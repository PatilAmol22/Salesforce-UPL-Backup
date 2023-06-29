import { LightningElement, track, api } from 'lwc';
import getPOGSkusList from '@salesforce/apex/Grz_POGLiquidationReportController.getPOGSkusList';
import All from '@salesforce/label/c.All';
import OptionsSelected from '@salesforce/label/c.Grz_OptionsSelected';
import SelectAnOption from '@salesforce/label/c.Grz_SelectAnOption';
import No_data_found from '@salesforce/label/c.Grz_NoDataFound'
import ClearAllOptions from '@salesforce/label/c.Grz_ClearAllOptions'

export default class Grz_multiSelectSkuPicklist extends LightningElement {
    @api options=[];
    @api isDependent = false;
    @api selectedValue;
    @api fieldLabelName;
    @api selectedValues = [];
    @api label;
    @api disabled = false;
    @api multiSelect = false;
    @track value;
    @track values = [];
    @track optionData;
    @track searchString;
    @track noResultMessage;
    @track showDropdown = false;
    @track placeholderLabel = SelectAnOption;
    @track labels = {All,OptionsSelected,No_data_found,ClearAllOptions};

    @api
    setDependentSkuDecList(depOptionList){
        console.log('rendered sku dec',JSON.parse(JSON.stringify(depOptionList)));
        if(depOptionList){
            this.disabled = false;
        }else{
            this.disabled = true;
        }
        this.options = depOptionList;
        var optionData = this.options ? (JSON.parse(JSON.stringify(this.options))) : null;
        var value = this.selectedValue ? (JSON.parse(JSON.stringify(this.selectedValue))) : null;
        var values = this.selectedValues ? (JSON.parse(JSON.stringify(this.selectedValues))) : null;
        
        if(value || values) {
            var searchString;
            var count = 0;
            for(var i = 0; i < optionData.length; i++) {
                if(this.multiSelect) {
                    if(values.includes(optionData[i].value)) {
                        optionData[i].selected = true;
                        count++;
                    }  
                } else {
                    if(optionData[i].value == value) {
                        searchString = optionData[i].label;
                    }
                }
            }
            if(this.multiSelect){
                if(count==0){
                    this.searchString = this.labels.All;
                }else{
                    //this.searchString = count + ' Option(s) Selected';
                    this.searchString = count + ' '+this.labels.OptionsSelected;
                }               
            }else{
                this.searchString = searchString;
            }
                
        }
        this.value = value;
        this.values = values;
        this.optionData = optionData;
    }
    
    connectedCallback() {

        if(!this.isDependent){
            
            getPOGSkusList({fieldName: this.fieldLabelName}).then((result) => {
                if(result){
                    var data = result;
                    /*for(var key in data){
                        this.options.push({ label: data[key].SKU_Code, value: data[key].Id });
                    }*/
                    data.forEach(element => {
                        if(element.SKU_Code){
                            this.options = [...this.options, { label: element.SKU_Code, value: element.Id }];
                        }
                    });
                    console.log('this.skuOptionsList : ',this.options);

                    this.showDropdown = false;
                    var optionData = this.options ? (JSON.parse(JSON.stringify(this.options))) : null;
                    var value = this.selectedValue ? (JSON.parse(JSON.stringify(this.selectedValue))) : null;
                    var values = this.selectedValues ? (JSON.parse(JSON.stringify(this.selectedValues))) : null;
                    
                    if(value || values) {
                        var searchString;
                        var count = 0;
                        for(var i = 0; i < optionData.length; i++) {
                            if(this.multiSelect) {
                                if(values.includes(optionData[i].value)) {
                                    optionData[i].selected = true;
                                    count++;
                                }  
                            } else {
                                if(optionData[i].value == value) {
                                    searchString = optionData[i].label;
                                }
                            }
                        }
                        if(this.multiSelect){
                            if(count==0){
                                this.searchString = this.labels.All;
                            }else{
                                //this.searchString = count + ' Option(s) Selected';
                                this.searchString = count + ' '+this.labels.OptionsSelected;
                            }               
                        }else{
                            this.searchString = searchString;
                        }
                            
                    }
                    this.value = value;
                    this.values = values;
                    this.optionData = optionData;
                }
                })
                .catch(error => {
                console.log('Error : ',error);
            });
        }else{
            this.searchString = this.labels.All;
            this.disabled = true;
        }
        
    }
  
    filterOptions(event) {
        this.searchString = event.target.value;
        if( this.searchString && this.searchString.length > 0 ) {
            this.noResultMessage = '';
            if(this.searchString.length >= 2) {
                var flag = true;
                for(var i = 0; i < this.optionData.length; i++) {
                    if(this.optionData[i].label.toLowerCase().trim().startsWith(this.searchString.toLowerCase().trim())) {
                        this.optionData[i].isVisible = true;
                        flag = false;
                    } else {
                        this.optionData[i].isVisible = false;
                    }
                }
                console.log('Search Options : ',this.optionData);
                if(flag) {
                    //this.noResultMessage = "No results found for '" + this.searchString + "'";
                    this.noResultMessage = this.labels.No_data_found+" '" + this.searchString + "'";
                }
            }
            this.showDropdown = true;
        } else {
            this.showDropdown = false;
        }
    }
  
