import { LightningElement, track, wire } from "lwc";
import getMonths from "@salesforce/apex/Grz_LiquidationClassNew.getMonths";
import updateSubmit from "@salesforce/apex/Grz_LiquidationClassNew.updateSubmit";
import updateOpeningInventory from "@salesforce/apex/Grz_LiquidationClassNew.updateOpeningInventory";
import updateRetailerInventory from "@salesforce/apex/Grz_LiquidationClassNew.updateRetailerInventory";
import updateDistributorInventory from "@salesforce/apex/Grz_LiquidationClassNew.updateDistributorInventory";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import { refreshApex } from '@salesforce/apex';
import getLiquidationRecord from "@salesforce/apex/Grz_LiquidationClassNew.getLiquidationRecord";
const SCROLL_TABLE_CLASS = "table-data-scroll";
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
export default class Grz_distributorliquidation extends LightningElement {
    @track testdetails;
    @track liquidationData=[];
    @track handleopening;
   @track isLoading = false;
    @track monthvalue = '';
   @track monthType;
    @track yearType;
    @track yearsdatafilter = [];
    @track yearvalue = '';
    @track activedata = [];
   @track searchKey = '';
    @track data;
    @track error;
    @track liquidationTableScroll;
    @track monthShows;
    @track ccount = 1;
    @track openingid;
    @track liquiId;
    @track submitvalue;
    @track handleliquidation;
      @track handleliquidation2;
    @track totalstock;
    @track currentopeningedit;
    @track currentliquidationedit
    @track wiredList = [];
    @track submittedvalue;
    @track setDefaultYear = true;
    @track firstRun = true;
    @track nodata;
  Headertitle = 'Liquidation';
    filterIcon = Icons + "/Grz_Resourse/Images/FilterIcon.png";
    backgroundimage = Icons + "/Grz_Resourse/Images/Carousel.jpg";

    connectedCallback() {
           this.ccount = Math.floor(Math.random() * 101)+ 1;
        
        console.log(' this.ccount===', this.ccount);
    }
         @wire(getMonths, { firstRun: '$firstRun' })
    getData(result) {
       
    
        if (result.data) {

            console.log('asdasdasdasd=1==>',result.data);
            console.log('asdasdasdasd=3==>',result.data.mapSize);
            if (result.data.mapSize > 0) {
                var conts = result.data.monthMapFinal;
                let cstCode = [];
                for (var key in conts) {
                    const option = {
                        label: key,
                        value: conts[key]
                    };
                    cstCode = [...cstCode, option];
                }
                this.monthShows = cstCode;
                this.monthvalue = result.data.currentMonth;
                 if (this.setDefaultYear) {
                    var today = new Date();

                    if ((today.getMonth() + 1) <= 3) {
                        this.yearvalue = (today.getFullYear() - 1).toString() + "-" + today.getFullYear().toString();
                    } else {
                        this.yearvalue = today.getFullYear().toString() + "-" + (today.getFullYear() + 1).toString();

                    }
                    this.setDefaultYear = false;
                   // this.passToParent();

                }
            }
        }
        else if (result.error) {
            this.error = result.error;
           // console.log('this.error',this.error);
             const event = new ShowToastEvent({
                    title: 'Liquidation Settings are missing. Please contact administrator.',
                    variant: 'Error',
                });
                this.dispatchEvent(event);
        }
    }
        
    
 
