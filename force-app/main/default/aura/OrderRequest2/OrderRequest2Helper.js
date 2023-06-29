({
    //Logic to show/hide modal by toggling css class .tog
    toggle: function(component){
        var lookupmodal = component.find("lookupmodal");
        $A.util.toggleClass(lookupmodal, "slds-hide");
        
        var backdrop = component.find("backdrop");
        $A.util.toggleClass(backdrop, "slds-hide");
    },
    
    //Logic to show/hide modal by toggling css class .tog2
    toggleDialog: function(component){
        var dialog = component.find("approvalDialog");
        $A.util.toggleClass(dialog, "slds-hide");
        
        var backdrop2 = component.find("backdrop2");
        $A.util.toggleClass(backdrop2, "slds-hide");
    },
    
    //Logic to show/hide confirm modal by toggling css class .tog3
    toggleConfirmDialog: function(component){
        var dialog = component.find("confirmDialog");
        $A.util.toggleClass(dialog, "slds-hide");
        
        var backdrop3 = component.find("backdrop3");
        $A.util.toggleClass(backdrop3, "slds-hide");
        
    },    
    
    //Logic to show/hide confirm modal by toggling css class .tog3
    toggleSignDialog: function(component){
        var dialog = component.find("signDialog");
        $A.util.toggleClass(dialog, "slds-hide");
        
        var backdrop4 = component.find("backdrop4");
        $A.util.toggleClass(backdrop4, "slds-hide");
    },  
    //logic to block browser back button
    redirectBack: function(component, event) {
        history.pushState(null, null, location.href);
        window.onpopstate = function () {
            history.go(1);
        };
        return false;
        
    },
    
    //Disable Currency/PriceList/SOM/Account/OrderType/Dates
    enableDisableFields: function(component, length){
        var orderType = component.get("v.orderType");
        var isChecked= component.find("campChk").get("v.value");
        //console.log('Length: '+length);
        var keyAcc=component.get("v.showKeyAccount");
        var isPunctual=component.get("v.isPunctual");


        if(orderType != 'ORDEM FILHA'){
            if(length >= 1){
                component.set("v.disablePriceCurrency", true);
                component.set("v.disableOrderType_Dates_SOM_Account", true);
                component.set("v.disablePaymentMethod", true);
            //.....nik
            if(isChecked){
                component.find("simpCmp").set("v.disabled",true);
                component.find("structCmp").set("v.disabled",true);
            }
            if(orderType == 'VENDA NORMAL'){
                component.find("dirSaleYes").set("v.disabled",true);
                component.find("dirSaleNo").set("v.disabled",true);
            }

            if(keyAcc){
                component.find("keyYes").set("v.disabled",true);
                component.find("keyNo").set("v.disabled",true); 
            }

            if(isPunctual == true){
                component.find("punctualitydisc").set("v.disabled",true); 
            }
            
            component.find("campChk").set("v.disabled",true);
            component.find("orderTypeOptions").set("v.disabled",true);
            component.find("radio1").set("v.disabled",true);
            component.find("radio2").set("v.disabled",true);

            component.find("custitem").set("v.disabled",true);  // search icon id...nik
            component.find("itemShip").set("v.disabled",true);  // search icon id...nik
          //  component.find("ExpNumDays").set("v.disabled",true);
            component.find("descYes").set("v.disabled",true);
            component.find("descNo").set("v.disabled",true);

            }
            else{
                component.set("v.disablePriceCurrency", false);
                component.set("v.disableOrderType_Dates_SOM_Account", false);
                component.set("v.disablePaymentMethod", false);
            //....nik
            if(isChecked){
                component.find("simpCmp").set("v.disabled",false);
                component.find("structCmp").set("v.disabled",false);
            }
            if(orderType == 'VENDA NORMAL'){
                component.find("dirSaleYes").set("v.disabled",false);
                component.find("dirSaleNo").set("v.disabled",false);
            }

            if(keyAcc){
                component.find("keyYes").set("v.disabled",false);
                component.find("keyNo").set("v.disabled",false);
            }

            if(isPunctual == true){
                component.find("punctualitydisc").set("v.disabled",false); 
            }

            component.find("campChk").set("v.disabled",false);
            component.find("orderTypeOptions").set("v.disabled",false);
            component.find("radio1").set("v.disabled",false);
            component.find("radio2").set("v.disabled",false);
            component.find("custitem").set("v.disabled",false);  // search icon id...nik
            component.find("itemShip").set("v.disabled",false);  // search icon id...nik
         //   component.find("ExpNumDays").set("v.disabled",false);
            component.find("descYes").set("v.disabled",false);
            component.find("descNo").set("v.disabled",false);
            }
           // var isPunctual = component.get("v.isPunctual");
            
            if(isPunctual==true){
                component.find("descNo").set("v.value", false);
            }
            
            var showKeyAccount = component.get("v.showKeyAccount");
            if(showKeyAccount==true){
                var showSeller = component.get("v.showSeller");
                if(showSeller){
                    if(showSeller==true){
                        component.find("keyNo").set("v.value", false);
                    }
                }
            }
            
        }
        else{
            if(length >= 1){
                component.set("v.disableOrderType_Dates_SOM_Account", true);

                 //.....nik
            if(isChecked){
                component.find("simpCmp").set("v.disabled",true);
                component.find("structCmp").set("v.disabled",true);
            }
            if(orderType == 'VENDA NORMAL'){
                component.find("dirSaleYes").set("v.disabled",true);
                component.find("dirSaleNo").set("v.disabled",true);
            }
            if(keyAcc){
                component.find("keyYes").set("v.disabled",true);
                component.find("keyNo").set("v.disabled",true); 
            }

            if(isPunctual == true){
                component.find("punctualitydisc").set("v.disabled",true); 
            }
           
            component.find("campChk").set("v.disabled",true);
            component.find("orderTypeOptions").set("v.disabled",true);
            component.find("radio1").set("v.disabled",true);
            component.find("radio2").set("v.disabled",true);
            component.find("custitem").set("v.disabled",true);  // search icon id...nik
            component.find("itemShip").set("v.disabled",true);  // search icon id...nik
          //  component.find("ExpNumDays").set("v.disabled",true);
            component.find("descYes").set("v.disabled",true);
            component.find("descNo").set("v.disabled",true);
            }
            else{
                component.set("v.disableOrderType_Dates_SOM_Account", false);

                //....nik
            if(isChecked){
                component.find("simpCmp").set("v.disabled",false);
                component.find("structCmp").set("v.disabled",false);
            }
            if(orderType == 'VENDA NORMAL'){
                component.find("dirSaleYes").set("v.disabled",false);
                component.find("dirSaleNo").set("v.disabled",false);
            }
            if(keyAcc){
                component.find("keyYes").set("v.disabled",false);
                component.find("keyNo").set("v.disabled",false);
            }

            if(isPunctual == true){
                component.find("punctualitydisc").set("v.disabled",false); 
            }
            component.find("campChk").set("v.disabled",false);
            component.find("orderTypeOptions").set("v.disabled",false);
            component.find("radio1").set("v.disabled",false);
            component.find("radio2").set("v.disabled",false);
            component.find("custitem").set("v.disabled",false);  // search icon id...nik
            component.find("itemShip").set("v.disabled",false);  // search icon id...nik
         //   component.find("ExpNumDays").set("v.disabled",false);
            component.find("descYes").set("v.disabled",false);
            component.find("descNo").set("v.disabled",false);
            }
        }
    },
    
    // 1. Used to Navigate to Standard List View on Salesforce1 App
    // 2. Commented Code was used earlier to Navigate to Custom List View Lighning Component
    navigateToComponent: function(component){
        /*var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:BrazilOrderListComponent"/*,
            componentAttributes: {
                contactName : component.get("v.contact.Name")
            }* /
        });
        evt.fire();*/
        
        /*var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "Sales_Order__c"
        });
        homeEvent.fire();*/
        
        //Replace listId with Production ID of 'Brazil Sales Orders'
        var listId = '00B0k000000Nxt9EAC';
        var navEvent = $A.get("e.force:navigateToList");
        
        if(navEvent!=undefined){
            
            navEvent.setParams({
                "listViewId": listId,
                "listViewName": null,
                "scope": "Sales_Order__c"
            });
            navEvent.fire();        
        }
        else{
            window.history.back();
        }
    },
    
    // 1. Method call to reload existing SO
    // 2. Called in getOrderFields() after all Fields are loaded.
    // 3. Uses recordId to fetch related data of a Regular/Simulated record.
    reloadSO: function(component,event){
        //var toastMsg = 'Please add items before saving Order';
        //this.showErrorToast(component, event, toastMsg);  
        
        var isSimulated = component.get("v.isSimulated");
        var flag = false;
        var pb_id='';

        if(isSimulated){
            component.set("v.headerMsg", $A.get("$Label.c.Create_Simulation_Order")); 
        }
        else{
            component.set("v.headerMsg", $A.get("$Label.c.Create_Order"));
        }
        
        var action = component.get("c.getSalesOrder");
        var soId = component.get("v.recordId");
        
        if(soId!=null){
            component.set("v.headerMsg", $A.get("$Label.c.VIEW_ORDER")); 
            
            action.setParams({
                soId: soId
            });
            
            //action.setStorable();
            
            action.setCallback(this, function(a) {
                var state = a.getState();
                if(state == "SUCCESS") {
                    var salesOrder = a.getReturnValue();
                    component.set("v.isEdit", false); //......nik..
                    component.set("v.newSalesOrder", salesOrder);
                    console.log('salesOrder: '+JSON.stringify(salesOrder));
                   // alert(salesOrder.Payment_Term__c);
                 
                    component.set("v.sfdcOrderNo", salesOrder.SalesOrderNumber_Brazil__c);

                     // selItem is an Sobject of Type Account
                // Reconstructing the object from Sales Order fields
                component.set("v.selItem", {'sobjectType': 'Account',
                'Id': salesOrder.Sold_to_Party__c, 
                'Name': salesOrder.Sold_to_Party__r.Name, 
                'Program_Margin_Discount__c': salesOrder.Sold_to_Party__r.Program_Margin_Discount__c,
                'SAP_Code__c': salesOrder.Sold_to_Party__r.SAP_Code__c,
                'Depot_Code__c': salesOrder.Sold_to_Party__r.Depot_Code__c,
                'Tax_Number_1__c': salesOrder.Sold_to_Party__r.Tax_Number_1__c,
                'Tax_Number_3__c': salesOrder.Sold_to_Party__r.Tax_Number_3__c,
                'Customer_Region__c': salesOrder.Sold_to_Party__r.Customer_Region__c,
                'BillingCity': salesOrder.Sold_to_Party__r.BillingCity});
                console.log('Account  obj-----> '+JSON.stringify(component.get("v.selItem"))); 



            // added by Nik..***************.
            if(salesOrder.Ship_To_Party__c != undefined){ 
                    console.log('Ship to party val .---> '+salesOrder.Ship_To_Party__c);
                 console.log('Length---> '+salesOrder.Ship_To_Party__c.length);
                if(salesOrder.Ship_To_Party__c.length > 0){
                    console.log('Test...---');
                    component.set("v.selItem5", {'sobjectType': 'Shipping_Location__c',
                                                    'Id': salesOrder.Ship_To_Party__c, 
                                                    'Location_Name__c': salesOrder.Ship_To_Party__r.Location_Name__c});
                }
            }
                //component.find("itemShipToParty").set("v.value",component.get("v.selItem6.Location_Name__c"));
                console.log('Shipto Party obj-----> '+component.get("v.selItem5.Location_Name__c"));
                     
                    var orderStatus = salesOrder.Order_Status__c;
                    var OpenUserTM = salesOrder.TM_Code__c;
                    var keyAccnt = salesOrder.Key_Account__c;
                    var selectedUsr = salesOrder.KeyAccountDesOwnerBrazil__c;
                    console.log('OpenUserTM'+OpenUserTM);
                    console.log('selectedUsr'+selectedUsr);
                    
                    if(orderStatus == 'Error from SAP'){
                        component.set("v.sapOrderNo", $A.get("$Label.c.Order_not_pushed_to_SAP"));
                    }
                    else{
                        component.set("v.sapOrderNo", salesOrder.SAP_Order_Number__c);
                    }
                    
                    if(orderStatus != "Draft"){
                        component.set("v.showValidFromTo", false);
                    }  
                    
                    //component.set("v.newSalesOrder.Price_Book__c", salesOrder.Price_Book__c);
                    
                    var punctualitydisc = component.get("v.newSalesOrder.Punctuality_Discount__c");
                    
                    //console.log('punctualitydisc: '+punctualitydisc);
                   // console.log('reload currency: '+JSON.stringify(salesOrder));
                    //console.log('reload currency2: '+a.getReturnValue().Currency_Brazil__c);
                    
                    component.set("v.selectedCurrency",a.getReturnValue().Currency_Brazil__c); 
                       
                  	component.set("v.priceBookId",a.getReturnValue().Price_Book__c);
                    //component.set("v.priceBookId",salesOrder.Sales_Order__r.Price_Book__c); 
                                  
                    component.set("v.orderType", salesOrder.Type_of_Order__c);
                    component.set("v.paymentTerm", salesOrder.ReloadPaymentTerms__c);
                    component.set("v.paymentMethod", salesOrder.PaymentMethod__c);
                    
                    //component.set("v.totalValue", salesOrder.TotalValueWithInterest__c);//Commented By Ganesh
                    
                    component.set("v.totalValue", salesOrder.TotalValueWithoutInterest__c); 
                    component.set("v.incoTerm", salesOrder.Inco_Term__r.IncoTerm_Code__c+','+salesOrder.Inco_Term__c);
                    component.set("v.showReset", false);
                    
                    //added by ganesh
                    //desc: to get business rule of reloaded record 
                    //console.log('salesOrder.Taxes__c'+salesOrder.Tax__c+'yy'+salesOrder.Freight__c);
                    
                    component.set("v.businessRule.Taxes__c", salesOrder.Tax__c);
                    component.set("v.businessRule.Freight__c", salesOrder.Freight__c);
                    
                    //console.log('a.getReturnValue().Price_Book__c'+a.getReturnValue().Price_Book__c);
                    
                    var orderType = salesOrder.Type_of_Order__c;
                    
                    //Enable Boolean to know the reloaded order is a Mother Order.
                    if(orderType=="CONTRATO MÃE"){
                        component.set("v.isMother",true);
                    }
                    
                    if(orderType=="ORDEM FILHA"){
                        // selItem3 is an Sobject of Type SOM i.e Sales Order
                        // Reconstructing the object from Sales Order fields
                        component.set("v.selItem3",{"Id": salesOrder.Sales_Order__c,
                                                    "Name": salesOrder.Sales_Order__r.Name,
                                                    "SAP_Order_Number__c": salesOrder.Sales_Order__r.SAP_Order_Number__c,
                                                    "Sold_to_Party__c": salesOrder.Sales_Order__r.Sold_to_Party__c,
                                                    "SalesOrderNumber_Brazil__c": salesOrder.Sales_Order__r.SalesOrderNumber_Brazil__c,
                                                    "Currency_Brazil__c": salesOrder.Sales_Order__r.Currency_Brazil__c,
                                                    "CurrencyIsoCode": salesOrder.Sales_Order__r.CurrencyIsoCode,
                                                    "Price_Book__c": salesOrder.Sales_Order__r.Price_Book__c,
                                                    "Type_of_Order__c": salesOrder.Sales_Order__r.Type_of_Order__c,
                                                    "ReloadPaymentTerms__c": salesOrder.Sales_Order__r.ReloadPaymentTerms__c,
                                                    "Sold_to_Party__r":
                                                    {"Name": salesOrder.Sales_Order__r.Sold_to_Party__r.Name,
                                                     "Customer_Group__c": salesOrder.Sales_Order__r.Sold_to_Party__r.Customer_Group__c,
                                                     "BillingCity": salesOrder.Sales_Order__r.Sold_to_Party__r.BillingCity,
                                                     "BillingState":salesOrder.Sales_Order__r.Sold_to_Party__r.BillingState,
                                                     "Id": salesOrder.Sales_Order__r.Sold_to_Party__c}});
                        
                    }      
                    
                    var user = component.get("v.user");
                    var ownerId = salesOrder.OwnerId;
                    var userId = component.get("v.userId");
                    var profileName = component.get("v.orderFields.userObj.Profile.Name");
                    
                     if((ownerId!=userId || isSimulated) && profileName!='Brazil Sales District Manager'){
                        component.set("v.showLedgerReplacement",true);
                    }
                    if(profileName!='Brazil Sales Person'){
                        component.set("v.showDiscount",true);
                    }
                    
                    //If User is owner of record & Order is a 'Simulation' or 'Draft' Order then enable delete
                    if(ownerId==userId && (isSimulated || salesOrder.Order_Status__c== "Draft")){
                        component.set("v.showDelete",true);
                    }

                    // selItem is an Sobject of Type Account
                    // Reconstructing the object from Sales Order fields
                    /*component.set("v.selItem", {'sobjectType': 'Account',
                                                'Id': salesOrder.Sold_to_Party__c, 
                                                'Name': salesOrder.Sold_to_Party__r.Name, 
                                                'Program_Margin_Discount__c': salesOrder.Sold_to_Party__r.Program_Margin_Discount__c,
                                                'SAP_Code__c': salesOrder.Sold_to_Party__r.SAP_Code__c,
                                                'Depot_Code__c': salesOrder.Sold_to_Party__r.Depot_Code__c,
                                                'Tax_Number_1__c': salesOrder.Sold_to_Party__r.Tax_Number_1__c,
                                                'Tax_Number_3__c': salesOrder.Sold_to_Party__r.Tax_Number_3__c,
                                                'Customer_Region__c': salesOrder.Sold_to_Party__r.Customer_Region__c,
                                                'BillingCity': salesOrder.Sold_to_Party__r.BillingCity});*/

                    
                    //console.log('filled selItem: '+JSON.stringify(component.get('v.selItem')));
                    
                   // this.fetchPriceBookDetails(component);
                    
                    //Disable inputs on reload existing SO
                    var status = component.get("v.newSalesOrder.BrazilSalesOrderStatus__c");
                    var subStatus = component.get("v.newSalesOrder.OrderSubStatus__c");
                    
                    //console.log('status: '+status);					                    
                    
                    // Cancel Button Visibility Logic
                    // 1. Logic for SP/CSU
                    if( profileName == 'Brazil Customer Service User'){
                        //if(status=='Pending' || status=='Approved' || status=='Rejected'){
                        if(status==$A.get("$Label.c.Pending") || status==$A.get("$Label.c.Approved") || status==$A.get("$Label.c.Rejected")){
                            component.set("v.showCancel", true);
                            component.set("v.showRemarks", true);
                        }
                        //if(status=="Cancelled"){
                        if(status==$A.get("$Label.c.Cancelled")){
                            component.set("v.showRemarks", true);
                            component.find("remarks").set("v.disabled", true);
                        }
                    }
                    //Logic to show budget value 
                    if(profileName == 'Brazil Sales Director' || profileName == 'Custom System Administrator' || profileName =='Brazil Regional Head' ){
                         component.set("v.showBudgetVal", true);
                    }
                    //end
                    // Logic for SP added by ganesh
                    if(profileName == 'Brazil Sales Person'){
                        if(status==$A.get("$Label.c.Pending") || status==$A.get("$Label.c.Rejected")){
                            component.set("v.showCancel", false);
                        }
                        
                        
                        if(status==$A.get("$Label.c.Approved")){
                            //component.set("v.showCancel", true);
                            //component.set("v.showRemarks", true);
                            
                            component.set("v.showCancel", false);
                            component.set("v.showRemarks", false);
                        }
                        
                        if(status==$A.get("$Label.c.Cancelled")){
                            component.set("v.showRemarks", true);
                            component.find("remarks").set("v.disabled", true);
                        }
                    }
                    // 2. Logic for System Admin
                    // changed by ganesh
                    else if(profileName == 'Brazil System Administrator' || profileName == 'Brazil Customer Service User' || profileName == 'Brazil Customer Service Manager'){
                        //if(status=="Approved" || subStatus=='Approved'){
                        if(status==$A.get("$Label.c.Approved") || subStatus=='Approved' || status==$A.get("$Label.c.Pending") || status==$A.get("$Label.c.Rejected") ){
                            component.set("v.showCancel", true);
                            component.set("v.showRemarks", true);
                        }
                        //if(status=="Cancelled"){
                        if(status==$A.get("$Label.c.Cancelled")){
                            component.set("v.showRemarks", true);
                            component.find("remarks").set("v.disabled", true);
                        }
                    }
                    // 3. Logic for SOM/SDM
                        else if(profileName=='Brazil Sales Office Manager' || profileName=='Brazil Sales District Manager'){
                            var selectedUser = component.get("v.newSalesOrder.KeyAccountDesOwnerBrazil__c");
                            var opts=[];   
                            if(OpenUserTM){ 
                                if(OpenUserTM && (ownerId==userId) ){
                                    console.log('selectedUser-'+selectedUser);
                                    component.set("v.selectedUser", selectedUser+'~~'+OpenUserTM);
                                }
                                else if(OpenUserTM && ownerId!=userId && profileName=='Brazil Sales District Manager'){
                                    opts.push({"class": "optionClass", label: OpenUserTM+'- Open User', value:userId});
                                    component.find("sellerOptions").set("v.options", opts);
                                }
                                    else if(OpenUserTM && ownerId!=userId && profileName=='Brazil Sales Office Manager'){
                                        opts.push({"class": "optionClass", label: OpenUserTM+'- Open User', value:userId});
                                        component.find("sellerOptions").set("v.options", opts);
                                    }
                            }
                            else{
                                console.log('selectedUser--'+selectedUser);
                                component.set("v.selectedUser", selectedUser);
                            }
                        }
                    //End
                    
                    //if(status=="Approved"){
                    if(status==$A.get("$Label.c.Approved")){
                        if(ownerId!=userId){
                            component.set("v.showSimulate", true);
                        }
                        // Logic for SOM/SDM added by ganesh 
                        if(profileName=='Brazil Sales Office Manager' || profileName=='Brazil Sales District Manager' || profileName=='Brazil Sales Director' ){
                            component.set("v.showSimulate", false); 
                        }
                        // Logic end
                        component.set("v.showPrint", true);
                        if(profileName == 'Brazil System Administrator' || profileName == 'System Administrator' || profileName == 'Brazil Customer Service User' || profileName == 'Brazil Customer Service Manager'){
                            component.set("v.showSignUnsign",true);
                            component.set("v.showSimulate", false);
                            
                            var signed = component.get("v.newSalesOrder.Signed__c");
                            
                            if(signed){
                                component.set("v.showSign",false);
                                component.set("v.showUnsign",true);
                                component.set("v.signMessage", $A.get("$Label.c.Are_you_sure_you_want_to_unsign") );
                            }
                            else{
                                component.set("v.showSign",true);
                                component.set("v.showUnsign",false);
                                component.set("v.signMessage", $A.get("$Label.c.Are_you_sure_you_want_to_sign") );
                            }
                        }      
                        component.set("v.showSaveDraft", false); 
                    }
                    
                    //if(status=="Rejected"){
                    if(status==$A.get("$Label.c.Rejected")){
                        component.set("v.showSaveDraft", false); 
                    }
                    
                    //Disable Fields by default on reload
                    component.set("v.disableThis", true);
                    //component.set("v.disableSelect", true);
                    component.set("v.disablePaymentMethod", true);
                    component.set("v.disablePriceCurrency", true);
                    component.set("v.disableOrderType_Dates_SOM_Account", true);
                    component.set("v.disableSearch", true);
                    //End
                    
                    component.set("v.showOnReLoad", true);
                    
                    //if(status=="Pending"){
                    if(status == $A.get("$Label.c.Pending")){
                        if(ownerId!=userId && profileName!='Brazil Barter Manager'){
                            component.set("v.showSimulate", true);
                        }
                        
                        component.set("v.showSaveDraft", false); 
                        component.set("v.showSubmitEdit", false);
                    }
                    //else if(status=="Submitted" || status=="Cancelled"){
                    else if(status == $A.get("$Label.c.Submitted") || status == $A.get("$Label.c.Cancelled")){
                        component.set("v.showSaveDraft", false); 
                        component.set("v.showSubmitEdit", false);
                    }
                    else if(status == $A.get("$Label.c.Rejected") && profileName != 'Brazil Sales Person'){
                        component.set("v.showSaveDraft", false); 
                        component.set("v.showSubmitEdit", false);
                    }   
                    
                     if(status == $A.get("$Label.c.Rejected") && profileName == 'Brazil Sales District Manager'){
                      //  console.log('ownerId'+ownerId+'userId'+userId);
                        if(ownerId==userId){
                            component.set("v.showSubmitEdit", true);
                        }  
                    }
                    
                    var recordType = a.getReturnValue().RecordType.Name;
                    //console.log('recordType: '+recordType);
                    
                    if(recordType=='Simulation'){
                        component.set("v.showSaveDraft", false); 
                        component.set("v.showReset", true);
                        //var sfdcNo = 'Order No:25918  This order is Duplicated from Order No : 25917';
                        var checkParent = salesOrder.Parent_Order_Simulated__c;
                        if(checkParent){
                            var sfdcNo = salesOrder.SalesOrderNumber_Brazil__c+ '. '+$A.get("$Label.c.This_order_is_Duplicated_from_Order_No")+' '+salesOrder.Parent_Order_Simulated__r.SalesOrderNumber_Brazil__c;
                            component.set("v.sfdcOrderNo", sfdcNo);
                        }
                        component.set("v.showSAPNo", false);
                        component.set("v.headerMsg", $A.get("$Label.c.View_Simulation_Order")); 
                        component.set("v.showDelete",true);
                    }
                    component.set("v.showRaiseOrder", false);
                    
                    var approvedFlag = component.get("v.newSalesOrder.BrazilSalesOrderApproved__c"); 
                    if(!approvedFlag){
                        component.set("v.disableEdit", false);
                    }
                    
                    //Simulation Button visibility Logic
                    if(profileName == 'Brazil System Administrator' || 
                       profileName == 'System Administrator' || 
                       profileName == 'Brazil Customer Service User' || 
                       profileName == 'Brazil Customer Service Manager' ||
                       profileName == 'Brazil Barter Manager') {
                        
                        component.set("v.showSimulate", false);
                    }
                    //End
                    //Patch added by ganesh
                    if(subStatus==$A.get("$Label.c.Pending_at_Sales_Office_Manager") || subStatus==$A.get("$Label.c.Pending_for_director_approval")){
                        if(profileName=='Brazil Sales Office Manager' || profileName=='Brazil Sales District Manager'){
                            component.set("v.showSimulate", false);
                            //  console.log('subStatus'+subStatus);
                        }
                        if(subStatus==$A.get("$Label.c.Pending_at_Sales_Office_Manager") && profileName=='Brazil Sales Office Manager'){
                            component.set("v.showSimulate", true);
                        }
                    } 
                    //End Patch
                    this.fetchApprovalHistory(component, soId);
                    this.fetchErrorHistory(component, soId);
                }
                else{
                    var toastMsg = $A.get("$Label.c.Error_while_reloading_SO");
                    this.showErrorToast(component, event, toastMsg);
                }
                
                if(punctualitydisc > 0){
                    component.find("descNo").set("v.value",false);
                    component.find("descYes").set("v.value",true);
                    component.set("v.isPunctual",true);
                    component.set("v.newSalesOrder.Punctuality_Discount__c",punctualitydisc);
                }
                
                // selItem is an Sobject of Type Account
                // Reconstructing the object from Sales Order fields
                component.set("v.selItem", {'sobjectType': 'Account',
                                                'Id': salesOrder.Sold_to_Party__c, 
                                                'Name': salesOrder.Sold_to_Party__r.Name, 
                                                'Program_Margin_Discount__c': salesOrder.Sold_to_Party__r.Program_Margin_Discount__c,
                                                'SAP_Code__c': salesOrder.Sold_to_Party__r.SAP_Code__c,
                                                'Depot_Code__c': salesOrder.Sold_to_Party__r.Depot_Code__c,
                                                'Tax_Number_1__c': salesOrder.Sold_to_Party__r.Tax_Number_1__c,
                                                'Tax_Number_3__c': salesOrder.Sold_to_Party__r.Tax_Number_3__c,
                                                'Customer_Region__c': salesOrder.Sold_to_Party__r.Customer_Region__c,
                                                'BillingCity': salesOrder.Sold_to_Party__r.BillingCity});
           

                if(salesOrder.Use_Campaign__c == true){
                    component.set("v.CampaignCheck",true);
                    component.find("campChk").set("v.value",true);
                    var opts=[];
                    opts.push({"class": "optionClass", label: a.getReturnValue().Price_Book__r.Name, value: a.getReturnValue().Price_Book__c});
                    component.find("Campaign").set("v.options", opts);
                                     
					//alert(salesOrder.Payment_Term__c);
                   if(salesOrder.Payment_Term__c != null){      //  Payment_Term__r.Payterms_Desc__c
                    var opts2=[];
                    opts2.push({"class": "optionClass", label: salesOrder.ReloadPaymentTerms__c, value: salesOrder.Payment_Term__c});
                    component.find("payTmdy").set("v.options", opts2);
                   }
                   else if(salesOrder.Maturity_Date__c != null){
                    component.set("v.isMature", "true");   
                    var opts2=[];
                    opts2.push({"class": "optionClass", label: 'BR71 INFORMAR VENCIMENTO', value: 'BR71 INFORMAR VENCIMENTO'});
                    component.find("payTmDt").set("v.options", opts2);
                   }
                   else{
                    var opts2=[];
                    opts2.push({"class": "optionClass", label: salesOrder.Campaign_Payment_Term_Date__c, value: salesOrder.Campaign_Payment_Term_Date__c});
                    component.find("payTmDt").set("v.options", opts2);
                   }
                    
                  
                    flag=true;
                    if(salesOrder.Campaign_Type__c == 'Simple'){
                        component.set("v.isSimple",true); 
                        component.set("v.isStructure",false);
                        component.find("simpCmp").set("v.value",true);
                    }
                    else if(salesOrder.Campaign_Type__c == 'Structure'){
                        component.set("v.isSimple",false); 
                        component.set("v.isStructure",true);
                        component.find("structCmp").set("v.value",true);
                    }
                    component.find("simpCmp").set("v.disabled",true);
                    component.find("structCmp").set("v.disabled",true);
                }
                else{
                    component.set("v.priceBookId",a.getReturnValue().Price_Book__c);
                    component.set("v.paymentTerm", salesOrder.ReloadPaymentTerms__c);
                }

                var keyAcc=component.get("v.showKeyAccount");
                if(keyAcc){
                    if(salesOrder.Key_Account__c == true){
                        component.find("keyYes").set("v.value",true);
                        component.find("keyNo").set("v.value",false); 
                    }
                    else{
                        component.find("keyYes").set("v.value",false);
                        component.find("keyNo").set("v.value",true); 
                    }
                    component.find("keyYes").set("v.disabled",true);
                    component.find("keyNo").set("v.disabled",true); 
                }

                if(salesOrder.Type_of_Order__c=='VENDA NORMAL'){
                    if(salesOrder.Directed_Sales__c == true){
                        component.find("dirSaleYes").set("v.value",true);
                        component.find("dirSaleNo").set("v.value",false);
                    }
                    else if(salesOrder.Directed_Sales__c == false){
                        component.find("dirSaleNo").set("v.value",true);
                        component.find("dirSaleYes").set("v.value",false);
                    }
                    component.find("dirSaleYes").set("v.disabled",true);
                    component.find("dirSaleNo").set("v.disabled",true);
                }
                
                if(salesOrder.Pronutiva__c == true){
                   // component.find("radio1").set("v.value",'Yes');
                    component.find("radio1").set("v.checked",true);
                    component.find("radio2").set("v.checked",false);
                }
                else if(salesOrder.Pronutiva__c == false){
                    component.find("radio2").set("v.checked",true);
                    component.find("radio1").set("v.checked",false);
                }
                
                component.find("campChk").set("v.disabled",true);
                component.find("orderTypeOptions").set("v.disabled",true);
                component.find("radio1").set("v.disabled",true);
                component.find("radio2").set("v.disabled",true);

                var isPunctual=component.get("v.isPunctual");
                if(isPunctual == true){
                    component.find("punctualitydisc").set("v.disabled",true); 
                }

            component.find("custitem").set("v.disabled",true);  // search icon id...nik
            component.find("itemShip").set("v.disabled",true);  // search icon id...nik
         //   component.find("ExpNumDays").set("v.disabled",true);
            component.find("descYes").set("v.disabled",true);
            component.find("descNo").set("v.disabled",true);

               

            });
            $A.enqueueAction(action);
			 this.reloadSOItems(component);   
                this.reloadSubStatus(component);
                                
             this.fetchPriceBookDetails(component);
        }
    },
    
    // Method call to reload Order Items
    // Gets all Order Line Items against the current Sales Order record
    reloadSubStatus: function(component){
        var action = component.get("c.getOrderSubStatus");
        if(component.get("v.recordId")!=null){
            action.setParams({
                soId: component.get("v.recordId")
            });
            
            action.setCallback(this, function(a) {
                var state = a.getState();
                if(state == "SUCCESS") {
                    component.set("v.orderSubStatus", a.getReturnValue());
                    //console.log('orderItems: '+JSON.stringify(a.getReturnValue()));
                }
                else{
                    //var toastMsg = $A.get("$Label.c.Error_while_reloading_Order_Items");
                    //this.showErrorToast(component, event, toastMsg);                      
                }
            });
            $A.enqueueAction(action);
        }
    },     
    
    // Method call to reload Order Items
    // Gets all Order Line Items against the current Sales Order record
    reloadSOItems: function(component){
        var action = component.get("c.getSalesOrderItems");
        
        if(component.get("v.recordId")!=null){
            action.setParams({
                soId: component.get("v.recordId")
            });
            
            action.setCallback(this, function(a) {
                var state = a.getState();
                if(state == "SUCCESS") {
                    component.set("v.orderItemList", a.getReturnValue());
                    console.log('orderItems List:-----> '+JSON.stringify(a.getReturnValue()));
                }
                else{
                    var toastMsg = $A.get("$Label.c.Error_while_reloading_Order_Items");
                    this.showErrorToast(component, event, toastMsg);                      
                }
            });
            $A.enqueueAction(action);
        }
    }, 
    
    // Show Success Toast (Green)
    // Note: Shows a javascript alert in case the component is loaded within a visualforce page
    showToast : function(component, event, toastMsg) {
        var toastEvent = $A.get("e.force:showToast");
        var success = $A.get("$Label.c.Success");
        // For lightning1 show the toast
        if (toastEvent!=undefined){
            
            //fire the toast event in Salesforce1
            toastEvent.setParams({
                title: success,
                mode: 'dismissible',
                type: 'success',
                message: toastMsg/*,
                messageTemplate: '{0} '+toastMsg+' {1}',
                messageTemplateData: ['Salesforce', {
                url: '/one/one.app?#/sObject/'+recordId+'/view',
                label: ' Click here',}]*/
            });
            toastEvent.fire();
        }
        else{ // otherwise throw an alert
           // alert(success+': ' + toastMsg);
           sforce.one.showToast({
                        "title": "success!",
                        "message":toastMsg,
                         "type": "success"
                    });
        }
    },
    
    //Show Error Message Toast (Red)
    // Note: Shows a javascript alert in case the component is loaded within a visualforce page
    showErrorToast : function(component, event, toastMsg) {
        var toastEvent = $A.get("e.force:showToast");
       // var toastEvent = sforce.one.showToast; 
        var error = $A.get("$Label.c.Error");
        // For lightning1 show the toast
        if (toastEvent!=undefined){
            //fire the toast event in Salesforce1
            toastEvent.setParams({
                title: error,
                mode: 'dismissible',
                type: 'error',
                message: toastMsg
            });
            toastEvent.fire();
        }
        else{ // otherwise throw an alert
            console.log('toastMsg'+toastMsg);
            sforce.one.showToast({
                        "title": "error!",
                        "message":toastMsg,
                         "type": "error"
                    });
          //  alert(error+': ' + toastMsg);
        }
    },
    
    closePopUp: function(component) {
        this.toggle(component);
    },
    
    // Hides all components with in the Modal
    // Used for Account/SOM/Price/Balance
    // Note - Logic behing this method is first we hide all the components and then only unhide the one that is to be visible to the user
    hideAllCmp: function(component){
        var accountdata = component.find("accountdata1");
        $A.util.addClass(accountdata, 'slds-hide');
        
        var somdata = component.find("somdata1");
        $A.util.addClass(somdata, 'slds-hide');
        
        var pricedata = component.find("pricedata1");
        $A.util.addClass(pricedata, 'slds-hide');        
        
        var balancedata = component.find("balancedata1");
        $A.util.addClass(balancedata, 'slds-hide');  
        
		var shippingdata = component.find("shiptopartydata1");
        $A.util.addClass(shippingdata, 'slds-hide');  
    },
    
    // Method to display Approval/Audit History of the current record
    // All entries are Sorted by Created Date
    fetchApprovalHistory : function(component, soId, status) {
        var action = component.get("c.generateData");
        
        action.setParams({
            recordId: soId
        });
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state == "SUCCESS") {
                var returnValue = JSON.stringify(a.getReturnValue());
                component.set("v.approvalList",a.getReturnValue());
                
                var enableApproval = component.get("v.approvalList.enableApproval");
                component.set("v.showApproveReject", enableApproval); 
                
                //console.log('enableApproval: '+enableApproval);
                
                if(enableApproval){
                    var userId = component.get("v.userId");
                    //console.log('logged in user: '+JSON.stringify(userId));
                    
                    var barterManager = component.get("v.newSalesOrder.BarterManager__c");
                    //console.log('barterManager: '+barterManager);
                    
                    if(barterManager==userId){
                        component.set("v.disableBarter",false);
                    }                     
                }
            }	
            
        });
        $A.enqueueAction(action);        
    },  
    
    // Method to query and display all 'Transaction Logs' from HCI/SAP against a particular record
    fetchErrorHistory : function(component, soId) {
        var action = component.get("c.getErrorHistory");
        
        action.setParams({
            recordId: soId
        });
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state == "SUCCESS") {
                component.set("v.errorList",a.getReturnValue());
            }	
        });
        
        $A.enqueueAction(action);        
    },
    
    // Loads language Map used to replace a set of portuguese characters against there English equivalents
    loadPortugueseMap : function(component) {
        var languageMap = component.get("v.languageMap");
        
        languageMap.portuguese_map={
            "Á":"A", "á":"a", "Â":"A", "â":"a", "À":"A", "à":"a", "Å":"A", "å":"a", "Ã":"A", "ã":"a",
            "Ä":"A", "ä":"a", "Æ":" ", "æ":" ", "É":"E", "é":"e", "Ê":"E", "ê":"e", "È":"E", "è":"e",
            "Ë":"E", "ë":"e", "Ð":" ", "ð":" ", "Í":"I", "í":"i", "Î":"I", "î":"i", "Ì":"I", "ì":"i",
            "Ï":"I", "ï":"i", "Ó":"O", "ó":"o", "Ô":"O", "ô":"o", "Ò":"O", "ò":"o", "Ø":" ", "ø":" ",
            "Õ":"O", "õ":"o", "Ö":"O", "ö":"o", "Ú":"U", "ú":"u", "Û":"U", "û":"u", "Ù":"U", "ù":"u",
            "Ü":"U", "ü":"u", "Ç":"C", "ç":"c", "Ñ":"N", "ñ":"n", "Ý":"Y", "ý":"y", "\"":" ", "<":" ",
            ">":" ", "&":" ", "®":" ", "©":" ", "Þ":" ", "þ":" ", "ß":" ", "=":" "
        };        
        component.set("v.languageMap",languageMap);
    },
    
    // Get Business Rule of the seller
    // If Business Rule for a particular seller does not exist, assign default business rule for 'Sales Person'
    fetchBusinessRule : function(component, userId) {
        var action = component.get("c.getBusinessRule");
        var soId = component.get("v.recordId");     
        
        action.setParams({
            soId: soId,
            loggedInUser: userId
        });  
        
        // show spinner to true on click of a button / onload
        component.set("v.showSpinner", true);
        
        action.setCallback(this, function(a) {
            // on call back make it false ,spinner stops after data is retrieved
            component.set("v.showSpinner", false); 
            
            var state = a.getState();
            if (state == "SUCCESS") {
                var returnValue = a.getReturnValue();
                //console.log('returnValue: '+JSON.stringify(returnValue));
                if(soId==null){
                    try{
                        //component.set("v.newSalesOrder.Business_Rule__c", returnValue.Associate_Group__r.Business_Rule__c);            
                        component.set("v.businessRule.Taxes__c", returnValue.Associate_Group__r.Business_Rule__r.Taxes__c);
                        component.set("v.businessRule.Freight__c", returnValue.Associate_Group__r.Business_Rule__r.Freight__c);
                    }
                    catch(err){
                        var orderFields = component.get("v.orderFields");
                        
                        var defaultRule = orderFields.defaultRule;
                        //console.log('defaultRule: '+JSON.stringify(defaultRule));
                        
                        //component.set("v.newSalesOrder.Business_Rule__c", defaultRule.Id);            
                        component.set("v.businessRule.Taxes__c", defaultRule.Taxes__c);
                        component.set("v.businessRule.Freight__c", defaultRule.Freight__c);
                        
                        console.log('Business Rule not found: '+err);
                        //var toastMsg = $A.get("$Label.c.Business_Rule_not_found");
                        //this.showErrorToast(component, event, toastMsg);
                    }
                }
            }    
        });
        $A.enqueueAction(action);
    }, 
    
    // Method to get Seller Values in to Picklist. 
    // Queries all the Sellers of a particular district as applicable to the current logged in user
    fetchSeller : function(component) {
        var action = component.get("c.getSeller");
        var opts=[];   
        opts.push({"class": "optionClass", label: $A.get("$Label.c.None"), value: 'None'});
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state == "SUCCESS") {
                var sellerList = a.getReturnValue(); 
                //console.log('sellerList');
                
                for(var i=0; i < sellerList.length; i++){
                    var str = sellerList[i];
                    var splitValues = str.split("*");
                    opts.push({"class": "optionClass", label: splitValues[0], value: splitValues[1]});
                }
                component.set("v.showSeller", true);
                component.find("sellerOptions").set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
    },
    
    getOrderFields : function(component, event) {
        // show spinner to true on click of a button / onload
		//alert('helper');
        component.set("v.showSpinner", true);        
        var action = component.get("c.getOrderFields");        
        var opts=[];           
        //action.setStorable();        
        action.setCallback(this, function(a) {
            
            // on call back make it false ,spinner stops after data is retrieved
            component.set("v.showSpinner", false); 
            
            var state = a.getState();
            
            if (state == "SUCCESS") {
                var returnValue = a.getReturnValue();
                component.set("v.orderFields",returnValue);
                // console.log('returnValue: '+JSON.stringify(returnValue.hasDefaultRules));
                
                if(returnValue.hasDefaultRules){
                    var orderTypeList = returnValue.orderTypeList;
                    var paymentMethodList = returnValue.paymentMethodList;
                    var currencyList = returnValue.currencyList;
                    var incoTermsList = returnValue.incoTermsList;
                    var culturalDescList = returnValue.culturalDescList;
                    
                    component.set("v.user",returnValue.userObj);
                    component.set("v.userId",returnValue.userObj.Id);
                    component.set("v.orderTypeList",orderTypeList);
                    
                    var profileName = component.get("v.user.Profile.Name");
                    
                    if(returnValue.userObj.Show_List_Value__c == true){
                        component.set("v.showListVal",true);
                    }
                    
                    var isSimulated = component.get("v.isSimulated");
                    var recordId = component.get("v.recordId");
                    //Show Seller to SDM or if 'Simulated Order'
                    //Hide Draft Button for SDM or if 'Simulated Order'
                    
                    if((!recordId) && (profileName=='Brazil Sales Office Manager' || profileName=='Brazil Sales District Manager' || isSimulated)){
                        //Comment above condition & uncomment below condition if SDM & SOM require Save as Draft feature
                        //if((recordId==null || recordId==undefined || recordId=='') && (isSimulated)){
                        component.set("v.showSaveDraft", false); 
                        component.set("v.showSeller",true);
                        this.fetchSeller(component);
                    }    
                    if(profileName=='Brazil Sales Office Manager' || profileName=='Brazil Sales District Manager'){
                        component.set("v.showSeller",true);
                        this.fetchSeller(component);
                    }
                    //Order Type
                    opts.push({"class": "optionClass", label: $A.get("$Label.c.None"), value: 'None'});
                    for(var i=0; i< orderTypeList.length; i++){
                        //If New Simulation and Order Type=='Child' do not add order type in picklist
                        if(isSimulated && orderTypeList[i].search('ORDEM FILHA')==-1){
                            opts.push({"class": "optionClass", label: orderTypeList[i], value: orderTypeList[i]});
                        }
                        //If not simulated record add all order types in picklist
                        else if(!isSimulated){
                            opts.push({"class": "optionClass", label: orderTypeList[i], value: orderTypeList[i]});
                        }
                    }
                    component.find("orderTypeOptions").set("v.options", opts);                
                    //End
                    
                    //Payment Method
                    opts=[];
                    opts.push({"class": "optionClass", label: $A.get("$Label.c.None"), value: 'None'});
                    for(var i=0; i < paymentMethodList.length; i++){
                        var str = paymentMethodList[i];
                        var splitValues = str.split("*");
                        opts.push({"class": "optionClass", label: splitValues[0], value: splitValues[1]});
                    }
                    var paymentopts=component.find("paymentMethodOptions");
                    console.log();
                    if(paymentopts){
                        paymentopts.set("v.options", opts);
                    }
                    
                    //console.log("opts: "+JSON.stringify(opts));
                    //End
                    
                    //Currency
                    opts=[];
                    opts.push({"class": "optionClass", label: $A.get("$Label.c.None"), value: 'None'});
                    for(var i=0; i< currencyList.length; i++){
                        var str = currencyList[i];
                        var splitValues = str.split("*");
                        opts.push({"class": "optionClass", label: splitValues[0], value: splitValues[1]});
                        //opts.push({"class": "optionClass", label: currencyList[i], value: currencyList[i]});
                    }
                    //console.log('currencyList: '+JSON.stringify(currencyList));
                    component.find("currencyOptions").set("v.options", opts);               
                    //End
                    
                    //Inco Terms
                    component.set("v.incoTermList",incoTermsList);
                    opts=[];
                    for(var i=0; i< incoTermsList.length; i++){
                        var str = incoTermsList[i];
                        var splitValues = str.split("*");
                        opts.push({"class": "optionClass", label: splitValues[0], value: splitValues});
                    }
                    var incopts =component.find("incoTermOptions");
                    if(incopts){
                    incopts.set("v.options", opts);                
                    }
                    //End 
                    //Cultural Description
                    opts=[]; 
                    component.set("v.cultureDescList", culturalDescList);
                    component.set("v.cultureDescListCopy", culturalDescList);             
                    //End   
                    
                    //Show Key Account Radio Buttons
                    component.set("v.showKeyAccount", returnValue.isKeyAccountManager);
                    if(returnValue.isKeyAccountManager){
                        //this.fetchSeller(component);
                    }
                    //End
                    
                    //Payment Terms Map
                    opts=[];
                    opts.push({"class": "optionClass", label: $A.get("$Label.c.None"), value: 'None'});  
                    //console.log('Payment Terms:'+JSON.stringify(returnValue.paymentTermsMap));
                    var paymentTermsMap = returnValue.paymentTermsMap;
                    //var ptMap = new Map();
                    
                    for (var key in paymentTermsMap){
                        opts.push({"class": "optionClass", label: key, value: key});
                        //ptMap.set(key, paymentTermsMap[key]);
                    }     
                    console.log('Payment Terms:'+JSON.stringify(opts));
                    component.set("v.paymentTermsMap", paymentTermsMap);
                   component.find("paymentTermOptions").set("v.options", opts);
                    //alert(component.find("radio1").get("v.value"));
                    //alert();
                    
                    //End   
                    
                    /*
                     * Logic Moved from doInit to here.
                     * To restrict orders if Default Business Rule not Found
                     */
                    // Initialize Valid From Date to Today by default.
                    var today = new Date();
                    
                    var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
                    var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
                    var yyyy = today.getFullYear();//today.getFullYear();
                    
                    // Custom date format for ui:inputDate
                    var validFromDate = (yyyy + "-" + MM + "-" + dd);
                    
                    component.set("v.newSalesOrder.Valid_From__c", validFromDate);
                    
                    //component.set("v.newSalesOrder.Purchase_Order_Date__c", validFromDate);
                    //component.set("v.newSalesOrder.Maturity_Date__c", validFromDate);  
                    
                    //Get ValidTo date from helper method        
                    this.getCurrentFiscalYear(component);          
                    
                    //Populate PortugueseMap on component load
                    this.loadPortugueseMap(component);
                    
                    //Reload existing Order if recordId present
                    this.reloadSO(component,event);
                    
                    //Get List of Holidays from helper method
                    //helper.fetchHolidays(component);
                    
                    /*
                     * End of Logic
                     */                    
                }
                else{
                    var toastMsgs = $A.get("$Label.c.Default_Business_Rules_Not_Found");
                    this.showErrorToast(component, event, toastMsgs);
                }
            }
        });
        $A.enqueueAction(action);
    },    
    getpaymentTerm:function(component, event, helper,campaignId){
        
    },
    
    // Method is used to set Valid To date to the 31st of Current Fiscal year.
    // Ex 1: Date - 16/02/2018 
    // Current Fiscal Year would be - 31/03/2018
    // Ex 2: Date - 20/11/2018
    // Current Fiscal Year would be - 31/03/2019
    getCurrentFiscalYear : function(component) {
        //get current date
        var today = new Date();
        
        //get current month
        var curMonth = today.getMonth();
        
        var fiscalYr = "";
        //patch by ganesh
        if (curMonth > 2) { 
            //var nextYr1 = (today.getFullYear() + 1).toString();
            //fiscalYr = today.getFullYear().toString() + "-" + nextYr1.charAt(2) + nextYr1.charAt(3);
            fiscalYr = (today.getFullYear()+1).toString();
        } else {
            //var nextYr2 = today.getFullYear().toString();
            //fiscalYr = (today.getFullYear() - 1).toString() + "-" + nextYr2.charAt(2) + nextYr2.charAt(3);
            fiscalYr = (today.getFullYear()).toString();
        }
        //patch end
        // Custom date format for ui:inputDate
        var validToDate = (fiscalYr + "-" + "03" + "-" + "31");
        component.set("v.newSalesOrder.Valid_To__c", validToDate);
    },
    
    // Validate Order Items
    // 1. Validates an array or just a single object for required values and sets a boolean to 'false' if even one validation fails
 validateOrder: function(component){
        
        var flag = true;
        var payFlag= false;
        var payFlag2=false;
        var toastMsg = '';
        var isCampgn = component.get("v.CampaignCheck");

    if(!isCampgn){
        var validFrom = component.find("validFrom");
        //console.log('validFrom: '+validFrom);
        
        if(validFrom){
            if(!validFrom.get("v.value")) {
                flag = false;
                component.find("validFrom").set("v.errors",[{message: $A.get("$Label.c.Valid_from_is_required")}]);                    
                $A.util.addClass(validFrom, "error");
            }
            //else{
            //    component.find("validFrom").set("v.errors",null);
            //    $A.util.removeClass(validFrom, "error");
            //}
        }
        var validToDate = component.find("validToDate");
        //console.log('validToDate: '+validToDate);
        
        if(validToDate){
            if(!validToDate.get("v.value")) {
                flag = false;
                component.find("validToDate").set("v.errors",[{message: $A.get("$Label.c.Valid_to_date_is_required")}]);                    
                $A.util.addClass(validToDate, "error");
            }
            //else{
            //    component.find("validToDate").set("v.errors",null);
            //    $A.util.removeClass(validToDate, "error");
            //}
        }

        var paymentTermOptions = component.find("paymentTermOptions");
        //console.log('paymentTermOptions: '+paymentTermOptions);
        if(paymentTermOptions){
            if(!paymentTermOptions.get("v.value") || paymentTermOptions.get("v.value") == 'None'){
                flag = false;
                component.find("paymentTermOptions").set("v.errors",[{message: $A.get("$Label.c.Payment_Terms_is_required")}]);                    
                $A.util.addClass(paymentTermOptions, "error");
            }
            //else{
            //    component.find("paymentTermOptions").set("v.errors",null);
            //    $A.util.removeClass(paymentTermOptions, "error");
            //}
        }   

        var priceListOptions = component.find("priceListOptions").get("v.value");
        //Check Price List Value (Mandatory)
        if(!priceListOptions || priceListOptions=='None'){
            flag = false;
            
            var inputCmp = component.find("priceListOptions");
            inputCmp.set("v.errors", [{message: $A.get("$Label.c.Price_List_is_required")}]);
            $A.util.addClass(inputCmp, "error");            
        } 
        //else{
        //    component.find("priceListOptions").set("v.errors",null); 
        //    $A.util.removeClass(component.find("priceListOptions"), "error");
        //}
    }
    else{
        var paymentTermOptionsDy = component.find("payTmdy");
        var paymentTermOptionsDt = component.find("payTmDt");
        //console.log('paymentTermOptions: '+payTmDt);
        
        if(paymentTermOptionsDt){
            if(!paymentTermOptionsDt.get("v.value") || paymentTermOptionsDt.get("v.value") == 'None'){
                payFlag=true;
                
              //  component.find("payTmDt").set("v.errors",[{message: $A.get("$Label.c.Payment_Terms_is_required")}]);                    
              //  $A.util.addClass(paymentTermOptionsDt, "error");
            }
            else{
                payFlag=false; 
            }
           
        }

        
            if(paymentTermOptionsDy){
                if(!paymentTermOptionsDy.get("v.value") || paymentTermOptionsDy.get("v.value") == 'None'){
                   
                    payFlag2=true; // nik...
                  //  component.find("payTmdy").set("v.errors",[{message: $A.get("$Label.c.Payment_Terms_is_required")}]);                    
                  //  $A.util.addClass(paymentTermOptionsDy, "error"); 
                }
                else{
                    payFlag2=false; 
                }
                
            }
        
        

        if(payFlag && payFlag2){
            flag = false;
            component.find("payTmdy").set("v.errors",[{message: $A.get("$Label.c.Payment_Terms_is_required")}]);                    
            $A.util.addClass(paymentTermOptionsDy, "error");
        }
        else{
            paymentTermOptionsDy.set("v.errors", null);
            $A.util.removeClass(paymentTermOptionsDy, "error");
        }

        var priceListOptions2 = component.find("Campaign").get("v.value");
        //Check Price List Value (Mandatory)
        var inputCmp = component.find("Campaign");
        if(!priceListOptions2 || priceListOptions2=='None'){
            flag = false;
            
            inputCmp.set("v.errors", [{message: $A.get("$Label.c.Price_List_is_required")}]);
            $A.util.addClass(inputCmp, "error");            
        }
        else{
            inputCmp.set("v.errors", null);
            $A.util.removeClass(inputCmp, "error"); 
       }
    }


        var maturityDate = component.find("maturityDate");
        //console.log('maturityDate: '+maturityDate);
        
        if(maturityDate) {
            if(!maturityDate.get("v.value")){
                flag = false;
                component.find("maturityDate").set("v.errors",[{message: $A.get("$Label.c.Maturity_date_is_required")}]);                    
                $A.util.addClass(maturityDate, "error");
            }
            //else{
            //    component.find("maturityDate").set("v.errors",null);
            //    $A.util.removeClass(maturityDate, "error");
            //}   
        }
        
        var shipToParty = component.find("itemShipToParty");
        if(shipToParty){
            if(!shipToParty.get("v.value") || shipToParty.get("v.value") == 'None'){
                flag = false;
                component.find("itemShipToParty").set("v.errors",[{message: $A.get("$Label.c.Ship_To_Party_is_required")}]); 
                $A.util.addClass(shipToParty, "error");
            }
            
        }
        
            
        var orderTypeOptions = component.find("orderTypeOptions");
        if(orderTypeOptions){
            if(!orderTypeOptions.get("v.value") || orderTypeOptions.get("v.value") == 'None'){
                flag = false;
                component.find("orderTypeOptions").set("v.errors",[{message: $A.get("$Label.c.Order_type_is_required")}]); 
                $A.util.addClass(orderTypeOptions, "error");
            }
            //else{
            //    component.find("orderTypeOptions").set("v.errors",null);
            //    $A.util.removeClass(orderTypeOptions, "error");
            //}
        }
        
        var currencyOptions = component.find("currencyOptions");
        if(currencyOptions){
            if(!currencyOptions.get("v.value") || currencyOptions.get("v.value") == 'None'){
                flag = false;
                component.find("currencyOptions").set("v.errors",[{message: $A.get("$Label.c.Currency_not_selected")}]); 
                $A.util.addClass(currencyOptions, "error");
            }
            else{
                component.find("currencyOptions").set("v.errors",null);
                $A.util.removeClass(currencyOptions, "error");
            }
        }
        
        var showSeller = component.get('v.showSeller');
        if(showSeller){
            var sellerOptions = component.find("sellerOptions");
            if(sellerOptions){
                if(!sellerOptions.get("v.value") || sellerOptions.get("v.value") == 'None'){
                    flag = false;
                    component.find("sellerOptions").set("v.errors",[{message: $A.get("$Label.c.Seller_is_required")}]); 
                    $A.util.addClass(sellerOptions, "error");
                }
                //else{
                //    component.find("sellerOptions").set("v.errors",null);
                //    $A.util.removeClass(sellerOptions, "error");
                //}
            }
        }
        
        var soName = component.find("soName");
        //console.log('soName: '+soName);
        
        if(soName) {
            if(!soName.get("v.value")) {
                flag = false;
                component.find("soName").set("v.errors",[{message:"Mother Order is required"}]);
                $A.util.addClass(soName, "error");          
            }
            else{
                component.find("soName").set("v.errors",null);
            }        
        }
        
        var customerName = component.find("customerName");
        //console.log('customerName: '+customerName);
        if(customerName!=undefined){
            if(!customerName.get("v.value")){
                flag = false;
                component.find("customerName").set("v.errors",[{message: $A.get("$Label.c.Customer_is_required")}]);
                $A.util.addClass(customerName, "error");
                //toastMsg = 'Select Customer before proceeding.';
                //this.showErrorToast(component, event, toastMsg);              
            }
            //else{
            //    component.find("customerName").set("v.errors",null);
            //    $A.util.removeClass(customerName, "error");
            //}
        }
        //console.log('this is disable>>--->'+component.get("v.disableThis"));
        var poNum = component.find("poNo");
        console.log('poNo: '+poNum);
        if(poNum) {
            if(!poNum.get("v.value")) {
                flag = false;
                component.find("poNo").set("v.errors",[{message: $A.get("$Label.c.Purchase_Order_No_is_required")}]);                    
                $A.util.addClass(poNum, "error");
            }
            //else{
            //    component.find("poNo").set("v.errors",null);
            //    $A.util.removeClass(poNo, "error");
            //}
        }
        
        var poDate = component.find("poDate");
        //console.log('poDate: '+poDate);
        if(poDate) {
            if(!poDate.get("v.value")) {
                flag = false;
                component.find("poDate").set("v.errors",[{message: $A.get("$Label.c.Purchase_Order_date_is_required")}]);                    
                $A.util.addClass(poDate, "error");
            }
            //else{
            //    component.find("poDate").set("v.errors",null);
            //    $A.util.removeClass(poDate, "error");
            //}
        }    
       
        
       
        
        var isPunctual = component.get("v.isPunctual");
        //console.log('isPunctual: '+isPunctual);
        if(isPunctual){
            var punctualitydisc = component.find("punctualitydisc");
            //console.log('punctualitydisc: '+punctualitydisc);
            if(punctualitydisc) {
                if(!punctualitydisc.get("v.value")) {
                    flag = false;
                    component.find("punctualitydisc").set("v.errors",[{message: $A.get("$Label.c.Punctuality_discount_is_required")}]);    
                    $A.util.addClass(punctualitydisc, "error");
                }
                //else{
                //    component.find("punctualitydisc").set("v.errors",null);  
                //    $A.util.removeClass(punctualitydisc, "error");
                //}
            }
        }
        
        return flag;
    }, 
    
    //Validate Order Items
    validateOrderItems: function(component){
        try{
            //FAT Validation Patch
            var today = new Date();
            var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
            var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
            var yyyy = today.getFullYear();
            
            // Custom date format for ui:inputDate
            var currentDate = (yyyy + "-" + MM + "-" + dd);
            //End
            
            var orderItemList = component.get("v.orderItemList");
            var getProductId = component.find("itemproduct");
            var getFATId = component.find("itemfat");
            var getUnitValueId = component.find("itemunitvalue");
            var getQtyId = component.find("itemqty");
            var getCultureId = component.find("cultureDescOptions");
            
            var toastMsg = '';
            var flag = true;

            if(orderItemList.length <= 0){
                flag = false;
                //toastMsg = 'Please add items before saving Order';
                //this.showErrorToast(component, event, toastMsg);              
            }
            else if(orderItemList.length > 0){
                var isProductArray = Array.isArray(getProductId);
                
                if(isProductArray){
                    for(var i = 0; i <orderItemList.length; i++){
                        //Product validaiton
                        if(!getProductId[i].get("v.value")) {
                            component.find("itemproduct")[i].set("v.errors",[{message: $A.get("$Label.c.Product_is_required")}]);               
                            flag = false;
                        }
                        else{
                            component.find("itemproduct")[i].set("v.errors",null);           
                        }
                        
                        // FAT Date validaiton
                        if(!getFATId[i].get("v.value")) {
                            component.find("itemfat")[i].set("v.errors",[{message: $A.get("$Label.c.FAT_is_required")}]);
                            flag = false;
                        }
                        else{
                            //component.find("itemfat")[i].set("v.errors",null);
                            var selectedDate = getFATId[i].get("v.value");
                            
                            var x = new Date(selectedDate);
                            var y = new Date(currentDate);
                            
                            if(selectedDate=='Invalid Date'){
                                var dateString = selectedDate;
                                var dateParts = dateString.split("/");
                                selectedDate = new Date(dateParts[2], dateParts[1] - 1, dateParts[0]);
                                x = new Date(selectedDate);
                            }          
                            if (+x <= +y) {
                                component.find("itemfat")[i].set("v.errors", [{message: $A.get("$Label.c.FAT_should_be_greater_than_today")}]);
                                flag = false;
                            }
                            else{
                                component.find("itemfat")[i].set("v.errors",null);  
                            }
                        }
                        
                        if(getUnitValueId){
                            // Unit Value validaiton
                            if(!getUnitValueId[i].get("v.value") || getUnitValueId[i].get("v.value") == '0') {
                                component.find("itemunitvalue")[i].set("v.errors",[{message: $A.get("$Label.c.Unit_Value_is_required")}]);
                                flag = false;
                            }
                            else{
                                component.find("itemunitvalue")[i].set("v.errors",null); 
                            }
                        }
                        
                        // Quantity validaiton
                        if(!getQtyId[i].get("v.value") || getQtyId[i].get("v.value") == '0') {
                            component.find("itemqty")[i].set("v.errors",[{message: $A.get("$Label.c.Quantity_is_required")}]);;
                            flag = false;
                        }
                        else{
                            component.find("itemqty")[i].set("v.errors",null); 
                        }
                        
                        // Culture Description validaiton
                        if(!getCultureId[i].get("v.value") || getCultureId[i].get("v.value") == 'None'){
                            component.find("cultureDescOptions")[i].set("v.errors",[{message: $A.get("$Label.c.Culture_is_required")}]);
                            flag = false;
                        }
                        else{
                            component.find("cultureDescOptions")[i].set("v.errors",null); 
                        }
                    }    
                }
                else{
                    if(!getProductId.get("v.value")) {
                        flag = false;
                        component.find("itemproduct").set("v.errors",[{message: $A.get("$Label.c.Product_is_required")}]);                
                    }
                    else{
                        component.find("itemproduct").set("v.errors",null);
                    }  
                    
                    if(!getFATId.get("v.value")) {
                        flag = false;
                        component.find("itemfat").set("v.errors",[{message: $A.get("$Label.c.FAT_is_required")}]);                
                    }
                    else{
                        //component.find("itemfat").set("v.errors",null);
                        var selectedDate = getFATId.get("v.value");
                        
                        var x = new Date(selectedDate);
                        var y = new Date(currentDate);
                        
                        if(x=='Invalid Date'){
                            var dateString = selectedDate;
                            var dateParts = dateString.split("/");
                            selectedDate = new Date(dateParts[2], dateParts[1] - 1, dateParts[0]);
                            x = new Date(selectedDate);
                        }
                        //console.log('selectedDate: '+x);
                        //console.log('currentDate: '+y);
                        if (+x <= +y) {
                            component.find("itemfat").set("v.errors", [{message: $A.get("$Label.c.FAT_should_be_greater_than_today")}]);
                            flag = false;
                        }
                        else{
                            component.find("itemfat").set("v.errors",null);  
                        }
                    }  
                    
                    if(!getQtyId.get("v.value") || getQtyId.get("v.value") == '0') {
                        flag = false;
                        component.find("itemqty").set("v.errors",[{message: $A.get("$Label.c.Quantity_is_required")}]);  
                    }
                    else{
                        component.find("itemqty").set("v.errors",null);
                    }
                    
                    if(getUnitValueId){
                        if(!getUnitValueId.get("v.value") || getUnitValueId.get("v.value") == '0') {
                            flag = false;
                            component.find("itemunitvalue").set("v.errors",[{message: $A.get("$Label.c.Unit_Value_is_required")}]);    
                        }
                        else{
                            component.find("itemunitvalue").set("v.errors",null);
                        }
                    }
                    
                    if(!getCultureId.get("v.value") || getCultureId.get("v.value") == 'None'){
                        flag = false;
                        component.find("cultureDescOptions").set("v.errors",[{message: $A.get("$Label.c.Culture_is_required")}]);                
                    }
                    else{
                        component.find("cultureDescOptions").set("v.errors",null);
                    }      
                }
            }
            return flag;
        }
        catch(err){
            console.log('error: '+err);
        }
    },
    
    // Method to Validate all Line Items for Balance Qty on Server
    validateSOCServer : function(component, event, status, isRollback){
        var orderType = component.get("v.newSalesOrder.Type_of_Order__c");
       // console.log('validateSOCServer'+orderType);
     //  alert(JSON.stringify(component.get("v.newSalesOrder")));
        if(orderType=="ORDEM FILHA" && isRollback) {
            //console.log('validateSOCServer Called');
            
            var orderItemList = component.get("v.orderItemList");
            
            var priceBookId = component.get("v.newSalesOrder.Price_Book__c");
            var motherOrderId = component.get("v.newSalesOrder.Sales_Order__c");     
            var depotCode = component.get("v.selItem.Depot_Code__c");
            var accountState = component.get("v.selItem.Customer_Region__c");
            var orderId = component.get("v.recordId");
            
            var action = component.get("c.validateQuantitySOC");
            
            action.setParams({ 
                "priceBookId": priceBookId,
                "motherOrderId": motherOrderId,
                "depotCode": depotCode,
                "accountState": accountState,
                "orderId" : orderId,
                "salesOrderItemString" : JSON.stringify(orderItemList)
            });
            
            // Create a callback that is executed after 
            // the server-side action returns
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                console.log('validateSOCServer state: '+state);
                
                if (state === "SUCCESS") {
                    console.log("From server: " + response.getReturnValue());
                    
                    var result = response.getReturnValue();
                    
                    if(!result){
                        console.log('here');
                        //this.validateSOCBeforeSave(component);
                        component.set("v.isValidSOC", true);
                        this.createSalesOrder(component, event, status, isRollback);
                    }
                    else{
                        //console.log("priceList: "+JSON.stringify(result.priceList));
                        var toastMsg = 'Quantity exceeded since SOM balance was updated on server for Product/s: '+ result.productList +'. Please change the quantity as per updated balance.';
                        this.showErrorToast(component, event, toastMsg);
                        this.fetchServerPriceBookDetails(component, result.priceList);
                    }
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            
            // optionally set storable, abortable, background flag here
            
            $A.enqueueAction(action);
        }
        else{

            console.log('Call Create salesOrder in validatesoc');
            this.createSalesOrder(component, event, status, isRollback);
        }
    },
    
    // Method to Validate all Line Items for Balance Qty
    // Used in scenario where SOM is saved as 'Draft' and reloaded after a while and 'Submitted'
    // If entered 'Qty' is more than 'Balance Qty' during 'Resave' or 'Submit' the Validation will fire
    validateSOCBeforeSave : function(component){
        
        var priceDetailList = component.get("v.priceDetailList");
        var priceMap = new Map();
        for (var idx = 0; idx < priceDetailList.length; idx++) {
            priceMap.set(priceDetailList[idx].itemNo, priceDetailList[idx]);
            //console.log(' priceDetailList[idx]'+ JSON.stringify(priceDetailList[idx]));
        }
        //component.set("v.priceMap", priceMap);
        
        var orderItemList = component.get("v.orderItemList");
       // console.log('orderItemList: '+JSON.stringify(orderItemList));
        
        var getQtyId = component.find("itemqty");
        //console.log('getQtyId'+getQtyId);
        
        var isProductArray = Array.isArray(getQtyId);
        var flag = true;
        for (var idx = 0; idx < orderItemList.length; idx++) {
            if(priceMap.has(orderItemList[idx].moItemNo)){
                var priceObj = priceMap.get(orderItemList[idx].moItemNo);
                if(isProductArray){
                    console.log('priceObj.balanceQty: '+priceObj.balanceQty);
                    console.log('priceObj.balanceQty2: '+priceObj.balanceQty2);
                    console.log('getQtyId[idx].get("v.value"): '+getQtyId[idx].get("v.value"));
                    
                    // Quantity validaiton
                    if(getQtyId[idx].get("v.value") > priceObj.balanceQty2){
                        component.find("itemqty")[idx].set("v.errors",[{message: $A.get("$Label.c.Qty_cannot_be_greater_than_SOM_Balance")+" "+priceObj.balanceQty2}]);
                        flag = false;
                    }
                    else{
                        component.find("itemqty")[idx].set("v.errors",null); 
                    }
                }
                else{
                    console.log('priceObj.balanceQty : '+priceObj.balanceQty);
                    console.log('priceObj.balanceQty2: '+priceObj.balanceQty2);
                    console.log('getQtyId.get("v.value"): '+getQtyId.get("v.value"));
                    
                    if(getQtyId.get("v.value") > priceObj.balanceQty2){
                        flag = false;
                        component.find("itemqty").set("v.errors",[{message: $A.get("$Label.c.Qty_cannot_be_greater_than_SOM_Balance")+" "+priceObj.balanceQty2}]);  
                    }
                    else{
                        component.find("itemqty").set("v.errors",null);
                    }
                }
            }
        }
        component.set("v.isValidSOC", flag);
    },
    
    // Create sales order on Save as Draft button. 
    createSalesOrder : function(component, event, status, isRollback) { 
       // console.log('createSalesOrder');
        
        var orderType = component.get("v.newSalesOrder.Type_of_Order__c");
      //  var exp_no_day= component.find("ExpNumDays").get("v.value");
      //  component.set("v.newSalesOrder.Expected_Number_of_days__c",exp_no_day);  // for expected no of days....Nik

		//alert('orderType before>>--->'+orderType);
        //Not Required - Commented by Bhavik 21/07/2018
        /*if(orderType=="ORDEM FILHA" && isRollback) {
            this.fetchPriceBookDetails(component);
            this.validateSOCBeforeSave(component);
        }*/
        
        var isValid = this.validateOrder(component); 
        var isValidItems = this.validateOrderItems(component);
        var isValidFAT = component.get("v.isValidFAT");
        var isValidSOC = component.get("v.isValidSOC");
        var isValidInvoice = component.get("v.isValidInvoice");
        
        console.log('isValidSOC: '+isValidSOC);
        
        if(isValid && isValidItems && isValidFAT && isValidSOC && isValidInvoice){
            var paymentTerm = component.get("v.paymentTerm");
            var toastMsg = '';
            var newSO = component.get("v.newSalesOrder");
            // alert('Create Order newSO>>--->'+JSON.stringify(newSO));
            var orderItemList = component.get("v.orderItemList");
            console.log('orderItemList'+JSON.stringify(orderItemList));
            
            var action;
            
            var isSimulated = component.get("v.isSimulated");
            //console.log('isSimulated'+isSimulated);
            if(isSimulated){
                //Execute to save simulation without flag dialog
                component.set("v.newSalesOrder.Order_Status__c","Draft");
                
                if(isRollback==true) {
                    //Execute to rollback and check flag status
                    console.log('Simulated=true isrollback=true newSO>>--->'+JSON.stringify(newSO));
                    action = component.get("c.rollbackSalesOrder");
                    action.setParams({ 
                        "soObj": newSO,
                        "salesOrderItemString": JSON.stringify(orderItemList),
                        "isSimulated": true
                    });  
                }
                else if(isRollback==false) {
                    console.log('Simulated=true isrollback=false newSO>>--->'+JSON.stringify(newSO));
                    action = component.get("c.saveSalesOrder");
                    action.setParams({ 
                        "soObj": newSO,
                        "salesOrderItemString": JSON.stringify(orderItemList),
                        "isRollback": false,
                        "isSimulated": true
                    });      
                }
            }
            else if(!isSimulated) {
                if(status=="Submitted") {
                  //  console.log('status'+status);
                    //Execute to save order on Submit button
                    component.set("v.newSalesOrder.Order_Status__c","Submitted");
                      if(isRollback==false){
                        component.set("v.disableSelect", true);
                        console.log("disableSelect");
                    }
                }
                
                else if(status== "Draft") {
                    //Execute to save as draft without flag check/rollback
                    component.set("v.newSalesOrder.Order_Status__c", "Draft");               
                }
                
                if(isRollback==true) {
                    console.log('Order Line Items added by Nik-----> '+ JSON.stringify(orderItemList));
                    console.log('Simulated=false isrollback=true newSO>>--->'+JSON.stringify(newSO));
                    action = component.get("c.rollbackSalesOrder");
                    action.setParams({ 
                        "soObj": newSO,
                        "salesOrderItemString": JSON.stringify(orderItemList),
                        "isSimulated": false
                    });  
                }
                else if(isRollback==false) {
                   
                    console.log('Simulated=false isrollback=false newSO>>--->'+JSON.stringify(newSO));
                    console.log('SalesOrderItems>>---->'+JSON.stringify(orderItemList));
                    action = component.get("c.saveSalesOrder");
                    action.setParams({ 
                        "soObj": newSO,
                        "salesOrderItemString": JSON.stringify(orderItemList),
                        "isRollback": false,
                        "isSimulated": false
                    });   
                }    
            }
            // show spinner to true on click of a button / onload
            component.set("v.showSpinner", true);             
            
            action.setCallback(this, function(a) {
                
                // on call back make it false ,spinner stops after data is retrieved
                component.set("v.showSpinner", false);                
                
                var state = a.getState();
                
                if (state == "SUCCESS") {
                    //toastMsg = "Sales Order created successfully for "+JSON.stringify(a.getReturnValue().Sold_to_Party__r.Name);
                    
                    var recordId = a.getReturnValue().soObj.Id;
                    component.set("v.recordId",recordId);
                    var orderStatus = a.getReturnValue().soObj.Order_Status__c;
                    
                    component.set("v.newSalesOrder",a.getReturnValue().soObj);
                    component.set("v.orderSubStatus",a.getReturnValue().orderSubStatus);
                    console.log('a.getReturnValue().orderSubStatus'+JSON.stringify(a.getReturnValue()));
                    
                    if(isRollback==false){
                        component.set("v.sfdcOrderNo", a.getReturnValue().sfdcOrderNo);
                        //console.log('Rollback False Order No: '+a.getReturnValue().sfdcOrderNo);
                        //console.log('Rollback False Order Id: '+a.getReturnValue().soObj.Id);
                    }
                    console.log('a.getReturnValue().soObj.Flag_Status__c'+a.getReturnValue().soObj.Flag_Status__c);
                    //component.set("v.flag",a.getReturnValue().soObj.Flag_Status__c);
                    var flagImg = '$Resource.'+a.getReturnValue().soObj.Flag_Status__c;
                    var flagIm = a.getReturnValue().soObj.Flag_Status__c;
                    //console.log('flagIm: '+flagIm);

                    component.set("v.flag",$A.get(flagImg));
                    component.set("v.flagMessage",a.getReturnValue().soObj.Flag_Message__c);
                    
                    //component.set("v.selectedCurrency",a.getReturnValue().soObj.Currency_Brazil__c);
                    //component.set("v.priceBookId",a.getReturnValue().soObj.Price_Book__c);
                     console.log('Class value of Order Type>>----->'+a.getReturnValue().soObj.Type_of_Order__c);
                    component.set("v.orderType", a.getReturnValue().soObj.Type_of_Order__c);
                    //alert('Order Type Value>>--->'+component.get("v.orderType"));
                    var errorMessage = a.getReturnValue().soObj.ErrorMessage__c;
                    console.log('error msg:'+errorMessage);
                    
                    var defType = 'pending';
                    
                    if(errorMessage!='') {
                        toastMsg = errorMessage;
                        this.showErrorToast(component, event, toastMsg);
                    }
                    else{
                        //If User is owner of record & Order is a 'Simulation' or 'Draft' Order then enable delete
                        if((isSimulated || a.getReturnValue().soObj.Order_Status__c== "Draft") && isRollback==false) {
                            component.set("v.showDelete",true);
                        }
                        
                        if(isSimulated) {
                            toastMsg = $A.get("$Label.c.Simulation_Saved_Successfully");
                            
                            if(isRollback == false) {
                                //Execute to save order on Submit button
                                this.toggleConfirmDialog(component);                     
                                this.showToast(component, event, toastMsg);
                                
                                //Start
                                component.set("v.showOnReLoad",true);
                                component.set("v.showSAPNo",false);
                                component.set("v.showRaiseOrder",false);
                                
                                var orderItemList = a.getReturnValue().soiList;
                                
                                if(orderItemList) {
                                    component.set("v.orderItemList", orderItemList);
                                }
                                
                                var approvalList = a.getReturnValue().approvalList;
                                
                                if(approvalList) {
                                    component.set("v.approvalList", approvalList);
                                }
                                
                                var errorList = a.getReturnValue().errorList;
                                if(errorList) {
                                    component.set("v.errorList", errorList);
                                }   
                                //End
                                
                                //var fullUrl = '';
                                //fullUrl = '/apex/simulationOrderEnhancedView';
                                //this.gotoURL(fullUrl);
                                //this.navigateToComponent(component);                        
                            }
                            else if(isRollback==true){
                                var orderItemList = a.getReturnValue().soiList;
                                if(orderItemList){
                                    component.set("v.orderItemList", orderItemList);
                                }
                                //Execute to rollback and check flag status on Submit button
                                this.toggleConfirmDialog(component); 
                            }
                        }
                        else{
                            if(status=="Submitted"){
                                toastMsg = $A.get("$Label.c.Sales_Order_Created_Successfully");
                                if(isRollback==false){
                                    //Execute to save order on Submit button
                                    this.toggleConfirmDialog(component);                  
                                    this.showToast(component, event, toastMsg);
                                   
                                    
                                    var profileName = component.get("v.orderFields.userObj.Profile.Name");
                                    var fullUrl = '';
                                    var defType = '';
                                    console.log('flagIm'+flagIm+'profileName'+profileName);
                                    if(profileName=='Brazil Sales Person'){
                                        
                                        if(flagIm =='like'){
                                            defType = 'approved';
                                        }
                                        else if(flagIm =='midlike' || flagIm=='dislike' || flagIm=='dislike_black'){
                                            defType = 'pending';
                                        }
                                        fullUrl = "/apex/BrazilEnhancedListForSP?defType="+defType;
                                        this.gotoURL(component, fullUrl);
                                    }
                                    else if(profileName=='Brazil Sales District Manager'){
                              
                                        if(flagIm=='like'){
                                            defType = 'approved';
                                        }
                                        else if(flagIm=='midlike' || flagIm=='dislike' || flagIm=='dislike_black'){
                                            defType = 'pending';
                                        }
                                        fullUrl = "/apex/BrazilEnhancedListForSDM?defType="+defType;
                                        this.gotoURL(component, fullUrl);
                                    } 
                                    
                                    else if(profileName=='Brazil Sales Office Manager'){
                                            
                                        if(flagIm=='like'){
                                            defType = 'approved';
                                        }
                                        else if(flagIm=='midlike' || flagIm=='dislike' || flagIm=='dislike_black'){
                                            defType = 'pending';
                                        }
                                        fullUrl = "/apex/BrazilEnhancedListForSOM?defType="+defType;
                                        this.gotoURL(component, fullUrl);
                                    } 
                                }
                                else if(isRollback==true){
                                    var orderItemList = a.getReturnValue().soiList;
                                    if(orderItemList!=null && orderItemList!=undefined){
                                        component.set("v.orderItemList", orderItemList);
                                    }
                                    //Execute to rollback and check flag status on Submit button
                                    this.toggleConfirmDialog(component);
                                }
                            }
                            else if(status=='Draft'){
                                toastMsg = $A.get("$Label.c.Sales_Order_Draft_Saved_Successfully");
                                
                                if(isRollback==false){
                                    //Execute to save order on Draft button
                                    this.toggleConfirmDialog(component);    
                                    
                                    //Execute to save as draft without flag check/rollback
                                    this.showToast(component, event, toastMsg);
                                    component.set("v.showOnReLoad",true);
                                    
                                    var orderItemList = a.getReturnValue().soiList;
                                    if(orderItemList!=null && orderItemList!=undefined){
                                        component.set("v.orderItemList", orderItemList);
                                    }
                                    
                                    var approvalList = a.getReturnValue().approvalList;
                                    if(approvalList!=null && approvalList!=undefined){
                                        component.set("v.approvalList", approvalList);
                                    }
                                    
                                    var errorList = a.getReturnValue().errorList;
                                    if(errorList!=null && errorList!=undefined){
                                        component.set("v.errorList", errorList);
                                    }   
                                    
                                    //this.fetchPriceBookDetails(component);
                                    
                                    /*var orderType = a.getReturnValue().soObj.Type_of_Order__c;
                                                
                                                if(orderType=="CONTRATO MÃE"){
                                                    component.set("v.recordId",a.getReturnValue().soObj.Id);
                                                    component.set("v.isMother",true);
                                                }*/
                                    
                                    //this.navigateToComponent(component);
                                }
                                else if(isRollback==true){
                                    var orderItemList = a.getReturnValue().soiList;
                                    if(orderItemList!=null && orderItemList!=undefined){
                                        component.set("v.orderItemList", orderItemList);
                                    }
                                    //Execute to rollback and check flag status on Draft button
                                    this.toggleConfirmDialog(component);
                                }                            
                            }
                        }
                    }
                }
                else{
                    toastMsg = $A.get("$Label.c.Some_error_has_occurred_while_Confirming_Order_Please_try_again");
                    this.showErrorToast(component, event, toastMsg);   
                }
            });
            
            $A.enqueueAction(action);
        }
        else{
            toastMsg = $A.get("$Label.c.Please_provide_valid_input_fill_all_the_mandatory_fields_before_proceeding")
            this.showErrorToast(component, event, toastMsg);
        }
    },
    
    gotoURL : function(component, fullUrl) {
        var device = $A.get("$Browser.formFactor");
        //console.log("You are using a " + device);
        //console.log('fullUrl: '+fullUrl);
        
        if(device=='DESKTOP'){
            
            // (e.force:navigateToURL) only works when component loads as lightning.
            var urlEvent = $A.get("e.force:navigateToURL");
            if(urlEvent) {
                urlEvent.setParams({
                    "url": fullUrl,
                    "isredirect": false
                });
                urlEvent.fire();
            } 
            else{
                //window.location = fullUrl;
                
                // (sforce.one.navigateToURL) works when component loads in visualforce page.
                sforce.one.navigateToURL(fullUrl);
            }
        }
        else{
            //Redirect to Standard ListView when placing orders in SF1.
            this.navigateToComponent(component);
        }
    },
    
    updatePriceTable : function(component, event){
        
        var target = event.getSource();  
        var qty = target.get("v.value");
        var itemNo = target.get("v.requiredIndicatorClass");
        
        var priceDetailList = component.get("v.priceDetailList");
        for (var idx = 0; idx < priceDetailList.length; idx++) {
            if(priceDetailList[idx].itemNo == itemNo){
                var oldValueQty = component.get("v.oldValueQty");
                if(qty > priceDetailList[idx].balanceQty || oldValueQty > qty){
                    priceDetailList[idx].balanceQty = priceDetailList[idx].balanceQty + oldValueQty;
                    priceDetailList[idx].balanceQty = priceDetailList[idx].balanceQty - qty;    
                }
                else{
                    priceDetailList[idx].balanceQty = priceDetailList[idx].balanceQty - qty;
                }
                priceDetailList[idx].percUsed = parseFloat((priceDetailList[idx].balanceQty / priceDetailList[idx].qty) *100).toFixed(2);
                //priceDetailList[idx].percUsed = (priceDetailList[idx].balanceQty / priceDetailList[idx].qty) *100;
                break;
            }
        }
        component.set("v.priceDetailList", priceDetailList);
        
    },
    
    updateRowCalculations : function(component, event){
        //var target = event.getSource();  
        //var rowIndex = target.get("v.labelClass");
        
        //Edit Row function
        var orderItemList = component.get("v.orderItemList");
        var totalValue = 0;
        for (var idx = 0; idx < orderItemList.length; idx++) {
            var flag = true;
            if(!orderItemList[idx].qty) {
                flag = false;
            }
            if(!orderItemList[idx].unitValue) {
                flag = false;
            }
            if(!orderItemList[idx].productId==false){
                if(flag){
                    //Logic to restrict negative value
                    var qty2 = orderItemList[idx].qty.toString(); //Convert to string
                    orderItemList[idx].qty = parseFloat(qty2.replace("-", "")); //Replace negative sign

                    var value2 = orderItemList[idx].unitValue.toString(); //Convert to string
                    orderItemList[idx].unitValue = parseFloat(value2.replace("-", "")); //Replace negative sign
                    //End of logic
                    
                    //console.log('row calc: '+component.get("v.days"));
                    //orderItemList[idx].days = component.get("v.days");
                    
                    orderItemList[idx].timeInMonths = orderItemList[idx].days/30;
                    
                    //console.log('unitValueWithInterest = unitValue * (1+interestRate/100) ^ timeInMonths');
                    //console.log('unitValue: '+orderItemList[idx].unitValue);
                    //console.log('interestRate: '+orderItemList[idx].interestRate);
                    //console.log('days: '+orderItemList[idx].days);
                    //console.log('timeInMonths: '+orderItemList[idx].timeInMonths);
                    
                    if(orderItemList[idx].timeInMonths && orderItemList[idx].interestRate!=0){
                        //orderItemList[idx].unitValueWithInterest = (orderItemList[idx].unitValue + Math.pow(orderItemList[idx].unitValue * (1+orderItemList[idx].interestRate/100),orderItemList[idx].timeInMonths)).toFixed(2);    
                        //orderItemList[idx].unitValueWithInterest = orderItemList[idx].unitValue + Math.pow(orderItemList[idx].unitValue / (1+orderItemList[idx].interestRate/100),orderItemList[idx].timeInMonths);
                        orderItemList[idx].unitValueWithInterest = orderItemList[idx].unitValue / (Math.pow(1+orderItemList[idx].interestRate/100,orderItemList[idx].timeInMonths));
                    }
                    else{
                        orderItemList[idx].unitValueWithInterest = orderItemList[idx].unitValue;
                    }
                    console.log('unitValueWithInterest: '+orderItemList[idx].unitValueWithInterest);
                    //orderItemList[idx].totalValue = (orderItemList[idx].qty * orderItemList[idx].unitValue).toFixed(2);
                    //orderItemList[idx].totalValueWithInterest = (orderItemList[idx].qty * orderItemList[idx].unitValueWithInterest).toFixed(2);
                    
                    orderItemList[idx].totalValue = orderItemList[idx].qty * orderItemList[idx].unitValue;
                    //  commented by ganesh
                    //  orderItemList[idx].totalValueWithInterest = orderItemList[idx].qty * orderItemList[idx].unitValueWithInterest;
                    //comment end
                    
                    orderItemList[idx].totalValueWithInterest = orderItemList[idx].qty * orderItemList[idx].unitValue;
                    
                    console.log('totalValueWithInterest ----Nik--->: '+orderItemList[idx].totalValueWithInterest);
                    
                    //commented by ganesh
                    // totalValue += parseFloat(orderItemList[idx].totalValueWithInterest);
                    //comment end
                    
                    totalValue += parseFloat(orderItemList[idx].totalValue);//change by Ganesh
                    //console.log('totalValue: '+totalValue)
                }
            }
            else{
                //var toastMsg = $A.get("$Label.c.Select_Product_before_Entering_Price_Quantity");
                //this.showErrorToast(component, event, toastMsg);
                
                var getProductId = component.find("itemproduct");
                var isProductArray = Array.isArray(getProductId);
                
                if(isProductArray){
                    //Product validaiton
                    if(getProductId[idx].get("v.value") == null || getProductId[idx].get("v.value") == ''){
                        component.find("itemproduct")[idx].set("v.errors",[{message: $A.get("$Label.c.Product_is_required")}]);               
                        $A.util.addClass(component.find("itemproduct")[idx], "error");
                    }
                }
                else{
                    if(getProductId.get("v.value") == null || getProductId.get("v.value") == ''){
                        component.find("itemproduct").set("v.errors",[{message: $A.get("$Label.c.Product_is_required")}]);                
                        $A.util.addClass(component.find("itemproduct"), "error");
                    }
                }
            }
        }
        component.set("v.orderItemList",orderItemList); 
        component.set("v.totalValue",totalValue);        
    },
    
    fetchAccounts : function(component) {
        var sellerId = component.get("v.newSalesOrder.KeyAccountDesOwnerBrazil__c");
        
        var userId = component.get("v.userId");
        
        //var seUser = component.get("v.selectedUser");
        //console.log('sellerId'+sellerId);
        
        var orderType = component.get("v.newSalesOrder.Type_of_Order__c");
        var customerGroup = component.get("v.selItem3.Sold_to_Party__r.Customer_Group__c");
        var accountId = component.get("v.selItem3.Sold_to_Party__c");
        console.log('accountId--->'+accountId);
        var action; 
        
        var isKeyAccount = component.get("v.newSalesOrder.Key_Account__c");
        var showKeyAccount = component.get("v.showKeyAccount");
        
       
        //console.log("inside fetch method");
        
        //Column data for the table
        var tableColumns = [
            {
                'label': $A.get("$Label.c.Customer_Code"),
                'name':'SAP_Code__c',
                'type':'string',
                'value':'Id',
                /*'width': 100,*/
                'resizeable':true
            },
            {
                'label': $A.get("$Label.c.Name"),
                'name':'Name',
                'type':'string',              
                'resizeable':true
            },
            {
                'label': $A.get("$Label.c.Group"),
                'name':'Customer_Group__c',
                'type':'string',  
                'resizeable':true
            },
            {
                'label': $A.get("$Label.c.City"),
                'name':'BillingCity',
                'type':'string',     
                'resizeable':true
            },
            {
                'label': $A.get("$Label.c.Region"),
                'name':'Customer_Region__c',
                'type':'string',   
                'resizeable':true
            },
            {
                'label': $A.get("$Label.c.Tax_Number_1"),
                'name':'Tax_Number_1__c',
                'type':'string',   
                'resizeable':true
            },
            {
                'label': $A.get("$Label.c.Tax_Number_3"),
                'name':'Tax_Number_3__c',
                'type':'string',   
                'resizeable':true
            }
            
        ];
        
       //Configuration data for the table to enable actions in the table
        var tableConfig = {
            "massSelect":false,
            "globalAction":[],
            "searchByColumn":true,
            "rowAction":[
                {
                    "label": $A.get("$Label.c.Select"),
                    "type":"url",
                    "id":"selectaccount"
                }
            ]
            
        };
        
         if(showKeyAccount && isKeyAccount!=undefined && isKeyAccount!=null){
            var keyUserId;
            
            //Get Logged In User ID
            if(isKeyAccount==false){
                keyUserId = userId;
                //console.log('keyUserId1'+keyUserId);
            }
            //Get selected Seller ID
            else{
                keyUserId = sellerId;
                //console.log('keyUserId2'+keyUserId);
            }
            
            //If key account manager then getKeyCustomers
            
            action = component.get("c.getKeyCustomers");
            action.setParams({ 
                "userId": keyUserId,
                "orderType": orderType,
                "customerGroup": customerGroup,
                "accountId": accountId
            }); 
        }
        else{
            //If not key account manager then getCustomers
            //selectedUser added by ganesh
            //desc: if selectedUser is not blank then get customer 
            action = component.get("c.getCustomers");	
            action.setParams({ 
                "selectedUser":sellerId,
                "orderType": orderType,
                "customerGroup": customerGroup,
                "accountId": accountId
            }); 
            
        }

        // show spinner to true on click of a button / onload
        component.set("v.showSpinner", true);    

        action.setCallback(this,function(resp){
            // on call back make it false ,spinner stops after data is retrieved
           component.set("v.showSpinner", false);     
            
            var state = resp.getState();
            if(component.isValid() && state == 'SUCCESS'){
                //pass the records to be displayed
                //console.log('Accounts: '+JSON.stringify(resp.getReturnValue()));
                component.set("v.accountTableConfig",tableConfig);
                component.set("v.accountList",resp.getReturnValue());
                var custbtn = component.find("custitem");
        	  	custbtn.set('v.disabled',false);
                 //pass the configuration of task table
             //   component.set("v.accountTableConfig",tableConfig);
                
                //pass the column information
                component.set("v.accountTableColumns",tableColumns);
                
                
                //initialize the datatable
                component.find("accountTable").initialize({
                    "order":[0,"desc"],
                    "itemMenu":["5","10","25","50"],
                    "itemsPerPage:":5
                });
            }
            else{
                //console.log(resp.getError());
            } 
        });
        
        $A.enqueueAction(action);
  	  },
    
    //fetchSOM : function(component,currentValue) {
    fetchSOM : function(component) {
        var action = component.get("c.getSOM");

       var currentValue = component.get("v.selectedUser");
       console.log('currentValue'+currentValue);
        
        //Column data for the table
        var somTableColumns = [
            {
                'label': $A.get("$Label.c.SOM_Code"),
                'name':'SalesOrderNumber_Brazil__c',
                'type':'string',
                'value':'Id',
                'width': 100,
                'resizeable':true
            },
            {
                'label': $A.get("$Label.c.Code"),
                'name':'SAP_Order_Number__c',
                'type':'string',              
                'resizeable':true
            },
            {
                'label': $A.get("$Label.c.SOM_Customer"),
                'name':'Sold_to_Party__r.Name',
                'type':'string',              
                'resizeable':true
            },
            {
                'label': $A.get("$Label.c.Customer_Group"),
                'name':'Sold_to_Party__r.Customer_Group__c',
                'type':'string',              
                'resizeable':true
            },
            {
                'label': $A.get("$Label.c.City"),
                'name':'Sold_to_Party__r.BillingCity',
                'type':'string',              
                'resizeable':true
            },
            {
                'label': $A.get("$Label.c.State"),
                'name':'Sold_to_Party__r.BillingState',
                'type':'string',              
                'resizeable':true
            }
        ];
        
        //Configuration data for the table to enable actions in the table
        var somTableConfig = {
            "massSelect":false,
            "globalAction":[],
            "searchByColumn":true,
            "rowAction":[
                {
                    "label": $A.get("$Label.c.Select"),
                    "type":"url",
                    "id":"selectsom"
                }
            ]
            
        };
         if(component.get("v.selectedUser")!=null && component.get("v.selectedUser")!=undefined && component.get("v.selectedUser")!='None'){
            action.setParams({
                currentValue: component.get("v.selectedUser")
            });
         }
        
        
        // show spinner to true on click of a button / onload
        component.set("v.showSpinner", true);
        
        action.setCallback(this,function(resp){
            // on call back make it false ,spinner stops after data is retrieved
            component.set("v.showSpinner", false);
            
            var state = resp.getState();
            if(component.isValid() && state == 'SUCCESS'){
                //pass the records to be displayed
                var data = resp.getReturnValue();
               
                var som=component.get("v.somList");
                
                component.set("v.somList",resp.getReturnValue());
                
                //pass the column information
                component.set("v.somTableColumns",somTableColumns);
                //pass the configuration of task table
                component.set("v.somTableConfig",somTableConfig);
                
                //initialize the datatable
                component.find("somTable").initialize({
                    "order":[0,"desc"],
                    "itemMenu":["5","10","25","50"],
                    "itemsPerPage:":5                        
                });
            }
            else{
                //console.log(resp.getError());
            }         
        });
        
        $A.enqueueAction(action);
    },
    getShipToParty: function(component, event,distrId){
        console.log(distrId);
       // component.set("v.shipToPartyList","");
         var tableColumns = [
           
            {
                'label': $A.get("$Label.c.Name"),
                'name':'Location_Name__c',
                'type':'string',              
                'resizeable':true
            },
            {
                'label': 'Customer',
                'name':'Distributor__r.Name',
                'type':'string',  
                'resizeable':true
            },
            {
                'label': 'City',
                'name':'City__c',
                'type':'string',     
                'resizeable':true
            },
            {
                'label': 'State',
                'name':'State__c',
                'type':'string',   
                'resizeable':true
            },
            {
                'label': 'Country',
                'name':'Country__c',
                'type':'string',   
                'resizeable':true
            },
            {
                'label': 'Pincode',
                'name':'Pincode__c',
                'type':'string',   
                'resizeable':true
            }
            
        ];
        
        var tableConfig = {
            "massSelect":false,
            "globalAction":[],
            "searchByColumn":true,
            "rowAction":[
                {
                    "label": 'Select',
                    "type":"url",
                    "id":"selectshiptoparty"
                }
            ]
            
        };
        var action = component.get("c.getShippingLoations");
        action.setParams({
            "accId":distrId  
        });
        action.setCallback(this,function(response){
         var state = response.getState();
            if(state == 'SUCCESS'){
              console.log('ship to party>>--->'+response.getReturnValue());  
              //if(response.getReturnValue() !=null){
                  component.set("v.shipToPartyList",response.getReturnValue());
                  component.set("v.shipToPartyTableColumns",tableColumns);
                  component.set("v.shipToPartyTableConfig",tableConfig); 
             // }    
              
              var custbtn = component.find("itemShip");
        		custbtn.set('v.disabled',false);
                //initialize the datatable
                component.find("shipartyTable").initialize({
                    "order":[0,"desc"],
                    "itemMenu":["5","10","25","50"],
                    "itemsPerPage:":5
                });  
            }
            
        });
         $A.enqueueAction(action);
    },
    fetchPriceBookDetails : function(component) {
        
        var motherOrderId = component.get("v.newSalesOrder.Sales_Order__c"); 
        console.log('motherOrderId: '+motherOrderId);
        //alert('SOM Id'+motherOrderId);
        var action;
        var priceDetailTableColumns;  
        
        var selAccount = component.get("v.selItem");
        var accountState = '';
        console.log('filled selItem: '+selAccount);
        
        if(selAccount){
            accountState = selAccount.Customer_Region__c;
        }
        if(selAccount==null){
             accountState = component.get("v.newSalesOrder.Sold_to_Party__r.Customer_Region__c");
        }
        
        
        //console.log('motherOrderId: '+motherOrderId);
        if(motherOrderId!=null){
            action = component.get("c.getMOPriceBookDetails");
            //Column data for the table
            priceDetailTableColumns = [
                {
                    'label': $A.get("$Label.c.Product_Code"),
                    'name':'skuCode',
                    'type':'string',
                    'resizeable':true
                },
                {
                    'label': $A.get("$Label.c.Name"),
                    'name':'skuDescription',
                    'type':'string',              
                    'resizeable':true
                },
                {
                    'label': $A.get("$Label.c.Category"),
                    'name':'skuCategory',
                    'type':'string',              
                    'resizeable':true
                },
                {
                    'label': $A.get("$Label.c.Date_of_FAT"),
                    'name':'fatDate',
                    'type':'string',              
                    'resizeable':true
                },
                {
                    'label': $A.get("$Label.c.Qty"),
                    'name':'qty',
                    'type':'string',              
                    'resizeable':true
                },
                {
                    'label': $A.get("$Label.c.Balance"),
                    'name':'balanceQty',
                    'type':'string',              
                    'resizeable':true
                },
                {
                    'label':'%',
                    'name':'percUsed',
                    'type':'string',              
                    'resizeable':true
                },
                {
                    'label': $A.get("$Label.c.Unit_Value_With_Interest"),
                    'name':'unitValueWithInterest',
                    'type':'string',              
                    'resizeable':true
                }
                
            ];
        }
        else{
            action = component.get("c.getPriceBookDetails");
            //Column data for the table
            priceDetailTableColumns = [
                {
                    'label': $A.get("$Label.c.Product_Code"),
                    'name':'skuCode',
                    'type':'string',
                    'resizeable':true
                },
                {
                    'label': $A.get("$Label.c.Name"),
                    'name':'skuDescription',
                    'type':'string',              
                    'resizeable':true
                },
                {
                    'label': $A.get("$Label.c.Category"),
                    'name':'skuCategory',
                    'type':'string',              
                    'resizeable':true
                }
                
                /*,
                {
                    'label':'State',
                    'name':'regState',
                    'type':'string',              
                    'resizeable':true
                },
                {
                    'label':'Is Valid',
                    'name':'isValid',
                    'type':'string',              
                    'resizeable':true
                }*/                
                ];            
            }
        
       
        
        //Configuration data for the table to enable actions in the table
        var priceDetailTableConfig = {
            "massSelect":false,
            "globalAction":[],
            "searchByColumn":true,
            "rowAction":[
                {
                    "label": $A.get("$Label.c.Select"),
                    "type":"url",
                    "id":"selectproduct"
                }
            ]
            
        };
        var priceBookId='';
        var isChecked= component.find("campChk").get("v.value");
        var cmpTp = component.get("v.newSalesOrder.Campaign_Type__c");
        if(isChecked && cmpTp=='Simple'){
            priceBookId = component.get("v.campaignId");
            component.set("v.newSalesOrder.Price_Book__c",priceBookId);
        }
        else{
            priceBookId = component.get("v.newSalesOrder.Price_Book__c");
        }
         
        var depotCode = component.get("v.selItem.Depot_Code__c");
        if(depotCode==null){
         depotCode = component.get("v.newSalesOrder.Sold_to_Party__r.Depot_Code__c");
        }
        
        console.log('priceBookId2-: '+priceBookId);
        console.log('depotCode2:- '+depotCode);
        console.log('accountState: '+accountState);
        
        var orderId = component.get("v.recordId");
        
        console.log('motherOrderId: '+motherOrderId);
        
        
        if(motherOrderId!=null){
            action.setParams({ 
                "priceBookId": priceBookId,
                "motherOrderId": motherOrderId,
                "depotCode": depotCode,
                "accountState": accountState,
                "orderId" : orderId,
                "withDraft": true
            });  
        }
        else{
            action.setParams({ 
                "priceBookId": priceBookId,
                "depotCode": depotCode,
                "accountState": accountState
            });  
        }
        
        //show spinner to true on click of a button / onload
        //component.set("v.showSpinner", true);  
        
        action.setCallback(this,function(resp){
            
            //on call back make it false ,spinner stops after data is retrieved
            //component.set("v.showSpinner", false); 
            
            var state = resp.getState();
            
            //console.log('PriceBook getState(): '+JSON.stringify(resp.getState()));
            //console.log('PriceBook getReturnValue(): '+JSON.stringify(resp.getReturnValue()));
            
            if(component.isValid() && state == 'SUCCESS'){
                //console.log('PriceBook ReturnValue(): '+JSON.stringify(resp.getReturnValue()));
                console.log('PriceBook ReturnValue(): '+resp.getReturnValue().length);
                //pass the records to be displayed
                component.set("v.priceDetailList",resp.getReturnValue());
                
                //Start Map
                if(motherOrderId!=null){
                    /*var priceDetailList = resp.getReturnValue();
                    var priceMap = new Map();
                    for (var idx = 0; idx < priceDetailList.length; idx++) {
                        priceMap.set(priceDetailList[idx].itemNo, priceDetailList[idx]);
                    }
                    component.set("v.priceMap", priceMap);*/
                        //console.log('priceMap: '+JSON.stringify(priceMap));
                    }
                    //End Map
                    
                    //pass the column information
                    component.set("v.priceDetailTableColumns",priceDetailTableColumns);
                    //pass the configuration of task table
                    component.set("v.priceDetailTableConfig",priceDetailTableConfig);
                    
                    //initialize the datatable
                    component.find("priceDetailsTable").initialize({
                        "order":[0,"desc"],
                        "itemMenu":["5","10","25","50"],
                        "itemsPerPage:":5                    
                    });
                }
                else{
                    //console.log(resp.getError());
                }           
            });
        
        $A.enqueueAction(action);
    },
    
    //Re-intializing Pricebook Table
    fetchServerPriceBookDetails : function(component, priceList) {
        
        //Column data for the table
        var priceDetailTableColumns = [
            {
                'label': $A.get("$Label.c.Product_Code"),
                'name':'skuCode',
                'type':'string',
                'resizeable':true
            },
            {
                'label': $A.get("$Label.c.Name"),
                'name':'skuDescription',
                'type':'string',              
                'resizeable':true
            },
            {
                'label': $A.get("$Label.c.Date_of_FAT"),
                'name':'fatDate',
                'type':'string',              
                'resizeable':true
            },
            {
                'label': $A.get("$Label.c.Qty"),
                'name':'qty',
                'type':'string',              
                'resizeable':true
            },
            {
                'label': $A.get("$Label.c.Balance"),
                'name':'balanceQty',
                'type':'string',              
                'resizeable':true
            },
            {
                'label':'%',
                'name':'percUsed',
                'type':'string',              
                'resizeable':true
            },
            {
                'label': $A.get("$Label.c.Unit_Value_With_Interest"),
                'name':'unitValueWithInterest',
                'type':'string',              
                'resizeable':true
            }
            
        ];
        
        
        //Configuration data for the table to enable actions in the table
        var priceDetailTableConfig = {
            "massSelect":false,
            "globalAction":[],
            "searchByColumn":true,
            "rowAction":[
                {
                    "label": $A.get("$Label.c.Select"),
                    "type":"url",
                    "id":"selectproduct"
                }
            ]
            
        };

        component.set("v.priceDetailList", priceList);
        
        //pass the column information
        component.set("v.priceDetailTableColumns",priceDetailTableColumns);
        //pass the configuration of task table
        component.set("v.priceDetailTableConfig",priceDetailTableConfig);
        
        //initialize the datatable
        component.find("priceDetailsTable").initialize({
            "order":[0,"desc"],
            "itemMenu":["5","10","25","50"],
            "itemsPerPage:":5                    
        });
        
        this.validateSOCBeforeSave(component);
    },
	
    getPBPayMent : function(component, event, pb_id) {
        // show spinner to true on click of a button / onload
		//alert('helper');
        component.set("v.showSpinner", true);        
        var action = component.get("c.getPBPaymentTerms");    
        
        action.setParams({ 
                "priceBook_id": pb_id
            }); 
        
        var opts=[];           
        //action.setStorable();        
        action.setCallback(this, function(a) {
            
            // on call back make it false ,spinner stops after data is retrieved
            component.set("v.showSpinner", false); 
            
            var state = a.getState();
            var blkDt='';
            var flag=true;

            var today = new Date();
            var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
            var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
            var yyyy = today.getFullYear();
            
            // Custom date format for ui:inputDate
            var currentDate = (yyyy + "-" + MM + "-" + dd);
            
            if (state == "SUCCESS") {
                var returnValue = a.getReturnValue();
                component.set("v.pbPaymentTerms",returnValue);
                   
                if(returnValue.priceBook!=null){
                    component.set("v.interestDate",returnValue.priceBook.Interest_Date__c);
                    component.set("v.blockDate",returnValue.priceBook.Sales_Order_Block_Date__c);
                    blkDt=returnValue.priceBook.Sales_Order_Block_Date__c;
                }

                if(blkDt!=null || blkDt!=''){
                    if(blkDt<currentDate){
                       flag=false;

                        var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.Block_Date_Reached}");
                        var titl  = $A.get("{!$Label.c.Error}");
                        toastEvent.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg
                        });
                        toastEvent.fire();
                        component.find("Campaign").focus();
                    }

                }
                if(flag == true){
                    //Payment Terms Map Day
                   if(returnValue.payTermsDays!=null){
                        opts=[];
                        opts.push({"class": "optionClass", label: $A.get("$Label.c.None"), value: 'None'});  
                        var paymentTermsMap = returnValue.payTermsDays;
                        
                        for (var key in paymentTermsMap){
                            if(key != 'null null'){
                              opts.push({"class": "optionClass", label: key, value: key});
                            }
                        }     
                       // console.log('Payment Terms:'+JSON.stringify(opts));
                        component.set("v.paymentTermsMapDY", paymentTermsMap);
                        component.find("payTmdy").set("v.options", opts);
                    }
                    //End  
                    
                    //Payment Terms Map Date
                if(returnValue.payTermsDates!=null){
                        opts=[];
                        opts.push({"class": "optionClass", label: $A.get("$Label.c.None"), value: 'None'});  
                        var paymentTermsMapDT = returnValue.payTermsDates;
                        
                        for (var key in paymentTermsMapDT){
                            if(key != 'null'){
                              opts.push({"class": "optionClass", label: key, value: key});
                            }    
                        }   
                         //Payment Terms BR71...
                        if(returnValue.payTermBR71!=null){
                            var paymentTermBR71 = returnValue.payTermBR71;
                            var val= paymentTermBR71.Payment_Term_Code__c+' '+paymentTermBR71.Payterms_Desc__c;
                            opts.push({"class": "optionClass", label: val, value: val});
                            component.set("v.paymentTermBR71", paymentTermBR71);   
                        }

                      //  console.log('Payment Terms Date:'+JSON.stringify(opts));
                        component.set("v.paymentTermsMapDT", paymentTermsMapDT);
                        component.find("payTmDt").set("v.options", opts);
                    }
                    //End 
                }
            }
        });
        $A.enqueueAction(action);
    },

   

    
})