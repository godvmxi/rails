drop table if exists products;
create table products (
id int not null auto_increment,
title varchar(100) not null,
description text not null,
image_url varchar(200) not null,
price decimal(10,2) not null,
date_available datetime not null,
primary key (id)
);



drop table if exists line_items;
create table line_items (
id int not null auto_increment,
product_id int not null,
quantity int not null default 0,
unit_price decimal(10,2) not null,
constraint fk_items_product foreign key (product_id) references products(id),
primary key (id)
);

//lesson 11
在数据库里创建Order表，创建表的Sql如下：

create table orders (
id int not null auto_increment,
name varchar(100) not null,
email varchar(255) not null,
address text not null,
pay_type char(10) not null,
primary key (id)
);


重新创建line_item表，下面是Sql：
drop table if exists line_items;
create table line_items (
id int not null auto_increment,
product_id int not null,
order_id int not null,
quantity int not null default 0,
unit_price decimal(10,2) not null,
constraint fk_items_product foreign key (product_id) references products(id),
constraint fk_items_order foreign key (order_id) references orders(id),
primary key (id)
);

//lesson 14
drop table if exists orders;
create table orders (
id int not null auto_increment,
name varchar(100) not null,
email varchar(255) not null,
address text not null,
pay_type char(10) not null,
shipped_at datetime null,
primary key (id)
);