import { LightningElement, track } from 'lwc';
import Id from '@salesforce/user/Id'; //To get user Id of logged in user
import fetchHeaderDetails from '@salesforce/apex/LiquidationSWALController.fetchHeaderDetails';

export default class LiquidationSWALContainerCmp extends LightningElement {

    @track hideSpinner = false;
    @track fiscalYear;
    @track territoryMap;
    @track userRole;
    @track isTmAvailableMap;
    @track isFmmHasRoleMap;
    @track isZmlHasRoleMap;
    showSWALHeader = false;

    connectedCallback(){
        //alert ('Logged in user is = '+Id);
        this.loggedInUserId = Id;
        fetchHeaderDetails({UserId : this.loggedInUserId}) 
        .then(result => {
            this.fiscalYear = result.FiscalYear;
            this.territoryMap = JSON.stringify(result.territoryMap);
            this.userRole = result.userRole;
            this.isTmAvailableMap = JSON.stringify(result.isTMAvailableMap);
            this.isFmmHasRoleMap = JSON.stringify(result.isFMMHasRoleMap);
            this.isZmlHasRoleMap = JSON.stringify(result.isZMLHasRoleMap);
            if(JSON.stringify(result.territoryMap).length == 2){
                this.showAfHeader = false;
                this.message = 'Dear User, Liquidation is not applicable for your territory. Please contact your admin';
            }else if((this.userRole == 'TM' || this.userRole == 'RM' || this.userRole == 'FMM' || this.userRole == 'ZML') && result.validLiqPeriod == true){
                this.showSWALHeader = true;
            }else if((this.userRole == 'TM' || this.userRole == 'RM' || this.userRole == 'FMM' || this.userRole == 'ZML') && result.validLiqPeriod == false){
                this.showSWALHeader = false;
                this.message = 'Liquidation has not yet started for this month. Please contact your admin';
            }else if(this.userRole == undefined){
                this.showSWALHeader = false;
                this.message = 'You donot have access to it. Please contact your admin';
            }
            this.hideSpinner = true;
        }).catch(error => {
            console.log('Something went wrong...'+error)
        });
    }
}