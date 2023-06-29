/*
* Class Name - NebulizationPageControllerTest
* Created Date - 6th JAN, 2023
* Author - Abhinay
* Description - Created for testing NebulizationApplicationPageController class. 
* */

@isTest
public class NebulizationPageControllerTest {
    @isTest
    public static void CustomerVisitTestData()
    {
        Id recordTypeId = Schema.SObjectType.Customer_Visit__c.getRecordTypeInfosByName().get('FR NeoFog teams').getRecordTypeId();
        System.debug(recordTypeId);
        Account acc = new Account();
        	acc.Name = 'Kvp';
        insert acc;
        
        Contact con = new Contact();
        	con.FirstName = 'Kvp';
        	con.LastName = 'Test';
        insert con;
        
        Customer_Visit__c CustVisit = new Customer_Visit__c();
        CustVisit.RecordTypeId = recordTypeId;
        
            CustVisit.Customer_Name__c = acc.Id;
            CustVisit.Interlocutor__c = con.Id;
            CustVisit.Destination__c = 'Frais';
            CustVisit.Site_Visit__c = 'OUI';
        	CustVisit.Humidity__c = 123 ;
        	CustVisit.Earth__c = 123 ;
        	CustVisit.Strokes__c = 123 ;
        	CustVisit.Germination_1mm__c = 123;
        	CustVisit.Germination_1mmm__c = 123;
        	CustVisit.Germination_white_dots__c = 123;
        	CustVisit.Tubers_temp__c = 12;
        	CustVisit.Building_fill_level__c = 12345;
        	CustVisit.Storage_time_month__c = '12';
        	CustVisit.Batch_number__c = '123456789012345678901234567890123456789012345';
        	CustVisit.Equipment__c = 'Crop Fog F';
            CustVisit.Variety__c = '123456789012345678901234567890123456789012345';
            CustVisit.Product__c = 'OZONE';
            CustVisit.Nebulizated_qtty__c = 12345;
            CustVisit.Applied_dose__c = 123;
            CustVisit.Treatment__c = 'T1';
        	CustVisit.Refrigeration_Stop_Date__c = Date.newInstance(2022,11,1);
        	CustVisit.Refrigeration_stop_time__c = Time.newInstance(1,22,5,5);
        	CustVisit.Remark__c = 'aaaaaaaaaa,aaaaaaaa,aaaaaaaaaa,aaaaaaaaaaa,aaaaaaaaaaaa,aaaaaaaaaa,ccccccc,cccccccc,ccccccc,ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc';
        insert CustVisit;
        
        //Added save
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Test'); 
        content.VersionData=bodyBlob;
        //content.LinkedEntityId=sub.id;
        content.origin = 'H';
        //insert content;
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=CustVisit.id;
        //contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        //insert contentlink;
        
        // End save
         PageReference pageRef = Page.NebulizationApplicationPage;
            pageRef.getParameters().put('Id',CustVisit.Id);
            Test.setCurrentPage(pageRef);
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(CustVisit);
        NebulizationApplicationPageController ob = new NebulizationApplicationPageController(sc);
        //ob.currentRecordId=pageRef.getParameters().get('Id');
        
        ob.FetchData(String.valueOf(CustVisit.id));
        
        PageReference pageRef2 = Page.NebulizationApplicationPage;
        NebulizationApplicationPageController ob2 = new NebulizationApplicationPageController(sc);
        pageRef2.getParameters().put('Id',CustVisit.Id);
        ob2.Cancel();
        
        PageReference pageRef3 = Page.NebulizationApplicationPage;
        NebulizationApplicationPageController ob3 = new NebulizationApplicationPageController(sc);
        pageRef3.getParameters().put('Id',CustVisit.Id);
        ob3.pdfAction();
        
        Customer_Visit__c CustVisit2 = new Customer_Visit__c();
        CustVisit2.RecordTypeId = recordTypeId;
        
            CustVisit2.Customer_Name__c = acc.Id;
            CustVisit2.Interlocutor__c = con.Id;
            CustVisit2.Destination__c = 'Frais';
            CustVisit2.Site_Visit__c = 'OUI';
            CustVisit2.Variety__c = '1';
            CustVisit2.Product__c = 'OZONE';
            CustVisit2.Nebulizated_qtty__c = 2;
            CustVisit2.Applied_dose__c = 1;
            CustVisit2.Treatment__c = 'T1';
        	CustVisit2.Refrigeration_Stop_Date__c = Date.newInstance(2022,11,1);
        	CustVisit2.Refrigeration_stop_time__c = Time.newInstance(1,22,5,5);
        	CustVisit2.Remark__c = 'aaaaaaaaaa,aaaaaaaa,aaaaaaaaaa,aaaaaaaaaaa,aaaaaaaaaaaa,aaaaaaaaaa,ccccccc,cccccccc,ccccccc,ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc';
        insert CustVisit2;
        
        PageReference pageRef4 = Page.NebulizationApplicationPage;
        NebulizationApplicationPageController ob4 = new NebulizationApplicationPageController(sc);
        pageRef4.getParameters().put('Id',CustVisit2.Id);
        ob4.pdfAction();

    }
}