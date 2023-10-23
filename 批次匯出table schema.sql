-- ====================================================================
-- SP Name     : procExportTableSchema
-- Function    : 批次匯出table schema
-- Author      : Mark
-- Create Date : 2023-10-22
-- Parameter   : DBName
-- Modify His  : 
-- (1) 2023-10-22 : Mark    : CREATE 
-- (2) 2023-10-23 : Mark    : 
-- a、Modify SP describe
-- b、CREATE COLUMN CHINESE NAME
-- c、UPDATE SP NAME
-- d、UPDATE CSV COLUMN NAME
-- e、Add CSV Header For User Choose Language
-- f、UPDATE COLUMN CHINESE NAME
-- ===================================================================

DELIMITER $$
-- 如果PROCEDURE存在就先移除                                                                                                                                                                   
DROP PROCEDURE IF EXISTS procExportTableSchema $$       
-- 建立PROCEDURE(傳入資料庫名稱參數)                                                                                                                           
CREATE PROCEDURE procExportTableSchema(DBName varchar(255),title_language varchar(255))    
BEGIN   
		-- 變數宣告
			-- 1. 資料表集合名稱
			-- 2. 取得最後一張資料表
			-- 3. 時間戳記
        DECLARE table_name VARCHAR(255);                                                                                                                                        
        DECLARE end_of_tables INT DEFAULT 0;
        DECLARE mylocaltimestamp DATETIME;
		
        -- 利用SQL取出指定資料庫裡面所有資料表的list，直到最後一張資料表為止
        DECLARE cur CURSOR FOR                                                                                                                                                  
            SELECT t.table_name                                                                                                                                                 
            FROM information_schema.tables t                                                                                                                                    
            WHERE t.table_schema = DBName AND t.table_type='BASE TABLE';                                                                                                 
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET end_of_tables = 1;                                                                                                           
		
        OPEN cur;                                                                                                                                                               
		
        -- 迴圈開始
        tables_loop: LOOP                   
            	
			-- 將資料集透過迴圈取出，最後一張表時強制離開迴圈
            FETCH cur INTO table_name;             			
            IF end_of_tables = 1 THEN                                                                                                                                           
                LEAVE tables_loop;                                                                                                                                              
            END IF;                                                                                                                                                             
			
            -- 使用CONCAT串接SQL語法(這一段是查看SQL結果，可以拿掉不執行)
            -- SET @show_schema = CONCAT("desc"," ",DBName,".",table_name);
            -- 建立PREPARE STATEMENT，並執行
            -- PREPARE stmt FROM @show_schema;                                                                                                                                               
            -- EXECUTE stmt;     
  
            -- 取得當下時間戳記
			SET @mylocaltimestamp=DATE_FORMAT(NOW(),'%Y-%m-%d %H-%i-%s');
            -- 取得CSV匯出路徑
            SET @windows_path='C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/';
            
            -- 取得CSV檔名
            CASE title_language
			WHEN 'ch' THEN 
				 SET @file_name=CONCAT(@windows_path,@mylocaltimestamp,"_",table_name,'_ch.csv');
			WHEN 'en' THEN 
				 SET @file_name=CONCAT(@windows_path,@mylocaltimestamp,"_",table_name,'_en.csv');
				 ELSE BEGIN END;  
			END CASE;
                       
            -- 判斷不同的資料表，給予不同的中文欄位名稱
			CASE table_name
			WHEN 'stock_list' THEN
			   SET @table_type='證券清冊';
			   SET @caseSQL = CONCAT("(
						CASE 
							WHEN COLUMN_NAME='id' THEN '證券代號'
                            WHEN COLUMN_NAME='sname' THEN '證券名稱' 
                            WHEN COLUMN_NAME='stock_attr' THEN '上市上櫃類別'
                            WHEN COLUMN_NAME='industry' THEN '產業分類'
						ELSE 'null'
						END)"
						);
                        
			WHEN  'stock_daily' THEN
			   SET @table_type='每日收盤資訊';
			   SET @caseSQL=CONCAT("(
						CASE 
							WHEN COLUMN_NAME='sdate' THEN '交易日期' 
							WHEN COLUMN_NAME='id' THEN '證券代號'
                            WHEN COLUMN_NAME='sname' THEN '證券名稱'
                            WHEN COLUMN_NAME='trs_qty' THEN '成交股數'
                            WHEN COLUMN_NAME='trs_count' THEN '成交筆數'
                            WHEN COLUMN_NAME='trs_amt' THEN '成交金額'
                            WHEN COLUMN_NAME='open_price' THEN '開盤價'
                            WHEN COLUMN_NAME='h_price' THEN '最高價'
                            WHEN COLUMN_NAME='l_price' THEN '最低價'
                            WHEN COLUMN_NAME='close_price' THEN '收盤價'
                            WHEN COLUMN_NAME='s_status' THEN '漲跌(+/-)'
                            WHEN COLUMN_NAME='dec_price' THEN '漲跌價差'
                            WHEN COLUMN_NAME='lb_price' THEN '最後揭示買價'
                            WHEN COLUMN_NAME='lb_amt' THEN '最後揭示買量'
                            WHEN COLUMN_NAME='ls_price' THEN '最後揭示賣價'
                            WHEN COLUMN_NAME='ls_amt' THEN '最後揭示賣量'
                            WHEN COLUMN_NAME='PE' THEN '本益比'
						ELSE 'null'
						END)"
						);
                        
			   WHEN 'stock_monthly_revenue' THEN
			    SET @table_type='每月營收';
			   SET @caseSQL = CONCAT("(
						CASE 
							WHEN COLUMN_NAME='yyyymm' THEN '營收年月' 
							WHEN COLUMN_NAME='id' THEN '證券代號'
                            WHEN COLUMN_NAME='sname' THEN '證券名稱'
                            WHEN COLUMN_NAME='month_amt' THEN '當月營收'
                            WHEN COLUMN_NAME='pre_m_amt' THEN '上月營收'
                            WHEN COLUMN_NAME='pre_y_amt' THEN '去年當月營收'
                            WHEN COLUMN_NAME='pre_m_percent' THEN '上月比較增減(%)'
                            WHEN COLUMN_NAME='pre_y_percent' THEN '去年同月增減(%)'
                            WHEN COLUMN_NAME='sum_amt' THEN '當月累計營收'
                            WHEN COLUMN_NAME='per_sum_amt' THEN '去年累計營收'
                            WHEN COLUMN_NAME='sum_percent' THEN '前期比較增減(%)'
                            WHEN COLUMN_NAME='memo_str' THEN '備註'
						ELSE 'null'
						END)"
						);
                        
			WHEN 'stock_daily_3' THEN
               SET @table_type='三大法人進出';
			   SET @caseSQL = CONCAT("(
						CASE 
							WHEN COLUMN_NAME='sdate' THEN '交易日期' 
							WHEN COLUMN_NAME='id' THEN '證券代號'
                            WHEN COLUMN_NAME='f_qty' THEN '外資'
                            WHEN COLUMN_NAME='i_qty' THEN '投信'
                            WHEN COLUMN_NAME='s_qty' THEN '自營商'
                            WHEN COLUMN_NAME='t_qty' THEN '單日合計'
                            WHEN COLUMN_NAME='est_f_qty' THEN '估計外資持股'
                            WHEN COLUMN_NAME='est_i_qty' THEN '估計投信持股'
                            WHEN COLUMN_NAME='est_s_qty' THEN '估計自營商持股'
                            WHEN COLUMN_NAME='est_t_qty' THEN '合計'
                            WHEN COLUMN_NAME='trs_f_percent' THEN '外資比例'
                            WHEN COLUMN_NAME='trs_3_percent' THEN '三大法人比例'
						ELSE 'null'
						END)"
						);
			WHEN 'stock_daily_mr' THEN
               SET @table_type='主力進出';
			   SET @caseSQL = CONCAT("(
						CASE 
							WHEN COLUMN_NAME='sdate' THEN '日期' 
							WHEN COLUMN_NAME='id' THEN '股票代號'
                            WHEN COLUMN_NAME='id_sub' THEN '券商代號'
                            WHEN COLUMN_NAME='id_mr' THEN '券商主代號'
                            WHEN COLUMN_NAME='mrname' THEN '券商名稱'
                            WHEN COLUMN_NAME='b_qty' THEN '買進'
                            WHEN COLUMN_NAME='s_qty' THEN '賣出'
                            WHEN COLUMN_NAME='dec_qty' THEN '買超'
                            WHEN COLUMN_NAME='dstatus' THEN '買or賣'
                            WHEN COLUMN_NAME='trs_percent' THEN '佔成交比重'
						ELSE 'null'
						END)"
						);
			WHEN 'stock_daily_mt' THEN
               SET @table_type='融資融券';
			   SET @caseSQL = CONCAT("(
						CASE 
							WHEN COLUMN_NAME='sdate' THEN '交易日期' 
							WHEN COLUMN_NAME='id' THEN '證券代號'
                            WHEN COLUMN_NAME='mt_b_qty' THEN '融資買進'
                            WHEN COLUMN_NAME='mt_s_qty' THEN '融資賣出'
                            WHEN COLUMN_NAME='mt_r_qty' THEN '融資現償'
                            WHEN COLUMN_NAME='mt_qty' THEN '融資餘額'
                            WHEN COLUMN_NAME='mt_dec_qty' THEN '融資增減'
                            WHEN COLUMN_NAME='mt_limit_qty' THEN '融資限額'
                            WHEN COLUMN_NAME='mt_use_percent' THEN '融資使用率'
                            WHEN COLUMN_NAME='ss_b_qty' THEN '融券賣出'
                            WHEN COLUMN_NAME='ss_s_qt' THEN '融券買進'
                            WHEN COLUMN_NAME='ss_r_qty' THEN '融券券償'
                            WHEN COLUMN_NAME='ss_qty' THEN '融券餘額'
                            WHEN COLUMN_NAME='ss_dec_qty' THEN '融券增減'
                            WHEN COLUMN_NAME='ms_percent' THEN '券資比'
                            WHEN COLUMN_NAME='ms_dec_qty' THEN '資券相抵'
						ELSE 'null'
						END)"
						);	

				ELSE BEGIN END;  
			END CASE;
		
			-- 判斷CSV表頭要使用哪種語言(中文、英文)
            CASE title_language
			WHEN 'ch' THEN 
				SET @title= CONCAT("'",'欄位名稱',"'",",","'",'資料型態',"'",",","'",'是否null',"'",",","'",'主鍵/外來鍵',"'",",","'",'欄位描述',"'",",","'",'資料表分類',"'");
                
			WHEN 'en' THEN 
				SET @title= CONCAT("'",'COLUMN_NAME',"'",",","'",'DATA_TYPE',"'",",","'",'IS_NULLABLE',"'",",","'",'COLUMN_KEY',"'",",","'",'DESC',"'",",","'",'COLUMN_NAME',"'");
				ELSE BEGIN END;  
			END CASE;
            
            -- 串接SQL匯出語句
			SET @export_csv = CONCAT("SELECT ",@title,"
			UNION
			select COLUMN_NAME,DATA_TYPE,IS_NULLABLE,COLUMN_KEY,",@caseSQL,",","'",@table_type,"' FROM information_schema.columns 
			where table_schema = '",DBName,"' AND table_name='",table_name,"' 
			INTO OUTFILE '",@file_name,"' CHARACTER SET Big5 FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n'"); 
            
            -- 這一段供測試用
            -- SELECT @export_csv;
            -- 執行SQL
			PREPARE stmt2 FROM @export_csv;                                                                                                                                               
  			EXECUTE stmt2; 

         -- 迴圈結束
        END LOOP;                                                                                                                                                               
        CLOSE cur;                                                                                                                                                              
    END $$                                                                                                                                                                      
DELIMITER ;
-- 設定資料庫名稱、表頭語言參數 
SET @DBName='stock';
SET @title='en';
-- 呼叫PROCEDURE並傳入參數(資料庫名稱、表頭語言)
call procExportTableSchema(@DBName,@title);