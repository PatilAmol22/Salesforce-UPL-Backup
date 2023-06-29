({
    doInit : function(component, event, helper) {
        
        var recordId = component.get("v.recordId");
        console.log('recordId.... : '+ recordId);
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        console.log('userId.... : '+ userId);
        
        if(userId != '' || userId != null){
            component.set("v.loginUserId",userId);
            helper.loginUserDetails(component, event, helper);
        }
        
    },

    onButtonClick:function(component, event, helper) {
        var recordId = component.get("v.recordId");
        console.log('recordId.... : '+ recordId);
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        console.log('userId.... : '+ userId);
        
        if(userId != '' || userId != null){
            component.set("v.loginUserId",userId);
            helper.loginUserDetails(component, event, helper);
        }
    },

    onChangeSelect : function(component, event, helper) {
        var selectedItem = event.getSource().get("v.value");
       // alert(selectedItem);
        component.set("v.accountId",selectedItem);
    },

    redirectToOrder: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        //component.set("v.showSuccess", false);
        var accId = component.find("acc_id").get("v.value");
        var country = component.get("v.userCountry");
        //var acId = component.get("v.accountId");
        //console.log('redirectToOrder..--: '+ accId);
        
        if(accId == '' || accId == null){
            var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                 "title": $A.get("$Label.c.Error"),
                 "type": "Error",
                  "message": $A.get("$Label.c.Account_can_not_be_empty")
                });
                toastEvent.fire();
        }
        else{
            
            var url = '';
            component.set("v.accountId",accId);

            if(country == 'CAM'){
                url = '/apex/OrderCAM?acid='+accId;
            }
            else if(country == 'Indonesia'){
                url = '/apex/OrderIndonesia_clone?acid='+accId;
            }
            else if(country == 'Argentina'){
                url = '/apex/OrderArgentina?acid='+accId;
            }
            else if(country == 'Mexico'){
                url = '/apex/OrderMexico?acid='+accId;
            }
            else if(country == 'Australia'){
                url = '/apex/OrderAustralia?acid='+accId;
            }
            else if(country == 'Turkey'){
                url = '/apex/OrderTurkey?acid='+accId;
            }
            else if(country == 'India'){
               // url = '/apex/OrderIndia?acid='+accId;
                component.set("v.showSuccess", false);
                component.set("v.showIndSwal", true); 
            }
            else if(country == 'SWAL'){
                url = '/apex/OrderSWAL?acid='+accId;
            }
            else if(country == 'Colombia'){
                url = '/apex/OrderColombia?acid='+accId;
            }
            else if(country == 'Italy'){
                url = '/apex/SOItalyComp_VF?recordId='+accId;
            }
            else if(country == 'Spain'){
                var evt = $A.get("e.force:navigateToComponent");
                evt.setParams({
                    componentDef: "c:SpainPortugalSalesOrder",
                    componentAttributes: {
                        recordId: accId
                    }
                });
                evt.fire();
            }
            else if(country == 'Vietnam'){
                var evt = $A.get("e.force:navigateToComponent");
                evt.setParams({
                    componentDef: "c:VietnamSalesOrder",
                    componentAttributes: {
                        recordId: accId
                    }
                });
                evt.fire();
            }
            else if(country == 'Poland'){
                var evt = $A.get("e.force:navigateToComponent");
                evt.setParams({
                    componentDef: "c:Poland_Sales_Order",
                    componentAttributes: {
                        recordId: accId
                    }
                });
                evt.fire();
            }
            else if(country == 'Bolivia' || country == 'Paraguay'){
                var evt = $A.get("e.force:navigateToComponent");
                evt.setParams({
                    componentDef: "c:BoliviaParaguaySalesOrder",
                    componentAttributes: {
                        recordId: accId
                    }
                });
                evt.fire();
            }
            
            if(url != ''){
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                "url": url 
                });
                urlEvent.fire();
               
               // window.open(url);
            }
        }
        
        if(country != 'India'){
            $A.get("e.force:closeQuickAction").fire();    // to close a Global Quick Action Lightning Component popup..
        }    
    },

    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.showSuccess", false);
        $A.get("e.force:closeQuickAction").fire();
        //location.reload(true);
    },

    closeErrorModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.showError", false);
        $A.get("e.force:closeQuickAction").fire();
    },

    closeIndSwalModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.showIndSwal", false);
        $A.get("e.force:closeQuickAction").fire();
    },

    orderAF: function(component, event, helper) {
        component.set("v.showIndSwal", false);
        var acId = component.get("v.accountId");
        var url = '/apex/OrderIndia?acid='+acId;  
        var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                "url": url 
                });
                urlEvent.fire();
       
        $A.get("e.force:closeQuickAction").fire();
    },

    orderALS: function(component, event, helper) {
        component.set("v.showIndSwal", false);
        var acId = component.get("v.accountId");
        var url = '/apex/ALSOrderPage?acid='+acId;  
        var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                "url": url 
                });
                urlEvent.fire();
       
        $A.get("e.force:closeQuickAction").fire();
    },
})