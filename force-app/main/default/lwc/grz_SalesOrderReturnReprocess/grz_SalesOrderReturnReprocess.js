import { LightningElement,api,wire,track } from 'lwc';
import getDetailsReprocess from "@salesforce/apex/grz_SalesOrderReturnFnlController.getDetailsReprocess";
import saveRec from "@salesforce/apex/grz_SalesOrderReturnFnlController.saveRec";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import modal from "@salesforce/resourceUrl/Grz_ModalWidth";
//import modal from "@salesforce/resourceUrl/ModalCssUk";
import { loadStyle } from "lightning/platformResourceLoader";

const columns = [
    { label: 'Line Item', fieldName: 'name', type: 'text' },
    { label: 'Product SKU', fieldName: 'proname', type: 'text' },
    { label: 'Batch', fieldName: 'batch', type: 'text' },
    { label: 'Expiry Date', fieldName: 'expDate', type: 'date' },
    { label: 'UOM', fieldName: 'uom', type: 'text' },
    { label: 'Total Quantity', fieldName: 'totalQnty', type: 'number' },
    { label: 'Net Value Per Unit', fieldName: 'netValuePerUnit', type: 'number' },
    { label: 'Net Value', fieldName: 'netValue', type: 'number' },
    { label: 'YTD Sales', fieldName: 'ytdSales', type: 'number' },
    { label: 'Net Value Returned', fieldName: 'netValueReturned', type: 'number'},
    { label: 'Quantity Already Returned', fieldName: 'alreadyReturned', type: 'number' },
    { label: 'Return Quantity ', fieldName: 'returnQty', type: 'number',editable: 'true',typeAttributes: { maximumFractionDigits: '3' } },
  //  { label: 'Reason of Return', fieldName: 'returnReason', type: 'text',editable: 'true' }
    
];
export default class Grz_SalesOrderReturnReprocess extends LightningElement {
    sldsThemeH='slds-modal__header slds-theme_error';
    sldsThemeB='slds-modal__content slds-p-around_medium slds-box slds-theme_error slds-theme_alert-texture';
    showVfMsg=false;
    vfMsg1='';
    vfMsg2='';
    approvalPercent;
    finalApprover=null;
    ytdAmt;
    confirmmsg='Dear User, your Return request is about to be submitted and after 2 step approvals, it will be sent to SAP. pls track the SO number for status update...';
      @api recordId;
    detailsData = [];
    thresh11=false;
    thresh22=false;
    submitArray1 = [];
    mmList = [];
    orderreasonval = '';
    data = [];
    columns = columns;
    draftValues = [];
    errors = [];
    isShowModal = false;
    isLoaded = true;
    apError = false;
    apErrorMsg = '';
    showToast=false;
    errorTitle='';
    errorMsg='';
    volMap={};
    fhApprover=null;
    connectedCallback() {
    Promise.all([loadStyle(this, modal)]);
    //if(this.recordId)this.getInvData(this.recordId);
    }

    @wire(getDetailsReprocess, {retSalesOrderId: "$recordId"})
        getRecord({ error, data }) {
             if (data) {
                console.log('=============**********data*******================',data);
                var data1=JSON.parse(JSON.stringify(data));
            this.detailsData = data1;
            this.data = data1.InvoiceLineItemList;
            this.volMap = data1.volMap;
            this.approvalPercent=data1.approvalPercent;
            this.finalApprover=data1.finalApprover;
            this.fhApprover=data1.finalApprover2;
            //this.ytdAmt=data1.ytdAmt;
                
             console.log("---this.data----", this.data);
             console.log("---this.detailsData----", this.detailsData);
             this.orderreasonval  = this.detailsData.picks[0].value;
             this.isLoaded=false;
            } else if (error) {
            console.log("---error----", error);
            location.reload();
            }
        }

       

