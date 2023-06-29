({
    doInit : function(component, event, helper) {
        var oppId = component.get("v.recordId");
        helper.fetchAllOpportunityLineItem(component,event,helper,oppId);
        helper.showHideInventory(component,event,helper);
        
        
    },
    
    onfocusQuantity : function(component, event, helper) {
        if(component.get("v.quantity") == '0'){
            component.set("v.quantity","");    
        }
    },
    
    
    checkIfNotNumber : function(component, event, helper){
        var tempQuant = component.get("v.quantity");
        var flg = true;
        
        if(isNaN(component.get("v.quantity")) || tempQuant<0){
            if(tempQuant<0){
                component.set("v.errorMSG",$A.get("$Label.c.Quantity_should_be_positive"));
                setTimeout(function(){ component.set("v.errorMSG",""); }, 3000);  
            }
            component.set("v.quantity","");
        }else{
            
            
            var result = (tempQuant - Math.floor(tempQuant)) !== 0; 
            
            if (result){
                flg = false;
            }else{
                flg = true;    
            }
            if(flg){
                var quty = component.get("v.quantity");
                var pric =  component.get("v.price");
                var amt = quty * pric;
                component.set("v.amount",amt);  
            }else{
                component.set("v.errorMSG",$A.get("$Label.c.Quantity_should_be_Integer_Number"));
                setTimeout(function(){ component.set("v.errorMSG",""); }, 3000);
                component.set("v.quantity","");
            }
            
            
        }
        
    },
    
    checkIfNumberOfPrice : function(component, event, helper){
        var tempPrice = component.get("v.price");
        
        if(isNaN(component.get("v.price")) || tempPrice<0){
            if(tempPrice<0){
                component.set("v.errorMSG",$A.get("$Label.c.Final_Price_should_be_positive"));
                setTimeout(function(){ component.set("v.errorMSG",""); }, 3000);  
            }
            component.set("v.price","");
        }else{
            var quty = component.get("v.quantity");
            var pric =  component.get("v.price");
            var amt = quty * pric;
            component.set("v.amount",amt); 
        }
        
    },
    
    onfocusPrice: function(component,event,helper){
        if(component.get("v.price")== '0.00'){
            component.set("v.price","");    
        }
    },
    
    
    
    
    
    addToOppLine : function(component,event,helper){
        var selSku = component.get("v.selectedRecord").Id;
        var selUOM = component.get("v.UOM");
        var selMinPrice = component.get("v.minPrice");
        var selMaxPrice = component.get("v.maxPrice");
        var selQuantity = component.get("v.quantity");
        var selPrice = component.get("v.price");
        var selPackSize = component.get("v.packSize");
        var selAmt = component.get("v.amount");
        
        var isvalid = true;
        //alert('selUOM '+selUOM);
        
        if(selSku == undefined){
            isvalid = false;
            component.set("v.errorMSG",$A.get("$Label.c.Please_Enter_SKU"));
            setTimeout(function(){ component.set("v.errorMSG",""); }, 3000);
        }else if(selUOM==''){
            isvalid= false;
            alert($A.get("$Label.c.Please_Enter_UOM"));
        }else if(selMinPrice==''){
            isvalid = false;
            alert($A.get("$Label.c.Please_Enter_Min_Price"));
        }else if(selMaxPrice ==''){
            isvalid = false;
            alert($A.get("$Label.c.Please_Enter_Max_Price"));
        } else if(selPackSize ==''){
            isvalid = false;
            alert($A.get("$Label.c.Please_Enter_Pack_Size"));
            
        }else if(selQuantity =='0' || selQuantity ==''){
            isvalid = false;
            alert($A.get("$Label.c.Please_enter_Quantity"));
            
        }else if(selPrice=='0.00' || selPrice =='' || selPrice=='0'){
            isvalid = false;
            alert($A.get("$Label.c.Please_enter_Final_Price"));
            
        }else if(selAmt=='' || selAmt=='0.00' || selAmt=='0'){
            isvalid = false;
            component.set("v.errorMSG",$A.get("$Label.c.Amount_not_calculated"));
            setTimeout(function(){ component.set("v.errorMSG",""); }, 3000);
        }else{
            isvalid = true;
        }
        
        
        
       // console.log('Description '+component.get("v.selectedRecord").Product2.Name);
        if(isvalid==true){
            selPrice = selPrice.replace('.',',');
            var RowItemList =[];
            
            RowItemList.push({
                'sobjectType': 'OpportunityLineItem',
                'OpportunityId': component.get("v.recordId"),
                'PricebookEntryId':component.get("v.selectedRecord").Id,
                'Product2Id': component.get("v.selectedRecord").Product2Id,       
                'Quantity': selQuantity,
                'Pack_Size__c': selPackSize,
                'UnitPrice': selPrice,
                'UOM__c': selUOM,
                'Min_Price__c': selMinPrice,
                'Max_Price__c': selMaxPrice,
                'Depot__c': component.get("v.depotId"),
                'SKU__c': component.get("v.SKUId"),
                'Storage_Location__c': component.get("v.depotId"),
                'Sales_Org__c': component.get("v.SalesOrg"),
                'Distribution_Channel__c': component.get("v.distributionChannel"),
                'Division__c': component.get("v.division"),
                'Description':component.get("v.selectedRecord").Product2.Name,
            });
            
            
            component.set("v.opportunityLineItemList", RowItemList);
            helper.insertOppotunitylibeItem(component,event,helper);
            var oppId = component.get("v.recordId");
            helper.fetchAllOpportunityLineItem(component,event,helper,oppId);
            helper.clearAll(component,event,helper);
            helper.showSpinner(component,event,helper);
            setTimeout(function(){ helper.hideSpinner(component,event,helper); }, 2000);
            
            
        }        
    },
    
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
        var oppoLitemId = event.getSource().get("v.value");
        component.set("v.rowOppoLineItemId",oppoLitemId);
        helper.gettingSinleOpportunityLineItem(component,event,helper,oppoLitemId);
        
    },
    
    
    
    closeComponent : function(component,event,helper){
        var rcdId = component.get("v.recordId");
        helper.gotoURL(component,rcdId);
    },
    
    //This is for SKU lookup
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    clear :function(component,event,heplper){
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.selectedRecord", {} );  
        component.set("v.disableFields", true ); 
        component.set("v.packSize", "" );
        component.set("v.quantity", "0" );
        component.set("v.price", "0.00" );
        component.set("v.amount", "" );
        component.set("v.UOM", "" );
        component.set("v.maxPrice", "" );
        component.set("v.minPrice", "" );
        component.set("v.Inventory", "" );
        
        component.set("v.SKUId", "" );
        
        component.set("v.depotId", "" );
        component.set("v.storageLocation", "" );
        
        
        
        
    },
    
    onfocus : function(component,event,helper){
        
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
        var getInputkeyWord = '';
        
        helper.searchHelper(component,event,getInputkeyWord);
    },
    
    keyPressController : function(component, event, helper) {
        var getInputkeyWord = component.get("v.SearchKeyWord");
        console.log('getInputkeyWord ' +getInputkeyWord);
        if( getInputkeyWord.length > 2 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelperOnKeyPress(component,event,helper,getInputkeyWord);
        }
    },
    
    
    onChnageSelectedSKU : function(component,event,helper){
        // get the selected Account record from the COMPONETN event 	 
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        console.log('selectedAccountGetFromEvent '+selectedAccountGetFromEvent.Product2Id);
        component.set("v.selectedRecord" , selectedAccountGetFromEvent);
        var selectProduct = selectedAccountGetFromEvent.Product2Id;
        
        //using product we have create Query on 
        helper.fetchPriceBook(component,event,selectProduct);
        
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show'); 
        
    },
    
    deleteOppoLineItem: function(component,event,helper){
        
        var isDelete = true;
        if (confirm("Are you sure ?")) {
            isDelete = true;
        } else {
            isDelete = false;
        }
        
        
        if(isDelete){
            
            var oppoLitemId = event.getSource().get("v.value");
            helper.deleteoppotunityLineItem(component,event,helper,oppoLitemId);
            var oppId = component.get("v.recordId");
            helper.fetchAllOpportunityLineItem(component,event,helper,oppId);     
        }
    },
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
        component.set("v.isPopup", false);
        
        
    },
    
    
    checkIfNumberOfQuantityPopup : function(component,event,helper){
        console.log('checkIfNumberOfQuantityPopup ');
        var tempQuant = component.get("v.quantityPopup");
        var flg= true;
        
        if(isNaN(component.get("v.quantityPopup"))  || tempQuant<0){
            if(tempQuant<0){
                component.set("v.errorMSGPopup",$A.get("$Label.c.Quantity_should_be_positive"));
                setTimeout(function(){ component.set("v.errorMSGPopup",""); }, 3000);  
            }
            component.set("v.quantityPopup","");
        }else{
            var result = (tempQuant - Math.floor(tempQuant)) !== 0; 
            
            if (result){
                flg = false;
            }else{
                flg = true;    
            }
            if(flg){
                
                var quty = component.get("v.quantityPopup");
                var pric =  component.get("v.pricePopup");
                var amt = quty * pric;
                component.set("v.amountPopup",amt);  
            }else{
                component.set("v.errorMSGPopup",$A.get("$Label.c.Quantity_should_be_Integer_Number"));
                setTimeout(function(){ component.set("v.errorMSGPopup",""); }, 3000);  
                component.set("v.quantityPopup","");
            }
        }
    },
    
    
    checkIfNumberOfPricePopup : function(component,event,helper){
        var tempPrice = component.get("v.pricePopup");
        
        if(isNaN(component.get("v.pricePopup")) || tempPrice<0){
            if(tempPrice<0){
                component.set("v.errorMSGPopup",$A.get("$Label.c.Final_Price_should_be_positive"));
                setTimeout(function(){ component.set("v.errorMSGPopup",""); }, 3000);  
            }
            
            component.set("v.pricePopup","");
        }else{
            var quty = component.get("v.quantityPopup");
            var pric =  component.get("v.pricePopup");
            var amt = quty * pric;
            component.set("v.amountPopup",amt); 
        }
    },
    
    likenClose: function(component, event, helper) {
        
        
        //getting all data 
        var selSku = component.get("v.selectedRecordPopup").Id;
        
        var selDescription = document.getElementById('descriptionPopup').value;
        
        var selQuantity = component.get("v.quantityPopup");
        
        var selPrice = component.get("v.pricePopup");
        
        var selPackSize = component.get("v.packSizePopup");
        
        var selAmt = component.get("v.amountPopup");
        
        
        var isvalid = true;
        
        if(selSku == undefined){
            isvalid = false;
            alert($A.get("$Label.c.Please_Enter_SKU"));      
            
        }else if(selDescription ==''){
            isvalid = false;
            alert('Please Enter Description.');
            
        }else if(selPackSize ==''){
            isvalid = false;
            alert($A.get("$Label.c.Please_Enter_Pack_Size"));
            
        }else if(selQuantity =='0' || selQuantity ==''){
            isvalid = false;
            alert($A.get("$Label.c.Please_enter_Quantity"));
            
        }else if(selPrice=='0.00' || selPrice =='' || selPrice=='0'){
            isvalid = false;
            alert($A.get("$Label.c.Please_enter_Final_Price"));
            
        }else if(selAmt=='' || selAmt=='0.00' || selAmt=='0'){
            isvalid = false;
            component.set("v.errorMSGPopup",$A.get("$Label.c.Amount_not_calculated"));
            setTimeout(function(){ component.set("v.errorMSGPopup",""); }, 3000);
        }else if(component.get("v.isPopup")==true){
            isvalid = false;
            alert('Please Enter SKU.');
        }else{
            isvalid = true;
        }
        
        
        
        if(isvalid){
            //Adding all data to the array
            selPrice = selPrice.toString().replace('.',',');
            var RowItemList =[];
            RowItemList.push({
                'sobjectType': 'OpportunityLineItem',
                'OpportunityId': component.get("v.recordId"),
                'PricebookEntryId':component.get("v.selectedRecordPopup").Id,
                'Product2Id': component.get("v.selectedRecordPopup").Product2Id,       
                'Description': selDescription,
                //'ProductCode': component.get("v.selectedRecordPopup").Product2.Product_Code__c,
                'Quantity': selQuantity,
                'Pack_Size__c': selPackSize,
                'UnitPrice': selPrice,
                'Id':component.get("v.rowOppoLineItemId")
            });
            
            component.set("v.opportunityLineItemListPopup", RowItemList);
            var tempJson = component.get("v.opportunityLineItemListPopup")
            console.log(JSON.stringify(tempJson));
            helper.updateOppotunitylibeItem(component,event,helper);
            var pillTarget = component.find("lookup-pillPopup");
            var lookUpTarget = component.find("lookupFieldPopup"); 
            
            $A.util.addClass(pillTarget, 'slds-hide');
            $A.util.removeClass(pillTarget, 'slds-show');
            
            $A.util.addClass(lookUpTarget, 'slds-show');
            $A.util.removeClass(lookUpTarget, 'slds-hide');
            document.getElementById('descriptionPopup').value ='';
            component.set("v.quantityPopup","") ;
            component.set("v.pricePopup","") ;
            component.set("v.amountPopup","") ;
            component.set("v.SearchKeyWordPopup",null);
            component.set("v.listOfSearchRecords", null );
            component.set("v.selectedRecordPopup", {} );  
            component.set("v.disableFieldsPopup", true ); 
            component.set("v.packSizePopup", "" );
            component.set("v.isOpen", false);
            
            var oppId = component.get("v.recordId");
            helper.fetchAllOpportunityLineItem(component,event,helper,oppId);
            helper.showSpinner(component,event,helper);
            setTimeout(function(){ helper.hideSpinner(component,event,helper); }, 2000);
            component.set("v.isPopup", false ); 
        }
        
        
    },
    
    
    
    
})