-- ====================================================================
-- SP Name     : procExportTableSchema
-- Function    : 批次匯出table schema
-- Author      : Mark
-- Create Date : 2023-10-22
-- Parameter   : DBName
-- Modify His  : 
-- (1) 2023-10-22 : Mark    : CREATE 
-- (2) 2023-10-23 : Mark    : Modify SP describe 
-- ===================================================================

DELIMITER $$
-- 如果PROCEDURE存在就先移除                                                                                                                                                                   
DROP PROCEDURE IF EXISTS procExportTableSchema $$       
-- 建立PROCEDURE(傳入資料庫名稱參數)                                                                                                                           
CREATE PROCEDURE procCountAllTables(DBName varchar(255))    
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
			
            -- 使用CONCAT串接SQL語法
            SET @show_schema = CONCAT("desc"," ",DBName,".",table_name);
            -- 建立PREPARE STATEMENT，並執行
            PREPARE stmt FROM @show_schema;                                                                                                                                               
            EXECUTE stmt;       
            -- 取得當下時間戳記
			SET @mylocaltimestamp=DATE_FORMAT(NOW(),'%Y-%m-%d %H-%i-%s');
            -- 取得CSV匯出路徑
            SET @windows_path='C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/';
            -- 建立匯出CSV的SQL語法
			SET @export_csv = CONCAT("SELECT 'COLUMN_NAME','DATA_TYPE','IS_NULLABLE','COLUMN_KEY'
			UNION
			select COLUMN_NAME,DATA_TYPE,IS_NULLABLE,COLUMN_KEY FROM information_schema.columns 
			where table_schema = '",DBName,"' AND table_name='",table_name,"' 
			INTO OUTFILE '",@windows_path,@mylocaltimestamp,"_",table_name,'.csv',"' FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n'"); 

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
call procCountAllTables(@DBName);