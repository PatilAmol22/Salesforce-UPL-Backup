import { api,wire, LightningElement, track } from 'lwc';
import getCropBreakupData from '@salesforce/apex/LiquidationAF.getCropBreakupData';
import createCropLiquidation from '@salesforce/apex/LiquidationAF.createCropLiquidation';
import cropwiseAggergateErrorLabel from '@salesforce/label/c.Crop_wise_greater_than_less_than_Product_wise';
import CropwiseSubmissionLabel from '@salesforce/label/c.Cropwise_Submission';
import AllowOthersCropEdit from '@salesforce/label/c.AllowOthersCropEdit';

export default class LiquidationAfCropCmp extends LightningElement {
    label = {cropwiseAggergateErrorLabel,
            CropwiseSubmissionLabel}
    //All JS Variable
    @api territorycode;
    @api fiscalyear;
    @api liqmonth;
    @api usrRole;
    @api isTmAvb;
    @api isEditAppClicked = false;
    searchKey;
    hideCropSpinner = false;
    isShowSubmit = true;
    @track liqYTDColName;
    @track cropNameData = [];
    @track cropLiqTableData = [];
    @track cropLiqTableFilteredData = [];
    @track cropLiqData = [];
    @track liqStatus;
    @track isDisableCrpField = false;
    isTMAvailable = true;
    @track footerMessage;
    @track cropErrorList = [];
    @track productErrorList = [];
    isShowErrorPopup = false;
    errorTitle;
    errorMessage = [];
    isSubModalOpen = false;
    isShowApproval = false;
    isShowRemarks = false;
    remarks;
    isShowAppPopup = false;
    isShowRejPopup = false;
    isDisbAppBtn = true;
    isAppClicked = false;
    @track allowAllByPass; //By pass validation

