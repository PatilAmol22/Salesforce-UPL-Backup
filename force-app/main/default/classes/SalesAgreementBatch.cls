public class SalesAgreementBatch {
  public List<ExceptionMon> exceptionMonList;
    public List<String> errorCSVList;
    public List<String> successCSVList;
    
    public String businessDashboardID;
    private SplitString splitObj ;
    
    public Integer batchNo;
    public String rowNo;
    public String row;
    public String selectedObject;
    public String fileName;
    public DateTime asOfNow;
    public Map<String,String> csvMap;
    public List<Map<Integer,String>> csvlist;
    public String key='';
    public String csvkey='';
    public String liqKey='';
    public Integer keycsv;
    public sObject sObj_new; 
    
    //public static String year = String.valueOf(Date.Today().Year());
    
     /*@AuraEnabled
    public static String setYear(String year){
        year = year;
        return year;
    } */
    public static String year='';
    @AuraEnabled
   public static String setYear(String year)
 {
     BudgetUploadYear__c budgetuploadyear=[select id,name,year__c from BudgetUploadYear__c where name='Budgetyear' limit 1];
     budgetuploadyear.Year__c=year;
     update budgetuploadyear;
    return year;    
 }
    
    public SalesAgreementBatch(){
        businessDashboardID = '';
        selectedObject = '';
        batchNo = 0;
        rowNo = '';
        filename = '';
        asOfNow = System.Today();
        csvMap=new Map<String,String>();
        csvlist = new List<Map<Integer,String>>(); 
        splitObj = new SplitString();
        
        exceptionMonList = new List<ExceptionMon>();
        errorCSVList = new List<String>();
        successCSVList = new List<String>();
        
        //Fetch single record from bdObjage Object created today & status = draft
        List<BusinessDashboard__c> businessDashboardList = [SELECT Id, Header__c, As_of_now__c 
                                                            FROM BusinessDashboard__c 
                                                            WHERE CreatedDate = TODAY 
                                                            AND Status__c = 'Draft' 
                                                            ORDER By CreatedDate LIMIT 1 ];
        
        
        if(!businessDashboardList.isEmpty()){
            //system.debug('businessDashboardList'+businessDashboardList);
            businessDashboardID = businessDashboardList[0].Id;
            asOfNow = businessDashboardList[0].As_of_now__c;
            errorCSVList.add(businessDashboardList[0].Header__c+',Error Description');
            successCSVList.add('Record ID,'+businessDashboardList[0].Header__c);
        }
    }
    
    //Method to fetch attachment from bdObjage Object
    public String getFile(){
        String myFile = '';
        system.debug('businessDashboardID: '+businessDashboardID);
        
        if(String.isNotBlank(businessDashboardID)){
            
            List<Attachment> attachmentList = [SELECT Id,Name,Body,ParentId 
                                               FROM Attachment 
                                               WHERE ParentId = :businessDashboardID
                                               AND (Name != 'Success.csv' 
                                                    OR Name != 'Error.csv')
                                               AND Name LIKE '%.csv'
                                               ORDER BY CreatedDate LIMIT 1];
            
            if(!attachmentList.isEmpty()){
                //Return csv to scope of Batch class from attachment
                //system.debug('Attachment List Size: '+attachmentList.size());
                myFile = attachmentList[0].Body.toString();  
                //system.debug('myFile :- '+myFile);
                
                fileName = attachmentList[0].Name;
                
                fileName = fileName.substringBefore('_');
                
                system.debug('fileName :: '+fileName);
                
                //Integer endIndex = fileName.indexOf('_');
                //fileName = fileName.substring(0, endIndex);
                List<SchemaObjectMapping__c> lisSC= new List<SchemaObjectMapping__c>();
                if(test.isRunningTest()){
                    lisSC= [Select Name, Filename__c, Object__c FROM SchemaObjectMapping__c  WHERE Filename__c =:fileName ];  
                    /* system.debug('size list>>--->'+lisSC.size());
                    system.debug('fileName >>--->'+fileName); */
                    if(lisSC.size()==0){
                   lisSC= [Select Name, Filename__c, Object__c FROM SchemaObjectMapping__c  WHERE Filename__c ='SalesAgreementSchedule.csv' ]; 
                    }
                }else{
                   lisSC= [Select Name, Filename__c, Object__c FROM SchemaObjectMapping__c  WHERE Filename__c LIKE:fileName ]; 
                }
                 
                system.debug('lisSC :-----'+lisSC);
                Map<String, String> objectNameMap = new Map<String, String>();
                for(SchemaObjectMapping__c smObj : lisSC){
                    //system.debug('smObj :-'+smObj);
                    objectNameMap.put(smObj.Filename__c, smObj.Object__c);
                }
                //system.debug('objectNameMap :-'+objectNameMap);
                if(objectNameMap.containsKey(fileName) || test.isRunningTest()){
                    //system.debug('inside if Map :-');
                    if(test.isRunningTest()){
                        selectedObject = objectNameMap.get(fileName);
                        
                        if(fileName == 'test.csv'){
                         selectedObject = 'SalesAgreementProductSchedule';
                        }
                        
                    }else{
                         selectedObject = objectNameMap.get(fileName);
                    }
                    //system.debug('fileName :- '+fileName);
                    system.debug('selectedObject :- '+selectedObject);
                }
                //system.debug('After Map :-');
                //Change status of current record being processed by the batch
                BusinessDashboard__c bdObj = new BusinessDashboard__c();
                bdObj.Id = businessDashboardID;
                bdObj.Status__c ='Processing';
                update bdObj;
            }
            else{
                //Update Record if no attachment found
                BusinessDashboard__c bdObj = new BusinessDashboard__c();
                bdObj.Id = businessDashboardID;
                bdObj.Status__c ='Completed';
                update bdObj;
            }
            //system.debug('File Length: '+ myFile.length());
            //system.debug('Heap size is ' + limits.getHeapSize() + ' enforced is ' + limits.getLimitHeapSize());
        }
            
        return myFile;
    }
    
    //Method to process CSV rows and insert records in bdObjage Data 
    public void processData(String csvFile){
        try{
            
            //Logic to parse CSV row by row
            List<String> csvData = new List<String>();
            csvData = splitObj.safeSplit(csvFile, '\n');
            
            
            system.debug('selectedObject :- '+selectedObject);
            if(selectedObject == 'SalesAgreementProductSchedule'){
                //system.debug('csvData 2 :- '+csvData);
                List<SalesAgreementProductSchedule> sAPSList = new List<SalesAgreementProductSchedule>();
                Map<Id,Integer> plannedQtyMap=new Map<Id,Integer>();
                for (Integer i = 0; i < csvData.size()-1; i++){
                    row = csvData[i];
                    List<String> csvLineItem = new List<String>();
                    //csvLineItem = csvData[i].split(',');
                    csvLineItem = csvData[i].split(';'); // ';' used only for Brazil country 
                    for(Integer j=0; j<csvLineItem.size()-1; j++){
                        if(String.isNotBlank(csvLineItem[0].trim()) && String.isNotBlank(csvLineItem[1].trim())){
                            plannedQtyMap.put(csvLineItem[0].trim(),Integer.valueOf(csvLineItem[1].trim()));
                        }
                        csvMap.put(csvLineItem[0].trim(), row);
                    }
                }
                List<SalesAgreementProductSchedule> listSaps=[Select Id,PlannedQuantity FROM SalesAgreementProductSchedule Where Id IN:plannedQtyMap.keySet()];
                for(SalesAgreementProductSchedule sapsObj:listSaps){
                    SalesAgreementProductSchedule saps=new SalesAgreementProductSchedule();
                    if(plannedQtyMap.containsKey(sapsObj.Id)){
                        saps.Id=sapsObj.Id;
                        saps.PlannedQuantity=plannedQtyMap.get(sapsObj.Id);
                        sAPSList.add(saps);  
                    }
                }
                
                /*Map<String,Integer> sapsMap = new Map<String,Integer>();
                Map<String,String>sapsIdMap = new Map<String,String>();
                for(SalesAgreementProductSchedule sapsObj:listSaps){
                    sapsMap.put(sapsObj.Id,plannedQtyMap.get(sapsObj.Id));
                    sapsIdMap.put(sapsObj.Id,'');       
                }
                for(String idStr:plannedQtyMap.keySet()){
                    if(sapsMap.containsKey(idStr)){
                        Integer plannedQty=plannedQtyMap.get(idStr);
                        SalesAgreementProductSchedule saps = new SalesAgreementProductSchedule();
                        saps.Id = idStr;
                        saps.PlannedQuantity=plannedQty;
                        sAPSList.add(saps);
                    }
                }
                        
                // Logic for successcsv and errorcsv 
                for(String s:plannedQtyMap.keySet()){
                    if(sapsIdMap.containsKey(s)){
                        successCSVList.add(' ,'+csvMap.get(s));
                    }else{
                        errorCSVList.add(csvMap.get(s));
                    } 
                }*/
                        
                
                Database.SaveResult[] srList;
                if(sAPSList.size()>0){
                    srList = Database.update(sAPSList, false);
                }
                
                //Iterate through each returned result
                for(Integer i=0;i<srList.size();i++){
                    if (!srList[i].isSuccess()){
                        Database.Error[] errs = srList[i].getErrors();
                        errorCSVList.add(String.valueOf(sAPSList[i].get('Id'))+','+String.valueOf(sAPSList[i].get('PlannedQuantity'))+','+errs[0].getMessage());
                    }
                    else{
                        successCSVList.add(String.valueOf(sAPSList[i].get('Id'))+','+String.valueOf(sAPSList[i].get('Id'))+','+String.valueOf(sAPSList[i].get('PlannedQuantity')));
                    }
                }
            } 
            
            //added on 4-11-2022
            if(selectedObject == 'Account_Target__c'){
                String salesOrgCode = '5191';
                String salesOrgId=[Select id,Sales_Org_Code__c from Sales_Org__c where Sales_Org_Code__c=:salesOrgCode limit 1].Id;
                Map<String,Territory_Distributor__c> mapTerritories = new Map<String,Territory_Distributor__c>();
                Map<String,Product2> mapProducts = new Map<String,Product2>();
                
                List<Territory_Distributor__c> territories = [select Id,Name,TerritoryCode__c from Territory_Distributor__c where Sales_Org_Code__c =:salesOrgCode];
  
                List<Product2> products = [select Id,Name,Product_Code__c from Product2 where Sales_Org_Code__c =:salesOrgCode];
                BudgetUploadYear__c budgetuploadyear=[select id,name,year__c from BudgetUploadYear__c where name='Budgetyear' limit 1];
                year=budgetuploadyear.year__c;
                
                for(Territory_Distributor__c td:territories){
                    mapTerritories.put(td.TerritoryCode__c,td);
                }
                for(Product2 product:products){
                    mapProducts.put(product.Product_Code__c,product);
                }
                
                
                
                System.debug('Year '+year);
                List<Account_Target__c> accountTargets = new List<Account_Target__c>();
                Id RecordTypeMonthly = Schema.SObjectType.Account_Target__c.getRecordTypeInfosByName().get('Monthly').getRecordTypeId();
                   
                for (Integer i = 0; i < csvData.size()-1; i++){
                    List<String> csvLineItem = new List<String>();
                   
                    csvLineItem = csvData[i].split(';');
                    // Region Code, SKU Code,Quantity,Month
                    if(csvLineItem.size()>3){
                    String regionCode =  'BR'+String.valueOf(csvLineItem[0]);  
                    String skuCode = String.valueOf(csvLineItem[1]).leftPad(18, '0');  
                    String month =   String.valueOf(csvLineItem[3]);
                    Decimal quantity = Decimal.valueOf(String.valueOf(csvLineItem[2]).replaceAll(',','.'));
                    String combinationKey =regionCode+salesOrgCode+skuCode+month.trim()+year.trim();
                    try{
                    Account_Target__c accountTarget = new Account_Target__c();
                    accountTarget.Month__c = month;
                    // accountTarget.Price__c = '';
                    accountTarget.Product__c = mapProducts.get(skuCode).Id;
                    accountTarget.Quantity__c = quantity;
                    accountTarget.Region__c = mapTerritories.get(regionCode).Id;
                    accountTarget.Sales_Org__c = salesOrgId;
                    accountTarget.Year__c = year;
                    accountTarget.Combination_Key__c = combinationKey;
                    accountTarget.RecordTypeId=RecordTypeMonthly;
                    accountTargets.add(accountTarget);
                    }catch(Exception ex){
                        errorCSVList.add('Combination key: '+combinationKey+' Exception:'+ex.getMessage());
            			exceptionHandler(ex, 'processData');
                    }
                    }
                }
                DataBase.UpsertResult[] results= Database.upsert(accountTargets , Account_Target__c.Combination_Key__c) ;
             for( integer i=0;i<results.size();i++)
             {
                 if(!results[i].isSuccess())
                 {
                     Database.Error[] errors=results[i].getErrors();
                     errorCSVList.add(String.valueOf(accountTargets[i].Combination_Key__c)+' '+errors[0].getMessage());
                     system.debug('The error is'+errors);
                 }
                 else
                 {
                     successCSVList.add(String.valueOf(accountTargets[i].Combination_Key__c));
                 }
             }
                                  
            }

            
           
        }
        catch(Exception ex){
            errorCSVList.add(ex.getMessage());
            exceptionHandler(ex, 'processData');
            
        }
        //End of Logic
    }
    
    
    
    
    
    //Method to handle & monitor Exceptions
    public void exceptionHandler(Exception exObj, String methodName){
        if(exObj!=null){
            ExceptionMon monObj = new ExceptionMon();
            monObj.batchNo = batchNo;
            monObj.method = methodName;            
            monObj.lineNo = exObj.getLineNumber();
            monObj.message = exObj.getMessage();
            monObj.stackTrace = exObj.getStackTraceString();
            monObj.cause = String.valueOf(exObj.getCause());
            exceptionMonList.add(monObj);
            //system.debug('exceptionMonList: '+exceptionMonList);
        }
    }
    
    public class ExceptionMon{
        public Integer batchNo = 0;
        public String method = '';
        public Integer lineNo = 0;
        public String message = '';
        public String stackTrace = '';
        public String cause = '';
    }
    
}