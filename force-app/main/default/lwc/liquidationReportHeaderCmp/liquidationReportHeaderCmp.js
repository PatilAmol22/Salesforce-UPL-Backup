import { api,wire,track, LightningElement } from 'lwc';
import { fireEvent, registerListener,unregisterAllListeners } from 'c/pubsub';
import { CurrentPageReference } from 'lightning/navigation';
import liquidationHeaderMessageLabel from '@salesforce/label/c.AF_and_SWAL_Liquidation_Header_Message_Label';
import liquidationHeaderValueMessage from '@salesforce/label/c.AF_and_SWAL_Liquidation_Header_Value_Message';
//import showPrevFiscalYearLabel from '@salesforce/label/c.showPrevFiscalYear';
const monthList = ["Apr","May","Jun","Jul","Aug","Sept","Oct","Nov","Dec","Jan","Feb","Mar"];

export default class LiquidationReportHeaderCmp extends LightningElement {
    //All custom Labels will go here
    label = {
        liquidationHeaderMessageLabel,
        liquidationHeaderValueMessage
    }
    @wire(CurrentPageReference) pageRef;
    //All JS Variables
    @api fiscalyear;
    @api terrzonemap;
    @api usrrole;
    @api usrcountry;
    @track zoneOptions=[];
    @track zoneOptionsValue;
    @track territoryOptions=[];
    @track territoryOptionsValue;
    @track fiscalYearOptions=[];
    @track fiscalOptionsValue;
    @track monthOptions=[];
    @track monthOptionsValue;
    showProdTable = true;
    showCropTable = false;
    @track headerMessage;
    @api shwPrevFisYr;

    connectedCallback(){
        this.headerMessage = liquidationHeaderMessageLabel;
        //Load header details
        //Populate Zones in dropdown starts here
        if(this.usrrole == 'TM-AF' || this.usrrole == 'ZMM/ZM/ZSM-AF' || this.usrrole == 'TM-SWAL' || this.usrrole == 'RM-SWAL' || this.usrrole == 'FMM-SWAL'){
            let options = [];
            const zoneNameArray = Object.keys(this.terrzonemap);
            if(zoneNameArray.length > 1){
                options.push({ label: 'All', value: 'All'});
                for (var key in this.terrzonemap) {
                    options.push({ label: key, value: key });
                }
                this.zoneOptions = options;
            }else{
                for (var key in this.terrzonemap) {
                    options.push({ label: key, value: key });
                }
                this.zoneOptions = options;
            }
        }else{
            let options = [];
            options.push({ label: 'All', value: 'All'});
            for (var key in this.terrzonemap) {
                options.push({ label: key, value: key });
            }
            this.zoneOptions = options;
        }
        this.zoneOptionsValue = this.zoneOptions[0].value;
        //Populate Zones in dropdown ends here

        //Populate Territories in dropdown starts here
        if(this.usrrole == 'TM-AF' || this.usrrole == 'TM-SWAL'){
            let options = [];
            for (var key in this.terrzonemap) {
                if(this.zoneOptionsValue === key){
                    for (var subkey in this.terrzonemap[key]){
                        for (var childkey in this.terrzonemap[key][subkey]) {
                            options.push({ label: childkey, value: this.terrzonemap[key][subkey][childkey]});
                        }
                    }
                }
            }
            this.territoryOptions = options;
        }else if(this.usrrole == 'ZMM/ZM/ZSM-AF' || this.usrrole == 'RM-SWAL' || this.usrrole == 'FMM-SWAL'){
            let options = [];
            options.push({ label: 'All', value: 'All'});
            for (var key in this.terrzonemap) {
                if(this.zoneOptionsValue === key){
                    for (var subkey in this.terrzonemap[key]){
                        for (var childkey in this.terrzonemap[key][subkey]) {
                            options.push({ label: childkey, value: this.terrzonemap[key][subkey][childkey]});
                        }
                    }
                }
            }
            this.territoryOptions = options;
        }else{
            
            let options = [];
            options.push({ label: 'All', value: 'All'});
            this.territoryOptions = options;
        }
        this.territoryOptionsValue = this.territoryOptions[0].value;
        //Populate Territories in dropdown ends here
        
        //Populate Fiscal Year in dropdown starts here
        const yearArray = this.fiscalyear.split('-');
        var fisYearArray = [];
        fisYearArray.push(this.fiscalyear);
        console.log(this.shwPrevFisYr);
        if(this.shwPrevFisYr == 'True'){
            fisYearArray.push((parseInt(yearArray[0])-1)+"-"+(parseInt(yearArray[1])-1));
        }
        let fisOptions = [];
        fisYearArray.forEach(function(fisYr){
            fisOptions.push({
                label: fisYr,
                value: fisYr
            });
        }) 
        this.fiscalYearOptions = fisOptions;
        this.fiscalOptionsValue = this.fiscalYearOptions[0].value;
        //Populate Fiscal Year in dropdown ends here

        //Populate Months in dropdown starts here
        const curDate = new Date();
        var curMnthIndex;
        let mntOptions = [];
        if(curDate.getMonth() <= 3){curMnthIndex = curDate.getMonth()+9;}
        else if(curDate.getMonth() > 3){curMnthIndex = curDate.getMonth()-3;}
        
        for(var ind =0; ind<curMnthIndex; ind++){
            mntOptions.push({
                label: monthList[ind],
                value: monthList[ind]
            });
        }
        this.monthOptions = mntOptions;
        this.monthOptionsValue = this.monthOptions[curMnthIndex-1].value;
        //Populate Months in dropdown ends here

        //pubsub handle
        if(!this.pageRef)
        {
            this.pageRef = {};
            this.pageRef.attributes = {};
            this.pageRef.attributes.LightningApp = "LightningApp";
        }
    }

