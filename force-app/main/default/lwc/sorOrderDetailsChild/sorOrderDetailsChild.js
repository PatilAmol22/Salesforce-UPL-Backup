import { api, LightningElement, track, wire } from 'lwc';
import getSubReturnTypes from '@salesforce/apex/SOROrderDetailsChildController.getSubReturnTypes';
import getRebateRegionDistrict from '@salesforce/apex/SOROrderDetailsChildController.getRebateRegionDistrict';
import uId from '@salesforce/user/Id';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi'; 
import RSO_OBJECT from '@salesforce/schema/Return_Sales_Order__c';
	
import SOR_Return_Policy from '@salesforce/resourceUrl/SOR_Return_Policy';
 
import REFUSAL_FIELD from '@salesforce/schema/Return_Sales_Order__c.Refusal__c';
import REINVOICING_FIELD from '@salesforce/schema/Return_Sales_Order__c.Reinvoicing__c';
import RETURNTYPE_FIELD from '@salesforce/schema/Return_Sales_Order__c.Return_Type__c';
import STATUS_FIELD from '@salesforce/schema/Return_Sales_Order__c.Order_Status__c';
import SUBSTATUS_FIELD from '@salesforce/schema/Return_Sales_Order__c.Sub_Status__c';

import PleaseWait from '@salesforce/label/c.Please_wait';
import ErrorT from '@salesforce/label/c.Error';
import Success from '@salesforce/label/c.Success';
import Warning from '@salesforce/label/c.Warning';
import Return_Order_Number from '@salesforce/label/c.Return_Order_Number'; 
import Download_Return_Policy from '@salesforce/label/c.Download_Return_Policy';
import Return_Policy from '@salesforce/label/c.Return_Policy';
import Customer_Name from '@salesforce/label/c.Customer_Name';
import Search_Account from '@salesforce/label/c.Search_Account';
import RebateContract from '@salesforce/label/c.RebateContract';
import Open_Rebate_Contract from '@salesforce/label/c.Open_Rebate_Contract';
import Region from '@salesforce/label/c.Region';
import District from '@salesforce/label/c.District';
import Requestor_s_Name from '@salesforce/label/c.Requestor_s_Name';
import Creation_Date from '@salesforce/label/c.Creation_Date';
import Sales_Order_Number from '@salesforce/label/c.Sales_Order_Number';
import Status from '@salesforce/label/c.Status';
import Sub_Status from '@salesforce/label/c.Sub_Status';
import Return_Type from '@salesforce/label/c.Return_Type';
import Return_Sub_Type from '@salesforce/label/c.Return_Sub_Type';
import Sub_Type from '@salesforce/label/c.Sub_Type';
import Refusal from '@salesforce/label/c.Refusal';
import Reinvoicing from '@salesforce/label/c.Reinvoicing';
import Date_of_Incident from '@salesforce/label/c.Date_of_Incident';
import Logistics_Operator from '@salesforce/label/c.Logistics_Operator';
import Search_User from '@salesforce/label/c.Search_User';
import Credit_Analyst from '@salesforce/label/c.Credit_Analyst';
import FailToCreateRecord from '@salesforce/label/c.Failed_To_Create_Record';
import NoRecordsFound from '@salesforce/label/c.No_Records_Found';
import SearchAccount from '@salesforce/label/c.Search_Account';
import SalesPerson from '@salesforce/label/c.Brazil_Sales_Person';
import SalesDistrictManager from '@salesforce/label/c.Brazil_Sales_District_Manager';
import LogisticsManager from '@salesforce/label/c.Brazil_Logistics_Manager';
import CustomerService from '@salesforce/label/c.Brazil_Customer_Service_User';
import BrazilAdmin from '@salesforce/label/c.Brazil_System_Administrator';
import Return_Details from '@salesforce/label/c.Return_Details';

