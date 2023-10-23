# 批次建立資料表&匯出資料表結構到CSV

### 簡介

自動化建立資料表&匯出資料結構至CSV

### 目錄

- [批次建立資料表\&匯出資料表結構到CSV](#批次建立資料表匯出資料表結構到csv)
    - [簡介](#簡介)
    - [目錄](#目錄)
  - [一、使用方式](#一使用方式)
  - [二、執行步驟](#二執行步驟)
    - [注意事項](#注意事項)
    - [步驟開始](#步驟開始)


## 一、使用方式

1. 進入到以下網址，`下載專案`到本地端
https://github.com/Mark850409/mysqlAutoCreateDB

2. 點選Code→Download ZIP

![image-20231023100858046](https://raw.githubusercontent.com/Mark850409/UploadGithubImage/master/image-20231023100858046.png)

3. `解壓`後會看到如下圖檔案
![image-20231023100942573](https://raw.githubusercontent.com/Mark850409/UploadGithubImage/master/image-20231023100942573.png)


## 二、執行步驟


### 注意事項

1. 請依序執行SP，先執行`建立資料表SP`，再執行`匯出資料表結構SP`
2. 請將代碼複製貼上`整段執行`(不要`單獨執行`會`出錯`)
3. 請先安裝`mysql workbench`，並確認`mysql`程序`可正常執行`

### 步驟開始

1. 將剛才下載的檔案`批次建立stock table.sql`，將語法整段複製起來，貼到`mysql Workbench`，如下圖
![image-20231023101347673](https://raw.githubusercontent.com/Mark850409/UploadGithubImage/master/image-20231023101347673.png)

2. 點選`執行`按鈕，看到以下執行結果為綠勾勾，表示執行無誤，此時`重新整理`左側的`資料庫清單`，可以發現`已建立stock`資料庫以及對應的`6個資料表`，如下圖
![image-20231023101459437](https://raw.githubusercontent.com/Mark850409/UploadGithubImage/master/image-20231023101459437.png)

3. 將剛才下載的檔案`批次匯出table schema.sql`，將語法整段複製起來，貼到`mysql Workbench`，如下圖
![image-20231023101534154](https://raw.githubusercontent.com/Mark850409/UploadGithubImage/master/image-20231023101534154.png)

4. 點選`執行`按鈕，看到以下執行結果為`綠勾勾`，表示執行無誤，此時會出現`資料表結構查詢結果`，以及在`指定目錄下生成CSV`
![image-20231023101622238](https://raw.githubusercontent.com/Mark850409/UploadGithubImage/master/image-20231023101622238.png)

5. 執行完成到此目錄，C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/，查看是否成功產生CSV檔案。
![image-20231023101709795](https://raw.githubusercontent.com/Mark850409/UploadGithubImage/master/image-20231023101709795.png)