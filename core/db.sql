CREATE TABLE IF NOT EXISTS user (
    id INT PRIMARY KEY,
    pos VARCHAR(255),
    u_name VARCHAR(255),
    pass VARCHAR(255),
    name VARCHAR(255),
    note VARCHAR(255),
    tel VARCHAR(255),
    adrs VARCHAR(255),
    nic VARCHAR(255),
    act VARCHAR(255),
    dob DATE
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