export default class SorOrderDetailsChild extends LightningElement {
    @api getValueFromParent = {};
    @track refusalOptions = [];
    @track reinvoicingOptions = [];
    @track returnTypeOptions = [];
    @track returnSubTypeOptions = [];
    @track statusOptions = [];
    @track subStatusOptions = [];
    @track policyURL = SOR_Return_Policy;
    @track userId = uId;
    @track orderDetails={};
    @track accountName = '';
    @track accDisable = false;
    @track isCredit = false;
    @track creditAnalystName = '';
    @track rebetContName = '';
    @track rebateURL = '';
    @track isAdmin = false;
    @track isLogistic = false;
    @track isDisable = true;
    @track accRequired = false;
    @track accountList = {};
    @track regionName = '';
    @track disrictName = '';
    @track analystfilter = ' Profile_Name__c = \'Brazil Credit Team\' ORDER BY Full_Name__c ASC';
    @track objectName = 'Customer_and_Region_Mapping__c';
    //@track fieldNames = 'CustomerCode__c, BillingCity__c, Customer_Region__c, Customer_Name__c, CustomerName_Formula_Field__c ';
    @track fieldNames = 'CustomerCode__c,BillingCity__c,Customer_Region__c,Customer_CNPJ_CPF__c,Region_Name__c,CustomerRegionCode__c'; //Updated for RITM0574771  GRZ(Dheeraj Sharma) 21-06-2023 
    @track serarchField = 'CustomerName_Formula_Field__c';  // default....
    //@track filter = 'RecordType.Name=\'Distributor\' AND Sales_Org__r.Sales_Org_Code__c = \'5191\' AND Territory_Distributor__r.TerritoryManager__c = \''+this.userId+'\' ORDER BY Name ASC ';
    @track filter = 'Customer_Name__r.RecordType.Name=\'Distributor\' AND Active__c = true AND Account_Active__c = true ORDER BY CustomerName_Formula_Field__c ASC ';
    @track isSO = false;
    @track isCustomerService = false;
    
    label = {
        PleaseWait,
        ErrorT,
        Success,
        Warning,
        FailToCreateRecord,
        NoRecordsFound,
        SearchAccount,
        SalesPerson,
        SalesDistrictManager,
        LogisticsManager,
        CustomerService,
        BrazilAdmin,
        Return_Order_Number,
        Download_Return_Policy,
        Return_Policy,
        Customer_Name,
        Search_Account,
        RebateContract,
        Open_Rebate_Contract,
        Region,
        District,
        Requestor_s_Name,
        Creation_Date,
        Sales_Order_Number,
        Status,
        Sub_Status,
        Return_Type,
        Return_Sub_Type,
        Sub_Type,
        Refusal,
        Reinvoicing,
        Date_of_Incident,
        Logistics_Operator,
        Search_User,
        Credit_Analyst,
        Return_Details
    };
    
    
    // getting the default record type id, if you dont' then it will get master
    @wire(getObjectInfo, { objectApiName: RSO_OBJECT })
    rsoMetadata;
 
    // now retriving the field picklist values of object
 
    @wire(getPicklistValues,
        {
            recordTypeId: '012000000000000AAA',// hardcoded value for null recordTypeid...//'$rsoMetadata.data.defaultRecordTypeId', 
            fieldApiName: REFUSAL_FIELD
        }
    )
    wiredRefusal({error, data}){
        if(data){
            this.refusalOptions = data.values;
            //console.log('RefusalPicklist data- ', data.values);
        }
        else if(error){
            console.log('RefusalPicklist error- ', error);
        }
    }

    @wire(getPicklistValues,
        {
            recordTypeId: '012000000000000AAA',// hardcoded value for null recordTypeid...//'$rsoMetadata.data.defaultRecordTypeId', 
            fieldApiName: REINVOICING_FIELD
        }
    )
    wiredReinvoicing({error, data}){
        if(data){
            this.reinvoicingOptions = data.values;
            //console.log('ReinvoicingPicklist data- ', data.values);
        }
        else if(error){
            console.log('ReinvoicingPicklist error- ', error);
        }
    }

