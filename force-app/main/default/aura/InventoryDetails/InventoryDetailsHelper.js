({
    helperUpdateAvailability : function(component, rowIndex,event, helper,target, InventoryRecordToUpdate){              
       	var index = event.target.dataset.index;
        var pagination = component.get("v.invntId");
        var isRequiredFieldError = false;
        var avail1=InventoryRecordToUpdate.avail;
        var availdate=InventoryRecordToUpdate.availdte;
        console.log('avail1'+avail1);
        console.log('availdate--'+availdate);
        
        console.log('Id 	--'+InventoryRecordToUpdate.Id);
        var locale = $A.get("$Locale.language");
        var inputfield=component.find("availDteerro");
        if((avail1 == 'Empty' || avail1 == 'Indisponível') && (InventoryRecordToUpdate.availDate == '' || InventoryRecordToUpdate.availDate == undefined) )
        {
            component.set("v.showAvailabilityDateError", true);
            component.set("v.AvailabilityVal", avail1);
            console.log('set required to true--'+inputfield);            
            //$A.util.removeClass(component.find('availDteerro'),'slds-hide');
        	isRequiredFieldError = true;
        }
        else{
            isRequiredFieldError = false;
            component.set("v.showAvailabilityDateError", true);
            //var outtext = component.find('availDteerro');
			//$A.util.addClass(outtext , 'slds-hide');
            
        }
        if(isRequiredFieldError == true )
        {
           /* if(locale='pt'){
               InventoryRecordToUpdate.avail= 'Indisponível';
            }else
            InventoryRecordToUpdate.avail='Empty'; */
            return;
        }
        else
        {
        	console.log("calling update availability");
            var action = component.get("c.upsertAvailabilityDetails");        
        
        action.setParams({
           	Wh: InventoryRecordToUpdate.warehouse,
            SKUCode: InventoryRecordToUpdate.SKUCode,            
            Avail:InventoryRecordToUpdate.avail,
            Id: InventoryRecordToUpdate.Id,
            Availdte :InventoryRecordToUpdate.availdte,
            comment:InventoryRecordToUpdate.comment
            
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
              //component.set("v.invntId",response.getReturnValue()); 
                InventoryRecordToUpdate.Id=response.getReturnValue();
                console.log('calling helperUpdateAvailabilityDate');
                //this.helperUpdateAvailabilityDate(component, rowIndex, event, helper,target, InventoryRecordToUpdate);
                if(InventoryRecordToUpdate.availDate == undefined || InventoryRecordToUpdate.availDate==''){
                    InventoryRecordToUpdate.availDate=null;
                    this.helperSubUpdateavailDte(component, rowIndex,event, helper,target, InventoryRecordToUpdate);
                }
                }
            else{
               console.log(response.getState()+response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);        
        }
    },
    helperUpdateAvailabilityDate : function(component, rowIndex,event, helper,target, InventoryRecordToUpdate){              
        
        
        var Id;
        var dateValidationError;
        var pagination = component.get("v.invntId");
        var inputfield=event.getSource();
		var today = new Date();        
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();
     // if date is less then 10, then append 0 before date   
        if(dd < 10){
            dd = '0' + dd;
        } 
    // if month is less then 10, then append 0 before date    
        if(mm < 10){
            mm = '0' + mm;
        }
     var todayFormattedDate = yyyy+'-'+mm+'-'+dd;        
	 if(InventoryRecordToUpdate.availDate != '' && InventoryRecordToUpdate.availDate != undefined && InventoryRecordToUpdate.availDate < todayFormattedDate){
			//$A.util.removeClass(component.find("availDteerro1"),"slds-hide");
           //var errtxt=	$A.get("$Label.c.Future_Date_Error");
        
         inputfield.setCustomValidity($A.get("$Label.c.Future_Date_Error"));         	
         	inputfield.reportValidity();	
         dateValidationError =true; 
     }
     else{
         	
         //$A.util.addClass(component.find('availDteerro1'),'slds-hide');         
         	inputfield.setCustomValidity('');
         	inputfield.reportValidity();
         	dateValidationError = false;
         
    }
		
        if(dateValidationError == true)
        {
            
            return;
        }
        else
        {
            console.log('Avail*'+InventoryRecordToUpdate.avail);
            console.log('availDate*'+InventoryRecordToUpdate.availDate);
            console.log('Id*--'+InventoryRecordToUpdate.Id);
            if(InventoryRecordToUpdate.avail != 'Empty' || InventoryRecordToUpdate.availDate != null){
             // || InventoryRecordToUpdate.avail != 'Indisponível'){
        var action = component.get("c.upsertAvailabilityDateDetails");        
        action.setParams({
            Wh: InventoryRecordToUpdate.warehouse,
            SKUCode: InventoryRecordToUpdate.SKUCode,            
            Avail:InventoryRecordToUpdate.avail,
            Id: InventoryRecordToUpdate.Id,
            Availdte :InventoryRecordToUpdate.availDate,
            comment:InventoryRecordToUpdate.comment
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state--'+state);
            if (state === "SUCCESS") {
              InventoryRecordToUpdate.Id=response.getReturnValue();
                Id=response.getReturnValue();
                console.log('Id--'+Id);
				this.helperSubUpdateavail(component, rowIndex,event, helper,target, InventoryRecordToUpdate);
            }
            });
        
        $A.enqueueAction(action);
            }
        }
    },
	
	
    helperSubUpdateavailDte: function(component, rowIndex,event, helper,target, InventoryRecordToUpdate){
		var action = component.get("c.upsertAvailabilityDateDetails");        
        
        console.log('new avail-'+InventoryRecordToUpdate.avail);
        console.log('new Id-'+InventoryRecordToUpdate.Id);
        console.log('new availDate-'+InventoryRecordToUpdate.availDate);
        action.setParams({
            Wh: InventoryRecordToUpdate.warehouse,
            SKUCode: InventoryRecordToUpdate.SKUCode,            
            Avail:InventoryRecordToUpdate.avail,
            Id: InventoryRecordToUpdate.Id,
            Availdte :InventoryRecordToUpdate.availDate,
            comment:InventoryRecordToUpdate.comment
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state--'+state);
            if (state === "SUCCESS") {
              InventoryRecordToUpdate.Id=response.getReturnValue();                
                console.log('state1--'+ '--'+state);
				}
            });
        
        $A.enqueueAction(action);
            },
            
    
	helperSubUpdateavail: function(component, rowIndex,event, helper,target, InventoryRecordToUpdate){
		
        //var availVal=component.get("v.AvailabilityVal");
        var availVal=InventoryRecordToUpdate.avail;
        console.log('availVal-'+InventoryRecordToUpdate.avail);
        if(availVal =='Empty'){ // || availVal =='Indisponível'){
            var action1 = component.get("c.upsertAvailabilityDetails");        
        	console.log('InventoryRecordToUpdate.avail'+InventoryRecordToUpdate.avail);
            console.log('InventoryRecordToUpdate.Id'+InventoryRecordToUpdate.Id);
            console.log(InventoryRecordToUpdate.warehouse+'--'+InventoryRecordToUpdate.SKUCode);
            action1.setParams({
                Wh: InventoryRecordToUpdate.warehouse,
                SKUCode: InventoryRecordToUpdate.SKUCode,            
                Avail:InventoryRecordToUpdate.avail,
                Id: InventoryRecordToUpdate.Id,
                Availdte :InventoryRecordToUpdate.availDate,
                comment:InventoryRecordToUpdate.comment
            });
            action1.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
              component.set("v.InventoryRecordToUpdate",response.getReturnValue()); 
               InventoryRecordToUpdate.Id=response.getReturnValue();     
            }
            else{
               console.log(response.getState()+response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action1); 
       }
	
	},
       helperUpdateComment : function(component, rowIndex,event, helper,target, InventoryRecordToUpdate){              
        var pagination = component.get("v.invntId");
        var action = component.get("c.upsertCommentDetails");
        console.log('Wh'+InventoryRecordToUpdate.warehouse);
        console.log('Coments'+InventoryRecordToUpdate.comment);
        console.log('SKUCode'+InventoryRecordToUpdate.SKUCode);
           console.log('availDate'+InventoryRecordToUpdate.availDate);
           console.log('avail'+InventoryRecordToUpdate.avail);
           action.setParams({
            Wh: InventoryRecordToUpdate.warehouse,
            SKUCode: InventoryRecordToUpdate.SKUCode,            
            Avail:InventoryRecordToUpdate.avail,
            Id: InventoryRecordToUpdate.Id,
            Availdte :InventoryRecordToUpdate.availDate,
            comment:InventoryRecordToUpdate.comment
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {                
            InventoryRecordToUpdate.Id=response.getReturnValue(); 
            }
        });
        
        $A.enqueueAction(action);    
        
        
    },
    //Search Filter
    filterRecords : function(component){
        
        console.log('in filterRecords');
        var sObjectList = component.get("v.invntId");
        //fetch selected Brand value
        var brand = component.find("brandSearch").get("v.value");
        //fetch SKU
        var skuCodeName = component.find("SKUSearch").get("v.value"); 
        console.log('skuCodeName--'+skuCodeName);
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
                skusearch = sObjectList[i].SKU;
                brandSearch=sObjectList[i].brandName;
                
                
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
                brandSearch=sObjectList[i].brandName;
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
                
                skusearch = sObjectList[i].SKU;
                
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
            FilterList= component.get("v.invntId");                
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

})