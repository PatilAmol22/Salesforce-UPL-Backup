import { LightningElement, track, wire, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import backgroundImage from '@salesforce/resourceUrl/Grz_Resourse';
import CaseFileTypeAccepted from "@salesforce/label/c.Grz_CaseFileTypeAccepted";
import getCaseDetailList from '@salesforce/apex/Grz_CaseDetailClass.getCaseDetailList';
import saveCaseComment from '@salesforce/apex/Grz_CaseDetailClass.saveCaseComment';
import contentSizePublic from '@salesforce/apex/Grz_CaseDetailClass.contentSizePublic';
import CloseCase from '@salesforce/apex/Grz_CaseDetailClass.CloseCase';
import reopenPortalCase from '@salesforce/apex/Grz_CaseDetailClass.reopenPortalCase';
import getContentDistribution from '@salesforce/apex/Grz_CaseDetailClass.getContentDistribution';
import escalatePortalCase from '@salesforce/apex/Grz_CaseDetailClass.escalatePortalCase';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import detailsLabel from '@salesforce/label/c.Grz_CaseDetails';
import ACCOUNT_NAME_FIELD from '@salesforce/schema/Case.Id';
import FORM_FACTOR from '@salesforce/client/formFactor';//Added by Akhilesh w.r.t Mobile UI


export default class Grz_CaseDetailCmp extends LightningElement {

@track objUser = {};
currentPageReference = null;
urlStateParameters = null;
urlId = null;
@track FileAccepted=[];
FileAccepted = CaseFileTypeAccepted.split(',');
@track FileTypes = CaseFileTypeAccepted;
@api vfurlid;
@track finaldata;
@track checkescalationstatus;
@track checkexternaluser;
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
@track saleOrg;
@track caseconmethod;
@track casecreateddate;
@track createdTime;
@track catesub;
@track subcategorycatesub;
@track boolVisibleforcat;
@track boolVisibleforsubcat;
@track boolVisiblefortype;
@track casemodifieddate;
@track contentDocData;
@track headerlabel;
@track openCloseCaseModal = false;
@track hideCloseCaseButton = false;
@track openEscalateCaseModal = false;
@api errorMsg='';
@track IsCloseButton = false;
@track commentVal = '';
@track reasonValue = '';
@track isSpinner = false;
@track iconData=new Map();
@track isguestUser = false;
@track disableBtn = false;
@track disableAttachBtn = false;
@track publicLinkMapData=[];
@track docMap=[];
@api recordId;
@track iscommentSubmit = false;
@track openReopenCaseModal = false;
@track openAttachmentModal = false;
@track isCaseCreatedUser = false;
@track isReopenBtnVisible = false;
@track openCommentModal = false;
@track navUrl = '/uplpartnerportal/s/casehome';

@wire(getRecord, { recordId: '$recordId', fields: [ACCOUNT_NAME_FIELD] })
record;
// using wire service getting current user data
@wire(getRecord, { recordId: USER_ID, fields: ['User.Name','User.SmallPhotoUrl'] })
userData({error, data}) {
    if(data) {
        window.console.log('data ====> '+JSON.stringify(data)); 
        let objCurrentData = data.fields;
        window.console.log('objCurrentData ====> '+JSON.stringify(objCurrentData));
        this.objUser = {
            Name : objCurrentData.Name.value,
            SmallPhotoUrl : objCurrentData.SmallPhotoUrl.value,
        }
        console.log('this.objUser.Name==>'+this.objUser.Name);
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
    if (currentPageReference) {
        //this.urlStateParameters = currentPageReference.state;      
        var urlParameters = window.location.href;
        console.log('urlParameters : ',urlParameters);
        if(!urlParameters.includes('casedetailpage?')){
            console.log('urlStateParameters--', urlParameters.split('case/'));
            var urlcaseId = urlParameters.split('case/');
            var urlIDValue = urlcaseId[1] || null;
            urlIDValue = urlIDValue.split('/');
            this.urlStateParameters = urlIDValue[0];
            console.log('this.urlStateParameters Standard : ', this.urlStateParameters);            
        }
        else{
            var urlIdcustom = currentPageReference.state;  
            console.log('urlIdcustom : ',urlIdcustom);
            this.urlStateParameters = urlIdcustom.id;
            console.log('this.urlStateParameters Custom : ',this.urlStateParameters);
        }        
        this.setParametersBasedOnUrl();
    }
}
connectedCallback(){
 //Added by Akhilesh  w.r.t Mobile resposiveness
    let url = window.location.href;
    if(url.includes("uplpartnerportalstd")){
        this.navUrl = '/uplpartnerportalstd/s/casehome';
    }
}
setParametersBasedOnUrl() {
    this.urlId = this.urlStateParameters || null;
    console.log('---this.urlId--', this.urlId);
    this.doSearch();
}


doSearch() {
    getCaseDetailList({ urlapex: this.urlId})
    .then(result => {
        console.log('result+++++ ',result);  
        this.finaldata = result.caseList;
        this.checkexternaluser = result.checkexternaluser;
        this.isReopenBtnVisible = result.isReopenBtnVisible;
        this.isCaseCreatedUser = result.isCaseCreatedUser;
        this.checkescalationstatus = result.checkescalationstatus;
        this.hideCloseCaseButton = result.hideCloseCaseButton;
        this.contentDocData = result.caseList[0].ContentDocumentLinks;
        console.log('contentDocData +++++ ',this.contentDocData);
        this.contentDocData =[];
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
        console.log('publicLinkMapData +++++ ',this.publicLinkMapData);  
    
    if(result.caseList[0].CaseComments!=undefined){
        this.feeditemdata =[];
        console.log('result.caseList[0].CaseComments +++++ ',result.caseList[0].CaseComments);
        result.caseList[0].CaseComments.forEach(item => {
            result.urlMap.map(e =>{
                this.iconData.set(e.Id,e.SmallPhotoUrl);
                })
            console.log('this.iconData aashim+++++ ',this.iconData.get(item.CreatedById));
            console.log('iconData +++++ ',this.iconData);

            var commentbody=item.CommentBody;                
            var iconMap=this.iconData;
            console.log('iconMap +++++ ',iconMap.get(item.CreatedById));
                let feed = {};
            feed = {
                Icon:iconMap.get(item.CreatedById),
                Date:this.formatDateFxn(item.CreatedDate),
                CreatedBy:item.CreatedBy.Name,
                CommentBody:commentbody
            };
            console.log('feed +++++ ',feed);
            this.feeditemdata.push(feed);  
        });
    }

    this.error = undefined;
    this.casenumhash='#'+this.finaldata[0].CaseNumber;
    this.headerlabel=detailsLabel+' - '+this.casenumhash;
    console.log('----headerlabel----' ,this.headerlabel);
    this.casesub=this.finaldata[0].Subject;
    this.casedesc=this.finaldata[0].Description;
    this.casepriority=this.finaldata[0].Priority.toUpperCase();


/*   Additional Line For India Case Module  Begins Here */    
    this.boolVisibleforcat = false;
    if(this.finaldata[0].Sub_Category__c){
        this.boolVisibleforcat = true;
        this.catesub=this.finaldata[0].catesub__c;
    }

    this.boolVisiblefortype = false;
    this.boolVisibleforsubcat = false;

    if(this.finaldata[0].Sub_Category__c){
        this.boolVisibleforsubcat = true;
        this.subcategorycatesub=this.finaldata[0].Sub_Category__c;
    }
    else if(this.finaldata[0].Type){
        this.boolVisiblefortype = true;
        this.caseType = this.finaldata[0].Type;
    }
    
    

    // console.log('this.caseType ', this.finaldata[0].Type);
    
/*            *****  End    Here  *****             */

    console.log('casepriority : ',this.casepriority);
    this.casestatus=this.finaldata[0].Status;
    
    //this.saleOrg =  this.finaldata[0].SalesOrg__r.Name;
    if(this.casestatus == 'Closed'){
        this.IsCloseButton = true;
        this.disableBtn = true;
        this.disableAttachBtn = true;
    }
    this.caseowner = this.finaldata[0].CaseOwner__c;
    if(this.finaldata[0].CaseOwner__c){                
        this.caseowner = this.caseowner.replace(';',', ');
        if(this.caseowner == 'ZSM, CROP MANAGER' || this.caseowner =='ZSM, LOGISTICS HO'){
            this.checkescalationstatus = false;
        }
    }
    var name = this.finaldata[0].Owner.LastName;
    if(null != this.finaldata[0].Owner.FirstName && this.finaldata[0].Owner.FirstName != undefined){
        name = this.finaldata[0].Owner.FirstName+' '+name;
    }
    this.createdbyname = name;
    console.log('this.createdbyname : ',this.createdbyname);
    this.caseconmethod=this.finaldata[0].Origin;
    this.casecreateddate=this.formatDateFxn(this.finaldata[0].CreatedDate);
    this.createdTime=this.finaldata[0].Created_Date_Time__c;  
    this.casemodifieddate=this.formatDateFxn(this.finaldata[0].LastModifiedDate);
    })
    .catch(error => {
    console.log('----in error----' ,error);
    this.error = error;
    this.finaldata = undefined;
    });
}

formatDateFxn(dateVal){
    // var date = new Date(dateVal);
    // const dtf = new Intl.DateTimeFormat('en', {
    //     year: 'numeric',
    //     month: 'short',
    //     day: '2-digit'
    // })
    // const [{value: mo}, , {value: da}, , {value: ye}] = dtf.formatToParts(date);
    
    // // var formattedDate = `${da}-${mo}-${ye}`;
    // var formattedDate = `${mo} ${da}, ${ye}`;

    // var month = date.getMonth()+1;//months (0-11)
    // var day = date.getDate();//day (1-31)
    // var year= date.getFullYear(); 
    // var formattedDate =  day+"-"+month+"-"+year;
    //var formattedDate =  month+" "+day+", "+year;
    //var formattedDate = $A.localizationService.formatDate(date, "yyyy MM dd");
    //return formattedDate;
    console.log('date before',dateVal);
    var d=new Date(dateVal);
    var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ];
    var day = d.getDate();
    var monthIndex = d.getMonth();
    var year = d.getFullYear();
    console.log('date after',monthNames[monthIndex]+ ' ' + day+ ', ' + year);
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

showescalatedCaseModal(){
    this.errorMsg='';
    this.openEscalateCaseModal = true;
}


showReopenCaseModal(){
    this.errorMsg='';
    this.openReopenCaseModal = true;
}

showescalatedCase(){
    this.isSpinner = true; 
    let casesid = this.urlId;
    console.log('this.casesid',casesid);
    this.caseids.push(casesid);    
    console.log('caseids', this.caseids);
    escalatePortalCase({ caseIdList: this.caseids, originOfEscalation: 'Portal'})
        .then(result => {         
        console.log('inside escalate case', result);  
        if(result != null || result != undefined){
            if(result=='CaseClosed'){
                this.checkescalationstatus = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Case cannot be escalated as this case is already closed',
                        variant: 'error',
                        mode: 'dismissable'
                    })
                );
                this.isSpinner = false;
                this.reasonValue='';
                this.IsCloseButton=true;
                this.disableBtn = true;
                this.disableAttachBtn=true;
            }
            else{
                this.checkescalationstatus = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Case Escalated',
                        variant: 'success'
                    })
                );  
            this.caseowner = result;
            }
            
        }
        else{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error In Case Escalation',
                    message: 'Case is not Escalated',
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
            this.IsCloseButton=true;
            this.disableBtn = true;
            this.disableAttachBtn=true;
        }
                
        this.isSpinner = false;   

    }).catch(error => {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error In Case Escalation',
                message: 'Case is not Escalated',
                variant: 'error',
                mode: 'dismissable'
            })
        );
        this.isSpinner = false; 
        window.console.log('Error ====> ',error);
    });
    
}

