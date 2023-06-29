import { LightningElement, track, wire,api } from 'lwc';
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import getArData from '@salesforce/apex/Grz_ArgentinaConsignmentStockController.getArData';
import fetchExistingRecord from '@salesforce/apex/Grz_ArgentinaConsignmentStockController.retreiveExistingRecord';
import retrievePaymentMethod from '@salesforce/apex/Grz_ArgentinaConsignmentStockController.retrievePaymentMethod';
import loggedUserData from '@salesforce/apex/Grz_ArgentinaConsignmentStockController.loggedUserData';
import insertConsignmentStock from '@salesforce/apex/Grz_ArgentinaConsignmentStockController.insertConsignmentStockList';
import updateStatusOfConsignment from '@salesforce/apex/Grz_ArgentinaConsignmentStockController.updateStatusOfConsignment';
import ConsignmentStocks from "@salesforce/label/c.Grz_ConsignmentStock";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import DownloadPDF from "@salesforce/label/c.Grz_DownloadPFD";
import DownloadXLS from "@salesforce/label/c.Grz_DownloadXLS";
import ArSearchLabel from "@salesforce/label/c.Grz_ArSearch";
import fetchConsignmentStock from '@salesforce/apex/Grz_ArgentinaConsignmentStockController.retrieveConsignmentStock';
import fetchEditDeclaration from '@salesforce/apex/Grz_ArgentinaConsignmentStockController.retrieveEditDeclaration';
import deleteConsignmentStock from '@salesforce/apex/Grz_ArgentinaConsignmentStockController.deleteConsignmentStock';
import { loadStyle } from 'lightning/platformResourceLoader'; //Added By Nishi
import MobileCardCSS from '@salesforce/resourceUrl/CustomMobileCardCSS'; //Added By Nishi
import LightningConfirm from 'lightning/confirm';



