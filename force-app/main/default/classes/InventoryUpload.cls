public without sharing class InventoryUpload {
    //profile check
    @AuraEnabled public Boolean isSalesRep = false;
    @AuraEnabled public Boolean isCustomer= false;
    @AuraEnabled public Integer blockDate;
    @AuraEnabled 
    public List<string> inputvalues;
    
    public class SalesRepCSVTemplate{
        @AuraEnabled
        public String Year {get;set;}
        @AuraEnabled
        public Integer Month {get;set;}
        @AuraEnabled
        public String CustomerCode {get;set;}
        @AuraEnabled
        public String SKUCode {get;set;}
        @AuraEnabled
        public Decimal Volume {get;set;}
    }
    
    /*@AuraEnabled
public static String getDocument(){
List<document> DocumentList = new List<document>(); 
String Templatefile = '/servlet/servlet.FileDownload?file=';
String newTemplatefile;
DocumentList = [select Name from document where Name = 'Stock In Channel UPL Inventory Upload Template'];
if(DocumentList.size()>0){
newTemplatefile = Templatefile+DocumentList[0].Id;
//system.debug('checktemplate '+newTemplatefile);
}
return newTemplatefile;
}*/
    
    
    @AuraEnabled
    public static List<SalesRepCSVTemplate> getDataAsCSV(){
        
        List<SalesRepCSVTemplate> retList = new List<SalesRepCSVTemplate>();
        String newString;
        ApexPages.PageReference report;
        Blob content;
        List<document> DocumentList = new List<document>(); 
        String Templatefile = '/servlet/servlet.FileDownload?file=';
        String newTemplatefile;
        DocumentList = [select Name from document where Name = 'Stock In Channel UPL Inventory Upload Template'];
        if(DocumentList.size()>0){
            newTemplatefile = Templatefile+DocumentList[0].Id;
            report = new ApexPages.PageReference(newTemplatefile);
            if(!Test.isRunningTest()){
                content = report.getContent();
            } 
            if(Test.isRunningTest())
            {
                content = Blob.valueOf('Test');
            }
            String[] strList = content.toString().split(',');
            for( String temp:strList ){
                //system.debug('->'+temp);
            }
            
            Integer YearToSearch;
            Integer MonthToSearch;
            if( Integer.valueOf(Date.Today().Month()) == 1 ){
                YearToSearch = Integer.valueOf(Date.Today().Year()) - 1 ;
                MonthToSearch = 12;
            }else{
                YearToSearch = Integer.valueOf(Date.Today().Year());
                MonthToSearch = Integer.valueOf(Date.Today().Month()) - 1;
            }
            
            List<Stock_In_Channel_Detail__c> SIC = [SELECT Id,Stock_In_Channel__r.Id,Stock_In_Channel__r.Year__c,Stock_In_Channel__r.Channel__r.SAP_Code__c,
                                                    SKU__r.SKU_Code__c,January_Volume__c,February_Volume__c,
                                                    March_Volume__c,April_Volume__c,May_Volume__c,June_Volume__c,July_Volume__c,
                                                    August_Volume__c,September_Volume__c,October_Volume__c,November_Volume__c,December_Volume__c 
                                                    FROM Stock_In_Channel_Detail__c WHERE 
                                                    Stock_In_Channel__r.Year__c=:String.valueOf(YearToSearch) 
                                                    AND (Stock_In_Channel__r.CreatedById=:UserInfo.getUserId() OR CreatedById=:UserInfo.getUserId()) 
                                                    ORDER BY Stock_In_Channel__r.Channel__r.SAP_Code__c DESC,SKU__r.SKU_Code__c DESC];
            //Year,Month,CustomerCode,SKUCode,Volume
            if( SIC.size()>0 ){
                for( Stock_In_Channel_Detail__c var:SIC ){
                    //system.debug('SIC id->'+var.Stock_In_Channel__r.Id);
                    //system.debug('SIC Detail id->'+var.Id);
                    SalesRepCSVTemplate ret = new SalesRepCSVTemplate();
                    Map<Integer,Decimal> MapOfMonthAndSCDMonthField = new Map<Integer,Decimal>();
                    MapOfMonthAndSCDMonthField.put(1,var.January_Volume__c);
                    MapOfMonthAndSCDMonthField.put(2,var.February_Volume__c);
                    MapOfMonthAndSCDMonthField.put(3,var.March_Volume__c);
                    MapOfMonthAndSCDMonthField.put(4,var.April_Volume__c);
                    MapOfMonthAndSCDMonthField.put(5,var.May_Volume__c);
                    MapOfMonthAndSCDMonthField.put(6,var.June_Volume__c);
                    MapOfMonthAndSCDMonthField.put(7,var.July_Volume__c);
                    MapOfMonthAndSCDMonthField.put(8,var.August_Volume__c);
                    MapOfMonthAndSCDMonthField.put(9,var.September_Volume__c);
                    MapOfMonthAndSCDMonthField.put(10,var.October_Volume__c);
                    MapOfMonthAndSCDMonthField.put(11,var.November_Volume__c);
                    MapOfMonthAndSCDMonthField.put(12,var.December_Volume__c);
                    ret.Year = var.Stock_In_Channel__r.Year__c;
                    ret.Month = MonthToSearch;
                    ret.CustomerCode = var.Stock_In_Channel__r.Channel__r.SAP_Code__c;
                    ret.SKUCode = var.SKU__r.SKU_Code__c;
                    if( MapOfMonthAndSCDMonthField.get(MonthToSearch)!=null ){
                        ret.Volume = MapOfMonthAndSCDMonthField.get(MonthToSearch);
                    }else{
                        ret.Volume = 0;
                    }
                    retList.add(ret);
                }
                
            }else{
                return null;
            }
        }
        return retList;
    }
    
    
    //Sayan ( RITM0152766 & RITM0152769 )
    public static List<Account> getCustomer(String Region,String Salesrep)
    { 
        //fetch Sales org code from Custom settings
        UPL_Settings__c salesOrgDetails = UPL_Settings__c.getInstance();
        String SalesOrg = salesOrgDetails.SalesOrg__c;
        List<User> userlist = [SELECT UGDN_Number__c FROM User WHERE Id =: Salesrep];
        List<String> userugdns = new List<String>();
        for( User temp:userlist ){
            userugdns.add( temp.UGDN_Number__c );
        }
        List<SIC_Customer__c> SICCustList = new List<SIC_Customer__c>();
        
        
        List<Account> Cust = new list<Account>();
        set<string> setCustomerCode = new set<string>();
        for(SIC_Customer__c A: [Select Customer_SAP_Code__c 
                                from SIC_Customer__c
                                where year__c = :string.valueOf(Date.Today().Year())
                                and active__c = true AND Sales_Rep_UGDN__c IN:userugdns] ){
                                    if( A.Customer_SAP_Code__c.length()==9 ){
                                        A.Customer_SAP_Code__c = '0'+A.Customer_SAP_Code__c;
                                    }else if( A.Customer_SAP_Code__c.length()==8 ){
                                        A.Customer_SAP_Code__c = '00'+A.Customer_SAP_Code__c;
                                    }else if( A.Customer_SAP_Code__c.length()==7 ){
                                        A.Customer_SAP_Code__c = '000'+A.Customer_SAP_Code__c;
                                    }else if( A.Customer_SAP_Code__c.length()==6 ){
                                        A.Customer_SAP_Code__c = '0000'+A.Customer_SAP_Code__c;
                                    }
                                    setCustomerCode.add(A.Customer_SAP_Code__c);   
                                }
        Cust = [SELECT Id, Name, BillingCity,  SAP_Code__c 
                FROM Account 
                where SAP_Code__c in :setCustomerCode
                order by Name asc];
        return Cust;
    }
    //Sayan ( RITM0152766 & RITM0152769 )
    
    @AuraEnabled
    public static boolean submitDate(Integer bDate)
    {
        UPL_Settings__c enddate = UPL_Settings__c.getOrgDefaults();
        enddate.Visibility_Date__c=bDate;
        update enddate;
        //Scheduling/Aborting SChedule jobs to send SIC Reminder email before 5 and 2 days.
        List<CronTrigger> liScheduledJobs = [SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType 
                                             FROM CronTrigger
                                             where CronJobDetail.Name = 'SIC Reminder Before 5 Days'
                                             or CronJobDetail.Name = 'SIC Reminder Before 2 Days'];
        if(liScheduledJobs.size()>0){
            
            for (CronTrigger CT: liScheduledJobs){
                System.abortJob(CT.id);
            }
            
        }
        string Days5Before = String.valueof(bDate-5);
        string Days3Before = String.valueof(bDate-2);
        String schedmon5am = '0 0 0 '+Days5Before+' * ?';          
        SICScheduleEmailToTMRM SC5 = new SICScheduleEmailToTMRM(); 
        System.schedule('SIC Reminder Before 5 Days', schedmon5am, SC5);
        
        String schedmon3am = '0 0 0 '+Days3Before+' * ?';          
        SICScheduleEmailToTMRM SC3 = new SICScheduleEmailToTMRM(); 
        System.schedule('SIC Reminder Before 2 Days', schedmon3am, SC3);
        //end
        return true;
    }
    
    
    @AuraEnabled
    public static InventoryUpload checkAccess(){
        InventoryUpload oAccess = new InventoryUpload();
        UPL_Settings__c enddate = UPL_Settings__c.getInstance();
        system.debug('end date is'+enddate) ;
        oAccess.blockDate= integer.valueof(enddate.Visibility_Date__c);
        
        Boolean hasCustomPermissionDisti = FeatureManagement.checkPermission('Edit_Permission_for_Distributor_Volume');
        Boolean hasCustomPermissionFull = FeatureManagement.checkPermission('Edit_Permission_For_Distributor_and_UPl_Inventory');
        system.debug('value of permission is '+ hasCustomPermissionDisti+'full is  '+hasCustomPermissionFull );
        if(hasCustomPermissionFull){
            oAccess.isCustomer= true;
        }
        else{    
            if(hasCustomPermissionDisti)
            {
                oAccess.isSalesRep = true;
            }
        }   
        return oAccess;
    }
    
    public class errorWrapper {
        @AuraEnabled
        public Integer recordno {get;set;}
        @AuraEnabled
        public string year {get;set;}
        @AuraEnabled
        public string SKUID {get;set;}
        @AuraEnabled
        public String monthValue {get;set;}
        @AuraEnabled
        public String customerID {get;set;}
        @AuraEnabled
        public String reason {get;set;}
        @AuraEnabled
        public String vol {get;set;}
        
    }
    
    @AuraEnabled
    public static string passFile(String file,String volume)
    {
        list<errorWrapper> errorList= new list<errorWrapper>();
        list<String> arrayMonth= new list<String>{'January','February','March','April','May','June','July','August','September','October','November','December'};
            map<String,String> numericMonth= new Map<String,String>();
        numericMonth.put('1','January');
        numericMonth.put('2','February');
        numericMonth.put('3','March');
        numericMonth.put('4','April');
        numericMonth.put('5','May');
        numericMonth.put('6','June');
        numericMonth.put('7','July');
        numericMonth.put('8','August');
        numericMonth.put('9','September');
        numericMonth.put('10','October');
        numericMonth.put('11','November');
        numericMonth.put('12','December');        
        Map<Integer,boolean> validRecord= new map<Integer,boolean>();    
        try{
            String uploadvolume='_Volume__c';        
            if (volume.equals('upl'))
            {
                uploadvolume= '_Volume_Co__c';     
            }
            UPL_Settings__c enddate = UPL_Settings__c.getInstance();
            String salesorg=enddate.SalesOrg__c;
            system.debug('end date is'+enddate) ;
            Integer visibledate = integer.valueof(enddate.Visibility_Date__c); 
            Integer paddingsapcode= integer.valueof(enddate.PaddingSAPCode__c);
            Integer paddingsku= integer.valueof(enddate.PaddingSKU__c);
            Integer dy = Date.Today().day()-20;
            String myDatetimeStr = Datetime.now().format('MMMM');
            system.debug(''+myDatetimeStr);
            //added by Swapnil
            String profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
            boolean blockupload = false;
            
            if(visibledate<=dy){
                blockupload = true;
            }
            if(profileName == 'Brazil Customer Service User'){
                blockupload=false;
            }
            
            //end
            
            if (blockupload )//visibledate<=dy updated by Swapnil
            {
                return ('Updation not allowed');
            }
            else
            {
                Set<String> CustomerCode = new Set<String>(); 
                Set<String> TerritoryCode = new Set<String>(); 
                Set<String> SKU = new Set<String>(); 
                List<string> inputvalues = new list<string>();
                List<Account> CustomerAccountLst= new list<Account>();
                Map<String, Account> MapOfCustomerAccount = new Map<String, Account>();
                List<String> lstCustomerCode = new List<String>();
                List<String> lstSKU = new List<String>();
                //header map
                map <String,String> mapheader = new map<String,String>();
                map <String,id> mapdetails = new map<String,id>();
                list<Stock_In_Channel__c> lststockinchannel = new list<Stock_In_Channel__c>();    
                list<Stock_In_Channel_Detail__c> lststockinchanneldetails = new list<Stock_In_Channel_Detail__c>();    
                
                String []filelines;
                String myFile = EncodingUtil.urlDecode(file, 'UTF-8');
                filelines = myFile.split('\n');
                system.debug('Inside Apex');
                system.debug('file'+file);
                for (Integer i=1;i<filelines.size();i++)
                {
                    
                    inputvalues = filelines[i].split(',');
                    inputvalues[2]= inputvalues[2].leftPad(paddingsapcode,'0');
                    system.debug('SKU Code->'+inputvalues[3]);
                    inputvalues[3]= inputvalues[3].leftPad(paddingsku,'0');
                    //system.debug('leftpad is '+inputvalues[2] +''+inputvalues[1]);
                    
                    //Adding to make sure that SOQL works fine even if user have entered Customer Code 1070904 in place of 0001070904 inside csv template
                    if( inputvalues[2].length()==9 ){
                        CustomerCode.add('0'+inputvalues[2]);
                    }else if( inputvalues[2].length()==8 ){
                        CustomerCode.add('00'+inputvalues[2]);
                    }else if( inputvalues[2].length()==7 ){
                        CustomerCode.add('000'+inputvalues[2]);
                    }else if( inputvalues[2].length()==6 ){
                        CustomerCode.add('0000'+inputvalues[2]);
                    }else{
                        CustomerCode.add(inputvalues[2]);
                    }
                    //End
                    
                    //Adding to make sure that SOQL works fine even if user have entered SKU Code 6302691 in place of 000000000006302691 inside csv template
                    if(inputvalues[3].length()==6){
                        SKU.add('000000000000'+inputvalues[3]);
                    }else if(inputvalues[3].length()==7){
                        SKU.add('00000000000'+inputvalues[3]);
                    }else{
                        SKU.add(inputvalues[3]);
                    }
                    //End
                }
                
                lstCustomerCode.addAll(CustomerCode);
                lstSKU.addAll(SKU);
                System.debug('lstCustomerCode is '+ lstCustomerCode);
                Map<Id, Account> mapAcc = new Map<Id, Account>([SELECT id, SAP_Code__c FROM Account WHERE SAP_Code__c IN : lstCustomerCode]);
                Map<String, Id> mapSAPCodeAccId = new Map<String, Id>();
                for(Id itemId: mapAcc.keySet()){
                    
                    mapSAPCodeAccId.put(mapAcc.get(itemId).SAP_Code__c, itemId);
                    //System.debug('map is ' + mapAcc.get(itemId).SAP_Code__c);
                }
                //map for sku 
                Map<Id, SKU__c> mapSKU = new Map<Id, SKU__c>([SELECT id, SKU_Code__c FROM SKU__c WHERE SKU_Code__c IN : lstSKU AND Sales_Org_Code__c = '5191']);//INCTASK0351786: Sayan
                Map<String, Id> mapSKUId = new Map<String, Id>();
                for(Id itemId: mapSKU.keySet()){
                    mapSKUId.put(mapSKU.get(itemId).SKU_Code__c, itemId);
                    //System.debug('map is ' + mapSKU.get(itemId).SKU_Code__c);
                }
                
                List<Territory_Distributor__c> territory = new list<Territory_Distributor__c>([select id from Territory_Distributor__c where  TerritoryManager__c=:UserInfo.getUserId() limit 1]);
                system.debug('size is '+territory.size());
                
                for (Integer i=1;i<filelines.size();i++)
                {
                    
                    String counter='0';
                    Boolean volResult =false;
                    inputvalues = filelines[i].split(',');
                    inputvalues[2]= inputvalues[2].leftPad(paddingsapcode,'0');
                    inputvalues[3]= inputvalues[3].leftPad(paddingsku,'0');
                    
                    String testVolume= inputvalues[4].trim();
                    String regrex= '^[0-9 .]*$';
                    Pattern num= Pattern.compile(regrex);
                    Matcher match= num.matcher(testVolume);
                    volResult= match.matches();
                    
                    // new validations 
                    errorWrapper err = new errorWrapper();
                    err.reason='';
                    inputvalues[0]=inputvalues[0].trim();
                    if(!inputvalues[0].isNumeric())
                    {
                        validRecord.put(i,false);
                        system.debug('map value is month'+ validRecord.get(i));
                        err.year= inputvalues[0];
                        err.monthValue = inputvalues[1];
                        err.customerID= inputvalues[2];
                        err.SKUID= inputvalues[3];
                        err.vol=inputvalues[4].trim();
                        err.reason= 'Invalid Year ';
                        counter='1';  
                    }
                    inputvalues[1]=inputvalues[1].trim();
                    if(!arrayMonth.contains(inputvalues[1])||inputvalues[1] == null || inputvalues[1] =='')
                    {
                        if(!numericMonth.containsKey(inputvalues[1]))
                        {
                            
                            //err.recordno= i+1;
                            validRecord.put(i,false);
                            system.debug('map value is month'+ validRecord.get(i));
                            err.year= inputvalues[0];
                            err.monthValue = inputvalues[1];
                            err.customerID= inputvalues[2];
                            err.SKUID= inputvalues[3];
                            err.vol=inputvalues[4].trim();
                            err.reason=err.reason+'Invalid month name';
                            counter='1';
                        }
                        //errorList.add(err);
                    }
                    if (mapSAPCodeAccId.get(inputvalues[2])== null ||inputvalues[2]==null || inputvalues[2]=='')
                    {
                        //err.recordno= i+1;
                        validRecord.put(i,false);
                        system.debug('map value is custom'+ validRecord.get(i));
                        err.year= inputvalues[0];
                        err.monthValue = inputvalues[1];
                        err.customerID= inputvalues[2];
                        err.SKUID=inputvalues[3];
                        err.vol=inputvalues[4].trim();
                        err.reason=err.reason+' Invalid customer Code ';
                        counter='1';
                    }
                    if (mapSKUId.get(inputvalues[3])== null || inputvalues[3]==null || inputvalues[3]=='')
                    {
                        //err.recordno= i+1;
                        validRecord.put(i,false);
                        system.debug('map value is sku'+ validRecord.get(i));
                        err.year= inputvalues[0];
                        err.monthValue = inputvalues[1];
                        err.customerID= inputvalues[2];
                        err.SKUID= inputvalues[3];
                        err.vol=inputvalues[4].trim();
                        err.reason=err.reason+' Invalid SKU Code ';
                        counter='1';
                    }
                    //System.debug('value of trim is '+ (inputvalues[4].trim()).isNumeric());
                    if (!volResult)
                    {
                        system.debug('i reached here in vol debug');
                        validRecord.put(i,false);
                        system.debug('map value is vol'+ validRecord.get(i));
                        err.year= inputvalues[0];
                        err.monthValue = inputvalues[1];
                        err.customerID= inputvalues[2];
                        err.SKUID= inputvalues[3];
                        err.vol=inputvalues[4].trim();
                        err.reason=err.reason+' Invalid Vol ';
                        counter='1';
                    }
                    
                    //Sayan new validation ( RITM0152766 & RITM0152769 )
                    String Idf;
                    List<Account> CustomersFromMapping = new List<Account>();
                    List<Id> checkList = new List<Id>();
                    if(profileName == 'Brazil Sales Person'){
                        List<Account> CustomersFromFile = [SELECT Id, Name, BillingCity,  SAP_Code__c FROM Account WHERE SAP_Code__c IN : lstCustomerCode ORDER BY SAP_Code__c DESC];
                        List<Territory_Distributor__c> Bulst = [Select ID from Territory_Distributor__c where 
                                                                (TerritoryManager__c=: UserInfo.getUserId() OR Regional_Manager_Id__c	=: UserInfo.getUserId() 
                                                                 OR Zonal_Manager_Id__c=: UserInfo.getUserId() OR SBU_Head_Id__c=: UserInfo.getUserId() ) 
                                                                AND (Sales_Org_Code__c = :SalesOrg)];
                        for(Territory_Distributor__c g:Bulst){
                            CustomersFromMapping = getCustomer(g.ID,UserInfo.getUserId());
                        }
                        system.debug('CustomersFromMapping->'+CustomersFromMapping);
                        system.debug('CustomersFromFile->'+CustomersFromFile);
                        for( Account temp:CustomersFromFile ){
                            if( !CustomersFromMapping.contains( temp ) ){
                                checkList.add(temp.Id);
                            }
                        }
                        system.debug('checkList->'+checkList);
                        if( checkList.size()>0 ){
                            system.debug('Sales Rep is trying to upload Customers outside of his area');
                            err.year= inputvalues[0];
                            err.monthValue = inputvalues[1];
                            err.customerID= inputvalues[2];
                            err.SKUID= inputvalues[3];
                            err.vol=inputvalues[4].trim();
                            err.reason=err.reason+' You are not allowed to update SKU for some of the Customer Codes';
                            counter='1';
                        }
                        
                    }
                    //Sayan ( RITM0152766 & RITM0152769 )
                    
                    if(counter=='1')
                    {
                        errorList.add(err);
                    }
                    else
                    {
                        validRecord.put(i,true); 
                    }
                    //
                    if (counter =='0')
                    {
                        if(mapheader.get(salesorg+inputvalues[0]+inputvalues[2]) == null)
                        { 
                            mapheader.put(salesorg+inputvalues[0]+inputvalues[2],salesorg+inputvalues[0]+inputvalues[2]);
                            Stock_In_Channel__c st = new Stock_In_Channel__c();
                            st.Year__c= inputvalues[0];
                            st.Combination_Key__c= salesorg+inputvalues[0]+inputvalues[2];
                            //system.debug('value of this mappppppppp'+mapSAPCodeAccId.get(inputvalues[2]));
                            st.Channel__c= mapSAPCodeAccId.get(inputvalues[2]);
                            Boolean hasCustomPermissionDisti = FeatureManagement.checkPermission('Edit_Permission_for_Distributor_Volume');
                            if(hasCustomPermissionDisti)
                            {
                                st.Sales_Rep__c=UserInfo.getUserId();
                                if(territory!=null)
                                {
                                    st.Territory__c= territory[0].id;
                                }
                            }
                            lststockinchannel.add(st);
                        }
                    }
                    
                }
                
                for(errorWrapper er: errorList)
                {
                    System.debug('value of errors is '+er);
                }
                /*for(Integer t: validRecord.keyset())
{
system.debug('value of map is '+t+'   '+ validRecord.get(t));
}*/
                
                Database.UpsertResult[] sicHeader=  Database.upsert(lststockinchannel,Stock_In_Channel__c.Combination_Key__c,false);
                
                for(Stock_In_Channel__c st :lststockinchannel)
                {
                    if(mapheader.containskey(st.Combination_Key__c))
                    {
                        mapheader.put(st.Combination_Key__c,st.Id);
                    }
                    system.debug('value is '+ st.Combination_Key__c);
                    system.debug('value is '+ st.Id);
                }  
                //for detail insertion
                map<String ,Stock_In_Channel_Detail__c> combinemap= new map <String ,Stock_In_Channel_Detail__c>(); 
                for (Integer i=1;i<filelines.size();i++)
                {
                    if(validRecord.get(i))
                    {
                        inputvalues = filelines[i].split(',');
                        inputvalues[2]= inputvalues[2].leftPad(paddingsapcode,'0');
                        inputvalues[3]= inputvalues[3].leftPad(paddingsku,'0');
                        string lastmonth = inputvalues[4];
                        
                        if(numericMonth.containsKey(inputvalues[1]))
                        {
                            inputvalues[1]= numericMonth.get(inputvalues[1]);
                        }
                        
                        // system.debug('value of lastmonth is '+ lastmonth);
                        lastmonth= lastmonth.trim();
                        if (lastmonth ==''|| lastmonth == null|| lastmonth ==' ')
                        {
                            lastmonth='0';
                        }
                        
                        if(mapdetails.get(salesorg+inputvalues[0]+inputvalues[2]+inputvalues[3]) == null && mapheader.containskey(salesorg+inputvalues[0]+inputvalues[2]))
                        {
                            mapdetails.put(salesorg+inputvalues[0]+inputvalues[2]+inputvalues[3],id.valueOf(mapheader.get(salesorg+inputvalues[0]+inputvalues[2])));     
                        }
                        
                        if(combinemap.get(salesorg+inputvalues[0]+inputvalues[2]+inputvalues[3]) == null && mapheader.containskey(salesorg+inputvalues[0]+inputvalues[2]))
                        {
                            Stock_In_Channel_Detail__c de = new Stock_In_Channel_Detail__c();
                            
                            de.put(inputvalues[1]+uploadvolume,decimal.valueOf(lastmonth).setScale(2));
                            de.SKU__c= mapSKUId.get(inputvalues[3]);
                            de.Combination_Key__c= salesorg+inputvalues[0]+inputvalues[2]+inputvalues[3]; 
                            de.Stock_In_Channel__c= mapdetails.get(salesorg+inputvalues[0]+inputvalues[2]+inputvalues[3]); 
                            combinemap.put(salesorg+inputvalues[0]+inputvalues[2]+inputvalues[3],de); 
                            //system.debug('i reached '+ de);
                        }
                        else
                        {
                            if(mapheader.containskey(salesorg+inputvalues[0]+inputvalues[2]))
                            {
                                Stock_In_Channel_Detail__c change =combinemap.get(salesorg+inputvalues[0]+inputvalues[2]+inputvalues[3]); 
                                change.put(inputvalues[1]+uploadvolume,decimal.valueOf(lastmonth).setScale(2));
                                combinemap.put(salesorg+inputvalues[0]+inputvalues[2]+inputvalues[3],change);
                                //  system.debug('i reached c'+ change); 
                            }
                        }
                    }
                }
                
                //upsert  combinemap.values() Combination_Key__c;
                list<string> successstring= new list<string>();
                
                Database.UpsertResult[] updateResults = Database.upsert(combinemap.values(),Stock_In_Channel_Detail__c.Combination_Key__c, false);
                Integer successCounter=0; 
                for(Integer i=0;i<updateResults.size();i++){
                    if (updateResults.get(i).isSuccess()){
                        String succ= String.valueOf(updateResults.get(i).getId());
                        successCounter++;
                        successstring.add(succ);
                        
                    }else if (!updateResults.get(i).isSuccess()){
                        
                        // Database.Error errors = updateResults.get(i).getErrors().get(0);
                        
                    }                        
                }
                //ends             
                if (errorList.size()>0){
                    List<Messaging.Emailfileattachment> efaList = new List<Messaging.Emailfileattachment>();
                    
                    //csv generator code for error 
                    string header = 'Year, Month , CustomerCode, SKU , Volume, Reason \n';
                    string finalstr = header ;
                    for(errorWrapper a: errorList)
                    {
                        string recordString = '"'+a.year+'","'+a.monthValue+'","'+a.customerID+'","'+a.SKUID +'","'+a.vol+'","'+a.reason +'" \n';
                        finalstr = finalstr +recordString;
                    }
                    
                    //csv for success
                    string successheader= 'RecordId \n';
                    string finalSuccessHeader= successheader;
                    for (string success: successstring)
                    {
                        String tempString =success+'\n'; 
                        finalSuccessHeader= finalSuccessHeader+tempString;
                    }//ends
                    Messaging.EmailFileAttachment csvsuccessAttc = new Messaging.EmailFileAttachment();
                    blob csvsuccessBlob = Blob.valueOf(finalSuccessHeader);
                    string csvsuccessname= 'Success.csv';
                    csvsuccessAttc.setFileName(csvsuccessname);
                    csvsuccessAttc.setBody(csvsuccessBlob);
                    efaList.add(csvsuccessAttc);
                    //
                    
                    String loggedInUser= UserInfo.getUserEmail();
                    system.debug('email value is '+ loggedInUser);
                    // 
                    Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                    blob csvBlob = Blob.valueOf(finalstr);
                    string csvname= 'error.csv';
                    csvAttc.setFileName(csvname);
                    csvAttc.setBody(csvBlob);
                    efaList.add(csvAttc);
                    Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
                    String[] toAddresses = new list<string> {loggedInUser};
                        String subject =Label.SIC_email_Subject;
                    email.setSubject(subject);
                    email.setToAddresses( toAddresses );
                    email.setPlainTextBody(Label.SIC_email_Text);
                    //email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
                    email.setFileAttachments(efaList);
                    Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                    return 'email';
                }
                else
                {
                    String recordsupdated= String.valueOf(successCounter);        
                    return ('success:'+recordsupdated);
                }
            } 
        }
        catch(Exception e)
        {   
            System.debug('exception is '+ e.getMessage()+ 'line'+e.getLineNumber());
            return 'exception occured';   
        }    
    }   
}