    @wire(getLiquidationRecord, { count: '$ccount', searchKey: '$searchKey', yearfilter: '$yearvalue', monthfilter: '$monthvalue'})
    getLiquidationRecord(result) {
        
           this.isLoading = true;
        this.wiredList=result;
      //  console.log('in wire method');
        console.log('rsult---', result.data)

        if (result.data) {
            if (result.data.Errormsg) {
                  this.nodata = true;
                const event = new ShowToastEvent({
                    title: result.data.Errormsg,
                    variant: 'Error',
                });
                this.dispatchEvent(event);
            }
           
            else {
                
          
                this.liquidationTableScroll = SCROLL_TABLE_CLASS;
                // console.log('  this.liquidationTableScroll---', this.liquidationTableScroll);

                var today = new Date();
                var fiscalyear;
                if ((today.getMonth() + 1) <= 3) {
                    fiscalyear = (today.getFullYear() - 1)
                } else {
                    fiscalyear = today.getFullYear()
                }
                var next = fiscalyear + 1;
                //  console.log('fiscalyear++fiscalyear+1', fiscalyear + '-' + next);
                //  console.log('result.data.yeardata', result.data.yeardata);
                //  console.log('(result.data.yeardata.toString()', (result.data.yeardata.toString()));
                if (result.data.yeardata.toString().includes(fiscalyear.toString() + '-' + (next).toString())) {
               
                    this.testdetails = result.data.productWrapList;
                    let temp = [];
                    this.testdetails.forEach(liq => {
                    
                        temp.push({
                            'BrandName': liq.BrandName,
                            'DistributorsInventory': liq.DistributorsInventory,
                            'Id': liq.Id,
                            'LiquidationEdit': liq.LiquidationEdit,
                            'LiquidationYTDmonth': liq.LiquidationYTDmonth,
                            'LiquidationYTDmonthpercentage': liq.LiquidationYTDmonthpercentage,
                            'OpeningInventory': liq.OpeningInventory,
                            'OpeninvEdit': liq.OpeninvEdit,
                            'PlanNextMonth': liq.PlanNextMonth,
                            'PlanYTDmonth': liq.PlanYTDmonth,
                            'RetailersInventory': liq.RetailersInventory,
                            'SKU_Code': liq.SKU_Code,
                            'SKU_Description': liq.SKU_Description,
                            'TotalAvailablestock': liq.TotalAvailablestock,
                            'TotalMarketInventory': liq.TotalMarketInventory,
                            'YTDSales': liq.YTDSales,
                            'openingId': liq.openingId,
                            'submitVar': liq.submitVar,
                            'distId':liq.Id+'dist',
                            'retId':liq.Id+'ret',
                        });
                                       
                    });
                    this.liquidationData = temp;
                    //   this.isLoading = false;
                    if (this.testdetails.length == 0) {
                        this.nodata = true;
                    
                        //.log('this.nodata ', this.nodata);
                    }
                    else
                        this.nodata = false;
                    if (this.testdetails.length > 0) {
                   
              
                         console.log('--',result.data.productWrapList);
                        this.currentopeningedit = result.data.productWrapList[0].OpeninvEdit;
                        this.currentliquidationedit = result.data.productWrapList[0].LiquidationEdit;
                        this.submittedvalue = result.data.productWrapList[0].submitVar;
                        console.log( ' this.submittedvalue---',this.submittedvalue);
                    }
                    this.yearsdatafilter = result.data.yeardata;
                     
                    this.activedata = [];
                    for (var i = 0; i < this.yearsdatafilter.length; i++) {
                        let acv = [];

                        acv = {
                            label: this.yearsdatafilter[i],
                            value: this.yearsdatafilter[i]
                        }
                        this.activedata = [...this.activedata, acv];
                        console.log('years--', this.activedata);
                    }
                      if (this.setDefaultYear) {
                    var today = new Date();

                    if ((today.getMonth() + 1) <= 3) {
                        this.yearvalue = (today.getFullYear() - 1).toString() + "-" + today.getFullYear().toString();
                    } else {
                        this.yearvalue = today.getFullYear().toString() + "-" + (today.getFullYear() + 1).toString();

                    }
                    this.setDefaultYear = false;
                   // this.passToParent();

                }
         
              
                    //  console.log(' this.activedata========', JSON.stringify(this.activedata));
                    //  console.log('  this.testdetails---', this.testdetails);
                    // this.isLoading = false;

                } else {
                      this.nodata = true;
                    const event = new ShowToastEvent({
                        title: 'Current fiscal year is not present in data. Please contact administrator.',
                        variant: 'Error',
                    });
                    this.dispatchEvent(event);
                }
            }
        }


        else if (result.error) {
              this.nodata = true;
            this.error = result.error;
          //   console.log('this.error',this.error);
             const event = new ShowToastEvent({
                    title: 'Liquidation Settings are missing. Please contact administrator.',
                    variant: 'Error',
                });
                this.dispatchEvent(event);
        }
        // this.passToParent();
          this.isLoading = false;
    }
      handleCellChanges(event) {
        this.firstRun = false;
        var theEvent = event || window.event;
        
        var key = theEvent.keyCode || theEvent.which;
        key = String.fromCharCode(key);
        console.log('Key cell ', key);
        // var regex = /[0-9]|\./;
          var regex = /[0-9]/;
        if (!regex.test(key)) {
            theEvent.returnValue = false;
        }
      
    }
    handleKeyChange(event) {
        this.firstRun = false;
     //   console.log('in searching-----');
        this.searchKey = event.target.value;
      //  console.log('this.searchKey', this.searchKey);
        //refreshApex(this.wiredList);
    }



