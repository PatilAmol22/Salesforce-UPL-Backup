import { api, LightningElement, track, wire } from 'lwc';
import { fireEvent, registerListener,unregisterListener } from 'c/pubsub';
import { CurrentPageReference } from 'lightning/navigation'; 
import getProductLiquidationData from '@salesforce/apex/LiquidationAF.getProductLiquidationData';
import createProductLiquidation from '@salesforce/apex/LiquidationAF.createProductLiquidation';
import noLAPErrorMessageLabel from '@salesforce/label/c.NoLAPPresentErrorMessage';
import liqNotSubErrorMessageLabel from '@salesforce/label/c.LiquidationNotSubmittedErrorMessage';
import productSubmissionLabel from '@salesforce/label/c.Product_Sub';
import AllowOpnInvEdit from '@salesforce/label/c.AllowOpnInvEdit';

export default class LiquidationAfProductCmp extends LightningElement {
    //Custom Label
    label = {
        noLAPErrorMessageLabel,
        liqNotSubErrorMessageLabel,
        productSubmissionLabel,
        AllowOpnInvEdit
    }
    
    @wire(CurrentPageReference) pageRef; 

    // All JS Variables are defined here
    @api liquidationmonth;
    @api liquidationterritory;
    @api liquidationfiscalyear;
    @api liquidationuserrole;
    @api istmavbmap;
    @api iszsmrolemap;
    @api territorymap;
    @track liquidationYTD;
    @track liquidationPerYTD;
    hideProdSpinner = false;
    productTableData = [];
    @track productTableFilteredData = [];
    searchKey;
    totalProdListSize;
    totalfilteredListSize;
    footerMessage;
    isShowSubmit=false;
    isShowCropBreakup=false;
    isSubModalOpen = false;
    isTMAvailable = true;
    showProductTable = false;
    isDisableInv = false;
    liqCurStatus;
    territoryName;
    @track isOpenCrpModal = false;
    errorProductArray = [];
    //negLiqNegYTDProdArray = [];
    negLiqProdArray = [];
    isShowErrorPopup = false;
    errorTitle;
    errorMessage = [];
    isDisbEditnAppBtn = true;
    isShowProdError = false;
    isZSMHasRole = false;
    @track errMessage;
    @track allowAllByPass;   //By pass validation

    //Onload Action
    connectedCallback(){
        this.liquidationYTD = 'Liquidation MTD ' + this.liquidationmonth;
        this.liquidationPerYTD = 'Liquidation % MTD ' + this.liquidationmonth;
        this.isTMAvailable = this.checkTm(this.liquidationterritory);
        if(this.liquidationuserrole == 'ZSM'){
            this.isZSMHasRole = this.checkZSMRole(this.liquidationterritory);
        }

        if(this.liquidationuserrole != 'ZSM'){
            this.getProductTableData(this.liquidationterritory, this.liquidationfiscalyear, this.liquidationmonth, this.liquidationuserrole, this.isTMAvailable);
        }else if(this.liquidationuserrole == 'ZSM' && this.isZSMHasRole){
            this.getProductTableData(this.liquidationterritory, this.liquidationfiscalyear, this.liquidationmonth, this.liquidationuserrole, this.isTMAvailable);
        }else{
            this.dispatchEvent(new CustomEvent('errormessage'));
            this.showProductTable = false;
            this.errMessage = 'Dear user, Please refer to My Liquidation Data Tab to view the Liquidation of selected territory';
            this.hideProdSpinner = true;
        }

        // Creates the custom event with status of Product table load
        if(!this.pageRef)
        {
            this.pageRef = {};
            this.pageRef.attributes = {};
            this.pageRef.attributes.LightningApp = "LightningApp";
        } 
        //listen to events
        registerListener("liqMonthChangeEvent",this.reloadTableMnt,this);
        registerListener("liqTerritoryChangeEvent",this.reloadTableTer,this);
    }

