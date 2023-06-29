import { LightningElement,wire,api,track } from 'lwc';
import GetAllData from '@salesforce/apex/SalesorderUkController.getOrderFields'; 
import saveSalesOrder from '@salesforce/apex/SalesorderUkController.saveSalesOrder'; 
import labelName from '@salesforce/label/c.HeaderLabelForUKComponent';
import Confirm_UK from '@salesforce/label/c.Confirm_UK';
import Do_you_want_to_apply_for_FCA_UK from '@salesforce/label/c.Do_you_want_to_apply_for_FCA_UK';
import Order_TypeUK from '@salesforce/label/c.Order_TypeUK';
import Normal_Type_Uk from '@salesforce/label/c.Normal_Type_Uk';
import Approval_Required_UK from '@salesforce/label/c.Approval_Required_UK';
import Order_Successfully_created from '@salesforce/label/c.Order_Successfully_created';
import Order_cretion_content_UK from '@salesforce/label/c.Order_cretion_content_UK';
import Go_to_Sales_order_UK from '@salesforce/label/c.Go_to_Sales_order_UK';
import Create_New_Order_UK from '@salesforce/label/c.Create_New_Order_UK';
import Order_Updated_successfully_Uk from '@salesforce/label/c.Order_Updated_successfully_Uk';
import Refresh_Page_Uk from '@salesforce/label/c.Refresh_Page_Uk';
import Approval_History_Uk from '@salesforce/label/c.Approval_History_Uk';
import Raise_Sales_Order from '@salesforce/label/c.Raise_Sales_Order_Uk';
import Base_URL_UK from '@salesforce/label/c.Base_URL_UK';
import Save_As_Draft_UK from '@salesforce/label/c.Save_As_Draft_UK';
import Saved_As_Draft_Header_UK from '@salesforce/label/c.Saved_As_Draft_Header_UK';
import To_save_as_Draft_Uk from '@salesforce/label/c.To_save_as_Draft_Uk';
import Save_as_Draft_Header_UK from '@salesforce/label/c.Save_as_Draft_Header_UK';
import Account_Name_uk from '@salesforce/label/c.Account_Name_uk';
import Total_Credit_Limit_UK from '@salesforce/label/c.Total_Credit_Limit_UK';
import SAP_Code_UK from '@salesforce/label/c.SAP_Code_UK';
import Credit_Limit_Balanced_Uk from '@salesforce/label/c.Credit_Limit_Balanced_Uk';
import Credit_Limit_Used_UK from '@salesforce/label/c.Credit_Limit_Used_UK';
import Internal_Credit_Limit_UK from '@salesforce/label/c.Internal_Credit_Limit_UK';
import Total_outstanding_UK from '@salesforce/label/c.Total_outstanding_UK';
import Net_Overdue_UK from '@salesforce/label/c.Net_Overdue_UK';
import Edit_UK from '@salesforce/label/c.Edit_UK';
import SAP_Order_Number_UK from '@salesforce/label/c.SAP_Order_Number_UK';
import Order_Number_UK from '@salesforce/label/c.Order_Number_UK';
import ORDERSAVED_IMAGE from '@salesforce/resourceUrl/SalesorderUK_Images';
import { NavigationMixin,CurrentPageReference } from 'lightning/navigation';
import myStaticStyles from '@salesforce/resourceUrl/ModalCssUk'
import { loadStyle } from 'lightning/platformResourceLoader';
import userId from '@salesforce/user/Id';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';
import { refreshApex } from '@salesforce/apex';


const COLS = [
    { label: 'Date', fieldName:'createdDate',type:'text'},
    { label: 'Status', fieldName:'stepStatus', type:'text'},
    { label: 'User', fieldName:'originalActorName', type:'text'},
    { label: 'Approver', fieldName:'actorName', type:'text'},
];

