({
    getPageSize : function(component) {
        var action = component.get("c.getPageSize");
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.pageSize",res);
            }
            else{
                console.log('error:'+e);
            }
            
        });
        $A.enqueueAction(action);    
    },
    getDivision : function(component) {
        var action = component.get("c.getDivisions");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                console.log('result:::'+res);
                component.set("v.divList",res);
            }
            else{
                console.log('error:'+e);
            }
            
        });
        $A.enqueueAction(action);    
    },
    retrieveSKUWrapper : function(component) {
        var action = component.get("c.getSKUWrapper");
        action.setParams({
            "mktYear": component.get("v.mktYear"),
             "div":component.get("v.custDiv")
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                component.set("v.SKUWrapper", resultData);
                component.set("v.totalRecords", component.get("v.SKUWrapper").length);
                var sObjectList = component.get("v.SKUWrapper");
                var pageSize = component.get("v.pageSize");
                component.set("v.startPage",0);
                component.set("v.PageNumber",1);
                component.set("v.endPage",pageSize-1);
                var PaginationList = [];
                for(var i=0; i< pageSize; i++){
                    if(component.get("v.SKUWrapper").length> i)
                        PaginationList.push(sObjectList[i]);
                    component.set('v.PaginationList', PaginationList);
                } 
                component.set("v.TotalPages", Math.ceil(component.get("v.totalRecords") / pageSize));
            }
            else{
                console.log('error:'+e);
                component.set("v.ShowSpinner", true);
                component.find('notifLib').showToast({
                    "variant": "error",
                    "title": "Error!",
                    "message": "Target Planning details are not available"
                });
            
            }
            
        });
        $A.enqueueAction(action);    
    },
    getMarketingYear : function(component) {
        var action = component.get("c.getMarketingYear");
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                console.log('result:::'+res);
                component.set("v.firstYear",res.firstMarketingYear);
                component.set("v.secondYear",res.secondMarketingYear);
                component.set("v.currentYear",res.firstMarketingYear);
                component.set("v.prevYear",res.firstMarketingYear-1);
            }
            else{
                console.log('error:'+e);
            }
            
        });
        $A.enqueueAction(action);    
    },
    getLastSavedData : function(component) {
        var action = component.get("c.getLastSavedData");
        action.setParams({
            "mktYear": component.get("v.mktYear")
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.showLast",res.showLastSaved);
                component.set("v.lastSavedBy",res.lastSavedName);
                component.set("v.lastSaveddate",res.lastSavedDate);
                component.set("v.editaccess",res.editAccess);
                component.set("v.targetaccess",res.targetAccess);
            }
            else{
                console.log('error:'+e);
            }
            
        });
        $A.enqueueAction(action);    
    },
    filterRecords : function(component){
        
        var sObjectList = component.get("v.SKUWrapper");
        //fetch selected material value
        var material = component.find("selectMaterial").get("v.value");
        if(material)
        	material = material.toUpperCase();
        //fetch product
        var product = component.find("selectProduct").get("v.value"); 
        if(product)
        	product = product.toUpperCase();
        var skuproduct;var skumaterial;
        var pageNumber = component.get("v.PageNumber");
        var pageSize = component.get("v.pageSize");       
        var FilterList = [];
        var PaginationList = [];
        //material and product is not null
        if(material && product){
            for(var i=0; i< sObjectList.length; i++){
                if(sObjectList[i].SKUName)
                	skuproduct = sObjectList[i].SKUName.toUpperCase();
                if(sObjectList[i].SKUMaterial)
					skumaterial = sObjectList[i].SKUMaterial.toUpperCase();
                console.log(product);
                console.log(skuproduct);
                //SKU search value is null
                if(skuproduct && skumaterial){
                    if(skumaterial.includes(material)>0
                       && skuproduct.includes(product)>0)
                        FilterList.push(sObjectList[i]);
                }
                
            }
            
        }
        //material != null and product is null
        if(material &&  (product === undefined ||  product === "")){
            console.log('in material:'+material);
            for(var i=0; i< sObjectList.length; i++){
                if(sObjectList[i].SKUMaterial)
					skumaterial = sObjectList[i].SKUMaterial.toUpperCase();
				if(skumaterial){
                if(skumaterial.includes(material)>0)
                    FilterList.push(sObjectList[i]);
				}
            }
            
        }
        //product is not null and material == null 
        if(product && (material ==="" || material === undefined)){
            for(var i=0; i< sObjectList.length; i++){
                if(sObjectList[i].SKUName)
                	skuproduct = sObjectList[i].SKUName.toUpperCase();
                
                if(skuproduct){
                    if(skuproduct.includes(product)>0)
                        FilterList.push(sObjectList[i]);
                }
            }
            
        }
        //Both product and material null
        if((product==="" || product == undefined) && (material === ""|| material == undefined)){
            FilterList= component.get("v.SKUWrapper");                
        }
        component.set('v.FilterList', FilterList);
        
        for(var i=0; i< pageSize; i++){
            if(FilterList.length> i)
                PaginationList.push(FilterList[i]);
            
        }
        console.log('filtered pagination::'+PaginationList);
        component.set("v.PaginationList", PaginationList);
        component.set("v.startPage",0);
        component.set("v.PageNumber",1);
        component.set("v.totalRecords", component.get("v.FilterList").length);
        component.set("v.TotalPages", Math.ceil(component.get("v.totalRecords") / pageSize));
        component.set("v.endPage",pageSize-1);//
        
        
    },
    saveTargetTotal : function(component, event, helper) {
        var sObjectList = component.get("v.SKUWrapper");
        var action = component.get("c.saveTargetData");
        action.setParams({
            "paginationList": component.get("v.FinalList"),
             "mktYear": component.get("v.mktYear"),
            "div":component.get("v.custDiv")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
              //component.set("v.SKUWrapper",response.getReturnValue()); 
              console.log('after save!!');
                //alert('after save!!');
                
                var resultData = response.getReturnValue();
                //alert('success'+resultData);
                var updatedList=resultData;
                for(var u in updatedList){
                    for(var j=0;j<sObjectList.length;j++){
                        if(sObjectList[j].SKUId==updatedList[u]){
                            sObjectList[j].fromTargetPlan=true;
                        }
                        
                    }
                }
                
            }
        });
        
        $A.enqueueAction(action); 
	}
})