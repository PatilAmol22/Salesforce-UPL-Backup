import { LightningElement ,wire ,track} from 'lwc';
import getGstInformation from '@salesforce/apex/Grz_GstInformation.getGstInformation';
import getSalesAreaOptions from '@salesforce/apex/Grz_GstInformation.getSalesAreaOptions';
import backgroundImage from '@salesforce/resourceUrl/Grz_Resourse';
import detailsLabel from '@salesforce/label/c.Grz_GstDetails';
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class Grz_gstInfo extends LightningElement {
label={
        detailsLabel
    };
@track gstData;
@track bgImage = backgroundImage + '/Grz_Resourse/Images/Carousel.jpg';
@track gstTableScroll;

filterIcon = Icons + "/Grz_Resourse/Images/FilterIcon.png";
downloadIcon = Icons + "/Grz_Resourse/Images/DownloadIcon.png";


@track startDate;
@track endDate;
@track isSearching=false;
@track showDownloadBtn=false;
@track downloadUrl;
@track downloadUrlXls;
@track notValidDate=false;

@track totalSgst=0;
@track totalCgst=0;
@track totalIgst=0;
@track grandTotal=0;
@track startDateLabel;
@track endDateLabel;
@track showTotalDiv=false;
@track count=0;
connectedCallback() {
    var today = new Date();
    this.endDate = today.toISOString().split('T')[0];
    console.log(today.toISOString());
    var last30days = new Date(today.setDate(today.getDate() - 30));
    console.log("Last 30th day: " + last30days.toISOString());
    this.startDate = last30days.toISOString().split('T')[0];

    }

renderedCallback(){
    console.log('window.navigator.appCodeName==>'+window.navigator.appCodeName);
    if(window.chrome==undefined){
        this.template.querySelector('.imageCls').classList.add('removeMargin');
    }
}

startDateChange(event) {
    this.count=0;
this.startDate = event.target.value;
console.log("this.fiscalyearStartDate",this.fiscalyearStartDate);

if(this.startDate<this.fiscalyearStartDate || this.startDate>this.fiscalyearEndDate){
    this.notValidDate=true;
}
else if(this.startDate==null || this.endDate==null){
    this.notValidDate=true;
}
else{
    this.notValidDate=false;
}
}
endDateChange(event) {
    this.count=0;
this.endDate = event.target.value;
console.log("----this.enddatesearch---", this.endDate);
if(this.endDate<this.fiscalyearStartDate || this.endDate>this.fiscalyearEndDate){
    this.notValidDate=true;
}
else if(this.startDate==null || this.endDate==null){
    this.notValidDate=true;
}
else{
    this.notValidDate=false;
}
}

handleGetClick(){
    if(this.count<2){
        this.count=this.count+1;
        this.notValidDate=true;
        this.isSearching=true;
        this.gstData=[];
        this.totalSgst=0;
        this.totalCgst=0;
        this.totalIgst=0;
        this.grandTotal=0;
        this.showDownloadBtn=false;
        this.showTotalDiv=false;
        var start = new Date(this.startDate.slice(0,10));
        var end = new Date(this.endDate);
        var today=new Date();
        var StartThreeMon = new Date(this.startDate);
        StartThreeMon.setMonth(StartThreeMon.getMonth() + 3);
        StartThreeMon.setDate(StartThreeMon.getDate() - 1);
        var threemonStart = StartThreeMon.toISOString().slice(0,10);
        var EndThreeMon = new Date(this.endDate);
        EndThreeMon.setMonth(EndThreeMon.getMonth() - 3);
        
        var threemonEnd = EndThreeMon.toISOString().slice(0,10);
        if(this.companyCode==null){
            const event = new ShowToastEvent({
                title: 'Please select a sales org',
                variant: 'error',
                });
                this.dispatchEvent(event);
                this.isSearching=false;
        }
        if(start < new Date(threemonEnd) || end > new Date(threemonStart)){
            const event = new ShowToastEvent({
            title: 'Start date and end date duration must be three months or less',
            variant: 'error',
            });
            this.dispatchEvent(event);
            this.isSearching=false;
            }
            else if(start>today ||end > today){
                const event = new ShowToastEvent({
                    title: 'Start date and end date must be less than today',
                    variant: 'error',
                    });
                    this.dispatchEvent(event);
                    this.isSearching=false;
            }
            else if(start>end){
                const event = new ShowToastEvent({
                    title: 'Start date cannot be greater than end date',
                    variant: 'error',
                    });
                    this.dispatchEvent(event);
                    this.isSearching=false;
            }
    else{
        getGstInformation({
            startDate: this.startDate,
            endDate: this.endDate,
            companyCode: this.companyCode
            }).then((result) => {
                console.log('result==>',result);
                 if(result.isSuccess==false){
                    this.isSearching=false;
                const event = new ShowToastEvent({
                    title: result.msg,
                    variant: 'error',
                    });
                    setTimeout(this.handleGetClick.bind(this),1000);
                    
                    this.dispatchEvent(event);
                    
               } 
           else if (result.isSuccess==true) {
                
                console.log('result==>',JSON.stringify(result.GstInfo));
            result.GstInfo.forEach(item => {
                let gst={
                    CIN:item.CommercialInvoiceNo,
                    GIN:item.GSTInvoiceNo,
                    ID:this.formatDate(item.InvoiceDate),
                    DN:item.DeliveryNo,
                    DD:this.formatDate(item.DeliveryDate),
                    TV:item.TaxableValue,
                    TIV:item.TotalInvoiceValue,
                    SUV:item.SGST_UGSTValue,
                    CV:item.CGSTValue,
                    TGV:item.TotalGSTValue,
                    IV:item.ISTValue
                  }
                  //Change by Aashima(Grazitti) for GST total issue India Community
                  this.totalSgst+=parseFloat(item.SGST_UGSTValue.replace(',',''));
                  this.totalCgst+=parseFloat(item.CGSTValue.replace(',',''));
                  this.totalIgst+=parseFloat(item.ISTValue.replace(',',''));
                  this.grandTotal+=parseFloat(item.TotalGSTValue.replace(',',''));
    this.startDateLabel=this.formatDate(this.startDate);
    this.endDateLabel=this.formatDate(this.endDate);
                  this.gstData.push(gst);
            });
            this.totalSgst=this.formatNumber(this.totalSgst.toFixed(2));
            this.totalCgst=this.formatNumber(this.totalCgst.toFixed(2));
            this.totalIgst=this.formatNumber(this.totalIgst.toFixed(2));
            this.grandTotal=this.formatNumber(this.grandTotal.toFixed(2));
            this.gstData.shift();
            if(this.gstData.length==0){
                const event = new ShowToastEvent({
                    title: 'No records found for the selected date range',
                    variant: 'error',
                    });
                    this.dispatchEvent(event);
            }
            this.downloadUrl='/uplpartnerportal/apex/Grz_GstDetails?startDate=' +this.startDate+'&endDate='+this.endDate+'&totalSgst='+this.totalSgst+'&totalCgst='+this.totalCgst+'&totalIgst='+this.totalIgst+'&grandTotal='+this.grandTotal+'&companyCode='+this.companyCode;
            this.downloadUrlXls='/uplpartnerportal/apex/Grz_GstDetailsXls?startDate=' +this.startDate+'&endDate='+this.endDate+'&totalSgst='+this.totalSgst+'&totalCgst='+this.totalCgst+'&totalIgst='+this.totalIgst+'&grandTotal='+this.grandTotal+'&companyCode='+this.companyCode;
            }
            this.isSearching=false;
            if(this.gstData.length>0){
                this.showDownloadBtn=true;
                this.showTotalDiv=true;
            }
            this.notValidDate=false;
    });
    }
    }
    
    
}

formatNumber(val){
    var x=val.toString();
    var dec=x.split('.');
    var lastThree = dec[0].substring(dec[0].length-3);
    var otherNumbers = dec[0].substring(0,dec[0].length-3);
    var res='0.00';
    if(dec[0].length>3){
        if(otherNumbers != '')
        lastThree = ',' + lastThree;
        res = otherNumbers.replace(/\B(?=(\d{2})+(?!\d))/g, ",") + lastThree;
        res=res+'.'+dec[1];
    }
    else{
        res=x;
    }
    return res;
}

 formatDate(date) {
      if(date!='0000-00-00'){
        console.log('date before',date);
        var d=new Date(date);
       var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ];
       var day = d.getDate();
       var monthIndex = d.getMonth();
       var year = d.getFullYear();
       console.log('date after',monthNames[monthIndex]+ ' ' + day+ ',' + year);
       return monthNames[monthIndex]+ ' ' + day+ ',' + year;
     }
     else{
         return '0000-00-00';
     }
    }


    getHtmlMethod(){
        console.log('html==>'+this.template.querySelector('.finalTopClass').innerHTML);
    }

    get fiscalyearStartDate() {
        return (this.getFiscalYearStart()-1)+'-04-01';
        }
        
        get fiscalyearEndDate() {
        return (this.getFiscalYearStart()+1)+'-03-31';
        }
        
        getFiscalYearStart() {
        var fiscalyearStart = "";
        var today = new Date();
        
        if ((today.getMonth() + 1) <= 3) {
        fiscalyearStart = today.getFullYear() - 1;
        } else {
        fiscalyearStart = today.getFullYear()
        }
        console.log('-----fiscalyearStart---- '+fiscalyearStart);
        return fiscalyearStart;
        }

        companyCode=null;
        orgOptions=null;

        @wire(getSalesAreaOptions,{})
        getSalesAreaOptions(result) {
            if (result.data) {
                console.log('++++++++++++'+JSON.stringify(result));
                this.orgOptions=JSON.parse(JSON.stringify(result.data));
                console.log(this.orgOptions);
            }
   
                
             else if (result.error) {
                 this.error = result.error;
             }
         } 
         handleOrgChange(event) {
            var valueSelected = event.detail.value;
            console.log('====*********=='+valueSelected);
            this.companyCode=valueSelected;
        }
       

        
       
}