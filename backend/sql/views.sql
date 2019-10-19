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
