global without sharing class ClosureFoBatch Implements Database.Batchable<sObject>,Database.Stateful{




    Schema.SObjectField extObj;
    public Map<String,Tehsil__c> mapofTehsil;
    Map<String,Integer> mapLeadClosedFo = new Map<String,Integer>();
    Map<String,Integer> mapLeadOpen = new Map<String,Integer>();
    public String todayDate;    
    public ClosureFoBatch(){
    
        System.debug('ClosureFoBatch started at-->'+ system.now());
        Date d = System.today();
        Datetime myDT = datetime.newInstance(d.year(),d.month(),d.day());
        todayDate = myDT.format('yyyy-MM-dd');
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    
        System.debug('start==>');
        
        String query ;
        
        try{
        
            List<String> caseStatus = new List<String>();
            caseStatus.add('Escalated-L2');
            caseStatus.add('Closed-FO');
            
            query = 'SELECT id,Tehsil_id__c,status ';
            query += ' from case '; 
            query += ' where status IN : caseStatus ';
            
            System.debug('query==>>'+query);
                            
        }catch(Exception ex){
        
            System.debug('ErrorLine==>'+ex.getLineNumber());
            System.debug('Error==>'+ex);
        }
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Case> lstOfCases){   
             
            System.debug('lstOfCases===>'+lstOfCases.size());
            
            Integer incVal = 0;
            Integer incVal1 = 0 ; 
            
            if(lstOfCases.size()>0){
                for(Case cas : lstOfCases){                    
                    
                    if(mapLeadClosedFo.containsKey(cas.Tehsil_id__c) && cas.Status == 'Closed-Fo'){
                    
                        incVal = mapLeadClosedFo.get(cas.Tehsil_id__c);
                        incVal = incVal + 1 ;
                        mapLeadClosedFo.put(cas.Tehsil_id__c,incVal);
                        
                    }else{
                        incVal =  1 ;
                        mapLeadClosedFo.put(cas.Tehsil_id__c,incVal);
                    }
                    
                    if(mapLeadOpen.containsKey(cas.Tehsil_id__c) && cas.Status == 'Escalated-L2'){
                        
                        incVal1 = mapLeadOpen.get(cas.Tehsil_id__c);
                        incVal1 = incVal1 + 1 ;
                        mapLeadOpen.put(cas.Tehsil_id__c,incVal1);
                    }else{
                        
                        incVal1 =  1 ;
                        mapLeadOpen.put(cas.Tehsil_id__c,incVal1);
                    }
                }//for Block closed
            }//if Block closed
    }
   
    global void finish(Database.BatchableContext BC){
        System.debug('finish==>');
      
        List<Akc_Business_dashboard__c> listAKCDashboard = new List<Akc_Business_dashboard__c>();
        Map<String,Tehsil__c> mapofTehsil = new Map<String,Tehsil__c>();
        listAKCDashboard = new List<Akc_Business_dashboard__c>();
        for(Tehsil__c tehsil : [Select id From Tehsil__c]){
             mapofTehsil.put(tehsil.Id,tehsil);    
        }
         for(String tehsilKey : mapofTehsil.keySet()){
                 
                 
                    Akc_Business_dashboard__c abd = new Akc_Business_dashboard__c();
                    abd.combinationKey__c=tehsilKey+''+todayDate;
                    abd.Tehsil__c = tehsilKey;
                    extObj = Akc_Business_dashboard__c.Fields.CombinationKey__c;
                    
                    if( mapLeadClosedFo.containsKey(tehsilKey) ){
                    
                        abd.Sales_lead_Closed_Fo__c =  mapLeadClosedFo.get(tehsilKey);
                    }
                    if( mapLeadOpen.containsKey(tehsilKey) ){
                    
                        abd.Sales_lead_Open__c =  mapLeadOpen.get(tehsilKey);
                    }
                    
                   listAKCDashboard.add(abd);
             }
             
             IF(listAKCDashboard.Size()>0){
                 Database.UpsertResult [] cr = Database.upsert(listAKCDashboard,extObj,false);
             }
    }
}