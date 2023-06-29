@isTest 
private class SalesOrderApprovalController_Test {
    
    
    
    static testMethod void validateData() {
        userrole  usrole1 = new userrole();
        usrole1.Name ='vishal pawar Customer User';
        Contact con = new Contact();
        //con.AccountId=ac.Id;
        con.LastName='Pawar';
        insert con;
        Profile profileObj = [SELECT Id,name FROM Profile WHERE Name = 'Commercial Leader NUCO Colombia' LIMIT 1];
        
        User userObj = new User();
        userObj.Alias = 'zonaa';                                                            
        userObj.Email = 'himanshua.mehta@skinternational.com';                             
        userObj.ProfileId  = profileObj.ID;                                                     
        userObj.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        userObj.IsActive = true;  
        userObj.LastName='Terriotory Manager';
        userObj.CommunityNickname = 'zonalExe1222 Di'; 
        userObj.TimeZoneSidKey = 'Asia/Kolkata'; 
        userObj.LocaleSidKey = 'en_IN';                                    
        userObj.LanguageLocaleKey = 'en_US';                                             
        userObj.ForecastEnabled = false;                                                     
        userObj.EmailEncodingKey = 'ISO-8859-1';    
        userObj.Show_Inventory__c = false;                                                     
        userObj.Show_Credit_Limit__c = false; 
        //   u.UserRoleId=usrole.id;
        insert userObj;
        
        
        Sales_Org__c SalesOrgObj = new Sales_Org__c(
            Name = 'Colombia',           // Sales Org Name
            Company_Code__c = '5700',      // Company Code
            Sales_Org_Code__c = '5710',    // Sales Org Code
            Country_Code__c = 'CO'        // Country Code
        );
        insert SalesOrgObj;
        
        Division__c divisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert divisionObj;
        
        
        Distribution_Channel__c DistributionChannelObj = new Distribution_Channel__c(
            Name = '67',                        // Distribution Channel Name
            Distribution_Channel_Code__c = '67'  // Distribution Channel Code
        );
        insert DistributionChannelObj;
        
        
        Account accObj = new Account(
            Name = 'CASAGRO',                                   					   // Account Name
            Last_Name__c = 'CASAGRO',                                                 // Last Name
            SAP_Code__c = '0001052626',                                                    // SAP Customer Code
            Mobile__c = '000000000000',                                                    // Mobile
            Email__c = 'johanna.macias@uniphos.com',                                       // Email
            Order_Block__c = false,                                                        // Order Block
            TaxNumber2__c = '8300950488',                                                  // Tax Number 2
            Tax_Number_1__c = '830092048',                                                 // Tax Number 1
            Account_Type__c = 'Sold To Party',                                             // Account Type
      
       
            Billing_Street_1__c = 'KM 2 5 AUT A MEDELLIN PAR IND. PORTOS SABANA 80 BG95',  // Billing Street 1
            Sales_Org__c = SalesOrgObj.Id,                                              // Sales Org
            Division__c = divisionObj.Id,                                               // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                                   // Distribution Channel
            Depot_Code__c = 'CO00',                                                        // Depot Code
            Payment_Terms__c = 'UK10'                                                     // Payment Terms
          
        );
        insert accObj;
        
        Sales_Order__c sobj = new Sales_Order__c(
            ownerId = userObj.Id,
            SFDC_Order_Number__c = '98352',                       // SFDC Order Number
            Desc_Punctuality__c = false,                           // Desc Punctuality
            Order_Status__c = 'Pending',                           // Order Status
            Order_Date__c = system.today(),              // Order Date,
            OrderSubStatus__c = 'Draft',                           // Order Sub-Status
            Punctuality_Discount__c = 0.00,                        // Punctuality Discount
            Program_Margin_Discount__c = 0.00,                     // Program Margin Discount (%)
            isOffline_Mobile_Order__c = false,                     // isOffline Mobile Order
            BrazilOrderSubmittedforApproval__c = true,             // Brazil Order Submitted for Approval
            Call_Process_Builder_Flow__c = false,                  // Call Process Builder Flow
            ProcessBuilderFlag__c = false,                         // Process Builder Flag
            BrazilSalesOrderApproved__c = false,                   // Brazil Sales Order Approved
            Turkey_Order_Send_for_Approval__c = false,             // Turkey Order Send for Approval
            Key_Account__c = false,                                // Key Account
            Customer_Approval__c = false,                          // Customer Approval
            Signed__c = false,                                     // Signed
            SentEmailIndonesia__c = false,                         // Sent Email Indonesia
            Sales_Org_lk__c = SalesOrgObj.Id,                   // Sales Org
            RequestforCancellationCheck__c = false,                // Request for Cancellation
            TM_Code__c = '00051115',                               // TM Code
            ApprovedBySDM__c = false,                              // Approved By SDM
            ApprovedBySOM__c = false,                              // Approved By SOM
            ApprovedByBM__c = false,                               // Approved By BM
            ApprovedBySOMifSDMisNull__c = false,                   // Approved By SOM if SDM is Null
            Approved_By_SD__c = false,                             // Approved By SD
            Division_lk__c =divisionObj.Id,                    // Division
            Distribution_Channel_lk__c = DistributionChannelObj.Id,        // Distribution Channel
                       
            Sent_for_Manager_Approval_Mexico__c = true,            // Sent for Manager Approval
            Bill_To_Party__c =accObj.Id,                  // Bill To Party
            Sold_to_Party__c = accObj.Id,                 // Sold to Party
            createdDate = System.today()
            
        );
        insert sobj;
        
        
        
        System.runAs(userObj) {
            
            SalesOrderApprovalController SalesOrderApprovalControllerObj = new SalesOrderApprovalController();
            SalesOrderApprovalController.fetchAccountDetail(accObj.Name);
            SalesOrderApprovalController.fetchOwnerNameDetail(userObj.Name);
            SalesOrderApprovalController.searchHelperOnAccountKeyPres(accObj.Name);
            SalesOrderApprovalController.searchHelperOnOwnerNameKeyPres(userObj.Name);
            SalesOrderApprovalController.fetchProfile();
            Date dt = System.today();
            System.debug('Date is '+dt);
            
            SalesOrderApprovalController.fetchSalesOrder1(accObj.Id, null, 'My_Pending_Orders', null, 'false');
            // if(accountId!= null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'My_Pending_Orders', null, false);
				//SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'Draft', null, false);
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'none', null, false);
            
            
            
            //!!!!!
            //if(accountId!= null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'My_Pending_Orders', dt, true);
                     //   SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'Draft', dt, true);
            
            
            
            
            //if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'none', dt, true); 
            //if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'My_Pending_Orders', null, false);
           // SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'Draft', null, false);
            // if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'My_Pending_Orders', dt, true);
            //if(accountId ==null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'none', dt, true);
            //if(accountId == null && statusOrder =='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'none', null, false);
            //if(accountId != null && statusOrder =='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'none', null, false);
            //if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'My_Pending_Orders', null, false);
            
            //Then
            //if(accountId == null && statusOrder =='none' && strtDate != null && edDate != null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, dt, 'none', dt, true);
            //if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'My_Pending_Orders', null, false);
            
            
            
            
            //For Rejected
            SalesOrderApprovalController SalesOrderApprovalControllerObj1 = new SalesOrderApprovalController();
            SalesOrderApprovalController.fetchSalesOrder1(accObj.Id, null, 'Rejected', null, 'false');
            // if(accountId!=null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'Rejected', null, false);
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'none', null, false);
            
