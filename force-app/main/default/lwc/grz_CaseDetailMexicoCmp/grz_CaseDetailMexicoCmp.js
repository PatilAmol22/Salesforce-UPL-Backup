import { LightningElement, track, wire, api } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import backgroundImage from "@salesforce/resourceUrl/Grz_Resourse";
import getCaseDetailList from "@salesforce/apex/Grz_CaseDetailMexico.getCaseDetailList";
import saveCaseComment from "@salesforce/apex/Grz_CaseDetailBrazilClass.saveCaseComment";
import contentSizePublic from "@salesforce/apex/Grz_CaseDetailBrazilClass.contentSizePublic";
//import CloseCase from "@salesforce/apex/Grz_CaseDetailMexico.CloseCase";
import getContentDistribution from "@salesforce/apex/Grz_CaseDetailBrazilClass.getContentDistribution";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getRecord } from "lightning/uiRecordApi";
import USER_ID from "@salesforce/user/Id";
import detailsLabel from "@salesforce/label/c.Grz_CaseDetails";
import CaseLabel from "@salesforce/label/c.Grz_Case";
import CaseNumLabel from "@salesforce/label/c.Grz_CaseNumber";
import CaseOwnerLabel from "@salesforce/label/c.Grz_CaseOwner";
import CaseCreatedDateLabel from "@salesforce/label/c.Grz_CreatedDate";
import CaseTypeLabel from "@salesforce/label/c.Grz_Issue_Type";
import ACCOUNT_NAME_FIELD from "@salesforce/schema/Case.Id";

export default class Grz_CaseDetailMexicoCmp extends LightningElement {

  @track CaseLabel = CaseLabel;  
  @track CaseNumLabel = CaseNumLabel;
  @track CaseOwnerLabel = CaseOwnerLabel;
  @track CaseCreatedDateLabel = CaseCreatedDateLabel;
  @track CaseTypeLabel = CaseTypeLabel;
  @track objUser = {};
  currentPageReference = null;
  urlStateParameters = null;
  urlId = null;
  @api vfurlid;
  @track finaldata;
  @track checkescalationstatus;
  @track checkexternaluser;
  @track feeditemdata;
  @track data;
  @track caseids = [];
  @track error;
  @track bgImage = backgroundImage + "/Grz_Resourse/Images/Carousel.jpg";
  @track attImage = backgroundImage + "/Grz_Resourse/Images/attachmentIcon.png";
  @api casenumhash;
  @track casesub;
  @track casedesc;
  @track casepriority;
  @track casestatus;
  @track caseType;
  @track caseowner = "";
  @track createdbyname;
  @track caseconmethod;
  @track casecreateddate;
  @track casemodifieddate;
  @track contentDocData;
  @track headerlabel;
  @track openCloseCaseModal = false;
  @api errorMsg = "";
  @track IsCloseButton = false;
  @track commentVal = "";
  @track reasonValue = "";
  @track isSpinner = false;
  @track iconData = new Map();
  @track disableBtn = false;
  @track disableAttachBtn = false;
  @track publicLinkMapData = [];
  @track docMap = [];
  @api recordId;
  @track openCommentModal = false;
  @track navUrl = '/uplpartnerportal/s/casehome';


  @wire(getRecord, { recordId: "$recordId", fields: [ACCOUNT_NAME_FIELD] })
  record;
  // using wire service getting current user data
  @wire(getRecord, {
    recordId: USER_ID,
    fields: ["User.Name", "User.SmallPhotoUrl"]
  })
  userData({ error, data }) {
    if (data) {
      window.console.log("data ====> ",data);
      let objCurrentData = data.fields;
      window.console.log("objCurrentData ====> ",objCurrentData);
      this.objUser = {
        Name: objCurrentData.Name.value,
        SmallPhotoUrl: objCurrentData.SmallPhotoUrl.value
      };
      console.log("this.objUser.Name==>" + this.objUser.Name);
    } else if (error) {
      window.console.log("error ====> " + JSON.stringify(error));
    }
  }
  constructor() {
    super();
    this.commentVal = "";
    this.reasonValue = "";
  }
  connectedCallback(){
    //Added by Akhilesh  w.r.t Mobile resposiveness
       let url = window.location.href;
       if(url.includes("uplpartnerportalstd")){
           this.navUrl = '/uplpartnerportalstd/s/casehome';
       }
   }
  formatDateFxn(dateVal) {
    console.log('date before',dateVal);
    var date = new Date(dateVal);
    //console.log('date after',date.toLocaleString('es-MX',{timeZone: 'America/Mexico_City'}));
    //date = date.toLocaleString('es-MX',{timeZone: 'America/Mexico_City'});
    var monthNames = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
    var day = date.getDate();
    var monthIndex = date.getMonth()+1;
    var year = date.getFullYear();
    //console.log('date after',monthNames[monthIndex]+ ' ' + day+ ', ' + year);
    //return monthNames[monthIndex]+ ' ' + day+ ', ' + year;
    return day + "/" + monthIndex + "/" + year;
  }

