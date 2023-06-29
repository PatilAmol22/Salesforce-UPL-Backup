public class TravelExpensesController {
    
    
    /*public static List<String> getItems(sObject o_Object, String item){

List<String> arrayList=new List<String>();

Schema.SObjectType obj_type=  o_Object.getSObjectType();

Schema.DescribeSObjectResult objDescribe = obj_type.getDescribe();
map <String, Schema.SObjectField > fMap = objDescribe.fields.getMap();

list < Schema.PicklistEntry > values = fMap.get(item).getDescribe().getPickListValues();

for(Schema.PicklistEntry sp: values){
arrayList.add(sp.getValue());
}

return arrayList;
}*/ 
    
    @AuraEnabled
    public static List<Profile> getProfileName(){
        
        List<Profile> prof= [Select Id, Name From Profile where id =:userinfo.getProfileId() Limit 1];
        System.debug('prof :- '+prof);
        return prof;
        
    }
    
    
    @AuraEnabled
    public static List<String> getMonthItemsType(){
        // UPL-2-I386: Modified by:Ankita Saxena Changes in Travel request  for Indonesia
        Set<String> options = new Set<String>();
        List<String> optList = new List<String>();
        for(Monthly_Travel_Expense__c ptObj:[Select id, Month__c from Monthly_Travel_Expense__c Where TotalAmount__c > 0 ORDER BY Month__c ASC]){
            options.add(ptObj.Month__c);}
        optList.addAll(options);
        return optList;
    } 
    @AuraEnabled
    public static List<String> getYearItemsType(){
        
        List<String> options = new List<String>();
        Set<String> s = new Set<String>();
        
        List<Monthly_Travel_Expense__c> mte_list= [Select id, Month__c from Monthly_Travel_Expense__c Where TotalAmount__c > 0 ORDER BY Month__c ASC];
        for(Integer i=0 ; i< mte_list.size() ;i++){
            String[] str = mte_list[i].Month__c.split(' ');
            s.add(str[1]);
        }
        options.addAll(s);
        return options;
    } 
    @AuraEnabled
    public static List<String> getItemsType(){
        List<String> arrayList=new List<String>();
        Schema.DescribeFieldResult fieldResult = Expense_Item__c.Item__c.getDescribe();
        List <Schema.PicklistEntry > values = fieldResult.getPickListValues();
        for(Schema.PicklistEntry sp: values){
            arrayList.add(sp.getLabel());
        }
        return arrayList; 
    } 
    
    @AuraEnabled     
    public static PagedResult getActivities(Decimal pageNumber ,Integer recordToDisply, String sortField, boolean isAsc, String whereClause) {  
        Integer pageSize = recordToDisply;  
        Integer offset = ((Integer)pageNumber - 1) * pageSize; 
        
        PagedResult obj = new PagedResult();  
        obj.pageSize = pageSize;  
        obj.page = (Integer) pageNumber;  
        
        obj.total = [SELECT count() FROM Monthly_Travel_Expense__c]; 
        System.debug('obj.total ::: ' + obj.total);
        System.debug('isAsc ::: ' + isAsc);
        System.debug('recordToDisply ::: ' + recordToDisply);
        String query = '';
        if(String.isBlank(whereClause)){
            
            //String strQuery= 'Select Id, Month__c, Comment__c, TotalAmount__c from Monthly_Travel_Expense__c where TotalAmount__c > 0';
            //System.debug('strQuery ::: ' + strQuery);
            //RM_Approval_Status__c, NSM_Approved_Status__c, CH_Approved_Status__c, 
            query = 'Select Id, Month__c, RM__c, NSM__c, NMM__c, CH__c,  TotalAmount__c, Status__c, CreatedById, CreatedBy.Name from Monthly_Travel_Expense__c WHERE TotalAmount__c > 0 ORDER BY ' +sortField +(isAsc? ' ASC':' DESC')+' LIMIT '+recordToDisply+' OFFSET '+offset;
        }
        else{
            //RM_Approval_Status__c, NSM_Approved_Status__c, CH_Approved_Status__c, 
            query = 'Select Id, Month__c, RM__c, NSM__c, NMM__c, CH__c, TotalAmount__c, Status__c, CreatedById, CreatedBy.Name from Monthly_Travel_Expense__c ' +whereClause+' AND TotalAmount__c > 0 ORDER BY '+sortField + (isAsc? ' ASC':' DESC')+ ' LIMIT '+recordToDisply+' OFFSET '+offset;
        }
        System.debug('query ::: ' + query);
        
        obj.results = Database.Query(query); 
        
        if(String.isNotBlank(whereClause)){
            obj.total = obj.results.size();
        }
        
        return obj;  
    }  
    
    public class PagedResult {  
        @AuraEnabled public Integer pageSize {get;set;}  
        @AuraEnabled public Integer page {get;set;}  
        @AuraEnabled public Integer total {get;set;}  
        @AuraEnabled public List<Monthly_Travel_Expense__c> results {get;set;}  
    } 
    @AuraEnabled
    public static Monthly_Travel_Expense__c deleteMTERecord(Monthly_Travel_Expense__c mte_obj, String recordId){
        
        List<Monthly_Travel_Expense__c> arrayList=[Select Id, Month__c, TotalAmount__c 
                                                   from Monthly_Travel_Expense__c
                                                   where Id =: recordId ];
        delete arrayList;
        return mte_obj;
        
    }
    @AuraEnabled
    public static Expense_Item__c deletePerMTERecord(Expense_Item__c e_obj, String recordId){
        
        System.debug('recordId :- '+ recordId);
        List<Expense_Item__c> arrayList=[Select id, Name, Item__c, Date__c, 
                                         Purpose__c, Month__c, Location__c, 
                                         Amount__c, Remarks__c FROM Expense_Item__c
                                         where Id =: recordId ];
        
        
        delete arrayList;
        
        return e_obj;
        /* List<Monthly_Travel_Expense__c> m_arrayList=[Select Id, Month__c,
Comment__c, TotalAmount__c 
from Monthly_Travel_Expense__c
where Id =: mte_rec_id];
System.debug('mte_rec_id : '+mte_rec_id);

for(Monthly_Travel_Expense__c mte_obj: m_arrayList){

System.debug('amnt : '+mte_obj.TotalAmount__c);

if(mte_obj.TotalAmount__c == 0.00){
System.debug('amnt is zero');
delete m_arrayList;
}else{
System.debug('amnt is more than zero');
}

}*/ 
    }
    @AuraEnabled
    public static list<Monthly_Travel_Expense__c> getMTExpense(list<Monthly_Travel_Expense__c> mteObj){
        
        List<Monthly_Travel_Expense__c> arrayList= [Select Id,Name, Month__c,
                                                    TotalAmount__c
                                                    from Monthly_Travel_Expense__c];
        System.debug('arrayList :- '+arrayList);
        
        return arrayList;
        
    } 
    
    @AuraEnabled
    public static list<Expense_Item__c> getPerMTExpense(String mte_id){
        
        List<Expense_Item__c> arrayList = [SELECT id, Name, Item__c, Date__c, 
                                           Purpose__c,Month__c, Location__c, 
                                           Amount__c, Remarks__c FROM Expense_Item__c
                                           where Monthly_Travel_Expenses__c =: mte_id ];
        System.debug('arrayList :- '+arrayList);
        
        return arrayList;
        
    } 
    
    @AuraEnabled
    public static list<Expense_Item__c> getExistPerMTExpense(String mte_id){
        
        List<Expense_Item__c> arrayList = [SELECT id, Name, Item__c, Date__c, 
                                           Purpose__c,Month__c, Location__c, 
                                           Amount__c, Remarks__c FROM Expense_Item__c
                                           where id =: mte_id ];
        System.debug('arrayList :- '+arrayList);
        
        return arrayList;
        
    } 
    @AuraEnabled
    public static list<Expense_Item__c> saveTravelExpense(list<Expense_Item__c> eiObj){       
        
        system.debug('eiObj=====>'+eiObj);
        Map<String,Monthly_Travel_Expense__c> existmapfortravel = new Map<String,Monthly_Travel_Expense__c>();
        Map<String,List<Expense_Item__c>> mapfortravel = new Map<String,List<Expense_Item__c>>(); 
        List<Expense_Item__c> lstForMonth = new List<Expense_Item__c>();
        List<Expense_Item__c> lstForinsert = new List<Expense_Item__c>();
        List<Monthly_Travel_Expense__c> lstforExisting = new List<Monthly_Travel_Expense__c>();
        
        // try{
        
        lstforExisting = [select id,month__c
                          from Monthly_Travel_Expense__c 
                          // where createddate=:THIS_YEAR
                         ];
        
        System.debug('lstforExisting -->'+lstforExisting);
        if(lstforExisting.size()>0){
            for(Monthly_Travel_Expense__c exsitobj :  lstforExisting){
                if(!existmapfortravel.containsKey(exsitobj.Month__c)){
                    existmapfortravel.put(exsitobj.Month__c, exsitobj);
                    System.debug('exsitobj -->'+exsitobj);
                    System.debug('existmapfortravel inside -->'+existmapfortravel);
                }
            } 
        }
        
        System.debug('existmapfortravel -->'+existmapfortravel);
        
        if(existmapfortravel.size()>0){
            for(String existId : existmapfortravel.keySet()){
                
                List<Expense_Item__c> lstForMonthblank = new List<Expense_Item__c>();
                mapfortravel.put(existId, lstForMonthblank);
            }                
        }
        System.debug('mapfortravel-->'+mapfortravel);
        System.debug('mapfortravel keyset-->'+mapfortravel.keySet());
        
        /* for(Expense_Item__c expense : eiObj){

if(mapfortravel.containsKey(expense.Month__c)){
System.debug('InsideLoop-->'+expense.Month__c);
}else{
System.debug('ELSE');
}
}*/
        
        for(Expense_Item__c expense : eiObj){                 
            if(mapfortravel.containsKey(expense.Month__c)){
                lstForMonth = mapfortravel.get(expense.Month__c);
                lstForMonth.add(expense);
                mapfortravel.put(expense.Month__c, lstForMonth); 
            }else{
                System.debug('ELSE-->');
                lstForMonth = new List<Expense_Item__c>();
                lstForMonth.add(expense);
                mapfortravel.put(expense.Month__c, lstForMonth); 
            }
        }
        
        System.debug('mapfortravel keyset 2 -->'+mapfortravel.keySet());
        for(string key : mapfortravel.keySet()){
            System.debug('key -->'+mapfortravel.keySet());
            //for(Monthly_Travel_Expense__c exsitobj :  lstforExisting){
            
            Monthly_Travel_Expense__c obj = new Monthly_Travel_Expense__c();
            Monthly_Travel_Expense__c existRecord = new Monthly_Travel_Expense__c();
            existRecord = existmapfortravel.get(key);
            if(existRecord == null){
                
                obj.Month__c = key;
                insert obj;                    
                List<Expense_Item__c> lstofMonth = new List<Expense_Item__c>();
                lstofMonth = mapfortravel.get(key);  
                
                for(Expense_Item__c exp : lstofMonth){
                    
                    Expense_Item__c expItemObj = new Expense_Item__c();
                    expItemObj.Item__c = exp.Item__c;
                    expItemObj.Date__c = exp.Date__c;
                    expItemObj.Purpose__c = exp.Purpose__c;
                    expItemObj.Month__c = exp.Month__c;
                    expItemObj.Location__c = exp.Location__c;
                    expItemObj.Monthly_Travel_Expenses__c = obj.id;
                    expItemObj.Amount__c = exp.Amount__c;
                    expItemObj.Remarks__c = exp.Remarks__c;
                    lstForinsert.add(expItemObj);
                }
            }else{
                
                List<Expense_Item__c> lstofMonth = new List<Expense_Item__c>();
                lstofMonth = mapfortravel.get(key);
                for(Expense_Item__c exp : lstofMonth){
                    
                    Expense_Item__c expItemObj = new Expense_Item__c();
                    expItemObj.Item__c = exp.Item__c;
                    expItemObj.Date__c = exp.Date__c;
                    expItemObj.Purpose__c = exp.Purpose__c;
                    expItemObj.Month__c = exp.Month__c;
                    expItemObj.Location__c = exp.Location__c;
                    expItemObj.Monthly_Travel_Expenses__c = existRecord.id;
                    expItemObj.Amount__c = exp.Amount__c;
                    expItemObj.Remarks__c = exp.Remarks__c;
                    lstForinsert.add(expItemObj);
                    System.debug('lstForinsert :- '+lstForinsert);
                    System.Debug('existRecord.id ========== ' + existRecord.id);
                    
                    
                    
                    /*Monthly_Travel_Expense__c  mte = new Monthly_Travel_Expense__c();

mte.Id = existRecord.id;
mte.SubmittedforApproval__c = false;
System.debug('mte.SubmittedforApproval__c 1 :- '+mte.SubmittedforApproval__c);
System.debug('mte.Rejection_Status_del__c 1 :- '+mte.Rejection_Status_del__c);
update mte;*/
                    
                    
                    /*Expense_Item__c temp = exp;
String expenseId=temp.Id;
System.debug('expenseId'+expenseId);
Expense_Item__c  mte = [select id,Monthly_Travel_Expenses__c from Expense_Item__c where Monthly_Travel_Expenses__c =:existRecord.id];
String s=  mte.Monthly_Travel_Expenses__c;
Monthly_Travel_Expense__c monthTrevelExpence =[select id,SubmittedforApproval__c,Rejection_Status_del__c from Monthly_Travel_Expense__c where id=:s];
//  system.debug('monthTrevelExpence'+monthTrevelExpence);
monthTrevelExpence.SubmittedforApproval__c = false;
//  system.debug('monthTrevelExpence.SubmittedforApproval__c : '+monthTrevelExpence.SubmittedforApproval__c);
update monthTrevelExpence;*/
                    
                    
                    //upsert mte;
                    
                    
                }
                
            }
        }
        
        if(lstForinsert.size()>0){
            insert lstForinsert;
        } 
        //}
        /*catch(Exception ex){
System.debug('ErorLine-->'+ex.getLineNumber());
System.debug('ErorMessage-->'+ex);

}       */
        return eiObj;
        
    } 
    @AuraEnabled
    public static Expense_Item__c updateTravelExpense(Expense_Item__c update_eiObj){
        upsert update_eiObj;
        Expense_Item__c temp = update_eiObj;
        string expenseId=temp.Id;
        Expense_Item__c  mte = [select id,Monthly_Travel_Expenses__c from Expense_Item__c where id=:expenseId];
        string s=  mte.Monthly_Travel_Expenses__c;
        Monthly_Travel_Expense__c monthTrevelExpence =[select id,SubmittedforApproval__c,Rejection_Status_del__c from Monthly_Travel_Expense__c where id=:s];
        monthTrevelExpence.SubmittedforApproval__c = false;
        update monthTrevelExpence;
        return update_eiObj;
    }
    
    @AuraEnabled
    public static list<Monthly_Travel_Expense__c> addMonth(list<Monthly_Travel_Expense__c> mteObj){
        
        insert mteObj;
        return mteObj;
        
    }     
}