    @wire(getPicklistValues,
        {
            recordTypeId: '012000000000000AAA',// hardcoded value for null recordTypeid...//'$rsoMetadata.data.defaultRecordTypeId', 
            fieldApiName: RETURNTYPE_FIELD
        }
    )
    wiredReturnType({error, data}){
        if(data){
            this.returnTypeOptions = data.values;
            //console.log('returnTypeOptions data- ', data.values);
        }
        else if(error){
            console.log('returnTypeOptions error- ', error);
        }
    }

    @wire(getPicklistValues,
        {
            recordTypeId: '012000000000000AAA',// hardcoded value for null recordTypeid...//'$rsoMetadata.data.defaultRecordTypeId', 
            fieldApiName: STATUS_FIELD
        }
    )
    wiredStatus({error, data}){
        if(data){
            this.statusOptions = data.values;
            //console.log('statusOptions data- ', data.values);
        }
        else if(error){
            console.log('statusOptions error- ', error);
        }
    }

    @wire(getPicklistValues,
        {
            recordTypeId: '012000000000000AAA',// hardcoded value for null recordTypeid...//'$rsoMetadata.data.defaultRecordTypeId', 
            fieldApiName: SUBSTATUS_FIELD
        }
    )
    wiredSubStatus({error, data}){
        if(data){
            this.subStatusOptions = data.values;
            //console.log('subStatusOptions data- ', data.values);
        }
        else if(error){
            console.log('subStatusOptions error- ', error);
        }
    }

    /* @wire(getOrderDetails)
    wiredSORDetails({ error, data }) {
        if (data) {
            this.orderDetails = data;
            //this.valueForOrderDetailsChild = data.orderDetailsWrap;
        } else if (error) {
            console.log(error);
            this.error = error;
        }
    } */
 
    /* renderedCallback(){
        
    }  */

    connectedCallback(){
        //console.log('value from parent in Order Details Child - ', this.getValueFromParent);
        this.orderDetails = this.getValueFromParent;
        //console.log('this.orderDetails in Order Details Child - ', this.orderDetails);
    } 

    @api
    disableAccount(strString) {
        this.accDisable = strString;        
    }

