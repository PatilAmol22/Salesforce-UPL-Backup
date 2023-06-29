import { api, LightningElement,wire,track } from 'lwc';
import getApprovalConfiguration from '@salesforce/apex/ApprovalInterface.getApprovalConfiguration';
import Search from '@salesforce/label/c.Search';

export default class CaiChildComp extends LightningElement {
 
    _sObjectFields=[];
     _filters={
        sobject:'',
        stage:''
    }
    set filters(value){
        let val = JSON.parse(JSON.stringify(value));
        console.log('Val From Parent ',val);
       this._filters=val;
    
       this.sobject=val.sobject?val.sobject:'';

       this.stage=val.stage?val.stage:'';
    }
    @api get filters(){
        return this._filters;
    }
    selectedFields='';
    sobject='';
    stage='';
    SearchField;
    searchValue;
    initialRecords=[];
    inputDisabled = true;

    labels = {
      Search:Search
    }


    @wire(getApprovalConfiguration , {selectedObject:'$sobject', selectedStage:'$stage'})

     getObjectApprovalConfiguration({data,error}){
        if(data){
            console.log('data column1',data);
          data=JSON.parse(data);
            let array = [];
            for(let i=0;i<data.length-1;i++){
                array.push({ label: data[i].label, value: data[i].fieldName });
            }
            this._sObjectFields = array;
            console.log('sobjectFeild' ,this._sObjectFields);
        }
        if(error){
            console.log('error ',error);
        }
    };


    renderedCallback(){
        console.log( 'filterObject',this.filters.sobject,this.filters.stage);
    }

  connectedCallback(){
   this.stage=this.filters.stage;
   this.sobject=this.filters.sobject;
   this.disabledInputs();
  }
  
  disabledInputs(){
    if(this.selectedFields){
      this.inputDisabled = false;
    }else{
      this.inputDisabled = true;
    }
  }

  handleFieldChange(event){
    this.selectedFields=event.target.value;
    this.disabledInputs();
  }
  handleSearchInput(event){
  this.searchValue=event.target.value;
  
  }

    get optionSobjectFields(){
        console.log('_sObjectFields ',this._sObjectFields);
        return this._sObjectFields;
        
    }
  handleSearch(event){

  let obj={input:this.searchValue,fieldName:this.selectedFields};
  this.dispatchEvent(new CustomEvent('search',{detail:obj}));

}
}