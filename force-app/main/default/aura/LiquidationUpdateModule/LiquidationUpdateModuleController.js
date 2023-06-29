({
    doInit : function(component, event, helper) {
        var type = $A.get('$Label.c.Liquidation_type');
        type = type.split(",");
        component.set('v.LiquidationType', type);
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.today', today);
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
        
    },
    onSelectchange : function(component, event, helper) {
        var type = component.find('liquidationselect').get('v.value');
        component.set('v.typeSelected',type);
        if(type == 'Sales'){
            helper.fetchSecondary(component);  
        }
        else if(type == 'Inventory'){
            helper.fetchInventory(component); 
            component.set('v.totalAmount','');
            component.set('v.totalQuantity','');
            component.set('v.Quantity','');
             component.set('v.Amount','');
        }
            else if(type == 'Select'){
                component.set('v.display',false);
                component.set('v.inventorySelected',false);
                component.set('v.salesSelected',false);
            }
    },
    handleNext: function(component, event, helper) {
        if(component.get("v.FilterList").length>0)
            var sObjectList = component.get("v.FilterList");
        else
            var sObjectList = component.get("v.recordsList");    
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        var totalAmount= 0;
        var totalQuantity =0;
        for(var i=end+1; i<end+pageSize+1; i++){
            if(sObjectList.length > i){
                Paginationlist.push(sObjectList[i]);
                if (totalAmount == 0)
                    totalAmount += sObjectList[i].Sell_Amount_USD__c;
                else
                    totalAmount += sObjectList[i].Sell_Amount_USD__c;
                if(totalQuantity == 0)    
                  totalQuantity += sObjectList[i].Product_Quantity__c;
                else
                  totalQuantity += sObjectList[i].Product_Quantity__c;
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;        
        
        component.set("v.totalQuantity",totalQuantity.toFixed(2));
        component.set("v.totalAmount",totalAmount.toFixed(1));
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        component.set("v.FinalList",[]);
        component.set("v.PageNumber",component.get("v.PageNumber")+1);
    },
    handlePrev: function(component, event, helper) {
        if(component.get("v.FilterList").length>0)
            var sObjectList = component.get("v.FilterList");
        else
            var sObjectList = component.get("v.recordsList");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        var totalAmount =0;
        var totalQuantity =0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                Paginationlist.push(sObjectList[i]);
                if(totalAmount == 0)
                  totalAmount += sObjectList[i].Sell_Amount_USD__c;
                else
                  totalAmount += sObjectList[i].Sell_Amount_USD__c;
                if(totalQuantity ==0)    
                  totalQuantity += sObjectList[i].Product_Quantity__c;
                else
                  totalQuantity += sObjectList[i].Product_Quantity__c;
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        
        component.set("v.totalQuantity",totalQuantity.toFixed(2));
        component.set("v.totalAmount",totalAmount.toFixed(1));
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        component.set("v.FinalList",[]);
        component.set("v.PageNumber",component.get("v.PageNumber")-1);
    },
    onSKUChange: function(component, event, helper) {
        
        var timer = setTimeout(function(){
            helper.multipleFilterRecords(component);           
        },500);
        
    },
    onDistChange: function(component, event, helper) {
        
        var timer = setTimeout(function(){
            helper.multipleFilterRecords(component);           
        },500);
        
    },
    onCityChange: function(component, event, helper) {
        
        var timer = setTimeout(function(){
            helper.multipleFilterRecords(component);           
        },500);
        
    },
    onMonthSelectchange: function(component, event, helper) {
        
        var timer = setTimeout(function(){
            helper.multipleFilterRecords(component);           
        },500);
        
    },
    onYearSelectchange: function(component, event, helper) {
        
        var timer = setTimeout(function(){
            helper.multipleFilterRecords(component);           
        },500);
        
    },
    onDatechange: function(component, event, helper) {
        
        var timer = setTimeout(function(){
            helper.multipleFilterRecords(component);           
        },500);
        
    },
    handleSave: function(component, event, helper){
        var type  = component.get('v.typeSelected');
        var recordsList = component.get("v.recordsList");
        var draftList = event.getParam('draftValues');
        console.log('draftValues-> ' + JSON.stringify(draftList));
        console.log('recordsList->' + JSON.stringify(recordsList));
        if(type == 'Sales'){
            var action = component.get("c.saveSecondaryData");
        }
        else if(type == 'Inventory'){
            var action = component.get("c.saveInventoryData");
        }
        action.setParams({records: draftList});
        action.setCallback(this, function(actionResult){
            var response=actionResult.getReturnValue();
            if(response.includes('Success'))
            { 
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "",
                    "message": 'Records updated successfully!',
                    "type":"Success",
                    "mode":"sticky"
                });
                toastEvent.fire();
                var type = component.get('v.typeSelected');
                if(type == 'Sales'){
                    helper.fetchSecondary(component);  
                    var timer = setTimeout(function(){
                        helper.multipleFilterRecords(component);           
                    },500);
                }
                else if(type == 'Inventory'){
                    helper.fetchInventory(component);
                    var timer = setTimeout(function(){
                        helper.multipleFilterRecords(component);           
                    },500);
                }
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
                    var type = component.get('v.typeSelected');
                    if(type == 'Sales'){
                        helper.fetchSecondary(component);  
                    }
                    else if(type == 'Inventory'){
                        helper.fetchInventory(component);  
                    }
                    
                }
            }
        }); 
        
        $A.enqueueAction(action);
    }
})