import {api,track, LightningElement } from 'lwc';
import getTableData from '@salesforce/apex/LiquidationReportAFSWALController.getTableData';
import Id from '@salesforce/user/Id'; //To get user Id of logged in user

export default class LiquidationReportCropCmp extends LightningElement {
    //All JS Variable
    @api usrcountry;
    @api liquidationmonth;
    @api liquidationterritory;
    @api liquidationfiscalyear;
    @api liquidationuserrole;
    @api liquidationzone;
    hideCropSpinner = false;
    @track cropNameData = [];
    cropLiqVolTableData = [];
    cropLiqValTableDataCr = [];
    cropLiqValTableDataLk = [];

    @track cropLiqTableFilteredData = [];
    @track totalCropLiqData = [];
    totalcropLiqVolTable = [];
    totalcropLiqValTableCr = [];
    totalcropLiqValTableLk = [];

    searchKey;
    @track footerMessage;
    @track liqYTDColName;
    valVolValue = 'volume';
    valFigure = 'crores';
    isValue = false;
    errorMessage;
    showCropTable = true;

    totalYTD;
    totalCrop;
    totalYTDVol = 0.00;
    totalYTDCr = 0.00;
    totalYTDLk = 0.00;
    totalCropVol = 0.00;
    totalCropCr = 0.00;
    totalCropLk = 0.00;


    get valVolOptions() {
        return [
            { label: 'Data in Volume', value: 'volume' },
            { label: 'Data in Value', value: 'value' },
        ];
    }

    get valOptions(){
        return [
            { label: 'In Crores', value: 'crores' },
            { label: 'In Lakhs', value: 'lakhs' },   
        ];
    }

    //Onload action
    connectedCallback(){
        this.liqYTDColName = 'Liquidation MTD ('+this.liquidationmonth+')';

        // Creates the event with the radio value.
        const selectedEvent = new CustomEvent('radioonload', { detail: this.valVolValue });

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);

