({
    doInit : function(component, event, helper) {
    var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.CurrentDate', today);
        console.log('today is '+ today);
        component.set('v.today', today);
       /* var today = new Date();
        var currentyyyy = today.getFullYear();
        //var currentyy= currentyyyy.substring(2,2);
        var nextyyyy = today.getFullYear()+1; 
        console.log('**currentyyyy - '+ currentyyyy);
        console.log('**nextyyyy - '+ nextyyyy); 
        
        const options = {year: '2-digit'};
        const todayYr = new Date();
        var currentyy = todayYr.toLocaleDateString("en-US", options);
        component.set('v.CurrentYr',currentyy);
        var CurrentYr = component.get("v.CurrentYr");
        console.log('**today CurrentYr year - ' +CurrentYr);
        

        const lastYear = new Date(todayYr.getFullYear( )- 1, todayYr.getMonth(), todayYr.getDate());
        var lastyy = lastYear.toLocaleDateString("en-US", options);
        component.set('v.LastYr',lastyy);
        var LastYr = component.get("v.LastYr");
        console.log('**today LastYy year - ' +LastYr);
        
        const last2Year = new Date(todayYr.getFullYear( )- 2, todayYr.getMonth(), todayYr.getDate());
        var last2yy = last2Year.toLocaleDateString("en-US", options);
        component.set('v.LastYr2',last2yy);
        var LastYr2 = component.get("v.LastYr2");
        console.log('**today last2yy year - ' +LastYr2); */
        
        
    	helper.getSKUs(component,event,helper);
	},
    
    onChangePageSize: function(component, event, helper) {
        console.log('reached 121212');
        component.set("v.showSpinner",true);
        console.log(component.find("PageSize").get("v.value"));
        component.set("v.pageSize",parseInt(component.find("PageSize").get("v.value")));
        helper.getSKUs(component,event,helper);
         /*var sObjectList = component.get("v.InventoryPOGDetails");
                var pageSize = component.get("v.pageSize");
        
                // set star as 0
                component.set("v.startPage",0);//changed to 1
                component.set("v.PageNumber",1);
                component.set("v.endPage",pageSize-1);
                var PaginationList = [];
                for(var i=0; i< pageSize; i++){
                    if(component.get("v.InventoryPOGDetails").length> i)
                        PaginationList.push(sObjectList[i]);
                    component.set('v.PaginationList', PaginationList);
                }
                
                component.set("v.TotalPages", Math.ceil(component.get("v.totalRecords") / pageSize));
    			component.set("v.showSpinner",false);
   */ },
    onChangeDate : function(component, event, helper)
    {
        var currentday = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        var changedDate = component.find("datePicker").get("v.value");
        
        if(!(currentday == changedDate))
            {
             component.set('v.today',changedDate); 
             helper.getSKUs(component,event,helper);
             component.set('v.Columndisable',true);                        
            }
        else
        {
            component.set('v.Columndisable',false);
            component.set('v.today',currentday);
            helper.getSKUs(component,event,helper);
        }
        
        
        
    },
    
    handleSearchSKUDescription: function(component, event, helper) {
        
        var timer = setTimeout(function(){
            helper.filterRecords(component);           
        },500);
        
    },
    
    handleShowSpinner: function(component, event, helper) {
        
        //console.log('show spinner');
        component.set("v.showSpinner", true); 
    },
     
    //Call by aura:doneWaiting event 
    handleHideSpinner : function(component,event,helper){
        //console.log('show spinner demo');
        component.set("v.showSpinner", false);
    },
    
     handleNext: function(component, event, helper) {
        
        if(component.get("v.FliterList").length>0)
            var sObjectList = component.get("v.FliterList");
        else
            var sObjectList = component.get("v.InventoryPOGDetails");    
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
            var sObjectList = component.get("v.InventoryPOGDetails");
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
    
    UpdateQuantity: function(component, event, helper) {
        
       var pagination = component.get("v.PaginationList");
       var target = event.target;
       var rowIndex = event.getSource().get('v.label');
       var value = event.getSource().get('v.value');
       var productCampaign= pagination[rowIndex].Product_Campaign; 
        //console.log('value of target is '+ target);
        //console.log('value of rowindex is '+ rowIndex);
        //console.log('value of value is '+ value);
        
        if(value !== undefined){
        ///currentMonthinEnglish
        
        //last Month
        //Last last Month
        var quantity = value;
        
        if(quantity.length==0)
            quantity = 0; 
        
        helper.helperUpdateQuantity(component, rowIndex, quantity);
        
        if(component.get("v.FliterList").length>0)
            var sObjectList = component.get("v.FliterList");
        else
            var sObjectList = component.get("v.InventoryPOGDetails");
        
        const index = sObjectList.indexOf(pagination[rowIndex]);
        
        
        sObjectList[index].Stock_Pending_Last_Campaign = quantity;
        //added after error handling
        if (productCampaign == undefined)
            sObjectList[index].Stock_Pending_Last_Campaign=0;        
            var marketload =  sObjectList[index].Marketing_Load;
        sObjectList[index].Marketing_Load= parseInt(sObjectList[index].Stock_at_Farm_Last_Campaign)+parseInt(sObjectList[index].Stock_Pending_Last_Campaign);
            //added after error handling 
        component.set("v.PaginationList",pagination);
        }
    },
    
    // Commented for RITM0255509
  /*  UpdateSAFLC: function(component, event, helper) {
        
       var pagination = component.get("v.PaginationList");
       var target = event.target;
       var rowIndex = event.getSource().get('v.label');
       var value = event.getSource().get('v.value');
       //added after error handling
       var productCampaign= pagination[rowIndex].Product_Campaign;
       //
        console.log('value of target is '+ target);
        console.log('value of rowindex is '+ rowIndex);
        console.log('value of value is '+ value);
        
        if(value !== undefined){
        ///currentMonthinEnglish
        
        //last Month
        //Last last Month
        var quantity = value;
        
        if(quantity.length==0)
            quantity = 0; 
        
        helper.helperUpdateSAFLC(component, rowIndex, quantity);
        
        if(component.get("v.FliterList").length>0)
            var sObjectList = component.get("v.FliterList");
        else
            var sObjectList = component.get("v.InventoryPOGDetails");
        
        const index = sObjectList.indexOf(pagination[rowIndex]);
        
        sObjectList[index].Stock_at_Farm_Last_Campaign = quantity;
        //added after error handling
        if (productCampaign == undefined)
            sObjectList[index].Stock_at_Farm_Last_Campaign=0;
        var marketload =  sObjectList[index].Marketing_Load;
        sObjectList[index].Marketing_Load= parseInt(sObjectList[index].Stock_at_Farm_Last_Campaign)+parseInt(sObjectList[index].Stock_Pending_Last_Campaign);     
        
            //ends
            component.set("v.PaginationList",pagination);
        }
    },
    
    UpdateStockPendingPrev: function(component, event, helper) {
       var pagination = component.get("v.PaginationList");
       var target = event.target;
       var rowIndex = event.getSource().get('v.label');
       var value = event.getSource().get('v.value');
       var productCampaign= pagination[rowIndex].Product_Campaign; 

        console.log('**value of target is '+ target);
        console.log('**value of rowindex is '+ rowIndex);
        
        if(value !== undefined){
        console.log('**value of value is '+ value);
        var quantity = value;
        
        if(quantity.length==0)
            quantity = 0; 
			
        
        helper.helperUpdateStockPendingPrev(component, rowIndex, quantity);
        
        if(component.get("v.FliterList").length>0)
            var sObjectList = component.get("v.FliterList");
        else
            var sObjectList = component.get("v.InventoryPOGDetails");
        
        const index = sObjectList.indexOf(pagination[rowIndex]);
        
        
        sObjectList[index].Stock_pending_end_prev_product_campaign = quantity;
        //added after error handling
        if (productCampaign == undefined)
            sObjectList[index].Stock_pending_end_prev_product_campaign=0;        
        component.set("v.PaginationList",pagination);
        }
    } */
})