({
  MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
  CHUNK_SIZE: 750000,      //Chunk Max size 750Kb
  orderDetails: function(component, event, helper) {
      //console.log('RecordTp.... ',rcdTp_nm);
    component.set("v.showSpinner", true);
    var recordId = component.get("v.recordId");
    var action = component.get("c.getOrderDetails");

    action.setParams({
      id_val: recordId
    });

    action.setCallback(this, function(response) {
    if (response.getState() == "SUCCESS") {
        
      var resp = response.getReturnValue();
      console.log('orderDetails Response.... ', resp);
      if(resp != null){
        //component.set("v.orderWrapper",resp);
          
          console.log('resp.creditSummary ',resp.creditSummary);
          
          var obj = new Object();
          obj=  resp.creditSummary;
          console.log('obj sdasd ',obj.total_credit_limit);
          var format = new Intl.NumberFormat('en-US', {
              minimumFractionDigits: 2,
          });
          
          //console.log('result is '+format.format(147121221.1512));
          obj.total_credit_limit  = format.format(obj.total_credit_limit);
          obj.internal_credit_limit  = format.format(obj.internal_credit_limit);
          obj.credit_limit_used  = format.format(obj.credit_limit_used);
          obj.credit_limit_balance  = format.format(obj.credit_limit_balance);
          obj.total_outstanding  = format.format(obj.total_outstanding);
          obj.net_overdue  = format.format(obj.net_overdue);
          
          if(resp.total_amount > 0){
            resp.total_amount = format.format(resp.total_amount);
          }
          
          if(resp.net_price_kg > 0){
            resp.net_price_kg = format.format(resp.net_price_kg);
            component.set("v.showKgDiv",true);
          }

          if(resp.net_price_litre > 0){
            resp.net_price_litre = format.format(resp.net_price_litre);
            component.set("v.showLtrDiv",true);
          }         
          
        component.set("v.orderWrapper",resp); 
          
        component.set("v.creditSummaryWrap",resp.creditSummary);
        /* -----------Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022 --------------------- */ 
        component.set("v.isPODateReq", resp.isPORequired);
        component.set("v.isDeliveryDateReq", resp.isDeliveryRequired);
        component.set("v.showPODate", resp.showPODate);
        component.set("v.showDeliveryDate", resp.showDeliveryDate);  
        /* -----------------End Start SKI(Nik) : #CR152 : PO And Delivery Date : 01-08-2022-------------- */  
          
        component.set("v.shippingMap",resp.shippingMap);
        component.set("v.shipToPartyList",resp.shippingLocationList); 
        component.set("v.orderForList",resp.orderForList); 
        //component.set("v.tmDepoList",resp.tmDepoList); 
        component.set("v.orderHistoryList",resp.orderHistory); 
        component.set("v.paymentTermList", resp.payTermList);

       
        if(resp.fileName.length != 0){
          component.set("v.fileName", resp.fileName);
          component.set("v.isFileReq", false);
        }

        var ordFrMp = new Map(component.get("v.orderForMap"));

        if(resp.orderForList.length>0){
          for(var i = 0; i< resp.orderForList.length; i++){
            if(!ordFrMp.has(resp.orderForList[i].Sales_Org_Code__c)){
              ordFrMp.set(resp.orderForList[i].Sales_Org_Code__c,resp.orderForList[i]);
            } 
          }
          component.set("v.orderForMap",ordFrMp);
        }

        if(resp.isSalesOrder == true){
          component.set("v.orderForDisable",true);
        }
        
        if(resp.isSalesOrder == true && resp.status != 'Draft'){
            var divsn = "('" + resp.divisionIds.toString().split( "," ).join( "','" ) + "')";
            var distChnl = "('" + resp.distributionChanlIds.toString().split( "," ).join( "','" ) + "')";
            
            var filtr = "";
                          
            component.set("v.divisionIds",divsn);
            component.set("v.distributionChnlIds",distChnl);

            if(resp.businessTypeName == 'B2C'){
              //filtr = "AND DepotCode__c =\'"+ resp.Depo_Obj+"\' AND DistributionChannel__c  IN "+ distChnl +" AND Division__c IN "+ divsn +" AND Sales_Org__c =\'"+ resp.salesOrgObj+"\' AND Price__c != null AND StartDate__c <= TODAY AND EndDate__c >= TODAY ORDER BY LastModifiedDate DESC ";
              filtr = "AND DistributionChannel__c  IN "+ distChnl +" AND Division__c IN "+ divsn +" AND Sales_Org__c =\'"+ resp.salesOrgObj+"\' AND Price__c != null AND StartDate__c <= TODAY AND EndDate__c >= TODAY ORDER BY LastModifiedDate DESC ";
              component.set("v.objectName","PriceBookMaster__c");
              component.set("v.displayField","SKUCode__r.SKU_Description__c");
              component.set("v.displayFieldSecond","SKUCode__r.SKU_Code__c");
              component.set("v.queryField",", SKUCode__c, SKUCode__r.Name, SKUCode__r.SKU_Description__c, SKUCode__r.SKU_Code__c, SKUCode__r.Mininum_Quantity__c, UOM__c, SKUCode__r.Pack_Size__c, Price__c, DepotCode__c, DistributionChannel__c, Division__c, Sales_Org__c ");
            }
            else if(resp.businessTypeName == 'B2B'){
              filtr = "AND Distribution_Channel__c  IN "+ distChnl +" AND Division__c IN "+ divsn +" AND Sales_Org__c =\'"+ resp.salesOrgObj+"\' AND Pack_Size__c != null AND Active__c = true ORDER BY LastModifiedDate DESC ";
              component.set("v.objectName","SKU__c");
              component.set("v.displayField","SKU_Description__c");
              component.set("v.displayFieldSecond","SKU_Code__c");
              component.set("v.queryField",", Pack_Size__c, SKU_Code__c, SKU_Description__c, Sales_Org__c, UOM__c, Active__c, Distribution_Channel__c, Distribution_Channel_Code__c, Division__c, Division_Code__c, Multiple_of__c ");
            }
            else{
              this.bussinessTypeError(component, event, helper);
            }

            component.set("v.PriceBookFilter",filtr);
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
           this.fetchDepoList(component, event, helper);
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
        var shpDt = resp.priceBookWrapper.shipmnt_date;
        shpDt = $A.localizationService.formatDate(shpDt, "yyyy-MM-dd"); //"yyyy-dd-MM" "d MMM, yyyy"
       // console.log('shpDt.... ',shpDt);
        component.find("shipment_dt").set("v.value", shpDt);
        component.set("v.priceBookWrap",resp.priceBookWrapper);  

        if(resp.orderItemList.length>0){
            
          for(var i=0;i<resp.orderItemList.length;i++){

            if(resp.orderItemList[i].net_rate>0){
              resp.orderItemList[i].net_rate = format.format(resp.orderItemList[i].net_rate);
            }

            if(resp.orderItemList[i].net_value>0){
              resp.orderItemList[i].net_value = format.format(resp.orderItemList[i].net_value);
            }
          }
            
          component.set("v.orderItemWrapList",resp.orderItemList); 
          component.set("v.orderForDisable",true);
          component.set("v.disableTmDepo",true);

          var skuMap = new Map();
          for(var i = 0; i< resp.orderItemList.length; i++){
            
            if(!skuMap.has(resp.orderItemList[i].sku_id)){
              skuMap.set(resp.orderItemList[i].sku_id,resp.orderItemList[i].sku_id);
            } 
          }
          component.set("v.skuMap",skuMap);

        }   

        if(resp.status == 'Draft' || resp.status == 'Rejected'){
          component.set("v.disableActionButton",false); 
          component.set("v.disableInput",false);
          if(resp.businessTypeName == 'B2C'){
            component.set("v.disableBP",true);
          }
          else{
            component.set("v.disableBP",false);
          }
          
        }
        else{
          component.set("v.disableActionButton",true);
          component.set("v.disableInput",false);
          component.set("v.disableBP",true);
         // component.set("v.disableEOD",true);
          component.find("skuId").makeDisabled(true); // to disable sku search pill 
          
        }
                  
      }
      
    }

    /*var price = 147121221.1512;

    var dollarIndianLocale = Intl.NumberFormat('en-IN');

    console.log("US Locale output: " + dollarIndianLocale.format(price));
    console.log("Indian Locale output: " + parseFloat(dollarIndianLocale.format(price))); */
        
        
        var format = new Intl.NumberFormat('en-IN', {
                 minimumFractionDigits: 2,
            });
            // for 4800 INR
            //console.log('result is '+format.format(147121221.1512));
        
        
        
        
        
        
        
    
    component.set("v.showSpinner", false);
    });
    $A.enqueueAction(action);
  },

  fetchDepoList: function(component, event, helper) {
    //console.log('RecordTp.... ',rcdTp_nm);
    component.set("v.showSpinner", true);
    var ordFr = component.find("order_for").get("v.value");
    if(ordFr!=''|| ordFr!=null){
      var action = component.get("c.getTMDepoList");
      action.setParams({
        org_code: ordFr
      });

      action.setCallback(this, function(response) {
        if (response.getState() == "SUCCESS") {
            
          var resp = response.getReturnValue();
          //console.log('Response.... ',resp);
          if(resp != null){ 
            component.set("v.tmDepoList",resp.tmDepoList);
          }
        
        }
        
        component.set("v.showSpinner", false);
      });
      $A.enqueueAction(action); 
    }
  },

  handleOrderForChng: function(component, event, helper) {
    //console.log('RecordTp.... ',rcdTp_nm);
    component.set("v.showSpinner", true);
    var ordFr = component.find("order_for").get("v.value");
    var ordrWrap = component.get("v.orderWrapper");
    if(ordFr!=''|| ordFr!=null){
      
        var ordFrMp = new Map(component.get("v.orderForMap"));
        var obj = new Object();
        obj = ordFrMp.get(ordFr);
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
        //console.log('Response.... ',resp);
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
            component.set("v.paymentTermList", resp.paymentTermList);
            component.set("v.tmDepoList",resp.tmDepoList); 

            if(ordrWrap.status == 'Draft'){
              var divsn = "('" + resp.divisionIds.toString().split( "," ).join( "','" ) + "')";
              var distChnl = "('" + resp.distributionChanlIds.toString().split( "," ).join( "','" ) + "')";
              
              //var filtr = "AND DepotCode__c =\'"+ ordrWrap.Depo_Obj+"\' AND DistributionChannel__c  IN "+ distChnl +" AND Division__c IN "+ divsn +" AND Sales_Org__c =\'"+ resp.salesOrgObj.Id+"\' AND Price__c != null AND StartDate__c <= TODAY AND EndDate__c >= TODAY ORDER BY LastModifiedDate ASC ";
              var filtr = "";

              //component.set("v.PriceBookFilter",filtr);
              component.set("v.divisionIds",divsn);
              component.set("v.distributionChnlIds",distChnl);

              if(ordrWrap.businessTypeName == 'B2C'){
                //filtr = "AND DepotCode__c =\'"+ ordrWrap.Depo_Obj+"\' AND DistributionChannel__c  IN "+ distChnl +" AND Division__c IN "+ divsn +" AND Sales_Org__c =\'"+ resp.salesOrgObj.Id+"\' AND Price__c != null AND StartDate__c <= TODAY AND EndDate__c >= TODAY ORDER BY LastModifiedDate DESC ";
                filtr = "AND DistributionChannel__c  IN "+ distChnl +" AND Division__c IN "+ divsn +" AND Sales_Org__c =\'"+ resp.salesOrgObj.Id+"\' AND Price__c != null AND StartDate__c <= TODAY AND EndDate__c >= TODAY ORDER BY LastModifiedDate DESC ";
                component.set("v.objectName","PriceBookMaster__c");
                //component.set("v.displayField","SKUCode__r.SKU_Description__c");
                //component.set("v.displayFieldSecond","SKUCode__r.SKU_Code__c");
                component.set("v.queryField",", SKUCode__c, SKUCode__r.Name, SKUCode__r.SKU_Description__c, SKUCode__r.SKU_Code__c, SKUCode__r.Mininum_Quantity__c, UOM__c, SKUCode__r.Pack_Size__c, Price__c, DepotCode__c, DistributionChannel__c, Division__c, Sales_Org__c ");
              }
              else if(ordrWrap.businessTypeName == 'B2B'){
                filtr = "AND Distribution_Channel__c  IN "+ distChnl +" AND Division__c IN "+ divsn +" AND Sales_Org__c =\'"+ resp.salesOrgObj.Id+"\' AND Pack_Size__c != null AND Active__c = true ORDER BY LastModifiedDate DESC ";
                component.set("v.objectName","SKU__c");
                //component.set("v.displayField","SKU_Description__c");
                //component.set("v.displayFieldSecond","SKU_Code__c");
                component.set("v.queryField",", Pack_Size__c, SKU_Code__c, SKU_Description__c, Sales_Org__c, UOM__c, Active__c, Distribution_Channel__c, Distribution_Channel_Code__c, Division__c, Division_Code__c, Multiple_of__c ");
              }
                
              component.set("v.PriceBookFilter",filtr);

              console.log(' Depo Obj length :- ', ordrWrap.Depo_Obj.length);

              if(ordrWrap.Depo_Obj.length == 0 || ordrWrap.Depo_Obj == null){
                component.find("depo_id").focus();
                var toastEvent1 = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Please_Select_Depot}");
                var titl  = $A.get("{!$Label.c.Warning}");
                toastEvent1.setParams({
                    "title": titl,
                    "type": "Warning",
                    "message": msg
                    //"duration":'3000'
                });
                toastEvent1.fire();
              }
              
            }
            
            //component.set("v.displayField","SKUCode__r.SKU_Description__c");
            //component.set("v.displayFieldSecond","SKUCode__r.SKU_Code__c");
            if(ordrWrap.businessTypeName == 'B2C'){
                component.set("v.displayField","SKUCode__r.SKU_Description__c");
                component.set("v.displayFieldSecond","SKUCode__r.SKU_Code__c");
            }
            else if(ordrWrap.businessTypeName == 'B2B'){
                component.set("v.displayField","SKU_Description__c");
                component.set("v.displayFieldSecond","SKU_Code__c");
            }
            else{
              this.bussinessTypeError(component, event, helper);
            }

            var ordWrap = component.get("v.orderWrapper");
            ordWrap.salesOrgObj = resp.salesOrgObj.Id;
            ordWrap.Order_Type = resp.Order_Type.Id;
            //ordWrap.Depo_Obj = resp.Depo_Obj.Id;
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

  getInventory: function(component, event, helper) {
    //console.log('RecordTp.... ',rcdTp_nm);
    component.set("v.showSpinner", true);
    var pb = component.get("v.selectedPBRecord");
    var ordFr = component.find("order_for").get("v.value");
    var ordrWrap = component.get("v.orderWrapper");
    var skuId = '';

    if(ordrWrap.businessTypeName == 'B2C'){
      skuId = pb.SKUCode__r.Id;
    }
    else if(ordrWrap.businessTypeName == 'B2B'){
      skuId = pb.Id;
    }
    else {
      console.log('Inventory.... :- ', 'Bussiness Type Not set, so as SKU Id');
    }

    /* if(ordrWrap.Depo_Obj == null || ordrWrap.Depo_Obj == ''){
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
        component.set("v.showSpinner", false);
    }
    else{ */

      if(pb!=null){
        var action = component.get("c.getSKUInventory");
        action.setParams({
          skuId : skuId,
          Sales_Org_Code : ordFr,
          depoId : ordrWrap.Depo_Obj
        });
  
        action.setCallback(this, function(response) {
        if (response.getState() == "SUCCESS") {
            
          var resp = response.getReturnValue();
          console.log('Inventory Response.... ',resp);
          if(resp != null){
            var pbWrap = component.get("v.priceBookWrap");
              
              pbWrap.inventory = resp.inventory;       
              component.set("v.priceBookWrap",pbWrap);
  
          }
          
        }
        component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
      }
    //}
    
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
      
     //updated by Vishal   
      ordWrap.creditSummary.credit_limit_balance = ordWrap.creditSummary.credit_limit_balance.replace(/\$|,/g, '');
      ordWrap.creditSummary.credit_limit_used = ordWrap.creditSummary.credit_limit_used.replace(/\$|,/g, '');
      
      ordWrap.creditSummary.internal_credit_limit = ordWrap.creditSummary.internal_credit_limit.replace(/\$|,/g, '');
      ordWrap.creditSummary.net_overdue = ordWrap.creditSummary.net_overdue.replace(/\$|,/g, '');
      ordWrap.creditSummary.total_credit_limit = ordWrap.creditSummary.total_credit_limit.replace(/\$|,/g, '');
      ordWrap.creditSummary.total_outstanding = ordWrap.creditSummary.total_outstanding.replace(/\$|,/g, '');
      
      
      //console.log('ordWrap.net_price_litre in create so '+ordWrap.net_price_litre);
      
      if(/(,|-)/.test(ordWrap.net_price_litre)){
          ordWrap.net_price_litre = ordWrap.net_price_litre.replace(/\$|,/g, '');
      }
      
      if(/(,|-)/.test(ordWrap.net_price_kg)){
          ordWrap.net_price_kg = ordWrap.net_price_kg.replace(/\$|,/g, '');
      }
      
      
      if(/(,|-)/.test(ordWrap.total_amount)){
          ordWrap.total_amount = ordWrap.total_amount.replace(/\$|,/g, '');
      }
      
      
      
      //console.log('orderItemList after clicking in create so '+ordWrap.orderItemList);
      //console.log('orderItemList after clicking in create so '+ordWrap.orderItemList.length);
      
      for(var i=0;i<ordWrap.orderItemList.length;i++){
          
          if(/(,|-)/.test(ordWrap.orderItemList[i].net_rate)){
              ordWrap.orderItemList[i].net_rate = ordWrap.orderItemList[i].net_rate.replace(/\$|,/g, '');
          }
          if(/(,|-)/.test(ordWrap.orderItemList[i].net_value)){
              ordWrap.orderItemList[i].net_value = ordWrap.orderItemList[i].net_value.replace(/\$|,/g, '');
          }
          
      }
      console.log('ordWrap '+ ordWrap);
      //update end by vishal  
   
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
      component.set("v.showSpinner", true);
      var ordWrap = component.get("v.orderWrapper");
      
      //updated by Vishal   
      ordWrap.creditSummary.credit_limit_balance = ordWrap.creditSummary.credit_limit_balance.replace(/\$|,/g, '');
      ordWrap.creditSummary.credit_limit_used = ordWrap.creditSummary.credit_limit_used.replace(/\$|,/g, '');
      
      ordWrap.creditSummary.internal_credit_limit = ordWrap.creditSummary.internal_credit_limit.replace(/\$|,/g, '');
      ordWrap.creditSummary.net_overdue = ordWrap.creditSummary.net_overdue.replace(/\$|,/g, '');
      ordWrap.creditSummary.total_credit_limit = ordWrap.creditSummary.total_credit_limit.replace(/\$|,/g, '');
      ordWrap.creditSummary.total_outstanding = ordWrap.creditSummary.total_outstanding.replace(/\$|,/g, '');
      
      
      console.log('ordWrap.net_price_litre in create so '+ordWrap.net_price_litre);
      
      if(/(,|-)/.test(ordWrap.net_price_litre)){
          ordWrap.net_price_litre = ordWrap.net_price_litre.replace(/\$|,/g, '');
      }
      
      if(/(,|-)/.test(ordWrap.net_price_kg)){
          ordWrap.net_price_kg = ordWrap.net_price_kg.replace(/\$|,/g, '');
      }
      
      if(/(,|-)/.test(ordWrap.total_amount)){
          ordWrap.total_amount = ordWrap.total_amount.replace(/\$|,/g, '');
      }
      
      
      
      console.log('orderItemList after clicking in create so '+ordWrap.orderItemList);
      console.log('orderItemList after clicking in create so '+ordWrap.orderItemList.length);
      
      for(var i=0;i<ordWrap.orderItemList.length;i++){
          
          if(/(,|-)/.test(ordWrap.orderItemList[i].net_rate)){
              ordWrap.orderItemList[i].net_rate = ordWrap.orderItemList[i].net_rate.replace(/\$|,/g, '');
          }
          if(/(,|-)/.test(ordWrap.orderItemList[i].net_value)){
              ordWrap.orderItemList[i].net_value = ordWrap.orderItemList[i].net_value.replace(/\$|,/g, '');
          }
          
      }
      
      //update end by vishal
      
      
      
      if(ordWrap!=null){
      var action = component.get("c.createNewSO");
      action.setParams({
        orderObj: JSON.stringify(ordWrap)
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

          if(component.get("v.isFileReq") == true){
            var fileLen = component.find("fileId").get("v.files");
            if(fileLen != null){
              if(fileLen.length > 0) {
                  component.set("v.parentId",ordIds); 
                  this.uploadHelper(component, event);
              }
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
    console.log('ordWrap.... in update SO ', ordWrap);
    //updated by vishal
         
      ordWrap.creditSummary.credit_limit_balance = ordWrap.creditSummary.credit_limit_balance.replace(/\$|,/g, '');
      ordWrap.creditSummary.credit_limit_used = ordWrap.creditSummary.credit_limit_used.replace(/\$|,/g, '');
      
      ordWrap.creditSummary.internal_credit_limit = ordWrap.creditSummary.internal_credit_limit.replace(/\$|,/g, '');
      ordWrap.creditSummary.net_overdue = ordWrap.creditSummary.net_overdue.replace(/\$|,/g, '');
      ordWrap.creditSummary.total_credit_limit = ordWrap.creditSummary.total_credit_limit.replace(/\$|,/g, '');
      ordWrap.creditSummary.total_outstanding = ordWrap.creditSummary.total_outstanding.replace(/\$|,/g, '');
      
      //ordWrap.net_price_litre = ordWrap.net_price_litre.replace(/\$|,/g, '');
      //ordWrap.total_amount = ordWrap.total_amount.replace(/\$|,/g, '');
      //ordWrap.net_price_kg = ordWrap.net_price_kg.replace(/\$|,/g, '');
      
      if(/(,|-)/.test(ordWrap.net_price_litre)){
          ordWrap.net_price_litre = ordWrap.net_price_litre.replace(/\$|,/g, '');
      }
      
      if(/(,|-)/.test(ordWrap.net_price_kg)){
          ordWrap.net_price_kg = ordWrap.net_price_kg.replace(/\$|,/g, '');
      }
      
      if(/(,|-)/.test(ordWrap.total_amount)){
          ordWrap.total_amount = ordWrap.total_amount.replace(/\$|,/g, '');
      }
      
      //console.log('orderItemList after clicking in update so '+ordWrap.orderItemList);
      //console.log('orderItemList after clicking in update so '+ordWrap.orderItemList.length);
      
      for(var i=0;i<ordWrap.orderItemList.length;i++){
          //console.log('replace char '+ordWrap.orderItemList[i].net_rate);
          //console.log('replace char '+ordWrap.orderItemList[i].net_value);
          //ordWrap.orderItemList[i].net_rate = ordWrap.orderItemList[i].net_rate.replace(/\$|,/g, '');
          //ordWrap.orderItemList[i].net_value = ordWrap.orderItemList[i].net_value.replace(/\$|,/g, '');
          
          if(/(,|-)/.test(ordWrap.orderItemList[i].net_rate)){
              ordWrap.orderItemList[i].net_rate = ordWrap.orderItemList[i].net_rate.replace(/\$|,/g, '');
          }
          if(/(,|-)/.test(ordWrap.orderItemList[i].net_value)){
              ordWrap.orderItemList[i].net_value = ordWrap.orderItemList[i].net_value.replace(/\$|,/g, '');
          }
      }
     
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

            if(component.get("v.isFileReq") == true){
              var fileLen = component.find("fileId").get("v.files");
              if(fileLen != null){
                if(fileLen.length > 0) {
                    component.set("v.parentId",ordIds); 
                    this.uploadHelper(component, event);
                }
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

  bussinessTypeError: function(component, event, helper) {
    var toastEvent1 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.Customer_Group_Not_Defined_At_Customer_Level}");
            var titl  = $A.get("{!$Label.c.Error}");
            toastEvent1.setParams({
                "title": titl,
                "type": "Error",
                "message": msg
                //"duration":'3000'
            });
            toastEvent1.fire();
  },


})