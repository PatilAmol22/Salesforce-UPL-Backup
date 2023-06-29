({
    getAccount: function (component) {
        component.set("v.isLoading", true);
        let accId = component.get("v.recordId");
        var action = component.get("c.getAccountDetails");

        action.setParams({
            "accountId": accId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var data;
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                if (!$A.util.isUndefinedOrNull(result)) {
                    let DistrictName = !$A.util.isUndefinedOrNull(result.District__pc) ? result.District__pc : result.District__c;
                    this.setupDataTable(component);
                    this.getData(component);
                } else {
                    component.set("v.isError", false);
                    component.set("v.isLoading", false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    setupDataTable: function (component) {
        component.set('v.columns', [
            { label: 'commodity', fieldName: 'commodity', type: 'text', sortable: true },
            { label: 'market', fieldName: 'market', type: 'text', wrapText: true, },
            { label: 'district', fieldName: 'district', type: 'text', wrapText: true, },
            { label: 'state', fieldName: 'state', type: 'text', wrapText: true },
            { label: 'Max price', fieldName: 'max_price', type: 'currency', wrapText: true, },
            { label: 'Min price', fieldName: 'min_price', type: 'currency', wrapText: true, }

        ]);
    },

    getData: function (component) {
        var action = component.get("c.fetchMandiPrice");
        action.setCallback(this, function (response) {
            var state = response.getState();
            var data;
            if (state === 'SUCCESS') {
                component.set("v.isLoading", false);
                var result = response.getReturnValue();
                //console.log(result);
                //console.log(JSON.stringify(result));
                if (!$A.util.isUndefinedOrNull(result) && result.length > 0) {
                    component.set("v.filteredData", result);
                    component.set("v.allData", result);
                    this.preparePagination(component, result);
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

    preparePagination: function (component, imagesRecords) {
        let countTotalPage = Math.ceil(imagesRecords.length / component.get("v.pageSize"));
        let totalPage = countTotalPage > 0 ? countTotalPage : 1;
        component.set("v.totalPages", totalPage);
        component.set("v.currentPageNumber", 1);
        this.setPageDataAsPerPagination(component);
    },

    setPageDataAsPerPagination: function (component) {
        let data = [];
        let pageNumber = component.get("v.currentPageNumber");
        let pageSize = component.get("v.pageSize");
        let districtName = component.get("v.DistrictName");
        let filteredData = component.get('v.filteredData');
        filteredData.sort(function (a, b) {
            if (a['district'] == districtName) {
                return -1;
            } else if (a['district'] == districtName) {
                return 1;
            }
            return 0;
        })

        let x = (pageNumber - 1) * pageSize;
        for (; x < (pageNumber) * pageSize; x++) {
            if (filteredData[x]) {
                data.push(filteredData[x]);
            }
        }
        component.set("v.tableData", data);
    },

    searchRecordsBySearchPhrase: function (component) {
        let searchPhrase = component.get("v.searchPhrase");
        if (!$A.util.isEmpty(searchPhrase)) {
            let allData = component.get("v.allData");
            let filteredData = allData.filter(record => record.commodity.toLowerCase().includes(searchPhrase.toLowerCase()));
            component.set("v.filteredData", filteredData);
            this.preparePagination(component, filteredData);
        }
    },

    /*sortByState : function(component, paginateData){
        let data = component.get("v.filteredData");
        let stateVal = component.get("v.StateName");
        stateVal = 'Gujarat';
        let districtName = component.get("v.DistrictName");
        console.log("stateVal-->>", stateVal);
        console.log("paginateData-->>", paginateData);
        paginateData.sort(function(a,b){
            console.log(a['market']);
            if (a['state'] == 'punjab' ) { 
                console.log('IF');
                return 1;    
            } else if (a['state'] == 'punjab' ) {    
                console.log('ELSE')
                return -1;    
            }    
            return 0;   
        })
        console.log("AF paginateData-->>", paginateData);
        //  component.set("v.tableData", paginateData);
    }
    */
})