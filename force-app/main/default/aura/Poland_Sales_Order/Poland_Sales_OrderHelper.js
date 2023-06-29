({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb
    
    //Logic to get all price book master Data with respect to their sold to party.
    fetchSKUData : function(component, event) {
        var action;
        var priceDetailTableColumns;  
        //component.set("v.showSpinner", true);
        
        action = component.get("c.getSkuData");
        //Column data for the table
        priceDetailTableColumns = [
            {
                //'label': $A.get("$Label.c.Product_Code"),
                'label': 'SKU Code',
                'name':'skuCode',
                'type':'string',
                'resizeable':true
            },
            {
                'label': $A.get("$Label.c.Name"),
                'name':'skuDescription',
                'type':'string',              
                'resizeable':true
            }];            
        
        //Configuration data for the table to enable actions in the table
        var priceDetailTableConfig = {
            "massSelect":false,
            "globalAction":[],
            "searchByColumn":false,
            "rowAction":[
                {
                    "label": $A.get("$Label.c.Select"),
                    "type":"url",
                    "id":"selectproduct"
                }
            ]
            
        };
            
        var accId =  component.get("v.recordId");
        var isCommonPriceBook = component.get("v.isCommonPriceBook");
        //var isDistributor =  component.get("v.isDistributor");
                
        action.setParams({ 
            "accId":accId,
            "isCommonPriceBook":isCommonPriceBook,
            //"isDistributor":isDistributor
        });  
        
        action.setCallback(this, function(a) {
            component.set("v.showSpinner", false); 
            var state = a.getState();
            
            if (state == "SUCCESS") {
                var returnData =a.getReturnValue();
                
                //pass the column information
                
                component.set("v.priceDetailList",a.getReturnValue());
                
                //console.log('price lisr returned :'+JSON.stringify(component.get("v.priceDetailList")));
                component.set("v.priceDetailTableColumns",priceDetailTableColumns);
                //pass the configuration of task table
                component.set("v.priceDetailTableConfig",priceDetailTableConfig);
                //initialize the datatable
                component.find("priceDetailsTable").initialize({
                    "order":[0,"desc"],
                    "itemMenu":["10","25","50"],
                    "itemsPerPage:":5                    
                });
            }
            else{
                
            }           
        });
        $A.enqueueAction(action);
    },
    
    
    
    getOrderFieldss : function(component, event) {
        // var forClones = component.get("v.forClone");
        //console.log('change donint handler '+forClones);
        
        var action = component.get("c.getOrderFields");
        var accId = component.get("v.recordId");
        
        var salesOrderId = component.get("v.sOId");
        
        action.setParams({
            "accId" : accId
        });
        var opts=[]; 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            
            
            if(state == 'SUCCESS') {
                var returnValue = a.getReturnValue();
                component.set('v.loginCountryObjs',returnValue.loginCobj); // SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022...              
                
                if(returnValue.userObj.Profile.Name=='Customer Community Plus User - Poland - 1' || returnValue.userObj.Profile.Name=='Customer Community Plus User - Poland - 2' || returnValue.userObj.Profile.Name=='Customer Partner Community Plus User - Poland - 1'||  returnValue.userObj.Profile.Name=='Customer Partner Community Plus User - Poland - 2'){
                    
                    accId = JSON.stringify(a.getReturnValue().DistributorData.accountIds);
                    
                    component.set("v.profileNameforCommu",returnValue.userObj.Profile.Name);
                    
                    component.set("v.isCommunityUser",true); // SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022...
                    
                }
                //setting distributor Data
                var DistributorData = returnValue.DistributorData;
                var varDivCode = returnValue.divisionCodeList;
                var sid = component.get("v.sOId");
                console.log('sid '+sid);
                var divsn = '';
                if(sid==undefined){
                    //console.log('inside corred');
                    divsn = "('" +varDivCode.toString().split( "," ).join( "','" ) + "')";    
                }else{
                    //console.log('Inside sales Order division');
                    var divisionlk = component.get('v.divisionlk');
                    console.log('sasss divisionlk '+divisionlk);
                    divsn = "('" +divisionlk+ "')"; 
                } 
                
                //console.log('divsn '+divsn);
                
                component.set("v.newSalesOrder.Sold_to_Party__c", component.get("v.recordId"));
                component.set("v.newSalesOrder.Bill_To_Party__c", component.get("v.recordId"));
                component.set("v.newSalesOrder.Distribution_Channel_lk__c",DistributorData.distributorChannelId);
                component.set("v.newSalesOrder.Sales_Org_lk__c",DistributorData.salesOrgId);
                console.log('new Division lookup '+returnValue.DistributorData.divisionId);
                component.set("v.newSalesOrder.Division_lk__c", returnValue.DistributorData.divisionId);
                
                component.set("v.customerType", returnValue.DistributorData.customerType);
                
                
                
                component.set("v.user",returnValue.userObj);
                component.set("v.userId",returnValue.userObj.Id);
                
                component.set("v.profileName",returnValue.userObj.Profile.Name);
                
                
                
                //if Profile Name is Key Account managers and Wholesale Sales Manager set Common Price Book To true 
                if(returnValue.userObj.Profile.Name=='Poland(wholesale sales Manager)' ||  returnValue.userObj.Profile.Name=='Poland(Key Account Manager)' || returnValue.userObj.Profile.Name=='Poland(Non Crop Product & Retail Sales Manager)'){
                    console.log('P@oland Inside poland ');
                    component.set("v.objectName",'PriceBookMaster__c');
                    component.set("v.displayFields",'SKUCode__r.SKU_Description__c');
                    component.set("v.displayFieldSeconds",' SKUCode__r.SKU_Code__c');
                    //below changed by nandhini
                    component.set("v.queryFieldss",', SKUCombinationKey__c,SKUCode__r.Parent__c,SKUCode__r.Distribution_Channel__c,SKUCode__r.Early_Order_Discount__c,SKUCode__r.Division__c,Director_Price__c,SKUCode__r.Big_Volume_for_Truck__c, SKUCode__r.Big_Volume_for_Pallet__c,SKUCode__r.SKU_Description_poland__c,SKUCode__r.Product_with_SKU__c,Manager_Price__c,SKUCode__r.Payment_Term__c,SKUCode__c,SKUCode__r.Logistic_Discount__c,SKUCode__r.Truck_Quantity__c,Division__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name,SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c,DistributorCustomerCode__c, DepotCode__c, DepotCode__r.Location__c,SKUCode__r.UOM__c,SKUCode__r.Area_Manager_MSP__c, SKUCode__r.Sales_Director_MSP__c, Price__c, PG_CODE__c, PG_CODE__r.Name,SKUCode__r.Product_Category__c,SKUCode__r.Sales_Agent_MSP__c,UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Unit_Cost__c,SKUCode__r.pallet_Size_Italy__c,SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c,SKUCode__r.Inventory_order_Flag_Color_Italy__c,SKUCode__r.Inventory_Description_Italy__c,SKUCode__r.Inventory_order_Flag_Italy__c,SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.Division__r.Division_Code__c,SKUCode__r.SKU_Description__c,Final_Price__c,SKUCode__r.Distribution_Channel__r.Distribution_Channel_Code__c');
                    
                    component.set("v.isCommonPriceBook",true);
                    component.set("v.isKAMWholesManager",true);
                    //below Nandhini
                    var filter =" AND SKUCode__r.Division__r.Division_Code__c IN "+divsn+" AND DepotCode__r.Location__c ='PD01' AND PAK__c = false AND SKUCode__r.Distribution_Channel__r.Distribution_Channel_Code__c	= '20' AND DistributorCustomerCode__c = null AND SKUCode__r.Sales_Org__r.sales_org_code__c ='2941' AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC,LastModifiedDate ASC";
                    component.set("v.PriceBookFilter",filter);
                    var tempFil = component.get("v.PriceBookFilter");
                    
                }else{
                    console.log('P@oland community poland ');
                    
                    //do it here for Community
                    component.set("v.objectName",'PriceBook_Indonesia_Discount__c');
                    component.set("v.displayFields",'SKUCode__r.SKU_Description__c');
                    component.set("v.displayFieldSeconds",' SKUCode__r.SKU_Code__c');
                    
                    // component.set("v.queryFieldss",', SKUCode__r.Distribution_Channel__c,SKUCode__r.Early_Order_Discount__c,SKUCode__r.Division__c,Director_Price__c,SKUCode__r.Big_Volume_for_Truck__c, SKUCode__r.Big_Volume_for_Pallet__c,SKUCode__r.SKU_Description_poland__c,SKUCode__r.Product_with_SKU__c,Manager_Price__c,SKUCode__r.Payment_Term__c,SKUCode__c,SKUCode__r.Logistic_Discount__c,SKUCode__r.Truck_Quantity__c,Division__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name,SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c,DistributorCustomerCode__c, DepotCode__c, DepotCode__r.Location__c,SKUCode__r.UOM__c,SKUCode__r.Area_Manager_MSP__c, SKUCode__r.Sales_Director_MSP__c, Price__c, PG_CODE__c, PG_CODE__r.Name,SKUCode__r.Product_Category__c,SKUCode__r.Sales_Agent_MSP__c,UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Unit_Cost__c,SKUCode__r.pallet_Size_Italy__c,SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c,SKUCode__r.Inventory_order_Flag_Color_Italy__c,SKUCode__r.Inventory_Description_Italy__c,SKUCode__r.Inventory_order_Flag_Italy__c,SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.Division__r.Division_Code__c,SKUCode__r.SKU_Description__c,Final_Price__c,SKUCode__r.Distribution_Channel__r.Distribution_Channel_Code__c');
                    component.set("v.queryFieldss",', Active__c,SKUCode__r.Logistic_Discount__c,SKUCode__r.Early_Order_Discount__c,SKUCode__r.Multiple_of__c,SKUCode__r.Big_Volume_for_Pallet__c,SKUCode__r.Big_Volume_for_Truck__c,SKUCode__r.Truck_Quantity__c,SKUCode__r.pallet_Size_Italy__c,SKUCode__r.UOM__c,New_Composite_key__c,SKUCode__r.Division__c,SKUCode__r.Distribution_Channel__c,SKUCode__r.Payment_Term__c,SKUCode__r.SKU_Description_poland__c,SKUCode__r.SKU_Description__c,SKUCode__r.SKU_Code__c,DistributorCustomerCode__c,SKUCode__c,Payment_Term__c,Payment_Term__r.Payterms_Desc__c,Manual_Discount__c');
                    
                    
                    
                    component.set("v.isCommonPriceBook",false);
                    var tempAccId = accId;
                    console.log('tttempAccId '+tempAccId);
                    //Start 01-Sep-2021 Rajesh Singh Added the conditional check to fix Sales Order issue on community
                    //var results = tempAccId.substring(1, tempAccId.length-1);
                    if (tempAccId.length >= 20) {
                        var results = tempAccId.substring(1, tempAccId.length-1);
                    } else {
                        var results = tempAccId;
                    }
                    //End 01-Sep-2021 Rajesh Singh
                    
                    // var filter =" AND SKUCode__r.Division__r.Division_Code__c IN "+divsn+" AND DistributorCustomerCode__c =\'"+accId+"\' AND DepotCode__r.Location__c ='PD01' AND SKUCode__r.Distribution_Channel__r.Distribution_Channel_Code__c	= '20' AND SKUCode__r.Sales_Org__r.sales_org_code__c ='2941' AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC,LastModifiedDate ASC";
                    //var filter =" AND SKUCode__r.Division__r.Division_Code__c IN "+divsn+" AND DistributorCustomerCode__c =\'"+results+"\' AND DepotCode__r.Location__c ='PD01' AND SKUCode__r.Distribution_Channel__r.Distribution_Channel_Code__c	= '20' AND SKUCode__r.Sales_Org__r.sales_org_code__c ='2941' AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC,LastModifiedDate ASC";
                    //created chanages for Price Book Indonesia Discount accordingly
                    // var filter =" AND SKUCode__r.Division__r.Division_Code__c IN "+divsn+" AND DistributorCustomerCode__c =\'"+results+"\' AND DepotCode__r.Location__c ='PD01' AND SKUCode__r.Distribution_Channel__r.Distribution_Channel_Code__c	= '20' AND SKUCode__r.Sales_Org__r.sales_org_code__c ='2941' AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC,LastModifiedDate ASC";
                    
                    //filter is right
                    
                    var forCloneFilter = component.get("v.forClone");
                    console.log('clone order for clone sss '+forCloneFilter); 
                    var filter;
                    if(forCloneFilter=='cloneOrder'){
                        filter =" AND Sales_Org_Code__c='2941' AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND DistributorCustomerCode__c =\'"+results+"\' AND SKUCode__r.Division__r.Division_Code__c IN "+divsn+" AND SKUCode__r.Distribution_Channel__r.Distribution_Channel_Code__c	= '20'  ORDER BY LastModifiedDate ASC";
                    }else{
                        filter =" AND Sales_Org_Code__c='2941' AND Payment_Term__c!=null  AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND DistributorCustomerCode__c =\'"+results+"\' AND SKUCode__r.Division__r.Division_Code__c IN "+divsn+" AND SKUCode__r.Distribution_Channel__r.Distribution_Channel_Code__c	= '20'  ORDER BY LastModifiedDate ASC";
                    }
                    
                    
                    component.set("v.PriceBookFilter",filter);
                    component.set("v.isKAMWholesManager",false);
                }
                            
                if(returnValue.userObj.Profile.Name=='Customer Community Plus User - Poland - 1' || returnValue.userObj.Profile.Name=='Customer Community Plus User - Poland - 2'  || returnValue.userObj.Profile.Name=='Customer Partner Community Plus User - Poland - 1'||returnValue.userObj.Profile.Name=='Customer Partner Community Plus User - Poland - 2'){
                    component.set("v.showhideforCommunity",false);
                    component.set("v.forCommunityManualDis",true);
                    
                    component.set("v.isDistributor",true);
                    component.set("v.isInventoryHide",false);
                    component.set("v.disableThisPaymentTerm",true);
                    component.set("v.basePriceCartDisabl",true);
                    component.set("v.payTrmCartDisabl",true); 
                    component.set("v.showModalBigLogDiscount", true);
                    component.set("v.manualDisCartDisabl1", true);
                    console.log('inside test 1');
                    
                    
                }else{
                    component.set("v.showhideforCommunity",true);
                    
                    component.set("v.isInventoryHide",true);
                    component.set("v.isDistributor",false);
                    component.set("v.disableThisPaymentTerm",false);
                    component.set("v.basePriceCartDisabl",false); 
                    component.set("v.payTrmCartDisabl",false);
                    component.set("v.showModalBigLogDiscount", false);
                    console.log('inside test 2');
                }
                
                
                
                var customerType = component.get("v.customerType");
                if(customerType=='Regular Customer'){
                    component.set("v.isRegularCustomer",true);
                    
                    
                }else{
                    component.set("v.isRegularCustomer",false);
                }
                
                
                if(customerType=='Non Regular Customer'){
                    component.set("v.isNonRegularCustomer",true);
                    
                }else{
                    component.set("v.isNonRegularCustomer",false);
                }
                
                
                component.set("v.orderFields",returnValue);
                
                var ShippingLocMap = returnValue.ShippingLocMap;
                //for Inco Term
                var incoTermMap = returnValue.incoTermMap;
                var paymentTermMap = returnValue.paymentTermMap;
                
                
                
                
                // for Shipping Location Map
                opts=[];
                opts.push({"class": "optionClass", label: $A.get("$Label.c.None"), value: 'None'});  
                for (var key in ShippingLocMap){
                    if(DistributorData.sapCode == ShippingLocMap[key].SAP_Code__c){
                        opts.push({"class": "optionClass", label: $A.get("$Label.c.same_as_billing_address") ,value: key});
                        console.log('key'+key);
                    }
                }
                for (var key in ShippingLocMap){
                    if(DistributorData.sapCode != ShippingLocMap[key].SAP_Code__c){
                        opts.push({"class": "optionClass", label: ShippingLocMap[key].Location_Name__c+' '+'('+ShippingLocMap[key].City__c+')' ,value: key});
                        console.log('key1'+key);
                    }
                } 
                
                
                
                component.set("v.ShippingLocMap", ShippingLocMap);
                component.find("shippListOptions").set("v.options", opts);
                
                
                
                
                //for Inco Term
                opts=[];
                opts.push({"class": "optionClass", label: $A.get("$Label.c.None"), value: 'None'}); 
                for (var key in incoTermMap){
                    
                    opts.push({"class": "optionClass", label: incoTermMap[key].IncoTerm_Desc__c,value: key});
                    
                }
                component.set("v.incoTermMap", incoTermMap);
                component.find("incoTermListOptions").set("v.options", opts);
                
                
                //for payment Term 
                var opts2=[];
                var paymentTerm =[];
                opts2.push({"class": "optionClass", label: $A.get("$Label.c.None"), value: 'None'}); 
                for (var key in paymentTermMap){
                    opts2.push({"class": "optionClass", label: paymentTermMap[key].Payterms_Desc__c,value: key});
                    paymentTerm.push({value:paymentTermMap[key].Payterms_Desc__c, key:key});
                }
                
                component.set("v.paymentTermList", paymentTerm);
                component.set("v.paymentTermListCopy", paymentTerm);
                
                /*  component.set("v.paymentTermMap", paymentTermMap);
                component.find("paymentTermListOptions").set("v.options", opts2);*/
                
                
                
                
                
                //if sales order id found
                
                if(salesOrderId){
                    this.reloadSO(component);
                    var acIdTemp = component.get("v.recordId");
                    this.getDistributorTypePoland(component,event,acIdTemp);
                    
                }else{
                    
                    this.loadCart(component,event);
                    //component.set("v.showDynamicCompo",true);
                    
                }
                
                //calling Price Book Data 
                this.fetchSKUData(component,event);
                
                
            }else{
                var toastMsg = $A.get("$Label.c.Error_While_placing_Order_Please_Contact_System_Administrator");
                //Remove this comments after showErrorToast
                //this.showErrorToast(component, event, toastMsg);  
            }
        });
        $A.enqueueAction(action);
    },
    
    
    // Method call to reload Order Items
    // Gets all Order Line Items against the current Sales Order record
    reloadSOItems: function(component){
        
        var forClones = component.get("v.forClone");
        
        var filters = component.get("v.PriceBookFilter");
        console.log('forClones adadadasdasdas '+filters);
        
        var action = component.get("c.getSalesOrderItems");
        if(component.get("v.sOId")!=null){
            action.setParams({
                "soId": component.get("v.sOId"),
                "cloneOrders":forClones,
                "filter":filters
            });
            
            action.setCallback(this, function(a) {
                var state = a.getState();
                component.set("v.showSpinner", false); 
                console.log('State in reload Data '+state);
                if(state == "SUCCESS") {
                    component.set("v.orderItemList", a.getReturnValue());
                    var orderItemList = component.get("v.orderItemList");
                    
                    this.disabledOnReload(component);
                    this.clubbingSKU1(component,event,orderItemList);
                    var prName = component.get("v.profileName");
                    console.log('inside prName '+prName);
                    console.log('inside sales Id '+component.get("v.sOId"));
                    
                    var ordrRaisedBy = component.get("v.orderRaiseBy");
                    console.log('ordrRaisedBy '+ordrRaisedBy);
                    if(component.get("v.sOId") && (prName =='Customer Community Plus User - Poland - 1' || prName =='Customer Community Plus User - Poland - 2'  || prName=='Customer Partner Community Plus User - Poland - 1'||prName=='Customer Partner Community Plus User - Poland - 2') && (ordrRaisedBy=='Wholesale Sales Manager' || ordrRaisedBy=='Key Account Manager' )){
                        //if(component.get("v.sOId") && prName =='Customer Community Plus User - Poland - 1' && (ordrRaisedBy=='Key Account Manager' || ordrRaisedBy=='Wholesale Sales Manager' )){
                        console.log('inside sucess @@ ');
                        component.set("v.forCommunityManualDis",true);
                        component.set("v.manualDisCartDisabl1",true);
                        component.set("v.showhideforCommunity",false);
                        
                        
                    }else{
                        console.log('inside fails @@ ');
                        component.set("v.showhideforCommunity",true);
                        component.set("v.forCommunityManualDis",false);
                        component.set("v.manualDisCartDisabl1",false);
                    }
                    
                    
                    
                }else{
                    var toastMsg = $A.get("$Label.c.Error_while_reloading_Order_Items");
                    this.showErrorToast(component, event, toastMsg);                      
                }
                //Sayan INC0150730
                if(component.get("v.sOId")){
                    var forClones = component.get("v.forClone");
                    if(forClones=='cloneOrder'){
                        component.set("v.hasOrderId",true);
                        component.set("v.forCommunityManualDis",true);
                    }else{
                        component.set("v.hasOrderId",true);
                    }
                    
                    component.set("v.hideManualDiscount",false);
                }
                //Sayan INC0150730
            });
            $A.enqueueAction(action);
        }
    },
    
    
    // 1. Method call to reload existing SO
    // 2. Called in getOrderFields() after all Fields are loaded.
    // 3. Uses recordId to fetch related data of a SO record.
    reloadSO: function(component){
        
        component.set("v.headerMsg", $A.get("$Label.c.Create_Order"));
        var action = component.get("c.getSalesOrder");
        var soId = component.get("v.sOId");
        
        if(soId!=null && soId!=undefined){
            component.set("v.headerMsg", $A.get("$Label.c.VIEW_ORDER"));
            action.setParams({
                soId: soId
            });
            component.set("v.showSpinner", true);
            action.setCallback(this, function(a) {
                
                var state = a.getState();
                console.log('Reload SO line Item '+state);
                if(state == "SUCCESS") {
                    console.log('@@@@ One');
                    var salesOrder = a.getReturnValue();
                    //component.set("v.showSpinner", false);
                    component.set("v.newSalesOrder", salesOrder);
                    component.set("v.sfdcOrderNo", salesOrder.Name);
                    component.set("v.newSalesOrder.Purchase_Order_Date__c", salesOrder.Purchase_Order_Date__c); // SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022..
                    
                    console.log('@@@@ two');
                    component.set("v.grossNetPrice", salesOrder.Gross_Net_Value__c); 
                    var orderStatus = salesOrder.Order_Status__c;
                    console.log('@@@@ three');
                    
                    if(orderStatus == 'Error from SAP'){	
                        console.log('@@@@ four');
                        component.set("v.sapOrderNo", $A.get("$Label.c.Order_not_pushed_to_SAP"));
                        console.log('@@@@ five');
                    }else{
                        console.log('@@@@ six');
                        component.set("v.sapOrderNo", salesOrder.SAP_Order_Number__c);
                        console.log('@@@@ seven');
                    }
                    
                    var shipLoc = component.get("v.shipLocation");
                    
                    
                    var ShippingLocMap = component.get("v.ShippingLocMap");
                    if(shipLoc){
                        component.set("v.shippingLoc",salesOrder.Ship_To_Party__r.Name);
                        var slObj = ShippingLocMap[salesOrder.Ship_To_Party__r.Name];
                        component.set("v.selItem", slObj);
                    }
                    
                    
                    var forClones = component.get("v.forClone");
                    console.log('forClonesgfgfgfgfgfgf  '+forClones)
                    if(forClones=='cloneOrder'){
                        component.find("poNumber").set("v.disabled",false);
                    }else{
                        component.find("poNumber").set("v.disabled",true);
                    }
                    
                    
                    var user = component.get("v.user");
                    
                    var ownerId = salesOrder.OwnerId;
                    var userId = component.get("v.userId");
                    console.log('@@@@ foutteen');
                    var profileName = component.get("v.orderFields.userObj.Profile.Name");
                    console.log('profileName dsa '+profileName);
                    if(profileName=='Poland Sales Manager'){
                        component.set("v.forPoladnSalesMgrManualDis",true);
                    }else{
                        component.set("v.forPoladnSalesMgrManualDis",false);
                    }
                    
                    //forPoladnSalesMgrManualDis
                    
                    
                    var raisedBy = salesOrder.Order_Raise_By__c;
                    
                    
                    
                    if(orderStatus == 'Rejected'){ //|| (orderStatus == 'Rejected' && raisedBy =='Area Manager' && profileName =='Area Manager Italy') ||(orderStatus == 'Rejected' && raisedBy =='Sales Agent' && profileName =='Customer Service & Finance Manager Italy')){  
                        console.log('@@@@ fifteen');
                        component.set("v.disableEdit", false); 
                        component.set("v.disableEdit", false); 
                        console.log('@@@@ sixteen');
                        
                    }else{
                        console.log('@@@@ seventeen');
                        component.set("v.disableEdit", true); 
                        console.log('@@@@ eighteen');
                    } 
                    
                    
                    console.log('@@@@ nineteen');
                    var forClones = component.get("v.forClone");
                    if(forClones=='cloneOrder'){
                        component.set("v.disableThisConfirm", false);
                        component.set("v.disableThis", true);
                        
                    }else{
                        component.set("v.disableThisConfirm", true);
                        component.set("v.disableThis", true);
                        
                    }
                    
                    console.log('@@@@ twenty');
                    var forClones = component.get("v.forClone");
                    if(forClones=='cloneOrder'){
                        component.set("v.disableThisShipLoc", false);
                        component.set("v.disableThisRemark", false);
                    }else{
                        component.set("v.disableThisShipLoc", true);
                        component.set("v.disableThisRemark", true);
                    }
                    
                    console.log('@@@@ twenty one');
                    
                    console.log('@@@@ twenty two');
                    
                    component.set("v.showOnReLoad", true);
                    console.log('@@@@twenty three ');
                    component.set("v.showRaiseOrder", false);
                    console.log('@@@@ twenty four');
                    component.set("v.disabledSOI", true);
                    component.set("v.manualDisCartDisabl", true);
                    
                    
                    var forClones = component.get("v.forClone");
                    if(forClones=='cloneOrder'){
                        component.set("v.disableQtyCart", false);
                    }else{
                        component.set("v.disableQtyCart", true);
                    }
                    component.set("v.disableThisDeleteAll", true);
                    
                    
                    var prfileName = component.get("v.profileName");
                    //console.log('prfileName at portal '+prfileName);
                    
                    if(prfileName =='Customer Community Plus User - Poland - 1' || prfileName =='Customer Community Plus User - Poland - 2' || prfileName =='Customer Partner Community Plus User - Poland - 1'|| prfileName =='Customer Partner Community Plus User - Poland - 2'){
                        var forClones = component.get("v.forClone");
                        if(forClones=='cloneOrder'){
                            // component.set("v.basePriceCartDisabl", false);
                        }else{
                            // component.set("v.basePriceCartDisabl", true);
                        }
                        
                        
                        //component.set("v.basePriceCartDisabl", true);
                        component.set("v.isDistributor", true);
                        component.set("v.showhideforCommunity",false);
                    }else{
                        var forClones = component.get("v.forClone");
                        if(forClones=='cloneOrder'){
                            component.set("v.basePriceCartDisabl", false);
                        }else{
                            component.set("v.basePriceCartDisabl", true);
                        }
                        // component.set("v.basePriceCartDisabl", true);
                        component.set("v.basePriceCartDisabl", true);
                        component.set("v.isDistributor", true);
                        component.set("v.showhideforCommunity",true);
                    }
                    
                    
                    component.set("v.payTrmCartDisabl", true);
                    component.set("v.disableCheckBox", true);
                    component.set("v.disableRepeatOrdeTmp", true);
                    component.set("v.disableRepeatOrdeTmp", false);
                    
                    
                    console.log('forClones at raload items '+forClones)
                    if(forClones=='cloneOrder'){
                        component.find("skuId").makeDisabled(false); 
                        component.set("v.fileDisabele", false);
                    }else{
                        component.set("v.fileDisabele", true);
                        component.find("skuId").makeDisabled(true);
                    }
                    
                    
                    
                    this.reloadSOItems(component);
                    
                    this.fetchSKUData(component,event); 
                    
                    
                    
                }else{
                    var toastMsg = $A.get("$Label.c.Error_while_reloading_SO");
                    this.showErrorToast(component, event, toastMsg);
                }
                
                
            });
            
            $A.enqueueAction(action);
            
            
        }else{
            console.log('so id not found');
        }
        
    },
    
    
    
    
    //Logic to disable all fields when reload.
    disabledOnReload :function(component){
        var getProductId = component.find("itemproduct1");
        var orderItemList = component.get("v.orderItemList");
        var isProductArray = Array.isArray(getProductId);
        //console.log('disabledOnReload isProductArray '+isProductArray);
        if(orderItemList.length >=1){
            for (var idx=0; idx < orderItemList.length; idx++) {
                if(isProductArray){
                    var forClones = component.get("v.forClone");
                    if(forClones=='cloneOrder'){
                        component.find("deleteBtn")[idx].set("v.disabled",false);  
                    }else{
                        component.find("deleteBtn")[idx].set("v.disabled",true);
                    }
                    
                }else{
                    var forClones = component.get("v.forClone");
                    if(forClones=='cloneOrder'){
                        component.find("deleteBtn").set("v.disabled",false);
                    }else{
                        component.find("deleteBtn").set("v.disabled",true);
                    }
                    
                }
            }
        }
    },
    
    clubbingSKU1:function(component,event,orderItemList){
        console.log('orderItemList in clubbing SKU '+JSON.stringify(orderItemList));
        var ordItem = orderItemList;// compoent.get("v.orderItemList");
        var i;
        var qun_ltr = 0;
        var qun_ltr_amt = 0;
        var qun_kg = 0;
        var qun_kg_amt = 0;
        var qun_pac = 0;//Ticket No:RITM0412034 
        var qun_pac_amt = 0;
        
        console.log('ordItem in clubbing '+ordItem);
        
        for (i = 0; i < ordItem.length; i++) {
            var obj = new Object(ordItem[i]); 
            
            if(obj.UOM != null && obj.UOM != undefined && obj.UOM.toUpperCase() == 'L'){//nandhini
                
                qun_ltr = qun_ltr + parseFloat(obj.qty);
                qun_ltr_amt = qun_ltr_amt + parseFloat(obj.netValue);
            }//end of Liter
            else if(obj.UOM != null && obj.UOM != undefined && obj.UOM.toUpperCase() == 'KG'){//nandhini
                
                qun_kg = qun_kg + parseFloat(obj.qty);
                qun_kg_amt = qun_kg_amt + parseFloat(obj.netValue);
            }
            else if(obj.UOM != null && obj.UOM != undefined && obj.UOM.toUpperCase() == 'PAK'){//Ticket No:RITM0412034 //nandhini-changed to PAK
                qun_pac = qun_pac + parseFloat(obj.qty);
                qun_pac_amt = qun_pac_amt + parseFloat(obj.netValue);
            }
        }
        console.log('Quantity amount'+qun_kg_amt);
        
        component.set("v.net_price_litre",qun_ltr_amt.toFixed(2));
        component.set("v.quantity_litre",qun_ltr.toFixed(2));
        
        
        
        component.set("v.quantity_kg",qun_kg.toFixed(2));
        component.set("v.net_price_kg",qun_kg_amt.toFixed(2));
        
        component.set("v.quantity_pac",qun_pac.toFixed(2));//Ticket No:RITM0412034 
        component.set("v.net_price_pac",qun_pac_amt.toFixed(2));
        
    },
    
    
    loadCart : function(component,event){
        //console.log('in Load Cart Function');  
        var accId = component.get("v.recordId");
        var action = component.get("c.getCartOrderItems");
        //console.log('in Load cart accId '+accId);
        if(accId!=null){
            action.setParams({
                accId: accId
            });
            
            action.setCallback(this, function(a) {
                var state = a.getState();
                
                if(state == "SUCCESS") {
                    //console.log('succes Inside while loading Cart');
                    
                    var cartData = a.getReturnValue();
                    
                    //console.log('cartData '+cartData);
                    var cartLength =cartData.soiList.length;
                    console.log('@@ cartData.soiList '+cartData.soiList.productName);
                    component.set("v.orderItemList", cartData.soiList);
                    var orderItemList = component.get("v.orderItemList");
                    console.log('orderItemList in load Cart '+JSON.stringify(orderItemList));
                    
                    this.clubbingSKU1(component,event,orderItemList);
                    
                    
                    
                    
                    
                    console.log('orderItemList while Loading Cart '+JSON.stringify(orderItemList));
                    var orderObjId = cartData.cartOrderId;
                    
                    var grossNetPrice = Math.round(cartData.grossNetPrice * 100) / 100;
                    var incoTerm = cartData.incoTerm;
                    
                    if(orderItemList.length>0){
                        this.disabledAfterInsert(component,event);
                    }
                    if(orderObjId!=null && orderObjId!='' && orderObjId!= undefined){
                        component.set("v.orderObjId",orderObjId);
                        component.set("v.grossNetPrice",grossNetPrice); 
                        component.set("v.incoTrm",incoTerm);
                        
                        
                    }
                    
                    
                    
                }
                else{
                    var toastMsg = $A.get("$Label.c.Error_While_Loading_Cart");
                    this.showErrorToast(component, event, toastMsg);                      
                }
                
            });
            $A.enqueueAction(action);
            
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
    toggleMultipleOfDialog: function(component){
        var dialog = component.find("multipleOfDialog");
        $A.util.toggleClass(dialog, "slds-hide");
        
        var backdrop4 = component.find("backdrop4");
        $A.util.toggleClass(backdrop4, "slds-hide");
    },
    
    
    
    toggleshowModalBigLogDisDialog: function(component){
        console.log('in toggleshowModalBigLogDisDialog ');
        
        var dialog = component.find("bigVolLogisticDisc");
        $A.util.toggleClass(dialog, "slds-hide");
        
        var backdrop4 = component.find("backdrop4");
        $A.util.toggleClass(backdrop4, "slds-hide");
    },
    
    
    
    
    
    closePopUp: function(component) {
        this.toggle(component);
    },
    
    // Show Success Toast (Green)
    // Note: Shows a javascript alert in case the component is loaded within a visualforce page
    showToast : function(component, event, toastMsg) {
        component.set("v.toastFlag","setSuccess");
        var ss = component.set("v.sOId");
        console.log('ss sales order id '+ss);
        
        var toastEvent = $A.get("e.force:showToast");
        var success = $A.get("$Label.c.Success");
        // For lightning1 show the toast
        if (toastEvent!=undefined){
            //fire the toast event in Salesforce1
            console.log('in fisrt console ');
            toastEvent.setParams({
                title: success,
                mode: 'dismissible',
                type: 'success',
                message: toastMsg
            });
            toastEvent.fire();
        }
        else{ 
            console.log('insecond console ');
            try{
                sforce.one.showToast({
                    "title": success,
                    "message":toastMsg,
                    "type": "success"
                });
            }catch(err){
                component.set("v.flagMessage",toastMsg);
                console.log('errro occure in '+err);
                var x = document.getElementById("snackbar");
                x.className = "show";
                setTimeout(function(){ x.className = x.className.replace("show", ""); }, 3000); 
                //console.log('toastMsg'+toastMsg);
            }
        }
    },
    
    resetSingleOrderItem : function(component) { 
        var OrderItem = component.get("v.SingleOrderItem");
        
        if(OrderItem!=undefined && OrderItem!= null){
            component.set("v.SingleOrderItem.productName","") ;
            component.set("v.SingleOrderItem.qty","");
            component.set("v.SingleOrderItem.UOM","");
            component.set("v.paymenttrm","None");
            component.set("v.SingleOrderItem.basePrice","");
            
            component.set("v.SingleOrderItem.multipleOf","");
            component.set("v.SingleOrderItem.palletSize","");
            component.set("v.SingleOrderItem.earlyOrderDiscount","");
            component.set("v.SingleOrderItem.bigVolDiscount","");
            component.set("v.SingleOrderItem.manualDiscount","");
            component.set("v.SingleOrderItem.logisticDiscount","");
            component.set("v.SingleOrderItem.finalPrice","");
            component.set("v.SingleOrderItem.netValue","");
            component.set("v.SingleOrderItem.typeOfPayment","none");
            //This is for Inventory
            component.set("v.SingleOrderItem.inventory","");
            
            
        }
        
        
    },
    
    resetData:function(component){
        component.set("v.SingleOrderItem.productName","") ;
        component.set("v.SingleOrderItem.qty","");
        component.set("v.SingleOrderItem.UOM","");
        component.set("v.paymenttrm","None");
        component.set("v.SingleOrderItem.basePrice","");
        
        component.set("v.SingleOrderItem.multipleOf","");
        component.set("v.SingleOrderItem.palletSize","");
        component.set("v.SingleOrderItem.earlyOrderDiscount","");
        component.set("v.SingleOrderItem.bigVolDiscount","");
        component.set("v.SingleOrderItem.manualDiscount","");
        component.set("v.SingleOrderItem.logisticDiscount","");
        component.set("v.SingleOrderItem.finalPrice","");
        component.set("v.SingleOrderItem.netValue","");
        component.set("v.SingleOrderItem.typeOfPayment","none");
        //This is for Inventory
        component.set("v.SingleOrderItem.inventory","");
    },
    
    gettingDiscount:function(component,event,helper){
        //console.log('In getting discount ');
        var action = component.get('c.getdiscount'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                component.set('v.discountList', a.getReturnValue());
                var discountListTemp = a.getReturnValue();
                component.set('v.earlyOrderDisName', discountListTemp[0].earlyOrderDisName);
                component.set('v.startDate', discountListTemp[0].startDate);
                component.set('v.endDate', discountListTemp[0].endDate);
                component.set('v.discount', discountListTemp[0].discount);
                component.set('v.bigOrderDisName', discountListTemp[0].bigOrderDisName);
                component.set('v.paletQtydis', discountListTemp[0].paletQtydis);
                component.set('v.truckQtydis', discountListTemp[0].truckQtydis);
                
                
            }
        });
        $A.enqueueAction(action);
    },
    
    //update calculation of "Add product" row.
    updateRowCalculations1 : function(component, event, helper,qty){
        if(qty>0){
            
            console.log('in calculation on qty changed '+qty);
            
            var isRegularCustomer = component.get("v.isRegularCustomer");
            var isNonRegularCustomer = component.get("v.isNonRegularCustomer");
            var isDistributor = component.get("v.isDistributor");
            //console.log('isRegularCustomer '+isRegularCustomer);
            if(isRegularCustomer || isDistributor ){
                
                var palletSize = component.get("v.SingleOrderItem.palletSize");
                var logisticDis = component.get("v.SingleOrderItem.logisticDiscount");
                
                
                
                var truckSize = component.get("v.SingleOrderItem.truckSize");
                
                
                var stDate = Date.parse(component.get("v.startDateforBigVol"));
                var edDate = Date.parse(component.get("v.endDateforBigVol"));
                console.log('stDate in big vol '+stDate);
                
                var currentDate = new Date();
                
                var pCurdate = Date.parse(currentDate);
                
                
                var oneDiscount;
                var twoDiscount
                
                
                if(pCurdate>=stDate && pCurdate<=edDate){
                    console.log('inside big vol date ');
                    oneDiscount = component.get("v.oneBigDiscount");
                    twoDiscount = component.get("v.twoBigDiscount");
                    
                }else{
                    console.log('outside big vol date ');
                    oneDiscount = 0;
                    twoDiscount = 0;
                }
                
                
                console.log('weww oneDiscount '+oneDiscount);
                console.log('weww twoDiscount '+twoDiscount);
                
                //var oneDiscount = component.get("v.paletQtydis");
                //var twoDiscount = component.get("v.truckQtydis");
                
                var BigVolumeforPallet = component.get("v.SingleOrderItem.Big_Volume_for_Pallet");
                var BigVolumeforTruck = component.get("v.SingleOrderItem.Big_Volume_for_Truck");
                
                
                //var oneDiscount = component.get("v.paletQtydis");
                //var twoDiscount = component.get("v.truckQtydis");
                
                console.log('in  @@@@ truckSize '+truckSize);
                console.log('in  @@@@ palletSize '+palletSize);
                console.log('in  @@@@ BigVolumeforPallet '+BigVolumeforPallet);
                console.log('in  @@@@ BigVolumeforTruck '+BigVolumeforTruck);
                
                
                
                
                if(BigVolumeforPallet=='Yes' && BigVolumeforTruck=='Yes'){
                    console.log('$$$ in first by excel condition ');
                    console.log('in third condition palletSize '+palletSize);
                    console.log('in third condition truckSize '+truckSize);
                    if(qty>=palletSize && qty<truckSize){
                        //getting 1% discount
                        component.set("v.SingleOrderItem.bigVolDiscount",oneDiscount);
                    }else if(qty>=palletSize && qty>=truckSize){
                        component.set("v.SingleOrderItem.bigVolDiscount",twoDiscount);
                    }else{
                        component.set("v.SingleOrderItem.bigVolDiscount",0);
                    }
                    
                }
                
                if(BigVolumeforPallet=='Yes' && BigVolumeforTruck=='No'){
                    console.log('$$$ in Second by excel Conditon');
                    
                    if(qty>=palletSize ){
                        //getting 1% discount
                        component.set("v.SingleOrderItem.bigVolDiscount",oneDiscount);
                    }
                    else{
                        component.set("v.SingleOrderItem.bigVolDiscount",0);
                    }
                    
                }
                
                
                if(BigVolumeforPallet=='No' && BigVolumeforTruck=='Yes' ){
                    console.log('$$$ in third by Excel Conditon ')
                    if(qty>=truckSize ){
                        //getting 1% discount
                        component.set("v.SingleOrderItem.bigVolDiscount",twoDiscount);
                    }
                    else{
                        component.set("v.SingleOrderItem.bigVolDiscount",0);
                    }
                    
                }
                
                if(BigVolumeforPallet=='No' && BigVolumeforTruck=='No' ){
                    console.log('$$$ in fourth by Excel Conditon ');
                    component.set("v.SingleOrderItem.bigVolDiscount",0);
                }
                
                if(BigVolumeforPallet==undefined && BigVolumeforTruck=='Yes'){
                    console.log('$$$ in Fifth by Excel Conditon');
                    if(qty>=truckSize){
                        component.set("v.SingleOrderItem.bigVolDiscount",twoDiscount);
                    }else{
                        component.set("v.SingleOrderItem.bigVolDiscount",0);
                    }
                    
                }
                
                if(BigVolumeforPallet==undefined && BigVolumeforTruck=='No'){
                    console.log('$$$ in Sixth by excel Conditon');
                    component.set("v.SingleOrderItem.bigVolDiscount",0);
                }
                
                
                if(BigVolumeforPallet=='Yes' && BigVolumeforTruck==undefined){
                    console.log('$$$ in seventh by excel Conditon');
                    if(qty>=palletSize){
                        component.set("v.SingleOrderItem.bigVolDiscount",oneDiscount);
                    }else{
                        component.set("v.SingleOrderItem.bigVolDiscount",0);
                    }
                }
                
                
                if(BigVolumeforPallet=='No' && BigVolumeforTruck==undefined){
                    console.log('$$$ in eighth by excel Conditon');
                    component.set("v.SingleOrderItem.bigVolDiscount",0);
                    
                } 
                
                
                
                
                
                
                
                // console.log('After updtae big vol discount ');
                
                //calculating Logistic Discount
                var inctmcode = component.get("v.incoTrm1");
                //console.log('inctmcode in qty '+inctmcode);
                var logDiscount = 0;
                if(inctmcode == 'EXW'){
                    //calculate Logistic Discount
                    console.log(' in production prodlogisticDis '+logisticDis);
                    if(logisticDis!=undefined){
                        logDiscount = logisticDis;    
                    }else{
                        logDiscount = 0;
                    }
                    
                    
                }else{
                    logDiscount = 0;
                }
                component.set("v.SingleOrderItem.logisticDiscount",logDiscount); 
                //calulating Net value
                
                
                
                var bsPrice = component.get("v.SingleOrderItem.basePrice");
                var earlyDiscount = component.get("v.SingleOrderItem.earlyOrderDiscount");
                var bigVolDiscount = component.get("v.SingleOrderItem.bigVolDiscount");
                var manualDiscount = component.get("v.SingleOrderItem.manualDiscount");
                var logisticDiscount = component.get("v.SingleOrderItem.logisticDiscount");
                
                
                console.log('quntity changed after bsPrice '+bsPrice);
                console.log('quntity changed after earlyDiscount '+earlyDiscount);
                console.log('quntity changed after bigVolDiscount '+bigVolDiscount);
                console.log('quntity changed after manualDiscount '+manualDiscount);
                console.log('quntity changed after logisticDiscount '+logisticDiscount);
                
                var tmpbsPrice ;
                if(bsPrice!=null){
                    tmpbsPrice = bsPrice;
                }else{
                    tmpbsPrice = 0;
                }
                
                var tmpearlyDiscount;
                if(earlyDiscount!=null){
                    tmpearlyDiscount = earlyDiscount;
                }else{
                    tmpearlyDiscount = 0;
                }
                
                var tmpbigVolDiscount;
                if(bigVolDiscount!=null){
                    tmpbigVolDiscount = bigVolDiscount;
                }else{
                    tmpbigVolDiscount = 0;
                }
                
                var tmpmanualDiscount;
                if(manualDiscount!=undefined){
                    tmpmanualDiscount = manualDiscount; 
                }else{
                    tmpmanualDiscount = 0;
                }
                
                var tmplogisticDiscount;
                if(logisticDiscount!=null){
                    tmplogisticDiscount =logisticDiscount;
                }else{
                    tmplogisticDiscount =0;
                }
                
                console.log('after done tmp varible tmpbsPrice '+tmpbsPrice);
                console.log('after done tmp varible tmpearlyDiscount '+tmpearlyDiscount);
                console.log('after done tmp varible tmpbigVolDiscount '+tmpbigVolDiscount);
                console.log('after done tmp varible tmpmanualDiscount '+tmpmanualDiscount);
                console.log('after done tmp varible tmplogisticDiscount '+tmplogisticDiscount);
                
                
                
                var finalPrice = 0.0;
                finalPrice =(tmpbsPrice -(tmpbsPrice*tmpbigVolDiscount/100));//tmpearlyDiscount
                finalPrice = Math.round((finalPrice + Number.EPSILON) * 100) / 100;
                console.log('After calculation of Early order Discount '+finalPrice);
                
                finalPrice = (finalPrice - (finalPrice*tmpmanualDiscount/100));//tmpbigVolDiscount
                finalPrice = Math.round((finalPrice + Number.EPSILON) * 100) / 100;
                console.log('After calculation of Big Vol discount '+finalPrice);
                
                finalPrice = (finalPrice - (finalPrice*tmpearlyDiscount/100));//tmpmanualDiscount
                finalPrice = Math.round((finalPrice + Number.EPSILON) * 100) / 100;
                console.log('After calculation of Manual Discount '+finalPrice);
                
                if(finalPrice >0){//nandhini
                    finalPrice = (finalPrice - tmplogisticDiscount);//tmplogisticDiscount
                }                
                finalPrice = Math.round((finalPrice + Number.EPSILON) * 100) / 100;
                console.log('After calculation of Logistic Discount '+finalPrice);
                
                component.set("v.SingleOrderItem.finalPrice",finalPrice);
                var netValue = (finalPrice *qty).toFixed(2);
                //finish
                component.set("v.SingleOrderItem.netValue",netValue);
                component.set("v.SingleOrderItem.qty",qty.toFixed(2));
                // }
            }//regular customer end
            
            if(isNonRegularCustomer){
                var bsPrice = component.get("v.SingleOrderItem.basePrice");
                var qty = component.get("v.SingleOrderItem.qty");
                var manualDiscount = component.get("v.SingleOrderItem.manualDiscount");
                
                console.log('for Non regular base Price '+bsPrice);
                console.log('for Non regular qty '+qty);
                console.log('for Non regular manualDiscount '+manualDiscount);
                var qty1 ; 
                if(qty==undefined){
                    qty1= 0; 
                }else{
                    qty1=qty;
                }
                var manualDiscount1;
                if(manualDiscount==undefined){
                    manualDiscount1 =0;
                }else{
                    manualDiscount1 =manualDiscount;  
                }
                var bsPrice1;
                if(bsPrice==undefined){
                    bsPrice1= 0;
                }else{
                    bsPrice1=bsPrice;
                }
                
                var finalPrice =0;
                var netValue =0;
                finalPrice = (bsPrice1 - (bsPrice1*manualDiscount1/100));
                finalPrice = Math.round((finalPrice + Number.EPSILON) * 100) / 100;
                component.set("v.SingleOrderItem.finalPrice",finalPrice);
                netValue = (finalPrice* qty1).toFixed(2);
                component.set("v.SingleOrderItem.netValue",netValue);
                component.set("v.SingleOrderItem.manualDiscount",manualDiscount1);
                component.set("v.SingleOrderItem.qty",qty1.toFixed(2));
                
            }
            
            
            
            
        }//end of first condition
    },
    
    getInctrmCode : function(component,event,helper,inctcode){
        //console.log('Inside hlepr inco term '+inctcode);
        //calling apex Method
        var action = component.get('c.getincotermCode'); 
        
        action.setParams({
            "incode" : inctcode
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                var retnCode = a.getReturnValue();
                //console.log('retnCode in helpwe calling apex method  '+retnCode);
                component.set('v.incoTrm1', a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    //Logic to validate calculation of single order item
    validateSingleOrderItem :function(component){
        try{
            var orderItemList = component.get("v.orderItemList");
            var orderItem = component.get("v.SingleOrderItem");
            
            var getQtyId = component.find("itemqty1"); 
            var getpaymentTerm = component.get("v.SingleOrderItem.typeOfPayment");
            var bsPrice = component.get("v.SingleOrderItem.basePrice");
            var temppb = component.get("v.selectedPBRecord");//nandhini
            
            var toastMsg = '';
            var flag = true;
            
            //this is for Base Price validation
            
            if((!bsPrice || bsPrice =='0') && !temppb.SKUCode__r.SKU_Code__c.includes('6061000')){//nandhini
                flag = false;
                component.find("basePricesingle").set("v.errors",[{message: $A.get("$Label.c.Please_enter_Base_Price")}]);
            }else{
                component.find("basePricesingle").set("v.errors",null);
                
            }
            
            if(!getQtyId.get("v.value") || getQtyId.get("v.value") == '0') {
                flag = false;
                component.find("itemqty1").set("v.errors",[{message: $A.get("$Label.c.Please_enter_Quantity")}]);  
            }
            else{
                component.find("itemqty1").set("v.errors",null);
            }
            //console.log('Inside 3');
            console.log('getpaymentTerm while adding to the cart '+getpaymentTerm);
            if(getpaymentTerm =='none'){
                flag = false;
                console.log('inside 4 getpaymentTerm while adding to the cart');
                this.showErrorToast(component, event, $A.get("$Label.c.Please_select_Payment_Term"));
                //component.find("paymentTermListOptions").set("v.errors",[{message: $A.get("$Label.c.Please_select_Payment_Term")}]);  
            }
            else{
                //  console.log('inside 5');
                component.find("paymentTermListOptions").set("v.errors","");
            }
            
            //console.log('Inside 6');
            return flag;
            
        }catch(err){
            
            console.log('@@@@@@ error: '+err);
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
                type: 'error',
                message: toastMsg
            });
            toastEvent.fire();
        }
        else{
            console.log('inside errorsss toast display ');
            try{
                sforce.one.showToast({
                    "title": error,
                    "message":toastMsg,
                    "type": "error"
                });}catch(err){
                    var forClones = component.get("v.forClone");
                    if(forClones=='cloneOrder'){ 
                        var tmpmsg = $A.get("$Label.c.Please_enter_Quantity_for_each_Product_Item");
                        component.set("v.showsnackbarclone",true);
                        component.set("v.flagMessageforClone",tmpmsg);
                        setTimeout(function(){ component.set("v.showsnackbarclone",false); }, 3000);
                        
                    }else{
                        
                        console.log('inside other order error toast');
                        var errorMsg = component.find("errorMsg");
                        component.set("v.flagMessage",toastMsg);
                        var x = document.getElementById("snackbar");
                        x.className = "show";
                        setTimeout(function(){ x.className = x.className.replace("show", ""); }, 3000);
                    }
                    
                }
        }
        
    },
    
    
    
    createOrder : function(component,event,helper) { 
        var isValidItems = this.validateSingleOrderItem(component);
        //console.log('isValidItems '+isValidItems);
        var newSO = component.get("v.newSalesOrder");
        var newOrder = component.get("v.newOrder");
        var orderItem = component.get("v.SingleOrderItem");
        var orderItemList = component.get("v.orderItemList");
        var accID = component.get("v.recordId");
        var orderObjId = component.get("v.orderObjId");
        
        var errorMessage ='';
        var soId = component.get("v.sOId");
        
        if(soId==null || soId==undefined){
            //if sales Order is already created
            //console.log('Inside creation of Order ');
            var paymentTerm = component.get("v.paymenttrm");
            var incoTerm = component.get("v.incoTrm");
            
            console.log('JSON dsd in '+JSON.stringify(orderItem));
            
            if(isValidItems){
                var toastMsg = '';
                var action;
                action = component.get("c.saveOrder");
                action.setParams({ 
                    "accountId": accID,
                    "OrderItemString":JSON.stringify(orderItem),
                    "orderObjId":orderObjId,
                    "PaymentTerm":paymentTerm,
                    "incoTerm":incoTerm,
                    "orderItemListString": null
                });
                // show spinner to true on click of a button / onload
                component.set("v.showSpinner", true); 
                action.setCallback(this, function(a) {
                    // on call back make it false ,spinner stops after data is retrieved
                    component.set("v.showSpinner", false);
                    var state = a.getState();
                    if (state == "SUCCESS") {                        
                        errorMessage = a.getReturnValue().errorMessage;
                        if(errorMessage!=''&& errorMessage!=null) {
                            toastMsg = errorMessage;
                            this.showErrorToast(component, event, toastMsg);
                        }else{
                            var orderObjId = a.getReturnValue().cartOrderId;
                            //console.log('orderObjId '+orderObjId);
                            if(orderObjId!=null && orderObjId!='' && orderObjId!= undefined){
                                component.set("v.orderObjId",orderObjId);
                            }
                            orderItemList.push(a.getReturnValue().soitemObj);
                            
                            //console.log('orderItemList After adding '+orderItemList);
                            component.set("v.orderItemList", orderItemList);
                            
                            var retuValue = component.get("v.orderItemList");
                            console.log('retuValue @@@@  '+JSON.stringify(retuValue));
                            //nandhini
                            var temppb = component.get("v.selectedPBRecord");
                            helper.getDependentLineItem(component, event, helper);

                            this.updateRowCalculations(component, event, helper);
                            //this.resetSingleOrderItem(component);
                            this.resetData(component);
                            this.resetPBObj(component,event,helper);
                            this.disabledAfterInsert(component, event);
                            this.clubbingSKU(component,event,helper);
                            
                            component.set("v.showBasePriceCartformat",false);
                            component.set("v.showBasePriceCartformat1",true);
                            component.set("v.showQtyCartformat",false);
                            component.set("v.showQtyCartformat1",true);
                            
                        }
                        
                    }else{
                        toastMsg = $A.get("$Label.c.Some_error_has_occurred_while_Confirming_Order_Please_try_again");
                        this.showErrorToast(component, event, toastMsg);   
                    }
                    
                });
                $A.enqueueAction(action);
            }
            
        }else{
            console.log('Inside addTableRow function');
            this.addTableRow(component,helper,isValidItems,soId);
        }
        
    },
    
    
    
    
    
    addTableRow : function(component,helper,isValidItems,soId){
        var orderItemList = component.get("v.orderItemList");
        var orderItem = component.get("v.SingleOrderItem");
        console.log('orderItem '+JSON.stringify(orderItem));
        
        var toastMsg = '';
        if(isValidItems){
            orderItemList.push(orderItem);
            component.set("v.orderItemList", orderItemList);
            this.resetPBObj(component,event,helper);
            var salesorderId = component.get("v.sOId");
            if(salesorderId!=undefined){
                component.set("v.showSingleLineItemforSO",true);
                component.set("v.showSingleLineItemforSO1",false);
            }
            
            
            
        }
        
        
        
    },
    
    
    //Updating row when Qty and Final price changes.
    updateRowCalculations : function(component, event, helper){
        var rowIndex = component.get("v.rowIndex");
        var soId = component.get("v.sOId");
        var orderItemList = component.get("v.orderItemList");
        var totalNetGross=0.0;
        if(rowIndex==undefined){
            rowIndex = orderItemList.length;
        }
        //console.log('rowIndex'+rowIndex);
        //console.log('orderItemList.length '+orderItemList.length);
        
        
        for (var idx = 0; idx < orderItemList.length; idx++) {
            //console.log('orderItemList[idx].netValue '+orderItemList[idx].netValue);
            totalNetGross = totalNetGross + orderItemList[idx].netValue;
        }
        //console.log(' @@@ totalNetGross '+totalNetGross); 
        component.set("v.grossNetPrice",totalNetGross);
    },
    
    
    disabledAfterInsert  :function(component, event){
        var getProductId = component.find("itemproduct1");
        var orderItemList = component.get("v.orderItemList");
        var isProductArray = Array.isArray(getProductId);
        if(orderItemList.length >=1){
            component.find("incoTermListOptions").set("v.disabled",true);
        }else{
            component.find("incoTermListOptions").set("v.disabled",false);
        }
        
        
    },
    
    
    //Logic to delete Order Items
    deleteOrderItem :function(component, event, oliId,orderId,itemsLength,index){
        
        console.log('oliId in helper '+oliId);
        
        var action = component.get('c.deleteOItem');
        
        //below added by nandhini          
        var items = component.get("v.orderItemList");  
        var itemsLength=items.length;
        var oliIds = [];
        
        oliIds.push(oliId);
        if(items[index].skuCode != undefined && items[index].skuCode != ''){
            let skucode = items[index].skuCode;
            console.log('SKU Code =>> '+skucode);
            if((items[index].skuCode.includes('6280610') && items[index].PAK == true)|| (items[index].skuCode.includes('6060697') && items[index].PAK == true) || (items[index].skuCode.includes('6061000'))){
                console.log('Delete depended SKU');
                let data = items.filter(record => (record.PAK == true || record.skuCode.includes('6061000')));
               
                data.forEach(each=>{
                    if(!oliIds.includes(each.oliId))
                    {
                    oliIds.push(each.oliId);
                   
                }
                })

            }
        }
        console.log('filtered oliIds Data',oliIds);
        oliIds.forEach(item=>{
          //  items.splice(items.indexOf(item), 1);
          items.splice(items.findIndex(obj => obj.oliId==item), 1);
        })
        action.setParams({
            "oliId" : oliIds,
            "orderId" : orderId,
            "itemsLength" : itemsLength
            
        });
        action.setCallback(this, function(a){
            var state = a.getState();
            if(state == 'SUCCESS') {
                var errorMessage;
                errorMessage = a.getReturnValue().errorMessage;
                if(errorMessage!=''&& errorMessage!=null) {
                    toastMsg = errorMessage;
                    this.showErrorToast(component, event, toastMsg);
                }
                this.resetSingleOrderItem(component);
            }else{
                var toastMsg =  $A.get("$Label.c.Error_While_Deleting_Item_Please_Contact_System_Administrator");
                this.showErrorToast(component, event, toastMsg);
            }
        });
        $A.enqueueAction(action);
        
    },
    
    //Logic to validate Order data
    validateOrder: function(component){
        var flag = true;
        var toastMsg = '';
        var shippListOptions = component.find("shippListOptions");
        var incoTermListOptions = component.find("incoTermListOptions");
        var poNumber = component.find("poNumber");
        var poDate = component.get("v.newSalesOrder.Purchase_Order_Date__c"); // SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022..
        
        
        //console.log('shippListOptions '+shippListOptions);
        //console.log('incoTermListOptions '+incoTermListOptions);
        var inctrn = component.get("v.incoTrm1");
        
        if(shippListOptions){
            if((!shippListOptions.get("v.value") || shippListOptions.get("v.value") == 'None') && inctrn!='EXW'){
                flag = false;
                component.find("shippListOptions").set("v.errors",[{message:$A.get("$Label.c.Please_Select_shipping_location")}]); 
                $A.util.addClass(shippListOptions, "error");
            }
        }
        if(incoTermListOptions){
            if(!incoTermListOptions.get("v.value") || incoTermListOptions.get("v.value") == 'None'){
                flag = false;
                component.find("incoTermListOptions").set("v.errors",[{message:$A.get("$Label.c.Please_Select_Inco_Terms")}]); 
                $A.util.addClass(incoTermListOptions, "error");
            }
        }
        
        if(poNumber){
            if(!poNumber.get("v.value") || poNumber.get("v.value") == 'None'){
                flag = false;
                component.find("poNumber").set("v.errors",[{message:$A.get("$Label.c.Please_Enter_PO_Number")}]); 
                $A.util.addClass(poNumber, "error");
            }
        }
        
        /* ------------------- Start SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022 -------------- */
        var poDateRequired = component.get("v.loginCountryObjs.PO_Date__c");
        if(poDate==undefined && poDateRequired==true){
            component.set("v.showsnackbarclone1",true);
            var toastMsg1 = 'please select PO Date';
            component.set("v.flagMessageforClone1",toastMsg1);
            setTimeout(function(){ component.set("v.showsnackbarclone1",false); }, 3000);
            flag = false;
            
        }
        /* ----------------- End SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022 ------------------ */
        return flag; 
    },
    
    
    //Validate Order Items
    validateOrderItems: function(component){
        try{
            var orderItemList = component.get("v.orderItemList");
            var getProductId = component.find("itemproduct1");
            var getQtyId = component.find("itemqty");
            var getBasePrice = component.find("basePriceCart");
            var getManualDiscount = component.find("manualDiscountCart");  
            var ptmTerm = component.find("paymentTermListOptions1"); 
            var toastMsg = '';
            var flag = true;
            var sumOfQty=0;
            if(orderItemList.length <= 0){
                flag = false;
            }else if(orderItemList.length > 0){
                var isProductArray = Array.isArray(getProductId);
                for(var i = 0; i <orderItemList.length; i++){
                    console.log('cheking qty while placing order '+orderItemList[i].qty);
                    if(!orderItemList[i].qty || orderItemList[i].qty == '0') {
                        console.log('quantity null inside ');
                        var msg =$A.get("$Label.c.Please_enter_Quantity");
                        // this.showToastForClone(msg);
                        // component.find("itemqty")[i].set("v.errors",[{message: $A.get("$Label.c.Please_enter_Quantity")}]);
                        flag = false;
                    }
                    else{
                        console.log('quantity null outside ');
                        //component.find("itemqty")[i].set("v.errors",0); 
                    }
                    
                    
                    // for validation of base price in cart
                    
                    //APPS-2521-Nandhini
                    if((!orderItemList[i].basePrice || orderItemList[i].basePrice == '0') && (!orderItemList[i].skuDescription.includes('6061000') && !orderItemList[i].skuCombinationKey.includes('6061000'))) {
                        //component.find("basePriceCart")[i].set("v.errors",[{message: $A.get("$Label.c.Please_enter_Base_Price")}]);;
                        flag = false;
                    }else{
                        //component.find("basePriceCart")[i].set("v.errors",0); 
                    }
                    
                    
                    
                    
                    if(orderItemList[i].typeOfPayment == 'none'){
                        // orderItemList[i].typeOfPayment[i].set("v.errors",[{message: $A.get("$Label.c.Please_select_Payment_Terms")}]);;
                        flag = false;
                    }else{
                        // orderItemList[i].typeOfPayment[i].set("v.errors",'');  
                    }
                    
                    
                    
                    
                }//end of for Loop
                
                
                
            }
            return flag;
        }
        catch(err){
            console.log('error: '+err);
        }
        
    },
    
    
    //Logic to Redirect sales order after creation
    gotoURL : function(component, recordId) {
        var device = $A.get("$Browser.formFactor");
        var recrdId = recordId;
        console.log('recordId dsadaswwdad '+recordId);
        
        if(device=='DESKTOP'){
            try{
                sforce.one.navigateToSObject(recordId);
                //  sforce.one.navigateToList('00B0k000001YexGEAS',null,"Sales_Order__c");
            }catch(err){
                console.log('catch');
                // sforce.one.navigateToList('00B0k000001YexGEAS',null,"Sales_Order__c");
                this.navigateToComponent(component,recrdId);
            }
        }
        else{
            //console.log('else url'+recordId);
            //Redirect to Standard ListView when placing orders in SF1.
            // this.navigateToComponent(component,recordId);
            //added by Vaishnavi Ahirrao-check is this related to CR-APPs2521
            if((window.location.href).includes('/s/')){
                var url= (window.location.href).split('/s/')[0];
                var baseURL='';
                baseURL = url+ '/s/detail/'+recordId;
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": baseURL
                });
                urlEvent.fire();
            }else{
                sforce.one.navigateToSObject(recordId);
            }
            
        }
    },
    
    //Called through "gotoURL" method
    navigateToComponent: function(component,recrdId){
        var navEvent = $A.get("e.force:navigateToSObject");
        if(navEvent!=undefined){
            
            navEvent.setParams({
                "recordId": recrdId,
                // "slideDevName": related
            });
            navEvent.fire();    
            
        }
        else{
            window.history.back();
        }
    },
    
    
    
    createSalesOrder : function(component, event, status) {
        var salesOrderId = component.get("v.sOId"); 
        var grossNetPrice = component.get("v.grossNetPrice");
        
        component.set("v.newSalesOrder.Sales_Order__c",salesOrderId);
        component.set("v.newSalesOrder.Total_Amount__c",grossNetPrice);
        console.log('Total Amount : '+grossNetPrice);
        var orderItemList = component.get("v.orderItemList");
        console.log('WWWWWW orderItemList  '+orderItemList);
        var isValid = this.validateOrder(component); 
        var isValidItemsTemp = true;
        var isValidItems = this.validateOrderItems(component);
        //console.log('isValid '+isValid);
        
        if(isValidItems){
            console.log('isValidItems inside true '+isValidItems);
            isValidItemsTemp = true;
        }else{
            console.log('isValidItems inside false '+isValidItems);
            isValidItemsTemp = false;
            var toastMsgtmp ='';
            toastMsgtmp = $A.get("$Label.c.Please_Enter_Required_data_in_the_cart");
            this.showErrorToast(component, event, toastMsgtmp);
            
        }
        if(isValidItemsTemp){
            if(isValid){
                var toastMsg = '';
                
                component.set("v.newSalesOrder.Total_Amount__c",grossNetPrice);
                var newSO = component.get("v.newSalesOrder");
                
                var kamWholeMgr = component.get("v.isKAMWholesManager"); 
                if(kamWholeMgr){
                    component.set("v.newSalesOrder.Price_Book_Type__c","Common Pricebook");
                }else{
                    component.set("v.newSalesOrder.Price_Book_Type__c","Customer Wise Pricebook");
                }
                var action;
                if(status=="Pending") {
                    component.set("v.newSalesOrder.Order_Status__c","Pending");
                    component.set("v.disableThis", true);
                }
                
                
                action = component.get("c.saveSalesOrder");
                var incoTermId = component.get("v.incoTrm");
                var forClones = component.get("v.forClone");
                var poDate  = component.get("v.newSalesOrder.Purchase_Order_Date__c"); // SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022..
                
                
                action.setParams({ 
                    "soObj": newSO,
                    "salesOrderItemString": JSON.stringify(orderItemList),
                    "incoTermId":incoTermId,
                    "forCloneOrders":forClones,
                    "poDate":poDate // SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022...
                });
                
                // show spinner to true on click of a button / onload
                component.set("v.showSpinner", true);   
                action.setCallback(this, function(a) {
                    // on call back make it false ,spinner stops after data is retrieved
                    component.set("v.showSpinner", false);                
                    var state = a.getState();
                    
                    if (state == "SUCCESS"){
                        
                        var salesOrderIds = a.getReturnValue().createdsalesOrderList;
                        var recordId = a.getReturnValue().createdsalesOrderList[0];
                        var saleOrdeName = a.getReturnValue().salesOrderName;
                        
                        console.log('saleOrdeName '+saleOrdeName);
                        
                        var ordNo = '';
                        
                        var ordIds =[];
                        
                        for(var i=0; i<salesOrderIds.length; i++){
                            ordIds = salesOrderIds[i];
                        }
                        
                        
                        component.set("v.parentId",ordIds);
                        
                        for(var j=0; j<saleOrdeName.length; j++){
                            if(j == 0){
                                ordNo = saleOrdeName[j];
                            }
                            else{
                                ordNo = ordNo + ','+ saleOrdeName[j];
                            }
                            console.log('ordNo >> '+ordNo);   
                        }
                        if(kamWholeMgr==true){
                            console.log('kamWholeMgr >>>>>>>>>.' +kamWholeMgr);
                             //nandhini
                            var fileLen = component.find("fileId");
                            if(fileLen != null && fileLen != undefined){
                                fileLen = component.find("fileId").get("v.files");
                                if(fileLen != null){
                                    if(fileLen.length > 0) {
                                        console.log('fileLen.length >>>>>>>>>.' +fileLen.length);
                                        //component.set("v.parentId",ordIds); 
                                        console.log('@1795');
                                        this.uploadHelper(component, event);
                                        console.log('uploadHelper >>>');
                                    }
                                }
                            }
                            
                        }
                            
                        //changes made by Srinivas for the ticket RITM0328841
                        if(kamWholeMgr==true){
                            console.log('kamWholeMgr >>>>>>>>>.' +kamWholeMgr);
                            //nandhini
                            var fileLen1 = component.find("fileId1");
                            if(fileLen1 != null && fileLen1 != undefined){
                                fileLen1 = component.find("fileId1").get("v.files");
                                if(fileLen1 != null){
                                    if(fileLen1.length > 0) {
                                        //component.set("v.parentId",ordIds); 
                                        console.log('@1807');
                                        this.uploadHelper1(component, event);
                                    }
                                }
                            }
                            
                        }
                            
                        //RITM0328841
                        if(kamWholeMgr==true){
                            var fileLen2 = component.find("fileId2"); 
                            //nandhini
                            if(fileLen2 != null && fileLen2 != undefined){
                                fileLen2 = component.find("fileId2").get("v.files");
                                if(fileLen2 != null){
                                    if(fileLen2.length > 0) {
                                        //component.set("v.parentId",ordIds); 
                                        console.log('@1817');
                                        this.uploadHelper2(component, event);
                                    }
                                }
                            }

                            
                        }

                        //changes made by Srinivas for the ticket RITM0328841
                        if(kamWholeMgr==false){
                            //code here
                            var fileId3 = component.find("fileId3"); 
                            if(fileId3 != null && fileId3 != undefined){
                                var fileLen3 = component.find("fileId3").get("v.files");
                                if(fileLen3 != null && fileLen3 !=undefined){
                                    if(fileLen3.length > 0) {
                                        //component.set("v.parentId",ordIds); 
                                        console.log('@1832');
                                        this.uploadHelper3(component, event);
                                    }
                                }
                            }
                        }
                        
                        toastMsg = ordNo+' '+$A.get("$Label.c.Sales_Order_Created_Successfully");
                        
                        //Execute to save order on Submit button
                                               
                        //sri
                        this.showToast(component, event, toastMsg);
                        // alert("Order placed successfully"+ ordNo);
                        //confirm("Order placed successfully"+ordNo);
                        this.saveOrderTemplates(component,event);
                        
                        var proTemp = component.get("v.isDistributor");
                        if(proTemp){
                            console.log('Redircetion Issue '+recordId); 
                            //this is for UPL test
                            // window.location.href = "https://upltest-upl.cs57.force.com/Distributor/s/detail/"+recordId;
                            //this is for UAT
                            //window.location.href = "https://uat-upl.cs117.force.com/Distributor/s/detail/"+recordId;
                            //window.location.href = "https://uat-upl.cs72.force.com/Distributor/s/detail/"+recordId;
                            //this is for 
                            //changes added by Vaishnavi -check is this related to APPS 2521
                            if((window.location.href).includes('/s/')){
                                var url= (window.location.href).split('/s/')[0];
                                var baseURL='';
                                baseURL = url+ '/s/detail/'+recordId;
                                var urlEvent = $A.get("e.force:navigateToURL");
                                urlEvent.setParams({
                                    "url": baseURL
                                });
                                urlEvent.fire();
                            }else{
                                if((window.location.href).includes('uplpartnerportalstd')){
                                    window.location.href = "https://upl--uat.sandbox.my.site.com/uplpartnerportalstd/s/detail/"+recordId;
                                }else{
                                    window.location.href = "https://upl--uat.sandbox.my.site.com/customers/s/detail/"+recordId;
                                }
                            }
                            
                        }else{
                            this.gotoURL(component, recordId);     
                        }
                        
                    }else{
                        toastMsg = $A.get("$Label.c.Some_error_has_occurred_while_Confirming_Order_Please_try_again");
                        
                        this.showErrorToast(component, event, toastMsg);   
                        
                    }
                });
                $A.enqueueAction(action);
                
            }else{
                toastMsg = $A.get("$Label.c.Please_provide_valid_input_fill_all_the_mandatory_fields_before_proceeding");
                this.showErrorToast(component, event, toastMsg);
                
                
            }
        }
        
        
    },
    
    
    saveOrderTemplates:function(component,event){
        console.log('In saveOrderTemplates method ');
        var checkBoxTrue = component.get("v.saveOrderTemplateCheck");
        if(checkBoxTrue){
            var action = component.get('c.saveTemplate'); 
            console.log('in save Template method acc id is'+component.get('v.recordId'));
            
            action.setParams({
                "accId" : component.get("v.recordId"),
                "lineItem" :JSON.stringify( component.get("v.orderItemList")),
                "templateName":component.get("v.repeatOrderName"),
                "incoTerm":component.get("v.incoTrm")
            });
            action.setCallback(this, function(a){
                var state = a.getState(); // get the response state
                if(state == 'SUCCESS') {
                    //component.set('v.sObjList', a.getReturnValue());
                }
            });
            $A.enqueueAction(action);
        }
        
        
    },
    
    
    uploadHelper: function(component, event) {
        
        component.set("v.showSpinner", true);
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fileId").get("v.files");
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function 
        
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.showSpinner", false);
            component.set("v.fileName", $A.get("{!$Label.c.Alert_File_size_cannot_exceed}") + self.MAX_FILE_SIZE + $A.get("{!$Label.c.bytes}") + '.\n' + $A.get("{!$Label.c.Selected_file_size}") +': ' + file.size);
            return;
        }
        
        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object  
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents);
        });
        
        objFileReader.readAsDataURL(file);
        
    },
    
    uploadHelper1: function(component, event) {
        
        component.set("v.showSpinner", true);
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fileId1").get("v.files");
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function 
        
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.showSpinner", false);
            component.set("v.fileName", $A.get("{!$Label.c.Alert_File_size_cannot_exceed}") + self.MAX_FILE_SIZE + $A.get("{!$Label.c.bytes}") + '.\n' + $A.get("{!$Label.c.Selected_file_size}") +': ' + file.size);
            return;
        }
        
        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object  
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents);
        });
        
        objFileReader.readAsDataURL(file);
        
    },
    uploadHelper2: function(component, event) {
        
        component.set("v.showSpinner", true);
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fileId2").get("v.files");
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function 
        
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.showSpinner", false);
            component.set("v.fileName", $A.get("{!$Label.c.Alert_File_size_cannot_exceed}") + self.MAX_FILE_SIZE + $A.get("{!$Label.c.bytes}") + '.\n' + $A.get("{!$Label.c.Selected_file_size}") +': ' + file.size);
            return;
        }
        
        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object  
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents);
        });
        
        objFileReader.readAsDataURL(file);
        
    },   
    uploadHelper3: function(component, event) {
        
        component.set("v.showSpinner", true);
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fileId3").get("v.files");
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function 
        
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.showSpinner", false);
            component.set("v.fileName", $A.get("{!$Label.c.Alert_File_size_cannot_exceed}") + self.MAX_FILE_SIZE + $A.get("{!$Label.c.bytes}") + '.\n' + $A.get("{!$Label.c.Selected_file_size}") +': ' + file.size);
            return;
        }
        
        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object  
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents);
        });
        
        objFileReader.readAsDataURL(file);
        
    }, 
    
    
    
    
    uploadProcess: function(component, file, fileContents) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        var attchId = new Array();
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attchId);
        
    },
    
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
        // call the apex method 'saveChunk'
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveChunk");
        
        
        action.setParams({
            parentId: JSON.stringify(component.get("v.parentId")),
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: JSON.stringify(attachId)
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
                    component.set("v.showSpinner", false);
                }
                
                
            }//state end
            else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            }else if (state === "ERROR") {
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
        $A.enqueueAction(action);
        
        
    },
    
    
    
    //To get SO Id if we Open comp. through "VIEW" button of SO detail page
    //If Comp. is open through "place Order Poland" then this method will not success.
    getSOSTP:function(component){
        //component.set("v.showSpinner", true);
        var soId = component.get("v.recordId");
        var action = component.get("c.getSalesSTP");
        console.log('fisrt loding soId '+soId);
        
        action.setParams({
            soId: soId
        });
        action.setCallback(this, function(a) {
            component.set("v.showSpinner", false);
            var state = a.getState();
            console.log('state first loading '+state);
            if(state == "SUCCESS") {
                
                var returnResult = a.getReturnValue();
                if(returnResult!=null){
                    console.log('in first loading of record  '+a.getReturnValue());
                    component.set("v.sOId",soId);
                    component.set("v.recordId",a.getReturnValue().Sold_to_Party__c);
                    
                    component.set("v.incoTrm",a.getReturnValue().Inco_Term__c); 
                    component.set("v.orderRaiseBy",a.getReturnValue().Order_Raise_By__c);
                    console.log('checking 1');
                    component.set("v.divisionlk",a.getReturnValue().Division_lk__r.Division_Code__c);
                    console.log('checking 2');
                    
                    var shipLoca = a.getReturnValue().Ship_To_Party__c;
                    
                    
                    if(shipLoca==undefined){
                        component.set("v.shipLocation",false);    
                    }else{
                        component.set("v.shipLocation",true);
                    }
                    console.log('stp found '+component.get("v.sOId"));
                    this.getFileName(component,event,soId);
                    
                }
                
            }else{
                component.set("v.forCommunityManualDis",false);
                console.log('stp not found ');
            }
        });
        $A.enqueueAction(action);
    },
    
    
    getFileName:function(component,event,soId){
        var action = component.get('c.getfileNames'); 
        
        
        action.setParams({
            "soId" : soId 
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                component.set('v.fileName', a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
    },
    
    // Method use to enable OrderForm for Editing purpose sales order
    editForm:function(component,event){
        
        component.set("v.disableThis", true);
        component.set("v.disableThisConfirm", false);
        component.set("v.disableEdit", true);
        component.find("skuId").makeDisabled(false);
        
        var prfName= component.get("v.profileName");
        if(prfName =='' || prfName =='Customer Community Plus User - Poland - 2'|| prfName =='Customer Partner Community Plus User - Poland - 2'){
            component.set("v.showhideforCommunity",false);
            component.set("v.basePriceCartDisabl",true);
            component.set("v.isDistributor", true);
            component.set("v.showModalBigLogDiscount", true);
            
            
        }else{
            component.set("v.showhideforCommunity",true);
            component.set("v.isDistributor", false);
            component.set("v.basePriceCartDisabl",false);
            component.set("v.showModalBigLogDiscount", false);
        }
        component.set("v.disableQtyCart",false);
        component.set("v.manualDisCartDisabl",false);
        component.set("v.payTrmCartDisabl",true);
        component.set("v.disableThisDeleteAll",false);
        
        
        
        
        component.set("v.headerMsg", $A.get("$Label.c.Edit_Order"));
        var getProductId = component.find("itemproduct1");
        var isProductArray = Array.isArray(getProductId);
        var orderItemList = component.get("v.orderItemList");
        for (var idx=0; idx < orderItemList.length; idx++) {
            if(isProductArray){
                component.find("deleteBtn")[idx].set("v.disabled",false); 
            }else{
                component.find("deleteBtn").set("v.disabled",false);
            }
        }//end of for Loop
        
    },
    
    gettingInventory: function(component,event,helper,skuId){
        
        var action = component.get('c.gettingSKUInventories');
        
        
        action.setParams({
            "skuId" :skuId
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            
            if(state == 'SUCCESS') {
                component.set("v.SingleOrderItem.inventory",a.getReturnValue());
                component.set("v.tmpInventory",a.getReturnValue());
                //component.set('v.sObjList', a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
    },
    
    gettingPriceBookPrice:function(component,event,helper,combinationKey,acId){
        
        var action = component.get('c.gettingPriceBookPrices'); 
        
        action.setParams({
            "combinationKey" : combinationKey,
            "customerId" : acId 
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                var retrunData = a.getReturnValue();
                console.log('@@ retrunData '+retrunData);
                console.log('@@ retrunData '+JSON.stringify(retrunData));
                var bPrice = retrunData.Price__c;
                component.set("v.tmpBasePrice",bPrice);
                var palltsize = component.get("v.tmpPalletSize");                
                var tsize = component.get("v.tmpTruckSize");
                var tBigVolForTruck = component.get("v.tmpBigVolForTruck");
                var tBigVolForPallet = component.get("v.tmpBigVolForPallet");
                var pTerm = component.get("v.tmpPaymentTerm");
                var tProductName = component.get("v.tmpProductName");
                var tUom = component.get("v.tmpUOMName");
                var tMultipleOf =  component.get("v.tmpmultipleOf");
                var tEarlyOrderDis =  component.get("v.tmpEarlyOrderDis");
                var tmanualDsc = component.get("v.tmpManualDscnt");
                var tDivisionId = component.get("v.tmpDivisionId");
                var tDistributionChanel = component.get("v.tmpDistributionChannelId");
                var tskuId= component.get("v.tmpSkuId");
                
                var tLogDisValue= component.get("v.tmpLogDisValue");
                var tLogDis= component.get("v.tmpLogDis");
                
                console.log('logis val '+tLogDisValue);
                console.log('logis val '+tLogDis);
                
                
                
                
                var singlLineItema = new Object();
                singlLineItema.basePrice = bPrice;
                singlLineItema.basePriceOg = bPrice;
                
                singlLineItema.palletSize = palltsize;
                singlLineItema.truckSize = tsize;
                singlLineItema.Big_Volume_for_Truck = tBigVolForTruck;
                singlLineItema.Big_Volume_for_Pallet = tBigVolForPallet;
                
                singlLineItema.typeOfPayment = pTerm;
                singlLineItema.productName = tProductName;
                singlLineItema.UOM = tUom;
                singlLineItema.multipleOf = tMultipleOf;
                console.log('tEarlyOrderDis sas '+tEarlyOrderDis);
                singlLineItema.earlyOrderDiscount = tEarlyOrderDis;
                singlLineItema.manualDiscount = tmanualDsc;
                
                
                singlLineItema.divisionId = tDivisionId;
                singlLineItema.distributionChannelId = tDistributionChanel;
                singlLineItema.skuId = tskuId;
                
                singlLineItema.logisticDiscountValue = tLogDisValue;
                singlLineItema.logisticDiscount = tLogDisValue;
                //nandhini
                var pb = component.get("v.selectedPBRecord");
                singlLineItema.skuCode = pb.SKUCode__r.SKU_Code__c;

                
                
                component.set("v.SingleOrderItem",singlLineItema);
                
            }
        });
        $A.enqueueAction(action);        
        
    },
    
    gettingBigVolDiscount:function(component,event,helper,combinationKey){
        console.log('In getting big vol discount '+combinationKey);
        
        var action = component.get('c.gettingBigVolDiscounts'); 
        
        action.setParams({
            "combinationKeys" : combinationKey 
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            console.log('state in big vol dis '+state);
            if(state == 'SUCCESS') {
                
                var returnData = a.getReturnValue();
                component.set("v.oneBigDiscount",returnData.Discount__c);
                component.set("v.twoBigDiscount",returnData.Second_Discount__c);
                console.log('retrunData.StartDate__c '+returnData.StartDate__c);
                console.log('retrunData.StartDate__c '+returnData.EndDate__c);
                
                component.set("v.startDateforBigVol",returnData.StartDate__c);
                component.set("v.endDateforBigVol",returnData.EndDate__c);
                console.log('retrun Data of Big vol discount '+JSON.stringify(a.getReturnValue()));

                    //Added for RITM0531740	GRZ(Dheeraj Sharma) 04-03-2023
                var profileNames = component.get("v.profileName");
                var acSapCode = component.get("v.accSapCode");
              
              if (profileNames == 'Customer Community Plus User - Poland - 1' || profileNames == 'Customer Community Plus User - Poland - 2' ||
                    profileNames == 'Customer Partner Community Plus User - Poland - 1' || profileNames == 'Customer Partner Community Plus User - Poland - 2' && acSapCode == '0001086118') {
                        component.set("v.oneBigDiscount",0);
                        component.set("v.twoBigDiscount",0);

                }
                console.log('oneBigDiscount', component.get("v.oneBigDiscount"));
                console.log('twoBigDiscount', component.get("v.twoBigDiscount"));
               //Added End for RITM0531740	GRZ(Dheeraj Sharma) 04-03-2023

            }
        });
        $A.enqueueAction(action);
        
    },
    
    gettingEarlyOrderDiscount:function(component,event,helper,combinationKey){
        console.log('In gettingEarlyOrderDiscount method helper ');
        var action = component.get('c.gettingEarlyOrderDiscounts'); 
        
        action.setParams({
            "combinationKeys" : combinationKey
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                var returnData = a.getReturnValue();
                console.log('return value eraly order discount '+a.getReturnValue());
                var palltsize = component.get("v.tmpPalletSize");  
                
                
                var tsize = component.get("v.tmpTruckSize");
                
                
                var tBigVolForTruck = component.get("v.tmpBigVolForTruck");
                
                
                var tBigVolForPallet = component.get("v.tmpBigVolForPallet");
                
                
                var pTerm = component.get("v.tmpPaymentTerm");
                
                
                var tProductName = component.get("v.tmpProductName");
                
                
                var tUom = component.get("v.tmpUOMName");
                
                
                
                var tMultipleOf =  component.get("v.tmpmultipleOf");
                
                
                // this ealry order discount calculated on this method.
                //checking start date and End date from Special Invoice Discount object 
                
                
                var stDate = Date.parse(returnData.StartDate__c);
                var edDate = Date.parse(returnData.EndDate__c);
                
                var currentDate = new Date();
                var pCurdate = Date.parse(currentDate);
                
                
                
                
                
                
                var tEarlyOrderDis;
                
                if(pCurdate>=stDate && pCurdate<=edDate){
                    
                    var isRegularCsutomrTemp = component.get("v.isRegularCustomer");
                    
                    if(isRegularCsutomrTemp){
                        tEarlyOrderDis = returnData.Discount__c;    
                    }else{
                        tEarlyOrderDis = null; 
                        
                    }
                    
                } else {

                    tEarlyOrderDis = 0; 
                }

                
                //Added for RITM0531740	GRZ(Dheeraj Sharma) 04-03-2023

                var profileNames = component.get("v.profileName");
                var acSapCode = component.get("v.accSapCode");
                if (profileNames == 'Customer Community Plus User - Poland - 1' || profileNames == 'Customer Community Plus User - Poland - 2' ||
                    profileNames == 'Customer Partner Community Plus User - Poland - 1' || profileNames == 'Customer Partner Community Plus User - Poland - 2' && acSapCode == '0001086118') {
                    tEarlyOrderDis = 0;

                }
                console.log('tEarlyOrderDis', tEarlyOrderDis);

                //Added End for RITM0531740	GRZ(Dheeraj Sharma) 04-03-2023

                var tBasePrice = component.get("v.tmpBasePrice");


                
                var tDivisionId = component.get("v.tmpDivisionId");
                
                
                var tDistributionChanel = component.get("v.tmpDistributionChannelId");
                
                
                var tskuId= component.get("v.tmpSkuId");
                
                
                var tLogDisValue= component.get("v.tmpLogDisValue");
                
                
                var tLogDis= component.get("v.tmpLogDis");
                
                var tmanualDsc = component.get("v.tmpManualDscnt");
                
                
                
                var singlLineItema = new Object();
                singlLineItema.basePrice = tBasePrice;
                singlLineItema.basePriceOg = tBasePrice;
                singlLineItema.manualDiscount = tmanualDsc;
                
                singlLineItema.palletSize = palltsize;
                singlLineItema.truckSize = tsize;
                singlLineItema.Big_Volume_for_Truck = tBigVolForTruck;
                singlLineItema.Big_Volume_for_Pallet = tBigVolForPallet;
                
                singlLineItema.typeOfPayment = pTerm;
                singlLineItema.productName = tProductName;
                singlLineItema.UOM = tUom;
                singlLineItema.multipleOf = tMultipleOf;
                
                singlLineItema.earlyOrderDiscount = tEarlyOrderDis;
                // singlLineItema.manualDiscount = tmanualDsc;
                
                singlLineItema.divisionId = tDivisionId;
                singlLineItema.distributionChannelId = tDistributionChanel;
                singlLineItema.skuId = tskuId;
                
                singlLineItema.logisticDiscountValue = tLogDisValue;
                singlLineItema.logisticDiscount = tLogDisValue;
                singlLineItema.inventory = component.get("v.tmpInventory");
                
                //nandhini
                var pb = component.get("v.selectedPBRecord");
                var wholePriceList1=component.get("v.priceDetailList");
                var isParent;
                wholePriceList1.forEach(pbInfo=>{
                    if(pb.SKUCode__r.SKU_Code__c ==pbInfo.skuCode){
                    isParent =pbInfo.isParent;
                }
                                       });
                console.log('test parent last:'+isParent);
                singlLineItema.skuCombinationKey = pb.SKUCombinationkey__c;
                singlLineItema.skuDescription = pb.SKUCode__r.SKU_Description__c;
                singlLineItema.skuCode = pb.SKUCode__r.SKU_Code__c;
                singlLineItema.isParent =isParent;//Added by nandhini-may 27
                component.set("v.SingleOrderItem",singlLineItema);
                console.log('single Order Item inside discounts:'+JSON.stringify(component.get("v.SingleOrderItem")));
                
            }
        });
        $A.enqueueAction(action);
        
    },
    
    
    gettingEarlyDis:function(component,event,helper,skuCombinationky){
        console.log('in changing qty in lower '+skuCombinationky);
        //gettingEarlyOrderDiscounts
        var action = component.get('c.gettingEarlyOrderDiscounts'); 
        
        
        action.setParams({
            "combinationKeys" : skuCombinationky 
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            console.log('State in qtye change eraly Order '+state);
            if(state == 'SUCCESS') {
                var returnData = a.getReturnValue();
                console.log('Rets data '+JSON.stringify(returnData));
                // component.set('v.sObjList', a.getReturnValue());
                
                var stDate = Date.parse(returnData.StartDate__c);
                var edDate = Date.parse(returnData.EndDate__c);
                
                var currentDate = new Date();
                var pCurdate = Date.parse(currentDate);
                var tEarlyOrderDis;
                
                if(pCurdate>=stDate && pCurdate<=edDate){
                    
                    var isRegularCsutomrTemp = component.get("v.isRegularCustomer");
                    
                    if(isRegularCsutomrTemp){
                        tEarlyOrderDis = returnData.Discount__c;    
                    }else{
                        tEarlyOrderDis = null; 
                        
                    }
                    
                }else{
                    
                    tEarlyOrderDis =0;
                }
                
                console.log('Early Order Dis for chaeck '+tEarlyOrderDis);
                
                component.set("v.earlyOrderDisValue",tEarlyOrderDis);
                
                 //Added for RITM0531740 GRZ(Dheeraj Sharma) 04-03-2023
                var profileNames = component.get("v.profileName");
                var acSapCode = component.get("v.accSapCode");
                if (profileNames == 'Customer Community Plus User - Poland - 1' || profileNames == 'Customer Community Plus User - Poland - 2' ||
                    profileNames == 'Customer Partner Community Plus User - Poland - 1' || profileNames == 'Customer Partner Community Plus User - Poland - 2' && acSapCode == '0001086118') {
                    tEarlyOrderDis = 0;

                }
                console.log('tEarlyOrderDis2', tEarlyOrderDis);
                
                 //Added End for RITM0531740 GRZ(Dheeraj Sharma) 04-03-2023
                
                
                
            }
        });
        $A.enqueueAction(action);
        
    },
    
    
    
    //Logic to show/hide modal by toggling css class .tog2
    toggleMultipleOfCartDialog: function(component){
        var dialog = component.find("multipleOfCartDialog");
        $A.util.toggleClass(dialog, "slds-hide");
        
        var backdrop5 = component.find("backdrop5");
        $A.util.toggleClass(backdrop5, "slds-hide");
    },
    
    gettingNameSKU:function(component,event,helper){
        
        var checkRepeateOrder = component.get("v.saveOrderTemplateCheck");
        
        var orderItemList = component.get("v.orderItemList");
        var skuName ='';
        if(checkRepeateOrder){
            for(var i=0;i<orderItemList.length;i++){
                console.log('orderItemList skuDescription '+orderItemList[i].skuDescription);
                skuName = skuName + orderItemList[i].skuDescription;
            }
            var tempskuName ='';
            if(skuName.length>21){
                tempskuName = skuName.substring(0, 19);
            }else{
                tempskuName = skuName;
            }
            component.set("v.repeatOrderName",tempskuName);
        }else{
            component.set("v.repeatOrderName",skuName);
        }
        
    },
    
    //update Quantity cart
    updateQtyCart : function(component,event,helper,rowIndex,qty){
        //console.log('@@@ rowindex in cart update quantity '+rowIndex);
        var getProductId = component.find("itemproduct1");
        var isProductArray = Array.isArray(getProductId);
        var orderItemList = component.get("v.orderItemList");
        var basePrice = orderItemList[rowIndex].basePrice;
        var manualDiscount = orderItemList[rowIndex].manualDiscount;
        
        
        
        
        //var earlyOrderDisValue = orderItemList[rowIndex].earlyOrderDiscount; //earlyOrderDiscount    earlyOrderDiscountValue
        var earlyOrderDisValue = component.get("v.earlyOrderDisValue"); //earlyOrderDiscount    earlyOrderDiscountValue
        console.log('earlyOrderDisValues in qty Order  '+earlyOrderDisValue);
        
        
        
        
        if(qty>0){
            var isRegularCustomer = component.get("v.isRegularCustomer");
            var isNonRegularCustomer = component.get("v.isNonRegularCustomer");
            //for Regular customer
            console.log('isRegularCustomer in cart change '+isRegularCustomer);
            console.log('isNonRegularCustomer in cart change '+isNonRegularCustomer);
            
            if(isRegularCustomer){
                var palletSize = orderItemList[rowIndex].palletSize;
                var logisticDis = orderItemList[rowIndex].logisticDiscount;
                var logisticDisValue;  
                //changed nandhini                 
                if(orderItemList[rowIndex].PAK){                        
                    logisticDisValue = orderItemList[rowIndex].logisticDiscount;            
                }else{                       
                    logisticDisValue = orderItemList[rowIndex].logisticDiscountValue;   }
               
                    var truckSize = orderItemList[rowIndex].truckSize;
                
                
                
                var oneDiscount = component.get("v.oneBigDiscount");
                var twoDiscount = component.get("v.twoBigDiscount");
                
                
                console.log('asdecf oneDiscount '+oneDiscount);
                console.log('asdecf twoDiscount '+twoDiscount);
                
                var qtty = orderItemList[rowIndex].qty;
                
                var BigVolumeforPallet = orderItemList[rowIndex].Big_Volume_for_Pallet;
                var BigVolumeforTruck = orderItemList[rowIndex].Big_Volume_for_Truck;
                
                console.log('@@@w Order Template truckSize '+truckSize);
                console.log('@@@w Order Template palletSize '+palletSize);
                console.log('@@@w Order Template BigVolumeforPallet '+BigVolumeforPallet);
                console.log('@@@w Order Template BigVolumeforTruck '+BigVolumeforTruck);
                
                
                
                if(BigVolumeforPallet=='Yes' && BigVolumeforTruck=='Yes'){
                    console.log('$$$ in first by excel condition ');
                    console.log('Order Template in qty chnage Inside 3 '+qty);
                    
                    if(qty>=palletSize && qty<truckSize){
                        console.log('oneDiscount asdasd '+oneDiscount);
                        
                        orderItemList[rowIndex].bigVolDiscount = oneDiscount;
                        console.log('Order Template in qty chnage Inside for One Percent');
                    }else if(qty>=palletSize && qty>=truckSize){
                        console.log(' Order Template in qty chnage Inside 5');
                        orderItemList[rowIndex].bigVolDiscount = twoDiscount;
                    }else{
                        orderItemList[rowIndex].bigVolDiscount = 0;
                    } 
                }
                
                if(BigVolumeforPallet=='Yes' && BigVolumeforTruck=='No'){
                    console.log('$$$ in Second by excel Conditon');
                    if(qty>=palletSize){
                        orderItemList[rowIndex].bigVolDiscount = oneDiscount;
                    }else{
                        orderItemList[rowIndex].bigVolDiscount = 0;
                    }
                    
                }
                
                if(BigVolumeforPallet=='No' && BigVolumeforTruck=='Yes' ){
                    console.log('$$$ in third by Excel Conditon ');
                    if(qty>=truckSize){
                        orderItemList[rowIndex].bigVolDiscount = twoDiscount;
                    }else{
                        orderItemList[rowIndex].bigVolDiscount = 0;
                    }
                    
                }
                
                
                if(BigVolumeforPallet=='No' && BigVolumeforTruck=='No' ){
                    console.log('$$$ in fourth by Excel Conditon ');
                    orderItemList[rowIndex].bigVolDiscount = 0;
                }
                
                
                if(BigVolumeforPallet==undefined && BigVolumeforTruck=='Yes'){
                    console.log('$$$ in Fifth by Excel Conditon');
                    if(qty>=truckSize){
                        orderItemList[rowIndex].bigVolDiscount = twoDiscount;
                    }else{
                        orderItemList[rowIndex].bigVolDiscount = 0;
                    }
                }
                
                if(BigVolumeforPallet==undefined && BigVolumeforTruck=='No'){
                    console.log('$$$ in Sixth by excel Conditon');
                    orderItemList[rowIndex].bigVolDiscount = 0;
                }
                
                if(BigVolumeforPallet=='Yes' && BigVolumeforTruck==undefined){
                    console.log('$$$ in seventh by excel Conditon');
                    if(qty>=palletSize){
                        orderItemList[rowIndex].bigVolDiscount = oneDiscount;
                    }else{
                        orderItemList[rowIndex].bigVolDiscount = 0;
                    }
                }
                
                if(BigVolumeforPallet=='No' && BigVolumeforTruck==undefined){
                    console.log('$$$ in eighth by excel Conditon');
                    orderItemList[rowIndex].bigVolDiscount = 0;
                }
                
                
                
                
                
                
                
                
                
                /*  var showModalBigLogDis = component.get("v.showModalBigLogDiscount"); 
                console.log('showModalBigLogDis at cart  '+showModalBigLogDis); 
                
                
                if(showModalBigLogDis){
                    var logDis = orderItemList[rowIndex].logisticDiscount;
                    var bigVolDiss = orderItemList[rowIndex].bigVolDiscount;
                    component.set("v.logisticDis",logDis);
                    component.set("v.bigVolDis",bigVolDiss);
                    this.toggleshowModalBigLogDisDialog(component);
                }*/
                
                // for getting Inventories
                
                var tempTrueForTemplate = component.get("v.trueforTemplate");
                console.log('tempTrueForTemplate '+tempTrueForTemplate);
                if(tempTrueForTemplate){
                    var skuidforTemplate = orderItemList[rowIndex].skuId;
                    
                    console.log('skuidforTemplate '+skuidforTemplate);
                    this.gettingInventory1(component,event,helper,skuidforTemplate);
                    
                    window.setTimeout($A.getCallback(function() {var templateInv = component.get("v.templateInventory");
                                                                 console.log('for template templateInv '+templateInv );
                                                                 orderItemList[rowIndex].inventory = templateInv;
                                                                 component.set("v.orderItemList",orderItemList);
                                                                }),2000 );
                    
                    
                    
                    //orderItemList[rowIndex].logisticDiscount = logDiscount;
                }
                
                
                
                
                var inctmcode = component.get("v.incoTrm1");
                var logDiscount = 0;
                console.log('Order Template inco term '+inctmcode);
                if(inctmcode == 'EXW'){
                    console.log('Order Template logisticDis '+logisticDisValue);
                    if(logisticDisValue!=undefined){
                        logDiscount = logisticDisValue;    
                    }else{
                        logDiscount = 0;
                    }
                    
                    
                }else{
                    logDiscount = 0;
                }
                orderItemList[rowIndex].logisticDiscount = logDiscount;
                
                
                var cloneOrder = component.get("v.forClone");
                var earlyDiscount =0; 
                
                if(cloneOrder=='cloneOrder'){
                    
                    var stDate = Date.parse(component.get("v.startDate"));
                    var edDate = Date.parse(component.get("v.endDate"));
                    var currentDate = new Date();
                    var pCurdate = Date.parse(currentDate);
                    
                    if(pCurdate>=stDate && pCurdate<=edDate && earlyOrderDisValue!=undefined){
                        
                        var isRegularCsutomrTemp = component.get("v.isRegularCustomer");
                        if(isRegularCsutomrTemp){
                            console.log('inside regular customer in clone order');
                            console.log('earlyOrderDisValue in checking for '+earlyOrderDisValue);
                            orderItemList[rowIndex].earlyOrderDiscount= earlyOrderDisValue;
                        }else{
                            orderItemList[rowIndex].earlyOrderDiscount= null;
                        }
                        
                    }else{
                        console.log('outside condition in clone Order for early order discount');
                        orderItemList[rowIndex].earlyOrderDiscount= 0;
                    }
                    
                    //orderItemList[rowIndex].earlyOrderDiscount= 5;
                    earlyDiscount = orderItemList[rowIndex].earlyOrderDiscount;
                }else{
                    earlyDiscount = orderItemList[rowIndex].earlyOrderDiscount;
                }
                
                
                
                var bigVolDiscount = orderItemList[rowIndex].bigVolDiscount;
                
                var forClones = component.get("v.forClone");
                
                var manualDiscount1 ;
                
                if(forClones=='cloneOrder'){
                    manualDiscount1 = component.get("v.manualDisclone");
                    
                }else{
                    manualDiscount1 = orderItemList[rowIndex].manualDiscount;
                }
                
                
                
                var manualDiscount=0;
                
                
                if(manualDiscount1==undefined){
                    manualDiscount = 0; 
                }else{
                    manualDiscount =manualDiscount1;
                }
                
                console.log('manualDiscount for clone order '+manualDiscount);
                
                var logisticDiscount = logDiscount;
                //********
                var finalPrice = 0.0;
                var finalPrice1 =0.0;
                var finalPrice2 =0.0;
                var finalPrice3 =0.0;
                
                
                console.log('basePrice in checking calcu '+basePrice);
                console.log('bigVolDiscount in checking calcu '+bigVolDiscount);
                
                finalPrice = (basePrice -(basePrice*bigVolDiscount/100)); //earlyDiscount
                finalPrice = Math.round((finalPrice + Number.EPSILON) * 100) / 100;
                console.log('After calculation of big vol '+finalPrice);
                
                finalPrice1 = (finalPrice - (finalPrice*manualDiscount/100));  //bigVolDiscount
                finalPrice1 = Math.round((finalPrice1 + Number.EPSILON) * 100) / 100;
                console.log('After calculation of manual '+finalPrice1);
                
                finalPrice2 = (finalPrice1 - (finalPrice1*earlyDiscount/100)); //manualDiscount
                finalPrice2 = Math.round((finalPrice2 + Number.EPSILON) * 100) / 100;
                console.log('After calcualtion of early  '+finalPrice2);
                
                finalPrice3 =finalPrice2 - logDiscount; //logDiscount
                finalPrice3 = Math.round((finalPrice3 + Number.EPSILON) * 100) / 100;
                console.log('After calcualtion of Logistic discuount '+finalPrice3);
                
                orderItemList[rowIndex].finalPrice=finalPrice3;
                var netValue = (finalPrice3 *qtty).toFixed(2);
                console.log('netValue for data '+netValue);
                orderItemList[rowIndex].netValue = netValue;
                orderItemList[rowIndex].qty = qtty.toFixed(2);
                orderItemList[rowIndex].manualDiscount=manualDiscount;
                
                var paytrmCln = component.get("v.paymentTermClone");
                var forClones1 = component.get("v.forClone");
                if(forClones1=='cloneOrder'){
                    console.log('paytrmCln adsad '+paytrmCln);
                    orderItemList[rowIndex].typeOfPayment=paytrmCln;
                }
                
                
                //this is mandate
                component.set("v.orderItemList",orderItemList);
                
            }//end of IsRegular condition
            
            
            
            
            
            
            
            if(isNonRegularCustomer){
                //var orderItemList = component.get("v.orderItemList");
                console.log('inside isNonRegularCustomer');
                var manualDis =  orderItemList[rowIndex].manualDiscount;
                var qtty = orderItemList[rowIndex].qty;
                console.log('manualDis '+manualDis);
                var finalPrice = 0.0;
                finalPrice = (basePrice - (basePrice*manualDis/100));
                finalPrice = Math.round((finalPrice + Number.EPSILON) * 100) / 100;
                
                console.log('After calculation of Manual Discount '+finalPrice);
                //console.log('finalPrice '+finalPrice);
                orderItemList[rowIndex].finalPrice =finalPrice;
                console.log('qtyyyyy '+qtty);
                var netValue = (finalPrice * qtty).toFixed(2);
                console.log('netValue '+netValue);
                orderItemList[rowIndex].netValue = netValue;
                orderItemList[rowIndex].qty = qtty.toFixed(2);
                component.set("v.orderItemList",orderItemList);
            }
            
        }//end if condition of qty checking
        
    },
    
    updategrossAmmount: function(component,event,helper){
        //console.log('updategrossAmmount function');
        var orderItemListTemp = component.get("v.orderItemList");
        //console.log('orderItemListTemp.lenght '+orderItemListTemp.length)
        if(orderItemListTemp.length>0){
            var grossAmt =0;
            for(var i=0; i<orderItemListTemp.length;i++){
                grossAmt =grossAmt +orderItemListTemp[i].netValue;
            }
            //console.log('gross amount '+grossAmt);
            component.set("v.grossNetPrice",grossAmt);
        }
    },
    
    
    gettingOrderTemplate:function(component,event,helper){
        
        var action = component.get('c.showOrderTemplates'); 
        action.setParams({
            "accId" : component.get('v.recordId') 
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                component.set('v.orderTemplateList', a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
    },
    
    resetPBObj:function(component, event, helper){
        component.find("skuId").makeReset(false);
        
    },
    
    clubbingSKU:function(component, event, helper){
        
        var ordItem = component.get("v.orderItemList");
        var i;
        var qun_ltr = 0;
        var qun_ltr_amt = 0;
        var qun_kg = 0;
        var qun_kg_amt = 0;
        var qun_pac = 0;//Ticket No:RITM0412034
        var qun_pac_amt = 0;
        
        
        
        for (i = 0; i < ordItem.length; i++) {
            var obj = new Object(ordItem[i]); 
            
            if(obj.UOM != null && obj.UOM != undefined && obj.UOM.toUpperCase() == 'L'){//nandhini
                
                qun_ltr = qun_ltr + parseFloat(obj.qty);
                qun_ltr_amt = qun_ltr_amt + parseFloat(obj.netValue);
            }//end of Liter
            else if(obj.UOM != null && obj.UOM != undefined && obj.UOM.toUpperCase() == 'KG'){//nandhini
                qun_kg = qun_kg + parseFloat(obj.qty);
                qun_kg_amt = qun_kg_amt + parseFloat(obj.netValue);
            }
            else if(obj.UOM != null && obj.UOM != undefined && obj.UOM.toUpperCase() == 'PAK'){ //Ticket No:RITM0412034 //nandhini//changed to PAK
                qun_pac = qun_pac + parseFloat(obj.qty);
                qun_pac_amt = qun_pac_amt + parseFloat(obj.netValue);
            }
        }
        component.set("v.net_price_litre",qun_ltr_amt.toFixed(2));
        component.set("v.quantity_litre",qun_ltr.toFixed(2));
        
        component.set("v.quantity_kg",qun_kg.toFixed(2));
        component.set("v.net_price_kg",qun_kg_amt.toFixed(2));
        
        component.set("v.quantity_pac",qun_pac.toFixed(2));//Ticket No:RITM0412034
        component.set("v.net_price_pac",qun_pac_amt.toFixed(2));
    },
    
    
    gettingOrderTemplateDetails:function(component,event,helper,tempId){
        console.log('gettingOrderTemplateDetails method  '+tempId);
        var action = component.get('c.getEntity'); 
        
        
        action.setParams({
            "templateId" : tempId 
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                var cartData = a.getReturnValue();
                var cartLength =cartData.soiList.length;
                component.set("v.orderItemList", cartData.soiList);
                var orderItemList = component.get("v.orderItemList");
                var incoTerm = cartData.incoTerm;
                component.set("v.incoTrm",incoTerm);
                component.set("v.disableThis",true);
                component.set("v.trueforTemplate",true);
                
                
            }
        });
        $A.enqueueAction(action);
        
    },
    
    updateRowCalculations2:function(component,event,helper){
        console.log('updateRowCalculations2 method ');
        var bsPrice = component.get("v.SingleOrderItem.basePrice");
        
        var qty = component.get("v.SingleOrderItem.qty");
        
        
        
        
        if(bsPrice>0){
            var isRegularCustomer = component.get("v.isRegularCustomer");
            var isDistributor = component.get("v.isDistributor");
            var isNonRegularCustomer = component.get("v.isNonRegularCustomer");
            
            
            if(isRegularCustomer || isDistributor ){
                var palletSize = component.get("v.SingleOrderItem.palletSize");
                var logisticDis = component.get("v.SingleOrderItem.logisticDiscountValue");  //available on sku level
                var truckSize = component.get("v.SingleOrderItem.truckSize");
                var oneDiscount = component.get("v.paletQtydis");
                var twoDiscount = component.get("v.truckQtydis");
                var errlyderdisc = component.get("v.SingleOrderItem.earlyOrderDiscount");
                
                console.log('@@@@@ palletSize '+palletSize);
                console.log('@@@@@ logisticDis  '+logisticDis);
                console.log('@@@@@ truckSize '+truckSize);
                console.log('@@@@@ oneDiscount '+oneDiscount);
                console.log('@@@@@ twoDiscount '+twoDiscount);
                
                var BigVolumeforPallet = component.get("v.SingleOrderItem.Big_Volume_for_Pallet");
                var BigVolumeforTruck = component.get("v.SingleOrderItem.Big_Volume_for_Truck");
                
                console.log('@@@@@ BigVolumeforPallet '+BigVolumeforPallet);
                console.log('@@@@@ BigVolumeforTruck '+BigVolumeforTruck);
                
                console.log('big discount 3 '+component.get("v.SingleOrderItem.bigVolDiscount"));
                
                var inctmcode = component.get("v.incoTrm1");
                var logDiscount = 0;
                if(inctmcode == 'EXW'){
                    if(logisticDis!=undefined){
                        logDiscount = logisticDis;    
                    }else{
                        logDiscount = 0;
                    }
                    
                }else{
                    logDiscount = 0;
                }
                component.set("v.SingleOrderItem.logisticDiscount",logDiscount);
                
                //now getting all discount to calculate Net value
                var earlyDiscount = component.get("v.SingleOrderItem.earlyOrderDiscount");
                var bigVolDiscount = component.get("v.SingleOrderItem.bigVolDiscount");
                var manualDiscount = component.get("v.SingleOrderItem.manualDiscount");
                var logDisc = component.get("v.SingleOrderItem.logisticDiscount");
                var qty = component.get("v.SingleOrderItem.qty");
                
                console.log('before calculation earlyDiscount before calculation '+earlyDiscount);
                console.log('before calculation bigVolDiscount before calculation '+bigVolDiscount);
                console.log('before calculation manualDiscount before calculation '+manualDiscount);
                console.log('before calculation logDisc before calculation '+logDisc);
                console.log('before calculation qty before calculation '+qty);
                
                
                var tmpearlyDiscount;
                if(earlyDiscount!=undefined){
                    tmpearlyDiscount = earlyDiscount;
                }else{
                    tmpearlyDiscount =0;
                }
                
                var tmpbigVolDiscount;
                if(bigVolDiscount!=undefined){
                    tmpbigVolDiscount = bigVolDiscount; 
                }else{
                    tmpbigVolDiscount =0;
                }
                
                var tmpmanualDiscount;
                if(manualDiscount!=undefined){
                    tmpmanualDiscount  = manualDiscount;
                }else{
                    tmpmanualDiscount = 0;
                }
                
                var tmplogDisc;
                if(logDisc!=undefined){
                    tmplogDisc = logDisc;
                }else{
                    tmplogDisc = 0;
                }
                
                var tmpqty ;
                if(qty!=undefined){
                    tmpqty= qty;
                }else{
                    tmpqty =0;
                }
                
                
                var finalPrice = 0.0;
                
                
                
                //Changes order of Discount #CR143
                
                finalPrice = (bsPrice -(bsPrice*tmpbigVolDiscount/100)); //tmpearlyDiscount
                finalPrice = Math.round((finalPrice + Number.EPSILON) * 100) / 100;
                console.log('After calculation of early Order Discount '+finalPrice);
                
                finalPrice = (finalPrice - (finalPrice*tmpmanualDiscount/100));  //tmpbigVolDiscount
                finalPrice = Math.round((finalPrice + Number.EPSILON) * 100) / 100;
                console.log('After calculation of big vol discount '+finalPrice);
                
                finalPrice = (finalPrice - (finalPrice*tmpearlyDiscount/100));//tmpmanualDiscount
                finalPrice = Math.round((finalPrice + Number.EPSILON) * 100) / 100;
                console.log('After calculation of Manual Discount '+finalPrice);
                
                finalPrice = (finalPrice - tmplogDisc); //tmplogDisc
                finalPrice = Math.round((finalPrice + Number.EPSILON) * 100) / 100;
                console.log('After calculation of Logistic Discount '+finalPrice);
                
                component.set("v.SingleOrderItem.finalPrice",finalPrice);
                
                
                
                console.log('after cal tmpqty '+tmpqty);
                var netValue = (finalPrice *tmpqty).toFixed(2);
                console.log('after cal netValue '+netValue);
                
                
                component.set("v.SingleOrderItem.netValue",netValue);
                component.set("v.SingleOrderItem.basePrice",bsPrice);
                
                //End For Changes order of Discount #CR143
                
                
            }//isRegular and Is Distributor End
            
            if(isNonRegularCustomer){
                var bsPrice = component.get("v.SingleOrderItem.basePrice");
                var qty = component.get("v.SingleOrderItem.qty");
                var manualDiscount = component.get("v.SingleOrderItem.manualDiscount");
                
                console.log('for Non regular base Price '+bsPrice);
                console.log('for Non regular qty '+qty);
                console.log('for Non regular manualDiscount '+manualDiscount);
                var qty1 ; 
                if(qty==undefined){
                    qty1= 0; 
                }else{
                    qty1=qty;
                }
                var manualDiscount1;
                if(manualDiscount==undefined){
                    manualDiscount1 =0;
                }else{
                    manualDiscount1 =manualDiscount;  
                }
                var bsPrice1;
                if(bsPrice==undefined){
                    bsPrice1= 0;
                }else{
                    bsPrice1=bsPrice;
                }
                
                var finalPrice =0;
                var netValue =0;
                finalPrice = (bsPrice1 - (bsPrice1*manualDiscount1/100));
                finalPrice= Math.round((finalPrice + Number.EPSILON) * 100) / 100;
                component.set("v.SingleOrderItem.finalPrice",finalPrice);
                netValue = (finalPrice* qty1).toFixed(2);
                component.set("v.SingleOrderItem.netValue",netValue);
                component.set("v.SingleOrderItem.manualDiscount",manualDiscount1);
                component.set("v.SingleOrderItem.basePrice",bsPrice1);
                
            }//non Regualr customer End
            
        }
        
    },
    
    updateBasePriceCart :function(component,event,helper,rowIndex,bsPrice){
        console.log('bsPrice '+bsPrice);
        var getProductId = component.find("itemproduct1");
        var isProductArray = Array.isArray(getProductId);
        var orderItemList = component.get("v.orderItemList");
        var basePrice = orderItemList[rowIndex].basePrice;
        var manualDiscount = orderItemList[rowIndex].manualDiscount;
        var qty = orderItemList[rowIndex].qty;
        
        console.log('getProductId '+getProductId);
        console.log('basePrice '+basePrice);
        console.log('manualDiscount '+manualDiscount);
        console.log('qty '+qty);
        if(basePrice>0){
            var isRegularCustomer = component.get("v.isRegularCustomer");
            var isNonRegularCustomer = component.get("v.isNonRegularCustomer");
            //var isNonRegularCustomer = component.get("v.isDistributor");
            //this is for Regular customer
            if(isRegularCustomer){
                var palletSize = orderItemList[rowIndex].palletSize;
                var logisticDis = orderItemList[rowIndex].logisticDiscount;
                var logisticDisValue;   
                //changed Nanhdini  
                if(orderItemList[rowIndex].PAK){        
                    logisticDisValue = orderItemList[rowIndex].logisticDiscount;  
                }else{ 
                    logisticDisValue = orderItemList[rowIndex].logisticDiscountValue;    
                }
                var truckSize = orderItemList[rowIndex].truckSize;
                var oneDiscount = component.get("v.paletQtydis");
                var twoDiscount = component.get("v.truckQtydis");
                var qtty = orderItemList[rowIndex].qty;
                
                
                
                var BigVolumeforPallet = orderItemList[rowIndex].Big_Volume_for_Pallet;
                var BigVolumeforTruck = orderItemList[rowIndex].Big_Volume_for_Truck;
                
                
                var inctmcode = component.get("v.incoTrm1");
                var logDiscount = 0;
                
                if(inctmcode == 'EXW'){
                    if(logisticDisValue!=undefined ){
                        logDiscount = logisticDisValue;    
                    }else{
                        logDiscount = 0;
                    }
                    
                    
                }else{
                    logDiscount = 0;
                }
                
                orderItemList[rowIndex].logisticDiscount = logDiscount;
                var earlyDiscount = orderItemList[rowIndex].earlyOrderDiscount;
                var bigVolDiscount = orderItemList[rowIndex].bigVolDiscount;
                var manualDiscount = orderItemList[rowIndex].manualDiscount;
                var logisticDiscount = logDiscount;
                
                
                var tmpbasePrice;
                if(basePrice!=null){
                    tmpbasePrice = basePrice;
                }else{
                    tmpbasePrice =0;
                }
                
                var tmpqtty;
                if(qtty!=null){
                    tmpqtty = qtty;
                }else{
                    tmpqtty = 0;
                }
                
                
                var tmpearlyDiscount;
                if(earlyDiscount!=null){
                    tmpearlyDiscount = earlyDiscount;
                }else{
                    tmpearlyDiscount =0;
                }
                
                var tmpbigVolDiscount;
                if(bigVolDiscount!=null){
                    tmpbigVolDiscount = bigVolDiscount;
                }else{
                    tmpbigVolDiscount =0;
                }
                
                var tmpmanualDiscount;
                if(manualDiscount!=undefined){
                    tmpmanualDiscount = manualDiscount;
                }else{
                    tmpmanualDiscount =0;
                }
                
                var tmplogisticDiscount;
                if(logisticDiscount!= null){
                    tmplogisticDiscount = logisticDiscount;
                }else{
                    tmplogisticDiscount =0;
                }
                
                
                var finalPrice = 0.0;
                var finalPrice1 =0.0;
                var finalPrice2 =0.0;
                var finalPrice3 =0.0;
                
                
                
                finalPrice = (tmpbasePrice -(tmpbasePrice*tmpbigVolDiscount/100));//tmpearlyDiscount
                finalPrice = Math.round((finalPrice + Number.EPSILON) * 100) / 100;                
                console.log('After calculation of Early order discount '+finalPrice);
                
                
                finalPrice1 = (finalPrice - (finalPrice*tmpmanualDiscount/100)); //tmpbigVolDiscount
                finalPrice1 = Math.round((finalPrice1 + Number.EPSILON) * 100) / 100;
                console.log('After calculation of Big vol discount '+finalPrice1);
                
                finalPrice2 = (finalPrice1 - (finalPrice1*tmpearlyDiscount/100)); //tmpmanualDiscount
                finalPrice2 = Math.round((finalPrice2 + Number.EPSILON) * 100) / 100;
                console.log('After calculation of Manual discount '+finalPrice2);
                
                finalPrice3 =finalPrice2 - tmplogisticDiscount; //tmplogisticDiscount
                finalPrice3 = Math.round((finalPrice3 + Number.EPSILON) * 100) / 100;
                console.log('After calculation of Logistic discount '+finalPrice3);
                
                orderItemList[rowIndex].finalPrice=finalPrice3;
                var netValue = (finalPrice3 *qtty).toFixed(2);
                orderItemList[rowIndex].netValue = netValue;
                orderItemList[rowIndex].basePrice =basePrice;
                component.set("v.orderItemList",orderItemList);
                
            }//end for Regular customer
            
            if(isNonRegularCustomer){
                console.log('in isNonRegularCustomer base price Changes in cart');
                var manualDis =  orderItemList[rowIndex].manualDiscount;
                var qtty = orderItemList[rowIndex].qty;
                var basPrice = orderItemList[rowIndex].basePrice;
                
                
                var manualDis1;
                if(manualDis==undefined){
                    manualDis1 =0;
                }else{
                    manualDis1= manualDis;
                }
                
                var basPrice1;
                if(basPrice==undefined){
                    basPrice1=0;
                }else{
                    basPrice1=basPrice;
                }
                
                var qtty1;
                if(qtty==undefined){
                    qtty1=0;
                }else{
                    qtty1=qtty;
                }
                
                
                var finalPrice = 0.0;
                finalPrice = (basPrice1 - (basPrice1*manualDis1/100));
                finalPrice = Math.round((finalPrice + Number.EPSILON) * 100) / 100;
                
                orderItemList[rowIndex].finalPrice =finalPrice;
                var netValue = (finalPrice * qtty1).toFixed(2);
                orderItemList[rowIndex].netValue = netValue;
                orderItemList[rowIndex].basePrice =parseInt(basPrice1).toFixed(2);
                component.set("v.orderItemList",orderItemList);
            }//end of Non regular Customer
            
        }
    },
    
    deleteSalesOrderItem:function(component,event,soliId){
        console.log('soliId in delete sales Order Line Item '+soliId);
        var action = component.get('c.deleteSalesOrderLineItem'); 
        
        
        action.setParams({
            "salesOLId" : soliId
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                component.set("v.showSpinner", false);
            }
        });
        $A.enqueueAction(action);
        
        
    },
    
    
    onChangeManulDiscountCartHlpr:function(component,event,helper,rowIndex){
        console.log('@@@@ onChangeManulDiscountCartHlpr '+rowIndex);
        
        var orderItemList = component.get("v.orderItemList");
        var manualDiscount = orderItemList[rowIndex].manualDiscount;
        
        var tmpManflg  =true;
        
        if(manualDiscount<=100){
            console.log('manual discount is under 100');
            tmpManflg = true;
        }else{
            tmpManflg = false;
            orderItemList[rowIndex].manualDiscount =0;
            var toastMsg = $A.get("$Label.c.Manual_Discount_should_be_Under_100");
            this.showErrorToast(component, event, toastMsg); 
            var qtTem = orderItemList[rowIndex].qty;
            var bsprce = orderItemList[rowIndex].basePrice; 
            var mnalDis = orderItemList[rowIndex].manualDiscount;
            
            var qtTem1;
            if(qtTem==undefined){
                qtTem1=0;
            }else{
                qtTem1 =qtTem;
            }
            
            var bsprce1;
            if(bsprce==undefined){
                bsprce1=0;
            }else{
                bsprce1=bsprce;
            }
            
            var mnalDis1;
            if(mnalDis==undefined){
                mnalDis1=0;
            }else{
                mnalDis1=mnalDis;
            }
            
            var fnlprce = 0.0;
            
            fnlprce= (bsprce1 - (bsprce1*mnalDis1/100));
            fnlprce = Math.round((fnlprce + Number.EPSILON) * 100) / 100;
            orderItemList[rowIndex].finalPrice=fnlprce;
            var ntValue = (fnlprce* qtTem1);
            ntValue = Math.round((ntValue + Number.EPSILON) * 100) / 100;
            orderItemList[rowIndex].netValue=fnlprce;
            
            component.set("v.orderItemList",orderItemList);
            
            this.updategrossAmmount(component, event, helper);
            this.clubbingSKU(component, event, helper);
            
        }
        
        
        if(tmpManflg){
            if(manualDiscount>=0){
                var isRegularCustomer = component.get("v.isRegularCustomer");
                var isNonRegularCustomer = component.get("v.isNonRegularCustomer");
                
                //for Regular customer
                if(isRegularCustomer){
                    var palletSize = orderItemList[rowIndex].palletSize;
                    var logisticDis = orderItemList[rowIndex].logisticDiscount;
                    var logisticDisValue;      //changes nandhini            
                    if(orderItemList[rowIndex].PAK){      
                        logisticDisValue = orderItemList[rowIndex].logisticDiscount;            
                    }else{                     
                        logisticDisValue = orderItemList[rowIndex].logisticDiscountValue;    
                    }
                    var truckSize = orderItemList[rowIndex].truckSize;
                    var oneDiscount = component.get("v.paletQtydis");
                    var twoDiscount = component.get("v.truckQtydis");
                    var qtty = orderItemList[rowIndex].qty;
                    var bsPrice = orderItemList[rowIndex].basePrice;
                    
                    
                    
                    
                    
                    
                    var inctmcode = component.get("v.incoTrm1");
                    var logDiscount = 0;
                    
                    
                    if(inctmcode == 'EXW'){
                        if(logisticDisValue!=undefined){
                            logDiscount = logisticDisValue;    
                        }else{
                            logDiscount = 0;
                        }
                        
                        
                    }else{
                        logDiscount = 0;
                    }
                    
                    orderItemList[rowIndex].logisticDiscount = logDiscount;
                    var earlyDiscount = orderItemList[rowIndex].earlyOrderDiscount;
                    var bigVolDiscount = orderItemList[rowIndex].bigVolDiscount;
                    
                    
                    
                    
                    var manualDiscount = orderItemList[rowIndex].manualDiscount;
                    var logisticDiscount = logDiscount;
                    var manualDiscount1;
                    if(manualDiscount==undefined){
                        manualDiscount1 =0;
                    }else{
                        manualDiscount1=manualDiscount;
                    }
                    
                    var tmpmanualDiscount;
                    if(manualDiscount!=''){
                        tmpmanualDiscount = manualDiscount;                
                    }else{
                        tmpmanualDiscount = 0;
                    }
                    
                    
                    
                    
                    var finalPrice = 0.0;
                    var finalPrice1 =0.0;
                    var finalPrice2 =0.0;
                    var finalPrice3 =0.0;
                    
                    
                    
                    finalPrice = (bsPrice -(bsPrice*bigVolDiscount/100)); //earlyDiscount
                    finalPrice = Math.round((finalPrice + Number.EPSILON) * 100) / 100;
                    console.log('After calculation of Early Order discount '+finalPrice);
                    
                    finalPrice1 = (finalPrice - (finalPrice*tmpmanualDiscount/100)); //bigVolDiscount
                    finalPrice1 = Math.round((finalPrice1 + Number.EPSILON) * 100) / 100;
                    console.log('After calculation of Big vol discount '+finalPrice1);
                    
                    finalPrice2 = (finalPrice1 - (finalPrice1*earlyDiscount/100)); //tmpmanualDiscount
                    finalPrice2 = Math.round((finalPrice2 + Number.EPSILON) * 100) / 100;
                    console.log('After calculation of manual discount '+finalPrice2);
                    
                    finalPrice3 = (finalPrice2 - logDiscount); //logDiscount
                    finalPrice3 = Math.round((finalPrice3 + Number.EPSILON) * 100) / 100;
                    console.log('After calculation of logistic discount '+finalPrice3);
                    
                    orderItemList[rowIndex].finalPrice=finalPrice3;
                    var netValue = (finalPrice3 *qtty).toFixed(2);
                    orderItemList[rowIndex].netValue = netValue;
                    component.set("v.orderItemList",orderItemList);
                    
                    
                }//regular customer End
                
                //for Non Regular Customer
                if(isNonRegularCustomer){
                    var manualDis =  orderItemList[rowIndex].manualDiscount;
                    var qtty = orderItemList[rowIndex].qty;
                    var basPrice = orderItemList[rowIndex].basePrice;
                    var manualDis1;
                    if(manualDis==undefined){
                        manualDis1 =0;
                    }else{
                        manualDis1= manualDis;
                    }
                                       
                    var basPrice1;
                    if(basPrice==undefined){
                        basPrice1=0;
                    }else{
                        basPrice1=basPrice;
                    }
                    
                    
                    var qtty1;
                    if(qtty==undefined){
                        qtty1=0;
                    }else{
                        qtty1=qtty;
                    }
                    
                    var finalPrice = 0.0;
                    finalPrice = (basPrice1 - (basPrice1*manualDis1/100));
                    finalPrice = Math.round((finalPrice + Number.EPSILON) * 100) / 100;
                    orderItemList[rowIndex].finalPrice =finalPrice;
                    var netValue = (finalPrice * qtty1).toFixed(2);
                    orderItemList[rowIndex].netValue = netValue;
                    component.set("v.orderItemList",orderItemList);
                    
                         
                }// end of Non Regular
                
            }
            this.updategrossAmmount(component, event, helper);
            this.clubbingSKU(component, event, helper);
        }
        
    },
    
    getDistributorTypePoland:function(component,event,accountIdTemp){
        
        var action = component.get('c.getDistributorTypePolands'); 
        
        action.setParams({
            "accountIdTemp" : accountIdTemp
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            console.log('state '+state);
            
            if(state == 'SUCCESS') {
                console.log('Corrcet in Loading SO Order');
                var customerTypeTemp = a.getReturnValue();
                
                //isKAMWholesManager,v.isRegularCustomer),and(v.isDistributor)
                
                if(customerTypeTemp=='Regular Customer'){
                    
                    component.set("v.isRegularCustomer",true);
                    //component.set("v.isKAMWholesManager",false);
                    //component.set("v.isDistributor",false);
                    component.set("v.isNonRegularCustomer",false);                
                    
                }
                
                
                if(customerTypeTemp=='Non Regular Customer'){
                    //{!v.isKAMWholesManager} {!v.isRegularCustomer} {!v.isNonRegularCustomer}
                    console.log('@@@@ Inside non Regular Customer ');
                    component.set("v.isRegularCustomer",false);
                    component.set("v.isKAMWholesManager",true);
                    component.set("v.isDistributor",false);
                    component.set("v.isNonRegularCustomer",true);
                    
                }
                
            }
        });
        $A.enqueueAction(action);
        
    },
    
    gettingInventory1:function(component,event,helper,skuId){
        console.log('in gettingInventory1 method ');
        var action = component.get('c.gettingSKUInventories');
        action.setParams({
            "skuId" :skuId
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('for Template a.getReturnValue() '+a.getReturnValue());
                var tempInv = a.getReturnValue();
                component.set("v.templateInventory",tempInv);
                
                //component.set("v.SingleOrderItem.inventory",a.getReturnValue());
                
            }
        });
        $A.enqueueAction(action);
    },
    
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
                 component.set("v.recId", a.getReturnValue()[0].AccountId);
                console.log('prName for community '+prName);
                component.set("v.profileNmForComm",prName);

                if (prName == 'Customer Community Plus User - Poland - 1' || prName == 'Customer Community Plus User - Poland - 2' ||
                    prName == 'Customer Partner Community Plus User - Poland - 1' || prName == 'Customer Partner Community Plus User - Poland - 2' )  //Added for RITM0531740 GRZ(Dheeraj Sharma) 04-03-2023
                {
                    component.set("v.accSapCode", a.getReturnValue()[0].Account.SAP_Customer_Code__c);

                }
                    
                console.log('comunityRole second '+comunityRole);
                
                if(comunityRole==2){
                    component.set("v.showCommunityRole",false);
                }else{
                    component.set("v.showCommunityRole",true);
                }
                
                
            }
        });
        $A.enqueueAction(action);
        
        
    },
    
    showToastForClone : function(msg) {
        console.log('inside showToastForClone ');
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "type" : 'error',
            "message": msg
        });
        toastEvent.fire();
    },
    
    gettingManualDiscount:function(component,event,helper,skuCombinationky,accId){
        console.log('in getting manual discount for community');
        
        var action = component.get('c.gettingManualDisc'); 
        action.setParams({
            "combinationKeys" : skuCombinationky,
            "accId" : accId
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                var returnData = a.getReturnValue();
                
                component.set('v.manualDisclone', returnData.Manual_Discount__c);
                component.set('v.paymentTermClone', returnData.Payment_Term__c);
                
                
            }
        });
        $A.enqueueAction(action);
                
    },  
    getDependentLineItem : function(component,event,helper){
        var data=component.get("v.selectedPBRecord");
        console.log('In getDependentLineItem =>> ',data);
        var action = component.get('c.getDependentSKUData'); 
        var accId =  component.get("v.recordId");
        var manualDiscount = component.get("v.SingleOrderItem.manualDiscount");
        var bigVolDiscount = component.get("v.SingleOrderItem.bigVolDiscount");
        var finalPrice = component.get("v.SingleOrderItem.finalPrice");
        var logisticDiscount = component.get("v.SingleOrderItem.logisticDiscount");
        var earlyOrderDiscount = component.get("v.SingleOrderItem.earlyOrderDiscount");
        action.setParams({
            "accId":accId,
            "SKUCode" : data.SKUCode__r.SKU_Code__c,
            "quantity": component.get("v.SingleOrderItem.qty"),
            "paymentTerm":component.get("v.SingleOrderItem.typeOfPayment"),
            "manualDiscount":manualDiscount,
            "bigVolDiscount":bigVolDiscount,
            "logisticDiscount":logisticDiscount,
            "earlyOrderDiscount":earlyOrderDiscount
            
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                var returnData = a.getReturnValue();
                var orderItemList = component.get("v.orderItemList");
                var itemList = [];
                console.log('returnData of Dependent =>> ',returnData);
                var customerDeliveryDate = component.get("v.SingleOrderItem.customerDeliveryDate");
                var getpaymentTerm = component.get("v.SingleOrderItem.typeOfPayment");
                var orderItem = component.get("v.SingleOrderItem");
                
                returnData.forEach(each =>{
                    //each.netValue=
                    each.customerDeliveryDate = customerDeliveryDate;
                    each.manualDiscount = manualDiscount != null && manualDiscount != undefined ? manualDiscount : 0;
                    each.bigVolDiscount = bigVolDiscount!= null && bigVolDiscount != undefined ? bigVolDiscount : 0;;
                    each.earlyOrderDiscount = earlyOrderDiscount!= null && earlyOrderDiscount != undefined ? earlyOrderDiscount : 0;;
                    each.logisticDiscount = logisticDiscount!= null && logisticDiscount != undefined ? logisticDiscount : 0;;
                     
                //********
                var finalPrice = 0.0;
                var finalPrice1 =0.0;
                var finalPrice2 =0.0;
                var finalPrice3 =0.0;
                
 
                    finalPrice = (each.basePrice -(each.basePrice*each.bigVolDiscount/100)); //earlyDiscount
                    finalPrice = Math.round((finalPrice + Number.EPSILON) * 100) / 100;
                console.log('After calculation of big vol '+finalPrice);
                
                    finalPrice1 = (finalPrice - (finalPrice*each.manualDiscount/100));  //bigVolDiscount
                    finalPrice1 = Math.round((finalPrice1 + Number.EPSILON) * 100) / 100;
                console.log('After calculation of manual '+finalPrice1);

                    finalPrice2 = (finalPrice1 - (finalPrice1*each.earlyOrderDiscount/100)); //manualDiscount
                    finalPrice2 = Math.round((finalPrice2 + Number.EPSILON) * 100) / 100;
                console.log('After calcualtion of early  '+finalPrice2);

                    finalPrice3 =finalPrice2 -  each.logisticDiscount; //logDiscount
                    finalPrice3 = Math.round((finalPrice3 + Number.EPSILON) * 100) / 100;

               
                console.log('After calcualtion of Logistic discuount '+finalPrice3);
                if(each.logisticDiscount != null && each.logisticDiscount!= undefined && each.logisticDiscount > 0){
                    each.finalPrice=finalPrice3;
                }else if(each.earlyOrderDiscount != null && each.earlyOrderDiscount != undefined && each.earlyOrderDiscount != '' && each.earlyOrderDiscount >0){
                    each.finalPrice=finalPrice2;
                }else if(each.manualDiscount != null && each.manualDiscount != undefined && each.manualDiscount != '' && each.manualDiscount > 0){
                    each.finalPrice=finalPrice1;
                }/*else if(each.bigVolDiscount != null && each.bigVolDiscount != undefined && each.bigVolDiscount != '' && each.bigVolDiscount > 0){
                    each.finalPrice=finalPrice;
                }*/else{
                    each.finalPrice=finalPrice;//commented above and added this by Nandhini
                }
                
                 each.netValue = (each.finalPrice *each.qty).toFixed(2);
                    itemList.push(JSON.stringify(each));
                    //orderItemList.push(each);
                })
                //returnData[0]['customerDeliveryDate'] = customerDeliveryDate;
                //returnData[1]['customerDeliveryDate'] = customerDeliveryDate;
                //returnData[0]['typeOfPayment'] = getpaymentTerm;
                //returnData[1]['typeOfPayment'] = getpaymentTerm;
                //itemList.push(JSON.stringify(returnData[0]));
                //itemList.push(JSON.stringify(returnData[1]));
                //orderItemList.push(returnData[0]);
                //orderItemList.push(returnData[1]);
                //component.set("v.orderItemList",orderItemList);
                console.log('itemList end:'+itemList);
                helper.saveDependentOrder(component,event,helper,itemList);
                
                
            }
        });
        $A.enqueueAction(action);
    },

    saveDependentOrder : function(component,event,helper,orderItemList){
        var paymentTerm = component.get("v.paymenttrm");
        var incoTerm = component.get("v.incoTrm");
        var orderItem = component.get("v.SingleOrderItem");
        var accID = component.get("v.recordId");
        var orderObjId = component.get("v.orderObjId");
        var itemList = component.get("v.orderItemList");

        var errorMessage ='';
        var soId = component.get("v.sOId");
        var action = component.get('c.saveOrder'); 
        action.setParams({
            "accountId": accID,
            "OrderItemString":null,
            "orderObjId":orderObjId,
            "PaymentTerm":paymentTerm,
            "incoTerm":incoTerm,
            "orderItemListString":JSON.stringify(orderItemList)
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                var returnData = a.getReturnValue();
                console.log('returnData =>> ',returnData);
                let soiList = returnData.soiList;
                soiList.forEach(each =>{ 
                    itemList.push(each);
                })
                component.set("v.orderItemList",itemList);
                this.updateRowCalculations(component, event, helper);             
                this.clubbingSKU(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    }
                
                
                
    
})