    handleopeningMethod(event) {
         
           this.handleopening = event.target.value;
          console.log('123this.handleopening--',this.handleopening);
          if(this.handleopening == '' || this.handleopening == undefined || this.handleopening == null ){
              this.handleopening = 0;
              let e=event.target.id.split('-')[0];
              this.template.querySelector(`lightning-input[data-id=${e}]`).value = 0;
          }
          
        //  if (this.handleopening == '' || this.handleliquidation == '' || this.handleliquidation2 == '') {
        //      this.submittedvalue = true;
        //      const event = new ShowToastEvent({
        //            title: 'Field cannot be Empty',
        //            variant: 'Error',
        //         });
        //         this.dispatchEvent(event);
        //  }
        //  else{

        
           //  this.submittedvalue = false;
              this.firstRun = false;
        
        
        
      
        console.log('123this.handleopening--',this.handleopening);
        var str = event.target.id;
         console.log('str--',str);
        var arr = str.split("-");

    let w=this.liquidationData;
    w.forEach(liq => {
if(liq.openingId==event.target.id.split('-')[0]){
console.log('inside oi edit aashima');
liq.OpeningInventory=parseInt(event.target.value);
liq.TotalAvailablestock=parseInt(event.target.value)+parseInt(liq.YTDSales);
liq.LiquidationYTDmonth=parseInt(liq.TotalAvailablestock)-parseInt(liq.TotalMarketInventory);
 
liq.LiquidationYTDmonthpercentage=((parseInt(liq.LiquidationYTDmonth)/parseInt(liq.TotalAvailablestock))*100).toFixed(2);
    console.log('  liq.LiquidationYTDmonthpercentage--', liq.LiquidationYTDmonthpercentage);
     if (liq.LiquidationYTDmonthpercentage == 'NaN') {
                    liq.LiquidationYTDmonthpercentage = 0;
                }
}

    });
    this.liquidationData=w;
          updateOpeningInventory({ oi_id:arr[0], value: this.handleopening }).then((result) => {
            console.log('oooo', result);
            
          });
        // }  
       
       
      
         // refreshApex(this.wiredList);
    }
      handleDistributorMethod(event) {
              this.handleliquidation = event.target.value;
               if(this.handleliquidation == '' || this.handleliquidation == undefined || this.handleliquidation == null ){
              this.handleliquidation = 0;
              let e=event.target.id.split('-')[0]+'dist';
              this.template.querySelector(`lightning-input[data-id=${e}]`).value = 0;
          }
          
               console.log(' this.handleliquidation1---', this.handleliquidation);
          /*if (this.handleopening == '' || this.handleliquidation == '' || this.handleliquidation2 == '') {
             this.submittedvalue = true;
              const event = new ShowToastEvent({
                    title: 'Field cannot be Empty',
                    variant: 'Error',
                });
                this.dispatchEvent(event);
         }
         else{

          this.submittedvalue = false;*/
        this.firstRun = false;
      
        //  console.log('vvv---', event.target.name);
         // this.submitvalue = event.target.name;
         // console.log(' this.handleliquidation---', this.handleliquidation);
          var str = event.target.id;
         
          var arr = str.split("-");
          let w=this.liquidationData;
          w.forEach(liq => {
            if(liq.Id==event.target.id.split('-')[0]){
            console.log('inside disti edit aashima');
            liq.DistributorsInventory=parseInt(event.target.value);
            liq.TotalMarketInventory=parseInt(event.target.value)+parseInt(liq.RetailersInventory);
            liq.LiquidationYTDmonth=parseInt(liq.TotalAvailablestock)-parseInt(liq.TotalMarketInventory);
            
                liq.LiquidationYTDmonthpercentage = ((parseInt(liq.LiquidationYTDmonth) / parseInt(liq.TotalAvailablestock)) * 100).toFixed(2);
                console.log('  liq.LiquidationYTDmonthpercentage--', liq.LiquidationYTDmonthpercentage);
                 if (liq.LiquidationYTDmonthpercentage == 'NaN') {
                    liq.LiquidationYTDmonthpercentage = 0;
                }
            }
          });
          this.liquidationData=w;
              updateDistributorInventory({ liq_id: arr[0], value: this.handleliquidation }).then((result) => {
                 console.log('ddddd', result);
            
              
              });
        
         //}
          //refreshApex(this.wiredList);
      }
     handleRetailerMethod(event) {
           this.handleliquidation2 = event.target.value;
            console.log(' this.handleliquidation2---', this.handleliquidation2);
              if(this.handleliquidation2 == '' || this.handleliquidation2 == undefined || this.handleliquidation2 == null ){
              this.handleliquidation2 = 0;
              let e=event.target.id.split('-')[0]+'ret';
              this.template.querySelector(`lightning-input[data-id=${e}]`).value = 0;
          }
             
             /*if (this.handleopening == '' || this.handleliquidation == '' || this.handleliquidation2 == '') {
             this.submittedvalue = true;
              const event = new ShowToastEvent({
                    title: 'Field cannot be Empty',
                    variant: 'Error',
                });
                this.dispatchEvent(event);
         }
         else{*/
        this.firstRun = false;
       // this.submittedvalue = false;
       //  console.log(' this.handleliquidation2---', this.handleliquidation);
          
         this.liquiId = event.target.id;
         var str = event.target.id;
         
        var arr = str.split("-");
        let w=this.liquidationData;
          w.forEach(liq => {
            if(liq.Id==event.target.id.split('-')[0]){
            console.log('inside disti edit aashima');
            liq.RetailersInventory=parseInt(event.target.value);
            liq.TotalMarketInventory=parseInt(event.target.value)+parseInt(liq.DistributorsInventory);
            liq.LiquidationYTDmonth=parseInt(liq.TotalAvailablestock)-parseInt(liq.TotalMarketInventory);
           
                liq.LiquidationYTDmonthpercentage = ((parseInt(liq.LiquidationYTDmonth) / parseInt(liq.TotalAvailablestock)) * 100).toFixed(2);
                if (liq.LiquidationYTDmonthpercentage == 'NaN') {
                    liq.LiquidationYTDmonthpercentage = 0;
                }
             console.log('  liq.LiquidationYTDmonthpercentage--',  liq.LiquidationYTDmonthpercentage);
            }
          });
          this.liquidationData=w;
          updateRetailerInventory({ liq_id:arr[0], value: this.handleliquidation2 }).then((result) => {
           // console.log('rrrrrrrrrrrrrrr', result);
            
              
          });
       
         //}
          //refreshApex(this.wiredList);
    }
   
  
   
