({
    searchHelper : function(component,event,getInputkeyWord) {
        // call the apex class method 
        var action = component.get("c.fetchSKUValues");
        // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'oppId': component.get("v.recordId")
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
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
            'oppId': component.get("v.recordId")
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
                    component.set("v.Message", $A.get("$Label.c.No_Records_Found"));
                } else {
                    component.set("v.Message", '');
                }
                component.set("v.listOfSearchRecords", storeResponse);
            }
            
        });
        // enqueue the Action  
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
    
    fetchPriceBook : function(component,event,selProdId){
        console.log('at helper selProdId '+selProdId);
        var action = component.get('c.fetchPriceBookMasterDetails'); 
        var oppId = component.get("v.recordId");
        action.setParams({
            "productId" : selProdId,
            "oppId" :oppId
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            
            
            if(state == 'SUCCESS') {
                var pbmList = a.getReturnValue();
                component.set("v.UOM",pbmList[0].UOM);
                component.set("v.packSize",pbmList[0].PackSize);
                component.set("v.maxPrice",pbmList[0].MaxPrice);
                
                var minprice = pbmList[0].MinPrice;
                //console.log('@@@ minprice '+minprice);
                //var minprice1 = (minprice - (2/100 * minprice)).toFixed(4);
                
                component.set("v.minPrice",minprice);
                
               
                
                component.set("v.SKUId",pbmList[0].SKUId);
                
                component.set("v.depotId",pbmList[0].depotId);
                component.set("v.storageLocation",pbmList[0].storageLocation);
                
                console.log('Division is '+pbmList[0].division);
                console.log('Distribution Channel is '+pbmList[0].distributionChannel);
                console.log('sales Org '+pbmList[0].SalesOrg);
                
                
                component.set("v.division",pbmList[0].division);
                component.set("v.distributionChannel",pbmList[0].distributionChannel);
                component.set("v.SalesOrg",pbmList[0].SalesOrg);
                
                 component.set("v.Inventory",pbmList[0].available2);
                
                
                
                
                
               
            }
            
            if(state == 'ERROR'){
                alert($A.get("$Label.c.Price_Book_not_found"));
            }
        });
        $A.enqueueAction(action);
        
    },
    
    insertOppotunitylibeItem : function(component,event,helper){
        var listofOppo = component.get("v.opportunityLineItemList");
        
        var action = component.get('c.saveOpportunityLineItem'); 
        action.setParams({
            "ListOpportunity" : listofOppo
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            
            if(state == 'SUCCESS') {
                if(a.getReturnValue()=='pricebook entry currency code does not match opportunity currency code'){
                    component.set("v.isStatus",true);
                    //component.set("v.errorMSG","Error :- pricebook entry currency code does not match opportunity currency code");
                    //setTimeout(function(){ component.set("v.errorMSG",""); }, 6000);  
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    
    
    
    fetchAllOpportunityLineItem : function(component,event,helper,oppId){
        console.log('Loading All Opportunity Line Item ');
        var action = component.get('c.fetchAllOppoLineItem'); 
        
        action.setParams({
            "oppoId" : oppId 
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                component.set('v.oppoLineItemList', a.getReturnValue());
            }
        });
        $A.enqueueAction(action);  
    },
    
    
    showSpinner: function(component,event,helper) {
        var spinnerMain =  component.find("Spinner");
        $A.util.removeClass(spinnerMain, "slds-hide");
    },
    
    hideSpinner : function(component,event,helper) {
        var spinnerMain =  component.find("Spinner");
        $A.util.addClass(spinnerMain, "slds-hide");
    },
    
    clearAll : function(component,event,helper){
        
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.quantity","0") ;
        component.set("v.price","0.00") ;
        component.set("v.amount","0") ;
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.selectedRecord", {} );  
        component.set("v.disableFields", true ); 
        component.set("v.packSize", "" );
        component.set("v.UOM", "" );
        component.set("v.maxPrice", "" );
        component.set("v.Inventory", "" );
        component.set("v.minPrice", "" );
        component.set("v.SKUId", "" );
        
        component.set("v.depotId", "" );
        component.set("v.storageLocation", "" );
        
    },
    
    
    
    deleteoppotunityLineItem : function(component,event,helper,oppoLitemId){
        var action = component.get('c.deleteOpportunityLineItem'); 
        action.setParams({
            "oppolineItemId" : oppoLitemId
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                if(a.getReturnValue()=='Success'){
                    // component.set("v.isStatus",true);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    gettingSinleOpportunityLineItem: function(component,event,helper,oppoLitemId){
        console.log('oppoLitemId '+oppoLitemId);
        
        var action = component.get('c.fetchsingleOppoLineItem'); 
        
        action.setParams({
            "oppoLIId" : oppoLitemId 
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('a.getReturnValue() in Helper  '+JSON.stringify(a.getReturnValue()));
                var temOppoLineItem = a.getReturnValue();
                
                var prodDes = temOppoLineItem.Product2.Description;
                
                
                component.set("v.disableFieldsPopup",true);
                document.getElementById('descriptionPopup').disabled = true;    
                document.getElementById('descriptionPopup').value = temOppoLineItem.Product2.Description;
                component.set("v.packSizePopup",temOppoLineItem.Pack_Size__c);
                component.set("v.quantityPopup",temOppoLineItem.Quantity);
                component.set("v.pricePopup",temOppoLineItem.UnitPrice);
                component.set("v.amountPopup",temOppoLineItem.TotalPrice);
                
                component.set("v.UOMPopup",temOppoLineItem.UOM__c);
                component.set("v.minPricePopup",temOppoLineItem.Min_Price__c);
                component.set("v.maxPricePopup",temOppoLineItem.Max_Price__c);
                component.set("v.selectedRecordPopup",temOppoLineItem);
                component.set("v.ProductNamePop",temOppoLineItem.Product2.Description);
                
                
                
            }
        });
        $A.enqueueAction(action); 
        
    },
    
    updateOppotunitylibeItem : function(component,event,helper){
        var listofOppo = component.get("v.opportunityLineItemListPopup");
        
        var action = component.get('c.updateOpportunityLineItem'); 
        action.setParams({
            "ListOpportunity" : listofOppo
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