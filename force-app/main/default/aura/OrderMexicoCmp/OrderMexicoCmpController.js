({
    doInit : function(component, event, helper){
        helper.getProfitCenter(component, event, helper);
        helper.doInit(component, event, helper);
        console.log('&&&&'+component.get("v.recordId"));
        console.log('&&&&'+component.get("v.oppId"));
    },
    
    //This is added for CR : SCTASK0308099 (RITM0141241)
    onChangeSegment : function(component, event, helper){
        helper.onChangeSegment(component, event, helper);
    },
    
    updatePromotionSOI : function(component, event, helper){
        var SingleOrderItem = component.get("v.SingleOrderItem");
        if(SingleOrderItem.typeOfSale == 'Promotion'){
            SingleOrderItem.finalPrice = 0.01;
            SingleOrderItem.disablePrice = true;
        }else{
            SingleOrderItem.finalPrice = 0;
            SingleOrderItem.disablePrice = false;
        }
        component.set("v.SingleOrderItem", SingleOrderItem);
    },
    
    openProductDeatilsPopUp : function(component, event, helper){
        component.set("v.showSpinner", true);
        var productDetailTableColumns = [
            {
                'label': $A.get("$Label.c.Product_Code"),
                'name':'skuCode',
                'type':'string',
                'resizeable':true
            },
            {
                'label': $A.get("$Label.c.Name"),
                'name':'description',
                'type':'string',              
                'resizeable':true
            }];            
        var productDetailTableConfig = {
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
        component.set("v.productDetailTableColumns", productDetailTableColumns);
        component.set("v.productDetailTableConfig", productDetailTableConfig);
        
        component.find("priceDetailsTable").initialize({
            "order":[0,"desc"],
            "itemMenu":["10","25","50"],
            "itemsPerPage:":5                    
        });
        
        helper.toggle(component, event, helper, 'lookupmodal', 'backdrop');
        component.set("v.showSpinner", false);
    },
    
    closePopUp : function(component, event, helper){
        helper.toggle(component, event, helper, 'lookupmodal', 'backdrop');
    },
    
    closePopUp2 : function(component, event, helper){
        helper.toggle(component, event, helper, 'lookupmodal2', 'backdrop2');
    },
    
    tabActionClicked : function(component, event, helper){
    console.log('click on select');
        var actionId = event.getParam('actionId');
        var itemRow = event.getParam('row');
        
        //Crop CR - For default selection at B2B
        var selectedDepot = component.get("v.depotSegmentvalue");
        if(selectedDepot == 'B2B'){
            var initDetail = component.get("v.wrapObj_Init_Details");
            var cropList = initDetail.cropList;
            var defaultCropId = '';
            var defaultCropName = '';
            for(var i in cropList){
                if(cropList[i].Name == 'Planta'){
                    defaultCropId = cropList[i].Id;
                    defaultCropName = cropList[i].Name;
                }
            }
            itemRow.crop1 = defaultCropId;
            itemRow.cropName1 = defaultCropName;
            itemRow.crop1_Percentage = 100;
            
            
            var cropVisiblityObj = {
                'crop1_disable' : true, 'crop2_disable' : true, 'crop3_disable' : true, 'crop4_disable' : true, 
                'crop5_disable' : true, 'crop1_percent_disable' : true, 
                'crop2_percent_disable' : true, 'crop3_percent_disable' : true, 
                'crop4_percent_disable' : true, 'crop5_percent_disable' : true,
                'crop2_max' : 100, 'crop3_max' : 100, 'crop4_max' : 100, 'crop5_max' : 100, 
            };
            component.set("v.cropVisiblityObj", cropVisiblityObj);
        }else{
            var cropVisiblityObj = {
                'crop1_disable' : false, 'crop2_disable' : true, 'crop3_disable' : true, 'crop4_disable' : true, 
                'crop5_disable' : true, 'crop1_percent_disable' : true, 
                'crop2_percent_disable' : true, 'crop3_percent_disable' : true, 
                'crop4_percent_disable' : true, 'crop5_percent_disable' : true,
                'crop2_max' : 100, 'crop3_max' : 100, 'crop4_max' : 100, 'crop5_max' : 100, 
            };
            component.set("v.cropVisiblityObj", cropVisiblityObj);
        }
        
        
        if(actionId == 'selectproduct'){
            component.set("v.SingleOrderItem", itemRow);
            component.set("v.DisplayOrderCart", true);
        }
        helper.toggle(component, event, helper, 'lookupmodal', 'backdrop');
    },
    
    displayOrderHistory : function(component, event, helper){
        var selectedSKUObj = component.get("v.SingleOrderItem");
        var selectSKUId = selectedSKUObj.skuId;
        var action = component.get("c.getSalesOrderHistory");  
        var initDetails = component.get("v.wrapObj_Init_Details");
        action.setParams({
            initDetail : JSON.stringify(initDetails),
            skuId : selectSKUId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retVal = response.getReturnValue();
                component.set("v.OrderHistoryList", retVal);
            } 
        });
        $A.enqueueAction(action);
        helper.toggle(component, event, helper, 'lookupmodal2', 'backdrop2');
    },
    
    onChangePaymentMethod : function(component, event, helper){
        var paymentMethodList = component.get("v.paymentMethodList");
        var paymentTermListAll = component.get("v.paymentTermListAll");
        var selectedPaymentMethodId = component.find("pay_method").get("v.value");
        if(selectedPaymentMethodId != 'None'){
            var selectedPaymentMethodName = '';
            for(var i in paymentMethodList){
                if(paymentMethodList[i].Id == selectedPaymentMethodId){
                    selectedPaymentMethodName = paymentMethodList[i].Name + ' - ' + paymentMethodList[i].Payment_Method_Code__c;
                }
            }
            if(selectedPaymentMethodName == 'TRANSFERENCIA ELECTRONICA - T'
               || selectedPaymentMethodName == 'CHEQUE - C'
               || selectedPaymentMethodName == 'EFECTIVO - E'
               || selectedPaymentMethodName == 'OTROS - J')
            {
                //RITM0226501: Sayan has added segment dependencies on change on PT selection; 16th July 2021
                if( component.get("v.depotSegmentvalue") != 'ALP' ){
                    component.set("v.paymentTermList", paymentTermListAll);
                }else{
                    var paymentTermListAll2 = [];
    //Added by Naresh for RITM0406004 For the AlP segment when creating the order,in the payment terms remove the UK65 and UK66. not for others segments
                    for(var i in paymentTermListAll){
                        
                        if(paymentTermListAll[i].Payment_Term_Code__c != 'MX00' && paymentTermListAll[i].Payment_Term_Code__c != 'UK10' && paymentTermListAll[i].Payment_Term_Code__c != 'AU01' && paymentTermListAll[i].Payment_Term_Code__c != 'UK11' && paymentTermListAll[i].Payment_Term_Code__c != 'UK12' &&
                           paymentTermListAll[i].Payment_Term_Code__c != 'UK65' &&  paymentTermListAll[i].Payment_Term_Code__c != 'UK66') {
                            paymentTermListAll2.push( paymentTermListAll[i] );
                        }
                    } 
                   component.set("v.paymentTermList", paymentTermListAll2);
                    
                }
                //RITM0226501 end
                
                //component.set("v.paymentTermList", paymentTermListAll); removed after RITM0226501 
                component.set("v.DisablePaymentTerm", false);
            }
            else{
                for(var i in paymentTermListAll){
                    if(paymentTermListAll[i].Payment_Term_Code__c == '0004'){
                        component.set("v.DisablePaymentTerm", true);
                        component.find("pay_term").set("v.value", paymentTermListAll[i].Id);
                    }
                } 
            }
        }
        else{
            component.find("pay_term").set("v.value", "None");
            component.set("v.DisablePaymentTerm", true);
        }
    },
    
    checkFinalPrice : function(component, event, helper){
        helper.checkFinalPrice(component, event, helper, false);
    },
    
    checkFinalPrice_OrderList : function(component, event, helper){
        helper.checkFinalPrice(component, event, helper, true);
    },
    
    closePopUp3 : function(component, event, helper){
        helper.toggle(component, event, helper, 'lookupmodal3', 'backdrop3');
        component.set("v.showMessageButton", true);
        component.set("v.showFinalCheckButtons", false);
    },
    
    closePopUp3_Bulk : function(component, event, helper){
        helper.toggle(component, event, helper, 'lookupmodal3', 'backdrop3');
        component.set("v.showMessageButton", true);
        component.set("v.showFinalCheckButtons_Bulk", false);
    },
    
    setFinalPriceZero : function(component, event, helper){
        helper.setFinalPriceZero(component, event, helper, false);
    },
    
    setFinalPriceZero_Bulk : function(component, event, helper){
        //helper.setFinalPriceZero(component, event, helper, true);
        helper.toggle(component, event, helper, 'lookupmodal3', 'backdrop3');
        component.set("v.showMessageButton", true);
        component.set("v.showFinalCheckButtons", false);
        component.set("v.showFinalCheckButtons_Bulk", false);
        
    },
    
    checkQuantity : function(component, event, helper){
        helper.checkQuantity(component, event, helper, false);
    },
    
    checkQuantity_OrderList : function(component, event, helper){
        helper.checkQuantity(component, event, helper, true);
    },
    
    /* ---------------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022------------ */
    validateCustomerDate:function(component, event, helper){
       helper.validateCustomerDate(component, event, helper, false);  
    },

    validateCustomerDate_OrderList:function(component, event, helper){
        helper.validateCustomerDate(component, event, helper, true);  
    },
    /* --------------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022----------------- */
    validateDate : function(component, event, helper){
        helper.validateDate(component, event, helper, false);
        
    },
    
    validateDate_OrderList : function(component, event, helper){
        helper.validateDate(component, event, helper, true);
    },
    
    openCropSelectionModal : function(component, event, helper){
        helper.toggle(component, event, helper, 'lookupmodal4', 'backdrop4');
    },
    
    closePopUp4 : function(component, event, helper){
        helper.toggle(component, event, helper, 'lookupmodal4', 'backdrop4');
    },
    
    manageCropPercentage : function(component, event, helper){
        var cropVisiblityObj = component.get("v.cropVisiblityObj");
        var SingleOrderItem = component.get("v.SingleOrderItem");
        
        if(SingleOrderItem.crop1_Percentage > 0 && SingleOrderItem.crop1_Percentage < 100){
            cropVisiblityObj.crop2_disable = false;
        }
        else if(SingleOrderItem.crop1_Percentage == 0 || SingleOrderItem.crop1_Percentage == 100){
            cropVisiblityObj.crop2_disable = true;
            SingleOrderItem.crop2 = null;
        }
        
        if(SingleOrderItem.crop2_Percentage > 0 && SingleOrderItem.crop2_Percentage < 100){
            cropVisiblityObj.crop3_disable = false;
        }
        else if(SingleOrderItem.crop2_Percentage == 0 || SingleOrderItem.crop2_Percentage == 100){
            cropVisiblityObj.crop3_disable = true;
            SingleOrderItem.crop3 = null;
        }
        
        if(SingleOrderItem.crop3_Percentage > 0 && SingleOrderItem.crop3_Percentage < 100){
            cropVisiblityObj.crop4_disable = false;
        }
        else if(SingleOrderItem.crop3_Percentage == 0 || SingleOrderItem.crop3_Percentage == 100){
            cropVisiblityObj.crop4_disable = true;
            SingleOrderItem.crop4 = null;
        }
        
        if(SingleOrderItem.crop4_Percentage > 0 && SingleOrderItem.crop4_Percentage < 100){
            cropVisiblityObj.crop5_disable = false;
        }
        else if(SingleOrderItem.crop4_Percentage == 0 || SingleOrderItem.crop4_Percentage == 100){
            cropVisiblityObj.crop5_disable = true;
            SingleOrderItem.crop5 = null;
        }
        
        component.set("v.cropVisiblityObj", cropVisiblityObj);
        component.set("v.SingleOrderItem", SingleOrderItem);
        helper.handleCropSelection(component, event, helper);
        helper.populateCropName(component, event, helper);
    },
    
    handleCropSelection: function(component, event, helper){
        helper.handleCropSelection(component, event, helper);
        helper.populateCropName(component, event, helper);
    },
    
    addSKUItem : function(component, event, helper){
        var hasError = helper.validateCrop(component, event, helper, false);
        if(!hasError){
            helper.addSKUItem(component, event, helper);
            helper.setCropfunction(component, event, helper);
        }
    },
    
    validateCropOnly : function(component, event, helper){
        var hasError = helper.validateCrop(component, event, helper, true);
        if(!hasError){
            component.set("v.CropErrorMessage", undefined);
            helper.toggle(component, event, helper, 'lookupmodal4', 'backdrop4');
        }
    },
    
    removeItem : function(component, event, helper){
        helper.deleteSKUItem(component, event, helper);
    },
    
    removeAllItem : function(component, event, helper){
        helper.deleteSKUAll(component, event, helper);
    },
    
    onIncoTermChange : function(component, event, helper){
        helper.onIncoTermChange(component, event, helper);
    },
    
    onShippingAddressChange : function(component, event, helper){
        helper.onShippingAddressChange(component, event, helper);
    },
    
    getInvDetails: function(component, event, helper){
        var storageIdChosen  = component.get("v.storageIdChosen");
        helper.getInvDetails(component, event, helper, storageIdChosen);
    },
    
    getTemplateName : function(component, event, helper){
        var OrderItemList = component.get("v.OrderItemList");
        var TemplateName = '';
        if(!helper.isBlank(OrderItemList) && OrderItemList.length > 0){
            for(var i in OrderItemList){
                TemplateName += OrderItemList[i].brandName + ' - ';
            }
            if(TemplateName.length > 0){
                if(TemplateName.length  > 75){
                    TemplateName = TemplateName.substring(0, 75);
                }
                TemplateName = TemplateName.substring(0, TemplateName.lastIndexOf('-'));
                if(TemplateName.endsWith(' - ')){
                    TemplateName = TemplateName.substring(0, TemplateName.length() - 2);
                }
            }
        }
        component.set("v.TemplateName", TemplateName);
    },
    
    handleFilesChange : function (component, event, helper) {
        var uploadedFiles = event.getSource().get("v.files");
        component.set("v.fileName", uploadedFiles[0].name);
        var isFileValidated = false;
        isFileValidated = helper.uploadHelper(component, event, helper);
    },
    
    clearSelectedFile : function (component, event, helper) {
        component.find("file_input").set("v.files",undefined);
        component.set("v.fileName", undefined);
    },
    
    saveOrder : function(component, event, helper){
        var totalAmountValidated = helper.minimumOrderValidation(component, event, helper);
        if(totalAmountValidated){
            var isvalidated = helper.fieldValidations(component, event, helper);
            if(isvalidated){
                console.log('&&&&1'+component.get("v.oppId"));
                 helper.confirmTheOrder(component, event, helper);
            }
        }
    },
    /* -----------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022-------------- */
    restrictPODate:function(component, event, helper){
        var pDate = component.get("v.poDate");
        console.log('ddasd pDate  '+pDate );
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"); 
        console.log('today today  '+today );
        /* if(pDate<today){      //commented as requested by client....
            helper.showPopup(component, event, helper, 'PO Date should be future date only');
            component.set("v.poDate",null);
        }  */       
    },
    /* --------------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022---------------- */
    closePopUp5 : function(component, event, helper){
        helper.toggle(component, event, helper, 'lookupmodal5', 'backdrop5');
    },
    
    getTemplateList : function(component, event, helper){
        component.set("v.showSpinner", true);
        var wrapObj_Init_Details = component.get("v.wrapObj_Init_Details");
        
        var action = component.get("c.showOrderTemplates");
        action.setParams({
            getDetailsWrap_str : JSON.stringify(wrapObj_Init_Details)
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var retVal = response.getReturnValue();
                component.set("v.TemplateList", retVal);
                helper.toggle(component, event, helper, 'lookupmodal5', 'backdrop5');
                component.set("v.showSpinner", false);
            }else if(state === "INCOMPLETE"){
                component.set("v.showSpinner", false);
                this.showToast(component, event, helper, 'error', 'Error', 'From server: ' + response.getReturnValue());
            }else if(state === "ERROR"){
                component.set("v.showSpinner", false);
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error message: " + errors[0].message);
                        this.showToast(component, event, helper, 'error', 'Error', 'From server: ' + errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    selectTemplate : function(component, event, helper){
        helper.selectTemplate(component, event, helper);
    },
    
    redirectToSalesOrder : function(component, event, helper){
        var soId = component.get("v.soIdToRedirect");
        console.log('redirect to sale order '+soId);
        helper.gotoURL(component, soId);
    }
    
})