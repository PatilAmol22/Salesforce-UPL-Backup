({
    
    init: function(component, event, helper) {       
        component.set("v.ready", true);
        var action = component.get("c.getStateData");
        action.setCallback(this,function(response){
            if (action.getState() === "SUCCESS"){
                var data = response.getReturnValue();
                if(data.isAdmin){
                    component.set('v.isAdmin', data.isAdmin);
                }else{
                    component.set('v.isAdmin', data.isAdmin);
                }
            }else{
                component.set('v.isAdmin', false);
            }
        });
        $A.enqueueAction(action);
         console.log('Before Handler Call');
        helper.initHandlers(component,event,helper);
        console.log('After Handler Call');
    },
    onTyping: function(component,event,helper) {
        var fields = component.get("v.fields");
        var searchText = component.find("searchText").getElement();        
        var inputElement = component.find("searchText").getElement();
        component.set("v.selItem", inputElement.value);
        var searchTerm = inputElement.value;        
        searchText = searchText.value;
        if(searchText.length >= 3 ){
        }
    }
        
    
})