closeCommentModal(){
    this.errorMsg='';
    this.openCommentModal=false;  
    this.openCloseCaseModal = false;
    this.openEscalateCaseModal = false;
    this.openReopenCaseModal = false;
}

handleReopeningCase(){
    this.isSpinner = true; 
    let casesid = this.urlId;
    console.log('this.casesid',casesid);
    this.caseids.push(casesid);    
    console.log('caseids', this.caseids);
    reopenPortalCase({ caseIdList: this.caseids})
        .then(result => {         
        console.log('inside Reopen case : ', result);  
        if(result != null || result != undefined){
            if(result.CaseUpdateSuccess == 'Not Reopned'){                
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Case cannot be Reopened as this case is already Reopened',
                        variant: 'error',
                        mode: 'dismissable'
                    })
                );
                this.checkescalationstatus = false;
                this.isSpinner = false;
                this.reasonValue='';
                this.IsCloseButton=true;
                this.disableBtn = true;
                this.disableAttachBtn=true;
            }
            else{
                this.checkescalationstatus = result.checkescalationstatus;
                this.IsCloseButton=false;
                this.disableBtn = false;
                this.disableAttachBtn=false;
                this.casestatus = 'Reopen';
                this.caseowner = result.CaseOwner;
                this.caseowner = this.caseowner.replace(';',', ');
                if(this.caseowner == 'ZSM, CROP MANAGER' || this.caseowner =='ZSM, LOGISTICS HO'){
                    this.checkescalationstatus = false;
                }
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Case Reopened Successfully',
                        variant: 'success'
                    })
                );             
            }
            
        }
        else{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error In Case Reopening',
                    message: 'Case is not Reopened',
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
            this.checkescalationstatus = false;
            this.IsCloseButton=true;
            this.disableBtn = true;
            this.disableAttachBtn=true;
        }
                
        this.isSpinner = false;   

    }).catch(error => {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error In Case Escalation',
                message: 'Case is not Escalated',
                variant: 'error',
                mode: 'dismissable'
            })
        );
        this.isSpinner = false; 
        window.console.log('Error ====> ',error);
    });
}

