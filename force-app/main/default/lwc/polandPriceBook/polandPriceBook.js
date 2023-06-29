import { LightningElement,wire,track,api } from 'lwc';
import 	polandpricebookmodalcss from '@salesforce/resourceUrl/polandpricebookmodalcss';
import { loadStyle} from 'lightning/platformResourceLoader';
import getPriceBookData from '@salesforce/apex/GetPriceBookDataPoland.getPriceBookData';

const columns=[
    { label: 'Sku Name', fieldName: 'SkuName',sortable: "true" },
    { label: 'Customer Name', fieldName: 'CustomerName' },
    { label: 'Payment Term in Days', fieldName: 'PaymentTerm',sortable: "true" },
    { label: 'UOM', fieldName: 'UOM'  },
    { label: 'Base Price', fieldName: 'BasePrice',sortable: "true" },
    { label: 'Manual Discount', fieldName: 'ManualDiscount',sortable: "true" },
    { label: 'Start Date', fieldName: 'Startdate',sortable: "true" },
    { label: 'End Date', fieldName: 'EndDate',sortable: "true" }
]

export default class PolandPriceBook extends LightningElement {
    @api recordId;
    @track tableData=[];
    @track isdata=false;
      sortBy;
    defaultSortDirection = 'desc';
    sortDirection = 'desc';
  
    Columns=columns;
    
     
    @wire(getPriceBookData , { recordId: '$recordId' })
    wiredRecordsMethod({ error, data }) {
        console.log('recordId'+this.recordId);
        console.log('Table Data-->'+JSON.stringify(data));
      
        if (data) {
            this.tableData=data;
            
              this.sortData('PaymentTerm', this.sortDirection);
              
     /*       this.tableData  = data.map(
      record => Object.assign(
   { "SKUCode__r.Division__r.Division_Code__c": ((record.SKUCode__r.Division__c==null || 
  record.SKUCode__r.Division__c=='undefined' )? '' :record.SKUCode__r.Division__r.Division_Code__c),
  "DepotCode__r.Location__c": ((record.DepotCode__c ==null || record.DepotCode__c=='undefined') ? '':record.DepotCode__r.Location__c),
  "SKUCode__r.SKU_Code__c":((record.SKUCode__c == null || record.SKUCode__c=='undefined') ?
  '' :record.SKUCode__r.SKU_Code__c),"DistributorCustomerCode__r.SAP_Customer_Code__c":((record.DistributorCustomerCode__c==null || record.DistributorCustomerCode__c=='undefined')
   ? '' :record.DistributorCustomerCode__r.SAP_Customer_Code__c),
   "SKUCode__r.Name":((record.SKUCode__r.Name==null || record.SKUCode__r.Name=='undefined')
   ? '' :record.SKUCode__r.Name),
   "Pmnt_Term__r.Payment_Term__c":((record.Pmnt_Term__c==null || record.Pmnt_Term__c=='undefined')
   ? '' :record.Pmnt_Term__r.Payment_Term__c)},
  record
       )
            );*/
              console.log('@@@@@@@@tableLength-------->'+this.tableData.length);
              if(this.tableData.length>0){
                  this.isdata=true;
              }
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data  = undefined;
        }
    }
    connectedCallback() {
        console.log('@@@@@recordId@@@@@'+this.recordId);
        loadStyle(this, polandpricebookmodalcss);
      }


    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        console.log('####sortBy==:>'+this.sortBy);
        this.sortDirection = event.detail.sortDirection;
           console.log('####sortBy==:>'+this.sortBy+'*****'+this.sortDirection);
        this.sortData(this.sortBy, this.sortDirection);
         

    }
    sortData(fieldname, direction) {
         console.log('####fieldname==:>'+fieldname+'*****'+direction);
        let parseData = JSON.parse(JSON.stringify(this.tableData));
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
        this.tableData = parseData;
        console.log('@@@@@@@@@@@@@@@@@@82'+JSON.stringify(this.tableData));
    }    

}