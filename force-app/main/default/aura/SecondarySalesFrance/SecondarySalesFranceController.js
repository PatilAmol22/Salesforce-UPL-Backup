({
    doInit: function(component,event,helper) {
        //helper.getUserDetails(component,event,helper);
        helper.getDocuments(component,event,helper);
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
        
        var file = fileInput[0];
        console.log(file);
        var action = component.get("c.passFileAura"); 
        var objFileReader = new FileReader();        
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result; 
            action.setParams({ file : objFileReader.result
                             });
            action.setCallback(self, function(actionResult) {
                console.log((actionResult.getReturnValue()));
                var response = actionResult.getReturnValue();
                console.log(response);
                if(actionResult.getReturnValue()=='error')
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "",
                        "message": $A.get("$Label.c.UploadException"),
                        "type":"error",
                        "mode":"sticky"
                    });
                    toastEvent.fire();   
                    
                }
                 else if(response.includes('NoSuccess'))
				{
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
				}		
                else if(response.includes('PartialSuccess'))
				{
					 var str = response.substring(response.indexOf(':') + 1);
					//console.log('str is '+str);
					str =  $A.get("$Label.c.Partial_Records_Failure") + ' ' + str + ' ' + $A.get("$Label.c.Records_Inserted_Successfully_Secondary_Sales");
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
                //diwansh
                 else if(response.includes('InBatch'))
				{
					 var str = response.substring(response.indexOf(':') + 1);
					//console.log('str is '+str);
					
					str =  $A.get("$Label.c.Partial_Records_Failure") + ' ' + str + ' ' + $A.get("$Label.c.Records_Inserted_Successfully_Secondary_Sales");
		            str=  $A.get("$Label.c.SSD_Submission");
                    var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						"title": "",
						"message": str,
						"type":"Success",
						"mode":"dismissible"
					});
					toastEvent.fire();  
					$A.get('e.force:refreshView').fire();
				}
                //ends
					
                else
                {
                    if(response.includes('success'))
                    {
                        
                    var str = response.substring(response.indexOf(':') + 1);
                    console.log('str is '+str);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "",
                            "message": str+' '+$A.get("$Label.c.Records_Inserted_Successfully_Secondary_Sales"),
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
    },
    
    onFileUploaded: function(component,event,helper)
    {  
        console.log('i reached here in file upload');
        var uploadFile = event.getSource().get("v.files")[0];
        console.log(uploadFile);
        component.set("v.FileName",uploadFile.name);
        $A.util.removeClass(component.find("filename"),"slds-hide");
    },
})