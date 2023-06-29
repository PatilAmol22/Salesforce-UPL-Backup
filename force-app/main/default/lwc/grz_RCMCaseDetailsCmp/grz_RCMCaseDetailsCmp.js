import { LightningElement, track, wire, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import backgroundImage from '@salesforce/resourceUrl/Grz_Resourse';
import CaseFileTypeAccepted from "@salesforce/label/c.Grz_CaseFileTypeAccepted";
import getCaseDetailList from '@salesforce/apex/Grz_RCMCaseDetailsComtroller.getCaseDetailList';
import saveCaseComment from '@salesforce/apex/Grz_CaseDetailClass.saveCaseComment';
import contentSizePublic from '@salesforce/apex/Grz_RCMCaseDetailsComtroller.contentSizePublic';
import CloseCase from '@salesforce/apex/Grz_RCMCaseDetailsComtroller.CloseCase';
import getContentDistribution from '@salesforce/apex/Grz_RCMCaseDetailsComtroller.getContentDistribution';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import detailsLabel from '@salesforce/label/c.Grz_CaseDetails';
import ACCOUNT_NAME_FIELD from '@salesforce/schema/Case.Id';
export default class Grz_RCMCaseDetailsCmp extends LightningElement {

@track objUser = {};
currentPageReference = null;
urlStateParameters = null;
urlId = null;
@track FileAccepted=[];
FileAccepted = CaseFileTypeAccepted.split(',');
@track FileTypes = CaseFileTypeAccepted;
@track finaldata;
@track feeditemdata;
@track data;
@track caseids = [];
@track error;
@track bgImage = backgroundImage + '/Grz_Resourse/Images/Carousel.jpg';
@track attImage = backgroundImage + '/Grz_Resourse/Images/attachmentIcon.png';
@api casenumhash;
@track casesub;
@track casedesc;
@track casepriority;
@track casestatus;
@track caseType;
@track caseowner = '';
@track createdbyname;
@track casecreateddate;
@track createdTime;
@track catesub;
@track subcategorycatesub;
@track casemodifieddate;
@track headerlabel;
@track openCloseCaseModal = false;
@track hideCloseCaseButton = false;
@api errorMsg='';
@track IsCloseButton = false;
@track commentVal = '';
@track reasonValue = '';
@track isSpinner = false;
@track iconData=new Map();
@track disableBtn = false;
@track disableAttachBtn = false;
@track publicLinkMapData=[];
@track docMap=[];
@api recordId;
@track iscommentSubmit = false;
@track openAttachmentModal = false;
@track openCommentModal = false;


@wire(getRecord, { recordId: '$recordId', fields: [ACCOUNT_NAME_FIELD] })
record;
@wire(getRecord, { recordId: USER_ID, fields: ['User.Name','User.SmallPhotoUrl'] })
userData({error, data}) {
    if(data) {
        let objCurrentData = data.fields;
        this.objUser = {
            Name : objCurrentData.Name.value,
            SmallPhotoUrl : objCurrentData.SmallPhotoUrl.value,
        }
    } 
    else if(error) {
        window.console.log('error ====> '+JSON.stringify(error))
    } 
}

constructor(){
    super();
    this.commentVal='';
    this.reasonValue='';
}

@wire(CurrentPageReference)
getStateParameters(currentPageReference) {
        var urlIdcustom = currentPageReference.state;  
        this.urlStateParameters = urlIdcustom.id;
        this.setParametersBasedOnUrl();
        console.log('this.urlStateParameters == ', this.urlStateParameters);
}

setParametersBasedOnUrl() {
    this.urlId = this.urlStateParameters || null;
    this.doSearch();
}

doSearch() {
    getCaseDetailList({ urlapex: this.urlId})
    .then(result => {
        console.log('this.urlapex == ', this.urlapex);
        this.finaldata = result.caseList;
        this.hideCloseCaseButton = result.hideCloseCaseButton;
        this.publicLinkMapData=[];
        var attachPublicList = result.attachPublicList;
        if(attachPublicList !=null){
            result.attachPublicList.forEach(item => {
                let cd = {};
                cd={
                    Filename:item.Filename,
                    Id : item.Id,
                    CreatedbyName:item.CreatedbyName,
                    publicLink:item.publicLink
                }
                this.publicLinkMapData.push(cd);
            });
        }
    if(result.caseList[0].CaseComments!=undefined){
        this.feeditemdata =[];
        result.caseList[0].CaseComments.forEach(item => {
            result.urlMap.map(e =>{
                this.iconData.set(e.Id,e.SmallPhotoUrl);
                })

            var commentbody=item.CommentBody;                
            var iconMap=this.iconData;
                let feed = {};
            feed = {
                Icon:iconMap.get(item.CreatedById),
                Date:this.formatDateFxn(item.CreatedDate),
                CreatedBy:item.CreatedBy.Name,
                CommentBody:commentbody
            };
            this.feeditemdata.push(feed); 
        });
    }

if(this.finaldata != null){
    this.error = undefined;
    this.casenumhash='#'+this.finaldata[0].CaseNumber;
    this.headerlabel=detailsLabel+' - '+this.casenumhash;
    this.casesub=this.finaldata[0].Subject;
    this.casedesc=this.finaldata[0].Description;
    this.casepriority=this.finaldata[0].Priority.toUpperCase();

    if(this.finaldata[0].Sub_Category__c){
        this.catesub=this.finaldata[0].catesub__c;
    }

    if(this.finaldata[0].Sub_Category__c){
        this.subcategorycatesub=this.finaldata[0].Sub_Category__c;
    }
    if(this.finaldata[0].Type){
        this.caseType = this.finaldata[0].Type;
    }
        this.casestatus=this.finaldata[0].Status;
        
        if(this.casestatus == 'Closed'){
            this.IsCloseButton = true;
            this.disableBtn = true;
            this.disableAttachBtn = true;
        }
        this.caseowner = this.finaldata[0].CaseOwnerName__c;
        if(this.finaldata[0].CaseOwnerName__c){                
            this.caseowner = this.caseowner.replace(';',', ');
        }
        var name = this.finaldata[0].Owner.LastName;
        if(null != this.finaldata[0].Owner.FirstName && this.finaldata[0].Owner.FirstName != undefined){
            name = this.finaldata[0].Owner.FirstName+' '+name;
        }
        this.createdbyname = name;
        this.casecreateddate=this.formatDateFxn(this.finaldata[0].CreatedDate);
        this.createdTime=this.finaldata[0].Created_Date_Time__c;  
        this.casemodifieddate=this.formatDateFxn(this.finaldata[0].LastModifiedDate);
    }
   
})
    .catch(error => {
    this.error = error;
    this.finaldata = undefined;
    });
}

formatDateFxn(dateVal){
    
    var d=new Date(dateVal);
    var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ];
    var day = d.getDate();
    var monthIndex = d.getMonth();
    var year = d.getFullYear();
    return monthNames[monthIndex]+ ' ' + day+ ', ' + year;
}


openCommentModalMethod(){
    this.errorMsg='';
    this.openCommentModal=true;
}

showCloseCase(){   
    this.errorMsg='';
    this.openCloseCaseModal = true;
}


closeCommentModal(){
    this.errorMsg='';
    this.openCommentModal=false;  
    this.openCloseCaseModal = false;
}



addCaseComment(event){
    var errormessage = '';
    
    this.disableBtn = true;
    this.iscommentSubmit = false;
    if(this.commentVal==''){
        this.errorMsg = errormessage;
    }
    else{
        this.openCommentModal=false;
        this.errorMsg='';
        this.isSpinner = true;
        console.log('caseId ', this.urlId);
        console.log('this.commentVal  ', this.commentVal);
        saveCaseComment({caseId : this.urlId,commentData:this.commentVal,sourceComment:'comment'})
        .then(result => {  
            this.isSpinner = false;
            console.log('result  ', result);
            if(result != undefined && result != null){
                if(result=='caseClosed'){
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'Comment cannot be added as this case is already closed',
                            variant: 'error',
                            mode: 'dismissable'
                        })
                    );
                    this.commentVal='';
                    this.IsCloseButton=true;
                    this.disableBtn = true;
                    this.disableAttachBtn=true;
                }
                else{
                    this.iscommentSubmit = true;
                    if(this.feeditemdata == undefined){
                        this.feeditemdata = [];
                    }               
                    let feed = {};
                    var commentpostedby = result;
                   
                    feed = {
                        Icon:this.objUser.SmallPhotoUrl,
                        Date:this.formatDateFxn(new Date()),
                        CreatedBy:commentpostedby,
                        CommentBody:this.commentVal
                    };
        
                    this.feeditemdata.unshift(feed);
        
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Comment added',
                            variant: 'success'
                        })
                    );     
                    this.disableBtn = false;   
                }
                            
            }
            else{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error In Adding Comment',
                        message: 'Your Comment is not Added',
                        variant: 'error',
                        mode: 'dismissable'
                    })
                );
                this.disableBtn = false;  
            }   
            this.commentVal='';                         
        
        })       
        .catch(error => {
            window.console.log('Error ====> '+error);
            window.console.log('error =====> '+JSON.stringify(error));
            this.disableBtn = false;  
        });
    }
    return  this.iscommentSubmit;
        
}






