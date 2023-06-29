public class TotalRegistration {

   
@Remoteaction
@Readonly
public static void getcontact() {
Schema.SObjectField extObj;

    /* For Ownership logic */
    Map<String,TM_District_Tehsil_Mapping__c> TehsilTMMap = new Map<String,TM_District_Tehsil_Mapping__c>();
    List<TM_District_Tehsil_Mapping__c> MappingList = new List<TM_District_Tehsil_Mapping__c>([select id, District__c, Tehsil__c, Territory__c,TM_User__c
                                                                                                                             from TM_District_Tehsil_Mapping__c]);
        TehsilTMMap = new Map<String,TM_District_Tehsil_Mapping__c>();
         for(TM_District_Tehsil_Mapping__c tdm : MappingList){
            TehsilTMMap.put(String.valueof(tdm.Tehsil__c),tdm);
        }
    /* END */
    List<contact> monthcount = new List<contact>();
    Map<String,Integer> mapMonthCountFo = new Map<String,Integer>();
    Map<String,Integer> mapMonthCountNonFo = new Map<String,Integer>();
    Map<String,Integer> mapYearCountFo = new Map<String,Integer>();
    Map<String,Integer> mapYearCountNonFo = new Map<String,Integer>();
    Map<String,Integer> mapTotalRegistrationFo = new Map<String,Integer>();
    Map<String,Integer> mapTotalregistrationNonFo = new Map<String,Integer>();
          
    for(AggregateResult result :[SELECT contact.Village__r.Tehsil__c tehsil,count(Fo_present__c) fopresent FROM contact WHERE CreatedDate = This_Month and FO_Present__c = 1 group by contact.Village__r.Tehsil__c]){
        mapMonthCountFo.put(''+result.get('tehsil'),Integer.valueOf(result.get('fopresent'))); 
    }      
    for(AggregateResult result :[SELECT contact.Village__r.Tehsil__c tehsil,count(Non_FO_Present__c) nonfopresent FROM contact WHERE CreatedDate = This_Month and Non_FO_Present__c = 1 group by contact.Village__r.Tehsil__c]){
        mapMonthCountNonFo.put(''+result.get('tehsil'),Integer.valueOf(result.get('nonfopresent')));
    }
    for(AggregateResult result :[SELECT contact.Village__r.Tehsil__c tehsil,count(Fo_present__c) fopresentyear FROM contact WHERE CreatedDate = This_Year and FO_Present__c = 1 group by contact.Village__r.Tehsil__c]){
        mapYearCountFo.put(''+result.get('tehsil'),Integer.valueOf(result.get('fopresentyear')));
    }
    for(AggregateResult result :[SELECT contact.Village__r.Tehsil__c tehsil,count(Non_FO_Present__c) nonfopresentyear FROM contact WHERE CreatedDate = This_Year and Non_FO_Present__c = 1 group by contact.Village__r.Tehsil__c]){
        mapYearCountNonFo.put(''+result.get('tehsil'),Integer.valueOf(result.get('nonfopresentyear')));
    }
    for(AggregateResult result :[SELECT contact.Village__r.Tehsil__c tehsil,count(Fo_present__c) totalRegistrationFoPresent FROM contact WHERE CreatedDate != null and FO_Present__c = 1 group by contact.Village__r.Tehsil__c]){
        mapTotalRegistrationFo.put(''+result.get('tehsil'),Integer.valueOf(result.get('totalRegistrationFoPresent')));
    }
    for(AggregateResult result :[SELECT contact.Village__r.Tehsil__c tehsil,count(Fo_present__c) fopresent FROM contact WHERE CreatedDate  != null  and Non_FO_Present__c = 1 group by contact.Village__r.Tehsil__c]){
        mapTotalregistrationNonFo.put(''+result.get('tehsil'),Integer.valueOf(result.get('fopresent')));
    }
   
    List<Akc_Business_dashboard__c> listAKCDashboard = new List<Akc_Business_dashboard__c>();
    
    for(Tehsil__c tehsil : [Select id From Tehsil__c]){
        Akc_Business_dashboard__c abd = new Akc_Business_dashboard__c();
        
        Date d = System.today();
        Datetime myDT = datetime.newInstance(d.year(), d.month(),d.day());
        String todayDate = myDT.format('yyyy-MM-dd');
        
        abd.combinationKey__c=tehsil.id+''+todayDate;
        
        abd.Tehsil__c = tehsil.id;
        extObj = Akc_Business_dashboard__c.Fields.CombinationKey__c;

        /* Ownership logic */
        if(TehsilTMMap.containsKey(tehsil.id)){
            abd.Territory__c = TehsilTMMap.get(tehsil.id).Territory__c;
            abd.OwnerID = TehsilTMMap.get(tehsil.id).TM_User__c;
        }
        /* End */
        if( mapMonthCountFo.containsKey(tehsil.id) ){
            abd.Current_Month_Fo_Present__c =  mapMonthCountFo.get(tehsil.id);
        }
        if( mapMonthCountNonFo.containsKey(tehsil.id) ){
            abd.Current_Month_Non_Fo_present__c =  mapMonthCountNonFo.get(tehsil.id);
        }
        if( mapYearCountFo.containsKey(tehsil.id) ){
            abd.Current_Year_Fo_Present__c =  mapYearCountFo.get(tehsil.id);
        }
        if( mapYearCountNonFo.containsKey(tehsil.id) ){
            abd.Current_Year_Non_Fo_present__c =  mapYearCountNonFo.get(tehsil.id);
        }
        if( mapTotalRegistrationFo.containsKey(tehsil.id) ){
            abd.Total_Registration_Fo_Present__c =  mapTotalRegistrationFo.get(tehsil.id);
        }
        if( mapTotalregistrationNonFo.containsKey(tehsil.id) ){
            abd.Total_Registration_Non_Fo_Present__c =  mapTotalregistrationNonFo.get(tehsil.id);
        }
        
        
        listAKCDashboard.add(abd);
    }
    
    try {
   Database.UpsertResult [] cr = Database.upsert(listAKCDashboard,extObj,false);
   } catch(exception e) {
   system.debug('Exception:    '+e);
   }
 }
}