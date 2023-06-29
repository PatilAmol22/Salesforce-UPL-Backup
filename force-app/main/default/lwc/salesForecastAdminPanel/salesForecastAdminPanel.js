import { LightningElement,track } from 'lwc';
import SalesForecastingAdmin from '@salesforce/label/c.Sales_Forecasting_Admin_Panel';
import ForecastManagement from '@salesforce/label/c.Forecast_Management';
import ForecastSettings from '@salesforce/label/c.Sales_Forecast_Settings';
import BudgetUpload from '@salesforce/label/c.Budget_Upload';
import PriceBookManagement from '@salesforce/label/c.Price_Book_Management';
import PrentChildMapping from '@salesforce/label/c.Parent_Child_SKU_Mapping'; // new
import UpdateMetrics from '@salesforce/label/c.Update_Metrics';

export default class SalesForecastAdminPanel extends LightningElement {
    
    label = {
        SalesForecastingAdmin,
        ForecastManagement,
        ForecastSettings,
        BudgetUpload,
        PriceBookManagement,
        PrentChildMapping,
        UpdateMetrics
    };

    @track openModal = false;
    showModal() {
        this.openModal = true;
    }
    closeModal() {
        this.openModal = false;
    }


    handleChange(event) {
        this.value = event.detail.value;
    }

    handleOnActivePBM(event){
        //this.template.querySelector('c-pb-management').run();
        setTimeout(()=>this.template.querySelector('c-pb-management').run());
    }
    handleOnActiveBU(event){
        //this.template.querySelector('c-pb-management').run();
        setTimeout(()=>this.template.querySelector('c-budget-upload').run());
    }

    handleOnActive(event) {
        /* let str = this.template;
        setTimeout(function() {
            str.querySelector('c-sales-forecast').connectedCallback();
          }, 4000); */

          setTimeout(()=>this.template.querySelector('c-sales-forecast').run());
        
    }
    handleOnActivePC(event){
        //this.template.querySelector('c-pb-management').run();
        setTimeout(()=>this.template.querySelector('c-parent-child-sku-mapping').run());
    }

    handleOnActiveUM(event){
        //this.template.querySelector('c-pb-management').run();
        setTimeout(()=>this.template.querySelector('c-update-sales-agreement-metrics').run());
    }
}