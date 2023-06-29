({
    /*doInit : function(component, event, helper) {
              var urlEvent = $A.get("e.force:navigateToURL"); 
        urlEvent.setParams({"url":"/apex/Case_AKC"}); 
        urlEvent.fire(); 
        
         window.location.href = 'http:///upl--uat.cs73.my.salesforce.com/apex/Case_AKC';
       }*/
    doInit: function (component, event, helper) {
        //Introduced the variable below to use the component in Argentina community, 
        //the override when done from Argentine Community will redcirect to the flow when
        //Argentina distributor record type is selected,GRZ(Gurubaksh Grewal) : APPS-1757 added on: 16-08-2022
        
        var articleURL = JSON.stringify(window.location.pathname);
        
        if(articleURL.includes('uplpartnerportalstd')){
            if(JSON.stringify(component.get("v.pageReference")) != 'null' ){
                var recordTypeId = component.get("v.pageReference").state.recordTypeId;
                if(recordTypeId===undefined)window.location.href = '/uplpartnerportalstd/s/createcase';
                if(recordTypeId==='01228000001HmiJAAS')window.location.href = '/uplpartnerportalstd/s/createcase';
                else{
                    helper.helperMethod(component, event,helper);
                }
            }
            
        }
        else        
            // Issue reported by IBM team - Prashant Chinchpure date 25th feb 2021 -Start
           helper.helperMethod(component, event,helper);
        // Issue reported by IBM team - Prashant Chinchpure date 25th feb 2021 -End
        
        
    },
    
    handlePageChange: function (component, event, helper) {
        console.log("pageReference attribute change");
        //component.find("colombiaCase").reloadRecord(true);
        // Issue reported by IBM team - Prashant Chinchpure date 25th feb 2021 -Start
        var country = '';
                var action = component.get("c.fetchUser");
        action.setCallback(this, function (a) {
            
            var response = a.getReturnValue();
            console.log('isColombiaUser>>--->' + response);
            console.log('isColombiaUser>>--->' + country);
            country = response.Country;
            if (country == 'Colombia' || country == 'COLOMBIA') {
                component.set("v.isColombiaCase", true);
                component.find('colombiaCase').getFiredFromAura();
            } else {
                helper.helperMethod(component, event, helper);
            }
            console.log('country===' + response.Country);
            
        });
        $A.enqueueAction(action);
        
        // Issue reported by IBM team - Prashant Chinchpure date 25th feb 2021- End
        
        
    },
    
    handleNurturePageClose: function (component, event, helper) {
        //$A.get('e.force:refreshView').fire();
        console.log('testing order.. in cancel method');
        console.log('testing order.. in cancel method' + component.get("v.accIdForNurture"));
        component.set("v.accIdForNurture", "");
        component.set("v.accIdForUPLConsumer", "");// <!--New Changes(start) - Ishu(for UPL Consumer)-->
       
        var workspaceAPI = component.find("workspace");
        var focusedTabId = component.get("v.focustab");
        workspaceAPI.closeTab({ tabId: focusedTabId });
        
        //window.location.reload();
       // $A.get("e.force:closeQuickAction").fire();
    },
    
    handleNurtureSave: function (component, event, helper) {
        var workspaceAPI = component.find("workspace");
        var focusedTabId = component.get("v.focustab");
        workspaceAPI.closeTab({ tabId: focusedTabId });
        
    }
    
    
    
    
    
})