({
    
    
    // Init method to initalize default values in form on component load. 
    doInit: function(component, event, helper) {
        /* ---------- Start SKI(Paresh S) : #CR152 : PO and Delivery Date : 29-09-2022 ------- */
		var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
    	component.set('v.newSalesOrder.Purchase_Order_Date__c', today);
		/* ----------- End SKI(Paresh S) : #CR152 : PO and Delivery Date : 29-09-2022 --------- */      
        //try{
        var forClones = component.get("v.forClone");
        console.log('change donint handler in do '+forClones);
        
        helper.getSOSTP(component);
        
        //window.setTimeout($A.getCallback(function() {helper.getSOSTP(component);}),2000 );
        helper.getUserInfo(component,event,helper);
        window.setTimeout($A.getCallback(function() {helper.getOrderFieldss(component,event,helper);}),2000 );
        window.setTimeout($A.getCallback(function() {helper.gettingDiscount(component,event,helper);}),2000 ); 
        if(forClones=='cloneOrder'){
            //component.set('v.disableThisConfirm',false);
            
            // helper.editForm(component,event);
        }
        // }
        // catch(err){
        //   console.log('Error msg '+err.message);
        
        // }
        
        
        
    }, 
    /* ------------- Start SKI(Paresh S) : #CR152 : PO and Delivery Date : 29-09-2022 ----------- */
    closeDateModel:function(component, event, helper) {
      // Set isModalOpen attribute to false  
      console.log('close modal');
      component.set("v.isModalOpen", false);
   	},
    /* ------------------ End SKI(Paresh S) : #CR152 : PO and Delivery Date : 29-09-2022 ------------ */
    /* ------------------- Start SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022 ----------- */
    changeDeliveryDate:function(component, event,helper){
        //alert('On Date Change');              
        var target = event.getSource();
        var inp = target.get("v.value");
        //console.log('Enter customer Date '+inp);
        //alert('inp' +inp);
        const today = new Date();
        let tomorrow =  new Date();
        //alert('tomorrow' +tomorrow);  
        //RITM0459627-Added by Nandhini to allow user select the delivery date from Today+5 days
        var todaysDate=new Date();
        todaysDate.setDate(todaysDate.getDate() + 5);
        var todayPlusFive=$A.localizationService.formatDate(todaysDate, "YYYY-MM-DD");
        //alert('todayPlusFive' +todayPlusFive);
        tomorrow.setDate(today.getDate() + 1);
        var tmrro = $A.localizationService.formatDate(tomorrow, "YYYY-MM-DD");
       // alert('tmrro' +tmrro);
        var loginCountry = component.get("v.loginCountryObjs");
        var device = $A.get("$Browser.formFactor");
//check with Vaishnavi
        if(loginCountry.Delivery_Date__c==true && inp==null){
            if(device!='DESKTOP'){
                var toastMsg = $A.get("$Label.c.Customer_Delivery_Date_should_not_be_empty");
                helper.showErrorToast(component, event, toastMsg);
            }else{
                alert($A.get("$Label.c.Customer_Delivery_Date_should_not_be_empty")); 
            }
           
            target.set("v.value",todayPlusFive);//RITM0459627-Added by Nandhini to automatically map Today+5 days when user enters other than date
        }else{
            if(inp< $A.localizationService.formatDate(todaysDate, "YYYY-MM-DD")){
               if(device!='DESKTOP'){
                    var toastMsg = $A.get("$Label.c.Customer_Delivery_Date_should_be_future_date_only");
                    helper.showErrorToast(component, event, toastMsg);
                }else{
                    alert($A.get("$Label.c.Customer_Delivery_Date_should_be_future_date_only"));
                }
                target.set("v.value",'');
            }else{
                target.set("v.value",inp);
                //Added By Paresh Sondigara #CR152
                var showModal = component.get("v.isCommunityUser");                
                if(showModal){                    
                    component.set("v.isModalOpen", true);                    
                }
                //Ended By Paresh Sondigara #CR152 
            }   
        }       
    },
    /* ------------------------ End SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022 --------------------- */
    
    // Logic to handle shipping changs 
    handleShipLocChange : function(component, event){
        var shippingLoc = component.get("v.shippingLoc");
        
        
        if(shippingLoc!='None'){
            var inputCmp = component.find("shippListOptions");
            inputCmp.set("v.errors", null);
            $A.util.removeClass(inputCmp, "error");
            var ShippingLocMap = component.get("v.ShippingLocMap");
            var slObj = ShippingLocMap[shippingLoc];
            
            if(slObj!=undefined){
                component.set("v.newSalesOrder.Ship_To_Party__c", slObj.Id);
                
                
                component.set("v.newSalesOrder.OwnerId",slObj.OwnerId);
                component.set("v.selItem", slObj);
                component.set("v.newSalesOrder.Shipping_Notes__c",slObj.Shipping_Notes__c); 
                var temp = component.get("v.selItem");
                
            }
            
            
        }else{
            
            component.set("v.selItem", '');
            component.set("v.newSalesOrder.Ship_To_Party__c", '');
            component.set("v.newSalesOrder.OwnerId",null);
            component.set("v.newSalesOrder.Shipping_Notes__c",'');
        }
    },
    
    
    //handler for Inco term
    handleIncoTermChange: function(component, event,helper){
        var inctcode = component.get("v.incoTrm");
        console.log('inctcode '+inctcode);
        if(inctcode!='None'){
            helper.getInctrmCode(component,event,helper,inctcode);
            component.set("v.showDynamicCompo",true);
            console.log('in changeing on inco term');
            var SingleOrder = component.get("v.SingleOrderItem");
            console.log('SingleOrder @@@@ '+SingleOrder);
            if(SingleOrder!=null){
                console.log('null not available');
                component.find("skuId").makeReset(false);
            }
            var forClones = component.get("v.forClone");
            if(forClones=='cloneOrder'){
                console.log('inside inco term null clone');
                component.set("v.orderItemList",[]);
            }
            
            
        }else{
            component.set("v.showDynamicCompo",false);
            var SingleOrder = component.get("v.SingleOrderItem");
            console.log('SingleOrder @@@@ '+SingleOrder);
            if(SingleOrder!=null){
                console.log('null not available');
                component.find("skuId").makeReset(false);
            } 
        }
        
    },
    
    
    // Logic to show Product Selection Modal        
    openPriceDeatilsPopUp : function(component, event, helper) {
        
        var incotrm = component.get("v.incoTrm");
        var flg = true;
        if(incotrm=='None'){
            component.find("incoTermListOptions").set("v.errors",[{message: $A.get("$Label.c.Please_Select_Inco_Terms")}]); 
            flg = false;
        }else{
            flg = true;
        }
        
        
        
        if(flg){   
            var target = event.getSource();  
            var rowIndexValue = target.get("v.value");
            
            component.set("v.modalHeader", $A.get("$Label.c.Products"));
            component.set("v.rowIndex",rowIndexValue);
            var pricedata = component.find("pricedata1");
            $A.util.removeClass(pricedata, 'slds-hide');
            helper.toggle(component);
            
        }
    },  
    
    //Logic to hide all selection modals    
    closePopUp : function(component, event, helper) {
        helper.closePopUp(component);
    }, 
    
    //Event used to get selected row from 'Lightning Data Table' Component 
    tabActionClicked: function(component, event, helper){
        
        
        
        var actionId = event.getParam('actionId');
        
        //get the row where click happened and its position
        var itemRow = event.getParam('row');
        
        var tmIvento = component.get("v.isInventoryHide");
        if(tmIvento== true){
            helper.gettingInventory(component,event,helper,itemRow.skuId);          
        }
        
        
        
        var paymentTem = itemRow.PaymentTermId;
        
        
        component.set("v.paymenttrm",paymentTem);
        //component.set("v.disableThisPaymentTerm",false);
        
        
        if(actionId == 'selectproduct'){
            // component.set("v.disabledSOI", false);
            var orderItemList = component.get("v.orderItemList");
            
            component.set("v.SingleOrderItem",itemRow);
            
            //component.set("v.SingleOrderItem.productCode",itemRow.skuCode) ;
            
            
            var discnt = component.get("v.discount");
            
            
            var stDate = Date.parse(component.get("v.startDate"));
            var edDate = Date.parse(component.get("v.endDate"));
            
            
            
            
            var currentDate = new Date();
            var pCurdate = Date.parse(currentDate);
            
            
            if(pCurdate>=stDate && pCurdate<=edDate){
                //getting 3% discount
                
                component.set("v.SingleOrderItem.earlyOrderDiscount",discnt);
            }else{
                //getting o% discount
                
                component.set("v.SingleOrderItem.earlyOrderDiscount",0);
            }
            
            helper.closePopUp(component);
            
            
        } 
        
        
        
        
    },
    //  changes made by Srinivas for the ticket INC0300621
    //  Redy to move
     checkPoNumberLength: function(component, event, helper){
          var PoNumber = component.get("v.newSalesOrder.PONumber__c");
         if(PoNumber.length>=36){
             var toastMsg= "Przepraszamy ale numer zamówienia nie może być dłuższy niż 36 znaków";
			
			 helper.showErrorToast(component, event, toastMsg);
         }
      },
    //Validation on Quantity Input
    restrictQuantity1: function(component, event, helper){
       // alert('in quantity method');
        var target = event.getSource();  
        var qty = target.get("v.value");
        console.log('quantity:'+qty);
        var errorMessage = '';
        var warningMessage = '';
        if(qty){
            var qtyString = qty.toString(); //Convert to string
            console.log('converted quantity:'+qtyString);
            if(qtyString!=''){
                qty = parseFloat(qtyString.replace("-", "")); //Replace negative sign
                target.set("v.value",qty);
                
                //var multipleOf = target.get("v.placeholder");
                var multipleOf = component.get("v.SingleOrderItem.multipleOf");
                console.log('multiple of:'+multipleOf);
                var flag = false;
                var modValue = (qty%multipleOf).toFixed(2);
                console.log('mod val:'+modValue);
                // var modValue = (qty%multipleOf);
                
                if(multipleOf && modValue!=0){
                    console.log('multipleOf && modValue!=0');
                    if(modValue != multipleOf){
                        console.log('entering modValue != multipleOf');
                        flag = true;
                        warningMessage= $A.get("$Label.c.Qty_should_be_in_multiple_of")+" "+multipleOf+". ";
                        component.set('v.MultipleOfDialogMessage',warningMessage);
                        helper.toggleMultipleOfDialog(component);
                    }
                    //changes made by Abhimanyu for the ticket INC0292723
                    else if(modValue == multipleOf) {
                        var modValue2 = (modValue%multipleOf).toFixed(2); 
                        console.log('mod val2:'+modValue2);
                        if(modValue2 == 0) {
                            helper.updateRowCalculations1(component, event, helper,qty);
                        }
                    }
                }else{
                    console.log('into else');
                    helper.updateRowCalculations1(component, event, helper,qty);     
                    
                }
                
                target.set("v.errors", null); 
                $A.util.removeClass(target, "error");
                
            }
            
        }else{
            errorMessage= $A.get("$Label.c.Please_enter_Quantity");
            target.set("v.errors", [{message:errorMessage}]);
            $A.util.addClass(target, "error");
        }
    },
    
    NoMultiplyOf: function(component, event, helper){
        var qty = component.find("itemqty1");
        var errorMessage = '';
        var warningMessage = '';
        if(qty){
            qty.set("v.value",0);
            //helper.updateRowCalculations1(component, event, helper); 
            helper.toggleMultipleOfDialog(component);
        }
    },
    
    
    NobigLogDiscout :function(component, event, helper){
        helper.toggleshowModalBigLogDisDialog(component);
    },
    
    
    
    NoMultiplyOf1 :function(component, event, helper){
        var qtySOLI = component.get("v.qtySOLI");
        var orderItemList = component.get("v.orderItemList");
        var qtIndex=component.get('v.qtyIndexSOLI');
        var qty = component.find("itemqty");
        var errorMessage = '';
        var warningMessage = '';
        orderItemList[qtIndex].qty=0;
        //qty.set("v.value",0);
        //helper.updateRowCalculations(component, event, helper);
        helper.toggleMultipleOfCartDialog(component);
        
        
    },
    
    
    //method to delete all Order Line Item Data From Cart
    deleteAllItem : function(component, event, helper) {
        var orderId = component.get("v.orderObjId");
        var action = component.get("c.deleteOrderItems");
        var soId = component.get("v.sOId");
        var toastMsg ='';
        var errorMessage ='';
        
        //console.log('In delete all Item in Sales Order soId '+orderId);
        
        if(orderId!=null && orderId!='' && orderId!= undefined){
            action.setParams({
                orderId : orderId
            });
            
            component.set("v.showSpinner", true); 
            action.setCallback(this, function(a) {
                component.set("v.showSpinner", false);
                var state = a.getState();
                if(state == "SUCCESS") {
                    var orderItemList = component.get("v.orderItemList");
                    errorMessage = a.getReturnValue().errorMessage;
                    if(errorMessage!=''&& errorMessage!=null) {
                        toastMsg = errorMessage;
                        helper.showErrorToast(component, event, toastMsg);
                    }else{
                        orderItemList.splice(0, orderItemList.length);
                        component.set("v.orderItemList", orderItemList);
                        toastMsg = $A.get("$Label.c.Cart_Cleared_Successfully");
                        helper.showToast(component, event, toastMsg);
                        component.set("v.grossNetPrice",0);
                        helper.resetSingleOrderItem(component,helper);
                        helper.clubbingSKU(component,event,helper);
                        window.location.reload();
                        
                    }
                    
                }else{
                    var toastMsg = $A.get("$Label.c.Error_While_Deleting_Cart_Please_Contact_System_Administrator");
                    helper.showErrorToast(component, event, toastMsg);                      
                }
                
            });
            $A.enqueueAction(action);
            
        }else{
            
            console.log('In delete all Item in Sales Order');
            if(soId!=null && soId!='' && soId!= undefined){
                var action = component.get('c.deleteSaleOrderItems');
                action.setParams({
                    "sorderId" : soId 
                });
                action.setCallback(this, function(a){
                    var state = a.getState(); 
                    var orderItemList = component.get("v.orderItemList");
                    if(state == 'SUCCESS') {
                        errorMessage = a.getReturnValue().errorMessage;
                        if(errorMessage!=''&& errorMessage!=null) {
                            toastMsg = errorMessage;
                            helper.showErrorToast(component, event, toastMsg);
                        }else{
                            console.log('in else part of delte cart');
                            orderItemList.splice(0, orderItemList.length);
                            component.set("v.orderItemList", orderItemList);
                            toastMsg = $A.get("$Label.c.Cart_Cleared_Successfully");
                            helper.showToast(component, event, toastMsg);
                            component.set("v.grossNetPrice",0);
                            helper.resetSingleOrderItem(component,helper);
                            helper.clubbingSKU(component,event,helper);
                            //window.location.reload();
                        }
                        
                    }else{
                        var toastMsg = $A.get("$Label.c.Error_While_Deleting_Cart_Please_Contact_System_Administrator");
                        helper.showErrorToast(component, event, toastMsg);  
                        
                        
                        
                    }
                });
                $A.enqueueAction(action);
                
                
                
            }
            
            
            
        }
        
    },
    
    
    calulateFinalPrice : function(component,event,helper){
        var tmpmnlDis = true;
        var mndisct = component.get("v.SingleOrderItem.manualDiscount");
        if(mndisct<0){
            console.log('Negetive');
            tmpmnlDis = false;
            var toastMsg = $A.get("$Label.c.Manual_Discount_should_Be_positive");
            helper.showErrorToast(component, event, toastMsg); 
            component.set("v.SingleOrderItem.manualDiscount",0);
            component.set("v.SingleOrderItem.finalPrice",0);
            component.set("v.SingleOrderItem.netValue",0);
            
            
        }else{
            console.log('Positive');
            tmpmnlDis = true;
        }
        
        
        if(tmpmnlDis){
            var tmpManflg  =true;
            if(mndisct<=100){
                console.log('manual discount is under 100');
                tmpManflg = true;
            }else{
                tmpManflg = false;
                console.log('manual discount is above 100');
                component.set("v.SingleOrderItem.manualDiscount",0);
                
                var toastMsg = $A.get("$Label.c.Manual_Discount_should_be_Under_100");
                helper.showErrorToast(component, event, toastMsg); 
                var qtTem = component.get("v.SingleOrderItem.qty");
                var bsprce = component.get("v.SingleOrderItem.basePrice");
                var mnalDis = component.get("v.SingleOrderItem.manualDiscount");
                var qtTem1;
                if(qtTem==undefined){
                    qtTem1=0;
                }else{
                    qtTem1 =qtTem;
                }
                
                var bsprce1;
                if(bsprce==undefined){
                    bsprce1=0;
                }else{
                    bsprce1=bsprce;
                }
                
                var mnalDis1;
                if(mnalDis==undefined){
                    mnalDis1=0;
                }else{
                    mnalDis1=mnalDis;
                }
                
                var fnlprce = 0.0;
                fnlprce= (bsprce1 - (bsprce1*mnalDis1/100));
                fnlprce = Math.round((fnlprce + Number.EPSILON) * 100) / 100;
                console.log('After calculation of Manual Discount '+fnlprce);
                component.set("v.SingleOrderItem.finalPrice",fnlprce);
                var ntValue = (fnlprce* qtTem1).toFixed(2);
                component.set("v.SingleOrderItem.netValue",fnlprce);
                
            }
            
            if(tmpManflg){
                var isNonRegularCustomer = component.get("v.isNonRegularCustomer");
                var isRegularCustomer = component.get("v.isRegularCustomer");
                
                
                if(isNonRegularCustomer){
                    
                    var bsPrice = component.get("v.SingleOrderItem.basePrice");
                    var qty = component.get("v.SingleOrderItem.qty");
                    var manualDiscount = component.get("v.SingleOrderItem.manualDiscount");
                    
                    console.log('for Non regular base Price '+bsPrice);
                    console.log('for Non regular qty '+qty);
                    console.log('for Non regular manualDiscount '+manualDiscount);
                    var qty1 ; 
                    if(qty==undefined){
                        qty1= 0; 
                    }else{
                        qty1=qty;
                    }
                    var manualDiscount1;
                    if(manualDiscount==undefined){
                        manualDiscount1 =0;
                    }else{
                        manualDiscount1 =manualDiscount;  
                    }
                    var bsPrice1;
                    if(bsPrice==undefined){
                        bsPrice1= 0;
                    }else{
                        bsPrice1=bsPrice;
                    }
                    
                    var finalPrice =0;
                    var netValue =0;
                    finalPrice = (bsPrice1 - (bsPrice1*manualDiscount1/100));
                    finalPrice = Math.round((finalPrice + Number.EPSILON) * 100) / 100;
                    component.set("v.SingleOrderItem.finalPrice",finalPrice);
                    netValue = (finalPrice* qty1).toFixed(2);
                    component.set("v.SingleOrderItem.netValue",netValue);
                    component.set("v.SingleOrderItem.manualDiscount",manualDiscount1);
                }
                
                if(isRegularCustomer){
                    
                    var bsPrice = component.get("v.SingleOrderItem.basePrice");
                    var earlyDiscount = component.get("v.SingleOrderItem.earlyOrderDiscount");
                    var bigVolDiscount = component.get("v.SingleOrderItem.bigVolDiscount");
                    var logisticDis = component.get("v.SingleOrderItem.logisticDiscount");
                    var manualDis = component.get("v.SingleOrderItem.manualDiscount");
                    var qty = component.get("v.SingleOrderItem.qty");
                    var skuCode = component.get("v.SingleOrderItem.skuCode");//nandhini
                    var finalPrice = 0.0;
                    
                    
                    console.log('after manual discount bsPrice '+bsPrice);
                    console.log('after manual discount earlyDiscount '+earlyDiscount);
                    console.log('after manual discount bigVolDiscount '+bigVolDiscount);
                    console.log('after manual discount logisticDis '+logisticDis);
                    console.log('after manual discount manualDis '+manualDis);
                    console.log('after manual discount qty '+qty);
                    
                    var tmpbsPrice;
                    if(bsPrice!=null){
                        tmpbsPrice =bsPrice;
                    }else{
                        tmpbsPrice = 0;
                    }
                    
                    var tmpearlyDiscount;
                    if(earlyDiscount!=null){
                        tmpearlyDiscount = earlyDiscount;
                    }else{
                        tmpearlyDiscount = 0;
                    }
                    
                    var tmpbigVolDiscount;
                    if(bigVolDiscount!=undefined){
                        tmpbigVolDiscount = bigVolDiscount;
                    }else{
                        tmpbigVolDiscount =0;
                    }
                    
                    var tmplogisticDis;
                    if(logisticDis!=undefined){
                        tmplogisticDis = logisticDis;
                    }else{
                        tmplogisticDis = 0;
                    }
                    
                    
                    var tmpmanualDis;
                    if(manualDis!=null){
                        tmpmanualDis = manualDis;
                    }else{
                        tmpmanualDis = 0;
                    }
                    
                    
                    var tmpqty;
                    if(qty!=null){
                        tmpqty = qty;
                    }else{
                        tmpqty = 0; 
                    }
                    
                    
                    console.log('me as cal after tmpbsPrice '+tmpbsPrice);
                    console.log('me as cal after tmpearlyDiscount '+tmpearlyDiscount);
                    console.log('me as cal after tmpbigVolDiscount '+tmpbigVolDiscount);
                    console.log('me as cal after tmpmanualDis '+tmpmanualDis);
                    console.log('me as cal after tmplogisticDis '+tmplogisticDis);
                    
                    console.log('me as cal after tmpqty '+tmpqty);
                    
                    
                    
                    
                    finalPrice =(tmpbsPrice-(tmpbsPrice*tmpbigVolDiscount/100)); //tmpearlyDiscount
                    finalPrice = Math.round((finalPrice + Number.EPSILON) * 100) / 100;
                    console.log('After calculation of early order discount '+finalPrice);
                    
                    finalPrice = (finalPrice -(finalPrice*tmpmanualDis/100)); //tmpbigVolDiscount
                    finalPrice = Math.round((finalPrice + Number.EPSILON) * 100) / 100;
                    console.log('After calculation of big vol discount '+finalPrice);
                    
                    finalPrice = (finalPrice -(finalPrice*tmpearlyDiscount/100));  //tmpmanualDis
                    finalPrice = Math.round((finalPrice + Number.EPSILON) * 100) / 100;
                    console.log('After calculation of Manual discount '+finalPrice);
                    //nandhini
                    if(!skuCode.includes('6061000') && finalPrice >= 0){
                        finalPrice =(finalPrice - tmplogisticDis);  //tmplogisticDis
                        finalPrice = Math.round((finalPrice + Number.EPSILON) * 100) / 100;
                    }
                    
                    console.log('After calculation of Logistic discount '+finalPrice);
                    
                    component.set("v.SingleOrderItem.finalPrice",finalPrice);
                    var netValue = (finalPrice * tmpqty).toFixed(2);
                    component.set("v.SingleOrderItem.netValue",netValue);
                }
                
                
            }
            //for the profile of Key Account Manager and Wholesales Manager
            
        }
        
        
        
        
    },
    
    //adding single SKU in OrderList
    addSkuRow : function(component, event, helper){
        
        var getordeItemList= component.get("v.orderItemList");
        console.log('getordeItemList '+getordeItemList);
        
        var i;
        
        var temppb = component.get("v.selectedPBRecord");
        var skid = temppb.SKUCode__r.Id;
        //var ptid = temppb.SKUCode__r.Payment_Term__c;
        var ptid = component.get("v.SingleOrderItem.typeOfPayment");
        var customerDeliveryDate = component.get("v.SingleOrderItem.customerDeliveryDate"); // SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022..
        var flg = true;
        var toastMsg='';        
        		
        	/* --------------------- Start SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022 ------------- */
            var customerDeliverRequired = component.get("v.loginCountryObjs.Delivery_Date__c"); 
			if(customerDeliveryDate==undefined && customerDeliverRequired==true){
				component.set("v.showsnackbarclone1",true);
				//var toastMsg1 = $A.get("$Label.c.SKU_already_added_to_cart");
				var toastMsg1 = $A.get("$Label.c.Select_Customer_Delivery_Date");
				component.set("v.flagMessageforClone1",toastMsg1);
				setTimeout(function(){ component.set("v.showsnackbarclone1",false); }, 3000);                 
			}
            /* ----------------------- End SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022 --------------- */
		 	else if(getordeItemList!=null){        
            for (i = 0; i < getordeItemList.length; i++) {
                var obj = new Object(getordeItemList[i]);
                
			    //Ticket INCTASK0923666--Added by Wipro Pradeep Salvi 22/8/2022    
        		var profileNamess = component.get("v.profileName");
                //console.log('profileNamess: '+profileNamess);
    		    //Ticket INCTASK0923666--Modified by Wipro Pradeep Salvi 22/8/2022
    			//commented the if statement below and added new if statement with profileNamess 
    			//if(obj.skuId == skid)
                if((obj.skuId == skid)&&(profileNamess!='Poland(Key Account Manager)' && profileNamess!='Poland(Non Crop Product & Retail Sales Manager)' && profileNamess!='Poland(wholesale sales Manager)')){
                    console.log('Same ski and paterm Id');
                    flg = false;
                    break;
                }else{
                    flg = true;
                }
                
            }//end of for Loop
             if(flg){
            
            helper.createOrder(component, event, helper);
            helper.updategrossAmmount(component, event, helper);
            helper.clubbingSKU1(component,event,getordeItemList); 
            
            }else{
                var forClones = component.get("v.forClone");
                console.log('forClones in add to cart '+forClones);
                if(forClones=='cloneOrder'){
                    console.log('inside  clone order toast ');
                    component.set("v.showsnackbarclone1",true);
                    var toastMsg1 = $A.get("$Label.c.SKU_already_added_to_cart");
                    component.set("v.flagMessageforClone1",toastMsg1);
                    setTimeout(function(){ component.set("v.showsnackbarclone1",false); }, 4000);
                                    
                }else{
                    toastMsg = $A.get("$Label.c.SKU_already_added_to_cart");
                    helper.showErrorToast(component, event, toastMsg); 
                }
                
                
            }
            
        }
				    				                                                  
    },
    
    
    
    
    // Logic to hide all selection modals    
    closeMultipleOfDialog : function(component, event, helper) {
        //helper.toggleMultipleOfDialog(component);
        //Added by Pavani on 21-10-2021 for SCTASK0624160 Start
        var qty = component.find("itemqty1");
        var errorMessage = '';
        var warningMessage = '';
        if(qty){
            qty.set("v.value",0);
            //helper.updateRowCalculations1(component, event, helper);
            helper.toggleMultipleOfDialog(component);
        }
        //Added by Pavani on 21-10-2021 for SCTASK0624160 End
    },
    
    // Logic to remove Order Line Item
    removeTableRow : function(component, event, helper) { 
        var target = event.getSource();  
        var index = target.get("v.value");
        var items = component.get("v.orderItemList");   
        var soId = component.get("v.sOId");
        var orderId = component.get("v.orderObjId");
        var itemsLength=items.length;
        
        if(index == items.length - 1){
            //when only one SKU is in Line item
            if(soId==null || soId==undefined){
                var oliId =items[index].oliId;
                
                if(index==0){
                    helper.deleteOrderItem(component, event, oliId,orderId,0,index);
                    component.set("v.orderObjId",'');
                }else{
                    
                    helper.deleteOrderItem(component, event, oliId,'','',index);
                }
                //component.set("v.paymentTermList", null);
                // items.splice(index, 1); nandhini
                component.set("v.paymentTermList", component.get("v.paymentTermListCopy"));    
            }else if(soId!=null || soId!=undefined){
                
                console.log('items Soid Not null Edit sales Order '+JSON.stringify(items)) ;
                var soliId =items[index].soliId;
                if(soliId!=null || soliId!=undefined){
                    var forClones = component.get("v.forClone");
                    if(forClones=='cloneOrder'){
                        console.log('only deleting item 1');
                        component.set("v.showSpinner", false);
                    }else{
                        helper.deleteSalesOrderItem(component, event, soliId); 
                        component.set("v.showSpinner", true);
                    }
                    
                    
                    
                }
                // items.splice(index, 1); nandhini
            }
            
            
        }else{
            if(soId==null || soId==undefined){
                var oliId =items[index].oliId; 
                helper.deleteOrderItem(component, event, oliId,orderId,itemsLength,index);
                // items.splice(index, 1); nandhini
            }else if(soId!=null || soId!=undefined){
                console.log('items Soid Not null Edit sales Order other '+JSON.stringify(items)) ;
                var soliId =items[index].soliId;
                if(soliId!=null || soliId!=undefined){
                    var forClones = component.get("v.forClone");
                    if(forClones=='cloneOrder'){
                        console.log('only deleting item 2');
                        component.set("v.showSpinner", false);
                        
                    }else{
                        helper.deleteSalesOrderItem(component, event, soliId);    
                        component.set("v.showSpinner", true);
                    }
                    
                    
                    
                }
                // items.splice(index, 1); nandhini
            }
            
            
        }
        
        
        
        component.set("v.orderItemList", items);
        var tempOrderItemList = component.get("v.orderItemList");
        
        
        if(tempOrderItemList.length==0){
            component.find("incoTermListOptions").set("v.disabled",false);
        }else{
            component.find("incoTermListOptions").set("v.disabled",true);
        }
        helper.updateRowCalculations(component, event, helper);
        helper.clubbingSKU(component,event,helper);
        component.find("skuId").makeReset(false);
    },
    
    //Logic to show confirmation dialog with Simulation Flag & Message on Save and Submit.
    saveSalesOrderData : function(component, event, helper) {
        var selected = event.getSource().get("v.label");
        
        if(selected=="Confirm" || selected=="Conferma" || selected=='Potwierdź'){
            //we need to add Translation for Poland for Selected
            component.set("v.saveSalesOrderData",true);
            helper.createSalesOrder(component, event, "Pending");
        }
        
    },
    
    // Method use to enable Editing of Order Form using 'Edit' button 
    // Enabled when order status is Rejected'
    editForm : function(component, event, helper) {
        helper.editForm(component);
    },
    
    handleFilesChange:function(component, event, helper) {
        var fileName = $A.get("{!$Label.c.No_file_selected}");
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },
    //changes made by Srinivas for the ticket RITM0328841
    handleFilesChange1:function(component, event, helper) {
        var fileName1 = $A.get("{!$Label.c.No_file_selected}");
        if (event.getSource().get("v.files").length > 0) {
            fileName1 = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName1", fileName1);
    },
    // changes made by Srinivas for the ticket RITM0328841
    handleFilesChange2:function(component, event, helper) {
        var fileName2 = $A.get("{!$Label.c.No_file_selected}");
        if (event.getSource().get("v.files").length >= 0) {
            fileName2 = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName2", fileName2);
    },
    //changes made by Srinivas for the ticket RITM0328841
    handleFilesChange3:function(component, event, helper) {
        var fileName3 = $A.get("{!$Label.c.No_file_selected}");
        if (event.getSource().get("v.files").length >= 0) {
            fileName3 = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName3", fileName3);
    },
    
    
    //Replace Negative Sign from Quantity Input
    restrictQuantity: function(component, event, helper){
        var target = event.getSource();  
        var qty = target.get("v.value");
        var rowIndex = target.get("v.labelClass");
        var orderItemList = component.get("v.orderItemList");
        var flag = false;
        var errorMessage = '';
        var warningMessage = '';
        var jsonString = JSON.stringify(orderItemList);
        console.log('jsonString '+jsonString);
        
        var skuCombinationky = orderItemList[rowIndex].skuCombinationKey;
        console.log('skuCombinationky update qty  '+skuCombinationky);
        helper.gettingBigVolDiscount(component,event,helper,skuCombinationky);
        helper.gettingEarlyDis(component,event,helper,skuCombinationky);
        
        var forClones = component.get("v.forClone");
        console.log('forClones checking  '+forClones);
        var accId = orderItemList[rowIndex].accountId;
        console.log('after qtye change skuCombinationky '+skuCombinationky);
        console.log('after qtye change accId '+accId);
        if(forClones=='cloneOrder'){
            helper.gettingManualDiscount(component,event,helper,skuCombinationky,accId);    
        }
        
        
        
        component.set('v.qtySOLI',qty);
        component.set('v.qtyIndexSOLI',rowIndex);
        
        
        
        if(qty){
            flag = false;
            var qtyString = qty.toString(); //Convert to string
            if(qtyString!=''){
                qty = parseFloat(qtyString.replace("-", "")); //Replace negative sign
                target.set("v.value",qty);
                var multipleOf = target.get("v.placeholder");
                var flag = false;
                var modValue = (qty%multipleOf).toFixed(2);
                if(multipleOf && modValue!=0){
                    if(modValue != multipleOf){
                        flag = true;
                        warningMessage= $A.get("$Label.c.Qty_should_be_in_multiple_of")+" "+multipleOf+". ";
                        orderItemList[rowIndex].qty=0;
                        component.set('v.MultipleOfDialogMessage',warningMessage);
                        helper.toggleMultipleOfCartDialog(component);
                    }
                    
                }
                target.set("v.errors", null); 
                $A.util.removeClass(target, "error");
                
                
                window.setTimeout($A.getCallback(function() {
                    helper.updateQtyCart(component, event, helper,rowIndex,qty); 
                    helper.clubbingSKU(component,event,helper);
                    helper.updategrossAmmount(component, event, helper);
                }),2000 );
                
                
                // console.log('before clubbiing');
                
            }
            
        }else{
            errorMessage= $A.get("$Label.c.Please_enter_Quantity");
            target.set("v.errors", [{message:errorMessage}]);
            $A.util.addClass(target, "error");
            target.set("v.value",0);
            // helper.updateQty(component, event, helper,rowIndex,qty); 
            // helper.updateRowCalculations(component, event, helper);
        }
        
    },
    
    checkOrderTemple:function(component,event,helper){
        //component.set("v.saveOrderTemplate",true);
        helper.gettingNameSKU(component,event,helper);
    },
    
    openOrderTemplate: function(component,event,helper){
        console.log('openOrderTemplate');  
        //open dialog box
        
    },
    
    
    
    
    
    showOrderTemplate : function(component, event, helper) {
        helper.gettingOrderTemplate(component,event,helper);
        component.set("v.isOpen", true);
    },
    
    loadOrderTemplate: function(component,event,helper){
        component.set("v.isOpen", false);
        var tempId = event.getSource().get("v.name");
        helper.gettingOrderTemplateDetails(component,event,helper,tempId);
        
        
        
        
        
        
    },
    
    closeModel : function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    
    
    
    //Dynamic Component Code For Handler
    handleSKUChange:function(component, event, helper){
        
        var pb = component.get("v.selectedPBRecord");
         console.log('selected PB :'+JSON.stringify(pb));

        var singlLineItem = new Object();
        //Added by Nandhini-APPS-2521
        var isParent='';
      if(pb.Id != undefined){
        var wholePriceList=component.get("v.priceDetailList");
        wholePriceList.forEach(pbInfo=>{
            if(pb.SKUCode__r.SKU_Code__c ==pbInfo.skuCode){
                 isParent =pbInfo.isParent;
              }
         });
          
      }
        console.log('test parent :'+isParent);
        component.set("v.tempTrueForTemplate",false);
        
        
        
        var profileNames = component.get("v.profileName");
        
        if(profileNames=='Customer Community Plus User - Poland - 1' || profileNames=='Customer Community Plus User - Poland - 2' || profileNames=='Customer Partner Community Plus User - Poland - 1'|| profileNames=='Customer Partner Community Plus User - Poland - 2'){
            
            
            if(pb.Id != undefined){
                
                var salesorderId = component.get("v.sOId");
                if(salesorderId!=undefined){
                    component.set("v.showSingleLineItemforSO",false);
                    component.set("v.showSingleLineItemforSO1",true);
                }
                var isRegularCustomer = component.get("v.isRegularCustomer");
                var iswholesalesMgr = component.get("v.isKAMWholesManager");
                
                
                var tmIvento1 = component.get("v.isInventoryHide");
                
                if(tmIvento1==true){
                    helper.gettingInventory(component,event,helper,pb.SKUCode__r.Id);  
                }
                
                var paymentTemss = pb.Payment_Term__c;
                var manualDiscnt;
                if(pb.Manual_Discount__c== undefined){
                    manualDiscnt = 0;    
                }else{
                    manualDiscnt = pb.Manual_Discount__c;
                }
                
                
                
                
                component.set("v.paymenttrm",paymentTemss);
                component.set("v.disabledSOI", false);
                
                
                
                var orderItemList = component.get("v.orderItemList");
                singlLineItem.skuId = pb.SKUCode__c;
                component.set("v.tmpSkuId",pb.SKUCode__c);
                singlLineItem.skuDescription = pb.SKUCode__r.SKU_Description__c;
                singlLineItem.skuCode = pb.SKUCode__r.SKU_Code__c; //nandhini
                
                singlLineItem.UOM = pb.SKUCode__r.UOM__c;
                console.log('pb.SKUCode__r.SKU_Description__c '+pb.SKUCode__r.SKU_Description__c);
                
                
                singlLineItem.productName =  pb.SKUCode__r.SKU_Description_poland__c;
                singlLineItem.PaymentTermId = pb.SKUCode__r.Payment_Term__c;
                
                singlLineItem.typeOfPayment = pb.SKUCode__r.Payment_Term__c;
                singlLineItem.divisionId = pb.SKUCode__r.Division__c;
                
                console.log('pb.SKUCode__r.Division__c '+pb.SKUCode__r.Division__c);
                
                singlLineItem.distributionChannelId = pb.SKUCode__r.Distribution_Channel__c;
                component.set("v.tmpDivisionId",pb.SKUCode__r.Division__c);
                component.set("v.tmpDistributionChannelId",pb.SKUCode__r.Distribution_Channel__c);
                
                var combinationKey = pb.New_Composite_key__c;
                var acId = pb.DistributorCustomerCode__c;
                //console.log('DistributorCustomerCode__c '+acId);
                
                console.log('combinationKey from Indonesia '+combinationKey);
                
                component.set("v.tmpPalletSize",pb.SKUCode__r.pallet_Size_Italy__c);
                component.set("v.tmpTruckSize",pb.SKUCode__r.Truck_Quantity__c);
                
                component.set("v.tmpBigVolForTruck",pb.SKUCode__r.Big_Volume_for_Truck__c);
                component.set("v.tmpBigVolForPallet",pb.SKUCode__r.Big_Volume_for_Pallet__c);
                component.set("v.tmpPaymentTerm",paymentTemss);
                console.log('ggggggggggggg '+pb.SKUCode__r.SKU_Description_poland__c);
                component.set("v.tmpProductName",pb.SKUCode__r.SKU_Description_poland__c);
                component.set("v.tmpUOMName",pb.SKUCode__r.UOM__c);
                component.set("v.tmpmultipleOf",pb.SKUCode__r.Multiple_of__c);
                component.set("v.tmpManualDscnt",manualDiscnt);
                
                
                
                var discnt = component.get("v.discount");
                
                var ealryOrderdisFromSKU =  pb.SKUCode__r.Early_Order_Discount__c;
                console.log('ealryOrderdisFromSKU early Order Discount on sku level '+ealryOrderdisFromSKU);
                
                var stDate = Date.parse(component.get("v.startDate"));
                var edDate = Date.parse(component.get("v.endDate"));
                
                var currentDate = new Date();
                var pCurdate = Date.parse(currentDate);
                console.log(' condition for early order discount outside '+ealryOrderdisFromSKU);
                
                var tearyOrder;
                if(pCurdate>=stDate && pCurdate<=edDate && ealryOrderdisFromSKU!=undefined){
                    console.log(' condition for early order discount inside  '+ealryOrderdisFromSKU);
                    
                    var isRegularCsutomrTemp = component.get("v.isRegularCustomer");
                    if(isRegularCsutomrTemp){
                        console.log('@@@1');
                        //component.set("v.singlLineItem.earlyOrderDiscount",ealryOrderdisFromSKU);    
                        tearyOrder =ealryOrderdisFromSKU;
                    }else{
                        console.log('@@@2');
                        //component.set("v.singlLineItem.earlyOrderDiscount",null);
                        tearyOrder = null;
                    }
                    
                }else{
                    console.log('@@@3');
                    //console.log('outside condition for early order discount');
                    //component.set("v.singlLineItem.earlyOrderDiscount",0);
                    tearyOrder = 0;
                }
                
                
                
                console.log('tearyOrder '+tearyOrder);
                component.set("v.tmpEarlyOrderDis",tearyOrder);
                
                var intrmTem = component.get("v.incoTrm1");
                console.log('intrmTem tem vert  '+intrmTem);
                var isReuglarCus = component.get("v.isRegularCustomer");
                console.log('is Regular  '+isReuglarCus);
                
                var logDisValue ;
                var logDis ;
                
                var isDistributors = component.get("v.isDistributor");
                if((isReuglarCus && intrmTem=='EXW') || (isDistributors && intrmTem =='EXW') ){
                    logDisValue = pb.SKUCode__r.Logistic_Discount__c;
                    logDis = pb.SKUCode__r.Logistic_Discount__c;
                    singlLineItem.logisticDiscountValue = pb.SKUCode__r.Logistic_Discount__c;    
                    singlLineItem.logisticDiscount = pb.SKUCode__r.Logistic_Discount__c;
                }else{
                    logDisValue = null;
                    logDis = null
                    singlLineItem.logisticDiscountValue = null;
                    singlLineItem.logisticDiscount = null;
                }
                
                component.set("v.tmpLogDisValue",logDisValue);
                component.set("v.tmpLogDis",logDis);
                
                
                var logisticDiscntForMsg = pb.SKUCode__r.Logistic_Discount__c;
                console.log('logisticDiscntForMsg in select '+logisticDiscntForMsg);
                
                var bigvolapply1 = pb.SKUCode__r.Big_Volume_for_Truck__c;
                var bigvolapply2 = pb.SKUCode__r.Big_Volume_for_Pallet__c;
                
                console.log('bigvolapply1 '+bigvolapply1);
                console.log('bigvolapply1 '+bigvolapply2);
                
                var showModalBigLogDis = component.get("v.showModalBigLogDiscount"); 
                console.log('showModalBigLogDis '+showModalBigLogDis); 
                
                if(bigvolapply1=='Yes' || bigvolapply2 =='Yes'){
                    console.log('Inside yes');
                    component.set("v.bigVolDis",'Obowiązuje upust ilościowy');
                    //helper.toggleshowModalBigLogDisDialog(component);
                }else{
                    console.log('Inside no');
                    component.set("v.bigVolDis",'Nie obowiązuje upust ilościowy');
                    //helper.toggleshowModalBigLogDisDialog(component);
                }
                
                
                if(intrmTem=='EXW' 	&& logisticDiscntForMsg!=undefined && logisticDiscntForMsg!=0 ){
                    console.log('Inside yes for Logistustic discount');  
                    component.set("v.logisticDis",', Obowiązuje upust logistyczny');
                }else{
                    console.log('Inside no for Logistustic discount');  
                    component.set("v.logisticDis",', Nie obowiązuje upust logistyczny ');
                }
                
                helper.toggleshowModalBigLogDisDialog(component);
                
                
                
                helper.gettingPriceBookPrice(component,event,helper,combinationKey,acId);
                helper.gettingBigVolDiscount(component,event,helper,combinationKey);
                helper.gettingEarlyOrderDiscount(component,event,helper,combinationKey);
                
                
                
                
            }// pb is not defined end
            else{
                console.log('when close Button click');
                var orderId = component.get("v.sOId");
                console.log('orderId in close button '+orderId);
                if(orderId==undefined){
                    helper.resetSingleOrderItem(component);  
                }
            }
            
            
            //this end for Community
            
            
        }else{
            
            
            //this is for another user like Wholesale manager and key account manager
            
            if(pb.Id != undefined){
                
                
                var salesorderId = component.get("v.sOId");
                if(salesorderId!=undefined){
                    component.set("v.showSingleLineItemforSO",false);
                    component.set("v.showSingleLineItemforSO1",true);
                }
                
                var isRegularCustomer = component.get("v.isRegularCustomer");
                var iswholesalesMgr = component.get("v.isKAMWholesManager");
                
                var tmIvento1 = component.get("v.isInventoryHide");
                if(tmIvento1==true){
                    helper.gettingInventory(component,event,helper,pb.SKUCode__r.Id);  
                }
                
                
                console.log('pb in new  '+JSON.stringify(pb));
                console.log('pb in new  '+pb.Id);
                
                var combinationKey = pb.SKUCombinationKey__c;
                
                console.log('combinationKey in new '+combinationKey);
                
                
                
                
                console.log('pb.SKUCode__r.Id '+pb.SKUCode__r.Id);
                var paymentTem = pb.SKUCode__r.Payment_Term__c;
                
                component.set("v.paymenttrm",paymentTem);
                component.set("v.disabledSOI", false);
                var orderItemList = component.get("v.orderItemList");
                
                singlLineItem.skuId = pb.SKUCode__c;
                component.set("v.tmpSkuId",pb.SKUCode__c);
                
                singlLineItem.skuDescription = pb.SKUCode__r.SKU_Description__c;
                singlLineItem.UOM = pb.SKUCode__r.UOM__c;
                singlLineItem.skuCode = pb.SKUCode__r.SKU_Code__c; //nandhini
               
                singlLineItem.isParent =isParent;//Added by nandhini-may 27
                
                console.log('pb.SKUCode__r.SKU_Description__c '+pb.SKUCode__r.SKU_Description__c);
                
                singlLineItem.productName =  pb.SKUCode__r.SKU_Description_poland__c;
                singlLineItem.PaymentTermId = pb.SKUCode__r.Payment_Term__c;
                console.log('in selction of SKU  '+pb.SKUCode__r.Payment_Term__c);
                component.set("v.tmpPaymentTerm",pb.SKUCode__r.Payment_Term__c);
                singlLineItem.typeOfPayment = pb.SKUCode__r.Payment_Term__c;
                
                singlLineItem.divisionId = pb.SKUCode__r.Division__c;
                console.log('pb.SKUCode__r.Division__c '+pb.SKUCode__r.Division__c);
                
                singlLineItem.distributionChannelId = pb.SKUCode__r.Distribution_Channel__c;
                
                
                component.set("v.tmpDivisionId",pb.SKUCode__r.Division__c);
                component.set("v.tmpDistributionChannelId",pb.SKUCode__r.Distribution_Channel__c);
                
                
                console.log('hgdhsagd '+pb.Price__c);
                component.set("v.baseprices",pb.Price__c);
                
                singlLineItem.basePrice = pb.Price__c;
                singlLineItem.basePriceOg = pb.Price__c;
                component.set("v.tmpBasePrice",pb.Price__c);
                console.log('pb.SKUCode__r.Multiple_Of__c '+pb.SKUCode__r.Multiple_of__c);
                singlLineItem.multipleOf = pb.SKUCode__r.Multiple_of__c;
                
                
                singlLineItem.palletSize = pb.SKUCode__r.pallet_Size_Italy__c;
                singlLineItem.truckSize = pb.SKUCode__r.Truck_Quantity__c;
                
                
                var isReuglarCus = component.get("v.isRegularCustomer");
                var isDistributors = component.get("v.isDistributor");
                console.log('isReuglarCus logistic  '+isReuglarCus);
                console.log('Is Distributor  logistic  '+isDistributors);
                
                singlLineItem.Big_Volume_for_Truck = pb.SKUCode__r.Big_Volume_for_Truck__c;    
                singlLineItem.Big_Volume_for_Pallet = pb.SKUCode__r.Big_Volume_for_Pallet__c;
                
                
                console.log('wwwwwwww '+pb.SKUCode__r.pallet_Size_Italy__c);
                console.log('wwwwwwww2 '+pb.SKUCode__r.Truck_Quantity__c);
                
                component.set("v.tmpTruckSize",pb.SKUCode__r.Truck_Quantity__c);
                
                component.set("v.tmpUOMName",pb.SKUCode__r.UOM__c);
                
                component.set("v.tmpmultipleOf",pb.SKUCode__r.Multiple_of__c);
                
                component.set("v.tmpProductName",pb.SKUCode__r.SKU_Description_poland__c);
                
                component.set("v.tmpPalletSize",pb.SKUCode__r.pallet_Size_Italy__c);
                
                component.set("v.tmpBigVolForPallet",pb.SKUCode__r.Big_Volume_for_Pallet__c);
                component.set("v.tmpBigVolForTruck",pb.SKUCode__r.Big_Volume_for_Truck__c);
                
                
                
                
                var intrmTem = component.get("v.incoTrm1");
                console.log('intrmTem tem vert  '+intrmTem);
                console.log('intrmTem tem vert isReuglarCus '+isReuglarCus);
                
                var logisticDiss;
                var logisticDissVal;
                if((isReuglarCus && intrmTem=='EXW') || (isDistributors && intrmTem =='EXW') ){
                    singlLineItem.logisticDiscountValue = pb.SKUCode__r.Logistic_Discount__c;    
                    singlLineItem.logisticDiscount = pb.SKUCode__r.Logistic_Discount__c;
                    logisticDiss = pb.SKUCode__r.Logistic_Discount__c;
                    logisticDissVal = pb.SKUCode__r.Logistic_Discount__c;
                }else{
                    singlLineItem.logisticDiscountValue = null;
                    singlLineItem.logisticDiscount = null;
                    logisticDiss = null;
                    logisticDissVal = null;
                }
                
                console.log('logisticDissVal permat '+logisticDissVal);
                var logisticDiscntForMsg = pb.SKUCode__r.Logistic_Discount__c;
                
                component.set("v.tmpLogDisValue",logisticDissVal);
                component.set("v.tmpLogDis",logisticDiss);
                
                
                console.log('logisticDiscntForMsg in select '+logisticDiscntForMsg);
                
                
                
                
                var bigvolapply1 = pb.SKUCode__r.Big_Volume_for_Truck__c;
                var bigvolapply2 = pb.SKUCode__r.Big_Volume_for_Pallet__c;
                console.log('bigvolapply1 '+bigvolapply1);
                console.log('bigvolapply1 '+bigvolapply2);
                var showModalBigLogDis = component.get("v.showModalBigLogDiscount"); 
                console.log('showModalBigLogDis '+showModalBigLogDis); 
                // if(showModalBigLogDis){
                if(bigvolapply1=='Yes' || bigvolapply2 =='Yes'){
                    console.log('Inside yes');
                    component.set("v.bigVolDis",'Obowiązuje upust ilościowy');
                    //helper.toggleshowModalBigLogDisDialog(component);
                }else{
                    console.log('Inside no');
                    component.set("v.bigVolDis",'Nie obowiązuje upust ilościowy');
                    //helper.toggleshowModalBigLogDisDialog(component);
                }
                
                if(intrmTem=='EXW' 	&& logisticDiscntForMsg!=undefined && logisticDiscntForMsg!=0 ){
                    console.log('Inside yes for Logistustic discount');  
                    component.set("v.logisticDis",', Obowiązuje upust logistyczny');
                }else{
                    console.log('Inside no for Logistustic discount');  
                    component.set("v.logisticDis",', Nie obowiązuje upust logistyczny ');
                }
                helper.toggleshowModalBigLogDisDialog(component);
                
                //}
                
                
                
                component.set("v.SingleOrderItem",singlLineItem);
                //UPL CR-143 
                
                
                
                var discnt = component.get("v.discount");
                
                var ealryOrderdisFromSKU =  pb.SKUCode__r.Early_Order_Discount__c;
                console.log('ealryOrderdisFromSKU early Order Discount on sku level '+ealryOrderdisFromSKU);
                
                
                var stDate = Date.parse(component.get("v.startDate"));
                var edDate = Date.parse(component.get("v.endDate"));
                
                var currentDate = new Date();
                var pCurdate = Date.parse(currentDate);
                console.log(' condition for early order discount outside '+ealryOrderdisFromSKU);
                
                if(pCurdate>=stDate && pCurdate<=edDate && ealryOrderdisFromSKU!=undefined){
                    console.log(' condition for early order discount inside  '+ealryOrderdisFromSKU);
                    
                    var isRegularCsutomrTemp = component.get("v.isRegularCustomer");
                    if(isRegularCsutomrTemp){
                        component.set("v.SingleOrderItem.earlyOrderDiscount",ealryOrderdisFromSKU);    
                    }else{
                        component.set("v.SingleOrderItem.earlyOrderDiscount",null);
                    }
                    
                }else{
                    //getting 0% discount
                    console.log('outside condition for early order discount');
                    component.set("v.SingleOrderItem.earlyOrderDiscount",0);
                }
                
                
                
                var tmpEarlyOrder = component.get("v.SingleOrderItem.earlyOrderDiscount");
                component.set("v.tmpEarlyOrderDis",tmpEarlyOrder);
                
                
                helper.gettingBigVolDiscount(component,event,helper,combinationKey);  
                helper.gettingEarlyOrderDiscount(component,event,helper,combinationKey);
                console.log('single Order Item :'+JSON.stringify(component.get("v.SingleOrderItem")));
               //Added by Nandhini
               /* if(singlLineItem.UOM == 'PAC'){
                    component.set("v.isDistributor", true);
                }else{
                    component.set("v.isDistributor", isDistributors);
                }*/
                
            }else{
                
                console.log('when close Button click');
                var orderId = component.get("v.sOId");
                console.log('orderId in close button '+orderId);
                if(orderId==undefined){
                    helper.resetSingleOrderItem(component);  
                }
                
                var cloneOrder = component.get("v.forClone");
                if(cloneOrder=='cloneOrder'){
                    console.log('in close button in clone order');
                    // helper.resetSingleOrderItem(component); 
                }
                
            }
            
        }
        
    },
    
    keyupdemo:function(component,event,helper){
        console.log('in keyupdemo function');  
    },
    
    
    calculateFinalBase :function(component,event,helper){
        
        console.log('single Order Item inside base price:'+JSON.stringify(component.get("v.SingleOrderItem")));
        var target = event.getSource();  
        var bsPrice = target.get("v.value");
        console.log('bsPrice '+bsPrice);
        var flgcomma = true;
        console.log('bsPrice comma '+bsPrice)
        /* if(bsPrice.match(',')){
            flgcomma =false;
        }else{
            flgcomma = true;
        }*/
        
        
        
        var errorMessage = '';
        var warningMessage = '';
        
        /* if(isNaN(bsPrice)){
            console.log('charac');
            flgcomma = false;
            component.set("v.SingleOrderItem.basePrice",'');
            
        }else{
            flgcomma = true;
        }*/
        
        if(bsPrice>0){ 
            helper.updateRowCalculations2(component,event,helper);
            errorMessage= $A.get("");
            target.set("v.errors", [{message:errorMessage}]);
            $A.util.addClass(target, "error");
            
        }
        else{
            errorMessage= $A.get("$Label.c.Please_enter_Base_Price");
            target.set("v.errors", [{message:errorMessage}]);
            $A.util.addClass(target, "error");
        }
        
    },
    
    restrictBasePriceCart: function(component, event, helper){
        console.log('base price change in cart');
        var target = event.getSource();  
        var bsPrice = target.get("v.value");
        
        
        
        var flgcomma = true;
        console.log('bsPrice comma '+bsPrice)
        
        
        
        
        
        
        var rowIndex = target.get("v.labelClass");
        var orderItemList = component.get("v.orderItemList");
        
        var flag = false;
        var errorMessage = '';
        var warningMessage = '';
        
        
        if(bsPrice>0){
            flag = false;
            target.set("v.errors", [{message:''}]);
            $A.util.addClass(target, "error");
            helper.updateBasePriceCart(component, event, helper,rowIndex,bsPrice);
            
            helper.updategrossAmmount(component, event, helper);
            helper.clubbingSKU(component,event,helper);
            
        }else{
            errorMessage= $A.get("$Label.c.Please_enter_Base_Price");
            target.set("v.errors", [{message:errorMessage}]);
            $A.util.addClass(target, "error");
            target.set("v.value",0);
        }
        
    },
    
    gotoRecordBack: function(component, event, helper){
        var recIds ='';
        var recId = component.get("v.sOId");
        if(recId){
            recIds = recId;
        }else{
            var recIds = component.get("v.recordId");    
        }
        
        
        console.log('gotoRecordBack function '+recIds);
        
        if(recIds!=undefined){
            helper.gotoURL(component,recIds);    
        }else{
            window.history.back();
        }
        
        // helper.gotoURL(component,recIds);    
        
    },
    
    onChangePaymentTerm : function(component,event,helper){	
        console.log('onChangePaymentTerm Method ');	
        var target = event.getSource();  	
        var ptmtrrm = target.get("v.value");	
        console.log('ptmtrrm '+ptmtrrm);	
        
        /*  if(ptmtrrm=='none'){	
            	
            target.set("v.errors", [{message:$A.get("$Label.c.Please_select_Payment_Terms")}]);	
            $A.util.addClass(target, "error");	
        }else{	
            target.set("v.errors", [{message:''}]);	
            $A.util.addClass(target, "error");	
        }*/	
        
    },
    
    
    onChangeManulDiscountCart:function(component,event,helper){
        var target = event.getSource();  
        var rowIndex = target.get("v.labelClass");
        var orderItemList = component.get("v.orderItemList");
        var mnaDis = orderItemList[rowIndex].manualDiscount;
        var flgmDis = true;
        
        if(mnaDis<0){
            console.log('negetaive value enterd');
            flgmDis = false;
            orderItemList[rowIndex].manualDiscount =0;
            var toastMsg = $A.get("$Label.c.Manual_Discount_should_Be_positive");
            helper.showErrorToast(component, event, toastMsg); 
            var qtTem = orderItemList[rowIndex].qty;
            var bsprce = orderItemList[rowIndex].basePrice; 
            var mnalDis = orderItemList[rowIndex].manualDiscount;
            
            var qtTem1;
            if(qtTem==undefined){
                qtTem1=0;
            }else{
                qtTem1 =qtTem;
            }
            
            var bsprce1;
            if(bsprce==undefined){
                bsprce1=0;
            }else{
                bsprce1=bsprce;
            }
            
            var mnalDis1;
            if(mnalDis==undefined){
                mnalDis1=0;
            }else{
                mnalDis1=mnalDis;
            }
            
            var fnlprce = 0.0;
            
            fnlprce= bsprce1 - (bsprce1*mnalDis1/100);
            orderItemList[rowIndex].finalPrice=fnlprce;
            var ntValue = (fnlprce* qtTem1);
            ntValue = Math.round((ntValue + Number.EPSILON) * 100) / 100;
            orderItemList[rowIndex].netValue=fnlprce;
            
            component.set("v.orderItemList",orderItemList);
            
            helper.updategrossAmmount(component, event, helper);
            helper.clubbingSKU(component, event, helper);
            
        }else{
            console.log('Positive value enterd');
            flgmDis = true;
        }
        if(flgmDis){
            helper.onChangeManulDiscountCartHlpr(component,event,helper,rowIndex);
        }
    },
    
    changetoTextEdit:function(component,event,helper){
        console.log('EDit to text function');
        component.set("v.showBasePriceCartformat",true);
        component.set("v.showBasePriceCartformat1",false);
        
    },
    
    changetoTextEditQty:function(component,event,helper){
        console.log('EDit to text function Quantity '); 
        component.set("v.showQtyCartformat",true);
        component.set("v.showQtyCartformat1",false);
        
        
    },
    
    handleChangeInco:function(component,event,helper){
        console.log('in inco term change');
    },
    
    /* ----------------- Start SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022 -------------- */
    restrictPODate: function(component,event,helper){
        
    },
    /* ----------------- End SKI(Vishal P) : #CR152 : PO and Delivery Date : 29-09-2022 --------------- */
    
    
    
    
})