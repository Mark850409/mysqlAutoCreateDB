DELIMITER $$                                                                                                                                                                    
DROP PROCEDURE IF EXISTS procCountAllTables $$                                                                                                                                  
CREATE PROCEDURE procCountAllTables(DBName varchar(255))    
BEGIN                                                                                                                                                                       
        DECLARE table_name VARCHAR(255);                                                                                                                                        
        DECLARE end_of_tables INT DEFAULT 0;
        DECLARE mylocaltimestamp DATETIME;
		
        
        DECLARE cur CURSOR FOR                                                                                                                                                  
            SELECT t.table_name                                                                                                                                                 
            FROM information_schema.tables t                                                                                                                                    
            WHERE t.table_schema = DBName AND t.table_type='BASE TABLE';                                                                                                 
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET end_of_tables = 1;                                                                                                           
		
        OPEN cur;                                                                                                                                                               
		
        
        tables_loop: LOOP                   
            	
            FETCH cur INTO table_name;             			
            IF end_of_tables = 1 THEN                                                                                                                                           
                LEAVE tables_loop;                                                                                                                                              
            END IF;                                                                                                                                                             

            SET @show_schema = CONCAT("desc"," ",DBName,".",table_name);                                                                               
            PREPARE stmt FROM @show_schema;                                                                                                                                               
            EXECUTE stmt;       
            
			SET @mylocaltimestamp=DATE_FORMAT(NOW(),'%Y-%m-%d %H-%i-%s');
            SET @windows_path='C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/';
			SET @export_csv = CONCAT("SELECT 'COLUMN_NAME','DATA_TYPE','IS_NULLABLE','COLUMN_KEY'
			UNION
			select COLUMN_NAME,DATA_TYPE,IS_NULLABLE,COLUMN_KEY FROM information_schema.columns 
			where table_schema = '",DBName,"' AND table_name='",table_name,"' 
			INTO OUTFILE '",@windows_path,@mylocaltimestamp,"_",table_name,'.csv',"' FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n'"); 

			PREPARE stmt2 FROM @export_csv;                                                                                                                                               
			EXECUTE stmt2; 
        
        END LOOP;                                                                                                                                                               
        CLOSE cur;                                                                                                                                                              
    END $$                                                                                                                                                                      

DELIMITER ;
SET @DBName='stock';
call procCountAllTables(@DBName);