({
    getSKUs : function(component, stockInChannel, currentMonthEnglish, lastMonthEnglish, last2MonthEnglish) {
        var action = component.get("c.getallSKU");
        
        action.setParams({
            "stockInChannel": stockInChannel,
            "currentMonth": currentMonthEnglish,
            "previousMonth": lastMonthEnglish,
            "previous2Month": last2MonthEnglish,
            "hideemptystock": component.get("v.hideemptystock") ,
            "customerId": component.get("v.customerId")
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                /*
                //in case Brazil : replace '.' with ','
                if($A.get("$Locale.country") == 'BR'){
                    for(var i=0;i<resultData.stockInChanneldetails.length ;i++){
                        var numberFormat = new Intl.NumberFormat('de-DE');
                        //var currentMonth = resultData.stockInChanneldetails[i].currentMonthVol.toString();
                        resultData.stockInChanneldetails[i].currentMonthVol = numberFormat.format(resultData.stockInChanneldetails[i].currentMonthVol);
                        
                        
                        //var previousMonthVol = resultData.stockInChanneldetails[i].previousMonthVol.toString();
                        resultData.stockInChanneldetails[i].previousMonthVol = numberFormat.format(resultData.stockInChanneldetails[i].previousMonthVol);
                        
                        
                        //var previous2MonthVol = resultData.stockInChanneldetails[i].previous2MonthVol.toString();
                        resultData.stockInChanneldetails[i].previous2MonthVol = numberFormat.format(resultData.stockInChanneldetails[i].previous2MonthVol);
                        
                        
                        }
                }
                */
                component.set("v.StockInChannelDetails", resultData.stockInChanneldetails);
                
                component.set("v.totalRecords", component.get("v.StockInChannelDetails").length);
                var sObjectList = component.get("v.StockInChannelDetails");
                var pageSize = component.get("v.pageSize");
                // set star as 0
                component.set("v.startPage",0);//changed to 1
                component.set("v.PageNumber",1);
                component.set("v.endPage",pageSize-1);
                //component.set("v.SubmittedForApproval", resultData.SubmittedForApproval); //added by swapnil
                //console.log('SubmittedForApproval'+!resultData.SubmittedForApproval);
                //component.set("v.FreezeDetails", !resultData.SubmittedForApproval);//added by swapnil
                //component.set("v.enablestock", !resultData.SubmittedForApproval);//added by swapnil
                var PaginationList = [];
                for(var i=0; i< pageSize; i++){
                    if(component.get("v.StockInChannelDetails").length> i)
                        PaginationList.push(sObjectList[i]);
                    component.set('v.PaginationList', PaginationList);
                }                
                
                var currentmonth = currentMonthEnglish+'_Description__c';
                var lastmonth = lastMonthEnglish+'_Description__c';
                var last2month = last2MonthEnglish+'_Description__c';
                
                component.set("v.liBrandname", resultData.ProductGroupList);
                component.set("v.TotalPages", Math.ceil(component.get("v.totalRecords") / pageSize));
                
                //component.set("v.currentnotes", resultData.stockInChannel.September_Description__c);
                component.set("v.currentnotes", resultData.stockInChannel[currentmonth]);
                
                component.set("v.previousnotes", resultData.stockInChannel[lastmonth]);
                component.set("v.lastnotes", resultData.stockInChannel[last2month]);
                component.set("v.displayDetails", true);
                component.set("v.ShowSpinner", true); // added by swapnil
                
                
                var curr = new Date; // current date
                var CurrentDay = $A.localizationService.formatDate(curr, "d");
                
                if(CurrentDay>resultData.endDate){
                    if(!resultData.SalesRepExceptionProvided){
                    component.set("v.FreezeDetails", false);
                    component.set("v.enablestock", false);
                    }
                }
                //checking if user have write access
               
                if(!resultData.writeAccess){
                    component.set("v.FreezeDetails", false);
                    component.set("v.enablestock", false);
                }
                
            }
            else{
                component.set("v.displayDetails", false);
                component.set("v.ShowSpinner", true); // added by swapnil
                component.find('notifLib').showToast({
                    "variant": "error",
                    "title": "Error!",
                    "message": "Stock in channel details are not available"
                });
            }
            
        });
        $A.enqueueAction(action);
    },
    
    helperUpdateVolume : function(component, rowIndex, currentMonth, previousMonth,
                                 previousMonth2, currentMonthEnglish, lastMonthEnglish,
                                 last2MonthEnglish){
        
        var pagination = component.get("v.PaginationList");
        var action = component.get("c.upsertStockInChannelDetails");
        
        action.setParams({
            "SKUId": pagination[rowIndex].SKUID,
            "currentMonth": currentMonth,
            "previousMonth": previousMonth,
            "previousMonth2": previousMonth2,
            "StockInChannelId": component.get("v.StockInChannelId"),
            "customerId": component.get("v.customerId"),
            "territoryId": component.get("v.territoryId"),
            "currentMonthlabel": currentMonthEnglish,
            "previousMonthlabel": lastMonthEnglish,
            "previous2Monthlabel": last2MonthEnglish
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                
              component.set("v.StockInChannelId",response.getReturnValue()); 
              component.set("v.ReadyForApproval", true); //added by Swapnil
              component.set("v.Status", "In Progress"); //added by Swapnil
              
            }
        });
        
        $A.enqueueAction(action);        
        
        
        
    },
    
    
    helperUpdateVolumePrevious2 : function(component, rowIndex, previousMonth, lastMonthEnglish){
        
        var pagination = component.get("v.PaginationList");
        
        
        
        var action = component.get("c.upsertStockInChannelDetailsMonth");
        
        action.setParams({
            "SKUId": pagination[rowIndex].SKUID,
            "Month": previousMonth,
            "StockInChannelId": component.get("v.StockInChannelId"),
            "customerId": component.get("v.customerId"),
            "territoryId": component.get("v.territoryId"),
            "monthLable": lastMonthEnglish 
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                
              component.set("v.StockInChannelId",response.getReturnValue()); 
      
            }
        });
        
        $A.enqueueAction(action);        
        
        
        
    },
    
    
    filterRecords : function(component){
        
        var sObjectList = component.get("v.StockInChannelDetails");
        //fetch selected Brand value
        var brand = component.find("selectBrand").get("v.value");
        //fetch description
        var description = component.find("SKUDescription").get("v.value"); 
        
        //description = description.toUpperCase();
        
        var skudescription;
        var pageNumber = component.get("v.PageNumber");
        var pageSize = component.get("v.pageSize");       
        var FliterList = [];
        var PaginationList = [];
        //brand and description is not null
        if(brand && description){
            description = description.toUpperCase();
            for(var i=0; i< sObjectList.length; i++){
                
                
                skudescription = sObjectList[i].productCategory;
                console.log(description);
                console.log(skudescription);
                //SKU search value is null
                if(skudescription){
                    if(sObjectList[i].brandName === brand
                       && skudescription.includes(description)>0)
                        FliterList.push(sObjectList[i]);
                }
                
            }
            
        }
        //brand != null and description is null
        if(brand &&  (description === undefined ||  description == "")){
            
            for(var i=0; i< sObjectList.length; i++){
                if(sObjectList[i].brandName === brand)
                    FliterList.push(sObjectList[i]);
            }
            
        }
        //description is not null and brand == null 
        if(description && (brand ==="" || brand == undefined)){
            description = description.toUpperCase();
            for(var i=0; i< sObjectList.length; i++){
                
                skudescription = sObjectList[i].productCategory;
                
                if(skudescription){
                    if(skudescription.includes(description)>0)
                        FliterList.push(sObjectList[i]);
                }
            }
            
        }
        //Both description and brand null
        if((description==="" || description == undefined) && brand === ""){
            
            FliterList= component.get("v.StockInChannelDetails");                
        }
        component.set('v.FliterList', FliterList);
        
        for(var i=0; i< pageSize; i++){
            if(FliterList.length> i)
                PaginationList.push(FliterList[i]);
            
        }
        component.set("v.PaginationList", PaginationList);
        component.set("v.startPage",0);
        component.set("v.PageNumber",1);
        component.set("v.totalRecords", component.get("v.FliterList").length);
        component.set("v.TotalPages", Math.ceil(component.get("v.totalRecords") / pageSize));
        component.set("v.endPage",pageSize-1);//
        
        
    },
    
    helperResetStock: function(component, event, helper, SKUIdList) {
        
        //currentMonthinEnglish
            const monthNames = ["January", "February", "March", "April", "May", "June",
                                "July", "August", "September", "October", "November", "December"
                               ];
        var curr = new Date; // current date
            var currentMonthEnglish = monthNames[curr.getMonth()];
            
        //last Month
        var previousmonth = new Date(curr.getFullYear(), curr.getMonth()-1, 1);
        var lastMonthEnglish =  monthNames[previousmonth.getMonth()];
        
        //Last last Month
        var previou2smonth = new Date(curr.getFullYear(), curr.getMonth()-2, 1);
        var last2MonthEnglish =  monthNames[previou2smonth.getMonth()];
        
        var action = component.get("c.resetStockMethod");
        
        action.setParams({
            "SKUIds": SKUIdList,
            "currentMonth": currentMonthEnglish,
            "previousMonth": lastMonthEnglish,
            "previous2Month": last2MonthEnglish
            
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Updated successfully');
            }
        })
    
        $A.enqueueAction(action);      
        
        
    },
    
    helperCopyStock: function(component, event, helper, SKUIdList) {
        
        //currentMonthinEnglish
            const monthNames = ["January", "February", "March", "April", "May", "June",
                                "July", "August", "September", "October", "November", "December"
                               ];
        var curr = new Date; // current date
            var currentMonthEnglish = monthNames[curr.getMonth()];
            
        //last Month
        var previousmonth = new Date(curr.getFullYear(), curr.getMonth()-1, 1);
        var lastMonthEnglish =  monthNames[previousmonth.getMonth()];
        
        //Last last Month
        var previou2smonth = new Date(curr.getFullYear(), curr.getMonth()-2, 1);
        var last2MonthEnglish =  monthNames[previou2smonth.getMonth()];
        
        var action = component.get("c.copyStockMethod");
        
        action.setParams({
            "SKUIds": SKUIdList,
            "currentMonth": currentMonthEnglish,
            "previousMonth": lastMonthEnglish,
            "previous2Month": last2MonthEnglish
            
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Updated successfully');
            }
        })
    
        $A.enqueueAction(action);
        
    }
    
    
    
})