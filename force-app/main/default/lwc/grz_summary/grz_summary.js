import { LightningElement, track, wire, api } from 'lwc';
import { fireEvent } from 'c/pubsub';
import { refreshApex } from '@salesforce/apex';
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import { NavigationMixin } from 'lightning/navigation';
import Salesorders from '@salesforce/label/c.Grz_SalesOrder';
import getSalesOrderRecord from '@salesforce/apex/grz_OrderSummary.getSalesOrderRecord';


export default class Grz_summary extends NavigationMixin(LightningElement) {
    isScreen=false;
    @track searchKey='';
    @api recordId;
    @track detailPageLink;
    Headertitle = Salesorders;
    @track isBr = false;
    @api ordernumber;
    @track startdatesearch = this.fiscalyearStartDate;
    @track enddatesearch = this.fiscalyearEndDate;
    @track pagenumber = 1;
    @track recordstart = 0;
    @track recordend = 0;
    @track totalpages = 1;
    @track activepicklist = [];
    @track activedata = [];
    @track totalrecords = 0;
    @track brazilflag;
    @track isLoading = false;
     wiredresult;
    @track currentpagenumber=1;
    @track pagesize = 10;
    @track value = 'All';
    @track datevalue = 'CreatedDate desc';
    today = new Date();
    @track range;
    backgroundimage = Icons + "/Grz_Resourse/Images/Carousel.jpg";

