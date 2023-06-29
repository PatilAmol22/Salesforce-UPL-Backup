({
     
   /* getDateCampaign :function(component,event,helper)
    {
        var CDate = component.get("v.today");
        var action = component.get("c.getCampaign");  
        
        action.setParams({
            "CDate": CDate
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log('state is '+ response.getState())
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                console.log('returned date data is '+JSON.stringify(response.getReturnValue()) );
                component.set("v.CampaignDetails", response.getReturnValue());
                component.set("v.startDate",component.get("v.CampaignDetails").Start_Date);
                component.set("v.endDate",component.get("v.CampaignDetails").End_Date);
                component.set("v.CurrentCampaign",component.get("v.CampaignDetails").Campaign);
                console.log("end date is"+component.get("v.endDate"));
                console.log("Start date is"+component.get("v.startDate"));
                console.log("campaign date is" +component.get("v.CurrentCampaign"));
                this.getSKUs(component,event,helper);
                
            }
            
        }
        )
        $A.enqueueAction(action);
        
    },*/
    
    getSKUs : function(component,event,helper) {
        var action = component.get("c.getallSKU");
        //var customerId= '0011y000005pXF1AAM';
        var customerId= component.get('v.recordId');
        component.set('v.customerId',customerId);
        var custID = component.get('v.customerId');
        var currentday = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        var changedDate = component.find("datePicker").get("v.value");
        if (custID == undefined)
        {
            console.log('reached here');
            custID= '0011y000005pXF1AAM';
            component.set('v.customerId',custID);
        }
        action.setParams({
            "CustomerID": custID,
            "Current_Date": component.get('v.today')
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            //console.log('state is '+ response.getState());
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                //console.log('value of date is '+resultData.BlockDate);
                component.set("v.ViewDate",resultData.BlockDate);
                //console.log('returned data is '+JSON.stringify(response.getReturnValue()));
                component.set("v.InventoryPOGDetails", resultData.InventoryPOGDetails);
                component.set("v.totalRecords", component.get("v.InventoryPOGDetails").length);
                if(currentday == changedDate)
                component.set("v.Columndisable",resultData.revokeAccess);
                //alert('value is'+component.get('v.Columndisable'));
                component.set("v.CustomerName",resultData.CustomerName);
                var sObjectList = component.get("v.InventoryPOGDetails");
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
            }
        })
        $A.enqueueAction(action);
        
    },
    
    helperUpdateQuantity : function(component, rowIndex, quantity){
        
        var pagination = component.get("v.PaginationList");
        var action = component.get("c.upsertInventoryPOGDetails");
        var SKUID = pagination[rowIndex].SKUID;
        var dateFilter = component.get("v.today");
        console.log('**dateFilter is - '+dateFilter);
        console.log('**Helper value of skuid is - '+SKUID);
        // Commented for RITM0255509
        /* var Quantity_Ordered_Last_Campaign = pagination[rowIndex].Quantity_Ordered;
       // var Quantity_Sold_Current_Campaign = pagination[rowIndex].Quantity_Sold_Current_Campaign;
       // var Quantity_Ordered_Last_Fiscal = pagination[rowIndex].Quantity_Sold_Last_Fiscal;
       // var Quantity_Ordered_Current_Campaign = pagination[rowIndex].Quantity_Sold_Current_Fiscal;
       // var Stock_pending_end_prev_product_campaign = pagination[rowIndex].Stock_pending_end_prev_product_campaign;      
		//console.log('**Helper value of Stock_pending_end_prev_product_campaign is - '+Stock_pending_end_prev_product_campaign);
        //alert(JSON.stringify(pagination[rowIndex]));
        //component.set('v.UpdatePOG',pagination[rowIndex].Quantity_Ordered);
        console.log('vvvvvv',component.get('v.UpdatePOG.Quantity_Ordered')); */
  
        action.setParams({
            "SKUId": SKUID,
            "quantity": quantity,
            "customerId": component.get("v.customerId"),
            "inputDate": dateFilter,
            /*"Quantity_Ordered_Last_Campaign":Quantity_Ordered_Last_Campaign,
            //"Quantity_Sold_Current_Campaign":Quantity_Sold_Current_Campaign,
            //"Quantity_Ordered_Last_Fiscal":Quantity_Ordered_Last_Fiscal,
            //"Quantity_Ordered_Current_Campaign":Quantity_Ordered_Current_Campaign,
            //"Stock_pending_end_prev_product_campaign":Stock_pending_end_prev_product_campaign,*/           
                   });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            //console.log('state is '+ state);
            var resultData = response.getReturnValue();
            if (state === "SUCCESS" && resultData=="false" ) {
          
                var error =$A.get("$Label.c.StockPendingPrev_Error");
                component.find('notifLib').showToast({
                        "variant": "error",
                        "message": error,
                    });
                }       
              //component.set("v.StockInChannelId",response.getReturnValue()); 
                    
            
        });
        
        $A.enqueueAction(action);        
        
        
        
    },
    
    // Commented for RITM0255509
    /* helperUpdateSAFLC : function(component, rowIndex, quantity){
        
        var pagination = component.get("v.PaginationList");
        var action = component.get("c.upsertInventoryPOGDetailsSAFLC");
        var SKUID = pagination[rowIndex].SKUID;
        var Quantity_Ordered_Last_Campaign = pagination[rowIndex].Quantity_Ordered;
        var Quantity_Sold_Current_Campaign = pagination[rowIndex].Quantity_Sold_Current_Campaign;
        var Quantity_Ordered_Last_Fiscal = pagination[rowIndex].Quantity_Sold_Last_Fiscal;
        var Quantity_Ordered_Current_Campaign = pagination[rowIndex].Quantity_Sold_Current_Fiscal; 
        var productCampaign= pagination[rowIndex].Product_Campaign;
        console.log('value of skuid is'+SKUID);
        action.setParams({
            "SKUId": SKUID,
            "quantity": quantity,
            "Quantity_Ordered_Last_Campaign":Quantity_Ordered_Last_Campaign,
            "Quantity_Sold_Current_Campaign":Quantity_Sold_Current_Campaign,
            "Quantity_Ordered_Last_Fiscal":Quantity_Ordered_Last_Fiscal,
            "Quantity_Ordered_Current_Campaign":Quantity_Ordered_Current_Campaign,
            "customerId": component.get("v.customerId"),
    
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            var resultData = response.getReturnValue();
            if (state === "SUCCESS" && resultData=="false" ) {
          
                var error =$A.get("$Label.c.POG_Campaign_Error");
                component.find('notifLib').showToast({
                        "variant": "error",
                        "message": error,
                    });
                }     
        });
        
        $A.enqueueAction(action);        
        
        
        
    },*/
    
    
    filterRecords : function(component){
        console.log('in filter');
        var sObjectList = component.get("v.InventoryPOGDetails");
       // alert('sObjectList' +JSON.stringify(sObjectList));
        //fetch selected Brand value
        //fetch description
        var description = component.find("enter-search").get("v.value"); 
        
        //description = description.toUpperCase();
        
        var skudescription;
        var pageNumber = component.get("v.PageNumber");
        var pageSize = component.get("v.pageSize");       
        var FliterList = [];
        var PaginationList = [];
        //brand and description is not null
        
        //brand != null and description is null
        
        //description is not null and brand == null 
       
        if(description){
            description = description.toUpperCase();
            //alert('something is happening'+description);
           // alert('sObjectList.length '+sObjectList.length);
            
            for(var i=0; i<sObjectList.length; i++){
               if(sObjectList[i].SKU_Name!=null) //Moumita[SCTASK0320550(RITM0147240)added null check]
               {
                //alert('sObjectList' +JSON.stringify(sObjectList));
                //alert('SKU_Name '+sObjectList[i].Product_Campaign);
             
                skudescription = sObjectList[i].SKU_Name;
                
                
                skudescription= skudescription.toUpperCase();
                
                if(skudescription){
                    if(skudescription.includes(description)>0)
                        FliterList.push(sObjectList[i]);
                }
               }//end
        } 
        }
        //Both description and brand null
        if(description==="" || description == undefined) {
            
            FliterList= component.get("v.InventoryPOGDetails");                
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
        if(FliterList.length==0)
        {
            console.log('reached reached');
            component.set("v.startPage",0);
            component.set("v.endPage",0);
            component.set("v.PageNumber",0);
            component.set("v.TotalPages",0);
        }
        
        
    },
   // Commented for RITM0255509
   /* helperUpdateStockPendingPrev : function(component, rowIndex, quantity){       
        var pagination = component.get("v.PaginationList");
        var action = component.get("c.updateStockPendingPrev");
        var SKUID = pagination[rowIndex].SKUID;
        var Stock_Pending_Last_Campaign = pagination[rowIndex].Stock_Pending_Last_Campaign;
        //var Quantity_Ordered_Last_Campaign = pagination[rowIndex].Quantity_Ordered;	
        console.log('**Helper value of skuid is - '+SKUID);
		console.log('**Helper value of Stock_Pending_Last_Campaign is - '+Stock_Pending_Last_Campaign);
		
        action.setParams({
            "SKUId": SKUID,
            "quantity": quantity,
            "Stock_Pending_Last_Campaign":Stock_Pending_Last_Campaign,
            //"Quantity_Ordered_Last_Campaign":Quantity_Ordered_Last_Campaign,
            "customerId": component.get("v.customerId"),
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log('state is '+ state);
            var resultData = response.getReturnValue();
            if (state === "SUCCESS" && resultData=="false" ) {
          
                var error =$A.get("$Label.c.POG_Campaign_Error");
                component.find('notifLib').showToast({
                        "variant": "error",
                        "message": error,
                    });
                }
        });
        
        $A.enqueueAction(action); 
    } */
             
})