export default class SalesOrderUKComponent_New extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectName;
    index=0;
    columns=COLS;
    backVisible = false; 
    nextVisible=true;
    ConfirmVisible=false;
    DistributorDatas;
    auditData;
    Step1=true;
    currencycode='';
    isloaderReq=true;
    shippingLocationData;
    incoTermData;
    salesOrederData;
    incoTermCipID = undefined;
    isdisabledbutton=true;
    isConfirm=false;
    isapprovalvisible=false;
    isordersaved=false;
    currencycodename='';
    modalheader='';         
    modalMessage='';
    salesOrderId='';
    orderstatusis='';
    isView=false;
    isdisabledEdit=true;
    isauditvisible=false;
    sucessheader='';
    successContent='';
    issalesorederscreen=false;
    orderSuccessImage = ORDERSAVED_IMAGE + '/UK_Icons/successOrder1.png';
    successbuttontext='';
    labelheadername='';
    divclass="boxstyle";
    textclass="labelstyle";
    strUserId  = userId;
    sapNumber=false;
    orderNumber=false;
    allsavedProduct=[];
    isfirstclick=false;
    nodata=false;
    isUKData=true
    @wire(CurrentPageReference) pageRef;

    cancelModal(){
        this.isConfirm=false;
        this.isordersaved=false;
    }
    

    label = {
        labelName,
        Confirm_UK,
        Do_you_want_to_apply_for_FCA_UK,
        Approval_Required_UK,
        Order_TypeUK,
        Normal_Type_Uk,
        Order_Successfully_created,
        Order_cretion_content_UK,
        Go_to_Sales_order_UK,
        Create_New_Order_UK,
        Order_Updated_successfully_Uk,
        Refresh_Page_Uk,
        Approval_History_Uk,
        Raise_Sales_Order,
        Base_URL_UK,
        Save_As_Draft_UK,
        Saved_As_Draft_Header_UK,
        To_save_as_Draft_Uk,
        Save_as_Draft_Header_UK,
        Account_Name_uk,
        Total_Credit_Limit_UK,
        SAP_Code_UK,
        Internal_Credit_Limit_UK,
        Credit_Limit_Used_UK,
        Credit_Limit_Balanced_Uk,
        Total_outstanding_UK,
        Net_Overdue_UK,
        Edit_UK,
        Order_Number_UK,
        SAP_Order_Number_UK,
    };

    connectedCallback(){
        //console.log('objectName==>'+this.objectName);
        if(this.objectName==='SalesOrder'){
            this.isView=true;
            this.isdisabledEdit=true;
            this.isdisabledbutton=true;
            this.labelheadername='VIEW ORDER';
            console.log('this.isdisabledbutton===>'+this.isdisabledEdit+'===>'+this.isdisabledbutton);
        }
        else{
            this.labelheadername=this.label.labelName; 
        }
        this.getData();
       // if (navigator.userAgent.includes("Chrome")){ 
            loadStyle(this, myStaticStyles)
            .then(result => {
                console.log('#####Success11Topic');
            })
            .catch(reason => {
                console.log('#####Error');
            });
      //  }
    }

    
   getData(){
    GetAllData({accId:this.recordId,objectName:this.objectName})
    .then(result =>{
        this.isfirstclick=true;
        this.salesOrederData=[];
        this.auditData=[];
         var data=result;
         if(data.DistributorData.salesOrgName==="United Kingdom" || data.DistributorData.salesOrgName==="Ireland" ){
            this.isUKData=true;
         }
         else{
            this.isUKData=false;
         }
         this.isloaderReq=false;
         if(data.SalesOrdersList){
             this.salesOrederData=data.SalesOrdersList;
         }
         if(data.generatedata){
             this.auditData=data.generatedata.listOfStepsAudit;
             if(data.generatedata.listOfStepsAudit.length > 0){
             this.isauditvisible=true;
         }
         console.log('generatedata=='+JSON.stringify(data.generatedata));
         }
         this.DistributorDatas=data.DistributorData;
         let shippingLocationData = [];
         if(data.ShippingLocList){
             for(let i in data.ShippingLocList){
                 let locName='',City='',pincode='';
                 if(data.ShippingLocList[i].Location_Name__c!=null){
                    locName=data.ShippingLocList[i].Location_Name__c;
                 }
                 if(data.ShippingLocList[i].City__c!=null){
                    City=data.ShippingLocList[i].City__c;
                 } 
                 if(data.ShippingLocList[i].Pincode__c!=null){
                    pincode=data.ShippingLocList[i].Pincode__c;
                 }
                 //this.shippingLocationData = [...this.shippingLocationData,{value: data.ShippingLocList[i].Id , label: data.ShippingLocList[i].Name+', '+data.ShippingLocList[i].City__c+', '+data.ShippingLocList[i].Pincode__c}];
                 shippingLocationData.push({label : data.ShippingLocList[i].Location_Name__c+', '+data.ShippingLocList[i].City__c+', '+data.ShippingLocList[i].Pincode__c, value : data.ShippingLocList[i].Id,fulldata:data.ShippingLocList[i]});
             }
         }
         this.shippingLocationData = shippingLocationData;
         let incoTermData = [];
         if(data.IncoTermList){
             for(let j in data.IncoTermList){
                 if(data.IncoTermList[j].IncoTerm_Code__c==='CIP'){
                    this.incoTermCipID=data.IncoTermList[j].Id;//'0016D00000RPMAuQAP';//
                 }
                 //this.incoTermData = [...this.incoTermData,{value: data.IncoTermList[j].Id , label: data.IncoTermList[j].IncoTerm_Code__c}];
                 incoTermData.push({value: data.IncoTermList[j].Id , label: data.IncoTermList[j].IncoTerm_Code__c});
             }
             this.incoTermData = incoTermData;
         }
        
         console.log('DistributorData=='+JSON.stringify(this.salesOrederData));
        
         if(this.DistributorDatas.salesOrgName==='United Kingdom'){
             this.currencycode='£';
             this.currencycodename='GBP';
         }
         else{
             this.currencycode='€';
             this.currencycodename='EUR';
         }
         if(this.objectName==='SalesOrder'){
            this.orderNumber=this.salesOrederData.Name;
            if(this.salesOrederData.SAP_Order_Number__c!=''){
                this.sapNumber=this.salesOrederData.SAP_Order_Number__c;
            }
             if(!this.sapNumber && (this.salesOrederData.CreatedById===this.strUserId) && (this.salesOrederData.Order_Status__c ==='Draft' || this.salesOrederData.Order_Status__c ==='Rejected')){
                this.isdisabledbutton=true;
                this.isdisabledEdit=false;
                this.isfirstclick=false;
             }
             else{
                this.isdisabledbutton=true;
                this.isdisabledEdit=true;
                this.isfirstclick=true;
             }
                
                this.template.querySelector("c-sales-order-uk-po-component").checkmethodtofil(this.salesOrederData,data.documentList,data.showPODate);  // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022...added one more field...data.showPODate...
                this.template.querySelector("c-sales-order-u-k-add-product-component-new").ceckmethod(this.salesOrederData,this.currencycodename); 
                if(this.template.querySelector("c-sales-order-shipping-address-component")){
                    this.template.querySelector("c-sales-order-shipping-address-component").checkmethodtofil(this.salesOrederData,this.objectName,this.shippingLocationData); 
                }
           }
           /* ----------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ----------------------------------------------- */
           this.template.querySelector("c-sales-order-uk-po-component").checkPoDateField(data.showPODate,data.isPORequired); 
           this.template.querySelector("c-sales-order-u-k-add-product-component-new").checkDelDateField(data.showDeliveryDate,data.isDeliveryRequired);
           /* ------------------ End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ------------------------------------------------------------- */
           this.template.querySelector("c-sales-order-u-k-add-product-component-new").currencygetmethod(this.currencycodename);
           //this.isdisabledbutton=true;
           console.log('this.isdisabledbutton===>'+this.isdisabledEdit+'===>'+this.isdisabledbutton);

         // TODO: Data handling
    })
    .catch(error =>{
        console.log('error===>'+JSON.stringify(error));
    })
  /*  wiredmethod (result) {
        this.allsavedProduct = result;
        if (result.data) {
           // this.isdisabledbutton=true;
           // this.isdisabledEdit=true;
           
        } else if (result.error) {
            console.log('error===>'+JSON.stringify(result.error));
            // TODO: Error handling
        }
    }*/
}

    ismoduleclick(event){
        var type=event.currentTarget.dataset.type;
        console.log('Click click===>'+type);
        if(type==='addproduct'){
            this.template.querySelector("c-sales-order-u-k-add-product-component-new").methodToChangeColoradd(true);  
            this.template.querySelector("c-sales-order-shipping-address-component").methodToChangeColorship(false);  
            this.template.querySelector("c-sales-order-uk-po-component").methodToChangeColorpo(false);  
            this.divclass="boxstyle";
            this.textclass="labelstyle";
        }
        else if(type==='shipdetails'){
            this.template.querySelector("c-sales-order-u-k-add-product-component-new").methodToChangeColoradd(false);  
            this.template.querySelector("c-sales-order-shipping-address-component").methodToChangeColorship(true);  
            this.template.querySelector("c-sales-order-uk-po-component").methodToChangeColorpo(false); 
            this.divclass="boxstyle";
            this.textclass="labelstyle";
        }
        else if(type==='ponumber'){
            this.template.querySelector("c-sales-order-u-k-add-product-component-new").methodToChangeColoradd(false);  
            this.template.querySelector("c-sales-order-shipping-address-component").methodToChangeColorship(false);  
            this.template.querySelector("c-sales-order-uk-po-component").methodToChangeColorpo(true); 
            this.divclass="boxstyle";
            this.textclass="labelstyle";
        }
        else if(type==='aprovalbox'){
            this.template.querySelector("c-sales-order-u-k-add-product-component-new").methodToChangeColoradd(false);  
            this.template.querySelector("c-sales-order-shipping-address-component").methodToChangeColorship(false);  
            this.template.querySelector("c-sales-order-uk-po-component").methodToChangeColorpo(false); 
            this.divclass="boxstylecolored";
            this.textclass="labelstylecolored";            
        }
      
    }
    handleshipEvent(){
        this.template.querySelector("c-sales-order-u-k-add-product-component-new").methodToChangeColoradd(false);  
        this.template.querySelector("c-sales-order-uk-po-component").methodToChangeColorpo(false); 
    }
    methodtoconfirm(event){
      this.isConfirm=false;
      var type=event.currentTarget.dataset.type;
      if(type=='openconfirm'){
        this.orderstatusis='Submitted';
      }
      else if(type=='draft'){
        this.orderstatusis='Draft';  
      }
      var isvalidpo =false;
      var isvalidship=false;
      var isvalidproducts=false;
       isvalidpo = this.template.querySelector("c-sales-order-uk-po-component").methodTogetvalues(this.orderstatusis);
       isvalidship = this.template.querySelector("c-sales-order-shipping-address-component").methodTogetvaluesship(this.orderstatusis);
       isvalidproducts = this.template.querySelector("c-sales-order-u-k-add-product-component-new").getcartproducts();
      var callmethod=false;
      var isapprval=false;
      if(isvalidpo && isvalidship && isvalidproducts){
        if(isvalidproducts.Totaldiscount>=1){
            isapprval=true;
            this.isConfirm=true;
           // this.modalMessage=this.label.Do_you_want_to_apply_for_FCA_UK;
           // this.modalheader=this.label.Approval_Required_UK;
          }
         if(type=='openconfirm' ){
            this.isConfirm=true;
            this.modalMessage=this.label.Do_you_want_to_apply_for_FCA_UK;
            this.modalheader=this.label.Confirm_UK;
            this.topFunction();
            
          }
          else if(type=='draft'){
            this.isConfirm=true;
            this.modalMessage=this.label.To_save_as_Draft_Uk;
            this.modalheader=this.label.Save_as_Draft_Header_UK;
            this.topFunction();
          }
          else{
            this.isConfirm=false;
            callmethod=true;
            this.isloaderReq=true;
          }
          
      }
      
      if(type=='Confrim' && callmethod){
          this.isloaderReq=true;         
        this.isConfirm=false;
        saveSalesOrder({recordId:this.recordId,
            distributorData:JSON.stringify(this.DistributorDatas),
            orderdata:JSON.stringify(isvalidproducts),
            orderStatus:this.orderstatusis,
            incotermid:isvalidship.Incotermvalue,
            shippingaddress:isvalidship.shippingdetailsid,
            remark:isvalidship.remarkvalue,
            ponumber:isvalidpo.poNumber,
            podocument:JSON.stringify(isvalidpo.poDoc),
            isapprovalreq:isapprval,
            currencycodename:this.currencycodename,
            objectName:this.objectName,         
            poDate:isvalidpo.poDate         // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022...
        })
        .then(result => {
            console.log('result==>Success', result)
           if(this.objectName==='SalesOrder'){
                this.issalesorederscreen=true;
                this.isordersaved=true;
                
                if(this.orderstatusis==='Draft'){
                    this.sucessheader= this.label.Saved_As_Draft_Header_UK;
                    this.successContent=this.label.Save_As_Draft_UK;
                    this.successbuttontext=this.label.Refresh_Page_Uk;
                    }
                else{
                    this.sucessheader= this.label.Order_Updated_successfully_Uk;
                    this.successContent=this.label.Order_cretion_content_UK;
                    this.successbuttontext=this.label.Refresh_Page_Uk;
                   
                }
               
           }
           else{
               this.issalesorederscreen=false;
               this.isordersaved=true;
               if(this.orderstatusis==='Draft'){
                this.sucessheader= this.label.Saved_As_Draft_Header_UK;
                this.successContent=this.label.Save_As_Draft_UK;
                this.successbuttontext=this.label.Create_New_Order_UK;
            }
            else{
                this.sucessheader= this.label.Order_Successfully_created;
                this.successContent=this.label.Order_cretion_content_UK;
                this.successbuttontext=this.label.Create_New_Order_UK;
            }
               
           }
            this.isdisabledbutton=true;
            this.isloaderReq=false;
            this.salesOrderId=result.cartOrderId;
        })
        .catch(error => {
            console.log('error==>',error)
            this.error = error;
            this.isloaderReq=false;
        });
      }
    }

    handleCustomEvent(){
        this.isdisabledbutton=false;
        if(this.objectName==='SalesOrder'){
            if(this.isdisabledEdit){
                if(this.isfirstclick){
                    this.isdisabledbutton=true;
                }
                else{
                    this.isdisabledbutton=false;
                }
            }
            else{
                this.isdisabledbutton=true;
            }
        }
        console.log('this.isdisabledbutton===>11',this.isdisabledbutton+'this.isfirstclick=='+this.isfirstclick)
    }
    handleCustomEventempty(){
        this.isdisabledbutton=true;
        this.nodata=true;
    }
    refrshpage(event){
        this.isordersaved=false;
        var type=event.currentTarget.dataset.type;
        if(type==='onplaceorder'){
           if(this.objectName==='SalesOrder'){
                this.isloaderReq=true;
                this.labelheadername='VIEW ORDER';
                this.recordId=this.salesOrderId;
                this.objectName='SalesOrder';
                //return refreshApex(this.allsavedProduct);
                this.getData();
            }
            else{
               // window.location.reload();
             this.isdisabledbutton=true;
             this.template.querySelector("c-sales-order-u-k-add-product-component-new").clearmethod();  
             this.template.querySelector("c-sales-order-shipping-address-component").clearmethod();  
             this.template.querySelector("c-sales-order-uk-po-component").clearmethod(); 
            }
        }
        else{
            //this.isView=true;
            this.isdisabledbutton=true;
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: this.salesOrderId,
                       // objectApiName: 'Sales_Order__c', // objectApiName is optional
                        actionName: 'view'
                    }
                });
                console.log('this.salesOrderId'+this.salesOrderId)
        }

       
    }
    methodtoEdit(){
        console.log('checkdata==');
        if(this.nodata){
            this.isdisabledbutton=true;  
        }
        else{
            this.isdisabledbutton=false;   
        }
         this.isdisabledEdit=true;  
         this.isfirstclick=false;
         this.template.querySelector("c-sales-order-u-k-add-product-component-new").iseditcalled();  
         this.template.querySelector("c-sales-order-shipping-address-component").iseditcalled();  
         this.template.querySelector("c-sales-order-uk-po-component").iseditcalled();
    }

    callmethod(){
        window.location.origin + "/" + "a2v6D0000005xbEQAQ";
    }
    cancelFinalModal(){
      this.getData();
       this.template.querySelector("c-sales-order-u-k-add-product-component-new").clearmethod();
       this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: this.recordId,
            actionName: 'view'
        }
    });
    }
    
    topFunction(){
        
        if (navigator.userAgent.includes("Mac")){ 
        let myHeight = window.innerHeight;
      // let myHeight2= document.body.offsetHeight;
       // alert(myHeight);
       // let lenght=(myHeight2)/2;
      //  window.scrollTo(0,0);
        /*const scrollOptions = {
            left: 0,
            top: lenght,
            behavior: 'smooth'
        }
        window.scrollTo(scrollOptions);*/
        //alert(navigator.userAgent);
        let knowledgeWidgetElement = this.template.querySelector('.myClass')
		knowledgeWidgetElement.scrollTop=0;
    }
}
    
}