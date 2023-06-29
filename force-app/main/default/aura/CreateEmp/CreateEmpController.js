({
    doInit: function(component, event, helper) {
        
              
        
        helper.fetchPickListVal(component, 'CultivatedCrop__c', 'CultivatedValues');
        helper.fetchPickListVal(component, 'SeedTreatmentProduct__c', 'SeedTreatmentProductValues');
        
        var today = $A.localizationService.formatDate(new Date()+1, "YYYY-MM-DD");
        component.set("v.maxDate",today);
        
        //addded by Swapnil
        var myPageRef = component.get("v.pageReference");
        
        var AccountId = myPageRef.state.c__FarmerId;
        var AccountName = myPageRef.state.c__FarmerName;
        var AccountState = myPageRef.state.c__FarmerState;
        
        component.set('v.FarmerId', AccountId);
        component.set('v.FarmerName', AccountName);
        component.set('v.FarmerState', AccountState);
        console.log('AccountState AccountState + === '+ AccountState);
        
       
       //change label of new tab when clicked on New Empanelment     
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getAllTabInfo().then(function(response) {
            console.log(response);
		 workspaceAPI.getFocusedTabInfo().then(function(response) {
            //alert('focus tab');
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: AccountName
            });
            workspaceAPI.setTabIcon({
                tabId: focusedTabId,
                icon: "utility:user",
                iconAlt: "User"
            });
        })            
       })
        .catch(function(error) {
            console.log(error);
        });
        
        
        
        //end
        
        // Prepare a new record from template
        component.find("empanelmentRecordCreator").getNewRecord(
            // sObject type 
            "Empanelment__c",
            // recordTypeId
            null,
            // skip cache?
            false,  
            $A.getCallback(function() {
                var rec = component.get("v.newEmpanelment");
                var error = component.get("v.newEmpanelmentError");
                
                if(error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                    return;
                }
                console.log("Record template initialized: " + rec.sobjectType);
            })
        );
    },
    
    handleCultivatedValues : function(component, event, helper) {
        var selectedOptionsList = event.getParam("value");
        var targetName = event.getSource().get("v.name");
        if(targetName == 'cultivated crop'){ 
            component.set("v.simpleNewEmpanelment.CultivatedCrop__c" , selectedOptionsList);
        }
    },
    
    handleSeedTreatmentProductValues : function(component, event, helper) {
        var selectedOptionsList = event.getParam("value");
        var targetName = event.getSource().get("v.name");
        if(targetName == 'seed treatment product'){ 
            component.set("v.simpleNewEmpanelment.SeedTreatmentProduct__c" , selectedOptionsList);
        }
        if(selectedOptionsList === 'Non UPL Product'){
            
            component.set("v.reqTrue", true);
            component.set("v.disableAtr",false);
        }else if(selectedOptionsList !== 'Non UPL Product'){
            component.set("v.reqTrue", false);
            component.set("v.disableAtr",true);
            component.find("nonUplProduct").set("v.value","");
        }
    },
    
    handleSaveEmpanelment: function(component, event, helper) {
        helper.handleSaveEmpanelementHelper(component, event, helper);
        component.set("v.saveorsaveandrecommend",true);
    },
    
    handleSaveEmpanelmentandRecommend: function(component, event, helper) {
        helper.handleSaveEmpanelementHelper(component, event, helper);
    },
    
    handleCancel : function(component, event, helper){
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.FarmerId"),
            "slideDevName": "detail"
        });
        navEvt.fire();
    },
    
})