import { LightningElement,track, wire } from 'lwc';
import Id from '@salesforce/user/Id'; //To get user Id of logged in user
import fetchReportHeaderDetails from '@salesforce/apex/LiquidationReportAFSWALController.fetchReportHeaderDetails';

export default class LiquidationReportContainerCmp extends LightningElement {
    //All JS Variables goes here
    @track hideSpinner = false;
    @track fiscalYear;
    @track territoryZoneMap;
    @track userRole;
    @track userCountry;
    @track shwPrevFisYr;
    showReportHeader = false;
    result;
    error;

    @wire(fetchReportHeaderDetails,{
        UserId : Id
    })
    wiredResponse({error, data}){
        if(data){
            this.result = JSON.parse(data);
            this.fiscalYear = this.result.FiscalYear;
            this.shwPrevFisYr = this.result.shwPrvFisYear;
            this.territoryZoneMap = this.result.territoryZoneMap;
            this.userRole = this.result.userRole;
            this.userCountry = this.result.userCountry;
            this.hideSpinner = true;
            if(JSON.stringify(this.territoryZoneMap).length == 2){
                this.showReportHeader = false;
                this.message = 'Dear User, Liquidation is not applicable for your territory. Please contact your admin';
            }else if(this.userRole == 'TM-AF' || this.userRole == 'ZMM/ZM/ZSM-AF' || this.userRole == 'SBUH/SBUM-AF' || this.userRole == 'TM-SWAL' || this.userRole == 'RM-SWAL' || this.userRole == 'FMM-SWAL' || this.userRole == 'ZML-SWAL'){
                this.showReportHeader = true;
            }else{
                this.showReportHeader = false;
                this.message = 'You donot have access to it. Please contact your admin';
            }
        }else if(error){
            console.log('error = '+JSON.stringify(error));
        }
    }
}