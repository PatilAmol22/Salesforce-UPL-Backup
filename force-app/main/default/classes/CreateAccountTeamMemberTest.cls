@isTest
public class CreateAccountTeamMemberTest
{
    public static testMethod void test1()
    {
        Trigger_Settings__c tsObj = new Trigger_Settings__c();
        tsObj.Name = 'atmTrigger';
        tsObj.isActive__c = True;
        insert tsObj;
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id devRecordAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id devRecordDepot = Schema.SObjectType.Depot__c.getRecordTypeInfosByName().get('Depot').getRecordTypeId();
        
        userrole  usrole = new userrole();
        usrole.Name ='Sales Agent Italy New';
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Sales Agents Italy'];

        User usr = new User();
        usr.Alias = 'zonaa';                                                            
        usr.Email = 'skim@skinternational123.com';                             
        usr.ProfileId  = p.ID;                                                     
        usr.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        usr.IsActive = true;  
        usr.LastName='Terriotory Manager';
        usr.CommunityNickname = 'zonalExe1222 Di'; 
        usr.TimeZoneSidKey = 'Asia/Kolkata'; 
        usr.LocaleSidKey = 'en_IN';                                    
        usr.LanguageLocaleKey = 'en_US';                                             
        usr.ForecastEnabled = false;                                                     
        usr.EmailEncodingKey = 'ISO-8859-1';    
        usr.Show_Inventory__c = false;                                                     
        usr.Show_Credit_Limit__c = false; 
        usr.UserRoleId=usrole.id;
        usr.Marketing_Manager__c=UserInfo.getUserId();
       // usr.ContactId=con.Id;
        insert usr; 
        
        //Data for Sales Org
        Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'Italy',           // Sales Org Name
            Company_Code__c = '2400',      // Company Code
            Sales_Org_Code__c = '2410',    // Sales Org Code
            Country_Code__c = 'IT'        // Country Codes
        );
        insert salesOrgObj;
        
        //Data for Division
        Division__c DivisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert DivisionObj;
        
        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZZCQ';              
        ordType.Order_Type_Code__c = 'ZZCQ';
        ordType.SalesOrg__c = salesOrgObj.Id;
        insert ordType;
        
        //Data for Distribution Channel
        Distribution_Channel__c DistributionChannelObj = new Distribution_Channel__c(
            Name = '20',                        // Distribution Channel Name
            Distribution_Channel_Code__c = '20',  // Distribution Channel Code
            Description__c='test'
        );
        insert DistributionChannelObj;
        
       
        
        //Data for Payment Term
        
        Payment_Term__c paymentTermObj = new Payment_Term__c(
            Payment_Term__c = 'Net 7 days',   // Payment Term
            Payment_Term_Code__c = 'UK01',      // Payment Term Code
            Payterms_Desc__c = 'Net 7 days',    // Payterms Desc
            Sales_Org__c = salesOrgObj.Id,   // Sales Org
            Days_to_calc_interest__c = 0,     // Days (to calc interest)
            Active__c = true,                   // Active
            CombinationKey__c = '5710UK01'     // CombinationKey
        );
        insert paymentTermObj;
        
        //Data for Price Group
        Price_Group_Master__c priceGroupMasterObj = new Price_Group_Master__c(
            PG_Code__c = '95',                // PG Code
            Description_Colombia__c = 'Casagro'  // Description
        );
        insert priceGroupMasterObj;
        
        Payment_Term_PG_Group_Mapping__c paymentPgMapObj = new Payment_Term_PG_Group_Mapping__c(
            Name = '0001',   // Payment Term
            Payment_Term_Italy__c = paymentTermObj.Id,      // Payment Term Code
            Price_Group_Master_Italy__c =priceGroupMasterObj.Id    // Payterms Desc
        );
        insert paymentPgMapObj;
        
        
        //Data for account 1
        Account accObj1 = new Account(
            Name = 'BAM',                                                           // Account Name
            RecordTypeId = devRecordAcc,                                        // Account Record Type
            Last_Name__c = 'SAR123',                                         // Last Name
            SAP_Code__c = '0001023234',                                        // SAP Customer Code
            Mobile__c = '0876543219',                                          // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '8600589793',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            Sales_Org__c = salesOrgObj.Id,                                  // Sales Org
            Division__c = divisionObj.Id,                                   // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                       // Distribution Channel
            Payment_Term_Code__c = paymentTermObj.Id,                          // Payment Term Code
            Payment_Terms__c = 'UK07',                                         // Payment Terms
            PriceGroupCode__c =priceGroupMasterObj.Id,                          // Tax classification for customer
            AuthorizationGroupSalesoffice__c='',
            Tax_classification_for_customer__c=''
        );
        insert accObj1;

        Territory_Distributor__c territory = new Territory_Distributor__c();
             territory.Name = 'Narayangaon';
             territory.TerritoryCode__c = '398';
             territory.SalesOrg__c = salesOrgObj.id;
             territory.TerritoryManager__c = usr.Id;
         insert territory;
        
        
        Shipping_Location__c shippingLocationObj = new Shipping_Location__c(
            Location_Name__c = 'BAM S.A.',                           // Location Name
            SAP_Code__c = '0001023194',                                // SAP Code
            Distributor__c = accObj1.Id,                        // Distributor
            City__c = 'BOGOTA DC',                                     // City
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',  // Billing Street 1
            State__c = '11',                                           // State
            Country__c = 'CO',                                         // Country
            Billing_Street_3__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',  // Billing Street 3
            Pincode__c = '11001',                                      // Pincode
            Sold_To_Party_SAP_Code__c = '0001023194',                  // Sold To Party (SAP Code)
            Combination_Key__c = '00010231940001023194',               // Combination Key
            Country_Name__c = 'Italy',                   // Country Name
            Sales_Org__c = salesOrgObj.Id,                          // Sales Org
            Distribution_Channel__c = DistributionChannelObj.Id,               // Distribution Channel
            Division__c = divisionObj.Id ,                          // Division
            Territory_Distributor__c = territory.Id, 
            Is_Updated_from_SAP__c = true
        );
        insert shippingLocationObj;
        
        Test.StartTest();
        CreateAccountTeamMemberBatchScheduler testsche = new CreateAccountTeamMemberBatchScheduler();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );
        Test.stopTest();
    }
}