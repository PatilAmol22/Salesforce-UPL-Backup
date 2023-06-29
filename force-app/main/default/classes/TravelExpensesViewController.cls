public class TravelExpensesViewController {
    
   // Monthly_Travel_Expense__c mteObj;
   // UPL-2-I386: Modified by:Ankita Saxena Changes in Travel request  for Indonesia
    public string mte_id;
    public list<Monthly_Travel_Expense__c> mtePlan{get;set;}
    public list<Expense_Item__c> eiList {get;set;}
    public String total_sum= '';
    public decimal sum {get;set;}
    public Map<string, decimal> activityAmountMap{get;set;}
    public Map<string, String> activityLimitMap{get;set;}
    public set<String> keys{get;set;}
    
    
    public TravelExpensesViewController(ApexPages.StandardController st){
        sum = 0;
   // public TravelExpensesViewController(){
        //recordtypelist = new list<RecordType>();
      	eiList= new list<Expense_Item__c>();
     //   mteObj= new Monthly_Travel_Expense__c();
        mte_id = ApexPages.currentPage().getParameters().get('id');
        	system.debug('mte_id========'+mte_id);
     
        mtePlan = new list<Monthly_Travel_Expense__c>();
	//	mteObj = mtePlan[0];
       
        //CH_Approval_Status__c, NSM_Approval_Status__c, RM_Approval_Status__c,TM Code,Territory,Item,Regional Manager,National Sales Manager,Country Head
        
        eiList = [SELECT id, Name, CreatedBy.Name, CreatedBy.TM_Code__c, CreatedBy.Territory__c,Item__c, Date__c,Purpose__c,Month__c, Location__c, Amount__c, Remarks__c,Monthly_Travel_Expenses__r.status__c, Monthly_Travel_Expenses__r.RM_status__c,Monthly_Travel_Expenses__r.NSM_status__c,Monthly_Travel_Expenses__r.NMM_status__c,Monthly_Travel_Expenses__r.CH_status__c,Monthly_Travel_Expenses__r.RegionalManager__r.name,Monthly_Travel_Expenses__r.NationalSalesManager__r.name,Monthly_Travel_Expenses__r.CountryHead__r.name,Item_Limit__c FROM Expense_Item__c where Monthly_Travel_Expenses__c =: mte_id]; 
        System.debug('eiList == > '+eiList);
        for(Expense_Item__c eiObj  : eiList){
            sum =  sum + eiObj.Amount__c;
        } 
    }
    // UPL-2-I386: Modified by:Ankita Saxena Changes in Travel request  for Indonesia
    public void createCummulativeActivity()
    {
        activityAmountMap = new Map<String, decimal>();
        activityLimitMap = new Map<String, String>();
        for(Expense_Item__c ei : eiList)
        {
            if(activityAmountMap.containsKey(ei.Item__c)){
                decimal amtMap = ei.amount__c + activityAmountMap.get(ei.Item__c);
                system.debug('amtMap -->' +amtMap);
                activityAmountMap.put(ei.Item__c,amtMap);
                    
            }
            else{
                activityAmountMap.put(ei.Item__c,ei.Amount__c);
            }
            activityLimitMap.put(ei.Item__c,ei.Item_Limit__c);
            
        }
		keys = activityAmountMap.keySet();
    }

    
}