        async handleSave(event) {
            this.thresh11=false;
       this.thresh22=false;
            this.errors = [];
            var count = 0;
            var error = false;
            var errornegativeval = false;
            var errorList = [];
    
            this.draftValues = event.detail.draftValues;
            console.log(event.detail.draftValues.length);
            for(var i=0; i<event.detail.draftValues.length; i++){
                var er = '';
                if(event.detail.draftValues[i].returnQty != null && event.detail.draftValues[i].returnQty != ''){
                    // console.log(event.detail.draftValues[i]);
                    const myArray = event.detail.draftValues[i].id.split("@_@_@_@");
                
                    if(parseFloat(event.detail.draftValues[i].returnQty) < 0){
                        errornegativeval = true;
                    }
    
                    if(parseFloat(event.detail.draftValues[i].returnQty) >  parseFloat(myArray[1])){
                        er = er+'QM';
                        error = true;
                        //console.log('error');
                       // errorList.push(event.detail.draftValues[i].id);
                    }
                    //console.log(' event.detail.draftValues[i].returnQty.includes(',  event.detail.draftValues[i].returnQty.includes('.'))
                    //console.log(' event.detail.draftValues[i].returnQty.includes(',  event.detail.draftValues[i].returnQty);
                    // console.log(' event.detail.draftValues[i].returnQty.includes(',  myArray)
                    if(myArray[2] != 'null' && myArray[2] != ''){
                        if((myArray[2] != 'KG' && myArray[2] != 'L' ) && event.detail.draftValues[i].returnQty.includes('.')){
                            er = er+'UOM';
                            error = true;
                        }
                    }
                    
                    if(er != ''){
                        errorList.push(event.detail.draftValues[i].id+'@--@'+er);
                    }
                }else{
                    count = count+1;
                }
               
            }
    
        console.log('count==>'+count);
        console.log('error==>'+error);
        console.log('errorList==>'+errorList);
        console.log('window.location.href=>'+window.location.href);
    
        if(errornegativeval == true){
            this.isShowModal = true;
            this.errorMsg='Entered quantity cannot be negative';
            this.errorTitle='Values Missing!';
            this.showToast=true;
            /*const evt = new ShowToastEvent({
                title: 'Invalid Quantity',
                message: 'Entered quantity should be more than 0.',
                variant: 'error',
            });
            this.dispatchEvent(evt);*/
        }
        else if(count == event.detail.draftValues.length){
            this.isShowModal = true;
            this.errorMsg='Please enter some quantity before proceeding.';
            this.errorTitle='Values Missing!';
            this.showToast=true;
            /*const evt = new ShowToastEvent({
                title: 'Values Missing.',
                message: 'Please enter some quantity before proceed',
                variant: 'error',
            });
            this.dispatchEvent(evt);*/
        }else if(error == true){
            if(window.location.href.includes('apex/')){
                console.log('Yes')
    
                this.isShowModal = true;
                this.errorMsg="Please fix the errors before proceeding. Following are the possible reasons for error encountered : ";
                this.vfMsg1="1.) Return quantity should not be more than the remaining quantities on the Invoice.";
                this.vfMsg2="2.) You cannot enter decimals in return quantity as the unit of measurment associated with the product is KG or Litres.";
                this.showVfMsg=true;
                        this.errorTitle='Error!';
            this.showToast=true;
    
                var rows1 = {};
            for(var i=0; i<errorList.length; i++){
                //console.log('ff',errorList[i]);
                if(errorList[i].split("@--@")[1] == 'QM'){
                          rows1[errorList[i].split("@--@")[0]] = {
                            fieldNames: ['returnQty']
                        }
                }else if(errorList[i].split("@--@")[1] == 'QMUOM'){
                    rows1[errorList[i].split("@--@")[0]] = {
                            fieldNames: ['returnQty']
                }
            }else if(errorList[i].split("@--@")[1] == 'UOM'){
                 rows1[errorList[i].split("@--@")[0]] = {
                            fieldNames: ['returnQty']
                        }
            }
            }
            console.log('rows1',rows1);
            this.errors = {
                    rows: rows1,
                };
    
    
            }else{
            this.isShowModal = true;
            this.errorMsg='Please fix the errors before proceeding.';
            this.errorTitle='Error!';
            this.showToast=true;
            /*const evt = new ShowToastEvent({
                title: 'Quantity Exceed.',
                message: 'Please fix the errors before proceed.',
                variant: 'error',
            });
            this.dispatchEvent(evt);*/
            var rows1 = {};
            for(var i=0; i<errorList.length; i++){
                //console.log('ff',errorList[i]);
                if(errorList[i].split("@--@")[1] == 'QM'){
                          rows1[errorList[i].split("@--@")[0]] = {
                            title: 'We found 1 errors.',
                            messages: [
                                'Return quantity should not be more than the remaining quantities on the Invoice.'
                            ],
                            fieldNames: ['returnQty']
                        }
                }else if(errorList[i].split("@--@")[1] == 'QMUOM'){
                    rows1[errorList[i].split("@--@")[0]] = {
                            title: 'We found 2 errors.',
                            messages: [
                                'Return quantity should not be more than the remaining quantities on the Invoice.',
                                'You can only populate return quantities in whole numbers for this product.'
                            ],
                            fieldNames: ['returnQty']
                }
            }else if(errorList[i].split("@--@")[1] == 'UOM'){
                 rows1[errorList[i].split("@--@")[0]] = {
                            title: 'We found 1 errors.',
                            messages: [
                                'You can only populate return quantities in whole numbers for this product.'
                            ],
                            fieldNames: ['returnQty']
                        }
            }
            }
            console.log('rows1',rows1);
            this.errors = {
                    rows: rows1,
                    table: {
                        title: 'Your entry cannot be saved.',
                        messages: [
                            'Fix the errors and try again.'
                        ]
                    }
                };
        }}else{
            this.confirmmsg='Dear User, your Return request is about to be submitted and after 2 step approvals, it will be sent to SAP. pls track the SO number for status update...';
            console.log('sucess');
            var thresh1=false;
            var thresh2=false;
            console.log(JSON.stringify(this.data));
            console.log('vol==='+JSON.stringify(this.volMap));
            var msgList=[];
            var submitArray = [];
             for(var i=0; i<this.draftValues.length; i++){
                  if(this.draftValues[i].returnQty != null && this.draftValues[i].returnQty != ''){
                        submitArray.push(this.draftValues[i]);
                  }
             }
             this.submitArray1=submitArray;
             var upLi=this.data;
             var helper1 = {};
             for(var i=0; i<upLi.length; i++){
                if(!upLi[i].returnQty)upLi[i].returnQty=0;
             }
            var resultG = upLi.reduce(function(r, o) {
                var key = o.product;
                
                if(!helper1[key]) {
                    helper1[key] = Object.assign({}, o); // create a copy of o
                    r.push(helper1[key]);
                } else {
                    if(helper1[key].returnQty!=null)helper1[key].returnQty = parseFloat(o.returnQty)+parseFloat(helper1[key].returnQty);
                }
                
                return r;
            }, []);
            console.log('resultG==='+JSON.stringify(resultG));
    
            var ap= parseFloat(this.approvalPercent);
    
    
            for(var i=0; i<resultG.length; i++){
                console.log(parseFloat(resultG[i].returnQty)+'<<<<<<'+parseFloat(this.volMap[resultG[i].product]));
                if(resultG[i].returnQty){
                var ret=parseFloat(resultG[i].returnQty);
                if(ret>0){
                    var orig=parseFloat(this.volMap[resultG[i].product]);
                if(orig>0){
                    if(((ret/orig)*100)>=ap){
                    thresh1=true;
                    var m1='Return qty for materials:'+resultG[i].product+' is exceeding the threshold return qty as per Sales return SOP.';
                    msgList.push(m1);
                }
            }
                }
                
                }
           }
           for(var i=0; i<this.data.length; i++){
            if(this.data[i].returnQty && parseFloat(this.data[i].returnQty)>0){
                var date1=new Date(this.data[i].expDate);
                var date2=new Date();
               var noOfDays=(((date1-date2)/(1000 * 60 * 60 * 24)));
               if(noOfDays>0 && noOfDays<180){
                thresh1=true;
                var m1='Material:'+this.data[i].proname+'  is within 6 months of expiry.';
                msgList.push(m1);
               }
               if(noOfDays<0){
                thresh2=true;
                thresh1=true;
                var m1='Material:'+this.data[i].proname+'  is already expired.';
                msgList.push(m1);        }
            }
       }
       this.mmList=[];
       if(msgList.length>0){
        this.confirmmsg='Dear User, the return request will undergo additional approvals due to below exceptional scenario -   \n';
        this.mmList=msgList;
    }
       this.thresh11=thresh1;
       this.thresh22=thresh2;
       this.showToast=false;
            this.isShowModal = true;
            
        }
        }
    
    
     hideModalBox() {  
        this.isShowModal = false;
        this.showVfMsg=false;
    }

