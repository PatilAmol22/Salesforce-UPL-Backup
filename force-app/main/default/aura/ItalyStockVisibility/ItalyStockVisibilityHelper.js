({
	fetchActivities : function(component, salesOrgCode, distributionChannelCode, divisionCode, page, recordToDisply, productSearch,productIdentification){
        // show spinner to true on click of a button / onload
        //component.set("v.showSpinner", true);
        //console.log('isAsc : '+isAsc);
       	console.log('print product 2 : '+productSearch);
        console.log('print page : '+page);
        console.log('productIdentification helper: '+productIdentification);
        var action = component.get("c.getActivities");
        action.setParams({
            salesOrgCode : salesOrgCode,
            distributionChannelCode : distributionChannelCode,
            divisionCode : divisionCode,
            pageNumber: page,
            recordToDisply: recordToDisply,
            productSearch: productSearch,
            productIdentification : productIdentification
        });
        action.setCallback(this, function(a) {
            // on call back make it false ,spinner stops after data is retrieved
            //component.set("v.showSpinner", false); 
            
            var state = a.getState();
            // console.log('state: '+JSON.stringify(state));   
            
            if (state == "SUCCESS") {
                var returnValue = a.getReturnValue();
                console.log('returnValue: '+JSON.stringify(returnValue));
                //component.set("v.pagedResult", returnValue);
                
                component.set("v.SKUList", returnValue.results);  
               	var SKUList=component.get("v.SKUList");
                console.log('SKUList : '+JSON.stringify(SKUList));
                if(returnValue.results.length===0){
                    console.log('Null');
                    component.set('v.checkRecord',true);
                    
                }else {
                    console.log('profileName :'+returnValue.profileName);
                    component.set('v.checkRecord',false);
                    component.set("v.page", returnValue.page);  
                    component.set("v.total", parseInt(returnValue.total));  
                    component.set("v.pages", Math.ceil(returnValue.total / recordToDisply));  
                    if(returnValue.profileName=='Sales Agents Italy' || returnValue.profileName=='Sales Director Italy' || returnValue.profileName=='Country Manager Italy' || returnValue.profileName=='Area Manager Italy' ){
                        component.set('v.isVisible',false);
                    }
                }
                
                var code='';
                //var skuCode=returnValue.results.SKU_Code__c;
                for(var i=0;i<SKUList.length;i++){
                    //console.log('code : '+returnValue.results[i].SKU_Code__c);
                    code=returnValue.results[i].SKU_Code__c.substring(11);
                    console.log('code : '+code);
                  	component.set("v.SKUList["+i+"].SKU_Code__c", code);
                }
            }
            else{
                //this.showErrorToast(component, 'Some error has occurred. Please contact System Administrator.');
            }
        });
        $A.enqueueAction(action);
    },
    
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
    
    updateSKU : function (component,jsonstr){
        console.log('jsonstr : '+jsonstr);
        var action = component.get("c.updateCSVData");
        action.setParams({
            "strfromCSV" : jsonstr
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