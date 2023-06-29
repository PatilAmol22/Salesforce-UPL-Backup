public  class SpainProtugalCampaign {
    
    public SpainProtugalCampaign(){
        
    }
    @AuraEnabled
    public static string  getloginuserName(){
    string userName = UserInfo.getName();
    system.debug('userName>>--->'+userName);
    return userName;    
    }
    
    @AuraEnabled
    public static Invoice_Line_Item__c  getInvoiceQtyAndAomunt(string custId, string sKUId){
        List<Invoice_Line_Item__c> invcLnItmList = new List<Invoice_Line_Item__c>();
        invcLnItmList = [SELECT Id, Name, Invoice__c, Net_Value__c, Quantity__c, SKU__c, Invoice__r.Id, Invoice__r.Name, Invoice__r.Billing_Status__c,Invoice__r.Billing_Date__c, 
                             Invoice__r.Sold_To_Party__c FROM Invoice_Line_Item__c where SKU__c =:sKUId AND  Invoice__r.Billing_Status__c='M' AND Invoice__r.Sold_To_Party__c =:custId AND Net_Value__c !=0  AND Invoice__r.Billing_Date__c<=:system.today() order by Invoice__r.Billing_Date__c  DESC LIMIT 1];
      
        if(!invcLnItmList.isEmpty()){
            return invcLnItmList[0];
        }else{
        	return null;
        }
    }
    
    @AuraEnabled
    public static string updateCFIRecord(string cFIRecord){
        string retValue = '';
        try{        
            if(cFIRecord!= Null){     
   			forecastInformation forecastInfoRec = new forecastInformation();
             forecastInfoRec = (forecastInformation) JSON.deserialize(cFIRecord, forecastInformation.class);    
        	system.debug('forecastInfoRec>>--->'+forecastInfoRec);
            if(forecastInfoRec != NULL){
               Customer_Forecast_Information__c cfiObj = new Customer_Forecast_Information__c();
            if(forecastInfoRec.Id != '' || forecastInfoRec.Id != NULL){
            cfiObj.id = forecastInfoRec.Id;
            }
            cfiObj.Actual_Quantity__c = forecastInfoRec.ActualQty;
            cfiObj.Actual_Amount__c = forecastInfoRec.ActualAmount;

                if(cfiObj!=Null){
                 update cfiObj;
                 retValue = 'SUCCESS';
                }    
              }
           }
        }catch(DmlException e){
            retValue = 'ERROR';
           }
        return retValue;
        }
    
	@AuraEnabled
    public static RecordDataWithRelatedList  fetchAllRecordData(string recordId) { 
    system.debug('recordId >>--->'+recordId);
    string profileId = UserInfo.getProfileId();
    string profileName = [select Name from Profile where id =:profileId].Name;    
    system.debug('profileName>>--->'+profileName);
    Spain_Portugal_Campaign__c sPCampaignObj = new Spain_Portugal_Campaign__c();
    list<Customer_Forecast_Information__c> custForecastInfoList = new list<Customer_Forecast_Information__c>();
    list<Campaign_Crop_Details__c> cropDetailslist = new list<Campaign_Crop_Details__c>();
    list<Campaign_Demo_Protocol__c> demoProtocollist = new list<Campaign_Demo_Protocol__c>();
    list<Expense_Activity__c> expenseActivitylist = new list<Expense_Activity__c>();
    RecordDataWithRelatedList recordDataObj = new RecordDataWithRelatedList();        
    recordDataObj.userProfile = profileName;
    sPCampaignObj = [SELECT Id,Name,Owner.Name,Start_Date__c,End_Date__c,CurrencyIsoCode,Status__c FROM Spain_Portugal_Campaign__c
                     WHERE Id=:recordId];  
    recordDataObj.sPCampaign =  sPCampaignObj;  
    custForecastInfoList = [SELECT Id,Name,Actual_Amount__c,Actual_Quantity__c,Entry_Type__c,Customer__c,Customer__r.Name,Forecast_Amount__c, SKU__c,
                            SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Spain_Portugal_Campaign__c FROM Customer_Forecast_Information__c
                            WHERE Spain_Portugal_Campaign__c =:recordId];
        
    cropDetailslist = [SELECT Id,Name,Spain_Portugal_Campaign__c,Crop__c,Crop__r.Name FROM Campaign_Crop_Details__c
                       WHERE Spain_Portugal_Campaign__c =:recordId];
        
    demoProtocollist =[SELECT Id,Name,Cost__c,End_Date__c,Objectives__c,Spain_Portugal_Campaign__c,Start_Date__c,Status__c
                       FROM Campaign_Demo_Protocol__c WHERE Spain_Portugal_Campaign__c =:recordId]; 
        
    expenseActivitylist = [SELECT Id,Name,Activity__c,Actual_Cost__c,Customer__c,Customer__r.Name,Budgeted_Cost__c,SKU__c,SKU__r.SKU_Description__c,
                           SKU__r.SKU_Code__c,Spain_Portugal_Campaign__c FROM Expense_Activity__c 
                           WHERE Spain_Portugal_Campaign__c =:recordId];
        
        if(!custForecastInfoList.isEmpty()){
            For(Customer_Forecast_Information__c cfi : custForecastInfoList){
                forecastInformation finfo = new forecastInformation();
                finfo.id = cfi.Id;
                finfo.customerId = cfi.Customer__c;
                finfo.customerName = cfi.Customer__r.Name;
                finfo.sKUID = cfi.SKU__c;
                finfo.sKUDescription = cfi.SKU__r.SKU_Description__c;
                finfo.sKUCode = cfi.SKU__r.SKU_Code__c;
                finfo.forecastAmount = cfi.Forecast_Amount__c;
                finfo.ActualAmount = cfi.Actual_Amount__c;
                finfo.ActualQty = cfi.Actual_Quantity__c;
                finfo.entryType = cfi.Entry_Type__c;
                recordDataObj.ForecastInfoList.add(finfo);
            }
            
        }
        if(!cropDetailslist.isEmpty()){
            For(Campaign_Crop_Details__c cd : cropDetailslist){
                CropDetails  cdobj = new CropDetails();
    			cdobj.id = cd.Id;
                cdobj.cropid =cd.Crop__c ;
                cdobj.cropName =cd.Crop__r.Name;
                recordDataObj.cropDetailList.add(cdobj);
            }
            
        }
        if(!demoProtocollist.isEmpty()){
            For(Campaign_Demo_Protocol__c dp : demoProtocollist){
                DemoProtocol dpobj = new DemoProtocol();
                dpobj.id = dp.Id;
                dpobj.objectives = dp.Objectives__c;
                dpobj.startDate = dp.Start_Date__c;
                dpobj.endDate = dp.End_Date__c;
                dpobj.cost = dp.Cost__c;
                dpobj.status = dp.Status__c;
                 recordDataObj.demoProtocolList.add(dpobj);
                
            }
            
        }
         if(!expenseActivitylist.isEmpty()){
             For(Expense_Activity__c ea : expenseActivitylist){
                ExpenseActivity eaObj = new ExpenseActivity();
                eaObj.id = ea.Id;
                eaObj.customerId = ea.Customer__c;
                eaObj.customerName = ea.Customer__r.Name;
                eaObj.expenseActivity = ea.Activity__c;
                eaObj.sKUID = ea.SKU__c;
                eaObj.sKUDescription = ea.SKU__r.SKU_Description__c;
                eaObj.sKUCode = ea.SKU__r.SKU_Code__c;
                eaObj.budgetedCost = ea.Budgeted_Cost__c;
                eaObj.actualCost = ea.Actual_Cost__c;
             recordDataObj.activityList.add(eaObj);
            }  
        }
     system.debug('recordDataObj>>--->'+ recordDataObj);
     return recordDataObj;
    }   
 @AuraEnabled
 public static List<String> getselectOptions(string objObject, string fld) {
    system.debug('sobject>>--->'+objObject);
    system.debug('Field>>--->'+fld);
 	list<String> opslist = new list<String>();
    Schema.SObjectType sobjType = Schema.getGlobalDescribe().get(objObject);
    
    //Description Of Sobject 
    Schema.DescribeSobjectResult sobjDescribe = sobjType.getDescribe();
    //Map of fields
    map<string,schema.SobjectField> fieldMap = sobjDescribe.fields.getmap();
    list<schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPicklistValues();
    // picklist values of fields
     if(fld =='CurrencyIsoCode'){
        for(Schema.PicklistEntry pickval : values){
            if(pickval.getvalue() == 'EUR' || pickval.getvalue() == 'USD'){
            	opslist.add(pickval.getvalue());
            }    
     	} 
     }else{
     	for(Schema.PicklistEntry pickval : values){
     		opslist.add(pickval.getvalue());   
     	}
     }
     system.debug('opslist'+opslist);
     return opslist;
 }
    @AuraEnabled
    public Static String saveSpainCampaign(Spain_Portugal_Campaign__c spainCampaignObj,string forecastInfoObj,string cropDetailObj,String demoProtocolObj,string expenseActObj,string forecastInfoDelObj,string cropDetailDelObj,String demoProtocolDelObj,string expenseActDelObj){
    list<Spain_Portugal_Campaign__c> campList = new list<Spain_Portugal_Campaign__c>();
    list<Customer_Forecast_Information__c> custForecastInfolist = new list<Customer_Forecast_Information__c>();
    list<Campaign_Crop_Details__c> cropDetailslist = new list<Campaign_Crop_Details__c>();
    list<Campaign_Demo_Protocol__c> demoProtocollist = new list<Campaign_Demo_Protocol__c>();
    list<Expense_Activity__c> expenseActivitylist = new list<Expense_Activity__c>();
        
    list<Customer_Forecast_Information__c> custForecastInfoDellist = new list<Customer_Forecast_Information__c>();
    list<Campaign_Crop_Details__c> cropDetailsDellist = new list<Campaign_Crop_Details__c>();
    list<Campaign_Demo_Protocol__c> demoProtocolDellist = new list<Campaign_Demo_Protocol__c>();
    list<Expense_Activity__c> expenseActivityDellist = new list<Expense_Activity__c>();
        
    if(spainCampaignObj != NULL){
        upsert spainCampaignObj;
        campList=[SELECT Id,Name,Owner.Name,Start_Date__c,End_Date__c,CreatedDate,CurrencyIsoCode,Status__c FROM Spain_Portugal_Campaign__c
                     WHERE Id=:spainCampaignObj.id];
    }
        
   if(forecastInfoObj!= Null){     
   List<forecastInformation> forecastInfolist = (List<forecastInformation>)JSON.deserialize(forecastInfoObj, List<forecastInformation>.class) ;     
   if(forecastInfolist.size()>0){
       system.debug('forecast Size >>--->'+forecastInfolist.size());
        for(forecastInformation fiobj :forecastInfolist){
			Customer_Forecast_Information__c cfiObj = new Customer_Forecast_Information__c();
            if(fiobj.Id != '' || fiobj.Id != NULL){
            cfiObj.id = fiobj.Id;
            }
            cfiObj.Customer__c = fiobj.customerId;
            cfiObj.Spain_Portugal_Campaign__c = spainCampaignObj.id;
            cfiObj.Forecast_Amount__c = fiobj.forecastAmount;
            cfiObj.SKU__c = fiobj.sKUID;
            cfiObj.Actual_Quantity__c = fiobj.ActualQty;
            cfiObj.Actual_Amount__c = fiobj.ActualAmount;
            cfiObj.Entry_Type__c = fiobj.entryType;
            cfiObj.CurrencyIsoCode = spainCampaignObj.CurrencyIsoCode;
            custForecastInfolist.add(cfiObj);
        }
    }
   }
        if(forecastInfoDelObj!= Null){     
   List<forecastInformation> forecastInfoDellist = (List<forecastInformation>)JSON.deserialize(forecastInfoDelObj, List<forecastInformation>.class) ;     
   if(forecastInfoDellist.size()>0){
       system.debug('forecast Size >>--->'+forecastInfoDellist.size());
        for(forecastInformation fiobj :forecastInfoDellist){
			Customer_Forecast_Information__c cfiObj = new Customer_Forecast_Information__c();
            if(fiobj.Id != '' || fiobj.Id != NULL){
            cfiObj.id = fiobj.Id;
            }
            cfiObj.Customer__c = fiobj.customerId;
            cfiObj.Spain_Portugal_Campaign__c = spainCampaignObj.id;
            cfiObj.Forecast_Amount__c = fiobj.forecastAmount;
            cfiObj.SKU__c = fiobj.sKUID;
            cfiObj.Actual_Quantity__c = fiobj.ActualQty;
            cfiObj.Actual_Amount__c = fiobj.ActualAmount;
            cfiObj.CurrencyIsoCode = spainCampaignObj.CurrencyIsoCode;
            custForecastInfoDellist.add(cfiObj);
        }
    }
   }
        
        if(cropDetailObj!= Null){
           List<CropDetails> croplist = (List<CropDetails>)JSON.deserialize(cropDetailObj, List<CropDetails>.class) ;     
         if(croplist.size()>0){
         for(CropDetails cdobj :croplist){
			Campaign_Crop_Details__c ccd = new Campaign_Crop_Details__c();
            if(cdobj.Id != '' || cdobj.Id != NULL){
            ccd.id = cdobj.Id;
            }
            ccd.Crop__c =  cdobj.cropid;
            ccd.Spain_Portugal_Campaign__c = spainCampaignObj.id;
            ccd.CurrencyIsoCode = spainCampaignObj.CurrencyIsoCode;
            cropDetailslist.add(ccd); 
        }
        }
    } 
        if(cropDetailDelObj!= Null){
           List<CropDetails> cropDellist = (List<CropDetails>)JSON.deserialize(cropDetailDelObj, List<CropDetails>.class) ;     
         if(cropDellist.size()>0){
         for(CropDetails cdobj :cropDellist){
			Campaign_Crop_Details__c ccd = new Campaign_Crop_Details__c();
            if(cdobj.Id != '' || cdobj.Id != NULL){
            ccd.id = cdobj.Id;
            }
            ccd.Crop__c =  cdobj.cropid;
            ccd.Spain_Portugal_Campaign__c = spainCampaignObj.id;
            ccd.CurrencyIsoCode = spainCampaignObj.CurrencyIsoCode;
            cropDetailsDellist.add(ccd); 
        }
        }
    }
        
        if(demoProtocolObj!= Null){
        List<DemoProtocol> demolist = (List<DemoProtocol>)JSON.deserialize(demoProtocolObj, List<DemoProtocol>.class) ; 
        if(demolist.size()>0){
        for(DemoProtocol dpobj :demolist){
           Campaign_Demo_Protocol__c cdp = new Campaign_Demo_Protocol__c();
            if(dpobj.Id != '' || dpobj.Id != NULL){
            cdp.id = dpobj.Id;
            }
            cdp.Spain_Portugal_Campaign__c = spainCampaignObj.id;
            cdp.Objectives__c = dpobj.objectives;
            cdp.Start_Date__c = dpobj.startDate;
            cdp.End_Date__c = dpobj.endDate;
            cdp.Cost__c = dpobj.cost;
            cdp.Status__c = dpobj.status;
            cdp.CurrencyIsoCode = spainCampaignObj.CurrencyIsoCode;
            demoProtocollist.add(cdp);
        }
        }
    }
        if(demoProtocolDelObj!= Null){
        List<DemoProtocol> demoDellist = (List<DemoProtocol>)JSON.deserialize(demoProtocolDelObj, List<DemoProtocol>.class) ; 
        if(demoDellist.size()>0){
        for(DemoProtocol dpobj :demoDellist){
           Campaign_Demo_Protocol__c cdp = new Campaign_Demo_Protocol__c();
            if(dpobj.Id != '' || dpobj.Id != NULL){
            cdp.id = dpobj.Id;
            }
            cdp.Spain_Portugal_Campaign__c = spainCampaignObj.id;
            cdp.Objectives__c = dpobj.objectives;
            cdp.Start_Date__c = dpobj.startDate;
            cdp.End_Date__c = dpobj.endDate;
            cdp.Cost__c = dpobj.cost;
            cdp.Status__c = dpobj.status;
            cdp.CurrencyIsoCode = spainCampaignObj.CurrencyIsoCode;
            demoProtocolDellist.add(cdp);
        }
        }
    }
        
        if(expenseActObj != NULL){
         List<ExpenseActivity> expenseActlist = (List<ExpenseActivity>)JSON.deserialize(expenseActObj, List<ExpenseActivity>.class) ; 
        if(!expenseActlist.isEmpty()){
           
            for(ExpenseActivity ea : expenseActlist){
              Expense_Activity__c eaObj = new  Expense_Activity__c();
                if(ea.id != '' || ea.id != NULL){
                	eaObj.id = ea.id;  
                }
               eaObj.Spain_Portugal_Campaign__c = spainCampaignObj.id;
               eaObj.Customer__c = ea.customerId;
               eaObj.Activity__c =  ea.expenseActivity;
               eaObj.SKU__c = ea.sKUID;
               eaObj.Budgeted_Cost__c = ea.budgetedCost;
               eaObj.Actual_Cost__c = ea.actualCost;
               eaObj.CurrencyIsoCode = spainCampaignObj.CurrencyIsoCode;
               expenseActivitylist.add(eaObj);    
            }
            
        }
        }
        
        if(expenseActDelObj != NULL){
         List<ExpenseActivity> expenseActDellist = (List<ExpenseActivity>)JSON.deserialize(expenseActDelObj, List<ExpenseActivity>.class) ; 
        if(!expenseActDellist.isEmpty()){
           
            for(ExpenseActivity ea : expenseActDellist){
              Expense_Activity__c eaObj = new  Expense_Activity__c();
                if(ea.id != '' || ea.id != NULL){
                	eaObj.id = ea.id;  
                }
               eaObj.Spain_Portugal_Campaign__c = spainCampaignObj.id;
               eaObj.Customer__c = ea.customerId;
               eaObj.Activity__c =  ea.expenseActivity;
               eaObj.SKU__c = ea.sKUID;
               eaObj.Budgeted_Cost__c = ea.budgetedCost;
               eaObj.Actual_Cost__c = ea.actualCost;
               eaObj.CurrencyIsoCode = spainCampaignObj.CurrencyIsoCode;
               expenseActivityDellist.add(eaObj);    
            }      
        }
        }
       
        
        if(!custForecastInfolist.isEmpty()){
           upsert custForecastInfolist; 
        }
        if(!cropDetailslist.isEmpty()){
           upsert cropDetailslist; 
        }
		if(!demoProtocollist.isEmpty()){
           upsert demoProtocollist; 
        }
		if(!expenseActivitylist.isEmpty()){
           upsert expenseActivitylist; 
        }
        spainCampaignObj.Sent_Mail__c = true;
        update spainCampaignObj;
        
         if(!campList.isEmpty()){
        CustomerForecastMap CFMObj = new CustomerForecastMap();
        system.debug('spainCampaignObj >>--->'+campList);
        CFMObj.processData(campList,false);
        }
        
        if(!custForecastInfoDellist.isEmpty()){
           delete custForecastInfoDellist; 
        }
        if(!cropDetailsDellist.isEmpty()){
           delete cropDetailsDellist; 
        }
		if(!demoProtocolDellist.isEmpty()){
           delete demoProtocolDellist; 
        }
		if(!expenseActivityDellist.isEmpty()){
           delete expenseActivityDellist; 
        }
     system.debug('spainCampaignObj >>--->'+spainCampaignObj);
     system.debug('forecastInfoObj >>--->'+forecastInfoObj);
     system.debug('cropDetailObj >>--->'+cropDetailObj);
     system.debug('spainCampaignObj >>--->'+demoProtocolObj);
     system.debug('spainCampaignObj >>--->'+expenseActObj);
     
        return spainCampaignObj.id;   
    }
    
    public Class RecordDataWithRelatedList{
        @AuraEnabled public Spain_Portugal_Campaign__c sPCampaign{get;set;}
        @AuraEnabled public list<forecastInformation> ForecastInfoList{get;set;}
        @AuraEnabled public list<CropDetails> cropDetailList{get;set;}
        @AuraEnabled public list<DemoProtocol> demoProtocolList{get;set;}
        @AuraEnabled public list<ExpenseActivity> activityList{get;set;}
        @AuraEnabled public string userProfile{get;set;} 
        public RecordDataWithRelatedList(){
            userProfile = '';
            sPCampaign = new Spain_Portugal_Campaign__c();
            ForecastInfoList = new list<forecastInformation>();
            cropDetailList = new list<CropDetails>();
            demoProtocolList = new list<DemoProtocol>(); 
             activityList = new list<ExpenseActivity>();
            
        }
        
    }
    
    
    public class forecastInformation {
    	@AuraEnabled public String id{get;set;}
        @AuraEnabled public String customerId{get;set;}
        @AuraEnabled public String customerName{get;set;}
        @AuraEnabled public String sKUID{get;set;}
        @AuraEnabled public String sKUDescription{get;set;}
        @AuraEnabled public String sKUCode{get;set;}
        @AuraEnabled public Decimal forecastAmount{get;set;}
        @AuraEnabled public Decimal ActualAmount{get;set;}
        @AuraEnabled public Decimal ActualQty{get;set;}
         @AuraEnabled public string entryType{get;set;}
        public forecastInformation(){
            id = '';
            customerId = '';
            sKUCode ='';
            customerName = '';
            sKUID = '';
            entryType = '';
            sKUDescription = '';
            forecastAmount = 0.0;
            ActualAmount = 0.0;
            ActualQty = 0;
        }
    }
      public class CropDetails {
    	@AuraEnabled public String id{get;set;}
        @AuraEnabled public String cropid{get;set;}
        @AuraEnabled public String cropName{get;set;}
        
        public CropDetails(){
            id = '';
           cropid = '';
            cropName ='';
           
        }
    }
    public class DemoProtocol {
    	@AuraEnabled public String id{get;set;}
        @AuraEnabled public String objectives{get;set;}
         @AuraEnabled public Date startDate{get;set;}
         @AuraEnabled public Date endDate{get;set;}
         @AuraEnabled public Decimal cost{get;set;}
        @AuraEnabled public String status{get;set;}
        
        public DemoProtocol(){
           id = '';
           objectives = '';
           status ='';
           startDate = system.today();
           endDate = system.today();
           cost = 0.0;
            
        }
    }
     public class ExpenseActivity {
    	@AuraEnabled public String id{get;set;}
        @AuraEnabled public String customerId{get;set;}
        @AuraEnabled public String customerName{get;set;}
        @AuraEnabled public String expenseActivity{get;set;}
        @AuraEnabled public String sKUID{get;set;}
        @AuraEnabled public String sKUDescription{get;set;}
        @AuraEnabled public String sKUCode{get;set;}
        @AuraEnabled public Decimal budgetedCost{get;set;}
        @AuraEnabled public Decimal actualCost{get;set;}
        
        public ExpenseActivity(){
           id = '';
           customerId ='';
           customerName = '';
           expenseActivity = '';
           sKUID = '';
           sKUDescription = '';
           sKUCode = '';
           budgetedCost = 0.0;
            actualCost =0.0;
        }
    }   
     
}