    @api
    getRecordDetailsFromParent(obj,flag,isKeyAccountMngr) {     // Updated  for INC0479929 GRZ(Dheeraj Sharma) 01-06-2023
        
        if(flag == true){
            this.isDisable = false;
        }
        this.orderDetails = obj; 
        let objOD = JSON.parse(JSON.stringify(this.orderDetails));  
              
        this.accountName = objOD.accountName; 
        this.rebetContName = objOD.rebContractName;  
        this.regionName = objOD.region;
        this.disrictName = objOD.district;
        
        if(objOD.profileName == SalesPerson || objOD.profileName == SalesDistrictManager){
            this.returnTypeOptions = this.returnTypeOptions.filter(option => option.value != 'Logistics');
        }
       
        this.loadReturnSubTypes(objOD.returnType);
        
        if(objOD.returnType == 'Credit' || objOD.returnType == 'Crédito'){
            this.isCredit = true;
            this.creditAnalystName = objOD.creditAnalystName;
        }

        if(objOD.profileName == 'Brazil Logistics'|| objOD.profileName == CustomerService){
            this.isCustomerService = true;
        }

        if(objOD.profileName == 'Brazil Logistics'){ //  || objOD.profileName == CustomerService
            this.isLogistic = true;
        }

        if(objOD.profileName == BrazilAdmin || objOD.profileName == CustomerService || objOD.profileName == 'Brazil Logistics'){
            this.filter = 'Customer_Name__r.RecordType.Name=\'Distributor\' AND Active__c = true AND Account_Active__c = true ORDER BY CustomerName_Formula_Field__c ASC ';
        } 
        /* else if(objOD.profileName == 'Brazil Logistics'){
            this.filter = 'Customer_Name__r.RecordType.Name=\'Distributor\' AND Active__c = true AND Account_Active__c = true ORDER BY CustomerName_Formula_Field__c ASC ';
        } */
        else if(objOD.profileName == SalesDistrictManager){
            this.filter = 'CustomerRegion__r.Region__c = \''+objOD.regnId+'\' AND Customer_Name__r.RecordType.Name=\'Distributor\' AND Active__c = true AND Account_Active__c = true ORDER BY CustomerName_Formula_Field__c ASC ';
        }
        else if(objOD.profileName == SalesPerson){
           
            if(isKeyAccountMngr == true){
                this.filter = '(CustomerRegion__c = \''+objOD.terId+'\' OR Customer_Name__r.Key_Account_Manager__c = \''+objOD.requesterId+'\') AND Customer_Name__r.RecordType.Name=\'Distributor\' AND Active__c = true AND Account_Active__c = true ORDER BY CustomerName_Formula_Field__c ASC ';
            }
            else{
                this.filter = 'CustomerRegion__c = \''+objOD.terId+'\' AND Customer_Name__r.RecordType.Name=\'Distributor\' AND Active__c = true AND Account_Active__c = true ORDER BY CustomerName_Formula_Field__c ASC ';
            }
        }

        if(objOD.reInvoicing == 'Yes' || objOD.reInvoicing == 'Sim'){
            this.isSO = true;
        }

        if(this.accountName.length > 0){
            this.accDisable = true; 
            if(objOD.rebContractId.length >= 15){
                this.rebateURL = window.location.origin+'/lightning/r/Rebate_Contract__c/'+objOD.rebContractId+'/view';
            }
        }
        else{
            this.rebateURL = '';
        }
    }

    triggerEvent(events){
        //create event
        const custEvent = new CustomEvent("getorderdetails",{
            detail: this.orderDetails
        });

        // dispatch event
        this.dispatchEvent(custEvent);
    }

    triggerAccountEvent(){
        //create event
        const custEvent = new CustomEvent("getaccountdetails",{
            detail: this.orderDetails
        });

        // dispatch event
        this.dispatchEvent(custEvent);
    }

    handleChange(event){
        let obj = JSON.parse(JSON.stringify(this.orderDetails));
        //console.log('value in Order Details Child - ', obj);
        if(event.target.name == 'soNumber'){
            obj.soNumber = event.target.value;
        }
        else if(event.target.name == 'refusal'){
            obj.refusal = event.target.value;
        }
        else if(event.target.name == 'reinvoicing'){
            obj.reInvoicing = event.target.value;
            this.handleReinvoicing(event);
        }
        else if(event.target.name == 'date_of_incident'){
            obj.dateOfIncident = event.target.value;
        }
        else if(event.target.name == 'return_type'){
            obj.returnType = event.target.value;
            obj.returnSubType = '';

            if(obj.returnType == '' || obj.returnType == null){
                this.returnSubTypeOptions = [];
            }
            else{
                this.loadReturnSubTypes(obj.returnType);
                if(obj.returnType == 'Credit' || obj.returnType == 'Credito'){
                    this.isCredit = true;
                }
                else{
                    this.isCredit = false;
                    this.handleRemoveAnalyst(event);
                }
            }
        }
        else if(event.target.name == 'return_sub_type'){
            obj.returnSubType = event.target.value;
            //console.log('ReturnSubType - ', event.target.value);
        }
        else if(event.target.name == 'sub_type'){
            obj.subType = event.target.value;
        }
        else if(event.target.name == 'status'){
            obj.status = event.target.value;
        }
        else if(event.target.name == 'sub_status'){
            obj.subStatus = event.target.value;
        }
        else if(event.target.name == 'logistics_operator'){
            obj.logisticsOperator = event.target.value;
        }
        else if(event.target.name == 'returnDetails'){
            obj.returnDetails = event.target.value;
        }
        /* else if(event.target.name == 'contact'){
            obj.contact = event.target.value;
        } */
        
        this.orderDetails = obj;

        this.triggerEvent(event);
        //create event
        /* const custEvent = new CustomEvent("getorderdetails",{
            detail: this.orderDetails
        });

        // dispatch event
        this.dispatchEvent(custEvent); */
    }

