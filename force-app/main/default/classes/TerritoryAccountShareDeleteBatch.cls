/*
@Author : Pranav Dinakaran
@Class_Description : Batch to delete Sharing data of TM-Teshil data
*/
global class TerritoryAccountShareDeleteBatch implements Database.Batchable<sObject>{
Public List<AccountShare> AccountShareList;
public String Query;
public String UserID;
public String MappingRecordID;
public List<TM_District_Tehsil_Mapping__c> TehsilTmMappingList;

// Constructor based on input parametrs we retireve TM_District_Tehsil_Mapping__c record and Prepare Query String to retrieve all  AccountShare  Records of particular Tehsil_Name
global TerritoryAccountShareDeleteBatch(String TehsilName , String TerritoryMGr, String Mapping_ID){
         // retrieve TM_District_Tehsil_Mapping__c Record
         TehsilTmMappingList = new List<TM_District_Tehsil_Mapping__c>([select id, name,District__c,RecordShared__c,Tehsil__c, Tehsil__r.Name,Territory__c,TM_User__c 
                                                                                                                                                  from TM_District_Tehsil_Mapping__c
                                                                                                                                                  where id=: Mapping_ID]);
         AccountShareList = new List<AccountShare>();
         
           // Query string to retrieve all AccountsShare  belonging to particular Tehsil
         Query = 'SELECT Id, RowCause, UserOrGroupId, Account.Tehsil__pc FROM AccountShare where UserOrGroupId =\''+TerritoryMGr+'\' AND Account.Tehsil__pc =\''+TehsilName+'\' AND RowCause=\'Manual\'';
  
  System.debug('Query String :::'+ Query);
    UserID = TerritoryMGr;
  
    System.Debug('Territory User :::'+ UserID);
}
// Start Method retrieve all AccountsShare Record
global Database.Querylocator start(Database.BatchableContext bc){    
  System.debug('--------Start---------');
   
    
    system.debug('Query Result:::'+ database.getQueryLocator(query));
    
        return database.getQueryLocator(query);
     
    
}

// Delete AccountSHare Record 
global void execute(Database.BatchableContext bc, List<Sobject> scope){
  System.debug('--------Start---------');
  System.debug('------Scope  :::'+Scope);  
 
         Database.delete(scope, false);
     
    
}

// After deleting AccountSHare Record delete TM_District_Tehsil_Mapping__c record
global void finish(Database.BatchableContext bc){
  delete  TehsilTmMappingList;
  List<TM_District_Tehsil_Mapping__c> ExistingMappingList = new List<TM_District_Tehsil_Mapping__c>();
ExistingMappingList = [select id, name,District__c,RecordShared__c,Tehsil__c, Tehsil__r.Name,Territory__c,TM_User__c 
                                                                                          from TM_District_Tehsil_Mapping__c
                                                                                           where DeleteRequested__c = True limit 1];
 if(ExistingMappingList.size()>0)
     Database.executeBatch(new TerritoryAccountShareDeleteBatch(String.valueof(ExistingMappingList[0].Tehsil__r.Name),String.Valueof(ExistingMappingList[0].TM_User__c),String.valueof(ExistingMappingList[0].id)),5000);                                                                                            
  
    
}

}