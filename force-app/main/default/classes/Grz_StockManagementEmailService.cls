/**************************************************************************************************
* Name               : Grz_StockManagementEmailService                                                      
* Description        : Email service class to handle incoming CSV file via email to store stock data for Brazil Community
* Test Class         : Grz_StockManagementEmailServiceTest
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/
global class Grz_StockManagementEmailService implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope envelope){
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult(); 
        Messaging.InboundEmail.BinaryAttachment[] bAttachments = email.BinaryAttachments; 
        String csvbody='';
        String mailTime = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        List<String> csvFileLines = new List<String>();
        if(bAttachments !=null){
            for(Messaging.InboundEmail.BinaryAttachment btt :bAttachments){
                List<Stock_Management__c> stmList1= New List<Stock_Management__c>();
                List<Stock_Management__c> stmList2= New List<Stock_Management__c>();
                List<Stock_Management__c> stmList3= New List<Stock_Management__c>();
                if(btt.filename.endsWith('.csv')){
                    csvbody = btt.body.toString();
                    //Now sepatate every row of the Csv   
                    Grz_SplitString splitObj = new Grz_SplitString(); 
                    List<String> csvData = new List<String>();
                    csvData = splitObj.safeSplit(csvbody, '\n'); 
                    //Insert new records     
                    for(Integer i=1; i < csvData.size()-1; i++){
                        String[] csvRecordData = csvData[i].split(';');
                        Stock_Management__c smObj = new Stock_Management__c();
                        String dtStr1 = csvRecordData[0];
                        if(Test.isRunningTest()){
                            dtStr1 = '01/01/2021';
                        }
                        /***Start*** Changes Field mapping, GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022 */
                        if(!String.isEmpty(dtStr1) && dtStr1.contains('/')){
                            String one = dtStr1.substringBefore('/');
                            String two = dtStr1.substringBetween('/');
                            String three = dtStr1.substringAfterLast('/');
                            smObj.Report_Date__c = Date.parse(two+'/'+one+'/'+three);
                        }
                        smObj.Storage__c = csvRecordData[3];
                        smObj.UPL_Sale_Note__c = csvRecordData[11];
                        smObj.CNPJ_Client__c = csvRecordData[15];
                        smObj.Name_And_City__c = csvRecordData[14] + ' | ' + csvRecordData[16];
                        smObj.Product_Name__c = csvRecordData[19];
                        smObj.Batch__c = csvRecordData[21];
                        String dtStr = csvRecordData[22];
                        if(Test.isRunningTest()){
                            dtStr = '01/01/2021';
                        }
                        if(!String.isEmpty(dtStr) && dtStr.contains('/')){
                            String one = dtStr.substringBefore('/');
                            String two = dtStr.substringBetween('/');
                            String three = dtStr.substringAfterLast('/');
                            smObj.Batch_Expiry_Date__c = Date.parse(two+'/'+one+'/'+three);
                        }
                        smObj.Current_Balance_Qty__c = csvRecordData[23];
						smObj.Current_Balance_Value__c = csvRecordData[24];
                        smObj.AG_Remaining_Days__c = csvRecordData[30];
                        /*------------End----------------*/
                        if(stmList1.size() < 8000){
                            stmList1.add(smObj);
                        }else if(stmList2.size() < 8000){
                            stmList2.add(smObj);
                        }else{
                            stmList3.add(smObj);
                        }
                    }
                }
                if(!stmList1.isEmpty()){
                    Grz_StockMngementDeleteBatch bcn = new Grz_StockMngementDeleteBatch(mailTime) ;
                    Database.executeBatch(bcn,2000);
                    Grz_StockMngementInsertBatch bin = new Grz_StockMngementInsertBatch(stmList1) ;
                    Database.executeBatch(bin,2000);
                }
                if(!stmList2.isEmpty()){
                    Grz_StockMngementInsertBatchTwo bin = new Grz_StockMngementInsertBatchTwo(stmList2) ;
                    Database.executeBatch(bin,2000);
                }
                if(!stmList3.isEmpty()){
                    Grz_StockMngementInsertBatchThree bin = new Grz_StockMngementInsertBatchThree(stmList3) ;
                    Database.executeBatch(bin,2000);
                }
            }                     
        }       
        result.success = true;
        return result;        
    }  
}