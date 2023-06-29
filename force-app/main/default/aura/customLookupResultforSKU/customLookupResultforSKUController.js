({
    selectRecord : function(component, event, helper){      
        
        var getSelectRecord = component.get("v.oRecord");
        
        var compEvent = component.getEvent("oSelectedRecordEventSKU");
        
        compEvent.setParams({"recordByEvent" : getSelectRecord });  
        
        compEvent.fire();
    },
})