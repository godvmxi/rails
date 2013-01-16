class ArticlesController < ApplicationController
  before_filter :verify_config
  before_filter :ignore_page_query_param
  layout :theme_layout

  cache_sweeper :blog_sweeper
  caches_page :index, :read, :permalink, :category, :find_by_date, :archives, :view_page

  verify :only => [:nuke_comment, :nuke_trackback], :session => :user, :method => :post, :render => { :text => 'Forbidden', :status => 403 }
    
  def index
    @pages = Paginator.new self, Article.count, config[:limit_article_display], @params[:page]
    @articles = Article.find(:all, :conditions => 'published != 0', :order => 'created_at DESC', :limit => config[:limit_article_display], :offset => @pages.current.offset)
  end
  
  def search
    @articles = Article.search(params[:q])
  end

  def archives
    @articles = Article.find(:all, :conditions => 'published != 0', :order => 'created_at DESC', :include => [:categories])
  end
  
  def read    
    @article      = Article.find(params[:id], :include => [:categories])    
    @comment      = Comment.new
    @page_title   = @article.title
  end
    
  def permalink
    @article    = Article.find_by_permalink(params[:year], params[:month], params[:day], params[:title])
    @comment    = Comment.new
    
    if @article.nil?
      error("Post not found...")
    else
      @page_title = @article.title
      render :action => "read"
  	end
  end
  
  def find_by_date
    @articles = Article.find_all_by_date(params[:year], params[:month], params[:day])
    @pages = Paginator.new self, @articles.size, config[:limit_article_display], @params[:page]

    if @articles.empty?
      error("No posts found...")
    else
      start = @pages.current.offset
      stop  = (@pages.current.next.offset - 1) rescue @articles.size
      @articles = @articles.slice(start..stop)

      render :action => "index"              
    end
  end  
  
  def error(message = "Record not found...")
    @message = message
    render :action => "error"
  end
  
  def category
    if category = Category.find_by_permalink(params[:id])
      @articles = Article.find(:all, :conditions => [%{ published != 0
          AND articles.id = articles_categories.article_id
          AND articles_categories.category_id = ? }, category.id],
        :joins => ', articles_categories',
        :order => "created_at DESC")
      
      @pages = Paginator.new self, @articles.size, config[:limit_article_display], @params[:page]

      start = @pages.current.offset
      stop  = (@pages.current.next.offset - 1) rescue @articles.size
      # Why won't this work? @articles.slice!(start..stop)
      @articles = @articles.slice(start..stop)

      render :action => "index"
    else
      error("Can't find posts in category #{params[:id]}")
    end
  end
    
  # Receive comments to articles
  def comment 
    @article = Article.find(params[:id])    
    @comment = Comment.new(params[:comment])
    @comment.article = @article
    @comment.ip = request.remote_ip

    if request.post? and @comment.save      
      @comment.body = ""
      
      cookies[:author]  = { :value => @comment.author, :path => '/' + controller_name, :expires => 6.weeks.from_now } 
      cookies[:url]     = { :value => @comment.url, :path => '/' + controller_name, :expires => 6.weeks.from_now } 

      @headers["Content-Type"] = "text/html; charset=utf-8"
      
      render :partial => "comment", :object => @comment
    else
      render :text => @comment.errors.full_messages.join(", "), :status => 500
    end
  end  

  # Receive trackbacks linked to articles
  def trackback
    @result = true
    
    if params[:__mode] == "rss"
      # Part of the trackback spec... will implement later
    else
      # url is required
      unless params.has_key?(:url) and params.has_key?(:id)
        @result = false
        @error_message = "A URL is required."
      else
        begin
          article = Article.find(params[:id])
          tb = article.build_to_trackbacks
          tb.url       = params[:url]
          tb.title     = params[:title] || params[:url]
          tb.excerpt   = params[:excerpt]
          tb.blog_name = params[:blog_name]
          tb.ip        = request.remote_ip
          unless article.save
            @result = false
            @error_message = "Trackback not saved.  Database problem most likely."
          end
        rescue ActiveRecord::RecordNotFound, ActiveRecord::StatementInvalid
          @result = false
          @error_message = "Article id #{params[:id]} not found."
        end
      end
    end
    render :layout => false
  end
  
  def nuke_comment
    if(session[:user])
      comment = Comment.find(params[:id])
      comment.destroy 
      render :nothing => true 
    end
  end

  def nuke_trackback
    if(session[:user])
      trackback = Trackback.find(params[:id])
      trackback.destroy 
      render :nothing => true 
    end
  end

  def view_page
    if(@page = Page.find_by_name(params[:name].to_a.join('/')))
      @page_title = @page.title
      render
    else
      render :nothing => true, :status => 404
    end
  end
  
  private

    def ignore_page_query_param
      @params[:page] = nil unless @request.path =~ /\/page\// # assumes all page routes use /page/:page
    end

    def verify_config
      if User.count == 0
        redirect_to :controller => "accounts", :action => "signup"
      elsif !config.is_ok?
        redirect_to :controller => "admin/general", :action => "index"
      else
        return true
      end
    end
    
    def rescue_action_in_public(exception)
      error(exception.message)
    end

end
