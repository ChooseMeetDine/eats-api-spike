-- sequences
CREATE SEQUENCE public.global_id_seq;

--     NUMBER SIZES:
--     4294967295 (2^32-1)
--     9007199254740992 (javascript 2^53)
--     1125899906842624 (2^50)
--     2147483647 (int postgres)
--     9223372036854775807 (bigint postgres)

-- creates a pseudo_encrypt-function that outputs 2^50-size-values (smaller than Javascripts max int)
CREATE OR REPLACE FUNCTION pseudo_encrypt50(VALUE bigint) returns bigint
 AS $$
DECLARE
  l1 bigint;
  l2 bigint;
  r1 bigint;
  r2 bigint;
  i int:=0;
  b25 int:=(1<<25)-1; -- 25 bits mask for a half-number => 50 bits total
BEGIN
  l1:= (VALUE >> (64-25)) & b25;
  r1:= VALUE & b25;
  WHILE i < 3 LOOP
    l2 := r1;
    r2 := l1 # (((((1366*r1+150889)%714025)/714025.0)*32767*32767)::int & b25);
    l1 := l2;
    r1 := r2;
    i := i + 1;
  END LOOP;
  RETURN ((l1::bigint << 25) + r1);
END;
$$ LANGUAGE plpgsql strict immutable;

-- tables
-- Table: category
CREATE TABLE public.category (
    id bigint  NOT NULL DEFAULT pseudo_encrypt50(nextval('public.global_id_seq')),
    type varchar(255)  NOT NULL,
    CONSTRAINT category_pk PRIMARY KEY (id)
);

-- Table: "group"
CREATE TABLE public."group" (
    id bigint  NOT NULL DEFAULT pseudo_encrypt50(nextval('public.global_id_seq')),
    creator int  NOT NULL,
    created timestamp  NOT NULL,
    name varchar(255)  NOT NULL,
    CONSTRAINT group_pk PRIMARY KEY (id)
);

-- Table: group_users
CREATE TABLE public.group_users (
    user_id int  NOT NULL,
    group_id int  NOT NULL,
    CONSTRAINT group_users_pk PRIMARY KEY (user_id,group_id)
);

-- Table: poll
CREATE TABLE public.poll (
    id bigint  NOT NULL DEFAULT pseudo_encrypt50(nextval('public.global_id_seq')),
    creator int  NOT NULL,
    name varchar(255)  NOT NULL,
    created timestamp  NOT NULL,
    expires timestamp  NOT NULL,
    nice_id varchar(255)  NOT NULL,
    "group" int  NULL,
    allow_new_restaurants boolean  NOT NULL default true,
    CONSTRAINT poll_pk PRIMARY KEY (id)
);

-- Table: poll_users
CREATE TABLE public.poll_users (
    "user" int  NOT NULL,
    poll int  NOT NULL,
    joined timestamp  NOT NULL,
    CONSTRAINT poll_users_pk PRIMARY KEY ("user",poll)
);

-- Table: rating
CREATE TABLE public.rating (
    id bigint  NOT NULL DEFAULT pseudo_encrypt50(nextval('public.global_id_seq')),
    rating smallint  NOT NULL,
    restaurant int  NOT NULL,
    rater int  NOT NULL,
    created timestamp  NOT NULL,
    CONSTRAINT rating_pk PRIMARY KEY (id)
);

-- Table: restaurant
CREATE TABLE public.restaurant (
    id bigint  NOT NULL DEFAULT pseudo_encrypt50(nextval('public.global_id_seq')),
    name varchar(255)  NOT NULL,
    lng decimal(53,50)  NULL,
    info text  NULL,
    photo varchar(1000)  NULL,
    number_votes int  NOT NULL DEFAULT 0,
    number_won_votes int  NOT NULL DEFAULT 0,
    creator int  NOT NULL,
    temporary boolean  NOT NULL,
    created timestamp  NOT NULL,
    price_rate int  NOT NULL,
    lat decimal(53,50)  NULL,
    CONSTRAINT restaurant_pk PRIMARY KEY (id)
);


-- Table: restaurant_categories
CREATE TABLE public.restaurant_categories (
    category_id int  NOT NULL,
    restaurant_id int  NOT NULL,
    CONSTRAINT restaurant_categories_pk PRIMARY KEY (category_id,restaurant_id)
);


-- Table: restaurant_polls
CREATE TABLE public.restaurant_polls (
    restaurant int  NOT NULL,
    poll int  NOT NULL,
    CONSTRAINT restaurant_polls_pk PRIMARY KEY (restaurant,poll)
);


-- Table: restaurant_update
CREATE TABLE public.restaurant_update (
    id bigint  NOT NULL DEFAULT pseudo_encrypt50(nextval('public.global_id_seq')),
    restaurant_id int  NOT NULL,
    user_id int  NOT NULL,
    name varchar(255)  NULL,
    lat decimal(53,50)  NULL,
    lng decimal(53,50)  NULL,
    reason text  NOT NULL,
    status varchar(255)  NULL,
    created timestamp  NOT NULL,
    status_changed timestamp  NOT NULL,
    CONSTRAINT restaurant_update_pk PRIMARY KEY (id)
);


