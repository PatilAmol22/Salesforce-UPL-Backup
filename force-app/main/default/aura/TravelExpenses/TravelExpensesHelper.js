({
    applyCSS: function(component){
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:0} .forceStyle.desktop ");
    },
    
    revertCssChange: function(component){
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:5} .forceStyle.desktop .viewport{overflow:visible}");
    },
    fetchPickListMonthData: function(component){
        var action= component.get("c.getMonthItemsType");
        
        var opts = [];
        
        action.setCallback(this, function(response) {
            //  console.log("response :- "+response);
            var state = response.getState();
            //  console.log('state month: '+JSON.stringify(state)); 
            if (state == "SUCCESS") {
                
                var allValues = response.getReturnValue();
                //    console.log('allValues: '+allValues); 
                if (allValues != undefined && allValues.length > 0) {
                    
                    opts.push({"class": "optionClass", label: 'Month To Date', value: ''});
                    
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({"class": "optionClass",label: allValues[i],value: allValues[i]});
                }
                component.find("mtdOptions").set("v.options", opts);   
                
            }
        });
        $A.enqueueAction(action);
    },
    fetchPickListYearData: function(component){
        var action= component.get("c.getYearItemsType");
        
        var opts = [];
        
        action.setCallback(this, function(response) {
            //  console.log("response :- "+response);
            var state = response.getState();
            //  console.log('state month: '+JSON.stringify(state)); 
            if (state == "SUCCESS") {
                
                var allValues = response.getReturnValue();
                //    console.log('allValues: '+allValues); 
                if (allValues != undefined && allValues.length > 0) {
                    
                    opts.push({"class": "optionClass", label: 'Year', value: ''});
                    
                }
                for (var i = 0; i < allValues.length; i++) {
                    
                    opts.push({"class": "optionClass",label: allValues[i],value: allValues[i]});
                }
                
                component.find("yrOptions").set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
    },
    fetchPickListData: function(component){
        var action= component.get("c.getItemsType");
        
        var opts = [];
        
        action.setCallback(this, function(response) {
            //  console.log("response :- "+response);
            var state = response.getState();
            //    console.log('state: '+JSON.stringify(state)); 
            if (state == "SUCCESS") {
                
                var allValues = response.getReturnValue();
                
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({"class": "optionClass", label: 'None', value: ''});
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({"class": "optionClass",label: allValues[i],value: allValues[i]});
                }
                component.find("items").set("v.options", opts);   
            }
        });
        $A.enqueueAction(action);
    },
    addTravelExpenseItems: function(component, new_item1) {
        
        //  console.log('amnt : '+component.get("v.TravelExpenses.Amount__c"));
        var sum = 0;
        var ItemList = component.get("v.TravelExpensesList");
        ItemList.push(new_item1);
        
        component.set("v.TravelExpensesList", ItemList);
        
        var JSONObject = JSON.stringify(ItemList);
        var parsed = JSON.parse(JSONObject);
        
        for(var j=0;j<parsed.length;j++){
            sum = sum + +parsed[j].Amount__c ;
        }
        
        component.find("totalAmount").set("v.value",sum);
        component.set("v.travelexpense",{'sobjectType': 'Expense_Item__c',
                                         'Date__c': '',
                                         'Item__c': '',
                                         'Amount__c': '',
                                         'Purpose__c': '',
                                         'Location__c':'',
                                         'Remarks__c':''});
        
    },
    fetchActivities : function(component, page, recordToDisply, sortField, isAsc, whereClause){
        // show spinner to true on click of a button / onload
        //component.set("v.showSpinner", true);
        
        var action = component.get("c.getActivities");
        
         console.log('action : '+action);
        
        action.setParams({
            pageNumber: page,
            recordToDisply: recordToDisply,
            sortField: sortField,
            isAsc: isAsc,
            whereClause: whereClause
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
                
                component.set("v.TravelExpenseMonthList", returnValue.results);  
                component.set("v.page", returnValue.page);  
                component.set("v.total", parseInt(returnValue.total));  
                component.set("v.pages", Math.ceil(returnValue.total / recordToDisply));  
            }
            else{
                //this.showErrorToast(component, 'Some error has occurred. Please contact System Administrator.');
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchProfile: function(component){
        
        var action = component.get("c.getProfileName");
        action.setCallback(this, function(a) {
            
            // on call back make it false ,spinner stops after data is retrieved
            //component.set("v.showSpinner", false); 
            
            var state = a.getState();
           // console.log('state: '+JSON.stringify(state));   
            
            if (state == "SUCCESS") {
                var returnValue = a.getReturnValue();
                
              //  console.log('returnValue Name : '+JSON.stringify(returnValue));
                var ProfileList = JSON.stringify(returnValue);
                var parsed = JSON.parse(ProfileList);
                for( var k = 0; k < parsed.length ; k++){
                    
                    var name = parsed[k].Name;
                    if(name == "Territory Manager Indonesia"){

                        component.set("v.isNMM",false);
                        component.set("v.isAddNEw",true);
                        
                    } if(name == "Marketing user Indonesia"){
                        

                        
                        component.set("v.isNSM",false);
                        component.set("v.isAddNEw",true);
                        
                    } if(name == "Regional/Zonal Indonesia"){
                        

                        component.set("v.isNMM",false);
                        component.set("v.isRM",false);
                        component.set("v.isAddNEw",true);
                        
                    }if(name == "Marketing Manager Indonesia"){
                        

                        component.set("v.isNSM",false);

                        
                    }if(name == "National sales Manager indonesia"){
                        

                        component.set("v.isNMM",false);

                        
                    }if(name == "System Administrator"){
                        

                        component.set("v.isAddNEw",true);
                        
                    }
                }
                
            }
            else{
                //this.showErrorToast(component, 'Some error has occurred. Please contact System Administrator.');
            }
        });
        $A.enqueueAction(action);
        
    },
    
    showToast : function(title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message
        });
        toastEvent.fire();
    },
    //UPL-2-I386: Modified by:Ankita Saxena Changes in Travel request  for Indonesia
    sortHelper : function(component, event, sortFieldName) {  
        var currentDir = component.get("v.arrowDirection");  
        if (currentDir == 'arrowdown') {  
            component.set("v.arrowDirection", 'arrowup');  
            component.set("v.isAsc", true);  
        } else {  
            component.set("v.arrowDirection", 'arrowdown');  
            component.set("v.isAsc", false);  
        }  
        this.fetchActivities(component, component.get("v.page"), component.find("recordSize").get("v.value"), sortFieldName, component.get("v.isAsc"), '');  
    },
})