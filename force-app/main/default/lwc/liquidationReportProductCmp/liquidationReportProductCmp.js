import { api, LightningElement, track, wire } from 'lwc';
import { fireEvent, registerListener,unregisterListener } from 'c/pubsub';
import { CurrentPageReference } from 'lightning/navigation'; 
import getTableData from '@salesforce/apex/LiquidationReportAFSWALController.getTableData';
import NoCompletedLiquidationData from '@salesforce/label/c.NoCompletedLiquidationData';
import LiquidationDataNotFound from '@salesforce/label/c.LiquidationDataNotFound';
import Id from '@salesforce/user/Id';

export default class LiquidationReportProductCmp extends LightningElement {
    //custom Label
    label = {
        NoCompletedLiquidationData,
        LiquidationDataNotFound
    }

    @wire(CurrentPageReference) pageRef; 

    // All JS Variables are defined here
    @api usrcountry;
    @api liquidationmonth;
    @api liquidationterritory;
    @api liquidationfiscalyear;
    @api liquidationuserrole;
    @api liquidationzone;
    hideProdSpinner = false;
    productVolTableData = [];
    @track productTableFilteredData = [];
    productValTableDataCr = [];
    productValTableDataLk = [];
    searchKey;
    @track footerMessage;
    showProductTable = false;
    @track errorMessage;
    valVolValue = 'volume';
    totValOpenInv = 0;
    totValYtdSale = 0;
    totValtAvbStck = 0;
    totValDistInv = 0;
    totValRetInv = 0;
    totValTotMrkInv = 0;
    totValProdBud = 0;
    totValLiqYTD = 0;
    isValue=false;

    totVolOpenInv = 0;
    totVolYtdSale = 0;
    totVoltAvbStck = 0;
    totVolDistInv = 0;
    totVolRetInv = 0;
    totVolTotMrkInv = 0;
    totVolProdBud = 0;
    totVolLiqYTD = 0;
    valFigure = 'crores';

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

    //Onload Action
    connectedCallback(){  
        this.liquidationYTD = 'Liquidation MTD ' + this.liquidationmonth;
        this.liquidationPerYTD = 'Liquidation % MTD ' + this.liquidationmonth;

        // Creates the event with the radio value.
        const selectedEvent = new CustomEvent('radioonload', { detail: this.valVolValue });

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);

        //get product table data 
        this.getProdLiqData(this.liquidationzone, this.liquidationterritory, this.liquidationfiscalyear, this.liquidationmonth,  this.usrcountry);