    connectedCallback(){
        this.liqYTDColName = 'Liquidation MTD ('+this.liqmonth+')';
        
        //get Crop Breakup data
        getCropBreakupData({
            territoryCode : this.territorycode,
            fisYear : this.fiscalyear,
            liqMonth : this.liqmonth
        })
        .then(result => {
            if(result != null && result != undefined){
                var res = JSON.parse(result);
                this.liqStatus = res.liqStatus;
                var isCropSub = res.isCrpSub;
                this.allowAllByPass = res.byCropPassValid;  //By pass validation
                //Handle enable and disable of the input field
                if(this.usrRole == 'TM'){
                    this.isShowApproval = false;
                    if(this.liqStatus == 'In Progress'){
                        this.isDisableCrpField = false;
                        this.isShowSubmit = true;
                    }else{
                        this.isDisableCrpField = true;
                        this.isShowSubmit = false;
                    }
                }else{
                    this.isTMAvailable = this.checkTm(this.territorycode);
                    if(this.liqStatus == 'In Progress' && this.isTMAvailable == false){
                        this.isDisableCrpField = false;
                        this.isShowApproval = false;
                        this.isShowSubmit = true;
                    }else if(this.liqStatus == 'Pending for Approval' && this.isTMAvailable == true){
                        this.isDisableCrpField = false;
                        this.isShowApproval = true;
                        this.isShowSubmit = false;
                        if(!this.isEditAppClicked){
                            this.isDisbEditnAppBtn = true;
                            this.isDisbAppBtn = false;
                        }else{
                            this.isDisbEditnAppBtn = false;
                            this.isDisbAppBtn = true;
                        }
                    }else{
                        this.isDisableCrpField = true;
                        this.isShowApproval = false;
                        this.isShowSubmit = false;
                    }
                }

                //Creating Crop Name Data
                for(var i=0; i < res.liqAfCropList.length ; i++){
                    this.cropNameData.push(res.liqAfCropList[i].Name);
                }
                var crpLiqTotal = 0;
                var balanceValue = 0;
                var crpLiqData = [];
                var crpNme = [];
                var prevMnthLiqYTD;
                //Creating Table  data
                for(var ti = 0; ti < res.afProdLiqList.length; ti ++){
                    crpLiqTotal = 0;
                    balanceValue = 0;
                    crpLiqData = [];
                    crpNme = [];
                    //Crop liq List for each Product
                    for(var ci = 0; ci < res.afCropLiqList.length; ci ++){
                        if(res.afCropLiqList[ci].Liquidation__r.Product__r.Product_Code__c == res.afProdLiqList[ti].Product__r.Product_Code__c){
                            if(!isCropSub){
                                var crpJson = {"crpLiqId" : '',
                                                "liqId" : res.afProdLiqList[ti].Id,
                                                "crpName" : res.afCropLiqList[ci].Crop__r.Name,
                                                "crpId" : res.afCropLiqList[ci].Crop__r.Id,
                                                "prdCode" : res.afCropLiqList[ci].Liquidation__r.Product__r.Product_Code__c,
                                                "curLiqValue" : res.afCropLiqList[ci].Liquidation_Value__c,
                                                "prevLiqValue" : res.afCropLiqList[ci].Liquidation_Value__c,
                                                "prodYTD" : res.afProdLiqList[ti].Liquidation_MTD_Trade__c,
                                                "prevMonthLiqYTD" : res.afCropLiqList[ci].Liquidation_MTD_Trade__c,
                                                "sortOrder" : res.afCropLiqList[ci].Crop__r.Crop_Order__c,
                                                "crpIndex" : ti
                                            };
                                crpNme.push(res.afCropLiqList[ci].Crop__r.Name); 
                                prevMnthLiqYTD = res.afCropLiqList[ci].Liquidation_MTD_Trade__c;           
                            }else{ //once Crop Liquidation is submitted
                                var crpJson = {"crpLiqId" : res.afCropLiqList[ci].Id,
                                                "liqId" : res.afProdLiqList[ti].Id,
                                                "crpName" : res.afCropLiqList[ci].Crop__r.Name,
                                                "crpId" : res.afCropLiqList[ci].Crop__r.Id,
                                                "prdCode" : res.afCropLiqList[ci].Liquidation__r.Product__r.Product_Code__c,
                                                "curLiqValue" : res.afCropLiqList[ci].Liquidation_Value__c,
                                                "prevLiqValue" : res.afCropLiqList[ci].Prev_Month_Crop_Liquidation_Volume__c, 
                                                "prodYTD" : res.afCropLiqList[ti].Liquidation_YTD_Trade__c,
                                                "prevMonthLiqYTD" : res.afCropLiqList[ci].Liquidation_YTD_Prev_Month__c,
                                                "sortOrder" : res.afCropLiqList[ci].Crop__r.Crop_Order__c,
                                                "crpIndex" : ti
                                            };
                                crpNme.push(res.afCropLiqList[ci].Crop__r.Name); 
                            }
                            crpLiqTotal = crpLiqTotal + parseFloat(res.afCropLiqList[ci].Liquidation_Value__c);
                            crpLiqData.push(crpJson);
                        }
                    }

                    //Handling new Crop Logic
                    if(crpNme.length != res.liqAfCropList.length){
                        res.liqAfCropList.forEach(function(crp){
                            if(!crpNme.includes(crp.Name)){
                                crpNme.push(crp.Name);
                                crpLiqData.push({
                                    "crpLiqId" : '',
                                    "liqId" : res.afProdLiqList[ti].Id,
                                    "crpName" : crp.Name,
                                    "crpId" : crp.Id,
                                    "prdCode" : res.afProdLiqList[ti].Product__r.Product_Code__c,
                                    "curLiqValue" : 0,
                                    "prevLiqValue" : 0,
                                    "prodYTD" : res.afProdLiqList[ti].Liquidation_MTD_Trade__c,
                                    "prevMonthLiqYTD" : prevMnthLiqYTD,
                                    "sortOrder" : crp.Crop_Order__c,
                                    "crpIndex" : ti
                                });
                            }
                        });
                    }

                    //Handle products with no past crop breakup
                    if(crpLiqData.length == 0){
                        res.liqAfCropList.forEach(function(crp){
                            if(!crpNme.includes(crp.Name)){
                                crpNme.push(crp.Name);
                                crpLiqData.push({
                                    "crpLiqId" : '',
                                    "liqId" : res.afProdLiqList[ti].Id,
                                    "crpName" : crp.Name,
                                    "crpId" : crp.Id,
                                    "prdCode" : res.afProdLiqList[ti].Product__r.Product_Code__c,
                                    "curLiqValue" : 0,
                                    "prevLiqValue" : 0,
                                    "prodYTD" : res.afProdLiqList[ti].Liquidation_MTD_Trade__c,
                                    "prevMonthLiqYTD" : 0,
                                    "sortOrder" : crp.Crop_Order__c,
                                    "crpIndex" : ti
                                });
                            }
                        });
                    }

                    //Sort logic for crops as their record index
                    crpLiqData.sort(this.getSortOrder("sortOrder"));

                    // calculate balance value
                    balanceValue = parseFloat(res.afProdLiqList[ti].Liquidation_MTD_Trade__c) - parseFloat(crpLiqTotal.toFixed(2));
                    //Final table value
                    var liqJson = {"liqId" : res.afProdLiqList[ti].Id,
                                    "prdName" : res.afProdLiqList[ti].Product__r.Name,
                                    "prdCode" : res.afProdLiqList[ti].Product__r.Product_Code__c,
                                    "prdYTD" : res.afProdLiqList[ti].Liquidation_MTD_Trade__c,
                                    "rowIndex" : ti,
                                    "crpLidList" : crpLiqData,
                                    "crpLiqTotal" : crpLiqTotal.toFixed(2),
                                    "balanceValue" : balanceValue.toFixed(2)};
                    this.cropLiqTableData.push(liqJson);
                    this.cropLiqData.push(crpLiqData); 
                }
                this.cropLiqTableFilteredData = this.cropLiqTableData;
            }
            this.footerMessage = 'Showing '+this.cropLiqTableFilteredData.length+' of '+this.cropLiqTableData.length+' products';
            this.hideCropSpinner = true;
        }).catch(error => {
            console.log('Something went wrong...'+error);
        })
    }