    //Check TM availability in territory
    checkTm(terCode){
        const isTmJson = JSON.parse(this.istmavbmap);
        return isTmJson[terCode];
    }

    //Check ZSM Role for territory
    checkZSMRole(terrCode){
        const isZsmRoleJson = JSON.parse(this.iszsmrolemap);
        return isZsmRoleJson[terrCode];
    }

    //handle territory change on header
    reloadTableTer(param){
        this.isShowProdError = false;
        this.liquidationterritory = param;
        this.hideProdSpinner = false;
        this.isTMAvailable = this.checkTm(this.liquidationterritory)
        if(this.liquidationuserrole == 'ZSM'){
            this.isZSMHasRole = this.checkZSMRole(this.liquidationterritory);
        }

        this.productTableData = [];
        this.productTableFilteredData = [];
        this.searchKey = '';
        if(this.liquidationuserrole != 'ZSM'){
            this.getProductTableData(this.liquidationterritory, this.liquidationfiscalyear, this.liquidationmonth, this.liquidationuserrole, this.isTMAvailable);
        }else if(this.liquidationuserrole == 'ZSM' && this.isZSMHasRole){
            this.getProductTableData(this.liquidationterritory, this.liquidationfiscalyear, this.liquidationmonth, this.liquidationuserrole, this.isTMAvailable);
        }else{
            this.dispatchEvent(new CustomEvent('errormessage'));
            this.showProductTable = false;
            this.errMessage = 'Dear user, Please refer to My Liquidation Data Tab to view the Liquidation of selected territory';
            this.hideProdSpinner = true;
        }
    }

    //load product liquidation table
    getProductTableData(curTerCode, curFisYr, curMnt, uRole, isTMPresent){
        getProductLiquidationData({
            territoryCode : curTerCode,
            fisYear : curFisYr,
            liqMonth : curMnt,
            usrRole : uRole,
            isTmAvb : isTMPresent
        })
        .then(result => {
            if(result != null && result != undefined){
                if(result == noLAPErrorMessageLabel || result == liqNotSubErrorMessageLabel){
                    this.showProductTable = false;
                    this.errMessage = result;
                    this.dispatchEvent(new CustomEvent('errormessage'));
                }else{
                    this.dispatchEvent(new CustomEvent('productdata'));
                    var res = JSON.parse(result);
                    this.allowAllByPass = res.byProdPassValid;  //By pass validation
                    this.liqCurStatus = res.liqStatus;
                    for(var pi = 0; pi < res.liqAfProductList.length; pi++){
                        this.productTableData.push(res.liqAfProductList[pi]);
                        if(!res.liqAfProductList[pi].isDisableOI){
                            this.isShowProdError = true; 
                        }
                    }
                    //sort product based on Total available stocks in descending order
                    this.productTableData.sort(this.getSortOrder("tAvbStck")); 
                    this.productTableFilteredData = this.productTableData;
                    if(uRole == 'TM'){
                        if(res.liqStatus == 'Not Started' || res.liqStatus == 'Rejected' || res.liqStatus == 'Unlocked'){
                            this.isShowSubmit=true;
                            this.isShowCropBreakup=false;
                            this.isDisbEditnAppBtn = false;
                            this.isDisableInv = false;
                        }else if(res.liqStatus == 'In Progress' &&  res.isProdSub == true){
                            this.isShowSubmit=false;
                            this.isShowCropBreakup=true;
                            this.isDisableInv = true;
                        }else if(res.liqStatus == 'Approved' || res.liqStatus == 'Edit and Approved'){
                            this.isShowSubmit=false;
                            this.isShowCropBreakup=true;
                            this.isDisableInv = true;
                        }else if(res.liqStatus == 'Pending for Approval'){
                            this.isShowSubmit=false;
                            this.isShowCropBreakup=true;
                            this.isDisableInv = true;
                        }
                        fireEvent(this.pageRef,"liqApprovalStatusEvent",res.liqStatus);
                    }else{
                        if((res.liqStatus == 'Not Started' || res.liqStatus == 'Unlocked') && isTMPresent == false){
                            this.isShowSubmit=true;
                            this.isShowCropBreakup=false;
                            this.isDisbEditnAppBtn = false;
                            this.isDisableInv = false;
                        }else if(res.liqStatus == 'In Progress' && isTMPresent == false){
                            this.isShowSubmit=false;
                            this.isShowCropBreakup=true;
                            this.isDisableInv = true;
                        }else if(res.liqStatus == 'Pending for Approval' && res.isProdSub == false){
                            this.isShowSubmit=true;
                            this.isDisbEditnAppBtn = true;
                            this.isShowCropBreakup=true;
                            this.isDisableInv = false;
                        }else if(res.liqStatus == 'Pending for Approval' && res.isProdSub == true){
                            this.isShowSubmit=false;
                            this.isShowCropBreakup=true;
                            this.isDisableInv = true;
                            for(var ind = 0; ind < this.productTableFilteredData.length; ind++){
                                this.productTableFilteredData[ind].isDisableOI = true;
                            }
                        }else if(res.liqStatus == 'Approved' || res.liqStatus == 'Edit and Approved'){
                            this.isShowSubmit=false;
                            this.isShowCropBreakup=true;
                            this.isDisableInv = true;
                        }
                        fireEvent(this.pageRef,"liqApprovalStatusEvent",res.liqStatus);
                    }
                    
                    this.totalProdListSize = this.productTableData.length;
                    this.totalfilteredListSize = this.productTableFilteredData.length;
                    this.footerMessage = 'Showing '+this.totalfilteredListSize+' of '+this.totalProdListSize+' products';
                    this.showProductTable = true;
                }
            }else{
                this.showProductTable = false;
                this.errMessage = result;
            }
            this.hideProdSpinner = true;
        }).catch(error => {
            console.log('Something went wrong...'+error);
        });
        
    }

