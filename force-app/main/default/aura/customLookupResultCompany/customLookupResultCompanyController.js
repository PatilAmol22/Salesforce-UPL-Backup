({
    selectRecordCompany : function(component, event, helper) {
        var getSelectRecord = component.get("v.oRecordCompany");
        var compEvent = component.getEvent("oSelectedRecordEventCompany");
        compEvent.setParams({"recordByEvent" : getSelectRecord });
        compEvent.fire();
	}
})