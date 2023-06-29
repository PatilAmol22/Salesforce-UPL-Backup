/*
 * Name: GtmLeadCustomer
 * Created On: 23/12/2021
 * Author: Vishal Pawar (vishal.pawar@skinternational.com)
 * Modified: Priyanka Nalawade(Priyanka.nalawade@skinternational.com)
 * Test Class Name: GtmLeadCustomer_Test
 * Description: Class is used GTM Configuration of Lead Customer of Argentina, mexico.
 */
public without sharing class GtmLeadCustomer {



    @AuraEnabled(cacheable = false)
    public static List < LeadAccountListWrapper > getLeadCustomerList(String customerFilter) {

        List < Account > gtmCustomers = new List < Account > ();
        List < Account > leadCustomerList = new List < Account > ();
        List < Account > nonLeadCustomerList = new List < Account > ();

        Id leadcustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Lead Customer').getRecordTypeId();
        Id nonleadcustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();

        System.debug('leadcustomerRecordType ' + leadcustomerRecordType);
        if (Schema.sObjectType.Account.isAccessible()) {
            //Added Sales Org Code By Priyanka(SKI)
			String SalesOrgCode = getSalesOrg().Sales_Org_Code__c;
            leadCustomerList = [SELECT Id, OwnerId, Name, SAP_Code__c, Path_Finder__c, Lead_Customer__c,
                Lead_Customer_Ownership__r.UGDN_Number__c, Account_Type__c,
                Lead_Customer_Ownership__r.Name, Lead_Customer_Created_Date__c,
                Lead_Customer_Description__c, Lead_Customer_Ownership__c, Lead_Customer_Type__c, LastModifiedBy.Name,
                LastModifiedById, LastModifiedDate, recordType.Name
              FROM Account
                WHERE Account_Type__c = 'Sold To Party'
                AND Sales_Org_Code__c =: getSalesOrg().Sales_Org_Code__c
                AND recordType.Id =: leadcustomerRecordType
                ORDER BY Name Asc
            ];

            System.debug('Lead Customer ' + leadCustomerList);
            //Condition Added for Brazil-'001' by Priyanka(SKI)
            if(SalesOrgCode!='5191'){
            nonLeadCustomerList = [SELECT Id, OwnerId, Name, SAP_Code__c, Path_Finder__c, Lead_Customer__c, Lead_Customer_Ownership__r.UGDN_Number__c, Lead_Customer_Created_Date__c,
                Lead_Customer_Description__c, Lead_Customer_Ownership__c,
                LastModifiedBy.Name, LastModifiedDate, LastModifiedById,
                Lead_Customer_Ownership__r.Name, Lead_Customer_Type__c, recordType.Name
                FROM Account WHERE Sales_Org_Code__c =: getSalesOrg().Sales_Org_Code__c
                AND Account_Type__c = 'Sold To Party'
                AND Lead_Customer__c = null
                AND recordType.Id =: nonleadcustomerRecordType
                ORDER BY Name Asc
            ];
            }else{
                nonLeadCustomerList = [SELECT Id, OwnerId, Name, SAP_Code__c, Path_Finder__c, Lead_Customer__c, Lead_Customer_Ownership__r.UGDN_Number__c, Lead_Customer_Created_Date__c,
                Lead_Customer_Description__c, Lead_Customer_Ownership__c,
                LastModifiedBy.Name, LastModifiedDate, LastModifiedById,
                Lead_Customer_Ownership__r.Name, Lead_Customer_Type__c, recordType.Name
                FROM Account WHERE Sales_Org_Code__c =: getSalesOrg().Sales_Org_Code__c
                AND Account_Type__c = 'Sold To Party'
                AND Lead_Customer__c = '001'
                AND recordType.Id =: nonleadcustomerRecordType
                ORDER BY Name Asc];
            }

            System.debug('non lead ' + nonLeadCustomerList);

            System.debug('leadCustomerList ' + leadCustomerList.size());
            System.debug('nonLeadCustomerList ' + nonLeadCustomerList.size());
            if (customerFilter == 'Both') {
                gtmCustomers.addAll(leadCustomerList);
                gtmCustomers.addAll(nonLeadCustomerList);
            } else if (customerFilter == 'Lead Customer') {
                gtmCustomers.addAll(leadCustomerList);
            } else if (customerFilter == 'Non Lead Customer') {
                gtmCustomers.addAll(nonLeadCustomerList);
            }
            System.debug('GTM Customer ' + gtmCustomers.size());


        }

        List < LeadAccountListWrapper > leadCustwraList = new List < LeadAccountListWrapper > ();
        LeadAccountListWrapper wrapObj;
        Integer rowIndex = 0;
        Integer count = 0;

        for (Account accObj: gtmCustomers) {
            wrapObj = new LeadAccountListWrapper();

            wrapObj.showOnwerLookup = false;
            wrapObj.showOnwerText = true;
            System.debug('recordType.Name fetching Data ' + accObj.recordType.Name);
            System.debug('accObj.Id in fetching data ' + accObj.Id);
            if (accObj.recordType.Name == 'Lead Customer') {
                wrapObj.forLeadCust = true;
                wrapObj.isSelected = true;

                count = count + 1;
            } else {
                wrapObj.forLeadCust = false;
                wrapObj.isSelected = false;
            }
            wrapObj.selectCnt = count;

            wrapObj.leadCustomerId = accObj.Id;

            wrapObj.index = rowIndex;
            rowIndex = rowIndex + 1;

            wrapObj.leadCustomerName = accObj.Name;
            System.debug('accObj.SAP_Code__c ' + accObj.SAP_Code__c);

            if (accObj.SAP_Code__c != null) {
                wrapObj.leadCustomerCode = accObj.SAP_Code__c;
            } else {
                wrapObj.leadCustomerCode = accObj.Lead_Customer__c;
            }


            wrapObj.ownerShip = accObj.Lead_Customer_Ownership__c;
            if (accObj.Lead_Customer_Ownership__r.Name != null) {
                wrapObj.ownerShipName = accObj.Lead_Customer_Ownership__r.Name;
                wrapObj.ownerUGDNCode = accObj.Lead_Customer_Ownership__r.UGDN_Number__c;
            } else {
                wrapObj.ownerShipName = '';
                wrapObj.ownerUGDNCode = '';
            }
            wrapObj.customerType = accObj.Lead_Customer_Type__c;
            wrapObj.pathFinder = accObj.Path_Finder__c;
            wrapObj.lastModifiedByName = accObj.LastModifiedBy.Name;
            wrapObj.lastModifiedDate = accObj.LastModifiedDate;
            wrapObj.recordTypeName = accObj.recordType.Name;


            leadCustwraList.add(wrapObj);

        }
        System.debug('leadCustwraList ' + leadCustwraList);
        return leadCustwraList;

    }




    @AuraEnabled
    public static List < String > downloadCSV(String accData) {
        System.debug('accData ' + accData);
        List < String > csvRowValues = new List < String > ();
        List < LeadAccountListWrapper > accounts = (List < LeadAccountListWrapper > ) JSON.deserialize(accData, List < LeadAccountListWrapper > .class);

        for (LeadAccountListWrapper accObj: accounts) {
            System.debug('accObj adsdas ' + accObj.recordTypeName);

            String accName = accObj.leadCustomerName.replaceAll(',', ' ');
            System.debug('accObj.leadCustomerCode ' + accObj.leadCustomerCode);
            String leadCode = accObj.leadCustomerCode;
            String ownershipUGDN = accObj.ownerUGDNCode;
            String customerType = accObj.customerType;
            String pathFinder = '';
            System.debug('accObj.pathFinder new ' + accObj.pathFinder);
            if (accObj.pathFinder == true) {
                pathFinder = 'Active';
            } else {
                pathFinder = 'Inactive';
            }


            String recordTypeName = accObj.leadCustomerId;

            //String rowStr = recordTypeName+','+accName + ',' + leadCode + ',' + ownershipUGDN + ',' + customerType + ','+ pathFinder;
            String rowStr = recordTypeName + ',' + accName + ',' + leadCode + ',' + ownershipUGDN + ',' + pathFinder;
            System.debug('rowStr in apex ' + rowStr);
            csvRowValues.add(rowStr);

        }

        Sales_Org__c sorg = getSalesOrg();
        String csvColumnHeader;
        //Argentina
        List < Folder > folders = [SELECT Id, Name FROM Folder WHERE Name =: sorg.Name];
        String documentName = 'Lead_Customer_' + sorg.Name + '_' + Datetime.now().format('MMM') + '_' + Datetime.now().year();
        System.debug('documentName ' + documentName);
        csvColumnHeader = 'Updated Record Id,  Lead Customer Name, Lead Code/ SAP Code, UGDN, Path Finder\n';
        String csvFile = csvColumnHeader + String.join(csvRowValues, '\n');
        List < Document > docList = new List < Document > ();

        docList = [Select Id, Name from Document WHERE
            FolderId =: UserInfo.getUserId()
            AND Name =: documentName
        ];
        if (docList.size() > 0) {
            delete docList;
        }


        Document doc = new Document(
            Name = documentName,
            Body = Blob.valueOf(csvFile),
            FolderId = UserInfo.getUserId(),
            Type = 'csv',
            ContentType = 'application/vnd.ms-excel');
        insert doc;

        System.debug('document id is ' + doc.Id);
        String mainUrl = string.valueof(System.Url.getOrgDomainUrl());
        String subUrl = mainUrl.Substring(0, mainUrl.length() - 1);

        String urlResult = subUrl.Substring(14, subUrl.length());
        system.debug('Domain URL is urlResult ' + urlResult);
        List < String > returnList = new List < String > ();
        returnList.add(doc.Id);
        returnList.add(urlResult);
        return returnList;
    }




    @AuraEnabled
    public static String saveFile(String base64Data) {
        Sales_Org__c saOrg = new Sales_Org__c();
        saOrg = getSalesOrg();

        Id leadcustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Lead Customer').getRecordTypeId();
        Id nonleadcustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();

        List < User > userList = new List < User > ();

        MAP < String, String > userMap = new MAP < String, String > ();
        String ctrNm = saOrg.Name;
        if (ctrNm == 'Italy - Domestic') {
            ctrNm = 'Italy';
        } else {
            ctrNm = saOrg.Name;
        }

        System.debug('ctrNm is for checking ');
        userList = [Select Id, Name, UGDN_Number__c, Country From User WHERE Country =: ctrNm];

        System.debug(' for checking userList ' + JSON.serializePretty(userList));
        for (User uObj: userList) {
            userMap.put(uObj.UGDN_Number__c, uObj.Id);
        }

        System.debug(' for checking userMap size ' + userMap.size());
        for (String str: userMap.keySet()) {
            System.debug('for chekcing UGDN is ' + str);
        }

        String data;
        if (Test.isRunningTest()) {
            data = base64Data;
        } else {
            data = JSON.deserializeUntyped(base64Data).toString();
        }

        System.debug('data in csv files ' + data);
        List < String > errorCSVList = new List < String > ();
        List < String > successCSVList = new List < String > ();
        List < String > csvData = new List < String > ();
        String strCSVFile = base64Data;
        list < String > lstCSVLines = data.split('\n');
        csvData = strCSVFile.split('\r\n');

        successCSVList.add('Record Id,' + lstCSVLines[0]);


        errorCSVList.add(lstCSVLines[0] + ',Error Description');
        list < Account > lstACCToUpdate = new list < Account > ();


        String glsPth;
        String tmColName = lstCSVLines[0];
        System.debug('tmColName for checking  ' + tmColName);
        List < String > lstColName = tmColName.split(',');
        System.debug('lstColName sas ' + lstColName);
        Boolean colNameChange;


        if (lstColName[0].trim() == 'Updated Record Id' && lstColName[1].trim() == 'Lead Customer Name' && lstColName[2].trim() == 'Lead Code/ SAP Code' && lstColName[3].trim() == 'UGDN' && lstColName[4].trim() == 'Path Finder') {
            colNameChange = true;
        } else {
            colNameChange = false;
        }

        System.debug('Checking sequesnce of col ' + colNameChange);

        if (colNameChange) {
            for (Integer i = 1; i < lstCSVLines.size(); i++) {
                Account acc = new Account();

                String csvLine = lstCSVLines[i];
                String prevLine = csvLine;
                Integer startIndex;
                Integer endIndex;

                while (csvLine.indexOf('"') > -1) {
                    if (startIndex == null) {
                        startIndex = csvLine.indexOf('"');
                        csvLine = csvLine.substring(0, startIndex) + ':quotes:' + csvLine.substring(startIndex + 1, csvLine.length());
                    } else {
                        if (endIndex == null) {
                            endIndex = csvLine.indexOf('"');
                            csvLine = csvLine.substring(0, endIndex) + ':quotes:' + csvLine.substring(endIndex + 1, csvLine.length());
                        }
                    }

                    if (startIndex != null && endIndex != null) {
                        String sub = csvLine.substring(startIndex, endIndex);
                        sub = sub.replaceAll(',', ':comma:');
                        csvLine = csvLine.substring(0, startIndex) + sub + csvLine.substring(endIndex, csvLine.length());
                        startIndex = null;
                        endIndex = null;
                    }

                } //while loop ended
                System.debug('csvLine col line Name ' + csvLine);
                List < String > csvRowData = new List < String > ();
                for (String column: csvLine.split(',')) {
                    System.debug('column Name is ' + column);
                    column = column.replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                    csvRowData.add(column);
                }

                System.debug('csvRowData colo name ' + csvRowData);

                acc.Id = csvRowData[0];
                if (userMap.containsKey(csvRowData[3])) {
                    System.debug('for checking csvRowData[3] ' + csvRowData[3]);
                    acc.Lead_Customer_Ownership__c = userMap.get(csvRowData[3]);
                }
                else{
                    acc.Lead_Customer_Ownership__c = null;
                }

                /*if(csvRowData[4]!='null'){
acc.Lead_Customer_Type__c = csvRowData[4];    
}*/

                glsPth = csvRowData[4].Trim();
                if (glsPth == 'Active') {
                    acc.Path_Finder__c = true;

                }
                if (glsPth == 'Inactive') {
                    acc.Path_Finder__c = false;

                }
                acc.Phone = '0000000000';


                lstACCToUpdate.add(acc);
            } // first for loop ended


            System.debug('account data for updates ' + JSON.serializePretty(lstACCToUpdate));
            System.debug('account data for updates size ' + lstACCToUpdate.size());
            System.debug('account data for updates size ' + lstACCToUpdate);

         //Batch Class called for Ownership Logic,Mail Sending,Update CSV file etc. By Priyanka(SKI)    
            try {
				BatchLeadCustomerOwnership accountobj = new BatchLeadCustomerOwnership(lstACCToUpdate);
            
        		Database.executeBatch(accountobj, 4);           
             } 
            
            catch (Exception ex) {
                System.debug('Error occure Line Number ' + ex.getLineNumber());
                System.debug('Error occure Line Message ' + ex.getMessage());
            }
            return 'ok';
        } else {

            return 'Colomn sequence can not be changed';

        }


    }

    public static void sendEmail(String successFile, String errorFile, Integer successCount, Integer errorCount, String LeadCustomerUploads) {
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

        DateTime d = Date.Today();
        String dateString = d.format('dd/MM/yyyy');

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        //mail.setToAddresses(new String[] { 'vishal.pawar@skinternational.com'});
        mail.setToAddresses(new String[] {
            UserInfo.getUserEmail()
        });



        mail.setSubject(LeadCustomerUploads);
        mail.setHtmlBody('Dear User,<br /><br />Please find attached files generated in SFDC while uploading the Lead Customer Data <br /><br />Date: ' + dateString + '<br /><br />No. of error records: ' + errorCount + '<br /><br />Regards,<br/>UPL Salesforce Administrator<br />');


        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {
            successAttach,
            errorAttach
        });

        // Send the email
        System.debug('mail after all update values ' + mail);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
            mail
        });
    }




    public static Sales_Org__c getSalesOrg() {
        String country = '';
        //Sales_Org__c salesorg =GTMPathFinder.getSalesOrg() ;
        // System.debug('salesorg in Test Class '+salesorg);

        Sales_Org__c salesorg;


        Login_Country__c loginCountry = null;
        User usr;
        if (Schema.sObjectType.User.isAccessible()) {
            usr = [Select Id, Name, Country from User where id =: userInfo.getUserId()];
        }
        if (usr != null) {
            country = usr.Country;
        }
        if (country == 'Italy') {
            country = 'Italy - Domestic';
        }
        System.debug('for checking country ' + country);
        System.debug('country for Test Class ' + Schema.sObjectType.Login_Country__c.isAccessible());
        if (Schema.sObjectType.Login_Country__c.isAccessible() || Test.isRunningTest()) {
            loginCountry = [Select id, Name, Sales_Org_Code__c from Login_Country__c where Name =: country];
            System.debug('loginCountry for Test Class ' + loginCountry);


        }
        if ((loginCountry != null && Schema.sObjectType.Sales_Org__c.isAccessible()) || Test.isRunningTest()) {
            // System.debug('getSalesOrg '+loginCountry.Sales_Org_Code__c);
            salesorg = [Select id, Name, Sales_Org_Code__c from Sales_Org__c where Sales_Org_Code__c =: loginCountry.Sales_Org_Code__c];
        }
        return salesorg;
    }

    @AuraEnabled
    public static void updateAccountMethod(String accountObjList) {
        try {
            //insert accountObjList;
            //System.debug('accountObjList after save '+accountObjList); 
            Sales_Org__c saOrg = new Sales_Org__c();
            saOrg = getSalesOrg();
            List < User > userList = new List < User > ();
            MAP < String, String > userMap = new MAP < String, String > ();
            //System.debug('saOrg.Name in update '+saOrg.Name);
            String ctrNm = saOrg.Name;
            if (ctrNm == 'Italy - Domestic') {
                ctrNm = 'Italy';
            } else {
                ctrNm = saOrg.Name;
            }
            userList = [Select Id, Name, UGDN_Number__c, Country From User WHERE Country =: ctrNm];

            //System.debug('userList '+userList);
            for (User uObj: userList) {
                userMap.put(uObj.Name.toLowercase(), uObj.Id);
            }

            List < LeadAccountListWrapper > accounts = (List < LeadAccountListWrapper > ) JSON.deserialize(accountObjList, List < LeadAccountListWrapper > .class);
            // System.debug('accounts '+accounts);
            List < Account > accList = new List < Account > ();
            Account accObj;

            for (LeadAccountListWrapper wrpObj: accounts) {
                accObj = new Account();
                accObj.Id = wrpObj.leadCustomerId;

                //accObj.Lead_Customer_Ownership__c = wrpObj.ownerShip;

                // System.debug('wrpObj.ownerShipName '+wrpObj.ownerShipName);
                String owneName;
                if (wrpObj.ownerShipName != null) {
                    owneName = wrpObj.ownerShipName.toLowercase().trim();
                }

                if (userMap.containskey(owneName)) {
                    //System.debug('in true part of ownership');
                    accObj.Lead_Customer_Ownership__c = userMap.get(owneName);
                } else {
                    // System.debug('Else Part of blank');
                    accObj.Lead_Customer_Ownership__c = null;

                }
                //System.debug('wrpObj.customerType '+wrpObj.customerType);
                accObj.Lead_Customer_Type__c = wrpObj.customerType;
                // System.debug('wrpObj.pathFinder '+wrpObj.pathFinder);
                accObj.Path_Finder__c = wrpObj.pathFinder;
                accObj.Phone = '0000000000';
                accList.add(accObj);

            }

            //Updated By Priyanka - Ownership Logic update in Batch class
            BatchLeadCustomerOwnership accountobj = new BatchLeadCustomerOwnership(accList);
            
        	Database.executeBatch(accountobj, 4);



        } catch (Exception exp) {
            System.debug('Error Occure Line Number ' + exp.getLineNumber() + ' '+exp.getStackTraceString() + ' '+exp);
            System.debug('Error Occure message ' + exp.getMessage());
            throw new AuraHandledException(exp.getMessage());
        }
    }
    // New Method added for Update Ownership By Priyanka(SKI)
    public static void updateOwnership(List < Account > accList) {
        List < string > accids = new List < String > ();
        Map < String, Account > accMap = new Map < String, Account > ();
        Set < String > salesRepIds = new Set < String > ();
        Map < String, GTM__c > gtmMap = new Map < String, GTM__c > ();
        List < String > salesRepGtMYetToCreate = new List < String > ();
        for (Account acc: accList) {

           if(acc.Lead_Customer_Ownership__c != null){
                accids.add(acc.id);
                accMap.put(acc.id, acc);
    
                salesRepIds.add(acc.Lead_Customer_OwnerShip__c);
                
            }
        }

        String currentFiscalYear = GTMPathFinder.getFiscalYear();
        List < GTM_details__c > gtmDetails = new List < GTM_details__c > ();
        gtmDetails = [Select id, name, ownerId, GTM_Customer__c,GTM__c,GTM__r.Fiscal_Year__c from GTM_details__c where GTM_Customer__c IN: accids and GTM__r.Fiscal_Year__c=:currentFiscalYear];
		List < GTM__c > gtms = [Select id, name, Sales_Rep__c from GTM__c where Sales_Rep__c IN: salesRepIds and Fiscal_Year__c =: currentFiscalYear];
        
        for (GTM__c g: gtms) {
            gtmMap.put(g.Sales_Rep__c, g);
        }

        for (String salesRep: salesRepIds) {
            if (gtmMap.get(salesRep) == null) {
                salesRepGtMYetToCreate.add(salesRep);
            }
        }
		if(salesRepGtMYetToCreate.size()>0){
			createGTM(salesRepGtMYetToCreate);
		}

        gtms = [Select id, name, Sales_Rep__c from GTM__c where Sales_Rep__c IN: salesRepIds and Fiscal_Year__c =: currentFiscalYear];
        gtmMap.clear();
        for (GTM__c g: gtms) {
            gtmMap.put(g.Sales_Rep__c, g);
        }


        for (GTM_details__c details: gtmDetails) {
            System.debug('Owner Changed'+details);
            details.ownerId = accMap.get(details.GTM_Customer__c).Lead_Customer_OwnerShip__c;
            details.GTM__c = gtmMap.get(details.ownerId).Id;
        }
        System.debug('GTMDetails+++++++' + gtmDetails);
        update gtmDetails;

    }
    //New Method added for GTM Creation by Priyanka(SKI)
    @AuraEnabled
    public static void createGTM(List < String > salesRepGtMYetToCreate) {

        List < User > userDetails = new List < User > ();
        String fiscalYear = GTMPathFinder.getFiscalYear();
        sales_Org__c salesOrg = GTMPathFinder.getSalesOrg();
        List < GTM__C > gtms = new List < GTM__C > ();
        Map < String, User > userMap = new Map < String, User > ();

        userDetails = [SELECT Id, Name, Email,UGDN_Number__c , Profile.Name, UserRole.Id, UserRole.Name FROM User where Id IN: salesRepGtMYetToCreate];
        for (User u: userDetails) {
            userMap.put(u.Id, u);
        }
        for (String salesRep: salesRepGtMYetToCreate) {
            if(userMap.get(salesRep)!=null){
            GTM__c gtm = new GTM__c();
            gtm.fiscal_Year__c = fiscalYear;
            gtm.GTM_Status__c = 'Draft';
            gtm.Role__c = userMap.get(salesRep).UserRole.Name;
            gtm.Sales_Org__c = salesOrg.Id;
            gtm.sales_Rep__c = salesRep;
            gtm.Sales_Rep_Name__c = userMap.get(salesRep).Name;
            gtm.Email__c = userMap.get(salesRep).Email;
            gtm.OwnerId = salesRep;
            gtm.Combination_Key__c = userMap.get(salesRep).UGDN_Number__c + fiscalYear + salesOrg.Sales_Org_Code__c;
            gtms.add(gtm);
            }
        }
        insert gtms;
    }





    //leadCustomerListForSelected
    @AuraEnabled
    public static List < LeadAccountListWrapper > leadCustomerListForSelected(String accId, String ownerId) {
        try {
            //System.debug('select customer accId  '+accId);
            //System.debug('select customer ownerId '+ownerId); 
            List < Account > accList = new List < Account > ();
            if (accId != '' && ownerId == '') {
                accList = [SELECT Id, OwnerId, Name, SAP_Code__c, Path_Finder__c, Lead_Customer__c, Lead_Customer_Ownership__r.Name, Lead_Customer_Created_Date__c,
                    Lead_Customer_Description__c, Lead_Customer_Ownership__c, Lead_Customer_Type__c, LastModifiedBy.Name,
                    LastModifiedById, LastModifiedDate
                    FROM Account WHERE Sales_Org_Code__c =: getSalesOrg().Sales_Org_Code__c
                    AND Id =: accId
                ];
            } else if (accId == '' && ownerId != '') {
                accList = [SELECT Id, OwnerId, Name, SAP_Code__c, Path_Finder__c, Lead_Customer__c, Lead_Customer_Ownership__r.Name, Lead_Customer_Created_Date__c,
                    Lead_Customer_Description__c, Lead_Customer_Ownership__c, Lead_Customer_Type__c, LastModifiedBy.Name,
                    LastModifiedById, LastModifiedDate
                    FROM Account WHERE Sales_Org_Code__c =: getSalesOrg().Sales_Org_Code__c
                    AND(Lead_Customer_Ownership__c =: ownerId)
                ];
            } else {
                accList = [SELECT Id, OwnerId, Name, SAP_Code__c, Path_Finder__c, Lead_Customer__c, Lead_Customer_Ownership__r.Name, Lead_Customer_Created_Date__c,
                    Lead_Customer_Description__c, Lead_Customer_Ownership__c, Lead_Customer_Type__c, LastModifiedBy.Name,
                    LastModifiedById, LastModifiedDate
                    FROM Account WHERE Sales_Org_Code__c =: getSalesOrg().Sales_Org_Code__c
                    AND(Lead_Customer_Ownership__c =: ownerId)
                    AND Id =: accId
                ];

            }





            System.debug('accList select ' + accList);
            System.debug('accList select size ' + accList.size());
            //return accList;


            List < LeadAccountListWrapper > leadCustwraList = new List < LeadAccountListWrapper > ();
            LeadAccountListWrapper wrapObj;
            for (Account accObj: accList) {
                wrapObj = new LeadAccountListWrapper();
                wrapObj.isSelected = false;
                wrapObj.showOnwerLookup = false;
                wrapObj.showOnwerText = true;
                wrapObj.leadCustomerId = accObj.Id;
                wrapObj.leadCustomerName = accObj.Name;
                wrapObj.leadCustomerCode = accObj.SAP_Code__c;
                wrapObj.ownerShip = accObj.Lead_Customer_Ownership__c;
                if (accObj.Lead_Customer_Ownership__r.Name != null) {
                    wrapObj.ownerShipName = accObj.Lead_Customer_Ownership__r.Name;
                } else {
                    wrapObj.ownerShipName = '';
                }

                wrapObj.customerType = accObj.Lead_Customer_Type__c;
                wrapObj.pathFinder = accObj.Path_Finder__c;
                wrapObj.lastModifiedByName = accObj.LastModifiedBy.Name;
                wrapObj.lastModifiedDate = accObj.LastModifiedDate;
                leadCustwraList.add(wrapObj);

            }

            return leadCustwraList;



        } catch (Exception exp) {
            throw new AuraHandledException(exp.getMessage());
        }

    }

   
    //New Method added for Account Sharing Logic by Priyanka(SKI)
    public static void manualShareRead(List<Account> accounts){
        List<AccountShare> accountSharings = new List<AccountShare>();
        for(Account acc:accounts){
            AccountShare shareObj = new AccountShare();
            shareObj.AccountId = acc.Id;
            shareObj.UserOrGroupId = acc.Lead_customer_Ownership__c;
            shareObj.AccountAccessLevel = 'Read';
           // shareObj.ContactAccessLevel  = 'Read';
            shareObj.OpportunityAccessLevel  = 'Read';
            shareObj.RowCause = 'Manual';
            accountSharings.add(shareObj);
        }
        Database.SaveResult[] saveResultList =  Database.insert(accountSharings, false);
        System.debug('SaveResult '+accountSharings);
        for (Database.SaveResult sr : saveResultList) {
            if (sr.isSuccess()) { 
                System.debug('Successfully inserted account. Account ID: ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('Error: The following error has occurred.');                    
                    System.debug('Error: '+err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Error: Account fields that affected this error: ' + err.getFields());
                }
            }
        }
        
    }

    public static void removeManualShare(List<Account> accounts){
        List<AccountShare> accountShares = new List<AccountShare>();
        Map<String,Accountshare> shareMap = new Map<String,Accountshare>();
        List<Accountshare> shareToRemove = new List<Accountshare>();
        List<String> accountIds = new List<String>();
        for(Account acc:accounts){
            accountIds.add(acc.Id);
        }
        
        accountShares = [select id,AccountId,UserOrGroupId,RowCause from AccountShare where AccountId IN:accountIds and RowCause='Manual'];
        
        System.debug('share size'+accountShares);
        for(AccountShare share:accountShares){
            shareMap.put(share.UserOrGroupId+''+share.AccountId+''+share.RowCause,share);
        }
        System.debug('Hello '+accountIds);
        for(Account acc:accounts){
            AccountShare share = shareMap.get(acc.Lead_Customer_Ownership__c+''+acc.Id+'Manual');
            if(share!=null){   
                shareToRemove.add(share);
            }
        }
        System.debug('shareToRemove '+shareToRemove.size());
        System.debug('shareToRemove list'+shareToRemove);
        if(shareToRemove.size()>0){
        delete shareToRemove;
        }
    }

    // wrapper class with @AuraEnabled and {get;set;} properties 
    public class LeadAccountListWrapper {

        @AuraEnabled
        public Boolean isSelected {get;set;}

        @AuraEnabled
        public Integer index {get;set;}

        @AuraEnabled
        public String leadCustomerId {get;set;}

        @AuraEnabled
        public String leadCustomerName {get;set;}

        @AuraEnabled
        public String leadCustomerCode {get;set;}

        @AuraEnabled
        public String ownerShip {get;set;}

        @AuraEnabled
        public String ownerUGDNCode {get;set;}

        @AuraEnabled
        public String ownerShipName {get;set;}

        @AuraEnabled
        public String customerType {get;set;}

        @AuraEnabled
        public Boolean pathFinder {get;set;}

        @AuraEnabled
        public String lastModifiedByName {get;set;}

        @AuraEnabled
        public DateTime lastModifiedDate {get;set;}

        @AuraEnabled
        public String recordTypeName {get;set;}

        @AuraEnabled
        public Boolean showOnwerLookup {get;set;}

        @AuraEnabled
        public Boolean showOnwerText {get;set;}

        @AuraEnabled
        public Boolean forLeadCust {get;set;}

        @AuraEnabled
        public Integer selectCnt {get;set;}




        public LeadAccountListWrapper() {
            isSelected = false;
            showOnwerLookup = false;
            showOnwerText = true;
            forLeadCust = false;
            selectCnt = 0;
        }
    }

}