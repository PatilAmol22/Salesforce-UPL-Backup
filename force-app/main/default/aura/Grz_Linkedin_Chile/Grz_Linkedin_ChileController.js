({
    doInit : function(component, event, helper) {
        var url = (window.location.href).split('/s/')[0];
        if(windowUrl.includes('uplpartnerportalstd')){
            console.log('Standard linkedin');
            component.set('v.notStd', false);
        }
    }
})