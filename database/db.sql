
-- tables
-- Table: category
CREATE TABLE category (
    id bigserial  NOT NULL,
    type varchar(255)  NOT NULL,
    CONSTRAINT category_pk PRIMARY KEY (id)
);

-- Table: "group"
CREATE TABLE "group" (
    id bigserial  NOT NULL,
    creator int  NOT NULL,
    created timestamp  NOT NULL,
    name varchar(255)  NOT NULL,
    CONSTRAINT group_pk PRIMARY KEY (id)
);

-- Table: group_users
CREATE TABLE group_users (
    user_id int  NOT NULL,
    group_id int  NOT NULL,
    CONSTRAINT group_users_pk PRIMARY KEY (user_id,group_id)
);

-- Table: poll
CREATE TABLE poll (
    id bigserial  NOT NULL,
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
CREATE TABLE poll_users (
    "user" int  NOT NULL,
    poll int  NOT NULL,
    joined timestamp  NOT NULL,
    CONSTRAINT poll_users_pk PRIMARY KEY ("user",poll)
);

-- Table: rating
CREATE TABLE rating (
    id bigserial  NOT NULL,
    rating smallint  NOT NULL,
    restaurant int  NOT NULL,
    rater int  NOT NULL,
    created timestamp  NOT NULL,
    CONSTRAINT rating_pk PRIMARY KEY (id)
);

-- Table: restaurant
CREATE TABLE restaurant (
    id bigserial  NOT NULL,
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
CREATE TABLE restaurant_categories (
    category_id int  NOT NULL,
    restaurant_id int  NOT NULL,
    CONSTRAINT restaurant_categories_pk PRIMARY KEY (category_id,restaurant_id)
);


-- Table: restaurant_polls
CREATE TABLE restaurant_polls (
    restaurant int  NOT NULL,
    poll int  NOT NULL,
    CONSTRAINT restaurant_polls_pk PRIMARY KEY (restaurant,poll)
);


-- Table: restaurant_update
CREATE TABLE restaurant_update (
    id bigserial  NOT NULL,
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
CREATE TABLE restaurant_update_categories (
    restaurant_update int  NOT NULL,
    category_id int  NOT NULL
);


-- Table: status
CREATE TABLE status (
    status varchar(255)  NOT NULL,
    CONSTRAINT status_pk PRIMARY KEY (status)
);


-- Table: "user"
CREATE TABLE "user" (
    id bigserial  NOT NULL,
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
CREATE TABLE vote (
    user_id int  NOT NULL,
    poll_id int  NOT NULL,
    restaurant_id int  NOT NULL,
    created timestamp  NOT NULL,
    updated timestamp  NOT NULL,
    CONSTRAINT vote_pk PRIMARY KEY (user_id,poll_id,restaurant_id)
);


-- foreign keys
-- Reference:  Copy_of_restaurant_categories_category (table: restaurant_update_categories)

ALTER TABLE restaurant_update_categories ADD CONSTRAINT Copy_of_restaurant_categories_category
    FOREIGN KEY (category_id)
    REFERENCES category (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  Copy_of_restaurant_categories_restaurant_updates (table: restaurant_update_categories)

ALTER TABLE restaurant_update_categories ADD CONSTRAINT Copy_of_restaurant_categories_restaurant_updates
    FOREIGN KEY (restaurant_update)
    REFERENCES restaurant_update (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  category_map_category (table: restaurant_categories)

ALTER TABLE restaurant_categories ADD CONSTRAINT category_map_category
    FOREIGN KEY (category_id)
    REFERENCES category (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  category_map_restaurant (table: restaurant_categories)

ALTER TABLE restaurant_categories ADD CONSTRAINT category_map_restaurant
    FOREIGN KEY (restaurant_id)
    REFERENCES restaurant (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  group_user (table: "group")

ALTER TABLE "group" ADD CONSTRAINT group_user
    FOREIGN KEY (creator)
    REFERENCES "user" (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  group_users_group (table: group_users)

ALTER TABLE group_users ADD CONSTRAINT group_users_group
    FOREIGN KEY (group_id)
    REFERENCES "group" (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  group_users_user (table: group_users)

ALTER TABLE group_users ADD CONSTRAINT group_users_user
    FOREIGN KEY (user_id)
    REFERENCES "user" (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  poll_group (table: poll)

ALTER TABLE poll ADD CONSTRAINT poll_group
    FOREIGN KEY ("group")
    REFERENCES "group" (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  poll_user (table: poll)

ALTER TABLE poll ADD CONSTRAINT poll_user
    FOREIGN KEY (creator)
    REFERENCES "user" (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  poll_users_poll (table: poll_users)

ALTER TABLE poll_users ADD CONSTRAINT poll_users_poll
    FOREIGN KEY (poll)
    REFERENCES poll (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  poll_users_user (table: poll_users)

ALTER TABLE poll_users ADD CONSTRAINT poll_users_user
    FOREIGN KEY ("user")
    REFERENCES "user" (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  rate_restaurant (table: rating)

ALTER TABLE rating ADD CONSTRAINT rate_restaurant
    FOREIGN KEY (restaurant)
    REFERENCES restaurant (id)
    ON DELETE  CASCADE
    ON UPDATE  CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  rate_user (table: rating)

ALTER TABLE rating ADD CONSTRAINT rate_user
    FOREIGN KEY (rater)
    REFERENCES "user" (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  restaurant_polls_poll (table: restaurant_polls)

ALTER TABLE restaurant_polls ADD CONSTRAINT restaurant_polls_poll
    FOREIGN KEY (poll)
    REFERENCES poll (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  restaurant_polls_restaurant (table: restaurant_polls)

ALTER TABLE restaurant_polls ADD CONSTRAINT restaurant_polls_restaurant
    FOREIGN KEY (restaurant)
    REFERENCES restaurant (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  restaurant_updates_restaurant (table: restaurant_update)

ALTER TABLE restaurant_update ADD CONSTRAINT restaurant_updates_restaurant
    FOREIGN KEY (restaurant_id)
    REFERENCES restaurant (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  restaurant_updates_status (table: restaurant_update)

ALTER TABLE restaurant_update ADD CONSTRAINT restaurant_updates_status
    FOREIGN KEY (status)
    REFERENCES status (status)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  restaurant_updates_user (table: restaurant_update)

ALTER TABLE restaurant_update ADD CONSTRAINT restaurant_updates_user
    FOREIGN KEY (user_id)
    REFERENCES "user" (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  restaurant_user (table: restaurant)

ALTER TABLE restaurant ADD CONSTRAINT restaurant_user
    FOREIGN KEY (creator)
    REFERENCES "user" (id)
    ON DELETE  SET NULL
    ON UPDATE  SET NULL
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  vote_poll (table: vote)

ALTER TABLE vote ADD CONSTRAINT vote_poll
    FOREIGN KEY (poll_id)
    REFERENCES poll (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  vote_restaurant (table: vote)

ALTER TABLE vote ADD CONSTRAINT vote_restaurant
    FOREIGN KEY (restaurant_id)
    REFERENCES restaurant (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference:  vote_user (table: vote)

ALTER TABLE vote ADD CONSTRAINT vote_user
    FOREIGN KEY (user_id)
    REFERENCES "user" (id)
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;


-- Insert Users
INSERT INTO "user" (name, email, password, last_login, registration_date, admin, phone)
VALUES('elias', 'elias@mail.se', 'password123', now(), now(), false, '0123-123'),
      ('davve', 'davve@mail.se', 'password123', now(), now(), true, '0123-124'),
      ('musse', 'musse@mail.se', 'password123', now(), now(), false, '0123-125'),
      ('natti', 'natti@mail.se', 'password123', now(), now(), true, '0123-126');

INSERT INTO restaurant (name, lat, lng, creator, created, price_rate, temporary)
VALUES('Tusen och 22', 12.125123, 56.432432, 1, now(), 1, false),
      ('Surf chakk', 12.133123, 56.432434, 3, now(), 2, false),
      ('Kaffestället', 12.123623, 56.432232, 3, now(), 5, false),
      ('Det där stället med bra mat!', 12.123121, 56.435432, 4, now(), 2, false),
      ('Wiggos bar', 12.123121, 56.435432, 2, now(), 3, false);


INSERT INTO category (type)
VALUES('burgare'),
      ('kaffe'),
      ('god mat'),
      ('thai'),
      ('pizza');

INSERT INTO restaurant_categories (category_id, restaurant_id)
VALUES(1,1),
      (1,2),
      (2,3),
      (3,4),
      (4,5),
      (5,5);

INSERT INTO "group" (creator, created, name)
VALUES(1, now(), 'Grupp 1'),
      (3, now(), 'Grupp 2');

INSERT INTO group_users (group_id, user_id)
VALUES(1, 1),
      (1, 2),
      (2, 2),
      (2, 3),
      (2, 4);

INSERT INTO poll (creator, name, created, expires, nice_id, "group", allow_new_restaurants)
VALUES(1, 'Rösta på burgare, tack!', now(), now(), 'ABC123', null, false),
      (3, 'Hungrig..', now(), now(), 'ABC321', 2, false);


INSERT INTO poll_users ("user", poll, joined)
VALUES(1, 1, now()),
      (2, 1, now()),
      (2, 2, now()),
      (3, 2, now()),
      (4, 2, now());


INSERT INTO rating (rating, restaurant, rater, created)
VALUES(5,1,1,now()),
      (1,4,2,now());

INSERT INTO restaurant_polls (restaurant, poll)
VALUES(1,1),
      (2,1),
      (4,2),
      (3,2);


INSERT INTO status (status)
VALUES('ACCEPTED'),
      ('DENIED'),
      ('PENDING');

INSERT INTO restaurant_update (restaurant_id, user_id, name, reason, status, created, status_changed)
VALUES(1, 1, 'Tusen och 23', 'Ni har stavat fel', 'PENDING', now(), now()),
      (2, 1, 'Turf Smack', 'Ni har stavat fel på denna också', 'PENDING', now(), now());


INSERT INTO restaurant_update_categories (restaurant_update, category_id)
VALUES(1, 3);

INSERT INTO vote (user_id, poll_id, restaurant_id, created, updated)
VALUES(1,1,1,now(),now()),
      (2,1,2,now(),now()),
      (3,2,4,now(),now());

-- End of file.
