({
    doInit: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.get("v.defaultPageSize");//component.find("pageSize").get("v.value"); 
        console.log('doInit...');
        var today = new Date();
        component.find("end_date").set("v.value",$A.localizationService.formatDate(today, "yyyy-MM-dd"));
        component.find("strt_date").set("v.value",$A.localizationService.formatDate(today.setDate(today.getDate()-30), "yyyy-MM-dd")); 
        helper.getOrderList(component, pageNumber, pageSize);
    },
     
    handleNext: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber++;
        
        helper.getOrderList(component, pageNumber, pageSize);
    },
     
    handlePrev: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber--;
       
        helper.getOrderList(component, pageNumber, pageSize);
    },
     
    onSelectChange: function(component, event, helper) {
        var page = component.get("v.PageNumber"); //1;
        var pageSize = component.find("pageSize").get("v.value");
        
        helper.getOrderList(component, page, pageSize);
    },

    searchOrders: function(component, event, helper) {
        var page = component.get("v.PageNumber"); //1;
        var pageSize = component.find("pageSize").get("v.value");
        
        helper.getOrderList(component, page, pageSize);
    },

    resetData: function(component, event, helper) {
        component.find("skuId").makeReset(false); // to reset sku search pill
        component.find("strt_date").set("v.value","");
        component.find("end_date").set("v.value","");
        var action4 = component.get('c.doInit');
        $A.enqueueAction(action4);  
    }, 

    downloadCSV: function(component, event, helper) {
        var orderList = component.get("v.orderList");

        //if(orderList.length>0){
            helper.convertDataToCSV(component, event, helper); 
       // }
        /* else{
            var errMsg = $A.get("{!$Label.c.Shipment_Date_Can_Not_Be_Less_Than_Today}");
            var toastEvent1 = $A.get("e.force:showToast");
              var titl  = $A.get("{!$Label.c.Warning}");
              toastEvent1.setParams({
                  "title": titl,
                  "type": "Warning",
                  "message": errMsg
                  //"duration":'3000'
              });
              toastEvent1.fire();
        } */
    },
})