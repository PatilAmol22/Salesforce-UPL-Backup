({
    textKeyChange: function (component, termtext) {
        console.log('term value :-----' + termtext)
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
            console.log('Sayan Helper Product SKU Inside If');
        }else {
            console.log('Sayan Helper Product SKU Inside Else');
            // var opts = component.find("select_id").get("v.value");
            var opts = document.querySelector('input[name="options"]:checked').value;
            
            // var searchDepot = component.find("depot_items").get("v.value");
            var searchDepot = 'JP01';

            if (opts == 'Product/Sku' || opts == 'Product/SKU') {
                this.searchRequirements(component, searchFeild, searchKey, page, recordToDisply, searchDepot);
            } else if (opts == 'Storage Location') {
                if (searchKey != null) {
                    console.log('Helper Product SKU Inside ELSE Storage Location searchKey-> '+searchKey);
                    this.searchRequirements(component, searchFeild, searchKey, page, recordToDisply, searchDepot);
                }
            } else if (opts == 'SKU Code') {
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
        console.log('Fetch Depot');

        action.setCallback(this, function (response) {
            var returnValue = response.getReturnValue();
            var state = response.getState();
            var selectedDepots = '';
            if (state == "SUCCESS") {
                console.log('This Is Working');
                // var returnValue = JSON.parse(returnValue);
                console.log('response.getReturnValue();--------->',returnValue);
                for (var i = 0; i < returnValue.length; i++) {
                    selectedDepots = selectedDepots + returnValue[i].Name + ";";
                }

                if (returnValue != undefined && returnValue.length > 0) {
                    console.log("if ALL ---> --->",selectedDepots); 
                    opts.push({ "class": "optionClass", label: 'All', value: selectedDepots });
                }
                for (var i = 0; i < returnValue.length; i++) {
                    opts.push({ "class": "optionClass", label: returnValue[i].Depot_Code__c, value: returnValue[i].Name });
                }
                console.log("v.options----------------------------------------------------->", opts);
                console.log(selectedDepots);
                this.fetchRequirements(component, page, recordToDisply, selectedDepots);   // New Added by MMFurkan 03-feb-2020 

            }
        });
        $A.enqueueAction(action);
    },

    //To fetch data on load or whenever search string doesn't match any data
    fetchRequirements: function (component, page, recordToDisply, selectedDepot) {
        var action = component.get('c.getInventories');
        console.log('recordToDisply--->',recordToDisply,' selectedDepot-->',selectedDepot,' page-->',page, ' COMPONENT--->', component);
        var SAPchkBox = component.get('v.SAPCheboxBoolean');
        action.setParams({
            pageNumber: page,
            recordToDisply: recordToDisply,
            SelectedDepots: 'JP01',
            NoZeroSAPRecord: SAPchkBox
        });
        action.setCallback(this, function (response) {
            //store state of response

            console.log('-response-response->',response);
            var returnValue = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('- Wrapperlist --> ',returnValue.listWrapStkReqInv);
                component.set('v.Wrapperlist', returnValue.listWrapStkReqInv);
                component.set('v.isAdmin', returnValue.isAdmin);
                component.set("v.page", returnValue.page);
                component.set("v.total", parseInt(returnValue.total));
            }
        });
        $A.enqueueAction(action);
    },

    //To search data on basis of Product or Storage locations along with the selected depots
    searchRequirements: function (component, searchFeild, searchKey, page, recordToDisply, SelectedDepots) {
        var recordToDisply1 = recordToDisply;
        if (SelectedDepots == 'All' || SelectedDepots == '') {
            SelectedDepots = "JP01";
        }

        var SAPchkBox = component.get('v.SAPCheboxBoolean');
        var action = component.get("c.getBySKUAndSLocation");

        action.setParams({
            "fieldName": searchFeild,
            "value": searchKey,
            "pageNumber": page,
            "recordToDisply": recordToDisply,
            "SelectedDepots": SelectedDepots,
            "NoZeroSAPRecord": SAPchkBox
        });
        console.log(action);
        action.setCallback(this, function (response) {
            var returnValue = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.Wrapperlist', returnValue.listWrapStkReqInv);
                component.set("v.page", returnValue.page);
                component.set("v.total", parseInt(returnValue.total));
                component.set("v.pages", Math.ceil(returnValue.total / recordToDisply1));
                console.log(" searchRequirements --> ",returnValue.listWrapStkReqInv);
                if (returnValue.listWrapStkReqInv.length == 0) {
                    this.errormsg(component);
                    var page = component.get("v.page") || 1;
                    var recordToDisply = component.find("recordSize").get("v.value");
                    this.fetchRequirements(component, page, recordToDisply, SelectedDepots);
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