export default class grz_ArgentinaConsignmentStock extends LightningElement {
DownloadPDF = DownloadPDF;
DownloadXLS = DownloadXLS;
backgroundimage = Icons + "/Grz_Resourse/Images/Carousel.jpg";
downloadIcon = Icons + "/Grz_Resourse/Images/DownloadIcon.png";
ArSearchLabel = ArSearchLabel;
columns = [
{ label: 'Producto', fieldName: 'MaterialDescription' },
{ label: 'Lote', fieldName: 'BatchNo' },
{ label: 'Cantidad', fieldName: 'UnrestrictedInventory' },
];
@track data;
@track error;
Headertitle = ConsignmentStocks;
@track ConsignmentStockListwithItems = new Map();
@track previousQtySoldMap=new Map();
@track paymentTermResult=new Map();
@track CustomerCode;
@track isExternal=true;
@track CustomerName;
@track isSpinner = true;
@track isLoading = false
@track disableButton=true;
@track ledgerRecords = [];
@track fetchRecords=[];
@track allItemList=[];
uploadedFiles = []; file; fileContents; fileReader; content; fileName  

isDataNull = false;
isSuccess = true;
isSuccessArData = false;
nodata = false;
message = 'No se encontraron registros';
errorMessage;
message2show='Por favor, ingrese el código de cliente';
declarationRequired=false;
value='';
selectedoptionARG=false;
exchangerateValue=0.0;
PaymentTermValue='';
LPNumberValue='';
QtySold=0;
netPrice=0.0;
showdeclaration=false;
hidedeclaration=true;
distributor='';
@track mapData=[];
@track existingQtyMap=new Map();
@track availableQtyMap=new Map();

@track paymentTermMap=[];
@track paymentTermOptions=[];
@track recordtodisplay=[];
isEdit=false;
recordSavedSuccess=false;
clickSaveUpload=false;
isFileUpload=false;
isQtySoldValid=true;
paymentMethodValue='';
displayFileName=false;
isCommaChangedtoDecimal=false;
ismultipleof=false;
multipleOf='';


//Added By Ishu for Currency option
get options() {
return [
  { label: 'USD', value: 'USD' },
  { label: 'ARG', value: 'ARG' },
];

}

//Added by Nishi for Mobile responsive cards css
connectedCallback() {        
 Promise.all([
      loadStyle( this, MobileCardCSS )
      ]).then(() => {
          console.log( 'Files loaded' );
      })
      .catch(error => {
          console.log( error.body.message );
  });
}


get ARpdfURL() {
return ('/uplpartnerportalstd/apex/Grz_ArgConsignmentStockPDF?CustomerCode='+ this.searchKeyBar);
}


get ARxlsURL() {
return ('/uplpartnerportalstd/apex/Grz_ArgConsignmentStockXLS?CustomerCode='+ this.searchKeyBar);
}
onChangeSearch(event) {
this.searchKeyBar = event.target.value;
console.log('this.searchKeyBar : '+this.searchKeyBar);
if(this.searchKeyBar !='' || this.searchKeyBar !=undefined){
this.disableButton=false;
}
else{
this.disableButton=true;
}
}


handleCustomerData(){
this.isSpinner = true;
this.ledgerRecords = [];
if(this.searchKeyBar == '' || this.searchKeyBar ==null || this.searchKeyBar ==undefined){
const event = new ShowToastEvent({
  title:
    "Ingrese el código de cliente",
  variant: "error"
});
this.dispatchEvent(event);
}


this.disableButton=true;
var searchval = this.searchKeyBar;

if((searchval != '' && searchval != undefined)) {
console.log('=====this.searchKeyBar==='+this.searchKeyBar);
getArData({executedfrom: this.searchKeyBar}).then((result) => {

    console.log('getArAndLedgerData result==>',result);
    var message1=result.Message;
    this.ledgerRecords  = result.ItemInfo;
    //this.ledgerRecords.push(result.ItemInfo[0]);
    /*for(var i=0;i<15;i++){
      this.ledgerRecords = [...this.ledgerRecords, result.ItemInfo[0]];
    }*/
    console.log('getArAndLedgerData result==>',this.ledgerRecords);
    console.log('getArAndLedgerData Message==>',message1);
    //
    if(message1==undefined){
        this.isDataNull=true;
        this.message2show='Por favor, ingrese el código de cliente';
    }
    else {
        this.isDataNull=false;
        if(message1=='Error_In_Sap')this.message2show='Error en SAP';
        if(message1=='Data does not exist')this.message2show='No data';
        if(message1=='No access to account')this.message2show='No data/No tienes el acceso requerido';
    }
    
    this.prepareLedgerRecordList();//added by Ishu to show ledger data
   
    this.retreivePaymentTerm();
    this.isSpinner = false;

})
.catch(error => {
  this.isSpinner = false;
  console.log('error in AR : ',error);
});


}
else{
this.isSpinner = false;
}
this.disableButton=false;
}

@wire(loggedUserData, {

})
loggedUserData(result) {
if (result.data) {
if(result.data.AccountId==undefined){
    this.isExternal=false;
    console.log('==================',JSON.stringify(result.data))
    this.isSpinner=false;

}else{
  this.distributor=result.data.AccountId;
  
    this.isExternal=true;
    console.log('*********CustomerCode*********',JSON.stringify(result.data.CustomerCode));
    this.searchKeyBar=result.data.CustomerCode;
    this.handleCustomerData();
}
}
}
LedgerPDF() {
this.isSpinner = true;
setTimeout(() => {
this.isSpinner = false;
}, 4000);
}
LedgerXLS() {
this.isSpinner = true;
setTimeout(() => {
this.isSpinner = false;
}, 4000);
}

//Added By Ishu for if DB declares the Consignment Stock
handleDeclarationChange(event)
{
if( event.target.checked)
{
this.declarationRequired=true;
}
else
{
this.declarationRequired=false;
}
}

//Added By Ishu
handleLPNumber(event)
{
this.LPNumberValue=event.target.value;
}
handleExchangeRate(event)
{
this.exchangerateValue=event.target.value;


}
//on change of Qty Sold and fetch rowId i.e. lote number
handleQTYSoldChange(event)
{var previousQtySold=0;

var TotalQty=event.target.value;
var qty=event.target.value;

const lastIndex = (event.currentTarget.id).lastIndexOf('-');
var rowId  = (event.currentTarget.id).slice(0, lastIndex);
var availableQty=this.availableQtyMap.get(rowId);
var list=this.ConsignmentStockListwithItems.get(rowId);
for(let i=0;i<this.recordtodisplay.length;i++)
{
  if(this.recordtodisplay[i].lote==rowId)
  {
    this.recordtodisplay[i].quantitySold=qty;
  }
}

//var previousEnteredQty=list.quantitySold;
list.quantitySold=TotalQty;

//var totalReturnQty = parseInt(exisitngQty) + parseInt(list.quantitySold)-parseInt(previousEnteredQty);
if(TotalQty.indexOf(",")!=-1)
{
 TotalQty =TotalQty.replace(",",".");
}
if(parseFloat(TotalQty) > parseFloat(availableQty)){
list.quantitySold=0;
this.title = 'Error';
    this.msg = 'Quantity Sold Should not be greater than '+availableQty;
    this.variant = 'Error';
    this.toastMessage();
this.isQtySoldValid=false;

}
else{
  this.isQtySoldValid=true;
  
}

console.log('list.QtySold=---'+list.quantitySold);
}

//on change of net Price and fetch rowId i.e. lote number
handleNetPriceChange(event)
{
  const lastIndex = (event.currentTarget.id).lastIndexOf('-');
  var rowId  = (event.currentTarget.id).slice(0, lastIndex);
  var netPrice=event.target.value;
 
var list=this.ConsignmentStockListwithItems.get(rowId);
list.netPrice=netPrice;
console.log('list.netPrice=---'+list.netPrice);

}

//method to get currency selected 
handleCurrencyChange(event)
{
this.value=event.detail.value;
const selectedOption = event.detail.value;
console.log('Option selected with value: ' + selectedOption);
if(selectedOption=='USD')
{
this.selectedoptionARG=false;
this.exchangerateValue=1.0; //if currency selected as USD then exchanges rate will be 1;
}
else
{
this.selectedoptionARG=true; // if currecy selected ARG populate exchane rate field
}
}

onFileUpload(event) { 
this.isFileUpload=true; 
this.uploadedFiles = event.detail.files;
        this.displayFileName =true;
if (event.target.files.length > 0) {  
this.uploadedFiles = event.target.files;  
this.fileName = event.target.files[0].name;  
this.file = this.uploadedFiles[0];  
if (this.file.size > this.MAX_FILE_SIZE) {  
  alert("File Size Can not exceed" + MAX_FILE_SIZE);  
}  
}  
}  

handlePaymentTermChange(event) {
// Get the payment term value attribute on the selected option
this.PaymentTermValue = event.detail.value;
}
handlePaymentMethodChange(event)
{
  this.paymentTermOptions=[];
  
  this.paymentMethodValue=event.detail.value;
  this.handlePaymenttermoptions(this.paymentMethodValue);
 
// this.template.querySelector('lightning-combobox.paymentTerm').options=this.paymentTermOptions;
  
  
  

}
//On Click of Save and Upload Save the Data and Populate the Declaration screen.
saveUpload(event)
{
this.clickSaveUpload=true;
this.isEdit=false;

if(this.isFileUpload)
{
this.fileReader = new FileReader();  
this.fileReader.onloadend = (() => {  
  this.fileContents = this.fileReader.result;  
  let base64 = 'base64,';  
  this.content = this.fileContents.indexOf(base64) + base64.length;  
  this.fileContents = this.fileContents.substring(this.content);  
  this.saveData(); // save the data in the Consignment_Stock__c Object 
  displayFileName=false; 
});  
this.fileReader.readAsDataURL(this.file); 
}
else{
this.saveData(); 
displayFileName=false;
}


}
//when click on save and new button
saveNew(event)
{
this.isEdit=false;
this.clickSaveUpload=false;


//if file is uploaded 
if(this.isFileUpload)
{
this.fileReader = new FileReader();  
this.fileReader.onloadend = (() => {  
this.fileContents = this.fileReader.result;  
let base64 = 'base64,';  
this.content = this.fileContents.indexOf(base64) + base64.length;  
this.fileContents = this.fileContents.substring(this.content);  
this.saveData();  
displayFileName=false;
});  
this.fileReader.readAsDataURL(this.file); 
}
//if document is not uploaded
else

this.saveData();  
displayFileName=false;

}
//method Added by Ishu to save the Data in Consignment Stock
saveData()
{
var invalidRow=false; // if any of UOM ,QtySold and Net Price empty 
var allfieldEntered=true; //required Field Mandatory
var count=0;
var itemList=[];
var totalAmount=0;
console.log('this.ConsignmentStockListwithItems----->'+this.ConsignmentStockListwithItems);

console.log('this.recordtodisplay---->'+this.recordtodisplay);
for (const [key, value] of this.ConsignmentStockListwithItems) { // Using the default iterator (could be `map.entries()` instead)
console.log('The value for key' + key +' values ' +value);
var list= this.ConsignmentStockListwithItems.get(key);
count=count+1;
totalAmount=totalAmount+list.quantitySold*list.netPrice;
if(this.value=='' || this.PaymentTermValue=='' || this.LPNumberValue=='' || this.paymentMethodValue=='')
{ 
allfieldEntered=false;
}
else if((list.quantitySold%list.multipleOf!=0))
{
  invalidRow=true;
  break;
}
else if((list.quantitySold==0 && list.netPrice==0 )||( list.quantitySold!=0 && list.netPrice!=0)  )
{
invalidRow=false;
list.quantitySold=list.quantitySold.toString();
if(list.quantitySold.indexOf(",")!=-1)
{
  list.quantitySold =list.quantitySold.replace(",",".");
 
}
list.quantitySold=parseFloat(list.quantitySold);
list.netPrice=list.netPrice.toString();
if(list.netPrice.indexOf(",")!=-1)
{
  list.netPrice =list.netPrice.replace(",",".");
 
}

list.netPrice=parseFloat(list.netPrice);
itemList.push({
product:list.product, 
material:list.material,
lote:list.lote,
quantity:list.quantity,
availableQty:list.availableQty,
expiryDate:list.expiryDate,
uom:list.uom,
quantitySold: list.quantitySold,
netPrice:list.netPrice
})

}

else{
invalidRow=true;
break;
}}
//if row doesn't have proper value 
if(invalidRow)
{
this.title = 'Error';
this.msg = 'Please Enter Valid Details at row  no: ' +count;
this.variant = 'Error';
this.toastMessage();
this.recordSavedSuccess=false;
}
//if mandatory fields are not entered
else if(allfieldEntered==false)
{
this.title = 'Error';
this.msg = 'Please Enter all required field';
this.variant = 'Error';
this.toastMessage();
}
//if all rows are blank with value 0
else if(totalAmount==0)
{
this.title = 'Error';
this.msg = 'Please Enter atleast 1 line item';
this.variant = 'Error';
this.toastMessage();
}
//if quantity entered is more than total quantity
else if(this.isQtySoldValid==false)
{
this.title = 'Error';
this.msg = 'Please Enter Valid Quantity';
this.variant = 'Error';
this.toastMessage();
}
// Call Apex method to insert the data in Consignment Stock.
else
{this.allItemList=itemList;
  this.isSpinner=true;
  this.exchangerateValue=this.exchangerateValue.toString();
  if(this.exchangerateValue.indexOf(",")!=-1)
{
  this.exchangerateValue =this.exchangerateValue.replace(",",".");
 
}
this.exchangerateValue=parseFloat(this.exchangerateValue);
insertConsignmentStock({
arrayitemList:itemList,distributorId:this.distributor,currenci:this.value,exchangeRate:this.exchangerateValue,lpNumber:this.LPNumberValue,PaymentTermValue:this.PaymentTermValue,PaymentMethod:this.paymentMethodValue, file: encodeURIComponent(this.fileContents),  
fileName: this.fileName 
})
.then(result => {
  if(result.Result=='Success')
  {
    this.title = result.Result;
    this.msg = result.toastMsg;
    this.variant = result.Result;
    this.toastMessage();
    this.calculateAvailableQty();
    this.fileName='';
    this.isSpinner=false;
    //when click on save and upload
    if(this.clickSaveUpload==true)
    {
      this.showdeclaration=true; //show declaration
      this.declarationRequired=false;
      this.showDeclarationData(this.distributor);//data to show on declaration screen.
      
    }
    //when click on save and new
    else
    {
      this.showdeclaration=false;
      this.declarationRequired=true;
      this.LPNumberValue='';
      this.PaymentTermValue='';
      this.value='';
      this.exchangerateValue='';
      this.selectedoptionARG=false;
      this.paymentMethodValue='';
      this.recordtodisplay=[];

      this.prepareLedgerRecordList(); // for Clearing of Data Entered.
    }
    
  }
  else{
    this.isSpinner=false;
    this.declarationRequired=false;
    throw new Error(result.toastMsg);
  }
    
    
})
.catch(error => {
    console.log('err ' + JSON.stringify(error));
    this.declarationRequired=false;
    this.title = 'Error';
    this.msg = error.message;
    this.variant = 'Error';
    this.toastMessage();
    this.recordSavedSuccess=false;
    this.declarationRequired=false;
    
});
}
}

//Call Apex Class to fetch the data from Consignemnt Stock 
showDeclarationData(distributor)
{ var map=[];
console.log('distributor----->'+distributor);
this.isSpinner=true;
this.showdeclaration=true;
fetchConsignmentStock({
distributorId:distributor
})
.then(result => {
console.log('result----->'+JSON.stringify(result));
this.isSpinner=false;
for (let key in result) {
map.push({value:result[key], key:key});
}

this.mapData=map;
})
.catch(error => {
});
}

editDeclaration(event)
{
console.log(event.currentTarget.id);
var name=event.target.name;
var currentid=event.currentTarget.id.split('-');
currentid=currentid[0];
this.isEdit=true;
this.isSpinner=true;
fetchEditDeclaration({
distributorId:this.distributor,lpNo:currentid
})
.then(result => {
console.log('result==>'+JSON.stringify(result));
this.recordtodisplay.pop;
this.isSpinner=false;

  this.fetchRecords=result;
  this.recordtodisplay= this.fetchRecords.ConsignmentInfo;

  for(let i=0;i<this.recordtodisplay.length;i++)
{
var list=this.ConsignmentStockListwithItems.get(this.recordtodisplay[i].lote);
var quantitySld=this.recordtodisplay[i].quantitySold;
this.recordtodisplay[i].quantitySold=this.recordtodisplay[i].quantitySold.toString();
if(this.recordtodisplay[i].quantitySold.indexOf(".")!=-1)
{
  this.recordtodisplay[i].quantitySold =this.recordtodisplay[i].quantitySold.replace(".",",");
 
}
this.recordtodisplay[i].netPrice=this.recordtodisplay[i].netPrice.toString();
if(this.recordtodisplay[i].netPrice.indexOf(".")!=-1)
{
  this.recordtodisplay[i].netPrice =this.recordtodisplay[i].netPrice.replace(".",",");
 
}

list.quantitySold=this.recordtodisplay[i].quantitySold;
list.netPrice=this.recordtodisplay[i].netPrice;
var existingQtyAvailable=this.availableQtyMap.get(this.recordtodisplay[i].lote);
list.availableQty=existingQtyAvailable+quantitySld;
this.recordtodisplay[i].availableQty=list.availableQty;
this.availableQtyMap.set(this.recordtodisplay[i].lote,list.availableQty);
this.previousQtySoldMap.set(this.recordtodisplay[i].lote,this.recordtodisplay[i].quantitySold);
console.log('ConsignmentStockListwithItems------->'+JSON.stringify(this.ConsignmentStockListwithItems.get(this.recordtodisplay[i].lote)));
}
  this.showdeclaration=false;
  this.declarationRequired=true;
  this.LPNumberValue=this.fetchRecords.lPNumber;
  
  this.value=this.fetchRecords.currenci;
  if(this.value=='ARG')
  {
    this.selectedoptionARG=true;
  }
  this.exchangerateValue=this.fetchRecords.exchangeRate;

  this.exchangerateValue=this.exchangerateValue.toString();

if(this.exchangerateValue.indexOf(".")!=-1)
{
  this.exchangerateValue =this.exchangerateValue.replace(".",",");
 
}


  
  this.paymentMethodValue=this.fetchRecords.paymentMethod;
  this.handlePaymenttermoptions(this.paymentMethodValue);
  this.PaymentTermValue=this.fetchRecords.paymentTerm;


  for(let i=0;i<this.mapData.length;i++)
  {
    if(this.mapData[i].value.LP_Number__c==this.LPNumberValue)
    {
      this.fileName=this.mapData[i].value.File_Name__c;
    }
  }
  
  
})
.catch(error => {
  
  
});


}
//Added By Ishu for to display the screen to enter  Declaration 
prepareLedgerRecordList()
{


this.recordtodisplay=[];

var map=new Map();
  fetchExistingRecord({
    distributorId:this.distributor
    })
    .then(result => {
    console.log('result----->'+JSON.stringify(result));
    for (let key in result) {
      map.set(key, result[key]);
    }
    this.existingQtyMap=map;
    for(let i=0;i<this.ledgerRecords.length;i++)
{
var product = this.ledgerRecords[i].MaterialDescription; 
var material=this.ledgerRecords[i].MaterialNo;
var Lote =  this.ledgerRecords[i].BatchNo;
var quantity =  this.ledgerRecords[i].UnrestrictedInventory;
var multipleOf=this.ledgerRecords[i].multipleOf;
if(this.existingQtyMap.get(Lote)!=null)
{
  var availableQty=quantity-this.existingQtyMap.get(Lote);
}
else{
  var availableQty=parseFloat(quantity);
}

var expiryDate=this.ledgerRecords[i].Expirydate;
var uom = this.ledgerRecords[i].uom;
var quantitySold = 0.0;
var netPrice=0.0;

let consignmentStockData = {
product:product,
lote:Lote,
material:material,
quantity: quantity,
availableQty:availableQty,
expiryDate:expiryDate,
uom : uom,
quantitySold: quantitySold,
netPrice :netPrice,
multipleOf:multipleOf
}
console.log('consignmentStockData ******************** ',JSON.stringify(consignmentStockData));
this.recordtodisplay.push(consignmentStockData); //to show the initial Data
this.ConsignmentStockListwithItems.set(this.ledgerRecords[i].BatchNo,consignmentStockData); 
this.availableQtyMap.set(this.ledgerRecords[i].BatchNo,consignmentStockData.availableQty);
}
console.log('recordtodisplay--->'+this.recordtodisplay);
 })
    .catch(error => {
    });

}
calculateAvailableQty()
{
  for(let i=0;i<this.recordtodisplay.length;i++)
  {
    var lote=this.recordtodisplay[i].lote;
    var qtySold=this.recordtodisplay[i].quantitySold;
    qtySold=qtySold.toString();
if(qtySold.indexOf(",")!=-1)
{
  qtySold =qtySold.replace(",",".");
 
}
qtySold=parseFloat(qtySold);
    let availableQty=this.recordtodisplay[i].availableQty-qtySold;
 
    this.availableQtyMap.set(lote,availableQty);
    this.recordtodisplay[i].availableQty=availableQty;
  }
  console.log('availableQty--->'+this.availableQtyMap);
}
retreivePaymentTerm()
{
  var map=new Map();
  retrievePaymentMethod({
    })
    .then(result => {
    console.log('retrieveResult----->'+JSON.stringify(result));
  
    for (let key in result) {
      map.set(key, result[key]);
      var item={
        label: key,
        value: key
      };
      this.paymentTermMap.push(item);
    }
    this.paymentTermResult=map;
  })
    
  
     
  
    
    .catch(error => {
    });
}


//Added By Ishu on submit the Declaration show success/error toast message and refresh the screen
onSubmit(event)
{this.isSpinner=true;
updateStatusOfConsignment({
distributorId:this.distributor
})
.then(result => {
  this.isSpinner=false;
  console.log('result==>'+JSON.stringify(result));
  this.title = 'Success';
  this.msg = result;
  this.variant = 'Success';
  this.toastMessage();
  eval("$A.get('e.force:refreshView').fire();");
  
}).catch(error => {
  
  this.title = 'Error';
  this.msg = result;
  this.variant = 'Error';
  this.toastMessage();
  
});

}

draftDeclaration(event)
{
  this.showDeclarationData(this.distributor);
 
}
async deleteDeclaration(event)
{
  var currentid=event.currentTarget.id.split('-');
  currentid=currentid[0];
  const result = await LightningConfirm.open({
    message: 'Are you sure you want to delete consignment?',
    variant: 'header',
    label: 'Please Confirm',
    theme: 'error',
});
if(result==true){
   
 this.isSpinner=true;
  deleteConsignmentStock({
  distributorId:this.distributor,lpNo:currentid
  })
  .then(result => {
    if(result.Result=='Success')
    {
      this.title = result.Result;
      this.msg = result.toastMsg;
      this.variant = result.Result;
      this.toastMessage();
      this.showDeclarationData(this.distributor);
      this.prepareLedgerRecordList();
      this.isSpinner=false;
    //  this.calculateAvailableQtyAfterDelete();
    }
    else{
    this.isSpinner=false;
      throw new Error(result.toastMsg);
    }
    
    
    
  }).catch(error => {
    
    this.title = 'Error';
    this.msg = error.message;
    this.variant = 'Error';
    this.toastMessage();
    this.isSpinner=false;
    
  });
}
else{
  this.isSpinner=false;
}
  
}
backButton()
{
  this.prepareLedgerRecordList();
  this.isEdit=false;
  this.fileName='';
  
this.showdeclaration=false;
this.declarationRequired=true;
this.LPNumberValue='';
this.PaymentTermValue='';
this.value='';
this.exchangerateValue='';
this.selectedoptionARG=false;
this.paymentMethodValue='';
var inputs = this.template.querySelector("lightning-input.declareSoldProduct");
inputs.checked=true;

}

calculateAvailableQtyAfterDelete()
{
  for(let i=0;i<this.recordtodisplay.length;i++)
  {
    var lote=this.recordtodisplay[i].lote;
    var qtySold=this.recordtodisplay[i].quantitySold;
    qtySold=qtySold.toString();
if(qtySold.indexOf(",")!=-1)
{
  qtySold =qtySold.replace(",",".");
 
}
qtySold=parseFloat(qtySold);
    let availableQty=this.recordtodisplay[i].availableQty;
 
    this.availableQtyMap.set(lote,availableQty);
    this.recordtodisplay[i].availableQty=availableQty;
  }
  console.log('availableQty--->'+this.availableQtyMap);
}
handleKeyUp(event) {
  var TotalQty=event.target.value;
  const lastIndex = (event.currentTarget.id).lastIndexOf('-');
var rowId  = (event.currentTarget.id).slice(0, lastIndex);
let datasetId=event.currentTarget.dataset.id;
var list=this.ConsignmentStockListwithItems.get(rowId);
var skuGridId = event.currentTarget.name;
  if(TotalQty%list.multipleOf!=0)
  {
    this.ismultipleof=false;
    this.multipleof=list.multipleOf;
  alert('Quantity should be multiple of '+this.multipleof);
  
  }
  else
  {
    this.ismultipleof=true;
  }
  
}
handlePaymenttermoptions(paymentMethodValue)
{
  var paymentTermOption=this.paymentTermResult.get( paymentMethodValue);
  for(let i=0;i<paymentTermOption.length;i++)
  {
    var item={
      label: paymentTermOption[i],
      value: paymentTermOption[i]
    };
    this.paymentTermOptions.push(item);
  }
}

toastMessage() {
const event = new ShowToastEvent({
  title: this.title,
  message: this.msg,
  variant: this.variant,
  mode: 'dismissable'
});
this.dispatchEvent(event);
}

}