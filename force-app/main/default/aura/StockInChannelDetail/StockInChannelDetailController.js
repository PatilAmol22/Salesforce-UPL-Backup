({
    doInit : function(component, event, helper) {
        
        var curr = new Date; // current date
        //curr.setMonth(curr.getMonth() - 9); //testing january
        
        var CurrentMonth = $A.localizationService.formatDate(curr, "MMMM");
        
        component.set("v.CurrentMonth",CurrentMonth);
        
        //last Month
        var previousmonth = new Date(curr.getFullYear(), curr.getMonth()-1, 1);
        var LastMonth = $A.localizationService.formatDate(previousmonth, "MMMM");
        component.set("v.PreviousMonth",LastMonth);
        //Last last Month
        var previou2smonth = new Date(curr.getFullYear(), curr.getMonth()-2, 1);
        var Last2Month = $A.localizationService.formatDate(previou2smonth, "MMMM");
        component.set("v.Previous2Month",Last2Month);
        var stockInChannel = component.get("v.StockInChannelId");
        var pageNumber = component.get("v.PageNumber");  
        //var pageSize = component.find("pageSize").get("v.value"); 
        var pageSize = component.get("v.pageSize");
        
        //currentMonthinEnglish
        const monthNames = ["January", "February", "March", "April", "May", "June",
                            "July", "August", "September", "October", "November", "December"
                           ];
        var curr = new Date; // current date
        //curr.setMonth(curr.getMonth() - 9); //testing january
        var currentMonthEnglish = monthNames[curr.getMonth()];
        
        //last Month
        var previousmonth = new Date(curr.getFullYear(), curr.getMonth()-1, 1);
        var lastMonthEnglish =  monthNames[previousmonth.getMonth()];
        
        //Last last Month
        var previou2smonth = new Date(curr.getFullYear(), curr.getMonth()-2, 1);
        var last2MonthEnglish =  monthNames[previou2smonth.getMonth()];
        
        helper.getSKUs(component, stockInChannel, currentMonthEnglish, lastMonthEnglish, last2MonthEnglish);
        //helper.getNotes(component,event,helper);
    },
    
    
    
    handleNext: function(component, event, helper) {
        
        if(component.get("v.FliterList").length>0)
            var sObjectList = component.get("v.FliterList");
        else
            var sObjectList = component.get("v.StockInChannelDetails");    
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        for(var i=end+1; i<end+pageSize+1; i++){
            if(sObjectList.length > i){
                Paginationlist.push(sObjectList[i]);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        component.set("v.PageNumber",component.get("v.PageNumber")+1);
    },
    
    handlePrev: function(component, event, helper) {
        
        if(component.get("v.FliterList").length>0)
            var sObjectList = component.get("v.FliterList");
        else
            var sObjectList = component.get("v.StockInChannelDetails");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                Paginationlist.push(sObjectList[i]);
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        component.set("v.PageNumber",component.get("v.PageNumber")-1);
    },
    
    onSelectChange: function(component, event, helper) {
        var page = 1
        //var pageSize = component.find("pageSize").get("v.value");
        var pageSize = component.get("v.pageSize");
        helper.getSKUs(component, pageNumber, pageSize, component.find("selectBrand").get("v.value"), component.find("SKUDescription").get("v.value"));
    },
    
    //reset stock function
    resetStock: function(component, event, helper) {
        var SKU = component.get("v.PaginationList");
        var SKUslength = component.get("v.PaginationList").length;
        console.log('SKUslength'+SKUslength);
        var i;
        var SKUIdList = [];
        
        if(component.get("v.FliterList").length>0)
            var sObjectList = component.get("v.FliterList");
        else
            var sObjectList = component.get("v.StockInChannelDetails");
        
        for (i = 0; i < SKUslength; i++) {
            
            var currentMonthdivId ="currentMonth"+i;
            console.log('2 '+SKU[i].currentMonthVol);
            
            //component.find("currentMonth")[i].set("v.value","0");
            //if(SKU[i].currentMonthVol!="0"){
            if(SKU[i].currentMonthVol!==undefined){
                SKU[i].currentMonthVol = "";
                console.log('1 '+SKU[i].currentMonthVol);
                const index = sObjectList.indexOf(SKU[i]);
                sObjectList[index].currentMonthVol = ""; //0
                SKUIdList.push(SKU[i].SKUID);
            }
            
        }
        component.set("v.PaginationList",SKU);
        console.log('ResetList'+SKUIdList);
        //alert('helper');
        helper.helperResetStock(component, event, helper, SKUIdList);
        
    },
    
    //Copy functionality
    copy: function(component, event, helper) {
        var SKU = component.get("v.PaginationList");
        var SKUslength = component.get("v.PaginationList").length;
        var i;
        
        if(component.get("v.FliterList").length>0)
            var sObjectList = component.get("v.FliterList");
        else
            var sObjectList = component.get("v.StockInChannelDetails");
        
        var SKUIdList = [];
        for (i = 0; i < SKUslength; i++) {
            
            var currentMonthdivId ="currentMonth"+i;
            var previousMonthdivId = "previousMonth"+i;
            console.log('outside loop1 '+SKU[i].currentMonthVol);
             console.log('outside loop2 '+SKU[i].previousMonthVol);
            if(SKU[i].currentMonthVol === undefined
               && SKU[i].previousMonthVol !== "0" 
               && SKU[i].previousMonthVol !== ""
              ){
                console.log('Inside loop '+SKU[i].currentMonthVol);
                SKU[i].currentMonthVol = SKU[i].previousMonthVol;
                
                const index = sObjectList.indexOf(SKU[i]);
                sObjectList[index].currentMonthVol = SKU[i].previousMonthVol;
                SKUIdList.push(SKU[i].SKUID);
                
            }
            
            
        } 
        component.set("v.PaginationList",SKU);
        helper.helperCopyStock(component, event, helper, SKUIdList); 
    },
    
    onBrandnameChange: function(component, event, helper) {
        helper.filterRecords(component);     
    },
    
    handleSearchSKUDescription: function(component, event, helper) {
        
        var timer = setTimeout(function(){
            helper.filterRecords(component);           
        },500);
        
    },
    
    updateNotes: function(component, event, helper) {
        
        
        /*var description = component.find("currentnotes").get("v.value");
            var Olddescription = component.find("previousnotes").get("v.value");
            var Old2description = component.find("lastnotes").get("v.value");*/
        var description = document.getElementById("currentnotes").value
        var Olddescription = document.getElementById("previousnotes").value
        var Old2description = document.getElementById("lastnotes").value
        //currentMonthinEnglish
        const monthNames = ["January", "February", "March", "April", "May", "June",
                            "July", "August", "September", "October", "November", "December"
                           ];
        var curr = new Date; // current date
        //curr.setMonth(curr.getMonth() - 9); //testing january
        var currentMonthEnglish = monthNames[curr.getMonth()];
        console.log(currentMonthEnglish);
        //last Month
        var previousmonth = new Date(curr.getFullYear(), curr.getMonth()-1, 1);
        var lastMonthEnglish =  monthNames[previousmonth.getMonth()];
        console.log(lastMonthEnglish);
        //Last last Month
        var previou2smonth = new Date(curr.getFullYear(), curr.getMonth()-2, 1);
        var last2MonthEnglish =  monthNames[previou2smonth.getMonth()];    
        console.log(last2MonthEnglish);
        var action = component.get("c.UnsertStockInChannelDetails");
        
        action.setParams({
            "description": description,
            "Olddescription": Olddescription,
            "Old2description": Old2description,
            "stockInChannelId": component.get("v.StockInChannelId"),
            "customerId": component.get("v.customerId"),
            "territoryId": component.get("v.territoryId"),
            "currentMonth": currentMonthEnglish,
            "previousMonth": lastMonthEnglish,
            "previous2Month": last2MonthEnglish
            
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                
                component.set("v.StockInChannelId",response.getReturnValue());   
                
            }
        });
        $A.enqueueAction(action);
        
        
        
        
    },
    
    UpdateVolume: function(component, event, helper) {
        
        var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        //var rowIndex = event.getSource().get('v.name');
        //alert(event.source.Rc.rc);
        console.log('row'+rowIndex);
        helper.helperUpdateVolume(component, rowIndex);
        
    },
    
    
    UpdateVolumeMonth: function(component, event, helper) {
        
       var pagination = component.get("v.PaginationList");
        var target = event.target;
        var rowIndex = event.getSource().get('v.label');
        var value = event.getSource().get('v.value');
        if(value !== undefined){
        ///currentMonthinEnglish
        const monthNames = ["January", "February", "March", "April", "May", "June",
                            "July", "August", "September", "October", "November", "December"
                           ];
        var curr = new Date; // current date
        //curr.setMonth(curr.getMonth() - 9); //testing january
        var currentMonthEnglish = monthNames[curr.getMonth()];
        console.log(currentMonthEnglish);
        //last Month
        var previousmonth = new Date(curr.getFullYear(), curr.getMonth()-1, 1);
        var lastMonthEnglish =  monthNames[previousmonth.getMonth()];
        console.log(lastMonthEnglish);
        //Last last Month
        var previou2smonth = new Date(curr.getFullYear(), curr.getMonth()-2, 1);
        var last2MonthEnglish =  monthNames[previou2smonth.getMonth()];
            console.log(last2MonthEnglish);
        var currentMonth = value;
        var previousMonthVol = pagination[rowIndex].previousMonthVol;
         var previousMonth2 = pagination[rowIndex].previous2MonthVol;
        
        //added by Swapnil
            if(value>(previousMonthVol+pagination[rowIndex].previousSales)){
               
                var action = component.get("c.SICSKUExc");
                
                action.setParams({
                    "SKUId": pagination[rowIndex].SKUID,            
                    "customerId": component.get("v.customerId")                       
                });
                action.setCallback(this, function(response) {
                    var message = $A.get("$Label.c.SIC_SKU_ERROR");
                   
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        console.log('Response '+response.getReturnValue().isValid);
                        if(!response.getReturnValue().isValid) {
                            component.find('notifLib').showToast({
                                "variant": "error",
                                "title": "Error!",
                                "message": message
                            });
                           
                           event.getSource().set('v.value',response.getReturnValue().OldValue);
                        }
                        else{
                            if(currentMonth.length==0)
                                currentMonth = 0; 
                            
                            helper.helperUpdateVolume(component, rowIndex, currentMonth, previousMonthVol, previousMonth2, currentMonthEnglish, lastMonthEnglish, last2MonthEnglish);
                            
                            if(component.get("v.FliterList").length>0)
                                var sObjectList = component.get("v.FliterList");
                            else
                                var sObjectList = component.get("v.StockInChannelDetails");
                            
                            const index = sObjectList.indexOf(pagination[rowIndex]);
                            
                            
                            sObjectList[index].currentMonthVol = currentMonth;
                            component.set("v.PaginationList",pagination);
                        }
                        
                        
                    }
                });
                
                $A.enqueueAction(action); 
                
                
                
                
            }
            else{
                //end
                
                if(currentMonth.length==0)
                    currentMonth = 0; 
                
                helper.helperUpdateVolume(component, rowIndex, currentMonth, previousMonthVol, previousMonth2, currentMonthEnglish, lastMonthEnglish, last2MonthEnglish);
                
                if(component.get("v.FliterList").length>0)
                    var sObjectList = component.get("v.FliterList");
                else
                    var sObjectList = component.get("v.StockInChannelDetails");
                
                const index = sObjectList.indexOf(pagination[rowIndex]);
                
                
                sObjectList[index].currentMonthVol = currentMonth;
                component.set("v.PaginationList",pagination);
            }
        }//added by Swapnil
    },
    
    UpdateVolumePrevious : function(component, event, helper) {
       var pagination = component.get("v.PaginationList");
        var target = event.target;
        var rowIndex = event.getSource().get('v.label');
        var value = event.getSource().get('v.value');
        if(value !== undefined){
        ///currentMonthinEnglish
        const monthNames = ["January", "February", "March", "April", "May", "June",
                            "July", "August", "September", "October", "November", "December"
                           ];
        var curr = new Date; // current date
            //curr.setMonth(curr.getMonth() - 9); //testing january
        var currentMonthEnglish = monthNames[curr.getMonth()];
        
        //last Month
        var previousmonth = new Date(curr.getFullYear(), curr.getMonth()-1, 1);
        var lastMonthEnglish =  monthNames[previousmonth.getMonth()];
        
        //Last last Month
        var previou2smonth = new Date(curr.getFullYear(), curr.getMonth()-2, 1);
        var last2MonthEnglish =  monthNames[previou2smonth.getMonth()];
        
         var previousMonth2 = pagination[rowIndex].previous2MonthVol;
        var currentMonthVol = pagination[rowIndex].currentMonthVol;
        var previousMonth = value;
        if(previousMonth.length==0)
            previousMonth = 0; 
        
        helper.helperUpdateVolume(component, rowIndex, currentMonthVol, previousMonth, previousMonth2, currentMonthEnglish, lastMonthEnglish, last2MonthEnglish);
        var pagination = component.get("v.PaginationList");
        if(component.get("v.FliterList").length>0)
            var sObjectList = component.get("v.FliterList");
        else
            var sObjectList = component.get("v.StockInChannelDetails");
        
        const index = sObjectList.indexOf(pagination[rowIndex]);
        
        
        sObjectList[index].previousMonthVol = previousMonth;
        component.set("v.PaginationList",pagination);
        }
    },
    
    
    UpdateVolumePrevious2 : function(component, event, helper) {
        var pagination = component.get("v.PaginationList");
        var target = event.target;
        var rowIndex = event.getSource().get('v.label');
        var value = event.getSource().get('v.value');
        if(value !== undefined){
        ///currentMonthinEnglish
        const monthNames = ["January", "February", "March", "April", "May", "June",
                            "July", "August", "September", "October", "November", "December"
                           ];
        var curr = new Date; // current date
            //curr.setMonth(curr.getMonth() - 9); //testing january
        var currentMonthEnglish = monthNames[curr.getMonth()];
        
        //last Month
        var previousmonth = new Date(curr.getFullYear(), curr.getMonth()-1, 1);
        var lastMonthEnglish =  monthNames[previousmonth.getMonth()];
        
        //Last last Month
        var previou2smonth = new Date(curr.getFullYear(), curr.getMonth()-2, 1);
        var last2MonthEnglish =  monthNames[previou2smonth.getMonth()];
        
        
        var previousMonth2 = value;
        var currentMonthVol = pagination[rowIndex].currentMonthVol;
        var previousMonthVol = pagination[rowIndex].previousMonthVol;
        if(previousMonth2.length==0)
            previousMonth2 = 0; 
        
        helper.helperUpdateVolume(component, rowIndex, currentMonthVol, previousMonthVol, previousMonth2, currentMonthEnglish, lastMonthEnglish, last2MonthEnglish);
        //var pagination = component.get("v.PaginationList");
        if(component.get("v.FliterList").length>0)
            var sObjectList = component.get("v.FliterList");
        else
            var sObjectList = component.get("v.StockInChannelDetails");
        
        const index = sObjectList.indexOf(pagination[rowIndex]);
        
        
        sObjectList[index].previous2MonthVol = previousMonth2;
        component.set("v.PaginationList",pagination);
        }
    },
    
    onChangeHideEmptyStock: function(component, event, helper) {
        if(component.get("v.hideemptystock")){
            
            
            var FliterList = [];
            if(component.get("v.FliterList").length>0)
                var sObjectList = component.get("v.FliterList");
            else
                var sObjectList = component.get("v.StockInChannelDetails");
            //var brand = component.find("selectBrand").get("v.value");
            
            var pageNumber = component.get("v.PageNumber");
            var pageSize = component.get("v.pageSize");
            var PaginationList = [];
            for(var i=0; i< sObjectList.length; i++){
                
                if(sObjectList[i].currentMonthVol != 0 || (sObjectList[i].previousMonthVol != 0 && sObjectList[i].previousMonthVol != undefined) || (sObjectList[i].previous2MonthVol != 0 && sObjectList[i].previous2MonthVol != undefined))
                    FliterList.push(sObjectList[i]);
                
                //PaginationList.push(sObjectList[i]);
                
            } 
            component.set('v.FliterList', FliterList);
            for(var i=0; i< pageSize; i++){
                if(FliterList.length> i)
                    PaginationList.push(FliterList[i]);
                
            }
            
            component.set("v.PaginationList", PaginationList);
            component.set("v.startPage",0);
            component.set("v.totalRecords", component.get("v.FliterList").length);
            component.set("v.TotalPages", Math.ceil(component.get("v.totalRecords") / pageSize));
            component.set("v.endPage",pageSize-1);//
            component.set("v.PageNumber",1);
        }
        if(!component.get("v.hideemptystock")){
            var pageNumber = component.get("v.PageNumber");
            var pageSize = component.get("v.pageSize");
            var FliterList = [];
            var PaginationList = [];
            var sObjectList = component.get("v.StockInChannelDetails");
            
            
            for(var i=0; i< sObjectList.length; i++)
                FliterList.push(sObjectList[i]);
            
            component.set('v.FliterList', FliterList);
            for(var i=0; i< pageSize; i++){
                if(FliterList.length> i)
                    PaginationList.push(FliterList[i]);
                
            }
            
            component.set("v.PaginationList", PaginationList);
            component.set("v.startPage",0);
            component.set("v.totalRecords", component.get("v.FliterList").length);
            component.set("v.TotalPages", Math.ceil(component.get("v.totalRecords") / pageSize));
            component.set("v.endPage",pageSize-1);//
            component.set("v.PageNumber",1);
        }
        
    },
})