  @wire(CurrentPageReference)
  getStateParameters(currentPageReference) {

    if (currentPageReference) {
      //this.urlStateParameters = currentPageReference.state;
      var urlParameters = window.location.href;
      console.log("urlParameters : ", urlParameters);
      if (!urlParameters.includes("casedetailpage?")) {
        console.log("urlStateParameters--", urlParameters.split("case/"));
        var urlcaseId = urlParameters.split("case/");
        var urlIDValue = urlcaseId[1] || null;
        urlIDValue = urlIDValue.split("/");
        this.urlStateParameters = urlIDValue[0];
        console.log("this.urlStateParameters Standard : ",this.urlStateParameters);

      } else {
        var urlIdcustom = currentPageReference.state;
        console.log("urlIdcustom : ", urlIdcustom);
        this.urlStateParameters = urlIdcustom.id;
        console.log("this.urlStateParameters Custom : ",this.urlStateParameters);
      }
      this.setParametersBasedOnUrl();
    }
  }
  setParametersBasedOnUrl() {
    this.urlId = this.urlStateParameters || null;
    console.log("---this.urlId--", this.urlId);
    this.doSearch();
  }

  doSearch() {
        getCaseDetailList({ urlapex: this.urlId })
        .then((result) => {
            console.log("result+++++ ", result);
            this.finaldata = result.caseList;
            this.checkexternaluser = result.checkexternaluser;
            console.log("this.checkexternaluser+++++ ", this.checkexternaluser);
            //this.checkescalationstatus = result.checkescalationstatus;
            this.contentDocData = result.caseList[0].ContentDocumentLinks;
            console.log("contentDocData +++++ ", this.contentDocData);
            this.contentDocData = [];
            this.publicLinkMapData = [];
            var attachPublicList = result.attachPublicList;
            if (attachPublicList != null) {
                result.attachPublicList.forEach((item) => {
                    let cd = {};
                    cd = {
                        Filename: item.Filename,
                        Id: item.Id,
                        CreatedbyName: item.CreatedbyName,
                        publicLink: item.publicLink
                    };
                    this.publicLinkMapData.push(cd);
                });
            }
            console.log("publicLinkMapData +++++ ", this.publicLinkMapData);

            if (result.caseList[0].CaseComments != undefined) {
                this.feeditemdata = [];
                console.log("result.caseList[0].CaseComments +++++ ",result.caseList[0].CaseComments);
                result.caseList[0].CaseComments.forEach((item) => {
                    result.urlMap.map((e) => {
                        this.iconData.set(e.Id, e.SmallPhotoUrl);
                    });
                    console.log("this.iconData aashim+++++ ",this.iconData.get(item.CreatedById));
                    console.log("iconData +++++ ", this.iconData);
                    var commentbody = item.CommentBody;
                    var iconMap = this.iconData;
                    console.log("iconMap +++++ ", iconMap.get(item.CreatedById));
                    let feed = {};
                    feed = {
                        Icon: iconMap.get(item.CreatedById),
                        Date: this.formatDateFxn(item.CreatedDate),
                        CreatedBy: item.CreatedBy.Name,
                        CommentBody: commentbody
                    };
                    console.log("feed +++++ ", feed);
                    this.feeditemdata.push(feed);
                });
            }

            this.error = undefined;
            this.casenumhash = "#" + this.finaldata[0].CaseNumber;
            this.headerlabel = detailsLabel+" - " + this.casenumhash;
            console.log("----headerlabel----", this.headerlabel);
            this.casesub = this.finaldata[0].Subject;
            this.casedesc = this.finaldata[0].Description;
            this.casepriority = this.finaldata[0].Priority.toUpperCase();
            console.log("casepriority : ", this.casepriority);
            this.casestatus = this.finaldata[0].Status;
            this.caseType = this.finaldata[0].Type;

            if (this.casestatus == "Fechado") {
                this.IsCloseButton = true;
                this.disableBtn = true;
                this.disableAttachBtn = true;
            }
            //this.caseowner = this.finaldata[0].Owner.Name;
            this.caseowner = result.caseOwners;
            if(this.caseType == null || this.caseType ==''){
                this.caseowner = '';
            }
            this.createdbyname = this.finaldata[0].CreatedBy.Name;
            console.log("this.createdbyname : ", this.createdbyname);
            this.caseconmethod = this.finaldata[0].Origin;
            this.casecreateddate = this.formatDateFxn(this.finaldata[0].CreatedDate);
            this.casemodifieddate = this.formatDateFxn(this.finaldata[0].LastModifiedDate);
        })
      .catch((error) => {
        console.log("----in error----", error);
        this.error = error;
        this.finaldata = undefined;
      });
    }

    handleCommentValChange(event) {
        this.commentVal = event.detail.value;
    }

    openCommentModalMethod(event) {
        this.errorMsg = "";
        this.commentVal = "";
        this.openCommentModal = true;
    }
    closeCommentModal() {
        this.errorMsg = "";
        this.openCommentModal = false;
        this.openCloseCaseModal = false;
      }

