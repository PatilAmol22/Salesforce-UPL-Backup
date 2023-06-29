/*******************************************************************************************
* @Name         Sales Order Return 
* @Author       Nikhil Dhoke (SKI)
* @Date         15/02/2023
* @Group        SKI
* @Description  This class is used for Sales Order Return Module (Brazil Only).
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer         	   Date(MM/DD/YYYY)      Description
*-------------------------------------------------------------------------------------------   
*  1.0             Nikhil Dhoke            03/04/2023            Initial Creation                                        
*******************************************************************************************/
public without sharing class SORParentController {
    
    /*
    * @Description - This method get called when Sales Order Return interface get loaded.
    * @Param String - Sales Order Return Id.
    * @return  -    returns Sales Order return wrapper class with SOR details.
    */
    @AuraEnabled(cacheable=true)
    public static SORParentWrapper getSORDetails(String sorId){
        SORParentWrapper sorWrap = new SORParentWrapper();
        
        try {
            sorWrap.profileName = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1].Name;
            sorWrap.orderDetailsWrap.profileName = sorWrap.profileName;
            
            if(sorWrap.profileName == System.Label.Brazil_Sales_Person){ // Brazil Sales Person
                List<Territory_Distributor__c> terList = [SELECT Id, Name, TerritoryManager__c FROM Territory_Distributor__c WHERE 
                                                          TerritoryManager__c =: userinfo.getUserId() ORDER BY LastModifiedDate DESC LIMIT 1];
                if(terList.size()>0){
                    sorWrap.orderDetailsWrap.terId = terList[0].Id;
                }       
                sorWrap.isKeyAccountMngr = SORParentController.checkKeyAccountManager(userinfo.getUserId());                                   
            }
            if(sorWrap.profileName == System.Label.Brazil_Sales_District_Manager){//Brazil Sales District Manager
                List<Region__c> regnList = [SELECT Id, Name, RegionHead__c, RegionCode__c FROM Region__c WHERE 
                                            RegionHead__c =: userinfo.getUserId() ORDER BY LastModifiedDate DESC LIMIT 1];
                if(regnList.size()>0){
                    sorWrap.orderDetailsWrap.regnId = regnList[0].Id;
                }                            
            }
           
            if(sorId.length() > 0){//Sub_Type__c,
                List<Return_Sales_Order__c> rsoList = [SELECT Id, Name, Invoice__c, Order_Status__c, Total_Amount__c, 
                                                    Date_of_Incident__c, RSO_SFDC_Number__c, RSO_SAP_Number__c, 
                                                    Logistics_Operator__c, Return_Type__c, Return_Sub_Type__c,  
                                                    Customer_Name__c, Customer_CNPJ_CPF__c, Send_to_Material_Assessment__c, 
                                                    Customer_Contact__c, Customer_Email__c, Customer_Cost_Center__c, 
                                                    Customer_Address__c, Customer_Postcode__c, Customer_State__c, 
                                                    Customer_Branch__c, Customer_FARM__c, Customer_SUBRUB__c, 
                                                    Customer_City__c, Customer_Phone_Number__c, Return_Details__c, 
                                                    Return_Amount__c, Necessary_Technical_Inspection__c, Cost_QA__c, 
                                                    Proceed_with_Return__c, Inspection_Date__c, Contention__c, 
                                                    Estimated_Collection_Date__c, Actual_Collection_Date__c, RSO_Raised_By__c, 
                                                    Logistics_Operator_Email__c, Date_of_Submission_to_logistics_Partner__c, 
                                                    Closing_Date__c, Quality_Manager__c, Sub_Status__c, Refusal__c, Customer__c, 
                                                    Customer__r.Name, Customer__r.SAP_Code__c, Reinvoicing__c, Comment__c, 
                                                    Credit_Analyst__c, Credit_Analyst__r.Full_Name__c, Sales_Order_Number__c,
                                                    Sales_District_Manager__c, Sales_District_Manager__r.Full_Name__c,
                                                    Sales_Office_Manager__c, Sales_Office_Manager__r.Full_Name__c, 
                                                    Sales_Director__c, Sales_Director__r.Full_Name__c, 
                                                    CreatedById, CreatedBy.Full_Name__c, CreatedDate, Distributor_Territory__c     
                                                    FROM Return_Sales_Order__c WHERE Id =: sorId LIMIT 1];
                if(rsoList.size()>0){
                    for(Return_Sales_Order__c rso : rsoList){

                        sorWrap.sorId = rso.Id;
                        sorWrap.rsoRaisedBy = rso.RSO_Raised_By__c;
                        sorWrap.orderDetailsWrap.returnOrderNumber = rso.Name;
                        sorWrap.orderDetailsWrap.refusal = rso.Refusal__c;
                        sorWrap.orderDetailsWrap.reInvoicing = rso.Reinvoicing__c;
                        sorWrap.orderDetailsWrap.dateOfIncident = string.valueof(rso.Date_of_Incident__c);
                        sorWrap.orderDetailsWrap.logisticsOperator = rso.Logistics_Operator__c;
                        sorWrap.orderDetailsWrap.returnType = rso.Return_Type__c;
                        sorWrap.orderDetailsWrap.returnSubType = rso.Return_Sub_Type__c;
                        //sorWrap.orderDetailsWrap.subType = rso.Sub_Type__c;
                        sorWrap.orderDetailsWrap.accountId = rso.Customer__c;
                        sorWrap.orderDetailsWrap.accountName = rso.Customer__r.Name;
                        sorWrap.orderDetailsWrap.status = rso.Order_Status__c;
                        sorWrap.orderDetailsWrap.subStatus = rso.Sub_Status__c;
                        sorWrap.orderDetailsWrap.soNumber = rso.Sales_Order_Number__c;

                        if(rso.Credit_Analyst__c != null){
                            sorWrap.orderDetailsWrap.creditAnalyst = rso.Credit_Analyst__c;
                            sorWrap.orderDetailsWrap.creditAnalystName = rso.Credit_Analyst__r.Full_Name__c;
                        }

                        sorWrap.orderDetailsWrap.requester = rso.CreatedBy.Full_Name__c;
                        sorWrap.orderDetailsWrap.requesterId = rso.CreatedById;
                        Date d = rso.CreatedDate.date();
                        sorWrap.orderDetailsWrap.createDate = string.valueOf(d);
                        sorWrap.orderDetailsWrap.returnDetails = rso.Return_Details__c;

                        if(rso.Distributor_Territory__c != null){
                            sorWrap.orderDetailsWrap.distTerId = rso.Distributor_Territory__c;
                        }

                        sorWrap.tabSectionWrap.sorId = rso.Id;
                        sorWrap.tabSectionWrap.accountId = rso.Customer__c;
                        sorWrap.tabSectionWrap.accountSAPCode = rso.Customer__r.SAP_Code__c;
                        sorWrap.tabSectionWrap.cnpjCPF = rso.Customer_CNPJ_CPF__c;
                        sorWrap.tabSectionWrap.contact = rso.Customer_Contact__c;
                        sorWrap.tabSectionWrap.email = rso.Customer_Email__c;
                        sorWrap.tabSectionWrap.costCenter = rso.Customer_Cost_Center__c;
                        sorWrap.tabSectionWrap.address = rso.Customer_Address__c;
                        sorWrap.tabSectionWrap.postCode = rso.Customer_Postcode__c;
                        sorWrap.tabSectionWrap.state = rso.Customer_State__c;
                        sorWrap.tabSectionWrap.branch = rso.Customer_Branch__c;
                        sorWrap.tabSectionWrap.farm = rso.Customer_FARM__c;
                        sorWrap.tabSectionWrap.suburb = rso.Customer_SUBRUB__c;
                        sorWrap.tabSectionWrap.city = rso.Customer_City__c;
                        sorWrap.tabSectionWrap.phoneNumber = rso.Customer_Phone_Number__c;
                        //sorWrap.tabSectionWrap.returnDetails = rso.Return_Details__c;
                        sorWrap.tabSectionWrap.returnAmount = rso.Return_Amount__c;
                        sorWrap.tabSectionWrap.costQA = rso.Cost_QA__c;
                        sorWrap.tabSectionWrap.proceedWithRtrn = rso.Proceed_with_Return__c;
                        sorWrap.tabSectionWrap.necessaryTechInspectn = rso.Necessary_Technical_Inspection__c;
                        sorWrap.tabSectionWrap.inspectionDate = string.valueof(rso.Inspection_Date__c);
                        sorWrap.tabSectionWrap.contention = rso.Contention__c;
                        sorWrap.tabSectionWrap.estimatedCollectionDate = string.valueof(rso.Estimated_Collection_Date__c);
                        sorWrap.tabSectionWrap.actualCollectionDate = string.valueof(rso.Actual_Collection_Date__c);
                        sorWrap.tabSectionWrap.sendToMaterial = rso.Send_to_Material_Assessment__c;
                        sorWrap.tabSectionWrap.refusal = rso.Refusal__c;

                        if(rso.Logistics_Operator_Email__c != null){
                            sorWrap.tabSectionWrap.logisticOperatorMail = rso.Logistics_Operator_Email__c;
                        }
                        
                        sorWrap.tabSectionWrap.dateOfSubToLogisticPartner = string.valueof(rso.Date_of_Submission_to_logistics_Partner__c);
                        sorWrap.tabSectionWrap.closingDate = string.valueof(rso.Closing_Date__c);
                        
                        if(rso.Sales_District_Manager__c != null){
                            sorWrap.tabSectionWrap.salesDistMangr = rso.Sales_District_Manager__r.Full_Name__c;
                        }
                        if(rso.Sales_Office_Manager__c != null){
                            sorWrap.tabSectionWrap.salesOfficeMngr = rso.Sales_Office_Manager__r.Full_Name__c;
                        }
                        if(rso.Sales_Director__c != null){
                            sorWrap.tabSectionWrap.salesDirector = rso.Sales_Director__r.Full_Name__c;
                        }
                                                
                        if(rso.Order_Status__c == 'Draft' || rso.Order_Status__c == 'Rejected'){
                            sorWrap.isEdit = true;
                        }
                        else if(rso.Order_Status__c == 'Pending'){
                            if(sorWrap.profileName == 'Brazil Quality Team'){
                                sorWrap.tabSectionWrap.qualityFlag = false;
                            }
                            if(sorWrap.profileName == 'Brazil Quality Team' && (rso.Sub_Status__c == 'Pending At Quality Team' || rso.Sub_Status__c == 'Pending At Inspection Team')){
                                sorWrap.isApproveReject = true;
                            }
                            else if(sorWrap.profileName == 'Brazil Logistics Manager' && rso.Sub_Status__c == 'Pending At Logistic Manager'){
                                sorWrap.isApproveReject = true;
                            }
                            else if(sorWrap.profileName == 'Brazil Credit Team' && rso.Sub_Status__c == 'Pending At Credit Team'){
                                sorWrap.isApproveReject = true;
                            }
                            else if(sorWrap.profileName == System.Label.Brazil_Sales_District_Manager && (rso.Sub_Status__c == 'Pending At Sales District Manager' || rso.Sub_Status__c == 'Pending At Slow Moving Manager')){
                                sorWrap.isApproveReject = true;
                            }
                            else if(sorWrap.profileName == 'Brazil Sales Office Manager' && rso.Sub_Status__c == 'Pending At Sales Office Manager'){
                                sorWrap.isApproveReject = true;
                            }
                            else if(sorWrap.profileName == 'Brazil Sales Director' && (rso.Sub_Status__c == 'Pending At Sales Director' || rso.Sub_Status__c == 'Pending At CCO')){   // Updated substatus for cco   for RITM0569625 GRZ(Dheeraj Sharma) 20-06-2023
                                sorWrap.isApproveReject = true;
                            }
                            else if(sorWrap.profileName == 'Brazil Operation Manager' && rso.Sub_Status__c == 'Pending At Operational Manager'){
                                sorWrap.isApproveReject = true;
                            }
                            else if(sorWrap.profileName == 'Brazil Accounts Receivable' && (rso.Sub_Status__c == 'Pending At CFO' ||  rso.Sub_Status__c == 'Pending at Region Finance Head' )){ // Updated substatus for cco   for RITM0569625 GRZ(Dheeraj Sharma) 20-06-2023
                                sorWrap.isApproveReject = true;
                            }
                            else if(sorWrap.profileName == 'Brazil Supply Director' && rso.Sub_Status__c == 'Pending At Supply Director'){
                                sorWrap.isApproveReject = true;
                            }
                            else if(UserInfo.getUserName() == System.Label.SMM_User_Name_For_SOR && rso.Sub_Status__c == 'Pending At Slow Moving Manager'){
                                sorWrap.isApproveReject = true;
                            }
                            
                        }
                        /* else if(rso.Order_Status__c != 'Completely processed' && rso.Order_Status__c != 'Approved' && rso.Order_Status__c != null){
                            if((sorWrap.profileName == System.Label.Brazil_System_Administrator || sorWrap.profileName == System.Label.Brazil_Customer_Service_User) && rso.RSO_Raised_By__c != 'Customer service'){
                                sorWrap.isEdit = true; 
                            }
                            else if(sorWrap.profileName == 'Brazil Logistics' && (rso.RSO_Raised_By__c != 'Logistics' || rso.RSO_Raised_By__c != 'Customer service')){
                                sorWrap.isEdit = true;
                            }
                            else if(sorWrap.profileName == System.Label.Brazil_Sales_District_Manager && (rso.RSO_Raised_By__c == 'Key Account Manager' || rso.RSO_Raised_By__c == 'Sales Rep')){
                                sorWrap.isEdit = true;
                            }
                        } */

                        if(sorWrap.isEdit == false && rso.Order_Status__c == 'Approved'){
                            if(rso.Sub_Status__c == 'Pending At Book Collection' && sorWrap.profileName == 'Brazil Logistics'){
                                sorWrap.tabSectionWrap.isLOEEdit = false;
                                sorWrap.isAttachment = true;
                            }
                            else if(rso.Sub_Status__c == 'Pending At Collection' && sorWrap.profileName == 'Brazil Logistics'){
                                sorWrap.tabSectionWrap.isACDEdit = false;
                                sorWrap.isAttachment = true;
                            }
                            else if((rso.Sub_Status__c == 'Pending At Customer Service' || rso.Sub_Status__c == 'Pending At Process Return') && sorWrap.profileName == System.Label.Brazil_Customer_Service_User){
                                sorWrap.tabSectionWrap.isCSEdit = false;
                            }
                            else if(rso.Sub_Status__c == 'Pending At Process Return' && sorWrap.profileName == 'Brazil Logistics'){
                                sorWrap.tabSectionWrap.isCDEdit = false;
                                sorWrap.isAttachment = true;
                            }
                            else if(rso.Sub_Status__c == 'Pending At Material Assessment' && sorWrap.profileName == 'Brazil Quality Team'){
                                sorWrap.tabSectionWrap.isQualityEdit = false;
                            }
                        }
                    }
                } 
                Territory_Distributor__c ter = SORTabSectionChildController.getKEDEUsers(sorWrap.orderDetailsWrap.distTerId);
                if(ter != null){
                    sorWrap.orderDetailsWrap.region = ter.Name != null ? ter.Name : '' +'-'+ ter.TerritoryCode__c != null ? ter.TerritoryCode__c : '';
                    sorWrap.orderDetailsWrap.district = ter.Region__r.Name != null ? ter.Region__r.Name : '' +'-'+ ter.Region__r.RegionCode__c != null ? ter.Region__r.RegionCode__c : '';
                }
                List<Rebate_Contract__c> rebList = SOROrderDetailsChildController.getRebateContract(sorWrap.orderDetailsWrap.accountId);   
                if(rebList.size()>0){
                    sorWrap.orderDetailsWrap.rebContractName = rebList[0].Name;
                    sorWrap.orderDetailsWrap.rebContractId = rebList[0].Id;
                }
                /* SOROrderDetailsChildController.OrderDetailsWrapper odw = SOROrderDetailsChildController.getRebateRegionDistrict(sorWrap.orderDetailsWrap.accountId);
                sorWrap.orderDetailsWrap.rebContractName = odw.rebContractName;
                sorWrap.orderDetailsWrap.rebContractId = odw.rebContractId;
                sorWrap.orderDetailsWrap.region = odw.region;
                sorWrap.orderDetailsWrap.district = odw.district; */
                sorWrap.tabSectionWrap.customerServiceList = SORTabSectionChildController.getCustomerServices(sorId);
                sorWrap.tabSectionWrap.sapOrderList = SORTabSectionChildController.getSAPOrders(sorId);
                sorWrap.productWrapList = SORProductDetailsChildController.getSORItemList(sorId);
                sorWrap.attachmentWrapList = SORAttachmentChildController.getSORAttachments(sorId);
                if(sorWrap.isEdit == true){
                    if(SORProductDetailsChildController.invItemIdList.size()>0){
                        sorWrap.invItemAggregateMap = SORProductDetailsChildController.getInvoiceItemAggregate(SORProductDetailsChildController.invItemIdList);
                    }
                }
                //System.debug('sorWrap.invItemAggregateMap - '+ JSON.serializePretty(sorWrap.invItemAggregateMap));
            }
            else{
                sorWrap.isEdit = true;
                //System.debug('Inside else - '+ JSON.serializePretty(sorWrap));
            }
            
        } catch (Exception e) {
            System.debug('getSORDetails Exception is - '+ e.getMessage());
            System.debug('getSORDetails Exception at - '+ e.getLineNumber());
            //throw new AuraHandledException(e.getMessage());
        }
        System.debug('Inside sorWrap - '+ JSON.serializePretty(sorWrap));
        return sorWrap;
    }

    /*
    * @Description - This method get called at the time of SOR creation and updation.
    * @Param String - SOR Wrapper.
    * @return  -    returns SOR record id or error msg in case of error.
    */
    @AuraEnabled
    public static string createSOR(String sorDetailsString){
        String str='';
        String ordStatus = '';
        Boolean isCSFlag = false;
        Boolean quantityFlag = false;
        Boolean flag = false;
        String raisedBy = '';
        SORParentWrapper sorWrap = new SORParentWrapper();
        try {
            String profileName = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1].Name;
            sorWrap = (SORParentWrapper)JSON.deserialize(sorDetailsString, SORParentWrapper.class);
            System.debug('sorWrap - '+ sorWrap);
            Return_Sales_Order__c rso = new Return_Sales_Order__c();

            if(sorWrap.sorId.length() > 0){
                rso.Id = sorWrap.sorId;
            }
            else{
                rso.SalesOrg__c = [SELECT Id, Sales_Org_Code__c FROM Sales_Org__c WHERE Sales_Org_Code__c ='5191' ORDER BY LastModifiedDate DESC LIMIT 1].Id;
            }
           
            if(String.IsNotBlank(sorWrap.orderDetailsWrap.refusal)){
                rso.Refusal__c = sorWrap.orderDetailsWrap.refusal;
            }
            if(String.IsNotBlank(sorWrap.orderDetailsWrap.reInvoicing)){
                rso.Reinvoicing__c = sorWrap.orderDetailsWrap.reInvoicing;
            }
            if(String.IsNotBlank(sorWrap.orderDetailsWrap.dateOfIncident)){
                rso.Date_of_Incident__c = Date.valueof(sorWrap.orderDetailsWrap.dateOfIncident);
            }

            rso.Logistics_Operator__c = sorWrap.orderDetailsWrap.logisticsOperator;
            rso.Return_Type__c = sorWrap.orderDetailsWrap.returnType;

            if(String.IsNotBlank(sorWrap.orderDetailsWrap.returnSubType)){
                rso.Return_Sub_Type__c = sorWrap.orderDetailsWrap.returnSubType;
            }
            
            //rso.Sub_Type__c = sorWrap.orderDetailsWrap.subType;
            rso.Bill_To_Party__c = sorWrap.orderDetailsWrap.accountId;
            rso.Customer__c = sorWrap.orderDetailsWrap.accountId;
            rso.Customer_Name__c = sorWrap.orderDetailsWrap.accountName;
            rso.Sales_Order_Number__c = sorWrap.orderDetailsWrap.soNumber;

            if(String.IsNotBlank(sorWrap.orderDetailsWrap.creditAnalyst)){
                rso.Credit_Analyst__c = sorWrap.orderDetailsWrap.creditAnalyst; 
            }
            rso.Return_Details__c = sorWrap.orderDetailsWrap.returnDetails;//sorWrap.tabSectionWrap.returnDetails;

            if(String.IsNotBlank(sorWrap.orderDetailsWrap.distTerId)){
                rso.Distributor_Territory__c = sorWrap.orderDetailsWrap.distTerId;
            }

            rso.Customer_CNPJ_CPF__c = sorWrap.tabSectionWrap.cnpjCPF;
            rso.Customer_Contact__c = sorWrap.tabSectionWrap.contact;
            rso.Customer_Email__c = sorWrap.tabSectionWrap.email;
            rso.Customer_Cost_Center__c = sorWrap.tabSectionWrap.costCenter;
            rso.Customer_Address__c = sorWrap.tabSectionWrap.address;
            rso.Customer_Postcode__c = sorWrap.tabSectionWrap.postCode;
            rso.Customer_State__c = sorWrap.tabSectionWrap.state;
            rso.Customer_Branch__c = sorWrap.tabSectionWrap.branch;
            rso.Customer_FARM__c = sorWrap.tabSectionWrap.farm;
            rso.Customer_SUBRUB__c = sorWrap.tabSectionWrap.suburb;
            rso.Customer_City__c = sorWrap.tabSectionWrap.city;
            rso.Customer_Phone_Number__c = sorWrap.tabSectionWrap.phoneNumber;
            rso.Return_Amount__c = sorWrap.tabSectionWrap.returnAmount;
            rso.Estimated_Collection_Date__c = Date.valueof(sorWrap.tabSectionWrap.estimatedCollectionDate); 

            if(String.IsNotBlank(sorWrap.tabSectionWrap.proceedWithRtrn)){
                rso.Proceed_with_Return__c = sorWrap.tabSectionWrap.proceedWithRtrn;
            }
            if(String.IsNotBlank(sorWrap.tabSectionWrap.necessaryTechInspectn)){
                rso.Necessary_Technical_Inspection__c = sorWrap.tabSectionWrap.necessaryTechInspectn;
            }         
            if(String.IsNotBlank(sorWrap.tabSectionWrap.inspectionDate)){
                rso.Inspection_Date__c = Date.valueof(sorWrap.tabSectionWrap.inspectionDate);
            }

            if(sorWrap.tabSectionWrap.costQA != null){
                rso.Cost_QA__c = sorWrap.tabSectionWrap.costQA;
            }
              
            if(sorWrap.rsoRaisedBy == '' || sorWrap.rsoRaisedBy == null){
                if(profileName == 'Brazil Logistics' || profileName == System.Label.Brazil_Customer_Service_User){
                    if(sorWrap.orderDetailsWrap.refusal == 'Yes'){
                        rso.Logistics__c = SORParentController.getUserFromProfile('Brazil Logistics Manager') != '' ? SORParentController.getUserFromProfile('Brazil Logistics Manager') : null;
                    }
                    else if(sorWrap.orderDetailsWrap.refusal == 'No'){
                        rso.Logistics__c = SORParentController.getUserFromProfile('Brazil Logistics Manager') != '' ? SORParentController.getUserFromProfile('Brazil Logistics Manager') : null;
                        rso.Approver_1__c = SORParentController.getUserFromProfile('Brazil Operation Manager') != '' ? SORParentController.getUserFromProfile('Brazil Operation Manager') : null; // Operational Manager...
                    }
                }
                else if(profileName == System.Label.Brazil_Sales_Person || profileName == System.Label.Brazil_Sales_District_Manager){
                    Territory_Distributor__c ter = SORTabSectionChildController.getKEDEUsers(sorWrap.orderDetailsWrap.distTerId);
                    
                    rso.Sales_Office_Manager__c = ter.Zonal_Manager_Id__c != null ? ter.Zonal_Manager_Id__c: null;
                    rso.Slow_Moving_Manager__c = SORParentController.getUserByName('SAMUEL CUNHA DA SILVA') != '' ? SORParentController.getUserByName('SAMUEL CUNHA DA SILVA') : null;
                    rso.Sales_Director__c = ter.SBU__r.SBUUser__c != null ? ter.SBU__r.SBUUser__c: null;
                    
                    if(profileName == System.Label.Brazil_Sales_Person){
                        rso.Sales_District_Manager__c = ter.Regional_Manager_Id__c != null ? ter.Regional_Manager_Id__c: null;
                    }
                    if(sorWrap.orderDetailsWrap.returnType == 'Formulation' || sorWrap.orderDetailsWrap.returnType == 'Packaging' || sorWrap.orderDetailsWrap.returnType == 'Missing'){
                        rso.Approver_1__c = SORParentController.getUserFromProfile('Brazil Operation Manager') != '' ? SORParentController.getUserFromProfile('Brazil Operation Manager') : null; // Operational Manager...
                    }
                }

                if(sorWrap.productWrapList.size()>0){
                    List<Admin_MPT_Colombia__c> adminMpt = [SELECT Id, Name, Active__c, Maximum_Return_Value_BRL__c, 
                                                            Maximum_Return_Value_USD__c, Sales_Org__c FROM 
                                                            Admin_MPT_Colombia__c WHERE Sales_Org__r.Sales_Org_Code__c = '5191' 
                                                            ORDER BY LastModifiedDate DESC LIMIT 1];
                    if(adminMpt.size()>0){
                        if(sorWrap.productWrapList[0].currencyCode == 'USD'){
                            if(sorWrap.tabSectionWrap.returnAmount > adminMpt[0].Maximum_Return_Value_USD__c){
                                rso.CFO__c = SORParentController.getUserByName('Julio Pilenso') != '' ? SORParentController.getUserByName('Julio Pilenso') : null;
                                rso.Supply_Director__c = SORParentController.getUserFromProfile('Brazil Supply Director') != '' ? SORParentController.getUserFromProfile('Brazil Supply Director') : null;
                            }
                        }
                        else if(sorWrap.productWrapList[0].currencyCode == 'BRL'){
                            if(sorWrap.tabSectionWrap.returnAmount > adminMpt[0].Maximum_Return_Value_BRL__c){
                                rso.CFO__c = SORParentController.getUserByName('Julio Pilenso') != '' ? SORParentController.getUserByName('Julio Pilenso') : null;
                                rso.Supply_Director__c = SORParentController.getUserFromProfile('Brazil Supply Director') != '' ? SORParentController.getUserFromProfile('Brazil Supply Director') : null;
                            }
                        }
                    } 
                }                                       
            }

            if(sorWrap.sorId.length() == 0){
                if(profileName == System.Label.Brazil_Sales_Person){
                    Boolean isKeyAccountMngr = SORParentController.checkKeyAccountManager(userinfo.getUserId()); 
                    if(isKeyAccountMngr == true){
                        rso.RSO_Raised_By__c = 'Key Account Manager';
                    }
                    else{
                        rso.RSO_Raised_By__c = 'Sales Rep';
                    }
                }
                else if(profileName == System.Label.Brazil_Sales_District_Manager){
                    rso.RSO_Raised_By__c = 'Sales District Manager';
                }
                else if(profileName == 'Brazil Logistics'){//System.Label.Brazil_Logistics_Manager Brazil Logistics Manager
                    rso.RSO_Raised_By__c = 'Logistics';
                }
                else if(profileName == System.Label.Brazil_System_Administrator || profileName == System.Label.Brazil_Customer_Service_User){ // Brazil System Administrator, Brazil Customer Service User
                    rso.RSO_Raised_By__c = 'Customer Service';
                }

                raisedBy = rso.RSO_Raised_By__c;
            }
            else{
                raisedBy = sorWrap.rsoRaisedBy;
            }
            
            if(sorWrap.orderDetailsWrap.isDraft == true){
                //rso.Order_Status__c = 'Draft';
                ordStatus = 'Draft';
            }
            /* else if(sorWrap.orderDetailsWrap.refusal == 'Yes'){
                rso.Order_Status__c = 'Approved';
            } */
            else if(sorWrap.isEdit == true){
                //rso.Order_Status__c = 'Pending';
                ordStatus = 'Pending';
                if(raisedBy == 'Customer Service' || raisedBy == 'Logistics'){
                    rso.Sub_Status__c = 'Pending At Logistic Manager';
                }
                else{
                    rso.Sub_Status__c = 'Pending At Quality Team';
                }
            }
            else if(sorWrap.orderDetailsWrap.status == 'Approved'){
                
                if(profileName == 'Brazil Logistics' && sorWrap.orderDetailsWrap.subStatus == 'Pending At Book Collection'){

                    if(String.IsNotBlank(sorWrap.tabSectionWrap.logisticOperatorMail)){
                        rso.Logistics_Operator_Email__c = sorWrap.tabSectionWrap.logisticOperatorMail;
                    }
                    if(String.IsNotBlank(sorWrap.tabSectionWrap.dateOfSubToLogisticPartner)){
                        rso.Date_of_Submission_to_logistics_Partner__c = Date.valueof(sorWrap.tabSectionWrap.dateOfSubToLogisticPartner);
                    }
                    rso.Sub_Status__c = 'Pending At Collection';
                }
                else if(profileName == 'Brazil Logistics' && sorWrap.orderDetailsWrap.subStatus == 'Pending At Collection'){
                    
                    if(String.IsNotBlank(sorWrap.tabSectionWrap.actualCollectionDate)){
                        rso.Actual_Collection_Date__c = Date.valueof(sorWrap.tabSectionWrap.actualCollectionDate);
                    }
                    rso.Sub_Status__c = 'Pending At Customer Service';
                    flag = true;
                }
                else if(profileName == System.Label.Brazil_Customer_Service_User && (sorWrap.orderDetailsWrap.subStatus == 'Pending At Customer Service' || sorWrap.orderDetailsWrap.subStatus == 'Pending At Process Return')){
                    isCSFlag = true;
                    rso.Order_Status__c = 'Approved';
                    rso.Sub_Status__c = 'Pending At Process Return';
                }
                else if(profileName == 'Brazil Logistics' && sorWrap.orderDetailsWrap.subStatus == 'Pending At Process Return'){
                    if(String.IsNotBlank(sorWrap.tabSectionWrap.closingDate)){
                        rso.Closing_Date__c = Date.valueof(sorWrap.tabSectionWrap.closingDate);
                    }
                    
                    if(sorWrap.tabSectionWrap.sendToMaterial == true){
                        rso.Sub_Status__c = 'Pending At Material Assessment';
                    }
                    rso.Send_to_Material_Assessment__c = sorWrap.tabSectionWrap.sendToMaterial;
                }
                else if(profileName == 'Brazil Quality Team' && sorWrap.orderDetailsWrap.subStatus == 'Pending At Material Assessment'){
                    rso.Order_Status__c = 'Completely processed';
                    rso.Sub_Status__c = 'Completed';
                    rso.Contention__c = sorWrap.tabSectionWrap.contention;
                    quantityFlag = true;
                }
            }                                 
            System.debug('upsert rso - '+ JSON.serializePretty(rso));            
            UPSERT rso;
            str = rso.Id;
            
            if(rso.Id != null){
                if(sorWrap.isEdit == true){
                    SORParentController.createSORItem(sorWrap.productWrapList,rso.Id,ordStatus,quantityFlag);
                }
                if(sorWrap.isAttachment == true || sorWrap.isEdit == true){
                    SORParentController.createAttachments(sorWrap.attachmentWrapList,rso.Id);
                }

                if(quantityFlag == true){
                    SORParentController.createSORItem(sorWrap.productWrapList,rso.Id,ordStatus,quantityFlag);
                }
                
                if(isCSFlag == true){ //Nik..
                    SORParentController.createCustomerService(sorWrap.tabSectionWrap.customerServiceList,rso);
                }

                if(flag == true){
                    List<SORTabSectionChildController.CustomerServiceWrapper> custServList = SORTabSectionChildController.rsoItemToCustomerService(sorWrap.productWrapList,rso);
                    SORParentController.createCustomerService(custServList,rso);
                }
            }

        } catch (Exception e) {
            str = 'error';
            System.debug('createSOR Exception is - '+ e.getMessage());
            System.debug('createSOR Exception at - '+ e.getLineNumber());
            //throw new AuraHandledException(e.getMessage());
        }
        return str;
    }

    /*
    * @Description - This method get called after SOR record get created or updated.
    * @Param List - Wrapper object list,
             String - SOR id,
             String - Order status
             Boolean - boolean.
    * @return  -    .
    */
    public static void createSORItem(List<SORProductDetailsChildController.ProductDetailsWrapper> productWrapList, String rsoId, String ordStatus, Boolean qltFlag){
        List<Return_Sales_Order_Line_Item__c> rsoItemList = new List<Return_Sales_Order_Line_Item__c>();
        try{
            if(productWrapList.size()>0){
                for(SORProductDetailsChildController.ProductDetailsWrapper pdWrap : productWrapList){
                    Return_Sales_Order_Line_Item__c rsoItem = new Return_Sales_Order_Line_Item__c();
                    //System.debug('RSo item id - '+ pdWrap.recId);
                    //System.debug('RSo item id length- '+ pdWrap.recId.length());
                    if(pdWrap.recId.length() > 0){
                        rsoItem.Id = pdWrap.recId;
                    }
                    else {
                        rsoItem.Return_Sales_Order__c = rsoId;
                    }
                    rsoItem.Item_Number__c = string.valueof(pdWrap.srNo);
                    rsoItem.Invoice_Line_Item__c = pdWrap.invoiceItemId;
                    rsoItem.Invoice__c = pdWrap.invoiceId;
                    //rsoItem.Batch__c = pdWrap.batch;
                    rsoItem.Currency__c = pdWrap.currencyCode;
                    rsoItem.Volumn_KG_LT__c = pdWrap.volume;
                    rsoItem.Unit_Value__c = pdWrap.unitValue;
                    rsoItem.Total_Value__c = pdWrap.totalValue;
                    //rsoItem.Expire_Date__c = Date.valueof(pdWrap.expireDate); // formula field..
                    rsoItem.AT_AG__c = pdWrap.atAG;
                    rsoItem.Product_Damaged__c = pdWrap.productDamage;
                    rsoItem.Packing_Condition__c = pdWrap.packagingCondition;
                    rsoItem.Product_Condition__c = pdWrap.productCondition;
                    rsoItem.Comments__c = pdWrap.comments;

                    if(String.IsNotBlank(pdWrap.slowMoving)){
                        rsoItem.Slow_Moving__c = pdWrap.slowMoving;
                    }
                    if(String.IsNotBlank(pdWrap.productContention)){
                        rsoItem.Product_Contention__c = pdWrap.productContention;
                    }
                    if(String.IsNotBlank(pdWrap.productRework)){
                        rsoItem.Product_can_be_reworked__c = pdWrap.productRework;
                    }
                    
                    rsoItem.Rework_Cost__c = pdWrap.reworkCost;
                    rsoItem.Write_Off__c = pdWrap.writeOff;

                    rsoItemList.add(rsoItem);
                }
                if(rsoItemList.size()>0){
                    UPSERT rsoItemList;                    
                }
            }

            if(qltFlag == false){
                Return_Sales_Order__c rso = new Return_Sales_Order__c();
                rso.Id = rsoId;
                rso.Order_Status__c = ordStatus;
                rso.Call_RSO_Approval_Process__c = true;
                UPDATE rso;
            }

        } catch (Exception e) {
            System.debug('createSORItem Exception is - '+ e.getMessage());
            System.debug('createSORItem Exception at - '+ e.getLineNumber());
            //throw new AuraHandledException(e.getMessage());
        }
    }

    /*
    * @Description - This method get called after SOR creation and updation depending of some conditons.
    * @Param List - Wrapper object list,
             Sobject - Return_Sales_Order__c object.
    * @return  - .
    */
    public static void createCustomerService(List<SORTabSectionChildController.CustomerServiceWrapper> customerServiceList, Return_Sales_Order__c rso){
        List<RSO_with_Customer_Service__c> rsoCustomerServList = new List<RSO_with_Customer_Service__c>();
        System.debug('customerServiceList - '+ JSON.serializePretty(customerServiceList));
        Map<String,String> invcDocTpMap = new Map<String,String>();

        try{
            if(customerServiceList.size()>0){
                for(SORTabSectionChildController.CustomerServiceWrapper rsoCS : customerServiceList){
                    RSO_with_Customer_Service__c custServ = new RSO_with_Customer_Service__c();
                    if(rsoCS.sapNo.length() == 0){
                        if(rsoCS.recId.length() > 0){
                            custServ.Id = rsoCS.recId;
                        }
                        custServ.Return_Sales_Order__c = rso.Id; 
                        custServ.Invoice__c = rsoCS.invoice;
                        custServ.Billing_Doc__c = rsoCS.billingDoc;

                        if(String.IsNotBlank(rsoCS.invoiceDate)){
                            custServ.Invoice_Date__c = Date.valueof(rsoCS.invoiceDate);
                        }

                        custServ.Inco_Term__c = rsoCS.incoTerm;
                        custServ.Inco_Term_2__c = rsoCS.incoTerm2;
                        custServ.Sub_Return_Type__c = rsoCS.returnType;

                        if(String.IsNotBlank(rsoCS.deposit)){
                            custServ.Deposit__c = rsoCS.deposit;
                            custServ.Deposit_Flag__c = rsoCS.depositFlag;
                        }

                        if(String.IsNotBlank(rsoCS.docType)){
                            custServ.Order_Type__c = rsoCS.docType;
                        }
                        
                        custServ.Full_Return__c = rsoCS.fullReturn;

                        if(rsoCS.fullReturn == true){
                            invcDocTpMap.put(rsoCS.invoice,rsoCS.docTypeName);

                        }

                        if(rso.Refusal__c == 'No'){
                            custServ.Customer_Invoice__c = rsoCS.custInvoice;
                            if(String.IsNotBlank(rsoCS.custInvoiceDt)){
                                custServ.Customer_Invoice_Date__c = Date.valueof(rsoCS.custInvoiceDt);
                            }
                            
                            if(rsoCS.fullReturn == false){
                                custServ.Quantity__c = rsoCS.quantity;
                                custServ.Quantity_Flag__c = rsoCS.quantityFlag;
                                custServ.Billing_Doc_Item_Number__c = rsoCS.productId; // its a SOR Line item id..look up..
                            }
                        }                   

                        rsoCustomerServList.add(custServ);
                    }
                }
                
                if(rsoCustomerServList.size()>0){
                    UPSERT rsoCustomerServList;
                   
                    if(rso.Order_Status__c == 'Approved' && rso.Sub_Status__c == 'Pending At Process Return'){
                        List<String> custServIds = new List<String>();
                        List<String> fullCustServInvoiceIds = new List<String>();
                        
                        for(RSO_with_Customer_Service__c rcs : rsoCustomerServList){
                            if(rcs.Full_Return__c == true){
                                fullCustServInvoiceIds.add(rcs.Invoice__c);
                            }
                            
                            custServIds.add(rcs.Id);
                        }

                        if(!test.isRunningTest()){
                            SORIntegrationService.sendToIntegration(custServIds,fullCustServInvoiceIds,invcDocTpMap,rso.Id,rso.Refusal__c);
                        }
                        /* List<SORIntegrationService.HttpWrapper> httpWrapList = SORIntegrationService.sendToIntegration(rsoCustomerServList,rso);
                        System.debug('httpWrapList size 2 - '+ httpWrapList);
                       
                        if(httpWrapList.size()>0){
                            List<RSO_with_Customer_Service__c> cslist = new List<RSO_with_Customer_Service__c>();
                            for(SORIntegrationService.HttpWrapper httpWrap : httpWrapList){
                                cslist.addAll(SORIntegrationService.responseToCustmerService(httpWrap.response,httpWrap.request,rso.Refusal__c,rso.Id));
                            }
                            System.debug('integration call cslist size - '+ cslist.size());
                        } */
                        /* List<RSO_with_Customer_Service__c> cslist = SORIntegrationService.sendToIntegration(rsoCustomerServList,rso);
                        System.debug('integration call cslist size - '+ cslist.size());
                        if(cslist.size() > 0){
                            UPDATE cslist;
                        } */
                    }
                }
            }

        } catch (Exception e) {
            System.debug('createCustomerService Exception is - '+ e.getMessage());
            System.debug('createCustomerService Exception at - '+ e.getLineNumber());
            //throw new AuraHandledException(e.getMessage());
        }
    }

    /*
    * @Description - This method get called after SOR creation and updation depending of some conditons.
    * @Param List - Wrapper object list,
             String - SOR id.
    * @return  - .
    */
    public static void createAttachments(List<SORAttachmentChildController.AttachmentWrapper> attachList, String rsoId){
        List<String> docIdList = new List<String>();
        List<ContentDocumentLink> cdLinkList = new List<ContentDocumentLink>();
        try{
            if(attachList.size()>0){
                for(SORAttachmentChildController.AttachmentWrapper attch : attachList){
                    docIdList.add(attch.docId);
                    ContentDocumentLink cdLink = new ContentDocumentLink();
                    cdLink.LinkedEntityId = rsoId;
                    cdLink.ContentDocumentId = attch.docId;
                    cdLink.ShareType = 'V';
                    cdLink.Visibility = 'InternalUsers';

                    cdLinkList.add(cdLink);
                }

                if(docIdList.size()>0){
                    //System.debug('inside delete - '+ docIdList);
                    List<ContentDocumentLink> docList2 = new List<ContentDocumentLink>();
                    List<ContentDocumentLink> docList = [SELECT Id, ContentDocumentId, ShareType, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN: docIdList];
                    if(docList.size()>0){
                        for(ContentDocumentLink cd : docList){
                            if(cd.ShareType == 'V'){
                                docList2.add(cd);
                            }
                        }
                        if(docList2.size()>0){
                            DELETE docList2;
                        }
                    }
                }
                if(cdLinkList.size()>0){
                    INSERT cdLinkList;
                }
            }
        } catch (Exception e) {
            System.debug('createAttachments Exception is - '+ e.getMessage());
            System.debug('createAttachments Exception at - '+ e.getLineNumber());
            //throw new AuraHandledException(e.getMessage());
        }
    }     

    /*
    * @Description - This method will return user id of user depending of profile name.
    * @Param String - Profile Name.
    * @return  - user id.
    */
    public static String getUserFromProfile(String profileName){
        String str = '';
        try{
            List<User> userList = [SELECT Id, Name, IsActive, ProfileId, Profile.Name FROM User WHERE 
                                  Profile.Name =: profileName ORDER BY LastModifiedDate DESC LIMIT 1];
            if(userList.size()>0){
                str = userList[0].Id;
            }                      

        } catch (Exception e) {
            System.debug('getUserFromProfile Exception is - '+ e.getMessage());
            System.debug('getUserFromProfile Exception at - '+ e.getLineNumber());
            //throw new AuraHandledException(e.getMessage());
        }
        return str;
    }

    /*
    * @Description - This method will return user id of user depending of name.
    * @Param String - Name.
    * @return  - user id.
    */
    public static String getUserByName(String name){
        String str = '';
        try{
            List<User> userList = [SELECT Id, Name, IsActive, ProfileId, Profile.Name FROM User WHERE 
                                  Name =: name ORDER BY LastModifiedDate DESC LIMIT 1];
            if(userList.size()>0){
                str = userList[0].Id;
            }                      

        } catch (Exception e) {
            System.debug('getUserByName Exception is - '+ e.getMessage());
            System.debug('getUserByName Exception at - '+ e.getLineNumber());
            //throw new AuraHandledException(e.getMessage());
        }
        return str;
    }

    /*
    * @Description - This method will check whether user is Key Account manager or not.
    * @Param String - User id.
    * @return  - True or false.
    */
    public static Boolean checkKeyAccountManager(String uId){
        Boolean flag = false;
        try{
            List<Key_Account_Manager__c> keyMngrList = [SELECT Id, Name, Active__c, Brazil_User__c, Key_Account__c, UniqueEmployee__c FROM 
                    Key_Account_Manager__c WHERE Brazil_User__c =: uId];
            if(keyMngrList.size()>0){
                flag = true;
            }        
        } catch (Exception e) {
            System.debug('checkKeyAccountManager Exception is - '+ e.getMessage());
            System.debug('checkKeyAccountManager Exception at - '+ e.getLineNumber());
            //throw new AuraHandledException(e.getMessage());
        }
        return flag;
    }

    public class SORParentWrapper{
        @AuraEnabled public String sorId;
        @AuraEnabled public String profileName;
        @AuraEnabled public Boolean isKeyAccountMngr;
        @AuraEnabled public String rsoRaisedBy;
        @AuraEnabled public Boolean isEdit;
        @AuraEnabled public Boolean isApproveReject;
        @AuraEnabled public Boolean isAttachment;
        @AuraEnabled public SOROrderDetailsChildController.OrderDetailsWrapper orderDetailsWrap;
        @AuraEnabled public SORTabSectionChildController.TabSectionWrapper tabSectionWrap;
        @AuraEnabled public List<SORProductDetailsChildController.ProductDetailsWrapper> productWrapList;
        @AuraEnabled public List<SORAttachmentChildController.AttachmentWrapper> attachmentWrapList;
        @AuraEnabled public Map<String,Decimal> invItemAggregateMap;

        public SORParentWrapper(){
            sorId = '';
            profileName = '';
            isKeyAccountMngr = false;
            rsoRaisedBy = '';
            isEdit = false;
            isApproveReject = false;
            orderDetailsWrap = new SOROrderDetailsChildController.OrderDetailsWrapper();
            tabSectionWrap = new SORTabSectionChildController.TabSectionWrapper();
            productWrapList = new List<SORProductDetailsChildController.ProductDetailsWrapper>();
            attachmentWrapList = new List<SORAttachmentChildController.AttachmentWrapper>();
            invItemAggregateMap = new Map<String,Decimal>();
            isAttachment = false;
        }
    }
}