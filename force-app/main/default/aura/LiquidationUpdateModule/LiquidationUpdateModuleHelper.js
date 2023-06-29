({
    fetchSecondary : function(component) {
        component.set('v.mycolumns', [
            {label: 'Secondary Sales Number', fieldName: 'linkName', type: 'url', 
             typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},            
            {label: 'Created Date', fieldName: 'CreatedDate', type: 'date'},
            {label: 'Distributor', fieldName: 'SoldToParty', type: 'Text'},
            {label: 'SKU Name', fieldName: 'SKUName', type: 'text'}, 
            {label: 'SKU Code', fieldName: 'SKUCode', type: 'text'},
            {label: 'City Name', fieldName: 'City__c', type: 'text'},
            {label: 'Unit Price', fieldName: 'Mapping_Unit_Price__c', type: 'currency'},            
            {label: 'UoM', fieldName: 'UOM__c', type: 'text'},
            {label: 'Month', fieldName: 'Month__c', type: 'text'},
            {label: 'Year', fieldName: 'Year__c', type: 'text'},
            {label: 'Quantity', fieldName: 'Product_Quantity__c', type: 'number',  editable: true},
            {label: 'Amount', fieldName: 'Sell_Amount_USD__c', type: 'currency'}
        ]);
        component.set('v.display',true);
        component.set('v.salesSelected',true);
        component.set('v.inventorySelected',false);
        
        var action = component.get("c.fetchSecondaryRecords");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var rows = response.getReturnValue();
                rows.forEach(function(record){
                    record.linkName = '/'+record.Id;
                });
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if (row.Sales_Org__c) row.SalesOrgCode = row.Sales_Org__r.Sales_Org_Code__c;
                    if (row.Product_Name__c) {row.SKUName = row.Product_Name__r.SKU_Description__c;
                                              row.SKUCode = row.Product_Name__r.SKU_Code__c;}
                    if (row.Sold_To_Party__c) row.SoldToParty = row.Sold_To_Party__r.Name;
                }
                component.set("v.recordsList", response.getReturnValue());
                component.set("v.totalRecords", component.get("v.recordsList").length);
                var sObjectList = component.get("v.recordsList");
                var pageSize = component.get("v.pageSize");
                component.set("v.startPage",0);
                component.set("v.PageNumber",1);
                component.set("v.endPage",pageSize-1);
                var PaginationList = [];
                var totalAmount = 0;
                var totalQuantity =0;
                for(var i=0; i< pageSize; i++){
                    if(component.get("v.recordsList").length> i){
                        PaginationList.push(sObjectList[i]);
                        if (totalAmount == 0)
                            totalAmount += sObjectList[i].Sell_Amount_USD__c;
                        else
                            totalAmount += sObjectList[i].Sell_Amount_USD__c;
                        if (totalQuantity == 0){
                            totalQuantity += sObjectList[i].Product_Quantity__c;
                        }
                        else
                        {
                            totalQuantity += sObjectList[i].Product_Quantity__c;
                        }
                    }
                    component.set('v.PaginationList', PaginationList);
                    component.set("v.Quantity",'Quantity:');
                    component.set("v.Amount",'Amount:');
                    component.set("v.totalAmount",totalAmount.toFixed(1));
                    component.set("v.totalQuantity",totalQuantity.toFixed(2));
                    
                } 
                component.set("v.TotalPages", Math.ceil(component.get("v.totalRecords") / pageSize));
            }
        });
        $A.enqueueAction(action);
    },
    fetchInventory : function(component) {
        
        component.set('v.mycolumns', [
            {label: 'Inventory Name', fieldName: 'linkName', type: 'url', 
             typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
            {label: 'Created Date', fieldName: 'CreatedDate', type: 'date'},
            {label: 'Distributor', fieldName: 'CustomerName', type: 'Text'},
            {label: 'SKU Name', fieldName: 'SKUName', type: 'text'}, 
            {label: 'SKU Code', fieldName: 'SKUCode', type: 'text'},
            {label: 'City Name', fieldName: 'City__c', type: 'text'}, 
            {label: 'UoM', fieldName: 'UoM__c', type: 'text'}, 
            {label: 'Stock date', fieldName: 'Stock_Date__c', type: 'date'},
            {label: 'Stock available', fieldName: 'Stock_Quantity__c', type: 'number',  editable: true}
        ]);
        component.set('v.display',true);
        component.set('v.inventorySelected',true);
        component.set('v.salesSelected',false);
        
        var action = component.get("c.fetchInventoryRecords");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var rows = response.getReturnValue();
                rows.forEach(function(record){
                    record.linkName = '/'+record.Id;
                });
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if (row.Sales_Org__c) row.SalesOrgCode = row.Sales_Org__r.Sales_Org_Code__c;
                    if (row.SKU_Name__c) {row.SKUName = row.SKU_Name__r.Name;
                                          row.SKUCode = row.SKU_Name__r.SKU_Code__c;}
                    
                    if (row.Customer_Name__c) row.CustomerName = row.Customer_Name__r.Name;
                }
                component.set("v.recordsList", response.getReturnValue());
                component.set("v.totalRecords", component.get("v.recordsList").length);
                var sObjectList = component.get("v.recordsList");
                var pageSize = component.get("v.pageSize");
                component.set("v.startPage",0);
                component.set("v.PageNumber",1);
                component.set("v.endPage",pageSize-1);
                var PaginationList = [];
                for(var i=0; i< pageSize; i++){
                    if(component.get("v.recordsList").length> i)
                        PaginationList.push(sObjectList[i]);
                    component.set('v.PaginationList', PaginationList);
                } 
                component.set("v.TotalPages", Math.ceil(component.get("v.totalRecords") / pageSize));
            }
        });
        $A.enqueueAction(action);
    },
    filterRecords : function(component){
        
        var sObjectList = component.get("v.recordsList");
        var type = component.find('liquidationselect').get('v.value');
        if(type == 'Sales'){ 
            //fetch selected sku value
            var sku = component.find("selectSKU").get("v.value");
            var dist = component.find("selectDist").get("v.value");
            var month = component.find("liquidationcurrentMonth").get("v.value");
            var year = component.find("liquidationfinyear").get("v.value");
            if(sku)
                sku = sku.toUpperCase();
            if(dist)
                dist = dist.toUpperCase();
            
            var skudesc;var salesDist;var salesMonth;var salesYear;
            var pageNumber = component.get("v.PageNumber");
            var pageSize = component.get("v.pageSize");       
            var FilterList = [];
            var PaginationList = [];
            if(sku || dist || month || year){
                for(var i=0; i< sObjectList.length; i++){
                    if(sObjectList[i].SKUName)
                        skudesc = sObjectList[i].SKUName.toUpperCase();
                    if(sObjectList[i].SoldToParty)
                        salesDist = sObjectList[i].SoldToParty.toUpperCase();
                    if(sObjectList[i].Month__c)
                        salesMonth = sObjectList[i].Month__c;
                    if(sObjectList[i].Year__c)
                        salesYear = sObjectList[i].Year__c;
                    if(skudesc || salesDist || salesMonth || salesYear){
                        if((sku && skudesc.includes(sku)>0) || 
                           (dist && salesDist.includes(dist)>0 ) ||
                           (month && salesMonth.includes(month)>0) ||
                           (year && salesYear.includes(year)>0))
                            FilterList.push(sObjectList[i]);
                    }
                    
                }
                
            }
             component.set('v.FilterList', FilterList);
           
        }
        else if(type == 'Inventory'){
            //fetch selected sku value
            var sku = component.find("selectSKU").get("v.value");
            var dist = component.find("selectDist").get("v.value");
            var cDate = component.find("daterange").get("v.value");
            if(sku)
                sku = sku.toUpperCase();
            if(dist)
                dist = dist.toUpperCase();
            console.log('sku::'+sku);
            var skudesc;var salesDist;var salesDate;
            var pageNumber = component.get("v.PageNumber");
            var pageSize = component.get("v.pageSize");       
            var FilterList = [];
            var PaginationList = [];
            if(sku || dist || cDate){
                for(var i=0; i< sObjectList.length; i++){
                    if(sObjectList[i].SKUName)
                        skudesc = sObjectList[i].SKUName.toUpperCase();
                    if(sObjectList[i].CustomerName)
                        salesDist = sObjectList[i].CustomerName.toUpperCase();
                    if(sObjectList[i].Stock_Date__c)
                        salesDate = sObjectList[i].Stock_Date__c;
                    if(skudesc || salesDist || salesDate){
                        if((sku && skudesc.includes(sku)>0) || 
                           (dist && salesDist.includes(dist)>0 ) ||
                           (cDate && salesDate.includes(cDate)>0))
                            FilterList.push(sObjectList[i]);
                    }
                    
                }
                
            }
        }
        console.log('sku::'+sku);
        console.log('dist::'+dist);
        console.log('cDate::'+cDate);
        console.log('month::'+month);
        console.log('year::'+year);
        if((sku === ""|| sku == undefined) && (dist === ""|| dist == undefined) && (cDate === ""|| cDate == undefined)
           && (month === "Select") && (year === "Select")){
            FilterList= component.get("v.recordsList");                
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
    multipleFilterRecords : function(component){
        
        var sObjectList = component.get("v.recordsList");
        var type = component.find('liquidationselect').get('v.value');
        if(type == 'Sales'){ 
            var sku = component.find("selectSKU").get("v.value");
            var dist = component.find("selectDist").get("v.value");
            var city = component.find("selectCity").get("v.value");
            var month = component.find("liquidationcurrentMonth").get("v.value");
            var year = component.find("liquidationfinyear").get("v.value");
            if(sku)
                sku = sku.toUpperCase();
            if(dist)
                dist = dist.toUpperCase();
            if(city)
                city = city.toUpperCase();
            
            var skudesc;var salesDist;var salesMonth;var salesYear;
            var pageNumber = component.get("v.PageNumber");
            var pageSize = component.get("v.pageSize");       
            //var FilterList = [];
            var PaginationList = [];
            var query = {};
            if(sku)
                query.SKUName = sku;
            if(dist)
                query.SoldToParty = dist;
            if(city)
                query.City__c = city;
            if(month && month != 'Select')
                query.Month__c = month;
            if(year && year != 'Select')
                query.Year__c = year;
            
            console.log('query'+JSON.stringify(query));
            var filteredData = sObjectList.filter( (item) => {
                for (let key in query) {
                if (item[key] === undefined || !item[key].toUpperCase().includes(query[key])) {
                return false;
            }                                     }
                                                  return true;
                                                  });
            component.set('v.FilterList', filteredData);
            console.log('filtered::'+JSON.stringify(component.get('v.FilterList')));
            var totalAmount= 0;
            var totalQuantity =0;
            var filtered = component.get('v.FilterList');
         for(var i=0; i< pageSize; i++){
             if(filtered.length> i){
                PaginationList.push(filtered[i]);
            if (totalAmount == 0)
                    totalAmount += filtered[i].Sell_Amount_USD__c;
                else
                    totalAmount += filtered[i].Sell_Amount_USD__c;
                if(totalQuantity == 0)    
                  totalQuantity += filtered[i].Product_Quantity__c;
                else
                  totalQuantity += filtered[i].Product_Quantity__c;
             }
            
          }  
        component.set("v.totalQuantity",totalQuantity.toFixed(2));
        component.set("v.totalAmount",totalAmount.toFixed(1));
        }
        else if(type == 'Inventory'){
            //fetch selected sku value
            var sku = component.find("selectSKU").get("v.value");
            var dist = component.find("selectDist").get("v.value");
            var city = component.find("selectCity").get("v.value");
            var cDate = component.find("daterange").get("v.value");
            if(sku)
                sku = sku.toUpperCase();
            if(dist)
                dist = dist.toUpperCase();
            if(city)
                city = city.toUpperCase();
            console.log('sku::'+sku);
            var skudesc;var salesDist;var salesDate;
            var pageNumber = component.get("v.PageNumber");
            var pageSize = component.get("v.pageSize");       
            //var FilterList = [];
            var PaginationList = [];
            var query = {};
            if(sku)
                query.SKUName = sku;
            if(dist)
                query.CustomerName = dist;
             if(city)
                query.City__c = city;
            
            console.log('query'+JSON.stringify(query));
            var filteredData = sObjectList.filter( (item) => {
                console.log('item'+JSON.stringify(item));
                for (let key in query) {
                if (item[key] === undefined || !item[key].toUpperCase().includes(query[key])) {
                return false;
            }
                                                  }
                                                  return true;
                                                  });
            component.set('v.FilterList', filteredData);
            var filtered = component.get('v.FilterList');
            console.log('filtered::'+component.get('v.FilterList'));
                for(var i=0; i< pageSize; i++){
             if(filtered.length> i)
                PaginationList.push(filtered[i]);} 
        }
        console.log('sku::'+sku);
        console.log('dist::'+dist);
        console.log('City::'+city);
        console.log('cDate::'+cDate);
        console.log('month::'+month);
        console.log('year::'+year);
        var filtered = component.get('v.FilterList');
      /* for(var i=0; i< pageSize; i++){
            if(filtered.length> i)
                PaginationList.push(filtered[i]);
            
        }*/
        console.log('filtered pagination::'+PaginationList);
        component.set("v.PaginationList", PaginationList);
        component.set("v.startPage",0);
        component.set("v.PageNumber",1);
        component.set("v.totalRecords", component.get("v.FilterList").length);
        component.set("v.TotalPages", Math.ceil(component.get("v.totalRecords") / pageSize));
        component.set("v.endPage",pageSize-1);//
        
        
    }
})