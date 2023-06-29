({   
    
    gotoListviewHelper : function (component,defType) {
        
        var action = component.get("c.getListViews");
        var fullUrl='/apex/BrazilPriceBookViewSPA?defType='+defType;
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {               
                
                /* var homeEvent = $A.get("e.force:navigateToObjectHome");
                homeEvent.setParams({
                    "scope": "Price_Book__c"
                });
                homeEvent.fire();*/
                
                var urlEvent = $A.get("e.force:navigateToURL");
                if(urlEvent) {
                    urlEvent.setParams({
                        "url": fullUrl,
                        "isredirect": false
                    });
                    urlEvent.fire();
                } 
                else{
                    //window.location = fullUrl;
                    
                    // (sforce.one.navigateToURL) works when component loads in visualforce page.
                    sforce.one.navigateToURL(fullUrl);
                }
                
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
        
        /*   var skuWrapper = component.get("v.wrappers");
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
        }*/
        
        
        
    },
    revertCssChange: function(component){
        
        var isCloneVar = component.get("v.isClone");        
        var isDone = true; 
        
        var recordId = component.get("v.recordId"); 
        /*  if (typeof recordId != "undefined"){
           //  console.log('Edit Record----->');
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
			//  console.log('New Record----->');
             setTimeout(function(){ 
                component.find("newLineItem").focus();
            },100);
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
    
    
    //added to convert file to table and validate the data if kit pb
    CSV2JSONKIT: function (component,csv,currency) {
        
        var skDet = component.get('v.materialDetails');
        console.log('skDet'+skDet);
        var skuDesc = component.get("v.skuDescription");
        var skuSet= component.get("v.uniqueSKU");
        console.log('skuSet'+skuSet);
        var clrTable= component.get("v.clearTableData");    
        var key ='';
        var code='';
        var keyk ='';
        var codek='';
        var count= component.get("v.count"); 
        //var array = [];
        var arr = []; 
        
        arr = csv.split('\n');
        
        // console.log('@@@ arr = '+arr);
        arr.pop();
        var jsonObj = [];
        var headers = arr[0].split(',');
        var flag=true;
        for(var i = 1; i < arr.length; i++) {
            // var data = arr[i].split(',');
            
            var re =/,(?=(?:(?:[^"]*"){2})*[^"]*$)/g;				// /,(?=(?:(?:[^"]*"){2})*[^"]*$)/; 
            var data = [].map.call(arr[i].split(re), function(el) {
                return el.replace(/^"|"$/g, '');
            }
                                  );
            //changed from 7 to 8
            if(data.length == 6){
                
                //alert(data);
                var obj = {};
                var obj2 ={};
                var skCode=data[0].trim();
                skCode=skCode.replace(',00','').trim();  
                if(skCode.length == 6){
                    key='5191000000000000'+skCode;   // if length is 6 then added 12 zeros. 
                    code='000000000000'+skCode;
                }
                else if(skCode.length == 7){
                    key='519100000000000'+skCode;    // if length is 7 then added 11 zeros.
                    code='00000000000'+skCode;       
                }
                    else {
                        key='5191'+skCode;    // if length is 18 then added sales org code only. 
                        code=skCode;      
                    }
                
                
                var ktCode=data[5].trim();
                //alert(ktCode);
                ktCode=ktCode.replace(',00','').trim();  
                if(ktCode.length == 6){
                    keyk='5191000000000000'+skCode;
                    codek='000000000000'+ktCode;
                }
                else if(ktCode.length == 7){
                    keyk='519100000000000'+skCode;
                    codek='00000000000'+ktCode;       
                }
                    else {
                        keyk='5191'+skCode;
                        codek=ktCode;      
                    }
                var cmpCode;
                if(ktCode.length!=0 && skCode.length!=0){
                    cmpCode=codek+'#'+code;
                    
                    if (jQuery.inArray(cmpCode, skuSet)!='-1') {
                        flag=false;
                        
                        var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.Duplicate_SKU_Found}");
                        var titl  = $A.get("{!$Label.c.Error}");
                        toastEvent.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg
                        });
                        toastEvent.fire();
                        clrTable=true;
                    }
                }
                for(var j = 0; j < data.length; j++) {
                    var invVal='';
                    var val=data[j].trim();
                    
                    if(val.length == 0){ 
                        
                        if(j == 0 && val.length == 0){
                            flag=false;
                            var toastEvent = $A.get("e.force:showToast");
                            var msg  = $A.get("{!$Label.c.File_has_Null_SKU_Code_Please_Add_SKU_Code_and_Then_Import_File}");
                            var titl  = $A.get("{!$Label.c.Warning}");
                            toastEvent.setParams({
                                "title": titl,
                                "type": "warning",
                                "message": msg,
                                "duration":'5000'
                            });
                            toastEvent.fire();
                            val='0,0';
                            
                        }
                        else if(currency =='Only BRL' && (j == 1 || j == 3)){
                            alert('in err brl')
                            flag=false;
                            var toastEvent = $A.get("e.force:showToast");
                            var msg  = $A.get("{!$Label.c.Found_Null_Column_values_for_BRL}");
                            var titl  = $A.get("{!$Label.c.Warning}");
                            toastEvent.setParams({
                                "title": titl,
                                "type": "warning",
                                "message": msg
                            });
                            toastEvent.fire();
                            val='0,0';
                            clrTable=true;
                        }
                            else if(currency =='Only USD' && (j == 2 || j == 4)){
                                flag=false;
                                var toastEvent = $A.get("e.force:showToast");
                                var msg  = $A.get("{!$Label.c.Found_Null_Column_values_for_USD}");
                                var titl  = $A.get("{!$Label.c.Warning}");
                                toastEvent.setParams({
                                    "title": titl,
                                    "type": "warning",
                                    "message": msg
                                });
                                toastEvent.fire();
                                val='0,0';
                                clrTable=true;
                            }
                                else if(currency =='BRL and USD' && (j == 1 || j == 2 || j == 3 || j == 4)){
                                    flag=false;
                                    var toastEvent = $A.get("e.force:showToast");
                                    var msg  = $A.get("{!$Label.c.Found_Null_Column_values_for_Both_Currency}");
                                    var titl  = $A.get("{!$Label.c.Warning}");
                                    toastEvent.setParams({
                                        "title": titl,
                                        "type": "warning",
                                        "message": msg
                                    });
                                    toastEvent.fire();
                                    val='0,0';
                                    clrTable=true;
                                }
                                    else if(j==5){
                                        flag=false;
                                        var toastEvent = $A.get("e.force:showToast");
                                        var msg  = $A.get("{!$Label.c.File_has_Null_Kit_SKU_Code_Please_Add_Kit_SKU_Code_and_Then_Import_File}");
                                        var titl  = $A.get("{!$Label.c.Warning}");
                                        toastEvent.setParams({
                                            "title": titl,
                                            "type": "warning",
                                            "message": msg,
                                            "duration":'5000'
                                        });
                                        toastEvent.fire();
                                        val='0,0';
                                    }
                                        else{
                                            
                                            val='0,0';
                                            
                                            
                                            
                                            val=val.replace('.','').replace(',','.').trim();
                                            val=val.replace("\"","");
                                            val=parseFloat(val).toFixed(2).toString();    
                                            val=val.replace(".",",");    
                                            invVal = val;
                                            var hed=headers[j].replace(",",".").trim();
                                            hed=hed.replace(".",",");
                                            
                                            obj[hed] = val;
                                            
                                            
                                            if(isNaN(invVal.replace(",","."))){
                                                flag=false;
                                                var toastEvent = $A.get("e.force:showToast");
                                                var msg  = $A.get("{!$Label.c.Invalid_Data_Found_Please_Check_CSV_File}");
                                                var titl  = $A.get("{!$Label.c.Error}");
                                                toastEvent.setParams({
                                                    "title": titl,
                                                    "type": "error",
                                                    "message": msg
                                                });
                                                toastEvent.fire();
                                                clrTable=true;
                                            }
                                            else{
                                                if(j==0){
                                                    // obj2.pbd_id=''; 
                                                    val=val.replace(',00','').trim();  
                                                    obj2.sku_code=val;  
                                                    
                                                    
                                                    
                                                    if(key in skuDesc){
                                                        console.log('skuDesc------ '+skuDesc[key]);
                                                        obj2.mt_code=skuDesc[key];
                                                    }
                                                    else{
                                                        obj2.mt_code='';
                                                    } 
                                                    
                                                }
                                              
                                                        else if(j==1){
                                                            obj2.unt_prc=val; 
                                                        }
                                                            else if(j==2){
                                                                obj2.unt_prc_u=val;  
                                                            }
                                                                else if(j==3){
                                                                    obj2.fsp=val;  
                                                                }
                                                                    else if(j==4){
                                                                        obj2.fsp_u=val;  
                                                                    }
                                                                        else if(j==5){
                                                                            //val=val.replace(',00','').trim();
                                                                            //  alert(val);
                                                                            obj2.kit_prod=val;
                                                                        }
                                                
                                            }
                                        }
                    }
                    else{
                        
                        
                        
                        val=val.replace('.','').replace(',','.').trim();
                        val=val.replace("\"","");
                        val=parseFloat(val).toFixed(2).toString();    
                        val=val.replace(".",",");   
                        
                        var hed=headers[j].replace(",",".").trim();
                        hed=hed.replace(".",",");
                        invVal=val;
                        obj[hed] = val;
                        
                        
                        if(isNaN(invVal.replace(",","."))){
                            flag=false;
                            var toastEvent = $A.get("e.force:showToast");
                            var msg  = $A.get("{!$Label.c.Invalid_Data_Found_Please_Check_CSV_File}");
                            var titl  = $A.get("{!$Label.c.Error}");
                            toastEvent.setParams({
                                "title": titl,
                                "type": "error",
                                "message": msg
                            });
                            toastEvent.fire();
                            clrTable=true;
                        }
                        else{
                            if(j==0){
                                //obj2.pbd_id=''; 
                                val=val.replace(',00','').trim(); 
                                obj2.sku_code=val; 
                                
                                if(val.length == 6){
                                    key='5191000000000000'+val;   // if length is 6 then added 12 zeros.
                                    code='000000000000'+val; 
                                }
                                else if(val.length == 7){
                                    key='519100000000000'+val;    // if length is 7 then added 11 zeros.
                                    code='00000000000'+val;       
                                }
                                    else {
                                        key='5191'+val;    // if length is 18 then added sales org code only.
                                        code=val;       
                                    }
                                
                                
                                
                                
                                if(key in skuDesc){
                                    // console.log('skuDesc------ '+skuDesc[key]);
                                    obj2.mt_code=skuDesc[key];
                                }
                                else{
                                    obj2.mt_code='';
                                } 
                            }
                           
                                    else if(j==1){
                                        obj2.unt_prc=val; 
                                    }
                                        else if(j==2){
                                            obj2.unt_prc_u=val;  
                                        }
                                            else if(j==3){
                                                obj2.fsp=val;  
                                            }
                                                else if(j==4){
                                                    obj2.fsp_u=val;  
                                                }
                                                    else if(j==5){
                                                        val=val.replace(',00','').trim(); 
                                                        obj2.kit_prod=val;
                                                    }
                        }
                    } 
                    //console.log('@@@ obj headers = ' + obj[headers[j].trim()]);
                }
                
                if(flag){
                    obj2.min_prc=0;
                  obj2.min_prc_u=0;
                  obj2.sellOutPrice='0';
                  obj2.sellOutPriceU='0';
                  obj2.GM=0;
                  obj2.GMU=0;
                  obj2.selloutType='  ';
                  obj2.selloutTypeU='  ';
                  obj2.SelloutFactor=0;
                  obj2.SelloutFactorU=0;
                  obj2.MinPriceFactor=0;
                  obj2.MinPriceFactorU=0;
                    obj2.pbd_id='';
                    skDet.push(obj2);
                    skuSet.push(cmpCode);
                    
                }
                else{
                    component.find("file").getElement().value='';
                    if(clrTable){
                        skDet.splice(0, skDet.length);
                        
                        skuSet=[];
                        $('#tableId').dataTable().fnClearTable();
                    }
                    
                    break;
                }
                jsonObj.push(obj);
            }
            else{
                component.find("file").getElement().value='';
                flag=false;
                var toastEvent = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Wrong_file_format}");
                var titl  = $A.get("{!$Label.c.Warning}");
                toastEvent.setParams({
                    "title": titl,
                    "type": "warning",
                    "message": msg
                });
                toastEvent.fire();
            } 
        }
        console.log('skDet------->');
        console.log(skDet); 
        console.log('SKU SET -----> '+JSON.stringify(skuSet));
        console.log('flag'+flag);
        component.set('v.materialDetails',skDet);
        component.set('v.uniqueSKU',skuSet);
        
        //added by Swapnil-- to check Sales district is not null
        var SD = component.get("v.salesdtarr");
        var Error = $A.get("{!$Label.c.Error}");
        
        if(SD.length==0){
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": Error,
                "type": Error,
                "message": $A.get("{!$Label.c.SalesDistrictBeforeSKU}")
                
            });
            toastEvent.fire();
            flag = false;
            var liSKUCode=[];
            component.set("v.showSpinner",false);
            component.find("file").getElement().value='';
            var emptySKU = [];
            component.set("v.uniqueSKU", emptySKU);
            component.set("v.materialDetails", emptySKU);
            clrTable=true;
        }
        else{
            //added by Swapnil
            var liSKUCode=[];
            var md = component.get("v.materialDetails");
            var arrOfSalesdist = component.get("v.salesdtarr")
            for(var j = 0; j < md.length; j++) {
                liSKUCode.push(md[j].sku_code);
            }
            
            var action = component.get("c.SKUValidationKIT");
            action.setParams({ LiSKU :  JSON.stringify(md),
                              salesDistArray:JSON.stringify(arrOfSalesdist),
                              kitPb:component.get("v.Price_Book_For_Kit")});//liSKUCode
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue().ErrorString.length>0){
                        var toastEvent = $A.get("e.force:showToast");                        
                        toastEvent.setParams({
                            "title": $A.get("{!$Label.c.Error}"),
                            "type": "warning",
                            "message": response.getReturnValue().ErrorString
                        });
                        toastEvent.fire();
                    }
                    if(response.getReturnValue().FinalSKUList.length>0) { 
                        console.log('return '+response.getReturnValue().FinalSKUList);
                        flag = true;
                        skDet = response.getReturnValue().FinalSKUList;
                        console.log('skDet '+skDet);
                        if(flag){
                            
                            
                            $('#tableId').dataTable().fnClearTable();
                            
                            
                            setTimeout(function(){ 
                                // $('#tableId').DataTable();
                                // console.log(JSON.parse(JSON.stringify(skDet)));
                                var testJson = JSON.parse(JSON.stringify(skDet));
                                
                                var length = testJson.length;
                                for(var i = 0; i < length; i++) {
                                    count=i;
                                    try {
                                        var btnCode=testJson[i].kit_prod+'#'+testJson[i].sku_code;
                                        $('#tableId').dataTable().fnAddData( [
                                            
                                            testJson[i].sku_code,
                                            testJson[i].mt_code,
                                            testJson[i].kit_prod,
                                            testJson[i].min_prc,
                                            testJson[i].min_prc_u,
                                            testJson[i].unt_prc,
                                            testJson[i].unt_prc_u,
                                            testJson[i].sellOutPrice,//changes by Harshit@Wipro
                                             testJson[i].sellOutPriceU,//changes by Harshit@Wipro
                                             testJson[i].fsp,
                                             testJson[i].fsp_u,
                                             //Below 8 lines changes by Harshit@Wipro START
                                             testJson[i].GM,
                                             testJson[i].GMU,
                                             testJson[i].selloutType,
                                             testJson[i].selloutTypeU,
                                             testJson[i].SelloutFactor,
                                             testJson[i].SelloutFactorU,
                                             testJson[i].MinPriceFactor,
                                             testJson[i].MinPriceFactorU,
                                             //END    
                                            '<button class="btn-to-hide" style="color:red; font-weight:bold; margin-left:21px; background:#fff; border-radius:3px; border:1px solid #ccc; padding:2px 5px 2px 5px;" id="" name="'+btnCode+'" value="'+i+'" iconName="utility:delete">X</button>'
                                            
                                            
                                            
                                        ]);
                                    } catch (error) {
                                        console.log(error);  
                                        component.find("file").getElement().value='';
                                        component.set("v.showSpinner",false);  
                                    }
                                }
                                component.set('v.count',count+1); 
                                component.set("v.clearTableData",true);
                                component.set("v.showSpinner",false);  
                                component.set("v.materialDetails", skDet);
                                $('div.dataTables_filter input').addClass('slds-input');
                                $('div.dataTables_filter input').css("marginBottom", "10px");
                            }, 5000);  
                        }
                        else{
                            
                            component.set("v.showSpinner",false);
                        }
                    }
                    else{
                        component.set("v.showSpinner",false);
                        component.find("file").getElement().value='';
                        var emptySKU = [];
                        component.set("v.uniqueSKU", emptySKU);
                        component.set("v.materialDetails", emptySKU);
                        $('#tableId').dataTable().fnClearTable();
                        //console.log('SKU '+Component.get("v.uniqueSKU"));
                        flag = false;
                    }
                    
                }
            });
            $A.enqueueAction(action);
        } 
        //end
        
        var json = JSON.stringify(jsonObj);
        
        
        return json;
        
    }, 
    //changed data length from 7 to 8 and set empty for kit prod code
    CSV2JSON: function (component,csv,currency) {
        
        var skDet = component.get('v.materialDetails');
        console.log('skDet'+skDet);
        var skuDesc = component.get("v.skuDescription");
        var skuSet= component.get("v.uniqueSKU");
        console.log('skuSet'+skuSet);
        var clrTable= component.get("v.clearTableData");    
        var key ='';
        var code='';
        var count= component.get("v.count"); 
        //var array = [];
        var arr = []; 
        
        arr = csv.split('\n');
        
        // console.log('@@@ arr = '+arr);
        arr.pop();
        var jsonObj = [];
        var headers = arr[0].split(',');
        var flag=true;
        for(var i = 1; i < arr.length; i++) {
            // var data = arr[i].split(',');
            
            var re =/,(?=(?:(?:[^"]*"){2})*[^"]*$)/g;				// /,(?=(?:(?:[^"]*"){2})*[^"]*$)/; 
            var data = [].map.call(arr[i].split(re), function(el) {
                return el.replace(/^"|"$/g, '');
            }
                                  );
            //changed from 7 to 8
            if(data.length == 6){
                
                //alert(data);
                var obj = {};
                var obj2 ={};
                
                for(var j = 0; j < data.length; j++) {
                    var invVal='';
                    var val=data[j].trim();
                    if(val.length == 0){ 
                        
                        if(j == 0 && val.length == 0){
                            flag=false;
                            var toastEvent = $A.get("e.force:showToast");
                            var msg  = $A.get("{!$Label.c.File_has_Null_SKU_Code_Please_Add_SKU_Code_and_Then_Import_File}");
                            var titl  = $A.get("{!$Label.c.Warning}");
                            toastEvent.setParams({
                                "title": titl,
                                "type": "warning",
                                "message": msg,
                                "duration":'5000'
                            });
                            toastEvent.fire();
                            val='0,0';
                            
                        }
                        else if(currency =='Only BRL' && (j == 1 || j == 3)){
                            flag=false;
                            var toastEvent = $A.get("e.force:showToast");
                            var msg  = $A.get("{!$Label.c.Found_Null_Column_values_for_BRL}");
                            var titl  = $A.get("{!$Label.c.Warning}");
                            toastEvent.setParams({
                                "title": titl,
                                "type": "warning",
                                "message": msg
                            });
                            toastEvent.fire();
                            val='0,0';
                            clrTable=true;
                        }
                            else if(currency =='Only USD' && (j == 2 || j == 4)){
                                flag=false;
                                var toastEvent = $A.get("e.force:showToast");
                                var msg  = $A.get("{!$Label.c.Found_Null_Column_values_for_USD}");
                                var titl  = $A.get("{!$Label.c.Warning}");
                                toastEvent.setParams({
                                    "title": titl,
                                    "type": "warning",
                                    "message": msg
                                });
                                toastEvent.fire();
                                val='0,0';
                                clrTable=true;
                            }
                                else if(currency =='BRL and USD' && (j == 1 || j == 2 || j == 3 || j == 4)){
                                    flag=false;
                                    var toastEvent = $A.get("e.force:showToast");
                                    var msg  = $A.get("{!$Label.c.Found_Null_Column_values_for_Both_Currency}");
                                    var titl  = $A.get("{!$Label.c.Warning}");
                                    toastEvent.setParams({
                                        "title": titl,
                                        "type": "warning",
                                        "message": msg
                                    });
                                    toastEvent.fire();
                                    val='0,0';
                                    clrTable=true;
                                }
                                    else{
                                        
                                        val='0,0';
                                        
                                        /* val=val.replace(",",".").trim();
                val=val.replace(".",",");
                val=val.replace("\"","");*/
                                        
                                        val=val.replace('.','').replace(',','.').trim();
                                        val=val.replace("\"","");
                                        val=parseFloat(val).toFixed(2).toString();    
                                        val=val.replace(".",",");    
                                        invVal = val;
                                        var hed=headers[j].replace(",",".").trim();
                                        hed=hed.replace(".",",");
                                        
                                        obj[hed] = val;
                                        
                                        /* if(j==0){
                  obj2.cn=val;  
                }
                else if(j==1){
                  obj2.mt_code=val;  
                }
                else*/
                    if(isNaN(invVal.replace(",","."))){
                        flag=false;
                        var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.Invalid_Data_Found_Please_Check_CSV_File}");
                        var titl  = $A.get("{!$Label.c.Error}");
                        toastEvent.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg
                        });
                        toastEvent.fire();
                        clrTable=true;
                    }
                    else{
                        if(j==0){
                            // obj2.pbd_id=''; 
                            val=val.replace(',00','').trim();  
                            obj2.sku_code=val;  
                            
                            if(val.length == 6){
                                key='5191000000000000'+val;   // if length is 6 then added 12 zeros. 
                                code='000000000000'+val;
                            }
                            else if(val.length == 7){
                                key='519100000000000'+val;    // if length is 7 then added 11 zeros.
                                code='00000000000'+val;       
                            }
                                else {
                                    key='5191'+val;    // if length is 18 then added sales org code only. 
                                    code=val;      
                                }
                            
                            if (jQuery.inArray(code, skuSet)!='-1') {
                                flag=false;
                                
                                var toastEvent = $A.get("e.force:showToast");
                                var msg  = $A.get("{!$Label.c.Duplicate_SKU_Found}");
                                var titl  = $A.get("{!$Label.c.Error}");
                                toastEvent.setParams({
                                    "title": titl,
                                    "type": "error",
                                    "message": msg
                                });
                                toastEvent.fire();
                                clrTable=true;
                            }
                            
                            if(key in skuDesc){
                                console.log('skuDesc------ '+skuDesc[key]);
                                obj2.mt_code=skuDesc[key];
                            }
                            else{
                                obj2.mt_code='';
                            } 
                            
                        }
                        
                                else if(j==1){
                                    obj2.unt_prc=val; 
                                }
                                    else if(j==2){
                                        obj2.unt_prc_u=val;  
                                    }
                                        else if(j==3){
                                            obj2.fsp=val;  
                                        }
                                            else if(j==4){
                                                obj2.fsp_u=val;  
                                            }
                        //adding kit prod code
                                                else if(j==5){
                                                    if(val!=null && val!=''){
                                                        obj2.kit_prod==val;
                                                    }
                                                    else{
                                                        obj2.kit_prod==''; 
                                                    }
                                                }
                    }
                }
             }
                else{
                    
                    /* if(val.length == 0){
                    val='0,0';
                }*/
                  /*val=val.replace(",",".").trim();
                val=val.replace(".",",");
                val=val.replace("\"","");*/
                  
                  val=val.replace('.','').replace(',','.').trim();
                  val=val.replace("\"","");
                  val=parseFloat(val).toFixed(2).toString();    
                  val=val.replace(".",",");   
                  
                  var hed=headers[j].replace(",",".").trim();
                  hed=hed.replace(".",",");
                  invVal=val;
                  obj[hed] = val;
                  
                  /* if(j==0){
                  obj2.cn=val;  
                }
                else if(j==1){
                  obj2.mt_code=val;  
                }
                else*/
                  if(isNaN(invVal.replace(",","."))){
                      flag=false;
                      var toastEvent = $A.get("e.force:showToast");
                      var msg  = $A.get("{!$Label.c.Invalid_Data_Found_Please_Check_CSV_File}");
                      var titl  = $A.get("{!$Label.c.Error}");
                      toastEvent.setParams({
                          "title": titl,
                          "type": "error",
                          "message": msg
                      });
                      toastEvent.fire();
                      clrTable=true;
                  }
                  else{
                      if(j==0){
                          //obj2.pbd_id=''; 
                          val=val.replace(',00','').trim(); 
                          obj2.sku_code=val; 
                          
                          if(val.length == 6){
                              key='5191000000000000'+val;   // if length is 6 then added 12 zeros.
                              code='000000000000'+val; 
                          }
                          else if(val.length == 7){
                              key='519100000000000'+val;    // if length is 7 then added 11 zeros.
                              code='00000000000'+val;       
                          }
                              else {
                                  key='5191'+val;    // if length is 18 then added sales org code only.
                                  code=val;       
                              }
                          
                          if (jQuery.inArray(code, skuSet)!='-1') {
                              flag=false;
                              
                              var toastEvent = $A.get("e.force:showToast");
                              var msg  = $A.get("{!$Label.c.Duplicate_SKU_Found}");
                              var titl  = $A.get("{!$Label.c.Error}");
                              toastEvent.setParams({
                                  "title": titl,
                                  "type": "error",
                                  "message": msg
                              });
                              toastEvent.fire();
                              clrTable=true;
                          } 
                          
                          
                          if(key in skuDesc){
                              // console.log('skuDesc------ '+skuDesc[key]);
                              obj2.mt_code=skuDesc[key];
                          }
                          else{
                              obj2.mt_code='';
                          } 
                      }
                     
                              else if(j==1){
                                  obj2.unt_prc=val; 
                              }
                                  else if(j==2){
                                      obj2.unt_prc_u=val;  
                                  }
                                      else if(j==3){
                                          obj2.fsp=val;  
                                      }
                                          else if(j==4){
                                              obj2.fsp_u=val;  
                                          }
                      //adding kit prod code
                                              else if(j==5){
                                                  if(val!=null && val!=''){
                                                      obj2.kit_prod==val;
                                                  }
                                                  else{
                                                      obj2.kit_prod==''; 
                                                  }
                                              }
                  }
              } 
                //console.log('@@@ obj headers = ' + obj[headers[j].trim()]);
            }
              
              if(flag){
                  obj2.min_prc=0;
                  obj2.min_prc_u=0;
                  obj2.sellOutPrice='0';
                  obj2.sellOutPriceU='0';
                  obj2.GM=0;
                  obj2.GMU=0;
                  obj2.selloutType='  ';
                  obj2.selloutTypeU='  ';
                  obj2.SelloutFactor=0;
                  obj2.SelloutFactorU=0;
                  obj2.MinPriceFactor=0;
                  obj2.MinPriceFactorU=0;
                  obj2.pbd_id='';
                  skDet.push(obj2);
                  skuSet.push(code);
                  
              }
              else{
                  component.find("file").getElement().value='';
                  if(clrTable){
                      skDet.splice(0, skDet.length);
                      
                      skuSet=[];
                      $('#tableId').dataTable().fnClearTable();
                  }
                  
                  break;
              }
              jsonObj.push(obj);
          }
            else{
                component.find("file").getElement().value='';
                flag=false;
                var toastEvent = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Wrong_file_format}");
                var titl  = $A.get("{!$Label.c.Warning}");
                toastEvent.setParams({
                    "title": titl,
                    "type": "warning",
                    "message": msg
                });
                toastEvent.fire();
            } 
        }
         console.log('skDet------->');
         console.log(skDet); 
         console.log('SKU SET -----> '+JSON.stringify(skuSet));
         console.log('flag'+flag);
         component.set('v.materialDetails',skDet);
         component.set('v.uniqueSKU',skuSet);
         
         //added by Swapnil-- to check Sales district is not null
         var SD = component.get("v.salesdtarr");
         var Error = $A.get("{!$Label.c.Error}");
         
         if(SD.length==0){
             
             var toastEvent = $A.get("e.force:showToast");
             toastEvent.setParams({
                 "title": Error,
                 "type": Error,
                 "message": $A.get("{!$Label.c.SalesDistrictBeforeSKU}")
                 
             });
             toastEvent.fire();
             flag = false;
             var liSKUCode=[];
             component.set("v.showSpinner",false);
             component.find("file").getElement().value='';
             var emptySKU = [];
             component.set("v.uniqueSKU", emptySKU);
             component.set("v.materialDetails", emptySKU);
             clrTable=true;
         }
         else{
             //added by Swapnil
             var liSKUCode=[];
             var md = component.get("v.materialDetails");
             var arrOfSalesdist = component.get("v.salesdtarr")
             for(var j = 0; j < md.length; j++) {
                 liSKUCode.push(md[j].sku_code);
             }
             
             var action = component.get("c.SKUValidation");
             action.setParams({ LiSKU :  JSON.stringify(md),
                               salesDistArray:JSON.stringify(arrOfSalesdist)});//liSKUCode
             action.setCallback(this, function(response) {
                 var state = response.getState();
                 if (state === "SUCCESS") {
                     if(response.getReturnValue().ErrorString.length>0){
                         var toastEvent = $A.get("e.force:showToast");                        
                         toastEvent.setParams({
                             "title": $A.get("{!$Label.c.Error}"),
                             "type": "warning",
                             "message": response.getReturnValue().ErrorString
                         });
                         toastEvent.fire();
                     }
                     if(response.getReturnValue().FinalSKUList.length>0) { 
                         console.log('return '+response.getReturnValue().FinalSKUList);
                         flag = true;
                         skDet = response.getReturnValue().FinalSKUList;
                         console.log('skDet '+skDet);
                         if(flag){
                             
                             
                             $('#tableId').dataTable().fnClearTable();
                             
                             
                             setTimeout(function(){ 
                                 // $('#tableId').DataTable();
                                 // console.log(JSON.parse(JSON.stringify(skDet)));
                                 var testJson = JSON.parse(JSON.stringify(skDet));
                                 
                                 var length = testJson.length;
                                 for(var i = 0; i < length; i++) {
                                     var kt='';
                                     //alert(testJson[i].kit_prod);
                                     count=i;
                                     var kt='';
                                     try {
                                         
                                         $('#tableId').dataTable().fnAddData( [
                                             
                                             testJson[i].sku_code,
                                             testJson[i].mt_code,
                                             kt,
                                             testJson[i].min_prc,
                                             testJson[i].min_prc_u,
                                             testJson[i].unt_prc,
                                             testJson[i].unt_prc_u,
                                             testJson[i].sellOutPrice,//changes by Harshit@Wipro
                                             testJson[i].sellOutPriceU,//changes by Harshit@Wipro
                                             testJson[i].fsp,
                                             testJson[i].fsp_u,
                                             //Below 8 lines changes by Harshit@Wipro START
                                             testJson[i].GM,
                                             testJson[i].GMU,
                                             testJson[i].selloutType,
                                             testJson[i].selloutTypeU,
                                             testJson[i].SelloutFactor,
                                             testJson[i].SelloutFactorU,
                                             testJson[i].MinPriceFactor,
                                             testJson[i].MinPriceFactorU,
                                             //END     
                                             '<button class="btn-to-hide" style="color:red; font-weight:bold; margin-left:21px; background:#fff; border-radius:3px; border:1px solid #ccc; padding:2px 5px 2px 5px;" id="" name="'+testJson[i].sku_code+'" value="'+i+'" iconName="utility:delete">X</button>'
                                             
                                             
                                             
                                         ]);
                                     } catch (error) {
                                         console.log(error);  
                                         component.find("file").getElement().value='';
                                         component.set("v.showSpinner",false);  
                                     }
                                 }
                                 component.set('v.count',count+1); 
                                 component.set("v.clearTableData",true);
                                 component.set("v.showSpinner",false);  
                                 component.set("v.materialDetails", skDet);
                                 $('div.dataTables_filter input').addClass('slds-input');
                                 $('div.dataTables_filter input').css("marginBottom", "10px");
                             }, 5000);  
                         }
                         else{
                             
                             component.set("v.showSpinner",false);
                         }
                     }
                     else{
                         component.set("v.showSpinner",false);
                         component.find("file").getElement().value='';
                         var emptySKU = [];
                         component.set("v.uniqueSKU", emptySKU);
                         component.set("v.materialDetails", emptySKU);
                         $('#tableId').dataTable().fnClearTable();
                         //console.log('SKU '+Component.get("v.uniqueSKU"));
                         flag = false;
                     }
                     
                 }
             });
             $A.enqueueAction(action);
         } 
         //end
         /*  
    if(flag){

       
         $('#tableId').dataTable().fnClearTable();
        
              
        setTimeout(function(){ 
            // $('#tableId').DataTable();
           // console.log(JSON.parse(JSON.stringify(skDet)));
            var testJson = JSON.parse(JSON.stringify(skDet));
         
            var length = testJson.length;
            for(var i = 0; i < length; i++) {
                count=i;
          try {
          
                $('#tableId').dataTable().fnAddData( [
               
                testJson[i].sku_code,
                testJson[i].mt_code,
                testJson[i].min_prc,
                testJson[i].min_prc_u,
                testJson[i].unt_prc,
                testJson[i].unt_prc_u,
                testJson[i].fsp,
                testJson[i].fsp_u,
                '<button class="btn-to-hide" style="color:red; font-weight:bold; margin-left:21px; background:#fff; border-radius:3px; border:1px solid #ccc; padding:2px 5px 2px 5px;" id="" name="'+testJson[i].sku_code+'" value="'+i+'" iconName="utility:delete">X</button>'
               

              
            ]);
        } catch (error) {
          console.log(error);  
          component.find("file").getElement().value='';
          component.set("v.showSpinner",false);  
        }
       }
        component.set('v.count',count+1); 
        component.set("v.clearTableData",true);
        component.set("v.showSpinner",false);   
            $('div.dataTables_filter input').addClass('slds-input');
             $('div.dataTables_filter input').css("marginBottom", "10px");
         }, 5000);  
     }
     else{
       
        component.set("v.showSpinner",false);
     }
       
     */
         var json = JSON.stringify(jsonObj);
         
         
         return json;
         
     },   
    //added parameter related to kit in method call 
    createPriceBook:function(component, event, helper, priceBook, mtFile, arrOfSalesdist,arrOfSalesdist1,arrOfcustgrps,arrOfcustnames, payObjs){
        //  console.log('createPriceBook called..');
        //  console.log(priceBook);
        //  console.log(mtFile);
        //  console.log(arrOfSalesdist);
        //  console.log(payObjs);
        
        var action = component.get("c.saveNewPriceBook");
        
        
        action.setParams({
            "price_book":JSON.stringify(priceBook),
            "sku_file":JSON.stringify(mtFile),
            "salesDistArray":JSON.stringify(arrOfSalesdist),
            "cropCulArray":JSON.stringify(arrOfSalesdist1),//added by sagar for PB-003
            "custGrpArray":JSON.stringify(arrOfcustgrps),//added by sagar for PB-004
            "custNameArray":JSON.stringify(arrOfcustnames),//added by sagar for PB-004
            "paymentTerms":JSON.stringify(payObjs),
            "pbType":component.get("v.priceBookType"),
            "cropCultureId":component.get("v.fnlList")// added by javed(Grazitti) for RITM0463334 23-12-2022
        });
        
        action.setCallback(this,function(response){
            //  console.log(response.getError());
            if(response.getState() == 'SUCCESS'){
                //  console.log(response.getReturnValue()); 
                var resp = response.getReturnValue();
                //  alert('Price and Scheme Details Added Successfully..'); 
                
                if(resp == 'true'){
                    
                    var successMsg  = $A.get("{!$Label.c.Price_Book_Created_Successfully}"); 
                    var successMsg1 = $A.get("{!$Label.c.Success}");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": successMsg1,
                        "type": "Success",
                        "message": successMsg
                    });
                    toastEvent.fire();
                }
                else if(resp == 'false'){
                    var successMsg  = $A.get("{!$Label.c.Failed_to_Create_Error_Occurred}"); 
                    var successMsg1 = $A.get("{!$Label.c.Error}");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": successMsg1,
                        "type": "Error",
                        "message": successMsg
                        
                    });
                    toastEvent.fire();
                }
                    else{
                        //  console.log('Response on create...'); 
                        //  console.log(resp);
                        var successMsg  =$A.get("{!$Label.c.Price_Book_Created_Successfully}")+' \n'+ $A.get("{!$Label.c.SKU_Not_Valid_or_Not_Present_in_Database}")+' \n'+ resp+' \n'; 
                        var successMsg1 = $A.get("{!$Label.c.Warning}");
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": successMsg1,
                            "type": "Warning",
                            "message": successMsg,
                            "duration":'150000'
                        });
                        toastEvent.fire();
                    }
                
                
  //this.gotoListviewHelper(component,'draft');
  this.getMyAttachments(component, helper); //added by Atish
            } 
            // component.set("v.showSubmitSpinner",false);
            component.set("v.showSpinner",false);
        });
        
        $A.enqueueAction(action);	
    },
    
    //added parameter related to kit in method call 
    saveAndSubmitApproval:function(component, event, helper, priceBook, mtFile, arrOfSalesdist,arrOfSalesdist1,arrOfcustgrps,arrOfcustnames, payObjs){
        //  console.log('createPriceBook called..');
        //  console.log(priceBook);
        //  console.log(mtFile);
        //  console.log(arrOfSalesdist);
        //  console.log(payObjs);
        var abc = arrOfSalesdist;
        console.log('arrOfcustgrps',+arrOfcustgrps);
        var abc = arrOfSalesdist1;
        console.log('arrOfSalesdist1',+arrOfSalesdist1);
        var action = component.get("c.saveAndSendForApprovalNewPriceBook");
        
        
        action.setParams({
            "price_book":JSON.stringify(priceBook),
            "sku_file":JSON.stringify(mtFile),
            "salesDistArray":JSON.stringify(arrOfSalesdist),
            "cropCulArray":JSON.stringify(arrOfSalesdist1),
             "custGrpArray":JSON.stringify(arrOfcustgrps),
            "custNameArray":JSON.stringify(arrOfcustnames),
            "paymentTerms":JSON.stringify(payObjs),
            "pbType":component.get("v.priceBookType"),
            "cropCultureId":component.get("v.fnlList") //added by javed(Grazitti) for RITM0463334 23-12-2022
        });
        
        action.setCallback(this,function(response){
            //  console.log(response.getError());
            if(response.getState() == 'SUCCESS'){
                //  console.log(response.getReturnValue()); 
                var resp = response.getReturnValue();
                //  alert('Price and Scheme Details Added Successfully..');  
                component.set('v.insertedPriceBookIds',resp.pbSet);
                if(resp == 'true'){
                    
                    var successMsg  = $A.get("{!$Label.c.Price_Book_Created_Successfully}")+' '+ $A.get("{!$Label.c.Price_Book_is_Sent_For_Approval}"); 
                    var successMsg1 = $A.get("{!$Label.c.Success}");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": successMsg1,
                        "type": "Success",
                        "message": successMsg
                    });
                    toastEvent.fire();
                }
                else if(resp == 'false'){
                    var successMsg  = $A.get("{!$Label.c.Failed_to_Create_Error_Occurred}"); 
                    var successMsg1 = $A.get("{!$Label.c.Error}");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": successMsg1,
                        "type": "Error",
                        "message": successMsg
                        
                    });
                    toastEvent.fire();
                }
                    else{
                        //  console.log('Response on create...'); 
                        //  console.log(resp);
                        var successMsg  =$A.get("{!$Label.c.Price_Book_Created_Successfully}")+' '+ $A.get("{!$Label.c.Price_Book_is_Sent_For_Approval}")+' \n'+ $A.get("{!$Label.c.SKU_Not_Valid_or_Not_Present_in_Database}")+' \n'+ resp+' \n'; 
                        var successMsg1 = $A.get("{!$Label.c.Warning}");
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": successMsg1,
                            "type": "Warning",
                            "message": successMsg,
                            "duration":'150000'
                        });
                        toastEvent.fire();
                    }
                
                
 // this.gotoListviewHelper(component,'draft');
 this.getMyAttachments(component, helper); //added by Atish
            } 
            // component.set("v.showSubmitSpinner",false);
            component.set("v.showSpinner",false);
        });
        component.set("v.isModalOpen", true);//added by Atish

        $A.enqueueAction(action);	
    },
    
    //added parameter related to kit in method call 
    editPriceBookNew:function(component, event, helper){
        //  console.log('editPriceBookNew called..');
        //alert('in edit');
        component.set("v.showSpinner",true);
        component.set("v.iscustgrp",false);
        var isEdit1=component.get('v.isEdit');
        //component.find("addDistbtn").set("v.disabled",true);
        var action = component.get("c.editNewPriceBook");
        var dateFormat = $A.get("$Locale.dateFormat");
       // $('.addDistbtn').hide();
        action.setParams({
            "price_bookId":component.get("v.recordId")
        });
        
        action.setCallback(this,function(response){
            //  console.log(response.getError());
            if(response.getState() == 'SUCCESS'){
                
                var data = response.getReturnValue();
                var parsed = data;
                //  console.log(data);
                //  console.log(parsed);
                //  console.log(JSON.stringify(parsed.pc_book));
                // alert('parsed.length '+parsed.pc_book == null);
                if(parsed.pc_book == null || parsed.pc_book == ''){
                    component.set("v.showSpinner",false);
                    //  alert('No record in edit.');
                }
                else{
                    
                    /* if(parsed.pc_book.curncy == 'Only BRL'){
                        parsed.pc_book.curncy =$A.get("{!$Label.c.Only_BRL}");
                    }
                    else if(parsed.pc_book.curncy == 'Only USD'){
                        parsed.pc_book.curncy =$A.get("{!$Label.c.Only_USD}");
                    }
                    else {
                        parsed.pc_book.curncy =$A.get("{!$Label.c.USD_and_BRL}");   
                    } */
                    // component.find("addDistbtn").set("v.disabled",true);
                    component.set("v.priceBookDetails",parsed.pc_book);
                    component.set("v.hide10",true);
                    /* commenting for deployment apply discount matrix and usdrate

                    //Divya
                    if(parsed.pc_book.apply_discount == true){
                       component.find("apply_disc").set("v.checked", true); 
                    }*/
                    if(parsed.pc_book.isActive == true){
                        component.find("checkbox-id-02").set("v.checked", true);
                        component.set("v.active_deactive",$A.get("{!$Label.c.Deactivate}"));
                        // component.find("approvalBtnId").set("v.disabled",false);
                    }
                    else{
                        component.set("v.active_deactive",$A.get("{!$Label.c.Activate}"));
                        // component.find("approvalBtnId").set("v.disabled",true);
                    } 
                    // alert(parsed.pc_book.exp_dt+' ---- '+ new Date(parsed.pc_book.exp_dt).toDateString("yyyy-MM-dd"));
                    // alert(parsed.pc_book.exp_dt);
                    // var d = new Date(parsed.pc_book.exp_dt).toISOString().slice(0,10);
                    // var d2 = new Date(parsed.pc_book.frm_dt).toISOString().slice(0,10);
                    component.set("v.toDate",$A.localizationService.formatDate(parsed.pc_book.exp_dt, "yyyy-MM-dd")); //"yyyy-dd-MM" "d MMM, yyyy"
                    component.set("v.frmDate",$A.localizationService.formatDate(parsed.pc_book.frm_dt, "yyyy-MM-dd"));
                    component.set("v.lasMon",$A.localizationService.formatDate(parsed.pc_book.las_mon, "yyyy-MM-dd"));
                    
                    // component.set("v.toDate",d); //"yyyy-dd-MM" "d MMM, yyyy"
                    //  component.set("v.frmDate",d2);
                    //  Added by Sagar@Wipro Start--
                    if(isEdit1 == true){
                    if(parsed.pc_book.applyPercentage == true){
                        component.find("apply_percentage").set("v.checked", true);
                        component.find("apply_percentage").set("v.disabled",true);
                        component.set("v.applyPercentage",true);
                    }
                    else{
                        component.find("apply_percentage").set("v.checked", false);
                        component.find("apply_percentage").set("v.disabled",true);
                        component.set("v.applyPercentage",false);
                    }
                    //end--
                    
                    //  Added by Sagar@Wipro Start--
                    if(parsed.pc_book.applySimulation == true){
                        component.find("apply_simulation").set("v.checked", true);
                        component.find("apply_simulation").set("v.disabled",true);
                        component.set("v.applySimulation",true);
                    }
                    else{
                        component.find("apply_simulation").set("v.checked", false);
                        component.find("apply_simulation").set("v.disabled",true);
                        component.set("v.applySimulation",false);
                    }
                    //end--
                     //  Added by Sagar@Wipro Start--
                    if(parsed.pc_book.apply_discount == true){
                        component.find("apply_disc").set("v.checked", true);
                        component.find("apply_disc").set("v.disabled",true);
                        component.set("v.apply_discount",true);
                    }
                    else{
                        component.find("apply_disc").set("v.checked", false);
                        component.find("apply_disc").set("v.disabled",true);
                        component.set("v.apply_discount",false);
                    }
                    //end-
                    //
                    //  Added by Sagar@Wipro Start--
                    if(parsed.pc_book.applyMinPrice == true){
                        component.find("apply_MinPrice").set("v.checked", true);
                        component.find("apply_MinPrice").set("v.disabled",true);
                        component.set("v.applyMinPrice",true);
                    }
                    else{
                        component.find("apply_MinPrice").set("v.checked", false);
                        component.find("apply_MinPrice").set("v.disabled",true);
                        component.set("v.applyMinPrice",false);
                    }
                    }
                    //end--
                    
                    if(parsed.pc_book.pb_for_cmpgn == true){
                        component.find("checkbox-id-01").set("v.value", 'Price Book For Campaign'); 
                        component.set("v.hide1",true);
                        component.set("v.hide4",true);
                        component.set("v.pb_for_campaign",true);
                        component.set("v.priceBookType",'Price Book For Campaign');
                        /* var chkbx= $("#checkbox-id-01");
                       chkbx.prop('checked', true);*/
                        component.set("v.bltDate",$A.localizationService.formatDate(parsed.pc_book.blk_dt, "yyyy-MM-dd"));
                        component.set("v.intrDate",$A.localizationService.formatDate(parsed.pc_book.intr_dt, "yyyy-MM-dd"));
                        this.loadPaymentTerms(component);
                    }
                    else{
                        component.set("v.pb_for_campaign",false);
                        //added for kit
                        if(parsed.pc_book.pb_for_Kit == true){
                            //alert('in edit set');
                            component.set("v.Price_Book_For_Kit",true);
                            component.set("v.priceBookType",'Price Book For Kit');
                            component.find("checkbox-id-01").set("v.value", 'Price Book For Kit');
                        }
                        else{
                            component.set("v.Price_Book_For_Kit",false);
                            }//added by wipro
                        if(parsed.pc_book.pb_for_avec == true){
                        component.find("checkbox-id-01").set("v.value", 'AVEC Price Book'); 
                        component.set("v.hide1",false);
                        component.set("v.hide4",true);
                        component.set("v.pb_for_campaign",false);
                        component.set("v.priceBookType",'AVEC Price Book');
                            component.set("v.pb_for_avec",true);
                        /* var chkbx= $("#checkbox-id-01");
                       chkbx.prop('checked', true);*/
                        component.set("v.bltDate",$A.localizationService.formatDate(parsed.pc_book.blk_dt, "yyyy-MM-dd"));
                        component.set("v.intrDate",$A.localizationService.formatDate(parsed.pc_book.intr_dt, "yyyy-MM-dd"));
                       this.loadPaymentTerms(component);  //  //Updated for INC0448026  GRZ(Dheeraj Sharma) 09-02-2023
                    }
                        else{
																				component.set("v.pb_for_avec",false);
                            component.set("v.priceBookType",'Normal Pricebook');
                            component.find("checkbox-id-01").set("v.value", 'Normal Pricebook');
                        }
                        /* var chkbx= $("#checkbox-id-01");
                       chkbx.prop('checked', false);*/
                        //component.find("checkbox-id-01").set("v.checked", false); 
                        component.set("v.hide1",false);
                        component.set("v.hide4",false); 
                    }
                    
                    //added by Wipro
                    if(parsed.pc_book.pb_for_avec == true){
                        component.set("v.hide4",true);
                        component.find("intr_dt").set("v.disabled", true);
                    }
                    
                    if(parsed.pc_book.cmpgn_tp == 'Simple'){
                        component.find("radio1").set("v.checked", true);
                        component.set("v.campaignType",'Simple');
                    }
                    else if(parsed.pc_book.cmpgn_tp == 'Structure'){
                        component.find("radio2").set("v.checked", true);
                        component.set("v.campaignType",'Structure');
                    }
                        else{
                            component.set("v.campaignType",'');    
                        }
                    
                    if(parsed.pc_book.curncy == 'Only BRL'){
                        component.find("int_rate_U").set("v.disabled",true);
                    }
                    else if(parsed.pc_book.curncy == 'Only USD'){
                        component.find("int_rate_R").set("v.disabled",true);
                    }
                        else{
                            component.find("int_rate_R").set("v.disabled",false);
                            component.find("int_rate_U").set("v.disabled",false);
                            component.set("v.isBothCurrency", false);    
                        }
                    
                    //   component.set("v.PriceBookDivisionName",parsed.pc_book.division_nm);
                    //component.find("HiddenDivisionName").set("v.value", parsed.pc_book.division);
                    //alert('in edit');
                    
                    if(parsed.materialList != null){ 
                        //alert('not null');
                        var materials = component.get('v.materialDetails');
                        var skuSet= component.get("v.uniqueSKU"); 
                        var newWrapper = new Array();
                        for(var j = 0 ;j < parsed.materialList.length;j++){
                            //alert('hello'+parsed.materialList[j].kit_comp);
                            var kitcode=parsed.materialList[j].kit_prod;
                            if(parsed.materialList[j].kit_comp!='' && parsed.materialList[j].kit_comp!=null && parsed.materialList[j].kit_comp!=undefined){
                                //alert('inside kit comp'+parsed.materialList[j].kit_comp);
                                skuSet.push(parsed.materialList[j].kit_comp);
                                var kimComp=parsed.materialList[j].kit_comp;
                            }else{
                                skuSet.push(parsed.materialList[j].sku_code);
                            }
                            
                              if(parsed.materialList[j].SelloutFactorU =='' || parsed.materialList[j].SelloutFactorU ==null || parsed.materialList[j].SelloutFactorU ==undefined){
                            	parsed.materialList[j].SelloutFactorU = 0;
                            }
                             if(parsed.materialList[j].SelloutFactor =='' || parsed.materialList[j].SelloutFactor ==null || parsed.materialList[j].SelloutFactor ==undefined){
                            	parsed.materialList[j].SelloutFactor = 0;
                            }
                             if(parsed.materialList[j].MinPriceFactor =='' || parsed.materialList[j].MinPriceFactor ==null || parsed.materialList[j].MinPriceFactor ==undefined){
                            	parsed.materialList[j].MinPriceFactor = 0;
                            }
                             if(parsed.materialList[j].MinPriceFactorU =='' || parsed.materialList[j].MinPriceFactorU ==null || parsed.materialList[j].MinPriceFactorU ==undefined){
                            	parsed.materialList[j].MinPriceFactorU = 0;
                            }
                             if(parsed.materialList[j].GM =='' || parsed.materialList[j].GM ==null || parsed.materialList[j].GM ==undefined){
                            	parsed.materialList[j].GM = 0;
                            }
                             if(parsed.materialList[j].GMU =='' || parsed.materialList[j].GMU ==null || parsed.materialList[j].GMU ==undefined){
                            	parsed.materialList[j].GMU = 0;
                            }
                            
                            if(parsed.materialList[j].selloutTypeU =='' || parsed.materialList[j].selloutTypeU ==null || parsed.materialList[j].selloutTypeU ==undefined){
                            	parsed.materialList[j].selloutTypeU = ' ';
                            }
                            if(parsed.materialList[j].selloutType =='' ||  parsed.materialList[j].selloutType ==null || parsed.materialList[j].selloutType ==undefined){
                            	parsed.materialList[j].selloutType = ' ';
                            }
                            
                            console.log('sellOutPrice*****',parsed.materialList[j].sellOutPrice);
                            console.log('sellOutPriceU*****',parsed.materialList[j].sellOutPriceU);
                            console.log('unt_prc*****',parsed.materialList[j].min_prc);
                            console.log('min_prc_u*****',parsed.materialList[j].min_prc_u);
                            //alert(kitcode);
                            newWrapper = {
                                'pbd_id':parsed.materialList[j].pbd_id,
                                /*'cn': parsed.materialList[j].cn,*/
                                'mt_code': parsed.materialList[j].mt_code,
                                'sku_code' :parsed.materialList[j].sku_code,
                                'min_prc':parsed.materialList[j].min_prc,//
                                'min_prc_u':parsed.materialList[j].min_prc_u,
                                'unt_prc':parsed.materialList[j].unt_prc,
                                'unt_prc_u':parsed.materialList[j].unt_prc_u,
                                'sellOutPrice':parsed.materialList[j].sellOutPrice,//changes by Harshit
                                'sellOutPriceU':parsed.materialList[j].sellOutPriceU,//changes by Harshit
                                'fsp':parsed.materialList[j].fsp,
                                'fsp_u':parsed.materialList[j].fsp_u,
                                   
                              //Below 8 lines changes by Harshit@Wipro START
                              'GM':parsed.materialList[j].GM,
                              'GMU':parsed.materialList[j].GMU,
                              'selloutType':parsed.materialList[j].selloutType,
                              'selloutTypeU':parsed.materialList[j].selloutTypeU,
                              'SelloutFactor':parsed.materialList[j].SelloutFactor,
                              'SelloutFactorU':parsed.materialList[j].SelloutFactorU,
                              'MinPriceFactor':parsed.materialList[j].MinPriceFactor,
                              'MinPriceFactorU':parsed.materialList[j].MinPriceFactorU,
                            //END 
                                'kit_prod':kitcode,
                                'kit_comp':kimComp
                            };
                            materials.push(newWrapper);
                            
                            //skuSet.push(parsed.materialList[j].sku_code);    
                        } 
                        try{
                            component.set('v.materialDetails',materials);
                            component.set('v.uniqueSKU',skuSet);
                        }
                        catch(error){
                           alert(err);
                        }
                        setTimeout(function(){ 
                            var btn='';
                            //alert('inside timeout');
                            // $('#tableId').DataTable();
                            console.log(JSON.parse(JSON.stringify(materials)));
                            var testJson = JSON.parse(JSON.stringify(materials));
                            
                            var length = testJson.length;
                            for(var i = 0; i < length; i++) {
                                //alert('inside 2nd for'+testJson[i].pbd_id);
                                var code='';
                                if(testJson[i].kit_prod!='' && testJson[i].kit_prod!=null && testJson[i].kit_prod!=undefined){ 
                                    //alert('inside kit2nd comp'+testJson[i].kit_comp);
                                    code=testJson[i].kit_prod+'#'+testJson[i].sku_code;
                                }
                                else{
                                    code=testJson[i].sku_code;  
                                }
                                if(parsed.pc_book.status == 'Draft' || parsed.pc_book.status == 'Disapproved'){
                                    //alert(parsed.pc_book.status+testJson[i].kit_comp);
                                    btn='<button id="'+testJson[i].pbd_id+'" class="slds-button btn-small btn-to-hide" style="color:red" name="'+code+'" value="'+i+'" iconName="utility:delete" >X</button>'
                                }
                                else{
                                    btn='';
                                }
                                //alert('before try');
                                try {
                                    //alert('inside 2nd try'+testJson[i].kit_prod);
                                    
                                    
                                    $('#tableId').dataTable().fnAddData( [
                                        /* testJson[i].cn,
                            testJson[i].mt_code,*/
                                testJson[i].sku_code,
                                testJson[i].mt_code,
                                testJson[i].kit_prod,
                                testJson[i].min_prc,
                                testJson[i].min_prc_u,
                                testJson[i].unt_prc,
                                testJson[i].unt_prc_u,
                                testJson[i].sellOutPrice,//changes by Harshit@Wipro
                                testJson[i].sellOutPriceU,//changes by Harshit@Wipro
                                testJson[i].fsp,
                                testJson[i].fsp_u,
                                            
                              //Below 8 lines changes by Harshit@Wipro START

                              testJson[i].GM,
                              testJson[i].GMU,
                              testJson[i].selloutType,
                              testJson[i].selloutTypeU,
                              testJson[i].SelloutFactor,
                              testJson[i].SelloutFactorU,
                              testJson[i].MinPriceFactor,
                              testJson[i].MinPriceFactorU,
                            //END     


                                '<button id="'+testJson[i].pbd_id+'" class="btn-to-hide" style="color:red; font-weight:bold; margin-left:21px; background:#fff; border-radius:3px; border:1px solid #ccc; padding:2px 5px 2px 5px;" name="'+code+'" value="'+i+'" iconName="utility:delete" >X</button>'
                                
                                
                            ]);
                      } catch (error) {
                          //alert('errhello'+error);  
                          component.set("v.showSpinner",false);  
                      }
                            
                        }
                          if(parsed.pc_book.status == 'Draft' || parsed.pc_book.status == 'Disapproved'){
                              $('.btn-to-hide').show();
                          }
                          else{
                              $('.btn-to-hide').hide();
                              $('#tableId').dataTable().fnDraw();
                          }
                          
                          component.set("v.showSpinner",false);
                          $('div.dataTables_filter input').addClass('slds-input');
                          $('div.dataTables_filter input').css("marginBottom", "10px");
                      }, 5000);  
                     
                     
                     
                 }
                    //  component.set('v.materialDetails','');  //changed here...
                    
                    if(parsed.salesDistricts != null){
                        var newWrapperSdt = new Array();
                        var wrappers2 = component.get('v.salesdtarr');
                        for(var j = 0 ;j < parsed.salesDistricts.length;j++){
                            
                            //  console.log('DistId--->'+parsed.salesDistricts[j].Id);
                            newWrapperSdt = {
                                'Id1':parsed.salesDistricts[j].Id,
                                'sdtId': parsed.salesDistricts[j].sdtId,
                                'Name' :parsed.salesDistricts[j].Name,
                                'SDCode':parsed.salesDistricts[j].SDCode
                            };
                            wrappers2.push(newWrapperSdt);                    
                        }
                        component.set("v.salesdtarr",wrappers2);
                        var getSkuAllId = component.find("sdtNameforSales");
                        var isArray = Array.isArray(getSkuAllId);
                        if(isArray){
                            for(var j = 0 ;j < parsed.salesDistricts.length;j++){
                                component.find("sldtUtil")[j].set("v.disabled",true);
                                component.find("lkpdisable")[j].set("v.disabled",true);
                            }
                        }else{
                           // component.find("sldtUtil").set("v.disabled",true);   //updated by GRZ(Dheeraj Sharma) for RITM0496070 25-01-2023
                           // component.find("lkpdisable").set("v.disabled",true);  //updated by GRZ(Dheeraj Sharma) for RITM0496070 25-01-2023
                         }
                    }
                    //  console.log('Approval History....');
                    //  console.log(parsed.approvarList);
                    
                    // //  Added by Sagar@Wipro Start-- 
                    console.log('parsed.cropculs'+JSON.stringify(parsed.cropculs));
                     if(parsed.cropculs != null){
                        var newWrapperSdt1 = new Array();
                        var wrappers3 = component.get('v.cropcularr');
                        for(var j = 0 ;j < parsed.cropculs.length;j++){
                            
                            //  console.log('DistId--->'+parsed.salesDistricts[j].Id);
                            newWrapperSdt1 = {
                                'Id11':parsed.cropculs[j].Id1,
                                'sdtId1': parsed.cropculs[j].sdtId1,
                                'Name1' :parsed.cropculs[j].Name1,
                                'SDCode1':parsed.cropculs[j].SDCode1
                            };
                            wrappers3.push(newWrapperSdt1);
                            console.log('wrappers3**'+JSON.stringify(wrappers3));
                        }
                        component.set("v.cropcularr",wrappers3);
                         var getSkuAllId1 = component.find("sdtNameforSales1");
                        var isArray1 = Array.isArray(getSkuAllId1);
                        if(isArray1){
                            for(var j = 0 ;j < parsed.cropculs.length;j++){
                                component.find("sldtUtil1")[j].set("v.disabled",true);
                                component.find("lkpdisable1")[j].set("v.disabled",true);
                                
                            }
                        }else{
                           // component.find("sldtUtil1").set("v.disabled",true);
                           // component.find("lkpdisable1").set("v.disabled",true);
                        }
                    }
                    //end--   
                    
                    //// //  Added by Sagar@Wipro Start-- 
                     if(parsed.custgrps != null){
                        var newWrapperSdt2 = new Array();
                        var wrappers4 = component.get('v.custgrparr');
                        for(var j = 0 ;j < parsed.custgrps.length;j++){
                            
                            //  console.log('DistId--->'+parsed.salesDistricts[j].Id);
                            newWrapperSdt2 = {
                                'Id2':parsed.custgrps[j].Id1,
                                'sdtId2': parsed.custgrps[j].sdtId2,
                                'Name2' :parsed.custgrps[j].Name2,
                                'SDCode2':parsed.custgrps[j].SDCode2
                            };
                            wrappers4.push(newWrapperSdt2);                    
                        }
                        component.set("v.custgrparr",wrappers4);
                         var getSkuAllId2 = component.find("sdtNameforSales2");
                        var isArray1 = Array.isArray(getSkuAllId2);
                        if(isArray1){
                            for(var j = 0 ;j < parsed.custgrps.length;j++){
                                component.find("sldtUtil2")[j].set("v.disabled",true);
                                component.find("lkpdisable2")[j].set("v.disabled",true);
                                component.set("v.iscustgrp",false);
                            }
                        }else{
                           // component.find("sldtUtil2").set("v.disabled",true);
                           // component.find("lkpdisable2").set("v.disabled",true);
                        }
                    }
                    //end--  
                    
                    //  Added by Sagar@Wipro Start-- 
                     if(parsed.custnames != null){
                        var newWrapperSdt3 = new Array();
                        var wrappers5 = component.get('v.custnamearr');
                        for(var j = 0 ;j < parsed.custnames.length;j++){
                            
                            //  console.log('DistId--->'+parsed.salesDistricts[j].Id);
                            newWrapperSdt3 = {
                              'Id':parsed.custnames[j].Id,
                               // 'sdtId2': parsed.custnames[j].sdtId2,
                                'Name' :parsed.custnames[j].Name,
                                'custgrpname':parsed.custnames[j].PriceConversionGroup
                            };
                            wrappers5.push(newWrapperSdt3);                    
                        }
                        component.set("v.custnamearr",wrappers5);
                         var getSkuAllId3 = component.find("sdtNameforSales3");
                        var isArray3 = Array.isArray(getSkuAllId3);
                        if(isArray3){
                            for(var j = 0 ;j < parsed.custnames.length;j++){
                                component.find("sldtUtil3")[j].set("v.disabled",true);
                                component.find("lkpdisable3")[j].set("v.disabled",true);
                                component.set("v.iscustgrp",false);
                            }
                        }else{
                          //  component.find("sldtUtil3").set("v.disabled",true);
                          //  component.find("lkpdisable3").set("v.disabled",true);
                        }
                    }
                    //end--  
                   
                         
                         
                    if(parsed.approvarList.length>0){       
                        var history = component.get("v.approvalHistory"); 
                        var hisArr =new Array();
                        for(var j = 0 ;j < parsed.approvarList.length;j++){
                            hisArr = {
                                'date_tm':parsed.approvarList[j].date_tm,
                                'user': parsed.approvarList[j].user,
                                'cur_status': parsed.approvarList[j].cur_status,
                                'prev_status' :parsed.approvarList[j].prev_status,
                                'comment':parsed.approvarList[j].comment,
                                'name':parsed.approvarList[j].name
                            };
                            history.push(hisArr);
                        } 
                        
                        component.set("v.approvalHistory",history);
                        
                    }
                    
                    if(parsed.paymentTerms !=null){       
                        
                        var payObjs = component.get('v.paymentTermsWrapper');
                        var paySet= component.get("v.paymentSet"); 
                        var payArr = new Array();
                        
                        for(var k = 0 ;k < parsed.paymentTerms.length;k++){
                            
                            payArr = {
                                'id':parsed.paymentTerms[k].id,
                                'pBook': parsed.paymentTerms[k].pBook,
                                'pt_id': parsed.paymentTerms[k].pt_id,
                                'pt_name' :parsed.paymentTerms[k].pt_name,
                                'pt_type':parsed.paymentTerms[k].pt_type
                            };
                            payObjs.push(payArr);
                            paySet.push(parsed.paymentTerms[k].pt_name);
                            
                        } 
                        component.set('v.paymentTermsWrapper',payObjs);
                       
                    }
                    
                    
                    component.set("v.hide11",false); // hide choose file button....
                    if(parsed.pc_book.status == 'Draft' || parsed.pc_book.status == 'Disapproved'){
                        // code added by Sagar@Wipro start--
                        component.set("v.isEdit",false);
                        component.find("apply_percentage").set("v.disabled",false);
                        component.find("apply_simulation").set("v.disabled",false);
                        component.find("apply_disc").set("v.disabled",false);
                        component.find("apply_MinPrice").set("v.disabled",false);
                        // end--
                        
                        component.find("checkbox-id-01").set("v.disabled",true);
                        //component.find("priceBookName").set("v.disabled",true);
                        component.find("currencyID").set("v.disabled",true);
                        component.find("DivisionName").set("v.disabled",true);
                        component.find("searchUtil").set("v.disabled",true);
                        component.find("DivisionName").set("v.disabled",true);
                        component.find("imprtbtn").set("v.disabled",true);  
                        // component.find("addDistbtn").set("v.disabled",true);
                        
                        if(parsed.pc_book.pb_for_cmpgn == true){
                            component.find("radio1").set("v.disabled",true);
                            component.find("radio2").set("v.disabled",true); 
                            //component.set("v.hideDeleteBtn",true);
                            component.find("updateBtn").set("v.disabled",false);  
                        }
                        
                        if(parsed.pc_book.isActive == true){
                            component.find("approvalBtnId").set("v.disabled",false);
                            component.find("deactivateBtnId").set("v.disabled",false);
                        }
                        
                    }
                    else{
                        
                        component.find("checkbox-id-01").set("v.disabled",true);
                        component.find("priceBookName").set("v.disabled",true);
                        component.find("currencyID").set("v.disabled",true);
                        component.find("validfrmId").set("v.disabled",true);
                        component.find("expiryId").set("v.disabled",true);
                        component.find("lastMonth").set("v.disabled",true);
                        component.find("crUsdRate").set("v.disabled",true);
                        //component.find("expiryId").set("v.disabled",true);
                        component.find("DivisionName").set("v.disabled",true);
                        //component.find("addDistbtn").set("v.disabled",true);
                        //component.find("addDistbtn").set("v.disabled",true);
                        component.find("int_rate_R").set("v.disabled",true);
                        component.find("int_rate_U").set("v.disabled",true);
                        component.find("DivisionName").set("v.disabled",true);
                        component.find("searchUtil").set("v.disabled",true);
                        //component.find("imprtbtn").set("v.disabled",true);
                        //document.getElementById("file").disabled = true;
                        // component.set("v.hide8",false);
                        component.find("updateBtn").set("v.disabled",true);
                        //component.find("addDistbtn").set("v.disabled",true);
                        
                        //component.find("skuName").set("v.disabled",true);
                       // component.find("skulkp").set("v.disabled",true);  //updated by GRZ(Dheeraj Sharma) for RITM0496070 25-01-2023
                        // component.find("SkuCode1").set("v.disabled",true);
                        component.find("minPriceR").set("v.disabled",true);
                        component.find("minPriceU").set("v.disabled",true);
                        component.find("unitPriceR").set("v.disabled",true);
                        component.find("unitPriceU").set("v.disabled",true);
                        component.find("fspR").set("v.disabled",true);
                        component.find("fspU").set("v.disabled",true);
                        component.find("addbtn").set("v.disabled",true);
                        
                        if(parsed.pc_book.pb_for_cmpgn == true){
                            component.find("radio1").set("v.disabled",true);
                            component.find("radio2").set("v.disabled",true);
                            component.find("blck_dt").set("v.disabled",true);
                            component.find("intr_dt").set("v.disabled",true);
                            
                            component.set("v.hideDeleteBtn",false);
                        }
                        
                        if(parsed.pc_book.isActive == true){
                            
                            component.find("deactivateBtnId").set("v.disabled",false);
                        }                       
                        
                    }
                    
                }
                //  component.set("v.showSpinner",false);
            }
             else{
                 component.set("v.showSpinner",false);
             } 
             
             
         });
        
        $A.enqueueAction(action);	
    },
    
    updatePriceBook:function(component, event, helper, priceBook, mtFile, mtFileDelete, payObjs, payObjsDelete, arrOfSalesdist,arrOfSalesdist1,arrOfcustgrps,arrOfcustnames){
        //  console.log('updatePriceBook called..');
        //  console.log(priceBook);
        //  console.log(mtFile);
        //  console.log(mtFileDelete);
        
        var action = component.get("c.updateNewPriceBook");
        
        action.setParams({
            "price_book":JSON.stringify(priceBook),
            "sku_file":JSON.stringify(mtFile),
            "sku_fileToDelete":JSON.stringify(mtFileDelete),
            "paymentTerms":JSON.stringify(payObjs),
            "paymentTermsToDelete":JSON.stringify(payObjsDelete),
            "salesDistArray":JSON.stringify(arrOfSalesdist),
            "cropCulArray":JSON.stringify(arrOfSalesdist1),
             "custGrpArray":JSON.stringify(arrOfcustgrps),
            "custNameArray":JSON.stringify(arrOfcustnames),
            "cropCultureId":component.get("v.fnlList")
        });
        
        action.setCallback(this,function(response){
            //  console.log(response.getError());
            if(response.getState() == 'SUCCESS'){
                //  console.log(response.getReturnValue()); 
                //  alert('Price and Scheme Details Added Successfully..'); 
                
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
                
                this.gotoListviewHelper(component,'draft');
                
                
            } 
            // component.set("v.showSubmitSpinner",false);
            component.set("v.showSpinner",false);
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
//added by wipro
fetchCropCultures : function(cmp) {
        //alert('1');
        var action = cmp.get("c.getCropCultures");
        //Column data for the table
        //Do not chnage the column names 
        var accountColumns = [
            {
                'label':$A.get("$Label.c.Crop_Culture_Name"),
                'name':'Name',
                'type':'string',
                'value':'Id',
                //'width': 100,
                'resizeable':true
            },
            {
                'label':$A.get("$Label.c.Crop_Culture_Code"),
                //'label':'Sales District Code',
                'name':'Culture_Code__c',
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
                    "id":"salectDist1",
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
 /* start code added by javed(Grazitti) for RITM0463334 23-12-2022*/
buildData : function(component, helper) {
    var data = [];
    var pageNumber = component.get("v.currentPageNumber");
    var pageSize = component.get("v.pageSize");
    var allData = component.get("v.cropDataList");
    var selectedOptionForSize = component.get("v.selectedOptionForSize");
    var x = (pageNumber-1)*selectedOptionForSize;
    for(; x<=((pageNumber)*selectedOptionForSize)-1; x++){
        if(allData[x]){
           // data.push("isSelected""true");
            data.push(allData[x]);
        }
    }
    component.set("v.cropData", data);
    console.log('cropData===>> ', data);
    console.log('v.selectedOptionForSize===>> ', component.get('v.selectedOptionForSize'));
    console.log('allData===>> ', allData[0]);
    this.generatePageList(component, pageNumber);
},

    generatePageList : function(component, pageNumber){
    pageNumber = parseInt(pageNumber);
    console.log('pageNumber +++ ', pageNumber);
    var pageList = [];
    var totalPages = component.get("v.totalPages");
    console.log('totalPages ', totalPages);
    var pages2show = component.get("v.pages2show");
    console.log('pages2show ', pages2show);
    
    
    
    if(totalPages > 0  && pageNumber > 1 && pageNumber < totalPages && totalPages>pages2show){
               pageList.push(pageNumber-1, pageNumber, pageNumber+1);
    }
    else if(pageNumber == 1 && totalPages>pages2show){
        pageList.push(null, pageNumber, pageNumber+1);
    }
    
    else if(pageNumber == totalPages && totalPages>pages2show){
            pageList.push(pageNumber-1, pageNumber, null);
    }
   
    else if(totalPages > 0  && totalPages<pages2show){
        for(var i=0;i<pages2show;i++){
            if((pageNumber+i)<=totalPages && pageNumber>0){ 
               pageList.push(pageNumber+i);
            }
        }
    }
    console.log('PageNumbereeeee   ++ ', pageNumber);
    console.log('pagelist++++>>>>> ', pageList);
    component.set("v.pageList", pageList);
},
 /* end code added by javed(Grazitti) for RITM0463334 23-12-2022*/
fetchCustomerGroups : function(cmp) {
        //alert('1');
        var action = cmp.get("c.getCustmerGroups");
        //Column data for the table
        //Do not chnage the column names 
        var accountColumns = [
           /* {
                'label':$A.get("$Label.c.Customer_Group_Name"),
                'name':'Name',
                'type':'string',
                'value':'Id',
                //'width': 100,
                'resizeable':true
            },*/
            {
                'label':$A.get("$Label.c.Customer_Group_Code"),
                //'label':'Sales District Code',
                'name':'Customer_Group__c',
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
                    "id":"salectDist2",
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
    
    fetchCustomerNames : function(component,custid1) {
       
        var custgrparr = component.get("v.custgrparr");
        console.log('custgrparr'+JSON.stringify(custgrparr));
        
         console.log('custgrparr'+JSON.stringify(custgrparr));
        var List =component.get("v.custgrplist");
        //var List;
        let len= custgrparr.length;
        console.log('len**',len);
        for(var i = 0; i < custgrparr.length; i++){
            
            var listOfSku = custgrparr[i].SDCode2;
            
            console.log('listOfSku',listOfSku);
            List.push(listOfSku);
        }
        component.set("v.custgrplist",'');
        component.set("v.custgrplist",List);
        console.log('custgrplist1212**'+component.get("v.custgrplist"));
        var List2 =component.get("v.custgrplist");
        console.log(' custgrplist**'+JSON.stringify(List2));
        var action = component.get("c.getCustmerNames");
        action.setParams({ 
            "custGrpArray": JSON.stringify(custgrparr)
        });
        var accountColumns = [
             {
                'label':$A.get("$Label.c.Customer_Group_Code"),
                //'label':'Sales District Code',
                'name':'Customer_Group__c',
                'type':'string',
                'value':'Id',
                //'width': 100,
                'resizeable':true
            },
            {
                'label':$A.get("$Label.c.SAP_Customer_Code"),
                'name':'SAP_Code__c',
                'type':'string',
                'value':'Id',
                //'width': 100,
                'resizeable':true
            },
            {
                'label':$A.get("$Label.c.CustomerName"),
                'name':'Name',
                'type':'string',
                'value':'Id',
                //'width': 100,
                'resizeable':true
            },
            {
                'label':$A.get("$Label.c.Billing_City"),
                //'label':'Sales District Code',
                'name':'BillingCity',
                'type':'string',
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
                    "id":"salectcust",
                    //'width': 100,
                    'resizeable':true
                }]
    };
    
    action.setCallback(this,function(resp){
    var state = resp.getState();
    if(component.isValid() && state === 'SUCCESS'){
    
    component.set("v.accountList",resp.getReturnValue());
    component.set("v.accountColumns",accountColumns);
    component.set("v.accountTableConfig",accountTableConfig);
    component.find("accountTable").initialize({
    "order":[0,"asc"]
});
}else{
    console.log(resp.getError());
}
});
$A.enqueueAction(action);

}, 
    
    removeSalesDist : function(component, index) {
        
        
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
    removeCropCulture : function(component, index) {
        
        
        var divError = component.get("v.showduplicateErr");
        if(divError){
            component.set("v.showduplicateErr", false);
        }
        var divError1 = component.get("v.showErrOnDiv");
        if(divError1){
            component.set("v.showErrOnDiv", false);
        }
        
        var node = component.get("v.cropcularr");
        node.splice(index, 1);
        component.set("v.cropcularr", node);
    }, 
        removeCustomerGroup : function(component, index) {
        
        
        var divError = component.get("v.showduplicateErr");
        if(divError){
            component.set("v.showduplicateErr", false);
        }
        var divError1 = component.get("v.showErrOnDiv");
        if(divError1){
            component.set("v.showErrOnDiv", false);
        }
        
        var node = component.get("v.custgrparr");
        node.splice(index, 1);
        component.set("v.custgrparr", node);
    }, 
        
          removeCustomerName : function(component, index) {
        
        
        var divError = component.get("v.showduplicateErr");
        if(divError){
            component.set("v.showduplicateErr", false);
        }
        var divError1 = component.get("v.showErrOnDiv");
        if(divError1){
            component.set("v.showErrOnDiv", false);
        }
        
        var node = component.get("v.custnamearr");
        node.splice(index, 1);
        component.set("v.custnamearr", node);
    }, 
        
        loadSKUDescription: function(cmp) {
            //  console.log('loadSKUDescription called...');
            var action = cmp.get("c.skuDescriptionMap");
            
            action.setCallback(this,function(resp){
                var state = resp.getState();
                if(cmp.isValid() && state === 'SUCCESS'){
                    //  //  console.log('loadSKUDescription response..... '+resp.getReturnValue());
                    cmp.set("v.skuDescription",resp.getReturnValue());
                    
                }else{
                    console.log(resp.getError());
                }
            });
            $A.enqueueAction(action);
            
        },
            
            loadPaymentTerms : function(cmp) {
                //  console.log('loadPaymentTerms called...');
                var action = cmp.get("c.getPaymentTerms");
                
                action.setCallback(this,function(resp){
                    var state = resp.getState();
                    if(cmp.isValid() && state === 'SUCCESS'){
                        //  console.log('response..... '+resp.getReturnValue());
                        cmp.set("v.paymentTerms",resp.getReturnValue());
                        
                    }else{
                        console.log(resp.getError());
                    }
                });
                $A.enqueueAction(action);
                
            },
                
                
                sentForApproval : function(cmp,recordId,helper) {
                    //  console.log('sentForApproval called...');
                    var action = cmp.get("c.submitForApproval");
                    cmp.set("v.recordsId", recordId);//added by Atish
                    console.log('inside else 2');
                    
                    action.setParams({
                        "priceBookId":recordId
                    });
                    
                    action.setCallback(this,function(resp){
                        var state = resp.getState();
                        if(cmp.isValid() && state === 'SUCCESS'){
                               //added by Atish
                               var responseValues = resp.getReturnValue();
                               cmp.set("v.filesUpload", responseValues);
                            //  console.log('response..... '+resp.getReturnValue());
                            
                            var toastEvent = $A.get("e.force:showToast");
                            var successMsg  = $A.get("{!$Label.c.Price_Book_is_Sent_For_Approval}");
                            var successMsg1  = $A.get("{!$Label.c.Success}");
                            //var successMsg = '{!$Label.c.Price_Book_Updated_Successfully}';
                            toastEvent.setParams({
                                "title": successMsg1,
                                "type": "Success",
                                "message": successMsg
                            });
                            toastEvent.fire();
                            
   //this.gotoListviewHelper(cmp,'pending');
   this.getMyAttachments(cmp, helper); //added by Atish                               
                        }else{
                            console.log(resp.getError());
                            cmp.set("v.showSpinner",false);
                        }
            //added by Atish
            cmp.set("v.showSpinner", false);
            //alert('checking'+component.get("v.PriceBook"));
            cmp.set("v.isModalOpen", true); 
        });
                    $A.enqueueAction(action);
                },
                //added by Atish
                getMyAttachments: function(component, helper) {
                    //alert('calling getMyattachments');
                                 console.log('inside else 4');

                    var action = component.get("c.getUploadItems");
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        var values = response.getReturnValue();
                        var check = response.getReturnValue();
                        if (state === "SUCCESS") {
                            component.set("v.testUpload", response.getReturnValue());
                            //alert(values+'state');
                            console.log(values + "state");
                        }
                        component.set("v.isfinalModalOpen", true); //add if  condition
                    });
                    $A.enqueueAction(action);
                },
                    
                    activeDeactive : function(cmp,event,recordId, strVal) {
                        //  console.log('activeDeactive called...');
                        var action = cmp.get("c.setActiveDeactive");
                        var successMsg  = '';
                        
                        if(strVal == 'true'){
                            successMsg  = $A.get("{!$Label.c.Price_Book_Activated_Successfully}");
                        }
                        else{
                            successMsg  = $A.get("{!$Label.c.Price_Book_Deactivated_Successfully}");
                        }
                        
                        action.setParams({
                            "priceBookId":recordId,
                            "value":strVal
                        });
                        
                        action.setCallback(this,function(resp){
                            var state = resp.getState();
                            if(cmp.isValid() && state === 'SUCCESS'){
                                //  console.log('response..... '+resp.getReturnValue());
                                
                                var toastEvent = $A.get("e.force:showToast");
                                
                                var successMsg1  = $A.get("{!$Label.c.Success}");
                                //var successMsg = '{!$Label.c.Price_Book_Updated_Successfully}';
                                toastEvent.setParams({
                                    "title": successMsg1,
                                    "type": "Success",
                                    "message": successMsg
                                });
                                toastEvent.fire();
                                
                                this.gotoListviewHelper(cmp,'canceled');
                                
                            }else{
                                console.log(resp.getError());
                                cmp.set("v.showSpinner",false);
                            }
                            cmp.set("v.showSpinner",false);
                        });
                        $A.enqueueAction(action);
                        
                    },
                        
                        clonePriceBook:function(component, event, helper, priceBook, mtFile, arrOfSalesdist,arrOfSalesdist1,arrOfcustgrps,arrOfcustnames, payObjs){
                            //  console.log('clonePriceBook called..');
                            //  console.log(priceBook);
                            //  console.log(mtFile);
                            //  console.log(arrOfSalesdist);
                            //  console.log(payObjs);
                            
                            var action = component.get("c.cloneNewPriceBook");
                            
                            //alert('clone'+component.get("v.Price_Book_For_Kit"));
                            action.setParams({
                                "price_book":JSON.stringify(priceBook),
                                "sku_file":JSON.stringify(mtFile),
                                "salesDistArray":JSON.stringify(arrOfSalesdist),
                                "cropCulArray":JSON.stringify(arrOfSalesdist1),
                                "custGrpArray":JSON.stringify(arrOfcustgrps),
                                "custNameArray":JSON.stringify(arrOfcustnames),
                                "paymentTerms":JSON.stringify(payObjs),
								 "cropCultureId":component.get("v.fnlList") // added by javed(Grazitti) for RITM0463334 23-12-2022
                            });
                            
                            action.setCallback(this,function(response){
                                //  console.log(response.getError());
                                if(response.getState() == 'SUCCESS'){
                                    //  console.log(response.getReturnValue()); 
                                    var resp = response.getReturnValue();
                                    //  alert('Price and Scheme Details Added Successfully..'); 
                                    
                                    if(resp == 'true'){
                                        
                                        var successMsg  = $A.get("{!$Label.c.Price_Book_Cloned_Successfully}"); 
                                        var successMsg1 = $A.get("{!$Label.c.Success}");
                                        var toastEvent = $A.get("e.force:showToast");
                                        toastEvent.setParams({
                                            "title": successMsg1,
                                            "type": "Success",
                                            "message": successMsg
                                        });
                                        toastEvent.fire();
                                    }
                                    else if(resp == 'false'){
                                        var successMsg  = $A.get("{!$Label.c.Failed_to_Create_Error_Occurred}"); 
                                        var successMsg1 = $A.get("{!$Label.c.Error}");
                                        var toastEvent = $A.get("e.force:showToast");
                                        toastEvent.setParams({
                                            "title": successMsg1,
                                            "type": "Error",
                                            "message": successMsg
                                            
                                        });
                                        toastEvent.fire();
                                    }
                                        else{
                                            //  console.log('Response on create...'); 
                                            //  console.log(resp);
                                            var successMsg  =$A.get("{!$Label.c.Price_Book_Cloned_Successfully}")+' \n'+ $A.get("{!$Label.c.SKU_Not_Valid_or_Not_Present_in_Database}")+' \n'+ resp+' \n'; 
                                            var successMsg1 = $A.get("{!$Label.c.Warning}");
                                            var toastEvent = $A.get("e.force:showToast");
                                            toastEvent.setParams({
                                                "title": successMsg1,
                                                "type": "Warning",
                                                "message": successMsg,
                                                "duration":'150000'
                                            });
                                            toastEvent.fire();
                                        }
                                    
                                    
                                    this.gotoListviewHelper(component,'draft');
                                   //this.getMyAttachments(component, helper); //added by Atish
                                } 
                                // component.set("v.showSubmitSpinner",false);
                                component.set("v.showSpinner",false);
                            });
                            
                            $A.enqueueAction(action);	
                        },
                            
                            fetchSku : function(cmp) {
                                var pbType=cmp.get("v.priceBookType");
                                
                                var divName = cmp.find("HiddenDivisionName"); 
                                var divActName = divName.get("v.value");
                                //alert(divActName);
                                var pbKit=cmp.get("v.Price_Book_For_Kit");
                                var action = cmp.get("c.getSku");
                                action.setParams({ "divisionId" : divActName,
                                                  "pbKit" :pbKit
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
                                        'label':$A.get("$Label.c.Category"),
                                        'name':'Product_Category__c',
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
                                        
                                    },
                                    //added Brand Column - Swapnil
                                    {
                                        'label':'Brand',
                                        'name':'Brand_Name__c',
                                        'type':'string',
                                        'value':'Id',
                                        //'width': 50,
                                        
                                    }
                                    //End
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
                                        //alert(resp.getReturnValue());
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
                                //added for kit on change of pricebook type set the values
                                onRadioSelect:function(component, event, helper){
                                    //var currecny = component.find("checkbox-id-01").get("v.value"); 
                                    var val1=event.getSource().get('v.value');
                                    // alert(isChecked);
                                    
                                    // var checkbox = document.getElementById('checkbox-id-01');
                                    if(val1=='Price Book For Campaign'){
                                        component.set("v.hide1",true);
                                        
                                        component.set("v.hide4",true);
                                        
                                        component.set("v.pb_for_campaign",true);
                                        component.set("v.priceBookType",val1);
                                        component.set("v.campaignType","Simple");
                                        component.find("radio1").set("v.checked", true);
                                        helper.loadPaymentTerms(component);
                                    }
                                    else if(val1=='Normal Pricebook'){
                                        component.set("v.hide1",false);
                                        
                                        component.set("v.hide4",false);
                                        component.set("v.campaignType","");
                                        component.set("v.pb_for_campaign",false);
                                        component.set("v.priceBookType",val1);
                                        //component.find("radio1").set("v.checked", false);
                                    }else if(val1=='Price Book For Kit'){
                                        //alert('hello');
                                        component.set("v.priceBookType",val1);
                                        component.set("v.hide1",false);
                                        component.set("v.hide4",false);
                                        component.set("v.pb_for_campaign",false);
                                        component.set("v.campaignType","");
                                        }else if(val1=='AVEC Price Book'){ //added by wipro
                                            component.set("v.hide1",false);
                                            component.set("v.hide4",true);
                                            component.set("v.pb_for_campaign",false);
                                            component.set("v.Price_Book_For_Kit",false);
                                            component.set("v.pb_for_avec",true);
                                            component.set("v.priceBookType",val1);
                                            component.set("v.campaignType","Simple");
                                           // component.find("radio1").set("v.checked", true);
                                          //  helper.loadPaymentTerms(component);
                                    }
                                    
                                    component.find("DivisionName").set("v.disabled",true);
                                },
                                    //modified for kit ,if kit pb,set values accordingly
                                    toggleCheck: function(component, event, helper){ 
                                        //changed from checkbox to radio
                                        var isChecked = component.get("v.Price_Book_For_Campaign");// kindly check and make changes in same method in controller as well....
                                        //var currecny = component.find("checkbox-id-01").get("v.value"); 
                                        var pbooktype = component.get("v.priceBookType");
                                        var pbKit=component.get("v.Price_Book_For_Kit");
                                        var ctype=component.get("v.campaignType");
                                        //alert(pbKit);
                                        if(pbooktype!=null && pbooktype!='' && pbooktype!=undefined){
                                            //alert('innew'+pbooktype);
                                            component.find("checkbox-id-01").set("v.value",pbooktype);
                                        }
                                        //alert(isChecked);
                                        
                                        // var checkbox = document.getElementById('checkbox-id-01');
                                        if(isChecked){
                                            //alert('in1');
                                            component.set("v.hide1",true);
                                            
                                            component.set("v.hide4",true);
                                            
                                            component.set("v.pb_for_campaign",true);
                                            component.set("v.campaignType","Simple");
                                            component.find("radio1").set("v.checked", true);
                                            //component.find("radi2").set("v.checked", true);
                                            component.set("v.Price_Book_For_Kit",false);
                                            //alert(component.find("radi2").get("v.checked"));
                                            
                                            helper.loadPaymentTerms(component);
                                        }
                                        else{
                                            //alert('in2'+pbooktype+component.find("checkbox-id-01").get("v.value")+component.get("v.Price_Book_For_Kit"));
                                            //component.find("radio1").set("v.checked", false);
                                            component.set("v.hide1",false);
                                            component.set("v.hide4",false);
                                            component.set("v.pb_for_campaign",false);
                                            component.set("v.campaignType","");
                                            
                                            
                                            
                                        }
                                        component.find("DivisionName").set("v.disabled",true);
                                    },
                                        
                                        
                                        getTypeOfCamaign : function(cmp,event,recordId) {
                                            //  console.log('getTypeOfCamaign called...');
                                            var action = cmp.get("c.getCampaigntype");
                                            var flag=false;
                                            action.setParams({
                                                "priceBookId":recordId
                                            });
                                            
                                            action.setCallback(this,function(resp){
                                                var state = resp.getState();
                                                if(cmp.isValid() && state === 'SUCCESS'){
                                                    //  console.log('response..... '+resp.getReturnValue());
                                                    // alert(resp.getReturnValue());
                                                    // cmp.set("v.cmpType",resp.getReturnValue());
                                                    // alert(cmp.get("v.cmpType"));
                                                    
                                                    var cmpTyp =resp.getReturnValue();
                                                    //alert(result);
                                                    
                                                    if(cmpTyp == 'Structured'){
                                                        var evt = $A.get("e.force:navigateToComponent");
                                                        evt.setParams({
                                                            componentDef  : "c:StructuredCampaign" ,
                                                            componentAttributes  : {
                                                                recordId :recordId 
                                                            }
                                                        });
                                                        //  console.log('Event '+evt);
                                                        evt.fire();
                                                    }
                                                    else{
                                                        this.editPriceBookNew(cmp,recordId);
                                                    }
                                                    
                                                }else{
                                                    console.log(resp.getError());
                                                    cmp.set("v.showSpinner",false);
                                                }
                                                cmp.set("v.showSpinner",false);
                                            });
                                            $A.enqueueAction(action);
                                            
                                        },
                                            //addded by Swapnil    
                                            getMasterDataHelper: function(component, event, helper){  
                                                var action = component.get("c.getMasterdata");
                                                
                                                action.setCallback(this, function(response) {
                                                    var state = response.getState();
                                                    if (state === "SUCCESS") {
                                                        component.set("v.LiMarketVariation", response.getReturnValue().MarketVariation);
                                                        component.set("v.LiSalesDistrictCost", response.getReturnValue().SalesDistrictCost);
                                                        component.set("v.LiDiscountMatrix", response.getReturnValue().DiscountMatrix);
                                                        //component.set("v.mapSKUBrand", response.getReturnValue().mapSKUBrand);
                                                        component.set("v.SalesOrg", response.getReturnValue().SalesOrg);
                                                        console.log('test'+component.get("v.LiMarketVariation"));
                                                        console.log('test2'+component.get("v.LiSalesDistrictCost"));
                                                        console.log('test3'+component.get("v.LiDiscountMatrix"));
                                                        console.log('test4'+component.get("v.SalesOrg"));
                                                        
                                                    }
                                                    
                                                });
                                                $A.enqueueAction(action); 
                                            },
                                             //added by Atish
    getuploadedFiles: function(component) {
        var action = component.get("c.getFiles");
        action.setParams({
            recordId: component.get("v.testUpload"),
            filepricelistIds: component.get("v.insertedPriceBookIds")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var result = response.getReturnValue();
                 component.set("v.disableThis",true);//added by Atish@Wipro

                console.log("result is ",result);
                
                /*if(result.length > 1){
                      var toastEvent = $A.get("e.force:showToast");
                        var msg  = "You cannot upload more then one file";
                        var titl  = "File cannot uploaded";
                        toastEvent.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg,
                            "duration":'3000'
                        });
                        toastEvent.fire();
                        return;
                    
                }*/
              component.set("v.files", result);

           

            }
        });
        $A.enqueueAction(action);
    },
    getMyTasks: function(component) {
        var action = component.get("c.getUplFiles");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.ContentDocumentfiles", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    delUploadedfiles: function(component, documentId) {
        console.log('component.get("v.insertedPriceBookIds")',component.get("v.insertedPriceBookIds"));
        var action = component.get("c.deleteFiles");
        action.setParams({
            sdocumentId: documentId,
            filepricelistIds:component.get("v.insertedPriceBookIds")//added by Atish@Wipro
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                 component.set("v.disableThis",false);//Added by Atish@Wipro

                console.log('inside if 1');
               // this.getuploadedFiles(component);//Added by Atish@wipro
                component.set("v.Spinner", false);
                //console.log('inside if2');
            }
        });
        $A.enqueueAction(action);
    },
    //end                      
                                                validateSalesDistrict: function(component, event, helper, Salesdist){
                                                    console.log('Salesdist '+JSON.stringify(Salesdist));
                                                    var md = component.get("v.materialDetails");
                                                    var flag = false;
                                                    var action;
                                                    if(component.get("v.Price_Book_For_Kit")==true){
                                                        action = component.get("c.SKUValidationKIT");
                                                        action.setParams({ LiSKU :  JSON.stringify(md),
                                                                          salesDistArray:JSON.stringify(Salesdist),
                                                                          kitPb:component.get("v.Price_Book_For_Kit")});//liSKUCode
                                                    }else{
                                                        action = component.get("c.SKUValidation");
                                                        action.setParams({ LiSKU :  JSON.stringify(md),
                                                                          salesDistArray:JSON.stringify(Salesdist)});//liSKUCode
                                                    }
                                                    //kitPb:component.get("v.Price_Book_For_Kit")
                                                    
                                                    action.setCallback(this, function(response) {
                                                        var state = response.getState();
                                                        if (state === "SUCCESS") {
                                                            
                                                            if(response.getReturnValue().ErrorString.length>0){
                                                                var toastEvent = $A.get("e.force:showToast");                        
                                                                toastEvent.setParams({
                                                                    "title": $A.get("{!$Label.c.Error}"),
                                                                    "type": "warning",
                                                                    "message": response.getReturnValue().ErrorString
                                                                });
                                                                toastEvent.fire();
                                                            }
                                                            if(response.getReturnValue().FinalSKUList.length>0) { 
                                                                console.log('return '+response.getReturnValue().FinalSKUList);
                                                                component.set("v.materialDetails", response.getReturnValue().FinalSKUList);
                                                                flag = true;
                                                                var skDet = response.getReturnValue().FinalSKUList;
                                                                console.log('skDet '+skDet);
                                                                if(flag){
                                                                    
                                                                    
                                                                    $('#tableId').dataTable().fnClearTable();
                                                                    
                                                                    
                                                                    setTimeout(function(){ 
                                                                        // $('#tableId').DataTable();
                                                                        // console.log(JSON.parse(JSON.stringify(skDet)));
                                                                        var testJson = JSON.parse(JSON.stringify(skDet));
                                                                        
                                                                        var length = testJson.length;
                                                                        for(var i = 0; i < length; i++) {
                                                                            var count=i;
                                                                            try {
                                                                                
                                                                                $('#tableId').dataTable().fnAddData( [
                                                                                    
                                                                                    testJson[i].sku_code,
                                                                                    testJson[i].mt_code,
                                                                                    testJson[i].kit_prod,
                                                                                    testJson[i].min_prc,
                                                                                    testJson[i].min_prc_u,
                                                                                    testJson[i].unt_prc,
                                                                                    testJson[i].unt_prc_u,
                                                                                    testJson[i].sellOutPrice,//changes by Harshit@Wipro
                                                                                    testJson[i].sellOutPriceU,//changes by Harshit@Wipro
                                                                                    testJson[i].fsp,
                                                                                    testJson[i].fsp_u,
                                                                                        
                                                                                     //Below 8 lines changes by Harshit@Wipro START

                                                                                            testJson[i].GM,
                                                                                            testJson[i].GMU,
                                                                                            testJson[i].selloutType,
                                                                                            testJson[i].selloutTypeU,
                                                                                            testJson[i].SelloutFactor,
                                                                                            testJson[i].SelloutFactorU,
                                                                                            testJson[i].MinPriceFactor,
                                                                                            testJson[i].MinPriceFactorU,
                                                                                        //END     

                                                                                    '<button class="btn-to-hide" style="color:red; font-weight:bold; margin-left:21px; background:#fff; border-radius:3px; border:1px solid #ccc; padding:2px 5px 2px 5px;" id="" name="'+testJson[i].sku_code+'" value="'+i+'" iconName="utility:delete">X</button>'
                                                                                    
                                                                                    
                                                                                    
                                                                                ]);
                                                                            } catch (error) {
                                                                                console.log(error);  
                                                                                component.find("file").getElement().value='';
                                                                                component.set("v.showSpinner",false);  
                                                                            }
                                                                        }
                                                                        component.set('v.count',count+1); 
                                                                        component.set("v.clearTableData",true);
                                                                        component.set("v.showSpinner",false);   
                                                                        $('div.dataTables_filter input').addClass('slds-input');
                                                                        $('div.dataTables_filter input').css("marginBottom", "10px");
                                                                    }, 5000);  
                                                                }
                                                                else{
                                                                    
                                                                    component.set("v.showSpinner",false);
                                                                }
                                                            }
                                                            else{
                                                                component.set("v.showSpinner",false);
                                                                component.find("file").getElement().value='';
                                                                var emptySKU = [];
                                                                component.set("v.uniqueSKU", emptySKU);
                                                                component.set("v.materialDetails", emptySKU);
                                                                $('#tableId').dataTable().fnClearTable();
                                                                //console.log('SKU '+Component.get("v.uniqueSKU"));
                                                                flag = false;
                                                            }
                                                            
                                                        }
                                                    });
                                                    $A.enqueueAction(action);
                                                    
                                                    
                                                    
                                                },
                                                // code added by Sagar@Wipro MPO-001 for fetching Material Plant Relation records wrt Depot code
                                                        mterialplanrecords1: function(component, event, helper,depot1){ 
                                                        var depot2=depot1;
                                                             console.log('depot2'+depot2);
                                                        var action = component.get("c.materialPlantrecordfetch");
                                              action.setParams({ "depotcode" : depot1 });
                                                action.setCallback(this, function(response) {
                                                    var state = response.getState();
                                                    if (state === "SUCCESS") {
                                                        component.set("v.mterialplanrecords", response.getReturnValue());
                                                        var list=JSON.stringify(component.get("v.mterialplanrecords"));
                                                        //Var lsit1=JSON.stringify(list);
                                                        console.log('test4'+list);
                                                        
                                                    }
                                                    
                                                });
                                                $A.enqueueAction(action); 
                                                        },
                                                    
    // Added by Krishanu Mallik Thakur and Ankita Tripathy @WIPRO
    getConversionFactor: function(component, event, brand) {
        var action = component.get("c.getConversionFactor");
        action.setParams({
            Brand: brand
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log("test", state);
            if (state === "SUCCESS") {
                component.set("v.cfWrap", response.getReturnValue());
                console.log(component.get("v.cfWrap"));
            }
        });
        $A.enqueueAction(action);
    },
	// Added by Krishanu Mallik Thakur and Ankita Tripathy @WIPRO
    getSellOutMatrix:function(component, event, helper){
        var action = component.get("c.getSelloutMinpriceFactor");
        action.setCallback(this, function(response) {
            var state = response.getState();
            //console.log("test", state);
            if (state === "SUCCESS") {
                component.set("v.selloutMatrix", response.getReturnValue());
                console.log(component.get("v.selloutMatrix"));
            }
        });
        $A.enqueueAction(action);
    },
        getCurrentER:function(component, event, helper){
        var action = component.get("c.getCurrentExchangeRate");
        action.setCallback(this, function(response) {
            var state = response.getState();
            //console.log("test", state);
            if (state === "SUCCESS") {
                component.set("v.exchangeRate", response.getReturnValue());
                console.log(component.get("v.exchangeRate"));
            }
        });
        $A.enqueueAction(action);
    }                                     
      //end   























































})