({
    CheckPOAvailability: function(component, event, helper) {
        var availPOList = component.get("v.poNoList");
        var target = event.getSource();  
        var inp = target.get("v.value");
        if(availPOList.indexOf(inp) != -1){
        var toastMsg =  $A.get("$Label.c.PO_number_Unique_Check");
            helper.showErrorToast(component, event, toastMsg); 
        }
    },
    
    normalUpdateRowCalculations: function(component, event, helper) {
    	helper.normalUpdateRowCalculations(component, event, helper);
    },
    searchField : function(component, event, helper) {
         component.set("v.selectedAcc", true);//CR#183 -Export Order Management – Chile- SKI- kalpesh chande -21-06-2023
        var currentText = event.getSource().get("v.value");
        var resultBox = component.find('resultBox');
        component.set("v.LoadingText", true);
        if(currentText.length > 0) {
            $A.util.addClass(resultBox, 'slds-is-open');
        }
        else {
            $A.util.removeClass(resultBox, 'slds-is-open');
        }
        var action = component.get("c.findByName");
        action.setParams({
            "searchKey" : currentText
        });
        
        action.setCallback(this, function(response){
            var STATE = response.getState();
            if(STATE === "SUCCESS") {
                component.set("v.searchRecords", response.getReturnValue());
                if(component.get("v.searchRecords").length == 0) {
                    console.log('000000');
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            component.set("v.LoadingText", false);
        });
        
        $A.enqueueAction(action);
    },
    
    setSelectedRecord : function(component, event, helper) {
        var currentText = event.currentTarget.id;
        var resultBox = component.find('resultBox');
        $A.util.removeClass(resultBox, 'slds-is-open');
         component.set("v.selectedAcc", false);//CR#183 -Export Order Management – Chile- SKI- kalpesh chande -06-06-2023
        //component.set("v.selectRecordName", currentText);
        component.set("v.selectRecordName", event.currentTarget.dataset.name);
        component.set("v.selectRecordId", currentText);
        component.find('userinput').set("v.readonly", true);
        component.set("v.recordId",currentText)
        window.setTimeout($A.getCallback(function() {helper.getOrderFields(component);}),2000 );
    }, 
    //uploading attachment 
    handleFilesChange : function(component, event, helper) {
         var file = component.find("fileId");
         var fileName = component.find("fileId").get("v.files");
         
            if(file.get("v.files") == null){
                flag = false;
                component.set("v.noFileError",false);
            	component.set("v.fileName",$A.get("Please select file"));
            }else{
               if(fileName[0].type.includes('/vnd.ms-excel') || fileName[0].type.includes('/pdf') || fileName[0].type.includes('spreadsheetml') ||fileName[0].type.includes('/png')){
                   component.set("v.noFileError",true);				           
                   component.set("v.fileName",fileName[0].name);
               }else{
                   component.set("v.noFileError",false);
                   component.set("v.fileName",$A.get("Please select Correct file"));
                    component.find("fileId").set("v.value", []);
               }
	      }
    },
    resetData : function(component, event, helper) {
        component.set("v.selectRecordName", "");
        component.set("v.selectRecordId", "");
        component.find('userinput').set("v.readonly", false);
         component.set("v.orderFields","");//CR#183 -Export Order Management – Chile- SKI- kalpesh chande -06-06-2023
        component.set("v.selectedAcc", false);
        //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -06-06-2023 -Start here
        component.set("v.paymentTermList", "");
        component.set("v.ShippingLocMap", "");
        component.set("v.paymentTerm", "");
        component.set("v.accPaymentTerm","");
        component.set("v.newSalesOrder.Inco_Term__c","");
        component.set("v.incoTermList", "");
        component.set("v.poNoList","");
        component.set("v.newSalesOrder.Payment_Term__c","");
        component.set("v.defaultTerm","");//Sayan
        component.set("v.orderTypeList",""); 
        component.set("v.newSalesOrder.Purchase_Order_no__c","");
        var orderItem = component.get("v.orderItemList");
        helper.deleteAllOrderItem(component, event, orderItem);
        if(orderItem.length>0){
            orderItem.splice(0, orderItem.length);   
        }
        component.set("v.orderItemList", orderItem);
       //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -06-06-2023-End here
    },
    // Init method to initalize default values in form on component load. 
    doInit: function(component, event, helper) {
        console.log('Sayan inside init');
        if(component.get("v.recordId") && component.get("v.recordPageFlag")){
            window.setTimeout($A.getCallback(function() {helper.getOrderFields(component);}),2000 );
        	
        }
        
        // alert(window.location.href);
        
    },
    
    changePODate :function(component, event,helper) {
        helper.getExchangeRate(component);
    },
    changeDeliveryDate :function(component, event,helper) {
        var target = event.getSource();  
        var orderItemList = component.get("v.orderItemList");
        var rowIndex = target.get("v.labelClass");
        var inp = target.get("v.value");
        if(inp == '' || inp< $A.localizationService.formatDate(new Date(), "YYYY-MM-DD")){
                    errorMessage=$A.get("$Label.c.Please_Select_Delivery_Date_Greater_Than_or_equal_to_Todays_date") ;//$A.get("$Label.c.Please_enter_Quantity");
                    target.set("v.errors", [{message:errorMessage}]);
                    $A.util.addClass(target, "error"); 
                    inp =  $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
                    target.set("v.value",inp);
                }else{
                    target.set("v.value",inp);
                    target.set("v.errors", null); 
                    $A.util.removeClass(target, "error");
                    helper.updateDraftOrder(component,event,orderItemList[rowIndex]);
                }
    },
    
    searchKeyChange: function(component, event) {
        var searchKey = component.find("searchKey").get("v.value");
        console.log('searchKey:::::'+searchKey);
        var action = component.get("c.findByName");
        action.setParams({
            "searchKey": searchKey
        });
        action.setCallback(this, function(a) {
            component.set("v.accounts", a.getReturnValue());
                   });
        if(a.getReturnValue().length>0){
                    component.set("v.openDropDown", true);
                }
        $A.enqueueAction(action);
    },
    
    changeCurrency : function(component, event, helper) {
        var curr = component.get("v.currencyList");
        var exchangeRate = component.get("v.exchangeRate");
        var orderItemList = component.get("v.orderItemList");
        for (var idx = 0; idx < orderItemList.length; idx++) {
            if(curr != orderItemList[idx].oiCurrency){
                if(curr == 'CLP'){
                    orderItemList[idx].minValue = orderItemList[idx].minValue*exchangeRate;
                	orderItemList[idx].oiCurrency ='CLP';
                	if(orderItemList[idx].unitCost!= undefined)
                	{
                    	orderItemList[idx].unitCost = orderItemList[idx].unitCost*exchangeRate;
                	}else{
                    	orderItemList[idx].unitCost =0;
                    }
                    
                	orderItemList[idx].maxPrice = orderItemList[idx].maxPrice*exchangeRate;
                    orderItemList[idx].unitValue = orderItemList[idx].unitValue*exchangeRate;
                    orderItemList[idx].netSales = orderItemList[idx].netSales*exchangeRate;
                }else{
                orderItemList[idx].minValue = orderItemList[idx].minValue/exchangeRate;
                	orderItemList[idx].oiCurrency ='USD';
                	if(orderItemList[idx].unitCost!= undefined)
                	{
                    	orderItemList[idx].unitCost = orderItemList[idx].unitCost/exchangeRate;
                	}else{
                    	orderItemList[idx].unitCost =0;
                    }
                    
                	orderItemList[idx].maxPrice = orderItemList[idx].maxPrice/exchangeRate;
                    orderItemList[idx].unitValue = orderItemList[idx].unitValue/exchangeRate;
                    orderItemList[idx].netSales = orderItemList[idx].netSales/exchangeRate;
                }
            }
        }
        component.set("v.orderItemList",orderItemList); 
        helper.updateAllItems(component, event,orderItemList);
    },
    fetchExchangeRate :function(component,event,helper){
        
        
    },
    //Method to validate Purchase Order No. has alpha numeric characters only.
    validatePO: function(component,event,helper){
        var target = event.getSource();  
        var inp = target.get("v.value");
        var letterNumber = /^[0-9a-zA-Z!@#\$%\^\&*\)\(+=._-]+$/;
        if((inp.match(letterNumber))){
            component.find("poNo").setCustomValidity("");
		}
        else{
            var errorMessage= $A.get("$Label.c.Purchase_Order_No_is_required_and_can_contain_only_characters_and_numbers");
            var setValue = ''; //inp.replace(/\W+/g, " ");
            component.find("poNo").setCustomValidity(errorMessage);
            target.set("v.value",setValue);
            }
        component.find("poNo").reportValidity();
    },
    // Logic to check if PO Date is valid
    restrictPODate: function(component,event,helper){
        var inputCmp = component.find("startDate");
        //var value = inputCmp.get("v.value");
        var value = component.get("v.newSalesOrder.Purchase_Order_Date__c");
        /* ----------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022------------------- */
        var tmpLogin = component.get("v.loginCountryObjs");
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        if(value){
            var x = new Date(value);
            /*if(value <= today){
                var msg = 'PO Date should be greater than today Date';
                helper.showErrorToast(component, event, msg);
                component.set("v.newSalesOrder.Purchase_Order_Date__c",null);
            }*/
        }
        helper.getExchangeRate(component);
        //inputCmp.reportValidity();
        /* -----------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022------------------- */
        //helper.getExchangeRate(component);
        
    },
    // Logic to hide all selection modals    
    closeDialog : function(component, event, helper) {
        helper.toggleDialog(component);
    },
    
    //Logic to hide all selection modals    
    closePopUp : function(component, event, helper) {
        helper.closePopUp(component);
    }, 
    
    //CR#169 -Chile Margin Block- kalpesh chande -SKI 05/12/2022 - Start Here
   
    handlecancel : function(component, event, helper) {
        console.log('No');
        component.set('v.isModalOpen', false);
    }, 
    handleYes : function(component, event, helper) {
        component.set('v.isModalOpen', false);
        component.set('v.isSimulationOrder', false);
        component.set("v.isDraft", false);
        helper.createSalesOrder(component, event, "Submitted");
        

    }, 
    //CR#169 -Chile Margin Block- kalpesh chande - SKI- 05/12/2022 - End Here
    
    
    //Logic to show confirmation dialog with Simulation Flag & Message on Save and Submit.
    openConfirmDialog : function(component, event, helper) {
        var selected = event.getSource().get("v.label");
        /* --------------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022---------- */
        var PODate = component.get("v.newSalesOrder.Purchase_Order_Date__c");
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        var msg ='Please select PO Date greater than today'; 
        var loginShowPO = component.get("v.loginCountryObjs");
        /*if(PODate<=today){
             helper.showErrorToast(component, event, msg);
            
        }else */
        /* -----------------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022---------- */
        if(selected=="Confirm" || selected=="Confirmación"){
            component.set("v.isDraft", false);
            helper.createSalesOrder(component, event, "Submitted");
        }
        
    },
    
    // Method used to Download SalesOrder PDF (Calls visualforce page)
    renderedPDF:function(component, event, helper){
        var recordId = component.get('v.sOId');
        window.open('/apex/SalesOrderCol_pdf?id1='+recordId);
    },
    
    
    // Method use to enable Editing of Order Form using 'Edit' button 
    // Enabled when order status is 'Draft/Rejected'
    editForm : function(component, event, helper) {
        helper.editForm(component);
    },
    
    
   
    deleteAllItems:function(component,event,helper){
        var orderItem = component.get("v.orderItemList");
        helper.deleteAllOrderItem(component, event, orderItem);
        if(orderItem.length>0){
            orderItem.splice(0, orderItem.length);   
        }
        component.set("v.orderItemList", orderItem);
    },
    
    //handle business type change
    handleBusinessChange: function(component,event,helper){
        var businessTypes = component.get("v.businessTypesList");
        var target = event.getSource();  
        var rowIndex = component.get("v.rowIndex");
        //alert('rowIndex>>--->'+rowIndex);
        var orderItemList = component.get("v.orderItemList");
        var mtpParamObj =component.get("v.adminMPTParam");
        var initialPosition =rowIndex;
        var rowLimit =0;
        var flag =false;
        var flag1 =false;
        var msg ='';
        //   alert(JSON.stringify(mtpParamObj));
        if(mtpParamObj){
            rowLimit =  mtpParamObj.Max_no_of_prod_asso_with_initial_product__c;
        }
        //patch for 1st record on mobile type initial Product
        orderItemList[0].typeOfBusiness = 'Producto Inicial';  
        //alert('orderItemList>>-->'+JSON.stringify(orderItemList));
        component.set("v.orderItemList",orderItemList);
        
        orderItemList = component.get("v.orderItemList");
        for (var idx=0; idx < orderItemList.length; idx++) {
            if (idx==rowIndex){
                
                if(idx!=0){
                    component.find("itemqty")[idx].set("v.value",'0');    
                }
                if(target.get("v.value") == "Impacto Producto" || target.get("v.value") == 'Impacto Negocio'){
                    component.find("itemunitvalue")[idx].set("v.disabled",true);
                    if(target.get("v.value") == "Impacto Producto"){
                        console.log(idx+' - '+rowIndex);
                        for (var idx1=rowIndex; idx1 >=0; idx1--) {
                            if(orderItemList[idx1].typeOfBusiness=='Producto Inicial'){
                                initialPosition =idx1;
                                break;
                            }
                        }
                        // console.log(initialPosition+'- - '+rowLimit);
                        if(rowIndex-initialPosition>rowLimit){
                            component.find("itemproduct")[idx].set("v.errors",[{message:"Product Impact Limit exceeded"}]); 
                            flag = true;
                            msg = $A.get("$Label.c.Product_Impact_Limit_exceeded");
                            orderItemList[idx].productName='';
                            component.find("maxPric")[idx].set("v.value",0); 
                            orderItemList[idx].qty =0;
                        }else
                            if(orderItemList[initialPosition].productId != orderItemList[initialPosition+1].productId){
                                
                                if(initialPosition+1!=rowIndex){
                                    for (var idx1=rowIndex; idx1 >initialPosition; idx1--) {
                                        if(orderItemList[idx1].productId==orderItemList[initialPosition].productId){
                                            component.find("itemproduct")[rowIndex].set("v.errors",[{message:$A.get("$Label.c.You_cannot_add_initial_Product_again")}]); 
                                            flag = true;
                                            msg = $A.get("$Label.c.You_cannot_add_initial_Product_again");
                                            orderItemList[rowIndex].productName='';
                                            component.find("maxPric")[idx].set("v.value",0);  
                                            orderItemList[idx].qty =0;
                                            break;
                                        }
                                    }
                                }
                            }
                            else if(orderItemList[idx].productId != orderItemList[initialPosition].productId){
                                component.find("itemproduct")[idx].set("v.errors",[{message:$A.get("$Label.c.You_cannot_add_a_Different_Product")}]); 
                                flag = true;
                                msg = $A.get("$Label.c.You_cannot_add_a_Different_Product");
                                orderItemList[idx].productName='';
                                component.find("maxPric")[idx].set("v.value",0); 
                                orderItemList[idx].qty =0;
                            }else{
                                flag = false;
                                console.log('no error');
                                component.find("itemproduct")[idx].set("v.errors",null);  
                            }
                    } 
                    //Desc:if adding product impact right after business Impact
                    if(target.get("v.value") == "Impacto Producto"){
                        
                        for (var idx1=rowIndex; idx1 >initialPosition; idx1--) {
                            //console.log(orderItemList[idx1].typeOfBusiness);
                            if(orderItemList[idx1].typeOfBusiness=='Impacto Negocio'){
                                component.find("itemproduct")[rowIndex].set("v.errors",[{message:"Please Add Initial Product first"}]); 
                                flag1 = true;
                                msg ="Please Add Initial Product first";
                                orderItemList[rowIndex].productName='';
                                component.find("maxPric")[idx].set("v.value",0); 
                                orderItemList[idx].qty =0;
                                break;
                            }else{
                                flag1 = false;
                                component.find("itemproduct")[idx].set("v.errors",null);  
                            }
                        }
                    }
                    
                    if(flag || flag1 ){
                        helper.showErrorToast(component, event, msg);
                        
                    }
                    else{
                        //component.find("itemunitvalue")[idx].set("v.value",0);
                        //component.find("itemunitvalue")[idx].set("v.errors",null); 
                        //component.find("itemunitvalue")[idx].set("v.disabled",true);  
                        orderItemList[idx].netSales ='';
                        orderItemList[idx].netPrice ='';
                        
                    }
                }else{
                    component.find("itemunitvalue")[idx].set("v.disabled",false);  
                }
            }  
        }
        
    },
    //Replace Negative Sign from Quantity Input
    restrictQuantity: function(component, event, helper){
        
        var target = event.getSource(); 
        var currentidx = target.get("v.requiredIndicatorClass");
        var qty = target.get("v.value");
        var rowIndex = component.get("v.rowIndex");
        var setValue = null;
        var flag = false;
        var errorMessage = '';
        
        if(qty){
            var multipleOf = target.get("v.placeholder");
            if(multipleOf && (qty%multipleOf != 0)){
                console.log('multipleOf'+multipleOf+'--'+qty);
                flag = true;
                errorMessage= $A.get("$Label.c.Qty_should_be_in_multiple_of")+" "+multipleOf;
                target.set("v.errors", [{message:errorMessage}]);
                $A.util.addClass(target, "error");
            }else{     
            target.set("v.errors", null); 
            $A.util.removeClass(target, "error");
            helper.normalUpdateRowCalculations(component, event, helper);
        }         
    }else{
    errorMessage= $A.get("$Label.c.Please_enter_Quantity");
    target.set("v.errors", [{message:errorMessage}]);
$A.util.addClass(target, "error");
helper.normalUpdateRowCalculations(component, event, helper); 
}         

},
    
    handleOrderTypeChange : function(component, event, helper){ 
        var target = event.getSource();
        if(target.value !='None'){
            component.find("OrderTypeOptions").set("v.errors",null);                    
            $A.util.removeClass(component.find("OrderTypeOptions"), "error");
        }else{
            component.find("OrderTypeOptions").set("v.errors",[{message: $A.get("$Label.c.Please_select_order_type")}]);  
            $A.util.addClass(component.find("OrderTypeOptions"), "error");
            var toastMsg =  $A.get("$Label.c.Please_select_order_type");
            helper.showErrorToast(component, event, toastMsg);  
        }    
    },
        // Logic to update current row with calculations
        updateTableRow : function(component, event, helper) {
            
            var target = event.getSource();  
            var qty = target.get("v.value");
            var currentidx = target.get("v.requiredIndicatorClass");
            console.log('currentidx>>--->'+currentidx);
            component.set("v.currentIndex",currentidx);
            var setValue = null;
            var flag = false;
            var errorMessage = '';
            console.log('qty'+qty);
            if(qty){
                flag = false;
                var qtyString = qty.toString(); //Convert to string
                
                if(qtyString.includes('.')){
                    errorMessage=$A.get("$Label.c.Only_number_allowed");//$A.get("$Label.c.Please_enter_Quantity");
                    target.set("v.errors", [{message:errorMessage}]);
                    $A.util.addClass(target, "error");
                    qtyString =  qtyString.replace('.','');
                    target.set("v.value",qtyString);
                }else if(qtyString.includes(',')){
                    errorMessage=$A.get("$Label.c.Only_number_allowed") ;//$A.get("$Label.c.Please_enter_Quantity");
                    target.set("v.errors", [{message:errorMessage}]);
                    $A.util.addClass(target, "error"); 
                    qtyString =  qtyString.replace(',','');
                    target.set("v.value",qtyString);
                }else{
                    qtyString = qtyString.replace(',','');
                    qtyString = qtyString.replace('.','');
                    qtyString = qtyString.replace('-','');
                    qtyString = qtyString.replace(/[^a-zA-Z0-9]/,'');
                    qtyString = qtyString.replace(/([a-zA-Z ])/g,'');
                    console.log(qtyString+'==='+qtyString);
                    target.set("v.value",qtyString);
                    target.set("v.errors", null); 
                    $A.util.removeClass(target, "error");
                    helper.updateRowCalculations(component, event, helper); 
                }
            }else{
                errorMessage= $A.get("$Label.c.Please_enter_Quantity");
                target.set("v.errors", [{message:errorMessage}]);
                $A.util.addClass(target, "error");
            }
        },
            normalUpdateTableRow : function(component, event,helper){
                var target = event.getSource();  
                var unitValue = target.get("v.value");
               var prsntValue = 0 ;
                var setBlank = 0;
                var currentidx = target.get("v.labelClass");
                var errorMessage = '';
                
                if(unitValue) {
                    //var unitValueFixed  = unitValue.toFixed(2);
                    var unitValueFixed  = unitValue;
                    target.set("v.value",unitValueFixed);
                    target.set("v.errors", null);
                    $A.util.removeClass(target, "error");
                    helper.normalUpdateRowCalculations(component, event, helper);
                }else{
                    errorMessage= $A.get("$Label.c.Please_enter_Final_Price");
                    target.set("v.errors", [{message:errorMessage}]);
                    $A.util.addClass(target, "error");
                    helper.normalUpdateRowCalculations(component, event, helper);
                }
                
            },
   /* changePaymentTerm :function(component, event,helper){
        var payTerm = component.get("v.paymentTerm");
        var action = component.get("c.changePaymentTerm");
        if(payTerm!=null){
            action.setParams({
                payTerm: payTerm
            });
        }
        action.setCallback(this, function(a) {
            
            // on call back make it false ,spinner stops after data is retrieved
            component.set("v.showSpinner", false); 
            // console.log('returnValue: '+JSON.stringify(returnValue));
            var state = a.getState();
            
            if (state == "SUCCESS") {
                var returnValue = a.getReturnValue();
                component.set("v.orderFields",returnValue);
            }
        }
        component.set("v.newSalesOrder.Payment_Term__c");
    },*/
    
                //DIVYA: 16-01-2020: Added new section for SCTASK0102624-Colombia MPT Order Final Price Change
                MPTUpdateTableRow : function(component, event,helper){
                    var target = event.getSource();  
                    var unitValue = target.get("v.value");
                    var maxPrice = target.get("v.requiredIndicatorClass");
                    var prsntValue = 0 ;
                    var setBlank = 0;
                    var rowIndex = component.get("v.rowIndex");
                    var errorMessage = '';
                    if(unitValue && unitValue > 0) {
                        //var unitValueFixed  = unitValue.toFixed(2);
                        
                        var unitValueFixed  = unitValue;
                        target.set("v.value",unitValueFixed);
                    }else{
                        errorMessage= $A.get("$Label.c.Please_enter_Final_Price");
                        target.set("v.errors", [{message:errorMessage}]);
                        $A.util.addClass(target, "error");
                        helper.updateRowCalculations(component, event, helper);
                    }
                    if(unitValue) {
                        if(maxPrice > unitValue){
                            helper.showErrorToast(component, event, $A.get("$Label.c.Final_Price_isn_t_allowed"));
                            //target.set("v.errors", [{message: $A.get("$Label.c.Final_Price_isn_t_allowed")}]);
                            target.set("v.value",'0');
                            //$A.util.addClass(target, "error");  
                            //console.log('forderminValue'+minValue);
                            console.log('prsntValue'+prsntValue);
                        } 
                        else{
                            target.set("v.errors", null); 
                            $A.util.removeClass(target, "error");
                            helper.updateRowCalculations(component, event, helper);
                        }
                    }  
                },
                    
                    // Logic to handle shipping changs 
                    handleShipLocChange : function(component, event,helper){
                        var target = event.getSource(); 
       					var rowIndex = target.get("v.labelClass");
                        //var rowIndex = component.get("v.rowIndex");
                        var shippingLoc = component.find("shippListOptions");
                        if(component.find("shippListOptions").length>1){
                            shippingLoc = component.find("shippListOptions")[rowIndex];
                        }else{
                        	shippingLoc = component.find("shippListOptions");
                        }
                        var orderItemList = component.get("v.orderItemList");
                        if(orderItemList[rowIndex].deliveryAddress == "None"){
                            shippingLoc.set("v.errors",[{message: $A.get("$Label.c.Please_Select_shipping_location")}]);
                            $A.util.addClass(shippingLoc, "error");
                            
                        }else{
                            shippingLoc.set("v.errors", null);
                            $A.util.removeClass(shippingLoc, "error");
                        }
                        helper.updateDraftOrder(component,event,orderItemList[rowIndex]);
                    }, 
                        
                        
                        //uploading attachment 
                        handleFilesChange : function(component, event, helper) {
                            var file = component.find("fileId");
                            var fileName = component.find("fileId").get("v.files");
                            
                            if(file.get("v.files") == null){
                                flag = false;
                                component.set("v.noFileError",false);
                                component.set("v.fileName",$A.get("Please select file"));
                            }else{
                                if(fileName[0].type.includes('/vnd.ms-excel') || fileName[0].type.includes('/pdf') || fileName[0].type.includes('spreadsheetml') ||fileName[0].type.includes('/png')){
                                    component.set("v.noFileError",true);				           
                                    component.set("v.fileName",fileName[0].name);
                                }else{
                                    component.set("v.noFileError",false);
                                    component.set("v.fileName",$A.get("Please select Correct file"));
                                    component.find("fileId").set("v.value", []);
                                }
                            }
                        },
                            
                            // Logic to show Product Selection Modal        
                            openPriceDeatilsPopUp : function(component, event, helper) {
                                var target = event.getSource();  
                                var rowIndexValue = target.get("v.value");
                                console.log('rowIndexValue>>--->'+rowIndexValue);
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
                                    
                                    
                                    // Logic to Add Order Line Item 
                                    addTableRow : function(component, event, helper){
                                        console.log('inside');
                                        component.set("v.validCodeCounter",0);
                                        var isValid = helper.validateOrder(component); 
                                        console.log('isValid>>--->'+isValid);
                                        var isValidItems = helper.validateOrderItems(component);
                                        var LastValue =0;
                                        var orderItemList = component.get("v.orderItemList");
                                        console.log('Test AddTable Row:-'+orderItemList);
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
                                        console.log('flag'+flag);
                                        console.log('orderItemList.length'+orderItemList.length);
                                        
                                        //If all validations are successful add new row
                                        if(flag){
                                            /* ---Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022---- */
                                            const today = new Date()
                                            let tomorrow =  new Date()
                                            tomorrow.setDate(today.getDate() + 1)
                                            /* ---End SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022--- */
                                            orderItemList.push({
                                                productId:"",
                                                priceBookDetailId: "",
                                                productName:"", 
                                                qty:"0", 
                                                unitValue:"0", 
                                                discount:"0",
                                                discount_percent:"0",
                                                profit:"0",
                                                netSales:"0",
                                                netPrice:"0",
                                                margin:"0",
                                                netMargin:"0",
                                                unitValueWithInterest:"0",
                                                totalValue:"0", 
                                                totalValueWithInterest:"0",
                                                interestRate:"0", 
                                                days: "0", 
                                                timeInMonths: "0",
                                                deliveryAddress : "",		
                                                deliveryDate : $A.localizationService.formatDate(tomorrow, "YYYY-MM-DD") // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022
                                            });
                                             console.log('orderItemList@@@@'+orderItemList);
                                            component.set("v.orderItemList",orderItemList);
                                        }
                                        else{
                                            var toastMsg = $A.get("$Label.c.Please_provide_valid_input_fill_all_the_mandatory_fields_before_proceeding");
                                            helper.showErrorToast(component, event, toastMsg);
                                        }
                                    },
                                        
                                        normalremoveTableRow : function(component, event, helper) {
                                            var target = event.getSource();  
                                            var index = event.getSource().get("v.rowIndex");
                                            var items = component.get("v.orderItemList");   
                                            var soId = component.get("v.sOId");
                                            if(index>=0){	
                                                items.splice(index, 1);   
                                            }
                                            component.set("v.orderItemList", items);
                                            helper.deleteOrderItem(component, event, index);
                                            helper.normalUpdateRowCalculations(component, event, helper);
                                        },
                                             
                                            // Logic to remove Order Line Item
                                            removeTableRow : function(component, event, helper) {
                                                var target = event.getSource();  
                                                var index = target.get("v.value");
                                                var items = component.get("v.orderItemList");    
                                                var soId = component.get("v.sOId");
                                                console.log('index'+index);
                                                
                                                if(items.length<=2 && items.length!=1){  
                                                    component.find("deleteBtn")[0].set("v.disabled",false); 
                                                }
                                                
                                                //logic to delete row associated with initial product
                                                console.log('items[index].productId'+items[index].productId);
                                                if( index != items.length - 1 && items[index].typeOfBusiness=='Producto Inicial' && items[index].productId!=null && items[index].productId!=''){
                                                    for (var idx1=index+1; idx1<=items.length; idx1) {
                                                        console.log('inside loop'+idx1);
                                                        if(items[idx1]!=undefined){
                                                            console.log('inside loop2'+items[idx1]);
                                                            if(items[idx1].typeOfBusiness=='Impacto Producto'){
                                                                // component.set(items[idx1].typeOfBusiness,null);
                                                                component.set("v.businessTypesList", null);
                                                                items.splice(idx1, 1);  
                                                                component.set("v.businessTypesList", component.get("v.businessTypesListCopy"));     
                                                            }else{break;}
                                                        }else{break;}
                                                    }
                                                }
                                                //logic end
                                                if(index == items.length - 1){
                                                    console.log('if index'+index);
                                                    component.set("v.businessTypesList", null);
                                                    items.splice(index, 1);
                                                    component.set("v.businessTypesList", component.get("v.businessTypesListCopy"));     
                                                }
                                                else{
                                                    console.log('else index'+index);
                                                    items.splice(index, 1);
                                                }
                                                /*for(var idx=0;items.length;idx++){
           items.itemNo = idx; 
        }*/
        
        //console.log(JSON.stringify(items));
        component.set("v.orderItemList", items);
        var orderItem = component.get("v.orderItemList");    
        if(orderItem.length==1){ 
            console.log('orderItem.length'+orderItem.length);
            // component.find("deleteBtn")[0].set("v.disabled",true); 
        }
        if(orderItem.length==0){
            if(soId==null || soId==undefined){
                component.find("OrderTypeOptions").set("v.disabled",false); 
            }
        }
        helper.updateRowCalculations(component, event, helper);
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
                // console.log('');
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
                    if (state == "SUCCESS") {
                        var returnValue = JSON.stringify(a.getReturnValue());
                        component.set("v.approvalList",a.getReturnValue());
                        
                        var enableApproval = component.get("v.approvalList.enableApproval");
                        component.set("v.showApproveReject", enableApproval);
                        console.log('component.get("v.sOId")'+component.get("v.sOId"));
                        helper.gotoURL(component, component.get("v.sOId"));
                    }	
                });
                helper.toggleDialog(component);
                $A.enqueueAction(action);
            }
        },
    //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023-Start here
    orderTypeChange: function(component,event,helper) {
        console.log('inside ot');
        helper.fetchSKUData(component,event);
        var orderItem = component.get("v.orderItemList");
        helper.deleteAllOrderItem(component, event, orderItem);
        if(orderItem.length>0){
            orderItem.splice(0, orderItem.length);   
        }
        component.set("v.orderItemList", orderItem);
    }
    //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -28-03-2023 -End here
})