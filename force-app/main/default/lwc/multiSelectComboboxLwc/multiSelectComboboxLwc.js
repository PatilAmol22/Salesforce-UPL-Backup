import { api, LightningElement, track } from 'lwc';
import Options_Selected from '@salesforce/label/c.Options_Selected';
import No_results_found_for from '@salesforce/label/c.No_results_found_for';

export default class MultiSelectComboboxLwc extends LightningElement {
    @api options;
    @api selectedvalue;
    @api selectedvalues = [];
    @api label;
    @api minChar = 2;
    @api disabled = false;
    @api multiselect = false;
    @api isnone = false;
    @api placeholder = '';
    @track value;
    @track values = [];
    @track optionData;
    @track searchString;
    @track message;
    @track showDropdown = false;
  
    label={
      Options_Selected,
      No_results_found_for
    };
  
    connectedCallback() {
        this.showDropdown = false;
        var optionData = this.options ? (JSON.parse(JSON.stringify(this.options))) : null;
        var value = this.selectedvalue ? (JSON.parse(JSON.stringify(this.selectedvalue))) : null;
        var values = this.selectedvalues ? (JSON.parse(JSON.stringify(this.selectedvalues))) : null;
        //console.log('multi select connectedCallback - ', value);
        //console.log('this.multiselect connectedCallback - ', this.multiselect);
        if(value || values) {
            var searchString;
          var count = 0;
            for(var i = 0; i < optionData.length; i++) {
                if(this.multiselect) {
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
            if(this.multiselect)
                this.searchString = count + ' '+Options_Selected;
            else
                this.searchString = searchString;
        }
        this.value = value;
        this.values = values;
        this.optionData = optionData;
    }
  
    filterOptions(event) {
        this.searchString = event.target.value;
        if( this.searchString && this.searchString.length > 0 ) {
            this.message = '';
            if(this.searchString.length >= this.minChar) {
                var flag = true;
                for(var i = 0; i < this.optionData.length; i++) {
                    if(this.optionData[i].label.toLowerCase().trim().startsWith(this.searchString.toLowerCase().trim())) {
                        this.optionData[i].isVisible = true;
                        flag = false;
                    } else {
                        this.optionData[i].isVisible = false;
                    }
                }
                if(flag) {
                    this.message = No_results_found_for + " '" + this.searchString + "'";
                }
            }
            this.showDropdown = true;
        } else {
            this.showDropdown = false;
        }
  }
  
    selectItem(event) {
        //console.log('multi select selectItem - ', event.currentTarget.dataset.id);
        var selectedVal = event.currentTarget.dataset.id;
        if(selectedVal) {
            var count = 0;
            var options = JSON.parse(JSON.stringify(this.optionData));
            for(var i = 0; i < options.length; i++) {
                
                if(this.isnone == true){
                    if(options[i].value == ''){ // for none value...
                        options[i].selected = false;
                    }
                }

                if(options[i].value === selectedVal) {
                    if(this.multiselect) {
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

            if(this.isnone == true){
                this.values.filter(data => data == '').forEach(r => {
                    this.values.splice(r.indexOf(''), 1);
                });

                if(this.values.length == 0){
                    this.optionData[0].selected = true;
                }
            }

            if(this.multiselect)
                this.searchString = count + ' '+Options_Selected;
            if(this.multiselect)
                event.preventDefault();
            else
                this.showDropdown = false;
        }
        else{
            if(this.isnone == true){
                this.values = [];
                var options = JSON.parse(JSON.stringify(this.optionData));
                for(var i = 0; i < options.length; i++) {
                    if(this.multiselect) {
                        
                        if(options[i].value === ""){
                            options[i].selected = true;
                        }
                        else{
                            options[i].selected = false;
                        }
                        //console.log('multiselect optionDate - ', options[i]);
                    }                 
                }
                this.optionData = options;
            }
        }
        //console.log('multiselect optionDate - ', JSON.stringify(this.optionData));
    }
  
    showOptions() {
        if(this.disabled == false && this.options) {
            this.message = '';
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
  
    removePill(event) {
      if(this.disabled == false){
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
        this.optionData = options;
        if(this.isnone == true){
            if(this.values.length == 0){
                this.optionData[0].selected = true;
            }
        }
        this.blurEvent();
        if(this.multiselect)
            this.searchString = count + ' '+Options_Selected;
      }
    }
  
    blurEvent() {
        var previousLabel;
        var count = 0;
        for(var i = 0; i < this.optionData.length; i++) {
            if(this.optionData[i].value === this.value) {
                previousLabel = this.optionData[i].label;
            }
            if(this.optionData[i].selected) {
                count++;
            }
        }
        if(this.multiselect)
          this.searchString = count + ' '+Options_Selected;
        else
          this.searchString = previousLabel;
        
        this.showDropdown = false;
  
        this.dispatchEvent(new CustomEvent('select', {
            detail: {
                'payloadType' : 'multi-select',
                'payload' : {
                    'value' : this.value,
                    'values' : this.values
                }
            }
        }));
    }
  
    @api
    reportValidity(flag,msg){
      var inp=this.template.querySelectorAll(".inp"); // get input with class name as inp....
          inp.forEach(function(item){
              if(flag == true){
                  item.setCustomValidity(msg);
              }
              else{
                  item.setCustomValidity('');
              }
              item.reportValidity();
          },this);
    }
}