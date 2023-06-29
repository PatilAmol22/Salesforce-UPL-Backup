({
    closeModal : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    
    showSpinnerMethod:function(component,event,helper){
        console.log('showSpinner :',event.getParam('showSpinner'));
        component.set('v.IsSpinner',event.getParam('showSpinner'));
        if(event.getParam('showSpinner')==false || event.getParam('showSpinner')=='false'){
            console.log('close action');
            $A.get("e.force:closeQuickAction").fire();
            helper.showToast(component,event);
        }
    },
    
    
})