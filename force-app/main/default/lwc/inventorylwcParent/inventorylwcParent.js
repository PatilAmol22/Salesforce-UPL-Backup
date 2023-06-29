import { LightningElement, track, wire, api } from "lwc";
import getEuropeOrg from "@salesforce/apex/GetEuropeInventoryData.getEuropeOrg";
// import getInventories from "@salesforce/apex/GetEuropeInventoryData.getInventories";
export default class InventorylwcParent extends LightningElement {
@track isChecked = false;
@track radiocheck1 = true;
@track radiocheck2 = false;
@track radiocheck3 = false;
@track radiocheck4 = false;
@track selectedValue = "SKU__r.SKU_Description__c";
@track orgData = [{ label: "ALL", value: "ALL" }];
@track clickedOrgList = ['ALL']; 
@track selecteditem; //Not used
@track searchDepot = "";
//@track orgValue = "2031;2032"; Not Used
@track childData=true;// used to call child data
@track countryAlias;
@track searchfield;
@track searchData;
@track runonce=1;
@wire(getEuropeOrg)
wiredOrg(result) {    
console.log("wire hit");
this.wiredoppResult = result;
if (result.data) {
    console.log("orgData==", result.data);

    result.data.forEach((ele) => {
    if (ele.Sales_Org_Code__c == "2031") {
        this.countryAlias = "UK";
    } else if (ele.Sales_Org_Code__c == "2032") {
        this.countryAlias = "IE";
    }
    let obj = {
        label: ele.Sales_Org_Code__c,
        value: this.countryAlias + "-" + ele.Sales_Org_Code__c
    };
    this.orgData = [...this.orgData, obj];
    //this.clickedOrgList.push(ele.Sales_Org_Code__c);
    });
    console.log("orgData==@@", this.orgData);
    //console.log("clickedOrgList22@@", this.clickedOrgList);
} else if (result.error) {
    this.error = result.error;
    console.log("AccountIdList++==" + this.error);
}
}
connectedCallback() {
  
}
renderedCallback(){
    if(this.runonce==1){
        this.template.querySelector(`[data-kpp="abc"]`).checked=true;
    this.template.querySelector(`[data-typee="ALL"]`).classList.add('rowColorBlue');
    this.template.querySelector(`[data-typee="ALL"]`).classList.remove('rowColorWhite');
    this.template.querySelector(`[data-idd="ALL"]`).classList.add('fontColorBlue');
    this.template.querySelector(`[data-idd="ALL"]`).classList.remove('fontColorWhite');
    this.runonce=2;
    }
}


get options() {
return [
    { label: "Product/SKU", value: "SKU__r.SKU_Description__c" },
    { label: "Storage Location", value: "Depot_Code__c" },
    { label: "SKU Number", value: "SKU__r.SKU_Code__c" },
    { label: "Brand Name", value: "SKU__r.Brand_Name__c" }
];
}

checkbox(event) {
if (this.isChecked === false) {
    this.isChecked = true;
} else {
    this.isChecked = false;
}
console.log("this.isChecked@@@", this.isChecked);
this.CommonChildCall();
}

handleradiochange(event) {
    console.log('###RaioCustom',event.target.name +'###'+event.currentTarget.dataset.radioname);
this.selectedValue = event.currentTarget.dataset.radioname;
this.options.forEach(
    (option) => (option.checked = option.value === this.selectedValue)
);
console.log("Radio Selected", this.selectedValue);
let elements = this.template.querySelectorAll("c-data-List");
console.log("data====",elements);
for (let i = 0; i < elements.length; i++) {
    elements[i].callabc(this.selectedValue);
}
}
handleSearch(event) {
this.searchData = event.detail.getdaata;
console.log("@@parentSearchData@@", this.searchData);
this.CommonChildCall();

}

rowClick(event){
    let rowid=event.currentTarget.dataset.typee;
    console.log('@@@@@@Row',event.currentTarget.dataset.typee);
   
    if(this.clickedOrgList.indexOf(rowid)<0 ){
        this.clickedOrgList.push(rowid);
        this.template.querySelector(`[data-idd="${rowid}"]`).classList.remove('fontColorWhite');
        this.template.querySelector(`[data-idd="${rowid}"]`).classList.add('fontColorBlue');
        this.template.querySelector(`[data-typee="${rowid}"]`).classList.add('rowColorBlue');
        this.template.querySelector(`[data-typee="${rowid}"]`).classList.remove('rowColorWhite');
    }
    else{
        var index = this.clickedOrgList.indexOf(rowid);
      if (index > -1) {
      this.clickedOrgList.splice(index, 1);
      }
        this.template.querySelector(`[data-idd="${rowid}"]`).classList.remove('fontColorBlue');
        this.template.querySelector(`[data-idd="${rowid}"]`).classList.add('fontColorWhite');
        this.template.querySelector(`[data-typee="${rowid}"]`).classList.add('rowColorWhite');
        this.template.querySelector(`[data-typee="${rowid}"]`).classList.remove('rowColorBlue');
    }
    this.CommonChildCall();
    console.log('this.clickedOrgList===='+this.clickedOrgList);
    
}
 



onOrgChange(event) {
console.log("Org Valuee", event.target.value);
}

CommonChildCall(event){
let elements = this.template.querySelectorAll("c-inventorylwc-child");
console.log("data====CommonChildCall" ,elements);
for (let i = 0; i < elements.length; i++) {
    elements[i].callData(this.searchDepot,this.isChecked,this.clickedOrgList,this.selectedValue,this.searchData);
}
}

handleItemSelected(event) {
console.log('ChildInvEvent Fire IN Parent');
console.log("@@parentpgno", event.detail.pgno);
}

}