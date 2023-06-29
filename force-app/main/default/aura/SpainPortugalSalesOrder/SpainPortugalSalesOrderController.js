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
            component.set("v.DuplicateSKUMap",newMp);
            component.set("v.orderForMap",newMp);
            helper.orderDetails(component, event, helper);
        }
        
    },
    //Below code added by Vivek for ticket:RITM0321550-22-Feb-22.
    onGoBack  : function(component, event, helper){
      var pageReference = {
            type: "standard__objectPage",
            attributes: {
                objectApiName: "Sales_Order__c",
                actionName: "list"
            },
            state: {
                filterName: "Recent"
            }
			};
      var navService = component.find("navService");
     
        event.preventDefault();
        navService.navigate(pageReference);
    },
    //Harshitha
    onChangePaymentMethod  : function(component, event, helper){
        var selectedPaymentMethod = component.find("paymnt_method").get("v.value");
        if(selectedPaymentMethod!=null && selectedPaymentMethod!='') 
            component.set("v.orderWrapper.payment_method_id",selectedPaymentMethod);
    },
    onChangePaymentTerm : function(component, event, helper){
        var selectedPaymentTerm = component.find("paymnt_term").get("v.value");  
            if(selectedPaymentTerm!=null && selectedPaymentTerm!='') 
                component.set("v.orderWrapper.payment_term_id",selectedPaymentTerm);
    },
    //added by Vaishnavi w.r.t CR-RITM0378141 ** S**-->
    onChangeIncoTerm : function(component, event, helper){
        var selectedIncoTerm = component.find("inco_term").get("v.value");  
            if(selectedIncoTerm!=null && selectedIncoTerm!='') 
                component.set("v.orderWrapper.inco_term_id",selectedIncoTerm);
     
    },
    //Sayan
    onChangeBasePrice:function(component, event, helper){
        var target = event.getSource();  
        var val = target.get("v.value");
        var pb = component.get("v.selectedPBRecord");
        console.log('Sayan pb id-->'+pb.Id);
        var stp2 = target.get("v.step");
        if(parseFloat(val) <= 0 || isNaN(parseFloat(val))){
            target.focus();
            target.set("v.value",pb.Price__c);
            var toastEvent1 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.Please_enter_Base_Price}");
            var titl  = $A.get("{!$Label.c.Error}");
            toastEvent1.setParams({
                "title": titl,
                "type": "Error",
                "message": msg
                //"duration":'3000'
            });
            toastEvent1.fire();
        }
        var action = component.get('c.calculatePriceAndDiscount');     // call one method from other method..
        $A.enqueueAction(action);
    },
    //Sayan

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
            if(obj.Billing_Street_1__c != 'None' && obj.Billing_Street_1__c != undefined){
                ordrWrap.shipping_loc_details = obj.Billing_Street_1__c;
            }else if(obj.Billing_Street_2__c != 'None' && obj.Billing_Street_2__c != undefined){
                if(ordrWrap.shipping_loc_details != ''){
                    ordrWrap.shipping_loc_details = ordrWrap.shipping_loc_details + ', ' + obj.Billing_Street_2__c;
                }else{
                    ordrWrap.shipping_loc_details = obj.Billing_Street_2__c;
                }
            }else if(obj.Billing_Street_3__c != 'None' && obj.Billing_Street_3__c != undefined){
                if(ordrWrap.shipping_loc_details != ''){
                    ordrWrap.shipping_loc_details = ordrWrap.shipping_loc_details + ', ' + obj.Billing_Street_3__c;
                }else{
                    ordrWrap.shipping_loc_details = obj.Billing_Street_3__c;
                }
            }else if(obj.Billing_Street_4__c != 'None' && obj.Billing_Street_4__c != undefined){
                if(ordrWrap.shipping_loc_details != ''){
                    ordrWrap.shipping_loc_details = ordrWrap.shipping_loc_details + ', ' + obj.Billing_Street_4__c;
                }else{
                    ordrWrap.shipping_loc_details = obj.Billing_Street_4__c;
                }
            }else if(obj.Billing_Street_5__c != 'None' && obj.Billing_Street_5__c != undefined){
                if(ordrWrap.shipping_loc_details != ''){
                    ordrWrap.shipping_loc_details = ordrWrap.shipping_loc_details + ', ' + obj.Billing_Street_5__c;
                }else{
                    ordrWrap.shipping_loc_details = obj.Billing_Street_5__c;
                }
            }else if(obj.Billing_Street_6__c != 'None' && obj.Billing_Street_6__c != undefined){
                if(ordrWrap.shipping_loc_details != ''){
                    ordrWrap.shipping_loc_details = ordrWrap.shipping_loc_details + ', ' + obj.Billing_Street_6__c;
                }else{
                    ordrWrap.shipping_loc_details = obj.Billing_Street_6__c;
                }
            }else if(obj.Region__c != 'None' && obj.Region__c != undefined){
                if(ordrWrap.shipping_loc_details != ''){
                    ordrWrap.shipping_loc_details = ordrWrap.shipping_loc_details + ', ' + obj.Region__c;
                }else{
                    ordrWrap.shipping_loc_details = obj.Region__c;
                }
            }
            if(obj.Country_Name__c != 'None' && obj.Country_Name__c != undefined){ //country name field is used for refence as City name..
                if(ordrWrap.shipping_loc_details != ''){
                    ordrWrap.shipping_loc_details = ordrWrap.shipping_loc_details + ', ' + obj.Country_Name__c;
                    console.log('Priya Country_Name -> ' +obj.Country_Name__c);
                }else{
                    ordrWrap.shipping_loc_details = obj.Country_Name__c;
                    console.log('Priya else Country_Name -> ' +obj.Country_Name__c);
                }

            }
            
             if(obj.City__c != 'None' && obj.City__c != undefined){ // RITM0217558 City name..
                if(ordrWrap.shipping_loc_details != ''){
                    ordrWrap.shipping_loc_details = ordrWrap.shipping_loc_details + ', ' + obj.City__c;
                }else{
                    ordrWrap.shipping_loc_details = obj.City__c;
                }

            }
            if(obj.Country__c != 'None' && obj.Country__c != undefined){ // RITM0217558 Country name..
                if(ordrWrap.shipping_loc_details != ''){
                    ordrWrap.shipping_loc_details = ordrWrap.shipping_loc_details + ', ' + obj.Country__c;
                }else{
                    ordrWrap.shipping_loc_details = obj.Country__c;
                }
            }
            
           /* if(obj.State__c != 'None' && obj.State__c != undefined){ 
                if(ordrWrap.shipping_loc_details != ''){
                    ordrWrap.shipping_loc_details = ordrWrap.shipping_loc_details + ', ' + obj.State__c;
                }else{
                    ordrWrap.shipping_loc_details = obj.State__c;
                }
            } RITM0217558 */
            
            if(obj.Pincode__c != 'None' && obj.Pincode__c != undefined){
                if(ordrWrap.shipping_loc_details != ''){
                    ordrWrap.shipping_loc_details = ordrWrap.shipping_loc_details + ', ' + obj.Pincode__c;
                }else{
                    ordrWrap.shipping_loc_details = obj.Pincode__c;
                }
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
        var pb = component.get("v.selectedPBRecord");
        var pbWrap = component.get("v.priceBookWrap");  
           console.log('pb ', pb);
           console.log('pbWrap ', pbWrap);
        //console.log('handleSKUChange ', pb.Id);
        //alert('WWWWW');
       
        if(pb.Id != undefined){
            pbWrap.pb_id = pb.Id;
            pbWrap.sku_name = pb.SKUCode__r.SKU_Description__c;
            pbWrap.sku_id = pb.SKUCode__r.Id;
            pbWrap.uom = pb.UOM__c;
            pbWrap.base_price = pb.Price__c;
            pbWrap.actual_base_price = pb.Price__c;//Sayan
            pbWrap.apply_cmpgn_disc = true;
            pbWrap.multiple_of = pb.SKUCode__r.Multiple_of__c;
            pbWrap.distributionChanlIds = pb.DistributionChannel__c;
            pbWrap.divisionIds = pb.Division__c;
            pbWrap.min_quantity = pb.SKUCode__r.Mininum_Quantity__c;
            pbWrap.tax = pb.Country_Tax__c;

            helper.getCampaignDiscount(component, event, helper);
            component.set("v.priceBookWrap",pbWrap);
        }
        else{
            
            var action = component.get('c.resetPBObj');     // call one method from other method..
            $A.enqueueAction(action); 
            
        }
        
    },

    onCampaignChange:function(component, event, helper){
        var campId = event.getSource().get("v.value");
        console.log('campId ... - ', campId);
        //var ordTyp = component.find("shipping_address").get("v.value"); 
        var pbWrap = component.get("v.priceBookWrap");
        var campMap = new Map(component.get("v.campaignMap"));
        console.log('campMap ... - ', campMap);
        if(campId == null || campId == ''){
            pbWrap.campaign_nm = '';
            pbWrap.campaign_id = '';
            pbWrap.campaign_code = '';
            pbWrap.campaign_discount= 0.0;
            pbWrap.actual_campaign_discount = 0.0;
            pbWrap.pb_discount_id = '';
            
        }
        else{
            var obj = new Object();
            obj=  campMap.get(campId);
            console.log('Campaign ... - ',obj);
            pbWrap.campaign_nm = obj.Spain_Portugal_Campaign__r.Name;
            pbWrap.campaign_id = obj.Spain_Portugal_Campaign__c;
            pbWrap.campaign_code = obj.Spain_Portugal_Campaign__r.Campaign_Id__c;
            if(obj.Distributor_Discount__c == null){
                pbWrap.campaign_discount= 0;
                pbWrap.actual_campaign_discount = 0;
            }
            else{
                pbWrap.campaign_discount= obj.Distributor_Discount__c;
                pbWrap.actual_campaign_discount = obj.Distributor_Discount__c;
            }
            
            pbWrap.pb_discount_id = obj.Id;
            
        }
        component.set("v.priceBookWrap",pbWrap);
        var action = component.get('c.calculatePriceAndDiscount');     // call one method from other method..
        $A.enqueueAction(action);
       },

       addSKU:function(component, event, helper){
        var pbWrap = component.get("v.priceBookWrap");
        var skuMap = new Map(component.get("v.skuMap"));
        var showDel = component.get("v.showDeliveryDate"); /* SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 */
        var reqDel = component.get("v.isDeliveryDateReq"); /* SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 */
        var DuplicateSKUMap = new Map(component.get("v.DuplicateSKUMap"));
        var error = false;
        /*-------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ------------*/
        console.log('Nik addSKU pbWrap - ', JSON.stringify(pbWrap));
        //var today = new Date(); // for current date..
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
        var z = '';

        //var x = new Date(component.find("shipment_dt").get("v.value")); //Hiding Shipping date RITM0475049 GRZ(Nikhil Verma) 16-12-2022
        var y = new Date(currentDate);
        
        /*---------- End - SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022  ------------*/    
        var errMsg = '';   

        if(pbWrap == null){
            error = true;
            errMsg = $A.get("{!$Label.c.SKU_Not_Selected}");             
        }
        else if(pbWrap.sku_id == '' || pbWrap.sku_id == null){
            error = true;
            errMsg = $A.get("{!$Label.c.Please_Select_SKU}");            
        }
        /* else if(DuplicateSKUMap.has(pbWrap.sku_id+"-"+pbWrap.line_discount+"-"+pbWrap.base_price)){   // SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022..
            error = true;
            errMsg = $A.get("{!$Label.c.Duplicate_entries_are_not_allowed}"); 
        } */
        else if(pbWrap.base_price <= 0){
            error = true;
            component.find("base_price").focus();
            errMsg = $A.get("{!$Label.c.SKU_With_Base_Price_Zero_Can_Not_Be_Added}");
        }
        else if(pbWrap.quantity <= 0){
            error = true;
            component.find("quantity").focus();
            errMsg = $A.get("{!$Label.c.Please_enter_Quantity}");
        }
        //Below else if block, Hiding Shipping date RITM0475049 GRZ(Nikhil Verma) 16-12-2022
        /*else if(+x < +yy){
            error = true;
            component.find("shipment_dt").focus();
            errMsg = $A.get("{!$Label.c.Shipment_Date_Can_Not_Be_Less_Than_Today}");
        } */

        else if(showDel == true){ /*-------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ------------*/
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
            else if(reqDel == true && dt != "" && +z < +y){
                error = true;
                component.find("delvery_date").focus();
                errMsg = $A.get("{!$Label.c.Date_of_delivery_should_not_be_less_than_todays_date}");
            }
            else if(dt == ""){
                z = '';
            }
        } /*---------- End - SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022  ------------*/

        if(error == true){
            var toastEvent1 = $A.get("e.force:showToast");
              var titl  = $A.get("{!$Label.c.Error}");
              toastEvent1.setParams({
                  "title": titl,
                  "type": "Error",
                  "message": errMsg
              });
              toastEvent1.fire();
        }
        else{
            component.set("v.orderForDisable",true);
            var ordItem = component.get("v.orderItemWrapList");
            var itemObj = new Array();
            var vg = component.get("v.selectedPBRecord");
            var totalBasePrice = pbWrap.base_price - pbWrap.tax;
            itemObj = {
                'orderItem_id' : '',
                'order_id' : '' ,
                'pb_id' : pbWrap.pb_id,
                'sku_name' : pbWrap.sku_name,
                'sku_id' : pbWrap.sku_id,
                'uom' : pbWrap.uom,
                'campaign_nm' : pbWrap.campaign_nm,
                'campaign_id' : pbWrap.campaign_id,
                'base_price' : pbWrap.base_price,//totalBasePrice, Changes done w.r.t CR-#RITM0383747
                'apply_cmpgn_disc' : pbWrap.apply_cmpgn_disc,
                'campaign_discount' : pbWrap.campaign_discount,
                'line_discount' : pbWrap.line_discount,
                'volume_discount' : pbWrap.volume_discount,
                'quantity' : pbWrap.quantity,
                'final_price' : pbWrap.final_price,
                'net_price' : pbWrap.net_price,
                'shipmnt_date' : pbWrap.shipmnt_date,  // x;  // remove x to set default value comming from apex RITM0475049 GRZ(Nikhil Verma) 16-12-2022
                'inventory' : pbWrap.inventory,
                'actual_discount' : pbWrap.actual_discount,
                'edited_discount' : pbWrap.edited_discount,
                'multiple_of' : pbWrap.multiple_of,
                'actual_campaign_discount' : pbWrap.actual_campaign_discount,
                'actual_line_discount' : pbWrap.actual_line_discount,
                'actual_base_price' : component.get("v.selectedPBRecord").Price__c,//Sayan
                'actual_volume_discount' : pbWrap.actual_volume_discount,
                'pb_discount_id' : pbWrap.pb_discount_id,
                'distributionChanlIds' : pbWrap.distributionChanlIds,
                'divisionIds' : pbWrap.divisionIds,
                'itemNumber' : 0,
                'campaign_code' : pbWrap.campaign_code,
                'tax' : pbWrap.tax,
                'deliveryDate' : z,  /*-------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ------------*/
                'base_Price_without_tax' : totalBasePrice     /*Change by Aashima(Grazitti) RITM0509178 2 march 2023*/
            };
            //component.get("v.selectedPBRecord").Country_Tax__c
            ordItem.push(itemObj);
            //ordItem = JSON.parse(JSON.stringify(ordItem));
            component.set('v.orderItemWrapList',ordItem);
            skuMap.set(pbWrap.sku_id,pbWrap.sku_id);
            component.set("v.skuMap",skuMap);
            //-------------------------------------------
            DuplicateSKUMap.set(pbWrap.sku_id+"-"+pbWrap.line_discount+"-"+pbWrap.base_price,pbWrap.sku_id+"-"+pbWrap.line_discount+"-"+pbWrap.base_price);
            component.set("v.DuplicateSKUMap",DuplicateSKUMap);
            //var ordWrap = component.get("v.orderWrapper");
           // ordWrap.total_amount = (parseFloat(ordWrap.total_amount) + parseFloat(pbWrap.net_price)).toFixed(2);

            /* if(pbWrap.uom.toUpperCase() == 'KG'){
                ordWrap.quantity_kg = (parseFloat(ordWrap.quantity_kg) + parseFloat(pbWrap.quantity)).toFixed(2);
                ordWrap.net_price_kg = (parseFloat(ordWrap.net_price_kg) + parseFloat(pbWrap.net_price)).toFixed(2);
            }
            else if(pbWrap.uom.toUpperCase() == 'L'){
                ordWrap.quantity_litre = (parseFloat(ordWrap.quantity_litre) + parseFloat(pbWrap.quantity)).toFixed(2);
                ordWrap.net_price_litre = (parseFloat(ordWrap.net_price_litre) + parseFloat(pbWrap.net_price)).toFixed(2);
            }
            else if(pbWrap.uom.toUpperCase() == 'BT'){
                ordWrap.quantity_bottle = (parseFloat(ordWrap.quantity_bottle) + parseFloat(pbWrap.quantity)).toFixed(2);
                ordWrap.net_price_bottle = (parseFloat(ordWrap.net_price_bottle) + parseFloat(pbWrap.net_price)).toFixed(2);
            } */

            /* var early_dis = component.find("early_ord_discount").get("v.value");
            ordWrap.gross_amount = (parseFloat(ordWrap.total_amount) -  (parseFloat(early_dis) * ordWrap.total_amount) / 100).toFixed(2);
            component.set("v.orderWrapper",ordWrap); */
            var action1 = component.get('c.calculateTotalAmt');
            $A.enqueueAction(action1); 

            var action2 = component.get('c.calculateGrossAmt');     // call one method from other method..
            $A.enqueueAction(action2); 

            component.find("skuId").makeReset(false); // to reset sku search pill
            var action3 = component.get('c.resetPBObj');     // call one method from other method..
            $A.enqueueAction(action3);  

            var action4 = component.get('c.draftOrder');
            $A.enqueueAction(action4);  

        }
       },

       applyCampaignDiscount:function(component, event, helper){
        var appDis = document.getElementById("applyDiscount").checked
        var campMap = new Map(component.get("v.campaignMap"));
        var campId = component.find("campaign_id").get("v.value");
        var pbWrap = component.get("v.priceBookWrap");
        if(appDis == true){
            if(campId.length>0){
                var obj = new Object();
                obj = campMap.get(campId);
               // component.find("campaign_discount").set("v.value",obj.Distributor_Discount__c);
               pbWrap.campaign_discount = obj.Distributor_Discount__c;
               var addedCampDiscount = component.get("v.totalDiscount")+pbWrap.campaign_discount;
			   component.set("v.totalDiscount",addedCampDiscount);
            }
            else{
               // component.find("campaign_discount").set("v.value",0.0);
               pbWrap.campaign_discount = 0.0;
            }
            pbWrap.apply_cmpgn_disc = true;
        }
        else{
          // component.find("campaign_discount").set("v.value",0.0);
          pbWrap.campaign_discount = 0.0;
          pbWrap.apply_cmpgn_disc = false;
        }
        component.set("v.priceBookWrap",pbWrap);
        var action = component.get('c.calculatePriceAndDiscount');     // call one method from other method..
        $A.enqueueAction(action);  
       },

       calculatePriceAndDiscount:function(component, event, helper){
           
        var pbWrap = component.get("v.priceBookWrap");
        console.log('PB Wrap : '+JSON.stringify(pbWrap));
           
        if(pbWrap.campaign_discount.length == 0){
            pbWrap.campaign_discount = 0;
        }
        if(pbWrap.line_discount.length == 0){
            pbWrap.line_discount = 0;
        }
        if(pbWrap.volume_discount.length == 0){
            pbWrap.volume_discount = 0;
        }
        
        var edt_dis;
        var edt_dis_Clone;
        var actl_dis = pbWrap.actual_campaign_discount + pbWrap.actual_line_discount + pbWrap.actual_volume_discount;
        if(pbWrap.tax !=undefined){
            console.log('**Inside not undefined Tax - '+pbWrap.tax);
             edt_dis = (parseFloat(pbWrap.campaign_discount) + parseFloat(pbWrap.line_discount) + parseFloat(pbWrap.volume_discount)) ; // removed parseFloat(pbWrap.tax) Nikhil Verma RITM0475996 15-12-2022
             edt_dis_Clone = parseFloat(pbWrap.campaign_discount) + parseFloat(pbWrap.line_discount) + parseFloat(pbWrap.volume_discount);
            }
         else{
             console.log('**Inside undefined Tax - '+pbWrap.tax);
             edt_dis = (parseFloat(pbWrap.campaign_discount) + parseFloat(pbWrap.line_discount) + parseFloat(pbWrap.volume_discount) ) ;

         }
        console.log('**total Tax - '+pbWrap.tax);
        pbWrap.actual_discount = actl_dis;
        pbWrap.edited_discount = edt_dis;
		component.set("v.totalDiscount",edt_dis_Clone);
        /*--------------- Update logic Condition Nikhil Verma RITM0475996 15-12-2022--------------*/
        var revisedBasePrice = pbWrap.base_price;
        console.log('jarevisedBasePrice:'+revisedBasePrice)
        // comment below code for RITM0531490 GRZ(Javed Ahmed) 03-04-2023
        // if(pbWrap.tax !=undefined){
        //     revisedBasePrice = pbWrap.base_price - pbWrap.tax;
        // }
        var finl_prc = parseFloat(revisedBasePrice - ((pbWrap.edited_discount * revisedBasePrice) / 100));
        /*--------------- End------ Nikhil Verma RITM0475996 15-12-2022--------------*/


        pbWrap.final_price = parseFloat(finl_prc).toFixed(2) ;  //Updated for RITM0527621  GRZ(Dheeraj Sharma) 30-03-2023
  
        console.log('ds2',pbWrap.final_price);

        var net_prc = parseFloat(pbWrap.quantity) * finl_prc;
        pbWrap.net_price = net_prc;

        console.log('actl_dis ', actl_dis);
        console.log('edt_dis ', edt_dis);

        //Added by Varun Shrivastava : INCTASK0497950 Start 9 June 2021
        component.set("v.selectedVolumeDiscount",false);
        if(pbWrap.actual_volume_discount == pbWrap.volume_discount){
            component.set("v.selectedVolumeDiscount",true);
        }
        //pbWrap.actual_volume_discount = pbWrap.volume_discount;
        //Added by Varun Shrivastava : INCTASK0497950 Start 9 June 2021

        component.set("v.priceBookWrap",pbWrap);
        console.log('After Calculation : '+JSON.stringify(component.get("v.priceBookWrap")));
       /*  var action = component.get('c.calculateGrossAmt');     // call one method from other method..
        $A.enqueueAction(action);  */
       },

       calculatePrice:function(component, event, helper){
        var target = event.getSource();  
        var index = target.get("v.name"); 
        var ordItem = component.get("v.orderItemWrapList"); 
        var obj = new Object(ordItem[index]); 
        
        if(obj.campaign_discount.length == 0){
            obj.campaign_discount = 0;
        }
        if(obj.line_discount.length == 0){
            obj.line_discount = 0;
        }
        if(obj.volume_discount.length == 0){
            obj.volume_discount = 0;
        }

       // var ordWrap = component.get("v.orderWrapper");
      //  ordWrap.total_amount = (parseFloat(ordWrap.total_amount) + parseFloat(obj.net_price)).toFixed(2);

        //var actl_dis = (obj.actual_campaign_discount + obj.actual_line_discount + obj.actual_volume_discount ) * obj.base_price / 100 ;
        //var edt_dis = (parseFloat(obj.campaign_discount) + parseFloat(obj.line_discount) + parseFloat(obj.volume_discount) ) * obj.base_price / 100 ;
        var actl_dis = obj.actual_campaign_discount + obj.actual_line_discount + obj.actual_volume_discount ;
        var edt_dis = (parseFloat(obj.campaign_discount) + parseFloat(obj.line_discount) + parseFloat(obj.volume_discount) ) ;

        obj.actual_discount = actl_dis;
        obj.edited_discount = edt_dis;
        
        var finl_prc = parseFloat(obj.base_price - ((obj.edited_discount * obj.base_price) / 100));
        obj.final_price = finl_prc;

        var net_prc = parseFloat(obj.quantity) * finl_prc;
        obj.net_price = net_prc;

        ordItem[index] = obj;
        component.set("v.orderItemWrapList",ordItem); 

        var action1 = component.get('c.calculateTotalAmt');
        $A.enqueueAction(action1); 

        var action = component.get('c.calculateGrossAmt');     // call one method from other method..
        $A.enqueueAction(action); 
      //  console.log('Item .. ', component.get("v.orderItemWrapList"));
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
        var DuplicateSKUMap = new Map(component.get("v.DuplicateSKUMap"));
        var early_dis = component.find("early_ord_discount").get("v.value");
        console.log('deleteSKU Id- ',obj);

        if(skuMap.size>0){
            if(skuMap.has(sku[index].sku_id)){
                skuMap.delete(sku[index].sku_id);
                component.set("v.skuMap",skuMap);
            }
        } 
           if(DuplicateSKUMap.size>0){
               if(DuplicateSKUMap.has(sku[index].sku_id+"-"+sku[index].line_discount+"-"+sku[index].base_price)){
                   DuplicateSKUMap.delete(sku[index].sku_id+"-"+sku[index].line_discount+"-"+sku[index].base_price);
                   component.set("v.DuplicateSKUMap",DuplicateSKUMap);
               }
           } 

        if(obj.length==0){
            var action1 = component.get('c.calculateTotalAmt');
            $A.enqueueAction(action1); 

            var action = component.get('c.calculateGrossAmt');     // call one method from other method..
            $A.enqueueAction(action); 

            if (index > -1) {
                sku.splice(index, 1);
            }
            component.set("v.orderItemWrapList", sku);
            if(sku.length == 0){
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
                netPrc :parseFloat(sku[index].net_price)
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

                    var action = component.get('c.calculateGrossAmt');     // call one method from other method..
                    $A.enqueueAction(action); 

                    if (index > -1) {
                        sku.splice(index, 1);
                    }
                    component.set("v.orderItemWrapList", sku);
                    if(sku.length == 0){
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
        var DuplicateSKUMap = new Map(component.get("v.DuplicateSKUMap"));
        var skuMap = new Map(component.get("v.skuMap"));
        var isNewOrder = component.get("v.isNewOrder");
           console.log('**NewDelete - ', isNewOrder);

        if(skuMap.size>0){
            skuMap.clear();
            component.set("v.skuMap",skuMap);
        }
        if(DuplicateSKUMap.size>0){
            DuplicateSKUMap.clear();
            component.set("v.DuplicateSKUMap",DuplicateSKUMap);
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
       },


       resetPBObj:function(component, event, helper){
        var pbWrap = component.get("v.priceBookWrap");
        var showDel = component.get("v.showDeliveryDate"); /* SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 */
        var cmpgnId = pbWrap.campaign_id;
            //console.log('cmpgnId.... ',cmpgnId);
            pbWrap.pb_id = '';
            pbWrap.sku_name = '';
            pbWrap.sku_id = '';
            pbWrap.uom = '';
            pbWrap.base_price = 0.0;
            pbWrap.apply_cmpgn_disc = true;
            pbWrap.multiple_of = 0.0;
            pbWrap.campaign_nm = '';
            pbWrap.campaign_id = '';
            pbWrap.campaign_discount = 0.0;
            pbWrap.line_discount = 0.0;
            pbWrap.volume_discount = 0.0;
            pbWrap.quantity = 0.0;
            pbWrap.final_price = 0.0;
            pbWrap.net_price = 0.0;
            pbWrap.inventory = 0.0;
            pbWrap.actual_campaign_discount = 0.0;
            pbWrap.actual_line_discount = 0.0;
            pbWrap.actual_base_price = 0.0;//Sayan
            pbWrap.actual_volume_discount = 0.0;
            pbWrap.actual_discount = 0.0;
            pbWrap.edited_discount = 0.0;
            pbWrap.pb_discount_id = '';
            pbWrap.distributionChanlIds = '';
            pbWrap.divisionIds = '';
            pbWrap.min_quantity = 0;
            pbWrap.tax = 0.0;
            //pbWrap.Updated_baseprice = 0.0;
           /*-------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ------------*/
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

            //component.find("shipment_dt").set("v.value", yy); //Hiding Shipping date RITM0475049 GRZ(Nikhil Verma) 16-12-2022
            if(showDel == true){
                component.find("delvery_date").set("v.value", currentDate);
            }
            
            /*---------- End - SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022  ------------*/

            var lst = [];
            component.set("v.campaignDiscountList",lst); 
            
            if(cmpgnId.length>0){
                var newMp = new Map(component.get("v.campaignMap"));
                newMp.delete(cmpgnId);
                component.set("v.campaignMap",newMp);
                console.log('newMp.... ',newMp);
            }
            component.set("v.priceBookWrap",pbWrap);
       },

         validateDate:function(component, event, helper){
        //var target = event.getSource();  
        //var index = target.get("v.name"); 
        var ordItem = component.get("v.orderItemWrapList"); 
       // var ordrWrap = component.get("v.orderWrapper");
        //var obj = new Object(ordItem[index]); 
        
        //console.log('Item .. ', JSON.stringify(obj));
        //console.log('Date.. ', obj.shipmnt_date);
        
        var today = new Date();
        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        var currentDate = (yyyy + "-" + MM + "-" + dd); 

        // var x = new Date(component.find("shipment_dt").get("v.value"));; //Hiding Shipping date RITM0475049 GRZ(Nikhil Verma) 16-12-2022
        var y = new Date(currentDate);

        // Hiding Shipping date RITM0475049 GRZ(Nikhil Verma) 16-12-2022
        /*if(+x < +y){     // shipment date greated than today...
           
            component.find("shipment_dt").focus();
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
            component.find("shipment_dt").set("v.value", '');
        }
        else{            
            for(var i=0; i < ordItem.length; i++){
		ordItem[i].shipmnt_date = x;
		}
            console.log('**Date in validate shipment - '+x);
            
         //ordrWrap.shipmnt_date = x;  
            
            //var action4 = component.get('c.draftOrder');
            //$A.enqueueAction(action4);  
        } */
        /*---------End --------- Hiding Shipping date RITM0475049 GRZ(Nikhil Verma) 16-12-2022---------*/

       },

    /*-------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ------------*/
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
    /*---------- End - SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022  ------------*/

       calculateGrossAmt:function(component, event, helper){
        var ordWrap = component.get("v.orderWrapper");
        var early_dis = component.find("early_ord_discount").get("v.value");
        console.log('**early_dis '+early_dis);
        console.log('**total_amount '+ordWrap.total_amount);
        var grosAmt = parseFloat(parseFloat(ordWrap.total_amount) -  (parseFloat(early_dis) * parseFloat(ordWrap.total_amount)) / 100).toFixed(2);
        //console.log('**early_dis '+ordWrap.total_amount);
        console.log('**grosAmt '+ordWrap.grosAmt);  
        component.set("v.orderWrapper.gross_amount",grosAmt);
        
       },

       calculateTotalAmt:function(component, event, helper){
        var ordWrap = component.get("v.orderWrapper");
           console.log('**Inside calculateTotalAmt ');
        var ordItem = component.get("v.orderItemWrapList");
        var i;
        var tot_amt = 0;
        var qun_kg = 0;
        var qun_kg_amt = 0;
        var qun_ltr = 0;
        var qun_ltr_amt = 0;
        var qun_btl = 0;
        var qun_btl_amt = 0;

        for (i = 0; i < ordItem.length; i++) {
            var obj = new Object(ordItem[i]); 
            tot_amt = tot_amt + parseFloat(obj.net_price);

            if(obj.uom.toUpperCase() == 'KG'){
                qun_kg = qun_kg + parseFloat(obj.quantity);
                qun_kg_amt = qun_kg_amt + parseFloat(obj.net_price);
            }
            else if(obj.uom.toUpperCase() == 'L'){
                qun_ltr = qun_ltr + parseFloat(obj.quantity);
                qun_ltr_amt = qun_ltr_amt + parseFloat(obj.net_price);
            }
            else if(obj.uom.toUpperCase() == 'BT'){
                qun_btl = qun_btl + parseFloat(obj.quantity);
                qun_btl_amt = qun_btl_amt + parseFloat(obj.net_price);
            }

        }
        
        ordWrap.total_amount = parseFloat(tot_amt).toFixed(2);
        
        ordWrap.quantity_kg = qun_kg.toFixed(2);
        ordWrap.net_price_kg = qun_kg_amt.toFixed(2);
    
        ordWrap.quantity_litre = qun_ltr.toFixed(2);
        ordWrap.net_price_litre = qun_ltr_amt.toFixed(2);
    
        ordWrap.quantity_bottle = qun_btl.toFixed(2);
        ordWrap.net_price_bottle = qun_btl_amt.toFixed(2);
        
        component.set("v.orderWrapper",ordWrap);
       },

       resetToDefault:function(component, event, helper){
        var target = event.getSource();  
        var val = target.get("v.value"); 

        if(val.length == 0){
            target.set("v.value", 0);
        }
       },

       handleFilesChange:function(component, event, helper) {
            var fileName = $A.get("{!$Label.c.No_file_selected}");
            if (event.getSource().get("v.files").length > 0) {
                fileName = event.getSource().get("v.files")[0]['name'];
            }
            component.set("v.fileName", fileName);
        },

        draftOrder:function(component, event, helper) {
            var ordWrap = component.get("v.orderWrapper");
            var ordItem = component.get("v.orderItemWrapList");
            
            //var pb = component.get("v.selectedPBRecord");
            /* var error = false;
            var errMsg = '';

            if(ordWrap.orderFor == '' || ordWrap.orderFor == null){
                error = true;
                component.find("order_for").focus();
                errMsg = 'Select Order For.';
            }
            else if(ordWrap.shipping_loc == '' || ordWrap.shipping_loc == null){
                error = true;
                component.find("shipping_address").focus();
                errMsg = 'Select Shipping Address.';
            }
            else if(ordWrap.po_no == '' || ordWrap.po_no == null){
                error = true;
                component.find("po_number").focus();
                errMsg = 'Enter PO Number.';
            }
            else if(ordItem.length == 0){
                error = true;
                errMsg = 'Add SKU To Order.';
            }

            if(error == true){
                var toastEvent1 = $A.get("e.force:showToast");
                  var titl  = 'Error'//$A.get("{!$Label.c.Warning}");
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
                
                if(ordWrap.isSalesOrder == true){
                    ordWrap.status = 'Draft';
                    component.set("v.orderWrapper",ordWrap);
                    helper.updateSO(component, event, helper);
                }
                else{
                    component.set("v.orderWrapper",ordWrap);
                    helper.saveAsDraft(component, event, helper);
                }
                
            } */
            component.set("v.disableButton",true);
            ordWrap.orderItemList = ordItem;
            component.set("v.orderWrapper",ordWrap);

            if(ordWrap.isSalesOrder == true){
                var error = false;
                if(ordWrap.inco_term_id == '' || ordWrap.inco_term_id == null){
                    error = true;
                    errMsg = $A.get("{!$Label.c.Inco_Term_Is_Required}");
                }
                else if(ordWrap.payment_method_id == '' || ordWrap.payment_method_id == null){
                    error = true;
                    errMsg = $A.get("{!$Label.c.Payment_Method_Is_Required}");
                }
                else if(ordWrap.payment_term_id == '' || ordWrap.payment_term_id == null){
                    error = true;
                    errMsg = $A.get("{!$Label.c.Payment_Terms_is_required}");
                }
                else if(ordItem.length > 0){ /*-------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ------------*/
                    //var today = new Date();
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

                    ordItem.forEach(function(item){
                        var obj = new Object(item);
                        if(ordWrap.showDeliveryDate == true){
                            if(obj.deliveryDate == '' || obj.deliveryDate == null){
                                //
                            }
                            else{
                                var z = new Date(obj.deliveryDate);
                                if(+z < +y){
                                    error = true;
                                    errMsg = $A.get("{!$Label.c.Date_of_delivery_should_not_be_less_than_todays_date}");
                                }
                            }
                        }
                        
                    });
                }  /*---------- End - SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022  ------------*/

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
        }, 

        draftSO:function(component, event, helper) {
            var ordWrap = component.get("v.orderWrapper");
            var ordItem = component.get("v.orderItemWrapList");
            var checkedReorder = component.get("v.allowTemplate");
            
            var error = false;
            var errMsg = '';
            if(checkedReorder == true){
                error = true;
                component.find("reOrder").focus();
                errMsg = $A.get("{!$Label.c.Error_On_Draft_Reorder}");
            }
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
            /*else if(ordWrap.po_no == '' || ordWrap.po_no == null){
                error = true;
                component.find("po_number").focus();
                errMsg = $A.get("{!$Label.c.Enter_PO_No}");
            } */
            // RITM0207130
            else if(ordItem.length == 0){
                error = true;
                errMsg = $A.get("{!$Label.c.Please_add_product_to_cart}");   // 'Add SKU To Order.';
            }
            else if(ordWrap.inco_term_id == '' || ordWrap.inco_term_id == null){
                error = true;
                errMsg = $A.get("{!$Label.c.Inco_Term_Is_Required}");
            }
            else if(ordWrap.payment_method_id == '' || ordWrap.payment_method_id == null){
                error = true;
                errMsg = $A.get("{!$Label.c.Payment_Method_Is_Required}");
            }
            else if(ordWrap.payment_term_id == '' || ordWrap.payment_term_id == null){
                error = true;
                errMsg = $A.get("{!$Label.c.Payment_Terms_is_required}");
            }
            else if(ordItem.length > 0){  /*-------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ------------*/
                var i;
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

                for (i = 0; i < ordItem.length; i++) {
                    var obj = new Object(ordItem[i]); 
                               
                    /* var x = new Date(obj.shipmnt_date);

                    if(+x < +yy){
                        error = true;
                        errMsg = $A.get("{!$Label.c.Shipment_Date_Can_Not_Be_Less_Than_Today}");
                        break;
                    } */
                    if(ordWrap.showDeliveryDate == true){
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
                }
            } /*---------- End - SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022  ------------*/

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

        validateMultipleOf:function(component, event, helper) {
            var target = event.getSource();  
            var val = target.get("v.value"); 
            var stp = target.get("v.step");
            var pbWrap = component.get("v.priceBookWrap");
            var stp2 = target.get("v.step");
           
            //parseInt(val,10) % 8 === 0
            //parseInt(val,10) % stp === 0
           // val = val.replace('.','').replace(',','.');
           console.log('**Value Of multiple - ' +stp);
            if(stp == 0){
                console.log('** Inside Value Of multiple 0 ');
                 if(parseFloat(val,10) % 1 === 0 && val != 0 ){
                if(val >= pbWrap.min_quantity){
                    pbWrap.volume_discount = pbWrap.actual_volume_discount;
                }
                else{
                    pbWrap.volume_discount = 0;
                }
                component.set("v.priceBookWrap",pbWrap);
            }
            else{
                if(stp2 == '' || stp2 == null){

                }
                else{
                    stp2 = stp2.toString().replace('.',',');
                }
                
                target.set("v.value",'');
                var toastEvent1 = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Qty_should_be_in_multiple_of}")+' '+ 1;
                var titl  = $A.get("{!$Label.c.Error}");
                toastEvent1.setParams({
                    "title": titl,
                    "type": "Error",
                    "message": msg
                    //"duration":'3000'
                });
                toastEvent1.fire();
            }
            }
            else {
                console.log('**Inside Value Of multiple non 0 ');
            if(parseFloat(val,10) % stp === 0){
                if(val >= pbWrap.min_quantity){
                    pbWrap.volume_discount = pbWrap.actual_volume_discount;
                }
                else{
                    pbWrap.volume_discount = 0;
                }
                component.set("v.priceBookWrap",pbWrap);
            }
            else{
                if(stp2 == '' || stp2 == null){

                }
                else{
                    stp2 = stp2.toString().replace('.',',');
                }
                
                target.set("v.value",'');
                var toastEvent1 = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Qty_should_be_in_multiple_of}")+' '+ stp2;
                var titl  = $A.get("{!$Label.c.Error}");
                toastEvent1.setParams({
                    "title": titl,
                    "type": "Error",
                    "message": msg
                    //"duration":'3000'
                });
                toastEvent1.fire();
            }
            }

            var action = component.get('c.calculatePriceAndDiscount');     // call one method from other method..
            $A.enqueueAction(action);
        },

        checkMultipleOf:function(component, event, helper) {
            var target = event.getSource();  
            var val = target.get("v.value"); 
            var stp = target.get("v.step");
            var index = target.get("v.name");
            var ordItem = component.get("v.orderItemWrapList");
            var minQ = ordItem[index].min_quantity;
            var stp2 = target.get("v.step");
            
            //parseInt(val,10) % 8 === 0
            if(parseFloat(val) <= 0){
                target.focus();
                target.set("v.value",0);
                var toastEvent1 = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Please_enter_Quantity}");
                var titl  = $A.get("{!$Label.c.Error}");
                toastEvent1.setParams({
                    "title": titl,
                    "type": "Error",
                    "message": msg
                    //"duration":'3000'
                });
                toastEvent1.fire();
            }
            else{
                
                if(parseFloat(val,10) % stp === 0){
                    if(val >= minQ){
                        ordItem[index].volume_discount = ordItem[index].actual_volume_discount;
                    }
                    else{
                        ordItem[index].volume_discount = 0;
                    }
                    //component.set("v.orderItemWrapList",ordItem);

                    //var ordItem = component.get("v.orderItemWrapList"); 
                    var obj = new Object(ordItem[index]); 
                    
                    if(obj.campaign_discount.length == 0){
                        obj.campaign_discount = 0;
                    }
                    if(obj.line_discount.length == 0){
                        obj.line_discount = 0;
                    }
                    if(obj.volume_discount.length == 0){
                        obj.volume_discount = 0;
                    }

                    // var ordWrap = component.get("v.orderWrapper");
                    //  ordWrap.total_amount = (parseFloat(ordWrap.total_amount) + parseFloat(obj.net_price)).toFixed(2);

                    var actl_dis = obj.actual_campaign_discount + obj.actual_line_discount + obj.actual_volume_discount ;
                    var edt_dis = (parseFloat(obj.campaign_discount) + parseFloat(obj.line_discount) + parseFloat(obj.volume_discount) );

                    obj.actual_discount = actl_dis;
                    obj.edited_discount = edt_dis;
                    
                    var finl_prc = parseFloat(obj.base_price - ((obj.edited_discount * obj.base_price) / 100));
                    obj.final_price = finl_prc;

                    var net_prc = parseFloat(obj.quantity) * finl_prc;
                    obj.net_price = net_prc;

                    ordItem[index] = obj;
                    component.set("v.orderItemWrapList",ordItem); 

                    var action1 = component.get('c.calculateTotalAmt');
                    $A.enqueueAction(action1); 

                    var action = component.get('c.calculateGrossAmt');     // call one method from other method..
                    $A.enqueueAction(action); 
                    //  console.log('Item .. ', component.get("v.orderItemWrapList"));
                    var action4 = component.get('c.draftOrder');
                        $A.enqueueAction(action4);  

                }
                else{
                    if(stp2 == '' || stp2 == null){
                        
                    }
                    else{
                        stp2 = stp2.toString().replace('.',',');
                    }
                    target.set("v.value",0);
                    var toastEvent1 = $A.get("e.force:showToast");
                    var msg  = $A.get("{!$Label.c.Qty_should_be_in_multiple_of}")+' ' + stp2;
                    var titl  = $A.get("{!$Label.c.Error}");
                    toastEvent1.setParams({
                        "title": titl,
                        "type": "Error",
                        "message": msg
                        //"duration":'3000'
                    });
                    toastEvent1.fire();
                }
            }
            /* var action = component.get('c.calculatePrice');     // call one method from other method..
            $A.enqueueAction(action); */

           /*  var action4 = component.get('c.draftOrder');
            $A.enqueueAction(action4);   */
        },

        confirmOrder:function(component, event, helper) {
            var ordWrap = component.get("v.orderWrapper");
            var ordItem = component.get("v.orderItemWrapList");
            var error = false;
            var errMsg = '';
            /*-------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ------------*/
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
            /*---------- End - SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022  ------------*/

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
          /*  else if(ordWrap.po_no == '' || ordWrap.po_no == null){
                error = true;
                component.find("po_number").focus();
                errMsg = $A.get("{!$Label.c.Enter_PO_No}");
            } */ 
            // RITM0207130
            else if(ordItem.length == 0){
                error = true;
                errMsg = $A.get("{!$Label.c.Please_add_product_to_cart}");   // 'Add SKU To Order.';
            }
            else if(ordWrap.inco_term_id == '' || ordWrap.inco_term_id == null){
                error = true;
                errMsg = $A.get("{!$Label.c.Inco_Term_Is_Required}");
            }
            else if(ordWrap.payment_method_id == '' || ordWrap.payment_method_id == null){
                error = true;
                errMsg = $A.get("{!$Label.c.Payment_Method_Is_Required}");
            }
            else if(ordWrap.payment_term_id == '' || ordWrap.payment_term_id == null){
                error = true;
                errMsg = $A.get("{!$Label.c.Payment_Terms_is_required}");
            }
            else if(ordItem.length > 0){  /*-------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ------------*/
                var i;

                for (i = 0; i < ordItem.length; i++) {
                    var obj = new Object(ordItem[i]); 
            
                    /* var x = new Date(obj.shipmnt_date);

                    if(+x < +yy){
                        error = true;
                        errMsg = $A.get("{!$Label.c.Shipment_Date_Can_Not_Be_Less_Than_Today}");
                        break;
                    } */
                    if(error == false && ordWrap.showDeliveryDate == true){
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
                }
            }/*---------- End - SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022  ------------*/

            /*-------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ------------*/
            if(error == false && ordWrap.showPODate == true){
                if(ordWrap.poDate == null){
                    ordWrap.poDate = "";
                    w = "";
                } 
                else{
                    w = new Date(ordWrap.poDate);
                }
                 
                if(ordWrap.isPORequired == true && ordWrap.poDate == ""){
                    error = true;
                    component.find("po_date").focus();
                    errMsg = $A.get("{!$Label.c.Purchase_Order_date_is_required}");
                }
                /* else if(ordWrap.poDate != "" && +w < +y){
                    error = true;
                    component.find("po_date").focus();
                    errMsg = $A.get("{!$Label.c.PO_Date_should_not_be_less_than_todays_date}");
                } */
            }
            /*---------- End - SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022  ------------*/

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
        var sku = component.get("v.orderItemWrapList"); 
        var DuplicateSKUMap = new Map(component.get("v.DuplicateSKUMap"));
        var skuMap = new Map(component.get("v.skuMap"));
        var isNewOrder = component.get("v.isNewOrder");

        if(skuMap.size>0){
            skuMap.clear();
            component.set("v.skuMap",skuMap);
        }
        if(DuplicateSKUMap.size>0){
            DuplicateSKUMap.clear();
            component.set("v.DuplicateSKUMap",DuplicateSKUMap);
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
                if (response.getState() === "SUCCESS") {
                    component.set("v.showSpinner", false);
                var resp = response.getReturnValue();
                console.log('Response.... ',resp);
                if(resp != null){
                    if(resp == true){
                      
                        $A.get('e.force:refreshView').fire();
                        window.history.back();
                    } 
                }                
                }
                  else if(response.getState() == "INCOMPLETE"){
                component.set("v.showSpinner", false);
                }
				else if(response.getState() == "ERROR"){
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
        }
            else{
                window.history.back();
            }
        /* var action1 = component.get('c.deleteAllSKU');
                $A.enqueueAction(action1);
            window.history.back(); */
        },
    
  getTemplateName  :function(component, event, helper){
        var OrderItemList = component.get("v.orderItemWrapList");
        var checkedReorder = component.get("v.allowTemplate");
        //console.log('**checkedReorder - ' +checkedReorder);
        var TemplateName = '';
        var tempName = '';
        var todayDate = new Date();
        var todayMonth = todayDate.getMonth() + 1;
        var todayDay = todayDate.getDate();
        var todayYear = todayDate.getFullYear();
        if(todayDay<10) {todayDay='0'+todayDay;} 
        if(todayMonth<10){todayMonth='0'+todayMonth;} 
        var todayDateText =  todayDay + "-" + todayMonth+ "-" + todayYear;
       
        if(OrderItemList.length > 0){
            for(var i in OrderItemList){
                tempName += OrderItemList[i].sku_name + ' - ' ;
            }
            
            TemplateName =  todayDateText + ', ' + tempName;
             
            
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
      if(checkedReorder == true){
        component.set("v.TemplateName", TemplateName);
      }
      else {
          component.set("v.TemplateName", '');
      }
        },
    
   getTemplateList  :function(component, event, helper){
       component.set("v.showSpinner", true);
       var creditSummaryWrap =component.get("v.creditSummaryWrap"); 
       var accSAPCode = creditSummaryWrap.sap_code;
       //console.log('**ReOrder for Account- ' +creditSummaryWrap.account_name +' '+accSAPCode);
       var action = component.get("c.showOrderTemplates");
         action.setParams({
            accSAPCode : accSAPCode
        });
       action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var retVal = response.getReturnValue();
                component.set("v.TemplateList", retVal);
                var tempList = component.get("v.TemplateList"); 
                //console.log('**TemplateList - '+JSON.stringify(tempList));
                helper.toggle(component, event, helper, 'lookupmodal5', 'backdrop5');
                component.set("v.showSpinner", false);
            }else if(state === "INCOMPLETE"){
                console.log("INCOMPLETE");
                component.set("v.showSpinner", false);
                //this.showToast(component, event, helper, 'error', 'Error', 'From server: ' + response.getReturnValue());
            }else if(state === "ERROR"){
                component.set("v.showSpinner", false);
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error message: " + errors[0].message);
                        //this.showToast(component, event, helper, 'error', 'Error', 'From server: ' + errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
       
   },
        closePopUp5 : function(component, event, helper){
        helper.toggle(component, event, helper, 'lookupmodal5', 'backdrop5');
    },
    
    selectTemplate : function(component, event, helper){
        helper.toggle(component, event, helper, 'lookupmodal5', 'backdrop5');
        component.set("v.showSpinner", true);
        var orderItems = component.get("v.orderItemWrapList");
        var ordWrap = component.get("v.orderWrapper");
        var target = event.target;
        var currentRow = target.getAttribute("data-row-index");
        var templateList = component.get("v.TemplateList");
        var selectedTemplateId = templateList[currentRow].Id;
        //console.log('Selected OrderItem - ' +selectedTemplateId);
        //console.log('orderWrapper Present- ' +JSON.stringify(ordWrap));
        //console.log('orderWrapper OrderId- ' +JSON.stringify(ordWrap.ordr_id));
        if(ordWrap!=null){
        var action = component.get("c.loadTemplate");
        action.setParams({ 
            orderObj : JSON.stringify(ordWrap),
            tempIdChosen : selectedTemplateId,
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var retVal = response.getReturnValue();
                
                //console.log('Reorder Response - ' +JSON.stringify(retVal.orderItemList));
                //component.set("v.PaymentMethod", JSON.stringify(retVal.payment_Methods));
                component.set('v.orderWrapper',retVal);
				 component.set('v.orderItemWrapList',retVal.orderItemList);
                var action1 = component.get('c.calculateTotalAmt');
                $A.enqueueAction(action1); 

                var action2 = component.get('c.calculateGrossAmt');     
                $A.enqueueAction(action2); 
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
                  
        } 
        },
    
})