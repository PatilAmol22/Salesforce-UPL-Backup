import { api, LightningElement, track, wire } from "lwc";
import 	ShowDetailsButton from '@salesforce/resourceUrl/ShowDetailsButton';
import 	HideDetailsButton from '@salesforce/resourceUrl/HideDetailsButton';
import 	ExpandAllInWhite from '@salesforce/resourceUrl/ExpandAllInWhite';
import 	CollapseAllInWhite from '@salesforce/resourceUrl/CollapseAllInWhite';
import getInventories from "@salesforce/apex/Grz_InventoryEurope.getInventories";
import Storage_Location_Uk from '@salesforce/label/c.Storage_Location_Uk';
import Product_SKU_UK from '@salesforce/label/c.Product_SKU_UK';
import Unrestricted_Inventory_UK from '@salesforce/label/c.Unrestricted_Inventory_UK';
import Batch_Number_UK from '@salesforce/label/c.Batch_Number_UK';
import Production_Date_UK from '@salesforce/label/c.Production_Date_UK';
import Expiry_Date_UK from '@salesforce/label/c.Expiry_Date_UK';
import Depot_UK from '@salesforce/label/c.Depot_UK';
import SKU_Code_UK from '@salesforce/label/c.SKU_Code_UK';
import UOM_UK from '@salesforce/label/c.UOM_UK';
import Physical_Stock_UK from '@salesforce/label/c.Physical_Stock_UK';
import Incoming_PO_UK from '@salesforce/label/c.Incoming_PO_UK';
import Stock_In_Transit_UK from '@salesforce/label/c.Stock_In_Transit_UK';
import Outgoing_Reservation_UK from '@salesforce/label/c.Outgoing_Reservation_UK';
import Unrestriced_Order_UK from '@salesforce/label/c.Unrestriced_Order_UK';
import Net_Stock_UK from '@salesforce/label/c.Net_Stock_UK';
export default class grz_inventoryEuropeChild extends LightningElement {
@api selectedDepots;
@api nozeroRecord;
@api orgValue;
@api fieldname;
@api searchTerm;

@track Net_Stock_UK=Net_Stock_UK;
@track Unrestriced_Order_UK=Unrestriced_Order_UK;
@track Outgoing_Reservation_UK=Outgoing_Reservation_UK;
@track Stock_In_Transit_UK=Stock_In_Transit_UK;
@track Incoming_PO_UK=Incoming_PO_UK;
@track Physical_Stock_UK=Physical_Stock_UK;
@track UOM_UK=UOM_UK;
@track SKU_Code_UK=SKU_Code_UK;
@track Depot_UK=Depot_UK;
@track Expiry_Date_UK=Expiry_Date_UK;
@track Production_Date_UK=Production_Date_UK;
@track Batch_Number_UK=Batch_Number_UK;
@track Unrestricted_Inventory_UK=Unrestricted_Inventory_UK;
@track Storage_Location_Uk=Storage_Location_Uk;
@track Product_SKU_UK=Product_SKU_UK
@track pageNumber=1;
@track recordDisply='20';
@track childwrapper;
@track showbutton=ShowDetailsButton;
@track hidebutton=HideDetailsButton;
@track showWhite=ExpandAllInWhite;
@track hideWhite=CollapseAllInWhite;
@track expandedDataList=[];
@track childData;
@track firstCallFlag=0;
@track showSpinner=false;
@track firstButton=true;
@track prevButton=true;
@track nextButton=false;
@track lastButton=false;
@track totalRecords;
@track calcPages;
@track customHeight;

connectedCallback() {
this.pageNumber=1;
this.recordDisply='20'
this.selectedDepots='';
this.nozeroRecord=false;
this.orgValue=['ALL'];
console.log('Child Compoent Calles');
if(this.getRecord){
  this.getRecord();
}
}

renderedCallback(){
  this.template.querySelector('[data-exp="expand"]').classList.remove('hideButton');
  this.template.querySelector('[data-exp="expand"]').classList.add('showButton');
  this.template.querySelector('[data-cola="colapse"]').classList.add('hideButton');
   this.template.querySelector('[data-cola="colapse"]').classList.remove('showButton');
}
get optionss() {
  return [
      { label: "10", value: "10" },
      { label: "20", value: "20" },
      { label: "50", value: "50" },
      { label: "100", value: "100" }
  ];
  }

@api
callData(selectedDepots,nozeroRecord,orgValue,fieldname,searchTerm) {
this.pageNumber=1;
this.selectedDepots=selectedDepots;
this.nozeroRecord=nozeroRecord;
this.orgValue=orgValue;
this.fieldname=fieldname;
this.searchTerm=searchTerm;
console.log('@@@SabkaData',this.selectedDepots+'org'+orgValue+'@@@@@'+nozeroRecord+'$$$'+fieldname+'###'+searchTerm);
this.getRecord();
}

getRecord(){
  console.log('@@@SabkaData GetRecord',+this.pageNumber+'^^^^'+this.recordDisply +'#####'+this.selectedDepots+'org',this.orgValue+'@@@@@'+this.nozeroRecord+'$$$'+this.fieldname+'###'+this.searchTerm);
this.showSpinner=true;
this.childwrapper=[];
var recordDisplay= parseInt(this.recordDisply);
console.log('recordDisplay@@@@'+recordDisplay);
console.log('nozeroRecord@@@@',this.nozeroRecord);
console.log('this.pageNumber@@@@'+this.pageNumber);
console.log('this.getInventories@@@@',this.getInventories);
console.log('this.orgValue@@@@'+this.orgValue);
console.log('this.fieldname@@@@',this.fieldname);
console.log('this.searchTerm',this.searchTerm);
  getInventories({pageNumber:this.pageNumber,recordToDisply:recordDisplay,
      SelectedDepots:this.getInventories,NoZeroSAPRecord:this.nozeroRecord,
      orgValue:this.orgValue,fieldname:this.fieldname,value:this.searchTerm})
  .then(result => {   
//       console.log('result12345===',result);
       console.log('result12345==='+JSON.stringify(result));
    this.childData=result;
//      // console.log('this.childData',JSON.stringify(this.childData));
    console.log('Length--Parent',this.childData.listWrapStkReqInv.length);
     this.childwrapper= this.childData.listWrapStkReqInv;
     console.log('this.childwrapper->>',JSON.stringify(this.childwrapper));
     this.totalRecords=this.childData.total;
     this.calcPages=Math.ceil(this.totalRecords/this.recordDisply);
     this.showSpinner=false;
if(this.pageNumber>=this.calcPages){
  this.nextButton=true;
}
else{
  this.nextButton=false;
}
if(this.pageNumber==1){
  this.prevButton=true;
  this.firstButton=true;
}
else{
  this.prevButton=false;
  this.firstButton=false;
}
if(this.pageNumber==this.calcPages || this.calcPages==0){
  this.lastButton=true;
}
else{
  this.lastButton=false;
}

console.log('@@@@@this.totalRecords',this.totalRecords+'####'+this.calcPages);
// console.log('END OF Get Record');
  })
  .catch(error => {
      console.log('error==>',JSON.stringify(error));
      this.error = error;
      this.showSpinner=false;
  });
}


//   fireEvent(event){
//     console.log('ChildInvEvent Fire');
//   const evt = new CustomEvent ('itms', { detail : {pgno :this.pageNumber,rdisplay:this.recordDisply,sDepot:this.selectedDepots,checkbox:this.nozeroRecord,oValue:this.orgValue,fName:this.fieldname,sTerm:this.searchTerm}});
//   this.dispatchEvent (evt);
//     event.stopPropagation();
// }

onRecordPage(event) {
  this.pageNumber=1;
  this.recordDisply = event.target.value;
  console.log("Number of Record Shubham", event.target.value);
  this.getRecord();
  
  }

ShowbuttonClick(event){
console.log('expandedDataList',this.expandedDataList);
  let myid= event.currentTarget.dataset.id;
  
  console.log('###event.currentTarget'+' '+myid);
  console.log(this.template.querySelector(`[data-child="${myid}"]`).classList);
  
console.log('Index@@',this.expandedDataList.indexOf(myid) );
  if(this.expandedDataList.indexOf(myid)<0 ){
    this.expandedDataList.push(myid); 
  console.log('condition1');
  this.template.querySelectorAll(`[data-child="${myid}"]`).forEach(element => {
    element.classList.add('show');
    element.classList.remove('hiddee');
  });
         
    console.log('show', (this.template.querySelector(`[data-show="${myid}"]`).classList));
      console.log('hide', (this.template.querySelector(`[data-hide="${myid}"]`).classList));
    this.template.querySelector(`[data-show="${myid}"]`).classList.remove('show');
    this.template.querySelector(`[data-show="${myid}"]`).classList.add('hiddee');
    this.template.querySelector(`[data-hide="${myid}"]`).classList.add('show');
    this.template.querySelector(`[data-hide="${myid}"]`).classList.remove('hiddee');
    // below 4 line for mobile
    this.template.querySelector(`[data-showwer="${myid}"]`).classList.remove('show');
    this.template.querySelector(`[data-showwer="${myid}"]`).classList.add('hiddee');
    this.template.querySelector(`[data-hider="${myid}"]`).classList.add('show');
    this.template.querySelector(`[data-hider="${myid}"]`).classList.remove('hiddee');
  }
  else{
    console.log('condition2');
   
    this.template.querySelectorAll(`[data-child="${myid}"]`).forEach(element => {
      element.classList.add('hiddee');
      element.classList.remove('show');
    });
    
    this.template.querySelector(`[data-show="${myid}"]`).classList.remove('hiddee');
    this.template.querySelector(`[data-show="${myid}"]`).classList.add('show');
    this.template.querySelector(`[data-hide="${myid}"]`).classList.add('hiddee');
    this.template.querySelector(`[data-hide="${myid}"]`).classList.remove('show');
// below 4 line for mobile
this.template.querySelector(`[data-showwer="${myid}"]`).classList.remove('hiddee');
this.template.querySelector(`[data-showwer="${myid}"]`).classList.add('show');
this.template.querySelector(`[data-hider="${myid}"]`).classList.add('hiddee');
this.template.querySelector(`[data-hider="${myid}"]`).classList.remove('show');


    var index = this.expandedDataList.indexOf(myid);
    if (index > -1) {
    this.expandedDataList.splice(index, 1);
    }
  } 
  console.log('Clicked Second Time',this.expandedDataList);

  // code for fix absolute position issue in produdct/SKU
  if( this.template.querySelector(`[data-calprod="${myid}"]`)){
  let he1=this.template.querySelector(`[data-calprod="${myid}"]`).offsetHeight;
  this.template.querySelector(`[data-heightprod="${myid}"]`).style="height:"+he1+"px";
  }

  if( this.template.querySelector(`[data-calstore="${myid}"]`)){
    let he2=this.template.querySelector(`[data-calstore="${myid}"]`).offsetHeight;
    this.template.querySelector(`[data-heightstore="${myid}"]`).style="height:"+he2+"px";
    }
    if( this.template.querySelector(`[data-calunres="${myid}"]`)){
      let he3=this.template.querySelector(`[data-calunres="${myid}"]`).offsetHeight;
      this.template.querySelector(`[data-heightunres="${myid}"]`).style="height:"+he3+"px";
      }

   if( this.template.querySelector(`[data-calbatch="${myid}"]`)){
        let he4=this.template.querySelector(`[data-calbatch="${myid}"]`).offsetHeight;
        this.template.querySelector(`[data-heightbatch="${myid}"]`).style="height:"+he4+"px";
        }

        if( this.template.querySelector(`[data-calpdate="${myid}"]`)){
          let he5=this.template.querySelector(`[data-calpdate="${myid}"]`).offsetHeight;
          this.template.querySelector(`[data-heightpdate="${myid}"]`).style="height:"+he5+"px";
          }
          
        if( this.template.querySelector(`[data-caledate="${myid}"]`)){
          let he6=this.template.querySelector(`[data-caledate="${myid}"]`).offsetHeight;
          this.template.querySelector(`[data-heightedate="${myid}"]`).style="height:"+he6+"px";
          }
// code for fix absolute position issue in produdct/SKU


}

onExpand(event){
  // this.showSpinner=true;
  // setTimeout(() => {
  //   this.showSpinner=false;
  // }, 10000);
  this.template.querySelector('[data-exp="expand"]').classList.remove('showButton');
  this.template.querySelector('[data-exp="expand"]').classList.add('hideButton');
  this.template.querySelector('[data-cola="colapse"]').classList.add('showButton');
   this.template.querySelector('[data-cola="colapse"]').classList.remove('hideButton');

  for(var i=0;i<this.childwrapper.length;i++){
    console.log('thisImportantData',this.childwrapper[i].stkReq.Id);
    this.expandedDataList.push(this.childwrapper[i].stkReq.Id);
  }
  this.template.querySelectorAll('[data-typee="childData"]').forEach(element => {
    element.classList.add('show');
    element.classList.remove('hiddee');
  });
  this.template.querySelectorAll('[data-sar="showallrow"]').forEach(element => {
    element.classList.add('hiddee');
    element.classList.remove('show');
  });
  
   this.template.querySelectorAll('[data-sah="hideallrow"]').forEach(element => {
    element.classList.add('show');
    element.classList.remove('hiddee');
  });
 
   console.log('ExpandAlll',this.expandedDataList);

// code for fix absolute position issue in produdct/SKU
for(var k=0;k<this.expandedDataList.length;k++){
  var myid=this.expandedDataList[k];
if(this.template.querySelector(`[data-calprod="${myid}"]`)){
let h1=this.template.querySelector(`[data-calprod="${myid}"]`).offsetHeight;
this.template.querySelector(`[data-heightprod="${myid}"]`).style="height:"+h1+"px";
}

if(this.template.querySelector(`[data-calstore="${myid}"]`)){
  let h2=this.template.querySelector(`[data-calstore="${myid}"]`).offsetHeight;
  this.template.querySelector(`[data-heightstore="${myid}"]`).style="height:"+h2+"px";
  }

  if(this.template.querySelector(`[data-calunres="${myid}"]`)){
    let h3=this.template.querySelector(`[data-calunres="${myid}"]`).offsetHeight;
    this.template.querySelector(`[data-heightunres="${myid}"]`).style="height:"+h3+"px";
    }

    if(this.template.querySelector(`[data-calbatch="${myid}"]`)){
      let h4=this.template.querySelector(`[data-calbatch="${myid}"]`).offsetHeight;
      this.template.querySelector(`[data-heightbatch="${myid}"]`).style="height:"+h4+"px";
      }

      if(this.template.querySelector(`[data-calpdate="${myid}"]`)){
        let h5=this.template.querySelector(`[data-calpdate="${myid}"]`).offsetHeight;
        this.template.querySelector(`[data-heightpdate="${myid}"]`).style="height:"+h5+"px";
        }

        if(this.template.querySelector(`[data-caledate="${myid}"]`)){
          let h6=this.template.querySelector(`[data-caledate="${myid}"]`).offsetHeight;
          this.template.querySelector(`[data-heightedate="${myid}"]`).style="height:"+h6+"px";    
          }

}
//code for fix absolute position issue in produdct/SKU



}

onCollapse(event){
  this.template.querySelectorAll('[data-typee="childData"]').forEach(element => {
    element.classList.add('hiddee');
    element.classList.remove('show');
  });
  this.template.querySelectorAll('[data-sar="showallrow"]').forEach(element => {
    element.classList.add('show');
    element.classList.remove('hiddee');
  });
  
   this.template.querySelectorAll('[data-sah="hideallrow"]').forEach(element => {
    element.classList.add('hiddee');
    element.classList.remove('show');
  });
  this.template.querySelector('[data-exp="expand"]').classList.remove('hideButton');
  this.template.querySelector('[data-exp="expand"]').classList.add('showButton');
  this.template.querySelector('[data-cola="colapse"]').classList.add('hideButton');
   this.template.querySelector('[data-cola="colapse"]').classList.remove('showButton');
   this.expandedDataList=[];
}
OnClickLast(event){
  this.pageNumber=this.calcPages;
  this.getRecord();
}
OnClickNext(event){
this.pageNumber++;
this.getRecord();
}
OnClickPrevious(event){
this.pageNumber--;
this.getRecord();
}
onClickFirst(event){
this.pageNumber=1;
this.getRecord();
}

}