addCaseCommentReopen(event){
    console.log('event : '+event.target.dataset.id);
    var checkescalateCase =  event.target.dataset.id;
    var errormessage = '';
    if(checkescalateCase == 'SubmitReopen'){
        errormessage = '*Please enter a reason for Reopening Case';
    }
    else if(checkescalateCase == 'SubmitCloseCase'){
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
        if(checkescalateCase == 'SubmitReopen'){
            this.commentVal = 'Case Reopening  Reason : '+this.commentVal;
        }
        else if(checkescalateCase == 'SubmitCloseCase'){
            this.commentVal = 'Case Closing  Reason : '+this.commentVal;
            this.openCloseCaseModal = false;
        }
        
        saveCaseComment({caseId : this.urlId,commentData:this.commentVal,sourceComment:'Reopening Case'})
        .then(result => {  
            console.log('add Case Comment result==>',result); 
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

                    if(checkescalateCase == 'SubmitReopen'){
                        this.handleReopeningCase();             //Calling Reopen Status Change Method
                    }
                    else if(checkescalateCase == 'SubmitCloseCase'){
                        this.handleCloseCase();
                    }

                    feed = {
                        Icon: this.objUser.SmallPhotoUrl,
                        Date: this.formatDateFxn(new Date()),
                        CreatedBy: commentpostedby,
                        CommentBody: this.commentVal
                    };
                    console.log('feed==>',feed);
        
                    this.feeditemdata.unshift(feed);
        
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
                        title: 'Error In Adding Reopening Reason',
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


addCaseCommentEscalate(event){
    console.log('event : '+event.target.dataset.id);
    var checkescalateCase =  event.target.dataset.id;
    var errormessage = '';
    if(checkescalateCase == 'SubmitEscalation'){
        errormessage = '*Please enter a reason for Escalating Case';
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
        this.commentVal = 'Case Escalation  Reason : '+this.commentVal;
        saveCaseComment({caseId : this.urlId,commentData:this.commentVal,sourceComment:'escalation'})
        .then(result => {  
            console.log('add Case Comment result==>',result); 
            this.isSpinner = false;
            if(result != undefined && result != null){
                if(result=='caseClosed'){
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'Case cannot be escalated and comment cannot be added as this case is already closed',
                            variant: 'error',
                            mode: 'dismissable'
                        })
                    );
                    this.commentVal='';
                    this.IsCloseButton = true;
                    this.disableBtn = true;
                    this.disableAttachBtn = true;
                }
                else if((result.toString()).includes('caseEscalated')){
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'Case cannot be escalated and comment cannot be added as this case is already escalated',
                            variant: 'error',
                            mode: 'dismissable'
                        })
                    );
                    this.commentVal='';
                    this.checkescalationstatus = false;
                    this.caseowner=result.split('caseEscalated')[1];
                }
                else{
                    this.iscommentSubmit = true;
                    if(this.feeditemdata == undefined){
                        this.feeditemdata = [];
                    }               
                    let feed = {};
                    var commentpostedby = result;

                    this.showescalatedCase();                   //Calling Escalation Method for changing Case Owner
                    
                    feed = {
                        Icon:this.objUser.SmallPhotoUrl,
                        Date:this.formatDateFxn(new Date()),
                        CreatedBy:commentpostedby,
                        CommentBody:this.commentVal
                    };
                    console.log('feed==>',feed);
        
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
            this.disableBtn = false;                         
        
        })       
        .catch(error => {
            window.console.log('Error ====> '+error);
            window.console.log('error =====> '+JSON.stringify(error));
            this.disableBtn = false;  
        });
            this.openEscalateCaseModal = false;
          
    }
    return  this.iscommentSubmit;
}



