({
    textKeyChange: function (component, termtext) {
        console.log('term value :-----' + termtext)
        //var searchKey =  component.find("input1").get("v.value"); 
        var searchKey = termtext;
        //searchKey = searchKey.toUpperCase();
        var recordToDisply = component.find("recordSize").get("v.value");
        var searchFeild = component.get("v.selectBy");
        var searchDepot = component.get("v.Selected_Depots");
        component.set("v.page", 1);
        var page = component.get("v.page");
        // alert(searchKey);
        
        if ($A.util.isUndefined(searchKey) || searchKey == '') {
            this.fetchRequirements(component, page, recordToDisply,searchDepot);
            console.log('Helper Product SKU Inside If');
        }else {
            
            // var opts = component.find("select_id").get("v.value");
            var opts = document.querySelector('input[name="options"]:checked').value;
            
            // var searchDepot = component.find("depot_items").get("v.value");
            //var searchDepot = 'PD01';
			
            if (opts == 'Product/Sku' || opts == 'Product/SKU') {
                this.searchRequirements(component, searchFeild, searchKey, page, recordToDisply,searchDepot);
            } else if (opts == 'Storage Location') {
                if (searchKey != null) {
                    console.log('Helper Product SKU Inside ELSE Storage Location searchKey-> '+searchKey);
                    this.searchRequirements(component, searchFeild, searchKey, page, recordToDisply,searchDepot);
                }
            } else if (opts == 'SKU Code') {
                if (searchKey != null) {
                    this.searchRequirements(component, searchFeild, searchKey, page, recordToDisply,searchDepot);
                }
            } else if (opts == 'Brand Name') {
                if (searchKey != null) {
                    this.searchRequirements(component, searchFeild, searchKey, page, recordToDisply,searchDepot);
                }

            }
        }

    },
    
    fetchDepot: function (component) {
        var page = component.get("v.page") || 1;
        var recordToDisply = component.find("recordSize").get("v.value");
        var searchDepot = '';
        var action = component.get("c.getDepot");
        var opts = [];
        console.log('Fetch Depot');
		
        action.setCallback(this, function (response) {
            var returnValue = response.getReturnValue();
            var state = response.getState();
            var selectedDepots = '';
            console.log('state '+state);
            if (state == "SUCCESS") {
                console.log('This Is Working');
                // var returnValue = JSON.parse(returnValue);
                console.log('response.getReturnValue();--------->',returnValue);
                
                for (var i = 0; i < returnValue.length; i++) {
                    console.log('Country__c :'+returnValue[i].Country__c);
                    component.set('v.countryName',returnValue[i].Country__c);
                    selectedDepots = selectedDepots + returnValue[i].Name + ";";
                }

                if (returnValue != undefined && returnValue.length > 0) {
                    console.log("if ALL ---> --->",selectedDepots); 
                    component.set("v.Selected_Depots",selectedDepots);
                    opts.push({ "class": "optionClass", label: $A.get("$Label.c.All"), value: selectedDepots, selected: "true" });
                }
                for (var i = 0; i < returnValue.length; i++) {
                    opts.push({ "class": "optionClass", label: returnValue[i].Depot_Code__c, value: returnValue[i].Name });
                }
                console.log("v.options----------------------------------------------------->", opts);
                console.log(selectedDepots);
                component.find("depot_items").set("v.options", opts);
                this.fetchRequirements(component, page, recordToDisply, selectedDepots);   // New Added by MMFurkan 03-feb-2020 

            }
        });
        $A.enqueueAction(action);
    },
    
	fetchRequirements : function(component,page, recordToDisply,selectedDepot){
        var action = component.get('c.getInventories');   
        var SAPchkBox = component.get('v.SAPCheboxBoolean');
        action.setParams({
            pageNumber: page,
            recordToDisply: recordToDisply,
            SelectedDepots: selectedDepot,
            NoZeroSAPRecord: SAPchkBox 
        });
        action.setCallback(this, function(response){
            //store state of response
            var returnValue = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS"){
                component.set('v.Wrapperlist',returnValue.listWrapStkReqInv);
                component.set('v.isAdmin',returnValue.isAdmin);
                component.set("v.page", returnValue.page);  
                component.set("v.total", parseInt(returnValue.total));  
                component.set("v.pages", Math.ceil(returnValue.total / recordToDisply)); 
               console.log('isAdmin>>--->'+returnValue.isAdmin);
                console.log('pages>>--->'+component.get("v.pages"));
               console.log('total>>--->'+component.get("v.total"));
               console.log('page>>--->'+component.get("v.page"));
                console.log('Wrapperlist : '+JSON.stringify(component.get("v.Wrapperlist")));
                /*var Wrapperlist=component.get("v.Wrapperlist");
                for(var i=0;i<=Wrapperlist.length;i++){
                    console.log('sales org code :'+Wrapperlist[0].Depot__r.SalesOrg__r.Sales_Org_Code__c);
                }*/
            }
        });
        $A.enqueueAction(action); 	
	},
   
    searchRequirements : function(component,searchFeild,searchKey,page,recordToDisply, SelectedDepots){
        console.log('SelectedDepots :'+SelectedDepots);
        var recordToDisply1 = recordToDisply;
       
        var action = component.get("c.getBySKUAndSLocation"); 
         
        action.setParams({ 
            "fieldName":  searchFeild,
            "value": searchKey,
            "pageNumber": page,
            "recordToDisply": recordToDisply  
        });  
         action.setCallback(this, function(response){
             
         var returnValue = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS"){
                component.set('v.Wrapperlist',returnValue.listWrapStkReqInv);
                component.set("v.page", returnValue.page);  
                component.set("v.total", parseInt(returnValue.total));  
               // console.log('pages>>--->'+returnValue.total);
               // console.log('record to display>>--->'+recordToDisply1);
                component.set("v.pages", Math.ceil(returnValue.total / recordToDisply1)); 
             
                if(returnValue.listWrapStkReqInv.length==0){
                  	this.errormsg(component);
                     var page = component.get("v.page") || 1; 
        			var recordToDisply = component.find("recordSize").get("v.value"); 
       				this.fetchRequirements(component,page,recordToDisply);
                    // component.find("input1").set("v.value","");
        		} 
              
            }
        });
        $A.enqueueAction(action);       
    
	},
   
   
    errormsg:function(component,event){
         var staticLabel = $A.get("$Label.c.No_Such_Data_Present_in_system");
       // alert(staticLabel);
       //  console.log('ewtewwe');
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: 'dismissible',
            duration:'5',
            message: staticLabel,
            key: 'info_alt',
            type : 'info'
        });
        toastEvent.fire();
    }
})