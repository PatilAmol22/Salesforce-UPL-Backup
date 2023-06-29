import { LightningElement, wire,api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import news from '@salesforce/label/c.News';
import noticias from '@salesforce/label/c.Noticias';
import download from '@salesforce/label/c.Download';
import somerroroccured from '@salesforce/label/c.Some_error_has_occurred';
import NoDataAvailable from '@salesforce/label/c.No_Data_Available';
import Warning from '@salesforce/label/c.Warning';
import DownloadFile from '@salesforce/label/c.Download_File';
import No_Files_Available from '@salesforce/label/c.No_Files_Available';
import getNewsList from '@salesforce/apex/NewsCommunityController.getNewsList';
import contentVersionIdsList from '@salesforce/apex/NewsCommunityController.getContentVersionIds';
import getNext from '@salesforce/apex/NewsCommunityController.getNext';
import getPrevious from '@salesforce/apex/NewsCommunityController.getPrevious';
import TotalRecords from '@salesforce/apex/NewsCommunityController.TotalRecords';

export default class NewsCommunityLWC extends LightningElement {
    
    @api recordSize;
    newsList;
    error;
    visibleNews
    showSpinner=false;
    showDate=false;

    label = {
        news,
        noticias,
        download,
        somerroroccured
    };
    @wire(getNewsList)
    wirednewsList({ error, data }) {
        if (data) {
            console.log('read data');
            console.log(data);
            this.newsList = data;
            if(this.newsList[0].country=='Poland'){
                this.showDate=false;
            }else{
                this.showDate=true;
            }
            /*if(this.v_Offset>this.page_size){
                this.showNotification(Warning,NoDataAvailable,'warning');
            }*/
        } else if (error) {
            console.log('some error');
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
    updateNewsHandler(event){
        this.visibleNews=[...event.detail.records]
        console.log('records :'+event.detail.records)
    }
    changeHandler2(event){
        const det = event.detail;
        recordSize = det;
    }
    downloadfile(event){
        var nId=event.target.dataset.id;
        console.log('nId :'+ nId);
        let baseUrl = 'https://upl--upltest.my.salesforce.com/';
        this.showSpinner=true;
        contentVersionIdsList({nId:nId}).then(result => {
            console.log('result:-'+result);
            this.showSpinner=false;
            if(result==''){
                this.showNotification(DownloadFile,No_Files_Available,'Error');
            }else{
                for (let i = 0; i < result.length; i++) {
                    console.log('result[i] : '+JSON.stringify(result[i]));
                    const element = result[i];
                    console.log('element : '+element);    
                    setTimeout(function timer() {   
                        let downloadElement = document.createElement('a');
                        //downloadElement.href = baseUrl+'sfc/servlet.shepherd/version/download/'+element;
                        
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

    
    showNotification(titles,messages,variants) {
        const evt = new ShowToastEvent({
            title: titles,
            message: messages,
            variant: variants
        });
        this.dispatchEvent(evt);
    }
}