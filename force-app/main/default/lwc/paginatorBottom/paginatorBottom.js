import { LightningElement, api } from 'lwc';
import First from '@salesforce/label/c.First';
import Previous	from '@salesforce/label/c.Previous';
import Next from '@salesforce/label/c.Next';
import Last from '@salesforce/label/c.Last';
import Page from '@salesforce/label/c.Page';
import FORM_FACTOR from '@salesforce/client/formFactor';

export default class PaginatorBottom extends LightningElement {

    isMobile;
    currentPage =1
    totalRecords
    @api recordSize = 10
    disableNext
    totalPage = 0
    label = {
        First,
        Previous,
        Next,
        Last,
        Page
    };
    
    get records(){
        return this.visibleRecords
    }
    @api 
    set records(data){
        if(data){ 
            this.totalRecords = data
            console.log('this.recordSize 2 :'+this.recordSize);
            this.recordSize = Number(this.recordSize)
            this.totalPage = Math.ceil(data.length/this.recordSize)
            this.updateRecords()
        }
    }

    //Changes made by akhilesh w.r.t Mobile UI
    connectedCallback() {        

        console.log('The device form factor is: ' + FORM_FACTOR);
        if(FORM_FACTOR == 'Large'){
            this.isMobile = false;
        }else if(FORM_FACTOR == 'Medium' || FORM_FACTOR == 'Small'){
            this.isMobile = true;
        }
        console.log('this.isMobile ' + this.isMobile);
    }

    get disablePrevious(){ 
        return this.currentPage<=1
    }
    get disableFirstPage(){ 
        return this.currentPage<=1
    }
    get disableNext(){ 
        return this.currentPage>=this.totalPage
    }
    get disableLastPage(){ 
        return this.currentPage>=this.totalPage
    }
    previousHandler(){ 
        if(this.currentPage>1){
            this.currentPage = this.currentPage-1
            this.updateRecords()
        }
    }
    firstPageHandler(){ 
        if(this.currentPage>1){
            this.currentPage = 1
            this.updateRecords()
        }
    }
    nextHandler(){
        if(this.currentPage < this.totalPage){
            this.currentPage = this.currentPage+1
            this.updateRecords()
        }
    }
    lastPageHandler(){
        if(this.currentPage < this.totalPage){
            this.currentPage = this.totalPage
            this.updateRecords()
        }
    }
    updateRecords(){ 
        const start = (this.currentPage-1)*this.recordSize
        const end = this.recordSize*this.currentPage
        this.visibleRecords = this.totalRecords.slice(start, end)
        this.dispatchEvent(new CustomEvent('update',{ 
            detail:{ 
                records:this.visibleRecords
            }
        }))
        if(this.visibleRecords.length < this.recordSize){
            this.disableNext=true;
        }else{
            this.disableNext=false;
        }
    }
    changeHandler(event){
        event.preventDefault();
        const s_value = event.target.value;
        this.recordSize=s_value;
        this.updateRecords();
        this.dispatchEvent(selectedEvent);
    }
}