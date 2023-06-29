({
    // Init method to initalize default values in form on component load. 
    doInit: function(component, event, helper) {
        //Populate all picklists
        helper.redirectBack(component,event);
        helper.getOrderFields(component);
    }, 
    
    //Logic to open Sign/Unsign Dialog
    openSignDialog: function(component,event,helper){
        helper.toggleSignDialog(component);
    },
    
    //Logic to close Sign/Unsign Dialog
    closeSignDialog: function(component,event,helper){
        helper.toggleSignDialog(component);
    },  
    
    //Method to validate Purchase Order No. has alpha numeric characters only.
    validatePO: function(component,event,helper){
        var target = event.getSource();  
        var inp = target.get("v.value");
        var letterNumber = /^[0-9a-zA-Z]+$/;
        if((inp.match(letterNumber))){
            target.set("v.errors", null); 
            $A.util.removeClass(target, "error");
        }
        else{
            var errorMessage= $A.get("$Label.c.Purchase_Order_No_is_required_and_can_contain_only_characters_and_numbers");
            var setValue = ''; //inp.replace(/\W+/g, " ");
            target.set("v.errors", [{message:errorMessage}]);
            target.set("v.value",setValue);
            
            $A.util.addClass(target, "error");
        }
    },
    
    //Method to validate Invoice Message has alpha numeric characters only.
    validateInvoice: function(component,event,helper){
        var target = event.getSource();  
        var inp = target.get("v.value");
        if(inp){
            var letterNumber = /^[a-z\d\-_;\s]+$/i;
            if((inp.match(letterNumber))){
                target.set("v.errors", null); 
                $A.util.removeClass(target, "error");
                component.set("v.isValidInvoice",true);
            }
            else{
                var errorMessage= $A.get("$Label.c.Invoice_Message_can_contain_only_characters_and_numbers");
                //var setValue = ''; //inp.replace(/\W+/g, " ");
                target.set("v.errors", [{message:errorMessage}]);
                //target.set("v.value",setValue);
                $A.util.addClass(target, "error");
                component.set("v.isValidInvoice",false);
            }
        }
    },  
    
    // 1. Logic to Cancel Order (Only Available for Brazil System Administrator, Sales Person & Customer Service User)
    // 2. Sales Person allowed to cancel records owned by him/her.
    // 3. Brazil System Admin/Customer Service User can cancel approved orders.
    cancelOrder: function(component,event,helper){
        var remarks = component.find("remarks");
        //console.log('remarks: '+remarks);
        
        if(!remarks.get("v.value")){
            component.find("remarks").set("v.errors",[{message: $A.get("$Label.c.Remarks_required_for_a_cancelled_Sales_Order")}]);
        }
        else{
            component.find("remarks").set("v.errors",null);
            var profileName = component.get("v.orderFields.userObj.Profile.Name");
            var orderSubStatus = '';
            
            if(profileName == 'Brazil System Administrator' || profileName == 'System Administrator'){
                orderSubStatus = 'Cancelled by Admin';
            }
            else if(profileName == 'Brazil Customer Service User'){
                orderSubStatus = 'Cancelled by Customer Service Executive';
            }
            else{
                orderSubStatus = 'Cancelled by Sales Person';
            }
            
            component.set("v.newSalesOrder.Order_Status__c", "Cancelled");
            component.set("v.newSalesOrder.OrderSubStatus__c", orderSubStatus);

            if(confirm( $A.get("$Label.c.Are_you_sure_you_want_to_Cancel_the_Sales_Order") )){
                var action = component.get("c.signOrder");
                action.setParams({ 
                    "soObj": component.get("v.newSalesOrder")
                });
                
                action.setCallback(this, function(a) {
                    var state = a.getState();
                    var toastMsg = '';
                    if (state == "SUCCESS") {
						component.set("v.showCancel", false);
                        toastMsg = $A.get("$Label.c.Sales_Order_Cancelled");
                        helper.showToast(component, event, toastMsg); 
                        
                        var profileName = component.get("v.orderFields.userObj.Profile.Name");
                        var fullUrl = '';
                        var defType = 'cancelled';
                        if(profileName=='Brazil Customer Service User' || profileName=='Brazil System Administrator'){
                            fullUrl = "/apex/BrazilEnhancedList2?defType="+defType;
                            helper.gotoURL(component,fullUrl);
                        }  
                        else if(profileName=='Brazil Sales Person'){
                            fullUrl = "/apex/BrazilEnhancedListForSP?defType="+defType;
                            helper.gotoURL(component,fullUrl);
                        }                          
                    }
                    else{
                        toastMsg = 'Sales Order Cancellation Failed';
                        helper.showErrorToast(component, event, toastMsg);   
                    }             
                    
                });
                $A.enqueueAction(action);  
            }            
        }        
    },  
    
    //Logic to delete Sales Order (Only Draft & Simulated Orders can be deleted by Record Owner)
    deleteRecord: function(component,event,helper){
        
        // show a confirm
        if(confirm( $A.get("$Label.c.Are_you_sure_you_want_to_delete_this_Order") )){
            // perform custom logic here    
            
            var action = component.get("c.deleteSalesOrder");
            action.setParams({ 
                "recordId": component.get("v.recordId")
            });
            
            action.setCallback(this, function(a) {
                var state = a.getState();
                var toastMsg = '';
                if (state == "SUCCESS") {
                    var flag = a.getReturnValue();
                    if(flag){
                        toastMsg = $A.get("$Label.c.Order_Deleted_Successfully");
                        helper.showToast(component, event, toastMsg);
                        
                        var profileName = component.get("v.orderFields.userObj.Profile.Name");
                        if(profileName=='Brazil Sales Person'){
                            var fullUrl = "/apex/BrazilEnhancedListForSP?defType=pending";
                            helper.gotoURL(component,fullUrl);
                        }                        
                    }
                    else{
                        toastMsg = $A.get("$Label.c.Delete_denied_Please_contact_System_Administrator");
                        helper.showErrorToast(component, event, toastMsg);   
                    }
                }
                else{
                    toastMsg = $A.get("$Label.c.Unable_to_delete_Order_Please_contact_System_Administrator");
                    helper.showErrorToast(component, event, toastMsg);   
                }             
            });
            $A.enqueueAction(action);  
        }
    },
    
    // 1. Method called to Sign/Unsign Order.
    // 2. Only Available for Brazil System Administrator.
    signedOrder: function(component,event,helper){
        helper.toggleSignDialog(component);

        var signed = component.get("v.newSalesOrder.Signed__c");
        
        if(signed){
            component.set("v.newSalesOrder.Signed__c",false);
        }
        else{
            component.set("v.newSalesOrder.Signed__c",true);
        }        
        
        var action = component.get("c.signOrder");
        action.setParams({ 
            "soObj": component.get("v.newSalesOrder")
        });
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            var toastMsg = '';
            if (state == "SUCCESS") {
                var signed = component.get("v.newSalesOrder.Signed__c");
                
                if(signed){
                    component.set("v.showSign",false);
                    component.set("v.showUnsign",true);
                    component.set("v.signMessage", $A.get("$Label.c.Are_you_sure_you_want_to_unsign"));
                }
                else{
                    component.set("v.showSign",true);
                    component.set("v.showUnsign",false);
                    component.set("v.signMessage", $A.get("$Label.c.Are_you_sure_you_want_to_sign"));
                }
            }
            else{
                toastMsg = $A.get("$Label.c.Signing_Failed");
                helper.showErrorToast(component, event, toastMsg);   
            }             
        });
        $A.enqueueAction(action);  
    }, 
    
    //Logic to Simulate existing Order record (Not available to System Admin/Sales Person/Customer Service User)
    simulateOrder: function(component,event,helper){
        var newSO = component.get("v.newSalesOrder");
      //  console.log('newso'+JSON.stringify(newSO));
        var orderItemList = component.get("v.orderItemList");
      //  console.log('orderItemList'+JSON.stringify(orderItemList));
        var action = component.get("c.simulateSalesOrder");
        action.setParams({ 
            "soObj": newSO,
            "salesOrderItemString": JSON.stringify(orderItemList)
        });
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            var toastMsg = '';
            if (state == "SUCCESS") {
                toastMsg = $A.get("$Label.c.Sales_Order_simulated_successfully");
                console.log('orderlineitem-->'+JSON.stringify(a.getReturnValue().soiList));
                component.set("v.newSalesOrder",a.getReturnValue().soObj);
                component.set("v.orderItemList",a.getReturnValue().soiList);
                component.set("v.disableThis", false);
              //  component.set("v.disableSelect", false);
                component.set("v.disablePaymentMethod", true);
                component.set("v.disablePriceCurrency", true);
                component.set("v.disableOrderType_Dates_SOM_Account", true);
                component.set("v.disableEdit", true);
                
                component.set("v.isSimulated", true);
                var staticLabel = $A.get("$Label.c.Create_Simulation_Order");
                component.set("v.headerMsg", staticLabel); 
                component.set("v.showSeller", false);
                component.set("v.showSimulate", false);
                component.set("v.showOnReLoad", false);
                component.set("v.showApproveReject", false);
                component.set("v.showSaveDraft", false); 
                component.set("v.showSubmitEdit", true); 
                component.set("v.showReset", true); 
                
                helper.showToast(component, event, toastMsg);
            }
            else{
                toastMsg = $A.get("$Label.c.Simulation_failed");
                helper.showErrorToast(component, event, toastMsg);   
            }
        });
        $A.enqueueAction(action);
    },
    
    //1. Restrict Item level Quantity & Logic to enter quantity in Multiple of
    //2. Replace Negative Sign from Quantity Input
    //3. In case of 'Ordem Filha' type restrict Input Qty by checking against Balace Qty of selected SOM
    restrictQuantity: function(component, event, helper){
        var orderType = component.get("v.newSalesOrder.Type_of_Order__c");
        var target = event.getSource();  
        var qty = target.get("v.value");
		var setValue = null;
        
     	//console.log('qty: '+qty);
        if(!qty){
            setValue = component.get("v.oldValueQty");
            target.set("v.value", setValue);
        }
        
        if(qty){
            var qtyString = qty.toString(); //Convert to string
            
            if(qtyString!=''){
                qty = parseFloat(qtyString.replace("-", "")); //Replace negative sign
                target.set("v.value",qty);
                
                var multipleOf = target.get("v.placeholder");
                var errorMessage = '';
                var flag = false;
                //var setValue = null;
                setValue = component.get("v.oldValueQty");
                if(multipleOf && qty%multipleOf != 0){
                    flag = true;
                    errorMessage= $A.get("$Label.c.Qty_should_be_in_multiple_of")+" "+multipleOf;
                }
                else if(orderType == 'ORDEM FILHA'){
                    var inventory = target.get("v.labelClass");
                    
                    if(qty > inventory) {
                        flag = true;
                        //setValue = inventory;
                        errorMessage= $A.get("$Label.c.Qty_cannot_be_greater_than_SOM_Balance")+" "+inventory;
                        //console.log(errorMessage);
                    }
                }
                
                if(flag){
                    target.set("v.value", setValue);
                    target.set("v.errors", [{message:errorMessage}]);
                    $A.util.addClass(target, "error");
                }
                else{
                    target.set("v.errors", null); 
                    $A.util.removeClass(target, "error");
                    helper.updatePriceTable(component, event);
                    //added by ganesh Date:4/6/18
                    //Desc:to update table row based on qty
                    helper.updateRowCalculations(component, event);
                }
            }
        }
    },
    
    //1. Check if difference between Date of FAT and Maturity Date not more than 360 days.
    //2. Check input Date of FAT is always greater than today
    //Note: Commented Logic was used to restrict Date Of FAT against Holidays & Saturday/Sunday (i.e Weekly Offs)
    restrictHolidays: function(component, event, helper){
        var target = event.getSource();  
        var selectedDate = target.get("v.value");
    	var rowIndex = target.get("v.labelClass");
        var selectedPaymentTerm = component.get("v.paymentTerm");
        target.set("v.errors", null);   //INC-378280: Dat of Fat limit change from 360 to 365
        
        //var inputCmp = component.find("validFrom");
        //var value = inputCmp.get("v.value");
        
        //var inputCmp2 = component.find("validToDate");
        //var value2 = inputCmp2.get("v.value");
        
        if(selectedDate){
            var today = new Date();
            var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
            var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
            var yyyy = today.getFullYear();
            
            // Custom date format for ui:inputDate
            var currentDate = (yyyy + "-" + MM + "-" + dd);
            
            var x = new Date(selectedDate);
            var y = new Date(currentDate);
            
            var flag = true;
            
            //console.log('+x <= +y: '+(+x <= +y));
            //console.log('x: '+x);
            //console.log('y: '+y);
    
            var day = new Date(selectedDate).getUTCDay();
            
            var maturityDate = component.get("v.newSalesOrder.Maturity_Date__c");
            
            // is less than today?
            if (+x <= +y) {
                target.set("v.errors", [{message: $A.get("$Label.c.FAT_should_be_greater_than_today")}]);
                flag = false;
            } 
            /*else {
                target.set("v.errors", null);
            }*/
    
            //var target = event.getSource();  
            //var selectedDate = target.get("v.value");
    
            else if(!isNaN(day)){
                //Logic for Holidays
                var holidayList = component.get("v.holidayList");
                var val = holidayList.toString();
                var errorMessage = "";
                
                // Days in JS range from 0-6 where 0 is Sunday and 6 is Saturday   
                /*if(day == 0 || day == 6 ) {
                    //target.set('v.validity', {valid:false, badInput :true});
                    
                    if(day == 0)
                        errorMessage= "Date of FAT cannot be Sunday";
                    else if(day == 6)
                        errorMessage= "Date of FAT cannot be Saturday";
                    
                    target.set("v.errors", [{message:errorMessage}]);
                    target.set("v.value","");
                }
                
                elseif(val.includes(selectedDate.toString())){ 
                    
                    errorMessage = "Date of FAT cannot be Holiday";
                    target.set("v.errors", [{message:errorMessage}]);
                    target.set("v.value","");            
                }
                
                else*/
                if(maturityDate){
                    var oneDay = 24*60*60*1000; // hours*minutes*seconds*milliseconds
                    var firstDate = new Date(maturityDate);
                    var secondDate = new Date(selectedDate);
                    
                    //var diffDays = Math.round(Math.abs((firstDate.getTime() - secondDate.getTime())/(oneDay)));
                    var diffDays = Math.round((firstDate.getTime() - secondDate.getTime())/(oneDay));
                    if(diffDays < 0){
                        diffDays = 0;
                    }
                    else{
                        diffDays = diffDays+1;
                    }
                    component.set("v.days", diffDays);
                    var orderItemList = component.get("v.orderItemList");
					for (var idx = 0; idx < orderItemList.length; idx++) {
                        if(idx==rowIndex){
                            orderItemList[idx].days = component.get("v.days");
                            break;
                        }
                    }
                    component.set("v.orderItemList", orderItemList);
                    if(diffDays > 365){
                        errorMessage = $A.get("$Label.c.Date_of_FAT_greater_than_360");
                        target.set("v.errors", [{message:errorMessage}]);
                        target.set("v.value","");  
                        flag = false;
                    }
                    /*else{
                        target.set("v.errors", null);    
                        //target.set("v.errors", [{message:""}]);    
                    }*/
                    
                    //Change request added by ganesh 
                    //Date:17/10/2018
                    //desc:validate FAT if payment term is INFORMAR VENCIMENTO
                    if(selectedPaymentTerm.includes("BR71 INFORMAR VENCIMENTO")){
                        if(secondDate > firstDate){
                            errorMessage = $A.get("$Label.c.Dat_of_Fat_not_be_greater_than_Maturity_Date");
                            target.set("v.errors", [{message:errorMessage}]);
                            
                            // target.set("v.errors", [{message: $A.get("$Label.c.Dat_of_Fat_not_be_greater_than_Maturity_Date")}]);
                          //  console.log($A.get("$Label.c.Dat_of_Fat_not_be_greater_than_Maturity_Date"));
                            target.set("v.value","");  
                            $A.util.addClass(target, "error");
                            flag = false;
                        } else{
                            if(target.get("v.errors")==null){
                            target.set("v.errors", null); 
                                $A.util.removeClass(target, "error");}
                        }
                    }
                    //End patch
                    
                }
                else{
                    //Set Error
                    target.set("v.errors", null);  
                }
                component.set("v.isValidFAT",flag);
            }
        }
    },

    // Create sales order on Save as Draft/ Submit button. 
    // 1. Order Status = Draft when Order saved using Save as Draft 
    // 2. Order Status = Submitted when Order saved using Submit button
    saveFormAsDraft : function(component, event, helper) { 
		var status = "";	
        var isDraft = component.get("v.isDraft");
        if(isDraft == false){
          status = 'Submitted';
        }
        else{
            status = "Draft";
        }
        helper.validateSOCServer(component, event, status, false);
		//helper.createSalesOrder(component, event, status, false);
    },
    
    //Logic to show confirmation dialog with Simulation Flag & Message on Save and Submit.
    openConfirmDialog : function(component, event, helper) {
        
        var selected = event.getSource().get("v.label");
        var isSimulated = component.get("v.isSimulated");
        
        if(isSimulated){
            //helper.createSalesOrder(component, event, "Draft" , true); 
            helper.validateSOCServer(component, event, "Draft", true);
        }
        else if(!isSimulated){
            //console.log('selected: '+selected);
            //console.log('Submit: '+$A.get("$Label.c.Submit"));
            if(selected==$A.get("$Label.c.Submit")){
                component.set("v.isDraft", false);
                //helper.createSalesOrder(component, event, "Submitted" , true);
                helper.validateSOCServer(component, event, "Submitted", true);
            }
            else{
                component.set("v.isDraft", true);
                //helper.createSalesOrder(component, event, "Draft" , true);  
                helper.validateSOCServer(component, event, "Draft", true);
            }
        }
    },
    
    //Logic to hide all selection modals    
    closeConfirmDialog : function(component, event, helper) {
        helper.toggleConfirmDialog(component);
    }, 
	    
	//Logic to redirect user after the record is Saved as per Logged In  user Profile.    
    closeOKDialog: function(component,event,helper){
        helper.toggleConfirmDialog(component);
        
        //var flagIm = component.get("v.isflagGreen");
        var orderStatus = component.get("v.newSalesOrder.Order_Status__c");
        //console.log('flagIm: '+flagIm);
        //console.log('orderStatus: '+orderStatus);

        if(orderStatus!= "Draft"){
            var profileName = component.get("v.orderFields.userObj.Profile.Name");
            var fullUrl = '';
            var defType = '';
            
            if(profileName=='Brazil Sales Person'){
                defType = 'approved';
                fullUrl = "/apex/BrazilEnhancedListForSP?defType="+defType;
                helper.gotoURL(component,fullUrl);
            }
            else if(profileName=='Brazil Sales District Manager'){                                            
                defType = 'approved';
                fullUrl = "/apex/BrazilEnhancedListForSDM?defType="+defType;
                helper.gotoURL(component,fullUrl);
            } 
            else if(profileName=='Brazil Sales Office Manager'){                                            
                defType = 'approved';
                fullUrl = "/apex/BrazilEnhancedListForSOM?defType="+defType;
                helper.gotoURL(component,fullUrl);
            }               
        }
        //End
    },
    
    // Method use to enable Editing of Order Form using 'Edit' button 
    // Enabled when order status is 'Draft/Rejected'
    editForm:function(component){
        component.set("v.disableThis", false);
        //component.set("v.disableSelect", false);
        component.set("v.disableEdit", true);
        
        var isSimulated = component.get("v.isSimulated");
        
        if(isSimulated){
            component.set("v.headerMsg", $A.get("$Label.c.Edit_Simulation_Order")); 
        }
        else{
            component.set("v.headerMsg", $A.get("$Label.c.Edit_Order"));
        }
    },
    
    removeValidationError: function(component,event){
        var target = event.getSource();  
        if(target.get("v.value") != null && target.get("v.value") != 'None'){
            target.set("v.errors",null);
        }    
    },
    
	// Method uses Prototype to replace Portuguese characters from the Input String against a pre-defined Map of characters and replaces them
	// Make sure space bar is hit after the input in the text area
	// Works even if input is pasted in the TextArea
    validateInvoiceMessage  : function(component) {
        var input = component.get('v.newSalesOrder.Invoice_Message__c');
        
        var languageMap = component.get("v.languageMap");
        
        String.prototype.portuguese=function(){
            return this.replace(/[^A-Za-z0-9\[\] ]/g,
                                function(a){
                                    return languageMap.portuguese_map[a]||a}
                               )
        };
        
        String.prototype.portugueze = String.prototype.portuguese;
        
        //Not In Use : (FYI - Can be used to check if input contains portuguese alphabets)
        String.prototype.isPortuguese=function(){
            return this == this.portuguese()
        }
        //End
        
        //console.log(inp.portugueze()); 
        component.set('v.newSalesOrder.Invoice_Message__c', input.portugueze());
    },
    
    // Method used to Download SalesOrder PDF (Calls visualforce page)
    renderedPDF:function(component, event, helper){
        var recordId = component.get('v.recordId');
        var punctual = component.get('v.isPunctual');
        window.open('/apex/SalesOrderPDF?id1='+recordId+'&punct='+punctual);
    },
    
    // Event used to get selected row from 'Lightning Data Table' Component (Used for Account/SOM/Product)
    tabActionClicked: function(component, event, helper){
        
        //get the id of the action being fired
        var actionId = event.getParam('actionId');
        //get the row where click happened and its position
        //var rowIdx = event.getParam("index");
        var itemRow = event.getParam('row');
        
        if(actionId == 'selectaccount'){
            component.set("v.selItem",itemRow);
            
            //Assign accountId to Sales Order record attribute
            component.set("v.newSalesOrder.Sold_to_Party__c", itemRow.Id);
            component.set("v.newSalesOrder.Program_Margin_Discount__c", itemRow.Program_Margin_Discount__c);
            
            //component.set("v.isClicked",false);
			helper.closePopUp(component);
            helper.fetchPriceBookDetails(component);
            
            var customerName = component.find("customerName");
            customerName.set("v.errors",null);
            $A.util.removeClass(customerName, "error");
            
            //var action = component.get("c.closePopUp");
            //$A.enqueueAction(action);
        }
        
        else if(actionId == 'selectproduct'){
            var rowIndex = component.get("v.rowIndex");
            var selAccount = component.get("v.selItem");
            var accountState = selAccount.Customer_Region__c;
            
            if((itemRow.balanceQty > 0 && itemRow.isMO == true) || itemRow.isMO == false){
                var stateflag = true;
                var validityflag = true;
                var errorMessage = '';
                
                if(itemRow.regState!=accountState){
                    stateflag = false;
                    errorMessage = $A.get("$Label.c.Material_without_Registration_Dates_Please_check_with_Customer_Service_team");
                } 
                else if(!itemRow.isValid){
                    validityflag = false;
                    errorMessage = $A.get("$Label.c.Registration_date_is_out_of_limit_Please_contact_the_Customer_Service_Team");
                }
                
                if(stateflag && validityflag){
                    //Edit Row function
                    var orderItemList = component.get("v.orderItemList");
                    var getProductId = component.find("itemproduct");
                    var getItemSelId = component.find("itemsel");
                    var isProductArray = Array.isArray(getProductId);
                    
                    for (var idx=0; idx < orderItemList.length; idx++) {
                        if (idx==rowIndex) {
                            //if(orderItemList.length == 1){
                            if(isProductArray){
                                component.find("itemproduct")[idx].set("v.errors",null);    
                            }
                            else{
                                component.find("itemproduct").set("v.errors",null);
                            }
                            orderItemList[idx].productId = itemRow.skuId;
                            orderItemList[idx].productName = itemRow.skuDescription;
                            orderItemList[idx].listValue = itemRow.unitValue;
                            //console.log('itemRow.pricebookId'+itemRow.pricebookId);
                            orderItemList[idx].priceBookDetailId = itemRow.pricebookId;
                            //console.log('orderItemList[idx].priceBookDetailId'+ orderItemList[idx].priceBookDetailId);
                            orderItemList[idx].inventory = itemRow.balanceQty;
                            orderItemList[idx].productCode = itemRow.skuCode;
                            orderItemList[idx].multipleOf = itemRow.multipleOf;
                            orderItemList[idx].itemNo = itemRow.itemNo;
                            orderItemList[idx].moItemNo = itemRow.itemNo;
                            orderItemList[idx].isMO = itemRow.isMO;
                            
                            var days = component.get("v.days");
                            var monthlyInterestRate = 0;
                            orderItemList[idx].days = days;
                            if(itemRow.unitValue!=0){
                                //console.log(' orderItemList[idx].qty'+ orderItemList[idx].qty);
                                orderItemList[idx].fatDate = itemRow.fatDate;
                                //console.log('itemRow.fatDate'+itemRow.fatDate);
                                //console.log('itemRow.balanceQty'+itemRow.balanceQty);
                                orderItemList[idx].qty = itemRow.balanceQty;
                                 
                                //orderItemList[idx].unitValue = itemRow.unitValue;
                                //orderItemList[idx].unitValueWithInterest = itemRow.unitValueWithInterest;
                                orderItemList[idx].days = itemRow.days;
                                orderItemList[idx].cultureDesc = itemRow.cultureDesc;
                            }
                            //orderItemList[idx].qty = itemRow.qty;
                            
                            //if(days > 0){
                                monthlyInterestRate = itemRow.monthlyInterestRate;                        
                                orderItemList[idx].days = days;
                            //}
                            
                            var orderType = component.get("v.newSalesOrder.Type_of_Order__c");

                            if(orderType=="ORDEM FILHA"){
                                orderItemList[idx].orderItemId = itemRow.orderItemId;
                                orderItemList[idx].unitValue = itemRow.unitValue;
                                orderItemList[idx].unitValueWithInterest = itemRow.unitValueWithInterest;
                                
                                if(isProductArray){  
                                    component.find("itemsel")[idx].set("v.disabled",true);  
                                }
                                else{
                                    component.find("itemsel").set("v.disabled",true);  
                                }
                                
                                if(!itemRow.orderItemId) {
                                    var toastMsg = '';
                                    toastMsg = $A.get("$Label.c.Order_Item_Id_not_found");
                                    helper.showErrorToast(component, event, toastMsg);
                                }
                                
                                helper.validateOrderItems(component);
                            }
                            else{
                                orderItemList[idx].minValue = itemRow.minValue;
                                if(orderItemList[idx].qty == '0'){
                                    orderItemList[idx].qty = '';
                                }
                            }

                            orderItemList[idx].interestRate = monthlyInterestRate;

                            var priceDetailList = component.get("v.priceDetailList");
                            for (var idxy = 0; idxy< priceDetailList.length; idxy++) {
                                if(priceDetailList[idxy].itemNo == orderItemList[idx].itemNo){
                                    //console.log(' orderItemList[idx].qty-->'+ orderItemList[idx].qty);
                                    priceDetailList[idxy].balanceQty = priceDetailList[idxy].balanceQty - orderItemList[idx].qty;
                                    //console.log(' priceDetailList[idxy].balanceQty-->'+  priceDetailList[idxy].balanceQty);
                                    //priceDetailList[idxy].percUsed = parseFloat(Math.abs((priceDetailList[idxy].balanceQty / priceDetailList[idxy].qty) *100)).toFixed(2);
                                    priceDetailList[idxy].percUsed = Math.abs((priceDetailList[idxy].balanceQty / priceDetailList[idxy].qty) *100);
                                    break;
                                }
                            }
                            component.set("v.priceDetailList", priceDetailList);
                            
                            break;
                        }
                    }
                    //console.log('Calculations called');
                    helper.updateRowCalculations(component, event);
                    component.set('v.orderItemList', orderItemList);
                    
                    //End function
                }
                else{
                    var toastMsg = errorMessage;
                    //var toastMsg = 'Selected Product is not Registered in Customer State ('+accountState+').';
                    helper.showErrorToast(component, event, toastMsg);
                }
            }
            else{
                var toastMsg = $A.get("$Label.c.Balance_Qty_of_selected_product_is_0");
                helper.showErrorToast(component, event, toastMsg);
            }
			helper.closePopUp(component);
        }
        
		else if(actionId == 'selectsom'){
			helper.closePopUp(component);

            var soName = component.find("soName");
            soName.set("v.errors",null);
            $A.util.removeClass(soName, "error");
          	component.set("v.selItem3" ,itemRow);  
            
          	//added by ganesh 
          	//desc: to get business rule of chosen SOM 
          	
            component.set("v.businessRule.Taxes__c", itemRow.Tax__c);
            component.set("v.businessRule.Freight__c", itemRow.Freight__c);
            component.set("v.newSalesOrder.Tax__c", itemRow.Tax__c);
            component.set("v.newSalesOrder.Freight__c", itemRow.Freight__c);
            
            var maturityDate = itemRow.Maturity_Date__c;

            //console.log('maturityDate: '+maturityDate);
            
            if(maturityDate){
                component.set("v.isMature" ,true);
                component.set("v.newSalesOrder.Maturity_Date__c" ,itemRow.Maturity_Date__c);  
            }
            
            
            var punctualityDiscount = itemRow.Punctuality_Discount__c;
            
            if(punctualityDiscount && punctualityDiscount > 0){
                component.find("descNo").set("v.value","false");
                component.find("descYes").set("v.value","true");
                component.set("v.isPunctual","true");
                component.set("v.newSalesOrder.Punctuality_Discount__c", punctualityDiscount);
            }
            
            //Add Option
            var opts=[];   
			opts.push({"class": "optionClass", label: itemRow.Price_Book__r.Name, value: itemRow.Price_Book__c});
            component.find("priceListOptions").set("v.options", opts);  
            //End
            
			//Assign somId to Sales Order record attribute
			component.set("v.newSalesOrder.Sales_Order__c", itemRow.Id);
              if(orderType!='None'){
                component.set("v.disableSearch", true);
                window.setTimeout(
                    $A.getCallback(function() {component.set("v.disableSearch", false);}), 2000 );
            }
		}                
    },
    
    // Logic to Add Order Line Item 
    addTableRow : function(component, event, helper){
        
        var isValid = helper.validateOrder(component); 
        var isValidItems = helper.validateOrderItems(component); 
        var isValidTo = component.get("v.isValidTo");
        var isValidFrom = component.get("v.isValidFrom");
        var isValidMaturity = component.get("v.isValidMaturity");
        var isValidInvoice = component.get("v.isValidInvoice");
        
        var orderItemList = component.get("v.orderItemList");
       
        //Initialize validation flag to false
        var flag = false;
        
        //Check if order has line items and then check if all inputs are valid before adding new line item
        if(orderItemList.length > 0){
            if(isValid && isValidItems){
                flag = true;
            }
        }
        else if(isValid){
            flag = true;
        }
        
        // Set Validation Flag to 'false' if any of the validation returns 'false'
        if(!isValidTo || !isValidFrom || !isValidMaturity || !isValidInvoice){
            flag = false;
        }
        
        //If all validations are successful add new row
        if(flag){
            orderItemList.push({
                productId:"",
                priceBookDetailId: "",
                productName:"", 
                fatDate:"", 
                qty:"", 
                listValue:"0", 
                unitValue:"", 
                unitValueWithInterest:"0",
                totalValue:"0", 
                totalValueWithInterest:"0",
                interestRate:"0", 
                days: "0", 
                timeInMonths: "0"
                //cultureDesc:""
            });
            component.set("v.orderItemList",orderItemList);
            
            helper.enableDisableFields(component, orderItemList.length);
        }
        else{
            var toastMsg = $A.get("$Label.c.Please_provide_valid_input_fill_all_the_mandatory_fields_before_proceeding");
            helper.showErrorToast(component, event, toastMsg);
        }
    },
    
    // Logic to remove Order Line Item
    removeTableRow : function(component, event, helper) {
        var target = event.getSource();  
        var index = target.get("v.value");
        var items = component.get("v.orderItemList");    
        
        var getQtyId = component.find("itemqty");
        var qty,itemNo;
        var isQuantityArray = Array.isArray(getQtyId);
        
        if(isQuantityArray){
            qty = getQtyId[index].get("v.value");    
            itemNo = getQtyId[index].get("v.requiredIndicatorClass");
        }
        else{
            qty = getQtyId.get("v.value");
            itemNo = getQtyId.get("v.requiredIndicatorClass");
        }
        
        var orderType = component.get("v.newSalesOrder.Type_of_Order__c");
        if(orderType=="ORDEM FILHA"){

            var priceDetailList = component.get("v.priceDetailList");
            for (var idx = 0; idx < priceDetailList.length; idx++) {
                //console.log('priceDetailList[idx].itemNo: '+priceDetailList[idx].itemNo);
                //console.log('itemNo: '+itemNo);

                if(priceDetailList[idx].itemNo == itemNo){
                    //console.log('priceDetailList[idx].itemNo: '+priceDetailList[idx].itemNo);
                    //console.log('itemNo: '+itemNo);
                    
                    priceDetailList[idx].balanceQty = priceDetailList[idx].balanceQty + qty;
                    //priceDetailList[idx].percUsed = parseFloat((priceDetailList[idx].balanceQty / priceDetailList[idx].qty) *100).toFixed(2);
                    priceDetailList[idx].percUsed = (priceDetailList[idx].balanceQty / priceDetailList[idx].qty) *100;
                    
                    //console.log('balanceQty: '+priceDetailList[idx].balanceQty);
                    break;
                }
            }     
            component.set("v.priceDetailList", priceDetailList);
            //console.log('priceDetailList: '+JSON.stringify(priceDetailList));
        }
        
        if(index == items.length - 1){
            component.set("v.cultureDescList", null);
        	items.splice(index, 1);
			component.set("v.cultureDescList", component.get("v.cultureDescListCopy"));              
        }
        else{
            items.splice(index, 1);
        }
        //console.log('index: '+ index);
        var orderStatus = component.get("v.newSalesOrder.Order_Status__c");
        if(index == 0){
            var recordId = component.get("v.recordId");
           	//console.log('recordId: '+recordId); //|| (orderStatus=="Draft" && recordId)
            if(orderStatus!="Draft"){
                helper.fetchPriceBookDetails(component);
            }
            //component.set("v.isValid", false);
            //component.set("v.isValidItems", false);
        }
        
        component.set("v.orderItemList", items);
        
        helper.enableDisableFields(component, items.length);
        helper.updateRowCalculations(component, event);
    },
    
    //Logic to store the old value of Qty in to a temporary variable and restore it if the user blanks the Qty in the Line Items
    updateOldBalanceQty : function(component, event, helper) {
        var target = event.getSource();  
        var qty = target.get("v.value");
		component.set("v.oldValueQty", qty);      
    },
    
    // Logic to update current row with calculations
    updateTableRow : function(component, event, helper) {
        var target = event.getSource();  
        var unitValue = target.get("v.value");
        var minValue = target.get("v.requiredIndicatorClass");
        var prsntValue = 0 ;
        var setBlank = 0;
        var rowIndex = component.get("v.rowIndex");
        
        if(unitValue) {
            //var unitValueFixed  = unitValue.toFixed(2);
            var unitValueFixed  = unitValue;
            target.set("v.value",unitValueFixed);
        }
        
        /* Change-Request Uncomment When needed*/
        var orderItemList = component.get("v.orderItemList");
        for (var idx = 0; idx < orderItemList.length; idx++) {
            if(idx==rowIndex){
                 console.log('idx'+idx);
                 console.log('rowIndex'+rowIndex);
                if(orderItemList[idx].unitValue!=null){
                var value2 = orderItemList[idx].unitValue.toString(); //Convert to string
                orderItemList[idx].unitValue = parseFloat(value2.replace("-", "")); //Replace negative sign
                     console.log(orderItemList[idx].unitValue+'orderItemList[idx].unitValue');
                }
                orderItemList[idx].timeInMonths = orderItemList[idx].days/30;
                if(orderItemList[idx].timeInMonths && orderItemList[idx].interestRate!=0){
                    orderItemList[idx].unitValueWithInterest = orderItemList[idx].unitValue / (Math.pow(1+orderItemList[idx].interestRate/100,orderItemList[idx].timeInMonths));
                    prsntValue = orderItemList[idx].unitValueWithInterest;
                    console.log('presntValue'+prsntValue);
                }
                else{
                    prsntValue = orderItemList[idx].unitValue;
                }
                break;
            }
        }
        
        if(prsntValue < minValue){
          	//change added by ganesh 
           	//target.set("v.errors", [{message: $A.get("$Label.c.Unit_Value_cannot_be_less_than")+" "+minValue}]);
     		target.set("v.errors", [{message: $A.get("$Label.c.Unit_Value_isn_t_allowed")}]);
            target.set("v.value","");
            $A.util.addClass(target, "error");            
        } 
        else{
            target.set("v.errors", null); 
            $A.util.removeClass(target, "error");
            
            //console.log('minValue1'+minValue);
            
            helper.updateRowCalculations(component, event);
        }
    },
    
    // Remove validation message if punctuality discount is entered
    updatePunctualityDiscount: function(component, event, helper){
        //var locale = $A.get("$Locale.locale");
        //console.log('locale format: '+locale);
        
        var target = event.getSource();
        var discountValue = target.get("v.value");
        if(discountValue) {
            //var discountFixedValue = discountValue.toFixed(2); //parseFloat(discountValue).toFixed(2).toLocaleString();
            //target.set("v.value", discountFixedValue);
            
            component.find("punctualitydisc").set("v.errors",null);  
            $A.util.removeClass(component.find("punctualitydisc"), "error");
        }
    },

    // Restrict Negative Discount Values
    restrictNegativeValue: function(component, event, helper){
        var target = event.getSource();  
        var discountValue = target.get("v.value");
        
        //Logic to restrict negative value
        if(discountValue==null){
            discountValue = 0;
        }
        else{
            var discountString = discountValue.toString(); //Convert to string
            discountValue = parseFloat(discountString.replace("-", "")); //Replace negative sign
        }
        
        target.set("v.value",discountValue);
        //End of logic
    },
    
    // Logic to show SOM Balance Modal
    openBalancePopUp : function(component, event, helper) {
        component.set("v.modalHeader", $A.get("$Label.c.SOM_Balance"));
        
		helper.hideAllCmp(component);
        
        var balancedata = component.find("balancedata1");
        $A.util.removeClass(balancedata, 'slds-hide');  
        
        helper.toggle(component);
    },    
    
    // Logic to show Account Selection Modal
    openPopUp : function(component, event, helper) {
        component.set("v.modalHeader",$A.get("$Label.c.Customer"));
        
        helper.hideAllCmp(component);
        
        var accountdata = component.find("accountdata1");
        $A.util.removeClass(accountdata, 'slds-hide');
        
        helper.toggle(component);
    },

    // Logic to show SOM Selection Modal    
    openSOMPopUp : function(component, event, helper) {
        component.set("v.modalHeader", $A.get("$Label.c.S_O_Mother"));
        
        helper.hideAllCmp(component);
        
        var somdata = component.find("somdata1");
        $A.util.removeClass(somdata, 'slds-hide');
        
        helper.toggle(component);
    },
        
    // Logic to show Product Selection Modal        
    openPriceDeatilsPopUp : function(component, event, helper) {
        var target = event.getSource();  
        var rowIndexValue = target.get("v.value");
        
        component.set("v.modalHeader", $A.get("$Label.c.Products"));
        component.set("v.rowIndex",rowIndexValue);
        
        helper.hideAllCmp(component);
        
        var pricedata = component.find("pricedata1");
        $A.util.removeClass(pricedata, 'slds-hide');
        
        //helper.fetchPriceBookDetails(component);
        helper.toggle(component);
    },   
    
    // Logic to show approval/rejection modal
    openDialog : function(component, event, helper) {
        var selected = event.getSource().get("v.label");
        var status = "";
        var toastMsg = '';
        
        if(selected==$A.get("$Label.c.Approve")){
            component.set("v.isApproval",true);
            status = "Draft";	
        }
        else{
            component.set("v.isApproval",false);
            status = "Draft";	
        }
        
        var disableBarter = component.get("v.disableBarter");
        //console.log(disableBarter);
        
        if(disableBarter==false){
            var businessdisc = component.find("businessdisc");
            var financialdisc = component.find("financialdisc");
            
            var flag = true;
            
            if(businessdisc.get("v.value") == null || businessdisc.get("v.value") == ''){
                flag = false;
                component.find("businessdisc").set("v.errors",[{message: $A.get("$Label.c.Business_Discount_is_required") }]);                    
            }
            else{
                component.find("businessdisc").set("v.errors",null);
            }      
            
            if(financialdisc.get("v.value") == null || financialdisc.get("v.value") == ''){
                flag = false;
                component.find("financialdisc").set("v.errors",[{message: $A.get("$Label.c.Financial_Discount_is_required") }]);                    
            }
            else{
                component.find("financialdisc").set("v.errors",null);
            }   

            if(flag==false){
                toastMsg = $A.get("$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding");
                helper.showErrorToast(component, event, toastMsg);
            }
            else{
                var action = component.get("c.signOrder");
                action.setParams({ 
                    "soObj": component.get("v.newSalesOrder")
                });
                
                action.setCallback(this, function(a) {
                    var state = a.getState();
                    if (state == "SUCCESS") {
                        var signed = component.get("v.newSalesOrder.Signed__c");
                        if(signed){
                            component.set("v.showSign",false);
                            component.set("v.showUnsign",true);
                            component.set("v.signMessage", $A.get("$Label.c.Are_you_sure_you_want_to_unsign"));
                        }
                        else{
                            component.set("v.showSign",true);
                            component.set("v.showUnsign",false);
                            component.set("v.signMessage", $A.get("$Label.c.Are_you_sure_you_want_to_sign"));
                        }
                    }
                    else{
                        //toastMsg = 'Signing Failed';
                        //helper.showErrorToast(component, event, toastMsg);   
                    }             
                });
                $A.enqueueAction(action);  
                helper.toggleDialog(component);
            }
        }
        else{
            helper.toggleDialog(component);
        }
    },
    
    // Logic to hide all selection modals    
    closeDialog : function(component, event, helper) {
        helper.toggleDialog(component);
    },   
    
    //Logic to hide all selection modals    
    closePopUp : function(component, event, helper) {
        helper.closePopUp(component);
    },    
    
    // Save Comments while Approving / Rejecting Order (Available for: SDM/SOM/SD/Barter)
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
                recordId: component.get("v.recordId"),
                comments: component.get("v.comments")
            });
            // show spinner to true on click of a button / onload
            component.set("v.showSpinner", true); 
            
            action.setCallback(this, function(a) {
                // on call back make it false ,spinner stops after data is retrieved
                component.set("v.showSpinner", false); 
                var state = a.getState();
                if (state == "SUCCESS") {
                    var returnValue = JSON.stringify(a.getReturnValue());
                    component.set("v.approvalList",a.getReturnValue());
                    
                    var enableApproval = component.get("v.approvalList.enableApproval");
                    component.set("v.showApproveReject", enableApproval);
                    component.set("v.disableBarter", true);
                    
                    component.set("v.showSimulate", false);
                    
                    var profileName = component.get("v.orderFields.userObj.Profile.Name");
                    var fullUrl = '';
                    var defType = '';
                    
                    if(component.get("v.isApproval")){
                        defType = 'approved';
                    }
                    else{
                        defType = 'rejected';
                    }      
                    
                    if(profileName=='Brazil Sales District Manager'){
                        fullUrl = "/apex/BrazilEnhancedListForSDM?defType="+defType;
                        helper.gotoURL(component, fullUrl);
                    }  
                    else if(profileName=='Brazil Sales Office Manager'){
                        fullUrl = "/apex/BrazilEnhancedListForSOM?defType="+defType;
                        helper.gotoURL(component, fullUrl);
                    }
					else if(profileName=='Brazil Sales Director'){
						fullUrl = "/apex/BrazilEnhancedListForSD?defType="+defType;
						helper.gotoURL(component, fullUrl);
					}
                    else if(profileName=='Brazil Barter Manager'){
						fullUrl = "/apex/BrazilEnhancedListforBarter?defType="+defType;
						helper.gotoURL(component, fullUrl);
                    }
                }	
            });
            helper.toggleDialog(component);
            $A.enqueueAction(action);
        }
    },
    
    // Reset all input elements on the form
    resetForm : function(component, event, helper){
        // show a confirm
        if(confirm( $A.get("$Label.c.Are_you_sure_you_want_to_reset_the_details") )){
            // perform custom logic here    
            
            component.set("v.newSalesOrder", 
                          {'sobjectType' : 'Sales_Order__c',
                           'Name' : "",
                           'Sold_to_Party__c' : "",
                           'Sales_Order__c' : null,
                           'Price_Book_Details__c' : "",
                           'Type_of_Order__c' : "",
                           'Valid_From__c' : "",
                           'Valid_To__c' : "",
                           'Payment_Method__c' : "",
                           'Payment_Term__c' : "",
                           'Sold_to_Party__r' : null,
                           'Purchase_Order_no__c': "",
                           'Purchase_Order_Date__c': null,
                          });
            
            component.set("v.selItem",null);
            component.set("v.selItem2",null);
            component.set("v.selItem3",null);
            component.set("v.selItem4",null);
            component.set("v.totalValue",0);
            component.set("v.priceBookId",null);
            
            var items = component.get("v.orderItemList");
            for(var index=0; index<items.length; index++){
                if(index == items.length - 1){
                    component.set("v.cultureDescList", null);
                    items.splice(index, 1);
                    component.set("v.cultureDescList", component.get("v.cultureDescListCopy"));     
                }
                else{
                    items.splice(index, 1);
                }
            }
            
            component.set("v.orderItemList",items);
            helper.enableDisableFields(component, items.length);
            component.set("v.recordId",null);
            
            var action = component.get("c.doInit");
            $A.enqueueAction(action); 
        }       
    },
    
    // Populate current date in ValidTo date by default 
    onDateChangeValidToDate : function(component){
        var inputCmp = component.find("validToDate");
        var value = inputCmp.get("v.value");
        
        var inputCmp1 = component.find("validFrom");
        var value1 = inputCmp1.get("v.value");
        
        var x = new Date(value);
        var y = new Date(value1);
        
        var flag = true;
        
        if(x=='Invalid Date'){
            inputCmp.set("v.errors", [{message: $A.get("$Label.c.Valid_to_date_is_required")}]);      
            $A.util.addClass(inputCmp, "error");
            flag = false; 
        }
        // is less than today?
        else if (+x < +y) {
            //inputCmp.set("v.errors", [{message:"Valid To date: "+value+" cannot be less than Valid From date: " + value1}]);
            inputCmp.set("v.errors", [{message: $A.get("$Label.c.To_date_can_not_be_before_from_date")}]);
            $A.util.addClass(inputCmp, "error");
            flag = false;
        }
        else {
            inputCmp.set("v.errors", null);
            $A.util.removeClass(inputCmp, "error");
        }
        
        component.set("v.isValidTo",flag);
    },

    // Populate financial year end date in Valid From date by default  
    // Validation to check if Valid From less than today   
    // Validation to check if Valid From greater than Valid To (Expiry) Date
    onDateChangeValidFromDate : function(component){
        var inputCmp = component.find("validFrom");
        var value = inputCmp.get("v.value");
        
        var inputCmp2 = component.find("validToDate");
        var value2 = inputCmp2.get("v.value");
        
        var today = new Date();
        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        
        // Custom date format for ui:inputDate
        var currentDate = (yyyy + "-" + MM + "-" + dd);
        
        var x = new Date(value);
        var y = new Date(currentDate);
		var z = new Date(value2);
        
        var flag = true;
        
        //console.log('validFromDate: '+x);
        //console.log('validToDate: '+z);
        //console.log('+x > +z: '+(+x > +z));
        
        if(x=='Invalid Date'){
            inputCmp.set("v.errors", [{message:"Valid From is required"}]);           
            $A.util.addClass(inputCmp, "error");
            flag = false; 
        }
        // is less than today?
        else if (+x < +y) {
            inputCmp.set("v.errors", [{message: $A.get("$Label.c.Valid_From_cannot_be_less_than_today") }]);    
            $A.util.addClass(inputCmp, "error");
            flag = false;
        } 
        else if(+x > +z){
            inputCmp.set("v.errors", [{message: $A.get("$Label.c.Valid_From_Date_cannot_be_more_than_Valid_To_date") }]);
            $A.util.addClass(inputCmp, "error");
            flag = false;
        }
        else {
            inputCmp.set("v.errors", null);
            $A.util.removeClass(inputCmp, "error");
        }
        component.set("v.isValidFrom",flag);
    },
    
    // Logic to check if PO Date is valid
    restrictPODate: function(component){
        var inputCmp = component.find("poDate");
        var value = inputCmp.get("v.value");
		
        if(value){
            var x = new Date(value);
            var flag = true;
            
            //console.log('validFromDate: '+x);
            
            if(x=='Invalid Date'){
                inputCmp.set("v.errors", [{message: $A.get("$Label.c.Purchase_Order_date_is_required")}]);                 
                $A.util.addClass(inputCmp, "error");
                flag = false; 
            }
            else {
                inputCmp.set("v.errors", null);
                $A.util.removeClass(inputCmp, "error");
            }
            //component.set("v.isValidMaturity",flag);
        }
    },
    
    // 1. Logic to check maturity date not less than today
    // 2. Logic to validate if input date is a valid date
    restrictMaturityDate : function(component, event){
        //var inputCmp = component.find("maturityDate");
        var target = event.getSource();  
        var value = target.get("v.value"); //inputCmp.get("v.value");
        
        if(value){
            var today = new Date();
            var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
            var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
            var yyyy = today.getFullYear();
            
            // Custom date format for ui:inputDate
            var currentDate = (yyyy + "-" + MM + "-" + dd);
            
            var x = new Date(value);
            var y = new Date(currentDate);
            
            var flag = true;
            
            //console.log('validFromDate: '+x);
            //console.log('+x > +z: '+(+x > +z));
            
            if(x=='Invalid Date'){
                target.set("v.errors", [{message: $A.get("$Label.c.Maturity_date_is_required")}]);
                $A.util.addClass(target, "error");
                flag = false; 
            }
            // is less than today?
            else if (+x < +y) {
                target.set("v.errors", [{message: $A.get("$Label.c.Maturity_Date_cannot_be_less_than_today") }]);
                $A.util.addClass(target, "error");
                flag = false;
            } 
            else {
                target.set("v.errors", null);
                $A.util.removeClass(target, "error");
            }
            component.set("v.isValidMaturity",flag);
        }
    },
    
    // Method to Update Punctuality flag on Radio Group Value
    onGroup: function(component, event) {
        var selected = event.getSource().get("v.text");
        if(selected == 'Yes'){
            component.set("v.isPunctual", true);
        }
        else if(selected == 'No'){
            component.set("v.isPunctual", false);
            component.set("v.newSalesOrder.Punctuality_Discount__c", "");
        }
        //console.log('selected: '+selected);
    },
    
    // 1. If Key Group = No then fetch Business Rule of current logged in user.
    // 2. Else fetch All the sellers of the Same district to which the Logged in user (Sales Person) belongs
    onKeyGroup: function(component, event, helper) {
        var selected = event.getSource().get("v.text");
        //console.log('selected: '+selected);
        
        if(selected == 'Yes'){
            component.set("v.newSalesOrder.Key_Account__c", true);
            helper.fetchSeller(component);
            //patch added by ganesh
            component.set("v.selectedUser",'None');
            component.set("v.orderType",'None');
            helper.fetchAccounts(component);
        }
        else if(selected == 'No'){
            //added by ganesh 
            component.set("v.newSalesOrder.KeyAccountDesOwnerBrazil__c", null);
            component.set("v.selectedUser",'None');
            //end
            component.set("v.showSeller", false);
            component.set("v.orderType",'None');
            component.set("v.newSalesOrder.Key_Account__c", false);
            helper.fetchAccounts(component);
            
            //Commenting this because when Key Account is 'No' user Id will be set to logged in user
            //var currentValue = component.get("v.newSalesOrder.KeyAccountDesOwnerBrazil__c"); //event.getParam("value");
            
            var currentValue = component.get("v.user.Id"); 
            //console.log('currentValue: '+currentValue);
            
            if(currentValue && currentValue!='None'){
                //Commenting this because when Key Account is 'No' user Id will be set to logged in user
                //component.set("v.user.Id",currentValue); 
                
                //Set owner Id to logged In user
                component.set("v.newSalesOrder.OwnerId", currentValue);
                
                helper.fetchBusinessRule(component, currentValue);
            }
        }
    },
    
    // Method to check Selected Currency and Add Price List Options accordingly.
    handleCurrencyChange: function(component, event, helper){
        // handle value change
        //console.log("old value (Currency): " + JSON.stringify(event.getParam("oldValue")));
        //console.log("current value (Currency): " + JSON.stringify(event.getParam("value")));
        
        //if(event.getParam("oldValue")!=event.getParam("value")){
            
            //PriceList
            var returnValue = component.get("v.orderFields",returnValue);
            var priceList = returnValue.priceList;
        
        	//console.log('priceList: '+JSON.stringify(priceList));
        	
        	if(returnValue!='None'){
                var inputCmp = component.find("currencyOptions");
                inputCmp.set("v.errors", null);
                $A.util.removeClass(inputCmp, "error");
            }
        
            var opts=[];
           
            var selectedCurrency = event.getParam("value"); //component.get("v.newSalesOrder.Currency_Brazil__c"); 
 			//selectedCurrency = selectedCurrency.replace('"','');       
        	//console.log('selectedCurrency: '+selectedCurrency);
        	
            if(selectedCurrency==undefined || selectedCurrency=='None'){
                selectedCurrency = 'None'; //'Billing BRL / Payment BRL';
            }
            /*if(selectedCurrency=='None'){
                opts.push({"class": "optionClass", label: 'Select a price list', value: 'None'});
            }*/           
            component.set("v.newSalesOrder.Currency_Brazil__c", selectedCurrency);
            
            var priceBookId = component.get("v.newSalesOrder.Price_Book__c");
        	var priceBookName = component.get("v.newSalesOrder.Price_Book__r.Name");
        
          	//console.log('selectedCurrency: '+selectedCurrency);
           	//console.log('priceBookId: '+priceBookId+'priceBookName'+priceBookName);

            opts.push({"class": "optionClass", label: $A.get("$Label.c.Select_A_Price_List"), value: 'None'});
            if(priceList.length==0){
                opts.push({"class": "optionClass", label: priceBookName, value: priceBookId});   
            }
       
            if(selectedCurrency.startsWith('Billing BRL')){ // || selectedCurrency.startsWith('Faturamento BRL')
                selectedCurrency = 'BRL';
               	//console.log('BRL: '+selectedCurrency);
            }
            else if(selectedCurrency.startsWith('Billing USD')){ // || selectedCurrency.startsWith('Faturamento USD')
                selectedCurrency = 'USD';
                //console.log('USD: '+selectedCurrency);
            }
             
            for(var i=0; i< priceList.length; i++){
                var str = priceList[i];
                if(str.startsWith(selectedCurrency)){
                    var splitValues = str.split("*");
                    opts.push({"class": "optionClass", label: splitValues[0], value: splitValues[1]});               
                }         
            }
        
        	//console.log('opts'+JSON.stringify(opts));
        	
            component.set("v.newSalesOrder.CurrencyIsoCode", selectedCurrency);
            if(selectedCurrency!='None'){
                component.set("v.currency",selectedCurrency+' ');        
            }
            component.find("priceListOptions").set("v.options", opts);       
            //console.log('priceBookId: '+priceBookId);
            
            if(priceBookId){
               	//console.log('priceBookId:12 '+priceBookId);
                component.set("v.priceBookId",priceBookId);
                //component.set("v.priceBookId",priceBookName);
            }
        //}
        //End
    },
    
    // Logic to update Currency, Product Selection and PriceList based on selected SOM
    handleSOMChange: function(component, event, helper){
        var priceBookId = component.get("v.selItem3.Price_Book__c");
        var currencyBrazil = component.get("v.selItem3.Currency_Brazil__c");
        var paymentMethod = component.get("v.selItem3.PaymentMethod__c");
        
        var paymentTerm = component.get("v.selItem3.ReloadPaymentTerms__c");
        component.set("v.selItem",null);
        if(component.get("v.selItem3")!=null){
            var inputCmp = component.find("soName");
            inputCmp.set("v.errors", null);
            $A.util.removeClass(inputCmp, "error");
        }
        component.set("v.paymentTerm", paymentTerm);
        
        //console.log('paymentTerm SOM Change: '+paymentTerm);
        
        component.set("v.priceBookId",priceBookId);
        component.set("v.newSalesOrder.Currency_Brazil__c", currencyBrazil );
        component.set("v.selectedCurrency", currencyBrazil );
        component.set("v.paymentMethod", paymentMethod ); 
        
        //Fetch config/data for customers component from helper method        
        helper.fetchAccounts(component);        
    },
    
    // 1. Logic to enable Maturity date if selected value flag is 'Yes' on Payment Term record
    // 2. Set No. of Days based on Payment Term which is required for calculation on Order Line Items
    handlePaymentTermChange : function(component, event){
        //console.log('paymentTerm: '+event.getParam("value"));
        var paymentTerm = component.get("v.paymentTerm"); //event.getParam("value");        
        component.set("v.isMature", "false");
		component.set("v.newSalesOrder.ReloadPaymentTerms__c", paymentTerm);
        if(paymentTerm!='None'){
            
            var inputCmp = component.find("paymentTermOptions");
            inputCmp.set("v.errors", null);
            $A.util.removeClass(inputCmp, "error");
            
            var paymentTermsMap = component.get("v.paymentTermsMap");
            var pmObj = paymentTermsMap[paymentTerm]; //paymentTermsMap.get(paymentTerm);

            var maturityDate = component.get("v.newSalesOrder.Maturity_Date__c");
            //console.log('maturityDate: '+maturityDate);
            
            if(pmObj!=undefined){
                if(pmObj.Maturity_Date_Mandatory__c == $A.get("$Label.c.Yes") || pmObj.Maturity_Date_Mandatory__c == "Yes") {
                    component.set("v.isMature", "true");
                    
                    /*if(maturityDate==undefined || maturityDate==null || maturityDate==''){
                        // Initialize Valid From Date to Today by default.
                        var today = new Date();
                        
                        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
                        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
                        var yyyy = today.getFullYear();
                        
                        // Custom date format for ui:inputDate
                        var validFromDate = (yyyy + "-" + MM + "-" + dd);                    
                        component.set("v.newSalesOrder.Maturity_Date__c", validFromDate);
                    }*/
                }
                else{
                    component.set("v.isMature", "false");
                    component.set("v.newSalesOrder.Maturity_Date__c", null);
                }
                component.set("v.newSalesOrder.Payment_Term__c", pmObj.Id);
                console.log('days: '+pmObj.Days_to_calc_interest__c);
                component.set("v.days", pmObj.Days_to_calc_interest__c);
            }
        }
    },    
    
    // 1. Logic to set Freight to '0' if selected value is FOB
    // 2. Fetch Business Rule of Sales Person (Selected User in case of SOM/SDM/Key Account) on Inco Term Change
    handleIncoTermChange : function(component, event, helper){
        var incoTerm = event.getParam("value").toString(); //component.get("v.incoTerm");
        
        if(incoTerm.includes("FOB")){
            component.set("v.businessRule.Freight__c", "0");
        }
        else{
            //Get Business Rule for Logged In user from helper method       
            var user = component.get("v.user"); 
            
            helper.fetchBusinessRule(component, user.Id);   
        }      
        var splitValues = incoTerm.split(",");
        component.set("v.newSalesOrder.Inco_Term__c", splitValues[1]);  
        //console.log("incoTerm split 1: "+splitValues[1]);
    },
	
    // Method to Show/Hide Additional Discount inputs if Payment Method = "Barter"
    handlePaymentMethodChange : function(component, event, helper){
        var paymentMethod = event.getParam("value"); //component.get("v.incoTerm");
        if(paymentMethod!='None'){
            var inputCmp = component.find("paymentMethodOptions");
            inputCmp.set("v.errors", null);
            $A.util.removeClass(inputCmp, "error");
        }
        //if(paymentMethod!='None'){
            component.set("v.newSalesOrder.PaymentMethod__c", paymentMethod);  //splitValues[1]);
            
			var opts = component.find("paymentMethodOptions").get("v.options");
            
            for(var i=0; i< opts.length; i++){
                var selectedValue = opts[i].value;
                var selectedLabel = opts[i].label;
                
                if(selectedValue==paymentMethod){
                    if(selectedLabel=='Barter'){
                        component.set("v.isBarter",true);
                    }
                    else{
                        component.set("v.isBarter",false);
                        component.set("v.newSalesOrder.Business_Discount__c",0);
                        component.set("v.newSalesOrder.Financial_Discount__c",0);
                    }                     
                    break;
                }
            }
            
        //}
    },
    
    // Method to show/hide SOM (Extra Fields) based on selected Order Type. 
    handleOrderTypeChange : function (component, event, helper) {
        // handle value change
        //console.log("old value (Order Type): " + JSON.stringify(event.getParam("oldValue")));
        //console.log("current value (Order Type): " + JSON.stringify(event.getParam("value")));
       /* if(event.getParam("oldValue")!=event.getParam("value")){
            var action = component.get("c.doInit");
            $A.enqueueAction(action); 
        }*/
        if(event.getParam("oldValue")!=event.getParam("value")){
            var orderType = component.get("v.orderType"); //event.getParam("value");
            helper.searchButtonFun(component);
            //component.set("v.selItem",null);
            component.set("v.newSalesOrder.Type_of_Order__c", orderType);
            if(orderType!='None'){
                var inputCmp = component.find("orderTypeOptions");
                inputCmp.set("v.errors", null);
                $A.util.removeClass(inputCmp, "error");
            }
            if(orderType == 'ORDEM FILHA'){
                //added by ganesh
                //var currentValue = component.get("v.selectedUser");
                //console.log('currentValue'+currentValue);
                //Fetch config/data for som component from helper method       
                //helper.fetchSOM(component,currentValue);
                 helper.fetchSOM(component);
                //fetch end
                component.set("v.isChild", true);
                component.set("v.disablePriceCurrency", true);
                component.set("v.disablePaymentMethod", true);
            }
            else{
                //Punctuality Discount Patch
                component.find("descNo").set("v.value","true");
                component.find("descYes").set("v.value","false");
                component.set("v.isPunctual","false");
                component.set("v.newSalesOrder.Punctuality_Discount__c", "");
                //component.set("v.newSalesOrder.Punctuality_Discount__c", 0);
                //End 
                
                component.set("v.isChild", false);
                component.set("v.disablePaymentMethod", false);
                component.set("v.disablePriceCurrency", false);
                
                // Set selected mother order to null
                component.set("v.selItem3", null);
                
                // Assign Mother Id in Sales Order to null
                component.set("v.newSalesOrder.Sales_Order__c", null);
            }
        }
                    
        // Fetch config/data for customers component from helper method    
        // added by ganesh 
        if(orderType!= 'ORDEM FILHA'){
        helper.fetchAccounts(component);
        }
        //desc :get business rule again if order type change
        var currentValue = component.get("v.selectedUser");
        if(currentValue && currentValue!='None'){
            helper.fetchBusinessRule(component, currentValue);
        }else{
            var userId = component.get("v.user.Id"); 
            helper.fetchBusinessRule(component, userId);
        }
        
    },   
    
    // Method to fetch Price Book Details based on Order Type. 
    handlePriceListChange : function (component, event, helper) {
        // handle value change
        //console.log("old value (PriceList): " + event.getParam("oldValue"));
        //console.log("current value (PriceList): " + event.getParam("value"));
        
        var currentValue = event.getParam("value"); //component.get("v.priceBookId"); 
        if(currentValue!='Select a price list'){
            var inputCmp = component.find("priceListOptions");
            inputCmp.set("v.errors", null);
            $A.util.removeClass(inputCmp, "error");
        }
        component.set("v.newSalesOrder.Price_Book__c", currentValue);
        
        if(currentValue){
            helper.fetchPriceBookDetails(component);
        }
        
    },
    
    // Method to populate Seller. 
    // Available for SOM/SDM/Key Account Seller & New Simulations.
    handleSellerChange : function (component, event, helper) {
         var TerritoryCode='';
     	 var TerritoryUser='';
         var selected='';
        // handle value change
        //console.log("old value (handleSellerChange): " + JSON.stringify(event.getParam("oldValue")));
        //console.log("current value (handleSellerChange): " + JSON.stringify(event.getParam("value")));
        
        var currentValue = component.get("v.selectedUser"); //event.getParam("value");
        var orderId = component.get("v.recordId");
        
        //console.log('orderId'+orderId);
        //console.log('currentValue-->'+currentValue);
        if(currentValue!=undefined){
            selected = currentValue.split("~~");
            TerritoryCode = selected[1];
            TerritoryUser = selected[0];
            //console.log('TerritoryCode--'+TerritoryCode+'selected'+TerritoryUser);
            component.set("v.newSalesOrder.TM_Code__c", TerritoryCode);
        }
        
        if(currentValue && currentValue!='None'){
           component.set("v.newSalesOrder.KeyAccountDesOwnerBrazil__c",TerritoryUser);
            //component.set("v.user.Id",currentValue); 
            helper.fetchBusinessRule(component, TerritoryUser);
            var inputCmp = component.find("sellerOptions");
            inputCmp.set("v.errors", null);
            $A.util.removeClass(inputCmp, "error");
        }
        //patch added by ganesh
        if(currentValue=='None'){
            component.set("v.newSalesOrder.KeyAccountDesOwnerBrazil__c", null);
         	//console.log('inside patchhandle selller');
            helper.fetchAccounts(component);
            
        }else{
            var isKeyAccount = component.get("v.newSalesOrder.Key_Account__c");
            //console.log("isKeyAccount: "+isKeyAccount);
            
            component.set("v.newSalesOrder.OwnerId", TerritoryUser);
          
            //added by ganesh
            //desc: if SDM logged-in and orderId is null then based on seller selection fetch account
            if(isKeyAccount!= true && currentValue!='' && currentValue!='None' && (!orderId)){
                 component.set("v.selItem",null); 
                 component.set("v.newSalesOrder.Sold_to_Party__c", null);
                 helper.fetchAccounts(component);
            }
            if(isKeyAccount || (currentValue!='' && currentValue!='None')){
                component.set("v.selItem",null);
                if(!orderId){
                // Assign null to accountId attribute
                //console.log("record ID"+orderId);
                component.set("v.newSalesOrder.Sold_to_Party__c", null);
                }
                // Fetch config/data for customers component from helper method        
                helper.fetchAccounts(component);
            }
            else{
                console.log("isKeyAccount false: Set Owner Id");
                component.set("v.newSalesOrder.OwnerId",TerritoryUser);
            }
        }
    }     
})