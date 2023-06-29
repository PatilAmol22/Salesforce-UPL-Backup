global without sharing class ThisMonthProductRecomdBatch Implements Database.Batchable<sObject>,Database.Stateful{

    /*
        This Month Product Recomdation Batch --
        
        Written By - Pravin J.
        Date - 29/10/2017 
        
    */   
    
    public Map<String,Tehsil__c> mapofTehsil = new Map<String,Tehsil__c>();
    public Schema.SObjectField extObj;
    public List<Akc_Business_dashboard__c> listAKCDashboard = new List<Akc_Business_dashboard__c>();
    public Map<String,Integer>  mapMonthCountFoVillage  = new Map<String,Integer>();
    public Map<String,Integer> mapMonthCountNonFoVillage = new Map<String,Integer>();
    
     public String todayDate;
    
    public ThisMonthProductRecomdBatch(){
    
        System.debug('ThisMonthProductRecomdBatch started at-->'+ system.now());
        Date d = System.today();
        Datetime myDT = datetime.newInstance(d.year(),d.month(),d.day());
        todayDate = myDT.format('yyyy-MM-dd');
        
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        
        System.debug('ThisMonthTotalRegistrationBatch_start==>');
        String query;
        Integer fovalue = 1;
        String nullChk = null;
        
        try{            
            query = 'SELECT Tehsil_Id__c,Fo_present__c,createdDate,Non_FO_Present__c   ';
            query += 'FROM CASE ';
            query += ' WHERE ( Products_Recommended__c !=: nullChk ';
            query += 'AND createdDate = THIS_MONTH )';
            
            System.debug('query==>>'+query);
                            
        }catch(Exception ex){
        
            System.debug('ErrorLine==>'+ex.getLineNumber());
            System.debug('Error==>'+ex);
        }
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Case > lstOfCases){ 
                   
            System.debug('lstOfCases===>'+lstOfCases);
            
            Integer incVal = 0;
            Integer incVal1 = 0 ; 
            
            for(Tehsil__c tehsil : [Select id From Tehsil__c]){
                 mapofTehsil.put(tehsil.Id,tehsil);    
            }
            
            if(lstOfCases.size()>0){
                 for(Case caseRec : lstOfCases){
                 
                    if(caseRec.FO_Present__c == 1){
                          
                         System.debug('FO==>');
                         if(mapMonthCountFoVillage.containsKey(caseRec.Tehsil_Id__c)){
                            
                            incVal  =  mapMonthCountFoVillage.get(caseRec.Tehsil_Id__c);
                            incVal = incVal + 1;
                            mapMonthCountFoVillage.put(caseRec.Tehsil_Id__c,incVal);
                            
                         }else{
                         
                             incVal = 1;
                            mapMonthCountFoVillage.put(caseRec.Tehsil_Id__c,incVal);
                         }
                    }
                    
                    if(caseRec.Non_FO_Present__c == 1){
                    
                         if( mapMonthCountNonFoVillage.containsKey(caseRec.Tehsil_Id__c)){
                         
                            incVal1 =  mapMonthCountNonFoVillage.get(caseRec.Tehsil_Id__c);
                            incVal1 = incVal1 + 1;
                            mapMonthCountNonFoVillage.put(caseRec.Tehsil_Id__c,incVal1);
                         }else{
                             
                            incVal1 = 1;
                            mapMonthCountNonFoVillage.put(caseRec.Tehsil_Id__c,incVal1); 
                         }
                    }
                 }
             }
             
             System.debug('FO==>'+mapMonthCountFoVillage);
             System.debug('NonFO==>'+mapMonthCountNonFoVillage);
    }
   
    global void finish(Database.BatchableContext BC){
    
        System.debug('finish==>');
        
        for(String tehsilKey : mapofTehsil.keyset()){
       
            Akc_Business_dashboard__c abd = new Akc_Business_dashboard__c();
            abd.combinationKey__c=tehsilKey+''+todayDate;
            abd.Tehsil__c = tehsilKey;
             extObj = Akc_Business_dashboard__c.Fields.CombinationKey__c;
            
            if( mapMonthCountFoVillage.containsKey(tehsilKey) ){               
                abd.Current_month_Fo_present_village__c =  mapMonthCountFoVillage.get(tehsilKey);
            }
            if(mapMonthCountNonFoVillage.containsKey(tehsilKey) ){
                abd.Current_Month_Non_Fo_present_village__c =  mapMonthCountNonFoVillage.get(tehsilKey);
            }
            listAKCDashboard.add(abd); 
        }
        System.debug('listAKCDashboard-->'+listAKCDashboard.size());
        
        if(listAKCDashboard.size()>0){
            Database.UpsertResult [] cr = Database.upsert(listAKCDashboard,extObj,false);
        }else{
            System.debug('<--No Data is added into List-->');
        }
    }   
}