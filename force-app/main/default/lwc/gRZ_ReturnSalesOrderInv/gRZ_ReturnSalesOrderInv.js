import { LightningElement,api,wire,track } from 'lwc';
import getAllData from "@salesforce/apex/grz_ReturnSalesOrderController.getAllData";
import modal from "@salesforce/resourceUrl/Grz_ModalWidth";
//import modal from "@salesforce/resourceUrl/ModalCssUk";
import { loadStyle } from "lightning/platformResourceLoader";
import { CloseActionScreenEvent } from "lightning/actions";

export default class GRZ_ReturnSalesOrderInv extends LightningElement {
@api recordId;
showInvError=true;
@api invId;
invData1=[];
ytdAmt;
@track detailsData;
@track dataInv;
@track sortBy;
@track sortDirection;
showBackBttn=false;
columnsInv = [
    {
        type:"button",
        initialWidth: 134,
        label: 'Invoice No.',
        typeAttributes: {
            label: {fieldName: 'Name'},
            name: 'edit',
            
        }}            ,{ label: 'Billing Date', fieldName: 'Billing_Date__c',  sortable: "true" }    
    ,{ label: 'Billing Doc No.', fieldName: 'Billing_Doc_Number__c' }    
    ,{ label: 'Billing Status', fieldName: 'Billing_Status__c' }    
    ,{ label: 'Sold To', fieldName: 'SoldTo' }    
    ,{ label: 'Bill To', fieldName: 'BillTo' }    
    ,{ label: 'Nota Fiscal', fieldName: 'Nota_Fiscal__c' },
    
];



connectedCallback() {
    Promise.all([loadStyle(this, modal)]);
    
    //if(this.recordId)this.getInvData(this.recordId);
}
backAction(){
    this.detailsData.InvDetails=null;
    this.detailsData.isInvWindow=false;
    this.showInvError=false;
    this.detailsData.Invoices=this.invData1;
}
getInvData(recId){
    getAllData({
        'parameterId' : recId
    }).then((result) => {
                if(result){
        
                    this.showInvError=true; 
        this.detailsData =JSON.parse(JSON.stringify(result)) ;
        console.log('=======normal=====',result);
        this.ytdAmt=result.ytdAmt;
        var dataInvoices=this.detailsData.Invoices;
        if(this.detailsData.InvDetails)this.invId=this.detailsData.InvDetails.Id;
        if(dataInvoices){
            dataInvoices.forEach(function (element) {
                if(element.Sold_To_Party__c) element.SoldTo = element.Sold_To_Party__r.Name;
                if(element.Bill_To_Party__c) element.BillTo = element.Bill_To_Party__r.Name;
                });
                this.dataInv=dataInvoices;
            }
            if(dataInvoices && dataInvoices.length>0){
                this.invData1=dataInvoices;
                this.showInvError=false;
            }
        
    }else{
        console.log(JSON.stringify(result.error));
    }
    if(result.data==undefined){
        this.isSpinner = false;
    }
    });
    }

handleRowAction(event) {
    this.showBackBttn=true;
    const actionName = event.detail.action.name;
    const row = event.detail.row;
    //edit=== alert(actionName);
    this.invId=row.Id;
    this.getInvData(row.Id);
    
}
onChangeSearch(evt){
    var searchKey = evt.target.value;
    var dataInvoices=this.detailsData.Invoices;
    if(searchKey){
    var searchedInvoices=[];
    dataInvoices.forEach(function (element) {
        if(element.Name.toLowerCase().includes(searchKey.toLowerCase()) || element.Billing_Doc_Number__c.toLowerCase().includes(searchKey.toLowerCase())) searchedInvoices.push(element);
        });
        this.dataInv=searchedInvoices;
    }else this.dataInv=dataInvoices;
}
 @wire(getAllData, {parameterId: "$recordId"})
    getRecord({ error, data }) {
            if (data) {
        this.detailsData =JSON.parse(JSON.stringify(data)) ;
        console.log('=======wire=====',data);
        this.ytdAmt=data.ytdAmt;

        var dataInvoices=this.detailsData.Invoices;
        var dataInvoices=this.detailsData.Invoices;
        this.showInvError=true;
        if(this.detailsData.InvDetails)this.invId=this.detailsData.InvDetails.Id;
        if(dataInvoices){
        dataInvoices.forEach(function (element) {
            if(element.Sold_To_Party__c) element.SoldTo = element.Sold_To_Party__r.Name;
            if(element.Bill_To_Party__c) element.BillTo = element.Bill_To_Party__r.Name;
            });
            this.dataInv=dataInvoices;
        }
        if(dataInvoices && dataInvoices.length>0){
            this.invData1=dataInvoices;
            this.showInvError=false;
        }
            console.log("---this.data----", data);
        } else if (error) {
        console.log("---error----", error);
        }
    }

    doSorting(event) {
        console.log('sadfasdas');
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.dataInv));
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
        // cheking reverse direction
        let isReverse = direction === 'asc' ? 1: -1;
        // sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.dataInv = parseData;
    }   
}