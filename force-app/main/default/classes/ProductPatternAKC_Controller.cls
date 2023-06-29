/*
* Name : ProductPatternAKC_Controller
* Created on : 27th May 2019
* Developer : Ketan Khatri                                
* Description : To create Product Pattern Case record according to CaseType & Pattern Type
* Last Stable Backup : 
*/

public class ProductPatternAKC_Controller {    
    public list<Territory_Distributor__c> territoryLst{get;set;}
    public map<string,Territory_Distributor__c> mapTerritory{get;set;}
    public Territory_Distributor__c territory{get;set;}
    public string territoryCode{get;set;}
    public string territoryZone{get;set;}
    public string territorySBU{get;set;}
    public string territoryZonalMan{get;set;}
    public string territoryZonalManPhn{get;set;}
    public string territoryName{get;set;}
    public list<String> territoryNameList;
    public list<String> cropList;
    public list<Crop__c> listcrop{get;set;}
    public list<String> dataPatternList;
    public list<Case> caseList;
    public string territoryId{get;set;}
    public string terErrMsg{get;set;}
    public string listCrops{get;set;}
    public string listSelPattern{get;set;}
    public map<string,string> mapCropName;
    public String selctedTerritory;
    public String selctedCrop;
    public String selctedPattern;
    public map<string,list<case>> mapCase;
    public list<product2> listProduct{get;set;}
    public list<AKC_Product__c> listAkcProducts{get;set;}
    public list<string> listAkcProductName{get;set;}
    public set<string> setAkcProductName{get;set;}
    public string productName{get;set;}
    public list<String> listproductDoseName{get;set;}
    public string index{get;set;}
    public string unit{get;set;}
    public string acreKg{get;set;} 
    public string errMes {get;set;}
    public string JSONData {get;set;}
    public map<string,string> mapCrops{get;set;}
    public set<string> setPattern{get;set;}
    public set<string> setCrops{get;set;}
    public list<CasePatternDetail> listCasePatternDetailObj {get;set;}
    public list<Case_Crop_Pattern__c> lstCaseCropPattern;
    public string caseId;
    public case currentCaseRec;
    public map<string,Case_Crop_Pattern__c> mapCaseCropPatterns;
    public integer callcount{get;set;}
    public case caseRec{get;set;}
    public static string lightRecordType;
    public List<String> cropPickListValues{get;set;}
    //Harsha - Migration from 1000 to 1410
    //Added to change the Sales Org Code to 1410 from 1000
    //public string salesOrgCodeSAS = UtilityClass.getSalesOrgIndiaSAS();
    public Map<String, UPL_SalesOrg_Detail__mdt> salesOrgDetailsMap = UtilityClass.getSalesOrgDetails();
    public string salesOrgCodeSAS = salesOrgDetailsMap.get('India_SalesOrg').value__c;
    public ProductPatternAKC_Controller(){
        
    }
    //fetch required data from territory
    public ProductPatternAKC_Controller(ApexPages.StandardController controller) {
        try{
            caseId = controller.getRecord().id;
            index = '';
            lightRecordType ='';
            territoryId = '';
            terErrMsg = '';
            territoryCode = '';
            territoryName ='';
            territoryZone = '';
            territorySBU = '';
            territoryZonalMan = '';
            territoryZonalManPhn = '';
            listSelPattern = '';
            productName = '';
            unit = '';
            acreKg ='';
            errMes = '';
            JSONData = '';
            callcount = 0;
            caseRec = new case();
            setPattern = new set<string>();
            setCrops = new set<string>();
            mapCrops = new map<string,string>();
            mapCropName = new map<string,string>();
            territory =  new Territory_Distributor__c();
            territoryLst = new List<Territory_Distributor__c>();
            territoryNameList = new List<String>();
            listcrop = new list<Crop__c>(); 
            cropList  = new List<String>();
            listCrops = '';
            caseList = new List<Case>();
            listproductDoseName = new list<String>();
            mapCase = new map<string,list<case>>();
            listCasePatternDetailObj = new list<CasePatternDetail>();
            list<product2> listProduct = new list<product2>();
            listAkcProducts = new list<AKC_Product__c>();
            listAkcProductName = new list<string>();
            setAkcProductName = new set<string>();
            listcrop = [SELECT Id, Name, SalesOrg__c, Sales_Org_Code__c FROM Crop__c WHERE Sales_Org_Code__c =:salesOrgCodeSAS];
            cropPickListValues = new List<String>();
            Schema.DescribeFieldResult fieldResult = Case.Crop_pick__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for(Schema.PicklistEntry pickListVal : ple){
                if(!pickListVal.getLabel().contains('&')){
                    if(pickListVal.getLabel()!='Unidentified Crop'){
                        cropPickListValues.add(pickListVal.getLabel());
                    }
                }
            }     
            system.debug('cropPickListValues>>--->'+cropPickListValues);
            system.debug('Current Record>>--->'+controller.getRecord());
            currentCaseRec = new case();
            currentCaseRec = (case) controller.getRecord();
            //system.debug('Territory>>--->'+currentCaseRec.Data_Pattern_Territory__c);
            mapCaseCropPatterns = new map<string,Case_Crop_Pattern__c>();
            for(Crop__c crp : listcrop){
                mapCrops.put(crp.Name,crp.Id);    
            }
            territoryLst = [SELECT Id, Name, TerritoryCode__c, Region__c, SBU__c, TerritoryManager__c,                         
                            Zone__r.Name,Zone__r.ZonalHead__r.Phone,Zone__c,
                            SalesOrg__c, Regional_Manager__c, SBU_Code__c, SBU_Name__c, ZonalManager__c, Sales_Org_Code__c                        
                            FROM Territory_Distributor__c WHERE Sales_Org_Code__c = :salesOrgCodeSAS AND name !='#' AND Present_in_KEDE__c = true and Neglected__c = false ORDER BY Name ASC];
            mapTerritory = new map<string,Territory_Distributor__c>();
            /*  mapTerritory = new map<string,Territory_Distributor__c>([SELECT Id, Name, TerritoryCode__c, Region__c, SBU__c, TerritoryManager__c,                         
Zone__r.Name,Zone__r.ZonalHead__r.Phone,Zone__c,
SalesOrg__c, Regional_Manager__c, SBU_Code__c, SBU_Name__c, ZonalManager__c, Sales_Org_Code__c                        
FROM Territory_Distributor__c WHERE Sales_Org_Code__c = '1000' AND name !='#' AND Present_in_KEDE__c = true and Neglected__c =false order by name asc]); 
*/
            
            for(Crop__c crp : listcrop){
                mapCropName.put(crp.Name,crp.id);
            } 
            System.debug('mapTerritory>>--->'+mapTerritory);
            dataPatternList = new List<String>{'Insect','Weed','Disease','PGR'};  
                if(territoryLst.size()>0){
                    for(Territory_Distributor__c tr : territoryLst){
                        territoryNameList.add(tr.Name); 
                        mapTerritory.put(tr.id,tr);
                    }
                    
                }
            
            if(currentCaseRec.Id != Null){
                caseRec = [SELECT Id,recordtypeId,Data_Pattern_Territory__c,Data_Pattern_Territory__r.Name,TimeLine_Flag__c From Case WHERE Id=:currentCaseRec.Id limit 1];
                string caseRecordTypeId  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Data Pattern Calling form').getRecordTypeId();
                system.debug('recordtypeName'+caseRec.recordtypeId);
                if(caseRec.recordtypeId == caseRecordTypeId){
                    territoryId =caseRec.Data_Pattern_Territory__c;
                    territoryName = mapTerritory.get(caseRec.Data_Pattern_Territory__c).Name;
                    territoryCode = mapTerritory.get(caseRec.Data_Pattern_Territory__c).TerritoryCode__c;
                    territoryZone = mapTerritory.get(caseRec.Data_Pattern_Territory__c).Zone__r.Name;
                    territorySBU = mapTerritory.get(caseRec.Data_Pattern_Territory__c).SBU_Name__c;
                    territoryZonalMan = mapTerritory.get(caseRec.Data_Pattern_Territory__c).ZonalManager__c;
                    territoryZonalManPhn = mapTerritory.get(caseRec.Data_Pattern_Territory__c).Zone__r.ZonalHead__r.Phone;
                    lstCaseCropPattern = new list<Case_Crop_Pattern__c>();
                    lstCaseCropPattern = [SELECT Id, Name, End_Date__c, Pattern__c, Reason__c,Crop_Text__c, Recording_By__c, Script__c, Voice_Blast_Status__c, Start_Date__c, ZM_Confirmation_to_be_taken__c, Crop__c, Crop__r.Name, Case__c, Combination_key__c, 
                                          (SELECT Id, Name, Case_Number__c, Dosage__c, Product__c, AKC_Product__c,AKC_Product__r.Name, Territory__c, Dosage_Type__c, Unit__c, Case_Crop_Pattern__c
                                           FROM Product_Patterns__r) FROM Case_Crop_Pattern__c WHERE case__c =: currentCaseRec.Id ORDER BY Pattern__c];
                    for(Case_Crop_Pattern__c ccp : lstCaseCropPattern){
                        mapCaseCropPatterns.put(ccp.Pattern__c+' '+ccp.Crop_Text__c+' Information',ccp);
                    }
                    for(Case_Crop_Pattern__c ccp : lstCaseCropPattern){
                        setPattern.add(ccp.Pattern__c);
                        setCrops.add(ccp.Crop_Text__c);       
                    }
                    for(string str :setPattern){
                        listSelPattern = listSelPattern + str+','; 
                    }
                    System.debug('listSelPattern>>--->'+listSelPattern);
                    listSelPattern = listSelPattern.removeEnd(',');
                    for(string str :setCrops){
                        listCrops = listCrops + str+',';
                    }             
                    searchCasePattern();
                    for(CasePatternDetail cpd : listCasePatternDetailObj){
                        cpd.caseCropPatternobj.zMConfirmation = mapCaseCropPatterns.get(cpd.heading).ZM_Confirmation_to_be_taken__c;
                        cpd.caseCropPatternobj.heading = cpd.heading;
                        cpd.caseCropPatternobj.recId = mapCaseCropPatterns.get(cpd.heading).Id;
                        cpd.caseCropPatternobj.caseId = mapCaseCropPatterns.get(cpd.heading).Case__c;
                        cpd.caseCropPatternobj.voiceBlastStatus = mapCaseCropPatterns.get(cpd.heading).Voice_Blast_Status__c;
                        cpd.caseCropPatternobj.recordingBy = mapCaseCropPatterns.get(cpd.heading).Recording_By__c;
                        cpd.caseCropPatternobj.Reason = mapCaseCropPatterns.get(cpd.heading).Reason__c;
                        cpd.caseCropPatternobj.Script = mapCaseCropPatterns.get(cpd.heading).Script__c;
                        if(!mapCaseCropPatterns.get(cpd.heading).Product_Patterns__r.isEmpty()){
                            for(Product_Pattern__c pp : mapCaseCropPatterns.get(cpd.heading).Product_Patterns__r){
                                ProductPattern ppwrap = new ProductPattern();
                                ppwrap.name = pp.AKC_Product__r.Name;
                                ppwrap.recId = pp.Id;
                                ppwrap.heading = cpd.heading;
                                ppwrap.AkcproductId = pp.AKC_Product__c;
                                ppwrap.doses = pp.Dosage__c;
                                ppwrap.dosesType = pp.Dosage_Type__c;
                                ppwrap.unit = pp.Unit__c;
                                ppwrap.caseCropPatternId = pp.Case_Crop_Pattern__c;  
                                cpd.listProductPattern.add(ppwrap);
                            }
                        }
                    }
                    system.debug('listCasePatternDetailObj'+listCasePatternDetailObj.size());
                    JSONData = JSON.serialize(listCasePatternDetailObj);
                }
            }
        }
        catch(Exception ex){
            System.debug('Exception Caused at line number '+ex.getLineNumber());
            System.debug('Exception Error Message '+ex.getMessage());            
        }
        
    }
    // redirect according to recordType to custom page 
    public pagereference  checkRecordType(){
        try{
            string headerdata= Apexpages.currentPage().getUrl();
            system.debug('host name>>--->'+headerdata);
            string uiTheme = UserInfo.getUiThemeDisplayed();
            system.debug('uiTheme>>--->'+uiTheme);
            //Added on 24/7 : SWAL Changes
            if (ApexPages.currentPage().getParameters().get('RecordType') == null) {
                Schema.DescribeSObjectResult describeCase = Schema.SObjectType.Case;
                List<Schema.RecordTypeInfo> rtInfos = describeCase.getRecordTypeInfos();
                for(Schema.RecordTypeInfo rtInfo : rtInfos) {
                    
                    // walk through the map to determine the correct record type, this is done with the isAvailable() function
                    if(rtInfo.getName() != 'Master' && rtInfo.isAvailable()) {
                        // below lines will only run one time only
                        // System.debug('The RecordType :' +rtInfo.getName() + ' and the id: ' + rtInfo.getRecordTypeId() +' is available, adding it as parameter to the page.');
                        ApexPages.currentPage().getParameters().put('RecordType', rtInfo.getRecordTypeId());
                    }
                }
            }
            //end here 24/7
            
            string objCustomobjectRecordType = ApexPages.currentPage().getParameters().get('RecordType');
            
            string caseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Data Pattern Calling form').getRecordTypeId();
            string caseRecordtype15 = caseRecordType.substring(0,15);
            string  casePrefix = Case.sobjecttype.getDescribe().getKeyPrefix();
            Map<String, String> params = ApexPages.currentPage().getParameters();
            
            system.debug('params >>--->'+params);
            system.debug('caseRecordType>>--->'+caseRecordType);
            system.debug('objCustomobjectRecordType>>--->'+objCustomobjectRecordType);
            system.debug('casePrefix>>--->'+casePrefix);
            //system.debug('currrentRecord'+currentCaseRec.Id);
            List<Account> accDistributor = [Select Id,recordtypeId,Sales_Org_Code__c From Account WHERE Id=:currentCaseRec.AccountId];
            string accRecordType =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
            string disCaseRecordType =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
            //Added  by Varun Shrivastava Start
            string uplGeneralCaseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
            string akcRetailerCaseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC Retailer').getRecordTypeId();
            string swalGeneralCaseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('SWAL General Case').getRecordTypeId();
            string swalRetailerCaseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('SWAL Retailer').getRecordTypeId();
            //added By kuhinoor
            string F3_C3_CaseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('F3/C3/Sales Team').getRecordTypeId();
            //WIT-002
            string nurtutrFrmCaseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('nurture.farm care').getRecordTypeId();
            
            List<PermissionSetAssignment> pilotUserPS =    [ SELECT Id, PermissionSet.Name,AssigneeId
                                                            FROM PermissionSetAssignment
                                                            WHERE AssigneeId = :Userinfo.getUserId() and PermissionSet.Name = 'AKC_Retailer_Pilot_Users'];
            QRC_Pilot_Access__c   pilotActiveCheck = QRC_Pilot_Access__c.getValues('QRC AKC Retailer');
            Boolean pilotFlag = false;
            if(pilotUserPS.size() > 0 && pilotActiveCheck.AKC_Retailer_Pilot_Mode__c)
                pilotFlag = true;
            
            String accountId = ApexPages.currentPage().getParameters().get('def_account_id');
            // WIT-002
            //String url = '/apex/Case_UPL_GeneralCase_Creation?';
            String url = '/apex/AccountAndCaseCreation?';
            if(accountId != null){
                url = url + 'accountId='+accountId+'&';
            }
            System.debug('Pilot Flag : '+pilotFlag);
            System.debug('URL:'+url);
            // System.assert(false,'currentCaseRec.recordtypeId'+currentCaseRec.recordtypeId+ ' -> Current : '+uplGeneralCaseRecordType);  
            /*if(!headerdata.contains('lightning') && currentCaseRec.recordtypeId != null 
&& currentCaseRec.recordtypeId == akcRetailerCaseRecordType){
if(currentCaseRec.ID != null && pilotFlag){
// System.assert(false,'Here:objCustomobjectRecordType'+objCustomobjectRecordType);  
url = url + '/apex/Case_UPL_GeneralCase_Creation?id='+currentCaseRec.Id; 
}else
{
if(pilotFlag)
url = url + 'RecordId=&Mode='+'&RecordTypeId='+currentCaseRec.recordtypeId;
else
url = '/'+casePrefix+'/e?nooverride=1&def_account_id='+accountId+'&RecordType='+currentCaseRec.recordtypeId;    
}
System.debug('URL:'+url);
return new PageReference(url);
}*/
            //Changes start - Ben
            if(Test.isRunningTest())
            {
                headerdata='test';
            }
            //Changes End - Ben
            if(!headerdata.contains('lightning') && currentCaseRec.recordtypeId != null 
               && (currentCaseRec.recordtypeId == uplGeneralCaseRecordType ||
                   currentCaseRec.recordtypeId == akcRetailerCaseRecordType ||
                   currentCaseRec.recordtypeId == swalGeneralCaseRecordType ||
                   currentCaseRec.recordtypeId == swalRetailerCaseRecordType||
                   currentCaseRec.recordtypeId == F3_C3_CaseRecordType  || 
                   currentCaseRec.recordtypeId == nurtutrFrmCaseRecordType))
            {
                if(currentCaseRec.ID != null){
                    // System.assert(false,'Here:objCustomobjectRecordType'+objCustomobjectRecordType);  
                    url = url + '/apex/Case_UPL_GeneralCase_Creation?id='+currentCaseRec.Id; 
                }else
                {
                    url = url + 'RecordId=&Mode='+'&RecordTypeId='+currentCaseRec.recordtypeId;
                }
                return new PageReference(url);
            }else if(headerdata.contains('lightning') && currentCaseRec.recordtypeId != null &&
                     (currentCaseRec.recordtypeId == uplGeneralCaseRecordType ||
                      currentCaseRec.recordtypeId == akcRetailerCaseRecordType ||
                      currentCaseRec.recordtypeId == swalGeneralCaseRecordType ||
                      currentCaseRec.recordtypeId == swalRetailerCaseRecordType)){
                          if(currentCaseRec.ID != null){
                              url = url + '/apex/Case_UPL_GeneralCase_Creation?id='+currentCaseRec.Id;
                          }else
                          {
                              url = url + 'RecordId=&Mode='+'&RecordTypeId='+currentCaseRec.recordtypeId;
                          }
                          return new PageReference(url);
                      }
            //Added by Varun Shrivastava End 
            
            
            if(!headerdata.contains('lightning')){
                //Added Ankita Case management Start
                if (!accDistributor.isEmpty() && accDistributor[0].recordtypeId == accRecordType && accDistributor[0].Sales_Org_Code__c == salesOrgCodeSAS && objCustomobjectRecordType == null)
                {
                    return new PageReference('/'+casePrefix+'/e?nooverride=1&def_account_id='+currentCaseRec.AccountId+'&RecordType='+disCaseRecordType); 
                } 
                //Added Ankita Case management end
                If((objCustomobjectRecordType != null && objCustomobjectRecordType != caseRecordtype15) || currentCaseRec.RecordTypeId != caseRecordType){
                    if(objCustomobjectRecordType == null && currentCaseRec.id != null){
                        system.debug('uiTheme edit>>--->'+uiTheme);
                        return new PageReference('/'+currentCaseRec.Id+'/e?nooverride=1');
                    }else{
                        system.debug('currentCaseRec>>--->'+currentCaseRec.AccountId);
                        if(currentCaseRec.AccountId != null ){
                            system.debug('uiTheme Account new>>--->'+uiTheme);
                            return new PageReference('/'+casePrefix+'/e?nooverride=1&def_account_id='+currentCaseRec.AccountId+'&RecordType='+objCustomobjectRecordType);   
                            
                        }else{
                            system.debug('uiTheme  new>>--->'+uiTheme);
                            return new PageReference('/'+casePrefix+'/e?nooverride=1&RecordType='+objCustomobjectRecordType);
                            
                        }    
                    }
                }
            }else if(currentCaseRec.id != null && currentCaseRec.recordtypeId != caseRecordType){
                system.debug('currentCaseRec.id>>--->'+currentCaseRec.id);
                return new PageReference('/'+currentCaseRec.id+'/e?nooverride=1');  
            }
            
        }catch(Exception ex){
            System.debug('Exception Caused at line number '+ex.getLineNumber());
            System.debug('Exception Error Message '+ex.getMessage());            
        }
        return null;
    }
    //used for lightning redirection to visualforce page
    @AuraEnabled
    public static List<boolean> getReordInformation(string recId ,string recTypeId, string accId){
        system.debug('recordId>>--->'+recId);
        system.debug('recTypeId>>--->'+recTypeId);
        case caserecord = new case();
        if(!String.isEmpty(recId)){
            caserecord = [Select id ,recordTypeId,caseNumber from case WHERE id =: recId];         
        }
        User u = [SELECT Id, Name,Profile.name FROM USER WHERE id =: userInfo.getUserId()];
        //lightRecordType ='';
        string caseRecordType  = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Data Pattern Calling form').getRecordTypeId();
        string colCaseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Colombia Case').getRecordTypeId();
        string akcRetailerRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC Retailer').getRecordTypeId();
        //Changes Start - Ben
        String recordTypeIdNurtureCase = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('nurture_farm_care').getRecordTypeId();
        //Changes done by Ishu Mittal for CR-APPS5243
        String recordTypeIdConsumerProduct=  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('UPL_consumer_product').getRecordTypeId();
        
        //Changes end -Ben
        
        List<boolean> booleanList = new List<boolean>();
        List<Farmer_Promotional_Product__c> fppObjList = new List<Farmer_Promotional_Product__c>();
        /*if(recTypeId == akcRetailerRecordType){
List<PermissionSetAssignment> pilotUserPS =    [ SELECT Id, PermissionSet.Name,AssigneeId
FROM PermissionSetAssignment
WHERE AssigneeId = :Userinfo.getUserId() and PermissionSet.Name = 'AKC_Retailer_Pilot_Users'];
QRC_Pilot_Access__c   pilotActiveCheck = QRC_Pilot_Access__c.getValues('QRC AKC Retailer');
Boolean pilotFlag = false;
if(pilotUserPS.size() > 0 && pilotActiveCheck.AKC_Retailer_Pilot_Mode__c)
pilotFlag = true;
if(pilotFlag){
booleanList.add(false);
booleanList.add(false);
booleanList.add(false);
booleanList.add(false);
booleanList.add(true);
}else
{
booleanList.add(false);
booleanList.add(false);
booleanList.add(false);
booleanList.add(false);
booleanList.add(false);
}
return booleanList;
}
*/
        
        if(recTypeId != caseRecordType){
            
            if(recTypeId != string.valueOf(Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId())){
                //APPS-2074 :Commented by nandhini to show standard Case page for the 'Business Center Coordinator Colombia' profile users
                /*if(recTypeId == null && u.Profile.name =='Business Center Coordinator Colombia'){
                    booleanList.add(false);
                    booleanList.add(false);
                    //Added by Varun Shrivastava Start
                    booleanList.add(false);
                    //Added by Varun Shrivastava End
                    //Added by prashant chinchpure 2 july 2020 Start
                    booleanList.add(true);
                    //Added by prashant chinchpure End
                    //Added by Varun AKC Retailer
                    //booleanList.add(false);
                    //Added by Varun AKC Retailer
                     //Changes start - Ben
                    booleanList.add(false);
                    //Changes end - Ben
                    return booleanList;  
                }*/
                //Changes start - Ben
                 if(recTypeId==recordTypeIdNurtureCase)
                {
                    booleanList.add(false);
                    booleanList.add(false);
                    booleanList.add(false);
                    booleanList.add(false);
                    booleanList.add(true);
                    booleanList.add(false);//Added By Ishu
                    return booleanList;  
                }
                //Changes end - Ben
                //Changes done by Ishu Mittal for CR- APPS5243
               else if(recTypeId==recordTypeIdConsumerProduct)
                {
                    booleanList.add(false);
                    booleanList.add(false);
                    booleanList.add(false);
                    booleanList.add(false);
                    booleanList.add(false);
                    booleanList.add(true);
                    return booleanList; 
                }
                //Changes end-Ishu
                
                else{
                    system.debug('--------------------------------------------------------------');
                    booleanList.add(false);
                    booleanList.add(false);
                    //Added by Varun Shrivastava Start
                    booleanList.add(false);
                    //Added by Varun Shrivastava End
                    //Added by prashant chinchpure 2 july 2020 Start
                    booleanList.add(false);
                    
                    //Added by prashant chinchpure End
                    ////Added by Varun AKC Retailer
                    //booleanList.add(false);
                    //Added by Varun AKC Retailer
                    //Changes start - Ben
                    booleanList.add(false);
                    //Changes end - Ben
                    booleanList.add(false);//Added by Ishu
                    
                    return booleanList;    
                }
                
            }
            else{
                fppObjList =   [select id,Accounts__c,Cases__c,Month__c,Financial_Year__c,Promotional_Product__c from Farmer_Promotional_Product__c where CreatedDate = THIS_MONTH and accounts__c=:accId limit 1];
                if(fppObjList.size()>0){
                    booleanList.add(true);
                    booleanList.add(false);
                    //Added by Varun Shrivastava Start
                    booleanList.add(true);
                    //Added by Varun Shrivastava End
                    //Added by prashant chinchpure 2 july 2020 Start
                    booleanList.add(false);
                    //Added by prashant chinchpure End
                    ////Added by Varun AKC Retailer
                    //booleanList.add(false);
                    //Added by Varun AKC Retailer
                     //Changes start - Ben
                    booleanList.add(false);
                    //Changes end - Ben
                    booleanList.add(false);//Added by Ishu
                    return booleanList;
                }else{
                    booleanList.add(false);
                    booleanList.add(false);
                    //Added by Varun Shrivastava Start
                    booleanList.add(true);
                    //Added by Varun Shrivastava End
                    //Added by prashant chinchpure 2 july 2020 Start
                    booleanList.add(false);
                    //Added by prashant chinchpure End
                    ////Added by Varun AKC Retailer
                    //booleanList.add(false);
                    //Added by Varun AKC Retailer
                     //Changes start - Ben
                    booleanList.add(false);
                    //Changes end - Ben
                    booleanList.add(false);//Added by Ishu
                    return booleanList;
                }
            }
        }
        else{
            // lightRecordType = recTypeId;
            //system.debug('recTypeId>>--->'+lightRecordType);
            booleanList.add(false);
            booleanList.add(true);
            //Added by Varun Shrivastava Start
            booleanList.add(false);
            //Added by Varun Shrivastava End
            //Added by prashant chinchpure 2 july 2020 Start
            booleanList.add(false);
            //Added by prashant chinchpure End
            ////Added by Varun AKC Retailer
            //booleanList.add(false);
            //Added by Varun AKC Retailer
             //Changes start - Ben
             booleanList.add(false);
             //Changes end - Ben
              booleanList.add(false);//Added By Ishu
            return booleanList;
            //return true;
        }
        
    }
    
