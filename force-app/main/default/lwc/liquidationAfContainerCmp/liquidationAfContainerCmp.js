import { LightningElement, track } from 'lwc';
import Id from '@salesforce/user/Id'; //To get user Id of logged in user
import fetchHeaderDetails from '@salesforce/apex/LiquidationAF.fetchHeaderDetails';

export default class LiquidationAfContainerCmp extends LightningElement {
    @track hideSpinner = false;
    @track fiscalYear;
    @track territoryMap;
    @track userRole;
    @track isTmAvailableMap;
    @track isZsmRoleMp;
    showAfHeader = false;

    connectedCallback(){
        this.loggedInUserId = Id;
        fetchHeaderDetails({UserId : this.loggedInUserId}) 
        .then(result => {
            this.fiscalYear = result.FiscalYear;
            this.territoryMap = JSON.stringify(result.territoryMap);
            this.userRole = result.userRole;
            this.isTmAvailableMap = JSON.stringify(result.isTMAvailableMap);
            this.isZsmRoleMp = JSON.stringify(result.isZSMRoleMap);
            if(JSON.stringify(result.territoryMap).length == 2){
                this.showAfHeader = false;
                this.message = 'Dear User, Liquidation is not applicable for your territory. Please contact your admin';
            }else if((this.userRole == 'TM' || this.userRole == 'ZMM' || this.userRole == 'ZSM') && result.validLiqPeriod == true){
                this.showAfHeader = true;
            }else if((this.userRole == 'TM' || this.userRole == 'ZMM' || this.userRole == 'ZSM') && result.validLiqPeriod == false){
                this.showAfHeader = false;
                this.message = 'Dear User, Liquidation has not yet started for this month. Please contact your admin';
            }else if(this.userRole == undefined){
                this.showAfHeader = false;
                this.message = 'Dear User, You donot have access to it. Please contact your admin';
            }
            this.hideSpinner = true;
        }).catch(error => {
            console.log('Something went wrong...'+error)
        });
    }
}