        getTableData({
            zone : this.liquidationzone, 
            territory : this.liquidationterritory, 
            fisyear : this.liquidationfiscalyear, 
            month : this.liquidationmonth,  
            usrCountry : this.usrcountry,
            usrId : Id,
            tableType : 'Crop'
        })
        .then(result => {
            if(result != null || result != undefined){
                var res = JSON.parse(result);
                //get crop name array
                for(var ci = 0 ; ci < res.liqCropList.length; ci++){
                    this.cropNameData.push(res.liqCropList[ci].Name);
                }

                //crop breakup data creation
                for(var pi = 0; pi < res.prodLiqList.length; pi ++){
                    var pYtdVol = 0;
                    var pYtdValCr = 0;
                    var pYtdValLk = 0;
                    for(var pai = 0; pai<res.prdAggLiqList.length; pai++){
                        if(res.prodLiqList[pi].Product__r.Product_Code__c == res.prdAggLiqList[pai].prdCde){
                            pYtdVol = res.prdAggLiqList[pai].prodLiqVal;
                            if((res.prodLiqList[pi].Product__r.Budget_NRV__c != null)||(res.prodLiqList[pi].Product__r.Budget_NRV__c !== undefined)){
                                pYtdValCr = ((res.prdAggLiqList[pai].prodLiqVal * res.prodLiqList[pi].Product__r.Budget_NRV__c)/10000000).toFixed(2);
                                pYtdValLk = ((res.prdAggLiqList[pai].prodLiqVal * res.prodLiqList[pi].Product__r.Budget_NRV__c)/100000).toFixed(2);
                            }    
                        }
                    }

                    let crpVolLiqArray = [];
                    let crpValLiqArrayCr = [];
                    let crpValLiqArrayLk = [];
                    var totalVol = 0;
                    var totalValCr = 0;
                    var totalValLk = 0;
                    
                    for(var ti = 0; ti < res.liqCropList.length; ti ++){
                        var isCropFound = false;
                        for(var cai = 0; cai < res.crpAggLiqList.length; cai++){
                            if(res.prodLiqList[pi].Product__r.Product_Code__c == res.crpAggLiqList[cai].prodCode){
                                    if(res.liqCropList[ti].Name == res.crpAggLiqList[cai].crpName){
                                        var crpVolJson = {
                                                    "crpName" : res.crpAggLiqList[cai].crpName,
                                                    "prdCode" : res.crpAggLiqList[cai].prodCode,
                                                    "curLiqValue" : res.crpAggLiqList[cai].crpLiqVal,
                                                    "crpIndex" : pi,
                                        }
                                        totalVol = totalVol + parseFloat(res.crpAggLiqList[cai].crpLiqVal.toFixed(2));
                                        var crpLiqValCr = 0.00;
                                        var crpLiqValLk = 0.00;
                                        if((res.prodLiqList[pi].Product__r.Budget_NRV__c != null)||(res.prodLiqList[pi].Product__r.Budget_NRV__c !== undefined)){
                                            crpLiqValCr = (res.crpAggLiqList[cai].crpLiqVal * res.prodLiqList[pi].Product__r.Budget_NRV__c)/10000000;
                                            crpLiqValLk = (res.crpAggLiqList[cai].crpLiqVal * res.prodLiqList[pi].Product__r.Budget_NRV__c)/100000;
                                        }
                                        var crpValJsonCr = {
                                            "crpName" : res.crpAggLiqList[cai].crpName,
                                            "prdCode" : res.crpAggLiqList[cai].prodCode,
                                            "curLiqValue" : parseFloat((crpLiqValCr).toFixed(2)),
                                            "crpIndex" : pi,
                                        } 
                                        var crpValJsonLk = {
                                            "crpName" : res.crpAggLiqList[cai].crpName,
                                            "prdCode" : res.crpAggLiqList[cai].prodCode,
                                            "curLiqValue" : parseFloat((crpLiqValLk).toFixed(2)),
                                            "crpIndex" : pi,
                                        } 
                                        totalValCr = totalValCr + parseFloat((crpLiqValCr).toFixed(2));   
                                        totalValLk = totalValLk + parseFloat((crpLiqValLk).toFixed(2));    
                                        crpVolLiqArray.push(crpVolJson);
                                        crpValLiqArrayCr.push(crpValJsonCr);
                                        crpValLiqArrayLk.push(crpValJsonLk);
                                        isCropFound = true;
                                        break;
                                    }else{
                                        isCropFound = false;
                                    }
                            }

                        }
                        if(!isCropFound){
                            var crpVolJson = {
                                "crpName" : res.liqCropList[ti].Name,
                                "prdCode" : res.prodLiqList[pi].Product__r.Product_Code__c,
                                "curLiqValue" : 0.00,
                                "crpIndex" : pi,
                            }
                                   
                            crpVolLiqArray.push(crpVolJson);
                            crpValLiqArrayCr.push(crpVolJson);
                            crpValLiqArrayLk.push(crpVolJson);
                        }
                    }
                    //Final table value
                    var liqVolJson = {
                                    "prdName" : res.prodLiqList[pi].Product__r.Name,
                                    "prdCode" : res.prodLiqList[pi].Product__r.Product_Code__c,
                                    "prdYTD" : pYtdVol,
                                    "rowIndex" : pi,
                                    "crpLidList" : crpVolLiqArray,
                                    "crpLiqTotal" : totalVol.toFixed(2),
                                    };
                    var liqValJsonCr = {
                                    "prdName" : res.prodLiqList[pi].Product__r.Name,
                                    "prdCode" : res.prodLiqList[pi].Product__r.Product_Code__c,
                                    "prdYTD" : pYtdValCr,
                                    "rowIndex" : pi,
                                    "crpLidList" : crpValLiqArrayCr,
                                    "crpLiqTotal" : totalValCr.toFixed(2),
                                     };
                    
                    var liqValJsonLk = {
                                        "prdName" : res.prodLiqList[pi].Product__r.Name,
                                        "prdCode" : res.prodLiqList[pi].Product__r.Product_Code__c,
                                        "prdYTD" : pYtdValLk,
                                        "rowIndex" : pi,
                                        "crpLidList" : crpValLiqArrayLk,
                                        "crpLiqTotal" : totalValLk.toFixed(2),
                                         };
                    
                    this.totalYTDVol+= pYtdVol;
                    this.totalCropVol+= parseFloat(totalVol);
                    this.totalYTDCr+= parseFloat(pYtdValCr);
                    this.totalYTDLk+= parseFloat(pYtdValLk);
                    this.totalCropCr+= parseFloat(totalValCr);
                    this.totalCropLk+= parseFloat(totalValLk);
                   

                    this.cropLiqVolTableData.push(liqVolJson);
                    this.cropLiqValTableDataCr.push(liqValJsonCr);
                    this.cropLiqValTableDataLk.push(liqValJsonLk);
                    this.cropLiqVolTableData.sort(this.getSortOrder("crpLiqTotal"));
                    this.cropLiqValTableDataCr.sort(this.getSortOrder("crpLiqTotal"));
                    this.cropLiqValTableDataLk.sort(this.getSortOrder("crpLiqTotal"));
                }
                let totalcropVolLiqArray = [];
                let totalcropValLiqArrayCr = [];
                let totalcropValLiqArrayLk = [];

                this.totalCropVol =0;
                for(var p = 0;p<this.cropLiqVolTableData.length;p++){
                    for(var r = 0;r<this.cropLiqVolTableData[p].crpLidList.length;r++){
                        
                        var cropLiq = this.cropLiqVolTableData[p].crpLidList[r];
                        this.totalCropVol+= (cropLiq.curLiqValue);
                        if(this.totalcropLiqVolTable.length>0){
                            for(var key in this.totalcropLiqVolTable){
                                if(this.totalcropLiqVolTable[key].crpName == cropLiq.crpName)
                                {
                                    this.totalcropLiqVolTable[key].curLiqValue+= cropLiq.curLiqValue;
                                    break;
                                }
                            }
                        }
                        else{
                            var liqVolJsonTotal = {
                                "crpName" : cropLiq.crpName,
                                "curLiqValue" : cropLiq.curLiqValue,
                                 };
                                 totalcropVolLiqArray.push(liqVolJsonTotal);
                        }
                    }
                    this.totalcropLiqVolTable = totalcropVolLiqArray;
                }

                for(var p = 0;p<this.cropLiqValTableDataCr.length;p++){
                    for(var r = 0;r<this.cropLiqValTableDataCr[p].crpLidList.length;r++){
                        var cropLiq = this.cropLiqValTableDataCr[p].crpLidList[r];
                        if(this.totalcropLiqValTableCr.length>0){
                            for(var key in this.totalcropLiqValTableCr){
                                if(this.totalcropLiqValTableCr[key].crpName == cropLiq.crpName)
                                {   
                                    this.totalcropLiqValTableCr[key].curLiqValue+= cropLiq.curLiqValue;
                                    this.totalcropLiqValTableCr[key].curLiqValue = parseFloat((this.totalcropLiqValTableCr[key].curLiqValue).toFixed(2));
                                    
                                    break;
                                }
                            }
                        }
                        else{
                            var liqVolJsonTotal = {
                                "crpName" : cropLiq.crpName,
                                "curLiqValue" : cropLiq.curLiqValue,
                                 };
                                 totalcropValLiqArrayCr.push(liqVolJsonTotal);
                        }
                    }
                    this.totalcropLiqValTableCr = totalcropValLiqArrayCr;
                    
                }


                for(var p = 0;p<this.cropLiqValTableDataLk.length;p++){
                    for(var r = 0;r<this.cropLiqValTableDataLk[p].crpLidList.length;r++){
                        var cropLiq = this.cropLiqValTableDataLk[p].crpLidList[r];
                        if(this.totalcropLiqValTableLk.length>0){
                            for(var key in this.totalcropLiqValTableLk){
                                if(this.totalcropLiqValTableLk[key].crpName == cropLiq.crpName)
                                {   
                                    this.totalcropLiqValTableLk[key].curLiqValue+= cropLiq.curLiqValue;
                                    this.totalcropLiqValTableLk[key].curLiqValue = parseFloat((this.totalcropLiqValTableLk[key].curLiqValue).toFixed(2));
                                    
                                    break;
                                }
                            }
                        }
                        else{
                            var liqVolJsonTotal = {
                                "crpName" : cropLiq.crpName,
                                "curLiqValue" : cropLiq.curLiqValue,
                                 };
                                 totalcropValLiqArrayLk.push(liqVolJsonTotal);
                        }
                    }
                    this.totalcropLiqValTableLk = totalcropValLiqArrayLk;
                    
                }

                this.totalCropVol = this.totalCropVol.toFixed(2);
                this.totalYTDVol = this.totalYTDVol.toFixed(2);
                this.totalCropCr = this.totalCropCr.toFixed(2);
                this.totalYTDCr = this.totalYTDCr.toFixed(2);
                this.totalCropLk = this.totalCropLk.toFixed(2);
                this.totalYTDLk = this.totalYTDLk.toFixed(2);

                if(this.valVolValue === 'volume'){
                    this.totalCrop = this.totalCropVol;
                    this.totalYTD = this.totalYTDVol;
                    this.totalCropLiqData = this.totalcropLiqVolTable;
                    this.cropLiqTableFilteredData = this.cropLiqVolTableData;
                }else if(this.valVolValue === 'value'){
                    this.totalCropLiqData = this.totalcropLiqValTableCr;
                    this.cropLiqTableFilteredData = this.cropLiqValTableDataCr;
                    this.totalCrop = this.totalCropCr;
                    this.totalYTD = this.totalYTDCr;
                }
                this.footerMessage = 'Showing '+this.cropLiqTableFilteredData.length+' of '+this.cropLiqVolTableData.length+' products';
            }
            this.hideCropSpinner = true;
            this.showCropTable = true;
        }).catch(error => {
            this.hideCropSpinner = true;
            this.showCropTable = false;
            console.log('Something went wrong...'+error);
            this.errorMessage =  'Dear User, There seems to be a large amount of data. Please try again by selecting single territory';
        })
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