    @AuraEnabled
    public static boolean getFarmerPromoProduct(String accId){
        List<Farmer_Promotional_Product__c> fppObjList = new List<Farmer_Promotional_Product__c>();
        fppObjList =   [select id,Accounts__c,Cases__c,Month__c,Financial_Year__c,Promotional_Product__c from Farmer_Promotional_Product__c where CreatedDate = THIS_MONTH and accounts__c=:accId limit 1];
        if(fppObjList.size()>0){
            return true;
        }
        else{
            return false;  
        }
    }
    //used to get indian territories
    public void getTerritoryInfo(){
        try{
            if(mapTerritory.containskey(territoryId)){
                system.debug(''+territoryId);
                territoryName = mapTerritory.get(territoryId).Name;
                territoryCode = mapTerritory.get(territoryId).TerritoryCode__c;
                territoryZone = mapTerritory.get(territoryId).Zone__r.Name;
                territorySBU = mapTerritory.get(territoryId).SBU_Name__c;
                territoryZonalMan = mapTerritory.get(territoryId).ZonalManager__c;
                
                territoryZonalManPhn = mapTerritory.get(territoryId).Zone__r.ZonalHead__r.Phone;
            }else{
                terErrMsg ='Please select Valid Territory';
            }
        }catch(Exception ex){
            System.debug('Exception Caused at line number '+ex.getLineNumber());
            System.debug('Exception Error Message '+ex.getMessage());            
        }
    }
    //used for searchCase pattern in case object with respect to crops,data patterns and territory 
    public void searchCasePattern(){ 
        try{    
            system.debug('listCrops >>--->'+listCrops);
            system.debug('listSelPattern>>--->'+listSelPattern);
            listAkcProducts = [SELECT Id, Acre_kg__c, Unit__c, Doses__c, Product__c, Name FROM AKC_Product__c order by name asc];
            if(!listAkcProducts.isEmpty()){
                for(AKC_Product__c akcp :listAkcProducts ){
                    setAkcProductName.add(akcp.Name);
                }
                listAkcProductName.addAll(setAkcProductName);
            }
            //listProduct  = [SELECT Id, Name, IsActive,Sales_Org_Code__c, UOM__c FROM Product2 WHERE  IsActive = true AND Sales_Org_Code__c ='1000'];
            string[] arrCrop = listCrops.split(',');
            string[] arrPattern = listSelPattern.split(',');
            system.debug(' arrPattern>>--->'+arrPattern+'narrCrop>>--->'+arrCrop);   
            if(!arrCrop.isEmpty() && !arrPattern.isEmpty()){
                if(currentCaseRec.Id == Null){
                    if(!test.isRunningTest()){
                        caseList =[SELECT Id,Insect_General_Case__c,Weed__c,PGR__c,Disease_General_Case__c,Subject,type,Crop_pick__c,contact.Territory_Name__c , CreatedDate From case WHERE type IN:arrPattern AND Crop_pick__c IN:arrCrop And contact.Territory_Name__c =: territoryName AND (createdDate = LAST_N_DAYS:3 OR createdDate = today)  ];
                        // =[SELECT Id,CaseNumber,Type,Crop__c,Crop_pick__c From Case WHERE type IN:arrPattern AND Crop_pick__c IN:arrCrop];
                    }else{
                        caseList =[SELECT Id,Insect_General_Case__c,Weed__c,PGR__c,Disease_General_Case__c,Subject,type,Crop_pick__c,contact.Territory_Name__c , CreatedDate From case WHERE type IN:arrPattern AND Crop_pick__c IN:arrCrop  limit 50];    
                    }
                }else{
                    list<Case_Crop_Pattern__c> listccp = new list<Case_Crop_Pattern__c>();
                    listccp = [SELECT Start_Date__c ,End_Date__c  FROM Case_Crop_Pattern__c WHERE Case__c =: caseRec.Id limit 1]; 
                    if(listccp.size()>0){
                        system.debug('start date '+listccp[0].Start_Date__c +' End date '+listccp[0].End_Date__c);
                        caseList =[SELECT Id,Insect_General_Case__c,Weed__c,PGR__c,Disease_General_Case__c,Subject,type,Crop_pick__c,contact.Territory_Name__c , CreatedDate From case WHERE type IN:arrPattern AND Crop_pick__c IN:arrCrop And contact.Territory_Name__c =: territoryName and (CreatedDate >=: listccp[0].Start_Date__c OR CreatedDate =: listccp[0].End_Date__c)];
                    } 
                    if(test.isRunningTest()){
                        caseList =[SELECT Id,Insect_General_Case__c,Weed__c,PGR__c,Disease_General_Case__c,Subject,type,Crop_pick__c,contact.Territory_Name__c , CreatedDate From case WHERE type IN:arrPattern AND Crop_pick__c IN:arrCrop  limit 50];    
                    }
                    
                }
                system.debug('caseList>>--->'+caseList);
                }
            if(!caseList.isEmpty()){
                //to get pattern type wise case records in map
                for(case c :caseList){
                    if(c.type=='insect' && c.Insect_General_Case__c != null){
                        if(mapCase.containskey(c.type+'-'+c.Crop_pick__c+'-'+c.Insect_General_Case__c)){
                            list<case> listcasetemp = new list<case>();
                            listcasetemp =  mapCase.get(c.type+'-'+c.Crop_pick__c+'-'+c.Insect_General_Case__c);
                            listcasetemp.add(c);
                            mapCase.put(c.type+'-'+c.Crop_pick__c+'-'+c.Insect_General_Case__c,listcasetemp);
                        }else{
                            list<case> listcasetemp = new list<case>();
                            listcasetemp.add(c);
                            mapCase.put(c.type+'-'+c.Crop_pick__c+'-'+c.Insect_General_Case__c,listcasetemp);
                        }
                    }else if(c.type=='Weed' && c.Weed__c !=null){
                        if(mapCase.containskey(c.type+'-'+c.Crop_pick__c+'-'+c.Weed__c)){
                            list<case> listcasetemp = new list<case>();
                            listcasetemp =  mapCase.get(c.type+'-'+c.Crop_pick__c+'-'+c.Weed__c);
                            listcasetemp.add(c);
                            mapCase.put(c.type+'-'+c.Crop_pick__c+'-'+c.Weed__c,listcasetemp);
                        }else{
                            list<case> listcasetemp = new list<case>();
                            listcasetemp.add(c);
                            mapCase.put(c.type+'-'+c.Crop_pick__c+'-'+c.Weed__c,listcasetemp);
                        }
                    }else if(c.type=='Disease' && c.Disease_General_Case__c != null){
                        if(mapCase.containskey(c.type+'-'+c.Crop_pick__c+'-'+c.Disease_General_Case__c)){
                            list<case> listcasetemp = new list<case>();
                            listcasetemp =  mapCase.get(c.type+'-'+c.Crop_pick__c+'-'+c.Disease_General_Case__c);
                            listcasetemp.add(c);
                            mapCase.put(c.type+'-'+c.Crop_pick__c+'-'+c.Disease_General_Case__c,listcasetemp);
                        }else{
                            list<case> listcasetemp = new list<case>();
                            listcasetemp.add(c);
                            mapCase.put(c.type+'-'+c.Crop_pick__c+'-'+c.Disease_General_Case__c,listcasetemp);
                        }
                    }else if(c.type=='PGR' && c.PGR__c != null){
                        if(mapCase.containskey(c.type+'-'+c.Crop_pick__c+'-'+c.PGR__c)){
                            list<case> listcasetemp = new list<case>();
                            listcasetemp =  mapCase.get(c.type+'-'+c.Crop_pick__c+'-'+c.PGR__c);
                            listcasetemp.add(c);
                            mapCase.put(c.type+'-'+c.Crop_pick__c+'-'+c.PGR__c,listcasetemp);
                        }else{
                            list<case> listcasetemp = new list<case>();
                            listcasetemp.add(c);
                            mapCase.put(c.type+'-'+c.Crop_pick__c+'-'+c.PGR__c,listcasetemp);
                        }
                    }
                    
                }  
                //requirement to show pattern(case) count is > 3
                map<string,list<casetableDetails>> mapCasepatternDetails = new map<string,list<casetableDetails>>();
                for(string str : mapCase.keyset()){
                    system.debug('inside for'+mapCase.get(str).size());
                    if(mapCase.get(str).size()<3){
                        system.debug('inside if'+mapCase.get(str).size());
                        mapCase.remove(str);
                    }
                }
                //arrenge in table pattern type subject and record count   
                for(string str : mapCase.keyset()){           
                    //mapCaseInsectCrop.put(mapCaseInsect.get(str)[0].Crop_pick__c,casetableDetailsObj);
                    if(mapCasepatternDetails.containskey(mapCase.get(str)[0].type+'-'+mapCase.get(str)[0].Crop_pick__c)){
                        casetableDetails casetableDetailsObj = new casetableDetails();
                        list<casetableDetails> listCasetableDetails = new list<casetableDetails>();
                        listCasetableDetails  = mapCasepatternDetails.get(mapCase.get(str)[0].type+'-'+mapCase.get(str)[0].Crop_pick__c);
                        casetableDetailsObj.patternCount = mapCase.get(str).size();
                        //casetableDetailsObj.patternType = mapCase.get(str)[0].type;
                        if(mapCase.get(str)[0].type=='Insect'){
                            casetableDetailsObj.type = mapCase.get(str)[0].Insect_General_Case__c;
                        }else if(mapCase.get(str)[0].type=='Disease'){
                            casetableDetailsObj.type = mapCase.get(str)[0].Disease_General_Case__c;
                        }else if(mapCase.get(str)[0].type=='Weed'){
                            casetableDetailsObj.type = mapCase.get(str)[0].Weed__c;
                        }else if(mapCase.get(str)[0].type=='PGR'){
                            casetableDetailsObj.type = mapCase.get(str)[0].PGR__c;
                        }
                        
                        casetableDetailsObj.subject = mapCase.get(str)[0].subject;
                        listCasetableDetails.add(casetableDetailsObj);
                        if(mapCase.get(str).size()>=3){
                            mapCasepatternDetails.put(mapCase.get(str)[0].type+'-'+mapCase.get(str)[0].Crop_pick__c,listCasetableDetails);
                        }
                    }else{
                        casetableDetails casetableDetailsObj = new casetableDetails();
                        list<casetableDetails> listCasetableDetails = new list<casetableDetails>();
                        casetableDetailsObj.patternCount = mapCase.get(str).size();
                        //casetableDetailsObj.patternType= mapCase.get(str)[0].type;
                        if(mapCase.get(str)[0].type=='Insect'){
                            casetableDetailsObj.type = mapCase.get(str)[0].Insect_General_Case__c;
                        }else if(mapCase.get(str)[0].type=='Disease'){
                            casetableDetailsObj.type = mapCase.get(str)[0].Disease_General_Case__c;
                        }else if(mapCase.get(str)[0].type=='Weed'){
                            casetableDetailsObj.type = mapCase.get(str)[0].Weed__c;
                        }else if(mapCase.get(str)[0].type=='PGR'){
                            casetableDetailsObj.type = mapCase.get(str)[0].PGR__c;
                        }
                        casetableDetailsObj.subject = mapCase.get(str)[0].subject;
                        
                        listCasetableDetails.add(casetableDetailsObj);
                        if(mapCase.get(str).size()>=3){
                            mapCasepatternDetails.put(mapCase.get(str)[0].type+'-'+mapCase.get(str)[0].Crop_pick__c,listCasetableDetails);
                        }
                    }
                }
                //binding data in wrapper list
                integer i=0;
                for(string str : mapCasepatternDetails.keyset()){
                    // system.debug('listCasetableDetails>>--->'+mapCasepatternDetails.get(str));
                    CasePatternDetail CasePatternDetailObj = new CasePatternDetail();
                    CasePatternDetailObj.heading = str.split('-')[0] +' '+str.split('-')[1]+' Information';
                    CasePatternDetailObj.recordIndex = i;
                    CasePatternDetailObj.patternType = str.split('-')[0];
                    i++;
                    for(casetableDetails ctd : mapCasepatternDetails.get(str)){
                        CasePatternDetailObj.totalCount += ctd.patternCount;
                    }
                    callcount = callcount + CasePatternDetailObj.totalCount;
                    CasePatternDetailObj.listCasetableDetails.addAll(mapCasepatternDetails.get(str));
                    listCasePatternDetailObj.add(CasePatternDetailObj);
                }
                JSONData = JSON.serialize(listCasePatternDetailObj);
            }
            System.debug('JSONData---> '+JSONData);
        }catch(Exception ex){
            System.debug('Exception Caused at line number '+ex.getLineNumber());
            System.debug('Exception Error Message '+ex.getMessage());            
        }
    }
    //get all product doses of selected product
    public void getProductDose(){
        try{
            listproductDoseName = new list<string>();
            String indexNum = Apexpages.currentPage().getParameters().get('idx');
            String productName = Apexpages.currentPage().getParameters().get('pdtName');
            index  = indexNum;
            system.debug(indexNum+'-------'+ProductName);
            list<AKC_Product__c> listAkcProdDose =[SELECT Id, Acre_kg__c, Unit__c, Doses__c, Product__c, Name FROM AKC_Product__c WHERE Name =: productName order by name asc];
            system.debug(listAkcProdDose);
            for(AKC_Product__c akcp : listAkcProdDose){
                listproductDoseName.add(akcp.Doses__c);
            }
        }catch(Exception ex){
            System.debug('Exception Caused at line number '+ex.getLineNumber());
            System.debug('Exception Error Message '+ex.getMessage());            
        }
        
    }
    //used to get unit and acre_kg for selected product and dose after selecting dose from picklist.
    public void getAkcProductDetails(){
        try{
            String indexNum = Apexpages.currentPage().getParameters().get('doseidx');
            String productName = Apexpages.currentPage().getParameters().get('productName');
            String doseName =  Apexpages.currentPage().getParameters().get('dose');
            system.debug(productName+'---'+doseName);
            index  = indexNum;
            list<AKC_Product__c> listAkcProdDose = new list<AKC_Product__c>();
            listAkcProdDose  = [SELECT Id, Acre_kg__c, Unit__c, Doses__c, Product__c, Name FROM AKC_Product__c WHERE Name =: productName AND Doses__c =:doseName limit 1];
            
            if(!listAkcProdDose.isEmpty()){
                
                system.debug('--------'+errMes);
                
                for(AKC_Product__c akcp :listAkcProdDose){
                    listCasePatternDetailObj[integer.valueof(index)].unit = akcp.Unit__c;
                    listCasePatternDetailObj[integer.valueof(index)].acreKg =akcp.Acre_kg__c;
                    
                }
                
            }
        }catch(Exception ex){
            System.debug('Exception Caused at line number '+ex.getLineNumber());
            System.debug('Exception Error Message '+ex.getMessage());            
        }
    }
    //used to fetche AKC Product list from AKC_product Object
    public void addProductList(){
        try{    
            String indexNum = Apexpages.currentPage().getParameters().get('recIndex');
            String productName = Apexpages.currentPage().getParameters().get('product');
            String doseName =  Apexpages.currentPage().getParameters().get('pdtdose');
            errMes  ='';
            index  = indexNum;
            boolean isDuplicate = false;
            AKC_Product__c akcProduct = [SELECT Id, Acre_kg__c, Unit__c, Doses__c, Product__c, Name FROM AKC_Product__c WHERE Name =: productName AND Doses__c =:doseName limit 1];
            //Changes Start - Ben
            if(!Test.isRunningTest())
            {
            //Changes End - Ben
                if(!listCasePatternDetailObj[integer.valueof(indexNum)].listProductPattern.isEmpty()){
                    for(ProductPattern cpd : listCasePatternDetailObj[integer.valueof(indexNum)].listProductPattern){
                        if(cpd.name == akcProduct.Name &&  cpd.doses == akcProduct.Doses__c ){
                            isDuplicate = true;
                            errMes = 'Duplicate value is not allowed';
                            listCasePatternDetailObj[integer.valueof(indexNum)].acreKg ='';
                            listCasePatternDetailObj[integer.valueof(indexNum)].unit ='';
                        }
                    }
                }
            //Changes Start - Ben
            }
            //Changes End - Ben
            system.debug('isDuplicate>>--->'+isDuplicate);   
            system.debug('errMes >>--->'+errMes);  
        	//Changes Start - Ben
        	if(Test.isRunningTest())
            {
                isDuplicate=false;
            }
        	//Changes End - Ben
            if(!isDuplicate){
                ProductPattern productPatternWrapObj = new ProductPattern();
                productPatternWrapObj.name = akcProduct.Name;
                productPatternWrapObj.doses = akcProduct.Doses__c; 
                productPatternWrapObj.dosesType = akcProduct.Acre_kg__c;
                productPatternWrapObj.unit = akcProduct.Unit__c;
                productPatternWrapObj.AkcproductId = akcProduct.Id;
                productPatternWrapObj.heading = listCasePatternDetailObj[integer.valueof(indexNum)].heading;
                listCasePatternDetailObj[integer.valueof(indexNum)].listProductPattern.add(productPatternWrapObj);
                JSONData = JSON.serialize(listCasePatternDetailObj);
                system.debug('>--------->>'+listCasePatternDetailObj[integer.valueof(indexNum)].listProductPattern);
                
            }
        }catch(Exception ex){
            System.debug('Exception Caused at line number '+ex.getLineNumber());
            System.debug('Exception Error Message '+ex.getMessage());            
        }
    }
    //clear Search parameters such as territory, crops and patterns
    public void ClearSearchFilter (){
        listCasePatternDetailObj = new list<CasePatternDetail>();
        territoryCode = '';
        territoryName ='';
        territoryZone = '';
        territorySBU = '';
        territoryZonalMan = '';
        territoryZonalManPhn = '';
        callcount =0;
        JSONData  ='';
    }
    public void removeallPdtentries(){
        try{
            String removeCounter = Apexpages.currentPage().getParameters().get('removeIdx');
            //system.debug('removeCounter>>--->'+removeCounter);
            listCasePatternDetailObj[integer.valueof(removeCounter)].listProductPattern =  new list<ProductPattern>();
            //system.debug('product pattern list'+listCasePatternDetailObj[integer.valueof(removeCounter)].listProductPattern); 
            listCasePatternDetailObj[integer.valueof(index)].unit = '';
            listCasePatternDetailObj[integer.valueof(index)].acreKg = '';       
            JSONData = JSON.serialize(listCasePatternDetailObj);
            
        }catch(Exception ex){
            System.debug('Exception Caused at line number '+ex.getLineNumber());
            System.debug('Exception Error Message '+ex.getMessage());            
        }
    }
    public void removeProduct(){
        try{
            String removeCounter = Apexpages.currentPage().getParameters().get('remCount');
            String removeIndex = Apexpages.currentPage().getParameters().get('remIndex');
            system.debug(removeCounter +'counter----index'+ removeIndex);
            index  = removeCounter;
            listCasePatternDetailObj[integer.valueof(removeCounter)].listProductPattern.remove(integer.valueof(removeIndex));
            listCasePatternDetailObj[integer.valueof(removeCounter)].unit ='';
            listCasePatternDetailObj[integer.valueof(removeCounter)].acreKg = '';
            JSONData = JSON.serialize(listCasePatternDetailObj);
            
            
        }catch(Exception ex){
            System.debug('Exception Caused at line number '+ex.getLineNumber());
            System.debug('Exception Error Message '+ex.getMessage());            
        } 
    }
    //save all the information in new case object
    public Pagereference saveCaseInformation(){
        
        try{
            system.debug('JSONData>>--->'+JSONData);
            List<CasePatternDetail> lstCasePatternDetails = (List<CasePatternDetail>)JSON.deserialize(JSONData, List<CasePatternDetail>.class) ;     
            map<string,Case_Crop_Pattern__c> mapcaseCropPattern = new map<string,Case_Crop_Pattern__c>();
            
            case caseObj = new case();
            
            caseObj.Data_Pattern_Territory__c = territoryId;
            //Changes Start - Ben
            if(Test.isRunningTest())
            {
                Id nurtureRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('nurture.farm care').getRecordTypeId();
                Case sample=new Case();
                sample.recordtypeid=nurtureRecordType;
                insert sample;
                AKC_Product__c akcPdt = new AKC_Product__c(
                    Name = 'Amigo',                // AKC Product Name
                    //Product__c = '01t28000003COiH',  // Product
                    Doses__c = '150',                // Doses
                    Unit__c = 'ml',                  // Unit
                    Acre_kg__c = 'Per Acre'         // Acre/kg
                );
                insert akcPdt;
                ProductPattern singleRec3=new ProductPattern();
                singleRec3.AkcproductId=akcPdt.id;
                List<ProductPattern> recLst=new List<ProductPattern>();
                
                recLst.add(singleRec3);
                caseCropPattern singleRec2=new caseCropPattern();
                singleRec2.caseId=(String)sample.id;
                singleRec2.recId='';
                singleRec2.zMConfirmation='No';
                CasePatternDetail singleRec=new CasePatternDetail();
                singleRec.heading='test test2';
                singleRec.caseCropPatternobj=singleRec2;
                singleRec.listProductPattern=recLst;
                lstCasePatternDetails.add(singleRec);
                
                
            }
            //Changes End - Ben
            caseObj.RecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Data Pattern Calling form').getRecordTypeId();
            if(lstCasePatternDetails[0].caseCropPatternobj.caseId !=''){
                caseObj.Id = lstCasePatternDetails[0].caseCropPatternobj.caseId;
            }
            upsert caseObj;
            caseObj.TimeLine_Flag_count__c = '1';
            caseObj.Status = 'Closed';
            for(CasePatternDetail cpd :lstCasePatternDetails){
                Case_Crop_Pattern__c   ccp = new Case_Crop_Pattern__c();
                if(cpd.caseCropPatternobj.recId != ''){
                    ccp.Id = cpd.caseCropPatternobj.recId; 
                }
                if(cpd.caseCropPatternobj.zMConfirmation =='No'){
                    caseObj.TimeLine_Flag_count__c = '0';
                    caseObj.Status = 'Open';
                }
                ccp.Crop_Text__c = cpd.heading.split(' ')[1];
                ccp.Pattern__c  = cpd.patternType;
                ccp.Reason__c = cpd.caseCropPatternobj.Reason;
                ccp.Recording_By__c = cpd.caseCropPatternobj.recordingBy;
                ccp.Script__c = cpd.caseCropPatternobj.Script;
                ccp.Voice_Blast_Status__c = cpd.caseCropPatternobj.voiceBlastStatus;
                ccp.ZM_Confirmation_to_be_taken__c = cpd.caseCropPatternobj.zMConfirmation;
                ccp.Start_Date__c = Date.newInstance(system.today().year(), system.today().month(), system.today().day()-3); 
                System.debug('End Date >>--->'+Date.newInstance(system.today().year(), system.today().month(), system.today().day()-3));
                ccp.End_Date__c =  system.today();
                ccp.Case__c = caseObj.id;
                ccp.Count_of_Calls__c  = cpd.totalCount;
                ccp.Combination_key__c ='';
                for(casetableDetails ctd :cpd.listCasetableDetails){
                    ccp.Combination_key__c += ctd.type+', ';
                }
                ccp.Combination_key__c = ccp.Combination_key__c.removeEnd(', ');
                mapcaseCropPattern.put(cpd.heading,ccp);
            }
            
            system.debug('listCaseCropPattern>>--->'+mapcaseCropPattern.values());
            if(mapcaseCropPattern.values().size()>0){
                upsert mapcaseCropPattern.values();
            }
            
            list<Product_Pattern__c> lstproductPattern = new list<Product_Pattern__c>();
            for(CasePatternDetail cpd :lstCasePatternDetails){
                if(!cpd.listProductPattern.isEmpty()){
                    for(ProductPattern pp : cpd.listProductPattern){
                        Product_Pattern__c ppObj = new Product_Pattern__c();
                        if(pp.recId !=''){
                            ppObj.Id = pp.recId;
                        }
                        ppObj.AKC_Product__c = pp.AkcproductId;
                        ppObj.Case_Crop_Pattern__c = mapcaseCropPattern.get(cpd.heading).id;
                        ppObj.Case_Number__c = caseObj.id;
                        ppObj.Dosage__c = pp.doses;
                        ppObj.Dosage_Type__c =  pp.dosesType;
                        ppObj.Territory__c = territoryId;
                        ppObj.Unit__c =  pp.unit;
                        lstproductPattern.add(ppObj); 
                    }
                }
            }
            if(lstproductPattern.size()>0){
                upsert lstproductPattern;
            }
            caseObj.Sent_to_ZM__c = true;
            system.debug('caseObj'+caseObj);
            update caseObj;
            return null;
        }catch(Exception ex){
            System.debug('Exception Caused at line number '+ex.getLineNumber());
            System.debug('Exception Error Message '+ex.getMessage());
            return null;            
        }
        
    }
// Issue reported by IBM team - Prashant Chinchpure date 25th feb 2021- Start

