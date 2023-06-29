({
    doInit: function(component,event,helper) {
        helper.getUserDetails(component,event,helper);
        helper.getDocuments(component,event,helper);
    },
    
    handleComponentEvent : function(component, event, helper) {
        var valueFromChild = event.getParam("message");
        alert(valueFromChild)
        component.set("v.enteredValue", valueFromChild);
    },
    
    
    fileSelected : function(component, event, helper) { 
        var fileInput = component.find("fileId").get("v.files");
        var volume = component .find("volume").get("v.value");
        var isrequired= false;
        if(volume==null || volume== '')
        {
            console.log('i reached in 2');
            $A.util.removeClass(component.find("selectvolume"),"slds-hide");                 
            isrequired= true ;
        }
        else{
            $A.util.addClass(component.find("selectvolume"),"slds-hide");
        }
        
        if(fileInput== null || fileInput == '')
        {
            console.log('i reached in file ');
            $A.util.removeClass(component.find("selectfile"),"slds-hide");                 
            isrequired= true;
        }
        else{
            $A.util.addClass(component.find("selectfile"),"slds-hide");                           
        }
        if (isrequired)
        {
            return;
        }
        
        var file = fileInput[0];
        var action = component.get("c.passFile"); 
        var objFileReader = new FileReader();        
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result; 
            action.setParams({ file : objFileReader.result,
                              volume:volume
                             });
            action.setCallback(self, function(actionResult) {
                if(actionResult.getReturnValue()==null)
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
                console.log((actionResult.getReturnValue()));
                var response = actionResult.getReturnValue();
                
                if (response == 'Updation not allowed')
                {
                    $A.util.removeClass(component.find("intendSalesReperro"),"slds-hide");                 
                }
                if (response=='exception occured')
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "",
                        "message": $A.get("$Label.c.UploadException"),
                        "type":"error",
                        "mode":"sticky"
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                }
                
                
                if(actionResult.getReturnValue()=='email')
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "",
                        "message": 'Email Sent with Success and error details',
                        "type":"error",
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
                            "message": str+' '+$A.get("$Label.c.RecordSuccessful"),
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
        component.set("v.FileName",uploadFile.name);
        $A.util.removeClass(component.find("filename"),"slds-hide");
    },
    
        
    onChangePickValBU: function(component,event,helper){
        var BU = component.find("volume").get("v.value");
        if(BU == null || BU == '' )
        {
            $A.util.removeClass(component.find("volumeerror"),"slds-hide");
            isRequiredFieldError = true;
            
        }
    },
    updateBlockDate : function(component,event,helper)
    {
        var required= false;
        var e_patt = new RegExp("^[0-9]+$");
        var blockdate= component .find("bDate").get("v.value");
        var checkNumber= e_patt.test(blockdate);
        
        if(blockdate=='0' ||blockdate>31 || checkNumber== false)
        {
            $A.util.removeClass(component.find("selectDate"),"slds-hide");
            required= true;
        }else
        {
            $A.util.addClass(component.find("selectDate"),"slds-hide"); 
        }
        if(blockdate =='' ||blockdate== null|| blockdate== undefined )
        {
            $A.util.removeClass(component.find("selectValue"),"slds-hide");
            required= true; 
        }
        else
        {
            $A.util.addClass(component.find("selectValue"),"slds-hide"); 
        }
        if (required== true)
        {
            return;
        }
        
        var submitblockdate = component.get("c.submitDate");
        submitblockdate.setParams({
            bDate: blockdate
        });
        submitblockdate.setCallback(this, function(response) {
            var state = response.getState();
            // var callBackResponse =  response.getReturnValue();
            
            if (component.isValid() && state === "SUCCESS" ) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "",
                    "message": 'Date Successfully Updated',
                    "type":"Success",
                    "mode":"sticky"
                });
                toastEvent.fire();  
                
            }
            
            else
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "",
                    "message": 'Error while updating date',
                    "type":"error",
                    "mode":"sticky"
                });
                toastEvent.fire();   
                
                
            }
        });
        $A.enqueueAction(submitblockdate);
    },
    
    downloadCSV: function(component,event,helper){
        var downloadableElement = document.createElement('a');
        downloadableElement.href = component.get("v.doc");
        downloadableElement.target = '_self'; // make sure Users stay in the same window/tab
        downloadableElement.download = 'Stock In Channel UPL Inventory Upload Template.csv';  // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(downloadableElement); // Required for FireFox browser
        downloadableElement.click(); // using click() js function to download csv file
    }
    
})