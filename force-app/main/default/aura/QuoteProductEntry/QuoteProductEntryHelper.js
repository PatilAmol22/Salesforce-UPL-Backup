({
    searchHelper : function(component,event,getInputkeyWord) {
        // call the apex class method 
        var action = component.get("c.fetchSKUValues");
        // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'quoteId': component.get("v.recordId")
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    },
    
    searchHelperOnKeyPress : function(component,event,helper,getInputkeyWord){
        var action = component.get("c.searchHelperOnKeyPres");
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'quoteId': component.get("v.recordId")
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
                //alert('storeResponse '+storeResponse);
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                
                console.log('storeResponse in Helper Method after click '+storeResponse);
                component.set("v.listOfSearchRecords", storeResponse);
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
        
    },
    
    
    insertQuotelineItem: function(component,event,helper){
        var listofQuote = component.get("v.quoteLineItemList");
        console.log('IN helper listofQuote '+JSON.stringify(listofQuote));
        var action = component.get('c.saveQuoteLineItem'); 
        action.setParams({
            "ListQuote" : listofQuote
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                if(a.getReturnValue()=='Success'){
                    component.set("v.isStatus",true);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    clearAll:function(component,event,helper){
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        //document.getElementById('description').value ='';
        component.find("description").set("v.value", "");
        component.set("v.quantity","") ;
        component.set("v.price","") ;
        component.set("v.amount","") ;
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.selectedRecord", {} );  
        component.set("v.disableFields", true ); 
        component.set("v.packSize", "" ); 
    },
    
    fetchAllQuoteLineItem: function(component,event,helper,quoteId){
        console.log('Loading All Quote Line Item ');
        var action = component.get('c.fetchAllQuoteItem'); 
        
        action.setParams({
            "quoteId" : quoteId 
        });
        
        
        action.setCallback(this, function(a){
            var temJson = JSON.stringify(a.getReturnValue());
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                if(temJson.length==2){
                    //component.set('v.disableComfirm',true);
                    component.set('v.quoteLineItemList', a.getReturnValue()); 
                }else{
                    component.set('v.quoteLineItemList', a.getReturnValue());    
                    component.set('v.disableComfirm',false);
                }
                
            }
        });
        $A.enqueueAction(action);  
        
    },
    
    
    gettingSinleQuoteLineItem: function(component,event,helper,quoteLitemId){
        var action = component.get('c.fetchsingleQuoteLineItem'); 
        
        action.setParams({
            "quoteLitemId" : quoteLitemId 
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('a.getReturnValue() in Helper  '+JSON.stringify(a.getReturnValue()));
                var temQuoteLineItem = a.getReturnValue();
                if(temQuoteLineItem.Product2.Product_Code__c=='0000000000'){
                    component.set("v.disableFieldsPopup",false);
                    document.getElementById('descriptionPopup').disabled = false;
                    
                }else{
                    component.set("v.disableFieldsPopup",true);
                    document.getElementById('descriptionPopup').disabled = false;
                }
                
                document.getElementById('descriptionPopup').value = temQuoteLineItem.Description;
                component.set("v.packSizePopup",temQuoteLineItem.Pack_Size__c);
                component.set("v.quantityPopup",temQuoteLineItem.Quantity);
                component.set("v.pricePopup",temQuoteLineItem.UnitPrice);
                component.set("v.amountPopup",temQuoteLineItem.TotalPrice);
                component.set("v.selectedRecordPopup",temQuoteLineItem);
                component.set("v.ProductNamePop",temQuoteLineItem.Product2.Name);
            }
        });
        $A.enqueueAction(action); 
    },
    
    
    
    updateQuoteLineItem : function(component,event,helper){
        var listofQuote = component.get("v.quoteLineItemListPopup");
        
        var action = component.get('c.updateQuoteLineItem'); 
        action.setParams({
            "ListQuote" : listofQuote
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                if(a.getReturnValue()=='Success'){
                    component.set("v.isStatus",true);
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    
    deleteQuoteLineItems : function(component,event,helper,quoteLineId){
        
        var action = component.get('c.deleteQuoteLineItms'); 
        action.setParams({
            "quoteLineId" : quoteLineId
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
               
                if(a.getReturnValue()=='Success'){
                    alert('Deleted Successfully. ');
                }else{
                    alert(a.getReturnValue());
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    searchHelperOnKeyPressPopup : function(component,event,helper,getInputkeyWord){
        var action = component.get("c.searchHelperOnKeyPresPopup");
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'quoteId': component.get("v.recordId")
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
                //alert('storeResponse '+storeResponse);
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                component.set("v.listOfSearchRecords", storeResponse);
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    },
    
    sendApproval:function(component,event,helper){
        var action = component.get('c.submitToApproval'); 
        
        action.setParams({
            "quoteId" : component.get('v.recordId') 
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                this.gotoURL(component, component.get('v.recordId')); 
                
            }
        });
        $A.enqueueAction(action);
        
    },
    
    
    gotoURL : function (component,recordId) {
        // alert('in goto event ');
        var device = $A.get("$Browser.formFactor");
        var recrdId = recordId;
        
        if(device=='DESKTOP'){
            try{
                sforce.one.navigateToSObject(recordId);
            }catch(err){
                console.log('catch');
                this.navigateToComponent(component,recrdId);
            }
        }
        else{
            // console.log('else url'+recordId);
            sforce.one.navigateToSObject(recordId);
        }       
        
    },
    
    
    navigateToComponent: function(component,recrdId){
        var navEvent = $A.get("e.force:navigateToSObject");
        
        if(navEvent!=undefined){
            
            navEvent.setParams({
                "recordId": recrdId,
                "slideDevName": related
                
            });
            navEvent.fire();    
            
        }
        else{
            window.history.back();
        }
    },
    
    checkSubmitToApproval:function(component,event,helper,recordId){
        //calling apex method
        var action = component.get('c.checkApprovalProcess'); 
        action.setParams({
            "quoteId" : recordId 
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                var result = a.getReturnValue();
                console.log('result at helper approval check '+result);
                if(result=='true'){
                    component.set("v.disableComfirm",true);
                    
                }else{
                    component.set("v.disableComfirm",false);
                    
                }
                
            }
        });
        $A.enqueueAction(action);
        
    },
    
})