    get fiscalyearStartDate() {
        return this.getFiscalYearStart()+'-04-01';
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

    get options() {
        return [
                { label: 'All', value: 'All' },
                 { label: 'Open', value: 'Open' },
                 { label: 'Not Relevant', value: 'Not Relevant' },
                { label: 'Not yet processed', value: 'Not yet processed' },
                  { label: 'Partially processed', value: 'Partially processed' },
                { label: 'Completely processed', value: 'Completely processed' },
                { label: 'Pending', value: 'Pending' },
                  { label: 'Request for Cancellation', value: 'Request for Cancellation' },
                 { label: 'Order Cancelled', value: 'Order Cancelled' },
                { label: 'Approved', value: 'Approved' },
                  { label: 'Rejected', value: 'Rejected' },
                 { label: 'Submitted', value: 'Submitted' },
                 { label: 'Draft', value: 'Draft' },
                  
                 { label: 'Cancelled', value: 'Cancelled' },
                 { label: 'Error from SAP', value: 'Error from SAP' },
               
                 
                 { label: 'Blocked', value: 'Blocked' }
        ];
        
    }
    
    get dateoptions() {
        return [
                    { label: 'Created Date - Desc', value: 'CreatedDate desc' },
                    { label: 'Created Date - Asc', value: 'CreatedDate asc' },
                    { label: 'Last Update - Asc', value: 'LastModifiedDate asc' },
                     { label: 'Last Update - Desc', value: 'LastModifiedDate desc' }, 
               ];
    }
    


    @track testdetails;
    @track data;
    @track error;
   

  
//      doSearch() {
        
//         getSalesOrderRecord({ searchKey: this.searchKey, datefilter: this.datevalue , sortby: this.value, getstartdate: this.startdatesearch , getenddate: this.enddatesearch , pageNumber : this.pagenumber, pageSize : this.pagesize })
//             .then(result => {
//                 console.log('----in final----');
                
//                 this.testdetails = result.salesWrapList;
//                 console.log('----this.testdetails----' + JSON.stringify(this.testdetails));
//                  console.log('---recordid----', this.recordId);
//             //this.pagenumber = result.pageNumber;
//             console.log('pagenumber+++++ '+JSON.stringify(this.pagenumber));
//             this.totalrecords = result.totalRecords;
//            this.recordstart = result.RecordStart;
//             this.recordend = result.RecordEnd;
//             this.totalpages = Math.ceil(this.totalrecords/this.pagesize);
//            console.log('totalrecords========',this.totalrecords);
//             console.log('pagesize========',this.pagesize);
//             console.log('total pages========',this.totalpages);
           
//            this.generatePageList(this.pagenumber,this.totalpages);
//              this.isLoading = false;
//                 this.error = undefined;
//             })
//             .catch(error => {
//                 console.log('----in error----' + error);
//                 this.error = error;
//                 this.testdetails = undefined;
//             });
//      }
       connectedCallback() {
        window.addEventListener('resize', this.myFunction);

         console.log('screen================='+screen.width);
         if(screen.width<768)this.isScreen=true;
         else this.isScreen=false; 

        // window.addEventListener('resize', this.screenFunction);
 }
 myFunction = () => {
    if(screen.width<768)this.isScreen=true; 
    else this.isScreen=false; 

    console.log('isScreen=========='+this.isScreen);
 };
     @wire(getSalesOrderRecord,{ searchKey: '$searchKey', datefilter: '$datevalue' , sortby: '$value', getstartdate: '$startdatesearch' , getenddate: '$enddatesearch' , pageNumber :'$pagenumber',pageSize :'$pagesize'})
     getSalesOrderRecord(result) {
         console.log('rsult---',result)
         this.wiredresult = result;
         
             console.log(' this.isLoading+++++ ' +  this.isLoading);
         if (result.data) {
             
             this.testdetails = result.data.salesWrapList;
             if(this.testdetails.length == 0 ){
                    this.nodata = true;
                     console.log('this.nodata ', this.nodata);
             }
             else
                 this.nodata = false;
             console.log('testdetails+++++ '+JSON.stringify(this.testdetails));
               console.log('---recordid----', this.recordId);
             //this.pagenumber = data.salesWrapList.pageNumber;
             console.log('pagenumber+++++ ' + JSON.stringify(this.pagenumber));
            
             this.totalrecords = result.data.totalRecords;
             this.brazilflag = result.data.brazilFlag;
              this.recordstart = result.data.RecordStart;
             this.recordend = result.data.RecordEnd;
             this.activepicklist = result.data.activePickListVal;
             this.activedata = [];
             let a = {
                      label :'All',
                     value : 'All'
             }
             this.activedata.push(a);
             console.log('activepicklist', this.activepicklist.length);
              for (var i = 0; i < this.activepicklist.length; i++) {
                   let acv = [];
                  if (this.activepicklist[i] != 'Completly processed') {
                       acv = {
                      label : this.activepicklist[i],
                     value : this.activepicklist[i]
                 }
                   this.activedata = [ ...this.activedata, acv ]; 
               }
            
             }
             console.log(' this.activedata========', JSON.stringify( this.activedata));
              this.totalpages = Math.ceil(this.totalrecords/this.pagesize);
             console.log('totalrecords========',this.totalrecords);
              console.log('pagesize========',this.pagesize);
              console.log('total pages========',this.totalpages);
           
             this.generatePageList(this.pagenumber,this.totalpages);
             this.isLoading = false;
             console.log('this.isLoading in wire',this.isLoading);
           
     }

             
          else if (result.error) {
              this.error = result.error;
          }
      } 

    handleChange(event) {
        this.isLoading = true;
        console.log('this.isLoading in hand change',this.isLoading);
        this.value = event.detail.value;
         this.pagenumber = 1;
        console.log('----this.value---',this.value);
     }
    handleChangeDate(event) {
        this.isLoading = true;
        console.log('this.isLoading hand chn data',this.isLoading);
        this.datevalue = event.detail.value;
         this.pagenumber = 1;
        console.log('----this.datevalue---',this.datevalue);
     }
  
    handleKeyChange(event) {
          var code = (event.keyCode ? event.keyCode : event.which);
        if (code != 13) { //'Enter' keycode
            return;
        }
        if (this.searchKey != event.target.value)
        {
            this.searchKey = event.target.value;
            this.isLoading = true;
           
            
        }
       
        if(this.searchKey==''){
             this.isLoading = false;
        }
         this.pagenumber = 1;
            console.log('this.isLoading in key chang',this.isLoading);
            
        
      
    }
    clearClick(event) {
        this.isLoading = true;
        console.log('this.isLoading in cle cli',this.isLoading);
           console.log('search====1',this.searchKey);
        this.searchKey = '';
      
        console.log('search===2', this.searchKey);
        
        
     
    }
    buttonClick() {
         if (this.searchKey != this.template.querySelector('lightning-input').value) {
        this.searchKey = this.template.querySelector('lightning-input').value;
             this.isLoading = true;
              this.pagenumber = 1;
       console.log('this.isLoading in butto',this.isLoading);
           
        }
        
        
    }
    
    startdateChange( event ) {
        this.startdatesearch = event.target.value;
        console.log('----this.startdatesearch---',this.startdatesearch);
    }

    enddateChange( event ) {
        this.enddatesearch = event.target.value;
        console.log('----this.enddatesearch---',this.enddatesearch);
    }
    
    handleFirst(event) {
         this.isLoading = true;
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

    processMe(event) {
       
        var checkpage = this.pagenumber;

        this.pagenumber = parseInt(event.target.name);
        if (this.pagenumber != checkpage) {
           this.isLoading = true;  
        }
        console.log('this.isLoading in procss',this.isLoading);
        const scrollOptions = {
            left: 0,
            top: 0,
            behavior: "smooth"
          };
        window.scrollTo(scrollOptions);
        console.log('processMe pagenumber-----'+this.pagenumber);
    }

    handleOrderDetail(event) {
        
        this.recordId = event.currentTarget.dataset.value;
      
        console.log('---recordid----', this.recordId);
       // this.detailPageLink = 'orderdetailpage?id=' + this.recordId;
        this.detailPageLink = 'sales-order/' + this.recordId;
       
      
    }

    renderedCallback(){
        this.template.querySelectorAll('.testcss').forEach((but) => {
        but.style.backgroundColor = this.pagenumber===parseInt(but.dataset.id,10) ? '#F47920' : 'white';
        but.style.color = this.pagenumber === parseInt(but.dataset.id, 10) ? 'white' : 'black';
        });
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

    handlePrevious(event) {
          this.isLoading = true;
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
          this.isLoading = true;
        this.pagenumber = this.pagenumber + 1;
         const scrollOptions = {
            left: 0,
            top: 0,
            behavior: "smooth"
          };
        window.scrollTo(scrollOptions);
        console.log('processMe pagenumber-----'+this.pagenumber);
    }

    handleLast(event) {
          this.isLoading = true;
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
}