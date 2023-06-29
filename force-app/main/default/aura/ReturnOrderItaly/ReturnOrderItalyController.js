({
    
    // Init method to initalize default values in form on component load. 
    doInit: function(component, event, helper) {
        helper.getSOSTP(component);
        window.setTimeout($A.getCallback(function() {helper.getOrderFields(component);}),2000 );
    }, 
    
    // Logic to hide all selection modals    
    closeMultipleOfDialog : function(component, event, helper) {
        helper.toggleMultipleOfDialog(component);
    },
    
    // Logic to hide all selection modals    
    closeDialog : function(component, event, helper) {
        helper.toggleDialog(component);
    },
    
    //Logic to hide all selection modals    
    closePopUp : function(component, event, helper) {
        helper.closePopUp(component);
    }, 
    
    //Logic to hide all selection modals    
    closeConfirmDialog : function(component, event, helper) {
        helper.toggleConfirmDialog(component);
    }, 
    
    //Logic to show confirmation dialog with Simulation Flag & Message on Save and Submit.
    openConfirmDialog : function(component, event, helper) {
        component.set("v.newSalesOrder.Is_Order_FCA_Italy__c",true);
        helper.toggleConfirmDialog(component);
    },
    //Logic for Ordertype selection by Azhar
    handleOrderTypeChange : function(component, event, helper) {
        var selectOrderType = component.find('orderTypeOptions').get("v.value"); 
        console.log('selectOrderType :'+selectOrderType);
        helper.showCmpsOnNormalOrder(component,event);
        
        /*if(selectOrderType=='Parent Order'){
            helper.showCmpsOnParentOrder(component,event);
        }else{
            helper.showCmpsOnNormalOrder(component,event);
        }*/
    },
    
    //Logic to show confirmation dialog with Simulation Flag & Message on Save and Submit.
    saveSalesOrderData : function(component, event, helper) {
        // helper.toggleConfirmDialog(component);
        var selected = event.getSource().get("v.label");
        console.log('selected :'+selected);
        
        //helper.createSalesOrder(component, event, "Submitted");
        if(selected=="Confirm" || selected=="Conferma"){
            component.set("v.isDraft", false);
            helper.createSalesOrder(component, event, "Submitted");
        }else if(selected=="Yes" || selected=="Yes"){
            component.set("v.isDraft", false);
            helper.createSalesOrder(component, event, "Submitted");
        }
            else{
                var FCAOrderCheck = component.get("v.FCAOrderCheck");
                var ExpressOrderCheck =component.get("v.ExpressOrderCheck");
                console.log('FCAOrderCheck :'+FCAOrderCheck);
                console.log('ExpressOrderCheck :'+ExpressOrderCheck);
                if(FCAOrderCheck){
                    component.set("v.newSalesOrder.Is_Order_FCA_Italy__c",true);
                }else{
                    component.set("v.newSalesOrder.Is_Order_FCA_Italy__c",false);
                }
                
                component.set("v.isDraft", true);
                helper.createSalesOrder(component, event, "Draft");
            }
    },
    
    // Method use to enable Editing of Order Form using 'Edit' button 
    // Enabled when order status is 'Draft/Rejected'
    editForm : function(component, event, helper) {
        console.log('orderType2 :'+component.get("v.orderType2"));
        helper.editForm(component);
    },
    
    
    //Event used to get selected row from 'Lightning Data Table' Component (Used for Account/SOM/Product)
    tabActionClicked: function(component, event, helper){
        //get the id of the action being fired
        var actionId = event.getParam('actionId');
        //get the row where click happened and its position
        var itemRow = event.getParam('row');
        console.log('itemRow'+JSON.stringify(itemRow));
        
        if(actionId == 'selectproduct'){
            var orderItemList = component.get("v.orderItemList");
            var productTypes = component.get("v.productTypesList");
            
            component.set("v.SingleOrderItem",itemRow);
            if(orderItemList.length==0){
                component.set("v.SingleOrderItem.typeOfProduct",productTypes[0]) ;
                component.find("productTypeOptions").set("v.disabled",true);
                component.find("estimatedFinal1").set("v.disabled",false); 
            }else{
                component.set("v.SingleOrderItem.typeOfProduct",productTypes[0]) ;
                component.find("productTypeOptions").set("v.disabled",false);
            }
            
            if((itemRow.pgCode!='' && itemRow.pgCode!= null)||(itemRow.customerCode!='' && itemRow.customerCode!= null)){
                component.set("v.SingleOrderItem.unitValue",itemRow.unitValue);
                component.set("v.SingleOrderItem.unitValue2",itemRow.unitValue);
                component.set("v.SingleOrderItem.averageFinalP",itemRow.unitValue);
            }else{
                component.set("v.SingleOrderItem.unitValue",'');
            }
            
            component.set("v.SingleOrderItem.qty",'') ;
            component.find("rebId1").set("v.disabled",false);
            
            component.set("v.SingleOrderItem.productId",itemRow.skuId) ;
            component.set("v.SingleOrderItem.productName",itemRow.skuDescription) ;
            component.set("v.SingleOrderItem.flagImage",itemRow.flagImage) ;//for Stock flag
            
            
            /*if(itemRow.flagImageText!=undefined){
                component.set("v.SingleOrderItem.flagImageText",itemRow.flagImageText) ;
            }*/
            if(itemRow.flagImageDisc!=undefined){
                component.set("v.SingleOrderItem.flagImageDisc",itemRow.flagImageDisc.replace(/(?:\r\n|\r|\n)/g, '\n')) ;
            }
            if(itemRow.accrualDiscount!=0){
                component.set("v.SingleOrderItem.accrualDiscount",itemRow.accrualDiscount) ;
            }else{
                component.set("v.SingleOrderItem.accrualDiscount",null) ;
            }
            component.set("v.SingleOrderItem.pricebookId",itemRow.pricebookId) ;// Added for pricebook Id
            component.set("v.SingleOrderItem.productCode",itemRow.skuCode) ;
            component.set("v.SingleOrderItem.netInvoicePrice",itemRow.materialPrice) ;
            component.set("v.SingleOrderItem.palletSize",itemRow.palletSize);
            component.set("v.SingleOrderItem.standardRebate2",itemRow.standardRebate);
            var today = new Date();
            var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
            var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
            var yyyy = today.getFullYear();
            var currentDate = (yyyy + "-" + MM + "-" + dd);
            component.set("v.SingleOrderItem.shipDate",currentDate);
            component.set("v.disabledSOI", false);
            component.find("estimatedFinal1").set("v.disabled",false);
            component.find("TC1").set("v.disabled",false);
            component.find("personalNotes").set("v.disabled",false);
            
            // CR110 : Added by Azhar Shaikh 11-05-2020
            // SOC
            var target = component.find("rebId1");
            // var pgCode = component.get("v.pgCode");
            var pgCode = component.get("v.pgCodeId");
            var customerCode = component.get("v.customerCodeId");
            console.log('pgCode :'+pgCode);
            console.log('customerCode :'+customerCode);
            var orderItem = component.get("v.SingleOrderItem");
            var ProductType = orderItem.typeOfProduct;
            console.log('ProductType'+ProductType);
            var netInvPrice = 0;
            var netInvPrice1 = 0;
            var netPrice = 0;
            if(ProductType=='Vendita'){
                target.set("v.value",true);
                if(target.get("v.value")== true){
                    // netInvPrice = orderItem.materialPrice - orderItem.standardRebate;
                    netInvPrice1 = orderItem.materialPrice - orderItem.standardRebate;
                    netInvPrice =Math.round(netInvPrice1 * 100) / 100;
                    netPrice = orderItem.qty*netInvPrice;
                    component.set("v.SingleOrderItem.netInvoicePrice",netInvPrice);
                    console.log(netInvPrice);
                    if((pgCode==null || pgCode==undefined) && (customerCode==null || customerCode==undefined)){
                        component.find("estimatedFinal1").set("v.value",'');
                    }
                    component.set("v.SingleOrderItem.netPrice",netPrice);
                }
                console.log('pgCode'+pgCode);
                var estimatedFP = component.find("estimatedFinal1").get("v.value");
                helper.handleEstimatedFP(component,event,helper,netInvPrice,estimatedFP);
            }else{
                target.set("v.value",false);
            }
            // EOC
        }
        console.log('SingleOrderItem'+JSON.stringify(component.get("v.SingleOrderItem")));
        helper.closePopUp(component);
    },
    
    //handle rebate discount change for single order item
    handleRDiscountChange1: function(component,event,helper){
        //  var target = event.getSource();  
        var target = component.find("rebId1");
        // var pgCode = component.get("v.pgCode");
        var pgCode = component.get("v.pgCodeId");
        var customerCode = component.get("v.customerCodeId");
        console.log(pgCode+'pgCode');
        var orderItem = component.get("v.SingleOrderItem");
        var ProductType = orderItem.typeOfProduct;
        console.log('ProductType'+ProductType);
        var netInvPrice = 0;
        var netInvPrice1 = 0;
        var netPrice = 0;
        if(ProductType=='Vendita'){
            if(target.get("v.value")== true){
                // netInvPrice = orderItem.materialPrice - orderItem.standardRebate;
                netInvPrice1 = orderItem.materialPrice - orderItem.standardRebate;
                netInvPrice =Math.round(netInvPrice1 * 100) / 100;
                netPrice = orderItem.qty*netInvPrice;
                component.set("v.SingleOrderItem.netInvoicePrice",netInvPrice);
                console.log(netInvPrice);
                if((pgCode==null || pgCode==undefined) && (customerCode==null || customerCode==undefined)){
                    component.find("estimatedFinal1").set("v.value",'');
                }
                component.set("v.SingleOrderItem.netPrice",netPrice);
            }else{
                netInvPrice = orderItem.materialPrice ;
                netPrice = orderItem.qty*netInvPrice;
                component.set("v.SingleOrderItem.netInvoicePrice",netInvPrice);
                console.log(netInvPrice);
                if((pgCode==null || pgCode==undefined) && (customerCode==null || customerCode==undefined)){
                    component.find("estimatedFinal1").set("v.value",'');//changed 0 to ''
                }
                component.set("v.SingleOrderItem.netPrice",netPrice);
            }
            //   if(pgCode!=null && pgCode!=undefined){
            console.log('pgCode'+pgCode);
            var estimatedFP = component.find("estimatedFinal1").get("v.value");
            helper.handleEstimatedFP(component,event,helper,netInvPrice,estimatedFP);
            // }
        }
    },
    
    
    
    //handle rebate discount change
    handleRDiscountChange: function(component,event,helper){
        var target1 = event.getSource();  
        var rowIndex = target1.get("v.labelClass");
        //  var pgCode = component.get("v.pgCode");
        var pgCode = component.get("v.pgCodeId");
        var customerCode = component.get("v.customerCodeId");
        var orderItemList = component.get("v.orderItemList");
        var getProductId = component.find("itemproduct1");
        var isProductArray = Array.isArray(getProductId);
        console.log('rowIndex'+rowIndex);
        var netPrice = 0;
        var netinvoice1 =0;
        for (var idx=0; idx < orderItemList.length; idx++) {
            if (idx==rowIndex){
                if(isProductArray){
                    if(orderItemList[idx].typeOfProduct=="Vendita"){
                        if(orderItemList[idx].applyRebate == true){
                            var netInPrice = orderItemList[idx].netInvoicePrice = Math.round((orderItemList[idx].materialPrice - orderItemList[idx].standardRebate) * 100) / 100;
                            netPrice = orderItemList[idx].qty*netInPrice;
                            component.find("netInvPrice2")[idx].set("v.value", 0);
                            component.find("netInvPrice2")[idx].set("v.value", netInPrice);
                            if((pgCode==null || pgCode==undefined) && (customerCode==null || customerCode==undefined)){
                                component.find("estimatedFinal")[idx].set("v.value",0);  
                            }
                            component.find("ntPrice")[idx].set("v.value",netPrice);
                            netinvoice1 = netInPrice;
                        }else{
                            var netInPrice = orderItemList[idx].netInvoicePrice =orderItemList[idx].materialPrice;
                            netPrice = orderItemList[idx].qty*netInPrice;
                            component.find("netInvPrice2")[idx].set("v.value",0);
                            component.find("netInvPrice2")[idx].set("v.value",netInPrice);
                            if((pgCode==null || pgCode==undefined) && (customerCode==null || customerCode==undefined)){
                                component.find("estimatedFinal")[idx].set("v.value",0);  
                            }
                            component.find("ntPrice")[idx].set("v.value",netPrice);
                            netinvoice1 = netInPrice;
                        }
                        //   if(pgCode!=null && pgCode!=undefined){
                        console.log('pgCode'+pgCode);
                        var estimatedFP = component.find("estimatedFinal")[idx].get("v.value");
                        helper.handleRowEstimatedFP(component,event,helper,netinvoice1,estimatedFP,rowIndex);
                        // }    
                    }
                    helper.updateRowCalculations(component, event, helper);
                }else{
                    if(orderItemList[idx].typeOfProduct=="Vendita"){
                        if(orderItemList[idx].applyRebate== true){
                            var netInPrice = orderItemList[idx].netInvoicePrice = Math.round((orderItemList[idx].materialPrice - orderItemList[idx].standardRebate) * 100) / 100;
                            netPrice = orderItemList[idx].qty*netInPrice;
                            component.find("netInvPrice2").set("v.value", 0);
                            component.find("netInvPrice2").set("v.value", netInPrice);
                            if((pgCode==null || pgCode==undefined) && (customerCode==null || customerCode==undefined)){
                                component.find("estimatedFinal").set("v.value",0);  
                            }
                            component.find("ntPrice").set("v.value",netPrice);
                            netinvoice1 = netInPrice;
                        }else{
                            var netInPrice =  orderItemList[idx].netInvoicePrice =orderItemList[idx].materialPrice;
                            netPrice = orderItemList[idx].qty*netInPrice;
                            component.find("netInvPrice2").set("v.value",0);
                            component.find("netInvPrice2").set("v.value",netInPrice);
                            if((pgCode==null || pgCode==undefined) && (customerCode==null || customerCode==undefined)){
                                component.find("estimatedFinal").set("v.value",0);  
                            }
                            component.find("ntPrice").set("v.value",netPrice);
                            netinvoice1 = netInPrice;
                        }
                        //  if(pgCode!=null && pgCode!=undefined){
                        console.log('rowIndex'+rowIndex);
                        var estimatedFP = component.find("estimatedFinal").get("v.value");
                        helper.handleRowEstimatedFP(component,event,helper,netinvoice1,estimatedFP,rowIndex);
                        //   } 
                    }
                    helper.updateRowCalculations(component, event, helper);
                }
            }
        }
    },
    
    
    //Logic to handle Product Change
    handleProductChange: function(component,event,helper){
        var target = event.getSource(); 
        //  var netInvoicePrice = component.get("v.SingleOrderItem.netInvoicePrice");
        var orderItemList = component.get("v.orderItemList");
        var orderItem = component.get("v.SingleOrderItem");
        if(target.get("v.value") == "Omaggio"){
            component.find("estimatedFinal1").set("v.value",0);
            component.find("estimatedFinal1").set("v.errors",null); 
            component.find("estimatedFinal1").set("v.disabled",true);  
            component.set("v.SingleOrderItem.netInvoicePrice",0) ;
            component.set("v.SingleOrderItem.TransContribution2",0);
            component.set("v.SingleOrderItem.netPrice",0);
            component.find("TC1").set("v.value",0);
            component.find("TC1").set("v.disabled",true);
            
            //Sayan: 09/07/2021: Added for SCTASK0452622
            if(orderItem.qty!=null && orderItem.qty!=0 ){
                helper.updateRowCalculations1(component,event,helper);
            }
            //Sayan: 09/07/2021: Added for SCTASK0452622
            
        }else if(target.get("v.value") == "Vendita"){
            component.find("estimatedFinal1").set("v.disabled",false);
            component.find("TC1").set("v.disabled",false);  
            if(orderItem.qty!=null && orderItem.qty!=0 ){
                helper.updateRowCalculations1(component,event,helper);
            }
            $A.enqueueAction(component.get('c.handleRDiscountChange1'));
        }
    },
    
    
    // Validation to check if shipping Date less than today on Cart
    onDateChangeValidFromDate : function(component,event,helper){
        var inputCmp = event.getSource(); 
        var rowIndex = inputCmp.get("v.labelClass");
        console.log('rowIndex'+rowIndex);
        var value = inputCmp.get("v.value");
        var soId = component.get("v.sOId");
        var today = new Date();
        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        
        // Custom date format for ui:inputDate
        var currentDate = (yyyy + "-" + MM + "-" + dd);
        var x = new Date(value);
        var y = new Date(currentDate);
        
        var flag = true;
        if(x=='Invalid Date'){
            inputCmp.set("v.errors", [{message:"Date of Shipment is Required"}]);           
            $A.util.addClass(inputCmp, "error");
            flag = false; 
        }
        // is less than today?
        else if (+x < +y) {
            inputCmp.set("v.errors", [{message: $A.get("$Label.c.Date_of_Shipment_cannot_be_less_than_today")}]);    
            $A.util.addClass(inputCmp, "error");
            flag = false;
        } 
            else {
                inputCmp.set("v.errors", null);
                $A.util.removeClass(inputCmp, "error");
                if(soId==null || soId==undefined){
                    helper.updateOrderItems(component, event, helper); 
                }
            }
    },
    
    // Validation to check if Valid From less than today for single order item
    onDateChangeValidFromDate1 : function(component){
        var inputCmp = component.find("shipDt1");
        var value = inputCmp.get("v.value");
        
        var today = new Date();
        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        
        // Custom date format for ui:inputDate
        var currentDate = (yyyy + "-" + MM + "-" + dd);
        var x = new Date(value);
        var y = new Date(currentDate);
        
        var flag = true;
        if(x=='Invalid Date'){
            inputCmp.set("v.errors", [{message:"Date of Shipment is Required"}]);           
            $A.util.addClass(inputCmp, "error");
            flag = false; 
        }
        // is less than today?
        else if (+x < +y) {
            inputCmp.set("v.errors", [{message:$A.get("$Label.c.Date_of_Shipment_cannot_be_less_than_today")}]);    
            $A.util.addClass(inputCmp, "error");
            flag = false;
        } 
            else {
                inputCmp.set("v.errors", null);
                $A.util.removeClass(inputCmp, "error");
            }
    },
    
    // Validation to check if Valid From less than today for single order item
    onDateChangeStartFromDate : function(component){
        var startDate = component.find("startDate");
        var today = new Date();
        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        
        // Custom date format for ui:inputDate
        var currentDate = (yyyy + "-" + MM + "-" + dd);
        
        var flag = true;
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
    },
    // Validation to check if Valid From less than today for single order item
    onDateChangeEndFromDate : function(component){
        var endDate = component.find("endDate");
        var today = new Date();
        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        
        // Custom date format for ui:inputDate
        var currentDate = (yyyy + "-" + MM + "-" + dd);
        
        var flag = true;
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
                //done by Priya Dhawan for SCTASK0333953 (RITM0153568) Validity date in Precampaign order changes 
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
    },
    //Logic to handle changes on TC
    handleTransportChange: function(component, event, helper){
        var soId = component.get("v.sOId");
        if(soId==null || soId==undefined){
            helper.updateOrderItems(component, event, helper); 
        }
    },
    //added by nikhil to get the tranportaion cost 
    handleTransportCost:function(component,event,helper)
    {
        var transportValue = document.getElementById("TC1").value;
        document.getElementById("transC").value = transportValue;
    }
    ,
    handleFCAChange: function(component, event, helper){
        var target = event.getSource();  
        var FCAOrderCheck = target.get("v.value");
        var orderItemList = component.get("v.orderItemList");
        if(FCAOrderCheck){
            component.set("v.FCAOrderCheck",true);//disableExpress  disableFCA
            component.set("v.ExpressOrderCheck",false);
            component.set("v.disableExpress",true);
            /*if(component.get('v.sfdcOrderNo')!=null){
                component.set("v.disableOnExpress",true);
            }*/
            component.set("v.newSalesOrder.Order_FCA_Italy__c",FCAOrderCheck);
            console.log(FCAOrderCheck);
        }else{
            component.set("v.FCAOrderCheck",false);
            if(orderItemList.length==0){
                component.set("v.disableExpress",false);
                component.set("v.disableOnExpress",false);
            };
            component.set("v.newSalesOrder.Order_FCA_Italy__c",false); 
        }
    },
    
    handleExpressChange: function(component, event, helper){
        
        if(component.get("v.isChildOrderType")){
            console.log('child Order type');
            /*var target = event.getSource();  
            var ExpressCheck = target.get("v.value");
            if(ExpressCheck){
                helper.resetSalesOrderParentItems(component, event, helper);
            }*/
            var target = event.getSource();  
            var ExpressCheck = target.get("v.value");
            if(ExpressCheck){
                component.set("v.ExpressOrderCheck",true);
                component.set("v.FCAOrderCheck",false);
                component.set("v.disableFCA",true);
                component.set("v.newSalesOrder.Is_Express_Delivery_Italy__c",ExpressCheck);
            }else {
                console.log('ExpressCheck is unchecked :'+ExpressCheck);
                component.set("v.ExpressOrderCheck",false);
                component.set("v.disableFCA",false);
                component.set("v.newSalesOrder.Is_Express_Delivery_Italy__c",false); 
            }
        }else{
            helper.resetSingleOrderItem(component);
            helper.showWarningToast(component, event, 'Please Select Product');
            //Patch Added
            // helper.updateOnExpressChangeTC(component,event,helper);
            //Patch End
            var target = event.getSource();  
            var ExpressCheck = target.get("v.value");
            //var ExpressCheck =component.find('expressOrder').get('v.value');
            //console.log('ExpressCheck--'+ExpressCheck);
            console.log('sfdcOrderNo :'+component.get('v.sfdcOrderNo'));
            if(component.get('v.sfdcOrderNo')!=null){
                component.set("v.disableOnExpress",true);
            }
            if(ExpressCheck){
                component.set("v.ExpressOrderCheck",true);
                component.set("v.FCAOrderCheck",false);
                component.set("v.disableFCA",true);
                console.log('sfdcOrderNo :'+component.get('v.sfdcOrderNo'));
                //if(component.get('v.sfdcOrderNo')!=null){
                component.set("v.disableOnExpress",true);
                //}
                component.set("v.newSalesOrder.Is_Express_Delivery_Italy__c",ExpressCheck);
            }else {
                component.set("v.ExpressOrderCheck",false);
                component.set("v.disableFCA",false);
                if(component.get('v.sfdcOrderNo')==undefined){
                    component.set("v.disableOnExpress",false);
                }
                component.set("v.newSalesOrder.Is_Express_Delivery_Italy__c",false); 
            }
        }
        
    },
    
    
    handleFCABeforeSave : function(component, event, helper) {
        var FCAOrderCheck = component.get("v.FCAOrderCheck");
        if(FCAOrderCheck){
            component.set("v.newSalesOrder.Is_Order_FCA_Italy__c",false);
        }
        helper.createSalesOrder(component, event, "Submitted");
    },
    
    /* validateQtylength  : function(component, event, helper) {
       var target = event.getSource();  
        var qty = target.get("v.value");
        console.log('length'+qty);
        if(qty >99999999)
        {
            console.log('error in length');
           // component.set('v.value', parseFloat(qty.substring(0, 2)));
             component.set('v.value',0);
           //  console.log('value'+ target.get("v.value"));
        }
    },*/
    
    //Logic to restrict ',' and '.'
    validateQty: function(component, event, helper){
        var target = event.getSource();  
        var qty = target.get("v.value");
        if(qty){
            var qtyString = qty;
            if(qtyString.includes('.')){
                qtyString = qtyString.replace('.', ''); //Replace '.' sign
                target.set("v.value",qtyString);
            }else if(qtyString.includes(',')){
                qtyString = parseFloat(qtyString.replace(',', ''));
                target.set("v.value",qtyString);
            }
        }
    },
    
    //Logic to restrict ',' and '.'
    validateDisc: function(component, event, helper){
        var target = event.getSource();  
        var disc = target.get("v.value");
        var errorMessage = '';
        var flag = false;
        console.log('disc'+disc);
        if(disc){
            var discString = disc.toString();
            if(discString.includes('-')){
                discString = parseFloat(discString.replace("-", "")); //Replace negative sign
                target.set("v.value",discString);
            }else if(disc>100){
                flag = true;
                target.set("v.value",0);
            }else if(disc<0){
                flag = true;
                target.set("v.value",0);
            }
            if(flag){
                errorMessage= "Please enter valid percentage [0-100]";
                target.set("v.errors", [{message:errorMessage}]);
                $A.util.addClass(target, "error");
                component.set("v.newSalesOrder.Editable_Payment_Term_Discount__c",0);
            }else {
                console.log('disc'+disc);
                target.set("v.errors", null); 
                $A.util.removeClass(target, "error");
                helper.handleDiscountChange(component,event,disc);
            }
        }
    },
    
    
    NoMultiplyOf: function(component, event, helper){
        var qty = component.find("itemqty1");
        var errorMessage = '';
        var warningMessage = '';
        if(qty){
            qty.set("v.value",0);
            helper.updateRowCalculations1(component, event, helper); 
            helper.toggleMultipleOfDialog(component);
        }
    },
    
    YesMultiplyOf: function(component, event, helper){
        var qty = component.find("itemqty1");
        if(qty){
            helper.updateRowCalculations1(component, event, helper); 
            helper.toggleMultipleOfDialog(component);
        }
    },
    
    // Use for cart dialog
    NoMultiplyOf1: function(component, event, helper){
        
        var qtySOLI = component.get("v.qtySOLI");
        var orderItemList = component.get("v.orderItemList");
        var qtIndex=component.get('v.qtyIndexSOLI');//orderItemList[component.get('v.qtyIndexSOLI')];
        var qty = component.find("itemqty");
        //console.log('qty :'+qty);
        var errorMessage = '';
        var warningMessage = '';
        if(qtySOLI){
            orderItemList[qtIndex].qty=0;
            helper.updateRowCalculations(component, event, helper);
            //helper.updateQty(component, event, helper,rowIndex);
            helper.toggleMultipleOfCartDialog(component);
        }else {
            qty.set("v.value",0);
            helper.updateRowCalculations(component, event, helper);
            //helper.updateQty(component, event, helper,rowIndex);
            helper.toggleMultipleOfCartDialog(component);
        }
    },
    // Use for cart dialog
    YesMultiplyOf1: function(component, event, helper){
        var qty = component.find("itemqty");
        if(qty){
            helper.updateRowCalculations(component, event, helper);
            //helper.updateQty(component, event, helper,rowIndex);
            helper.toggleMultipleOfCartDialog(component);
        }
    },
    //Validation on Quantity Input
    restrictQuantity1: function(component, event, helper){
        var target = event.getSource();  
        var qty = target.get("v.value");
        console.log('qty :'+qty);
        var errorMessage = '';
        var warningMessage = '';
        if(qty){
            var qtyString = qty.toString(); //Convert to string
            if(qtyString!=''){
                qty = parseFloat(qtyString.replace("-", "")); //Replace negative sign
                target.set("v.value",qty);
                var multipleOf = target.get("v.placeholder");
                var flag = false;
                var modValue = (qty%multipleOf).toFixed(2);
                console.log('qty :'+qty);
                console.log('multipleOf :'+parseFloat(multipleOf).toFixed(2));
                console.log('modValue :'+(qty%multipleOf).toFixed(2));
                
                /*var qty2=qty.toFixed(2);
                console.log('qty :'+qty2);
                var mod1=(qty2%multipleOf).toFixed(2);
                console.log('mod1 :'+mod1);
                var mod2=(mod1+9) - ((mod1+9)%10);
                console.log('mod2 :'+mod2);*/
                
                /*if(multipleOf && modValue != 0){
                    flag = true;
                    warningMessage= $A.get("$Label.c.Qty_should_be_in_multiple_of")+" "+multipleOf;
                    helper.showWarningToast(component, event, warningMessage);
                    target.set("v.value",0);
                    helper.updateRowCalculations1(component, event, helper); 
                }*/
                if(multipleOf && modValue!=0){
                    if(modValue != multipleOf){
                        flag = true;
                        warningMessage= $A.get("$Label.c.Qty_should_be_in_multiple_of")+" "+multipleOf+". "+$A.get("$Label.c.Do_you_want_to_proceed_with_the_entered_quantity");
                        component.set('v.MultipleOfDialogMessage',warningMessage);
                        helper.toggleMultipleOfDialog(component);
                    }
                }
                
                target.set("v.errors", null); 
                $A.util.removeClass(target, "error");
                helper.updateRowCalculations1(component, event, helper); 
                
            }
        }else{
            errorMessage= $A.get("$Label.c.Please_enter_Quantity");
            target.set("v.errors", [{message:errorMessage}]);
            $A.util.addClass(target, "error");
        }
        
    },
    
    //Replace Negative Sign from Quantity Input
    restrictQuantity: function(component, event, helper){
        var target = event.getSource();  
        var qty = target.get("v.value");
        var rowIndex = target.get("v.labelClass");
        //Updated by Varun Shrivastava start : SCTASK0360650
        var orderItemList = component.get("v.orderItemList");
        if(component.get("v.isChildOrderType")){
            orderItemList = component.get("v.orderItemListTest");
        }
        //Updated by Varun Shrivastava start : End
        var flag = false;
        var errorMessage = '';
        var warningMessage = '';
        console.log('qty'+qty);
        component.set('v.qtySOLI',qty);
        component.set('v.qtyIndexSOLI',rowIndex);
        var sumQty=0;
        for (var idx = 0; idx < orderItemList.length; idx++) {
            sumQty = sumQty + orderItemList[idx].qty;
        }
        if(sumQty==0){
            component.set("v.ExpressOrderCheck",false);
            component.set("v.disableExpress",false);
            component.set("v.FCAOrderCheck",false);
            component.set("v.disableFCA",false)
        }
        if(qty){
            flag = false;
            var qtyString = qty.toString(); //Convert to string
            
            if(qtyString!=''){
                qty = parseFloat(qtyString.replace("-", "")); //Replace negative sign
                target.set("v.value",qty);
                var multipleOf = target.get("v.placeholder");
                var flag = false;
                var modValue = (qty%multipleOf).toFixed(2);
                /*if(multipleOf && modValue != 0){
                    flag = true;
                    warningMessage= $A.get("$Label.c.Qty_should_be_in_multiple_of")+" "+multipleOf;
                    helper.showWarningToast(component, event, warningMessage); 
                    target.set("v.value",0);
                    helper.updateRowCalculations(component, event, helper);
                    helper.updateQty(component, event, helper,rowIndex); 
                    
                }*/
                
                var balancQTY=null;
                console.log('orderItemList[rowIndex].balanceQty :'+orderItemList[rowIndex].balanceQty);
                console.log('orderItemList[rowIndex].balanceQtyStr :'+orderItemList[rowIndex].balanceQtyStr);
                
                if(component.get("v.orderType2")!=undefined){
                    
                    /*if(component.get("v.orderType2")=='Parent Order'){
                        if(component.get("v.isChildOrderType")==true && (orderItemList[rowIndex].balanceQtyStr=='0.00' || parseFloat(orderItemList[rowIndex].balanceQtyStr)>0 )){
                            console.log(' Balance is 0');
                            balancQTY=0;
                            balancQTY=orderItemList[rowIndex].balanceQty;
                        }else{
                            console.log(' Balance is blank');
                        }
                    }else if(component.get("v.orderType2")=='Child Order'){
                        balancQTY=0;
                        balancQTY=orderItemList[rowIndex].balanceQty;
                        
                    }*/
                }
                
                
                
                console.log('balancQTY :'+balancQTY);
                if(component.get("v.isChildOrderType")){
                    component.set("v.disableExpress",true);
                }
                console.log('orderType2 : '+component.get("v.orderType2"));
                if(balancQTY!=null){ //child order
                    if(balancQTY>0){
                        if(qty > balancQTY) {
                            errorMessage= $A.get("$Label.c.Qty_should_be_less_than_balance_qty");//"Qty should be less than balance qty";
                            target.set("v.errors", [{message:errorMessage}]);
                            target.set("v.value",0);
                            $A.util.addClass(target, "error"); 
                            helper.updateQty(component, event, helper,rowIndex); 
                            helper.updateRowCalculations(component, event, helper);
                        }else{
                            if(multipleOf && modValue!=0){
                                if(modValue != multipleOf){
                                    flag = true;
                                    warningMessage= $A.get("$Label.c.Qty_should_be_in_multiple_of")+" "+multipleOf+". "+$A.get("$Label.c.Do_you_want_to_proceed_with_the_entered_quantity");
                                    component.set('v.MultipleOfDialogMessage',warningMessage);
                                    helper.toggleMultipleOfCartDialog(component);
                                }
                            }
                            target.set("v.errors", null); 
                            $A.util.removeClass(target, "error");
                            helper.updateQty(component, event, helper,rowIndex); 
                            helper.updateRowCalculations(component, event, helper);
                        }
                    }else{
                        errorMessage= $A.get("$Label.c.No_Stock_available_Balance_Qty_is_empty");//"No Stock available. Balance Qty is empty";
                        target.set("v.errors", [{message:errorMessage}]);
                        target.set("v.value",0);
                        $A.util.addClass(target, "error");
                    }
                }else{
                    if(multipleOf && modValue!=0){
                        if(modValue != multipleOf){
                            flag = true;
                            warningMessage= $A.get("$Label.c.Qty_should_be_in_multiple_of")+" "+multipleOf+". "+$A.get("$Label.c.Do_you_want_to_proceed_with_the_entered_quantity");
                            component.set('v.MultipleOfDialogMessage',warningMessage);
                            helper.toggleMultipleOfCartDialog(component);
                        }
                    }
                    target.set("v.errors", null); 
                    $A.util.removeClass(target, "error");
                    helper.updateQty(component, event, helper,rowIndex); 
                    helper.updateRowCalculations(component, event, helper);
                }
            }
        }else{
            errorMessage= $A.get("$Label.c.Please_enter_Quantity");
            target.set("v.errors", [{message:errorMessage}]);
            $A.util.addClass(target, "error");
            target.set("v.value",0);
            helper.updateQty(component, event, helper,rowIndex); 
            helper.updateRowCalculations(component, event, helper);
        }
        
        //Sayan: 12/07/2021: Added for RITM0230668
        if( component.get("v.specialRateAvailable") ){
            helper.updateRowCalculations2(component, event, helper,orderItemList[rowIndex].productId,orderItemList[rowIndex].palletSize,qty,false);
        }
        //Sayan: 12/07/2021: Added for RITM0230668
    },
    
    // Logic to update current row with calculations
    updateTableRow : function(component, event, helper) {
        var target = event.getSource();  
        var unitValue = target.get("v.value");
        var netInvPrice = target.get("v.requiredIndicatorClass");
        var errorMessage = '';
        
        if(unitValue){
            if(netInvPrice < unitValue){
                target.set("v.errors", [{message:$A.get("$Label.c.Please_enter_valid_Estimated_Final_Price")}]);
                target.set("v.value",0);
                $A.util.addClass(target, "error");  
            } 
            else{
                target.set("v.errors", null); 
                $A.util.removeClass(target, "error");
                helper.updateRowCalculations(component, event, helper);
            }
        }else{
            errorMessage= $A.get("$Label.c.Please_Enter_Estimated_Final_Price");
            target.set("v.errors", [{message:errorMessage}]);
            $A.util.addClass(target, "error");
        }
    },
    
    
    // Logic to update "Add Product" row with calculations
    updateTableRow1 : function(component, event, helper) {
        var target = event.getSource();  
        var unitValue = target.get("v.value");
        var netInvPrice = target.get("v.requiredIndicatorClass");
        var errorMessage = '';
        
        if(unitValue){
            if(netInvPrice < unitValue){
                target.set("v.errors", [{message:$A.get("$Label.c.Please_enter_valid_Estimated_Final_Price")}]);
                target.set("v.value",'');
                $A.util.addClass(target, "error");  
            } 
            else{
                target.set("v.errors", null); 
                $A.util.removeClass(target, "error");
                component.set("v.SingleOrderItem.averageFinalP",unitValue);
            }
        }else{
            errorMessage= $A.get("$Label.c.Please_Enter_Estimated_Final_Price");
            target.set("v.errors", [{message:errorMessage}]);
            $A.util.addClass(target, "error");
        }
    },
    
    
    // Logic to handle shipping changs 
    handleShipLocChange : function(component, event){
        var shippingLoc = component.get("v.shippingLoc");
        if(shippingLoc!='None'){
            var inputCmp = component.find("shippListOptions");
            inputCmp.set("v.errors", null);
            $A.util.removeClass(inputCmp, "error");
            var ShippingLocMap = component.get("v.ShippingLocMap");
            var slObj = ShippingLocMap[shippingLoc];
            //console.log(slObj);
            if(slObj!=undefined){
                
                //RITM0238910
                var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
                if( slObj.Expiry_Date__c < today ){
                    /*var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type": "Error",
                        "message": "The record has been updated successfully."
                    });
                    toastEvent.fire();*/
                    alert("Attenzione : il patentino è scaduto , si prega di richiedere un nuovo patentino al più presto !");
                }
                //RITM0238910
                
                component.set("v.newSalesOrder.Ship_To_Party__c", slObj.Id);
                console.log('slObj.OwnerId'+slObj.OwnerId);
                console.log('slObj'+JSON.stringify(slObj));
                component.set("v.newSalesOrder.OwnerId",slObj.OwnerId);
                component.set("v.selItem", slObj);
                component.set("v.newSalesOrder.Shipping_Notes__c",slObj.Shipping_Notes__c); 
                // console.log(component.get("v.selItem"));
            }
        }else{
            component.set("v.selItem", '');
            component.set("v.newSalesOrder.Ship_To_Party__c", '');
            component.set("v.newSalesOrder.OwnerId",null);
            component.set("v.newSalesOrder.Shipping_Notes__c",''); 
        }
    }, 
    
    // Logic to handle payment term changs 
    handlePaymentChange : function(component, event){
        var paymentTerm = component.get("v.paymentTerm");
        var IsPaymentTermAvailable = component.get("v.emptyPaymetTerm");
        if(IsPaymentTermAvailable){
            if(paymentTerm!='None'){
                var inputCmp = component.find("paymentListOptions");
                inputCmp.set("v.errors", null);
                $A.util.removeClass(inputCmp, "error");
                var PaymentTermMap = component.get("v.PaymentTermMap");
                var ptObjId = PaymentTermMap[paymentTerm].Id;
                var ptObjDic = PaymentTermMap[paymentTerm].Discount_Italy__c;
                console.log(ptObjId);
                if(ptObjId!=undefined){
                    component.set("v.newSalesOrder.Payment_Term__c", ptObjId);
                    component.set("v.paymentDisc",ptObjDic);
                    if(ptObjDic!=null && ptObjDic!=''){
                        component.set("v.newSalesOrder.Payment_Term_Discount_Italy__c",ptObjDic);
                        component.set("v.newSalesOrder.Editable_Payment_Term_Discount__c",ptObjDic);
                    }else{
                        component.set("v.newSalesOrder.Payment_Term_Discount_Italy__c",0);
                        component.set("v.newSalesOrder.Editable_Payment_Term_Discount__c",0);
                    }
                }
            }else{
                component.set("v.newSalesOrder.Payment_Term__c", '');
                component.set("v.paymentDisc",0);
                component.set("v.newSalesOrder.Payment_Term_Discount_Italy__c",0);
                component.set("v.newSalesOrder.Editable_Payment_Term_Discount__c",0);
            }
        }else{
            if(paymentTerm!='None'){
                var inputCmp = component.find("paymentListOptions");
                inputCmp.set("v.errors", null);
                $A.util.removeClass(inputCmp, "error");
                var PaymentTermMap = component.get("v.PaymentTermMap");
                console.log(PaymentTermMap);
                var ptObjId = PaymentTermMap[paymentTerm].Payment_Term_Italy__c;
                console.log(ptObjId);
                var paymentDisc = PaymentTermMap[paymentTerm].Payterm_Term_Discount_Italy__c;
                
                console.log(ptObjId);
                if(ptObjId!=undefined){
                    component.set("v.newSalesOrder.Payment_Term__c", ptObjId);
                    component.set("v.paymentDisc",paymentDisc);
                    if(paymentDisc!=null && paymentDisc!=''){
                        component.set("v.newSalesOrder.Payment_Term_Discount_Italy__c",paymentDisc);
                        component.set("v.newSalesOrder.Editable_Payment_Term_Discount__c",paymentDisc);
                    }else{
                        component.set("v.newSalesOrder.Payment_Term_Discount_Italy__c",0);
                        component.set("v.newSalesOrder.Editable_Payment_Term_Discount__c",0);
                    }
                }
            }else{
                component.set("v.newSalesOrder.Payment_Term__c", '');
                component.set("v.paymentDisc",0);
                component.set("v.newSalesOrder.Payment_Term_Discount_Italy__c",0);
                component.set("v.newSalesOrder.Editable_Payment_Term_Discount__c",0);
            }
        }
    }, 
    
    handleDiscountChange : function(component, event){
        var target = event.getSource();  
        var Pdiscount = target.get("v.value");
        component.set("v.newSalesOrder.Editable_Payment_Term_Discount__c",Pdiscount);
    },
    
    
    // Logic to show Product Selection Modal        
    openPriceDeatilsPopUp : function(component, event, helper) {
        var target = event.getSource();  
        var rowIndexValue = target.get("v.value");
        if(component.get("v.priceDetailList").length < 1){
            helper.fetchSKUData(component, event);//Deeksha
        }
        component.set("v.modalHeader", $A.get("$Label.c.Products"));
        component.set("v.rowIndex",rowIndexValue);
        var pricedata = component.find("pricedata1");
        $A.util.removeClass(pricedata, 'slds-hide');
        helper.toggle(component);
        
    },  
    
    // Logic to show approval/rejection modal
    openDialog : function(component, event, helper) {
        var selected = event.getSource().get("v.label");
        var status = "";
        
        if(selected==$A.get("$Label.c.Approve")){
            component.set("v.isApproval",true);
            status = "Draft";	
        }
        else{
            component.set("v.isApproval",false);
            status = "Draft";	
        }
        helper.toggleDialog(component);
    },
    
    
    addSkuRow : function(component, event, helper){
        helper.createOrder(component, event, helper);
    },
    
    
    //method to delete all Order Line Item Data From Cart
    deleteAllItem : function(component, event, helper) {
        var orderId = component.get("v.orderObjId");
        var action = component.get("c.deleteOrderItems");
        var soId = component.get("v.sOId");
        var toastMsg ='';
        var errorMessage ='';
        
        if(orderId!=null && orderId!='' && orderId!= undefined){
            action.setParams({
                orderId : orderId
            });
            
            component.set("v.showSpinner", true); 
            action.setCallback(this, function(a) {
                component.set("v.showSpinner", false);     
                var state = a.getState();
                if(state == "SUCCESS") {
                    var orderItemList = component.get("v.orderItemList");
                    errorMessage = a.getReturnValue().errorMessage;
                    if(errorMessage!=''&& errorMessage!=null) {
                        toastMsg = errorMessage;
                        this.showErrorToast(component, event, toastMsg);
                    }else{
                        orderItemList.splice(0, orderItemList.length);
                        component.set("v.productTypesList", null);
                        component.set("v.productTypesList", component.get("v.productTypesListCopy"));   
                        component.set("v.orderItemList", orderItemList);
                        toastMsg = $A.get("$Label.c.Cart_Cleared_Successfully");
                        helper.showToast(component, event, toastMsg);
                        component.set("v.grossNetPrice",0);
                        helper.resetSingleOrderItem(component,helper);
                        component.set("v.disableFCA",false);
                        component.set("v.disableExpress",false);
                        component.set("v.disableOnExpress",false);
                        window.location.reload();
                    }
                }
                else{
                    var toastMsg = $A.get("$Label.c.Error_While_Deleting_Cart_Please_Contact_System_Administrator");
                    this.showErrorToast(component, event, toastMsg);                      
                }
            });
            $A.enqueueAction(action);
        }else if(soId!=null && soId!=undefined){
            var orderItemList = component.get("v.orderItemList");
            orderItemList.splice(0, orderItemList.length);
            component.set("v.productTypesList", null);
            component.set("v.productTypesList", component.get("v.productTypesListCopy"));   
            component.set("v.orderItemList", orderItemList);
            toastMsg = $A.get("$Label.c.Item_Cleared");
            helper.showToast(component, event, toastMsg);
            helper.resetSingleOrderItem(component);
            
        }
    },
    
    
    // Logic to remove Order Line Item
    removeTableRow : function(component, event, helper) {
        var target = event.getSource();  
        var index = target.get("v.value");
        var items = component.get("v.orderItemList");   
        var soId = component.get("v.sOId");
        
        //Sayan: 12/07/2021: Added for RITM0230668
        if( component.get("v.specialRateAvailable") ){
            helper.updateRowCalculations2(component, event, helper,items[index].productId,items[index].palletSize,items[index].qty,true);
        }
        //Sayan: 12/07/2021: Added for RITM0230668
        
        console.log('index'+index);
        var orderId = component.get("v.orderObjId");
        var itemsLength=items.length;
        //logic to delete row associated with Parent Item
        if( index != items.length - 1 && items[index].typeOfProduct=='Vendita' && items[index].productId!=null && items[index].productId!=''){
            for (var idx1=index+1; idx1<=items.length; idx1) {
                console.log('inside loop'+idx1);
                if(items[idx1]!=undefined){
                    console.log('inside loop2'+items[idx1]);
                    if(items[idx1].typeOfProduct=='Omaggio'){
                        if(soId==null || soId==undefined){
                            var oliId =items[idx1].oliId;
                            helper.deleteOrderItem(component, event, oliId,orderId,itemsLength,items);
                        }
                        component.set("v.productTypesList", null);
                        items.splice(idx1, 1);  
                        component.set("v.productTypesList", component.get("v.productTypesListCopy"));     
                    }else{break;}
                }else{break;}
            }
        }
        //logic end
        if(index == items.length - 1){
            console.log('if index'+index);
            if(soId==null || soId==undefined){
                var oliId =items[index].oliId;
                if(index==0){
                    helper.deleteOrderItem(component, event, oliId,orderId,0,index); 
                    window.location.reload();
                }else{
                    helper.deleteOrderItem(component, event, oliId,'','',index);
                }
                
            }
            component.set("v.productTypesList", null);
            items.splice(index, 1);
            component.set("v.productTypesList", component.get("v.productTypesListCopy"));     
        }
        else{
            if(soId==null || soId==undefined){
                var oliId =items[index].oliId; 
                helper.deleteOrderItem(component, event, oliId,orderId,itemsLength,index);
            }
            console.log('else index'+index);
            items.splice(index, 1);
        }
        //console.log(JSON.stringify(items));
        component.set("v.orderItemList", items);
        if( !component.get("v.specialRateAvailable") ){
            helper.updateRowCalculations(component, event, helper);
        }
        //Patch Added To Enable expressdelivery checkbox if cart size become 0
        var orderItemList1 = component.get("v.orderItemList");
        if(orderItemList1.length <= 0){
            component.set("v.disableExpress",false);
            if(component.get('v.sfdcOrderNo')!=undefined){
                component.set("v.disableOnExpress",true);
            }else{
                component.set("v.disableOnExpress",false);
            }
        }
        //Patch End
    },
    
    
    // Save Comments while Approving / Rejecting Order
    saveComment : function(component,event,helper) {
        var isApproved = false;
        var msg = '';
        if(component.get("v.isApproval")){
            status = "Approved";
            isApproved = true;
            msg = $A.get("$Label.c.Are_you_sure_you_want_to_Approve_the_Sales_Order");
        }
        else{
            status = "Rejected";
            isApproved = false;
            msg = $A.get("$Label.c.Are_you_sure_you_want_to_Reject_the_Sales_Order");
        }        
        if(confirm(msg)){    
            var action = component.get("c.processApproval");
            action.setParams({
                isApproved: isApproved,
                recordId: component.get("v.sOId"),
                comments: component.get("v.comments")
            });
            // show spinner to true on click of a button / onload
            component.set("v.showSpinner", true); 
            
            action.setCallback(this, function(a) {
                // on call back make it false ,spinner stops after data is retrieved
                component.set("v.showSpinner", false); 
                var state = a.getState();
                console.log('state'+state);
                if (state == "SUCCESS") {
                    var returnValue = JSON.stringify(a.getReturnValue());
                    component.set("v.approvalList",a.getReturnValue());
                    
                    var enableApproval = component.get("v.approvalList.enableApproval");
                    component.set("v.showApproveReject", enableApproval);
                    //  helper.gotoURL(component, component.get("v.sOId"));
                    helper.redirectToListView(component, component.get("v.sOId"));
                }	
            });
            helper.toggleDialog(component);
            $A.enqueueAction(action);
        }
    }
    
})