    //Compare/sort Function    
    getSortOrder(prop) {    
        return function(a, b) {    
            if (a[prop] < b[prop]) {    
                return 1;    
            } else if (a[prop] > b[prop]) {    
                return -1;    
            }    
            return 0;    
        }    
    }

    //handle search on table
    handleSearch(event){
        this.searchKey = event.detail.value;
        var allProdData = this.productTableData;
        var key = this.searchKey.toUpperCase();
        if(key != null || key != undefined){
            var tempArray = [];

            for(var i=0; i < allProdData.length; i++){
                if((allProdData[i].prodCode && allProdData[i].prodCode.toUpperCase().indexOf(key) != -1) ||
                (allProdData[i].prodName && allProdData[i].prodName.toUpperCase().indexOf(key) != -1 ) ||
                (allProdData[i].openInv && allProdData[i].openInv.toString().indexOf(key) != -1 ) ||
                (allProdData[i].ytdSale && allProdData[i].ytdSale.toString().indexOf(key) != -1 ) ||
                (allProdData[i].tAvbStck && allProdData[i].tAvbStck.toString().indexOf(key) != -1 ) ||
                (allProdData[i].distInv && allProdData[i].distInv.toString().indexOf(key) != -1 ) ||
                (allProdData[i].retInv && allProdData[i].retInv.toString().indexOf(key) != -1 ) ||
                (allProdData[i].totMrkInv && allProdData[i].totMrkInv.toString().indexOf(key) != -1 ) ||
                (allProdData[i].prodBud && allProdData[i].prodBud.toString().indexOf(key) != -1 ) ||
                (allProdData[i].liqYTD && allProdData[i].liqYTD.toString().indexOf(key) != -1 ) ||
                (allProdData[i].liqYTDPer && allProdData[i].liqYTDPer.toString().indexOf(key) != -1 )) 
                {
                    tempArray.push(allProdData[i]);
                }
            }
            this.productTableFilteredData = tempArray;
            this.totalfilteredListSize = this.productTableFilteredData.length;
            this.footerMessage = 'Showing '+this.totalfilteredListSize+' of '+this.totalProdListSize+' products';
        }else{
            this.productTableFilteredData = this.productTableData; 
            this.totalfilteredListSize = this.productTableFilteredData.length;
            this.footerMessage = 'Showing '+this.totalfilteredListSize+' of '+this.totalProdListSize+' products';
        }
    }

