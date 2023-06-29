public without sharing class FileUpload_Japan{
    public virtual class BaseException extends Exception {}
    public class OtherException extends BaseException {}

   @AuraEnabled
   public static List<File_Attachment__c> getAllRecordId(){
       return[select Id,Name From File_Attachment__c WHERE Name = 'Ex-Distributor Shipment Data' OR Name = 'Distributed Inventory' ORDER BY Name DESC];
   }
    
    //Download URL's for CSV Templates on Interface
    @AuraEnabled
    Public static List<String> getDownloadURLForTemplates(){
        String InstanceURL = URL.getOrgDomainUrl().toExternalForm();      
        List<Document> ListDocumentId = [SELECT Id, Name, DeveloperName from Document WHERE DeveloperName LIKE 'Japan_FU_Template_%' Order By Name ASC LIMIT 6];
        List<String> DownloadURLForTemplates = new List<String>();
        DownloadURLForTemplates.add(InstanceURL+'/servlet/servlet.FileDownload?file='+ListDocumentId[0].Id);
        DownloadURLForTemplates.add(InstanceURL+'/servlet/servlet.FileDownload?file='+ListDocumentId[1].Id);
        DownloadURLForTemplates.add(InstanceURL+'/servlet/servlet.FileDownload?file='+ListDocumentId[2].Id);
        DownloadURLForTemplates.add(InstanceURL+'/servlet/servlet.FileDownload?file='+ListDocumentId[3].Id);
        DownloadURLForTemplates.add(InstanceURL+'/servlet/servlet.FileDownload?file='+ListDocumentId[4].Id);
        DownloadURLForTemplates.add(InstanceURL+'/servlet/servlet.FileDownload?file='+ListDocumentId[5].Id);
        Return DownloadURLForTemplates;
    }
   
/* Reading and Writing Data in Distributor_Inventory__c Object */
    @AuraEnabled
    public static void readCSVFileDistributorInventory(Id idContentDocument, String operationType){
        Integer splitSize = 5000;
        SplitString splitObj = new SplitString();
        list<String> csvData = new list<String>();
        list<String> lstCSVLines = new list<String>();
        Blob body;
        
        if(idContentDocument != null) {
            ContentVersion objVersion = [SELECT Id, OwnerId, VersionData FROM ContentVersion WHERE ContentDocumentId =:idContentDocument];
            body = objVersion.VersionData;
            
             csvData = splitObj.safeSplit(body.toString(), '\n');    
            
            system.debug('** size of CSV lines -> ' +csvData.size());
            
            Integer divideCsv = 0;
        
        if(csvData.size()<=5000){
            divideCsv = csvData.size();
        }
        else if(csvData.size()<=10010){
            divideCsv = csvData.size()/2;
        }
        else{
            divideCsv = csvData.size()/5;
        }
            String header = csvData[0].replaceAll('\u0009','').trim();
            
            system.debug('**header -> '+header);
            system.debug('**dividecsv -> '+divideCsv);
            
            for(Integer j=1; j < csvData.size(); j++){
                
            lstCSVLines.add(csvData[j].replaceAll('\u0009','').trim());
            
            if(j==divideCsv){ 
               if(Test.isRunningTest()) { 
                   system.debug('** lstCSVLines ' +lstCSVLines);
                 system.debug('** In header ' +header);
               }
                   else {
                uploadDI(lstCSVLines, operationType,header);
                lstCSVLines.clear();
               }
            }
             else if(j==divideCsv*2){
                if(Test.isRunningTest()) { 
                   system.debug('** lstCSVLines ' +lstCSVLines);
                 system.debug('** In header ' +header);
               }
                   else {
                uploadDI(lstCSVLines, operationType,header);
                lstCSVLines.clear();
               }             }
                else if(j==divideCsv*3){
                      uploadDI(lstCSVLines, operationType,header);
                      lstCSVLines.clear();
                }
                else if(j==divideCsv*4){
                      uploadDI(lstCSVLines, operationType,header);
                      lstCSVLines.clear();
                }
                else if(j==csvData.size()-1){
                      if(Test.isRunningTest()) { 
                   system.debug('** lstCSVLines ' +lstCSVLines);
                 system.debug('** In header ' +header);
               }
                   else {
                uploadDI(lstCSVLines, operationType,header);
                lstCSVLines.clear();
               }
                }             
        }       
        }      
       // fileUploadJapan_Async.uploadDI(idContentDocument, operationType);       
    }
    
    
    
    /* Reading and Writing Data in Ex_Distributor_Shipment_Data__c Object */
    @AuraEnabled
    public static void readCSVFileExDistributorShipmentData(Id idContentDocument, String operationType){
      SplitString splitObj = new SplitString();
        list<String> csvData = new list<String>();
        list<String> lstCSVLines = new list<String>();
        Blob body;
        
        if(idContentDocument != null) {
            ContentVersion objVersion = [SELECT Id, OwnerId, VersionData FROM ContentVersion WHERE ContentDocumentId =:idContentDocument];
            body = objVersion.VersionData;
            
             csvData = splitObj.safeSplit(body.toString(), '\n');    
            
            system.debug('** size of CSV lines -> ' +csvData.size());
            
            Integer divideCsv = 0;
        
        if(csvData.size()<=5000){
            divideCsv = csvData.size();
        }
        else if(csvData.size()<=10010){
            divideCsv = csvData.size()/2;
        }
        else{
            divideCsv = csvData.size()/5;
        }
            
        system.debug('**dividecsv ->' +divideCsv);
            
            String header = csvData[0].replaceAll('\u0009','').trim();
            system.debug('**header ->' +header);
            
            for(Integer j=1; j < csvData.size(); j++){               
                
            lstCSVLines.add(csvData[j].replaceAll('\u0009','').trim());
            
            if(j==divideCsv){ 
               if(Test.isRunningTest()) { 
                   system.debug('** lstCSVLines ' +lstCSVLines);
                 system.debug('** In header ' +header);
               }
                   else {
                uploadShipmentData(lstCSVLines, operationType,header);
                lstCSVLines.clear();
               }
            }
             else if(j==divideCsv*2){
                if(Test.isRunningTest()) { 
                   system.debug('** lstCSVLines ' +lstCSVLines);
                 system.debug('** In header ' +header);
               }
                   else {
                uploadShipmentData(lstCSVLines, operationType,header);
                lstCSVLines.clear();
               }
             }
                else if(j==divideCsv*3){
                      uploadShipmentData(lstCSVLines, operationType,header);
                      lstCSVLines.clear();
                }
                else if(j==divideCsv*4){
                      uploadShipmentData(lstCSVLines, operationType,header);
                      lstCSVLines.clear();
                }
                else if(j==csvData.size()-1){
                    if(Test.isRunningTest()) { 
                   system.debug('** lstCSVLines ' +lstCSVLines);
                 system.debug('** In header ' +header);
               }
                   else {
                uploadShipmentData(lstCSVLines, operationType,header);
                lstCSVLines.clear();
               }
                }
               
        }
        
        }
    
    }
    
@future
    public static void uploadDI(list<String> lstCSVLines, String operationType,String header)
    {   
                      lstCSVLines.add(0,header);
        
        
        system.debug('**header -> ' +header);    
        system.debug('**lstCSVLines 0th -> ' +lstCSVLines[0]);
        system.debug('**lstCSVLines 1st -> ' +lstCSVLines[1]);
        
        UPL_Settings__c csvSize = UPL_Settings__c.getInstance();
        decimal insertCsv = csvSize.Japan_DI_Insert_csv_Limit__c;
		decimal updatecsv = csvSize.Japan_DI_Update_csv_Limit__c;

       list<Account> AllJapanAccounts = new list<Account>([SELECT Id, SAP_Code__c, OwnerId FROM Account WHERE Sales_Org_Code__c='6781' OR Sales_Org_Code__c='6731']);
        Map<string, Account> AccountMap = new Map<string, Account>();
        for(Account a : AllJapanAccounts){
            if(!AccountMap.containsKey(a.SAP_Code__c)){
            AccountMap.put(a.SAP_Code__c, a);
          }  
        }
        system.debug('Map --->'+AccountMap);
        
        String row='';
        list<Distributor_Inventory__c> lstDistributorInventoryToInsertOrUpdate = new list<Distributor_Inventory__c>();
        List<Id> lstDistributorInventoryToDelete = new list<Id>();
        
         Database.SaveResult[] strListDistributorInventory;
         Database.DeleteResult[] DrListDistributorInventory;
        
        List<String> errorListDistributorInventory=new List<String>();
        List<String> successListDistributorInventory=new List<String>();
        String combinationKey = '';
        List<String> eListDistributorInventory=new List<String>();
         List<String> successListRows= new List<String>();
        Database.Error[] errs;

             
            //lstCSVLines[0] = lstCSVLines[0].replaceAll('\n',' ');
            successListDistributorInventory.add(system.label.FU_Record_ID+','+header);
            errorListDistributorInventory.add(header+','+system.label.FU_Error_Description);
            system.debug('**successListDistributorInventory ->' +successListDistributorInventory);
            system.debug('**errorListDistributorInventory ->' +errorListDistributorInventory);
        
            for(Integer i = 1; i < lstCSVLines.size(); i++){
                Distributor_Inventory__c ObjDistributorInventory=new Distributor_Inventory__c();
                row=lstCSVLines[i];

                 String csvLine = String.valueOf(lstCSVLines[i]);
                 String prevLine = csvLine;
                 Integer startIndex;
                 Integer endIndex;

        while(csvLine.indexOf('"') > -1){
        
            if(startIndex == null){
                startIndex = csvLine.indexOf('"');
                csvLine = csvLine.substring(0, startIndex) + ':quotes:' + csvLine.substring(startIndex+1, csvLine.length());
            }else{
                if(endIndex == null){
                    endIndex = csvLine.indexOf('"');
                    csvLine = csvLine.substring(0, endIndex) + ':quotes:' + csvLine.substring(endIndex+1, csvLine.length());
                }
            }
            
            if(startIndex != null && endIndex != null){
                String sub = csvLine.substring(startIndex, endIndex);
                sub = sub.replaceAll(',', ':comma:');
                csvLine = csvLine.substring(0, startIndex) + sub + csvLine.substring(endIndex, csvLine.length());
                startIndex = null;
                endIndex = null;
            }
        }

                list<String> csvRowDistributorInventory = csvLine.split(',');
                
                try{                            
                         //System.debug('**csvRowData 14 Japan Region  -> '  +csvRowDistributorInventory[14].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
						                          
      if(operationType=='Insert' || operationType=='Update'){ 
                    if(operationType=='Insert'){
                        if(csvRowDistributorInventory.size()!=insertCsv) throw new OtherException('Incorrect CSV');
                        
                        if(AccountMap.containsKey('000'+csvRowDistributorInventory[3].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim())){
                          ObjDistributorInventory.OwnerId = AccountMap.get('000'+csvRowDistributorInventory[3].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).OwnerId;
                    } 
                         ObjDistributorInventory.Office__r = new Zone__c (ZoneCode__c=csvRowDistributorInventory[0].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                         ObjDistributorInventory.Fiscal_Year__c = csvRowDistributorInventory[1].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                         ObjDistributorInventory.Month__c = csvRowDistributorInventory[2].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                         ObjDistributorInventory.Distributor__r=new Account(SAP_Code__c= '000'+csvRowDistributorInventory[3].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                         ObjDistributorInventory.Distributors_Office__c = csvRowDistributorInventory[4].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                    
                    if((csvRowDistributorInventory[5].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).length()==1){
                         ObjDistributorInventory.Area__r=new Region__c(RegionCode__c='0'+csvRowDistributorInventory[5].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                    }
                    if((csvRowDistributorInventory[5].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).length()==2){
                         ObjDistributorInventory.Area__r=new Region__c(RegionCode__c=csvRowDistributorInventory[5].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                    }
                    
                    //Material = Sales org (csv row [7]) + dist channel (10) + Div (10) + SKU Combination Key (csv row [6])
                    if((csvRowDistributorInventory[6].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).length()==6){
                         ObjDistributorInventory.Material__r=new SKU__c(Combination_Key__c=(csvRowDistributorInventory[7].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim())+'10'+'10'+'000000000000'+csvRowDistributorInventory[6].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                       }
                    if((csvRowDistributorInventory[6].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).length()==7){
                         ObjDistributorInventory.Material__r=new SKU__c(Combination_Key__c=(csvRowDistributorInventory[7].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim())+'10'+'10'+'00000000000'+csvRowDistributorInventory[6].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                       }
                         ObjDistributorInventory.Single_pack_number__c = Decimal.ValueOf(csvRowDistributorInventory[8].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                         ObjDistributorInventory.Pesticidal_Year__c = csvRowDistributorInventory[9].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                         ObjDistributorInventory.Price_Per_Single_Bottle__c = csvRowDistributorInventory[10].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                         ObjDistributorInventory.Amount_JPY__c = csvRowDistributorInventory[11].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                         ObjDistributorInventory.Single_Bottle_In_Case__c = csvRowDistributorInventory[12].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                         ObjDistributorInventory.Calendar_Year__c = csvRowDistributorInventory[13].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                         ObjDistributorInventory.Japan_Region__c = csvRowDistributorInventory[14].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();                        
                         ObjDistributorInventory.Number_in_case__c = Decimal.ValueOf(csvRowDistributorInventory[15].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                    }          
                    
                     
        //Extra column for Id if operation type is Update
        if(operationType=='Update'){
        system.debug('size of column ---> '+csvRowDistributorInventory.size());
            if(csvRowDistributorInventory.size()!=updatecsv) throw new OtherException('Incorrect CSV');
                     
                        ObjDistributorInventory.Id = csvRowDistributorInventory[0].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                  
                        if(AccountMap.containsKey('000'+csvRowDistributorInventory[4].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim())){
                          ObjDistributorInventory.OwnerId = AccountMap.get('000'+csvRowDistributorInventory[4].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).OwnerId;
                        } 
                    
                         ObjDistributorInventory.Office__r = new Zone__c (ZoneCode__c=csvRowDistributorInventory[1].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                         ObjDistributorInventory.Fiscal_Year__c = csvRowDistributorInventory[2].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                         ObjDistributorInventory.Month__c = csvRowDistributorInventory[3].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                         ObjDistributorInventory.Distributor__r=new Account(SAP_Code__c= '000'+csvRowDistributorInventory[4].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                         ObjDistributorInventory.Distributors_Office__c = csvRowDistributorInventory[5].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                    
                    if((csvRowDistributorInventory[6].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).length()==1){
                         ObjDistributorInventory.Area__r=new Region__c(RegionCode__c='0'+csvRowDistributorInventory[6].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                    }
                    if((csvRowDistributorInventory[6].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).length()==2){
                         ObjDistributorInventory.Area__r=new Region__c(RegionCode__c=csvRowDistributorInventory[6].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                    }
                    
                    //Material = Sales org (csv row [7]) + dist channel (10) + Div (10) + SKU Combination Key (csv row [6])
                    if((csvRowDistributorInventory[7].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).length()==6){
                         ObjDistributorInventory.Material__r=new SKU__c(Combination_Key__c=(csvRowDistributorInventory[8].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim())+'10'+'10'+'000000000000'+csvRowDistributorInventory[7].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                       }
                    if((csvRowDistributorInventory[7].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).length()==7){
                         ObjDistributorInventory.Material__r=new SKU__c(Combination_Key__c=(csvRowDistributorInventory[8].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim())+'10'+'10'+'00000000000'+csvRowDistributorInventory[7].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                       }
                         ObjDistributorInventory.Single_pack_number__c = Decimal.ValueOf(csvRowDistributorInventory[9].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                         ObjDistributorInventory.Pesticidal_Year__c = csvRowDistributorInventory[10].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                         ObjDistributorInventory.Price_Per_Single_Bottle__c = csvRowDistributorInventory[11].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                         ObjDistributorInventory.Amount_JPY__c = csvRowDistributorInventory[12].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                         ObjDistributorInventory.Single_Bottle_In_Case__c = csvRowDistributorInventory[13].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                         ObjDistributorInventory.Calendar_Year__c = csvRowDistributorInventory[14].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                         ObjDistributorInventory.Japan_Region__c = csvRowDistributorInventory[15].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                         ObjDistributorInventory.Number_in_case__c = Decimal.ValueOf(csvRowDistributorInventory[16].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                  }   
 
                        lstDistributorInventoryToInsertOrUpdate.add(ObjDistributorInventory);
      }                                         
          if(operationType=='Delete'){
               if(csvRowDistributorInventory.size()!=1) throw new OtherException('Incorrect CSV');
                        lstDistributorInventoryToDelete.add(csvRowDistributorInventory[0].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
          }
                    successListRows.add(row);

                }catch(Exception e){
                     System.debug('stack trace --->'+ e.getStackTraceString());
                    if(e.getMessage()=='Incorrect CSV'){
                        eListDistributorInventory.add(e.getMessage());
                        //return eListDistributorInventory;
                    }
                    else{
                    errorListDistributorInventory.add(row+','+e.getMessage());
                    }
                    
                }
            }
        //    update objVersion;
        
        
        //Handling Delete operation and Delete results
           if(operationType=='Delete' && lstDistributorInventoryToDelete.size()>0){
                 DrListDistributorInventory=Database.delete(lstDistributorInventoryToDelete, false); 
                    if(DrListDistributorInventory!=null){
                       for(Integer i=0;i<DrListDistributorInventory.size();i++){      
                         if(!DrListDistributorInventory[i].isSuccess()){
                            errs=DrListDistributorInventory[i].getErrors();
                            errorListDistributorInventory.add(lstCSVLines[i+1]+','+errs[0].getMessage()); 
                            eListDistributorInventory.add(DrListDistributorInventory[i].getErrors()[0].getMessage()); 
                         }
                        else {
                           system.debug('List of success--->'+lstDistributorInventoryToDelete[i]);
                           system.debug('lstcsvlines--->'+lstCSVLines[i+1]);
                           successListDistributorInventory.add(lstDistributorInventoryToDelete[i]+','+successListRows[i]);                  
                        }
                      } 
                   }
                  else if(DrListDistributorInventory==null){
                    for(Integer i=0;i<errorListDistributorInventory.size();i++){ 
                      eListDistributorInventory.add(errorListDistributorInventory[i]);
                    }
                  }
                }
            else{
                 System.debug('Data Not Found');
            }
            
            
        //Handling Insert and Update   
            If(operationType=='Insert' || operationType=='Update')  {
            if(lstDistributorInventoryToInsertOrUpdate.size()>0){
                System.debug('lstAccsToInsertOrUpdate====> '+lstDistributorInventoryToInsertOrUpdate);   
                if(operationType=='Insert'){
                     strListDistributorInventory=Database.insert(lstDistributorInventoryToInsertOrUpdate,false);
                }
                if(operationType=='Update'){
                    strListDistributorInventory=Database.update(lstDistributorInventoryToInsertOrUpdate,false);
                }
                
               
            }else{
                 System.debug('Data Not Found');
            }
             System.debug('listtoInsertOrUpdate--->'+lstDistributorInventoryToInsertOrUpdate);
             System.debug('strList====> '+strListDistributorInventory);
            if(strListDistributorInventory!=null){
            for(Integer i=0;i<strListDistributorInventory.size();i++){      
                if(!strListDistributorInventory[i].isSuccess()){
                    errs=strListDistributorInventory[i].getErrors();
                    errorListDistributorInventory.add(lstCSVLines[i+1]+','+errs[0].getMessage()); 
                    eListDistributorInventory.add(strListDistributorInventory[i].getErrors()[0].getMessage()); 
                }
                else {
                    system.debug('List of success--->'+lstDistributorInventoryToInsertOrUpdate[i]);
                    //system.debug('lstcsvlines--->'+lstCSVLines[i+1]);
                    successListDistributorInventory.add(lstDistributorInventoryToInsertOrUpdate[i].get('Id')+','+successListRows[i]);                  
                }
              } 
            }
            else if(strListDistributorInventory==null){
                for(Integer i=0;i<errorListDistributorInventory.size();i++){ 
                eListDistributorInventory.add(errorListDistributorInventory[i]);
                }
            }
         }            
            
            sendMail(String.join(errorListDistributorInventory,'\r\n'),String.join(successListDistributorInventory,'\r\n'),errorListDistributorInventory.size()-1,successListDistributorInventory.size()-1,'Distributor Inventory');
            
 
    }
    
    @future
    public static void uploadShipmentData(list<String> lstCSVLines, String operationType,String header)
    {   
        lstCSVLines.add(0,header);
        
           list<Account> AllJapanAccounts = new list<Account>([SELECT Id, SAP_Code__c, OwnerId FROM Account WHERE Sales_Org_Code__c='6781' OR Sales_Org_Code__c='6731']);
        Map<string, Account> AccountMap = new Map<string, Account>();
        for(Account a : AllJapanAccounts){
            if(!AccountMap.containsKey(a.SAP_Code__c)){
            AccountMap.put(a.SAP_Code__c, a);
          }  
        }
        
        
        String row='';
        list<Ex_Distributor_Shipment_Data__c> lstExDistributorShipmentDataToInsertOrUpdate = new list<Ex_Distributor_Shipment_Data__c>();
        List<Id> lstExDistributorShipmentDataToDelete = new list<Id>();
        
        Database.DeleteResult[] DrListExDistributorShipmentData;
        Database.SaveResult[] strListExDistributorShipmentData;
        List<String> errorListExDistributorShipmentData=new List<String>();
        List<String> successListExDistributorShipmentData=new List<String>();
        String combinationKey = '';
        List<String> eListExDistributorShipmentData=new List<String>();
        List<String> successListRows= new List<String>();
        Database.Error[] errs;
            //lstCSVLines[0] = lstCSVLines[0].replaceAll('\n',' ');
            successListExDistributorShipmentData.add(system.label.FU_Record_ID+','+header);
            errorListExDistributorShipmentData.add(header+','+system.label.FU_Error_Description);
            for(Integer i = 1; i < lstCSVLines.size(); i++){
                Ex_Distributor_Shipment_Data__c ObjExDistributorShipmentData=new Ex_Distributor_Shipment_Data__c();
                row=lstCSVLines[i];
                system.debug('lstCSVLines '+lstCSVLines[i]);

                 String csvLine = String.valueOf(lstCSVLines[i]);
                 String prevLine = csvLine;
                 Integer startIndex;
                 Integer endIndex;

        while(csvLine.indexOf('"') > -1){
        
            if(startIndex == null){
                startIndex = csvLine.indexOf('"');
                csvLine = csvLine.substring(0, startIndex) + ':quotes:' + csvLine.substring(startIndex+1, csvLine.length());
            }else{
                if(endIndex == null){
                    endIndex = csvLine.indexOf('"');
                    csvLine = csvLine.substring(0, endIndex) + ':quotes:' + csvLine.substring(endIndex+1, csvLine.length());
                }
            }
            
            if(startIndex != null && endIndex != null){
                String sub = csvLine.substring(startIndex, endIndex);
                sub = sub.replaceAll(',', ':comma:');
                csvLine = csvLine.substring(0, startIndex) + sub + csvLine.substring(endIndex, csvLine.length());
                startIndex = null;
                endIndex = null;
            }
        }

                list<String> csvRowExDistributorShipmentData = csvLine.split(',');
                
                try{

   if(operationType=='Insert' || operationType=='Update'){  
       system.debug('operation type--->'+operationType);
         if(operationType=='Insert'){
             if(csvRowExDistributorShipmentData.size()!=25) throw new OtherException('Incorrect CSV');
                  
                        if(AccountMap.containsKey('000'+csvRowExDistributorShipmentData[8].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim())){
                          ObjExDistributorShipmentData.OwnerId = AccountMap.get('000'+csvRowExDistributorShipmentData[8].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).OwnerId;
                    } 
                 
                     if((csvRowExDistributorShipmentData[0].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).length()==1){
                         ObjExDistributorShipmentData.Distributors_Area__r = new Region__c(RegionCode__c='0'+csvRowExDistributorShipmentData[0].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                    }
                    if((csvRowExDistributorShipmentData[0].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).length()==2){
                         ObjExDistributorShipmentData.Distributors_Area__r = new Region__c(RegionCode__c=csvRowExDistributorShipmentData[0].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                    }
                    
                        ObjExDistributorShipmentData.Chemical_IPM__c = csvRowExDistributorShipmentData[1].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        ObjExDistributorShipmentData.Office_for_Ex_Distributor_Customer__r =new Zone__c (ZoneCode__c=csvRowExDistributorShipmentData[2].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                       
                     if((csvRowExDistributorShipmentData[3].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).length()==1){
                         ObjExDistributorShipmentData.Area_in_Ex_Distributor_s_Customer__r = new Region__c(RegionCode__c='0'+csvRowExDistributorShipmentData[3].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                    }
                    if((csvRowExDistributorShipmentData[3].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).length()==2){
                         ObjExDistributorShipmentData.Area_in_Ex_Distributor_s_Customer__r = new Region__c(RegionCode__c=csvRowExDistributorShipmentData[3].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                    }
                    
                     	ObjExDistributorShipmentData.Sales_Office_Area_in_Distributor__r =  new Zone__c (ZoneCode__c=csvRowExDistributorShipmentData[4].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                        ObjExDistributorShipmentData.Sales_Office_Area_in_Distributor_Text__c =  csvRowExDistributorShipmentData[4].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        ObjExDistributorShipmentData.UPL_FY__c =csvRowExDistributorShipmentData[5].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        ObjExDistributorShipmentData.Calendar_Year__c =csvRowExDistributorShipmentData[6].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        ObjExDistributorShipmentData.Month__c =csvRowExDistributorShipmentData[7].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        ObjExDistributorShipmentData.Distributor__r=new Account(SAP_Code__c='000'+csvRowExDistributorShipmentData[8].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                        ObjExDistributorShipmentData.Customer_Name__c=csvRowExDistributorShipmentData[9].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                    //    ObjExDistributorShipmentData.Distributor_s_Office__r = new Zone__c (ZoneCode__c=csvRowExDistributorShipmentData[10].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                        ObjExDistributorShipmentData.Distributor_s_Office_Text__c = csvRowExDistributorShipmentData[10].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        ObjExDistributorShipmentData.Region_in_Ex_Distributor_s_Customer__c = csvRowExDistributorShipmentData[11].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        ObjExDistributorShipmentData.District_in_Ex_Distributor_s_Customer__c = csvRowExDistributorShipmentData[12].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        ObjExDistributorShipmentData.Customer_Category__c = csvRowExDistributorShipmentData[13].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        ObjExDistributorShipmentData.JA_Area_Name__c = csvRowExDistributorShipmentData[14].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        ObjExDistributorShipmentData.Volume__c = Decimal.ValueOf(csvRowExDistributorShipmentData[15].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                        ObjExDistributorShipmentData.Pesticidal_Year__c = csvRowExDistributorShipmentData[16].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        ObjExDistributorShipmentData.Price_per_single_bottle_bag__c = Decimal.ValueOf(csvRowExDistributorShipmentData[17].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                        ObjExDistributorShipmentData.Amount_JPY__c = Decimal.ValueOf(csvRowExDistributorShipmentData[18].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                        ObjExDistributorShipmentData.Order_Type__c = csvRowExDistributorShipmentData[19].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                      //Material = Sales org (csv row [21]) + dist channel (10) + Div (10) + SKU Combination Key (csv row [20])
                    if((csvRowExDistributorShipmentData[20].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).length()==6){  
                        ObjExDistributorShipmentData.Material__r = new SKU__c(Combination_Key__c=(csvRowExDistributorShipmentData[21].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim())+'10'+'10'+'000000000000'+csvRowExDistributorShipmentData[20].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                       }
                    if((csvRowExDistributorShipmentData[20].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).length()==7){  
                        ObjExDistributorShipmentData.Material__r = new SKU__c(Combination_Key__c=(csvRowExDistributorShipmentData[21].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim())+'10'+'10'+'00000000000'+csvRowExDistributorShipmentData[20].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                       }
                        ObjExDistributorShipmentData.Customer_Address__c = csvRowExDistributorShipmentData[22].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        ObjExDistributorShipmentData.Single_bottle_bag_number_in_Case__c = Decimal.ValueOf(csvRowExDistributorShipmentData[23].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                        ObjExDistributorShipmentData.Unit_Of_Measurement__c = csvRowExDistributorShipmentData[24].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
        }
                    
       //Extra column for Id if operation type is update
       if(operationType=='Update'){
           
           system.debug('size of column ---> '+csvRowExDistributorShipmentData.size());
            if(csvRowExDistributorShipmentData.size()!=26) throw new OtherException('Incorrect CSV');
           
                        ObjExDistributorShipmentData.Id = csvRowExDistributorShipmentData[0].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                    
                    if(AccountMap.containsKey('000'+csvRowExDistributorShipmentData[9].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim())){
                          ObjExDistributorShipmentData.OwnerId = AccountMap.get('000'+csvRowExDistributorShipmentData[9].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).OwnerId;
                    } 
                    
                    
                     if((csvRowExDistributorShipmentData[1].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).length()==1){
                         ObjExDistributorShipmentData.Distributors_Area__r = new Region__c(RegionCode__c='0'+csvRowExDistributorShipmentData[1].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                    }
                    if((csvRowExDistributorShipmentData[1].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).length()==2){
                         ObjExDistributorShipmentData.Distributors_Area__r = new Region__c(RegionCode__c=csvRowExDistributorShipmentData[1].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                    }
                    
                        ObjExDistributorShipmentData.Chemical_IPM__c = csvRowExDistributorShipmentData[2].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        ObjExDistributorShipmentData.Office_for_Ex_Distributor_Customer__r =new Zone__c (ZoneCode__c=csvRowExDistributorShipmentData[3].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                       
                     if((csvRowExDistributorShipmentData[4].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).length()==1){
                         ObjExDistributorShipmentData.Area_in_Ex_Distributor_s_Customer__r = new Region__c(RegionCode__c='0'+csvRowExDistributorShipmentData[4].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                    }
                    if((csvRowExDistributorShipmentData[4].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).length()==2){
                         ObjExDistributorShipmentData.Area_in_Ex_Distributor_s_Customer__r = new Region__c(RegionCode__c=csvRowExDistributorShipmentData[4].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                    }
                    
                     	ObjExDistributorShipmentData.Sales_Office_Area_in_Distributor__r =  new Zone__c (ZoneCode__c=csvRowExDistributorShipmentData[5].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                        ObjExDistributorShipmentData.Sales_Office_Area_in_Distributor_Text__c = csvRowExDistributorShipmentData[5].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        ObjExDistributorShipmentData.UPL_FY__c =csvRowExDistributorShipmentData[6].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        ObjExDistributorShipmentData.Calendar_Year__c =csvRowExDistributorShipmentData[7].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        ObjExDistributorShipmentData.Month__c =csvRowExDistributorShipmentData[8].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        ObjExDistributorShipmentData.Distributor__r=new Account(SAP_Code__c='000'+csvRowExDistributorShipmentData[9].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                        ObjExDistributorShipmentData.Customer_Name__c=csvRowExDistributorShipmentData[10].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                    //    ObjExDistributorShipmentData.Distributor_s_Office__r = new Zone__c (ZoneCode__c=csvRowExDistributorShipmentData[11].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                        ObjExDistributorShipmentData.Distributor_s_Office_Text__c = csvRowExDistributorShipmentData[11].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        ObjExDistributorShipmentData.Region_in_Ex_Distributor_s_Customer__c = csvRowExDistributorShipmentData[12].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        ObjExDistributorShipmentData.District_in_Ex_Distributor_s_Customer__c = csvRowExDistributorShipmentData[13].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        ObjExDistributorShipmentData.Customer_Category__c = csvRowExDistributorShipmentData[14].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        ObjExDistributorShipmentData.JA_Area_Name__c = csvRowExDistributorShipmentData[15].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        ObjExDistributorShipmentData.Volume__c = Decimal.ValueOf(csvRowExDistributorShipmentData[16].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                        ObjExDistributorShipmentData.Pesticidal_Year__c = csvRowExDistributorShipmentData[17].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        ObjExDistributorShipmentData.Price_per_single_bottle_bag__c = Decimal.ValueOf(csvRowExDistributorShipmentData[18].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                        ObjExDistributorShipmentData.Amount_JPY__c = Decimal.ValueOf(csvRowExDistributorShipmentData[19].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                        ObjExDistributorShipmentData.Order_Type__c = csvRowExDistributorShipmentData[20].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                      //Material = Sales org (csv row [22]) + dist channel (10) + Div (10) + SKU Combination Key (csv row [21])
                      String Material='';    
                    if((csvRowExDistributorShipmentData[21].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).length()==6){  
                        Material = (csvRowExDistributorShipmentData[22].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim())+'10'+'10'+'000000000000'+csvRowExDistributorShipmentData[21].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();           
                        SKU__c skuref= new SKU__c(Combination_Key__c=Material);
                        ObjExDistributorShipmentData.Material__r = skuref;
                       }
                    if((csvRowExDistributorShipmentData[21].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).length()==7){  
                       Material = (csvRowExDistributorShipmentData[22].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim())+'10'+'10'+'00000000000'+csvRowExDistributorShipmentData[21].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();           
                        //  ObjExDistributorShipmentData.Material__r = new SKU__c(Combination_Key__c=Material);
                          SKU__c skuref= new SKU__c(Combination_Key__c=Material);
                         ObjExDistributorShipmentData.Material__r = skuref;
                       }
 
                        ObjExDistributorShipmentData.Customer_Address__c = csvRowExDistributorShipmentData[23].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                        ObjExDistributorShipmentData.Single_bottle_bag_number_in_Case__c = Decimal.ValueOf(csvRowExDistributorShipmentData[24].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                            ObjExDistributorShipmentData.Unit_Of_Measurement__c = csvRowExDistributorShipmentData[25].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                         
                        /* ------DEPRECATED -------
                        * Combination key = Distributor code + Office code + Area + Material code + Month + cal year + Customer name (8,10,3,20,7,6,9)
                        ObjExDistributorShipmentData.Combination_Key__c = (csvRowExDistributorShipmentData[8] + csvRowExDistributorShipmentData[10] + csvRowExDistributorShipmentData[3] + csvRowExDistributorShipmentData[20] + csvRowExDistributorShipmentData[7] + csvRowExDistributorShipmentData[6] + csvRowExDistributorShipmentData[9]).replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '');
                       */
           }
                    
                        lstExDistributorShipmentDataToInsertOrUpdate.add(ObjExDistributorShipmentData);
   }                                        
          if(operationType=='Delete'){
                if(csvRowExDistributorShipmentData.size()!=1) throw new OtherException('Incorrect CSV');
                         lstExDistributorShipmentDataToDelete.add(csvRowExDistributorShipmentData[0].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
               
          }
                    
                    successListRows.add(row);
                    
                }catch(Exception e){
                     System.debug('stack trace --->'+ e.getStackTraceString());
                    if(e.getMessage()=='Incorrect CSV'){
                        eListExDistributorShipmentData.add(e.getMessage());
                        //return eListExDistributorShipmentData;
                    }
                    else{
                    errorListExDistributorShipmentData.add(row+','+e.getMessage());
                    }
                }
            }
         
            //Handling Delete operation and Delete results
           if(operationType=='Delete' && lstExDistributorShipmentDataToDelete.size()>0){
                 DrListExDistributorShipmentData=Database.delete(lstExDistributorShipmentDataToDelete, false); 
               
                    if(DrListExDistributorShipmentData!=null){
                       for(Integer i=0;i<DrListExDistributorShipmentData.size();i++){      
                         if(!DrListExDistributorShipmentData[i].isSuccess()){
                             system.debug('if not success');
                            errs=DrListExDistributorShipmentData[i].getErrors();
                            errorListExDistributorShipmentData.add(lstCSVLines[i+1]+','+errs[0].getMessage()); 
                            eListExDistributorShipmentData.add(DrListExDistributorShipmentData[i].getErrors()[0].getMessage()); 
                         }
                        else {
                            system.debug('if success');
                           system.debug('List of success--->'+lstExDistributorShipmentDataToDelete[i]);
                           system.debug('lstcsvlines--->'+lstCSVLines[i+1]);
                           successListExDistributorShipmentData.add(lstExDistributorShipmentDataToDelete[i]+','+successListRows[i]);                  
                        }
                      } 
                   }
                  else if(DrListExDistributorShipmentData==null){
                      system.debug('If null');
                    for(Integer i=0;i<errorListExDistributorShipmentData.size();i++){ 
                      eListExDistributorShipmentData.add(errorListExDistributorShipmentData[i]);
                    }
                  }
                }
            else{
                 System.debug('Data Not Found');
            }      


            
           //Handling Insert and Update
            If(operationType=='Insert' || operationType=='Update'){
            if(lstExDistributorShipmentDataToInsertOrUpdate.size()>0){
                System.debug('lstAccsToUpsert====> '+lstExDistributorShipmentDataToInsertOrUpdate);   
                if(operationType=='Insert'){
                    strListExDistributorShipmentData=Database.insert(lstExDistributorShipmentDataToInsertOrUpdate,false);
                }
                if(operationType=='Update'){
                    strListExDistributorShipmentData=Database.update(lstExDistributorShipmentDataToInsertOrUpdate,false);
                }
                
            }else{
                 System.debug('Data Not Found');
            }
             System.debug('strList====> '+strListExDistributorShipmentData);
            
            if(strListExDistributorShipmentData!=null){
            for(Integer i=0;i<strListExDistributorShipmentData.size();i++){      
                if(!strListExDistributorShipmentData[i].isSuccess()){
                    errs=strListExDistributorShipmentData[i].getErrors();
                    errorListExDistributorShipmentData.add(lstCSVLines[i+1]+','+errs[0].getMessage());
                    eListExDistributorShipmentData.add(strListExDistributorShipmentData[i].getErrors()[0].getMessage()); 
                }
                else {
                    successListExDistributorShipmentData.add(lstExDistributorShipmentDataToInsertOrUpdate[i].get('Id')+','+successListRows[i]);                   
                }
              } 
            }
            else if(strListExDistributorShipmentData==null){
                for(Integer i=0;i<errorListExDistributorShipmentData.size();i++){
                eListExDistributorShipmentData.add(errorListExDistributorShipmentData[i]);
                }
            }
            }
            sendMail(String.join(errorListExDistributorShipmentData,'\r\n'),String.join(successListExDistributorShipmentData,'\r\n'),errorListExDistributorShipmentData.size()-1,successListExDistributorShipmentData.size()-1,'Ex-Distributor Shipment Data');
            
    
    }  
    
    public static void sendMail(String err,String scc,Integer errCount,Integer sccCount,String mailUnit){
        Messaging.EmailFileAttachment successAttach = new Messaging.EmailFileAttachment();
        successAttach.setContentType('application/csv');
        successAttach.setFileName('Success.csv');
        successAttach.setInline(false);
        successAttach.Body = Blob.valueOf(scc);

        Messaging.EmailFileAttachment errorAttach = new Messaging.EmailFileAttachment();
        errorAttach.setContentType('application/csv');
        errorAttach.setFileName('Error.csv');
        errorAttach.setInline(false);
        errorAttach.Body = Blob.valueOf(err);

        DateTime d = Date.Today() ;
        String dateString =  d.format('dd/MM/yyyy') ;

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        mail.setToAddresses(new String[] {UserInfo.getUserEmail()});
        mail.setSenderDisplayName('Salesforce Support');
        mail.setBccSender(false);
        mail.setUseSignature(false);

        if(mailUnit=='Distributor Inventory'){
            mail.setSubject(system.label.FU_Subject_Line_DI);
            mail.setPlainTextBody(system.label.FU_Plain_Text_Body_DI);
            mail.setHtmlBody(system.label.FU_Dear_User+'<br/><br/>'+system.label.FU_Please_Find_DI+'<br/><br/>'+system.label.Japan_Incorrect_CSV+'<br/><br/>'+system.label.FU_Date+ ' '+dateString+'<br/><br/>'+system.label.FU_No_Of_Errors+' '+errCount+'<br/><br/>'+system.label.FU_No_Of_Success+' '+sccCount+'<br/><br/>'+system.label.FU_Regards+'<br/>'+system.label.FU_UPL_SA+'<br />');
        }
        if(mailUnit=='Ex-Distributor Shipment Data'){
            mail.setSubject(system.label.FU_Subject_Line_OGS);
            mail.setPlainTextBody(system.label.FU_Plain_Text_Body_OGS);
            mail.setHtmlBody(system.label.FU_Dear_User+'<br/><br/>'+system.label.FU_Please_Find_OGS+'<br/><br/>'+system.label.Japan_Incorrect_CSV+'<br/><br/>'+system.label.FU_Date+ ' '+dateString+'<br/><br/>'+system.label.FU_No_Of_Errors+' '+errCount+'<br/><br/>'+system.label.FU_No_Of_Success+' '+sccCount+'<br/><br/>'+system.label.FU_Regards+'<br/>'+system.label.FU_UPL_SA+'<br />');
        }
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {successAttach,errorAttach}); 

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
  
}