    //Compare/sort Function    
    getSortOrder(prop) {    
        return function(a, b) {    
            if (a[prop] > b[prop]) {    
                return 1;    
            } else if (a[prop] < b[prop]) {    
                return -1;    
            }    
            return 0;    
        }    
    }

    //Check TM availability in territory
    checkTm(terCode){
        const isTmJson = JSON.parse(this.isTmAvb);
        return isTmJson[terCode];
    }

    //handle search
    handleSearch(event){
        this.searchKey = event.detail.value;
        var alltableData = this.cropLiqTableData;
        var key = this.searchKey.toUpperCase();
        if(key != null || key != undefined){
            var tempArray = [];

            for(var i=0; i < alltableData.length; i++){
                if((alltableData[i].prdCode && alltableData[i].prdCode.toUpperCase().indexOf(key) != -1) ||
                (alltableData[i].prdName && alltableData[i].prdName.toUpperCase().indexOf(key) != -1 ) ||
                (alltableData[i].prdYTD && alltableData[i].prdYTD.toString().indexOf(key) != -1 )){
                    tempArray.push(alltableData[i]);
                }
            }
            this.cropLiqTableFilteredData = tempArray;
            this.footerMessage = 'Showing '+this.cropLiqTableFilteredData.length+' of '+this.cropLiqTableData.length+' products';
        }else{
            this.cropLiqTableFilteredData = this.cropLiqTableData;
            this.footerMessage = 'Showing '+this.cropLiqTableFilteredData.length+' of '+this.cropLiqTableData.length+' products';     
        }
    }

    //Handle cell change
    handleCellChange(event){
        this.isDisbEditnAppBtn = false;
        this.isDisbAppBtn = true;
    }