    //Handle cell change
    handleCellChange(event){
        this.isDisbEditnAppBtn = false;
        var rowIndex = event.target.label;
        var cellName = event.target.name;
        var filteredRowIndex;

        for(var pi = 0; pi<this.productTableFilteredData.length; pi++){
            if(this.productTableFilteredData[pi].index == rowIndex){
                filteredRowIndex = pi;
                break;
            }
        }

        if(cellName == 'openInv'){
            this.productTableFilteredData[filteredRowIndex].openInv = event.target.value;
            this.productTableFilteredData[filteredRowIndex].isOpnInvEdit = true;
        }else if(cellName == 'distInv'){
            this.productTableFilteredData[filteredRowIndex].distInv = event.target.value;
        }else if(cellName == 'retInv'){
            this.productTableFilteredData[filteredRowIndex].retInv = event.target.value;
        }
    }

    //Handle cell Blur
    handleCellBlur(event){
        var rowIndex = event.target.label;
        var cellName = event.target.name;
        var filteredRowIndex;
        for(var pi = 0; pi<this.productTableFilteredData.length; pi++){
            if(this.productTableFilteredData[pi].index == rowIndex){
                filteredRowIndex = pi;
                break;
            }
        }

        if(cellName == 'openInv'){
            this.productTableFilteredData[filteredRowIndex].tAvbStck = parseFloat(this.productTableFilteredData[filteredRowIndex].openInv) + parseFloat(this.productTableFilteredData[filteredRowIndex].ytdSale);
            this.productTableFilteredData[filteredRowIndex].liqYTD = parseFloat(this.productTableFilteredData[filteredRowIndex].tAvbStck) - parseFloat(this.productTableFilteredData[filteredRowIndex].totMrkInv);
            if(parseFloat(this.productTableFilteredData[filteredRowIndex].tAvbStck) == 0){
                this.productTableFilteredData[filteredRowIndex].liqYTDPer = 0;
            }else{
                this.productTableFilteredData[filteredRowIndex].liqYTDPer = parseFloat(this.productTableFilteredData[filteredRowIndex].liqYTD)/parseFloat(this.productTableFilteredData[filteredRowIndex].tAvbStck);
            }
        }else if((cellName == 'distInv') || (cellName == 'retInv')){
            this.productTableFilteredData[filteredRowIndex].totMrkInv = parseFloat(this.productTableFilteredData[filteredRowIndex].distInv) + parseFloat(this.productTableFilteredData[filteredRowIndex].retInv);
            this.productTableFilteredData[filteredRowIndex].liqYTD = ((this.productTableFilteredData[filteredRowIndex].tAvbStck) - (this.productTableFilteredData[filteredRowIndex].totMrkInv)).toFixed(2);
            if((this.productTableFilteredData[filteredRowIndex].tAvbStck) == 0){
                this.productTableFilteredData[filteredRowIndex].liqYTDPer = 0;
            }else{
                this.productTableFilteredData[filteredRowIndex].liqYTDPer = parseFloat(this.productTableFilteredData[filteredRowIndex].liqYTD)/(this.productTableFilteredData[filteredRowIndex].tAvbStck);
            } 
        }

        //error check
        var errorProdName = this.productTableFilteredData[filteredRowIndex].prodName+'('+this.productTableFilteredData[filteredRowIndex].prodCode+')';
        //validation check logic goes here - This does not make sense for MTD - Harsha
        /*if((parseFloat(this.productTableFilteredData[filteredRowIndex].liqYTD) < parseFloat(this.productTableFilteredData[filteredRowIndex].prevMntliqYTD)) && this.allowAllByPass != 'True'){   //By pass validation
            this.addProdToErrorProdList(errorProdName,'NonNegCase');
            this.errorTitle = 'Product wise liq cannot be less than last month YTD ';
            this.errorMessage = [];
            var errmsgJson = {
                                "msgKey" : 1,
                                "msg" : 'The Liquidation of '+errorProdName+' cannot be made less than YTD last month - ('+this.productTableFilteredData[filteredRowIndex].prevMntliqYTD+'), pls ensure necessary corrections and then proceed to submit.'
                            }
            this.errorMessage.push(errmsgJson);
            this.isShowErrorPopup = true;
            if(this.negLiqProdArray.length > 0){
                this.removeProdFromErrorProdList(errorProdName,'NegLiq');
            }
            //Temporary allowing user to edit Opening Inventory
            if((parseFloat(this.productTableFilteredData[filteredRowIndex].prevMntYtdSale) > parseFloat(this.productTableFilteredData[filteredRowIndex].ytdSale)) && AllowOpnInvEdit === 'True'){
                var ytdDiff = parseFloat((parseFloat(this.productTableFilteredData[filteredRowIndex].prevMntYtdSale) - parseFloat(this.productTableFilteredData[filteredRowIndex].ytdSale)).toFixed(2));
                var PrevTMI = parseFloat((parseFloat(this.productTableFilteredData[filteredRowIndex].prevMntDI) + parseFloat(this.productTableFilteredData[filteredRowIndex].prevMntRI)).toFixed(2));
                if(ytdDiff > PrevTMI){
                    this.productTableFilteredData[filteredRowIndex].isDisableOI = false;
                    this.isShowProdError = true;
                }
            }
        }
        else*/ if(parseFloat(this.productTableFilteredData[filteredRowIndex].liqYTD) < 0){
            this.addProdToErrorProdList(errorProdName,'NegLiq');
            this.errorTitle = 'Liquidation MTD cannot be negative ';
            this.errorMessage = [];
            var errmsgJson = {
                                "msgKey" : 1,
                                "msg" : 'Total market inventory cannot be greater than total available stock for '+errorProdName
                            }
            this.errorMessage.push(errmsgJson);
            this.isShowErrorPopup = true;
            if(this.errorProductArray.length > 0){
                this.removeProdFromErrorProdList(errorProdName,'NonNegCase');
            }
        }else{
            this.isShowErrorPopup = false;
            if(this.negLiqProdArray.length > 0){
                this.removeProdFromErrorProdList(errorProdName,'NegLiq');
            }else if(this.errorProductArray.length > 0){
                this.removeProdFromErrorProdList(errorProdName,'NonNegCase');
            }
            
        }
    }

