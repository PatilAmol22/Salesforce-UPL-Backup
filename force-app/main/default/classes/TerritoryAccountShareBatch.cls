/*
@Author : Pranav Dinakaran
@Class_Description : Batch to Share all Tehsil Account data with TM.
*/
global class TerritoryAccountShareBatch implements Database.Batchable<sObject>{
Public List<AccountShare> AccountShareList;
public String Query;
public String UserID;
public STring ActionFlag;
public List<TM_District_Tehsil_Mapping__c> TehsilTmMappingList;

// Constructor based on input parametrs we retireve TM_District_Tehsil_Mapping__c record and Prepare Query String to retrieve all related Account Records of particular Tehsil_Name
global TerritoryAccountShareBatch(String TehsilName , String TerritoryMGr , String Mapping_ID){
      // retrieve TM_District_Tehsil_Mapping__c Record
      TehsilTmMappingList = new List<TM_District_Tehsil_Mapping__c>([select id, name,District__c,RecordShared__c,Tehsil__c, Tehsil__r.Name,Territory__c,TM_User__c 
                                                                                                                                                  from TM_District_Tehsil_Mapping__c
                                                                                                                                                  where id=: Mapping_ID]);
      AccountShareList = new List<AccountShare>();
      
      // Query string to retrieve all Accounts belonging to particular Tehsil
      Query = 'Select id, Name, Tehsil__pc from Account where isPersonAccount = True AND Tehsil__pc =\'' +TehsilName+'\'';
      System.debug('Query String :::'+ Query);
      UserID = TerritoryMGr;
      
    System.Debug('Territory User :::'+ UserID);
}

// Start Method retrieve all Accounts
global Database.Querylocator start(Database.BatchableContext bc){    
  System.debug('--------Start---------');
   
    
    system.debug('Query Result:::'+ database.getQueryLocator(query));
    
        return database.getQueryLocator(query);
     
    
}
// Create AccountSHare Record and share Record to TerritoryMGr 
global void execute(Database.BatchableContext bc, List<Sobject> scope){
  System.debug('--------Start---------');
  System.debug('------Scope  :::'+Scope);  
 

      for(Sobject acc : Scope){
         AccountShare  AcntShareObj = new AccountShare();
          AcntShareObj.AccountAccessLevel ='Read';
          AcntShareObj.CaseAccessLevel ='Read';
          AcntShareObj.OpportunityAccessLevel ='Read';
          AcntShareObj.AccountID = acc.id;
          AcntShareObj.UserOrGroupId = UserID; 
          AccountShareList.add(AcntShareObj);
      }
      if(AccountShareList.size()>0)
         Database.Insert(AccountShareList,false);
    
   
}

// After Sharing all Accounts to TerritoryMGr  update TM_District_Tehsil_Mapping__c record RecordShared__c Boolean flag to true
global void finish(Database.BatchableContext bc){
  System.debug('--------Finish---------');  
  TehsilTmMappingList[0].RecordShared__c = True;
  update TehsilTmMappingList;
  List<TM_District_Tehsil_Mapping__c> ExistingMappingList = new List<TM_District_Tehsil_Mapping__c>();
ExistingMappingList = [select id, name,District__c,RecordShared__c,Tehsil__c, Tehsil__r.Name,Territory__c,TM_User__c 
                                                                                          from TM_District_Tehsil_Mapping__c
                                                                                           where RecordShared__c = False AND DeleteRequested__c = False limit 1];
     if(ExistingMappingList.size()>0)
     Database.executeBatch(new TerritoryAccountShareBatch(String.valueof(ExistingMappingList[0].Tehsil__r.Name),String.Valueof(ExistingMappingList[0].TM_User__c),String.valueof(ExistingMappingList[0].id)),5000); 
    
}

}