({    
    doInit : function(component, event, helper){
        
        var Today = new Date();
        var recordId = component.get("v.recordId"); 
        
        if (typeof recordId != "undefined"){
            
            console.log('Record Existed--->');
            component.set("v.isbtndisable", true);
            component.set("v.isSavebtnHide", false);
            component.set("v.isEdit", true);
            helper.editPriceBook(component);
            
        }else if(typeof recordId == "undefined"){
            console.log('New Record--->');
            
            //component.find("searchUtil").set("v.disabled",false);
            
            component.set("v.isSavebtnHide", true);
            component.set("v.isbtndisable", false);
            component.set("v.isEdit", false);
            //getDefaultDivision
            
            var actionDivision = component.get("c.getDefaultDivision");
            actionDivision.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    var data = JSON.stringify(response.getReturnValue());
                    var parsed = JSON.parse(data);
                    for(var j=0;j<1;j++){
                        component.set("v.PriceBookDivisionName",parsed[j].Name);
                        component.find("HiddenDivisionName").set("v.value", parsed[j].Id);
                    }
                }else{
                    console.log('state--->'+state);
                }
            });
            $A.enqueueAction(actionDivision); 
            component.find("DivisionName").set("v.disabled",true);
            
            var Today = new Date();
            var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();
            var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
            var yyyy = Today.getFullYear();
            var expiryDate = (yyyy + "-" + MM + "-" + dd);
            component.set('v.myDate', yyyy + "-" + MM + "-" + dd);
            component.set('v.myDate1', yyyy + "-" + MM + "-" + dd);
        }
        
        
        
        /*
        var sPageURL = decodeURIComponent(window.location); 
        var isNewVal = sPageURL.substr(sPageURL.lastIndexOf('/') + 1);
        
        console.log('recordId--->'+recordId);
        
        console.log('isNewVal--->'+isNewVal);
        if(isNewVal == "new"){
            
        }else{
            console.log('Else--isNewVal--->'+isNewVal);
        }
        if(isNewVal == "edit"){
            component.set("v.isbtndisable", true);
            component.set("v.isSavebtnHide", false);
        }*/
    },
    handleValidfromValueChange : function(component, event, helper){
        
        var isNullCheck = true;
        var validfrmDt = component.get("v.myDate");
        var expiryDt = component.get("v.myDate1");
        var falseDate = true;         
        var Today = new Date();
        
        var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();
        var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
        var yyyy = Today.getFullYear();
        var expiryDate = (yyyy + "-" + MM + "-" + dd);
        
        console.log('validfrmDt-->'+validfrmDt);
        if(validfrmDt == ''){
            console.log('validfrmDt-->'+validfrmDt);
            isNullCheck = false;
            var err  = $A.get("{!$Label.c.Valid_from_date_is_Required}");
            component.find("validfrmId").set("v.errors",[{message:err}]);
            falseDate = false; 
        }else{            
            component.find("validfrmId").set("v.errors",null);
            falseDate = true;
        }       
        
        if(isNullCheck){
            
            if(validfrmDt < expiryDate){ 
                
                var err  = $A.get("{!$Label.c.PD_ValidFromError}");
                component.find("validfrmId").set("v.errors",[{message:err}]);
                falseDate = false;            
            }else{
                component.find("validfrmId").set("v.errors",null);
                falseDate = true;
            }
            if(expiryDt < validfrmDt){
                
                var err  = $A.get("{!$Label.c.PD_ExpiryError}");
                component.find("expiryId").set("v.errors",[{message:err}]);
                falseDate = false;
            }else{
                component.find("expiryId").set("v.errors",null); 
                falseDate = true;
            }
        }
        
        
        
    },
    handleExpiryValueChange: function(component, event, helper){
        //alert('how expiry gets Called');
        var isNullCheck = true;
        var validfrmDt = component.get("v.myDate");
        //console.log('Method--validfrmDt--'+validfrmDt);
        var expiryDt = component.get("v.myDate1");
        //console.log('Method--ExpiryDt--'+expiryDt);
        var falseDate1 = true;
        var Today = new Date();
        //console.log('todaydate'+Today.getDate());
        var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();    
        var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
        var yyyy = Today.getFullYear();
        var todayDate = (yyyy + "-" + MM + "-" + dd);
        //console.log('method--todayDate---'+todayDate);
        
   
        if(expiryDt == ''){
            isNullCheck = false;
            var err  = $A.get("{!$Label.c.Expiry_date_Required}");
            component.find("expiryId").set("v.errors",[{message:err}]);
            falseDate1 = false; 
        }else{            
            component.find("expiryId").set("v.errors",null);
            falseDate1 = true;
        }
        
        if(isNullCheck){
            console.log('Inside--isNullCheck-'+isNullCheck);
            if(expiryDt < todayDate){
                component.find("expiryId").set("v.errors",[{message:"Select Expiry date greater than today"}]);
                falseDate1 = false;
                
            }else{
                component.find("expiryId").set("v.errors",null); 
                falseDate1 = true;
            }
            
          
          //  if(expiryDt < vaildfrm){
             if(expiryDt < todayDate){
                var err  = $A.get("{!$Label.c.PD_ExpiryError}");
                component.find("expiryId").set("v.errors",[{message:err}]);
                falseDate1 = false;
            }else{
                component.find("expiryId").set("v.errors",null); 
                falseDate1 = true;
            }
            
           if(expiryDt < validfrmDt){
                
                var err  = $A.get("{!$Label.c.PD_ExpiryError}");
                component.find("expiryId").set("v.errors",[{message:err}]);
                falseDate1 = false;
            }else{
                component.find("expiryId").set("v.errors",null); 
                falseDate1 = true;
            }
        }
        
    },    
    onCurrencyChange: function(component, event, helper){
        
        var currecny = component.find("currencyID"); 
        var Selectedcurr = currecny.get("v.value");
        
        if(Selectedcurr == 'BRL and USD'){
            component.set("v.isBothCurrency", true);
        }else{
            component.set("v.isBothCurrency", false);
        } 
    },
    hideAndClonePriceBookJs: function(component, event, helper){
        
        component.set("v.showSpinner", true);  
        component.set("v.isClone", true);
        component.set("v.isbtndisable", false);
        component.find("currencyID").set("v.disabled",false);
        component.set("v.showSpinner", false);
        
        var salesdt = component.get('v.salesdtarr');
        var wrapp = component.get('v.wrappers'); 
        
        var getSkuAllId = component.find("sdtNameforSales"); 
        
        var isArray = Array.isArray(getSkuAllId);
        if(isArray){
            for(var j = 0 ;j < salesdt.length;j++){
                component.find("sldtUtil")[j].set("v.disabled",false);
                component.find("lkpdisable")[j].set("v.disabled",false);
            }
        }else{
            component.find("sldtUtil").set("v.disabled",false);
            component.find("lkpdisable").set("v.disabled",false);
        }
        
        var skuCodeId = component.find("SkuCode1");
        var getSkuAllId1 = component.find("skuName");
        var getminPriceId = component.find("minPrice");
        var getunitPriceId = component.find("unitPrice");
        var getmonthRateAllId = component.find("monthRate");
        var alltexchangeRateId = component.find("exchangeRate");
        
        
        var isArray = Array.isArray(getSkuAllId1);
        if(isArray){
            for(var j = 0 ;j < wrapp.length;j++){
                
                component.find("skulkp")[j].set("v.disabled",false);
                component.find("skuName")[j].set("v.disabled",false);
                component.find("minPrice")[j].set("v.disabled",false);
                component.find("unitPrice")[j].set("v.disabled",false);
                component.find("monthRate")[j].set("v.disabled",false);
                component.find("monthRate")[j].set("v.disabled",false);
                component.find("skudelete")[j].set("v.disabled",false);
                
            }
        }else{
            component.find("skulkp").set("v.disabled",false);
            component.find("skuName").set("v.disabled",false);
            component.find("minPrice").set("v.disabled",false);
            component.find("unitPrice").set("v.disabled",false);
            component.find("monthRate").set("v.disabled",false);
            component.find("monthRate").set("v.disabled",false);
            component.find("skudelete").set("v.disabled",false);
        }
        console.log('hideAndClonePriceBookJs--');
    },
    clonePriceBookJs: function(component, event, helper){
        
        // Boolean var
        var isPriceBookvalid = true;
        var isSalesDistvalid = true ;
        var isMaterialvalid = true;
        var isEdit = component.get("v.isEdit");
        
        // PriceBook Name
        var nameField = component.find("priceBookName");
        var name = nameField.get("v.value");
        
        // valid from Date             
        var validfrmDt = component.get("v.myDate");
        
        // Expiry from Date
        var expiryDt = component.get("v.myDate1");
        
        // Division Name     
        var divName = component.find("DivisionName"); 
        var divActName = divName.get("v.value");
        
        // sales District     
        var arrOfSalesdist = component.get("v.salesdtarr"); 
        var skuWrapper = component.get("v.wrappers");
        
        if(nameField.get("v.value") == null || nameField.get("v.value") == ''){
            var err  = $A.get("{!$Label.c.Description_is_required}");
            nameField.set("v.errors",[{message:err}]);
            isPriceBookvalid = false;
            
        }else{            
            nameField.set("v.errors",null);
        }
        var Today = new Date();
        var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();
        var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
        var yyyy = Today.getFullYear();
        var today = (yyyy + "-" + MM + "-" + dd);
        if(validfrmDt < today){
            
           // var err = '{!$Label.c.PD_ValidFromError}';
            var err  = $A.get("{!$Label.c.PD_ValidFromError}");
            component.find("validfrmId").set("v.errors",[{message:err}]);
            isPriceBookvalid = false; 
            
        }else{
            component.find("validfrmId").set("v.errors",null);
        } 
        
        if(expiryDt == null){
            component.find("expiryId").set("v.errors",[{message:"Expiry date Required"}]);
            isPriceBookvalid = false;
        }else{
            component.find("expiryId").set("v.errors",null); 
        }
        if(isEdit == true){            
            if(expiryDt  < today){
                
                // var err = '{!$Label.c.PD_ExpiryError}';
                var err  = $A.get("{!$Label.c.PD_ExpiryError}");
                component.find("expiryId").set("v.errors",[{message:err}]);
                isPriceBookvalid = false;
            }else{
                component.find("expiryId").set("v.errors",null);
            }
        }
        if(divName.get("v.value") == null ){
            
            var err  = $A.get("{!$Label.c.Division_required}");
            //var err = '{!$Label.c.Division_required}';
            divName.set("v.errors",[{message:err}]);
            isPriceBookvalid = false;
        }else{
            divName.set("v.errors",null); 
        }
        if(isPriceBookvalid){
            
            if(arrOfSalesdist.length == 0 && isPriceBookvalid != false){
                component.set("v.isErrors", true);
                helper.applyCSS(component);
                isSalesDistvalid = false;
                
            }else if(arrOfSalesdist.length > 0){
                //finding the duplicates salesdistrict
                for(var i = 0 ;i<arrOfSalesdist.length;i++){
                    for(var j = i+1 ;j<arrOfSalesdist.length;j++){
                        console.log('arrOfSalesdist[i].Name'+arrOfSalesdist[i].Name);
                        if(arrOfSalesdist[i].Name == arrOfSalesdist[j].Name){
                            component.set("v.showduplicateErr", true);
                            isPriceBookvalid = false;
                            isSalesDistvalid = false;
                        }    
                    }
                }
                // finding any null salesdistrict are added or not
                for(var i = 0 ;i<arrOfSalesdist.length;i++){
                    if(arrOfSalesdist[i].Name == null){
                        component.set("v.showErrOnDiv", true);
                        isSalesDistvalid = false;
                    }else{
                        component.set("v.showErrOnDiv", false);
                        //isSalesDistvalid = true ;
                    }
                }
            }// elseif closed
            
            // checking material is added or not
            if(skuWrapper.length == 0 && isPriceBookvalid != false && isSalesDistvalid != false){
                component.set("v.isSKuErrors", true);
                helper.applyCSS(component);
                isMaterialvalid = false;
            }
            if(isMaterialvalid){
                
                var skusalesforceId = component.find("SkuCode");
                var skuCodeId = component.find("SkuCode1");
                var getSkuAllId = component.find("skuName");
                var getminPriceId = component.find("minPrice");
                var getunitPriceId = component.find("unitPrice");
                var getmonthRateAllId = component.find("monthRate");
                var alltexchangeRateId = component.find("exchangeRate");           
                var bothCurrValid = component.get("v.isBothCurrency");
                
                 var isArray = Array.isArray(getSkuAllId);
                
                if(!isArray){
                    
                    if(getSkuAllId.get("v.value") == null || getSkuAllId.get("v.value") == ''){
                        
                        //var val = '{!$Label.c.MD_Required_Error}';
                         var val  = $A.get("{!$Label.c.MD_Required_Error}");
                        component.find("skuName").set("v.errors",[{message:val}]);                    
                        component.set("v.isMaterialReq",false);
                        isMaterialvalid = false;
                        isPriceBookvalid = false;
                        
                    }else{
                        component.find("skuName").set("v.errors",null);
                    }
                    
                    if(getminPriceId.get("v.value") == null ){
                        //var err = '{!$Label.c.Not_Empty_Message}';
                        var err  = $A.get("{!$Label.c.Not_Empty_Message}");
                        component.find("minPrice").set("v.errors",[{message:err}]); 
                        var toggleText = component.find("minPrice");                    
                        $A.util.addClass(toggleText, "error");
                        isMaterialvalid = false;
                        isPriceBookvalid = false;
                        
                    }else if(getminPriceId.get("v.value") < 0){
                        
                        var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                        component.find("minPrice").set("v.errors",[{message:err}]); 
                        var toggleText = component.find("minPrice");                    
                        $A.util.addClass(toggleText, "error");
                        isMaterialvalid = false;
                        isPriceBookvalid = false; 
                        
                    }else{
                        
                        component.find("minPrice").set("v.errors",null); 
                        var toggleText = component.find("minPrice");                    
                        $A.util.removeClass(toggleText, "error");
                    }
                    
                    // validating Single SKU Unit Price
                    if(getunitPriceId.get("v.value") == 0 || getunitPriceId.get("v.value") == null || getunitPriceId.get("v.value") == ''){
                        var err  = $A.get("{!$Label.c.Not_Empty_Message}");
                        component.find("unitPrice").set("v.errors",[{message:err}]); 
                        var toggleText = component.find("unitPrice");                    
                        $A.util.addClass(toggleText, "error");
                        isMaterialvalid = false;
                        isPriceBookvalid = false;
                        
                    }else if(getunitPriceId.get("v.value") < 0){
                        var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                        component.find("unitPrice").set("v.errors",[{message:err}]); 
                        var toggleText = component.find("unitPrice");                    
                        $A.util.addClass(toggleText, "error");
                        isMaterialvalid = false;
                        isPriceBookvalid = false; 
                        
                    }else{
                        component.find("unitPrice").set("v.errors",null); 
                        var toggleText = component.find("unitPrice");                    
                        $A.util.removeClass(toggleText, "error");
                    }
                    
                    // Validation Minimun Price
                    var unitPricval = getunitPriceId.get("v.value");
                    var minPriceval = getminPriceId.get("v.value");
                    if(minPriceval != null || minPriceval != '' ){
                        if( unitPricval < minPriceval){ 
                            var err  = $A.get("{!$Label.c.Unit_Should_be_Greater_than_Minimum}");
                            //var err = '{!$Label.c.Unit_Should_be_Greater_than_Minimum}';
                            component.find("unitPrice").set("v.errors",[{message:err}]); 
                            var toggleText = component.find("unitPrice");                    
                            $A.util.addClass(toggleText, "error");
                            isMaterialvalid = false;
                            isPriceBookvalid = false;
                            
                        }
                    }
                    
                    // validating Single SKU month Price
                    if(getmonthRateAllId.get("v.value") == null ){
                        var err  = $A.get("{!$Label.c.Not_Empty_Message}");
                       // var err = '{!$Label.c.Not_Empty_Message}';
                        component.find("monthRate").set("v.errors",[{message:err}]); 
                        var toggleText = component.find("monthRate");                    
                        $A.util.addClass(toggleText, "error");
                        isMaterialvalid = false;
                        isPriceBookvalid = false;
                    }else if(getmonthRateAllId.get("v.value") < 0){
                        var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                        component.find("monthRate").set("v.errors",[{message:err}]); 
                        var toggleText = component.find("monthRate");                    
                        $A.util.addClass(toggleText, "error");
                        isMaterialvalid = false;
                        isPriceBookvalid = false; 
                    }else{
                        component.find("monthRate").set("v.errors",null); 
                        var toggleText = component.find("monthRate");                    
                        $A.util.removeClass(toggleText, "error");
                    }
                    
                    // validating currency 
                    if(bothCurrValid){
                        
                        if(alltexchangeRateId.get("v.value") == 0 || alltexchangeRateId.get("v.value") == null || alltexchangeRateId.get("v.value") == ''){
                            var err  = $A.get("{!$Label.c.Not_Empty_Message}");
                            //var err = '{!$Label.c.Not_Empty_Message}';
                            component.find("exchangeRate").set("v.errors",[{message:err}]); 
                            var toggleText = component.find("exchangeRate");                    
                            $A.util.addClass(toggleText, "error");
                            isMaterialvalid = false;
                            isPriceBookvalid = false;
                        }else if(alltexchangeRateId.get("v.value") < 0){
                            var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                            component.find("exchangeRate").set("v.errors",[{message:err}]); 
                            var toggleText = component.find("exchangeRate");                    
                            $A.util.addClass(toggleText, "error");
                            isMaterialvalid = false;
                            isPriceBookvalid = false; 
                        }else{
                            component.find("exchangeRate").set("v.errors",null); 
                            var toggleText = component.find("exchangeRate");                    
                            $A.util.removeClass(toggleText, "error");
                        }
                    }

                }else{ 
                    
                    try{
                        for(var k = 0 ;k < skuWrapper.length;k++){
                            for(var j = k+1 ; j < skuWrapper.length; j++){
                                console.log('Update--SkuCode[k]-->'+skuCodeId[k].get("v.value"));
                                console.log('Update--SkuCode[j]-->'+skuCodeId[j].get("v.value"));
                                
                                if(skuCodeId[k].get("v.value") == skuCodeId[j].get("v.value")){
                                    component.set("v.isSkuDuplicate", true);
                                    isPriceBookvalid = false;
                                    isSalesDistvalid = false;                                   
                                }    
                            }
                        }
                        
                        for(var k = 0 ; k < skuWrapper.length; k++){ 
                            
                            if(getSkuAllId[k].get("v.value") == null || getSkuAllId[k].get("v.value") == ''){
                                
                                var err  = $A.get("{!$Label.c.MD_Required_Error}");
                                component.find("skuName")[k].set("v.errors",[{message:err}]);                    
                                isMaterialvalid = false;
                                isPriceBookvalid = false;
                                console.log('err'+err);
                                
                            }else{
                                component.find("skuName")[k].set("v.errors",null);
                            }
                            
                            if(getunitPriceId[k].get("v.value") == 0 || getunitPriceId[k].get("v.value") == null || getunitPriceId[k].get("v.value") == ''){
                                
                                var err  = $A.get("{!$Label.c.Not_Empty_Message}");
                                component.find("unitPrice")[k].set("v.errors",[{message:err}]); 
                                var toggleText = component.find("unitPrice")[k];                    
                                $A.util.addClass(toggleText, "error"); 
                                isMaterialvalid = false;
                                isPriceBookvalid = false;
                                
                            }else if(getunitPriceId[k].get("v.value") < 0){
                                
                                var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                                component.find("minPrice")[k].set("v.errors",[{message:err}]); 
                                var toggleText = component.find("minPrice")[k];                    
                                $A.util.addClass(toggleText, "error");
                                isMaterialvalid = false;
                                isPriceBookvalid = false;
                                
                            }else{
                                
                                component.find("unitPrice")[k].set("v.errors",null); 
                                var toggleText = component.find("unitPrice")[k];                    
                                $A.util.removeClass(toggleText, "error");
                            }
                            
                            if(getminPriceId[k].get("v.value") == null){
                                
                                var err  = $A.get("{!$Label.c.Not_Empty_Message}");
                                component.find("minPrice")[k].set("v.errors",[{message:err}]); 
                                var toggleText = component.find("minPrice")[k];                    
                                $A.util.addClass(toggleText, "error");
                                isMaterialvalid = false;
                                isPriceBookvalid = false;
                                
                            }else if(getminPriceId[k].get("v.value") < 0){
                                
                                var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                                component.find("minPrice")[k].set("v.errors",[{message:err}]); 
                                var toggleText = component.find("minPrice")[k];                    
                                $A.util.addClass(toggleText, "error");
                                isMaterialvalid = false;
                                isPriceBookvalid = false;
                                
                            }else{
                                component.find("minPrice")[k].set("v.errors",null); 
                                var toggleText = component.find("minPrice")[k];                    
                                $A.util.removeClass(toggleText, "error");
                            }
                            
                            var eraseUnitPrice = getunitPriceId[k].get("v.value");
                            var eraseMinPrice = getminPriceId[k].get("v.value");
                            if(eraseMinPrice != null || eraseMinPrice != ''){
                                if(  eraseUnitPrice < eraseMinPrice){ 
                                    //var err = '{!$Label.c.Unit_Should_be_Greater_than_Minimum}';
                                    var err  = $A.get("{!$Label.c.Unit_Should_be_Greater_than_Minimum}"); 
                                    component.find("unitPrice")[k].set("v.errors",[{message:err}]); 
                                    var toggleText = component.find("unitPrice")[k];                    
                                    $A.util.addClass(toggleText, "error");
                                    isMaterialvalid = false;
                                isPriceBookvalid = false;
                                }    
                            }
                            
                            if(getmonthRateAllId[k].get("v.value") == null){
                                var err  = $A.get("{!$Label.c.Not_Empty_Message}");
                                component.find("monthRate")[k].set("v.errors",[{message:err}]); 
                                var toggleText = component.find("monthRate")[k];                    
                                $A.util.addClass(toggleText, "error");
                                isMaterialvalid = false;
                                isPriceBookvalid = false;
                                
                            }else if(getmonthRateAllId[k].get("v.value") < 0){
                                var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                                component.find("monthRate")[k].set("v.errors",[{message:err}]); 
                                var toggleText = component.find("monthRate")[k];                    
                                $A.util.addClass(toggleText, "error");
                                isMaterialvalid = false;
                                isPriceBookvalid = false;
                                
                            }else{
                                component.find("monthRate")[k].set("v.errors",null); 
                                var toggleText = component.find("monthRate")[k];                    
                                $A.util.removeClass(toggleText, "error");
                                
                            }
                            var bothCurrValid = component.get("v.isBothCurrency");
                            if(bothCurrValid){
                                
                                if(alltexchangeRateId[k].get("v.value") == 0 ){
                                    var err  = $A.get("{!$Label.c.Not_Empty_Message}");
                                    component.find("exchangeRate")[k].set("v.errors",[{message:err}]); 
                                    var toggleText = component.find("exchangeRate")[k];                    
                                    $A.util.addClass(toggleText, "error");
                                    isMaterialvalid = false;
                                    isPriceBookvalid = false;
                                    
                                }else if(alltexchangeRateId[k].get("v.value") < 0){
                                    var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                                    component.find("exchangeRate")[k].set("v.errors",[{message:err}]); 
                                    var toggleText = component.find("exchangeRate")[k];                    
                                    $A.util.addClass(toggleText, "error");
                                    isMaterialvalid = false;
                                    isPriceBookvalid = false;
                                }else{
                                    component.find("exchangeRate")[k].set("v.errors",null); 
                                    var toggleText = component.find("exchangeRate")[k];                    
                                    $A.util.removeClass(toggleText, "error");
                                }
                            }
                        } 
                    }catch(error){
                        console.log('error-->'+error);
                    }
                }
            } 
        }
        if(isPriceBookvalid == true && isMaterialvalid == true && isSalesDistvalid == true){
            
            var BRLcurrency = 'BRL' ; 
            var USDcurrency = 'USD'; 
            var bothCurrncy = 'Both' ; 
            
            var newPriceBook = component.get("v.PriceBook");           
            var newSalesDist = component.get("v.salesdtarr");
            var newSkuWrap = component.get("v.wrappers");
            
            var validfromDate = component.get("v.myDate");
            var expiryDate = component.get("v.myDate1");
            var CurrName = component.find("currencyID"); 
            var currencyName = CurrName.get("v.value");
            var Division = component.find("HiddenDivisionName").get("v.value");
            
            if(currencyName == 'Only BRL'){
                currencyName = BRLcurrency;
            }else if(currencyName == 'Only USD'){
                currencyName = USDcurrency;
            }else if(currencyName == 'BRL and USD'){
                currencyName = bothCurrncy;
            }
            
            // Calling apex to save PriceList Record
            var action = component.get("c.clonePriceBookapex");
            
            action.setParams({ "arrOfSales" : JSON.stringify(newSalesDist),
                              "priceBookAsObj" : newPriceBook,
                              "skuList" : JSON.stringify(newSkuWrap),
                              "validfrm":validfromDate,
                              "expiryfrm":expiryDate,
                              "currencyName":currencyName,
                              "divName":Division
                             });
            component.set("v.showSpinner", true);
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state------'+state);
                
                if (state == "SUCCESS") {
                    
                    var recId = response.getReturnValue();
                    var pk = component.get("v.PriceBook");
                    component.set("v.PriceBook", pk);
                    component.set("v.PriceBook",{'sobjectType': 'Price_Book__c',
                                                 'Name':''
                                                });
                    component.set("v.PriceBookDivisionName",'');
                    component.set("v.myDate", null);
                    component.set("v.myDate1", null);
                    component.set("v.wrappers",null);
                    component.set("v.salesdtarr",null);
                    component.find("cloneSavebtn").set("v.disabled",true);
                    helper.showCloneToast(component);
                    helper.gotoListviewHelper(component); 
                    
                }else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } 
                }else{
                    console.log('Unknown error2');
                }
            });
            $A.enqueueAction(action);
        }
    },
    savePriceBookJs: function(component, event, helper){
        
        // Boolean var
        var isPriceBookvalid = true;
        var isSalesDistvalid = true ;
        var isMaterialvalid = true;
        
        var firstDtfalse = component.get("v.falseDate"); 
        var secondDtfalse = component.get("v.falseDate1");        
        var isEdit = component.get("v.isEdit");
        var bothCurrValid = component.get("v.isBothCurrency");
        //component.set("v.isSavebtnHide", false); 
        
        // PriceBook Name
        var nameField = component.find("priceBookName");
        var name = nameField.get("v.value");
        
        // valid from Date             
        var validfrmDt = component.get("v.myDate");
        
        // Expiry from Date
        var expiryDt = component.get("v.myDate1");
        
        // Division Name     
        var divName = component.find("DivisionName"); 
        var divActName = divName.get("v.value");
        
        // sales District     
        var arrOfSalesdist = component.get("v.salesdtarr"); 
        var skuWrapper = component.get("v.wrappers");
        
        // Name field validation
        if(nameField.get("v.value") == null || nameField.get("v.value") == ''){
            //var err = '{!$Label.c.Description_is_required}';
            var description  = $A.get("$Label.c.Description_is_required");
            nameField.set("v.errors",[{message:description}]);            
            isPriceBookvalid = false;
        }else{            
            nameField.set("v.errors",null);
        }
        
        // valid from date validation
        if(validfrmDt == null ){
            component.find("validfrmId").set("v.errors",[{message:"Valid date Required"}]);
            isPriceBookvalid = false;
        }else{
            component.find("validfrmId").set("v.errors",null);
        }
        
        //expiry date validaion
        if(expiryDt == null){
            component.find("expiryId").set("v.errors",[{message:"Expiry date Required"}]);
            isPriceBookvalid = false;
        }else{
            component.find("expiryId").set("v.errors",null); 
        }
        
        var Today = new Date();
        var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();
        var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
        var yyyy = Today.getFullYear();
        var today = (yyyy + "-" + MM + "-" + dd);
        if(validfrmDt < today){
            //var errMsg = '{!$Label.c.PD_ValidFromError}';
            var errMsg  = $A.get("{!$Label.c.PD_ValidFromError}");
            component.find("validfrmId").set("v.errors",[{message:errMsg}]);
            isPriceBookvalid = false;   
        }else{
            component.find("validfrmId").set("v.errors",null);
        }            
        
        if(expiryDt < today){ 
            //var err  = '{!$Label.c.PD_ExpiryError}';
            var err  = $A.get("{!$Label.c.PD_ExpiryError}");
            component.find("expiryId").set("v.errors",[{message:err}]);
            isPriceBookvalid = false;
        }else{
            component.find("expiryId").set("v.errors",null);
        }
        
        //validating division
        if(divName.get("v.value") == null ){
            //var err = '{!$Label.c.Division_required}';
            var err  = $A.get("{!$Label.c.Division_required}");
            divName.set("v.errors",[{message:err}]);
            isPriceBookvalid = false;
        }else{
            divName.set("v.errors",null);
        }
        
        // Primary Info is Correct i.e Price book object data 
        if(isPriceBookvalid){
            
            // validating sales district  
            if(arrOfSalesdist.length == 0 && isPriceBookvalid != false){
                component.set("v.isErrors", true);
                helper.applyCSS(component);
                isSalesDistvalid = false;
                
            }else if(arrOfSalesdist.length > 0){
                
                var duplicateval = component.get("v.showduplicateErr");
                var diverr = component.get("v.showErrOnDiv"); 
                
                for(var i = 0 ;i<arrOfSalesdist.length;i++){
                    for(var j = i+1 ;j<arrOfSalesdist.length;j++){
                        
                        var nameOfSD = arrOfSalesdist[i].Name;
                        if(typeof nameOfSD == "undefined"){
                            component.set("v.showErrOnDiv", true);
                            isSalesDistvalid = false;
                            isPriceBookvalid = false;
                        }else{
                            console.log('arrOfSalesdist[i].Name'+arrOfSalesdist[i].Name);
                            if(arrOfSalesdist[i].Name != null || arrOfSalesdist[i].Name != ''){
                                if(arrOfSalesdist[i].Name == arrOfSalesdist[j].Name){
                                    component.set("v.showduplicateErr", true);
                                    isPriceBookvalid = false;
                                    isSalesDistvalid = false;
                                }     
                            }
                        }
                    }
                }
                //alert('isPriceBookvalid1'+isPriceBookvalid);
                //alert('showduplicateErr-->'+duplicateval)
                //alert('showErrOnDiv-->'+diverr)
                if(!duplicateval){
                    for(var i = 0 ;i<arrOfSalesdist.length;i++){
                        if(arrOfSalesdist[i].Name == null){
                            component.set("v.showErrOnDiv", true);
                            isSalesDistvalid = false;
                            isPriceBookvalid = false;
                        }else{
                            component.set("v.showErrOnDiv", false);
                        }
                    }
                }
            }
            console.log('pricebook12-->'+isPriceBookvalid);
             console.log('skuWrapper.length-->'+skuWrapper.length);
             console.log('isSalesDistvalid-->'+isSalesDistvalid);
            // If No SKu is added 
            if(skuWrapper.length == 0 && isPriceBookvalid != false && isSalesDistvalid != false){
                
                component.set("v.isSKuErrors", true);
                component.set("v.showErrOnDiv", false);
                component.set("v.showduplicateErr", false);
                helper.applyCSS(component);
                isMaterialvalid = false;
                
            }
            console.log('pricebook100-->'+isPriceBookvalid);
            
            // If SKu is added
            if( skuWrapper.length > 0 ){
                
                var skusalesforceId = component.find("SkuCode");
                var skuCodeId = component.find("SkuCode1");
                var getSkuAllId = component.find("skuName");
                var getminPriceId = component.find("minPrice");
                var getunitPriceId = component.find("unitPrice");
                var getmonthRateAllId = component.find("monthRate");
                var alltexchangeRateId = component.find("exchangeRate");  
                 console.log('pricebook101-->'+isPriceBookvalid);
                var isArray = Array.isArray(getSkuAllId);
                
                if(!isArray){
                    
                    if(getSkuAllId.get("v.value") == null || getSkuAllId.get("v.value") == ''){
                       // var err = '{!$Label.c.MD_Required_Error}';
                        var err  = $A.get("{!$Label.c.MD_Required_Error}");
                        component.find("skuName").set("v.errors",[{message:err}]);                    
                        component.set("v.isMaterialReq",false);
                        isMaterialvalid = false;
                        isPriceBookvalid = false;
                        
                    }else{
                        component.find("skuName").set("v.errors",null);
                        //console.log('GETSKU-->'+isPriceBookvalid);
                    }
                    console.log('pricebook2-->'+isPriceBookvalid);
                    if(getminPriceId.get("v.value") == null ){
                        
                        //var err = '{!$Label.c.Not_Empty_Message}';
                        var err  = $A.get("{!$Label.c.Not_Empty_Message}");
                        component.find("minPrice").set("v.errors",[{message:err}]); 
                        var toggleText = component.find("minPrice");                    
                        $A.util.addClass(toggleText, "error");
                        isMaterialvalid = false;
                        isPriceBookvalid = false;
                        
                    }else if(getminPriceId.get("v.value") < 0){
                        
                        var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                        component.find("minPrice").set("v.errors",[{message:err}]); 
                        var toggleText = component.find("minPrice");                    
                        $A.util.addClass(toggleText, "error");
                        isMaterialvalid = false;
                        isPriceBookvalid = false; 
                        
                    }else{                        
                        
                        component.find("minPrice").set("v.errors",null); 
                        var toggleText = component.find("minPrice");                    
                        $A.util.removeClass(toggleText, "error");
                    }
                    
                    // validating Single SKU Unit Price
                    if(getunitPriceId.get("v.value") == 0 || getunitPriceId.get("v.value") == null || getunitPriceId.get("v.value") == ''){
                        
                        var err  = $A.get("{!$Label.c.Not_Empty_Message}");                        
                        component.find("unitPrice").set("v.errors",[{message:err}]); 
                        var toggleText = component.find("unitPrice");                    
                        $A.util.addClass(toggleText, "error");
                        isMaterialvalid = false;
                        isPriceBookvalid = false;
                        
                    }else if(getunitPriceId.get("v.value") < 0){
                        var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                        component.find("unitPrice").set("v.errors",[{message:err}]); 
                        var toggleText = component.find("unitPrice");                    
                        $A.util.addClass(toggleText, "error");
                        isMaterialvalid = false;
                        isPriceBookvalid = false; 
                        
                    }else{
                        component.find("unitPrice").set("v.errors",null); 
                        var toggleText = component.find("unitPrice");                    
                        $A.util.removeClass(toggleText, "error");
                    }
                    console.log('pricebook3-->'+isPriceBookvalid);
                    // Validation Minimun Price
                    var unitPricval = getunitPriceId.get("v.value");
                    var minPriceval = getminPriceId.get("v.value");
                    
                    
                    if(minPriceval != null || minPriceval != '' ){
                        if( unitPricval < minPriceval){ 
                             var err  = $A.get("{!$Label.c.Unit_Should_be_Greater_than_Minimum}");
                            component.find("unitPrice").set("v.errors",[{message:err}]); 
                            var toggleText = component.find("unitPrice");                    
                            $A.util.addClass(toggleText, "error");
                            isMaterialvalid = false;
                            isPriceBookvalid = false;
                            
                        }
                    }
                    
                    // validating Single SKU month Price
                    if(getmonthRateAllId.get("v.value") == null ){
                        
                        var err  = $A.get("{!$Label.c.Not_Empty_Message}");
                        component.find("monthRate").set("v.errors",[{message:err}]); 
                        var toggleText = component.find("monthRate");                    
                        $A.util.addClass(toggleText, "error");
                        isMaterialvalid = false;
                        isPriceBookvalid = false;
                    }else if(getmonthRateAllId.get("v.value") < 0){
                        var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                        component.find("monthRate").set("v.errors",[{message:err}]); 
                        var toggleText = component.find("monthRate");                    
                        $A.util.addClass(toggleText, "error");
                        isMaterialvalid = false;
                        isPriceBookvalid = false; 
                    }else{
                        component.find("monthRate").set("v.errors",null); 
                        var toggleText = component.find("monthRate");                    
                        $A.util.removeClass(toggleText, "error");
                    }
                    
                    // validating currency 
                    if(bothCurrValid){
                        
                        if(alltexchangeRateId.get("v.value") == 0 || alltexchangeRateId.get("v.value") == null || alltexchangeRateId.get("v.value") == ''){
                            var err  = $A.get("{!$Label.c.Not_Empty_Message}");
                            component.find("exchangeRate").set("v.errors",[{message:err}]); 
                            var toggleText = component.find("exchangeRate");                    
                            $A.util.addClass(toggleText, "error");
                            isMaterialvalid = false;
                            isPriceBookvalid = false;
                        }else if(alltexchangeRateId.get("v.value") < 0){
                            var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                            component.find("exchangeRate").set("v.errors",[{message:err}]); 
                            var toggleText = component.find("exchangeRate");                    
                            $A.util.addClass(toggleText, "error");
                            isMaterialvalid = false;
                            isPriceBookvalid = false; 
                        }else{
                            component.find("exchangeRate").set("v.errors",null); 
                            var toggleText = component.find("exchangeRate");                    
                            $A.util.removeClass(toggleText, "error");
                        }
                    }

                }else{ 
                    
                    try{
                        
                       
                        for(var k = 0 ;k < skuWrapper.length;k++){
                            for(var j = k+1 ; j < skuWrapper.length; j++){
                                
                               // console.log('SkuNmae-->'+getSkuAllId[k].get("v.value"));
                                
                                
                                if(skuCodeId[j].get("v.value") == skuCodeId[k].get("v.value")){
                                    
                                    component.set("v.isSkuDuplicate", true);
                                    //var err  = $A.get("{!$Label.c.Duplicate_Entries_Found_on_Material_List}");
                                    //component.find("skuName")[j].set("v.errors",[{message:err}]);
                                    isPriceBookvalid = false;
                                    isSalesDistvalid = false; 
                                    
                                }    
                            }
                        }
                        
                        for(var k = 0 ; k < skuWrapper.length; k++){ 
                            
                            if(getSkuAllId[k].get("v.value") == null || getSkuAllId[k].get("v.value") == ''){
                                var err  = $A.get("{!$Label.c.MD_Required_Error}");
                                component.find("skuName")[k].set("v.errors",[{message:err}]);                    
                                isMaterialvalid = false;
                                isPriceBookvalid = false;
                                console.log('err-->'+err);
                                
                            }else{
                                component.find("skuName")[k].set("v.errors",null);
                            }
                            
                            if(getunitPriceId[k].get("v.value") == 0 || getunitPriceId[k].get("v.value") == null || getunitPriceId[k].get("v.value") == ''){
                                var err  = $A.get("{!$Label.c.Not_Empty_Message}");
                                component.find("unitPrice")[k].set("v.errors",[{message:err}]); 
                                var toggleText = component.find("unitPrice")[k];                    
                                $A.util.addClass(toggleText, "error"); 
                                isMaterialvalid = false;
                                isPriceBookvalid = false;
                                
                            }else if(getunitPriceId[k].get("v.value") < 0){
                                var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                                component.find("minPrice")[k].set("v.errors",[{message:err}]); 
                                var toggleText = component.find("minPrice")[k];                    
                                $A.util.addClass(toggleText, "error");
                                isMaterialvalid = false;
                                isPriceBookvalid = false;
                                
                                
                            }else{
                                component.find("unitPrice")[k].set("v.errors",null); 
                                var toggleText = component.find("unitPrice")[k];                    
                                $A.util.removeClass(toggleText, "error");
                            }
                            
                            if(getminPriceId[k].get("v.value") == null){
                                var err  = $A.get("{!$Label.c.Not_Empty_Message}");
                                component.find("minPrice")[k].set("v.errors",[{message:err}]); 
                                var toggleText = component.find("minPrice")[k];                    
                                $A.util.addClass(toggleText, "error");
                                isMaterialvalid = false;
                                isPriceBookvalid = false;
                                
                            }else if(getminPriceId[k].get("v.value") < 0){
                                var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                                component.find("minPrice")[k].set("v.errors",[{message:err}]); 
                                var toggleText = component.find("minPrice")[k];                    
                                $A.util.addClass(toggleText, "error");
                                isMaterialvalid = false;
                                isPriceBookvalid = false;
                                
                            }else{
                                component.find("minPrice")[k].set("v.errors",null); 
                                var toggleText = component.find("minPrice")[k];                    
                                $A.util.removeClass(toggleText, "error");
                            }
                            
                            var eraseUnitPrice = getunitPriceId[k].get("v.value");
                            var eraseMinPrice = getminPriceId[k].get("v.value");
                            if(eraseMinPrice != null || eraseMinPrice != ''){
                                if(  eraseUnitPrice < eraseMinPrice){ 
                                    //var err = '{!$Label.c.Unit_Should_be_Greater_than_Minimum}';
                                    var err  = $A.get("{!$Label.c.Unit_Should_be_Greater_than_Minimum}"); 
                                    component.find("unitPrice")[k].set("v.errors",[{message:err}]); 
                                    var toggleText = component.find("unitPrice")[k];                    
                                    $A.util.addClass(toggleText, "error");
                                    isMaterialvalid = false;
                                    isPriceBookvalid = false;
                                }    
                            }
                            
                            if(getmonthRateAllId[k].get("v.value") == null){
                                var err  = $A.get("{!$Label.c.Not_Empty_Message}");
                                component.find("monthRate")[k].set("v.errors",[{message:err}]); 
                                var toggleText = component.find("monthRate")[k];                    
                                $A.util.addClass(toggleText, "error");
                                isMaterialvalid = false;
                                isPriceBookvalid = false;
                                
                            }else if(getmonthRateAllId[k].get("v.value") < 0){
                                var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                                component.find("monthRate")[k].set("v.errors",[{message:err}]); 
                                var toggleText = component.find("monthRate")[k];                    
                                $A.util.addClass(toggleText, "error");
                                isMaterialvalid = false;
                                isPriceBookvalid = false;
                                
                            }else{
                                component.find("monthRate")[k].set("v.errors",null); 
                                var toggleText = component.find("monthRate")[k];                    
                                $A.util.removeClass(toggleText, "error");
                                
                            }
                            var bothCurrValid = component.get("v.isBothCurrency");
                            if(bothCurrValid){
                                
                                if(alltexchangeRateId[k].get("v.value") == 0 ){
                                    var err  = $A.get("{!$Label.c.Not_Empty_Message}");
                                    component.find("exchangeRate")[k].set("v.errors",[{message:err}]); 
                                    var toggleText = component.find("exchangeRate")[k];                    
                                    $A.util.addClass(toggleText, "error");
                                    isMaterialvalid = false;
                                    isPriceBookvalid = false;
                                    
                                }else if(alltexchangeRateId[k].get("v.value") < 0){
                                    var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                                    component.find("exchangeRate")[k].set("v.errors",[{message:err}]); 
                                    var toggleText = component.find("exchangeRate")[k];                    
                                    $A.util.addClass(toggleText, "error");
                                    isMaterialvalid = false;
                                    isPriceBookvalid = false;
                                }else{
                                    component.find("exchangeRate")[k].set("v.errors",null); 
                                    var toggleText = component.find("exchangeRate")[k];                    
                                    $A.util.removeClass(toggleText, "error");
                                }
                            }
                        } 
                        
                    }catch(error){
                        console.log('error-->'+error);
                    }
                }
            }
            if(firstDtfalse == false){
                isPriceBookvalid = false;
            }
            if(secondDtfalse == false){
                isPriceBookvalid = false;
            }    
        }
        
       // alert('isPriceBookvalid-->'+isPriceBookvalid);
       // alert('isMaterialvalid-->'+isMaterialvalid);
       // alert('isSalesDistvalid-->'+isSalesDistvalid);
        
        // Price Book and sales district and Material is true
        if(isPriceBookvalid == true && isMaterialvalid == true && isSalesDistvalid == true){
            
            var BRLcurrency = 'BRL' ; 
            var USDcurrency = 'USD'; 
            var bothCurrncy = 'Both' ; 
            
            var newPriceBook = component.get("v.PriceBook");           
            var newSalesDist = component.get("v.salesdtarr");
            var newSkuWrap = component.get("v.wrappers");
            var validfromDate = component.get("v.myDate");
            var expiryDate = component.get("v.myDate1");
            var CurrName = component.find("currencyID"); 
            var currencyName = CurrName.get("v.value");
            
            if(currencyName == 'Only BRL'){
                currencyName = BRLcurrency;
            }else if(currencyName == 'Only USD'){
                currencyName = USDcurrency;
            }else if(currencyName == 'BRL and USD'){
                currencyName = bothCurrncy;
            }
            
            component.set("v.showSpinner", true);
            // Calling apex to save PriceList Record
            var action = component.get("c.savePriceBookapex");
            
            action.setParams({ "arrOfSales" : JSON.stringify(newSalesDist),
                              "priceBookAsObj" : newPriceBook,
                              "skuList" : JSON.stringify(newSkuWrap),
                              "validfrm":validfromDate,
                              "expiryfrm":expiryDate,
                              "currencyName":currencyName
                             });
            
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state------'+state);
                
                if (state == "SUCCESS") {
                    
                    var recId = response.getReturnValue();
                    var pk = component.get("v.PriceBook");
                    component.set("v.PriceBook", pk);
                    component.set("v.PriceBook",{'sobjectType': 'Price_Book__c',
                                                 'Name':''
                                                });
                    
                    component.set("v.PriceBookDivisionName",'');
                    component.set("v.myDate", null);
                    component.set("v.myDate1", null);
                    component.set("v.wrappers",null);
                    component.set("v.salesdtarr",null);
                    
                    var editVal =  component.get("v.isbtndisable");
                    if(editVal){
                        component.find("updateBtn").set("v.disabled",true);
                        component.find("clonebtn").set("v.disabled",true);
                        var toastEvent = $A.get("e.force:showToast");
                        var successMsg  = $A.get("{!$Label.c.Price_Book_Updated_Successfully}");
                        var successMsg1  = $A.get("{!$Label.c.Success}");
                         //var successMsg = '{!$Label.c.Price_Book_Updated_Successfully}';
                        toastEvent.setParams({
                            "title": successMsg1,
                            "type": "Success",
                            "message": successMsg
                        });
                        toastEvent.fire();
                        helper.gotoListviewHelper(component);
                    }else{
                        //alert('test');
                        //component.find("mainSavebtn").set("v.disabled",true);
                       var successMsg  = $A.get("{!$Label.c.Price_Book_Created_Successfully}"); 
                        var successMsg1 = $A.get("{!$Label.c.Success}");
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": successMsg1,
                            "type": "Success",
                            "message": successMsg
                        });
                        toastEvent.fire();
                        helper.gotoListviewHelper(component);
                    }
                    
                    
                }else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } 
                }else{
                    console.log('Unknown error2');
                }
            });
            $A.enqueueAction(action);
        }
    }, 
    validateunitPrice:function(component, event, helper){
      	try{
                var target = event.getSource(); 
            	var unitQty = target.get("v.value");
            	var whichOne = event.getSource().getLocalId();
                var skuwrap = component.get('v.wrappers');
           		var indexvar = event.getSource().get("v.size");
            	var getunitPriceId = component.find("unitPrice");
                var getminPriceId = component.find("minPrice");
            	var getmonthRateAllId = component.find("monthRate");
                var alltexchangeRateId = component.find("exchangeRate");
            	//alert('whichOne-->'+whichOne);
				if(skuwrap.length > 0){
                    
                    var isArray = Array.isArray(getunitPriceId);
                    
                    if(!isArray){                        
                        if(whichOne == "minPrice"){                   
                            // getminPriceId.get("v.value") == null
                            if(getminPriceId.get("v.value") == null ){ 
                                
                                 //var err = '{!$Label.c.Not_Empty_Message}';
                                 var err  = $A.get("{!$Label.c.Not_Empty_Message}"); 
                                component.find("minPrice").set("v.errors",[{message:err}]); 
                                var toggleText = component.find("minPrice");                    
                                $A.util.addClass(toggleText, "error");
                                
                            }else if(getminPriceId.get("v.value") < 0){
                                var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                                component.find("minPrice").set("v.errors",[{message:err}]); 
                                var toggleText = component.find("minPrice");                    
                                $A.util.addClass(toggleText, "error");
                                
                            }else{
                                component.find("minPrice").set("v.errors",null); 
                                var toggleText = component.find("minPrice");                    
                                $A.util.removeClass(toggleText, "error");
                            }
                        }
                        
                        if(whichOne == "unitPrice"){
                            
                            //getunitPriceId.get("v.value") == 0 || getunitPriceId.get("v.value") == null || getunitPriceId.get("v.value") == ''
                            if(getunitPriceId.get("v.value") == null){
                                var err  = $A.get("{!$Label.c.Not_Empty_Message}"); 
                                component.find("unitPrice").set("v.errors",[{message:err}]); 
                                var toggleText = component.find("unitPrice");                    
                                $A.util.addClass(toggleText, "error");                               
                                
                            }else if(getunitPriceId.get("v.value") < 0){
                                
                                component.find("minPrice").set("v.errors",[{message:err}]); 
                                var toggleText = component.find("minPrice");                    
                                $A.util.addClass(toggleText, "error");
                                
                            }else{
                                component.find("unitPrice").set("v.errors",null); 
                                var toggleText = component.find("unitPrice");                    
                                $A.util.removeClass(toggleText, "error");
                            }
                            
                            // Validation Minimun Price
                            var unitPricval = getunitPriceId.get("v.value");
                            var minPriceval = getminPriceId.get("v.value");
                            if(minPriceval != null || minPriceval != '' ){
                                if( unitPricval < minPriceval){
                                    var err  = $A.get("{!$Label.c.Unit_Should_be_Greater_than_Minimum}"); 
                                    //var err = '{!$Label.c.Unit_Should_be_Greater_than_Minimum}';
                                    component.find("unitPrice").set("v.errors",[{message:err}]); 
                                    var toggleText = component.find("unitPrice");                    
                                    $A.util.addClass(toggleText, "error"); 
                                    isMaterialvalid = false;
                                    isPriceBookvalid = false; 
                                }
                            }
                        }
                                                
                        if(whichOne == "monthRate"){
                            
                            if(getmonthRateAllId.get("v.value") == null){
                                
                                var err  = $A.get("{!$Label.c.Not_Empty_Message}"); 
                                //var err = '{!$Label.c.Not_Empty_Message}';
                                component.find("monthRate").set("v.errors",[{message:err}]); 
                                var toggleText = component.find("monthRate");                    
                                $A.util.addClass(toggleText, "error");   
                                isMaterialvalid = false;
                                isPriceBookvalid = false; 
                                
                            }else if(getmonthRateAllId.get("v.value") < 0){
                                var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                                component.find("monthRate").set("v.errors",[{message:err}]); 
                                var toggleText = component.find("monthRate");                    
                                $A.util.addClass(toggleText, "error");
                            }else{
                                component.find("monthRate").set("v.errors",null); 
                                var toggleText = component.find("monthRate");                    
                                $A.util.removeClass(toggleText, "error");
                            }
                        }
                        
                        var bothCurrValid = component.get("v.isBothCurrency");
                        if(whichOne == "exchangeRate"){
                            
                            if(bothCurrValid){
                                if(alltexchangeRateId.get("v.value") == 0 || alltexchangeRateId.get("v.value") == null || alltexchangeRateId.get("v.value") == ''){
                                    // var err = '{!$Label.c.Not_Empty_Message}';
                                     var err  = $A.get("{!$Label.c.Not_Empty_Message}"); 
                                    component.find("exchangeRate").set("v.errors",[{message:err}]); 
                                    var toggleText = component.find("exchangeRate");                    
                                    $A.util.addClass(toggleText, "error");
                                    isMaterialvalid = false;
                                    isPriceBookvalid = false;
                                }else if(alltexchangeRateId.get("v.value") < 0){
                                    var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                                    component.find("exchangeRate").set("v.errors",[{message:err}]); 
                                    var toggleText = component.find("exchangeRate");                    
                                    $A.util.addClass(toggleText, "error");
                                    isMaterialvalid = false;
                                    isPriceBookvalid = false; 
                                }else{
                                    component.find("exchangeRate").set("v.errors",null); 
                                    var toggleText = component.find("exchangeRate");                    
                                    $A.util.removeClass(toggleText, "error");
                                }
                            }
                        }
                        
                    }
                    
                    if(isArray){
                        console.log('isArray-->'+isArray);
                        for(var k = 0 ; k < skuwrap.length; k++){ 
                            
                            if(indexvar == k){
                                
                                 if(whichOne == "minPrice"){
                                    
                                    console.log('isArray-->'+whichOne);
                                    if(getminPriceId[k].get("v.value") == null){
                                         //var err = '{!$Label.c.Not_Empty_Message}';
                                        var err  = $A.get("{!$Label.c.Not_Empty_Message}"); 
                                        component.find("minPrice")[k].set("v.errors",[{message:err}]); 
                                        var toggleText = component.find("minPrice")[k];                    
                                        $A.util.addClass(toggleText, "error");
                                        
                                    }else if(getminPriceId[k].get("v.value") < 0){
                                        var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                                        component.find("minPrice")[k].set("v.errors",[{message:err}]); 
                                        var toggleText = component.find("minPrice")[k];                    
                                        $A.util.addClass(toggleText, "error");
                                        
                                    }else{
                                        component.find("minPrice")[k].set("v.errors",null); 
                                        var toggleText = component.find("minPrice")[k];                    
                                        $A.util.removeClass(toggleText, "error");
                                    }
                                    
                                    
                                }
                                if(whichOne == "unitPrice"){
                                    
                                    if(getunitPriceId[k].get("v.value") == 0 || getunitPriceId[k].get("v.value") == null || getunitPriceId[k].get("v.value") == ''){
                                       
                                        // var err = '{!$Label.c.Not_Empty_Message}';
                                        var err  = $A.get("{!$Label.c.Not_Empty_Message}"); 
                                        component.find("unitPrice")[k].set("v.errors",[{message:err}]); 
                                        var toggleText = component.find("unitPrice")[k];                    
                                        $A.util.addClass(toggleText, "error");                               
                                        
                                    }else if(getunitPriceId[k].get("v.value") < 0){
                                        
                                        var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                                        component.find("minPrice")[k].set("v.errors",[{message:err}]); 
                                        var toggleText = component.find("minPrice")[k];                    
                                        $A.util.addClass(toggleText, "error");
                                        
                                    }else{
                                        component.find("unitPrice")[k].set("v.errors",null); 
                                        var toggleText = component.find("unitPrice")[k];                    
                                        $A.util.removeClass(toggleText, "error");
                                    }
                                    var eraseUnitPrice = getunitPriceId[k].get("v.value");
                                    var eraseMinPrice = getminPriceId[k].get("v.value");
                                    if(eraseMinPrice != null || eraseMinPrice != ''){
                                        if(  eraseUnitPrice < eraseMinPrice){ 
                                             //var err = '{!$Label.c.Unit_Should_be_Greater_than_Minimum}';
                                            var err  = $A.get("{!$Label.c.Unit_Should_be_Greater_than_Minimum}"); 
                                            component.find("unitPrice")[k].set("v.errors",[{message:err}]); 
                                            var toggleText = component.find("unitPrice")[k];                    
                                            $A.util.addClass(toggleText, "error");
                                        }    
                                    }
                                    
                                }
                                if(whichOne == "monthRate"){
                                    if(getmonthRateAllId[k].get("v.value") == null){
                                        // var err = '{!$Label.c.Not_Empty_Message}';
                                        var err  = $A.get("{!$Label.c.Not_Empty_Message}"); 
                                        component.find("monthRate")[k].set("v.errors",[{message:err}]); 
                                        var toggleText = component.find("monthRate")[k];                    
                                        $A.util.addClass(toggleText, "error");
                                        
                                    }else if(getmonthRateAllId[k].get("v.value") < 0){
                                        var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                                        component.find("monthRate")[k].set("v.errors",[{message:err}]); 
                                        var toggleText = component.find("monthRate")[k];                    
                                        $A.util.addClass(toggleText, "error");
                                        
                                    }else{
                                        component.find("monthRate")[k].set("v.errors",null); 
                                        var toggleText = component.find("monthRate")[k];                    
                                        $A.util.removeClass(toggleText, "error");
                                        
                                    }
                                }
                                var bothCurrValid = component.get("v.isBothCurrency");
                                if(whichOne == "exchangeRate"){
                                    if(bothCurrValid){
                                        
                                        if(alltexchangeRateId[k].get("v.value") == 0 ){
                                           // var err = '{!$Label.c.Not_Empty_Message}';
                                            var err  = $A.get("{!$Label.c.Not_Empty_Message}"); 
                                            component.find("exchangeRate")[k].set("v.errors",[{message:err}]); 
                                            var toggleText = component.find("exchangeRate")[k];                    
                                            $A.util.addClass(toggleText, "error");
                                            
                                        }else if(alltexchangeRateId[k].get("v.value") < 0){
                                            var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                                            component.find("exchangeRate")[k].set("v.errors",[{message:err}]); 
                                            var toggleText = component.find("exchangeRate")[k];                    
                                            $A.util.addClass(toggleText, "error");
                                        }else{
                                            component.find("exchangeRate")[k].set("v.errors",null); 
                                            var toggleText = component.find("exchangeRate")[k];                    
                                            $A.util.removeClass(toggleText, "error");
                                        }
                                    }
                                }
                                
                            }
                        } 
                    }
                        
                }
            
            }catch(error){
                //alert('Error-->'+error);
                console.log('Error-->'+error);
            }
       
    },
    addSalesDist : function(component, event, helper){        
        try{
            var sd = component.get("v.salesdtarr");
            sd.push({
                'Id':'',
                'sdtId':'',
                'sdtNameforSales':''
            });
            component.set("v.salesdtarr",sd);
            
            helper.goDown(component);   
        }catch(error){
            console.log('error-->'+error);
        }   
    },
    addSkuList : function(component, event, helper){
        
        var isDivExists = true;
        var blockToaddRow = true;
        var skuwrap = component.get('v.wrappers');
        var isEdit = component.get("v.isEdit");
        var isCloneVar = component.get("v.isClone");
        
        if(skuwrap.length>0){
            
            for(var j=0;j<skuwrap.length;j++){
               // alert('Test-->'+skuwrap[j].Name);
                if(skuwrap[j].Name == null || skuwrap[j].Name == ''){
                    blockToaddRow = false;
                    var addrowMSg = $A.get('{!$Label.c.Select_material_to_add_new_row}');
                    var ErrorMsg = $A.get('{!$Label.c.Error}');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": ErrorMsg,
                        "type": "error",
                        "message": addrowMSg
                    });
                    toastEvent.fire();
                }
            }
        }
        if(blockToaddRow){
            
            var divName = component.find("DivisionName"); 
            var divActName = divName.get("v.value");
            if(divName.get("v.value") == null ){
                isDivExists = false;
            }
            
            if(isDivExists){
                var wrappers1 = component.get('v.wrappers');
                var wrappers2 = component.get('v.wrappers');
                var wrapper = {
                    'Name' :'',
                    'SkuDes':'',
                    'unitPrice': 0,
                    'monthlyIntRate':0,
                    'minPrice':0,
                    'exchangeRate':0  
                };
                wrappers1.push(wrapper);
                component.set('v.wrappers', wrappers1);
                component.find("searchUtil").set("v.disabled",true);
                
            }else{
                if(divName.get("v.value") == null ){
                    helper.showErrorToast(component);
                }
            }
        }
        helper.goDown(component);
    },
    openSDModel: function(component, event, helper){
        try{
            
            var target = event.getSource();  
            var rowIndexValue = target.get("v.value");            
            component.set("v.rowIndex",rowIndexValue);
            helper.fetchSalesDistrict(component);
            component.set("v.isOpen", true);
            helper.applyCSS(component);
            
        }catch(error){
            console.log('error-->'+error);
        }
    },
    openDivModel: function(component, event, helper){
        
        helper.fetchDivision(component);
        component.set("v.isOpen2", true);
        helper.applyCSS(component);
        
        
    },
    openSkuModal: function(component, event, helper){
        
        var target = event.getSource();  
        var rowIndexValue = target.get("v.value");
        component.set("v.rowIndex",rowIndexValue);
        helper.fetchSku(component);
        component.set("v.isOpen3", true);
        helper.applyCSS(component);
    },
    closeModel: function(component, event, helper){
        component.set("v.isOpen", false);
        component.set("v.isOpen2", false);
        helper.revertCssChange(component);
    },
    closeSkuModel: function(component, event, helper){        
        component.set("v.isOpen3", false);
        helper.revertCssChange(component);
    },
    closeErrorModel :function(component, event, helper){        
        component.set("v.isErrors", false);
        component.set("v.isSKuErrors", false);
        helper.revertCssChange(component);
        
    },
    handleRemoveSalesDist : function(component, event, helper){
        var target = event.getSource();  
        var index = target.get("v.value");
        helper.removeSalesDist(component, index);
        
    },
    handleRemoveSku : function(component, event, helper){
        
        var target = event.getSource();  
        var index = target.get("v.value");
        helper.removeSku(component, index);
    },
    tabActionClicked: function(component, event, helper){
        
        var actionId = event.getParam('actionId');
        var lstofSldt = [];
        
        //Division
        if(actionId == 'selectDivision' ){
            
            //get the row where click happened and its position
            var rowIdx = event.getParam("index");
            var divRow = event.getParam('row');
            component.set("v.PriceBookDivisionName",divRow.Name);
            component.find("HiddenDivisionName").set("v.value", divRow.Id);
            component.set("v.isOpen2", false);
            helper.revertCssChange(component);
            
        }
        // Product
        if(actionId == 'selectSku' ){
            
            //get the row where click happened and its position
            var rowIdx = event.getParam("index");
            var skuRow = event.getParam('row');
            var rowIndex = component.get("v.rowIndex");
            var skuArray = component.get("v.wrappers");            
            for (var idx=0; idx<skuArray.length; idx++) {
                if (idx==rowIndex) {                    
                    try{
                        
                        skuArray[idx].skuId=skuRow.Id;
                        skuArray[idx].SkuCode=skuRow.SKU_Code__c;
                        skuArray[idx].Name=skuRow.Name;
                        skuArray[idx].SkuDes =skuRow.SKU_Description__c;
                    }catch(e){
                        console.log('Error-->'+e);
                    }
                    
                }
            }
            component.set('v.wrappers', skuArray);
            component.set("v.isOpen3", false);
            helper.revertCssChange(component);
        }
        
        //Sales District
        if(actionId == 'salectDist'){
            
            var rowIdx = event.getParam("index");
            var Salesdist = event.getParam('row');
            var rowIndex = component.get("v.rowIndex");
            var salesDistList = component.get("v.salesdtarr");
            for (var idx=0; idx<salesDistList.length; idx++) {
                if (idx==rowIndex) {
                    salesDistList[idx].sdtId = Salesdist.Id;                   
                    salesDistList[idx].Name = Salesdist.Name;
                    salesDistList[idx].SDCode = Salesdist.RegionCode__c;
                } 
            }
            component.set('v.salesdtarr', salesDistList);
            component.set("v.isOpen",false);
            helper.revertCssChange(component);           
        }
    },
    applyCSS: function(component){
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:0} .forceStyle.desktop .viewport{overflow:hidden}");
    },
    revertCssChange: function(component){
       // alert('2000');
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:5} .forceStyle.desktop .viewport{overflow:visible}");
    },
    gotoListview : function (component, event, helper){
        helper.gotoListviewHelper(component);
    },
    closeDupCheck: function (component, event, helper){
        component.set("v.isSkuDuplicate", false);
        helper.revertCssChange(component);
    },
    // kept it for Testing purpose
    savePriceBookJsTestFunc: function(component, event, helper){
        
        // Boolean var
        var isPriceBookvalid = true;
        var isSalesDistvalid = true ;
        var isMaterialvalid = true;
        var firstDtfalse = component.get("v.falseDate"); 
        var secondDtfalse = component.get("v.falseDate1");        
        var isEdit = component.get("v.isEdit");
        var bothCurrValid = component.get("v.isBothCurrency");
        //component.set("v.isSavebtnHide", false); 
        
        // PriceBook Name
        var nameField = component.find("priceBookName");
        var name = nameField.get("v.value");
        
        // valid from Date             
        var validfrmDt = component.get("v.myDate");
        
        // Expiry from Date
        var expiryDt = component.get("v.myDate1");
        
        // Division Name     
        var divName = component.find("DivisionName"); 
        var divActName = divName.get("v.value");
        
        // sales District     
        var arrOfSalesdist = component.get("v.salesdtarr"); 
        var skuWrapper = component.get("v.wrappers");
        
        // Name field validation
        if(nameField.get("v.value") == null || nameField.get("v.value") == ''){
            //var description =  "{!$Label.c.Description_is_required}";
            
            var description  = $A.get("$Label.c.Description_is_required");
            //alert(description);
            nameField.set("v.errors",[{message:description}]);
            
            isPriceBookvalid = false;
        }else{            
            nameField.set("v.errors",null);
        }
        
        // valid from date validation
        if(validfrmDt == null ){
            component.find("validfrmId").set("v.errors",[{message:"Valid date Required"}]);
            isPriceBookvalid = false;
        }else{
            component.find("validfrmId").set("v.errors",null);
        }
        
        //expiry date validaion
        if(expiryDt == null){
            component.find("expiryId").set("v.errors",[{message:"Expiry date Required"}]);
            isPriceBookvalid = false;
        }else{
            component.find("expiryId").set("v.errors",null); 
        }
        
        var Today = new Date();
        var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();
        var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
        var yyyy = Today.getFullYear();
        var today = (yyyy + "-" + MM + "-" + dd);
        if(validfrmDt < today){
            // var validfrmErr =  '{!$Label.c.PD_ValidFromError}';
            var validfrmErr  = $A.get("{!$Label.c.PD_ValidFromError}"); 
            component.find("validfrmId").set("v.errors",[{message:validfrmErr}]);
            isPriceBookvalid = false;   
        }else{
            component.find("validfrmId").set("v.errors",null);
        }            
        
        if(expiryDt < validfrmDt){
            // var expfrmErr =  '{!$Label.c.PD_ExpiryError}'; 
            var expfrmErr  = $A.get("{!$Label.c.PD_ExpiryError}");
            component.find("expiryId").set("v.errors",[{message:expfrmErr}]);
            isPriceBookvalid = false;
        }else{
            component.find("expiryId").set("v.errors",null);
        }
        
        //validating division
        if(divName.get("v.value") == null ){
            var divErr  = $A.get("{!$Label.c.Division_required}");
            //var divErr =  '{!$Label.c.Division_required}';  
            divName.set("v.errors",[{message:divErr}]);
            isPriceBookvalid = false;
        }else{
            divName.set("v.errors",null);
        }
        
        // Primary Info is Correct i.e Price book object data 
        if(isPriceBookvalid){
            
            // validating sales district  
            if(arrOfSalesdist.length == 0 && isPriceBookvalid != false){
                component.set("v.isErrors", true);
                helper.applyCSS(component);
                isSalesDistvalid = false;
                
            }else if(arrOfSalesdist.length > 0){
               
                //var diverror = component.find("v.showErrOnDiv"); 
                //alert('diverror-->'+diverror);
                
                for(var i = 0 ;i<arrOfSalesdist.length;i++){
                    for(var j = i+1 ;j<arrOfSalesdist.length;j++){
                        if(arrOfSalesdist[i].Name != null || arrOfSalesdist[i].Name != ''){
                            //if(!showErrOnDiv){
                              //console.log('arrOfSalesdist[i].Name---->'+arrOfSalesdist[i].Name);
                                if(arrOfSalesdist[i].Name == arrOfSalesdist[j].Name){
                                    
                                    component.set("v.showduplicateErr", true);
                                    isPriceBookvalid = false;
                                    isSalesDistvalid = false;
                                }    
                            //}    
                        }  
                    }
                }
                
                for(var i = 0 ;i<arrOfSalesdist.length;i++){
                    if(arrOfSalesdist[i].Name == null){
                        component.set("v.showErrOnDiv", true);
                        isSalesDistvalid = false;
                        isPriceBookvalid = false;
                    }else{
                        component.set("v.showErrOnDiv", false);
                    }
                }
            }
            // If No SKu is added 
            if(skuWrapper.length == 0 && isPriceBookvalid != false && isSalesDistvalid != false){
                
                component.set("v.isSKuErrors", true);
                component.set("v.showErrOnDiv", false);
                component.set("v.showduplicateErr", false);
                helper.applyCSS(component);
                isMaterialvalid = false;
            }
            // If SKu is added
            if( skuWrapper.length > 0 ){
                
                var getSkuAllId = component.find("skuName");
                var getminPriceId = component.find("minPrice");
                var getunitPriceId = component.find("unitPrice");
                var getmonthRateAllId = component.find("monthRate");
                var alltexchangeRateId = component.find("exchangeRate");           
                
                var isArray = Array.isArray(getSkuAllId);
                
                if(!isArray){
                    
                        if(getSkuAllId.get("v.value") == null || getSkuAllId.get("v.value") == ''){
                            var matreq  = $A.get("{!$Label.c.MD_Required_Error}");
                            component.find("skuName").set("v.errors",[{message:matreq}]);                    
                            component.set("v.isMaterialReq",false);
                            isMaterialvalid = false;
                            isPriceBookvalid = false;
                            
                        }else{
                            component.find("skuName").set("v.errors",null);
                        }
                    
                        if(getminPriceId.get("v.value") == null ){
                            // var err = '{!$Label.c.Not_Empty_Message}';
                            var err  = $A.get("{!$Label.c.Not_Empty_Message}");
                            component.find("minPrice").set("v.errors",[{message:err}]); 
                            var toggleText = component.find("minPrice");                    
                            $A.util.addClass(toggleText, "error");
                            isMaterialvalid = false;
                            isPriceBookvalid = false;
                            
                        }else if(getminPriceId.get("v.value") < 0){
                            var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                            component.find("minPrice").set("v.errors",[{message:err}]); 
                            var toggleText = component.find("minPrice");                    
                            $A.util.addClass(toggleText, "error");
                            isMaterialvalid = false;
                            isPriceBookvalid = false; 
                            
                        }else{
                            
                            component.find("minPrice").set("v.errors",null); 
                            var toggleText = component.find("minPrice");                    
                            $A.util.removeClass(toggleText, "error");
                        }
                        
                        // validating Single SKU Unit Price
                        if(getunitPriceId.get("v.value") == 0 || getunitPriceId.get("v.value") == null || getunitPriceId.get("v.value") == ''){
                            //var err = '{!$Label.c.Not_Empty_Message}';
                            var err  = $A.get("{!$Label.c.Not_Empty_Message}");
                            component.find("unitPrice").set("v.errors",[{message:err}]); 
                            var toggleText = component.find("unitPrice");                    
                            $A.util.addClass(toggleText, "error");
                            isMaterialvalid = false;
                            isPriceBookvalid = false;
                            
                        }else if(getunitPriceId.get("v.value") < 0){
                            var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                            component.find("unitPrice").set("v.errors",[{message:err}]); 
                            var toggleText = component.find("unitPrice");                    
                            $A.util.addClass(toggleText, "error");
                            isMaterialvalid = false;
                            isPriceBookvalid = false; 
                            
                        }else{
                            component.find("unitPrice").set("v.errors",null); 
                            var toggleText = component.find("unitPrice");                    
                            $A.util.removeClass(toggleText, "error");
                        }
                        
                        // Validation Minimun Price
                        var unitPricval = getunitPriceId.get("v.value");
                        var minPriceval = getminPriceId.get("v.value");
                        if(minPriceval != null || minPriceval != '' ){
                            if( unitPricval < minPriceval){
                                // var err = '{!$Label.c.Unit_Should_be_Greater_than_Minimum}';
                                var err  = $A.get("{!$Label.c.Unit_Should_be_Greater_than_Minimum}");
                                component.find("unitPrice").set("v.errors",[{message:err}]); 
                                var toggleText = component.find("unitPrice");                    
                                $A.util.addClass(toggleText, "error");
                                isMaterialvalid = false;
                                isPriceBookvalid = false;
                                
                            }
                        }
                        
                        // validating Single SKU month Price
                        if(getmonthRateAllId.get("v.value") == null ){
                           // var err = '{!$Label.c.Not_Empty_Message}';
                            var err  = $A.get("{!$Label.c.Not_Empty_Message}");
                            component.find("monthRate").set("v.errors",[{message:err}]); 
                            var toggleText = component.find("monthRate");                    
                            $A.util.addClass(toggleText, "error");
                            isMaterialvalid = false;
                            isPriceBookvalid = false;
                        }else if(getmonthRateAllId.get("v.value") < 0){
                            var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                            component.find("monthRate").set("v.errors",[{message:err}]); 
                            var toggleText = component.find("monthRate");                    
                            $A.util.addClass(toggleText, "error");
                            isMaterialvalid = false;
                            isPriceBookvalid = false; 
                        }else{
                            component.find("monthRate").set("v.errors",null); 
                            var toggleText = component.find("monthRate");                    
                            $A.util.removeClass(toggleText, "error");
                        }
                    
                    // validating currency 
                    if(bothCurrValid){
                        
                        if(alltexchangeRateId.get("v.value") == 0 || alltexchangeRateId.get("v.value") == null || alltexchangeRateId.get("v.value") == ''){
                          
                            var err  = $A.get("{!$Label.c.Not_Empty_Message}");
                            component.find("exchangeRate").set("v.errors",[{message:err}]); 
                            var toggleText = component.find("exchangeRate");                    
                            $A.util.addClass(toggleText, "error");
                            isMaterialvalid = false;
                            isPriceBookvalid = false;
                        }else if(alltexchangeRateId.get("v.value") < 0){
                            var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                            component.find("exchangeRate").set("v.errors",[{message:err}]); 
                            var toggleText = component.find("exchangeRate");                    
                            $A.util.addClass(toggleText, "error");
                            isMaterialvalid = false;
                            isPriceBookvalid = false; 
                        }else{
                            component.find("exchangeRate").set("v.errors",null); 
                            var toggleText = component.find("exchangeRate");                    
                            $A.util.removeClass(toggleText, "error");
                        }
                    }
                	}else{               
                   
                        
                        try{
                            for(var k = 0 ; k < skuwrap.length; k++){ 
                            
                            if(indexvar == k){
                                
                                
                                if(getunitPriceId[k].get("v.value") == 0 || getunitPriceId[k].get("v.value") == null || getunitPriceId[k].get("v.value") == ''){
                                    //var err = '{!$Label.c.Not_Empty_Message}';
                                    var err  = $A.get("{!$Label.c.Not_Empty_Message}");
                                    component.find("unitPrice")[k].set("v.errors",[{message:err}]); 
                                    var toggleText = component.find("unitPrice")[k];                    
                                    $A.util.addClass(toggleText, "error");                               
                                    
                                }else if(getunitPriceId[k].get("v.value") < 0){
                                    var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                                    component.find("minPrice")[k].set("v.errors",[{message:err}]); 
                                    var toggleText = component.find("minPrice")[k];                    
                                    $A.util.addClass(toggleText, "error");
                                    
                                }else{
                                    component.find("unitPrice")[k].set("v.errors",null); 
                                    var toggleText = component.find("unitPrice")[k];                    
                                    $A.util.removeClass(toggleText, "error");
                                }
                                
                                if(getminPriceId[k].get("v.value") == null){
                                     var err  = $A.get("{!$Label.c.Not_Empty_Message}");
                                    component.find("minPrice")[k].set("v.errors",[{message:err}]); 
                                    var toggleText = component.find("minPrice")[k];                    
                                    $A.util.addClass(toggleText, "error");
                                    
                                }else if(getminPriceId[k].get("v.value") < 0){
                                    var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                                    component.find("minPrice")[k].set("v.errors",[{message:err}]); 
                                    var toggleText = component.find("minPrice")[k];                    
                                    $A.util.addClass(toggleText, "error");
                                    
                                }else{
                                    component.find("minPrice")[k].set("v.errors",null); 
                                    var toggleText = component.find("minPrice")[k];                    
                                    $A.util.removeClass(toggleText, "error");
                                }
                                
                                if(getmonthRateAllId[k].get("v.value") == null){
                                    var err  = $A.get("{!$Label.c.Not_Empty_Message}");
                                    component.find("monthRate")[k].set("v.errors",[{message:err}]); 
                                    var toggleText = component.find("monthRate")[k];                    
                                    $A.util.addClass(toggleText, "error");
                                    
                                }else if(getmonthRateAllId[k].get("v.value") < 0){
                                    var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                                    component.find("monthRate")[k].set("v.errors",[{message:err}]); 
                                    var toggleText = component.find("monthRate")[k];                    
                                    $A.util.addClass(toggleText, "error");
                                    
                                }else{
                                    component.find("monthRate")[k].set("v.errors",null); 
                                    var toggleText = component.find("monthRate")[k];                    
                                    $A.util.removeClass(toggleText, "error");
                                    
                                }
                                var bothCurrValid = component.get("v.isBothCurrency");
                                if(bothCurrValid){
                                    
                                    if(alltexchangeRateId[k].get("v.value") == 0 ){
                                        var err  = $A.get("{!$Label.c.Not_Empty_Message}");
                                        component.find("exchangeRate")[k].set("v.errors",[{message:err}]); 
                                        var toggleText = component.find("exchangeRate")[k];                    
                                        $A.util.addClass(toggleText, "error");
                                       
                                    }else if(alltexchangeRateId[k].get("v.value") < 0){
                                        var err  = $A.get("{!$Label.c.Only_Positive_number_is_allowed}");
                                        component.find("exchangeRate")[k].set("v.errors",[{message:err}]); 
                                        var toggleText = component.find("exchangeRate")[k];                    
                                        $A.util.addClass(toggleText, "error");
                                    }else{
                                        component.find("exchangeRate")[k].set("v.errors",null); 
                                        var toggleText = component.find("exchangeRate")[k];                    
                                        $A.util.removeClass(toggleText, "error");
                                    }
                                }
                            }
                        } 
                        
                    }catch(error){
						console.log('error-->'+error);
                    }
                   
                }//else closed
            }
            if(firstDtfalse == false){
                isPriceBookvalid = false;
            }
            if(secondDtfalse == false){
                isPriceBookvalid = false;
            }    
        }
        
        // Price Book and sales district and Material is true
        if(isPriceBookvalid == true && isMaterialvalid == true && isSalesDistvalid == true){
            
            var BRLcurrency = 'BRL' ; 
            var USDcurrency = 'USD'; 
            var bothCurrncy = 'Both' ; 
            
            var newPriceBook = component.get("v.PriceBook");           
            var newSalesDist = component.get("v.salesdtarr");
            var newSkuWrap = component.get("v.wrappers");
            var validfromDate = component.get("v.myDate");
            var expiryDate = component.get("v.myDate1");
            var CurrName = component.find("currencyID"); 
            var currencyName = CurrName.get("v.value");
            
            if(currencyName == 'Only BRL'){
                currencyName = BRLcurrency;
            }else if(currencyName == 'Only USD'){
                currencyName = USDcurrency;
            }else if(currencyName == 'BRL and USD'){
                currencyName = bothCurrncy;
            }
            
            component.set("v.showSpinner", true);
            // Calling apex to save PriceList Record
            var action = component.get("c.savePriceBookapex");
            
            action.setParams({ "arrOfSales" : JSON.stringify(newSalesDist),
                              "priceBookAsObj" : newPriceBook,
                              "skuList" : JSON.stringify(newSkuWrap),
                              "validfrm":validfromDate,
                              "expiryfrm":expiryDate,
                              "currencyName":currencyName
                             });
            
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state------'+state);
                
                if (state == "SUCCESS") {
                    
                    var recId = response.getReturnValue();
                    var pk = component.get("v.PriceBook");
                    component.set("v.PriceBook", pk);
                    component.set("v.PriceBook",{'sobjectType': 'Price_Book__c',
                                                 'Name':''
                                                });
                    
                    component.set("v.PriceBookDivisionName",'');
                    component.set("v.myDate", null);
                    component.set("v.myDate1", null);
                    component.set("v.wrappers",null);
                    component.set("v.salesdtarr",null);
                    
                    var editVal =  component.get("v.isbtndisable");
                    if(editVal){
                        var updateMsg = $A.get("{!$Label.c.PD_Update_Success_Message}");
                        var successMsg = $A.get("{!$Label.c.Success}");
                        component.find("updateBtn").set("v.disabled",true);
                        component.find("clonebtn").set("v.disabled",true);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": successMsg,
                            "type": "Success",
                            "message": updateMsg
                        });
                        toastEvent.fire();
                        helper.gotoListviewHelper(component);
                    }else{
                        //alert('test');
                        //component.find("mainSavebtn").set("v.disabled",true);
                        var createdMsg = $A.get("{!$Label.c.PD_Create_Success_Message}");
                        var successMsg = $A.get("{!$Label.c.Success}");
                        console.log('successMsg---->'+successMsg);
                        
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": successMsg,
                            "type": "Success",
                            "message": createdMsg
                        });
                        toastEvent.fire();
                        helper.gotoListviewHelper(component);
                    }
                    
                    
                }else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } 
                }else{
                    console.log('Unknown error2');
                }
            });
            $A.enqueueAction(action);
        }
   	},
})