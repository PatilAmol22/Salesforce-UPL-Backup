/*
*   Author : Vaishnavi Ahirrao (EY)
*   Schedular Class - EmailToCustomerBatch
*   CreatedDate: 08-02-2023
*   Description - Send Email related to Bulk Communication functionality.
*   CR: APPS-3974
**/
public without sharing class EmailToCustomer {

    

    @AuraEnabled
    public static CountryWrapper fetchCountryData(string salesOrg){
        System.debug('salesOrg => '+salesOrg);
        Map<String,SBU__c> mapListSBU;
        Map<String,Territory_Distributor__c> mapListTer;
        Map<String,Region__c> mapListReg;
        Map<String,Zone__c> mapListZone;
        Map<String,State__c> mapListState;
        string salesOrgCodeSAS;
        CountryWrapper cWrapper = new CountryWrapper();
        try {
            
            mapListSBU = new Map<String,SBU__c>();
            mapListTer = new Map<String,Territory_Distributor__c>();
            mapListReg = new Map<String,Region__c>();
            mapListZone = new Map<String,Zone__c>();
            mapListState = new Map<String,State__c>();

             Map<String, UPL_SalesOrg_Detail__mdt> salesOrgDetailsMap = UtilityClass.getSalesOrgDetails();
             salesOrgCodeSAS = salesOrgDetailsMap.get('India_SalesOrg').value__c; 
    
           
            Id salesOrgId = [SELECT Id, Sales_Org_Code__c FROM Sales_Org__c where Sales_Org_Code__c  = :salesOrg][0].Id;
            System.debug(salesOrgId);
    
    
            //if(salesOrg == salesOrgCodeSAS){ 
                for(SBU__c sbu: [SELECT Id, SalesOrg__c, Name FROM SBU__c where SalesOrg__c  =:salesOrgId]){
                    if(!mapListSBU.containsKey(sbu.Id)){
                        mapListSBU.put(sbu.Id,sbu);
                    }
                }
                System.debug('mapListSBU----> '+mapListSBU);
    
                Set<String> sbuIdSet = new Set<String>();
                sbuIdSet = mapListSBU.keySet();
                System.debug('sbuIdSet----> '+sbuIdSet.size());
                System.debug('sbuIdSet----> '+sbuIdSet);
            //}
              
                for(Zone__c  zone:[SELECT Id,Name,SalesOrg__c FROM Zone__c WHERE  SalesOrg__c =: salesOrgId]){
                    
                  if(!mapListZone.containsKey(zone.Id)){
                        mapListZone.put(zone.Id,zone);
                  }
                }
             
            
    
            System.debug('mapListZone----> '+mapListZone);
    
            if(salesOrg == '1210'){ 
                for(Region__c  reg: [SELECT Id,Name,SalesOrg__c FROM Region__c WHERE  SalesOrg__c =: salesOrgId]){
                    
                    if(!mapListReg.containsKey(reg.Id)){
                      mapListReg.put(reg.Id,reg); 
                    }
                }
            }
    
            System.debug('mapListReg----> '+mapListReg);
            
                for(Territory_Distributor__c ter : [SELECT Id,Name,SalesOrg__c FROM Territory_Distributor__c WHERE SalesOrg__c =: salesOrgId]){
                    
                    if(!mapListTer.containsKey(ter.Id)){
                        mapListTer.put(ter.Id,ter);  
                    }
                }
            
                for(State__c s : [SELECT Id,Name FROM State__c WHERE Country_Code__c='91' AND Country__c='India']){
                    if(!mapListState.containsKey(s.Id)){
                        mapListState.put(s.Id,s);

                    }
                }
    
             System.debug('mapListTer----> '+mapListTer);
          
           
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        cWrapper.mapListSBU = mapListSBU;
        cWrapper.mapListTer = mapListTer;
        cWrapper.mapListReg = mapListReg;
        cWrapper.mapListZone = mapListZone;
        cWrapper.mapListState = mapListState;

        return cWrapper;
    }
    @AuraEnabled
    public static CountryWrapper fetchSearchData(string salesOrg, String ObjName, String searchKey,String sbuList,String zoneList,String regionList){
        System.debug('salesOrg => '+salesOrg);
        System.debug('sbuList => '+sbuList);
        String searchTerm = String.isBlank(searchKey) ?'':'%'+searchKey+'%';
        Map<String,SBU__c> mapListSBU;
        Map<String,Territory_Distributor__c> mapListTer;
        Map<String,Region__c> mapListReg;
        Map<String,Zone__c> mapListZone;
        Map<String,State__c> mapListState;
        string salesOrgCodeSAS;
        CountryWrapper cWrapper = new CountryWrapper();
        try {
            
            mapListSBU = new Map<String,SBU__c>();
            mapListTer = new Map<String,Territory_Distributor__c>();
            mapListReg = new Map<String,Region__c>();
            mapListZone = new Map<String,Zone__c>();
            mapListState = new Map<String,State__c>();

             Map<String, UPL_SalesOrg_Detail__mdt> salesOrgDetailsMap = UtilityClass.getSalesOrgDetails();
             salesOrgCodeSAS = salesOrgDetailsMap.get('India_SalesOrg').value__c; 
    
           
            Id salesOrgId = [SELECT Id, Sales_Org_Code__c FROM Sales_Org__c where Sales_Org_Code__c  = :salesOrg][0].Id;
            System.debug(salesOrgId);
            
            if(objName == 'SBU__c'){
                for(SBU__c sbu: [SELECT Id, SalesOrg__c, Name FROM SBU__c where SalesOrg__c  =:salesOrgId AND Name LIKE: searchTerm]){
                    if(!mapListSBU.containsKey(sbu.Id)){
                        mapListSBU.put(sbu.Id,sbu);
                    }
                }
                System.debug('mapListSBU----> '+mapListSBU);
    
                Set<String> sbuIdSet = new Set<String>();
                sbuIdSet = mapListSBU.keySet();
                System.debug('sbuIdSet----> '+sbuIdSet.size());
                System.debug('sbuIdSet----> '+sbuIdSet);
            }else if(objName == 'Zone__c'){
                List<String> sbList=(List<String>)JSON.deserialize(sbuList,List<String>.class);
                //String query = 'SELECT Id,Name,SalesOrg__c FROM Zone__c WHERE  SalesOrg__c =\''+salesOrgId+'\' AND Name LIKE \''+ searchTerm +'\''+filterCriteria;
                String query='SELECT Id,Name,SalesOrg__c FROM Zone__c WHERE  SalesOrg__c =:salesOrgId ';
                String filter='';
                if(!String.IsBlank(searchTerm)){
                    filter = 'AND Name LIKE:searchTerm';

                }else if(!sbList.isEmpty()){
                    filter = !sbList.isEmpty() ? filter+' AND SBUCode__r.Name IN: sbList' :filter ;
                }
                query = query+filter;
                System.debug('Query =>> '+query);
                List<Zone__c> zoneDataList =Database.query(query);
                for(Zone__c  zone:zoneDataList){
                    
                    if(!mapListZone.containsKey(zone.Id)){
                          mapListZone.put(zone.Id,zone);
                    }
                  }
               
              
      
              System.debug('mapListZone----> '+mapListZone);
            }else if(objName == 'Region__c'){
                if(salesOrg == '1210'){ 
                    String query='SELECT Id,Name,SalesOrg__c FROM Region__c WHERE  SalesOrg__c =: salesOrgId ';
                    String filter = '';
                    
                    List<String> sbList=(List<String>)JSON.deserialize(sbuList,List<String>.class);
                    List<String> ZoList=(List<String>)JSON.deserialize(zoneList,List<String>.class);
                    if(!String.IsBlank(searchTerm)){
                        filter = 'AND Name LIKE: searchTerm';

                    }
                     if(!sbList.isEmpty() || !ZoList.isEmpty()){
                        filter = !sbList.isEmpty() ? filter+' AND SBU__r.Name IN: sbList' :filter ;
                        filter = !ZoList.isEmpty() ? filter+' AND Zone__r.Name IN:ZoList' :filter ;
                    }
                query = query+ filter;
                System.debug('Query =>> '+query);
                

                List<Region__c> regionDataList =Database.query(query);

                    for(Region__c  reg: regionDataList){
                        
                        if(!mapListReg.containsKey(reg.Id)){
                          mapListReg.put(reg.Id,reg); 
                        }
                    }
                }
        
                System.debug('mapListReg----> '+mapListReg);
            }else if(objName == 'Territory_Distributor__c'){
                String query = 'SELECT Id,Name,SalesOrg__c FROM Territory_Distributor__c WHERE SalesOrg__c =: salesOrgId ';
                String filter = '';
                    List<String> sbList=(List<String>)JSON.deserialize(sbuList,List<String>.class);
                    List<String> ZoList=(List<String>)JSON.deserialize(zoneList,List<String>.class);
                    List<String> ReList=(List<String>)JSON.deserialize(regionList,List<String>.class);

                    if(!String.IsBlank(searchTerm)){
                        filter=' AND Name LIKE: searchTerm';

                    }
                	if(!sbList.isEmpty() || !ZoList.isEmpty() || !ReList.isEmpty()){
                        filter = !sbList.isEmpty() ? filter+' AND SBU__r.Name IN: sbList' :filter ;
                        filter = !ZoList.isEmpty() ? filter+' AND Zone__r.Name IN:ZoList' :filter ;
                        filter = !ReList.isEmpty() ? filter+' AND Region_Name__c IN:ReList' :filter;
                    }
                    query = query+ filter;
                System.debug('Query =>> '+query);
                List<Territory_Distributor__c> TerriDataList =Database.query(query);

                for(Territory_Distributor__c ter : TerriDataList){
                    
                    if(!mapListTer.containsKey(ter.Id)){
                        mapListTer.put(ter.Id,ter);  
                    }
                }
                System.debug('mapListTer----> '+mapListTer);

            }else if(objName == 'State__c'){
                for(State__c s : [SELECT Id,Name FROM State__c where Name LIKE: searchTerm]){
                    if(!mapListState.containsKey(s.Id)){
                        mapListState.put(s.Id,s);

                    }
                }
            }
    
           
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        cWrapper.mapListSBU = mapListSBU;
        cWrapper.mapListTer = mapListTer;
        cWrapper.mapListReg = mapListReg;
        cWrapper.mapListZone = mapListZone;
        cWrapper.mapListState = mapListState;

        return cWrapper;
    }
    @AuraEnabled
    public static string fetchCustomerData(String salesOrgCode, List<Id> sbuIds, List<Id> zoneIds, List<Id> regionIds,List<Id> stateIds,List<Id> TerIds){
        try {
            System.debug('TerIds =>> '+TerIds);
            String query ='SELECT Id, Name,Email__c,SAP_Customer_Code__c,State__c,state__r.Name, Territory_Distributor__r.Name,Territory_Distributor__r.SBU__r.Name,Territory_Distributor__r.Zone__r.Name,Territory_Distributor__r.Region__r.Name FROM Account where Sales_Org__r.Sales_Org_Code__c=:salesOrgCode ';
            String sbuQuery = 'AND Territory_Distributor__r.SBU__c IN:sbuIds ';
            String zoneQuery = 'AND Territory_Distributor__r.Zone__c IN:zoneIds ';
            String regionQuery = 'AND Territory_Distributor__r.Region__c IN:regionIds ';
            String territoryQuery = 'AND Territory_Distributor__c IN:TerIds ';
            String stateQuery = 'AND State__c IN:stateIds ';

            if(sbuIds != null && sbuIds?.size()>0){
                query = query+sbuQuery;
            }
            if(zoneIds != null && zoneIds?.size()>0){
                query = query+zoneQuery;
            }
            if(regionIds != null && regionIds?.size()>0){
                query = query+regionQuery;
            }
            if(TerIds != null && TerIds?.size()>0){
                query = query+territoryQuery;
            }
            if(stateIds != null && stateIds?.size()>0){
                query = query+stateQuery;
            }
            query = query+'order by Name DESC';
            
            System.debug('Query=>> '+query);

            List<Account> AccountList = Database.query(query);
            return JSON.serialize(AccountList);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());

        }
    }

    @AuraEnabled
    public static void SendEmail(String emailBody, List<String> userList,List<Id> ContentDocumentIds, String CustVsContentIds){
        try {
            System.debug('Json Obj=>> '+emailBody);
            String MailBody = emailBody;
            String organizationEmailId;
            List<Id> contentDocIds = new List<Id>();
            List<customerWrapper> UserData = new List<customerWrapper>();
            Messaging.SingleEmailMessage  message = new Messaging.SingleEmailMessage();
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
            Messaging.EmailFileAttachment[] emailMsgAttachments = new List<Messaging.EmailFileAttachment>();
            List<ContentVersion> objVersions = new List<ContentVersion>();
            Map<Id,ContentVersion> contIdVsData = new Map<Id,ContentVersion>();
            Map<String,String> CustCodeVsFileName = new Map<String,String>();
            Map<String,List<Id>> custCodeVsContentDocIds = new Map<String,List<Id>>();
            Map<String,List<Id>> jsonObj = (Map<String,List<Id>>)JSON.deserialize(CustVsContentIds,Map<String,List<Id>>.class);
            Map<String,Account> SAPCodeVsAcc = new Map<String,Account>();
            set<String> SAPCodes = new set<String>();
            System.debug('jsonObj =>> '+jsonObj);
            System.debug('userList =>> '+userList);
            System.debug('UserList Size =>> '+userList.size());
            for(String str : userList){
                customerWrapper wrapData = (customerWrapper)JSON.deserialize(str,customerWrapper.class);
                UserData.add(wrapData);
                if(wrapData.SAPCode != null){
                    SAPCodes.add(wrapData.SAPCode);
                }
            }
            system.debug('SAPCodes=> '+SAPCodes);
            if(SAPCodes.size()>0){
                EmailToCustomerBatch shn = new EmailToCustomerBatch(emailBody, userList,ContentDocumentIds, CustVsContentIds,SAPCodes); 
                database.executeBatch(shn,5); 
            }
           
            /*
            if(ContentDocumentIds != null &&  ContentDocumentIds.size()>0){
                objVersions = [SELECT Id, OwnerId,ContentDocumentId,FileExtension, VersionData FROM ContentVersion WHERE ContentDocumentId IN:ContentDocumentIds];
            }
            if(objVersions != null && objVersions.size()>0){
                for(ContentVersion cv:objVersions){
                    if(cv.FileExtension == 'csv'){
                        List < String > records = cv.VersionData.toString().split( '\n');
                        System.debug('records ==>>> '+records);
                        //Removing the Header
                        records.remove( 0 );

                        for ( String record : records ) {

                            if ( record != null ) {

                                List < String > row = record.split( ',' );
                                System.debug('ROW ==> '+row);
                                if(row?.size()>1){
                                    CustCodeVsFileName.put(row[0],row[1].trim());
                                }

                            }

                        }
                        contIdVsData.put(cv.ContentDocumentId,cv);
                    }else{
                        contIdVsData.put(cv.ContentDocumentId,cv);
                        contentDocIds.add(cv.ContentDocumentId);
                        custCodeVsContentDocIds = jsonObj;
                    }
                }
               
            }
            System.debug('CustCodeVsFileName => '+CustCodeVsFileName);
            if(CustCodeVsFileName.size()>0){
                for(String custCode:CustCodeVsFileName.keySet()){
                    String fileName = CustCodeVsFileName.get(custCode);
                    System.debug('fileName =>> '+fileName);
                    ContentVersion objVersions2 = [SELECT Id, OwnerId,ContentDocumentId,FileExtension, VersionData FROM ContentVersion WHERE Title =:fileName limit 1];
                    
                        contIdVsData.put(objVersions2.ContentDocumentId,objVersions2);
                        contentDocIds.add(objVersions2.ContentDocumentId);
                        custCodeVsContentDocIds.put(custCode,contentDocIds);
                       
                }
               
               
            }
            System.debug('custCodeVsContentDocIds => '+custCodeVsContentDocIds);
            System.debug('contIdVsData => '+contIdVsData);
            System.debug('SAPCodes =>> '+SAPCodes);

            List<OrgWideEmailAddress> owaList = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'salesexcellence1@upl-ltd.com'];
            if(null != owaList && !owaList.isEmpty()){
                organizationEmailId = owaList[0].Id;
            }
            EmailTemplate et = [SELECT Id,body FROM EmailTemplate WHERE DeveloperName = 'Bulk_Communication_India'];
            contact conObj = [select id,firstname from contact limit 1];
            List<Account> accList = [Select Id, Name, SAP_Customer_Code__c from Account where SAP_Customer_Code__c IN:SAPCodes];
            for(Account acc : accList){
                if(!SAPCodeVsAcc.containsKey(acc.SAP_Customer_Code__c)){
                    SAPCodeVsAcc.put(acc.SAP_Customer_Code__c,acc);
                }
            }
            System.debug('SAPCodeVsAcc Values  => '+SAPCodeVsAcc);
          
           for(customerWrapper user:UserData){
                if(!String.isBlank(user.Email)){
                    List<String> uList = new List<String>{user.Email};
                    //System.debug('uList =>>> '+User);
                    emailMsgAttachments = new List<Messaging.EmailFileAttachment>();
                    message = new Messaging.SingleEmailMessage();
                    message.setOrgWideEmailAddressId(organizationEmailId);
                    message.setCharset('UTF8');
                    message.setTemplateId(et.Id);
                    message.setWhatId(SAPCodeVsAcc?.get(User.SAPCode)?.Id);
                    message.setSubject('Email to customer from SFDC check');
                    message.setTargetObjectId(conObj.Id);
                    message.setTreatTargetObjectAsRecipient(false);
                    message.setTreatBodiesAsTemplate(true);
                    String body = et.body;
                    //body = body.replace('{body}',MailBody);
                    MailBody = et.body+MailBody;
                    message.setHtmlBody(MailBody);
                    MailBody = emailBody;
                    message.setToAddresses(uList);
                    //message.setSaveAsActivity(false);
                    //system.debug('check to address :'+message); 
                    if(custCodeVsContentDocIds != null && custCodeVsContentDocIds.size()>0 && custCodeVsContentDocIds.containsKey(user.SAPCode) && contIdVsData.size()>0){
                        List<Id> cntIds = custCodeVsContentDocIds.get(user.SAPCode);
                        System.debug('cntIds =>> '+cntIds);
                        for(Id contId : cntIds){
                            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                            efa.setFileName('attachment'+contId+'.pdf');
                            efa.setBody(contIdVsData?.get(Id.valueOf(contId))?.VersionData);
                            emailMsgAttachments.add(efa);
                        }
                        message.setFileAttachments(emailMsgAttachments);
                    }
                    //System.debug('message=>> => '+message);
                    messages.add(message);  
                }    
            }    
            //System.debug('messages => '+messages);
            System.debug('messages size => '+messages.size());
            Messaging.sendEmail(messages);*/
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static string uploadFiles(Id ContentDocumentId,List<Id> acc_ids){
        List<ContentDocumentLink> contentlinkList=new List<ContentDocumentLink>();

        system.debug('acc_ids=>'+acc_ids);
        try {
            ContentVersion objVersion = [SELECT Id, OwnerId,ContentDocumentId, VersionData FROM ContentVersion WHERE ContentDocumentId =:ContentDocumentId];

            if(ContentDocumentId != null && acc_ids?.size() > 0){
                for(Id accid : acc_ids){
                    ContentDocumentLink contentlink=new ContentDocumentLink();
                    contentlink.LinkedEntityId=acc_ids[0];
                    contentlink.ShareType= 'V';
                    contentlink.ContentDocumentId=objVersion.ContentDocumentId;
                    contentlinkList.add(contentlink);
                }
                if(contentlinkList?.size()>0){
                    insert contentlinkList;
                }
               
            }
            return JSON.serialize(contentlinkList);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public class CountryWrapper{  

        @AuraEnabled public Map<String,SBU__c> mapListSBU;
        @AuraEnabled public Map<String,Territory_Distributor__c> mapListTer;
        @AuraEnabled public Map<String,Region__c> mapListReg;
        @AuraEnabled public Map<String,Zone__c> mapListZone;
        @AuraEnabled public Map<String,State__c> mapListState;
        @AuraEnabled public string salesOrgCodeSAS;
       
        
        public CountryWrapper(){  
            mapListSBU = new Map<String,SBU__c>();   
            mapListTer = new Map<String,Territory_Distributor__c>();  
            mapListReg = new Map<String,Region__c>();
            mapListZone = new Map<String,Zone__c>();
            mapListState = new Map<String,State__c> ();
            salesOrgCodeSAS = '';   
            
            
        }   
    } 
    
    public class customerWrapper{
        
        public String Id;	//0015D000012FueNQAS
        public String Name;	//YzEWPCCdcI
        public String SBUName;	//NA
        public String ZoneName;	//United AP
        public String TerritoryName;	//HYDERABAD
        public String Email;	//vaishnavi.ahirrao@upl-ltd.com
        public String SAPCode;
        @testvisible
        customerWrapper(){
            Id = '';	//0015D000012FueNQAS
            Name = '';	//YzEWPCCdcI
            SBUName = '';	//NA
            ZoneName = '';	//United AP
            TerritoryName = '';	//HYDERABAD
            Email = '';	//vaishnavi.ahirrao@upl-ltd.com
            SAPCode = '';

        }
    }

}