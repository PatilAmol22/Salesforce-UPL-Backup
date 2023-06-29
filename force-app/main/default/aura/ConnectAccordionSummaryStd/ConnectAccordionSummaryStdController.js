({
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');
        
        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    },
    
    doInit: function (component, event,helper) {
        console.log('in Do init handler ');
        //getting all details
        
        helper.getUrlAddress(component,event,helper);
        
        helper.showHideDetails(component,event,helper);
        helper.Credit_Information(component,event,helper);
        //Change by Swaranjeet(Grazitti) APPS-1315
       // helper.AccountTstatement(component,event,helper);
        helper.Account_Statement(component,event,helper);
        helper.Outstanding_Ageing (component,event,helper);
        helper.Payment_Detail(component,event,helper);
        
        helper.getOverdue(component,event,helper);
        
        
        
       /* component.set('v.mycolumns', [
            {label: $A.get("$Label.c.Credit_Limit"), fieldName: 'Credit_Limit', type: 'currency',wrapText: true,cellAttributes: { alignment: 'left' }},
            {label: $A.get("$Label.c.Used_Limit"), fieldName: 'Used_Limit', type: 'currency',wrapText: true ,cellAttributes: { alignment: 'left' }},
            {label: $A.get("$Label.c.Balance_Limit"), fieldName: 'Balance_Limit', type: 'currency',wrapText: true, cellAttributes: { alignment: 'left' }},
            {label: $A.get("$Label.c.Outstanding") , fieldName: 'Sum_Open_Item', type: 'currency',wrapText: true, cellAttributes: { alignment: 'left' }},
            {label: '%'+$A.get("$Label.c.Used"), fieldName: 'Percentage_Used', type: 'Number',wrapText: true, cellAttributes: { alignment: 'left' }},
            {label: $A.get("$Label.c.Overdue"), fieldName: 'overdue', type: 'currency',wrapText: true, cellAttributes: { alignment: 'left' }}
            
        ]);*/
        component.set('v.mycolumns', [
            {label: $A.get("$Label.c.Credit_Limit"), fieldName: 'Credit_Limit', type: 'currency',wrapText: true,cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: $A.get("$Label.c.Used_Limit"), fieldName: 'Used_Limit', type: 'currency',wrapText: true ,cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: $A.get("$Label.c.Balance_Limit"), fieldName: 'Balance_Limit', type: 'currency',wrapText: true, cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: $A.get("$Label.c.Outstanding") , fieldName: 'Sum_Open_Item', type: 'currency',wrapText: true, cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: '%'+$A.get("$Label.c.Used"), fieldName: 'Percentage_Used', type: 'Number',wrapText: true, cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
                      
        ]);
        
        
        
       /* component.set('v.mycolumns1', [
            {label:$A.get("$Label.c.Opening_Balance"), fieldName: 'Opening_Balance__c', type: 'currency',cellAttributes: { alignment: 'left' }},
            {label: $A.get("$Label.c.Credit") , fieldName: 'Credit__c', type: 'currency' ,cellAttributes: { alignment: 'left' }},
            {label: $A.get("$Label.c.Debit") , fieldName: 'Debit__c', type: 'currency', cellAttributes: { alignment: 'left' }},
            {label: $A.get("$Label.c.Closing_Balance"), fieldName: 'Closing_Balance__c', type: 'currency', cellAttributes: { alignment: 'left' }}
            
        ]);*/
        
        
        component.set('v.mycolumns2', [
            {label: '0-30', fieldName: 'o0_30', wrapText: true, type: 'currency',cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: '31-60', fieldName: 'o31_60',  wrapText: true, type: 'currency' ,cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: '61-75', fieldName: 'o61_75',  wrapText: true, type: 'currency', cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: '76-90', fieldName: 'o76_90',  wrapText: true, type: 'currency', cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: '> 90', fieldName: 'Above_90',  wrapText: true, type: 'currency', cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: $A.get("$Label.c.Net_Outstanding") , fieldName: 'Net_Outstanding',  wrapText: true, type: 'currency', cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}}
            
        ]);
        
        
        
        component.set('v.mycolumns3', [
            {label: $A.get("$Label.c.Bounce"), fieldName: 'Bounce__c', wrapText: true,type: 'currency',cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: '01-15', fieldName: 'X1_15__c', wrapText: true, type: 'currency',cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: '16-30', fieldName: 'X16_30__c', wrapText: true, type: 'currency',cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: '31-60', fieldName: 'X31_60__c', wrapText: true, type: 'currency',cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: '61-90', fieldName: 'X61_90__c', wrapText: true, type: 'currency',cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: '91-120', fieldName: 'X91_120__c', wrapText: true, type: 'currency',cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: $A.get("$Label.c.Total_Collectibles") , fieldName: 'Total_Collectibles__c', wrapText: true, type: 'currency',cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: $A.get("$Label.c.Total_Collection"), fieldName: 'Total_Collection__c', wrapText: true, type: 'currency',cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: $A.get("$Label.c.Non_Forecasted_Collection") , fieldName: 'Non_Forecasted_Collection__c',wrapText: true,  type: 'currency',cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: $A.get("$Label.c.Forecasted_Collection") , fieldName: 'Forecasted_Collection__c', wrapText: true, type: 'currency',cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            
            
        ]);
            
            
            component.set('v.mycolumns4', [
            {label: $A.get("$Label.c.Amount"), fieldName: 'Amount__c', type: 'currency',cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: $A.get("$Label.c.Amount_in_LC") , fieldName: 'Amount_in_LC__c', type: 'currency',cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: $A.get("$Label.c.Assignment"), fieldName: 'Assignment__c', type: 'text',cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: $A.get("$Label.c.Net_Overdue") , fieldName: 'Net_Overdue__c', type: 'currency',cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: $A.get("$Label.c.Posting_Date") , fieldName: 'Posting_Date__c', type: 'date',cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: $A.get("$Label.c.Status") , fieldName: 'Status__c', type: 'text',cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: $A.get("$Label.c.Zone") , fieldName: 'Zone__r.Name', type: 'text',cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}},
            {label: $A.get("$Label.c.Special_G_L_Ind") , fieldName: 'Special_GL_Ind__c', type: 'text',cellAttributes: { alignment: 'left' },typeAttributes:{currencyCode:"",currencyDisplayAs:"symbol"}}
            
        ]);
        
        
    },
    
    //Change by Swaranjeet(Grazitti) APPS-1315
    // showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
      //  component.set("v.spinner", true); 
    //},
     
    // function automatic called by aura:doneWaiting event 
   // hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
     //   component.set("v.spinner", false);
    //},
    
    openPDF:function(component,event,helper){
        
        console.log('click on div tag');
        helper.gotoDownloadPDF(component,event,helper);
        
    },
    
    openExcel:function(component,event,helper){
        
        console.log('click on div tag');
        helper.gotoDownloadExcel(component,event,helper);
        
    },
    

    openPDFAS:function(component,event,helper){
        
        console.log('click on div tag');
        helper.gotoDownloadPDFAS(component,event,helper);
         
        
    },
    
    openExcelAS:function(component,event,helper){
        
        console.log('click on div tag');
        helper.gotoDownloadExcelAS(component,event,helper);
        
    },
    
});