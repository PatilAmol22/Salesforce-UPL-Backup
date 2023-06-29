import { LightningElement, wire, track, api } from "lwc";
import getTalenData from "@salesforce/apex/SideBarController.getSideBarData";
import getSurveyData from "@salesforce/apex/grz_FooterController.getSurveyData";
import sideArrow from "@salesforce/resourceUrl/arrow";
import downArrow from "@salesforce/resourceUrl/Down_pArrow";
import FORM_FACTOR from "@salesforce/client/formFactor";
import LANG from "@salesforce/i18n/lang";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import standardCSS from '@salesforce/resourceUrl/UPL_Custom_Css'; //added by Vaishanvi w.r.t mobile changes.
import { loadStyle } from 'lightning/platformResourceLoader';//added by Vaishanvi w.r.t mobile changes.

export default class Side_Bar extends LightningElement {
  @track aidata = [];
  urldata = [];
  @track language = LANG;
  @api divExpanded = false;
  @api hideDivonExpand = false;
  @api downarrow = downArrow;
  @api sidearr = sideArrow;
  @api noHover_on_moblie = false;
  @api backgroundcolor;
  @api fontcolor;
  @api hoverbackgroundcolor;
  @api hoverfontcolor;
  @api manageresponsiveClick = false;
  @api highlightParent;
  @api highlightChild;
  @api highlightParentBrazil;
  @api highlightParentMexico;
  @api highlightChildBrazil;
  @api highlightParentChile;
  @api highlightChildChile;
  @api idUnderHover;
  @track isBr = false;
  @track isCl = false;
  @track isIn = false;
  @track isMx = false;
  @track screenSize = FORM_FACTOR;
  @track isBrExternal = false;
   @track isMxExternal = false;
  @track btnEnable = false;
   @track isClExternal = false;
  @track btnEnableCl = false;
  @track surveyURL;

  @track isInExternal = false;
  @track btnEnableIn = false;
  @track highligthSurveyIn = false;
  @track surveyURLIn;
  isStdurl=false;//Added By Akhilesh

  get sideDiv1() {}
  surveyIcon = Icons + "/Grz_Resourse/Images/surveyIcon.png";
  connectedCallback(){
    console.log('In COnnected call back of talend');
    if (this.language == "pt-BR") {
      this.isBr = true;
    }
    else if(this.language == "es-MX"){
      this.isMx = true;
    }else if(this.language == "es"){
      this.isCl = true;
    } else  {
      this.isIn = true;
    }
    console.log("mexico language check---", this.language);
     console.log("mexico language check 1---", this.isMx);
     //added by Vaishnavi 
     Promise.all([
      loadStyle( this, standardCSS )
      ]).then(() => {
          console.log( 'Files loaded' );
      })
      .catch(error => {
          console.log( error.body.message );
  });

  }
  renderedCallback() {
    var heightofPage = "";
    setTimeout(() => {
      heightofPage = Math.max(
        document.body.scrollHeight,
        document.documentElement.scrollHeight,
        document.body.offsetHeight,
        document.documentElement.offsetHeight,
        document.body.clientHeight,
        document.documentElement.clientHeight
      );

      this.isRenderCallbackActionExecuted = true;

      this.template.querySelectorAll(".fulldiv").forEach((element) => {
        element.style.background = this.backgroundcolor;
        //element.style.height = heightofPage + "px";
      });      
      var i;
      this.template.querySelectorAll(".FullLabelDiv").forEach((element) => {
        element.style.color = this.fontcolor;
        var highlightParent;
        if(this.language == "pt-BR"){
          highlightParent = this.highlightParentBrazil;
        }
        else if (this.language == "es")
        {
           highlightParent = this.highlightParentChile;
        }
        else if (this.language == "es-MX")
        {
           highlightParent = this.highlightParentMexico;
        }
        else {
          highlightParent = this.highlightParent;
        }
        if (element.outerText == highlightParent ||element.text == highlightParent || element.innerText == highlightParent) {
          element.style.background = this.hoverbackgroundcolor;
        } else {
          element.style.background = this.backgroundcolor;
        }
      });

      this.template.querySelectorAll(".Label").forEach((element) => {
        element.style.color = this.fontcolor;
      });

      this.template.querySelectorAll(".LabelHover").forEach((element) => {
        element.style.background = this.hoverbackgroundcolor;
        element.style.color = this.hoverfontcolor;
      });

      /*const containerElement = this.template.querySelectorAll(
        `[data-id="Icon"]`
      );
      for (i = 0; i < containerElement.length; i++) {
        var containerClass = containerElement[i].classList;

        if (containerClass.contains("DeveloperTools")) {
          //containerElement[i].style.backgroundImage = `url('${DeveloperTools}')`;
        } else if (containerClass.contains("tld_cloud")) {
          // containerElement[i].style.backgroundImage = `url('${cloudfree}')`;
        } else {
          //containerElement[i].style.backgroundImage = `url('${icons}')`;
        }
      }*/
     
      if (
        (document.body.offsetWidth <= 1024) &&
        !this.template
          .querySelector(".test121")
          .classList.contains("backgroundBlack")
      ) {
        this.template
          .querySelector(".test121")
          .classList.add("backgroundTrans");
          if(this.language == "pt-BR" || this.language == "es"){
            this.template
            .querySelector(".test121")
            .classList.remove("fixed-br");
          } 
          this.template.querySelector('.test121').classList.remove('heightClass');
      } else {
        if(window.chrome!=undefined){
          this.template.querySelector('.test121').classList.add('heightClass');
      }
        this.template
          .querySelector(".test121")
          .classList.add("backgroundBlack");
      }
      //added by Vaishnavi 
      Promise.all([
        loadStyle( this, standardCSS )
        ]).then(() => {
            console.log( 'Files loaded' );
        })
        .catch(error => {
            console.log( error.body.message );
    });
     
    }, 1000);
  }

