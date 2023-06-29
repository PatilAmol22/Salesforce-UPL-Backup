({
	//Search 
	
 filterRecords : function(component){
        
        console.log('in filterRecords');
        var sObjectList = component.get("v.custPLs");
        //fetch selected Brand value
        var brandSearch = component.find("brandSearch").get("v.value");
        //fetch SKU
        console.log('before');
		var SKUNameSearch=component.find("SKUNameSearch").get("v.value");
     console.log('after');
        var SKUSearch = component.find("SKUSearch").get("v.value"); 
         //description = description.toUpperCase();
        
        var SKUNamelist;
        var brandlist;
		var SKUCodelist;
		
        var pageNumber = component.get("v.PageNumber");
        var pageSize = component.get("v.pageSize");       
        var FilterList = [];
        var PaginationList = [];
        //brand and skuName and skuCode is not null
        if(brandSearch && SKUNameSearch && SKUSearch){
            for(var i=0; i< sObjectList.length; i++){
				brandlist=sObjectList[i].brand;
                SKUNamelist = sObjectList[i].SKUName;
                SKUCodelist=sObjectList[i].SKUCode;			
                
                
                
                if(SKUNamelist &&  SKUCodelist && brandlist){
                    brandlist=brandlist.toLowerCase();
               		brandSearch=brandSearch.toLowerCase();                
                	SKUNamelist=SKUNamelist.toLowerCase();
                	SKUNameSearch=SKUNameSearch.toLowerCase();
					SKUSearch=SKUSearch.toLowerCase();
					SKUCodelist=SKUCodelist.toLowerCase();
					
                    //if((!brandlist.search(new RegExp(brand, "i")))
                       //&& (!skuNamelist.search(new RegExp(skuCodeName, "i"))))
                    if((brandlist.includes(brandSearch)>0) && (SKUNamelist.includes(SKUNameSearch)>0) && (SKUCodelist.includes(SKUSearch)>0))
                        FilterList.push(sObjectList[i]);
                }                
            }            
        } 
        //brand != null and skuCodeName is null
      
         if(brandSearch && ( (SKUNameSearch === undefined ||  SKUNameSearch == "") && (SKUSearch === undefined || SKUSearch== ""))){
            console.log('brand is not null');
            for(var i=0; i< sObjectList.length; i++){
                brandlist=sObjectList[i].brand;
                if(brandlist){
                    brandlist=brandlist.toLowerCase();
                    brandSearch=brandSearch.toLowerCase();                    
                    if(brandlist.includes(brandSearch)>0){                    
                    //if(!brandlist.search(new RegExp(brand, "i"))){
                        FilterList.push(sObjectList[i]);
                }
                }                 
            }            
        }
        //SKUNameSearch is not null and brand and code == null 
        if(SKUNameSearch && ((brandSearch ==="" || brandSearch == undefined)&& (SKUSearch === undefined || SKUSearch== ""))){
            
        	SKUNameSearch = SKUNameSearch.toUpperCase();
        	console.log('sObjectList.length--'+sObjectList.length);
            for(var i=0; i< sObjectList.length; i++){
                
                SKUNamelist = sObjectList[i].SKUName;
                
                if(SKUNamelist){
                    SKUNamelist=SKUNamelist.toLowerCase();
                    SKUNameSearch=SKUNameSearch.toLowerCase();
                    //if(!skuNamelist.search(new RegExp(skuCodeName, "i"))){
                       if(SKUNamelist.includes(SKUNameSearch)>0){
                   	   console.log('sObjectList[i]--'+sObjectList[i]);
                        FilterList.push(sObjectList[i]);
                    }
                }
            }
            
        }
		//SKUCode is not null  and brand and SKUName == null 
        if(SKUSearch && ((brandSearch ==="" || brandSearch == undefined)&& (SKUNameSearch === undefined || SKUNameSearch== ""))){
            
        	SKUSearch = SKUSearch.toUpperCase();
        	console.log('sObjectList.length--'+sObjectList.length);
            for(var i=0; i< sObjectList.length; i++){
                
                SKUCodelist = sObjectList[i].SKUCode;
                
                if(SKUCodelist){
                    SKUCodelist=SKUCodelist.toLowerCase();
                    SKUSearch=SKUSearch.toLowerCase();
                    //if(!SKUCodelist.search(new RegExp(skuCodeName, "i"))){
                       if(SKUCodelist.includes(SKUSearch)>0){
                   	   console.log('sObjectList[i]--'+sObjectList[i]);
                        FilterList.push(sObjectList[i]);
                    }
                }
            }
            
        }
		
		if(brandSearch && SKUNameSearch && (SKUSearch === undefined || SKUSearch== "")){
            for(var i=0; i< sObjectList.length; i++){
				brandlist=sObjectList[i].brand;
                SKUNamelist = sObjectList[i].SKUName; 
                
                if(SKUNamelist && brandlist){
                    brandlist=brandlist.toLowerCase();
               		brandSearch=brandSearch.toLowerCase();                
                	SKUNamelist=SKUNamelist.toLowerCase();
                	SKUNameSearch=SKUNameSearch.toLowerCase();				
					
                    //if((!brandlist.search(new RegExp(brand, "i")))
                       //&& (!skuNamelist.search(new RegExp(skuCodeName, "i"))))
                    if((brandlist.includes(brandSearch)>0) && (SKUNamelist.includes(SKUNameSearch)>0))
                        FilterList.push(sObjectList[i]);
                }                
            }            
        } 
		
		if(brandSearch && SKUSearch  && (SKUNameSearch === undefined || SKUNameSearch== "")){
            for(var i=0; i< sObjectList.length; i++){
				brandlist=sObjectList[i].brand;
                SKUCodelist = sObjectList[i].SKUCode; 
                
                if(SKUCodelist && brandlist){
                    brandlist=brandlist.toLowerCase();
               		brandSearch=brandSearch.toLowerCase();                
                	SKUCodelist=SKUCodelist.toLowerCase();
                	SKUSearch=SKUSearch.toLowerCase();				
					
                    //if((!brandlist.search(new RegExp(brand, "i")))
                       //&& (!skuNamelist.search(new RegExp(skuCodeName, "i"))))
                    if((brandlist.includes(brandSearch)>0) && (SKUCodelist.includes(SKUSearch)>0))
                        FilterList.push(sObjectList[i]);
                }                
            }            
        } 
		if(SKUNameSearch && SKUSearch  && (brandSearch === undefined || brandSearch == "")){
            for(var i=0; i< sObjectList.length; i++){
				SKUNamelist=sObjectList[i].SKUName;
                SKUCodelist = sObjectList[i].SKUCode; 
                
                if(SKUCodelist && SKUNamelist){
                    SKUNamelist=SKUNamelist.toLowerCase();
               		SKUNameSearch=SKUNameSearch.toLowerCase();                
                	SKUCodelist=SKUCodelist.toLowerCase();
                	SKUSearch=SKUSearch.toLowerCase();				
					
                    //if((!brandlist.search(new RegExp(brand, "i")))
                       //&& (!skuNamelist.search(new RegExp(skuCodeName, "i"))))
                    if((SKUNamelist.includes(SKUNameSearch)>0) && (SKUCodelist.includes(SKUSearch)>0))
                        FilterList.push(sObjectList[i]);
                }                
            }            
        } 
		
		
        //Both skuCodeName and brand null
          if((SKUSearch==="" || SKUSearch== undefined)&& (brandSearch === "" || brandSearch== undefined) && (SKUNameSearch === "" || SKUNameSearch== undefined)){
            FilterList= component.get("v.custPLs");                
        }
        component.set('v.FilterList', FilterList);
        
        for(var i=0; i< pageSize; i++){
            if(FilterList.length> i)
                PaginationList.push(FilterList[i]);
            
        } 
        component.set("v.PaginationList", PaginationList);
        component.set("v.startPage",0);
        component.set("v.PageNumber",1);
        component.set("v.totalRecords", component.get("v.FilterList").length);
        component.set("v.TotalPages", Math.ceil(component.get("v.totalRecords") / pageSize));
        component.set("v.endPage",pageSize-1);//
        
        
    },
    convertArrayOfObjectsToCSV : function(component,objectRecords){
        var csvStringResult, counter, keys, columnDivider, lineDivider, headers, value;
       
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
         }
        columnDivider = ';';
        lineDivider =  '\n';
 
        // in the keys variable store fields API Names as a key 
        // this labels use in CSV file header  
        headers = ['Marca','Produto','Codigo','Moeda','Preco Unitario BRL','Preco Unitario USD'];
        keys = ['brand','SKUName','SKUCode','currISOCode','unitPriceBR','unitPriceUS'];
        
        csvStringResult = '';
        csvStringResult += headers.join(columnDivider);
        csvStringResult += lineDivider;
 
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
           
             for(var sTempkey in keys) {
                var skey = keys[sTempkey] ; 
                 console.log('Key name is--'+skey);
                  if(counter > 0){ 
                      csvStringResult += columnDivider; 
                   }   
                 if(skey == "unitPriceUS" || skey == "unitPriceBR"){
                     var valueTemp = '"'+ objectRecords[i][skey]+'"';
                     value = valueTemp.replace(".",",");
                 } 
                 else{
                     value = '"'+ objectRecords[i][skey]+'"';
                 }
               csvStringResult += value; //csvStringResult += '"'+ objectRecords[i][skey]+'"'; 
               console.log('csv string result--'+value);
               counter++;
 
            }  
             csvStringResult += lineDivider;
          }
        return csvStringResult; 
    },

    /* filterRecords : function(component){
        
        console.log('in filterRecords');
        var sObjectList = component.get("v.custPLs");
        //fetch selected Brand value
        var brand = component.find("brandSearch").get("v.value");
        //fetch SKU
        var skuCodeName = component.find("SKUSearch").get("v.value"); 
        console.log('brand--'+brand+'--skuCodeName--'+skuCodeName);
        //description = description.toUpperCase();
        
        var skusearch;
        var brandSearch;
        var pageNumber = component.get("v.PageNumber");
        var pageSize = component.get("v.pageSize");       
        var FilterList = [];
        var PaginationList = [];
        //brand and skuCodeName is not null
        if(brand && skuCodeName){
            for(var i=0; i< sObjectList.length; i++){
                skusearch = sObjectList[i].SKUCode;
                brandSearch=sObjectList[i].SKUName;
                
                
                //SKU search value is null
                if(skusearch && brandSearch){
                    brandSearch=brandSearch.toLowerCase();
               		brand=brand.toLowerCase();                
                	skusearch=skusearch.toLowerCase();
                	skuCodeName=skuCodeName.toLowerCase();
                    //if((!brandSearch.search(new RegExp(brand, "i")))
                       //&& (!skusearch.search(new RegExp(skuCodeName, "i"))))
                    if((brandSearch.includes(brand)>0) && (skusearch.includes(skuCodeName)>0))
                        FilterList.push(sObjectList[i]);
                }                
            }            
        } 
        //brand != null and skuCodeName is null
        console.log('brand--'+brand);
         if(brand &&  (skuCodeName === undefined ||  skuCodeName == "")){
            console.log('brand is not null');
            for(var i=0; i< sObjectList.length; i++){
                brandSearch=sObjectList[i].SKUName;
                console.log('brandSearch--'+brandSearch);
                if(brandSearch){
                    brandSearch=brandSearch.toLowerCase();
                    brand=brand.toLowerCase();                    
                    if(brandSearch.includes(brand)>0){                    
                    //if(!brandSearch.search(new RegExp(brand, "i"))){
                        console.log('brand added');
                        FilterList.push(sObjectList[i]);
                }
                }                 
            }            
        }
        //skuCodeName is not null and brand == null 
        if(skuCodeName && (brand ==="" || brand == undefined)){
            
        	skuCodeName = skuCodeName.toUpperCase();
        	console.log('sObjectList.length--'+sObjectList.length);
            for(var i=0; i< sObjectList.length; i++){
                
                skusearch = sObjectList[i].SKUCode;
                
                if(skusearch){
                    skusearch=skusearch.toLowerCase();
                    skuCodeName=skuCodeName.toLowerCase();
                    //if(!skusearch.search(new RegExp(skuCodeName, "i"))){
                       if(skusearch.includes(skuCodeName)>0){
                   	   console.log('sObjectList[i]--'+sObjectList[i]);
                        FilterList.push(sObjectList[i]);
                    }
                }
            }
            
        }
        //Both skuCodeName and brand null
          if((skuCodeName==="" || skuCodeName== undefined)&& (brand === "" || brand== undefined)){
            FilterList= component.get("v.custPLs");                
        }
        component.set('v.FilterList', FilterList);
        
        for(var i=0; i< pageSize; i++){
            if(FilterList.length> i)
                PaginationList.push(FilterList[i]);
            
        } 
        component.set("v.PaginationList", PaginationList);
        component.set("v.startPage",0);
        component.set("v.PageNumber",1);
        component.set("v.totalRecords", component.get("v.FilterList").length);
        component.set("v.TotalPages", Math.ceil(component.get("v.totalRecords") / pageSize));
        component.set("v.endPage",pageSize-1);//
        
        
    }, */
})