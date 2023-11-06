-- ====================================================================
-- Function    : 報告內容有指令建立資料集，不可使用資料庫管理工具，需
-- 產出ERD圖形(以下三種指令都要呈現)
-- Create Date : 2023-11-06
-- Modify His  : 
-- 1.CREATE TABLE
-- 2.PRIMARY KEY
-- 3.FOREIGN KEY
-- Final:
-- 以下這端指令完成後，請至dbeaver產出ER關聯圖並截圖
-- ===================================================================

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE if exists stock_list;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE IF NOT EXISTS stock_list
		(
			id varchar(10),
			sname varchar(255),
			stock_attr varchar(255),
			industry varchar(255),
			CONSTRAINT PK_stock_list
				PRIMARY KEY (id)
);
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE if exists stock_daily;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE IF NOT EXISTS stock_daily(
   sdate        varchar(10),
   id           varchar(10), 
   sname        varchar(255), 
   trs_qty      decimal(18,0), 
   trs_count    decimal(18,0), 
   trs_amt      decimal(18,0), 
   open_price   decimal(18,2),
   h_price      decimal(18,2),
   l_price      decimal(18,2),
   close_price  decimal(18,2),
   s_status     varchar(255), 
   dec_price    decimal(18,2),
   lb_price     decimal(18,2),
   lb_amt       decimal(18,2),
   ls_price     decimal(18,2),
   ls_amt       decimal(18,2),
   PE           decimal(18,2),
   CONSTRAINT PK_stock_daily PRIMARY KEY (id,sdate),
   CONSTRAINT FK_stock_list FOREIGN KEY (id) REFERENCES stock_list(id) ON UPDATE cascade
   );

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE if exists stock_daily_3;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE IF NOT EXISTS stock_daily_3
	(
			sdate varchar(10),
			id varchar(10),
			f_qty decimal(18, 0),
			i_qty decimal(18, 0),
			s_qty decimal(18, 0),
			t_qty decimal(18, 0),
			est_f_qty decimal(18, 0),
			est_i_qty decimal(18, 0),
			est_s_qty decimal(18, 0),
			est_t_qty decimal(18, 0),
			trs_f_percent decimal(18, 2),
			trs_3_percent decimal(18, 2),
			CONSTRAINT PK_stock_daily_3
				PRIMARY KEY
				(
					id,
					sdate
				),
			CONSTRAINT FK_stock_daily2 FOREIGN KEY (id, sdate) REFERENCES stock_daily(id, sdate),
   			CONSTRAINT FK_stock_list2 FOREIGN KEY (id) REFERENCES stock_list(id) ON UPDATE cascade
	);
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE if exists stock_daily_MT;
SET FOREIGN_KEY_CHECKS=1;
		CREATE TABLE IF NOT EXISTS stock_daily_MT
		(
			sdate varchar(10),
			id varchar(10),
			mt_b_qty decimal(18, 0),
			mt_s_qty decimal(18, 0),
			mt_r_qty decimal(18, 0),
			mt_qty decimal(18, 0),
			mt_dec_qty decimal(18, 0),
			mt_limit_qty decimal(18, 0),
			mt_use_percent decimal(18, 2),
			ss_b_qty decimal(18, 0),
			ss_s_qt decimal(18, 0),
			ss_r_qty decimal(18, 0),
			ss_qty decimal(18, 0),
			ss_dec_qty decimal(18, 0),
			ms_percent decimal(18, 2),
			ms_dec_qty decimal(18, 0),
			CONSTRAINT PK_stock_daily_MT
				PRIMARY KEY
				(
					id,
					sdate
				),
				CONSTRAINT FK_stock_daily3 FOREIGN KEY (id, sdate) REFERENCES stock_daily(id, sdate),
				CONSTRAINT FK_stock_list3 FOREIGN KEY (id) REFERENCES stock_list(id) ON UPDATE CASCADE
		);
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE if exists stock_daily_MR;
SET FOREIGN_KEY_CHECKS=1;
		CREATE TABLE IF NOT EXISTS stock_daily_MR
		(
			sdate varchar(10),
			id varchar(50),
			id_sub varchar(50),
			id_mr varchar(50),
			mrname varchar(255),
			b_qty decimal(18, 0),
			s_qty decimal(18, 0),
			dec_qty decimal(18, 0),
			dstatus int,
			trs_percent decimal(18, 2),
			CONSTRAINT PK_stock_daily_MR
				PRIMARY KEY
				(
					id,
					sdate
				),
				CONSTRAINT FK_stock_daily4 FOREIGN KEY (id, sdate) REFERENCES stock_daily(id, sdate),
			CONSTRAINT FK_stock_list4 FOREIGN KEY (id) REFERENCES stock_list(id) ON UPDATE CASCADE
		);
	
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE if exists stock_monthly_revenue;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE IF NOT EXISTS stock_monthly_revenue
(
			yyyymm varchar(6),
			id varchar(10),
			sname varchar(255),
			month_amt decimal(18, 0),
			pre_m_amt decimal(18, 0),
			pre_y_amt decimal(18, 0),
			pre_m_percent decimal(18, 2),
			pre_y_percent decimal(18, 2),
			sum_amt decimal(18, 0),
			per_sum_amt decimal(18, 0),
			sum_percent decimal(18, 2),
			memo_str varchar(255),
			CONSTRAINT PK_stock_monthly_revenue
				PRIMARY KEY
				(
					id,
					yyyymm
				),
			CONSTRAINT FK_stock_list5 FOREIGN KEY (id) REFERENCES stock_list(id) ON UPDATE CASCADE
);

