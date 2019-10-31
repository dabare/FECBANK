USE `fecbank`;
CREATE VIEW member_saving_ledger AS
select `member_saving`.`id` AS `id`,
`member_saving`.`member_id` AS `member_id`,
`member_saving`.`req_date` AS `req_date`,
`member_saving`.`amount` AS `amount`,
`member_saving`.`req_user` AS `req_user`,
`member_saving`.`note` AS `note`,
`member_saving`.`status` AS `status`,
'DEPOSIT' AS `trx_type`
from `member_saving`
union
select `member_withdraw`.`id` AS `id`,
`member_withdraw`.`member_id` AS `member_id`,
`member_withdraw`.`req_date` AS `req_date`,
`member_withdraw`.`amount` AS `amount`,
`member_withdraw`.`req_user` AS `req_user`,
`member_withdraw`.`note` AS `note`,
`member_withdraw`.`status` AS `status`,
'WITHDRAWAL' AS `trx_type`
from `member_withdraw`
order by `req_date` desc;

CREATE VIEW member_saving_history AS
select `member_saving_ledger`.`member_id` AS `member_id`,
`member_saving_ledger`.`note` AS `description`,
`member_saving_ledger`.`amount` AS `value`,
`member_saving_ledger`.`req_date` AS `req_date`,
`member_saving_ledger`.`trx_type` AS `trx_type`,
`member_saving_ledger`.`id` AS `id`
from `member_saving_ledger`
where (`member_saving_ledger`.`status` = 1)
union
select -(1) AS `member_id`,
`member_saving_rate`.`description` AS `description`,
`member_saving_rate`.`rate` AS `value`,
`member_saving_rate`.`req_date` AS `req_date`,
'RATE' AS `trx_type`,
-(1) AS `id`
from `member_saving_rate`
where (`member_saving_rate`.`status` = 1)
order by `req_date`;


CREATE VIEW member_saving_total AS
SELECT "member_saving_total" AS `type`, (s.amount -  w.amount) AS amount FROM
(SELECT coalesce(SUM(amount),0) AS amount FROM member_saving WHERE `status` = 1)  s,
(SELECT coalesce(SUM(amount),0) AS amount FROM member_withdraw WHERE `status` = 1)  w;

CREATE VIEW bank_book_total AS
SELECT "bank_book_total" AS `type`, (s.amount -  w.amount) AS amount FROM
(SELECT coalesce(SUM(amount),0) AS amount FROM bank_book_ledger WHERE `status` = 7)  s,
(SELECT coalesce(SUM(amount),0) AS amount FROM bank_book_ledger WHERE `status` = 9)  w;

CREATE VIEW member_loan_total AS
SELECT "member_loan_total" AS `type`, (l.amount -  d.amount) AS amount FROM
(SELECT coalesce(SUM(amount),0) AS amount FROM member_loan WHERE `status` = 1) l,
(SELECT coalesce(SUM(amount),0) AS amount FROM member_loan_deposit WHERE `status` = 1) d;

CREATE VIEW member_savings_top_5 AS
SELECT tt.member_id, tt.amount, member.name FROM
(SELECT t.member_id, coalesce(SUM(t.amount),0) AS amount
FROM
(select
`member_id`,
`amount`
from `member_saving`  WHERE `member_saving`.`status` = 1
union
select
`member_id`,
(-1 * amount) AS `amount`
from `member_withdraw` WHERE `member_withdraw`.`status` = 1) t
GROUP BY t.member_id ORDER BY amount DESC LIMIT 5) tt
LEFT JOIN member ON member.id = tt.member_id;

CREATE VIEW member_count AS
SELECT "member_count" AS `type`, coalesce(COUNT(id),0) as `amount` FROM member WHERE `status` = 1;

CREATE VIEW `statistics` AS
SELECT * FROM bank_book_total
UNION
SELECT * FROM member_loan_total
UNION
SELECT * FROM member_count
UNION
SELECT * FROM member_saving_total;
