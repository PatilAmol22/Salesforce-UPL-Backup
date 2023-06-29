({
    doInit : function(component, event, helper) {
        var oppId = component.get("v.recordId");
        helper.fetchAllOpportunityLineItem(component,event,helper,oppId);
        component.find("description").set("v.disabled", true);
        
    },
    
    // this method is execute after selection of SKU from List 
    onChnageSelectedSKU : function(component,event,helper){
        // get the selected Account record from the COMPONETN event 	 
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        console.log('selectedAccountGetFromEvent '+selectedAccountGetFromEvent.Id);
        component.set("v.selectedRecord" , selectedAccountGetFromEvent);
        
        console.log('@@@ pckSize '+selectedAccountGetFromEvent.Product2.Pack_Size__c);
        console.log('@@@ pckSize '+selectedAccountGetFromEvent.Product2.UOM1__c);
        
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
           // document.getElementById('description').value = selectedAccountGetFromEvent.Product2.Description; 
        }else{
            component.find("description").set("v.value", '');
        }
        
        
        
        if(productCode =='0000000000'){
            component.find("description").set("v.disabled", false);
           // document.getElementById("description").disabled = false;
            component.set("v.disableFields",false); 
        }else{
            component.find("description").set("v.disabled", false);
            //document.getElementById("description").disabled = true;
            component.set("v.disableFields",true); 
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
    
    
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
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
    
    // function for clear the Record Selaction 
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
        
        component.find("description").set("v.value", "");
        //document.getElementById('description').value ='';
        component.find("description").set("v.disabled", true);
        //document.getElementById('description').disabled=false;
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
    
    checkIfNotNumber : function(component,event,helper){
        var tempQuant = component.get("v.quantity");
        
        if(isNaN(component.get("v.quantity")) || tempQuant<0){
            if(tempQuant<0){
                component.set("v.errorMSG"," Quantity should be positive number.");
                setTimeout(function(){ component.set("v.errorMSG",""); }, 3000);  
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
    
    onfocusQuantity : function(component,event,helper){
        if(component.get("v.quantity") == '0'){
            component.set("v.quantity","");    
        }
        
    },
    
    checkIfNumberOfPrice : function(component,event,helper){
        var tempPrice = component.get("v.price");
        
        if(isNaN(component.get("v.price")) || tempPrice<0){
            if(tempPrice<0){
                component.set("v.errorMSG","Unit Price should be positive number.");
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
    
    onfocusPrice : function(component,event,helper){
        if(component.get("v.price")== '0.00'){
            component.set("v.price","");    
        }
    },
    
    addToOppLine : function(component,event,helper){
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
            component.set("v.errorMSG","Please Select SKU ");
           // component.find("description").set("v.value", "Find Example");
            setTimeout(function(){ component.set("v.errorMSG",""); }, 3000);
        }else if(selDescription ==''){
            isvalid = false;
            alert('Please Enter Description.');
            //component.set("v.errorMSG","Please Enter Description ");
            //setTimeout(function(){ component.set("v.errorMSG",""); }, 3000);
        }else if(selPackSize ==''){
            isvalid = false;
            alert('Please Enter Pack Size.');
            //component.set("v.errorMSG","Please Enter Pack Size ");
            //setTimeout(function(){ component.set("v.errorMSG",""); }, 3000);
        }else if(selQuantity =='0' || selQuantity ==''){
            isvalid = false;
            alert('Please Enter Quantity.');
            //component.set("v.errorMSG","Please Enter Quantity ");
            //setTimeout(function(){ component.set("v.errorMSG",""); }, 3000);
        }else if(selPrice=='0.00' || selPrice =='' || selPrice=='0'){
            isvalid = false;
            alert('Please Enter Unit Price.');
            //component.set("v.errorMSG","Please Enter Unit Price ");
            //setTimeout(function(){ component.set("v.errorMSG",""); }, 3000);
        }else if(selAmt=='' || selAmt=='0.00' || selAmt=='0'){
            isvalid = false;
            component.set("v.errorMSG","Please Amount not calculate. ");
            setTimeout(function(){ component.set("v.errorMSG",""); }, 3000);
        }else{
            isvalid = true;
        }
        
        
        
        if(isvalid==true){
            //Adding all data to the array
            var RowItemList =[];
            
            RowItemList.push({
                'sobjectType': 'OpportunityLineItem',
                'OpportunityId': component.get("v.recordId"),
                'PricebookEntryId':component.get("v.selectedRecord").Id,
                'Product2Id': component.get("v.selectedRecord").Product2Id,       
                'Description': selDescription,
                //'ProductCode': component.get("v.selectedRecord").Product2.Product_Code__c,
                'Quantity': selQuantity,
                'Pack_Size__c': selPackSize,
                'UnitPrice': selPrice 
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
    
    //This is for Modal Popup action
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
        console.log('id of the opportunity Line Item '+event.getSource().get("v.value"));
        var oppoLitemId = event.getSource().get("v.value");
        component.set("v.rowOppoLineItemId",oppoLitemId);
        helper.gettingSinleOpportunityLineItem(component,event,helper,oppoLitemId);
        
        
        
        
        
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
            alert('Please Select SKU.');
           // component.set("v.errorMSGPopup","please Select Product ");
            //setTimeout(function(){ component.set("v.errorMSGPopup",""); }, 3000);
        }else if(selDescription ==''){
            isvalid = false;
             alert('Please Enter Description.');
            //component.set("v.errorMSGPopup","Please Enter Description ");
            //setTimeout(function(){ component.set("v.errorMSGPopup",""); }, 3000);
        }else if(selPackSize ==''){
            isvalid = false;
            alert('Please Enter Pack Size');
            
           // component.set("v.errorMSGPopup","Please Enter Pack Size ");
            //setTimeout(function(){ component.set("v.errorMSGPopup",""); }, 3000);
        }else if(selQuantity =='0' || selQuantity ==''){
            isvalid = false;
            alert('Please Enter Qunatity.');
            //component.set("v.errorMSGPopup","Please Enter Quantity ");
            //setTimeout(function(){ component.set("v.errorMSGPopup",""); }, 3000);
        }else if(selPrice=='0.00' || selPrice =='' || selPrice=='0'){
            isvalid = false;
            alert('Please Enter Unit Price.');
            //component.set("v.errorMSGPopup","Please Enter Price ");
            //setTimeout(function(){ component.set("v.errorMSGPopup",""); }, 3000);
        }else if(selAmt=='' || selAmt=='0.00' || selAmt=='0'){
            isvalid = false;
            component.set("v.errorMSGPopup","Please Amount not calculate. ");
            setTimeout(function(){ component.set("v.errorMSGPopup",""); }, 3000);
        }else if(component.get("v.isPopup")==true){
            isvalid = false;
            alert('Please Enter SKU.');
            
            //component.set("v.errorMSGPopup"," ");
            //setTimeout(function(){ component.set("v.errorMSGPopup",""); }, 3000);
        }else{
            isvalid = true;
        }
        
        
        if(isvalid){
            //Adding all data to the array
            
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
            component.set("v.isPopup", false ); 
        }
        
        
    },
    
    checkIfNumberOfQuantityPopup : function(component,event,helper){
        console.log('checkIfNumberOfQuantityPopup ');
        var tempQuant = component.get("v.quantityPopup");
        if(isNaN(component.get("v.quantityPopup"))  || tempQuant<0){
             if(tempQuant<0){
                component.set("v.errorMSGPopup"," Quantity should be positive number.");
                setTimeout(function(){ component.set("v.errorMSGPopup",""); }, 3000);  
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
         var tempPrice = component.get("v.pricePopup");
        
        if(isNaN(component.get("v.pricePopup")) || tempPrice<0){
             if(tempPrice<0){
                component.set("v.errorMSGPopup"," Price should be positive number.");
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
    
    
    
    //this is function for Lookup for Modal
    
    onfocusPopup : function(component,event,helper){
        $A.util.addClass(component.find("mySpinnerPopup"), "slds-show");
        var forOpen = component.find("searchResPopup");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        var getInputkeyWord = '';
        helper.searchHelper(component,event,getInputkeyWord);    
    },
    
    
    
    onblurPopup:function(component,event,helper){
        console.log('onblurPopup ')    ;
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchResPopup");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        
    },
    clearPopup : function(component,event,helper){
        console.log('clearPopup');
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
         component.set("v.pricePopup", "" ); 
         component.set("v.quantityPopup", "" ); 
         component.set("v.amountPopup", "" ); 
        document.getElementById('descriptionPopup').value ='';
        
        
        
        
        
        
        
    },
    
    
    
    
    
    keyPressControllerPopup:function(component,event,helper){
        var getInputkeyWord = component.get("v.SearchKeyWordPopup");
        console.log( 'getInputkeyWord '+getInputkeyWord);
        if( getInputkeyWord.length > 2 ){
            var forOpen = component.find("searchResPopup");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelperOnKeyPressPopup(component,event,helper,getInputkeyWord);
        }  
    },
    
    
    onChnageSelectedSKUPopup : function(component,event,helper){
        
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        var pckSize = selectedAccountGetFromEvent.Product2.Pack_Size_1__c;
        console.log(' @@@ pckSize '+pckSize);
        var productCode = selectedAccountGetFromEvent.Product2.Product_Code__c;
        var prodDescription = selectedAccountGetFromEvent.Product2.Description;
        
        if(prodDescription!=undefined){
            document.getElementById('descriptionPopup').value = prodDescription;
        }else{
            document.getElementById('descriptionPopup').value = '';
        }
        
        component.set("v.selectedRecordPopup" , selectedAccountGetFromEvent);
        component.set("v.ProductNamePop",selectedAccountGetFromEvent.Product2.Description);
        //alert(selectedAccountGetFromEvent.Product2Id);
        //alert(selectedAccountGetFromEvent.Product2.Name);
        alert('productCode '+productCode);
        
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
    showLookup : function(component,event,helper){
        component.set("v.isPopup", true );
        document.getElementById('descriptionPopup').value ='';
        component.set("v.packSizePopup",'');
        component.set("v.quantityPopup",'');
        component.set("v.pricePopup",'');
        component.set("v.amountPopup",'');
        component.set("v.disableFieldsPopup",false);
    },
    
    closeComponent:function(component,event,helper){
        var rcdId = component.get("v.recordId");
        helper.gotoURL(component,rcdId);
    },
    
    
        
})