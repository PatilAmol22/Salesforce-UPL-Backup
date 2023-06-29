({
    AddNewRow : function(component, event, helper){
        component.getEvent("KAMDataEntryDynamicRowAdd").fire();     
    },
    removeRow : function(component, event, helper){
        if(component.get("v.totalItems") == 1){
            component.set("v.payoutWrapper.Tier",1);
            component.set("v.payoutWrapper.threshold",0);
            component.set("v.payoutWrapper.quantity",0.00);
            component.set("v.payoutWrapper.payout",0.00);
            component.set("v.payoutWrapper.payoutPct",0.00);
            component.set("v.payoutWrapper.del",false);
            component.getEvent("KAMDataEntryDynamicRowRemove").setParams({
                "indexVar" : component.get("v.rowIndex") 
            }).fire();
        }else{
            component.getEvent("KAMDataEntryDynamicRowRemove").setParams({
                "indexVar" : component.get("v.rowIndex") 
            }).fire();
        }
    }, 
    CalcPct:function(component, event, helper) {
        var quant = ((component.get("v.payoutWrapper.threshold")/component.get('v.draftQty'))*100).toFixed(2);
        component.set("v.payoutWrapper.quantity",quant );  
    },
    handlePayout:function(component, event, helper) {
        var payoutPct = ((component.get("v.payoutWrapper.payout")/component.get('v.productPrice'))*100).toFixed(2);
        component.set("v.payoutWrapper.payoutPct",payoutPct);  
    },
    handlePayoutPct:function(component, event, helper) {
        var payout = ((component.get("v.payoutWrapper.payoutPct")/100)*component.get('v.productPrice')).toFixed(2);
        component.set("v.payoutWrapper.payout",payout);  
    },
    AddWrapper:function(component, event, helper) {
        if(component.get("v.totalItems") == 1 && component.get("v.payoutWrapper.del") == true){
            component.set("v.payoutWrapper.del",false);
            component.set("v.payoutWrapper.payoutId",null);
        }
        if(component.get("v.payoutWrapper.payout") != 0 && component.get("v.payoutWrapper.threshold") != 0 ){
            component.getEvent("KAMDataEntryDynamicRowPayout").setParams({
                "indexVar" : component.get("v.rowIndex"),
                "payWrapper" :component.get("v.payoutWrapper")
            }).fire();
        }
    } 
})