-- Table: restaurant_update_categories
CREATE TABLE public.restaurant_update_categories (
    restaurant_update int  NOT NULL,
    category_id int  NOT NULL
);


-- Table: status
CREATE TABLE public.status (
    status varchar(255)  NOT NULL,
    CONSTRAINT status_pk PRIMARY KEY (status)
);


-- Table: "user"
CREATE TABLE public."user" (
    id bigint  NOT NULL DEFAULT pseudo_encrypt50(nextval('public.global_id_seq')),
    name varchar(255)  NOT NULL,
    email varchar(255)  NULL,
    photo varchar(1000)  NULL,
    password varchar(1000)  NOT NULL,
    last_login timestamp  NOT NULL,
    registration_date timestamp  NOT NULL,
    admin boolean  NOT NULL DEFAULT false,
    phone varchar(30)  NULL,
    anon boolean  NOT NULL DEFAULT false,
    CONSTRAINT user_pk PRIMARY KEY (id)
);

-- Table: vote
CREATE TABLE public.vote (
    id bigint  NOT NULL DEFAULT pseudo_encrypt50(nextval('public.global_id_seq')),
    user_id int  NOT NULL,
    poll_id int  NOT NULL,
    restaurant_id int  NOT NULL,
    created timestamp  NOT NULL,
    updated timestamp  NOT NULL,
    CONSTRAINT vote_pk PRIMARY KEY (id)
);


-- foreign keys
-- Reference:  Copy_of_restaurant_categories_category (table: restaurant_update_categories)

