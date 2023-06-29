global class OpeningInventoryBatch implements Database.Batchable<sObject>{
        global string query = '';
        global map<string,Opening_Inventory2__c> mapOpeningInventory; 
 
        global OpeningInventoryBatch ( string  query){
            this.query = query;
            system.debug('query'+ this.query);
            mapOpeningInventory = new map<string,Opening_Inventory2__c>();   
        }

       global Database.QueryLocator start(Database.BatchableContext BC){ 
          string query = '';
          query = this.query;
          system.debug('query>>----->'+ query);
            
          return Database.getQueryLocator(query);
       }

       global void execute(Database.BatchableContext BC, List<Liquidation_Annual_Plan__c> scope){
       list<Product2> lstProduct = new list<Product2>();
       lstProduct = [SELECT Id, Name, ProductCode, Combination_Key__c, Budget_NRV__c,Product_Code__c, Sales_Org__c, VF_Image__c, Brand_Type__c, Sales_Org_Code__c FROM Product2 WHERE IsActive = true AND Sales_Org_Code__c = '1000' AND Active_For_Liquidation__c= true];
       system.debug('lstProduct>>----->'+lstProduct.size());
       RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Opening_Inventory2__c' and Name='Trade'];
        system.debug('Record Type>>-----> '+rt);
          For(Liquidation_Annual_Plan__c  liqAnlPln : scope ){ 
              For(Product2 prdct: lstProduct){
                  /* Opening_Inventory__c OpnIntObj = new Opening_Inventory__c();
                   OpnIntObj.Product_Name__c = prdct.Id;
                   OpnIntObj.Budgeted_NRV__c = prdct.Budget_NRV__c;
                   OpnIntObj.Liquidation_Annual_Plan__c = liqAnlPln.id;
                   OpnIntObj.Territory_Name__c = liqAnlPln.Territory_Name__c;
                   OpnIntObj.Sales_Qty_External_Key_Opening_Inventory__c = prdct.Product_Code__c+liqAnlPln.Sales_Qty_External_Key_Annual_Plan__c;
                   */
                   
                   Opening_Inventory2__c opnInv2=new Opening_Inventory2__c();
                   opnInv2.Product__c= prdct.Id;
                   opnInv2.RecordTypeId= rt.Id;
                   opnInv2.Liquidation_Annual_Plan__c= liqAnlPln.id;
                   opnInv2.Territory__c= liqAnlPln.Territory_Name__c;
                   
                   
                   if(!mapOpeningInventory.containskey(prdct.Id)){
                       mapOpeningInventory.put(prdct.Id,opnInv2);
                   }
              }             
      //TODO: scope checkbox true
      liqAnlPln .SentToBatch__c = true;
      update liqAnlPln;
      }  
      system.debug('opening Inventory>>----->'+mapOpeningInventory.values());
      insert mapOpeningInventory.values();
   }

   global void finish(Database.BatchableContext BC){
   //TODO:check if checkbox true then update
       list<Period> lstPeriod = new list<Period>();
       Date endDate;
       Date startDate;
       lstPeriod = [SELECT FiscalYearSettings.Name,StartDate,EndDate,type  FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY];
          if(lstPeriod.size()>0){
                  endDate = lstPeriod[0].EndDate; 
                  startDate = lstPeriod[0].StartDate;    
                  string sDate = string.valueOfGmt(startDate);
                  String eDate = string.valueOfGmt(endDate);
       list<Liquidation_Annual_Plan__c> lstLiqdtnAnnlPln = new list<Liquidation_Annual_Plan__c>();
      String recordTypeName = 'Trade';
      String orgCode='1000';
      lstLiqdtnAnnlPln =[SELECT Name,Id,FIscal_Year__c,SentToBatch__c,Sales_Qty_External_Key_Annual_Plan__c,Territory_Name__c,Fiscal_Start_Date__c,Fiscal_End_Date__c FROM Liquidation_Annual_Plan__c WHERE Fiscal_Start_Date__c =:startDate AND RecordType.Name='Trade' AND Fiscal_End_Date__c =:endDate AND SentToBatch__c = false And Sales_Org__r.Sales_Org_Code__c='1000' LIMIT 1];
      
       string qry = 'SELECT Name,Id,SentToBatch__c,FIscal_Year__c,Territory_Name__c,Fiscal_Start_Date__c,Fiscal_End_Date__c,Sales_Qty_External_Key_Annual_Plan__c FROM Liquidation_Annual_Plan__c WHERE Fiscal_Start_Date__c ='+sDate.split(' ')[0]+' AND RecordType.Name=\''+String.escapeSingleQuotes(recordTypeName) +'\'  AND Fiscal_End_Date__c ='+eDate.split(' ')[0]+' AND Sales_Org__r.Sales_Org_Code__c=\''+orgCode+'\'  AND SentToBatch__c = false Limit 1';
       
       if(lstLiqdtnAnnlPln.size()>0){
           OpeningInventoryBatch opnInvBtObj = new OpeningInventoryBatch(qry); 
           database.executebatch(opnInvBtObj,1);
       }  
       } 
   }
}