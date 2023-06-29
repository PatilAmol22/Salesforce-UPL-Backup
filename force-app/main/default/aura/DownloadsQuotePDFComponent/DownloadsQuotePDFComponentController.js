({
    doInit : function(component, event, helper) {
        console.log('download pdf while status is Approved');
        var recordIdOfQuote = component.get("v.recordId")
        helper.callingDownloadPDF(component, event, helper,recordIdOfQuote);
        helper.reloadNow(component, event, helper);
        var isDown = component.get("v.isDownloaded");
        if(isDown == true){
            helper.reloadNow(component, event, helper);
        }
        
    }
})