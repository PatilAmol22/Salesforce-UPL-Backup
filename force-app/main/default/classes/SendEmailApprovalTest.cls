@isTest
public class SendEmailApprovalTest {
    @TestSetup
    public static void createdata(){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c sorg = new Sales_Org__c();
        sorg.Name='Brazil';
        sorg.Description__c='Brazil';
        sorg.Sales_Org_Code__c='5191';
        insert sorg;
        
        Profile profAdmn = [SELECT Id,name FROM Profile WHERE Name = 'Brazil Sales District Manager'];
        userrole  usrole = new userrole();
        usrole.Name ='CUSTOMER SERVICE ANALYST';
        
        User userAdmn = new User(
            Alias = 'admin',                                                            
            Email = 'skiadmin@skinternational123.com',                             
            ProfileId  = profAdmn.Id,                                                     
            Username = 'admin@upl122333.com.devbox',                                    
            IsActive = true,  
            LastName='Admin',
            CommunityNickname = 'AdminExe1222 Di', 
            TimeZoneSidKey = 'Asia/Kolkata', 
            LocaleSidKey = 'en_IN',                                    
            LanguageLocaleKey = 'en_US',                                             
            ForecastEnabled = false,                                                     
            EmailEncodingKey = 'ISO-8859-1',    
            Show_Inventory__c = false,                                                     
            Show_Credit_Limit__c = false, 
            UserRoleId=usrole.id,
            Country = 'Brazil'
        );
        insert userAdmn;
        
         Account acc = new Account(
            Name = 'MAURICIO BERNARDO X',// Account Name
            SAP_Code__c = '0001419276',                                     // SAP Customer Code
            Mobile__c = '000000000000000000',                               // Mobile
            Email__c = 'mauri@xxx.com',                            // Email
            Order_Block__c = false,                                         // Order Block
            Sales_Org__c = sorg.id,                               // Sales Org
            taxjurcode__c = 'GO 5218805',                                   // taxjurcode
            TaxNumber2__c = '12031688880',                                  // Tax Number 2
            Account_Type__c = 'Sold To Party',                              // Account Type
            Final_Approval_Date__c = system.today(),             // Final Approval Date
            Customer_Group__c = '069',                                      // Customer Group(Attribute 6)
            Last_Name__c = 'MAURICIO BERNARDO SCHOLTEN E OUTROS',           // Last Name
            OwnersetbyProcess__c = false,                                   // Owner set by Process
            RecordTypeId = devRecordTypeId                                     // Account Record Type
        );
        insert acc;
        
        RSO_Return_Sub_Status__c rss = new RSO_Return_Sub_Status__c();
        rss.Sub_Return_Type_Code__c='st123';
        insert rss;
        
        Return_Sales_Order__c rso1=new Return_Sales_Order__c();
        rso1.Customer__c=acc.Id;
        rso1.SFDC_Order_Number__c='test12345';
        rso1.Order_Status__c='Approved';
        rso1.Sub_Status__c='Pending At Collection';
        rso1.Return_Sub_Type__c=rss.Id;
        rso1.Refusal__c='No';
        rso1.RSO_Raised_By__c='Sales District Manager';
        rso1.Sales_District_Manager__c=userAdmn.Id;
        rso1.Logistics_Operator_Email__c='abc@gmail.com;amol.patil@skinternational.com';
        rso1.Sales_Office_Manager__c=userAdmn.Id;
        rso1.Sales_Director__c=userAdmn.Id;
        rso1.Credit_Analyst__c=userAdmn.Id;
        insert rso1;
      
    }
    
    @isTest
    public static void sendEmailApprovaltest1(){ 
        List<Return_Sales_Order__c> rsorecord = [SELECT Id FROM Return_Sales_Order__c];
        system.debug('rsorecord.id'+rsorecord[0].Id);
        system.debug('Record 1=='+rsorecord);
        List<Id> rsoList=new List<Id>();
        rsoList.add(rsorecord[0].Id);
        test.startTest();
        SendEmailApproval.sendEmailToOperator(rsoList);
        test.stopTest();
    }
   /*  @isTest
    public static void sendEmailApprovaltest2(){
      List<Return_Sales_Order__c> rsorecord = [SELECT Id FROM Return_Sales_Order__c];
        system.debug('Record 2=='+rsorecord);
        test.startTest();
        SendEmailApproval.sendEmailToOperator(new List<Id>{rsorecord[0].Id});
        
        test.stopTest();
    }*/
    
}