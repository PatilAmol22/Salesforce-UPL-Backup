({
    // Init method to initalize default values in form on component load. 
    doInit: function(component, event, helper) {
        //Populate all picklists
        var isSimulated = component.get("v.isSimulated");
       
        helper.redirectBack(component,event);
        helper.getOrderFields(component,event,isSimulated);
        helper.getCreatedDate(component); //SCTASK0340391 Account search button check
        helper.getCurrentUserAppoval(component,event);// Added by Shubham 10th Feb
        helper.isbrazilusercheck(component);
        helper.isBrazilSalesUser(component);
        helper.isSOCancelProcess(component);
        helper.isSOItemsEditProcess(component);
        helper.SKUUpdateAPI(component, event, helper); // Added by Sagar@Wipro for StatusOrdemVendas API Call
        helper.inventory(component,event,helper);//CREATED METHOD FOR INVENTORY CONTROL OBJECT BY HARSHIT&ANMOL@WIPRO FOR (US IU-001)
        helper.fetchRegionCode(component); // Added for RITM0508956 GRZ(Dheeraj Sharma) 20-02-2023
        var profileName = component.get("v.user.Profile.Name");
    if (	
      profileName == "Brazil Sales District Manager" ||	
      profileName == "Brazil Barter Manager"	
    ){
            helper.fetchSeller(component);  
        }
        helper.getSellOutMatrix(component, event, helper); //added by Krishanu@wipro
        helper.getExchangeRate(component, event, helper); //added by Krishanu@wipro
    }, 
    onPronutivaChange:function(component, event, helper){
        var srcId = event.getSource().get("v.value");
        // alert('pronutiva'+srcId);
        var ordTyp = component.find("orderTypeOptions").get("v.value"); 
        
        component.set("v.pronutivaVal",srcId);
        
    if (srcId == "Yes") {
            //  if(ordTyp == 'VENDA NORMAL'){
            component.find("dirSaleNo").set("v.value", true); 
            component.find("dirSaleYes").set("v.value", false); 
            component.find("dirSaleNo").set("v.disabled", true); 
            component.find("dirSaleYes").set("v.disabled", true); 
            component.set("v.newSalesOrder.Directed_Sales__c", false);
            //  }
            
            component.set("v.newSalesOrder.Pronutiva__c", true);
    } else if (srcId == "No") {
            //if(ordTyp == 'VENDA NORMAL'){
      component.find("dirSaleNo").set("v.value", "");
            component.find("dirSaleNo").set("v.disabled", false); 
            component.find("dirSaleYes").set("v.disabled", false); 
            // }
            
            component.set("v.newSalesOrder.Pronutiva__c", false);  
            //component.set("v.newSalesOrder.Directed_Sales__c", false);
        }
    },
    
    ondirctSalesChange:function(component, event, helper){
        var sourceRadio = event.getSource();
        var srcId = sourceRadio.getLocalId();
    if (srcId == "dirSaleYes") {
            component.set("v.newSalesOrder.Directed_Sales__c", true);  
        }
    if (srcId == "dirSaleNo") {
            component.set("v.newSalesOrder.Directed_Sales__c", false);
        }
     console.log('component.get("v.newSalesOrder.Directed_Sales__c"', component.get("v.newSalesOrder.Directed_Sales__c"));
    },

    //modified by Krishanu @ wipro
  onCheckchange: function (component, event, helper) {
    // Changes made by Krishanu Mallik Thakur
        var checkCmp = false;
        var PriceBook = component.find("SelectPB").get("v.value");
        var isSimulated = component.get("v.isSimulated");
        var orderTypeList = component.get("v.orderTypeList");
        var currencyList = component.get("v.currencyList");
        var opts=[];//alert(checkCmp.get("v.value"));
        console.log("curr"+currencyList);
        if(PriceBook=="Price Book for Campaign"){
            checkCmp = true;
            component.set("v.newSalesOrder.Use_Campaign__c",checkCmp);
            component.set("v.CampaignCheck",checkCmp);
            //component.set("v.isStructure", checkCmp);
            helper.getOrderFields(component,event,isSimulated);
    } else if (PriceBook == "AVEC / Descontinuados Price Book") {
      //Modified by Harit@wipro
        component.set("v.isAvec",true);
            checkCmp = false;
        component.set("v.CampaignCheck",checkCmp);
        if(component.get('v.paymentTermAfterEmpty').length > 0){  //Added by GRZ(Butesh Singla) for INC04226660  modified 23-01-2023
          component.find("paymentTermOptions").set("v.options",component.get("v.paymentTermAfterEmpty"));  //Added by GRZ(Butesh Singla) for INC04226660  modified 23-01-2023
        }  //Added by GRZ(Butesh Singla) for INC04226660  modified 23-01-2023
        component.set("v.newSalesOrder.AVEC_Order__c",true);
            
            //component.set("v.isSimple", checkCmp);
            component.set("v.isKit",false);

            console.log(component.get("v.isAvec"));
            component.set("v.newSalesOrder.Directed_Sales__c",true);// Modified by by Anmol@wipro for US SO-002
            helper.getOrderFields(component,event,isSimulated);
        }else if(PriceBook=="Price Book for Kit"){ //Modified by Krishanu&Ankita@wipro
        checkCmp = false;
        component.set("v.newSalesOrder.AVEC_Order__c",false);
        component.set("v.CampaignCheck",checkCmp);
        //component.set("v.isSimple", checkCmp);
        component.set("v.isKit",true);
        component.set("v.isAvec",false);
        component.set("v.newSalesOrder.Directed_Sales__c",false);// Modified by by Anmol@wipro for US SO-002
        helper.getOrderFields(component,event,isSimulated);
    }else{
            checkCmp = false;
            component.set("v.newSalesOrder.Use_Campaign__c",false);
            component.set("v.CampaignCheck",false);
            component.set("v.isAvec",false);
            component.set("v.isKit",false);

            component.set("v.newSalesOrder.AVEC_Order__c",false);
            helper.getOrderFields(component,event,isSimulated);
        }
        //alert("AVEC"+ component.get("v.newSalesOrder.AVEC_Order__c"));
        component.set("v.CampaignCheck",checkCmp);
        component.set("v.newSalesOrder.Use_Campaign__c",checkCmp);																										 
        //Vivek added for RITM0329481 paymentterm issue
        //component.set("v.newSalesOrder.Campaign_Payment_Term__c",null);
        component.set("v.newSalesOrder.Campaign_Payment_Term_Date__c",null);
        component.set("v.newSalesOrder.Maturity_Date__c",null);
        component.set("v.isMature",false);

        if(isSimulated){
            component.set("v.isStructure",false);
            if(checkCmp){
                component.find("structCmp").set("v.disabled",true);
            }
        }

        if(!checkCmp){
            component.set("v.isStructure", checkCmp);
            component.set("v.newSalesOrder.Campaign_Type__c","None");
            // For BONIFICAÇÃO removal.... 
            //Order Type
      opts.push({
        class: "optionClass",
        label: $A.get("$Label.c.None"),
        value: "None",
      });
            for(var i=0; i< orderTypeList.length; i++){
                //If New Simulation and Order Type=='Child' do not add order type in picklist
        if (isSimulated && orderTypeList[i].search("ORDEM FILHA") == -1) {
          opts.push({
            class: "optionClass",
            label: orderTypeList[i],
            value: orderTypeList[i],
          });
                }
                //If not simulated record add all order types in picklist
                else if(!isSimulated){
          opts.push({
            class: "optionClass",
            label: orderTypeList[i],
            value: orderTypeList[i],
          });
                }
            }
            component.find("orderTypeOptions").set("v.options", opts);                
            //End 
    } else {
            component.set("v.newSalesOrder.Campaign_Type__c","Simple");
            component.set("v.isSimple", checkCmp);
            component.find("simpCmp").set("v.value",true);
            
            // For BONIFICAÇÃO removal....
            //Order Type
      opts.push({
        class: "optionClass",
        label: $A.get("$Label.c.None"),
        value: "None",
      });
            for(var i=0; i< orderTypeList.length; i++){
        if (
          orderTypeList[i] != "BONIFICAÇÃO" ||
          orderTypeList[i] != "REMESSA PARA TESTE"
        ) {
                    //If New Simulation and Order Type=='Child' do not add order type in picklist
          if (isSimulated && orderTypeList[i].search("ORDEM FILHA") == -1) {
            opts.push({
              class: "optionClass",
              label: orderTypeList[i],
              value: orderTypeList[i],
            });
                    }
                    //If not simulated record add all order types in picklist
                    else if(!isSimulated){
            opts.push({
              class: "optionClass",
              label: orderTypeList[i],
              value: orderTypeList[i],
            });
                    }
                }
            }
            component.find("orderTypeOptions").set("v.options", opts);       
            //End 
        }    

        // component.set("v.newSalesOrder.Campaign_Type__c",'None');
        //var isChecked= component.find("campChk").get("v.value");
        
        var isChecked= component.get("v.CampaignCheck");												
        var opts=[];
        if(!isChecked&&!component.get("v.isAvec")){
            opts=[];
      opts.push({
        class: "optionClass",
        label: $A.get("$Label.c.None"),
        value: "None",
      });
            //console.log('Payment Terms:'+JSON.stringify(returnValue.paymentTermsMap));
            var paymentTermsMap = component.get("v.paymentTermsMap");
            //var ptMap = new Map();
            
            for (var key in paymentTermsMap){
        opts.push({ class: "optionClass", label: key, value: key });
                //ptMap.set(key, paymentTermsMap[key]);
            }     
            //console.log('Payment Terms:'+JSON.stringify(opts));
            component.set("v.paymentTermsMap", paymentTermsMap);
            component.find("paymentTermOptions").set("v.options", opts);
        }

        //Inco Terms
        var inco = component.get("v.incoTermList");
        component.set("v.incoTermList",inco);
        opts=[];
        for(var i=0; i< inco.length; i++){
            var str = inco[i];
            var splitValues = str.split("*");
      opts.push({
        class: "optionClass",
        label: splitValues[0],
        value: splitValues,
      });
        }
        var incopts =component.find("incoTermOptions");
        if(incopts){
            incopts.set("v.options", opts);                
        }
        //Currency
        opts=[];
    opts.push({
      class: "optionClass",
      label: $A.get("$Label.c.None"),
      value: "None",
    });
        for(var i=0; i< currencyList.length; i++){
            var str = currencyList[i];
            var splitValues = str.split("*");
      opts.push({
        class: "optionClass",
        label: splitValues[0],
        value: splitValues[1],
      });
            //opts.push({"class": "optionClass", label: currencyList[i], value: currencyList[i]});
        }
        //console.log('currencyList: '+JSON.stringify(currencyList));
        component.find("currencyOptions").set("v.options", opts);               
        //End
    },
    onchageCampType : function(component, event) {
        $("#spinner").hide();
        var sourceRadio = event.getSource();
        var srcId = sourceRadio.getLocalId();
        var currencyList= component.get("v.currencyList");
        var orderType = component.find("orderTypeOptions").get("v.value");
    if (orderType != "None" && orderType != "Nenhum") {
            component.set("v.isOrderNotNone",true);
        }   
        //alert(orderType +'---'+component.get("v.isOrderNotNone"));   
        var opts=[]; 
    if (srcId == "structCmp" && sourceRadio.get("v.value")) {
            component.set("v.isStructure",true); 
            component.set("v.isSimple",false);  
            component.set("v.newSalesOrder.Campaign_Type__c","Structured");
            component.find("simpCmp").set("v.value",false);
            component.find("structCmp").set("v.value",true);
      if (orderType == "ORDEM FILHA") {
                component.set("v.isOrdemFilha",true);
            }else{
                component.set("v.isOrdemFilha",false);
            }  
            //Currency
            opts=[];
      opts.push({
        class: "optionClass",
        label: $A.get("$Label.c.None"),
        value: "None",
      });
            for(var i=0; i< currencyList.length; i++){
                var str = currencyList[i];
                var splitValues = str.split("*");
                
        if (splitValues[1] == "Billing BRL / Payment BRL") {
          opts.push({
            class: "optionClass",
            label: "BRL",
            value: splitValues[1],
          });
        } else if (splitValues[1] == "Billing USD / Payment BRL") {
          opts.push({
            class: "optionClass",
            label: "USD",
            value: splitValues[1],
          });
                }
                }
            //console.log('currencyList: '+JSON.stringify(currencyList));
            component.find("currencyOptions").set("v.options", opts);               
            //End
        }
    if (srcId == "simpCmp" && sourceRadio.get("v.value")) {
            component.set("v.isSimple",true); 
            component.set("v.isStructure",false);
            component.set("v.newSalesOrder.Campaign_Type__c","Simple");
            component.find("simpCmp").set("v.value",true);
            component.find("structCmp").set("v.value",false);
            //alert(component.get("v.newSalesOrder.Campaign_Type__c"));   
            
            //Currency
            opts=[];
      opts.push({
        class: "optionClass",
        label: $A.get("$Label.c.None"),
        value: "None",
      });
//Updated Below Condition for RITM0571431  GRZ(Dheeraj Sharma) 13-06-2023
      var regCode =component.get("v.regCode");  

      var USD_BRLCurrency=component.get("v.USD_BRLCurrencyavailable");

      console.log('USD_BRLCurrency',USD_BRLCurrency);
      
        var usdbrl = USD_BRLCurrency.split(",");
        console.log('usdbrl',usdbrl);

        for(var i=0;i<usdbrl.length;i++){
            if(usdbrl[i]==regCode){
            component.set("v.usdcheck",true);
            }
        }
        var usdchecktrue=component.get("v.usdcheck");
      console.log('usdbrlcheck',usdchecktrue);


     
                           if(usdchecktrue==true){       //    Updated Condition for RITM0571431  GRZ(Dheeraj Sharma) 13-06-2023 


                    for (var i = 0; i < currencyList.length; i++) {
                        console.log('1');
                        var str = currencyList[i];
                        var splitValues = str.split("*");
                                
                          opts.push({
                                class: "optionClass",
                                label: splitValues[0],
                                value: splitValues[1],
                            });
                        
                    
                    }
                    console.log('opts',opts);
                    component.find("currencyOptions").set("v.options", opts);

                }else{

        
            for(var i=0; i< currencyList.length; i++){
                var str = currencyList[i];
                var splitValues = str.split("*");
                if(splitValues[1]!='Billing USD / Payment BRL'){    //Updated for RITM0507224  GRZ(Dheeraj Sharma) 17-02-2023
                    opts.push({
                        class: "optionClass",
                        label: splitValues[0],
                        value: splitValues[1],
                      });
                }


       
                //opts.push({"class": "optionClass", label: currencyList[i], value: currencyList[i]});
            }
        }
            //console.log('currencyList: '+JSON.stringify(currencyList));
            component.find("currencyOptions").set("v.options", opts);   
            
            //Updated End Condition for RITM0571431  GRZ(Dheeraj Sharma) 13-06-2023
            //End
            //Inco Terms
            var inco = component.get("v.incoTermList");
            component.set("v.incoTermList",inco);
            opts=[];
            for(var i=0; i< inco.length; i++){
                var str = inco[i];
                var splitValues = str.split("*");
        opts.push({
          class: "optionClass",
          label: splitValues[0],
          value: splitValues,
        });
            }
            var incopts =component.find("incoTermOptions");
            if(incopts){
                incopts.set("v.options", opts);                
            }
            //end
            //Payment Method
            var paymentMethodList = component.get("v.paymentMethodList");
            opts=[];
      opts.push({
        class: "optionClass",
        label: $A.get("$Label.c.None"),
        value: "None",
      });
            for(var i=0; i < paymentMethodList.length; i++){
                var str = paymentMethodList[i];
                var splitValues = str.split("*");
        opts.push({
          class: "optionClass",
          label: splitValues[0],
          value: splitValues[1],
        });
            }
            var paymentopts=component.find("paymentMethodOptions");
            if(paymentopts){
                paymentopts.set("v.options", opts);
            }
            
            //console.log("opts: "+JSON.stringify(opts));
            //End
        }
        //alert(.get("v.value"));
    },
    //Logic to open Sign/Unsign Dialog
    openSignDialog: function(component,event,helper){
        helper.toggleSignDialog(component);
    },
    
    //Logic to close Sign/Unsign Dialog
    closeSignDialog: function(component,event,helper){
        helper.toggleSignDialog(component);
    },  
    
    //Method to validate Purchase Order No. has alpha numeric characters only.
    validatePO: function(component,event,helper){
        var target = event.getSource();  
        var inp = target.get("v.value");
        var letterNumber = /^[0-9a-zA-Z]+$/;
    if (inp.match(letterNumber)) {
            target.set("v.errors", null); 
            $A.util.removeClass(target, "error");
    } else {
      var errorMessage = $A.get(
        "$Label.c.Purchase_Order_No_is_required_and_can_contain_only_characters_and_numbers"
      );
      var setValue = ""; //inp.replace(/\W+/g, " ");
            target.set("v.errors", [{message:errorMessage}]);
            target.set("v.value",setValue);
            
            $A.util.addClass(target, "error");
        }
    },
    //Deeksha :SCTASK0216504 :Method to validate Product Purchase Order No. has alpha numeric characters only.
    validatePOItemNumber: function(component,event,helper){
        var target = event.getSource();  
        var inp = target.get("v.value");
        var letterNumber = /^[0-9]*$/;
    if (inp.match(letterNumber)) {
            target.set("v.errors", null); 
            $A.util.removeClass(target, "error");
    } else {
      var errorMessage = $A.get(
        "$Label.c.Product_PO_item_number_should_be_3_digit"
      );
      var setValue = ""; //inp.replace(/\W+/g, " ");
            target.set("v.errors", [{message:errorMessage}]);
            target.set("v.value",setValue);
            
            $A.util.addClass(target, "error");
        }
    }, 
    
    //Method to validate Invoice Message has alpha numeric characters only.
    validateInvoice: function(component,event,helper){
        var target = event.getSource();  
        var inp = target.get("v.value");
        if(inp){
            var letterNumber = /^[a-z\d\-_;\s]+$/i;
      if (inp.match(letterNumber)) {
                target.set("v.errors", null); 
                $A.util.removeClass(target, "error");
                component.set("v.isValidInvoice",true);
      } else {
        var errorMessage = $A.get(
          "$Label.c.Invoice_Message_can_contain_only_characters_and_numbers"
        );
                //var setValue = ''; //inp.replace(/\W+/g, " ");
                target.set("v.errors", [{message:errorMessage}]);
                //target.set("v.value",setValue);
                $A.util.addClass(target, "error");
                component.set("v.isValidInvoice",false);
            }
        }
    },  
    
    // 1. Logic to Cancel Order (Only Available for Brazil System Administrator, Sales Person & Customer Service User)
    // 2. Sales Person allowed to cancel records owned by him/her.
    // 3. Brazil System Admin/Customer Service User can cancel approved orders.
    cancelOrder: function(component,event,helper){
        var remarks = component.find("remarks");
        //console.log('remarks: '+remarks);
        
        if(!remarks.get("v.value")){
      component
        .find("remarks")
        .set("v.errors", [
          {
            message: $A.get(
              "$Label.c.Remarks_required_for_a_cancelled_Sales_Order"
            ),
          },
        ]);
    } else {
            component.find("remarks").set("v.errors",null);
            var profileName = component.get("v.orderFields.userObj.Profile.Name");
      var orderSubStatus = "";
            
      if (
        profileName == "Brazil System Administrator" ||
        profileName == "System Administrator"
      ) {
        orderSubStatus = "Cancelled by Admin";
      } else if (profileName == "Brazil Customer Service User") {
        orderSubStatus = "Cancelled by Customer Service Executive";
      } else {
        orderSubStatus = "Cancelled by Sales Person";
            }
            
            component.set("v.newSalesOrder.Order_Status__c", "Cancelled");
            component.set("v.newSalesOrder.OrderSubStatus__c", orderSubStatus);
            
      if (
        confirm(
          $A.get("$Label.c.Are_you_sure_you_want_to_Cancel_the_Sales_Order")
        )
      ) {
                var action = component.get("c.signOrder");
                action.setParams({ 
          soObj: component.get("v.newSalesOrder"),
                });
                
                action.setCallback(this, function(a) {
                    var state = a.getState();
          var toastMsg = "";
                    if (state == "SUCCESS") {
                        component.set("v.showCancel", false);
                        toastMsg = $A.get("$Label.c.Sales_Order_Cancelled");
                        helper.showToast(component, event, toastMsg); 
                        
            var profileName = component.get(
              "v.orderFields.userObj.Profile.Name"
            );
            var fullUrl = "";
            var defType = "cancelled";
            if (
              profileName == "Brazil Customer Service User" ||
              profileName == "Brazil System Administrator"
            ) {
                            fullUrl = "/apex/BrazilEnhancedList2?defType="+defType;
                            helper.gotoURL(component,fullUrl);
            } else if (profileName == "Brazil Sales Person") {
                            fullUrl = "/apex/BrazilEnhancedListForSP?defType="+defType;
                            helper.gotoURL(component,fullUrl);
                        }                          
          } else {
            toastMsg = "Sales Order Cancellation Failed";
                        helper.showErrorToast(component, event, toastMsg);   
                    }             
                });
                $A.enqueueAction(action);  
            }            
        }        
    },  
    
    //Logic to delete Sales Order (Only Draft & Simulated Orders can be deleted by Record Owner)
    deleteRecord: function(component,event,helper){
        var rcdTp = component.get("v.recordType");
        // show a confirm
    if (
      confirm($A.get("$Label.c.Are_you_sure_you_want_to_delete_this_Order"))
    ) {
            // perform custom logic here    
            
            var action = component.get("c.deleteSalesOrder");
            action.setParams({ 
        recordId: component.get("v.recordId"),
            });
            
            action.setCallback(this, function(a) {
                var state = a.getState();
        var toastMsg = "";
                if (state == "SUCCESS") {
                    var flag = a.getReturnValue();
                    if(flag){
                        toastMsg = $A.get("$Label.c.Order_Deleted_Successfully");
                        helper.showToast(component, event, toastMsg);
                        
            var profileName = component.get(
              "v.orderFields.userObj.Profile.Name"
            );
                        
                        if(rcdTp == "Simulation"){
                            var fullUrl = "/apex/SimulationOrderEnhancedView";
                            helper.gotoURL(component,fullUrl);
            } else {
              if (profileName == "Brazil Sales Person") {
                                var fullUrl = "/apex/BrazilEnhancedListForSP?defType=pending";
                                helper.gotoURL(component,fullUrl);
                            }
                        }
          } else {
            toastMsg = $A.get(
              "$Label.c.Delete_denied_Please_contact_System_Administrator"
            );
                        helper.showErrorToast(component, event, toastMsg);   
                    }
        } else {
          toastMsg = $A.get(
            "$Label.c.Unable_to_delete_Order_Please_contact_System_Administrator"
          );
                    helper.showErrorToast(component, event, toastMsg);   
                }             
            });
            $A.enqueueAction(action);  
        }
    },
    
    // 1. Method called to Sign/Unsign Order.
    // 2. Only Available for Brazil System Administrator.
    signedOrder: function(component,event,helper){
        helper.toggleSignDialog(component);
        
        var signed = component.get("v.newSalesOrder.Signed__c");
        
        if(signed){
            component.set("v.newSalesOrder.Signed__c",false);
    } else {
            component.set("v.newSalesOrder.Signed__c",true);
        }        
        
        var action = component.get("c.signOrder");
        action.setParams({ 
      soObj: component.get("v.newSalesOrder"),
        });
        
        action.setCallback(this, function(a) {
            var state = a.getState();
      var toastMsg = "";
            if (state == "SUCCESS") {
                var signed = component.get("v.newSalesOrder.Signed__c");
                
                if(signed){
                    component.set("v.showSign",false);
                    component.set("v.showUnsign",true);
          component.set(
            "v.signMessage",
            $A.get("$Label.c.Are_you_sure_you_want_to_unsign")
          );
        } else {
                    component.set("v.showSign",true);
                    component.set("v.showUnsign",false);
          component.set(
            "v.signMessage",
            $A.get("$Label.c.Are_you_sure_you_want_to_sign")
          );
                }
      } else {
                toastMsg = $A.get("$Label.c.Signing_Failed");
                helper.showErrorToast(component, event, toastMsg);   
            }             
        });
        $A.enqueueAction(action);  
    }, 
    
    //Logic to Simulate existing Order record (Not available to System Admin/Sales Person/Customer Service User)
    simulateOrder: function(component,event,helper){
       
        var newSO = component.get("v.newSalesOrder");
        //console.log('newso'+JSON.stringify(newSO));
        var orderItemList = component.get("v.orderItemList");
    console.log("orderItemList" + JSON.stringify(orderItemList));
        var action = component.get("c.simulateSalesOrder");
        action.setParams({ 
      soObj: newSO,
      salesOrderItemString: JSON.stringify(orderItemList),
      IsSimulated:component.get("v.isSimulated") //  Add IsSimulated Parameter for RITM0518333 GRZ(Javed Ahmed) 14-03-2023
        });
        
        action.setCallback(this, function(a) {
            var state = a.getState();
      var toastMsg = "";
            if (state == "SUCCESS") {
                toastMsg = $A.get("$Label.c.Sales_Order_simulated_successfully");
                // console.log('orderlineitem-->'+JSON.stringify(a.getReturnValue().soiList));
                component.set("v.newSalesOrder",a.getReturnValue().soObj);
                component.set("v.orderItemList",a.getReturnValue().soiList);
                component.set("v.disableThis", false);
                component.set("v.disableSelect", false);
                component.set("v.disablePaymentMethod", true);
                component.set("v.disablePriceCurrency", true);
                component.set("v.disableOrderType_Dates_SOM_Account", true);
                component.set("v.disableEdit", true);
                
                component.set("v.isSimulated", true);
                var staticLabel = $A.get("$Label.c.Create_Simulation_Order");
                component.set("v.headerMsg", staticLabel); 
                component.set("v.showSeller", false);
                component.set("v.showSimulate", false);
                component.set("v.showOnReLoad", false);
                component.set("v.showApproveReject", false);
                component.set("v.showSaveDraft", false); 
                component.set("v.showSubmitEdit", true); 
                component.set("v.showReset", true); 
                component.set("v.recordType","Simulation");
                
                helper.showToast(component, event, toastMsg);
      } else {
                toastMsg = $A.get("$Label.c.Simulation_failed");
                helper.showErrorToast(component, event, toastMsg);   
            }
        });
        $A.enqueueAction(action);
    },
    
    //1. Restrict Item level Quantity & Logic to enter quantity in Multiple of
    //2. Replace Negative Sign from Quantity Input
    //3. In case of 'Ordem Filha' type restrict Input Qty by checking against Balace Qty of selected SOM
    restrictQuantity: function(component, event, helper){
        var orderType = component.get("v.newSalesOrder.Type_of_Order__c");
        var target = event.getSource();  
        var rowIndex = target.get("v.requiredIndicatorClass");//Modified by Deeksha for kit selling Project
        var qty = target.get("v.value");
        var setValue = null;
        var kitOrder = component.get("v.newSalesOrder.Kit_Order__c");//Modified by Deeksha for kit selling Project
        //console.log('qty: '+qty);
        if(!qty){
            setValue = component.get("v.oldValueQty");
            target.set("v.value", setValue);
        }
        
        if(qty){
            var qtyString = qty.toString(); //Convert to string
            
      if (qtyString != "") {
                qty = parseFloat(qtyString.replace("-", "")); //Replace negative sign
                var NumOfZeroQ ;
                var NumOfZeroM;
                if(qty.toString().split(".").length>=2){
                    NumOfZeroQ = qty.toString().split(".").length;
        } else {
          NumOfZeroQ = 0;
                }
                qtyString = parseFloat(qtyString);// #INC-394341:Modified Deeksha Gupta :Change the condition
                target.set("v.value",qty);
                
                var multipleOf = target.get("v.placeholder");
                if(multipleOf.toString().split(".").length>=2){
                    NumOfZeroM = multipleOf.toString().split(".").length;
        } else {
          NumOfZeroM = 0;
                }
                var multipleOfString = parseFloat(multipleOf);// #INC-394341:Modified Deeksha Gupta :Change the condition
                var i;
                for (i = 0; i < NumOfZeroM+NumOfZeroQ; i++) {
                    qtyString = qtyString*10;
                    multipleOfString = multipleOfString*10;
                }
        var errorMessage = "";
                var flag = false;
                // alert(qty);
                // alert(multipleOf);
                // alert(qty%multipleOf);
                
                //var setValue = null;
                setValue = component.get("v.oldValueQty");
                //Modified by Deeksha for kit selling Project
                if(kitOrder){
                    if(!Number.isInteger(qty)){
                        qty = Math.floor(qty);
                        target.set("v.value", Math.floor(qty));                    	
                    }
                }
                // #INC-394341:Modified Deeksha Gupta :Change the condition
        if (
          multipleOf &&
          (qtyString % multipleOfString != 0 || qty < multipleOf)
        ) {
          console.log("multipleOf" + multipleOf + "--" + qty);
                    flag = true;
          errorMessage =
            $A.get("$Label.c.Qty_should_be_in_multiple_of") + " " + multipleOf;
        } else if (orderType == "ORDEM FILHA") {
                    var inventory = target.get("v.labelClass");
                    
                    //changes added by priya for RITM0232825 calculating balance quantity on quantity update
                    var priceDetailList = component.get("v.priceDetailList");
                    var orderItemList = component.get("v.orderItemList");
                    var rowIndx = component.get("v.rowIndex");
                    
                    if(qty <= inventory) {
                        for (var idx=0; idx < orderItemList.length; idx++) {                            
                            if (idx==rowIndx) {                             
                                for (var idxy = 0; idxy< priceDetailList.length; idxy++) {
                  if (
                    priceDetailList[idxy].itemNo == orderItemList[idx].itemNo
                  ) {
                    priceDetailList[idxy].balanceQty =
                      orderItemList[idx].inventory - orderItemList[idx].qty;
                    priceDetailList[idxy].percUsed = Math.abs(
                      (priceDetailList[idxy].balanceQty /
                        priceDetailList[idxy].qty) *
                        100
                    );
                                        //console.log('**afterCalculation balanceQty-->'+  priceDetailList[idxy].balanceQty);
                                        break;
                                    }
                                }   
                                component.set("v.priceDetailList", priceDetailList);
                                //orderItemList[idx].inventory= orderItemList[idx].inventory - orderItemList[idx].qty;
                                // break;
                            }
                        } 
                        
                        //changes ends
          } else {
                        flag = true;
                        //setValue = inventory;
            errorMessage =
              $A.get("$Label.c.Qty_cannot_be_greater_than_SOM_Balance") +
              " " +
              inventory;
                        //console.log(errorMessage);
                    }
                }
                
                if(flag){
                    target.set("v.value", setValue);
                    target.set("v.errors", [{message:errorMessage}]);
                    $A.util.addClass(target, "error");
        } else {
                    target.set("v.errors", null); 
                    $A.util.removeClass(target, "error");
                    //Modified by Deeksha for kit selling Project
                    var orderItemList = component.get("v.orderItemList");
                    var kitOrder = component.get("v.newSalesOrder.Kit_Order__c");
                    if(kitOrder){
                        for (var idx = 0; idx < orderItemList.length; idx++) {
              if (
                orderItemList[rowIndex].kitNo == orderItemList[idx].refKitNo
              ) {
                orderItemList[idx].qty = qty * orderItemList[idx].componentQty;
                            }
                        }
                        component.set("v.orderItemList", orderItemList);
                    }
                    helper.updatePriceTable(component, event);
                    //added by ganesh Date:4/6/18
                    //Desc:to update table row based on qty
                    helper.updateRowCalculations(component, event);
                }
            }
        }
    },
    
    //1. Check if difference between Date of FAT and Maturity Date not more than 360 days.
    //2. Check input Date of FAT is always greater than today
    //Note: Commented Logic was used to restrict Date Of FAT against Holidays & Saturday/Sunday (i.e Weekly Offs)
    restrictHolidays: function(component, event, helper){
        var target = event.getSource(); 
        var selectedDate = target.get("v.value");
        var rowIndex = target.get("v.labelClass");
        var selectedPaymentTerm = component.get("v.paymentTerm");
        var selectedPaymentTermDT = component.get("v.paymentTermDT");
        var smplCmp = component.get("v.newSalesOrder.Campaign_Type__c");
        var intrDate = component.get("v.interestDate");
        var intrFlag = true;
        
        // Added by Priya for RITM0176543 - SCTASK0398608       
        var orderItemList = component.get("v.orderItemList");      
        var minDate;
        var maxDate;
        var formatDat;
        var formatDatmax;

        var minDateError;
        var maxDateError;

        
        //Changes For RITM0373429 by EY team
        var indexValue = event.getSource().get("v.labelClass");
        if(component.get("v.isChild")){
            if(orderItemList[indexValue].qty != null){
                orderItemList[indexValue].qty = null;
        component.set(
          "v.orderItemList" + [indexValue],
          orderItemList[indexValue].qty
        );
            }
            if(orderItemList[indexValue].DDSGrade != null){
                orderItemList[indexValue].DDSGrade = null;
        component.set(
          "v.orderItemList" + [indexValue],
          orderItemList[indexValue].DDSGrade
        );
            }            
        }else{
            if(orderItemList[indexValue].unitValue != null){
                orderItemList[indexValue].unitValue = null;
        component.set(
          "v.orderItemList" + [indexValue],
          orderItemList[indexValue].unitValue
        );
            }
            if(orderItemList[indexValue].qty != null){
                orderItemList[indexValue].qty = null;
        component.set(
          "v.orderItemList" + [indexValue],
          orderItemList[indexValue].qty
        );
            }
            if(orderItemList[indexValue].DDSGrade != null){
                orderItemList[indexValue].DDSGrade = null;
        component.set(
          "v.orderItemList" + [indexValue],
          orderItemList[indexValue].DDSGrade
        );
            }
        }
        
        for(var i = 0; i <orderItemList.length; i++){
            //added by Dasoju Naresh kumar date 06/06/2022
            
            if(i==rowIndex){
                //productSKUCode.push(orderItemList[i].productId);
                minDate = orderItemList[i].minDate;
                maxDate = orderItemList[i].maxDate;

                break;
            }
        }	
        
        if(minDate!=null && minDate!=undefined && minDate != ""){
            formatDat = minDate.split("-");  
            
      minDateError =
        formatDat[2] + "/" + formatDat[1] + "/" + formatDat[0].substring(0, 4);
        }
         //added by Sirisha
         if(maxDate!=null && maxDate!=undefined && maxDate != ""){
          formatDatmax = maxDate.split("-");  
          
          
          
          maxDateError = formatDatmax[2]+ "/" +formatDatmax[1]+ "/" +formatDatmax[0].substring(0,4);
          
          
      }
      
            
    console.log("!!Inside Date blur minDate Error --> " + minDateError);
            
        //var inputCmp = component.find("validFrom");
        //var value = inputCmp.get("v.value");
        
        //var inputCmp2 = component.find("validToDate");
        //var value2 = inputCmp2.get("v.value");
        
        if(selectedDate){
            var today = new Date();
      var dd = (today.getDate() < 10 ? "0" : "") + today.getDate();
      var MM = (today.getMonth() + 1 < 10 ? "0" : "") + (today.getMonth() + 1);
            var yyyy = today.getFullYear();
            
            // Custom date format for ui:inputDate
      var currentDate = yyyy + "-" + MM + "-" + dd;
            
            var x = new Date(selectedDate);
            var y = new Date(currentDate);
            
            var z = new Date(minDate); // Added by Priya for RITM0176543 - SCTASK0398608
            var MD = new Date(maxDate);
            //console.log('z Date' +z);
            var flag = true;
            
            //console.log('+x <= +y: '+(+x <= +y));
            //console.log('x: '+x);
            //console.log('y: '+y);
            
            var day = new Date(selectedDate).getUTCDay();
            //console.log('day'+day);
            
      var maturityDate = "";
      if (smplCmp == "Simple") {
                var dt = component.get("v.newSalesOrder.Campaign_Payment_Term_Date__c");
                
        if (dt == undefined || dt == "None" || dt == "") {
                    maturityDate = component.get("v.newSalesOrder.Maturity_Date__c");
        } else {
                    maturityDate = dt;
                }
      } else {
                maturityDate = component.get("v.newSalesOrder.Maturity_Date__c"); 
            }
            
            // is less than today?
            if (+x <= +y) {
        target.set("v.errors", [
          { message: $A.get("$Label.c.FAT_should_be_greater_than_today") },
        ]);
                flag = false;
            } 
            
            // Added by Priya for RITM0176543 - SCTASK0398608
            else if(+x < +z){
        console.log("!! Inside date Error");
                if(minDateError!=null){
          target.set("v.errors", [
            {
              message:
                $A.get("$Label.c.Brazil_Validate_Min_Date") +
                " " +
                minDateError,
            },
          ]);
                    target.set("v.value","");  
                    flag = false;
                } 
              }else if(+x > +MD){
                  console.log('!! Inside date Error');
                  if(maxDateError!=null){
                      target.set("v.errors", [{message: $A.get("$Label.c.Maximum_Date") + ' ' +maxDateError}]);
                      target.set("v.value","");  
                      flag = false;
                  }
            }
            
            //component.set("v.minimumDate","");  minDateError='';
            /*else {
                target.set("v.errors", null);
            }*/
            
            //var target = event.getSource();  
            //var selectedDate = target.get("v.value");
                    else if(!isNaN(day)){
                        //Logic for Holidays
                        var holidayList = component.get("v.holidayList");
                        var val = holidayList.toString();
                        var errorMessage = "";
                        // Days in JS range from 0-6 where 0 is Sunday and 6 is Saturday   
                        /*if(day == 0 || day == 6 ) {
                    //target.set('v.validity', {valid:false, badInput :true});
                    
                    if(day == 0)
                        errorMessage= "Date of FAT cannot be Sunday";
                    else if(day == 6)
                        errorMessage= "Date of FAT cannot be Saturday";
                    
                    target.set("v.errors", [{message:errorMessage}]);
                    target.set("v.value","");
                }
                
                elseif(val.includes(selectedDate.toString())){ 
                    
                    errorMessage = "Date of FAT cannot be Holiday";
                    target.set("v.errors", [{message:errorMessage}]);
                    target.set("v.value","");            
                }
                
                else*/
                    if(maturityDate){
                        var oneDay = 24*60*60*1000; // hours*minutes*seconds*milliseconds
                        var firstDate = new Date(maturityDate);
                        var secondDate = new Date(selectedDate);
                        // console.log('firstDate'+firstDate);
                        //console.log('secondDate'+secondDate);
                        
                        /*
						RITM0286516
						If maturity date(first) is lower than interest(newIntr) date = 0
						If interest(newIntr) date is higher than fat(second) date = maturity(first) date - interest(newIntr) date  (fat date<interest date)
						If fat(second) date is higher than interest(newIntr) date = maturity date(first) - fat(second) date
						*/
          if (intrDate != null || intrDate != "") {
            console.log("@@firstDate: ", firstDate);
            console.log("@@secondDate: ", secondDate);
            console.log("@@newIntrDt: ", newIntrDt);
                            var newIntrDt = new Date(intrDate);
                            //alert(newIntrDt+' ==== '+ secondDate);
                            if(firstDate<newIntrDt){
                                component.set("v.days", 0);
            } else if (secondDate <= newIntrDt) {
              var calcuateDiff = Math.round(
                (firstDate.getTime() - newIntrDt.getTime()) / oneDay
              );
                                component.set("v.days", calcuateDiff);//commented by VT for Rollback
                                //component.set("v.days", 0);//Added by VT to rollback
                                intrFlag = false;
              console.log("@@calcuateDiff: ", calcuateDiff);
            } else if (secondDate > newIntrDt) {
              var diffDays = Math.round(
                (firstDate.getTime() - secondDate.getTime()) / oneDay
              );
                                    if(diffDays < 0){
                                        diffDays = 0;
              } else {
                                        diffDays = diffDays;
                                    }
                                    component.set("v.days", diffDays);
              console.log("@@diffDays: ", diffDays);
                                }
                        }
                        //var diffDays = Math.round(Math.abs((firstDate.getTime() - secondDate.getTime())/(oneDay)));
                        /* var diffDays = Math.round((firstDate.getTime() - secondDate.getTime())/(oneDay));
                        if(diffDays < 0){
                            diffDays = 0;
                        }
                        else{
                            diffDays = diffDays+1;
                        }
                        if(intrFlag == true){
                            
                            component.set("v.days", diffDays);
                        }
                        */
                        var orderItemList = component.get("v.orderItemList");
                        for (var idx = 0; idx < orderItemList.length; idx++) {
                            if(idx==rowIndex){
                                orderItemList[idx].days = component.get("v.days");
                                break;
                            }
                        }
                        component.set("v.orderItemList", orderItemList);
                        
                        //console.log('diffDays'+diffDays);
                        if(diffDays > 365){                           
            errorMessage =
              $A.get("$Label.c.Date_of_FAT_greater_than_360") + ": " + diffDays;
                            target.set("v.errors", [{message: errorMessage}]);
                            target.set("v.value","");  
                            flag = false;
                            // console.log('Date_of_FAT_greater_than_360');
          } else {
                            target.set("v.errors", null);    
                            //target.set("v.errors", [{message:""}]);    
                        }
                        
                        //Change request added by ganesh 
                        //Date:17/10/2018
                        //desc:validate FAT if payment term is INFORMAR VENCIMENTO
                        if(selectedPaymentTerm.includes("BR71 INFORMAR VENCIMENTO")){
                            if(secondDate > firstDate){
              errorMessage = $A.get(
                "$Label.c.Dat_of_Fat_not_be_greater_than_Maturity_Date"
              );
                                target.set("v.errors", [{message:errorMessage}]);
                                
                                // target.set("v.errors", [{message: $A.get("$Label.c.Dat_of_Fat_not_be_greater_than_Maturity_Date")}]);
                                //console.log($A.get("$Label.c.Dat_of_Fat_not_be_greater_than_Maturity_Date"));
                                target.set("v.value","");  
                                $A.util.addClass(target, "error");
                                flag = false;
                            } else{
                                //target.set("v.errors", null); // PC-this is overriding the error message set for 365 days.
                                target.set("v.errors", errorMessage); 
                                $A.util.removeClass(target, "error");
                            }
                        }
                        //End patch
                        
                        // by Nik.... on 16/03/2019
          if (smplCmp == "Simple") {
                            //alert(selectedPaymentTermDT);
                            
                            if(selectedPaymentTermDT=="BR71 INFORMAR VENCIMENTO"){
                                if(secondDate > firstDate){
                errorMessage = $A.get(
                  "$Label.c.Dat_of_Fat_not_be_greater_than_Maturity_Date"
                );
                                    target.set("v.errors", [{message:errorMessage}]);
                                    
                                    // target.set("v.errors", [{message: $A.get("$Label.c.Dat_of_Fat_not_be_greater_than_Maturity_Date")}]);
                                    //console.log($A.get("$Label.c.Dat_of_Fat_not_be_greater_than_Maturity_Date"));
                                    target.set("v.value","");  
                                    $A.util.addClass(target, "error");
                                    flag = false;
              } else {
                //Added by Vivek on 03/11/2021 for P1 Order Issue Fix
                var diffDays = Math.round(
                  (firstDate.getTime() - secondDate.getTime()) / oneDay
                );
                                    if(diffDays < 0){
                                        diffDays = 0;
                } else {
                                        diffDays = diffDays+1;
                                    }
                                    if(diffDays > 365){
                  errorMessage =
                    $A.get("$Label.c.Date_of_FAT_greater_than_360") +
                    ": " +
                    diffDays;
                                        target.set("v.errors", [{message: errorMessage}]);
                                        target.set("v.value","");  
                                        flag = false;
                  console.log("Date_of_FAT_greater_than_360");
                                    }// End Vivek P1 Order Issue Fix
                                    else{
                                        target.set("v.errors", null); // PC-this is overriding the error message set for 365 days.
                                        target.set("v.errors", errorMessage); 
                                        $A.util.removeClass(target, "error");
                                    }
                                }
                            }
                        }
        } else {
                        //Set Error
                        target.set("v.errors", null);  
                    }
                    //Modified by Deeksha for kit selling Project
                    var kitOrder = component.get("v.newSalesOrder.Kit_Order__c");
                    var orderItemList = component.get("v.orderItemList");
                    for (var idx = 0; idx < orderItemList.length; idx++) {
          if (
            orderItemList[idx].refKitNo == orderItemList[rowIndex].kitNo &&
            kitOrder
          ) {
                            orderItemList[idx].days = component.get("v.days");
                            orderItemList[idx].fatDate = selectedDate;
                        }
                    }
                    component.set("v.orderItemList", orderItemList);
                    component.set("v.isValidFAT",flag);
                }
        }    
    },
    
    // Create sales order on Save as Draft/ Submit button. 
    // 1. Order Status = Draft when Order saved using Save as Draft 
    // 2. Order Status = Submitted when Order saved using Submit button
    saveFormAsDraft : function(component, event, helper) { 
        var status = "";	
        var isDraft = component.get("v.isDraft");
        // console.log('isDraft'+isDraft);
        if(isDraft == false){
      status = "Submitted";
    } else {
            status = "Draft";
        }
        console.log('1263-------------------------------------->');
        helper.validateSOCServer(component, event, status, false);
        //helper.createSalesOrder(component, event, status, false);
    },
    
    //Logic to show confirmation dialog with Simulation Flag & Message on Save and Submit.
    openConfirmDialog : function(component, event, helper) {
        var selected = event.getSource().get("v.label");
        var isSimulated = component.get("v.isSimulated");
        var priceList = component.get("v.priceDetailList");
        let orderItemList = component.get("v.orderItemList");
        
        var pronu = component.get("v.newSalesOrder.Pronutiva__c");
        var currency = component.get("v.currencyType");
        var orderType = component.get("v.newSalesOrder.Campaign_Type__c");
        var ordertypeval = component.get("v.orderType");
        var minval;
        var maxdisc;
        
        var PriceBook = component.find("SelectPB").get("v.value");
        var avec= component.get("v.newSalesOrder.AVEC_Order__c");
    if (PriceBook == "AVEC / Descontinuados Price Book") {
      //Modified by Harit@wipro
            component.set("v.newSalesOrder.AVEC_Order__c",true);
            component.set("v.newSalesOrder.Directed_Sales__c",true);
    } else {
            component.set("v.newSalesOrder.AVEC_Order__c",false);
        }        // Added by Aditya for DDS Score																							
        var ischild1 = component.get("v.isChild");
        var profileName = component.get("v.user.Profile.Name");  
        // alert(component.get("v.newSalesOrder.Maturity_Date__c"));
        var count=0;
        var count2=0;
        
        if(pronu == true){
            for(var i=0;i<orderItemList.length;i++){
                var cat =orderItemList[i].skuCategory;
        if (cat == "BIOLOGICALS & NUTRITION") {
                    count=count+1;
        } else {
                    count2=count2+1; 
                } 
            }
    } else {
            count=1;
            count2=1;
        }
        // // Added by Aditya for DDS Score
        
        var isDeal = true;
        if(profileName!="Brazil Barter Manager" && !isSimulated){
            for(var i=0;i<orderItemList.length;i++){
        if (
          orderItemList[i].Recommendedprice === undefined ||
          orderItemList[i].DDSGrade === undefined ||
          orderItemList[i].DDSGrade === "No Grade as deal price min price"
        ) {
                    isDeal = false; // Added by GRZ(Nikhil Verma) 27-02-2023 to bypass DDS field for order saving
                }
            }
        }
        
        if(isDeal == false && ischild1 == false){
            var toastEvent = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.Deal_Scoring_Validation_Error}");
            var titl  = $A.get("{!$Label.c.Deal_Scoring}");
            toastEvent.setParams({
        title: titl,
        type: "error",
        message: msg,
        duration: "3000",
            });
            toastEvent.fire();
            return;
        }
        
            //BELOW 80 LINES ADDED BY HARSHITANDANMOL@WIPRO FOR (Phase 2-US IU-001) ---START

            var flag3 = false;
            var flag4 = false;
            var flag5 = false;
            var flag6 = false;
             var newSO = component.get("v.newSalesOrder");
            console.log('New Sales Order: '+JSON.stringify(newSO));
             var orderItemList1 = component.get("v.orderItemList");
             console.log("Line Items: "+JSON.stringify(component.get("v.orderItemList")));
    
             var newSalesOrder1= component.get("v.inventory"); 
             var names;
    
    
             for (var idx=0; idx < orderItemList1.length; idx++) {     
                        for(var i = 0; i < newSalesOrder1.length; i++){
                            //var replc = priceDetailList1[i].materialPlnRplcCost;
                            var active = newSalesOrder1[i].inventoryactive;
                            
                            var blockalert = newSalesOrder1[i].inventoryblockalert;
                            
                            
                            if(orderItemList1[idx].brand==newSalesOrder1[i].productname){
                           // var quantity = newSalesOrder1[newSalesOrder1.length - 1].totalqty;
                           // }
                           // else{
                                                   console.log('newSalesOrder1',newSalesOrder1[i]);
    
                            var quantity = newSalesOrder1[i].qty;
    
                            }
                            console.log('Inve quantity',quantity);
                            console.log('orderItemList[idx].qty',orderItemList1[idx].qty);
                            //var y = String.valueOf(orderItemList[idx].fatDate.getYear());
                            var d = new Date(orderItemList1[idx].fatDate);
                            var d1 = new Date(newSalesOrder1[i].year);
                            var d2 = new Date(newSalesOrder1[i].year1);
    
                            
                            console.log('d***********',d);
                            console.log('d1***********',d1);
                            console.log('d2***********',d2);
    
                            
         
    
                            //d = orderItemList[idx].fatDate;
                           // let year = d.getFullYear();
                            //let textyear = year.toString();
                            console.log('fat date >>>>',orderItemList1[idx].fatDate);
                            console.log('newSalesOrder1[i].year',newSalesOrder1[i].year);
                             console.log('newSalesOrder1[i].year1',newSalesOrder1[i].year1)
                            
                            
                            
                            
                            if(d1 <= d && d <= d2 ){
                                flag5 = true;
                                console.log('1st if');
                                
                            }else{
                                flag5= false;
                            }
                            
                
                            
                            if(active== true && blockalert=='Block' && quantity < orderItemList1[idx].qty && orderItemList1[idx].brand==newSalesOrder1[i].productname && flag5 ){
                                
                                
                            console.log('active',active);
                            console.log('blockalert',blockalert);
                            console.log('quantity',quantity);
                            console.log('orderItemList1[idx].qty',orderItemList1[idx].qty);
                            console.log('orderItemList1[idx].brand',orderItemList1[idx].brand);
                            console.log('newSalesOrder1[i].productname',newSalesOrder1[i].productname);
                            console.log('flag5',flag5);
                            names = orderItemList1[idx].brand;     
                          //alert('Quantity added is exceeding the Balance Inventory.');
                             console.log('inside if');
                                //component.set("v.flag3",true);
                                flag3=true;
                                console.log('flag3******',flag3);
                                
                               
                                
                            }
                            else if(active== true && blockalert=='Alert' && quantity < orderItemList1[idx].qty && orderItemList1[idx].brand==newSalesOrder1[i].productname && flag5){
                               names = orderItemList1[idx].brand;
                                flag4=true;
                            }
                            console.log(active,blockalert,quantity,orderItemList1[idx].qty,orderItemList1[idx].brand,newSalesOrder1[i].productname);
                             if(flag3==false && flag5==true && orderItemList1[idx].brand==newSalesOrder1[i].productname ){
                                break;
                            }
                            
                            
                            
                        }
                    }
            if(flag3==true && !isSimulated){
         
                              var toastEvent = $A.get("e.force:showToast");
                               var msg  = names + ' ' + $A.get("{!$Label.c.Quantity_Exceeded}");
                                var titl  =  $A.get("{!$Label.c.Quantity_Exceeded_title}");
                                toastEvent.setParams({
                                    "title": titl,
                                    "type": "error",
                                    "message": msg,
                                    "duration":'3000'
                                });
                                toastEvent.fire();
                                return;
            }
            
            
            
            if(flag4==true && !isSimulated){
                               var toastEvent = $A.get("e.force:showToast");
                                var msg  = names + ' ' + $A.get("{!$Label.c.Quantity_Exceeded}");
                                var titl  =  $A.get("{!$Label.c.Quantity_Exceeded_title}");
                                toastEvent.setParams({
                                    "title": titl,
                                    "type": "error",
                                    "message": msg,
                                    "duration":'3000'
                                });
                                toastEvent.fire();
                                
            }
            
             if(flag5==false && ordertypeval!="ORDEM FILHA" && !isSimulated){
                                var toastEvent = $A.get("e.force:showToast");
                                var msg  = $A.get("{!$Label.c.Inventory_year}");
                                var titl  = $A.get("{!$Label.c.year_title}");
                                toastEvent.setParams({
                                    "title": titl,
                                    "type": "error",
                                    "message": msg,
                                    "duration":'3000'
                                });
                                toastEvent.fire();
                                return;
            }
            //---END
            
            
        if(count > 0 && count2 > 0){
            var flag = false;
            var totalVal = component.get("v.totalValue");
            var Discount = 0;
            let CF = component.get("v.ConversionFactorValue");
      let pricebookCurrency =
        component.get("v.priceDetailList")[0].currencyCode;
      console.log(
        "test code: " + JSON.stringify(component.get("v.priceDetailList"))
      );
            if(pricebookCurrency=="Only BRL"){
                minval = component.get("v.minValue");
      } else {
                minval = component.get("v.minValueUSD");
                //console.log(listval);
            }
            var maxdisc = component.get("v.maxDiscount");
            
      var fixDate = new Date("2019-04-01").toISOString().split("T")[0];
            console.log(fixDate);
            //var accid = component.get("v.newSalesOrder.Sold_to_Party__c");
            
            /*var action = component.get("c.getCustomerConversionFactor");
            console.log("Checking 1");
            action.setParams({
                "AccountId": accid
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                var result = response.getReturnValue();
                if (state === "SUCCESS") 
                {              
                    CF=response.getReturnValue();
                }
            });
            $A.enqueueAction(action); */
            console.log("CF "+CF);//bnn
            console.log(component.get("v.createdDatePB"));
      if (
        (ordertypeval == "VENDA NORMAL" ||
          ordertypeval == "BONIFICAÇÃO" ||
          ordertypeval == "CONTRATO MÃE") &&
        !avec
      ) {
                console.log("min max: "+minval+" "+maxdisc);
                console.log(JSON.stringify(orderItemList));
        if (orderType == "Structured") {
                    Discount = component.get("v.newSalesOrder.Total_Group_Discount__c");
                    if(totalVal<minval&&Discount>maxdisc){
                        flag = true;
                        //break;
                    }
        } else {
                    for(var i=0;i<orderItemList.length;i++){
                        Discount =0;
            var crtDate = new Date(component.get("v.createdDatePB"))
              .toISOString()
              .split("T")[0];
            console.log(
              "unit value USD/BRL " +
                orderItemList[i].listValue +
                " " +
                orderItemList[i].unitValueWithInterest
            );
                        console.log(crtDate+" vs "+fixDate);
                        var tempDiscount = 0;
                        if(crtDate > fixDate) {
                            console.log("inside greater");
              tempDiscount =
                (100 -
                  ((orderItemList[i].unitValueWithInterest * 100) /
                    (orderItemList[i].listValue *  orderItemList[i].conversionFactor ))) /
                100;
                            //console.log("ListVal: "+listval+", tempDiscount: "+tempDiscount);
                            if(tempDiscount < 0){
                                Discount = 0;
              } else {
                                Discount = tempDiscount*100;
                            }
            } else {
                            console.log("inside lesser");
              tempDiscount =
                (100 -
                  ((orderItemList[i].unitValueWithInterest * 100) /
                    (orderItemList[i].unitValue * orderItemList[i].conversionFactor))) /
                100;
                            if(tempDiscount < 0){
                                Discount = 0;
              } else {
                                Discount = tempDiscount*100;
                            }
                        }
                        
                        console.log("Discount = "+Discount+", totalVal = "+totalVal);
                        if(totalVal<minval&&Discount>maxdisc){
                            flag = true;
                            break;
                        }
                    }
                }
            }
            if(!flag){
                if(isSimulated){
                    console.log('1588----------------------------->');
                    //helper.createSalesOrder(component, event, "Draft" , true); 
                    helper.validateSOCServer(component, event, "Draft", true);
        } else if (!isSimulated) {
                    // console.log('selected confirm dialog: '+selected);
                    //console.log('Submit: '+$A.get("$Label.c.Submit"));
          if (
            selected == $A.get("$Label.c.Save") ||
            selected == $A.get("$Label.c.Submit")
          ) {
              console.log('1597--------------------------------->'+isSimulated);
              
                        component.set("v.isDraft", false);
                        //helper.createSalesOrder(component, event, "Submitted" , true);
                        helper.validateSOCServer(component, event, "Submitted", true);								 
          } else {
              console.log('1602--------------------------->');
                        component.set("v.isDraft", true);							
                        //helper.createSalesOrder(component, event, "Draft" , true);  
                        helper.validateSOCServer(component, event, "Draft", true);
                    }
                }
      } else {
            /***** GRZ(Nikhil Verma) INC0399208 14-10-2022****/
                var toastMsg  = $A.get("{!$Label.c.MinVal_and_MaxDisc}");
                var titl  = $A.get("{!$Label.c.Error}");
                helper.genericToast(component, event,titl, toastMsg);
            /***** End------------ INC0399208 GRZ(Nikhil Verma) 14-10-2022****/				  
            }
    } else {
           /***** GRZ(Nikhil Verma) INC0399208 14-10-2022****/
                var toastMsg  = $A.get("{!$Label.c.If_Pronutiva_Yes_Then_Check_Category}");
                var titl  = $A.get("{!$Label.c.Error}");
                helper.genericToast(component, event,titl, toastMsg);
            /***** End------------ INC0399208 GRZ(Nikhil Verma) 14-10-2022****/
        }
        //BELOW LINES ADDED BY HARSHIT@WIPRO FOR (Phase 2-US SO-002) ---START
        
        // helper.childMarginCal(component, event, helper);
        var action = component.get("c.ChildReplacementMargin");
        var newSO1 = component.get("v.newSalesOrder");
        var orderItemList1 = component.get("v.orderItemList");
        console.log("orderItemList",JSON.stringify(orderItemList));
        
        action.setParams({
            "soObj": newSO1,
            "salesOrderItemString": JSON.stringify(orderItemList1)
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            console.log('childstate',state);
            if (state == "SUCCESS") {
                console.log('inside success');
                component.set("v.totalChildMargin",a.getReturnValue());
                console.log('**childMarginCal : ',component.get("v.totalChildMargin"));
                
                
                
                var MotherorderItemList=component.get("v.MotherorderItemList");
                var ChildorderItemList=component.get("v.orderItemList");
                
                
                console.log('MotherorderItemList*',JSON.stringify(MotherorderItemList));
                console.log('ChildorderItemList*',JSON.stringify(ChildorderItemList));
                
                
                if(ordertypeval=="ORDEM FILHA"){
                    
                    var totalMargin=component.get("v.totalChildMargin");
                    //component.set("v.newSalesOrder.SalesOrderReplacementMargin__c",totalMargin);
                                        
                    console.log('totalMargin*',totalMargin);
                    
                    var flag2 = false;
                    
                    var motherreplacementMargin = [];
                    var names1 = [];
                    var names2 = [];
                    var MoProduct = [];
                    var flagmother = false;
                    for (var idx=0; idx < ChildorderItemList.length; idx++) { 
                        MoProduct.push(ChildorderItemList[idx].productName);
                        
                    } 
                    console.log('MoProduct',MoProduct);
                         
                            
                        for(var i = 0; i < MotherorderItemList.length; i++){    
                            console.log('inside for',MotherorderItemList[i].productName);
                            if(!MoProduct.includes(MotherorderItemList[i].productName)){
                                flagmother = true;
                                break;
                            }
                        }
                    console.log('flagmother',flagmother);
                        
                            
                    // for(var i=0;i<MotherorderItemList.length;i++){
                    if(flagmother){
                    for (var idx=0; idx < MotherorderItemList.length; idx++) {     
                        for(var i = 0; i < ChildorderItemList.length; i++){
                            
                            names1[i] =MotherorderItemList[idx].brand;
                                
                                motherreplacementMargin[idx] = MotherorderItemList[idx].replacementMarginUP;
                                console.log('chMar***',motherreplacementMargin[idx]);    
                                
                                //console.log('orderItemList[i]******',JSON.stringify(MotherorderItemList[idx]));
                                //console.log('childMargin',childMargin);
                            
                                if(MotherorderItemList[idx].productName==ChildorderItemList[i].productName){
                                    
                                    break;
                            
                                 }else if(motherreplacementMargin[idx] < totalMargin){
                                    names2.push(MotherorderItemList[idx].brand);
                                    
                                    console.log('childMargin***',motherreplacementMargin[idx]);
                                    flag2=true;
                                    
                                    
                                //    component.set("v.names1",names1[i]);
                                    
                                    /*var toastEvent = $A.get("e.force:showToast");
                                    var msg  = names1 + ' ' +$A.get("{!$Label.c.Replacement_Margin_is_less}");
                                    var titl  = $A.get("{!$Label.c.Product_Margin1}");
                                    toastEvent.setParams({
                                        "title": titl,
                                        "type": "error",
                                        "message": msg,
                                        "duration":'3000'
                                    });
                                    toastEvent.fire();*/
                                    
                                }
                         // }
                        }
                        
                        
                    }
                     console.log('names1',names1)
					var marginlessproducts = names2.join(' , ');
                        console.log('marginlessproducts*******'+marginlessproducts);
                         component.set("v.names1",marginlessproducts);
                    }
                }
            
            }
            else{
                console.log('TestResError**',a.getError());     
            }
        });
        $A.enqueueAction(action);
        
       //---END

		
		
        
    },
    
    //Logic to hide all selection modals    
    closeConfirmDialog : function(component, event, helper) {
        helper.toggleConfirmDialog(component);
    }, 
        
    closeConfirmDialogDDS: function(component, event, helper) {
         var dialog = component.find("confirmDialog");
        $A.util.toggleClass(dialog, "slds-hide");

        var backdrop3 = component.find("backdrop3");
        $A.util.toggleClass(backdrop3, "slds-hide");
        
        
         var orderItemListDDs = component.get("v.orderItemListDDSRecal");
        component.set("v.orderItemList",orderItemListDDs);
        //component.set("v.orderItemListDDSRecal",a.getReturnValue());

    }, 
        
    //Logic to redirect user after the record is Saved as per Logged In  user Profile.    
    closeOKDialog: function(component,event,helper){
        helper.toggleConfirmDialog(component);
        
        //var flagIm = component.get("v.isflagGreen");
        var orderStatus = component.get("v.newSalesOrder.Order_Status__c");
        //console.log('flagIm: '+flagIm);
        //console.log('orderStatus: '+orderStatus);
        
        if(orderStatus!= "Draft"){
            var profileName = component.get("v.orderFields.userObj.Profile.Name");
      var fullUrl = "";
      var defType = "";
            
      if (profileName == "Brazil Sales Person") {
        defType = "approved";
                fullUrl = "/apex/BrazilEnhancedListForSP?defType="+defType;
                helper.gotoURL(component,fullUrl);
      } else if (profileName == "Brazil Sales District Manager") {
        defType = "approved";
                fullUrl = "/apex/BrazilEnhancedListForSDM?defType="+defType;
                helper.gotoURL(component,fullUrl);
      } else if (profileName == "Brazil Sales Office Manager") {
        defType = "approved";
                    fullUrl = "/apex/BrazilEnhancedListForSOM?defType="+defType;
                    helper.gotoURL(component,fullUrl);
                }               
        }
        //End
    },
    
    // Method use to enable Editing of Order Form using 'Edit' button 
    // Enabled when order status is 'Draft/Rejected'
    editForm:function(component){
        component.set("v.disableThis", false);
        component.set("v.disableSelect", false);
        component.set("v.disableEdit", true);
        
        component.set("v.isEdit", true); //......nik..        
        var isSimulated = component.get("v.isSimulated");
        
        if(isSimulated){
            component.set("v.headerMsg", $A.get("$Label.c.Edit_Simulation_Order")); 
    } else {
            component.set("v.headerMsg", $A.get("$Label.c.Edit_Order"));
        }
    },
    
    removeValidationError: function(component,event){
        //Modified by Deeksha for kit selling Project
        var target = event.getSource(); 
        var rowIndex = event.getSource().get("v.label");
        var cultDesc = component.find("cultureDescOptions");
        var orderItemList = component.get("v.orderItemList");
        for (var idxy = 0; idxy< orderItemList.length; idxy++) {
            if(orderItemList[rowIndex].kitNo == orderItemList[idxy].refKitNo){
                orderItemList[idxy].cultureDesc = orderItemList[rowIndex].cultureDesc;
            }
        }
        component.set("v.orderItemList",orderItemList);
        var target = event.getSource(); 
        var rowIndex = event.getSource().get("v.label");
        var cultDesc = component.find("cultureDescOptions");
    if (target.get("v.value") != null && target.get("v.value") != "None") {
            //target.set("v.errors",null);//Modified by Deeksha for kit selling Project
        } 
        //Modified by Deeksha for kit selling Project
        else{
            if(cultDesc){
                if(cultDesc.length){
          cultDesc[rowIndex].set("v.validity", {
            valid: false,
            valueMissing: true,
          });
          cultDesc[rowIndex].set(
            "v.messageWhenValueMissing",
            $A.get("$Label.c.Culture_is_required")
          );
                    cultDesc[rowIndex].showHelpMessageIfInvalid();
        } else {
                    cultDesc.set("v.validity",{valid:false,valueMissing:true});
          cultDesc.set(
            "v.messageWhenValueMissing",
            $A.get("$Label.c.Culture_is_required")
          );
                    cultDesc.showHelpMessageIfInvalid();
                }
            }
        }
    },
    
    // Method uses Prototype to replace Portuguese characters from the Input String against a pre-defined Map of characters and replaces them
    // Make sure space bar is hit after the input in the text area
    // Works even if input is pasted in the TextArea
    validateInvoiceMessage  : function(component) {
    var input = component.get("v.newSalesOrder.Invoice_Message__c");
    var result = input.normalize("NFD").replace(/[\u0300-\u036f]/g, "");
    component.set("v.newSalesOrder.Invoice_Message__c", result);
        console.log("**Converted string - "+ result);
        
        //Commented by Priya for RITM0222939 as String.prototype function is no longer supported
        /*  var languageMap = component.get("v.languageMap");
        
        String.prototype.portuguese=function(){
            return this.replace(/[^A-Za-z0-9\[\] ]/g,
                                function(a){
                                    return languageMap.portuguese_map[a]||a}
                               )
        };
        
        String.prototype.portugueze = String.prototype.portuguese;
        
        //Not In Use : (FYI - Can be used to check if input contains portuguese alphabets)
        String.prototype.isPortuguese=function(){
            return this == this.portuguese()
        }
        //End
        
        //console.log(inp.portugueze()); 
        component.set('v.newSalesOrder.Invoice_Message__c', input.portugueze());  */
    },
    
    // Method used to Download SalesOrder PDF (Calls visualforce page)
    renderedPDF:function(component, event, helper){
    var recordId = component.get("v.recordId");
    window.open("/apex/SalesOrderPDF?id1=" + recordId);
    },
    
    // Event used to get selected row from 'Lightning Data Table' Component (Used for Account/SOM/Product)
    tabActionClicked: function(component, event, helper){
        //get the id of the action being fired
        var pbid1=component.get("v.pbid");
    var actionId = event.getParam("actionId");
        var isBraziluser = component.get("v.isbraziluser");
        console.log(actionId  + " actionId");
        // alert(actionId  + " actionId");
    var isrelce = "false";
        
        //get the row where click happened and its position
        //var rowIdx = event.getParam("index");
        var profileName = component.get("v.orderFields.userObj.Profile.Name");
        
        //BELOW 20 LINES ADDED BY HARSHIT@WIPRO FOR (US MPO-002) ---START
        var priceDetailList1 = component.get("v.priceDetailList");
        // var replc = priceDetailList1.materialPlnRplcCost;
        //console.log("replacement cost value is ",replc);
    var itemRow = event.getParam("row");
        var prodid= itemRow.skuId;
    console.log("prodid**", prodid);
    console.log("priceDetailList1***", priceDetailList1);
        
        for(var i = 0; i < priceDetailList1.length; i++){
            if(prodid == priceDetailList1[i].skuId){
                var replc = priceDetailList1[i].materialPlnRplcCost;
                if(replc <= 0){
          isrelce = "true";
          console.log("isrelce***", replc);
                    //alert('replacement cost is 0');
                    
                    /***** GRZ(Nikhil Verma) INC0399208 14-10-2022****/
                    var toastMsg  = $A.get("$Label.c.Replacement_Cost_Validation_Error");
                    var titl  = "Custo Indisponível";
                    helper.genericToast(component, event,titl, toastMsg);
                    /***** End------------ INC0399208 GRZ(Nikhil Verma) 14-10-2022****/
                    
                    return;
                }
            }
        }		
        
        var ordercustomer =component.get("v.ordercustomer11");							 
        
        helper.cropculvalues(component,ordercustomer,pbid1);					  
        //alert(JSON.stringify(itemRow));
        var selCurrncy = component.get("v.selectedCurrency");
        console.log(selCurrncy + "selCurrncy");
        //alert(selCurrncy);
        var isChecked= component.get("v.CampaignCheck");
        //updated By Prashant
        var unitVal = 0;
        var minVal = 0;
        var fSPVal =0;
        var monthlyInterestRate = 0;
    if (selCurrncy == "Billing BRL / Payment BRL") {
            //alert(itemRow.unitValueBRL);
            unitVal = itemRow.unitValueBRL;
            minVal = itemRow.minValueBRL;
            monthlyInterestRate = itemRow.monthlyInterestRateBRL;
            //  alert(itemRow.budgetValueBRL);
            fSPVal = itemRow.budgetValueBRL;
    } 
    else if (selCurrncy == "Billing USD / Payment BRL" || selCurrncy == "Billing USD / Payment USD") {
                //alert(itemRow.unitValueUSD);
                unitVal = itemRow.unitValueUSD;
                minVal = itemRow.minValueUSD;
                monthlyInterestRate = itemRow.monthlyInterestRateUSD;
                fSPVal = itemRow.budgetValueUSD;
            }
        //updated By Prashant
    if (actionId == "selectaccount") {
            component.set("v.selItem",itemRow);
            //Assign accountId to Sales Order record attribute
            component.set("v.newSalesOrder.Sold_to_Party__c", itemRow.Id);
      component.set(
        "v.newSalesOrder.Program_Margin_Discount__c",
        itemRow.Program_Margin_Discount__c
      );
            
            // alert(component.get("v.campaignId"));
            //component.set("v.isClicked",false);
            helper.closePopUp(component);
            helper.fetchPriceBookDetails(component);
            //-----------Added on 3/6/2021 for SCTASK0488718--------------
      helper.getCustomerConversionFactor(component, itemRow.Id, itemRow.skuDescription);
            var customerName = component.find("customerName");
            customerName.set("v.errors",null);
            $A.util.removeClass(customerName, "error");
            
            // window.setTimeout(
            //  $A.getCallback(function() {component.find("itemShip").set("v.disabled", false);}), 2000 );
            
            //var action = component.get("c.closePopUp");
            //$A.enqueueAction(action);
        }
        //updated By Prashant
    else if (actionId == "selectshiptoparty") {
            component.set("v.selItem5",itemRow);
            component.set("v.newSalesOrder.Ship_To_Party__c", itemRow.Id);
            var shipLoc = component.find("itemShipToParty");
            shipLoc.set("v.errors",null);
            $A.util.removeClass(shipLoc, "error");
            helper.closePopUp(component);
        }
        //updated By Prashant
    else if (actionId == "selectproduct") {
                var rowIndex = component.get("v.rowIndex");
                var selAccount = component.get("v.selItem");
                var id1 = selAccount.Id;
                console.log('id1',id1);
                console.log('selAccount',selAccount);
                var accountState = selAccount.Customer_Region__c;
                var isSoStrctChild = component.get("v.isOrdemFilha");
                var adminMPT = component.get("v.adminMPTParameter");  // SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022......
                //Added on 3/06/2021 for SCTASK0488718
                var conversionfactor = component.get("v.CustomerConversionFactor");
      console.log("itemRow" + JSON.stringify(itemRow));
                var productId;
                var isAvailable = true;
                var mDate = itemRow.minDate;
                var iischild = component.get("v.isChild");    // Added on 25/02/2022 for RITM0318191
                
                var iiboni = component.get("v.isBonification");											   
                var isSimulated = component.get("v.isSimulated");             
                
                console.log('itemRow.ID',itemRow.ID);
                console.log('itemRow.skuDescription',itemRow.skuDescription);
                //BELOW 4 LINES ADDED BY HARSHIT@WIPRO FOR (US SO-005) ---START

                helper.getCustomerConversionFactor(component, id1, itemRow.brand);
                let CF = component.get("v.CustomerConversionFactor");
            	console.log('CF**',JSON.stringify(CF));
                console.log(itemRow.unitValue);
                 //---END
                 //BELOW 35 LINES ADDED BY HARSHITANDANMOL@WIPRO FOR (Phase 2-US IU-001) ---START
                var ordertypeval = component.get("v.orderType");

                var flag3 = true;
                var flag4 = true;
                var skuname = itemRow.brand;
                var skuname1 = itemRow.skuDescription;
                component.set('v.currentProductName',skuname);
                console.log('v.currentProductName ',skuname);
                var orderItemList1 = component.get("v.orderItemList");
                console.log('orderItemList1',orderItemList1);
                var newSalesOrder1= component.get("v.inventory");
                if (component.get('v.inventory').indexOf(skuname) < -1 ){
                    console.log('**8**alert wala flag3******');                  
                }

                console.log('newSalesOrder1',newSalesOrder1);
               // for (var idx=0; idx < orderItemList1.length; idx++) {     
                    for(var i = 0; i < newSalesOrder1.length; i++){
                        console.log('newSalesOrder1[i].productname tab*****',newSalesOrder1[i].productname);
                        //console.log('orderItemList1[idx].productName tab****',orderItemList1[idx].productName);
                        if(newSalesOrder1[i].productname == skuname){
                            flag3=false;
                            if(!flag3){
                                flag4 = false;
                            }
                        }   
                    }
                if(flag4 && ordertypeval!="ORDEM FILHA" && !isSimulated){
                    var toastEvent4 = $A.get("e.force:showToast");
                            var msg  = $A.get("{!$Label.c.product_not_available}");
                            var titl  = $A.get("{!$Label.c.Product_not_available_title}");
                            toastEvent4.setParams({
                                "title": titl,
                                "type": "error",
                                "message": msg,
                                "duration":'3000'
                            });
                            toastEvent4.fire();
                            return;
                }
               // }
               // ---END
                
                
             
                if(itemRow.avail == false && iischild!=true && isSimulated==false){    // add  isSimulated  for RITM0518333 GRZ(Javed Ahmed) 11-04-2023          
                    //component.set("v.isAvailable",false);
        console.log("##Inside availbility console If");
                    isAvailable = false;
                    var toastMsg = $A.get("$Label.c.Brazil_Product_Availability");
                    helper.showErrorToast(component, event, toastMsg);
                }
                
      if (
        (itemRow.balanceQty > 0 && itemRow.isMO == true) ||
        itemRow.isMO == false
      ) {
                    var stateflag = true;
                    var validityflag = true;
        var errorMessage = "";
                    //added by ganesh Date:12/4/2019
                    if(!isSoStrctChild){                                        
          if (itemRow.regState != accountState && !itemRow.kitProduct) {
            //Modified by Deeksha for kit selling Project
                            stateflag = false;
                            /* sforce.one.showToast({
                   "title"     : "Success!",
                        "message":$A.get("$Label.c.Material_without_Registration_Dates_Please_check_with_Customer_Service_team"),
                         "type": "error"
                    });*/
            errorMessage = $A.get(
              "$Label.c.Material_without_Registration_Dates_Please_check_with_Customer_Service_team"
            );
          } else if (!itemRow.isValid && !itemRow.kitProduct) {
            //Modified by Deeksha for kit selling Project
                            validityflag = false;
            errorMessage = $A.get(
              "$Label.c.Registration_date_is_out_of_limit_Please_contact_the_Customer_Service_Team"
            );
                        }
                    }                    
                    
                    if(stateflag && validityflag && isAvailable){
                        //Edit Row function
                        var orderItemList = component.get("v.orderItemList");
                        var getProductId = component.find("itemproduct");
                        var getItemSelId = component.find("itemsel");
                        var isProductArray = Array.isArray(getProductId);
                        
                        for (var idx=0; idx < orderItemList.length; idx++) {
                            if (idx==rowIndex) {
                                //if(orderItemList.length == 1){
                                if(isProductArray){
                                    component.find("itemproduct")[idx].set("v.errors",null);    
              } else {
                                    component.find("itemproduct").set("v.errors",null);
                                }
                                orderItemList[idx].minDate = itemRow.minDate; // priya
                                orderItemList[idx].maxDate = itemRow.maxDate;
                                orderItemList[idx].applyMinPrice = itemRow.applyMinPrice; // Priya RITM0237685
                                //console.log('**maping applyMinPrice ->'+itemRow.applyMinPrice);
                                //orderItemList[idx].kitNo = itemRow.kitNo;//Modified by Deeksha for kit selling Project
                                orderItemList[idx].kitProduct = itemRow.kitProduct;//Modified by Deeksha for kit selling Project
                                orderItemList[idx].productId = itemRow.skuId;
                                orderItemList[idx].productName = itemRow.skuDescription;
                                orderItemList[idx].conversionFactor = itemRow.custconversionfator;
                                orderItemList[idx].skuCategory = itemRow.skuCategory;  // added by Nik....category for Pronotiva..
                                orderItemList[idx].itemCategory = itemRow.itemCategory;//Modified by Deeksha for kit selling Project
                                orderItemList[idx].brand = itemRow.brand;                                 // for CR93......Nik...25/07/2019
                                //alert(itemRow.unitValue);
                                if(itemRow.currencyCode=='Only BRL'){
                                  orderItemList[idx].selloutprice = itemRow.selloutprice;  
                                  }
                                  else{
                                  orderItemList[idx].selloutprice = itemRow.selloutpriceU; 
                                  }
                                orderItemList[idx].unitValue = itemRow.unitValue;//INCTASK0189697 Date: 18.06.2020 Divya Singh
                                
              orderItemList[idx].unitValueWithInterest =
              itemRow.unitValueWithInterest; //INCTASK0189697 Date: 18.06.2020 Divya Singh
              orderItemList[idx].totalValueWithInterest =
              itemRow.totalValueWithInterest; //INCTASK0189697 Date: 18.06.2020 Divya Singh

                                //alert(itemRow.brand);
                                orderItemList[idx].listValue = unitVal;//changed by Prashant
                                // orderItemList[idx].listValue = itemRow.unitValue;
                                if(fSPVal!= null){
                                    orderItemList[idx].budgetValue = fSPVal;
                                    //console.log('itemRow.BudgetValue='+itemRow.budgetValue+'-'+itemRow.unitValue);
                                }
                                //console.log('itemRow.pricebookId'+itemRow.pricebookId);
                                orderItemList[idx].priceBookDetailId = itemRow.pricebookId;
                                //console.log('orderItemList[idx].priceBookDetailId'+ orderItemList[idx].priceBookDetailId);
                                orderItemList[idx].inventory = itemRow.balanceQty;
                                orderItemList[idx].productCode = itemRow.skuCode;
                                orderItemList[idx].multipleOf = itemRow.multipleOf;
                                orderItemList[idx].itemNo = itemRow.itemNo;
                                orderItemList[idx].moItemNo = itemRow.itemNo;
                                orderItemList[idx].isMO = itemRow.isMO;
                                
                                var days = component.get("v.days");
                                orderItemList[idx].days = days;
                                
                                /* ********************************* SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... Start ************************************************ */
                                orderItemList[idx].salesDeductionCost = itemRow.salesDeductionCost;
                                orderItemList[idx].cogsCost = itemRow.cogsCost;
                                orderItemList[idx].blnkt_EndDate = itemRow.blnkt_EndDate;
                                orderItemList[idx].blnkt_StartDate = itemRow.blnkt_StartDate;
                                orderItemList[idx].blnkt_Status = itemRow.blnkt_Status;
                                orderItemList[idx].isBlanket = itemRow.isBlanket;
                                orderItemList[idx].level1Max = adminMPT.level1Max;
                                orderItemList[idx].level1Min = adminMPT.level1Min;
                                orderItemList[idx].level2Max = adminMPT.level2Max;
                                orderItemList[idx].level2Min = adminMPT.level2Min;
                                orderItemList[idx].level3Below = adminMPT.level3Below;
                                orderItemList[idx].approvalLevel = adminMPT.approvalLevel;
                                orderItemList[idx].uom = itemRow.uom;
                                orderItemList[idx].baseUOM = itemRow.uom;
                                orderItemList[idx].e2eCost = itemRow.e2eCost;
                                orderItemList[idx].exchngRate = itemRow.exchangeRate;
                                orderItemList[idx].curncyCode = itemRow.currencyCode;
                                /* ********************************* SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... End ************************************************ */
                                
                                //if condition changed by Nik on 08/11/2019....CR106
                                //profileName=='Brazil Sales Office Manager' || profileName=='Brazil Sales District Manager'
                                
              if(profileName != "Brazil Sales Person") {
                                    orderItemList[idx].materialPlnRplc_Cost = itemRow.materialPlnRplcCost;    // for CR92......Nik...22/07/2019
                                    orderItemList[idx].exchange_Rate = itemRow.exchangeRate;                  // for CR92......Nik...22/07/2019
                                    orderItemList[idx].currency_Code = itemRow.currencyCode;                  // for CR92......Nik...22/07/2019
                                    orderItemList[idx].create_Date = itemRow.create_Dt;                       // for CR92......Nik...22/07/2019
                                    orderItemList[idx].unitValueBRL = itemRow.unitValueBRL;                   // for CR92......Nik...22/07/2019
                                    orderItemList[idx].unitValueUSD = itemRow.unitValueUSD;                   // for CR92......Nik...22/07/2019
                                    orderItemList[idx].unitValue = itemRow.unitValue;                         // for CR92......Nik...22/07/2019
                                    //orderItemList[idx].minValue = minVal*conversionfactor;                                     // for CR92 changes......Nik...27/07/2019
                orderItemList[idx].minValue =
                  minVal * itemRow.custconversionfator; ////Added by Sayan, 20th July, RITM0234559
                                }
                                //if(itemRow.unitValue!=0){
                                if(unitVal != 0){
                                    //console.log(' orderItemList[idx].qty'+ orderItemList[idx].qty);
                                    orderItemList[idx].fatDate = itemRow.fatDate;
                                    //console.log('itemRow.fatDate'+itemRow.fatDate);
                                    //console.log('itemRow.balanceQty'+itemRow.balanceQty);
                                    //orderItemList[idx].qty = itemRow.balanceQty; //commented for RITM0232825
                                    
                                    //orderItemList[idx].unitValue = itemRow.unitValue;
                                    //orderItemList[idx].unitValueWithInterest = itemRow.unitValueWithInterest;
                                    orderItemList[idx].days = itemRow.days;
                if(profileName != "Brazil Sales Office Manager" || profileName != "Brazil Sales District Manager") {
                  // for CR92 changes......Nik...27/07/2019
                                        orderItemList[idx].cultureDesc = itemRow.cultureDesc;
                                    }
                                }
                                //orderItemList[idx].qty = itemRow.qty;
                                
                                //if(days > 0){
                                // monthlyInterestRate = itemRow.monthlyInterestRate;                        
                                orderItemList[idx].days = days;
                                //}
                                
                                var orderType = component.get("v.newSalesOrder.Type_of_Order__c");
                                
                                if(orderType=="ORDEM FILHA"){
                                    orderItemList[idx].minDate = itemRow.minDate;
                                    orderItemList[idx].applyMinPrice = itemRow.applyMinPrice;
                                    orderItemList[idx].orderItemId = itemRow.orderItemId;
                                    //orderItemList[idx].unitValue = unitVal;
                                    //alert(minVal);
                                    orderItemList[idx].unitValue = itemRow.unitValue;
                console.log("Ihe present val 1650");
                orderItemList[idx].unitValueWithInterest =
                  itemRow.unitValueWithInterest;
                                    
                /*
                if(isProductArray){  
                                    component.find("itemsel")[idx].set("v.disabled",true);  
                                }
                                else{
                                    component.find("itemsel").set("v.disabled",true);  
                                }*/
                                    
                                    if(!itemRow.orderItemId) {
                  var toastMsg = "";
                                        toastMsg = $A.get("$Label.c.Order_Item_Id_not_found");
                                        helper.showErrorToast(component, event, toastMsg);
                                    }
                                    
                                    helper.validateOrderItems(component);
              } else {
                                    //orderItemList[idx].minValue =  minVal*conversionfactor; //MinVal calculated with CustomerConversionFactor
                                    // orderItemList[idx].minValue =  itemRow.minValue;
                orderItemList[idx].minValue =
                  minVal * itemRow.custconversionfator; ////Added by Sayan, 20th July, RITM0234559
                if (orderItemList[idx].qty == "0") {
                  orderItemList[idx].qty = "";
                                    }
                                }
                                
                                orderItemList[idx].interestRate = monthlyInterestRate;
                                //component.set("v.priceDetailList", priceDetailList);
                                //Modified by Deeksha for kit selling Project
                                helper.RemoveComponentRow(component,orderItemList[idx].kitNo);
                                
                                for(var i=0;i<itemRow.kitProductPB.length;i++){
                helper.AddComponentRow(
                  component,
                  event,
                  helper,
                  itemRow.kitProductPB[i],
                  selCurrncy,
                  orderItemList[idx].kitNo,
                  fSPVal,
                  profileName,
                  itemRow.skuId
                );
                                }
                                //commented for RITM0232825
                                /* var priceDetailList = component.get("v.priceDetailList");
                                for (var idxy = 0; idxy< priceDetailList.length; idxy++) {
                                    if(priceDetailList[idxy].itemNo == orderItemList[idx].itemNo){
                                        //console.log(' orderItemList[idx].qty-->'+ orderItemList[idx].qty);
                                        priceDetailList[idxy].balanceQty = priceDetailList[idxy].balanceQty - orderItemList[idx].qty;
                                        //console.log(' priceDetailList[idxy].balanceQty-->'+  priceDetailList[idxy].balanceQty);
                                        //priceDetailList[idxy].percUsed = parseFloat(Math.abs((priceDetailList[idxy].balanceQty / priceDetailList[idxy].qty) *100)).toFixed(2);
                                        priceDetailList[idxy].percUsed = Math.abs((priceDetailList[idxy].balanceQty / priceDetailList[idxy].qty) *100);
                                        break;
                                    }
                                }
                                
                                console.log('priceDetailList');
                                console.log(priceDetailList);
                                component.set("v.priceDetailList", priceDetailList);
                                
                                break; */
                            }
                        }
                        
                        //console.log('Calculations called');
                        helper.updateRowCalculations(component, event);
                        
                        //component.set('v.orderItemList', orderItemList);
                        
                        //End function
        } else {
                        var toastMsg = errorMessage;
                        //var toastMsg = 'Selected Product is not Registered in Customer State ('+accountState+').';
                        helper.showErrorToast(component, event, toastMsg);
                    }
                }
                else{
                    var toastMsg = $A.get("$Label.c.Balance_Qty_of_selected_product_is_0");
                    helper.showErrorToast(component, event, toastMsg);
                }
                helper.closePopUp(component);
            }
    else if (actionId == "selectsom") {
                    helper.closePopUp(component);
                    var soName = component.find("soName");
                    //soName.set("v.errors",null);
                    $A.util.removeClass(soName, "error");
                    //component.set("v.selItem3" ,itemRow);  
      console.log("itemRow.Directed_Sales__c" + itemRow.Directed_Sales__c);
                    component.set("v.newSalesOrder.Sales_Order__c", itemRow.Id);
                     //BELOW LINES ADDED BY HARSHIT@WIPRO FOR (Phase 2-US SO-002) ---START
                     var motherorderid = itemRow.Id;
                     var action1 = component.get("c.getSalesOrderItems");
                     action1.setParams({
                         soId: motherorderid
                     });
                     
                     action1.setCallback(this, function(a) {
                         var state = a.getState();
                         if(state == "SUCCESS") {
                             //component.set("v.orderSubStatus", a.getReturnValue());
                             console.log('orderItems: '+JSON.stringify(a.getReturnValue()));
                             component.set("v.MotherorderItemList", a.getReturnValue());
                         }
                         else{
                             //var toastMsg = $A.get("$Label.c.Error_while_reloading_Order_Items");
                             //this.showErrorToast(component, event, toastMsg);                      
                         }
                         console.log('new');
                     });
                     console.log('new');
                     $A.enqueueAction(action1);
                     console.log('new');
                     //END
                     
                     
                    if(itemRow.Directed_Sales__c==true){
                        component.find("dirSaleYes").set("v.value",true);
                        component.find("dirSaleNo").set("v.value",false);
                        component.set("v.newSalesOrder.Directed_Sales__c", true);
                    }else{
                        component.find("dirSaleYes").set("v.value",false);
                        component.find("dirSaleNo").set("v.value",true); 
                        component.set("v.newSalesOrder.Directed_Sales__c", false);
                    } 
      console.log("itemRow" + itemRow.Directed_Sales__c);
                    //...for Simple campaign mother order.....Nik...22/03/2019
                    var PriceBook = component.find("SelectPB").get("v.value");
      console.log("PriceBook**" + PriceBook);

      console.log('itemRow',JSON.stringify(itemRow));
      if(component.get("v.orderType") != 'ORDEM FILHA'){
        if(itemRow.Kit_Price_Book__c == true&&PriceBook=='Price Book for Kit'){
          component.set("v.isKit",true);
      }else{
          component.set("v.isKit",false);
      }
      // above 4 lines are added by Ankita&Krishanu@wipro
      if(PriceBook=='AVEC / Descontinuados Price Book'){ // Updated for INC0389109 GRZ(Dheeraj Sharma) 24-11-2022
          component.set("v.isAvec",true);
      }else{
          component.set("v.isAvec",false);
      }
      if(itemRow.Use_Campaign__c == true&&PriceBook == 'Price Book for Campaign'){
          
          if(itemRow.Campaign_Type__c == 'Simple'){
                                isChecked=true;
                                component.set("v.CampaignCheck",true);
                                //component.find("campChk").set("v.value",true);
                                component.set("v.newSalesOrder.Use_Campaign__c",true);
                                
                                component.set("v.isSimple",true); 
                                component.set("v.isStructure",false);
                                component.find("simpCmp").set("v.value",true);
                                component.set("v.newSalesOrder.Campaign_Type__c","Simple");
                                component.set("v.isOrdemFilha",false);
          } else if (itemRow.Campaign_Type__c == "Structured") {
                                isChecked=true;
                                component.set("v.CampaignCheck",true);
                                //component.find("campChk").set("v.value",true);
                                component.set("v.newSalesOrder.Use_Campaign__c",true);
                                component.set("v.isSimple",false); 
                                component.set("v.isStructure",true);
                                component.find("structCmp").set("v.value",true);
                                component.set("v.newSalesOrder.Campaign_Type__c","Structured");
                                component.set("v.isOrdemFilha",true);
                            }
        } else {
                            isChecked=false;
                            component.set("v.CampaignCheck",false);
                            //component.find("campChk").set("v.value",false);
                            component.set("v.newSalesOrder.Use_Campaign__c",false);
                            component.set("v.isSimple",false); 
                            component.set("v.isStructure",false);
                            //component.find("simpCmp").set("v.value",false);
                            component.set("v.newSalesOrder.Campaign_Type__c","None");
                            component.set("v.isOrdemFilha",false);
                        }
      } else {
        console.log('item.avecorder==>',itemRow.AVEC_Order__c);
                        if(itemRow.AVEC_Order__c == true){
                            component.set("v.isAvec",true);
                        }else{
                            component.set("v.isAvec",false);
                        }
                        if(itemRow.Kit_Price_Book__c == true){
                          component.set("v.isKit",true);
                      }else{
                          component.set("v.isKit",false);
                      }
                      //above 4 lines are added by Ankita&Krishanu@wipro
                        if(itemRow.Use_Campaign__c == true){
                            //component.set("v.campaignId",pbname);
          if (itemRow.Campaign_Type__c == "Simple") {
                                isChecked=true;
                                component.set("v.CampaignCheck",true);
                                //component.find("campChk").set("v.value",true);
                                component.set("v.newSalesOrder.Use_Campaign__c",true);
                                component.set("v.isSimple",true); 
                                component.set("v.isStructure",false);
                                component.find("simpCmp").set("v.value",true);
                                component.set("v.newSalesOrder.Campaign_Type__c","Simple");
                                component.set("v.isOrdemFilha",false);
          } else if (itemRow.Campaign_Type__c == "Structured") {
                                isChecked=true;
                                component.set("v.CampaignCheck",true);
                                //component.find("campChk").set("v.value",true);
                                component.set("v.newSalesOrder.Use_Campaign__c",true);
                                component.set("v.isSimple",false); 
                                component.set("v.isStructure",true);
                                component.find("structCmp").set("v.value",true);
                                component.set("v.newSalesOrder.Campaign_Type__c","Structured");
                                component.set("v.isOrdemFilha",true);
                            }
        } else {
                            //component.set("v.priceBookId",pbname);
                            isChecked=false;
                            component.set("v.CampaignCheck",false);
                            //component.find("campChk").set("v.value",false);
                            component.set("v.newSalesOrder.Use_Campaign__c",false);
                            component.set("v.isSimple",false); 
                            component.set("v.isStructure",false);
                            //component.find("simpCmp").set("v.value",false);
                            component.set("v.newSalesOrder.Campaign_Type__c","None");
                            component.set("v.isOrdemFilha",false);
                        }
                        if(itemRow.Kit_Order__c){
          component.set("v.SelectPriceBook", "Price Book for Kit");
                        }else if(itemRow.Use_Campaign__c){
          component.set("v.SelectPriceBook", "Price Book for Campaign");
                        }else if(itemRow.AVEC_Order__c){
          component.set(
            "v.SelectPriceBook",
            "AVEC / Descontinuados Price Book"
          );
                        }else{
          component.set("v.SelectPriceBook", "Normal Price Book");
                        }
                    }
                    
                    //added by ganesh for structure campaign
                    var orderType = component.get("v.orderType");
                    
                    var srcId= component.get("v.CampaignCheck");
      if (orderType == "ORDEM FILHA") {	
        component.set(	
          "v.newSalesOrder.Business_Discount__c",	
          itemRow.Business_Discount__c	
        ); //for RITM0419745 GRZ(Nikhil Verma) modified date-03-10-2022	
                            }
                    /*  if(orderType == 'ORDEM FILHA'){
                if(srcId){
                    var isStructure = component.find("structCmp").get("v.value");	
                    console.log('isStructure'+isStructure);
                    if(isStructure){ 
                        component.set("v.isOrdemFilha", true); 
                    }else{
                        component.set("v.isOrdemFilha", false);  
                    }}
            }*/
                    //patch end
      component.set("v.selItem3", itemRow);
                    //alert(JSON.stringify(itemRow));
                    //added by ganesh 
                    //desc: to get business rule of chosen SOM 
                    //alert(itemRow.Price_Book__c);
      component.set(
        "v.blockDate",
        itemRow.Price_Book__r.Sales_Order_Block_Date__c
      );
                    component.set("v.interestDate",itemRow.Price_Book__r.Interest_Date__c);
                    if(srcId){
                        component.set("v.campaignId",itemRow.Price_Book__c);  // by nik for simple campaign SOM line items..
      } else {
                        component.set("v.priceBookId",itemRow.Price_Book__c);
                    }
                    component.set("v.newSalesOrder.Price_Book__c",itemRow.Price_Book__c);
                    //console.log('item Row Nik....---> '+JSON.stringify(itemRow));
                    component.set("v.businessRule.Taxes__c", itemRow.Tax__c);
                    component.set("v.businessRule.Freight__c", itemRow.Freight__c);
                    component.set("v.newSalesOrder.Tax__c", itemRow.Tax__c);
                    component.set("v.newSalesOrder.Freight__c", itemRow.Freight__c);
                    
                    var maturityDate = itemRow.Maturity_Date__c;
                    
                    //console.log('**itemRow: '+itemRow);
                    
                    if(maturityDate){
                        component.set("v.isMature" ,"true");
        component.set(
          "v.newSalesOrder.Maturity_Date__c",
          itemRow.Maturity_Date__c
        );
                    }
                    
                    var isSoStrctChild = component.get("v.isOrdemFilha");
                    var punctualityDiscount = itemRow.Punctuality_Discount__c;
                    //alert(isSoStrctChild);
      if (
        punctualityDiscount &&
        punctualityDiscount > 0 &&
        isSoStrctChild != true
      ) {
                        if(!isBraziluser){
                            component.find("descNo").set("v.value",false);
                            component.find("descYes").set("v.value",true);
                        }
                        component.set("v.isPunctual",true);
        component.set(
          "v.newSalesOrder.Punctuality_Discount__c",
          punctualityDiscount
        );
      } else if (!isSoStrctChild) {
                        if(!isBraziluser){
                            component.find("descNo").set("v.value",true);
                            component.find("descYes").set("v.value",false);
                        }
                        component.set("v.isPunctual",false);
        component.set(
          "v.newSalesOrder.Punctuality_Discount__c",
          punctualityDiscount
        );
                    }
                    if(!isSoStrctChild){
                        if(!isBraziluser){
                            component.find("descNo").set("v.disabled",true);
                            component.find("descYes").set("v.disabled",true);
                        }
                        var pcntl=component.get("v.isPunctual");
                        
                        if(pcntl == true){
                            component.find("punctualitydisc").set("v.disabled",true);
                        }
                    }  
                    
                    //Code added by Sagar@Wipro for Bonification order - should not auto fill any field
                    
                    var opts=[];  
                    var showOnReLoad = component.get("v.showOnReLoad");
      if (orderType != "BONIFICAÇÃO" && showOnReLoad == false) {
        opts.push({
          class: "optionClass",
          label: itemRow.Price_Book__r.Name,
          value: itemRow.Price_Book__c,
        });
                    }
      if (orderType == "BONIFICAÇÃO" && showOnReLoad == false) {
                        component.set("v.selectedCurrency", "None"); 
                        component.set("v.paymentMethod", "None"); 
                        component.set("v.paymentTerm", "None"); 
        component.set("v.newSalesOrder.Invoice_Message__c", "");
        component.set("v.newSalesOrder.Internal_OBS__c", "");
        component.set("v.newSalesOrder.Sales_order_OBS__c", "");
        component.set("v.disablePaymentMethod", false);
        component.set("v.disablePriceCurrency", false);
        component.set("v.newSalesOrder.Maturity_Date__c", "");
        component.set("v.newSalesOrder.Program_Margin_Discount__c", "");
        component.set("v.newSalesOrder.Punctuality_Discount__c", "");
        component.set("v.disableThis", false);
                        component.set("v.isMature", "false");
                    }
                    var isAvectemp = component.get("v.isAvec");
                    if(isChecked||isAvectemp){
                        // alert(isChecked);
        if (!isAvectemp) {
                            component.find("Campaign").set("v.options", opts);
        } else {
                            component.find("priceListOptions").set("v.options", opts);
                        }
                        if(itemRow.Payment_Term__c != null){
                            var opts2=[];
          opts2.push({
            class: "optionClass",
            label: itemRow.ReloadPaymentTerms__c,
            value: itemRow.Payment_Term__c,
          });
                            component.find("payTmdy").set("v.options", opts2);
          component.set(
            "v.newSalesOrder.Payment_Term__c",
            itemRow.Payment_Term__c
          );
                            // alert(itemRow.Payment_Term__c);
        } else if (itemRow.Maturity_Date__c != null) {
                            //component.set("v.isMature", "true"); 
                            var opts2=[];
          opts2.push({
            class: "optionClass",
            label: "BR71 INFORMAR VENCIMENTO",
            value: "BR71 INFORMAR VENCIMENTO",
          });
                            component.find("payTmDt").set("v.options", opts2);
        } else {
                                var opts2=[];
          opts2.push({
            class: "optionClass",
            label: itemRow.Campaign_Payment_Term_Date__c,
            value: itemRow.Campaign_Payment_Term_Date__c,
          });
                                component.find("payTmDt").set("v.options", opts2);
                                
          component.set(
            "v.newSalesOrder.Campaign_Payment_Term_Date__c",
            itemRow.Campaign_Payment_Term_Date__c
          );
                            }
      } else {
                        //  alert(isChecked);
                        
                        //alert(JSON.stringify(opts));
                        var opts2=[];
        opts2.push({
          class: "optionClass",
          label: itemRow.ReloadPaymentTerms__c,
          value: itemRow.Payment_Term__c,
        });
        if (orderType == "ORDEM FILHA") {
                            component.find("priceListOptions").set("v.options", opts); 
                        }
                        /*var pmtterms = component.find("paymentTermOptions");
                        if(Array.isArray(pmtterms)){
                            pmtterms[0].set("v.value",opts)
                        }else{
                            pmtterms.set("v.value",opts)
                        }*/
        component
          .find("paymentTermOptions")
          .set("v.value", itemRow.ReloadPaymentTerms__c);
                    }
                    
                    //End
                }   
                console.log('isvaec=>>',component.get("v.isAvec"));             
    },
    
    // Logic to Add Order Line Item 
      addTableRow : function(component, event, helper){
        //conditons added to limit the number of sales order line item being added by user||Gurubaksh Grewal||Grazitti|| RITM0537040||14/04/2023
		var oil=component.get("v.orderItemList");
        var isVal=true;
        var msg1='';
        if(oil && oil.length>0){
            var isSim=component.get("v.isSimulated");
            if(isSim==false&&oil.length>=15){
             isVal=false;
             msg1=$A.get("{!$Label.c.brz}");   
            }
            if(isSim==true&&oil.length>=23){
             isVal=false;
             msg1=$A.get("{!$Label.c.brz_SimError}");   
            }
        }
        
        if(isVal==true){
            
        var isValid = helper.validateOrder(component); 
        var isValidItems = helper.validateOrderItems(component); 
        var isValidTo = component.get("v.isValidTo");
        var isValidFrom = component.get("v.isValidFrom");
        var isValidMaturity = component.get("v.isValidMaturity");
        var isValidInvoice = component.get("v.isValidInvoice");
        var blkDate= component.get("v.blockDate");
        var orderItemList = component.get("v.orderItemList");
        var smplCmp = component.get("v.newSalesOrder.Campaign_Type__c");
        var today = new Date();
    var dd = (today.getDate() < 10 ? "0" : "") + today.getDate();
    var MM = (today.getMonth() + 1 < 10 ? "0" : "") + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        var orderType = component.get("v.newSalesOrder.Type_of_Order__c"); 
        var counter = component.get("v.counter");//Modified by Deeksha for kit selling Project	
        
        // Custom date format for ui:inputDate
    var currentDate = yyyy + "-" + MM + "-" + dd;
        
        //Initialize validation flag to false
        var flag = false;
        var blkFlag= true;
        //Check if order has line items and then check if all inputs are valid before adding new line item
        if(orderItemList.length > 0){
            if(isValid && isValidItems){
                flag = true;
            }
    } else if (isValid) {
            flag = true;
        }
        
        // Set Validation Flag to 'false' if any of the validation returns 'false'
        if(!isValidTo || !isValidFrom || !isValidMaturity || !isValidInvoice){
            flag = false;
        }
        
        //If all validations are successful add new row
        if(flag){
      if (smplCmp == "Simple") {
        if (blkDate != null || blkDate != "") {
                    if(blkDate<currentDate){
                        blkFlag=false;
                        var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.Block_Date_Reached}");
                        var titl  = $A.get("{!$Label.c.Error}");
                        toastEvent.setParams({
              title: titl,
              type: "error",
              message: msg,
                        });
                        toastEvent.fire();
                        component.find("Campaign").focus();
                    }
                }
            }
            
            if(blkFlag == true){
                orderItemList.push({
                    minDate:"",//Priya
                    applyMinPrice:"",
                    productId:"",
                    priceBookDetailId: "", 
                    productName:"", 
                    fatDate:"", 
                    qty:"", 
                    listValue:"0", 
                    unitValue:"", 
                    unitValueWithInterest:"0",
                    totalValue:"0", 
                    totalValueWithInterest:"0",
                    interestRate:"0", 
                    days: "0", 
                    timeInMonths: "0",
                    skuCategory:"",
                    replacementMargin:0,
                    discount:0,
                    brand:"",
                    minValue:0,
                    POItemNumber:"", //Deeksha : added for SCTASK0216504
                    kitProduct:"",//Modified by Deeksha for kit selling Project
                    kitNo: counter,//Modified by Deeksha for kit selling Project
                    refKitNo : -1 ,//Modified by Deeksha for kit selling Project
                    kitSKU :"", //Modified by Deeksha for kit selling Project
                    //cultureDesc:""
                    contMargin:0   // SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.......
                });
                component.set("v.orderItemList",orderItemList);
                counter++;  
                component.set("v.counter",counter);
                helper.enableDisableFields(component, orderItemList.length);
            }
    } else {
      var toastMsg = $A.get(
        "$Label.c.Please_provide_valid_input_fill_all_the_mandatory_fields_before_proceeding"
      );
            helper.showErrorToast(component, event, toastMsg);
        }
    if (orderType != "ORDEM FILHA") {
            // alert(orderType);
            // alert(component.get("v.isChild", false));
            component.set("v.isChild", false);  
        }
        var isPronutiva = component.get("v.newSalesOrder.Pronutiva__c");
    console.log("isPronutiva>>--->" + isPronutiva);
        if(isPronutiva){
            component.find("radio1").set("v.checked",true);
            component.find("radio2").set("v.checked",false);
      console.log(
        "isPronutiva>>--->" + component.find("radio1").get("v.value")
      );
        }else{
            component.find("radio1").set("v.checked",false);
            component.find("radio2").set("v.checked",true); 
        }
        }else{
            helper.showErrorToast(component, event, msg1);
        }
        
    },
    
    // Logic to remove Order Line Item
    removeTableRow : function(component, event, helper){
        var target = event.getSource();  
        var index = target.get("v.value");
        var items = component.get("v.orderItemList");    
        var getQtyId = component.find("itemqty");
        var qty,itemNo;
        var isQuantityArray = Array.isArray(getQtyId);
        
        if(isQuantityArray){
            qty = getQtyId[index].get("v.value");    
            itemNo = getQtyId[index].get("v.requiredIndicatorClass");
    } else {
            qty = getQtyId.get("v.value");
            itemNo = getQtyId.get("v.requiredIndicatorClass");
        }
        
        //changes added by priya for RITM0232825 calculating balance quantity on lineitem removal
        var orderType = component.get("v.newSalesOrder.Type_of_Order__c");
        var orderItemList = component.get("v.orderItemList");
        if(orderType=="ORDEM FILHA"){
            var priceDetailList = component.get("v.priceDetailList");
            
            if(orderItemList.length > 0){
                for (var idxy=0; idxy < orderItemList.length; idxy++) {
                    if (idxy==index)  {
                        for (var idx = 0; idx < priceDetailList.length; idx++) {
                            if(priceDetailList[idx].itemNo == orderItemList[idxy].itemNo){
                priceDetailList[idx].balanceQty =
                  priceDetailList[idx].balanceQty + orderItemList[idxy].qty;
                                //priceDetailList[idx].percUsed = parseFloat((priceDetailList[idx].balanceQty / priceDetailList[idx].qty) *100).toFixed(2);
                priceDetailList[idx].percUsed =
                  (priceDetailList[idx].balanceQty / priceDetailList[idx].qty) *
                  100;
                                
                                break;
                            }
                        }  
                        //orderItemList[idx].inventory= orderItemList[idx].inventory + orderItemList[idx].qty;
                        component.set("v.priceDetailList", priceDetailList);
                    }
                } 
            }
            //component.set("v.priceDetailList", priceDetailList); 
            //console.log('priceDetailList: '+JSON.stringify(priceDetailList));
            //changes end
        }
        var kit = items[index].kitNo;//Modified by Deeksha for kit selling Project
        
        if(index == items.length - 1){
            component.set("v.cultureDescList", null);
            items.splice(index, 1);
      component.set(
        "v.cultureDescList",
        component.get("v.cultureDescListCopy")
      );
    } else {
            items.splice(index, 1);
        }
        
        //console.log('index: '+ index);
        var orderStatus = component.get("v.newSalesOrder.Order_Status__c");
        if(index == 0){
            var recordId = component.get("v.recordId");
            //console.log('recordId: '+recordId); //|| (orderStatus=="Draft" && recordId)
            if(orderStatus!="Draft"){
                helper.fetchPriceBookDetails(component);
            }
            //component.set("v.isValid", false);
            //component.set("v.isValidItems", false);
        }
        
        component.set("v.orderItemList", JSON.parse(JSON.stringify(items)));
        helper.RemoveComponentRow(component,kit);//Modified by Deeksha for kit selling Project
        items = component.get("v.orderItemList");  //Modified by Deeksha for kit selling Project 
        helper.enableDisableFields(component, items.length);
        console.log('removeTableRow');
        helper.updateRowCalculations(component, event);
    },    
    //Logic to store the old value of Qty in to a temporary variable and restore it if the user blanks the Qty in the Line Items
    updateOldBalanceQty : function(component, event, helper) {
        var target = event.getSource();  
        var qty = target.get("v.value");
        component.set("v.oldValueQty", qty);      
    },
          
        //Change by Swaranjeet(Grazitti) APPS-4591 
        updatebarter : function(component, event, helper) {
            
         var target = event.getSource(); 
         console.log('traget--',target);
         var discountValue = target.get("v.value");
         console.log('discountValue--',discountValue);
      	 var freqRow1 = component.get("v.orderItemList");
         console.log('freqRow1-',freqRow1);
             var temp1 = 0, temp2 = 0, discount = 0;
            var gross1 = 0,gross2 = 0,gross3 = 0;
          var salesorderlist = component.get("v.newSalesOrder");
            
            freqRow1.forEach((ele) => {
                if(ele.BarterDiscountPercentage || ele.BarterDiscountPercentage == 0){
                console.log('in if ele.BarterDiscountPercentage--',ele.BarterDiscountPercentage);
                 console.log('ele---',ele);
                 console.log('eele.totalValueWithInterest-',ele.totalValueWithInterest);
                discount = (ele.BarterDiscountPercentage * ele.totalValueWithInterest) / 100;
                console.log('discount---',discount);
                ele.BarterDiscountCalculated = discount;
                
				temp1 = temp1 + ele.totalValueWithInterest;
                console.log('temp1---',temp1);
                temp2 = temp2 + discount;
                console.log('temp2---',temp2);
                
                gross1 = (ele.totalValueWithInterest - ele.BarterDiscountCalculated - ele.taxAmountWithoutInterest - ele.freightAmountWithoutInterest - ele.punctualityDiscountWICalculated - ele.totalReplacementCost1);
                gross2 = (ele.totalValueWithInterest - ele.BarterDiscountCalculated - ele.taxAmountWithoutInterest - ele.punctualityDiscountWICalculated);
              
                console.log('gross1--',gross1);
                console.log('gross2--',gross2);
                gross3 = (gross1 / gross2);
				console.log('gross3---',gross3);
                ele.GrossMarginwithBarter = gross3;
            	
            }
                            
             else{
                       console.log('in else ele.BarterDiscountPercentage--',ele.BarterDiscountPercentage);
                       component.set("v.TotalofDiscountApplied",0); 
            		  
            			
            }
             
            });
			
            var IDss = target.get("v.requiredIndicatorClass");
			console.log('IDss',IDss);
			var Barterpercentagecalculatedmap = component.get("v.Barterpercentagecalculatedmap"); //chng
            Barterpercentagecalculatedmap[IDss] = discount;
			console.log('Barterpercentagecalculatedmap---',JSON.stringify(Barterpercentagecalculatedmap));
			component.set("v.Barterpercentagecalculatedmap",Barterpercentagecalculatedmap);
			var NewGrossMargin = component.get("v.NewGrossMargin"); //chng
            NewGrossMargin[IDss] = gross3;
			console.log('NewGrossMargin---',JSON.stringify(NewGrossMargin));
			component.set("v.NewGrossMargin",NewGrossMargin);
			component.set("v.TotalBarterDiscountSalesorder",temp2);
			var totalbarterss = component.get("v.TotalBarterDiscountSalesorder");
            var temp3 = (temp2 / temp1) * 100;
            console.log('temp3---',temp3);
            component.set("v.TotalofDiscountApplied",temp3);
			var grosssalesorder = (salesorderlist.TotalValueWithoutInterest__c - totalbarterss - salesorderlist.Total_Tax_Without_Interest__c - salesorderlist.Total_Freight_Without_Interest__c - salesorderlist.Total_Punctuality_Without_Interest__c - salesorderlist.TotalReplacementCost__c) / (salesorderlist.TotalValueWithoutInterest__c - totalbarterss - salesorderlist.Total_Tax_Without_Interest__c - salesorderlist.Total_Punctuality_Without_Interest__c);
			console.log('grosssalesorder--',grosssalesorder);
			component.set("v.Grossmarginsalesorder",grosssalesorder);
          	var BarterMap = component.get("v.BarterMap"); //chng
            BarterMap[IDss] = discountValue; 
            component.set("v.BarterMap",BarterMap);  
			 console.log('BarterMap---',JSON.stringify(BarterMap));
			component.set("v.orderItemList",component.get("v.orderItemList"));   
            
         // var businessdisc1 = component.find("businessdisc").get("v.value");
        //   console.log('businessdisc1--',businessdisc1);
       // var financialdisc1 = component.find("financialdisc").get("v.value");
        var priceDetailList1 = component.get("v.priceDetailList");
          console.log('priceDetailList1--',priceDetailList1);
        var pbid1=component.get("v.pbid");
           console.log('pbid1--',pbid1);
        var orderItemList1= component.get("v.orderItemList");
           console.log('orderItemList1--',orderItemList1);
        component.set("v.orderItemListBarter",null);
        component.set("v.barterDiscountValidate",false);
      
        var action = '';
        action = component.get("c.updateBarterLineitem");
                    action.setParams({ 
                        "salesOrderItemString": JSON.stringify(orderItemList1),
                        "pbid1":pbid1,
                        "businessdiscmap": BarterMap
                        
                    }); 
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state---',state);
            console.log('result---',result);
            var result = response.getReturnValue();
            if (state === "SUCCESS") 
            {    
                target.set("v.errors","");
                var barterFlag;
                var orderItemList2 = response.getReturnValue();
                component.set("v.orderItemListBarter",response.getReturnValue()); 
                var orderItemList3= component.get("v.orderItemListBarter"); 
                console.log('response123 - '+JSON.stringify(response.getReturnValue()));
               // console.log('orderItemList2 - '+JSON.stringify(orderItemList2));
                for(var i=0; i< priceDetailList1.length; i++){
                    for(var j=0; j< orderItemList2.length; j++){
                        
                        console.log('priceDetailList1[i].skuDescription - '+priceDetailList1[i].skuDescription);
                        console.log('orderItemList2[j].productName - '+orderItemList2[j].productName);
                        console.log('priceDetailList1[i].minValueBRL - '+priceDetailList1[i].minValueBRL);
                        console.log('orderItemList2[j].unitValue - '+orderItemList2[j].unitValue);
                        if(priceDetailList1[i].skuDescription == orderItemList2[j].productName){
                            if(priceDetailList1[i].currencyCode == 'Only BRL'){
                                //below code added by Sagar for calculating Barter Discount using CustomerConversionFactor
                                console.log('Updated MinValue in PriceBook - '+ (priceDetailList1[i].minValueBRL * orderItemList2[j].CustomerConversionFactor));
                                if((priceDetailList1[i].minValueBRL * orderItemList2[j].CustomerConversionFactor) <= orderItemList2[j].unitValue){
                                    barterFlag = true;
                                    target.set("v.errors","");
                                    console.log('IF - barterFlag - '+barterFlag);
                                    console.log('IF - barterFlag1 - '+barterFlag);
                                    //component.set("v.barterDiscountValidate",true);
                                    
                                    if(component.get("v.barterDiscountValidate")){
                                         console.log('IF - barterFlag - Test111');
                                        target.set("v.errors", [{message: $A.get("$Label.c.Please_reduce_the_Business_Discount")}]); 
                                        component.set("v.barterDiscountValidate1",true);
                                        component.set("v.barterDiscountValidate",true);
                                    }
                                    var isDiscountValidate= component.get("v.barterDiscountValidate")
                                    if(!isDiscountValidate){
                                        console.log('IF - barterFlag - Test');
                                        target.set("v.errors","");
                                        component.set("v.barterDiscountValidate1",false);
                                    }
                                    
                                    //
                                    
                                }
                                else{
                                    barterFlag = false;
                                    console.log('ELSE - barterFlag - 1234'+barterFlag);
                                    component.set("v.barterDiscountValidate1",true);
                                    component.set("v.barterDiscountValidate",true);
                                    console.log('target==>',target);
                                    target.set("v.errors", [{message: $A.get("$Label.c.Please_reduce_the_Business_Discount")}]);
                                    target.set("v.value","");
                                    $A.util.addClass(target, "error");  
                                    
                                }
                            }
               
                        }
                    }
                }
                
            }
        });
            $A.enqueueAction(action);
            
        //Logic to restrict negative value
        if(discountValue==null){
            discountValue = 0;
    } else {
            var discountString = discountValue.toString(); //Convert to string
            discountValue = parseFloat(discountString.replace("-", "")); //Replace negative sign
        }
        
        target.set("v.value",discountValue);
        //End of logic
            
        
         },
    
    // Logic to update current row with calculations
    updateTableRow : function(component, event, helper) {
        // Console.log("In_Controller_Table_Row");
        
        var priceDetailList1 = component.get("v.priceDetailList");
        
    console.log("priceDetailList1***", priceDetailList1);
        
        var target = event.getSource(); 
        var unitValue = target.get("v.value");
        

// Added Below condition by GRZ(Dheeraj Sharma) for RITM0560048 on 25-05-2023
        if(unitValue!=''&&unitValue!=null){
            console.log('unitValueDs',unitValue);
            var orderItemList = component.get("v.orderItemList");
            console.log('orderItemList'+JSON.stringify(orderItemList));
            for(var i=0;i<orderItemList.length;i++){
                console.log('workingIf',orderItemList[i].DDSGrade);
                if(orderItemList[i].DDSGrade!=undefined && orderItemList[i].DDSGrade!='' && orderItemList[i].DDSGrade!='No Grade as deal price min price'){
                    console.log('working');
                    orderItemList[i].DDSGrade=undefined;
                    component.set("v.orderItemList",orderItemList)
                }
            }
        }


// Added Below condition by GRZ(Dheeraj Sharma) for RITM0560048 on 25-05-2023



        var minValue = target.get("v.requiredIndicatorClass");
        var p = component.find("paymentMethodOptions").get("v.value");
        console.log("value of p is **********",p);
        //Divya: 26-05-2020 for INCTASK0186953
        var intrstDate = component.get("v.interestDate");
    if (intrstDate != null && intrstDate != "") {
            var newintrstDate = new Date(intrstDate);
        }
        //Updated by Rakesh 
        //If BR71 INFORMAR VENCIMENTO is selected then consider maturity date or else Campaign_Payment_Term_Date__c
    var isCampainCheck = component.get("v.CampaignCheck");
    var isAvec = component.get("v.isAvec");
    var paymntDate = component.get(
      "v.newSalesOrder.Campaign_Payment_Term_Date__c"
    );
    if (
      (isAvec || isCampainCheck) &&
      component.find("payTmDt").get("v.value") &&
      component
        .find("payTmDt")
        .get("v.value")
        .includes("BR71 INFORMAR VENCIMENTO") &&
      component.get("v.newSalesOrder.Maturity_Date__c")
    ) {
      console.log(
        "selectedPaymentTerm12345",
        component.get("v.newSalesOrder.Maturity_Date__c")
      );
            paymntDate = component.get("v.newSalesOrder.Maturity_Date__c");
        }
        
    if (paymntDate != null && paymntDate != "") {
            var newpaymntDate = new Date(paymntDate); 
        }
        //end
        
        var oneDay = 24*60*60*1000;
        //var prsntValue = 0 ;//Modified by Deeksha for kit selling Project
        var lessPrsntValue = false;//Modified by Deeksha for kit selling Project
        var setBlank = 0;
        var isSimulated = component.get("v.isSimulated");
        var applyMinPrice = false; // Priya
        
        var rowIndex = target.get("v.labelClass");
        // var rowIndex = component.get("v.rowIndex");
        //console.log('minValue-->'+minValue);
    console.log("u" + unitValue);
        if(unitValue) {
            //var unitValueFixed  = unitValue.toFixed(2);
            var unitValueFixed  = unitValue;
            target.set("v.value",unitValueFixed);
        }
        var orderItemList = component.get("v.orderItemList");
        
        //Modified by Deeksha for kit selling Project
        if(orderItemList[rowIndex].kitProduct){
            helper.CalculateComponentRow(component, event, helper);
        }
        
        for (var idx = 0; idx < orderItemList.length; idx++) {
            var prsntValue = 0 ;//Modified by Deeksha for kit selling Project
            //console.log('rowIndex1-->'+rowIndex);
            //console.log('orderItemList-'+JSON.stringify(orderItemList));
            //Modified by Deeksha for kit selling Project
      if (
        idx == rowIndex ||
        orderItemList[rowIndex].kitNo == orderItemList[idx].refKitNo
      ) {
                applyMinPrice= orderItemList[idx].applyMinPrice;
                //console.log('**Inside loop applyMinPrice -> '+orderItemList[idx].applyMinPrice);
                
                // console.log('idx'+idx);
                // console.log('rowIndex2-->'+rowIndex);
                if(orderItemList[idx].unitValue!=null){
                    var value2 = orderItemList[idx].unitValue.toString(); //Convert to string
                    //console.log('value2>>--->'+value2);
                    orderItemList[idx].unitValue = parseFloat(value2.replace("-", "")); //Replace negative sign
                    //  console.log(orderItemList[idx].unitValue+'orderItemList[idx].unitValue');
                }
                //Divya: 26-05-2020 for INCTASK0186953
                //console.log("No. of Days "+orderItemList[idx].days);
        console.log("VIVEK-in-Controller newpaymntDate", newpaymntDate);
        console.log("VIVEK-in-Controller paymntDate", paymntDate);
        console.log(
          "VIVEK-in-Controller orderItemList[idx].days",
          orderItemList[idx].days
        );
        if (newpaymntDate != null && newpaymntDate != "") {
                    var nfatDate = new Date(orderItemList[idx].fatDate);
                    console.log("Inside fixed Date");
          if (
            newintrstDate != "" &&
            newintrstDate != null &&
            newpaymntDate > newintrstDate
          ) {
                        if(nfatDate > newintrstDate){
              orderItemList[idx].timeInMonths =
                (newpaymntDate.getTime() - nfatDate.getTime()) / oneDay / 30;
            } else {
              orderItemList[idx].timeInMonths =
                (newpaymntDate.getTime() - newintrstDate.getTime()) /
                oneDay /
                30;
                        }
            console.log("TimeInMonths " + orderItemList[idx].timeInMonths);
            if (
              orderItemList[idx].timeInMonths &&
              orderItemList[idx].interestRate != 0
            ) {
              console.log("Ihe present val 2303");
              orderItemList[idx].unitValueWithInterest =
                orderItemList[idx].unitValue /
                Math.pow(
                  1 + orderItemList[idx].interestRate / 100,
                  orderItemList[idx].timeInMonths
                );
                            prsntValue = orderItemList[idx].unitValueWithInterest;
              console.log("presntValueF" + prsntValue);
            } else {
                            prsntValue = orderItemList[idx].unitValue;
              console.log("Ihe present val 2309");
                        }
          } else {
                        prsntValue = orderItemList[idx].unitValue;
            console.log("Ihe present val 2316");
                    }
                }
                //   console.log("***");                
        else if (
          (paymntDate == "" || paymntDate == null) &&
          orderItemList[idx].days != "" &&
          orderItemList[idx].days != null
        ) {
                    console.log("Interest Date is"+intrstDate);
          console.log("no of days " + orderItemList[idx].days);
                    if(intrstDate=="" || intrstDate==null){
                        orderItemList[idx].timeInMonths = orderItemList[idx].days/30;
                        //if(orderItemList[idx].timeInMonths && orderItemList[idx].interestRate!=0){
                        
            console.log("intrestRate is" + orderItemList[idx].interestRate);
            if (orderItemList[idx].interestRate != 0) {
              console.log("Ihe present val 2327");
              orderItemList[idx].unitValueWithInterest =
                orderItemList[idx].unitValue /
                Math.pow(
                  1 + orderItemList[idx].interestRate / 100,
                  orderItemList[idx].timeInMonths
                );
                            prsntValue = orderItemList[idx].unitValueWithInterest;
              console.log("presntValueRVIVEKController" + prsntValue);
                            //var Interest = (orderItemList[idx].days/30) * orderItemList[idx].interestRate;
                            //orderItemList[idx].unitValueWithInterest = (orderItemList[idx].unitValue - Interest);
                            //prsntValue = orderItemList[idx].unitValueWithInterest;//Added by PC for P1 order issue
              console.log("presntValueR" + prsntValue);
            } else {
                            prsntValue = orderItemList[idx].unitValue;
                        }
          } else {
                        var fatDate = new Date(orderItemList[idx].fatDate);
                        if(fatDate > newintrstDate){
                            orderItemList[idx].timeInMonths = orderItemList[idx].days/30;
              if (
                orderItemList[idx].timeInMonths &&
                orderItemList[idx].interestRate != 0
              ) {
                console.log("Ihe present val 2347");
                orderItemList[idx].unitValueWithInterest =
                  orderItemList[idx].unitValue /
                  Math.pow(
                    1 + orderItemList[idx].interestRate / 100,
                    orderItemList[idx].timeInMonths
                  );
                                prsntValue = orderItemList[idx].unitValueWithInterest;
                console.log("presntValueC1" + prsntValue);
              } else {
                                prsntValue = orderItemList[idx].unitValue;
                            }
            } else {
                            var nfatDate = new Date(orderItemList[idx].fatDate);
                            nfatDate.setDate(nfatDate.getDate()+orderItemList[idx].days);
                            if(nfatDate > newintrstDate){
                orderItemList[idx].timeInMonths =
                  (nfatDate.getTime() - newintrstDate.getTime()) / oneDay / 30;
                                //console.log('timeInMonths '+orderItemList[idx].timeInMonths);
                if (
                  orderItemList[idx].timeInMonths &&
                  orderItemList[idx].interestRate != 0
                ) {
                                    //uncommented by PC to validate the P1 scenario for order
                  console.log("Ihe present val 2364");
                  orderItemList[idx].unitValueWithInterest =
                    orderItemList[idx].unitValue /
                    Math.pow(
                      1 + orderItemList[idx].interestRate / 100,
                      orderItemList[idx].timeInMonths
                    ); //vt
                                    //var Interest = (orderItemList[idx].days/30) * orderItemList[idx].interestRate;//vt
                                    //orderItemList[idx].unitValueWithInterest = (orderItemList[idx].unitValue - Interest);//vt
                                    prsntValue = orderItemList[idx].unitValueWithInterest;//PC
                  console.log("presntValueC2" + prsntValue);
                } else {
                                    prsntValue = orderItemList[idx].unitValue;
                                }
              } else {
                                prsntValue = orderItemList[idx].unitValue;
                            }
                        }
                    }
                }
                //end
                    else{
                        prsntValue = orderItemList[idx].unitValue;
                    }
                //break;//Modified by Deeksha for kit selling Project
                //Modified by Deeksha for kit selling Project
                //if not simulated changes added by Priya For RITM0237685
                
                if(!isSimulated){
          console.log("Inside Not Simulated Orders");
                    
                    //var p = component.find("paymentMethodOptions").get("v.value");
                    console.log(p);
                    console.log(component.get("v.selItem3.PaymentMethod__c.Name"));
          console.log("value is******", orderItemList[idx].unitValue);
          console.log("value is******", orderItemList[idx]);
                    
                    if(prsntValue < orderItemList[idx].minValue) {							   
                        lessPrsntValue = true;
                        orderItemList[idx].unitValue = "";
                    }
                    
                    var CF1 = component.get("v.CustomerConversionFactor");
                    console.log('CF1******',JSON.stringify(CF1));
                
                //BELOW 21 LINES OF CODE ADDED BY HARSHIT&ANMOL FOR (US SO-019)---START
                 //BELOW 21 LINES ADDED BY HARSHITANDANMOL@WIPRO FOR (Phase 2-US SO-005) ---START
                
                for(var i = 0; i < priceDetailList1.length; i++){
                    //var replc = priceDetailList1[i].materialPlnRplcCost;
                    if(orderItemList[idx].productCode==priceDetailList1[i].skuCode){
                        
                        
                        var curr = priceDetailList1[i].currencyCode;
                       var p= priceDetailList1[i].minValueBRL;
                        var o = orderItemList[idx].conversionFactor;
                        var q =p*o;
                        var p1 = priceDetailList1[i].minValueUSD;
                        var o1 = orderItemList[idx].conversionFactor;
                        var q1 = p1*o1;
                        var unitValueBRL1 = priceDetailList1[i].unitValueBRL*orderItemList[idx].conversionFactor;
                        var unitValueUSD1 = priceDetailList1[i].unitValueUSD*orderItemList[idx].conversionFactor;
                        console.log('unitValueBRL1***',unitValueBRL1);
                        console.log('unitValueUSD1***',unitValueUSD1);

                        if(p == 'a300K00000ByAesQAF' && curr == "Only BRL"){
                            console.log("p is ",unitValueBRL1);
                            if(prsntValue < unitValueBRL1 ) {							   
                                lessPrsntValue = true;
                                orderItemList[idx].unitValue = "";
                            }
                            
                            
                            
                        }else if(p == 'a300K00000ByAesQAF' && curr == "Only USD"){
                            if(prsntValue < unitValueUSD1 ) {							   
                                lessPrsntValue = true;
                                orderItemList[idx].unitValue = "";
                            }
                            
                            
                        } 
                        else if(curr == "Only BRL"){
                           console.log('priceDetailList1[i].minValue'+p);
                           console.log('orderItemList[idx].minValue'+o);
                            console.log('orderItemList[idx].minValue*orderItemList[idx].conversionFactor',q);

                            if(prsntValue < priceDetailList1[i].minValueBRL*orderItemList[idx].conversionFactor ) {							   
                                lessPrsntValue = true;
                                orderItemList[idx].unitValue = "";
                            }
                            
                        }
                            else{
                                
                                 console.log('priceDetailList1[i].minValue'+p1);
                           console.log('orderItemList[idx].minValue'+o1);
                            console.log('orderItemList[idx].minValue*orderItemList[idx].conversionFactor',q1);
                                if(prsntValue < priceDetailList1[i].minValueUSD*orderItemList[idx].conversionFactor ) {							   
                                lessPrsntValue = true;
                                orderItemList[idx].unitValue = "";
                            }
                                
                            }
                        
                    }
                    
                    
                }
                
                //---- END
                }
                
                //if simulated changes added by Priya For RITM0237685
                else{
          console.log("Inside Simulated Orders");
          if (prsntValue < orderItemList[idx].minValue && !applyMinPrice) {
                        lessPrsntValue = true;
                        orderItemList[idx].unitValue = "";
                    } 
                }
            }
        }
    console.log("p" + prsntValue);
    console.log("m" + minValue);
        //console.log('**outside loop applyMinPrice -> '+applyMinPrice);
        //console.log('**isSimulated -> '+isSimulated);// Priya RITM0237685 
        
    if (lessPrsntValue) {
      //Modified by Deeksha for kit selling Project: replace with the flag
            //change added by ganesh 
            //target.set("v.errors", [{message: $A.get("$Label.c.Unit_Value_cannot_be_less_than")+" "+minValue}]);
      console.log("Inside error");
      target.set("v.errors", [
        { message: $A.get("$Label.c.Unit_Value_isn_t_allowed") },
      ]);
            target.set("v.value","");
            $A.util.addClass(target, "error");  
            //console.log('minValue'+minValue);
            //console.log('prsntValue'+prsntValue);
    } else {
            target.set("v.errors", null); 
            $A.util.removeClass(target, "error");
            
            //console.log('minValue1'+minValue);
            component.set("v.orderItemList", orderItemList);//Modified by Deeksha for kit selling Project
            helper.updateRowCalculations(component, event);
        }
    },
    
    // Remove validation message if punctuality discount is entered
    updatePunctualityDiscount: function(component, event, helper){
        //var locale = $A.get("$Locale.locale");
        //console.log('locale format: '+locale);
        
        var target = event.getSource();
        var discountValue = target.get("v.value");
        if(discountValue) {
            //var discountFixedValue = discountValue.toFixed(2); //parseFloat(discountValue).toFixed(2).toLocaleString();
            //target.set("v.value", discountFixedValue);
            
            component.find("punctualitydisc").set("v.errors",null);  
            $A.util.removeClass(component.find("punctualitydisc"), "error");
        }
    },
    
    // Restrict Negative Discount Values
        //  function modified by Sagar@Wipro for SO-004 (Price2Win Phase 2)
    restrictNegativeValue: function(component, event, helper){
        var target = event.getSource(); 
        var discountValue = target.get("v.value");
        var businessdisc1 = component.find("businessdisc").get("v.value");
       // var financialdisc1 = component.find("financialdisc").get("v.value");
        var priceDetailList1 = component.get("v.priceDetailList");
        var pbid1=component.get("v.pbid");
        var orderItemList1= component.get("v.orderItemList");
        component.set("v.orderItemListBarter",null);
        component.set("v.barterDiscountValidate",false);
        console.log('businessdisc - '+businessdisc1);
       // console.log('financialdisc - '+financialdisc1);
        console.log('priceDetailList - '+JSON.stringify(priceDetailList1)); 
        console.log('orderItemList1 - '+JSON.stringify(orderItemList1));
        var action = '';
        action = component.get("c.updatePresentValueByBarter");
                    action.setParams({ 
                        "salesOrderItemString": JSON.stringify(orderItemList1),
                        "pbid1":pbid1,
                        "businessdisc": businessdisc1
                        
                    }); 
        action.setCallback(this, function(response){
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") 
            {    
                target.set("v.errors","");
                var barterFlag;
                var orderItemList2 = response.getReturnValue();
                component.set("v.orderItemListBarter",response.getReturnValue()); 
                var orderItemList3= component.get("v.orderItemListBarter"); 
                console.log('orderItemListBarter - '+JSON.stringify(orderItemList3));
                console.log('orderItemList2 - '+JSON.stringify(orderItemList2));
                for(var i=0; i< priceDetailList1.length; i++){
                    for(var j=0; j< orderItemList2.length; j++){
                        
                        console.log('priceDetailList1[i].skuDescription - '+priceDetailList1[i].skuDescription);
                        console.log('orderItemList2[j].productName - '+orderItemList2[j].productName);
                        console.log('priceDetailList1[i].minValueBRL - '+priceDetailList1[i].minValueBRL);
                        console.log('orderItemList2[j].unitValue - '+orderItemList2[j].unitValue);
                        if(priceDetailList1[i].skuDescription == orderItemList2[j].productName){
                            if(priceDetailList1[i].currencyCode == 'Only BRL'){
                                //below code added by Sagar for calculating Barter Discount using CustomerConversionFactor
                                console.log('Updated MinValue in PriceBook - '+ (priceDetailList1[i].minValueBRL * orderItemList2[j].CustomerConversionFactor));
                                if((priceDetailList1[i].minValueBRL * orderItemList2[j].CustomerConversionFactor) <= orderItemList2[j].unitValue){
                                    barterFlag = true;
                                    target.set("v.errors","");
                                    console.log('IF - barterFlag - '+barterFlag);
                                    console.log('IF - barterFlag1 - '+barterFlag);
                                    //component.set("v.barterDiscountValidate",true);
                                    
                                    if(component.get("v.barterDiscountValidate")){
                                         console.log('IF - barterFlag - Test111');
                                        target.set("v.errors", [{message: $A.get("$Label.c.Please_reduce_the_Business_Discount")}]); 
                                        component.set("v.barterDiscountValidate1",true);
                                        component.set("v.barterDiscountValidate",true);
                                    }
                                    var isDiscountValidate= component.get("v.barterDiscountValidate")
                                    if(!isDiscountValidate){
                                        console.log('IF - barterFlag - Test');
                                        target.set("v.errors","");
                                        component.set("v.barterDiscountValidate1",false);
                                    }
                                    
                                    //
                                    
                                }
                                else{
                                    barterFlag = false;
                                    console.log('ELSE - barterFlag - '+barterFlag);
                                    component.set("v.barterDiscountValidate1",true);
                                    component.set("v.barterDiscountValidate",true);
                                    target.set("v.errors", [{message: $A.get("$Label.c.Please_reduce_the_Business_Discount")}]);
                                    target.set("v.value","");
                                    $A.util.addClass(target, "error");  	
                                }
                            }
                            if(priceDetailList1[i].currencyCode == 'Only USD'){
                                if((priceDetailList1[i].minValueUSD * orderItemList2[j].CustomerConversionFactor) <= orderItemList2[j].unitValue){
                                    barterFlag = true;
                                    target.set("v.errors","");
                                    console.log('IF - barterFlag - '+barterFlag);
                                    console.log('IF - barterFlag1 - '+barterFlag);
                                    //component.set("v.barterDiscountValidate",true);
                                    
                                    if(component.get("v.barterDiscountValidate")){
                                         console.log('IF - barterFlag - Test111');
                                        target.set("v.errors", [{message: $A.get("$Label.c.Please_reduce_the_Business_Discount")}]); 
                                        component.set("v.barterDiscountValidate1",true);
                                        component.set("v.barterDiscountValidate",true);
                                    }
                                    var isDiscountValidate= component.get("v.barterDiscountValidate")
                                    if(!isDiscountValidate){
                                        console.log('IF - barterFlag - Test');
                                        target.set("v.errors","");
                                        component.set("v.barterDiscountValidate1",false);
                                    }
                                    
                                    //
                                }
                                else{
                                    barterFlag = false;
                                    console.log('ELSE - barterFlag - '+barterFlag);
                                    component.set("v.barterDiscountValidate1",true);
                                    component.set("v.barterDiscountValidate",false);
                                    target.set("v.errors", [{message: $A.get("$Label.c.Please_reduce_the_Business_Discount")}]);
                                    target.set("v.value","");
                                    $A.util.addClass(target, "error");  	
                                }
                            }
                        }
                    }
                }
                
            }
        });
            $A.enqueueAction(action);
            
        //Logic to restrict negative value
        if(discountValue==null){
            discountValue = 0;
    } else {
            var discountString = discountValue.toString(); //Convert to string
            discountValue = parseFloat(discountString.replace("-", "")); //Replace negative sign
        }
        
        target.set("v.value",discountValue);
        //End of logic
    },
    
    // Logic to show SOM Balance Modal
    openBalancePopUp : function(component, event, helper) {
        component.set("v.modalHeader", $A.get("$Label.c.SOM_Balance"));
        
        helper.hideAllCmp(component);
        
        var balancedata = component.find("balancedata1");
    $A.util.removeClass(balancedata, "slds-hide");
        
        helper.toggle(component);
    },    
    
    // Logic to show Account Selection Modal
    openPopUp : function(component, event, helper) {
    if (component.get("v.orderflagtest") == false) {
      //should show for SCTASK0340391
            component.set("v.modalHeader",$A.get("$Label.c.Customer"));
            helper.hideAllCmp(component);
            var accountdata = component.find("accountdata1");
      $A.util.removeClass(accountdata, "slds-hide");
            helper.toggle(component);
        }
    },
    
    // Logic to show SOM Selection Modal    
    openSOMPopUp : function(component, event, helper) {
        // alert("mother order");
        component.set("v.modalHeader", $A.get("$Label.c.S_O_Mother"));
        
        helper.hideAllCmp(component);
        
        var somdata = component.find("somdata1");
    $A.util.removeClass(somdata, "slds-hide");
        
        helper.toggle(component);
    },
    // Added by Wipro
    openBonification : function(component, event, helper) {
        // alert("mother order");
        component.set("v.modalHeader", $A.get("$Label.c.Normal_Child"));
        
        helper.hideAllCmp(component);
        
        var somdata = component.find("somdata1");
    $A.util.removeClass(somdata, "slds-hide");
        
        helper.toggle(component);
    },
    
    // Logic to show Product Selection Modal        
    openPriceDeatilsPopUp : function(component, event, helper) {
        var target = event.getSource();  
        var rowIndexValue = target.get("v.value");
        
        component.set("v.modalHeader", $A.get("$Label.c.Products"));
        component.set("v.rowIndex",rowIndexValue);
        
        helper.hideAllCmp(component);
        
        var pricedata = component.find("pricedata1");
        
    $A.util.removeClass(pricedata, "slds-hide");
        
        //helper.fetchPriceBookDetails(component);
        //commenting for once
        helper.toggle(component);
    }, 
    openShipToPartysPopUp : function(component, event, helper) {
    component.set("v.modalHeader", "Ship To Party"); //$A.get("$Label.c.Customer")
        
        helper.hideAllCmp(component);
        
        var accountdata = component.find("shiptopartydata1");
    $A.util.removeClass(accountdata, "slds-hide");
        
        helper.toggle(component);
    },
    
    // Logic to show approval/rejection modal
    openDialog : function(component, event, helper) {
        var selected = event.getSource().get("v.label");
        var status = "";
    var toastMsg = "";
    var barterDiscountValidate = component.get("v.barterDiscountValidate");
    console.log('barterDiscountValidate'+barterDiscountValidate);
        
    if(selected==$A.get("$Label.c.Approve")){
            component.set("v.isApproval",true);
            status = "Draft";	
    } else {
            component.set("v.isApproval",false);
            status = "Draft";	
        }
        
        var disableBarter = component.get("v.disableBarter");
        //console.log(disableBarter);
        
        if(disableBarter==false){
            var businessdisc = component.find("businessdisc");
           // var financialdisc = component.find("financialdisc");
            
            var flag = true;
            
      /* if(businessdisc.get("v.value") == null || businessdisc.get("v.value") == ''){
                flag = false;
                component.find("businessdisc").set("v.errors",[{message: $A.get("$Label.c.Business_Discount_is_required") }]);                    
            }
            else{
                component.find("businessdisc").set("v.errors",null);
            }      
            
           /* if(financialdisc.get("v.value") == null || financialdisc.get("v.value") == ''){
                flag = false;
                component.find("financialdisc").set("v.errors",[{message: $A.get("$Label.c.Financial_Discount_is_required") }]);                    
            }
            else{
                component.find("financialdisc").set("v.errors",null);
            }   */
            
            if(flag==false){
        toastMsg = $A.get(
          "$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding"
        );
                helper.showErrorToast(component, event, toastMsg);
      } else {
        var orderItemListBarter2= component.get("v.orderItemListBarter");
        console.log('orderItemListBarter2==>',orderItemListBarter2);
        var isApproval= component.get("v.isApproval");
        var action = component.get("c.barterDiscountUpdate");
        action.setParams({ 
            "soObj": component.get("v.newSalesOrder"),
            "salesOrderItemString": JSON.stringify(orderItemListBarter2),
            "isApprove": isApproval
                });
                
                action.setCallback(this, function(a) {
                    var state = a.getState();
                    if (state == "SUCCESS") {
                        var signed = component.get("v.newSalesOrder.Signed__c");
                        if(signed){
                            component.set("v.showSign",false);
                            component.set("v.showUnsign",true);
              component.set(
                "v.signMessage",
                $A.get("$Label.c.Are_you_sure_you_want_to_unsign")
              );
            } else {
                            component.set("v.showSign",true);
                            component.set("v.showUnsign",false);
              component.set(
                "v.signMessage",
                $A.get("$Label.c.Are_you_sure_you_want_to_sign")
              );
                        }
          } else {
                        //toastMsg = 'Signing Failed';
                        //helper.showErrorToast(component, event, toastMsg);   
                    }             
                });
                $A.enqueueAction(action);  
                helper.toggleDialog(component);
            }
    } else {
            helper.toggleDialog(component);
        }
    },
    
    // Logic to hide all selection modals    
    closeDialog : function(component, event, helper) {
        helper.toggleDialog(component);
    },   
    
    //Logic to hide all selection modals    
    closePopUp : function(component, event, helper) {
        helper.closePopUp(component);
    },    
    
   // Save Comments while Approving / Rejecting Order (Available for: SDM/SOM/SD/Barter)
    saveComment : function(component,event,helper) {
        //Change by Swaranjeet(Grazitti) APPS-4591 
        var barterDiscountMap = component.get("v.BarterMap");
        console.log('barterDiscountMap----',JSON.stringify(barterDiscountMap));
        var TotalofDiscountApplied = component.get("v.TotalofDiscountApplied");
        console.log('TotalofDiscountApplied----',TotalofDiscountApplied);
        var NewGrossMargin = component.get("v.NewGrossMargin");
        console.log('NewGrossMargin----',JSON.stringify(NewGrossMargin));
         var Barterpercentagecalculatedmap = component.get("v.Barterpercentagecalculatedmap");
        console.log('Barterpercentagecalculatedmap----',JSON.stringify(Barterpercentagecalculatedmap));
        var TotalBarterDiscountSalesorder = component.get("v.TotalBarterDiscountSalesorder");
        console.log('TotalBarterDiscountSalesorder----',TotalBarterDiscountSalesorder);
        var Grossmarginsalesorder = component.get("v.Grossmarginsalesorder");
        console.log('Grossmarginsalesorder----',Grossmarginsalesorder);
        console.log(' component.get("v.isBarter")----', component.get("v.isBarter"));
       
        var isApproved = false;
        var msg = '';
        if(component.get("v.isApproval")){
            status = "Approved";
            isApproved = true;
            msg = $A.get("$Label.c.Are_you_sure_you_want_to_Approve_the_Sales_Order");
    } else {
            status = "Rejected";
            isApproved = false;
            msg = $A.get("$Label.c.Are_you_sure_you_want_to_Reject_the_Sales_Order");
        }        
        if(confirm(msg)){
            var processname='';
            if(component.get("v.isSOItemsEditProcess")){
                processname='isSOItemsEditProcess';
            }
            if(component.get("v.isSOCancelProcess")){
                processname='isSOCancelProcess';
            }
            
            if(component.get("v.isSOCancelProcess") || component.get("v.isSOItemsEditProcess")){
            var action = component.get("c.validateSAPResponse");
            action.setParams({
                isApproved: isApproved,
                recordId: component.get("v.recordId"),
                comments: component.get("v.comments"),
                processname: processname
            });
            // show spinner to true on click of a button / onload
            component.set("v.showSpinner", true); 
            
            action.setCallback(this, function(a) {
                // on call back make it false ,spinner stops after data is retrieved
                component.set("v.showSpinner", false); 
                var state = a.getState();
                if (state == "SUCCESS") {
                    var returnValue = a.getReturnValue();
                    console.log('returnValue***',returnValue);
                    //alert(returnValue);
                    /* var toastEvent = $A.get("e.force:showToast");
                            var msg  = returnValue;
                            var titl  = "Status";
                            if(toastEvent !=undefined){
                                onsole.log('toastEvent***');
                            toastEvent.setParams({
                                "title": titl,
                                "type": "error",
                                "message": msg,
                                "duration":'5000'
                            });
                            toastEvent.fire();
                }*/
                    
                   /* component.set("v.approvalList",a.getReturnValue());
                    
                    var enableApproval = component.get("v.approvalList.enableApproval");
                    component.set("v.showApproveReject", enableApproval);
                    component.set("v.disableBarter", true);
                    
                    component.set("v.showSimulate", false);*/
                    
                    var profileName = component.get("v.orderFields.userObj.Profile.Name");
                    var fullUrl = '';
                    var defType = '';
                    
                    if(component.get("v.isApproval")){
                        defType = 'approved';
                    }
                    else{
                        defType = 'rejected';
                    }      
                    
                    if(profileName=='Brazil Sales District Manager'){
                        fullUrl = "/apex/BrazilEnhancedListForSDM?defType="+defType;
                        helper.gotoURL(component, fullUrl);
                    }  
                    else if(profileName=='Brazil Sales Office Manager'){
                        fullUrl = "/apex/BrazilEnhancedListForSOM?defType="+defType;
                        helper.gotoURL(component, fullUrl);
                    }
                        else if(profileName=='Brazil Sales Director'){
                            fullUrl = "/apex/BrazilEnhancedListForSD?defType="+defType;
                            helper.gotoURL(component, fullUrl);
                        }
                            else if(profileName=='Brazil Regional Head'){
                                fullUrl = "/apex/BrazilEnhancedListForREH?defType="+defType;
                                helper.gotoURL(component, fullUrl);
                            }
                                else if(profileName=='Brazil Barter Manager'){
                                    fullUrl = "/apex/BrazilEnhancedListforBarter?defType="+defType;
                                    helper.gotoURL(component, fullUrl);
                                }
                                    else if(profileName=='Custom System Administrator'){
                                        fullUrl = "/apex/BrazilEnhancedListForSD?defType="+defType;
                                        helper.gotoURL(component, fullUrl);
                                    }
                }	
            });
            helper.toggleDialog(component);
            $A.enqueueAction(action);
        }
            else{
                var action = component.get("c.processApproval");
            action.setParams({
                isApproved: isApproved,
                recordId: component.get("v.recordId"),
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
                    component.set("v.disableBarter", true);
                    
                    component.set("v.showSimulate", false);
                    
                    var profileName = component.get("v.orderFields.userObj.Profile.Name");
                    var fullUrl = '';
                    var defType = '';
                    
                    if(component.get("v.isApproval")){
                        defType = 'approved';
                    }
                    else{
                        defType = 'rejected';
                    }      
                    
                    if(profileName=='Brazil Sales District Manager'){
                        fullUrl = "/apex/BrazilEnhancedListForSDM?defType="+defType;
                        helper.gotoURL(component, fullUrl);
                    }  
                    else if(profileName=='Brazil Sales Office Manager'){
                        fullUrl = "/apex/BrazilEnhancedListForSOM?defType="+defType;
                        helper.gotoURL(component, fullUrl);
                    }
                        else if(profileName=='Brazil Sales Director'){
                            fullUrl = "/apex/BrazilEnhancedListForSD?defType="+defType;
                            helper.gotoURL(component, fullUrl);
                        }
                            else if(profileName=='Brazil Regional Head'){
                                fullUrl = "/apex/BrazilEnhancedListForREH?defType="+defType;
                                helper.gotoURL(component, fullUrl);
                            }
                                else if(profileName=='Brazil Barter Manager'){
                                    fullUrl = "/apex/BrazilEnhancedListforBarter?defType="+defType;
                                    helper.gotoURL(component, fullUrl);
                                }
                                    else if(profileName=='Custom System Administrator'){
                                        fullUrl = "/apex/BrazilEnhancedListForSD?defType="+defType;
                                        helper.gotoURL(component, fullUrl);
                                    }
                }	
            });
            helper.toggleDialog(component);
            $A.enqueueAction(action);
            }
        }
        
		 //Change by Swaranjeet(Grazitti) APPS-4591 
        if(component.get("v.isBarter")){
             var action90 = component.get("c.updateBarter");
                        action90.setParams({
                            
                            recordMap: barterDiscountMap,
                            TotalofDiscount: TotalofDiscountApplied,
                            BarterDiscountSalesorder: TotalBarterDiscountSalesorder,
                            Grosssalesorder: Grossmarginsalesorder,
                            NewGrossmap: NewGrossMargin,
                            BarterpercentcalculatedMap: Barterpercentagecalculatedmap
                            
                        });
                        
                        
                        action90.setCallback(this, function(a) {
                            
                            var state = a.getState();
                            console.log('state***',state);
                            if (state == "SUCCESS") {
                                var returnValue = a.getReturnValue();
                                console.log('returnValue***',returnValue);
                                if(returnValue == true){
                                    component.set("v.bartercheck",true);
                                }
                            }
                            else{
                                console.log('Error-----');
                            }
                        });
                        $A.enqueueAction(action90); 
// end----      
        }
                      
    },
    
    // Reset all input elements on the form
    resetForm : function(component, event, helper){
        // show a confirm
    if (
      confirm($A.get("$Label.c.Are_you_sure_you_want_to_reset_the_details"))
    ) {
            // perform custom logic here    
            
            var isChecked= component.get("v.CampaignCheck");
            
            if(isChecked){
                //component.find("campChk").set("v.value",false);
                
                component.set("v.newSalesOrder.Use_Campaign__c",false);
                component.set("v.isStructure", false);
                component.set("v.newSalesOrder.Campaign_Type__c","None");
                component.set("v.isSimple", false);
                component.find("simpCmp").set("v.value",false);
                component.find("structCmp").set("v.value",false);
                component.set("v.CampaignCheck",false);
            }
            
            var orderType = component.get("v.orderType");
            //if(orderType == 'VENDA NORMAL'){
            component.find("dirSaleNo").set("v.disabled", false); 
            component.find("dirSaleYes").set("v.disabled", false); 
            component.set("v.newSalesOrder.Directed_Sales__c", false);
            //component.find("dirSaleNo").set("v.value", false); 
            //component.find("dirSaleYes").set("v.value", false);
            
            //}
            component.set("v.newSalesOrder.Pronutiva__c", false);            
            component.find("radio1").set("v.checked",false);
            component.find("radio2").set("v.checked",false);
            
      component.set("v.newSalesOrder", {
        sobjectType: "Sales_Order__c",
        Name: "",
        Sold_to_Party__c: "",
        Sales_Order__c: null,
        Price_Book_Details__c: "",
        Type_of_Order__c: "",
        Valid_From__c: "",
        Valid_To__c: "",
        Payment_Method__c: "",
        Payment_Term__c: "",
        Sold_to_Party__r: null,
        Purchase_Order_no__c: "",
        Purchase_Order_Date__c: null,
        Total_Overall_Margin__c: 0    // SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022....
                          });
            component.set("v.isEdit",false);
      component.set("v.selItem5", {
        sobjectType: "Shipping_Location__c",
        Name: "",
        Id: "",
        Location_Name__c: "",
      });
            
            component.set("v.selItem",null);
            component.set("v.selItem2",null);
            component.set("v.selItem3",null);
            component.set("v.selItem4",null);
            component.set("v.totalValue",0);
            component.set("v.priceBookId",null);
            component.set("v.isEdit",true);
            component.set("v.totalMargin", 0);            // SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.......
            var items = component.get("v.orderItemList");
            var count = items.length;
            for(var index=0; index<=count; index++){
                if(index == items.length - 1){
                    component.set("v.cultureDescList", null);
                    items.splice(index, 1);
          component.set(
            "v.cultureDescList",
            component.get("v.cultureDescListCopy")
          );
        } else {
                    if(items.length>=1){
                        if(items.length - 1 == 0){
                            component.set("v.cultureDescList", null);
                            items.splice(0, 1);
              component.set(
                "v.cultureDescList",
                component.get("v.cultureDescListCopy")
              );
            } else {
                            items.splice(0, 1);
                        } 
                    }
                }
            }
            
            component.set("v.orderItemList",items);
            helper.enableDisableFields(component, items.length);
            component.set("v.recordId",null);
            
            var action = component.get("c.doInit");
            $A.enqueueAction(action); 
        }       
    },
    
    // Populate current date in ValidTo date by default 
    onDateChangeValidToDate : function(component){
        var inputCmp = component.find("validToDate");
        var value = inputCmp.get("v.value");
        
        var inputCmp1 = component.find("validFrom");
        var value1 = inputCmp1.get("v.value");
        
        var x = new Date(value);
        var y = new Date(value1);
        
        var flag = true;
        
    if (x == "Invalid Date") {
      inputCmp.set("v.errors", [
        { message: $A.get("$Label.c.Valid_to_date_is_required") },
      ]);
            $A.util.addClass(inputCmp, "error");
            flag = false; 
        }
        // is less than today?
        else if (+x < +y) {
            //inputCmp.set("v.errors", [{message:"Valid To date: "+value+" cannot be less than Valid From date: " + value1}]);
      inputCmp.set("v.errors", [
        { message: $A.get("$Label.c.To_date_can_not_be_before_from_date") },
      ]);
            $A.util.addClass(inputCmp, "error");
            flag = false;
    } else {
                inputCmp.set("v.errors", null);
                $A.util.removeClass(inputCmp, "error");
            }
        
        component.set("v.isValidTo",flag);
    },
    
    // Populate financial year end date in Valid From date by default  
    // Validation to check if Valid From less than today   
    // Validation to check if Valid From greater than Valid To (Expiry) Date
    onDateChangeValidFromDate : function(component){
        var inputCmp = component.find("validFrom");
        var value = inputCmp.get("v.value");
        
        var inputCmp2 = component.find("validToDate");
        var value2 = inputCmp2.get("v.value");
        
        var today = new Date();
    var dd = (today.getDate() < 10 ? "0" : "") + today.getDate();
    var MM = (today.getMonth() + 1 < 10 ? "0" : "") + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        
        // Custom date format for ui:inputDate
    var currentDate = yyyy + "-" + MM + "-" + dd;
        
        var x = new Date(value);
        var y = new Date(currentDate);
        var z = new Date(value2);
        
        var flag = true;
        
        //console.log('validFromDate: '+x);
        //console.log('validToDate: '+z);
        //console.log('+x > +z: '+(+x > +z));
        
    if (x == "Invalid Date") {
            inputCmp.set("v.errors", [{message:"Valid From is required"}]);           
            $A.util.addClass(inputCmp, "error");
            flag = false; 
        }
        // is less than today?
        else if (+x < +y) {
      inputCmp.set("v.errors", [
        { message: $A.get("$Label.c.Valid_From_cannot_be_less_than_today") },
      ]);
            $A.util.addClass(inputCmp, "error");
            flag = false;
    } else if (+x > +z) {
      inputCmp.set("v.errors", [
        {
          message: $A.get(
            "$Label.c.Valid_From_Date_cannot_be_more_than_Valid_To_date"
          ),
        },
      ]);
                $A.util.addClass(inputCmp, "error");
                flag = false;
    } else {
                    inputCmp.set("v.errors", null);
                    $A.util.removeClass(inputCmp, "error");
                }
        component.set("v.isValidFrom",flag);
    },
    
    // Logic to check if PO Date is valid
    restrictPODate: function(component){
        var inputCmp = component.find("poDate");
        var value = inputCmp.get("v.value");
        
        if(value){
            var x = new Date(value);
            var flag = true;
            
            //console.log('validFromDate: '+x);
            
      if (x == "Invalid Date") {
        inputCmp.set("v.errors", [
          { message: $A.get("$Label.c.Purchase_Order_date_is_required") },
        ]);
                $A.util.addClass(inputCmp, "error");
                flag = false; 
      } else {
                inputCmp.set("v.errors", null);
                $A.util.removeClass(inputCmp, "error");
            }
            //component.set("v.isValidMaturity",flag);
        }
    },
    
    // 1. Logic to check maturity date not less than today
    // 2. Logic to validate if input date is a valid date
    restrictMaturityDate : function(component, event){
        //var inputCmp = component.find("maturityDate");
        var target = event.getSource();  
        var value = target.get("v.value"); //inputCmp.get("v.value");
        
        if(value){
            var today = new Date();
      var dd = (today.getDate() < 10 ? "0" : "") + today.getDate();
      var MM = (today.getMonth() + 1 < 10 ? "0" : "") + (today.getMonth() + 1);
            var yyyy = today.getFullYear();
            
            // Custom date format for ui:inputDate
      var currentDate = yyyy + "-" + MM + "-" + dd;
            
            var x = new Date(value);
            var y = new Date(currentDate);
            
            var flag = true;
            
            //console.log('validFromDate: '+x);
            //console.log('+x > +z: '+(+x > +z));
            
      if (x == "Invalid Date") {
        target.set("v.errors", [
          { message: $A.get("$Label.c.Maturity_date_is_required") },
        ]);
                $A.util.addClass(target, "error");
                flag = false; 
            }
            // is less than today?
            else if (+x < +y) {
        target.set("v.errors", [
          {
            message: $A.get("$Label.c.Maturity_Date_cannot_be_less_than_today"),
          },
        ]);
                $A.util.addClass(target, "error");
                flag = false;
      } else {
                    target.set("v.errors", null);
                    $A.util.removeClass(target, "error");
                }
            component.set("v.isValidMaturity",flag);
        }
    },
    
    // Method to Update Punctuality flag on Radio Group Value
    onGroup: function(component, event) {
        var selected = event.getSource().get("v.text");
    if (selected == "Yes") {
            component.set("v.isPunctual", true);
    } else if (selected == "No") {
            component.set("v.isPunctual", false);
            component.set("v.newSalesOrder.Punctuality_Discount__c", "");
        }
        //console.log('selected: '+selected);
    },
    
    // 1. If Key Group = No then fetch Business Rule of current logged in user.
    // 2. Else fetch All the sellers of the Same district to which the Logged in user (Sales Person) belongs
    onKeyGroup: function(component, event, helper) {
            var selected = event.getSource().get("v.text");
            //console.log('selected: '+selected);
            
        if (selected == "Yes") {
                component.set("v.newSalesOrder.Key_Account__c", true);
                component.find("keyYes").set("v.value", true);     // by nikhil
                component.find("keyNo").set("v.value", false);     // by nikhil
                helper.fetchSeller(component);
                //patch added by ganesh
          component.set("v.selectedUser", "None");
          component.set("v.orderType", "None");
                var custbtn = component.find("custitem");
          custbtn.set("v.disabled", true);
                //console.log('Key Account>>--->'+selected);
                helper.fetchAccounts(component);
        } else if (selected == "No") {
                //added by ganesh 
                component.set("v.newSalesOrder.KeyAccountDesOwnerBrazil__c", null);
          component.set("v.selectedUser", "None");
                //end
                // component.find("keyNo").set("v.value", false);     // by nikhil
                component.set("v.showSeller", false);
          component.set("v.orderType", "None");
                component.set("v.newSalesOrder.Key_Account__c", false);
                var custbtn = component.find("custitem");
          custbtn.set("v.disabled", true);
                helper.fetchAccounts(component);
                
                //Commenting this because when Key Account is 'No' user Id will be set to logged in user
                //var currentValue = component.get("v.newSalesOrder.KeyAccountDesOwnerBrazil__c"); //event.getParam("value");
                
                var currentValue = component.get("v.user.Id"); 
                //console.log('currentValue: '+currentValue);
                
          if (currentValue && currentValue != "None") {
                    //Commenting this because when Key Account is 'No' user Id will be set to logged in user
                    //component.set("v.user.Id",currentValue); 
                    
                    //Set owner Id to logged In user
                    // component.set("v.newSalesOrder.OwnerId", currentValue);
                    
                    helper.fetchBusinessRule(component, currentValue);
                }
            }
    },
    handleshipLocChange: function(component, event, helper){
    var shipToParty = component.get("v.selItem5.Id");
        component.set("v.newSalesOrder.Ship_To_Party__c",shipToParty); 
        
        //alert('handleShipLoc shiptoParty>>--->'+component.get("v.newSalesOrder.Ship_To_Party__c")); 
    },
    onCampaignChange:function(component, event, helper){
        //var isChecked= component.find("campChk").get("v.value");
        var isChecked=component.get("v.CampaignCheck");											   
        var campaignId = component.get("v.campaignId");
        var spltStr=campaignId.split("*");
        component.set("v.isMature", "false");
        component.set("v.newSalesOrder.Maturity_Date__c", null);
        
        var campid = spltStr[0];
        //alert(spltStr[1])
    if (spltStr[1] == "true") {
            component.set("v.isSimulator",true);    
        }else{
            component.set("v.isSimulator",false);  
        }
        
        if(isChecked){
            // var pb_id = component.get("v.campaignId"); 
            //alert(pb_id);  
            //console.log(component.find("campaignId").get("v.value"));
            /*var selectedPriceBookName = component.get("v.priceBooksMap").filter(entry =>entry.value === (component.find('Campaign').get('v.value'))).length>0 ?component.get("v.priceBooksMap").filter(entry =>entry.value === component.find('Campaign').get('v.value'))[0].label:'';
            var avecValue=selectedPriceBookName.toUpperCase();
            if(avecValue.indexOf('AVEC') !== -1 || avecValue.indexOf('DESCONTINUADOS') !== -1){
                //alert('in If');
                component.set("v.disableDirectSalesNo",true);
                component.find('dirSaleYes').set('v.value',true);
                component.set("v.newSalesOrder.Directed_Sales__c", true);
            }
            else {
                component.set("v.disableDirectSalesNo",false);
                component.find('dirSaleYes').set('v.value',false);
               var isDirect=component.get("v.newSalesOrder.Directed_Sales__c");
                if(isDirect===undefined){
                    component.set("v.newSalesOrder.Directed_Sales__c", false);
                }
            }*/
            component.set("v.newSalesOrder.Price_Book__c",campid);
            component.set("v.pbid",campid);
            helper.getPBPayMent(component, event, campid);
            helper.fetchPriceBookDetails(component);
            helper.getPricebookCreatedDate(component);										  
    } else {
            helper.getpaymentTerm(component, event, helper,campid);
        }
        // component.set("v.campaignId",campid);
    },
    // Method to check Selected Currency and Add Price List Options accordingly.
    handleCurrencyChange: function(component, event, helper){
        // handle value change
    console.log(
      "old value (Currency): " + JSON.stringify(event.getParam("oldValue"))
    );
    console.log(
      "current value (Currency): " + JSON.stringify(event.getParam("value"))
    );
        
        //if(event.getParam("oldValue")!=event.getParam("value")){
        
        //PriceList
        var returnValue = component.get("v.orderFields",returnValue);

        console.log('returnValues==>',returnValue);
        console.log('returnValue.priceList',returnValue.priceList);
        var priceList = returnValue.priceList;
        var isChecked= component.get("v.CampaignCheck");//component.find("campChk").get("v.value");
        //console.log('priceList: '+JSON.stringify(priceList));
        //alert();
    if (returnValue != "None") {
            var inputCmp = component.find("currencyOptions");
            //inputCmp.set("v.errors", null);
            $A.util.removeClass(inputCmp, "error");
        }
        
        var opts=[];
        
        var selectedCurrency = event.getParam("value"); //component.get("v.newSalesOrder.Currency_Brazil__c"); 
        //selectedCurrency = selectedCurrency.replace('"','');       
        //console.log('selectedCurrency: '+selectedCurrency);
        
    if (selectedCurrency == undefined || selectedCurrency == "None") {
      selectedCurrency = "None"; //'Billing BRL / Payment BRL';
        }
        /*if(selectedCurrency=='None'){
                opts.push({"class": "optionClass", label: 'Select a price list', value: 'None'});
            }*/           
        component.set("v.newSalesOrder.Currency_Brazil__c", selectedCurrency);
        
        var priceBookId = component.get("v.newSalesOrder.Price_Book__c");
        console.log(priceBookId);
        console.log("priceBookId");
        var priceBookName = component.get("v.newSalesOrder.Price_Book__r.Name");
        
        //console.log('selectedCurrency: '+selectedCurrency);
        //console.log('priceBookId: '+priceBookId+'priceBookName'+priceBookName);
        
        if(isChecked){
      opts.push({
        class: "optionClass",
        label: $A.get("$Label.c.Select_Campaign"),
        value: "None",
      });
    } else {
      opts.push({
        class: "optionClass",
        label: $A.get("$Label.c.Select_A_Price_List"),
        value: "None",
      });
        } 

        if(priceList.length==0){
      opts.push({
        class: "optionClass",
        label: priceBookName,
        value: priceBookId,
      });
        }

    if (selectedCurrency.startsWith("Billing BRL")) {
      // || selectedCurrency.startsWith('Faturamento BRL')
      selectedCurrency = "BRL";
            //console.log('BRL: '+selectedCurrency);
    } else if (selectedCurrency.startsWith("Billing USD")) {
      // || selectedCurrency.startsWith('Faturamento USD')
      selectedCurrency = "USD";
            //console.log('USD: '+selectedCurrency);
        }
        // alert('isChecked '+isChecked);
        var kitLabel = $A.get("$Label.c.Kit");//Modified by Deeksha for kit selling Project
        if(isChecked){
            var cmpTp = component.get("v.newSalesOrder.Campaign_Type__c");
          
            //  alert('cmp tp'+cmpTp);
            for(var i=0; i< priceList.length; i++){
                var str = priceList[i];
                //Modified by Deeksha for kit selling Project
                if(str.startsWith(kitLabel)){
                    str = str.replace(kitLabel,"").trim();
                }
                var spltStr=str.split("*");
                // alert(spltStr[2]);
                if(spltStr[2] == cmpTp){
          if (str.startsWith(selectedCurrency) || str.startsWith("ST")) {
                        //console.log('str>>--->'+str+'<---cmpTp>>--->'+cmpTp+'<--spltStr[2]>>--->'+spltStr[2]);
                        var splitValues = str.split("*");
      opts.push({
              class: "optionClass",
              label: splitValues[0],
              value: splitValues[1] + "*" + splitValues[3],
            });
            }
                }
            }
            //component.set("v.priceBooksMap",opts);
    } else {
            for(var i=0; i< priceList.length; i++){
                var str = priceList[i];
                //Modified by Deeksha for kit selling Project
                if(str.startsWith(kitLabel)){
                    str = str.replace(kitLabel,"").trim();
                }
                var spltStr=str.split("*");
                //console.log('str>>--->'+str);
                // alert(spltStr[2]);
        if (spltStr[2] == "null" || spltStr[2] == "Normal") {
                    if(str.startsWith(selectedCurrency)){
                        var splitValues = str.split("*");
            opts.push({
              class: "optionClass",
              label: splitValues[0],
              value: splitValues[1],
            });
                    }
                }   else{
            }
            }
            //added below line by srikanth to handle AVEC changes
            component.set("v.priceBooksMap",opts);
      console.log(JSON.stringify(opts) + "*****");
        }
        
        //console.log('opts>>>'+JSON.stringify(opts));
        
        component.set("v.newSalesOrder.CurrencyIsoCode", selectedCurrency);
    if (selectedCurrency != "None") {
      component.set("v.currency", selectedCurrency + " ");
        }
        var ordertype=component.get("v.orderType");
        if(component.get("v.CampaignCheck") == true){
            component.find("Campaign").set("v.options", opts);
            //alert('priceBook'+priceBookId);
    } else {
      if (ordertype != "ORDEM FILHA") {
                component.find("priceListOptions").set("v.options", opts); 
            }
      var pmtterms;
            if(!component.get("v.isAvec")){
                pmtterms = component.find("paymentTermOptions");
                if(Array.isArray(pmtterms)){
          pmtterms[0].set("v.value", opts);
                }else{
          pmtterms.set("v.value", opts);
                }
            }
        }
        
        //console.log('opts>>---> '+opts);
        
        if(priceBookId){
      console.log("priceBookId:12 " + priceBookId);
      if (ordertype != "ORDEM FILHA") {
                component.set("v.priceBookId",priceBookId);
            }
            //component.set("v.campaignId",priceBookId);
            //component.set("v.priceBookId",priceBookName);
        }
        //}
        //End
    },
    
    /* //added by sreekanth
    onPriceBookChange : function(component,event,helper){
        var selectedPriceBookName = component.get("v.priceBookId");
        alert(selectedPriceBookName);
    },*/
    
    // Logic to update Currency, Product Selection and PriceList based on selected SOM
    handleSOMChange: function(component, event, helper){
        //BELOW 1 LINE OF CODE IS FOR FETCHING PRICEBOOK NAME BY HARSHIT&ANMOL@WIPRO ---START
        var selItem3=component.get("v.selItem3");
        
        var priceBookId = component.get("v.selItem3.Price_Book__r.Name");
        var pbid = component.get("v.selItem3.Price_Book__c");
        var isavec = component.get("v.selItem3.AVEC_Order__c");

        console.log('isAVECDS=>',isavec);
        component.set("v.campaignId",priceBookId);
        //--END		   
        var currencyBrazil = component.get("v.selItem3.Currency_Brazil__c");
        var paymentMethod = component.get("v.selItem3.PaymentMethod__c");
        var campgnTp = component.get("v.selItem3.Campaign_Type__c"); 
        var campgn= component.get("v.selItem3.Use_Campaign__c");
        var isStructChild= component.get("v.isOrdemFilha");
        var currencyList= component.get("v.currencyList");
        var ordertype = component.get("v.orderType");
        // component.set("v.newSalesOrder.Currency_Brazil__c", currencyBrazil );
        /* if (selItem3!=null){
         if(selItem3.Kit_Order__c){
                        component.set("v.SelectPriceBook",'Price Book for Kit');
                        component.set("v.isAvec",false);
                        component.set("v.CampaignCheck",false);
                    }else if(selItem3.Use_Campaign__c){
                        component.set("v.SelectPriceBook",'Price Book for Campaign');
                        component.set("v.CampaignCheck",true);
                        component.set("v.newSalesOrder.Campaign_Type__c",campgnTp); 
                        component.set("v.isAvec",false);
                    }else if(selItem3.AVEC_Order__c){
                        component.set("v.SelectPriceBook",'AVEC / Descontinuados Price Book');
                        component.set("v.isAvec",true);
                        component.set("v.CampaignCheck",false);
                    }else{
                    	component.set("v.SelectPriceBook",'Normal Price Book');
                        component.set("v.isAvec",false);
                        component.set("v.CampaignCheck",false);
                    }
        }
        */
        var opts=[]; 
        var paymentTerm = component.get("v.selItem3.ReloadPaymentTerms__c");
        // ananwoy -- added to fetch invoice message from mother order to child order RITM0287875
        var invoiceMsg = component.get("v.selItem3.Invoice_Message__c");
        component.set("v.newSalesOrder.Invoice_Message__c",invoiceMsg);
        component.set("v.newSalesOrder.ReloadPaymentTerms__c",paymentTerm);
        //component.set("v.newSalesOrder.Sales_Order__c",component.get("v.selItem3"));
        
        //BELOW 10 LINES OF CODE ADDED BY HARSHIT@WIPRO FOR (US SOS-010) TO fetch Internal_OBS__c from mother order to child order ---START
        var internalObs = component.get("v.selItem3.Internal_OBS__c");
    console.log("internalObs", internalObs);
        
        component.set("v.newSalesOrder.Internal_OBS__c",internalObs);
    console.log("internalObs", internalObs);
        
        //fetch Sales_order_OBS__c from mother order to child order by Harshit Porwal
        var salesOrderObs = component.get("v.selItem3.Sales_order_OBS__c");
        component.set("v.newSalesOrder.Sales_order_OBS__c",salesOrderObs);
        
        //---END
        
        component.set("v.selItem",null);
        if(component.get("v.selItem3")!=null){
            var inputCmp = component.find("soName");
            inputCmp.set("v.errors", null);
            $A.util.removeClass(inputCmp, "error");
        }
        
        var isChecked= component.get("v.CampaignCheck");//component.find("campChk").get("v.value");  
        if(!isChecked&&!isavec){
            component.set("v.isSimple",false); 
            component.set("v.isStructure",false);
            
            var opts=[];
      opts.push({
        class: "optionClass",
        label: $A.get("$Label.c.None"),
        value: "None",
      });
            //console.log('Payment Terms:'+JSON.stringify(returnValue.paymentTermsMap));
            var paymentTermsMap = component.get("v.paymentTermsMap");
            //var ptMap = new Map();
            
            for (var key in paymentTermsMap){
        opts.push({ class: "optionClass", label: key, value: key });
                //ptMap.set(key, paymentTermsMap[key]);
            }     
            //console.log('Payment Terms:'+JSON.stringify(opts));
            
            component.set("v.paymentTermsMap", paymentTermsMap);
            var pmtterms = component.find("paymentTermOptions");
            if(Array.isArray(pmtterms)){
        pmtterms[0].set("v.value", opts);
            }else{
        pmtterms.set("v.value", opts);
            }
            //component.find("paymentTermOptions").set("v.options", opts);   
            
            component.set("v.paymentTerm", paymentTerm);
            console.log("pricebookId set" + priceBookId);
            //component.set("v.priceBookId",priceBookId);
    } else if (campgn) {
      if (campgnTp == "Structured") {
                component.set("v.isSimple",false); 
                component.set("v.isStructure",true);
                component.find("simpCmp").set("v.value",false);
                component.find("structCmp").set("v.value",true);
        component.set("v.newSalesOrder.Campaign_Type__c", "Structured");
                //Currency
                opts=[];
        opts.push({
          class: "optionClass",
          label: $A.get("$Label.c.None"),
          value: "None",
        });
                for(var i=0; i< currencyList.length; i++){
                    var str = currencyList[i];
                    var splitValues = str.split("*");
                    
          if (splitValues[1] == "Billing BRL / Payment BRL") {
            opts.push({
              class: "optionClass",
              label: "BRL",
              value: splitValues[1],
            });
          } else if (splitValues[1] == "Billing USD / Payment BRL") {
            opts.push({
              class: "optionClass",
              label: "USD",
              value: splitValues[1],
            });
                    }
                    }
                //console.log('currencyList: '+JSON.stringify(currencyList));
                component.find("currencyOptions").set("v.options", opts);               
                //End
      } else {
        component.set("v.newSalesOrder.Campaign_Type__c", "Simple");
                component.set("v.isSimple",true); 
                component.set("v.isStructure",false);
                component.find("simpCmp").set("v.value",true);
                component.find("structCmp").set("v.value",false);
            }
    } else if (isavec) {
                component.set("v.isAvec",true);
      console.log("TestSagar123");
            }
        
        console.log(currencyBrazil + "selectedCurrency");
        component.set("v.selectedCurrency", currencyBrazil );
        if(!isStructChild && paymentMethod!=null){
            component.set("v.paymentMethod", paymentMethod ); 
        }
        component.set("v.newSalesOrder.Currency_Brazil__c", currencyBrazil );
        
        var custbtn = component.find("custitem");
    custbtn.set("v.disabled", true);
        //Fetch config/data for customers component from helper method        
        helper.fetchAccountsForSOM(component);  
        helper.fetchAccounts(component);								
    },
    handleselItemChange : function(component, event,helper){
        var selAccount = component.get("v.selItem");
        var distrId = component.get("v.selItem.Id");
        // alert(distrId);
        //var saleOrderId = component.get("v.newSalesOrder.Id");
        var isEdit = component.get("v.isEdit");
        //alert('saleOrderId--- '+saleOrderId);
        // alert(distrId);
        var shprtybtn = component.find("itemShip");
        //shprtybtn.set('v.disabled',true);
        //component.set("v.selItem5",'');
        // added by Nikhil to clear selected ship to party on customer selection...
        if(isEdit == true){
      component.set("v.selItem5", {
        sobjectType: "Shipping_Location__c",
        Name: "",
        Id: "",
        Location_Name__c: "",
      });
            helper.getShipToParty(component, event,distrId);
        }
    },
    
    //RITM0355165 - Brazil sales order enhancement to track revenue of cancel order
    handleLast24MonthOrders : function(component, event,helper){
        var checkRepSalesOrder = component.find("repSalesOrdChk");
        //component.set("v.newSalesOrder.ReplacementSalesOrderCheck",checkRepSalesOrder.get("v.value"));		   
    component.set(
      "v.newSalesOrder.Enable_cancelled_sales_order__c",
      checkRepSalesOrder.get("v.value")
    );
    console.log("Check box Last 24 months SO " + checkRepSalesOrder);
        var isSimulated = component.get("v.isSimulated");
        if(isSimulated){
            component.set("v.disableReplaceSOCheckBox",true);
        }else{
            component.set("v.disableReplaceSOCheckBox",false);
        }
        var action=component.get("c.getLast24MonthsSalesOrders");
        action.setParams({
      entityType: component.get("v.last24MonthsSalesOrder"),
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
      if (state == "SUCCESS") {
                component.set("v.Last24MonthsSalesOrdersList", a.getReturnValue());
                component.set("v.Last24MonthsSoOriginal", a.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
    },
    //RITM0355165 - Brazil sales order enhancement to track revenue of cancel order
    
    openModel: function(component, event, helper) {
        var customerPartyName=component.get("v.selItem");
    console.log("customerPartyName is ++" + customerPartyName);
        var allRecords = component.get("v.Last24MonthsSoOriginal");
        if(customerPartyName){
      var filteredRecords = allRecords.filter((rec) =>
        JSON.stringify(rec)
          .toLowerCase()
          .includes(customerPartyName.Name.toLowerCase())
      );
            component.set("v.Last24MonthsSalesOrdersList",filteredRecords);
            component.set("v.SearchLast24MonthsSalesOrdersList",filteredRecords);
      console.log("filteredRecords in MODEL ++" + filteredRecords);
    } else {
            var emptyList=[];
            
            component.set("v.Last24MonthsSalesOrdersList",emptyList);
        }
        
        component.set("v.isModalOpen", true);
    },
    
    //RITM0355165 - Brazil sales order enhancement to track revenue of cancel order
    
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    //RITM0355165 - Brazil sales order enhancement to track revenue of cancel order
    
    //RITM0355165 - Brazil sales order enhancement to track revenue of cancel order
    handleSelect: function(component, event, helper) {
        var btnValue = event.getSource().get("v.value");
        component.set("v.newSalesOrder.Cancelled_details_SO__c", btnValue.Name);
        component.set("v.isModalOpen", false);
    },
    //RITM0355165 - Brazil sales order enhancement to track revenue of cancel order
    //
    // 1. Logic to enable Maturity date if selected value flag is 'Yes' on Payment Term record
    // 2. Set No. of Days based on Payment Term which is required for calculation on Order Line Items
    
    handlePaymentTermChange : function(component, event){
        //console.log('paymentTerm: '+event.getParam("value"));
        var paymentTerm = component.get("v.paymentTerm"); //event.getParam("value");      
        var isChecked= component.get("v.CampaignCheck");//component.find("campChk").get("v.value");  
        
        if(!isChecked){
            component.set("v.isMature", "false");
            component.set("v.newSalesOrder.ReloadPaymentTerms__c", paymentTerm);
      if (paymentTerm != "None") {
                var inputCmp = component.find("paymentTermOptions");
                inputCmp.set("v.errors", null);
                $A.util.removeClass(inputCmp, "error");
                
                var paymentTermsMap = component.get("v.paymentTermsMap");
                var pmObj = paymentTermsMap[paymentTerm]; //paymentTermsMap.get(paymentTerm);
                var maturityDate = component.get("v.newSalesOrder.Maturity_Date__c");
                
                if(pmObj!=undefined){
          if (
            pmObj.Maturity_Date_Mandatory__c == $A.get("$Label.c.Yes") ||
            pmObj.Maturity_Date_Mandatory__c == "Yes"
          ) {
                        component.set("v.isMature", "true");
                        
                        /*if(maturityDate==undefined || maturityDate==null || maturityDate==''){
                        // Initialize Valid From Date to Today by default.
                        var today = new Date();
                        
                        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
                        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
                        var yyyy = today.getFullYear();
                        
                        // Custom date format for ui:inputDate
                        var validFromDate = (yyyy + "-" + MM + "-" + dd);                    
                        component.set("v.newSalesOrder.Maturity_Date__c", validFromDate);
                    }*/
          } else {
                        component.set("v.isMature", "false");
                        component.set("v.newSalesOrder.Maturity_Date__c", null);
                    }
                    component.set("v.newSalesOrder.Payment_Term__c", pmObj.Id);
                    //console.log('days: '+pmObj.Days_to_calc_interest__c);
                    component.set("v.days", pmObj.Days_to_calc_interest__c);
                }
            }
        }
    },    
    
    // 1. Logic to set Freight to '0' if selected value is FOB
    // 2. Fetch Business Rule of Sales Person (Selected User in case of SOM/SDM/Key Account) on Inco Term Change
    handleIncoTermChange : function(component, event, helper){
        var incoTerm = event.getParam("value").toString(); //component.get("v.incoTerm");
        
        if(incoTerm.includes("FOB")){
            component.set("v.businessRule.Freight__c", "0");
    } else {
            //Get Business Rule for Logged In user from helper method       
            var user = component.get("v.user"); 
            
            helper.fetchBusinessRule(component, user.Id);   
        }      
        var splitValues = incoTerm.split(",");
        component.set("v.newSalesOrder.Inco_Term__c", splitValues[1]);  
        //console.log("incoTerm split 1: "+splitValues[1]);
    },
    
    // Method to Show/Hide Additional Discount inputs if Payment Method = "Barter"
    handlePaymentMethodChange : function(component, event, helper){
        var paymentMethod = event.getParam("value"); //component.get("v.incoTerm");
        var campaignType = component.get("v.newSalesOrder.Campaign_Type__c");
    if (paymentMethod != "None" && campaignType != "Structured") {
            var inputCmp = component.find("paymentMethodOptions");
            inputCmp.set("v.errors", null);
            $A.util.removeClass(inputCmp, "error");
        }
        //if(paymentMethod!='None'){
        component.set("v.newSalesOrder.PaymentMethod__c", paymentMethod);  //splitValues[1]);
        
        var opts = component.find("paymentMethodOptions").get("v.options");        

        for(var i=0; i< opts.length; i++){
            var selectedValue = opts[i].value;
            var selectedLabel = opts[i].label;
            
            if(selectedValue==paymentMethod){
        if (selectedLabel == "Barter") {
                    component.set("v.isBarter",true);                   
        } else {
                    component.set("v.isBarter",false);
                    component.set("v.newSalesOrder.Business_Discount__c",0);
                    component.set("v.newSalesOrder.Financial_Discount__c",0);
                }                     
                break;
            }
        }
        
        //}
    },
    // Method to show/hide SOM (Extra Fields) based on selected Order Type. 
    handleOrderTypeChange : function (component, event, helper) {
        // handle value change
        //console.log("old value (Order Type): " + JSON.stringify(event.getParam("oldValue")));
        //console.log("current value (Order Type): " + JSON.stringify(event.getParam("value")));
        var opts = []; //  Added for RITM0508956 GRZ(Dheeraj Sharma) 20-02-2023 
       
        var srcId= component.get("v.CampaignCheck");//component.find("campChk").get("v.value");
    if (
      event.getParam("oldValue") != "None" &&
      event.getParam("oldValue") != "Nenhum"
    ) {
            var isOrdertype = component.get("v.isOrderNotNone");
            // var srcId= component.find("campChk").get("v.value");
            if(srcId){
                var isStructure = component.find("structCmp").get("v.value");
                if(!isOrdertype && isStructure){
          var childcmp = component.find("structComponent");
                    childcmp.destroy();    
                    //component.set("v.isOrderNotNone",false);
                } 
            }
        }
        if(event.getParam("oldValue")!=event.getParam("value")){
            var orderType = component.get("v.orderType"); //event.getParam("value");
            
            //component.set("v.selItem",null);
            var typeOrder=component.get("v.newSalesOrder.Type_of_Order__c");
            
            //alert('TypeOrder>>--->'+typeOrder);
            if(typeOrder != undefined){
                component.set("v.newSalesOrder.Type_of_Order__c", orderType);
                //alert('NewSalesOrder.OrderType>>--->'+component.get("v.newSalesOrder.Type_of_Order__c"));    
            }    
      if (orderType != "None") {
                var inputCmp = component.find("orderTypeOptions");
                inputCmp.set("v.errors", null);
                $A.util.removeClass(inputCmp, "error");
                component.set("v.isOrderNotNone",true);
            }
            
      if (orderType == "ORDEM FILHA") {
                //added by ganesh
                //var currentValue = component.get("v.selectedUser");
                //console.log('current Value '+currentValue);
                //Fetch config/data for som component from helper method       
                // helper.fetchSOM(component,currentValue);
                
                if(srcId){
                    var isStructure = component.find("structCmp").get("v.value");	
                    if(isStructure){ 
                        component.set("v.isOrdemFilha", true); 
          }
        }
                helper.fetchSOM(component);
                //fetch end
                
                component.set("v.isChild", true);
                component.set("v.isChildDisabled", true);
                component.set("v.isBonification",false);
                // component.set("v.disableOrderType_Dates_SOM_Account", true);
                //component.find("campChk").set("v.disabled",true);
                //  component.find("repSalesOrdChk").set("v.disabled",true);
                component.find("dirSaleYes").set("v.disabled",true);
                component.find("dirSaleNo").set("v.disabled",true);
                component.find("radio1").set("v.disabled",true);
                component.find("radio2").set("v.disabled",true); 
                //  component.set("v.disableReplaceSOCheckBox", true);
                component.set("v.disablePriceCurrency", true);
                component.set("v.disablePaymentMethod", true);
            }
            
            //BELOW 39 LINE WHEN TYPE OF ORDER IS BONIFICATION BY HARSHIT&ANMOL@WIPRO FOR (US SO-011) ---START
      else if (orderType == "BONIFICAÇÃO") {
                //alert("hello bonifaction");
                //added by ganesh
                //var currentValue = component.get("v.selectedUser");
                // console.log('currentValue'+currentValue);
                //Fetch config/data for som component from helper method       
                //helper.fetchSOM(component,currentValue);
                if(srcId){
                    var isStructure = component.find("structCmp").get("v.value");	
                    if(isStructure){ 
                        component.set("v.isBonification", true); 
          }
        }
                // helper.fetchSOM(component);
                helper.fetchBonification(component);
                //  helper.fetchSOM(component);
                
                //fetch end
                component.set("v.isChild", false);
                
                component.set("v.isBonification",true);
                
                //component.set("v.isChildDisabled", true);
                // component.set("v.disableOrderType_Dates_SOM_Account", true);
                //component.find("campChk").set("v.disabled",true);
                component.find("dirSaleYes").set("v.disabled",true);
                component.find("dirSaleNo").set("v.disabled",true);
                component.find("radio1").set("v.disabled",true);
                component.find("radio2").set("v.disabled",true);                
                component.set("v.disablePriceCurrency", false);
                component.set("v.disablePaymentMethod", true);
      } else {
                    //component.find("campChk").set("v.disabled",false);
                    component.find("dirSaleYes").set("v.disabled",false);
                    component.find("dirSaleNo").set("v.disabled",false);
                    component.find("radio1").set("v.disabled",false);
                    component.find("radio2").set("v.disabled",false); 
                    
                    component.set("v.isOrdemFilha", false);
                    //Punctuality Discount Patch
                    var descNo = component.find("descNo");
                    if(descNo){
                        descNo.set("v.value","true");
                    }
                    
                    var descYes = component.find("descYes");
                    if(descYes){
                        descYes.set("v.value","false");
                    }    
                    component.set("v.isPunctual","false");
                    component.set("v.newSalesOrder.Punctuality_Discount__c", "");
                    //component.set("v.newSalesOrder.Punctuality_Discount__c", 0);
                    //End 
                    
                    component.set("v.isChild", false);
                    
                    component.set("v.isBonification",false);
                    
                    component.set("v.isChildDisabled", false);
                    component.set("v.disablePaymentMethod", false);
                    
                    component.set("v.disablePriceCurrency", false);
                    // component.set("v.disableOrderType_Dates_SOM_Account", false);
                    // Set selected mother order to null
                    component.set("v.selItem3", null);
                    
                    // Assign Mother Id in Sales Order to null
                    component.set("v.newSalesOrder.Sales_Order__c", null);
                }
        }
        
        // Fetch config/data for customers component from helper method    
        // added by ganesh 
    if (orderType != "ORDEM FILHA") {
            component.set("v.isChild", false);
            component.set("v.isChildDisabled", false);
            var custbtn = component.find("custitem");
      custbtn.set("v.disabled", true);
            helper.fetchAccounts(component);
        }
        //desc :get business rule again if order type change
        var currentValue = component.get("v.selectedUser");
    if (currentValue && currentValue != "None") {
            helper.fetchBusinessRule(component, currentValue);
        }else{
            var userId = component.get("v.user.Id"); 
            helper.fetchBusinessRule(component, userId);
        }
        
        // if(orderType == 'VENDA NORMAL'){
        var srcId = component.get("v.pronutivaVal");
        
    if (srcId == "Yes") {
            component.find("dirSaleNo").set("v.value", true); 
            component.find("dirSaleNo").set("v.disabled", true); 
            component.find("dirSaleYes").set("v.disabled", true); 
            
            component.set("v.newSalesOrder.Directed_Sales__c", false);  
    } else if (srcId == "No") {
      component.find("dirSaleNo").set("v.value", "");
            component.find("dirSaleNo").set("v.disabled", false); 
            component.find("dirSaleYes").set("v.disabled", false); 
            //component.set("v.newSalesOrder.Directed_Sales__c", false);
        }    
        //component.find("radio1").set("v.value", '');
        // component.find("radio2").set("v.value", '');
        // }
        
        var srcId= component.get("v.CampaignCheck");//component.find("campChk").get("v.value");
        if(srcId){  
            var isSimple = component.find("simpCmp").get("v.value");
            var isStructure = component.find("structCmp").get("v.value");
            if(isSimple){
                component.find("simpCmp").set("v.value", true);
                component.set("v.isSimple",true); 
                component.set("v.isStructure",false);
                component.set("v.newSalesOrder.Campaign_Type__c","Simple"); 
            } 
            if(isStructure){
                component.find("structCmp").set("v.value", true);
                component.set("v.isSimple",false); 
                component.set("v.isStructure",true);
                component.set("v.newSalesOrder.Campaign_Type__c","Structured"); 
            }
        }
        //Added by Krishanu @ wipro
        helper.getMinValMaxDisc(component);
        //alert('Order Type >>--->'+component.get("v.orderType"));

   
    
        //Updated Below Condition for RITM0571431  GRZ(Dheeraj Sharma) 13-06-2023

        var orderType = component.get("v.orderType");
        opts.push({
             class: "optionClass",
             label: $A.get("$Label.c.None"),
             value: "None",
         });
         var currencyList = component.get("v.currencyList");
         console.log('getcurrency',currencyList);

          var regCode =component.get("v.regCode");  
          
          var USD_BRLCurrency=component.get("v.USD_BRLCurrencyavailable");

          console.log('USD_BRLCurrency',USD_BRLCurrency);
          
            var usdbrl = USD_BRLCurrency.split(",");
            console.log('usdbrl',usdbrl);

            for(var i=0;i<usdbrl.length;i++){
                if(usdbrl[i]==regCode){
                component.set("v.usdcheck",true);
                }
            }
            var usdchecktrue=component.get("v.usdcheck");
          console.log('usdbrlcheck',usdchecktrue);


                if( usdchecktrue==true || orderType=='ORDEM FILHA'){      //    Updated Condition for RITM0571431  GRZ(Dheeraj Sharma) 13-06-2023  


                    for (var i = 0; i < currencyList.length; i++) {
                        console.log('1');
                        var str = currencyList[i];
                        var splitValues = str.split("*");
                                
                          opts.push({
                                class: "optionClass",
                                label: splitValues[0],
                                value: splitValues[1],
                            });
                        
                    
                    }
                    console.log('opts',opts);
                    component.find("currencyOptions").set("v.options", opts);
            
                }else{

                    for (var i = 0; i < currencyList.length; i++) {
                        console.log('1');
                        var str = currencyList[i];
                        var splitValues = str.split("*");
                        if(splitValues[1]!='Billing USD / Payment BRL'){
                          opts.push({
                                class: "optionClass",
                                label: splitValues[0],
                                value: splitValues[1],
                            });
                        
                        }
                    }
                    console.log('opts',opts);
                    component.find("currencyOptions").set("v.options", opts);
                   


                }
                   //End Condition for RITM0571431  GRZ(Dheeraj Sharma) 13-06-2023
    },   
    
    // Method to fetch Price Book Details based on Order Type. 
    handlePriceListChange : function (component, event, helper) {
        // debugger;
        // handle value change
        console.log("old value (PriceList): " + event.getParam("oldValue"));
        console.log("current value (PriceList): " + event.getParam("value"));
        component.set("v.pbid",event.getParam("value"));
        var campgnTp = component.get("v.selItem3.Campaign_Type__c"); 
        var campgn= component.get("v.selItem3.Use_Campaign__c");
        var isavec = component.get("v.isAvec");
        var isChecked= component.get("v.CampaignCheck");//component.find("campChk").get("v.value");
        if(!isChecked){
            //added below codes by srikanth to handle pricebook AVEC changes. start
      var selectedPriceBookName =
        component
          .get("v.priceBooksMap")
          .filter((entry) => entry.value === event.getParam("value")).length > 0
          ? component
              .get("v.priceBooksMap")
              .filter((entry) => entry.value === event.getParam("value"))[0]
              .label
          : "";
      if (
        selectedPriceBookName != "" &&
        selectedPriceBookName != null &&
        selectedPriceBookName != undefined
      ) {
                var avecValue=selectedPriceBookName.toUpperCase();
        if (
          avecValue.indexOf("AVEC") !== -1 ||
          avecValue.indexOf("DESCONTINUADOS") !== -1
        ) {
                    //alert('in If');
                    component.set("v.disableDirectSalesNo",true);
          component.find("dirSaleYes").set("v.value", true);
                    component.set("v.newSalesOrder.Directed_Sales__c", true);
        } else {
                    //alert('in else');
                    component.set("v.disableDirectSalesNo",false);
          component.find("dirSaleYes").set("v.value", false);
                    //component.find('dirSaleNo').set('v.value',true);
                    var isDirect=component.get("v.newSalesOrder.Directed_Sales__c");
                    if(isDirect===undefined){
                        component.set("v.newSalesOrder.Directed_Sales__c", false);
                    }
                }
            }
            
            //changes for AVEC END Here by srikanth
            
            var currentValue = event.getParam("value"); //component.get("v.priceBookId"); 
      if (currentValue != "Select a price list") {
                /* var inputCmp = component.find("priceListOptions");
                inputCmp.set("v.errors", null);
                $A.util.removeClass(inputCmp, "error");*/
                var inputCmp = component.find("priceListOptions");
                if(Array.isArray(inputCmp)){
                    inputCmp[0].set("v.errors",null);
                    $A.util.removeClass(inputCmp[0], "error");
                }else{
                    inputCmp.set("v.errors",null);
                    $A.util.removeClass(inputCmp, "error");
                }
            }
            //console.log('currentValue--'+currentValue);
            //Added by Ankit to avoid setting invalid values
      if (
        currentValue != undefined ||
        currentValue != null ||
        currentValue != "None"
      ) {
                component.set("v.newSalesOrder.Price_Book__c", currentValue);
            }
            //console.log('currentValue'+currentValue);
            if(currentValue){
                console.log("currentvalue123 fetchPricebookDetails12");
                helper.fetchPriceBookDetails(component);
                console.log("currentvalue2 fetchPricebookDetails12");
                //added by Krishanu @ wipro
                helper.getPricebookCreatedDate(component);
                var orderType = component.get("v.newSalesOrder.Type_of_Order__c");
                if(isavec && orderType != "ORDEM FILHA"){
                    helper.getPBPayMent(component, event, currentValue);
                }
            } 
    } else {
            var currentValue = event.getParam("value"); //component.get("v.priceBookId"); 
            /* if(currentValue!='Select a price list'){
                var inputCmp = component.find("priceListOptions");
                inputCmp.set("v.errors", null);
                $A.util.removeClass(inputCmp, "error");
            }*/
            
            //console.log('currentValue--'+currentValue);
            //Added by Ankit to avoid setting invalid values
      if (
        currentValue != undefined ||
        currentValue != null ||
        currentValue != "None"
      ) {
                component.set("v.newSalesOrder.Price_Book__c", currentValue);
                
                // component.find("Campaign").set("v.value",currentValue);
                
                //component.set("v.campaignId",currentValue  );
                //component.set("v.priceBookId", currentValue );
                // component.find("priceListOptions").set("v.value",currentValue);
            }
            
            //var currentValue = event.getParam("value"); //component.get("v.priceBookId"); 
      console.log("currentValue", currentValue);
            
            if(currentValue){
        if (currentValue != "None") {
                    helper.getPBPayMent(component, event, currentValue);
                }
                helper.fetchPriceBookDetails(component);
                //added by Krishanu @ wipro
                helper.getPricebookCreatedDate(component);
                console.log("on handlePriceListChange1");
        console.log("currentValue****", currentValue);
            }
        }
    },
    
    // Method to populate Seller. 
    // Available for SOM/SDM/Key Account Seller & New Simulations.
    handleSellerChange : function (component, event, helper) {
    console.log("currentValue ENTRY@12");
    var TerritoryCode = "";
    var TerritoryUser = "";
    var selected = "";

        // handle value change
        //console.log("old value (handleSellerChange): " + JSON.stringify(event.getParam("oldValue")));
        //console.log("current value (handleSellerChange): " + JSON.stringify(event.getParam("value")));
        
        var currentValue = component.get("v.selectedUser"); //event.getParam("value");
console.log('currVal&&&&&&&&&&&&&'+currentValue);
       // console.log('&&&&&'+JSON.stringify(component.find("sellerOptions").get("v.options")));
        // Added by GRZ(Nikhil Verma) for RITM0422585 modified 09-09-2022
    if (component.get("v.user.Profile.Name") == "Brazil Barter Manager" || component.get("v.user.Profile.Name") == "Brazil Sales Office Manager") {	
            if(component.find("sellerOptions")){
                var selleropts = component.find("sellerOptions").get("v.options");
                if(selleropts){
                    for(var i=0; i<= selleropts.length; i++){
                    if(selleropts[i]!=undefined && currentValue!=undefined){
                        if(selleropts[i].value == currentValue){
              component.set(	
                "v.TCForBarterProcess",	
                selleropts[i].label.split("-")[0].trim()	
              );	
              component.set("v.customerRegionForSOM",selleropts[i].label.split("-")[0].trim());	// Added by GRZ(Javed) for RITM0490875 modified 03-02-2023-->
              console.log("Nikhil==>", component.get("v.TCForBarterProcess"));	
                            break;
                        }
                    }
                }
            }
        }
        }
               //-------------------End here Added by GRZ(Nikhil Verma) for RITM0422585 modified 09-09-2022
        //alert('currentValue>>>'+currentValue);
        var orderId = component.get("v.recordId");
        
        //console.log('orderId'+orderId);
        // console.log('currentValue-->'+currentValue);
        
        if(currentValue!=undefined){
      console.log("currentValue@12" + currentValue);
            selected = currentValue.split("~~");
            //alert(JSON.stringify(selected[0]+'------'+selected[1]));
            TerritoryCode = selected[1];
            TerritoryUser = selected[0];
      console.log(
        "TerritoryCode--" + TerritoryCode + "selected" + TerritoryUser
      );
            component.set("v.newSalesOrder.TM_Code__c", TerritoryCode);
            //Added by GRZ(Nikhil Verma) for INC0385117 modified 06-10-2022
            if(TerritoryCode != undefined){
                component.set("v.customerRegionForSDM", TerritoryCode); 
            }else{
                component.set("v.customerRegionForSDM","null"); 
            }
        }
        
    if (currentValue && currentValue != "None" && currentValue != "Nenhum") {
      component.set(
        "v.newSalesOrder.KeyAccountDesOwnerBrazil__c",
        TerritoryUser
      );
            //component.set("v.user.Id",currentValue); 
            helper.fetchBusinessRule(component, TerritoryUser);
            var inputCmp = component.find("sellerOptions");
      if (inputCmp != undefined) {	
                inputCmp.set("v.errors", null);
                $A.util.removeClass(inputCmp, "error");
            }	
        }
        //patch added by ganesh
    if (currentValue == "None" || currentValue == "Nenhum") {
            component.set("v.newSalesOrder.KeyAccountDesOwnerBrazil__c", null);
            //console.log('inside patchhandle selller');
            var custbtn = component.find("custitem");
      custbtn.set("v.disabled", true);
            helper.fetchAccounts(component);
        }else if(currentValue!=undefined){
            var isKeyAccount = component.get("v.newSalesOrder.Key_Account__c");
            //console.log("isKeyAccount: "+isKeyAccount);
      console.log("currentValue56@", currentValue);
            // component.set("v.newSalesOrder.OwnerId", currentValue.split("~~")[0]);
            
            //added by ganesh
            //desc: if SDM logged-in and orderId is null then based on seller selection fetch account
      if (
        isKeyAccount != true &&
        currentValue != "" &&
        currentValue != "None" &&
        !orderId
      ) {
                component.set("v.selItem",null); 
                //console.log("new selection");
                component.set("v.newSalesOrder.Sold_to_Party__c", null);
                var custbtn = component.find("custitem");
        custbtn.set("v.disabled", true);
                helper.fetchAccounts(component);
            }
      if (isKeyAccount || (currentValue != "" && currentValue != "None")) {
                component.set("v.selItem",null);
                //console.log("==");
                if(!orderId){
                    // Assign null to accountId attribute
                    // console.log("record ID"+orderId);
                    component.set("v.newSalesOrder.Sold_to_Party__c", null);
                    var custbtn = component.find("custitem");
          custbtn.set("v.disabled", true);
                }
                // Assign null to accountId attribute
                //component.set("v.newSalesOrder.Sold_to_Party__c", null);
                //var custbtn = component.find("custitem");
                //custbtn.set('v.disabled',true);
                // Fetch config/data for customers component from helper method        
                helper.fetchAccounts(component);
      } else {
                // console.log("isKeyAccount false: Set Owner Id");
                //component.set("v.newSalesOrder.OwnerId",TerritoryUser);
            }
        }
          },
    
    handleCampaignChange : function(component, event, helper){
        //console.log('handleCampaignChange called .... ');
        var pb_id = component.get("v.campaignId"); 
        //alert(pb_id);
    if (pb_id != "None") {
            component.set("v.newSalesOrder.Price_Book__c",pb_id);
            helper.getPBPayMent(component, event, pb_id);
            helper.fetchPriceBookDetails(component);
        }
    },
    
    handlePaymentTermChangeDay : function(component, event){
        //console.log('handlePaymentTermChangeDay called..');
        var opts=[];
        opts=[];
    opts.push({
      class: "optionClass",
      label: $A.get("$Label.c.None"),
      value: "None",
    });
        var paymentTermsMapDT = component.get("v.paymentTermsMapDT");
        for (var key in paymentTermsMapDT){
      if (key != "null") {
        opts.push({ class: "optionClass", label: key, value: key });
            }
        }
        var payBR= component.get("v.paymentTermBR71"); 
        
        if(payBR!=null){
      var val = payBR.Payment_Term_Code__c + " " + payBR.Payterms_Desc__c;
      opts.push({ class: "optionClass", label: val, value: val });
            component.set("v.paymentTermBR71", payBR);
        }
        
        //console.log('Payment Terms Date:'+JSON.stringify(opts));
        component.set("v.paymentTermsMapDT", paymentTermsMapDT);
        component.find("payTmDt").set("v.options", opts);

        var paymentTerm = component.get("v.paymentTermDY");  
        // alert(paymentTerm);
        //console.log('paymentTerm ----> '+paymentTerm);       
        component.set("v.isMature", "false");
        component.set("v.newSalesOrder.ReloadPaymentTerms__c", paymentTerm);
        //alert('at 3160=='+paymentTerm);
    if (paymentTerm != "None") {
            var inputCmp = component.find("payTmdy");
            inputCmp.set("v.errors", null);
            $A.util.removeClass(inputCmp, "error");
            
            var paymentTermsMap2 = component.get("v.paymentTermsMapDY"); //chng
            //alert('paymentTermsMap2== 3168'+paymentTermsMap2);
            //console.log('paymentTermsMap2 ----> '+JSON.stringify(paymentTermsMap2));
            var pmObj = paymentTermsMap2[paymentTerm]; 
            var obj2 = new Object();
            obj2=  JSON.stringify(pmObj);
            var maturityDate = component.get("v.newSalesOrder.Maturity_Date__c");
            
            if(pmObj!=undefined){
        if (
          pmObj.Maturity_Date_Mandatory__c == $A.get("$Label.c.Yes") ||
          pmObj.Maturity_Date_Mandatory__c == "Yes"
        ) {
                    // component.set("v.isMature", "true");
        } else {
                    // component.set("v.isMature", "false");
                    component.set("v.newSalesOrder.Maturity_Date__c", null);
                }
                
                component.set("v.newSalesOrder.Campaign_Payment_Term_Date__c", null);
                component.set("v.newSalesOrder.Payment_Term__c", pmObj.Payment_Term__c);
                
                component.set("v.newSalesOrder.Campaign_Payment_Term__c", pmObj.Id);
                //console.log('days: '+pmObj.Payment_Term__r.Days_to_calc_interest__c);
                //alert('pay '+pmObj.Payment_Term__r.Days_to_calc_interest__c);
                component.set("v.days", pmObj.Payment_Term__r.Days_to_calc_interest__c);
            }
        }
    },
    
    handlePaymentTermChangeDate : function(component, event){
        var opts=[];
        opts=[];
    opts.push({
      class: "optionClass",
      label: $A.get("$Label.c.None"),
      value: "None",
    });
        var paymentTermsMap = component.get("v.paymentTermsMapDY"); //chng
        
        for (var key in paymentTermsMap){
      if (key != "null null") {
        opts.push({ class: "optionClass", label: key, value: key });
            }
        }     
    console.log("Payment Terms:" + JSON.stringify(opts));
        component.set("v.paymentTermsMapDY", paymentTermsMap);
        component.find("payTmdy").set("v.options", opts);
        
        var paymentTerm = component.get("v.paymentTermDT"); 
        
        // alert(paymentTerm);       
        component.set("v.isMature", "false");
        //component.set("v.newSalesOrder.ReloadPaymentTerms__c", paymentTerm);
    if (paymentTerm != "None") {
      if (paymentTerm == "BR71 INFORMAR VENCIMENTO") {
                component.set("v.isMature", "true");
                component.set("v.newSalesOrder.Campaign_Payment_Term_Date__c",null);
        console.log("The BR71 INFOR is");
      } else {
                var inputCmp = component.find("payTmDt");
                inputCmp.set("v.errors", null);
                $A.util.removeClass(inputCmp, "error");

                var paymentTermsMap1 = component.get("v.paymentTermsMapDT");
                var pmObj = paymentTermsMap1[paymentTerm]; 
                var maturityDate = component.get("v.newSalesOrder.Maturity_Date__c");
                if(pmObj!=undefined){
                    component.set("v.isMature", "false");
                    // component.set("v.newSalesOrder.Maturity_Date__c", paymentTerm);                                
                    //component.set("v.newSalesOrder.Campaign_Payment_Term_Date__c", pmObj.Payment_Term_in_Date__c);
                    
          component.set(
            "v.newSalesOrder.Campaign_Payment_Term_Date__c",
            paymentTerm
          );
                    component.set("v.newSalesOrder.Campaign_Payment_Term__c", pmObj.Id);
          console.log("The BR71 INFOR is else");
                    //console.log('days: '+pmObj.Payment_Term__r.Days_to_calc_interest__c);
                    // component.set("v.days", pmObj.Payment_Term__r.Days_to_calc_interest__c);
                }
            }
        }
    },
    openTable : function(component, event, helper){
        var campaignId = component.get("v.newSalesOrder.Price_Book__c");
        var orderId = component.get("v.newSalesOrder.Id");
        var orderType = component.get("v.newSalesOrder.Type_of_Order__c");
        
        component.set("v.isLoadData",helper.validateOrder(component));
        var blkDate= component.get("v.blockDate");
        var today = new Date();
    var dd = (today.getDate() < 10 ? "0" : "") + today.getDate();
    var MM = (today.getMonth() + 1 < 10 ? "0" : "") + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        
        // Custom date format for ui:inputDate
    var currentDate = yyyy + "-" + MM + "-" + dd;
        
        //Initialize validation flag to false
        var flag = false;
        var blkFlag= true;
    if (blkDate != null || blkDate != "") {
            if(blkDate<currentDate){
                component.set("v.isLoadData",false);
                var toastEvent = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Block_Date_Reached}");
                var titl  = $A.get("{!$Label.c.Error}");
                toastEvent.setParams({
          title: titl,
          type: "error",
          message: msg,
                });
                toastEvent.fire();
                component.find("Campaign").focus();
            }
        }
        if(component.get("v.isLoadData")){
            component.set("v.showSpinner",true);    
            //component.find("campChk").set("v.disabled",true); 
            
            component.find("orderTypeOptions").set("v.disabled",true); 
            component.set("v.disableOrderType_Dates_SOM_Account",true);
            component.find("simpCmp").set("v.disabled",true);
            component.find("structCmp").set("v.disabled",true);
            component.find("radio1").set("v.disabled",true);
            component.find("radio2").set("v.disabled",true);
            component.find("itemShip").set("v.disabled",true);
            
            //alert('orderType>>--->'+orderType);    
      if (orderType != "ORDEM FILHA") {
                component.set("v.isChild", false);  
            }
            //if(orderType=='VENDA NORMAL'){
            component.find("dirSaleYes").set("v.disabled",true);
            component.find("dirSaleNo").set("v.disabled",true);
            // }
            var keyAcc=component.get("v.showKeyAccount");
            if(keyAcc){
                component.find("keyYes").set("v.disabled",true);
                component.find("keyNo").set("v.disabled",true); 
            }
            
            component.set("v.disablePriceCurrency",true);
            component.set("v.disableThis",true);
            helper.fetchStructureCampaign(component, event,campaignId,orderId);        
        }else{
      var toastMsg = $A.get(
        "$Label.c.Please_provide_valid_input_fill_all_the_mandatory_fields_before_proceeding"
      );
            helper.showErrorToast(component, event, toastMsg);
        }
        //component.set("v.isLoadData",true);
        var clsbtn = component.find("clsTbl");
        $A.util.removeClass(clsbtn,"hide");  
        var opnbtn = component.find("opntbl");
        $A.util.addClass(opnbtn,"hide");
        var isPronutiva = component.get("v.newSalesOrder.Pronutiva__c");
    console.log("isPronutiva>>--->" + isPronutiva);
        if(isPronutiva){
            component.find("radio1").set("v.checked",true);
            component.find("radio2").set("v.checked",false);
      console.log(
        "isPronutiva if>>--->" + component.find("radio1").get("v.value")
      );
        }else{
            component.find("radio1").set("v.checked",false);
            component.find("radio2").set("v.checked",true); 
        } 
    },
    handleFilesChange : function(component, event, helper) {
        var file = component.find("fileId");
        var fileName = component.find("fileId").get("v.files");
        
        if(file.get("v.files") == null){
            flag = false;
            component.set("v.noFileError",false);
            //file.set('v.validity', {valid:false, badInput:true});  
            //component.set("v.fileName",$A.get("$Label.c.Please_select_file"));
            var errormsg = $A.get("$Label.c.Please_select_file");
            helper.showWarningToast(component, event, errormsg);
            //file.showHelpMessageIfInvalid();
        }else{
            //
            //alert(fileName[0].type);
      if (
        fileName[0].type.includes("/vnd.ms-excel") ||
        fileName[0].type.includes("/pdf") ||
        fileName[0].type.includes("spreadsheetml")
      ) {
                component.set("v.noFileError",true);				           
                component.set("v.fileName",fileName[0].name);
                // component.set("v.optSimStructFile",fileName[0]);
            }else{
                component.set("v.noFileError",false);
                var errormsg = $A.get("$Label.c.Please_select_Correct_file");
                helper.showWarningToast(component, event, errormsg);
                //component.set("v.fileName",$A.get("$Label.c.Please_select_Correct_file"));
                component.find("fileId").set("v.value", []);
            }
            
            //file.set('v.validity', {valid:true, badInput:false});    
        }
    },
    closeTable : function(component, event, helper) {
        var opnbtn = component.find("opntbl");
        $A.util.removeClass(opnbtn, "hide");  
        var clsbtn = component.find("clsTbl");
        $A.util.addClass(clsbtn, "hide");
        component.set("v.isLoadData",false);
    },
    structureConfirmDialog : function(component,event,helper){
        var selected = event.getSource().get("v.label");  
        
    var childcmp = component.find("structComponent");
        var returnValue = childcmp.saveOrder();
        var temp =  component.get("v.newSalesOrder");
        
        if(returnValue == true){
            //alert(selected);
            component.set("v.disableSaveStruct",true);
            component.set("v.disableEditStruct",true);
            
            if(selected==$A.get("$Label.c.Submit")){
                component.set("v.isDraft", false);
                //component.set("v.showSpinner",true);
                
                helper.saveStructureSalesOrder(component, event, "Submitted");
      } else {
                component.set("v.isDraft", true);
                
                helper.saveStructureSalesOrder(component, event, "Draft");
                //alert('parent'+component.get("v.recordId"));
            } 
        }else{
        } 
        
        //alert('call'+orderId);        
        //console.log('-------OrderRequest3 JSON---------');   
        //console.log(JSON.parse(JSON.stringify(component.get("v.structureCampWrapDetail.lstStructOrderLineItem"))));    
    },
    editStructureForm:function(component,event,helper){
    var childcmp = component.find("structComponent");
        childcmp.editOrder();
    },
    
    backToList:function(component,event,helper){
        var profileName = component.get("v.orderFields.userObj.Profile.Name");
    var fullUrl = "";
    var defType = "";
        var rcdTp = component.get("v.recordType");
        //console.log('flagIm'+flagIm+'profileName'+profileName);
        if(rcdTp == "Simulation"){
            var fullUrl = "/apex/SimulationOrderEnhancedView";
            helper.gotoURL(component,fullUrl);
    } else {
      if (profileName == "Brazil Sales Person") {
                fullUrl = "/apex/BrazilEnhancedListForSP?defType="+defType;
                helper.gotoURL(component, fullUrl);
      } else if (profileName == "Brazil Sales District Manager") {
                fullUrl = "/apex/BrazilEnhancedListForSDM?defType="+defType;
                helper.gotoURL(component, fullUrl);
      } else if (profileName == "Brazil Sales Office Manager") {
                    fullUrl = "/apex/BrazilEnhancedListForSOM?defType="+defType;
                    helper.gotoURL(component, fullUrl);
      } else if (profileName == "Brazil Sales Director") {
                        fullUrl = "/apex/BrazilEnhancedListForSD?defType="+defType;
                        helper.gotoURL(component, fullUrl);
      } else if (profileName == "Brazil Regional Head") {
                            fullUrl = "/apex/BrazilEnhancedListForREH?defType="+defType;
                            helper.gotoURL(component, fullUrl);
                        }
        }
    },
    handleshowOnReload:function(component,event,helper){
        var orderId =component.get("v.recordId") ;
        //var childcmp = component.find('structComponent'); 
        //childcmp.loadcalculations(orderId);
    },
    
    //added for RITM0222939 by Priya  <!--3636-3638 lines added for Deal Scoring-->
    handleRowAction: function (component, event, helper) {
        var ordertype = component.find("orderTypeOptions").get("v.value"); 
    var action = event.getParam("action");
    var itemRow = event.getParam("row");
        var isSimulated = component.get("v.isSimulated");
        var isAvec = component.get("v.isAvec");
        var ordercustomer=itemRow.Id;
    console.log("customer*** - " + ordercustomer);
        //added by Sagar for Deal Scoring
        component.set("v.ordercustomer11",ordercustomer);
    console.log("Account Id Selected - " + itemRow.Id);
    console.log("Account Id Selected - " + component.get("v.accountList"));
    console.log(
      "Account Id Selected - " + JSON.stringify(component.get("v.accountList"))
    );
        component.set("v.customerId",itemRow.Id);
        var selCurrncy = component.get("v.selectedCurrency");
    console.log("selCurrncy - " + selCurrncy);
        var isChecked= component.get("v.CampaignCheck");//component.find("campChk").get("v.value");
    console.log("isChecked - " + isChecked);
        var unitVal = 0;
        var minVal = 0;
        var fSPVal =0;
        var monthlyInterestRate = 0;
    if (selCurrncy == "Billing BRL / Payment BRL") {
            unitVal = itemRow.unitValueBRL;
            minVal = itemRow.minValueBRL;
            monthlyInterestRate = itemRow.monthlyInterestRateBRL;
            fSPVal = itemRow.budgetValueBRL;
    } else if (
      selCurrncy == "Billing USD / Payment BRL" ||
      selCurrncy == "Billing USD / Payment USD"
    ) {
                unitVal = itemRow.unitValueUSD;
                minVal = itemRow.minValueUSD;
                monthlyInterestRate = itemRow.monthlyInterestRateUSD;
                fSPVal = itemRow.budgetValueUSD;
            }
        component.set("v.selItem",itemRow);
        
        //Assign accountId to Sales Order record attribute
        component.set("v.newSalesOrder.Sold_to_Party__c", itemRow.Id);
    component.set(
      "v.newSalesOrder.Program_Margin_Discount__c",
      itemRow.Program_Margin_Discount__c
    );
        //console.log('Account Id Selected - ' +itemRow.Id);
        helper.closePopUp(component);
        helper.fetchPriceBookDetails(component);
        helper.getPriceListVal(component,event,isSimulated,ordertype);
        //-----------Added on 3/6/2021 for SCTASK0488718--------------
    helper.getCustomerConversionFactor(component, itemRow.Id, itemRow.skuDescription);
        helper.getConversionFactorValue(component, itemRow.Id);			
        helper.getTaxAndFreight(component);                     // SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.......
        var customerName = component.find("customerName");
        customerName.set("v.errors",null);
        $A.util.removeClass(customerName, "error");
    },
    
    //RITM0355165 - Brazil sales order enhancement to track revenue of cancel order
    searchTables: function (component, event, helper) {
        var allRecords = component.get("v.SearchLast24MonthsSalesOrdersList");
    console.log("Last24MonthsSoOriginal ************ **" + allRecords);
        
        //  var searchFilter = event.getSource().get("v.value");
        var searchTerm=component.get("v.searchTerm");
        
        if(searchTerm.length > 1){
      var filteredRecords = allRecords.filter((rec) =>
        JSON.stringify(rec).toLowerCase().includes(searchTerm.toLowerCase())
      );
            
            component.set("v.Last24MonthsSalesOrdersList",filteredRecords);
      console.log("filteredRecords  **" + filteredRecords);
    } else {
            component.set("v.Last24MonthsSalesOrdersList",allRecords);
      console.log("filteredRecords  **" + filteredRecords);
        }
    },
    //RITM0355165 - Brazil sales order enhancement to track revenue of cancel order
    
    //added by Priya for RITM0222939
    searchTable: function (component, event, helper) {
        var allRecords = component.get("v.accountData");
        var searchFilter = event.getSource().get("v.value").toUpperCase();
        
        var tempArray = [];
        var i;
        
        for(i=0; i < allRecords.length; i++){
      if (
        (allRecords[i].SAP_Code__c &&
          allRecords[i].SAP_Code__c.toUpperCase().indexOf(searchFilter) !=
            -1) ||
        (allRecords[i].Name &&
          allRecords[i].Name.toUpperCase().indexOf(searchFilter) != -1) ||
        (allRecords[i].Customer_Group__c &&
          allRecords[i].Customer_Group__c.toUpperCase().indexOf(searchFilter) !=
            -1) ||
        (allRecords[i].BillingCity &&
          allRecords[i].BillingCity.toUpperCase().indexOf(searchFilter) !=
            -1) ||
        (allRecords[i].Customer_Region__c &&
          allRecords[i].Customer_Region__c.toUpperCase().indexOf(
            searchFilter
          ) != -1) ||
        (allRecords[i].Tax_Number_1__c &&
          allRecords[i].Tax_Number_1__c.toUpperCase().indexOf(searchFilter) !=
            -1) ||
        (allRecords[i].Tax_Number_3__c &&
          allRecords[i].Tax_Number_3__c.toUpperCase().indexOf(searchFilter) !=
            -1)
      ) {
                tempArray.push(allRecords[i]);
            }
        }
        
        component.set("v.accountList",tempArray);
    },   //added by Sagar for Deal Scoring
    productcodevalidate : function(component, event, helper){ 
        //new code
        var orderItemList1 = component.get("v.orderItemList");
    console.log("orderItemList1" + JSON.stringify(orderItemList1));
        /*var action = component.get("c.totalrepcostlogic");
        action.setParams({ 
            "salesOrderItemString": JSON.stringify(orderItemList1)
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            var toastMsg = '';
            console.log('res**',a.getReturnValue()); 
            console.log('resstate**',a.getState()); 
            if (state == "SUCCESS") {
                console.log('SUCCESS**'); 
                component.set("v.orderItemList",a.getReturnValue());
                var List5 =component.get("v.orderItemList");
       		    console.log('**orderItemList**'+JSON.stringify(List5));
                console.log('TestRes**',a.getReturnValue());  
            }
            else{
             console.log('TestResError**',a.getError());     
            }
        });
        $A.enqueueAction(action);
		//*/
            
            var newSO = component.get("v.newSalesOrder");
    console.log("Create Order newSO>>--->" + JSON.stringify(newSO));
            var orderItemList = component.get("v.orderItemList");
         component.set("v.orderItemListDDSRecal",orderItemList);
    console.log("orderItemList" + JSON.stringify(orderItemList));
            var List =component.get("v.productCodeList");
            var ordercustomer =component.get("v.ordercustomer11");
    console.log("ordercustomer" + JSON.stringify(ordercustomer));
            //Updated by Rakesh K G Ticket INCTASK0917680
            //if we edit the add product section then we need to get the below values.Since we are getting sellerId as null and ordercustomer as null 
            if(!ordercustomer){
                var clientSAPCode = component.get("v.selItem.SAP_Code__c");
                var clientName = component.get("v.selItem.Name");
                var accList = component.get("v.accountList");
      accList.forEach((ele) => {
                    if(ele.Name === clientName && ele.SAP_Code__c === clientSAPCode){
          console.log("The Ele", ele);
                    ordercustomer = ele.Id;
                }
      });
            }
            var userId = component.get("v.userId");
            //END
            var sellerid = component.get("v.sellerID");
            //Updated by Rakesh K G Ticket INCTASK0917680
    var sellerId1 = component.get(
      "v.newSalesOrder.KeyAccountDesOwnerBrazil__c"
    );
            if(!sellerId1 && !sellerid){
                sellerid = userId;
            }
            //END
    console.log("selleridOrg**" + sellerid);
    console.log("ordercustomer123" + JSON.stringify(ordercustomer));
            var action = component.get("c.dealScoringValidCall");
            action.setParams({ 
      soObj: newSO,
      salesOrderItemString: JSON.stringify(orderItemList),
      customer1: ordercustomer,
      sellerid: sellerid,
            });
            component.set("v.showSpinner", true);
            action.setCallback(this, function(a) {
                var state = a.getState();
      var toastMsg = "";
      console.log("res**", a.getReturnValue());
      console.log("resstate**", a.getState());
                component.set("v.showSpinner", false);
                if (state == "SUCCESS") {
        console.log("SUCCESS**");
                    //dealscoringres
                    // component.set("v.dealscoringres",a.getReturnValue());
                    //  var List3 =component.get("v.dealscoringres");
                    //console.log('dealscoringres**'+JSON.stringify(List3));
                    
                    component.set("v.orderItemList",a.getReturnValue());
                    
                    var List4 =component.get("v.orderItemList");
        console.log("**orderItemList**" + JSON.stringify(List4));
                    
                    // var test=JSON.parse(a.getReturnValue());
        console.log("TestRes**", a.getReturnValue());
                    
                    //Added by sagar for API Error toast msg 
                    var isAPIError = false;
                    for(var i=0;i<List4.length;i++){
          if (List4[i].DDSApiErrMsg === "Error While Exectuting the model") {
            console.log("The error is Entry");
                            isAPIError = true;
                        }
                    }
                    
                    if(isAPIError == true){
                        var toastEvent11 = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.DDS_API_Call_Error}");
                        var titl  = $A.get("{!$Label.c.Deal_Scoring}");
                        //Updated by Rakesh K G Ticket INCTASK0917680
                        if(toastEvent11 !=undefined){
                            toastEvent11.setParams({
              title: titl,
              type: "error",
              message: msg,
                                //"duration":'3000'
                            });
                            //console.log('The error is Entry2314');
                            toastEvent11.fire();
                            return;
                        }
                        //Updated by Rakesh K G Ticket INCTASK0917680
                        else{
            alert(titl + ": " + msg);
                        }
                    } 
                }else {                             
        console.log("TestResError**", a.getError());
                }
            });
            $A.enqueueAction(action);
  },
});