ALTER TABLE public.restaurant_update_categories ADD CONSTRAINT Copy_of_restaurant_categories_category
    FOREIGN KEY (category_id)
    REFERENCES public.category (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  Copy_of_restaurant_categories_restaurant_updates (table: restaurant_update_categories)

ALTER TABLE public.restaurant_update_categories ADD CONSTRAINT Copy_of_restaurant_categories_restaurant_updates
    FOREIGN KEY (restaurant_update)
    REFERENCES public.restaurant_update (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  category_map_category (table: restaurant_categories)

ALTER TABLE public.restaurant_categories ADD CONSTRAINT category_map_category
    FOREIGN KEY (category_id)
    REFERENCES public.category (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  category_map_restaurant (table: restaurant_categories)

ALTER TABLE public.restaurant_categories ADD CONSTRAINT category_map_restaurant
    FOREIGN KEY (restaurant_id)
    REFERENCES public.restaurant (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  group_user (table: "group")

ALTER TABLE public."group" ADD CONSTRAINT group_user
    FOREIGN KEY (creator)
    REFERENCES public."user" (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  group_users_group (table: group_users)

ALTER TABLE public.group_users ADD CONSTRAINT group_users_group
    FOREIGN KEY (group_id)
    REFERENCES public."group" (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  group_users_user (table: group_users)

ALTER TABLE public.group_users ADD CONSTRAINT group_users_user
    FOREIGN KEY (user_id)
    REFERENCES public."user" (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  poll_group (table: poll)

ALTER TABLE public.poll ADD CONSTRAINT poll_group
    FOREIGN KEY ("group")
    REFERENCES public."group" (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  poll_user (table: poll)

ALTER TABLE public.poll ADD CONSTRAINT poll_user
    FOREIGN KEY (creator)
    REFERENCES public."user" (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  poll_users_poll (table: poll_users)

ALTER TABLE public.poll_users ADD CONSTRAINT poll_users_poll
    FOREIGN KEY (poll)
    REFERENCES public.poll (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  poll_users_user (table: poll_users)

ALTER TABLE public.poll_users ADD CONSTRAINT poll_users_user
    FOREIGN KEY ("user")
    REFERENCES public."user" (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  rate_restaurant (table: rating)

ALTER TABLE public.rating ADD CONSTRAINT rate_restaurant
    FOREIGN KEY (restaurant)
    REFERENCES public.restaurant (id)
    ON DELETE  CASCADE
    ON UPDATE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  rate_user (table: rating)

ALTER TABLE public.rating ADD CONSTRAINT rate_user
    FOREIGN KEY (rater)
    REFERENCES public."user" (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  restaurant_polls_poll (table: restaurant_polls)

ALTER TABLE public.restaurant_polls ADD CONSTRAINT restaurant_polls_poll
    FOREIGN KEY (poll)
    REFERENCES public.poll (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  restaurant_polls_restaurant (table: restaurant_polls)

ALTER TABLE public.restaurant_polls ADD CONSTRAINT restaurant_polls_restaurant
    FOREIGN KEY (restaurant)
    REFERENCES public.restaurant (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  restaurant_updates_restaurant (table: restaurant_update)

ALTER TABLE public.restaurant_update ADD CONSTRAINT restaurant_updates_restaurant
    FOREIGN KEY (restaurant_id)
    REFERENCES public.restaurant (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  restaurant_updates_status (table: restaurant_update)

ALTER TABLE public.restaurant_update ADD CONSTRAINT restaurant_updates_status
    FOREIGN KEY (status)
    REFERENCES public.status (status)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  restaurant_updates_user (table: restaurant_update)

ALTER TABLE public.restaurant_update ADD CONSTRAINT restaurant_updates_user
    FOREIGN KEY (user_id)
    REFERENCES public."user" (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  restaurant_user (table: restaurant)

ALTER TABLE public.restaurant ADD CONSTRAINT restaurant_user
    FOREIGN KEY (creator)
    REFERENCES public."user" (id)
    ON DELETE  SET NULL
    ON UPDATE  SET NULL
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  vote_poll (table: vote)

ALTER TABLE public.vote ADD CONSTRAINT vote_poll
    FOREIGN KEY (poll_id)
    REFERENCES public.poll (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  vote_restaurant (table: vote)

ALTER TABLE public.vote ADD CONSTRAINT vote_restaurant
    FOREIGN KEY (restaurant_id)
    REFERENCES public.restaurant (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  vote_user (table: vote)

ALTER TABLE public.vote ADD CONSTRAINT vote_user
    FOREIGN KEY (user_id)
    REFERENCES public."user" (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;


-- Insert Users
INSERT INTO public."user" (id, name, email, password, last_login, registration_date, admin, phone)
VALUES(10, 'elias', 'elias@mail.se', 'password123', now(), now(), false, '0123-123'),
      (20, 'davve', 'davve@mail.se', 'password123', now(), now(), true, '0123-124'),
      (30, 'musse', 'musse@mail.se', 'password123', now(), now(), false, '0123-125'),
      (40, 'natti', 'natti@mail.se', 'password123', now(), now(), true, '0123-126');

INSERT INTO public.restaurant (id, name, lat, lng, creator, created, price_rate, temporary)
VALUES(11, 'Tusen och 22', 12.125123, 56.432432, 10, now(), 1, false),
      (21, 'Surf chakk', 12.133123, 56.432434, 30, now(), 2, false),
      (31, 'Kaffestället', 12.123623, 56.432232, 30, now(), 5, false),
      (41, 'Det där stället med bra mat!', 12.123121, 56.435432, 40, now(), 2, false),
      (51, 'Wiggos bar', 12.123121, 56.435432, 20, now(), 3, false);


INSERT INTO public.category (id, type)
VALUES(13, 'burgare'),
      (23, 'kaffe'),
      (33, 'god mat'),
      (43, 'thai'),
      (53, 'pizza');

INSERT INTO public.restaurant_categories (category_id, restaurant_id)
VALUES(13,11),
      (13,21),
      (23,31),
      (33,41),
      (43,51),
      (53,51);

INSERT INTO public."group" (id, creator, created, name)
VALUES(14, 10, now(), 'Grupp 1'),
      (24, 30, now(), 'Grupp 2');

INSERT INTO public.group_users (group_id, user_id)
VALUES(14, 10),
      (14, 20),
      (24, 20),
      (24, 30),
      (24, 40);

INSERT INTO public.poll (id, creator, name, created, expires, nice_id, "group", allow_new_restaurants)
VALUES(15, 10, 'Rösta på burgare, tack!', now(), now(), 'ABC123', null, false),
      (25, 30, 'Hungrig..', now(), now(), 'ABC321', 24, false);


INSERT INTO public.poll_users ("user", poll, joined)
VALUES(10, 15, now()),
      (20, 15, now()),
      (20, 25, now()),
      (30, 25, now()),
      (40, 25, now());


INSERT INTO public.rating (id, rating, restaurant, rater, created)
VALUES(16, 5,11,10,now()),
      (26, 1,41,20,now());

INSERT INTO public.restaurant_polls (restaurant, poll)
VALUES(11,15),
      (21,15),
      (41,25),
      (31,25);


INSERT INTO public.status (status)
VALUES('ACCEPTED'),
      ('DENIED'),
      ('PENDING');

INSERT INTO public.restaurant_update (id, restaurant_id, user_id, name, reason, status, created, status_changed)
VALUES(17, 11, 10, 'Tusen och 23', 'Ni har stavat fel', 'PENDING', now(), now()),
      (27, 21, 10, 'Turf Smack', 'Ni har stavat fel på denna också', 'PENDING', now(), now());


INSERT INTO public.restaurant_update_categories (restaurant_update, category_id)
VALUES(17, 33);

INSERT INTO public.vote (id, user_id, poll_id, restaurant_id, created, updated)
VALUES(18, 10,15,11,now(),now()),
      (28, 20,15,21,now(),now()),
      (38, 30,25,41,now(),now());

-- End of file.