    //add error product to list
    addProdToErrorProdList(prodName,errorSource){
        var count = 0;
        if(errorSource === 'NonNegCase'){
            if(this.errorProductArray.length > 0){
                for(var pi=0; pi<this.errorProductArray.length; pi++){
                    if(this.errorProductArray[pi] == prodName){
                        count++;
                    }
                }
                if(count == 0){
                    this.errorProductArray.push(prodName);
                }
            }else{
                this.errorProductArray.push(prodName);
            }
        }else if(errorSource === 'NegLiq'){ //Liquidation is negative but YTD sales is Positive
            if(this.negLiqProdArray.length > 0){
                for(var pi=0; pi<this.negLiqProdArray.length; pi++){
                    if(this.negLiqProdArray[pi] == prodName){
                        count++;
                    }
                }
                if(count == 0){
                    this.negLiqProdArray.push(prodName);
                }
            }else{
                this.negLiqProdArray.push(prodName);
            }
        }
    }

    //remove product from error product list
    removeProdFromErrorProdList(prodName,errorSource){
        if(errorSource === 'NonNegCase'){
            for(var pi=0; pi<this.errorProductArray.length; pi++){
                if(this.errorProductArray[pi] == prodName){
                    this.errorProductArray.splice(pi,1);
                }
            }
        }else if(errorSource === 'NegLiq'){ //Liquidation is negative but YTD sales is Positive
            for(var pi=0; pi<this.negLiqProdArray.length; pi++){
                if(this.negLiqProdArray[pi] == prodName){
                    this.negLiqProdArray.splice(pi,1);
                }
            }
        }
    }

