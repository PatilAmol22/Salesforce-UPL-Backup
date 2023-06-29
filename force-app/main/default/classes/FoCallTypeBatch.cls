global without sharing class FoCallTypeBatch Implements Database.Batchable<sObject>,Database.Stateful{

    /*
        Fo Call Type  -----------
         
        Written By - Pravin J.
        Date - 29/10/2017 
        
    */   
    
    public Map<String,Tehsil__c> mapofTehsil = new Map<String,Tehsil__c>();
    public Schema.SObjectField extObj;
    public Schema.SObjectField extObj1;
    public List<Akc_Business_dashboard__c> listAKCDashboard = new List<Akc_Business_dashboard__c>();
    public List<Akc_Business_dashboard__c> listAKCDashboard1 = new List<Akc_Business_dashboard__c>();
    
    public Map<String,Map<String,Map<Integer,Integer>>> mapFoData = new Map<String,Map<String,Map<Integer,Integer>>>();
    public Map<String,Map<String,Map<Integer,Integer>>> mapNonData = new Map<String,Map<String,Map<Integer,Integer>>>();
    
    public String todayDate;
    
    public FoCallTypeBatch(){
    
        System.debug('FoCallTypeBatch started at-->'+ system.now());
        Date d = System.today();
        Datetime myDT = datetime.newInstance(d.year(),d.month(),d.day());
        todayDate = myDT.format('yyyy-MM-dd');
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        System.debug('ThisMonthTotalRegistrationBatch_start==>');
        String query;
        Integer minDay = 0 ;
        Integer maxDay = 7 ;
        Integer fovalue = 1;
        
        try{
        
            
            Id RecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
        
            List<String> lstOfCaseType = new List<string>();
            List<String> options = new List<string>();
            options = PicklistDescriber.describe('Case', RecType, 'Type');
            
           /* for(String str : options){
                System.debug('Str==>'+str);
                lstOfCaseType.add(str);
            }*/
            
            if(!Test.isRunningTest()){
                for(String str : options){
                    lstOfCaseType.add(str);
                }
            }else{
                lstOfCaseType.add('Advisory Related');
                lstOfCaseType.add('AFS');
                lstOfCaseType.add('Appreciation');
                lstOfCaseType.add('Axeda Survey');
                lstOfCaseType.add('Disease');
                lstOfCaseType.add('Fertilizer');
                lstOfCaseType.add('Insect');
                lstOfCaseType.add('Irrigation');
                lstOfCaseType.add('Land preparation');
                lstOfCaseType.add('Mandi price');
                lstOfCaseType.add('PGR');
                lstOfCaseType.add('Product');
                lstOfCaseType.add('Rainfall');
                lstOfCaseType.add('Seed Selection');
                lstOfCaseType.add('Seed Treatment');
                lstOfCaseType.add('Flowering and Fruiting related');
                lstOfCaseType.add('Forage crops – Cultivation');
                lstOfCaseType.add('Forage crops – Other information');
                lstOfCaseType.add('Forage crops - Seed availability/Enquiry');
                lstOfCaseType.add('Forage crops - Seed Subsidy Enquiry');
                lstOfCaseType.add('Inter cultivation');
                lstOfCaseType.add('Non crop related');
                lstOfCaseType.add('Nutrient deficiency');
                lstOfCaseType.add('Seed Treatment');
                lstOfCaseType.add('Sowing/Nursery');
                lstOfCaseType.add('Weed');
            
            } 
            
            query = 'SELECT Tehsil_Id__c,CreatedDate,DayInWeek__c,FO_Present__c,Type,Non_FO_Present__c  ';
            query += 'FROM CASE ';
            query += ' WHERE (type IN: lstOfCaseType ';
            query += 'AND DayInWeek__c >=: minDay AND DayInWeek__c <: maxDay )';
            
            System.debug('query==>>'+query);
                            
        }catch(Exception ex){
        
            System.debug('ErrorLine==>'+ex.getLineNumber());
            System.debug('Error==>'+ex);
        }
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Case > lstOfCases){ 
                   
            System.debug('lstOfCases===>'+lstOfCases);           
            
            // Var Declaration ----------------
            Map<Integer,Integer> mapInner = new Map<Integer,Integer>();
            Integer incFoVal = 0;
            Integer incNonFoVal = 0;
        
             
                for(Case casesRec : lstOfCases){
                   System.debug('casesRec===>'+casesRec.FO_Present__c);
                
                     if(casesRec.FO_Present__c == 1){
                         
                       //  for(Tehsil__c tehsil : [Select id,Name From Tehsil__c where id =: casesRec.Tehsil_Id__c]){
                        
                            Map<Integer,Integer> mapDay = new Map<Integer,Integer>();
                            Map<String,Map<Integer,Integer>> mapType = new Map<String,Map<Integer,Integer>>();        
                            if(mapFoData.containsKey(casesRec.Tehsil_Id__c)){
                            
                                mapType = mapFoData.get(casesRec.Tehsil_Id__c);
                                
                                if(mapType.containsKey(casesRec.Type)){
                                
                                    mapDay = mapType.get(casesRec.Type);
                                    Integer dayCount = 0;
                                    
                                    if(mapDay.containsKey(Integer.valueOf(casesRec.DayInWeek__c))){
                                        
                                        dayCount = mapDay.get(Integer.valueOf(casesRec.DayInWeek__c));
                                        dayCount += 1; 
                                        mapDay.put(Integer.valueOf(casesRec.DayInWeek__c),dayCount);
                                    }else{
                                    
                                        dayCount = 1; 
                                        mapDay.put(Integer.valueOf(casesRec.DayInWeek__c),dayCount);
                                      
                                    }
                                }else{
                                
                                    Integer count = 1 ;
                                    mapDay.put(Integer.valueOf(casesRec.DayInWeek__c),count);
                                    mapType.put(casesRec.Type,mapDay);
                                }
                            }else{
                            
                                Integer count = 1 ;
                                mapDay.put(Integer.valueOf(casesRec.DayInWeek__c),count);
                                mapType.put(casesRec.Type,mapDay);  
                                mapFoData.put(casesRec.Tehsil_Id__c,mapType);
                            }
                            
                          // }// Tehsil End
                     }
                     
                     if(casesRec.Non_FO_Present__c == 1){
                         
                         Map<Integer,Integer> mapDay1 = new Map<Integer,Integer>();
                            Map<String,Map<Integer,Integer>> mapType1 = new Map<String,Map<Integer,Integer>>();  
                                  
                            if(mapNonData.containsKey(casesRec.Tehsil_Id__c)){
                            
                                mapType1 = mapNonData.get(casesRec.Tehsil_Id__c);
                                
                                if(mapType1.containsKey(casesRec.Type)){
                                
                                    mapDay1 = mapType1.get(casesRec.Type);
                                    Integer dayCount = 0;
                                    
                                    if(mapDay1.containsKey(Integer.valueOf(casesRec.DayInWeek__c))){
                                        
                                        dayCount = mapDay1.get(Integer.valueOf(casesRec.DayInWeek__c));
                                        dayCount += 1; 
                                        mapDay1.put(Integer.valueOf(casesRec.DayInWeek__c),dayCount);
                                        
                                    }else{
                                    
                                        dayCount = 1; 
                                        mapDay1.put(Integer.valueOf(casesRec.DayInWeek__c),dayCount);
                                      
                                    }
                                }else{
                                
                                    Integer count = 1 ;
                                    mapDay1.put(Integer.valueOf(casesRec.DayInWeek__c),count);
                                    mapType1.put(casesRec.Type,mapDay1);
                                }
                            }else{
                            
                                Integer count = 1 ;
                                mapDay1.put(Integer.valueOf(casesRec.DayInWeek__c),count);
                                mapType1.put(casesRec.Type,mapDay1);  
                                mapNonData.put(casesRec.Tehsil_Id__c,mapType1);
                            }
                            
                           }// Tehsil End
                 
                }// lstofCase loop End
            
            System.debug('mapFoData===>'+mapFoData); 
            System.debug('mapNonData===>'+mapNonData);
    }
   
    global void finish(Database.BatchableContext BC){
    
        System.debug('finish==>');
       
        for(String tehsilKey : mapFoData.keyset()){
            
                Akc_Business_dashboard__c abd = new Akc_Business_dashboard__c();
                
                
                abd.Last1DayFOCallType__c = '';
                abd.Last2DayFOCallType__c = '';
                abd.Last3DayFOCallType__c = '';
                abd.Last4DayFOCallType__c = '';
                abd.Last5DayFOCallType__c = '';
                abd.Last6DayFOCallType__c = '';
                abd.Last7DayFOCallType__c = '';
                
                abd.combinationKey__c=tehsilKey+''+todayDate;
                abd.Tehsil__c = tehsilKey;
                extObj = Akc_Business_dashboard__c.Fields.CombinationKey__c;
                
                for(String TypeValue : mapFoData.get(tehsilKey).keySet()){
                     
                    System.debug('TypeValue==>'+TypeValue);
                    for(Integer Day : mapFoData.get(tehsilKey).get(typeValue).keySet()){
                    
                        System.debug('Day==>'+Day);
                        if(Day == 0){
                                
                            System.debug('Last1DayFOCallType__c ---->'+abd.Last1DayFOCallType__c);
                            abd.Last1DayFOCallType__c += TypeValue +'- '+ mapFoData.get(tehsilKey).get(typeValue).get(Day)+',';
                        }
                        
                        if(Day == 1){
                            
                             System.debug('abd.Last2DayFOCallType__c-->'+abd.Last2DayFOCallType__c);
                             abd.Last2DayFOCallType__c += TypeValue +'- '+ mapFoData.get(tehsilKey).get(typeValue).get(Day)+',';
                        }
                        
                        if(Day == 2){
                        
                            System.debug('abd.Last3DayFOCallType__c-->'+abd.Last3DayFOCallType__c);
                            abd.Last3DayFOCallType__c += TypeValue +'- '+ mapFoData.get(tehsilKey).get(typeValue).get(Day)+',';
                            
                        }
                        
                        if(Day == 3){
                                    
                            System.debug('abd.Last4DayFOCallType__c-->'+abd.Last4DayFOCallType__c);
                            abd.Last4DayFOCallType__c += TypeValue +'- '+ mapFoData.get(tehsilKey).get(typeValue).get(Day)+',';
                            
                        }
                        
                        if(Day == 4){
                        
                            System.debug('abd.Last5DayFOCallType__c-->'+abd.Last5DayFOCallType__c);
                            abd.Last5DayFOCallType__c += TypeValue +'- '+ mapFoData.get(tehsilKey).get(typeValue).get(Day)+',';
                            
                        }
                        
                        if(Day == 5){
                        
                            System.debug('abd.Last6DayFOCallType__c-->'+abd.Last6DayFOCallType__c);
                            abd.Last6DayFOCallType__c += TypeValue +'- '+ mapFoData.get(tehsilKey).get(typeValue).get(Day)+',';
                            
                        }
                        
                        if(Day == 6){
                        
                            System.debug('abd.Last7DayFOCallType__c-->'+abd.Last7DayFOCallType__c);
                            abd.Last7DayFOCallType__c += TypeValue +'- '+ mapFoData.get(tehsilKey).get(typeValue).get(Day)+',';
                        }
                    }
                }
                
                listAKCDashboard.add(abd);
                System.debug('listAKCDashboard==>'+listAKCDashboard);
                
        }
        
        // Upserting Non- Fo data
        
        for(String tehsilKey : mapNonData.keyset()){
            
                Akc_Business_dashboard__c abd = new Akc_Business_dashboard__c();
                Date d = System.today();
                
                abd.Last1DayNonFOCallType__c = '';
                abd.Last2DayNonFOCallType__c = '';
                abd.Last3DayNonFOCallType__c = '';
                abd.Last4DayNonFOCallType__c = '';
                abd.Last5DayNonFOCallType__c = '';
                abd.Last6DayNonFOCallType__c = '';
                abd.Last7DayNonFOCallType__c = '';
                
                Datetime myDT = datetime.newInstance(d.year(),d.month(),d.day());
                String todayDate = myDT.format('yyyy-MM-dd');
                abd.combinationKey__c=tehsilKey+''+todayDate;
                abd.Tehsil__c = tehsilKey;
                System.debug('abd.Tehsil__c--->'+abd.Tehsil__c);
                extObj1 = Akc_Business_dashboard__c.Fields.CombinationKey__c;
                for(String TypeValue : mapNonData.get(tehsilKey).keySet()){
                    for(Integer Day : mapNonData.get(tehsilKey).get(typeValue).keySet()){
                    
                      System.debug('nonfo-Day==>'+Day);
                        
                        if(Day == 0){
                                abd.Last1DayNonFOCallType__c += TypeValue +'- '+ mapNonData.get(tehsilKey).get(typeValue).get(Day)+',';
                        }
                        if(Day == 1){
                                abd.Last2DayNonFOCallType__c += TypeValue +'- '+ mapNonData.get(tehsilKey).get(typeValue).get(Day)+',';
                        }
                        if(Day == 2){
                                abd.Last3DayNonFOCallType__c += TypeValue +'- '+ mapNonData.get(tehsilKey).get(typeValue).get(Day)+',';
                        }
                        if(Day == 3){
                                abd.Last4DayNonFOCallType__c += TypeValue +'- '+ mapNonData.get(tehsilKey).get(typeValue).get(Day)+',';
                        }
                        if(Day == 4){
                                abd.Last5DayNonFOCallType__c += TypeValue +'- '+ mapNonData.get(tehsilKey).get(typeValue).get(Day)+',';
                        }
                        if(Day == 5){
                                abd.Last6DayNonFOCallType__c += TypeValue +'- '+ mapNonData.get(tehsilKey).get(typeValue).get(Day)+',';
                        }
                        if(Day == 6){
                                abd.Last7DayNonFOCallType__c += TypeValue +'- '+ mapNonData.get(tehsilKey).get(typeValue).get(Day)+',';
                        }
                    }
                }
               listAKCDashboard1.add(abd);
               System.debug('listAKCDashboard1==>'+listAKCDashboard1.size());
        }
        
         if(listAKCDashboard.size()>0){
             Database.UpsertResult [] cr = Database.upsert(listAKCDashboard, extObj , false);
         }
         
         if(listAKCDashboard1.size()>0){
             Database.UpsertResult [] cr1 = Database.upsert(listAKCDashboard1, extObj1 , false);
         }
         
         
    }   
}