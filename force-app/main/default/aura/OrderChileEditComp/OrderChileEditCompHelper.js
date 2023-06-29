({	
    getExchangeRate: function(component) {
        var poDate = component.get("v.newSalesOrder.Purchase_Order_Date__c");
        var action = component.get('c.getExchangeRate');
        if(poDate!=''){
        action.setParams({
                PODate: poDate
            });
        }else{
            var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
            action.setParams({
                PODate: today
            });
        }
        action.setCallback(this, function(actionResult) {
            component.set('v.exchangeRate', actionResult.getReturnValue());
            component.set('v.newSalesOrder.USD_Conversion_Rate__c',actionResult.getReturnValue());
        });
        
        $A.enqueueAction(action);
    },
    getAccountList: function(component) {
        var action = component.get('c.fetchCustomer');
        action.setCallback(this, function(actionResult) {
            component.set('v.accounts', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    fetchCurrency :function(component, elementId) {
        var opts = [];
       
                    opts.push({
                        class: "optionClass",
                        label: "USD",
                        value: "USD"
                    });
        		opts.push({
                        class: "optionClass",
                        label: "CLP",
                        value: "CLP"
                    });
                
                
                component.find(elementId).set("v.options", opts);
            
    },
     MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
    //Logic to get all Account's/Sales order's Data.
    getOrderFields : function(component, event) {
        var action = component.get("c.getOrderFields");
        var accId = component.get("v.sORecordId");
       // console.log('Cmp Id:-'+accId);
		if(accId!=null){
            action.setParams({
                salesorderId: accId
            });
        }
         
        action.setCallback(this, function(a) {
            // on call back make it false ,spinner stops after data is retrieved
            component.set("v.showSpinner", false); 
            // console.log('returnValue: '+JSON.stringify(returnValue));
            var state = a.getState();
          //  console.log('state '+ state);
            if (state == "SUCCESS") {
                /* -----Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022----------- */
                const todays = new Date()
                let tomorrow =  new Date();
                tomorrow.setDate(todays.getDate() + 1);
                var today = $A.localizationService.formatDate(tomorrow, "YYYY-MM-DD");
               /* ------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022-------------- */
                component.set("v.newSalesOrder.Purchase_Order_Date__c",today);
                this.getExchangeRate(component);
          //CR#174 -Chile Margin Block-SKI- kalpesh chande -  06/01/2023 -Start here.....Comment
                //this.fetchCurrency(component, 'Currency');
               // this.fetchCurrency(component, 'CurrencyForItems');
            //CR#174 -Chile Margin Block-SKI- kalpesh chande -  06/01/2023 -End here.....Comment
                var returnValue = a.getReturnValue();
             //   console.log('returnValue',returnValue);
                component.set("v.orderFields",returnValue);
              //  console.log('OrderField:-'+JSON.stringify(returnValue));
                component.set("v.recordId",returnValue.accountId);
                //console.log("tAccountId:-"+returnValue.accountId);
                component.set("v.newSalesOrder.Purchase_Order_no__c",returnValue.purchaseOrderNo);
                var orderList = component.get("v.orderItemList");
                component.set("v.newSalesOrder.Order__c",returnValue.orderId);
               //console.log('Return Value :- '+returnValue.orderId);
              //  var sol = returnValue.soliList;
                //console.log("tSalorderlineitemList:-"+JSON.stringify(sol));
        		//console.log("tOrderlist:-"+JSON.stringify(orderList));
                //component.set('v.orderItemList',sol);
               // var or = component.get('v.orderItemList');
                //console.log('Test ini'+JSON.stringify(or));
                //console.log('Test returnValue'+JSON.stringify(returnValue));
          //CR#174 -Chile Margin Block-SKI- kalpesh chande -  23/01/2023 -Start here
                   component.set("v.solItemCurrency", returnValue.soliCurrency);
                 component.set("v.currencyList1", returnValue.orderCurrency);
           //CR#174 -Chile Margin Block-SKI- kalpesh chande -  23/01/2023 -End here      
                component.set("v.newSalesOrder.CurrencyIsoCode",returnValue.orderCurrency);
               console.log(' returnValue.orderCurrency ', returnValue.orderCurrency);
                console.log(' returnValue.soliCurrency ',  returnValue.soliCurrency);
              
                console.log('returnValue.soliCurrency ',returnValue.soliCurrency.length);
                
               // console.log('solItemCurrency',component.get('v.solItemCurrency'));
                var ShippingLocMap = returnValue.ShippingLocofSO;
                var DistributorData = returnValue.DistributorData;
                //console.log('DistributorData',DistributorData);
                //console.log('salesOrder',JSON.stringify(DistributorData));    
                var paymentTermList = returnValue.paymentTermList;
                var incoTermList = returnValue.incoTermsList;
                component.set("v.paymentTermList", paymentTermList);
                component.set("v.newSalesOrder.Order_Type_lk__c", returnValue.editOrderType);  //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023
                component.set("v.orderTypeList", returnValue.orderTypeList1);  //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023
                console.log(' returnValue.editOrderType>>>>'+ returnValue.editOrderType)
                //console.log('Test Payment term:-',JSON.stringify(component.get('v.paymentTermList')));
                component.set("v.ShippingLocMap", ShippingLocMap);
                component.set("v.paymentTerm", DistributorData.paymentTerms);
                component.set("v.accPaymentTerm", DistributorData.paymentTermId);
				//console.log('@@@'+DistributorData.paymentTermId);
               // console.log('@@@'+component.get("v.newSalesOrder").Payment_Term__c);
                component.set("v.newSalesOrder.Inco_Term__c", incoTermList[0].Id);//CR#183 -Chile Export Sales - kalpesh chande -  21/06/2023
                component.set("v.incoTermList", incoTermList);
                component.set("v.poNoList",returnValue.poNoList);
                //console.log('Test Po:-'+returnValue.poNoList);
                component.set("v.newSalesOrder.Payment_Term__c",DistributorData.paymentTermId);
                component.set("v.defaultTerm",DistributorData.paymentTermId);//Sayan
                //console.log('Test Def'+JSON.stringify(component.get('v.defaultTerm')));
                component.set("v.newSalesOrder.Sold_to_Party__c", component.get("v.recordId"));
                component.set("v.newSalesOrder.Bill_To_Party__c", component.get("v.recordId"));
                component.set("v.newSalesOrder.Distribution_Channel_lk__c",DistributorData.distributorChannelId);
                component.set("v.newSalesOrder.Sales_Org_lk__c",DistributorData.salesOrgId);
                component.set("v.newSalesOrder.OwnerId", DistributorData.soOwner);
                component.set("v.newSalesOrder.Division_lk__c", returnValue.DistributorData.divisionId);
                component.set("v.newSalesOrder.Id",accId);
                component.set("v.user",returnValue.userObj);
                component.set("v.userId",returnValue.userObj.Id);
                component.set("v.salesOrg",returnValue.salesOrg); //Divya
                
                component.set("v.loginCountryObjs",returnValue.loginCountryObj); // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022
          //CR#174 -Chile Margin Block- SKI- kalpesh chande -  06/01/2023 - Start Here
                var user = component.get("v.user");
                var ownerId = returnValue.OwnerId;
                var userId = component.get("v.userId");
                var profileName = component.get("v.orderFields.userObj.Profile.Name");
                  // console.log("profile"+profileName)
                    if(profileName=='Chile Customer Service'){
                        component.set("v.isSalesrep",true)
                    }
         //CR#174 -Chile Margin Block- SKI- kalpesh chande -  06/01/2023 - End Here
                //console.log('@@@'+component.get("v.newSalesOrder.OwnerId"));
               // this.reloadSO(component, event);
                this.createDraftOrder(component, event);   
                this.fetchSKUData(component,event); 
                //console.log("testFetchSku end");
                
            }
            else{
                var toastMsg = "Error While placing Order Please Contact System Administrator";
                this.showErrorToast(component, event, toastMsg);  
            }
        });
        $A.enqueueAction(action);
        var orderItemList = component.get("v.orderItemList");
                //console.log("tOrderItemList:-"+orderItemList);
    },
    
    
    
    
    // Method use to enable OrderForm for Editing purpose.
    editForm:function(component,event){
        component.set("v.disableThis", false);
        component.set("v.disableEdit", true);
        component.set("v.headerMsg", $A.get("$Label.c.Edit_Order"));
          var OrderType = component.get("v.newSalesOrder.Order_Type_Colombia__c");
          var getProductId;  
        if(OrderType == 'MPT Order'){
           getProductId = component.find("itemproduct");
        }else{
           getProductId = component.find("normalitemproduct"); 
        }
          var isProductArray = Array.isArray(getProductId);
          var orderItemList = component.get("v.orderItemList");
      
        for (var idx=0; idx < orderItemList.length; idx++) {
            if(isProductArray){
            //component.find("itemunitvalue")[idx].set("v.disabled",false); 
                if(OrderType == 'MPT Order'){
            if(orderItemList[idx].typeOfBusiness=='Impacto Producto' || orderItemList[idx].typeOfBusiness=='Impacto Negocio') {
               // component.find("itemunitvalue")[idx].set("v.disabled",true);  
               // console.log('idx'+idx);
            }
            if(idx!=0){
                component.find("deleteBtn")[idx].set("v.disabled",false); 
            }
               }else{
                    component.find("normalitemunitvalue")[idx].set("v.disabled",false); 
                }
            }else{
                  if(OrderType == 'MPT Order'){
                    //component.find("itemunitvalue").set("v.disabled",false);
                    component.find("businessTypeOptions").set("v.disabled",true);
                    component.find("deleteBtn").set("v.disabled",false);
                  }else{
                  
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
       // console.log('soId'+soId);
         if(soId!=null && soId!=undefined){
            component.set("v.headerMsg", $A.get("$Label.c.VIEW_ORDER")); 
            
            action.setParams({
                soId: soId
            });
             
              action.setCallback(this, function(a) {
                var state = a.getState();
                if(state == "SUCCESS") {
                    var salesOrder = a.getReturnValue();
				  // console.log('salesOrder'+JSON.stringify(a.getReturnValue()));    
                    component.set("v.newSalesOrder", salesOrder);
                    //console.log('salesOrder: '+salesOrder.Sold_to_Party__r.Name);
                    component.set("v.sfdcOrderNo", salesOrder.Name);
                     
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
                    component.set("v.shippingLoc",salesOrder.Ship_To_Party__r.City__c);
                    
                    var slObj = ShippingLocMap[salesOrder.Ship_To_Party__r.City__c];
                    component.set("v.selItem", slObj);
                     
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
                    
                    // Logic for RC/PC 
                    if(salesOrder.Order_Status__c == "Draft" && (userId==ownerId)){
                       // console.log('profileName'+profileName);
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
            // console.log('so id not found');
         }
    },
    
    
    // Method call to reload Order Items
    // Gets all Order Line Items against the current Sales Order record
    reloadSOItems: function(component){
        console.log('reloadSOItems');
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
                    console.log('orderItems: '+JSON.stringify(a.getReturnValue()));
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
       	component.set("v.showSpinner", true);
       // console.log('FetchSKUDATE');
         action = component.get("c.getSkuData");
            //Column data for the table
           // console.log('getSku');
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
                }/*,
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
        
        var accId =  component.get("v.recordId");
       var newSO = component.get("v.newSalesOrder"); //CR#174 -Chile Margin Block-SKI- kalpesh chande -  23/01/2023
        action.setParams({ 
            "accId": accId,
            "soObj":newSO, //CR#174 -Chile Margin Block-SKI- kalpesh chande -  23/01/2023
            });  
        
        action.setCallback(this, function(a) {
       		component.set("v.showSpinner", false); 
    	    var state = a.getState();
           // console.log('returnValue: '+JSON.stringify(a.getReturnValue()));
            if (state == "SUCCESS") {
              component.set("v.priceDetailList",a.getReturnValue());
               	    //pass the column information
                    component.set("v.priceDetailTableColumns",priceDetailTableColumns);
                var tData = component.get("v.priceDetailTableColumns");
               // console.log("tpriceDetails:-"+JSON.stringify(tData));
                    //pass the configuration of task table
                    component.set("v.priceDetailTableConfig",priceDetailTableConfig);
                    //initialize the datatable
                    
                }
                else{
                    //console.log(resp.getError());
                }           
            });
        
        $A.enqueueAction(action);
        //console.log("tfetchOr:-"+component.get("v.orderItemList"));
    },
    
    //Updating row when Qty and Final price changes.
    normalUpdateRowCalculations : function(component, event, helper){
        var target = event.getSource(); 
        var rowIndex = event.getSource().get("v.rowIndex");
        //var rowIndex = component.get("v.rowIndex");
        var orderItemList = component.get("v.orderItemList");
        var totalSales = 0;
        var grossProfit = 0;
        var grossMargin = 0;
        var totalDisc = 0;
        var totalMaxPrice=0;//CR#174 -Chile Margin Block- SKI- kalpesh chande -  06/01/2023
        var totalD = 0;
        var SumDiscount= 0;
        var businessImpact = 0;
        //var MTPadmin = component.get("v.adminMPTParam");
        var authrizationFlag =false;
        var currency = component.get("v.solItemCurrency"); //CR#174 -Chile Margin Block-SKI- kalpesh chande -  23/01/2023
        var exchangeRate = component.get("v.exchangeRate");
        //var adjustedPer = MTPadmin.of_adjustment_to_display_vendor_utility__c/100;
        var initialPosition =rowIndex;
       // console.log('rowIndex'+rowIndex);
        for (var idx = 0; idx < orderItemList.length; idx++) {
            //console.log('isvalidFinal>>--->'+idx);
           // console.log('orderItemList[idx].qty>>--->'+orderItemList[idx].qty*orderItemList[idx].unitValue);
            var flag = true;
            if(!orderItemList[idx].qty) {
                flag = false;
                
            }
            if(!orderItemList[idx].unitValue) {
                flag = false;
            }
           // console.log(orderItemList[idx].unitValue +'-----------'+flag);
            if(!orderItemList[idx].productId==false){
                if(flag){
                   // console.log('Test Product Id:-'+!orderItemList[idx].productId)
                    //Logic to restrict negative value
                    var qty2 = orderItemList[idx].qty.toString(); //Convert to string
                    orderItemList[idx].qty = parseFloat(qty2.replace("-", "")); //Replace negative sign
                    
                    var value2 = orderItemList[idx].unitValue.toString(); //Convert to string
                    orderItemList[idx].unitValue = parseFloat(value2.replace("-", "")); //Replace negative sign
                    //End of logic 
                   // console.log('Test Calculation');
                    orderItemList[idx].netSales = orderItemList[idx].qty*orderItemList[idx].unitValue;
                    
                    
                    orderItemList[idx].discount_percent = ((orderItemList[idx].maxPrice-orderItemList[idx].unitValue)/orderItemList[idx].maxPrice)*100;
                   
                    //console.log('orderItemList[idx].discount_percent------->'+orderItemList[idx].discount_percent);
                    orderItemList[idx].discount= (orderItemList[idx].discount_percent/100)*(orderItemList[idx].maxPrice*orderItemList[idx].qty);
                   // console.log('orderItemList[idx].discount----->'+orderItemList[idx].discount);
                    orderItemList[idx].profit = (orderItemList[idx].netSales-(orderItemList[idx].qty*orderItemList[idx].unitCost));
                    //orderItemList[idx].netMargin = (orderItemList[idx].profit/orderItemList[idx].netSales)*100;
                    /*if(orderItemList[idx].netMargin<MTPadmin.Level_1_max__c && !authrizationFlag){
                        authrizationFlag = true;
                    }
                    console.log('MTPadmin'+MTPadmin.of_adjustment_to_display_vendor_utility__c);
                    console.log('orderItemList[idx].unitCost'+orderItemList[idx].unitCost);
                    */
                     totalMaxPrice+=parseFloat(orderItemList[idx].maxPrice*orderItemList[idx].qty);//CR#174 -Chile Margin Block- SKI- kalpesh chande -  06/01/2023
                    totalSales += parseFloat(orderItemList[idx].netSales);
                    grossProfit += parseFloat(orderItemList[idx].profit);//(Gross Profit / Total Sales ) *100
                    grossMargin = (grossProfit / totalSales ) *100;
                    totalD += parseFloat(orderItemList[idx].discount);
                   // console.log('totalD--'+totalD+'totalSales--'+totalSales);
                    totalDisc = (totalD/totalMaxPrice)*100;//CR#174 -Chile Margin Block- SKI- kalpesh chande -  06/01/2023
                    //businessImpact  = (SumDiscount/totalSales)*100;*/
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
               // console.log('else');
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
        //console.log('totalSales'+totalSales+'---grossMargin---'+grossMargin+'---totalDisc---'+totalDisc);    
        component.set("v.orderItemList",orderItemList); 
        if(currency=='CLP'){
            component.set("v.totalSales",totalSales/exchangeRate);
        }else{
            component.set("v.totalSales",totalSales);
        }
        component.set("v.grossMargin",grossMargin);
        component.set("v.totalDisc",totalDisc);
        //component.set("v.businessImpact",businessImpact);
        component.set("v.grossProfit",grossProfit); 
        if(orderItemList[rowIndex]!=null){
            if(orderItemList[rowIndex].SOLIID !== null){
            //this.updateDraftOrder(component,event,orderItemList[rowIndex]);   
         this.updateSalesOrderLineItem(component,event,orderItemList[rowIndex]);
            }else{
               // console.log('update')
           // this.updateDraftOrder(component,event,orderItemList[rowIndex]);    
            }
            
        }
        
        /*if(grossMargin<MTPadmin.Level_1_max__c){
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
        } */
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
   /* updateDraftOrder :function(component, event, orderItem) { 
        var accId = component.get("v.newSalesOrder.Sold_to_Party__c");
        var newSO = component.get("v.newSalesOrder");
      
        var salesOrg = component.get("v.salesOrg"); //Divya
        console.log('Test Sales Org:-'+salesOrg);
        var action = component.get("c.updateOrderItem");
                    action.setParams({ 
                        "salesOrderItemString": JSON.stringify(orderItem),
                        "soObj2": newSO,
                        "accountId": accId,
                        "salesOrg": salesOrg
                        });  
        action.setCallback(this, function(a) {
                component.set("v.showSpinner", false);                
				
        });  
      $A.enqueueAction(action);  
    },*/
    
    updateSalesOrderLineItem :function(component, event, orderItem){
          var accId = component.get("v.newSalesOrder.Sold_to_Party__c");
        var newSO = component.get("v.newSalesOrder");
        var salesOrg = component.get("v.salesOrg");
        
       var soilUpAction  = component.get("c.updateSalesOrderLineItem");
        soilUpAction.setParams({
             "salesOrderItemString": JSON.stringify(orderItem),
                        "soObj2": newSO,
                        "accountId": accId,
        });
         soilUpAction.setCallback(this, function(a) {
              				//var state = a.getState();
            // console.log('Test Update');
        });  
      $A.enqueueAction(soilUpAction);  
    },
    //Logic to validate Order data
      validateOrder: function(component){
          var flag = true;
          var toastMsg = '';
          var paymentTerm = component.get("v.newSalesOrder.Payment_Term__c");
          var PONumber = component.get("v.newSalesOrder.Purchase_Order_no__c");
          var PODate = component.get("v.newSalesOrder.Purchase_Order_Date__c");
          if(paymentTerm){
              if(paymentTerm == null) {
                  flag = false;
                  var errorMessage= $A.get("$Label.c.Payment_Term_is_not_available");
                  component.find("paymentTermId").setCustomValidity(errorMessage);
                  component.find("paymentTermId").reportValidity();
              }
          }
          if(!PONumber){
              flag = false;
              component.find("poNo").setCustomValidity($A.get("$Label.c.Purchase_Order_No_is_required_and_can_contain_only_characters_and_numbers"));
              component.find("poNo").reportValidity(); 
          }
          
          if(!PODate){
             
              flag = false;
              component.find("startDate").setCustomValidity($A.get("$Label.c.Purchase_Order_date_is_required"));                    
              component.find("startDate").reportValidity(); 
          }
          
          
          return flag;  
      },
    
    
    
    
    //Validate Order Items
    validateOrderItems: function(component){
        //var validCodeCounter = component.get("v.validCodeCounter");
        var orderItemList = component.get("v.orderItemList");
        var toastMsg = '';
        var flag = true;
        if(orderItemList.length <= 0){
            flag = false;
        }
        else {
            if(orderItemList.length > 1 || $A.util.isArray(component.find("ChildComponent"))){
                for(var i of component.find("ChildComponent") ){
                    i.checkItems();
                }
                if(component.get("v.validCodeCounter") != orderItemList.length){
                    flag = false;
                }
            }     
            else{
                component.find("ChildComponent").checkItems();
                if(component.get("v.validCodeCounter") != 1){
                    flag = false;
                }
            }
        }
        /* -------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022--------------------- */
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        var tmpFlag = true;
        if(orderItemList.length > 0){
            //deliveryDate
            for (i = 0; i < orderItemList.length; i++) {
                var obj = new Object(orderItemList[i]);
                var tmpCountry = component.get("v.loginCountryObjs");
                //alert('obj.deliveryDate '+obj.deliveryDate);
                //alert('todays date '+today);
                //alert('tmpCountry.Delivery_Date__c '+tmpCountry.Delivery_Date__c);
                if(obj.deliveryDate==null && tmpCountry.Delivery_Date__c== true){
                   flag = false;
                    tmpFlag = false;
                    break;
 
                }
                
               /* if((obj.deliveryDate<= today && tmpCountry.Delivery_Date__c== true) || (obj.deliveryDate==null && tmpCountry.Delivery_Date__c== true)){
                    flag = false;
                    tmpFlag = false;
                    break;
                }*/
            }
        }
        
        
        if(tmpFlag==false ){
            var msg ='Please select Delivery date greater than today in the cart';
            this.showErrorToast(component, event, msg);
        }
        /* -----------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022------------------- */
        return flag;
    },
    
    deleteSaleOrderLineItem : function(component,event,orderItem){
         var newSO = component.get("v.newSalesOrder");
        var action  = component.get("c.deleteSaleOrdeLineItem");
        action.setParams({
            "salesOrderLineItemID" : orderItem.SOLIID,
            "soObj2": newSO
        });
        action.setCallback(this,function(a){
            var state = a.getState();
           // console.log('Row Delete:-'+state);
            if(state === 'Success'){
               // console.log(''+a);
            }
        });
        $A.enqueueAction(action);
       
    },
    deleteOrderItem :function(component, event, ItemNo) { 
    	var accId = component.get("v.recordId");
        var newSO = component.get("v.newSalesOrder");
        var action = component.get("c.deleteOrderItem");
                    action.setParams({ 
                        "ItemNo": ItemNo,
                        "accountId": accId
                        });  
        action.setCallback(this, function(a) {
                component.set("v.showSpinner", false);                
				
        });  
      $A.enqueueAction(action);  
    },
    
    
    deleteAllOrderItem :function(component, event, orderItem) { 
        var accId = component.get("v.recordId");
        var newSO = component.get("v.newSalesOrder");
        var action = component.get("c.deleteAllOrderItem");
                    action.setParams({ 
                        "accountId": accId,
                        "soObj2": newSO
                        });  
        action.setCallback(this, function(a) {
            //console.log('Test Del Status:->>'+a.getState());
                component.set("v.showSpinner", false); 
            
				
        });  
      $A.enqueueAction(action);  
    },
    
    updateAllItems :function(component, event,orderItem){
    var accId = component.get("v.recordId");
        var newSO = component.get("v.newSalesOrder");
        var salesOrg = component.get("v.salesOrg"); //Divya
        var action = component.get("c.updateAllOrderItems");
                    action.setParams({ 
                        "salesOrderItemString": JSON.stringify(orderItem),
                        "soObj2": newSO,
                        "accountId": accId,
                        "salesOrg": salesOrg,
                        });  
        action.setCallback(this, function(a) {
                component.set("v.showSpinner", false);                
				
        });  
      $A.enqueueAction(action); 
} ,
    
    //create Order for saving cart values
    createDraftOrder:function(component, event) { 
       // console.log("tdraftorder");
        var action;
        var accId = component.get("v.recordId");
        var newSO = component.get("v.newSalesOrder");
        console.log('createOrder');
        action = component.get("c.createOrder");
                    action.setParams({ 
                        "soObj2": newSO,
                        "accountId": accId 
                        });   
		action.setCallback(this, function(a) {
                component.set("v.showSpinner", false);                
				var state = a.getState();
           // console.log('State:-'+state)
                if (state == "SUCCESS") {
                     console.log('createOrder##### ',a.getReturnValue());
                    var orderItemList = a.getReturnValue();
                    var totalSales = 0;
                    
        var grossProfit = 0;
        var grossMargin = 0;
        var totalDisc = 0;
        var totalD = 0;
        var SumDiscount= 0;
        var totalMaxPrice=0;//CR#174 -Chile Margin Block- SKI- kalpesh chande -  06/01/2023
        var currency = component.get("v.solItemCurrency");//CR#174 -Chile Margin Block- SKI- kalpesh chande -  23/01/2023
        var exchangeRate = component.get("v.exchangeRate");
        for (var idx = 0; idx < orderItemList.length; idx++) {
         //  console.log('isvalidFinal>>--->'+idx);
           // console.log('orderItemList[idx].qty>>--->'+orderItemList[idx].qty*orderItemList[idx].unitValue);
            var flag = true;
            if(!orderItemList[idx].qty) {
                flag = false;
                
            }
            if(!orderItemList[idx].unitValue) {
                flag = false;
            }
           // console.log(orderItemList[idx].unitValue +'-----------'+flag);
            if(!orderItemList[idx].productId==false){
                if(flag){
                    //Logic to restrict negative value
                    var qty2 = orderItemList[idx].qty.toString(); //Convert to string
                    orderItemList[idx].qty = parseFloat(qty2.replace("-", "")); //Replace negative sign
                    
                    var value2 = orderItemList[idx].unitValue.toString(); //Convert to string
                    orderItemList[idx].unitValue = parseFloat(value2.replace("-", "")); //Replace negative sign
                    //End of logic 
                    
                    orderItemList[idx].netSales = orderItemList[idx].qty*orderItemList[idx].unitValue;
                    orderItemList[idx].discount_percent = ((orderItemList[idx].maxPrice-orderItemList[idx].unitValue)/orderItemList[idx].maxPrice)*100;
                    orderItemList[idx].discount= (orderItemList[idx].discount_percent/100)*(orderItemList[idx].maxPrice*orderItemList[idx].qty);
                    orderItemList[idx].profit = (orderItemList[idx].netSales-(orderItemList[idx].qty*orderItemList[idx].unitCost));
                    totalMaxPrice+=parseFloat(orderItemList[idx].maxPrice*orderItemList[idx].qty);//CR#174 -Chile Margin Block- SKI- kalpesh chande -  06/01/2023
                    totalSales += parseFloat(orderItemList[idx].netSales);
                    grossProfit += parseFloat(orderItemList[idx].profit);//(Gross Profit / Total Sales ) *100
                    grossMargin = (grossProfit / totalSales ) *100;
                    totalD += parseFloat(orderItemList[idx].discount);
                   // console.log('totalD--'+totalD+'totalSales--'+totalSales);
                    totalDisc = (totalD/totalMaxPrice)*100;//CR#174 -Chile Margin Block- SKI- kalpesh chande -  06/01/2023
                    //businessImpact  = (SumDiscount/totalSales)*100;*/
                }else{
                    orderItemList[idx].netSales = 0;
                    orderItemList[idx].discount_percent = 0;
                    orderItemList[idx].discount= 0;
                    orderItemList[idx].profit = 0;
                    orderItemList[idx].netMargin = 0; 
                }
            }
            
        }
        //console.log('totalSales'+totalSales+'---grossMargin---'+grossMargin+'---totalDisc---'+totalDisc);    
        component.set("v.orderItemList",orderItemList);
                    var o = component.get("v.orderItemList");
                //    console.log('Test OR:-'+JSON.stringify(o));
        component.set("v.grossMargin",grossMargin);
        component.set("v.totalDisc",totalDisc);
        if(orderItemList.length>0){
           // component.set("v.solItemCurrency",orderItemList[0].oiCurrency);//CR#174 -Chile Margin Block- SKI- kalpesh chande -  23/01/2023-comment
            if(orderItemList[0].oiCurrency=='CLP'){
            component.set("v.totalSales",totalSales/exchangeRate);
        }else{
            component.set("v.totalSales",totalSales);
        }
        }
        component.set("v.grossProfit",grossProfit);
                    component.set("v.orderItemList", a.getReturnValue());
                }
        });  
        $A.enqueueAction(action);
        
    },
    
    
    // Create sales order on Save as Draft button. 
    createSalesOrder : function(component, event, status) { 
       // console.log('Sayan default PT-->'+component.get("v.defaultTerm"));
       // console.log('Sayan final PT-->'+component.get("v.newSalesOrder").Payment_Term__c);
        var isPaymentTermChanged;
        if(component.get("v.defaultTerm") == component.get("v.newSalesOrder").Payment_Term__c){
            isPaymentTermChanged = false;
        }else{
            isPaymentTermChanged = true;
        }
        var isValid = this.validateOrder(component); 
        component.set("v.validCodeCounter",0);
        var isValidItems = this.validateOrderItems(component);
        var grosMrgn = component.get("v.grossMargin");
        var currency = component.get("v.newSalesOrder.CurrencyIsoCode");
        console.log('currency'+currency);
        var exchangeRate = component.get("v.exchangeRate");
        var totalSales = component.get("v.totalSales");
        var salesOrg = component.get("v.salesOrg");
  //CR#174 -Chile Margin Block- SKI- kalpesh chande -  06/01/2023 -Start Here
            var priceDetailList = component.get("v.priceDetailList");
            var isSimulationOrder=component.get("v.isSimulationOrder");
  //CR#174 -Chile Margin Block- SKI- kalpesh chande -  06/01/2023 -End Here
        
        if(isValid && isValidItems ){
            //var paymentTerm = component.get("v.paymentTerm");
            var toastMsg = '';
            var newSO = component.get("v.newSalesOrder");
            var orderItemList = component.get("v.orderItemList");
            //console.log('order @@@ '+JSON.stringify(newSO));
            //console.log('OrderItemList:-'+JSON.stringify(orderItemList));
            
            var action;
               if(status=="Submitted") {
                   //Execute to save order on Submit button
                   component.set("v.newSalesOrder.Order_Status__c","Submitted");
                   //component.set('v.newSalesOrder.USD_Conversion_Rate__c',"exchangeRate");
                   component.set("v.disableSelect", true);
               }
       //CR#174 -Chile Margin Block- SKI- kalpesh chande -  06/01/2023 - Start Here
           // component.set("v.showSpinner", true);
            
            if(isSimulationOrder==false){
                action = component.get("c.saveSalesOrderLineItem");
            }else{
      
                action = component.get("c.checkSimulation");//CR#174 -Chile Margin Block- SKI- kalpesh chande -  06/01/2023
                
            }
                     action.setParams({ 
                        "soObj": newSO,
                        "priceDetailString":JSON.stringify(priceDetailList),//CR#174 -Chile Margin Block- SKI- kalpesh chande -  06/01/2023
                        "salesOrderItemString": JSON.stringify(orderItemList),
                        "isSimulated": false,
                        "salesOrg": salesOrg,
                        "isPaymentTermChanged": isPaymentTermChanged,
                        "isSimulation":isSimulationOrder//CR#174 -Chile Margin Block- SKI- kalpesh chande -  06/01/2023
                    });
                            
                // show spinner to true on click of a button / onload
            component.set("v.showSpinner", true);             
            
            if(isSimulationOrder==false){//CR#174 -Chile Margin Block- SKI- kalpesh chande -  06/01/2023
            action.setCallback(this, function(a) {
                
                // on call back make it false ,spinner stops after data is retrieved
                component.set("v.showSpinner", false);                
                 component.set('v.isModalOpen', false);//CR#174 -Chile Margin Block- SKI- kalpesh chande -  06/01/2023
                var state = a.getState();
               
                if (state == "SUCCESS") {
                   // console.log('Test so:-'+JSON.stringify(a.getReturnValue().soObjList));
                    var recordId = a.getReturnValue().soObjList[0].Id;
                   // console.log('sales Order --->'+JSON.stringify(a.getReturnValue().soObjList));
                    component.set("v.parentId",recordId);     
                    //component.set("v.recordId",recordId);
                    //var orderStatus = a.getReturnValue().soObj.Order_Status__c;
                    //console.log('solist>>--->'+JSON.stringify(a.getReturnValue().soiList));
                    if(recordId!=null){
                        var file;
                        file = component.find("fileId");    
                        
                      //  console.log('ParentId>>--->'+component.get("v.parentId"));
                        if(file.get("v.files")!=null && file.get("v.files").length!=0){ 
                            try {
                                var reader = new FileReader();
                                var self1 = this;
                                //console.log('your File is started uploading'+file.get("v.files")[0].name);
                                
                                reader.onload = $A.getCallback(function(){
                                    var fileContents = reader.result;
                                    var base64 = 'base64,';
                                    var dataStart = fileContents.indexOf(base64) + base64.length;
                                    fileContents = fileContents.substring(dataStart);
                                   // console.log('your File is started uploading');
                                    // call the uploadProcess method 
                                    self1.uploadProcess(component, file.get("v.files")[0], fileContents,a.getReturnValue().soObjList);
                                });
                                reader.readAsDataURL(file.get("v.files")[0]);
                                
                                //this.readFile(component,file.get("v.files")[0],a.getReturnValue().soObjList);
                            }
                            catch(err) {
                                console.log( err.message);
                               // document.getElementById("demo").innerHTML = err.message;
                            }
                            
                        }
                    }                        
                    if(status=="Submitted"){
                        toastMsg = $A.get("$Label.c.Sales_Order_Edited_Successfully");
                        //Execute to save order on Submit button
                        this.showToast(component, event, toastMsg);
                        var profileName = component.get("v.orderFields.userObj.Profile.Name");
                        var fullUrl = '';
                        var defType = '';
                        //console.log('recordId'+recordId);
                        this.gotoURL(component, recordId); 
                    }
                    
                    
                }
                else{
                    toastMsg = $A.get("$Label.c.Some_error_has_occurred_while_Confirming_Order_Please_try_again");
                    this.showErrorToast(component, event, toastMsg);   
                }
                  
            });
       //CR#174 -Chile Margin Block- SKI- kalpesh chande -  06/01/2023 - Start Here
            }else{
                   action.setCallback(this, function(a) {
                
                // on call back make it false ,spinner stops after data is retrieved
                component.set("v.showSpinner", false); 
                
                var state = a.getState();
                
                       if (state == "SUCCESS") {
                          // console.log('Approval --->'+JSON.stringify(a.getReturnValue()));
                           var approvalMap1 = [];
                           var approvalMap=a.getReturnValue();
                           //console.log('approvalMap '+JSON.stringify(approvalMap));
                           for ( var key in approvalMap ) {
                               //console.log('approvalMap[key] '+approvalMap[key]);
                               if(approvalMap[key]!='' && approvalMap[key]!=null){
                                  // console.log('inside if');
                               approvalMap1.push({value:approvalMap[key], key:key});
                               }else{
                                    //console.log('inside else');
                                  approvalMap1.push({value:$A.get("$Label.c.Order_will_be_Opened"), key:key}); 
                               }
                           }
                         //  console.log('approvalMap1 '+JSON.stringify(approvalMap1));
                           component.set("v.ApprovalFlags", approvalMap1);
                          

                       }  
                        component.set('v.isModalOpen', true);
            });
            }
     //CR#174 -Chile Margin Block- SKI- kalpesh chande -  06/01/2023 - End Here
          $A.enqueueAction(action);
            
            
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
        //console.log('isProductArray');
        var orderItemList = component.get("v.orderItemList");
        var isProductArray = Array.isArray(getProductId);
       
        if(orderItemList.length >=1){
               component.find("OrderTypeOptions").set("v.disabled",true);
            for (var idx=0; idx < orderItemList.length; idx++) {
                 // console.log('isProductArray');
                if(isProductArray){
                  //  console.log('isProductArray');
                    if(OrderType =='MPT Order'){
                    component.find("businessTypeOptions")[idx].set("v.disabled",true);
                    component.find("deleteBtn")[idx].set("v.disabled",true); 
                    component.find("itemsel")[idx].set("v.disabled",true);
                    }else{
                        component.find("normalitemunitvalue")[idx].set("v.disabled",true); 
                        component.find("normalitemsel")[idx].set("v.disabled",true);
                         component.find("normaldeleteBtn")[idx].set("v.disabled",true);
                    }    
                    
                   // console.log('isProductArray'+isProductArray);
                    
                }else{
                    // console.log('else isProductArray');
                     if(OrderType =='MPT Order'){
                     	component.find("businessTypeOptions").set("v.disabled",true);
                    	component.find("deleteBtn").set("v.disabled",true);
                    	component.find("itemsel").set("v.disabled",true);
                     }else{
                     	component.find("normalitemunitvalue").set("v.disabled",true); 
                        component.find("normaldeleteBtn").set("v.disabled",true);

                     }     
                  
                    
                    //console.log('isProductArray-'+isProductArray);
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
        
        if(device=='DESKTOP'){
            try{
                sforce.one.navigateToSObject(recordId);
            }catch(err){
                this.navigateToComponent(component,recrdId);
            }
        }
        else{
            //alert('else url');
            //Redirect to Standard ListView when placing orders in SF1.
            this.navigateToComponent(component,recrdId);
        }
    },
    
    //Called through "gotoURL" method
    navigateToComponent: function(component,recrdId){
        var navEvent = $A.get("e.force:navigateToSObject");
        //alert('recrdId'+recrdId);
        if(navEvent!=undefined){
            
            navEvent.setParams({
                "recordId": recrdId,
                "slideDevName": "related"
                
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
     readFile: function(component, file,soRecords){
    	var reader = new FileReader();
  		var self1 = this;
       //  console.log('your File is started uploading'+file.name);
         /*
    reader.onloadstart = function() {
      //reader.abort();
       console.log('OnLoad Start');
        /*	var fileContents = reader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
			console.log('your File is started uploading');
            // call the uploadProcess method 
            self1.uploadProcess(component, file, fileContents);
 		
    };

    reader.onloadend = function() {
      console.log('OnLoad end');
        	
    };*/
  		reader.onload = $A.getCallback(function(){
     	var fileContents = reader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
			//console.log('your File is started uploading');
            // call the uploadProcess method 
            this.uploadProcess(component, file, fileContents,soRecords);
 		 });
  		reader.readAsDataURL(file);
	},
    
    uploadProcess: function(component, file, fileContents,soRecords) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        //console.log('Filelist>>--->'+filelist);
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
     //   console.log('in upload');
        try{
            this.uploadInChunk(component, file, fileContents, startPosition, endPosition,'',soRecords);
        } catch(err) {
            console.log( err.message);
        }
    },
    
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId,soRecords) {
        // call the apex method 'saveChunk'
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveChunk");
       // console.log('ParentId>>--->in upload'+soRecords);
        var soIDs =[];
        // console.log('soRecords in upload>>--->'+JSON.stringify(soRecords));
        for(var so = 0; so < soRecords.length;so++){
           // console.log(' soRecords[so].id in upload>>--->'+ soRecords[so].Id);
            soIDs[so] = soRecords[so].Id;
           // console.log(' soIDs[so] in upload>>--->'+ soIDs[so]);
           // console.log(' attachId--->'+ attachId);
        }
       // console.log('soIDs in upload>>--->'+soIDs);
        action.setParams({
            parentId: soIDs,
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
           // console.log('state::'+state);
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                // check if the start postion is still less then end postion 
                // then call again 'uploadInChunk' method , 
                // else, diaply alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId,soRecords);
                } else {
                   // alert('your File is uploaded successfully');
                   // component.set("v.showLoadingSpinner", false);
               //    console.log("your File is uploaded successfully	");
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
           // console.log(attachId);
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
               // console.log(component.get("v.approvalList.enableApproval")+'userId'+userId);
                var enableApproval = component.get("v.approvalList.enableApproval");
                if(userId!='Admin NUCO Colombia'){
                component.set("v.showApproveReject", enableApproval);
            }
          }	
        });
        $A.enqueueAction(action);        
    }
    
})