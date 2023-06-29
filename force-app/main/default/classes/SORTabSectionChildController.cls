/*******************************************************************************************
* @Name         Sales Order Return 
* @Author       Nikhil Dhoke (SKI)
* @Date         03/03/2023
* @Group        SKI
* @Description  This class is used for Sales Order Return Module (Brazil Only).
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer         	   Date(MM/DD/YYYY)      Description
*-------------------------------------------------------------------------------------------   
*  1.0             Nikhil Dhoke            03/04/2023            Initial Creation                                        
*******************************************************************************************/
public without sharing class SORTabSectionChildController {


    /*
    * @Description - This method will return Territory object value based on id.
    * @Param String - territory id.
    * @return  - Territory object.
    */
    @AuraEnabled
    public static Territory_Distributor__c getKEDEUsers(String terId){
        Territory_Distributor__c ter = new Territory_Distributor__c();
        try{
            /* List<Customer_and_Region_Mapping__c> custRegList = [SELECT Id, Name, Active__c, Account_Active__c, 
                                                                Customer_Name__c, CustomerRegion__c  
                                                                FROM Customer_and_Region_Mapping__c WHERE 
                                                                Customer_Name__c =: accId ORDER BY LastModifiedDate DESC LIMIT 1]; */
            if(terId.length()>0){
                List<Territory_Distributor__c> terList = [SELECT Id, Name, TerritoryManager__c, Region__c, Regional_Manager__c, TerritoryCode__c, 
                                                         Regional_Manager_Id__c, Zone__c, Zonal_Manager_Id__c, Zonal_Head__c, 
                                                         SBU__c, SBU__r.SBUUser__c, SBU_Name__c, Region__r.Name, Region__r.RegionCode__c 
                                                         FROM Territory_Distributor__c WHERE Id =: terId];
                if(terList.size()>0){
                    ter = terList[0];
                }                                         
            }                                                    
        } catch (Exception e) {
            System.debug('getKEDEUsers Exception is - '+ e.getMessage());
            System.debug('getKEDEUsers Exception at - '+ e.getLineNumber());
            //throw new AuraHandledException(e.getMessage());
        }
        return ter;
    }

    /*
    * @Description - This method will return Account details based on id.
    * @Param String - account id,
             String - territory id
    * @return  - Wrapper object.
    */
    @AuraEnabled(cacheable=true)
    public static TabSectionWrapper getAccountDetails(String accId,String terId){
        System.debug('account id - '+ accId);
        TabSectionWrapper tabWrap = new TabSectionWrapper();
        try {
            List<Account> accList = [SELECT Id, Name, Type, BillingStreet, BillingCity, BillingState, 
                                        BillingPostalCode, BillingCountry, BillingAddress, Phone, SAP_Code__c, 
                                        Account_Type__c, Email__c, Mobile__c, Sales_Org__c, Customer_Region__c, 
                                        Tax_Number_Br_Portal_Filter__c  
                                        FROM Account WHERE Id =: accId LIMIT 1];
            if(accList.size()>0){
                //tabWrap.sorId = accList[0].;
                tabWrap.accountId = accList[0].Id;
                tabWrap.accountSAPCode = accList[0].SAP_Code__c;
                tabWrap.cnpjCPF = accList[0].Tax_Number_Br_Portal_Filter__c;
                //tabWrap.contact = accList[0].;
                tabWrap.email = accList[0].Email__c;
                //tabWrap.costCenter = accList[0].;
                if(accList[0].BillingStreet != null || accList[0].BillingStreet != ''){
                    tabWrap.address = accList[0].BillingStreet;
                }
                if(accList[0].BillingCity != null || accList[0].BillingCity != ''){
                    tabWrap.address += ', '+ accList[0].BillingCity;
                    tabWrap.city = accList[0].BillingCity;
                }
                if(accList[0].BillingState != null || accList[0].BillingState != ''){
                    tabWrap.address += ', '+ accList[0].BillingState;
                    tabWrap.suburb = accList[0].BillingState;
                }
                if(accList[0].BillingCountry != null || accList[0].BillingCountry != ''){
                    tabWrap.address += ', '+ accList[0].BillingCountry;
                }
                if(accList[0].BillingPostalCode != null || accList[0].BillingPostalCode != ''){
                    tabWrap.address += ', '+ accList[0].BillingPostalCode;
                    tabWrap.postCode = accList[0].BillingPostalCode;
                }
                                    
                //tabWrap.branch = accList[0].;
                //tabWrap.farm = accList[0].;
                tabWrap.state = accList[0].Customer_Region__c; // suburb and state variables interchanged as requested...
                tabWrap.phoneNumber = accList[0].Mobile__c;
                tabWrap.requestersName = UserInfo.getName();
                tabWrap.requesterId = UserInfo.getUserId();

                if(accList[0].Customer_Region__c  != null){
                    List<State__C> stateList = [SELECT Id, Name, Country_Code__c, Country__c, State_Code__c, 
                                                Active__c, Region__c, State_Code_Census__c, SalesOrg__c, Days__c, 
                                                Email_Id_s__c FROM State__c WHERE State_Code__c =: accList[0].Customer_Region__c];
                    if(stateList.size() > 0 && stateList[0].Days__c != null){
                        tabWrap.estimatedCollectionDate = string.valueof(System.today() + integer.valueof(stateList[0].Days__c));
                    }                            
                }   
            }   

            Territory_Distributor__c ter = SORTabSectionChildController.getKEDEUsers(terId);   
            if(ter != null){
                tabWrap.salesDistMangr = ter.Regional_Manager_Id__c != null ? ter.Regional_Manager__c : null;
                tabWrap.salesOfficeMngr = ter.Zonal_Manager_Id__c != null ? ter.Zonal_Head__c : '';
                tabWrap.salesDirector = ter.SBU__r.SBUUser__c != null ? ter.SBU_Name__c : null;
            }                  
            
        } catch (Exception e) {
            System.debug('Exception is - '+ e.getMessage());
            System.debug('Exception at - '+ e.getLineNumber());
            //throw new AuraHandledException(e.getMessage());
        }
        System.debug('tabWrap - '+ tabWrap);
        return tabWrap;
    }

    /*
    * @Description - This method will return Customer Service records for a SOR.
    * @Param String - SOR id
    * @return  - List of Wrapper object.
    */
    @AuraEnabled(cacheable=true)
    public static List<CustomerServiceWrapper> getCustomerServices(String sorId) {
        List<CustomerServiceWrapper> customerSerList = new List<CustomerServiceWrapper>();
        try{
            List<RSO_with_Customer_Service__c> csList = [SELECT Id, Name, Return_Sales_Order__c, SAP_Order_Number__c, Invoice__c, Invoice__r.Name, 
                                                        Billing_Doc__c, Invoice_Date__c, Inco_Term__c, Inco_Term_2__c, Sub_Return_Type__c, 
                                                        Sub_Return_Type__r.Sub_Return_Type_Code__c, Deposit__c, Deposit__r.Deposit_Code__c, 
                                                        Deposit_Flag__c, Order_Type__c, Full_Return__c, Customer_Invoice__c, Customer_Invoice_Date__c,   
                                                        Quantity__c, Quantity_Flag__c, Billing_Doc_Item_Number__c, Order_Type__r.Order_Type_Code__c, 
                                                        Billing_Doc_Item_Number__r.Invoice_Line_Item__r.SKU__r.Name, Invoice__r.Nota_Fiscal__c,  
                                                        Billing_Doc_Item_Number__r.Invoice_Line_Item__r.Billing_DOC_reference_number__c  
                                                        FROM RSO_with_Customer_Service__c WHERE Return_Sales_Order__c =: sorId];
            if(csList.size()>0){
                for(RSO_with_Customer_Service__c rsoCS : csList){
                    Integer count = 0;
                    CustomerServiceWrapper csWrap = new CustomerServiceWrapper();
                    csWrap.recId = rsoCS.Id;
                    csWrap.sorId = rsoCS.Return_Sales_Order__c;
                    csWrap.invoice = rsoCS.Invoice__c;
                    csWrap.billingDoc = rsoCS.Billing_Doc__c;
                    csWrap.invoiceName = rsoCS.Invoice__r.Nota_Fiscal__c;
                    csWrap.returnType = rsoCS.Sub_Return_Type__c;
                    csWrap.returnTypeName = rsoCS.Sub_Return_Type__r.Sub_Return_Type_Code__c;
                    csWrap.invoiceDate = string.valueof(rsoCS.Invoice_Date__c);
                    csWrap.incoTerm = rsoCS.Inco_Term__c;
                    csWrap.incoTerm2 = rsoCS.Inco_Term_2__c;
                    csWrap.fullReturn = rsoCS.Full_Return__c;

                    if(rsoCS.Deposit__c != null){
                        csWrap.deposit = rsoCS.Deposit__c;
                        csWrap.depositName = rsoCS.Deposit__r.Deposit_Code__c;
                        csWrap.depositFlag = rsoCS.Deposit_Flag__c;
                    }

                    if(rsoCS.Full_Return__c == false && rsoCS.Billing_Doc_Item_Number__c != null){
                        csWrap.productId = rsoCS.Billing_Doc_Item_Number__c; // SOR Item Id...
                        csWrap.productName = rsoCS.Billing_Doc_Item_Number__r.Invoice_Line_Item__r.SKU__r.Name;
                        csWrap.quantity = rsoCS.Quantity__c;
                        //csWrap.maxQuantity = 0;
                        csWrap.quantityFlag = rsoCS.Quantity_Flag__c;
                        csWrap.billingDocNum = rsoCS.Billing_Doc_Item_Number__r.Invoice_Line_Item__r.Billing_DOC_reference_number__c; // SOR Item Name...
                    }
                    
                    if(rsoCS.Customer_Invoice_Date__c != null){
                        csWrap.custInvoiceDt = string.valueof(rsoCS.Customer_Invoice_Date__c);
                    }
                    
                    if(rsoCS.Order_Type__c != null){
                        csWrap.docType = rsoCS.Order_Type__c;
                        csWrap.docTypeName = rsoCS.Order_Type__r.Order_Type_Code__c;
                    }
                    
                    if(rsoCS.SAP_Order_Number__c != null){
                        csWrap.sapNo = rsoCS.SAP_Order_Number__c;
                        csWrap.disableAction = true;
                    }
                    
                    if(rsoCS.Customer_Invoice__c != null){
                        csWrap.custInvoice = rsoCS.Customer_Invoice__c;
                    }
                    
                    csWrap.srNo = count;
                    customerSerList.add(csWrap);
                    count ++;
                }
            }                                    

        } catch(Exception e){
            System.debug('getCustomerServices Exception is - '+ e.getMessage());
            System.debug('getCustomerServices Exception at - '+ e.getLineNumber());
        }

        return customerSerList;
    }

    /*
    * @Description - This method will return List of Wrapper for custoemr service based on SOR item.
    * @Param List - SOR item List,
             Sobject - Return_Sales_Order__c.
    * @return  - List of Wrapper object.
    */
    @AuraEnabled(cacheable=true)
    public static List<CustomerServiceWrapper> rsoItemToCustomerService(List<SORProductDetailsChildController.ProductDetailsWrapper> rsoItemList,Return_Sales_Order__c rso){
        List<CustomerServiceWrapper> custServList = new List<CustomerServiceWrapper>();
        Set<String> invoiceSet = new Set<String>();
        
        try{
            if(rsoItemList.size()>0){
                String zcerId = '';
                List<OrderTypeWrapper> ordTypList = SORTabSectionChildController.getOrderTypes();
                if(ordTypList.size()>0){
                    for(OrderTypeWrapper otw : ordTypList){
                        if(otw.orderCode == 'ZCER'){
                            zcerId = otw.recId;
                            break;
                        }
                    }
                }
                for(SORProductDetailsChildController.ProductDetailsWrapper rsoItem: rsoItemList){
                    //if(!invoiceSet.contains(rsoItem.invoiceId)){  // for unique record entry...
                        CustomerServiceWrapper csWrap = new CustomerServiceWrapper();
                        csWrap.sorId = rso.Id;
                        csWrap.billingDoc = rsoItem.billingDoc;
                        csWrap.invoice = rsoItem.invoiceId;
                        csWrap.returnType = rso.Return_Sub_Type__c;
                        csWrap.invoiceDate = rsoItem.invoiceDate;
                        csWrap.incoTerm = rsoItem.incoTerm;
                        csWrap.incoTerm2 = '.'; // default...
                        csWrap.fullReturn = false;

                        if(rso.Refusal__c == 'No'){
                            csWrap.productId = rsoItem.recId;
                            csWrap.quantity = 0;
                            csWrap.quantityFlag = '';
                        }
                        else{
                            if(String.IsNotBlank(zcerId)){
                                csWrap.docType = zcerId;
                            }
                        }
                        custServList.add(csWrap);
                        invoiceSet.add(rsoItem.invoiceId);
                    //}
                }
            }
        } catch(Exception e){
            System.debug('rsoItemToCustomerService Exception is - '+ e.getMessage());
            System.debug('rsoItemToCustomerService Exception at - '+ e.getLineNumber());
        }
        return custServList;
    }

    /*
    * @Description - This method will return List of Wrapper for invoices and Deposite.
    * @Param String - SOR id.
    * @return  - List of Wrapper object.
    */
    @AuraEnabled(cacheable=true)
    public static List<CustomerServiceWrapper> getInvoicesAndDeposite(String sorId){
        List<CustomerServiceWrapper> invoicesList = new List<CustomerServiceWrapper>();
        try{
            List<Return_Sales_Order_Line_Item__c> rsoInvoiceList = [SELECT Id, Name, Return_Sales_Order__c, Return_Sales_Order__r.Return_Sub_Type__c, 
                                                                    Return_Sales_Order__r.Return_Sub_Type__r.Sub_Return_Type_Code__c, 
                                                                    Invoice__c, Invoice__r.Name, Invoice__r.SAP_Billing_DOC__c, 
                                                                    Invoice__r.Billing_Date__c, Invoice__r.Sales_Order__r.Inco_Term__c, 
                                                                    Invoice__r.Sales_Order__r.Inco_Term_Code__c, Invoice__r.Nota_Fiscal__c,  
                                                                    Invoice_Line_Item__r.SKU__r.Name, Invoice_Line_Item__r.SKU_Code__c, 
                                                                    Invoice_Line_Item__r.Billing_DOC_reference_number__c, Invoice_Line_Item__c, 
                                                                    Volumn_KG_LT__c, Return_Sales_Order__r.Customer__r.Brazil_Depot_Code__c  
                                                                    FROM Return_Sales_Order_Line_Item__c WHERE Return_Sales_Order__c =: sorId];
            if(rsoInvoiceList.size()>0){
                List<RSO_Deposit__c> depositList = SORTabSectionChildController.getDeposit(rsoInvoiceList[0].Return_Sales_Order__r.Customer__r.Brazil_Depot_Code__c,rsoInvoiceList[0].Return_Sales_Order__r.Return_Sub_Type__c);
                String depstId = '';
                String depstName = '';
                String depstFlag = '';
                if(depositList.size()>0){
                    depstId = depositList[0].Id;
                    depstName = depositList[0].Deposit_Code__c;
                    depstFlag = 'X';
                }
                for(Return_Sales_Order_Line_Item__c rsoLI : rsoInvoiceList){
                    //if(!invcMap.containsKey(rsoLI.Invoice__c)){
                        CustomerServiceWrapper csWrap = new CustomerServiceWrapper();
                        csWrap.sorId = rsoLI.Return_Sales_Order__c;
                        csWrap.billingDoc = rsoLI.Invoice__r.SAP_Billing_DOC__c;
                        csWrap.invoice = rsoLI.Invoice__c;
                        csWrap.invoiceName = rsoLI.Invoice__r.Nota_Fiscal__c;
                        csWrap.returnType = rsoLI.Return_Sales_Order__r.Return_Sub_Type__c;
                        csWrap.returnTypeName = rsoLI.Return_Sales_Order__r.Return_Sub_Type__r.Sub_Return_Type_Code__c;
                        csWrap.invoiceDate = string.valueof(rsoLI.Invoice__r.Billing_Date__c);
                        csWrap.incoTerm = 'FOB';  // hard coded as per requirement.. //rsoLI.Invoice__r.Sales_Order__r.Inco_Term_Code__c;
                        csWrap.incoTerm2 = '.'; // default...
                        csWrap.fullReturn = false;
                        csWrap.productId = rsoLI.Id;
                        Integer intgr = integer.valueOf(rsoLI.Invoice_Line_Item__r.SKU_Code__c);
                        csWrap.productName = rsoLI.Invoice_Line_Item__r.SKU__r.Name+'-'+string.valueOf(intgr);//rsoLI.Invoice_Line_Item__r.SKU_Code__c;
                        //csWrap.maxQuantity = rsoLI.Volumn_KG_LT__c;
                        csWrap.billingDocNum = rsoLI.Invoice_Line_Item__r.Billing_DOC_reference_number__c;
                        csWrap.deposit = depstId;
                        csWrap.depositName = depstName;
                        csWrap.depositFlag = depstFlag;
                        invoicesList.add(csWrap);
                       // invcMap.put(rsoLI.Invoice__c,rsoLI.Invoice__c);
                   // }
                }
            }                                                        

        } catch(Exception e){
            System.debug('getInvoicesAndDeposite Exception is - '+ e.getMessage());
            System.debug('getInvoicesAndDeposite Exception at - '+ e.getLineNumber());
        }
        return invoicesList;
    }

    /*
    * @Description - This method will return Order types for Brazil.
    * @Param - .
    * @return  - List of Wrapper object.
    */
    @AuraEnabled(cacheable=true)
    public static List<OrderTypeWrapper> getOrderTypes(){
        List<OrderTypeWrapper> orderTpList = new List<OrderTypeWrapper>();
        try{
            List<Order_Type__c> typeList = [SELECT Id, Name, Description__c, Order_Type_Code__c, SalesOrg__c,  
                                            Combination_Key__c FROM Order_Type__c WHERE SalesOrg__r.Sales_org_code__c ='5191'];
            if(typeList.size()>0){
                for(Order_Type__c ot : typeList){
                    OrderTypeWrapper otw = new OrderTypeWrapper();
                    otw.recId = ot.Id;
                    otw.name = ot.Name;
                    otw.orderCode = ot.Order_Type_Code__c;

                    orderTpList.add(otw);
                }
            }                                
        } catch(Exception e){
            System.debug('getOrderTypes Exception is - '+ e.getMessage());
            System.debug('getOrderTypes Exception at - '+ e.getLineNumber());
        }
        return orderTpList;
    }

    /*
    * @Description - This method will check Invoice is maked full or not.
    * @Param String - Invoice id.
    * @return  - String value based on condition.
    */
    @AuraEnabled(cacheable=true)
    public static String checkInvoiceFullReturn(String invcId){
        String result ='';
        Boolean flag = false;
        try{
            List<RSO_with_Customer_Service__c> custSerList = [SELECT Id, Full_Return__c, Billing_Doc_Item_Number__c, 
                                                                Billing_Doc_Item_Number__r.Invoice__c FROM RSO_with_Customer_Service__c 
                                                                WHERE Billing_Doc_Item_Number__r.Invoice__c =: invcId];
            if(custSerList.size()>0){
                result = 'Partial Return';
                for(RSO_with_Customer_Service__c cs : custSerList){
                    if(cs.Full_Return__c == true){
                        result = 'Full Return';
                        break;
                    }
                }
            } 
            else{
                result = 'No Return';
            }                                                   

        } catch(Exception e){
            System.debug('checkInvoiceFullReturn Exception is - '+ e.getMessage());
            System.debug('checkInvoiceFullReturn Exception at - '+ e.getLineNumber());
        }
        return result;
    }

    /*
    * @Description - This method will check how much quantity balance for SOR item.
    * @Param String - SOR id,
             String - SOR item id.
    * @return  - decimal value.
    */
    @AuraEnabled(cacheable=true)
    public static Decimal checkBalanceQuantity(String sorId, String sorLiId){
        System.debug('sorId - '+ sorId);
        System.debug('sorLiId - '+ sorLiId);
        Decimal result = 0;
        try{
            List<RSO_with_Customer_Service__c> custSerList = [SELECT Id, Name, Quantity__c, Return_Sales_Order__c, Billing_Doc_Item_Number__c, 
                                                                Billing_Doc_Item_Number__r.Volumn_KG_LT__c FROM RSO_with_Customer_Service__c 
                                                                WHERE Billing_Doc_Item_Number__c =:sorLiId  AND Return_Sales_Order__c =:sorId];
            if(custSerList.size()>0){
                Decimal totalQuantity = custSerList[0].Billing_Doc_Item_Number__r.Volumn_KG_LT__c;
                Decimal usedQuantity = 0;
                for(RSO_with_Customer_Service__c cs : custSerList){
                    usedQuantity += cs.Quantity__c;
                }
                result = totalQuantity - usedQuantity;
            }   
            else{
                List<Return_Sales_Order_Line_Item__c> rsoLI = [SELECT Id, Name, Return_Sales_Order__c, Volumn_KG_LT__c FROM Return_Sales_Order_Line_Item__c 
                                                                WHERE Id =: sorLiId];
                if(rsoLI.size()>0){
                    result = rsoLI[0].Volumn_KG_LT__c;
                }                                                
            }                                                 
        } catch(Exception e){
            System.debug('checkBalanceQuantity Exception is - '+ e.getMessage());
            System.debug('checkBalanceQuantity Exception at - '+ e.getLineNumber());
        }
        System.debug('result - '+ result);
        return result;
    }

    /*
    * @Description - This method will return list of Customer service with SAP numbers. But right now this method is not used as tab is hidden on UI.
    * @Param String - SOR id
    * @return  - List of Wrapper object.
    */
    @AuraEnabled(cacheable=true)
    public static List<SAPOrderWrapper> getSAPOrders(String sorId) {
        List<SAPOrderWrapper> sapOrderList = new List<SAPOrderWrapper>();
        try{
            List<RSO_with_SAP_Return_Order__c> sapList = [SELECT Id, Name, Return_Sales_Order__c, SAP_Order_Number__c, 
                                                        Branch__c, Email__c, Customer_Invoice__c FROM 
                                                        RSO_with_SAP_Return_Order__c WHERE Return_Sales_Order__c =: sorId];
            if(sapList.size()>0){
                for(RSO_with_SAP_Return_Order__c rsoCS : sapList){
                    Integer count = 0;
                    SAPOrderWrapper sapWrap = new SAPOrderWrapper();
                    sapWrap.sorId = rsoCS.Return_Sales_Order__c;
                    sapWrap.orderNumber = rsoCS.SAP_Order_Number__c;
                    sapWrap.branch = rsoCS.Branch__c;
                    sapWrap.email = rsoCS.Email__c;
                    sapWrap.custInvoice = rsoCS.Customer_Invoice__c;
                    sapWrap.srNo = count;
                    sapWrap.recId = rsoCS.Id;

                    sapOrderList.add(sapWrap);
                    count ++;
                }
            }                                    

        } catch(Exception e){
            System.debug('getSAPOrders Exception is - '+ e.getMessage());
            System.debug('getSAPOrders Exception at - '+ e.getLineNumber());
        }

        return sapOrderList;
    }

    /*
    * @Description - This method will delete custoemr service record.
    * @Param String - record id.
    * @return  - string value.
    */
    @AuraEnabled
    public static string deleteCustomerService(String recId){
        System.debug('recId - '+ recId);
        String result = '';
        try{
            if(recId != '' || recId != null){
                DELETE [SELECT Id, Name FROM RSO_with_Customer_Service__c WHERE Id=: recId];
                result = 'success';
            }
        }
        catch(Exception e){
            result = 'fail';
            System.debug('Exception is - '+ e.getMessage());
            System.debug('Exception at - '+ e.getLineNumber());
        }
        return result;
    }

    /*
    * @Description - This method is not in use right now as tab is hidden on UI.
    * @Param String - record id.
    * @return  - string value.
    */
    @AuraEnabled(cacheable=true)
    public static string deleteSAPOrder(String recId){
        String result = '';
        try{
            if(recId != '' || recId != null){
                //DELETE [SELECT Id, Name FROM RSO_with_Customer_Service__c WHERE Id=: recId];
                result = 'success';
            }
        }
        catch(Exception e){
            result = 'fail';
            System.debug('Exception is - '+ e.getMessage());
            System.debug('Exception at - '+ e.getLineNumber());
        }
        return result;
    }

    @AuraEnabled(cacheable=true)
    public static List<RSO_Deposit__c> getDeposit(String depoId,String subReturnId){
        List<RSO_Deposit__c> depositList = new List<RSO_Deposit__c>();
        try{
            depositList = [SELECT Id, Name, Deposit_Code__c, Depot__c, Return_Sub_Status__c FROM RSO_Deposit__c WHERE 
                            Depot__c =: depoId AND Return_Sub_Status__c =: subReturnId ORDER BY LastModifiedDate DESC];
        }catch(Exception e){
            System.debug('getDeposit is - '+ e.getMessage());
            System.debug('getDeposit at - '+ e.getLineNumber());
        }
        return depositList;
    } 

    public class TabSectionWrapper{

        @AuraEnabled public String sorId;
        @AuraEnabled public String accountId;
        @AuraEnabled public String accountSAPCode;
        @AuraEnabled public String cnpjCPF;
        @AuraEnabled public String contact;
        @AuraEnabled public String email;
        @AuraEnabled public String costCenter;
        @AuraEnabled public String address;
        @AuraEnabled public String postCode;
        @AuraEnabled public String state;
        @AuraEnabled public String branch;
        @AuraEnabled public String farm;
        @AuraEnabled public String suburb;
        @AuraEnabled public String city;
        @AuraEnabled public String phoneNumber;
        @AuraEnabled public String requestersName;
        @AuraEnabled public String requesterId;     //
        @AuraEnabled public String salesDistMangr;
        @AuraEnabled public String salesOfficeMngr;
        @AuraEnabled public String salesDirector;
        @AuraEnabled public String returnDetails;
        @AuraEnabled public Decimal returnAmount;
        @AuraEnabled public String proceedWithRtrn;
        @AuraEnabled public String necessaryTechInspectn;
        @AuraEnabled public String inspectionDate;
        @AuraEnabled public Decimal costQA;
        @AuraEnabled public String contention;
        @AuraEnabled public String estimatedCollectionDate;
        @AuraEnabled public String logisticOperatorMail;
        @AuraEnabled public String actualCollectionDate;
        @AuraEnabled public String dateOfSubToLogisticPartner;
        @AuraEnabled public String closingDate;
        @AuraEnabled public List<CustomerServiceWrapper> customerServiceList;
        @AuraEnabled public List<SAPOrderWrapper> sapOrderList;
        @AuraEnabled public Boolean isEdit;
        @AuraEnabled public Boolean isLOEEdit; // logistics operator email..
        @AuraEnabled public Boolean isACDEdit; // actual collection date..
        @AuraEnabled public Boolean isCDEdit; // closing date...
        @AuraEnabled public Boolean isQualityEdit; // quality ...
        @AuraEnabled public Boolean isCSEdit;  // customer service..
        @AuraEnabled public Boolean sendToMaterial;
        @AuraEnabled public String refusal;
        @AuraEnabled public Boolean qualityFlag; // quality approver...

        public TabSectionWrapper() {
            sorId = '';
            accountId = '';
            accountSAPCode = '';
            cnpjCPF = '';
            contact = '';
            email = '';
            costCenter = '';
            address = '';
            postCode = '';
            state = '';
            branch = '';
            farm = '';
            suburb = '';
            city = '';
            phoneNumber = '';
            requestersName = UserInfo.getName();
            requesterId = UserInfo.getUserId();
            salesDistMangr = '';
            salesOfficeMngr = '';
            salesDirector = '';
            returnDetails = '';
            returnAmount = 0;
            proceedWithRtrn = '';
            necessaryTechInspectn = '';
            inspectionDate = '';//string.valueof(System.today());
            costQA = 0;
            contention = '';
            estimatedCollectionDate = string.valueof(System.today());
            logisticOperatorMail = '';
            actualCollectionDate = '';//string.valueof(System.today());
            dateOfSubToLogisticPartner = '';//string.valueof(System.today());
            closingDate = '';//string.valueof(System.today());
            customerServiceList = new List<CustomerServiceWrapper>();
            sapOrderList = new List<SAPOrderWrapper>();
            isEdit = false;
            isLOEEdit = true; // logistics operator email..
            isACDEdit = true; // actual collection date..
            isCDEdit = true; // closing date...
            isQualityEdit = true; // quality ...
            isCSEdit = true;  // customer service..
            sendToMaterial = false;
            refusal = '';
            qualityFlag = true; // quality approver...
        }

    }

    public class CustomerServiceWrapper{

        @AuraEnabled public String recId;
        @AuraEnabled public String sorId;
        @AuraEnabled public String billingDoc;
        @AuraEnabled public String invoice;
        @AuraEnabled public String invoiceName;
        @AuraEnabled public String custInvoice;
        @AuraEnabled public String returnType;
        @AuraEnabled public String returnTypeName;
        @AuraEnabled public Integer srNo;
        @AuraEnabled public String invoiceDate;
        @AuraEnabled public String incoTerm;
        @AuraEnabled public String incoTerm2;
        @AuraEnabled public Boolean fullReturn;
        @AuraEnabled public String deposit;
        @AuraEnabled public String depositName;
        @AuraEnabled public String depositFlag;
        @AuraEnabled public String productId;
        @AuraEnabled public String productName;
        @AuraEnabled public Decimal quantity;
        @AuraEnabled public Decimal maxQuantity;
        @AuraEnabled public String quantityFlag;
        @AuraEnabled public String billingDocNum; 
        @AuraEnabled public String custInvoiceDt;
        @AuraEnabled public String docType;
        @AuraEnabled public String sapNo;
        @AuraEnabled public Boolean disableAction;
        @AuraEnabled public String docTypeName;

        public CustomerServiceWrapper(){
            recId = '';
            sorId = '';
            billingDoc = '';
            invoice = '';
            invoiceName = '';
            custInvoice = '';
            returnType = '';
            returnTypeName = '';
            srNo = 0;
            invoiceDate = '';
            incoTerm = '';
            incoTerm2 = '';
            fullReturn = false;
            deposit = '';
            depositName = '';
            depositFlag = '';
            productId = ''; // SOR Item Id...
            productName = '';
            quantity = 0;
            maxQuantity = 0;
            quantityFlag = '';
            billingDocNum = ''; // SOR Item Name...
            custInvoiceDt = '';
            docType = '';
            sapNo = '';
            disableAction = false;
            docTypeName = '';
        }
    }

    public class SAPOrderWrapper{
        @AuraEnabled public String sorId;
        @AuraEnabled public String orderNumber;
        @AuraEnabled public String branch;
        @AuraEnabled public String email;
        @AuraEnabled public String custInvoice;
        @AuraEnabled public Integer srNo;
        @AuraEnabled public String recId;

        public SAPOrderWrapper(){
            sorId = '';
            orderNumber = '';
            branch = '';
            email = '';
            custInvoice = '';
            srNo = 0;
            recId = '';
        }
    }

    public class OrderTypeWrapper{
        @AuraEnabled public String recId;
        @AuraEnabled public String name;
        @AuraEnabled public String orderCode;

        public OrderTypeWrapper(){
            recId = '';
            name = '';
            orderCode = '';
        }
    }
    
}