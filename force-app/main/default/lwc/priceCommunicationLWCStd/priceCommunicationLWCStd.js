import { LightningElement, wire, api,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import NoDataAvailable from '@salesforce/label/c.No_Data_Available';
import Warning from '@salesforce/label/c.Warning';
import ppcommunicationList from '@salesforce/apex/PriceCommunicationCommunityController.getppcommunicationList';
import contentVersionIdsList from '@salesforce/apex/PriceCommunicationCommunityController.getContentVersionIds'; 
import getNext from '@salesforce/apex/PriceCommunicationCommunityController.getNext';
import getPrevious from '@salesforce/apex/PriceCommunicationCommunityController.getPrevious';
import TotalRecords from '@salesforce/apex/PriceCommunicationCommunityController.TotalRecords';
import somerroroccured from '@salesforce/label/c.Some_error_has_occurred';
import pricecommunition from '@salesforce/label/c.Price_Communication';
import srno from '@salesforce/label/c.SR_No';
import description from '@salesforce/label/c.Description';
import createdDate from '@salesforce/label/c.Created_Date';
import action from '@salesforce/label/c.Action';
import downloadfile from '@salesforce/label/c.Download_File';
import FORM_FACTOR from '@salesforce/client/formFactor';//Added by Akhilesh for Mobile responsiveness
import fetchUser from '@salesforce/apex/OverDueSummaryLWC_Controller.fetchUser';//Added by Akhilesh for fetching user's country

export default class PriceCommunicationLWC extends LightningElement {
    
    @api recordSize;
    ppcommunicationList;
    error;
    visibleppcomunication
    @track showSpinner=false;
    isMobile;
    isPoland;

    label = {
        pricecommunition,
        srno,
        description,
        createdDate,
        action,
        downloadfile,
        somerroroccured
    };

    //Added By Akhilesh w.r.t U-Connect Mobile App
    connectedCallback() {        

        console.log('The device form factor is: ' + FORM_FACTOR);
        if(FORM_FACTOR == 'Large'){
            this.isMobile = false;
        }else if(FORM_FACTOR == 'Medium' || FORM_FACTOR == 'Small'){
            this.isMobile = true;
        }
        console.log('this.isMobile ' + this.isMobile);

        //For Country based fucntionality mainly to avoid download
        fetchUser().then(result => { 
            console.log('result---->',result);
               this.userAccountId=result[0].AccountId;
                if(this.userAccountId==undefined){
                    this.userAccountId='';
                }
                console.log('user Id ----->'+this.userAccountId);
                this.userCountry=result[0].Country;
                console.log('user country ---->'+ this.userCountry)
                if(this.userCountry=='Poland'){
                    this.isPoland=true;
                }
                    
        });
    }
    
    @wire(ppcommunicationList)
    wiredachievementList({ error, data }) {
        if (data) {
            console.log(data)
            this.ppcommunicationList = data; 
            /*if(this.v_Offset>this.page_size){
                //this.showNotification(ErrorMessage,NoDataAvailable,'Error');
                this.showNotification(Warning,NoDataAvailable,'warning');
            }*/
            
        } else if (error) {
            console.log(error);
            this.error = error;
        }
    }
    
    //Executes on the page load
    /*connectedCallback() {
      TotalRecords().then(result=>{
          this.v_TotalRecords = result;
      });
    }*/

    /*downloadfile(event){
        var pId=event.target.dataset.id;
        console.log('Id :'+ pId);
        let baseUrl = 'https://upl--upltest.my.salesforce.com/';
        this.showSpinner=true;
        contentVersionIdsList({pId:pId}).then(result => {
            console.log('result:-'+result);
            this.showSpinner=false;
            for (let i = 0; i < result.length; i++) {
                const element = result[i];
                setTimeout(function timer() {
                    let downloadElement = document.createElement('a');
                    downloadElement.href = baseUrl+'sfc/servlet.shepherd/version/download/'+element;
                    downloadElement.target = '_self';
                    document.body.appendChild(downloadElement);
                    downloadElement.click(); 
                }, i * 3000);
              }
        })
        .catch(error => {
            this.error = error;
        });
    }*/
    updatePPCHandler(event){
        this.visibleppcomunication=[...event.detail.records]
        console.log('records :'+event.detail.records)
    }
    changeHandler2(event){
        const det = event.detail;
        recordSize = det;
    }
    downloadfile(event){
        var nId=event.target.dataset.id;
        console.log('nId :'+ nId);
        this.showSpinner=true;
        contentVersionIdsList({nId:nId}).then(result => {
            console.log('result:-'+result);
            this.showSpinner=false;
            if(result==''){
                console.log('in if for empty result');
                this.showNotification(DownloadFile,No_Files_Available,'Error');
            }else{
                for (let i = 0; i < result.length; i++) {
                    console.log('result[i] : '+JSON.stringify(result[i]));
                    const element = result[i];
                    console.log('element : '+element);    
                    setTimeout(function timer() {   
                        let downloadElement = document.createElement('a');
                        var mediaTypeArray=['application/html','application/java-archive','application/javascript','application/msword','application/octet-stream','application/octet-stream;type=unknown','application/opx','application/pdf','application/postscript','application/rtf','application/vnd.google-apps.document','application/vnd.google-apps.drawing','application/vnd.google-apps.form','application/vnd.google-apps.presentation','application/vnd.google-apps.script','application/vnd.google-apps.spreadsheet','application/vnd.ms-excel','application/vnd.ms-excel.sheet.macroEnabled.12','application/vnd.ms-infopath','application/vnd.ms-powerpoint','application/vnd.ms-powerpoint.presentation.macroEnabled.12','application/vnd.ms-word.document.macroEnabled.12','application/vnd.oasis.opendocument.presentation','application/vnd.oasis.opendocument.spreadsheet','application/vnd.oasis.opendocument.text','application/vnd.openxmlformats-officedocument.presentationml.presentation','application/vnd.openxmlformats-officedocument.presentationml.slideshow','application/vnd.openxmlformats-officedocument.presentationml.template','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet','application/vnd.openxmlformats-officedocument.spreadsheetml.template','application/vnd.openxmlformats-officedocument.wordprocessingml.document','application/vnd.openxmlformats-officedocument.wordprocessingml.template','application/vnd.visio','application/x-gzip','application/x-java-source','application/x-javascript','application/x-shockwave-flash','application/x-sql','application/x-zip-compressed','application/xhtml+xml','application/xml','application/zip','audio/mp4','audio/mpeg','audio/x-aac','audio/x-ms-wma','audio/x-ms-wmv','audio/x-wav','image/bmp','image/gif','image/jpeg','image/png','image/svg+xml','image/tiff','image/vnd.adobe.photoshop','image/vnd.dwg','image/x-photoshop','message/rfc822','text/css','text/csv','text/html','text/plain','text/rtf','text/snote','text/stypi','text/webviewhtml','text/x-c','text/x-c++','text/xml','video/mp4','video/mpeg','video/quicktime','video/x-m4v','video/x-ms-asf','video/x-msvideo','application/vnd.ms-excel'];
                        for(let j=0;j<mediaTypeArray.length;j++){
                            const strSplit= mediaTypeArray[j].split('/');
                            if(result[i].fType==strSplit[1]){
                                console.log('mediaTypeArray[j] :'+mediaTypeArray[j]);
                                downloadElement.href = 'data:'+mediaTypeArray[j]+';base64,'+result[i].imagebase64Str;
                            }

                        }
                        
                        if(result[i].fType=='xls' || result[i].fType=='xlsx'){
                            downloadElement.href = 'data:application/vnd.ms-excel;base64,'+result[i].imagebase64Str;
                        }
                        if(result[i].fType=='doc' || result[i].fType=='docx'){
                            downloadElement.href = 'data:application/vnd.ms-word;base64,'+result[i].imagebase64Str;
                        }
                        if(result[i].fType=='jpg'){
                            downloadElement.href = 'data:data:image/jpeg;base64,'+result[i].imagebase64Str;
                        }
                        /*if(result[i].fType=='png'){
                            downloadElement.href = 'data:image/png;base64,'+result[i].imagebase64Str;
                        }else if(result[i].fType=='jpeg' || result[i].fType=='jpg'){
                            downloadElement.href = 'data:image/jpeg;base64,'+result[i].imagebase64Str;
                        }else if(result[i].fType=='gif'){
                            downloadElement.href = 'data:image/gif;base64,'+result[i].imagebase64Str;
                        }else if(result[i].fType=='pdf'){
                            downloadElement.href = 'data:application/pdf;base64,'+result[i].imagebase64Str;
                        }else if(result[i].fType=='csv'){
                            downloadElement.href = 'data:text/csv;base64,'+result[i].imagebase64Str;
                        }else if(result[i].fType=='xls'){
                            downloadElement.href = 'data:application/vnd.ms-excel;base64,'+result[i].imagebase64Str;
                        }else if(result[i].fType=='html'){
                            downloadElement.href = 'data:text/html;base64,'+result[i].imagebase64Str;
                        }else if(result[i].fType=='txt'){
                            downloadElement.href = 'data:text/plain;base64,'+result[i].imagebase64Str;
                        }else if(result[i].fType=='ttf'){
                            downloadElement.href = 'data:application/x-font-ttf;base64,'+result[i].imagebase64Str;
                        }else if(result[i].fType=='zip'){
                            downloadElement.href = 'data:application/zip;base64,'+result[i].imagebase64Str;
                        }else if(result[i].fType=='json'){
                            downloadElement.href = 'data:application/json;base64,'+result[i].imagebase64Str;
                        }*/
                        
                        downloadElement.download=result[i].title;
                        downloadElement.target = '_self';
                        
                        document.body.appendChild(downloadElement);
                        downloadElement.click(); 
                    }, i * 3000);
                  }
            }
            
        })
        .catch(error => {
            this.error = error;
        });
    }
    /*previousHandler2(){
            if(this.v_Offset<this.page_size){
                this.v_Offset=this.page_size;
            }
            getPrevious({v_Offset: this.v_Offset, v_pagesize: this.page_size}).then(result=>{
                this.v_Offset = result;
                if(this.v_Offset === 0){
                    this.template.querySelector('c-paginator-bottom').changeView('trueprevious');
                    this.template.querySelector('c-paginator-bottom').changeView('truepreviousOffsetZero');
                    this.template.querySelector('c-paginator-bottom').changeView('onFirstPage');
                    this.template.querySelector('c-paginator-bottom').changeView('onFirstPagefalseprevious');
                }else{
                    this.template.querySelector('c-paginator-bottom').changeView('trueNextOffsetZero');
                    this.template.querySelector('c-paginator-bottom').changeView('onFirstPage');
                }
            });
  }
  nextHandler2(){

      if(this.v_TotalRecords<10){
        this.showNotification(Warning,NoDataAvailable,'warning');
      }else{
        console.log('this.v_Offset 2:'+ this.v_Offset);
        console.log('this.page_size :'+ this.page_size);

        getNext({v_Offset: this.v_Offset, v_pagesize: this.page_size}).then(result=>{
            this.v_Offset = result;
            if(this.v_Offset + 10 >= this.v_TotalRecords){
                this.template.querySelector('c-paginator-bottom').changeView('truenext');
                this.template.querySelector('c-paginator-bottom').changeView('falsenext');
                this.template.querySelector('c-paginator-bottom').changeView('falseprevious');
                this.template.querySelector('c-paginator-bottom').changeView('trueprevious');
            }else{
                this.template.querySelector('c-paginator-bottom').changeView('falseprevious');
                this.template.querySelector('c-paginator-bottom').changeView('trueprevious');
            }
        });
      }
      
  }
  
  changeHandler2(event){
      const det = event.detail;
      this.page_size = det;
      console.log('this.v_Offset :'+ this.v_Offset);
     console.log('this.page_size :'+ this.page_size);
  }
  firstpagehandler(){
      this.v_Offset = 0;
      this.template.querySelector('c-paginator-bottom').changeView('truepreviousOffsetZero');
      this.template.querySelector('c-paginator-bottom').changeView('falsepreviousOffsetZero');
      this.template.querySelector('c-paginator-bottom').changeView('onFirstPage');
      this.template.querySelector('c-paginator-bottom').changeView('onFirstPagefalseprevious');
  }
  lastpagehandler(){
      this.v_Offset = this.v_TotalRecords - (this.v_TotalRecords)%(this.page_size);
      if(this.v_Offset==this.v_TotalRecords){
        this.template.querySelector('c-paginator-bottom').changeView('falseprevious');
        this.template.querySelector('c-paginator-bottom').changeView('truenext');
        this.template.querySelector('c-paginator-bottom').changeView('trueprevious');
        this.template.querySelector('c-paginator-bottom').changeView('falsenext');
      }
      
  }*/

  showNotification(titles,messages,variants) {
    const evt = new ShowToastEvent({
        title: titles,
        message: messages,
        variant: variants
    });
    this.dispatchEvent(evt);
}
}