/**************************************************************************************************
* Name               : grz_OverdueSummaryInternal.js                                              
* Description        : JS controller for grz_OverdueSummaryInternal component.                           
* Created Date       : 26/05/2022
* Created By         : Nikhil Verma (Grazitti)                                                   
**************************************************************************************************/                                         
import { LightningElement, wire, api,track} from 'lwc';
import LANG from "@salesforce/i18n/lang";
import modal from "@salesforce/resourceUrl/quickActionWidth";
import { loadStyle } from "lightning/platformResourceLoader";
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import labels from "@salesforce/label/c.Grz_OverdueSummaryTranslation"
import sapuserId from "@salesforce/label/c.Grz_SapUserId"
import getData from "@salesforce/apex/Grz_OverdueSummaryInternal.getData";
import getSalesArea from "@salesforce/apex/Grz_SapCommonIntegration.getSalesAreaValues"; // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
import getOverdueData from "@salesforce/apex/Grz_OverdueSummaryInternal.getOverdueData";
import dislike from '@salesforce/resourceUrl/dislike';
import like from '@salesforce/resourceUrl/like';
const SCROLL_TABLE_CLASS = "table-data-scroll";
const NO_SCROLL_TABLE_CLASS = "table-no-scroll";
export default class Grz_OverdueSummaryInternal extends LightningElement {
    @api recordId;
    @api dislike = dislike;
    @api like = like;
    @track labels;
    @track sapuserId = sapuserId;
    @track errorMessage;
    @track overdueData;
    @track account;
    @track overdueTableScroll;
    @track isLoading = true;
    @track noRecordError = false;    
    @track showDownloadOption = false;  
    @track notValidStartDate = false;
    @track notValidEndDate = false;  
    @track salesAreaOptions; salesArea; salesOrg; // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
    
    //Added for Poland User RITM0431761 GRZ(Nikhil Verma) 27-09-2022
    @track polandUser = false;   
    @track callSpanNoData = '8';   
    @track callSpanTotal = '4'; 

    @track language = LANG;
    @track totalOutstanding;
    @track pdfURL; xlsURL; pdfFileName; xlsFileName;
    @track startDate; endDate; currentFiscalYear; fiscalyearStartDate; fiscalyearEndDate;


    // Added for  RITM0435555 GRZ(Javed Ahmed) 5-10-2022

    @track DocDate = 'Asc'; 
    @track DocNo = 'Asc'; 
    @track AmtDoccur = 'Asc'; 
    @track DsctDays1 = 'Asc'; 
    @track DueDate = 'Desc'; 
    @track overDued = 'Asc'; 

    @track DocDateUpBool = false; 
    @track DocDateDownBool = false; 
    @track DocNoDownBool = false; 
    @track DocNoUpBool = false; 
    @track AmtDoccurUpBool = false; 
    @track AmtDoccurDownBool = false; 
    @track DsctDays1UpBool = false; 
    @track DsctDays1DownBool = false; 
    @track DueDateUpBool= false; 
    @track DueDateDownBool = false; 
    @track overDuedDownBool = false; 
    @track overDuedUpBool = false; 
     
    // ----------end  for  RITM0435555 GRZ(Javed Ahmed) 5-10-2022
      
