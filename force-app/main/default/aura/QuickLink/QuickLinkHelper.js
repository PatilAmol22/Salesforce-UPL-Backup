({
    gettingUrls : function(component,event,helper) {
        console.log('@@@@@@@ in helper Quick Link');
        
        var action = component.get('c.gettingDetailsCommConfig'); 
        console.log('@@@@@@@  in helper Quick Link 1');
        action.setCallback(this, function(a){
            console.log('first state ');
            var state = a.getState(); // get the response state
            console.log('state   '+state);
            var windowUrl= (window.location.href).split('/s/')[0];
            if(state == 'SUCCESS') {
                if(windowUrl.includes('uplpartnerportalstd')){
                    component.set('v.StdurlAddress', true);
            }
               // console.log('@@@@@@@  in Quick Link return Value '+a.getReturnValue());
                component.set('v.quickLinkList', a.getReturnValue());
                
            }
        });
        $A.enqueueAction(action);
        
        
    },
})