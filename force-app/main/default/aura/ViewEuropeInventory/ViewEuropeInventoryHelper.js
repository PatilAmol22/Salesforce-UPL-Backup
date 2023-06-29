({
    textKeyChange: function (component, termtext) {
        //var searchKey =  component.find("input1").get("v.value"); 
        var searchKey = termtext;
        //searchKey = searchKey.toUpperCase();
        var recordToDisply = component.find("recordSize").get("v.value");
        var searchFeild = component.get("v.selectBy");
        component.set("v.page", 1);
        var page = component.get("v.page");
        // alert(searchKey);

        if ($A.util.isUndefined(searchKey) || searchKey == '') {
            // this.fetchRequirements(component, page, recordToDisply);
        } else {

            // var opts = component.find("select_id").get("v.value");
            var opts = document.querySelector('input[name="options"]:checked').value;

            var searchDepot = component.find("depot_items").get("v.value");
            // var searchDepot = 'Europe';

            if (opts == 'Product/Sku' || opts == 'Product/SKU') {
                this.searchRequirements(component, searchFeild, searchKey, page, recordToDisply, searchDepot);
            }
            else if (opts == 'Storage Location') {
                if (searchKey != null) {
                    this.searchRequirements(component, searchFeild, searchKey, page, recordToDisply, searchDepot);
                }
            }
            else if (opts == 'SKU Code') {
                if (searchKey != null) {
                    this.searchRequirements(component, searchFeild, searchKey, page, recordToDisply, searchDepot);
                }
            } else if (opts == 'Brand Name') {
                if (searchKey != null) {
                    this.searchRequirements(component, searchFeild, searchKey, page, recordToDisply, searchDepot);
                }

            }
        }

    },

    //To populate the multi select picklist of depot

    fetchDepot: function (component) {
        var page = component.get("v.page") || 1;
        var recordToDisply = component.find("recordSize").get("v.value");
        var searchDepot = '';
        var action = component.get("c.getDepot");
        var opts = [];


        action.setCallback(this, function (response) {
            var returnValue = response.getReturnValue();
            var state = response.getState();
            var selectedDepots = '';
            if (state == "SUCCESS") {
                // var returnValue = JSON.parse(returnValue);
                console.log('Depot returnValue-->',returnValue);
                for (var i = 0; i < returnValue.length; i++) {
                    selectedDepots = selectedDepots + returnValue[i].Name + ";";
                }

                if (returnValue != undefined && returnValue.length > 0) {
                    opts.push({ "class": "optionClass", label: 'All', value: selectedDepots });
                }
                for (var i = 0; i < returnValue.length; i++) {
                    opts.push({ "class": "optionClass", label: returnValue[i].Name, value: returnValue[i].Name });
                }
                console.log('selectedDepots-->',selectedDepots);
                component.find("depot_items").set("v.options", opts);
                component.set("v.Selected_Depots", selectedDepots);
                this.fetchRequirements(component, page, recordToDisply, selectedDepots);   // New Added by MMFurkan 03-feb-2020 

            } else {
            }
        });
        $A.enqueueAction(action);
    },

    //To fetch data on load or whenever search string doesn't match any data
    fetchRequirements: function (component, page, recordToDisply, selectedDepot) {
        var SAPchkBox = component.get('v.SAPCheboxBoolean');
        console.log('SAPchkBox=Requiremnt=>', SAPchkBox);
        var action = component.get('c.getInventories');
        action.setParams({
            pageNumber: page,
            recordToDisply: recordToDisply,
            SelectedDepots: selectedDepot,
            NoZeroSAPRecord: SAPchkBox
        });
        action.setCallback(this, function (response) {
            //store state of response

            var returnValue = response.getReturnValue();
            console.log('-response-response->', returnValue);
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.Wrapperlist', returnValue.listWrapStkReqInv);
                component.set("v.page", returnValue.page);
                component.set("v.total", parseInt(returnValue.total));
                if (returnValue.isAdmin) {
                    component.set('v.allowLineItem', true);
                } else {
                    if (returnValue.allowLineItem) {
                        component.set('v.allowLineItem', true);
                    } else {
                        component.set('v.allowLineItem', false);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },

    //To search data on basis of Product or Storage locations along with the selected depots
    searchRequirements: function (component, searchFeild, searchKey, page, recordToDisply, SelectedDepots) {
        var recordToDisply1 = recordToDisply;
        if (SelectedDepots == 'All' || SelectedDepots == '') {
            SelectedDepots = "NL02;UK10;UK11;UK12;UK13;UK14;UK15;UK16";
        }

        var SAPchkBox = component.get('v.SAPCheboxBoolean');
        console.log('SAPchkBox=Requiremnt=>', SAPchkBox);
        var action = component.get("c.getBySKUAndSLocation");

        action.setParams({
            "fieldName": searchFeild,
            "value": searchKey,
            "pageNumber": page,
            "recordToDisply": recordToDisply,
            "SelectedDepots": SelectedDepots,
            "NoZeroSAPRecord": SAPchkBox
        });
        action.setCallback(this, function (response) {
            var returnValue = response.getReturnValue();
            console.log(" returnValue -=-> ", returnValue);
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.Wrapperlist', returnValue.listWrapStkReqInv);
                component.set("v.page", returnValue.page);
                component.set("v.total", parseInt(returnValue.total));
                component.set("v.isAdmin", returnValue.isAdmin);
                component.set("v.pages", Math.ceil(returnValue.total / recordToDisply1));
                if (returnValue.listWrapStkReqInv.length == 0) {
                    this.errormsg(component);
                    var page = component.get("v.page") || 1;
                    var recordToDisply = component.find("recordSize").get("v.value");
                    this.fetchRequirements(component, page, recordToDisply, SelectedDepots);
                }
                if (returnValue.isAdmin) {
                    component.set('v.allowLineItem', true);
                } else {
                    if (returnValue.allowLineItem) {
                        component.set('v.allowLineItem', true);
                    } else {
                        component.set('v.allowLineItem', false);
                    }
                }

            }
        });
        $A.enqueueAction(action);

    },

    // for the error  toast message
    errormsg: function (component, event) {
        var staticLabel = $A.get("$Label.c.No_Such_Data_Present_in_system");
        // alert(staticLabel);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: 'dismissible',
            duration: '3',
            message: staticLabel,
            key: 'info_alt',
            type: 'info'
        });
        toastEvent.fire();
    }
})