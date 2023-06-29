({
    doInit : function(component, event, helper) {
        
        
     //  window.open("https://uplonline.service-now.com/sp?id=index", '_blank');
     

        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
        "url": 'https://uplonline.service-now.com/sp?id=sc_cat_item&sys_id=3f1dd0320a0a0b99000a53f7604a2ef9'
        });
        urlEvent.fire();

        $A.get("e.force:closeQuickAction").fire();    // to close a Global Quick Action Lightning Component popup..
        
        
    }

    
})