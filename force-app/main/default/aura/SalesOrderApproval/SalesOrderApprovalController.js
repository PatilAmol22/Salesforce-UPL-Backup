({
    doInit : function(component, event, helper) {
        helper.loginAdmin(component, event); 
        //helper.fetchSalesOrderData1(component, event, null,null,'Pending',null,null); 
    },
    
    
    onblurAccount : function(component,event,helper){ 
        var forclose = component.find("searchResAccount");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    
    onblurOwnerName : function(component,event,helper){ 
        var forclose = component.find("searchResOwnerName");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEventAccount : function(component, event, helper) {
        // get the selected Account record from the COMPONETN event 
        
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        component.set("v.selectedRecordAccount" , selectedAccountGetFromEvent); 
        
        // var brdID = selectedAccountGetFromEvent.Brand__c;
        // var cmpID = selectedAccountGetFromEvent.Company__c;
        
        var forclose = component.find("lookup-pill-Account");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchResAccount");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupFieldAccount");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show'); 
        
        //helper.getCompanyOnBrand(component,event,brdID);
        // helper.getFormulationOnBrand(component,event,brdID,cmpID); // this function is getting formulation by sending Brand id and Company id
        
    },
    
    // this is Handler for Owner Id
    // This function call when the end User Select any record from the result list.   
    handleComponentEventOwnerName : function(component, event, helper) {
        // get the selected Owner Name record from the COMPONETN event 
        
        var selectedOwnerNameGetFromEvent = event.getParam("recordByEvent");
        component.set("v.selectedRecordOwnerName" , selectedOwnerNameGetFromEvent); 
        
        var forclose = component.find("lookup-pill-OwnerName");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchResOwnerName");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupFieldOwnerName");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show'); 
        
    },
    
    
    
    clearAccount :function(component,event,helper){ 
        var pillTarget = component.find("lookup-pill-Account");
        var lookUpTarget = component.find("lookupFieldAccount"); 
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        component.find("vAccount").set("v.value", '');
        component.set('v.selectedRecordAccount',null);
        
    },//end of clearAccount
    
    clearOwnerName :function(component,event,helper){ 
        var pillTarget = component.find("lookup-pill-OwnerName");
        var lookUpTarget = component.find("lookupFieldOwnerName"); 
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        component.find("vOwnerName").set("v.value", '');
        component.set('v.selectedRecordOwnerName',null);
        
    },//end of clearOwner Name
    
    
    onfocusAccount : function(component,event,helper){
        //  $A.util.addClass(component.find("mySpinnerAccount"), "slds-show");
        var forOpen = component.find("searchResAccount");
        
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
        var getInputkeyWordAccount = '';
        helper.searchHelperAccount(component,event,getInputkeyWordAccount);
    },
    
    
    
    onfocusOwnerName : function(component,event,helper){
        
        var forOpen = component.find("searchResOwnerName");
        
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
        var getInputkeyWordOwnerName = '';
        helper.searchHelperOwnerName(component,event,getInputkeyWordOwnerName);
    },
    
    
    keyPressControllerAccount : function(component, event, helper) {
        var getInputkeyWordAccount = component.get("v.SearchKeyWordAccount");
        if( getInputkeyWordAccount.length > 2 ){
            var forOpen = component.find("searchResAccount");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelperOnAccountKeyPress(component,event,getInputkeyWordAccount);
            
        }
        
    },
    
    
    keyPressControllerOwnerName : function(component, event, helper) {
        
        var getInputkeyWordOwnerName = component.get("v.SearchKeyWordOwnerName");
        
        if( getInputkeyWordOwnerName.length > 2 ){
            var forOpen = component.find("searchResOwnerName");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelperOnOwnerNameKeyPress(component,event,getInputkeyWordOwnerName);
            
        }
        
    },
    
    
    
    toggleStatus : function(component, event, helper) {
        
    },
    
    
    toggleSubOrderStatus : function(component, event, helper) {
        
    }, 
    
    dateUpdate : function(component, event, helper) {
        
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
        if(component.get("v.eddDate") != '' && component.get("v.eddDate") > todayFormattedDate){
            component.set("v.dateValidationError" , true);
        }else{
            component.set("v.dateValidationError" , false);
        }
    },
    
    dateUpdate1 : function(component, event, helper) {
        
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
        if(component.get("v.stdDate") != '' && component.get("v.stdDate") > todayFormattedDate){
            component.set("v.dateValidationError1" , true);
        }else{
            component.set("v.dateValidationError1" , false);
        }
    },
    
    
    
    
    searchDetailsSalesOrder : function(component, event, helper) {
        var flagSet = true;
        var strAccount = component.get('v.selectedRecordAccount');
        var strOwner = component.get('v.selectedRecordOwnerName');
        var strtDate = component.find("startDate").get("v.value");
        var statusOrder = component.find("Status_Type").get("v.value");
        //var subOrderStatus = component.find("Sub_Order_Type").get("v.value"); 
        var edDate = component.find("endDate").get("v.value") ;
        var isDateError = component.get("v.dateValidationError");
        var isDateError1 = component.get("v.dateValidationError1");
        //alert('subOrderStatus '+subOrderStatus);
        var accId='';
        var ownerId ='';
        var isSameDate = false;
        
        if(strtDate!=null && edDate == null){
           var msg = $A.get("$Label.c.Select_End_Date");
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error Message',
                message:msg,
                messageTemplate: 'Mode is pester ,duration is 1 sec and Message is overrriden',
                duration:' 1000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
            flagSet = false; 
        }else if(strtDate ==null && edDate != null){
            
            
            var toastEvent = $A.get("e.force:showToast");
            var msg = $A.get("$Label.c.Select_Start_Date");
            //alert('msg is '+msg);
            toastEvent.setParams({
                title : 'Error Message',
                message:msg,
                messageTemplate: 'Mode is pester ,duration is 1 sec and Message is overrriden',
                duration:' 1000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
            flagSet = false; 
        }else if(strtDate!= null && edDate!=null){
            
            if(strtDate == edDate){
                isSameDate = true;
                
                /*
                var msg = $A.get("$Label.c.Start_Date_and_End_Date_must_different");
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error Message',
                    message:msg,
                    messageTemplate: 'Mode is pester ,duration is 1 sec and Message is overrriden',
                    duration:' 1000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                flagSet = false; */
            }
            
            if(strtDate > edDate){
                var msg = $A.get("$Label.c.Start_Date_should_be_less_than_End_Date");
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error Message',
                    message:msg,
                    messageTemplate: 'Mode is pester ,duration is 1 sec and Message is overrriden',
                    duration:' 1000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                flagSet = false; 
            }else{
                flagSet = true;
            }
            
        }else{
            flagSet = true; 
        }
        
        
        //for Account
        if(strAccount!=null){
            accId= strAccount.Id;
            
        }else{
            accId= undefined;
        }
        
        //for Owner 
        if(strOwner!=null){
            ownerId= strOwner.Id;
            
        }else{
            ownerId= undefined;
        }
        
        
        if(flagSet){
            if(isSameDate){
                helper.fetchSalesOrderData(component, event, accId,ownerId,strtDate,statusOrder,edDate,isSameDate);
            }else{
                helper.fetchSalesOrderData(component, event, accId,ownerId,strtDate,statusOrder,edDate,false);    
            }
            
        }
        
        
        
        
        
        
        
        
        
    }, 
    
    scriptsLoaded: function(component, event, helper) {
        console.log('Script loaded..');
        helper.fetchSalesOrderData1(component, event, null,null,'Pending',null,null); 
        
    },  
    
    resetItem : function(component, event, helper) {
        component.set('v.selectedRecordAccount',null);
        component.set('v.selectedRecordOwnerName',null);
        component.find("startDate").set("v.value",null);
        component.find("Status_Type").set("v.value",'none');
        //component.find("Sub_Order_Type").set("v.value",'none'); 
        component.find("endDate").set("v.value",null) ;
        component.set("v.lstSalesOrder", null);
        component.set("v.showDataTable",false) ;
        component.set("v.dateValidationError1",false) ;
        component.set("v.dateValidationError",false) ;
        component.find("vAccount").set("v.value",'');
        component.find("vOwnerName").set("v.value",'');
        var table = $('#tableId').DataTable();
        table.destroy();
        
        
        //for Account Name
        var forclose = component.find("lookup-pill-Account");
        $A.util.addClass(forclose, 'slds-hide');
        $A.util.removeClass(forclose, 'slds-show');
        
        var forclose = component.find("searchResAccount");
        $A.util.addClass(forclose, 'slds-is-hide');
        $A.util.removeClass(forclose, 'slds-is-show');
        
        var lookUpTarget = component.find("lookupFieldAccount");
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide'); 
        
        
        // for Owner Name
        var forclose1 = component.find("lookup-pill-OwnerName");
        $A.util.addClass(forclose1, 'slds-hide');
        $A.util.removeClass(forclose1, 'slds-show');
        
        var forclose2 = component.find("searchResOwnerName");
        $A.util.addClass(forclose2, 'slds-is-hide');
        $A.util.removeClass(forclose2, 'slds-is-show');
        
        var lookUpTarget1 = component.find("lookupFieldOwnerName");
        $A.util.addClass(lookUpTarget1, 'slds-show');
        $A.util.removeClass(lookUpTarget1, 'slds-hide'); 
        
        
        
        
    }, 
    
       
    downloadCsv : function(component,event,helper){
        var stockData = component.get("v.lstSalesOrder");
        var csv = helper.convertArrayOfObjectsToCSV(component,stockData);
        if (csv == null){return;} 
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_self'; // 
        hiddenElement.download = 'Sales_Order.csv';  // CSV file Name* you can change it.
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    },
    
    navigatePage : function(component,event,helper){
    
       console.log(event.getSource().get("v.value"));
        var sId = event.getSource().get("v.value");
        
         var url = "/apex/VFPageToOpenComp?recordId="+sId;
      
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            'url': url
        });
        urlEvent.fire();
      
   
    },
    
    
})