({
    getingMDODetails : function(component,event,helper,recId) {
        console.log('In helepr Method recId '+recId);
        
        var action = component.get('c.gettingMDODetail'); 
        
        
        action.setParams({
            "recoId" : recId
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            console.log('state mdo '+state);
            
            if(state == 'SUCCESS') {
                var isMDOReturn = a.getReturnValue();
                console.log('isMDOReturn '+isMDOReturn);
                if(!isMDOReturn){
                    component.set("v.isShowTrue",true);
                    component.set("v.ErrorMsg",'Can not send to SAP, MDO Number already generated. ');
                    
                }else{
                    // calling another function
                    this.callingOnBoardingServices(component,event,helper,recId);
                    component.set("v.isShowTrue",false);
                    component.set("v.ErrorMsg",'');
                    
                }
                
            }
        });
        $A.enqueueAction(action);
        
        
    },
    
    callingOnBoardingServices : function(component,event,helper,recId) {
        console.log('Calling callingOnBoardingServices '+recId);
        var action = component.get('c.callingOnboardingServices'); 
        
        
        action.setParams({
            "recoId" : recId
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                // component.set('v.sObjList', a.getReturnValue());
                console.log('Successfully called Services');
            }
            if(state == 'ERROR') {
                console.log('Error Occure while calling of Onborading Services');
                
            }
            
        });
        $A.enqueueAction(action);
        
        
    },
    
    
    
    
    
    
    
    gotoURL : function(component, recordId) {
        var device = $A.get("$Browser.formFactor");
        var recrdId = recordId;
        
        
        if(device=='DESKTOP'){
            try{
                sforce.one.navigateToSObject(recordId);
                
            }catch(err){
                console.log('catch');
                
                this.navigateToComponent(component,recrdId);
            }
        }
        else{
            sforce.one.navigateToSObject(recordId);
        }
    },
    
    //Called through "gotoURL" method
    navigateToComponent: function(component,recrdId){
        var navEvent = $A.get("e.force:navigateToSObject");
        if(navEvent!=undefined){
            
            navEvent.setParams({
                "recordId": recrdId
                //"slideDevName": related
            });
            navEvent.fire();    
            
        }
        else{
            window.history.back();
        }
    },
})