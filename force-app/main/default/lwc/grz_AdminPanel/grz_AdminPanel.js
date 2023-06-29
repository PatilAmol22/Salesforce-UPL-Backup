import { LightningElement,track,wire,api } from 'lwc';
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
//import GetResponse from "@salesforce/apex/Grz_AdminPanel.GetResponse";
import GetSbu from "@salesforce/apex/Grz_AdminPanel.GetSbu";
import GetPriceBook from "@salesforce/apex/Grz_AdminPanel.GetPriceBook";
import HeaderDet from "@salesforce/apex/Grz_AdminPanel.HeaderDet";
import SendMail from "@salesforce/apex/Grz_AdminPanelVfController.SendMail";
//import DownloadPdf from "@salesforce/apex/Grz_AdminPanel.DownloadPdf";
//import EnterEntry from "@salesforce/apex/Grz_AdminPanel.EnterEntry";
//import EnterMailEntry from "@salesforce/apex/Grz_AdminPanel.EnterMailEntry";
import { refreshApex } from '@salesforce/apex';
//import EnterEntryDownload from "@salesforce/apex/Grz_AdminPanel.EnterEntryDownload";
//import SendMailWithCustomLink from "@salesforce/apex/AdminPanelStatementDownloadController.SendMailWithCustomLink";

import AdminPaneInfo from "@salesforce/apex/Grz_AdminPanel.AdminPaneInfo";
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

export default class Grz_AdminPanel extends LightningElement {
downloadIcon = Icons + "/Grz_Resourse/Images/DownloadIcon.png";
backgroundimage = Icons + "/Grz_Resourse/Images/Carousel.jpg";

  @api SalesOrgCompanyCode;
  @track SalesOrgCompanyCodeArray =[];
  @track DistEmails = [];
  @track fiscalYear ;
  @track fiscalyearStartDate;
  @track fiscalyearEndDate;
  @track endDate;
  @track startDate;
  @track StartDateFiscalYear;
  @track ledgerURL;
  @track PdfDownloadURL;
  @track AdminPanelInfo;
  loaded = false;
  loaded1 = false;

  SbuRes=[];
  sbuKey = [];
  sbuValue = [];
  @track Sbu = [];
  @track combinedData;
  @track  values =  [];
  @track SelectedZones;
  @track SelectedSbu;
  @track wiredAdminPanelInfo;
  @track cir1;
  @track cir2;
  @track CirularForEmail;


  @track pagenumber = 1;
  @track recordstart = 0;
  @track recordend = 0;
  @track totalpages = 1;
  @track totalrecords = 0;
  @track pagesize = 5;

  CustomerType =[
        { label: 'Distributor', value: 'Distributor' },
        { label: 'Super Distributor', value: 'SuperDistributor' },
    ];
    @track SelectedCustomerType;

  @wire(AdminPaneInfo, {
    pageNumber: '$pagenumber', pageSize: '$pagesize'
})
    ShowData(result){
      this.wiredAdminPanelInfo = result;
      if (result.data) {
        console.log(result);
        this.AdminPanelInfo = result.data.AdminPanelRecs;
       console.log('this.AdminPanelInfo',this.AdminPanelInfo);

       this.totalrecords = result.data.totalRecords;
      // this.brazilflag = result.data.brazilFlag;
      this.recordstart = result.data.RecordStart;
      this.recordend = result.data.RecordEnd;
      this.totalpages = Math.ceil(this.totalrecords/this.pagesize);
      this.generatePageList(this.pagenumber,this.totalpages);

      } 
    }
      