    submitReport(event) {
        
        
             this.firstRun = false;
       // console.log('this.currentopeningedit--',this.currentopeningedit);
        this.currentopeningedit = true;
       //  console.log('submit---this.liquiId--', this.liquiId);
        this.currentliquidationedit = true;
       // console.log('in submit this.testdetails--',this.testdetails.length);
            updateSubmit({ tmpList:  this.testdetails }).then((result) => {
              //  console.log('submit---success', result);
            
              
            });
      
    
           
       
    }
    handleMonth(event) {
          this.ccount = Math.floor(Math.random() * 101)+ 456;
        this.firstRun = false;
       // this.isLoading = true;
       
      
        this.monthvalue = event.target.value;
     
       // console.log('this.monthvalue', this.monthvalue);
        // refreshApex(this.wiredList);


    }
    handleYear(event) {
          this.ccount = Math.floor(Math.random() * 101)+ 123;
        this.firstRun = false;
        this.isLoading = true;
      
        this.yearvalue = event.detail.value;

        this.passToParent();
        var today = new Date();
       // console.log('year----', this.yearvalue);
        this.monthType = (today.getMonth() + 1).toString();
        this.yearType = (today.getFullYear()).toString();
        var fiscalyear = "";
        var selYear = this.yearvalue.substring(0, 4);

        if ((today.getMonth() + 1) <= 3) {
            fiscalyear = (today.getFullYear() - 1)
        } else {
            fiscalyear = today.getFullYear()
        }
        if (selYear == fiscalyear) {
            console.log('Matched');
            const months = [
                "January", "February",
                "March", "April", "May",
                "June", "July", "August",
                "September", "October",
                "November", "December"
            ];
            console.log(months);
            let fMonth = [];
            for (let i = 4; i <= Number(this.monthType); i++) {
                const d = new Date('"' + i + '"');
                console.log(d);
                var f;
                if (i == 9) {
                    f = { label: months[d.getMonth()], value: months[d.getMonth()].substring(0, 4) };
                }
                else {
                    f = { label: months[d.getMonth()], value: months[d.getMonth()].substring(0, 3) };
                }
                console.log(f);
                fMonth.push(f);
            }
            this.monthShows = fMonth;
        }
        else {
            this.monthShows = [
                { label: 'April', value: 'Apr' },
                { label: 'May', value: 'May' },
                { label: 'June', value: 'Jun' },
                { label: 'July', value: 'Jul' },
                { label: 'August', value: 'Aug' },
                { label: 'September', value: 'Sept' },
                { label: 'October', value: 'Oct' },
                { label: 'November', value: 'Nov' },
                { label: 'December', value: 'Dec' },
                { label: 'January', value: 'Jan' },
                { label: 'Febraury', value: 'Feb' },
                { label: 'March', value: 'Mar' }];
        }

        console.log('year----2', this.yearvalue);
        // refreshApex(this.wiredList);
    }

  

   
}