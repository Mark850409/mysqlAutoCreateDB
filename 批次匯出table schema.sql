-- ====================================================================
-- SP Name     : procExportTableSchema
-- Function    : 批次匯出table schema
-- Author      : Mark
-- Create Date : 2023-10-22
-- Parameter   : DBName
-- Modify His  : 
-- (1) 2023-10-22 : Mark    : CREATE 
-- (2) 2023-10-23 : Mark    : Modify SP describe、CREATE COLUMN CHINESE NAME、UPDATE SP NAME、UPDATE CSV COLUMN NAME
-- ===================================================================

DELIMITER $$
-- 如果PROCEDURE存在就先移除                                                                                                                                                                   
DROP PROCEDURE IF EXISTS procExportTableSchema $$       
-- 建立PROCEDURE(傳入資料庫名稱參數)                                                                                                                           
CREATE PROCEDURE procExportTableSchema(DBName varchar(255))    
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
            
            -- 判斷不同的資料表，給予不同的中文欄位名稱
			CASE table_name
			WHEN  'stock_daily' THEN
			   SET @caseSQL=CONCAT("(
						CASE 
							WHEN COLUMN_NAME='sdate' THEN '價格1' 
							WHEN COLUMN_NAME='id' THEN '價格2'
                            WHEN COLUMN_NAME='sname' THEN '價格2'
                            WHEN COLUMN_NAME='trs_qty' THEN '價格2'
                            WHEN COLUMN_NAME='trs_count' THEN '價格2'
                            WHEN COLUMN_NAME='trs_amt' THEN '價格2'
                            WHEN COLUMN_NAME='open_price' THEN '價格2'
                            WHEN COLUMN_NAME='h_price' THEN '價格2'
                            WHEN COLUMN_NAME='l_price' THEN '價格2'
                            WHEN COLUMN_NAME='close_price' THEN '價格2'
                            WHEN COLUMN_NAME='s_status' THEN '價格2'
                            WHEN COLUMN_NAME='dec_price' THEN '價格2'
						ELSE 'null'
						END)"
						);
			WHEN 'stock_daily_3' THEN
			   SET @caseSQL = CONCAT("(
						CASE 
							WHEN COLUMN_NAME='sdate' THEN '價格3' 
							WHEN COLUMN_NAME='id' THEN '價格4'
                            WHEN COLUMN_NAME='f_qty' THEN '價格4'
                            WHEN COLUMN_NAME='i_qty' THEN '價格4'
                            WHEN COLUMN_NAME='s_qty' THEN '價格4'
                            WHEN COLUMN_NAME='t_qty' THEN '價格4'
                            WHEN COLUMN_NAME='est_f_qty' THEN '價格4'
                            WHEN COLUMN_NAME='est_i_qty' THEN '價格4'
                            WHEN COLUMN_NAME='est_s_qty' THEN '價格4'
                            WHEN COLUMN_NAME='est_t_qty' THEN '價格4'
                            WHEN COLUMN_NAME='trs_f_percent' THEN '價格4'
                            WHEN COLUMN_NAME='trs_3_percent' THEN '價格4'
						ELSE 'null'
						END)"
						);
			WHEN 'stock_daily_mr' THEN
			   SET @caseSQL = CONCAT("(
						CASE 
							WHEN COLUMN_NAME='sdate' THEN '價格5' 
							WHEN COLUMN_NAME='id' THEN '價格6'
                            WHEN COLUMN_NAME='id_sub' THEN '價格6'
                            WHEN COLUMN_NAME='id_mr' THEN '價格6'
                            WHEN COLUMN_NAME='mrname' THEN '價格6'
                            WHEN COLUMN_NAME='b_qty' THEN '價格6'
                            WHEN COLUMN_NAME='s_qty' THEN '價格6'
                            WHEN COLUMN_NAME='dec_qty' THEN '價格6'
                            WHEN COLUMN_NAME='dstatus' THEN '價格6'
                            WHEN COLUMN_NAME='trs_percent' THEN '價格6'
						ELSE 'null'
						END)"
						);
			WHEN 'stock_daily_mt' THEN
			   SET @caseSQL = CONCAT("(
						CASE 
							WHEN COLUMN_NAME='sdate' THEN '價格7' 
							WHEN COLUMN_NAME='id' THEN '價格8'
                            WHEN COLUMN_NAME='mt_b_qty' THEN '價格8'
                            WHEN COLUMN_NAME='mt_s_qty' THEN '價格8'
                            WHEN COLUMN_NAME='mt_r_qty' THEN '價格8'
                            WHEN COLUMN_NAME='mt_qty' THEN '價格8'
                            WHEN COLUMN_NAME='mt_dec_qty' THEN '價格8'
                            WHEN COLUMN_NAME='mt_limit_qty' THEN '價格8'
                            WHEN COLUMN_NAME='mt_use_percent' THEN '價格8'
                            WHEN COLUMN_NAME='ss_b_qty' THEN '價格8'
                            WHEN COLUMN_NAME='ss_s_qt' THEN '價格8'
                            WHEN COLUMN_NAME='ss_r_qty' THEN '價格8'
                            WHEN COLUMN_NAME='ss_qty' THEN '價格8'
                            WHEN COLUMN_NAME='ss_dec_qty' THEN '價格8'
                            WHEN COLUMN_NAME='ms_percent' THEN '價格8'
                            WHEN COLUMN_NAME='ms_dec_qty' THEN '價格8'
						ELSE 'null'
						END)"
						);
			WHEN 'stock_list' THEN
			   SET @caseSQL = CONCAT("(
						CASE 
							WHEN COLUMN_NAME='sdate' THEN '價格9' 
							WHEN COLUMN_NAME='id' THEN '價格10'
                            WHEN COLUMN_NAME='stock_attr' THEN '價格10'
                            WHEN COLUMN_NAME='industry' THEN '價格10'
						ELSE 'null'
						END)"
						);
			WHEN 'stock_monthly_revenue' THEN
			   SET @caseSQL = CONCAT("(
						CASE 
							WHEN COLUMN_NAME='yyyymm' THEN '價格11' 
							WHEN COLUMN_NAME='id' THEN '價格12'
                            WHEN COLUMN_NAME='sname' THEN '價格12'
                            WHEN COLUMN_NAME='month_amt' THEN '價格12'
                            WHEN COLUMN_NAME='pre_m_amt' THEN '價格12'
                            WHEN COLUMN_NAME='pre_y_amt' THEN '價格12'
                            WHEN COLUMN_NAME='pre_m_percent' THEN '價格12'
                            WHEN COLUMN_NAME='pre_y_percent' THEN '價格12'
                            WHEN COLUMN_NAME='sum_amt' THEN '價格12'
                            WHEN COLUMN_NAME='pre_sum_amt' THEN '價格12'
                            WHEN COLUMN_NAME='sum_precent' THEN '價格12'
                            WHEN COLUMN_NAME='memo_str' THEN '價格12'
						ELSE 'null'
						END)"
						);
		
				ELSE BEGIN END;  
			END CASE;
		
			-- 將 @caseSQL、@windows_path、@mylocaltimestamp、DBName 當作變數傳入SQL
			SET @export_csv = CONCAT("SELECT '欄位名稱','資料型態','是否null','主鍵/外來鍵', '欄位描述'
			UNION
			select COLUMN_NAME,DATA_TYPE,IS_NULLABLE,COLUMN_KEY,",@caseSQL," FROM information_schema.columns 
			where table_schema = '",DBName,"' AND table_name='",table_name,"' 
			INTO OUTFILE '",@windows_path,@mylocaltimestamp,"_",table_name,'.csv'"' CHARACTER SET Big5 FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n'"); 
            -- 執行SQL
			PREPARE stmt2 FROM @export_csv;                                                                                                                                               
 			EXECUTE stmt2; 

         -- 迴圈結束
        END LOOP;                                                                                                                                                               
        CLOSE cur;                                                                                                                                                              
    END $$                                                                                                                                                                      
DELIMITER ;
-- 設定資料庫名稱參數 
SET @DBName='stock';
-- 呼叫PROCEDURE並傳入參數(資料庫名稱)
call procExportTableSchema(@DBName);