({
    fetchAllQuoteLineItem: function(component,event,helper,quoteId){
        console.log('Loading All Quote Line Item ');
        var action = component.get('c.fetchAllQuoteItem'); 
       
        action.setParams({
            "quoteId" : quoteId 
        });
        
      
        action.setCallback(this, function(a){
            var temJson = JSON.stringify(a.getReturnValue());
            var state = a.getState(); 
            if(state == 'SUCCESS') {
                if(temJson.length==2){
                    component.set('v.disableComfirm',true);
                    component.set('v.quoteLineItemList', a.getReturnValue()); 
                }else{
                    component.set('v.quoteLineItemList', a.getReturnValue());    
                    component.set('v.disableComfirm',false);
                }
                
            }
        });
        $A.enqueueAction(action);  
        
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
                console.log('fetchSKUValues response - ',storeResponse);
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", $A.get("$Label.c.No_Records_Found"));
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
                console.log('searchHelperOnKeyPres response - ',storeResponse);
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
                //alert('storeResponse '+storeResponse);
                if (storeResponse.length == 0) {
                    component.set("v.Message", $A.get("$Label.c.No_Records_Found"));
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
    
    
    fetchPriceBook : function(component,event,selProdId){
        console.log('selProdId '+selProdId);
        var action = component.get('c.fetchPriceBookMasterDetails'); 
        
        action.setParams({
            "productId" : selProdId,
            "quoteId" : component.get("v.recordId")
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                var pbmList = a.getReturnValue();
                
                console.log('pbmList '+pbmList);
                console.log('pbmList[0].PackSize '+pbmList[0].PackSize);
                console.log('pbmList '+pbmList);
                
                component.set("v.UOM",pbmList[0].UOM);                
                component.set("v.packSize",pbmList[0].PackSize);
                component.set("v.maxPrice",pbmList[0].MaxPrice);
                var minprice = pbmList[0].MinPrice;
                
               // var minprice1 =( minprice - (2/100 * minprice)).toFixed(4);
                
                
                
                component.set("v.minPrice",minprice);
                
                
                
                
                component.set("v.SKUId", pbmList[0].SKUId );
               // component.set("v.itemNumber", pbmList[0].itemNumber );
                component.set("v.depotId", pbmList[0].depotId );
                component.set("v.storageLocation", pbmList[0].storageLocation );
                component.set("v.division",pbmList[0].division);
                component.set("v.distributionChannel",pbmList[0].distributionChannel);
                component.set("v.SalesOrg",pbmList[0].SalesOrg);
                component.set("v.Inventory",pbmList[0].available2);
            }
            if(state == 'ERROR') {
               alert('Price Book not found.');
            }
        });
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
        
        
        
        component.set("v.quantity","") ;
        component.set("v.price","") ;
        component.set("v.amount","") ;
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.selectedRecord", {} );  
        component.set("v.disableFields", true ); 
        component.set("v.packSize", "" ); 
        component.set("v.UOM", "" ); 
        component.set("v.minPrice", "" ); 
        component.set("v.maxPrice", "" ); 
        component.set("v.Inventory", "" );
        component.set("v.SKUId", "" );
        component.set("v.itemNumber", "" );
        component.set("v.depotId", "" );
        component.set("v.storageLocation", "" );
        
        
    },
    
    
    showSpinner: function(component,event,helper) {
        var spinnerMain =  component.find("Spinner");
        $A.util.removeClass(spinnerMain, "slds-hide");
    },
    
    hideSpinner : function(component,event,helper) {
        var spinnerMain =  component.find("Spinner");
        $A.util.addClass(spinnerMain, "slds-hide");
    },
    
    
    
    gettingSinleQuoteLineItem: function(component,event,helper,quoteLitemId){
        var action = component.get('c.fetchsingleQuoteLineItem'); 
        
        action.setParams({
            "quoteLitemId" : quoteLitemId 
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                
                var temQuoteLineItem = a.getReturnValue();
                document.getElementById('descriptionPopup').disabled = true;
                document.getElementById('descriptionPopup').value = temQuoteLineItem.Product2.Description;
                component.set("v.packSizePopup",temQuoteLineItem.Pack_Size__c);
                component.set("v.quantityPopup",temQuoteLineItem.Quantity);
                component.set("v.pricePopup",temQuoteLineItem.UnitPrice);
                component.set("v.amountPopup",temQuoteLineItem.TotalPrice);
                component.set("v.selectedRecordPopup",temQuoteLineItem);
                component.set("v.ProductNamePop",temQuoteLineItem.Product2.Name);
                component.set("v.minPricePopup",temQuoteLineItem.Min_Price__c);
                component.set("v.maxPricePopup",temQuoteLineItem.Max_Price__c);
                component.set("v.UOMPopup",temQuoteLineItem.UOM__c);
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
    
     showHideInventory : function(component,event,helper){
        var action = component.get('c.InventoryShow'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                if(a.getReturnValue().Show_InTransit__c && a.getReturnValue().Show_InTransit_Values__c ){
                    component.set('v.showHideInventory', true);
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    
    
})