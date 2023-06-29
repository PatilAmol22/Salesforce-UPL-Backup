({
	uplSetting:function(component, event, helper) {
    var action = component.get("c.getHiearchySettings");

    action.setCallback(this, function(response){
        if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
            //saving custom setting to attribute
            component.set("v.pageSize",response.getReturnValue());
            //console.debug(response.Draft_Record_Per_Page__c );//Check the output
            //... rest of your code
        }
    });

    $A.enqueueAction(action);
},
    getDivision : function(component) {
        var action = component.get("c.getDivsions");
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                console.log('result:::'+res);
               //alert('resdiv'+res.length);
                
                    component.set("v.divList",res);
                    //this.retreiveWrapper(component);
                
            }
            else{
                console.log('error:'+e);
            }
            
        });
        $A.enqueueAction(action);    
    },
    retriveWrapper:function(component) {
        //alert(component.get("v.custDiv"));
        component.set('v.ChangeList',[]);
        var pageNumber = component.get("v.PageNumber");
        var pageSize = component.get("v.pageSize");
    	var action = component.get("c.generateWrapper");
        action.setParams({
            "mktYear": component.get("v.mktYear"),
            "div":component.get("v.custDiv")
        });
        action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
            //alert('success');
             var resultData = response.getReturnValue();
             component.set("v.datList",resultData.finalWrap);
            
            component.set("v.currStart",resultData.curStart);
            component.set("v.currEnd",resultData.curEnd);
            component.set("v.saleOrg",resultData.sorg);
            component.set("v.curYear",resultData.curYear);
            component.set("v.PrevYear",resultData.prevYear);
            component.set("v.LastPrevYear",resultData.prevLastYear);
            component.set("v.showLast",resultData.showLastSaved);
            component.set("v.lastSavedBy",resultData.savedname);
            component.set("v.lastSaveddate",resultData.saveddate);
            //alert(resultData.editAccess);
            
            //component.set("v.freezeInput",resultData.editAccess);
            if(component.get("v.yearEditAccess")==false && resultData.editAccess==false){
                component.set("v.freezeInput",true);
                
            }
            else if(component.get("v.yearEditAccess")==true && resultData.editAccess==false){
                component.set("v.freezeInput",true);
            }
                else if(component.get("v.yearEditAccess")==true && resultData.editAccess==true){
                    component.set("v.freezeInput",false);
                }
            else if(component.get("v.yearEditAccess")==false && resultData.editAccess==true){
                    component.set("v.freezeInput",true);
                }
            component.set("v.totalRecords", component.get("v.datList").length);
             var sObjectList = component.get("v.datList");
             var pageSize = component.get("v.pageSize");
             // set star as 0
             component.set("v.startPage",0);//changed to 1
             component.set("v.PageNumber",1);
             component.set("v.endPage",pageSize-1);
             component.set("v.TotalPages", Math.ceil(component.get("v.totalRecords") / pageSize));
            //alert(component.get("v.TotalPages")); 
            var PaginationList = [];
             for(var i=0; i< pageSize; i++){
                 if(component.get("v.datList").length> i)
                      PaginationList.push(sObjectList[i]);
                      component.set('v.PaginationList', PaginationList);
                }
              
            }
            else{
                //component.set("v.displayDetails", false);
                //component.set("v.ShowSpinner", true); // added by swapnil
                component.find('notifLib').showToast({
                    "variant": "error",
                    "title": "Error!",
                    "message": "SKU and region level Draft plan Entry are not available"
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
                component.set("v.curYear",res.firstMarketingYear);
                component.set("v.prevYear",res.firstMarketingYear-1);
            }
            else{
                console.log('error:'+e);
            }
            
        });
        $A.enqueueAction(action);    
    },
    filterRecords : function(component){
        //component.set('v.FilterList',null)
        var sObjectList = component.get("v.datList");
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
                if(sObjectList[i].SkuName)
                skuproduct = sObjectList[i].SkuName.toUpperCase();
                if(sObjectList[i].Category)
                skumaterial = sObjectList[i].Category.toUpperCase();
                
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
        if(material &&  (product === undefined ||  product == "")){
            
            for(var i=0; i< sObjectList.length; i++){
                if(sObjectList[i].Category)
					skumaterial = sObjectList[i].Category.toUpperCase();
				if(skumaterial){
                if(skumaterial.includes(material)>0)
                    FilterList.push(sObjectList[i]);
				}
            }
            //alert(FilterList.length);
        }
        //product is not null and material == null 
        if(product && (material ==="" || material == undefined)){
            for(var i=0; i< sObjectList.length; i++){
                 if(sObjectList[i].SKUName)
                skuproduct =sObjectList[i].SkuName.toUpperCase();
                
                if(skuproduct){
                    if(skuproduct.includes(product)>0)
                        FilterList.push(sObjectList[i]);
                }
            }
            
        }
        //Both product and material null
        if((product==="" || product == undefined) && material === ""){
            console.log('yess in');
            FilterList= component.get("v.datList");                
        }
        
        component.set('v.FilterList', FilterList);
        
        for(var i=0; i< pageSize; i++){
            if(FilterList.length> i)
                PaginationList.push(FilterList[i]);
            
            
        }
       for(var i=0; i< pageSize; i++){
            if(PaginationList.length> i){
                //PaginationList[i].dfpayList=FilterList[i].dfpayList;
               //alert(PaginationList[i].dQty);
                //PaginationList[i].expanded=false;
            }
        }
     /*  var count = component.find("listItem1").length;
        console.log("1: "+count);
        var timer = window.setInterval($A.getCallback(function() {
                if (component.isValid()) {
                   clearInterval(timer);
                   count = component.find("listItem1").length;
                   console.log("2: " +count);
                }
        }), 200);*/
        //alert('len'+FilterList.length);
        console.log('filtered pagination::'+PaginationList.length);
        component.set("v.PaginationList", PaginationList);
        component.set("v.startPage",0);
        component.set("v.PageNumber",1);
        component.set("v.totalRecords", component.get("v.FilterList").length);
        component.set("v.TotalPages", Math.ceil(component.get("v.totalRecords") / pageSize));
        component.set("v.endPage",pageSize-1);
        
        
    },
    NavSave : function(component, event, helper) {
		var sObjectList = component.get("v.datList");
        //alert('help'+component.get("v.ChangeList")[0].dfpayList[0].payoutId);
       //alert(component.get("v.ChangeList").length);
        var action = component.get("c.createDraftPlanRegion");
        action.setParams({
            "finalList": component.get("v.ChangeList"),
            "mktYear": component.get("v.mktYear"),
            "salesOrg":component.get("v.saleOrg"),
            "div":component.get("v.custDiv")
            
        });
        action.setCallback(this, function(response) {
        var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                //alert(resultData[0].editAccess);
                component.set("v.showLast",resultData[0].showLastSaved);
            	component.set("v.lastSavedBy",resultData[0].savedname);
            	component.set("v.lastSaveddate",resultData[0].saveddate);
                
                
                for(var j=0;j<sObjectList.length;j++){
                    for(var u in resultData){
                        if(u.skuReg==sObjectList[j].skuReg){
                            //alert('hello');
                        	sObjectList[j]=u.dprId;
                    }
                    }
                }
            }
            else{
                alert('fail');
            }
            
        });
        $A.enqueueAction(action);    
    },
    FilterRecordUpdated : function(component){
        //alert('hello');
        component.set("v.PaginationList", []);
        var pageNumber = component.get("v.PageNumber");
        var pageSize = component.get("v.pageSize");  
        var sObjectList = component.get("v.datList");
        console.log('sObjectList'+JSON.stringify(sObjectList));
        //fetch selected material value
        var material = component.find("selectMaterial").get("v.value");
        
         console.log('hello'+material)
        if(material)
            material = material.toUpperCase();
        console.log('material'+material);
        //fetch product
        var product = component.find("selectProduct").get("v.value"); 
        if(product)
            product = product.toUpperCase();
        
        console.log('product'+product);
        
        var query = {} ;
        
        if(material)
            query.Category = material;
        
        if(product)
            query.SkuName = product;
        
        console.log('query'+JSON.stringify(query));
        
        console.log(JSON.stringify(query));
            
            var filteredData = sObjectList.filter( (item) => {
            
            for (let key in query) {
                console.log('key'+key);
            console.log('query key'+query[key]);
                 console.log('item key'+item.key);
            if (item[key] === undefined || !item[key].toUpperCase().includes(query[key])) {
            //alert('false');
                return false;
                
        }
                                                }
                                                  
                                                  //alert('true');
                                                return true;
                                                });
         console.log(filteredData);
         component.set("v.filterdata",filteredData);
                 component.set("v.FilterList",filteredData);

        //alert(component.get("v.filterdata"));
        if(component.get("v.filterdata").length>0){
            var sObjectList = component.get("v.filterdata");
        
        var pageSize = component.get("v.pageSize");
            console.log(component.get("v.filterdata").length);
        // set start as 0
        component.set("v.totalRecords", component.get("v.filterdata").length);
        component.set("v.startPage",0);//changed to 1
        component.set("v.PageNumber",1);
        component.set("v.endPage",pageSize-1);
        component.set("v.TotalPages", Math.ceil(component.get("v.totalRecords") / pageSize));
        var PaginationList = [];
        for(var i=0; i< pageSize; i++){
            if(component.get("v.filterdata").length> i)
                PaginationList.push(sObjectList[i]);
            component.set("v.PaginationList", PaginationList);
        }
            //var a = [];
       //component.set("v.PaginationList", a); 
            //console.log(PaginationList);
        } 
        else{
            var PaginationList = [];
            component.set("v.PaginationList", PaginationList);
            //Added on 22-04-2020 - Pagination defect patch
            component.set("v.PageNumber",1); 
            component.set("v.TotalPages", 1);
            //
        }
    }
})