    submit() {
        
        this.isShowModal = false;
        this.isLoaded = true;
        saveRec({dataLst : this.submitArray1, 
                invId1 : '', 
                reProcess : true, 
                retSalesOrderId : this.recordId, 
                fhApprover : this.fhApprover, 
                orderRsn : this.orderreasonval,
                threshold1 : this.thresh11, 
                threshold2 : this.thresh22, 
                finalApprover : this.finalApprover})
            .then((data) => {
                this.isShowModal = true;
                this.showToast=true;
                this.errorMsg='Return request submitted successfully.';
                this.errorTitle='Submitted successfully.';
                this.sldsThemeH='slds-modal__header slds-theme_success';
                this.sldsThemeB='slds-modal__content slds-p-around_medium slds-box slds-theme_success slds-theme_alert-texture';

                /*const evt = new ShowToastEvent({
                    title: 'Return Success',
                    message: 'Return request submitted successfully.',
                    variant: 'Success',
                });
                
                this.dispatchEvent(evt);*/
                this.dispatchEvent(new CloseActionScreenEvent());
                this.draftValues = [];
                this.isLoaded = false;
                setTimeout(() => {
                   
                    window.open(window.location.origin+'/'+data, "_self");

                }, 1000);
                //location.reload();
                console.log(data);
                }) 
                .catch((error)=>{
                this.isLoaded = false;
                this.isShowModal = true;
                this.showToast=true;
                this.errorMsg=JSON.stringify(error);
                this.errorTitle='Some error occured. Please contact administrator.';
                this.sldsThemeH='slds-modal__header slds-theme_error';
                this.sldsThemeB='slds-modal__content slds-p-around_medium slds-box slds-theme_error slds-theme_alert-texture';

                /*const evt = new ShowToastEvent({
                    title: 'Some error occured. Please contact administrator.',
                    message: error,
                    variant: 'Error',
                });
                this.dispatchEvent(evt);*/
                console.log(error);
                });
        
    }


