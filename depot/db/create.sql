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