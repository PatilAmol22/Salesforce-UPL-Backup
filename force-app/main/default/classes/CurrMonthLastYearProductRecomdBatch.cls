global without sharing class CurrMonthLastYearProductRecomdBatch Implements Database.Batchable<sObject>,Database.Stateful{

    /*
        This Current Month LastYear ProductRecomd  Batch
        
        Written By - Pravin J.
        Date - 29/10/2017 
    */   
    
    public Map<String,Tehsil__c> mapofTehsil = new Map<String,Tehsil__c>();
    public Schema.SObjectField extObj;
    public List<Akc_Business_dashboard__c> listAKCDashboard = new List<Akc_Business_dashboard__c>();
    public Map<String,Integer>  mapYearCountMonthPreviousYearFoVillage = new Map<String,Integer>();
    public Map<String,Integer> mapYearCountMonthPreviousYearNonFoVillage = new Map<String,Integer>();
    
    public String todayDate;
    public CurrMonthLastYearProductRecomdBatch(){
    
        System.debug('CurrMonthLastYearProductRecomdBatch started at-->'+ system.now());
        Date d = System.today();
        Datetime myDT = datetime.newInstance(d.year(),d.month(),d.day());
        todayDate = myDT.format('yyyy-MM-dd');
        
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        
        System.debug('CurrMonthLastYearProductRecomdBatch==>');
        String query;
        String nullChk = null;
        Integer year = Date.today().year() - 1;
        Integer month = Date.today().month();

        
        try{            
            query = 'SELECT Tehsil_Id__c,Fo_present__c,createdDate,Non_FO_Present__c   ';
            query += 'FROM CASE ';
            query += ' WHERE ( Products_Recommended__c !=: nullChk ';
            query += 'AND CALENDAR_YEAR(CreatedDate) =: year ';
            query += ' AND CALENDAR_MONTH(CreatedDate) =: month )';
            
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
                    
                         if(mapYearCountMonthPreviousYearFoVillage.containsKey(caseRec.Tehsil_Id__c)){
                            
                            incVal  =  mapYearCountMonthPreviousYearFoVillage.get(caseRec.Tehsil_Id__c);
                            incVal = incVal + 1;
                            mapYearCountMonthPreviousYearFoVillage.put(caseRec.Tehsil_Id__c,incVal);
                            System.debug('mapYearCountMonthPreviousYearFoVillage==>'+mapYearCountMonthPreviousYearFoVillage);
                            
                         }else{
                         
                             incVal = 1;
                            mapYearCountMonthPreviousYearFoVillage.put(caseRec.Tehsil_Id__c,incVal);
                         }
                    }
                    
                    if(caseRec.Non_FO_Present__c == 1){
                    
                         if(mapYearCountMonthPreviousYearNonFoVillage.containsKey(caseRec.Tehsil_Id__c)){
                            
                            incVal  =  mapYearCountMonthPreviousYearNonFoVillage.get(caseRec.Tehsil_Id__c);
                            incVal = incVal + 1;
                            mapYearCountMonthPreviousYearNonFoVillage.put(caseRec.Tehsil_Id__c,incVal);
                         }else{
                         
                             incVal = 1;
                            mapYearCountMonthPreviousYearNonFoVillage.put(caseRec.Tehsil_Id__c,incVal);
                         }
                        
                        
                        
                    }
                 }
             }
    }
   
    global void finish(Database.BatchableContext BC){
    
        System.debug('finish==>');
        
        for(String tehsilKey : mapofTehsil.keyset()){
        
            Akc_Business_dashboard__c abd = new Akc_Business_dashboard__c();
            Date d = System.today();
            Datetime myDT = datetime.newInstance(d.year(), d.month(),d.day());
            String todayDate = myDT.format('yyyy-MM-dd');
            abd.combinationKey__c=tehsilKey+''+todayDate;
            abd.Tehsil__c = tehsilKey;
            extObj = Akc_Business_dashboard__c.Fields.CombinationKey__c;
            
            if( mapYearCountMonthPreviousYearFoVillage.containsKey(tehsilKey) ){
                abd.CmPyMtd_Fo_present__c =  mapYearCountMonthPreviousYearFoVillage.get(tehsilKey);
            }
            if( mapYearCountMonthPreviousYearNonFoVillage.containsKey(tehsilKey) ){
                abd.CmPyMtd_Non_Fo_present__c  =  mapYearCountMonthPreviousYearNonFoVillage.get(tehsilKey);
            }
           
            listAKCDashboard.add(abd); 
        }
        
        System.debug('listAKCDashboard-->'+listAKCDashboard.size());
        
        if(listAKCDashboard.size()>0){
            Database.UpsertResult [] cr = Database.upsert(listAKCDashboard,extObj,false);
        }else{
            System.debug('<--No Data is added into the List-->');
        }
    }   
}