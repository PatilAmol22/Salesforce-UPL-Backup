({
  MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB
  CHUNK_SIZE: 750000, //Chunk Max size 750Kb
  orderDetails: function (component, event, helper) {
    //console.log('RecordTp.... ',rcdTp_nm);
    component.set("v.showSpinner", true);
    var recordId = component.get("v.recordId");
    var action = component.get("c.getOrderDetails");

    action.setParams({
      id_val: recordId,
    });

    action.setCallback(this, function (response) {
      if (response.getState() == "SUCCESS") {
        var resp = response.getReturnValue();
        console.log("orderDetails Response.... ", resp);
        if (resp != null) {
          //component.set("v.orderWrapper",resp);
          //console.log('Payment date.... ', resp.payment_date);
          component.set("v.orderWrapper", resp);
          component.set("v.creditSummaryWrap", resp.creditSummary);
          component.set("v.shippingMap", resp.shippingMap);
          component.set("v.shipToPartyList", resp.shippingLocationList);
          component.set("v.orderForList", resp.orderForList);
          component.set("v.paymentTermList", resp.payTermList);
          component.set("v.orderForWrap", resp.orderForWrapper);
          /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 Start */
          component.set("v.isPODateReq", resp.isPORequired);
          component.set("v.isDeliveryDateReq", resp.isDeliveryRequired);
          component.set("v.showPODate", resp.showPODate);
          component.set("v.showDeliveryDate", resp.showDeliveryDate);
          /* SKI (Nik): #CR152 : PO And Delivery Date : 12-07-2022 End */
          var custs = [];
          for (var key in resp.orderTypMap) {
            custs.push({ value: resp.orderTypMap[key], key: key });
          }
          component.set("v.orderTpList", custs);

          if (resp.order_typ == "Exceptional") {
            component.set("v.isExceptional", true);
          }
          console.log("orderTpMap.... ", resp.orderTypMap);

          if (resp.fileName.length != 0) {
            component.set("v.fileName", resp.fileName);
            component.set("v.isFileReq", false);
          }

          var ordFrMp = new Map(component.get("v.orderForMap"));

          if (resp.orderForList.length > 0) {
            for (var i = 0; i < resp.orderForList.length; i++) {
              if (!ordFrMp.has(resp.orderForList[i].Sales_Org_Code__c)) {
                ordFrMp.set(
                  resp.orderForList[i].Sales_Org_Code__c,
                  resp.orderForList[i]
                );
              }
            }
            component.set("v.orderForMap", ordFrMp);
          }

          var divsn =
            "('" + resp.divisionIds.toString().split(",").join("','") + "')";
          var distChnl =
            "('" +
            resp.distributionChanlIds.toString().split(",").join("','") +
            "')";

          component.set("v.divisionIds", divsn);
          component.set("v.distributionChnlIds", distChnl);

          //filtr = "AND DepotCode__c =\'"+ resp.Depo_Obj+"\' AND DistributionChannel__c  IN "+ distChnl +" AND Division__c IN "+ divsn +" AND Sales_Org__c =\'"+ resp.salesOrgObj+"\' AND Price__c != null AND StartDate__c <= TODAY AND EndDate__c >= TODAY ORDER BY LastModifiedDate DESC ";
          var filtr =
            "AND DistributionChannel__c  IN " +
            distChnl +
            " AND Division__c IN " +
            divsn +
            " AND Sales_Org__c ='" +
            resp.salesOrgObj +
            "' AND DepotCode__r.SalesOrg__c = '" +
            resp.salesOrgObj +
            "' AND DepotCode__r.Name = 'MAIN' AND Price__c != null AND MinPrice__c != null AND StartDate__c <= TODAY AND EndDate__c >= TODAY ORDER BY LastModifiedDate DESC ";
          component.set("v.objectName", "PriceBookMaster__c");
          component.set("v.displayField", "SKUCode__r.SKU_Description__c");
          component.set("v.displayFieldSecond", "SKUCode__r.SKU_Code__c");
          component.set(
            "v.queryField",
            ", SKUCode__c, SKUCode__r.Name, SKUCode__r.SKU_Description__c, SKUCode__r.SKU_Code__c, SKUCode__r.Multiple_of__c, UOM__c, SKUCode__r.Pack_Size__c, Price__c, MinPrice__c, DepotCode__c, DistributionChannel__c, Division__c, Sales_Org__c "
          );

          component.set("v.PriceBookFilter", filtr);

          if (resp.isSalesOrder == true && resp.status != "Draft") {
            //component.set("v.orderWrapper",ordWrap);
            component.find("skuId").makeDisabled(false); // to disable sku search pill

            if (resp.orderForList.length == 1) {
              if (resp.orderFor.length == 0) {
                var result = resp;
                result.orderFor = resp.orderForList[0].Sales_Org_Code__c;

                result.ownerId = resp.orderForList[0].AccountOwner__c;

                component.set("v.orderWrapper", result);
              }
            } else if (resp.orderForList.length > 1) {
              if (resp.orderFor.length == 0) {
                var result = resp;
                result.orderFor = resp.orderForList[0].Sales_Org_Code__c;

                result.ownerId = resp.orderForList[0].AccountOwner__c;

                component.set("v.orderWrapper", result);
              }
            }
          } else {
            if (resp.orderForList.length == 1) {
              if (resp.orderFor.length == 0) {
                var result = resp;
                result.orderFor = resp.orderForList[0].Sales_Org_Code__c;

                result.ownerId = resp.orderForList[0].AccountOwner__c;

                component.set("v.orderWrapper", result);
              }
              //this.handleOrderForChng(component, event, helper);
            } else if (resp.orderForList.length > 1) {
              if (resp.orderFor.length == 0) {
                var result = resp;
                result.orderFor = resp.orderForList[0].Sales_Org_Code__c;

                result.ownerId = resp.orderForList[0].AccountOwner__c;

                component.set("v.orderWrapper", result);
              }
              //this.handleOrderForChng(component, event, helper);
            }
          }
          var ordFr = component.get("v.orderWrapper.orderFor");
          if (ordFr == "5361") {
            component.set("v.disableDraft", false);
          }

          /* var shpDt = resp.payment_date;
        shpDt = $A.localizationService.formatDate(shpDt, "yyyy-MM-dd"); //"yyyy-dd-MM" "d MMM, yyyy"
        component.find("pay_date").set("v.value", shpDt); */
          component.set("v.priceBookWrap", resp.priceBookWrapper);

          if (resp.orderItemList.length > 0) {
            component.set("v.disableDate", true);
            if (resp.isCustomerService == true) {
              component.set("v.orderTypDisable", true);
              component.set("v.isCustomerService", true);
            }

            component.set("v.orderItemWrapList", resp.orderItemList);

            var skuMap = new Map();
            for (var i = 0; i < resp.orderItemList.length; i++) {
              if (!skuMap.has(resp.orderItemList[i].sku_id)) {
                skuMap.set(
                  resp.orderItemList[i].sku_id,
                  resp.orderItemList[i].sku_id
                );
              }
            }
            component.set("v.skuMap", skuMap);
          } else {
            if (resp.isCustomerService == true) {
              component.set("v.orderTypDisable", false);
              component.set("v.isCustomerService", true);
            }
          }

          if (resp.status == "Draft" || resp.status == "Rejected") {
            component.set("v.disableActionButton", false);
            component.set("v.disableInput", false);
            component.find("skuId").makeDisabled(false); // to enable sku search pill
          } else {
            component.set("v.disableActionButton", true);
            component.set("v.disableInput", true);
            component.find("skuId").makeDisabled(true); // to disable sku search pill
            component.set("v.orderTypDisable", true);
            component.set("v.disableDate", true);
          }
        }
      }

      component.set("v.showSpinner", false);
    });
    $A.enqueueAction(action);
  },

  getInventory: function (component, event, helper) {
    //console.log('RecordTp.... ',rcdTp_nm);
    component.set("v.showSpinner", true);
    var pb = component.get("v.selectedPBRecord");
    var ordFr = component.find("order_for").get("v.value");
    var ordrWrap = component.get("v.orderWrapper");
    var skuId = "";

    skuId = pb.SKUCode__r.Id;

    if (pb != null) {
      var action = component.get("c.getSKUInventory");
      action.setParams({
        skuId: skuId,
        Sales_Org_Code: ordFr,
        depoId: ordrWrap.Depo_Obj,
      });

      action.setCallback(this, function (response) {
        if (response.getState() == "SUCCESS") {
          var resp = response.getReturnValue();
          console.log("Inventory Response.... ", resp);
          if (resp != null) {
            var pbWrap = component.get("v.priceBookWrap");

            pbWrap.inventory = resp.inventory;
            component.set("v.priceBookWrap", pbWrap);
          }
        }
        component.set("v.showSpinner", false);
      });
      $A.enqueueAction(action);
    }
  },

  uploadHelper: function (component, event) {
    // start/show the loading spinner
    component.set("v.showSpinner", true);
    // get the selected files using aura:id [return array of files]
    var fileInput = component.find("fileId").get("v.files");
    // get the first file using array index[0]
    var file = fileInput[0];
    var self = this;
    // check the selected file size, if select file size greter then MAX_FILE_SIZE,
    // then show a alert msg to user,hide the loading spinner and return from function
    if (file.size > self.MAX_FILE_SIZE) {
      component.set("v.showSpinner", false);
      component.set(
        "v.fileName",
        $A.get("{!$Label.c.Alert_File_size_cannot_exceed}") +
          self.MAX_FILE_SIZE +
          $A.get("{!$Label.c.bytes}") +
          ".\n" +
          $A.get("{!$Label.c.Selected_file_size}") +
          ": " +
          file.size
      );
      return;
    }

    // create a FileReader object
    var objFileReader = new FileReader();
    // set onload function of FileReader object
    objFileReader.onload = $A.getCallback(function () {
      var fileContents = objFileReader.result;
      var base64 = "base64,";
      var dataStart = fileContents.indexOf(base64) + base64.length;

      fileContents = fileContents.substring(dataStart);
      // call the uploadProcess method
      self.uploadProcess(component, file, fileContents);
    });

    objFileReader.readAsDataURL(file);
  },

  uploadProcess: function (component, file, fileContents) {
    // set a default size or startpostiton as 0
    var startPosition = 0;
    // calculate the end size or endPostion using Math.min() function which is return the min. value
    var endPosition = Math.min(
      fileContents.length,
      startPosition + this.CHUNK_SIZE
    );

    // start with the initial chunk, and set the attachId(last parameter)is null in begin
    var attchId = new Array();
    this.uploadInChunk(
      component,
      file,
      fileContents,
      startPosition,
      endPosition,
      attchId
    );
  },

  uploadInChunk: function (
    component,
    file,
    fileContents,
    startPosition,
    endPosition,
    attachId
  ) {
    // call the apex method 'saveChunk'
    var getchunk = fileContents.substring(startPosition, endPosition);
    var action = component.get("c.saveChunk");
    action.setParams({
      parentId: JSON.stringify(component.get("v.parentId")),
      fileName: file.name,
      base64Data: encodeURIComponent(getchunk),
      contentType: file.type,
      fileId: JSON.stringify(attachId),
    });

    // set call back
    action.setCallback(this, function (response) {
      // store the response / Attachment Id
      attachId = response.getReturnValue();
      var state = response.getState();
      if (state === "SUCCESS") {
        // update the start position with end postion
        startPosition = endPosition;
        endPosition = Math.min(
          fileContents.length,
          startPosition + this.CHUNK_SIZE
        );
        // check if the start postion is still less then end postion
        // then call again 'uploadInChunk' method ,
        // else, diaply alert msg and hide the loading spinner
        if (startPosition < endPosition) {
          this.uploadInChunk(
            component,
            file,
            fileContents,
            startPosition,
            endPosition,
            attachId
          );
        } else {
          // alert('your File is uploaded successfully');
          component.set("v.showSpinner", false);
        }
        // handel the response errors
      } else if (state === "INCOMPLETE") {
        alert("From server: " + response.getReturnValue());
      } else if (state === "ERROR") {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            console.log("Error message: " + errors[0].message);
          }
        } else {
          console.log("Unknown error");
        }
      }
    });
    // enqueue the action
    $A.enqueueAction(action);
  },

  saveAsDraft: function (component, event, helper) {
    console.log("saveAsDraft.... ");
    component.set("v.showSpinner", true);
    var ordWrap = component.get("v.orderWrapper");

    //updated by Vishal
    //ordWrap.creditSummary.credit_limit_balance = ordWrap.creditSummary.credit_limit_balance.replace(/\$|,/g, '');

    if (/(,|-)/.test(ordWrap.total_amount)) {
      ordWrap.total_amount = ordWrap.total_amount.replace(/\$|,/g, "");
    }

    for (var i = 0; i < ordWrap.orderItemList.length; i++) {
      if (/(,|-)/.test(ordWrap.orderItemList[i].max_price)) {
        ordWrap.orderItemList[i].max_price = ordWrap.orderItemList[
          i
        ].max_price.replace(/\$|,/g, "");
      }

      if (/(,|-)/.test(ordWrap.orderItemList[i].min_price)) {
        ordWrap.orderItemList[i].min_price = ordWrap.orderItemList[
          i
        ].min_price.replace(/\$|,/g, "");
      }

      if (/(,|-)/.test(ordWrap.orderItemList[i].net_price)) {
        ordWrap.orderItemList[i].net_price = ordWrap.orderItemList[
          i
        ].net_price.replace(/\$|,/g, "");
      }

      if (/(,|-)/.test(ordWrap.orderItemList[i].final_price)) {
        ordWrap.orderItemList[i].final_price = ordWrap.orderItemList[
          i
        ].final_price.replace(/\$|,/g, "");
      }
    }
    console.log("ordWrap " + ordWrap);
    //update end by vishal

    if (ordWrap != null) {
      var action = component.get("c.createDraftOrder");
      action.setParams({
        orderObj: JSON.stringify(ordWrap),
      });

      action.setCallback(this, function (response) {
        if (response.getState() == "SUCCESS") {
          var resp = response.getReturnValue();
          console.log("createDraftOrder Response.... ", resp);
          if (resp == true) {
            $A.get("e.force:refreshView").fire();
          } else {
            var toastEvent1 = $A.get("e.force:showToast");
            var titl = $A.get("{!$Label.c.Error}");
            var errMsg = $A.get(
              "{!$Label.c.Error_Occurred_While_Creating_Record}"
            );
            toastEvent1.setParams({
              title: titl,
              type: "Error",
              message: errMsg,
              //"duration":'3000'
            });
            toastEvent1.fire();
          }
        }
        component.set("v.disableButton", false);
        component.set("v.showSpinner", false);
      });
      $A.enqueueAction(action);
    }
  },

  createSO: function (component, event, helper) {
    console.log("createSO.... ");
    component.set("v.showSpinner", true);
    var ordWrap = component.get("v.orderWrapper");

    if (/(,|-)/.test(ordWrap.total_amount)) {
      ordWrap.total_amount = ordWrap.total_amount.replace(/\$|,/g, "");
    }

    for (var i = 0; i < ordWrap.orderItemList.length; i++) {
      if (/(,|-)/.test(ordWrap.orderItemList[i].max_price)) {
        ordWrap.orderItemList[i].max_price = ordWrap.orderItemList[
          i
        ].max_price.replace(/\$|,/g, "");
      }

      if (/(,|-)/.test(ordWrap.orderItemList[i].min_price)) {
        ordWrap.orderItemList[i].min_price = ordWrap.orderItemList[
          i
        ].min_price.replace(/\$|,/g, "");
      }

      if (/(,|-)/.test(ordWrap.orderItemList[i].net_price)) {
        ordWrap.orderItemList[i].net_price = ordWrap.orderItemList[
          i
        ].net_price.replace(/\$|,/g, "");
      }

      if (/(,|-)/.test(ordWrap.orderItemList[i].final_price)) {
        ordWrap.orderItemList[i].final_price = ordWrap.orderItemList[
          i
        ].final_price.replace(/\$|,/g, "");
      }
    }

    if (ordWrap != null) {
      var action = component.get("c.createNewSO");
      action.setParams({
        orderObj: JSON.stringify(ordWrap),
      });

      action.setCallback(this, function (response) {
        if (response.getState() == "SUCCESS") {
          var resp = response.getReturnValue();
          console.log("Response.... ", resp);
          if (resp != null) {
            var ordIds = new Array();
            var ordNo = "";
            for (var j = 0; j < resp.length; j++) {
              ordIds.push(resp[j].Id);
              if (j == 0) {
                ordNo = resp[j].Name;
              } else {
                ordNo = ordNo + "," + resp[j].Name;
              }
            }

            if (component.get("v.isFileReq") == true) {
              var fileLen = component.find("fileId").get("v.files");
              if (fileLen != null) {
                if (fileLen.length > 0) {
                  component.set("v.parentId", ordIds);
                  this.uploadHelper(component, event);
                }
              }
            }

            component.set("v.orderNumbers", ordNo);
            component.set("v.soList", ordIds);
            component.set("v.showSOSuccess", true);
          }
        }
        component.set("v.disableButton", false);
        component.set("v.showSpinner", false);
      });
      $A.enqueueAction(action);
    }
  },

  updateSO: function (component, event, helper) {
    console.log("updateSO.... ");
    component.set("v.showSpinner", true);
    var ordWrap = component.get("v.orderWrapper");
    //var sts = ordWrap.status;
    console.log("ordWrap.... in update SO ", ordWrap);

    if (/(,|-)/.test(ordWrap.total_amount)) {
      ordWrap.total_amount = ordWrap.total_amount.replace(/\$|,/g, "");
    }

    for (var i = 0; i < ordWrap.orderItemList.length; i++) {
      if (/(,|-)/.test(ordWrap.orderItemList[i].max_price)) {
        ordWrap.orderItemList[i].max_price = ordWrap.orderItemList[
          i
        ].max_price.replace(/\$|,/g, "");
      }

      if (/(,|-)/.test(ordWrap.orderItemList[i].min_price)) {
        ordWrap.orderItemList[i].min_price = ordWrap.orderItemList[
          i
        ].min_price.replace(/\$|,/g, "");
      }

      if (/(,|-)/.test(ordWrap.orderItemList[i].net_price)) {
        ordWrap.orderItemList[i].net_price = ordWrap.orderItemList[
          i
        ].net_price.replace(/\$|,/g, "");
      }

      if (/(,|-)/.test(ordWrap.orderItemList[i].final_price)) {
        ordWrap.orderItemList[i].final_price = ordWrap.orderItemList[
          i
        ].final_price.replace(/\$|,/g, "");
      }
    }

    if (ordWrap != null) {
      var action = component.get("c.updateSalesOrder");
      action.setParams({
        orderObj: JSON.stringify(ordWrap),
      });

      action.setCallback(this, function (response) {
        if (response.getState() == "SUCCESS") {
          var resp = response.getReturnValue();
          console.log("Response.... ", resp);
          if (resp != null) {
            var ordWrap = component.get("v.orderWrapper");
            ordWrap.lastItemNumber = ordWrap.lastItemNumber + 10;
            component.set("v.orderWrapper", ordWrap);
            if (component.get("v.isSODraft") == true) {
              var ordIds = new Array();
              var ordNo = "";
              for (var j = 0; j < resp.length; j++) {
                ordIds.push(resp[j].Id);
                if (j == 0) {
                  ordNo = resp[j].Name;
                } else {
                  ordNo = ordNo + "," + resp[j].Name;
                }
              }

              if (component.get("v.isFileReq") == true) {
                var fileLen = component.find("fileId").get("v.files");
                if (fileLen != null) {
                  if (fileLen.length > 0) {
                    component.set("v.parentId", ordIds);
                    this.uploadHelper(component, event);
                  }
                }
              }

              component.set("v.orderNumbers", ordNo);
              component.set("v.soList", ordIds);
              component.set("v.showSuccess", true);
            } else {
              $A.get("e.force:refreshView").fire();
            }
          }
        }
        component.set("v.disableButton", false);
        component.set("v.showSpinner", false);
      });
      $A.enqueueAction(action);
    }
  },
});