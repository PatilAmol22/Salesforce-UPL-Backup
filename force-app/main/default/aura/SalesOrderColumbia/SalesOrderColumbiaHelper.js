({
    
     MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
    //Logic to get all Account's/Sales order's Data.
    getOrderFields : function(component, event) {
        // show spinner to true on click of a button / onload
        //component.set("v.showSpinner", true);
        var action = component.get("c.getOrderFields");
        var accId = component.get("v.recordId");
        
        if(accId!=null){
            action.setParams({
                accId: accId
            });
        }
        //console.log('accId'+accId);
        var opts=[];   
        action.setCallback(this, function(a) {
            
            // on call back make it false ,spinner stops after data is retrieved
            component.set("v.showSpinner", false); 
            // console.log('returnValue: '+JSON.stringify(returnValue));
            var state = a.getState();
            
            if (state == "SUCCESS") {
                var returnValue = a.getReturnValue();
                component.set("v.orderFields",returnValue);
                // console.log('returnValue: '+JSON.stringify(returnValue));
                 var ShippingLocMap = returnValue.ShippingLocMap;
                 var DistributorData = returnValue.DistributorData;
                console.log('DistributorData------>'+DistributorData);
                 var businessTypesList = returnValue.businessTypesList;
                component.set("v.OrderTypes",returnValue.orderTypeList);
                console.log(returnValue.orderTypeList+'OrderType>>--->'+component.get("v.OrderTypes"));
                component.set("v.paymentTerm", DistributorData.paymentTerms);
                component.set("v.newSalesOrder.Payment_Term__c", DistributorData.paymentTermId);
                component.set("v.adminMPTParam", returnValue.adminParam);
                component.set("v.newSalesOrder.Sold_to_Party__c", component.get("v.recordId"));
                component.set("v.newSalesOrder.Bill_To_Party__c", component.get("v.recordId"));
                component.set("v.newSalesOrder.Distribution_Channel_lk__c",DistributorData.distributorChannelId);
                component.set("v.newSalesOrder.Sales_Org_lk__c",DistributorData.salesOrgId);
                component.set("v.newSalesOrder.OwnerId", returnValue.userObj.Id);
                component.set("v.newSalesOrder.Division_lk__c", returnValue.DistributorData.divisionId);
                component.set("v.user",returnValue.userObj);
                //console.log('inventory===>'+returnValue.userObj.Show_Inventory_Column__c);
                component.set("v.userId",returnValue.userObj.Id);
        /* ------------------Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ----------*/
                component.set("v.isPODateReq", returnValue.isPORequired);
                component.set("v.isDeliveryDateReq", returnValue.isDeliveryRequired);
                component.set("v.showPODate", returnValue.showPODate);
                component.set("v.showDeliveryDate", returnValue.showDeliveryDate);
        /* ------------------End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022-------------- */        
                if(DistributorData.priceGroupId!=null && DistributorData.priceGroupId!=''){
                    component.set("v.pgCode", DistributorData.priceGroupId);
                }
                 if(DistributorData.PriceGroupCodes!=null && DistributorData.PriceGroupCodes!=''){
                     //Setting pgCodes values by Ishu for ticket RITM0496802
                    component.set("v.pgCodes", DistributorData.PriceGroupCodes);
                }
                
                var profileName = component.get("v.user.Profile.Name");
                //disable if logged in User is PC/RC
                if(profileName!= 'Key Account Manager Colombia' && profileName!= 'RC (Commercial Representative) NUCO Colombia' && profileName!= 'PC (Commercial Promoters) NUCO Colombia'){
                    component.set("v.showDiscMargin",true);
                }
                //added by vaishnavi
                if(returnValue.userObj.Profile.Name=='Customer Partner Community Plus User - Colombia' ){
                    
                    //accId = JSON.stringify(a.getReturnValue().DistributorData.accountIds);
                    
                    //component.set("v.profileNameforCommu",returnValue.userObj.Profile.Name);
                    
                    component.set("v.isCommunityUser",true); 
                    if(component.get("v.isCommunityUser")){
                        component.find("OrderTypeOptions").set("v.errors",null);                    
                        $A.util.removeClass(component.find("OrderTypeOptions"), "error");
                        component.set("v.newSalesOrder.Order_Type_Colombia__c",'Normal Order');
                    }
                }
               // component.set("v.showDiscMargin",true);
         		// component.set("v.showDiscMargin",true);
                //Shipping location Map
                    opts=[];
                    opts.push({"class": "optionClass", label: $A.get("$Label.c.None"), value: 'None'});  
                console.log('shipping location :'+JSON.stringify(ShippingLocMap));  
                for (var key in ShippingLocMap){
                    //opts.push({"class": "optionClass", label: key, value: key});
                    
                    //Sayan start: RITM0129839
                    console.log('Shipping Location Ids--->'+key);
                    console.log('shipping location inside for:'+JSON.stringify(ShippingLocMap[key]));
                    var shippingname;
                    var shippingcity;
                    var salesRep;
                    if(ShippingLocMap[key].Location_Name__c != undefined || ShippingLocMap[key].Location_Name__c != null){
                        shippingname = ShippingLocMap[key].Location_Name__c;
                    }else{
                        shippingname = '<Blank Name>';
                    }
                    if(ShippingLocMap[key].City__c != undefined || ShippingLocMap[key].City__c != null){
                        shippingcity = ShippingLocMap[key].City__c;
                    }else{
                        shippingcity = '<Blank City>';
                    }
                    //Added by Nandhini
                    if(ShippingLocMap[key].Sort1__c != undefined || ShippingLocMap[key].Sort1__c != null){
                        salesRep = ' - '+ShippingLocMap[key].Sort1__c;
                    }
                    else{
                        salesRep='';
                    }
                    if(returnValue.userObj.Profile.Name=='Customer Partner Community Plus User - Colombia' ){
                        if(salesRep != ''){
                            var newShippingOption = shippingname+' - '+shippingcity+' ('+ShippingLocMap[key].SAP_Code__c+')' +salesRep;//Modified by Nandhini
                            opts.push({"class": "optionClass", label: newShippingOption, value: key});
                        }
                    }
                    else{
                        var newShippingOption = shippingname+' - '+shippingcity+' ('+ShippingLocMap[key].SAP_Code__c+')';//Modified by Nandhini
                        opts.push({"class": "optionClass", label: newShippingOption, value: key});
                    }
                    //Sayan end
                    }              
                    component.set("v.ShippingLocMap", ShippingLocMap);
                    component.find("shippListOptions").set("v.options", opts);  
                
                // businessTypes
                    opts=[]; 
                    component.set("v.businessTypesList", businessTypesList);
                    component.set("v.businessTypesListCopy", businessTypesList);   
                   
                 this.reloadSO(component);
                 this.fetchSKUData(component,event); 
            }
            else{
                var toastMsg = "Error While placing Order Please Contact System Administrator";
                this.showErrorToast(component, event, toastMsg);  
            }
        });
        $A.enqueueAction(action);
    },
    
    
    //To get SO Id if we Open comp. through "VIEW" button of SO detail page
    //If Comp. is open through "place Order Colombia" then this method will not success.
    getSOSTP:function(component){
        component.set("v.showSpinner", true);
        var soId = component.get("v.recordId");
        var action = component.get("c.getSalesSTP");
       
        console.log('soId'+soId);
        action.setParams({
            soId: soId
        });
        action.setCallback(this, function(a) {
            // component.set("v.showSpinner", false);
            var state = a.getState();
            if(state == "SUCCESS") {
                component.set("v.sOId",soId);
                console.log(component.get("v.recordId"));
                component.set("v.recordId",a.getReturnValue().Sold_to_Party__c);
                console.log(component.get("v.recordId"));
            }else{
                console.log('stp not found'+state);
            }
        });
        $A.enqueueAction(action);
    },
    
    
    // Method use to enable OrderForm for Editing purpose.
    editForm:function(component,event){
        component.set("v.disableThis", false);
        component.set("v.disableShipping", true);//Added by Nandhini
        
        component.set("v.disableEdit", true);
        component.set("v.headerMsg", $A.get("$Label.c.Edit_Order"));
          var OrderType = component.get("v.newSalesOrder.Order_Type_Colombia__c");
          var getProductId;  
          // added by vaishnavi.
        
          var salesOrder = component.get("v.newSalesOrder");
          var ownerId = salesOrder.OwnerId;
          var userId = component.get("v.userId");
          
        if(OrderType == 'MPT Order'){
           getProductId = component.find("itemproduct");
        }else{
           getProductId = component.find("normalitemproduct"); 
        }
          var isProductArray = Array.isArray(getProductId);
          var orderItemList = component.get("v.orderItemList");
        
        if(component.get("v.sObjectName") == 'Sales_Order__c' && ((salesOrder.Order_Status__c == 'Pending' && salesOrder.Need_Community_Approval__c == true) || salesOrder.Order_Status__c=='Rejected') && (userId==ownerId)){
            component.set("v.disableEdit", false);
            component.find("OrderTypeOptions").set("v.disabled",false);
        }

        for (var idx=0; idx < orderItemList.length; idx++) {
            if(isProductArray){
            //component.find("itemunitvalue")[idx].set("v.disabled",false); 
                if(OrderType == 'MPT Order'){
                    if(orderItemList[idx].typeOfBusiness=='Impacto Producto' || orderItemList[idx].typeOfBusiness=='Impacto Negocio') {
                    // component.find("itemunitvalue")[idx].set("v.disabled",true);  
                        console.log('idx'+idx);
                    }
                    if(idx!=0){
                        component.find("deleteBtn")[idx].set("v.disabled",false); 
                    }
               }else{
                    component.find("normalitemunitvalue")[idx].set("v.disabled",false); 
                }
            }else{
                  if(OrderType == 'MPT Order'){
                    component.find("itemunitvalue").set("v.disabled",false);
                    component.find("businessTypeOptions").set("v.disabled",true);
                    component.find("deleteBtn").set("v.disabled",false);
                  }else{
                    if(salesOrder.Need_Community_Approval__c == true){
                        component.find("normalitemunitvalue").set("v.disabled",false); 
                    }
                    
                    component.find("normaldeleteBtn").set("v.disabled",false);    
                  }      
            }
        }
    },
    
    // 1. Method call to reload existing SO
    // 2. Called in getOrderFields() after all Fields are loaded.
    // 3. Uses recordId to fetch related data of a SO record.
    reloadSO: function(component){
         component.set("v.headerMsg", $A.get("$Label.c.Create_Order"));
         var action = component.get("c.getSalesOrder");
         var soId = component.get("v.sOId");
        console.log('soId'+soId);
         if(soId!=null && soId!=undefined){
            component.set("v.headerMsg", $A.get("$Label.c.VIEW_ORDER")); 
            
            action.setParams({
                soId: soId
            });
             
              action.setCallback(this, function(a) {
                var state = a.getState();
                if(state == "SUCCESS") {
                    var salesOrder = a.getReturnValue();
				   console.log('salesOrder'+JSON.stringify(a.getReturnValue()));    
                    component.set("v.newSalesOrder", salesOrder);
                    console.log('salesOrder: '+salesOrder.Sold_to_Party__r.Name);
                    component.set("v.sfdcOrderNo", salesOrder.Name);
                     component.set("v.totalSalesUSD", salesOrder.Total_Sales_USD__c);
                     
                    var orderStatus = salesOrder.Order_Status__c;
                   
                    if(orderStatus == 'Error from SAP'){
                        component.set("v.sapOrderNo", $A.get("$Label.c.Order_not_pushed_to_SAP"));
                    }
                    else{
                        component.set("v.sapOrderNo", salesOrder.SAP_Order_Number__c);
                    }
                     component.set("v.paymentTerm", salesOrder.Payment_Term__r.Payment_Term__c);
                     component.set("v.totalSales", salesOrder.Net_Amount__c);//   
                   
                     component.set("v.grossProfit", salesOrder.Gross_Profit_colombia__c);
                     component.set("v.grossMargin", salesOrder.Gross_Margin_Colombia__c);
                     component.set("v.businessImpact", salesOrder.Business_Impact_Per_colombia__c);
                     component.set("v.totalDisc", salesOrder.Total_Discount_Per_Colombia__c);
                     component.find("OrderTypeOptions").set("v.disabled",true);
                   
                    if(salesOrder.Attachments!=null){
                        component.set("v.noFileError",true);
                        component.set("v.fileName",salesOrder.Attachments[0]['Name']);
                    }
                    var ShippingLocMap = component.get("v.ShippingLocMap");
                   //Added by Nandhini
                    console.log('shipping loc inside reload :'+JSON.stringify(ShippingLocMap));
                    for (var key in ShippingLocMap){
                        console.log('Shipping Location Ids--->'+key);
                        console.log('shipping location inside for:'+JSON.stringify(ShippingLocMap[key]));
                        var shippingname;
                        var shippingcity;
                        var salesRep;
                        if(ShippingLocMap[key].Id == salesOrder.Ship_To_Party__c)
                        {
                            var newShippingOption =key;
                            component.set("v.selItem", ShippingLocMap[key]);//Added by Nandhini
                            //component.set("v.disableThis",false);
                        }
                     }   
                    console.log('newShippingOption :'+newShippingOption);
                    component.find("shippListOptions").set("v.value",newShippingOption);
                    
                    //component.set("v.shippingLoc",newShippingOption);//modified by Nandhini
                    
                    var slObj = ShippingLocMap[salesOrder.Ship_To_Party__r.City__c];
                    //component.set("v.selItem", slObj);//commented by Nandhini
                     
                    if(salesOrder.Gross_Margin_Colombia__c>salesOrder.Min_for_Profitable_in_result_by_margin__c){
                        component.set("v.resultByMargin","Profitable");
                    }else{
                        component.set("v.resultByMargin","Deficit");  
                    }
                  
                    if(orderStatus!='Rejected'){
                        if(!salesOrder.Sent_for_Manager_Approval_Mexico__c && !salesOrder.Sent_for_Director_Approval_Mexico__c && !salesOrder.Sent_for_Latam_Director_Approval__c ){
                            component.set("v.resultByPrice","Approved");  
                        }else{
                            component.set("v.resultByPrice","Requires Authorization");  
                        }
                    }
                    
                    var user = component.get("v.user");
                    var ownerId = salesOrder.OwnerId;
                    var userId = component.get("v.userId");
                    var profileName = component.get("v.orderFields.userObj.Profile.Name");
                    
                    //Add all button logic here
                    //if logged in user is owner of record and order is disabled 
                    if(orderStatus == 'Rejected' && (userId==ownerId)){
                        component.set("v.disableEdit", false);
                    }
                    if(orderStatus == 'Open' && (profileName!= 'PC (Commercial Promoters) NUCO Colombia' && profileName!='RC (Commercial Representative) NUCO Colombia')){
                        component.set("v.showPrint",true);
                   }
                   if(component.get("v.sObjectName") == 'Sales_Order__c' && ((orderStatus == 'Pending' && salesOrder.Need_Community_Approval__c == true) || orderStatus=='Rejected') && (userId==ownerId)){
                        component.set("v.disableEdit", false);
                        component.find("OrderTypeOptions").set("v.disabled",false);
                   }
                    
                    // Logic for RC/PC 
                    if(salesOrder.Order_Status__c == "Draft" && (userId==ownerId)){
                        console.log('profileName'+profileName);
                        if(profileName== 'PC (Commercial Promoters) NUCO Colombia' || profileName=='RC (Commercial Representative) NUCO Colombia'){
                            component.set("v.showSaveDraft", true); 
                            component.set("v.disableEdit", false);
                        }else{
                            component.set("v.showSaveDraft", false); 
                             component.set("v.disableEdit", true);
                        }
                    }
                    
                    //Disable Fields by default on reload
                    component.set("v.disableThis", true);
                    component.set("v.disableShipping", true);//Added by Nandhini
                    component.set("v.showOnReLoad", true);
                    component.set("v.showRaiseOrder", false);
                 
                   this.fetchApprovalHistory(component, soId, userId);
                }else{
                    var toastMsg = $A.get("$Label.c.Error_while_reloading_SO");
                    this.showErrorToast(component, event, toastMsg);
                }
               });
            $A.enqueueAction(action);
           this.reloadSOItems(component);   
           this.fetchSKUData(component,event); 
         }else{
             console.log('so id not found');
         }
    },
    
    
    // Method call to reload Order Items
    // Gets all Order Line Items against the current Sales Order record
    reloadSOItems: function(component){
        var action = component.get("c.getSalesOrderItems");
        if(component.get("v.sOId")!=null){
            action.setParams({
                soId: component.get("v.sOId")
            });
            
            action.setCallback(this, function(a) {
                var state = a.getState();
                if(state == "SUCCESS") {
                    component.set("v.orderItemList", a.getReturnValue());
                    var orderItemList = component.get("v.orderItemList");
                    console.log('orderItems: '+a.getReturnValue()[0].unitValue);
                }
                else{
                    var toastMsg = $A.get("$Label.c.Error_while_reloading_Order_Items");
                    this.showErrorToast(component, event, toastMsg);                      
                }
                this.disabledOnReload(component);
            });
            $A.enqueueAction(action);
        }
    }, 
    
    
    //Logic to get all price book master Data with respect to their pg code/sold to party.
    fetchSKUData : function(component, event) {
        var action;
        var priceDetailTableColumns;  
      // component.set("v.showSpinner", true);
        
         action = component.get("c.getSkuData");
            //Column data for the table
            priceDetailTableColumns = [
                {
                    'label': $A.get("$Label.c.Product_Code"),
                    'name':'skuCode',
                    'type':'string',
                    'resizeable':true
                },
                {
                    'label': $A.get("$Label.c.Name"),
                    'name':'skuDescription',
                    'type':'string',              
                    'resizeable':true
                },
                //Added Column on Product Selection Screen by Ishu Mittal for RITM0496802
                 {
                    'label': $A.get("$Label.c.Channel_Description"),
                    'name':'PriceGroupDescription',
                    'type':'string',              
                    'resizeable':true
                }
                /*,
                 {
                    'label':"Category",
                    'name':'skuCategory',
                    'type':'string',              
                    'resizeable':true
                }*/
                ];            
            
        //Configuration data for the table to enable actions in the table
        var priceDetailTableConfig = {
            "massSelect":false,
            "globalAction":[],
            "searchByColumn":true,
            "rowAction":[
                {
                    "label": $A.get("$Label.c.Select"),
                    "type":"url",
                    "id":"selectproduct"
                }
            ]
            
        };
        
        var pgCode = component.get("v.pgCode");
        var pgCodes = component.get("v.pgCodes");
        var accId =  component.get("v.recordId");
        console.log('pgCode-: '+pgCode);
        console.log('accId:- '+accId);
         //Added pgCodes parameter by Ishu Mittal for ticket RITM0496802
        action.setParams({ 
            "accId": accId,
            "pgCode": pgCode,
            "pgCodes":pgCodes
        });  
        
        action.setCallback(this, function(a) {
       		component.set("v.showSpinner", false); 
    	    var state = a.getState();
            console.log('returnValue: '+JSON.stringify(a.getReturnValue()));
            if (state == "SUCCESS") {
              component.set("v.priceDetailList",a.getReturnValue());
               	    //pass the column information
                    component.set("v.priceDetailTableColumns",priceDetailTableColumns);
                    //pass the configuration of task table
                    component.set("v.priceDetailTableConfig",priceDetailTableConfig);
                    //initialize the datatable
                    component.find("priceDetailsTable").initialize({
                        "order":[0,"desc"],
                        "itemMenu":["5","10","25","50"],
                        "itemsPerPage:":5                    
                    });
                }
                else{
                    //console.log(resp.getError());
                }           
            });
        
        $A.enqueueAction(action);
    },
    
    //Updating row when Qty and Final price changes.
     updateRowCalculations : function(component, event, helper){
        var rowIndex = component.get("v.rowIndex");
        var orderItemList = component.get("v.orderItemList");
        var totalSales = 0;
        var grossProfit = 0;
        var grossMargin = 0;
        var totalDisc = 0;
        var totalD = 0;
        var SumDiscount=0;
        var businessImpact =0;
        var MTPadmin = component.get("v.adminMPTParam");
        var authrizationFlag =false;
        var adjustedPer = MTPadmin.of_adjustment_to_display_vendor_utility__c/100;
        var initialPosition =rowIndex;
        var currentIndex  = rowIndex;
        
        console.log('rowIndex'+rowIndex);
         var isvalidQty = true;
        for (var idx = 0; idx < orderItemList.length; idx++) {
            var flag = true;
            if(!orderItemList[idx].qty) {
                flag = false;
            }
           /*if( orderItemList[0].typeOfBusiness!="Initial Product" ) {
                flag = false;
            }else{
                component.find("businessTypeOptions").set("v.disabled",true);
                orderItemList[0].typeOfBusiness = "Initial Product";
                 component.set("v.orderItemList",orderItemList);
            }*/
            if(!orderItemList[idx].productId==false){
                if(flag){
                    //Logic to restrict negative value
                    //console.log('orderItemList[idx].productId'+orderItemList[idx].productId);
                    var qty2 = orderItemList[idx].qty.toString(); //Convert to string
                    console.log('qty2>>--->'+qty2);
                    orderItemList[idx].qty = parseFloat(qty2.replace("-", "")); //Replace negative sign
                    
                    //var value2 = orderItemList[idx].unitValue.toString(); //Convert to string
                    //orderItemList[idx].unitValue = parseFloat(value2.replace("-", "")); //Replace negative sign
                    //End of logic 
                    if(orderItemList[idx].typeOfBusiness=="Producto Inicial"){
                        //console.log('netsales'+orderItemList[idx].netSales+'qty'+orderItemList[idx].qty+'unit cost'+orderItemList[idx].unitCost);
                        orderItemList[idx].netSales = orderItemList[idx].qty*orderItemList[idx].unitValue;   //DIVYA: 16-01-2020: replaced orderItemList[idx].maxPrice with orderItemList[idx].unitValue for SCTASK0102624-Colombia MPT Order Final Price Change
                    	orderItemList[idx].profit = adjustedPer*(orderItemList[idx].netSales-(orderItemList[idx].qty*orderItemList[idx].unitCost));
                    //console.log('orderItemList[idx].profit'+orderItemList[idx].profit);
                        
                        
                    }
                    else{
                        //console.log('netsales else  '+orderItemList[idx].netSales+'qty'+orderItemList[idx].qty+'unit cost'+orderItemList[idx].unitCost);
                       orderItemList[idx].netSales = 0;
                        
                       orderItemList[idx].profit = adjustedPer*(orderItemList[idx].netSales-(orderItemList[idx].qty*orderItemList[idx].unitCost)); 
                    }
                    
                   if(orderItemList[idx].typeOfBusiness=="Impacto Producto"){
                     orderItemList[idx].discount=orderItemList[idx].maxPrice*orderItemList[idx].qty; 
                     for (var idx1=idx; idx1 >=0; idx1--){
                            if(orderItemList[idx1].typeOfBusiness=='Producto Inicial'){
                               // console.log(orderItemList[idx1].typeOfBusiness);
                                initialPosition =idx1;
                                break;
                            }
                        }
                       console.log('initialPosition'+initialPosition);
                       var totalqty=orderItemList[initialPosition].qty;
                       var totalProfit =orderItemList[initialPosition].profit;
                       //console.log('orderItemList[initialPosition].profit'+orderItemList[initialPosition].profit);
                       var totalDiscount = 0;
                       //console.log('totalqty'+totalqty+'### '+totalProfit);
                       if(orderItemList[initialPosition+1].productId == orderItemList[initialPosition].productId){
                           for (var idx1=idx; idx1 >initialPosition; idx1--) {
                               totalqty= totalqty + orderItemList[idx1].qty ;
                               totalProfit =totalProfit+orderItemList[idx1].profit; 
                               //console.log('totalProfit 556 '+totalProfit+'orderItemList[idx1].profit'+orderItemList[idx1].profit);
                                var netPrice =  orderItemList[initialPosition].netSales/totalqty; 
                           console.log('netPrice'+netPrice);
                           if(netPrice  < orderItemList[initialPosition].minValue && isvalidQty ){
                                //errorMessage= $A.get("$Label.c.Please_enter_Quantity");
                              	  currentIndex = idx1;
            					 this.showErrorToast(component, event, $A.get("$Label.c.Quantity_not_allowed"));
                                 isvalidQty = false; 
                                 console.log('isvalidQty>>--->'+isvalidQty+'currentIndex>>--->'+currentIndex);
                           }else{
                           orderItemList[initialPosition].netPrice = netPrice;
                           orderItemList[initialPosition].netMargin =  (totalProfit/orderItemList[initialPosition].netSales)*100; 
                           orderItemList[idx].netMargin =0;
                           orderItemList[idx].netPrice =0;
                           orderItemList[initialPosition].discount_percent =  -[(orderItemList[initialPosition].netPrice/orderItemList[initialPosition].maxPrice)-1]*100;
                           } 
                           }
                           //console.log('orderItemList[initialPosition].netMargin'+orderItemList[initialPosition].netMargin+'oorderItemList[initialPosition].discount_percent'+orderItemList[initialPosition].discount_percent);
                           
                          
                       }else if(orderItemList[initialPosition+1].productId != orderItemList[initialPosition].productId){
                           for (var idx1=idx; idx1 >initialPosition; idx1--) {
                               //console.log('orderItemList[idx1]'+JSON.stringify(orderItemList[idx1]));
                               //console.log('orderItemList[idx1] ##3'+orderItemList[idx1].discount);
                               
                               totalDiscount = totalDiscount + orderItemList[idx1].discount ;
                               console.log('discount'+totalDiscount);
                               totalProfit =totalProfit+orderItemList[idx1].profit;
                               console.log('totalProfit'+totalProfit);
                                var netPrice =  (orderItemList[initialPosition].netSales-totalDiscount)/orderItemList[initialPosition].qty; 
                           //console.log('netPrice'+netPrice+'orderItemList[initialPosition].minValue'+orderItemList[initialPosition].minValue);
                           if(netPrice  < orderItemList[initialPosition].minValue && isvalidQty){
                               // errorMessage= $A.get("$Label.c.Please_enter_Quantity");
            					//component.find("itemqty")[idx].set("v.errors",[{message: $A.get("$Label.c.Quantity_not_allowed")}]);               
                        		//$A.util.addClass(component.find("itemqty")[idx], "error");
                                 this.showErrorToast(component, event, $A.get("$Label.c.Quantity_not_allowed"));
                                currentIndex = idx1;
                                 isvalidQty = false; 
                                 console.log('isvalidQty>>--->'+isvalidQty);
                           }else{
                            orderItemList[initialPosition].netPrice =  netPrice; 
                            orderItemList[initialPosition].netMargin =  (totalProfit/orderItemList[initialPosition].netSales)*100; 
                            //console.log('orderItemList[initialPosition].netMargin----->'+orderItemList[initialPosition].netMargin);
                               orderItemList[idx].netMargin =0;
                            orderItemList[idx].netPrice =0;
                            orderItemList[initialPosition].discount_percent =  -[(orderItemList[initialPosition].netPrice/orderItemList[initialPosition].maxPrice)-1]*100;
                          //console.log('totalDiscount'+totalDiscount+'orderItemList[initialPosition].netPrice'+orderItemList[initialPosition].netPrice);
                           }
                               
                           }
                           
                       }    
                       
                       if(orderItemList[initialPosition].netMargin<MTPadmin.Level_1_max__c){
                           authrizationFlag = true;
                     }
                  }
                   
                    if(orderItemList[idx].typeOfBusiness=="Impacto Negocio"){
                           orderItemList[idx].netPrice =0;
                           orderItemList[idx].discount_percent = 100;
                           orderItemList[idx].discount = orderItemList[idx].discount=orderItemList[idx].maxPrice*orderItemList[idx].qty;
                        //console.log(' orderItemList[idx].discount'+ orderItemList[idx].discount);   
                        SumDiscount += parseFloat(orderItemList[idx].discount);
                        console.log('SumDiscount'+SumDiscount);
                    }
                  
                   if(orderItemList[idx].typeOfBusiness=="Producto Inicial"){
                        orderItemList[idx].margin = (orderItemList[idx].profit/orderItemList[idx].netSales)*100;
                        orderItemList[idx].netMargin =  (orderItemList[idx].profit/orderItemList[idx].netSales)*100; 
                       //console.log('orderItemList[initialPosition].netMargin--------------'+orderItemList[idx].netMargin);
                       orderItemList[idx].netPrice =  orderItemList[idx].netSales/orderItemList[idx].qty;
                        orderItemList[idx].discount_percent =  -[(orderItemList[idx].netPrice/orderItemList[idx].maxPrice)-1]*100;//  [Net Sales - (Quantity * Unit Cost)]
                        orderItemList[idx].discount = 0;
                       
                        //if only one line item data then
                         if(orderItemList[idx].netMargin<MTPadmin.Level_1_max__c){
                           authrizationFlag = true;
                    }
                    }else{
                        orderItemList[idx].discount_percent = 100;
                        orderItemList[idx].margin =0;
                    }
                    console.log('MTPadmin'+MTPadmin.of_adjustment_to_display_vendor_utility__c);
                   // console.log('orderItemList[idx].unitCost'+orderItemList[idx].unitCost);
                   // console.log('orderItemList[initialPosition].discount_percent'+orderItemList[initialPosition].discount_percent);
                  
                    totalSales += parseFloat(orderItemList[idx].netSales);
                    console.log('totalSales'+totalSales+'grossProfit'+grossProfit);
                    console.log('grossProfit'+grossProfit);
                    grossProfit += parseFloat(orderItemList[idx].profit);//(Gross Profit / Total Sales ) *100
                   console.log('grossProfit'+grossProfit+'orderItemList[idx].profit'+orderItemList[idx].profit);
                    grossMargin = (grossProfit / totalSales ) *100;
                    totalD += parseFloat(orderItemList[idx].discount);
                    console.log('totalD--'+totalD+'totalSales--'+totalSales);
                    console.log('grossMargin'+grossMargin+'grossProfit'+grossProfit);
                    totalDisc = (totalD/totalSales)*100;
                    console.log('totalDisc'+totalDisc);
                    businessImpact  = (SumDiscount/totalSales)*100;
                }
            }
            else{
                //var toastMsg = $A.get("$Label.c.Select_Product_before_Entering_Price_Quantity");
                //this.showErrorToast(component, event, toastMsg);
                console.log('else');
                var getProductId = component.find("itemproduct");
                var isProductArray = Array.isArray(getProductId);
                
                if(isProductArray){
                    //Product validaiton
                    if(getProductId[idx].get("v.value") == null || getProductId[idx].get("v.value") == ''){
                        component.find("itemproduct")[idx].set("v.errors",[{message: $A.get("$Label.c.Product_is_required")}]);               
                        $A.util.addClass(component.find("itemproduct")[idx], "error");
                    }
                }
                else{
                    if(getProductId.get("v.value") == null || getProductId.get("v.value") == ''){
                        component.find("itemproduct").set("v.errors",[{message: $A.get("$Label.c.Product_is_required")}]);                
                        $A.util.addClass(component.find("itemproduct"), "error");
                    }
                }
            }
        }
         if(isvalidQty){
         component.set("v.orderItemList",orderItemList); 
          component.set("v.totalSales",totalSales);
          console.log('Rate>>-->'+component.get("v.adminMPTParam").USD_Conversion_Rate__c);
          var totalSalesUsd = (totalSales/component.get("v.adminMPTParam").USD_Conversion_Rate__c);
          component.set("v.totalSalesUSD",totalSalesUsd);
          component.set("v.grossMargin",grossMargin);
             if(isNaN(totalDisc)){
                 component.set("v.totalDisc",0.0);
             }else{
                  component.set("v.totalDisc",totalDisc);
             }
             console.log('business impact>>--->'+businessImpact);
           if(isNaN(businessImpact)){
                 component.set("v.businessImpact",0.0);
             }else{
                 component.set("v.businessImpact",businessImpact);
             }
          component.set("v.grossProfit",grossProfit); 
          //console.log(totalDisc+'<<<totalDisc>>>'+'businessImpact>>>'+businessImpact+'<<<grossProfit>>>'+grossProfit);
            if(grossMargin<MTPadmin.Level_1_max__c){
            authrizationFlag = true;
         }
          
         if(grossMargin>MTPadmin.Min_for_Profitable_in_result_by_margin__c){
             component.set("v.resultByMargin","Profitable");
         }else{
             component.set("v.resultByMargin","Deficit");  
         }
         if(orderItemList.length!=0){
             if(!authrizationFlag){ //&& orderItemList[0].unitValue!=0){
                // console.log('authrizationFlag'+authrizationFlag);
                 component.set("v.resultByPrice","Approved");  
             }else{
                 component.set("v.resultByPrice","Requires Authorization");  
             }
         } 
         }else{
			var items = component.get("v.orderItemList");    
			//items.splice(rowIndex, 1);   
			//component.get("v.currentIndex");
			items[component.get("v.currentIndex")].qty = 0;
            items[component.get("v.currentIndex")].netPrice =0;
            component.set("v.orderItemList",items); 
         } 
    },
    normalUpdateRowCalculations : function(component, event, helper){
        var rowIndex = component.get("v.rowIndex");
        var orderItemList = component.get("v.orderItemList");
        var totalSales = 0;
        var grossProfit = 0;
        var grossMargin = 0;
        var totalDisc = 0;
        var totalD = 0;
        var SumDiscount= 0;
        var businessImpact = 0;
        var MTPadmin = component.get("v.adminMPTParam");
        var authrizationFlag =false;
       
        var adjustedPer = MTPadmin.of_adjustment_to_display_vendor_utility__c/100;
        var initialPosition =rowIndex;
        console.log('rowIndex'+rowIndex+'adjustedPer'+adjustedPer);
               for (var idx = 0; idx < orderItemList.length; idx++) {
            console.log('isvalidFinal>>--->'+idx);
            console.log('orderItemList[idx].qty>>--->'+orderItemList[idx].qty*orderItemList[idx].unitValue);
                   var flag = true;
            if(!orderItemList[idx].qty) {
                flag = false;
                 
            }
            if(!orderItemList[idx].unitValue) {
                flag = false;
            }
           console.log(orderItemList[idx].unitValue +'-----------'+flag);
            if(!orderItemList[idx].productId==false){
                if(flag){
                    //Logic to restrict negative value
                    var qty2 = orderItemList[idx].qty.toString(); //Convert to string
                    orderItemList[idx].qty = parseFloat(qty2.replace("-", "")); //Replace negative sign
                    
                    var value2 = orderItemList[idx].unitValue.toString(); //Convert to string
                    orderItemList[idx].unitValue = parseFloat(value2.replace("-", "")); //Replace negative sign
                    //End of logic 
                    
                    orderItemList[idx].netSales = orderItemList[idx].qty*orderItemList[idx].unitValue;
					orderItemList[idx].discount_percent = (1-(orderItemList[idx].unitValue/orderItemList[idx].maxPrice))*100;
                    orderItemList[idx].discount= (orderItemList[idx].discount_percent/100)*(orderItemList[idx].maxPrice*orderItemList[idx].qty);
					orderItemList[idx].profit = adjustedPer*(orderItemList[idx].netSales-(orderItemList[idx].qty*orderItemList[idx].unitCost));
					orderItemList[idx].netMargin = (orderItemList[idx].profit/orderItemList[idx].netSales)*100;
                     if(orderItemList[idx].netMargin<MTPadmin.Level_1_max__c && !authrizationFlag){
                           authrizationFlag = true;
                    }
                    console.log('MTPadmin'+MTPadmin.of_adjustment_to_display_vendor_utility__c);
                    console.log('orderItemList[idx].unitCost'+orderItemList[idx].unitCost);
                  
                    totalSales += parseFloat(orderItemList[idx].netSales);
                    grossProfit += parseFloat(orderItemList[idx].profit);//(Gross Profit / Total Sales ) *100
                    grossMargin = (grossProfit / totalSales ) *100;
                    totalD += parseFloat(orderItemList[idx].discount);
                    console.log('totalD--'+totalD+'totalSales--'+totalSales);
                    totalDisc = (totalD/totalSales)*100;
                    businessImpact  = (SumDiscount/totalSales)*100;
                }else{
                  orderItemList[idx].netSales = 0;
					orderItemList[idx].discount_percent = 0;
                    orderItemList[idx].discount= 0;
					orderItemList[idx].profit = 0;
					orderItemList[idx].netMargin = 0; 
                }
            }
            else{
                //var toastMsg = $A.get("$Label.c.Select_Product_before_Entering_Price_Quantity");
                //this.showErrorToast(component, event, toastMsg);
                console.log('else');
                var getProductId = component.find("normalitemproduct");
                var isProductArray = Array.isArray(getProductId);
                
                if(isProductArray){
                    //Product validaiton
                    if(getProductId[idx].get("v.value") == null || getProductId[idx].get("v.value") == ''){
                        component.find("normalitemproduct")[idx].set("v.errors",[{message: $A.get("$Label.c.Product_is_required")}]);               
                        $A.util.addClass(component.find("normalitemproduct")[idx], "error");
                    }
                }
                else{
                    if(getProductId.get("v.value") == null || getProductId.get("v.value") == ''){
                        component.find("normalitemproduct").set("v.errors",[{message: $A.get("$Label.c.Product_is_required")}]);                
                        $A.util.addClass(component.find("normalitemproduct"), "error");
                    }
                }
            }
        }
		  console.log('totalSales'+totalSales+'---grossMargin---'+grossMargin+'---totalDisc---'+totalDisc);    
          component.set("v.orderItemList",orderItemList); 
          component.set("v.totalSales",totalSales);
        console.log('Rate>>-->'+component.get("v.adminMPTParam").USD_Conversion_Rate__c);
          var totalSalesUsd = (totalSales/component.get("v.adminMPTParam").USD_Conversion_Rate__c);
          component.set("v.totalSalesUSD",totalSalesUsd);
          console.log('conversion Rate >>--->');
                   component.set("v.grossMargin",grossMargin);
          component.set("v.totalDisc",totalDisc);
          component.set("v.businessImpact",businessImpact);
          component.set("v.grossProfit",grossProfit); 
         if(grossMargin<MTPadmin.Level_1_max__c){
             authrizationFlag = true;
         }
          
         if(grossMargin>MTPadmin.Min_for_Profitable_in_result_by_margin__c){
             component.set("v.resultByMargin","Profitable");
         }else{
             component.set("v.resultByMargin","Deficit");  
         }
         if(orderItemList.length!=0){
             if(!authrizationFlag && orderItemList[0].unitValue!=0){
                // console.log('authrizationFlag'+authrizationFlag);
                 component.set("v.resultByPrice","Approved");  
             }else{
                 component.set("v.resultByPrice","Requires Authorization");  
             }
         } 
    },
    
    validateShipping :function(component){
        var flag = true;
        var toastMsg = '';
        var shippListOptions = component.find("shippListOptions");
        if(shippListOptions){
            if(!shippListOptions.get("v.value") || shippListOptions.get("v.value") == 'None'){
                flag = false;
                component.find("shippListOptions").set("v.errors",[{message: $A.get("$Label.c.Please_Select_shipping_location")}]); 
                $A.util.addClass(shippListOptions, "error");
            }
        }
        return flag;  
    },
    
    
    //Logic to validate Order data
      validateOrder: function(component){
          var flag = true;
          var toastMsg = '';
          var OrderType = component.get("v.newSalesOrder.Order_Type_Colombia__c");
          var paymentTermId = component.find("paymentTermId");
          var creditLimitId = component.find("creditLimitId");
          // var shippListOptions = component.find("shippListOptions");
    /*--------------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 -----------------*/
          
          var poSkip = component.get("v.skipPO");
          var showPOD = component.get("v.showPODate");
          var reqPOD = component.get("v.isPODateReq");
          
          var crDt = new Date();
          var today = new Date(crDt.getTime() + 86400000); // for current date + 1 ...
          var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
          var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
          var yyyy = today.getFullYear();
          var currentDate = (yyyy + "-" + MM + "-" + dd);
          var y = new Date(currentDate);
    /* -----------------End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022--------------------- */    
          if(OrderType =='{}' || OrderType =='None'){
              flag = false; 
                  component.find("OrderTypeOptions").set("v.errors",[{message: $A.get("$Label.c.Please_select_order_type")}]);                    
                  //$A.util.addClass(component.find("OrderTypeOptions"), "error");
          }
          if(paymentTermId){
              if(!paymentTermId.get("v.value")) {
                  flag = false;
                  component.find("paymentTermId").set("v.errors",[{message: $A.get("$Label.c.Payment_Term_is_not_available")}]);                    
                  $A.util.addClass(paymentTermId, "error");
              }
          }
    /*-----------------------Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022---------------  */
          if(showPOD == true && poSkip == false){
            //var poDate = component.find("po_date");
            var poDateVal = component.get("v.isCommunityUser") == true? new Date(): component.get("v.newSalesOrder.Purchase_Order_Date__c");
            component.set("v.newSalesOrder.Purchase_Order_Date__c",poDateVal);
            var w = new Date(poDateVal);
            if(reqPOD == true && poDateVal == null){
                flag = false;
                component.find("po_date").focus();
                component.find("po_date").set("v.value",null);
                var toastEvent1 = $A.get("e.force:showToast");
                  var titl  = $A.get("{!$Label.c.Error}");
                  toastEvent1.setParams({
                      "title": titl,
                      "type": "Error",
                      "message": $A.get("$Label.c.Purchase_Order_date_is_required")
                      //"duration":'3000'
                  });
                  toastEvent1.fire();
            }
            /* else if(poDateVal != null && +w < +y){  // commented this validation on client request....
                flag = false;
                component.find("po_date").focus();
                component.find("po_date").set("v.value",'');
                var toastEvent1 = $A.get("e.force:showToast");
                  var titl  = $A.get("{!$Label.c.Error}");
                  toastEvent1.setParams({
                      "title": titl,
                      "type": "Error",
                      "message": $A.get("$Label.c.PO_Date_should_not_be_less_than_todays_date")
                      //"duration":'3000'
                  });
                  toastEvent1.fire();
                
            } */
            else if(poDateVal == null){
                component.set("v.newSalesOrder.Purchase_Order_Date__c",null);
            }
        }
        else{
            component.set("v.newSalesOrder.Purchase_Order_Date__c",null);
        }
    /* ------------------------End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022-------------- */    
         /* if(creditLimitId){
              if(!creditLimitId.get("v.value")) {
                  flag = false;
                  component.find("creditLimitId").set("v.errors",[{message: $A.get("$Label.c.Credit_Information_for_Distributor_not_found")}]);                    
                  $A.util.addClass(creditLimitId, "error");
              }
          }*/
          /* if(shippListOptions){
             if(!shippListOptions.get("v.value") || shippListOptions.get("v.value") == 'None'){
                flag = false;
                component.find("shippListOptions").set("v.errors",[{message:"Please Select Shipping Location "}]); 
                $A.util.addClass(shippListOptions, "error");
            }
           }*/
           return flag;  
      },
    
    
    //Validate Order Items
    validateOrderItems: function(component){
        //try{
            var OrderType = component.get("v.newSalesOrder.Order_Type_Colombia__c");
            var orderItemList = component.get("v.orderItemList");
        /* -------------------Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022-------------- */    
            var crDt = new Date();
            var today = new Date(crDt.getTime() + 86400000); // for current date + 1 ...
            var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
            var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
            var yyyy = today.getFullYear();
            var currentDate = (yyyy + "-" + MM + "-" + dd); 
            var y = new Date(currentDate);
            var showDel = component.get("v.showDeliveryDate");
            var reqDel = component.get("v.isDeliveryDateReq");
            var flag2 = false;
            var errMsg = '';
        /* ----------------End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022----------------- */
            if(OrderType =='MPT Order'){
                var getProductId = component.find("itemproduct");
                var getQtyId = component.find("itemqty");
                var del_Date = component.find("delivery_date");   // SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022...
                var getFinalPrice = component.find("itemunitvalue"); //DIVYA
                    var toastMsg = '';
                var flag = true;
                if(orderItemList.length <= 0){
                    flag = false;
                }
                else if(orderItemList.length > 0){
                    var isProductArray = Array.isArray(getProductId);
                    
                    if(isProductArray){
                        for(var i = 0; i <orderItemList.length; i++){
                            //Product validaiton
                            if(!getProductId[i].get("v.value")) {
                                component.find("itemproduct")[i].set("v.errors",[{message: $A.get("$Label.c.Product_is_required")}]);               
                                flag = false;
                            }
                            else{
                                component.find("itemproduct")[i].set("v.errors",null);           
                            }
                        //DIVYA uncommented from line no 771 to 780 to put Final Price Validation
                                // Unit Value validaiton
                                
                                if((!getFinalPrice[i].get("v.value") || getFinalPrice[i].get("v.value") == '0')&&(orderItemList[i].typeOfBusiness=="Initial Product" || orderItemList[i].typeOfBusiness=="Producto Inicial")){
                                    console.log("inside Final Price"+getFinalPrice);
                                    component.find("itemunitvalue")[i].set("v.errors",[{message: $A.get("$Label.c.Please_enter_Final_Price")}]);
                                    flag = false;
                                }
                                else{
                                    component.find("itemunitvalue")[i].set("v.errors",null); 
                                }
                            
                            
                            // Quantity validaiton
                            if(!getQtyId[i].get("v.value") || getQtyId[i].get("v.value") == '0') {
                                component.find("itemqty")[i].set("v.errors",[{message: $A.get("$Label.c.Please_enter_Quantity")}]);;
                                flag = false;
                            }
                            else{
                                component.find("itemqty")[i].set("v.errors",null); 
                            }
                        /* ----------------Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022--- */
                            // Delivery Date validaiton
                            if(showDel == true && reqDel == true && !del_Date[i].get("v.value")) {
                                //component.find("delivery_date")[i].set("v.errors",[{message: $A.get("$Label.c.Delivery_Date_is_Required")}]);;
                                flag = false;
                                flag2 = true; 
                                errMsg = $A.get("$Label.c.Delivery_Date_is_Required");
                            }
                            else if(del_Date[i].get("v.value") && +new Date(del_Date[i].get("v.value")) < +y){
                                //component.find("delivery_date")[i].set("v.errors",[{message: $A.get("$Label.c.Date_of_delivery_should_not_be_less_than_todays_date")}]);;
                                flag = false;
                                flag2 = true; 
                                errMsg = $A.get("$Label.c.Date_of_delivery_should_not_be_less_than_todays_date");
                            }
                            else{
                                //component.find("delivery_date")[i].set("v.errors",null); 
                                flag2 = false; 
                            }
                        /* --------------End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022---- */    
                        }
                    }
                    else{
                        console.log('else'+JSON.stringify(orderItemList));
                        if(!getProductId.get("v.value")) {
                            flag = false;
                            component.find("itemproduct").set("v.errors",[{message: $A.get("$Label.c.Product_is_required")}]);                
                        }
                        else{
                            component.find("itemproduct").set("v.errors",null);
                        }  
                        
                        if(!getQtyId.get("v.value") || getQtyId.get("v.value") == '0') {
                            flag = false;
                            component.find("itemqty").set("v.errors",[{message: $A.get("$Label.c.Please_enter_Quantity")}]);  
                        }
                        else{
                            component.find("itemqty").set("v.errors",null);
                        }
                    /* ------------Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022---------- */    
                        // Delivery Date validaiton
                        if(showDel == true && reqDel == true && !del_Date.get("v.value")) {
                           // component.find("delivery_date").set("v.errors",[{message: $A.get("$Label.c.Delivery_Date_is_Required")}]);;
                            flag = false;
                            flag2 = true; 
                            errMsg = $A.get("$Label.c.Delivery_Date_is_Required");
                        }
                        else if(del_Date.get("v.value") && +new Date(del_Date.get("v.value")) < +y){
                            //component.find("delivery_date").set("v.errors",[{message: $A.get("$Label.c.Date_of_delivery_should_not_be_less_than_todays_date")}]);;
                            flag = false;
                            flag2 = true; 
                            errMsg = $A.get("$Label.c.Date_of_delivery_should_not_be_less_than_todays_date");
                        }
                        else{
                            //component.find("delivery_date").set("v.errors",null); 
                            flag2 = false; 

                        }
                    /* -----------------End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022----- */    
                    /* if(getUnitValueId){
                            if(!getUnitValueId.get("v.value") || getUnitValueId.get("v.value") == '0') {
                                flag = false;
                                component.find("itemunitvalue").set("v.errors",[{message: $A.get("$Label.c.Please_enter_Final_Price")}]);    
                            }
                            else{
                                component.find("itemunitvalue").set("v.errors",null);
                            }
                        }*/
                    }
                }
                return flag;
            }
            else if(OrderType =='Normal Order'){
                var getProductId = component.find("normalitemproduct");
                var getUnitValueId = component.find("normalitemunitvalue");
                var getQtyId = component.find("normalitemqty");
                var del_Date = component.find("delivery_dateNrml");    // SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022..
                var toastMsg = '';
                var flag = true;
                
                if(orderItemList.length <= 0){
                    flag = false;
                }
                else if(orderItemList.length > 0){
                    var isProductArray = Array.isArray(getProductId);
                    
                    if(isProductArray){
                        for(var i = 0; i <orderItemList.length; i++){
                            //Product validaiton
                            if(!getProductId[i].get("v.value")) {
                                component.find("normalitemproduct")[i].set("v.errors",[{message: $A.get("$Label.c.Product_is_required")}]);               
                                flag = false;
                            }
                            else{
                                component.find("normalitemproduct")[i].set("v.errors",null);           
                            }
                            console.log('getUnitValueId>>--->'+getUnitValueId[i].get("v.value"));
                        // if(getUnitValueId){
                                // Unit Value validaiton
                                if((!getUnitValueId[i].get("v.value") || getUnitValueId[i].get("v.value") == '0')){
                                    component.find("normalitemunitvalue")[i].set("v.errors",[{message: $A.get("$Label.c.Please_enter_Final_Price")}]);
                                    flag = false;
                                }
                                else{
                                    component.find("normalitemunitvalue")[i].set("v.errors",null); 
                                }
                            //}
                            console.log('getUnitQtyId>>--->'+getQtyId[i].get("v.value"));
                            // Quantity validaiton
                            if(!getQtyId[i].get("v.value") || getQtyId[i].get("v.value") == '0') {
                                component.find("normalitemqty")[i].set("v.errors",[{message: $A.get("$Label.c.Please_enter_Quantity")}]);;
                                flag = false;
                            }
                            else{
                                component.find("normalitemqty")[i].set("v.errors",null); 
                            }
                            /* ----------Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022---- */
                            // Delivery Date validaiton
                            if(showDel == true && reqDel == true && !del_Date[i].get("v.value")) {
                                //component.find("delivery_dateNrml")[i].set("v.errors",[{message: $A.get("$Label.c.Delivery_Date_is_Required")}]);;
                                flag = false;
                                flag2 = true; 
                                errMsg = $A.get("$Label.c.Delivery_Date_is_Required");
                            }
                            else if(del_Date[i].get("v.value") && +new Date(del_Date[i].get("v.value")) < +y){
                                //component.find("delivery_dateNrml")[i].set("v.errors",[{message: $A.get("$Label.c.Date_of_delivery_should_not_be_less_than_todays_date")}]);;
                                flag = false;
                                flag2 = true; 
                                errMsg = $A.get("$Label.c.Date_of_delivery_should_not_be_less_than_todays_date");
                            }
                            else{
                                //component.find("delivery_dateNrml")[i].set("v.errors",null); 
                                flag2 = false; 
                            }
                            /* --------End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022------ */
                        }
                    }
                    else{
                        console.log('else'+JSON.stringify(orderItemList));
                        if(!getProductId.get("v.value")) {
                            flag = false;
                            component.find("normalitemproduct").set("v.errors",[{message: $A.get("$Label.c.Product_is_required")}]);                
                        }
                        else{
                            component.find("normalitemproduct").set("v.errors",null);
                        }  
                        
                        if(!getQtyId.get("v.value") || getQtyId.get("v.value") == '0') {
                            flag = false;
                            component.find("normalitemqty").set("v.errors",[{message: $A.get("$Label.c.Please_enter_Quantity")}]);  
                        }
                        else{
                            component.find("normalitemqty").set("v.errors",null);
                        }
                        
                        if(getUnitValueId){
                            if(!getUnitValueId.get("v.value") || getUnitValueId.get("v.value") == '0') {
                                flag = false;
                                component.find("normalitemunitvalue").set("v.errors",[{message: $A.get("$Label.c.Please_enter_Final_Price")}]);    
                            }
                            else{
                                component.find("normalitemunitvalue").set("v.errors",null);
                            }
                        }
                        /* --------Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022--------- */
                        // Delivery Date validaiton
                        if(showDel == true && reqDel == true && !del_Date.get("v.value")) {
                            //component.find("delivery_dateNrml").set("v.errors",[{message: $A.get("$Label.c.Delivery_Date_is_Required")}]);;
                            flag = false;
                            flag2 = true; 
                            errMsg = $A.get("$Label.c.Delivery_Date_is_Required");
                        }
                        else if(del_Date.get("v.value") && +new Date(del_Date.get("v.value")) < +y){
                            //component.find("delivery_dateNrml").set("v.errors",[{message: $A.get("$Label.c.Date_of_delivery_should_not_be_less_than_todays_date")}]);;
                            flag = false;
                            flag2 = true; 
                            errMsg = $A.get("$Label.c.Date_of_delivery_should_not_be_less_than_todays_date");
                        }
                        else{
                            flag2 = false; 
                        }
                        /* ----------End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022-------- */
                    }
                }
                /* ----------Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022------------ */
                if(flag2 == true){
                    var toastEvent1 = $A.get("e.force:showToast");
                      var titl  = $A.get("{!$Label.c.Error}");
                      toastEvent1.setParams({
                          "title": titl,
                          "type": "Error",
                          "message": errMsg
                          //"duration":'3000'
                      });
                      toastEvent1.fire();
                }
                /* -------------End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022------------ */
                return flag;
            }
            
            
       // }
       // catch(err){
        //    console.log('error: '+err);
        //}
    },
    
    
    // Create sales order on Save as Draft button. 
    createSalesOrder : function(component, event, status) { 
        var isValid = this.validateOrder(component); 
        var isValidItems = this.validateOrderItems(component);
        var isValidateShipping = this.validateShipping(component);
        var grosMrgn = component.get("v.grossMargin");
        component.set("v.newSalesOrder.Gross_Margin_Per_Colombia__c",grosMrgn);
     
        if(isValid && isValidItems && isValidateShipping){
            var paymentTerm = component.get("v.paymentTerm");
            var toastMsg = '';
            var newSO = component.get("v.newSalesOrder");
            var orderItemList = component.get("v.orderItemList");
            console.log('orderItemList'+JSON.stringify(newSO));
            
            var action;
               if(status=="Submitted") {
                   //Execute to save order on Submit button
                   
                   component.set("v.newSalesOrder.Order_Status__c","Submitted");
                   component.set("v.disableSelect", true);
               }
               else if(status== "Draft") {
                   //Execute to save as draft without flag check/rollback
                   component.set("v.newSalesOrder.Order_Status__c", "Draft");    
               }
               
                 action = component.get("c.saveSalesOrder");
                    action.setParams({ 
                        "soObj": newSO,
                        "salesOrderItemString": JSON.stringify(orderItemList),
                        "isSimulated": false,
                        "TotalUSD": newSO.Total_Sales_USD__c
                    });   
                
                // show spinner to true on click of a button / onload
            component.set("v.showSpinner", true);             
            
            action.setCallback(this, function(a) {
                
                // on call back make it false ,spinner stops after data is retrieved
                component.set("v.showSpinner", false);                
                
                var state = a.getState();
                
                if (state == "SUCCESS") {
                  
                     var recordId = a.getReturnValue().soObj.Id;
                     component.set("v.parentId",recordId);     
                     component.set("v.recordId",recordId);
                    var orderStatus = a.getReturnValue().soObj.Order_Status__c;
                    console.log('solist>>--->'+JSON.stringify(a.getReturnValue().soiList));
                    component.set("v.newSalesOrder",a.getReturnValue().soObj);
                    component.set("v.sfdcOrderNo", a.getReturnValue().sfdcOrderNo);
                    
                    var errorMessage = a.getReturnValue().soObj.ErrorMessage__c;
                    console.log('error msg:'+errorMessage);
                    
                    if(errorMessage!='') {
                        toastMsg = errorMessage;
                        this.showErrorToast(component, event, toastMsg);
                    }
                    else{
                        if(status=="Submitted"){
                                toastMsg = $A.get("$Label.c.Sales_Order_Created_Successfully");
                                 //Execute to save order on Submit button
                                    this.showToast(component, event, toastMsg);
                                    var profileName = component.get("v.orderFields.userObj.Profile.Name");
                                    var fullUrl = '';
                                    var defType = '';
                                    console.log('recordId'+recordId);
                                    this.gotoURL(component, recordId);
                            }
                            else if(status=='Draft'){
                                var toastMg = $A.get("$Label.c.Sales_Order_Draft_Saved_Successfully");
                                
                                    //Execute to save order on Draft button
                                    this.showToast(component, event, toastMg);
                                    component.set("v.showOnReLoad",true);
                                    
                                    var orderItemList = a.getReturnValue().soiList;
                                    if(orderItemList!=null && orderItemList!=undefined){
                                        component.set("v.orderItemList", orderItemList);
                                    }
                                   
                                    var approvalList = a.getReturnValue().approvalList;
                                    if(approvalList!=null && approvalList!=undefined){
                                        component.set("v.approvalList", approvalList);
                                }
                            } 
                    	}
                    if(recordId!=null && !component.get("v.isCommunityUser")){
                        var file;
                        file = component.find("fileId");    
                        
                         console.log('ParentId>>--->'+component.get("v.parentId"));
                        if(file.get("v.files")!=null && file.get("v.files").length!=0){ 
                            this.readFile(component,file.get("v.files")[0]);
                        }
                    }
                }
                else{
                    toastMsg = $A.get("$Label.c.Some_error_has_occurred_while_Confirming_Order_Please_try_again");
                    this.showErrorToast(component, event, toastMsg);   
                }
                  
            });
            $A.enqueueAction(action);
            
            //Logic to disable Data after draft Order Reload
            window.setTimeout($A.getCallback(function() {
                var OrderType = component.get("v.newSalesOrder.Order_Type_Colombia__c");
                var getProductId;
                if(OrderType == 'MPT Order'){
                getProductId = component.find("itemproduct");    
                }else{
                   getProductId = component.find("normalitemproduct");  
                }
                var orderItemList = component.get("v.orderItemList");
                var isProductArray = Array.isArray(getProductId);
                
                if(orderItemList.length >=1){
                    console.log('orderItemList.length'+orderItemList.length);
                    for (var idx=0; idx < orderItemList.length; idx++) {
                        if(isProductArray){
                            if(OrderType =='MPT Order'){
                            	component.find("businessTypeOptions")[idx].set("v.disabled",true);
                            	component.find("itemsel")[idx].set("v.disabled",true);
                                if(orderItemList[idx].typeOfBusiness=='Impacto Producto' || orderItemList[idx].typeOfBusiness=='Impacto Negocio') {
                               // component.find("itemunitvalue")[idx].set("v.disabled",true);  
                                }
                                if(idx==0){
                                    component.find("deleteBtn")[idx].set("v.disabled",true); 
                                }
                                if(orderItemList.length==1){
                                     component.find("deleteBtn")[idx].set("v.disabled",false); 
                                     component.find("itemsel")[idx].set("v.disabled",true);
                                }
                            }else{
                                component.find("normalitemsel")[idx].set("v.disabled",true);
                                component.find("normalitemunitvalue")[idx].set("v.disabled",false);
                                 if(idx==0){
                                   // component.find("normaldeleteBtn")[idx].set("v.disabled",true); 
                                }
                            }        
                        }else{
                            console.log('idx'+idx);
                            if(OrderType =='MPT Order'){
                            component.find("businessTypeOptions").set("v.disabled",true);
                            component.find("deleteBtn").set("v.disabled",false);
                            component.find("itemsel").set("v.disabled",true);    
                            }else{
                            component.find("normalitemsel").set("v.disabled",true);    
                            }    
                           
                        }
                    }
                }
           }),3000 );
            //Logic End
        }
        else{
            toastMsg = $A.get("$Label.c.Please_provide_valid_input_fill_all_the_mandatory_fields_before_proceeding");
            this.showErrorToast(component, event, toastMsg);
        }
    },
   
    
    //Logic to disable all fields when reload.
    disabledOnReload :function(component){
        var OrderType = component.get("v.newSalesOrder.Order_Type_Colombia__c");
        var getProductId;
        if(OrderType =='MPT Order'){
         	getProductId = component.find("itemproduct");   
        }else{
           getProductId = component.find("normalitemproduct");    
        }
        console.log('isProductArray');
        var orderItemList = component.get("v.orderItemList");
        var isProductArray = Array.isArray(getProductId);
       
        if(orderItemList.length >=1){
               component.find("OrderTypeOptions").set("v.disabled",true);
            for (var idx=0; idx < orderItemList.length; idx++) {
                  console.log('isProductArray');
                if(isProductArray){
                    console.log('isProductArray');
                    if(OrderType =='MPT Order'){
                    component.find("businessTypeOptions")[idx].set("v.disabled",true);
                    component.find("deleteBtn")[idx].set("v.disabled",true); 
                    component.find("itemsel")[idx].set("v.disabled",true);
                    }else{
                        component.find("normalitemunitvalue")[idx].set("v.disabled",true); 
                        component.find("normalitemsel")[idx].set("v.disabled",true);
                         component.find("normaldeleteBtn")[idx].set("v.disabled",true);
                    }    
                    
                    console.log('isProductArray'+isProductArray);
                    
                }else{
                     console.log('else isProductArray');
                     if(OrderType =='MPT Order'){
                     	component.find("businessTypeOptions").set("v.disabled",true);
                    	component.find("deleteBtn").set("v.disabled",true);
                    	component.find("itemsel").set("v.disabled",true);
                        component.find("itemunitvalue").set("v.disabled",true);  
                     }else{
                     	component.find("normalitemunitvalue").set("v.disabled",true); 
                        component.find("normaldeleteBtn").set("v.disabled",true);

                     }     
                  
                    
                    console.log('isProductArray-'+isProductArray);
                }
            }
            
        }
    },
    
    
    //Logic to show/hide modal by toggling css class .tog
    toggle: function(component){
        var lookupmodal = component.find("lookupmodal");
        $A.util.toggleClass(lookupmodal, "slds-hide");
        
        var backdrop = component.find("backdrop");
        $A.util.toggleClass(backdrop, "slds-hide");
    },
    
    //Logic to show/hide modal by toggling css class .tog2
    toggleDialog: function(component){
        var dialog = component.find("approvalDialog");
        $A.util.toggleClass(dialog, "slds-hide");
        
        var backdrop2 = component.find("backdrop2");
        $A.util.toggleClass(backdrop2, "slds-hide");
    },
    
    closePopUp: function(component) {
        this.toggle(component);
    },
    
   
    //Logic to Redirect sales order after creation
    gotoURL : function(component, recordId) {
        var device = $A.get("$Browser.formFactor");
        var recrdId = recordId;
        
        // if-else Commented by Akhilesh for same behaviour on U-Connect after placing order redirecting to order detail
        //if(device=='DESKTOP'){
            try{
                var baseURL='';
                
                if(component.get("v.user.Profile.Name")=='Customer Partner Community Plus User - Colombia')
                {
                      var url = (window.location.href).split('/s/');
                    baseURL = url[0] + '/s/detail/'+recordId;
                }
                else
                {
                   var urlInstance= window.location.hostname;
                var baseURL = 'https://'+urlInstance+'/lightning/r/Sales_Order__c/'+recrdId+'/view';
              
                }
                //sforce.one.navigateToSObject(recordId);
                //Modified by Deeksha : For full screen
                
             
                
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": baseURL
                });
                urlEvent.fire();
                //END:Modified by Deeksha : For full screen
            }catch(err){
                console.log('inside error of go to URL')
                this.navigateToComponent(component,recrdId);
            }
       /* }
        else{
            console.log('inside else of go to URL')
            //alert('else url');
            //Redirect to Standard ListView when placing orders in SF1.
            this.navigateToComponent(component,recrdId);
        }*/
    },
    
    //Called through "gotoURL" method
    navigateToComponent: function(component,recrdId){
        var navEvent = $A.get("e.force:navigateToSObject");
        //alert('recrdId'+recrdId);
        if(navEvent!=undefined){
            
            navEvent.setParams({
                "recordId": recrdId,
                "slideDevName": related
                
            });
            navEvent.fire();        
        }
        else{
           
            var mobileUrl = window.location.hostname;
            //alert(window.history);
            window.history.back();
           //window.location.assign('/'+recrdId+'/view');
             //window.location.assign(mobileUrl+'/'+ recrdId);
        }
    },

    //Show Error Message Toast (Red)
    // Note: Shows a javascript alert in case the component is loaded within a visualforce page
    showErrorToast : function(component, event, toastMsg) {
        component.set("v.toastFlag","setError"); 
        var toastEvent = $A.get("e.force:showToast");
        var error = $A.get("$Label.c.Error");
        // For lightning1 show the toast
        if (toastEvent!=undefined){
            //fire the toast event in Salesforce1
            toastEvent.setParams({
                title: error,
                mode: 'dismissible',
                type: 'Error',
                message: toastMsg
            });
            toastEvent.fire();
        }
        else{ 
            try{
                sforce.one.showToast({
                    "title": "Error!",
                    "message":toastMsg,
                    "type": "error"
                });}catch(err){
                    var errorMsg = component.find("errorMsg");
                    component.set("v.flagMessage",toastMsg);
                    var x =document.getElementById("snackbar");
                    x.className = "show";
                    setTimeout(function(){ x.className = x.className.replace("show", ""); }, 3000);
                }
        }
    },
    
    // Show Success Toast (Green)
    // Note: Shows a javascript alert in case the component is loaded within a visualforce page
    showToast : function(component, event, toastMsg) {
        component.set("v.toastFlag","setSuccess"); 
        var toastEvent = $A.get("e.force:showToast");
        var success = $A.get("$Label.c.Success");
        // For lightning1 show the toast
        if (toastEvent!=undefined){
            //fire the toast event in Salesforce1
            toastEvent.setParams({
                title: success,
                mode: 'dismissible',
                type: 'success',
                message: toastMsg
            });
            toastEvent.fire();
        }
        else{ 
            try{
                sforce.one.showToast({
                    "title": success,
                    "message":toastMsg,
                    "type": "success"
                });
            }catch(err){
                component.set("v.flagMessage",toastMsg);
                var x = document.getElementById("snackbar");
                x.className = "show";
                setTimeout(function(){ x.className = x.className.replace("show", ""); }, 3000); 
            }
        }
    },
    
    
    //Logic to upload attachments
     readFile: function(component, file){
    	var reader = new FileReader();
  		var self1 = this;
         console.log('your File is started uploading'+file.name);
    reader.onloadstart = function() {
      //reader.abort();
       console.log('OnLoad Start');
        /*	var fileContents = reader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
			console.log('your File is started uploading');
            // call the uploadProcess method 
            self1.uploadProcess(component, file, fileContents);*/
 		
    };

    reader.onloadend = function() {
      console.log('OnLoad end');
        	
    };
  		reader.onload = $A.getCallback(function(){
     	var fileContents = reader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
			console.log('your File is started uploading');
            // call the uploadProcess method 
            self1.uploadProcess(component, file, fileContents);
 		 });
  		reader.readAsDataURL(file);
	},
    
    uploadProcess: function(component, file, fileContents) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        //console.log('Filelist>>--->'+filelist);
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition,'');
    },
    
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
        // call the apex method 'saveChunk'
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveChunk");
        console.log('ParentId>>--->'+component.get("v.parentId"));
        action.setParams({
            parentId: component.get("v.parentId"),
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
        });
 
        // set call back 
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                // check if the start postion is still less then end postion 
                // then call again 'uploadInChunk' method , 
                // else, diaply alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
                } else {
                   // alert('your File is uploaded successfully');
                   // component.set("v.showLoadingSpinner", false);
                   console.log("your File is uploaded successfully	");
                }
                // handel the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    },
    
    upload: function(component, file, fileContents) {
        var MAX_FILE_SIZE = 750000;
        var action = component.get("c.saveTheFile");
        
        action.setParams({ 
            parentId: component.get("v.parentId"),
            fileName: file.name,
            base64Data: encodeURIComponent(fileContents), 
            contentType: file.type
        });
        
        action.setCallback(this, function(a) {
            var attachId = a.getReturnValue();
            console.log(attachId);
        });
        
        $A.enqueueAction(action);     
    },
    
    
    // Method to display Approval/Audit History of the current record
    // All entries are Sorted by Created Date
    fetchApprovalHistory : function(component, soId, userId) {
        var action = component.get("c.generateData");
        
        action.setParams({
            recordId: soId
        });
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state == "SUCCESS") {
                var returnValue = JSON.stringify(a.getReturnValue());
                component.set("v.approvalList",a.getReturnValue());
                console.log(component.get("v.approvalList.enableApproval")+'userId'+userId);
                var enableApproval = component.get("v.approvalList.enableApproval");
                if(userId!='Admin NUCO Colombia'){
                component.set("v.showApproveReject", enableApproval);
            }
          }	
        });
        $A.enqueueAction(action);        
    },
    //Modified by Deeksha : For full screen
    checkOldSalesOrg :function(component) {
        var action = component.get("c.getAccountSalesOrg");
        var accId = component.get("v.recordId");
        
        if(accId!=null){
            action.setParams({
                accId: accId
            });
        }
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state == "SUCCESS") {
                if(a.getReturnValue() != '5710'){
                var toastMsg = "This functionality is not available for you";
                this.showErrorToast(component, event, toastMsg);  
                var urlInstance= window.location.hostname;
                var baseURL = 'https://'+urlInstance+'/lightning/r/Account/'+accId+'/view';
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": baseURL
                });
                urlEvent.fire();
                
                }
                else{
                    this.getSOSTP(component);
                    this.getOrderFields(component);
                }
          }	
        });
        $A.enqueueAction(action);   
    },
    //END:Modified by Deeksha : For full screen
    getUserInfo:function(component,event,helper){
        console.log('in getUserInfo function'); 
        var action = component.get('c.getUserInfo'); 
        
        
        
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            console.log('statein user info  '+state);
            if(state == 'SUCCESS') {
                // component.set('v.sObjList', a.getReturnValue());
                console.log('in return result info users '+JSON.stringify(a.getReturnValue()));
                var comunityRole = a.getReturnValue()[0].Community_Role__c;
                var prName = a.getReturnValue()[0].Profile.Name;
                if(prName == 'Customer Partner Community Plus User - Colombia'){
                    component.set("v.recordId", a.getReturnValue()[0].AccountId);
                }
                console.log('recordId=>> ',component.get("v.recordId"))
                 helper.getSOSTP(component);
                console.log('prName for community '+prName);
                //component.set("v.profileNmForComm",prName);
                
                console.log('comunityRole second '+comunityRole);
                
                /*if(comunityRole==2){
                    component.set("v.showCommunityRole",false);
                }else{
                    component.set("v.showCommunityRole",true);
                }*/
                
                
            }
        });
        $A.enqueueAction(action);
        
        
    }
})