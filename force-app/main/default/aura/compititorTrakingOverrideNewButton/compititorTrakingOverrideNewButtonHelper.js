({
    doInitHandler : function(component,event,helper){        
        var action = component.get('c.getUserInformation'); 
        action.setCallback(this, function(a){
            var state = a.getState(); 
            if(state == 'SUCCESS') {
                var  userInfo = a.getReturnValue();
                console.log('userInfo::',userInfo);
                if(userInfo){
                    component.set('v.userInfo',userInfo);
                }
            }else{
                console.log('error');
            }
        });
        $A.enqueueAction(action);
        
    },
})