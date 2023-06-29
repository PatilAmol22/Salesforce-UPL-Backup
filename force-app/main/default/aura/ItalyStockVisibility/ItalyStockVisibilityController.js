({
	doInit : function(component, event, helper) {
        var page = component.get("v.page") || 1; 
        var recordToDisply = component.find("recordSize").get("v.value"); 
        var salesOrgCode ='2410';
        var distributionChannelCode ='20';
        var divisionCode ='10';
        var search_product_name=component.find("search_product_name").get("v.value");
        var search_product_code=component.find("search_product_code").get("v.value");
        component.set('v.search_product_name','');
        component.set('v.search_product_code','');
        helper.fetchActivities(component, salesOrgCode, distributionChannelCode, divisionCode, page, recordToDisply,'',''); 

        
    },
    fileUpload:function(component,event,helper){
        component.set("v.isOpen", true);
    },
    onSearchCloseModel : function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
        component.set("v.isSKUOpen", false);
    },
    isSkuBlank:function(component,event,helper){
        var page = component.get("v.page") || 1; 
        var recordToDisply = component.find("recordSize").get("v.value"); 
        var salesOrgCode ='2410';
        var distributionChannelCode ='20';
        var divisionCode ='10';
        var search_product_name=component.find("search_product_name").get("v.value");
        var search_product_code=component.find("search_product_code").get("v.value");
        if(search_product_name.length==0 && search_product_code.length==0){
            helper.fetchActivities(component, salesOrgCode, distributionChannelCode, divisionCode, page, recordToDisply,'',''); 
        }
    },
    
    onSelectChange: function(component, event, helper) {  
        var target = event.getSource();  
        var value = target.get("v.value");
        var page = 1  
        var recordToDisply = component.find("recordSize").get("v.value");
        var salesOrgCode ='2410';
        var distributionChannelCode ='20';
        var divisionCode ='10';
        helper.fetchActivities(component,salesOrgCode,distributionChannelCode,divisionCode, page, recordToDisply,'','');
    },
    previousPage: function(component, event, helper) {  
        var recordToDisply = component.find("recordSize").get("v.value"); 
        component.set("v.page", component.get("v.page") - 1);  
        var salesOrgCode ='2410';
        var distributionChannelCode ='20';
        var divisionCode ='10';
        helper.fetchActivities(component,salesOrgCode,distributionChannelCode,divisionCode, component.get("v.page"), recordToDisply,'','');          
       }, 
    
    gotoFirstPage : function(component, event, helper) {  
        component.set("v.page",1);  
        var recordToDisply = component.find("recordSize").get("v.value");  
        var salesOrgCode ='2410';
        var distributionChannelCode ='20';
        var divisionCode ='10';
        helper.fetchActivities(component,salesOrgCode,distributionChannelCode,divisionCode, 1, recordToDisply,'','');  
       },  
    
    gotoLastPage : function(component, event, helper) {  
        
        component.set("v.page",component.get("v.pages"));  
        var recordToDisply = component.find("recordSize").get("v.value");  
        var salesOrgCode ='2410';
        var distributionChannelCode ='20';
        var divisionCode ='10';
        helper.fetchActivities(component,salesOrgCode,distributionChannelCode,divisionCode, component.get("v.pages"), recordToDisply,'','');  
      },  
    
    nextPage: function(component, event, helper) {  
        var recordToDisply = component.find("recordSize").get("v.value");
        component.set("v.page", component.get("v.page") + 1);
        var salesOrgCode ='2410';
        var distributionChannelCode ='20';
        var divisionCode ='10';
        helper.fetchActivities(component,salesOrgCode,distributionChannelCode,divisionCode, component.get("v.page"), recordToDisply,'','');  
       },
    onSearch : function(component,event,helper){
        var page = component.get("v.page") || 1; 
        var recordToDisply = component.find("recordSize").get("v.value"); 
        var salesOrgCode ='2410';
        var distributionChannelCode ='20';
        var divisionCode ='10';
        var search_product_name=component.find("search_product_name").get("v.value");
        var search_product_code=component.find("search_product_code").get("v.value");
        
        if(search_product_name.length>1){
            console.log('search_product_name : '+search_product_name);
            var productIdentification='productName';
            helper.fetchActivities(component, salesOrgCode, distributionChannelCode, divisionCode, '1', recordToDisply,search_product_name,productIdentification); 
        }else if(search_product_code.length>1){
            console.log('search_product_code : '+search_product_code);
            var productIdentification='productCode';
            helper.fetchActivities(component, salesOrgCode, distributionChannelCode, divisionCode, '1', recordToDisply,search_product_code,productIdentification); 
        }
    },
    onEdit : function(component,event){
        component.set("v.isSKUOpen", true);
        //component.set("v.isSKUOpen", true);
        
        var src = event.getSource();
        var idx = src.get("v.value");
        console.log('idx : '+idx);
        
        var checkCmp = component.find("checkbox");
        var inventoryCB=checkCmp.get("v.value");
        console.log('inventoryCB : '+inventoryCB);
		
        if(inventoryCB===true){
            console.log('inventoryCB true : '+inventoryCB);
            component.find("radioFlag1").set("v.disabled", false);
        }else{
            console.log('inventoryCB false : '+inventoryCB);
            component.find("radioFlag1").set("v.disabled", true);
            
        }
        
        //component.set('v.SKUListItem.Name','Test data');
        
        //getSkuListItem
        
        var action = component.get("c.getSkuListItem");
        action.setParams({
            sku_id : idx
        });
        action.setCallback(this, function(a) {
            // on call back make it false ,spinner stops after data is retrieved
            //component.set("v.showSpinner", false); 
            
            var state = a.getState();
            // console.log('state: '+JSON.stringify(state));   
            
            if (state == "SUCCESS") {
                var returnValue = a.getReturnValue();
                console.log('returnValue: '+JSON.stringify(returnValue));
                //component.set("v.pagedResult", returnValue);
                console.log('returnValue sd: '+returnValue.results[0].SKU_Description__c);
                
                component.set("v.SKUListItem", returnValue.results[0]);
                var skuCode=returnValue.results[0].SKU_Code__c;
                var code=skuCode.substring(11);
                console.log('code : '+code);
                component.set("v.SKUListItem.SKU_Code__c", code);
                if(returnValue.results[0].Inventory_Dynamic_Check_Italy__c ===true){
                    console.log('inventoryCB true : '+inventoryCB);
                    component.find("radioFlag1").set("v.disabled", false);
                }else{
                    console.log('inventoryCB false : '+inventoryCB);
                    component.find("radioFlag1").set("v.disabled", true);
                    
                }
                //console.log('options : '+component.get('v.options'));//.get('v.value')
                //console.log('returnValue.results[0].Inventory_order_Flag__c : '+returnValue.results[0].Inventory_order_Flag__c);
                component.set("v.value",returnValue.results[0].Inventory_order_Flag__c);
            }
            else{
                //this.showErrorToast(component, 'Some error has occurred. Please contact System Administrator.');
            }
        });
        $A.enqueueAction(action);
                
    },
    
    oninventoryCheck: function(cmp, evt) {
        var checkCmp = cmp.find("checkbox");
        var inventoryCB=checkCmp.get("v.value");
        

        if(inventoryCB===true){
            console.log('inventoryCB true : '+inventoryCB);
            cmp.find("radioFlag1").set("v.disabled", false);
        }else{
            console.log('inventoryCB false : '+inventoryCB);
            //cmp.set("v.radioFlag", false);
            cmp.find("radioFlag1").set("v.disabled", true);
        }
    },
    onInventoryQty : function(cmp,event){
        var inventoryQty = cmp.find('inventoryQty1');
        var inventoryQtyValue = inventoryQty.get("v.value");
        if(inventoryQtyValue < 0){
            console.log('valuer  :- '+inventoryQtyValue);
            inventoryQty.set("v.errors",[{message:"Enter positive number"}]);
        }else {
            inventoryQty.set("v.errors",null);
        }
    },
    
    onSubmitSKUItem : function(cmp,event,helper){
        
        var checkCmp = cmp.find("inventorycheck");
        var inventoryCB=cmp.get("v.value");
        
       
        //var skuListItemCheck=component.get("v.SKUListItem.Inventory_Dynamic_Check_Italy__c");
        console.log('inventoryCB : '+inventoryCB);
        var skuListItem=cmp.get("v.SKUListItem");
        var skuListItemSkuCode=cmp.get("v.SKUListItem.SKU_Code__c");
        console.log('skuListItemSkuCode : '+skuListItemSkuCode);
        console.log('skuListItem : '+JSON.stringify(skuListItem));
        //console.log('Inventory_Description_Italy__c : '+cmp.find("inventoryDiscription").get("v.value"));
        if(skuListItemSkuCode.length===7){
            cmp.set("v.SKUListItem.SKU_Code__c",'00000000000'+skuListItemSkuCode);
        }else if(skuListItemSkuCode.length===6){
            cmp.set("v.SKUListItem.SKU_Code__c",'000000000000'+skuListItemSkuCode);
        }
        if(inventoryCB===true){
            cmp.set("v.radioFlag", true);
            console.log('inside inventoryCB false');
        }else{
            cmp.set("v.radioFlag", false);
            console.log('inside inventoryCB false');
            //cmp.set("v.SKUListItem.Inventory_flag_Italy__c",'');
        }
        
        var inventoryQty = cmp.find('inventoryQty1');
        var inventoryQtyValue = inventoryQty.get("v.value");
        if(inventoryQtyValue < 0){
            console.log('valuer  :- '+inventoryQtyValue);
            inventoryQty.set("v.errors",[{message:"Enter positive number"}]);
        }else {
            inventoryQty.set("v.errors",null);
            //getSkuListItem
            var action = cmp.get("c.updateSKUItem");
            action.setParams({
                "skuListItem": skuListItem 
            });
             cmp.set("v.showSpinner", true); 
            action.setCallback(this, function(response) {
                 cmp.set("v.showSpinner", false); 
                var state = response.getState();
                //console.log('data save : ' + response.getState());
                //console.log('return value : ' + response.getReturnValue());
                console.log('state : ' + state);
                if (state === "SUCCESS") {
                    var message=$A.get("$Label.c.Updated_successfully");
                    helper.showSuccessToast(cmp,event,message);
                    //location.reload();
                    var a = cmp.get('c.doInit');
                    $A.enqueueAction(a);
                }else {
                    
                    //helper.showToast("Error","error","Travel expenses for this is already submitted for approval. Please RECALL approval process to edit the records.");
                }
            });
            $A.enqueueAction(action); 
            cmp.set("v.isSKUOpen", false);
        }
        
        //component.set('v.SKUListItem.Name','Test data');
        
        
        
    },
    uploadCSV : function(component,event,helper){
        var fileBody, fileSize, csvLength, fileName;  
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        //var spinner = component.find("mySpinner");
        //$A.util.toggleClass(spinner, "slds-show");
        if(file === undefined){
            var message=$A.get("$Label.c.Warning");
            helper.showWarningToast(component,event,message);
        }else {
            
            var _validFileExtensions = [".csv"];    
            var reader = new FileReader();
            fileName = fileInput.value.split('\\').pop();
            
            if (fileName.length > 0) {
                var blnValid = false;
                for (var j = 0; j < _validFileExtensions.length; j++) {
                    var sCurExtension = _validFileExtensions[j];
                    if (fileName.substr(fileName.length - sCurExtension.length, sCurExtension.length).toLowerCase() == sCurExtension.toLowerCase()) {
                        blnValid = true;
                        reader.readAsText(file, "UTF-8");
                        reader.onload = function (evt) {
                            var csv = evt.target.result;
                            console.log('csv file contains'+ csv);
                            var result = helper.CSV2JSON(component,csv);
                            console.log('result = ' + result);
                            //console.log('Result = '+JSON.parse(result));
                            //$A.util.toggleClass(spinner, "slds-hide");
                            
                            helper.updateSKU(component,result);
                            var a = component.get('c.doInit');
                            $A.enqueueAction(a);
                            component.set("v.isOpen", false);
                            
                        }
                    }
                    if (!blnValid) {
                        var message=fileName + ' '+ $A.get("$Label.c.Is_invalid_allowed_extensions_only") +' : '  + _validFileExtensions.join(", ");
                        helper.showErrorToast(component,event,message);
                        return false;
                    }
                }
            }
            reader.onerror = function (evt) {
                var message=$A.get("$Label.c.Error_reading_file");
                helper.showErrorToast(component,event,message);
            }
        }
        
    },
    
    
})