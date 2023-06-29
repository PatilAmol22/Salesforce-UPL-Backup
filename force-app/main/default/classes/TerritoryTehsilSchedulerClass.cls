/*
@Author : Pranav Dinakaran
@Class_Description : General Class which is called from schedular to execute batch to share TM Tehsil Data, 
                        where based on the parameter passed call appropriate Batch.
*/
public class TerritoryTehsilSchedulerClass{
public List<TM_District_Tehsil_Mapping__c> TmTehsilMappinglist;

// Parameterised Constructor where based on the parameter call Insert or Delete   
    public TerritoryTehsilSchedulerClass(String Action){
        TmTehsilMappinglist = new List<TM_District_Tehsil_Mapping__c>();
        
        // If Parameter String is 'Create' Then retrieve TM_District_Tehsil_Mapping__c record where Sharing is not Take Placed and pass it to batch 
        if(Action =='Create'){
            TmTehsilMappinglist = [select id, name,District__c,RecordShared__c,Tehsil__c, Tehsil__r.Name,Territory__c,TM_User__c
                                                                                                         from TM_District_Tehsil_Mapping__c
                                                                                                          where RecordShared__c = False AND DeleteRequested__c = False limit 1 ];
            // Call Creation Batch pass Tehsil Name ,TM User and Mapping Record id.
            if(TmTehsilMappinglist .size()>0){
                Database.executeBatch(new TerritoryAccountShareBatch(String.valueof(TmTehsilMappinglist[0].Tehsil__r.Name),String.Valueof(TmTehsilMappinglist[0].TM_User__c),String.valueof(TmTehsilMappinglist[0].id)),5000); 
            }                                                                                                     
          }
          
          // If Parameter String is 'Delete' Then retrieve TM_District_Tehsil_Mapping__c record where Sharing is done and delete Requested falg is True, pass it to batch .
          else if(Action == 'Delete'){
              TmTehsilMappinglist = [select id, name,District__c,RecordShared__c,Tehsil__c, Tehsil__r.Name,Territory__c,TM_User__c
                                                                                                         from TM_District_Tehsil_Mapping__c           
                                                                                                         where DeleteRequested__c = True limit 1];
            
             // Call Delet Batch pass Tehsil Name ,TM User and Mapping Record id.                                                                                                
            if(TmTehsilMappinglist .size()>0){
                Database.executeBatch(new TerritoryAccountShareDeleteBatch(String.valueof(TmTehsilMappinglist[0].Tehsil__r.Name),String.Valueof(TmTehsilMappinglist[0].TM_User__c),String.valueof(TmTehsilMappinglist[0].id)),5000); 
            }  
          }
    }
}