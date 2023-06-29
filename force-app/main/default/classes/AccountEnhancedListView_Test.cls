@isTest
public class AccountEnhancedListView_Test{
    
    public  static TestMethod  void  showAccount(){
        
        Id RecordTypeIdContact = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();

        Account accObj = new Account(
              Name = 'AKASH KRUSHI KENDRA',
              Last_Name__c = 'AKASH KRUSHI KENDRA - MANDRUP',       // Last Name
               recordtypeid=RecordTypeIdContact,                // Mobile
              OwnersetbyProcess__c = true,                          // Owner set by Process
              Photograph__c = false,  
              Security_cheque_scan__c = false,                      // Security cheque scan
              Copy_of_PesticideSeed_License__c = false,             // Copy of Pesticide / Seed License
              GST_Certificate__c = false,                           // GST Certificate
              CopyofPartnershipfirmcompanyHUFPro__c = false,        // Copy of Partnership firm/company/HUF/Pro
              Signed_business_policy__c = false,                    // Signed business policy
              One_Blank_Letter_Pad_for_address_proof_o__c = false,  // One Blank Letter Pad for address proof o
              Order_Block__c = false,                               // Order Block
              Status__c = 'Active',                                 // Status
              Zone__c = 'Pune',                                     // Zone
              Cust_Group__c = '189',                                // Customer Group
              Territory_Code__c = '189',                            // Territory Code
              ApprovedbyRegionalManager__c = false,                 // Approved by Regional Manager
              ApprovedbyZonalHead__c = false,
              ApprovalStatus__c = 'Draft'                          // Approval Status
        );
        insert accObj;
        
         Contact con = new Contact(LastName ='testCon',AccountId = accObj.Id);
        insert con;  
                  
        User userObj= new User(
                                                             // Role
  Alias = 'padm',
  LastName ='upltest',                                                                       // Alias
  Email = 'pravin.jagadale@skinternational.com.upltest',                                // Email
 ProfileId =  [SELECT Id FROM Profile WHERE Name ='PartnerCommunity Distributor Profile'].Id,                                                                  // Profile
  Username = 'distributor@skinternational.com',                                 // Username
  IsActive = true,                                                                      // Active
  CommunityNickname = 'prashant',  // Nickname
  ContactId = con.id,                                                                // Contact
  TimeZoneSidKey = 'Asia/Kolkata',                    // Time Zone
  LocaleSidKey = 'en_US',                                             // Locale
  LanguageLocaleKey = 'en_US',                                                        // Language
  ForecastEnabled = false,                                                              // Allow Forecasting
  EmailEncodingKey = 'UTF-8',           // Email Encoding
  Territory__c = 'KODAD',                                                               // Territory
  Zone__c = 'Hyderabad',                                                                // Zone
  EnableDepot__c = false,                                                               // Enable Depot
  Show_List_Value__c = false,                                                           // Show List Value (Brazil)
  Show_Credit_Limit__c = false,                                                         // Show Credit Limit
  Show_Inventory__c = false,                                                            // Show Inventory
  Show_Pricing__c = false,                                                              // Show Pricing
  Show_Inventory_Column__c = false,                                                     // Show Inventory Column
  Show_InTransit__c = false,                                                            // Show InTransit
  Show_InTransit_Values__c = false                                                     // Show InTransit Values
);
insert userObj;
        
        
    
        system.runAs(userObj){
        AccountEnhancedListView accEnhLstObj = new AccountEnhancedListView();
        }
    
    }
    
    
}