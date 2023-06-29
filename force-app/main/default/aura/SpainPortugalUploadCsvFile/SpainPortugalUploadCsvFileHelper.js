({
	CSV2JSON: function (component,csv) {
    console.log('Incoming csv = ' + csv);
        
         var arr = []; 
        
        arr =  csv.split('\n');;
        //console.log('@@@ arr = '+arr);
        arr.pop();
        var jsonObj = [];
        var headers = arr[0].split(',');
        for(var i = 1; i < arr.length; i++) {
            var data = arr[i].split(',');
            var obj = {};
            for(var j = 0; j < data.length; j++) {
                obj[headers[j].trim()] = data[j].trim();
                //console.log('@@@ obj headers = ' + obj[headers[j].trim()]);
            }
            jsonObj.push(obj);
        }
        var json = JSON.stringify(jsonObj);
        //console.log('@@@ json = '+ json);
        return json;

        
    },
    
    updateSKU : function (component,selectAccountType,jsonstr){
        console.log('jsonstr : '+jsonstr);
        var action = component.get("c.updateCSVData");
        action.setParams({
            selectAccountType : selectAccountType,
            strfromCSV : jsonstr
        });
        
        //component.set("v.showSpinner", true); 
        action.setCallback(this, function(response) {
            component.set("v.showSpinner", false); 
            var state = response.getState();
            
            if (state === "SUCCESS") { 
                console.log('update SKU');
               // var spinner = component.find("mySpinner");
                //$A.util.toggleClass(spinner, "slds-hide");
                var message=$A.get("$Label.c.Updated_successfully");
                this.showSuccessToast(component,event,message);
            }
            else if (state === "ERROR") {
                //var spinner = component.find("mySpinner");
                //$A.util.toggleClass(spinner, "slds-hide");
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var message=errors[0].message;
                        this.showErrorToast(component,event,message);
                    }
                } else {
                    var message='Unknown';
                    this.showErrorToast(component,event,message);
                }
            }
        }); 
        
        $A.enqueueAction(action);    
        
    },
    showSuccessToast : function(component, event,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : $A.get("$Label.c.Success_Message"),
            message: message,
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    showErrorToast : function(component, event, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : $A.get("$Label.c.Error_Message"),
            message:message,
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    showWarningToast : function(component, event, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Warning',
            message: message,
            duration:' 5000',
            key: 'info_alt',
            type: 'warning',
            mode: 'sticky'
        });
        toastEvent.fire();
        
        
    },
})