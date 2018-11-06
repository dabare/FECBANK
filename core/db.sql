CREATE TABLE IF NOT EXISTS user (
    id INT PRIMARY KEY,
    userType_id INT,
    status VARCHAR(255),
    email VARCHAR(255),
    pass VARCHAR(255),
    name VARCHAR(255),
    note VARCHAR(255),
    tel VARCHAR(255),
    adrs VARCHAR(255),
    nic VARCHAR(255),
    act VARCHAR(255),
    dob DATE
);

CREATE TABLE IF NOT EXISTS userType (
    id INT PRIMARY KEY,
    typ VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS deposit (
    id INT PRIMARY KEY,
    dte DATE,
    user_id INT,
    fec_id  INT,
    amount  INT,
    interest    INT,
    updated_id  INT
);


CREATE TABLE IF NOT EXISTS account (
    id INT PRIMARY KEY,
    u_id INT,
    note VARCHAR(255),
    dte DATE
);

CREATE TABLE IF NOT EXISTS saving (
    id INT PRIMARY KEY,
    a_id INT,
    amt INT,
    note VARCHAR(255),
    dte DATE
);

CREATE TABLE IF NOT EXISTS loan (
    id INT PRIMARY KEY,
    u_id INT,
    amt INT,
    purps VARCHAR(255),
    note VARCHAR(255),
    dte DATE
);

CREATE TABLE IF NOT EXISTS installment (
    id INT PRIMARY KEY,
    l_id INT,
    amt INT,
    note VARCHAR(255),
    dte DATE
);

CREATE TABLE IF NOT EXISTS bank (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    tel VARCHAR(255),
    adrs VARCHAR(255),
    note VARCHAR(255),
    dte DATE
);

CREATE TABLE IF NOT EXISTS invesment (
    id INT PRIMARY KEY,
    b_id INT,
    amt INT,
    rate INT,
    strtng DATE,
    endng DATE,
    name VARCHAR(255),
    note VARCHAR(255)
);

SELECT user.*, userType.typ FROM user LEFT JOIN userType ON user.userType_id = userType.id;


SELECT userType.id, userType.typ, tmp2.count FROM
	(SELECT COUNT(id) AS count, userType_id FROM (
		SELECT user.id, userType.id AS userType_id, userType.typ FROM user
		LEFT JOIN userType ON user.userType_id = userType.id
		UNION
		SELECT user.id, userType.id AS userType_id, userType.typ FROM user
		RIGHT JOIN userType ON user.userType_id = userType.id
		) AS tmp
	GROUP BY userType_id) AS tmp2
LEFT JOIN userType
ON userType.id = tmp2.userType_id;

SELECT user.id, user.name FROM user LEFT JOIN userType ON user.userType_id = userType.id WHERE userType.typ!='Customer';

SELECT tmp1.*, user.name AS updated
FROM
    (SELECT tmp.* , user.name AS fec
    FROM
        (SELECT deposit.*, user.name AS user FROM deposit
        LEFT JOIN user
        ON deposit.user_id=user.id) AS tmp
    LEFT JOIN user
    ON tmp.fec_id=user.id) as tmp1
LEFT JOIN user
ON tmp1.updated_id=user.id

SELECT COUNT(id) FROM deposit WHERE user_id=1 OR fec_id=1 OR updated_id=1;