    //Handle on blur event on the table
    handleCellBlur(event){
        var crpName = event.target.name;
        var index = event.target.label;
        var crpValue = event.target.value;

        var filteredRowIndex;
        var totalCrpLiq = 0;
        var balanceval = 0;

        for(var pi = 0; pi<this.cropLiqTableFilteredData.length; pi++){
            if(this.cropLiqTableFilteredData[pi].rowIndex == index){
                filteredRowIndex = pi;
                break;
            }
        }

        for(var ind = 0; ind < this.cropLiqTableFilteredData[filteredRowIndex].crpLidList.length; ind++){
            if(this.cropLiqTableFilteredData[filteredRowIndex].crpLidList[ind].crpName == crpName){
                this.cropLiqTableFilteredData[filteredRowIndex].crpLidList[ind].curLiqValue = crpValue;
            
                // First validation Check
               /* if((parseFloat(this.cropLiqTableFilteredData[filteredRowIndex].prdYTD) < parseFloat(this.cropLiqTableFilteredData[filteredRowIndex].crpLidList[ind].prevMonthLiqYTD)) && this.allowAllByPass != 'True'){   //By pass validation
                    console.log('check 1 = '+this.allowAllByPass);
                    var liqYTDDiff = (parseFloat(this.cropLiqTableFilteredData[filteredRowIndex].crpLidList[ind].prevMonthLiqYTD) - parseFloat(this.cropLiqTableFilteredData[filteredRowIndex].prdYTD)).toFixed(2);
                    //Decimal Point check
                    var crpBrkUpDiff = ((parseFloat(this.cropLiqTableFilteredData[filteredRowIndex].crpLidList[ind].prevLiqValue) - parseFloat(this.cropLiqTableFilteredData[filteredRowIndex].crpLidList[ind].curLiqValue))).toFixed(2);
                    var crpPrdName = this.cropLiqTableFilteredData[filteredRowIndex].prdName+'('+this.cropLiqTableFilteredData[filteredRowIndex].prdCode+')'+'-'+this.cropLiqTableFilteredData[filteredRowIndex].crpLidList[ind].crpName;
                    if(parseFloat(crpBrkUpDiff) > parseFloat(liqYTDDiff)){
                        this.addCropToErrorCropList(crpPrdName);
                        this.errorTitle = 'Crop Breakup Error';
                        this.errorMessage = [];
                        var errmsgJson = {
                                            "msgKey" : 1,
                                            "msg" : 'Crop breakup for '+this.cropLiqTableFilteredData[filteredRowIndex].crpLidList[ind].crpName+' for '+this.cropLiqTableFilteredData[filteredRowIndex].prdName+' cannot be decreased less than by '+liqYTDDiff+' from its previous month value of : '+this.cropLiqTableFilteredData[filteredRowIndex].crpLidList[ind].prevLiqValue
                                        }
                        this.errorMessage.push(errmsgJson);
                        this.isShowErrorPopup = true;
                    }else{
                        this.removeCropFromErrorCropList(crpPrdName);
                        this.isShowErrorPopup = false;
                    }
                }else if((parseFloat(this.cropLiqTableFilteredData[filteredRowIndex].prdYTD) >= parseFloat(this.cropLiqTableFilteredData[filteredRowIndex].crpLidList[ind].prevMonthLiqYTD)) && this.allowAllByPass != 'True'){   //By pass validation
                    console.log('check 2 = '+this.allowAllByPass);
                    var crpPrdName = this.cropLiqTableFilteredData[filteredRowIndex].prdName+'-'+this.cropLiqTableFilteredData[filteredRowIndex].crpLidList[ind].crpName;
                    if(AllowOthersCropEdit != this.cropLiqTableFilteredData[filteredRowIndex].crpLidList[ind].crpName){
                    if(parseFloat(this.cropLiqTableFilteredData[filteredRowIndex].crpLidList[ind].prevLiqValue) > parseFloat(this.cropLiqTableFilteredData[filteredRowIndex].crpLidList[ind].curLiqValue)){
                        this.addCropToErrorCropList(crpPrdName);
                            this.errorTitle = 'Crop Breakup Error';
                        this.errorMessage = [];
                        var errmsgJson = {
                                            "msgKey" : 1,
                                                "msg" : 'Crop breakup for '+this.cropLiqTableFilteredData[filteredRowIndex].crpLidList[ind].crpName+' for '+this.cropLiqTableFilteredData[filteredRowIndex].prdName+' cannot be made less than previous month value of : '+this.cropLiqTableFilteredData[filteredRowIndex].crpLidList[ind].prevLiqValue
                                        }
                        this.errorMessage.push(errmsgJson);
                        this.isShowErrorPopup = true;
                    }else{
                        this.removeCropFromErrorCropList(crpPrdName);
                        this.isShowErrorPopup = false;
                        }
                    }
                }*/
            }
            totalCrpLiq = parseFloat(totalCrpLiq) + parseFloat(this.cropLiqTableFilteredData[filteredRowIndex].crpLidList[ind].curLiqValue);
            
        }
        totalCrpLiq = totalCrpLiq.toFixed(2);
        balanceval = parseFloat(this.cropLiqTableFilteredData[filteredRowIndex].prdYTD) - parseFloat(totalCrpLiq);
        //balanceval = balanceval.toFixed(2);
        this.cropLiqTableFilteredData[filteredRowIndex].crpLiqTotal = totalCrpLiq;
        this.cropLiqTableFilteredData[filteredRowIndex].balanceValue = balanceval.toFixed(2);

        //Second Validation : Liquidation YTD of Current month should be equal to Total
        var errPrdName = this.cropLiqTableFilteredData[filteredRowIndex].prdName+'('+this.cropLiqTableFilteredData[filteredRowIndex].prdCode+')';
        if(parseFloat(this.cropLiqTableFilteredData[filteredRowIndex].crpLiqTotal) != parseFloat(this.cropLiqTableFilteredData[filteredRowIndex].prdYTD)){
            this.addProdToErrorProdList(errPrdName);
        }else{
            this.removeProdFromErrorProdList(errPrdName);
        }
    }