    //Handle volume value radio button
    handleRadioChange(event){
        this.valVolValue = event.detail.value;
        this.searchKey = '';
        if(this.valVolValue === 'volume'){
            this.isValue = false;
            this.totalCrop = this.totalCropVol;
            this.totalYTD = this.totalYTDVol;
            this.totalCropLiqData = this.totalcropLiqVolTable;
            this.cropLiqTableFilteredData = this.cropLiqVolTableData;
        }else if(this.valVolValue === 'value'){
            this.isValue = true;
            this.totalCrop = this.totalCropCr;
            this.totalYTD = this.totalYTDCr;
            this.totalCropLiqData = this.totalcropLiqValTableCr;
            this.cropLiqTableFilteredData = this.cropLiqValTableDataCr;
            this.valFigure = 'crores';
        }

         // Creates the event with the radio value.
         const selectedEvent = new CustomEvent('radioselected', { detail: this.valVolValue });

         // Dispatches the event.
         this.dispatchEvent(selectedEvent);
    }
    handleValChange(event){
        this.valFigure = event.detail.value;
        if(this.valFigure == 'crores'){
            this.totalCrop = this.totalCropCr;
            this.totalYTD = this.totalYTDCr;
            this.totalCropLiqData = this.totalcropLiqValTableCr;
            this.cropLiqTableFilteredData = this.cropLiqValTableDataCr;
        }
        else if(this.valFigure == 'lakhs'){
            this.totalCrop = this.totalCropLk;
            this.totalYTD = this.totalYTDLk;
            this.totalCropLiqData = this.totalcropLiqValTableLk;
            this.cropLiqTableFilteredData = this.cropLiqValTableDataLk;
        }
    }

//handle search
handleSearch(event){
    this.searchKey = event.detail.value;
    var alltableData = [];
    if(this.valVolValue === 'volume'){
        alltableData = this.cropLiqVolTableData;
    }else if(this.valVolValue === 'value'){
        if(this.valFigure == 'crores'){
            alltableData = this.cropLiqValTableDataCr;
        }
        else if(this.valFigure == 'lakhs'){
            alltableData = this.cropLiqValTableDataLk;
        }
    }
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
        this.footerMessage = 'Showing '+this.cropLiqTableFilteredData.length+' of '+this.cropLiqVolTableData.length+' products';
    }else{
        if(this.valVolValue === 'volume'){
            this.cropLiqTableFilteredData = this.cropLiqVolTableData;
        }else if(this.valVolValue === 'value'){
            if(this.valFigure == 'crores'){
             this.cropLiqTableFilteredData = this.cropLiqValTableDataCr;
            }
            else if(this.valFigure == 'lakhs'){
                this.cropLiqTableFilteredData = this.cropLiqValTableDataLk;
            }
        }
        this.footerMessage = 'Showing '+this.cropLiqTableFilteredData.length+' of '+this.cropLiqVolTableData.length+' products';     
    }
}

    //Handle modal Close
    handleBackClick(event){
        this.dispatchEvent(new CustomEvent('showprd'));
    }
}