({
    doInit : function(component, event, helper){
        component.set("v.showSpinner", true);
        var action = component.get("c.initializeDetails");
        action.setParams({ 
            recordId :  component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retVal = response.getReturnValue();
                
                if((retVal.error).toString() == 'NA'){
                    component.set("v.wrapObj_Init_Details", retVal.initDetailsWrap);
                    component.set("v.typeOfOrder", retVal.initDetailsWrap.typeOfOrder);
                    component.set("v.wrapObj_Distri_Details", retVal.distributerWrapObj);
                    component.set("v.wrapObj_SKU_Details_All", retVal.skuObjList);
                    
                    component.set("v.paymentTermList", retVal.distributerWrapObj.listPaymentTerm);
                    component.set("v.paymentTermListAll", retVal.distributerWrapObj.listPaymentTerm);
                    component.set("v.paymentMethodList", retVal.distributerWrapObj.paymentMethodList);
                    component.set("v.incoTermList", retVal.distributerWrapObj.incoTermList);
                    
                    component.set("v.loginCountryObjs", retVal.lCountry); // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022
                    
                    var orderlist = retVal.skuOrderList;
                    for(var i in orderlist){
                        if(!helper.isBlank(orderlist[i].netRateEnteredText)){
                            orderlist[i].netRateEnteredText = helper.numberWithCommas(orderlist[i].netRateEnteredText);
                        }
                    }
                    component.set("v.OrderItemList", orderlist);
                    component.set("v.orderSummaryCurrencyList", retVal.orderSummaryCurrencyList);
                    component.set("v.orderSummaryUOMList", retVal.orderSummaryUOMList);
                    component.set("v.selectedShippingLocation", retVal.distributerWrapObj.selectedShippingLocation);
                    component.set("v.shippingList", retVal.distributerWrapObj.shippingList);
                    component.set("v.mapShippingLocationWrapper", retVal.distributerWrapObj.mapShippingLocationWrapper);
                    component.set("v.showSpinner", false);
                    component.set("v.orderObj", retVal.orderObj);
                    component.set("v.storageIdChosen", retVal.initDetailsWrap.storageIdChosen);
                    
                	console.log('In Attribute : '+component.get("v.wrapObj_SKU_Details_All"));
                    helper.arrangeSKUandDepotList(component, event, helper, 
                                                  retVal.distributerWrapObj.listDepot, retVal.skuObjList);
                    
                    if(retVal.initDetailsWrap.typeOfOrder == 'Edit'){
                        component.set("v.SalesOrderDetails", retVal.soWrap);
                        component.set("v.SalesOrderNumber", retVal.soWrap.soObj.Name);
                        component.set("v.poDate",retVal.soWrap.soObj.Purchase_Order_Date__c); // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022
                        window.setTimeout(
                            $A.getCallback(function() {
                                helper.populatesalesorderdetails(component, event, helper, retVal.soWrap);
                            }), 1000
                        );
                    }
                }
                else{
                    component.set("v.ErrorMessage", retVal.error);
                    component.set("v.showMessageButton", false);
                    component.set("v.showFinalCheckButtons", false);
                    component.set("v.showFinalCheckButtons_Bulk", false);
                    component.set("v.closeOption", false);
                    component.set("v.showSpinner", false);
                    helper.toggle(component, event, helper, 'lookupmodal3', 'backdrop3');
                }
            }else if(state === "INCOMPLETE"){
                component.set("v.showSpinner", false);
                alert("From server: " + response.getReturnValue());
            }else if(state === "ERROR"){
                component.set("v.showSpinner", false);
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error message: " + errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        helper.setCropfunction(component, event, helper);
    },
    
    //added by vishal pawar
    getProfitCenter:function(component, event, helper){
         var action = component.get('c.fetchProfitCenter'); 
       
       
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
               // component.set('v.sObjList', a.getReturnValue());
               var returnData = a.getReturnValue();
                console.log('returnData profit center '+returnData);
                component.set("v.profitCenter",returnData.Profit_Center__c);
                component.set("v.profitCenterId",returnData.Id);
            }
        });
        $A.enqueueAction(action);
        
    },
    
    
    
    
    
    
    
    //This is added for CR : SCTASK0308099 (RITM0141241)
    arrangeSKUandDepotList : function(component, event, helper, storageLocList, allSKUs){
        var divisionCodes = [];
        var radioButtonValues = [];
        var filteredSKUs = [];
        var storageLocListToSet = [];
        
        for(var i in storageLocList){
            //Updated by Varun : SCTASK0380343 Start
            var segmentList;
            var segmentString = storageLocList[i].Segment_Name__c;
            if(segmentString !== null && segmentString !== undefined){
                segmentList = segmentString.split(";");
            	for(var i=0;i<segmentList.length; i++){
             		if(!divisionCodes.includes(segmentList[i])){
                		divisionCodes.push(segmentList[i]);
            		}   
            	}   
            }
            
            //if(!divisionCodes.includes(storageLocList[i].Segment__c)){
              //  divisionCodes.push(storageLocList[i].Segment__c);
            //}
            //Updated by Varun : SCTASK0380343 End
        }
        
        for(var i in divisionCodes){
            radioButtonValues.push({'label' : divisionCodes[i], 'value' : divisionCodes[i]});
        }
        
        if(!helper.isBlank(radioButtonValues) && radioButtonValues.length > 0){
            var selectedOption = '';
            component.set("v.depotSegmentOptions", radioButtonValues);
            for(var i in radioButtonValues){
                if(radioButtonValues[i].value == "Sales Team"){
                    selectedOption = radioButtonValues[i];
                }
        	}
            if(selectedOption == ''){
                selectedOption = radioButtonValues[0];
            }
            
            console.log('@@@@ selectedOption.value '+selectedOption.value);
            component.set("v.depotSegmentvalue", selectedOption.value);
            for(var i in allSKUs){
                console.log('@@@@@@ checking selected option '+allSKUs[i].divisionCode);
                
                if(allSKUs[i].divisionCode == selectedOption.value){
                    filteredSKUs.push(allSKUs[i]);
                }
            }
            component.set("v.wrapObj_SKU_Details", filteredSKUs);
            console.log('Final SKU : '+JSON.stringify(filteredSKUs));
            for(var i in storageLocList){
                //Updated by Varun : SCTASK0380343 Start
                var segmentList;
                console.log("here2:"+storageLocList[i].Segment_Name__c);
                var segmentString = storageLocList[i].Segment_Name__c;
                if(segmentString !== null && segmentString !== undefined){
                    segmentList = segmentString.split(";");
                    console.log("here3");
                    for(var j=0;j<segmentList.length; j++){
                        console.log("here4");
                        if(segmentList[j] == selectedOption.value){
                            console.log("here5");
                            storageLocListToSet.push(storageLocList[i]);
                        }   
                    }   
                }
                //if(storageLocList[i].Segment__c == selectedOption.value){
                    //if(storageLocList[i].Segment_Name__c != null && storageLocList[i].Segment_Name__c.contains(selectedOption.value)){    
                    //Updated by Varun : SCTASK0380343 End    
                  //  storageLocListToSet.push(storageLocList[i]);
                //}
                 //Updated by Varun : SCTASK0380343 End
            }
            component.set("v.StorageLocationList", storageLocListToSet);
            //Added by Varun Start
            component.set("v.storageIdChosen", storageLocListToSet[0].Id);
            //Added by Varun End
        }else{
            component.set("v.depotSegmentDisabled", true);
        }
    },
    
    //This is added for CR : SCTASK0308099 (RITM0141241)
    onChangeSegment : function(component, event, helper){
        //RITM0226501: Sayan has added this to removed payment values when Segment is changed; 16th July 2021
        //This is because we have defined some dependencies after RITM0226501
        component.find("pay_method").set( "v.value",'None');
        component.find("pay_term").set( "v.value",'None');
        //RITM0226501 end
       
        
        var distWrap = component.get("v.wrapObj_Distri_Details");
        var listDepot = distWrap.listDepot;
        var selectedOption = component.get("v.depotSegmentvalue");
        var allSKUs = component.get("v.wrapObj_SKU_Details_All");
        var filteredSKUs = [];
        var storageLocListToSet = [];
        console.log('On Change Called');
        for(var i in allSKUs){
            if(allSKUs[i].divisionCode == selectedOption){
                filteredSKUs.push(allSKUs[i]);
            }
        }     
        
        for(var i in listDepot){
            //Updated by Varun : SCTASK0380343 Start
            var segmentList;
            var segmentString = listDepot[i].Segment_Name__c;
                if(segmentString !== null && segmentString !== undefined){
                    segmentList = segmentString.split(";");
                    for(var j=0;j<segmentList.length; j++){
                        if(segmentList[j] == selectedOption){
                            storageLocListToSet.push(listDepot[i]);
                        }   
                    }   
                }
              // if(listDepot[i].Segment__c == selectedOption){
              //  if(listDepot[i].Segment_Name__c != null && listDepot[i].Segment_Name__c.contains(selectedOption)){    
            //storageLocListToSet.push(listDepot[i]);
            //}
            //Updated by Varun : SCTASK0380343 End
        }
        console.log('storageLocListToSet:'+storageLocListToSet);
        component.set("v.StorageLocationList", storageLocListToSet);
        component.set("v.storageIdChosen", storageLocListToSet[0].Id);
        component.set("v.wrapObj_SKU_Details", filteredSKUs);
        helper.getInvDetails(component, event, helper, storageLocListToSet[0].Id);
        
    },
    
    populatesalesorderdetails : function(component, event, helper, soDetails){
        if(!helper.isBlank(soDetails)){
            component.set("v.PaymentMethod", soDetails.payment_Methods);
            component.set("v.PaymentTerm", soDetails.payment_Terms);
            component.set("v.IncoTerm", soDetails.inco_Terms);
            component.set("v.Remark", soDetails.Remaks);
            component.set("v.SelectedShipping", soDetails.selectedShipping);
        }
        
    },
    
    //Added for CR: B2B and AlP improvements in Mexico warehouse selection screen. SCTASK0308099 (RITM0141241)
    setDefaultCrop : function(component, event, helper, soitm){
        //Crop CR - For default selection at B2B
        var selectedDepot = component.get("v.depotSegmentvalue");
        
        if(selectedDepot == 'B2B'){
            var initDetail = component.get("v.wrapObj_Init_Details");
            var cropList = initDetail.cropList;
            var defaultCropId = undefined;
            var defaultCropName = undefined;
            for(var i in cropList){
                if(cropList[i].Name == 'Planta'){
                    defaultCropId = cropList[i].Id;
                    defaultCropName = cropList[i].Name;
                }
            }
            soitm.crop1 = defaultCropId;
            soitm.cropName1 = defaultCropName;
            soitm.crop1_Percentage = 100;
            
            
            var cropVisiblityObj = {
                'crop1_disable' : true, 'crop2_disable' : true, 'crop3_disable' : true, 'crop4_disable' : true, 
                'crop5_disable' : true, 'crop1_percent_disable' : true, 
                'crop2_percent_disable' : true, 'crop3_percent_disable' : true, 
                'crop4_percent_disable' : true, 'crop5_percent_disable' : true,
                'crop2_max' : 100, 'crop3_max' : 100, 'crop4_max' : 100, 'crop5_max' : 100, 
            };
            component.set("v.cropVisiblityObj", cropVisiblityObj);
            component.set("v.SingleOrderItem", soitm);
        }
        else{
            var cropVisiblityObj = {
                'crop1_disable' : false, 'crop2_disable' : true, 'crop3_disable' : true, 'crop4_disable' : true, 
                'crop5_disable' : true, 'crop1_percent_disable' : true, 
                'crop2_percent_disable' : true, 'crop3_percent_disable' : true, 
                'crop4_percent_disable' : true, 'crop5_percent_disable' : true,
                'crop2_max' : 100, 'crop3_max' : 100, 'crop4_max' : 100, 'crop5_max' : 100, 
            };
            component.set("v.cropVisiblityObj", cropVisiblityObj);
            soitm.crop1 = '';
            soitm.cropName1 = '';
            soitm.crop1_Percentage = 0;
            component.set("v.SingleOrderItem", soitm);
        }
    },
    
    isBlank : function(val) {
        return (val == undefined || val == null || val == '' || val == "");
    },
    
    toggle : function(component, event, helper, lookupmodal, backdrop){
        var lookupmodal = component.find(lookupmodal);
        $A.util.toggleClass(lookupmodal, "slds-hide");
        
        var backdrop = component.find(backdrop);
        $A.util.toggleClass(backdrop, "slds-hide");
    },
    
    setFinalPriceZero : function(component, event, helper, bulk){
        helper.toggle(component, event, helper, 'lookupmodal3', 'backdrop3');
        component.set("v.showMessageButton", true);
        component.set("v.showFinalCheckButtons", false);
        component.set("v.showFinalCheckButtons_Bulk", false);
        var singleOdrItem = component.get("v.SingleOrderItem");
        if(bulk){
            var currentRow = component.get("v.currentRow_finalPrice");
            var OrderItemList = component.get("v.OrderItemList");
            singleOdrItem = OrderItemList[currentRow];
        }
        singleOdrItem.finalPrice = 0.0;
        if(bulk){
            OrderItemList[currentRow] = singleOdrItem;
            component.set("v.OrderItemList", OrderItemList);
        }else{
            component.set("v.SingleOrderItem", singleOdrItem);
        }
        component.set("v.SingleOrderItem", singleOdrItem);
        if(bulk){helper.updateNetRate(component, event, helper, true, currentRow);}
        else{helper.updateNetRate(component, event, helper, false, undefined);}
        
        helper.updateNetRate(component, event, helper);
    },
    
    updateNetRate : function(component, event, helper, bulk, currentRow){
        var singleOdrItem = component.get("v.SingleOrderItem");
        
        if(bulk){
            var OrderItemList = component.get("v.OrderItemList");
            singleOdrItem = OrderItemList[currentRow];
        }
       
        var finalPrice = singleOdrItem.finalPrice;
        var quantity = singleOdrItem.qty;
        if(isNaN(quantity)){quantity = 0;}
        if(isNaN(finalPrice)){finalPrice = 0;}
        
        var totalpri = (quantity * finalPrice);  
        singleOdrItem.netRateEntered = totalpri;
        singleOdrItem.netRateEnteredText = this.numberWithCommas(Math.round(totalpri * 100) / 100);
        if(bulk){
            OrderItemList[currentRow] = singleOdrItem;
            component.set("v.OrderItemList", OrderItemList);
        }else{
            component.set("v.SingleOrderItem", singleOdrItem);
        }
    },
    
    numberWithCommas: function(val){
        return val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    },
    
    setCropfunction : function(component, event, helper){
        var cropVisiblityObj = {
            'crop1_disable' : false, 'crop2_disable' : true, 'crop3_disable' : true, 'crop4_disable' : true, 
            'crop5_disable' : true, 'crop1_percent_disable' : true, 
            'crop2_percent_disable' : true, 'crop3_percent_disable' : true, 
            'crop4_percent_disable' : true, 'crop5_percent_disable' : true,
            'crop2_max' : 100, 'crop3_max' : 100, 'crop4_max' : 100, 'crop5_max' : 100, 
        };
        component.set("v.cropVisiblityObj", cropVisiblityObj);
    },
    
    handleCropSelection: function(component, event, helper){
        var cropVisiblityObj = component.get("v.cropVisiblityObj");
        var SingleOrderItem = component.get("v.SingleOrderItem");
        if(!this.isBlank(SingleOrderItem.crop1)){
            cropVisiblityObj.crop1_percent_disable = false;
        }else{
            cropVisiblityObj.crop1_percent_disable = true;
            SingleOrderItem.crop1_Percentage = 0;
            SingleOrderItem.crop2_Percentage = 0;
            SingleOrderItem.crop3_Percentage = 0;
            SingleOrderItem.crop4_Percentage = 0;
            SingleOrderItem.crop5_Percentage = 0;
            SingleOrderItem.crop2 = null;
            SingleOrderItem.crop3 = null;
            SingleOrderItem.crop4 = null;
            SingleOrderItem.crop5 = null;
            
            cropVisiblityObj.crop2_disable = true;
            cropVisiblityObj.crop3_disable = true;
            cropVisiblityObj.crop4_disable = true;
            cropVisiblityObj.crop5_disable = true;
        }
        
        if(!this.isBlank(SingleOrderItem.crop2)){
            cropVisiblityObj.crop2_percent_disable = false;
        }else{
            cropVisiblityObj.crop2_percent_disable = true;
            SingleOrderItem.crop2_Percentage = 0;
            SingleOrderItem.crop3_Percentage = 0;
            SingleOrderItem.crop4_Percentage = 0;
            SingleOrderItem.crop5_Percentage = 0;
            SingleOrderItem.crop3 = null;
            SingleOrderItem.crop4 = null;
            SingleOrderItem.crop5 = null;
            
            cropVisiblityObj.crop3_disable = true;
            cropVisiblityObj.crop4_disable = true;
            cropVisiblityObj.crop5_disable = true;
        }
        
        if(!this.isBlank(SingleOrderItem.crop3)){
            cropVisiblityObj.crop3_percent_disable = false;
        }else{
            cropVisiblityObj.crop3_percent_disable = true;
            SingleOrderItem.crop3_Percentage = 0;
            SingleOrderItem.crop4_Percentage = 0;
            SingleOrderItem.crop5_Percentage = 0;
            SingleOrderItem.crop4 = null;
            SingleOrderItem.crop5 = null;
            cropVisiblityObj.crop4_disable = true;
            cropVisiblityObj.crop5_disable = true;
        }
        
        if(!this.isBlank(SingleOrderItem.crop4)){
            cropVisiblityObj.crop4_percent_disable = false;
        }else{
            cropVisiblityObj.crop4_percent_disable = true;
            SingleOrderItem.crop4_Percentage = 0;
            SingleOrderItem.crop5_Percentage = 0;
            SingleOrderItem.crop5 = null;
            
            cropVisiblityObj.crop5_disable = true;
        }
        
        if(!this.isBlank(SingleOrderItem.crop5)){
            cropVisiblityObj.crop5_percent_disable = false;
        }else{
            cropVisiblityObj.crop5_percent_disable = true;
            SingleOrderItem.crop5_Percentage = 0;
        }
        component.set("v.cropVisiblityObj", cropVisiblityObj);
        component.set("v.SingleOrderItem", SingleOrderItem);
        this.evaluatePercentCal(component, event, helper);
    },
    
    evaluatePercentCal : function(component, event, helper){
        var cropVisiblityObj = component.get("v.cropVisiblityObj");
        var SingleOrderItem = component.get("v.SingleOrderItem");
        var totalPercent = 0;
        var c1_percent = 0; var c2_percent = 0; var c3_percent = 0; var c4_percent = 0; var c5_percent = 0;
        
        if(!helper.isBlank(SingleOrderItem.crop1_Percentage)){c1_percent = parseFloat(SingleOrderItem.crop1_Percentage);}
        if(!helper.isBlank(SingleOrderItem.crop2_Percentage)){c2_percent = parseFloat(SingleOrderItem.crop2_Percentage);}
        if(!helper.isBlank(SingleOrderItem.crop3_Percentage)){c3_percent = parseFloat(SingleOrderItem.crop3_Percentage);}
        if(!helper.isBlank(SingleOrderItem.crop4_Percentage)){c4_percent = parseFloat(SingleOrderItem.crop4_Percentage);}
        if(!helper.isBlank(SingleOrderItem.crop5_Percentage)){c5_percent = parseFloat(SingleOrderItem.crop5_Percentage);}
        
        if(c1_percent != 0){
            if(100 - c1_percent > 0){
                cropVisiblityObj.crop2_max = 100 - c1_percent;
                if(SingleOrderItem.crop2_Percentage > cropVisiblityObj.crop2_max){
                    SingleOrderItem.crop2_Percentage = cropVisiblityObj.crop2_max;
                }
            }
            if(c2_percent != 0){
                if((100 - (c1_percent + c2_percent)) > 0 ){
                    cropVisiblityObj.crop3_max = 100 - (c1_percent + c2_percent);
                    if(SingleOrderItem.crop3_Percentage > cropVisiblityObj.crop3_max){
                        SingleOrderItem.crop3_Percentage = cropVisiblityObj.crop3_max;
                    }
                }
                if(c3_percent != 0){
                    if((100 - (c1_percent + c2_percent + c3_percent)) > 0){
                        cropVisiblityObj.crop4_max = 100 - (c1_percent + c2_percent + c3_percent);
                        if(SingleOrderItem.crop4_Percentage > cropVisiblityObj.crop4_max){
                            SingleOrderItem.crop4_Percentage = cropVisiblityObj.crop4_max;
                        }
                    }
                    if(c4_percent != 0){
                        if((100 - (c1_percent + c2_percent + c3_percent + c4_percent)) > 0){
                            cropVisiblityObj.crop5_max = 100 - (c1_percent + c2_percent + c3_percent + c4_percent);
                            if(SingleOrderItem.crop5_Percentage > cropVisiblityObj.crop5_max){
                                SingleOrderItem.crop5_Percentage = cropVisiblityObj.crop5_max;
                            }
                        }
                    }
                }
            }
        }else{
            cropVisiblityObj.crop1_max = 100;
            cropVisiblityObj.crop2_max = 100;
            cropVisiblityObj.crop3_max = 100;
            cropVisiblityObj.crop4_max = 100;
            cropVisiblityObj.crop5_max = 100;
        }
        
        
        if((c1_percent + c2_percent) == 100 || (c1_percent + c2_percent) > 100){
            cropVisiblityObj.crop3_disable = true;
            cropVisiblityObj.crop4_disable = true;
            cropVisiblityObj.crop5_disable = true;
            cropVisiblityObj.crop3_percent_disable = true;
            cropVisiblityObj.crop4_percent_disable = true;
            cropVisiblityObj.crop5_percent_disable = true;
            SingleOrderItem.crop3 = null;
            SingleOrderItem.crop4 = null;
            SingleOrderItem.crop5 = null;
            SingleOrderItem.crop3_Percentage = 0;
            SingleOrderItem.crop4_Percentage = 0;
            SingleOrderItem.crop5_Percentage = 0;
        }
        
        else if((c1_percent + c2_percent + c3_percent) == 100 || (c1_percent + c2_percent + c3_percent) > 100){
            cropVisiblityObj.crop4_disable = true;
            cropVisiblityObj.crop5_disable = true;
            cropVisiblityObj.crop4_percent_disable = true;
            cropVisiblityObj.crop5_percent_disable = true;
            SingleOrderItem.crop4 = null;
            SingleOrderItem.crop5 = null;
            SingleOrderItem.crop4_Percentage = 0;
            SingleOrderItem.crop5_Percentage = 0;
        }
        
            else if((c1_percent + c2_percent + c3_percent + c4_percent) == 100 
                    ||
                    (c1_percent + c2_percent + c3_percent + c4_percent) > 100)
            {
                cropVisiblityObj.crop5_disable = true;
                cropVisiblityObj.crop5_percent_disable = true;
                SingleOrderItem.crop5 = null;
                SingleOrderItem.crop5_Percentage = 0;
            }
        
        component.set("v.cropVisiblityObj", cropVisiblityObj);
        component.set("v.SingleOrderItem", SingleOrderItem);
    },
    
    populateCropName : function(component, event, helper){
        var SingleOrderItem = component.get("v.SingleOrderItem");
        var initDetail = component.get("v.wrapObj_Init_Details"); 
        var cropList = initDetail.cropList;
        for(var i in cropList){
            if(cropList[i].Id == SingleOrderItem.crop1){
                SingleOrderItem.cropName1 = cropList[i].Name;
            }
            if(cropList[i].Id == SingleOrderItem.crop2){
                SingleOrderItem.cropName2 = cropList[i].Name;
            }
            if(cropList[i].Id == SingleOrderItem.crop3){
                SingleOrderItem.cropName3 = cropList[i].Name;
            }
            if(cropList[i].Id == SingleOrderItem.crop4){
                SingleOrderItem.cropName4 = cropList[i].Name;
            }
            if(cropList[i].Id == SingleOrderItem.crop5){
                SingleOrderItem.cropName5 = cropList[i].Name;
            }
        }
        component.set("v.SingleOrderItem", SingleOrderItem);
    },
    
    validateCrop : function(component, event, helper, onlyCropVal){
        var SingleOrderItem = component.get("v.SingleOrderItem");
        var initDetails = component.get("v.wrapObj_Init_Details");
        var cropList = initDetails.cropList;
        var c1_percent = 0; var c2_percent = 0; var c3_percent = 0; var c4_percent = 0; var c5_percent = 0;
        var c1_Id = ''; var c2_Id = ''; var c3_Id = ''; var c4_Id = ''; var c5_Id = '';
        var retVal;
        
        if(!helper.isBlank(SingleOrderItem.crop1)){
            c1_percent = parseFloat(SingleOrderItem.crop1_Percentage);
            c1_Id = SingleOrderItem.crop1;
        }
        if(!helper.isBlank(SingleOrderItem.crop2)){
            c2_percent = parseFloat(SingleOrderItem.crop2_Percentage);
            c2_Id = SingleOrderItem.crop2;
        }
        if(!helper.isBlank(SingleOrderItem.crop3)){
            c3_percent = parseFloat(SingleOrderItem.crop3_Percentage);
            c3_Id = SingleOrderItem.crop3;
        }
        if(!helper.isBlank(SingleOrderItem.crop4)){
            c4_percent = parseFloat(SingleOrderItem.crop4_Percentage);
            c4_Id = SingleOrderItem.crop4;
        }
        if(!helper.isBlank(SingleOrderItem.crop5)){
            c5_percent = parseFloat(SingleOrderItem.crop5_Percentage);
            c5_Id = SingleOrderItem.crop5;
        }
        if(!onlyCropVal){
            //Validate for Final Price & Quantity
            if(helper.isBlank(SingleOrderItem.finalPrice) || helper.isBlank(SingleOrderItem.qty)){
                retVal = $A.get("$Label.c.Please_enter_Quantity_Final_Price");
                return this.errorMessage(component, event, helper, retVal);
            }
            /* --------------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022------- */
            var logiCtry = component.get("v.loginCountryObjs");
            if(helper.isBlank(SingleOrderItem.customerDeliveryDate) && logiCtry.Delivery_Date__c==true){
                retVal = 'Please Enter Customer Delivery Date';
                return this.errorMessage(component, event, helper, retVal);
            }
            /* -------------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022---------- */
        }
        
        //validate for atleast 1 crop
        if(helper.isBlank(c1_Id)){
            retVal = $A.get("$Label.c.Please_Select_Crop");
            if(onlyCropVal){return this.cropErrorMessage(component, event, helper, retVal);}
            else{return this.errorMessage(component, event, helper, retVal);}
        }
        
        //Check for crop & its percentage
        if(!helper.isBlank(c1_Id) && c1_percent == 0){
            retVal = $A.get("$Label.c.Crop_1_is_selected_so_its_Percentage_should_be_between_1_to_100");
            if(onlyCropVal){return this.cropErrorMessage(component, event, helper, retVal);}
            else{return this.errorMessage(component, event, helper, retVal);}
        }
        if(!helper.isBlank(c2_Id) && c2_percent == 0){
            retVal = $A.get("$Label.c.Crop_2_is_selected_so_its_Percentage_should_be_between_1_to_100");
            if(onlyCropVal){return this.cropErrorMessage(component, event, helper, retVal);}
            else{return this.errorMessage(component, event, helper, retVal);}
        }
        if(!helper.isBlank(c3_Id) && c3_percent == 0){
            retVal = $A.get("$Label.c.Crop_3_is_selected_so_its_Percentage_should_be_between_1_to_100");
            if(onlyCropVal){return this.cropErrorMessage(component, event, helper, retVal);}
            else{return this.errorMessage(component, event, helper, retVal);}
        }
        if(!helper.isBlank(c4_Id) && c4_percent == 0){
            retVal = $A.get("$Label.c.Crop_4_is_selected_so_its_Percentage_should_be_between_1_to_100");
            if(onlyCropVal){return this.cropErrorMessage(component, event, helper, retVal);}
            else{return this.errorMessage(component, event, helper, retVal);}
        }
        if(!helper.isBlank(c5_Id) && c5_percent == 0){
            retVal = $A.get("$Label.c.Crop_5_is_selected_so_its_Percentage_should_be_between_1_to_100");
            if(onlyCropVal){return this.cropErrorMessage(component, event, helper, retVal);}
            else{return this.errorMessage(component, event, helper, retVal);}
        }
        
        //Validate for Total Percent
        if(c1_percent + c2_percent + c3_percent + c4_percent + c5_percent != 100){
            retVal = $A.get("$Label.c.Total_Crop_Percentage_should_be_100");
            if(onlyCropVal){return this.cropErrorMessage(component, event, helper, retVal);}
            else{return this.errorMessage(component, event, helper, retVal);}
        }
        
        //Check for duplicate crop 
        //Crop 1
        if(
            (!helper.isBlank(c1_Id) && !helper.isBlank(c2_Id) && c1_Id == c2_Id)
            ||
            (!helper.isBlank(c1_Id) && !helper.isBlank(c3_Id) && c1_Id == c3_Id)
            ||
            (!helper.isBlank(c1_Id) && !helper.isBlank(c4_Id) && c1_Id == c4_Id)
            ||
            (!helper.isBlank(c1_Id) && !helper.isBlank(c5_Id) && c1_Id == c5_Id)
        ){
            var cropName = '';
            for(var i in cropList){if(cropList[i].Id == c1_Id){cropName = cropList[i].Name;}}
            var message = $A.get("$Label.c.is_selected_Multiple_Times");
            retVal = cropName+' '+message;
            if(onlyCropVal){return this.cropErrorMessage(component, event, helper, retVal);}
            else{return this.errorMessage(component, event, helper, retVal);}
        }
        
        //Crop 2
        if(
            (!helper.isBlank(c2_Id) && !helper.isBlank(c1_Id) && c2_Id == c1_Id)
            ||
            (!helper.isBlank(c2_Id) && !helper.isBlank(c3_Id) && c2_Id == c3_Id)
            ||
            (!helper.isBlank(c2_Id) && !helper.isBlank(c4_Id) && c2_Id == c4_Id)
            ||
            (!helper.isBlank(c2_Id) && !helper.isBlank(c5_Id) && c2_Id == c5_Id)
        ){
            var cropName = '';
            for(var i in cropList){if(cropList[i].Id == c2_Id){cropName = cropList[i].Name;}}
            var message = $A.get("$Label.c.is_selected_Multiple_Times");
            retVal = cropName+' '+message;
            if(onlyCropVal){return this.cropErrorMessage(component, event, helper, retVal);}
            else{return this.errorMessage(component, event, helper, retVal);}
        }
        
        //Crop 3
        if(
            (!helper.isBlank(c3_Id) && !helper.isBlank(c1_Id) && c3_Id == c1_Id)
            ||
            (!helper.isBlank(c3_Id) && !helper.isBlank(c2_Id) && c3_Id == c2_Id)
            ||
            (!helper.isBlank(c3_Id) && !helper.isBlank(c4_Id) && c3_Id == c4_Id)
            ||
            (!helper.isBlank(c3_Id) && !helper.isBlank(c5_Id) && c3_Id == c5_Id)
        ){
            var cropName = '';
            for(var i in cropList){if(cropList[i].Id == c3_Id){cropName = cropList[i].Name;}}
            var message = $A.get("$Label.c.is_selected_Multiple_Times");
            retVal = cropName+' '+message;
            if(onlyCropVal){return this.cropErrorMessage(component, event, helper, retVal);}
            else{return this.errorMessage(component, event, helper, retVal);}
        }
        
        //Crop 4
        if(
            (!helper.isBlank(c4_Id) && !helper.isBlank(c2_Id) && c4_Id == c2_Id)
            ||
            (!helper.isBlank(c4_Id) && !helper.isBlank(c3_Id) && c4_Id == c3_Id)
            ||
            (!helper.isBlank(c4_Id) && !helper.isBlank(c1_Id) && c4_Id == c1_Id)
            ||
            (!helper.isBlank(c4_Id) && !helper.isBlank(c5_Id) && c4_Id == c5_Id)
        ){
            var cropName = '';
            for(var i in cropList){if(cropList[i].Id == c4_Id){cropName = cropList[i].Name;}}
            var message = $A.get("$Label.c.is_selected_Multiple_Times");
            retVal = cropName+' '+message;
            if(onlyCropVal){return this.cropErrorMessage(component, event, helper, retVal);}
            else{return this.errorMessage(component, event, helper, retVal);}
        }
        
        //Crop 5
        if(
            (!helper.isBlank(c5_Id) && !helper.isBlank(c2_Id) && c5_Id == c2_Id)
            ||
            (!helper.isBlank(c5_Id) && !helper.isBlank(c3_Id) && c5_Id == c3_Id)
            ||
            (!helper.isBlank(c5_Id) && !helper.isBlank(c4_Id) && c5_Id == c4_Id)
            ||
            (!helper.isBlank(c5_Id) && !helper.isBlank(c1_Id) && c5_Id == c1_Id)
        ){
            var cropName = '';
            for(var i in cropList){if(cropList[i].Id == c5_Id){cropName = cropList[i].Name;}}
            var message = $A.get("$Label.c.is_selected_Multiple_Times");
            retVal = cropName+' '+message;
            if(onlyCropVal){return this.cropErrorMessage(component, event, helper, retVal);}
            else{return this.errorMessage(component, event, helper, retVal);}
        }
        
        if(!onlyCropVal){
            //validate Delievery Date
            if(helper.isBlank(SingleOrderItem.deliveryDate)){
                retVal = $A.get("$Label.c.Please_Enter_Delivery_Date");
                return this.errorMessage(component, event, helper, retVal);
            }
        }
        
        return false;
    },
    
    errorMessage : function(component, event, helper, retVal){
        component.set("v.ErrorMessage", retVal);
        component.set("v.showMessageButton", true);
        component.set("v.showFinalCheckButtons", false);
        helper.toggle(component, event, helper, 'lookupmodal3', 'backdrop3');
        return true;
    },
    
    cropErrorMessage : function(component, event, helper, retVal){
        component.set("v.CropErrorMessage", retVal);
        return true;
    },
    
    addSKUItem : function(component, event, helper){
        component.set("v.showSpinner", true);
        var SingleOrderItem = component.get("v.SingleOrderItem");
        console.log('Line item details are-->'+SingleOrderItem.agrosatSale);
        var OrderItemList = component.get("v.OrderItemList");
        var wrapObj_Distri_Details = component.get("v.wrapObj_Distri_Details");
        var wrapObj_Init_Details = component.get("v.wrapObj_Init_Details");
        
        var typeOrder = component.get("v.typeOfOrder");
        var soDetails = component.get("v.SalesOrderDetails");
        var soObj = {};
        var isEdit = false;
        
        if(typeOrder == 'Edit' && !helper.isBlank(soDetails)){
            if(!helper.isBlank(soDetails.soObj.Id)){
                soObj = soDetails.soObj;
                isEdit = true;
            }
        }
        
        var action = component.get("c.addSKU");        
        action.setParams({ 
            singleOrderItem_str :  JSON.stringify(SingleOrderItem), 
            skuOrderList_str : JSON.stringify(OrderItemList),
            distWrapObj_str : JSON.stringify(wrapObj_Distri_Details),
            orderRaisedBy : wrapObj_Init_Details.orderRaisedBy,
            ordObj : component.get("v.orderObj"),
            isEdit : isEdit,
            salesOrderObj : soObj
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var orderlist = response.getReturnValue();
                for(var i in orderlist){
                    if(!helper.isBlank(orderlist[i].netRateEnteredText)){
                        if(orderlist[i].typeOfSale == 'Promotion'){
                            orderlist[i].netRateEnteredText = orderlist[i].netRateEnteredText;
                        }else{
                            orderlist[i].netRateEnteredText = helper.numberWithCommas(orderlist[i].netRateEnteredText);
                        }
                    }
                }
                component.set("v.OrderItemList", orderlist);
                helper.calculateUOMCurrencyTotal(component, event, helper, orderlist);
                component.set("v.showSpinner", false);
                component.set("v.SingleOrderItem", {});
                component.set("v.DisplayOrderCart", false);
                component.find("itemproduct").set("v.value", null);
                // RITM0416295 - Uncommented the below line with respect to update related to the ticket where only one segment is alowed for each line item(01-09-2022)
				component.set("v.depotSegmentDisabled", true);
                if(isEdit==true){
                    location.reload();    
                }
                
            }else{
                alert('Error in Server side');
                component.set("v.showSpinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    /* ----------------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022----------- */
    validateCustomerDate:function(component, event, helper, bulk){
        var singleOdrItem;
        var currentRow;
        if(bulk){
            var OrderItemList = component.get("v.OrderItemList");
            currentRow = parseInt(event.getSource().get("v.name"));
            singleOdrItem = OrderItemList[currentRow];
        }else{
            singleOdrItem = component.get("v.SingleOrderItem");
        }
        var enterDate = singleOdrItem.customerDeliveryDate;
        var todayDate = new Date();
        var todayMonth = todayDate.getMonth() + 1;
        var todayDay = todayDate.getDate()+ 1;
        console.log('dsadasd todayDay '+todayDay);
      
        
        var todayYear = todayDate.getFullYear();
        if(todayDay<10) {todayDay='0'+todayDay;} 
        if(todayMonth<10){todayMonth='0'+todayMonth;} 
        var todayDateText =  todayYear  + "-" + todayMonth+ "-" + todayDay;
        console.log()
        if(enterDate < todayDateText ){
            //var msg = $A.get("$Label.c.Please_Select_Delivery_Date_Greater_Than_or_equal_to_Todays_date"); 
            var msg = 'Customer Delivery Date should be future date only'; 
            component.set("v.ErrorMessage", msg);
            component.set("v.showMessageButton", true);
            component.set("v.showFinalCheckButtons", false);
            const today = new Date();           
            let tomorrow =  new Date();
            tomorrow.setDate(today.getDate() + 1);
            singleOdrItem.customerDeliveryDate = todayDateText;
            if(bulk){
                OrderItemList[currentRow] = singleOdrItem;
                component.set("v.OrderItemList", OrderItemList);
            }else{
                component.set("v.SingleOrderItem", singleOdrItem);
            }
            if(bulk){
                helper.updateSKUItem(component, event, helper, OrderItemList, currentRow);
            }
            helper.toggle(component, event, helper, 'lookupmodal3', 'backdrop3');
        }else{
            if(bulk){
                helper.updateSKUItem(component, event, helper, OrderItemList, currentRow);
            }
        }
        
    },
    /* -----------------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022------------ */
    
    validateDate : function(component, event, helper, bulk){
        var singleOdrItem;
        var currentRow;
        if(bulk){
            var OrderItemList = component.get("v.OrderItemList");
            currentRow = parseInt(event.getSource().get("v.name"));
            singleOdrItem = OrderItemList[currentRow];
        }else{
            singleOdrItem = component.get("v.SingleOrderItem");
        }
        var enterDate = singleOdrItem.deliveryDate;
        var todayDate = new Date();
        var todayMonth = todayDate.getMonth() + 1;
        var todayDay = todayDate.getDate();
        var todayYear = todayDate.getFullYear();
        if(todayDay<10) {todayDay='0'+todayDay;} 
        if(todayMonth<10){todayMonth='0'+todayMonth;} 
        var todayDateText =  todayYear  + "-" + todayMonth+ "-" + todayDay;
        if(enterDate < todayDateText ){
            var msg = $A.get("$Label.c.Please_Select_Delivery_Date_Greater_Than_or_equal_to_Todays_date"); 
            component.set("v.ErrorMessage", msg);
            component.set("v.showMessageButton", true);
            component.set("v.showFinalCheckButtons", false);
            singleOdrItem.deliveryDate = todayDateText;
            if(bulk){
                OrderItemList[currentRow] = singleOdrItem;
                component.set("v.OrderItemList", OrderItemList);
            }else{
                component.set("v.SingleOrderItem", singleOdrItem);
            }
            if(bulk){
                helper.updateSKUItem(component, event, helper, OrderItemList, currentRow);
            }
            helper.toggle(component, event, helper, 'lookupmodal3', 'backdrop3');
        }else{
            if(bulk){
                helper.updateSKUItem(component, event, helper, OrderItemList, currentRow);
            }
        }
    },
    
    checkFinalPrice : function(component, event, helper, bulk){
        var singleOdrItem = component.get("v.SingleOrderItem");
        if(bulk){
            var OrderItemList = component.get("v.OrderItemList");
            var currentRow = parseInt(event.getSource().get("v.labelClass"));
            component.set("v.currentRow_finalPrice", currentRow);
            singleOdrItem = OrderItemList[currentRow];
        }
        var isNotPromo = true;
        if(singleOdrItem.typeOfSale == 'Promotion'){
            isNotPromo = false;
        }
        
        var finalPrice = singleOdrItem.finalPrice;
        var maxPrice = singleOdrItem.maxPrice;
        var minPrice = singleOdrItem.minPrice;
        
        if(!helper.isBlank(finalPrice)){
            if(finalPrice > maxPrice && isNotPromo){
                var retVal = $A.get("$Label.c.Final_price_is_greater_than_List_price_Still_do_you_want_to_proceed");
                component.set("v.ErrorMessage", retVal);
                component.set("v.showMessageButton", false);
                if(bulk){
                    component.set("v.showFinalCheckButtons", false);
                    component.set("v.showFinalCheckButtons_Bulk", true);
                }else{
                    component.set("v.showFinalCheckButtons", true);
                    component.set("v.showFinalCheckButtons_Bulk", false);
                }
                helper.toggle(component, event, helper, 'lookupmodal3', 'backdrop3');
            }
            if(finalPrice < minPrice && isNotPromo){
                var retVal = $A.get("$Label.c.Final_price_is_less_than_Min_price_Still_do_you_want_to_proceed"); 
                component.set("v.ErrorMessage", retVal);
                component.set("v.showMessageButton", false);
                if(bulk){
                    component.set("v.showFinalCheckButtons", false);
                    component.set("v.showFinalCheckButtons_Bulk", true);
                }else{
                    component.set("v.showFinalCheckButtons", true);
                    component.set("v.showFinalCheckButtons_Bulk", false);
                }
                helper.toggle(component, event, helper, 'lookupmodal3', 'backdrop3');
            }
            if(bulk){
                helper.updateNetRate(component, event, helper, true, currentRow);
                helper.updateSKUItem(component, event, helper, OrderItemList, currentRow);
            }
            else{
                helper.updateNetRate(component, event, helper, false, undefined);
            }
        }
    },
    
    checkQuantity : function(component, event, helper, bulk){
        var singleOdrItem = component.get("v.SingleOrderItem");
        if(bulk){
            var OrderItemList = component.get("v.OrderItemList");
            var currentRow = parseInt(event.getSource().get("v.labelClass"));
            singleOdrItem = OrderItemList[currentRow];
        }
        var multiple_Of = singleOdrItem.multipleOf;
        var quantity = singleOdrItem.qty;
        if(isNaN(multiple_Of)){multiple_Of = 0;}
        if(isNaN(quantity)){quantity = 0;}
        var finalval = (quantity % multiple_Of).toFixed(2);
        if((finalval != 0 && finalval != multiple_Of) && multiple_Of != 0){
            var labelmsg = $A.get("$Label.c.Please_Enter_Quantity_in_multiple_of"); 
            var msg = labelmsg + multiple_Of.toString();
            component.set("v.ErrorMessage", msg);
            component.set("v.showMessageButton", true);
            component.set("v.showFinalCheckButtons", false);
            singleOdrItem.qty = 0;
            if(bulk){
                OrderItemList[currentRow] = singleOdrItem;
                component.set("v.OrderItemList", OrderItemList);
            }else{
                component.set("v.SingleOrderItem", singleOdrItem);
            }
            helper.toggle(component, event, helper, 'lookupmodal3', 'backdrop3');
        }
        if(bulk){
            helper.updateNetRate(component, event, helper, true, currentRow);
            helper.updateSKUItem(component, event, helper, OrderItemList, currentRow);
        }
        else{
            helper.updateNetRate(component, event, helper, false, undefined);
        }
    },
    
    updateSKUItem : function(component, event, helper, OrderItemList, currentRow){
        component.set("v.showSpinner", true);
        var typeOrder = component.get("v.typeOfOrder");
        var isEdit = false;
        if(typeOrder == 'Edit'){isEdit = true;}
        var action = component.get("c.updateSKU");        
        action.setParams({ 
            skuOrderList_str : JSON.stringify(OrderItemList),
            currentRow : parseInt(currentRow),
            isEdit : isEdit
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retVal = response.getReturnValue();
                component.set("v.OrderItemList", retVal);
                helper.calculateUOMCurrencyTotal(component, event, helper, retVal);
                component.set("v.showSpinner", false);
            }else{
                alert('Error in Server side : updateSKUItem');
                component.set("v.showSpinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    deleteSKUItem : function(component, event, helper){
        component.set("v.showSpinner", true);
        var typeOrder = component.get("v.typeOfOrder");
        var isEdit = false;
        if(typeOrder == 'Edit'){isEdit = true;}
        var OrderItemList = component.get("v.OrderItemList");
        var currentRow = parseInt(event.getSource().get("v.name"));
        var action = component.get("c.deleteSKU");        
        action.setParams({ 
            skuOrderList_str : JSON.stringify(OrderItemList),
            currentRow : parseInt(currentRow),
            isEdit : isEdit
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retVal = response.getReturnValue();
                component.set("v.OrderItemList", retVal);
                helper.calculateUOMCurrencyTotal(component, event, helper, retVal);
                component.set("v.showSpinner", false);
            }else{
                alert('Error in Server side : deleteSKUItem');
                component.set("v.showSpinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    deleteSKUAll : function(component, event, helper){
        component.set("v.showSpinner", true);
        var typeOrder = component.get("v.typeOfOrder");
        var isEdit = false;
        if(typeOrder == 'Edit'){isEdit = true;}
        
        var OrderItemList = component.get("v.OrderItemList");
        var action = component.get("c.deleteAllSKU");        
        action.setParams({ 
            skuOrderList_str : JSON.stringify(OrderItemList),
            isEdit : isEdit
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retVal = response.getReturnValue();
                component.set("v.OrderItemList", retVal);
                helper.calculateUOMCurrencyTotal(component, event, helper, retVal);
                component.set("v.showSpinner", false);
            }else{
                alert('Error in Server side : deleteSKUAll');
                component.set("v.showSpinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    //This method is not being called because we must need Shipping location for every scenario.
    //Calling is disabled from the component picklist.
    onIncoTermChange : function(component, event, helper){
        var incoTermList = component.get("v.incoTermList");
        var selectedIncoTermVId = component.find("inco_term").get("v.value");
        component.set("v.shippingRequired", false);
        if(!helper.isBlank(selectedIncoTermVId)){
            for(var i in incoTermList){
                if(incoTermList[i].Id == selectedIncoTermVId){
                    var NameToCheck = incoTermList[i].Name + '-' + incoTermList[i].IncoTerm_Desc__c;
                    if(NameToCheck == 'CFR-NOSOTROS ENVIAMOS EL PRODUCTO'){
                        var msg = $A.get("$Label.c.Please_Select_shipping_location"); 
                        component.set("v.ErrorMessage", msg);
                        component.set("v.showMessageButton", true);
                        component.set("v.showFinalCheckButtons", false);
                        component.set("v.shippingRequired", true);
                        helper.toggle(component, event, helper, 'lookupmodal3', 'backdrop3');
                    }
                }
            }
        }
    },
    
    //Added for CR : Depot improvement Mexico. SCTASK0308045 (RITM0141217)
    onShippingAddressChange : function(component, event, helper){
        component.set("v.showSpinner", true);
        var initDetail = component.get("v.wrapObj_Distri_Details");
        var storageLocList = initDetail.listDepot;
        var listDepot = initDetail.listDepot;
        var selectedShippingAdd = component.find("shipping_address").get("v.value");
        var mapShippingLocationWrapper = component.get("v.mapShippingLocationWrapper");
        var depotSegmentOptions = component.get("v.depotSegmentOptions");
        var depotSegmentvalue = component.get("v.depotSegmentvalue");
        var depoId = '';
        console.log("Populate shipping address");
        var action = component.get("c.populateShippingAddress");        
        action.setParams({ 
            mapShippingLocationWrapper_str : JSON.stringify(mapShippingLocationWrapper),
            selectedAddress : selectedShippingAdd
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retVal = response.getReturnValue();
                component.set("v.selectedShippingLocation", retVal);
                depoId = retVal.depoId;
                console.log('Depot Id:'+depoId);
                var segment = '';
                
                var storageIdChosen = component.get("v.storageIdChosen");
                if(!helper.isBlank(depoId) && depoId != storageIdChosen){
                    var toPopulate = false;
                    for(var i in listDepot){
                        if((listDepot[i].Id).toString().substring(0, 15) == depoId.toString().substring(0, 15)){
                            toPopulate = true;
                            depoId = listDepot[i].Id;
                            segment = listDepot[i].Segment__c;
                            break;
                        }
                    }
                    if(!helper.isBlank(segment) && depotSegmentvalue != segment){
                        var segmentToSet = '';
                        var storageLocListToSet = [];
                        var allSKUs = component.get("v.wrapObj_SKU_Details_All");
                        var filteredSKUs = [];

                        for(var i in depotSegmentOptions){
                            if(depotSegmentOptions[i].value == segment){
                                segmentToSet = depotSegmentOptions[i].value;
                                break;
                            }
                        }
                        for(var i in storageLocList){
                            //Updated by Varun Shrivastava: Start: SCTASK0380343
                            if(storageLocList[i].Segment__c == segmentToSet){
                            //if(storageLocList[i].Segment_Name__c != null & storageLocList[i].Segment_Name__c.contains(segmentToSet)){
                            //Updated by Varun Shrivastava: End: SCTASK0380343
                                storageLocListToSet.push(storageLocList[i]);
                            }
                        }
                        
                        for(var i in allSKUs){
                            if(allSKUs[i].divisionCode == segmentToSet){
                                filteredSKUs.push(allSKUs[i]);
                            }
                        }
                        component.set("v.wrapObj_SKU_Details", filteredSKUs);
                        component.set("v.depotSegmentvalue", segmentToSet);
                        component.set("v.StorageLocationList", storageLocListToSet);
                    }
                }
                var finalStorageId = storageIdChosen;
                if(!helper.isBlank(depoId)){finalStorageId = depoId}
                component.set("v.showSpinner", false);
                helper.getInvDetails(component, event, helper, finalStorageId);
                
            }else{
                alert('Error in Server side : onShippingAddressChange');
                component.set("v.showSpinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    //This will consider only Mexican Currency > 80000
    //Need Confirmation for functionality
    minimumOrderValidation : function(component, event, helper){
        var orderSummaryCurrencyList = component.get("v.orderSummaryCurrencyList");
        var totalValue = 0;
        var toCheck = false;
        for(var i in orderSummaryCurrencyList){
            if(orderSummaryCurrencyList[i].currencyName == 'MXN'){
                toCheck = true;
                totalValue += orderSummaryCurrencyList[i].totalValue;
            }
        }
        if(toCheck && totalValue < 80000){
            var msg = $A.get("$Label.c.Mexico_Order_Validation"); 
            if(confirm(msg)){
                component.set("v.totalOrderAmount", totalValue);
                return true;
            }else{
                return false;
            }
        }else{
            return true;
            component.set("v.totalOrderAmount", totalValue);
        }
    },
    
    fieldValidations : function(component, event, helper){
        var errorMessage = '';
        
        //Validation begains:
        var oderlist = component.get("v.OrderItemList");
        var loginCotry = component.get("v.loginCountryObjs"); // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022
        if(helper.isBlank(oderlist)){
            errorMessage = $A.get("$Label.c.Please_add_product_to_cart");
            this.showPopup(component, event, helper, errorMessage);
            return false;
        }else{
            for(var i in oderlist){
                if(oderlist[i].qty == 0){
                    errorMessage = $A.get("$Label.c.Please_Enter_Quantity_for_all_SKU_s_before_confirming_order");
                    this.showPopup(component, event, helper, errorMessage);
                    return false;
                    break;
                }
                /* -------------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022----------------- */
                if(oderlist[i].customerDeliveryDate == undefined && loginCotry.Delivery_Date__c==true ){
                    errorMessage = 'Please Select customer Delivery Date for all sku before confirming Order';
                    this.showPopup(component, event, helper, errorMessage);
                    return false;
                    break;
                }
                /* -----------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022------------------- */
            }
        }
        
        if(component.find("pay_method").get("v.value") == 'None'){
            errorMessage = $A.get("$Label.c.Please_select_Payment_Method");
            this.showPopup(component, event, helper, errorMessage);
            return false;
        }
        if(component.find("pay_term").get("v.value") == 'None'){
            errorMessage = $A.get("$Label.c.Please_select_Payment_Terms");
            this.showPopup(component, event, helper, errorMessage);
            return false;
        }
        if(component.find("inco_term").get("v.value") == 'None'){
            errorMessage = $A.get("$Label.c.Please_Select_Inco_Terms");
            this.showPopup(component, event, helper, errorMessage);
            return false;
        }
        if(component.find("shipping_address").get("v.value") == 'Select shipping location'){
            errorMessage = $A.get("$Label.c.Please_select_Shipping_Address");
            this.showPopup(component, event, helper, errorMessage);
            return false;
        }
        
        
        
        var isEdit = false;
        var typeOrder = component.get("v.typeOfOrder");
        if(typeOrder == 'Edit'){isEdit = true;}
        
        if(!isEdit){
            if(this.isBlank(component.get("v.PONumber"))){
                errorMessage = $A.get("$Label.c.Please_Enter_PO_Number");
                this.showPopup(component, event, helper, errorMessage);
                return false;
            }
            var fileInput = component.find("file_input").get("v.files");
            if(this.isBlank(fileInput)){
                errorMessage = $A.get("$Label.c.Please_upload_file");
                this.showPopup(component, event, helper, errorMessage);
                return false;
            }
        }
        if(component.get("v.allowTemplate") && helper.isBlank(component.get("v.TemplateName"))){
            errorMessage = $A.get("$Label.c.Please_Enter_Template_Name");
            this.showPopup(component, event, helper, errorMessage);
            return false;
        }
        if(helper.isBlank(component.find("shipping_address").get("v.value"))){
            errorMessage = $A.get("$Label.c.Please_select_Shipping_Address");
            this.showPopup(component, event, helper, errorMessage);
            return false;
        }
        
        /* ------------Start SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022------------- */  
        var pdtDate = component.get("v.poDate");
        console.log('dasdadasdsadasd '+pdtDate); 
        if(pdtDate == null && loginCotry.PO_Date__c== true){
            //errorMessage = $A.get("$Label.c.Please_select_Shipping_Address");
            errorMessage = 'Please Select PO Date';
            this.showPopup(component, event, helper, errorMessage);
            return false;
        }else{
            /* var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"); // commented as requested by client..
            if(pdtDate<today){
                errorMessage = 'PO Date should be future date only';
                this.showPopup(component, event, helper, errorMessage);
                return false;
            } */
        }
        /* ------------End SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022-------------- */
        
        return true;
    },
    
    confirmTheOrder : function(component, event, helper){
        component.set("v.showSpinner", true);
        var orderObj = component.get("v.orderObj");
        var OrderItemList = component.get("v.OrderItemList");
        var wrapObj_Distri_Details = component.get("v.wrapObj_Distri_Details");
        var wrapObj_Init_Details = component.get("v.wrapObj_Init_Details");
        var selectedShippingLocation  = component.get("v.selectedShippingLocation");
        
        var isEdit = false;
        var typeOrder = component.get("v.typeOfOrder");
        var soDetails = component.get("v.SalesOrderDetails");
        if(typeOrder == 'Edit'){isEdit = true;}
        var soObj = {};
        
        if(isEdit && !helper.isBlank(soDetails)){
            if(!helper.isBlank(soDetails.soObj.Id)){
                soObj = soDetails.soObj;
            }
        }
        console.log('isEdit-->'+isEdit);
        var action = component.get("c.confirmOrder");
        action.setParams({
            skuOrderList_str : JSON.stringify(OrderItemList),
            orderObj : orderObj,
            templateName : component.get("v.TemplateName"),
            totalOrderAmount : component.get("v.totalOrderAmount"),
            payment_method : component.find("pay_method").get("v.value"),
            payment_term : component.find("pay_term").get("v.value"),
            inco_term : component.find("inco_term").get("v.value"),
            getDetailsWrap_str : JSON.stringify(wrapObj_Init_Details),
            storageIdChosen : component.get("v.storageIdChosen"),
            po_num : component.get("v.PONumber"),
            distWrapObj_str : JSON.stringify(wrapObj_Distri_Details),
            selectedShippingLocation_str : JSON.stringify(selectedShippingLocation),
            isEdit : isEdit,
            sorderObj : soObj,
            opportunityId : component.get("v.oppId"), //Added By Nishi to link opportunity
            remark : component.get("v.Remark"),
            depotSegmentvalue : component.get("v.depotSegmentvalue"),
            poDate : component.get("v.poDate")                      // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var salesOrderList = response.getReturnValue();
                if(isEdit){
                    var soIdToRedirect = salesOrderList[0].Id;
                    var soName = salesOrderList[0].Name;
                    var message = $A.get("$Label.c.Sales_Order")+' '+soName+' '+$A.get("$Label.c.edited_successfully");
                    
                    component.set("v.messageSalesOrder", message);
                    component.set("v.soIdToRedirect", soIdToRedirect);
                    helper.toggle(component, event, helper, 'lookupmodal6', 'backdrop6');
                    component.set("v.showSpinner", false);
                }else{
                    var message = $A.get("$Label.c.Order_Confirmed_Order_Number");
                    var soIdToRedirect = '';
                    for(var i in  salesOrderList){
                        if(salesOrderList.length > 1){
                            message = message +' '+salesOrderList[i].Name+',';
                        }else{
                            message = message +' '+salesOrderList[i].Name;
                        }
                    }
                    soIdToRedirect = salesOrderList[0].Id;
                    component.set("v.messageSalesOrder", message);
                    component.set("v.soIdToRedirect", soIdToRedirect);
                    helper.toggle(component, event, helper, 'lookupmodal6', 'backdrop6');
                    component.set("v.showSpinner", false);
                }
            }else if(state === "INCOMPLETE"){
                component.set("v.showSpinner", false);
                alert("From server: UOM Conversion data not found " + response.getReturnValue());
            }else if(state === "ERROR"){
                component.set("v.showSpinner", false);
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        alert("Error message: "+errors[0].message); // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022
                    }
                }else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    
    redirectToSobject: function (component, event, helper, recordId) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId,
            "slideDevName": "Detail"
        });
        navEvt.fire();
    },
    
    gotoURL : function(component, recordId) {
        var device = $A.get("$Browser.formFactor");
        var recrdId = recordId;

        if(device=='DESKTOP'){
            try{
                //sforce.one.navigateToSObject(recordId);
                //Modified by Deeksha : For full screen
                var urlInstance = window.location.hostname;
                var baseURL = 'https://'+urlInstance+'/lightning/r/Sales_Order__c/'+recrdId+'/view';
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": baseURL
                });
                urlEvent.fire();
                //END:Modified by Deeksha : For full screen
            }catch(err){
                console.log('catch for redirect issue');
                this.navigateToComponent(component,recrdId);
            }
        }
        else{
            console.log('else url'+recordId);
            //sforce.one.navigateToSObject(recordId);
            //Modified by Deeksha : For full screen
                var urlInstance= window.location.hostname;
                var baseURL = 'https://'+urlInstance+'/lightning/r/Sales_Order__c/'+recrdId+'/view';
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": baseURL
                });
                urlEvent.fire();
                //END:Modified by Deeksha : For full screen
        }
    },
   
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
            console.log('in history back');
            var urlInstance= window.location.hostname;
            //https://upl--hotfix.lightning.force.com/lightning/r/Sales_Order__c/a1E5D000001GdsfUAC/view
            var baseURL = 'https://'+urlInstance+'/lightning/r/Sales_Order__c/'+recrdId+'/view';
            window.location.href = baseURL;
         
        }
    },
    
    showToast : function(component, event, helper, type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message: message,
            duration:' 5000',
            key: 'info_alt',
            type: type,
        });
        toastEvent.fire();
    },
    
    selectTemplate : function(component, event, helper){ 
        helper.toggle(component, event, helper, 'lookupmodal5', 'backdrop5');
        component.set("v.showSpinner", true);
        var target = event.target;
        var currentRow = target.getAttribute("data-row-index");
        var templateList = component.get("v.TemplateList");
        var selectedTemplateId = templateList[currentRow].Id;
        var orderObj = component.get("v.orderObj");
        var initDetails = component.get("v.wrapObj_Init_Details");
        var distributerDetail = component.get("v.wrapObj_Distri_Details");
        
        var action = component.get("c.loadTemplate");
        action.setParams({ 
            orderObj : orderObj,
            tempIdChosen : selectedTemplateId,
            getDetailsWrap_str : JSON.stringify(initDetails),
            distWrapObj_str : JSON.stringify(distributerDetail)
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var retVal = response.getReturnValue();
                component.set("v.PaymentMethod", retVal.payment_Methods);
                component.set("v.PaymentTerm", retVal.payment_Terms);
                component.set("v.IncoTerm", retVal.inco_Terms);
                component.set("v.wrapObj_SKU_Details", retVal.skuDetailList);
                component.set("v.OrderItemList", retVal.skuOrderList);
                component.set("v.orderSummaryUOMList", retVal.orderSummaryUOMList);
                component.set("v.orderSummaryCurrencyList", retVal.orderSummaryCurrencyList);
                component.set("v.showSpinner", false);
            }else if(state === "INCOMPLETE"){
                component.set("v.showSpinner", false);
            }else if(state === "ERROR"){
                component.set("v.showSpinner", false);
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error message: " + errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    //Upload File Controller
    MAX_FILE_SIZE: 26214400, //Max file size 25 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
    
    uploadHelper: function(component, event, helper){
        component.set("v.showSpinner", true);
        var fileInput = component.find("file_input").get("v.files");
        var file = fileInput[0];
        var self = this; 
        
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.showSpinner", false);
            alert('Attachment size not supported');
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return false;
        }
        
        var objFileReader = new FileReader(); 
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
            self.uploadProcess(component, file, fileContents);
        });
        objFileReader.readAsDataURL(file);
        return true;
    },
    
    uploadProcess: function(component, file, fileContents) {
        var startPosition = 0; 
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
    },
    
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
        var getchunk = fileContents.substring(startPosition, endPosition);
        var orderObj = component.get("v.orderObj");
        var action = component.get("c.saveChunk");
        action.setParams({
            parentId: orderObj.Id,
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
        });
        
        action.setCallback(this, function(response){
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS"){
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
                }else{
                    if(attachId!=null && attachId!='')
                    component.set("v.showSpinner", false);
                }       
            }else if(state === "INCOMPLETE"){
                component.set("v.showSpinner", false);
                alert("From server: " + response.getReturnValue());
            }else if(state === "ERROR"){
                component.set("v.showSpinner", false);
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error message: " + errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getInvDetails : function(component, event, helper, storageIdChosen){
        component.set("v.showSpinner", true);
        var OrderItemList = component.get("v.OrderItemList");
        var wrapObj_Init_Details = component.get("v.wrapObj_Init_Details");
        var skuList = component.get("v.wrapObj_SKU_Details");
        var selectedSKU = component.get("v.SingleOrderItem");
        
        var OrderItemList_str = null;
        var skuList_str = null;
        var selectedSKU_str = null;
        
        if(!helper.isBlank(OrderItemList)){
            OrderItemList_str = JSON.stringify(OrderItemList);
        }
        if(!helper.isBlank(skuList)){
            skuList_str = JSON.stringify(skuList);
        }
        if(!helper.isBlank(selectedSKU)){
            selectedSKU_str = JSON.stringify(selectedSKU);
            
        }
        
        
        var action = component.get("c.getInventoryDetails");
        action.setParams({
            getDetailsWrap_str : JSON.stringify(wrapObj_Init_Details),
            skuOrderList_str : OrderItemList_str,
            skuObjList_str : skuList_str,
            selectedSKU_str : selectedSKU_str,
            storageIdChosen : storageIdChosen
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var retVal = response.getReturnValue();
                //component.set("v.OrderItemList", retVal.skuOrderList); // SKI(Vishal P) : #CR152 : PO And Delivery Date : 18-07-2022
                component.set("v.wrapObj_SKU_Details", retVal.skuObjList);
                component.set("v.SingleOrderItem", retVal.selectedSKU); 
                component.set("v.storageIdChosen", storageIdChosen);
                helper.setDefaultCrop(component, event, helper, retVal.selectedSKU);
                component.set("v.showSpinner", false);
            }
            else if(state === "INCOMPLETE"){
                component.set("v.showSpinner", false);
                alert("From server: " + response.getReturnValue());
            }else if(state === "ERROR"){
                component.set("v.showSpinner", false);
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error message: " + errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    showPopup : function(component, event, helper, errorMessage){
        component.set("v.ErrorMessage", errorMessage);
        component.set("v.showMessageButton", true);
        component.set("v.showFinalCheckButtons", false);
        component.set("v.showFinalCheckButtons_Bulk", false);
        helper.toggle(component, event, helper, 'lookupmodal3', 'backdrop3');
    },
    
    calculateUOMCurrencyTotal : function(component, event, helper, OrderItemList){
        var uomMap = new Map();
        var currMap = new Map();
        if(!helper.isBlank(OrderItemList)){
            for(var i in OrderItemList){
                var skuObj = OrderItemList[i];
                
                if(uomMap.has(skuObj.uOM)){
                    var objUOM = uomMap.get(skuObj.uOM);
                    objUOM['totalQty'] = objUOM['totalQty'] + skuObj.qty;
                    uomMap.set(skuObj.uOM, objUOM);
                }
                else{
                    uomMap.set(skuObj.uOM, {'UOM' : skuObj.uOM, 'totalQty' : skuObj.qty});
                }
                
                if(currMap.has(skuObj.currencyIso)){
                    var objCurr = currMap.get(skuObj.currencyIso);
                    objCurr['totalValue'] = objCurr['totalValue'] + skuObj.netRateEntered;
                    currMap.set(skuObj.currencyIso, objCurr);
                }
                else{
                    currMap.set(skuObj.currencyIso, {'currencyName' : skuObj.currencyIso,
                                                     'totalValue' : skuObj.netRateEntered});
                }
            }
            var uomList = [];
            var currList = [];
            uomMap.forEach((values,keys)=>
                           {uomList.push(values);
                           });
                            
            currMap.forEach((values,keys)=>
                            {currList.push(values);
                           });
                                           
            component.set("v.orderSummaryUOMList", uomList);
            component.set("v.orderSummaryCurrencyList", currList);
        }
        else{
            component.set("v.orderSummaryUOMList", []);
            component.set("v.orderSummaryCurrencyList", []);
        }
    }
})