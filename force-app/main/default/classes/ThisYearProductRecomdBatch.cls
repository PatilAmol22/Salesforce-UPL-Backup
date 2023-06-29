global without sharing class ThisYearProductRecomdBatch Implements Database.Batchable<sObject>,Database.Stateful{

    /*
        This Year ProductRecomd  
        
        Written By - Pravin J.
        Date - 29/10/2017 
        
    */   
    
    public Map<String,Tehsil__c> mapofTehsil = new Map<String,Tehsil__c>();
    public Schema.SObjectField extObj;
    public List<Akc_Business_dashboard__c> listAKCDashboard = new List<Akc_Business_dashboard__c>();
    public Map<String,Integer>  mapYearCountFoVillage  = new Map<String,Integer>();
    public Map<String,Integer> mapYearCountNonFoVillage = new Map<String,Integer>();
    
     public String todayDate;
    
    public ThisYearProductRecomdBatch(){
    
        System.debug('FoCallTypeBatch started at-->'+ system.now());
        Date d = System.today();
        Datetime myDT = datetime.newInstance(d.year(),d.month(),d.day());
        todayDate = myDT.format('yyyy-MM-dd');
        
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        
        System.debug('ThisYearPrdctRecomendationBatch_start==>');
        String query;
        String nullChk = null;
        
        try{            
            query = 'SELECT Tehsil_Id__c,Fo_present__c,createdDate,Non_FO_Present__c   ';
            query += 'FROM CASE ';
            query += ' WHERE ( Products_Recommended__c !=: nullChk ';
            query += 'AND createdDate = THIS_YEAR )';
            
            System.debug('query==>>'+query);
                            
        }catch(Exception ex){
        
            System.debug('ErrorLine==>'+ex.getLineNumber());
            System.debug('Error==>'+ex);
        }
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Case > lstOfCases){ 
                   
            System.debug('lstOfCases===>'+lstOfCases.size());
            
            Integer incVal = 0;
            Integer incVal1 = 0 ; 
            
            for(Tehsil__c tehsil : [Select id From Tehsil__c]){
                 mapofTehsil.put(tehsil.Id,tehsil);    
            }
            
             if(lstOfCases.size()>0){
                 for(Case caseRec : lstOfCases){
                 
                    if(caseRec.FO_Present__c == 1){
                      
                       
                        if(mapYearCountFoVillage.containsKey(caseRec.Tehsil_Id__c)){
                            
                            incVal  =  mapYearCountFoVillage.get(caseRec.Tehsil_Id__c);
                            incVal = incVal + 1;
                            mapYearCountFoVillage.put(caseRec.Tehsil_Id__c,incVal);
                         }else{
                             incVal = 1;
                            mapYearCountFoVillage.put(caseRec.Tehsil_Id__c,incVal);
                         }
                    }
                    
                    if(caseRec.Non_FO_Present__c == 1){
                        
                        if(mapYearCountNonFoVillage.containsKey(caseRec.Tehsil_Id__c)){
                            
                            incVal1  =  mapYearCountNonFoVillage.get(caseRec.Tehsil_Id__c);
                            incVal1 = incVal1 + 1;
                            mapYearCountNonFoVillage.put(caseRec.Tehsil_Id__c,incVal1);
                         }else{
                         
                             incVal1 = 1;
                            mapYearCountNonFoVillage.put(caseRec.Tehsil_Id__c,incVal1);
                         }
                    }
                 }
             }
    }
   
    global void finish(Database.BatchableContext BC){
    
        System.debug('finish==>');
        
        for(String tehsilKey : mapofTehsil.keyset()){
            Akc_Business_dashboard__c abd = new Akc_Business_dashboard__c();            
            abd.combinationKey__c=tehsilKey+''+todayDate;
            abd.Tehsil__c = tehsilKey;
            extObj = Akc_Business_dashboard__c.Fields.CombinationKey__c;
            
            if( mapYearCountFoVillage.containsKey(tehsilKey) ){
                abd.Current_Year_Fo_Present_village__c =  mapYearCountFoVillage.get(tehsilKey);
            }
            if( mapYearCountNonFoVillage.containsKey(tehsilKey) ){
                abd.Current_Year_Non_Fo_Present_village__c =  mapYearCountNonFoVillage.get(tehsilKey);
            }
           
            listAKCDashboard.add(abd); 
        }
        System.debug('listAKCDashboard-->'+listAKCDashboard.size());
        if(listAKCDashboard.size()>0){
            Database.UpsertResult [] cr = Database.upsert(listAKCDashboard,extObj,false);
        }else{
            System.debug('<===No Data Found===>');
        }
    }   
}