  connectedCallback() {
    if(this.SalesOrgCompanyCode != undefined){
      this.SalesOrgCompanyCodeArray = this.SalesOrgCompanyCode.split(',');
  }
    var today = new Date();
    this.endDate = today.toISOString();
    console.log(today.toISOString());
    var last30days = new Date(today.setDate(today.getDate() - 30));
    console.log("Last 30th day: " + last30days.toISOString());
    this.startDate = last30days.toISOString();

    if((new Date(this.startDate).getMonth() + 1) <= 3) {
      this.StartDateFiscalYear = (new Date(this.startDate).getFullYear() - 1)+'-04-01';
     } else {
      this.StartDateFiscalYear = new Date(this.startDate).getFullYear()+'-04-01';
     }
     
    GetSbu({SalesOrg : this.SalesOrgCompanyCodeArray}).then((result) => {
      this.SbuRes = result.Sbus;
      this.fiscalYear = result.FiscalYear;
  
      this.fiscalyearStartDate = this.fiscalYear - 1 + "-01-01";
      this.fiscalyearEndDate = this.fiscalYear + 1 + "-12-31";
      
      for(var key in this.SbuRes){
        this.sbuKey.push(key);
        this.sbuValue.push(this.SbuRes[key]);
        }
    
        let SbuKeyValue = [];
        for (let i = 0; i < this.sbuKey.length; i++) {
        const option = {
        label:this.sbuKey[i],
        value: this.sbuKey[i]
        };
        SbuKeyValue = [...SbuKeyValue, option];
        }
        this.Sbu = SbuKeyValue;
        let allValues = [];
        for (let i = 0; i < this.sbuValue.length; i++) {
        for(let j = 0; j < this.sbuValue[i].length; j++){
        allValues.push(this.sbuValue[i][j]);
        }
        }
        this.combinedData = allValues;  
         })
  }


  handleSbu(event){
    this.SelectedZones = undefined;
    this.SelectedSbu = event.detail.value;
    let MultiPickArray = [];
    for (let i = 0; i < this.combinedData.length; i++){
      if(this.combinedData[i].SBUCode__r.Name == event.detail.value){
        MultiPickArray.push(this.combinedData[i].Name);
      }
    }
    let TemoMultiArray = [];
    for (let i = 0; i < MultiPickArray.length; i++) {
      const option = {
        label:MultiPickArray[i],
        value: MultiPickArray[i]
      };
      TemoMultiArray = [...TemoMultiArray, option];
    }
    this.values = TemoMultiArray;
  }

  HandleCustomer(event){
    
     if(event.detail.value == 'Distributor'){
       this.SelectedCustomerType = '03';
     }else{
      this.SelectedCustomerType = '49';
     }
     console.log('this.CustomerType==>>',this.SelectedCustomerType);
  }
   startdateChange(event) {
     this.startDate = event.target.value;
     console.log( this.startDate);
     console.log('check');
     if((new Date(this.startDate).getMonth() + 1) <= 3) {
      this.StartDateFiscalYear = (new Date(this.startDate).getFullYear() - 1)+'-04-01';
     } else {
      this.StartDateFiscalYear = new Date(this.startDate).getFullYear()+'-04-01';
     }

     console.log(this.StartDateFiscalYear);
     console.log('check');
    }

   enddateChange(event) {
     this.endDate = event.target.value;

   }


  handleZone(event){
    this.SelectedZones = event.detail.value;
    console.log("this.SelectedZones",this.SelectedZones);
  }

