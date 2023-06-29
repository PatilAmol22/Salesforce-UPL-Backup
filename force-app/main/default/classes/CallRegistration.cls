public class CallRegistration{
 
@Remoteaction
@Readonly
 Public static void IncomingCalls() {
 
 Schema.SObjectField extObj;
 Map<String,Map<Integer,Integer>> mapFOPresentCountDaywise = new Map<String,Map<Integer,Integer>>();
 Map<String,Map<Integer,Integer>> mapNonFOPresentCountDaywise = new Map<String,Map<Integer,Integer>>();
 
 system.debug('===enterd '+new list<AggregateResult>([SELECT case.contact.Village__r.Tehsil__c tehsil,DAY_IN_WEEK(CreatedDate) CRT,count(case.contact.Fo_present__c) fopresent FROM case WHERE CreatedDate = LAST_N_DAYS :7 and case.contact.Fo_present__c = 1 and case.RecordType.name = 'AKC General Case'  group by case.contact.Village__r.Tehsil__c,DAY_IN_WEEK(CreatedDate) order by DAY_IN_WEEK(CreatedDate) asc]));
    for(AggregateResult result :[SELECT case.contact.Village__r.Tehsil__c tehsil,DAY_IN_WEEK(CreatedDate) CRT,count(case.contact.Fo_present__c) fopresent FROM case WHERE CreatedDate = LAST_N_DAYS :7 and case.contact.Fo_present__c = 1 and case.RecordType.name = 'AKC General Case'  group by case.contact.Village__r.Tehsil__c,DAY_IN_WEEK(CreatedDate) order by DAY_IN_WEEK(CreatedDate) asc]) {
        
        Map<Integer,Integer> mapDaywiseFOCount = new Map<Integer,Integer>();
        mapDaywiseFOCount.put(Integer.valueOf(result.get('CRT')),Integer.valueOf(result.get('fopresent')));
        mapFOPresentCountDaywise.put(''+result.get('tehsil'),mapDaywiseFOCount); 
      }
      
      for(AggregateResult result :[SELECT case.contact.Village__r.Tehsil__c tehsil,DAY_IN_WEEK(CreatedDate) CRT,count(case.contact.Non_Fo_present__c) Nonfopresent FROM case WHERE CreatedDate = LAST_N_DAYS :7 and case.contact.Non_Fo_present__c = 1 and case.RecordType.name = 'AKC General Case'  group by case.contact.Village__r.Tehsil__c,DAY_IN_WEEK(CreatedDate) order by DAY_IN_WEEK(CreatedDate) asc]) {
        
        Map<Integer,Integer> mapDaywiseNonFOCount = new Map<Integer,Integer>();
        mapDaywiseNonFOCount.put(Integer.valueOf(result.get('CRT')),Integer.valueOf(result.get('Nonfopresent')));
        mapNonFOPresentCountDaywise.put(''+result.get('tehsil'),mapDaywiseNonFOCount); 
      }
      
      
      List<Akc_Business_dashboard__c> listAKCDashboard = new List<Akc_Business_dashboard__c>();
      
      for(Tehsil__c tehsil : [Select id From Tehsil__c]){
        Akc_Business_dashboard__c abd = new Akc_Business_dashboard__c();
        
        Date d = System.today();
        Datetime myDT = datetime.newInstance(d.year(),d.month(),d.day());
        String todayDate = myDT.format('yyyy-MM-dd');
        
        abd.combinationKey__c=tehsil.id+''+todayDate;
        abd.Tehsil__c = tehsil.id;
        extObj = Akc_Business_dashboard__c.Fields.CombinationKey__c;

  

if(mapFOPresentCountDaywise.containsKey(tehsil.id) ){
            Map<Integer,Integer> mapDaywiseFOCount = new Map<Integer,Integer>();
            mapDaywiseFOCount =  mapFOPresentCountDaywise.get(tehsil.id);
            if(mapDaywiseFOCount.containsKey(1)){
                abd.Last1DayFoPresent__c = mapDaywiseFOCount.get(1);
            }
            if(mapDaywiseFOCount.containsKey(2)){
                abd.Last2DayFoPresent__c = mapDaywiseFOCount.get(2);
            }
            if(mapDaywiseFOCount.containsKey(3)){
                abd.Last3DayFoPresent__c = mapDaywiseFOCount.get(3);
            }
            if(mapDaywiseFOCount.containsKey(4)){
                abd.Last4DayFoPresent__c = mapDaywiseFOCount.get(4);
                System.debug('====Entered 4 here=====');
            }
            if(mapDaywiseFOCount.containsKey(5)){
            System.debug('===Before Entered 5 for Fo====');
                abd.Last5DayFoPresent__c = mapDaywiseFOCount.get(5);
                System.debug('====After Entered 5 for Fo=====');
            }
            if(mapDaywiseFOCount.containsKey(6)){
                abd.Last6DayFoPresent__c = mapDaywiseFOCount.get(6);
            }
            if(mapDaywiseFOCount.containsKey(7)){
                abd.Last7DayFoPresent__c = mapDaywiseFOCount.get(7);
            }
        }
        
        
        if(mapNonFOPresentCountDaywise.containsKey(tehsil.id) ){
            Map<Integer,Integer> mapDaywiseNonFOCount = new Map<Integer,Integer>();
            mapDaywiseNonFOCount =  mapNonFOPresentCountDaywise.get(tehsil.id);
            if(mapDaywiseNonFOCount.containsKey(1)){
                abd.Last1DayNonFoPresent__c= mapDaywiseNonFOCount.get(1);
            }
            if(mapDaywiseNonFOCount.containsKey(2)){
                abd.Last2DayNonFoPresent__c= mapDaywiseNonFOCount.get(2);
            }
            if(mapDaywiseNonFOCount.containsKey(3)){
                abd.Last3DayNonFoPresent__c = mapDaywiseNonFOCount.get(3);
            }
            if(mapDaywiseNonFOCount.containsKey(4)){
                abd.Last4DayNonFoPresent__c = mapDaywiseNonFOCount.get(4);
            }
            if(mapDaywiseNonFOCount.containsKey(5)){
             System.debug('===Entered 5 for Non Fo====');
                abd.Last5DayNonFoPresent__c = mapDaywiseNonFOCount.get(5);
                System.debug('===Entered 5 for Non Fo====');
            }
            if(mapDaywiseNonFOCount.containsKey(6)){
                abd.Last6DayNonFoPresent__c = mapDaywiseNonFOCount.get(6);
            }
            if(mapDaywiseNonFOCount.containsKey(7)){
                abd.Last7DayNonFoPresent__c = mapDaywiseNonFOCount.get(7);
            }
        }
        
         listAKCDashboard.add(abd);
        
        
        }
   Database.UpsertResult [] cr = Database.upsert(listAKCDashboard,extObj,false);
 }
}