     handleEditCellChange(event){
        console.log('Change');
        console.log(event.detail.draftValues);
        console.log(this.data);
       // this.data = [];
       var duplicateData = [];
       if(event.detail.draftValues.length > 0){
            for(var i=0; i<event.detail.draftValues.length; i++){
                for(var j=0; j<this.data.length; j++){
                    var objCopy = {...this.data[j]};
                    if(event.detail.draftValues[i].id == this.data[j].id){
                        console.log(event.detail.draftValues[i].returnQty+'============='+(this.data[j].totalQnty+'-------------'+this.data[j].alreadyReturned));
                        if(event.detail.draftValues[i].returnQty>(this.data[j].totalQnty-this.data[j].alreadyReturned)){
                            console.log('errrrror*************302');
                            this.showToast=true;
                            this.isShowModal=true;
                            this.errorMsg='The return quantity entered exceed the quantity availaible on Invoice';
                            this.errorTitle='Warning!';
                            this.sldsThemeH='slds-modal__header slds-theme_warning';
                            this.sldsThemeB='slds-modal__content slds-p-around_medium slds-box slds-theme_warning slds-theme_alert-texture';
                        
                        }else{
                            objCopy.returnQty=event.detail.draftValues[i].returnQty;
                        }

                        if((this.data[j].uom != 'KG' && this.data[j].uom != 'L' ) && event.detail.draftValues[i].returnQty.includes('.')){
                            console.log('errrrror*************313');
                            this.showToast=true;
                            this.isShowModal=true;
                            this.errorMsg='The return quantity enterd cannot be in decimals for the current UOM';
                            this.errorTitle='Warning!';
                            this.sldsThemeH='slds-modal__header slds-theme_warning';
                            this.sldsThemeB='slds-modal__content slds-p-around_medium slds-box slds-theme_warning slds-theme_alert-texture';
                        
                        }
                    var retQnty = 0;
                    if(event.detail.draftValues[i].returnQty != ''){
                        retQnty = parseFloat(event.detail.draftValues[i].returnQty);
                    }
                    objCopy.netValueReturned = parseFloat(this.data[j].netValuePerUnit) * retQnty;
                    console.log(objCopy)
                    }
                    duplicateData.push(objCopy);
                   // this.data = ss;
                }
            }
            this.data = duplicateData;
       }
       console.log('this.data==>',this.data)
    }

    triggerError(event) {
        this.errors = {
             rows: {
                 'a1W6D000000lfYlUAI@_@_@_@23': {
                     title: 'We found 1 errors.',
                     messages: [
                         'Return quantity should not be more than quantity pending.'
                     ],
                     fieldNames: ['returnQty']
                 }
             },
             table: {
                 title: 'Your entry cannot be saved. Fix the errors and try again.',
                 messages: [
                     'Return quantity should not be more than quantity pending.'
                 ]
             }
         };
         console.log(this.errors);
     }
}