    Query(event){
      console.log('this.endDate',this.endDate);
      console.log('this.StarDate',this.startDate);
      if(this.startDate != null && this.endDate != null){
      this.cir1 = undefined;
      console.log(this.SelectedZones);
      var start = new Date(this.startDate.slice(0,10));
      var end = new Date(this.endDate);
      var startLimit = new Date((this.fiscalYear - 1).toString() + "-04-01");
      var endLimit = new Date((this.fiscalYear + 1).toString() + "-03-31");
      var StartThreeMon =  new Date(this.startDate);
      StartThreeMon.setMonth(StartThreeMon.getMonth() + 3);
      StartThreeMon.setDate(StartThreeMon.getDate() - 1);
      var threemonStart = StartThreeMon.toISOString().slice(0,10);
      var EndThreeMon =  new Date(this.endDate);
      EndThreeMon.setMonth(EndThreeMon.getMonth() - 3);
      var threemonEnd = EndThreeMon.toISOString().slice(0,10);
      }
      if(this.SelectedZones == undefined || this.SelectedCustomerType == undefined || this.startDate == null || this.endDate == null){
          const event = new ShowToastEvent({
              title: 'Required Field Missing',
              variant: 'Warning',
                });
            this.dispatchEvent(event);
      }

      else if(start < startLimit || end > endLimit )
      {
          const event = new ShowToastEvent({
              title: 'Date range should be in between current or last fiscal year',
              variant: 'Warning',
                });
            this.dispatchEvent(event);
      } else if(start < new Date(threemonEnd) || end > new Date(threemonStart)){
        const event = new ShowToastEvent({
            title: 'Duration between start date and end date should not be greater than 3 months',
            variant: 'Warning',
              });
          this.dispatchEvent(event);
      }
       else if(start > end || end < start ){
        const event = new ShowToastEvent({
          title: 'Start date should not be greater than End date',
          variant: 'Warning',
            });
        this.dispatchEvent(event);
      }
      else{
      this.loaded = true;
      console.log(this.SelectedZones);
      console.log(this.startDate.slice(0,10));
      console.log(this.endDate.slice(0,10));
      GetPriceBook({Zones : this.SelectedZones,StartDate : this.StartDateFiscalYear,EndDate : this.endDate.slice(0,10), accId: '',Month:'',year:'',isRelatedList:false,Customer:this.SelectedCustomerType,sbu:this.SelectedSbu}).then((result) => {
        console.log(result);
        console.log('this.DistEmails',result.DistributorMails);
        this.DistEmails =result.DistributorMails;
        console.log('this.DistEmails',this.DistEmails);
        console.log('result.PricesListBook',result.PricesListBook);
      // console.log(result.data);
      if(result.pricebookmaster.length <1 || result.PricesListBook.length <1){
        console.log(result);
        this.loaded = false;
        const event = new ShowToastEvent({
          title: 'No Record found',
          variant: 'Error',
          });
        this.dispatchEvent(event);
      }
      else{
        HeaderDet({Sbu : this.SelectedSbu,Zones : this.SelectedZones,StartDate : this.startDate.slice(0,10),EndDate : this.endDate.slice(0,10),CustomerNum:this.SelectedCustomerType}).then((result) =>{
          this.loaded = false;
          console.log(result);
          this.cir1 = result.Circular1;
          this.cir2 = result.Circular2;
          this.CirularForEmail = result.Circular3;
          console.log('this.CirularForEmail',this.CirularForEmail)
      });
      var repZone;
      if(this.SelectedZones.includes('&')){
        repZone = this.SelectedZones.replaceAll('&','rep_()_rep');
      }
      else{
         repZone = this.SelectedZones;
      }
      this.ledgerURL =
      "/uplpartnerportal/apex/Grz_AdminPanelStatementDownload?sbu="+
      this.SelectedSbu+
      "&SelectedZones=" +
       repZone +
      "&startDate=" +
      this.startDate.slice(0,10) +
      "&endDate=" +
      this.endDate.slice(0,10)+ 
      "&Customer="+this.SelectedCustomerType+
      "&StartDateFiscalYear="
      +this.StartDateFiscalYear;
      }
        })
        }
}



SendAsEmail(event){
  this.loaded1 = true;
  // this.ledgerURL =
  // "/uplpartnerportal/apex/Grz_AdminPanelStatementDownload?sbu="+
  // this.SelectedSbu+
  // "&SelectedZones=" +
  // this.SelectedZones +
  // "&startDate=" +
  // this.startDate.slice(0,10) +
  // "&endDate=" +
  // this.endDate.slice(0,10) +
  // "&Customer="+this.SelectedCustomerType
  // ;
  SendMail({Url : this.ledgerURL,Zones : this.SelectedZones,StartDate : this.startDate.slice(0,10),EndDate : this.endDate.slice(0,10),Sbu: this.SelectedSbu, Circular:this.cir1,CircularDetail:this.cir2,CirForMail:this.CirularForEmail,DistEmails : this.DistEmails}).then((result) => {
    console.log(result)
    this.loaded1 = false;
    const event = new ShowToastEvent({
      title: 'Email Sent Successfully',
      variant: 'Success',
      });
    this.dispatchEvent(event);
   
    refreshApex(this.wiredAdminPanelInfo);
   
     
      });
}


PdfDownloadCustom(event){
  let targetId = event.target.dataset.targetId;
  console.log(targetId);
  window.location.href ='/sfc/servlet.shepherd/document/download/'+targetId+'?operationContext=S1';
 
 }

