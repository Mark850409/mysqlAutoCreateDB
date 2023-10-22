CREATE DATABASE IF NOT EXISTS `stock` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `stock`;
DROP PROCEDURE IF EXISTS stock.CreateStockTable; 
DELIMITER //

CREATE PROCEDURE CreateStockTable()
BEGIN
DROP TABLE IF EXISTS stock_daily;
CREATE TABLE IF NOT EXISTS stock_daily
(sdate	varchar(10),
id	varchar(10),
sname varchar(255),
trs_qty decimal(18,0), trs_count decimal(18,0), trs_amt decimal(18,0), open_price decimal(18,2), h_price     decimal(18,2),
l_price	decimal(18,2), close_price decimal(18,2), s_status	varchar(255), dec_price	decimal(18,2), lb_price	decimal(18,2), lb_amt	decimal(18,2), ls_price	decimal(18,2), ls_amt	decimal(18,2),
PE	decimal(18,2));

DROP TABLE IF EXISTS stock_list;
CREATE TABLE IF NOT EXISTS stock_list
(id varchar (10),
sname varchar (255),
stock_attr varchar (255),
industry varchar (255),
CONSTRAINT PK_stock_list PRIMARY KEY (id) );

DROP TABLE IF EXISTS stock_daily;
CREATE TABLE IF NOT EXISTS stock_daily
(
sdate varchar(10),
id varchar (10),
sname varchar (255),
trs_qty decimal (18,0),
trs_count decimal (18,0),
trs_amt decimal (18,0),
open_price decimal (18,2),
h_price decimal (18,2),
l_price decimal (18,2),
close_price decimal (18,2),
s_status varchar (255),
dec_price decimal (18,2),
lb_price decimal (18,2),
lb_amt decimal (18,2),
ls_price decimal (18,2),
ls_amt decimal (18,2),
PE decimal (18,2),
CONSTRAINT PK_stock_daily PRIMARY KEY (id,sdate));

DROP TABLE IF EXISTS stock_monthly_revenue;
CREATE TABLE IF NOT EXISTS stock_monthly_revenue
(
yyyymm varchar(6),
id varchar (10),
sname varchar (255),
month_amt decimal (18,0),
pre_m_amt decimal (18,0),
pre_y_amt decimal (18,0),
pre_m_percent decimal (18,2),
pre_y_percent decimal (18,2),
sum_amt decimal (18,0),
per_sum_amt decimal (18,0),
sum_percent decimal (18,2),
memo_str varchar (255),
CONSTRAINT PK_stock_monthly_revenue PRIMARY KEY (id,yyyymm));

DROP TABLE IF EXISTS stock_daily_3;
CREATE TABLE IF NOT EXISTS stock_daily_3
(
sdate varchar(10),
id varchar(10),
f_qty decimal(18,0),
i_qty decimal(18,0),
s_qty decimal(18,0),
t_qty decimal(18,0),
est_f_qty decimal(18,0),
est_i_qty decimal(18,0),
est_s_qty decimal(18,0),
est_t_qty decimal(18,0),
trs_f_percent decimal(18,2),
trs_3_percent decimal(18,2),
CONSTRAINT PK_stock_daily_3 PRIMARY KEY(id,sdate));

DROP TABLE IF EXISTS stock_daily_MT;
CREATE TABLE IF NOT EXISTS stock_daily_MT
(
sdate varchar(10),
id varchar (10),
mt_b_qty decimal (18,0),
mt_s_qty decimal (18,0),
mt_r_qty decimal (18,0),
mt_qty decimal (18,0),
mt_dec_qty decimal (18,0),
mt_limit_qty decimal (18,0),
mt_use_percent decimal (18,2),
ss_b_qty decimal (18,0),
ss_s_qt decimal (18,0),
ss_r_qty decimal (18,0),
ss_qty decimal (18,0),
ss_dec_qty decimal(18,0),
ms_percent decimal(18,2),
ms_dec_qty decimal(18,0),
CONSTRAINT PK_stock_daily_MT PRIMARY KEY (id,sdate));

DROP TABLE IF EXISTS stock_daily_MR;
CREATE TABLE IF NOT EXISTS stock_daily_MR
(
sdate varchar (10),
id varchar (50),
id_sub varchar(50),
id_mr varchar(50),
mrname varchar(255),
b_qty decimal(18,0),
s_qty decimal(18,0),
dec_qty decimal(18,0),
dstatus int ,
trs_percent decimal(18,2),
CONSTRAINT PK_stock_daily_MR PRIMARY KEY(id,sdate));

END //
DELIMITER ;
CALL `stock`.`CreateStockTable`();