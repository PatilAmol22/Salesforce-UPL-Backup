global class salesDistrictUpdateTurkeySO_Batch implements Database.Batchable<sObject>{
   public String query;
   public List<Id> salesDistrictIdList;

    
    global salesDistrictUpdateTurkeySO_Batch(List<ID> idList){
        salesDistrictIdList = idList;
    }
   
   public Database.QueryLocator start(Database.BatchableContext BC){    
     String SalesOrgCode = '7110';
     set<id> sdIdSet = new set<id>();
     List<Sales_District__c> compareList = new List<Sales_District__c>();
    
     if(salesDistrictIdList.size()>0){
	   compareList = [select id,name, SalesOrg__c, User__c from Sales_District__c where id In :salesDistrictIdList AND SalesOrg__r.Sales_Org_Code__c= :SalesOrgCode];
         system.debug('**Sales_District list -> ' +compareList);
            }
   
	if(compareList.size()>0){
	for(Sales_District__c sdlist:compareList){
	sdIdSet.add(sdlist.id);	
	}
	}
	system.debug('**Sales_District ids user map -> ' +sdIdSet);
	
      query = 'select id,name,owner.name,Sold_To_Party__c,Sold_To_Party__r.Sales_District__c from Sales_Order__c where SalesOrgCode__c= :SalesOrgCode and Sold_To_Party__r.Sales_District__c IN :sdIdSet';
	  
      return Database.getQueryLocator(query);

   }
   
   public void execute(Database.BatchableContext BC, List<Sales_Order__c> scope){
    //set<id> sdIds = new set<id>();
    List<Sales_District__c> SalesDistList = new List<Sales_District__c>();
   	list<Sales_Order__c> soOwnerUpdate = new list<Sales_Order__c>();
	map<id,list<Sales_Order__c>> salesDistrictOrderMap = new map<id,list<Sales_Order__c>>();
	Database.SaveResult[] updateResult;
   
   if(!scope.isEmpty()){
   for(Sales_Order__c newSO: scope){
   if(!salesDistrictOrderMap.containsKey(newSO.Sold_To_Party__r.Sales_District__c)){
	salesDistrictOrderMap.put(newSO.Sold_To_Party__r.Sales_District__c,new List<Sales_Order__c>());
	}
	salesDistrictOrderMap.get(newSO.Sold_To_Party__r.Sales_District__c).add(newSO);
	}
   }
   system.debug('**salesDistrictOrderMap -> '+salesDistrictOrderMap);
   
   if(salesDistrictOrderMap.size()>0){
   SalesDistList=[select id,name, SalesOrg__c, User__c from Sales_District__c where id In :salesDistrictOrderMap.keySet() AND SalesOrg__r.Sales_Org_Code__c= '7110'];
   }
   system.debug('**SalesDistList -> '+SalesDistList);
   
   	if(SalesDistList.size()>0){
	for(Sales_District__c sdLst:SalesDistList){
	for(Sales_Order__c saleord: salesDistrictOrderMap.get(sdLst.id))
	{
    saleord.OwnerId= sdLst.User__c;
        soOwnerUpdate.add(saleord);
	}
	}
	}
	
       if(soOwnerUpdate.size()>0){
	   updateResult = Database.update(soOwnerUpdate, false);
	   	system.debug('**soOwnerUpdate List -> '+soOwnerUpdate);
       }

    }
   
     public void finish(Database.BatchableContext BC){
   }
   
   }