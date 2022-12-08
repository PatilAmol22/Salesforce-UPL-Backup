import { LightningElement,wire,track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAllActiveSku from '@salesforce/apex/BlanketProductController.getAllActiveSku';
import updateSku from '@salesforce/apex/BlanketProductController.updateSku';



    const columns = [
        { label: 'SKU',fieldName: 'skuName',type: 'text',editable:true, hideDefaultActions: "true"},
        { label: 'Sales Org', fieldName: 'salesOrgCode',type: 'text',editable:true, hideDefaultActions: "true"},
        { label: 'Start Date', fieldName: 'startDate' ,type: 'date-local',editable:true, hideDefaultActions: "true",
        typeAttributes: {
            day: "2-digit",
            month: "2-digit",
            year: "numeric"
            
        }
    },
        { label: 'End Date', fieldName: 'endDate', type: 'date-local' ,editable:true, hideDefaultActions: "true",
        typeAttributes: {
            day: "2-digit",
            month: "2-digit",
            year: "numeric"
            
        }
    },
        { label: 'Status', fieldName: 'skuStatus', type:'boolean', defaultValue:"true", editable:true, hideDefaultActions: "true" }
    ];
 export default class BlanketProduct extends LightningElement {
    recordId;
    draftValues = [];
    @track columns=columns; 
    @track skuList=[];
    @track blanketSkuUpdate=[];

    @wire (getAllActiveSku) 
    refreshTable;

@wire (getAllActiveSku) 
wiredActiveSku({error,data}){
if (data) {
        console.log('skuList',data);
        console.log('skuList',data.length);
        
    this.skuList = data.map(row=>{
            return{...row,  skuName: row.Name,
                salesOrgCode:row.Sales_Org_Code__c,
                startDate: row && row.Blanket_SKU__r && row.Blanket_SKU__r.length ? row.Blanket_SKU__r[0].Start_Date__c : '',
                endDate: row && row.Blanket_SKU__r && row.Blanket_SKU__r.length ? row.Blanket_SKU__r[0].End_Date__c : '',
                skuStatus: row && row.Blanket_SKU__r && row.Blanket_SKU__r.length ? row.Blanket_SKU__r[0].Status__c : '',
            }         
        })
    
    } else if(error) {
            console.log(error);
             }
         }

    resetFields(){
    eval("$A.get('e.force:refreshView').fire();"); 
    
    }

     handleSave(event) {
        const updatedFields = event.detail.draftValues;
        console.log('updatedFields',updatedFields)
        console.log('updatedFields:',JSON.stringify(updatedFields));
        
        this.draftValues = [];
        console.log('draftValues',this.draftValues);
        try {

             updateSku({ custWrapObjList:JSON.stringify(updatedFields)})
             .then(result => {
                console.log('result:',result);
             })
             console.log('updatedFields',updatedFields);
             console.log('draftValues',this.draftValues);
           
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Record updated',
                    variant: 'success'
                })
            )
           refreshApex(this.refreshTable);
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while updating or refreshing records',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        }
    }
}