({ 
    scriptsLoaded : function(component, event, helper) {
        component.set('v.loaded', false);
        helper.scriptsBrazil(component, event);
    },
})