            //!!!!
            //if(accountId!=null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'Rejected', dt, true);
            
            
            //if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'none', dt, true);
            //if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'Rejected', null, false);
            // if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'Rejected', dt, true);
            //if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'Rejected', null, false);
            
            
            //Then
            //if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'Rejected', null, false);
            
            
            
            //Approved
            
            SalesOrderApprovalController SalesOrderApprovalControllerObj2 = new SalesOrderApprovalController();
            SalesOrderApprovalController.fetchSalesOrder1(accObj.Id, null, 'Approved', null, 'false');
            // if(accountId!=null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'Approved', null, false);
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'none', null, false);
            
            //!!!!
            //if(accountId!=null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'Approved', dt, true);
            
            //if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'none', dt, true);
            //if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'Approved', null, false);
            // if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'Approved', dt, true);
            //if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'Approved', null, false);
            
            //Then
            //if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'Approved', null, false);
             
            
            
            //if(accountId!=null && statusOrder!='none' && strtDate != null && edDate != null && ownerId == null)
             SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'Approved', dt, false);
            
            
            
            
            //PendingForOthers
            SalesOrderApprovalController SalesOrderApprovalControllerObj3 = new SalesOrderApprovalController();
            SalesOrderApprovalController.fetchSalesOrder1(accObj.Id, null, 'PendingForOthers', null, 'false');
            // if(accountId!=null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'PendingForOthers', null, false);
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'none', null, false);
            
            
            //!!!!
            //if(accountId!=null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'PendingForOthers', dt, true);
            
            
            //if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'none', dt, true); 
            //if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'PendingForOthers', null, false);
            // if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'PendingForOthers', dt, true);
            //if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'PendingForOthers', null, false);
            
            
            //Then
            //if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'PendingForOthers', null, false);
            
            
        }
        
        
        
        
    }
    
    
    static testMethod void validateData1() {
        userrole  usrole1 = new userrole();
        usrole1.Name ='vishal pawar Customer User';
        Contact con = new Contact();
        //con.AccountId=ac.Id;
        con.LastName='Pawar';
        insert con;
        Profile profileObj = [SELECT Id,name FROM Profile WHERE Name = 'Commercial Manager NUCO Colombia' LIMIT 1];
        
        User userObj = new User();
        userObj.Alias = 'zonaa';                                                            
        userObj.Email = 'himanshua.mehta@skinternational.com';                             
        userObj.ProfileId  = profileObj.ID;                                                     
        userObj.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        userObj.IsActive = true;  
        userObj.LastName='Terriotory Manager';
        userObj.CommunityNickname = 'zonalExe1222 Di'; 
        userObj.TimeZoneSidKey = 'Asia/Kolkata'; 
        userObj.LocaleSidKey = 'en_IN';                                    
        userObj.LanguageLocaleKey = 'en_US';                                             
        userObj.ForecastEnabled = false;                                                     
        userObj.EmailEncodingKey = 'ISO-8859-1';    
        userObj.Show_Inventory__c = false;                                                     
        userObj.Show_Credit_Limit__c = false; 
        //   u.UserRoleId=usrole.id;
        insert userObj;
        
        
        Sales_Org__c SalesOrgObj = new Sales_Org__c(
            Name = 'Colombia',           // Sales Org Name
            Company_Code__c = '5700',      // Company Code
            Sales_Org_Code__c = '5710',    // Sales Org Code
            Country_Code__c = 'CO'        // Country Code
        );
        insert SalesOrgObj;
        
        Division__c divisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert divisionObj;
        
        
        Distribution_Channel__c DistributionChannelObj = new Distribution_Channel__c(
            Name = '67',                        // Distribution Channel Name
            Distribution_Channel_Code__c = '67'  // Distribution Channel Code
        );
        insert DistributionChannelObj;
        
        
        Account accObj = new Account(
            Name = 'CASAGRO',                                   					   // Account Name
            Last_Name__c = 'CASAGRO',                                                 // Last Name
            SAP_Code__c = '0001052626',                                                    // SAP Customer Code
            Mobile__c = '000000000000',                                                    // Mobile
            Email__c = 'johanna.macias@uniphos.com',                                       // Email
            Order_Block__c = false,                                                        // Order Block
            TaxNumber2__c = '8300950488',                                                  // Tax Number 2
            Tax_Number_1__c = '830092048',                                                 // Tax Number 1
            Account_Type__c = 'Sold To Party',                                             // Account Type
           
          
            Billing_Street_1__c = 'KM 2 5 AUT A MEDELLIN PAR IND. PORTOS SABANA 80 BG95',  // Billing Street 1
            Sales_Org__c = SalesOrgObj.Id,                                              // Sales Org
            Division__c = divisionObj.Id,                                               // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                                   // Distribution Channel
            Depot_Code__c = 'CO00',                                                        // Depot Code
            Payment_Terms__c = 'UK10'
        );
        insert accObj;
        
        Sales_Order__c sobj = new Sales_Order__c(
            ownerId = userObj.Id,
            SFDC_Order_Number__c = '98352',                       // SFDC Order Number
            Desc_Punctuality__c = false,                           // Desc Punctuality
            Order_Status__c = 'Pending',                           // Order Status
            Order_Date__c = system.today(),              // Order Date,
            OrderSubStatus__c = 'Draft',                           // Order Sub-Status
            Punctuality_Discount__c = 0.00,                        // Punctuality Discount
            Program_Margin_Discount__c = 0.00,                     // Program Margin Discount (%)
            isOffline_Mobile_Order__c = false,                     // isOffline Mobile Order
            BrazilOrderSubmittedforApproval__c = true,             // Brazil Order Submitted for Approval
            Call_Process_Builder_Flow__c = false,                  // Call Process Builder Flow
            ProcessBuilderFlag__c = false,                         // Process Builder Flag
            BrazilSalesOrderApproved__c = false,                   // Brazil Sales Order Approved
            Turkey_Order_Send_for_Approval__c = false,             // Turkey Order Send for Approval
            Key_Account__c = false,                                // Key Account
            Customer_Approval__c = false,                          // Customer Approval
            Signed__c = false,                                     // Signed
            SentEmailIndonesia__c = false,                         // Sent Email Indonesia
            Sales_Org_lk__c = SalesOrgObj.Id,                   // Sales Org
            RequestforCancellationCheck__c = false,                // Request for Cancellation
            TM_Code__c = '00051115',                               // TM Code
            ApprovedBySDM__c = false,                              // Approved By SDM
            ApprovedBySOM__c = false,                              // Approved By SOM
            ApprovedByBM__c = false,                               // Approved By BM
            ApprovedBySOMifSDMisNull__c = false,                   // Approved By SOM if SDM is Null
            Approved_By_SD__c = false,                             // Approved By SD
            Division_lk__c =divisionObj.Id,                    // Division
            Distribution_Channel_lk__c = DistributionChannelObj.Id,        // Distribution Channel
          
            
            Sent_for_Manager_Approval_Mexico__c = true,            // Sent for Manager Approval
            Bill_To_Party__c =accObj.Id,                  // Bill To Party
            Sold_to_Party__c = accObj.Id,                 // Sold to Party
            createdDate = System.today()
            
        );
        insert sobj;
        
        
        
        System.runAs(userObj) {
            SalesOrderApprovalController SalesOrderApprovalControllerObj = new SalesOrderApprovalController();
            SalesOrderApprovalController.fetchAccountDetail(accObj.Name);
            SalesOrderApprovalController.fetchOwnerNameDetail(userObj.Name);
            SalesOrderApprovalController.searchHelperOnAccountKeyPres(accObj.Name);
            SalesOrderApprovalController.searchHelperOnOwnerNameKeyPres(userObj.Name);
            SalesOrderApprovalController.fetchProfile();
            Date dt = System.today();
            System.debug('Date is '+dt);
            
            SalesOrderApprovalController.fetchSalesOrder1(accObj.Id, null, 'My_Pending_Orders', null, 'false');
            // if(accountId!=null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'My_Pending_Orders', null, false);
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'none', null, false);
            
            //!!!!!
            //if(accountId!=null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'My_Pending_Orders', dt, true);
            
            
            //if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'none', dt, true); 
            //if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'My_Pending_Orders', null, false);
            // if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'My_Pending_Orders', dt, true);
            //if(accountId ==null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'none', dt, true);
            //if(accountId == null && statusOrder =='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'none', null, false);
            //if(accountId != null && statusOrder =='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'none', null, false);
            //if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'My_Pending_Orders', null, false);
            
            
            //Then
            //if(accountId == null && statusOrder =='none' && strtDate != null && edDate != null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, dt, 'none', dt, true);
            //if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'My_Pending_Orders', null, false);
            
             //if(accountId!=null && statusOrder!='none' && strtDate != null && edDate != null && ownerId == null)
             SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'My_Pending_Orders', dt, false);
            
            
            
            
            
            //For Rejected
            SalesOrderApprovalController SalesOrderApprovalControllerObj1 = new SalesOrderApprovalController();
            SalesOrderApprovalController.fetchSalesOrder1(accObj.Id, null, 'Rejected', null, 'false');
            // if(accountId!=null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'Rejected', null, false);
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'none', null, false);
            
            
            //!!!!
            //if(accountId!=null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'Rejected', dt, true);
            
            
            //if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'none', dt, true);
            //if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'Rejected', null, false);
            // if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'Rejected', dt, true);
            //if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'Rejected', null, false);
            
            
            //Then
            //if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'Rejected', null, false);
            
            
            
            //Approved
            
            SalesOrderApprovalController SalesOrderApprovalControllerObj2 = new SalesOrderApprovalController();
            SalesOrderApprovalController.fetchSalesOrder1(accObj.Id, null, 'Approved', null, 'false');
            // if(accountId!=null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'Approved', null, false);
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'none', null, false);
            
            //!!!!
            //if(accountId!=null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'Approved', dt, true);
            
            
            //if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'none', dt, true); 
            //if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'Approved', null, false);
            // if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'Approved', dt, true);
            //if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'Approved', null, false);
            
            
            //Then
            //if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'Approved', null, false);
            
            
            
            
            //PendingForOthers
            
            SalesOrderApprovalController SalesOrderApprovalControllerObj3 = new SalesOrderApprovalController();
            SalesOrderApprovalController.fetchSalesOrder1(accObj.Id, null, 'PendingForOthers', null, 'false');
            // if(accountId!=null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'PendingForOthers', null, false);
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'none', null, false);
            
            //!!!!
            //if(accountId!=null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'PendingForOthers', dt, true);
            
            
            //if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'none', dt, true);
            //if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'PendingForOthers', null, false);
            // if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'PendingForOthers', dt, true);
            //if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'PendingForOthers', null, false);
            
            
            //Then
            //if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'PendingForOthers', null, false);
            
            
        }
        
    }
    
    static testMethod void validateData2() {
        userrole  usrole1 = new userrole();
        usrole1.Name ='vishal pawar Customer User';
        Contact con = new Contact();
        //con.AccountId=ac.Id;
        con.LastName='Pawar';
        insert con;
        Profile profileObj = [SELECT Id,name FROM Profile WHERE Name = 'Country Manager NUCO Colombia' LIMIT 1];
        
        User userObj = new User();
        userObj.Alias = 'zonaa';                                                            
        userObj.Email = 'himanshua.mehta@skinternational.com';                             
        userObj.ProfileId  = profileObj.ID;                                                     
        userObj.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        userObj.IsActive = true;  
        userObj.LastName='Terriotory Manager';
        userObj.CommunityNickname = 'zonalExe1222 Di'; 
        userObj.TimeZoneSidKey = 'Asia/Kolkata'; 
        userObj.LocaleSidKey = 'en_IN';                                    
        userObj.LanguageLocaleKey = 'en_US';                                             
        userObj.ForecastEnabled = false;                                                     
        userObj.EmailEncodingKey = 'ISO-8859-1';    
        userObj.Show_Inventory__c = false;                                                     
        userObj.Show_Credit_Limit__c = false; 
        //   u.UserRoleId=usrole.id;
        insert userObj;
        
        
        Sales_Org__c SalesOrgObj = new Sales_Org__c(
            Name = 'Colombia',           // Sales Org Name
            Company_Code__c = '5700',      // Company Code
            Sales_Org_Code__c = '5710',    // Sales Org Code
            Country_Code__c = 'CO'        // Country Code
        );
        insert SalesOrgObj;
        
        Division__c divisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert divisionObj;
        
        
        Distribution_Channel__c DistributionChannelObj = new Distribution_Channel__c(
            Name = '67',                        // Distribution Channel Name
            Distribution_Channel_Code__c = '67'  // Distribution Channel Code
        );
        insert DistributionChannelObj;
        
        
        Account accObj = new Account(
            Name = 'CASAGRO',                                   					   // Account Name
            Last_Name__c = 'CASAGRO',                                                 // Last Name
            SAP_Code__c = '0001052626',                                                    // SAP Customer Code
            Mobile__c = '000000000000',                                                    // Mobile
            Email__c = 'johanna.macias@uniphos.com',                                       // Email
            Order_Block__c = false,                                                        // Order Block
            TaxNumber2__c = '8300950488',                                                  // Tax Number 2
            Tax_Number_1__c = '830092048',                                                 // Tax Number 1
            Account_Type__c = 'Sold To Party',                                             // Account Type
           
          
            Billing_Street_1__c = 'KM 2 5 AUT A MEDELLIN PAR IND. PORTOS SABANA 80 BG95',  // Billing Street 1
            Sales_Org__c = SalesOrgObj.Id,                                              // Sales Org
            Division__c = divisionObj.Id,                                               // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                                   // Distribution Channel
            Depot_Code__c = 'CO00',                                                        // Depot Code
            Payment_Terms__c = 'UK10'
        );
        insert accObj;
        
        Sales_Order__c sobj = new Sales_Order__c(
            ownerId = userObj.Id,
            SFDC_Order_Number__c = '98352',                       // SFDC Order Number
            Desc_Punctuality__c = false,                           // Desc Punctuality
            Order_Status__c = 'Pending',                           // Order Status
            Order_Date__c = system.today(),              // Order Date,
            OrderSubStatus__c = 'Draft',                           // Order Sub-Status
            Punctuality_Discount__c = 0.00,                        // Punctuality Discount
            Program_Margin_Discount__c = 0.00,                     // Program Margin Discount (%)
            isOffline_Mobile_Order__c = false,                     // isOffline Mobile Order
            BrazilOrderSubmittedforApproval__c = true,             // Brazil Order Submitted for Approval
            Call_Process_Builder_Flow__c = false,                  // Call Process Builder Flow
            ProcessBuilderFlag__c = false,                         // Process Builder Flag
            BrazilSalesOrderApproved__c = false,                   // Brazil Sales Order Approved
            Turkey_Order_Send_for_Approval__c = false,             // Turkey Order Send for Approval
            Key_Account__c = false,                                // Key Account
            Customer_Approval__c = false,                          // Customer Approval
            Signed__c = false,                                     // Signed
            SentEmailIndonesia__c = false,                         // Sent Email Indonesia
            Sales_Org_lk__c = SalesOrgObj.Id,                   // Sales Org
            RequestforCancellationCheck__c = false,                // Request for Cancellation
            TM_Code__c = '00051115',                               // TM Code
            ApprovedBySDM__c = false,                              // Approved By SDM
            ApprovedBySOM__c = false,                              // Approved By SOM
            ApprovedByBM__c = false,                               // Approved By BM
            ApprovedBySOMifSDMisNull__c = false,                   // Approved By SOM if SDM is Null
            Approved_By_SD__c = false,                             // Approved By SD
            Division_lk__c =divisionObj.Id,                    // Division
            Distribution_Channel_lk__c = DistributionChannelObj.Id,        // Distribution Channel
           
         
            
            Sent_for_Manager_Approval_Mexico__c = true,            // Sent for Manager Approval
            Bill_To_Party__c =accObj.Id,                  // Bill To Party
            Sold_to_Party__c = accObj.Id,                 // Sold to Party
            createdDate = System.today()
            
        );
        insert sobj;
        
        
        
        System.runAs(userObj) {
            SalesOrderApprovalController SalesOrderApprovalControllerObj = new SalesOrderApprovalController();
            SalesOrderApprovalController.fetchAccountDetail(accObj.Name);
            SalesOrderApprovalController.fetchOwnerNameDetail(userObj.Name);
            SalesOrderApprovalController.searchHelperOnAccountKeyPres(accObj.Name);
            SalesOrderApprovalController.searchHelperOnOwnerNameKeyPres(userObj.Name);
            SalesOrderApprovalController.fetchProfile();
            Date dt = System.today();
            System.debug('Date is '+dt);
            
            //for Pending
            SalesOrderApprovalController.fetchSalesOrder1(accObj.Id, null, 'My_Pending_Orders', null, 'false');
            // if(accountId!=null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'My_Pending_Orders', null, false);
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'none', null, false);
            
            //!!!!
            //if(accountId!=null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'My_Pending_Orders', dt, true);
            
            
            
            //if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'none', dt, true); 
            //if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'My_Pending_Orders', null, false);
            // if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'My_Pending_Orders', dt, true);
            //if(accountId ==null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'none', dt, true);
            //if(accountId == null && statusOrder =='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'none', null, false);
            //if(accountId != null && statusOrder =='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'none', null, false);
            //if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'My_Pending_Orders', null, false);
            
            
            //Then
            //if(accountId == null && statusOrder =='none' && strtDate != null && edDate != null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, dt, 'none', dt, true);
            
            //if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'My_Pending_Orders', null, false);
            
             //if(accountId!=null && statusOrder!='none' && strtDate != null && edDate != null && ownerId == null)
             SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'Rejected', dt, false);
            
            
            
            //For Rejected
            SalesOrderApprovalController SalesOrderApprovalControllerObj1 = new SalesOrderApprovalController();
            SalesOrderApprovalController.fetchSalesOrder1(accObj.Id, null, 'Rejected', null, 'false');
            // if(accountId!=null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'Rejected', null, false);
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'none', null, false);
            
            //!!!!
            //if(accountId!=null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'Rejected', dt, true);
            
            
            //if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'none', dt, true); 
            //if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'Rejected', null, false);
            // if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'Rejected', dt, true);
            //if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'Rejected', null, false);
            
            //Then
            //if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'Rejected', null, false);
            
            
            
            //Approved
            
            SalesOrderApprovalController SalesOrderApprovalControllerObj2 = new SalesOrderApprovalController();
            SalesOrderApprovalController.fetchSalesOrder1(accObj.Id, null, 'Approved', null, 'false');
            // if(accountId!=null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'Approved', null, false);
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'none', null, false);
            
            //!!!!
            //if(accountId!=null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'Approved', dt, true);
            
            
            //if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'none', dt, true); 
            //if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'Approved', null, false);
            // if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'Approved', dt, true);
            //if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'Approved', null, false);
            
            
            //Then
            //if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'Approved', null, false);
            
            
            
            
            //PendingForOthers
            
            SalesOrderApprovalController SalesOrderApprovalControllerObj3 = new SalesOrderApprovalController();
            SalesOrderApprovalController.fetchSalesOrder1(accObj.Id, null, 'PendingForOthers', null, 'false');
            // if(accountId!=null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'PendingForOthers', null, false);
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'none', null, false);
            
            
            //!!!!
            //if(accountId!=null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'PendingForOthers', dt, true);
            
            
            //if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'none', dt, false); 
            //if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'PendingForOthers', null, false);
            // if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'PendingForOthers', dt, true);
            //if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'PendingForOthers', null, false);
            
            
            //Then
            //if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'PendingForOthers', null, false);
            
            
        }
        
        
        
        
    }
    
    //For  Admin 
    static testMethod void validateData3() {
        userrole  usrole1 = new userrole();
        usrole1.Name ='vishal pawar Customer User';
        Contact con = new Contact();
        //con.AccountId=ac.Id;
        con.LastName='Pawar';
        insert con;
        Profile profileObj = [SELECT Id,name FROM Profile WHERE Name = 'Admin NUCO Colombia' OR Name ='Country Manager NUCO Colombia' LIMIT 1];
        
        User userObj = new User();
        userObj.Alias = 'zonaa';                                                            
        userObj.Email = 'himanshua.mehta@skinternational.com';                             
        userObj.ProfileId  = profileObj.ID;                                                     
        userObj.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        userObj.IsActive = true;  
        userObj.LastName='Terriotory Manager';
        userObj.CommunityNickname = 'zonalExe1222 Di'; 
        userObj.TimeZoneSidKey = 'Asia/Kolkata'; 
        userObj.LocaleSidKey = 'en_IN';                                    
        userObj.LanguageLocaleKey = 'en_US';                                             
        userObj.ForecastEnabled = false;                                                     
        userObj.EmailEncodingKey = 'ISO-8859-1';    
        userObj.Show_Inventory__c = false;                                                     
        userObj.Show_Credit_Limit__c = false; 
        //   u.UserRoleId=usrole.id;
        insert userObj;
        
        
        Sales_Org__c SalesOrgObj = new Sales_Org__c(
            Name = 'Colombia',           // Sales Org Name
            Company_Code__c = '5700',      // Company Code
            Sales_Org_Code__c = '5710',    // Sales Org Code
            Country_Code__c = 'CO'        // Country Code
        );
        insert SalesOrgObj;
        
        Division__c divisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert divisionObj;
        
        
        Distribution_Channel__c DistributionChannelObj = new Distribution_Channel__c(
            Name = '67',                        // Distribution Channel Name
            Distribution_Channel_Code__c = '67'  // Distribution Channel Code
        );
        insert DistributionChannelObj;
        
        
        Account accObj = new Account(
            Name = 'CASAGRO',                                   					   // Account Name
            Last_Name__c = 'CASAGRO',                                                 // Last Name
            SAP_Code__c = '0001052626',                                                    // SAP Customer Code
            Mobile__c = '000000000000',                                                    // Mobile
            Email__c = 'johanna.macias@uniphos.com',                                       // Email
            Order_Block__c = false,                                                        // Order Block
            TaxNumber2__c = '8300950488',                                                  // Tax Number 2
            Tax_Number_1__c = '830092048',                                                 // Tax Number 1
            Account_Type__c = 'Sold To Party',                                             // Account Type
           
         
            Billing_Street_1__c = 'KM 2 5 AUT A MEDELLIN PAR IND. PORTOS SABANA 80 BG95',  // Billing Street 1
            Sales_Org__c = SalesOrgObj.Id,                                              // Sales Org
            Division__c = divisionObj.Id,                                               // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                                   // Distribution Channel
            Depot_Code__c = 'CO00',                                                        // Depot Code
            Payment_Terms__c = 'UK10'
        );
        insert accObj;
        
        Sales_Order__c sobj = new Sales_Order__c(
            ownerId = userObj.Id,
            SFDC_Order_Number__c = '98352',                       // SFDC Order Number
            Desc_Punctuality__c = false,                           // Desc Punctuality
            Order_Status__c = 'Pending',                           // Order Status
            Order_Date__c = system.today(),              // Order Date,
            OrderSubStatus__c = 'Draft',                           // Order Sub-Status
            Punctuality_Discount__c = 0.00,                        // Punctuality Discount
            Program_Margin_Discount__c = 0.00,                     // Program Margin Discount (%)
            isOffline_Mobile_Order__c = false,                     // isOffline Mobile Order
            BrazilOrderSubmittedforApproval__c = true,             // Brazil Order Submitted for Approval
            Call_Process_Builder_Flow__c = false,                  // Call Process Builder Flow
            ProcessBuilderFlag__c = false,                         // Process Builder Flag
            BrazilSalesOrderApproved__c = false,                   // Brazil Sales Order Approved
            Turkey_Order_Send_for_Approval__c = false,             // Turkey Order Send for Approval
            Key_Account__c = false,                                // Key Account
            Customer_Approval__c = false,                          // Customer Approval
            Signed__c = false,                                     // Signed
            SentEmailIndonesia__c = false,                         // Sent Email Indonesia
            Sales_Org_lk__c = SalesOrgObj.Id,                   // Sales Org
            RequestforCancellationCheck__c = false,                // Request for Cancellation
            TM_Code__c = '00051115',                               // TM Code
            ApprovedBySDM__c = false,                              // Approved By SDM
            ApprovedBySOM__c = false,                              // Approved By SOM
            ApprovedByBM__c = false,                               // Approved By BM
            ApprovedBySOMifSDMisNull__c = false,                   // Approved By SOM if SDM is Null
            Approved_By_SD__c = false,                             // Approved By SD
            Division_lk__c =divisionObj.Id,                    // Division
            Distribution_Channel_lk__c = DistributionChannelObj.Id,        // Distribution Channel

         
            Sent_for_Manager_Approval_Mexico__c = true,            // Sent for Manager Approval
            Bill_To_Party__c =accObj.Id,                  // Bill To Party
            Sold_to_Party__c = accObj.Id,                 // Sold to Party
            createdDate = System.today()
            
        );
        insert sobj;
        
        
        
        System.runAs(userObj) {
            SalesOrderApprovalController SalesOrderApprovalControllerObj = new SalesOrderApprovalController();
            SalesOrderApprovalController.fetchAccountDetail(accObj.Name);
            SalesOrderApprovalController.fetchOwnerNameDetail(userObj.Name);
            SalesOrderApprovalController.searchHelperOnAccountKeyPres(accObj.Name);
            SalesOrderApprovalController.searchHelperOnOwnerNameKeyPres(userObj.Name);
            SalesOrderApprovalController.fetchProfile();
            Date dt = System.today();
            System.debug('Date is '+dt);
            
            SalesOrderApprovalController.fetchSalesOrder1(accObj.Id, null, 'My_Pending_Orders', null, 'false');
            // if(accountId!=null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'My_Pending_Orders', null, false);
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'none', null, false);
            
            //!!!!
            //if(accountId!=null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'My_Pending_Orders', dt, true);
            
            
            //if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'none', dt, true); 
            //if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'My_Pending_Orders', null, false);
            // if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'My_Pending_Orders', dt, true);
            //if(accountId ==null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'none', dt, true);
            //if(accountId == null && statusOrder =='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'none', null, false);
            //if(accountId != null && statusOrder =='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'none', null, false);
            //if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'My_Pending_Orders', null, false);
            
            
            //Then
            //if(accountId == null && statusOrder =='none' && strtDate != null && edDate != null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, dt, 'none', dt, true);
            
            //if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'My_Pending_Orders', null, false);
            
            
            
            
            
            //Rejected
            SalesOrderApprovalController SalesOrderApprovalControllerObj1 = new SalesOrderApprovalController();
            SalesOrderApprovalController.fetchSalesOrder1(accObj.Id, null, 'Rejected', null, 'false');
            // if(accountId!=null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'Rejected', null, false);
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'none', null, false);
            
            
            //!!!!
            //if(accountId!=null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'Rejected', dt, true);
            
            
            //if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'none', dt, true); 
            //if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'Rejected', null, false);
            // if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'Rejected', dt, true);
            //if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'Rejected', null, false);
            
            
            //Then
            //if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'Rejected', null, false);
            
            
            
            
            
            //Approved
            SalesOrderApprovalController SalesOrderApprovalControllerObj2 = new SalesOrderApprovalController();
            SalesOrderApprovalController.fetchSalesOrder1(accObj.Id, null, 'Approved', null, 'false');
            // if(accountId!=null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'Approved', null, false);
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'none', null, false);
            
            
            //!!!!
            //if(accountId!=null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'Approved', dt, true);
            
            
            //if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'none', dt, true); 
            //if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'Approved', null, false);
            // if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'Approved', dt, true);
            //if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'Approved', null, false);
            
            
            
            //Then
            //if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'Approved', null, false);
            
            
            
            
            //PendingForOthers
            
            SalesOrderApprovalController SalesOrderApprovalControllerObj3 = new SalesOrderApprovalController();
            SalesOrderApprovalController.fetchSalesOrder1(accObj.Id, null, 'PendingForOthers', null, 'false');
            // if(accountId!=null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'PendingForOthers', null, false);
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'none', null, false);
            
            //!!!!
            //if(accountId!=null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId == null)
            // SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'PendingForOthers', dt, false);
            
            
            //if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'none', dt, true);  
            //if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'PendingForOthers', null, false);
            // if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'PendingForOthers', dt, true);
            //if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'PendingForOthers', null, false);
            
            
            //Then
            //if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'PendingForOthers', null, false);
            
            
            
            
        }
        
        
        
        
    }//End of Method
    
    static testMethod void validateData4() {
        userrole  usrole1 = new userrole();
        usrole1.Name ='vishal pawar Customer User';
        Contact con = new Contact();
        //con.AccountId=ac.Id;
        con.LastName='Pawar';
        insert con;
        Profile profileObj = [SELECT Id,name FROM Profile WHERE Name = 'Country Manager NUCO Colombia' LIMIT 1];
        
        User userObj = new User();
        userObj.Alias = 'zonaa';                                                            
        userObj.Email = 'himanshua.mehta@skinternational.com';                             
        userObj.ProfileId  = profileObj.ID;                                                     
        userObj.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        userObj.IsActive = true;  
        userObj.LastName='Terriotory Manager';
        userObj.CommunityNickname = 'zonalExe1222 Di'; 
        userObj.TimeZoneSidKey = 'Asia/Kolkata'; 
        userObj.LocaleSidKey = 'en_IN';                                    
        userObj.LanguageLocaleKey = 'en_US';                                             
        userObj.ForecastEnabled = false;                                                     
        userObj.EmailEncodingKey = 'ISO-8859-1';    
        userObj.Show_Inventory__c = false;                                                     
        userObj.Show_Credit_Limit__c = false; 
        //   u.UserRoleId=usrole.id;
        insert userObj;
        
        
        Sales_Org__c SalesOrgObj = new Sales_Org__c(
            Name = 'Colombia',           // Sales Org Name
            Company_Code__c = '5700',      // Company Code
            Sales_Org_Code__c = '5710',    // Sales Org Code
            Country_Code__c = 'CO'        // Country Code
        );
        insert SalesOrgObj;
        
        Division__c divisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert divisionObj;
        
        
        Distribution_Channel__c DistributionChannelObj = new Distribution_Channel__c(
            Name = '67',                        // Distribution Channel Name
            Distribution_Channel_Code__c = '67'  // Distribution Channel Code
        );
        insert DistributionChannelObj;
        
        
        Account accObj = new Account(
            Name = 'CASAGRO',                                   					   // Account Name
            Last_Name__c = 'CASAGRO',                                                 // Last Name
            SAP_Code__c = '0001052626',                                                    // SAP Customer Code
            Mobile__c = '000000000000',                                                    // Mobile
            Email__c = 'johanna.macias@uniphos.com',                                       // Email
            Order_Block__c = false,                                                        // Order Block
            TaxNumber2__c = '8300950488',                                                  // Tax Number 2
            Tax_Number_1__c = '830092048',                                                 // Tax Number 1
            Account_Type__c = 'Sold To Party',                                             // Account Type
         
          
            Billing_Street_1__c = 'KM 2 5 AUT A MEDELLIN PAR IND. PORTOS SABANA 80 BG95',  // Billing Street 1
            Sales_Org__c = SalesOrgObj.Id,                                              // Sales Org
            Division__c = divisionObj.Id,                                               // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                                   // Distribution Channel
            Depot_Code__c = 'CO00',                                                        // Depot Code
            Payment_Terms__c = 'UK10'
        );
        insert accObj;
        
        Sales_Order__c sobj = new Sales_Order__c(
            ownerId = userObj.Id,
            SFDC_Order_Number__c = '98352',                       // SFDC Order Number
            Desc_Punctuality__c = false,                           // Desc Punctuality
            Order_Status__c = 'Pending',                           // Order Status
            Order_Date__c = system.today(),              // Order Date,
            OrderSubStatus__c = 'Draft',                           // Order Sub-Status
            Punctuality_Discount__c = 0.00,                        // Punctuality Discount
            Program_Margin_Discount__c = 0.00,                     // Program Margin Discount (%)
            isOffline_Mobile_Order__c = false,                     // isOffline Mobile Order
            BrazilOrderSubmittedforApproval__c = true,             // Brazil Order Submitted for Approval
            Call_Process_Builder_Flow__c = false,                  // Call Process Builder Flow
            ProcessBuilderFlag__c = false,                         // Process Builder Flag
            BrazilSalesOrderApproved__c = false,                   // Brazil Sales Order Approved
            Turkey_Order_Send_for_Approval__c = false,             // Turkey Order Send for Approval
            Key_Account__c = false,                                // Key Account
            Customer_Approval__c = false,                          // Customer Approval
            Signed__c = false,                                     // Signed
            SentEmailIndonesia__c = false,                         // Sent Email Indonesia
            Sales_Org_lk__c = SalesOrgObj.Id,                   // Sales Org
            RequestforCancellationCheck__c = false,                // Request for Cancellation
            TM_Code__c = '00051115',                               // TM Code
            ApprovedBySDM__c = false,                              // Approved By SDM
            ApprovedBySOM__c = false,                              // Approved By SOM
            ApprovedByBM__c = false,                               // Approved By BM
            ApprovedBySOMifSDMisNull__c = false,                   // Approved By SOM if SDM is Null
            Approved_By_SD__c = false,                             // Approved By SD
            Division_lk__c =divisionObj.Id,                    // Division
            Distribution_Channel_lk__c = DistributionChannelObj.Id,        // Distribution Channel
         
            
            Sent_for_Manager_Approval_Mexico__c = true,            // Sent for Manager Approval
            Bill_To_Party__c =accObj.Id,                  // Bill To Party
            Sold_to_Party__c = accObj.Id,                 // Sold to Party
            createdDate = System.today()
            
        );
        insert sobj;
        
    
        
        
        System.runAs(userObj) {
            SalesOrderApprovalController SalesOrderApprovalControllerObj = new SalesOrderApprovalController();
            SalesOrderApprovalController.fetchAccountDetail(accObj.Name);
            SalesOrderApprovalController.fetchOwnerNameDetail(userObj.Name);
            SalesOrderApprovalController.searchHelperOnAccountKeyPres(accObj.Name);
            SalesOrderApprovalController.searchHelperOnOwnerNameKeyPres(userObj.Name);
            SalesOrderApprovalController.fetchProfile();
            Date dt = System.today();
            System.debug('Date is '+dt);
            
            //for Pending
            SalesOrderApprovalController.fetchSalesOrder1(accObj.Id, null, 'My_Pending_Orders', null, 'false');
            // if(accountId!=null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'My_Pending_Orders', null, false);
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'none', null, false);
            
            //!!!!
            //if(accountId!=null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'My_Pending_Orders', dt, false);
            
            
            
            //if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'none', dt, false); 
            //if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'My_Pending_Orders', null, false);
            // if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'My_Pending_Orders', dt, false);
            //if(accountId ==null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'none', dt, false);
            //if(accountId == null && statusOrder =='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'none', null, false);
            //if(accountId != null && statusOrder =='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'none', null, false);
            //if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'My_Pending_Orders', null, false);
            
            
            //Then
            //if(accountId == null && statusOrder =='none' && strtDate != null && edDate != null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, dt, 'none', dt, false);
            
            //if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'My_Pending_Orders', null, false);
            
            
            
            
            
            //For Rejected
            SalesOrderApprovalController SalesOrderApprovalControllerObj1 = new SalesOrderApprovalController();
            SalesOrderApprovalController.fetchSalesOrder1(accObj.Id, null, 'Rejected', null, 'false');
            // if(accountId!=null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'Rejected', null, false);
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'none', null, false);
            
            //!!!!
            //if(accountId!=null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'Rejected', dt, false);
            
            
            //if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'none', dt, false); 
            //if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'Rejected', null, false);
            // if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'Rejected', dt, false);
            //if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'Rejected', null, false);
            
            //Then
            //if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'Rejected', null, false);
            
            
            
            //Approved
            
            SalesOrderApprovalController SalesOrderApprovalControllerObj2 = new SalesOrderApprovalController();
            SalesOrderApprovalController.fetchSalesOrder1(accObj.Id, null, 'Approved', null, 'false');
            // if(accountId!=null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'Approved', null, false);
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'none', null, false);
            
            //!!!!
            //if(accountId!=null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'Approved', dt, false);
            
            
            //if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'none', dt, false); 
            //if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'Approved', null, false);
            // if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'Approved', dt, false);
            //if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'Approved', null, false);
            
            
            //Then
            //if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'Approved', null, false);
            
            
            
            
            //PendingForOthers
            
            SalesOrderApprovalController SalesOrderApprovalControllerObj3 = new SalesOrderApprovalController();
            SalesOrderApprovalController.fetchSalesOrder1(accObj.Id, null, 'PendingForOthers', null, 'false');
            // if(accountId!=null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'PendingForOthers', null, false);
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'none', null, false);
            
            
            //!!!!
            //if(accountId!=null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'PendingForOthers', dt, false);
            
            
            //if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'none', dt, false); 
            //if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'PendingForOthers', null, false);
            // if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'PendingForOthers', dt, false);
            //if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'PendingForOthers', null, false);
            
            
            //Then
            //if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'PendingForOthers', null, false);
            
            
        }
        
        
        
        
    }
    
    
    
    static testMethod void validateData5() {
        userrole  usrole1 = new userrole();
        usrole1.Name ='vishal pawar Customer User';
        Contact con = new Contact();
        //con.AccountId=ac.Id;
        con.LastName='Pawar';
        insert con;
        Profile profileObj = [SELECT Id,name FROM Profile WHERE Name = 'Country Manager NUCO Colombia' LIMIT 1];
        
        User userObj = new User();
        userObj.Alias = 'zonaa';                                                            
        userObj.Email = 'himanshua.mehta@skinternational.com';                             
        userObj.ProfileId  = profileObj.ID;                                                     
        userObj.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        userObj.IsActive = true;  
        userObj.LastName='Terriotory Manager';
        userObj.CommunityNickname = 'zonalExe1222 Di'; 
        userObj.TimeZoneSidKey = 'Asia/Kolkata'; 
        userObj.LocaleSidKey = 'en_IN';                                    
        userObj.LanguageLocaleKey = 'en_US';                                             
        userObj.ForecastEnabled = false;                                                     
        userObj.EmailEncodingKey = 'ISO-8859-1';    
        userObj.Show_Inventory__c = false;                                                     
        userObj.Show_Credit_Limit__c = false; 
        //   u.UserRoleId=usrole.id;
        insert userObj;
        
        
        Sales_Org__c SalesOrgObj = new Sales_Org__c(
            Name = 'Colombia',           // Sales Org Name
            Company_Code__c = '5700',      // Company Code
            Sales_Org_Code__c = '5710',    // Sales Org Code
            Country_Code__c = 'CO'        // Country Code
        );
        insert SalesOrgObj;
        
        Division__c divisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert divisionObj;
        
        
        Distribution_Channel__c DistributionChannelObj = new Distribution_Channel__c(
            Name = '67',                        // Distribution Channel Name
            Distribution_Channel_Code__c = '67'  // Distribution Channel Code
        );
        insert DistributionChannelObj;
        
        
        Account accObj = new Account(
            Name = 'CASAGRO',                                   					   // Account Name
            Last_Name__c = 'CASAGRO',                                                 // Last Name
            SAP_Code__c = '0001052626',                                                    // SAP Customer Code
            Mobile__c = '000000000000',                                                    // Mobile
            Email__c = 'johanna.macias@uniphos.com',                                       // Email
            Order_Block__c = false,                                                        // Order Block
            TaxNumber2__c = '8300950488',                                                  // Tax Number 2
            Tax_Number_1__c = '830092048',                                                 // Tax Number 1
            Account_Type__c = 'Sold To Party',                                             // Account Type
         
          
            Billing_Street_1__c = 'KM 2 5 AUT A MEDELLIN PAR IND. PORTOS SABANA 80 BG95',  // Billing Street 1
            Sales_Org__c = SalesOrgObj.Id,                                              // Sales Org
            Division__c = divisionObj.Id,                                               // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                                   // Distribution Channel
            Depot_Code__c = 'CO00',                                                        // Depot Code
            Payment_Terms__c = 'UK10'
        );
        insert accObj;
        
        Sales_Order__c sobj = new Sales_Order__c(
            ownerId = userObj.Id,
            SFDC_Order_Number__c = '98352',                       // SFDC Order Number
            Desc_Punctuality__c = false,                           // Desc Punctuality
            Order_Status__c = 'Pending',                           // Order Status
            Order_Date__c = system.today(),              // Order Date,
            OrderSubStatus__c = 'Draft',                           // Order Sub-Status
            Punctuality_Discount__c = 0.00,                        // Punctuality Discount
            Program_Margin_Discount__c = 0.00,                     // Program Margin Discount (%)
            isOffline_Mobile_Order__c = false,                     // isOffline Mobile Order
            BrazilOrderSubmittedforApproval__c = true,             // Brazil Order Submitted for Approval
            Call_Process_Builder_Flow__c = false,                  // Call Process Builder Flow
            ProcessBuilderFlag__c = false,                         // Process Builder Flag
            BrazilSalesOrderApproved__c = false,                   // Brazil Sales Order Approved
            Turkey_Order_Send_for_Approval__c = false,             // Turkey Order Send for Approval
            Key_Account__c = false,                                // Key Account
            Customer_Approval__c = false,                          // Customer Approval
            Signed__c = false,                                     // Signed
            SentEmailIndonesia__c = false,                         // Sent Email Indonesia
            Sales_Org_lk__c = SalesOrgObj.Id,                   // Sales Org
            RequestforCancellationCheck__c = false,                // Request for Cancellation
            TM_Code__c = '00051115',                               // TM Code
            ApprovedBySDM__c = false,                              // Approved By SDM
            ApprovedBySOM__c = false,                              // Approved By SOM
            ApprovedByBM__c = false,                               // Approved By BM
            ApprovedBySOMifSDMisNull__c = false,                   // Approved By SOM if SDM is Null
            Approved_By_SD__c = false,                             // Approved By SD
            Division_lk__c =divisionObj.Id,                    // Division
            Distribution_Channel_lk__c = DistributionChannelObj.Id,        // Distribution Channel
         
            
            Sent_for_Manager_Approval_Mexico__c = true,            // Sent for Manager Approval
            Bill_To_Party__c =accObj.Id,                  // Bill To Party
            Sold_to_Party__c = accObj.Id,                 // Sold to Party
            createdDate = System.today()
            
        );
        insert sobj;
        
    
        
        
        System.runAs(userObj) {
            SalesOrderApprovalController SalesOrderApprovalControllerObj = new SalesOrderApprovalController();
            SalesOrderApprovalController.fetchAccountDetail(accObj.Name);
            SalesOrderApprovalController.fetchOwnerNameDetail(userObj.Name);
            SalesOrderApprovalController.searchHelperOnAccountKeyPres(accObj.Name);
            SalesOrderApprovalController.searchHelperOnOwnerNameKeyPres(userObj.Name);
            SalesOrderApprovalController.fetchProfile();
            Date dt = System.today();
            System.debug('Date is '+dt);
            
            //for Pending
            SalesOrderApprovalController.fetchSalesOrder1(accObj.Id, null, 'Draft', null, 'false');
            // if(accountId!=null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'Draft', null, false);
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'none', null, false);
            
            //!!!!
            //if(accountId!=null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'Draft', dt, false);
            
            
            
            //if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'none', dt, false); 
            //if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'Draft', null, false);
            // if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'Draft', dt, false);
            //if(accountId ==null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'none', dt, false);
            //if(accountId == null && statusOrder =='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'none', null, false);
            //if(accountId != null && statusOrder =='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'none', null, false);
            //if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'Draft', null, false);
            
            
            //Then
            //if(accountId == null && statusOrder =='none' && strtDate != null && edDate != null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, dt, 'none', dt, false);
            
            //if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'Draft', null, false);
            
            
            
            
            
            //For Rejected
            SalesOrderApprovalController SalesOrderApprovalControllerObj1 = new SalesOrderApprovalController();
            SalesOrderApprovalController.fetchSalesOrder1(accObj.Id, null, 'Rejected', null, 'false');
            // if(accountId!=null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'Draft', null, false);
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'none', null, false);
            
            //!!!!
            //if(accountId!=null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'Draft', dt, false);
            
            
            //if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'none', dt, false); 
            //if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'Draft', null, false);
            // if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'Draft', dt, false);
            //if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'Draft', null, false);
            
            //Then
            //if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'Draft', null, false);
            
            
            
            //Approved
            
            SalesOrderApprovalController SalesOrderApprovalControllerObj2 = new SalesOrderApprovalController();
            SalesOrderApprovalController.fetchSalesOrder1(accObj.Id, null, 'Draft', null, 'false');
            // if(accountId!=null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'Draft', null, false);
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'none', null, false);
            
            //!!!!
            //if(accountId!=null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'Draft', dt, false);
            
            
            //if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'none', dt, false); 
            //if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'Draft', null, false);
            // if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'Draft', dt, false);
            //if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'Draft', null, false);
            
            
            //Then
            //if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'Draft', null, false);
            
            
            
            
            //PendingForOthers
            
            SalesOrderApprovalController SalesOrderApprovalControllerObj3 = new SalesOrderApprovalController();
            SalesOrderApprovalController.fetchSalesOrder1(accObj.Id, null, 'Draft', null, 'false');
            // if(accountId!=null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'Draft', null, false);
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, null, 'none', null, false);
            
            
            //!!!!
            //if(accountId!=null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, dt, 'Draft', dt, false);
            
            
            //if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, null, dt, 'none', dt, false); 
            //if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, null, 'Draft', null, false);
            // if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null)
            SalesOrderApprovalController.fetchSalesOrder(null, null, dt, 'Draft', dt, false);
            //if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(accObj.Id, userObj.Id, null, 'Draft', null, false);
            
            
            //Then
            //if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null)
            SalesOrderApprovalController.fetchSalesOrder(null, userObj.Id, null, 'Draft', null, false);
            
        }
        
    }// end of method
    
    
    
    
    
    
}//end of class