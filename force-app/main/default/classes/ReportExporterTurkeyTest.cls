@isTest
public class ReportExporterTurkeyTest {
    
    static testMethod void ExporterCheck(){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Report_Exporter__c re = new Report_Exporter__c();
        re.Attachment_Name__c = 'New Report for Sales Orders Turkey';
        re.Email_Content__c = 'Details';
        re.Email_Recipients__c = 'hash@gmail.com';
        re.Email_Subject__c = 'Report for Sales Orders Turkey';
        re.Name = 'New Report';
        re.Frequency__c = 'Daily';
        re.Report_Id__c = '656rytytryt';
        re.Type__c = 'Sales Order-Turkey';
        insert re;
        
        Trigger_Settings__c t =new Trigger_Settings__c ();
        t.Name ='SOLICombKeyTrigger';
        t.IsActive__c = true;
        INSERT t;
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Turkey';
        sorg.Description__c='Turkey';
        sorg.Sales_Org_Code__c='7110';
        insert sorg;
        
        Distribution_Channel__c disbj = new Distribution_Channel__c();
        disbj.Name = 'Depot';                      
        disbj.Distribution_Channel_Code__c = '20';  
        disbj.Description__c='test';
        insert disbj;
        
        Division__c Divbj = new Division__c();
        Divbj.Name = 'Agro Formulation';         
        Divbj.Description__c = null;    
        Divbj.Division_Code__c = '10'; 
        insert Divbj;
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Order_Type__c  SampleorderType = new Order_Type__c(
            Name = 'ZTO0',                  // Order Type Name  
            Description__c = 'Free Samples',     // Description
            Order_Type_Code__c = 'ZTO0',      // Order Type Code
            SalesOrg__c = sorg.Id  // Sales Org
        );
        insert SampleorderType;
        
        Order_Type__c  SampleorderType1 = new Order_Type__c(
            Name = 'ZTF0',                  // Order Type Name  
            Description__c = 'Free Samples',     // Description
            Order_Type_Code__c = 'ZTF0',      // Order Type Code
            SalesOrg__c = sorg.Id  // Sales Org
        );
        insert SampleorderType1;
        
        Account acc = new Account();
        acc.Name='Harshitha';
        acc.Last_Name__c='UdayKumar';
        acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP000004';
        acc.Order_Block__c = false;  
        acc.Account_Type__c = 'Sold To Party';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='9867213275';
        acc.Phone='98745632';
        acc.Sales_Org__c=sorg.Id;
        acc.Division__c=Divbj.Id;
        acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity= '35210 Alsancak / IZMIR';
        Insert acc;
        
        Shipping_Location__c shippLoc =new Shipping_Location__c();
        shippLoc.Location_Name__c ='IZMIR GÜMRÜK MÜDÜRLÜGÜ'; 
        shippLoc.Region__c='S.No:46/1, A1 Building, First Floor, Office No.101 E-Space, Wadgoan Sheri,Nagar Rd, Aga Nagar,';
        shippLoc.Distributor__c=acc.Id;
        shippLoc.City__c='IZMIR, TURKEY';
        shippLoc.Sales_Org__c=sorg.Id;
        shippLoc.Sold_To_Party_SAP_Code__c=acc.SAP_Code__c;
        shippLoc.SAP_Code__c='SAP0dd001';
        shippLoc.State__c='turkey';
        insert shippLoc;
        
        Sales_Order__c soObj = new Sales_Order__c(
            //   RecordType = '0120k0000000ZbF',                // Record Type
            SFDC_Order_Number__c = '01000',                  // SFDC Order Number
            Order_Raise_By__c = 'District Manager',          // Order Raised By
            Order_Status__c = 'In Transit',  
            Remarks__c = 'DomesticSalesSK',// Order Status
            Order_Date__c = system.today(),
            Division_lk__c = Divbj.Id,             			  // Division
            Distribution_Channel_lk__c = disbj.Id, 			  // Distribution Channel
            Order_Type_lk__c = SampleorderType.Id,         	          // Order Type
            Sold_to_Party__c = acc.Id,           			  // Sold to Party
            Bill_To_Party__c = acc.Id,          			  // Bill To Party
            Ship_To_Party__c = shippLoc.Id ,     		      // Ship To Party
            CreatedFrom__c = 'SFDC', 
            Sales_Org_lk__c = sorg.Id // Created From
        );
        insert soObj;
        
        Sales_Order__c soObj1 = new Sales_Order__c(
            //  RecordType = '0120k0000000ZbF',             // Record Type
            SFDC_Order_Number__c = '01000',                  // SFDC Order Number
            Order_Raise_By__c = 'District Manager',          // Order Raised By
            Order_Status__c = 'In Transit',  
            Remarks__c = 'DomesticSalesSK',// Order Status
            Order_Date__c = system.today(),
            Division_lk__c = Divbj.Id,             			  // Division
            Distribution_Channel_lk__c = disbj.Id, 			  // Distribution Channel
            Order_Type_lk__c = SampleorderType1.Id,         	  // Order Type
            Sold_to_Party__c = acc.Id,           			  // Sold to Party
            Bill_To_Party__c = acc.Id,          			  // Bill To Party
            Ship_To_Party__c = shippLoc.Id ,     		      // Ship To Party
            CreatedFrom__c = 'SFDC', 
            Sales_Org_lk__c = sorg.Id                         // Created From
        );
        insert soObj1;
		Test.startTest();
		ReportExporterTurkey  sch2 = new ReportExporterTurkey();
		String sch = '0 05 14 * * ?';
		system.schedule('One Time Pro', sch, sch2); 
        Test.stopTest();
    }
}