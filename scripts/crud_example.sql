CREATE DATABASE image_store;

CREATE TABLE images (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    data BYTEA
);

INSERT INTO images (name, data)
VALUES ('example.png', pg_read_binary_file('/tmp/ahmed/harry_kane.png'));

SELECT * FROM images;

UPDATE images
SET name = 'new_example.png'
WHERE name = 'example.png';

SELECT * FROM images;

DELETE FROM images
WHERE id = 2;

