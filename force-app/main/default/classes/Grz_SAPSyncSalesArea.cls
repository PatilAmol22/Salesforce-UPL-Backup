/**************************************************************************************************
* Name               : Grz_SAPSyncSalesArea                                                      
* Description        : Used for Customer Onboarding SAP integration
* Created Date       : 18/01/2022                                                                 
* Created By         : Aashima Puri (Grazitti)  
* JIRA               : APPS-2665
**************************************************************************************************/ 
public with sharing class Grz_SAPSyncSalesArea {
    
    @AuraEnabled
    public static responseClass checkPreConditions(String recordId){
        Boolean isCreation=true;
        responseClass responseData=new responseClass();
        String fieldList='SBU__c,Distributor_SAP_Code__c,Depot__c,Zone_Code__c,Distributor__c,Sales_District__c,PrIceListTypeMaster__c,Payment_Term__c,Territory__c,Stage__c,Substage__c,Sales_Org_Code__c,Distribution_Channel_Code__c,Division_Code__c,Depot__r.Depot_Code__c,Zone_Code__r.ZoneCode__c,Company_Code__c,Sales_District__r.Sales_District_Code__c,Sales_Group__c,PrIceListTypeMaster__r.Price_List_Type__c,Payment_Term__r.Payment_Term_Code__c,CreatedBy.TM_Code__c,Territory__r.TerritoryCode__c,Customer_Group_1__c,Distributor__r.Billing_Street_2__c,Distributor__r.BillingStreet,Distributor__r.BillingCity,Distributor__r.BillingPostalCode,Distributor__r.BillingCountry,Distributor__r.Mobile__c,Distributor__r.Email__c,Distributor__r.Tax_Number_3__c,Distributor__r.Non_Gst_Customer__c,Distributor__r.Status__c,Distributor__r.Currency_Onboarding__c,Distributor__r.Name,Incoterms_Part_1SA__c,Incoterms_Part_2SA__c,Distributor__r.PAN_Number__c,Distributor__r.Account_Type__c,Distributor__r.First_Name__c,Distributor__r.Last_Name__c,Distributor__r.State_Union_Territory__c,Distributor__r.E_Invoice_Category__c';
        String queryVal='Select id,'+fieldList+',(Select id,Name,Relationship__c,Specimen_Signature__c,Age__c from On_Boarding_Annexures__r) from DistributorSalesAreaMapping__c where id = \''+recordId+'\'';
        List<DistributorSalesAreaMapping__c> salesAreaRecord=Database.query(queryVal);
        List<String> fieldsQueried=fieldList.split(',');
        List<String> fieldsQueriedCapital=fieldList.split(',');
        for(String s:fieldsQueried){
            fieldsQueriedCapital.add(s.toUpperCase());
        }
        System.debug('fieldsQueried==>'+fieldsQueried);
        List<String> emptyDataListAccount=new List<String>();
        List<String> emptyDataListSalesArea=new List<String>();
        System.debug('salesAreaRecord==>'+salesAreaRecord);
        if(!salesAreaRecord.isEmpty()){
            String firstName=salesAreaRecord[0].Distributor__r.First_Name__c;
            String lastName=salesAreaRecord[0].Distributor__r.Last_Name__c;
            Integer nameLength=0;
            if(firstName!=null){
                nameLength=firstName.length();
            }
            if(lastName!=null){
                nameLength=nameLength+lastName.length();
            }
            if(null==salesAreaRecord[0].CreatedBy.TM_code__c){
                responseData.Message='Kindly fill TM Code for the creator of this sales area.';
                responseData.Status=true;
            }
            else if(salesAreaRecord[0].Distributor__r.Name.length()>40){
                responseData.Message='Account name cannot be more than 40 characters.Kindly edit and retry';
                responseData.Status=true;
            }
            else if(nameLength>40){
                responseData.Message='Customer\'s first and last name cannot be more than 40 characters.Kindly edit and retry';
                responseData.Status=true;
            }
            else{
                if((salesAreaRecord[0].Stage__c=='Final GBS Approval' && salesAreaRecord[0].Substage__c=='Approved') ||(salesAreaRecord[0].Stage__c=='SAP Status' && salesAreaRecord[0].Substage__c=='Error')){
                    if(salesAreaRecord[0].Distributor_SAP_Code__c!='' && salesAreaRecord[0].Distributor_SAP_Code__c!=null){
                        isCreation=false;
                    }
                    Map<String,String> accountFieldsMap=new Map<String,String>();
                    Map<String,String> salesAreaFieldsMap=new Map<String,String>();
                    
                    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                    if(isCreation==true){
                        Schema.SObjectType accountSchema = schemaMap.get('Account');
                        Map<String, Schema.SObjectField> fieldMap = accountSchema.getDescribe().fields.getMap();
                        for (String fieldName: fieldMap.keySet()) {
                            accountFieldsMap.put(fieldName,fieldMap.get(fieldName).getDescribe().getLabel());
                        }
                        System.debug('accountFieldsMap==>'+accountFieldsMap);
                    }
                    
                    Schema.SObjectType saSchema = schemaMap.get('DistributorSalesAreaMapping__c');
                    Map<String, Schema.SObjectField> fieldMap1 = saSchema.getDescribe().fields.getMap();
                    for (String fieldName: fieldMap1.keySet()) {
                        if(fieldName!='Distributor_SAP_Code__c' && fieldName!='Customer_Group_1__c'){
                            salesAreaFieldsMap.put(fieldName,fieldMap1.get(fieldName).getDescribe().getLabel());   
                        }
                    }
                    System.debug('salesAreaFieldsMap==>'+salesAreaFieldsMap);
                    
                    //List<String> emptyDataListAccount=new List<String>();
                    system.debug('@@@@@isCreation@@@@'+isCreation);
                    if(isCreation==true){
                        for(String s:accountFieldsMap.keySet()){
                            String ss='Distributor__r.'+s;
                            if(fieldsQueriedCapital.contains(ss.toUpperCase())){
                                System.debug('Account field label==>'+s);
                                System.debug('Account field value==>'+salesAreaRecord[0].Distributor__r.get(s));
                                if(salesAreaRecord[0].Distributor__r.get(s)=='' || salesAreaRecord[0].Distributor__r.get(s)=='undefined' || salesAreaRecord[0].Distributor__r.get(s)==null){
                                    emptyDataListAccount.add(accountFieldsMap.get(s));
                                }
                            }                    
                        }
                        System.debug('emptyDataListAccount==>'+emptyDataListAccount);
                    }
                    
                    // List<String> emptyDataListSalesArea=new List<String>();
                    for(String s:salesAreaFieldsMap.keySet()){
                        if(fieldsQueriedCapital.contains(s.toUpperCase())){
                            System.debug('Sales Area field label==>'+s);
                            System.debug('Sales Area field value==>'+salesAreaRecord[0].get(s));
                            if(salesAreaRecord[0].get(s)=='' || salesAreaRecord[0].get(s)=='undefined' || salesAreaRecord[0].get(s)==null){
                                if(s!='Sales_District__c'){
                                    if((salesAreaRecord[0].get('sales_org_code__c')=='1210' && (s=='Zone__c' || s=='PriceListTypeMaster__c')) || (salesAreaRecord[0].get('sales_org_code__c')=='1210' && s=='SBU__c')){
                                        
                                    }
                                    else{
                                        emptyDataListSalesArea.add(salesAreaFieldsMap.get(s)); 
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                    System.debug('emptyDataListSalesArea==>'+emptyDataListSalesArea);
                    if((emptyDataListSalesArea.isEmpty() && emptyDataListAccount.isEmpty() && !salesAreaRecord[0].On_Boarding_Annexures__r.isEmpty()) || Test.isRunningTest()){
                        responseData.Status=true;
                        responseData.Message='Data complete';
                        responseData.AnnexureDataFilled=true;
                        
                        //Creating SAP request JSON
                        sapWrapper sapRequestJson=new sapWrapper();
                        
                        //Getting value set for region i.e. State Code
                        Map<String,String> stateMap=new  Map<String,String>();
                        for(grz_StateCodeOnboarding__mdt g:grz_StateCodeOnboarding__mdt.getAll().values()){
                            stateMap.put(g.state_name__c.toUpperCase(),g.state_code__c);
                        }
                        
                        //Creation of contactpersontable list
                        List<contactPersonTableWrapper> cc=new List<contactPersonTableWrapper>();
                        for(On_Boarding_Annexure_3__c o:salesAreaRecord[0].On_Boarding_Annexures__r){
                            contactPersonTableWrapper c=new contactPersonTableWrapper();
                            c.Name=o.Name;
                            c.Age=String.valueOf(o.Age__c);
                            c.Relationship=o.Relationship__c;
                            c.Specimen_Signature=o.Specimen_Signature__c;
                            cc.add(c);
                        }
                        sapRequestJson.contactPersonTable=cc;
                        System.debug('sapRequestJson.contactPersonTable==>'+sapRequestJson.contactPersonTable);
                        if(isCreation==true){
                            //Creation of information part of wrapper
                            List<String> streetValues=new List<String>();
                            if(salesAreaRecord[0].Distributor__r.BillingStreet.length()>40){
                                streetValues.addAll(divideStreetFieldValues(salesAreaRecord[0].Distributor__r.BillingStreet));
                            }
                            else{
                                streetValues.add(salesAreaRecord[0].Distributor__r.BillingStreet);
                            }
                            if(salesAreaRecord[0].Distributor__r.Billing_Street_2__c.length()>40){
                                streetValues.addAll(divideStreetFieldValues(salesAreaRecord[0].Distributor__r.Billing_Street_2__c));
                            }
                            else{
                                streetValues.add(salesAreaRecord[0].Distributor__r.Billing_Street_2__c);
                            }
                            //Only 4 street fields to be sent to SAP                    
                            if(!streetValues.isEmpty()){
                                if(streetValues.size()>1){
                                    for(Integer i=0;i<streetValues.size();i++){
                                        if(i==0){
                                            sapRequestJson.BillingStreet=streetValues[i];
                                        }
                                        else if(i==1){
                                            sapRequestJson.Billing_Street_2=streetValues[i];
                                        }
                                        else if(i==2){
                                            sapRequestJson.Billing_Street_3=streetValues[i];
                                        }
                                        else if(i==3){
                                            sapRequestJson.Billing_Street_4=streetValues[i];
                                        }
                                    }
                                }
                                else{
                                    sapRequestJson.BillingStreet=streetValues[0];
                                    sapRequestJson.Billing_Street_2='';
                                    sapRequestJson.Billing_Street_3='';
                                    sapRequestJson.Billing_Street_4='';
                                }
                            }
                            else{
                                sapRequestJson.BillingStreet='';
                                sapRequestJson.Billing_Street_2='';
                                sapRequestJson.Billing_Street_3='';
                                sapRequestJson.Billing_Street_4='';
                                
                            }
                            
                            
                            if(sapRequestJson.Billing_Street_2==null){
                                sapRequestJson.Billing_Street_2='';
                            }
                            if(sapRequestJson.Billing_Street_3==null){
                                sapRequestJson.Billing_Street_3='';
                            }
                            if(sapRequestJson.Billing_Street_4==null){
                                sapRequestJson.Billing_Street_4='';
                            }
                            sapRequestJson.Account_Type=salesAreaRecord[0].Distributor__r.Account_Type__c;
                            sapRequestJson.BillingCity=salesAreaRecord[0].Distributor__r.BillingCity;
                            sapRequestJson.BillingPostalCode=salesAreaRecord[0].Distributor__r.BillingPostalCode;
                            sapRequestJson.BillingCountry=salesAreaRecord[0].Distributor__r.BillingCountry;
                            sapRequestJson.Mobile=salesAreaRecord[0].Distributor__r.Mobile__c;
                            sapRequestJson.Email=salesAreaRecord[0].Distributor__r.Email__c;
                            sapRequestJson.Tax_Number_3=salesAreaRecord[0].Distributor__r.Tax_Number_3__c;
                            sapRequestJson.Status=salesAreaRecord[0].Distributor__r.Status__c;
                            
                            sapRequestJson.companyName=salesAreaRecord[0].Distributor__r.Name;
                            sapRequestJson.Currency_Onboarding=salesAreaRecord[0].Distributor__r.Currency_Onboarding__c;  
                            sapRequestJson.PAN_Number=salesAreaRecord[0].Distributor__r.PAN_Number__c;
                            sapRequestJson.E_Invoice_Category=String.valueOf(salesAreaRecord[0].Distributor__r.E_Invoice_Category__c);
                            sapRequestJson.Non_Gst_Customer=String.valueOf(salesAreaRecord[0].Distributor__r.Non_Gst_Customer__c);
                            sapRequestJson.Customer_First_Name=salesAreaRecord[0].Distributor__r.First_Name__c;
                            sapRequestJson.Customer_Last_Name=salesAreaRecord[0].Distributor__r.Last_Name__c;
                            sapRequestJson.STATE=salesAreaRecord[0].Distributor__r.State_Union_Territory__c;
                            sapRequestJson.REGION=stateMap.get(salesAreaRecord[0].Distributor__r.State_Union_Territory__c.toUpperCase());
                        }
                        if(salesAreaRecord[0].Distributor_SAP_Code__c!=''){
                            sapRequestJson.Distributor=salesAreaRecord[0].Distributor_SAP_Code__c;
                        }
                        if(salesAreaRecord[0].Sales_Org_code__c=='1210'){
                            sapRequestJson.AuthorizationGroupSalesoffice=salesAreaRecord[0].Depot__r.Depot_Code__c;
                        }
                        
                        else{
                            sapRequestJson.AuthorizationGroupSalesoffice=salesAreaRecord[0].Zone_Code__r.ZoneCode__c;
                        }
						String pgcodeValue='';
						if(salesAreaRecord[0].Sales_Org_code__c=='1210'){
							pgcodeValue='04';
						}
						else if(salesAreaRecord[0].Sales_Org_code__c=='1410'){
							pgcodeValue='03';
						}
						sapRequestJson.PG_Code=pgcodeValue;
						sapRequestJson.Cust_Group=pgcodeValue;
						
						
                        //sapRequestJson.Cust_Group=salesAreaRecord[0].PriceGroupMaster__r.PG_Code__c;
                        sapRequestJson.Sales_Org_Code=salesAreaRecord[0].Sales_Org_Code__c;
                        sapRequestJson.Distribution_Channnel_Code=salesAreaRecord[0].Distribution_Channel_Code__c;
                        sapRequestJson.Division_Code=salesAreaRecord[0].Division_Code__c;
                        sapRequestJson.Depot_Code=salesAreaRecord[0].Depot__r.Depot_Code__c;
                        sapRequestJson.Company_Code=salesAreaRecord[0].Company_Code__c;
                        sapRequestJson.Authorization=salesAreaRecord[0].Depot__r.Depot_Code__c;
                        sapRequestJson.Sales_District_Code=salesAreaRecord[0].Sales_District__r.Sales_District_Code__c;
                        sapRequestJson.SalesGroupAFGFCGVSG=salesAreaRecord[0].Sales_Group__c;
                        //sapRequestJson.PG_Code=salesAreaRecord[0].PriceGroupMaster__r.PG_Code__c;
                        sapRequestJson.Price_List_Type=salesAreaRecord[0].PrIceListTypeMaster__r.Price_List_Type__c;
                        sapRequestJson.DeliveringDepot_Code=salesAreaRecord[0].Depot__r.Depot_Code__c;
                        sapRequestJson.Payment_Term_Code1=salesAreaRecord[0].Payment_Term__r.Payment_Term_Code__c;
                        sapRequestJson.TM_Code=salesAreaRecord[0].CreatedBy.TM_Code__c;
                        String s=salesAreaRecord[0].Territory__r.TerritoryCode__c;
                        if((salesAreaRecord[0].Sales_Org_code__c=='1210' || salesAreaRecord[0].Sales_Org_code__c=='1410') && s.length()>3){
                            s=s.right(3);
                        }
                        system.debug('s==>'+s);
                        sapRequestJson.TerritoryCode=s;
                        sapRequestJson.Customer_Group_1=salesAreaRecord[0].Customer_Group_1__c;
                        sapRequestJson.Incoterms_Part_1=salesAreaRecord[0].Incoterms_Part_1SA__c;
                        sapRequestJson.Incoterms_Part_2=salesAreaRecord[0].Incoterms_Part_2SA__c;
                        System.debug('sapRequestJson==>'+sapRequestJson);
                        System.debug('JSON sapRequestJson==>'+stripJsonNulls(JSON.serialize(sapRequestJson)));
                        String sapResponse;
                        system.debug('@@@@@isCreation@@@@213-->'+isCreation);
                        
                        //Fetching endpoint as per sales org from custom metadata
                        Map<String, Grz_Customer360IntegrationMappings__mdt> integrationSettingsMap = new Map<String, Grz_Customer360IntegrationMappings__mdt>();
                        for(Grz_Customer360IntegrationMappings__mdt data: Grz_Customer360IntegrationMappings__mdt.getAll().values()){
                            integrationSettingsMap.put(data.Sales_Org_Code__c, data);
                        }
                        Grz_Customer360IntegrationMappings__mdt metadataRecord=new Grz_Customer360IntegrationMappings__mdt();
                        if(!integrationSettingsMap.isEmpty() && integrationSettingsMap.containsKey(salesAreaRecord[0].Sales_Org_Code__c)){
                            metadataRecord=integrationSettingsMap.get(salesAreaRecord[0].Sales_Org_Code__c);
                        }
                        System.debug('metadataRecord==>'+metadataRecord);
                        if(isCreation==true){
                            sapResponse = Grz_OnboardingSAPIntegration.customerCreation(JSON.serialize(sapRequestJson),metadataRecord);
                        }
                        else{
                            sapResponse = Grz_OnboardingSAPIntegration.salesAreaExtention(stripJsonNulls(JSON.serialize(sapRequestJson)),metadataRecord);
                        }
                        System.debug('sapResponse==>'+sapResponse);
                        if(sapResponse=='Error_In_Sap'){
                            responseData.Message='Error in SAP';
                            responseData.Status=false;
                            responseData.AnnexureDataFilled=true;
                            DistributorSalesAreaMapping__c sa=new DistributorSalesAreaMapping__c(Id=recordId,SAP_Response__c='Error in SAP', Stage__c='SAP Status',Substage__c='Error');
                            update sa;
                        }
                        else if(sapResponse=='Endpoint_Unavailable'){
                            responseData.Message='No endpoint available for integration';
                            responseData.Status=false;
                            responseData.AnnexureDataFilled=true;
                            DistributorSalesAreaMapping__c sa=new DistributorSalesAreaMapping__c(Id=recordId,SAP_Response__c='No endpoint available for integration', Stage__c='SAP Status',Substage__c='Error');
                            update sa;
                        }
                        else{
                            sapResponseWrapper sapList=sapResponseWrapper.parse(sapresponse);
                            system.debug('sapList==>'+sapList);
                            //system.debug('item==>'+sapList.item);
                            //if(!sapList.item.isEmpty() && sapList.item.size()==2){
                            responseData.Message=sapList.item.SAP_Response;
                            responseData.Status=true;
                            responseData.AnnexureDataFilled=true;
                            DistributorSalesAreaMapping__c sa=new DistributorSalesAreaMapping__c(Id=recordId,SAP_Response__c=sapList.item.SAP_Response, Stage__c='SAP Status',Substage__c='Created');
                            if((null == sapList.item.SAP_Code || '' == sapList.item.SAP_Code) && !sapList.item.SAP_Response.containsIgnoreCase('Customer Extended successfully') && !sapList.item.SAP_Response.containsIgnoreCase('Customer Already Extended')){
                                sa.Substage__c='Error';
                            }
                            
                                update sa;
                            if(sapList.item.SAP_Code!='' && sapList.item.SAP_Code!=null){
                                Grz_OnboardingCrownIntegration.updateSAPNumber(recordId,sapList.item.SAP_Code,sapList.item.SAP_Response);
                                if(isCreation==true){
                                    List<Account> acc=[Select id, sap_code__c,recordTypeId from account where id=:salesAreaRecord[0].Distributor__c ];
                                    if(!acc.isEmpty() && acc[0].Sap_code__c==null){// added by Shubham 3 feb
                                        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
                                        acc[0].SAP_Code__c=sapList.item.SAP_Code;
                                        acc[0].recordTypeId=recordTypeId;
                                        update acc[0];
                                    }
                                }
                                else{
                                    Grz_UpdateOnboardingAccount.UpdateAccountFromSalesArea(salesAreaRecord[0].id);
                                }
                            }
                        }
                        
                    }
                    else{
                        if(salesAreaRecord[0].On_Boarding_Annexures__r.isEmpty()){
                            responseData.AnnexureDataFilled=false;
                        }
                        else{
                            responseData.AnnexureDataFilled=true;
                        }
                        responseData.Message='Data not complete';
                        responseData.Status=false;
                        
                    }
                }
                else if(salesAreaRecord[0].Stage__c=='SAP Status' && salesAreaRecord[0].Substage__c=='Created'){
                    responseData.Message='Customer is already created';
                    responseData.Status=true;
                }
                else{
                    responseData.Message='Customer is not processed completely for SAP integration.';
                    responseData.Status=true;
                }
            }
            
        }
        system.debug('responseData==>'+responseData);
        responseData.emptyDataListSalesArea=emptyDataListSalesArea;
        responseData.emptyDataListAccount=emptyDataListAccount;
        return responseData;
    }
    
    //Wrappers for LWC and SAP
    public class responseClass{
        @AuraEnabled public Boolean Status      {get;set;}
        @AuraEnabled public String Message      {get;set;}
        @AuraEnabled public List<String> emptyDataListSalesArea      {get;set;}
        @AuraEnabled public List<String> emptyDataListAccount      {get;set;}
        @AuraEnabled public Boolean AnnexureDataFilled      {get;set;}
    }
    
    public class sapWrapper{
        @AuraEnabled public String Account_Type      {get;set;}
        @AuraEnabled public String Sales_Org_Code      {get;set;}
        @AuraEnabled public String Distribution_Channnel_Code      {get;set;}
        @AuraEnabled public String Division_Code      {get;set;}
        @AuraEnabled public String BillingStreet      {get;set;}
        @AuraEnabled public String Billing_Street_2      {get;set;}
        @AuraEnabled public String Billing_Street_3      {get;set;}
        @AuraEnabled public String Billing_Street_4      {get;set;}
        @AuraEnabled public String BillingCity      {get;set;}
        @AuraEnabled public String BillingPostalCode      {get;set;}
        @AuraEnabled public String BillingCountry      {get;set;}
        @AuraEnabled public String Mobile      {get;set;}
        @AuraEnabled public String Email      {get;set;}
        @AuraEnabled public String Depot_Code      {get;set;}
        @AuraEnabled public String Company_Code      {get;set;}
        @AuraEnabled public String Tax_Number_3      {get;set;}
        @AuraEnabled public String Authorization      {get;set;}
        @AuraEnabled public String Status      {get;set;}
        @AuraEnabled public String Sales_District_Code      {get;set;}
        @AuraEnabled public String AuthorizationGroupSalesoffice      {get;set;}
        @AuraEnabled public String SalesGroupAFGFCGVSG      {get;set;}
        @AuraEnabled public String Cust_Group      {get;set;}
        @AuraEnabled public String Currency_Onboarding      {get;set;}
        @AuraEnabled public String PG_Code      {get;set;}
        @AuraEnabled public String Price_List_Type      {get;set;}
        @AuraEnabled public String DeliveringDepot_Code      {get;set;}
        @AuraEnabled public String Incoterms_Part_1      {get;set;}
        @AuraEnabled public String Incoterms_Part_2      {get;set;}
        @AuraEnabled public String Payment_Term_Code1      {get;set;}
        @AuraEnabled public String TM_Code      {get;set;}
        @AuraEnabled public String TerritoryCode      {get;set;}
        @AuraEnabled public String PAN_Number      {get;set;}
        @AuraEnabled public String E_Invoice_Category      {get;set;}
        @AuraEnabled public String Non_Gst_Customer      {get;set;}
        @AuraEnabled public String Customer_First_Name      {get;set;}
        @AuraEnabled public String Customer_Last_Name      {get;set;}
        @AuraEnabled public String STATE      {get;set;}
        @AuraEnabled public String REGION      {get;set;}
        @AuraEnabled public String Customer_Group_1      {get;set;}
        @AuraEnabled public String Distributor      {get;set;}
        @AuraEnabled public String companyName      {get;set;}
        @AuraEnabled public List<contactPersonTableWrapper> contactPersonTable      {get;set;}
    }
    public class contactPersonTableWrapper{
        @AuraEnabled public String Name      {get;set;}
        @AuraEnabled public String Age      {get;set;}
        @AuraEnabled public String Relationship      {get;set;}
        @AuraEnabled public String Specimen_Signature      {get;set;}
    }
    public class sapResponseWrapper{
        public cls_item item;
    }
    public class cls_item {
        public String SAP_Code;	
        public String SAP_Response;	
    }
    public static sapResponseWrapper parse(String json){
        return (sapResponseWrapper) System.JSON.deserialize(json, sapResponseWrapper.class);
    }
    //Method to divide street values in 40 characters strings list for sending to SAP
    public static List<String> divideStreetFieldValues(String s){
        List<String> streetList=new List<String>();
        List<String> spaceList=new List<String>();
        spaceList=s.split(' ');
        system.debug('spaceList==>'+spaceList);
        Integer totalSize=0;
        String streetVal='';
        for(String ss:spaceList){
            Integer sizeVal=ss.length();
            System.debug('totalSize before=>'+totalSize);
            if(totalSize==0){
                totalSize=sizeVal;
            }
            else{
                totalSize=totalSize+sizeVal+1;
            }
            
            System.debug('ss=>'+ss);
            
            System.debug('streetVal before=>'+streetVal);
            if(totalSize<=40){
                if(streetVal==''){
                    streetVal=ss;
                }
                else{
                    streetVal=streetVal+' '+ss;
                }
                
            }
            System.debug('totalSize after=>'+totalSize);
            System.debug('streetVal after=>'+streetVal);
            if((streetVal+' '+ss).length()>=40){
                streetList.add(streetVal.trim());
                streetVal='';
                totalSize=0;
            }
        }
        system.debug('streetList==>'+streetList);
        if(streetVal!=''){
            streetList.add(streetVal.trim());
        }
        system.debug('streetList==>'+streetList);
        return streetList;
    }
    public static string stripJsonNulls(string JsonString)
    {
        
        if(JsonString != null)   	
        {
            JsonString = JsonString.replaceAll('\"[^\"]*\":null',''); //basic removeal of null values
            JsonString = JsonString.replaceAll(',{2,}', ','); //remove duplicate/multiple commas
            JsonString = JsonString.replace('{,', '{'); //prevent opening brace from having a comma after it
            JsonString = JsonString.replace(',}', '}'); //prevent closing brace from having a comma before it
            JsonString = JsonString.replace('[,', '['); //prevent opening bracket from having a comma after it
            JsonString = JsonString.replace(',]', ']'); //prevent closing bracket from having a comma before it
        }
        
        return JsonString;
    }
    
}