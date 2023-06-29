({
    
    gotoRecord : function (component, recordId) {
        var navEvt = $A.get("e.force:navigateToSObject");
        
        if(navEvt){
            navEvt.setParams({
                "recordId": recordId
            });
            navEvt.fire();
        }
        else{
            sforce.one.navigateToSObject(recordId);
        }
    }
})