    addCaseComment() {
        this.disableBtn = true;
        if (this.commentVal == "") {
          this.errorMsg = "*Por favor ingrese un comentario";
        } else {
          this.openCommentModal = false;
          this.errorMsg = "";
          this.isSpinner = true;
          saveCaseComment({ caseId: this.urlId, commentData: this.commentVal })
            .then((result) => {
              console.log("add Case Comment result==>", result);
              this.isSpinner = false;
              if (result != undefined && result != null) {
                if (this.feeditemdata == undefined) {
                  this.feeditemdata = [];
                }
                let feed = {};
                var commentpostedby = result;
                feed = {
                  Icon: this.objUser.SmallPhotoUrl,
                  Date: this.formatDateFxn(new Date()),
                  CreatedBy: commentpostedby,
                  CommentBody: this.commentVal
                };
                console.log("feed==>", feed);
    
                this.feeditemdata.unshift(feed);
    
                this.dispatchEvent(
                  new ShowToastEvent({
                    title: "Éxito",
                    message: "Comentario añadido",
                    variant: "success"
                  })
                );
                this.disableBtn = false;
              } else {
                this.dispatchEvent(
                  new ShowToastEvent({
                    title: "Error al agregar el comentario",
                    message: "Su comentario no está agregado",
                    variant: "error",
                    mode: "dismissable"
                  })
                );
                this.disableBtn = false;
              }
              this.commentVal = "";
              this.disableBtn = false;
            })
            .catch((error) => {
              this.isSpinner = false;
              window.console.log("Error ====> ",error);
              this.dispatchEvent(
                new ShowToastEvent({
                  title: "Error al agregar el comentario",
                  message: "Su comentario no está agregado",
                  variant: "error",
                  mode: "dismissable"
                })
              );
              this.disableBtn = false;
            });
        }
    }

    @track openAttachmentModal = false;

    openAttachmentModalMethod() {
      this.openAttachmentModal = true;
    }

    closeAttachmentModal() {
        this.openAttachmentModal = false;
    }
    
    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        var documentId = uploadedFiles[0].documentId;
        contentSizePublic({ cid: documentId, caseId: this.urlId }).then(
          (result) => {
            if (result == "ERROR") {
              this.dispatchEvent(
                new ShowToastEvent({
                  message: "O tamanho do arquivo não pode ser maior que 20 MB",
                  variant: "Warning"
                })
              );
            } else if (result == "ERRORClosed") {
              this.dispatchEvent(
                new ShowToastEvent({
                  title: "Error",
                  message: "O anexo não pode ser adicionado porque este caso está fechado",
                  variant: "error",
                  mode: "dismissable"
                })
              );
              this.IsCloseButton = true;
              this.casestatus = "Fechado";
              this.disableBtn = true;
              this.disableAttachBtn = true;
              this.openAttachmentModal = false;
            } else {
              var nameList;
              var contentVersionList = [];
    
              for (var i = 0; i < uploadedFiles.length; i++) {
                // let cd = {};
                // cd={
                //     FileName:uploadedFiles[i].name,
                //     ContentVersionId : uploadedFiles[i].contentVersionId,
                //     CreatedBy:this.objUser.Name
                // }
                contentVersionList.push(uploadedFiles[i].contentVersionId);
                //this.contentDocData.unshift(cd);
              }
              console.log("contentVersionList==>", contentVersionList);
              setTimeout(() => {
                getContentDistribution({ cvIdList: contentVersionList })
                  .then((result) => {
                    window.console.log("result upload ====> ", result);
                    for (let key in result) {
                      // if (result.hasOwnProperty(key)) {
                      this.docMap.push({ value: result[key], key: key });
                      // }
                    }
                    console.log("this.docMap==>", this.docMap);
                    for (var i = 0; i < uploadedFiles.length; i++) {
                      var publicLinks = "";
                      var userName = this.objUser.Name;
    
                      if (userName == undefined || userName == "") {
                        userName = "UPL Guest User";
                      }
                      for (var j = 0; j < this.docMap.length; j++) {
                        if (
                          this.docMap[j].key == uploadedFiles[i].contentVersionId
                        ) {
                          publicLinks = this.docMap[j].value;
                          let cd = {};
                          cd = {
                            Filename: uploadedFiles[i].name,
                            Id: uploadedFiles[i].contentVersionId,
                            CreatedbyName: userName,
                            publicLink: publicLinks
                          };
                          this.publicLinkMapData.push(cd);
                        }
                      }
                    }
                  })
                  .catch((error) => {
                    window.console.log("Error ====> " + error);
                    window.console.log("error =====> " + JSON.stringify(error));
                  });
                this.openAttachmentModal = false;
              }, 1000);
            }
          }
        );
    }
    
    downloadAttachment(event) {
        this.contentdocid = event.target.dataset.value;
        window.location.href =
          "/uplpartnerportal/sfc/servlet.shepherd/document/download/" +
          this.contentdocid +
          "?operationContext=S1";
    }

}