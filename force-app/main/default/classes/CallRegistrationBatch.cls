global without sharing class CallRegistrationBatch Implements Database.Batchable<sObject>,Database.Stateful{



//    public Map<Integer,Integer> mapDaywiseFOCount;
    public Map<String,Tehsil__c> mapofTehsil;
    Map<String,Map<Integer,Integer>> mapFOPresentCountDaywise = new Map<String,Map<Integer,Integer>>();
    Map<String,Map<Integer,Integer>> mapNonFOPresentCountDaywise = new Map<String,Map<Integer,Integer>>();
    public Map<Integer,Integer> mapDaywiseNonFOCount;
    public List<Akc_Business_dashboard__c> listAKCDashboard;
    public Schema.SObjectField extObj;
    public String todayDate;
    
    public CallRegistrationBatch(){
    
        System.debug('CallRegistrationBatch started at-->'+ system.now());
        Date d = System.today();
        Datetime myDT = datetime.newInstance(d.year(),d.month(),d.day());
        todayDate = myDT.format('yyyy-MM-dd');
        
    }
    
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    
        System.debug('start==>');
        
        String query ;
        Integer minDay = 0 ;
        Integer maxDay = 7 ;
        String teh = 'a050k000001D7dP';
        
        try{
        
            String recTypeName = 'AKC General Case';
                 
            query = 'SELECT Tehsil_Id__c ,Non_Fo_present__c, FO_Present__c, ';
            query += 'CreatedDate, DayInWeek__c  ';
            query += 'FROM case ';
            query += ' WHERE ( DayInWeek__c >=: minDay AND DayInWeek__c <: maxDay' ;
            query += ' AND case.RecordType.name =: recTypeName )' ;
            
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
           // Map<String,Tehsil__c> mapofTehsil = new Map<String,Tehsil__c>();
            
           
            
            
             if(lstOfCases.size()>0){
          
                 for(Case caseRec : lstOfCases){
                 
                       
                    
                    if(caseRec.FO_Present__c == 1){
                    
                        if(mapFOPresentCountDaywise.containsKey(caseRec.Tehsil_Id__c)){
                        
                            Map<Integer,Integer> mapDaywiseFOCount = new Map<Integer,Integer>();
                            mapDaywiseFOCount = mapFOPresentCountDaywise.get(caseRec.Tehsil_Id__c);
                            
                            if(mapDaywiseFOCount.ContainsKey(Integer.valueOf(caseRec.DayInWeek__c))){
                    
                                incVal = mapDaywiseFOCount.get(Integer.valueOf(caseRec.DayInWeek__c));   
                                incVal = incVal + 1 ;
                                mapDaywiseFOCount.put(Integer.valueOf(caseRec.DayInWeek__c),incVal);
                                mapFOPresentCountDaywise.put(caseRec.Tehsil_Id__c,mapDaywiseFOCount);
                                
                            }else{
                    
                                incVal =  1 ;
                                mapDaywiseFOCount.put(Integer.valueOf(caseRec.DayInWeek__c),incVal);
                                mapFOPresentCountDaywise.put(caseRec.Tehsil_Id__c,mapDaywiseFOCount);
                            }
                             
                            
                        }else{
                      
                            Map<Integer,Integer> mapDaywiseFOCount = new Map<Integer,Integer>();
                            incVal =  1 ;
                            mapDaywiseFOCount.put(Integer.valueOf(caseRec.DayInWeek__c),incVal);
                            mapFOPresentCountDaywise.put(caseRec.Tehsil_Id__c,mapDaywiseFOCount);
                        }
                    }
                                        
                    if(caseRec.Non_FO_Present__c == 1){
                         
                         System.debug('NOn---Fo');
                         if(mapNonFOPresentCountDaywise.containsKey(caseRec.Tehsil_Id__c)){
                         
                              Map<Integer,Integer> mapDaywiseNonFOCount = new Map<Integer,Integer>();
                              mapDaywiseNonFOCount = mapNonFOPresentCountDaywise.get(caseRec.Tehsil_Id__c);
                             if(mapDaywiseNonFOCount.containsKey(Integer.valueOf(caseRec.DayInWeek__c))){
                                 
                                 incVal1 = mapDaywiseNonFOCount.get(Integer.valueOf(caseRec.DayInWeek__c));
                                 incVal1 = incVal1 + 1 ;
                                 mapDaywiseNonFOCount.put(Integer.valueOf(caseRec.DayInWeek__c),incVal1);
                                 
                             }else{
                                 
                                 incVal1 = 1 ;
                                 mapDaywiseNonFOCount.put(Integer.valueOf(caseRec.DayInWeek__c),incVal1);
                             }
                             
                             mapNonFOPresentCountDaywise.put(caseRec.Tehsil_Id__c,mapDaywiseNonFOCount);
                             
                         }else{
                             Map<Integer,Integer> mapDaywiseNonFOCount = new Map<Integer,Integer>();
                             incVal1 = 1 ;
                             mapDaywiseNonFOCount.put(Integer.valueOf(caseRec.DayInWeek__c),incVal1);
                             mapNonFOPresentCountDaywise.put(caseRec.Tehsil_Id__c,mapDaywiseNonFOCount);
                         }
                    }
                 }
                 
                 
                /* Set<String> setKey = mapFOPresentCountDaywise.keySet();
                    
                    for(String ky : setKey){
                        System.Debug('Tehsil = ' + ky +'  value == ' +mapFOPresentCountDaywise.get(ky) );
                        Map<Integer,Integer> mapDaywiseFOCount1 = new Map<Integer,Integer>();
                            mapDaywiseFOCount1 = mapFOPresentCountDaywise.get(ky);
                        Set<Integer> setDays = mapDaywiseFOCount1.keySet();
                        for(Integer days : setDays){
                            System.Debug('Tehsil ===== ' +Ky+ ' == Week Day ' + days + '  = dayCount =  '+ mapDaywiseFOCount1.get(days));
                        }
                    }*/
             }
             
        }
   
    global void finish(Database.BatchableContext BC){
        System.debug('finish==>');
      
      
        Map<String,Tehsil__c> mapofTehsil = new Map<String,Tehsil__c>();
        listAKCDashboard = new List<Akc_Business_dashboard__c>();
     for(Tehsil__c tehsil : [Select id From Tehsil__c]){
             mapofTehsil.put(tehsil.Id,tehsil);    
        }
         for(String tehsilKey : mapofTehsil.keySet()){
                 
                 
                    Akc_Business_dashboard__c abd = new Akc_Business_dashboard__c();
                    //Date d = System.today();
                   // Datetime myDT = datetime.newInstance(d.year(),d.month(),d.day());
                   // String todayDate = myDT.format('yyyy-MM-dd');
                    
                    abd.combinationKey__c=tehsilKey+''+todayDate;
                    abd.Tehsil__c = mapofTehsil.get(tehsilKey).Id;
                    extObj = Akc_Business_dashboard__c.Fields.CombinationKey__c;
                     
                    if(mapFOPresentCountDaywise.containsKey(tehsilKey) ){
                    
                        Map<Integer,Integer> mapDaywiseFOCount = new Map<Integer,Integer>();
                        mapDaywiseFOCount =  mapFOPresentCountDaywise.get(tehsilKey);
                        
                        if(mapDaywiseFOCount.containsKey(0)){
                            abd.Last1DayFoPresent__c = mapDaywiseFOCount.get(0);
                        }
                        if(mapDaywiseFOCount.containsKey(1)){
                            abd.Last2DayFoPresent__c = mapDaywiseFOCount.get(1);
                        }
                        if(mapDaywiseFOCount.containsKey(2)){
                            abd.Last3DayFoPresent__c = mapDaywiseFOCount.get(2);
                        }
                        if(mapDaywiseFOCount.containsKey(3)){
                            abd.Last4DayFoPresent__c = mapDaywiseFOCount.get(3);
                        }
                        if(mapDaywiseFOCount.containsKey(4)){
                            abd.Last5DayFoPresent__c = mapDaywiseFOCount.get(4);
                        }
                        if(mapDaywiseFOCount.containsKey(5)){
                            abd.Last6DayFoPresent__c = mapDaywiseFOCount.get(5);
                        }
                        if(mapDaywiseFOCount.containsKey(6)){
                            abd.Last7DayFoPresent__c = mapDaywiseFOCount.get(6);
                        }
                    } 
                   
                     if(mapNonFOPresentCountDaywise.containsKey(tehsilKey) ){
                       
                        mapDaywiseNonFOCount =  mapNonFOPresentCountDaywise.get(tehsilKey);
                        if(mapDaywiseNonFOCount.containsKey(0)){
                        
                            abd.Last1DayNonFoPresent__c= mapDaywiseNonFOCount.get(0);
                        }
                        if(mapDaywiseNonFOCount.containsKey(1)){
                            abd.Last2DayNonFoPresent__c= mapDaywiseNonFOCount.get(1);
                        }
                        if(mapDaywiseNonFOCount.containsKey(2)){
                        
                            abd.Last3DayNonFoPresent__c = mapDaywiseNonFOCount.get(2);
                        }
                        if(mapDaywiseNonFOCount.containsKey(3)){
                            abd.Last4DayNonFoPresent__c = mapDaywiseNonFOCount.get(3);
                        }
                        if(mapDaywiseNonFOCount.containsKey(4)){
                            abd.Last5DayNonFoPresent__c = mapDaywiseNonFOCount.get(4);
                        }
                        if(mapDaywiseNonFOCount.containsKey(5)){
                            abd.Last6DayNonFoPresent__c = mapDaywiseNonFOCount.get(5);
                        }
                        if(mapDaywiseNonFOCount.containsKey(6)){
                            abd.Last7DayNonFoPresent__c = mapDaywiseNonFOCount.get(6);
                        }
                    }
                    
                   listAKCDashboard.add(abd);
             }
             
             IF(listAKCDashboard.Size()>0){
                 Database.UpsertResult [] cr = Database.upsert(listAKCDashboard,extObj,false);
             }
    }
}