    //handle Submit button click
    handleSubmitClick(event){
        //Loop through all table to check for neg liq value
        for(var i=0; i<this.productTableData.length; i++){
            this.productTableData[i].liqYTD = ((this.productTableData[i].tAvbStck) - (this.productTableData[i].totMrkInv)).toFixed(2);
            //error check
            var errProdName = this.productTableData[i].prodName+'('+this.productTableData[i].prodCode+')';
            if(parseFloat(this.productTableData[i].liqYTD) < 0){
                this.addProdToErrorProdList(errProdName,'NegLiq');
                if(this.errorProductArray.length > 0){
                    this.removeProdFromErrorProdList(errProdName,'NonNegCase');
                }
            
            }/*else if((parseFloat(this.productTableData[i].liqYTD) < parseFloat(this.productTableData[i].prevMntliqYTD)) && this.allowAllByPass != 'True'){   //By pass validation
                this.addProdToErrorProdList(errProdName,'NonNegCase');
                if(this.negLiqProdArray.length > 0){
                    this.removeProdFromErrorProdList(errProdName,'NegLiq');
                }
                //Temporary allowing user to edit Opening Inventory -- Update custom label AllowOpnInvEdit = 'True'
                if((this.productTableData[i].prevMntYtdSale > this.productTableData[i].ytdSale) && AllowOpnInvEdit === 'True'){
                    var ytdDiff = parseFloat((parseFloat(this.productTableData[i].prevMntYtdSale) - parseFloat(this.productTableData[i].ytdSale)).toFixed(2));
                    var PrevTMI = parseFloat((parseFloat(this.productTableData[i].prevMntDI) + parseFloat(this.productTableData[i].prevMntRI)).toFixed(2));
                    if(ytdDiff > PrevTMI){
                        this.productTableData[i].isDisableOI = false;
                        this.isShowProdError = true;
                    }
                }
            }*/else{
                if(this.negLiqProdArray.length > 0){
                    this.removeProdFromErrorProdList(errProdName,'NegLiq');
                }
                if(this.errorProductArray.length > 0){
                    this.removeProdFromErrorProdList(errProdName,'NonNegCase');
                }
            }
        }
        this.productTableFilteredData = this.productTableData;
        this.checkvalidation();
        if(this.liquidationuserrole == 'ZMM' && this.liqCurStatus == 'Pending for Approval'){
            this.dispatchEvent(new CustomEvent('editnapproveclick'));
        }
    }

    //handle crop wise breakup button click
    handleCropClick(){
        this.dispatchEvent(new CustomEvent('showcrp'));
    }

    //handle subModal Close click
    closeSubModal(event){
        if(this.liqCurStatus == 'Not Started'){
            this.isShowSubmit=true;
        }else{
            this.isShowSubmit=false;
        }

        this.isSubModalOpen = false;
    }

