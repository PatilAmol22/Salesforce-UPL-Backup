({
    //Logic to get all Account's/Sales order's Data.
    getOrderFields : function(component, event) {
        // show spinner to true on click of a button / onload
        component.set("v.showSpinner", true);
        var action = component.get("c.getOrderFields");
        var accId = component.get("v.recordId");
        var salesOrderId = component.get("v.sOId");
        
        if(accId!=null){
            action.setParams({
                accId: accId
            });
        }
        //console.log('accId'+accId); 
        var opts=[];   
        //  action.setStorable();
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
                console.log('ShippingLocMap'+JSON.stringify(ShippingLocMap));
                var PaymentTermMap = returnValue.PaymentTermMap;
                var PaymentTermMap1 = returnValue.PaymentTermMap1;
                var PaymentTermCustomerMap = returnValue.PaymentTermCustomerMap;
                console.log('PaymentTermMap'+JSON.stringify(PaymentTermMap));
                console.log('PaymentTermCustomerMap'+JSON.stringify(returnValue.PaymentTermCustomerMap).length);
                var DistributorData = returnValue.DistributorData;
                var productTypesList = returnValue.productTypesList;
                
                component.set("v.newSalesOrder.Sold_to_Party__c", component.get("v.recordId"));
                component.set("v.newSalesOrder.Bill_To_Party__c", component.get("v.recordId"));
                component.set("v.newSalesOrder.Distribution_Channel_lk__c",DistributorData.distributorChannelId);
                component.set("v.newSalesOrder.Sales_Org_lk__c",DistributorData.salesOrgId);
                
                if(DistributorData.normalDCostTC!=null && DistributorData.normalDCostTC!=0 && DistributorData.expressDCostTC!=null && DistributorData.expressDCostTC!=0){
                    component.set("v.normalDCostTC",DistributorData.normalDCostTC);
                    component.set("v.expressDCostTC",DistributorData.expressDCostTC);
                    component.set("v.isCustomerTCAvailable",true); 
                }
                
                if(DistributorData.areaManagerId!=null && DistributorData.areaManagerId!='' && DistributorData.areaManagerId!= undefined){
                    component.set("v.newSalesOrder.Manager__c",DistributorData.areaManagerId);
                    component.set("v.areaManagerID",DistributorData.areaManagerId);
                }
                component.set("v.TCParam", returnValue.TransContributionParam);
                component.set("v.newSalesOrder.Division_lk__c", returnValue.DistributorData.divisionId);
                component.set("v.newSalesOrder.Is_Fixed_Rate_Available_Italy__c", returnValue.DistributorData.fixedRateAvailable);
                if(returnValue.DistributorData.normalDCostTC!=undefined){
                    component.set("v.newSalesOrder.Normal_Delivery_Cost__c", returnValue.DistributorData.normalDCostTC);
                }
                if(returnValue.DistributorData.expressDCostTC!=undefined){
                    component.set("v.newSalesOrder.Express_Delivery_Cost__c", returnValue.DistributorData.expressDCostTC);  
                }
                component.set("v.fixedRateAvailable",returnValue.DistributorData.fixedRateAvailable);
                component.set("v.specialRateAvailable",returnValue.DistributorData.specialRateAvailable); //Divya: 12/05/2021: Added for SCTASK0452622
                component.set("v.user",returnValue.userObj);
                component.set("v.userId",returnValue.userObj.Id);
                console.log('DistributorData.priceGroupId'+DistributorData.priceGroupId);
                console.log(returnValue.DistributorData.fixedRateAvailable+'-------------');
                console.log('normal TC : '+returnValue.DistributorData.normalDCostTC);
                console.log('express TC : '+returnValue.DistributorData.expressDCostTC);
                
                if(JSON.stringify(returnValue.PaymentTermCustomerMap).length>2){
                    opts=[];
                    opts.push({"class": "optionClass", label: $A.get("$Label.c.None"), value: 'None'});  
                    for (var key in PaymentTermCustomerMap){
                        opts.push({"class": "optionClass", label: key, value: key});
                    }              
                    component.set("v.PaymentTermMap", PaymentTermCustomerMap);
                    component.set("v.isPaymentDiscDisable", false);
                    component.set("v.discdPT", false); 
                    component.find("paymentListOptions").set("v.options", opts);  
                }else if(((JSON.stringify(returnValue.PaymentTermMap).length>2) &&(DistributorData.priceGroupId!=null && DistributorData.priceGroupId!=''))){
                    console.log('DistributorData.priceGroupId'+DistributorData.priceGroupId);
                    component.set("v.pgCode", DistributorData.priceGroupId);
                    //PaymentTerm Map
                    opts=[];
                    opts.push({"class": "optionClass", label: $A.get("$Label.c.None"), value: 'None'});  
                    for (var key in PaymentTermMap){
                        opts.push({"class": "optionClass", label: key, value: key});
                    }              
                    component.set("v.PaymentTermMap", PaymentTermMap);
                    component.set("v.discdPT", true); 
                    component.find("paymentListOptions").set("v.options", opts);  
                }else{
                    opts=[];
                    opts.push({"class": "optionClass", label: $A.get("$Label.c.None"), value: 'None'});  
                    for (var key in PaymentTermMap1){
                        opts.push({"class": "optionClass", label: key, value: key});
                    }              
                    component.set("v.PaymentTermMap", PaymentTermMap1);
                    component.find("paymentListOptions").set("v.options", opts);   
                    component.set("v.emptyPaymetTerm", true); 
                    component.set("v.isPaymentDiscDisable", false);
                    component.set("v.discdPT", false); 
                }
                
                /*   if(DistributorData.priceGroupId!=null && DistributorData.priceGroupId!=''){
                    console.log('DistributorData.priceGroupId'+DistributorData.priceGroupId);
                    component.set("v.pgCode", DistributorData.priceGroupId);
                    //PaymentTerm Map
                    opts=[];
                    opts.push({"class": "optionClass", label: $A.get("$Label.c.None"), value: 'None'});  
                    for (var key in PaymentTermMap){
                        opts.push({"class": "optionClass", label: key, value: key});
                    }              
                    component.set("v.PaymentTermMap", PaymentTermMap);
                    component.set("v.discdPT", true); 
                    component.find("paymentListOptions").set("v.options", opts);  
                }else if((DistributorData.priceGroupId==null || DistributorData.priceGroupId!='') && JSON.stringify(returnValue.PaymentTermCustomerMap).length>2){
                       component.set("v.pgCode", DistributorData.priceGroupId);
                    //PaymentTerm Map
                    opts=[];
                    opts.push({"class": "optionClass", label: $A.get("$Label.c.None"), value: 'None'});  
                    for (var key in PaymentTermCustomerMap){
                        opts.push({"class": "optionClass", label: key, value: key});
                    }              
                    component.set("v.PaymentTermMap", PaymentTermCustomerMap);
                    component.set("v.discdPT", true); 
                    component.find("paymentListOptions").set("v.options", opts);  
                }
                else if( DistributorData.paymentTerms!=null &&  DistributorData.paymentTerms!=''){
                    console.log('DistributorData.paymentTerms'+DistributorData.paymentTerms);
                    opts=[];
                    opts.push({"class": "optionClass",  label: DistributorData.paymentTerms, value: DistributorData.paymentTerms});  
                    component.find("paymentListOptions").set("v.options", opts);  
                    component.set("v.paymentTerm", DistributorData.paymentTerms);
                    component.set("v.paymentDisc", DistributorData.paymentTermsDiscount);
                    component.set("v.isPaymentDiscDisable", false);
                    component.set("v.discdPT", false); 
                    component.set("v.newSalesOrder.Payment_Term__c", DistributorData.paymentTermId);
                    component.set("v.newSalesOrder.Payment_Term_Discount_Italy__c",DistributorData.paymentTermsDiscount);
                    component.set("v.newSalesOrder.Editable_Payment_Term_Discount__c",DistributorData.paymentTermsDiscount);
                }else{
                     opts=[];
                    opts.push({"class": "optionClass", label: $A.get("$Label.c.None"), value: 'None'});  
                    for (var key in PaymentTermMap1){
                        opts.push({"class": "optionClass", label: key, value: key});
                    }              
                    component.set("v.PaymentTermMap", PaymentTermMap1);
                    component.find("paymentListOptions").set("v.options", opts);   
                    component.set("v.emptyPaymetTerm", true); 
                    component.set("v.isPaymentDiscDisable", false);
                    component.set("v.discdPT", false); 
                }*/
                
                // console.log('v.newSalesOrder'+JSON.stringify(component.get("v.newSalesOrder")));
                
                var profileName = component.get("v.user.Profile.Name");
                //Shipping location Map
                opts=[];
                opts.push({"class": "optionClass", label: $A.get("$Label.c.None"), value: 'None'});  
                for (var key in ShippingLocMap){
                    if(DistributorData.sapCode == ShippingLocMap[key].SAP_Code__c){
                        opts.push({"class": "optionClass", label: 'Stesso indirizzo di fatturazione' ,value: key});
                        console.log('key'+key);
                    }
                }
                for (var key in ShippingLocMap){
                    if(DistributorData.sapCode != ShippingLocMap[key].SAP_Code__c){
                        opts.push({"class": "optionClass", label: ShippingLocMap[key].Location_Name__c+' '+'('+ShippingLocMap[key].City__c+')' ,value: key});
                        console.log('key1'+key);
                    }
                } 
                /*  for (var key in ShippingLocMap){
                    if(DistributorData.sapCode == ShippingLocMap[key].SAP_Code__c){
                        console.log("");
                        opts.push({"class": "optionClass", label: 'SAME AS BILLING ADDRESS' ,value: key});
                    }else{
                        opts.push({"class": "optionClass", label: ShippingLocMap[key].Location_Name__c+' '+'('+ShippingLocMap[key].City__c+')' ,value: key});
                    }
                }      */      
                console.log('key--'+key);
                component.set("v.ShippingLocMap", ShippingLocMap);
                component.find("shippListOptions").set("v.options", opts);  
                
                
                
                // productTypes
                opts=[]; 
                component.set("v.productTypesList", productTypesList);
                component.set("v.productTypesListCopy", productTypesList);  
                if(DistributorData.priceGroupId !=null && DistributorData.priceGroupId!=''){
                    component.set("v.pgCode", DistributorData.priceGroupId);
                }
                //console.log('pgcode'+component.get("v.pgCode"));
                //if sales order id found
                if(salesOrderId){
                    this.reloadSO(component);
                }else{
                    this.loadCart(component,event);
                }
                this.disableSingleOrderRow(component,event); 
                //this.fetchSKUData(component,event); //Deeksha 
                this.getOrderType(component,event); //Added by Azhar
            }
            else{
                var toastMsg = $A.get("$Label.c.Error_While_placing_Order_Please_Contact_System_Administrator");
                this.showErrorToast(component, event, toastMsg);  
            }
        });
        $A.enqueueAction(action);
    },
    getOrderType : function(component,event){
        var opts=[{"class": "optionClass", label: $A.get("$Label.c.Return_Order"), value: "Return Order", selected: "true"}];
        component.find("orderTypeOptions").set("v.options", opts); 
    },
    
    showCmpsOnNormalOrder : function(component,event){
        component.set('v.newSalesOrder.Order_Type_Italy__c','Return Order');
        component.set('v.showStartEndDate',false);
        component.set('v.showChildOrder',false);
        component.set('v.showExpressDelivery',true);
        component.set('v.showFCA',true);
        component.set("v.startDate", '');
        component.set("v.endDate", '');
        component.set('v.showSaveDraft',true);
    },
    /*showCmpsOnParentOrder : function(component,event){
        component.set('v.newSalesOrder.Order_Type_Italy__c','Parent Order');
        component.set('v.showChildOrder',false);
        
        component.set('v.showStartEndDate',true);
        component.set('v.showExpressDelivery',false);
        component.set('v.showFCA',false);
        component.set('v.showSaveDraft',true);
        var today = new Date();
        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        var currentDate = (yyyy + "-" + MM + "-" + dd);
        component.find("startDate").set('v.value', currentDate);
    },*/
    
    disableSingleOrderRow : function(component,event){
        component.set("v.disabledSOI", true);
        component.find("rebId1").set("v.disabled",true);
        component.find("itemqty1").set("v.disabled",true);
        component.find("estimatedFinal1").set("v.disabled",true); 
        component.find("productTypeOptions").set("v.disabled",true); 
    },
    
    //To get SO Id if we Open comp. through "VIEW" button of SO detail page
    //If Comp. is open through "place Order Italy" then this method will not success.
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
    
    
    
    // Method use to enable OrderForm for Editing purpose for both parent and child order
    editForm:function(component,event){
        component.set("v.disableThis", false);
        component.set("v.disableEdit", true);
        component.set('v.showBalanceQty',false);
        //made by Priya Dhawan for SCTASK0333953 (RITM0153568) Validity date in Precampaign order changes
        component.set("v.isModifyDraft", true); 
        var ExpressOrderCheck =component.get("v.ExpressOrderCheck");
        if(ExpressOrderCheck==false){
            component.set("v.disableFCA",false);
        }
        
        if(component.get("v.discdPT")== true){
            component.set("v.isPaymentDiscDisable", true); 
        }else {
            component.set("v.isPaymentDiscDisable", false); 
        }
        var orderTypeItaly=component.get("v.orderType2");
        console.log('orderTypeItaly :'+orderTypeItaly)
        /*if(orderTypeItaly!=undefined){
            /*if(orderTypeItaly!="Child Order" && orderTypeItaly!="Normal Order"){
                component.find("itemsel").set("v.disabled",false);
                var today = new Date();
                var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
                var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
                var yyyy = today.getFullYear();
                var currentDate = (yyyy + "-" + MM + "-" + dd);
                component.find("startDate").set('v.value', currentDate);
                component.find("startDate").set('v.disabled', true);
                component.find("endDate").set('v.disabled', false); 
                component.find("endDate").set('v.value','');
                
            }else{
                component.find("itemsel").set("v.disabled",false);
            }
        }else{
            component.find("itemsel").set("v.disabled",false);
        }*/
        component.find("itemsel").set("v.disabled",false);
        component.set("v.headerMsg", $A.get("$Label.c.Edit_Order"));
        var getProductId = component.find("itemproduct1");
        var isProductArray = Array.isArray(getProductId);
        var orderItemList = component.get("v.orderItemList");
        var pgcodeId = component.get("v.pgCodeId"); 
        var customerCodeId = component.get("v.customerCodeId"); 
        
        for (var idx=0; idx < orderItemList.length; idx++) {
            if(isProductArray){
                component.find("estimatedFinal")[idx].set("v.disabled",false); 
                component.find("rebId")[idx].set("v.disabled",false); 
                // component.find("TC1")[idx].set("v.disabled",false);
                component.find("transC")[idx].set("v.disabled",false);
                component.find("personalNotes1")[idx].set("v.disabled",false);
                if(orderItemList[idx].typeOfProduct=='Omaggio') {
                    component.find("estimatedFinal")[idx].set("v.disabled",true);  
                    component.find("transC")[idx].set("v.disabled",true);  
                    console.log('idx'+idx);
                }
                component.find("deleteBtn")[idx].set("v.disabled",false); 
            }else{
                component.find("estimatedFinal").set("v.disabled",false);
                component.find("rebId").set("v.disabled",false); 
                component.find("transC").set("v.disabled",false); 
                component.find("deleteBtn").set("v.disabled",false);
                component.find("personalNotes1").set("v.disabled",false);
            }
        }
        //If Common Pricebook is selected
        //if(pgcodeId!=undefined && pgcodeId!= null && customerCodeId!=undefined && customerCodeId!=null){
        if((pgcodeId=='' || pgcodeId==undefined || pgcodeId== null) && (customerCodeId=='' || customerCodeId==undefined || customerCodeId== null)){
            component.set("v.isCustomizePB",false);
        }
        
    },
    
    childOrderEditForm:function(component,event){ //Added by Azhar for campaign module
        //console.log('childOrderEditForm :');
        component.set("v.disableThis", false);
        component.set("v.disableEdit", true);
        component.set('v.showOrderType',false);
        
        component.set('v.showChildOrder',false);
        
        component.set('v.showSKU',false);
        component.set('v.three',2);
        component.set('v.four',3);
        component.set('v.five',4);
        component.set('v.showExpressDelivery',true);
        component.set('v.showFCA',true);
        component.set('v.showBalanceQty',true);
        component.set('v.showSaveDraft',false);
        component.set('v.showDeleteAll',false);
        component.set("v.isCustomizePB",true);
        var ExpressOrderCheck =component.get("v.ExpressOrderCheck");
        if(ExpressOrderCheck==false){
            component.set("v.disableFCA",false);
            //component.set("v.disableExpress",false);
        }
        
        if(component.get("v.discdPT")== true){
            component.set("v.isPaymentDiscDisable", true); 
        }else {
            component.set("v.isPaymentDiscDisable", false); 
        }
        //component.find("itemsel").set("v.disabled",false);
        //component.set("v.disabledSOI", false);
        //component.set("v.headerMsg", $A.get("$Label.c.Edit_Order"));
        var getProductId = component.find("itemproduct1");
        var isProductArray = Array.isArray(getProductId);
        var orderItemList = component.get("v.orderItemList");
        var pgcodeId = component.get("v.pgCodeId"); 
        var customerCodeId = component.get("v.customerCodeId"); 
        component.set("v.rebidDisabled",true);
        if(orderItemList.length >=1){
            component.set("v.disableExpress",true);
            
            /*var orderTypeItaly=component.get("v.orderType2");
            if(orderTypeItaly!="Child Order" && orderTypeItaly!="Normal Order"){
                component.set("v.disableExpress",false); 
            }else{
                component.set("v.disableExpress",true); 
            }*/
        }
        
    },
    //Using for showing child Order form to show on edit
    childOrderForm:function(component,event){ //Added by Azhar for campaign module
        component.set("v.disableThis", false);
        component.set("v.disableEdit", false);
        component.set('v.showOrderType',false);
        
        component.set('v.showChildOrder',false);
        
        component.set('v.showSKU',false);
        component.set('v.three',2);
        component.set('v.four',3);
        component.set('v.five',4);
        component.set('v.showExpressDelivery',true);
        component.set('v.showFCA',true);
        component.set('v.showBalanceQty',false);
        component.set('v.showSaveDraft',false);
        component.set('v.showParentOrder',true);
        component.set('v.showDeleteAll',false);
        component.set("v.isCustomizePB",true);
        var ExpressOrderCheck =component.get("v.ExpressOrderCheck");
        if(ExpressOrderCheck==false){
            component.set("v.disableFCA",false);
        }
        
        if(component.get("v.discdPT")== true){
            component.set("v.isPaymentDiscDisable", true); 
        }else {
            component.set("v.isPaymentDiscDisable", false); 
        }
        component.find("itemsel").set("v.disabled",false);
        //component.set("v.disabledSOI", false);
        //component.set("v.headerMsg", $A.get("$Label.c.Edit_Order"));
        var getProductId = component.find("itemproduct1");
        var isProductArray = Array.isArray(getProductId);
        var orderItemList = component.get("v.orderItemList");
        var pgcodeId = component.get("v.pgCodeId"); 
        var customerCodeId = component.get("v.customerCodeId"); 
        if(orderItemList.length >=1){
            component.set("v.disableExpress",false);
        }
    },
    
    handleEstimatedFP : function(component,event,helper,netInvPrice,estimatedFP){
        var errorMessage = '';
        if(estimatedFP){
            console.log(netInvPrice+'---'+estimatedFP);
            if(netInvPrice < estimatedFP){
                component.find("estimatedFinal1").set("v.errors", [{message:$A.get("$Label.c.Please_enter_valid_Estimated_Final_Price")}]);
                component.find("estimatedFinal1").set("v.value",0);
                $A.util.addClass(component.find("estimatedFinal1"), "error");  
            } 
            else{
                component.find("estimatedFinal1").set("v.errors", null); 
                $A.util.removeClass(component.find("estimatedFinal1"), "error");
                component.set("v.SingleOrderItem.averageFinalP",estimatedFP);
            }
        }else{
            errorMessage= $A.get("$Label.c.Please_Enter_Estimated_Final_Price");
            component.find("estimatedFinal1").set("v.errors", [{message:errorMessage}]);
            $A.util.addClass(component.find("estimatedFinal1"), "error");
        }
    },
    
    handleRowEstimatedFP : function(component,event,helper,netinvoice1,estimatedFP,rowIndex){
        var getProductId = component.find("itemproduct1");
        var isProductArray = Array.isArray(getProductId);
        var errorMessage = '';
        if(isProductArray){
            if(estimatedFP){
                console.log(netinvoice1+'---'+estimatedFP+'--'+rowIndex);
                if(netinvoice1 < estimatedFP){
                    component.find("estimatedFinal")[rowIndex].set("v.errors", [{message:$A.get("$Label.c.Please_enter_valid_Estimated_Final_Price")}]);
                    component.find("estimatedFinal")[rowIndex].set("v.value",0);
                    $A.util.addClass(component.find("estimatedFinal")[rowIndex], "error");  
                } 
                else{
                    component.find("estimatedFinal")[rowIndex].set("v.errors", null); 
                    $A.util.removeClass(component.find("estimatedFinal")[rowIndex], "error");
                }
            }else{
                errorMessage= $A.get("$Label.c.Please_Enter_Estimated_Final_Price");
                component.find("estimatedFinal")[rowIndex].set("v.errors", [{message:errorMessage}]);
                $A.util.addClass(component.find("estimatedFinal")[rowIndex], "error");
            }
        }else{
            if(estimatedFP){
                //   console.log(netinvoice1+'---'+estimatedFP+'--');
                if(netinvoice1 < estimatedFP){
                    component.find("estimatedFinal").set("v.errors", [{message:$A.get("$Label.c.Please_enter_valid_Estimated_Final_Price")}]);
                    component.find("estimatedFinal").set("v.value",0);
                    $A.util.addClass(component.find("estimatedFinal"), "error");  
                } 
                else{
                    component.find("estimatedFinal").set("v.errors", null); 
                    $A.util.removeClass(component.find("estimatedFinal"), "error");
                }
            }else{
                errorMessage= $A.get("$Label.c.Please_Enter_Estimated_Final_Price");
                component.find("estimatedFinal").set("v.errors", [{message:errorMessage}]);
                $A.util.addClass(component.find("estimatedFinal"), "error");
            }
            
        }
        console.log('estimatedFP'+estimatedFP);
    },
    
    handleDiscountChange : function(component, event,disc){
        component.set("v.newSalesOrder.Editable_Payment_Term_Discount__c",disc);
    },
    
    loadCart : function(component,event){
        var accId = component.get("v.recordId");
        var action = component.get("c.getCartOrderItems");
        
        if(accId!=null){
            action.setParams({
                accId: accId
            });
            
            action.setCallback(this, function(a) {
                var state = a.getState();
                if(state == "SUCCESS") {
                    var cartData = a.getReturnValue();
                    // alert(cartData.soiList.length);
                    var cartLength =cartData.soiList.length;
                    component.set("v.orderItemList", cartData.soiList);
                    var orderItemList = component.get("v.orderItemList");
                    var orderObjId = cartData.cartOrderId;
                    var IsExpressD = cartData.isExpressDelivery;
                    console.log('IsExpressD'+IsExpressD);
                    console.log('orderTypeItaly '+cartData.orderTypeItaly);
                    component.set("v.orderType",cartData.orderTypeItaly);
                    component.set("v.newSalesOrder.Order_Type_Italy__c",'Return Order');
                    // var grossNetPrice = cartData.grossNetPrice;
                    var grossNetPrice = Math.round(cartData.grossNetPrice * 100) / 100;
                    if(orderItemList.length>0){
                        this.disabledAfterInsert(component,event);
                        component.set("v.disableExpress",true);
                        component.set("v.disableOnExpress",true);
                    };
                    if(orderObjId!=null && orderObjId!='' && orderObjId!= undefined){
                        component.set("v.orderObjId",orderObjId);
                        component.set("v.grossNetPrice",grossNetPrice); 
                        component.set("v.ExpressOrderCheck",IsExpressD);
                        
                        if(IsExpressD==true){
                            component.set("v.disableExpress",true);
                            component.set("v.FCAOrderCheck",false);
                            component.set("v.disableFCA",true);
                            component.set("v.disableOnExpress",true);
                            component.set("v.newSalesOrder.Is_Express_Delivery_Italy__c",IsExpressD);
                        }
                    }
                    console.log('orderItems:'+grossNetPrice+'--'+JSON.stringify(a.getReturnValue()));
                }
                else{
                    var toastMsg = $A.get("$Label.c.Error_While_Loading_Cart");
                    this.showErrorToast(component, event, toastMsg);                      
                }
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
        var emptyPT = component.get("v.emptyPaymetTerm"); 
        var isPDdisabled = component.get("v.isPaymentDiscDisable");
        
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
                    console.log('salesOrder 540'+JSON.stringify(a.getReturnValue()));    
                    component.set("v.newSalesOrder", salesOrder);
                    // console.log('salesOrder: '+salesOrder.Sold_to_Party__r.Name);
                    component.set("v.sfdcOrderNo", salesOrder.Name);
                    component.set("v.orderTypeNames", salesOrder.Order_Type_Code__c); //Divya: 11-01-2020: Added for SCTASK0351764
                    component.set("v.grossNetPrice", salesOrder.Total_Amount__c);
                    if(component.get("v.areaManagerID")!=''){
                        component.set("v.newSalesOrder.Manager__c", component.get("v.areaManagerID"));
                    }
                    
                    if(salesOrder.Is_Order_FCA_Italy__c== true){
                        component.set("v.FCAOrderCheck",true);
                    }
                    if(salesOrder.Is_Express_Delivery_Italy__c== true){
                        component.set("v.ExpressOrderCheck",true);
                    }
                    
                    var orderStatus = salesOrder.Order_Status__c;
                    if(orderStatus == 'Error from SAP'){
                        component.set("v.sapOrderNo", $A.get("$Label.c.Order_not_pushed_to_SAP"));
                        component.set("v.parentSAPOrderNo", $A.get("$Label.c.Order_not_pushed_to_SAP"));
                    }
                    else{
                        component.set("v.sapOrderNo", salesOrder.SAP_Order_Number__c);
                        component.set("v.parentSAPOrderNo", salesOrder.SAP_Order_Number__c);
                    }
                    // SOC :Campaign Order by Azhar 
                    var getOrderType = 'Return Order';
                    //console.log('getOrderType : '+getOrderType);
                    component.set('v.orderType',getOrderType);
                    component.set("v.orderType2",getOrderType);
                    var getStartDate = salesOrder.Valid_From__c;
                    var getEndDate = salesOrder.Valid_To__c;
                    //console.log('salesOrder.Name :'+salesOrder.Name);
                    //console.log('orderStatus :'+orderStatus);
                    component.set("v.disableOnExpress",true);
                    this.showCmpsOnNormalOrder(component,event);
                    /*if(getOrderType=='Parent Order'){
                        component.set('v.showBalanceQty',true);//Sayan
                        //this.showCmpsOnParentOrder(component,event);
                        component.set('v.newSalesOrder.Order_Type_Italy__c','Parent Order');
                        component.set('v.showStartEndDate',true);
                        component.set('v.showSaveDraft',false);
                        var today = new Date();
                        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
                        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
                        var yyyy = today.getFullYear();
                        var currentDate = (yyyy + "-" + MM + "-" + dd);
                        console.log('currentDate :'+currentDate);
                        if(getEndDate<currentDate)
                        {
                            component.set("v.placechildOrderDisabled",true);  
                        }
                        
                        //if(salesOrder.Name!=undefined && orderStatus!='Draft'){ //required only at testing time
                        if(salesOrder.SAP_Order_Number__c !=undefined){ 
                            component.set('v.showChildOrder',true);
                        }
                        component.set('v.showExpressDelivery',false);
                        component.set('v.showFCA',false);
                        component.find("startDate").set('v.value', getStartDate);
                        component.find("endDate").set('v.value', getEndDate);
                        component.find("startDate").set('v.disabled', true);
                        component.find("endDate").set('v.disabled', true);
                    }else if(getOrderType=='Child Order'){
                        console.log('orderType ch : '+component.get('v.orderType2'));
                        component.set("v.sapOrderNo", salesOrder.Parent_SAP_Order_Number__c);
                        component.set('v.parentOrderNo',salesOrder.Sales_Order__r.Name);
                        this.childOrderForm(component);
                    }else{
                        this.showCmpsOnNormalOrder(component,event);
                    }*/
                    // EOC 
                    /*  if(emptyPT== false && isPDdisabled== false){
                        component.set("v.paymentTerm", salesOrder.Payment_Term__c);
                    }else{
                        component.set("v.paymentTerm", salesOrder.Payment_Term__r.Payment_Term__c);
                    }*/
                    component.set("v.paymentTerm", salesOrder.Payment_Term__r.Payment_Term__c);
                    component.set("v.paymentDisc", salesOrder.Editable_Payment_Term_Discount__c);
                    
                    
                    var ShippingLocMap = component.get("v.ShippingLocMap");
                    component.set("v.shippingLoc",salesOrder.Ship_To_Party__r.Name);
                    
                    var slObj = ShippingLocMap[salesOrder.Ship_To_Party__r.Name];
                    component.set("v.selItem", slObj);
                    component.find("rebId1").set("v.disabled",true);
                    component.find("TC1").set("v.disabled",true);
                    component.find("personalNotes").set("v.disabled",true);
                    component.find("itemsel").set("v.disabled",true);
                    component.find("itemsel").set("v.disabled",true);
                    component.find("poNumber").set("v.disabled",true);
                    component.find("FCAOrder").set("v.disabled",true);
                    component.find("expressOrder").set("v.disabled",true);
                    //  disabledOnReload
                    
                    var user = component.get("v.user");
                    var ownerId = salesOrder.OwnerId;
                    var userId = component.get("v.userId");
                    var profileName = component.get("v.orderFields.userObj.Profile.Name");
                    var raisedBy =salesOrder.Order_Raise_By__c
                    console.log('disableEdit :'+component.get("v.disableEdit"));
                    console.log('profileName :'+profileName);
                    console.log('raisedBy :'+raisedBy);
                    //Add all button logic here
                    //if logged in user is owner of record and order is disabled 
                    //  if((orderStatus == 'Rejected' && (userId==ownerId)) || (orderStatus == 'Rejected' && raisedBy =='Area Manager' && profileName =='Area Manager Italy')){
                    if((orderStatus == 'Rejected' && raisedBy =='Sales Agent' && (userId==ownerId)) || (orderStatus == 'Rejected' && raisedBy =='Area Manager' && profileName =='Area Manager Italy') ||(orderStatus == 'Rejected' && raisedBy =='Sales Agent' && profileName =='Customer Service & Finance Manager Italy')){  
                        component.set("v.disableEdit", false); 
                    }/*else{
                        if(getOrderType=='Child Order'){
                            component.set("v.disableEdit", true);
                        }
                    }*/
                    
                    /*if((orderStatus == 'Rejected' && raisedBy =='Sales Agent' && (userId==ownerId)) || (orderStatus == 'Rejected' && raisedBy =='Area Manager' && profileName =='Area Manager Italy')||(orderStatus == 'Rejected' && raisedBy =='Sales Agent' && profileName =='Customer Service & Finance Manager Italy') || profileName =='Sales Director Italy' || profileName =='Country Manager Italy')
                    {  
                        component.set("v.placechildOrderDisabled",true);   
                    }*/
                    component.set("v.placechildOrderDisabled",true);
                    //Disable Fields by default on reload
                    if(salesOrder.Order_Status__c == "Draft"){
                        component.set("v.showSAPNo", false);
                        component.set("v.showSaveDraft", true); 
                        component.set("v.disableEdit", false);
                        if(getOrderType=='Parent Order'){
                            component.find("startDate").set('v.disabled', true);
                            component.find("endDate").set('v.disabled', true);
                        }
                    }
                    component.set("v.disableThis", true);
                    component.set("v.showOnReLoad", true);
                    component.set("v.showRaiseOrder", false);
                    component.set("v.disabledSOI", true);
                    component.set("v.isPaymentDiscDisable", true);
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
    // 1. Method call to reload existing SO
    // 2. Called in getOrderFields() after all Fields are loaded.
    // 3. Uses recordId to fetch related data of a SO record.
    
    
    // Method call to reload Order Items
    // Gets all Order Line Items against the current Sales Order record
    reloadSOItems: function(component){
        console.log(component.get("v.sOId"));
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
                    //console.log('orderItems 969: '+JSON.stringify(a.getReturnValue()));
                    this.disabledOnReload(component);
                }
                else{
                    var toastMsg = $A.get("$Label.c.Error_while_reloading_Order_Items");
                    this.showErrorToast(component, event, toastMsg);                      
                }
            });
            $A.enqueueAction(action);
        }
    }, 
    
    resetOrderItemList:function(component){
        var action = component.get("c.getBlankOrderItemList");
        action.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS") {
                component.set("v.orderItemListTest", a.getReturnValue());
                console.log('After Reset Order Items: '+JSON.stringify(component.get("v.orderItemListTest")));
            }
            else{
                console.log('Error');
            }
        });
        $A.enqueueAction(action);
    },
    //Added by Varun Shrivastava End: SCTASK0360650
    reloadSOParentItems: function(component){
        console.log('reloadSOParentItems');
        //Added by Varun Shrivastava Start : SCTASK0360650
        //var orderItemList = [];
        var testVariable = component.get("v.orderItemListTest");
        console.log('Before Child ORder Test Variable Value:'+JSON.stringify(testVariable));
        component.set("v.orderItemList",component.get("v.orderItemListTest"));
        //Added by Varun Shrivastava End : SCTASK0360650
        var action = component.get("c.getSalesOrderItemsOnChildOrder");
        if(component.get("v.sOId")!=null){
            console.log('sOId  :'+component.get("v.sOId"));
            action.setParams({
                soId: component.get("v.sOId")
            });
            
            action.setCallback(this, function(a) {
                var state = a.getState();
                if(state == "SUCCESS") {
                    component.set("v.orderItemList", a.getReturnValue());
                    //Added by Varun Shrivastava End : SCTASK0360650
                    component.set("v.orderItemListTest",a.getReturnValue());
                    var orderItemResult = component.get("v.orderItemList");
                    var orderItemResult1 = component.get("v.orderItemListTest");
                    //Added by Varun Shrivastava End : SCTASK0360650
                }
                else{
                    var toastMsg = $A.get("$Label.c.Error_while_reloading_Order_Items");
                    this.showErrorToast(component, event, toastMsg);                      
                }
            });
            $A.enqueueAction(action);
        }else{
            console.log('Some Exception');
        }
    }, 
    
    
    //Logic to get all price book master Data with respect to their pg code/sold to party.
    fetchSKUData : function(component, event) {
        var action;
        var priceDetailTableColumns;  
        component.set("v.showSpinner", true);
        
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
        
        var pgCode = component.get("v.pgCode");
        var accId =  component.get("v.recordId");
        console.log('pgCode-: '+pgCode);
        // console.log('accId:- '+accId);
        
        action.setParams({ 
            "accId":accId,
            "pgCode": pgCode
        });  
        
        action.setCallback(this, function(a) {
            component.set("v.showSpinner", false); 
            var state = a.getState();
            console.log('state: '+state);
            console.log('returnValue: '+JSON.stringify(a.getReturnValue()));
            if (state == "SUCCESS") {
                var returnData =a.getReturnValue();
                console.log('returnData'+returnData+'--');
                if(returnData!=null && returnData!='' ){
                    var pgCode1 =  returnData[0]["pgCode"];
                    var customerCode1 =  returnData[0]["customerCode"];
                    component.set("v.pgCodeId",pgCode1); 
                    component.set("v.customerCodeId",customerCode1);
                    if((pgCode1=='' || pgCode1==undefined || pgCode1== null) && (customerCode1=='' || customerCode1==undefined || customerCode1== null)){
                        console.log(pgCode1+'-pgCode1'+'customerCode1'+customerCode1);
                        var soId = component.get("v.sOId");
                        if(soId==null || soId==undefined){
                            component.set("v.isCustomizePB",false);
                        }
                    }
                }
                
                
                
                
                
                
                
                
                
                //pass the column information
                component.set("v.priceDetailList",a.getReturnValue());
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
                //console.log(resp.getError());
            }         
        });
        $A.enqueueAction(action);
    },
    
    updateQty : function(component, event, helper,rowIndex){
        var TCParam = component.get("v.TCParam"); 
        var fRAvailable =component.get("v.fixedRateAvailable");
        var sRAvailable =component.get("v.specialRateAvailable"); //Divya: 12/05/2021: Added for SCTASK0452622
        var expressOrder =component.get("v.ExpressOrderCheck");
        var IscustTCAvailable = component.get("v.isCustomerTCAvailable");
        var normalDCostTC = component.get("v.normalDCostTC");
        var expressDCostTC = component.get("v.expressDCostTC");
        var getProductId = component.find("itemproduct1");
        var isProductArray = Array.isArray(getProductId);
        //Updated by Varun Shrivastava start : SCTASK0360650
        var orderItemList = component.get("v.orderItemList");
        if(component.get("v.isChildOrderType")){
            orderItemList = component.get("v.orderItemListTest");
        }
        //Updated by Varun Shrivastava start : End
        console.log('rowIndex'+rowIndex);
        /*for (var idx = 0; idx < orderItemList.length; idx++) {
            if (idx==rowIndex){
                if(isProductArray){
                    console.log(orderItemList[idx].typeOfProduct);
                    if(orderItemList[idx].typeOfProduct=="Vendita"){
                        if(IscustTCAvailable){
                            if(expressOrder){
                                orderItemList[idx].TransContribution = expressDCostTC* orderItemList[idx].qty;
                                orderItemList[idx].TransContribution2 = expressDCostTC* orderItemList[idx].qty;
                            }else{
                                orderItemList[idx].TransContribution = normalDCostTC* orderItemList[idx].qty;
                                orderItemList[idx].TransContribution2 = normalDCostTC* orderItemList[idx].qty;
                            }
                        }else{
                            if(expressOrder && fRAvailable){
                                orderItemList[idx].TransContribution = TCParam.ExpressFixedRate__c* orderItemList[idx].qty;
                                orderItemList[idx].TransContribution2 = TCParam.ExpressFixedRate__c* orderItemList[idx].qty;
                            }else if(expressOrder){
                                if(orderItemList[idx].palletSize <= orderItemList[idx].qty){
                                    orderItemList[idx].TransContribution = TCParam.ExpressMoreThanPallet__c* orderItemList[idx].qty;
                                    orderItemList[idx].TransContribution2 = TCParam.ExpressMoreThanPallet__c* orderItemList[idx].qty;
                                }else if( orderItemList[idx].palletSize > orderItemList[idx].qty){
                                    orderItemList[idx].TransContribution = TCParam.ExpressLessThanPallet__c* orderItemList[idx].qty;
                                    orderItemList[idx].TransContribution2 = TCParam.ExpressLessThanPallet__c* orderItemList[idx].qty;
                                }
                            }else if(fRAvailable){
                                orderItemList[idx].TransContribution = TCParam.FixedRateCustomer__c* orderItemList[idx].qty;
                                orderItemList[idx].TransContribution2 = TCParam.FixedRateCustomer__c* orderItemList[idx].qty;
                                
                            }else{
                                if(orderItemList[idx].palletSize <= orderItemList[idx].qty){
                                    //Divya: 12/05/2021: Added for SCTASK0452622
                                    if(sRAvailable){
                                        orderItemList[idx].TransContribution = TCParam.Special_More_Than_Pallet__c* orderItemList[idx].qty;
                                        orderItemList[idx].TransContribution2 = TCParam.Special_More_Than_Pallet__c* orderItemList[idx].qty;  
                                    } //End
                                    else{
                                        orderItemList[idx].TransContribution = TCParam.MoreThanPallet__c* orderItemList[idx].qty;
                                        orderItemList[idx].TransContribution2 = TCParam.MoreThanPallet__c* orderItemList[idx].qty;
                                    }
                                    
                                }else if( orderItemList[idx].palletSize > orderItemList[idx].qty){
                                    console.log('Less than pallet 1');
                                    orderItemList[idx].TransContribution = TCParam.LessThanPallet__c* orderItemList[idx].qty;
                                    orderItemList[idx].TransContribution2 = TCParam.LessThanPallet__c* orderItemList[idx].qty;
                                }
                            }
                        }
                    }
                }else{
                    if(orderItemList[idx].typeOfProduct=="Vendita"){
                        if(IscustTCAvailable){
                            if(expressOrder){
                                orderItemList[idx].TransContribution = expressDCostTC* orderItemList[idx].qty;
                                orderItemList[idx].TransContribution2 = expressDCostTC* orderItemList[idx].qty;
                            }else{
                                orderItemList[idx].TransContribution = normalDCostTC* orderItemList[idx].qty;
                                orderItemList[idx].TransContribution2 = normalDCostTC* orderItemList[idx].qty;
                            }
                        }else{
                            if(expressOrder && fRAvailable){
                                orderItemList[idx].TransContribution = TCParam.ExpressFixedRate__c* orderItemList[idx].qty;
                                orderItemList[idx].TransContribution2 = TCParam.ExpressFixedRate__c* orderItemList[idx].qty;
                            }else if(expressOrder){
                                if(orderItemList[idx].palletSize <= orderItemList[idx].qty){
                                    orderItemList[idx].TransContribution = TCParam.ExpressMoreThanPallet__c* orderItemList[idx].qty;
                                    orderItemList[idx].TransContribution2 = TCParam.ExpressMoreThanPallet__c* orderItemList[idx].qty;
                                }else if( orderItemList[idx].palletSize > orderItemList[idx].qty){
                                    orderItemList[idx].TransContribution = TCParam.ExpressLessThanPallet__c* orderItemList[idx].qty;
                                    orderItemList[idx].TransContribution2 = TCParam.ExpressLessThanPallet__c* orderItemList[idx].qty;
                                }
                            }else if(fRAvailable){
                                orderItemList[idx].TransContribution = TCParam.FixedRateCustomer__c* orderItemList[idx].qty;
                                orderItemList[idx].TransContribution2 = TCParam.FixedRateCustomer__c* orderItemList[idx].qty;
                                
                            }else{
                                if(orderItemList[idx].palletSize <= orderItemList[idx].qty){//
                                    console.log('More than pallet 2');
                                    orderItemList[idx].TransContribution = TCParam.MoreThanPallet__c* orderItemList[idx].qty;
                                    orderItemList[idx].TransContribution2 = TCParam.MoreThanPallet__c* orderItemList[idx].qty;
                                }else if( orderItemList[idx].palletSize > orderItemList[idx].qty){
                                    console.log('Less than pallet 2');
                                    orderItemList[idx].TransContribution = TCParam.LessThanPallet__c* orderItemList[idx].qty;
                                    orderItemList[idx].TransContribution2 = TCParam.LessThanPallet__c* orderItemList[idx].qty;
                                }
                            }
                        }
                    }
                }
            }
        }*/
    },
    
    //update calculation of "Add product" row.
    updateRowCalculations1 : function(component, event, helper){
        var orderItem = component.get("v.SingleOrderItem");
        var fRAvailable =component.get("v.fixedRateAvailable");
        var sRAvailable =component.get("v.specialRateAvailable"); //Divya: 12/05/2021: Added for SCTASK0452622
        var expressOrder =component.get("v.ExpressOrderCheck");
        var normalDCostTC = component.get("v.normalDCostTC");
        var expressDCostTC = component.get("v.expressDCostTC");
        var TCParam = component.get("v.TCParam"); 
        var IscustTCAvailable = component.get("v.isCustomerTCAvailable");
        var netPrice =orderItem.netInvoicePrice*orderItem.qty;
        var qty = orderItem.qty;
        var palletSize = orderItem.palletSize;
        var transContri =0;
        var productType =orderItem.typeOfProduct;
        console.log('TCParam'+ JSON.stringify(TCParam.LessThanPallet__c));
        console.log(IscustTCAvailable+'expressOrder'+expressOrder);
        component.set("v.SingleOrderItem.netPrice",netPrice);
        if(productType=='Omaggio'){
            component.set("v.SingleOrderItem.TransContribution",0);
            component.set("v.SingleOrderItem.TransContribution2",0);
            
            //Sayan: 12/07/2021: Added for RITM0230668
            if(IscustTCAvailable){
            }else{
                if(expressOrder && fRAvailable){
                }else if(expressOrder){
                }else if(fRAvailable){
                }else{
                    //Sayan: 12/07/2021: Added for RITM0230668
                    var qtysum = qty;
                    var orderItemListHere = component.get("v.orderItemList");
                    for (var idx=0; idx < orderItemListHere.length; idx++) {
                        if( orderItemListHere[idx].productId == orderItem.productId ){
                            qtysum += orderItemListHere[idx].qty;
                        }
                    }
                    if(palletSize<=qtysum){
                        
                        //Divya: 12/05/2021: Added for SCTASK0452622
                        if(sRAvailable){
                            //transContri =TCParam.Special_More_Than_Pallet__c*qty;
                            //component.set("v.SingleOrderItem.TransContribution",transContri); //Commented By Nikhil
                            //component.set("v.SingleOrderItem.TransContribution2",transContri);
                            
                            //Sayan: 12/07/2021: Added for RITM0230668
                            var orderItemListHere = component.get("v.orderItemList");
                            for (var idx=0; idx < orderItemListHere.length; idx++){
                                if( orderItemListHere[idx].productId == orderItem.productId ){
                                    if( orderItemListHere[idx].typeOfProduct == "Vendita" ){
                                        //orderItemListHere[idx].TransContributionPreviousValue = orderItemListHere[idx].TransContribution;
                                        //orderItemListHere[idx].TransContributionPreviousValue2 = orderItemListHere[idx].TransContribution2;
                                        
                                        orderItemListHere[idx].TransContribution = TCParam.Special_More_Than_Pallet__c*orderItemListHere[idx].qty;
                                        
                                        orderItemListHere[idx].TransContribution2 = TCParam.Special_More_Than_Pallet__c*orderItemListHere[idx].qty;
                                    }
                                }
                            }
                            this.updateRowCalculations(component, event, helper);
                            //Sayan: 12/07/2021: Added for RITM0230668
                            
                        } //End
                        else{
                            transContri =TCParam.MoreThanPallet__c*qty;
                            //component.set("v.SingleOrderItem.TransContribution",transContri); //Commented by Nikhil
                            //component.set("v.SingleOrderItem.TransContribution2",transContri);
                        }
                        
                    }else if(palletSize>qtysum){
                        //transContri =TCParam.LessThanPallet__c*qty;
                        //component.set("v.SingleOrderItem.TransContribution",transContri);  //Commented By Nikhil
                        //component.set("v.SingleOrderItem.TransContribution2",transContri); 
                        
                        //Sayan: 12/07/2021: Added for RITM0230668
                        var orderItemListHere = component.get("v.orderItemList");
                        for (var idx=0; idx < orderItemListHere.length; idx++){
                            if( orderItemListHere[idx].productId == orderItem.productId ){
                                if( orderItemListHere[idx].typeOfProduct == "Vendita" ){
                                    //orderItemListHere[idx].TransContribution = orderItemListHere[idx].TransContributionPreviousValue;
                                    //orderItemListHere[idx].TransContribution2 = orderItemListHere[idx].TransContributionPreviousValue2;
                                    orderItemListHere[idx].TransContribution = TCParam.LessThanPallet__c*orderItemListHere[idx].qty;
                                    orderItemListHere[idx].TransContribution2 = TCParam.LessThanPallet__c*orderItemListHere[idx].qty;
                                }
                            }
                        }
                        this.updateRowCalculations(component, event, helper);
                        //Sayan: 12/07/2021: Added for RITM0230668
                    }
                }
            }
            //Sayan: 12/07/2021: Added for RITM0230668
            
        }else{
            if(IscustTCAvailable){
                if(expressOrder){
                    console.log('expressDCostTC'+expressDCostTC);
                    //component.set("v.SingleOrderItem.TransContribution",expressDCostTC*qty);//Commented by Nikhil
                    component.set("v.SingleOrderItem.TransContribution2",expressDCostTC*qty);
                }else{
                    console.log('normalDCostTC'+normalDCostTC);
                    //component.set("v.SingleOrderItem.TransContribution",normalDCostTC*qty);//Commented by Nikhil
                    component.set("v.SingleOrderItem.TransContribution2",normalDCostTC*qty);
                }
            }else{
                if(expressOrder && fRAvailable){
                    transContri =TCParam.ExpressFixedRate__c*qty;
                    // component.set("v.SingleOrderItem.TransContribution",transContri);//Commented by Nikhil
                    component.set("v.SingleOrderItem.TransContribution2",transContri);
                }else if(expressOrder){
                    if(palletSize<=qty){
                        transContri =TCParam.ExpressMoreThanPallet__c*qty;
                        // component.set("v.SingleOrderItem.TransContribution",transContri);//Commented by Nikhil
                        component.set("v.SingleOrderItem.TransContribution2",transContri);
                        
                    }else if(palletSize>qty){
                        transContri =TCParam.ExpressLessThanPallet__c*qty;
                        // component.set("v.SingleOrderItem.TransContribution",transContri); //Commented by Nikhil
                        component.set("v.SingleOrderItem.TransContribution2",transContri); 
                    }
                }else if(fRAvailable){
                    transContri =TCParam.FixedRateCustomer__c*qty;
                    //  component.set("v.SingleOrderItem.TransContribution",transContri);//Commented by Nikhil
                    component.set("v.SingleOrderItem.TransContribution2",transContri);
                    
                }else{
                    //Sayan: 06/07/2021: Added for SCTASK0452622
                    var qtysum = qty;
                    var orderItemListHere = component.get("v.orderItemList");
                    for (var idx=0; idx < orderItemListHere.length; idx++) {
                        if( orderItemListHere[idx].productId == orderItem.productId ){
                            qtysum += orderItemListHere[idx].qty;
                        }
                    }
                    if(palletSize<=qtysum){
                        //Divya: 12/05/2021: Added for SCTASK0452622
                        if(sRAvailable){
                            transContri =TCParam.Special_More_Than_Pallet__c*qty;
                            //  component.set("v.SingleOrderItem.TransContribution",transContri);//Commented by Nikhil
                            component.set("v.SingleOrderItem.TransContribution2",transContri);
                            
                            //Sayan: 06/07/2021: Added for SCTASK0452622
                            var orderItemListHere = component.get("v.orderItemList");
                            for (var idx=0; idx < orderItemListHere.length; idx++){
                                if( orderItemListHere[idx].productId == orderItem.productId ){
                                    if( orderItemListHere[idx].typeOfProduct == "Vendita" ){
                                        //orderItemListHere[idx].TransContributionPreviousValue = orderItemListHere[idx].TransContribution;
                                        //orderItemListHere[idx].TransContributionPreviousValue2 = orderItemListHere[idx].TransContribution2;
                                        orderItemListHere[idx].TransContribution = TCParam.Special_More_Than_Pallet__c*orderItemListHere[idx].qty;
                                        orderItemListHere[idx].TransContribution2 = TCParam.Special_More_Than_Pallet__c*orderItemListHere[idx].qty;
                                    }
                                }
                            }
                            
                            this.updateRowCalculations(component, event, helper);
                            //Sayan: 06/07/2021: Added for SCTASK0452622
                            
                        } //End
                        else{
                            transContri =TCParam.MoreThanPallet__c*qty;
                            //  component.set("v.SingleOrderItem.TransContribution",transContri);//Commented by Nikhil
                            component.set("v.SingleOrderItem.TransContribution2",transContri);
                        }
                        
                    }else if(palletSize>qtysum){
                        transContri =TCParam.LessThanPallet__c*qty;
                        //  component.set("v.SingleOrderItem.TransContribution",transContri); //Commented by Nikhil
                        component.set("v.SingleOrderItem.TransContribution2",transContri); 
                        
                        //Sayan: 06/07/2021: Added for SCTASK0452622
                        var orderItemListHere = component.get("v.orderItemList");
                        for (var idx=0; idx < orderItemListHere.length; idx++){
                            if( orderItemListHere[idx].productId == orderItem.productId ){
                                if( orderItemListHere[idx].typeOfProduct == "Vendita" ){
                                    //orderItemListHere[idx].TransContribution = orderItemListHere[idx].TransContributionPreviousValue;
                                    //orderItemListHere[idx].TransContribution2 = orderItemListHere[idx].TransContributionPreviousValue2;
                                    orderItemListHere[idx].TransContribution = TCParam.LessThanPallet__c*orderItemListHere[idx].qty;
                                    orderItemListHere[idx].TransContribution2 = TCParam.LessThanPallet__c*orderItemListHere[idx].qty;
                                }
                            }
                        }
                        this.updateRowCalculations(component, event, helper);
                        //Sayan: 06/07/2021: Added for SCTASK0452622
                    }
                }
            }
        }
        console.log('--'+JSON.stringify(orderItem));
        console.log('tc 1 : '+component.find('TC1').get('v.value'));
        
    },
    
    
    updateRowCalculations2 : function(component, event, helper,ProductId,Pallet,Quantity,Check){
        var fRAvailable =component.get("v.fixedRateAvailable");
        var sRAvailable =component.get("v.specialRateAvailable"); //Divya: 12/05/2021: Added for SCTASK0452622
        var expressOrder =component.get("v.ExpressOrderCheck");
        var normalDCostTC = component.get("v.normalDCostTC");
        var expressDCostTC = component.get("v.expressDCostTC");
        var TCParam = component.get("v.TCParam"); 
        var IscustTCAvailable = component.get("v.isCustomerTCAvailable");
        var palletSize = Pallet;
        if(IscustTCAvailable){
        }else{
            if(expressOrder && fRAvailable){
            }else if(expressOrder){
            }else if(fRAvailable){
            }else{
                //Sayan: 06/07/2021: Added for SCTASK0452622
                var qtysum = 0;
                var orderItemListHere = component.get("v.orderItemList");
                for (var idx=0; idx < orderItemListHere.length; idx++) {
                    if( orderItemListHere[idx].productId == ProductId ){
                        qtysum += orderItemListHere[idx].qty;
                    }
                }
                if( qtysum>0 && Check ){
                    qtysum -= Quantity;
                }
                if(palletSize<=qtysum){
                    if(sRAvailable){
                        //Sayan: 06/07/2021: Added for SCTASK0452622
                        var orderItemListHere = component.get("v.orderItemList");
                        for (var idx=0; idx < orderItemListHere.length; idx++){
                            if( orderItemListHere[idx].productId == ProductId ){
                                if( orderItemListHere[idx].typeOfProduct == "Vendita" ){
                                    orderItemListHere[idx].TransContribution = TCParam.Special_More_Than_Pallet__c*orderItemListHere[idx].qty;
                                    orderItemListHere[idx].TransContribution2 = TCParam.Special_More_Than_Pallet__c*orderItemListHere[idx].qty;
                                }
                            }
                        }
                        this.updateRowCalculations(component, event, helper);
                        //Sayan: 06/07/2021: Added for SCTASK0452622
                    } //End
                }else if(palletSize>qtysum){
                    var orderItemListHere = component.get("v.orderItemList");
                    for (var idx=0; idx < orderItemListHere.length; idx++){
                        if( orderItemListHere[idx].productId == ProductId ){
                            if( orderItemListHere[idx].typeOfProduct == "Vendita" ){
                                orderItemListHere[idx].TransContribution = TCParam.LessThanPallet__c*orderItemListHere[idx].qty;
                                orderItemListHere[idx].TransContribution2 = TCParam.LessThanPallet__c*orderItemListHere[idx].qty;
                            }
                        }
                    }
                    this.updateRowCalculations(component, event, helper);
                    //Sayan: 06/07/2021: Added for SCTASK0452622
                }
            }
        }
        
    },
    
    //Updating row when Qty and Final price changes.
    updateRowCalculations : function(component, event, helper){
        var rowIndex = component.get("v.rowIndex");
        var soId = component.get("v.sOId");
        var TCParam = component.get("v.TCParam"); 
        //Updated by Varun Shrivastava start : SCTASK0360650
        var orderItemList = component.get("v.orderItemList");
        if(component.get("v.isChildOrderType")){
            orderItemList = component.get("v.orderItemListTest");
        }
        //Updated by Varun Shrivastava start : End
        var totalNetGross=0;
        var expressOrder =component.get("v.ExpressOrderCheck");
        var IscustTCAvailable = component.get("v.isCustomerTCAvailable");
        var fRAvailable =component.get("v.fixedRateAvailable");
        console.log('expressOrder : '+expressOrder);
        console.log('IscustTCAvailable : '+IscustTCAvailable);
        console.log('fRAvailable : '+fRAvailable);
        var venIdMap={};
        var venProductIdMap={};
        //var venProductIdMap={};
        var venProductQtyMap={};
        var omagProductIdMap={};
        var omagProductQtyMap={};
        var venProductUnitValueMap={};
        var venProductQtySum=0;
        var venProductNetInvoiceQtySum=0;
        var venProductSumQtyMap={};
        var venProductNetInvoiceQtyMap={};
        var venProductIdxMap={};
        
        if(rowIndex==undefined){
            rowIndex = orderItemList.length;
        }
        var authrizationFlag =false;
        var initialPosition =1;
        
        console.log('rowIndex'+rowIndex);
        for (var idx = 0; idx < orderItemList.length; idx++) {
            
            var flag = true;
            if(!orderItemList[idx].qty) {
                flag = false;
                orderItemList[idx].netPrice = orderItemList[idx].netInvoicePrice*orderItemList[idx].qty; //CR110: Added by Azhar Shaikh 
            }
            if(!orderItemList[idx].unitValue && orderItemList[idx].typeOfProduct=="Vendita" ) {
                flag = false;
            }
            if(!orderItemList[idx].productId==false){
                if(flag){
                    //Logic to restrict negative value
                    var qty2 = orderItemList[idx].qty.toString(); //Convert to string
                    orderItemList[idx].qty = parseFloat(qty2.replace("-", "")); //Replace negative sign
                    
                    var value2 = orderItemList[idx].unitValue.toString(); //Convert to string
                    orderItemList[idx].unitValue = parseFloat(value2.replace("-", "")); //Replace negative sign
                    //End of logic 
                    orderItemList[idx].netPrice = orderItemList[idx].netInvoicePrice*orderItemList[idx].qty;
                    
                    if(orderItemList[idx].typeOfProduct=="Omaggio"){
                        var totalQty=0;
                        var totalQty2=0;
                        omagProductQtyMap[orderItemList[idx].productId]=orderItemList[idx].qty;
                        omagProductIdMap[orderItemList[idx].productId]=idx;
                        
                        if(venIdMap.hasOwnProperty(orderItemList[idx].productId)){
                            /* Changed by Azhar on 31 Oct 2020 CR#123*/
                            //SOC//
                            console.log('venProductQtySum in Omaggio:'+ venProductSumQtyMap[orderItemList[idx].productId]);
                            console.log('venProductNetInvoiceQtyMap in Omaggio:'+ venProductNetInvoiceQtyMap[orderItemList[idx].productId]);
                            var venProductIdxMapSplit=[];
                            if(venProductSumQtyMap.hasOwnProperty(orderItemList[idx].productId)){
                                
                                console.log('venProductIdxMap in omaggio :'+JSON.stringify(venProductIdxMap));
                                var strIDx=''+venProductIdxMap[orderItemList[idx].productId]+'';
                                venProductIdxMapSplit=strIDx.split(',');
                                totalQty = venProductSumQtyMap[orderItemList[idx].productId] + orderItemList[idx].qty;
                                for(var p=0; p<venProductIdxMapSplit.length; p++){
                                    orderItemList[venProductIdxMapSplit[p]].averageFinalP =venProductNetInvoiceQtyMap[orderItemList[idx].productId]/totalQty;
                                }
                            }
                            //EOC//
                            console.log('averageFinalP :----- '+orderItemList[venIdMap[orderItemList[idx].productId]].averageFinalP);
                        }else{
                            orderItemList[idx].averageFinalP =venProductUnitValueMap[orderItemList[idx].productId];
                            orderItemList[idx].isDiffProduct=true;
                        }
                        for (var idx1=idx; idx1 >=0; idx1--) {
                            console.log('idx1'+idx1+'orderItemList[idx1].qty'+orderItemList[idx1].qty);
                            if(orderItemList[idx].productId==orderItemList[idx1].productId){
                                totalQty2 = totalQty2 + orderItemList[idx1].qty;
                            }
                            
                            /*if(orderItemList[idx1].typeOfProduct=='Vendita'){
                                console.log(orderItemList[idx1].typeOfProduct);
                                // CR110 Added by Azhar Shaikh
                                if(IscustTCAvailable==false){
                                    if(fRAvailable==false){
                                        if(!component.get("v.specialRateAvailable")){//Sayan
                                            if(expressOrder==false){
                                            if(orderItemList[idx].productId==orderItemList[idx1].productId){
                                                //console.log('-totalQty-'+totalQty);
                                                //console.log('orderItemList[idx].palletSize :'+orderItemList[idx].palletSize);
                                                //console.log('totalQty2 :'+totalQty2);
                                                if( orderItemList[idx].palletSize <= totalQty2){
                                                    
                                                    if(orderItemList[idx1].tcCalculation!='' && orderItemList[idx1].tcCalculation1 !=''){
                                                        
                                                        var tcCalculation=orderItemList[idx1].tcCalculation;
                                                        var tcCalculation1=orderItemList[idx1].tcCalculation1;
                                                        
                                                        var tc=tcCalculation.split("-");
                                                        var tc1=tcCalculation1.split("-");
                                                        
                                                        var tcVar=orderItemList[tc[1]].tcCalculation;
                                                        var tcVar1=orderItemList[tc1[1]].tcCalculation1;
                                                        
                                                        var tcSplit=tcVar.split("-");
                                                        var tcSplit1=tcVar1.split("-");
                                                        
                                                        if(tcSplit[0]!=tcSplit1[0]){
                                                            orderItemList[idx1].TransContribution = tcSplit[0];
                                                            orderItemList[idx1].TransContribution2 = tcSplit1[0];
                                                        }else{
                                                            orderItemList[idx1].TransContribution = TCParam.MoreThanPallet__c* orderItemList[idx1].qty;
                                                            orderItemList[idx1].TransContribution2 = TCParam.MoreThanPallet__c* orderItemList[idx1].qty;
                                                        }
                                                        
                                                    }else{
                                                        orderItemList[idx1].TransContribution = TCParam.MoreThanPallet__c* orderItemList[idx1].qty;
                                                        orderItemList[idx1].TransContribution2 = TCParam.MoreThanPallet__c* orderItemList[idx1].qty;
                                                    }
                                                    
                                                }else if( orderItemList[idx].palletSize > totalQty2){
                                                    
                                                    if(orderItemList[idx1].tcCalculation!='' && orderItemList[idx1].tcCalculation1 !=''){
                                                        
                                                        var tcCalculation=orderItemList[idx1].tcCalculation;
                                                        var tcCalculation1=orderItemList[idx1].tcCalculation1;
                                                        
                                                        var tc=tcCalculation.split("-");
                                                        var tc1=tcCalculation1.split("-");
                                                        
                                                        var tcVar=orderItemList[tc[1]].tcCalculation;
                                                        var tcVar1=orderItemList[tc1[1]].tcCalculation1;
                                                        
                                                        var tcSplit=tcVar.split("-");
                                                        var tcSplit1=tcVar1.split("-");
                                                        
                                                        if(tcSplit[0]!=tcSplit1[0]){
                                                            orderItemList[idx1].TransContribution = tcSplit[0];
                                                            orderItemList[idx1].TransContribution2 = tcSplit1[0];
                                                        }else{
                                                            orderItemList[idx1].TransContribution = TCParam.LessThanPallet__c* orderItemList[idx1].qty;
                                                            orderItemList[idx1].TransContribution2 = TCParam.LessThanPallet__c* orderItemList[idx1].qty;
                                                        }
                                                    }else{
                                                        orderItemList[idx1].TransContribution = TCParam.LessThanPallet__c* orderItemList[idx1].qty;
                                                        orderItemList[idx1].TransContribution2 = TCParam.LessThanPallet__c* orderItemList[idx1].qty;
                                                    }
                                                }
                                            }else{
                                                if(orderItemList[idx].productId==orderItemList[idx1].productId){
                                                    //console.log('-totalQty-'+totalQty);
                                                    if( orderItemList[idx].palletSize <= totalQty2){
                                                        if(orderItemList[idx1].tcCalculation!='' && orderItemList[idx1].tcCalculation1 !=''){
                                                            var tcCalculation=orderItemList[idx1].tcCalculation;
                                                            var tcCalculation1=orderItemList[idx1].tcCalculation1;
                                                            
                                                            var tc=tcCalculation.split("-");
                                                            var tc1=tcCalculation1.split("-");
                                                            
                                                            var tcVar=orderItemList[tc[1]].tcCalculation;
                                                            var tcVar1=orderItemList[tc1[1]].tcCalculation1;
                                                            
                                                            var tcSplit=tcVar.split("-");
                                                            var tcSplit1=tcVar1.split("-");
                                                            
                                                            if(tcSplit[0]!=tcSplit1[0]){
                                                                orderItemList[idx1].TransContribution = tcSplit[0];
                                                                orderItemList[idx1].TransContribution2 = tcSplit1[0];
                                                            }else{
                                                                orderItemList[idx1].TransContribution = TCParam.ExpressMoreThanPallet__c* orderItemList[idx1].qty;
                                                                orderItemList[idx1].TransContribution2 = TCParam.ExpressMoreThanPallet__c* orderItemList[idx1].qty;
                                                            }
                                                        }else{
                                                            orderItemList[idx1].TransContribution = TCParam.ExpressMoreThanPallet__c* orderItemList[idx1].qty;
                                                            orderItemList[idx1].TransContribution2 = TCParam.ExpressMoreThanPallet__c* orderItemList[idx1].qty;
                                                        }
                                                    }else if( orderItemList[idx].palletSize > totalQty2){
                                                        if(orderItemList[idx1].tcCalculation!='' && orderItemList[idx1].tcCalculation1 !=''){
                                                            var tcCalculation=orderItemList[idx1].tcCalculation;
                                                            var tcCalculation1=orderItemList[idx1].tcCalculation1;
                                                            
                                                            var tc=tcCalculation.split("-");
                                                            var tc1=tcCalculation1.split("-");
                                                            
                                                            var tcVar=orderItemList[tc[1]].tcCalculation;
                                                            var tcVar1=orderItemList[tc1[1]].tcCalculation1;
                                                            
                                                            var tcSplit=tcVar.split("-");
                                                            var tcSplit1=tcVar1.split("-");
                                                            
                                                            if(tcSplit[0]!=tcSplit1[0]){
                                                                orderItemList[idx1].TransContribution = tcSplit[0];
                                                                orderItemList[idx1].TransContribution2 = tcSplit1[0];
                                                            }else{
                                                                orderItemList[idx1].TransContribution = TCParam.ExpressLessThanPallet__c* orderItemList[idx1].qty;
                                                                orderItemList[idx1].TransContribution2 = TCParam.ExpressLessThanPallet__c* orderItemList[idx1].qty;
                                                            }
                                                        }else{
                                                            orderItemList[idx1].TransContribution = TCParam.ExpressLessThanPallet__c* orderItemList[idx1].qty;
                                                            orderItemList[idx1].TransContribution2 = TCParam.ExpressLessThanPallet__c* orderItemList[idx1].qty;
                                                        }
                                                    }
                                                }
                                            } 
                                        }
                                        }
                                    }
                                }
                                // EOC
                                initialPosition =idx1;
                                break;
                            }*/
                        }
                    }
                    if(orderItemList[idx].typeOfProduct=="Vendita"){
                        venIdMap[orderItemList[idx].productId]=idx;
                        venProductIdMap[orderItemList[idx].productId]=orderItemList[idx].netInvoicePrice;
                        venProductUnitValueMap[orderItemList[idx].productId]=orderItemList[idx].unitValue;
                        venProductQtyMap[orderItemList[idx].productId]=orderItemList[idx].qty;
                        
                        /* Changed by Azhar on 31 Oct 2020 CR#123*/
                        //SOC//
                        if(venProductSumQtyMap.hasOwnProperty(orderItemList[idx].productId)){
                            venProductQtySum=venProductSumQtyMap[orderItemList[idx].productId]+orderItemList[idx].qty;
                            venProductSumQtyMap[orderItemList[idx].productId]=venProductQtySum;
                        }else{
                            venProductSumQtyMap[orderItemList[idx].productId]=orderItemList[idx].qty;
                        }
                        
                        if(venProductNetInvoiceQtyMap.hasOwnProperty(orderItemList[idx].productId)){
                            var Multi_NIPrice_Qty=orderItemList[idx].netInvoicePrice*orderItemList[idx].qty;
                            venProductNetInvoiceQtySum=venProductNetInvoiceQtyMap[orderItemList[idx].productId]+Multi_NIPrice_Qty;
                            venProductNetInvoiceQtyMap[orderItemList[idx].productId]=venProductNetInvoiceQtySum;
                        }else{
                            var Multi_NIPrice_Qty=orderItemList[idx].netInvoicePrice*orderItemList[idx].qty;
                            venProductNetInvoiceQtyMap[orderItemList[idx].productId]=Multi_NIPrice_Qty;
                        }
                        
                        var idxArray=[];
                        if(!venProductIdxMap.hasOwnProperty(orderItemList[idx].productId)){
                            idxArray.push(idx);
                            venProductIdxMap[orderItemList[idx].productId]=idxArray;
                        }else{
                            venProductIdxMap[orderItemList[idx].productId].push(idx);
                        }
                        //EOC//
                        
                        if(omagProductQtyMap.hasOwnProperty(orderItemList[idx].productId)){
                            orderItemList[omagProductIdMap[orderItemList[idx].productId]].isDiffProduct=false;
                            /* Changed by Azhar on 31 Oct 2020 */
                            //SOC//
                            var venProductIdxMapSplit=[];
                            if(venProductSumQtyMap.hasOwnProperty(orderItemList[idx].productId)){
                                totalQty = omagProductQtyMap[orderItemList[idx].productId] + venProductSumQtyMap[orderItemList[idx].productId];
                                var strIDx=''+venProductIdxMap[orderItemList[idx].productId]+'';
                                venProductIdxMapSplit=strIDx.split(',');
                                for(var p=0; p<venProductIdxMapSplit.length; p++){
                                    orderItemList[venProductIdxMapSplit[p]].averageFinalP =venProductNetInvoiceQtyMap[orderItemList[idx].productId]/totalQty;
                                }
                            }else{
                                totalQty = omagProductQtyMap[orderItemList[idx].productId] + orderItemList[idx].qty;
                                orderItemList[idx].averageFinalP =(orderItemList[idx].netInvoicePrice*orderItemList[idx].qty)/totalQty; 
                            }
                            //EOC//
                        }else{
                            orderItemList[idx].averageFinalP =orderItemList[idx].unitValue;
                        }
                        
                        console.log('orderItemList[idx].averageFinalP'+orderItemList[idx].averageFinalP);
                        orderItemList[idx].tcCalculation =orderItemList[idx].TransContribution+'-'+idx;
                        orderItemList[idx].tcCalculation1 =orderItemList[idx].TransContribution2+'-'+idx;
                        totalNetGross =totalNetGross + orderItemList[idx].netPrice;
                    }
                }
            }
            else{
                //var toastMsg = $A.get("$Label.c.Select_Product_before_Entering_Price_Quantity");
                //this.showErrorToast(component, event, toastMsg);
                console.log('else');
                var getProductId = component.find("itemproduct1");
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
        component.set("v.grossNetPrice",totalNetGross);
        component.set("v.orderItemList",orderItemList); 
        //Updated by Varun Shrivastava start : SCTASK0360650
        if(component.get("v.isChildOrderType")){
            component.set("v.orderItemListTest",orderItemList);
        }
        //Updated by Varun Shrivastava start : End
        console.log(component.get("v.grossNetPrice")+'totalgross'+totalNetGross);
        var grossPriceNet = Math.round(totalNetGross * 100) / 100;
        console.log('grossPriceNet'+grossPriceNet);
        //Logic to update Data only when user Creates Sales Order 
        if(soId==null || soId==undefined){
            this.updateOrderItems(component, event, helper); 
        }
    },
    
    //Logic to update Order Items.
    updateOrderItems :function(component, event, helper){
        try{
            var orderItemList = component.get("v.orderItemList");
            var errorMessage='';
            var action;
            var toastMsg ='';
            action = component.get("c.updateOrderLineItems");
            action.setParams({ 
                "orderItemListString":JSON.stringify(orderItemList)
            }); 
            // alert(JSON.stringify(orderItemList));
            // show spinner to true on click of a button / onload
            component.set("v.showSpinner", true);  
            action.setCallback(this, function(a) {
                // on call back make it false ,spinner stops after data is retrieved
                component.set("v.showSpinner", false);                
                var state = a.getState();
                
                if (state == "SUCCESS") {
                    console.log('a.getReturnValue()--'+JSON.stringify(a.getReturnValue()));//updatedCart
                    errorMessage = a.getReturnValue().errorMessage;
                    if(errorMessage!=''&& errorMessage!=null) {
                        toastMsg = errorMessage;
                        this.showErrorToast(component, event, toastMsg);
                    }else{
                        //component.set("v.orderItemList", orderItemList);
                        toastMsg = $A.get("$Label.c.Cart_Updated");
                        this.showToast(component, event, toastMsg);
                    }
                }else{
                    toastMsg = $A.get("$Label.c.Error_Occured_While_Editing_Cart");
                    this.showErrorToast(component, event, toastMsg);   
                }
            });
            $A.enqueueAction(action);
        }
        catch(err){
            console.log(' 1727 error: '+err);
        }
    },
    
    
    //Logic to delete Order Items
    deleteOrderItem :function(component, event, oliId,orderId,itemsLength,index){
        var oliId =oliId;
        var action = component.get("c.deleteOItem");
        var errorMessage ='';
        console.log(' index:'+index)
        console.log(' orderId 2 :'+orderId)
        console.log(' itemsLength 2 :'+itemsLength)
        if(oliId!=null && oliId!='' && oliId!= undefined){
            action.setParams({
                oliId : oliId,
                "orderId":orderId,
                "itemsLength":itemsLength
            });
            
            component.set("v.showSpinner", true); 
            action.setCallback(this, function(a) {
                component.set("v.showSpinner", false);     
                var state = a.getState();
                if(state == "SUCCESS") {
                    errorMessage = a.getReturnValue().errorMessage;
                    if(errorMessage!=''&& errorMessage!=null) {
                        toastMsg = errorMessage;
                        this.showErrorToast(component, event, toastMsg);
                    }
                    this.resetSingleOrderItem(component);
                }
                else{
                    var toastMsg =  $A.get("$Label.c.Error_While_Deleting_Item_Please_Contact_System_Administrator");
                    this.showErrorToast(component, event, toastMsg);                      
                }
            });
            $A.enqueueAction(action);
        } 
    },
    
    
    //Logic to validate Order data
    validateOrder: function(component){
        
        var today = new Date();
        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        var currentDate = (yyyy + "-" + MM + "-" + dd);
        //End
        var flag = true;
        var toastMsg = '';
        var paymentTermId = component.find("paymentListOptions");
        var paymentTermDiscId = component.find("payDiscount"); //Divya: 03-02-2021: SCTASK0368058
        var creditLimitId = component.find("creditLimitId");
        var shippListOptions = component.find("shippListOptions");
        var startDate = component.find("startDate");
        var endDate = component.find("endDate");
        
        var selectOrderType = component.get("v.orderType");//component.find('orderTypeOptions').get("v.value"); 
        console.log('selectOrderType :'+selectOrderType);
        component.set("v.newSalesOrder.Order_Type_Italy__c",'Return Order');
        /*if(selectOrderType=='Parent Order'){
            if(startDate){
                if(!startDate.get("v.value") || startDate.get("v.value") == undefined) {
                    flag = false;
                    component.find("startDate").set("v.errors",[{message: $A.get("$Label.c.Select_Start_Date")}]);                    
                    $A.util.addClass(startDate, "error");
                }else{
                    var selectedDate = startDate.get("v.value");
                    var x = new Date(selectedDate);
                    var y = new Date(currentDate);
                    
                    if(selectedDate=='Invalid Date'){
                        var dateString = selectedDate;
                        var dateParts = dateString.split("/");
                        selectedDate = new Date(dateParts[2], dateParts[1] - 1, dateParts[0]);
                        x = new Date(selectedDate);
                    }          
                    if (+x < +y) {
                        component.find("startDate").set("v.errors", [{message:$A.get("$Label.c.Date_of_Start_cannot_be_less_than_today")}]);
                        flag = false;
                    }
                    else{
                        $A.util.removeClass(startDate, "error");
                        component.find("startDate").set("v.errors",null);  
                    }
                }
            }
            if(endDate){
                if(!endDate.get("v.value") || endDate.get("v.value") == undefined) {
                    flag = false;
                    component.find("endDate").set("v.errors",[{message: $A.get("$Label.c.Select_End_Date")}]);                    
                    $A.util.addClass(endDate, "error");
                }else{
                    var selectedDate = endDate.get("v.value");
                    var x = new Date(selectedDate);
                    var y = new Date(currentDate);
                    
                    if(selectedDate=='Invalid Date'){
                        var dateString = selectedDate;
                        var dateParts = dateString.split("/");
                        selectedDate = new Date(dateParts[2], dateParts[1] - 1, dateParts[0]);
                        x = new Date(selectedDate);
                    }          
                    if (+x <= +y) {
                        console.log('Date of End cannot be less than today');
                        component.find("endDate").set("v.errors", [{message:$A.get("$Label.c.Date_of_End_cannot_be_less_than_today")}]);
                        flag = false;
                    }
                    else{
                        $A.util.removeClass(endDate, "error");
                        component.find("endDate").set("v.errors",null);  
                    }
                }
            }
        }*/
        if(paymentTermId){
            if(!paymentTermId.get("v.value") || paymentTermId.get("v.value") == 'None') {
                flag = false;
                component.find("paymentListOptions").set("v.errors",[{message: $A.get("$Label.c.Please_select_Payment_Term")}]);                    
                $A.util.addClass(paymentTermId, "error");
            }
        }
        //Divya: 03-02-2021: Added for SCTASK0368058
        /*if(paymentTermDiscId){
            console.log('paymentTermDiscId '+paymentTermDiscId.get("v.value"));
              if(paymentTermDiscId.get("v.value") === undefined || paymentTermDiscId.get("v.value") === null || paymentTermDiscId.get("v.value") === '') {
                  flag = false;
                  console.log('paymentTermDiscId '+paymentTermDiscId.get("v.value"));
                  component.find("payDiscount").set("v.errors",[{message: $A.get("$Label.c.Please_select_Payment_Term_Discount")}]);                    
                  $A.util.addClass(paymentTermDiscId, "error");
              }
          } Divya: 11-02-2021: commented it for SCTASK0380281 */
        /*  if(creditLimitId){
              if(!creditLimitId.get("v.value")) {
                  flag = false;
                  component.find("creditLimitId").set("v.errors",[{message: $A.get("$Label.c.Credit_Information_for_Distributor_not_found")}]);                    
                  $A.util.addClass(creditLimitId, "error");
              }
          }*/
        if(shippListOptions){
            if(!shippListOptions.get("v.value") || shippListOptions.get("v.value") == 'None'){
                flag = false;
                component.find("shippListOptions").set("v.errors",[{message:$A.get("$Label.c.Please_Select_shipping_location")}]); 
                $A.util.addClass(shippListOptions, "error");
            }
        }
        return flag;  
    },
    
    
    //Logic to validate calculation of single order item
    validateSingleOrderItem :function(component){
        try{
            //Ship Validation Patch
            var today = new Date();
            var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
            var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
            var yyyy = today.getFullYear();
            
            // Custom date format for ui:inputDate
            var currentDate = (yyyy + "-" + MM + "-" + dd);
            //End
            
            var orderItemList = component.get("v.orderItemList");
            var orderItem = component.get("v.SingleOrderItem");
            var typeOfProduct =orderItem.typeOfProduct;
            var getProductId = component.find("itemproduct");
            var getUnitValueId = component.find("estimatedFinal1");
            //event.getSource()
            
            var getQtyId = component.find("itemqty1");
            var getShipDtId = component.find("shipDt1");
            var toastMsg = '';
            var flag = true;
            var oLIPIMap={};
            
            for(var i = 0; i <orderItemList.length; i++){//+Vendita
                oLIPIMap[orderItemList[i].productId +'-'+orderItemList[i].typeOfProduct]=orderItemList[i].productId +'-'+orderItemList[i].typeOfProduct;
            }
            
            if(oLIPIMap.hasOwnProperty(orderItem.productId +'-'+orderItem.typeOfProduct)){
                if(orderItem.typeOfProduct=='Omaggio'){//Changed by Azhar on 31 Oct 2020 CR#123
                    toastMsg = $A.get("$Label.c.Duplication_of_omaggio_product_cannot_be_added_in_cart");
                    this.showErrorToast(component, event, toastMsg);
                    flag = false;
                }
                
            }else{
                
                if(!getProductId.get("v.value")) {
                    flag = false;
                    component.find("itemproduct").set("v.errors",[{message: $A.get("$Label.c.Product_is_required")}]);                
                }
                else{
                    component.find("itemproduct").set("v.errors",null);
                }
                
                if(!getQtyId.get("v.value") || getQtyId.get("v.value") == '0') {
                    flag = false;
                    component.find("itemqty1").set("v.errors",[{message: $A.get("$Label.c.Please_enter_Quantity")}]);  
                }
                else{
                    component.find("itemqty1").set("v.errors",null);
                }
                if(getUnitValueId){
                    if((!getUnitValueId.get("v.value") || getUnitValueId.get("v.value") == '0') && (typeOfProduct=="Vendita")) {
                        flag = false;
                        component.find("estimatedFinal1").set("v.errors",[{message: $A.get("$Label.c.Please_Enter_Estimated_Final_Price")}]);    
                    }
                    else{
                        component.find("estimatedFinal1").set("v.errors",null);
                        $A.util.removeClass(component.find("estimatedFinal1"), "error");
                    }
                }
                if(!getShipDtId.get("v.value")) {
                    component.find("shipDt1").set("v.errors",[{message:$A.get("$Label.c.Please_Enter_Shipping_Date")}]);
                    flag = false;
                }
                else{
                    var selectedDate = getShipDtId.get("v.value");
                    var x = new Date(selectedDate);
                    var y = new Date(currentDate);
                    
                    if(selectedDate=='Invalid Date'){
                        var dateString = selectedDate;
                        var dateParts = dateString.split("/");
                        selectedDate = new Date(dateParts[2], dateParts[1] - 1, dateParts[0]);
                        x = new Date(selectedDate);
                    }          
                    if (+x < +y) {
                        component.find("shipDt1").set("v.errors", [{message:$A.get("$Label.c.Date_of_Shipment_cannot_be_less_than_today")}]);
                        flag = false;
                    }
                    else{
                        component.find("shipDt1").set("v.errors",null);  
                    }
                }
            }
            
            return flag;
        }
        catch(err){
            console.log('error: '+err);
        }
    },
    
    
    //Validate Order Items
    validateOrderItems: function(component){
        try{
            
            //Ship Validation Patch
            var today = new Date();
            var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
            var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
            var yyyy = today.getFullYear();
            
            // Custom date format for ui:inputDate
            var currentDate = (yyyy + "-" + MM + "-" + dd);
            //End
            
            var isChildOrder=component.get("v.isChildOrderType");
            var orderItemList = component.get("v.orderItemList");
            //Updated by Varun Shrivastava start : SCTASK0360650
            if(component.get("v.isChildOrderType")){
                orderItemList = component.get("v.orderItemListTest");
            }
            //Updated by Varun Shrivastava start : End
            var getProductId = component.find("itemproduct1");
            var getUnitValueId = component.find("estimatedFinal");
            var getQtyId = component.find("itemqty");
            var getShipDtId = component.find("shipDt");
            var getProductType = component.find("productTypeOptions1");
            
            var toastMsg = '';
            var flag = true;
            var sumOfQty=0;
            var sumVenQty=0;
            
            if(orderItemList.length <= 0){
                flag = false;
            }
            else if(orderItemList.length > 0){
                var isProductArray = Array.isArray(getProductId);
                
                if(isProductArray){
                    for(var i = 0; i <orderItemList.length; i++){
                        console.log('component.get("v.omaggioFlag") :'+component.get("v.omaggioFlag"));
                        //console.log('productId :'+orderItemList[i].productId);    
                        //Product validaiton
                        if(!getProductId[i].get("v.value")) {
                            component.find("itemproduct1")[i].set("v.errors",[{message: $A.get("$Label.c.Product_is_required")}]);               
                            flag = false;
                        }
                        else{
                            component.find("itemproduct1")[i].set("v.errors",null);           
                        }
                        
                        // Shipping Date validaiton
                        if(!getShipDtId[i].get("v.value")) {
                            if(isChildOrder==true){
                                if(!getQtyId[i].get("v.value") || getQtyId[i].get("v.value") == '0') {
                                    component.find("shipDt")[i].set("v.errors",null);
                                }else{
                                    var selectedDate = getShipDtId.get("v.value");
                                    
                                    var x = new Date(selectedDate);
                                    var y = new Date(currentDate);
                                    
                                    if(x=='Invalid Date'){
                                        var dateString = selectedDate;
                                        var dateParts = dateString.split("/");
                                        selectedDate = new Date(dateParts[2], dateParts[1] - 1, dateParts[0]);
                                        x = new Date(selectedDate);
                                    }
                                    console.log('selectedDate: '+x);
                                    console.log('currentDate: '+y);
                                    if (+x < +y) {
                                        component.find("shipDt").set("v.errors", [{message:$A.get("$Label.c.Date_of_Shipment_cannot_be_less_than_today")}]);
                                        flag = false;
                                    } 
                                }
                            }else{
                                component.find("shipDt")[i].set("v.errors",[{message:$A.get("$Label.c.Please_Enter_Shipping_Date")}]);
                                flag = false;
                            }
                        }
                        else{
                            var selectedDate = getShipDtId[i].get("v.value");
                            
                            var x = new Date(selectedDate);
                            var y = new Date(currentDate);
                            
                            if(selectedDate=='Invalid Date'){
                                var dateString = selectedDate;
                                var dateParts = dateString.split("/");
                                selectedDate = new Date(dateParts[2], dateParts[1] - 1, dateParts[0]);
                                x = new Date(selectedDate);
                            }          
                            if (+x < +y) {
                                component.find("shipDt")[i].set("v.errors", [{message:$A.get("$Label.c.Date_of_Shipment_cannot_be_less_than_today")}]);
                                flag = false;
                            }
                            else{
                                component.find("shipDt")[i].set("v.errors",null);  
                            }
                        }
                        
                        if(getUnitValueId){
                            // Unit Value validaiton
                            //   if((!getUnitValueId[i].get("v.value") &&( getUnitValueId[i].get("v.value") == 0 && orderItemList[i].typeOfProduct=="Parent"))){
                            if((!getUnitValueId[i].get("v.value") || getUnitValueId[i].get("v.value") == '0')&&(orderItemList[i].typeOfProduct=="Vendita")){
                                component.find("estimatedFinal")[i].set("v.errors",[{message:$A.get("$Label.c.Please_Enter_Estimated_Final_Price")}]);
                                flag = false;
                            }
                            else{
                                component.find("estimatedFinal")[i].set("v.errors",null); 
                            }
                        }
                        
                        // Quantity validaiton
                        if(isChildOrder==true){
                            sumOfQty = sumOfQty + getQtyId[i].get("v.value");
                            console.log('sumOfQty :'+sumOfQty);
                            /*if(sumOfQty==0){
                                //component.find("itemqty")[i].set("v.errors",[{message: $A.get("$Label.c.Please_enter_Quantity")}]);;
                                //flag = false;
                            }else{
                                if(component.find("itemqty")[i].get("v.value")==null){
                                    component.find("itemqty")[i].set("v.value",0);
                                }else{
                                    component.find("itemqty")[i].set("v.errors",null); 
                                }
                            }*/
                            if(getProductType[i].get('v.value')=='Vendita'){
                                sumVenQty=sumVenQty + getQtyId[i].get("v.value");
                                if(sumVenQty==0){
                                    component.find("itemqty")[i].set("v.errors",[{message: $A.get("$Label.c.Please_enter_Quantity")}]);
                                }
                            }
                        }else{
                            if(!getQtyId[i].get("v.value") || getQtyId[i].get("v.value") == '0') {
                                component.find("itemqty")[i].set("v.errors",[{message: $A.get("$Label.c.Please_enter_Quantity")}]);;
                                flag = false;
                            }
                            else{
                                component.find("itemqty")[i].set("v.errors",0); 
                            }
                        }
                        
                    }
                    if(isChildOrder==true){
                        if(sumOfQty==0){
                            var toastMsg = $A.get("$Label.c.Please_enter_Quantity");
                            this.showErrorToast(component, event, toastMsg);
                            flag = false;
                        }
                        if(sumVenQty==0){
                            var toastMsg = $A.get("$Label.c.Please_enter_Quantity");
                            this.showErrorToast(component, event, toastMsg);
                            flag = false; 
                        }
                        // Code commented for CR115 on 19-09-2020. It will not work for sequence product  
                        /*if(component.get("v.omaggioFlag")==true){
                            var toastMsg = $A.get("$Label.c.Please_enter_Quantity");
                            this.showErrorToast(component, event, toastMsg);
                            var index = component.get("v.rowIndex");
                            component.find("itemqty")[index].set("v.errors",[{message: $A.get("$Label.c.Please_enter_Quantity")}]);
                            flag = false;
                        }*/
                    }
                }
                
                else{
                    
                    //console.log('else'+JSON.stringify(orderItemList));
                    //console.log('ProductType : '+getProductType.get('v.value'));
                    if(getProductType.get('v.value')=='Vendita'){
                        if(!getProductId.get("v.value")) {
                            flag = false;
                            component.find("itemproduct").set("v.errors",[{message: $A.get("$Label.c.Product_is_required")}]);                
                        }
                        else{
                            component.find("itemproduct").set("v.errors",null);
                        }
                        
                        if(!getShipDtId.get("v.value")) {
                            if(isChildOrder==true){
                                if(!getQtyId.get("v.value") || getQtyId.get("v.value") == '0') {
                                    component.find("shipDt").set("v.errors",null);
                                }else{
                                    var selectedDate = getShipDtId.get("v.value");
                                    
                                    var x = new Date(selectedDate);
                                    var y = new Date(currentDate);
                                    
                                    if(x=='Invalid Date'){
                                        var dateString = selectedDate;
                                        var dateParts = dateString.split("/");
                                        selectedDate = new Date(dateParts[2], dateParts[1] - 1, dateParts[0]);
                                        x = new Date(selectedDate);
                                    }
                                    console.log('selectedDate: '+x);
                                    console.log('currentDate: '+y);
                                    if (+x < +y) {
                                        component.find("shipDt").set("v.errors", [{message:$A.get("$Label.c.Date_of_Shipment_cannot_be_less_than_today")}]);
                                        flag = false;
                                    } 
                                }
                            }else{
                                flag = false;
                                component.find("shipDt").set("v.errors",[{message:$A.get("$Label.c.Please_Enter_Shipping_Date")}]);
                            }
                        }
                        else{
                            var selectedDate = getShipDtId.get("v.value");
                            
                            var x = new Date(selectedDate);
                            var y = new Date(currentDate);
                            
                            if(x=='Invalid Date'){
                                var dateString = selectedDate;
                                var dateParts = dateString.split("/");
                                selectedDate = new Date(dateParts[2], dateParts[1] - 1, dateParts[0]);
                                x = new Date(selectedDate);
                            }
                            console.log('selectedDate: '+x);
                            console.log('currentDate: '+y);
                            if (+x < +y) {
                                component.find("shipDt").set("v.errors", [{message:$A.get("$Label.c.Date_of_Shipment_cannot_be_less_than_today")}]);
                                flag = false;
                            }
                            else{
                                component.find("shipDt").set("v.errors",null);  
                            }
                        }
                        
                        if(!getQtyId.get("v.value") || getQtyId.get("v.value") == '0') {
                            flag = false;
                            component.find("itemqty").set("v.errors",[{message: $A.get("$Label.c.Please_enter_Quantity")}]);  
                        }
                        else{
                            component.find("itemqty").set("v.errors",null);
                        }
                        
                        //done by Priya Dhawan for SCTASK0333953 (RITM0153568) Validity date in Precampaign order changes
                        var isModDraft = component.get("v.isModifyDraft");
                        
                        if(getUnitValueId){
                            console.log('*isModifyDraft - > '+isModDraft);
                            //  if((!getUnitValueId.get("v.value") &&( getUnitValueId.get("v.value") == 0 && orderItemList[i].typeOfProduct=="Parent"))){
                            if(isModDraft==false){
                                console.log('*isModifyDraft if - > '+isModDraft);
                                console.log('*New Insert Loop');
                                if((!getUnitValueId.get("v.value") || getUnitValueId.get("v.value") == '0')&&(orderItemList[0].typeOfProduct=="Vendita")){
                                    flag = false;
                                    component.find("estimatedFinal").set("v.errors",[{message:$A.get("$Label.c.Please_Enter_Estimated_Final_Price")}]);    
                                }
                                else{
                                    component.find("estimatedFinal").set("v.errors",null);
                                }
                            }
                            else{
                                console.log('*isModifyDraft else - > '+isModDraft);
                                console.log('*New modify Loop');
                                if((!getUnitValueId[0].get("v.value") || getUnitValueId[0].get("v.value") == '0')&&(orderItemList[0].typeOfProduct=="Vendita")){
                                    flag = false;
                                    component.find("estimatedFinal")[0].set("v.errors",[{message:$A.get("$Label.c.Please_Enter_Estimated_Final_Price")}]);    
                                }
                                else{
                                    component.find("estimatedFinal")[0].set("v.errors",null);
                                }  
                            }
                        }
                    }
                    
                    else{
                        flag = false;
                        var errorMessage = 'Please select product type Vendita';
                        if(errorMessage!=''&& errorMessage!=null) {
                            this.showErrorToast(component, event, errorMessage);
                        }
                    }
                }
            }
            console.log('flag: '+flag);
            return flag;
        }
        catch(err){
            console.log('error: '+err);
        }
    },
    
    
    createOrder : function(component,event,helper) { 
        var isValidItems = this.validateSingleOrderItem(component);
        var newSO = component.get("v.newSalesOrder");
        var newOrder = component.get("v.newOrder");
        var orderItem = component.get("v.SingleOrderItem");
        var orderItemList = component.get("v.orderItemList");
        var accID = component.get("v.recordId");
        var orderObjId = component.get("v.orderObjId");
        var ExpressOrderCheck = component.get("v.ExpressOrderCheck");
        var orderType = component.find('orderTypeOptions').get("v.value")
        console.log('ExpressOrderCheck'+ExpressOrderCheck);
        var TCParam = component.get("v.TCParam"); 
        var fRAvailable =component.get("v.fixedRateAvailable");
        var IscustTCAvailable = component.get("v.isCustomerTCAvailable");
        //console.log('IscustTCAvailable : '+IscustTCAvailable); //should be false for common customers
        //console.log('fRAvailable : '+fRAvailable);//should be false for common customers
        var errorMessage ='';
        var soId = component.get("v.sOId");
        
        
        //console.log('newSO : '+JSON.stringify(newSO));
        //console.log('orderType : '+component.find('orderTypeOptions').get("v.value"));
        //console.log('-------->'+orderObjId);
        //console.log('orderItem --------'+JSON.stringify(orderItem));
        
        
        if(soId==null || soId==undefined){
            if(isValidItems){
                var toastMsg = '';
                var action;
                
                action = component.get("c.saveOrder");
                action.setParams({ 
                    "accountId": accID,
                    "OrderItemString":JSON.stringify(orderItem),
                    "orderObjId":orderObjId,
                    "ExpressOrderCheck":ExpressOrderCheck,
                    "orderType":orderType
                }); 
                
                // show spinner to true on click of a button / onload
                component.set("v.showSpinner", true);  
                action.setCallback(this, function(a) {
                    
                    // on call back make it false ,spinner stops after data is retrieved
                    component.set("v.showSpinner", false);                
                    
                    var state = a.getState();
                    
                    if (state == "SUCCESS") {
                        console.log('a.getReturnValue()'+JSON.stringify(a.getReturnValue()));
                        errorMessage = a.getReturnValue().errorMessage;
                        if(errorMessage!=''&& errorMessage!=null) {
                            toastMsg = errorMessage;
                            this.showErrorToast(component, event, toastMsg);
                        }else{
                            var orderObjId = a.getReturnValue().cartOrderId;
                            if(orderObjId!=null && orderObjId!='' && orderObjId!= undefined){
                                component.set("v.orderObjId",orderObjId);
                            }
                            //console.log('orderItemList :'+JSON.stringify(a.getReturnValue().soitemObj));
                            orderItemList.push(a.getReturnValue().soitemObj);
                            component.set("v.orderItemList", orderItemList);
                            this.updateRowCalculations(component, event, helper);
                            this.disabledAfterInsert(component, event);
                            this.resetSingleOrderItem(component);
                            component.set("v.disableExpress",true);
                            component.set("v.disableOnExpress",true);
                        }
                    }else{
                        toastMsg = $A.get("$Label.c.Some_error_has_occurred_while_Confirming_Order_Please_try_again");
                        this.showErrorToast(component, event, toastMsg);   
                    }
                    
                });
                $A.enqueueAction(action);
            }
        }else{
            this.addTableRow(component,helper,isValidItems);
        }
    },
    
    
    addTableRow : function(component,helper,isValidItems){
        var orderItemList = component.get("v.orderItemList");
        var orderItem = component.get("v.SingleOrderItem");
        var toastMsg = '';
        if(isValidItems){
            orderItemList.push(orderItem);
            component.set("v.orderItemList", orderItemList);
            toastMsg = "Added Successfully";
            this.updateRowCalculations(component, event, helper);
            this.disabledAfterInsert(component, event);
            this.showToast(component, event, toastMsg);
            this.resetSingleOrderItem(component);
            component.set("v.disableExpress",true);
            component.set("v.disableOnExpress",true);
        }else{
            toastMsg = $A.get("$Label.c.Please_provide_valid_input_fill_all_the_mandatory_fields_before_proceeding");
            this.showErrorToast(component, event, toastMsg);   
        }
    },
    
    
    resetSingleOrderItem : function(component) { 
        var productTypes = component.get("v.productTypesList");
        var OrderItem = component.get("v.SingleOrderItem");
        if(OrderItem!=undefined && OrderItem!= null){
            component.set("v.SingleOrderItem",{"typeOfProduct":productTypes[0]});
            component.find("estimatedFinal1").set("v.disabled",false); 
            component.set("v.SingleOrderItem.productName","") ;
            component.set("v.SingleOrderItem.qty","") ;
            component.set("v.SingleOrderItem.materialPrice","") ;
            component.set("v.SingleOrderItem.UOM","");    
            component.find("personalNotes").set("v.value",""); 
        }
    },
    
    removeZeroQuantityforChildOrder : function(component){
        var rowIndex = component.get("v.rowIndex");
        var soId = component.get("v.sOId");
        var TCParam = component.get("v.TCParam"); 
        var orderItemList = component.get("v.orderItemList");
        var totalNetGross=0;
        var expressOrder =component.get("v.ExpressOrderCheck");
        var IscustTCAvailable = component.get("v.isCustomerTCAvailable");
        var fRAvailable =component.get("v.fixedRateAvailable");
        var isChildOrder=component.get("v.isChildOrderType");
        var getQtyId = component.find("itemqty");
        var sumOfQty=0;
        var ommagioflag = false;  
        var initialPosition =0;
        var initialPositionStr ='';
        if(rowIndex==undefined){
            rowIndex = orderItemList.length;
        }
        
        
        console.log('orderItemList outside : '+JSON.stringify(orderItemList));
        var venMap={};
        var venArrayList=[];
        var allvenMap={};
        for (var idx = 0; idx < orderItemList.length; idx++) {
            console.log('--->>>');
            if(orderItemList[idx].typeOfProduct=='Vendita' ){ 
                allvenMap[orderItemList[idx].salesOrderItemId] = idx;
                if(orderItemList[idx].qty!=0){
                    console.log('------------------vendita > 0--------------');
                    venMap[orderItemList[idx].salesOrderItemId]=orderItemList[idx];
                    venArrayList.push(orderItemList[idx]);
                    
                    console.log('orderItemList[idx]>>---->'+JSON.stringify(orderItemList[idx])); 
                }
            }     
        }
        console.log('venMap>>--->'+JSON.stringify(venMap));
        for (var idx = 0; idx < orderItemList.length; idx++) {
            if(orderItemList[idx].qty!=0 && orderItemList[idx].typeOfProduct=="Omaggio"){
                console.log('Omaggio Type > 0') ;
                //component.set('v.omaggioFlag',false);//Added for for CR115 on 19-09-2020. It will for sequence product 
                if(venMap.hasOwnProperty(orderItemList[idx].VenditaPosition)){
                    venArrayList.push(orderItemList[idx]);
                    console.log('venArrayList : '+JSON.stringify(venArrayList)) ;
                }else{   
                    component.set("v.rowIndex",allvenMap[orderItemList[idx].VenditaPosition]); 
                    console.log('Omaggio qty is less than zer0') ;
                    ommagioflag = true; 
                    component.set('v.omaggioFlag',true);
                }
                
            }
        }
        
        console.log('ommagioflag : '+ommagioflag)
        if(ommagioflag==false){
            component.set('v.omaggioFlag',false);
            for (var idx = 0; idx < orderItemList.length; idx++) {
                var flag = true;
                if(!orderItemList[idx].productId==false){
                    if(flag){
                        if(isChildOrder==true){
                            sumOfQty = sumOfQty + getQtyId[idx].get("v.value");
                            console.log('sumOfQty :'+sumOfQty);
                        }
                    }
                }
            }
            for (var idx = 0; idx < orderItemList.length; idx++) {
                var flag = true;
                if(!orderItemList[idx].productId==false){
                    if(flag){
                        console.log('orderItemList[idx].typeOfProduct : '+orderItemList[idx].typeOfProduct);
                        
                        //logic to delete row associated with Parent Item
                        console.log('idx :'+idx);
                        console.log('sumOfQty :'+sumOfQty);
                        if(sumOfQty!=0){
                            console.log('sumOfQty is not zero :'+sumOfQty);
                            if(idx != orderItemList.length - 1 && orderItemList[idx].typeOfProduct=='Vendita' && orderItemList[idx].productId!=null && orderItemList[idx].productId!=''){
                                if(orderItemList[idx].qty==0){
                                    orderItemList.splice(idx,1);
                                    break;
                                    for (var idx1=idx+1; idx1<=orderItemList.length; idx1) {
                                        if(orderItemList[idx1]!=undefined){
                                            if(orderItemList[idx1].typeOfProduct=='Omaggio'){
                                                orderItemList.splice(idx1,1);  
                                                //console.log('orderItemList>>---->'+JSON.stringify(orderItemList)); 
                                            }else{break;}
                                        }else{break;}
                                    }
                                }
                            }
                        }
                        //EOC
                    }
                }
            }
        }
    },
    
    
    // Create sales order on Save as Draft button. 
    createSalesOrder : function(component, event, status) {
        // Added for child order
        var orderTypeItaly=component.get("v.OrderTypeItaly");
        var isChildOrder=component.get("v.isChildOrderType");
        var salesOrderId = component.get("v.sOId"); 
        var grossNetPrice1 = component.get("v.grossNetPrice"); 
        var grossNetPrice = Math.round(grossNetPrice1* 100) / 100;
        console.log('grossNetPrice1 :'+grossNetPrice1+'--'+grossNetPrice);
        console.log('orderTypeItaly :'+orderTypeItaly);
        console.log('isChildOrder'+isChildOrder);
        console.log('status'+status);
        console.log('salesOrderId'+salesOrderId);
        /*if(isChildOrder==true){
            if(status!='Draft'){
                component.set("v.orderType","Child Order");
                component.set("v.newSalesOrder.Order_Type_Italy__c","Child Order");
                component.set("v.newSalesOrder.Valid_From__c",'');
                component.set("v.newSalesOrder.Valid_To__c",'');
                component.set("v.newSalesOrder.Sales_Order__c",salesOrderId);
                component.set("v.newSalesOrder.Total_Amount__c",grossNetPrice);
                component.set("v.newSalesOrder.Parent_SAP_Order_Number__c",component.get("v.parentSAPOrderNo"));// get SAP order no from parent
                component.set("v.newSalesOrder.Id",undefined);
                var childSO = component.get("v.newSalesOrder");
                var orderItemList = component.get("v.orderItemList");
                //Updated by Varun Shrivastava start : SCTASK0360650
                if(component.get("v.isChildOrderType")){
                    orderItemList = component.get("v.orderItemListTest");
                }
                //Updated by Varun Shrivastava start : End
                // Code commented for CR115 on 19-09-2020. It will not work for sequence product
                //this.removeZeroQuantityforChildOrder(component); 
                //console.log('childSO :'+JSON.stringify(childSO));
                //console.log('orderItemList childSO	:'+JSON.stringify(orderItemList));
                
            }
        }*/
        //EOC
        var isValid = this.validateOrder(component); 
        var isValidItems = this.validateOrderItems(component);
        var pgcodeId = component.get("v.pgCodeId"); 
        var customerCodeId = component.get("v.customerCodeId");
        // var isValidateShipping = this.validateShipping(component);
        
        if(isValid && isValidItems){
            var paymentTerm = component.get("v.paymentTerm");
            var toastMsg = '';
            var newSO = component.get("v.newSalesOrder");
            // var poNumber =component.get("v.newSalesOrder.PONumber__c");
            var orderItemList = component.get("v.orderItemList");
            console.log('newSO :'+JSON.stringify(newSO));
            console.log('orderItemList :'+JSON.stringify(orderItemList));
            component.set("v.newSalesOrder.Total_Amount__c",grossNetPrice);
            
            //Patch Added Date:13/9/2019
            if(customerCodeId!=undefined && customerCodeId!=''){
                component.set("v.newSalesOrder.Price_Book_Type__c","Customer Wise Pricebook");
            }else if(pgcodeId!=undefined && pgcodeId!=''){
                component.set("v.newSalesOrder.Price_Book_Type__c","Customized Pricebook");
            }else{
                component.set("v.newSalesOrder.Price_Book_Type__c","Common Pricebook");
            }
            //Patch End
            
            var action;
            if(status=="Submitted") {
                //Execute to save order on Submit button
                component.set("v.newSalesOrder.Order_Status__c","Submitted");
                component.set("v.disableThis", true);
            }else if(status== "Draft") {
                //Execute to save as draft without flag check/rollback
                console.log('status : '+status);
                component.set("v.newSalesOrder.Order_Status__c", "Draft");    
            }
            action = component.get("c.saveSalesOrder");
            action.setParams({ 
                "soObj": newSO,
                "salesOrderItemString": JSON.stringify(orderItemList)
            });   
            
            // show spinner to true on click of a button / onload
            component.set("v.showSpinner", true);             
            
            action.setCallback(this, function(a) {
                
                // on call back make it false ,spinner stops after data is retrieved
                component.set("v.showSpinner", false);                
                
                var state = a.getState();
                
                if (state == "SUCCESS") {
                    
                    var recordId = a.getReturnValue().soObj.Id;
                    console.log('a.getReturnValue().soObj'+JSON.stringify(a.getReturnValue().soObj));
                    component.set("v.recordId",recordId);
                    var orderStatus = a.getReturnValue().soObj.Order_Status__c;
                    
                    component.set("v.newSalesOrder",a.getReturnValue().soObj);
                    component.set("v.sfdcOrderNo", a.getReturnValue().sfdcOrderNo);
                    component.set("v.OrderTypeItaly", a.getReturnValue().orderTypeItaly);
                    var errorMessage = a.getReturnValue().soObj.ErrorMessage__c;
                    console.log('error msg:'+errorMessage+'status'+status);
                    
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
                            console.log('orderStatus'+orderStatus);
                            
                            this.callPdfafterSave(component,recordId);
                            
                            this.gotoURL(component, recordId); 
                        }else if(status=="Draft"){
                            var toastMg = $A.get("$Label.c.Draft_Order_Saved_Successfully");
                            
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
                            this.gotoURL(component, recordId); 
                        }
                    }
                }
                else{
                    toastMsg = $A.get("$Label.c.Some_error_has_occurred_while_Confirming_Order_Please_try_again");
                    this.showErrorToast(component, event, toastMsg);   
                }
                
            });
            $A.enqueueAction(action);
        }
        else{
            toastMsg = $A.get("$Label.c.Please_provide_valid_input_fill_all_the_mandatory_fields_before_proceeding");
            this.showErrorToast(component, event, toastMsg);
            this.toggleConfirmDialog(component);
            this.toggleConfirmDialog(component);
        }
    },
    
    disabledAfterInsert  :function(component, event){
        var getProductId = component.find("itemproduct1");
        var orderItemList = component.get("v.orderItemList");
        var isProductArray = Array.isArray(getProductId);
        if(orderItemList.length >=1){
            for (var idx=0; idx < orderItemList.length; idx++) {
                if(isProductArray){
                    if(orderItemList[idx].typeOfProduct =="Omaggio"){
                        component.find("estimatedFinal")[idx].set("v.disabled",true);
                        component.find("transC")[idx].set("v.disabled",true);
                        
                    }
                }else{
                    if(orderItemList.typeOfProduct =="Omaggio"){
                        component.find("estimatedFinal").set("v.disabled",true);
                        component.find("transC").set("v.disabled",true);
                    }
                }
            }
        }
    },
    
    callPdfafterSave:function(component,recordId){
        var action;
        console.log('callPdfafterSave');
        action = component.get("c.saveSalesOrderPFD");
        action.setParams({ 
            "recordId": recordId
        }); 
        
        // show spinner to true on click of a button / onload
        component.set("v.showSpinner", true);  
        action.setCallback(this, function(a) {
            
            // on call back make it false ,spinner stops after data is retrieved
            component.set("v.showSpinner", false);                
            var state = a.getState();
            if (state == "SUCCESS") {
                console.log('success');
                //   console.log('a.getReturnValue()'+JSON.stringify(a.getReturnValue()));
            }
        });
        $A.enqueueAction(action);
    },
    
    //Logic to disable all fields when reload.
    disabledOnReload :function(component){
        var getProductId = component.find("itemproduct1");
        var orderItemList = component.get("v.orderItemList");
        var isProductArray = Array.isArray(getProductId);
        if(orderItemList.length >=1){
            console.log('isChildOrderType : '+component.get("v.isChildOrderType"));
            if(component.get("v.isChildOrderType")==false){
                for (var idx=0; idx < orderItemList.length; idx++) {
                    console.log('isChildOrderType : '+component.get("v.isChildOrderType"));
                    //if(isChildOrderType==false){
                    if(isProductArray){
                        component.find("rebId")[idx].set("v.disabled",true); 
                        //  component.find("stRebate")[idx].set("v.disabled",true); 
                        component.find("transC")[idx].set("v.disabled",true); 
                        component.find("estimatedFinal")[idx].set("v.disabled",true); 
                        component.find("personalNotes1")[idx].set("v.disabled",true); 
                        component.find("deleteBtn")[idx].set("v.disabled",true); 
                        console.log('isProductArray'+isProductArray);
                    }else{
                        component.find("rebId").set("v.disabled",true);
                        component.find("transC").set("v.disabled",true);
                        component.find("personalNotes1").set("v.disabled",true);
                        component.find("deleteBtn").set("v.disabled",true);
                        component.find("estimatedFinal").set("v.disabled",true); 
                    }
                }
            }else{
                for (var idx=0; idx < orderItemList.length; idx++) {
                    console.log('isChildOrderType : '+component.get("v.isChildOrderType"));
                    if(isProductArray){
                        component.find("transC")[idx].set("v.disabled",false);
                    }
                }
            }
        }
        console.log(component.get("v.isCommonPB"));
        component.set("v.isCustomizePB",true);
    },
    
    disabledOnParentReload :function(component){
        var getProductId = component.find("itemproduct1");
        var orderItemList = component.get("v.orderItemList");
        var isProductArray = Array.isArray(getProductId);
        if(orderItemList.length >=1){
            component.set("v.disableExpress",false);
            for (var idx=0; idx < orderItemList.length; idx++) {
                if(isProductArray){
                    component.find("rebId")[idx].set("v.disabled",true); 
                    //  component.find("stRebate")[idx].set("v.disabled",true); 
                    component.find("transC")[idx].set("v.disabled",true); 
                    component.find("estimatedFinal")[idx].set("v.disabled",true); 
                    component.find("personalNotes1")[idx].set("v.disabled",true); 
                    component.find("deleteBtn")[idx].set("v.disabled",false); 
                    console.log('isProductArray'+isProductArray);
                }else{
                    component.find("rebId").set("v.disabled",true);
                    component.find("transC").set("v.disabled",true);
                    component.find("personalNotes1").set("v.disabled",true);
                    component.find("deleteBtn").set("v.disabled",false);
                    component.find("estimatedFinal").set("v.disabled",true); 
                }
            }
        }
        console.log(component.get("v.isCommonPB"));
        component.set("v.isCustomizePB",true);
    },
    
    /* updateOnExpressChangeTC: function(component,event,helper){
        var TCParam = component.get("v.TCParam"); 
        var orderItemList = component.get("v.orderItemList");
        var expressOrder =component.get("v.ExpressOrderCheck");
        var fRAvailable =component.get("v.fixedRateAvailable");
        
        for (var idx = 0; idx < orderItemList.length; idx++) {
            if(orderItemList[idx].typeOfProduct=="Vendita" ) {
                
                if(orderItemList[idx].typeOfProduct=="Vendita"){
                    if(expressOrder && fRAvailable){
                        orderItemList[idx].TransContribution = TCParam.ExpressFixedRate__c* orderItemList[idx].qty;
                        orderItemList[idx].TransContribution2 = TCParam.ExpressFixedRate__c* orderItemList[idx].qty;
                    }else if(expressOrder){
                        if(orderItemList[idx].palletSize <= orderItemList[idx].qty){
                            orderItemList[idx].TransContribution = TCParam.ExpressMoreThanPallet__c* orderItemList[idx].qty;
                            orderItemList[idx].TransContribution2 = TCParam.ExpressMoreThanPallet__c* orderItemList[idx].qty;
                        }else if( orderItemList[idx].palletSize > orderItemList[idx].qty){
                            orderItemList[idx].TransContribution = TCParam.ExpressLessThanPallet__c* orderItemList[idx].qty;
                            orderItemList[idx].TransContribution2 = TCParam.ExpressLessThanPallet__c* orderItemList[idx].qty;
                        }
                    }else if(fRAvailable){
                        orderItemList[idx].TransContribution = TCParam.FixedRateCustomer__c* orderItemList[idx].qty;
                        orderItemList[idx].TransContribution2 = TCParam.FixedRateCustomer__c* orderItemList[idx].qty;
                        
                    }else{
                        if(orderItemList[idx].palletSize <= orderItemList[idx].qty){//
                            orderItemList[idx].TransContribution = TCParam.MoreThanPallet__c* orderItemList[idx].qty;
                            orderItemList[idx].TransContribution2 = TCParam.MoreThanPallet__c* orderItemList[idx].qty;
                        }else if( orderItemList[idx].palletSize > orderItemList[idx].qty){
                            orderItemList[idx].TransContribution = TCParam.LessThanPallet__c* orderItemList[idx].qty;
                            orderItemList[idx].TransContribution2 = TCParam.LessThanPallet__c* orderItemList[idx].qty;
                        }
                    }
                }//  
                
            }
        }
         
        this.updateOrderItems(component, event, helper); 
        component.set("v.orderItemList",orderItemList); 
    },*/
    
    
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
    
    //Logic to show/hide modal by toggling css class .tog2
    toggleMultipleOfCartDialog: function(component){
        var dialog = component.find("multipleOfCartDialog");
        $A.util.toggleClass(dialog, "slds-hide");
        
        var backdrop5 = component.find("backdrop5");
        $A.util.toggleClass(backdrop5, "slds-hide");
    },
    
    //Logic to show/hide modal by toggling css class .tog2
    toggleDialog: function(component){
        var dialog = component.find("approvalDialog");
        $A.util.toggleClass(dialog, "slds-hide");
        
        var backdrop2 = component.find("backdrop2");
        $A.util.toggleClass(backdrop2, "slds-hide");
    },
    
    //Logic to show/hide confirm modal by toggling css class .tog3
    toggleConfirmDialog: function(component){
        var dialog = component.find("confirmDialog");
        $A.util.toggleClass(dialog, "slds-hide");
        
        var backdrop3 = component.find("backdrop3");
        $A.util.toggleClass(backdrop3, "slds-hide");
        
    }, 
    
    closePopUp: function(component) {
        this.toggle(component);
    },
    
    
    //Logic to Redirect sales order after creation
    redirectToListView : function(component, recordId) {
        var device = $A.get("$Browser.formFactor");
        var recrdId = recordId;
        if(device=='DESKTOP'){
            try{
                sforce.one.navigateToList('00B0k000001YexGEAS',null,"Sales_Order__c");
            }catch(err){
                console.log('catch');
                sforce.one.navigateToList('00B0k000001YexGEAS',null,"Sales_Order__c");
            }
        }
        else{
            console.log('else url');
            sforce.one.navigateToList('00B0k000001YexGEAS',null,"Sales_Order__c");
        }
    },
    
    
    //Logic to Redirect sales order after creation
    gotoURL : function(component, recordId) {
        var device = $A.get("$Browser.formFactor");
        var recrdId = recordId;
        
        
        if(device=='DESKTOP'){
            try{
                //Modified by Deeksha : For full screen
                var urlInstance= window.location.hostname;
                var baseURL = 'https://'+urlInstance+'/lightning/r/Sales_Order__c/'+recordId+'/view';
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": baseURL
                });
                urlEvent.fire();
                //sforce.one.navigateToSObject(recordId);
                //END:Modified by Deeksha : For full screen
                //  sforce.one.navigateToList('00B0k000001YexGEAS',null,"Sales_Order__c");
            }catch(err){
                console.log('catch');
                // sforce.one.navigateToList('00B0k000001YexGEAS',null,"Sales_Order__c");
                this.navigateToComponent(component,recrdId);
            }
        }
        else{
            console.log('else url'+recordId);
            //Redirect to Standard ListView when placing orders in SF1.
            // this.navigateToComponent(component,recordId);
            //Modified by Deeksha : For full screen
            var urlInstance= window.location.hostname;
            var baseURL = 'https://'+urlInstance+'/lightning/r/Sales_Order__c/'+recordId+'/view';
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": baseURL
            });
            urlEvent.fire();
            //END:Modified by Deeksha : For full screen
            //sforce.one.navigateToSObject(recordId);
        }
    },
    
    //Called through "gotoURL" method
    navigateToComponent: function(component,recrdId){
        var navEvent = $A.get("e.force:navigateToSObject");
        
        if(navEvent!=undefined){
            
            navEvent.setParams({
                "recordId": recrdId,
                "slideDevName": related
                
            });
            navEvent.fire();    
            
        }
        else{
            window.history.back();
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
            try{
                sforce.one.showToast({
                    "title": error,
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
    
    
    showWarningToast : function(component, event, warningMessage) {
        component.set("v.toastFlag","setWarn"); 
        try{
            sforce.one.showToast({
                "title": "Warning!",
                "message":warningMessage,
                "type": "warning"
            });}catch(err){
                component.set("v.flagMessage",warningMessage);
                var x =document.getElementById("snackbar");
                x.className = "show";
                setTimeout(function(){ x.className = x.className.replace("show", ""); }, 3000);
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
                console.log('err'+err);
                var x = document.getElementById("snackbar");
                x.className = "show";
                setTimeout(function(){ x.className = x.className.replace("show", ""); }, 3000); 
                console.log('toastMsg'+toastMsg);
            }
        }
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
                
                var enableApproval = component.get("v.approvalList.enableApproval");
                if(userId!='Admin NUCO Colombia'){
                    component.set("v.showApproveReject", enableApproval);
                }
            }	
        });
        $A.enqueueAction(action);        
    }
    
})