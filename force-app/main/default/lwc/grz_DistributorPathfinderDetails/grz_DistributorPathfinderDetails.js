import { LightningElement, track, wire,api } from "lwc";
import getCompetitionDetails from '@salesforce/apex/Grz_DistributorPathfinderApex.getCompetitionDetails';
import getGTMOutlook from '@salesforce/apex/Grz_DistributorPathfinderApex.getGTMOutlook';
import { CurrentPageReference } from 'lightning/navigation';
import Total_Purchase_in_PY from '@salesforce/label/c.Total_Purchase_in_PY';
import Estimated_Growth_in_CY from '@salesforce/label/c.Estimated_Growth_in_CY';
import Estimated_Sales_in_CY from '@salesforce/label/c.Estimated_Sales_in_CY';
import Estimated_Growth_in_NY from '@salesforce/label/c.Estimated_Growth_in_NY';
import Estimated_Sales_in_NY from '@salesforce/label/c.Estimated_Sales_in_NY';
import Estimated_Growth_in_NNY from '@salesforce/label/c.Estimated_Growth_in_NNY';
import Estimated_Sales_in_NNY from '@salesforce/label/c.Estimated_Sales_in_NNY';
import Instructions from '@salesforce/label/c.Instructions';
import GTM_Customer from '@salesforce/label/c.GTM_Customer';
import OUTLOOK from '@salesforce/label/c.OUTLOOK';
import COMPETITION from '@salesforce/label/c.COMPETITION';
import Customer_Lead_Customer from '@salesforce/label/c.Customer_Lead_Customer';
import Write_UPL_POSITION from '@salesforce/label/c.Write_UPL_POSITION';
import UPL_s_Share_of_Wallet from '@salesforce/label/c.UPL_s_Share_of_Wallet';
import Write_the_name_of_the_1_Company from '@salesforce/label/c.Write_the_name_of_the_1_Company';
import Indicate_the_Share_of_Wallet_of_the_1_Company from '@salesforce/label/c.Indicate_the_Share_of_Wallet_of_the_1_Company';
import Write_the_name_of_the_2_Company from '@salesforce/label/c.Write_the_name_of_the_2_Company';
import Indicate_the_Share_of_Wallet_of_the_2_Company from '@salesforce/label/c.Indicate_the_Share_of_Wallet_of_the_2_Company';
import Write_the_name_of_the_3_Company from '@salesforce/label/c.Write_the_name_of_the_3_Company';
import Indicate_the_Share_of_Wallet_of_the_3_Company from '@salesforce/label/c.Indicate_the_Share_of_Wallet_of_the_3_Company';
import Write_the_name_of_the_4_Company from '@salesforce/label/c.Write_the_name_of_the_4_Company';
import Indicate_the_Share_of_Wallet_of_the_4_Company from '@salesforce/label/c.Indicate_the_Share_of_Wallet_of_the_4_Company';
import Write_the_name_of_the_5_Company from '@salesforce/label/c.Write_the_name_of_the_5_Company';
import Indicate_the_Share_of_Wallet_of_the_5_Company from '@salesforce/label/c.Indicate_the_Share_of_Wallet_of_the_5_Company';
import Write_the_name_of_the_6_Company from '@salesforce/label/c.Write_the_name_of_the_6_Company';
import Indicate_the_Share_of_Wallet_of_the_6_Company from '@salesforce/label/c.Indicate_the_Share_of_Wallet_of_the_6_Company';
import Write_the_name_of_the_7_Company from '@salesforce/label/c.Write_the_name_of_the_7_Company';
import Indicate_the_Share_of_Wallet_of_the_7_Company from '@salesforce/label/c.Indicate_the_Share_of_Wallet_of_the_7_Company';
import Write_the_name_of_the_8_Company from '@salesforce/label/c.Write_the_name_of_the_8_Company';
import Indicate_the_Share_of_Wallet_of_the_8_Company from '@salesforce/label/c.Indicate_the_Share_of_Wallet_of_the_8_Company';
import Remaining from '@salesforce/label/c.Remaining';
import Share_wallet_already_reached_100 from '@salesforce/label/c.Share_wallet_already_reached_100';
import Combined_total_value_more_than_100_is_not_allowed from '@salesforce/label/c.Combined_total_value_more_than_100_is_not_allowed';
import Please_check_all_distribution from '@salesforce/label/c.Please_check_all_distribution';
import X1_to_8_values_for_UPL_is_not_allowed from '@salesforce/label/c.X1_to_8_values_for_UPL_is_not_allowed';
import Check_If_Distribution_Is_Correct from '@salesforce/label/c.Check_If_Distribution_Is_Correct';
import Distribution_completed from '@salesforce/label/c.Distribution_completed';
import Please_check_the_values_Not_matching_100 from '@salesforce/label/c.Please_check_the_values_Not_matching_100';
import getUser from '@salesforce/apex/GTMPathFinder.getUser';
    export default class Grz_DistributorPathfinderDetails extends LightningElement {
    @track fiscalYearValue;
    @track gtmcompetitor;
    @api recordId;
    @track nodata= false;
    @track nodata12= false;
    currentPageReference = null;
    @track error;
    @track GTMOutlookDetails;
     @track labels = {
        Customer_Lead_Customer: Customer_Lead_Customer,
        Write_UPL_POSITION: Write_UPL_POSITION,
        UPL_s_Share_of_Wallet1: UPL_s_Share_of_Wallet.split('<br/>')[0],
        UPL_s_Share_of_Wallet2: UPL_s_Share_of_Wallet.split('<br/>')[1],
        Remaining: Remaining,
        Check_If_Distribution_Is_Correct: Check_If_Distribution_Is_Correct,
        Distribution_completed: Distribution_completed,
        Please_check_the_values_Not_matching_100: Please_check_the_values_Not_matching_100,
        Share_wallet_already_reached_100: Share_wallet_already_reached_100,

        Write_the_name_of_the_1_Company: Write_the_name_of_the_1_Company,


        Indicate_the_Share_of_Wallet_of_the_1_Company1: Indicate_the_Share_of_Wallet_of_the_1_Company.split('<br/>')[0],
        Indicate_the_Share_of_Wallet_of_the_1_Company2: Indicate_the_Share_of_Wallet_of_the_1_Company.split('<br/>')[1],

       Write_the_name_of_the_2_Company: Write_the_name_of_the_2_Company,

       Indicate_the_Share_of_Wallet_of_the_2_Company1: Indicate_the_Share_of_Wallet_of_the_2_Company.split('<br/>')[0],
       Indicate_the_Share_of_Wallet_of_the_2_Company2: Indicate_the_Share_of_Wallet_of_the_2_Company.split('<br/>')[1],

        Write_the_name_of_the_3_Company: Write_the_name_of_the_3_Company,
        Indicate_the_Share_of_Wallet_of_the_3_Company1: Indicate_the_Share_of_Wallet_of_the_3_Company.split('<br/>')[0],
        Indicate_the_Share_of_Wallet_of_the_3_Company2: Indicate_the_Share_of_Wallet_of_the_3_Company.split('<br/>')[1],
        Write_the_name_of_the_4_Company: Write_the_name_of_the_4_Company,
        Indicate_the_Share_of_Wallet_of_the_4_Company1: Indicate_the_Share_of_Wallet_of_the_4_Company.split('<br/>')[0],
        Indicate_the_Share_of_Wallet_of_the_4_Company2: Indicate_the_Share_of_Wallet_of_the_4_Company.split('<br/>')[1],
        Write_the_name_of_the_5_Company: Write_the_name_of_the_5_Company,
        Indicate_the_Share_of_Wallet_of_the_5_Company1: Indicate_the_Share_of_Wallet_of_the_5_Company.split('<br/>')[0],
        Indicate_the_Share_of_Wallet_of_the_5_Company2: Indicate_the_Share_of_Wallet_of_the_5_Company.split('<br/>')[1],
        Write_the_name_of_the_6_Company: Write_the_name_of_the_6_Company,
        Indicate_the_Share_of_Wallet_of_the_6_Company1: Indicate_the_Share_of_Wallet_of_the_6_Company.split('<br/>')[0],
        Indicate_the_Share_of_Wallet_of_the_6_Company2: Indicate_the_Share_of_Wallet_of_the_6_Company.split('<br/>')[1],
        Write_the_name_of_the_7_Company: Write_the_name_of_the_7_Company,
        Indicate_the_Share_of_Wallet_of_the_7_Company1: Indicate_the_Share_of_Wallet_of_the_7_Company.split('<br/>')[0],
        Indicate_the_Share_of_Wallet_of_the_7_Company2: Indicate_the_Share_of_Wallet_of_the_7_Company.split('<br/>')[1],
        Write_the_name_of_the_8_Company: Write_the_name_of_the_8_Company,
        Indicate_the_Share_of_Wallet_of_the_8_Company1: Indicate_the_Share_of_Wallet_of_the_8_Company.split('<br/>')[0],
        Indicate_the_Share_of_Wallet_of_the_8_Company2: Indicate_the_Share_of_Wallet_of_the_8_Company.split('<br/>')[1],
        Combined_total_value_more_than_100_is_not_allowed:Combined_total_value_more_than_100_is_not_allowed,
        Please_check_all_distribution:Please_check_all_distribution,
        X1_to_8_values_for_UPL_is_not_allowed:X1_to_8_values_for_UPL_is_not_allowed,
        OUTLOOK,
        COMPETITION
    }
   label = {
      Instructions:Instructions,
      GTM_Customer:GTM_Customer,
      Total_Purchase_in_PY:Total_Purchase_in_PY,
      Estimated_Growth_in_CY:Estimated_Growth_in_CY,
      Estimated_Sales_in_CY:Estimated_Sales_in_CY,
      Estimated_Growth_in_NY:Estimated_Growth_in_NY,
      Estimated_Sales_in_NY:Estimated_Sales_in_NY,
      Estimated_Growth_in_NNY:Estimated_Growth_in_NNY,
      Estimated_Sales_in_NNY:Estimated_Sales_in_NNY
    }
   countryLocale = 'es-Ar';
      constructor(){
    super()
    getUser().then(user=>{
        console.log('Country user ',user);
        if(user){
            if(user.Country=='Argentina'){
                this.countryLocale = 'es-AR';
            }
            if(user.Country=='Mexico'){
                this.countryLocale = 'es-MX';
            }
            if(user.Country=='Italy'){
                this.countryLocale = 'it-IT';
            }
        }
    }).catch(error=>{
        console.log(error);
    })
}

 
    @wire(CurrentPageReference)
getPageReferenceParameters(currentPageReference) {
console.log('currentPageReference==>',currentPageReference);
this.recordId = currentPageReference.attributes.recordId || null;
var today = new Date();
        var fiscalyear;
            if ((today.getMonth() + 1) <= 3) {
                fiscalyear = (today.getFullYear() - 1);
            } else {
                fiscalyear = today.getFullYear();
            }

this.fiscalYearValue=fiscalyear.toString()+'-'+(fiscalyear+1).toString();
console.log('this.fiscalYearValue==>',this.fiscalYearValue);
if(null!=this.recordId){
    this.getCompetitionDetails();
    this.getGTMOutlook();
}
}

getGTMOutlook() {
    getGTMOutlook({ year: this.fiscalYearValue,recordId: this.recordId})
    .then((result) => {
    console.log('result==>',result);
     console.log('result==>length',result.length);
 let tempData = [];

      if (result) {
          if(result.length > 0 && result != null){

          
          console.log('testimg---');
       tempData = result.map((ele) => {
          let confirmtotalSalesChannelCYFormula = Number((Number(ele.GTM_Details__r.Total_Purchase_of_Crop_Protection_PY__c)*Number(ele.Estimated_Growth_PY_to_CY__c)/100)+Number(ele.GTM_Details__r.Total_Purchase_of_Crop_Protection_PY__c)).toFixed(2)
          console.log('Calculated Value-->',ele.Estimated_Growth_PY_to_CY__c);

          let confirmtotalSalesChannelNYFormula = Number((Number(confirmtotalSalesChannelCYFormula)*Number(ele.Estimated_Growth_PY_to_NY__c)/100)+Number(confirmtotalSalesChannelCYFormula)).toFixed(2)

          let confirmtotalSalesChanneN2YFormula =Number((Number(confirmtotalSalesChannelNYFormula)*Number(ele.Estimated_Growth_NY_to_2NY__c)/100)+Number(confirmtotalSalesChannelNYFormula)).toFixed(2)

          let tempCompaniesPY = Number(ele.GTM_Details__r.Total_Purchase_of_Crop_Protection_PY__c)?Number(ele.GTM_Details__r.Total_Purchase_of_Crop_Protection_PY__c).toLocaleString(this.countryLocale):'';
          console.log('confirmtotalSalesChannelCYFormula-->',confirmtotalSalesChannelCYFormula);
          console.log('tempCompaniesPY-->',tempCompaniesPY);
          let obj = {
            Id: ele.Id,
            customerName: ele.GTM_Customer__r ? ele.GTM_Customer__r.Name : "",
            totalCompaniesPurchesLocale:tempCompaniesPY,
            totalCompaniesPurches:ele.GTM_Details__r.Total_Purchase_of_Crop_Protection_PY__c,
            EstimatedGrowthCY: ele.Estimated_Growth_PY_to_CY__c?ele.Estimated_Growth_PY_to_CY__c:'',
            EstimatedGrowthNY: ele.Estimated_Growth_PY_to_NY__c?ele.Estimated_Growth_PY_to_NY__c:'',
            EstimatedGrowth2NY: ele.Estimated_Growth_NY_to_2NY__c?ele.Estimated_Growth_NY_to_2NY__c:'',
            confirmtotalSalesChannelCY:isNaN(confirmtotalSalesChannelCYFormula)?'':Number(confirmtotalSalesChannelCYFormula).toLocaleString(this.countryLocale),
            confirmtotalSalesChannelNY:isNaN(confirmtotalSalesChannelNYFormula)?'':Number(confirmtotalSalesChannelNYFormula).toLocaleString(this.countryLocale),
            confirmtotalSalesChanneN2Y:isNaN(confirmtotalSalesChanneN2YFormula)?'':Number(confirmtotalSalesChanneN2YFormula).toLocaleString(this.countryLocale),
           
          };
          console.log('obj---',obj);
         tempData.push(obj);
       
        console.log('tempData---',tempData);
       
           this.GTMOutlookDetails = tempData;
           console.log('GTMOutlook String', JSON.stringify(this.GTMOutlookDetails));
        
      if(confirmtotalSalesChannelCYFormula == 'NaN' || confirmtotalSalesChannelCYFormula == '' ){
        this.nodata = true;
          console.log('this.nodata-a--',this.nodata);
      }
          
        
       
        });
          }
           else if(result.length == 0){
                this.nodata = true;
                console.log('this.nodata-b--',this.nodata);
           }
       else if(result == null){
                this.nodata = true;
                console.log('this.nodata1---',this.nodata);
           }
     
      
       else{
                this.nodata = true;
                console.log('this.nodata-c--',this.nodata);
           }
      }
      
    })
    .catch((error) => {
    console.log('In error....',error);
    this.error = error;
    // This way you are not to going to see [object Object]
    console.log('Error is', this.error); 
    });
    }

    getCompetitionDetails() {
        getCompetitionDetails({ year: this.fiscalYearValue,recordId: this.recordId})
        .then((result) => {
        console.log('result==>123',result);
        console.log('result==>length',result.length);
        let tempData = [];
            if (result) {
                  if(result.length > 0 && result != null){
                tempData = result.map(ele => {
                    let obj = {
                        id: ele.Id,
                        customer: ele.GTM_Customer__r.Name,
                        customerId: ele.GTM_Customer__c,
                        Competitor1: ele.Competitor_Name_1__c ? ele.Competitor_Name_1__c : '',
                        Competitor1Name: ele.Competitor_Name_1__r ? ele.Competitor_Name_1__r.Name : '',
                        Indicate1: ele.Indicate_share_wallet_of_competitor_1__c,
                        Competitor2: ele.Competitor_Name_2__c ? ele.Competitor_Name_2__c : '',
                        Competitor2Name: ele.Competitor_Name_2__r ? ele.Competitor_Name_2__r.Name : '',
                        Indicate2: ele.Indicate_share_wallet_of_competitor_2__c,
                        Competitor3: ele.Competitor_Name_3__c ? ele.Competitor_Name_3__c : '',
                        Competitor3Name: ele.Competitor_Name_3__r ? ele.Competitor_Name_3__r.Name : '',
                        Indicate3: ele.Indicate_share_wallet_of_competitor_3__c,
                        Competitor4: ele.Competitor_Name_4__c ? ele.Competitor_Name_4__c : '',
                        Competitor4Name: ele.Competitor_Name_4__r ? ele.Competitor_Name_4__r.Name : '',
                        Indicate4: ele.Indicate_share_wallet_of_competitor_4__c,
                        Competitor5: ele.Competitor_Name_5__c ? ele.Competitor_Name_5__c : '',
                        Competitor5Name: ele.Competitor_Name_5__r ? ele.Competitor_Name_5__r.Name : '',
                        Indicate5: ele.Indicate_share_wallet_of_competitor_5__c,
                        Competitor6: ele.Competitor_Name_6__c ? ele.Competitor_Name_6__c : '',
                        Competitor6Name: ele.Competitor_Name_6__r ? ele.Competitor_Name_6__r.Name : '',
                        Indicate6: ele.Indicate_share_wallet_of_competitor_6__c,
                        Competitor7: ele.Competitor_Name_7__c ? ele.Competitor_Name_7__c : '',
                        Competitor7Name: ele.Competitor_Name_7__r ? ele.Competitor_Name_7__r.Name : '',
                        Indicate7: ele.Indicate_share_wallet_of_competitor_7__c,
                        Competitor8: ele.Competitor_Name_8__c ? ele.Competitor_Name_8__c : '',
                        Competitor8Name: ele.Competitor_Name_8__r ? ele.Competitor_Name_8__r.Name : '',
                        Indicate8: ele.Indicate_share_wallet_of_competitor_8__c ? ele.Indicate_share_wallet_of_competitor_8__c : '',
                        uplposition: ele.UPL_Position__c ? ele.UPL_Position__c : '',
                        uplshare: ele.UPLs_share_of_wallet__c ? ele.UPLs_share_of_wallet__c : '',
                        status: '',
                        numberOfFieldsFilled: '',
                        isSubmitted__c: ele.isSubmitted__c,
                        isLeadCustomer: ele.GTM_Customer__r.RecordTypeId== this.leadRecordTypeId ? true : false,

                        pathFinder: ele.GTM_Customer__r.Path_Finder__c,
                        options: this.statusOptions,
                        remainingOptions1: [],
                        remainingOptions2: [],
                        remainingOptions3: [],
                        remainingOptions4: [],
                        remainingOptions5: [],
                        remainingOptions6: [],
                        remainingOptions7: [],
                        remainingOptions8: [],
                        remainingPercentage: 100,
                        isDistributionCompleted: false,
                        isUPLSelected: false,

                        validateIndicator1:false,
                        validateIndicator2:false,
                        validateIndicator3:false,
                        validateIndicator4:false,
                        validateIndicator5:false,
                        validateIndicator6:false,
                        validateIndicator7:false,
                        validateIndicator8:false,
                        validateIndicator9:false,

                    }
                   console.log('obj---123 ',obj);
                    tempData.push(obj);
                    console.log('tempdata  data 123',tempData);
                    this.gtmcompetitor = tempData;
                    console.log('Competitior  data ', JSON.stringify(this.gtmcompetitor));

                });
                  }
                else if(result == null){
                    this.nodata12 = true;
                    console.log('this.nodata1---',this.nodata12);
                }
                else if(result.length == 0){
                    this.nodata12 = true;
                    console.log('this.nodata1---',this.nodata12);
                }
                
                
                else{
                    this.nodata12 = true;
                    console.log('this.nodata2---',this.nodata12);
                }
           }

           

        })
        .catch((error) => {
            console.log('In error....',error);
        this.error = error;
        // This way you are not to going to see [object Object]
        console.log('Error is', this.error); 
        });
        }
    }