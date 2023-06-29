({
    
    init: function(component, event, helper) {       
        console.log("Inside Init");
        component.set("v.ready", true);
        //helper.initHandlers(component);
        var action = component.get("c.getStateData");
        action.setCallback(this,function(response){
            console.log('==>',response.getState());
            console.log('==>',response.getReturnValue());
            if (action.getState() === "SUCCESS"){
                var data = response.getReturnValue();
                console.log('Data-->',data);
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
        helper.initHandlers(component,event,helper);
    },
    
    onTyping: function(component,event,helper) {
        var fields = component.get("v.fields");
        var searchText = component.find("searchText").getElement();        
        var inputElement = component.find("searchText").getElement();
        component.set("v.selItem", inputElement.value);
        var searchTerm = inputElement.value;        
        //console.log('fields :- '+fields);
        searchText = searchText.value;
        if(searchText.length >= 3 ){
        //helper.initHandlers(component,event,helper);
        }
    }
        
    
})