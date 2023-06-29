({
    getFileHelper : function(component, event, helper) {
        console.log('inside helper');
        var action = component.get("c.getDocument");
        
        action.setCallback(this, function(res){
            component.set("v.doc", res.getReturnValue());
            
        })
        $A.enqueueAction(action);
    },
    
    fileUploadHelper : function(component, event, helper) {
        
        var fileInput = component.find("fileId").get("v.files");
        var file = fileInput[0];
        var action = component.get("c.passFile");
        var objFileReader = new FileReader();        
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result; 
            action.setParams({ File : objFileReader.result
                             }); 
            
            action.setCallback(self, function(actionResult) {
                
                component.set("v.ActiveSection", "F");
                
                var response = actionResult.getReturnValue(); 
                
                if(actionResult.getReturnValue()=='error'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "",
                        "message": $A.get("$Label.c.UploadException"),
                        "type":"error",
                        "mode":"sticky"
                    });
                    toastEvent.fire();   
                    
                }
                else if(response.includes('NoSuccess')){
                    var str='';
                    //console.log('str is '+str);
                    str =  $A.get("$Label.c.All_Record_Creation_Failure");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "",
                        "message": str,
                        "type":"error",
                        "mode":"sticky"
                    });
                    toastEvent.fire();  
                    //$A.get('e.force:refreshView').fire();
                }else if(response.includes('PartialSuccess')){
                    var str = response.substring(response.indexOf(':') + 1);
                    //console.log('str is '+str);
                    str =  $A.get("$Label.c.Partial_Records_Failure") + ' ' + str + ' ' + $A.get("$Label.c.Records_Inserted_Successfully_Secondary_Sales");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "",
                        "message": str,
                        "type":"warning",
                        "mode":"sticky"
                    });
                    toastEvent.fire();  
                    $A.get('e.force:refreshView').fire();
                }else{
                    if(response.includes('success')){
                        var str = response.substring(response.indexOf(':') + 1);
                        console.log('str is '+str);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "",
                            "message": $A.get("$Label.c.Records_Inserted_Successfully_Secondary_Sales"),
                            "type":"Success",
                            "mode":"sticky"
                        });
                        toastEvent.fire();
                        $A.get('e.force:refreshView').fire();
                        
                    }
                }
                
                
            });   
            $A.enqueueAction(action);   
        });
        objFileReader.readAsText(file);  
    }
})