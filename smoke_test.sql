CREATE TABLE smoke_test (
    id SERIAL PRIMARY KEY,
    msg_data TEXT
);

INSERT INTO smoke_test (msg_data)
VALUES ('test data');

SELECT * FROM smoke_test;