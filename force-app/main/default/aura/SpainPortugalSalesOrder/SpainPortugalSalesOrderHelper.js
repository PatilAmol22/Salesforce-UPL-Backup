({
  MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
  CHUNK_SIZE: 750000,      //Chunk Max size 750Kb
  orderDetails: function(component, event, helper) {
      //console.log('RecordTp.... ',rcdTp_nm);
    component.set("v.showSpinner", true);
    var recordId = component.get("v.recordId");
    console.log('**recordId - ' +recordId);  
    var action = component.get("c.getOrderDetails");

    action.setParams({
      id_val: recordId
    });

    action.setCallback(this, function(response) {
    if (response.getState() == "SUCCESS") {
        
      var resp = response.getReturnValue();
      console.log('orderDetails Response.... ', resp);
      if(resp != null){
        component.set("v.orderWrapper",resp);
        component.set("v.creditSummaryWrap",resp.creditSummary); 
        component.set("v.shippingMap",resp.shippingMap);
        component.set("v.shipToPartyList",resp.shippingLocationList);
       //Added for Payment Methods and Payment Terms
        component.set("v.PaymentMethodList",resp.PaymentMethodList);
        component.set("v.PaymentTermList",resp.PaymentTermList);
        component.set("v.IncoTermList",resp.IncoTermList);    // added by Vaishnavi w.r.t CR-RITM0378141


        //component.find("paymnt_method").set("v.value",resp.payment_method);
        component.set("v.orderForList",resp.orderForList); 

        /*---------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022 ------------*/
        component.set("v.isPODateReq", resp.isPORequired);
        component.set("v.isDeliveryDateReq", resp.isDeliveryRequired);
        component.set("v.showPODate", resp.showPODate);
        component.set("v.showDeliveryDate", resp.showDeliveryDate); 
        /*---------- End - SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022  ------------*/

        var ordFrMp = new Map(component.get("v.orderForMap"));

        if(resp.orderForList.length>0){
          for(var i = 0; i< resp.orderForList.length; i++){
            if(!ordFrMp.has(resp.orderForList[i].Sales_Org_Code__c)){
              ordFrMp.set(resp.orderForList[i].Sales_Org_Code__c,resp.orderForList[i]);
            } 
          }
          component.set("v.orderForMap",ordFrMp);
        }
         console.log('**isSalesOrder - ' +resp.isSalesOrder);
         
        if(resp.isSalesOrder == true){
          component.set("v.orderForDisable",true);
            component.set("v.isNewOrder",'Re');
            component.set("v.isSalesOrder",true);//Added by VT 21-Feb-22
            
          var isNewOrder = component.get("v.isNewOrder");
          console.log('**isNewOrder - ', isNewOrder);
        }
          else{
              component.set("v.isNewOrder",'New');
              var isNewOrder = component.get("v.isNewOrder");
              console.log('**isNewOrder - ', isNewOrder);
          }
        
        if(resp.isSalesOrder == true && resp.status != 'Draft'){
            var divsn = "('" + resp.divisionIds.toString().split( "," ).join( "','" ) + "')";
            var distChnl = "('" + resp.distributionChanlIds.toString().split( "," ).join( "','" ) + "')";
            
            var filtr = "AND DepotCode__c =\'"+ resp.Depo_Obj+"\' AND DistributionChannel__c  IN "+ distChnl +" AND Division__c IN "+ divsn +" AND Sales_Org__c =\'"+ resp.salesOrgObj+"\' AND Price__c != null AND StartDate__c <= TODAY AND EndDate__c >= TODAY  ";
            
            component.set("v.PriceBookFilter",filtr);
            component.set("v.displayField","SKUCode__r.SKU_Description__c");
            component.set("v.displayFieldSecond","SKUCode__r.SKU_Code__c");
            //component.set("v.orderWrapper",ordWrap);
            component.find("skuId").makeDisabled(false); // to disable sku search pill 

            if(resp.orderForList.length == 1){
              if(resp.orderFor.length == 0){
                var result = resp;
                result.orderFor = resp.orderForList[0].Sales_Org_Code__c;
                
                result.ownerId = resp.orderForList[0].AccountOwner__c;
                
                component.set("v.orderWrapper",result);
              }
             // component.set("v.orderForDisable",true);
            }
            else if(resp.orderForList.length > 1){
              if(resp.orderFor.length == 0){
                var result = resp;
                result.orderFor = resp.orderForList[0].Sales_Org_Code__c;
                
                result.ownerId = resp.orderForList[0].AccountOwner__c;
                
                component.set("v.orderWrapper",result);
              }
            }
           
        }
        else{

          if(resp.orderForList.length == 1){
            if(resp.orderFor.length == 0){
              var result = resp;
              result.orderFor = resp.orderForList[0].Sales_Org_Code__c;
              
              result.ownerId = resp.orderForList[0].AccountOwner__c;
              
              component.set("v.orderWrapper",result);
            }
            component.set("v.orderForDisable",true);
            this.handleOrderForChng(component, event, helper);
          }
          else if(resp.orderForList.length > 1){
            if(resp.orderFor.length == 0){
              var result = resp;
              result.orderFor = resp.orderForList[0].Sales_Org_Code__c;
              
              result.ownerId = resp.orderForList[0].AccountOwner__c;
              
              component.set("v.orderWrapper",result);
            }
            this.handleOrderForChng(component, event, helper);
          }

          /* if(resp.orderForList.length == 1){
            var result = resp;
            result.orderFor = resp.orderForList[0].Sales_Org_Code__c;
            component.set("v.orderWrapper",result);
            component.set("v.orderForDisable",true);
            
            this.handleOrderForChng(component, event, helper);
          }
          if(resp.orderFor.length>0){
            this.handleOrderForChng(component, event, helper); 
          } */
        }

        // Below 3 Lines, Hiding Shipping date RITM0475049 GRZ(Nikhil Verma) 16-12-2022
        /*var shpDt = resp.priceBookWrapper.shipmnt_date;
        shpDt = $A.localizationService.formatDate(shpDt, "yyyy-MM-dd"); //"yyyy-dd-MM" "d MMM, yyyy"
        component.find("shipment_dt").set("v.value", shpDt);*/


        component.set("v.priceBookWrap",resp.priceBookWrapper);  
		
        if(resp.orderItemList.length>0){
          component.set("v.orderItemWrapList",resp.orderItemList); 
          component.set("v.orderForDisable",true);
          var skuMap = new Map();
          var DuplicateSKUMap = new Map();
          for(var i = 0; i< resp.orderItemList.length; i++){
            
            if(!skuMap.has(resp.orderItemList[i].sku_id)){
              skuMap.set(resp.orderItemList[i].sku_id,resp.orderItemList[i].sku_id);
            }
              if(!DuplicateSKUMap.has(resp.orderItemList[i].sku_id+"-"+resp.orderItemList[i].line_discount+"-"+resp.orderItemList[i].base_price)){
                  DuplicateSKUMap.set(resp.orderItemList[i].sku_id+"-"+resp.orderItemList[i].line_discount+"-"+resp.orderItemList[i].base_price,resp.orderItemList[i].sku_id+"-"+resp.orderItemList[i].line_discount+"-"+resp.orderItemList[i].base_price);
              }
          }
          component.set("v.skuMap",skuMap);
          component.set("v.DuplicateSKUMap",DuplicateSKUMap);
        }   

        if(resp.status == 'Draft' || resp.status == 'Rejected'){
          component.set("v.disableActionButton",false); 
          component.set("v.disableInput",false);
          if(resp.disable_EOD == true){
            component.set("v.disableEOD",true);
          }
          else{
            component.set("v.disableEOD",false);
          }
          
        }
        else{
          component.set("v.disableActionButton",true);
          component.set("v.disableInput",true);
          component.set("v.disableEOD",true);
          component.find("skuId").makeDisabled(true); // to disable sku search pill 
          
        }
        
      }
      
    }
    
    component.set("v.showSpinner", false);
    });
    $A.enqueueAction(action);
  },

  handleOrderForChng: function(component, event, helper) {
    //console.log('RecordTp.... ',rcdTp_nm);
    component.set("v.showSpinner", true);
    var ordFr = component.find("order_for").get("v.value");
    var ordrWrap = component.get("v.orderWrapper");
    if(ordFr!=''|| ordFr!=null){
      
        var ordFrMp = new Map(component.get("v.orderForMap"));
        var obj = new Object();
        obj=  ordFrMp.get(ordFr);
        ordrWrap.ownerId = obj.AccountOwner__c;
        console.log('ownerId.... ',obj.AccountOwner__c);
        component.set("v.orderWrapper",ordrWrap);
      
      var action = component.get("c.setOrderFor");
      action.setParams({
        org_code: ordFr
      });

      action.setCallback(this, function(response) {
      if (response.getState() == "SUCCESS") {
          
        var resp = response.getReturnValue();
        console.log('Response.... ',resp.error);
        if(resp != null){
           if(resp.error == true){
            component.find("order_for").focus();
            var toastEvent1 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.Selected_Record_Not_Found_Please_Try_Other_Options}");
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
            component.set("v.orderForWrap", resp);

            if(ordrWrap.status == 'Draft'){
              var divsn = "('" + resp.divisionIds.toString().split( "," ).join( "','" ) + "')";
              var distChnl = "('" + resp.distributionChanlIds.toString().split( "," ).join( "','" ) + "')";
              
              var filtr = "AND DepotCode__c =\'"+ resp.Depo_Obj.Id+"\' AND DistributionChannel__c  IN "+ distChnl +" AND Division__c IN "+ divsn +" AND Sales_Org__c =\'"+ resp.salesOrgObj.Id+"\' AND Price__c != null AND StartDate__c <= TODAY AND EndDate__c >= TODAY  ";
              
              component.set("v.PriceBookFilter",filtr);
            }
            
            component.set("v.displayField","SKUCode__r.SKU_Description__c");
            component.set("v.displayFieldSecond","SKUCode__r.SKU_Code__c");
            var ordWrap = component.get("v.orderWrapper");
            ordWrap.salesOrgObj = resp.salesOrgObj.Id;
            ordWrap.Order_Type = resp.Order_Type.Id;
            ordWrap.Depo_Obj = resp.Depo_Obj.Id;
            ordWrap.Shipping_Point = resp.Shipping_Point.Id;
            ordWrap.Storage_Location = resp.Storage_Location.Id;
            var combKey = resp.Storage_Location.Name+''+resp.Depo_Obj.Name;
            component.set("v.combinationKey",combKey);
            component.set("v.orderWrapper",ordWrap);
            component.find("skuId").makeDisabled(false); // to disable sku search pill 
           }       
        // this.fetchAccounts(component, event, helper);
        }
        
      }

      component.set("v.showSpinner", false);
      });
      $A.enqueueAction(action);
    }
  }, 

  getCampaignDiscount: function(component, event, helper) {
    //console.log('RecordTp.... ',rcdTp_nm);
    component.set("v.showSpinner", true);
    var pb = component.get("v.selectedPBRecord");
      //alert('@@@@');
   
    if(pb!=null){
      var action = component.get("c.getCampaignAndDiscount");
      action.setParams({
        skuId : pb.SKUCode__r.Id,
        salesOrgObj : pb.Sales_Org__c,
        Depo_Obj : pb.DepotCode__c,
        distributionChanlIds : pb.DistributionChannel__c,
        divisionIds : pb.Division__c,
        combKey : component.get("v.combinationKey")
      });

      action.setCallback(this, function(response) {
      if (response.getState() == "SUCCESS") {
          
        var resp = response.getReturnValue();
          console.log('BBresp',resp);
        if(resp != null){
          var pbWrap = component.get("v.priceBookWrap");
            pbWrap.line_discount = resp.line_discount;
            pbWrap.volume_discount = 0;
            pbWrap.actual_line_discount = resp.line_discount;
            pbWrap.actual_base_price = resp.base_price;//Sayan
            pbWrap.actual_volume_discount = resp.volume_discount;
            pbWrap.inventory = resp.inventory;       
            component.set("v.priceBookWrap",pbWrap);
        	//alert('####ALD'+pbWrap.actual_line_discount);
            //alert('####AVD'+pbWrap.actual_volume_discount);
            //component.set("v.totalDiscount",pbWrap.actual_line_discount+pbWrap.actual_volume_discount); 
        	//alert('####'+component.get("v.totalDiscount"));
            
          var pbDiscount = resp.pbDiscount;
          if(pbDiscount != null){
            if(pbDiscount.length >=1){
              var toastEvent1 = $A.get("e.force:showToast");
              var msg  = $A.get("{!$Label.c.Campaign_Discount_Is_Present_For_Selected_SKU}");
              var titl  = $A.get("{!$Label.c.Campaign_Discount}");
              toastEvent1.setParams({
                  "title": titl,
                  "type": "Success",
                  "message": msg
                  //"duration":'3000'
              });
              toastEvent1.fire();
            }
            var campgnMap = new Map();
            var oldMp = new Map(component.get("v.campaignMap"));
            
            for(var i = 0; i< pbDiscount.length; i++){
              
              if(!campgnMap.has(pbDiscount[i].Spain_Portugal_Campaign__c)){
                campgnMap.set(pbDiscount[i].Spain_Portugal_Campaign__c,pbDiscount[i]);
              } 
            }
            //console.log('campgnMap.... ',campgnMap);
            campgnMap.forEach((value,key)=>
              oldMp.set(key,value)
            );

            component.set("v.campaignMap",oldMp);
            component.set("v.campaignDiscountList",pbDiscount); 
            
          }
          else{
            var toastEvent1 = $A.get("e.force:showToast");
              var msg  = $A.get("{!$Label.c.Campaigns_For_Selected_SKU_Not_Found}");
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
        
      }
      component.set("v.showSpinner", false);
      });
      $A.enqueueAction(action);
    }
  },

  uploadHelper: function(component, event) {
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
        component.set("v.fileName", $A.get("{!$Label.c.Alert_File_size_cannot_exceed}") + self.MAX_FILE_SIZE + $A.get("{!$Label.c.bytes}") + '.\n' + $A.get("{!$Label.c.Selected_file_size}") +': ' + file.size);
        return;
    }

    // create a FileReader object 
    var objFileReader = new FileReader();
    // set onload function of FileReader object   
    objFileReader.onload = $A.getCallback(function() {
        var fileContents = objFileReader.result;
        var base64 = 'base64,';
        var dataStart = fileContents.indexOf(base64) + base64.length;

        fileContents = fileContents.substring(dataStart);
        // call the uploadProcess method 
        self.uploadProcess(component, file, fileContents);
    });

    objFileReader.readAsDataURL(file);
  },

  uploadProcess: function(component, file, fileContents) {
      // set a default size or startpostiton as 0 
      var startPosition = 0;
      // calculate the end size or endPostion using Math.min() function which is return the min. value   
      var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);

      // start with the initial chunk, and set the attachId(last parameter)is null in begin
      var attchId = new Array();
      this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attchId);
  },


  uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
    // call the apex method 'saveChunk'
    var getchunk = fileContents.substring(startPosition, endPosition);
    var action = component.get("c.saveChunk");
    action.setParams({
        parentId: JSON.stringify(component.get("v.parentId")),
        fileName: file.name,
        base64Data: encodeURIComponent(getchunk),
        contentType: file.type,
        fileId: JSON.stringify(attachId)
    });

    // set call back 
    action.setCallback(this, function(response) {
        // store the response / Attachment Id   
        attachId = response.getReturnValue();
        var state = response.getState();
        if (state === "SUCCESS") {
            // update the start position with end postion
            startPosition = endPosition;
            endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
            // check if the start postion is still less then end postion 
            // then call again 'uploadInChunk' method , 
            // else, diaply alert msg and hide the loading spinner
            if (startPosition < endPosition) {
                this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
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

  saveAsDraft:function(component, event, helper) {
    console.log('saveAsDraft.... ');
    component.set("v.showSpinner", true);
    var ordWrap = component.get("v.orderWrapper");
   
    if(ordWrap!=null){
      var action = component.get("c.createDraftOrder");
      action.setParams({
        orderObj: JSON.stringify(ordWrap)
      });
      
      action.setCallback(this, function(response) {
      if (response.getState() == "SUCCESS") {
          
        var resp = response.getReturnValue();
        console.log('createDraftOrder Response.... ',resp);
        if(resp == true){
          /* var ordWrap = component.get("v.orderWrapper");
          ordWrap.lastItemNumber = ordWrap.lastItemNumber + 10;
          component.set("v.orderWrapper",ordWrap);

          component.set("v.orderItemWrapList",resp); */
          $A.get('e.force:refreshView').fire();
          
        }
        else{
          var toastEvent1 = $A.get("e.force:showToast");
          var titl  = $A.get("{!$Label.c.Error}");
          var errMsg = $A.get("{!$Label.c.Error_Occurred_While_Creating_Record}");
          toastEvent1.setParams({
              "title": titl,
              "type": "Error",
              "message": errMsg
              //"duration":'3000'
          });
          toastEvent1.fire();
        }
        
      }
      component.set("v.disableButton",false);
      component.set("v.showSpinner", false);
      });
      $A.enqueueAction(action);
    }
  },

  createSO:function(component, event, helper) {
    console.log('createSO.... ');
    var TemplateName = component.get("v.TemplateName");
   console.log('**createSO TemplateName - '+TemplateName);
    component.set("v.showSpinner", true);
    var ordWrap = component.get("v.orderWrapper");
    console.log('ordWrap.... ', ordWrap);

    if(ordWrap!=null){
      var action = component.get("c.createNewSO");
      action.setParams({
        orderObj: JSON.stringify(ordWrap),
          TemplateName: TemplateName
      });

      action.setCallback(this, function(response) {
      if (response.getState() == "SUCCESS") {
          
        var resp = response.getReturnValue();
        console.log('Response.... ',resp);
        if(resp != null){

          var ordIds = new Array();
          var ordNo = '';
          for(var j=0; j<resp.length; j++){
            ordIds.push(resp[j].Id);
            if(j == 0){
              ordNo = resp[j].Name;
            }
            else{
              ordNo = ordNo + ','+ resp[j].Name;
            }
          }

          var fileLen = component.find("fileId").get("v.files");
          if(fileLen != null){
            if(fileLen.length > 0) {
                component.set("v.parentId",ordIds); 
                this.uploadHelper(component, event);
            }
          }
          
          component.set("v.orderNumbers", ordNo);
          component.set("v.soList", ordIds);
          component.set("v.showSOSuccess", true);

        }
        
      }
      component.set("v.disableButton",false);
      component.set("v.showSpinner", false);
      });
      $A.enqueueAction(action);
    }
  },

  updateSO:function(component, event, helper) {
    console.log('updateSO.... ');
    component.set("v.showSpinner", true);
    var ordWrap = component.get("v.orderWrapper");
    //var sts = ordWrap.status;
    console.log('ordWrap.... ', ordWrap);

    if(ordWrap!=null){
      var action = component.get("c.updateSalesOrder");
      action.setParams({
        orderObj: JSON.stringify(ordWrap)
      });

      action.setCallback(this, function(response) {
      if (response.getState() == "SUCCESS") {
          
        var resp = response.getReturnValue();
        console.log('Response.... ',resp);
        if(resp != null){
          var ordWrap = component.get("v.orderWrapper");
          ordWrap.lastItemNumber = ordWrap.lastItemNumber + 10;
          component.set("v.orderWrapper",ordWrap);
          if(component.get("v.isSODraft") == true){
          
            var ordIds = new Array();
            var ordNo = '';
            for(var j=0; j<resp.length; j++){
              ordIds.push(resp[j].Id);
              if(j == 0){
                ordNo = resp[j].Name;
              }
              else{
                ordNo = ordNo + ','+ resp[j].Name;
              }
            }

            var fileLen = component.find("fileId").get("v.files");
            if(fileLen != null){
              if(fileLen.length > 0) {
                  component.set("v.parentId",ordIds); 
                  this.uploadHelper(component, event);
              }
            }
            
            component.set("v.orderNumbers", ordNo);
            component.set("v.soList", ordIds);
            component.set("v.showSuccess", true);
            /* if(sts == 'Draft'){
              component.set("v.showSuccess", true);
            }
            else{
              component.set("v.showSOSuccess", true);
            } */
          }
          else{
            $A.get('e.force:refreshView').fire();
          }
        }
      }
      component.set("v.disableButton",false);
      component.set("v.showSpinner", false);
      });
      $A.enqueueAction(action);
    }
  },

 toggle : function(component, event, helper, lookupmodal, backdrop){
        var lookupmodal = component.find(lookupmodal);
        $A.util.toggleClass(lookupmodal, "slds-hide");
        
        var backdrop = component.find(backdrop);
        $A.util.toggleClass(backdrop, "slds-hide");
    },

})