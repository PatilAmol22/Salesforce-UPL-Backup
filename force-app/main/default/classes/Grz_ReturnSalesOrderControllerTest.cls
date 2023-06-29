/**************************************************************************************************
* Name             : Grz_ReturnSalesOrderControllerTest                                                      
* Description      : Test class for return sales order controllers and test classes
* Created Date     : 10-12-2022                                                                        
* Project/JIRA     : APPS-2818                                                                        
* Created By       : Gurubaksh Grewal (Grazitti)                                                                        
* Last Modified By : Gurubaksh Grewal (Grazitti) 17-12-2022                                                                        
**************************************************************************************************/
@isTest
public class Grz_ReturnSalesOrderControllerTest {

   static testMethod void testMethod1(){
      insert new UPL_Settings__c(Sales_Order_Tracking_URL__c='http://example.com/example/test',Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);
          Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
          sorg=[SELECT Id,sales_org_code__c from sales_org__c];
          
       
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
       
       
       User tmu = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id,
           
           LastName = 'last',
           Email = 'puser000@amamama.com',
           Username = 'puser000@amamama.com' + System.currentTimeMillis(),
           Country='India',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
           Show_Inventory__c = true
            
           //  UserRoleId =  ur.Id
       );  
       insert tmu;
       system.debug('tmu#######'+tmu.id);
        User zsm2 = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Managers'].Id,
           
