global without sharing class TotalRegistrationBatch Implements Database.Batchable<sObject>,Database.Stateful{
    
    /*
     * Wriiten By - Pravin Jagadale.
     * 
    Total Registration Batch Class
    
    */
    
    public Schema.SObjectField extObj;
    public Map<String,Tehsil__c> mapofTehsil = new Map<String,Tehsil__c>();
    public List<Akc_Business_dashboard__c> listAKCDashboard = new List<Akc_Business_dashboard__c>();
    public Map<String,Integer> mapTehsilCount= new Map<String,Integer>();
    public List<contact> monthcount = new List<contact>();
    public Map<String,Integer> mapTotalRegistrationFo = new Map<String,Integer>();
    public Map<String,Integer> mapTotalregistrationNonFo = new Map<String,Integer>();
    public Map<String,TM_District_Tehsil_Mapping__c> TehsilTMMap ;
    public List<TM_District_Tehsil_Mapping__c> MappingList ;
    public String todayDate;
    
    public TotalRegistrationBatch(){
        
        System.debug('TotalRegistrationBatch started at-->'+ system.now());
        Date d = System.today();
        Datetime myDT = datetime.newInstance(d.year(),d.month(),d.day());
        todayDate = myDT.format('yyyy-MM-dd');
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        System.debug('start==>');
        String query;
        try{
            query = ' SELECT Tehsil_Id__c, FO_Present__pc,Non_FO_Present__pc,Fully_Registered_Date__pc  ';
            query += ' FROM Account ';
            query += ' WHERE Fully_Registered_Date__pc != null ';
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
        Integer incFoVal = 0;
        Integer incNonFoVal = 0;
        for(Tehsil__c tehsil : [Select id From Tehsil__c]){
            mapofTehsil.put(tehsil.Id,tehsil);    
        }
        
        /* For Ownership logic */
        TehsilTMMap = new Map<String,TM_District_Tehsil_Mapping__c>();
        MappingList = new List<TM_District_Tehsil_Mapping__c>([select id, District__c,
                                                               Tehsil__c, Territory__c,TM_User__c
                                                               from TM_District_Tehsil_Mapping__c]);
        TehsilTMMap = new Map<String,TM_District_Tehsil_Mapping__c>();
        for(TM_District_Tehsil_Mapping__c tdm : MappingList){
            TehsilTMMap.put(String.valueof(tdm.Tehsil__c),tdm);
        }
        /* Ownership logic END */
        
        for(Account cnt : lstOfAccount){
            
            if(cnt.FO_Present__pc == 1){
                
                if(mapTotalRegistrationFo.containsKey(cnt.Tehsil_id__c)){
                    incFoVal = mapTotalRegistrationFo.get(cnt.Tehsil_id__c);
                    incFoVal = incFoVal + 1 ;
                    mapTotalRegistrationFo.put(cnt.Tehsil_id__c,incFoVal);
                    
                }else{
                    incFoVal = 1 ;
                    mapTotalRegistrationFo.put(cnt.Tehsil_id__c,incFoVal);
                }
            }
            
            if(cnt.Non_FO_Present__pc == 1){
                
                if(mapTotalregistrationNonFo.containsKey(cnt.Tehsil_id__c)){
                    incNonFoVal = mapTotalregistrationNonFo.get(cnt.Tehsil_id__c);
                    incNonFoVal = incNonFoVal + 1 ;
                    mapTotalregistrationNonFo.put(cnt.Tehsil_id__c,incNonFoVal);
                    
                }else{
                    incNonFoVal = 1 ;
                    mapTotalregistrationNonFo.put(cnt.Tehsil_id__c,incNonFoVal);
                }
            } 
        } 
    }
    
    global void finish(Database.BatchableContext BC){
        System.debug('finish==>');
        for(String tehsilKey : mapofTehsil.keySet()){
            
            Akc_Business_dashboard__c abd = new Akc_Business_dashboard__c();
            abd.combinationKey__c=tehsilKey+''+todayDate;
            abd.Tehsil__c = tehsilKey;
            extObj = Akc_Business_dashboard__c.Fields.CombinationKey__c;        
            if( mapTotalRegistrationFo.containsKey(tehsilKey) ){
                abd.Total_Registration_Fo_Present__c =  mapTotalRegistrationFo.get(tehsilKey);
            }
            if( mapTotalregistrationNonFo.containsKey(tehsilKey) ){
                abd.Total_Registration_Non_Fo_Present__c =  mapTotalregistrationNonFo.get(tehsilKey);
            }
            
            listAKCDashboard.add(abd);
        }
        if(listAKCDashboard.size()>0){
            Database.UpsertResult [] cr = Database.upsert(listAKCDashboard,extObj,false);
        }    
        
    }
}