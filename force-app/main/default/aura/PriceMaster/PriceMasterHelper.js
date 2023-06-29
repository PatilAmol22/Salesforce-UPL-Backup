({   
    goDown : function (component) {
        
        var isCloneVar = component.get("v.isClone");
        //var sPageURL = decodeURIComponent(window.location);
        //var isNewVal = sPageURL.substr(sPageURL.lastIndexOf('/') + 1);
        var isDone = true; 
        
        
        var recordId = component.get("v.recordId"); 
        if (typeof recordId != "undefined"){
           console.log('Edit record----->');
            if(isCloneVar){
                setTimeout(function(){ 
                    component.find("newLineItemClone").focus();
                },100);
            }else{
                
                setTimeout(function(){ 
                    component.find("newLineItemUpdate").focus();
                },100);
            }
            
        }else if(typeof recordId == "undefined"){
           console.log('New record--->');
            
            setTimeout(function(){ 
                component.find("newLineItem").focus();
            },100);
        }
        /*
        if(isNewVal == 'new' ){
            setTimeout(function(){ 
                component.find("newLineItem").focus();
            },100);
        } 
        if(isNewVal == 'edit' ){
            if(isCloneVar){
                setTimeout(function(){ 
                    component.find("newLineItemClone").focus();
                },100);
            }else{
                
                setTimeout(function(){ 
                    component.find("newLineItemUpdate").focus();
                },100);
            }
        }*/
    },
    gotoListviewHelper : function (component) {
        
    	var action = component.get("c.getListViews");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {               
                
                var homeEvent = $A.get("e.force:navigateToObjectHome");
                homeEvent.setParams({
                    "scope": "Price_Book__c"
                });
                homeEvent.fire();
            }
        });
        $A.enqueueAction(action);
	},
    showErrorToast : function(component) {
        var DivMSg =  $A.get("{!$Label.c.Division_required}");
        var ErrorMsg = $A.get("{!$Label.c.Error}");
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": ErrorMsg,        
            "type": "error",
            "message": DivMSg
            
               // "type": "error",
        });
        toastEvent.fire();
	},
    showCloneToast : function(component) { 
        
        var cloneMSg = $A.get("{!$Label.c.Price_Book_Cloned_Successfully}");
        var successMsg = $A.get("{!$Label.c.Success}");
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            
            "title": successMsg,
            "type": "Success",
            "message": cloneMSg
        });
        toastEvent.fire();
	},
    applyCSS: function(component){
        
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:0} .forceStyle.desktop .viewport{overflow:hidden}");
    	var isSaldtNull = component.get("v.showErrOnDiv");
        if(isSaldtNull){
            component.set("v.showErrOnDiv", false);
        }
        
        var skuWrapper = component.get("v.wrappers");
        var inx = component.get("v.rowIndex");
       // alert('idex-->'+inx);
        
        if( skuWrapper.length > 0 ){
            
            var getSkuAllId = component.find("skuName");
            var isArray = Array.isArray(getSkuAllId);
            if(!isArray){
                component.find("skuName").set("v.errors",null);
            }else{
                for(var i = 0 ;i < skuWrapper.length ;i++){
                    if(i==inx){
                       component.find("skuName")[i].set("v.errors",null); 
                    }
                }
            }   
        }
        
		/*if( skuWrapper.length > 0 ){
            alert('Code');
             alert('inx--->'+inx);
            var skusalesforceId = component.find("SkuCode");
            var isArray = Array.isArray(skusalesforceId);
            for(var k = 0 ;k < skuWrapper.length;k++){
                for(var j = k+1 ; j < skuWrapper.length; j++){
                    // alert('SkuName-->'+getSkuAllId[k].get("v.value"));
                    //console.log('SkuName-->'+getSkuAllId[k].get("v.value"));
                    console.log('OnSelction--SkuCode[k]-->'+skusalesforceId[k].get("v.value"));
                    console.log('OnSelction--SkuCode[j]-->'+skusalesforceId[j].get("v.value"));
                    
                    if(skusalesforceId[k].get("v.value") == skusalesforceId[j].get("v.value")){
                        //component.set("v.isSkuDuplicate", true);
                        var err  = $A.get("{!$Label.c.Duplicate_Entries_Found_on_Material_List}");
                        alert(err);
                        component.find("skuName")[j].set("v.errors",[{message:err}]);
                        //isPriceBookvalid = false;
                        //isSalesDistvalid = false;                                   
                    }    
                }
            }  
        }  */      
        
        
    },
    revertCssChange: function(component){
        
        var isCloneVar = component.get("v.isClone");        
        var isDone = true; 
        
         var recordId = component.get("v.recordId"); 
        if (typeof recordId != "undefined"){
           console.log('Edit Record----->');
            if(isCloneVar){
                setTimeout(function(){ 
                    component.find("newLineItemClone").focus();
                },100);
            }else{
                
                setTimeout(function(){ 
                    component.find("newLineItemUpdate").focus();
                },100);
            }
            
        }else if(typeof recordId == "undefined"){
			console.log('New Record----->');
             setTimeout(function(){ 
                component.find("newLineItem").focus();
            },100);
		}
        
        
        /*
        if(isNewVal == 'new' ){
            setTimeout(function(){ 
                component.find("newLineItem").focus();
            },100);
        } 
        if(isNewVal == 'edit' ){
            if(isCloneVar){
                setTimeout(function(){ 
                    component.find("newLineItemClone").focus();
                },100);
            }else{
                
                setTimeout(function(){ 
                    component.find("newLineItemUpdate").focus();
                },100);
            }
        }*/
        
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:5} .forceStyle.desktop .viewport{overflow:visible}");
        
        
   	},
    fetchDivision : function(cmp) {
        var action = cmp.get("c.getDivision");
        var accountColumns = [
            {
                //$A.get("$Label.c.SKU_Description")
                'label':$A.get("$Label.c.Name"),
                'name':'Name',
                'type':'string',
                'value':'Id',
                'width': 50,
            },
            {
                //$A.get("$Label.c.Name")
                'label':$A.get("$Label.c.Division_Code"),
                'name':'Division_Code__c',
                'type':'string',
                'width': 50,              
            }
        ];
        
        //Configuration data for the table to enable actions in the table
        var accountTableConfig = {
            "rowAction":[
                {
                    "label": $A.get("$Label.c.Select"),
                    "type":"url",
                    "id":"selectDivision",
                    
                }
            ]
        };
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(cmp.isValid() && state === 'SUCCESS'){
                
                cmp.set("v.accountList",resp.getReturnValue());
                cmp.set("v.accountColumns",accountColumns);
                cmp.set("v.accountTableConfig",accountTableConfig);
                cmp.find("accountTable").initialize({
                    "order":[0,"asc"]
                });
            }
            else{
                console.log(resp.getError());
            }
        });
        $A.enqueueAction(action);       
    },
    fetchSalesDistrict : function(cmp) {
        //alert('1');
        var action = cmp.get("c.getSalesDistrict");
       //Column data for the table
       //Do not chnage the column names 
        var accountColumns = [
            {
                'label':$A.get("$Label.c.Sales_District_Name"),
                'name':'Name',
                'type':'string',
                'value':'Id',
                //'width': 100,
                'resizeable':true
            },
            {
                'label':$A.get("$Label.c.Sales_District_Code"),
                //'label':'Sales District Code',
                'name':'RegionCode__c',
                'type':'Id',
                'value':'Id',
                //'width': 100,
                'resizeable':true
            },
        ];
            //Configuration data for the table to enable actions in the table
            var accountTableConfig = {
            "massSelect":false,
            "globalAction":[],
            "rowAction":[
                {
                    "label": $A.get("$Label.c.Select"),
                    "type":"url",
                    "id":"salectDist",
                   //'width': 100,
                    'resizeable':true
                }]
    	};
        
        action.setCallback(this,function(resp){
        var state = resp.getState();
        if(cmp.isValid() && state === 'SUCCESS'){
        
        cmp.set("v.accountList",resp.getReturnValue());
        cmp.set("v.accountColumns",accountColumns);
        cmp.set("v.accountTableConfig",accountTableConfig);
        cmp.find("accountTable").initialize({
            "order":[0,"asc"]
        });
        }else{
            console.log(resp.getError());
        }
        });
        $A.enqueueAction(action);
    
    },
    fetchSku : function(cmp) {
        
        var divName = cmp.find("HiddenDivisionName"); 
        var divActName = divName.get("v.value");
        var action = cmp.get("c.getSku");
        action.setParams({ "divisionId" : divActName
                         });
        
        //Column data for the table
        var accountColumns = [
            
            {
                //{!$Label.c.Material_Entries_Required}
                //$A.get("$Label.c.SKU_Description")
                'label':$A.get("$Label.c.SKU_Description"),
                'name':'SKU_Description__c',
                'type':'string',
               // 'width': 100,
                
            },
            {
                
                'label':$A.get("$Label.c.SKU_Name"),
                'name':'Name',
                'type':'string',
                'value':'Id',
                //'width': 50,
                
            },
            
             {
                'label':$A.get("$Label.c.SKU_Code"),
                'name':'SKU_Code__c',
                'type':'string',
                'value':'Id',
                //'width': 50,
                
            }
           
        ];
            
            //Configuration data for the table to enable actions in the table
            var accountTableConfig = {
            "massSelect":false,
            "globalAction":[  ],
            "rowAction":[
                {
                    "label": $A.get("$Label.c.Select"),
                    "type":"url",
                    "id":"selectSku",
                   // 'width': 25,
                }
            ]};

        action.setCallback(this,function(resp){
        var state = resp.getState();
        if(cmp.isValid() && state === 'SUCCESS'){
            
            cmp.set("v.accountList",resp.getReturnValue());
            cmp.set("v.accountColumns",accountColumns);
            cmp.set("v.accountTableConfig",accountTableConfig);
            
            //initialize the datatable
            cmp.find("accountTable").initialize({
                "order":[0,"desc"],
                "itemMenu":["5","10","25","50"],
                "itemsPerPage:":5         
            });
            }
            else{
                console.log(resp.getError());
            }
        });
        
        $A.enqueueAction(action);
    },
    removeSalesDist : function(component, index) {
           
            //var iseditRec = component.get("v.isEdit");
        	//alert('iseditRec------>'+iseditRec);
        	//var editCount = component.get("v.salesdtCount");
        	//alert('editCount-->'+editCount);
        	//var newSalesDist = component.get("v.salesdtarr");
        
        
            var divError = component.get("v.showduplicateErr");
            if(divError){
                component.set("v.showduplicateErr", false);
            }
            var divError1 = component.get("v.showErrOnDiv");
            if(divError1){
                component.set("v.showErrOnDiv", false);
            }
            
            var node = component.get("v.salesdtarr");
            node.splice(index, 1);
            component.set("v.salesdtarr", node);
    },
    removeSku : function(component, index) {
        

            var arrsku = new Array();
            var sku = component.get("v.wrappers");
            if (index > -1) {
                sku.splice(index, 1);
            }
            component.set("v.wrappers", sku);            
            var isNew = component.get("v.isSavebtnHide");
            if(isNew){
                component.set("v.isEdit", false);
            }else{
                component.set("v.isEdit", true);    
            }
            
            if(sku.length==0){
                var result = component.get("v.isEdit");
                if(!result){
                    component.find("DivisionName").set("v.disabled",true);
                    component.find("searchUtil").set("v.disabled",false);
                    
                }
            }
    },
    editPriceBook :function(component,event,helper){
       
    	var retrivePLaction = component.get("c.getPriceBookRecord");
        retrivePLaction.setParams({
            "priceBookRecId":component.get("v.recordId")
        });
        retrivePLaction.setCallback(this, function(response) {
            
            var state = response.getState();
            if(state === "SUCCESS") {
				
                var data = JSON.stringify(response.getReturnValue());
                var parsed = JSON.parse(data);
                var priceBookObj = JSON.stringify(parsed.priceBookList);
                var priceBookDetails = JSON.stringify(parsed.priceBookDetailLst);
                var priceBookSalesDt = JSON.stringify(parsed.priceBookSalesDistLst);
                var countOfSalesdt = JSON.stringify(parsed.salesdistCount);
                
                //console.log('countOfSalesdt--->'+countOfSalesdt);
                //component.set("v.salesdtCount",countOfSalesdt);
                
                component.set("v.PriceBook",parsed.priceBookList);
                var priceBokrecord = component.get("v.PriceBook");
                //component.set("v.PriceBookDivisionName",priceBokrecord.Division__r.Name);
               // component.find("HiddenDivisionName").set("v.value", priceBokrecord.Division__c);
                component.find("DivisionName").set("v.disabled",true);
                var currencyVal = priceBokrecord.Currency__c;
                var pricebkName = priceBokrecord.Name;
                var orginalString = pricebkName.slice(6, pricebkName.length);
                
                component.set("v.PriceBook.Name",orginalString);
                if(currencyVal == "Only USD"){
                    component.find("currencyID").set("v.value","Only USD");
                }                
                if(currencyVal == "Only BRL"){
                   component.find("currencyID").set("v.value","Only BRL");
                }
                component.find("currencyID").set("v.disabled",true);
                component.find("searchUtil").set("v.disabled",true);
                
                var newWrapper = new Array();
                var wrappers1 = component.get('v.wrappers');  
                console.log('priceBookDetails-->'+priceBookDetails);
                for(var j = 0 ;j < parsed.priceBookDetailLst.length;j++){
                    
                    console.log('DetailRecordId--->'+parsed.priceBookDetailLst[j].Id);
                    console.log('Sku--->'+parsed.priceBookDetailLst[j].SKU__c);
                    
                    newWrapper = {
                        'Id':parsed.priceBookDetailLst[j].Id,
                        'skuId': parsed.priceBookDetailLst[j].SKU__c,
                        'SkuCode': parsed.priceBookDetailLst[j].SKU_Code__c,
                        'Name' :parsed.priceBookDetailLst[j].Sku_Name__c,
                        'SkuDes':parsed.priceBookDetailLst[j].Sku_Name1__c,
                        'unitPrice':parsed.priceBookDetailLst[j].Unit_Price__c,
                        'minPrice':parsed.priceBookDetailLst[j].Minimum_Price__c,
                        'monthlyIntRate':parsed.priceBookDetailLst[j].Monthly_Interest_Rate__c,
                        'exchangeRate':parsed.priceBookDetailLst[j].Exchange_Rate__c
                    };
                    wrappers1.push(newWrapper);
                }
                
                
                 
                
                
                var newWrapperSdt = new Array();
                var wrappers2 = component.get('v.salesdtarr');
                for(var j = 0 ;j < parsed.priceBookSalesDistLst.length;j++){
                    
                    console.log('DistId--->'+parsed.priceBookSalesDistLst[j].Id);
                    newWrapperSdt = {
                        'Id1':parsed.priceBookSalesDistLst[j].Id,
                        'sdtId': parsed.priceBookSalesDistLst[j].Sales_District1__c,
                        'Name' :parsed.priceBookSalesDistLst[j].Sales_District_Name1__c,
                        'SDCode':parsed.priceBookSalesDistLst[j].Sales_District_Code__c
                    };
					wrappers2.push(newWrapperSdt);                    
                }
               
                var today = new Date();
                var monthDigit = today.getMonth() + 1;
                if (monthDigit <= 9) {
                    monthDigit = '0' + monthDigit;                    
                }
                component.set("v.isEdit", true);
                component.set("v.isBothCurrency", false);
                var dateval = today.getFullYear() + "-" + monthDigit + "-" + today.getDate();                
                component.set("v.PriceBookDivisionName",parsed.priceBookList.Division__r.Name);
                component.set("v.myDate", dateval);
                var dd = new Date(parsed.priceBookList.Expiry_Date__c);
              
               // var dddigit1 = dd.getDay();
                var dddigit1 = dd.getDate();
                //console.log('test1--->'+test1);
                
                if (dddigit1 <= 9) 
                {dddigit1 = '0' + dddigit1;                    
                }
                
                var today1 = new Date(parsed.priceBookList.Expiry_Date__c);
                var monthDigit1 = today1.getMonth() + 1;
                if (monthDigit1 <= 9) {
                    monthDigit1 = '0' + monthDigit1;                    
                }
                var dateval1 = today1.getFullYear() + "-" + monthDigit1 + "-" + dddigit1;               
                component.set("v.myDate1",dateval1);               
              
               
                if(dateval1 <= dateval){
                    component.find("validfrmId").set("v.errors",null);
                    component.find("expiryId").set("v.errors",null);
                }
                component.set("v.salesdtarr",wrappers2);
             	component.set("v.wrappers",wrappers1);
                
                var getSkuAllId = component.find("sdtNameforSales");
                var isArray = Array.isArray(getSkuAllId);
                if(isArray){
                    for(var j = 0 ;j < parsed.priceBookSalesDistLst.length;j++){
                        component.find("sldtUtil")[j].set("v.disabled",true);
                        component.find("lkpdisable")[j].set("v.disabled",true);
                    }
                }else{
                    component.find("sldtUtil").set("v.disabled",true);
                    component.find("lkpdisable").set("v.disabled",true);
                }
                
                
                var skusalesforceId = component.find("SkuCode");
                var skuCodeId = component.find("SkuCode1");
                var getSkuAllId1 = component.find("skuName");
                var getminPriceId = component.find("minPrice");
                var getunitPriceId = component.find("unitPrice");
                var getmonthRateAllId = component.find("monthRate");
                var alltexchangeRateId = component.find("exchangeRate");
               
                
                var isArray = Array.isArray(getSkuAllId1);
                if(isArray){
                    for(var j = 0 ;j < parsed.priceBookDetailLst.length;j++){
                        
                        component.find("skulkp")[j].set("v.disabled",true);
                        component.find("skuName")[j].set("v.disabled",true);
                        component.find("minPrice")[j].set("v.disabled",true);
                        component.find("unitPrice")[j].set("v.disabled",true);
                        component.find("monthRate")[j].set("v.disabled",true);
                        component.find("monthRate")[j].set("v.disabled",true);
                        component.find("skudelete")[j].set("v.disabled",true);
                        
                    }
                }else{
                    component.find("skulkp").set("v.disabled",true);
                    component.find("skuName").set("v.disabled",true);
                    component.find("minPrice").set("v.disabled",true);
                    component.find("unitPrice").set("v.disabled",true);
                    component.find("monthRate").set("v.disabled",true);
                    component.find("monthRate").set("v.disabled",true);
                    component.find("skudelete").set("v.disabled",true);
                }
                
            }
        });
        $A.enqueueAction(retrivePLaction);        
        
    }
})