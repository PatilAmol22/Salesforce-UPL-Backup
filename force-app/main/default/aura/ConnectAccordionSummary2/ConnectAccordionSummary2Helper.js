({
    showHideDetails:function(component,event,helper){
        console.log('showHideDetails method');
        var action = component.get('c.showHideDetailsInfo'); 
        
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                var device = $A.get("$Browser.formFactor"); //For Poland added by Akhilesh
                console.log('device type'+device);
                var returnValue = JSON.stringify(a.getReturnValue());
                console.log('returnValue '+returnValue);
                console.log('a.getReturnValue() '+a.getReturnValue());
                var creditInfo,accState,outStandAge,paymetDetails,outstandings;
                creditInfo='';
                accState='';
                outStandAge='';
                paymetDetails='';
                outstandings='';
                creditInfo =a.getReturnValue()[0].Credit_Information__c;
                accState =a.getReturnValue()[0].Account_Statement__c;
                outStandAge =a.getReturnValue()[0].Outstanding_Ageing__c;
                paymetDetails =a.getReturnValue()[0].Payment_Details__c;
                outstandings=a.getReturnValue()[0].Outstandings__c;
                var countryName = '';
                countryName = a.getReturnValue()[0].Country__c;
                
                if(countryName=='Japan'){
                    component.set('v.mycolumns1', [
                        {label:$A.get("$Label.c.Opening_Balance"), fieldName: 'Opening_Balance__c', type: 'currency',typeAttributes: {currencyDisplayAs: "code"},cellAttributes: { alignment: 'left' },hideDefaultActions: true},
                        //{label: $A.get("$Label.c.Credit") , fieldName: 'Credit__c', type: 'currency' ,cellAttributes: { alignment: 'left' }},
                        //{label: $A.get("$Label.c.Debit") , fieldName: 'Debit__c', type: 'currency', cellAttributes: { alignment: 'left' }},
                        {label: $A.get("$Label.c.Closing_Balance"), fieldName: 'Closing_Balance__c', type: 'currency', typeAttributes: {currencyDisplayAs: "code"},cellAttributes: { alignment: 'left' },hideDefaultActions: true}
                        
                    ]);
                    
                }else{
                    component.set('v.mycolumns1', [
                        {label:$A.get("$Label.c.Opening_Balance"), fieldName: 'Opening_Balance__c', type: 'currency',typeAttributes: {step: '0.00001',maximumFractionDigits: '3'} , wrapText: true, cellAttributes: { alignment: 'left' }},
                        {label: $A.get("$Label.c.Credit") , fieldName: 'Credit__c', type: 'number' ,wrapText: true, typeAttributes: {step: '0.00001',maximumFractionDigits: '3'},cellAttributes: { alignment: 'left' }},
                        {label: $A.get("$Label.c.Debit") , fieldName: 'Debit__c', type: 'number', wrapText: true, typeAttributes: {step: '0.00001',maximumFractionDigits: '3'},cellAttributes: { alignment: 'left' }},
                        {label: $A.get("$Label.c.Closing_Balance"), fieldName: 'Closing_Balance__c', type: 'currency',typeAttributes: {step: '0.00001',maximumFractionDigits: '3'},wrapText: true, cellAttributes: { alignment: 'left' }}
                        
                    ]);
                }
                
                
                if(countryName=='Poland'){
                    component.set("v.ctryNameflag",false);
                }else{
                    component.set("v.ctryNameflag",true);
                }         
            
                console.log(' creditInfo '+creditInfo);
                console.log(' accState '+accState);
                console.log(' outStandAge '+outStandAge);
                console.log(' paymetDetails '+paymetDetails);
                
                
                component.set("v.showDetailCreditInfo",creditInfo);
                component.set("v.showDetailAccStateInfo",accState);
                component.set("v.showDetailOutStandAgeInfo",outStandAge);
                component.set("v.showDetailPaymentDeatilsInfo",paymetDetails);
                component.set("v.showDetailOutstandinginfo",outstandings);
                
                
                //component.set('v.sObjList', a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
        
    },
    
    
    Credit_Information : function(component,event,helper) {
        console.log('in helper Credit_Information');
        var action = component.get('c.getting_Credit_Information1'); 
        
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            console.log('state credit '+state);
            
            
            if(state == 'SUCCESS') {
                
                
                console.log('credit data-- '+JSON.stringify(a.getReturnValue()));
                if(a.getReturnValue()!=null){
                    var temCuriso = a.getReturnValue()[0].DistributorCurrencyIsoCode;
                    var lastModDate  =a.getReturnValue()[0].LastModifiedDate;
                    console.log('lastModDate in new account '+lastModDate);
                    
                    component.set("v.onDate",lastModDate) ;
                    console.log('hello i m here---');
                    console.log('temCuriso '+temCuriso);
                    component.set("v.currencyCode1",temCuriso);
                    component.set('v.creditInfoList', a.getReturnValue());    
                }else{
                    console.log('Data not found Credit_Information');
                       var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type" :"Error",
                            "title": "Error!",
                            "message": "Data not found Credit Information."
                        });
                        toastEvent.fire();
                }
                
            }
              //Change by Swaranjeet(Grazitti) APPS-1315
             if(state == 'ERROR') {
                  console.log('Sap UserId found Credit_Information');
                       var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type" :"Error",
                            "title": "Error!",
                            "message": "Sap UserId not found Credit Information."
                        });
                        toastEvent.fire();
             }
        });
        $A.enqueueAction(action);
        
        
    },
    
    
    
    
    Account_Statement : function(component,event,helper) {
        console.log('in helper Account_Statement');
        
        component.set("v.spinner", true);
        var action = component.get('c.account_Statement_Information'); 
        
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            console.log('yes state',state);
            if(state == 'SUCCESS') {
                
                if(a.getReturnValue()!=null){
                    console.log('poland--'+JSON.stringify(a.getReturnValue()));
                    console.log('poland1--'+a.getReturnValue()[0].Country__c);
                    var temCuriso='';
                    if(a.getReturnValue()[0].Country__c=='Turkey'){
                        temCuriso = 'TRY';
                    }else if(a.getReturnValue()[0].Country__c=='Japan'){
                        temCuriso = 'JPY';
                    }
                    //Change by Swaranjeet(Grazitti) APPS-1315
                        else if(a.getReturnValue()[0].Country__c=='Colombia'){
                            temCuriso = 'COP';
                        }
                            else if(a.getReturnValue()[0].Country__c=='Poland'){
                                temCuriso = 'PLN';
                            }
                                else if(a.getReturnValue()[0].Country__c=='Spain'){
                                    temCuriso = 'EUR';
                                }
                                    else if(a.getReturnValue()[0].Country__c=='Portugal'){
                                        temCuriso = 'EUR';
                                    }
                                        else{
                                            temCuriso = a.getReturnValue()[0].Account__r.CurrencyIsoCode;
                                        }
                    var lastModDate  =a.getReturnValue()[0].LastModifiedDate;
                    console.log('lastModDate123 '+lastModDate);
                    component.set("v.onDate1",lastModDate) ;
                    
                    component.set("v.currencyCode2",temCuriso);
                    component.set('v.AccountStatementList', a.getReturnValue()); 
                    
                    component.set("v.spinner", false);
                    
                }else{
                    
                    console.log('Data Not found Account_Statement');
                    component.set("v.spinner", false);
                 //Change by Swaranjeet(Grazitti) APPS-1315
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type" :"Error",
                            "title": "Error!",
                            "message": "Data Not found Account Statement."
                        });
                        toastEvent.fire();
                   
                }
                
            }
          
            else{
                component.set("v.spinner", false);
            }
            
        });
        
        
        $A.enqueueAction(action);
    },
    
    Outstanding_Ageing : function(component,event,helper) {
        console.log('in helper Outstanding_Ageing');
        var action = component.get('c.outstanding_Ageing_Information'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            
            
            
            if(state == 'SUCCESS') {
                
                if(a.getReturnValue()!=null){
                    console.log('State in out', JSON.stringify(a.getReturnValue()));
                    var temCuriso = a.getReturnValue()[0].currencyKey123;
                    var lastModDate  =a.getReturnValue()[0].LastModifiedDate;
                    
                    console.log('get date--',lastModDate);
                    component.set("v.onDate2",lastModDate) ;
                    
                    component.set("v.currencyCode3",temCuriso);
                    
                    
                    component.set("v.closingBal",a.getReturnValue()[0].Net_Outstanding);
                    
                    component.set('v.outstandingAgeingList', a.getReturnValue());    
                    
                }else{
                    console.log('Data Not found Outstanding_Ageing');
                    //Change by Swaranjeet(Grazitti) APPS-1315
                      var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type" :"Error",
                            "title": "Error!",
                            "message": "Data Not found Outstanding Ageing."
                        });
                        toastEvent.fire();
                }
                
                
            }
             
        });
        $A.enqueueAction(action);
        
        
    },
    
    Payment_Detail : function(component,event,helper) {
        console.log('in helper Payment_Detail');
        var action = component.get('c.collection_Information'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            console.log('for payment Details a.getReturnValue() '+a.getReturnValue());
            var returnValue = a.getReturnValue();
            
            if(returnValue!=null){
                var temCuriso = a.getReturnValue()[0].Customer_Name__r.CurrencyIsoCode;
                var lastModDate  =a.getReturnValue()[0].LastModifiedDate;
                
                component.set("v.onDate3",lastModDate) ;
                
                component.set("v.currencyCode",temCuriso); 
            }
            
            
            if(state == 'SUCCESS') {
                component.set('v.collectionList', a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        //
    },
    
    
    gotoDownloadPDF:function(component,event,helper){
        console.log('gotoDownloadPDF method ');
        var urlAdd = component.get("v.urlAddress");
        console.log('urlAdd in pdf method567 '+urlAdd);
        window.open(urlAdd+'/apex/AccountSummaryReport');
        //https://uat-upl.cs117.force.com/Distributor/s/account-summary-
    },
    
    
    gotoDownloadExcel:function(component,event,helper){
        console.log('Excel Method  ');
        
        var urlAdd = component.get("v.urlAddress");
        window.open(urlAdd+'/apex/AccountSummaryExcel');
        
    },
    
    
    gotoDownloadPDFAS:function(component,event,helper){
        console.log('gotoDownloadPDF method ');
        var urlAdd = component.get("v.urlAddress");
        console.log('urlAdd in pdf method123 '+urlAdd);
        window.open(urlAdd+'/apex/AccountStatementReport');
    },
    
    
    gotoDownloadExcelAS:function(component,event,helper){
        console.log('Excel Method  ');
        var urlAdd = component.get("v.urlAddress");
        window.open(urlAdd+'/apex/AccountStatementExcel');
        
    },
    
    
    
    AccountTstatement:function(component,event,helper){
        console.log('in AccountTstatement ');
        var action = component.get('c.accountStatement'); 
        
        
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            console.log('State in account now '+state); 
            if(state == 'SUCCESS') {
                console.log('account data verification',a.getReturnValue()[0]);
                console.log('@@@@@@ in account state '+a.getReturnValue()[0].Closing_Balance__c);
                console.log('@@@@@@ in account state rrr '+a.getReturnValue()[0].LastModifiedDate);
                component.set("v.onDate4",a.getReturnValue()[0].LastModifiedDate);
                
                component.set("v.closingBal",a.getReturnValue()[0].Net_Outstanding);
                
                
            }
        });
        $A.enqueueAction(action);
    },
    
    getOverdue:function(component,event,helper){
        console.log('in Overdue function helper');
        var action = component.get('c.gettingOverdue'); 
        
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                var overdueAmt = a.getReturnValue();
                console.log('overdueAmt in account summary '+overdueAmt);
                component.set("v.overdueAmt",overdueAmt);
                //component.set('v.sObjList', a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    
    getUrlAddress:function(component,event,helper){
        console.log('ingetting url address Method ');
        var action = component.get('c.gettingUrlAddress'); 
        
        
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
             var windowUrl= (window.location.href).split('/s/')[0];
                //component.set('v.urlAddress', a.getReturnValue());
                component.set('v.urlAddress',windowUrl);
            }
        });
        $A.enqueueAction(action);
        
        
    },
    
    
    
})