@isTest
public class SalesData_test {
    
    static testMethod void method(){
        SalesOrgCode__c us = new SalesOrgCode__c();
        us.Name = 'France';
        us.Code__c = '2710';
        insert us;
        
        // setup controller object
        Account acc = TestDataFactory.CreateAccount('0001033509');
        acc.Combination_Key__c='00010335080001033508';
        update acc;
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='France';
        sorg.Description__c='France';
        sorg.Sales_Org_Code__c='2710';
        insert sorg;
        acc.Sales_Org__c = sorg.Id;
        update acc;
        SKU__c sk = new SKU__c();
        sk.SKU_Code__c='000000000006250320';
        sk.name='Pesticides';
        sk.Product_Campaign__c='C05';
        sk.Sales_Org__c=sorg.ID;
        insert sk;
        
        
        Account acc1 = TestDataFactory.CreateAccount('0001033508');
        acc1.Sales_Org__c = sorg.Id;
        update acc1;
        
        SKU__c sk1 = new SKU__c();
        sk1.SKU_Code__c='000000000006250321';
        sk1.name='Pesticides';
        sk1.Product_Campaign__c='C05';
        sk1.Sales_Org__c=sorg.ID;
        insert sk1;
        
        SalesOrgCode__c customsorg = new SalesOrgCode__c(Name ='France', Code__c = '2710',paddingsapcode__c='10',paddingsku__c='18'); 
        insert customsorg;
        
        
        SalesData objconfirm = new SalesData();
        System.debug('Debug Email Service');
        
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        objconfirm.handleInboundEmail(email, envelope);
        
        email.subject = 'france sales data';
        email.plainTextBody = 'This is a test mail.';
        email.fromAddress='diwanshsethi@ggmail.com';
        envelope.fromAddress = 'upl@uniphos.com';
        
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'france sales data.txt';
        String csvAttachment = 'Customer number,Material,Product Campaign,Date,LY Compaign,CY Compaign,LY FY Campaign,FY Compaign\r\n1033508,6250320,C10,20200302,0,0,46200,0\r\n1016541,568103,C10,20200302,0,0,46200,0\r\n';
        
        binaryAttachment.body = Blob.valueOf(csvAttachment);
        //binaryattachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { binaryattachment };
            objconfirm.handleInboundEmail(email, envelope);
        
        Messaging.InboundEmailResult result = objconfirm.handleInboundEmail(email, envelope);
        
        String csvAttachment1 = 'Customer,Ship-to Code,Material,Product Campaign,Date,LY Compaign,CY Compaign,LY FY Campaign,FY Compaign\r\n1033508,1033508,6250321,C10,20200302,0,0,46200,0\r\n1016541,1033508,568103,C10,20200302,0,0,46200,0\r\n';
        list<SalesDataReadandPopulateBatch.errorWrapper> lst = new list<SalesDataReadandPopulateBatch.errorWrapper>(); 
        lst= FileUtilitySalesData.processSalesDataShipTo(csvAttachment1);
        //System.assertEquals( result.success  ,true);
        
        
    }
    
}