    //handle Sub modal Yes click
    submitProdLiquidation(event){
        this.isShowSubmit=false;
        this.isShowCropBreakup=true;
        this.isSubModalOpen = false;
        this.isDisableInv = true;
        this.hideProdSpinner = false;
        
        this.productTableData = this.productTableFilteredData;
        createProductLiquidation({
            prodLiqData : JSON.stringify(this.productTableData),
            liqMonth : this.liquidationmonth,
            liqFiscalYear : this.liquidationfiscalyear,
            liqTerrCode : this.liquidationterritory,
            liqStatus : this.liqCurStatus
        }).then(result =>{
            if (result == 'Success'){
                this.dispatchEvent(new CustomEvent('showcrop'));
            }
            this.hideProdSpinner = true;
        }).catch(error => {
            console.log('Something went wrong...'+error);
        })
    }

    //close error popup
    closeErrorPopup(){
        this.isShowErrorPopup = false;
    }

    //Check Validation
    checkvalidation(){
        if(this.searchKey == '' || this.searchKey == undefined){
            const allValid = [
                ...this.template.querySelectorAll('lightning-input'),
            ].reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
            if(allValid){
                //alert('All form entries look valid. Ready to submit!');
                if(this.errorProductArray.length == 0 && this.negLiqProdArray.length == 0){
                    this.isSubModalOpen = true;
                    this.isShowErrorPopup = false;
                }else{
                    var prdErrorMsg;
                    var negLiqYTDErrorMsg;
                    var negLiqErrorMsg;
                    var errorList = [];
                    /*if(this.errorProductArray.length > 0){
                        let msg = 'Please correct the liquidation calcualtion for following products : ';
                        prdErrorMsg = this.addErrorForProduct(this.errorProductArray,msg);
                        errorList.push({"msgKey" : 1,
                                    "msg" : prdErrorMsg});
                    }*/
                    if(this.negLiqProdArray.length > 0){
                        let msg = 'Please update the distributor/retailer inventory for following products to make Liquidation YTD non negative: ';
                        negLiqYTDErrorMsg = this.addErrorForProduct(this.negLiqProdArray,msg);
                        errorList.push({"msgKey" : 2,
                                    "msg" : negLiqYTDErrorMsg});
                    }
                   
                    this.errorTitle = 'Liquidation Submission Error';
                    this.errorMessage = [];
                    this.errorMessage = errorList;

                    this.isShowErrorPopup = true;
                }
            }else{
                var prdErrorMsg;
                var negLiqYTDErrorMsg;
                var negLiqErrorMsg;
                var errorList = [];
                
                errorList.push({"msgKey" : 1,
                                "msg" : 'Form entries cannot be blank or negative.'});
                if(this.errorProductArray.length > 0){
                    let msg = 'Please correct the liquidation calcualtion for following products : ';
                    prdErrorMsg = this.addErrorForProduct(this.errorProductArray,msg);
                    errorList.push({"msgKey" : 2,
                                "msg" : prdErrorMsg});
                }
                if(this.negLiqProdArray.length > 0){
                    let msg = 'Please update the distributor/retailer inventory for following products to make Liquidation MTD non negative: ';
                    negLiqYTDErrorMsg = this.addErrorForProduct(this.negLiqProdArray,msg);
                    errorList.push({"msgKey" : 3,
                                "msg" : negLiqYTDErrorMsg});
                }
                
                this.errorTitle = 'Liquidation Submission Error';
                this.errorMessage = [];
                this.errorMessage = errorList;
                this.isShowErrorPopup = true;
            }
        }else{
            this.errorTitle = 'Liquidation Submission Error';
            this.errorMessage = [];
                var errmsgJson = {
                                    "msgKey" : 1,
                                    "msg" : 'Please clear the search field before submitting.'
                                }
                this.errorMessage.push(errmsgJson);
            this.isShowErrorPopup = true;
        }
    }

    //Error message for product:
    addErrorForProduct(errorProdList, msgBody){
        var prodName='';
        errorProdList.forEach(function(prd){
            prodName = prd+', '+prodName;
        });
        var finalPrdList = prodName.slice(0,-2);
        let errorMsg = msgBody+finalPrdList;
        return errorMsg;
    }
}