addCaseCommentReopen(event){
    var checkescalateCase =  event.target.dataset.id;
    var errormessage = '';
    
    if(checkescalateCase == 'SubmitCloseCase'){
        errormessage = '*Please Provide Closing Case Reason';
        this.commentVal = this.reasonValue;
    }
    else{
        errormessage = '*Please enter a Comment';
    }
    this.disableBtn = true;
    this.iscommentSubmit = false;

    if(this.commentVal==''){
        this.errorMsg = errormessage;
    }
    else{
        this.openCommentModal=false;
        this.errorMsg='';
        this.isSpinner = true;
       
        this.commentVal = 'Case Closing  Reason : '+this.commentVal;
        this.openCloseCaseModal = false;
        
        saveCaseComment({caseId : this.urlId,commentData:this.commentVal,sourceComment:'Closing Case'})
        .then(result => {  
            this.isSpinner = false;
            if(result != undefined && result != null){
                if(result=='caseClosed'){
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'Case cannot be Reopened and comment cannot be added as this case is already Reopened',
                            variant: 'error',
                            mode: 'dismissable'
                        })
                    );
                    this.commentVal='';
                    this.IsCloseButton=true;
                    this.disableBtn = true;
                    this.disableAttachBtn=true;
                }
                else{
                    this.iscommentSubmit = true;
                    if(this.feeditemdata == undefined){
                        this.feeditemdata = [];
                    }               
                    let feed = {};
                    var commentpostedby = result;
                    this.IsCloseButton=false;
                    this.disableBtn = false;
                    this.disableAttachBtn=false;  
                    

                    feed = {
                        Icon: this.objUser.SmallPhotoUrl,
                        Date: this.formatDateFxn(new Date()),
                        CreatedBy: commentpostedby,
                        CommentBody: this.commentVal
                    };
        
                    this.feeditemdata.unshift(feed);
                    this.handleCloseCase();
        
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Comment added',
                            variant: 'success'
                        })
                    );     
 
                }
                           
            }
            else{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error In Adding Closing Reason',
                        message: 'Your Comment is not Added',
                        variant: 'error',
                        mode: 'dismissable'
                    })
                );
                this.IsCloseButton=true;
                this.disableBtn = true;
                this.disableAttachBtn=true;  
            }   
            this.commentVal='';                        
        
        })       
        .catch(error => {
            window.console.log('Error ====> ',error);
            this.disableBtn = true;  
            this.IsCloseButton=true;
            this.disableAttachBtn=true; 
        });

        this.openReopenCaseModal = false;

    }
}








   
handleResonValChange(event){
    this.reasonValue = event.detail.value;
}

