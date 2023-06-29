/*
* Name: PriceUploadTurkeyController
* Created On: 16 July 2018
* Author: Ketan Khatri (ketan.khatri@skinternational.com)
* Description: Pricebook and discount upload for turkey
* Related VF : PriceUploadTurkey
* Last Stable Backup : PriceUploadTurkeyControllerV4.0
*/

public class PriceUploadTurkeyController {
    
    public string docType{get;set;}    
    public string csvAsString{get;set;}
    public String[] csvData{get;set;}
    public String fname {get;set;}
    
    public decimal fsize {get;set;}
    
    public transient Blob BlobFileValue {get;set;}
    
    public List<PriceBookMaster__c> upsertPriceList;
    public List<PriceBookDiscount__c> upsertDiscountList;
    
    public PriceUploadTurkeyController(){
        csvData = new String[]{};
        upsertPriceList = new List<PriceBookMaster__c>();
        upsertDiscountList = new List<PriceBookDiscount__c>();
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('',System.Label.None));
        options.add(new SelectOption('Pricebook',System.Label.Price_Book));
        options.add(new SelectOption('Discount',System.Label.Discount_Turkey));
        
        return options;
    }
    
    //Called from action function on the page
    public pagereference processData(){
      //  System.debug('Inside Process Data');
        try{
            
            PageReference pageRef = new PageReference('/'+'PriceUploadTurkey' );
            
            List<String> errorCSVList = new List<String>();
            List<String> successCSVList = new List<String>();
            
            csvAsString = BlobFileValue.toString();
            csvData = csvAsString.split('\r\n'); 
        
            //System.debug('csvData ---> '+csvData);
            successCSVList.add('Record ID,'+csvData[0]);
            errorCSVList.add(csvData[0]+',Error Description');
            // System.debug('docType ---> '+docType+' csvData.size() ---> '+csvData.size());
            /************ for pricebook upload***********/ 
            if(docType=='Pricebook'){          //Added By Ketan
              //  System.debug('Inside Price if');
                for (Integer i = 1; i < csvData.size(); i++){
                    String row = '';
                    try{
                        List<String> csvLineItem = new List<String>();
                        PriceBookMaster__c pbmObj = new PriceBookMaster__c();
                        row = csvData[i];
                        
                        csvLineItem = csvData[i].split(',');
                        
                        String startDate = '';
                        String depotCode = '';
                        String combinationKey = '';
                        String compositeKey = '';
                        String pgCode = '';
                         
                       // System.debug('csvLineItem.size() --> '+csvLineItem.size());
                        //to verify if correct csv was uploaded
                        if(csvLineItem.size()==12){                            
                        for(Integer j=0; j<csvLineItem.size(); j++){
                            
                            if(j==0){
                                if(String.isNotBlank(csvLineItem[j]) && csvLineItem[j]=='7110'){
                                    pbmObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j]);
                                  //  System.debug('pbmObj.Sales_Org__r -->'+pbmObj.Sales_Org__r);
                                    combinationKey += csvLineItem[j];
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Sales_Org_value_should_be_7110));   
                                    return null;
                                }
                            }
                            else if(j==1){
                                if(String.isNotBlank(csvLineItem[j]) && csvLineItem[j] == '20'){
                                    pbmObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j]);
                                    //System.debug('pbmObj.DistributionChannel__r -->'+pbmObj.DistributionChannel__r);
                                    combinationKey += csvLineItem[j];
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Distribution_Channel_Code_should_be_20));   
                                    return null;
                                }
                            }
                            else if(j==2){
                                //Updated by Rakesh Just to add division as 80
                                if(String.isNotBlank(csvLineItem[j]) && (csvLineItem[j]=='10' || csvLineItem[j]=='20' || csvLineItem[j]=='80') ){
                                    pbmObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j]);
                                    //System.debug('pbmObj.Division__r -->'+pbmObj.Division__r);
                                    combinationKey += csvLineItem[j];
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Division_Code_should_be_10_or_20));   
                                    return null;
                                }
                            }
                            else if(j==3){
                                if(String.isNotBlank(csvLineItem[j]) && csvLineItem[j]=='TR00'){
                                    pbmObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j]);
                                    //System.debug('pbmObj.DepotCode__r -->'+pbmObj.DepotCode__r);
                                    depotCode = csvLineItem[j];
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Depot_Code_should_be_TR00));   
                                    return null;
                                }
                            }
                            else if(j==4){
                                if(String.isNotBlank(csvLineItem[j]) && csvLineItem[j]=='TRY' ){
                                 	pbmObj.CurrencyIsoCode = csvLineItem[j];
                                    //System.debug('pbmObj.CurrencyIsoCode -->'+pbmObj.CurrencyIsoCode);
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Currency_is_required));   
                                    return null;
                                }
                            }
                            
                            else if(j==5){
                                if(String.isNotBlank(csvLineItem[j])){
                                    String code = csvLineItem[j];
                                    String leadingZeroes = '';
                                    for(integer k=1;k<=18-code.length();k++){
                                      leadingZeroes = '0'+leadingZeroes; 
                                    }
                                    code = leadingZeroes + code;
                                    //System.debug('SKUcode after for loop---> '+code);
									
                                    
                                   /* if(code.length()==6){
                                        code = '000000000000'+csvLineItem[j];
                                    }
                                    else if(code.length()==7){
                                        code = '00000000000'+csvLineItem[j];
                                    }
									*/
                                    combinationKey += code;
									
                                    pbmObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                    //System.debug('pbmObj.SKUCode__r -->'+pbmObj.SKUCode__r);
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.SKU_Code_cannot_be_blank));   
                                    return null;
                                }
                            }
                            else if(j==6){
                                if(String.isNotBlank(csvLineItem[j])){
                                    if(csvLineItem[j]=='CAN' ||csvLineItem[j]=='DR' ||csvLineItem[j]=='POU' ||csvLineItem[j]=='BAG' ||
                                      csvLineItem[j]=='L' ||csvLineItem[j]=='KG' ||csvLineItem[j]=='NOS' ||csvLineItem[j]=='EA'
                                      ||csvLineItem[j]=='BT' ||csvLineItem[j]=='CB'||csvLineItem[j]=='FLS'||csvLineItem[j]=='MNT'
                                       ||csvLineItem[j]=='PLT'){
                                    pbmObj.UOM__c =csvLineItem[j];
                                    //System.debug('pbmObj.UOM__c -->'+pbmObj.UOM__c);
                                    }
                                    else{
                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Invalid_UOM_value));
                                        return null;                                        
                                    }
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.UOM_cannot_be_blank));   
                                    return null;
                                }
                            }
                          
                            else if(j==7){
                                if(String.isNotBlank(csvLineItem[j])){
                                    if(csvLineItem[j].length()==1){
                                       csvLineItem[j] = '0' +csvLineItem[j]; 
                                    }
                                    if( csvLineItem[j]=='03' || csvLineItem[j]=='04' || csvLineItem[j]=='05' || csvLineItem[j]=='37'|| csvLineItem[j]=='36'){
                                    pbmObj.PG_CODE__r = new Price_Group_Master__c(PG_Code__c = csvLineItem[j]);
                                    System.debug('pbmObj.PG_CODE__r -->'+pbmObj.PG_CODE__r);
                                    pgCode = csvLineItem[j];
                                    }
                                    else{
                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.PG_CODE_cannot_be_blank));   
                                        return null;
                                    }
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.PG_CODE_cannot_be_blank));   
                                    return null;
                                }
                            }
                            
                            else if(j==8){
                                if(String.isNotBlank(csvLineItem[j])){
                                    if(Decimal.valueOf(csvLineItem[j])<0){
                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Min_Price_cannot_be_negative));
                                        return null;  
                                    }
                                    else{
                                    pbmObj.MinPrice__c = Decimal.valueOf(csvLineItem[j]);
                                    //System.debug('pbmObj.MinPrice__c -->'+pbmObj.MinPrice__c);
                                    }
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Min_Price_cannot_be_blank));   
                                    return null;
                                }
                            }
                            
                            else if(j==9){
                                 System.debug('Inside j=9 if -->'+csvLineItem[j]);
                                if(String.isNotBlank(csvLineItem[j]) && (csvLineItem[j].contains('-')!=false) ){
                                  	//System.debug('Inside csvLineItem[j] if -->'+csvLineItem[j]);
                                    //System.debug('Date.parse(csvLineItem[j])---> '+Date.parse(csvLineItem[j]));
                                    Date d = Date.valueOf(csvLineItem[j]) ;
                                    
                                    System.debug('Inside Start Date if -->'+d);
                                    startDate = DateTime.newInstance(d.year(),d.month(),d.day()).format('d-MM-YYYY');
                                    //System.debug(logginglevel.error, startDate);
                                    
                                    pbmObj.StartDate__c = d;
                                    //System.debug('pbmObj.StartDate__c -->'+pbmObj.StartDate__c);
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Start_Date_is_blank_or_not_in_YYYY_MM_DD_format));   
                                    return null;
                                }
                            }
                            else if(j==10){
                                if(String.isNotBlank(csvLineItem[j]) && (csvLineItem[j].contains('-')!=false) ){
                                    if(pbmObj.StartDate__c > Date.valueOf(csvLineItem[j])){
                                        //System.debug('pbmObj.StartDate__c < Date.valueOf(csvLineItem[j]) --> '+pbmObj.StartDate__c +' < '+ Date.valueOf(csvLineItem[j]));
                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Start_Date_cannot_be_greater_than_End_Date));   
                                        return null;
                                    }
                                    else{
                                    pbmObj.EndDate__c = Date.valueOf(csvLineItem[j]);
                                    //System.debug('pbmObj.EndDate__c -->'+pbmObj.EndDate__c);
                                    }
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.End_Date_is_blank_or_not_in_YYYY_MM_DD_format));   
                                    return null;
                                }
                            }
                            else if(j==11){
                                if(String.isNotBlank(csvLineItem[j])){
                                
                                    pbmObj.Batch__c = csvLineItem[j];
                                    //System.debug('pbmObj.Batch__c -->'+pbmObj.Batch__c);
                                    
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Batch_cannot_be_blank));   
                                    return null;
                                }
                            }
                            
                        }
                        }
                        else{
                            //System.debug('Apex messages--> Error in CSV data');                           
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Wrong_file_format));
                         	return null;
                        }
                        
                        compositeKey = depotCode + pgCode + combinationKey;
                        pbmObj.CompositeKey__c = compositeKey;
                        //System.debug('pbmObj.CompositeKey__c -->'+pbmObj.CompositeKey__c);
                        upsertPriceList.add(pbmObj);
                    }
                    
                    
                    catch(Exception ex){
                        errorCSVList.add(row+','+ex.getMessage());
                    }
                    
                }
            }
            /************ for pricebook upload end ***********/  
            
                        
            /************ for discount upload ***********/ 
            else{    //System.debug('Inside Discount Block');
                 for (Integer i = 1; i < csvData.size(); i++){
                    String row = '';
                    try{
                        List<String> csvLineItem = new List<String>();
                        PricebookDiscount__c sObj = new PricebookDiscount__c();
                        row = csvData[i];
                        
                        csvLineItem = csvData[i].split(',');
                        
                        String startDate = '';
                        String depotCode = '';
                        String pgCode = '';
   						String customerCode = '';
                        String combinationKey = '';
                        String compositeKey = '';
                        
                        
                        if(csvLineItem.size()==11){
                          //System.debug('Inside csvLineItem.size()--> '+csvLineItem.size());  
                        for(Integer j=0; j<csvLineItem.size(); j++){
                            
                            if(j==0){
                                if(String.isNotBlank(csvLineItem[j]) && csvLineItem[j]=='7110'){
                                    sObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = csvLineItem[j]);
                                    combinationKey += csvLineItem[j];
                                    //System.debug('sObj.Sales_Org__r'+sObj.Sales_Org__r);
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Sales_Org_value_should_be_7110));   
                                    return null;
                                }
                            }
                            else if(j==1){
                                if(String.isNotBlank(csvLineItem[j]) && csvLineItem[j] == '20'){
                                    sObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[j]);
                                    combinationKey += csvLineItem[j];
                                    //System.debug('sObj.Sales_Org__r'+sObj.DistributionChannel__r);
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Distribution_Channel_Code_should_be_20));   
                                    return null;
                                }
                            }
                            else if(j==2){
                                //Updated by Rakesh Just to add division as 80
                                if(String.isNotBlank(csvLineItem[j])&&(csvLineItem[j]=='10' || csvLineItem[j]=='20' || csvLineItem[j]=='80')){
                                    sObj.Division__r = new Division__c(Division_Code__c = csvLineItem[j]);
                                    combinationKey += csvLineItem[j];
                                    //System.debug('sObj.Division__r'+sObj.Division__r);
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Division_Code_should_be_10_or_20));   
                                    return null;
                                }
                            }
                            else if(j==3){
                                if(String.isNotBlank(csvLineItem[j]) && csvLineItem[j]=='TR00'){
                                    sObj.DepotCode__r = new Depot__c(Depot_Code__c = csvLineItem[j]);
                                    depotCode = csvLineItem[j];
                                    //System.debug('sObj.DepotCode__r'+sObj.DepotCode__r);
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Depot_Code_should_be_TR00));   
                                    return null;
                                }
                            }
                            else if(j==4){
                                if(String.isNotBlank(csvLineItem[j]) && csvLineItem[j]=='TRY'){
                                    sObj.CurrencyIsoCode = csvLineItem[j];
                                    //System.debug('sObj.CurrencyIsoCode'+sObj.CurrencyIsoCode);
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Currency_is_required));   
                                    return null;
                                }
                            }
                            
                            else if(j==5){
                                if(String.isNotBlank(csvLineItem[j])){
                                    String code = csvLineItem[j];                                 
                                    String leadingZeroes = '';
                                    for(integer k=1;k<=18-code.length();k++){
                                      leadingZeroes = '0'+leadingZeroes; 
                                    }
                                    code = leadingZeroes + code;
                                    //System.debug('SKUcode after for loop---> '+code);
                                    
                                    /*  if(code.length()==6){
                                        code = '000000000000'+csvLineItem[j];
                                    }
                                    else if(code.length()==7){
                                        code = '00000000000'+csvLineItem[j];
                                    }*/
                                    combinationKey += code;
                                    sObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                                    //System.debug('sObj.SKUCode__r'+sObj.SKUCode__r);
                                    
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.SKU_Code_cannot_be_blank));   
                                    return null;
                                }
                            }
                            else if(j==6){
                                String code = csvLineItem[j];
                                String leadingZeroes = '';
                                if(String.isNotBlank(csvLineItem[j])){
                                    for(integer l=0; l<10-code.length(); l++){
                                         leadingZeroes = '0'+leadingZeroes;
                                    }
                                    code = leadingZeroes + code;
                                    //System.debug('SKUcode after for loop---> '+code);
                                    
                                    sObj.DistributorCustomerCode__r =New Account(SAP_Code__c=code);
                                    customerCode = code;
                                    //System.debug('sObj.DistributorCustomerCode__c'+sObj.DistributorCustomerCode__r);
                                }
                                 else{
                                   // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Customer_code_is_required));   
                                    //return null;
                                }
                            }
                            else if(j==7){
                                if(String.isNotBlank(csvLineItem[j]) && (Decimal.valueOf(csvLineItem[j])>=0 && Decimal.valueOf(csvLineItem[j])<=100) ){
                                    sObj.Distributor_Discount__c = Decimal.valueOf(csvLineItem[j]);
                                    //System.debug('sObj.Distributor_Discount__c'+sObj.Distributor_Discount__c);
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Discount_cannot_be_negative));   
                                    return null;
                                }
                            }
                           else if(j==8){
                                if(String.isNotBlank(csvLineItem[j])){
                                    //System.debug('Inside--> '+csvLineItem[j]);
                                    if(csvLineItem[j].length()==1){
                                       csvLineItem[j] = '0' +csvLineItem[j]; 
                                    }
                                     if( csvLineItem[j]=='03'){
                                     sObj.PG_CODE__r = new Price_Group_Master__c(PG_Code__c = csvLineItem[j]);
                                    //System.debug('sObj.PG_CODE__r -->'+sObj.PG_CODE__r);
                                    pgCode = csvLineItem[j];
                                    }
                                    else{
                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.PG_CODE_cannot_be_blank));   
                                        return null;
                                    }                                   
                                                                      
                                }
                               else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.PG_CODE_cannot_be_blank));   
                                    return null;
                                }
                            }
                            
                            else if(j==9){
                                //System.debug('Inside j==8'+csvLineItem[j]);
                                if(String.isNotBlank(csvLineItem[j]) && (csvLineItem[j].contains('-')!=false)  ){
                                    Date d = Date.valueOf(csvLineItem[j]) ;
                                    startDate = DateTime.newInstance(d.year(),d.month(),d.day()).format('d-MM-YYYY');
                                    
                                    //System.debug(logginglevel.error, startDate);
                                    sObj.StartDate__c = d;
                                    //System.debug('sObj.StartDate__c'+sObj.StartDate__c);
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Start_Date_is_blank_or_not_in_YYYY_MM_DD_format));   
                                    return null;
                                }
                            }
                            else if(j==10){
                                if(String.isNotBlank(csvLineItem[j]) && (csvLineItem[j].contains('-')!=false) ){
                                    if(sObj.StartDate__c > Date.valueOf(csvLineItem[j])){
                                        //System.debug('pbmObj.StartDate__c < Date.valueOf(csvLineItem[j]) --> '+sObj.StartDate__c +' < '+ Date.valueOf(csvLineItem[j]));
                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Start_Date_cannot_be_greater_than_End_Date));   
                                        return null;
                                    }                                    
                                    else{
                                        sObj.EndDate__c = Date.valueOf(csvLineItem[j]);
                                    //System.debug('sObj.EndDate__c --> '+sObj.EndDate__c);
                                    }                                    
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.End_Date_is_blank_or_not_in_YYYY_MM_DD_format));   
                                    return null;
                                }
                            }
                        }
                        compositeKey = depotCode + customerCode + pgCode + combinationKey;
                        sObj.CompositeKey__c = compositeKey;
                        upsertDiscountList.add(sObj);
                        }
                        else{
                            //System.debug('Apex messages--> Error in CSV data');                           
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Wrong_file_format));
                         	return null;
                        }
                    }
                    
                    
                    catch(Exception ex){
                        errorCSVList.add(row+','+ex.getMessage());
                    }
                    
                }
            }
			/*********** for discount upload end************/
            //End of Logic
            
            Database.UpsertResult[] srList;
            Schema.SObjectField p = PriceBookMaster__c.Fields.CompositeKey__c;
            Schema.SObjectField d = PricebookDiscount__c.Fields.CompositeKey__c;
            System.debug('Before Upsert upsertPricebookList====> '+upsertPriceList);
            System.debug('Before Upsert upsertPricebookList size====> '+upsertPriceList.size());
            System.debug('Before Upsert upsertDiscountList====> '+upsertDiscountList);
           
            if(upsertPriceList.size()>0){
                Set<PriceBookMaster__c> setPBM = new Set<PriceBookMaster__c>();
                setPBM.addAll(upsertPriceList);
                system.debug('setPBM size --> ListPBM size = '+setPBM.size()+' --> '+upsertPriceList.size());               
                List<PriceBookMaster__c> listPBM = new List<PriceBookMaster__c>(setPBM);
                
                srList = Database.upsert(listPBM, p, false);
                 for(Integer i=0;i<srList.size();i++){
               if (!srList[i].isSuccess()){
                    Database.Error[] errs = srList[i].getErrors();
                    errorCSVList.add(csvData[i+1]+','+errs[0].getMessage());
                }
                else{
                    successCSVList.add(listPBM[i].get('Id')+','+csvData[i+1]);
                }
                }
                 system.debug('Error CSV Size ---> '+errorCSVList.size());
                 system.debug('Error CSV records ---> '+errorCSVList);
				sendEmail(String.join(successCSVList, '\r\n'), String.join(errorCSVList, '\r\n'), successCSVList.size(), errorCSVList.size());
                //Database.upsert(upsertPriceList, p, true);
                //insert upsertPricebookList;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,System.Label.Pricebook_uploaded_successfully));
                //System.debug('after Upsert'+upsertPriceList);
                System.debug('after Upsert upsertPricebookList size====> '+listPBM.size());
            }
            if(upsertDiscountList.size()>0){
                Set<PriceBookDiscount__c> setPBD = new Set<PriceBookDiscount__c>();
                setPBD.addAll(upsertDiscountList);
                system.debug('setPBD size --> ListPBD size = '+setPBD.size()+' --> '+upsertDiscountList.size());               
                List<PriceBookDiscount__c> listPBD = new List<PriceBookDiscount__c>(setPBD);
                
                srList = Database.upsert(listPBD, d, false);
                
                 for(Integer i=0;i<srList.size();i++){
               if (!srList[i].isSuccess()){
                    Database.Error[] errs = srList[i].getErrors();
                    errorCSVList.add(csvData[i+1]+','+errs[0].getMessage());
                }
                else{
                    successCSVList.add(listPBD[i].get('Id')+','+csvData[i+1]);
                }
                }
                 system.debug('Error CSV Size ---> '+errorCSVList.size());
                 system.debug('Error CSV records ---> '+errorCSVList);
				sendEmail(String.join(successCSVList, '\r\n'), String.join(errorCSVList, '\r\n'), successCSVList.size(), errorCSVList.size());
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,System.Label.Discount_uploaded_successfully));
                System.debug('after Upsert'+listPBD);
            }
            
            pageRef.setRedirect(true);
            
            return null; 
            
            
        }
        
        
        
        catch(Exception ex){
            System.debug('Outermost Catch');
            System.debug('Line No: '+ex.getLineNumber()+' Exception: '+ex.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,System.Label.Some_error_has_occurred+' : '+ex.getMessage())); 
            return null; 
        }   
                
    }
    
    
    //Method to Notify User with Success/Error Files after Upload
    public static void sendEmail(String successFile, String errorFile, Integer successCount, Integer errorCount){
        Messaging.EmailFileAttachment successAttach = new Messaging.EmailFileAttachment();
        successAttach.setContentType('application/csv');
        successAttach.setFileName('Success.csv');
        successAttach.setInline(false);
        successAttach.Body = Blob.valueOf(successFile);
        
        Messaging.EmailFileAttachment errorAttach = new Messaging.EmailFileAttachment();
        errorAttach.setContentType('application/csv');
        errorAttach.setFileName('Error.csv');
        errorAttach.setInline(false);
        errorAttach.Body = Blob.valueOf(errorFile);
        
        DateTime d = Date.Today() ;
        String dateString =  d.format('dd/MM/yyyy') ;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        mail.setToAddresses(new String[] { UserInfo.getUserEmail() });
        mail.setSubject('Pricebook Upload Status');
        //mail.setBccAddresses(new String[] { 'ganesh.chaurasia@skinternational.com','ketan.khatri@skinternational.com','amruta.pagar@skinternational.com','satkari@skinternational.com' });
        mail.setHtmlBody('Dear User,<br /><br />Please find attached files generated in SFDC while uploading the Pricebook Data<br /><br />Date: '+dateString+'<br /><br />No. of error records: '+errorCount+'<br /><br />Regards,<br/>UPL Salesforce Administrator<br />');
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { successAttach, errorAttach}); 
        
        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
}