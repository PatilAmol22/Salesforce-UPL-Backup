import { LightningElement, track, api, wire } from 'lwc';
import searchedList from '@salesforce/apex/LookupControllerCmp.searchedLookupList'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import no_data from '@salesforce/label/c.No_data_found';
import pleaseWait from '@salesforce/label/c.Please_wait';

const MAXLIMIT = 5;
export default class Lookupcmp extends LightningElement {
    @api placeholder;
    @api iconname;
    @api multiselect;
    @api sobject;
    @api filter;
    @api disable = false;
    @api requireattribute = false;
    @api singleselectedrec = '';
    @api hideinput = false;

    @track searchRecords = undefined;
    @api selectedRecords = [];
    @track i = 0;
    @track message = false;
    @track loadmessage = false;
    @track flag;
    @track recordDataseleted;
    @api recordData = [];

    @track recordVisibility = false;
    @track spinner_flag = false;
    @track mouse_enter;
    @track mouse_leave;
    @track btn_flag;
    @track btn_clear = false;
    @track is_multiple;
    @track hidebox = '';
    @track deleteitemdetail = false;
    @track textboxclass = '';
    @track dropdownClass = ''
    @track hasRendered = true;
    @track no_data_label = no_data;
    @track please_wait = pleaseWait;
    @api hitLimit = false;
    @api countItem = 0;
    @track searchKey = '';
    @api displayfields = '';//to show display field
    @api mergefields = '';//to show string of two fields
    @api keyfield = '';
    mergeFieldsArray = [];
    records = [];
    virtualRecords = [];
    @track isloading = false;
    @api cmpwidth = 'width:300px;';
    @api spinnerwidth = 'margin-left: 20rem;';//to show spinner in input box
    @track loadData = true;




    connectedCallback() {
        console, console.log('change@@@@ lookup');
        this.isloading = false;
        this.message = false;
        this.textboxclass = 'slds-combobox__input slds-input slds-combobox__input-value';
        this.dropdownClass = 'display: none;';
        if(this.singleselectedrec!=''){
            this.hidebox = 'hideboxcss';
        }
    }
    searchField(event) {
        this.message = false;
        this.textboxclass = 'slds-combobox__input slds-input slds-combobox__input-value';
        if (this.loadData == true) {
            this.disable=true;
            this.isloading = true;
            this.loadmessage=true;
            searchedList({ obj: this.sobject, name: this.displayfields, filter: this.filter, mergefield: this.mergefields })
                .then(result => {
                    this.disable=false;
                    this.loadmessage=false;
                    this.isloading = false;
                    this.textboxclass = 'slds-input mytextbsmall';
                    this.dropdownClass = 'dropdownsmall dropdown slds-scrollable';
                    this.loadData = false;
                    if (result.length > 0) {
                        this.flag = true;
                        this.btn_flag = false;
                        this.message = false;
                        this.searchRecords = result;
                        this.spinner_flag = false;
                        //  console.log('lookup Data111 ', this.searchRecords);
                        this.mergeFieldsArray = this.mergefields.split(',')
                        //  console.log('Display Fields ', this.displayfields, ' Merge Fields ', this.mergefields, ' keyField ', this.keyfield);

                        let data = this.searchRecords.map(ele => {
                            let obj = {};
                            obj['keyfield'] = ele[this.keyfield];
                            obj['displayfields'] = ele[this.displayfields];
                            obj['mergeFields'] = '';
                            this.mergeFieldsArray.forEach(field => {
                                obj[field] = ele[field] ? ele[field] : '';
                                obj['mergeFields'] = obj['mergeFields'] + ' - ' + obj[field];
                            });
                            return obj;
                        });
                        this.records = JSON.parse(JSON.stringify(data));
                        this.virtualRecords = JSON.parse(JSON.stringify(data));
                        //console.log('new lookupData ', this.records);
                    } else {
                        //  console.log('inside else');
                        this.loadData = false;
                        this.flag = false;
                        this.btn_flag = false;
                        this.message = true;
                        this.searchRecords = [];
                        this.spinner_flag = false;
                    }

                }).catch(error => {
                    //  console.log('Err -->');
                    this.loadData = true;
                    this.message = true;
                    this.flag = false;
                    this.spinner_flag = false;
                })

        } else {
            this.textboxclass = 'slds-input mytextbsmall';
            this.dropdownClass = 'dropdownsmall dropdown slds-scrollable';

            this.isloading = true;
            this.searchKey = event.target.value;
            if (this.searchKey == '' || this.searchKey == null) {
                this.records = this.virtualRecords;
                this.flag = true;
               // this.isloading = true;
                this.message = false;
            } else {
                if (this.searchKey.length > 2) {
                    this.flag = false;
                    this.isloading = true;
                    this.message = false;
                    setTimeout(() => {
                        this.records = this.virtualRecords.filter(ele => {
                            return ele['displayfields'].toLowerCase().includes(this.searchKey.toLowerCase()) || ele['mergeFields'].toLowerCase().includes(this.searchKey.toLowerCase());
                        });
                        this.flag = true;
                        this.isloading = false;

                    }, 300);
                }
            }
            if (this.records.length == 0) {
                this.message = true;
                this.isloading = false;
            }
        }
    }

    setSelectedrecord(event) {
        this.isloading = false;
        this.message = false;
        const recid = event.target.dataset.val;
        const recname = event.target.dataset.name;
        let newObj = { 'recId': recid, 'recName': recname };

        if (recname !== undefined) {
            this.singleselectedrec = recname;
            this.spinner_flag = false;
            this.flag = false;
            const selectEvent = new CustomEvent('selected', { detail: newObj });
            this.dispatchEvent(selectEvent);
            this.hidebox = 'hideboxcss';
            //  fireEvent(this.pageRef, "selectitems", this.singleselectedrec);

        }

    }

    focusOut_event() {
        if (this.mouse_leave === true)
            this.flag = false;
    }

    mouseIn() {
        this.mouse_enter = true;
        this.mouse_leave = false;
    }
    mouseOut() {
        this.mouse_leave = true;
        this.mouse_enter = false;
    }

    removeSingleHandler(event) {
        //  console.log('event  ', event.target.label, 'selected rec', this.singleselectedrec);
        const removeEvent = new CustomEvent('remove', { detail: this.singleselectedrec });
        this.dispatchEvent(removeEvent);
        this.hidebox = ''
        const element = this.template.querySelector('[data-id="inputtext"]');
        //   console.log('ele value 224', element.value);
        element.value = '';
        //  console.log('ele value 226', element.value);
    }
}