({
    doInit: function(component,event,helper){
        var quoteId = component.get("v.recordId");
        
        helper.fetchAllQuoteLineItem(component,event,helper,quoteId);
        helper.showHideInventory(component,event,helper);
        helper.checkSubmitToApproval(component,event,helper,quoteId);
    },
    
    
    //This all method for Custom Lookup
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    onfocus:function(component,event,helper){
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
        
        if(getInputkeyWord!=''){
            if( getInputkeyWord.length > 2 ){
                var forOpen = component.find("searchRes");
                $A.util.addClass(forOpen, 'slds-is-open');
                $A.util.removeClass(forOpen, 'slds-is-close');
                helper.searchHelperOnKeyPress(component,event,helper,getInputkeyWord);
            } 
        }
        
    },
    
    
    onChnageSelectedSKU : function(component,event,helper){
        // get the selected Account record from the COMPONETN event 	 
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        console.log('selectedAccountGetFromEvent '+selectedAccountGetFromEvent.Product2Id);
        component.set("v.selectedRecord" , selectedAccountGetFromEvent);
        var selectProduct = selectedAccountGetFromEvent.Product2Id;
        //using product we have create Query on 
        
        console.log('selectProduct '+selectProduct);
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
        
        component.set("v.SKUId", "" );
        component.set("v.itemNumber", "" );
        component.set("v.depotId", "" );
        component.set("v.storageLocation", "" );
        
    },
    
    checkIfNotNumber : function(component,event,helper){
        var tempQuant = component.get("v.quantity");
        var flg= true;
        
        if(isNaN(component.get("v.quantity")) || tempQuant<0 ){
            if(tempQuant<0){
                component.set("v.errorMSG",$A.get("$Label.c.Quantity_should_be_positive"));
                setTimeout(function(){ component.set("v.errorMSG",""); }, 4000);
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
                setTimeout(function(){ component.set("v.errorMSG",""); }, 4000);
                component.set("v.quantity","");
            }
            
        }
    },
    checkIfNumberOfPrice : function(component,event,helper){
        var temPrice = component.get("v.price");
        
        
        if(isNaN(component.get("v.price")) || temPrice<0){
            if(temPrice<0){
                component.set("v.errorMSG",$A.get("$Label.c.Final_Price_should_be_positive"));
                setTimeout(function(){ component.set("v.errorMSG",""); }, 4000);
            }
            component.set("v.price","");
        }else{
            var quty = component.get("v.quantity");
            var pric =  component.get("v.price");
            var amt = quty * pric;
            component.set("v.amount",amt); 
        }
    },
    
    
    
    onfocusQuantity : function(component,event,helper){
        if(component.get("v.quantity")== '0'){
            component.set("v.quantity","");    
        }
        
    },
    onfocusPrice:function(component,event,helper){
        if(component.get("v.price")== '0.00'){
            component.set("v.price","");    
        }
    },
    
    
    addToQuoteLine : function(component,event,helper){
        console.log('inside addToOppo');
        var selSku = component.get("v.selectedRecord").Id;
        var selUOM = component.get("v.UOM");
        var selMinPrice = component.get("v.minPrice");
        var selMaxPrice = component.get("v.maxPrice");
        var selQuantity = component.get("v.quantity");
        var selPrice = component.get("v.price");
        var selPackSize = component.get("v.packSize");
        var selAmt = component.get("v.amount");
        var isvalid = true;
        
        if(selSku == undefined){
            isvalid = false;
            alert($A.get("$Label.c.Please_Enter_SKU"));            
            
        }else if(selUOM==''){
            isValid = false;
            alert($A.get("$Label.c.Please_Enter_UOM"));
            
        }else if(selPackSize ==''){
            isvalid = false;
            alert($A.get("$Label.c.Please_Enter_Pack_Size"));
        }else if(selMinPrice==''){
            isValid = false;
            alert($A.get("$Label.c.Please_Enter_Min_Price"));
        }else if(selMaxPrice==''){
            isValid =false;
            alert($A.get("$Label.c.Please_Enter_Max_Price"));
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
        
        //Adding all data to the array
        
        console.log('@@ selMinPrice '+selMinPrice);
        
        var twoPer=0.0;
        var sevenPer=0.0;
        var tenPer=0.0;
        var moreTenPer=0.0;
         twoPer = selMinPrice - ((selMinPrice * 2) /100) ;
        sevenPer = selMinPrice - ((selMinPrice * 7) /100) ;
        tenPer = selMinPrice - ((selMinPrice * 10) /100) ;
        moreTenPer = selMinPrice - ((selMinPrice * 10.1) /100) ;
        
        var colflag =false;
        var setQuoteLineItem = false;
        if(selPrice <= sevenPer){
            console.log('@@@in 7');
            colflag =true;
            
        }else if(selPrice <= tenPer){
            console.log('@@@in 10');
            colflag =true;
            
        }else if(selPrice < moreTenPer){
            console.log('@@@in more than 10');
            colflag =true;
        }
        
        if(colflag){
            setQuoteLineItem = true;
        }
        
        
        
        
        
        
        
        if(isvalid==true){
            selPrice = selPrice.replace('.',',');
            var RowItemList =[];
            RowItemList.push({
                'sobjectType': 'QuoteLineItem',
                'QuoteId': component.get("v.recordId"),
                'PricebookEntryId':component.get("v.selectedRecord").Id,
                'Product2Id': component.get("v.selectedRecord").Product2Id,       
                'Quantity': selQuantity,
                'Pack_Size__c': selPackSize,
                'UnitPrice': selPrice,
                'UOM__c': selUOM,
                'Min_Price__c': selMinPrice,
                'Max_Price__c': selMaxPrice,
                'Quote_Highlight__c':setQuoteLineItem,
                'Description': component.get("v.selectedRecord").Product2.Name,
                'Depot__c': component.get("v.depotId"),
                'SKU__c': component.get("v.SKUId"),
                'Storage_Location__c': component.get("v.depotId"),
                'Sales_Org__c': component.get("v.SalesOrg"),
                'Distribution_Channel__c': component.get("v.distributionChannel"),
                'Division__c': component.get("v.division"),
                
            });
            
            component.set("v.quoteLineItemList", RowItemList);
            helper.insertQuotelineItem(component,event,helper); 
            var quoteId = component.get("v.recordId");
            helper.fetchAllQuoteLineItem(component,event,helper,quoteId);
            helper.clearAll(component,event,helper);
            helper.showSpinner(component,event,helper);
            setTimeout(function(){ helper.hideSpinner(component,event,helper); }, 2000);
        }
        
    },
    
    
    
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
        var quoteLitemId = event.getSource().get("v.value");
        component.set("v.rowQuoteLineItemId",quoteLitemId);
        helper.gettingSinleQuoteLineItem(component,event,helper,quoteLitemId);
    },
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
        component.set("v.isPopup", false);
        
    },
    
    deleteQuoteLineItem :  function(component,event,helper){
        var isDelete = true;
        if (confirm("Are you sure ?")) {
            isDelete = true;
        } else {
            isDelete = false;
        }
        if(isDelete){
            var quoteLineId = event.getSource().get("v.value");
            helper.deleteQuoteLineItems(component,event,helper,quoteLineId);
            var quoteId = component.get("v.recordId");
            helper.fetchAllQuoteLineItem(component,event,helper,quoteId);     
        }
    },
    
    
    likenClose: function(component, event, helper) {
        
        
        //getting all data 
        
        
        var selSku = component.get("v.selectedRecordPopup").Id;
        
        var selDescription = document.getElementById('descriptionPopup').value;
        
        var selQuantity = component.get("v.quantityPopup");
        
        var selPrice = component.get("v.pricePopup"); //component.find('Unit_Price').get('v.value');
        
        var selPackSize = component.get("v.packSizePopup");
        
        var selAmt = component.get("v.amountPopup");
        
        
        var isvalid = true;
         var selMin = component.get("v.minPricePopup"); 
        //alert('selMin '+selMin);
        var twoPer=0.0;
        var sevenPer=0.0;
        var tenPer=0.0;
        var moreTenPer=0.0;
         twoPer = selMin - ((selMin * 2) /100) ;
        sevenPer = selMin - ((selMin * 7) /100) ;
        tenPer = selMin - ((selMin * 10) /100) ;
        moreTenPer = selMin - ((selMin * 10.1) /100) ;
        
        var colflag =false;
        var setQuoteLineItem = false;
        if(selPrice <= sevenPer){
            console.log('@@@in 7');
            colflag =true;
            
        }else if(selPrice <= tenPer){
            console.log('@@@in 10');
            colflag =true;
            
        }else if(selPrice < moreTenPer){
            console.log('@@@in more than 10');
            colflag =true;
        }
        
        if(colflag){
            setQuoteLineItem = true;
        }
        
        
        
        
        
        
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
        }else if(component.get("v.isPopup")){
            isvalid = false;
            alert('Please Enter SKU.');
            
            
        }else{
            isvalid = true;
            
        }
        
        
        
        if(isvalid){
            selPrice = selPrice.toString().replace('.',',');
            //Adding all data to the array
            var RowItemList = [];
            RowItemList.push({
                'sobjectType': 'QuoteLineItem',
                'QuoteId': component.get("v.recordId"),
                'PricebookEntryId':component.get("v.selectedRecord").Id,
                'Product2Id': component.get("v.selectedRecord").Product2Id,       
                'Description': selDescription,
                'Quantity': selQuantity,
                'Pack_Size__c': selPackSize,
                'UnitPrice': selPrice,
                'Quote_Highlight__c':setQuoteLineItem,
                'Id':component.get("v.rowQuoteLineItemId") 
            });
            
            component.set("v.quoteLineItemListPopup", RowItemList);
            var tempJson = component.get("v.quoteLineItemListPopup")
            helper.updateQuoteLineItem(component,event,helper);
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
            
            var quoteId = component.get("v.recordId");
            helper.showSpinner(component,event,helper);
            setTimeout(function(){ helper.hideSpinner(component,event,helper); }, 2000);
            helper.fetchAllQuoteLineItem(component,event,helper,quoteId);
        }
        
    },
    
    
    checkIfNumberOfQuantityPopup : function(component,event,helper){
        console.log('checkIfNumberOfQuantityPopup ');
        var tempQuntPop =component.get("v.quantityPopup");
        var flg =true;
        if(isNaN(component.get("v.quantityPopup")) || tempQuntPop<0){
            if(tempQuntPop<0){
                component.set("v.errorMSGPopup"," Quantity should be positive. ");
                setTimeout(function(){ component.set("v.errorMSGPopup",""); }, 5000);
            }
            component.set("v.quantityPopup","");
        }else{
            
            var result = (tempQuntPop - Math.floor(tempQuntPop)) !== 0; 
            
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
                component.set("v.errorMSGPopup"," Quantity should be Integer Number. ");
                setTimeout(function(){ component.set("v.errorMSGPopup",""); }, 5000);
                component.set("v.quantityPopup","");
            }
            
        }
    },
    
    
    checkIfNumberOfPricePopup : function(component,event,helper){
        var tempPricePop =component.get("v.pricePopup");
        
        
        if(isNaN(component.get("v.pricePopup")) || tempPricePop<0){
            if(tempPricePop<0){
                component.set("v.errorMSGPopup"," final Price should be positive. ");
                setTimeout(function(){ component.set("v.errorMSGPopup",""); }, 5000); 
            }
            component.set("v.pricePopup","");
        }else{
            var quty = component.get("v.quantityPopup");
            var pric =  component.get("v.pricePopup");
            var amt = quty * pric;
            component.set("v.amountPopup",amt); 
        }
    },
    
    closeComponent:function(component,event,helper){
        var rcdId = component.get("v.recordId");
        helper.gotoURL(component,rcdId);
    },
    
    sendToApproval :function(component,event,helper){
        //var isDelete = true;
        //if (confirm("Are you sure?")) {
        //  isDelete = true;
        //} else {
        //  isDelete = false;
        //}
        //if(isDelete){
        helper.sendApproval(component,event,helper);
        //}
        
        
    },
    
    
})