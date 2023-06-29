@isTest
private class FrContract_TestClass {
  @testSetup
    static void testDataM() {
	Id devRecordAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
	Account accObj = new Account(
            Name = 'BAM test',                                          // Account Name
            RecordTypeId = devRecordAcc,                                // Account Record Type
            Last_Name__c = 't',                                         // Last Name
            SAP_Code__c = '0001023194',                                 // SAP Customer Code
            Mobile__c = '1234567980' 
			);
	insert accObj;
	
	Contact con = new Contact(
	         lastName = 'test t',
             AccountId = accObj.id,
			 CurrencyIsoCode = 'EUR'
                              );
	insert con;
	
	Contract_management__c contr = new Contract_management__c(
	         Customer_Account__c = accObj.id,
			 Contact__c = con.id,
			 Contract_Type__c = 'CPS',
			 Contract_Start_Date__c = System.today(),
			 Contract_End_Date__c = System.today()
	);
	insert contr;		
	}
    
	@isTest 
      static void testsendContractEmailmethod() {  
      list<Contract_management__c> queryCon= new list<Contract_management__c>();
	  list<Contract_management__c> upCon= new list<Contract_management__c>();
	  list<id> contractIds = new list<id>();
	  list<ContentDocumentLink> doclink = new list<ContentDocumentLink>();
          queryCon = [select id,name,Legal_Person_Email__c,Customer_Account__c,Contact__c,Contract_Type__c,Contract_Start_Date__c,Contract_End_Date__c,Status__c from Contract_management__c limit 1 ];
	
	for(Contract_management__c cc: queryCon){
	ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        content.origin = 'H';
        insert content;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=cc.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
		doclink.add(contentlink);
		
	cc.Status__c='Sales Manager Approved';
	upCon.add(cc);
	contractIds.add(cc.id);
	}
	
	Test.startTest();
    insert doclink;	
	update upCon;
	FrContractLegalApprovalMail.sendContractEmail(contractIds);
	Test.stopTest();
      }
    @isTest 
        static void testContractEmailServiceMethod(){
         string cid;
         Contract_management__c queryC = [select id,name,Legal_Person_Email__c,Customer_Account__c,Contact__c,Contract_Type__c,Contract_Start_Date__c,Contract_End_Date__c,Status__c from Contract_management__c limit 1 ];
         cid=queryC.name;

        list<string> approvalString = new list<string>();
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        FRContractEmailServiceClass contractClassObj = new FRContractEmailServiceClass();
        
        email.plainTextBody = 'APPROVED\n ok\n 0090';
        email.fromAddress =system.label.France_Legal_Person_Email;
        email.subject = cid;
        
        
        contractClassObj.handleInboundEmail(email, envelope);
    }
    
    @isTest 
        static void testContractTriggerMethod(){
		Contract_management__c queryT = [select id,name,Legal_Person_Email__c,Contract_Attached__c,Customer_Account__c,Contact__c,Contract_Type__c,Contract_Start_Date__c,Contract_End_Date__c,Status__c from Contract_management__c limit 1 ];
            try{
            queryT.Contract_Attached__c=true;
		update queryT;
		}
            catch(Exception e){
                system.debug('$Exception : '+e.getMessage());
            }

        }
}