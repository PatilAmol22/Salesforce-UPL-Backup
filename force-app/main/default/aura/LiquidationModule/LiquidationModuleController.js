({
    doInit : function(component, event, helper) {
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.today', today);
        var type = $A.get('$Label.c.Liquidation_type');
        type = type.split(",");
        component.set('v.LiquidationType', type);
        var month = $A.get('$Label.c.Liquidation_Month');
        month = month.split(",");
        component.set('v.LiquidationMonth', month);
        var currentYear = (new Date()).getFullYear();
        var yearList = [currentYear,currentYear-1,currentYear-2,currentYear-3,currentYear-4,currentYear-5];
        component.set('v.FinancialYear',yearList);
        var dateString = ''+currentYear-5+'-01-01';
        console.log('dateString::'+dateString);
        var min = $A.localizationService.formatDate(new Date(dateString), "YYYY-MM-DD");
        component.set('v.min', min);
        component.set('v.max', today);
        helper.getDocuments(component,event,helper);
    },
    onSelectchange : function(component, event, helper) {
        var type = component.find('liquidationselect').get('v.value');
        if(type == 'Sales'){
            component.set('v.salesSelected',true);
            component.set('v.inventorySelected',false);
        }
        else if(type == 'Inventory'){
            component.set('v.inventorySelected',true);
            component.set('v.salesSelected',false);
        }
            else if(type == 'Select'){
                component.set('v.inventorySelected',false);
                component.set('v.salesSelected',false);
            }
    },
    onYearSelectchange : function(component, event, helper) {
        var curryear = component.find('liquidationfinyear').get('v.value');
        component.set('v.finyear',curryear);
        console.log(component.get('v.finyear'));
        
    },
    onMonthSelectchange : function(component, event, helper) {
        var currmonth = component.find('liquidationcurrentMonth').get('v.value');
        component.set('v.selectmonth',currmonth);
        console.log(component.get('v.selectmonth'));
    },
    onDatechange : function(component, event, helper) {
        console.log(component.get('v.today'));
        var dateRange = component.find('daterange').get('v.validity');
        console.log('dateRange::'+dateRange.valid);
    },
    handleKeyUp : function(component, event, helper) {
        var queryTerm = component.get('v.myEnterSearch');
        component.set('v.issearching', true);
        setTimeout(function() {
            helper.getCurrentAccount();
            component.set('v.issearching', false);
        }, 2000);
    },
    searchHandler : function (component, event, helper) {
        component.set("v.distributorEmpty",false);
        const searchString = event.target.value;
        if (searchString.length >= 3) {
            //Ensure that not many function execution happens if user keeps typing
            if (component.get("v.inputSearchFunction")) {
                clearTimeout(component.get("v.inputSearchFunction"));
            }
            
            var inputTimer = setTimeout($A.getCallback(function () {
                helper.searchRecords(component, searchString);
            }), 1000);
            component.set("v.inputSearchFunction", inputTimer);
        } else{
            component.set("v.results", []);
            component.set("v.openDropDown", false);
        }
    },
    
    optionClickHandler : function (component, event, helper) {
        const selectedId = event.target.closest('li').dataset.id;
        const selectedValue = event.target.closest('li').dataset.value;
        console.log('1:'+selectedId+'2:'+selectedValue);
        component.set("v.inputValue", selectedValue);
        component.set("v.openDropDown", false);
        component.set("v.selectedOption", selectedId);
    },
    
    clearOption : function (component, event, helper) {
        component.set("v.results", []);
        component.set("v.openDropDown", false);
        component.set("v.inputValue", "");
        component.set("v.selectedOption", "");
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
        if(component.get("v.selectedOption")== null || component.get("v.selectedOption") == ''){
            component.set("v.distributorEmpty",true);
            return;
        }
        else{
            component.set("v.distributorEmpty",false);
        }
        var type = component.find('liquidationselect').get('v.value');
        if(type == 'Sales'){
            var salesDate = new Date(component.get("v.finyear"),component.get("v.selectmonth")-1);
            if(component.get("v.finyear")== null || component.get("v.finyear") == ''){
                component.set("v.yearInvalid",true);
                return;
            }
            else{
                component.set("v.yearInvalid",false);
            }
             if(component.get("v.selectmonth")== null || component.get("v.selectmonth") == ''){
                component.set("v.monthInvalid",true);
                return;
            }
            else{
                component.set("v.monthInvalid",false);
            }
             if((component.get("v.monthInvalid") == false || component.get("v.yearInvalid") == false) &&
                salesDate > new Date()){
                component.set("v.monthFuture",true);
                return;
            }
            else{
                component.set("v.monthFuture",false);
            }
            
        }
        else if(type == 'Inventory'){
            var dateRange = component.find('daterange').get('v.validity');
            if(!dateRange.valid)
                return;
                
        }
        var file = fileInput[0];
        console.log(file);
        var action = component.get("c.passFileAura"); 
        var objFileReader = new FileReader();        
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result; 
            action.setParams({ file : objFileReader.result,
                              ftype : component.find('liquidationselect').get('v.value'),
                              distributor : component.get("v.selectedOption"),
                              year : component.get("v.finyear"),
                              month : component.get("v.selectmonth"),
                              cdate : component.get("v.today")
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
})