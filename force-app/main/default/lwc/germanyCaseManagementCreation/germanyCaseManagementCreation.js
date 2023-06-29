import { LightningElement,track} from 'lwc';

export default class GermanyCaseManagementCreation extends LightningElement {

    @track activeSections = ['General information', 'Product information', 'Treatments','Others'];
    @track treatmentList = [
       {
        Date:'',
        CropType:'',
        applicationRate:'',
        partner:'',
        waterQuantity:'',
        key:0
       } 

    ];
    @track index = 0;
    companyName='';
    Street='';
    Postcode='';
    State='';
    Telephone='';
    EditingStaff='';
    Visitson='';
    Product='';
    Charge='';
    broughtAt='';
    InvoiceAvaialble='';



    handleGeneralInformationChange()
    {

    }
    handleProductInformationChange()
    {
        
    }
    addRow(){
        ++this.index;
        var newItem = [{ id: this.index }];
        this.treatmentList = this.treatmentList.concat(newItem);
    }
    removeRow(event){
        this.isLoaded = true;
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        if(this.treatmentList.length>1){
            this.treatmentList.splice(key, 1);
            this.index--;
            this.isLoaded = false;
        }else if(this.treatmentList.length == 1){
            this.accountList = [];
            this.index = 0;
            this.isLoaded = false;
        }
    } 
    handleTreatmentChange()
    {

    }
    onFileUpload()
    {

    }
    handleSaveCases()
    {

    }
    handleCancel()
    {
        
    }
   
}