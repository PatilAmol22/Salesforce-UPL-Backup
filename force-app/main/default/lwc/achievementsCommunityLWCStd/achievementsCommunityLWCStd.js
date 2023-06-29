import { LightningElement, wire,api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import NoDataAvailable from '@salesforce/label/c.No_Data_Available';
import Warning from '@salesforce/label/c.Warning';
import achievement from '@salesforce/label/c.Achivement';
import somerroroccured from '@salesforce/label/c.Some_error_has_occurred';
import getAchievementList from '@salesforce/apex/AchievementsCommunityController.getAchievementList';
import getNext from '@salesforce/apex/AchievementsCommunityController.getNext';
import getPrevious from '@salesforce/apex/AchievementsCommunityController.getPrevious';
import TotalRecords from '@salesforce/apex/AchievementsCommunityController.TotalRecords';
import FORM_FACTOR from '@salesforce/client/formFactor';

export default class AchievementsCommunityLWC extends LightningElement {
    @api recordSize;
    achievementList;
    error;
    visibleAchievements
    label = {
        achievement,
        somerroroccured
    };
    isMobile;

    connectedCallback() {
        //this.value='10';
        // ForMobile compatibility Start
        console.log('The device form factor is: ' + FORM_FACTOR);
        if(FORM_FACTOR == 'Large'){
            this.isMobile = false;
        }else if(FORM_FACTOR == 'Medium' || FORM_FACTOR == 'Small'){
            this.isMobile = true;
        }
        console.log('this.isMobile ' + this.isMobile);
        // ForMobile compatibility Start end
    }
    @wire(getAchievementList)
    wiredachievementList({ error, data }) {
        if (data) {
            console.log('data :'+data);
            this.achievementList = data;
        } else if (error) {
            console.log(error);
            this.error = error;
        }
    }
    updateAchievementHandler(event){
        this.visibleAchievements=[...event.detail.records]
        console.log('records :'+event.detail.records)
    }
    changeHandler2(event){
        const det = event.detail;
        recordSize = det;
    }

    showNotification(titles,messages,variants) {
    const evt = new ShowToastEvent({
        title: titles,
        message: messages,
        variant: variants
    });
    this.dispatchEvent(evt);
    }
}