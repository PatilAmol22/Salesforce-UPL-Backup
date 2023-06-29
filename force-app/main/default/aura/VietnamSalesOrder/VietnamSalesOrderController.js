({
    doInit: function(component, event, helper) {
        
        var recordId = component.get("v.recordId");
        console.log('recordId.... : '+ recordId);
        component.find("skuId").makeDisabled(true); // to disable sku search pill 
        //component.set("v.fileName", "");
        if(recordId != '' || recordId != null){
            var newMp = new Map();
            component.set("v.campaignMap",newMp);
            component.set("v.skuMap",newMp);
            component.set("v.orderForMap",newMp);
            helper.orderDetails(component, event, helper);
        }
    }, 

    onShippingChange:function(component, event, helper){
        var locId = event.getSource().get("v.value");
        console.log('locId ... - ', locId);
        //var ordTyp = component.find("shipping_address").get("v.value"); 
        var ordrWrap = component.get("v.orderWrapper");
        var shippingMap = component.get("v.shippingMap");
        if(locId == null || locId == ''){
            ordrWrap.shipping_loc_details = '';
        }
        else{
            var obj = new Object();
            obj=  shippingMap[locId];
            console.log('Ship Adr ... - ',JSON.stringify(shippingMap[locId]));
            ordrWrap.shipping_loc_details = '';
            if(obj.Billing_Street_1__c != 'None'){
                ordrWrap.shipping_loc_details = obj.Billing_Street_1__c;
            }
            else if(obj.Billing_Street_2__c != 'None'){
                ordrWrap.shipping_loc_details = ordrWrap.shipping_loc_details + ', ' + obj.Billing_Street_2__c;
            }
            else if(obj.Billing_Street_3__c != 'None'){
                ordrWrap.shipping_loc_details = ordrWrap.shipping_loc_details + ', ' + obj.Billing_Street_3__c;
            }
            else if(obj.Billing_Street_4__c != 'None'){
                ordrWrap.shipping_loc_details = ordrWrap.shipping_loc_details + ', ' + obj.Billing_Street_4__c;
            }
            else if(obj.Billing_Street_5__c != 'None'){
                ordrWrap.shipping_loc_details = ordrWrap.shipping_loc_details + ', ' + obj.Billing_Street_5__c;
            }
            else if(obj.Billing_Street_6__c != 'None'){
                ordrWrap.shipping_loc_details = ordrWrap.shipping_loc_details + ', ' + obj.Billing_Street_6__c;
            }
            else if(obj.Region__c != 'None'){
                ordrWrap.shipping_loc_details = ordrWrap.shipping_loc_details + ', ' + obj.Region__c;
            }
            if(obj.Country_Name__c != 'None'){                          // country name field is used for refence as City name..
                ordrWrap.shipping_loc_details = ordrWrap.shipping_loc_details + ', ' + obj.Country_Name__c;
            }
            if(obj.State__c != 'None'){
                ordrWrap.shipping_loc_details = ordrWrap.shipping_loc_details + ', ' + obj.State__c;
            }
            if(obj.Pincode__c != 'None'){
                ordrWrap.shipping_loc_details = ordrWrap.shipping_loc_details + ', ' + obj.Pincode__c;
            }
        }
        component.set("v.orderWrapper",ordrWrap);
       },

       onOrderForChange:function(component, event, helper){
        var ordFr = component.find("order_for").get("v.value");
        if(ordFr!=''|| ordFr!=null){
            helper.handleOrderForChng(component, event, helper);
        }
       },

       handleSKUChange:function(component, event, helper){
            console.log('JSON Normal test - ', JSON.stringify(component.get("v.selectedPBRecord")));
            console.log('JSON parse test - ', JSON.parse(JSON.stringify(component.get("v.selectedPBRecord"))));
            var pb = JSON.parse(JSON.stringify(component.get("v.selectedPBRecord")));
            var pbWrap = JSON.parse(JSON.stringify(component.get("v.priceBookWrap")));
            var ordrWrap = component.get("v.orderWrapper");
            //console.log('handleSKUChange ', pb.Id);
        
            if(pb.Id != undefined){

                if(ordrWrap.Depo_Obj == null || ordrWrap.Depo_Obj == ''){
                    component.find("depo_id").focus();
                    var toastEvent1 = $A.get("e.force:showToast");
                    var msg  = $A.get("{!$Label.c.Please_Select_Depot}");
                    var titl  = $A.get("{!$Label.c.Error}");
                    toastEvent1.setParams({
                        "title": titl,
                        "type": "Error",
                        "message": msg
                        //"duration":'3000'
                    });
                    toastEvent1.fire();
                    component.find("skuId").makeReset(false); // to reset sku search pill
                }
                else{

                    if(ordrWrap.businessTypeName == 'B2C'){
                        pbWrap.pb_id = pb.Id;
                        pbWrap.sku_name = pb.SKUCode__r.SKU_Description__c;
                        pbWrap.sku_id = pb.SKUCode__r.Id;
                        pbWrap.uom = pb.UOM__c;
                        pbWrap.base_price = pb.Price__c;
                        pbWrap.distributionChanlIds = pb.DistributionChannel__c;
                        pbWrap.divisionIds = pb.Division__c;
                        pbWrap.pack_size = pb.SKUCode__r.Pack_Size__c;

                        component.set("v.priceBookWrap",pbWrap);
                        helper.getInventory(component, event, helper);
                    }
                    else if(ordrWrap.businessTypeName == 'B2B'){
                        pbWrap.pb_id = '';
                        pbWrap.sku_name = pb.SKU_Description__c;
                        pbWrap.sku_id = pb.Id;
                        pbWrap.uom = pb.UOM__c;
                        pbWrap.base_price = 0;
                        pbWrap.distributionChanlIds = pb.Distribution_Channel__c;
                        pbWrap.divisionIds = pb.Division__c;
                        pbWrap.pack_size = pb.Pack_Size__c;

                        component.set("v.priceBookWrap",pbWrap);
                        helper.getInventory(component, event, helper);
                    }
                    else{
                        helper.bussinessTypeError(component, event, helper);
                    }
                
                }
                //component.set("v.priceBookWrap",pbWrap);
            }
            else{
                
                var action = component.get('c.resetPBObj');     // call one method from other method..
                $A.enqueueAction(action); 
                
            }
        
        },

        handleDepoChange:function(component, event, helper){
            console.log('handleDepoChange - '); 
            var ordrWrap = component.get("v.orderWrapper");
            //var ordrFor = component.get("v.orderForWrap");
            
            var divsn = component.get("v.divisionIds");
            var distChnl = component.get("v.distributionChnlIds");

              if(ordrWrap.businessTypeName == 'B2C'){
                //var filtr = "AND DepotCode__c =\'"+ ordrWrap.Depo_Obj+"\' AND DistributionChannel__c  IN "+ distChnl +" AND Division__c IN "+ divsn +" AND Sales_Org__c =\'"+ ordrWrap.salesOrgObj+"\' AND Price__c != null AND StartDate__c <= TODAY AND EndDate__c >= TODAY ORDER BY LastModifiedDate DESC ";
                var filtr = "AND DistributionChannel__c  IN "+ distChnl +" AND Division__c IN "+ divsn +" AND Sales_Org__c =\'"+ ordrWrap.salesOrgObj+"\' AND Price__c != null AND StartDate__c <= TODAY AND EndDate__c >= TODAY ORDER BY LastModifiedDate DESC ";
                component.set("v.PriceBookFilter",filtr);
              }

        },

       addSKU:function(component, event, helper){
        var pbWrap = JSON.parse(JSON.stringify(component.get("v.priceBookWrap")));
        var skuMap = new Map(component.get("v.skuMap"));
        var showDel = component.get("v.showDeliveryDate");  // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022
        var reqDel = component.get("v.isDeliveryDateReq");  // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022
        var error = false;
        /* ------------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------------------- */
        //var today = new Date(); // for current date..
        var crDt = new Date();
        var d = (crDt.getDate() < 10 ? '0' : '') + crDt.getDate();
        var M = ((crDt.getMonth() + 1) < 10 ? '0' : '') + (crDt.getMonth() + 1);
        var y = crDt.getFullYear();
        var currentDt = (y + "-" + M + "-" + d);
        var yy = new Date(currentDt);
        
        var today = new Date(crDt.getTime() + 86400000); // for current date + 1 ...
        var z = '';
        /* --------------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------------------ */
        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        var currentDate = (yyyy + "-" + MM + "-" + dd); 

        var x = new Date(component.find("shipment_dt").get("v.value"));
        var y = new Date(currentDate);
        
        var errMsg = '';   

        if(pbWrap == null){
            error = true;
            errMsg = $A.get("{!$Label.c.SKU_Not_Selected}");             
        }
        else if(pbWrap.sku_id == '' || pbWrap.sku_id == null){
            error = true;
          //  component.find("skuId").focus();
            errMsg = $A.get("{!$Label.c.Please_Select_SKU}");            
        }
        /* else if(skuMap.has(pbWrap.sku_id)){   // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022
            error = true;
            errMsg = $A.get("{!$Label.c.Duplicate_entries_are_not_allowed}"); 
        }  */
        else if(pbWrap.base_price <= 0){
            error = true;
            component.find("base_price").focus();
            errMsg = $A.get("{!$Label.c.SKU_With_Base_Price_Zero_Can_Not_Be_Added}");
        }
        /* else if(pbWrap.campaign_id == '' || pbWrap.campaign_id == null){
            error = true;
            component.find("campaign_id").focus();
            errMsg = $A.get("{!$Label.c.Please_Select_Campaign}");
        } */
        else if(pbWrap.quantity <= 0){
            error = true;
            component.find("quantity").focus();
            errMsg = $A.get("{!$Label.c.Please_enter_Quantity}");
        }
        else if(+x < +yy){    // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 // shipment date greated than today...
            error = true;
            component.find("shipment_dt").focus();
            errMsg = $A.get("{!$Label.c.Shipment_Date_Can_Not_Be_Less_Than_Today}");
        }
        /* --------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 --------------------- */
        else if(showDel == true){
            var dt = component.find("delvery_date").get("v.value");
            if(dt == null){
                dt = '';
                z = '';
            }
            else{
                z = new Date(dt);
            }            
            if(reqDel == true && dt == ""){
                error = true;
                component.find("delvery_date").focus();
                errMsg = $A.get("{!$Label.c.Delivery_Date_is_Required}");
            }
            else if(dt != "" && +z < +y){
                error = true;
                component.find("delvery_date").focus();
                errMsg = $A.get("{!$Label.c.Date_of_delivery_should_not_be_less_than_todays_date}");
            }
            else if(dt == ""){
                z = '';
            }
        }
        /* ----------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ----------------------- */
        if(error == true){
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
        else{
            component.set("v.orderForDisable",true);
            var ordItem = component.get("v.orderItemWrapList");
            var itemObj = new Array();
            itemObj = {
                'orderItem_id' : '',
                'order_id' : '' ,
                'pb_id' : pbWrap.pb_id,
                'sku_name' : pbWrap.sku_name,
                'sku_id' : pbWrap.sku_id,
                'uom' : pbWrap.uom,
                'base_price' : pbWrap.base_price,
                'special_discount' : pbWrap.special_discount,
                'boxes' : pbWrap.boxes,
                'pack_size' : pbWrap.pack_size,
                'net_rate' : pbWrap.net_rate,
                'net_value' : pbWrap.net_value,
                'quantity' : pbWrap.quantity,
                'shipmnt_date' : x,                         //pbWrap.shipmnt_date,
                'inventory' : pbWrap.inventory,
                'comment' : pbWrap.comment,
                'distributionChanlIds' : pbWrap.distributionChanlIds,
                'divisionIds' : pbWrap.divisionIds,
                'itemNumber' : 0,
                'deliveryDate' : z  // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022
            };

            ordItem.push(itemObj);
            //ordItem = JSON.parse(JSON.stringify(ordItem));
            component.set('v.orderItemWrapList',ordItem);
            skuMap.set(pbWrap.sku_id,pbWrap.sku_id);
            component.set("v.skuMap",skuMap);
            
            var action1 = component.get('c.calculateTotalAmt');
            $A.enqueueAction(action1); 

            /* var action2 = component.get('c.calculateGrossAmt');     // call one method from other method..
            $A.enqueueAction(action2);  */

            component.find("skuId").makeReset(false); // to reset sku search pill
            var action3 = component.get('c.resetPBObj');     // call one method from other method..
            $A.enqueueAction(action3);  

            component.set("v.itemIndex",''); 
            component.set("v.indexFlag",false); 
            var action4 = component.get('c.draftOrder');
            $A.enqueueAction(action4);  
            
        }
       },

       calculatePriceAndDiscount:function(component, event, helper){
        var pbWrap = JSON.parse(JSON.stringify(component.get("v.priceBookWrap")));
        
        if(pbWrap.pack_size.length == 0){
            pbWrap.pack_size = 0.0;
        }
        if(pbWrap.base_price.length == 0){
            pbWrap.base_price = 0.0;
        }
        if(pbWrap.special_discount.length == 0){
            pbWrap.special_discount = 0.0;
        }
        if(pbWrap.boxes.length == 0){
            pbWrap.boxes = 0;
        }
    
        pbWrap.quantity = parseFloat(parseFloat(pbWrap.pack_size) * parseInt(pbWrap.boxes)).toFixed(2);
                
        var finl_prc = parseFloat(parseFloat(pbWrap.base_price) - ((parseFloat(pbWrap.base_price) * parseFloat(pbWrap.special_discount)) / 100));
        //added by vishal
        var format = new Intl.NumberFormat('en-US', {
                minimumFractionDigits: 2,
            });
           
           // console.log('result is '+format.format(147121221.1512));   
           
           //commented By Vishal
           //pbWrap.net_rate = finl_prc;
           
           pbWrap.net_rate = format.format(finl_prc);

        var net_prc = parseFloat(parseFloat(pbWrap.quantity) * finl_prc).toFixed(2);
           
           //commented by vishal   
           //pbWrap.net_value = net_prc;
          //Added by vishal
           pbWrap.net_value = format.format(net_prc);

        console.log('pbWrap.quantity ', pbWrap.quantity);
        console.log('finl_prc ', finl_prc);
        console.log('net_prc ', net_prc);

        component.set("v.priceBookWrap",pbWrap);
       /*  var action = component.get('c.calculateGrossAmt');     // call one method from other method..
        $A.enqueueAction(action);  */
       },

       calculatePrice:function(component, event, helper){
        var target = event.getSource();  
        var index = target.get("v.name"); 
        var ordItem = component.get("v.orderItemWrapList"); 
        var pbWrap = new Object(ordItem[index]); 

        component.set("v.itemIndex",index); 
        component.set("v.indexFlag",true);

        if(pbWrap.pack_size.length == 0){
            pbWrap.pack_size = 0.0;
        }
        if(pbWrap.base_price.length == 0){
            pbWrap.base_price = 0.0;
        }
        if(pbWrap.special_discount.length == 0){
            pbWrap.special_discount = 0.0;
        }
        if(pbWrap.boxes.length == 0){
            pbWrap.boxes = 0;
        }
    
        pbWrap.quantity = parseFloat(parseFloat(pbWrap.pack_size) * parseInt(pbWrap.boxes)).toFixed(2);
                
           var finl_prc = parseFloat(parseFloat(pbWrap.base_price) - ((parseFloat(pbWrap.base_price) * parseFloat(pbWrap.special_discount)) / 100));
           
           //Added by vishal
           var format = new Intl.NumberFormat('en-US', {
               minimumFractionDigits: 2,
           });
           
           //added by vishal
           //pbWrap.net_rate = finl_prc;
           pbWrap.net_rate = format.format(finl_prc);

        var net_prc = parseFloat(parseFloat(pbWrap.quantity) * finl_prc).toFixed(2);
           
            // for 4800 INR
            //format.format(147121221.1512);
           
           
           //Commented By vishal
           //pbWrap.net_value = net_prc;
           
           pbWrap.net_value = format.format(net_prc);

        ordItem[index] = pbWrap;
        component.set("v.orderItemWrapList",ordItem); 

        var action1 = component.get('c.calculateTotalAmt');
        $A.enqueueAction(action1); 

       
        var action4 = component.get('c.draftOrder');
            $A.enqueueAction(action4);  
       },
      
       deleteSKU:function(component, event, helper){
        component.set("v.showSpinner", true);
        var target = event.getSource();  
        var index = target.get("v.value");
        var sku = component.get("v.orderItemWrapList");
        var obj = target.get("v.name"); 
        var ordWrap = component.get("v.orderWrapper");
        var type = '';
        var skuMap = new Map(component.get("v.skuMap"));
        //var early_dis = component.find("early_ord_discount").get("v.value");
        console.log('deleteSKU Id- ',obj);

        if(skuMap.size>0){
            if(skuMap.has(sku[index].sku_id)){
                skuMap.delete(sku[index].sku_id);
                component.set("v.skuMap",skuMap);
            }
        } 

        if(obj.length==0){
            var action1 = component.get('c.calculateTotalAmt');
            $A.enqueueAction(action1); 

            /* var action = component.get('c.calculateGrossAmt');     // call one method from other method..
            $A.enqueueAction(action); */ 

            if (index > -1) {
                sku.splice(index, 1);
            }
            component.set("v.orderItemWrapList", sku);
            if(sku.length == 0){
                component.set("v.disableTmDepo",false);
                if(ordWrap.isSalesOrder == false){
                    if(component.get("v.orderForList").length >1){
                        component.set("v.orderForDisable",false);
                    }
                }
            }
            component.set("v.showSpinner", false);
        }
        else{
            
            if(ordWrap.isSalesOrder == true){
                type = 'Sales Order';
            }
            else{
                type = 'Order';
            }

            var action = component.get("c.deleteLineItem");
            action.setParams({
                itemId : obj,
                type :type,
                netPrc :parseFloat(sku[index].net_value)
               // grsPrc :parseFloat(parseFloat(sku[index].net_price) -  (parseFloat(early_dis) * parseFloat(sku[index].net_price)) / 100).toFixed(2),
                
            });

            action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                
            var resp = response.getReturnValue();
            console.log('Response.... ',resp);
            if(resp != null){
                if(resp == true){
                    var action1 = component.get('c.calculateTotalAmt');
                    $A.enqueueAction(action1); 

                    /* var action = component.get('c.calculateGrossAmt');     // call one method from other method..
                    $A.enqueueAction(action); */ 

                    if (index > -1) {
                        sku.splice(index, 1);
                    }
                    component.set("v.orderItemWrapList", sku);
                    if(sku.length == 0){
                        component.set("v.disableTmDepo",false);
                        if(ordWrap.isSalesOrder == false){
                            if(component.get("v.orderForList").length >1){
                                component.set("v.orderForDisable",false);
                            }
                        }
                    }
                    var errMsg = $A.get("{!$Label.c.Line_Item_Deleted}");
                    var toastEvent1 = $A.get("e.force:showToast");
                    var titl  = $A.get("{!$Label.c.Success}");
                    toastEvent1.setParams({
                        "title": titl,
                        "type": "Success",
                        "message": errMsg
                        //"duration":'3000'
                    });
                    toastEvent1.fire();

                } 
            }
            
            }
            component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }
       },

       deleteAllSKU:function(component, event, helper){
        
        var sku = component.get("v.orderItemWrapList");  
        var skuMap = new Map(component.get("v.skuMap"));

        if(skuMap.size>0){
            skuMap.clear();
            component.set("v.skuMap",skuMap);
        }

        if(sku.length > 0){     
            component.set("v.showSpinner", true);
            var ordWrap = component.get("v.orderWrapper");
            var type = '';     
            var ordId = '';  
            
            if(ordWrap.isSalesOrder == true){
                type = 'Sales Order';
                ordId = ordWrap.so_id;
            }
            else{
                type = 'Order';
                ordId = ordWrap.ordr_id;
            }

            var action = component.get("c.deleteAllLineItem");
                action.setParams({
                ordrId : ordId,
                type :type
            });

            action.setCallback(this, function(response) {
                if (response.getState() == "SUCCESS") {
                    
                var resp = response.getReturnValue();
                console.log('Response.... ',resp);
                if(resp != null){
                    if(resp == true){
                        /* var action1 = component.get('c.calculateTotalAmt');
                        $A.enqueueAction(action1); 

                        var action = component.get('c.calculateGrossAmt');     // call one method from other method..
                        $A.enqueueAction(action); 
                        $A.get('e.force:refreshView').fire();
                        var sku = component.get("v.orderItemWrapList");
                        if(sku.length == 0){
                            if(ordWrap.isSalesOrder == false){
                                if(component.get("v.orderForList").length >1){
                                    component.set("v.orderForDisable",false);
                                }
                            }
                        } */
                        component.set("v.disableTmDepo",false);
                        var errMsg = $A.get("{!$Label.c.Line_Item_Deleted}");
                        var toastEvent1 = $A.get("e.force:showToast");
                        var titl  = $A.get("{!$Label.c.Success}");
                        toastEvent1.setParams({
                            "title": titl,
                            "type": "Success",
                            "message": errMsg
                            //"duration":'3000'
                        });
                        toastEvent1.fire();
                        $A.get('e.force:refreshView').fire();
                    } 
                }
                
                }
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }
        else{
            component.set("v.disableTmDepo",false);
        }
       },


       resetPBObj:function(component, event, helper){
        var pbWrap = JSON.parse(JSON.stringify(component.get("v.priceBookWrap")));
        var showDel = component.get("v.showDeliveryDate");   // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022
            //console.log('cmpgnId.... ',cmpgnId);
            pbWrap.pb_id = '';
            pbWrap.sku_name = '';
            pbWrap.sku_id = '';
            pbWrap.uom = '';
            pbWrap.base_price = 0.0;
            pbWrap.special_discount = 0.0;
            pbWrap.quantity = 0.0;
            pbWrap.pack_size = 0.0;
            pbWrap.boxes = 0.0;
            pbWrap.net_rate = 0.0;
            pbWrap.net_value = 0.0;
            pbWrap.inventory = 0.0;
            pbWrap.comment = '';
            pbWrap.distributionChanlIds = '';
            pbWrap.divisionIds = '';
            /* ------------------ Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 -------------------------- */           
            var crDt = new Date();
            var d = (crDt.getDate() < 10 ? '0' : '') + crDt.getDate();
            var M = ((crDt.getMonth() + 1) < 10 ? '0' : '') + (crDt.getMonth() + 1);
            var y = crDt.getFullYear();
            var currentDt = (y + "-" + M + "-" + d);
            var yy = new Date(currentDt);
            
            var today = new Date(crDt.getTime() + 86400000); // for current date + 1 ...
            /* ----------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 --------------------------- */
            var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
            var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
            var yyyy = today.getFullYear();
            var currentDate = (yyyy + "-" + MM + "-" + dd);
            /* ---------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 -------------------------- */
            component.find("shipment_dt").set("v.value", yy);
            if(showDel == true){
                component.find("delvery_date").set("v.value", currentDate);
            }
            /* --------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 --------------------------- */
            var lst = [];
            component.set("v.campaignDiscountList",lst); 
            
            
            component.set("v.priceBookWrap",pbWrap);
       },

       validateCurrentDate:function(component, event, helper){
        var target = event.getSource();  
        var val = target.get("v.value"); 
                
        //console.log('Item .. ', JSON.stringify(obj));
        //console.log('Date.. ', obj.shipmnt_date);
        
        var today = new Date();
        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        var currentDate = (yyyy + "-" + MM + "-" + dd); 

        var x = new Date(val);
        var y = new Date(currentDate);

        if(+x < +y){     // shipment date greated than today...
           
            target.focus();
            var errMsg = $A.get("{!$Label.c.Shipment_Date_Can_Not_Be_Less_Than_Today}");
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
        else{
           
        } 

       },

       validateDate:function(component, event, helper){
        var target = event.getSource();  
        var index = target.get("v.name"); 
        var ordItem = component.get("v.orderItemWrapList"); 
        var obj = new Object(ordItem[index]); 
        
        //console.log('Item .. ', JSON.stringify(obj));
        //console.log('Date.. ', obj.shipmnt_date);
        
        var today = new Date();
        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        var currentDate = (yyyy + "-" + MM + "-" + dd); 

        var x = new Date(obj.shipmnt_date);
        var y = new Date(currentDate);

        if(+x < +y){     // shipment date greated than today...
           
            target.focus();
            var errMsg = $A.get("{!$Label.c.Shipment_Date_Can_Not_Be_Less_Than_Today}");
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
        else{
            component.set("v.itemIndex",''); 
            component.set("v.indexFlag",false);
            var action4 = component.get('c.draftOrder');
            $A.enqueueAction(action4);  
        } 

       },

       calculateGrossAmt:function(component, event, helper){
        var ordWrap = component.get("v.orderWrapper");
        var early_dis = 1;
        var grosAmt = parseFloat(parseFloat(ordWrap.total_amount) -  (parseFloat(early_dis) * parseFloat(ordWrap.total_amount)) / 100).toFixed(2);
        
        //component.set("v.orderWrapper.gross_amount",grosAmt);
        
       },

       calculateTotalAmt:function(component, event, helper){
        var ordWrap = component.get("v.orderWrapper");
        var ordItem = component.get("v.orderItemWrapList");
        var i;
        var tot_amt = "0";
        var qun_kg = 0;
        var qun_kg_amt = 0;
        var qun_ltr = 0;
        var qun_ltr_amt = 0;
        

        for (i = 0; i < ordItem.length; i++) {
            var obj = new Object(ordItem[i]); 
           // console.log('@@@ obj.net_value '+obj.net_value);
            
           
            
            tot_amt = parseFloat(tot_amt) + parseFloat((obj.net_value).replace(/\$|,/g, ''));
           // console.log('@@@ tot_amt after add '+tot_amt);

            if(obj.uom.toUpperCase() == 'KG'){
                qun_kg = qun_kg + parseFloat(obj.quantity);
                //qun_kg_amt = qun_kg_amt + parseFloat(obj.net_value);
                
                qun_kg_amt = qun_kg_amt + parseFloat((obj.net_value).replace(/\$|,/g, ''));
            }
            else if(obj.uom.toUpperCase() == 'L'){
                
                qun_ltr = qun_ltr + parseFloat(obj.quantity);
                //qun_ltr_amt = qun_ltr_amt + parseFloat(obj.net_value);
                console.log('@@@@ new obj.net_value '+obj.net_value);
                qun_ltr_amt = qun_ltr_amt + parseFloat((obj.net_value).replace(/\$|,/g, ''));
                
            }
            

        }
           
           console.log(' new @@@ qun_ltr_amt '+qun_ltr_amt);
           
           
        
        //added by vishal
        var formated = new Intl.NumberFormat('en-US', {
                minimumFractionDigits: 2,
            });
           
		   var ltrQutyAmt = formated.format(qun_ltr_amt);
           console.log('ltrQutyAmt '+ltrQutyAmt); 
             
           
           console.log('tot_amt in changeing '+tot_amt);
           //commented by vishal
          // ordWrap.total_amount = parseFloat(tot_amt).toFixed(2);
          // this is for ltr
           var tmpQtyLtrAmt = qun_ltr_amt.toFixed(2);
           var tmpKgLtrAmt = qun_kg_amt.toFixed(2);
           
           console.log('tmpKgLtrAmt sad '+tmpKgLtrAmt);
          
           if(tmpQtyLtrAmt>0.00){
               console.log('inside true ltr');
               component.set("v.showLtrDiv",true);
           }
           
           //this is for KG
          var tmpQtyKg = qun_kg_amt.toFixed(2);
           if(tmpQtyKg>0.00){
               console.log('inside true KG');
               component.set("v.showKgDiv",true);
           }
           
           
           console.log('dasdasdsd dsdedegggg '+formated.format(parseFloat(tot_amt).toFixed(2)));
           ordWrap.total_amount = formated.format(parseFloat(tot_amt).toFixed(2));
           
           ordWrap.quantity_kg = qun_kg.toFixed(2);
           
           //commented by vishal
           //ordWrap.net_price_kg = qun_kg_amt.toFixed(2);
           
           ordWrap.net_price_kg = formated.format(tmpKgLtrAmt);
           
           ordWrap.quantity_litre = qun_ltr.toFixed(2);
           //commented by vishal
           //ordWrap.net_price_litre = qun_ltr_amt.toFixed(2);
           ordWrap.net_price_litre = ltrQutyAmt;
    
       
        component.set("v.orderWrapper",ordWrap);
       },

       

       handleFilesChange:function(component, event, helper) {
            var fileName = $A.get("{!$Label.c.No_file_selected}");
            if (event.getSource().get("v.files").length > 0) {
                fileName = event.getSource().get("v.files")[0]['name'];
                component.set("v.isFileReq", true);
            }
            component.set("v.fileName", fileName);
        },

        draftOrder:function(component, event, helper) {
            /* var target = event.getSource();  
            var index = target.get("v.name"); */
            var ordWrap = component.get("v.orderWrapper");
            var ordItem = component.get("v.orderItemWrapList");
            var index = component.get("v.itemIndex");
            var indxFlag = component.get("v.indexFlag");
            var error2 = false; 
            //console.log('Itemlist size - ', ordItem.length);
            if(indxFlag == true){
                var obj = new Object(ordItem[index]); 
                /* ------------ Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022------------------ */
                //var today = new Date();
                var crDt = new Date();
                var d = (crDt.getDate() < 10 ? '0' : '') + crDt.getDate();
                var M = ((crDt.getMonth() + 1) < 10 ? '0' : '') + (crDt.getMonth() + 1);
                var y = crDt.getFullYear();
                var currentDt = (y + "-" + M + "-" + d);
                var yy = new Date(currentDt);
                
                var today = new Date(crDt.getTime() + 86400000); // for current date + 1 ...
                /* ------------ End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------------ */
                var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
                var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
                var yyyy = today.getFullYear();
                var currentDate = (yyyy + "-" + MM + "-" + dd);
        
                var x = new Date(obj.shipmnt_date);
                var y = new Date(currentDate);

                if(+x < +yy){    // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 // shipment date greated than today...
                    error2 = true;
                    //component.find(obj.sku_id).focus();
                    var errMsg = $A.get("{!$Label.c.Shipment_Date_Can_Not_Be_Less_Than_Today}");
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
                /* ------------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022----------------------- */
                else if(ordWrap.showDeliveryDate == true){
                
                    //ordItem.forEach(function(item){
                        //var obj = new Object(item);
                        if(obj.deliveryDate == '' || obj.deliveryDate == null){
                            //
                        }
                        else{
                            var z = new Date(obj.deliveryDate);
                            if(+z < +y){
                                error2 = true;
                                component.find("delvery_date").focus();
                                var errMsg = $A.get("{!$Label.c.Date_of_delivery_should_not_be_less_than_todays_date}");
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
                        }
                    //});
                }
                /* ----------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------------------ */
            }
            
            if(error2 == false){

                component.set("v.disableButton",true);
                ordWrap.orderItemList = ordItem;
                component.set("v.orderWrapper",ordWrap);

                if(ordWrap.isSalesOrder == true){
                    var error = false;
                    /* if(ordWrap.inco_term_id == '' || ordWrap.inco_term_id == null){
                        error = true;
                        errMsg = $A.get("{!$Label.c.Inco_Term_Is_Required}");
                    }
                    else if(ordWrap.payment_method_id == '' || ordWrap.payment_method_id == null){
                        error = true;
                        errMsg = $A.get("{!$Label.c.Payment_Method_Is_Required}");
                    }
                    else  */if(ordWrap.payment_term_id == '' || ordWrap.payment_term_id == null){
                        error = true;
                        errMsg = $A.get("{!$Label.c.Payment_Terms_is_required}");
                    }

                    if(error == true){
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
                    else{
                        helper.updateSO(component, event, helper); 
                    } 
                }
                else{
                    
                    helper.saveAsDraft(component, event, helper);
                }
            }
            component.set("v.itemIndex",'');
        }, 

        draftSO:function(component, event, helper) {
            var ordWrap = component.get("v.orderWrapper");
            var ordItem = component.get("v.orderItemWrapList");
            var error = false;
            var errMsg = '';
            var fileInput = component.find("fileId").get("v.files");
            var fileReq = component.get("v.isFileReq");

            if(ordWrap.orderFor == '' || ordWrap.orderFor == null){
                error = true;
                component.find("order_for").focus();
                errMsg = $A.get("{!$Label.c.Please_Select_Order_For}");
            }
            else if(ordWrap.shipping_loc == '' || ordWrap.shipping_loc == null){
                error = true;
                component.find("shipping_address").focus();
                errMsg = $A.get("{!$Label.c.Select_Shipping_Address}");
            }
            else if((fileInput == null || fileInput.length <= 0) && fileReq == true){
                error = true;
                component.find("fileId").focus();
                errMsg = $A.get("{!$Label.c.Please_select_file}");
            }
            else if(ordItem.length == 0){
                error = true;
                errMsg = $A.get("{!$Label.c.Please_add_product_to_cart}");   // 'Add SKU To Order.';
            }
            
            else if(ordWrap.payment_term_id == '' || ordWrap.payment_term_id == null){
                error = true;
                errMsg = $A.get("{!$Label.c.Payment_Terms_is_required}");
            }
            else if(ordWrap.Depo_Obj == '' || ordWrap.Depo_Obj == null){
                error = true;
                errMsg = $A.get("{!$Label.c.Please_Select_Depot}");
            }
            else if(ordItem.length > 0){
                var i;
                /* ------------ Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ---------------------- */
                var crDt = new Date();
                var d = (crDt.getDate() < 10 ? '0' : '') + crDt.getDate();
                var M = ((crDt.getMonth() + 1) < 10 ? '0' : '') + (crDt.getMonth() + 1);
                var y = crDt.getFullYear();
                var currentDt = (y + "-" + M + "-" + d);
                var yy = new Date(currentDt);

                var today = new Date(crDt.getTime() + 86400000); // for current date + 1 ...
                /* ------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------------------ */
                var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
                var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
                var yyyy = today.getFullYear();
                var currentDate = (yyyy + "-" + MM + "-" + dd);
                var y = new Date(currentDate); // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022

                for (i = 0; i < ordItem.length; i++) {
                    var obj = new Object(ordItem[i]); 
                               
                    var x = new Date(obj.shipmnt_date);

                    if(+x < +yy){ // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022
                        error = true;
                        errMsg = $A.get("{!$Label.c.Shipment_Date_Can_Not_Be_Less_Than_Today}");
                        break;
                    }
                    /* ----------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 --------------------- */
                    else if(ordWrap.showDeliveryDate == true){
                        //ordItem.forEach(function(item){
                           // var obj = new Object(item);
                            if(obj.deliveryDate == null){
                                //
                            }
                            else{
                                var z = new Date(obj.deliveryDate);
                                if(+z < +y){
                                    error = true;
                                    errMsg = $A.get("{!$Label.c.Date_of_delivery_should_not_be_less_than_todays_date}");
                                    break;
                                }
                            }
                            
                       //});
                    }
                    /* -------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------------------- */
                }
            }
            /* else if(ordWrap.po_no == '' || ordWrap.po_no == null){
                error = true;
                component.find("po_number").focus();
                errMsg = $A.get("{!$Label.c.Enter_PO_No}");
            } */

            if(error == true){
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
            else{
                component.set("v.disableButton",true);
                component.set("v.isSODraft",true);
                ordWrap.orderItemList = ordItem;
                ordWrap.status = 'Draft';
                component.set("v.orderWrapper",ordWrap);
                helper.updateSO(component, event, helper);
            }
        },

        redirectToOrder:function(component, event, helper) {
            // Set isModalOpen attribute to false  
            
            var ordWrap = component.get("v.orderWrapper");
            var soId = component.get("v.soList");
            /* for(var i=0;i<soId.length;i++){
                window.open("/lightning/r/Sales_Order__c/"+soId[i]+"/view","_blank");
            } */
            window.history.forward(); 
            window.open("/lightning/r/Sales_Order__c/"+soId[0]+"/view","_self");
            /* if(ordWrap.isSalesOrder == true){
                window.open("/lightning/r/Sales_Order__c/"+soId[0]+"/view","_self");
            }
            else{
                window.open("/lightning/r/Order__c/"+soId[0]+"/view","_self");
            } */
            component.set("v.showSuccess", false);
            component.set("v.showSOSuccess", false);
            component.set("v.showSpinner", true);
        },
                
        
        confirmOrder:function(component, event, helper) {
            var ordWrap = component.get("v.orderWrapper");
            var ordItem = component.get("v.orderItemWrapList");
            var error = false;
            var errMsg = '';
            var fileInput = component.find("fileId").get("v.files");
            var fileReq = component.get("v.isFileReq");
            /* ---------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------------- */
            var crDt = new Date();
            var d = (crDt.getDate() < 10 ? '0' : '') + crDt.getDate();
            var M = ((crDt.getMonth() + 1) < 10 ? '0' : '') + (crDt.getMonth() + 1);
            var y = crDt.getFullYear();
            var currentDt = (y + "-" + M + "-" + d);
            var yy = new Date(currentDt);

            var today = new Date(crDt.getTime() + 86400000); // for current date + 1 ...
            var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
            var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
            var yyyy = today.getFullYear();
            var currentDate = (yyyy + "-" + MM + "-" + dd);
            var y = new Date(currentDate);
            var w = '';
            /* ------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------------------ */
            if(ordWrap.orderFor == '' || ordWrap.orderFor == null){
                error = true;
                component.find("order_for").focus();
                errMsg = $A.get("{!$Label.c.Please_Select_Order_For}");
            }
            else if(ordWrap.shipping_loc == '' || ordWrap.shipping_loc == null){
                error = true;
                component.find("shipping_address").focus();
                errMsg = $A.get("{!$Label.c.Select_Shipping_Address}");
            }
            else if((fileInput == null || fileInput.length <= 0) && fileReq == true){
                error = true;
                component.find("fileId").focus();
                errMsg = $A.get("{!$Label.c.Please_select_file}");
            }
            /* else if(ordWrap.po_no == '' || ordWrap.po_no == null){
                error = true;
                component.find("po_number").focus();
                errMsg = $A.get("{!$Label.c.Enter_PO_No}");
            } */
            else if(ordItem.length == 0){
                error = true;
                errMsg = $A.get("{!$Label.c.Please_add_product_to_cart}");   // 'Add SKU To Order.';
            }
           
            else if(ordWrap.payment_term_id == '' || ordWrap.payment_term_id == null){
                error = true;
                errMsg = $A.get("{!$Label.c.Payment_Terms_is_required}");
            }
            else if(ordWrap.Depo_Obj == '' || ordWrap.Depo_Obj == null){
                error = true;
                errMsg = $A.get("{!$Label.c.Please_Select_Depot}");
            }
            else if(ordItem.length > 0){
                var i;

                for (i = 0; i < ordItem.length; i++) {
                    var obj = new Object(ordItem[i]); 
            
                    var x = new Date(obj.shipmnt_date);

                    if(+x < +yy){ // SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022
                        error = true;
                        errMsg = $A.get("{!$Label.c.Shipment_Date_Can_Not_Be_Less_Than_Today}");
                        break;
                    }
                    /* ------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ---------------------- */
                    else if(error == false && ordWrap.showDeliveryDate == true){
                        //ordItem.forEach(function(item){
                            //var obj = new Object(item);
                            if(obj.deliveryDate == null){
                                //
                            }
                            else{
                                var z = new Date(obj.deliveryDate);
                                if(+z < +y){
                                    error = true;
                                    errMsg = $A.get("{!$Label.c.Date_of_delivery_should_not_be_less_than_todays_date}");
                                    break;
                                }
                            }
                        //});
                    }
                    /* --------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 --------------------- */
                }
            }
            /* ----------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------------------ */
            if(error == false && ordWrap.showPODate == true){
                if(ordWrap.poDate == null){
                    //ordWrap.poDate = "";
                    w = "";
                } 
                else{
                    w = new Date(ordWrap.poDate);
                }
                if(ordWrap.isPORequired == true && (ordWrap.poDate == null || ordWrap.poDate == '' )){
                    error = true;
                    component.find("po_date").focus();
                    errMsg = $A.get("{!$Label.c.Purchase_Order_date_is_required}");
                }
                /* else if(ordWrap.poDate != null && +w < +y){ // commented as per client request...
                    error = true;
                    component.find("po_date").focus();
                    errMsg = $A.get("{!$Label.c.PO_Date_should_not_be_less_than_todays_date}");
                } */
            }
            /* ------------------ End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------------------- */
            if(error == true){
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
            else{
                component.set("v.disableButton",true);
                ordWrap.orderItemList = ordItem;

                    component.set("v.orderWrapper",ordWrap);
                    helper.createSO(component, event, helper);
                                
                
            }
        }, 

        onCancel:function(component, event, helper){
            window.history.back();
        },

        showHistory:function(component, event, helper){
            component.set("v.showOrdHistory",true);
        },

        closeHistory:function(component, event, helper){
            component.set("v.showOrdHistory",false);
        },

        openOrder:function(component, event, helper){
            //var urlval = event.getSource().get("v.id");
            //var target = event.getSource();  
            var val = event.currentTarget.getAttribute("data-target") 
            var url ="/lightning/r/Sales_Order__c/"+val+"/view";
            window.open(url, '_blank');
        },

        validateDecimalVal:function(component, event, helper){
            var target = event.getSource();  
            var val = target.get("v.value");
            //var id = target.get("v.id");
            //val = val.replace(/^(0|[1-9]\d*)(\.\d+)?$/).replace(/([a-zA-Z ])/g,'').trim();
            if(val.length>0){
                val=val.replace(/[^a-zA-Z0-9,. ]/,'').replace(/([a-zA-Z ])/g,'').replace(/,(?=[^,]*$)/,'').trim();
            }
            else{
                val = 0;
            }
           
            target.set("v.value",val);
        },

        validateDiscountVal:function(component, event, helper){
            var target = event.getSource();  
            var val = target.get("v.value");

            if(val.length>0){
                val = val.replace(/[^0-9\.]/g,'');
                if(val.split('.').length>2){
                    val =val.replace(/\.+$/,"");
                } 
            }
            else{
                val = 0;
            }

            if(val > 100){
                val = 0;
            }
           
            target.set("v.value",val);
        },

        validateVal:function(component, event, helper){
            var target = event.getSource();  
            var val = target.get("v.value");

            if(val.length>0){
                val = val.replace(/[^0-9]/g,'');
                
            }
            else{
                val = 0;
            }
           
            target.set("v.value",val);
        },
        /* ---------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 ------------------------ */
        validateDateDel:function(component, event, helper){
            var target = event.getSource();  
            var index = target.get("v.name"); 
            var ordItem = component.get("v.orderItemWrapList"); 
            var obj = new Object(ordItem[index]); 
            var flag = false;
            var showDel = component.get("v.showDeliveryDate");
            //console.log('Item .. ', JSON.stringify(obj));
            
            if(obj.deliveryDate == null){
                obj.deliveryDate = '';
            }
            //var today = new Date();
            var crDt = new Date();
            var today = new Date(crDt.getTime() + 86400000); // for current date + 1 ...
            var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
            var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
            var yyyy = today.getFullYear();
            var currentDate = (yyyy + "-" + MM + "-" + dd); 

            
            var y = new Date(currentDate);

            if(showDel == true && obj.deliveryDate != ''){
                var x = new Date(obj.deliveryDate);
                if(+x < +y){     // delivery date greated than today+1...
                    flag = true;
                    target.focus();
                    //target.set("v.value","");
                    var errMsg = $A.get("{!$Label.c.Date_of_delivery_should_not_be_less_than_todays_date}");
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
            }
            if(flag == false){
                component.set("v.itemIndex",''); 
                component.set("v.indexFlag",false);
                var action4 = component.get('c.draftOrder');
                $A.enqueueAction(action4);  
            } 

        },

        validateDeliveryDate:function(component, event, helper){
            var target = event.getSource();  
            var val = target.get("v.value"); 
            var showDel = component.get("v.showDeliveryDate");       
           //console.log('validateDeliveryDate - ', val);            
            //var today = new Date();
            var crDt = new Date();
            var today = new Date(crDt.getTime() + 86400000); // for current date + 1 ...
            var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
            var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
            var yyyy = today.getFullYear();
            var currentDate = (yyyy + "-" + MM + "-" + dd); 
            
            var y = new Date(currentDate);

            if(showDel == true && val != null){
                var x = new Date(val);
                if(+x < +y){     
                
                    target.focus();
                    target.set("v.value","");
                    var errMsg = $A.get("{!$Label.c.Date_of_delivery_should_not_be_less_than_todays_date}");
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
            }
            
        },
        /* ----------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 -------------------------- */
      
})