handleCloseCase(){
        
    if(this.reasonValue==''){
        this.errorMsg='*Please Provide Closing Case Reason';
    }
    else{
        this.openCloseCaseModal=false;
        this.isSpinner = true;
        this.errorMsg='';
        CloseCase({caseId : this.urlId, closeReason : this.reasonValue})
        .then(result => {   
            this.isSpinner = false;          
            if(result.CaseUpdateSuccess == 'true'){
                this.IsCloseButton = true;
                this.casestatus='Closed';
                this.disableBtn = true;
                this.disableAttachBtn = true;

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Case Closed',
                        variant: 'success'
                    })
                ); 
            }
            else if(result.CaseUpdateSuccess == 'falseClosed'){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Case cannot be closed as this case is already closed',
                        variant: 'error',
                        mode: 'dismissable'
                    })
                );
                this.IsCloseButton = true;
                this.casestatus='Closed';
                this.disableBtn = true;
                this.disableAttachBtn = true;
            }
            else if(result.CaseUpdateSuccess == 'false'){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error Closing Case',
                        message: 'Your Case is not Closed',
                        variant: 'error',
                        mode: 'dismissable'
                    })
                );
                
            }   

            this.reasonValue='';        
        })
        .catch(error => {
            window.console.log('Error ====> '+error);
            window.console.log('error =====> '+JSON.stringify(error));
        });
    }
}