addCaseComment(event){
    console.log('event : '+event.target.dataset.id);
    var checkescalateCase =  event.target.dataset.id;
    var errormessage = '';
    if(checkescalateCase == 'SubmitEscalation'){
        errormessage = '*Please enter a reason for Escalating Case';
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
        saveCaseComment({caseId : this.urlId,commentData:this.commentVal,sourceComment:'comment'})
        .then(result => {  
            console.log('add Case Comment result==>',result); 
            this.isSpinner = false;
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
                    // if(this.objUser.Name == undefined){
                    //     commentpostedby = result;
                    // }
                    // else{
                    //     commentpostedby = this.objUser.Name;
                    // }
    
                    feed = {
                        Icon:this.objUser.SmallPhotoUrl,
                        Date:this.formatDateFxn(new Date()),
                        CreatedBy:commentpostedby,
                        CommentBody:this.commentVal
                    };
                    console.log('feed==>',feed);
        
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
        // if(checkescalateCase == 'SubmitEscalation'){
        //     this.openEscalateCaseModal = false;
        //     this.showescalatedCase();
        // }
    }
    return  this.iscommentSubmit;
        
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
            console.log('case close result==>',result);  
            this.isSpinner = false;          
            if(result.CaseUpdateSuccess == 'true'){
                this.IsCloseButton = true;
                this.casestatus='Closed';
                this.disableBtn = true;
                this.disableAttachBtn = true;
                this.isCaseCreatedUser = result.isCaseCreatedUser;
                this.isReopenBtnVisible = result.isReopenBtnVisible;
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
        // let cd = {};
        // cd={
        //     FileName:uploadedFiles[i].name,
        //     ContentVersionId : uploadedFiles[i].contentVersionId,
        //     CreatedBy:this.objUser.Name
        // }
        contentVersionList.push(uploadedFiles[i].contentVersionId);
        //this.contentDocData.unshift(cd);
    }
    console.log('contentVersionList==>',contentVersionList);
    setTimeout(() => {
    getContentDistribution({cvIdList : contentVersionList})
            .then(result => { 
                window.console.log('result upload ====> ',result);
                for(let key in result) {
                   // if (result.hasOwnProperty(key)) { 
                        this.docMap.push({value:result[key], key:key});
                   // }
                }
                console.log('this.docMap==>',this.docMap);
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