global class OpeningInventorySchedularSWAL implements Schedulable{
     global list<Period> lstPeriod;
     global list<Liquidation_Annual_Plan__c> lstLiqdtnAnnlPln;
    
     global void execute(SchedulableContext SC) {
         /*
         try{   
              string query = '';
              Date endDate;
              Date startDate;
              lstPeriod = [SELECT FiscalYearSettings.Name,StartDate,EndDate,type  FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY];
           
             system.debug('lstPeriod'+lstPeriod);
             system.debug('lstPeriod'+lstPeriod[0].Enddate);
             system.debug('lstPeriod'+lstPeriod[0].StartDate);
             if(lstPeriod.size()>0){
                  endDate = lstPeriod[0].EndDate; 
                  startDate = lstPeriod[0].StartDate;    
                  string sDate = string.valueOfGmt(startDate);
                  String eDate = string.valueOfGmt(endDate);
                  lstLiqdtnAnnlPln =[SELECT Name,Id,FIscal_Year__c,SentToBatch__c,Territory_Name__c,Fiscal_Start_Date__c,Fiscal_End_Date__c,Sales_Qty_External_Key_Annual_Plan__c FROM Liquidation_Annual_Plan__c WHERE Fiscal_Start_Date__c =:startDate AND Fiscal_End_Date__c =:endDate AND SentToBatch__c = false AND RecordType.Name='SWAL TRADE' AND Sales_Org__r.Sales_Org_Code__c='1210'  LIMIT 1];
                  system.debug('Hello'+lstLiqdtnAnnlPln.size());
                   String recordTypeName = 'SWAL TRADE';
                   String orgCode= '1210';
                  if(Test.isRunningTest()){
                      lstLiqdtnAnnlPln =[SELECT Name,Id,FIscal_Year__c,SentToBatch__c,Sales_Qty_External_Key_Annual_Plan__c,Territory_Name__c,Fiscal_Start_Date__c,Fiscal_End_Date__c FROM Liquidation_Annual_Plan__c WHERE SentToBatch__c = false AND RecordType.Name='SWAL Trade' AND Sales_Org__r.Sales_Org_Code__c='1210'  LIMIT 1];
                  }
                  if(lstLiqdtnAnnlPln.size()>0){
                      system.debug('Hello');
                  query = 'SELECT Name,Id,SentToBatch__c,FIscal_Year__c,Territory_Name__c,Fiscal_Start_Date__c,Fiscal_End_Date__c,Sales_Qty_External_Key_Annual_Plan__c FROM Liquidation_Annual_Plan__c WHERE Fiscal_Start_Date__c ='+sDate.split(' ')[0]+' AND RecordType.Name=\''+String.escapeSingleQuotes(recordTypeName) +'\' AND Fiscal_End_Date__c ='+eDate.split(' ')[0]+' AND SentToBatch__c = false AND Sales_Org__r.Sales_Org_Code__c=\''+orgCode+'\' Limit 1';
                  if(Test.isRunningTest()){
                    query = 'SELECT Name,Id,SentToBatch__c,FIscal_Year__c,Territory_Name__c,Fiscal_Start_Date__c,Fiscal_End_Date__c,Sales_Qty_External_Key_Annual_Plan__c FROM Liquidation_Annual_Plan__c WHERE  SentToBatch__c = false AND AND RecordType.Name='+recordTypeName+' AND Sales_Org__r.Sales_Org_Code__c=\''+orgCode+'\' Limit 1';
                  }
                      
                    system.debug('query');
                    system.debug(query);
                      OpeningInventoryBatchSWAL opnInvBtObj = new OpeningInventoryBatchSWAL(query); 
                       database.executebatch(opnInvBtObj,1);


                  }
              }
             }
             catch(Exception e){
                 System.debug('Exception>>----->'+e);
             }*/
          }
    
}