-- ====================================================================
-- Function    : 報告中需使用指令建置
-- Create Date : 2023-11-06
-- Modify His  : 
-- 1.修訂資料集欄位
-- 2.建立索引與移除索引
-- 3.建立/修改/刪除資料
-- 4.alter table、create index / drop index、insert into / update / delete、drop table(這指令只要示意即可)
-- 以下這端指令完成後，請至dbeaver截圖(請分段執行，7段語法各執行一次會有7個結果)
-- ===================================================================

-- 在stock_daily移除stock_daily_new_column欄位
ALTER TABLE stock.stock_daily DROP COLUMN stock_daily_new_column;

-- 在stock_daily新增stock_daily_new_column欄位
ALTER TABLE stock.stock_daily ADD stock_daily_new_column varchar(100) NULL;

-- 在stock_daily新增stock_daily_id_IDX索引，欄位使用id、sdate
CREATE INDEX stock_daily_id_IDX USING BTREE ON stock.stock_daily (id,sdate);

-- 在stock_daily移除stock_daily_id_IDX索引
DROP INDEX stock_daily_id_IDX ON stock.stock_daily;

-- 在stock_daily新增一筆資料
INSERT INTO stock.stock_daily
(sdate, id, sname, trs_qty, trs_count, trs_amt, open_price, h_price, l_price, close_price, s_status, dec_price, lb_price, lb_amt, ls_price, ls_amt, PE)
VALUES('20231023', '0050', '元大台灣50', 8728531, 17221, 1081610006, 124.85, 124.85, 123.55, 123.85, '<p style= color:green>-</p>', 1.55, 123.80, 13.00, 123.85, 10.00, 0.00);

-- 在stock_daily修改一筆資料(更改交易日期)
UPDATE stock.stock_daily
SET sdate='20231106'
WHERE id='0050' and sdate='20231106';

-- 在stock_daily移除一筆資料
DELETE FROM stock.stock_daily
WHERE id='0050' and sdate='20231106';

-- 移除stock_daily資料表，示意即可，因此這行註解
-- drop table stock.stock_daily;

-- ====================================================================
-- Function    : 資料自己創造，不需要太多資料筆數
-- Create Date : 2023-11-06
-- 以下這端指令完成後，請至dbeaver截圖(請分段執行，共兩個結果)
-- ===================================================================

-- 做update案例之前，請先執行以下兩段Inser Into語法
INSERT INTO stock_list (id,sname,stock_attr,industry) VALUES
	 ('1101','台泥','上市','水泥工業'),
	 ('1102','亞泥','上市','水泥工業'),
	 ('1103','嘉泥','上市','水泥工業'),
	 ('1104','環泥','上市','水泥工業'),
	 ('1108','幸福','上市','水泥工業');

INSERT INTO stock_daily (sdate,id,sname,trs_qty,trs_count,trs_amt,open_price,h_price,l_price,close_price,s_status,dec_price,lb_price,lb_amt,ls_price,ls_amt,PE) VALUES
	 ('20231024','1101','台泥',24067392,11612,758939141,31.75,31.75,31.35,31.50,'<p style= color:green>-</p>',0.15,31.50,873.00,31.55,209.00,25.82),
	 ('20231024','1102','亞泥',4819335,2248,188513356,38.85,39.40,38.85,39.00,'<p style= color:red>+</p>',0.15,39.00,205.00,39.05,5.00,11.64),
	 ('20231024','1103','嘉泥',163484,202,2920666,17.95,17.95,17.80,17.85,'<p style= color:green>-</p>',0.10,17.85,6.00,17.90,3.00,36.43),
	 ('20231024','1104','環泥',249575,236,6336950,25.30,25.50,25.25,25.50,'<p style= color:red>+</p>',0.25,25.40,5.00,25.50,13.00,8.92),
	 ('20231024','1108','幸福',301176,163,4072928,13.50,13.65,13.40,13.50,'<p style= color:green>-</p>',0.05,13.50,44.00,13.60,183.00,7.94);


-- ====================================================================
-- Function    : update案例
-- Create Date : 2023-11-06
-- 以下這端指令完成後，請至dbeaver截圖(請分段執行，共兩個結果)
-- ===================================================================

-- update案例，要有FK的值同步更動
update stock_list set id='111x'
where id='1108';

select * from stock_daily  where id like '111%';