        //handle pubsub
        if(!this.pageRef){
            this.pageRef = {};
            this.pageRef.attributes = {};
            this.pageRef.attributes.LightningApp = "LightningApp";
        }
        //pubsub listeners
        registerListener("liqZoneChangeEvent",this.reloadTableZone,this);
        registerListener("liqTerritoryChangeEvent",this.reloadTableTer,this);
        registerListener("liqFiscalYearChangeEvent",this.reloadTableFY,this);
        registerListener("liqMonthChangeEvent",this.reloadTableMnt,this);
    } 

    //handle zone change
    reloadTableZone(param){
        this.hideProdSpinner = false;
        this.liquidationzone = param;
        //get product table data 
        this.getProdLiqData(this.liquidationzone, this.liquidationterritory, this.liquidationfiscalyear, this.liquidationmonth,  this.usrcountry);
    }

    //handle territory change
    reloadTableTer(param){
        this.hideProdSpinner = false;
        this.liquidationterritory = param;
        //get product table data 
        this.getProdLiqData(this.liquidationzone, this.liquidationterritory, this.liquidationfiscalyear, this.liquidationmonth,  this.usrcountry);
    }

    //handle FY change
    reloadTableFY(param){
        this.hideProdSpinner = false;
        this.liquidationfiscalyear = param.FY;
        this.liquidationmonth = param.month;
        this.liquidationYTD = 'Liquidation MTD ' + this.liquidationmonth;
        this.liquidationPerYTD = 'Liquidation % MTD ' + this.liquidationmonth;
        //get product table data 
        this.getProdLiqData(this.liquidationzone, this.liquidationterritory, this.liquidationfiscalyear, this.liquidationmonth,  this.usrcountry);
    }

    //handle Month change
    reloadTableMnt(param){
        this.hideProdSpinner = false;
        this.liquidationmonth = param;
        this.liquidationYTD = 'Liquidation MTD ' + this.liquidationmonth;
        this.liquidationPerYTD = 'Liquidation % MTD ' + this.liquidationmonth;
        //get product table data 
        this.getProdLiqData(this.liquidationzone, this.liquidationterritory, this.liquidationfiscalyear, this.liquidationmonth,  this.usrcountry);
    }

    //get Product table data
    getProdLiqData(zone, territory, fisyear, month,  usrCountry){
        getTableData({
            zone : zone, 
            territory : territory, 
            fisyear : fisyear, 
            month : month,  
            usrCountry : usrCountry,
            usrId : Id,
            tableType : 'Product'
        })
        .then(result => {
            this.totValOpenInv = 0;
            this.totValYtdSale = 0;
            this.totValtAvbStck = 0;
            this.totValDistInv = 0;
            this.totValRetInv = 0;
            this.totValTotMrkInv = 0;
            this.totValProdBud = 0;
            this.totValLiqYTD = 0;

            this.totVolOpenInv = 0;
            this.totVolYtdSale = 0;
            this.totVoltAvbStck = 0;
            this.totVolDistInv = 0;
            this.totVolRetInv = 0;
            this.totVolTotMrkInv = 0;
            this.totVolProdBud = 0;
            this.totVolLiqYTD = 0;

            if(result != null && result != undefined){
                if(result == NoCompletedLiquidationData || result == LiquidationDataNotFound || result == 'Build in Progress'){
                    this.showProductTable = false;
                    this.errorMessage = result;
                }else{
                    var resvol = JSON.parse(result);
                    this.productVolTableData = resvol;
                    //sort product based on Total available stocks in descending order
                    this.productVolTableData.sort(this.getSortOrder("liqYTD"));
                    var resval = JSON.parse(result);
                    let resvalarrayCr = [];
                    let resvalarrayLk = [];
                    var total;
                    for(var pi = 0; pi < resval.length; pi++){
                        this.totVolOpenInv+= parseFloat(resval[pi].openInv);
                        this.totVolYtdSale+= parseFloat(resval[pi].ytdSale);
                        this.totVoltAvbStck+= parseFloat(resval[pi].tAvbStck);
                        this.totVolDistInv+= parseFloat(resval[pi].distInv);
                        this.totVolRetInv+= parseFloat(resval[pi].retInv);
                        this.totVolTotMrkInv+= parseFloat(resval[pi].totMrkInv);
                        this.totVolProdBud+= parseFloat(resval[pi].prodBud);
                        this.totVolLiqYTD+= parseFloat(resval[pi].liqYTD);

                        total = Object.assign({}, resval[pi]);
                        total.openInv = ((resval[pi].openInv*resval[pi].prodNRV)/100000).toFixed(2);
                        total.ytdSale = ((resval[pi].ytdSale*resval[pi].prodNRV)/100000).toFixed(2);
                        total.tAvbStck = (parseFloat(total.openInv) + parseFloat(total.ytdSale)).toFixed(2);
                        total.distInv = ((resval[pi].distInv*resval[pi].prodNRV)/100000).toFixed(2);
                        total.retInv = ((resval[pi].retInv*resval[pi].prodNRV)/100000).toFixed(2);
                        total.totMrkInv = (parseFloat(total.distInv) + parseFloat(total.retInv)).toFixed(2);
                        total.prodBud = ((resval[pi].prodBud*resval[pi].prodNRV)/10000000).toFixed(2);
                        total.liqYTD = parseFloat((parseFloat(total.tAvbStck) - parseFloat(total.totMrkInv)).toFixed(2));
                        if(total.tAvbStck == 0.00){
                            total.liqYTDPer = 0.00;
                        }else{
                            total.liqYTDPer = ((parseFloat(total.liqYTD)/parseFloat(total.tAvbStck))*100).toFixed(2);
                        }

                        resvalarrayLk.push(total);

                        resval[pi].openInv = ((resval[pi].openInv*resval[pi].prodNRV)/10000000).toFixed(2);
                        resval[pi].ytdSale = ((resval[pi].ytdSale*resval[pi].prodNRV)/10000000).toFixed(2);
                        resval[pi].tAvbStck = (parseFloat(resval[pi].openInv) + parseFloat(resval[pi].ytdSale)).toFixed(2);
                        resval[pi].distInv = ((resval[pi].distInv*resval[pi].prodNRV)/10000000).toFixed(2);
                        resval[pi].retInv = ((resval[pi].retInv*resval[pi].prodNRV)/10000000).toFixed(2);
                        resval[pi].totMrkInv = (parseFloat(resval[pi].distInv) + parseFloat(resval[pi].retInv)).toFixed(2);
                        resval[pi].prodBud = ((resval[pi].prodBud*resval[pi].prodNRV)/10000000).toFixed(2);
                        resval[pi].liqYTD = parseFloat((parseFloat(resval[pi].tAvbStck) - parseFloat(resval[pi].totMrkInv)).toFixed(2));
                        if(resval[pi].tAvbStck == 0.00){
                            resval[pi].liqYTDPer = 0.00;
                        }else{
                            resval[pi].liqYTDPer = ((parseFloat(resval[pi].liqYTD)/parseFloat(resval[pi].tAvbStck))*100).toFixed(2);
                        }
                        resvalarrayCr.push(resval[pi]);

                        
                        
                        this.totValOpenInv+= parseFloat(resval[pi].openInv);
                        this.totValYtdSale+= parseFloat(resval[pi].ytdSale);
                        this.totValtAvbStck+= parseFloat(resval[pi].tAvbStck);
                        this.totValDistInv+= parseFloat(resval[pi].distInv);
                        this.totValRetInv+= parseFloat(resval[pi].retInv);
                        this.totValTotMrkInv+= parseFloat(resval[pi].totMrkInv);
                        this.totValProdBud+= parseFloat(resval[pi].prodBud);
                        this.totValLiqYTD+= parseFloat(resval[pi].liqYTD);
                    }
                    this.totValOpenInv = this.totValOpenInv.toFixed(4);
                    this.totValYtdSale = this.totValYtdSale.toFixed(4);
                    this.totValtAvbStck = this.totValtAvbStck.toFixed(4);
                    this.totValDistInv = this.totValDistInv.toFixed(4);
                    this.totValRetInv = this.totValRetInv.toFixed(4);
                    this.totValTotMrkInv = this.totValTotMrkInv.toFixed(4);
                    this.totValProdBud = this.totValProdBud.toFixed(4);
                    this.totValLiqYTD = this.totValLiqYTD.toFixed(4);
                    
                    this.totVolOpenInv= parseFloat(this.totVolOpenInv.toFixed(2));
                    this.totVolYtdSale= parseFloat(this.totVolYtdSale.toFixed(2));
                    this.totVoltAvbStck= parseFloat(this.totVoltAvbStck.toFixed(2));
                    this.totVolDistInv= parseFloat(this.totVolDistInv.toFixed(2));
                    this.totVolRetInv= parseFloat(this.totVolRetInv.toFixed(2));
                    this.totVolTotMrkInv= parseFloat(this.totVolTotMrkInv.toFixed(2));
                    this.totVolProdBud= parseFloat(this.totVolProdBud.toFixed(2));
                    this.totVolLiqYTD= parseFloat(this.totVolLiqYTD.toFixed(2));

                    this.productValTableDataCr = resvalarrayCr;
                    this.productValTableDataLk = resvalarrayLk;
                    //sort product based on Total available stocks in descending order
                    this.productValTableDataCr.sort(this.getSortOrder("liqYTD"));
                    this.productValTableDataLk.sort(this.getSortOrder("liqYTD"));
                    if(this.valVolValue === 'volume'){
                        this.productTableFilteredData = this.productVolTableData;
                    }else if(this.valVolValue === 'value'){
                        this.productTableFilteredData = this.productValTableDataCr;
                    }
                    this.footerMessage = 'Showing '+this.productTableFilteredData.length+' of '+this.productVolTableData.length+' products';
                    this.showProductTable = true;
                }
            }else{
                this.showProductTable = false;
                this.errorMessage = result;
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

    //Handle volume value radio button
    handleRadioChange(event){
        this.valVolValue = event.detail.value;
        this.searchKey = '';
        if(this.valVolValue === 'volume'){
            this.isValue = false;
            this.productTableFilteredData = this.productVolTableData;
        }else if(this.valVolValue === 'value'){
            this.valFigure = 'crores';
            this.isValue= true;
            if(this.valFigure == 'crores'){
                this.productTableFilteredData = this.productValTableDataCr;
            }
            else if(this.valFigure == 'lakhs'){
                this.productTableFilteredData = this.productValTableDataLk;
            }
        }

         // Creates the event with the radio value.
         const selectedEvent = new CustomEvent('radioselected', { detail: this.valVolValue });

         // Dispatches the event.
         this.dispatchEvent(selectedEvent);
    }
    handleValChange(event){
        this.valFigure = event.detail.value;
        if(this.valFigure== 'crores'){
            this.productTableFilteredData = this.productValTableDataCr;
            this.totValOpenInv = (parseFloat(this.totValOpenInv)/100).toFixed(2);
            this.totValYtdSale = (parseFloat(this.totValYtdSale)/100).toFixed(2);
            this.totValtAvbStck = (parseFloat(this.totValtAvbStck)/100).toFixed(2);
            this.totValDistInv = (parseFloat(this.totValDistInv)/100).toFixed(2);
            this.totValRetInv = (parseFloat(this.totValRetInv)/100).toFixed(2);
            this.totValTotMrkInv = (parseFloat(this.totValTotMrkInv)/100).toFixed(2);
            this.totValProdBud = (parseFloat(this.totValProdBud)/100).toFixed(2);
            this.totValLiqYTD = (parseFloat(this.totValLiqYTD)/100).toFixed(2);
        }
        else if(this.valFigure == 'lakhs'){
            this.productValTableDataLk.sort(this.getSortOrder("liqYTD"));
            this.productTableFilteredData = this.productValTableDataLk;
            this.totValOpenInv = (parseFloat(this.totValOpenInv)*100).toFixed(2);
            this.totValYtdSale = (parseFloat(this.totValYtdSale)*100).toFixed(2);
            this.totValtAvbStck = (parseFloat(this.totValtAvbStck)*100).toFixed(2);
            this.totValDistInv = (parseFloat(this.totValDistInv)*100).toFixed(2);
            this.totValRetInv = (parseFloat(this.totValRetInv)*100).toFixed(2);
            this.totValTotMrkInv = (parseFloat(this.totValTotMrkInv)*100).toFixed(2);
            this.totValProdBud = (parseFloat(this.totValProdBud)*100).toFixed(2);
            this.totValLiqYTD = (parseFloat(this.totValLiqYTD)*100).toFixed(2);
        }
    }

    //handle search on table
    handleSearch(event){
        this.searchKey = event.detail.value;
        var allProdData = [];
        if(this.valVolValue === 'volume'){
            allProdData = this.productVolTableData;
        }else if(this.valVolValue === 'value'){
            if(this.valFigure == 'crores'){
                allProdData = this.productValTableDataCr;
            }
            else if(this.valFigure == 'lakhs'){
                allProdData = this.productValTableDataLk;
            }
        }
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
            this.footerMessage = 'Showing '+this.productTableFilteredData.length+' of '+this.productVolTableData.length+' products';
        }else{
            if(this.valVolValue === 'volume'){
                this.productTableFilteredData = this.productVolTableData;
            }else if(this.valVolValue === 'value'){
                if(this.valFigure == 'crores'){
                    this.productTableFilteredData = this.productValTableDataCr;
                }
                else if(this.valFigure == 'lakhs'){
                    this.productTableFilteredData = this.productValTableDataLk;
                }
            }
             
            this.footerMessage = 'Showing '+this.productTableFilteredData.length+' of '+this.productVolTableData.length+' products';
        }
    }

    //handle show crop wise breakup
    handleCropClick(){
        this.dispatchEvent(new CustomEvent('showcrp'));
    }
}