    connectedCallback() {
        console.log('User Language ==> ',this.language);
        loadStyle(this, modal);
        this.labels = JSON.parse(labels);
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, "0");
        var mm = String(today.getMonth() + 1).padStart(2, "0"); //January is 0!
        var yyyy = today.getFullYear();
        this.endDate = yyyy + "-" + mm + "-" + dd;
        this.currentFiscalYear = today.getFullYear();
        this.fiscalyearStartDate = Number(this.currentFiscalYear) - 2 + "-01-01";
        this.fiscalyearEndDate = this.currentFiscalYear + "-12-31";
    }

    // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
    @wire(getSalesArea, {
        recordId: "$recordId"
    })
    getSalesArea(result) {
        this.isLoading = true;
        console.log('result ===> ',result);
        if(result.data){
            let saArr = [];
            for (let i = 0; i < result.data.length; i++) {
                const option = {
                    label: String(result.data[i].SalesOrg__r.Name),
                    value: String(result.data[i].Company_Code__c) + '-' + String(result.data[i].Sales_Org_Code__c)
                };
                saArr = [...saArr, option];
            }
            console.log('saArr==>',saArr);
            this.salesAreaOptions = saArr;
            if(this.salesAreaOptions.length != 0){
                this.salesArea = this.salesAreaOptions[0].value;
            }
            this.isLoading = false;
        }else if(result.error){
            this.errorMessage = JSON.stringify(result.error);
            this.isLoading = false;
        }
    }

    handleSalesAreaOption(event){
        this.salesArea = event.detail.value;
    }
    // End for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->

    @wire(getData, {
        recordId: "$recordId"
    })
    getData(result) {
        this.isLoading = true;
        console.log('result ===> ',result);
        if(result.data){
            if (result.data.success) {
                this.account = result.data.data;
            }else{
                var errMsg = result.data.message;
                if(errMsg == 'Required_Data_Missing'){
                    this.errorMessage = this.labels.dataMissingErr;
                }else if(errMsg == 'no_access'){
                    this.errorMessage = this.labels.noAccess;
                }else if(errMsg == 'wrong_acc'){
                    this.errorMessage = this.labels.wrongAcc;
                }else{
                    this.errorMessage = errMsg;
                }
            }
            this.isLoading = false;
        }else if(result.error){
            this.errorMessage = result.error;
            this.isLoading = false;
            console.log('error ===> ',JSON.stringify(result.error));
        }
    }

    startDateChange(event) {
        this.startDate = event.target.value;
        if (this.startDate < this.fiscalyearStartDate || this.startDate > this.fiscalyearEndDate) {
          this.notValidStartDate = true;
        } else {
          this.notValidStartDate = false;
        }
    }

    endDateChange(event) {
        this.endDate = event.target.value;
        if (this.endDate < this.fiscalyearStartDate || this.endDate > this.fiscalyearEndDate) {
            this.notValidEndDate = true;
        } else {
            this.notValidEndDate = false;
        }
    }

    getOverdueData(){
        this.errorMessage = undefined;
        this.noRecordError = false;
        this.showDownloadOption = false;
        this.overdueData = undefined;
        if (this.startDate != null && this.endDate != null) {
            var start = new Date(this.startDate.slice(0, 10));
            var end = new Date(this.endDate);
            var today = new Date();
            if (start > today || end > today) {
                this.tostMsg(this.labels.greaterDateErr,"error");
            } else if (start > end) {
                this.tostMsg(this.labels.greaterDate,"error");
            } else if (this.notValidStartDate || this.notValidEndDate) {
                this.tostMsg(this.labels.notValidDate, "error");
            } else {
                this.getFinalData();
            }
        }else if((this.startDate == null || this.startDate == undefined) && this.endDate != null){
            this.getFinalData();
        }else {
            this.tostMsg(this.labels.emptyDate, "error");
        }
    }

    getFinalData(){
        // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
        let cmpCode;
        let salesOrg;
        if(this.salesArea){
            cmpCode = this.salesArea.split("-")[0];
            salesOrg = this.salesArea.split("-")[1];
            console.log('==> ',salesOrg +' ==> ', cmpCode);
        }else{
            cmpCode = this.account[0].Company_Code__c;
            salesOrg = this.account[0].Sales_Org_Code__c;
            console.log('==> ',salesOrg +' ==> ', cmpCode);
        }
        // End for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
        this.isLoading = true;
        getOverdueData({ 
            customerNumber: this.account[0].SAP_Customer_Code__c,
            sapUserId:      this.sapuserId,
            companyCode:    cmpCode, // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
            startDate:      this.startDate,
            endDate:        this.endDate,
            salesOrgCode:   salesOrg // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
        })
            .then(result => {  
                console.log( ' overdue => result => ',result );
                if(result.success){

                    //Added for Poland User RITM0431761 GRZ(Nikhil Verma) 27-09-2022
                    if(this.account[0].Sales_Org_Code__c == '2941'){
                        this.polandUser = true;
                        this.callSpanNoData = '9';
                        this.callSpanTotal = '5';
                    }

                    this.overdueData = result.lineitems;
                    this.sortDueDate();
                    this.totalOutstanding = result.totalOutstanding;
                    this.pdfFileName = this.account[0].SAP_Customer_Code__c + '-' + this.labels.overdueSummary + '.pdf';
                    this.xlsFileName = this.account[0].SAP_Customer_Code__c + '-' + this.labels.overdueSummary + '.xls';
                    
                    if (this.overdueData.length > 12) {
                        this.overdueTableScroll = SCROLL_TABLE_CLASS;
                    } else {
                        this.overdueTableScroll = NO_SCROLL_TABLE_CLASS;
                    }
                    if (this.overdueData.length == 0) {
                        this.noRecordError = true;
                        this.showDownloadOption = false;
                    } else {
                        this.noRecordError = false;
                        this.showDownloadOption = true;
                    }
                    this.generatedDocumentURL();
                }else{
                    if(result.message == 'Error_In_SAP'){
                        this.errorMessage = this.labels.errorInSap;
                    }else if(result.message == 'no_data'){
                        this.errorMessage = this.labels.noData;
                    }else{
                        this.errorMessage = result.message;
                    }
                }
                this.isLoading = false;
            })
            .catch(error => {
                this.isLoading = false;
                this.errorMessage = error;
                console.log( 'overdue => error =>'+JSON.stringify(error) );
            });
    }

    handleCancel() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    tostMsg(msg, type) {
        const event = new ShowToastEvent({
            title: msg,
            variant: type,
        });
        this.dispatchEvent(event);
    }

    generatedDocumentURL(){
        // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
        let cmpCode;
        let salesOrg;
        if(this.salesArea){
            cmpCode = this.salesArea.split("-")[0];
            salesOrg = this.salesArea.split("-")[1];
            console.log('==> ',salesOrg +' ==> ', cmpCode);
        }else{
            cmpCode = this.account[0].Company_Code__c;
            salesOrg = this.account[0].Sales_Org_Code__c;
            console.log('==> ',salesOrg +' ==> ', cmpCode);
        }
        // End for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
        this.pdfURL = "/apex/Grz_OverdueSummaryInternalPDF?customerNumber=" +
                        this.account[0].SAP_Customer_Code__c +
                        "&sapUserId=" +
                        this.sapuserId +
                        "&companyCode=" +
                        cmpCode + // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
                        "&cstName=" +
                        this.account[0].Name +
                        "&startDate=" +
                        this.startDate +
                        "&endDate=" +
                        this.endDate +
                        "&salesOrgCode=" +
                        salesOrg + // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
                        "&fileName=" +
                        this.pdfFileName;

        this.xlsURL = "/apex/Grz_OverdueSummaryInternalXLS?customerNumber=" +
                        this.account[0].SAP_Customer_Code__c +
                        "&sapUserId=" +
                        this.sapuserId +
                        "&companyCode=" +
                        cmpCode + // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
                        "&cstName=" +
                        this.account[0].Name +
                        "&startDate=" +
                        this.startDate +
                        "&endDate=" +
                        this.endDate +
                        "&salesOrgCode=" +
                        salesOrg + // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
                        "&fileName=" +
                        this.xlsFileName;
    }

    pdfDownloadClick() {
        window.open(this.pdfURL, '_blank');
    }
    xlsDownloadClick() {
        window.open(this.xlsURL, '_blank');
    }

  //  start Added for  RITM0435555 GRZ(Javed Ahmed) 5-10-2022

    sortDocDate(){
        if(this.DocDate == 'Asc'){
            this.DocDate = 'Desc';
            this.DocDateDownBool=true;
            this.DocDateUpBool=false;
            this.AmtDoccurDownBool=false;
            this.AmtDoccurUpBool=false;
            this.DsctDays1DownBool=false;
            this.DsctDays1UpBool=false;
            this.DueDateDownBool=false;
            this.DueDateUpBool=false;
            this.overDuedDownBool=false;
            this.overDuedUpBool=false;
            this.DocNoDownBool=false;
            this.DocNoUpBool=false;
        }else{
            this.DocDate = 'Asc';
            this.DocDateUpBool=true;
            this.DocDateDownBool=false;
            this.AmtDoccurDownBool=false;
            this.AmtDoccurUpBool=false;
            this.DsctDays1DownBool=false;
            this.DsctDays1UpBool=false;
            this.DueDateDownBool=false;
            this.DueDateUpBool=false;
            this.overDuedDownBool=false;
            this.overDuedUpBool=false;
            this.DocNoDownBool=false;
            this.DocNoUpBool=false;
        }
        this.overdueData.sort(this.dynamicsort('DocDate',this.DocDate));
    }
    sortDocNumber(){
        if(this.DocNo == 'Asc'){
            this.DocNo = 'Desc';
            this.DocNoDownBool=true;
            this.DocNoUpBool=false;
            this.DocDateUpBool=false;
            this.DocDateDownBool=false;
            this.AmtDoccurDownBool=false;
            this.AmtDoccurUpBool=false;
            this.DsctDays1DownBool=false;
            this.DsctDays1UpBool=false;
            this.DueDateDownBool=false;
            this.DueDateUpBool=false;
            this.overDuedDownBool=false;
            this.overDuedUpBool=false;
        }else{
            this.DocNo = 'Asc';
            this.DocNoUpBool=true;
            this.DocNoDownBool=false;
            this.DocDateUpBool=false;
            this.DocDateDownBool=false;
            this.AmtDoccurDownBool=false;
            this.AmtDoccurUpBool=false;
            this.DsctDays1DownBool=false;
            this.DsctDays1UpBool=false;
            this.DueDateDownBool=false;
            this.DueDateUpBool=false;
            this.overDuedDownBool=false;
            this.overDuedUpBool=false;
        }
        this.overdueData.sort(this.dynamicsort('DocNo',this.DocNo));
    }
    sortAmount(){   
        if(this.AmtDoccur == 'Asc'){
            this.AmtDoccur = 'Desc';
            this.AmtDoccurDownBool=true;
            this.AmtDoccurUpBool=false;
            this.DocNoUpBool=false;
            this.DocNoDownBool=false;
            this.DocDateUpBool=false;
            this.DocDateDownBool=false;
            this.DsctDays1DownBool=false;
            this.DsctDays1UpBool=false;
            this.overDuedDownBool=false;
            this.overDuedUpBool=false;
            this.DocNoDownBool=false;
            this.DocNoUpBool=false;
        }else{
            this.AmtDoccur = 'Asc';
            this.AmtDoccurUpBool=true;
            this.AmtDoccurDownBool=false;
            this.DocNoUpBool=false;
            this.DocNoDownBool=false;
            this.DocDateUpBool=false;
            this.DocDateDownBool=false;
            this.DsctDays1DownBool=false;
            this.DsctDays1UpBool=false;
            this.overDuedDownBool=false;
            this.overDuedUpBool=false;
            this.DocNoDownBool=false;
            this.DocNoUpBool=false;
        }
        this.overdueData.sort(this.dynamicsortAmmount('AmtDoccur',this.AmtDoccur));
    }
    sortPaymentTerm(){
        if(this.DsctDays1 == 'Asc'){
            this.DsctDays1 = 'Desc';
            this.DsctDays1DownBool=true;
            this.DsctDays1UpBool=false;
            this.AmtDoccurUpBool=false;
            this.AmtDoccurDownBool=false;
            this.DocNoUpBool=false;
            this.DocNoDownBool=false;
            this.DocDateUpBool=false;
            this.DocDateDownBool=false;
            this.overDuedDownBool=false;
            this.overDuedUpBool=false;
            this.DueDateDownBool=false;
            this.DueDateUpBool=false;
        }else{
            this.DsctDays1 = 'Asc';
            this.DsctDays1UpBool=true;
            this.DsctDays1DownBool=false;
            this.AmtDoccurUpBool=false;
            this.AmtDoccurDownBool=false;
            this.DocNoUpBool=false;
            this.DocNoDownBool=false;
            this.DocDateUpBool=false;
            this.DocDateDownBool=false;
            this.overDuedDownBool=false;
            this.overDuedUpBool=false;
            this.DueDateDownBool=false;
            this.DueDateUpBool=false;
        }
        this.overdueData.sort(this.dynamicsort('DsctDays1',this.DsctDays1));
    }
    sortDueDate(){
        if(this.DueDate == 'Asc'){
            this.DueDate = 'Desc';
            this.DueDateDownBool=true;
            this.DueDateUpBool=false;
            this.DsctDays1UpBool=false;
            this.DsctDays1DownBool=false;
            this.AmtDoccurUpBool=false;
            this.AmtDoccurDownBool=false;
            this.DocNoUpBool=false;
            this.DocNoDownBool=false;
            this.DocDateUpBool=false;
            this.DocDateDownBool=false;
            this.overDuedDownBool=false;
            this.overDuedUpBool=false;
        }else{
            this.DueDate = 'Asc';
            this.DueDateUpBool=true;
            this.DueDateDownBool=false;
            this.DsctDays1UpBool=false;
            this.DsctDays1DownBool=false;
            this.AmtDoccurUpBool=false;
            this.AmtDoccurDownBool=false;
            this.DocNoUpBool=false;
            this.DocNoDownBool=false;
            this.DocDateUpBool=false;
            this.DocDateDownBool=false;
            this.overDuedDownBool=false;
            this.overDuedUpBool=false;
        }
        this.overdueData.sort(this.dynamicsort('DueDate',this.DueDate));
    }
    sortOverdue(){
        if(this.overDued == 'Asc'){
            this.overDued = 'Desc';
            this.overDuedDownBool=true;
            this.overDuedUpBool=false;
            this.DueDateUpBool=false;
            this.DueDateDownBool=false;
            this.DsctDays1UpBool=false;
            this.DsctDays1DownBool=false;
            this.AmtDoccurUpBool=false;
            this.AmtDoccurDownBool=false;
            this.DocNoUpBool=false;
            this.DocNoDownBool=false;
            this.DocDateUpBool=false;
            this.DocDateDownBool=false;
            
        }else{
            this.overDued = 'Asc';
            this.overDuedUpBool=true;
            this.overDuedDownBool=false;
            this.DsctDays1UpBool=false;
            this.DsctDays1DownBool=false;
            this.AmtDoccurUpBool=false;
            this.AmtDoccurDownBool=false;
            this.DocNoUpBool=false;
            this.DocNoDownBool=false;
            this.DocDateUpBool=false;
            this.DocDateDownBool=false;
            this.DueDateUpBool=false;
            this.DueDateDownBool=false;
        }
        this.overdueData.sort(this.dynamicsort('overDued',this.overDued));
    }
    dynamicsort(property,order) {
        var sort_order = 1;
        if(order === "Desc"){
            sort_order = -1;
        }
        return function (a, b){
            if(a[property] < b[property]){
                return -1 * sort_order;
            }else if(a[property] > b[property]){
                return 1 * sort_order;
            }else{
                return 0 * sort_order;
            }
        }
    }
    dynamicsortAmmount(property,order) {
        var sort_order = 1;
        if(order === "Desc"){
            sort_order = -1;
        }
        return function (a, b){
            var one = parseFloat(a[property]);
            var two = parseFloat(b[property]);
            if(one < two){
                return -1 * sort_order;
            }else if(one > two){
                return 1 * sort_order;
            }else{
                return 0 * sort_order;
            }
        }
    }
    //------ end  Added for  RITM0435555 GRZ(Javed Ahmed) 5-10-2022

}