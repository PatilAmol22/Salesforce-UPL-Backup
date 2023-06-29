({
	getFileHelper : function(component, event, helper, ValueSelected) {
		var action = component.get("c.getDocument");
        action.setParams({ FileName : ValueSelected });
        action.setCallback(this, function(res){
            component.set("v.doc", res.getReturnValue());
     
        })
        $A.enqueueAction(action);
	},
    
    fileUploadHelper : function(component, event, helper, ValueSelected) {
        
        var fileInput = component.find("fileId").get("v.files");
        var file = fileInput[0];
        var action = component.get("c.passFile");
        var objFileReader = new FileReader();        
    	objFileReader.onload = $A.getCallback(function() {
         var fileContents = objFileReader.result; 
         action.setParams({ File : objFileReader.result,
                            Type : ValueSelected
                             }); 
            
         action.setCallback(self, function(actionResult) {
          var response = actionResult.getReturnValue(); 
           console.log('response'+response);  
           if(actionResult.getReturnValue()=='error' || actionResult.getReturnValue() == null)// add null check here to check return value added by GRZ(Javed Ahmed) RITM0419822 modified date-07-09-2022
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
						"type":"warning",
						"mode":"sticky"
					});
					toastEvent.fire();  
					$A.get('e.force:refreshView').fire();
				}		
					
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
    }
})