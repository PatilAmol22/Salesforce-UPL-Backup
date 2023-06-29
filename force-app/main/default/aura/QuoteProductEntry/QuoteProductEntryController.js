({
    
    doInit: function(component,event,helper){
        var quoteId = component.get("v.recordId");
        component.find("description").set("v.disabled", true);
        helper.fetchAllQuoteLineItem(component,event,helper,quoteId);
        helper.checkSubmitToApproval(component,event,helper,quoteId);
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
    
    checkIfNotNumber : function(component,event,helper){
        var tempQuant = component.get("v.quantity");
        
        if(isNaN(component.get("v.quantity")) || tempQuant<0 ){
            if(tempQuant<0){
                component.set("v.errorMSG","Error :- Quantity should be positive. ");
                setTimeout(function(){ component.set("v.errorMSG",""); }, 4000);
            }
            component.set("v.quantity","");
            
        }else{
            var quty = component.get("v.quantity");
            var pric =  component.get("v.price");
            var amt = quty * pric;
            //alert('amt '+amt );
            component.set("v.amount",amt);  
        }
    },
    checkIfNumberOfPrice : function(component,event,helper){
        var temPrice = component.get("v.price");
        
        
        if(isNaN(component.get("v.price")) || temPrice<0){
            if(temPrice<0){
                component.set("v.errorMSG"," Unit Price should be positive. ");
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
    onChnageSelectedSKU : function(component,event,helper){
        // get the selected Account record from the COMPONETN event 	 
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        console.log('selectedAccountGetFromEvent '+selectedAccountGetFromEvent.Id);
        component.set("v.selectedRecord" , selectedAccountGetFromEvent);
        
        
        var str1 = selectedAccountGetFromEvent.Product2.Pack_Size__c;
        var str2 = selectedAccountGetFromEvent.Product2.UOM1__c;
        
        console.log('@@@ str 1 '+str1);
        console.log('@@@ str 2 '+str2);
        var pckSize ='';
        if(str1!=undefined && str2!=undefined ){
            var res = str1+str2;
            console.log('res Display '+res);
            pckSize = res;   
        }else{
            pckSize = '';   
        }
        
        var productCode = selectedAccountGetFromEvent.Product2.Product_Code__c;
        var productDescription = selectedAccountGetFromEvent.Product2.Description;
       // alert('productDescription '+productDescription);
        if(productDescription!=undefined){
            component.find("description").set("v.value", selectedAccountGetFromEvent.Product2.Description);
            //document.getElementById('description').value = selectedAccountGetFromEvent.Product2.Description; 
        }else{
             component.find("description").set("v.value",'');
        }
        
        
        
        if(productCode =='0000000000'){
            component.set("v.disableFields",false); 
            // document.getElementById('description').disabled = false;  
            component.find("description").set("v.disabled", false);
        }else{
             //document.getElementById('description').disabled = true;  
            component.set("v.disableFields",true);
            component.find("description").set("v.disabled", false);
           
        }
        
        
        component.set("v.packSize" , pckSize); 
        
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
    // function for clear the Record Selection 
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
        component.set("v.quantity", "" ); 
        component.set("v.price", "" ); 
        component.set("v.amount", "" ); 
        //document.getElementById('description').value ='';
        component.find("description").set("v.value", "");
        component.find("description").set("v.disabled", true);
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
            alert('Please Enter SKU.')
           // component.set("v.errorMSGPopup"," Please Select SKU ");
            //setTimeout(function(){ component.set("v.errorMSGPopup",""); }, 3000);
        }else if(selDescription ==''){
            isvalid = false;
            alert('Please Enter Description.');
           // component.set("v.errorMSGPopup"," Please Enter Description ");
            //setTimeout(function(){ component.set("v.errorMSGPopup",""); }, 3000);
        }else if(selPackSize ==''){
            isvalid = false;
            alert('Please Enter Pack Size.');
            //component.set("v.errorMSGPopup"," Please Enter Pack Size ");
            //setTimeout(function(){ component.set("v.errorMSGPopup",""); }, 3000);
        }else if(selQuantity =='0' || selQuantity ==''){
            isvalid = false;
            alert('Please Enter Quantity.');
            //component.set("v.errorMSGPopup"," Please Enter Quantity ");
            //setTimeout(function(){ component.set("v.errorMSGPopup",""); }, 3000);
        }else if(selPrice=='0.00' || selPrice =='' || selPrice=='0'){
            isvalid = false;
            alert('Please Enter Unit Price.');
            //component.set("v.errorMSGPopup"," Please Enter Price ");
            //setTimeout(function(){ component.set("v.errorMSGPopup",""); }, 3000);
        }else if(selAmt=='' || selAmt=='0.00' || selAmt=='0'){
            isvalid = false;
            component.set("v.errorMSGPopup"," Amount not calculated. ");
            setTimeout(function(){ component.set("v.errorMSGPopup",""); }, 3000);
        }else if(component.get("v.isPopup")){
            isvalid = false;
            alert('Please Enter SKU.');
            //component.set("v.errorMSGPopup"," Please Enter Product ");
            //setTimeout(function(){ component.set("v.errorMSGPopup",""); }, 4000);
        }else{
            isvalid = true;
            
        }
        
        //alert('value of Isvalid '+isvalid);
        
        if(isvalid){
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
            helper.fetchAllQuoteLineItem(component,event,helper,quoteId);
        }
        
        
    },
    
    addToQuoteLine : function(component,event,helper){
        console.log('inside addToOppo');
        var selSku = component.get("v.selectedRecord").Id;
        //var selDescription = document.getElementById('description').value;
        var selDescription = component.find("description").get("v.value");
        var selQuantity = component.get("v.quantity");
        var selPrice = component.get("v.price");
        var selPackSize = component.get("v.packSize");
        var selAmt = component.get("v.amount");
        var isvalid = true;
        
        if(selSku == undefined){
            isvalid = false;
           alert('Please Enter SKU.');            
            //component.set("v.errorMSG","Please Select SKU ");
            //setTimeout(function(){ component.set("v.errorMSG",""); }, 3000);
        }else if(selDescription ==''){
            isvalid = false;
            alert('Please Enter Description');
           // component.set("v.errorMSG"," Please Enter Description ");
           // setTimeout(function(){ component.set("v.errorMSG",""); }, 3000);
        }else if(selPackSize ==''){
            isvalid = false;
            alert('Please Enter Pack Size.');
            //component.set("v.errorMSG","Please Enter Pack Size ");
            //setTimeout(function(){ component.set("v.errorMSG",""); }, 3000);
        }else if(selQuantity =='0' || selQuantity ==''){
            isvalid = false;
            alert('Please Enter Quantity.')
           //component.set("v.errorMSG","Please Enter Quantity. ");
            //setTimeout(function(){ component.set("v.errorMSG",""); }, 3000);
        }else if(selPrice=='0.00' || selPrice =='' || selPrice=='0'){
            isvalid = false;
            alert('Please Enter Unit Price');
            //component.set("v.errorMSG","Please Enter Price ");
            //setTimeout(function(){ component.set("v.errorMSG",""); }, 3000);
        }else if(selAmt=='' || selAmt=='0.00' || selAmt=='0'){
            isvalid = false;
            component.set("v.errorMSG","Please Amount not calculate. ");
            setTimeout(function(){ component.set("v.errorMSG",""); }, 3000);
        }else{
            isvalid = true;
        }
        
        //Adding all data to the array
        
        if(isvalid==true){
            var RowItemList =[];
            RowItemList.push({
                'sobjectType': 'QuoteLineItem',
                'QuoteId': component.get("v.recordId"),
                'PricebookEntryId':component.get("v.selectedRecord").Id,
                'Product2Id': component.get("v.selectedRecord").Product2Id,       
                'Description': selDescription,
                'Quantity': selQuantity,
                'Pack_Size__c': selPackSize,
                'UnitPrice': selPrice 
            });
            
            component.set("v.quoteLineItemList", RowItemList);
            helper.insertQuotelineItem(component,event,helper); 
            var quoteId = component.get("v.recordId");
            helper.fetchAllQuoteLineItem(component,event,helper,quoteId);
            helper.clearAll(component,event,helper);
        }
        
    },
    
    checkIfNumberOfQuantityPopup : function(component,event,helper){
        console.log('checkIfNumberOfQuantityPopup ');
        var tempQuntPop =component.get("v.quantityPopup");
        if(isNaN(component.get("v.quantityPopup")) || tempQuntPop<0){
            if(tempQuntPop<0){
                component.set("v.errorMSGPopup"," Quantity should be positive. ");
                setTimeout(function(){ component.set("v.errorMSGPopup",""); }, 5000);
            }
            component.set("v.quantityPopup","");
        }else{
            var quty = component.get("v.quantityPopup");
            var pric =  component.get("v.pricePopup");
            var amt = quty * pric;
            component.set("v.amountPopup",amt); 
        }
    },
    
    
    checkIfNumberOfPricePopup : function(component,event,helper){
        var tempPricePop =component.get("v.pricePopup");
        
        
        if(isNaN(component.get("v.pricePopup")) || tempPricePop<0){
            if(tempPricePop<0){
                component.set("v.errorMSGPopup"," Unit Price should be positive. ");
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
    
    
    onblurPopup:function(component,event,helper){
        console.log('onblurPopup ')    ;
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchResPopup");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    
    //this is function for Lookup for Modal
    
    onfocusPopup : function(component,event,helper){
        $A.util.addClass(component.find("mySpinnerPopup"), "slds-show");
        var forOpen = component.find("searchResPopup");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        var getInputkeyWord = '';
        helper.searchHelper(component,event,getInputkeyWord);    
        
    },
    
    onChnageSelectedSKUPopup : function(component,event,helper){
        
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        var pckSize = selectedAccountGetFromEvent.Product2.Pack_Size_1__c;
        console.log('pckSize '+pckSize);
        var productCode = selectedAccountGetFromEvent.Product2.Product_Code__c;
        console.log('productCode '+productCode);
        component.set("v.selectedRecordPopup" , selectedAccountGetFromEvent);
        if(productCode =='0000000000'){
            component.set("v.disableFieldsPopup",false); 
        }else{
            component.set("v.disableFieldsPopup",true); 
        }
        component.set("v.packSizePopup" , pckSize); 
        var forclose = component.find("lookup-pillPopup");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchResPopup");
        
        
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupFieldPopup");
        
        
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');
        component.set("v.isPopup",false);
        
    },
    
    clearPopup : function(component,event,helper){
        var pillTarget = component.find("lookup-pillPopup");
        var lookUpTarget = component.find("lookupFieldPopup"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.SearchKeyWordPopup",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.selectedRecordPopup", {} );  
        component.set("v.disableFieldsPopup", true ); 
        component.set("v.packSizePopup", "" ); 
        component.set("v.quantityPopup", "" ); 
        component.set("v.pricePopup", "" ); 
        component.set("v.amountPopup", "" ); 
        
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
    
    showLookup : function(component,event,helper){
        component.set("v.isPopup", true ); 
        
        
    },
    
    
    
    keyPressControllerPopup: function(component,event,helper){
        var getInputkeyWord = component.get("v.SearchKeyWordPopup");
        if(getInputkeyWord!=''){
            if( getInputkeyWord.length > 2 ){
                var forOpen = component.find("searchResPopup");
                $A.util.addClass(forOpen, 'slds-is-open');
                $A.util.removeClass(forOpen, 'slds-is-close');
                helper.searchHelperOnKeyPressPopup(component,event,helper,getInputkeyWord);
                
            }
        }
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
    
    closeComponent:function(component,event,helper){
        var rcdId = component.get("v.recordId");
        helper.gotoURL(component,rcdId);
    },
    
})