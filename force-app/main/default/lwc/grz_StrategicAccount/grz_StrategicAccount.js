import { LightningElement, api, track, wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import getContactsRelatedToAccount from '@salesforce/apex/StrategicAccount.getContactsRelatedToAccount';
const columns = [

{ label: 'Name', fieldName: 'Name', type: 'text' },

{ label: 'Role', fieldName: 'Role__c', type: 'Text' },
{ label: 'Relationship', fieldName: 'Relationship__c', type: 'text' },
{ label: 'Relationship Goal', fieldName: 'Relationship_goals__c', type: 'text' },
{ label: 'Stages of Involvement', fieldName: 'Stages_of_involvement__c', type: 'text' },

];
export default class Grz_StrategicAccount  extends NavigationMixin(LightningElement) {

            @track isLoading = false;
            @api recordId;
            data = [];
            columns = columns;
            @track error;
            @track contactid = '';
            @track sumofpriority = '';
            @track conList ;
            @track Priority1 = '';
            @track Priority2 = '';
            @track Priority3= '';
            @track isContact = true;
            @track modalClass = 'slds-modal ';
            @track modalBackdropClass = 'slds-backdrop ';
            @api objectApiName; 

            @wire(getContactsRelatedToAccount,{ accId: "$recordId" }) getContactsRelatedToAccount({ error,data}) {
                console.log('--i m in--', data);
                if (data) 
                {
                console.log('i m in the if--');
                let contactData = JSON.parse(JSON.stringify(data));      
                console.log('contact--',contactData);
                this.conList = contactData ;
                } else if (error) {
                this.error = error;
                }
            }
            navigateToHome() {

                this[NavigationMixin.Navigate]({
                type: "standard__objectPage",
                attributes: {
                objectApiName: "Business_goals__c",
                actionName: "new"
                },
                state: {
                defaultFieldValues : "Key_customer_stakeholder__c="+this.contactid,
                nooverride: "1"

                }
                });
            }
            navigateToGoals()
            {
                this[NavigationMixin.Navigate]({
                type: "standard__objectPage",
                attributes: {
                objectApiName: "Business_goals__c",
                actionName: "list"
                },
                state: {
                filterName: "All"
                },
                });
            }

            navigateToRecordViewPage= event => {
                var selectedRows=event.detail.selectedRows;
                console.log('after one click--',selectedRows);
                if(selectedRows.length>1)
                {
                    var el = this.template.querySelector('lightning-datatable');

                    console.log('el.selectedRows--',el.selectedRows);

                    selectedRows=el.selectedRows=el.selectedRows.slice(1);
                    console.log('selectedRows ---', selectedRows);
                    this.contactid = selectedRows[0];

                }

                else if(selectedRows.length==1){
                    this.contactid = selectedRows[0].Id;


                }
                else if(this.conList.length == selectedRows.length){
                    this.showNotification();
                    event.preventDefault();
                    return;
                }
                else{
                    this.showNotification();
                    event.preventDefault();
                    return;
                }
                    console.log(' this.contactid ---', this.contactid );
            }
            showNotification() {
                const event = new ShowToastEvent({
                title: 'Warning',
                message: 'Only one row can be selected',
                variant: 'error',
                mode: 'pester'
                });
                this.dispatchEvent(event);
            }
            connectedCallback() {
                console.log('accountid--',this.recordId);

            }
            handleSubmit(event){
                this.isLoading = true;
            }
            handlePriority1(event) {
                this.Priority1 = event.target.value;
                console.log('priority 1---',this.Priority1);
            }
            handlePriority2(event) {
                this.Priority2 = event.target.value;
                console.log('priority 2---',this.Priority2);
            }
            handlePriority3(event) {
                this.Priority3 = event.target.value;
                console.log('priority 3---',this.Priority3);
            }
            handleSuccess(event) {
                this.isLoading = false;
                console.log('loading--1---'+this.isLoading);
                this.dispatchEvent(
                new ShowToastEvent({
                title: 'Success',
                message: ' Strategic '+ event.detail.apiName + ' updated.',

                variant: 'success',
                })
            );
                this.isLoading = false;
                console.log('loading--2--'+this.isLoading);
            }
            handleClick(event){
                console.log('Priority1---',this.Priority1);
                console.log('Priority2---',this.Priority2);
                this.sumofpriority = this.Priority1 + ','+ this.Priority2 + ','+ this.Priority3;
                console.log('sumofpri---',this.sumofpriority);
            }

        }