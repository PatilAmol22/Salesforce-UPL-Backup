import { LightningElement, track, wire } from 'lwc';
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import getArgentinaArData from '@salesforce/apex/Grz_ArgentinaAccountReceivable.getArgentinaArData';
import getArAndLedgerData from '@salesforce/apex/Grz_ArgentinaAccountReceivable.getArAndLedgerData';
import getArgentinaPDFData from '@salesforce/apex/Grz_ArgentinaAccountReceivable.getArgentinaPDFData';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import DownloadPDF from "@salesforce/label/c.Grz_DownloadPFD";
import DownloadXLS from "@salesforce/label/c.Grz_DownloadXLS";
import ArSearchLabel from "@salesforce/label/c.Grz_ArSearch";

export default class NearExpiryLeaderAccountComponent extends LightningElement {
  isSpinner = true;
  checkexternaluser=false;
  ArSearchLabel = ArSearchLabel;
  searchKeyBar;
  isDataNull = false;
  isSuccess = true;
  isSuccessArData = false;
  nodata = false;
  CustomerCode;
  CustomerName;
  City;
  customerZone;
  customerServiceExecutive;
  error;
  disableButton1;
  buttonClass1;
  buttonClass;
  isDistributorFound;
  @track data;
  @track ledgerRecords;
  errorMessage;

  @wire(getArgentinaArData, {
    executedfrom : "ArLedgerCmp"
  })
  getArgentinaArData(result) {
  if (result.data) {
            
      this.data = result.data;
      console.log('this.data : ',this.data);
      this.CustomerCode = this.data.customerCode;
      this.CustomerName = this.data.customerName;
      this.City = this.data.customerCity;
      this.isSuccessArData = this.data.isSuccess;
      this.checkexternaluser = this.data.checkexternaluser;
      this.customerZone = this.data.customerZone;
      this.customerServiceExecutive = this.data.customerServiceExecutive;
      this.isSpinner = false;
      console.log(JSON.stringify(this.data)+'isExternal============='+this.checkexternaluser);
  }else if(result.error){
      this.isSpinner = false;
      this.error = result.error;
      console.log('this.error123456789 : ',this.error);
  }
}


  onChangeSearch(event) {
    this.searchKeyBar = event.target.value;
    this.isSuccessArData=false;
    this.isDataNull=false;
    this.nodata=false;
    if(this.searchKeyBar !=''&& this.searchKeyBar !=undefined && this.searchKeyBar !=null && this.searchKeyBar.trim().length>0){
      this.disableButton1=false;
      this.buttonClass1='buttonClass1 componentNotoSansBold';
    }
    else{
      this.disableButton1=true;
      this.buttonClass1='buttonClass2 componentNotoSansBold';
      this.disableButton=true;
      this.buttonClass='buttonClass2 componentNotoSansBold';
      
    }
   
  }

  handleCustomerData(){
    this.ledgerRecords = [];
    if(this.searchKeyBar == '' || this.searchKeyBar ==null || this.searchKeyBar ==undefined){
      
      const event = new ShowToastEvent({
        title:
          "Ingrese el código de cliente",
        variant: "error"
      });
      this.dispatchEvent(event);
    }

    this.isSpinner = true;
    this.disableButton=true;
    this.buttonClass='buttonClass2 componentNotoSansBold';
    var searchval = this.searchKeyBar;
   
    if((searchval != '' && searchval != undefined)) {
      getArgentinaArData({executedfrom: this.searchKeyBar}).then((result) => {

          console.log('getArAndLedgerData result==>',result);

          this.isSuccess  = result.isSuccess;
          this.CustomerCode = result.customerCode;
          this.CustomerName = result.customerName;
          this.City = result.customerCity;
          this.customerServiceExecutive = result.customerServiceExecutive;
          this.isSuccessArData = result.isSuccess;
          this.customerZone = result.customerZone;
          this.checkexternaluser = this.data.checkexternaluser;
          this.isSuccessArData=true;
          this.isDistributorFound = result.isDistributorFound;
          if(!result.isDistributorFound){
            const event = new ShowToastEvent({
              title:"No se encontró distribuidora",
              variant: "error"
            });
            this.dispatchEvent(event);
            this.isSuccessArData=false;
          }
          if(!this.isSuccess){
            this.isSpinner = result.isSuccess;
          }
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
    this.buttonClass='buttonClass1 componentNotoSansBold';

  }


}