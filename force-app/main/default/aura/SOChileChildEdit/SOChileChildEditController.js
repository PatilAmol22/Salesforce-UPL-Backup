({
    doInit : function(component, event, helper) {
        helper.fetchLoginCountry(component, event, helper); // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022
        console.log(component.get("v.rowIndex"));
        var ShippingLocMap = component.get("v.ShippingLocMap");
        var opts=[];  
        //opts[0] = 'None';
        var j = 0;
        for(var key in ShippingLocMap ){
            opts[j] = key;
            j++;
        }
        component.set("v.shippingOptions",opts);
        component.find("priceDetailsTable").initialize({
            "order":[0,"desc"],
            "itemMenu":["5","10","25","50"],
            "itemsPerPage:":5                    
        });
        
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
            console.log('Place Holder:-'+multipleOf);
            if(multipleOf && (qty%multipleOf != 0)){
                console.log('multipleOf'+multipleOf+'--'+qty+'----'+qty%multipleOf);
                flag = true;
                errorMessage= $A.get("$Label.c.Qty_should_be_in_multiple_of")+" "+multipleOf;
                target.set("v.errors", [{message:errorMessage}]);
                $A.util.addClass(target, "error");
            }else{     
                target.set("v.errors", null); 
                $A.util.removeClass(target, "error");
                var UpdateRows = component.getEvent("UpdateRows");
                UpdateRows.setParams({
                    rowIndex : component.get("v.rowIndex")
                });
                UpdateRows.fire();
                //helper.normalUpdateRowCalculations(component, event, helper);
            }         
        }else{
            errorMessage= $A.get("$Label.c.Please_enter_Quantity");
            target.set("v.errors", [{message:errorMessage}]);
            $A.util.addClass(target, "error");
            var UpdateRows = component.getEvent("UpdateRows");
            UpdateRows.setParams({
                rowIndex : component.get("v.rowIndex")
            });
            UpdateRows.fire();
            //helper.normalUpdateRowCalculations(component, event, helper); 
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
            //helper.normalUpdateRowCalculations(component, event, helper);
            var UpdateRows = component.getEvent("UpdateRows");
            UpdateRows.setParams({
                rowIndex : component.get("v.rowIndex")
            });
            UpdateRows.fire();
        }else{
            errorMessage= $A.get("$Label.c.Please_enter_Final_Price");
            target.set("v.errors", [{message:errorMessage}]);
            $A.util.addClass(target, "error");
            //helper.normalUpdateRowCalculations(component, event, helper);
            var UpdateRows = component.getEvent("UpdateRows");
            UpdateRows.setParams({
                rowIndex : component.get("v.rowIndex")
            });
            UpdateRows.fire();
        }
        
    },
    // Logic to handle shipping changs 
                    handleShipLocChange : function(component, event,helper){
                        var target = event.getSource(); 
       					//var rowIndex = target.get("v.labelClass");
                        var rowIndex = component.get("v.rowIndex");
                        var shippingLoc = component.find("shippListOptions");
                        var orderItem = component.get("v.orderItem");
                        if(orderItem.deliveryAddress == "None"){
                            //shippingLoc.set("v.messageWhenValueMissing",$A.get("$Label.c.Please_Select_shipping_location") );
                            shippingLoc.set("v.validity","false");
                            
                        }else{
                            shippingLoc.set("v.validity","true");
                            target.set("v.messageWhenValueMissing", "");
                            }
                        //helper.updateDraftOrder(component,event,orderItem);//CR#174 -Chile Margin Block-SKI- kalpesh chande - 23/01/2023 
                        component.find("shippListOptions").showHelpMessageIfInvalid();
                    }, 
    validateItem: function(component, event, helper){
        var getProductId = component.find("normalitemproduct");
        var getQtyId = component.find("normalitemqty");
        var getFinalPrice = component.find("normalitemunitvalue");
        var getShippingAddress = component.find("shippListOptions");
        var validCodeCounter = component.get("v.validCodeCounter");
        var flag = true;
        if(!getProductId.get("v.value")) {
            flag = false;
            component.find("normalitemproduct").setCustomValidity($A.get("$Label.c.Product_is_required"));                
        }
        else{
            component.find("normalitemproduct").setCustomValidity("");
        }  
        
        if(!getQtyId.get("v.value") || getQtyId.get("v.value") == '0') {
            flag = false;
            component.find("normalitemqty").set("v.errors",[{message: $A.get("$Label.c.Please_enter_Quantity")}]);  
        }
        else{
            component.find("normalitemqty").set("v.errors",null);
        }
        if(getFinalPrice){
            if((!getFinalPrice.get("v.value")  || getFinalPrice.get("v.value") == '0')){
                console.log("inside Final Price"+getFinalPrice);
                flag = false;
                component.find("normalitemunitvalue").set("v.errors",[{message: $A.get("$Label.c.Please_enter_Final_Price")}]);
                
            }
            else{
                component.find("normalitemunitvalue").set("v.errors",null); 
            }
        }
        if(!getShippingAddress.get("v.value") || getShippingAddress.get("v.value") == 'None') {
            flag = false;
            getShippingAddress.set("v.validity","false");
            component.find("shippListOptions").showHelpMessageIfInvalid();
        }
        else{
            getShippingAddress.set("v.validity","true");
            component.find("shippListOptions").showHelpMessageIfInvalid();
        }
        if(flag==true){
            validCodeCounter++;
        }
        component.set("v.validCodeCounter",validCodeCounter);
        var controlAuraIds = ["normalitemproduct"];
        let isAllValid = controlAuraIds.reduce(function(isValidSoFar, controlAuraId){
           //fetches the component details from the auraId
            var inputCmp = component.find(controlAuraId);
           //displays the error messages associated with field if any
            inputCmp.reportValidity();
           //form will be invalid if any of the field's valid property provides false value.
            return isValidSoFar && inputCmp.checkValidity();
        },true);
        
    },
    //Logic to hide all selection modals    
    closePopUp : function(component, event, helper) {
        helper.closePopUp(component);
    },
    tabActionClicked: function(component, event, helper){
        //to change in CLP
        var uomFlag=false; //CR#174 -Chile Margin Block -SKI- kalpesh chande - 06/01/2023
        var currency = component.get("v.currencyList");
        var exchangeRate = component.get("v.exchangeRate");
        //get the id of the action being fired
        var actionId = event.getParam('actionId');
        var orderItem = component.get("v.orderItem");
        //get the row where click happened and its position
        var itemRow = event.getParam('row');
        console.log('itemRow'+JSON.stringify(itemRow));
        console.log('Test OrderItem:-'+JSON.stringify(orderItem));
        console.log('child Test OrderItemList:-'+JSON.stringify(component.get('v.orderItemList')));
        //CR#174 -Chile Margin Block -SKI- kalpesh chande - 06/01/2023  - Start Here..Existing code is added into if else condition....
        //var action;
        var skuId=itemRow.skuId;
        console.log("skuUomId "+skuId);
        console.log("itemRow.skuId "+itemRow.skuId);
        var action2=component.get("c.checkUom");
        action2.setParams({
                "skuId": skuId
            });
         
        action2.setCallback(this, function(a) {
                var state = a.getState();
                console.log("state() "+itemRow.UOM);
                console.log("a.getReturnValue() "+a.getReturnValue());
                if(state == "SUCCESS") {
                    var uomCheckList=a.getReturnValue();
                     for (var i=0; i < uomCheckList.length; i++){
                        console.log('idx '+uomCheckList[i]);
                          console.log('idx.Base_UOM__c '+uomCheckList[i].Base_UOM__c);
                          console.log('idx.Sales_UOM__c '+uomCheckList[i].Sales_UOM__c);
                         if(itemRow.UOM == uomCheckList[i].Base_UOM__c){
                            console.log('inside true 1');
                             uomFlag=true;
                             break;
                         }else if(itemRow.UOM != uomCheckList[i].Base_UOM__c && itemRow.UOM == uomCheckList[i].Sales_UOM__c){
                             console.log('inside true 2');
                             uomFlag=true;
                             break;
                         }else if(itemRow.UOM == uomCheckList[i].Base_UOM__c && itemRow.UOM == uomCheckList[i].Sales_UOM__c){
                             console.log('inside true 3');  
                             uomFlag=true;
                               break;
                         }else if(itemRow.UOM != uomCheckList[i].Base_UOM__c && itemRow.UOM != uomCheckList[i].Sales_UOM__c){
                             console.log('inside false');
                             uomFlag=false;
                         }
                     }
                    if(uomFlag){
                        // ...Existing code start .....

        if(actionId == 'selectproduct'){
            if(currency =='CLP'){
                orderItem.productId = itemRow.skuId;
                orderItem.productName = itemRow.skuDescription;
                orderItem.UOM = itemRow.UOM;
                orderItem.productCode = itemRow.skuCode;
                orderItem.itemNo =component.get("v.rowIndex");// itemRow.itemNo;
                orderItem.minValue = itemRow.minValue*exchangeRate;
                orderItem.multipleOf = itemRow.multipleOf;
                orderItem.oiCurrency ='CLP';
                console.log('itemRow.itemNo>>--->'+itemRow.itemNo);
                if(itemRow.unitCost!= undefined)
                {
                    orderItem.unitCost = itemRow.unitCost*exchangeRate;
                }else{
                    orderItem.unitCost =0;
                }
                if(itemRow.maxPrice!=0){
                    orderItem.qty = 0;
                  //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -14-06-2023 -Start here
                    orderItem.netSales=0;
                    orderItem.unitValue =0;
                  //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -14-06-2023 -End here             
                }
                orderItem.maxPrice = itemRow.maxPrice*exchangeRate;
            }
            else{
                orderItem.productId = itemRow.skuId;
                orderItem.productName = itemRow.skuDescription;
                orderItem.UOM = itemRow.UOM;
                orderItem.productCode = itemRow.skuCode;
                orderItem.itemNo =component.get("v.rowIndex");// itemRow.itemNo;
                orderItem.minValue = itemRow.minValue;
                orderItem.multipleOf = itemRow.multipleOf;
                orderItem.oiCurrency ='USD';
                if(itemRow.unitCost!= undefined)
                {
                    orderItem.unitCost = itemRow.unitCost;
                }else{
                    orderItem.unitCost =0;
                }
                if(itemRow.maxPrice!=0){
                    orderItem.qty = 0;
                  //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -14-06-2023 -Start here
                    orderItem.netSales=0;
                    orderItem.unitValue =0;
                  //CR#183 -Export Order Management – Chile- SKI- kalpesh chande -14-06-2023 -End here             
                }
                orderItem.maxPrice = itemRow.maxPrice;
            }
            component.set("v.disableThis","false");
           // helper.updateDraftOrder(component,event,orderItem);//CR#174 -Chile Margin Block-SKI- kalpesh chande -  23/01/2023 
        }
        
        
        //console.log('orderItemList'+JSON.stringify(orderItemList));
        component.set('v.orderItem', orderItem);
        helper.closePopUp(component);
        if(!component.find("normalitemproduct").get("v.value")){
        component.find("normalitemproduct").setCustomValidity($A.get("$Label.c.Product_is_required"));                
        }
        else{
            component.find("normalitemproduct").setCustomValidity("");
        } 
        component.find("normalitemproduct").reportValidity();
             // ...Existing code End .....
                    }
                    else {
                        alert($A.get("$Label.c.UOM_Not_Match"));
                        //console.log('alert');
                        /*var toastEvent2 = $A.get("e.force:showToast");
                        toastEvent2.setParams({
                            title: $A.get("$Label.c.Error"),
                            type: 'Error',
                            message: $A.get("$Label.c.UOM_Not_Match")
                        });
                        
                       toastEvent2.fire();*/
                    }
                
                }
                else{
                     alert($A.get("$Label.c.Failed_To_Get_UOM_Converion_Data"));
                  /*  var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": $A.get("$Label.c.Error"),
                            "message":$A.get("$Label.c.Failed_To_Get_UOM_Converion_Data"),
                            "type":"error"
                        });
                        toastEvent.fire();*/
                }
             });
        $A.enqueueAction(action2);
        //CR#174 -Chile Margin Block -SKI- kalpesh chande - 06/01/2023  - End Here
    },
    changeDeliveryDate :function(component, event,helper) {
        var target = event.getSource();  
        var errorMessage;
        var orderItem = component.get("v.orderItem");
        var newSO = component.get("v.newSalesOrder");
        var accId = component.get("v.recordId");
        console.log('NTest New SO:-'+JSON.stringify(newSO));
        var inp = target.get("v.value");
        console.log('Test inp:-'+inp);
        console.log('Test Address :-'+JSON.stringify(orderItem));
        /* ----------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022----------- */
        const today = new Date();
        let tomorrow =  new Date();
        tomorrow.setDate(today.getDate() + 1);
        var tmrro = $A.localizationService.formatDate(tomorrow, "YYYY-MM-DD")
        var loginCountry = component.get("v.loginCountryObjs");
        if(loginCountry.Delivery_Date__c==true && inp==null){
            alert('Customer Delivery Date Should not empty and Greater than todays Date');
             target.set("v.value",tmrro);
        }else{	
            if(inp<= $A.localizationService.formatDate(new Date(), "YYYY-MM-DD")){
                alert('Customer Delivery Date should be greater than todays date');
                target.set("v.value",tmrro);
            }else{
               
                if(orderItem.SOILID != null ){
                    console.log('Test Order Id date:-'+JSON.stringify(component.get("v.orderItem")));
                      target.set("v.value",inp);
                     component.find("delDate").setCustomValidity("");
                     var orderItemd = component.get("v.orderItem");
                    var action = component.get("c.updateSOLIDate");
                    action.setParams({"salesOrderItemString" : JSON.stringify(orderItemd),
                                      "accountId" : accId});
                    action.setCallback(this,function(a){
                        var state = a.getState();
                        console.log('Test Change State:-'+state);
                        if(state === 'SUCCESS'){
                            console.log('Test State:-'+state);
                        }
                    });
                    $A.enqueueAction(action);
                    
                }else{
                     target.set("v.value",inp);
                //helper.updateDraftOrder(component,event,orderItem);//CR#174 -Chile Margin Block-SKI- kalpesh chande -  23/01/2023 
                    component.find("delDate").setCustomValidity("");
                }
                
            }
                
        }
            
            
           /* if(inp==null){
                component.find("delDate").setCustomValidity('Please Enter Delivery Date');
            }else if(inp == '' || inp< $A.localizationService.formatDate(new Date(), "YYYY-MM-DD")){
                //errorMessage=$A.get("$Label.c.Please_Select_Delivery_Date_Greater_Than_or_equal_to_Todays_date") ;//$A.get("$Label.c.Please_enter_Quantity");
                errorMessage=$A.get("Please select Delivery Date greater than today.") ;//$A.get("$Label.c.Please_enter_Quantity");
                inp =  $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
                target.set("v.value",inp);
                component.find("delDate").setCustomValidity(errorMessage);
            }*/
        /* -----------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022-------------- */  
    },
    
    removeRow : function(component, event, helper){
     // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
      console.log('removeRowIndex---->'+component.get("v.rowIndex"));
        component.getEvent("DeleteRowEvt").setParams({"rowIndex" : component.get("v.rowIndex") }).fire();
    }, 
})