 generatePageList = (pagenumber,totalpages) => {
  var pagenumber = parseInt(pagenumber);
  console.log('pagesnumber in generate page list ------ ',pagenumber);
  var pageList = [];
  var totalpages = this.totalpages;
  console.log('total pages in generate page list ------ ',totalpages);
  this.pagelist = [];
  if(totalpages>1){
  if(totalpages<3){
  if(pagenumber==1){
  pageList.push(1,2);
  }
  if(pagenumber==2){
  pageList.push(1,2);
  }
  }
  else{
  
  if((pagenumber+1) < totalpages && (pagenumber-1)>0){
  console.log('1st if');
  pageList.push(pagenumber-1,pagenumber,pagenumber+1);
  }
  else if(pagenumber==1 && totalpages>2){
  console.log('2st if');
  pageList.push(1,2,3);
  }
  else if((pagenumber+1) == totalpages && (pagenumber-1)>0){
  console.log('3st if');
  pageList.push(pagenumber-1,pagenumber,pagenumber+1);
  }
  else if(pagenumber == totalpages && (pagenumber-1)>0){
  console.log('4st if');
  pageList.push(pagenumber-2,pagenumber-1,pagenumber);
  }
  
  }
  }
  this.pagelist=pageList;
  console.log('pagelist in generate page list-----',this.pagelist);
  }




  handlePrevious(event){
    this.isSpinner = true;
    this.pagenumber--;
    const scrollOptions = {
    left: 0,
    top: 0,
    behavior: "smooth"
    };
    window.scrollTo(scrollOptions);
    console.log('processMe pagenumber-----'+this.pagenumber);
    }
    
    handleNext(event) {
    this.isSpinner = true;
    this.pagenumber = this.pagenumber + 1;
    const scrollOptions = {
    left: 0,
    top: 0,
    behavior: "smooth"
    };
    window.scrollTo(scrollOptions);
    console.log('processMe pagenumber-----'+this.pagenumber);
    }


    get disableFirst(){
      if(this.pagenumber==1){
      return true;
      }
      return false;
    }
      
    get disableNext(){
      if(this.pagenumber==this.totalpages || this.pagenumber>=this.totalpages){
      return true;
      }
      return false;
      }


      processMe(event){
        this.isSpinner = true;
        this.pagenumber = parseInt(event.target.name);
        const scrollOptions = {
        left: 0,
        top: 0,
        behavior: "smooth"
        };
        window.scrollTo(scrollOptions);
        console.log('processMe pagenumber-----'+this.pagenumber);
    }


    renderedCallback(){
          this.template.querySelectorAll('.testcss').forEach((but) => {
          but.style.backgroundColor = this.pagenumber===parseInt(but.dataset.id,10) ? '#F47920' : 'white';
          but.style.color = this.pagenumber === parseInt(but.dataset.id, 10) ? 'white' : 'black';
          });
          }



          handleLast(event){
            this.isSpinner = true;
            this.pagenumber=this.totalpages;
            console.log('this.totalpages----', this.totalpages);
            const scrollOptions = {
            left: 0,
            top: 0,
            behavior: "smooth"
            };
            window.scrollTo(scrollOptions);
            console.log('processMe pagenumber-----'+this.pagenumber);
      }


      handleFirst(event) {
              this.isSpinner = true;
              var pagenumber = 1;
              this.pagenumber = pagenumber;
              const scrollOptions = {
              left: 0,
              top: 0,
              behavior: "smooth"
              };
              window.scrollTo(scrollOptions);
              console.log('processMe pagenumber-----'+this.pagenumber);
              
      }

}