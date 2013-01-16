require File.dirname(__FILE__) + '/../test_helper'

class ConfigurationTest < Test::Unit::TestCase
  fixtures :settings

  def setup
    config.reload
  end

  def test_reload
    Setting.create("name" => "test", "value" => "test")
    assert_nil config['test']
    config.reload
    assert_equal "test", config['test']
  end
  
  def test_fields
    assert_equal ["blog_name",
     "blog_subtitle",
     "comment_text_filter",
     "default_allow_comments",
     "default_allow_pings",
     "geourl_location",
     "limit_article_display",
     "limit_rss_display",
     "link_to_author",
     "sp_article_auto_close",
     "sp_global",
     "sp_url_limit",
     "text_filter",
     "theme"], Configuration.fields.keys.sort 
  end
  
  def test_booleans
    assert_equal true, config[:sp_global]
    assert_equal true, config[:default_allow_comments]
    assert_equal false, config[:default_allow_pings]
    
    assert TrueClass === config[:sp_global]
    assert String === config[:blog_name]
    assert Fixnum === config[:limit_rss_display]
  end
  
  def test_is_ok
    assert config.is_ok?  
  end
  
end