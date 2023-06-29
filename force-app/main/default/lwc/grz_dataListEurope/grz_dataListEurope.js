import { api, LightningElement, track } from 'lwc';
import getlistdata from "@salesforce/apex/Grz_InventoryEurope.getlistdata";
export default class Grz_dataListEurope extends LightningElement {
    @api optionSelected;
@track initialized = false;
@track fieldName;
@track objName;
@track titleTag='Search by Product';
@track datalistResult = [];
@track secondaryList=[];
@track spinnerVisible=false;
connectedCallback(){
    this.objName = "Stock_Requirement__c";
this.fieldName = "SKU__r.SKU_Description__c";
this.getlistdata();
}

@api
callabc(selectedValue) {
this.template.querySelector('input').value='';
console.log("selectedValueInChild", selectedValue);
this.optionSelected = selectedValue;
if (selectedValue === "SKU__r.SKU_Description__c") {
this.objName = "Stock_Requirement__c";
this.fieldName = "SKU__r.SKU_Description__c";
this.titleTag='Search by Product';
} else if (selectedValue === "Depot_Code__c") {
this.objName = "Depot__c";
this.fieldName = "Depot_Code__c";
this.titleTag='Search by Storage Location';
} else if (selectedValue === "SKU__r.SKU_Code__c") {
this.objName = "Stock_Requirement__c";
this.fieldName = "SKU__r.SKU_Code__c";
this.titleTag='Search by SKU Number';
} else if (selectedValue === "SKU__r.Brand_Name__c") {
this.objName = "Stock_Requirement__c";
this.fieldName = "SKU__r.Brand_Name__c";
this.titleTag='Search by Brand Name';
}
this.getlistdata();
}

getlistdata() {
    this.spinnerVisible=true;
console.log('methods call');
getlistdata({ objname: this.objName, fieldname: this.fieldName })
.then((result) => {
this.datalistResult=[];
this.secondaryList=[];
console.log('method called####',result);
for(var i=0;i<result.length;i++){
    if(this.fieldName==='Depot_Code__c'){
//         if(this.datalistResult.label.indexOf(result[i].Name)<0){
// console.log('###DataList',this.datalistResult.label.indexOf(result[i].Name));
//         }
//this.datalistResult.push({label:result[i].Name,value:result[i].Name});
this.secondaryList.push(result[i].Name);
    }
    
    else if(this.fieldName==='SKU__r.SKU_Description__c'){
      //  this.datalistResult.push({label:result[i].SKU__r.SKU_Description__c,value:result[i].SKU__r.SKU_Description__c});
        this.secondaryList.push(result[i].SKU__r.SKU_Description__c);
    }
    else if(this.fieldName==='SKU__r.SKU_Code__c'){
     //   this.datalistResult.push({label:result[i].SKU__r.SKU_Code__c,value:result[i].SKU__r.SKU_Code__c});
        this.secondaryList.push(result[i].SKU__r.SKU_Code__c);
    }
    else if(this.fieldName==='SKU__r.Brand_Name__c'){
      //  this.datalistResult.push({label:result[i].SKU__r.Brand_Name__c,value:result[i].SKU__r.Brand_Name__c});
        this.secondaryList.push(result[i].SKU__r.Brand_Name__c);
    }
}
this.secondaryList=this.secondaryList.filter((value,index) =>this.secondaryList.indexOf(value)===index);
for(var j=0;j<this.secondaryList.length;j++){
    this.datalistResult.push({label:this.secondaryList[j],value:this.secondaryList[j]});
}
console.log('secondaryList@@@',this.secondaryList);
console.log('secondaryList@@@'+JSON.stringify(this.secondaryList));
this.spinnerVisible=false;
})
.catch((error) => {
this.error = error;
this.spinnerVisible=false;
});
}
onTyping(event) {
var inputElement = this.template.querySelector('input').value;
console.log("this.optionSelected", inputElement);
const passEvent = new CustomEvent('search', {
detail:{getdaata:inputElement}
});
this.dispatchEvent(passEvent);
event.stopPropagation();
}

renderedCallback() {
// if (this.initialized) {
// return;
// }
// this.initialized = true;
let listId = this.template.querySelector("datalist").id;
this.template.querySelector("input").setAttribute("list",listId);
}
}