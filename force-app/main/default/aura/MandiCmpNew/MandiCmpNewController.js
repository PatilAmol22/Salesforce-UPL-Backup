({
    doInit: function (component, event, helper) {
        //helper.getAccount(component);
        component.set("v.pageSize", 10);
        component.set("v.stateVal", "");
        component.set("v.districtVal", "");
        component.set("v.cropVal", "");
        component.set("v.tableData", null);
        component.set("v.districtFlag", true);
        component.set("v.tableVisibleFlag",false);
        component.set("v.totalPages",1);
        component.set("v.currentPageNumber",1);
        var action = component.get("c.getStates");

        action.setCallback(this, function (response) {
            var state = response.getState();
            var data;
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                if (!$A.util.isUndefinedOrNull(result)) {
                    component.set("v.stateOptions", result);
                }
            }
        });
        $A.enqueueAction(action);

    },

    onNext: function (component, event, helper) {
        let pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber + 1);
        helper.setPageDataAsPerPagination(component);
    },

    onPrev: function (component, event, helper) {
        let pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber - 1);
        helper.setPageDataAsPerPagination(component);
    },

    onFirst: function (component, event, helper) {
        component.set("v.currentPageNumber", 1);
        helper.setPageDataAsPerPagination(component);
    },

    onLast: function (component, event, helper) {
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.setPageDataAsPerPagination(component);
    },

    onPageSizeChange: function (component, event, helper) {
        //helper.preparePagination(component, component.get('v.filteredData'));
    },


    handleSearch: function (component, event, helper) {
        helper.searchRecordsBySearchPhrase(component);
    },

    handleStateChange: function (component, event, helper) {
        var selectedOptionValue = event.getParam("value");
        var action = component.get("c.getDistricts");
        action.setParams({
            "stateId": selectedOptionValue
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var data;
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                if (!$A.util.isUndefinedOrNull(result)) {
                    component.set("v.districtOptions", result);
                    component.set("v.districtFlag", false);
                }
            }
        });
        $A.enqueueAction(action);

        var action1 = component.get("c.getCrops");

        action1.setCallback(this, function (response) {
            var state = response.getState();
            var data;
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                if (!$A.util.isUndefinedOrNull(result)) {
                    component.set("v.cropOptions", result);
                    component.set("v.cropFlag", false);
                }
            }
        });
        $A.enqueueAction(action1);

    },

    handleDistrictChange: function (component, event, helper) {
        var selectedOptionValue = event.getParam("value");
        console.log("Label val1 : " + selectedOptionValue);


    },

    handleCropChange: function (component, event, helper) {
        var selectedOptionValue = event.getParam("value");
        console.log('crop selected: ' + component.get("v.cropVal"));
    },

    handleSearchWithFilters: function (component, event, helper) {
        var stateCode = component.get("v.stateVal");
        var districtCode = component.get("v.districtVal");
        var cropValue = component.get("v.cropVal");
        var action = component.get("c.getMandiPriceDetails");
        action.setParams({
            "state": stateCode
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var data;
            console.log('stete final:' + state);
            if (state === 'SUCCESS') {
                component.set("v.isLoading", false);
                var result = response.getReturnValue();
                //console.log(result);
                console.log(JSON.stringify(result));
                if (!$A.util.isUndefinedOrNull(result) && result.length > 0) {
                    component.set("v.tableVisibleFlag",true);
                    let filteredData = result;
                    if (!$A.util.isUndefinedOrNull(component.get("v.districtVal"))) {
                        filteredData = filteredData.filter(record => record.district.toLowerCase().includes(component.get("v.districtVal").toLowerCase()));
                    }
                    if (!$A.util.isUndefinedOrNull(component.get("v.cropVal"))) {
                        filteredData = filteredData.filter(record => record.product.toLowerCase().includes(component.get("v.cropVal").toLowerCase()));
                    }

                    component.set("v.filteredData", filteredData);
                    helper.preparePagination(component, filteredData);
                    component.set('v.columns', [
                        { label: 'commodity', fieldName: 'product', type: 'text', sortable: true },
                        { label: 'market', fieldName: 'market', type: 'text', wrapText: true, },
                        { label: 'district', fieldName: 'district', type: 'text', wrapText: true, },
                        { label: 'state', fieldName: 'state', type: 'text', wrapText: true },
                        { label: 'Max price', fieldName: 'maxPrice', type: 'currency', wrapText: true, },
                        { label: 'Min price', fieldName: 'minPrice', type: 'currency', wrapText: true, }

                    ]);

                    console.log('result data :' + JSON.stringify(component.get("v.tableData")));
                    //this.preparePagination(component, result);
                } else {
                    component.set("v.isError", false);
                }
            } else {
                component.set("v.isLoading", false);
                component.set("v.isError", false);
            }
        });
        $A.enqueueAction(action);
    },
})