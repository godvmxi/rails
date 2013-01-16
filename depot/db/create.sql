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