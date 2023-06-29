({
    scriptsLoaded: function (component, event, helper) {
        component.set("v.loaded", false);
        helper.scriptsBrazil(component, event);
    },
    handleDistributor: function (component, event, helper) {
        component.set("v.distributorValuep", event.getParam("value"));
        component.set("v.subGroupValue", "");//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
    },
    //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
    handleSubGroup: function (component, event, helper) {
        component.set("v.subGroupValue", event.getParam("value"));
        component.set("v.distributorValuep", "All");
    },
});