    //handle zone change
    handleZoneChange(event){
        let options = [];
        options.push({ label: 'All', value: 'All'});
        this.zoneOptionsValue = event.detail.value;

        if (this.terrzonemap){
            for (var key in this.terrzonemap) {
                if (this.zoneOptionsValue === key) {
                    for (var subkey in this.terrzonemap[key]) {
                        for (var childkey in this.terrzonemap[key][subkey]) {
                            options.push({ label: childkey, value: this.terrzonemap[key][subkey][childkey]});
                        }
                    }
                    break;
                }
            }
        }
        this.territoryOptions = options;
        this.territoryOptionsValue = this.territoryOptions[0].value;

        fireEvent(this.pageRef,"liqZoneChangeEvent",this.zoneOptionsValue);
    }

    //handle territory change
    handleTerritoryChange(event){
        this.territoryOptionsValue = event.detail.value;

        fireEvent(this.pageRef,"liqTerritoryChangeEvent",this.territoryOptionsValue);
    }

    //handle fiscal year change
    handleFiscalYearChange(event){
        this.fiscalOptionsValue = event.detail.value;
        let options = [];
        if(this.fiscalOptionsValue !== this.fiscalyear){
            for(var ind =0; ind<12; ind++){
                options.push({
                    label: monthList[ind],
                    value: monthList[ind]
                });
            }
        }else{
            const curDate = new Date();
            var curMnthIndex;
            if(curDate.getMonth() <= 3){curMnthIndex = curDate.getMonth()+9;}
            else if(curDate.getMonth() > 3){curMnthIndex = curDate.getMonth()-3;}
            
            for(var ind =0; ind<curMnthIndex; ind++){
                options.push({
                    label: monthList[ind],
                    value: monthList[ind]
                });
            }
            let monthArray = [];
            for(var mi = 0; mi< options.length; mi++){
                monthArray.push(options[mi].value);
            }
            if(!monthArray.includes(this.monthOptionsValue)){
                this.monthOptionsValue = this.monthOptions[curMnthIndex-1].value;
            }
        }
        this.monthOptions = options;
        var param = {'FY' : this.fiscalOptionsValue, 'month' : this.monthOptionsValue};
        fireEvent(this.pageRef,"liqFiscalYearChangeEvent",param);
    }

    //handle month change
    handleMonthChange(event){
        this.monthOptionsValue = event.detail.value;

        fireEvent(this.pageRef,"liqMonthChangeEvent",this.monthOptionsValue);
    }

    //handle radio change event
    radioSelected(event){
        const radioOptValue = event.detail;
        if(radioOptValue === 'volume'){
            this.headerMessage = liquidationHeaderMessageLabel;
        }else if(radioOptValue === 'value'){
            this.headerMessage = liquidationHeaderValueMessage;
        }
    }

    //Open Crop table
    openCropTable(){
        this.showProdTable = false;
        this.showCropTable = true;
    }

    //open product table
    openProdTable(){
        this.showProdTable = true;
        this.showCropTable = false;
    }
}