    //add error product to list
    addProdToErrorProdList(prodName){
        var count = 0;
        if(this.productErrorList.length > 0){
            for(var pi=0; pi<this.productErrorList.length; pi++){
                if(this.productErrorList[pi] == prodName){
                    count++;
                }
            }
            if(count == 0){
                this.productErrorList.push(prodName);
            }
        }else{
            this.productErrorList.push(prodName);
        }
    }

    //remove product from error product list
    removeProdFromErrorProdList(prodName){
            for(var pi=0; pi<this.productErrorList.length; pi++){
                if(this.productErrorList[pi] == prodName){
                    this.productErrorList.splice(pi,1);
                }
            }
    }

    //add error Crop to list
    /*addCropToErrorCropList(cropName){
        var count = 0;
        if(this.cropErrorList.length > 0){
            for(var pi=0; pi<this.cropErrorList.length; pi++){
                if(this.cropErrorList[pi] == cropName){
                    count++;
                }
            }
            if(count == 0){
                this.cropErrorList.push(cropName);
            }
        }else{
            this.cropErrorList.push(cropName);
        }
    }

    //remove crop from error crop list
    removeCropFromErrorCropList(cropName){
        for(var pi=0; pi<this.cropErrorList.length; pi++){
            if(this.cropErrorList[pi] == cropName){
                this.cropErrorList.splice(pi,1);
            }
        }
    }*/

    //Handle crop liquidation submit
    handleSubmitClick(event){
        //check all product list to confirm if liq YTD for month and total are same
        this.getErrorProductList();
        this.checkvalidation();
    }

    //handle Edit and Approval click
    handleEditApprovalClick(){
        this.isShowAppPopup = false;
        //check all product list to confirm if liq YTD for month and total are same
        this.getErrorProductList();
        this.checkvalidation();
        this.isShowRemarks = true;
    }

    //check for all crops and products
    getErrorProductList(){
        for(var i = 0; i < this.cropLiqTableFilteredData.length; i++){
            var errPrdName = this.cropLiqTableFilteredData[i].prdName+'('+this.cropLiqTableFilteredData[i].prdCode+')';
            if(parseFloat(this.cropLiqTableFilteredData[i].prdYTD) !== parseFloat(this.cropLiqTableFilteredData[i].crpLiqTotal)){
                this.addProdToErrorProdList(errPrdName);
            }else{
                this.removeProdFromErrorProdList(errPrdName);
            }
        }
    }

    //Handle remark change
    handleRemarkChange(event){
        this.remarks = event.target.value;
    }

    //Handle modal Close
    handleBackClick(event){
        this.dispatchEvent(new CustomEvent('showprd'));
    }

    //hanlde No in popup
    closeSubModal(){
        this.isSubModalOpen = false;
    }