  @wire(getTalenData)
  wiredpcMaterials({ error, data }) {
    if (data) {
      this.aidata = data;
      console.log('Data from Sidebar Parent'+JSON.stringify(this.aidata));
      this.urldata = JSON.parse(JSON.stringify(this.aidata));

      //Addition by Akhilesh
      var windowUrl = (window.location.href).split('/s/')[0];
    if(windowUrl.includes('uplpartnerportalstd')){
        console.log('In standard portal');
        this.urldata.forEach(e=>{e.url = e.std_url;});
        this.aidata = this.urldata;
    }
      console.log('Data from Sidebar Parent'+JSON.stringify(this.aidata));
      //AK Changes ends
      // eslint-disable-next-line no-console
    } else if (error) {
      this.error = error;
    }
  }
  @wire(getSurveyData, { language: "$language" })
  getSurveyData(results) {
    if (results.data) {
      this.isBrExternal = results.data.isBrExternal;
      this.isClExternal = results.data.isClExternal;
      this.isMxExternal = results.data.isMxExternal;
      this.btnEnable = results.data.btnEnable;
      this.btnEnableCl = results.data.btnEnableCl;
      this.surveyURL = results.data.surveyURL;
       this.btnEnableMx = results.data.btnEnableMx;
      this.surveyURLMx = results.data.surveyURLMx;
      this.isInExternal = results.data.isInExternal;
      this.btnEnableIn = results.data.btnEnableIn;
      this.highligthSurveyIn = results.data.highligthSurveyIn;
      this.surveyURLIn = results.data.surveyURLIn;
      console.log("mexico 1---", this.isBrExternal);
      console.log("mexico 2---", this.btnEnableMx);
      console.log("mexico 3---", this.surveyURL);
    }
    if (results.error) {
      this.error = results.error;
    }
  }
  /*expandSideBar() {
    var arrow = this.template.querySelector(".arrow").classList;

    if (arrow.contains("arrowRotate")) {
      arrow.remove("arrowRotate");
    } else {
      arrow.add("arrowRotate");
    }

    var i;

    var expand = this.template.querySelector(".fulldiv").classList; // used to expand the parent tabs
    var parentOnExpand = this.template.querySelectorAll(".FullLabelDiv");
    var containerElem = this.template.querySelectorAll(`[data-id="Icon"]`);
    var Fulldiv = this.template.querySelector(".LightTile").classList;
    if (expand.contains("divExpand")) {
      expand.remove("divExpand");
      for (i = 0; i < parentOnExpand.length; i++) {
        parentOnExpand[i].classList.remove("sideBox");
        containerElem[i].classList.remove("sideBoxBottom");
        Fulldiv.remove("removeBorder");
      }
    } else {
      expand.add("divExpand");
      for (i = 0; i < parentOnExpand.length; i++) {
        parentOnExpand[i].classList.add("sideBox");
        containerElem[i].classList.add("sideBoxBottom");
        Fulldiv.add("removeBorder");
      }
    }

    var buttonPosition = this.template.querySelector(".buttonClass").classList;
    // eslint-disable-next-line no-console

    if (buttonPosition.contains("divExpandButton")) {
      buttonPosition.remove("divExpandButton");

      this.divExpanded = false;
      this.hideDivonExpand = false;
    } else {
      buttonPosition.add("divExpandButton");
      this.divExpanded = true;
      this.hideDivonExpand = true;
      // eslint-disable-next-line no-console
    }
  }*/
  Hover(event) {
    var id = event.currentTarget.dataset.id;

    var imageElement = event.currentTarget.firstChild;
    var sideDivHover = this.template.querySelectorAll(`[data-id="${id}"]`);
    event.currentTarget.style.background = this.hoverbackgroundcolor;
    event.currentTarget.style.color = this.hoverfontcolor;
    imageElement.classList.add("filterClass");

    this.template.querySelectorAll(".hoverUL").forEach((element) => {
      element.childNodes.forEach((childElement) => {
        var highlightChild;
        if(this.language == "pt-BR"){
          highlightChild = this.highlightChildBrazil;
        }
        else if (this.language == "es")
        {
           //highlightParent = this.highlightParentChile; // changed by vaishnavi w.r.t chile mobile app issue.
           highlightChild = this.highlightParentChile;
        }
        else {
          highlightChild = this.highlightChild;
        }
        if (highlightChild!=undefined && (childElement.outerText == highlightChild ||childElement.text == highlightChild || childElement.innerText == highlightChild)) {
          childElement.style.background = this.hoverbackgroundcolor;
        } else {
          childElement.style.background = this.backgroundcolor;
        }
      });
    });
    this.template.querySelectorAll(".FullLabelDiv").forEach((element) => {
      element.style.color = this.fontcolor;
      var highlightParent;
      if(this.language == "pt-BR"){
        highlightParent = this.highlightParentBrazil;
      }
      else if (this.language == "es")
        {
           highlightParent = this.highlightParentChile;
      }
      else if (this.language == "es-MX")
        {
           highlightParent = this.highlightParentMexico;
      }
      else {
        highlightParent = this.highlightParent;
      }
      if (element.outerText == highlightParent || element.text == highlightParent || element.innerText == highlightParent) {
        element.style.background = this.hoverbackgroundcolor;
      } else {
        element.style.background = this.backgroundcolor;
      }
    });

    var frontElement = sideDivHover[0].classList;
    //if(this.divExpanded == false){
    //var child = event.currentTarget.firstChild;
    // eslint-disable-next-line no-console

    frontElement.add("hoverWhite");
    /*if (child.classList.contains("DeveloperTools")) {
      //child.style.backgroundImage = `url('${Developer_tools_White}')`;
    } else if (child.classList.contains("tld_cloud")) {
      // child.style.backgroundImage = `url('${cloud_free_white}')`;
    }*/

    // }

    /*var scrollTopValue = this.template.querySelector(".fulldiv").scrollTop;
    var topPixel = id * 91;
    topPixel = topPixel - scrollTopValue;
    sideDivHover[1].style.top = topPixel + `px`;*/
    if(sideDivHover.length > 1){
      var sideElement = sideDivHover[1].classList;
      sideElement.add("show");
    }
  }
  HoverOut(event) {
    var id = event.currentTarget.dataset.id;
    var imageElement = event.currentTarget.firstChild;
    imageElement.classList.remove("filterClass");
    var highlightParent;
    if(this.language == "pt-BR"){
      highlightParent = this.highlightParentBrazil;
    }
    else if (this.language == "es")
        {
           highlightParent = this.highlightParentChile;
    }
    else if (this.language == "es-MX")
        {
           highlightParent = this.highlightParentMexico;
    }
    else {
      highlightParent = this.highlightParent;
    }
    if (event.currentTarget.outerText != highlightParent && event.currentTarget.text != highlightParent) {
      event.currentTarget.style.background = this.backgroundcolor;
    }
    event.currentTarget.style.color = this.fontcolor;

    // eslint-disable-next-line no-console

    var sideDivHover = this.template.querySelectorAll(`[data-id="${id}"]`);
    var frontElement = sideDivHover[0].classList;
    frontElement.remove("hoverWhite");
    var child = event.currentTarget.firstChild;
    if (child.classList.contains("DeveloperTools")) {
      // child.style.backgroundImage = `url('${DeveloperTools}')`;
    } else if (child.classList.contains("tld_cloud")) {
      //child.style.backgroundImage = `url('${cloudfree}')`;
    }
    if(sideDivHover.length > 1){
      var sideElement = sideDivHover[1].classList;
    sideElement.remove("show");
    }
  }
  HoverInChild(event) {
    event.target.style.background = this.hoverbackgroundcolor;
  }
  HoverOutChild(event) {
    var highlightChild;
    if(this.language == "pt-BR"){
      highlightChild = this.highlightChildBrazil;
    }
    else if (this.language == "es")
        {
          highlightChild = this.highlightParentChile;
    }
    else {
      highlightChild = this.highlightChild;
    }
    if (event.target.outerText != highlightChild) {
      event.target.style.background = this.backgroundcolor;
    }
    if (event.target.text != highlightChild) {
      event.target.style.background = this.backgroundcolor;
    }
  }
  sideHoveractive(event) {
    var id = event.currentTarget.dataset.id;
    var sideDivHover = this.template.querySelectorAll(`[data-id="${id}"]`);
    var sideElement = sideDivHover[1].classList;
    sideElement.add("show");
  }
  sideHoverNotactive(event) {
    var id = event.currentTarget.dataset.id;
    var sideDivHover = this.template.querySelectorAll(`[data-id="${id}"]`);
    var sideElement = sideDivHover[1].classList;
    sideElement.remove("show");
  }
  DropDownHide(event) {
    var id = event.currentTarget.dataset.id;
    var DropdownList = this.template.querySelectorAll(`[data-id="${id}"]`);
    // eslint-disable-next-line no-console
    var rotateIcon = event.currentTarget.classList;
    if (
      DropdownList[3].classList.contains("hide") &&
      rotateIcon.contains("rotate_Icon")
    ) {
      DropdownList[3].classList.remove("hide");
      rotateIcon.remove("rotate_Icon");
    } else if (
      !DropdownList[3].classList.contains("hide") &&
      !rotateIcon.contains("rotate_Icon")
    ) {
      DropdownList[3].classList.add("hide");
      rotateIcon.add("rotate_Icon");
    }
  }
  DropDownHideonexpand(event) {
    var id = event.currentTarget.dataset.id;
    var rotateIcon = event.currentTarget.classList;
    var DropdownList = this.template.querySelectorAll(`[data-id="${id}"]`);
    if (
      DropdownList[2].classList.contains("hide") &&
      rotateIcon.contains("rotate_Icon")
    ) {
      DropdownList[2].classList.remove("hide");
      rotateIcon.remove("rotate_Icon");
    } else if (
      !DropdownList[2].classList.contains("hide") &&
      !rotateIcon.contains("rotate_Icon")
    ) {
      DropdownList[2].classList.add("hide");
      rotateIcon.add("rotate_Icon");
    }
  }
  openMobileNav(event) {
    if (this.noHover_on_moblie == false) {
      this.noHover_on_moblie = true;
    } else {
      this.noHover_on_moblie = false;
    }
    if (this.noHover_on_moblie === false) {
      //document.body.style.position='fixed';
      //document.body.style.left='0px';
    }
    if (this.noHover_on_moblie === true) {
      //document.body.style.position='fixed';
      //document.body.style.left='115px';
    }

    var displayMobileNav = this.template.querySelector(".fulldiv").classList;
    // eslint-disable-next-line no-console

    var currentClass = event.currentTarget.classList;

    if (
      displayMobileNav.contains("show_side_bar") ||
      currentClass.contains("mobile_icon_on_slide")
    ) {
      displayMobileNav.remove("show_side_bar");
      currentClass.remove("mobile_icon_on_slide");
      this.template
        .querySelector(".test121")
        .classList.remove("backgroundBlack");
      this.template.querySelector(".test121").classList.add("backgroundTrans");
    } else {
      displayMobileNav.add("show_side_bar");
      currentClass.add("mobile_icon_on_slide");
      this.template
        .querySelector(".test121")
        .classList.remove("backgroundTrans");
      this.template.querySelector(".test121").classList.add("backgroundBlack");
    }
  }
  responsiveClickAction(event) {
    var eventval = event.detail;
    var isChild = event.currentTarget.dataset.value;

    var elementID = event.currentTarget.dataset.id;

    var imageElement = event.currentTarget.firstChild;
    var i;
    if (isChild) {
      if (imageElement.classList.contains("filterClass")) {
        this.HoverOut(event);
      } else {
        this.Hover(event);
      }
    }
  }
}