({
	
    //Logic to show/hide modal by toggling css class .tog
    toggle: function(component){
        var lookupmodal = component.find("lookupmodal");
        $A.util.toggleClass(lookupmodal, "slds-hide");
        
        var backdrop = component.find("backdrop");
        $A.util.toggleClass(backdrop, "slds-hide");
    },
    closePopUp: function(component) {
        this.toggle(component);
    },
    /* -------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022-------------------- */
    fetchLoginCountry:function(component, event, helper){
        console.log('In the child component of SKU ');
        //fetchLogingCountry
        var action = component.get('c.fetchLogingCountry'); 
        
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('In the child component Data '+a.getReturnValue())
                component.set('v.loginCountryObjs', a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    /* -----------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022-------------------- */
    updateDraftOrder :function(component, event, orderItem) { 
        console.log('orderItem@@@'+JSON.stringify(orderItem));
        var accId = component.get("v.newSalesOrder.Sold_to_Party__c");
        var newSO = component.get("v.newSalesOrder");
        var action = component.get("c.updateOrderItem");
                    action.setParams({ 
                        "salesOrderItemString": JSON.stringify(orderItem),
                        "soObj2": newSO,
                        "accountId": accId 
                        });  
        action.setCallback(this, function(a) {
                component.set("v.showSpinner", false);                
				
        });  
      $A.enqueueAction(action);  
    },
    
})