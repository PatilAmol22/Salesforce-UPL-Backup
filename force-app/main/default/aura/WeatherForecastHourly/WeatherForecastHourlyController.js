({
    doInit: function (component, event, helper) {
        helper.setupDataTable(component); 
        helper.getData(component);
    },
 
    onNext: function(component, event, helper) {        
        let pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber + 1);
        helper.setPageDataAsPerPagination(component);
    },
     
    onPrev: function(component, event, helper) {        
        let pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber - 1);
        helper.setPageDataAsPerPagination(component);
    },
     
    onFirst: function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.setPageDataAsPerPagination(component);
    },
     
    onLast: function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.setPageDataAsPerPagination(component);
    },
 
    onPageSizeChange: function(component, event, helper) {        
        helper.preparePagination(component, component.get('v.filteredData'));
    },
 
    onChangeSearchPhrase : function (component, event, helper) {
        if ($A.util.isEmpty(component.get("v.searchPhrase"))) {
            let allData = component.get("v.allData");
            component.set("v.filteredData", allData);
            helper.preparePagination(component, allData);
        }
    },
})