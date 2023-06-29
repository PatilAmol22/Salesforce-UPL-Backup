({
    callingDownloadPDF : function(component, event, helper,recordIdOfQuote) {
        console.log('Id of Quote in Helper Method '+recordIdOfQuote);
        var action = component.get('c.downloadPdf'); 
        
        action.setParams({
            "recordIdOfQuote" : recordIdOfQuote
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                //component.set('v.sObjList', a.getReturnValue());
                var response = a.getReturnValue();
                if(response=='failure'){
                    // fire toast
                    this.showErrorToast();
                  
                    
                }else{
                    this.showSuccessToast();
                    component.set("v.isDownloaded", true);
                }
            }
        });
         
        $A.enqueueAction(action);
       
    },
    
    showErrorToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error Message',
            message:'Quote is not Approved yet.',
            messageTemplate: 'Mode is pester ,duration is 5sec and Message is overrriden',
            duration:' 4000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        
        toastEvent.fire();
    },
    
    
     showSuccessToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success Message',
            message: 'Quote is downloaded successfully.',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    
    reloadNow : function(component, event, helper) {
        //window.location.reload(); 
         setTimeout(function(){ window.location.reload(); }, 3000); 
         //alert('in reload now ');
    },
    
   
    
    
    
})