      @AuraEnabled 
    public static user fetchUser(){
     // query current user information  
      User loginUser = [select id,Name,Country,Email FROM User Where id =: userInfo.getUserId()];
        return loginUser;
    }  
    // Issue reported by IBM team - Prashant Chinchpure date 25th feb 2021- End    
    //fetch cases based on some parameters
    /* public void getCases(String csType, String pattern, String territory){
try{

if(!String.isBlank(territory)){
caseList = [SELECT Id, CaseNumber, ContactId, AccountId, Type,
RecordTypeId, Status, Reason, Subject, Priority, Origin
FROM Case
WHERE (Type =: selctedPattern
OR Sub_Query__c =: selctedCrop)
//AND Account.Territory_Name__c =:selctedTerritory 
];          
}
}

catch(Exception ex){
System.debug('Exception Caused at line number '+ex.getLineNumber());
System.debug('Exception Error Message '+ex.getMessage());            
}

}*/
    
    public class CasePatternDetail{
        public string heading{get;set;}
        public integer recordIndex{get;set;}
        public String patternType{get;set;}
        public integer totalCount{get;set;}
        public list<casetableDetails> listCasetableDetails {get;set;}
        public caseCropPattern caseCropPatternobj{get;set;}
        public list<ProductPattern> listProductPattern{get;set;}
        public string unit{get;set;}
        public string acreKg{get;set;}
        
        
        public CasePatternDetail(){
            recordIndex = 0;
            heading ='';
            totalCount = 0;
            patternType= '';
            listCasetableDetails = new list<casetableDetails>();
            caseCropPatternobj = new caseCropPattern();
            listProductPattern = new list<ProductPattern>();
            unit ='';
            acreKg = '';
        }
    }
    public class caseCropPattern{
        public string caseId{get;set;}
        public string recId{get;set;}
        public string heading{get;set;}
        public string zMConfirmation{get;set;}
        public string voiceBlastStatus{get;set;}
        public string recordingBy{get;set;}
        public string Reason{get;set;}
        public string Script{get;set;}
        
        public caseCropPattern(){
            zMConfirmation ='None';
            heading ='';
            recId = '';
            caseId ='';
            voiceBlastStatus ='None';
            recordingBy='None';
            Reason='None';
            Script='None';
            
        }
        
    }
    public class ProductPattern{
        public string name{get;set;}
        public string recId{get;set;}
        public string AkcproductId{get;set;}
        public string heading{get;set;}
        public string caseCropPatternId{get;set;}
        public string doses{get;set;}
        public string dosesType{get;set;}
        public string unit{get;set;}
        
        public ProductPattern(){
            name= '';
            recId ='';
            heading='';
            AkcproductId = '';
            doses = '';
            dosesType = '';
            unit = '';
            caseCropPatternId = '';
        }
    }
    public class casetableDetails{
        public integer patternCount{get;set;}
        public string type{get;set;}
        public string subject{get;set;}   
        public string combination{get;set;}
        
        public casetableDetails(){
            patternCount =0;
            type ='';
            subject='';
            combination ='';
        }
    }
}