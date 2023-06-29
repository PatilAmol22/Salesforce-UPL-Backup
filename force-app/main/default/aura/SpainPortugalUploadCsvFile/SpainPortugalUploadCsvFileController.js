({
    doInit : function(cmp) {
    	// Initialize input select options
        var opts = [
            { "class": "optionClass", label: $A.get("$Label.c.None"), value: "None", selected: "true", selected: "true" },
            { "class": "optionClass", label: $A.get("$Label.c.Prospect_Creation"), value: "Insert Prospect Account" },
            { "class": "optionClass", label: $A.get("$Label.c.Update_Customer_Segmentation"), value: "Update Customer Segmentation" },
            { "class": "optionClass", label: $A.get("$Label.c.Farmer_Creation"), value: "Insert Farmer Account" }

        ];
        cmp.find("InputSelectDynamic").set("v.options", opts);
        
    },
    onChange: function(cmp) {
		 var dynamicCmp = cmp.find("InputSelectDynamic");
		 cmp.set('v.AccounType',dynamicCmp.get("v.value"));
	 },
    
	uploadCSV : function(component,event,helper){
        var fileBody, fileSize, csvLength, fileName;  
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        //var spinner = component.find("mySpinner");
        //$A.util.toggleClass(spinner, "slds-show");
        if(file === undefined){
            var message=$A.get("$Label.c.Warning");
            helper.showWarningToast(component,event,message);
        }else {
            var selectAccountType = component.find("InputSelectDynamic").get("v.value");
            console.log('selectAccountType : '+selectAccountType);
            var _validFileExtensions = [".csv"];    
            var reader = new FileReader();
            fileName = fileInput.value.split('\\').pop();
            
            if (fileName.length > 0) {
                var blnValid = false;
                for (var j = 0; j < _validFileExtensions.length; j++) {
                    var sCurExtension = _validFileExtensions[j];
                    if (fileName.substr(fileName.length - sCurExtension.length, sCurExtension.length).toLowerCase() == sCurExtension.toLowerCase()) {
                        blnValid = true;
                        reader.readAsText(file, "UTF-8");
                        reader.onload = function (evt) {
                            var csv = evt.target.result;
                            console.log('csv file contains'+ csv);
                            var result = helper.CSV2JSON(component,csv);
                            console.log('result = ' + result);
                           	helper.updateSKU(component,selectAccountType,result);
                            
                        }
                    }
                    if (!blnValid) {
                        var message=fileName + ' '+ $A.get("$Label.c.Is_invalid_allowed_extensions_only") +' : '  + _validFileExtensions.join(", ");
                        helper.showErrorToast(component,event,message);
                        return false;
                    }
                }
            }
            reader.onerror = function (evt) {
                var message=$A.get("$Label.c.Error_reading_file");
                helper.showErrorToast(component,event,message);
            }
        }
        
    },
    
    //EDited
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    }
    
    //edited
    
})