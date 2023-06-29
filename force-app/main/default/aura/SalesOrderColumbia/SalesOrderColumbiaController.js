({
    
    // Init method to initalize default values in form on component load. 
    doInit: function(component, event, helper) {
        if(component.get("v.sObjectName") == 'Account'){
            helper.checkOldSalesOrg(component);
        }
		else {
        helper.getUserInfo(component, event, helper);
     
        window.setTimeout($A.getCallback(function() {helper.getOrderFields(component);}),2000 );
       // alert(window.location.href);
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
    
    
    //Logic to show confirmation dialog with Simulation Flag & Message on Save and Submit.
    openConfirmDialog : function(component, event, helper) {
        var selected = event.getSource().get("v.label");
         component.set("v.newSalesOrder.Total_Sales_USD__c",component.get("v.totalSalesUSD"));
            if(selected=="Confirm" || selected=="Confirmación"){
                component.set("v.isDraft", false);
                component.set("v.skipPO",false);    //  SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022...
                helper.createSalesOrder(component, event, "Submitted");
            }
            else{
                component.set("v.isDraft", true);
                component.set("v.skipPO",true);     //  SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022...
                helper.createSalesOrder(component, event, "Draft");  
            }
    },
    
    // Method used to Download SalesOrder PDF (Calls visualforce page)
    renderedPDF:function(component, event, helper){
        var recordId = component.get('v.sOId');
        window.open('/apex/SalesOrderCol_pdf?id1='+recordId);
    },
    
    
    // Method use to enable Editing of Order Form using 'Edit' button 
    // Enabled when order status is 'Draft/Rejected'
    editForm : function(component, event, helper) {
        helper.editForm(component);
    },
   
    
    //Event used to get selected row from 'Lightning Data Table' Component (Used for Account/SOM/Product)
    tabActionClicked: function(component, event, helper){
        //get the id of the action being fired
        var actionId = event.getParam('actionId');
        //get the row where click happened and its position
        var itemRow = event.getParam('row');
        console.log('itemRow'+JSON.stringify(itemRow));
        /* --------------Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022-------------- */
        var crDt = new Date();
        var today = new Date(crDt.getTime() + 86400000); // for current date + 1 ...
        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        var currentDate = (yyyy + "-" + MM + "-" + dd); 
        /* --------------End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022---------------- */
        var OrderType = component.get("v.newSalesOrder.Order_Type_Colombia__c");
        if(actionId == 'selectproduct'){
            var rowIndex = component.get("v.rowIndex");
            console.log('rowIndex-'+rowIndex);
            var orderItemList = component.get("v.orderItemList");
            var businessTypes = component.get("v.businessTypesList");
                
            var getProductId = component.find("itemproduct");
                    
            var getItemSelId = component.find("itemsel");
            var isProductArray = false;
            if(OrderType =='MPT Order'){
            isProductArray = Array.isArray(getProductId);
            }else{
            isProductArray = Array.isArray(component.find("normalitemproduct"));      
            }
                
            console.log('rowIndex>>>before for'+rowIndex+'<<<OrderTpe>>>'+OrderType);        
            for (var idx=0; idx < orderItemList.length; idx++) {
                        if (idx==rowIndex) {
                            if(rowIndex==0){
                                console.log("OrderType>>--->"+OrderType);
                                 if(OrderType =='MPT Order'){ 
                                   
                                orderItemList[idx].typeOfBusiness = businessTypes[0];//"Producto Inicial"; 
                                if(orderItemList[idx].typeOfBusiness=="Producto Inicial"){
                                       component.find("businessTypeOptions").set("v.disabled",true);
                                    }    
                                }
                                  console.log("OrderType>>--->"+OrderType);  
                            }
                             console.log('isProductArray->>>isProductArray'+isProductArray);
                            if(isProductArray){
                                 
                                 if(OrderType =='MPT Order'){
                                component.find("businessTypeOptions")[idx].set("v.disabled",false);
                                component.find("itemproduct")[idx].set("v.errors",null);     
                                 }else{
                                       console.log('rowIndex->>>normalitemproduct'+rowIndex);
                                    component.find("normalitemproduct")[idx].set("v.errors",null); 
                                 }     
                            }
                            else{
                                console.log('rowIndex->>>normalitemproduct---else'+rowIndex);
                                if(OrderType =='MPT Order'){
                                component.find("itemproduct").set("v.errors",null);
                                }else{
                                    console.log('rowIndex->>>normalitemproduct---else---else'+rowIndex);
                                	console.log('-----------------------'+component.find("normalitemproduct"));
                                    component.find("normalitemproduct").set("v.errors",null);
                                    console.log('rowIndex->>>normalitemproduct---else---after else'+rowIndex);
                                }      
                            }
                            if(OrderType =='MPT Order'){
                            orderItemList[idx].typeOfBusiness = businessTypes[0];
                            }//if(isProductArray){
                               // component.find("itemunitvalue")[idx].set("v.disabled",false);
                          // }
                            console.log('rowIndex>>> inside'+rowIndex);
                            orderItemList[idx].inventory = itemRow.balanceQty;
                            orderItemList[idx].productId = itemRow.skuId;
                            orderItemList[idx].productName = itemRow.skuDescription;
                            orderItemList[idx].UOM = itemRow.UOM;
                            orderItemList[idx].productCode = itemRow.skuCode;
                            orderItemList[idx].itemNo =idx;// itemRow.itemNo;
                            orderItemList[idx].minValue = itemRow.minValue;
                            console.log('itemRow.itemNo>>--->'+itemRow.itemNo);
                               console.log('rowIndex->>>last'+rowIndex);
                            if(itemRow.unitCost!= undefined)
                            {
                                orderItemList[idx].unitCost = itemRow.unitCost;
                            }else{
                                 orderItemList[idx].unitCost =0;
                            }
                            if(itemRow.maxPrice!=0){
                                orderItemList[idx].qty = '';
                            }
                            orderItemList[idx].maxPrice = itemRow.maxPrice;
                            if(component.get("v.isCommunityUser")){
                                orderItemList[idx].unitValue = itemRow.maxPrice
                                helper.normalUpdateRowCalculations(component, event, helper);
                            }
                   }
              }
        }
     //console.log('orderItemList'+JSON.stringify(orderItemList));
     component.set('v.orderItemList', orderItemList);
     helper.closePopUp(component);
    },
    
    
    //handle business type change
    handleBusinessChange: function(component,event,helper){
        var businessTypes = component.get("v.businessTypesList");
        var target = event.getSource();  
        var rowIndex = component.get("v.rowIndex");
        //alert('rowIndex>>--->'+rowIndex);
        var orderItemList = component.get("v.orderItemList");
        var mtpParamObj =component.get("v.adminMPTParam");
        var initialPosition =rowIndex;
        var rowLimit =0;
        var flag =false;
        var flag1 =false;
        var msg ='';
     //   alert(JSON.stringify(mtpParamObj));
        if(mtpParamObj){
           rowLimit =  mtpParamObj.Max_no_of_prod_asso_with_initial_product__c;
        }
          //patch for 1st record on mobile type initial Product
        orderItemList[0].typeOfBusiness = 'Producto Inicial';  
        //alert('orderItemList>>-->'+JSON.stringify(orderItemList));
         component.set("v.orderItemList",orderItemList);
       
        orderItemList = component.get("v.orderItemList");
        for (var idx=0; idx < orderItemList.length; idx++) {
            if (idx==rowIndex){
                   
                if(idx!=0){
                component.find("itemqty")[idx].set("v.value",'0');    
                }
                if(target.get("v.value") == "Impacto Producto" || target.get("v.value") == 'Impacto Negocio'){
                    component.find("itemunitvalue")[idx].set("v.disabled",true);
                    if(target.get("v.value") == "Impacto Producto"){
                        console.log(idx+' - '+rowIndex);
                        for (var idx1=rowIndex; idx1 >=0; idx1--) {
                            if(orderItemList[idx1].typeOfBusiness=='Producto Inicial'){
                                initialPosition =idx1;
                                break;
                            }
                        }
                      // console.log(initialPosition+'- - '+rowLimit);
                        if(rowIndex-initialPosition>rowLimit){
                            component.find("itemproduct")[idx].set("v.errors",[{message:"Product Impact Limit exceeded"}]); 
                            flag = true;
                            msg = $A.get("$Label.c.Product_Impact_Limit_exceeded");
                            orderItemList[idx].productName='';
                            component.find("maxPric")[idx].set("v.value",0); 
                            orderItemList[idx].qty =0;
                        }else
                            if(orderItemList[initialPosition].productId != orderItemList[initialPosition+1].productId){
                                
                                if(initialPosition+1!=rowIndex){
                                for (var idx1=rowIndex; idx1 >initialPosition; idx1--) {
                                   if(orderItemList[idx1].productId==orderItemList[initialPosition].productId){
                                        component.find("itemproduct")[rowIndex].set("v.errors",[{message:$A.get("$Label.c.You_cannot_add_initial_Product_again")}]); 
                                         flag = true;
                                         msg = $A.get("$Label.c.You_cannot_add_initial_Product_again");
                                         orderItemList[rowIndex].productName='';
                                         component.find("maxPric")[idx].set("v.value",0);  
                                         orderItemList[idx].qty =0;
                                        break;
                                   }
                                }
                              }
                            }
                        else if(orderItemList[idx].productId != orderItemList[initialPosition].productId){
                            component.find("itemproduct")[idx].set("v.errors",[{message:$A.get("$Label.c.You_cannot_add_a_Different_Product")}]); 
                            flag = true;
                            msg = $A.get("$Label.c.You_cannot_add_a_Different_Product");
                            orderItemList[idx].productName='';
                            component.find("maxPric")[idx].set("v.value",0); 
                            orderItemList[idx].qty =0;
                        }else{
                            flag = false;
                            console.log('no error');
                            component.find("itemproduct")[idx].set("v.errors",null);  
                        }
                    } 
                    //Desc:if adding product impact right after business Impact
                    if(target.get("v.value") == "Impacto Producto"){
                        
                        for (var idx1=rowIndex; idx1 >initialPosition; idx1--) {
                            //console.log(orderItemList[idx1].typeOfBusiness);
                            if(orderItemList[idx1].typeOfBusiness=='Impacto Negocio'){
                                component.find("itemproduct")[rowIndex].set("v.errors",[{message:"Please Add Initial Product first"}]); 
                                flag1 = true;
                                msg ="Please Add Initial Product first";
                                orderItemList[rowIndex].productName='';
                                component.find("maxPric")[idx].set("v.value",0); 
                                orderItemList[idx].qty =0;
                                break;
                            }else{
                                flag1 = false;
                                component.find("itemproduct")[idx].set("v.errors",null);  
                            }
                        }
                    }
                    
                    if(flag || flag1 ){
                         helper.showErrorToast(component, event, msg);
                      
                    }
                    else{
                    //component.find("itemunitvalue")[idx].set("v.value",0);
                    //component.find("itemunitvalue")[idx].set("v.errors",null); 
                    //component.find("itemunitvalue")[idx].set("v.disabled",true);  
                    orderItemList[idx].netSales ='';
                    orderItemList[idx].netPrice ='';
                        
                    }
                }else{
                    component.find("itemunitvalue")[idx].set("v.disabled",false);  
                }
            }  
        }
       
    },
    //Replace Negative Sign from Quantity Input
   restrictQuantity: function(component, event, helper){
       
        var target = event.getSource(); 
       
        var qty = target.get("v.value");
        var rowIndex = component.get("v.rowIndex");
        var setValue = null;
        var flag = false;
        var errorMessage = '';
       
       	 if(qty){
       var qtyString = qty;//.toString();
           console.log(qtyString+'==='+qtyString);  
           console.log(qtyString+'==='+qtyString.includes('.'));  
       if(qtyString.includes('.')){
          errorMessage=$A.get("$Label.c.Only_number_allowed")//$A.get("$Label.c.Please_enter_Quantity");
           target.set("v.errors", [{message:errorMessage}]);
           $A.util.addClass(target, "error"); 
           qtyString =  qtyString.replace('.','');
           target.set("v.value",qtyString);
       }else if(qtyString.includes(',')){
          errorMessage=$A.get("$Label.c.Only_number_allowed")//$A.get("$Label.c.Please_enter_Quantity");
           target.set("v.errors", [{message:errorMessage}]);
           $A.util.addClass(target, "error"); 
           qtyString =  qtyString.replace(',','');
           target.set("v.value",qtyString);
       }else{     
           qtyString = qtyString.replace(',','');
           qtyString = qtyString.replace('.','');
           qtyString = qtyString.replace('-','');
           qtyString = qtyString.replace(/[^a-zA-Z0-9]/,'');
           qtyString = qtyString.replace(/([a-zA-Z ])/g,'');
           console.log(qtyString+'==='+qtyString);
           target.set("v.value",qtyString);
           target.set("v.errors", null); 
           $A.util.removeClass(target, "error");
           helper.normalUpdateRowCalculations(component, event, helper);
           }         
         }else{
            errorMessage= $A.get("$Label.c.Please_enter_Quantity");
            target.set("v.errors", [{message:errorMessage}]);
            $A.util.addClass(target, "error");
            helper.normalUpdateRowCalculations(component, event, helper); 
         }         
       
   		},
    
    handleOrderTypeChange : function(component, event, helper){ 
         var target = event.getSource();
        if(target.value !='None'){
            component.find("OrderTypeOptions").set("v.errors",null);                    
            $A.util.removeClass(component.find("OrderTypeOptions"), "error");
        }else{
             component.find("OrderTypeOptions").set("v.errors",[{message: $A.get("$Label.c.Please_select_order_type")}]);  
             $A.util.addClass(component.find("OrderTypeOptions"), "error");
            var toastMsg =  $A.get("$Label.c.Please_select_order_type");
            helper.showErrorToast(component, event, toastMsg);  
        }    
       
    },
     // Logic to update current row with calculations
    updateTableRow : function(component, event, helper) {
        
        var target = event.getSource();  
        var qty = target.get("v.value");
        var currentidx = target.get("v.requiredIndicatorClass");
        console.log('currentidx>>--->'+currentidx);
        component.set("v.currentIndex",currentidx);
        var setValue = null;
        var flag = false;
        var errorMessage = '';
        console.log('qty'+qty);
        if(qty){
            flag = false;
            var qtyString = qty.toString(); //Convert to string
            
            if(qtyString.includes('.')){
            errorMessage=$A.get("$Label.c.Only_number_allowed");//$A.get("$Label.c.Please_enter_Quantity");
            target.set("v.errors", [{message:errorMessage}]);
            $A.util.addClass(target, "error");
            qtyString =  qtyString.replace('.','');
           target.set("v.value",qtyString);
            }else if(qtyString.includes(',')){
           errorMessage=$A.get("$Label.c.Only_number_allowed") ;//$A.get("$Label.c.Please_enter_Quantity");
           target.set("v.errors", [{message:errorMessage}]);
           $A.util.addClass(target, "error"); 
           qtyString =  qtyString.replace(',','');
           target.set("v.value",qtyString);
       }else{
               qtyString = qtyString.replace(',','');
               qtyString = qtyString.replace('.','');
               qtyString = qtyString.replace('-','');
               qtyString = qtyString.replace(/[^a-zA-Z0-9]/,'');
               qtyString = qtyString.replace(/([a-zA-Z ])/g,'');
               console.log(qtyString+'==='+qtyString);
               target.set("v.value",qtyString);
                target.set("v.errors", null); 
                $A.util.removeClass(target, "error");
               helper.updateRowCalculations(component, event, helper); 
            }
        }else{
            errorMessage= $A.get("$Label.c.Please_enter_Quantity");
            target.set("v.errors", [{message:errorMessage}]);
            $A.util.addClass(target, "error");
        }
       },
    normalUpdateTableRow : function(component, event,helper){
      var target = event.getSource();  
        var unitValue = target.get("v.value");
        var minValue = target.get("v.requiredIndicatorClass");
        var prsntValue = 0 ;
        var setBlank = 0;
        var rowIndex = component.get("v.rowIndex");
        var errorMessage = '';
        if(unitValue) {
            //var unitValueFixed  = unitValue.toFixed(2);
            var unitValueFixed  = unitValue;
            target.set("v.value",unitValueFixed);
        }else{
             errorMessage= $A.get("$Label.c.Please_enter_Final_Price");
             target.set("v.errors", [{message:errorMessage}]);
             $A.util.addClass(target, "error");
            helper.normalUpdateRowCalculations(component, event, helper);
        }
       if(unitValue) {
         if(minValue > unitValue){
           helper.showErrorToast(component, event, $A.get("$Label.c.Final_Price_isn_t_allowed"));
             //target.set("v.errors", [{message: $A.get("$Label.c.Final_Price_isn_t_allowed")}]);
            target.set("v.value",'0');
            //$A.util.addClass(target, "error");  
            console.log('minValue'+minValue);
            console.log('prsntValue'+prsntValue);
        } 
        else{
            target.set("v.errors", null); 
            $A.util.removeClass(target, "error");
            helper.normalUpdateRowCalculations(component, event, helper);
        }
       }  
    },
    
    //DIVYA: 16-01-2020: Added new section for SCTASK0102624-Colombia MPT Order Final Price Change
    MPTUpdateTableRow : function(component, event,helper){
      var target = event.getSource();  
        var unitValue = target.get("v.value");
        var maxPrice = target.get("v.requiredIndicatorClass");
        var prsntValue = 0 ;
        var setBlank = 0;
        var rowIndex = component.get("v.rowIndex");
        var errorMessage = '';
        if(unitValue && unitValue > 0) {
            //var unitValueFixed  = unitValue.toFixed(2);
            
            var unitValueFixed  = unitValue;
            target.set("v.value",unitValueFixed);
        }else{
             errorMessage= $A.get("$Label.c.Please_enter_Final_Price");
             target.set("v.errors", [{message:errorMessage}]);
             $A.util.addClass(target, "error");
            helper.updateRowCalculations(component, event, helper);
        }
       if(unitValue) {
         if(maxPrice > unitValue){
           helper.showErrorToast(component, event, $A.get("$Label.c.Final_Price_isn_t_allowed"));
             //target.set("v.errors", [{message: $A.get("$Label.c.Final_Price_isn_t_allowed")}]);
            target.set("v.value",'0');
            //$A.util.addClass(target, "error");  
            //console.log('minValue'+minValue);
            console.log('prsntValue'+prsntValue);
        } 
        else{
            target.set("v.errors", null); 
            $A.util.removeClass(target, "error");
            helper.updateRowCalculations(component, event, helper);
        }
       }  
    },

    // Logic to handle shipping changs 
    handleShipLocChange : function(component, event){
        var shippingLoc = component.get("v.shippingLoc");
        
        if(shippingLoc!='None'){
            var inputCmp = component.find("shippListOptions");
            inputCmp.set("v.errors", null);
            $A.util.removeClass(inputCmp, "error");
            var ShippingLocMap = component.get("v.ShippingLocMap");
            var slObj = ShippingLocMap[shippingLoc];
            console.log(slObj);
            if(slObj!=undefined){
                component.set("v.newSalesOrder.Ship_To_Party__c", slObj.Id);
                component.set("v.selItem", slObj);
               // console.log(component.get("v.selItem"));
            }
        }else{
            component.set("v.selItem", '');
            component.set("v.newSalesOrder.Ship_To_Party__c", '');
        }
    }, 
    
    
    //uploading attachment 
    handleFilesChange : function(component, event, helper) {
         var file = component.find("fileId");
         var fileName = component.find("fileId").get("v.files");
         
            if(file.get("v.files") == null){
                flag = false;
                component.set("v.noFileError",false);
            	component.set("v.fileName",$A.get("Please select file"));
            }else{
               if(fileName[0].type.includes('/vnd.ms-excel') || fileName[0].type.includes('/pdf') || fileName[0].type.includes('spreadsheetml') ||fileName[0].type.includes('/png')){
                   component.set("v.noFileError",true);				           
                   component.set("v.fileName",fileName[0].name);
               }else{
                   component.set("v.noFileError",false);
                   component.set("v.fileName",$A.get("Please select Correct file"));
                    component.find("fileId").set("v.value", []);
               }
	      }
    },
    
    // Logic to show Product Selection Modal        
    openPriceDeatilsPopUp : function(component, event, helper) {
        var target = event.getSource();  
        var rowIndexValue = target.get("v.value");
        console.log('rowIndexValue>>--->'+rowIndexValue);
        console.log('target'+target);
        component.set("v.modalHeader", $A.get("$Label.c.Products"));
        component.set("v.rowIndex",rowIndexValue);
        
        var pricedata = component.find("pricedata1");
        $A.util.removeClass(pricedata, 'slds-hide');
        
        helper.toggle(component);
    },  
    
     // Logic to show approval/rejection modal
    openDialog : function(component, event, helper) {
        var selected = event.getSource().get("v.label");
        var status = "";
       
        if(selected==$A.get("$Label.c.Approve")){
            component.set("v.isApproval",true);
            status = "Draft";	
        }
        else{
            component.set("v.isApproval",false);
            status = "Draft";	
        }
          helper.toggleDialog(component);
    },
    
    
    // Logic to Add Order Line Item 
    addTableRow : function(component, event, helper){
        component.set("v.skipPO", true);    //  SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022...
        var isValid = helper.validateOrder(component); 
        console.log('isValid>>--->'+isValid);
        var isValidItems = helper.validateOrderItems(component);
        var LastValue =0;
        var OrderType = component.get("v.newSalesOrder.Order_Type_Colombia__c");
        var orderItemList = component.get("v.orderItemList");
        var isProductArray = false;
        if(OrderType == 'MPT Order'){
        var getProductId = component.find("itemproduct");
 	        isProductArray = Array.isArray(getProductId);    
        }else{
        var getProductId = component.find("normalitemproduct");
        isProductArray = Array.isArray(getProductId);       
        }
        /* ----------------Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022------------ */
        var crDt = new Date();
        var today = new Date(crDt.getTime() + 86400000); // for current date + 1 ...
        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        var currentDate = (yyyy + "-" + MM + "-" + dd); 
        /* ---------------End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022-------------- */
       console.log('LastValue--'+LastValue);
      
        //Initialize validation flag to false
        var flag = false;
        
        //Check if order has line items and then check if all inputs are valid before adding new line item
        if(orderItemList.length > 0){
            if(isValid && isValidItems){
                flag = true;
            }
        }
        else if(isValid){
            flag = true;
        }
        console.log('flag'+flag);
        console.log('orderItemList.length'+orderItemList.length);
        if(flag){
        if(orderItemList.length == 1 && !component.get("v.isCommunityUser")){
        	component.find("OrderTypeOptions").set("v.disabled",true);
        }else{
            if(!component.get("v.isCommunityUser")){
                component.find("OrderTypeOptions").set("v.disabled",true);
            }
        }    
        if(orderItemList.length >=1){
             for (var idx=0; idx < orderItemList.length; idx++) {
                 if(isProductArray){
                     if(OrderType =='MPT Order'){
                      component.find("businessTypeOptions")[idx].set("v.disabled",true);
                      component.find("itemsel")[idx].set("v.disabled",true); 
                      component.find("deleteBtn")[0].set("v.disabled",true); 
                     }else{
                      component.find("normalitemsel")[idx].set("v.disabled",true); 
                     // component.find("normaldeleteBtn")[0].set("v.disabled",true);  
                     }
                     
                      LastValue = idx;
                 }else{
                     if(OrderType =='MPT Order'){ 
                     	component.find("itemsel").set("v.disabled",true); 
                     	component.find("businessTypeOptions").set("v.disabled",true);
                     	component.find("deleteBtn").set("v.disabled",true); 
                     }else{
                         component.find("normalitemsel").set("v.disabled",true);
                        // component.find("normaldeleteBtn").set("v.disabled",true); 
                     }
                      
                 }
             }
       } 
       }
       
         console.log('flag1'+flag);
        console.log('orderItemList.length1'+orderItemList.length);
        //If all validations are successful add new row
        if(flag){
            orderItemList.push({
                productId:"",
                priceBookDetailId: "",
                productName:"", 
                qty:"0", 
                unitValue:"0", 
                discount:"0",
                discount_percent:"0",
                profit:"0",
                netSales:"0",
                netPrice:"0",
                margin:"0",
                netMargin:"0",
                unitValueWithInterest:"0",
                totalValue:"0", 
                totalValueWithInterest:"0",
                interestRate:"0", 
                days: "0", 
                timeInMonths: "0"
            });
            
            component.set("v.orderItemList",orderItemList);
            
            //disable row's type of business 
            LastValue = LastValue + 1;
             if(OrderType =='MPT Order'){
            if(Array.isArray(component.find("itemproduct"))){
               
                component.find("businessTypeOptions")[LastValue].set("v.disabled",true);
                       
            }else{ 
                       component.find("businessTypeOptions").set("v.disabled",true);    
            }
             }      
        }else{
            var toastMsg = $A.get("$Label.c.Please_provide_valid_input_fill_all_the_mandatory_fields_before_proceeding");
            helper.showErrorToast(component, event, toastMsg);
        }
    },
    
    normalremoveTableRow : function(component, event, helper) {
        var target = event.getSource();  
        var index = target.get("v.value");
        var items = component.get("v.orderItemList");   
        var soId = component.get("v.sOId");
        if(index>=0){
        	items.splice(index, 1);   
        }
        component.set("v.orderItemList", items);
        var orderItems = component.get("v.orderItemList");
        console.log('orderItems>>-->'+orderItems);
        if(orderItems.length==0){
             if(soId==null || soId==undefined){
             component.find("OrderTypeOptions").set("v.disabled",false);
             }
        }else {
             component.find("OrderTypeOptions").set("v.disabled",true);
        }
         helper.normalUpdateRowCalculations(component, event, helper);
    },
    
    // Logic to remove Order Line Item
    removeTableRow : function(component, event, helper) {
        var target = event.getSource();  
        var index = target.get("v.value");
        var items = component.get("v.orderItemList");    
        var soId = component.get("v.sOId");
        console.log('index'+index);
        
        if(items.length<=2 && items.length!=1){  
            component.find("deleteBtn")[0].set("v.disabled",false); 
        }
        
        //logic to delete row associated with initial product
        console.log('items[index].productId'+items[index].productId);
        if( index != items.length - 1 && items[index].typeOfBusiness=='Producto Inicial' && items[index].productId!=null && items[index].productId!=''){
            for (var idx1=index+1; idx1<=items.length; idx1) {
                console.log('inside loop'+idx1);
                if(items[idx1]!=undefined){
                    console.log('inside loop2'+items[idx1]);
                    if(items[idx1].typeOfBusiness=='Impacto Producto'){
                        // component.set(items[idx1].typeOfBusiness,null);
                        component.set("v.businessTypesList", null);
                        items.splice(idx1, 1);  
                        component.set("v.businessTypesList", component.get("v.businessTypesListCopy"));     
                    }else{break;}
                }else{break;}
            }
        }
        //logic end
        if(index == items.length - 1){
            console.log('if index'+index);
            component.set("v.businessTypesList", null);
            items.splice(index, 1);
            component.set("v.businessTypesList", component.get("v.businessTypesListCopy"));     
        }
        else{
            console.log('else index'+index);
            items.splice(index, 1);
        }
        /*for(var idx=0;items.length;idx++){
           items.itemNo = idx; 
        }*/
        
        //console.log(JSON.stringify(items));
        component.set("v.orderItemList", items);
        var orderItem = component.get("v.orderItemList");    
        if(orderItem.length==1){ 
            console.log('orderItem.length'+orderItem.length);
           // component.find("deleteBtn")[0].set("v.disabled",true); 
        }
        if(orderItem.length==0){
            if(soId==null || soId==undefined){
                component.find("OrderTypeOptions").set("v.disabled",false); 
            }
        }
        helper.updateRowCalculations(component, event, helper);
    },
    
    // Save Comments while Approving / Rejecting Order
    saveComment : function(component,event,helper) {
        var isApproved = false;
        var msg = '';
        if(component.get("v.isApproval")){
            status = "Approved";
            isApproved = true;
            msg = $A.get("$Label.c.Are_you_sure_you_want_to_Approve_the_Sales_Order");
        }
        else{
            status = "Rejected";
            isApproved = false;
            msg = $A.get("$Label.c.Are_you_sure_you_want_to_Reject_the_Sales_Order");
        }        
        if(confirm(msg)){    
            var action = component.get("c.processApproval");
           // console.log('');
            action.setParams({
                isApproved: isApproved,
                recordId: component.get("v.sOId"),
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
                    console.log('component.get("v.sOId")'+component.get("v.sOId"));
                    helper.gotoURL(component, component.get("v.sOId"));
                  }	
            });
            helper.toggleDialog(component);
            $A.enqueueAction(action);
        }
    },
    /* ------------------Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022--------------------- */
    validateDate:function(component, event, helper){
        var target = event.getSource();  
        var index = target.get("v.class"); 
        var ordItem = component.get("v.orderItemList"); 
        var obj = new Object(ordItem[index]); 
        var flag = false;
        var showDel = component.get("v.showDeliveryDate");
        var reqDel = component.get("v.isDeliveryDateReq");
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
            if(+x < +y){     
                flag = true;
                target.focus();
                target.set("v.value",''); 
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
    /* -----------------End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022-------------------- */
})