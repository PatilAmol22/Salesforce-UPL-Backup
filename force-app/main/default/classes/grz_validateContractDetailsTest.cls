/**************************************************************************************************
* Name             : grz_validateContractDetailsTest                                                     
* Description      : To cover the Apex class grz_validateContractDetails					 
* Created Date     : 19-01-2023                                                                       
* Project/JIRA     : UPL                                                                 
* Created By       : Ranjeet Sharma  (Grazitti)                                                                        
* Last Modified By : Ranjeet Sharma (Grazitti) 19-01-2023                                                                     
**************************************************************************************************/
@isTest
public class grz_validateContractDetailsTest {
    @istest static void createTemplateTest(){
        
        Sales_Org__c objSalesOrg = new Sales_Org__c();
        objSalesOrg.Name = 'test1';
        objSalesOrg.Sales_Org_Code__c = '3710';
        insert objSalesOrg;
        
        
        Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Account objAcc = new Account();
        objAcc.RecordTypeId = stExam;
        objAcc.Name = 'Test';
        objAcc.Sales_Org__c = objSalesOrg.Id;
        objAcc.Email__c='taruni.uce@test.com';
        objAcc.GST_Validated__c=True;
        insert objAcc;
        
        Contact con = new Contact();
        con.LastName = 'abc';
        con.firstName = 'lastName';
        con.AccountId = objAcc.id;
        con.Phone='12223';
        insert con;
        
        
        
        Division__c objDiv = new Division__c();
        objDiv.Name = 'Testing';
        objDiv.Division_Code__c = '20';
        insert objDiv;
        
        Distribution_Channel__c objDivChannel = new Distribution_Channel__c();
        objDivChannel.Name = 'Testt';
        objDivChannel.Distribution_Channel_Code__c = '10';  
        insert objDivChannel;
      
        
        DistributorSalesAreaMapping__c objSalesArea = new DistributorSalesAreaMapping__c();
        objSalesArea.AccountType__c = 'Bill To Party';
        objSalesArea.Distributor__c = objAcc.Id;
        objSalesArea.Division__c = objDiv.Id;
        objSalesArea.DistributionChannel__c = objDivChannel.Id;
        objSalesArea.SalesOrg__c = objSalesOrg.Id;
        objSalesArea.Stage__c='Pending with customer';      
        objSalesArea.First_Approver__c= userinfo.getUserId();  
        insert objSalesArea;
        
        
        
        
        echosign_dev1__SIGN_Agreement__c agrmt = new echosign_dev1__SIGN_Agreement__c ();
        agrmt.Name = 'Test Agreement Send Auto '+system.now();
        agrmt.echosign_dev1__Message__c = 'test from anonymous block';
        agrmt.echosign_dev1__SignatureOrder__c = 'Recipient signs, then I sign';
        agrmt.echosign_dev1__SignatureType__c = 'e-Signature';
        agrmt.echosign_dev1__Signature_Flow__c = 'Order Entered';
        agrmt.echosign_dev1__SenderSigns__c = true;
        agrmt.echosign_dev1__Recipient_Addresses__c = 'xxxxx@gmail.com,';
        agrmt.Sales_Area__c=objSalesArea.Id;
        agrmt.echosign_dev1__ErrorMessage__c='error passed';
        agrmt.echosign_dev1__Status__c = 'Out for Signature';
        agrmt.echosign_dev1__Background_Action__c = 'Send';
        insert agrmt;
        
        
        
     
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
       
        List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        System.assertEquals(cvList.size(), 1);
        

        List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        System.assertEquals(cdList.size(), 1);
        
        ContentDocumentLink contentDocument = new ContentDocumentLink();
        contentDocument.ContentDocumentId = cdList[0].id;
        contentDocument.LinkedEntityId = agrmt.id;
        contentDocument.Visibility = 'AllUsers';
        upsert contentDocument;
        
        Echosign_Dev1__SIGN_Recipients__c asdasd = new Echosign_Dev1__SIGN_Recipients__c();
        asdasd.echosign_dev1__Agreement__c = agrmt.Id;
        asdasd.echosign_dev1__Contact__c = con.id;
        asdasd.echosign_dev1__Recipient_Role__c = 'Signer';
        asdasd.echosign_dev1__Recipient_Type__c = 'Contact';
        asdasd.echosign_dev1__Order_Number__c = 1;
        
        insert asdasd;
         System.debug('agrmt??'+agrmt);
         grz_validateContractDetailsTest.getTemplateDetailsTest(agrmt.Id);
 
         echosign_dev1.EchoSignApiService.SendDocumentResult.sendDocument(agrmt.Id);
        try{              
            grz_validateContractDetails.createTemplate(objSalesArea.id,objAcc.id);
            
        }catch(Exception e) 
        {
           
        }
    }
    
    static void getTemplateDetailsTest(id agreementIdd){
        echosign_dev1__SIGN_Agreement__c agrement = new echosign_dev1__SIGN_Agreement__c ();
        agrement.id=agreementIdd;
        agrement.echosign_dev1__ErrorMessage__c='error passed202';
        Update agrement;
        System.debug('agrement??'+agrement);
        try{         
            grz_validateContractDetails.getTemplateDetails(agrement.Id);
        }catch(Exception e) 
        {
            System.debug('ero22>>'+e);
        }
        
    }
    
}