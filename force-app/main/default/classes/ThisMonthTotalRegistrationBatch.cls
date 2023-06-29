global without sharing class ThisMonthTotalRegistrationBatch Implements Database.Batchable<sObject>,Database.Stateful{

    /*
        Total Registration of Current Month    
        
    */   
    
    public Map<String,Tehsil__c> mapofTehsil = new Map<String,Tehsil__c>();
    public Schema.SObjectField extObj;
    public List<Akc_Business_dashboard__c> listAKCDashboard = new List<Akc_Business_dashboard__c>();
    public Map<String,Integer> mapTehsilCount= new Map<String,Integer>(); 
    public Map<String,TM_District_Tehsil_Mapping__c> TehsilTMMap ;
    public List<TM_District_Tehsil_Mapping__c> MappingList ;
    public List<contact> monthcount = new List<contact>();
    public Map<String,Integer> mapMonthCountFo = new Map<String,Integer>();
    public Map<String,Integer> mapMonthCountNonFo = new Map<String,Integer>();
    
    public String todayDate;
    
    public ThisMonthTotalRegistrationBatch(){
    
        System.debug('ThisMonthTotalRegistrationBatch started at-->'+ system.now());
        Date d = System.today();
        Datetime myDT = datetime.newInstance(d.year(),d.month(),d.day());
        todayDate = myDT.format('yyyy-MM-dd');
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        System.debug('ThisMonthTotalRegistrationBatch_start==>');
        String query;
        
        try{
        
            query = 'SELECT Tehsil_Id__c, FO_Present__pc,Non_FO_Present__pc,Fully_Registered_Date__pc  ';
            query += ' FROM Account ';
            query += ' WHERE Fully_Registered_Date__pc != null '; 
            query += ' AND Fully_Registered_Date__pc = This_Month';
                        
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
                
                 if(cnt.FO_Present__pc== 1){
                     
                     if(mapMonthCountFo.containsKey(cnt.Tehsil_id__c)){
                     
                         incFoVal = mapMonthCountFo.get(cnt.Tehsil_id__c);
                         incFoVal = incFoVal + 1 ;
                         mapMonthCountFo.put(cnt.Tehsil_id__c,incFoVal);
                         
                     }else{
                         incFoVal = 1 ;
                         mapMonthCountFo.put(cnt.Tehsil_id__c,incFoVal);
                     }
                 }  
                    
                 if(cnt.Non_FO_Present__pc == 1){
                    
                    if(mapMonthCountNonFo.containsKey(cnt.Tehsil_id__c)){
                    
                         incNonFoVal = mapMonthCountNonFo.get(cnt.Tehsil_id__c);
                         incNonFoVal = incNonFoVal + 1 ;
                         mapMonthCountNonFo.put(cnt.Tehsil_id__c,incNonFoVal);
                         
                     }else{
                     
                         incNonFoVal = 1 ;
                         mapMonthCountNonFo.put(cnt.Tehsil_id__c,incNonFoVal);
                     }
                 } 
            }
    }
   
    global void finish(Database.BatchableContext BC){
    
        System.debug('finish==>');
        
        for(Tehsil__c tehsil : [Select id From Tehsil__c]){
            mapofTehsil.put(tehsil.Id,tehsil);    
        }
            
        for(String tehsilKey : mapofTehsil.keySet()){
                
                Akc_Business_dashboard__c abd = new Akc_Business_dashboard__c();
                abd.combinationKey__c=tehsilKey+''+todayDate;
                abd.Tehsil__c = tehsilKey;
                extObj = Akc_Business_dashboard__c.Fields.CombinationKey__c;                
                if( mapMonthCountFo.containsKey(tehsilKey) ){
                    abd.Current_Month_Fo_Present__c =  mapMonthCountFo.get(tehsilKey);
                }
                if( mapMonthCountNonFo.containsKey(tehsilKey) ){
                    abd.Current_Month_Non_Fo_present__c =  mapMonthCountNonFo.get(tehsilKey);
                }
                            
                listAKCDashboard.add(abd);
            }
              
            System.debug('listAKCDashboard==>'+listAKCDashboard.size());    
            if(listAKCDashboard.size() > 0){
                Database.UpsertResult [] cr = Database.upsert(listAKCDashboard,extObj,false);
            } 
            
    }
}