    selectItem(event) {
        var selectedVal = event.currentTarget.dataset.id;
        if(selectedVal) {
            var count = 0;
            var options = JSON.parse(JSON.stringify(this.optionData));
            for(var i = 0; i < options.length; i++) {
                if(options[i].value === selectedVal) {
                    if(this.multiSelect) {
                        if(this.values.includes(options[i].value)) {
                            this.values.splice(this.values.indexOf(options[i].value), 1);
                        } else {
                            this.values.push(options[i].value);
                        }
                        options[i].selected = options[i].selected ? false : true;   
                    } else {
                        this.value = options[i].value;
                        this.searchString = options[i].label;
                    }
                }
                if(options[i].selected) {
                    count++;
                }
            }
            this.optionData = options;
            if(this.multiSelect){
                console.log('Selected Values : ',this.values);
                if(count == 0){
                    this.searchString = this.labels.All;
                }else{
                    //this.searchString = count + ' Option(s) Selected';
                    this.searchString = count + ' '+this.labels.OptionsSelected;
                }
 
                let ev = new CustomEvent('selectoptionsku', {detail:this.values});
                this.dispatchEvent(ev);
            }
                 
 
            if(!this.multiSelect){
                let ev = new CustomEvent('selectoptionsku', {detail:this.values});
                this.dispatchEvent(ev);
            }
 
            if(this.multiSelect)
                event.preventDefault();
            else
                this.showDropdown = false;
        }
    }
  
    showOptions() {
        if(this.disabled == false && this.options) {
            this.noResultMessage = '';
            this.searchString = '';
            var options = JSON.parse(JSON.stringify(this.optionData));
            for(var i = 0; i < options.length; i++) {
                options[i].isVisible = true;
            }
            if(options.length > 0) {
                this.showDropdown = true;
            }
            this.optionData = options;
        }
    }
  
    closePill(event) {
        var value = event.currentTarget.name;
        var count = 0;
        var options = JSON.parse(JSON.stringify(this.optionData));
        for(var i = 0; i < options.length; i++) {
            if(options[i].value === value) {
                options[i].selected = false;
                this.values.splice(this.values.indexOf(options[i].value), 1);
            }
            if(options[i].selected) {
                count++;
            }
        }
        console.log('this.values : '+this.values);
        this.optionData = options;
        if(this.multiSelect){
            if(count== 0){
                this.searchString = this.labels.All;
            }else{
                //this.searchString = count + ' Option(s) Selected';
                this.searchString = count + ' '+this.labels.OptionsSelected;
            }
             
            let ev = new CustomEvent('selectoptionsku', {detail:this.values});
            //let ev = new CustomEvent('selectoptionsku', {detail:this.optionData});
            this.dispatchEvent(ev);
        }
    }

    handleClearOptions(){
        var count = 0;
        var options = JSON.parse(JSON.stringify(this.optionData));
        for(var i = 0; i < options.length; i++) {
            //if(options[i].value === value) {
                options[i].selected = false;
                this.values.splice(this.values.indexOf(options[i].value), 1);
            //}
            if(options[i].selected) {
                count++;
            }
        }
        console.log('this.values : '+this.values);
        this.optionData = options;
        if(this.multiSelect){
            if(count== 0){
                this.searchString = this.labels.All;
            }else{
                this.searchString = count + ' '+this.labels.OptionsSelected;
            }
             
            let ev = new CustomEvent('selectoptionsku', {detail:this.values});
            //let ev = new CustomEvent('selectoptionaccount', {detail:this.optionData});
            this.dispatchEvent(ev);
        }
    }
  
    handleBlur() {
        var previousLabel;
        var count = 0;
        if(this.optionData != undefined){
        for(var i = 0; i < this.optionData.length; i++) {
            if(this.optionData[i].value === this.value) {
                previousLabel = this.optionData[i].label;
            }
            if(this.optionData[i].selected) {
                count++;
            }
        }
        }
 
        if(this.multiSelect){
            if(count== 0){
                this.searchString = this.labels.All;
            }else{
                //this.searchString = count + ' Option(s) Selected';
                this.searchString = count + ' '+this.labels.OptionsSelected;
            }

        }else{
            this.searchString = previousLabel;
        }
 
        this.showDropdown = false;
    }
 
    /*handleMouseOut(){
        this.showDropdown = false;
    }
 
    handleMouseIn(){
        this.showDropdown = true;
    }*/
}