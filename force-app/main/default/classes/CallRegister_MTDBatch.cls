global without sharing class CallRegister_MTDBatch Implements Database.Batchable<sObject>,Database.Stateful{
    
        /*
    Written By - Pravin J.
    Date - 29/01/2018
    No. Of Call Register during MTD And YTD
    */   
    
    public String todayDate;    
    public Map<String,Tehsil__c> mapofTehsil = new Map<String,Tehsil__c>();
    public Schema.SObjectField extObj;
    public Schema.SObjectField extObj1;
    public List<Akc_Business_dashboard__c> listAKCDashboard = new List<Akc_Business_dashboard__c>();
    public Map<String,Map<String,Map<String,Integer>>> mapOfcallCount = new Map<String,Map<String,Map<String,Integer>>>();
    
    
    public CallRegister_MTDBatch(){
        
        System.debug('CallRegister_MTDBatch started at-->'+ system.now());
        Date d = System.today();
        Datetime myDT = datetime.newInstance(d.year(),d.month(),d.day());
        todayDate = myDT.format('yyyy-MM-dd');        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        System.debug('Start_CallRegister_MTDBatch==>');
        String query;
        try{
            
            Id RecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
            System.debug('RecType-->'+RecType);
            query = 'SELECT Tehsil_Id__c,CreatedDate,AccountId,Account.PersonMobilePhone,Account_Mobile__c ';
            query += ' FROM CASE ';
            query += ' WHERE CreatedDate = This_Month';
            query += ' AND RecordTypeID =: RecType';
            
            System.debug('query==>>'+query);
            
        }catch(Exception ex){
            
            System.debug('ErrorLine==>'+ex.getLineNumber());
            System.debug('Error==>'+ex);
        }
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Case > lstOfCases){ 
        
        System.debug('Execute_CallRegister_MTDBatch==>'+lstOfCases.size());
        try{
            
            Integer count = 0;
            Integer mobileCount = 0 ;
            Integer firstCount = 0 ;   
            
            for(Case caseObj : lstOfCases){
                
                if(caseObj.Tehsil_Id__c != null){
                    
                    Map<String,Map<String,Integer>> map2 = new Map<String,Map<String,Integer>>();
                    Map<String,Integer> map3 = new Map<String,Integer>();
                    
                    if(mapOfcallCount.containsKey(caseObj.Tehsil_Id__c)){ 
                                               
                        map2 = mapOfcallCount.get(caseObj.Tehsil_Id__c);
                        if(map2.containsKey(caseObj.AccountId)){
                            
                                map3 = map2.get(caseObj.AccountId);
                            
                                if(map3.containsKey(caseObj.Account_Mobile__c)){  
                                    
                                    mobileCount = map3.get(caseObj.Account_Mobile__c);
                                    mobileCount = mobileCount + 1;
                                    map3.put(caseObj.Account_Mobile__c, mobileCount);
                                    
                                }else{
                                    mobileCount = 1 ;
                                    map3.put(caseObj.Account_Mobile__c, mobileCount);
                                }
                           
                        }else{
                            count = 1;
                            map3.put(caseObj.Account_Mobile__c, count);
                            map2.put(String.valueOf(caseObj.AccountId), map3);
                        }
                    }else{
                        
                        firstCount = 1 ; 
                        //Integer mobileNumber = Integer.valueOf();
                        map3.put(caseObj.Account_Mobile__c,firstCount);
                        map2.put(caseObj.AccountId,map3);
                        mapOfcallCount.put(caseObj.Tehsil_Id__c,map2);
                    }
                }
            }
            
        }catch(Exception ex){
            
            System.debug('Error-->'+ex.getMessage());
            System.debug('ErrorLine-->'+ex.getLineNumber());
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
        
        Integer callerCount = 0 ;
        Integer NoOfCall = 0 ;
        Integer accCount = 0;
        Map<String,Tehsil__c> mapofTehsil = new Map<String,Tehsil__c>();
        listAKCDashboard = new List<Akc_Business_dashboard__c>();
        for(Tehsil__c tehsil : [Select id From Tehsil__c]){
            mapofTehsil.put(tehsil.Id,tehsil);    
        }
        
        System.debug('finish==>'+mapOfcallCount.size());
        Map<String,Map<String,Integer>> mapX = new Map<String,Map<String,Integer>>();
        Map<String,Integer> lstMap = new Map<String,Integer>();
        Map<String,Integer> lstMapCount = new Map<String,Integer>();
        for(String tehsilkey : mapofTehsil.keySet()){
            
            Akc_Business_dashboard__c abd = new Akc_Business_dashboard__c();
            accCount = 0;
            Date d = System.today();
            Datetime myDT = datetime.newInstance(d.year(),d.month(),d.day());
            String todayDate = myDT.format('yyyy-MM-dd');
            
            abd.combinationKey__c=tehsilKey+''+todayDate;
            abd.Tehsil__c = mapofTehsil.get(tehsilKey).id;
            extObj = Akc_Business_dashboard__c.Fields.CombinationKey__c;
            
            if(mapOfcallCount.containsKey(tehsilkey)){
                mapX = mapOfcallCount.get(tehsilkey);
                for(String accKey : mapX.keySet()){ 
                    lstMap =  mapX.get(acckey);
                    
                    for(String Mobilekey : lstMap.keySet()){
                        NoOfCall = NoOfCall + lstMap.get(Mobilekey);
                        abd.Number_of_Calls_MTD__c = NoOfCall;                        
                    }
                    accCount = accCount + 1;
                    abd.Number_of_Caller_MTD__c = accCount;
                }
                NoOfCall = 0 ;
            }
            
            listAKCDashboard.add(abd);
        }
        System.debug('listAKCDashboard==>'+listAKCDashboard.size());
        if(listAKCDashboard.size()>0){
            Database.UpsertResult [] cr = Database.upsert(listAKCDashboard, extObj , false);
        }
    }   
}