           LastName = 'last',
           Email = 'puser0002@amamama.com',
           Username = 'puser0002@amamama.com' + System.currentTimeMillis(),
           Country='Swal',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
            Show_Inventory__c = true
           //  UserRoleId =  ur2.Id
       );  
       insert zsm2;
       system.debug('zsm#######'+zsm2.id);
        User sbu3 = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'Sales Head Pune' OR Name = 'SBU Profile'].Id,
           LastName = 'last',
           Email = 'puser003@amamama.com',
           Username = 'puser0003@amamama.com' + System.currentTimeMillis(),
           Country='Indonesia',
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           isActive = true,
           Show_Inventory__c = true
           // UserRoleId =  ur3.Id
       );  
       insert sbu3;
        system.debug('sbur#######'+sbu3.id);
       
          Account accObj = new Account(
            Name = 'Test',                                                // Account Name
            Last_Name__c = 'Test Last',                                                 // Last Name
            SAP_Code__c = '0001052626',                                                    // SAP Customer Code
            Mobile__c = '000000000000',                                                    // Mobile
            Email__c = 'test@test.com',                                       // Email
            Order_Block__c = false,                                                        // Order Block
            TaxNumber2__c = '8300950488',                                                  // Tax Number 2
            Tax_Number_1__c = '830092048',                                                 // Tax Number 1
            Account_Type__c = 'Sold To Party',                                             // Account Type
            Billing_Street_1__c = 'KM 2 5 AUT A MEDELLIN PAR IND. PORTOS SABANA 80 BG95',  // Billing Street 1
            Sales_Org__c = sorg .Id,                                              // Sales Org
            Depot_Code__c = 'BR00',                                                        // Depot Code
            Payment_Terms__c = 'UK10'                                                     // Payment Terms
          
        );
        insert accObj;   
          system.debug('acc#######'+accobj.id);
       
       Country__c countryObj = new Country__c(
           Name = 'India',      // Country Name
           Country_Id__c = '91'  // Country Id
       );
       insert countryObj;
       system.debug('country#######'+countryObj.id);
       State__c stateObj = new State__c(
           Name = 'Uttar Pradesh',                // State Name
           State_Code__c = '9',                     // State Code
           Country__c = 'India',                    // Country
           Active__c = true,                        // Active
           State_Code_Census__c = '9',              // State Code Census
           State_Name_Census__c = 'UTTAR PRADESH',  // State Name Census
           Country_Akc__c = countryObj.id      // Country
       );
       insert stateObj;
       system.debug('stateObj#######'+stateObj.id);
       SBU__c SBUObj = new SBU__c(
           SBUUser__c = UserInfo.getUserId(), // SBU User
           SBUCode__c = 'SBU2',              // SBU Code
           SalesOrg__c = sOrg.id  // Sales Org
       );
       insert SBUObj;
       system.debug('sbuObj#######'+sbuObj.id);
       Zone__c zoneObj = new Zone__c(
           Name = 'Indore',                 // Zone Name
           SalesOrg__c = sOrg.Id,   // Sales Org
           ZoneCode__c = 'Z16',               // Zone Code
           ZonalHead__c = zsm2.Id,  // Zonal Head
           ZMMUser__c = zsm2.Id,
           SBUCode__c = SBUObj.Id    // SBU Code
       );
       insert zoneObj;
       system.debug('zone#######'+zoneObj.id);
       Region__c regionObj = new Region__c(
           Name = 'TRIANGULO',                  // Region Name
           RegionCode__c = 'BR4003',              // Region Code
           SalesOrg__c =sOrg.id,       // Sales Org
           // RegionHead__c = u1.id,     // Region Head
           Zone__c = zoneObj.id
           
       );
       insert regionObj;
        system.debug('region#######'+regionObj.id);
        Depot__c depo=new Depot__c();
        depo.Name='depo1';
        depo.Depot_Code__c='d0123';
        insert depo;
       system.debug('depo#######'+depo.id);
       Territory_Distributor__c territoryObj = new Territory_Distributor__c();
       territoryObj.Name = 'Narayangaon';
       territoryObj.TerritoryCode__c = '398';
       territoryObj.SalesOrg__c = sOrg.id;
       territoryObj.Region__c = regionObj.id;
       territoryObj.TerritoryManager__c = tmu.Id;
       territoryObj.Zone__c = zoneObj.id;
       territoryObj.SBU__c = SBUObj.Id;
       territoryObj.SalesOrg__c = sOrg.id;
       territoryObj.Present_in_KEDE__c = true ;
       territoryObj.Neglected__c = false;
       
       insert territoryObj;
       system.debug('territory#######'+territoryObj.id);
       
         Zone_Depot_Mapping__c zdm=new Zone_Depot_Mapping__c();
       	zdm.Depot__c=depo.id;
        zdm.SBU__c=SBUObj.Id;
        zdm.Sales_Org__c=sOrg.Id;
        zdm.Name='testZdm';
        //zdm.Depot__r.Depot_Code__c=depo.Depot_Code__c;
        //zdm.Depot__r.Name=depo.Name;
        //zdm.Depot_Name__c=depo.Name;
        //zdm.Depot_Code__c=depo.Depot_Code__c;
        insert zdm;
        system.debug('zdm#######'+zdm.id);
        TM_Depot_Mapping__c tdm=new TM_Depot_Mapping__c(); 
        
            tdm.Territory_Manager__c=tmu.id;
            //tdm.Depot_Name__c=depo.Name;
            //tdm.Depot_Code__c=depo.Depot_Code__c;
            tdm.Depot__c=depo.id;
        insert tdm;   
       system.debug('tdm#######'+tdm.id);
        Division__c   DivisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert DivisionObj;
       system.debug('divObj#######'+DivisionObj.id);
          Sales_Order__c sobj = new Sales_Order__c(            
            SAP_Order_Number__c='7676767676',
            Last_Invoice_Updated__c=system.now(),
            Last_Invoice_Update_Status__c='Success',
            Last_SuccessFull_Invoice_Update__c=system.now(),
            Sent_for_Manager_Approval_Mexico__c = true,            // Sent for Manager Approval
            Bill_To_Party__c =accObj.Id,                  // Bill To Party
            Sold_to_Party__c = accObj.Id,                 // Sold to Party
            SalesOrg__c=sorg.Id,
            createdDate = System.today(),
            Division_lk__c=DivisionObj.id
        );
        insert sobj;
       
        
       
       
        
        Distribution_Channel__c Distribution_ChannelObj = new Distribution_Channel__c(
            Name = '67',                        // Distribution Channel Name
            Distribution_Channel_Code__c = '67'  // Distribution Channel Code
        );
        insert Distribution_ChannelObj;
        
       DistributorSalesAreaMapping__c distributorSalesAreaMappingObj = new DistributorSalesAreaMapping__c(
            
            AccountType__c = 'Sold To Party',          // Account Type
            Distributor__c = accObj.Id,          // Distributor
            SalesOrg__c = sorg.Id,             // Sales Org
            OrderBlock__c = false,                       // Order Block
            DistributionChannel__c = Distribution_ChannelObj.Id,  // Distribution Channel
            Division__c = DivisionObj.Id,             // Division
            AccountOwner__c = tmu.Id,         // Account Owner
            Manually_Created__c = True,                 // Manually Created
           Territory__c=territoryObj.id
        );
        insert distributorSalesAreaMappingObj;
       
       distributorSalesAreaMappingObj.Territory__c=territoryObj.id;
       update distributorSalesAreaMappingObj;
        system.debug(distributorSalesAreaMappingObj.Territory__c+'============distributorSalesAreaMappingObj============'+JSON.serializePretty(distributorSalesAreaMappingObj));
       Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZRED';              
        ordType.Division__c = DivisionObj.Id;              
        ordType.SalesOrg__c = sorg.id;              
        ordType.Description__c = 'India';    
        ordType.Order_Type_Code__c = 'ZRED';
        insert ordType;
       
         Invoice__c InvoiceObj = new Invoice__c(
            Billing_Doc_Number__c = '2110787983',       // Billing Doc Number
            Billing_Date__c = System.today(),  // Billing Date
            PO_Number__c = '2438',                        // PO Number
            Sold_To_Party__c = accObj.Id,         // Sold To Party
            Sales_Org__c = sorg.Id ,          // Sales Org
            Sales_Order__c=sobj.id,
             Division__c=DivisionObj.Id,
             Distribution_Channel__c=Distribution_ChannelObj.Id
        );
        insert InvoiceObj;
       
       list<Invoice_Line_Item__c> invLineItemList= new list<Invoice_Line_Item__c>();
        Invoice_Line_Item__c invLine= new Invoice_Line_Item__c();
        invLine.Invoice__c=InvoiceObj.id;
        invLine.Quantity__c=1223;
        invLine.UOM__c='KG';
        invLine.Net_Value__c=122;
        invLineItemList.add(invLine);
         Invoice_Line_Item__c invLine1= new Invoice_Line_Item__c();
        invLine1.Invoice__c=InvoiceObj.id;
        invLine1.UOM__c='EA';
        invLine1.Quantity__c=1223;
        invLine1.Net_Value__c=122;
        invLineItemList.add(invLine1);
       
       insert invLineItemList;
       
       grz_SalesOrderReturnFnlController.forList fl1=new grz_SalesOrderReturnFnlController.forList();
       fl1.id=invLine.id;
       fl1.returnQty='2';
       fl1.returnReason='no reason';
       
       list<grz_SalesOrderReturnFnlController.forList> dataLst=new list<grz_SalesOrderReturnFnlController.forList>{fl1};
      
       grz_ReturnSalesOrderController.getAllData(InvoiceObj.id);
       grz_ReturnSalesOrderController.getAllData(sobj.id);
      //System.runas(tmu){
          // grz_SalesOrderReturnFnlController.saveRec(dataLst, InvoiceObj.id, false, null);
                         Return_Sales_Order__c rsalor = new Return_Sales_Order__c();
        	rsalor.Invoice__c = InvoiceObj.id;
        	rsalor.Order_Status__c = 'Draft';
            rsalor.SalesOrder__c = sobj.id;
            //rsalor.billing_block__c = 'VBAK-FAKSK';
            //rsalor.Order_Reason__c = 'VBAK-AUGRU';
       		rsalor.isApprover1__c=true;
       		rsalor.isApprover2__c=true;
       		rsalor.Approver_2__c=userinfo.getUserId();
            //rsalor.Order_Type__c = ordType.id;     
            
      insert rsalor;
		
       Return_Sales_Order_Line_Item__c retInvLinItem = new Return_Sales_Order_Line_Item__c();
                        retInvLinItem.SalesOrder__c = sobj.id;
                        retInvLinItem.Status__c = 'Draft';
                        retInvLinItem.Invoice_Line_Item__c = invLine1.id;
                        retInvLinItem.Quantity__c = 5.00;
                        retInvLinItem.Item_Number__c = '40';
						retInvLinItem.Return_Sales_Order__c = rsalor.id;
       test.startTest();
       insert retInvLinItem;
                         retInvLinItem.Quantity__c = 6.00;
       update retInvLinItem;
       					retInvLinItem.Status__c='Open';
       update retInvLinItem;
      
       retInvLinItem.Status__c='Completely processed';
       update retInvLinItem;
       
       
       Return_Sales_Order_Line_Item__c retInvLinItem1 = new Return_Sales_Order_Line_Item__c();
                        retInvLinItem1.SalesOrder__c = sobj.id;
                        retInvLinItem1.Status__c = 'Draft';
                        retInvLinItem1.Invoice_Line_Item__c = invLine1.id;
                        retInvLinItem1.Item_Number__c = '20';
                        retInvLinItem1.Quantity__c = 5.00;
                        retInvLinItem1.Return_Sales_Order__c = rsalor.id;
		insert retInvLinItem1;
       system.debug(rsalor.isApprover2__c+'rsalor@@@@@@@@@@@@@@@@@@'+rsalor.Approver_2__c);
       system.debug('@@@@@@@@@@@'+userinfo.getUserId());
		rsalor.Order_Status__c='Open';
       update rsalor;
       retInvLinItem1.Status__c='Completely processed';
       update retInvLinItem1;
       retInvLinItem1.Quantity__c = 4.00;
       retInvLinItem1.Status__c='Completely processed';
       update retInvLinItem1;
      test.stopTest();
      //}
                    
    } 
  
    
}