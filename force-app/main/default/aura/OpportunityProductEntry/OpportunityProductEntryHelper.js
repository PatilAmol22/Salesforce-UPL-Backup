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
    
    showErrorToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error Message',
            message:'Quantity should be Numeric.',
            messageTemplate: 'Mode is pester ,duration is 5sec and Message is overrriden',
            duration:'3000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    
    //this function is used to insert the opportunity line Item Into opportunitylineItem Standard object
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
                    component.set("v.errorMSG","Error :- pricebook entry currency code does not match opportunity currency code");
                    setTimeout(function(){ component.set("v.errorMSG",""); }, 6000);  
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    clearAll : function(component,event,helper){
        
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
       // document.getElementById('description').value ='';
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
                if(prodDes!=undefined){
                    document.getElementById('descriptionPopup').value ='';
                }else{
                      document.getElementById('descriptionPopup').value = prodDes;
                }
                
                
                
                if(temOppoLineItem.Product2.Product_Code__c=='0000000000'){
                    component.set("v.disableFieldsPopup",false);
                    document.getElementById('descriptionPopup').disabled = false;    
                    
                }else{
                    component.set("v.disableFieldsPopup",true);
                    document.getElementById('descriptionPopup').disabled = false;    
                }
                
                document.getElementById('descriptionPopup').value = temOppoLineItem.Description;
                component.set("v.packSizePopup",temOppoLineItem.Pack_Size__c);
                component.set("v.quantityPopup",temOppoLineItem.Quantity);
                component.set("v.pricePopup",temOppoLineItem.UnitPrice);
                component.set("v.amountPopup",temOppoLineItem.TotalPrice);
                component.set("v.selectedRecordPopup",temOppoLineItem);
                //alert('temOppoLineItem.Product2.Name '+temOppoLineItem.Product2.Name);
                component.set("v.ProductNamePop",temOppoLineItem.Product2.Description);
                
               
                
            }
        });
        $A.enqueueAction(action); 
        
    },
    
    
    searchHelperOnKeyPressPopup : function(component,event,helper,getInputkeyWord){
        console.log('searchHelperOnKeyPressPopup '+getInputkeyWord);
        
        var action = component.get('c.searchHelperOnKeyPresPopup'); 
       
        action.setParams({
            "searchKeyWord" : getInputkeyWord, 
            "oppId":component.get("v.recordId")
            
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                component.set('v.listOfSearchRecords', a.getReturnValue());
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
    
    
    showSpinner: function(component,event,helper) {
		var spinnerMain =  component.find("Spinner");
		$A.util.removeClass(spinnerMain, "slds-hide");
	},
 
	hideSpinner : function(component,event,helper) {
		var spinnerMain =  component.find("Spinner");
		$A.util.addClass(spinnerMain, "slds-hide");
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
    
    
    
    
})