({
    getAccount : function(component){
        component.set("v.isLoading", true); 
        let accId = component.get("v.recordId");
        
        var action = component.get("c.getForecast");
        
        action.setParams({
            "accountId" : accId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var data;
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                this.setupDataTable(component);
        		this.getData(component);
             }
        });
        $A.enqueueAction(action);
    },
    setupDataTable: function (component) {
        component.set('v.moreLess', true);  
        component.set('v.columns', [
            {label: 'Date', fieldName: 'dt', type: "date"},
            {label: 'Rain chances', fieldName: 'percip', type: 'text', wrapText: true},
            {label: 'Max temp(°C)', fieldName: 'maxTemp', type: 'text', wrapText: true},
            {label: 'Min temp(°C)', fieldName: 'minTemp', type: 'text', wrapText: true},
            
        ]);
    },
    
    showMore: function (component) {
        component.set('v.moreLess', false);    
        component.set('v.columns', [
            {label: 'Date', fieldName: 'dt', type: "date-local"},
            {label: 'Rain chances', fieldName: 'percip', type: 'text', wrapText: true},  
            {label: 'Max temp(°C)', fieldName: 'maxTemp', type: 'text', wrapText: true},
            {label: 'Min temp(°C)', fieldName: 'minTemp', type: 'text', wrapText: true},
            {label: 'Weather', fieldName: 'weather', type: 'text', wrapText: true},
            {label: 'Humidity', fieldName: 'humidity', type: 'text', wrapText: true},
            {label: 'Wind Speed(km/h)', fieldName: 'windSpeed', type: 'text', wrapText: true}
        ]);
        this.getData(component);
    },
    showLess: function (component) {
		this.setupDataTable(component);
    },
    
    /*
    
     * /
    
    /*
     {label: 'variety', variety: 'variety', type: 'text'},
     {label: 'state', fieldName: 'state', type: 'text'},
     {label: 'district', fieldName: 'district', type: 'text'},
     {label: 'modal_price', fieldName: 'modal_price', type: 'text'}
    */
    
    getData : function(component) {
        component.set("v.isLoading", true);
        let accId = component.get("v.recordId");
        var action = component.get("c.getForecast");
        action.setParams({
            "accountId" : accId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var data;
            
            console.log(response.StatusCode);
            console.log(response.state);
            console.log('state-->>'+state);
            if(!$A.util.isUndefinedOrNull(state) && state === 'SUCCESS'){
                component.set("v.isLoading", false);
                var result = response.getReturnValue();
                console.log('len-->'+result.length);
                //console.log(JSON.stringify(result));
                if(!$A.util.isUndefinedOrNull(result) && result.length > 0){
                    console.log('in if');
                    component.set("v.filteredData", result);
                    component.set("v.allData", result);
                    this.preparePagination(component, result);
                }else{
                    console.log('in Else');
                    component.set("v.isError", false);
                }
                
            }else{
                component.set("v.isLoading", false);
                component.set("v.isError", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    preparePagination: function (component, imagesRecords) {
        let countTotalPage = Math.ceil(imagesRecords.length/component.get("v.pageSize"));
        let totalPage = countTotalPage > 0 ? countTotalPage : 1;
        component.set("v.totalPages", totalPage);
        component.set("v.currentPageNumber", 1);
        this.setPageDataAsPerPagination(component);
    },
    
    setPageDataAsPerPagination: function(component) {
        let data = [];
        let pageNumber = component.get("v.currentPageNumber");
        let pageSize = component.get("v.pageSize");
        let districtName = component.get("v.DistrictName");
        let filteredData = component.get('v.filteredData');
        let x = (pageNumber - 1) * pageSize;
        for (; x < (pageNumber) * pageSize; x++){
            if (filteredData[x]) {
                data.push(filteredData[x]);
            }
        }
        component.set("v.tableData", data);
       
    }
})