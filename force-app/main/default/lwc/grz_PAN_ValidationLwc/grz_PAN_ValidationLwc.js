import { LightningElement, wire, api,track} from 'lwc';
import getPANData from "@salesforce/apex/Grz_PANGSTValidation.getPANData";
import getGSTData from "@salesforce/apex/Grz_PANGSTValidation.getGSTData";
import getGSTDataAgain from "@salesforce/apex/Grz_PANGSTValidation.getGSTDataAgain";
import updateNonGST from "@salesforce/apex/Grz_PANGSTValidation.updateNonGST";
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CloseActionScreenEvent } from 'lightning/actions';
import { getRecordNotifyChange } from "lightning/uiRecordApi";
import ProfileName from '@salesforce/schema/User.Profile.Name';
import { getRecord } from 'lightning/uiRecordApi';
import Id from '@salesforce/user/Id';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent } from 'lightning/flowSupport';

export default class Grz_PAN_Validation extends LightningElement {
    @api recordId;
    @api render1;
@track isLoading = true;
@track nonGSTOption = false;
@api strRecordId;
@api bttnType;
@track isTMOrAdmin=false;
@track disableSubmit=false;
currentPageReference = null; 
isMobile=false;
options = [
    { label: 'Yes', value: 'Yes' },
    { label: 'No', value: 'No' },
];

@track nonGstvalue = 'Yes';

renderedCallback() {
    this.render1 = this;
}
@track gstNumber='';
handleinputchange(event){
    var inputName=event.target.name;
        var inputValue=event.target.value;
        this[inputName]=inputValue;
        if(inputValue.length!=15 && inputValue.length!=0){
            this.disableSubmit=true;
        }
        else{
            this.disableSubmit=false;
        }
}

@track nonGstBoolean=false;
handleChange(event) {
    this.nonGstvalue = event.detail.value;
    console.log('Option selected with value: ' + this.nonGstvalue);
    if(this.nonGstvalue=='No'){
        this.nonGstBoolean=true;
    }
    else if(this.nonGstvalue=='Yes'){
        this.nonGstBoolean=false;
    }
}
@api
    async handleClick(){{
    this.isLoading = true;
    if(this.nonGstvalue=='Yes'){
        await updateNonGST({ recordId: this.recordId})
        .then((result) => {
            this.tostMsg( result, "info");
            this.isLoading = false;
    
        }).catch((error) => {
            console.log("----in error----", error);
        this.tostMsg(error, "error");
        this.isLoading = false;
        });
    }
       else if(this.nonGstvalue=='No' && this.gstNumber!=''){
        await getGSTDataAgain({ recordId: this.recordId,gstNumber:this.gstNumber})
        .then((result) => {
            this.tostMsg( result, "info");
            this.isLoading = false;
    
        }).catch((error) => {
            console.log("----in error----", error);
        this.tostMsg(error, "error");
        this.isLoading = false;
        });
       }
    else{
        this.tostMsg( 'Customer Updated successfully', "info");
        this.isLoading = false;
    }
    getRecordNotifyChange([{ recordId: this.recordId }]);
    }
}
@track buttonName;
@wire(CurrentPageReference)
getPageReferenceParameters(currentPageReference) {
    this.isLoading = true;
if (currentPageReference) {
    this.recordId = currentPageReference.state.recordId || null;
    console.log('currentPageReference==>',currentPageReference);
    this.buttonName=currentPageReference.attributes.apiName;
    console.log('currentPageReference===='+JSON.stringify(currentPageReference));
    console.log('currentPageReference.attribute====='+JSON.stringify(currentPageReference.attributes));
    if(this.buttonName===undefined){
        this.isMobile=true;
        this.recordId=this.strRecordId;
    }
}
}

@wire(getRecord, { recordId: Id, fields: [ ProfileName] })
        userDetails({ error, data }) {
            if (data) {
                if (data.fields.Profile.value != null) {
                    var profileName = data.fields.Profile.value.fields.Name.value;
                    if(profileName=='Territory Manager' || profileName=='Territory Manager SWAL' || profileName=='System Administrator'){
                        this.isTMOrAdmin=true;
                        if(this.buttonName=='Account.Validate_PAN' || this.buttonName=='Account.Validate_PAN_flow' || this.bttnType===false){
                            this.getPANData();
                        }
                        else if(this.buttonName=='Account.Validate_GST' || this.buttonName=='Account.GST_Validation' || this.bttnType===true){
                            this.getGSTData();
                        }
                    }
                    else{
                        this.tostMsg( 'This functionality is available for TMs and System Administrators only', "info");
                        this.isLoading=false;
                    }
                }
            }
        }

@api
    async getPANData() {
        await getPANData({ recordId: this.recordId })
    .then((result) => {
    this.isLoading = true;
    console.log('result ===> ',result);

    this.tostMsg( result, "info");
        this.isLoading = false;

    }).catch((error) => {
        console.log("----in error----", error);
    this.tostMsg(error, "error");
    this.isLoading = false;
    });
    getRecordNotifyChange([{ recordId: this.recordId }]);
}

@api
    async getGSTData() {
        await getGSTData({ recordId: this.recordId })
    .then((result) => {
    this.isLoading = true;
    this.nonGSTOption=false;
    console.log('result ===> ',result);
        if(result=='Non GST Status'){
            this.nonGSTOption=true;
        }
        else{
            //this.returnMessage = result;
            this.tostMsg( result, "info");
        }
        //this.errorMessage='';
        this.isLoading = false;

    }).catch((error) => {
        console.log("----in error----", error);
   //this.errorMessage = error;
   // this.returnMessage='';
    this.isLoading = false;
    this.tostMsg(error, "error");
    });
    getRecordNotifyChange([{ recordId: this.recordId }]);
}

tostMsg(msg, type) {
    const event = new ShowToastEvent({
        title: msg,
        variant: type,
    });
    this.dispatchEvent(event);
    this.closeQuickAction();
}

closeQuickAction() {
    //alert(this.recordId);
    this.dispatchEvent(new CloseActionScreenEvent());
    const navigateFinishEvent = new FlowNavigationFinishEvent();
        this.dispatchEvent(navigateFinishEvent);
       

}

}