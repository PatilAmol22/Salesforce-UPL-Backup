global without sharing class FarmerRegistrationBatch Implements Database.Batchable<sObject>,Database.Stateful{


    public Map<String,Tehsil__c> mapofTehsil = new Map<String,Tehsil__c>();
    public List<Akc_Business_dashboard__c> listAKCDashboard = new List<Akc_Business_dashboard__c>();
    public Map<String,Integer> mapTehsilCount= new Map<String,Integer>();
    public Schema.SObjectField extObj; 
    
    public String todayDate;
    
    public FarmerRegistrationBatch(){
    
         System.debug('FarmerRegistrationBatch started at-->'+ system.now());
        Date d = System.today();
        Datetime myDT = datetime.newInstance(d.year(),d.month(),d.day());
        todayDate = myDT.format('yyyy-MM-dd');
        
    }
           
    global Database.QueryLocator start(Database.BatchableContext BC){
    
        System.debug('start==>');
        String query;
        set<String> rectypeSet = new Set<String>();
        
        try{
        
            
            Id RecType1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
            rectypeSet.add(RecType1);
            Id RecType2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Marginal Farmer').getRecordTypeId();
            rectypeSet.add(RecType2);
            Id RecType3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('PreRegistered Farmer').getRecordTypeId();
            rectypeSet.add(RecType3);
            Id RecType4 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            rectypeSet.add(RecType4);
            
            
        
            query = 'SELECT Tehsil_Id__c ,RecordType.Id ';
            query += 'FROM Account ';
            query += ' WHERE (RecordType.Id IN:rectypeSet)';
            
            System.debug('query==>>'+query);
                            
        }catch(Exception ex){
        
            System.debug('ErrorLine==>'+ex.getLineNumber());
            System.debug('Error==>'+ex);
        }
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> lstOfAccount){ 
                   
            System.debug('lstOfAccount===>'+lstOfAccount.size());
            
            
            // Var Declaration ----------------
            
            Integer incVal = 0;
            
            for(Tehsil__c tehsil : [Select id From Tehsil__c]){
                 mapofTehsil.put(tehsil.Id,tehsil);    
            }
            
            for(Account acc : lstOfAccount){
            
                if(mapTehsilCount.containsKey(acc.tehsil_id__c)){
                
                     incVal = mapTehsilCount.get(acc.tehsil_id__c);
                     incVal = incVal + 1 ;
                     mapTehsilCount.put(acc.tehsil_id__c,incVal);  
                       
                }else{
                    incVal = 1;
                    mapTehsilCount.put(acc.tehsil_id__c,incVal);    
                }
            }
    }
   
    global void finish(Database.BatchableContext BC){
        System.debug('finish==>');
        
         System.debug('mapTehsilCount===>'+mapTehsilCount);
             
                
        for(String tehsilKey : mapofTehsil.keySet()){
            
            Akc_Business_dashboard__c abd = new Akc_Business_dashboard__c();
            abd.combinationKey__c=tehsilKey+''+todayDate;
            abd.Tehsil__c = tehsilKey;
            extObj = Akc_Business_dashboard__c.Fields.CombinationKey__c;
            abd.Tehsil_Count__c =  mapTehsilCount.get(tehsilKey);
            listAKCDashboard.add(abd);
            
        }
        
       if(listAKCDashboard.size()>0){
           Database.UpsertResult [] cr = Database.upsert(listAKCDashboard,extObj,false);
       }
    }
}