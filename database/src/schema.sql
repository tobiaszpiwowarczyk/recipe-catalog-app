/*
 * Plik zawierający konfigurację tworzenia tabel do bazy danych 
 * zawierającej dane przepisów kulinarnych
 *
 * Autor: Tobiasz Piwowarczyk
 * Grupa: Z610
 * 
 */


DO
$do$
begin
    if not exists(SELECT datname FROM pg_catalog.pg_database where datname = 'recipe_catalog_app')
    then
        create database recipe_catalog_app;
    end if;
end
$do$;

\c recipe_catalog_app;





create table if not exists users_roles
(
      id                  serial not null primary key
    , name                varchar(30) not null unique
);



create table if not exists users
(
      id                  serial not null primary key
    , role_id             int not null references users_roles(id)
    , username            varchar(20) not null unique
    , password            varchar(30) not null
    , first_name          varchar(20) not null
    , last_name           varchar(30) not null
    , email_address       varchar(30) not null
    , created_date        date not null default now()
);



create table if not exists recipe_catalog
(
      id                  serial not null primary key
    , name                varchar(100) not null unique
    , image_name          varchar(100) not null unique
);



create table if not exists recipe
(
      id                  serial not null primary key
    , user_id             int not null references users(id)
    , catalog_id          int not null references recipe_catalog(id)
    , folder_name         varchar(100) not null unique
    , created_date        date not null default now()
    , level_of_difficulty int not null default 1 check (level_of_difficulty between 1 and 5)
    , creation_time       int not null check(creation_time > 0)
);



create table if not exists recipe_rating
(
      id                  serial not null primary key
    , recipe_id           int not null references recipe(id)
    , user_id             int not null references users(id)
    , value               int not null check(value between 1 and 5)
    , created_date        date not null default now()
);



create table if not exists recipe_comment
(
      id                  serial not null primary key
    , recipe_id           int not null references recipe(id)
    , user_id             int not null references users(id)
    , content             varchar(1000) not null
    , likes               int not null default 0 check(likes >= 0)
    , dislikes            int not null default 0 check(dislikes >= 0)
    , created_date        date not null default now()
);


create table if not exists ingredients
(
      id                  serial not null primary key
    , name                varchar(100) not null UNIQUE
    , image_path          varchar(200) not null
);


create table if not exists recipe_ingredient_unit
(
      id                  serial not null primary key
    , name                varchar(100) not null unique
);


create table if not exists recipe_ingredient
(
      id                  serial not null primary key
    , recipe_id           int not null references recipe(id)
    , ingredient_id       int not null references ingredients(id)
    , unit_id             int not null references recipe_ingredient_unit(id)
    , ammount             int not null default 1
    , unique(recipe_id, ingredient_id, unit_id)
);





/*
 * Wstawianie rekordów
 */


insert into users_roles
    (name)
values
    ('Użytkownik'),
    ('Moderator'),
    ('Administrator')
;

insert into recipe_ingredient_unit
    (name)
values
    ('kg'),
    ('g'),
    ('l'),
    ('ml'),
    ('łyżka'),
    ('szklanka'),
    ('szczypta')
;