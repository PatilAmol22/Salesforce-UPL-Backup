({
    textKeyChange: function (component, termtext) {
        console.log('term value :-----' + termtext)
        //var searchKey =  component.find("input1").get("v.value"); 
        var searchKey = termtext;
        var orgValue = component.get("v.Selected_Org");
        //searchKey = searchKey.toUpperCase();
        var recordToDisply = component.find("recordSize").get("v.value");
        var searchFeild = component.get("v.selectBy");
        component.set("v.page", 1);
        var page = component.get("v.page");
        // alert(searchKey);
        var orgValue = component.get("v.Selected_Org");
        console.log('Sayan00 before Seacrhkey');

        if ($A.util.isUndefined(searchKey) || searchKey == '') {
            this.fetchRequirements(component, page, recordToDisply, "CR00",orgValue);
            console.log('Helper Product SKU Inside If');
        } else {
            console.log('Helper Product SKU Inside Else');

            // var opts = component.find("select_id").get("v.value");
            var opts = document.querySelector('input[name="options"]:checked').value;

            //var searchDepot = component.find("depot_items").get("v.value");
            // var searchDepot = 'Mexico';
            var searchDepot = "CR00";

            if (opts == 'Product/Sku' || opts == 'Product/SKU') {
                this.searchRequirements(component, searchFeild, searchKey, page, recordToDisply, searchDepot,orgValue);
            }
            else if (opts == 'Storage Location') {
                if (searchKey != null) {
                    console.log('Helper Product SKU Inside ELSE Storage Location searchKey-> ' + searchKey);
                    this.searchRequirements(component, searchFeild, searchKey, page, recordToDisply, searchDepot,orgValue);
                }
            }
            else if (opts == 'SKU Code') {
                if (searchKey != null) {
                    this.searchRequirements(component, searchFeild, searchKey, page, recordToDisply, searchDepot,orgValue);
                }
            }else if (opts == 'Brand Name') {
                if (searchKey != null) {
                    this.searchRequirements(component, searchFeild, searchKey, page, recordToDisply, searchDepot,orgValue);
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
        var orgValue = component.get("v.Selected_Org");

        console.log('Fecth Depot Working');

        action.setCallback(this, function (response) {
            var returnValue = response.getReturnValue();
            var state = response.getState();
            var selectedDepots = '';
            
            console.log('Fecth Depot Working 2');
            if (state == "SUCCESS") {
                // var returnValue = JSON.parse(returnValue);
                console.log('response.getReturnValue();--------->', returnValue);
                for (var i = 0; i < returnValue.length; i++) {
                    selectedDepots = selectedDepots + returnValue[i].Name + ";";
                }

                if (returnValue != undefined && returnValue.length > 0) {
                    console.log("if ALL ---> --->", selectedDepots);
                    opts.push({ "class": "optionClass", label: 'All', value: selectedDepots });
                }
                for (var i = 0; i < returnValue.length; i++) {
                    opts.push({ "class": "optionClass", label: returnValue[i].Depot_Code__c, value: returnValue[i].Name });
                }
                console.log("v.options----------------------------------------------------->", opts);
                console.log(selectedDepots);
                component.find("depot_items").set("v.options", opts);
                component.set("v.Selected_Depots", selectedDepots);
                console.log("component.get(v.Selected_Depots)--->" + component.get("v.Selected_Depots"));
                this.fetchRequirements(component, page, recordToDisply, selectedDepots,orgValue);   // New Added by MMFurkan 03-feb-2020 

            } else {
                console.log('FETCH DEPOT FAILED');
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchSpainOrgs: function (component) {
        var page = component.get("v.page") || 1;
        var recordToDisply = component.find("recordSize").get("v.value");
        var searchDepot = '';
        var action = component.get("c.getSpainOrg");
        var opts = [];
        action.setCallback(this, function (response) {
            var returnValue = response.getReturnValue();
            var state = response.getState();
            var selectedOrgs = '';
            console.log('Fecth org Working');
            if (state == "SUCCESS") {
                // var returnValue = JSON.parse(returnValue);
                console.log('Sayan100 Fetching Sales Orgs--------->', returnValue);
                for (var i = 0; i < returnValue.length; i++) {
                    selectedOrgs = selectedOrgs + returnValue[i].Sales_Org_Code__c+';';
                }
                if (returnValue != undefined && returnValue.length > 0) {
                    console.log("if ALL ---> --->", selectedOrgs);
                    opts.push({ "class": "optionClass", label: 'All', value: selectedOrgs });
                }
                for (var i = 0; i < returnValue.length; i++) {
                    var OrgValue =  'Costa Rica-' + returnValue[i].Sales_Org_Code__c ;
                    opts.push({ "class": "optionClass", label: OrgValue, value: returnValue[i].Sales_Org_Code__c });
                }
                console.log("v.options----------------------------------------------------->", opts);
                console.log(selectedOrgs);
                component.find("org_items").set("v.options", opts);
                component.set("v.Selected_Org", selectedOrgs);
                console.log("Orgs inside Fetch Spain Org doInit--->" + component.get("v.Selected_Org"));
            } else {
                console.log('FETCH SPAIN ORG FAILED');
            }
        });
        $A.enqueueAction(action);
    },

    
    
    
    
    
    //To fetch data on load or whenever search string doesn't match any data
    fetchRequirements: function (component, page, recordToDisply, selectedDepot,orgValue) {
        var SAPchkBox = component.get('v.SAPCheboxBoolean');
        console.log('SAPchkBox=Requiremnt=>', SAPchkBox);
        var action = component.get('c.getInventories');
        // console.log('recordToDisply--->', recordToDisply, ' selectedDepot-->', selectedDepot, ' page-->', page, ' COMPONENT--->', component);
        action.setParams({
            pageNumber: page,
            recordToDisply: recordToDisply,
            SelectedDepots: selectedDepot,
            NoZeroSAPRecord: SAPchkBox,
            orgValue: orgValue
        });
        action.setCallback(this, function (response) {
            //store state of response
            console.log('-response-response->', response);
            var returnValue = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('- Wrapperlist --> ', returnValue.listWrapStkReqInv);
                component.set('v.Wrapperlist', returnValue.listWrapStkReqInv);
                component.set('v.isAdmin', returnValue.isAdmin);
                component.set("v.page", returnValue.page);
                component.set("v.total", parseInt(returnValue.total));
            }
        });
        $A.enqueueAction(action);
    },

    //To search data on basis of Product or Storage locations along with the selected depots
    searchRequirements: function (component, searchFeild, searchKey, page, recordToDisply, SelectedDepots,orgValue) {
        var recordToDisply1 = recordToDisply;
        if (SelectedDepots == 'All' || SelectedDepots == '') {
            console.log('SelectedDepots==========================>');
            SelectedDepots = "CR00";
        }

        var action = component.get("c.getBySKUAndSLocation");

        action.setParams({
            "fieldName": searchFeild,
            "value": searchKey,
            "pageNumber": page,
            "recordToDisply": recordToDisply,
            "SelectedDepots": SelectedDepots,
            "orgValue": orgValue
        });
        action.setCallback(this, function (response) {
            var returnValue = response.getReturnValue();
            var state = response.getState();
            var orgValue = component.get("v.Selected_Org");
            if (state === "SUCCESS") {
                component.set('v.Wrapperlist', returnValue.listWrapStkReqInv);
                component.set("v.page", returnValue.page);
                component.set("v.total", parseInt(returnValue.total));
                component.set("v.pages", Math.ceil(returnValue.total / recordToDisply1));
                console.log(" searchRequirements --> ", returnValue.listWrapStkReqInv);
                if (returnValue.listWrapStkReqInv.length == 0) {
                    this.errormsg(component);
                    var page = component.get("v.page") || 1;
                    var recordToDisply = component.find("recordSize").get("v.value");
                    this.fetchRequirements(component, page, recordToDisply, SelectedDepots,orgValue);
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