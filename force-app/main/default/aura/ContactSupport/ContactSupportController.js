({
    myAction : function(component, event, helper) {
        
    },
    handleSubjectChange : function(component, event, helper) {
        var subject = event.getParam("value");
        component.set("v.subject",subject);
        console.log(subject);
    },
    handleDescriptionChange : function(component, event, helper) {
        var Description = event.getParam("value");
        component.set("v.Description",Description);
        console.log(Description);
    },
    handleUploadFinished: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        console.log(uploadedFiles);
        alert("Files uploaded : " + uploadedFiles[0].name);
        var documentId=uploadedFiles[0].documentId;
        cmp.set("v.documentId",documentId);
        console.log('Id----'+uploadedFiles[0].documentId);
        
    },
 
    
    handleClick : function (cmp, event, helper) {
        
		var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": $A.get("$Label.c.successfully"),
            "message": $A.get("$Label.c.Email_Sent_Successfully"),
            "mode": "dismissible"
        });
        var action = cmp.get('c.sendMail');
        var docId=cmp.get("v.documentId");
        var subject=cmp.get("v.subject");
        var desc=cmp.get("v.Description");  
      
        action.setParams({
            "docid" : docId,
            "subject" : subject,
            "description" : desc
        });
        action.setCallback(this, function(a){
            var state = a.getState();
            console.log('state '+state);
            if(state == 'SUCCESS') {
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action); 
    }
})