handleCommentValChange(event) {
    this.commentVal = event.detail.value;   
}

openAttachmentModalMethod(){
    this.openAttachmentModal=true;
}
closeAttachmentModal(){
    this.openAttachmentModal=false;  
}

handleUploadFinished(event){
    const uploadedFiles = event.detail.files;
    var documentId = uploadedFiles[0].documentId;
    contentSizePublic({cid : documentId,caseId:this.urlId })
 .then(result => { 
       if(result == 'ERROR'){
        this.dispatchEvent(
            new ShowToastEvent({
                message: 'File size can\'t be greater than 200 MB',
                variant: 'Warning',
            })
        );
       }
       else if(result=='ERRORClosed'){
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: 'Attachment cannot be added as this case is closed',
                variant: 'error',
                mode: 'dismissable'
            })
        );
        this.IsCloseButton = true;
        this.casestatus='Closed';
        this.disableBtn = true;
        this.disableAttachBtn = true;
        this.openAttachmentModal=false;
       }
       else{
    var nameList;
    var contentVersionList = [];

    for(var i=0;i<uploadedFiles.length;i++){
       
        contentVersionList.push(uploadedFiles[i].contentVersionId);
    }
    setTimeout(() => {
    getContentDistribution({cvIdList : contentVersionList})
            .then(result => { 
                window.console.log('result upload ====> ',result);
                for(let key in result) {
                        this.docMap.push({value:result[key], key:key});
                }
                for(var i=0;i<uploadedFiles.length;i++){
                    var publicLinks='';
                    var userName = this.objUser.Name;

                    if(userName==undefined || userName==''){
                        userName='UPL Guest User';
                    }
                    for(var j=0;j<this.docMap.length;j++){
                        if(this.docMap[j].key==uploadedFiles[i].contentVersionId){
                            publicLinks=this.docMap[j].value;
                            let cd={};
                            cd={
                                Filename:uploadedFiles[i].name,
                                Id : uploadedFiles[i].contentVersionId,
                                CreatedbyName:userName,
                                publicLink:publicLinks
                            }
                            this.publicLinkMapData.push(cd);
                        }
                    }
                    
                }
            })
            .catch(error => {
                window.console.log('Error ====> '+error);
                window.console.log('error =====> '+JSON.stringify(error));
        });  
        this.openAttachmentModal=false;
    }, 1000);
}
})
}

downloadAttachment(event){         
    this.contentdocid = event.target.dataset.value;
    window.location.href = '/uplpartnerportal/sfc/servlet.shepherd/document/download/' + this.contentdocid + '?operationContext=S1';
    }
}