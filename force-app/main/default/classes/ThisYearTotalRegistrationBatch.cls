global without sharing class ThisYearTotalRegistrationBatch Implements Database.Batchable<sObject>,Database.Stateful{

    /*
        Total Registration of This Year
        
    */    
    
    public Map<String,Tehsil__c> mapofTehsil = new Map<String,Tehsil__c>();
    public List<Akc_Business_dashboard__c> listAKCDashboard = new List<Akc_Business_dashboard__c>();
    public Map<String,Integer> mapTehsilCount= new Map<String,Integer>();
    public List<contact> monthcount = new List<contact>();
    public Map<String,Integer> mapYearCountFo = new Map<String,Integer>();
    public Map<String,Integer> mapYearCountNonFo = new Map<String,Integer>();
    public Map<String,Integer> mapTotalRegistrationFo = new Map<String,Integer>();
    public Map<String,Integer> mapTotalregistrationNonFo = new Map<String,Integer>();
    public Schema.SObjectField extObj;
    public Map<String,TM_District_Tehsil_Mapping__c> TehsilTMMap ;
    public List<TM_District_Tehsil_Mapping__c> MappingList ;
    public String todayDate;
    
    public ThisYearTotalRegistrationBatch(){
    
        System.debug('ThisMonthTotalRegistrationBatch started at-->'+ system.now());
        Date d = System.today();
        Datetime myDT = datetime.newInstance(d.year(),d.month(),d.day());
        todayDate = myDT.format('yyyy-MM-dd');
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    
        
        System.debug('start==>');
        String query;
        
        try{
        
            query = 'SELECT Tehsil_id__c, Fo_present__pc ,Non_FO_Present__pc,Fully_Registered_Date__pc ';
            query += 'FROM Account ';
            query += ' WHERE Fully_Registered_Date__pc != null '; 
            query += ' AND Fully_Registered_Date__pc = THIS_FISCAL_YEAR';
                        
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
            
           
            
            for(Account cnt : lstOfAccount){
                
                 if(cnt.FO_Present__pc == 1){
                 
                     if(mapYearCountFo.containsKey(cnt.Tehsil_id__c)){
                         incFoVal = mapYearCountFo.get(cnt.Tehsil_id__c);
                         incFoVal = incFoVal + 1 ;
                         mapYearCountFo.put(cnt.Tehsil_id__c,incFoVal);
                         
                     }else{
                         incFoVal = 1 ;
                         mapYearCountFo.put(cnt.Tehsil_id__c,incFoVal);
                     }
                 }
                    
                    
                 if(cnt.Non_FO_Present__pc == 1){
                    
                    if(mapYearCountNonFo.containsKey(cnt.Tehsil_id__c)){
                         incNonFoVal = mapYearCountNonFo.get(cnt.Tehsil_id__c);
                         incNonFoVal = incNonFoVal  + 1 ;
                         mapYearCountNonFo.put(cnt.Tehsil_id__c,incNonFoVal);
                         
                     }else{
                         incNonFoVal = 1 ;
                         mapYearCountNonFo.put(cnt.Tehsil_id__c,incNonFoVal);
                     }
                 } 
            }
      
    }
   
    global void finish(Database.BatchableContext BC){
        System.debug('finish==>');
        
         /* For Ownership logic */
                TehsilTMMap = new Map<String,TM_District_Tehsil_Mapping__c>();
                MappingList = new List<TM_District_Tehsil_Mapping__c>();
                
                MappingList = [select id, District__c,Tehsil__c,
                                 Territory__c,TM_User__c
                                 from 
                                 TM_District_Tehsil_Mapping__c];
                 
               
                for(TM_District_Tehsil_Mapping__c tdm : MappingList){
                    TehsilTMMap.put(String.valueof(tdm.Tehsil__c),tdm);
                }
                
                System.debug('TehsilTMMap-->'+TehsilTMMap.keySet());
            /* Ownership logic END */
        
        
        for(String tehsilKey : mapofTehsil.keySet()){
                
                Akc_Business_dashboard__c abd = new Akc_Business_dashboard__c();
                abd.combinationKey__c=tehsilKey+''+todayDate;
                abd.Tehsil__c = tehsilKey;
                extObj = Akc_Business_dashboard__c.Fields.CombinationKey__c;
                system.debug('Tehsil Key --->'+tehsilKey);
                /* Ownership logic */
                if(TehsilTMMap.containsKey(tehsilKey)){
                    system.debug('Map contains Key');

                    abd.Territory__c = TehsilTMMap.get(tehsilKey).Territory__c;
                    abd.OwnerID = TehsilTMMap.get(tehsilKey).TM_User__c;
                }
                /* End */
                
                if( mapYearCountFo.containsKey(tehsilKey) ){
                    abd.Current_Year_Fo_Present__c =  mapYearCountFo.get(tehsilKey);
                }
                if( mapYearCountNonFo.containsKey(tehsilKey) ){
                    abd.Current_Year_Non_Fo_present__c =  mapYearCountNonFo.get(tehsilKey);
                }
               
                listAKCDashboard.add(abd);
            }
            
            if(listAKCDashboard.size() > 0){
                
            Database.UpsertResult [] cr = Database.upsert(listAKCDashboard,extObj,false);
            }
    }
}