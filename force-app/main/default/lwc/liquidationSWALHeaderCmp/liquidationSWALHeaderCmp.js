import { api, LightningElement, track, wire } from 'lwc';
import { fireEvent, registerListener,unregisterListener } from 'c/pubsub';
import { CurrentPageReference } from 'lightning/navigation';
import liquidationHeaderMessageLabel from '@salesforce/label/c.AF_and_SWAL_Liquidation_Header_Message_Label';
const monthList = ["Apr","May","Jun","Jul","Aug","Sept","Oct","Nov","Dec","Jan","Feb","Mar"];

export default class LiquidationSWALHeaderCmp extends LightningElement {
    //All custom Labels will go here
    label = {
        liquidationHeaderMessageLabel
    }

    @wire(CurrentPageReference) pageRef;

    // All JS variables defined here
    @api fiscalyear;
    @api terrmap;
    @api usrrole;
    @api istmavbmap;
    @api isfmmrolemap;
    @api iszmlrolemap;
    @track territoryOptions=[];
    @track territoryOptionsValue;
    @track territoryOptionsLabel;
    @track fiscalYearOptions=[];
    @track fiscalOptionsValue;
    @track monthOptions=[];
    @track monthOptionsValue;
    @track liquidationStage = '1';
    loggedInUserId;
    showProdTable = true;
    showCropTable = false;
    @track isEditnAppClicked = false;
    isCropView = false;
    showProgressBar = true;

    //Onload Action
    connectedCallback(){
        //Load header details
        //Populate Territories in dropdown starts here
        const terrJson = JSON.parse(this.terrmap);
        const territoryNameArray = Object.keys(terrJson);
        for(var ti = 0; ti < territoryNameArray.length; ti++){
            const terOption = {
                label: territoryNameArray[ti],
                value: terrJson[territoryNameArray[ti]]
            };
            this.territoryOptions.push(terOption);
        }
        this.territoryOptionsValue = this.territoryOptions[0].value;
		this.territoryOptionsLabel = this.territoryOptions[0].label;
        //Populate Territories in dropdown ends here
        
        //Populate Fiscal Year in dropdown starts here
            const fyOption = {
                label: this.fiscalyear,
                value: this.fiscalyear
            };
            this.fiscalYearOptions.push(fyOption);
        this.fiscalOptionsValue = this.fiscalYearOptions[0].value;
        //Populate Fiscal Year in dropdown ends here

        //Populate Months in dropdown starts here
        const curDate = new Date();
        var curMnthIndex;
        if(curDate.getMonth() <= 3){curMnthIndex = curDate.getMonth()+9;}
        else if(curDate.getMonth() > 3){curMnthIndex = curDate.getMonth()-3;}
        const mntOption = {
            label: monthList[curMnthIndex-1],
            value: monthList[curMnthIndex-1]
        };
        this.monthOptions.push(mntOption);
        this.monthOptionsValue = this.monthOptions[0].value;
        //Populate Months in dropdown ends here

        if(!this.pageRef)
        {
            this.pageRef = {};
            this.pageRef.attributes = {};
            this.pageRef.attributes.LightningApp = "LightningApp";
        }
        //listen to events
        registerListener("liqApprovalStatusEvent",this.updateProgressBarStatus,this);
    }
    
    //Handle change in Territory List
    handleTerritoryChange(event){
        //alert("You have selected = "+event.detail.value);
        this.territoryOptionsValue = event.detail.value;
        this.territoryOptionsLabel = event.detail.label;
        fireEvent(this.pageRef,"liqTerritoryChangeEvent",this.territoryOptionsValue);
    }

    //handle progress bar status
    updateProgressBarStatus(param){
        var liqStatus = param;
        if(liqStatus == 'Pending for Approval'){
            this.liquidationStage = '2';
        }else if(liqStatus == 'Approved' || liqStatus == 'Edit and Approved'){
            this.liquidationStage = '3';
        }else{
            this.liquidationStage = '1';
        }
    }

    //Temp button will remove
    handleNext() {
        var getselectedStep = this.liquidationStage;
        if(getselectedStep === '1'){
            this.liquidationStage = '2';
        }
        else if(getselectedStep === '2'){
            this.liquidationStage = '3';
        }
    }

    openCropTable(){
        this.showProdTable = false;
        this.showCropTable = true;
        this.isCropView = true;
    }

    //open product table
    openProdTable(){
        this.showProdTable = true;
        this.showCropTable = false;
        this.isCropView = false;
    }

    //Edit and Approve click check in product Table
    updateEditnAppCheck(){
        this.isEditnAppClicked = true;
    }

    handleHideProgressBar(){
        this.showProgressBar = false;
    }

    handleShowProgressBar(){
        this.showProgressBar = true;
    }
}