    //handle Yes in popup
    submitCropLiquidation(){
        this.hideCropSpinner = false;
        this.isSubModalOpen = false;
        //submit the crop data for DML
        this.cropLiqTableData = this.cropLiqTableFilteredData;
        var cropFinalList = [];
        for(var i=0; i<this.cropLiqTableData.length; i++){
            for(var x = 0; x < this.cropLiqTableData[i].crpLidList.length; x++ ){
                cropFinalList.push(this.cropLiqTableData[i].crpLidList[x]);
            }
        }
        createCropLiquidation({
            cropLiqData : JSON.stringify(cropFinalList), 
            territoryCode : this.territorycode, 
            fiscalYear : this.fiscalyear, 
            liqMonth : this.liqmonth, 
            liqStatus : this.liqStatus, 
            userRole : this.usrRole, 
            remarks : this.remarks
        })
        .then(result => {
            this.hideCropSpinner = true;
            this.dispatchEvent(new CustomEvent('showprod'));
        }).catch(error => {
            console.log('Something went wrong...'+error);
        })
        this.isShowSubmit = false;
    }

    //handle close error popup event
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
                if(this.productErrorList.length == 0 ){ //&& this.cropErrorList.length == 0){
                    if(this.isAppClicked){
                        this.isShowAppPopup = true;
                    }else{
                        this.isSubModalOpen = true;
                    }
                    this.isShowErrorPopup = false;
                }else{
                        var prdErrMsg;
                        var crpErrMsg;
                        var errorList = [];
                        if(this.productErrorList.length > 0){
                            prdErrMsg = this.addErrorForProduct(this.productErrorList, cropwiseAggergateErrorLabel);
                            errorList.push({"msgKey" : 1,
                                            "msg" : prdErrMsg});
                        }
                        /*if(this.cropErrorList.length > 0){
                            let msg = 'Cropwise breakups are not correctly updated for following Products : ';
                            crpErrMsg = this.addErrorForProductCrop(this.cropErrorList,msg);
                            errorList.push({"msgKey" : 2,
                                            "msg" : crpErrMsg});
                        }*/
                        this.errorTitle = 'Liquidation Submission Error';
                        this.errorMessage = [];
                        this.errorMessage = errorList;
                    this.isShowErrorPopup = true;
                }
            }else{
                var prdErrMsg;
                var crpErrMsg;
                var errorList = [];

                errorList.push({"msgKey" : 1,
                                "msg" : 'Form entries cannot be blank or negative.'});
                
                if(this.productErrorList.length > 0){
                    prdErrMsg = this.addErrorForProduct(this.productErrorList, cropwiseAggergateErrorLabel);
                    errorList.push({"msgKey" : 2,
                                    "msg" : prdErrMsg});
                }
                /*if(this.cropErrorList.length > 0){
                    let msg = 'Cropwise breakups are not correctly updated for following crops : ';
                    crpErrMsg = this.addErrorForProductCrop(this.cropErrorList,msg);
                    errorList.push({"msgKey" : 2,
                                    "msg" : crpErrMsg});
                }*/
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

    //Error message for product-crop:
    /*addErrorForProductCrop(errorProdCrpList, msgBody){
        var prodName='';
        errorProdCrpList.forEach(function(crp){
            const prdArray = crp.split("-");
            if(!prodName.includes(prdArray[0])){
                prodName = prdArray[0]+', '+prodName;
            }
        });
        var finalPrdList = prodName.slice(0,-2);
        let errorMsg = msgBody+finalPrdList;
        return errorMsg;
    }*/

    //close approval popup
    closeAppPopup(){
        this.isAppClicked = false;
        this.isShowAppPopup = false;
    }

    //close reject popup
    closeRejPopup(){
        this.isShowRejPopup = false;
    }

    //handle approval button click
    handleApprovalClick(){
        this.isAppClicked = true;
        //check all product list to confirm if liq YTD for month and total are same
        this.getErrorProductList();
        this.checkvalidation();
    }

    //handle Reject button click
    handleRejectClick(){
        this.isShowRejPopup = true;
    }

    //dispatch event for app and rej action
    showprodTable(){
        this.dispatchEvent(new CustomEvent('shwprodforapprej'));
    }
}