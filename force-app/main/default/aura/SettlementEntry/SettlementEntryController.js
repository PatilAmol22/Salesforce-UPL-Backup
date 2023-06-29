({
    doInit: function(component, event, helper) {
        helper.getFormFields(component);
    },
    
    openItemModal: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpenItem", true);
        helper.getItemFields(component);
        helper.applyCSS(component);
        helper.callEvent(component);
    },
    
    closeItemModal: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "False"  
        component.set("v.isOpenItem", false);
        helper.revertCssChange(component);
        helper.callEvent(component);
    },
    
    openLiquidationModal: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpenLiquidation", true);
        helper.applyCSS(component);
        helper.callEvent(component);
    },
    
    closeLiquidationModal: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "False"  
        component.set("v.isOpenLiquidation", false);
        helper.revertCssChange(component);
        helper.callEvent(component);
    },
        
    addItem: function(component, event, helper) {
        
        var isValid = true;
        
        var item = component.find("itemOptions").get("v.value");
        var otherItem = component.find("otheritem").get("v.value");
        var description = component.find("description").get("v.value");
        var nou = component.find("nou").get("v.value");
        var cpu = component.find("cpu").get("v.value");
        var subtotal = component.find("subtotal").get("v.value");
        
        var settlementItemList = component.get("v.settlementItemList");
        
        var target = event.getSource();  
        //Deeksha:Added for INCTASK0290227 Start
        var index ;
        if(target.get("v.labelClass") === ''){
            index = settlementItemList.length;
        }else{
            index = target.get("v.labelClass");
        }
        //Deeksha:Added for INCTASK0290227 End
        if(item=='None'){
            isValid = false;
            component.find("itemOptions").set("v.errors",[{message: 'Complete this field'}]);                    
        }
        else if(item=='LAIN-LAIN' && otherItem==''){
            isValid = false;
            component.find("otheritem").set("v.errors",[{message: 'Complete this field'}]);                    
        }
        else{
            component.find("itemOptions").set("v.errors",null);   
            component.find("otheritem").set("v.errors",null);   
        }
        
        /*if(!description){
            isValid = false;
            component.find("description").set("v.errors",[{message: 'Complete this field'}]);                    
        }
        else{
            component.find("description").set("v.errors",null);    
        }*/
        
        if(!nou){
            isValid = false;
            component.find("nou").set("v.errors",[{message: 'Complete this field'}]);                    
        }
        else{
            component.find("nou").set("v.errors",null);    
        }
        
        if(!cpu){
            isValid = false;
            component.find("cpu").set("v.errors",[{message: 'Complete this field'}]);                    
        }
        else{
            component.find("cpu").set("v.errors",null);    
        }
        
        if(isValid){
            if(settlementItemList[index]){
                settlementItemList[index].item = item;
                settlementItemList[index].otherItem = otherItem;
                settlementItemList[index].description = description;
                settlementItemList[index].nou = nou;
                settlementItemList[index].cpu = cpu;
                settlementItemList[index].subtotal = subtotal;
            }
            else{
                index = settlementItemList.length;
                settlementItemList.push({
                    item: item,
                    otherItem: otherItem,
                    description: description,
                    nou : nou,
                    cpu : cpu,
                    subtotal : subtotal,
                    index : index
                });
            }
            component.find("itemOptions").set("v.value",'None');
            component.find("otheritem").set("v.value",'');
            component.find("description").set("v.value",'');
            component.find("nou").set("v.value",'');
            component.find("cpu").set("v.value",'');
            component.find("subtotal").set("v.value",'');
            component.find("addItem").set("v.labelClass",'');
            component.set("v.settlementItemList",settlementItemList);
            
            helper.getTotalItem(component);
            component.set("v.isOpenItem", false);
            helper.revertCssChange(component);
            helper.callEvent(component);
        }
    },
    
    calculateItemSubtotal: function(component, event, helper) {
        var nou = component.find("nou").get("v.value");
        var cpu = component.find("cpu").get("v.value");
        if(nou && cpu){
            var subtotal = nou * cpu;
            component.find("subtotal").set("v.value", Math.abs(subtotal));
        }
    },
    
    editItem: function(component, event, helper) {
        component.set("v.isOpenItem", true);
        helper.applyCSS(component);
        helper.callEvent(component);
        helper.getItemFields(component);
        var target = event.getSource();  
        var index = target.get("v.value");
        
        var settlementItemList = component.get("v.settlementItemList"); 
        
        component.find("itemOptions").set("v.value",settlementItemList[index].item);
        component.find("otheritem").set("v.value",settlementItemList[index].otherItem);
        component.find("description").set("v.value",settlementItemList[index].description);
        component.find("nou").set("v.value",settlementItemList[index].nou);
        component.find("cpu").set("v.value",settlementItemList[index].cpu);
        component.find("subtotal").set("v.value",settlementItemList[index].subtotal);
        
        component.find("addItem").set("v.labelClass",settlementItemList[index].index);
        
        helper.getTotalItem(component);
    },
    
    removeItem: function(component, event, helper) {
        var target = event.getSource();  
        var index = target.get("v.value");
        
        var settlementItemList = component.get("v.settlementItemList"); 
        settlementItemList.splice(index, 1);
        
        for (var idx = 0; idx < settlementItemList.length; idx++) {
            settlementItemList[idx].index = idx;
        }
        component.set("v.settlementItemList", settlementItemList);
        
        helper.getTotalItem(component);
    },
    
    addLiquidation: function(component, event, helper) {
        var isValid = true;
        
        var distributor = component.get("v.selectDI");
        var distributorId = '';
        var distributorName = '';
        
        if(distributor){
            distributorId = component.get("v.selectDI").val;
            distributorName = component.get("v.selectDI").text;
        }
        
        var retailer = component.get("v.selectR1");
        var retailerId = '';
        var retailerName = '';
        
        if(retailer){
            retailerId = component.get("v.selectR1").val;
            retailerName = component.get("v.selectR1").text;
        }
        
        var productGroup = component.get("v.selectPG2");
        var productGroupId = '';
        var productGroupName = '';
        
        if(productGroup){
            productGroupId = component.get("v.selectPG2").val;
            productGroupName = component.get("v.selectPG2").text;
        }
        
        //var stock = component.find("stock").get("v.value");
        var qty = component.find("qty").get("v.value");
        var price = component.find("price").get("v.value");
        //var subtotal = component.find("subtotal2").get("v.value");
        
        var balQty = component.find("balQty").get("v.value");
        var newPOQty = component.find("newPOQty").get("v.value");
        var newDistPrice = component.find("newDistPrice").get("v.value");
        //var subtotalR1 = component.find("subtotalR1").get("v.value");
        
        var settlementLiquidationList = component.get("v.settlementLiquidationList");
        
        var target = event.getSource(); 
        //Deeksha:Added for INCTASK0290227 Start
        var index ;
        if(target.get("v.labelClass") === ''){
            index = settlementLiquidationList.length;
        }else{
            index = target.get("v.labelClass");
        }
        //Deeksha:Added for INCTASK0290227 End
        
        if(!distributorName && !retailerName){
            isValid = false;
            helper.showErrorToast(component, 'Please select either Distributor or R1');
        }
        
        if(!productGroupName){
            isValid = false;
            helper.showErrorToast(component, 'Product is required');                   
        }
        
        /*if(!stock){
            isValid = false;
            component.find("stock").set("v.errors",[{message: 'Complete this field'}]);                    
        }
        else{
            component.find("stock").set("v.errors",null);    
        }*/
        
        if(!qty){
            isValid = false;
            component.find("qty").set("v.errors",[{message: 'Complete this field'}]);                    
        }
        else{
            component.find("qty").set("v.errors",null);    
        }
        
        if(!price){
            isValid = false;
            component.find("price").set("v.errors",[{message: 'Complete this field'}]);                    
        }
        else{
            component.find("price").set("v.errors",null);    
        }
        
        if(!balQty){
            isValid = false;
            component.find("balQty").set("v.errors",[{message: 'Complete this field'}]);                    
        }
        else{
            component.find("balQty").set("v.errors",null);    
        }
        
        if(!newPOQty){
            isValid = false;
            component.find("newPOQty").set("v.errors",[{message: 'Complete this field'}]);                    
        }
        else{
            component.find("newPOQty").set("v.errors",null);    
        }
        
        if(!newDistPrice){
            isValid = false;
            component.find("newDistPrice").set("v.errors",[{message: 'Complete this field'}]);                    
        }
        else{
            component.find("newDistPrice").set("v.errors",null);    
        }
        
        if(isValid){
            if(settlementLiquidationList[index]){
                settlementLiquidationList[index].distributorId = distributorId; 
                settlementLiquidationList[index].distributorName = distributorName; 
                settlementLiquidationList[index].retailerId = retailerId;
                settlementLiquidationList[index].retailerName = retailerName; 
                settlementLiquidationList[index].productGroupId = productGroupId; 
                settlementLiquidationList[index].productGroupName = productGroupName; 
                //settlementLiquidationList[index].stock = stock;
                settlementLiquidationList[index].qty = qty;
                settlementLiquidationList[index].price = price;
                settlementLiquidationList[index].subtotal = Math.abs(qty*price); //subtotal;
                
                settlementLiquidationList[index].balQty = balQty;
                settlementLiquidationList[index].newPOQty = newPOQty;
                settlementLiquidationList[index].newDistPrice = newDistPrice;
                settlementLiquidationList[index].subtotalR1 = Math.abs(newPOQty*newDistPrice);                
            }
            else{
                index = settlementLiquidationList.length;
                settlementLiquidationList.push({
                    distributorId: distributorId, 
                    distributorName: distributorName, 
                    retailerId: retailerId, 
                    retailerName: retailerName, 
                    productGroupId: productGroupId, 
                    productGroupName: productGroupName, 
                    //stock: stock,
                    qty: qty,
                    price: price,
                    subtotal: Math.abs(qty*price),
                    
                    balQty: balQty,
                    newPOQty: newPOQty,
                    newDistPrice: newDistPrice,
                    subtotalR1: Math.abs(newPOQty*newDistPrice),    
                    
                    index : index
                });
            }
            
            component.set("v.selectDI", null);
            component.set("v.selectR1", null);
            component.set("v.selectPG2", null);
            //component.find("stock").set("v.value",'');
            component.find("qty").set("v.value",'');
            component.find("price").set("v.value",'');
            //component.find("subtotal2").set("v.value",'');
            
            component.find("balQty").set("v.value",'');
            component.find("newPOQty").set("v.value",'');
            component.find("newDistPrice").set("v.value",'');
            //component.find("subtotalR1").set("v.value",'')   
            
            component.find("addLiquidation").set("v.labelClass",'');
            component.set("v.settlementLiquidationList",settlementLiquidationList);
            
            helper.getTotalLiquidation(component);
            helper.getTotalR1(component);
            component.set("v.isOpenLiquidation", false);
            helper.revertCssChange(component);
            helper.callEvent(component);
        }
    },
    
    calculateLiquidationSubtotal: function(component, event, helper) {
        var qty = component.find("qty").get("v.value");
        var price = component.find("price").get("v.value");
        if(qty && price){
            var subtotal = qty * price;
            component.find("subtotal2").set("v.value", Math.abs(subtotal));
        }
    },
    
    editLiquidation: function(component, event, helper) {
        component.set("v.isOpenLiquidation", true);
        helper.applyCSS(component);
        helper.callEvent(component);
        var target = event.getSource();  
        var index = target.get("v.value");
        
        var settlementLiquidationList  = component.get("v.settlementLiquidationList"); 
        
        var distributor = {val: settlementLiquidationList[index].distributorId, text: settlementLiquidationList[index].distributorName, object:"Account"};
        component.set("v.selectDI", distributor);
        
        var retailer = {val: settlementLiquidationList[index].retailerId, text: settlementLiquidationList[index].retailerName, object:"Account"};
        component.set("v.selectR1", retailer);
        
        var productGroup = {val: settlementLiquidationList[index].productGroupId, text: settlementLiquidationList[index].productGroupName, object:"Product2"};
        component.set("v.selectPG2", productGroup);
        
        //component.find("stock").set("v.value",settlementLiquidationList[index].stock);
        component.find("qty").set("v.value",settlementLiquidationList[index].qty);
        component.find("price").set("v.value",settlementLiquidationList[index].price);
        //component.find("subtotal2").set("v.value",settlementLiquidationList[index].subtotal);
        
        component.find("balQty").set("v.value",settlementLiquidationList[index].balQty);
        component.find("newPOQty").set("v.value",settlementLiquidationList[index].newPOQty);
        component.find("newDistPrice").set("v.value",settlementLiquidationList[index].newDistPrice);
        //component.find("subtotalR1").set("v.value",settlementLiquidationList[index].subtotalR1);
        
        component.find("addLiquidation").set("v.labelClass",settlementLiquidationList[index].index);
        
        helper.getTotalLiquidation(component);
        helper.getTotalR1(component);
    },
    
    removeLiquidation: function(component, event, helper) {
        var target = event.getSource();  
        var index = target.get("v.value");
        var settlementLiquidationList = component.get("v.settlementLiquidationList"); 
        settlementLiquidationList.splice(index, 1);
        for (var idx = 0; idx < settlementLiquidationList.length; idx++) {
            settlementLiquidationList[idx].index = idx;
        }
        component.set("v.settlementLiquidationList", settlementLiquidationList);
        
        helper.getTotalLiquidation(component);
        helper.getTotalR1(component);
    },
    
    getRecordData : function(component, event, helper) {
        var params = event.getParam('arguments');
        if (params) {
            console.log('params: '+params.param1);
            var recordId = params.param1;
            var isDisabled = component.set("v.isDisabled", params.param2);
            
            var action = component.get("c.getRecord");
            action.setParams({
                recordId: recordId
            });
            action.setCallback(this, function(a) {
                
                // on call back make it false ,spinner stops after data is retrieved
                component.set("v.showSpinner", false); 
                
                var state = a.getState();
                console.log('state: '+JSON.stringify(state));   
                if (state == "SUCCESS") {
                    var returnValue = a.getReturnValue();
                    //console.log('returnValue: '+JSON.stringify(returnValue));   
             		
                    component.set("v.apObj", returnValue.apObj);
                    //component.set("v.allocationList", returnValue.allocationList);
                    component.set("v.itemList", returnValue.itemList);
                    component.set("v.settlementItemList", returnValue.settlementItemList);
                    component.set("v.liquidationList", returnValue.liquidationList);
                    component.set("v.settlementLiquidationList", returnValue.settlementLiquidationList);
                    
                    //component.set("v.totalAllocation", returnValue.apObj.Activity_percentage__c);
                    component.set("v.totalItem", returnValue.apObj.Marketing_Requisition__r.Activity_Cost__c);
                    component.set("v.totalLiquidation", returnValue.apObj.Marketing_Requisition__r.Liquidation_Cost__c);
                    
                    component.set("v.totalSettlementItem", returnValue.apObj.Activity_Cost__c);
                    component.set("v.totalSettlementLiquidation", returnValue.apObj.Liquidation_Cost__c);
                    component.set("v.totalR1StockAfterActivity", returnValue.apObj.R1Cost__c);
                    
                    //var crop = {val: returnValue.apObj.Crop__c, text: returnValue.apObj.Crop__r.Name, object:"Crop__c"};
                    //component.set("v.selectCR", crop);
                }
            });
            $A.enqueueAction(action);
        }
    },
        
    handleItemChange: function(component, event, helper) {
        // handle value change
        //console.log("old value (Order Type): " + JSON.stringify(event.getParam("oldValue")));
        //console.log("current value (Order Type): " + JSON.stringify(event.getParam("value")));
        
        //var target = event.getSource();  
        var value = event.getParam("value"); //target.get("v.value");
        var otheritem = component.find('otheritem');
        
        if(value=='LAIN-LAIN'){
            otheritem.set("v.disabled", false);
        }
        else{
            otheritem.set("v.disabled", true);
        }
    },
    
    saveFormData : function(component, event, helper) {
        helper.validateForm(component);
        
        var isValid = component.get("v.isValid");
        
        if(isValid){
            // show spinner to true on click of a button / onload
            component.set("v.showSpinner", true);
            
            var action = component.get("c.saveRecord");
            var apObj = component.get("v.apObj");
            var settlementItemString = component.get("v.settlementItemList");
            var settlementLiquidationString = component.get("v.settlementLiquidationList");
            
            console.log('apObj: '+JSON.stringify(apObj));
            console.log('settlementItemString: '+JSON.stringify(settlementItemString));
            console.log('settlementLiquidationString: '+JSON.stringify(settlementLiquidationString));
            
            action.setParams({
                apObj: apObj,
                settlementItemString: JSON.stringify(settlementItemString),
                settlementLiquidationString: JSON.stringify(settlementLiquidationString)
            });
            
            action.setCallback(this, function(a) {
                
                // on call back make it false ,spinner stops after data is retrieved
                component.set("v.showSpinner", false); 
                
                var state = a.getState();
                console.log('state: '+JSON.stringify(state));  
                
                if (state == "SUCCESS") {
                    var returnValue = a.getReturnValue();
                    //console.log('returnValue: '+JSON.stringify(returnValue)); 

                    // Get the component event by using the
                    // name value from aura:registerEvent
                    var stlEvent = component.getEvent("stlEvent");
                    stlEvent.setParams({
                        "message" : "" });
                    stlEvent.fire();
                    
                    helper.showToast(component, 'Record saved Successfully.');
                }
                else{
                    helper.showErrorToast(component, 'Some error has occurred. Please contact System Administrator.');
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    // Restrict Negative Discount Values
    restrictNegativeValue: function(component, event, helper){
        var target = event.getSource();  
        var value = target.get("v.value");
        
        //Logic to restrict negative value
        if(!value){
            value = 0;
        }
        else{
            var valueString = value.toString(); //Convert to string
            value = parseFloat(valueString.replace("-", "")); //Replace negative sign
        }
        
        target.set("v.value", value);
        //End of logic
    },
    
    checkValidPercent: function(component, event, helper){
        var target = event.getSource();  
        var value = target.get("v.value");
        if(value > 100){
            value = null;
            target.set("v.errors",[{message: 'Allocation Percentage should not be greater than 100%'}]);     
        }
        else{
			target.set("v.errors",null); 
        }
        target.set("v.value", value);
    },

})