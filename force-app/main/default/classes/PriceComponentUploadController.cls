/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This apex is called from lightning component - PriceComponentUploadLC
*
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Swapnil More   <swapnil.more@in.ibm.com>
* @modifiedBy     Swapnil More   <swapnil.more@in.ibm.com>
* @maintainedBy   Swapnil More   <swapnil.more@in.ibm.com>
* @version        1.0
* @created        2020-01-23
* @modified       2020-01-23
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
*                 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

public without sharing class PriceComponentUploadController {
    @AuraEnabled
    public static String getDocument(String FileName)
    {
        try{
        List<document> DocumentList = new List<document>(); 
        String Templatefile = '/servlet/servlet.FileDownload?file=';
        String newTemplatefile;
        DocumentList = [select Name from document where Name = :FileName];
        if(DocumentList.size()>0){
            newTemplatefile = Templatefile+DocumentList[0].Id;
            system.debug('checktemplate '+newTemplatefile);
        }
        return newTemplatefile;
        }
        catch (exception e){
            throw new AuraHandledException('Something went wrong: '+ e.getMessage()); 
            
        }
        
    }
    
    @AuraEnabled
    public static string passFile(String File, String Type){
        try{
        String[] csvFileLines = file.split('\n');
        List<string> inputvalues = new list<string>();
        UPL_Settings__c salesOrgDetails = UPL_Settings__c.getInstance();
        String SalesOrg = salesOrgDetails.SalesOrg__c;
        system.debug('salesOrg'+SalesOrg);
        
        
        if(Type == 'SDC'){
            set<string> RegionCode = new set<string>();
            List<ErrorWrapperSDM> liErrorWrapper = new List<ErrorWrapperSDM>(); 
            List<SuccessWrapperSDM> liSuccessWrapper = new List<SuccessWrapperSDM>();
            
            for (Integer j=1;j<csvFileLines.size();j++){
                inputvalues = csvFileLines[j].split(';');
                if(string.isNotBlank(inputvalues[0].trim())){
                    system.debug(string.isNotBlank(inputvalues[0].trim()));//Updated By Swapnil - Removing Sales District Name column
                    RegionCode.add(inputvalues[0]);
                }
            }
            system.debug('RegionCode'+RegionCode);
            Map<string,Region__c> mapRegion = new Map<string,Region__c>();
            for(Region__c R: [select id, RegionCode__c
                              from Region__c
                              where RegionCode__c in :RegionCode]){
                                  mapRegion.put(R.RegionCode__c,R);  
                                  
                              }
            system.debug('mapRegion'+mapRegion);
            list<Sales_District_Cost__c> LiSalesDistrict = new list<Sales_District_Cost__c>();
            for (Integer j=1;j<csvFileLines.size();j++){
                
                inputvalues = csvFileLines[j].split(';');
                system.debug('Code '+inputvalues[0]);
                system.debug('Value '+inputvalues[1]); 
                if(inputvalues[0]!=''&& inputvalues[0]!=null && 
                   inputvalues[1].trim()!='' && inputvalues[1].trim()!=null){
                       if(mapRegion.containsKey(inputvalues[0])){
                           Sales_District_Cost__c SDC = new Sales_District_Cost__c();                   
                           Region__c region = new Region__c(RegionCode__c = inputvalues[0]);
                           Sales_Org__c SO = new Sales_Org__c(Sales_Org_Code__c = SalesOrg);
                           SDC.Sales_Org__r = SO;
                           SDC.Combination_Key__c = inputvalues[0]+ SalesOrg; 
                           SDC.Region__r = region;
                           SDC.Region_Code__c = inputvalues[0];
                           if(inputvalues[1].trim().contains(',')){
                           SDC.Sales_District_Cost__c = decimal.valueOf(inputvalues[1].trim().replace(',','.'));    
                           }
                           else{
                           SDC.Sales_District_Cost__c = decimal.valueOf(inputvalues[1].trim());
                           }
                           LiSalesDistrict.add(SDC);
                           
                           SuccessWrapperSDM S = new SuccessWrapperSDM();
                           
                           S.SalesDistictCode = inputvalues[0];
                           S.SalesDisctrictPercentage = inputvalues[1].trim();
                           
                           
                           liSuccessWrapper.add(S);
                           system.debug('liSuccessWrapper'+liSuccessWrapper);
                       }
                       else{
                           ErrorWrapperSDM E = new ErrorWrapperSDM();
                           
                           E.SalesDistictCode = inputvalues[0];
                           E.SalesDisctrictPercentage = inputvalues[1].trim();
                           
                           E.Message = System.Label.Region_Code_is_not_Available;
                           liErrorWrapper.add(E);
                       }
                   }
                else{
                    if(inputvalues[0]== '' || inputvalues[0] == null ){
                        ErrorWrapperSDM E = new ErrorWrapperSDM();
                        
                        E.SalesDistictCode = inputvalues[0];
                        E.SalesDisctrictPercentage = inputvalues[1].trim();                        
                        E.Message = System.Label.Region_Code_is_Blank; 
                        liErrorWrapper.add(E);
                    }
                    if(inputvalues[1].trim()== '' || inputvalues[1].trim() == null ){
                        ErrorWrapperSDM E = new ErrorWrapperSDM();
                        
                        E.SalesDistictCode = inputvalues[0];
                        E.SalesDisctrictPercentage = inputvalues[1].trim();
                        
                        E.Message = System.Label.Sales_District_Percentage_is_Blank; 
                        liErrorWrapper.add(E);
                    }
                }
            }
            upsert LiSalesDistrict Combination_Key__c;
            system.debug('liErrorWrapper'+liErrorWrapper);
            string ErrorString = '';
            if(liErrorWrapper.size()>0){
                ErrorString = System.Label.Error_String+' \n'; //Sales District Code, Sales District Percentage, Message \n';
            }
            for (ErrorWrapperSDM ESDM:liErrorWrapper){
                ErrorString += '"'+ESDM.SalesDistictCode +'";"'+ESDM.SalesDisctrictPercentage+'";"'+ESDM.Message +'" \n';
                //ErrorString += ESDM.SalesDistict +','+ESDM.SalesDistictCode +','+ESDM.SalesDisctrictPercentage+ ','+ESDM.Message +' \n';//
            }
            system.debug('ErrorString'+ErrorString);
            string SuccessString = '';
            if(liSuccessWrapper.size()>0){
                SuccessString = System.Label.Success_String+' \n'; //'Sales District, Sales District Code, Sales District Percentage \n';
            }
            for (SuccessWrapperSDM SSDM:liSuccessWrapper){
                SuccessString += '"'+SSDM.SalesDistictCode +'";"'+SSDM.SalesDisctrictPercentage+'" \n';
                //SuccessString += SSDM.SalesDistict +','+SSDM.SalesDistictCode +','+SSDM.SalesDisctrictPercentage +' \n';//+ '\n'
            }
            system.debug('SuccessString'+SuccessString);
            //sending attachments
            if(liErrorWrapper.size() > 0){
                sendEmail(ErrorString,SuccessString);
            }
            
            if(liErrorWrapper.size() == 0){
                return ('success:' +liSuccessWrapper.size());
            }
            if(liSuccessWrapper.size() == 0){
                return ('NoSuccess'); 
            }
            if(liSuccessWrapper.size() > 0 && liErrorWrapper.size() > 0){
                return ('PartialSuccess:'+liSuccessWrapper.size());
            }
        }
        
        if(Type == 'MV'){
            set<string> RegionCode = new set<string>();
            list<Market_Variation__c> LiMV = new list<Market_Variation__c>(); 
            List<ErrorWrapperMV> liErrorWrapper = new List<ErrorWrapperMV>(); 
            List<SuccessWrapperMV> liSuccessWrapper = new List<SuccessWrapperMV>();
            
              for (Integer j=1;j<csvFileLines.size();j++){
                inputvalues = csvFileLines[j].split(';');
                if(string.isNotBlank(inputvalues[0].trim())){
                    system.debug(string.isNotBlank(inputvalues[0].trim()));
                    RegionCode.add(inputvalues[0]);
                }
            }
            system.debug('RegionCode'+RegionCode);
            Map<string,Region__c> mapRegion = new Map<string,Region__c>();
            for(Region__c R: [select id, RegionCode__c
                              from Region__c
                              where RegionCode__c in :RegionCode]){
                                  mapRegion.put(R.RegionCode__c,R);  
                                  
                              }
            system.debug('mapRegion'+mapRegion);
            
            
            for (Integer j=1;j<csvFileLines.size();j++){
                inputvalues = csvFileLines[j].split(';'); 
                if(inputvalues[0]!=''&& inputvalues[0]!=null &&
                   inputvalues[1]!='' && inputvalues[1]!=null &&
                  inputvalues[2].trim()!='' && inputvalues[2].trim()!=null ){
                       if(mapRegion.containsKey(inputvalues[0])){
                       Market_Variation__c MV = new Market_Variation__c();
                       Region__c region = new Region__c(RegionCode__c = inputvalues[0]);
                       MV.Sales_District__r = region;
                       MV.Region_Code__c = inputvalues[0];
                       MV.SKU_Brand__c = inputvalues[1];
                       if(inputvalues[2].trim().contains(',')){
                       MV.Market_Variation__c = decimal.valueOf(inputvalues[2].trim().replace(',','.'));    
                       }
                       else{
                       MV.Market_Variation__c = decimal.valueOf(inputvalues[2].trim());
                       }
                       
                       Sales_Org__c SO = new Sales_Org__c(Sales_Org_Code__c = SalesOrg);
                       MV.Sales_Org__r = SO;
                       MV.Combination_Key__c = inputvalues[0]+inputvalues[1]+ SalesOrg;
                       LiMV.add(MV);
                       
                       SuccessWrapperMV S = new SuccessWrapperMV();
                       
                       S.SalesDistictCode = inputvalues[0];
                       S.SKUBrand = inputvalues[1];
                       S.Variation = inputvalues[2].trim();                      
                       liSuccessWrapper.add(S);
                       }
                       else{
                        ErrorWrapperMV E = new ErrorWrapperMV();
                        
                        E.SalesDistictCode = inputvalues[0];
                        E.SKUBrand = inputvalues[1];
                        E.Variation = inputvalues[2].trim();
                        E.Message = System.Label.Sales_District_is_incorrect;//'Sales District is incorrect';
                        
                        liErrorWrapper.add(E);   
                       }
                   }
                else{
                    if(inputvalues[0]== '' || inputvalues[0] == null ){
                        ErrorWrapperMV E = new ErrorWrapperMV();
                        
                        E.SalesDistictCode = inputvalues[0];
                        E.SKUBrand = inputvalues[1];
                        E.Variation = inputvalues[2].trim();
                        E.Message = System.Label.Sales_District_Code_is_missing;//'Sales District is missing';
                        
                        liErrorWrapper.add(E);
                    }
                    if(inputvalues[1]== '' || inputvalues[1] == null ){
                        ErrorWrapperMV E = new ErrorWrapperMV();
                        
                        E.SalesDistictCode = inputvalues[0];
                        E.SKUBrand = inputvalues[1];
                        E.Variation = inputvalues[2].trim();
                        E.Message = System.Label.Brand_Value_is_missing;//'Sales District Code is missing';
                        
                        liErrorWrapper.add(E);
                    }
                    if(inputvalues[2].trim()== '' || inputvalues[2].trim() == null ){
                        ErrorWrapperMV E = new ErrorWrapperMV();
                        
                        E.SalesDistictCode = inputvalues[0];
                        E.SKUBrand = inputvalues[1];
                        E.Variation = inputvalues[2].trim();
                        E.Message = System.Label.Variation_Value_is_missing; //'Brand Value is missing';
                        
                        liErrorWrapper.add(E);
                    }
                    
                }
            }
            upsert LiMV Combination_Key__c;
            
            
            string ErrorString = '';
            if(liErrorWrapper.size()>0){
                ErrorString = System.Label.Error_String_MV+' \n'; //'Sales District, Sales District Code, Brand Name, Market Variation, Message \n';
            }
            for (ErrorWrapperMV ESDM:liErrorWrapper){
                ErrorString += '"'+ESDM.SalesDistictCode+'";"'+ESDM.SKUBrand +'";"'+ESDM.Variation  +'";"'+ESDM.Message +'" \n';
                //ErrorString += ESDM.SalesDistict +','+ESDM.SalesDistictCode +','+ESDM.SalesDisctrictPercentage+ ','+ESDM.Message +' \n';//
            }
            system.debug('ErrorString'+ErrorString);
            string SuccessString = '';
            if(liSuccessWrapper.size()>0){
                SuccessString =System.Label.Success_String_MV+' \n';// 'Sales District, Sales District Code, Brand Name, Market Variation \n';
            }
            for (SuccessWrapperMV SSDM:liSuccessWrapper){
                SuccessString += '"'+SSDM.SalesDistictCode+'";"'+SSDM.SKUBrand +'";"'+SSDM.Variation +'" \n';
                //SuccessString += SSDM.SalesDistict +','+SSDM.SalesDistictCode +','+SSDM.SalesDisctrictPercentage +' \n';//+ '\n'
            }
            system.debug('SuccessString'+SuccessString);
            //sending attachments
            if(liErrorWrapper.size() > 0){
                sendEmail(ErrorString,SuccessString);
            }
            
            if(liErrorWrapper.size() == 0){
                return ('success:'+liSuccessWrapper.size());
            }
            if(liSuccessWrapper.size() == 0){
                return ('NoSuccess'); 
            }
            if(liSuccessWrapper.size() > 0 && liErrorWrapper.size() > 0){
                return ('PartialSuccess:'+liSuccessWrapper.size());
            }
        }
        
        if(Type == 'DM'){
            list<Discount_Matrix__c> LiDM = new list<Discount_Matrix__c>(); 
            List<ErrorWrapperDM> liErrorWrapper = new List<ErrorWrapperDM>(); 
            List<SuccessWrapperDM> liSuccessWrapper = new List<SuccessWrapperDM>();
            
            for (Integer j=1;j<csvFileLines.size();j++){
                inputvalues = csvFileLines[j].split(';');
                System.debug('@@33DM'+inputvalues);
                if(inputvalues[0]!='' && inputvalues[0]!=null && 
                   inputvalues[1]!='' && inputvalues[1]!=null && 
                   inputvalues[2]!='' && inputvalues[2]!=null && 
                   inputvalues[3]!='' && inputvalues[3]!=null && 
                   inputvalues[4]!='' && inputvalues[4]!=null ){
                       Discount_Matrix__c DM = new Discount_Matrix__c();
                       DM.Brand_Name__c = inputvalues[0];
                       if(inputvalues[1].trim().contains(',')){
                       DM.Sales_Director__c = decimal.valueOf(inputvalues[1].trim().replace(',','.'));    
                       }
                       else{
                       DM.Sales_Director__c = decimal.valueOf(inputvalues[1].trim());    
                       }
                       if(inputvalues[2].trim().contains(',')){
                       DM.BU_Manager__c = decimal.valueOf(inputvalues[2].trim().replace(',','.'));    
                       }
                       else{
                       DM.BU_Manager__c = decimal.valueOf(inputvalues[2].trim());
                       }
                       if(inputvalues[3].trim().contains(',')){
                       DM.Sales_District_Manager__c = decimal.valueOf(inputvalues[3].trim().replace(',','.'));
                       }
                       else{
                       DM.Sales_District_Manager__c = decimal.valueOf(inputvalues[3].trim());    
                       }
                       if(inputvalues[4].trim().contains(',')){
                       DM.Sales_Person__c = decimal.valueOf(inputvalues[4].trim().replace(',','.'));    
                       }
                       else{
                       DM.Sales_Person__c = decimal.valueOf(inputvalues[4].trim());
                       }
                       DM.Combination_key__c = inputvalues[0]+ SalesOrg;
                       LiDM.add(DM);
                       
                       SuccessWrapperDM S = new SuccessWrapperDM();
                       S.BrandName  = inputvalues[0];
                       S.SalesDirector = inputvalues[1].trim();
                       
                       S.BUManager = inputvalues[2].trim();
                       S.SalesDistrictManager = inputvalues[3].trim();
                       S.SalesPerson = inputvalues[3].trim();                      
                       liSuccessWrapper.add(S);
                       
                       
                   }
                else{
                    if(inputvalues[0]== '' || inputvalues[0] == null ){
                        ErrorWrapperDM  E = new ErrorWrapperDM();
                        E.BrandName  = inputvalues[0];
                        E.SalesDirector = inputvalues[1].trim();
                       
                        E.BUManager = inputvalues[2].trim();
                        E.SalesDistrictManager = inputvalues[3].trim();
                        E.SalesPerson = inputvalues[4].trim();
                        E.Message = System.Label.Brand_Value_is_missing;//'Brand Value is missing';
                        liErrorWrapper.add(E);
                    }
                     if(inputvalues[1]== '' || inputvalues[1] == null ){
                        ErrorWrapperDM  E = new ErrorWrapperDM();
                        E.BrandName  = inputvalues[0];
                        E.SalesDirector = inputvalues[1].trim();
                       
                        E.BUManager = inputvalues[2].trim();
                        E.SalesDistrictManager = inputvalues[3].trim();
                        E.SalesPerson = inputvalues[4].trim();
                        E.Message = System.Label.Sales_Director_Percentage_is_missing;//'Sales Director Percentage is missing';
                        liErrorWrapper.add(E);
                    }
                    
                    if(inputvalues[2]== '' || inputvalues[2] == null ){
                        ErrorWrapperDM  E = new ErrorWrapperDM();
                        E.BrandName  = inputvalues[0];
                        E.SalesDirector = inputvalues[1].trim();
                       
                        E.BUManager = inputvalues[2].trim();
                        E.SalesDistrictManager = inputvalues[3].trim();
                        E.SalesPerson = inputvalues[4].trim();
                        E.Message =System.Label.BU_Manager_Percentage_is_missing; //'Bu Manager Percentage is missing';
                        liErrorWrapper.add(E);
                    }
                 if(inputvalues[3]== '' || inputvalues[3] == null ){
                        ErrorWrapperDM  E = new ErrorWrapperDM();
                        E.BrandName  = inputvalues[0];
                        E.SalesDirector = inputvalues[1].trim();
                       
                        E.BUManager = inputvalues[2].trim();
                        E.SalesDistrictManager = inputvalues[3].trim();
                        E.SalesPerson = inputvalues[4].trim();
                        E.Message = System.Label.Sales_District_Percentage_is_Blank;//'Sales District Percentage is missing';
                        liErrorWrapper.add(E);
                    }
                    if(inputvalues[4]== '' || inputvalues[4] == null ){
                        ErrorWrapperDM  E = new ErrorWrapperDM();
                        E.BrandName  = inputvalues[0];
                        E.SalesDirector = inputvalues[1].trim();
                       
                        E.BUManager = inputvalues[2].trim();
                        E.SalesDistrictManager = inputvalues[3].trim();
                        E.SalesPerson = inputvalues[4].trim();
                        E.Message = System.Label.Sales_Person_Percentage_is_missing;//'Sales Person Percentage is missing';
                        liErrorWrapper.add(E);
                    }
                }
                
            }
            upsert LiDM Combination_key__c;   
            
              string ErrorString = '';
            if(liErrorWrapper.size()>0){
                ErrorString = System.Label.Error_String_DM+' \n';   //'Brand Name, Sales Dir, BU Manager, Sales District Manager, Sales Person, Message \n';
            }
            for (ErrorWrapperDM ESDM:liErrorWrapper){
                ErrorString += '"'+ESDM.BrandName  +'";"'+ESDM.SalesDirector +'";"'+ESDM.BUManager +'";"'+ESDM.SalesDistrictManager +'";"'+ESDM.SalesPerson   +'","'+ESDM.Message +'" \n';
                //ErrorString += ESDM.SalesDistict +','+ESDM.SalesDistictCode +','+ESDM.SalesDisctrictPercentage+ ','+ESDM.Message +' \n';//
            }
            system.debug('ErrorString'+ErrorString);
            string SuccessString = '';
            if(liSuccessWrapper.size()>0){
                SuccessString = System.Label.Success_String_DM+' \n';//'Brand Name, Sales Dir, BU Manager, Sales District Manager, Sales Person \n';
            }
            for (SuccessWrapperDM ESDM:liSuccessWrapper){
                SuccessString += '"'+ESDM.BrandName  +'";"'+ESDM.SalesDirector +'";"'+ESDM.BUManager +'";"'+ESDM.SalesDistrictManager +'";"'+ESDM.SalesPerson   +'" \n';
                //SuccessString += SSDM.SalesDistict +','+SSDM.SalesDistictCode +','+SSDM.SalesDisctrictPercentage +' \n';//+ '\n'
            }
            system.debug('SuccessString'+SuccessString);
            //sending attachments
            if(liErrorWrapper.size() > 0){
                sendEmail(ErrorString,SuccessString);
            }
            
            if(liErrorWrapper.size() == 0){
                return ('success:'+liSuccessWrapper.size());
            }
            if(liSuccessWrapper.size() == 0){
                return ('NoSuccess'); 
            }
            if(liSuccessWrapper.size() > 0 && liErrorWrapper.size() > 0){
                return ('PartialSuccess:'+liSuccessWrapper.size());
            }
        }
        
        if(Type == 'CCF'){
            list<Customer_Conversion_factor__c> LiMV = new list<Customer_Conversion_factor__c>(); 
            List<ErrorWrapperCCF> liErrorWrapper = new List<ErrorWrapperCCF>(); 
            List<SuccessWrapperCCF> liSuccessWrapper = new List<SuccessWrapperCCF>();
            
            
            for (Integer j=1;j<csvFileLines.size();j++){
                inputvalues = csvFileLines[j].split(';');
                //  add below code for RITM0419822 as user requested aydd one column (Javed Ahmed) modified date-07-09-2022
                System.debug('@@33'+inputvalues[0]);
                if(inputvalues[0]!=''&& inputvalues[0]!=null && inputvalues[1]!=''&& inputvalues[1]!=null &&
                   inputvalues[2].trim()!='' && inputvalues[2].trim()!=null ){
                       Customer_Conversion_factor__c MV = new Customer_Conversion_factor__c();
                       MV.Brand_Name__c = inputvalues[0];
                       MV.Customer_Group__c = inputvalues[1];
                       if(inputvalues[2].trim().contains(',')){
                       MV.Conversion_Factor__c = decimal.valueOf(inputvalues[2].trim().replace(',','.'));
                       }
                       else{
                        MV.Conversion_Factor__c = decimal.valueOf(inputvalues[2].trim());    
                       }
                       Sales_Org__c SO = new Sales_Org__c(Sales_Org_Code__c = SalesOrg);
                       MV.Sales_Org__r = SO;
                       MV.Combination_Key__c = inputvalues[1] + SalesOrg + inputvalues[0];
                       LiMV.add(MV);
                       
                       SuccessWrapperCCF S = new SuccessWrapperCCF();
                       S.BrandName = inputvalues[0];
                       S.CustomerGroup = inputvalues[1];
                       S.ConversionFactor = inputvalues[2].trim();                      
                       liSuccessWrapper.add(S);
                   }
                else{
                    if(inputvalues[1]== '' || inputvalues[1] == null ){
                        ErrorWrapperCCF E = new ErrorWrapperCCF();
                        E.BrandName = inputvalues[0];
                        E.CustomerGroup = inputvalues[1];
                        E.ConversionFactor = inputvalues[2].trim();
                        E.Message = System.Label.Customer_Group_is_missing;//'Customer Group is missing';
                        
                        liErrorWrapper.add(E);
                    }
                    if(inputvalues[2].trim()== '' || inputvalues[2].trim() == null ){
                        ErrorWrapperCCF E = new ErrorWrapperCCF();
                        E.BrandName = inputvalues[0];
                        E.CustomerGroup = inputvalues[1];
                        E.ConversionFactor = inputvalues[2].trim();
                        E.Message = System.Label.Conversion_Factor_is_missing;//'Conversion Factor is missing';                       
                        
                        liErrorWrapper.add(E);
                    }
                }
            }
            // //  end  above code for RITM0419822 as user requested add one column (Javed Ahmed) modified date-07-09-2022
            upsert LiMV Combination_Key__c;
            
            
            string ErrorString = '';
            if(liErrorWrapper.size()>0){
                ErrorString = System.Label.Error_String_CCF+' \n'; // 'Customer Group,Conversion Factor, Message \n';
            }
            for (ErrorWrapperCCF ESDM:liErrorWrapper){
                ErrorString += '"'+ESDM.brandName+'"'+ESDM.CustomerGroup +'";"'+ESDM.ConversionFactor  +'";"'+ESDM.Message +'" \n';
                //ErrorString += ESDM.SalesDistict +','+ESDM.SalesDistictCode +','+ESDM.SalesDisctrictPercentage+ ','+ESDM.Message +' \n';//
            }
            system.debug('ErrorString'+ErrorString);
            string SuccessString = '';
            if(liSuccessWrapper.size()>0){
                SuccessString =  System.Label.Success_String_CCF+' \n';//'Customer Group ,Conversion Factor \n';
            }
            for (SuccessWrapperCCF SSDM:liSuccessWrapper){
                SuccessString += '"'+SSDM.CustomerGroup +'";"'+SSDM.ConversionFactor +'" \n';
                //SuccessString += SSDM.SalesDistict +','+SSDM.SalesDistictCode +','+SSDM.SalesDisctrictPercentage +' \n';//+ '\n'
            }
            system.debug('SuccessString'+SuccessString);
            //sending attachments
            if(liErrorWrapper.size() > 0){
                sendEmail(ErrorString,SuccessString);
            }
            
            if(liErrorWrapper.size() == 0){
                return ('success:'+liSuccessWrapper.size());
            }
            if(liSuccessWrapper.size() == 0){
                return ('NoSuccess'); 
            }
            if(liSuccessWrapper.size() > 0 && liErrorWrapper.size() > 0){
                return ('PartialSuccess:'+liSuccessWrapper.size());
            }
        }
        return System.Label.Success ; //'success';
        }
        catch(exception e){
            // add debug to check error for RITM0419822 as user requested for add one column Grz(Javed Ahmed) modified date-07-09-2022
            System.debug(e.getLineNumber() + '==>' + e.getCause() + '==>' + e.getMessage());
            throw new AuraHandledException('Something went wrong: '+ e.getMessage()); 
        }
    }
    
    public class ErrorWrapperSDM {
        
        @AuraEnabled
        public string SalesDistictCode {get;set;}
        @AuraEnabled
        public string SalesDisctrictPercentage {get;set;}        
        @AuraEnabled
        public string Message {get;set;}
    }
    
    public class SuccessWrapperSDM {
        
        @AuraEnabled
        public string SalesDistictCode {get;set;}
        @AuraEnabled
        public string SalesDisctrictPercentage {get;set;}
        
    }
    
    public class ErrorWrapperMV {
        
        @AuraEnabled
        public string SalesDistictCode {get;set;}
        @AuraEnabled
        public string SKUBrand {get;set;}
        @AuraEnabled
        public string Variation {get;set;}
        @AuraEnabled
        public string Message {get;set;}
    }
    
    public class SuccessWrapperMV {
        
        @AuraEnabled
        public string SalesDistictCode {get;set;}
        @AuraEnabled
        public string SKUBrand {get;set;}
        @AuraEnabled
        public string Variation {get;set;}
        
    }
    
    public class ErrorWrapperDM {
       // add one variable RITM0419822 as user requested for add one column Grz(Javed Ahmed) modified date-07-09-2022
        @AuraEnabled
        public string BrandName {get;set;}
        @AuraEnabled
        public string SalesDirector {get;set;}
        @AuraEnabled
        public string BUManager {get;set;}        
        @AuraEnabled
        public string SalesDistrictManager {get;set;}
        @AuraEnabled
        public string SalesPerson {get;set;}
        @AuraEnabled
        public string Message {get;set;}
    }
    
    public class SuccessWrapperDM {
        // add one variable RITM0419822 as user requested for add one column Grz(Javed Ahmed) modified date-07-09-2022
        @AuraEnabled
        public string BrandName {get;set;}
        @AuraEnabled
        public string SalesDirector {get;set;}
        @AuraEnabled
        public string BUManager {get;set;}        
        @AuraEnabled
        public string SalesDistrictManager {get;set;}
        @AuraEnabled
        public string SalesPerson {get;set;}
        
    }
    
    public class ErrorWrapperCCF {
        @AuraEnabled
        public string CustomerGroup {get;set;}
        @AuraEnabled
        public string ConversionFactor {get;set;} 
        @AuraEnabled
        public string Message {get;set;}
        @AuraEnabled
        public string BrandName {get;set;}
        
    }
    
    public class SuccessWrapperCCF {
        @AuraEnabled
        public string CustomerGroup {get;set;}
        @AuraEnabled
        public string ConversionFactor {get;set;}
        @AuraEnabled
        public string BrandName {get;set;}
        
    }
    
    public static void sendEmail(string ErrorString, string SuccessString){
        try{
        String loggedInUser= UserInfo.getUserEmail();
        List<Messaging.EmailFileAttachment> licsvAttch = new List<Messaging.EmailFileAttachment>();
        //Error
        if(ErrorString !=''){
            Messaging.EmailFileAttachment csvAttchError = new Messaging.EmailFileAttachment();
            blob csvBlobError = Blob.valueOf(ErrorString);
            string csvNameError= System.Label.Error+'.csv';
            csvAttchError.setFileName(csvNameError);
            csvAttchError.setBody(csvBlobError);
            
            licsvAttch.add(csvAttchError);
        }
        //Success
        if(SuccessString != ''){
            Messaging.EmailFileAttachment csvAttchSuccess = new Messaging.EmailFileAttachment();
            blob csvBlobSuccess = Blob.valueOf(SuccessString);
            string csvNameSuccess= System.Label.Success+'.csv';
            csvAttchSuccess.setFileName(csvNameSuccess);
            csvAttchSuccess.setBody(csvBlobSuccess);
            
            licsvAttch.add(csvAttchSuccess);
        }
        
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String[] toAddresses = new string[] {loggedInUser};
        String subject =system.Label.Result;//'Result'
        email.setSubject(subject);
        email.setToAddresses( toAddresses );
        email.setPlainTextBody(Label.SIC_email_Text);
        email.setFileAttachments(licsvAttch);
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        
        
    }
       catch(Exception e){
        system.debug('Exception'+e);
    }
    }
    
    
    
}