({
	doInit : function(component, event, helper) {
		 var type = $A.get('$Label.c.Data_Upload_Type');
        type = type.split(",");
        component.set('v.UploadType', type);
        helper.getDocuments(component,event,helper);
        //helper.getDocuments1(component,event,helper);
	},
    onFileUploaded: function(component,event,helper)
    {  
        var uploadFile = event.getSource().get("v.files")[0];
        console.log(uploadFile);
        component.set("v.FileName",uploadFile.name);
        $A.util.removeClass(component.find("filename"),"slds-hide");
    },
    fileSelected : function(component, event, helper) { 
        var fileInput = component.find("fileId").get("v.files");
        var isrequired= false;
        
        if(fileInput== null || fileInput == '')
        {
            console.log('i reached in file ');
            $A.util.removeClass(component.find("selectfile"),"slds-hide");                 
            isrequired= true;
        }
        else
        {
            $A.util.addClass(component.find("selectfile"),"slds-hide");                           
        }
        if (isrequired)
        {
            return;
        }
       if(component.find("uploadselect").get('v.value')== 'Select'){
            return;
        }
        var type = component.find('uploadselect').get('v.value');
        var file = fileInput[0];
        console.log(file);
        var action = component.get("c.passFileAura"); 
        var objFileReader = new FileReader();        
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result; 
            action.setParams({ file : objFileReader.result,
                              ftype : component.find('uploadselect').get('v.value')
                             });
            action.setCallback(self, function(actionResult) {
                console.log((actionResult.getReturnValue()));
                var result=actionResult.getReturnValue();
                var response = result;
                
                if(response.includes('NoSuccess'))
                {
                    var str='';
                    //console.log('str is '+str);
                    str =  'Some of the records could not be uploaded. Please check mail for error details.';
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "",
                        "message": str,
                        "type":"error",
                        "mode":"sticky"
                    });
                    toastEvent.fire();  
                    //$A.get('e.force:refreshView').fire();
                }		
                else
                {
                    if(response.includes('success'))
                    {
                        var str = response;
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
                    else{
                        
                        if(response.includes('Exception'))
                        {
                            var str = response;
                            console.log('str is '+str);
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "",
                                "message": str,
                                "type":"error",
                                "mode":"sticky"
                            });
                            toastEvent.fire();
                            $A.get('e.force:refreshView').fire();
                            
                        }
                    }
                    
                }
                
            });
            $A.enqueueAction(action);            
        });
        objFileReader.readAsText(file);
    },
    onSelectchange : function(component, event, helper) {
		console.log('in init');
	}
})