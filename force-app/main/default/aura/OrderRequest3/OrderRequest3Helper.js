({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB
    CHUNK_SIZE: 750000, //Chunk Max size 750Kb

    //Logic to show/hide modal by toggling css class .tog
    toggle: function (component) {
        var lookupmodal = component.find("lookupmodal");
        $A.util.toggleClass(lookupmodal, "slds-hide");

        var backdrop = component.find("backdrop");
        $A.util.toggleClass(backdrop, "slds-hide");
    },

    //Logic to show/hide modal by toggling css class .tog2
    toggleDialog: function (component) {
        var dialog = component.find("approvalDialog");
        $A.util.toggleClass(dialog, "slds-hide");

        var backdrop2 = component.find("backdrop2");
        $A.util.toggleClass(backdrop2, "slds-hide");
    },

    //Logic to show/hide confirm modal by toggling css class .tog3
    toggleConfirmDialog: function (component) {
        var dialog = component.find("confirmDialog");
        $A.util.toggleClass(dialog, "slds-hide");

        var backdrop3 = component.find("backdrop3");
        $A.util.toggleClass(backdrop3, "slds-hide");
    },

    //Logic to show/hide confirm modal by toggling css class .tog3
    toggleSignDialog: function (component) {
        var dialog = component.find("signDialog");
        $A.util.toggleClass(dialog, "slds-hide");

        var backdrop4 = component.find("backdrop4");
        $A.util.toggleClass(backdrop4, "slds-hide");
    },
    //logic to block browser back button
    redirectBack: function (component, event) {
        history.pushState(null, null, location.href);
        window.onpopstate = function () {
            history.go(1);
        };
        console.log("The value redirectBack");
        return false;
    },

    //Disable Currency/PriceList/SOM/Account/OrderType/Dates
    enableDisableFields: function (component, length) {
        var orderType = component.get("v.orderType");
        var isChecked = component.get("v.CampaignCheck"); //component.find("campChk").get("v.value");
        //console.log('Length: '+length);
        var keyAcc = component.get("v.showKeyAccount");
        var isPunctual = component.get("v.isPunctual");
        var isStrChild = component.get("v.isOrdemFilha");
        var isBraziluser = component.get("v.isbraziluser");

        if (orderType != "ORDEM FILHA") {
            if (length >= 1) {
                //alert(length);
                component.set("v.disablePriceCurrency", true);
                component.set("v.disableOrderType_Dates_SOM_Account", true);
                component.set("v.disablePaymentMethod", true);
                //.....nik
                if (isChecked) {
                    if(component.find("simpCmp") != undefined){
                    	component.find("simpCmp").set("v.disabled", true);
                    }
                    if(component.find("structCmp") != undefined){
                        component.find("structCmp").set("v.disabled", true);
                    }
                }
                //  if(orderType == 'VENDA NORMAL'){
                component.find("dirSaleYes").set("v.disabled", true);
                component.find("dirSaleNo").set("v.disabled", true);
                //}

                if (keyAcc) {
                    component.find("keyYes").set("v.disabled", true);
                    component.find("keyNo").set("v.disabled", true);
                }

                if (isPunctual == true) {
                    component.find("punctualitydisc").set("v.disabled", true);
                }

                //component.find("campChk").set("v.disabled",true);
                component.find("orderTypeOptions").set("v.disabled", true);
                if(component.find("radio1") != undefined){
                    component.find("radio1").set("v.disabled", true);
                }
                if(component.find("radio2") != undefined){
                    component.find("radio2").set("v.disabled", true);
                }

                //JSON.parse(JSON.stringify(component.find("custitem"))).set("v.disabled", true); // search icon id...nik
                if(component.find("itemShip") != undefined){
                    component.find("itemShip").set("v.disabled", true); // search icon id...nik
                }
                //  component.find("ExpNumDays").set("v.disabled",true);
                if (component.find("descYes") !== undefined) {
                    component.find("descYes").set("v.disabled", true);
                }
                if (component.find("descNo") !== undefined) {
                    component.find("descNo").set("v.disabled", true);
                }
            } else {
                component.set("v.disablePriceCurrency", false);
                //component.set("v.disableOrderType_Dates_SOM_Account", false);
                component.set("v.disablePaymentMethod", false);
                //....nik
                if (isChecked) {
                    component.find("simpCmp").set("v.disabled", false);
                    component.find("structCmp").set("v.disabled", false);
                }
                //if(orderType == 'VENDA NORMAL'){
                component.find("dirSaleYes").set("v.disabled", false);
                component.find("dirSaleNo").set("v.disabled", false);
                //}

                if (keyAcc) {
                    component.find("keyYes").set("v.disabled", false);
                    component.find("keyNo").set("v.disabled", false);
                }

                if (isPunctual == true) {
                    component.find("punctualitydisc").set("v.disabled", false);
                }

                //component.find("campChk").set("v.disabled",false);
                component.find("orderTypeOptions").set("v.disabled", false);
                component.find("radio1").set("v.disabled", false);
                component.find("radio2").set("v.disabled", false);
                component.find("custitem").set("v.disabled", false); // search icon id...nik
                component.find("itemShip").set("v.disabled", false); // search icon id...nik
                //   component.find("ExpNumDays").set("v.disabled",false);
                if (!isStrChild && !isBraziluser) {
                    component.find("descYes").set("v.disabled", false);
                    component.find("descNo").set("v.disabled", false);
                }
            }
            // var isPunctual = component.get("v.isPunctual");

            if (isPunctual == true) {
                component.find("descNo").set("v.value", false);
            }

            var showKeyAccount = component.get("v.showKeyAccount");
            if (showKeyAccount == true) {
                var showSeller = component.get("v.showSeller");
                if (showSeller) {
                    if (showSeller == true) {
                        component.find("keyNo").set("v.value", false);
                    }
                }
            }
        } else {
            if (length >= 1) {
                //alert(length);
                component.set("v.disableOrderType_Dates_SOM_Account", true);

                //.....nik
                if (isChecked) {
                    component.find("simpCmp").set("v.disabled", true);
                    component.find("structCmp").set("v.disabled", true);
                }
                // if(orderType == 'VENDA NORMAL'){
                component.find("dirSaleYes").set("v.disabled", true);
                component.find("dirSaleNo").set("v.disabled", true);
                //}
                if (keyAcc) {
                    component.find("keyYes").set("v.disabled", true);
                    component.find("keyNo").set("v.disabled", true);
                }

                if (isPunctual == true) {
                    component.find("punctualitydisc").set("v.disabled", true);
                }

                //component.find("campChk").set("v.disabled",false);
                component.find("orderTypeOptions").set("v.disabled", true);
                component.find("radio1").set("v.disabled", true);
                component.find("radio2").set("v.disabled", true);
                component.find("custitem").set("v.disabled", true); // search icon id...nik
                component.find("itemShip").set("v.disabled", true); // search icon id...nik
                //  component.find("ExpNumDays").set("v.disabled",true);
                if (!isStrChild && !isBraziluser) {
                    component.find("descYes").set("v.disabled", true);
                    component.find("descNo").set("v.disabled", true);
                }
            } else {
                //  component.set("v.disableOrderType_Dates_SOM_Account", false);

                //....nik
                if (isChecked) {
                    component.set("v.isChildDisabled", true);
                    //component.find("simpCmp").set("v.disabled",false);
                    // component.find("structCmp").set("v.disabled",false);
                }
                // if(orderType == 'VENDA NORMAL'){
                component.find("dirSaleYes").set("v.disabled", true);
                component.find("dirSaleNo").set("v.disabled", true);
                //}
                if (keyAcc) {
                    component.find("keyYes").set("v.disabled", false);
                    component.find("keyNo").set("v.disabled", false);
                }

                if (isPunctual == true) {
                    component.find("punctualitydisc").set("v.disabled", false);
                }
                //component.find("campChk").set("v.disabled",false);
                component.find("orderTypeOptions").set("v.disabled", false);
                component.find("radio1").set("v.disabled", true);
                component.find("radio2").set("v.disabled", true);
                component.find("custitem").set("v.disabled", false); // search icon id...nik
                component.find("itemShip").set("v.disabled", false); // search icon id...nik
                //   component.find("ExpNumDays").set("v.disabled",false);
                if (!isStrChild && !isBraziluser) {
                    component.find("descYes").set("v.disabled", true);
                    component.find("descNo").set("v.disabled", true);
                }
            }
        }
    },

    // 1. Used to Navigate to Standard List View on Salesforce1 App
    // 2. Commented Code was used earlier to Navigate to Custom List View Lighning Component
    navigateToComponent: function (component) {
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
        var listId = "00B0k000000Nxt9EAC";
        var navEvent = $A.get("e.force:navigateToList");

        if (navEvent != undefined) {
            navEvent.setParams({
                listViewId: listId,
                listViewName: null,
                scope: "Sales_Order__c",
            });
            navEvent.fire();
        } else {
            window.history.back();
        }
    },



//  Added below function for RITM0508956 GRZ(Dheeraj Sharma) 20-02-2023

  fetchRegionCode :function(component){
  var action = component.get("c.getRegionCode");
      
        action.setCallback(this, function(a) {
            
            var state = a.getState();
            console.log('state***',state);
            if (state == "SUCCESS") {
                var returnValue = a.getReturnValue();
                console.log('Dsregion***',returnValue);
                component.set("v.regCode",returnValue);
            }
            else{
                console.log('Error-----');
            }
        });
        $A.enqueueAction(action); 

    },

    // End for RITM0508956 GRZ(Dheeraj Sharma) 20-02-2023



    // 1. Method call to reload existing SO
    // 2. Called in getOrderFields() after all Fields are loaded.
    // 3. Uses recordId to fetch related data of a Regular/Simulated record.
    reloadSO: function (component, event) {
        var isSimulated = component.get("v.isSimulated");
        console.log("isSimulated --> " + isSimulated);
        //this.isbrazilusercheck(component);
        //this.isBrazilSalesUser(component);
        var isBraziluser = component.get("v.isbraziluser");
        var isBrazilsalesuser = component.get("v.isbraziluser1");
        //alert(isBrazilsalesuser);
        var flag = false;
        var pb_id = "";
        //var sid = component.get("v.newSalesOrder.Sales_Order__c");
        //added by Sagar@Wipro for Cogs
        var profileName = component.get("v.orderFields.userObj.Profile.Name");
        console.log("User Profile on View Order" + profileName);
        /* start Added this condition by GRZ(Javed) for RITM0503899 modified 13-02-2023-->*/
        if (profileName != null && profileName != "BRAZIL CONTRACTORS") {
            // alert('profileName:'+profileName);
            component.set("v.isbrazilContractor", true);

        }
        /* end Added this condition by GRZ(Javed) for RITM0503899 modified 13-02-2023-->*/
        console.log('profileName@@@:' + profileName);
        console.log('isbrazilContractor:' + component.get("v.isbrazilContractor"));
        if (profileName == "Brazil Sales Person") {
            component.set("v.isCogsVisible", false);
        }
        if (isSimulated) {
            component.set("v.headerMsg", $A.get("$Label.c.Create_Simulation_Order"));

        }
        else {
            console.log("Inside else in helper.js");
            console.log("recordId --> " + component.get("v.recordId"));
            component.set("v.headerMsg", $A.get("$Label.c.Create_Order"));
        }

        var action = component.get("c.getSalesOrder");
        var soId = component.get("v.recordId");
        console.log("soId --> " + soId);
        var salesOrder = {};
        if (soId != null) {
            console.log("soId not null123--> " + soId);
            component.set("v.headerMsg", $A.get("$Label.c.VIEW_ORDER"));
            console.log("the order sales1");
            action.setParams({
                soId: soId,
            });

            //action.setStorable();
            action.setCallback(this, function (a) {
                try {
                    var state = a.getState();
                    console.log("the order state", state);
                    if (state == "SUCCESS") {
                        console.log("the order sales4");
                        salesOrder = a.getReturnValue();
                        //alert(JSON.stringify(salesOrder));
                        component.set("v.isEdit", false); //......nik..
                        component.set("v.newSalesOrder", salesOrder);
                        console.log("salesOrder:" + JSON.stringify(salesOrder));
                        var gmJuros = component.get("v.newSalesOrder.Sales_Order_Replacement_Margin_WI__c");
                        console.log('Juros' + gmJuros);
                        var gmJuros1 = component.get("v.newSalesOrder.SalesOrderReplacementMargin__c");
                        console.log('Juros1' + gmJuros1);
                        var gmJuros2 = gmJuros - gmJuros1;
                        component.set("v.gmjuros4", gmJuros2);
                        console.log('Juros2' + gmJuros2);
                        // alert(salesOrder.Payment_Term__c);
                        if (salesOrder.Kit_Order__c) {
                            component.set("v.SelectPriceBook", "Price Book for Kit");
                            component.set("v.CampaignCheck", false);
                            component.set("v.isAvec", false);
                        } else if (salesOrder.Use_Campaign__c) {
                            component.set("v.SelectPriceBook", "Price Book for Campaign");
                            component.set("v.CampaignCheck", true);
                            component.set("v.isAvec", false);
                        } else if (salesOrder.AVEC_Order__c) {
                            component.set(
                                "v.SelectPriceBook",
                                "AVEC / Descontinuados Price Book"
                            );
                            component.set("v.isAvec", true);
                            component.set("v.CampaignCheck", false);
                        } else {
                            component.set("v.SelectPriceBook", "Normal Price Book");
                            component.set("v.CampaignCheck", false);
                            component.set("v.isAvec", false);
                        }

                        component.set("v.recordType", salesOrder.RecordType.Name);
                        component.set("v.sfdcOrderNo", salesOrder.SalesOrderNumber_Brazil__c);
                        console.log("salesOrderAccountID:" + salesOrder.Sold_to_Party__c);
                        component.set("v.accountId", salesOrder.Sold_to_Party__c);
                        console.log("The Fetch fetchAccounts");
                        this.fetchAccounts(component); //Added by VT.11 NOV_21
                        console.log("The Fetch Account");
                        // selItem is an Sobject of Type Account
                        // Reconstructing the object from Sales Order fields
                        component.set("v.selItem", {
                            sobjectType: "Account",
                            Id: salesOrder.Sold_to_Party__c,
                            Name: salesOrder.Sold_to_Party__r.Name,
                            Program_Margin_Discount__c: salesOrder.Sold_to_Party__r.Program_Margin_Discount__c,
                            SAP_Code__c: salesOrder.Sold_to_Party__r.SAP_Code__c,
                            Tax_Number_Br_Portal_Filter__c: salesOrder.Sold_to_Party__r.Tax_Number_Br_Portal_Filter__c,//  add this   for RITM0482250 GRZ(Javed Ahmed)
                            Depot_Code__c: salesOrder.Sold_to_Party__r.Depot_Code__c,
                            Tax_Number_1__c: salesOrder.Sold_to_Party__r.Tax_Number_1__c,
                            Tax_Number_3__c: salesOrder.Sold_to_Party__r.Tax_Number_3__c,
                            Customer_Region__c: salesOrder.Sold_to_Party__r.Customer_Region__c,
                            'Customer_Group__c': salesOrder.Sold_to_Party__r.Customer_Group__c,
                            'BillingCity': salesOrder.Sold_to_Party__r.BillingCity,
                            'Price_Conversion_Group__c': salesOrder.Sold_to_Party__r.Price_Conversion_Group__c,
                            'BillingState': salesOrder.Sold_to_Party__r.BillingState

                        });
                        console.log("Account  obj-----> " + JSON.stringify(component.get("v.selItem")));
                        this.getTaxAndFreight(component);     // SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.......
                        // added by Nik..***************.
                        if (salesOrder.Ship_To_Party__c != undefined) {
                            console.log(
                                "Ship to party val .---> " + salesOrder.Ship_To_Party__c
                            );
                            console.log("Length---> " + salesOrder.Ship_To_Party__c.length);
                            if (salesOrder.Ship_To_Party__c.length > 0) {
                                console.log("Test...---");
                                component.set("v.selItem5", {
                                    sobjectType: "Shipping_Location__c",
                                    Id: salesOrder.Ship_To_Party__c,
                                    Location_Name__c: salesOrder.Ship_To_Party__r.Location_Name__c
                                });
                            }
                        }
                        //component.find("itemShipToParty").set("v.value",component.get("v.selItem6.Location_Name__c"));
                        console.log(
                            "Shipto Party obj-----> " +
                            component.get("v.selItem5.Location_Name__c")
                        );

                        var orderStatus = salesOrder.Order_Status__c;
                        var OpenUserTM = salesOrder.TM_Code__c;
                        //alert('Key '+salesOrder.Key_Account__c);
                        var keyAccnt = salesOrder.Key_Account__c;
                        var selectedUsr = salesOrder.KeyAccountDesOwnerBrazil__c;
                        console.log("OpenUserTM" + OpenUserTM);
                        console.log("selectedUsr" + selectedUsr);

                        if (orderStatus == "Error from SAP") {
                            component.set(
                                "v.sapOrderNo",
                                $A.get("$Label.c.Order_not_pushed_to_SAP")
                            );
                        } else {
                            component.set("v.sapOrderNo", salesOrder.SAP_Order_Number__c);
                        }

                        if (orderStatus != "Draft") {
                            component.set("v.showValidFromTo", false);
                        }

                        //component.set("v.newSalesOrder.Price_Book__c", salesOrder.Price_Book__c);

                        var punctualitydisc = component.get(
                            "v.newSalesOrder.Punctuality_Discount__c"
                        );

                        //console.log('punctualitydisc: '+punctualitydisc);
                        // console.log('reload currency: '+JSON.stringify(salesOrder));
                        //console.log('reload currency2: '+a.getReturnValue().Currency_Brazil__c);

                        //component.set("v.selectedCurrency",a.getReturnValue().Currency_Brazil__c);
                        console.log(
                            "a.getReturnValue()" + JSON.stringify(a.getReturnValue())
                        );
                        component.set("v.priceBookId", a.getReturnValue().Price_Book__c);

                        //alert(a.getReturnValue().Price_Book__c);
                        //component.set("v.priceBookId",salesOrder.Sales_Order__r.Price_Book__c);

                        component.set("v.orderType", salesOrder.Type_of_Order__c);
                        component.set("v.paymentTerm", salesOrder.ReloadPaymentTerms__c);
                        component.set("v.paymentMethod", salesOrder.PaymentMethod__c);
                        console.log("*paymentTerm:" + salesOrder.ReloadPaymentTerms__c);
                        var opts5 = [];
                        opts5.push({
                            class: "optionClass",
                            label: salesOrder.ReloadPaymentTerms__c,
                            value: salesOrder.ReloadPaymentTerms__c,
                        });
                        component.find("paymentTermOptions").set("v.options", opts5);
                        console.log('component.find("paymentTermOptions")', JSON.stringify(component.find("paymentTermOptions")));
                        //component.set("v.totalValue", salesOrder.TotalValueWithInterest__c);//Commented By Ganesh

                        component.set(
                            "v.totalValue",
                            salesOrder.TotalValueWithoutInterest__c
                        );
                        component.set(
                            "v.incoTerm",
                            salesOrder.Inco_Term__r.IncoTerm_Code__c +
                            "," +
                            salesOrder.Inco_Term__c
                        );
                        component.set("v.showReset", false);

                        //added by ganesh
                        //desc: to get business rule of reloaded record
                        //console.log('salesOrder.Taxes__c'+salesOrder.Tax__c+'yy'+salesOrder.Freight__c);

                        component.set("v.businessRule.Taxes__c", salesOrder.Tax__c);
                        component.set("v.businessRule.Freight__c", salesOrder.Freight__c);

                        //console.log('a.getReturnValue().Price_Book__c'+a.getReturnValue().Price_Book__c);

                        var orderType = salesOrder.Type_of_Order__c;
                        var camType = salesOrder.Campaign_Type__c;
                        //Enable Boolean to know the reloaded order is a Mother Order.
                        if (orderType == "CONTRATO MÃE") {
                            component.set("v.isMother", true);
                        }

                        if (orderType == "ORDEM FILHA" || orderType == "BONIFICAÇÃO") {
                            // selItem3 is an Sobject of Type SOM i.e Sales Order
                            // Reconstructing the object from Sales Order fields
                            if (camType == "Structured") {
                                component.set("v.isOrdemFilha", true);
                            }
                            if (salesOrder.Sales_Order__r != undefined) {
                                component.set("v.selItem3", {
                                    Id: salesOrder.Sales_Order__c,
                                    Name: salesOrder.Sales_Order__r.Name,
                                    SAP_Order_Number__c:
                                        salesOrder.Sales_Order__r.SAP_Order_Number__c,
                                    Sold_to_Party__c: salesOrder.Sales_Order__r.Sold_to_Party__c,
                                    SalesOrderNumber_Brazil__c:
                                        salesOrder.Sales_Order__r.SalesOrderNumber_Brazil__c,
                                    Currency_Brazil__c: salesOrder.Sales_Order__r.Currency_Brazil__c,
                                    CurrencyIsoCode: salesOrder.Sales_Order__r.CurrencyIsoCode,
                                    Price_Book__c: salesOrder.Sales_Order__r.Price_Book__c,
                                    Type_of_Order__c: salesOrder.Sales_Order__r.Type_of_Order__c,
                                    Invoice_Message__c: salesOrder.Invoice_Message__c,
                                    ReloadPaymentTerms__c:
                                        salesOrder.Sales_Order__r.ReloadPaymentTerms__c,
                                    Sold_to_Party__r: {
                                        Name: salesOrder.Sales_Order__r.Sold_to_Party__r.Name,
                                        Customer_Group__c:
                                            salesOrder.Sales_Order__r.Sold_to_Party__r.Customer_Group__c,
                                        BillingCity:
                                            salesOrder.Sales_Order__r.Sold_to_Party__r.BillingCity,
                                        BillingState:
                                            salesOrder.Sales_Order__r.Sold_to_Party__r.BillingState,
                                        Id: salesOrder.Sales_Order__r.Sold_to_Party__c,
                                    },
                                });
                            }
                        }
                        component.set("v.priceBookId", a.getReturnValue().Price_Book__c);
                        component.set("v.campaignId", a.getReturnValue().Price_Book__c);
                        component.set(
                            "v.selectedCurrency",
                            a.getReturnValue().Currency_Brazil__c
                        );
                        var user = component.get("v.user");
                        var ownerId = salesOrder.OwnerId;
                        var userId = component.get("v.userId");
                        var profileName = component.get("v.orderFields.userObj.Profile.Name");

                        if (salesOrder.Use_Campaign__c == true) {
                            component.set("v.CampaignCheck", true);
                        }
                        /*if((ownerId!=userId || isSimulated) && profileName!='Brazil Sales District Manager'){
                               component.set("v.showLedgerReplacement",true);
                           }*/

                        if (salesOrder.RecordType.Name == "Simulation") {
                            //....CR92..nik...
                            component.set("v.isSimulated", true);
                            /* if(profileName=='Brazil Sales Office Manager' || profileName=='Brazil Sales District Manager'){   //..commented..CR106..nik...08/11/2019
                                        
                                        component.set("v.showLedgerReplacement",true);
                                        component.set("v.showCultrBrand",false);
                                      }*/
                            //Added brazil barter manager in IF Condition >> Grazitti(Tanuj)- RITM0333006-8 Aug 2022
                            //Removed Brazil Barter Manager condition >> GRZ(Nikhil Verma)- RITM0438349 -10-10-2022
                            if (
                                profileName != "Brazil Sales Person"
                            ) {
                                //....CR106..nik...08/11/2019

                                component.set("v.showLedgerReplacement", true);
                                component.set("v.showCultrBrand", false);
                            }
                            //Exception for SAMUEL CUNHA DA SILVA >> GRZ(Nikhil Verma)- RITM0447453 -28-10-2022
                            var samualUserId = component.get("v.orderFields.userObj.Id");
                            if (samualUserId == "0050K000008kFzFQAU") {
                                component.set("v.showLedgerReplacement", true);
                                component.set("v.showCultrBrand", false);
                            }
                            //-----------End GRZ(Nikhil Verma)- RITM0447453 -28-10-2022 --------------
                        } else {
                            //..commented..CR106..nik...08/11/2019
                            /*if(profileName == "Brazil Sales Office Manager" || profileName == "Brazil Sales Director" || profileName == "Brazil Regional Head" || profileName == "Custom System Administrator"){ 
                                       component.set("v.showLedgerReplacement",true);
                                       component.set("v.showCultrBrand",true);
                                     }*/

                            if (profileName != "Brazil Sales Person") {
                                //....CR106..nik...08/11/2019
                                component.set("v.showLedgerReplacement", true);
                                component.set("v.showCultrBrand", true);
                            }
                            else if (profileName == "Brazil Sales Person") {         //....CR106..nik...08/11/2019
                                component.set("v.showLedgerReplacement", true);
                            }
                            //Exception for SAMUEL CUNHA DA SILVA >> GRZ(Nikhil Verma)- RITM0447453 -28-10-2022
                            var samualUserId = component.get("v.orderFields.userObj.Id");
                            if (samualUserId == "0050K000008kFzFQAU") {
                                component.set("v.showLedgerReplacement", true);
                                component.set("v.showCultrBrand", true);
                                component.set("v.showDiscount", true);
                            }
                            //-----------End GRZ(Nikhil Verma)- RITM0447453 -28-10-2022 --------------
                        }

                        if (profileName != "Brazil Sales Person") {
                            component.set("v.showDiscount", true);
                        }

                        //If User is owner of record & Order is a 'Simulation' or 'Draft' Order then enable delete
                        if (
                            ownerId == userId &&
                            (isSimulated || salesOrder.Order_Status__c == "Draft")
                        ) {
                            component.set("v.showDelete", true);
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
                        var status = component.get(
                            "v.newSalesOrder.BrazilSalesOrderStatus__c"
                        );
                        var subStatus = component.get("v.newSalesOrder.OrderSubStatus__c");
                        //  var profileName = component.get("v.orderFields.userObj.Profile.Name");
                  //console.log('status: '+status);

                        // Cancel Button Visibility Logic
                        // 1. Logic for SP/CSU
                        if (profileName == "Brazil Customer Service User") {
                            //if(status=='Pending' || status=='Approved' || status=='Rejected'){
                            if (
                                status == $A.get("$Label.c.Pending") ||
                                status == $A.get("$Label.c.Approved") ||
                                status == $A.get("$Label.c.Rejected")
                            ) {
                                component.set("v.showCancel", true);
                                component.set("v.showRemarks", true);
                            }
                            //if(status=="Cancelled"){
                            if (status == $A.get("$Label.c.Cancelled")) {
                                component.set("v.showRemarks", true);
                                component.find("remarks").set("v.disabled", true);
                            }
                        }
                        //Logic to show budget value
                        if (
                            profileName == "Brazil Sales Director" ||
                            profileName == "Custom System Administrator" ||
                            profileName == "Brazil Regional Head"
                        ) {
                            component.set("v.showBudgetVal", true);
                        }
                        //end
                        // Logic for SP added by ganesh
                        if (profileName == "Brazil Sales Person") {
                            if (
                                status == $A.get("$Label.c.Pending") ||
                                status == $A.get("$Label.c.Rejected")
                            ) {
                                component.set("v.showCancel", false);
                            }

                            if (status == $A.get("$Label.c.Approved")) {
                                //component.set("v.showCancel", true);
                                //component.set("v.showRem
                                //arks", true);

                                component.set("v.showCancel", false);
                                component.set("v.showRemarks", false);
                            }

                            if (status == $A.get("$Label.c.Cancelled")) {
                                component.set("v.showRemarks", true);
                                component.find("remarks").set("v.disabled", true);
                            }
                        }

                        //BELOW 15 LINES OF CODE ADDED BY HARSHIT&ANMOL@WIPRO  ---START
                        if (profileName == "Brazil Sales Person") {
                            this.relatedsorder(component);
                            this.reloadSOItems(component);

                            component.set("v.newSalesOrder1", true);
                            console.log("profileName =" + profileName);
                        } else {
                            console.log("profileName =" + profileName);
                            this.reloadSOItems(component);
                        }

                        if (profileName == "Brazil Sales District Manager") {
                            this.relatedsorder(component);
                            this.reloadSOItems(component);

                            this.relatedOrder(component);
                            this.relatedOrder1(component);

                            component.set("v.newSalesOrder1", true);
                            console.log("district aa gya ");
                        }
                        //---END

                        // 2. Logic for System Admin
                        // changed by ganesh
                        else if (
                            profileName == "Brazil System Administrator" ||
                            profileName == "Brazil Customer Service User" ||
                            profileName == "Brazil Customer Service Manager"
                        ) {
                            //if(status=="Approved" || subStatus=='Approved'){
                            if (
                                status == $A.get("$Label.c.Approved") ||
                                subStatus == "Approved" ||
                                status == $A.get("$Label.c.Pending") ||
                                status == $A.get("$Label.c.Rejected")
                            ) {
                                component.set("v.showCancel", true);
                                component.set("v.showRemarks", true);
                            }
                            //if(status=="Cancelled"){
                            if (status == $A.get("$Label.c.Cancelled")) {
                                component.set("v.showRemarks", true);
                                component.find("remarks").set("v.disabled", true);
                            }
                        }
                        // 3. Logic for SOM/SDM
                        else if (
                            profileName == "Brazil Sales Office Manager" ||
                            profileName == "Brazil Sales District Manager" ||
                            profileName == "Brazil Barter Manager"
                        ) {
                            //added brazil barter manager to if condition >> Grazitti(Tanuj)- RITM0333006-8 Aug 2022
                            var selectedUser = component.get(
                                "v.newSalesOrder.KeyAccountDesOwnerBrazil__c"
                            );
                            var opts = [];
                            if (OpenUserTM) {
                                if (OpenUserTM && ownerId == userId) {
                                    console.log("selectedUser-" + selectedUser);
                                    component.set(
                                        "v.selectedUser",
                                        selectedUser + "~~" + OpenUserTM
                                    );
                                } else if (
                                    OpenUserTM &&
                                    ownerId != userId &&
                                    profileName == "Brazil Sales District Manager"
                                ) {
                                    opts.push({
                                        class: "optionClass",
                                        label: OpenUserTM + "- Open User",
                                        value: userId,
                                    });
                                    component.find("sellerOptions").set("v.options", opts);
                                } else if (
                                    OpenUserTM &&
                                    ownerId != userId &&
                                    (profileName == "Brazil Sales Office Manager" ||
                                        profileName == "Brazil Barter Manager")
                                ) {
                                    //added brazil barter manager to if condition >> Grazitti(Tanuj)- RITM0333006-8 Aug 2022
                                    opts.push({
                                        class: "optionClass",
                                        label: OpenUserTM + "- Open User",
                                        value: userId,
                                    });
                                    component.find("sellerOptions").set("v.options", opts);
                                }
                            } else {
                                console.log("selectedUser--" + selectedUser);
                                component.set("v.selectedUser", selectedUser);
                            }
                            
                        }
                        //End

                        //if(status=="Approved"){
                        if (status == $A.get("$Label.c.Approved")) {
                            if (ownerId != userId) {
                                component.set("v.showSimulate", true);
                            }
                            console.log("profileName" + profileName);
                            // Logic for SOM/SDM added by ganesh
                            if (
                                profileName == "Brazil Sales Office Manager" ||
                                profileName == "Brazil Sales District Manager" ||
                                profileName == "Brazil Sales Director" ||
                                profileName == "Brazil Regional Head" ||
                                profileName == "External Auditor"
                            ) {
                                //External Auditor added by Srikanth
                                component.set("v.showSimulate", false);
                            }
                            // Logic end
                            component.set("v.showPrint", true);
                            if (
                                profileName == "Brazil System Administrator" ||
                                profileName == "System Administrator" ||
                                profileName == "Brazil Customer Service User" ||
                                profileName == "Brazil Customer Service Manager"
                            ) {
                                component.set("v.showSignUnsign", true);
                                component.set("v.showSimulate", false);

                                var signed = component.get("v.newSalesOrder.Signed__c");

                                if (signed) {
                                    component.set("v.showSign", false);
                                    component.set("v.showUnsign", true);
                                    component.set(
                                        "v.signMessage",
                                        $A.get("$Label.c.Are_you_sure_you_want_to_unsign")
                                    );
                                } else {
                                    component.set("v.showSign", true);
                                    component.set("v.showUnsign", false);
                                    component.set(
                                        "v.signMessage",
                                        $A.get("$Label.c.Are_you_sure_you_want_to_sign")
                                    );
                                }
                            }
                            component.set("v.showSaveDraft", false);
                            component.set("v.disableEditStruct", true);
                            component.set("v.disableSaveStruct", true);
                        }

                        //if(status=="Rejected"){
                        if (status == $A.get("$Label.c.Rejected")) {
                            component.set("v.showSaveDraft", false);
                        }

                        //Disable Fields by default on reload
                        component.set("v.disableThis", true);
                        //component.set("v.disableSelect", true);
                        component.set("v.disablePaymentMethod", true);
                        component.set("v.disablePriceCurrency", true);
                        component.set("v.disableOrderType_Dates_SOM_Account", true);
                        // component.set("v.disableSearch", true);
                        //End

                        component.set("v.showOnReLoad", true);

                        //if(status=="Pending"){
                        if (status == $A.get("$Label.c.Pending")) {
                            if (ownerId != userId && profileName != "Brazil Barter Manager") {
                                component.set("v.showSimulate", true);
                            }

                            component.set("v.showSaveDraft", false);
                            component.set("v.showSubmitEdit", false);
                            component.set("v.disableEditStruct", true);
                            component.set("v.disableSaveStruct", true);
                        }
                        //else if(status=="Submitted" || status=="Cancelled"){
                        else if (
                            status == $A.get("$Label.c.Submitted") ||
                            status == $A.get("$Label.c.Cancelled")
                        ) {
                            component.set("v.showSaveDraft", false);
                            component.set("v.showSubmitEdit", false);
                        } else if (
                            status == $A.get("$Label.c.Rejected") &&
                            profileName != "Brazil Sales Person"
                        ) {
                            component.set("v.showSaveDraft", false);
                            component.set("v.showSubmitEdit", false);
                        }

                        if (
                            status == $A.get("$Label.c.Rejected") &&
                            profileName == "Brazil Sales District Manager"
                        ) {
                            //  console.log('ownerId'+ownerId+'userId'+userId);
                            if (ownerId == userId) {
                                component.set("v.showSubmitEdit", true);
                            }
                        }

                        var recordType = a.getReturnValue().RecordType.Name;
                        //console.log('recordType: '+recordType);

                        if (recordType == "Simulation") {
                            component.set("v.showSaveDraft", false);
                            component.set("v.showReset", true);
                            //var sfdcNo = 'Order No:25918  This order is Duplicated from Order No : 25917';
                            var checkParent = salesOrder.Parent_Order_Simulated__c;
                            if (checkParent) {
                                var sfdcNo =
                                    salesOrder.SalesOrderNumber_Brazil__c +
                                    ". " +
                                    $A.get("$Label.c.This_order_is_Duplicated_from_Order_No") +
                                    " " +
                                    salesOrder.Parent_Order_Simulated__r.SalesOrderNumber_Brazil__c;
                                component.set("v.sfdcOrderNo", sfdcNo);
                            }
                            component.set("v.showSAPNo", false);
                            component.set(
                                "v.headerMsg",
                                $A.get("$Label.c.View_Simulation_Order")
                            );
                            component.set("v.showDelete", true);
                        }
                        component.set("v.showRaiseOrder", false);

                        var approvedFlag = component.get(
                            "v.newSalesOrder.BrazilSalesOrderApproved__c"
                        );
                        if (!approvedFlag) {
                            component.set("v.disableEdit", false);
                        }

                        //Simulation Button visibility Logic

                        if (
                            profileName == "Brazil System Administrator" ||
                            profileName == "System Administrator" ||
                            profileName == "Brazil Customer Service User" ||
                            profileName == "Brazil Customer Service Manager" ||
                            profileName == "Brazil Barter Manager"
                        ) {
                            component.set("v.showSimulate", false);
                        }
                        //End
                        //Patch added by ganesh
                        if (
                            subStatus == $A.get("$Label.c.Pending_at_Sales_Office_Manager") ||
                            subStatus == $A.get("$Label.c.Pending_for_director_approval")
                        ) {
                            if (
                                profileName == "Brazil Sales Office Manager" ||
                                profileName == "Brazil Sales District Manager"
                            ) {
                                component.set("v.showSimulate", false);
                                //  console.log('subStatus'+subStatus);
                            }
                            if (
                                subStatus == $A.get("$Label.c.Pending_at_Sales_Office_Manager") &&
                                profileName == "Brazil Sales Office Manager"
                            ) {
                                if (salesOrder.RecordType.Name == "Simulation") {
                                    component.set("v.showSimulate", false);
                                } else {
                                    component.set("v.showSimulate", true);
                                }
                            }
                        }

                        //End Patch
                        this.fetchApprovalHistory(component, soId);
                        this.fetchErrorHistory(component, soId);
        } else {
                        console.log("The Error Is");
                        var toastMsg = $A.get("$Label.c.Error_while_reloading_SO");
                        this.showErrorToast(component, event, toastMsg);
                    }
                    console.log("the order  Next");
                    if (punctualitydisc > 0) {
                        if (!isBraziluser) {
                            if (component.find("descYes") !== undefined) {
                                component.find("descYes").set("v.disabled", true);
                            }
                            if (component.find("descNo") !== undefined) {
                                component.find("descNo").set("v.disabled", true);
                            }
                        }
                        component.set("v.isPunctual", true);
                        component.set(
                            "v.newSalesOrder.Punctuality_Discount__c",
                            punctualitydisc
                        );
                    }
                    console.log('955');

                    // selItem is an Sobject of Type Account
                    // Reconstructing the object from Sales Order fields
                    component.set("v.selItem", {
                        sobjectType: "Account",
                        Id: salesOrder.Sold_to_Party__c,
                        Name: salesOrder.Sold_to_Party__r.Name,
                        Program_Margin_Discount__c:
                            salesOrder.Sold_to_Party__r.Program_Margin_Discount__c,
                        SAP_Code__c: salesOrder.Sold_to_Party__r.SAP_Code__c,
                        Depot_Code__c: salesOrder.Sold_to_Party__r.Depot_Code__c,
                        Tax_Number_1__c: salesOrder.Sold_to_Party__r.Tax_Number_1__c,
                        Tax_Number_Br_Portal_Filter__c: salesOrder.Sold_to_Party__r.Tax_Number_Br_Portal_Filter__c,//  add this   for RITM0482250 GRZ(Javed Ahmed)
                        Tax_Number_3__c: salesOrder.Sold_to_Party__r.Tax_Number_3__c,
                        Customer_Region__c: salesOrder.Sold_to_Party__r.Customer_Region__c,
                        BillingCity: salesOrder.Sold_to_Party__r.BillingCity,
                        'BillingState': salesOrder.Sold_to_Party__r.BillingState,
                        'Customer_Group__c': salesOrder.Sold_to_Party__r.Customer_Group__c,
                        'Price_Conversion_Group__c': salesOrder.Sold_to_Party__r.Price_Conversion_Group__c
                    });

                    //alert(salesOrder.Use_Campaign__c);
                    if (salesOrder.AVEC_Order__c == true) {
                        component.set("v.isAvec", true);
                        if (salesOrder.Maturity_Date__c != null) {
                            component.set("v.isMature", "true");
                            var opts2 = [];
                            opts2.push({
                                class: "optionClass",
                                label: "BR71 INFORMAR VENCIMENTO",
                                value: "BR71 INFORMAR VENCIMENTO",
                            });
                            component.find("payTmDt").set("v.options", opts2);
                            console.log("sagarTest13:" + JSON.stringify(opts2));
                        } else if (salesOrder.Payment_Term__c != null) {
                            //  Payment_Term__r.Payterms_Desc__c
                            var opts2 = [];
                            opts2.push({
                                class: "optionClass",
                                label: salesOrder.ReloadPaymentTerms__c,
                                value: salesOrder.Payment_Term__c,
                            });
                            component.find("payTmdy").set("v.options", opts2);
                            console.log("Test12345:" + JSON.stringify(opts2));
                        } else {
                            var opts2 = [];
                            opts2.push({
                                class: "optionClass",
                                label: salesOrder.Campaign_Payment_Term_Date__c,
                                value: salesOrder.Campaign_Payment_Term_Date__c,
                            });
                            component.find("payTmDt").set("v.options", opts2);
                            console.log("sagarTest12:" + JSON.stringify(opts2));
                        }
                    }
                    if (salesOrder.Use_Campaign__c == true) {
                        //alert(salesOrder.Use_Campaign__c);
                        component.set("v.CampaignCheck", true);
                        //component.find("campChk").set("v.value",true);

                        //component.set("v.campaignId",a.getReturnValue().Price_Book__c);

                        //alert(salesOrder.Payment_Term__c);
                        if (salesOrder.Payment_Term__c != null) {
                            //  Payment_Term__r.Payterms_Desc__c
                            var opts2 = [];
                            opts2.push({
                                class: "optionClass",
                                label: salesOrder.ReloadPaymentTerms__c,
                                value: salesOrder.Payment_Term__c,
                            });
                            component.find("payTmdy").set("v.options", opts2);
                        } else if (salesOrder.Maturity_Date__c != null) {
                            component.set("v.isMature", "true");
                            var opts2 = [];
                            opts2.push({
                                class: "optionClass",
                                label: "BR71 INFORMAR VENCIMENTO",
                                value: "BR71 INFORMAR VENCIMENTO",
                            });
                            component.find("payTmDt").set("v.options", opts2);
                        } else {
                            var opts2 = [];
                            opts2.push({
                                class: "optionClass",
                                label: salesOrder.Campaign_Payment_Term_Date__c,
                                value: salesOrder.Campaign_Payment_Term_Date__c,
                            });
                            component.find("payTmDt").set("v.options", opts2);
                        }

                        flag = true;
                        // alert(component.find("structCmp").get("v.value"));
                        //alert(salesOrder.Campaign_Type__c);
                        //console.log('a.getReturnValue().Currency_Brazil__c)'+a.getReturnValue().Currency_Brazil__c);
                        if (salesOrder.Campaign_Type__c == "Simple") {
                            component.set(
                                "v.selectedCurrency",
                                a.getReturnValue().Currency_Brazil__c
                            );
                            component.set("v.isSimple", true);
                            component.set("v.isStructure", false);
                            component.find("simpCmp").set("v.value", true);
                            var opts = [];
                            opts.push({
                                class: "optionClass",
                                label: a.getReturnValue().Price_Book__r.Name,
                                value: a.getReturnValue().Price_Book__c,
                            });
                            component.find("Campaign").set("v.options", opts);
                        } else if (salesOrder.Campaign_Type__c == "Structured") {
                            console.log(
                                "a.getReturnValue().Currency_Brazil__c)2" +
                                a.getReturnValue().Currency_Brazil__c
                            );
                            var currencyval = a.getReturnValue().Currency_Brazil__c;
                            // console.log('a.getReturnValue().Currency_Brazil__c'+a.getReturnValue().Currency_Brazil__c);
                            component.set("v.isSimple", false);
                            component.set("v.isStructure", true);
                            component.find("structCmp").set("v.value", true);
                            //alert(component.find("structCmp").get("v.value"));

                            var currencyList = component.get("v.currencyList");
                            var opts = [];
                            //Currency
                            opts.push({
                                class: "optionClass",
                                label: $A.get("$Label.c.None"),
                                value: "None",
                            });
                            for (var i = 0; i < currencyList.length; i++) {
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

                            //console.log('a.getReturnValue().Currency_Brazil__c)1'+a.getReturnValue().Currency_Brazil__c);
                            //console.log('currencyList: '+JSON.stringify(currencyList));
                            component.find("currencyOptions").set("v.options", opts);
                            //End
                            //console.log('a.getReturnValue().Currency_Brazil__c)'+a.getReturnValue().Currency_Brazil__c);
                            component.set("v.selectedCurrency", currencyval);

                            var optsCampaign = [];
                            optsCampaign.push({
                                class: "optionClass",
                                label: a.getReturnValue().Price_Book__r.Name,
                                value: a.getReturnValue().Price_Book__c,
                            });
                            component.find("Campaign").set("v.options", optsCampaign);
                        }
                        //component.find("campChk").set("v.disabled",true);
                        component.find("simpCmp").set("v.disabled", true);
                        component.find("structCmp").set("v.disabled", true);
                    } else {
                        //component.find("campChk").set("v.disabled",true);
                        component.set(
                            "v.selectedCurrency",
                            a.getReturnValue().Currency_Brazil__c
                        );

                        /*component.set("v.priceBookId",a.getReturnValue().Price_Book__c);*/
                        //INC0107348: Cancelled Price Book visibility for SP/SOM/SDM/SD on old orders: Sayan(crmconsultant3@upl-ltd.com)
                        var tempPriceBookId = a.getReturnValue().Price_Book__c;
                        component.set("v.priceBookId", tempPriceBookId);
                        var priceBookOption = [];
                        var priceBookName = a.getReturnValue().Price_Book__r.Name;
                        priceBookOption.push({
                            class: "optionClass",
                            label: priceBookName,
                            value: tempPriceBookId,
                        });
                        component.find("priceListOptions").set("v.options", priceBookOption);
                        //Sayan end

                        component.set("v.paymentTerm", salesOrder.ReloadPaymentTerms__c);
                    }

                    var keyAcc = component.get("v.showKeyAccount");
                    //alert('keyAcc>>-->'+keyAcc);
                    if (keyAcc) {
                        if (salesOrder.Key_Account__c == true) {
                            component.find("keyYes").set("v.value", true);
                            component.find("keyNo").set("v.value", false);
                        } else {
                            component.set("v.showSeller", false);
                            component.find("keyYes").set("v.value", false);
                            component.find("keyNo").set("v.value", true);
                        }
                        //alert('keyAcc inside if >>-->'+keyAcc);
                        component.find("keyYes").set("v.disabled", true);
                        component.find("keyNo").set("v.disabled", true);
                    } else {
                        component.set("v.showSeller", false);
                        // component.find("keyYes").set("v.value",false);
                        // component.find("keyNo").set("v.value",true);
                    }
                    // alert('keyAcc inside if >>-->'+keyAcc);

                    //if(salesOrder.Type_of_Order__c=='VENDA NORMAL'){
                    //alert(salesOrder.Directed_Sales__c);
                    if (salesOrder.Directed_Sales__c == true) {
                        //  alert('in yes');
                        component.find("dirSaleYes").set("v.value", true);
                        component.find("dirSaleNo").set("v.value", false);
                    } else if (salesOrder.Directed_Sales__c == false) {
                        //alert('in else');
                        component.find("dirSaleNo").set("v.value", true);
                        component.find("dirSaleYes").set("v.value", false);
                    }
                    component.find("dirSaleYes").set("v.disabled", true);
                    component.find("dirSaleNo").set("v.disabled", true);
                    //}

                    if (salesOrder.Pronutiva__c == true) {
                        // component.find("radio1").set("v.value",'Yes');
                        component.find("radio1").set("v.checked", true);
                        component.find("radio2").set("v.checked", false);
                    } else if (salesOrder.Pronutiva__c == false) {
                        component.find("radio2").set("v.checked", true);
                        component.find("radio1").set("v.checked", false);
                    }

                    //component.find("campChk").set("v.disabled",true);
                    component.find("orderTypeOptions").set("v.disabled", true);
                    component.find("radio1").set("v.disabled", true);
                    component.find("radio2").set("v.disabled", true);

                    var isPunctual = component.get("v.isPunctual");
                    if (isPunctual == true) {
                        component.find("punctualitydisc").set("v.disabled", true);
                    }

                    var custbtn1 = component.find("custitem");

                    if (Array.isArray(custbtn1)) {
                        custbtn1[0].set("v.disabled", true); // search icon id...nik
                    } else {
                        custbtn1.set("v.disabled", true); // search icon id...nik

                    }
                    component.find("itemShip").set("v.disabled", true); // search icon id...nik
                    //   component.find("ExpNumDays").set("v.disabled",true);
                    if (component.find("descYes") !== undefined) {
                        component.find("descYes").set("v.disabled", true);
                    }
                    if (component.find("descNo") !== undefined) {
                        component.find("descNo").set("v.disabled", true);
                    }

                    if (orderType != "ORDEM FILHA") {
                        component.set("v.isChild", false);
                        //alert('is Child'+component.get("v.isChild"));
                    }
                }
                catch (e) {
                    console.log('in catch ', e);
              }}
            );

            if (component.get("v.isStructure")) {
                //alert(component.get("v.isStructure"));
                this.fetchStructureCampaign(
                    component,
                    event,
                    salesOrder.Price_Book__c,
                    salesOrder.Id
                );
            } else {
                //BELOW 3 LINES OF CODE IS FOR IMPACT OF BONIFICATION ORDER BY HARSHIT&ANMOL@WIPRO FOR (US SO-016) ---START

                console.log("Before reloadSOItems ");

                this.reloadSOItems(component);
                this.reloadSubStatus(component);
                this.fetchPriceBookDetails(component);

                this.relatedOrder(component);
                this.relatedOrder1(component);
                this.relatedsorder(component);
            }
            $A.enqueueAction(action);
        }
    },

    // Method call to reload Order Items
    // Gets all Order Line Items against the current Sales Order record
    reloadSubStatus: function (component) {
        var action = component.get("c.getOrderSubStatus");
        if (component.get("v.recordId") != null) {
            action.setParams({
                soId: component.get("v.recordId"),
            });

            action.setCallback(this, function (a) {
                var state = a.getState();
                if (state == "SUCCESS") {
                    component.set("v.orderSubStatus", a.getReturnValue());
                    //console.log('orderItems: '+JSON.stringify(a.getReturnValue()));
                } else {
                    //var toastMsg = $A.get("$Label.c.Error_while_reloading_Order_Items");
                    //this.showErrorToast(component, event, toastMsg);
                }
            });
            $A.enqueueAction(action);
        }
    },
    //SCTASK0340391 Account search button check
    getCreatedDate: function (component) {
        var action = component.get("c.getCreatedDate");

        if (component.get("v.recordId") != null) {
            action.setParams({
                soId: component.get("v.recordId"),
            });

            action.setCallback(this, function (a) {
                var state = a.getState();
                if (state == "SUCCESS") {
                    console.log("The created Date getCreatedDate");
                    component.set("v.orderCreatedDate", a.getReturnValue());
                    //console.log('orderItems: '+JSON.stringify(a.getReturnValue()));
                    var orderCreatedDate = component.get("v.orderCreatedDate");

                    //alert('created dateee: '+JSON.stringify(a.getReturnValue()));
                    //if(orderCreatedDate!=null){
                    if (
                        JSON.stringify(a.getReturnValue()) != null ||
                        JSON.stringify(a.getReturnValue()) != undefined
                    ) {
                        //alert('***');
                        component.set("v.orderflagtest", true);
                        //component.set("v.orderflag11",true);

                        //alert(component.get("v.orderflagtest"));
                    } else {
                        component.set("v.orderflagtest", false);
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    //CREATED METHOD FOR INVENTORY CONTROL OBJECT BY HARSHIT&ANMOL@WIPRO FOR (US IU-001) START
    inventory: function (component, event, helper) {
        var action = component.get("c.getInventory");
        //var brandMap = new Map();
        //var profileName = component.get("v.user.Profile.Name");
        //var isSimulated = component.get("v.isSimulated");
        //var dist_brand = 0;
        var orderItemList = component.get("v.orderItemList");




        action.setParams({
            soId: component.get("v.recordId")
        });

        action.setCallback(this, function (a) {
            var state = a.getState();
            console.log('inventory watch', a.toString());
            if (state == "SUCCESS") {
                component.set("v.inventory", a.getReturnValue());
                //this.updateRowCalculations(component, event);
                var newSalesOrder1 = component.get("v.inventory");
                component.set("v.inventory", newSalesOrder1);
                console.log('inventory*************' + JSON.stringify(newSalesOrder1));

                /* var flag = component.get("v.flag3");
               
               for (var idx=0; idx < orderItemList.length; idx++) {     
                   for(var i = 0; i < newSalesOrder1.length; i++){
                       //var replc = priceDetailList1[i].materialPlnRplcCost;
                       var active = newSalesOrder1[i].inventoryactive;
                       
                       var blockalert = newSalesOrder1[i].inventoryblockalert;
                       var quantity = newSalesOrder1[i].qty;
                       console.log('Inve quantity',quantity);
                       console.log('orderItemList[idx].qty',orderItemList[idx].qty);
                       //var y = String.valueOf(orderItemList[idx].fatDate.getYear());
                       var d = new Date(orderItemList[idx].fatDate);
                       
                       //d = orderItemList[idx].fatDate;
                       let year = d.getFullYear();
                       let textyear = year.toString();
                       console.log('fat year',textyear);
                       if(active== true && blockalert=='Block' && quantity < orderItemList[idx].qty &&  textyear==newSalesOrder1[i].year && orderItemList[idx].productName==newSalesOrder1[i].productname ){
                           
                           //alert('Quantity added is exceeding the Balance Inventory.');
                           console.log('inside if');
                           component.set("v.flag3",true);
                           var toastEvent = $A.get("e.force:showToast");
                           var msg  = "Quantity added is exceeding the Balance Inventory.";
                           var titl  = "Quantity Exceeded";
                           toastEvent.setParams({
                               "title": titl,
                               "type": "error",
                               "message": msg,
                               "duration":'3000'
                           });
                           toastEvent.fire();
                           return;
                           
                       } 
                       
                       
                       
                   }
               }*/



            }
            else if (state === 'ERROR') {
                var errors = a.getError();
                console.log('Error', errors[0].message);
            }
        });
        $A.enqueueAction(action);

    },

    //---END


    //CREATED METHOD FOR IMPACT OF BONIFICATION ORDER BY HARSHIT&ANMOL@WIPRO FOR (US SO-016) ---START
    relatedOrder: function (component, event, helper) {
        var action = component.get("c.relatedOrder");
        var brandMap = new Map();
        var profileName = component.get("v.user.Profile.Name");
        var isSimulated = component.get("v.isSimulated");
        var dist_brand = 0;

        if (component.get("v.recordId") != null) {
            action.setParams({
                soId: component.get("v.recordId"),
            });

            action.setCallback(this, function (a) {
                var state = a.getState();
                console.log("a", a.toString());
                if (state == "SUCCESS") {
                    component.set("v.impact", a.getReturnValue());
                    this.updateRowCalculations(component, event);
                    var newSalesOrder1 = component.get("v.impact");
                    console.log(
                        "helper newSalesOrder1*************" +
                        JSON.stringify(newSalesOrder1)
                    );

                    var new1 = component.get("v.totalgross");
                    var new2 = component.get("v.totalgrossBoni");

                    for (var i = 0; i < newSalesOrder1.length; i++) {
                        //var replc = priceDetailList1[i].materialPlnRplcCost;
                        var curr =
                            newSalesOrder1[newSalesOrder1.length - 1].totalgrossproper;
                        var unitValueBRL1 =
                            newSalesOrder1[newSalesOrder1.length - 1].totalgrossproBoniper;
                    }

                    component.set("v.totalgross", curr);
                    component.set("v.totalgrossBoni", unitValueBRL1);

                    if (isSimulated == false && profileName != "Brazil Sales Person") {
                        //... added by Nik CR106.....on 08/11/2019...

                        component.set("v.showReplaceAmnt", true);
                    }
                } else {
                    var toastMsg = $A.get("$Label.c.Error_while_reloading_Order_Items");
                    this.showErrorToast(component, event, toastMsg);
                }
            });
            $A.enqueueAction(action);
        }
    },

    //--END

    //CREATED METHOD FOR IMPACT OF BONIFICATION ORDER BY HARSHIT&ANMOL@WIPRO FOR (US SO-016) ---START

    relatedOrder1: function (component, event, helper) {
        var action = component.get("c.relatedOrder1");
        var brandMap = new Map();
        var profileName = component.get("v.user.Profile.Name");
        var isSimulated = component.get("v.isSimulated");
        var dist_brand = 0;

        if (component.get("v.recordId") != null) {
            action.setParams({
                soId: component.get("v.recordId")
            });

            action.setCallback(this, function (a) {
                var state = a.getState();
                console.log("a", a.toString());
                if (state == "SUCCESS") {
                    component.set("v.impact", a.getReturnValue());
                    this.updateRowCalculations(component, event);
                    var newSalesOrder1 = component.get("v.impact");
                    console.log(
                        "helper newSalesOrder1*************" +
                        JSON.stringify(newSalesOrder1)
                    );

                    /*var new1 = component.get("v.totalgross");
                       var new2 = component.get("v.totalgrossBoni");
        
                        for(var i = 0; i < newSalesOrder1.length; i++){
                           //var replc = priceDetailList1[i].materialPlnRplcCost;
                           var curr = newSalesOrder1[newSalesOrder1.length-1].totalgrossproper;
                           var unitValueBRL1 = newSalesOrder1[newSalesOrder1.length-1].totalgrossproBoniper;
                        
                            
                        }
                       
                       component.set("v.totalgross",curr);
                       component.set("v.totalgrossBoni",unitValueBRL1);
        
                        */

                    if (isSimulated == false && profileName != "Brazil Sales Person") {
                        //... added by Nik CR106.....on 08/11/2019...

                        component.set("v.showReplaceAmnt", true);
                    }
                } else {
                    var toastMsg = $A.get("$Label.c.Error_while_reloading_Order_Items");
                    this.showErrorToast(component, event, toastMsg);
                }
            });
            $A.enqueueAction(action);
        }
    },

    //--END

    //CREATED METHOD TO GIVE BONIFICATION RELATED ORDER BY HARSHIT&ANMOL@WIPRO FOR (US SO-012) ---START

    relatedsorder: function (component) {
        var action = component.get("c.getrelatedSalesOrder");
        var brandMap = new Map();
        var profileName = component.get("v.user.Profile.Name");
        var isSimulated = component.get("v.isSimulated");
        var dist_brand = 0;

        if (component.get("v.recordId") != null) {
            action.setParams({
                soId: component.get("v.recordId"),
            });

            action.setCallback(this, function (a) {
                var state = a.getState();
                console.log("a", a.toString());
                if (state == "SUCCESS") {
                    component.set("v.newSalesOrder1", a.getReturnValue());
                    this.updateRowCalculations(component, event);
                    var newSalesOrder1 = component.get("v.newSalesOrder1");
                    console.log(
                        "relatedsorder*************" + JSON.stringify(newSalesOrder1)
                    );
                    /*if(isSimulated == false && profileName == "Brazil Sales District Manager"){    //... commented by Nik CR106.....on 08/11/2019...
                           var orderItemList = component.get("v.orderItemList");
                           
                           for (var idx=0; idx < orderItemList.length; idx++) {
                               
                               if(brandMap.has(orderItemList[idx].brand)){
                                   var count = brandMap.get(orderItemList[idx].brand);
                                   count = count+1;
                                   brandMap.set(orderItemList[idx].brand,count);
                               }
                               else{
                                   brandMap.set(orderItemList[idx].brand,1);
                                   dist_brand = dist_brand + 1;
                               }
                           }
        
                           if(dist_brand >= 4){
                               component.set("v.showReplaceAmnt",true); 
                           }
                       }*/
                    if (isSimulated == false && profileName != "Brazil Sales Person") {
                        //... added by Nik CR106.....on 08/11/2019...

                        component.set("v.showReplaceAmnt", true);
                    }
                } else {
                    var toastMsg = $A.get("$Label.c.Error_while_reloading_Order_Items");
                    this.showErrorToast(component, event, toastMsg);
                }
            });
            $A.enqueueAction(action);
        }
    },

    //---END

    // Method call to reload Order Items
    // Gets all Order Line Items against the current Sales Order record
    reloadSOItems: function (component) {
        var action = component.get("c.getSalesOrderItems");
        var brandMap = new Map();
        var profileName = component.get("v.user.Profile.Name");
        var isSimulated = component.get("v.isSimulated");
        var dist_brand = 0;
        if (component.get("v.recordId") != null) {
            action.setParams({
                soId: component.get("v.recordId"),
            });

            action.setCallback(this, function (a) {
                var state = a.getState();
                if (state == "SUCCESS") {
                    component.set("v.orderItemList", a.getReturnValue());
                    this.updateRowCalculations(component, event);
                    var orderItemList = component.get("v.orderItemList");
                    console.log("helper orderItemList" + JSON.stringify(orderItemList));
                    /*changes by ashraf starts here*/
                    for (var i in orderItemList) {
                        let orderItem = orderItemList[i];
                        if (orderItem.unitValueWithInterest) {
                            if (orderItem.totalValueWithInterest) {
                                if (orderItem.unitValueWithInterest > orderItem.totalValueWithInterest) {
                                    if (component.get('v.disableApproveButton') === false) {
                                        var toastEvent = $A.get("e.force:showToast");
                                        toastEvent.setParams({
                                            title: 'Info',
                                            message: 'Present value less than minimum value',
                                            mode: 'sticky'
                                        });
                                        toastEvent.fire();
                                    }

                                    component.set('v.disableApproveButton', true);
                                } else {
                                    component.set('v.disableApproveButton', false);
                                }
                            } else {
                                if (component.get('v.disableApproveButton') === false) {
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        title: 'Info',
                                        message: 'Present value less than minimum value',
                                        mode: 'sticky'
                                    });
                                    toastEvent.fire();
                                }
                                component.set('v.disableApproveButton', true);
                            }
                        }

                    }
                    /*changes by ashraf ends here*/
                    /*if(isSimulated == false && profileName == "Brazil Sales District Manager"){    //... commented by Nik CR106.....on 08/11/2019...
                                var orderItemList = component.get("v.orderItemList");
                                
                                for (var idx=0; idx < orderItemList.length; idx++) {
                                    
                                    if(brandMap.has(orderItemList[idx].brand)){
                                        var count = brandMap.get(orderItemList[idx].brand);
                                        count = count+1;
                                        brandMap.set(orderItemList[idx].brand,count);
                                    }
                                    else{
                                        brandMap.set(orderItemList[idx].brand,1);
                                        dist_brand = dist_brand + 1;
                                    }
                                }
        
                                if(dist_brand >= 4){
                                    component.set("v.showReplaceAmnt",true); 
                                }
                            }*/
                    if (isSimulated == false && profileName != "Brazil Sales Person") {
                        //... added by Nik CR106.....on 08/11/2019...

                        component.set("v.showReplaceAmnt", true);
                    }
                } else {
                    var toastMsg = $A.get("$Label.c.Error_while_reloading_Order_Items");
                    this.showErrorToast(component, event, toastMsg);
                }
            });
            $A.enqueueAction(action);
        }
    },

    // Show Success Toast (Green)
    // Note: Shows a javascript alert in case the component is loaded within a visualforce page
    showToast: function (component, event, toastMsg) {
        var toastEvent = $A.get("e.force:showToast");
        var success = $A.get("$Label.c.Success");
        // For lightning1 show the toast
        if (toastEvent != undefined) {
            //alert('in');
            //fire the toast event in Salesforce1
            toastEvent.setParams({
                title: success,
                mode: "dismissible",
                type: "success",
                message: toastMsg /*,
             messageTemplate: '{0} '+toastMsg+' {1}',
             messageTemplateData: ['Salesforce', {
             url: '/one/one.app?#/sObject/'+recordId+'/view',
             label: ' Click here',}]*/,
            });
            toastEvent.fire();
        } else {
            // otherwise throw an alert
            alert(success + ": " + toastMsg);

            /* sforce.one.showToast({
                             "title": "success!",
                             "message":toastMsg,
                              "type": "success"
                         });/*
                 /* toastEvent.setParams({  
                     title: success,
                     type: 'success',
                     message: toastMsg 
                  });
                  toastEvent.fire();   */
        }
    },

    //Show Error Message Toast (Red)
    // Note: Shows a javascript alert in case the component is loaded within a visualforce page
    showErrorToast: function (component, event, toastMsg) {
        var toastEvent = $A.get("e.force:showToast");
        // var toastEvent = sforce.one.showToast;
        var error = $A.get("$Label.c.Error");
        //Updated by Pradeep Salvi Wipro Regarding Ticket Number : SCTASK0872184;
        if (toastMsg == $A.get("$Label.c.Brazil_Product_Availability")) {
            error = $A.get("$Label.c.PRODUCT_UNAVAILABLE_T");
        }
        // For lightning1 show the toast
        if (toastEvent != undefined) {
            //fire the toast event in Salesforce1
            toastEvent.setParams({
                title: error,
                mode: "dismissible",
                type: "error",
                message: toastMsg,
            });
            toastEvent.fire();
        } else {
            // otherwise throw an alert
            //console.log('toastMsg'+toastMsg);
            /* toastEvent.setParams({
                title: "error!",
                type: 'error',
                message: toastMsg
            });
            toastEvent.fire(); */
            /*sforce.one.showToast({
                             "title": "error!",
                             "message":toastMsg,
                              "type": "error"
                         });*/
            alert(error + ": " + toastMsg);
        }
    },
    showWarningToast: function (component, event, toastMsg) {
        var toastEvent = $A.get("e.force:showToast");
        // var toastEvent = sforce.one.showToast;
        var error = $A.get("$Label.c.Warning");
        // For lightning1 show the toast
        if (toastEvent != undefined) {
            //fire the toast event in Salesforce1
            toastEvent.setParams({
                title: error,
                mode: "dismissible",
                type: "warning",
                message: toastMsg,
            });
            toastEvent.fire();
        } else {
            // otherwise throw an alert
            //console.log('toastMsg'+toastMsg);
            /*toastEvent.setParams({
                    title: "error!",
                    type: 'warning',
                    message: toastMsg
                });
                toastEvent.fire();*/

            /* sforce.one.showToast({
                             "title": "error!",
                             "message":toastMsg,
                              "type": "warning"
                         });*/
            alert(error + ": " + toastMsg);
        }
    },
    closePopUp: function (component) {
        this.toggle(component);
    },

    // Hides all components with in the Modal
    // Used for Account/SOM/Price/Balance
    // Note - Logic behing this method is first we hide all the components and then only unhide the one that is to be visible to the user
    hideAllCmp: function (component) {
        var accountdata = component.find("accountdata1");
        $A.util.addClass(accountdata, "slds-hide");

        var somdata = component.find("somdata1");
        $A.util.addClass(somdata, "slds-hide");

        var pricedata = component.find("pricedata1");
        $A.util.addClass(pricedata, "slds-hide");

        var balancedata = component.find("balancedata1");
        $A.util.addClass(balancedata, "slds-hide");

        var shippingdata = component.find("shiptopartydata1");
        $A.util.addClass(shippingdata, "slds-hide");
    },

    // Method to display Approval/Audit History of the current record
    // All entries are Sorted by Created Date
    fetchApprovalHistory: function (component, soId, status) {
        var action = component.get("c.generateData");

        action.setParams({
            recordId: soId,
        });

        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state == "SUCCESS") {
                var returnValue = JSON.stringify(a.getReturnValue());
                component.set("v.approvalList", a.getReturnValue());

                var enableApproval = component.get("v.approvalList.enableApproval");
                component.set("v.showApproveReject", enableApproval);

                //console.log('enableApproval: '+enableApproval);

                if (enableApproval) {
                    var userId = component.get("v.userId");
                    //console.log('logged in user: '+JSON.stringify(userId));

                    var barterManager = component.get("v.newSalesOrder.BarterManager__c");
                    //console.log('barterManager: '+barterManager);

                    if (barterManager == userId) {
                        component.set("v.disableBarter", false);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },

    // Method to query and display all 'Transaction Logs' from HCI/SAP against a particular record
    fetchErrorHistory: function (component, soId) {
        var action = component.get("c.getErrorHistory");

        action.setParams({
            recordId: soId,
        });

        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state == "SUCCESS") {
                component.set("v.errorList", a.getReturnValue());
            }
        });

        $A.enqueueAction(action);
    },

    // Loads language Map used to replace a set of portuguese characters against there English equivalents
    loadPortugueseMap: function (component) {
        var languageMap = component.get("v.languageMap");

        languageMap.portuguese_map = {
            Á: "A",
            á: "a",
            Â: "A",
            â: "a",
            À: "A",
            à: "a",
            Å: "A",
            å: "a",
            Ã: "A",
            ã: "a",
            Ä: "A",
            ä: "a",
            Æ: " ",
            æ: " ",
            É: "E",
            é: "e",
            Ê: "E",
            ê: "e",
            È: "E",
            è: "e",
            Ë: "E",
            ë: "e",
            Ð: " ",
            ð: " ",
            Í: "I",
            í: "i",
            Î: "I",
            î: "i",
            Ì: "I",
            ì: "i",
            Ï: "I",
            ï: "i",
            Ó: "O",
            ó: "o",
            Ô: "O",
            ô: "o",
            Ò: "O",
            ò: "o",
            Ø: " ",
            ø: " ",
            Õ: "O",
            õ: "o",
            Ö: "O",
            ö: "o",
            Ú: "U",
            ú: "u",
            Û: "U",
            û: "u",
            Ù: "U",
            ù: "u",
            Ü: "U",
            ü: "u",
            Ç: "C",
            ç: "c",
            Ñ: "N",
            ñ: "n",
            Ý: "Y",
            ý: "y",
            '"': " ",
            "<": " ",
            ">": " ",
            "&": " ",
            "®": " ",
            "©": " ",
            Þ: " ",
            þ: " ",
            ß: " ",
            "=": " ",
        };
        component.set("v.languageMap", languageMap);
    },

    // Get Business Rule of the seller
    // If Business Rule for a particular seller does not exist, assign default business rule for 'Sales Person'
    fetchBusinessRule: function (component, userId) {
        console.log("The Spinner fetchBusinessRule");
        var action = component.get("c.getBusinessRule");
        var soId = component.get("v.recordId");

        action.setParams({
            soId: soId,
            loggedInUser: userId
        });

        // show spinner to true on click of a button / onload
        component.set("v.showSpinner", true);

        action.setCallback(this, function (a) {
            // on call back make it false ,spinner stops after data is retrieved
            component.set("v.showSpinner", false);

            var state = a.getState();
            if (state == "SUCCESS") {
                var returnValue = a.getReturnValue();
                //console.log('returnValue: '+JSON.stringify(returnValue));
                if (soId == null) {
                    try {
                        //component.set("v.newSalesOrder.Business_Rule__c", returnValue.Associate_Group__r.Business_Rule__c);
                        component.set(
                            "v.businessRule.Taxes__c",
                            returnValue.Associate_Group__r.Business_Rule__r.Taxes__c
                        );
                        component.set(
                            "v.businessRule.Freight__c",
                            returnValue.Associate_Group__r.Business_Rule__r.Freight__c
                        );
                    } catch (err) {
                        var orderFields = component.get("v.orderFields");

                        var defaultRule = orderFields.defaultRule;
                        //console.log('defaultRule: '+JSON.stringify(defaultRule));

                        //component.set("v.newSalesOrder.Business_Rule__c", defaultRule.Id);
                        component.set("v.businessRule.Taxes__c", defaultRule.Taxes__c);
                        component.set("v.businessRule.Freight__c", defaultRule.Freight__c);

                        //console.log('Business Rule not found: '+err);
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
    fetchSeller: function (component) {
        console.log("The fetchSeller");
        var action = component.get("c.getSeller");
        var opts = [];
        opts.push({
            class: "optionClass",
            label: $A.get("$Label.c.None"),
            value: "None",
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state == "SUCCESS") {
                var sellerList = a.getReturnValue();
                console.log("fetchSeller");

                for (var i = 0; i < sellerList.length; i++) {
                    var str = sellerList[i];
                    var splitValues = str.split("*");
                    opts.push({
                        class: "optionClass",
                        label: splitValues[0],
                        value: splitValues[1],
                    });
                }
                console.log('@@@@@@@@@@@@@'+JSON.stringify(opts));
                //Below 9 lines of code added by Harshit@wipro
                var iskeyaccount = component.get("v.showKeyAccount");
                if (iskeyaccount) {
                    var yes1 = component.find("keyYes").get("v.value");
                    var no = component.find("keyNo").get("v.value");
                    if (yes1 == true) {
                        component.set("v.showSeller", true);
                        component.find("sellerOptions").set("v.options", opts);
                    }
                    if (no == true) {
                        component.set("v.showSeller", false);
                    }
                }
                var pricebooktype = component.get("v.SelectPriceBook");
                console.log("pricebooktype12" + pricebooktype);
                var profileName = component.get("v.user.Profile.Name");
                console.log("profileName" + profileName);
                if (
                    (profileName == "Brazil Sales District Manager" &&
                        pricebooktype == "--None--") ||
                    profileName == "Brazil Barter Manager" || profileName == "Brazil Sales Office Manager"    //Updated for RITM0490875  GRZ(Dheeraj Sharma) 13-01-2023 
                ) {
                    console.log("profileName111" + profileName);
                    console.log("opts" + JSON.stringify(opts));
                    component.set("v.showSeller", true);
                    component.find("sellerOptions").set("v.options", opts);
                    console.log("pricebooktype13" + pricebooktype);
                }
                console.log("profileName1" + profileName);
            }
        });
        $A.enqueueAction(action);
    },
    // GetPriceListVal by Ankita@wipro
    getPriceListVal: function (component, event, isSimulated) {
        console.log("The Spinner getPriceListVal");

        var isAvec = component.get("v.isAvec");
        var isKit = component.get("v.isKit");
        var isStructure = component.get("v.isStructure");
        var custid = component.get("v.customerId");
        var ordertype = component.get("v.orderType");

        console.log('isAvec' + isAvec);
        console.log('isStructure' + isStructure);
        console.log('custid' + custid);
        console.log('ordertype' + ordertype);


        console.log("The spinner getPriceListVal1");
        component.set("v.showSpinner", true);
        console.log(
            "The spinner getPriceListVal2",
            component.set("v.showSpinner", true)
        );
        var opts = [];
        var keyAccount = false;
        if (component.get("v.newSalesOrder.Key_Account__c")) {
            keyAccount = true;
        }
        var action = component.get("c.getPriceListValues");

        //Added by GRZ(Nikhil Verma) for INC0385117 modified 06-10-2022
        var sellerId = component.get("v.selectedUser");
        console.log('sellerId' + sellerId);

        if (component.get("v.user.Profile.Name") == 'Brazil Sales District Manager') {
            sellerId = component.get("v.customerRegionForSDM");
        }
        // Added below if by GRZ(Javed) for RITM0490875 modified 03-02-2023-->
        if (component.get("v.user.Profile.Name") == 'Brazil Sales Office Manager') {
            sellerId = component.get("v.customerRegionForSOM");
        }

        //------End GRZ(Nikhil Verma) for INC0385117----------
        console.log('isAvec' + isAvec);
        console.log('isStructure' + isStructure);
        console.log('custid' + custid);
        console.log('ordertype' + ordertype);
        console.log('keyAccount' + keyAccount);
        console.log('sellerId' + sellerId);

        action.setParams({
            keyAccount: keyAccount,
            sellerId: sellerId, //Added by GRZ(Nikhil Verma) for INC0385117 modified 06-10-2022
            isSimulated: isSimulated,
            avec: isAvec,
            custid: custid,
            ordertype: ordertype,
            isStructure: isStructure,
            isKit: isKit
        });
        action.setCallback(this, function (response) {
            console.log("The spinner getPriceListVal2 false");
            component.set("v.showSpinner", false);
            var state = response.getState();
            var toastMsg = "";
            var flag = response.getReturnValue();
            console.log("res**", response.getReturnValue());
            console.log("resstate**", response.getState());
            if (state == "SUCCESS") {
                //var returnValue = response.getReturnValue();
                console.log("pricelist**", response.getReturnValue());
                //component.set("v.priceBookList",response.getReturnValue());
                //var isSimulated = component.get("v.isSimulated");

                component.set("v.orderFields.priceList", response.getReturnValue());
                if (ordertype != "ORDEM FILHA" && ordertype != "BONIFICAÇÃO") {
                    component.set("v.selectedCurrency", "None");
                    component.set("v.priceBookId", "None");
                }
            } else {
                console.log("TestResError**", response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    getOrderFields: function (component, event, isSimulated) {
        console.log("The ShowSpinner getPriceListVal");
        // show spinner to true on click of a button / onload
        //alert('helper');
        var isAvec = component.get("v.isAvec");
        var isKit = component.get("v.isKit");
        var custid = component.get("v.customerId");
        var campChk = component.get("v.CampaignCheck");
        component.set("v.showSpinner", true);
        var ordertype = component.get("v.orderType");
        var keyAccount = false;
        if (component.get("v.newSalesOrder.Key_Account__c")) {
            keyAccount = true;
        }
        var action = component.get("c.getOrderFields");
        var opts = [];

        //Added by GRZ(Nikhil Verma) for INC0385117 modified 06-10-2022
        var sellerId = component.get("v.selectedUser");
        if (component.get("v.user.Profile.Name") == 'Brazil Sales District Manager') {
            sellerId = component.get("v.customerRegionForSDM");
        }
        // Added below if by GRZ(Javed) for RITM0490875 modified 03-02-2023-->
        if (component.get("v.user.Profile.Name") == 'Brazil Sales Office Manager') {
            sellerId = component.get("v.customerRegionForSOM");
        }
        console.log("getOrderFields seller id%%%%" + sellerId);

        //------End GRZ(Nikhil Verma) for INC0385117----------

        action.setParams({
            keyAccount: keyAccount,
            sellerId: sellerId, //Added by GRZ(Nikhil Verma) for INC0385117 modified 06-10-2022
            isSimulated: isSimulated,
            avec: isAvec,
            custid: custid,
            isKit: isKit
        });
        //action.setStorable();
        action.setCallback(this, function (a) {
            // on call back make it false ,spinner stops after data is retrieved
            component.set("v.showSpinner", false);
            console.log("The SpiinerShow", component.get("v.showSpinner"));
            var state = a.getState();

            if (state == "SUCCESS") {
                console.log("The getOrderFields");
                var returnValue = a.getReturnValue();
                component.set("v.orderFields", returnValue);

                if (returnValue.hasDefaultRules) {
                    var orderTypeList = returnValue.orderTypeList;
                    var paymentMethodList = returnValue.paymentMethodList;
                    var currencyList = returnValue.currencyList;
                    var incoTermsList = returnValue.incoTermsList;
                    var culturalDescList = returnValue.culturalDescList;
                    var CancellationReasonOptions = returnValue.CancellationReasonOptions;//added by tanuj 6feb2023

                    component.set("v.user", returnValue.userObj);
                    component.set("v.userId", returnValue.userObj.Id);
                    component.set("v.orderTypeList", orderTypeList);
                    component.set("v.currencyList", currencyList);
                    console.log('currencyList@@@@@:' + component.get("v.currencyList"));
                    component.set("v.CancellationReasonOptions", CancellationReasonOptions);//added by tanuj 6 feb 2023
                    var profileName = component.get("v.user.Profile.Name");

                    if (returnValue.userObj.Show_List_Value__c == true) {
                        component.set("v.showListVal", true);
                    }

                    component.set("v.adminMPTParameter", returnValue.adminparameters); // SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022......

                    var isSimulated = component.get("v.isSimulated");
                    var recordId = component.get("v.recordId");

                    //Show Seller to SDM or if 'Simulated Order'
                    //Hide Draft Button for SDM or if 'Simulated Order'

                    /*  if(profileName=='Brazil Sales Office Manager' || profileName=='Brazil Sales District Manager'){        // added by Nik on 19/07/2019 for CR92....
                              component.set("v.showLedgerReplacement",true);
                              
                           }*/

                    if (isSimulated == true) {
                        component.set("v.recordType", "Simulation");

                        if (profileName == 'Brazil Sales Office Manager' || profileName == 'Brazil Sales District Manager') {  // commented by Nik on 08/11/2019 for CR106....       // added by Nik on 19/07/2019 for CR92....
                            component.set("v.showLedgerReplacement", true);                                       //Updated for INC0445658  GRZ(Dheeraj Sharma) 03-02-2023 
                            component.set("v.showCultrBrand", true);

                        }

                        if (profileName != "Brazil Sales Person") {
                            // added by Nik on 08/11/2019 for CR106....
                            component.set("v.showLedgerReplacement", true);
                            //  component.set("v.showCultrBrand", false);      //Updated for INC0445658  GRZ(Dheeraj Sharma) 03-02-2023
                        }
                    } else {
                        // else block added by Nik on 08/11/2019 for CR106....

                        if (profileName != "Brazil Sales Person") {
                            // added by Nik on 08/11/2019 for CR106....
                            component.set("v.showLedgerReplacement", true);
                            component.set("v.showReplaceAmnt", true);
                        }
                    }
                    //|| isSimulated
                    //if(isSimulated == true){
                    if (
                        profileName == "Brazil Sales Office Manager" ||
                        profileName == "Brazil Sales District Manager"
                    ) {
                        if (!recordId && isSimulated) {
                            //Comment above condition & uncomment below condition if SDM & SOM require Save as Draft feature
                            //if((recordId==null || recordId==undefined || recordId=='') && (isSimulated)){

                            component.set("v.showSaveDraft", false);
                            component.set("v.showSeller", true);
                            console.log("The Fetch seller 1799");
                            // Added Below if by GRZ(Javed) for RITM0490875 modified 03-02-2023-->
                            if (!component.get("v.selectedUser")) {
                                this.fetchSeller(component);
                            }
                            console.log("The Fetch seller 1801");
                        }
                    } else if (profileName == "Brazil Sales Person") {
                        if (!recordId && isSimulated) {
                            component.set("v.showSaveDraft", false);
                            component.set("v.showSeller", false);
                        }
                    }

                    if (
                        profileName == "Brazil Sales Office Manager" ||
                        profileName == "Brazil Sales District Manager"
                    ) {
                        component.set("v.showSeller", true);
                        // Added Below if by GRZ(Javed) for RITM0490875 modified 03-02-2023-->
                        if (!component.get("v.selectedUser")) {
                            this.fetchSeller(component);
                        }
                    } else if (profileName == "Brazil Sales Person") {
                        component.set("v.showSeller", false);
                    }

                    console.log("The Value Is fetchSeller");
                    //Order Type

                    opts.push({
                        class: "optionClass",
                        label: $A.get("$Label.c.None"),
                        value: "None",
                    });
                    for (var i = 0; i < orderTypeList.length; i++) {
                        //If New Simulation and Order Type=='Child' do not add order type in picklist
                        if (isSimulated && orderTypeList[i].search("ORDEM FILHA") == -1) {
                            opts.push({
                                class: "optionClass",
                                label: orderTypeList[i],
                                value: orderTypeList[i],
                            });
                        }
                        //If not simulated record add all order types in picklist
                        else if (!isSimulated) {
                            opts.push({
                                class: "optionClass",
                                label: orderTypeList[i],
                                value: orderTypeList[i],
                            });
                        }
                    }

                    component.find("orderTypeOptions").set("v.options", opts);
                    console.log("The Value Is orderTypeOptions");

                    //End
                    //Payment Method

                    component.set("v.paymentMethodList", paymentMethodList);

                    opts = [];
                    opts.push({
                        class: "optionClass",
                        label: $A.get("$Label.c.None"),
                        value: "None",
                    });
                    for (var i = 0; i < paymentMethodList.length; i++) {
                        var str = paymentMethodList[i];
                        var splitValues = str.split("*");
                        opts.push({
                            class: "optionClass",
                            label: splitValues[0],
                            value: splitValues[1],
                        });
                    }
                    console.log("The Value Is paymentMethodOptions");
                    var paymentopts = component.find("paymentMethodOptions");
                    //console.log();
                    if (paymentopts) {
                        paymentopts.set("v.options", opts);
                    }

                    //console.log("opts: "+JSON.stringify(opts));
                    //End
                    
                    //Currency
                    opts = [];
                    opts.push({
                        class: "optionClass",
                        label: $A.get("$Label.c.None"),
                        value: "None",
                    });

                    //Added Below Condition for RITM0507224  GRZ(Dheeraj Sharma) 15-02-2023
                   

                    for (var i = 0; i < currencyList.length; i++) {
                        if (!recordId ) {

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
                        else {

                            var str = currencyList[i];
                            var splitValues = str.split("*");
                            opts.push({
                                class: "optionClass",
                                label: splitValues[0],
                                value: splitValues[1],
                            });

                        }




                        //opts.push({"class": "optionClass", label: currencyList[i], value: currencyList[i]});
                    }

                    //End Condition for RITM0507224  GRZ(Dheeraj Sharma) 15-02-2023

                    console.log("DsCurrencyop",opts);
                    //console.log('currencyList: '+JSON.stringify(currencyList));
                    component.find("currencyOptions").set("v.options", opts);
                    //End

                    //Inco Terms
                    component.set("v.incoTermList", incoTermsList);

                    opts = [];
                    for (var i = 0; i < incoTermsList.length; i++) {
                        var str = incoTermsList[i];
                        var splitValues = str.split("*");
                        opts.push({
                            class: "optionClass",
                            label: splitValues[0],
                            value: splitValues,
                        });
                    }

                    var incopts = component.find("incoTermOptions");
                    if (incopts) {
                        incopts.set("v.options", opts);
                    }
                    console.log("The Value Is incopts");

                    //End
                    //Cultural Description
                    opts = [];
                    component.set("v.cultureDescList", culturalDescList);
                    component.set("v.cultureDescListCopy", culturalDescList);
                    //End

                    component.set("v.CancellationReasonOptions", CancellationReasonOptions);//added by tanuj 6feb 2023


                    //Show Key Account Radio Buttons
                    component.set("v.showKeyAccount", returnValue.isKeyAccountManager);
                    if (returnValue.isKeyAccountManager) {
                        //this.fetchSeller(component);

                        //Below 9 lines of code added by Harshit@wipro
                        var yes1 = component.find("keyYes").get("v.value");
                        var no = component.find("keyNo").get("v.value");
                        console.log("The Fetch yes1==true");
                        if (yes1 == true) {
                            console.log("The Fetch seller 1899");
                            this.fetchSeller(component);
                            console.log("The Fetch seller 1901");
                        }
                        if (no == true) {
                            component.set("v.showSeller", false);
                        }
                        console.log("if");
                    }
                    //End

                    //Payment Terms Map
                    opts = [];
                    opts.push({
                        class: "optionClass",
                        label: $A.get("$Label.c.None"),
                        value: "None",
                    });
                    //console.log('Payment Terms:'+JSON.stringify(returnValue.paymentTermsMap));
                    var paymentTermsMap = returnValue.paymentTermsMap;
                    //var ptMap = new Map();

                    for (var key in paymentTermsMap) {
                        opts.push({ class: "optionClass", label: key, value: key });
                        //ptMap.set(key, paymentTermsMap[key]);
                    }
                    //console.log('Payment Terms:'+JSON.stringify(opts));
                    component.set('v.paymentTermAfterEmpty', opts);    //Added by GRZ(Butesh Singla) for INC04226660  modified 23-01-2023
                    component.set("v.paymentTermsMap", paymentTermsMap);
                    if (campChk == false && isAvec == false) {
                        component.find("paymentTermOptions").set("v.options", opts);
                    }

                    //End

                    /*
                   * Logic Moved from doInit to here.
                   * To restrict orders if Default Business Rule not Found
                   */
                    // Initialize Valid From Date to Today by default.
                    var today = new Date();

                    var dd = (today.getDate() < 10 ? "0" : "") + today.getDate();
                    var MM =
                        (today.getMonth() + 1 < 10 ? "0" : "") + (today.getMonth() + 1);
                    var yyyy = today.getFullYear(); //today.getFullYear();

                    // Custom date format for ui:inputDate
                    var validFromDate = yyyy + "-" + MM + "-" + dd;

                    component.set("v.newSalesOrder.Valid_From__c", validFromDate);

                    //component.set("v.newSalesOrder.Purchase_Order_Date__c", validFromDate);
                    //component.set("v.newSalesOrder.Maturity_Date__c", validFromDate);

                    //Get ValidTo date from helper method
                    this.getCurrentFiscalYear(component);

                    //Populate PortugueseMap on component load
                    this.loadPortugueseMap(component);
                    console.log("The reloadSO");
                    //Reload existing Order if recordId present
                    this.reloadSO(component, event);
                    //Get List of Holidays from helper method
                    //helper.fetchHolidays(component);

                    /*
                     * End of Logic
                     */
                } else {
                    var toastMsgs = $A.get("$Label.c.Default_Business_Rules_Not_Found");
                    this.showErrorToast(component, event, toastMsgs);
                }
                console.log(" The SpiinerShow End");
                console.log(component.get("v.CampaignCheck"));
                console.log(component.get("v.isAvec"));
                console.log('culture', component.get("v.showCultrBrand"));

            }
        });
        $A.enqueueAction(action);
    },
    getpaymentTerm: function (component, event, helper, campaignId) { },

    // Method is used to set Valid To date to the 31st of Current Fiscal year.
    // Ex 1: Date - 16/02/2018
    // Current Fiscal Year would be - 31/03/2018
    // Ex 2: Date - 20/11/2018
    // Current Fiscal Year would be - 31/03/2019
    getCurrentFiscalYear: function (component) {
        //get current date
        var today = new Date();

        //get current month
        var curMonth = today.getMonth();

        var fiscalYr = "";
        //patch by ganesh
        if (curMonth > 2) {
            //var nextYr1 = (today.getFullYear() + 1).toString();
            //fiscalYr = today.getFullYear().toString() + "-" + nextYr1.charAt(2) + nextYr1.charAt(3);
            fiscalYr = (today.getFullYear() + 1).toString();
        } else {
            //var nextYr2 = today.getFullYear().toString();
            //fiscalYr = (today.getFullYear() - 1).toString() + "-" + nextYr2.charAt(2) + nextYr2.charAt(3);
            fiscalYr = today.getFullYear().toString();
        }
        //patch end
        // Custom date format for ui:inputDate
        var validToDate = fiscalYr + "-" + "03" + "-" + "31";
        component.set("v.newSalesOrder.Valid_To__c", validToDate);
    },

    // Validate Order Items
    // 1. Validates an array or just a single object for required values and sets a boolean to 'false' if even one validation fails
    validateOrder: function (component) {
        var flag = true;
        var payFlag = false;
        var payFlag2 = false;
        var toastMsg = "";
        var isCampgn = component.get("v.CampaignCheck");
        var isAvec = component.get("v.isAvec");

        var orderType = component.get("v.newSalesOrder.Type_of_Order__c");

        if (!isCampgn) {
            var validFrom = component.find("validFrom");
            //console.log('validFrom: '+validFrom);

            if (validFrom) {
                if (!validFrom.get("v.value")) {
                    flag = false;
                    component
                        .find("validFrom")
                        .set("v.errors", [
                            { message: $A.get("$Label.c.Valid_from_is_required") },
                        ]);
                    $A.util.addClass(validFrom, "error");
                }
                //else{
                //    component.find("validFrom").set("v.errors",null);
                //    $A.util.removeClass(validFrom, "error");
                //}
            }
            var validToDate = component.find("validToDate");
            //console.log('validToDate: '+validToDate);

            if (validToDate) {
                if (!validToDate.get("v.value")) {
                    flag = false;
                    component
                        .find("validToDate")
                        .set("v.errors", [
                            { message: $A.get("$Label.c.Valid_to_date_is_required") },
                        ]);
                    $A.util.addClass(validToDate, "error");
                }
                //else{
                //    component.find("validToDate").set("v.errors",null);
                //    $A.util.removeClass(validToDate, "error");
                //}
            }
            if (isAvec == true) {
                var paymentTermOptionsDy = component.find("payTmdy");
                var paymentTermOptionsDt = component.find("payTmDt");
                //console.log('paymentTermOptions: '+payTmDt);

                if (paymentTermOptionsDt) {
                    if (
                        !paymentTermOptionsDt.get("v.value") ||
                        paymentTermOptionsDt.get("v.value") == "None"
                    ) {
                        payFlag = true;

                        //  component.find("payTmDt").set("v.errors",[{message: $A.get("$Label.c.Payment_Terms_is_required")}]);
                        //  $A.util.addClass(paymentTermOptionsDt, "error");
                    } else {
                        payFlag = false;
                    }
                }
                if (paymentTermOptionsDy) {
                    if (
                        !paymentTermOptionsDy.get("v.value") ||
                        paymentTermOptionsDy.get("v.value") == "None"
                    ) {
                        payFlag2 = true; // nik...
                        //  component.find("payTmdy").set("v.errors",[{message: $A.get("$Label.c.Payment_Terms_is_required")}]);
                        //  $A.util.addClass(paymentTermOptionsDy, "error");
                    } else {
                        payFlag2 = false;
                    }
                }

                if (payFlag && payFlag2) {
                    flag = false;
                    component
                        .find("payTmdy")
                        .set("v.errors", [
                            { message: $A.get("$Label.c.Payment_Terms_is_required") },
                        ]);
                    $A.util.addClass(paymentTermOptionsDy, "error");
                } else {
                    paymentTermOptionsDy.set("v.errors", null);
                    $A.util.removeClass(paymentTermOptionsDy, "error");
                }
            } else {
                var paymentTermOptions = component.find("paymentTermOptions");
                //console.log('paymentTermOptions: '+paymentTermOptions);
                if (paymentTermOptions) {
                    if (
                        !paymentTermOptions.get("v.value") ||
                        paymentTermOptions.get("v.value") == "None"
                    ) {
                        flag = false;
                        component
                            .find("paymentTermOptions")
                            .set("v.errors", [
                                { message: $A.get("$Label.c.Payment_Terms_is_required") },
                            ]);
                        $A.util.addClass(paymentTermOptions, "error");
                    }
                    //else{
                    //    component.find("paymentTermOptions").set("v.errors",null);
                    //    $A.util.removeClass(paymentTermOptions, "error");
                    //}
                }

                var priceListOptions = component
                    .find("priceListOptions")
                    .get("v.value");
                //Check Price List Value (Mandatory)
                if (!priceListOptions || priceListOptions == "None") {
                    flag = false;

                    var inputCmp = component.find("priceListOptions");
                    inputCmp.set("v.errors", [
                        { message: $A.get("$Label.c.Price_List_is_required") },
                    ]);
                    $A.util.addClass(inputCmp, "error");
                }
            }

            //else{
            //    component.find("priceListOptions").set("v.errors",null);
            //    $A.util.removeClass(component.find("priceListOptions"), "error");
            //}
        } else {
            var paymentTermOptionsDy = component.find("payTmdy");
            var paymentTermOptionsDt = component.find("payTmDt");
            //console.log('paymentTermOptions: '+payTmDt);

            if (paymentTermOptionsDt) {
                if (
                    !paymentTermOptionsDt.get("v.value") ||
                    paymentTermOptionsDt.get("v.value") == "None"
                ) {
                    payFlag = true;

                    //  component.find("payTmDt").set("v.errors",[{message: $A.get("$Label.c.Payment_Terms_is_required")}]);
                    //  $A.util.addClass(paymentTermOptionsDt, "error");
                } else {
                    payFlag = false;
                }
            }
            if (paymentTermOptionsDy) {
                if (
                    !paymentTermOptionsDy.get("v.value") ||
                    paymentTermOptionsDy.get("v.value") == "None"
                ) {
                    payFlag2 = true; // nik...
                    //  component.find("payTmdy").set("v.errors",[{message: $A.get("$Label.c.Payment_Terms_is_required")}]);
                    //  $A.util.addClass(paymentTermOptionsDy, "error");
                } else {
                    payFlag2 = false;
                }
            }

            if (payFlag && payFlag2) {
                flag = false;
                component
                    .find("payTmdy")
                    .set("v.errors", [
                        { message: $A.get("$Label.c.Payment_Terms_is_required") },
                    ]);
                $A.util.addClass(paymentTermOptionsDy, "error");
            } else {
                paymentTermOptionsDy.set("v.errors", null);
                $A.util.removeClass(paymentTermOptionsDy, "error");
            }

            var priceListOptions2 = component.find("Campaign").get("v.value");
            //Check Price List Value (Mandatory)
            var inputCmp = component.find("Campaign");
            if (!priceListOptions2 || priceListOptions2 == "None") {
                flag = false;

                inputCmp.set("v.errors", [
                    { message: $A.get("$Label.c.Price_List_is_required") },
                ]);
                $A.util.addClass(inputCmp, "error");
            } else {
                inputCmp.set("v.errors", null);
                $A.util.removeClass(inputCmp, "error");
            }
            var isSimulation = component.get("v.isSimulator");
            //alert(component.get("v.isSimulator")==rue);
            if (component.get("v.isSimulator") == true) {
                //alert();
                var file;
                file = component.find("fileId");
                //alert(file.get("v.files"));
                if (file.get("v.files") == null || file.get("v.files").length == 0) {
                    flag = false;
                    file.set("v.validity", { valid: false, badInput: true });
                    file.showHelpMessageIfInvalid();
                }
            }
        }

        /* .........Change added by Nik on 26/08/2019 to resolve line item issue...... */
        var maturityDate = "";
        var ordtp = component.get("v.newSalesOrder.Type_of_Order__c");
        var isMature = component.get("v.isMature");
        //console.log('maturityDate: '+maturityDate);

        if (isMature == "true") {
            if (ordtp == "ORDEM FILHA") {
                maturityDate = component.get("v.newSalesOrder.Maturity_Date__c");
            } else {
                maturityDate = component.get("v.newSalesOrder.Maturity_Date__c");
                console.log('maturityDate==>', maturityDate);
                //maturityDate = component.find("maturityDate").get("v.value");
            }

            if (!maturityDate) {
                flag = false;
                component
                    .find("maturityDate")
                    .set("v.errors", [
                        { message: $A.get("$Label.c.Maturity_date_is_required") },
                    ]);
                $A.util.addClass(component.find("maturityDate"), "error");
            }
        }
        /*...............end..................*/

        /*var maturityDate = component.find("maturityDate");
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
        }*/

        var shipToParty = component.find("itemShipToParty");
        if (shipToParty) {
            if (!shipToParty.get("v.value") || shipToParty.get("v.value") == "None") {
                flag = false;
                component
                    .find("itemShipToParty")
                    .set("v.errors", [
                        { message: $A.get("$Label.c.Ship_To_Party_is_required") },
                    ]);
                $A.util.addClass(shipToParty, "error");
                this.showWarningToast(
                    component,
                    event,
                    $A.get("$Label.c.Ship_To_Party_is_required")
                );
            }
        }
        var orderTypeOptions = component.find("orderTypeOptions");
        if (orderTypeOptions) {
            if (
                !orderTypeOptions.get("v.value") ||
                orderTypeOptions.get("v.value") == "None"
            ) {
                flag = false;
                component
                    .find("orderTypeOptions")
                    .set("v.errors", [
                        { message: $A.get("$Label.c.Order_type_is_required") },
                    ]);
                $A.util.addClass(orderTypeOptions, "error");
            }
            //else{
            //    component.find("orderTypeOptions").set("v.errors",null);
            //    $A.util.removeClass(orderTypeOptions, "error");
            //}
        }

        var currencyOptions = component.find("currencyOptions");
        if (currencyOptions) {
            if (
                !currencyOptions.get("v.value") ||
                currencyOptions.get("v.value") == "None"
            ) {
                flag = false;
                component
                    .find("currencyOptions")
                    .set("v.errors", [
                        { message: $A.get("$Label.c.Currency_not_selected") },
                    ]);
                $A.util.addClass(currencyOptions, "error");
            } else {
                component.find("currencyOptions").set("v.errors", null);
                $A.util.removeClass(currencyOptions, "error");
            }
        }

        var showSeller = component.get("v.showSeller");
        if (showSeller) {
            var sellerOptions = component.find("sellerOptions");
            if (sellerOptions) {
                if (
                    !sellerOptions.get("v.value") ||
                    sellerOptions.get("v.value") == "None"
                ) {
                    flag = false;
                    component
                        .find("sellerOptions")
                        .set("v.errors", [
                            { message: $A.get("$Label.c.Seller_is_required") },
                        ]);
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
        //BELOW IF CONDITION CHANGE FOR  orderType != 'BONIFICAÇÃO' BY HARSHIT&ANMOL@WIPRO  ---START

        if (soName && orderType != "BONIFICAÇÃO") {
            if (!soName.get("v.value")) {
                flag = false;
                component
                    .find("soName")
                    .set("v.errors", [{ message: "Mother Order is required" }]);
                $A.util.addClass(soName, "error");
            } else {
                component.find("soName").set("v.errors", null);
            }
        }

       var customerName = component.find("customerName")[0];      //updated For INC0471148 by GRZ(Dheeraj Sharma) 01-05-2023
        
            if (customerName != undefined) {
                if (!customerName.get("v.value")) {
                    flag = false;
                    component
                        .find("customerName")
                        .set("v.errors", [
                            { message: $A.get("$Label.c.Customer_is_required") },
                        ]);
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
        var poNum = component.find("poNo");      //updated For INC0471148 by GRZ(Dheeraj Sharma) 01-05-2023
        if ($A.util.isArray(poNum)) {
        //console.log('poNo: '+poNum);
            if (poNum[0]) {
                if (!poNum[0].get("v.value")) {
                    flag = false;
                    component
                        .find("poNo")[0]
                        .set("v.errors", [
                            { message: $A.get("$Label.c.Purchase_Order_No_is_required") },
                        ]);
                    $A.util.addClass(poNum[0], "error");
                }
                //else{
                //    component.find("poNo").set("v.errors",null);
                //    $A.util.removeClass(poNo, "error");
                //}
            }
        }else{
            if (poNum) {
                if (!poNum.get("v.value")) {
                    flag = false;
                    component
                        .find("poNo")
                        .set("v.errors", [
                            { message: $A.get("$Label.c.Purchase_Order_No_is_required") },
                        ]);
                    $A.util.addClass(poNum, "error");
                }
                //else{
                //    component.find("poNo").set("v.errors",null);
                //    $A.util.removeClass(poNo, "error");
                //}
            }
        }

        //RITM0355165 - Brazil sales order enhancement to track revenue of cancel order
        var last24MonthsSalesOrderOptions = component.find(
            "last24MonthsSalesOrderOptions"
        );
        if (last24MonthsSalesOrderOptions) {
            if (!last24MonthsSalesOrderOptions.get("v.value")) {
                flag = false;
                component
                    .find("last24MonthsSalesOrderOptions")
                    .set("v.errors", [
                        {
                            message: $A.get(
                                "$Label.c.Please_fill_Sales_order_reference_number"
                            ),
                        },
                    ]);
                $A.util.addClass(last24MonthsSalesOrderOptions, "error");
            }
            //else{
            //    component.find("poNo").set("v.errors",null);
            //    $A.util.removeClass(poNo, "error");
            //}
        }
        //RITM0355165 - Brazil sales order enhancement to track revenue of cancel order// Error Messages

        var poDate = component.find("poDate");               //updated For INC0471148 by GRZ(Dheeraj Sharma) 01-05-2023
        if ($A.util.isArray(poDate)) {
        //console.log('poDate: '+poDate);
            if (poDate[0]) {
                if (!poDate[0].get("v.value")) {
                    flag = false;
                    component
                        .find("poDate")[0]
                        .set("v.errors", [
                            { message: $A.get("$Label.c.Purchase_Order_date_is_required") },
                        ]);
                    $A.util.addClass(poDate[0], "error");
                }
                //else{
                //    component.find("poDate").set("v.errors",null);
                //    $A.util.removeClass(poDate, "error");
                //}
            }
        }else{
                if (poDate) {
                if (!poDate.get("v.value")) {
                    flag = false;
                    component
                        .find("poDate")
                        .set("v.errors", [
                            { message: $A.get("$Label.c.Purchase_Order_date_is_required") },
                        ]);
                    $A.util.addClass(poDate, "error");
                }
                //else{
                //    component.find("poDate").set("v.errors",null);
                //    $A.util.removeClass(poDate, "error");
                //}
            }             
         }

        var isPunctual = component.get("v.isPunctual");
        //console.log('isPunctual: '+isPunctual);
        if (isPunctual) {
            var punctualitydisc = component.find("punctualitydisc");
            //console.log('punctualitydisc: '+punctualitydisc);
            if (punctualitydisc) {
                if (!punctualitydisc.get("v.value")) {
                    flag = false;
                    component
                        .find("punctualitydisc")
                        .set("v.errors", [
                            { message: $A.get("$Label.c.Punctuality_discount_is_required") },
                        ]);
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
    validateOrderItems: function (component) {
        try {
            //FAT Validation Patch
            var today = new Date();
            var dd = (today.getDate() < 10 ? "0" : "") + today.getDate();
            var MM = (today.getMonth() + 1 < 10 ? "0" : "") + (today.getMonth() + 1);
            var yyyy = today.getFullYear();
            //var profileName = component.get("v.orderFields.userObj.Profile.Name"); //......CR92...Nik...
            var profileName = component.get("v.user.Profile.Name");
            var profileflag = true;
            //var profileUnitflag = true;   //......CR92...Nik...
            var isSimulated = component.get("v.isSimulated");

            if (profileName == "Brazil Sales Office Manager") {
                //......CR92...Nik...
                profileflag = false;
            } else if (profileName == "Brazil Sales District Manager") {
                profileflag = true;
            } else if (profileName == "Brazil Sales Person" && isSimulated == true) {
                profileflag = false;
            } else if (
                profileName == "Brazil Barter Manager" &&
                isSimulated == true
            ) {
                //added brazil barter manager Profile condition >> Grazitti(Tanuj)- RITM0333006-8 Aug 2022
                profileflag = false;
            } else {
                profileflag = true;
            }

            /*if(profileName=="Brazil Sales Person" && isSimulated == true){
            profileUnitflag = false;
            }
            else{
            profileUnitflag = true;
            }
            */
            // Custom date format for ui:inputDate
            var currentDate = yyyy + "-" + MM + "-" + dd;
            //End

            var orderItemList = component.get("v.orderItemList");
            var getProductId = component.find("itemproduct");
            console.log(getProductId);
            console.log("getProductId");
            var getFATId = component.find("itemfat");
            var getUnitValueId = component.find("itemunitvalue");
            var getQtyId = component.find("itemqty");
            var getCultureId = component.find("cultureDescOptions");
            var toastMsg = "";
            var flag = true;

            if (orderItemList.length <= 0) {
                console.log(orderItemList.length + "orderItemList.length");
                flag = false;
                //toastMsg = 'Please add items before saving Order';
                //this.showErrorToast(component, event, toastMsg);
          } else if (orderItemList.length > 0) {
                var isProductArray = Array.isArray(getProductId);

                if (isProductArray) {
                    for (var i = 0; i < orderItemList.length; i++) {
                        //Product validaiton
                        if (!getProductId[i].get("v.value")) {
                            component
                                .find("itemproduct")
                            [i].set("v.errors", [
                                { message: $A.get("$Label.c.Product_is_required") },
                            ]);
                            flag = false;
                        } else {
                            component.find("itemproduct")[i].set("v.errors", null);
                        }

                        // FAT Date validaiton
                        if (!getFATId[i].get("v.value")) {
                            component
                                .find("itemfat")
                            [i].set("v.errors", [
                                { message: $A.get("$Label.c.FAT_is_required") },
                            ]);
                            flag = false;
                        } else {
                            //component.find("itemfat")[i].set("v.errors",null);
                            var selectedDate = getFATId[i].get("v.value");

                            var x = new Date(selectedDate);
                            var y = new Date(currentDate);

                            if (selectedDate == "Invalid Date") {
                                var dateString = selectedDate;
                                var dateParts = dateString.split("/");
                                selectedDate = new Date(
                                    dateParts[2],
                                    dateParts[1] - 1,
                                    dateParts[0]
                                );
                                x = new Date(selectedDate);
                            }

                            if (+x <= +y) {
                                component
                                    .find("itemfat")
                                [i].set("v.errors", [
                                    {
                                        message: $A.get(
                                            "$Label.c.FAT_should_be_greater_than_today"
                                        ),
                                    },
                                ]);
                                flag = false;
                            } else {
                                component.find("itemfat")[i].set("v.errors", null);
                            }
                        }
                        if (profileflag == true) {
                            if (getUnitValueId) {
                                // Unit Value validaiton || getUnitValueId[i].get("v.value") == '0'
                                if (!getUnitValueId[i].get("v.value")) {
                                    component
                                        .find("itemunitvalue")
                                    [i].set("v.errors", [
                                        { message: $A.get("$Label.c.Unit_Value_is_required") },
                                    ]);
                                    flag = false;
                                } else {
                                    component.find("itemunitvalue")[i].set("v.errors", null);
                                }
                            }
                        }
                        // Quantity validaiton
                        if (
                            !getQtyId[i].get("v.value") ||
                            getQtyId[i].get("v.value") == "0"
                        ) {
                            component
                                .find("itemqty")
                            [i].set("v.errors", [
                                { message: $A.get("$Label.c.Quantity_is_required") },
                            ]);
                            flag = false;
                        } else {
                            component.find("itemqty")[i].set("v.errors", null);
                        }

                        // Culture Description validaiton if(profileflag == true){ //priya
                        if (profileflag == true) {
                            if (
                                !getCultureId[i].get("v.value") ||
                                getCultureId[i].get("v.value") == "None"
                            ) {
                                //Modified by Deeksha for kit selling Project
                                //component.find("cultureDescOptions")[i].set("v.errors",[{message: $A.get("$Label.c.Culture_is_required")}]);
                                component
                                    .find("cultureDescOptions")
                                [i].set("v.validity", { valid: false, valueMissing: true });
                                component
                                    .find("cultureDescOptions")
                                [i].set(
                                    "v.messageWhenValueMissing",
                                    $A.get("$Label.c.Culture_is_required")
                                );
                                component
                                    .find("cultureDescOptions")
                                [i].showHelpMessageIfInvalid();
                                flag = false;
                            } else {
                                //Modified by Deeksha for kit selling Project
                                //component.find("cultureDescOptions")[i].set("v.errors",null);
                            }
                        }
                    }
                } else {
                    console.log("else" + JSON.stringify(orderItemList));
                    if (!getProductId.get("v.value")) {
                        flag = false;
                        component
                            .find("itemproduct")
                            .set("v.errors", [
                                { message: $A.get("$Label.c.Product_is_required") },
                            ]);
                    } else {
                        component.find("itemproduct").set("v.errors", null);
                    }

                    if (!getFATId.get("v.value")) {
                        flag = false;
                        component
                            .find("itemfat")
                            .set("v.errors", [
                                { message: $A.get("$Label.c.FAT_is_required") },
                            ]);
                    } else {
                        //component.find("itemfat").set("v.errors",null);
                        var selectedDate = getFATId.get("v.value");
                        console.log("**selectedDate: " + selectedDate);

                        var x = new Date(selectedDate);
                        var y = new Date(currentDate);

                        if (x == "Invalid Date") {
                            var dateString = selectedDate;
                            var dateParts = dateString.split("/");
                            selectedDate = new Date(
                                dateParts[2],
                                dateParts[1] - 1,
                                dateParts[0]
                            );
                            x = new Date(selectedDate);
                        }

                        if (+x <= +y) {
                            component
                                .find("itemfat")
                                .set("v.errors", [
                                    {
                                        message: $A.get(
                                            "$Label.c.FAT_should_be_greater_than_today"
                                        ),
                                    },
                                ]);
                            flag = false;
                        } else {
                            component.find("itemfat").set("v.errors", null);
                        }
                    }

                    if (!getQtyId.get("v.value") || getQtyId.get("v.value") == "0") {
                        flag = false;
                        component
                            .find("itemqty")
                            .set("v.errors", [
                                { message: $A.get("$Label.c.Quantity_is_required") },
                            ]);
                    } else {
                        component.find("itemqty").set("v.errors", null);
                    }
                    //  || getUnitValueId.get("v.value") == '0'
                    if (profileflag == true) {
                        if (getUnitValueId) {
                            if (!getUnitValueId.get("v.value")) {
                                flag = false;
                                component
                                    .find("itemunitvalue")
                                    .set("v.errors", [
                                        { message: $A.get("$Label.c.Unit_Value_is_required") },
                                    ]);
                            } else {
                                component.find("itemunitvalue").set("v.errors", null);
                            }
                        }
                    }

                    if (profileflag == true) {
                        if (
                            !getCultureId.get("v.value") ||
                            getCultureId.get("v.value") == "None"
                        ) {
                            flag = false;
                            //Modified by Deeksha for kit selling Project
                            component
                                .find("cultureDescOptions")
                                .set("v.validity", { valid: false, valueMissing: true });
                            component
                                .find("cultureDescOptions")
                                .set(
                                    "v.messageWhenValueMissing",
                                    $A.get("$Label.c.Culture_is_required")
                                );
                            component.find("cultureDescOptions").showHelpMessageIfInvalid();
                            //component.find("cultureDescOptions").set("v.errors",[{message: $A.get("$Label.c.Culture_is_required")}]);
                        } else {
                            //Modified by Deeksha for kit selling Project
                            //component.find("cultureDescOptions").set("v.errors",null);
                        }
                    }
                }
            }
            return flag;
        } catch (err) {
            console.log("$$error: " + err);
        }
    },

    // Method to Validate all Line Items for Balance Qty on Server
    validateSOCServer: function (component, event, status, isRollback) {
        var orderType = component.get("v.newSalesOrder.Type_of_Order__c");

         console.log('isRollback'+isRollback);
        //  alert(JSON.stringify(component.get("v.newSalesOrder")));
        var isValid = this.validateOrder(component);
        var isValidItems = this.validateOrderItems(component);
        if (orderType == "ORDEM FILHA" && isRollback && isValid && isValidItems) {
            //console.log('validateSOCServer Called');
            var orderItemList = component.get("v.orderItemList");
            var priceBookId = component.get("v.newSalesOrder.Price_Book__c");
            var motherOrderId = component.get("v.newSalesOrder.Sales_Order__c");
            var depotCode = component.get("v.selItem.Depot_Code__c");
            var accountState = component.get("v.selItem.Customer_Region__c");
            var orderId = component.get("v.recordId");
            var isSimulated = component.get("v.isSimulated"); //added by Sumit kumar for Ticket No. RITM0518333
            var action = component.get("c.validateQuantitySOC");

            action.setParams({
                priceBookId: priceBookId,
                motherOrderId: motherOrderId,
                depotCode: depotCode,
                accountState: accountState,
                orderId: orderId,
                salesOrderItemString: JSON.stringify(orderItemList),
                isSimulated: isSimulated, //added by Sumit kumar for Ticket No. RITM0518333
            });

            // Create a callback that is executed after
            // the server-side action returns
            action.setCallback(this, function (response) {
                var state = response.getState();

                //console.log('validateSOCServer state: '+state);

                if (state === "SUCCESS") {
                    // console.log("From server: " + response.getReturnValue());

                    var result = response.getReturnValue();

                    if (!result) {
                        console.log("here");
                        //this.validateSOCBeforeSave(component);
                        component.set("v.isValidSOC", true);
                        this.createSalesOrder(component, event, status, isRollback);
                    } else {
                        //console.log("priceList: "+JSON.stringify(result.priceList));
                        var toastMsg =
                            "Quantity exceeded since SOM balance was updated on server for Product/s: " +
                            result.productList +
                            ". Please change the quantity as per updated balance.";
                        this.showErrorToast(component, event, toastMsg);
                        this.fetchServerPriceBookDetails(component, result.priceList);
                    }
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

            // optionally set storable, abortable, background flag here

            $A.enqueueAction(action);
        } else {
            console.log("Call Create salesOrder in validatesoc");
            this.createSalesOrder(component, event, status, isRollback);
        }
    },

    // Method to Validate all Line Items for Balance Qty
    // Used in scenario where SOM is saved as 'Draft' and reloaded after a while and 'Submitted'
    // If entered 'Qty' is more than 'Balance Qty' during 'Resave' or 'Submit' the Validation will fire
    validateSOCBeforeSave: function (component) {
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
            if (priceMap.has(orderItemList[idx].moItemNo)) {
                var priceObj = priceMap.get(orderItemList[idx].moItemNo);
                if (isProductArray) {
                    // console.log('priceObj.balanceQty: '+priceObj.balanceQty);

                    //console.log('priceObj.balanceQty2: '+priceObj.balanceQty2);
                    //console.log('getQtyId[idx].get("v.value"): '+getQtyId[idx].get("v.value"));

                    // Quantity validaiton
                    if (getQtyId[idx].get("v.value") > priceObj.balanceQty2) {
                        component
                            .find("itemqty")
                        [idx].set("v.errors", [
                            {
                                message:
                                    $A.get("$Label.c.Qty_cannot_be_greater_than_SOM_Balance") +
                                    " " +
                                    priceObj.balanceQty2,
                            },
                        ]);
                        flag = false;
                    } else {
                        component.find("itemqty")[idx].set("v.errors", null);
                    }
                } else {
                    //console.log('priceObj.balanceQty : '+priceObj.balanceQty);
                    //console.log('priceObj.balanceQty2: '+priceObj.balanceQty2);
                    // console.log('getQtyId.get("v.value"): '+getQtyId.get("v.value"));

                    if (getQtyId.get("v.value") > priceObj.balanceQty2) {
                        flag = false;
                        component
                            .find("itemqty")
                            .set("v.errors", [
                                {
                                    message:
                                        $A.get("$Label.c.Qty_cannot_be_greater_than_SOM_Balance") +
                                        " " +
                                        priceObj.balanceQty2,
                                },
                            ]);
                    } else {
                        component.find("itemqty").set("v.errors", null);
                    }
                }
            }
        }
        component.set("v.isValidSOC", flag);
    },

    // Create sales order on Save as Draft button.
    createSalesOrder: function (component, event, status, isRollback) {
                             //   alert(isRollback);
        console.log('createSalesOrderBss',isRollback);
        component.set("v.disableSelect", false);
        console.log("disableSelect");
        var orderType = component.get("v.newSalesOrder.Type_of_Order__c");
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
        var action = "";
        //console.log('isValidSOC: '+isValidSOC);

        if (isValid && isValidItems && isValidFAT && isValidSOC && isValidInvoice) {
            var paymentTerm = component.get("v.paymentTerm");
            var toastMsg = "";
            var newSO = component.get("v.newSalesOrder");
            //  console.log('Create Order newSO>>--->'+JSON.stringify(newSO));
            var orderItemList = component.get("v.orderItemList");
            //console.log('orderItemList'+JSON.stringify(orderItemList));
            console.log("newSO: " + JSON.stringify(newSO));

            var isSimulated = component.get("v.isSimulated");
            console.log('isSimulated@@3513-->'+isSimulated);
            if (isSimulated) {
                //Execute to save simulation without flag dialog
                component.set("v.newSalesOrder.Order_Status__c", "Draft");
 console.log('isRollback@@35137-->'+isRollback);
                if (isRollback == true) {
                               
                    //Execute to rollback and check flag status
                    //console.log('Simulated=true isrollback=true newSO>>--->'+JSON.stringify(newSO));
                    action = component.get("c.rollbackSalesOrder");
                    action.setParams({
                        soObj: newSO,
                        salesOrderItemString: JSON.stringify(orderItemList),
                        isSimulated: true,
                        TCforBarterManagerProcess: component.get("v.TCForBarterProcess"), // Added new parameter TCforBarterManagerProcess by GRZ(Nikhil Verma) for RITM0422585 modified 12-09-2022
                    });
                } else if (isRollback == false) {
                    console.log(
                        "Simulated=true isrollback=false newSO>>--->" +
                        JSON.stringify(newSO)
                    );
                    action = component.get("c.saveSalesOrder");
                    action.setParams({
                        soObj: newSO,
                        salesOrderItemString: JSON.stringify(orderItemList),
                        isRollback: false,
                        isSimulated: true,
                        TCforBarterManagerProcess: component.get("v.TCForBarterProcess"), // Added new parameter TCforBarterManagerProcess by GRZ(Nikhil Verma) for RITM0422585 modified 12-09-2022
                    });
                }
            } else if (!isSimulated) {
                if (status == "Submitted") {
                    //  console.log('status'+status);
                    //Execute to save order on Submit button

                    component.set("v.newSalesOrder.Order_Status__c", "Submitted");

                    if (isRollback == false) {
                        //......added By Nik on 12/08/2019
                        component.set("v.disableSelect", true);
                        console.log("disableSelect");
                    }
                } else if (status == "Draft") {
                    //Execute to save as draft without flag check/rollback
                    component.set("v.newSalesOrder.Order_Status__c", "Draft");
                    if (isRollback == false) {
                        //......added By Nik on 12/08/2019
                        component.set("v.disableSelect", true);
                        console.log("disableSelect");
                    }
                }

                if (isRollback == true) {
                    //console.log('Order Line Items added by Nik-----> '+ JSON.stringify(orderItemList));
                    //console.log('Simulated=false isrollback=true newSO>>--->'+JSON.stringify(newSO));
                    console.log('rollbackSalesOrder');
                    console.log('newSO',newSO);            
                    action = component.get("c.rollbackSalesOrder");
                    action.setParams({
                        soObj: newSO,
                        salesOrderItemString: JSON.stringify(orderItemList),
                        isSimulated: false,
                        TCforBarterManagerProcess: component.get("v.TCForBarterProcess"), // Added new parameter TCforBarterManagerProcess by GRZ(Nikhil Verma) for RITM0422585 modified 12-09-2022
                    });
                } else if (isRollback == false) {
                    //console.log('Simulated=false isrollback=false newSO>>--->'+JSON.stringify(newSO));
                    //console.log('SalesOrderItems>>---->'+JSON.stringify(orderItemList));
                    action = component.get("c.saveSalesOrder");
                    action.setParams({
                        soObj: newSO,
                        salesOrderItemString: JSON.stringify(orderItemList),
                        isRollback: false,
                        isSimulated: false,
                        TCforBarterManagerProcess: component.get("v.TCForBarterProcess"), // Added new parameter TCforBarterManagerProcess by GRZ(Nikhil Verma) for RITM0422585 modified 12-09-2022
                    });
                }
            }
            // show spinner to true on click of a button / onload
            component.set("v.showSpinner", true);

            action.setCallback(this, function (a) {
                // on call back make it false ,spinner stops after data is retrieved
                component.set("v.showSpinner", false);
                console.log(
                    "The SpiinerShow createSalesOrder",
                    component.get("v.showSpinner")
                );
                var state = a.getState();

                if (state == "SUCCESS") {
                    //toastMsg = "Sales Order created successfully for "+JSON.stringify(a.getReturnValue().Sold_to_Party__r.Name);

                    var recordId = a.getReturnValue().soObj.Id;
                               console.log('recordId',recordId);            
                    component.set("v.recordId", recordId);
                    var orderStatus = a.getReturnValue().soObj.Order_Status__c;
                    //alert(a.getReturnValue().soObj.Campaign_Type__c);
                    component.set("v.newSalesOrder", a.getReturnValue().soObj);
                    component.set("v.orderSubStatus", a.getReturnValue().orderSubStatus);
                    //console.log('a.getReturnValue().orderSubStatus'+JSON.stringify(a.getReturnValue()));

                    if (isRollback == false) {
                        component.set("v.sfdcOrderNo", a.getReturnValue().sfdcOrderNo);
                        //console.log('Rollback False Order No: '+a.getReturnValue().sfdcOrderNo);
                        //console.log('Rollback False Order Id: '+a.getReturnValue().soObj.Id);
                    }
                    //console.log('a.getReturnValue().soObj.Flag_Status__c'+a.getReturnValue().soObj.Flag_Status__c);
                    //component.set("v.flag",a.getReturnValue().soObj.Flag_Status__c);
                    var flagImg = "$Resource." + a.getReturnValue().soObj.Flag_Status__c;
                    var flagIm = a.getReturnValue().soObj.Flag_Status__c;
                    console.log("flagIm: " + flagIm);

                    component.set("v.flag", $A.get(flagImg));
                    component.set(
                        "v.flagMessage",
                        a.getReturnValue().soObj.Flag_Message__c
                    );

                    //component.set("v.selectedCurrency",a.getReturnValue().soObj.Currency_Brazil__c);
                    //component.set("v.priceBookId",a.getReturnValue().soObj.Price_Book__c);
                    //console.log('Class value of Order Type>>----->'+a.getReturnValue().soObj.Type_of_Order__c);
                    component.set(
                        "v.orderType",
                        a.getReturnValue().soObj.Type_of_Order__c
                    );
                    //alert('Order Type Value>>--->'+component.get("v.orderType"));
                    var errorMessage = a.getReturnValue().soObj.ErrorMessage__c;
                    //console.log('error msg:'+errorMessage);

                    var defType = "pending";

                    if (errorMessage != "") {
                        toastMsg = errorMessage;
                        this.showErrorToast(component, event, toastMsg);
                    } else {
                        //If User is owner of record & Order is a 'Simulation' or 'Draft' Order then enable delete
                        if (
                            (isSimulated ||
                                a.getReturnValue().soObj.Order_Status__c == "Draft") &&
                            isRollback == false
                        ) {
                            component.set("v.showDelete", true);
                        }
                        // alert(isSimulated);
                        if (isSimulated) {
                            toastMsg = $A.get("$Label.c.Simulation_Saved_Successfully");
                            //component.set("v.disableThis",true);

                            if (isRollback == false) {
                                //Execute to save order on Submit button
                                this.toggleConfirmDialog(component);
                                this.showToast(component, event, toastMsg);

                                //Start
                                component.set("v.showOnReLoad", true);
                                component.set("v.showSAPNo", false);
                                component.set("v.showRaiseOrder", false);

                                var orderItemList = a.getReturnValue().soiList;

                                if (orderItemList) {
                                    component.set("v.orderItemList", orderItemList);
                                    this.updateRowCalculations(component, event);
                                }

                                var approvalList = a.getReturnValue().approvalList;

                                if (approvalList) {
                                    component.set("v.approvalList", approvalList);
                                }

                                var errorList = a.getReturnValue().errorList;
                                if (errorList) {
                                    component.set("v.errorList", errorList);
                                }
                                //End

                                //var fullUrl = '';
                                //fullUrl = '/apex/simulationOrderEnhancedView';
                                //this.gotoURL(fullUrl);
                                //this.navigateToComponent(component);
                            } else if (isRollback == true) {
                                var orderItemList = a.getReturnValue().soiList;
                                if (orderItemList) {
                                    component.set("v.orderItemList", orderItemList);
                                    this.updateRowCalculations(component, event);
                                }
                                //Execute to rollback and check flag status on Submit button
                                this.toggleConfirmDialog(component);
                            }
                        } else {
                            if (status == "Submitted") {
                                toastMsg = $A.get("$Label.c.Sales_Order_Created_Successfully");
                                if (isRollback == false) {
                                    //Execute to save order on Submit button
                                    this.toggleConfirmDialog(component);
                                    this.showToast(component, event, toastMsg);

                                    var profileName = component.get(
                                        "v.orderFields.userObj.Profile.Name"
                                    );
                                    var fullUrl = "";
                                    var defType = "";
                                    //console.log('flagIm'+flagIm+'profileName'+profileName);
                                    if (profileName == "Brazil Sales Person") {
                                        if (flagIm == "like") {
                                            defType = "approved";
                                        } else if (
                                            flagIm == "midlike" ||
                                            flagIm == "dislike" ||
                                            flagIm == "dislike_black"
                                        ) {
                                            defType = "pending";
                                        }
                                        fullUrl =
                                            "/apex/BrazilEnhancedListForSP?defType=" + defType;
                                        this.gotoURL(component, fullUrl);
                                    } else if (profileName == "Brazil Sales District Manager") {
                                        if (flagIm == "like") {
                                            defType = "approved";
                                        } else if (
                                            flagIm == "midlike" ||
                                            flagIm == "dislike" ||
                                            flagIm == "dislike_black"
                                        ) {
                                            defType = "pending";
                                        }
                                        fullUrl =
                                            "/apex/BrazilEnhancedListForSDM?defType=" + defType;
                                        this.gotoURL(component, fullUrl);
                                    } else if (profileName == "Brazil Sales Office Manager") {
                                        if (flagIm == "like") {
                                            defType = "approved";
                                        } else if (
                                            flagIm == "midlike" ||
                                            flagIm == "dislike" ||
                                            flagIm == "dislike_black"
                                        ) {
                                            defType = "pending";
                                        }
                                        fullUrl =
                                            "/apex/BrazilEnhancedListForSOM?defType=" + defType;
                                        this.gotoURL(component, fullUrl);
                                    }
                                } else if (isRollback == true) {
                                    var orderItemList = a.getReturnValue().soiList;
                                    if (orderItemList != null && orderItemList != undefined) {
                                        component.set("v.orderItemList", orderItemList);
                                        this.updateRowCalculations(component, event);
                                    }
                                    //Execute to rollback and check flag status on Submit button
                                    this.toggleConfirmDialog(component);
                                }
                            } else if (status == "Draft") {
                                toastMsg = $A.get(
                                    "$Label.c.Sales_Order_Draft_Saved_Successfully"
                                );

                                if (isRollback == false) {
                                    //Execute to save order on Draft button
                                    this.toggleConfirmDialog(component);

                                    //Execute to save as draft without flag check/rollback
                                    this.showToast(component, event, toastMsg);
                                    component.set("v.showOnReLoad", true);

                                    var orderItemList = a.getReturnValue().soiList;
                                    if (orderItemList != null && orderItemList != undefined) {
                                        component.set("v.orderItemList", orderItemList);
                                        this.updateRowCalculations(component, event);
                                    }

                                    var approvalList = a.getReturnValue().approvalList;
                                    if (approvalList != null && approvalList != undefined) {
                                        component.set("v.approvalList", approvalList);
                                    }

                                    var errorList = a.getReturnValue().errorList;
                                    if (errorList != null && errorList != undefined) {
                                        component.set("v.errorList", errorList);
                                    }

                                    //this.fetchPriceBookDetails(component);

                                    /*var orderType = a.getReturnValue().soObj.Type_of_Order__c;
                                                                     
                                                                     if(orderType=="CONTRATO MÃE"){
                                                                         component.set("v.recordId",a.getReturnValue().soObj.Id);
                                                                         component.set("v.isMother",true);
                                                                     }*/

                                    //this.navigateToComponent(component);
                                } else if (isRollback == true) {
                                    var orderItemList = a.getReturnValue().soiList;
                                    if (orderItemList != null && orderItemList != undefined) {
                                        component.set("v.orderItemList", orderItemList);
                                        this.updateRowCalculations(component, event);
                                    }
                                    //Execute to rollback and check flag status on Draft button
                                    this.toggleConfirmDialog(component);
                                }
                            }
                        }
                    }
                } else {
                    toastMsg = $A.get(
                        "$Label.c.Some_error_has_occurred_while_Confirming_Order_Please_try_again"
                    );
                    this.showErrorToast(component, event, toastMsg);
                }
            });

            $A.enqueueAction(action);
        } else {
            toastMsg = $A.get(
                "$Label.c.Please_provide_valid_input_fill_all_the_mandatory_fields_before_proceeding"
            );
            this.showErrorToast(component, event, toastMsg);
        }
    },

    gotoURL: function (component, fullUrl) {
        var device = $A.get("$Browser.formFactor");
        console.log("You are using a " + device);
        console.log("fullUrl: " + fullUrl);

        if (device == "DESKTOP") {
            // (e.force:navigateToURL) only works when component loads as lightning.
            var urlEvent = $A.get("e.force:navigateToURL");
            if (urlEvent) {
                urlEvent.setParams({
                    url: fullUrl,
                    isredirect: false,
                });
                urlEvent.fire();
            } else {
                //window.location = fullUrl;

                // (sforce.one.navigateToURL) works when component loads in visualforce page.
                sforce.one.navigateToURL(fullUrl);
            }
        } else {
            //Redirect to Standard ListView when placing orders in SF1.
            this.navigateToComponent(component);
        }
    },

    updatePriceTable: function (component, event) {
        var target = event.getSource();
        var qty = target.get("v.value");
        var itemNo = target.get("v.requiredIndicatorClass");

        var priceDetailList = component.get("v.priceDetailList");
        for (var idx = 0; idx < priceDetailList.length; idx++) {
            if (priceDetailList[idx].itemNo == itemNo) {
                var oldValueQty = component.get("v.oldValueQty");
                if (qty > priceDetailList[idx].balanceQty || oldValueQty > qty) {
                    priceDetailList[idx].balanceQty =
                        priceDetailList[idx].balanceQty + oldValueQty;
                    priceDetailList[idx].balanceQty =
                        priceDetailList[idx].balanceQty - qty;
                } else {
                    priceDetailList[idx].balanceQty =
                        priceDetailList[idx].balanceQty - qty;
                }
                priceDetailList[idx].percUsed = parseFloat(
                    (priceDetailList[idx].balanceQty / priceDetailList[idx].qty) * 100
                ).toFixed(2);
                //priceDetailList[idx].percUsed = (priceDetailList[idx].balanceQty / priceDetailList[idx].qty) *100;
                break;
            }
        }
        component.set("v.priceDetailList", priceDetailList);
    },

    updateRowCalculations: function (component, event) {
        //console.log("From Method");
        //var target = event.getSource();
        //var rowIndex = target.get("v.labelClass");
        //this.fetchAccounts(component)//--> commented by VT for debugging
        //console.log("From Component");
        var accountId = component.get("v.selItem3.Sold_to_Party__c");
        var accountId1 = component.get("v.accountId");
        //console.log('**accountId--->'+accountId);
        //console.log('accountId5--->'+accountId1);
        // this.fetchAccountsForSOM(component);
        //console.log('accountId3--->'+accountId);

        var AccountId = component.get("v.accountId");
        //console.log('accountId6--->'+AccountId);
        //this.getCustomerConversionFactor(component, AccountId);
        /*
window.setTimeout(
$A.getCallback(function() {
 
}),1000);
*/
        //Edit Row function
        var orderItemList = component.get("v.orderItemList");
        // var  = .98;
        //  var customercoversionfactor = component.get("v.CF");
        // var customercoversionfactor3 = component.get("v.CustomerConversionFactor");
        //customercoversionfactor=1.02;

        var newSO = component.get("v.newSalesOrder"); // CR92.... Nik...22/07/2019...
        var tax = component.get("v.businessRule.Taxes__c"); // CR92.... Nik...22/07/2019...
        var freight = component.get("v.businessRule.Freight__c"); // CR92.... Nik...22/07/2019...
        var isPunct = component.get("v.isPunctual"); // CR92.... Nik...22/07/2019...
        var punct_Discount = 0; // CR92.... Nik...22/07/2019...
        var PunctualityDiscountCalculated = 0; // CR92.... Nik...22/07/2019...
        var PunctualityDiscountCalculatedUP = 0; //Divya: 13-07-2020: Added for SCTASK0216506
        var ReplacementCostCalculated = 0; // CR92.... Nik...22/07/2019...
        var ReplacementCostBRL = 0; // CR92.... Nik...22/07/2019...
        var fixDate = new Date("2019-04-01").toISOString().split("T")[0];
        var crtDate = "";
        var profileName = component.get("v.orderFields.userObj.Profile.Name");
        var taxAmt = 0;
        var taxAmtUP = 0; //Divya: 13-07-2020: Added for SCTASK0216506
        var freightAmt = 0; //Divya: 13-07-2020: Added for SCTASK0216506
        var freightAmtUP = 0;
        var disc = "";

        if (isPunct == true) {
            // CR92.... Nik...22/07/2019...
            punct_Discount = newSO.Punctuality_Discount__c;
        }

        var totalValue = 0;
        var totReplacementMar = 0;
        var totalTaxAmt = 0; // Nik.......13/09/2019
        var totalFreightAmt = 0; // Nik.......13/09/2019
        var TotalValueWihInterest = 0; // Nik.......13/09/2019
        var TotalPunctualityDiscount = 0; // Nik.......13/09/2019
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
        if ((isAvec || isCampainCheck) && component.find("payTmDt").get("v.value") && component.find("payTmDt").get("v.value").includes("BR71 INFORMAR VENCIMENTO") && component.get("v.newSalesOrder.Maturity_Date__c")) {
            paymntDate = component.get("v.newSalesOrder.Maturity_Date__c");
        }
        if (paymntDate != null && paymntDate != "") {
            var newpaymntDate = new Date(paymntDate);
        }
        //END

        var oneDay = 24 * 60 * 60 * 1000;
        //end
        /* ***************************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... Start ******************************************* */
        var blanketFlag = false;
        var customerTaxFreight = component.get("v.customerTaxFreight");
        var totalMargin = 0;
        var totalPrice = 0;
        var totalTax = 0;
        var totalPunctualityCal = 0;
        var totalSalesDeductionCal = 0;
        var totalE2eCal = 0;
        var totalFreight = 0;
        var tatalCOGSCal = 0;
        /* ***************************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... End ******************************************* */
        for (var idx = 0; idx < orderItemList.length; idx++) {
            //console.log("VIVEK-in-Helper 2")
            PunctualityDiscountCalculated = 0; // CR92.... Nik...22/07/2019...
            ReplacementCostCalculated = 0; // CR92.... Nik...22/07/2019...
            ReplacementCostBRL = 0; // CR92.... Nik...22/07/2019...
            taxAmt = 0;
            freightAmt = 0;

            PunctualityDiscountCalculatedUP = 0; //Divya: 13-07-2020: Added for SCTASK0216506
            taxAmtUP = 0; //Divya: 13-07-2020: Added for SCTASK0216506
            freightAmtUP = 0; //Divya: 13-07-2020: Added for SCTASK0216506
            blanketFlag = false;          // SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.......
            var flag = true;
            if (!orderItemList[idx].qty) {
                flag = false;
            }
            if (!orderItemList[idx].unitValue) {
                flag = false;
            }
            if (!orderItemList[idx].productId == false) {
                if (flag) {
                    //Logic to restrict negative value
                    var qty2 = orderItemList[idx].qty.toString(); //Convert to string
                    orderItemList[idx].qty = parseFloat(qty2.replace("-", "")); //Replace negative sign

                    var value2 = orderItemList[idx].unitValue.toString(); //Convert to string
                    orderItemList[idx].unitValue = parseFloat(value2.replace("-", "")); //Replace negative sign
                    //End of logic

                    //orderItemList[idx].days = component.get("v.days");

                    //orderItemList[idx].timeInMonths = orderItemList[idx].days/30;

                    //Divya: 26-05-2020 for INCTASK0186953
                    //Modified by Deeksha for kit selling Project
                    // undefined added by VT

                    if (newpaymntDate != null && newpaymntDate != "" && newpaymntDate != undefined) {
                        var nfatDate = new Date(orderItemList[idx].fatDate);
                        //undefined added by VT

                        if (newintrstDate != "" && newintrstDate != null && newintrstDate != undefined && newpaymntDate > newintrstDate) {
                            if (nfatDate > newintrstDate) {
                                orderItemList[idx].timeInMonths = (newpaymntDate.getTime() - nfatDate.getTime()) / oneDay / 30;
                            }
                            else {
                                orderItemList[idx].timeInMonths = (newpaymntDate.getTime() - newintrstDate.getTime()) / oneDay / 30;
                            }
                            //console.log('TimeInMonths '+orderItemList[idx].timeInMonths);
                            if (orderItemList[idx].timeInMonths && orderItemList[idx].interestRate != 0) {
                                orderItemList[idx].unitValueWithInterest = orderItemList[idx].unitValue / Math.pow(1 + orderItemList[idx].interestRate / 100, orderItemList[idx].timeInMonths);
                                //var Interest = (orderItemList[idx].days/30) * orderItemList[idx].interestRate;//vt
                                //orderItemList[idx].unitValueWithInterest = (orderItemList[idx].unitValue - Interest);//vt
                            }
                            else {
                                orderItemList[idx].unitValueWithInterest = orderItemList[idx].unitValue;
                            }
                        }
                        else {
                            orderItemList[idx].unitValueWithInterest =
                                orderItemList[idx].unitValue;
                            console.log("**unitValueWithInterest - helper 4 *******" + orderItemList[idx].unitValueWithInterest);
                        }
                    }
                    //VT added undefined
                    else if ((paymntDate == "" || paymntDate == null || paymntDate == undefined) && orderItemList[idx].days != "" && orderItemList[idx].days != null && orderItemList[idx].days != undefined) {

                        if (intrstDate == "" || intrstDate == null || intrstDate == undefined) {
                            orderItemList[idx].timeInMonths = orderItemList[idx].days / 30;

                            if (orderItemList[idx].timeInMonths && orderItemList[idx].interestRate != 0) {
                                var ViewPREVALUE = orderItemList[idx].unitValueWithInterest;
                                orderItemList[idx].unitValueWithInterest = orderItemList[idx].unitValue / Math.pow(1 + orderItemList[idx].interestRate / 100, orderItemList[idx].timeInMonths);

                                if (newpaymntDate == undefined) {
                                    //Pratham
                                    // orderItemList[idx].unitValueWithInterest = orderItemList[idx].unitValue / (Math.pow(1+orderItemList[idx].interestRate/100,orderItemList[idx].timeInMonths));
                                    orderItemList[idx].unitValueWithInterest = ViewPREVALUE;

                                    console.log("**unitValueWithInterest - helper 2******** " + orderItemList[idx].unitValueWithInterest);
                                }

                            }
                            else {
                                orderItemList[idx].unitValueWithInterest = orderItemList[idx].unitValue;
                                console.log("**unitValueWithInterest - helper 1 " + orderItemList[idx].unitValueWithInterest);
                            }
                        }
                        else {
                            var fatDate = new Date(orderItemList[idx].fatDate);
                            if (fatDate > newintrstDate) {
                                orderItemList[idx].timeInMonths = orderItemList[idx].days / 30;
                                if (orderItemList[idx].timeInMonths && orderItemList[idx].interestRate != 0) {
                                    orderItemList[idx].unitValueWithInterest = orderItemList[idx].unitValue / Math.pow(1 + orderItemList[idx].interestRate / 100, orderItemList[idx].timeInMonths);
                                    console.log("**unitValueWithInterest - " + orderItemList[idx].unitValueWithInterest);
                                }
                                else {
                                    orderItemList[idx].unitValueWithInterest = orderItemList[idx].unitValue;
                                    console.log("**unitValueWithInterest - helper 5 " + orderItemList[idx].unitValueWithInterest);
                                }
                            }
                            else {
                                var nfatDate = new Date(orderItemList[idx].fatDate);
                                nfatDate.setDate(nfatDate.getDate() + orderItemList[idx].days);
                                if (nfatDate > newintrstDate) {
                                    orderItemList[idx].timeInMonths = (nfatDate.getTime() - newintrstDate.getTime()) / oneDay / 30;
                                    //console.log('timeInMonths '+orderItemList[idx].timeInMonths);
                                    if (orderItemList[idx].timeInMonths && orderItemList[idx].interestRate != 0) {
                                        //this is Nikhil code
                                        orderItemList[idx].unitValueWithInterest = orderItemList[idx].unitValue / Math.pow(1 + orderItemList[idx].interestRate / 100, orderItemList[idx].timeInMonths);
                                        //Interest = (orderItemList[idx].days/30) * orderItemList[idx].interestRate;
                                        //orderItemList[idx].unitValueWithInterest = (orderItemList[idx].unitValue - Interest);
                                        console.log("presntValueC2" + orderItemList[idx].unitValueWithInterest); //this is Nikhil code
                                        console.log("presntValueC2Days" + orderItemList[idx].timeInMonths);
                                    }
                                    else {
                                        orderItemList[idx].unitValueWithInterest = orderItemList[idx].unitValue;
                                        console.log("**unitValueWithInterest - helper 6 " + orderItemList[idx].unitValueWithInterest);
                                    }
                                }
                                else {
                                    orderItemList[idx].unitValueWithInterest = orderItemList[idx].unitValue;
                                    console.log("**unitValueWithInterest - helper 7 " + orderItemList[idx].unitValueWithInterest);
                                }
                            }
                        }
                    }
                    //end
                    else {
                        orderItemList[idx].unitValueWithInterest = orderItemList[idx].unitValue;
                        console.log("**unitValueWithInterest - helper 8 " + orderItemList[idx].unitValueWithInterest);
                    }

                    //console.log('unitValueWithInterest: '+orderItemList[idx].unitValueWithInterest);
                    //orderItemList[idx].totalValue = (orderItemList[idx].qty * orderItemList[idx].unitValue).toFixed(2);
                    //orderItemList[idx].totalValueWithInterest = (orderItemList[idx].qty * orderItemList[idx].unitValueWithInterest).toFixed(2);

                    orderItemList[idx].totalValue = orderItemList[idx].qty * orderItemList[idx].unitValue;
                    //  commented by ganesh
                    //  orderItemList[idx].totalValueWithInterest = orderItemList[idx].qty * orderItemList[idx].unitValueWithInterest;
                    //comment end

                    orderItemList[idx].totalValueWithInterest = orderItemList[idx].qty * orderItemList[idx].unitValue;
                    if (!orderItemList[idx].kitProduct) {
                        TotalValueWihInterest += orderItemList[idx].totalValueWithInterest; // Nik.......13/09/2019
                    }
                    //if condition changed by Nik on 08/11/2019....CR106
                    //profileName=='Brazil Sales Office Manager' || profileName=='Brazil Sales District Manager'

                    if (profileName != "Brazil Sales Person") {
                        taxAmt = (tax * orderItemList[idx].totalValueWithInterest) / 100;
                        taxAmtUP = (tax * orderItemList[idx].totalValue) / 100; //Divya: 13-07-2020: Added for SCTASK0216506

                        freightAmt = (freight * orderItemList[idx].totalValueWithInterest) / 100;
                        freightAmtUP = (freight * orderItemList[idx].totalValue) / 100; //Divya: 13-07-2020: Added for SCTASK0216506
                        if (!orderItemList[idx].kitProduct) {
                            totalTaxAmt += taxAmt; // Nik.......13/09/2019
                            totalFreightAmt += freightAmt; // Nik.......13/09/2019

                            ReplacementCostBRL = orderItemList[idx].materialPlnRplc_Cost * orderItemList[idx].exchange_Rate; // CR92.... Nik...22/07/2019...

                            if (orderItemList[idx].currency_Code == "Only BRL") {
                                // CR92.... Nik...22/07/2019...
                                ReplacementCostCalculated = orderItemList[idx].qty * ReplacementCostBRL;
                            }
                            else {
                                ReplacementCostCalculated = orderItemList[idx].qty * orderItemList[idx].materialPlnRplc_Cost;
                            }

                            PunctualityDiscountCalculated = (punct_Discount * orderItemList[idx].totalValueWithInterest) / 100; // CR92.... Nik...22/07/2019...
                            PunctualityDiscountCalculatedUP =
                                (punct_Discount * orderItemList[idx].totalValue) / 100; //Divya: 13-07-2020: Added for SCTASK0216506
                            totReplacementMar += ReplacementCostCalculated;
                            TotalPunctualityDiscount += PunctualityDiscountCalculated; // Nik.......13/09/2019
                        }
                        //orderItemList[idx].replacementMargin = (parseFloat((orderItemList[idx].totalValueWithInterest - taxAmt - freightAmt - PunctualityDiscountCalculated - ReplacementCostCalculated)/orderItemList[idx].totalValueWithInterest))*100;  // CR92.... Nik...22/07/2019...
                        //orderItemList[idx].replacementMarginUP = (parseFloat((orderItemList[idx].totalValue - taxAmtUP - freightAmtUP - PunctualityDiscountCalculatedUP - ReplacementCostCalculated)/orderItemList[idx].totalValue))*100;  //Divya: 13-07-2020: Added for SCTASK0216506

                        // totReplacementMar += orderItemList[idx].replacementMargin;    // CR92.... Nik...22/07/2019...
                        // .... Nik...13/09/2019...

                        crtDate = new Date(orderItemList[idx].create_Date).toISOString().split("T")[0];

                        /*	
   var action = component.get("c.getCustomerConversionFactor");	
                          console.log("Checking 1");	
          action.setParams({	
              AccountId: AccountId	
          });	
          console.log("Checking");	
           action.setCallback(this, function(response) 	
           {	
              var state = response.getState();	
              var result = response.getReturnValue();	
              if (state === "SUCCESS") 	
              {	
                  console.log('In Success Conversion CF1 ='+CF);	
                  CF=response.getReturnValue();	
                     if(orderItemList[idx].currency_Code == 'Only BRL')	
       
     {	
                              
                              console.log('UnitValueWithIntrest'+orderItemList[idx].unitValueWithInterest);	
                              console.log('UNITBRL'+orderItemList[idx].unitValueBRL);	
                              console.log('Discount1'+orderItemList[idx].discount);	
                              console.log('customercoversionfactor '+customercoversionfactor);	
                              console.log('customercoversionfactor_From_SOQL'+orderItemList[idx].unitValueWithInterest);	
                              console.log('presntValueF'+orderItemList[idx].unitValueWithInterest);	
                              console.log('crtDate'+crtDate);	
                              console.log('fixDate'+fixDate);	
                              if(crtDate > fixDate){	
                                    
                                  if((100 - (( orderItemList[idx].unitValueWithInterest * 100) / orderItemList[idx].unitValueBRL*customercoversionfactor)) / 100 < 0){	
                                      orderItemList[idx].discount= 0;	
                                  }	
                                  else{	
                                      console.log('Discount21 in intial:'+disc);	
                                      disc = (100 - ((orderItemList[idx].unitValueWithInterest * 100) / (orderItemList[idx].unitValueBRL*customercoversionfactor))) / 100;	
                                      disc = disc*100;	
                                      orderItemList[idx].discount = disc;	
                                      console.log('Discount21 :'+disc);	
                                      console.log('Discount21 N :'+orderItemList[idx].unitValueWithInterest * 100);	
                                      console.log('Discount21 D :'+orderItemList[idx].unitValueBRL*customercoversionfactor);	
                                  }	
                              }	
                              else{	
                                  if(!orderItemList[idx]){	
                                        
                                      if((100 - (( orderItemList[idx].unitValueWithInterest* 100) / orderItemList[idx].unitValue*customercoversionfactor)) / 100 < 0){	
                                          orderItemList[idx].discount= 0;	
                                      }	
                                      else{	
                                          disc = (100 - (( orderItemList[idx].unitValueWithInterest* 100) / orderItemList[idx].unitValue*customercoversionfactor)) / 100;	
                                          disc = disc*100;	
                                          orderItemList[idx].discount = disc;	
                                          console.log('Discount3'+disc);	
                                      }	
                                  }	
                                  else{	
                                      orderItemList[idx].discount= 0;	
                                  }	
                                    
                              }	
                                
                          }	
                          else{	
                              if(crtDate > fixDate){	
                                  if((100 - (( orderItemList[idx].unitValueWithInterest * 100) / orderItemList[idx].unitValueUSD*customercoversionfactor)) /100 < 0){	
                                      orderItemList[idx].discount= 0;	
                                  }	
                                  else{	
                                      disc = (100 - (( orderItemList[idx].unitValueWithInterest * 100) / orderItemList[idx].unitValueUSD*customercoversionfactor)) /100;	
                                      disc = disc*100;	
                                      orderItemList[idx].discount = disc;	
                                      console.log('Discount5'+disc);	
                                  }	
                              }	
                              else{	
                                  if(!orderItemList[idx]){	
                                      if((100 - (( orderItemList[idx] * 100) / orderItemList[idx].unitValue*customercoversionfactor)) / 100 < 0){	
                                          orderItemList[idx].discount= 0;	
                                      }	
                                      else{	
                                          disc = (100 - (( orderItemList[idx].unitValueWithInterest* 100) / orderItemList[idx].unitValue*customercoversionfactor)) / 100;	
                                          disc = disc*100;	
                                          orderItemList[idx].discount = disc;	
                                          console.log('Discount6'+disc);	
                                      }	
                                  }	
                                  else{	
                                      orderItemList[idx].discount= 0;	
                                  }	
                                    
                              }	
                                
                                
                          }	
                            
                            
                      }	
                  console.log('In Success Conversion 1 ='+response.getReturnValue());	
                 // component.set("v.CF",CF);  	
                  //component.set("v.CustomerConversionFactor",'bnn'); 	
                  console.log('In Success Conversion 2 ='+response.getReturnValue());	
                  console.log('In Success Conversion 24 ='+component.get("v.CustomerConversionFactor")); 	
                   
                 
                
              else if (state === "ERROR") {	
                  console.log('In Error Conversion Error ='+response.getReturnValue());	
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
                      }	
          console.log('In Success Conversion CF2 ='+CF);	
          component.set("v.CustomerConversionFactor",'bnn'); 	
           component.set("v.CF",CF); 	
          // enqueue the action*/
                        console.log("UnitValueWithIntrestUjjwal" + orderItemList[idx].unitValueWithInterest);
                        console.log("currency_CodeUjjwal" + orderItemList[idx].currency_Code);
                        var CF;
                        var currencyCode = orderItemList[idx].currency_Code;
                        var UnitValueWithIntrest = orderItemList[idx].unitValueWithInterest;
                        var UNITBRL = orderItemList[idx].unitValueBRL;
                        var discount = orderItemList[idx].discount;
                        var action = component.get("c.getCustomerConversionFactor");
                        console.log("Checking 1");
                        action.setParams({
                            AccountId: AccountId,
                        });
                        console.log("Checking");
                        action.setCallback(this, function (response) {
                            var state = response.getState();
                            var result = response.getReturnValue();
                            if (state === "SUCCESS") {
                                CF = response.getReturnValue(); //Calculate the value of CF
                                if (currencyCode == "Only BRL") {

                                    console.log("crtDate" + crtDate);
                                    console.log("fixDate" + fixDate);
                                    if (crtDate > fixDate) {
                                        if ((100 - ((UnitValueWithIntrest * 100) / UNITBRL) * CF) / 100 < 0) {
                                            discount = 0;
                                        }
                                        else {
                                            console.log("Discount21 in intial:" + disc);
                                            disc =
                                                (100 - (UnitValueWithIntrest * 100) / (UNITBRL * CF)) /
                                                100;
                                            disc = disc * 100;
                                            discount = disc;
                                            console.log("Discount21 :" + disc);
                                            console.log(
                                                "Discount21 N :" + UnitValueWithIntrest * 100
                                            );
                                            console.log("Discount21 D :" + UNITBRL * CF);
                                        }
                                    }
                                    else {
                                        if (orderItemList[idx] != undefined) {
                                            //modified by sreekanth
                                            if ((100 - ((UnitValueWithIntrest * 100) / orderItemList[idx].unitValue) * CF) / 100 < 0) {
                                                discount = 0;
                                            }
                                            else {
                                                disc = (100 - ((UnitValueWithIntrest * 100) / orderItemList[idx].unitValue) * CF) / 100;
                                                disc = disc * 100;
                                                discount = disc;
                                                console.log("Discount3" + disc);
                                            }
                                        }
                                        else {
                                            discount = 0;
                                        }
                                    }
                                }
                                else {
                                    if (crtDate > fixDate && orderItemList[idx] != undefined) {
                                        //modified by srikanth
                                        if (
                                            (100 -
                                                ((UnitValueWithIntrest * 100) /
                                                    orderItemList[idx].unitValueUSD) *
                                                CF) /
                                            100 <
                                            0
                                        ) {
                                            discount = 0;
                                        }
                                        else {
                                            disc =
                                                (100 -
                                                    ((UnitValueWithIntrest * 100) /
                                                        orderItemList[idx].unitValueUSD) *
                                                    CF) /
                                                100;
                                            disc = disc * 100;
                                            discount = disc;
                                            console.log("Discount5" + disc);
                                        }
                                    }
                                    else {
                                        if (orderItemList[idx] != undefined) {
                                            //modified by srikanth
                                            if (
                                                (100 -
                                                    ((orderItemList[idx] * 100) /
                                                        orderItemList[idx].unitValue) *
                                                    CF) /
                                                100 <
                                                0
                                            ) {
                                                discount = 0;
                                            } else {
                                                disc =
                                                    (100 -
                                                        ((UnitValueWithIntrest * 100) /
                                                            orderItemList[idx].unitValue) *
                                                        CF) /
                                                    100;
                                                disc = disc * 100;
                                                discount = disc;
                                                console.log("Discount6" + disc);
                                            }
                                        }
                                        else {
                                            discount = 0;
                                        }
                                    }
                                }
                            }
                            else if (state === "ERROR") {
                                console.log(
                                    "In Error Conversion Error =" + response.getReturnValue()
                                );
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
                        $A.enqueueAction(action);
                        /*
                                    if(orderItemList[idx].currency_Code == 'Only BRL'){
                                        console.log('UnitValueWithIntrest'+orderItemList[idx].unitValueWithInterest);
                                        console.log('UNITBRL'+orderItemList[idx].unitValueBRL);
                                        console.log('Discount1'+orderItemList[idx].discount);
                                        console.log('customercoversionfactor '+customercoversionfactor);
                                        console.log('customercoversionfactor_From_SOQL'+orderItemList[idx].unitValueWithInterest);
                                        console.log('presntValueF'+orderItemList[idx].unitValueWithInterest);
                                        console.log('crtDate'+crtDate);
                                        console.log('fixDate'+fixDate);
                                        if(crtDate > fixDate){
                                            
                                            if((100 - (( orderItemList[idx].unitValueWithInterest * 100) / orderItemList[idx].unitValueBRL*customercoversionfactor)) / 100 < 0){
                                                orderItemList[idx].discount= 0;
                                            }
                                            else{
                                                console.log('Discount21 in intial:'+disc);
                                                disc = (100 - ((orderItemList[idx].unitValueWithInterest * 100) / (orderItemList[idx].unitValueBRL*customercoversionfactor))) / 100;
                                                disc = disc*100;
                                                orderItemList[idx].discount = disc;
                                                console.log('Discount21 :'+disc);
                                                console.log('Discount21 N :'+orderItemList[idx].unitValueWithInterest * 100);
                                                console.log('Discount21 D :'+orderItemList[idx].unitValueBRL*customercoversionfactor);
                                            }
                                        }
                                        else{
                                            if(!orderItemList[idx]){
                                                
                                                if((100 - (( orderItemList[idx].unitValueWithInterest* 100) / orderItemList[idx].unitValue*customercoversionfactor)) / 100 < 0){
                                                    orderItemList[idx].discount= 0;
                                                }
                                                else{
                                                    disc = (100 - (( orderItemList[idx].unitValueWithInterest* 100) / orderItemList[idx].unitValue*customercoversionfactor)) / 100;
                                                    disc = disc*100;
                                                    orderItemList[idx].discount = disc;
                                                    console.log('Discount3'+disc);
                                                }
                                            }
                                            else{
                                                orderItemList[idx].discount= 0;
                                            }
                                            
                                        }
                            }
                                    }
                                    else{
                                        if(crtDate > fixDate){
                                            if((100 - (( orderItemList[idx].unitValueWithInterest * 100) / orderItemList[idx].unitValueUSD*customercoversionfactor)) /100 < 0){
                                                orderItemList[idx].discount= 0;
                                            }
                                            else{
                                                disc = (100 - (( orderItemList[idx].unitValueWithInterest * 100) / orderItemList[idx].unitValueUSD*customercoversionfactor)) /100;
                                                disc = disc*100;
                                                orderItemList[idx].discount = disc;
                                                console.log('Discount5'+disc);
                                            }
                                        }
                                        else{
                                            if(!orderItemList[idx]){
                                                if((100 - (( orderItemList[idx] * 100) / orderItemList[idx].unitValue*customercoversionfactor)) / 100 < 0){
                                                    orderItemList[idx].discount= 0;
                                                }
                                                else{
                                                    disc = (100 - (( orderItemList[idx].unitValueWithInterest* 100) / orderItemList[idx].unitValue*customercoversionfactor)) / 100;
                                                    disc = disc*100;
                                                    orderItemList[idx].discount = disc;
                                                    console.log('Discount6'+disc);
                                                }
                                            }
                                            else{
                                                orderItemList[idx].discount= 0;
                                            }
                                            
                                        }
                                        
            */

                    }


                    /* ******************************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... Start **************************************** */
                    orderItemList[idx].convertedQnty = orderItemList[idx].qty;
                    orderItemList[idx].convertedNetPrice = orderItemList[idx].unitValueWithInterest;

                    if (orderItemList[idx].curncyCode == "Only BRL" || orderItemList[idx].curncyCode == "BRL") {
                        orderItemList[idx].salesDeductionCal = orderItemList[idx].salesDeductionCost * orderItemList[idx].qty * orderItemList[idx].exchngRate;
                        orderItemList[idx].cogsCostCal = orderItemList[idx].cogsCost * orderItemList[idx].qty * orderItemList[idx].exchngRate;
                        orderItemList[idx].e2eCostCal = orderItemList[idx].e2eCost * orderItemList[idx].qty * orderItemList[idx].exchngRate;
                    }
                    else {
                        orderItemList[idx].salesDeductionCal = orderItemList[idx].salesDeductionCost * orderItemList[idx].qty;
                        orderItemList[idx].cogsCostCal = orderItemList[idx].cogsCost * orderItemList[idx].qty;
                        orderItemList[idx].e2eCostCal = orderItemList[idx].e2eCost * orderItemList[idx].qty;
                    }

                    taxAmt = 0; freightAmt = 0; PunctualityDiscountCalculated = 0;
                    var totVal = orderItemList[idx].unitValue * orderItemList[idx].qty;
                    if (customerTaxFreight != null) {
                        taxAmt = (customerTaxFreight.tax * totVal) / 100;
                        freightAmt = (customerTaxFreight.freight * totVal) / 100;
                    }

                    PunctualityDiscountCalculated = (punct_Discount * totVal) / 100;

                    totalPrice += totVal;
                    totalTax += taxAmt;
                    totalPunctualityCal += PunctualityDiscountCalculated;
                    totalSalesDeductionCal += orderItemList[idx].salesDeductionCal;
                    totalE2eCal += orderItemList[idx].e2eCostCal;
                    totalFreight += freightAmt;
                    tatalCOGSCal += orderItemList[idx].cogsCostCal;

                    orderItemList[idx].contMargin = (((totVal - taxAmt - PunctualityDiscountCalculated - orderItemList[idx].salesDeductionCal) - (orderItemList[idx].e2eCostCal + freightAmt + orderItemList[idx].cogsCostCal)) / (totVal - taxAmt - PunctualityDiscountCalculated - orderItemList[idx].salesDeductionCal)) * 100;

                    orderItemList[idx].mbLevel1 = false; // reset here..
                    orderItemList[idx].mbLevel2 = false; // reset here..

                    if (orderItemList[idx].isBlanket == false) {
                        if (orderItemList[idx].contMargin >= orderItemList[idx].level2Min && orderItemList[idx].contMargin <= orderItemList[idx].level2Max) {
                            orderItemList[idx].mbLevel1 = true;
                        }
                        else if (orderItemList[idx].contMargin <= orderItemList[idx].level3Below) {
                            orderItemList[idx].mbLevel1 = true;
                            //orderItemList[idx].mbLevel2 = true;           // Update by Dheeraj RITM0502271 Comment due to order dont sent to go in global CCO Step
                        }
                    }
                    /* ******************************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... End **************************************** */

                    //commented by ganesh
                    // totalValue += parseFloat(orderItemList[idx].totalValueWithInterest);
                    //comment end
                    if (!orderItemList[idx].kitProduct && orderItemList[idx].ItemStatus != 'Inactive') {
                        totalValue += parseFloat(orderItemList[idx].totalValue); //change by Ganesh
                    }
                    //console.log('totalValue: '+totalValue)
                    /*
                    //Modified by Deeksha for kit selling Project
                    if(kitSummedValuesMap.has(orderItemList[idx].refKitNo)){
                        var kitPresentValue =kitSummedValuesMap.get(orderItemList[idx].refKitNo).presentValue+orderItemList[idx].unitValueWithInterest;
                        var kitTotalValue =kitSummedValuesMap.get(orderItemList[idx].refKitNo).totalValue+orderItemList[idx].totalValueWithInterest;
                        var kitReplacementMargin = kitSummedValuesMap.get(orderItemList[idx].refKitNo).rm + orderItemList[idx].replacementMargin;
                        var kitReplacementMarginUP = kitSummedValuesMap.get(orderItemList[idx].refKitNo).rmUP + orderItemList[idx].replacementMarginUP;
                        var kitListValue = kitSummedValuesMap.get(orderItemList[idx].refKitNo).lv + orderItemList[idx].listValue;
                        var kitBudgetPrice = kitSummedValuesMap.get(orderItemList[idx].refKitNo).bv + orderItemList[idx].budgetValue;
                        var kitDiscount = kitSummedValuesMap.get(orderItemList[idx].refKitNo).disc + orderItemList[idx].discount;
                        kitSummedValuesMap.set(orderItemList[idx].refKitNo,{presentValue : kitPresentValue,totalValue : kitTotalValue,kitLength : parseFloat(kitSummedValuesMap.get(orderItemList[idx].refKitNo).kitLength)+1,rm:kitReplacementMargin,rmUP:kitReplacementMarginUP,lv:kitListValue,bv:kitBudgetPrice,disc:kitDiscount});  
                        
                    }
                    else{
                        kitSummedValuesMap.set(orderItemList[idx].refKitNo,{presentValue : orderItemList[idx].unitValueWithInterest,totalValue:orderItemList[idx].totalValueWithInterest,kitLength : 1,rm:orderItemList[idx].replacementMargin,rmUP:orderItemList[idx].replacementMarginUP,lv:orderItemList[idx].listValue,bv:orderItemList[idx].budgetPrice,disc:orderItemList[idx].discount});  
                    }*/

                }
            }
            else {
                //var toastMsg = $A.get("$Label.c.Select_Product_before_Entering_Price_Quantity");
                //this.showErrorToast(component, event, toastMsg);

                var getProductId = component.find("itemproduct");
                var isProductArray = Array.isArray(getProductId);

                if (isProductArray) {
                    //Product validaiton
                    if (getProductId[idx].get("v.value") == null || getProductId[idx].get("v.value") == "") {
                        component.find("itemproduct")[idx].set("v.errors", [{ message: $A.get("$Label.c.Product_is_required") },]);
                        $A.util.addClass(component.find("itemproduct")[idx], "error");
                    }
                }
                else {
                    if (getProductId.get("v.value") == null || getProductId.get("v.value") == "") {
                        component.find("itemproduct").set("v.errors", [{ message: $A.get("$Label.c.Product_is_required") },]);
                        $A.util.addClass(component.find("itemproduct"), "error");
                    }
                }
            }

            if (orderItemList.length > 0) {
                //....Nik..13/09/2019...
                //var totCount = orderItemList.length;
                //totReplacementMar = totReplacementMar / totCount;
                try {
                    var allTotal =
                        TotalValueWihInterest -
                        totalTaxAmt -
                        totalFreightAmt -
                        TotalPunctualityDiscount -
                        totReplacementMar;
                    var replaceAmnt = allTotal / TotalValueWihInterest;
                    if (isNaN(replaceAmnt) == true) {
                        totReplacementMar = 0;
                    } else {
                        totReplacementMar = replaceAmnt * 100;
                    }
                    // SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.......
                    totalMargin = (((totalPrice - totalTax - totalPunctualityCal - totalSalesDeductionCal) - (totalE2eCal + totalFreight + tatalCOGSCal)) / (totalPrice - totalTax - totalPunctualityCal - totalSalesDeductionCal)) * 100;
                	totalMargin = parseFloat(totalMargin.toFixed(2));
              }
                catch (ex) {
                    totReplacementMar = 0;
                    console.log("Error occure in updateRowCalculation function....");
                    console.log("Error Is....- ");
                    console.log(ex);
                }
            }

            component.set("v.orderItemList", orderItemList);
            component.set("v.totalValue", totalValue);
            component.set("v.newSalesOrder.Total_Overall_Margin__c", totalMargin);  // SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.......

            //component.set("v.newSalesOrder.SalesOrderReplacementMargin__c",totReplacementMar);
        }
        /*Modified by Deeksha for kit selling Project
for (var idx = 0; idx < orderItemList.length; idx++){
if(kitSummedValuesMap.has(orderItemList[idx].kitNo)){
orderItemList[idx].unitValueWithInterest = kitSummedValuesMap.get(orderItemList[idx].kitNo).presentValue;
orderItemList[idx].totalValueWithInterest = kitSummedValuesMap.get(orderItemList[idx].kitNo).totalValue;
orderItemList[idx].replacementMargin = kitSummedValuesMap.get(orderItemList[idx].kitNo).rm/kitSummedValuesMap.get(orderItemList[idx].kitNo).kitLength;
orderItemList[idx].replacementMarginUP = kitSummedValuesMap.get(orderItemList[idx].kitNo).rmUP/kitSummedValuesMap.get(orderItemList[idx].kitNo).kitLength;
orderItemList[idx].listValue = kitSummedValuesMap.get(orderItemList[idx].kitNo).lv;
orderItemList[idx].budgetValue = kitSummedValuesMap.get(orderItemList[idx].kitNo).bv;
orderItemList[idx].discount = kitSummedValuesMap.get(orderItemList[idx].kitNo).disc/kitSummedValuesMap.get(orderItemList[idx].kitNo).kitLength;
}
 
}*/

        component.set("v.orderItemList", orderItemList);
        var kitOrder = component.get("v.newSalesOrder.Kit_Order__c");
        if (kitOrder) {
            this.CalculateComponentTotal(component, event);
        }
    },

    fetchAccounts: function (component) {
        var isSimulated = component.get("v.isSimulated");
        var sellerId = component.get("v.newSalesOrder.KeyAccountDesOwnerBrazil__c");
        //var keyAccTMcode = component.get("v.newSalesOrder.TM_Code__c");  // Ticket# INCTASK0100403:- Ankita, patch for open region
        var userId = component.get("v.userId");

        //var seUser = component.get("v.selectedUser");

        var orderType = component.get("v.newSalesOrder.Type_of_Order__c");
        var customerGroup = component.get(
            "v.selItem3.Sold_to_Party__r.Customer_Group__c"
        );
        var accountId = component.get("v.selItem3.Sold_to_Party__c");
        console.log("**AccountId - " + accountId);
        console.log("**customerGroup - " + customerGroup);
        var action;

        var isKeyAccount = component.get("v.newSalesOrder.Key_Account__c");
        var showKeyAccount = component.get("v.showKeyAccount");
        var tableColumns;

        //Column data for the table

        //   if (!isSimulated)
        //   Commented by Priya for RITM0222939
        /* tableColumns = [
{
'label': $A.get("$Label.c.Customer_Code"),
'name':'SAP_Code__c',
'type':'string',
'value':'Id',
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
 
]; */

        //added by Priya for RITM0222939
        tableColumns = [
            {
                label: $A.get("$Label.c.BrazilAction"),
                type: "button",
                initialWidth: 150,
                typeAttributes: {
                    label: $A.get("$Label.c.Select"),
                    title: "Select",
                    name: "Select",
                    disabled: { fieldName: "actionDisabled" },
                    class: "btn_next",
                },
            },
            {
                label: $A.get("$Label.c.Customer_Code"),
                type: "text",
                fieldName: "SAP_Code__c",
                hideDefaultActions: true,
            },
            {
                label: $A.get("$Label.c.Name"),
                fieldName: "Name",
                type: "text",
                hideDefaultActions: true,
            },
            {
                label: $A.get("$Label.c.Group"),
                fieldName: "Customer_Group__c",
                type: "text",
                hideDefaultActions: true,
            },
            {
                label: $A.get("$Label.c.City"),
                fieldName: "BillingCity",
                type: "text",
                hideDefaultActions: true,
            },
            {
                label: $A.get("$Label.c.Region"),
                fieldName: "Customer_Region__c",
                type: "text",
                hideDefaultActions: true,
            },
            {
                label: $A.get("$Label.c.Tax_Number_1"),
                fieldName: "Tax_Number_1__c",
                type: "text",
                hideDefaultActions: true,
            },
            {
                label: $A.get("$Label.c.Tax_Number_3"),
                fieldName: "Tax_Number_3__c",
                type: "text",
                hideDefaultActions: true,
            },
        ];

        //Configuration data for the table to enable actions in the tabl
        var tableConfig = {
            massSelect: false,
            globalAction: [],
            searchByColumn: true,
            rowAction: [
                {
                    label: $A.get("$Label.c.Select"),
                    type: "url",
                    id: "selectaccount",
                },
            ],
        };

        if (showKeyAccount && isKeyAccount != undefined && isKeyAccount != null) {
            var keyUserId = userId;

            //Get Logged In User ID
            if (isKeyAccount == false) {
                keyUserId = userId;
                //console.log('keyUserId1'+keyUserId);
            }
            //Get selected Seller ID
            else {
                keyUserId = sellerId;
                //console.log('keyUserId2'+keyUserId);
            }

            //If key account manager then getKeyCustomers

            action = component.get("c.getKeyCustomers");
            action.setParams({
                userId: keyUserId,
                orderType: orderType,
                customerGroup: customerGroup,
                accountId: accountId, //,"keyAccTMcode":keyAccTMcode // Ticket# INCTASK0100403:- Ankita, patch for open region
            });
            console.log("keyUserId2" + keyUserId);
            //if(isKeyAccount==true){
            console.log("UpdatePriceList keyUserId2");
            this.UpdatePriceList(component, keyUserId);
            //}
        } else {
            //If not key account manager then getCustomers
            //selectedUser added by ganesh
            //desc: if selectedUser is not blank then get customer
            action = component.get("c.getCustomers");
            // Added for SOM GRZ(Javed) for RITM0490875 modified 03-02-2023-->
            var regionCode;
            if (component.get("v.user.Profile.Name") == "Brazil Sales Office Manager") {
                regionCode = component.get("v.customerRegionForSOM");
            }
            if (component.get("v.user.Profile.Name") == "Brazil Sales District Manager") {
                regionCode = component.get("v.customerRegionForSDM");//INC0385117
            }

            action.setParams({
                selectedUser: sellerId,
                orderType: orderType,
                customerGroup: customerGroup,
                accountId: accountId, //,"keyAccTMcode":keyAccTMcode Ticket# INCTASK0100403:- Ankita, patch for open region
                customerRegionCode: regionCode
            });
            //console.log('**sellerIdTest - '+sellerId);

            component.set("v.sellerID", sellerId);
            console.log("**orderType - " + orderType);
            console.log("**customerGroup -" + customerGroup);
            //console.log('**sellerID&&& - '+component.get("v.sellerID"));
            //console.log('**customerGroup - '+customerGroup);
            //console.log('**accountId - '+accountId);
            if (isKeyAccount == true) {
                console.log("UpdatePriceList isKeyAccount");
                this.UpdatePriceList(component, sellerId);
            }
        }

        // show spinner to true on click of a button / onload
        component.set("v.showSpinner", true);

        action.setCallback(this, function (resp) {
            // on call back make it false ,spinner stops after data is retrieved
            component.set("v.showSpinner", false);
            console.log(
                "The SpiinerShow fetchAccounts",
                component.get("v.showSpinner")
            );
            var state = resp.getState();
            if (component.isValid() && state == "SUCCESS") {
                //pass the records to be displayed
                //console.log('Priya Accounts: '+JSON.stringify(resp.getReturnValue()));
                //component.set("v.accountTableConfig",tableConfig);
                component.set("v.accountList", resp.getReturnValue());
                component.set("v.accountData", resp.getReturnValue());
                var custbtn = component.find("custitem");
                console.log('custbtn fetchacc', JSON.stringify(custbtn));
                if (Array.isArray(custbtn)) {
                    custbtn[0].set("v.disabled", false);
                }
                else {
                    custbtn.set("v.disabled", false);

                }

                //pass the configuration of task table
                component.set("v.accountTableConfig", tableConfig);
                //console.log('accountTableConfig===>'+JSON.stringify(component.get("v.accountTableConfig")));
                //pass the column information
                component.set("v.accountTableColumns", tableColumns);

                console.log(
                    "**This Condition in fetchAccounts - " +
                    JSON.stringify(component.get("v.accountList"))
                );

                //initialize the datatable
                //if(!isSimulated){

                //Commented by Priya for RITM0222939
                /* component.find("accountTable").initialize({
                "order":[0,"desc"],
                "itemMenu":["5","10","25","50"],
                "itemsPerPage:":5
            }); */
            } else {
                console.log("**error in this Condition in fetchAccounts");
                //console.log(resp.getError());
            }
        });

        $A.enqueueAction(action);
    },

    fetchAccountsForSOM: function (component) {
        var sellerId = component.get("v.newSalesOrder.KeyAccountDesOwnerBrazil__c");
        console.log("fetchAccountsForSOM seller id%%%%" + sellerId);

        var userId = component.get("v.userId");

        //var seUser = component.get("v.selectedUser");
        //console.log('sellerId'+sellerId);

        var orderType = component.get("v.newSalesOrder.Type_of_Order__c");
        var customerGroup = component.get(
            "v.selItem3.Sold_to_Party__r.Customer_Group__c"
        );
        var accountId = component.get("v.selItem3.Sold_to_Party__c");
        //console.log('accountId--->'+accountId);
        var action;

        var isKeyAccount = component.get("v.newSalesOrder.Key_Account__c");
        var showKeyAccount = component.get("v.showKeyAccount");
        var tableColumns;

        //console.log("inside fetch method");

        //Commented by Priya for RITM0222939
        //Column data for the table
        /* var tableColumns = [
{
    'label': $A.get("$Label.c.Customer_Code"),
    'name':'SAP_Code__c',
    'type':'string',
    'value':'Id',
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
*/

        //Configuration data for the table to enable actions in the table
        var tableConfig = {
            massSelect: false,
            globalAction: [],
            searchByColumn: true,
            rowAction: [
                {
                    label: $A.get("$Label.c.Select"),
                    type: "url",
                    id: "selectaccount",
                },
            ],
        };

        //added by Priya for RITM0222939
        tableColumns = [
            {
                label: $A.get("$Label.c.BrazilAction"),
                type: "button",
                initialWidth: 150,
                typeAttributes: {
                    label: $A.get("$Label.c.Select"),
                    title: "Select",
                    name: "Select",
                    disabled: { fieldName: "actionDisabled" },
                    class: "btn_next",
                },
            },
            {
                label: $A.get("$Label.c.Customer_Code"),
                type: "text",
                fieldName: "SAP_Code__c",
                hideDefaultActions: true,
            },
            {
                label: $A.get("$Label.c.Name"),
                fieldName: "Name",
                type: "text",
                hideDefaultActions: true,
            },
            {
                label: $A.get("$Label.c.Group"),
                fieldName: "Customer_Group__c",
                type: "text",
                hideDefaultActions: true,
            },
            {
                label: $A.get("$Label.c.City"),
                fieldName: "BillingCity",
                type: "text",
                hideDefaultActions: true,
            },
            {
                label: $A.get("$Label.c.Region"),
                fieldName: "Customer_Region__c",
                type: "text",
                hideDefaultActions: true,
            },
            {
                label: $A.get("$Label.c.Tax_Number_1"),
                fieldName: "Tax_Number_1__c",
                type: "text",
                hideDefaultActions: true,
            },
            {
                label: $A.get("$Label.c.Tax_Number_3"),
                fieldName: "Tax_Number_3__c",
                type: "text",
                hideDefaultActions: true,
            },
        ];
        if (showKeyAccount && isKeyAccount != undefined && isKeyAccount != null) {
            var keyUserId;

            //Get Logged In User ID
            if (isKeyAccount == false) {
                keyUserId = userId;
                //console.log('keyUserId1'+keyUserId);
            }
            //Get selected Seller ID
            else {
                keyUserId = sellerId;
                // console.log('keyUserId2'+keyUserId);
            }

            //If key account manager then getKeyCustomers

            action = component.get("c.getKeyCustomers");
            action.setParams({
                userId: keyUserId,
                orderType: orderType,
                customerGroup: customerGroup,
                accountId: accountId,
            });
        } else {
            //If not key account manager then getCustomers
            //selectedUser added by ganesh
            //desc: if selectedUser is not blank then get customer
            action = component.get("c.getCustomers");
            // Added for SOM GRZ(Javed) for RITM0490875 modified 03-02-2023-->
            var regionCode;
            if (component.get("v.user.Profile.Name") == "Brazil Sales Office Manager") {
                regionCode = component.get("v.customerRegionForSOM");
            }
            if (component.get("v.user.Profile.Name") == "Brazil Sales District Manager") {
                regionCode = component.get("v.customerRegionForSDM"); //INC0385117
            }

            action.setParams({
                selectedUser: sellerId,
                orderType: orderType,
                customerGroup: customerGroup,
                accountId: accountId,
                customerRegionCode: regionCode
            });
        }

        // show spinner to true on click of a button / onload
        component.set("v.showSpinner", true);

        action.setCallback(this, function (resp) {
            // on call back make it false ,spinner stops after data is retrieved
            component.set("v.showSpinner", false);
            console.log(
                "The SpiinerShow fetchAccountsForSOM",
                component.get("v.showSpinner")
            );
            var state = resp.getState();
            if (component.isValid() && state == "SUCCESS") {
                //pass the records to be displayed
                // console.log('Accounts: '+JSON.stringify(resp.getReturnValue()));
                component.set("v.accountTableConfig", tableConfig);
                component.set("v.accountList", resp.getReturnValue());
                //added by Priya for RITM0222939
                component.set("v.accountData", resp.getReturnValue());
                if (resp.getReturnValue().length == 0) {
                    var toastMsgs = $A.get("$Label.c.No_Customer_Available");
                    this.showWarningToast(component, event, toastMsgs);
                }
                var custbtn = component.find("custitem");
                console.log('custbtn fetchacc', JSON.stringify(custbtn));
                if (Array.isArray(custbtn)) {
                    custbtn[0].set("v.disabled", false);
                }
                else {
                    custbtn.set("v.disabled", false);

                }
                //pass the configuration of task table
                //   component.set("v.accountTableConfig",tableConfig);

                //pass the column information
                component.set("v.accountTableColumns", tableColumns);

                console.log("**this Condition in fetchAccountsForSOM ");

                //Commented by Priya for RITM0222939
                //initialize the datatable
                /*   component.find("accountTable").initialize({
                    "order":[0,"desc"],
                    "itemMenu":["5","10","25","50"],
                    "itemsPerPage:":5
                });*/
            } else {
                console.log("**error in this Condition in fetchAccountsForSOM ");
                //console.log(resp.getError());
            }
        });

        $A.enqueueAction(action);
    },
    //fetchSOM : function(component,currentValue) {
    fetchSOM: function (component) {
        var action = component.get("c.getSOM");

        var currentValue = component.get("v.selectedUser");
        console.log(currentValue+'**********************');
        //console.log('currentValue'+currentValue);
        //01-12-2019: Patch given by SKI for Brazil INCTASK0092627 - SOM not Available
        var TerritoryCode = "";
        var selected = "";
        if (currentValue != undefined) {
            selected = currentValue.split("~~");
            TerritoryCode = selected[1];
            currentValue = selected[0];
            console.log(
                "currentValue" + currentValue + "TerritoryCode" + TerritoryCode
            );
        }

        //Column data for the table
        var somTableColumns = [
            {
                label: $A.get("$Label.c.SOM_Code"),
                name: "SalesOrderNumber_Brazil__c",
                type: "string",
                value: "Id",
                width: 100,
                resizeable: true,
            },
            {
                label: $A.get("$Label.c.Code"),
                name: "SAP_Order_Number__c",
                type: "string",
                resizeable: true,
            },
            {
                label: $A.get("$Label.c.SOM_Customer"),
                name: "Sold_to_Party__r.Name",
                type: "string",
                resizeable: true,
            },
            {
                label: $A.get("$Label.c.Customer_Group"),
                name: "Sold_to_Party__r.Customer_Group__c",
                type: "string",
                resizeable: true,
            },
            {
                label: $A.get("$Label.c.City"),
                name: "Sold_to_Party__r.BillingCity",
                type: "string",
                resizeable: true,
            },
            {
                label: $A.get("$Label.c.State"),
                name: "Sold_to_Party__r.BillingState",
                type: "string",
                resizeable: true,
            },
        ];

        //Configuration data for the table to enable actions in the table
        var somTableConfig = {
            massSelect: false,
            globalAction: [],
            searchByColumn: true,
            rowAction: [
                {
                    label: $A.get("$Label.c.Select"),
                    type: "url",
                    id: "selectsom",
                },
            ],
        };

        if (
            component.get("v.selectedUser") != null &&
            component.get("v.selectedUser") != undefined &&
            component.get("v.selectedUser") != "None"
        ) {
            /* 
action.setParams({
 currentValue: component.get("v.selectedUser")
});*/
            //02-12-2019: Patch given by SKI for Brazil INCTASK0092627 - SOM not Available
            action.setParams({
                currentValue: currentValue,
                TerritoryCode: TerritoryCode,
            });
        }

        // show spinner to true on click of a button / onload
        component.set("v.showSpinner", true);

        action.setCallback(this, function (resp) {
            // on call back make it false ,spinner stops after data is retrieved
            component.set("v.showSpinner", false);
            console.log("The SpiinerShow fetchSOM", component.get("v.showSpinner"));
            var state = resp.getState();
            if (component.isValid() && state == "SUCCESS") {
                //pass the records to be displayed
                var data = resp.getReturnValue();

                var som = component.get("v.somList");

                component.set("v.somList", resp.getReturnValue());

                //alert(JSON.stringify(component.get("v.somList")));

                console.log("resp.getReturnValue()" + resp.getReturnValue());
                var pricebookdetail12 = JSON.parse(
                    JSON.stringify(resp.getReturnValue())
                );
                console.log("pricebookdetail12*************", pricebookdetail12);

                //pass the column information
                component.set("v.somTableColumns", somTableColumns);
                //pass the configuration of task table
                component.set("v.somTableConfig", somTableConfig);

                //initialize the datatable
                component.find("somTable").initialize({
                    order: [0, "desc"],
                    itemMenu: ["5", "10", "25", "50"],
                    "itemsPerPage:": 5,
                });
            } else {
                //console.log(resp.getError());
            }
        });

        $A.enqueueAction(action);
    },

    //CREATED METHOD WHEN TYPE OF ORDER IS BONIFICATION BY HARSHIT&ANMOL@WIPRO FOR (US SO-011) ---START
    fetchBonification: function (component) {
        var action = component.get("c.typeofOrderBonification");
        //var action= component.get("c.typeofOrderBonification");
        //alert("hi");
        var currentValue = component.get("v.selectedUser");

        console.log("currentValue1", currentValue);
        //console.log('currentValue'+currentValue);
        //01-12-2019: Patch given by SKI for Brazil INCTASK0092627 - SOM not Available
        var TerritoryCode = "";
        var selected = "";
        if (currentValue != undefined) {
            selected = currentValue.split("~~");
            TerritoryCode = selected[1];
            currentValue = selected[0];
            console.log(
                "currentValue**************" +
                currentValue +
                "TerritoryCode" +
                TerritoryCode
            );
        }

        //Column data for the table
        var somTableColumns = [
            {
                label: $A.get("$Label.c.SOMCode"),
                name: "SalesOrderNumber_Brazil__c",
                type: "string",
                value: "Id",
                width: 100,
                resizeable: true,
            },
            {
                label: $A.get("$Label.c.Code"),
                name: "SAP_Order_Number__c",
                type: "string",
                resizeable: true,
            },
            {
                label: $A.get("$Label.c.SOMCustomer"),
                name: "Sold_to_Party__r.Name",
                type: "string",
                resizeable: true,
            },
            {
                label: $A.get("$Label.c.Customer_Group"),
                name: "Sold_to_Party__r.Customer_Group__c",
                type: "string",
                resizeable: true,
            },
            {
                label: $A.get("$Label.c.City"),
                name: "Sold_to_Party__r.BillingCity",
                type: "string",
                resizeable: true,
            },
            {
                label: $A.get("$Label.c.State"),
                name: "Sold_to_Party__r.BillingState",
                type: "string",
                resizeable: true,
            },
        ];

        //Configuration data for the table to enable actions in the table
        var somTableConfig = {
            massSelect: false,
            globalAction: [],
            searchByColumn: true,
            rowAction: [
                {
                    label: $A.get("$Label.c.Select"),
                    type: "url",
                    id: "selectsom",
                },
            ],
        };
        if (
            component.get("v.selectedUser") != null &&
            component.get("v.selectedUser") != undefined &&
            component.get("v.selectedUser") != "None"
        ) {
            /* 
        action.setParams({
         currentValue: component.get("v.selectedUser")
     });*/
            //02-12-2019: Patch given by SKI for Brazil INCTASK0092627 - SOM not Available
            action.setParams({
                currentValue: currentValue,
                TerritoryCode: TerritoryCode
            });
        }

        // show spinner to true on click of a button / onload
        component.set("v.showSpinner", true);

        action.setCallback(this, function (resp) {
            // on call back make it false ,spinner stops after data is retrieved
            component.set("v.showSpinner", false);
            console.log(
                "The SpiinerShow fetchBonification",
                component.get("v.showSpinner")
            );
            var state = resp.getState();
            if (component.isValid() && state == "SUCCESS") {
                //pass the records to be displayed
                var data = resp.getReturnValue();

                var som = component.get("v.somList");

                component.set("v.somList", resp.getReturnValue());

                //alert(JSON.stringify(component.get("v.somList")));

                console.log(
                    "resp.getReturnValue()*****************" + resp.getReturnValue()
                );
                var pricebookdetail12 = JSON.parse(
                    JSON.stringify(resp.getReturnValue())
                );
                console.log("bonification aa gya ", pricebookdetail12);

                //pass the column information
                component.set("v.somTableColumns", somTableColumns);
                //pass the configuration of task table
                component.set("v.somTableConfig", somTableConfig);

                //initialize the datatable
                component.find("somTable").initialize({
                    order: [0, "desc"],
                    itemMenu: ["5", "10", "25", "50"],
                    "itemsPerPage:": 5,
                });
            } else {
                //console.log(resp.getError());
            }
        });

        $A.enqueueAction(action);
    },
    getShipToParty: function (component, event, distrId) {
        // console.log(distrId);
        // component.set("v.shipToPartyList","");

        var tableColumns = [
            {
                label: $A.get("$Label.c.Name"),
                name: "Location_Name__c",
                type: "string",
                resizeable: true,
            },
            {
                label: "Customer",
                name: "Distributor__r.Name",
                type: "string",
                resizeable: true,
            },
            {
                label: "City",
                name: "City__c",
                type: "string",
                resizeable: true,
            },
            {
                label: "State",
                name: "State__c",
                type: "string",
                resizeable: true,
            },
            {
                label: "Country",
                name: "Country__c",
                type: "string",
                resizeable: true,
            },
            {
                label: "Pincode",
                name: "Pincode__c",
                type: "string",
                resizeable: true,
            },
        ];

        var tableConfig = {
            massSelect: false,
            globalAction: [],
            searchByColumn: true,
            rowAction: [
                {
                    label: "Select",
                    type: "url",
                    id: "selectshiptoparty",
                },
            ],
        };
        var action = component.get("c.getShippingLoations");
        action.setParams({
            accId: distrId,
        });

        if (distrId != null) {
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                    //console.log('ship to party>>--->'+response.getReturnValue());
                    //if(response.getReturnValue() !=null){
                    //component.set("v.shipToPartyList",response.getReturnValue());
                    // component.set("v.shipToPartyTableColumns",tableColumns);
                    //component.set("v.shipToPartyTableConfig",tableConfig);
                    // }

                    var custbtn = component.find("itemShip");
                    if (response.getReturnValue() != null) {
                        component.set("v.shipToPartyList", response.getReturnValue());
                        if (response.getReturnValue().length == 1) {
                            custbtn.set("v.disabled", true);
                            var list = response.getReturnValue();

                            component.set("v.selItem5", list[0]);
                            component.set("v.newSalesOrder.Ship_To_Party__c", list[0].Id);
                            var shipLoc = component.find("itemShipToParty");

                            shipLoc.set("v.errors", null);
                            $A.util.removeClass(shipLoc, "error");
                            // this.closePopUp(component);
                        }

                        if (response.getReturnValue().length > 1) {
                            custbtn.set("v.disabled", false);
                            component.set("v.shipToPartyTableColumns", tableColumns);
                            component.set("v.shipToPartyTableConfig", tableConfig);
                            //initialize the datatable
                            component.find("shipartyTable").initialize({
                                order: [0, "desc"],
                                itemMenu: ["5", "10", "25", "50"],
                                "itemsPerPage:": 5,
                            });
                        }
                    } else {
                        console.log("error");
                        var toastMsgs = $A.get(
                            "$Label.c.There_is_no_Ship_to_Party_option_available_for_this_Customer"
                        );
                        this.showWarningToast(component, event, toastMsgs);
                    }

                    //custbtn.set('v.disabled',false);
                    //initialize the datatable

                    /*  component.find("shipartyTable").initialize({
                                         "order":[0,"desc"],
                                         "itemMenu":["5","10","25","50"],
                                         "itemsPerPage:":5
                                     });  */
                }
            });
            $A.enqueueAction(action);
        } else {
            // var toastMsgs = $A.get("$Label.c.No_Customer_Available");
            //  this.showWarningToast(component, event, toastMsgs);
        }
    },
    fetchPriceBookDetails: function (component) {
        var motherOrderId = component.get("v.newSalesOrder.Sales_Order__c");
        //console.log('motherOrderId: '+motherOrderId);
        //alert('SOM Id'+motherOrderId);
        var action;
        var priceDetailTableColumns;

        var selAccount = component.get("v.selItem");
        var orderType = component.get("v.newSalesOrder.Type_of_Order__c");

        var accountState = "";
        //console.log('filled selItem: '+selAccount);

        if (selAccount) {
            accountState = selAccount.Customer_Region__c;
        }
        if (selAccount == null) {
            accountState = component.get(
                "v.newSalesOrder.Sold_to_Party__r.Customer_Region__c"
            );
        }

        console.log('motherOrderId: '+motherOrderId);
        //by HARSHIT@WIPRO
        if (motherOrderId != null && orderType == "BONIFICAÇÃO") {
            action = component.get("c.getMOPriceBookDetails");
            //Column data for the table
            priceDetailTableColumns = [
                {
                    label: $A.get("$Label.c.Product_Code"),
                    name: "skuCode",
                    type: "string",
                    resizeable: true,
                },
                {
                    label: $A.get("$Label.c.Name"),
                    name: "skuDescription",
                    type: "string",
                    resizeable: true,
                },
                {
                    label: $A.get("$Label.c.Category"),
                    name: "skuCategory",
                    type: "string",
                    resizeable: true,
                },
                {
                    label: $A.get("$Label.c.Brand_Name"),
                    name: "brand",
                    type: "string",
                    resizeable: true,
                },
                {
                    label: $A.get("$Label.c.Date_of_FAT"),
                    name: "fatDate",
                    type: "string",
                    resizeable: true,
                },
                /* {
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
}*/
            ];
        } else if (motherOrderId != null) {
            //alert("inside");
            action = component.get("c.getMOPriceBookDetails");
            //Column data for the table
            priceDetailTableColumns = [
                {
                    label: $A.get("$Label.c.Product_Code"),
                    name: "skuCode",
                    type: "string",
                    resizeable: true,
                },
                {
                    label: $A.get("$Label.c.Name"),
                    name: "skuDescription",
                    type: "string",
                    resizeable: true,
                },
                {
                    label: $A.get("$Label.c.Category"),
                    name: "skuCategory",
                    type: "string",
                    resizeable: true,
                },
                {
                    label: $A.get("$Label.c.Brand_Name"),
                    name: "brand",
                    type: "string",
                    resizeable: true,
                },
                {
                    label: $A.get("$Label.c.Date_of_FAT"),
                    name: "fatDate",
                    type: "string",
                    resizeable: true,
                },
                {
                    label: $A.get("$Label.c.Qty"),
                    name: "qty",
                    type: "string",
                    resizeable: true,
                },
                {
                    label: $A.get("$Label.c.Balance"),
                    name: "balanceQty",
                    type: "string",
                    resizeable: true,
                },
                {
                    label: "%",
                    name: "percUsed",
                    type: "string",
                    resizeable: true,
                } /*
             {
                 'label': $A.get("$Label.c.Unit_Value_With_Interest"),
                 'name':'unitValueWithInterest',
                 'type':'string',              
                 'resizeable':true
             }*/,
            ];
        }

        //---------END
        else {
            action = component.get("c.getPriceBookDetails");
            //Column data for the table
            priceDetailTableColumns = [
                {
                    label: $A.get("$Label.c.Product_Code"),
                    name: "skuCode",
                    type: "string",
                    resizeable: true,
                },
                {
                    label: $A.get("$Label.c.Name"),
                    name: "skuDescription",
                    type: "string",
                    resizeable: true,
                },
                {
                    label: $A.get("$Label.c.Category"),
                    name: "skuCategory",
                    type: "string",
                    resizeable: true,
                },
                {
                    label: $A.get("$Label.c.Brand_Name"),
                    name: "brand",
                    type: "string",
                    resizeable: true,
                },
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
            massSelect: false,
            globalAction: [],
            searchByColumn: true,
            rowAction: [
                {
                    label: $A.get("$Label.c.Select"),
                    type: "url",
                    id: "selectproduct",
                },
            ],
        };
        var priceBookId = "";
        var isChecked = component.get("v.CampaignCheck"); //component.find("campChk").get("v.value");
        var cmpTp = component.get("v.newSalesOrder.Campaign_Type__c");
                console.log('component.get("v.newSalesOrder)==>',component.get("v.newSalesOrder"));
        if (isChecked && cmpTp == "Simple") {
            //priceBookId = component.get("v.campaignId");
            //alert();
            //component.set("v.newSalesOrder.Price_Book__c",priceBookId);
            priceBookId = component.get("v.newSalesOrder.Price_Book__c");
        } else {
            priceBookId = component.get("v.newSalesOrder.Price_Book__c");
        }

        var depotCode = component.get("v.selItem.Depot_Code__c");
        if (depotCode == null) {
            depotCode = component.get(
                "v.newSalesOrder.Sold_to_Party__r.Depot_Code__c"
            );
        }

        // console.log('priceBookId2-: '+priceBookId);
        // console.log('depotCode2:- '+depotCode);
        // console.log('accountState: '+accountState);

        var orderId = component.get("v.recordId");
        var isSimulated = component.get("v.isSimulated"); //added by Sumit kumar for Ticket No. RITM0518333
        if (motherOrderId != null) {
            action.setParams({
                priceBookId: priceBookId,
                motherOrderId: motherOrderId,
                depotCode: depotCode,
                accountState: accountState,
                orderId: orderId,
                withDraft: true,
                isSimulated: isSimulated, //added by Sumit kumar for Ticket No. RITM0518333
            });
        } else {
            var accid = component.get("v.newSalesOrder.Sold_to_Party__c"); ////Added by Sayan, 20th July, RITM0234559
            action.setParams({
                priceBookId: priceBookId,
                depotCode: depotCode,
                accountState: accountState,
                accid: accid, //Added by Sayan, 20th July, RITM0234559
                isSimulated: isSimulated, //added by Sumit kumar for Ticket No. RITM0518333
            });
        }

        //show spinner to true on click of a button / onload
        //component.set("v.showSpinner", true);

        action.setCallback(this, function (resp) {
            //on call back make it false ,spinner stops after data is retrieved
            //component.set("v.showSpinner", false);

            var state = resp.getState();

            //console.log('PriceBook getState(): '+JSON.stringify(resp.getState()));
            //console.log('PriceBook getReturnValue(): '+JSON.stringify(resp.getReturnValue()));

            if (component.isValid() && state == "SUCCESS") {

                //pass the records to be displayed
                component.set("v.priceDetailList", resp.getReturnValue());
                console.log('MO Item List', component.get("v.priceDetailList"), priceBookId, motherOrderId, depotCode, accountState, orderId, true);
                //Start Map
                if (motherOrderId != null) {
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
                component.set("v.priceDetailTableColumns", priceDetailTableColumns);
                //pass the configuration of task table
                component.set("v.priceDetailTableConfig", priceDetailTableConfig);
                //Modified by Deeksha for kit selling Project
                var priceDetailList = component.get("v.priceDetailList");
                if (priceDetailList.length) {
                    component.set(
                        "v.newSalesOrder.Kit_Order__c",
                        priceDetailList[0].kitProduct
                    );
                }
                //initialize the datatable
                component.find("priceDetailsTable").initialize({
                    order: [0, "desc"],
                    itemMenu: ["5", "10", "25", "50"],
                    "itemsPerPage:": 5,
                });
            } else {
                //console.log(resp.getError());
            }
        });

        $A.enqueueAction(action);
    },

    //Re-intializing Pricebook Table
    fetchServerPriceBookDetails: function (component, priceList) {
        //Column data for the table
        var priceDetailTableColumns = [
            {
                label: $A.get("$Label.c.Product_Code"),
                name: "skuCode",
                type: "string",
                resizeable: true,
            },
            {
                label: $A.get("$Label.c.Name"),
                name: "skuDescription",
                type: "string",
                resizeable: true,
            },
            {
                label: $A.get("$Label.c.Date_of_FAT"),
                name: "fatDate",
                type: "string",
                resizeable: true,
            },
            {
                label: $A.get("$Label.c.Qty"),
                name: "qty",
                type: "string",
                resizeable: true,
            },
            {
                label: $A.get("$Label.c.Balance"),
                name: "balanceQty",
                type: "string",
                resizeable: true,
            },
            {
                label: "%",
                name: "percUsed",
                type: "string",
                resizeable: true,
            },
            {
                label: $A.get("$Label.c.Unit_Value_With_Interest"),
                name: "unitValueWithInterest",
                type: "string",
                resizeable: true,
            },
        ];

        //Configuration data for the table to enable actions in the table
        var priceDetailTableConfig = {
            massSelect: false,
            globalAction: [],
            searchByColumn: true,
            rowAction: [
                {
                    label: $A.get("$Label.c.Select"),
                    type: "url",
                    id: "selectproduct",
                },
            ],
        };

        component.set("v.priceDetailList", priceList);

        //pass the column information
        component.set("v.priceDetailTableColumns", priceDetailTableColumns);
        //pass the configuration of task table
        component.set("v.priceDetailTableConfig", priceDetailTableConfig);

        //initialize the datatable
        component.find("priceDetailsTable").initialize({
            order: [0, "desc"],
            itemMenu: ["5", "10", "25", "50"],
            "itemsPerPage:": 5,
        });

        this.validateSOCBeforeSave(component);
    },

    getPBPayMent: function (component, event, pb_id) {
        // show spinner to true on click of a button / onload
        //alert('helper');
        component.set("v.showSpinner", true);
        var isavec = component.get("v.isAvec");
        var campaignType = component.get("v.newSalesOrder.Campaign_Type__c");
        //alert(campaignType);
        var action = component.get("c.getPBPaymentTerms");

        action.setParams({
            priceBook_id: pb_id,
        });

        var opts = [];
        //action.setStorable();
        action.setCallback(this, function (a) {
            // on call back make it false ,spinner stops after data is retrieved
            component.set("v.showSpinner", false);
            console.log(
                "The SpiinerShow getPBPayMent",
                component.get("v.showSpinner")
            );
            var state = a.getState();
            var blkDt = "";
            var flag = true;

            var today = new Date();
            var dd = (today.getDate() < 10 ? "0" : "") + today.getDate();
            var MM = (today.getMonth() + 1 < 10 ? "0" : "") + (today.getMonth() + 1);
            var yyyy = today.getFullYear();

            // Custom date format for ui:inputDate
            var currentDate = yyyy + "-" + MM + "-" + dd;

            if (state == "SUCCESS") {
                var returnValue = a.getReturnValue();
                component.set("v.pbPaymentTerms", returnValue);

                if (returnValue.priceBook != null) {
                    component.set(
                        "v.interestDate",
                        returnValue.priceBook.Interest_Date__c
                    );
                    component.set(
                        "v.blockDate",
                        returnValue.priceBook.Sales_Order_Block_Date__c
                    );
                    blkDt = returnValue.priceBook.Sales_Order_Block_Date__c;
                }

                if (blkDt != null || blkDt != "") {
                    if (blkDt < currentDate) {
                        flag = false;

                        /***** GRZ(Nikhil Verma) INC0399208 14-10-2022****/
                        var toastMsg = $A.get("{!$Label.c.Block_Date_Reached}");
                        var titl = $A.get("{!$Label.c.Error}");
                        this.genericToast(component, event, titl, toastMsg);
                        /***** End------------ INC0399208 GRZ(Nikhil Verma) 14-10-2022****/

                        if (isavec) {
                            component.find("priceListOptions").set("v.value", "None");
                        } else {
                            component.find("Campaign").set("v.value", "None");
                        }
                        component.set("v.blockDate", null);
                        if (isavec) {
                            component.find("priceListOptions").focus();
                        } else {
                            component.find("Campaign").focus();
                        }
                    }
                }
                if (flag == true) {
                    if (!isavec) {
                        if (component.find("Campaign").get("v.value") != "None") {
                            var inputCmp = component.find("Campaign");
                            inputCmp.set("v.errors", null);
                            $A.util.removeClass(inputCmp, "error");
                        }
                    } else {
                        if (component.find("priceListOptions").get("v.value") != "None") {
                            var inputCmp = component.find("priceListOptions");
                            inputCmp.set("v.errors", null);
                            $A.util.removeClass(inputCmp, "error");
                        }
                    }
                    var isreload = component.get("v.showOnReLoad");
                    //Payment Terms Map Day
                    if (returnValue.payTermsDays != null) {
                        opts = [];
                        opts.push({
                            class: "optionClass",
                            label: $A.get("$Label.c.None"),
                            value: "None",
                        });
                        var paymentTermsMap = returnValue.payTermsDays;

                        for (var key in paymentTermsMap) {
                            if (key != "null null") {
                                opts.push({ class: "optionClass", label: key, value: key });
                            }
                        }
                        // console.log('Payment Terms:'+JSON.stringify(opts));
                        component.set("v.paymentTermsMapDY", paymentTermsMap);
                        if (!isreload) {
                            // component.find("payTmdy").set("v.options", opts);
                        }
                    }
                    //End

                    //Payment Terms Map Date
                    if (returnValue.payTermsDates != null) {
                        opts = [];
                        opts.push({
                            class: "optionClass",
                            label: $A.get("$Label.c.None"),
                            value: "None",
                        });
                        var paymentTermsMapDT = returnValue.payTermsDates;

                        for (var key in paymentTermsMapDT) {
                            if (key != "null") {
                                opts.push({ class: "optionClass", label: key, value: key });
                            }
                        }
                        //Payment Terms BR71...
                        var isOrdemFilha = component.get("v.isOrdemFilha");
                        if (campaignType == "Simple" || isavec) {
                            if (returnValue.payTermBR71 != null) {
                                var paymentTermBR71 = returnValue.payTermBR71;
                                var val =
                                    paymentTermBR71.Payment_Term_Code__c +
                                    " " +
                                    paymentTermBR71.Payterms_Desc__c;
                                opts.push({ class: "optionClass", label: val, value: val });
                                component.set("v.paymentTermBR71", paymentTermBR71);
                                if (isOrdemFilha == true) {
                                    var opts11 = [];
                                    opts11.push({ class: "optionClass", label: val, value: val });
                                }
                            }
                        }
                        //  console.log('Payment Terms Date:'+JSON.stringify(opts));
                        component.set("v.paymentTermsMapDT", paymentTermsMapDT);
                        if (!isreload) {
                            component.find("payTmDt").set("v.options", opts);
                            if (isOrdemFilha == true) {
                                component.find("payTmDt").set("v.options", opts11);
                            }
                        }
                    }
                    //End
                }
                //Commented by Rakesh K G RITM0411468 onload display of number of days and fixed date	
                //Commented since at last all the value will be set to null or it will be replaced by paymentTermsMapDY	
                /*var opts=[];	
opts=[];	
opts.push({"class": "optionClass", label: $A.get("$Label.c.None"), value: 'None'});  	
var paymentTermsMap = component.get("v.paymentTermsMapDY"); //chng	
 
for (var key in paymentTermsMap){	
if(key != 'null null'){	
    opts.push({"class": "optionClass", label: key, value: key});	
}	
}     	
console.log('Payment Terms:123:5240'+JSON.stringify(opts));	
component.set("v.paymentTermsMapDY", paymentTermsMap);	
component.find("payTmdy").set("v.options", opts);	
//Updated by Rakesh K G Incident - No INC0358834 onload display of number of days	
component.set("v.paymentTermDY", component.get("v.newSalesOrder.ReloadPaymentTerms__c"));	
//End*/
            }
        });
        $A.enqueueAction(action);
    },
    fetchStructureCampaign: function (component, event, campaignId, orderId) {
        var action = component.get("c.fetchStructureCampaign");
        action.setParams({
            structCampId: campaignId,
            soId: orderId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("state>>--->" + JSON.stringify(response.getError()));
            if (state == "SUCCESS") {
                var returnResult = response.getReturnValue();
                component.set("v.structureCampWrapDetail", returnResult);
                component.set("v.listCampaignGrp", returnResult.listCampaignGroup);
                component.set("v.showSpinner", false);
                //alert('orderId>>>'+orderId);
                if (orderId != "" && orderId != null) {
                    component.set("v.isLoadData", true);
                    var childcmp = component.find("structComponent");
                    childcmp.loadcalculations(orderId);
                }
            }
        });
        $A.enqueueAction(action);
    },
    saveStructureSalesOrder: function (component, event, status) {
        var listStructOrderItems = component.get(
            "v.structureCampWrapDetail.saveListStructOrderLineItem"
        );
        console.log("listStructOrderItems", listStructOrderItems);
        var structOrderItemData = component.get(
            "v.structureCampWrapDetail.lstStructOrderLineItem"
        );
        var toastMsg = "";
        if (status == "Submitted") {
            console.log("order Submitted");
            component.set("v.newSalesOrder.Order_Status__c", "Submitted");
        } else if (status == "Draft") {
            component.set("v.newSalesOrder.Order_Status__c", "Draft");
        }
        var salesorderId = component.get("v.newSalesOrder.Id");
        // alert('file'+salesorderId);
        var salesOrder = component.get("v.newSalesOrder");
        console.log("salesOrder>>--->" + JSON.stringify(salesOrder));
        var action = component.get("c.saveStructuresalesOrder");
        component.set("v.showSpinner", true);
        //alert('orderType'+component.get("v.newSalesOrder.Type_of_Order__c"));
        action.setParams({
            soObj: salesOrder,
            structCampSoitemStr: JSON.stringify(listStructOrderItems),
            structsoitemData: JSON.stringify(structOrderItemData),
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("state>>--->" + JSON.stringify(response.getError()));
            //console.log('state>>--->'+JSON.stringify(response.getError()));
            if (state == "SUCCESS") {
                component.set("v.structureCampWrapDetail", response.getReturnValue());
                var recordId = response.getReturnValue().salesOrderObj.Id;
                component.set("v.recordId", recordId);
                component.set("v.parentId", recordId);
                var orderStatus =
                    response.getReturnValue().salesOrderObj.Order_Status__c;
                console.log(
                    "Total group Discount" +
                    response.getReturnValue().salesOrderObj.Total_Group_Discount__c
                );
                component.set(
                    "v.newSalesOrder",
                    response.getReturnValue().salesOrderObj
                );
                component.set(
                    "v.orderType",
                    response.getReturnValue().salesOrderObj.Type_of_Order__c
                );
                component.set("v.sfdcOrderNo", response.getReturnValue().sfdcOrderNo);
                var errorMessage =
                    response.getReturnValue().salesOrderObj.ErrorMessage__c;
                console.log("error msg:" + errorMessage);

                var defType = "pending";

                if (errorMessage != "" && errorMessage != undefined) {
                    toastMsg = errorMessage;
                    this.showErrorToast(component, event, toastMsg);
                } else {
                    //If User is owner of record & Order is a 'Simulation' or 'Draft' Order then enable delete
                    if (
                        response.getReturnValue().salesOrderObj.Order_Status__c == "Draft"
                    ) {
                        component.set("v.showDelete", true);
                    }
                }
                if (status == "Submitted") {
                    toastMsg = $A.get("$Label.c.Sales_Order_Created_Successfully");
                    this.showToast(component, event, toastMsg);

                    //Execute to save order on Submit button
                    //this.toggleConfirmDialog(component);
                    //this.showToast(component, event, toastMsg);
                    var profileName = component.get("v.orderFields.userObj.Profile.Name");
                    var fullUrl = "";
                    var defType = "";
                    //console.log('flagIm'+flagIm+'profileName'+profileName);
                    if (profileName == "Brazil Sales Person") {
                        fullUrl = "/apex/BrazilEnhancedListForSP?defType=" + defType;
                        this.gotoURL(component, fullUrl);
                    } else if (profileName == "Brazil Sales District Manager") {
                        fullUrl = "/apex/BrazilEnhancedListForSDM?defType=" + defType;
                        this.gotoURL(component, fullUrl);
                    } else if (profileName == "Brazil Sales Office Manager") {
                        fullUrl = "/apex/BrazilEnhancedListForSOM?defType=" + defType;
                        this.gotoURL(component, fullUrl);
                    }
                } else if (status == "Draft") {
                    toastMsg = $A.get("$Label.c.Sales_Order_Draft_Saved_Successfully");
                    //Execute to save order on Draft button
                    // this.toggleConfirmDialog(component);

                    //Execute to save as draft without flag check/rollback
                    this.showToast(component, event, toastMsg);
                    component.set("v.showOnReLoad", true);

                    /*var orderItemList = a.getReturnValue().soiList;
                                     if(orderItemList!=null && orderItemList!=undefined){
                                         component.set("v.orderItemList", orderItemList);
                                     }*/

                    var approvalList = response.getReturnValue().approvalList;
                    if (approvalList != null && approvalList != undefined) {
                        component.set("v.approvalList", approvalList);
                    }

                    var errorList = response.getReturnValue().errorList;
                    if (errorList != null && errorList != undefined) {
                        component.set("v.errorList", errorList);
                    }
                    //component.set("v.disableSaveStruct",true);
                    component.set("v.disableEditStruct", false);
                }
                var isSimulation = component.get("v.isSimulator");

                if (
                    salesorderId == null ||
                    salesorderId == "" ||
                    salesorderId == undefined
                ) {
                    if (isSimulation) {
                        //alert();
                        var file = component.find("fileId").get("v.files")[0];
                        this.readFile(component, file);
                    }
                }
            } else {
                toastMsg = $A.get(
                    "$Label.c.Some_error_has_occurred_while_Confirming_Order_Please_try_again"
                );
                this.showErrorToast(component, event, toastMsg);
            }
        });
        $A.enqueueAction(action);
        component.set("v.showSpinner", false);
        var orderId = component.get("v.recordId");
        //alert(orderId+'----'+status);
        if (orderId != "" && status == "Draft") {
            var childcmp = component.find("structComponent");
            childcmp.loadcalculations(orderId);
        }
    },

    readFile: function (component, file) {
        var reader = new FileReader();
        var self1 = this;
        reader.onload = $A.getCallback(function () {
            var fileContents = reader.result;
            var base64 = "base64,";
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method
            self1.uploadProcess(component, file, fileContents);
        });
        reader.readAsDataURL(file);
    },
    uploadProcess: function (component, file, fileContents) {
        // set a default size or startpostiton as 0
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value
        var endPosition = Math.min(
            fileContents.length,
            startPosition + this.CHUNK_SIZE
        );
        //console.log('Filelist>>--->'+filelist);
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(
            component,
            file,
            fileContents,
            startPosition,
            endPosition,
            ""
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
            parentId: component.get("v.parentId"),
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
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
                    // component.set("v.showLoadingSpinner", false);
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
    //added by Swapnil - to update price list based on Seller selection
    UpdatePriceList: function (component, userId) {
        console.log("selected user1 " + userId);
        //added by Swapnil
        if (component.get("v.orderType") != "ORDEM FILHA") {
            component.set("v.selectedCurrency", "None");

            component.set("v.orderFields.priceList", "");
            if (
                userId != undefined &&
                userId.includes($A.get("$SObjectType.CurrentUser.Id"))
            ) {
                userId = $A.get("$SObjectType.CurrentUser.Id");
            }
            var action = component.get("c.getPriceListValuesSalesRep");
            console.log("selected user " + userId);
            action.setParams({ SalesRepId: userId });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log("state" + state);
                if (state === "SUCCESS") {
                    console.log("response.getReturnValue " + response.getReturnValue());
                    component.set("v.orderFields.priceList", response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
        }
    },
    //Modified by Deeksha for kit selling Project
    RemoveComponentRow: function (component, kitNo) {
        var orderItemList = component.get("v.orderItemList");
        var kitOrder = component.get("v.newSalesOrder.Kit_Order__c");
        var len = orderItemList.length;
        for (var idx = 0; idx < len; idx++) {
            if (orderItemList[idx].refKitNo == kitNo && kitOrder) {
                orderItemList.splice(idx, 1);
                component.set("v.orderItemList", orderItemList);
                this.RemoveComponentRow(component, kitNo);
                break;
            }
        }
        //component.set("v.orderItemList", orderItemList);
    },
    //Modified by Deeksha for kit selling Project
    AddComponentRow: function (
        component,
        event,
        helper,
        componentPB,
        selCurrncy,
        kitNo,
        fSPVal,
        profileName,
        kitSKU
    ) {
        //this.RemoveComponentRow(component,helper,kitNo);
        var unitVal = 0;
        var minVal = 0;
        var fSPVal = 0;
        var monthlyInterestRate = 0;
        if (selCurrncy == "Billing BRL / Payment BRL") {
            //alert(itemRow.unitValueBRL);
            unitVal = componentPB.unitValueBRL;
            minVal = componentPB.minValueBRL;
            monthlyInterestRate = componentPB.monthlyInterestRateBRL;
            //  alert(itemRow.budgetValueBRL);
            fSPVal = componentPB.budgetValueBRL;
        } else if (
            selCurrncy == "Billing USD / Payment BRL" ||
            selCurrncy == "Billing USD / Payment USD"
        ) {
            //alert(itemRow.unitValueUSD);
            unitVal = componentPB.unitValueUSD;
            minVal = componentPB.minValueUSD;
            monthlyInterestRate = componentPB.monthlyInterestRateUSD;
            fSPVal = componentPB.budgetValueUSD;
        }
        var orderItem = {
            productId: "",
            priceBookDetailId: "",
            productName: "",
            fatDate: "",
            qty: "",
            listValue: "0",
            unitValue: "",
            unitValueWithInterest: "0",
            totalValue: "0",
            totalValueWithInterest: "0",
            interestRate: "0",
            days: "0",
            timeInMonths: "0",
            // minDate:"",//Priya
            skuCategory: "",
            replacementMargin: 0,
            discount: 0,
            brand: "",
            minValue: 0,
            POItemNumber: "",
            kitProduct: false,
            cancellationReason: cancellationReason//added by tanuj >> 6 feb 2023
            //cultureDesc:""
        };
        orderItem.refKitNo = kitNo;
        orderItem.cancellationReason = cancellationReason;
        orderItem.kitProduct = componentPB.kitProduct; //Modified by Deeksha for kit selling Project
        orderItem.productId = componentPB.skuId;
        orderItem.productName = componentPB.skuDescription;
        orderItem.skuCategory = componentPB.skuCategory;
        //orderItem.minDate = componentPB.minDate;//Priya
        orderItem.itemCategory = componentPB.itemCategory; //Modified by Deeksha for kit selling Project
        orderItem.kitSKU = kitSKU;
        orderItem.brand = componentPB.brand; // for CR93......Nik...25/07/2019
        //alert(componentPB.unitValue);
        orderItem.unitValue = componentPB.unitValue; //INCTASK0189697 Date: 18.06.2020 Divya Singh
        orderItem.unitValueWithInterest = componentPB.unitValueWithInterest; //INCTASK0189697 Date: 18.06.2020 Divya Singh
        orderItem.totalValueWithInterest = componentPB.totalValueWithInterest; //INCTASK0189697 Date: 18.06.2020 Divya Singh
        orderItem.qty = componentPB.qty;
        orderItem.componentQty = componentPB.componentQty;
        //alert(componentPB.brand);
        orderItem.listValue = unitVal; //changed by Prashant
        // orderItem.listValue = componentPB.unitValue;
        if (fSPVal != null) {
            orderItem.budgetValue = fSPVal;
            //console.log('componentPB.BudgetValue='+componentPB.budgetValue+'-'+componentPB.unitValue);
        }
        //console.log('componentPB.pricebookId'+componentPB.pricebookId);
        orderItem.priceBookDetailId = componentPB.pricebookId;
        //console.log('orderItem.priceBookDetailId'+ orderItem.priceBookDetailId);
        orderItem.inventory = componentPB.balanceQty;
        orderItem.productCode = componentPB.skuCode;
        //orderItem.multipleOf = componentPB.multipleOf;
        orderItem.isMO = componentPB.isMO;

        var days = component.get("v.days");

        orderItem.days = days;

        //orderItemList[idx].qty = itemRow.qty;

        //if(days > 0){
        // monthlyInterestRate = itemRow.monthlyInterestRate;
        orderItem.days = days;
        //}

        var orderType = component.get("v.newSalesOrder.Type_of_Order__c");

        //if condition changed by Nik on 08/11/2019....CR106
        //profileName=='Brazil Sales Office Manager' || profileName=='Brazil Sales District Manager'

        if (profileName != "Brazil Sales Person") {
            orderItem.materialPlnRplc_Cost = componentPB.materialPlnRplcCost; // for CR92......Nik...22/07/2019
            orderItem.exchange_Rate = componentPB.exchangeRate; // for CR92......Nik...22/07/2019
            orderItem.currency_Code = componentPB.currencyCode; // for CR92......Nik...22/07/2019
            orderItem.create_Date = componentPB.create_Dt; // for CR92......Nik...22/07/2019
            orderItem.unitValueBRL = componentPB.unitValueBRL; // for CR92......Nik...22/07/2019
            orderItem.unitValueUSD = componentPB.unitValueUSD; // for CR92......Nik...22/07/2019
            orderItem.unitValue = componentPB.unitValue; // for CR92......Nik...22/07/2019
            orderItem.minValue = minVal; // for CR92 changes......Nik...27/07/2019
        }

        var orderType = component.get("v.newSalesOrder.Type_of_Order__c");

        if (orderType == "ORDEM FILHA") {
            orderItem.orderItemId = componentPB.orderItemId;
            orderItem.unitValue = unitVal;
            //alert(minVal);
            orderItem.unitValue = componentPB.unitValue;
            orderItem.unitValueWithInterest = componentPB.unitValueWithInterest;

            /* if(isProductArray){  
                  component.find("itemsel")[idx].set("v.disabled",true);  
              }
              else{
                  component.find("itemsel").set("v.disabled",true);  
              }*/

            if (!componentPB.orderItemId) {
                var toastMsg = "";
                toastMsg = $A.get("$Label.c.Order_Item_Id_not_found");
                helper.showErrorToast(component, event, toastMsg);
            }

            helper.validateOrderItems(component);
        } else {
            orderItem.minValue = minVal;
            if (orderItem.qty == "0") {
                orderItem.qty = "";
            }
        }

        orderItem.interestRate = monthlyInterestRate;
        var orderItemList = component.get("v.orderItemList");
        orderItemList.push(orderItem);
        var priceDetailList = component.get("v.priceDetailList");
        for (var idxy = 0; idxy < priceDetailList.length; idxy++) {
            if (priceDetailList[idxy].itemNo == orderItem.itemNo) {
                //console.log(' orderItem.qty-->'+ orderItem.qty);
                priceDetailList[idxy].balanceQty =
                    priceDetailList[idxy].balanceQty - orderItem.qty;
                //console.log(' priceDetailList[idxy].balanceQty-->'+  priceDetailList[idxy].balanceQty);
                //priceDetailList[idxy].percUsed = parseFloat(Math.abs((priceDetailList[idxy].balanceQty / priceDetailList[idxy].qty) *100)).toFixed(2);
                priceDetailList[idxy].percUsed = Math.abs(
                    (priceDetailList[idxy].balanceQty / priceDetailList[idxy].qty) * 100
                );
                break;
            }
        }
        component.set("v.priceDetailList", priceDetailList);
        component.set("v.orderItemList", orderItemList);
        //component.set("v.componentItemList",componentSoiList);
        return orderItem;
    },

    //Modified by Deeksha for kit selling Project
    CalculateComponentRow: function (component, event, helper) {
        var target = event.getSource();
        var rowIndex = target.get("v.labelClass");
        var orderItemList = component.get("v.orderItemList");
        var lastKitIndex;
        var sum = orderItemList[rowIndex].unitValue;
        for (var idx = 0; idx < orderItemList.length; idx++) {
            if (orderItemList[rowIndex].kitNo == orderItemList[idx].refKitNo) {
                orderItemList[idx].unitValue = (
                    (orderItemList[rowIndex].unitValue * orderItemList[idx].listValue) /
                    orderItemList[rowIndex].listValue
                ).toFixed(2);
                sum =
                    sum - orderItemList[idx].unitValue * orderItemList[idx].componentQty;
                lastKitIndex = idx;
            }
        }
        if (sum != 0) {
            //orderItemList[lastKitIndex].unitValue = (parseFloat(orderItemList[lastKitIndex].unitValue) + (parseFloat(sum))/orderItemList[lastKitIndex].componentQty).toFixed(2);
        }
        component.set("v.orderItemList", orderItemList);
    },
    //Added on 3/06/2021 for fecthing customerconversionfactor
    getCustomerConversionFactor: function (component, AccountId, productName) {
        console.log("**AccountId In CF =" + AccountId);
        var CF1 = component.get("v.CustomerConversionFactor");
        var CF = "";
        var action = component.get("c.getCustomerConversionFactor");
        action.setParams({
            AccountId: AccountId,
            productName: productName
        });
        // set call back
        action.setCallback(this, function (response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                console.log('In Success Conversion CF1 =' + CF);
                CF1 = response.getReturnValue();
                component.set("v.CustomerConversionFactor", CF1);
                console.log('CF1 helper*******', CF1);
                var orderItemList = component.get('v.orderItemList');
                orderItemList.forEach(function (item) {
                    if (item.brand == component.get('v.currentProductName')) {
                        item.conversionFactor = CF1;
                    }
                });
                console.log('In Success Conversion 1 =' + response.getReturnValue());
                // component.set("v.CF",CF);  
                //component.set("v.CustomerConversionFactor",'bnn'); 
                console.log('In Success Conversion 2 =' + response.getReturnValue());
                console.log('In Success Conversion 24 =' + component.get("v.CustomerConversionFactor"));

            }

            else if (state === "ERROR") {
                console.log('In Error Conversion Error =' + response.getReturnValue());
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
        console.log("In Success Conversion CF2 =" + CF);
        //component.set("v.CustomerConversionFactor", "bnn");
        //component.set("v.CF", CF);
        // enqueue the action
        $A.enqueueAction(action);
    },
    // Added by Krishanu And Ankita @ Wipro
    getSelloutprice: function (component, Brand, unitPrice, productname) {

        var pbd = component.get("v.priceDetailList");
        var ER = component.get("v.exchangeRate");
        var skuid;
        pbd.forEach(function (pbdi) {
            if (pbdi.brand == Brand) {
                skuid = pbdi.skuId;
            }
        });
        console.log('sell out****', Brand, unitPrice, productname);
        var orderItemList = component.get('v.orderItemList');
        var action = component.get('c.getReplacementCost');
        action.setParams({
            skuid: skuid
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {

                console.log(orderItemList);
                orderItemList.forEach(function (item) {
                    if (item.productName == productname) {
                        console.log(item, item.conversionFactor);
                        let cfunitval = unitPrice * item.conversionFactor;
                        var rep = response.getReturnValue();;
                        if (item.curncyCode == 'Only BRL') {
                            rep = rep * ER;
                        }
                        var gm = ((cfunitval * 0.96) - rep) / (cfunitval * 0.96);
                        console.log('rep cost:', cfunitval, rep, gm);
                        gm *= 100;
                        gm = Math.round(gm);
                        var type;
                        if (gm >= 60) {
                            type = 'Gold';
                        } else if (gm < 60 && gm >= 40) {
                            type = 'A';
                        } else if (gm < 40 && gm >= 20) {
                            type = 'B';
                        } else {
                            type = 'C';
                        }
                        var factor;
                        var smat = component.get('v.selloutMatrix');
                        smat.forEach(function (item2) {
                            if (item2.Type__c == type) {
                                factor = item2.Sell_Out_Factor__c;

                            }
                        });
                        console.log(factor, cfunitval, parseFloat(item.conversionFactor));
                        console.log(json.stringyfy(component.get("v.priceDetailList")));
                        // item.selloutprice = cfunitval+(cfunitval*factor/100);
                        if (item.curncyCode == 'Only BRL') {
                            item.selloutprice = parseFloat(pbd.selloutprice);
                            console.log(' item.selloutprice**** ' + pbd.selloutprice);
                        }
                        else {
                            item.selloutprice = parseFloat(pbd.selloutpriceU);
                            console.log(' item.selloutpriceU*** ' + pbd.selloutprice);
                        }
                        item.selloutprice = parseFloat(pbd.selloutprice);
                        var sellout = component.find('sellout');
                        if (Array.isArray(sellout)) {
                            sellout.forEach(function (each) {
                                console.log(each.get('v.value'));
                            });
                        } else {
                            console.log(sellout.get('v.value'));
                        }

                    }
                });
                console.log(orderItemList);
            }
        });
        $A.enqueueAction(action);


    },
    // Added by Krishanu And Ankita @ Wipro
    getSelloutpriceReload: function (component, Brand, curr, productname) {

        // var orderItemList = component.get("v.orderItemList");      
        // var pname = orderItemList.productName;
        var orderItemList = component.get('v.orderItemList');

        console.log(orderItemList);
        orderItemList.forEach(function (item) {
            if (item.productName == productname) {
                var cfunitval;
                var pbd = component.get("v.priceDetailList");
                var ER = component.get("v.exchangeRate");
                var rep;
                pbd.forEach(function (pbdi) {
                    console.log(pbdi);
                    if (pbdi.brand == item.brand) {
                        rep = pbdi.materialPlnRplcCostbr00;
                        let price;
                        if (curr == 'BRL') {
                            rep = rep * ER;
                            price = pbdi.unitValueBRL;
                        } else {
                            price = pbdi.unitValueUSD;
                        }
                        cfunitval = price * pbdi.custconversionfator;
                    }
                });
                var gm = ((cfunitval * 0.96) - rep) / (cfunitval * 0.96);
                console.log('rep cost', rep, gm);
                gm *= 100;
                var gm = Math.round(gm);
                var type;
                if (gm >= 60) {
                    type = 'Gold';
                } else if (gm < 60 && gm >= 40) {
                    type = 'A';
                } else if (gm < 40 && gm >= 20) {
                    type = 'B';
                } else {
                    type = 'C';
                }
                var factor;
                var smat = component.get('v.selloutMatrix');
                smat.forEach(function (item2) {
                    if (item2.Type__c == type) {
                        factor = item2.Sell_Out_Factor__c;

                    }
                });
                console.log(factor, cfunitval, parseFloat(item.conversionFactor));
                //item.selloutprice = cfunitval+(cfunitval*factor/100);
                if (item.curncyCode == 'Only BRL') {
                    item.selloutprice = parseFloat(pbd.selloutprice);
                    console.log(' item.selloutprice**** ' + pbd.selloutprice);
                }
                else {
                    item.selloutprice = parseFloat(pbd.selloutpriceU);
                    console.log(' item.selloutpriceU*** ' + pbd.selloutprice);
                }

                var sellout = component.find('sellout');
                if (Array.isArray(sellout)) {
                    sellout.forEach(function (each) {
                        console.log(each.get('v.value'));
                    });
                } else {
                    console.log(sellout.get('v.value'));
                }

            }
        });
        console.log(orderItemList);




    },

    CalculateComponentTotal: function (component, event, helper) {
        var orderItemList = component.get("v.orderItemList");
        var total = 0;
        for (var id = 0; id < orderItemList.length; id++) {
            if (orderItemList[id].kitProduct) {
                var lastKitIndex;
                var sum = orderItemList[id].totalValueWithInterest;
                for (var idx = 0; idx < orderItemList.length; idx++) {
                    if (orderItemList[id].kitNo == orderItemList[idx].refKitNo) {
                        sum = sum - orderItemList[idx].totalValueWithInterest;
                        lastKitIndex = idx;
                        //total = parseFloat(total) + parseFloat(orderItemList[idx].totalValueWithInterest);
                    }
                }
                if (sum != 0 && sum != orderItemList[id].totalValueWithInterest) {
                    orderItemList[lastKitIndex].totalValueWithInterest = (
                        parseFloat(orderItemList[lastKitIndex].totalValueWithInterest) +
                        parseFloat(sum)
                    ).toFixed(2);
                    orderItemList[lastKitIndex].round = parseFloat(sum).toFixed(2);
                }
                total =
                    parseFloat(total) +
                    parseFloat(orderItemList[id].totalValueWithInterest);
            }
        }
        component.set("v.totalValue", total);
        component.set("v.orderItemList", orderItemList);
    },

    //code for logged in user;s region check by Sagar@wipro
    isbrazilusercheck: function (component) {
        var action = component.get("c.isBrazilUsercheck");
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state == "SUCCESS") {
                var isbraziluser = a.getReturnValue();
                console.log("isbrazilusercheck" + isbraziluser);
                component.set("v.isbraziluser", isbraziluser);
            }
        });
        $A.enqueueAction(action);
    },

    isBrazilSalesUser: function (component) {
        var action = component.get("c.isBrazilSalesUsercheck");
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state == "SUCCESS") {
                var isbraziluser1 = a.getReturnValue();
                console.log("isBrazilSalesUser" + isbraziluser1);
                component.set("v.isbraziluser1", isbraziluser1);
            }
        });
        $A.enqueueAction(action);
    },

    cogsupdatecall: function (component, ordercustomer, prodid) {
        // alert("Help22");
        console.log("ordercustomer**>>cogs", ordercustomer);
        console.log("prodid**>>cogs", prodid);
        var action = component.get("c.cogsValueUpdate");
        action.setParams({
            productid: prodid,
            customer1: ordercustomer
        });
        // alert('Help33');
        //calling the server side method
        action.setCallback(this, function (response) {
            //  alert('Help44');
            var state = response.getState();
            var toastMsg = "";
            var flag = response.getReturnValue();
            console.log("res**", response.getReturnValue());
            console.log("resstate**", response.getState());
            //alert('Help55');
            if (state == "SUCCESS") {
                // alert('Help66');
                console.log("SUCCESS**>>cogs");
                console.log("cogs**", response.getReturnValue());
                component.set("v.cogsvalue", response.getReturnValue());
            } else {
                console.log("TestResError**", response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    //cropculvalues by Ankita@Wipro
    cropculvalues: function (component, ordercustomer, pbid1) {
        console.log("prodid**>>cogs", pbid1);
        console.log("ordercustomer**>>cogs", ordercustomer);
        var ordertype = component.get("v.orderType");
        var motherOrderId = component.get("v.newSalesOrder.Sales_Order__c");
        var action = component.get("c.getCultureDesc");
        action.setParams({
            pbid: pbid1,
            ordertype: ordertype,
            motherOrderId: motherOrderId,
        });

        //calling the server side method
        action.setCallback(this, function (response) {
            var state = response.getState();
            var toastMsg = "";
            var flag = response.getReturnValue();
            console.log("res**", response.getReturnValue());
            console.log("resstate**", response.getState());
            if (state == "SUCCESS") {
                console.log("cultureDescList**", response.getReturnValue());
                //component.set("v.cogsvalue",response.getReturnValue());
                component.set("v.cultureDescList", response.getReturnValue());
            } else {
                console.log("TestResError**", response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    getPricebookCreatedDate: function (component) {
        var plist = component.get("c.getPriceBookValues");

        plist.setParams({
            pb_id: component.get("v.pbid"),
        });
        plist.setCallback(this, function (a) {
            var result = a.getReturnValue();
            if (a.getState() == "SUCCESS") {
                component.set("v.createdDatePB", result.CreatedDate);
                component.set("v.currencyType", result.Currency__c);
                console.log(component.get("v.createdDatePB"));
            }
        });
        $A.enqueueAction(plist);
    },
    //get min value and max Discount by Ankita & Krishanu @Wipro
    getMinValMaxDisc: function (component) {
        var minValDisc = component.get("c.getMinValDisc");
        minValDisc.setParams({
            typeval: component.get("v.orderType"),
        });
        minValDisc.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                console.log(response.getReturnValue().MinValUSD);
                component.set("v.minValue", response.getReturnValue().MinVal);
                component.set("v.minValueUSD", response.getReturnValue().MinValUSD);
                component.set("v.maxDiscount", response.getReturnValue().MaxDisc);
            }
        });
        $A.enqueueAction(minValDisc);
    },
    //get Conversion Factor by Ankita & Krishanu @Wipro
    getConversionFactorValue: function (component, accid) {
        var action = component.get("c.getCustomerConversionFactor");
        console.log("Checking 1");
        action.setParams({
            AccountId: accid,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set("v.ConversionFactorValue", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    //Added by Ankita & Krishanu @WIPRO
    getSellOutMatrix: function (component, event, helper) {
        var action = component.get("c.getSelloutMinpriceFactor");
        action.setCallback(this, function (response) {
            var state = response.getState();
            //console.log("test", state);
            if (state === "SUCCESS") {
                component.set("v.selloutMatrix", response.getReturnValue());
                console.log(component.get("v.selloutMatrix"));
            }
        });
        $A.enqueueAction(action);
    },
    //Added by Ankita & Krishanu @WIPRO
    getExchangeRate: function (component, event, helper) {
        var action = component.get("c.latestExchangeRate");
        action.setCallback(this, function (response) {
            var state = response.getState();
            //console.log("test", state);
            if (state === "SUCCESS") {
                component.set("v.exchangeRate", response.getReturnValue());
                console.log(component.get("v.exchangeRate"));
            }
        });
        $A.enqueueAction(action);
    },

    // Added by Sagar@Wipro for StatusOrdemVendas API Call
    SKUUpdateAPI: function (component, event, helper) {
        var action = component.get("c.SKUUpdateAPI");
        console.log('recordId API --> ' + component.get("v.recordId"));
        action.setParams({
            "soId": component.get("v.recordId")
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state == "SUCCESS") {
                // var isbraziluser1 = a.getReturnValue();
                console.log('Order Status API Call Success');
                // component.set("v.isbraziluser1", isbraziluser1);                
            }
        });
        $A.enqueueAction(action);
    },
    /*showRowDetails: function(row) {
alert('row selected - '+row.Name);
this.toggle(component);   
},*/
    /* ************************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022...Start. ************************ */
    getTaxAndFreight: function (component) {

        if (component.get("v.selItem.Customer_Region__c") != null) {
            component.set("v.showSpinner", true);
            var action = component.get("c.getCustomerTaxFreight");
            action.setParams({
                regnName: component.get("v.selItem.Customer_Region__c")
            });

            action.setCallback(this, function (a) {
                var state = a.getState();
                if (state == "SUCCESS") {
                    component.set("v.customerTaxFreight", a.getReturnValue());
                }
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }
    },
    /* ************************* SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022....End ***************************** */

    /***** GRZ(Nikhil Verma) INC0399208 14-10-2022 Generic Toast method to handle lightning toast and to handle when component is called in VF *****/
    // Note: Shows a javascript alert in case the component is loaded within a visualforce page
    genericToast: function (component, event, titl, toastMsg) {
        var toastEvent = $A.get("e.force:showToast");
        if (toastEvent != undefined) {
            toastEvent.setParams({
                title: titl,
                type: 'Error',
                duration: '3000',
                message: toastMsg
            });
            toastEvent.fire();
        }
        else {
            alert(titl + ': ' + toastMsg);
        }
    },
    /***** GRZ(Nikhil Verma) INC0399208 14-10-2022 ********* End ********/
    isSOCancelProcess: function (component) {
        var action = component.get("c.isSOCancelProcessCheck");
        action.setParams({
            soId: component.get("v.recordId")
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state == "SUCCESS") {
                var isSOCancelProcess1 = a.getReturnValue();
                console.log("isSOCancelProcess" + isSOCancelProcess1);
                component.set("v.isSOCancelProcess", isSOCancelProcess1);
                console.log('isSOCancelProcess --> ' + component.get("v.isSOCancelProcess"));
            }
        });
        $A.enqueueAction(action);
    },


    isSOItemsEditProcess: function (component) {
        var action = component.get("c.isSOItemsEditProcessCheck");
        action.setParams({
            soId: component.get("v.recordId")
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state == "SUCCESS") {
                var isSOItemsEditProcess1 = a.getReturnValue();
                console.log("isSOItemsEditProcess" + isSOItemsEditProcess1);
                component.set("v.isSOItemsEditProcess", isSOItemsEditProcess1);
                console.log('isSOItemsEditProcess --> ' + component.get("v.isSOItemsEditProcess"));
            }
        });
        $A.enqueueAction(action);
    },
    /*Added by Shubham 10the Feb*/
    getCurrentUserAppoval: function (component, event) {
        console.log('Approve method hit');

        var action = component.get("c.checkApproval");
        action.setParams({
            recordid: component.get("v.recordId"),
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state == "SUCCESS") {
                var actionResponse = a.getReturnValue();
                console.log("actionResposne----@@@@@", actionResponse + 'deeee' + component.get("v.recordId"));
                component.set("v.IsApprovalPending", actionResponse);
              
            }
        });
        $A.enqueueAction(action);
    },

})