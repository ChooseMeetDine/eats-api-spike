// -- SELECT * som JSON
// Här får man ut alla rader och kolumner från tabellen user som JSON
// Hämtat härifrån: https://hashrocket.com/blog/posts/faster-json-generation-with-postgresql
SELECT row_to_json("user") FROM "user";

// -- SELECT * men bara vissa kolumner som JSON
// .. måste göra en intern FROM/SELECT för att inte få "f1", "f2" osv. som nycklar i json-svaret
SELECT row_to_json(t)
FROM (
  SELECT id, name FROM "user"
)t

// -- SELECT ett specifikt ID och bara vissa kolumner som JSON
// .. måste göra en subquery med FROM/SELECT för att inte få "f1", "f2" osv. som nycklar i json-svaret
SELECT row_to_json(t)
FROM (
  SELECT email, name FROM "user" WHERE id=1
)t

// -- Få ut det man precis INSERTAT som JSON --
// Här läggs alltså en användare till med INSERT INTO och VALUES()
// .. med keywordet RETURNING kan man få ut samma rad man precis la till
// och genom att använda row_to_json()-funktionen kan denna rad direkt göras om till JSON.
INSERT INTO "user" (name, email, password, last_login,  registration_date,  admin, phone)
VALUES('david', 'david@asdfasdf.com', 'davidspass', now(), now(), false, '23040')
RETURNING row_to_json("user");

// Har ännu inte hittat hur man kan få ut specifika kolumner som JSON efter INSERT
// .. tekniken med subqueries ovan funkar inte här..

// -- Få ut allt man precis INSERTAT som ICKE-json
INSERT INTO "user" (name, email, password, last_login,  registration_date,  admin, phone)
VALUES('david', 'david@asdfasdf.com', 'davidspass', now(), now(), false, '23040')
RETURNING *;

// -- Få ut det man precis INSERTAT som ICKE-json, men bara specifika kolumner
INSERT INTO "user" (name, email, password, last_login,  registration_date,  admin, phone)
VALUES('david', 'david@asdfasdf.com', 'davidspass', now(), now(), false, '23040')
RETURNING id, name;
