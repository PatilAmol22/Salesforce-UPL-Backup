({
    fetchData: function (cmp,event,helper,recordId) {
         cmp.set("v.showSpinner", true); 
        var action = cmp.get("c.getAllOrderItem");
        action.setParams({ 
                    "soId": recordId
                });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                 cmp.set("v.showSpinner", false); 
                var data = response.getReturnValue();
                /*for(var d in data){
                    if(d.Cancellation_Reason__c==undefined||d.Cancellation_Reason__c==null){
                        d.Cancellation_Reason__c='';
                    }
                }*/
                console.log('data*******',data);
                cmp.set('v.data',data);
                 cmp.set('v.data1',data);
                 cmp.set('v.data2',data);
                

            }
            console.log('data*******',data);
        });
        $A.enqueueAction(action);
    },
    
     ClearLineItemField: function (cmp,event,helper,recordId) {
        var action = cmp.get("c.ClearLineItemFields");
        action.setParams({ 
                    "soId": recordId
                });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('ClearLineItemFields Success');

            }
        });
        $A.enqueueAction(action);
    },
    
    
   /* fetchData1: function (cmp,event,helper,recordId) {
        var action = cmp.get("c.getAllOrderItem1");
        action.setParams({ 
                    "soId": recordId
                });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data1 = response.getReturnValue();
                console.log('Brand Data'+JSON.stringify(data1));
                cmp.set('v.data1',data1);
                
            }
        });
        $A.enqueueAction(action);
    },*/
    inventory : function(cmp,event,helper){
        var action = cmp.get("c.getInventory");
        action.setCallback(this, function(a) {
            var state = a.getState();
            console.log('state',state);
            if(state == "SUCCESS") {
              var newSalesOrder1= cmp.get("v.inventory"); 
                cmp.set("v.inventory", a.getReturnValue());
                console.log('inventory*************'+JSON.stringify(cmp.get("v.inventory"))); 
            }
            else{
                                            console.log(a.getError());
                                        }
        });
        $A.enqueueAction(action);
     },
     minMaxDate : function(cmp,event,helper,recordId){
        var action = cmp.get("c.getMinMaxDate");
         action.setParams({
             "soId": recordId
         });
        action.setCallback(this, function(a) {
            var state = a.getState();
            console.log('state************',state);
            if(state == "SUCCESS") {
              var minMaxDate= cmp.get("v.minMaxDate"); 
                cmp.set("v.minMaxDate", a.getReturnValue());
                console.log('minMaxDate'+JSON.stringify(cmp.get("v.minMaxDate"))); 
            }
            else{
                                            console.log(a.getError());
                                        }
        });
        $A.enqueueAction(action);
     },
    
   
    //Method for cancelReason by Harshit&Sirisha
    getCancelReasonPicklist : function(component, event) {
        var action = component.get("c.cancelReason");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result is ',result);
                var cancelMap = [];
                cancelMap.push({key: '', value:'--Nenhum--'});
                for(var key in result){
                    cancelMap.push({key: key, value: result[key]});
                }
               console.log('result is 123',JSON.stringify(cancelMap));
                component.set("v.cancelMap", cancelMap);
            }
        });
        $A.enqueueAction(action);
    },
   showToast : function(component, helper, message) {
       console.log('message is ',message);
    var toastEvent = $A.get("e.force:showToast");
               if (toastEvent!=undefined){

    toastEvent.setParams({
        "title": "Sucesso!",
        "message": message
        
    });
    toastEvent.fire();
               }else{
                   alert(message);
               }
      
   },

     })