({
    doInit: function (component, event, helper) {
      var recordId = component.get("v.recordId");
      console.log("recordId.... : " + recordId);
      component.find("skuId").makeDisabled(true); // to disable sku search pill
      //component.set("v.fileName", "");
      if (recordId != "" || recordId != null) {
        var newMp = new Map();
        component.set("v.skuMap", newMp);
        component.set("v.orderForMap", newMp);
        helper.orderDetails(component, event, helper);
      }
    },
  
    onShippingChange: function (component, event, helper) {
      var locId = event.getSource().get("v.value");
      console.log("locId ... - ", locId);
      //var ordTyp = component.find("shipping_address").get("v.value");
      var ordrWrap = component.get("v.orderWrapper");
      var shippingMap = component.get("v.shippingMap");
      if (locId == null || locId == "") {
        ordrWrap.shipping_loc_details = "";
      } else {
        var obj = new Object();
        obj = shippingMap[locId];
        console.log("Ship Adr ... - ", JSON.stringify(shippingMap[locId]));
        ordrWrap.shipping_loc_details = "";
        if (obj.Billing_Street_1__c != "None") {
          ordrWrap.shipping_loc_details = obj.Billing_Street_1__c;
        } else if (obj.Billing_Street_2__c != "None") {
          ordrWrap.shipping_loc_details =
            ordrWrap.shipping_loc_details + ", " + obj.Billing_Street_2__c;
        } else if (obj.Billing_Street_3__c != "None") {
          ordrWrap.shipping_loc_details =
            ordrWrap.shipping_loc_details + ", " + obj.Billing_Street_3__c;
        } else if (obj.Billing_Street_4__c != "None") {
          ordrWrap.shipping_loc_details =
            ordrWrap.shipping_loc_details + ", " + obj.Billing_Street_4__c;
        } else if (obj.Billing_Street_5__c != "None") {
          ordrWrap.shipping_loc_details =
            ordrWrap.shipping_loc_details + ", " + obj.Billing_Street_5__c;
        } else if (obj.Billing_Street_6__c != "None") {
          ordrWrap.shipping_loc_details =
            ordrWrap.shipping_loc_details + ", " + obj.Billing_Street_6__c;
        } else if (obj.Region__c != "None") {
          ordrWrap.shipping_loc_details =
            ordrWrap.shipping_loc_details + ", " + obj.Region__c;
        }
        if (obj.Country_Name__c != "None") {
          // country name field is used for refence as City name..
          ordrWrap.shipping_loc_details =
            ordrWrap.shipping_loc_details + ", " + obj.Country_Name__c;
        }
        if (obj.State__c != "None") {
          ordrWrap.shipping_loc_details =
            ordrWrap.shipping_loc_details + ", " + obj.State__c;
        }
        if (obj.Pincode__c != "None") {
          ordrWrap.shipping_loc_details =
            ordrWrap.shipping_loc_details + ", " + obj.Pincode__c;
        }
      }
      component.set("v.orderWrapper", ordrWrap);
    },
  
    onOrderForChange: function (component, event, helper) {
      var ordFr = component.find("order_for").get("v.value");
      if (ordFr != "" || ordFr != null) {
        helper.handleOrderForChng(component, event, helper);
      }
    },
  
    handleSKUChange: function (component, event, helper) {
      console.log(
        "JSON Normal test - ",
        JSON.stringify(component.get("v.selectedPBRecord"))
      );
      console.log(
        "JSON parse test - ",
        JSON.parse(JSON.stringify(component.get("v.selectedPBRecord")))
      );
      var pb = JSON.parse(JSON.stringify(component.get("v.selectedPBRecord")));
      var pbWrap = JSON.parse(JSON.stringify(component.get("v.priceBookWrap")));
      var ordrWrap = component.get("v.orderWrapper");
      //console.log('handleSKUChange ', pb.Id);
  
      if (pb.Id != undefined) {
        pbWrap.pb_id = pb.Id;
        pbWrap.sku_name = pb.SKUCode__r.SKU_Description__c;
        pbWrap.sku_id = pb.SKUCode__r.Id;
        pbWrap.uom = pb.UOM__c;
        pbWrap.min_price = pb.MinPrice__c;
        pbWrap.max_price = pb.Price__c;
        pbWrap.distributionChanlIds = pb.DistributionChannel__c;
        pbWrap.divisionIds = pb.Division__c;
        pbWrap.multiple_of = pb.SKUCode__r.Multiple_of__c;
  
        component.set("v.priceBookWrap", pbWrap);
        helper.getInventory(component, event, helper);
      } else {
        var action = component.get("c.resetPBObj"); // call one method from other method..
        $A.enqueueAction(action);
      }
    },
  
    addSKU: function (component, event, helper) {
      var ordWrap = component.get("v.orderWrapper");
      var pbWrap = JSON.parse(JSON.stringify(component.get("v.priceBookWrap")));
      var skuMap = new Map(component.get("v.skuMap"));
      var error = false;
      var showDel =
        component.get(
          "v.showDeliveryDate"
        ); /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 Start */
      //var today = new Date(); // for current date..
      /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 Start */
      var crDt = new Date();
      var d = (crDt.getDate() < 10 ? "0" : "") + crDt.getDate();
      var M = (crDt.getMonth() + 1 < 10 ? "0" : "") + (crDt.getMonth() + 1);
      var y = crDt.getFullYear();
      var currentDt = y + "-" + M + "-" + d;
      var yy = new Date(currentDt);
  
      var today = new Date(crDt.getTime() + 86400000); // for current date + 1 ...
      var dd = (today.getDate() < 10 ? "0" : "") + today.getDate();
      var MM = (today.getMonth() + 1 < 10 ? "0" : "") + (today.getMonth() + 1);
      var yyyy = today.getFullYear();
      var currentDate = yyyy + "-" + MM + "-" + dd;
      var z = "";
      var x = new Date(component.find("pay_date").get("v.value"));
      var y = new Date(currentDate);
      //var dt = component.find("delvery_date").get("v.value");
      var errMsg = "";
      /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 End */
  
      if (pbWrap == null) {
        error = true;
        errMsg = $A.get("{!$Label.c.SKU_Not_Selected}");
      } else if (pbWrap.sku_id == "" || pbWrap.sku_id == null) {
        error = true;
        //  component.find("skuId").focus();
        errMsg = $A.get("{!$Label.c.Please_Select_SKU}");
      } else if (pbWrap.net_price <= 0) {
      /* else if(skuMap.has(pbWrap.sku_id)){
                  error = true;
                  errMsg = $A.get("{!$Label.c.Duplicate_entries_are_not_allowed}"); 
              }  */
        error = true;
        //component.find("net_price").focus();
        errMsg = $A.get("{!$Label.c.SKU_with_zero_final_price_can_not_be_added}");
      } else if (pbWrap.quantity <= 0) {
        error = true;
        //component.find("quantity").focus();
        errMsg = $A.get("{!$Label.c.Please_enter_Quantity}");
      } else if (+x < +yy) {
        // shipment date greated than today...
        error = true;
        component.find("pay_date").focus();
        errMsg = $A.get(
          "{!$Label.c.Date_of_payment_should_not_be_less_than_todays_date}"
        );
      } else if (ordWrap.showDeliveryDate == true) {
      /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 Start */
        var dt = component.find("delvery_date").get("v.value");
        if (dt == null) {
          dt = "";
          z = "";
        } else {
          z = new Date(dt);
        }
  
        if (ordWrap.isDeliveryRequired == true && dt == null) {
          error = true;
          component.find("delvery_date").focus();
          errMsg = $A.get("{!$Label.c.Delivery_Date_is_Required}");
        } else if (dt != null && +z < +y) {
          error = true;
          component.find("delvery_date").focus();
          errMsg = $A.get(
            "{!$Label.c.Date_of_delivery_should_not_be_less_than_todays_date}"
          );
        } else if (dt == null || dt == "") {
          z = "";
        }
      }
      /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 End */
  
      /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 Start */
      if (error == true) {
        var toastEvent1 = $A.get("e.force:showToast");
        var titl = $A.get("{!$Label.c.Error}");
        toastEvent1.setParams({
          title: titl,
          type: "Error",
          message: errMsg,
          //"duration":'3000'
        });
        toastEvent1.fire();
      } /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 End */ else {
        var ordItem = component.get("v.orderItemWrapList");
        var itemObj = new Array();
        itemObj = {
          orderItem_id: "",
          order_id: "",
          pb_id: pbWrap.pb_id,
          sku_name: pbWrap.sku_name,
          sku_id: pbWrap.sku_id,
          uom: pbWrap.uom,
          max_price: pbWrap.max_price,
          min_price: pbWrap.min_price,
          quantity: pbWrap.quantity,
          payment_date: x, //pbWrap.shipmnt_date,
          inventory: pbWrap.inventory,
          net_price: pbWrap.net_price,
          final_price: pbWrap.final_price,
          multiple_of: pbWrap.multiple_of,
          distributionChanlIds: pbWrap.distributionChanlIds,
          divisionIds: pbWrap.divisionIds,
          itemNumber: 0,
          deliveryDate: z, // SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022...
        };
  
        ordItem.push(itemObj);
        //ordItem = JSON.parse(JSON.stringify(ordItem));
        component.set("v.orderItemWrapList", ordItem);
        skuMap.set(pbWrap.sku_id, pbWrap.sku_id);
        component.set("v.skuMap", skuMap);
  
        var action1 = component.get("c.calculateTotalAmt");
        $A.enqueueAction(action1);
  
        component.find("skuId").makeReset(false); // to reset sku search pill
        var action3 = component.get("c.resetPBObj"); // call one method from other method..
        $A.enqueueAction(action3);
  
        component.set("v.itemIndex", "");
        component.set("v.indexFlag", false);
        var action4 = component.get("c.draftOrder");
        $A.enqueueAction(action4);
      }
    },
  
    calculatePriceAndDiscount: function (component, event, helper) {
      var pbWrap = JSON.parse(JSON.stringify(component.get("v.priceBookWrap")));
  
      if (pbWrap.quantity.length == 0) {
        pbWrap.quantity = 0;
      }
      if (pbWrap.net_price == null) {
        pbWrap.net_price = 0.0;
      }
  
      var net_prc = parseFloat(
        parseFloat(pbWrap.quantity) * parseFloat(pbWrap.net_price)
      ).toFixed(2);
  
      pbWrap.final_price = net_prc;
  
      //pbWrap.net_price = parseFloat(pbWrap.net_price).toFixed(2);
      component.set("v.isLoaded", false); // to rerender input field, to avoid validation error..
      component.set("v.priceBookWrap", pbWrap);
      component.set("v.isLoaded", true); // to rerender input field, to avoid validation error..
    },
  
    calculatePrice: function (component, event, helper) {
      var target = event.getSource();
      var index = target.get("v.name");
      var ordItem = component.get("v.orderItemWrapList");
      var pbWrap = new Object(ordItem[index]);
  
      component.set("v.itemIndex", index);
      component.set("v.indexFlag", true);
  
      var net_prc = parseFloat(
        parseFloat(pbWrap.quantity) * parseFloat(pbWrap.net_price)
      ).toFixed(2);
  
      pbWrap.final_price = net_prc;
      component.set("v.isLoaded", false); // to rerender input field, to avoid validation error..
      ordItem[index] = pbWrap;
      component.set("v.orderItemWrapList", ordItem);
      component.set("v.isLoaded", true); // to rerender input field, to avoid validation error..
  
      var action1 = component.get("c.calculateTotalAmt");
      $A.enqueueAction(action1);
  
      var action4 = component.get("c.draftOrder");
      $A.enqueueAction(action4);
    },
  
    deleteSKU: function (component, event, helper) {
      component.set("v.showSpinner", true);
      var target = event.getSource();
      var index = target.get("v.value");
      var sku = component.get("v.orderItemWrapList");
      var obj = target.get("v.name");
      var ordWrap = component.get("v.orderWrapper");
      var type = "";
      var skuMap = new Map(component.get("v.skuMap"));
      var isCustmSer = component.get("v.isCustomerService");
  
      //var early_dis = component.find("early_ord_discount").get("v.value");
      //console.log('deleteSKU Id- ',obj);
      //console.log('sku length f.... ',sku.length);
      if (skuMap.size > 0) {
        if (skuMap.has(sku[index].sku_id)) {
          skuMap.delete(sku[index].sku_id);
          component.set("v.skuMap", skuMap);
        }
      }
  
      if (obj.length == 0) {
        var action1 = component.get("c.calculateTotalAmt");
        $A.enqueueAction(action1);
  
        if (index > -1) {
          sku.splice(index, 1);
        }
        component.set("v.orderItemWrapList", sku);
        if (sku.length == 0) {
          component.set("v.disableDate", false);
          if (isCustmSer == true) {
            component.set("v.orderTypDisable", false);
          }
        }
  
        component.set("v.showSpinner", false);
      } else {
        if (ordWrap.isSalesOrder == true) {
          type = "Sales Order";
        } else {
          type = "Order";
        }
  
        var action = component.get("c.deleteLineItem");
        action.setParams({
          itemId: obj,
          type: type,
          netPrc: parseFloat(sku[index].final_price),
        });
  
        action.setCallback(this, function (response) {
          if (response.getState() == "SUCCESS") {
            var resp = response.getReturnValue();
            console.log("Response.... ", resp);
            if (resp != null) {
              if (resp == true) {
                var action1 = component.get("c.calculateTotalAmt");
                $A.enqueueAction(action1);
  
                if (index > -1) {
                  sku.splice(index, 1);
                }
                component.set("v.orderItemWrapList", sku);
                if (sku.length == 0) {
                  component.set("v.disableDate", false);
                  if (isCustmSer == true) {
                    component.set("v.orderTypDisable", false);
                  }
                }
                //console.log('sku length.... ',sku.length);
                var errMsg = $A.get("{!$Label.c.Line_Item_Deleted}");
                var toastEvent1 = $A.get("e.force:showToast");
                var titl = $A.get("{!$Label.c.Success}");
                toastEvent1.setParams({
                  title: titl,
                  type: "Success",
                  message: errMsg,
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
  
    deleteAllSKU: function (component, event, helper) {
      var sku = component.get("v.orderItemWrapList");
      var skuMap = new Map(component.get("v.skuMap"));
      var isCustmSer = component.get("v.isCustomerService");
      if (skuMap.size > 0) {
        skuMap.clear();
        component.set("v.skuMap", skuMap);
      }
  
      if (sku.length > 0) {
        component.set("v.showSpinner", true);
        var ordWrap = component.get("v.orderWrapper");
        var type = "";
        var ordId = "";
  
        if (ordWrap.isSalesOrder == true) {
          type = "Sales Order";
          ordId = ordWrap.so_id;
        } else {
          type = "Order";
          ordId = ordWrap.ordr_id;
        }
  
        var action = component.get("c.deleteAllLineItem");
        action.setParams({
          ordrId: ordId,
          type: type,
        });
  
        action.setCallback(this, function (response) {
          if (response.getState() == "SUCCESS") {
            var resp = response.getReturnValue();
            console.log("Response.... ", resp);
            if (resp != null) {
              if (resp == true) {
                component.set("v.disableDate", false);
                if (isCustmSer == true) {
                  component.set("v.orderTypDisable", false);
                }
                var errMsg = $A.get("{!$Label.c.Line_Item_Deleted}");
                var toastEvent1 = $A.get("e.force:showToast");
                var titl = $A.get("{!$Label.c.Success}");
                toastEvent1.setParams({
                  title: titl,
                  type: "Success",
                  message: errMsg,
                  //"duration":'3000'
                });
                toastEvent1.fire();
                $A.get("e.force:refreshView").fire();
              }
            }
          }
          component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
      }
    },
  
    resetPBObj: function (component, event, helper) {
      var pbWrap = JSON.parse(JSON.stringify(component.get("v.priceBookWrap")));
      var showDel = component.get("v.showDeliveryDate"); // SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022...
      //console.log('cmpgnId.... ',cmpgnId);
      pbWrap.pb_id = "";
      pbWrap.sku_name = "";
      pbWrap.sku_id = "";
      pbWrap.uom = "";
      pbWrap.min_price = 0.0;
      pbWrap.max_price = 0.0;
      pbWrap.net_price = 0.0;
      pbWrap.final_price = 0.0;
      pbWrap.distributionChanlIds = "";
      pbWrap.divisionIds = "";
      pbWrap.multiple_of = 0.0;
      pbWrap.quantity = 0.0;
      pbWrap.inventory = 0.0;
      /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 Start */
      //var today = new Date();
      var crDt = new Date();
      var today = new Date(crDt.getTime() + 86400000); // for current date + 1 ...
      var dd = (today.getDate() < 10 ? "0" : "") + today.getDate();
      var MM = (today.getMonth() + 1 < 10 ? "0" : "") + (today.getMonth() + 1);
      var yyyy = today.getFullYear();
      var currentDate = yyyy + "-" + MM + "-" + dd;
      if (showDel == true) {
        component.find("delvery_date").set("v.value", currentDate);
      }
      /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 End */
      var lst = [];
      component.set("v.campaignDiscountList", lst);
  
      component.set("v.priceBookWrap", pbWrap);
    },
  
    validateCurrentDate: function (component, event, helper) {
      var target = event.getSource();
      var val = target.get("v.value");
  
      //console.log('Item .. ', JSON.stringify(obj));
      //console.log('Date.. ', obj.shipmnt_date);
  
      var today = new Date();
      var dd = (today.getDate() < 10 ? "0" : "") + today.getDate();
      var MM = (today.getMonth() + 1 < 10 ? "0" : "") + (today.getMonth() + 1);
      var yyyy = today.getFullYear();
      var currentDate = yyyy + "-" + MM + "-" + dd;
  
      var x = new Date(val);
      var y = new Date(currentDate);
  
      if (+x < +y) {
        // shipment date greated than today...
  
        target.focus();
        var errMsg = $A.get(
          "{!$Label.c.Date_of_payment_should_not_be_less_than_todays_date}"
        );
        var toastEvent1 = $A.get("e.force:showToast");
        var titl = $A.get("{!$Label.c.Error}");
        toastEvent1.setParams({
          title: titl,
          type: "Error",
          message: errMsg,
          //"duration":'3000'
        });
        toastEvent1.fire();
      }
      //New toast message has been added to alert the user when they enter the paymet date >270-RITM0397864--Starts
      var selectedDate = x; //selected date
      var currentDateToday = y; //current date
      var timeDifference = selectedDate.getTime() - currentDateToday.getTime();
      var dayDifference = timeDifference / (1000 * 60 * 60 * 24);
      if (dayDifference > 270) {
        var daysErrMsg = $A.get("{!$Label.c.isPaymentDateGT270}");
        var toastEventDate = $A.get("e.force:showToast");
  
        toastEventDate.setParams({
          type: "Info",
          message: daysErrMsg,
        });
        toastEventDate.fire();
      }
      //ends
    },
    /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 Start */
    validateDeliveryDate: function (component, event, helper) {
      var target = event.getSource();
      var val = target.get("v.value");
      var showDel = component.get("v.showDeliveryDate");
      //console.log('validateDeliveryDate - ', val);
      //var today = new Date();
      var crDt = new Date();
      var today = new Date(crDt.getTime() + 86400000); // for current date + 1 ...
      var dd = (today.getDate() < 10 ? "0" : "") + today.getDate();
      var MM = (today.getMonth() + 1 < 10 ? "0" : "") + (today.getMonth() + 1);
      var yyyy = today.getFullYear();
      var currentDate = yyyy + "-" + MM + "-" + dd;
  
      var y = new Date(currentDate);
  
      if (showDel == true && val != null) {
        var x = new Date(val);
        if (+x < +y) {
          target.focus();
          var errMsg = $A.get(
            "{!$Label.c.Date_of_delivery_should_not_be_less_than_todays_date}"
          );
          var toastEvent1 = $A.get("e.force:showToast");
          var titl = $A.get("{!$Label.c.Error}");
          toastEvent1.setParams({
            title: titl,
            type: "Error",
            message: errMsg,
            //"duration":'3000'
          });
          toastEvent1.fire();
        }
      }
    },
  
    validateDate: function (component, event, helper) {
      var target = event.getSource();
      var index = target.get("v.name");
      var ordItem = component.get("v.orderItemWrapList");
      var obj = new Object(ordItem[index]);
      var flag = false;
      var showDel = component.get("v.showDeliveryDate");
      var reqDel = component.get("v.isDeliveryDateReq");
      //console.log('Item .. ', JSON.stringify(obj));
  
      if (obj.deliveryDate == null) {
        obj.deliveryDate = "";
      }
      //var today = new Date();
      var crDt = new Date();
      var today = new Date(crDt.getTime() + 86400000); // for current date + 1 ...
      var dd = (today.getDate() < 10 ? "0" : "") + today.getDate();
      var MM = (today.getMonth() + 1 < 10 ? "0" : "") + (today.getMonth() + 1);
      var yyyy = today.getFullYear();
      var currentDate = yyyy + "-" + MM + "-" + dd;
  
      var y = new Date(currentDate);
  
      if (showDel == true && obj.deliveryDate != "") {
        var x = new Date(obj.deliveryDate);
        if (+x < +y) {
          // shipment date greated than today...
          flag = true;
          target.focus();
          var errMsg = $A.get(
            "{!$Label.c.Date_of_delivery_should_not_be_less_than_todays_date}"
          );
          var toastEvent1 = $A.get("e.force:showToast");
          var titl = $A.get("{!$Label.c.Error}");
          toastEvent1.setParams({
            title: titl,
            type: "Error",
            message: errMsg,
            //"duration":'3000'
          });
          toastEvent1.fire();
        }
      }
      if (flag == false) {
        component.set("v.itemIndex", "");
        component.set("v.indexFlag", false);
        var action4 = component.get("c.draftOrder");
        $A.enqueueAction(action4);
      }
    },
    /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 End */
  
    calculateTotalAmt: function (component, event, helper) {
      var ordWrap = component.get("v.orderWrapper");
      var ordItem = component.get("v.orderItemWrapList");
      var i;
      var tot_amt = "0";
      var qun_kg = 0;
      var qun_kg_amt = 0;
      var qun_ltr = 0;
      var qun_ltr_amt = 0;
      var qun_each = 0;
      var qun_each_amt = 0;
  
      for (i = 0; i < ordItem.length; i++) {
        var obj = new Object(ordItem[i]);
        tot_amt = parseFloat(tot_amt) + parseFloat(obj.final_price);
  
        if (obj.uom.toUpperCase() == "KG") {
          qun_kg = qun_kg + parseFloat(obj.quantity);
          qun_kg_amt = qun_kg_amt + parseFloat(obj.final_price);
        } else if (obj.uom.toUpperCase() == "L") {
          qun_ltr = qun_ltr + parseFloat(obj.quantity);
          qun_ltr_amt = qun_ltr_amt + parseFloat(obj.final_price);
        } else if (obj.uom.toUpperCase() == "Each") {
          qun_each = qun_each + parseFloat(obj.quantity);
          qun_each_amt = qun_each_amt + parseFloat(obj.final_price);
        }
      }
  
      ordWrap.total_amount = parseFloat(tot_amt).toFixed(2);
  
      ordWrap.quantity_kg = qun_kg.toFixed(2);
      ordWrap.net_price_kg = qun_kg_amt.toFixed(2);
  
      ordWrap.quantity_litre = qun_ltr.toFixed(2);
      ordWrap.net_price_litre = qun_ltr_amt.toFixed(2);
  
      ordWrap.quantity_each = qun_each.toFixed(2);
      ordWrap.net_price_each = qun_each_amt.toFixed(2);
  
      component.set("v.orderWrapper", ordWrap);
    },
  
    handleFilesChange: function (component, event, helper) {
      var fileName = $A.get("{!$Label.c.No_file_selected}");
      if (event.getSource().get("v.files").length > 0) {
        fileName = event.getSource().get("v.files")[0]["name"];
        component.set("v.isFileReq", true);
      }
      component.set("v.fileName", fileName);
    },
  
    handleOrderTypChange: function (component, event, helper) {
      var target = event.getSource();
      var val = target.get("v.value");
  
      if (val.length > 0) {
        if (val == "Exceptional") {
          component.set("v.isExceptional", true);
        } else {
          component.set("v.isExceptional", false);
        }
      }
  
      component.find("skuId").makeReset(false); // to reset sku search pill
      var action3 = component.get("c.resetPBObj"); // call one method from other method..
      $A.enqueueAction(action3);
    },
  
    draftOrder: function (component, event, helper) {
      /* var target = event.getSource();  
              var index = target.get("v.name"); */
      var ordWrap = component.get("v.orderWrapper");
      var ordItem = component.get("v.orderItemWrapList");
      var index = component.get("v.itemIndex");
      var indxFlag = component.get("v.indexFlag");
      var error2 = false;
      console.log("payment_date draft - ", new Date(ordWrap.payment_date));
      /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 Start */
      //var today = new Date();
      var crDt = new Date();
      var d = (crDt.getDate() < 10 ? "0" : "") + crDt.getDate();
      var M = (crDt.getMonth() + 1 < 10 ? "0" : "") + (crDt.getMonth() + 1);
      var y = crDt.getFullYear();
      var currentDt = y + "-" + M + "-" + d;
      var yy = new Date(currentDt);
  
      var today = new Date(crDt.getTime() + 86400000); // for current date + 1 ...
      var dd = (today.getDate() < 10 ? "0" : "") + today.getDate();
      var MM = (today.getMonth() + 1 < 10 ? "0" : "") + (today.getMonth() + 1);
      var yyyy = today.getFullYear();
      var currentDate = yyyy + "-" + MM + "-" + dd;
  
      var x = new Date(ordWrap.payment_date);
      var y = new Date(currentDate);
      /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 End */
      if (+x < +yy) {
        // shipment date greated than today...
        error2 = true;
        component.find("pay_date").focus();
        var errMsg = $A.get(
          "{!$Label.c.Date_of_payment_should_not_be_less_than_todays_date}"
        );
        var toastEvent1 = $A.get("e.force:showToast");
        var titl = $A.get("{!$Label.c.Error}");
        toastEvent1.setParams({
          title: titl,
          type: "Error",
          message: errMsg,
          //"duration":'3000'
        });
        toastEvent1.fire();
      } else if (ordWrap.showDeliveryDate == true) {
      /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 Start */
        ordItem.forEach(function (item) {
          var obj = new Object(item);
          if (obj.deliveryDate == "" || obj.deliveryDate == null) {
            //
          } else {
            var z = new Date(obj.deliveryDate);
            if (+z < +y) {
              error2 = true;
              component.find("delvery_date").focus();
              var errMsg = $A.get(
                "{!$Label.c.Date_of_delivery_should_not_be_less_than_todays_date}"
              );
              var toastEvent1 = $A.get("e.force:showToast");
              var titl = $A.get("{!$Label.c.Error}");
              toastEvent1.setParams({
                title: titl,
                type: "Error",
                message: errMsg,
                //"duration":'3000'
              });
              toastEvent1.fire();
            }
          }
        });
      }
      /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 End */
      if (error2 == false) {
        component.set("v.disableButton", true);
        ordWrap.orderItemList = ordItem;
        component.set("v.orderWrapper", ordWrap);
  
        if (ordWrap.isSalesOrder == true) {
          var error = false;
          if (ordWrap.payment_term_id == "" || ordWrap.payment_term_id == null) {
            error = true;
            errMsg = $A.get("{!$Label.c.Payment_Terms_is_required}");
          }
  
          if (error == true) {
            var toastEvent1 = $A.get("e.force:showToast");
            var titl = $A.get("{!$Label.c.Error}");
            toastEvent1.setParams({
              title: titl,
              type: "Error",
              message: errMsg,
              //"duration":'3000'
            });
            toastEvent1.fire();
          } else {
            helper.updateSO(component, event, helper);
          }
        } else {
          helper.saveAsDraft(component, event, helper);
        }
      }
      component.set("v.itemIndex", "");
    },
  
    draftSO: function (component, event, helper) {
      var ordWrap = component.get("v.orderWrapper");
      var ordItem = component.get("v.orderItemWrapList");
      var error = false;
      var errMsg = "";
      var fileInput = component.find("fileId").get("v.files");
      var fileReq = component.get("v.isFileReq");
      //var today = new Date();
      /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 Start */
      var crDt = new Date();
      var d = (crDt.getDate() < 10 ? "0" : "") + crDt.getDate();
      var M = (crDt.getMonth() + 1 < 10 ? "0" : "") + (crDt.getMonth() + 1);
      var y = crDt.getFullYear();
      var currentDt = y + "-" + M + "-" + d;
      var yy = new Date(currentDt);
  
      var today = new Date(crDt.getTime() + 86400000); // for current date + 1 ...
      var dd = (today.getDate() < 10 ? "0" : "") + today.getDate();
      var MM = (today.getMonth() + 1 < 10 ? "0" : "") + (today.getMonth() + 1);
      var yyyy = today.getFullYear();
      var currentDate = yyyy + "-" + MM + "-" + dd;
      var x = new Date(ordWrap.payment_date);
      var y = new Date(currentDate);
      //var z = new Date(ordWrap.delivry_date);
      /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 End */
      console.log("payment_date draft - ", new Date(ordWrap.payment_date));
  
      if (ordWrap.orderFor == "" || ordWrap.orderFor == null) {
        error = true;
        component.find("order_for").focus();
        errMsg = $A.get("{!$Label.c.Please_Select_Order_For}");
      } else if (ordWrap.shipping_loc == "" || ordWrap.shipping_loc == null) {
        error = true;
        component.find("shipping_address").focus();
        errMsg = $A.get("{!$Label.c.Select_Shipping_Address}");
      } else if (ordItem.length == 0) {
      /* else if((fileInput == null || fileInput.length <= 0) && fileReq == true){
                  error = true;
                  component.find("fileId").focus();
                  errMsg = $A.get("{!$Label.c.Please_select_file}");
              } */
        error = true;
        errMsg = $A.get("{!$Label.c.Please_add_product_to_cart}"); // 'Add SKU To Order.';
      } else if (
        ordWrap.payment_term_id == "" ||
        ordWrap.payment_term_id == null
      ) {
        error = true;
        errMsg = $A.get("{!$Label.c.Payment_Terms_is_required}");
      } else if (+x < +yy) {
        error = true;
        component.find("pay_date").focus();
        errMsg = $A.get(
          "{!$Label.c.Date_of_payment_should_not_be_less_than_todays_date}"
        );
      } else if (ordWrap.showDeliveryDate == true) {
      /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 Start */
        ordItem.forEach(function (item) {
          var obj = new Object(item);
          if (obj.deliveryDate == null) {
            //
          } else {
            var z = new Date(obj.deliveryDate);
            if (+z < +y) {
              error = true;
              //component.find("delivery_date").focus();
              errMsg = $A.get(
                "{!$Label.c.Date_of_delivery_should_not_be_less_than_todays_date}"
              );
            }
          }
        });
      }
      /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 End */
  
      /* else if(ordWrap.po_no == '' || ordWrap.po_no == null){
                  error = true;
                  component.find("po_number").focus();
                  errMsg = $A.get("{!$Label.c.Enter_PO_No}");
              } */
  
      /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 Start */
      if (error == true) {
        var toastEvent1 = $A.get("e.force:showToast");
        var titl = $A.get("{!$Label.c.Error}");
        toastEvent1.setParams({
          title: titl,
          type: "Error",
          message: errMsg,
          //"duration":'3000'
        });
        toastEvent1.fire();
      } /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 End */ else {
        component.set("v.disableButton", true);
        component.set("v.isSODraft", true);
        ordWrap.orderItemList = ordItem;
        ordWrap.status = "Draft";
        component.set("v.orderWrapper", ordWrap);
        helper.updateSO(component, event, helper);
      }
    },
  
    redirectToOrder: function (component, event, helper) {
      var soId = component.get("v.soList");
  
      window.history.forward();
      window.open("/lightning/r/Sales_Order__c/" + soId[0] + "/view", "_self");
  
      component.set("v.showSuccess", false);
      component.set("v.showSOSuccess", false);
      component.set("v.showSpinner", true);
    },
  
    confirmOrder: function (component, event, helper) {
      var ordWrap = component.get("v.orderWrapper");
      var ordItem = component.get("v.orderItemWrapList");
      var error = false;
      var errMsg = "";
      var fileInput = component.find("fileId").get("v.files");
      var fileReq = component.get("v.isFileReq");
      /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 Start */
      //var today = new Date();
      var crDt = new Date();
      var d = (crDt.getDate() < 10 ? "0" : "") + crDt.getDate();
      var M = (crDt.getMonth() + 1 < 10 ? "0" : "") + (crDt.getMonth() + 1);
      var y = crDt.getFullYear();
      var currentDt = y + "-" + M + "-" + d;
      var yy = new Date(currentDt);
  
      var today = new Date(crDt.getTime() + 86400000); // for current date + 1 ...
      var dd = (today.getDate() < 10 ? "0" : "") + today.getDate();
      var MM = (today.getMonth() + 1 < 10 ? "0" : "") + (today.getMonth() + 1);
      var yyyy = today.getFullYear();
      var currentDate = yyyy + "-" + MM + "-" + dd;
      var x = new Date(ordWrap.payment_date);
      var y = new Date(currentDate);
      var w = new Date(ordWrap.poDate);
      /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 End */
  
      console.log("payment_date draft - ", new Date(ordWrap.payment_date));
  
      if (ordWrap.orderFor == "" || ordWrap.orderFor == null) {
        error = true;
        component.find("order_for").focus();
        errMsg = $A.get("{!$Label.c.Please_Select_Order_For}");
      } else if (ordWrap.shipping_loc == "" || ordWrap.shipping_loc == null) {
        error = true;
        component.find("shipping_address").focus();
        errMsg = $A.get("{!$Label.c.Select_Shipping_Address}");
      } else if (ordItem.length == 0) {
      /* else if((fileInput == null || fileInput.length <= 0) && fileReq == true){
                  error = true;
                  component.find("fileId").focus();
                  errMsg = $A.get("{!$Label.c.Please_select_file}");
              } */
      /* else if(ordWrap.po_no == '' || ordWrap.po_no == null){
                  error = true;
                  component.find("po_number").focus();
                  errMsg = $A.get("{!$Label.c.Enter_PO_No}");
              } */
        error = true;
        errMsg = $A.get("{!$Label.c.Please_add_product_to_cart}"); // 'Add SKU To Order.';
      } else if (
        ordWrap.payment_term_id == "" ||
        ordWrap.payment_term_id == null
      ) {
        error = true;
        errMsg = $A.get("{!$Label.c.Payment_Terms_is_required}");
      } else if (+x < +yy) {
        error = true;
        component.find("pay_date").focus();
        errMsg = $A.get(
          "{!$Label.c.Date_of_payment_should_not_be_less_than_todays_date}"
        );
      }
      /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 Start */
      if (error == false && ordWrap.showDeliveryDate == true) {
        ordItem.forEach(function (item) {
          var obj = new Object(item);
          if (obj.deliveryDate == null) {
            //
          } else {
            var z = new Date(obj.deliveryDate);
            if (+z < +y) {
              error = true;
              //component.find("delivery_date").focus();
              errMsg = $A.get(
                "{!$Label.c.Date_of_delivery_should_not_be_less_than_todays_date}"
              );
            }
          }
        });
        /* if(+z < +y){
                      error = true;
                      component.find("delivery_date").focus();
                      errMsg = $A.get("{!$Label.c.Date_of_delivery_should_not_be_less_than_todays_date}");
                  } */
      }
      if (error == false && ordWrap.showPODate == true) {
        if (ordWrap.isPORequired == true && (ordWrap.poDate == null || ordWrap.poDate == "")) { // SKI (Nik): #CR152 : PO And Delivery Date : 02-08-2022..added OR condition..
            error = true;
            component.find("po_date").focus();
            errMsg = $A.get("{!$Label.c.Purchase_Order_date_is_required}");
        }
        /* else if(ordWrap.poDate != null && +w < +y){
                      error = true;
                      component.find("po_date").focus();
                      errMsg = $A.get("{!$Label.c.PO_Date_should_not_be_less_than_todays_date}");
                  } */
      }
  
      if (error == true) {
        var toastEvent1 = $A.get("e.force:showToast");
        var titl = $A.get("{!$Label.c.Error}");
        toastEvent1.setParams({
          title: titl,
          type: "Error",
          message: errMsg,
          //"duration":'3000'
        });
        toastEvent1.fire();
      } else {
      /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 End */
        component.set("v.disableButton", true);
        ordWrap.orderItemList = ordItem;
  
        component.set("v.orderWrapper", ordWrap);
        helper.createSO(component, event, helper);
      }
    },
  
    onCancel: function (component, event, helper) {
      window.history.back();
    },
  
    openOrder: function (component, event, helper) {
      var val = event.currentTarget.getAttribute("data-target");
      var url = "/lightning/r/Sales_Order__c/" + val + "/view";
      window.open(url, "_blank");
    },
  
    validateDecimalVal: function (component, event, helper) {
      var target = event.getSource();
      var val = target.get("v.value");
      //var id = target.get("v.id");
      //val = val.replace(/^(0|[1-9]\d*)(\.\d+)?$/).replace(/([a-zA-Z ])/g,'').trim();
      if (val.length > 0) {
        //RITM0378368 changes done by Ey Team
        val = val
          .replace(/[^a-zA-Z0-9,. ]/, "")
          .replace(/([a-zA-Z ])/g, "")
          .replace(/(?=[^,]*$)/, "")
          .trim();
        //val=val.replace(/[^a-zA-Z0-9,. ]/,'').replace(/([a-zA-Z ])/g,'').replace(/,(?=[^,]*$)/,'').trim();
        //val=val.replace(/[0-9]+(?:-[0-9]+)?(,[0-9]+(?:-[0-9]+)?)*/,'').replace(/[^a-zA-Z0-9,. ]/,'').replace(/([a-zA-Z ])/g,'').trim();
      } else {
        val = 0;
      }
      target.set("v.value", val);
    },
  
    validateQuantity: function (component, event, helper) {
      var target = event.getSource();
      //RITM0378368 changes done by Ey Team
      var readVal = target.get("v.value");
      var str = readVal.toString().replace(",", ".");
      var val = parseFloat(str);
      component.set("v.priceBookWrap.quantity", val);
      if (parseFloat(val) < 0) {
        target.focus();
        target.set("v.value", 0);
        var toastEvent1 = $A.get("e.force:showToast");
        var msg = $A.get("{!$Label.c.Please_enter_Quantity}");
        var titl = $A.get("{!$Label.c.Error}");
        toastEvent1.setParams({
          title: titl,
          type: "Error",
          message: msg,
          //"duration":'3000'
        });
        toastEvent1.fire();
      } else {
        var action = component.get("c.calculatePriceAndDiscount"); // call one method from other method..
        $A.enqueueAction(action);
      }
    },
  
    validateMultipleOf: function (component, event, helper) {
      var target = event.getSource();
      //RITM0378368 changes done by Ey Team
      var readVal = target.get("v.value");
      var stp = target.get("v.step");
      var stp2 = target.get("v.step");
      var str = readVal.toString().replace(",", ".");
      var val = parseFloat(str);
      component.set("v.priceBookWrap.quantity", val);
      if (parseFloat(val) < 0) {
        target.focus();
        target.set("v.value", 0);
        var toastEvent1 = $A.get("e.force:showToast");
        var msg = $A.get("{!$Label.c.Please_enter_Quantity}");
        var titl = $A.get("{!$Label.c.Error}");
        toastEvent1.setParams({
          title: titl,
          type: "Error",
          message: msg,
          //"duration":'3000'
        });
        toastEvent1.fire();
      } else {
        console.log("Naresh Else check:-" + val);
        // val quantity % stp final price
  
        //1077 to 1085 Changes done By Dasoju Naresh Kumar
        //Change for Mod calculation Ticket Number:-RITM0366502
        var z = val / stp;
        var cFloat = z.toFixed(8);
        var str = cFloat.toString();
        var myarray = str.split(".");
        var minusS = myarray[0];
        var multipleDec = myarray[1];
        var reminder = cFloat - minusS;
        var result = reminder * stp;
        if (result == 0) {
          console.log("Data" + result);
        } else {
          if (stp2 == "" || stp2 == null) {
          } else {
            stp2 = stp2.toString().replace(".", ",");
  
            console.log("Step2:-" + stp2);
          }
          target.set("v.value", 0);
          console.log("Testing Naresh Mod Value Else:-" + parseInt(val % stp));
          var toastEvent1 = $A.get("e.force:showToast");
          var msg =
            $A.get("{!$Label.c.Qty_should_be_in_multiple_of}") + " " + stp2;
          var titl = $A.get("{!$Label.c.Error}");
          toastEvent1.setParams({
            title: titl,
            type: "Error",
            message: msg,
            //"duration":'3000'
          });
          toastEvent1.fire();
        }
  
        var action = component.get("c.calculatePriceAndDiscount"); // call one method from other method..
        $A.enqueueAction(action);
      }
    },
  
    checkQuantity: function (component, event, helper) {
      var target = event.getSource();
      var val = target.get("v.value");
      var index = target.get("v.name");
      var ordItem = component.get("v.orderItemWrapList");
  
      //parseInt(val,10) % 8 === 0
      if (parseFloat(val) < 0) {
        target.focus();
        target.set("v.value", 0);
        var toastEvent1 = $A.get("e.force:showToast");
        var msg = $A.get("{!$Label.c.Please_enter_Quantity}");
        var titl = $A.get("{!$Label.c.Error}");
        toastEvent1.setParams({
          title: titl,
          type: "Error",
          message: msg,
          //"duration":'3000'
        });
        toastEvent1.fire();
      } else {
        var obj = new Object(ordItem[index]);
  
        var net_prc = parseFloat(obj.quantity) * parseFloat(obj.net_price);
        obj.final_price = net_prc;
  
        ordItem[index] = obj;
        component.set("v.orderItemWrapList", ordItem);
  
        var action1 = component.get("c.calculateTotalAmt");
        $A.enqueueAction(action1);
  
        var action4 = component.get("c.draftOrder");
        $A.enqueueAction(action4);
      }
    },
  
    checkMultipleOf: function (component, event, helper) {
      var target = event.getSource();
      var val = target.get("v.value");
      var stp = target.get("v.step");
      var index = target.get("v.name");
      var ordItem = component.get("v.orderItemWrapList");
      var stp2 = target.get("v.step");
  
      //parseInt(val,10) % 8 === 0
      if (parseFloat(val) < 0) {
        target.focus();
        target.set("v.value", 0);
        var toastEvent1 = $A.get("e.force:showToast");
        var msg = $A.get("{!$Label.c.Please_enter_Quantity}");
        var titl = $A.get("{!$Label.c.Error}");
        toastEvent1.setParams({
          title: titl,
          type: "Error",
          message: msg,
          //"duration":'3000'
        });
        toastEvent1.fire();
      } else {
        if (parseFloat(val, 10) % stp === 0) {
          var obj = new Object(ordItem[index]);
  
          var net_prc = parseFloat(obj.quantity) * parseFloat(obj.net_price);
          obj.final_price = net_prc;
          ordItem[index] = obj;
          component.set("v.orderItemWrapList", ordItem);
  
          var action1 = component.get("c.calculateTotalAmt");
          $A.enqueueAction(action1);
  
          var action4 = component.get("c.draftOrder");
          $A.enqueueAction(action4);
        } else {
          if (stp2 == "" || stp2 == null) {
          } else {
            stp2 = stp2.toString().replace(".", ",");
          }
          target.set("v.value", 0);
          var toastEvent1 = $A.get("e.force:showToast");
          var msg =
            $A.get("{!$Label.c.Qty_should_be_in_multiple_of}") + " " + stp2;
          var titl = $A.get("{!$Label.c.Error}");
          toastEvent1.setParams({
            title: titl,
            type: "Error",
            message: msg,
            //"duration":'3000'
          });
          toastEvent1.fire();
        }
      }
    },
  
    validateFinalPrice: function (component, event, helper) {
      var target = event.getSource();
      //RITM0378368 changes done by Ey Team
      var readVal = target.get("v.value");
      var pbWrap = component.get("v.priceBookWrap");
      var flag = false;
      var msg = ""; //$A.get("{!$Label.c.Qty_should_be_in_multiple_of}")+' ' + stp2;
      var str = readVal.toString().replace(",", ".");
      var val = parseFloat(str);
      component.set("v.priceBookWrap.net_price", val);
      if (parseFloat(val) > 0) {
        if (parseFloat(val) < parseFloat(pbWrap.min_price)) {
          msg = $A.get("{!$Label.c.Price_entered_is_less_than_minimum_price}");
          flag = true;
        } else if (parseFloat(val) > parseFloat(pbWrap.max_price)) {
          msg = $A.get("{!$Label.c.Price_entered_is_greater_than_maximum_price}");
          flag = true;
        }
  
        if (flag == true) {
          var toastEvent1 = $A.get("e.force:showToast");
  
          var titl = $A.get("{!$Label.c.Warning}");
          toastEvent1.setParams({
            title: titl,
            type: "Warning",
            message: msg,
            //"duration":'3000'
          });
          toastEvent1.fire();
        }
      } else {
        //target.focus();
        target.set("v.value", 0);
        var toastEvent1 = $A.get("e.force:showToast");
        var msg = $A.get("{!$Label.c.Please_enter_Final_Price}");
        var titl = $A.get("{!$Label.c.Warning}");
        toastEvent1.setParams({
          title: titl,
          type: "Warning",
          message: msg,
          //"duration":'3000'
        });
        toastEvent1.fire();
      }
      var action1 = component.get("c.calculatePriceAndDiscount");
      $A.enqueueAction(action1);
    },
  
    checkFinalPrice: function (component, event, helper) {
      var target = event.getSource();
      var val = target.get("v.value");
      var flag = false;
      var msg = ""; //$A.get("{!$Label.c.Qty_should_be_in_multiple_of}")+' ' + stp2;
      var index = target.get("v.name");
      var ordItem = component.get("v.orderItemWrapList");
      var pbWrap = new Object(ordItem[index]);
  
      if (parseFloat(val) > 0) {
        if (parseFloat(val) < parseFloat(pbWrap.min_price)) {
          msg = $A.get("{!$Label.c.Price_entered_is_less_than_minimum_price}");
          flag = true;
        } else if (parseFloat(val) > parseFloat(pbWrap.max_price)) {
          msg = $A.get("{!$Label.c.Price_entered_is_greater_than_maximum_price}");
          flag = true;
        }
  
        if (flag == true) {
          var toastEvent1 = $A.get("e.force:showToast");
  
          var titl = $A.get("{!$Label.c.Warning}");
          toastEvent1.setParams({
            title: titl,
            type: "Warning",
            message: msg,
            //"duration":'3000'
          });
          toastEvent1.fire();
        }
  
        component.set("v.itemIndex", index);
        component.set("v.indexFlag", true);
  
        var net_prc = parseFloat(
          parseFloat(pbWrap.quantity) * parseFloat(pbWrap.net_price)
        ).toFixed(2);
  
        pbWrap.final_price = net_prc;
        component.set("v.isLoaded", false); // to rerender input field, to avoid validation error..
        ordItem[index] = pbWrap;
        component.set("v.orderItemWrapList", ordItem);
        component.set("v.isLoaded", true); // to rerender input field, to avoid validation error..
  
        var action1 = component.get("c.calculateTotalAmt");
        $A.enqueueAction(action1);
  
        var action4 = component.get("c.draftOrder");
        $A.enqueueAction(action4);
      } else {
        // target.focus();
        target.set("v.value", 0);
        var toastEvent1 = $A.get("e.force:showToast");
        var msg = $A.get("{!$Label.c.Please_enter_Final_Price}");
        var titl = $A.get("{!$Label.c.Warning}");
        toastEvent1.setParams({
          title: titl,
          type: "Warning",
          message: msg,
          //"duration":'3000'
        });
        toastEvent1.fire();
      }
    },
  });