    handleAccountSelected(event){
    
        let obj = JSON.parse(JSON.stringify(this.orderDetails));
        //obj.accountId = event.detail.recId;
        obj.accountName = event.detail.recName;
        this.orderDetails = obj;
        this.accountName = event.detail.recName;
        this.fetchRebateRegionDistrict(event.detail.recId);
        /* //create event
        const custEvent = new CustomEvent("getaccountdetails",{
            detail: this.orderDetails
        });

        // dispatch event
        this.dispatchEvent(custEvent); */

        //this.triggerAccountEvent();
    }

    handleRemoveAccount(event){
        let obj = JSON.parse(JSON.stringify(this.orderDetails));
        obj.accountId = '';
        obj.accountName = '';
        obj.distTerId = '';
        this.orderDetails = obj;
        this.accountName = '';
        this.rebetContName = '';
        this.rebateURL = '';
        this.regionName = '';
        this.disrictName = '';
        /* //create event
        const custEvent = new CustomEvent("getaccountdetails",{
            detail: this.orderDetails
        });

        // dispatch event
        this.dispatchEvent(custEvent); */
        this.triggerAccountEvent();
    }

    handleReinvoicing(event){
        if(event.target.value == 'Yes' || event.target.value == 'Sim'){
            this.isSO = true;
        }
        else{
            this.isSO = false;
        }
    }

    handleAnalystSelected(event){
        let obj = JSON.parse(JSON.stringify(this.orderDetails));
        obj.creditAnalyst = event.detail.recId;
        obj.creditAnalystName = event.detail.recName;
        this.creditAnalystName = event.detail.recName;
        this.orderDetails = obj;
        this.triggerEvent(event);
    }

    handleRemoveAnalyst(event){
        let obj = JSON.parse(JSON.stringify(this.orderDetails));
        obj.creditAnalyst = '';
        obj.creditAnalystName = '';
        this.creditAnalystName = '';
        this.orderDetails = obj;
        this.triggerEvent(event);
    }

    loadReturnSubTypes(rtrnTp){
        if(rtrnTp.length>0){
            this.showSpinner = true;
            getSubReturnTypes({rtrnType : rtrnTp})
            .then(result => {
                //console.log('loadReturnSubTypes - ', JSON.stringify(result));
                this.returnSubTypeOptions = [];
                let optn =[];
                result.forEach(r => {
                    optn.push({
                      label: r.subReturnType,
                      value: r.id,
                    });
                });
                this.returnSubTypeOptions = optn;
                this.showSpinner = false;
            })
            .catch(error => {
                this.showSpinner = false;
                console.log('loadReturnSubTypes js method catch');
            })
        }
    }

    fetchRebateRegionDistrict(recId){
        getRebateRegionDistrict({custRegnId : recId})
            .then(result => {
                //console.log('fetchRebateRegionDistrict - ', JSON.stringify(result));
                let obj = JSON.parse(JSON.stringify(this.orderDetails));
                obj.accountId = result.accountId;
                obj.distTerId = result.distTerId;
                this.orderDetails = obj;

                this.rebetContName = result.rebContractName;
                if(result.rebContractId.length >= 15){
                    this.rebateURL = window.location.origin+'/lightning/r/Rebate_Contract__c/'+result.rebContractId+'/view';
                }
                this.regionName = result.region;
                this.disrictName = result.district;

                this.triggerAccountEvent();
                this.showSpinner = false;
            })
            .catch(error => {
                this.showSpinner = false;
                console.log('fetchCustomerDetails js method catch');
                
            })
    }

}