({    
    scriptsLoaded : function(component, event, helper) {
        //  console.log('Script loaded..'); 
        //location.reload(true);
        //alert('helloscriptsload');
        if ( ! $.fn.DataTable.isDataTable( '#tableId' ) ) {
            //alert('drawtable');
            $("#tableId").dataTable();
        }
        else{
            //alert('elsetable');
            location.reload(true);
            /*  if(component.get("v.reload")==true){
                  $("#tableId").dataTable();
              }else{
              
              }*/
              //alert(component.get("v.priceBookType")+component.get("v.campaignType"));
          }
        
        // $("#tableId").DataTable();
        
        // alert($A.localizationService.formatDate('2019-02-21', "yyyy-dd-MM"));
        
        $('#tableId').on("click", "button", function(){
            //alert('remove');
            /*      var locations= component.get('v.materialDetails');
       //  alert(locations.length);
          var index = $(this).attr("value");
          
         // alert(id);
          if (index > -1) {
               // alert(index);
            locations.splice(index, 1);
           }
         //  alert(locations.length);
        //   locations =  JSON.parse(JSON.stringify(locations));
             console.log(locations);
         component.set("v.materialDetails",locations);*/
            
            var id= $(this).attr("id");
            var val= $(this).attr("value");
            var nm= $(this).attr("name");
            var code='';
            if(component.get("v.Price_Book_For_Kit")==true){
                var nmsplt=nm.split("#");
                var mystring=nmsplt[0];
            }
            var skuSet = component.get('v.uniqueSKU');
            if(id){
                //added if for kit ,split with # and add to materialdelete
                if(component.get("v.Price_Book_For_Kit")==true){
                    var materials = component.get('v.materialToDelete'); 
                    var skuLst = component.get("v.materialDetails");
                    for(var i = 0; i < skuLst.length; i++){
                        if(skuLst[i].kit_prod==mystring){
                            //alert('hello in same');
                            var newWrapper = new Array();
                            newWrapper = {
                                'pbd_id':skuLst[i].id,
                                'cn':'',
                                'mt_code':'',
                                'sku_code':'',
                                'min_prc':'',
                                'min_prc_u':'',
                                'unt_prc':'',
                                'unt_prc_u':'',
                                'fsp':'',
                                'fsp_u':''
                                
                            };
                            materials.push(newWrapper);
                        }}
                    
                    // alert(materials.length);    
                    component.set('v.materialToDelete',materials);
                }else{
                    var materials = component.get('v.materialToDelete'); 
                    var newWrapper = new Array();
                    newWrapper = {
                        'pbd_id':id,
                        'cn':'',
                        'mt_code':'',
                        'sku_code':'',
                        'min_prc':'',
                        'min_prc_u':'',
                        'unt_prc':'',
                        'unt_prc_u':'',
                        'fsp':'',
                        'fsp_u':'',
                        'sellOutPrice':'',
                        'sellOutPrice':''
                        
                    };
                    materials.push(newWrapper);
                    // alert(materials.length);    
                    component.set('v.materialToDelete',materials);
                }
            }
            //added if for kit ,split with # and splice and form new table data.
            if(component.get("v.Price_Book_For_Kit")==true){
                var newLst=[];
                var unSku=[]
                var skuLst = component.get("v.materialDetails");
                var skuLstk = component.get("v.materialDetails");
                var ind=[];
                for(var i = 0; i < skuLst.length; i++){
                    if(skuLst[i].kit_prod==mystring){
                        unSku.push(skuLst[i].kit_comp);
                        skuSet.splice( $.inArray(skuLst[i].kit_comp,skuSet) ,1 );
                        ind.push(i);
                        //skuLstk.splice(i, 1);
                        //$("#tableId").DataTable().remove(mystring).draw(false);  
                    }
                }
                for(var j=0;j<ind.length;j++){
                    skuLstk.splice($.inArray(skuLst[ind[j]],skuLstk) ,1);
                }
                component.set("v.materialDetails", skuLstk);
                var matLst=component.get("v.materialDetails");
                //alert('hello'+matLst);
                var code;
                var count;
                $("#tableId").DataTable().clear().draw();
                for(var i=0;i<matLst.length;i++){
                    code=matLst[i].kit_prod+'#'+matLst[i].sku_code;
                    count =i;
                    $('#tableId').dataTable().fnAddData( [
                        
                        matLst[i].mt_code,
                        matLst[i].sku_code,
                        matLst[i].kit_prod,
                        parseFloat(matLst[i].min_prc.replace('.','').replace(',','.').trim()).toFixed(2).replace('.',','),
                        parseFloat(matLst[i].min_prc_u.replace('.','').replace(',','.').trim()).toFixed(2).replace('.',','),
                        parseFloat(matLst[i].unt_prc.replace('.','').replace(',','.').trim()).toFixed(2).replace('.',','),
                        parseFloat(matLst[i].unt_prc_u.replace('.','').replace(',','.').trim()).toFixed(2).replace('.',','),
                        parseFloat(matLst[i].fsp.replace('.','').replace(',','.').trim()).toFixed(2).replace('.',','),
                        parseFloat(matLst[i].fsp_u.replace('.','').replace(',','.').trim()).toFixed(2).replace('.',','),
                        '<button  class="btn-to-hide" style="color:red; font-weight:bold; margin-left:21px; background:#fff; border-radius:3px; border:1px solid #ccc; padding:2px 5px 2px 5px;" id="" value="'+count+'" name="'+code+'" iconName="utility:delete" >X</button>'
                        
                    ]);}
                //alert('hell2'+component.get("v.materialDetails"));
                //$("#tableId").DataTable().row($(this).parents('tr')).remove().draw(false);   
                // $("#tableId").DataTable().rows()remove();
            }
            else{
                skuSet.splice( $.inArray(nm,skuSet) ,1 );
                
                // alert(JSON.stringify(skuSet));
                
                var sku = component.get("v.materialDetails");
                
               
                for(let i=0;i<sku.length;i++){
                    if(sku[i].pbd_id==id){
                        sku.splice(i, 1);
                        //flag=1;
                    }
                }
                component.set("v.materialDetails", sku);
                
                $("#tableId").DataTable().row($(this).parents('tr')).remove().draw(false);
            }
            var toastEvent3 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.Record_Deleted_Successfully}");
            var titl  = $A.get("{!$Label.c.Success}");
            toastEvent3.setParams({
                "title": titl,
                "type": "success",
                "message": msg,
                "duration":'1000'
            });
            toastEvent3.fire();
            
        });
        
        
        
    },
    //added for kit on change of pricebook type set the values
    onRadioSelect:function(component, event, helper){
        var val1=event.getSource().get('v.value');
        if(val1=='Price Book For Campaign'){
            component.set("v.hide1",true);
            component.set("v.hide4",true);
            component.set("v.pb_for_campaign",true);
            
            component.set("v.Price_Book_For_Kit",false);
            component.set("v.pb_for_avec",false);     // Line Added Related to #INC0438067 by Shubham(Grazitti)
            component.set("v.priceBookType",val1);
            component.set("v.campaignType","Simple");
            component.find("radio1").set("v.checked", true);
            helper.loadPaymentTerms(component);
        }
        else if(val1=='Normal Pricebook'){
            component.set("v.hide1",false);
            component.set("v.hide4",false);
            component.set("v.pb_for_avec",false);     // Line Added Related to #INC0438067 by Shubham(Grazitti)
            component.set("v.pb_for_campaign",false);
            component.set("v.Price_Book_For_Kit",false);
            component.set("v.priceBookType",val1);
            component.set("v.campaignType","");
        }else if(val1=='Price Book For Kit'){
            component.set("v.Price_Book_For_Kit",true);
            component.set("v.priceBookType",val1);
            component.set("v.hide1",false);
            component.set("v.hide4",false);
            component.set("v.pb_for_avec",false);     // Line Added Related to #INC0438067 by Shubham(Grazitti)
            component.set("v.pb_for_campaign",false);
            component.set("v.campaignType","");
        }
        //Added by wipro
        else if(val1=='AVEC Price Book'){
            component.set("v.hide1",false);
            
            component.set("v.hide4",true);
            component.set("v.pb_for_campaign",false);
            component.set("v.Price_Book_For_Kit",false);
            component.set("v.pb_for_avec",true);
            component.set("v.priceBookType",val1);
            component.set("v.campaignType","Simple");
            //component.find("radio1").set("v.checked", false);
            helper.loadPaymentTerms(component);
        }										 
         
        component.find("DivisionName").set("v.disabled",true);
    },
    //modified for kit, if pbtype exist call togglecheck helper
    doInit : function(component, event, helper){
  /* start code added by javed(Grazitti) for RITM0463334 23-12-2022*/
        var action = component.get("c.getCropCultures");
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(component.isValid() && state === 'SUCCESS'){
                component.set("v.accountList",resp.getReturnValue());
                var alldta =[];
                    for(var i=0 ; i<resp.getReturnValue().length; i++ ){
                        alldta.push(resp.getReturnValue()[i].Id);
                    }
                    component.set('v.fnlList',alldta);
                component.set("v.data",resp.getReturnValue());
                component.set("v.cropDataList",resp.getReturnValue());
                
                component.set("v.totalPages", Math.ceil(resp.getReturnValue().length/component.get("v.selectedOptionForSize")));
                console.log('v.totalPages ', component.get("v.totalPages"));
                component.set("v.currentPageNumber",1);
                helper.buildData(component, helper);
                 
//alert('accountList:'+component.get("v.accountList"));
        }else{
            console.log(resp.getError());
        }
        });
        $A.enqueueAction(action);
          /* end code added by javed(Grazitti) for RITM0463334 23-12-2022*/
        component.set("v.cfWrap",{maximum:1,minimum:1});//Added by Krishanu & Ankita @Wipro
        console.log(JSON.stringify(component.get("v.cfWrap")));
        var options = [
            {
                'label':$A.get("$Label.c.Normal_Pricebook"), 
                'value': 'Normal Pricebook'
            },
            {
                'label':$A.get("$Label.c.PriceBookforCampaign") , 
                'value': 'Price Book For Campaign'
            },
            {
                'label': $A.get("$Label.c.Price_Book_for_Kit"), 
                'value': 'Price Book For Kit'
            },
            {
                'label': $A.get("$Label.c.AVEC_Discontinued_Price_Book"), 
                'value': 'AVEC Price Book'
            }                                                    
            
        ];
        component.set("v.options",options);
        
        helper.getMasterDataHelper(component, event, helper);//added by Swapnil
        helper.getuploadedFiles(component); //added by Atish

        var Today = new Date();
        var recordId = component.get("v.recordId"); 
        var price_book_checkbox = component.get("v.Price_Book_For_Campaign");
        //alert('init'+price_book_checkbox);
        var pbooktype = component.get("v.priceBookType");
        var apply_discount = component.get("v.apply_discount");
        var applyMinPrice = component.get("v.applyMinPrice"); // Priya RITM0237685
        
        console.log('in init'+apply_discount);
        console.log('**in init applyMinPrice -> '+applyMinPrice);
        
        if(pbooktype!=null && pbooktype!='' && pbooktype!=undefined){
            helper.toggleCheck(component, event, helper);
        }
        if(apply_discount){
            component.find("apply_discount").set("v.checked", true); //Divya
        }
        
        if(applyMinPrice){
            component.find("apply_MinPrice").set("v.checked", true); // Priya RITM0237685
        }
        
        var Today = new Date();
        var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();
        var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
        var yyyy = Today.getFullYear();
        
        component.set("v.today", yyyy + "-" + MM + "-" + dd);
        helper.loadSKUDescription(component,event);
        
        if (typeof recordId != "undefined"){
            component.set("v.isbtndisable", true);
            component.set("v.isSavebtnHide", false);
            component.set("v.isEdit", true);
            //component.find("addDistbtn").set("v.disabled",true);
            helper.editPriceBookNew(component);
            
        }else if(typeof recordId == "undefined"){
            //  console.log('New Record--->');
            
            //component.find("searchUtil").set("v.disabled",false);
            
            component.set("v.isSavebtnHide", true);
            component.set("v.isbtndisable", false);
            component.set("v.isEdit", false);
            //getDefaultDivision
            
            var actionDivision = component.get("c.getDefaultDivision");
            actionDivision.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    var data = response.getReturnValue();
                    var parsed =data;
                    //  console.log('division data '+JSON.stringify(parsed[0].Id));
                    var obj= new Object();
                    obj.division = parsed[0].Id;
                    obj.division_nm= parsed[0].Name;
                    component.set("v.priceBookDetails",obj); 
                    // component.set("v.priceBookDetails.division_nm",parsed[j].Name);
                    
                }else{
                    //  console.log('state--->'+state);
                }
            });
            $A.enqueueAction(actionDivision); 
            component.find("DivisionName").set("v.disabled",true);
            
            
            var expiryDate = (yyyy + "-" + MM + "-" + dd);
            component.set('v.myDate', yyyy + "-" + MM + "-" + dd);
            component.set('v.myDate1', yyyy + "-" + MM + "-" + dd);
            
            var actionProfile= component.get("c.getProfileID");
            actionProfile.setCallback(this,function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    var ProfileUser=response.getReturnValue();
                    if(ProfileUser =='Brazil Sales Director'){
                        component.set("v.isProfileUser",true);
                    }else if(ProfileUser == 'System Administrator')  {
                        component.set("v.isProfileUser",true);
                    }else if(ProfileUser == 'Brazil Sales Price Admin')  {
                        component.set("v.isProfileUser",true);
                    }else if(ProfileUser == 'Brazil System Administrator')  {
                        component.set("v.isProfileUser",true);
                    }
                    
                }else{
                    //  console.log('state :-- '+state);
                }
            });
            $A.enqueueAction(actionProfile); 
        }
        helper.getSellOutMatrix(component, event, helper);
        helper.getCurrentER(component, event, helper);
    },
      //added by Atish
      previewFileAction :function(component,event,helper){  
        var rec_id = event.currentTarget.id;  
        $A.get('e.lightning:openFiles').fire({ 
            recordIds: [rec_id]
        });  
    }, 
    openModel: function(component, event, helper) {
      // Set isModalOpen attribute to true
      component.set("v.isModalOpen", true);
   },
   submitDetails: function(component, event, helper) {
      // Set isModalOpen attribute to false
      //Add your code to call apex method or do some processing
      component.set("v.isModalOpen", false);
        helper.gotoListviewHelper(component,'pending');

   },
   /* start code added by javed(Grazitti) for RITM0463334 23-12-2022*/
   onPrev : function(component, event, helper) {        
    var pageNumber = component.get("v.currentPageNumber");
    component.set("v.currentPageNumber", pageNumber-1);
    helper.buildData(component, helper);
},
   onNext : function(component, event, helper) {        
    var pageNumber = component.get("v.currentPageNumber");
    component.set("v.currentPageNumber", pageNumber+1);
    console.log('pageNumber++++>> ', pageNumber);
    helper.buildData(component, helper);
},

checkboxSelect : function(component, event, helper) {  
    var fnlList = component.get('v.fnlList');
    var getAllLanguages = component.find("boxPackLanguages");
    for (var i=0; i<getAllLanguages.length; i++){

        if (getAllLanguages[i].get("v.checked")) {
            if(!fnlList.includes(getAllLanguages[i].get("v.value"))){
                fnlList.push(getAllLanguages[i].get("v.value"));            
            }
        }else{
            if(fnlList.includes(getAllLanguages[i].get("v.value"))){
                var m = fnlList.indexOf(getAllLanguages[i].get("v.value"));
                fnlList.splice(m,1);
            }
        }
    }
    
    component.set('v.fnlList',fnlList);
     console.log('fnlList:'+component.get('v.fnlList'));
     console.log('length:'+component.get('v.fnlList').length);
},
      /* end code added by javed(Grazitti) for RITM0463334 23-12-2022*/
    UploadFinished : function(component, event, helper) {  
        var uploadedFiles = event.getParam("files");  
       // var fileSize = component.get("v.files");
        console.log("filezise",uploadedFiles.length);

        console.log(JSON.stringify(uploadedFiles)+'checkingfiles');
        //var documentId = uploadedFiles[0].documentId;  
        //var fileName = uploadedFiles[0].name; 
          helper.getuploadedFiles(component); 
        

        helper.getMyTasks(component);     
        component.find('notifLib').showNotice({
            "variant": "success",
            "header": "Success",
            "message": "File Uploaded successfully!!",
            closeCallback: function() {}
        });
           component.set("v.isfilesModalOpen", true);
  }, 
    
    delFilesAction:function(component,event,helper){
        component.set("v.Spinner", true); 
        var documentId = event.currentTarget.id;        
        helper.delUploadedfiles(component,documentId);  
    },

    // end    
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
        
        //  console.log('validfrmDt-->'+validfrmDt);
        if(validfrmDt == ''){
            //  console.log('validfrmDt-->'+validfrmDt);
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
        ////  console.log('Method--validfrmDt--'+validfrmDt);
        var expiryDt = component.get("v.myDate1");
        ////  console.log('Method--ExpiryDt--'+expiryDt);
        var falseDate1 = true;
        var Today = new Date();
        ////  console.log('todaydate'+Today.getDate());
        var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();    
        var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
        var yyyy = Today.getFullYear();
        var todayDate = (yyyy + "-" + MM + "-" + dd);
        ////  console.log('method--todayDate---'+todayDate);
        
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
            //  console.log('Inside--isNullCheck-'+isNullCheck);
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
        
        
        if(Selectedcurr == 'Only BRL'){
            component.find("int_rate_U").set("v.value","0");
            component.find("int_rate_U").set("v.disabled",true);
            component.find("int_rate_R").set("v.disabled",false);
        }
        else if(Selectedcurr == 'Only USD'){
            component.find("int_rate_R").set("v.disabled",true);
            component.find("int_rate_R").set("v.value","0");
            component.find("int_rate_U").set("v.disabled",false);
        }
            else if(Selectedcurr == 'BRL and USD'){
                component.find("int_rate_U").set("v.value","0");
                component.find("int_rate_R").set("v.value","0");
                component.find("int_rate_R").set("v.disabled",false);
                component.find("int_rate_U").set("v.disabled",false);
                component.set("v.isBothCurrency", true);
            }
                else{
                    component.find("int_rate_R").set("v.disabled",false);
                    component.find("int_rate_U").set("v.disabled",false);
                    component.set("v.isBothCurrency", false);    
                }
        component.find("int_rate_R").set('v.validity', {valid:true, badInput :false});
        component.find("int_rate_R").showHelpMessageIfInvalid();
        component.find("int_rate_U").set('v.validity', {valid:true, badInput :false});
        component.find("int_rate_U").showHelpMessageIfInvalid();
        
        /*if(Selectedcurr == 'BRL and USD'){
            component.set("v.isBothCurrency", true);
        }else{
            component.set("v.isBothCurrency", false);
        } */
    },
    
    
    
    
    openDivModel: function(component, event, helper){
        
        helper.fetchDivision(component);
        component.set("v.isOpen2", true);
        helper.applyCSS(component);
        
        
    },
    
    closeModel: function(component, event, helper){
        //  console.log('closeModel called...');
        component.set("v.isOpen", false);
        component.set("v.isOpen2", false);
        helper.revertCssChange(component);
    },
    
    closeErrorModel :function(component, event, helper){        
        component.set("v.isErrors", false);
        component.set("v.isSKuErrors", false);
        helper.revertCssChange(component);
        
    },
    
    //modified for kit, if kit form table with kit product code on select sku 
    tabActionClicked: function(component, event, helper){

        var actionId = event.getParam('actionId');
        var lstofSldt = [];
        var Error = $A.get("{!$Label.c.Error}");
        //Division
        if(actionId == 'selectDivision' ){
            
            //get the row where click happened and its position
            var rowIdx = event.getParam("index");
            var divRow = event.getParam('row');
            
            
            var obj= new Object();
            obj.division = divRow.Id;
            obj.division_nm= divRow.Name;
            component.set("v.priceBookDetails",obj); 
            
            // component.set("v.PriceBookDivisionName",divRow.Name);
            // component.find("HiddenDivisionName").set("v.value", divRow.Id);
            component.set("v.isOpen2", false);
            helper.revertCssChange(component);
            
        }
        // Product
        if(actionId == 'selectSku' ){
            //added by Swapnil
            var itemRow = event.getParam('row');
            var skuid1=itemRow.Id;
            var skuid2=itemRow.Active__c;
            
            console.log('skuid1***',skuid1);
            component.set("v.ProductRecordId",skuid1);
            var validActiveMaterial = true;	
            var validSalesDistrict = true;
            var validActiveProduct = true;
            var validRecommCost= true;
            var validSKUBrandNull = true;
            var validSKUDataNotAvailableInMasterData = true; 
            var validSKUDistrictDataNotAvailableInMasterData = true;
            var LiDiscountMatrix = component.get("v.LiDiscountMatrix");
            var LiMarketVariation = component.get("v.LiMarketVariation");
            var liSalesDistrict = component.get("v.salesdtarr");
            var liSalesDistrict1 = component.get("v.cropcularr");

            //end
            //get the row where click happened and its position
            // var rowIdx = event.getParam("index");
            var skuRow = event.getParam('row');

            //BELOW 30 LINE OF CODE ADDED BY HARSHIT&SAGAR@WIPRO FOR (US MPO-001 & MPO-003) ---START
            var priceDetailList1 = component.get("v.PriceBook");
            //alert("help1"+skuid2);
            
            console.log("pricedetailslist is for price book ",priceDetailList1);
           var mterialplanrecords2 = component.get("v.mterialplanrecords"); 
            try{
                for(var i = 0; i < mterialplanrecords2.length; i++){
                if(skuid1 == mterialplanrecords2[i].SKUid){
                    console.log('mterialplanrecords2[i].SKUid***',mterialplanrecords2[i].SKUid);
                    console.log('mterialplanrecords2[i].Recommendedprice***',mterialplanrecords2[i].Recommendedprice);
                    if(mterialplanrecords2[i].Active == false){
                        validActiveProduct = false;
                        console.log('mterialplanrecords2***k',mterialplanrecords2[i]);
                        var toastEvent = $A.get("e.force:showToast");
                        var msg  = 'O produto está inativo no cadastro Produto x Filial. Por favor, verificar com o Customer Service.' ;
                        var titl  = "Produto Inativo";
                        toastEvent.setParams({
                            "title": titl,
                            "type": "Error",
                            "message": msg,
                            "duration":'3000'
                        });
                        toastEvent.fire();
                        return;
                    }
                    if(mterialplanrecords2[i].Recommendedprice <= 0){ 
                    validRecommCost= false;    
                var toastEvent = $A.get("e.force:showToast");
                var msg  = $A.get("$Label.c.Replacement_Cost_Validation_Error");
                var titl  = "Custo Indisponível";
                toastEvent.setParams({
                    "title": titl,
                    "type": "Error",
                    "message": msg,
                    "duration":'3000'
                });
                toastEvent.fire();
            }
                     
                }    
            }
            }
            catch(e){
                console.log('Error-->'+e);
            }
            //---END								  
			 
					
            
            // var rowIndex = component.get("v.rowIndex");
            var skuArray = new Object();            
            var skuArrayList = [];
            try{
                //added by Swapnil
                if(component.get("v.salesdtarr").length == 0){
                    validSalesDistrict = false;
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": Error,
                        "type": Error,
                        "message": $A.get("{!$Label.c.SalesDistrictBeforeSKU}")
                        
                    });
                    toastEvent.fire();
                }
                if(validSalesDistrict){
                    if(!skuRow.Brand_Name__c){
                        validSKUBrandNull = false;
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": Error,
                            "type": Error,
                            "message": $A.get("{!$Label.c.BrandValueIsBlank}")
                            
                        });
                        toastEvent.fire();
                    }
                    if(validSKUBrandNull){
                        //end
                        if((LiDiscountMatrix.indexOf(skuRow.Brand_Name__c+component.get("v.SalesOrg"))> -1)){//added by swapnil
                            var i ;
                            var errorMessage = $A.get("{!$Label.c.RegionaAndSKU}") +' \n';
                            for(i = 0; i < liSalesDistrict.length; i++){                                
                                if(!(LiMarketVariation.indexOf(liSalesDistrict[i].SDCode+skuRow.Brand_Name__c+component.get("v.SalesOrg"))> -1)){
                                    errorMessage = errorMessage + liSalesDistrict[i].Name + ' ' +  skuRow.Brand_Name__c + ' \n';
                                    validSKUDistrictDataNotAvailableInMasterData = false
                                }
                                
                            }
                            
                            if(validSKUDistrictDataNotAvailableInMasterData){
                                //added for kit
                                if(component.get("v.Price_Book_For_Kit")==true){
                                    skuArray.pbd_id=skuRow.Id;
                                    skuArray.mt_code=skuRow.SKU_Description__c;
                                    skuArray.Brand=skuRow.Brand_Name__c;
                                    skuArray.sku_code='';
                                    skuArray.min_prc='';
                                    skuArray.min_prc_u='';
                                    skuArray.unt_prc='';
                                    skuArray.unt_prc_u='';
                                    skuArray.fsp='';
                                    skuArray.fsp_u='';
                                    skuArray.kit_prod=skuRow.SKU_Code__c;
                                    //alert('hellocheck'+component.get("v.priceBookType"));
                                    var action=component.get("c.getComponent");
                                    action.setParams({ "kitCode" :skuRow.SKU_Code__c
                                                      
                                                     });
                                    action.setCallback(this,function(resp){
                                        var state = resp.getState();
                                        //alert('hello'+state);
                                        if(state === 'SUCCESS'){
                                            //alert(resp.getReturnValue());
                                            var cmpList=resp.getReturnValue();
                                            component.set("v.kitProduct",true);
                                            //alert('hello1'+component.get("v.kitProduct"));
                                            for(var cmp=0; cmp<cmpList.length; cmp++){
                                                
                                                //alert('hello1'+component.get("v.kitProduct"));
                                                skuArray = new Object();
                                                skuArray.pbd_id=skuRow.Id;
                                                skuArray.mt_code=cmpList[cmp].Component_SKU__r.SKU_Description__c;
                                                skuArray.sku_code=cmpList[cmp].Component_SKU__r.SKU_Code__c;
                                                skuArray.Brand=skuRow.Brand_Name__c;
                                                skuArray.min_prc='';
                                                skuArray.min_prc_u='';
                                                skuArray.unt_prc='';
                                                skuArray.unt_prc_u='';
                                                skuArray.fsp='';
                                                skuArray.fsp_u='';
                                                skuArray.kit_prod=cmpList[cmp].Kit_SKU__r.SKU_Code__c;
                                                skuArray.kit_comp=cmpList[cmp].Kit_SKU__r.SKU_Code__c+'#'+cmpList[cmp].Component_SKU__r.SKU_Code__c;
                                                skuArrayList.push(skuArray);
                                                //alert('enter1'+skuArrayList);
                                            }
                                            
                                            //alert('in'+skuArrayList);
                                            
                                            component.set('v.hideComp', true);
                                            component.set("v.compList",skuArrayList);
                                            component.set("v.isOpen3", false);
                                            helper.revertCssChange(component);
                                            
                                        }
                                        else{
                                            console.log(resp.getError());
                                            cmp.set("v.showSpinner",false);
                                        }
                                    });
                                    $A.enqueueAction(action);   
                                }
                                else{
                                    component.set('v.hideComp', false);
                                    skuArray.pbd_id=skuRow.Id;
                                    skuArray.mt_code=skuRow.SKU_Description__c;
                                    skuArray.sku_code=skuRow.SKU_Code__c;
                                    skuArray.Brand=skuRow.Brand_Name__c;
                                    skuArray.min_prc='';
                                    skuArray.min_prc_u='';
                                    skuArray.unt_prc='';
                                    skuArray.unt_prc_u='';
                                    skuArray.fsp='';
                                    skuArray.fsp_u='';
                                    skuArray.kit_prod='';    
                                }
                            }
                            else{
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": Error,
                                    "type": Error,
                                    "message": errorMessage
                                    
                                });
                                toastEvent.fire();
                                
                            }
                        }
                        
                        else{
                            
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": Error,
                                "type": Error,
                                "message": $A.get("{!$Label.c.SKUBrandNotAvailablein}")
                                
                            });
                            toastEvent.fire();
                            validSKUDataNotAvailableInMasterData = false;  
                            
                        }
                    }
                }
            }catch(e){
                console.log('Error-->'+e);
                
            }
            if(validSKUBrandNull && validSKUDataNotAvailableInMasterData 
               && validSalesDistrict && validSKUDistrictDataNotAvailableInMasterData && validRecommCost && validRecommCost){//added by Swapnil
                
                //added if for non kit
                
                //if(component.get("v.priceBookType")!='Price Book For Kit'){
                      //added by Krishanu
                helper.getConversionFactor(component, event, skuRow.Brand_Name__c);
                console.log(component.get("v.cfWrap"));
                component.set('v.skuWrapper', skuArray);
                component.set("v.isOpen3", false);
                helper.revertCssChange(component);  
                //}
                
            }
        }
        
        //Sales District
        if(actionId == 'salectDist'){
            //added by swapnil
            var RegionNotAvailableinMasterData = true;
            var LiSalesDistrictCost = component.get("v.LiSalesDistrictCost");
            
            //end
            var rowIdx = event.getParam("index");
            var Salesdist = event.getParam('row');
            var rowIndex = component.get("v.rowIndex");
            var salesDistList = component.get("v.salesdtarr");
            
            for (var idx=0; idx<salesDistList.length; idx++) {
                if (idx==rowIndex) {
                    if((LiSalesDistrictCost.indexOf(Salesdist.RegionCode__c+component.get("v.SalesOrg"))> -1)){//added by swapnil
                        salesDistList[idx].sdtId = Salesdist.Id;                   
                        salesDistList[idx].Name = Salesdist.Name;
                        salesDistList[idx].SDCode = Salesdist.RegionCode__c;
                        //alert(component.get("v.materialDetails").length);
                        console.log('lENGTH '+component.get("v.materialDetails").length);
                        if(component.get("v.materialDetails").length>0){
                            
                            console.log('Inside New Code1 '+salesDistList);
                            
                            helper.validateSalesDistrict(component, event, helper, salesDistList);
                        }
                    } 
                    //added by Swapnil
                    else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": Error,
                            "type": Error,
                            "message": $A.get("{!$Label.c.SalesDistrictNotPresent}")
                            
                        });
                        toastEvent.fire();
                        RegionNotAvailableinMasterData = false;    
                    }
                    //end
                } 
            }
            if(RegionNotAvailableinMasterData){//added by Swapnil
                component.set('v.salesdtarr', salesDistList);
                var salesDistList111 = component.get("v.salesdtarr");
                console.log('Salesdist111>>>',salesDistList111);
                component.set("v.isOpen",false);
                helper.revertCssChange(component);
            }
        }
        
        //code added by Sagar@Wipro PB-003 for selecting crop cultures
        if(actionId == 'salectDist1'){
            //added by swapnil 
            var RegionNotAvailableinMasterData = true;
            var LiSalesDistrictCost1 = component.get("v.LiSalesDistrictCost1");
            
            //end
            var rowIdx = event.getParam("index");
            var Salesdist1 = event.getParam('row');
          
            console.log('Salesdist1>>>',Salesdist1);
            var rowIndex = component.get("v.rowIndex");
            var salesDistList1 = component.get("v.cropcularr");
            console.log('salesDistList1>>>',salesDistList1);            
            for (var idx=0; idx<salesDistList1.length; idx++) {
                if (idx==rowIndex) {
                    // if((LiSalesDistrictCost1.indexOf(Salesdist1.Culture_Code__c+component.get("v.SalesOrg"))> -1)){//added by swapnil
                    salesDistList1[idx].sdtId1 = Salesdist1.Id;                   
                    salesDistList1[idx].Name1 = Salesdist1.Name;
                    salesDistList1[idx].SDCode1 = Salesdist1.Culture_Code__c;
                    console.log('Inside New Code1 '+salesDistList1[idx]);
                    //alert(component.get("v.materialDetails").length);
                    //console.log('lENGTH '+component.get("v.materialDetails").length);
                    /*if(component.get("v.materialDetails").length>0){
                            
                            console.log('Inside New Code1 '+salesDistList1);
                            
                            helper.validateSalesDistrict(component, event, helper, salesDistList);
                        }*/
                    // } 
                    //added by Swapnil
                    
                    //end
                } 
            }
            if(RegionNotAvailableinMasterData){//added by Swapnil
                component.set('v.cropcularr', salesDistList1);
                var salesDistList11 = component.get("v.cropcularr");
                console.log('Salesdist1>>>',salesDistList11);	
                component.set("v.isOpen",false);
                helper.revertCssChange(component);
            }
        }
		
		//code added by Sagar@Wipro PB-004 for selecting customer group
        if(actionId == 'salectDist2'){
            //added by swapnil 
            var RegionNotAvailableinMasterData = true;
            var LiSalesDistrictCost2 = component.get("v.LiSalesDistrictCost2");
            
            //end
            var rowIdx = event.getParam("index");
            var Salesdist2 = event.getParam('row');
            var custgrpid=Salesdist2.Id;//sagar
            console.log('custgrpid',custgrpid);
            component.set("v.custgrpid",custgrpid);
            console.log('Salesdist2>>>',Salesdist2);
            var rowIndex = component.get("v.rowIndex");
            var salesDistList2 = component.get("v.custgrparr");
            console.log('salesDistList2>>>',salesDistList2);            
            for (var idx=0; idx<salesDistList2.length; idx++) {
                if (idx==rowIndex) {
                    // if((LiSalesDistrictCost1.indexOf(Salesdist1.Culture_Code__c+component.get("v.SalesOrg"))> -1)){//added by swapnil
                    salesDistList2[idx].sdtId2 = Salesdist2.Id;                   
                    salesDistList2[idx].Name2 = Salesdist2.Name;
                    salesDistList2[idx].SDCode2 = Salesdist2.Customer_Group__c;
                    console.log('Inside New Code2 '+salesDistList2[idx]);
                    //alert(component.get("v.materialDetails").length);
                    //console.log('lENGTH '+component.get("v.materialDetails").length);
                    /*if(component.get("v.materialDetails").length>0){
                            
                            console.log('Inside New Code1 '+salesDistList1);
                            
                            helper.validateSalesDistrict(component, event, helper, salesDistList);
                        }*/
                    // } 
                    //added by Swapnil
                    
                    //end
                } 
            }
          //  if(RegionNotAvailableinMasterData){//added by Swapnil
                component.set('v.custgrparr', salesDistList2);
                var salesDistList11 = component.get("v.custgrparr");
                console.log('Salesdist2>>>',salesDistList11);
                component.set("v.isOpen",false);
                helper.revertCssChange(component);
            	component.set("v.iscustgrp",false);
          //  }
        }
        //code added by Sagar@Wipro PB-004 for selecting customer Name
        if(actionId == 'salectcust'){
            //added by swapnil 
            var RegionNotAvailableinMasterData = true;
            var LiSalesDistrictCost1 = component.get("v.LiSalesDistrictCost1");
            
            //end
            var rowIdx = event.getParam("index");
            var Salesdist1 = event.getParam('row');
          
            console.log('Salesdist1>>>',Salesdist1);
            var rowIndex = component.get("v.rowIndex");
            var salesDistList1 = component.get("v.custnamearr");
            console.log('salesDistList1>>>',salesDistList1);            
            for (var idx=0; idx<salesDistList1.length; idx++) {
                if (idx==rowIndex) {
                    // if((LiSalesDistrictCost1.indexOf(Salesdist1.Culture_Code__c+component.get("v.SalesOrg"))> -1)){//added by swapnil
                    salesDistList1[idx].Id = Salesdist1.Id;                   
                    salesDistList1[idx].Name = Salesdist1.Name;
                   // salesDistList1[idx].sapcode = Salesdist1.SAP_Code__c;
                    salesDistList1[idx].custgrpname= Salesdist1.Customer_Group__c;
                    salesDistList1[idx].depotcode= Salesdist1.Brazil_Depot_Code__r.Depot_Code__c	;
                    console.log('Inside New Code1 '+salesDistList1[idx]);
                    //alert(component.get("v.materialDetails").length);
                    //console.log('lENGTH '+component.get("v.materialDetails").length);
                    /*if(component.get("v.materialDetails").length>0){
                            
                            console.log('Inside New Code1 '+salesDistList1);
                            
                            helper.validateSalesDistrict(component, event, helper, salesDistList);
                        }*/
                    // } 
                    //added by Swapnil
                    
                    //end
                } 
            }
            if(RegionNotAvailableinMasterData){//added by Swapnil
                component.set('v.custnamearr', salesDistList1);
                var salesDistList11 = component.get("v.custnamearr");
                var depot= salesDistList11[0].depotcode;
                //component.set("v.depotcode1", depot);
                //var depot1= component.get("v.depotcode1");
                console.log('depot1'+depot);
                console.log('cust names>>>',salesDistList11);
                

                component.set("v.isOpen",false);
                helper.mterialplanrecords1(component,event,helper,depot);

                helper.revertCssChange(component);
            }
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
        helper.gotoListviewHelper(component,'');           // send blank defType for default list view.... dont remove '' blank..
    },
    
    closeDupCheck: function (component, event, helper){
        component.set("v.isSkuDuplicate", false);
        helper.revertCssChange(component);
    },
    
    //modified for kit ,if kit pb,set values accordingly
    toggleCheck: function(component, event, helper){      // kindly check and make changes in same method in helper as well....
        
        //var currecny = component.find("checkbox-id-01").get("v.value"); 
        //var isChecked = component.find("checkbox-id-01").get("v.checked");
        //changed from checkbox to radio
        var isChecked = component.get("v.Price_Book_For_Campaign");
        var pbooktype = component.get("v.priceBookType");
        if(pbooktype!=null && pbooktype!='' && pbooktype!=undefined){
            component.find("checkbox-id-01").set("v.value",pbooktype);
        }
        // var checkbox = document.getElementById('checkbox-id-01');
        if(isChecked){
            component.set("v.hide1",true);
            
            component.set("v.hide4",true);
            
            component.set("v.pb_for_campaign",true);
            component.set("v.campaignType","Simple");
            component.find("radio1").set("v.checked", true);
            //component.find("radi2").set("v.checked", true);
            component.set("v.Price_Book_For_Kit",false);
            helper.loadPaymentTerms(component);
        }
        else{
            component.set("v.hide1",false);
            
            component.set("v.hide4",false);
            
            component.set("v.pb_for_campaign",false);
            component.set("v.campaignType","");
            component.find("radio1").set("v.checked", false);
        }
        component.find("DivisionName").set("v.disabled",true);
    },
    //added parameter related to kit in event call 
    onRadioChange: function(component, event, helper){
        // var test=component.find("options").get("v.value");
        // alert('helloParentradio');
        var val=event.getSource().get('v.value');
        // alert(val);
        
        if(val == 'Structured'){
            var pbType=component.get("v.priceBookType");
            var evt = $A.get("e.force:navigateToComponent");
            //added pbtype in param
            evt.setParams({
                componentDef  : "c:StructuredCampaign" ,
                componentAttributes  : {
                    Price_Book_For_Campaign :true ,
                    Price_Book_For_Kit :false ,
                    priceBookType :pbType
                }
            });
            //  console.log('Event '+evt);
            evt.fire(); 
        }
        component.set("v.campaignType",val);
    },
    
    validateDate: function(component, event, helper){
        // var test=component.find("options").get("v.value");
        var val=event.getSource().get('v.value');
        
        var Today = new Date();
        var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();
        var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
        var yyyy = Today.getFullYear();
        var currentDt = (yyyy + "-" + MM + "-" + dd);
        
        if(val < currentDt){ 
            // event.getSource().focus();
            component.set("v.hide3",true);
        }
        else{
            component.set("v.hide3",false);
        }
        
    },
    
    validateDate2: function(component, event, helper){
        // var test=component.find("options").get("v.value");
        var val=event.getSource().get('v.value');
        var frm_dt=component.find("validfrmId").get("v.value");
        var Today = new Date();
        var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();
        var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
        var yyyy = Today.getFullYear();
        var currentDt = (yyyy + "-" + MM + "-" + dd);
        
        if(val < frm_dt){ 
            // event.getSource().focus();
            component.set("v.hide5",true);
        }
        else{
            component.set("v.hide5",false);
        }
    },
    
    validateDate3: function(component, event, helper){
        // var test=component.find("options").get("v.value");
        var val=event.getSource().get('v.value');
        
        var Today = new Date();
        var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();
        var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
        var yyyy = Today.getFullYear();
        var currentDt = (yyyy + "-" + MM + "-" + dd);
        
        if(val < currentDt){ 
            //  event.getSource().focus();
            component.set("v.hide6",true);
        }
        else{
            component.set("v.hide6",false);
        }
    },
    
    validateDate4: function(component, event, helper){
        // var test=component.find("options").get("v.value");
        var val=event.getSource().get('v.value');
        
        var Today = new Date();
        var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();
        var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
        var yyyy = Today.getFullYear();
        var currentDt = (yyyy + "-" + MM + "-" + dd);
        
        if(val < currentDt){ 
            //  event.getSource().focus();
            component.set("v.hide7",true);
        }
        else{
            component.set("v.hide7",false);
        }
    },
    
    validateDate5: function(component, event, helper){
        // var test=component.find("options").get("v.value");
        var val=event.getSource().get('v.value');
        
        var Today = new Date();
        var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();
        var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
        var yyyy = Today.getFullYear();
        var currentDt = (yyyy + "-" + MM + "-" + dd);
        
        if(val < currentDt){ 
            //  event.getSource().focus();
            component.set("v.hide9",true);
        }
        else{
            component.set("v.hide9",false);
        }
    },
    
    //file length modified from 7 to 8 included kit product code, if kit pb type call CSV2JSONKIT helper
    importFile: function(component, event, helper){
        // var test=component.find("options").get("v.value");
        component.set("v.showSpinner",true);
        
        try{
            
            var fileInput = component.find("file").getElement();
            var file = fileInput.files[0];
            var currency = component.find("currencyID").get("v.value");
            var fileName='';
            var fileExtension='';
            fileName = file.name;
            fileExtension = fileName.split('.').pop();
            //alert(fileExtension);
            if(fileExtension == 'csv' || fileExtension == 'CSV') { 
                // if(file.type.includes('/vnd.ms-excel')){   
                if(!currency){
                    var toastEvent1 = $A.get("e.force:showToast");
                    var msg  = $A.get("{!$Label.c.Please_Select_Currency}");
                    var titl  = $A.get("{!$Label.c.Warning}");
                    toastEvent1.setParams({
                        "title": titl,
                        "type": "warning",
                        "message": msg,
                        "duration":'3000'
                    });
                    toastEvent1.fire();
                    
                    // alert("Please select File to Import.");
                    component.set("v.showSpinner",false);
                    component.find("currencyID").focus();
                    
                } 
                else if(!file){
                    var toastEvent1 = $A.get("e.force:showToast");
                    var msg  = $A.get("{!$Label.c.Please_choose_a_file}");
                    var titl  = $A.get("{!$Label.c.Warning}");
                    toastEvent1.setParams({
                        "title": titl,
                        "type": "warning",
                        "message": msg,
                        "duration":'3000'
                    });
                    toastEvent1.fire();
                    
                    // alert("Please select File to Import.");
                    component.set("v.showSpinner",false);
                }   
                    else {
                        // console.log("File");
                        var reader = new FileReader();
                        reader.readAsText(file, "UTF-8");
                        reader.onload = function (evt) {
                            //  console.log("EVT FN");
                            var csv = evt.target.result;
                            //  console.log('@@@ csv file contains'+ csv);
                            // var result = helper.CSV2JSON(component,csv,currency);
                            if(component.get("v.Price_Book_For_Kit")==true){
                                helper.CSV2JSONKIT(component,csv,currency);
                            }else{
                                helper.CSV2JSON(component,csv,currency);
                            }
                            component.find("currencyID").set("v.disabled",true);
                            //  console.log('@@@ result = ' + result);
                            //console.log('@@@ Result = '+JSON.parse(result));
                            // helper.CreateAccount(component,result);
                            
                        }
                        reader.onerror = function (evt) {
                            //  console.log("error reading file");
                            var toastEvent = $A.get("e.force:showToast");
                            var msg  = $A.get("{!$Label.c.File_is_not_readable}");
                            var titl  = $A.get("{!$Label.c.Error}");
                            toastEvent.setParams({
                                "title": titl,
                                "type": "error",
                                "message": msg,
                                "duration":'3000'
                            });
                            toastEvent.fire();
                            
                            component.set("v.showSpinner",false);
                        }
                    }
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.File_is_not_readable}");
                var titl  = $A.get("{!$Label.c.Error}");
                toastEvent.setParams({
                    "title": titl,
                    "type": "error",
                    "message": msg,
                    "duration":'3000'
                });
                toastEvent.fire();
                
                component.set("v.showSpinner",false);
            }
            
        }catch(e){
            // alert(e);
            component.set("v.showSpinner",false);
        } 
    },
    //added kit related attributes on pricebook
    priceBookSave: function(component, event, helper){
        //  console.log('priceBookSave called..');
        component.set("v.showSpinner",true);
        var priceBook = component.get("v.priceBookDetails"); //{};
        //  console.log(priceBook);
        var pb_cmpgn=component.get("v.pb_for_campaign");
        var pb_avec=component.get("v.pb_for_avec");
        var pb_type=component.get("v.priceBookType");
        //alert(pb_cmpgn);
        var cmpgn_tp='';
        var divsn = component.find("HiddenDivisionName").get("v.value");
        var blk_dt='';
        var intr_dt='';
        var obj = new Object();
        var isValid=true;
        var isPriceBookvalid=true;
        var applyMinPrice=component.get("v.applyMinPrice"); // Priya RITM0237685
        console.log('**in Price Save applyMinPrice -> ' +applyMinPrice);
        var apply_discount=component.get("v.apply_discount"); //Divya
        var applySimulation=component.get("v.applySimulation");//Simulation
        var applyPercentage=component.get("v.applyPercentage");
        console.log('**in Price Save applySimulation -> ' +applySimulation);
        var usdRate = component.find("crUsdRate").get("v.value"); //Divya
        if(pb_cmpgn || pb_avec){
            cmpgn_tp=component.get("v.campaignType");
        }
        var pb_nm = component.find("priceBookName").get("v.value");
        var currency = component.find("currencyID").get("v.value");
        //var validfrmDt = component.get("v.myDate");
        // var expiryDt = component.get("v.myDate1");
        var frmDt = $A.localizationService.formatDate(component.get("v.frmDate"), "yyyy-MM-dd"); //component.find("validfrmId").get("v.value");
        
        var toDt = $A.localizationService.formatDate(component.get("v.toDate"), "yyyy-MM-dd");//component.find("expiryId").get("v.value");
        var lasMon = $A.localizationService.formatDate(component.get("v.lasMon"), "yyyy-MM-dd");

        if(pb_cmpgn || pb_avec){
            blk_dt= $A.localizationService.formatDate(component.get("v.bltDate"), "yyyy-MM-dd");//component.find("blck_dt").get("v.value");
            intr_dt = $A.localizationService.formatDate(component.get("v.intrDate"), "yyyy-MM-dd"); //component.find("intr_dt").get("v.value");
        }
        
        var intr_R = component.find("int_rate_R").get("v.value");
        var intr_U = component.find("int_rate_U").get("v.value");
        // sales District     
        var arrOfSalesdist = component.get("v.salesdtarr"); 
        var arrOfSalesdist1 = component.get("v.cropcularr");//added by Sagar@Wipro for PB-003
        var arrOfcustgrps = component.get("v.custgrparr");//added by Sagar@Wipro for PB-004
        var arrOfcustnames = component.get("v.custnamearr");//added by Sagar@Wipro for PB-004
        var mtFile= component.get("v.materialDetails");
        var payObjs = component.get('v.paymentTermsWrapper');
        //  console.log('mt file  '+mtFile.length);
        
        var Today = new Date();
        var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();
        var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
        var yyyy = Today.getFullYear();
        var currentDt = (yyyy + "-" + MM + "-" + dd);
        
        
        
        if(!pb_nm){
            //  console.log('pb_nm isValid '+isValid);
            component.find("priceBookName").set('v.validity', {valid:false, badInput :true});
            component.find("priceBookName").showHelpMessageIfInvalid();
            
            var toastEvent2 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding}");
            var titl  = $A.get("{!$Label.c.Warning}");
            toastEvent2.setParams({
                "title": titl,
                "type": "warning",
                "message": msg,
                "duration":'3000'
            });
            toastEvent2.fire();
            
            isValid=false;
            isPriceBookvalid=false;
        }
        if(pb_nm=='undefined'){
            //  console.log('pb_nm isValid '+isValid);
            component.find("priceBookName").set('v.validity', {valid:false, badInput :true});
            component.find("priceBookName").showHelpMessageIfInvalid();
            
            var toastEvent2 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding}");
            var titl  = $A.get("{!$Label.c.Warning}");
            toastEvent2.setParams({
                "title": titl,
                "type": "warning",
                "message": msg,
                "duration":'3000'
            });
            toastEvent2.fire();
            
            isValid=false;
            isPriceBookvalid=false;
        }
        //Start of change for RITM0339238 (1/4)
        if(!usdRate){
            component.find("crUsdRate").set('v.validity', {valid:false, badInput :true});
            component.find("crUsdRate").showHelpMessageIfInvalid();
            
            var toastEvent2 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding}");
            var titl  = $A.get("{!$Label.c.Warning}");
            toastEvent2.setParams({
                "title": titl,
                "type": "warning",
                "message": msg,
                "duration":'3000'
            });
            toastEvent2.fire();
            
            isValid=false;
            isPriceBookvalid=false;
        }
        if(usdRate=='undefined'){
            component.find("crUsdRate").set('v.validity', {valid:false, badInput :true});
            component.find("crUsdRate").showHelpMessageIfInvalid();
            
            var toastEvent2 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding}");
            var titl  = $A.get("{!$Label.c.Warning}");
            toastEvent2.setParams({
                "title": titl,
                "type": "warning",
                "message": msg,
                "duration":'3000'
            });
            toastEvent2.fire();
            
            isValid=false;
            isPriceBookvalid=false;
        }
        //End of change for RITM0339238 (1/4)
        //  console.log('currency '+currency);
        if(!currency){
            //  console.log('currency isValid '+isValid);
            //  console.log('currency inside if '+currency);
            component.find("currencyID").set('v.validity', {valid:false, badInput :true});
            component.find("currencyID").showHelpMessageIfInvalid();
            isValid=false;
            isPriceBookvalid=false;
        }
        if(frmDt == 'Invalid Date' || !frmDt){
            //  console.log('frmDt isValid '+isValid);
            // component.find("validfrmId").set("v.errors", [{message: "Select Date."}]);
            // $A.util.addClass(component.find("validfrmId"), 'slds-has-error');
            isValid=false;
            isPriceBookvalid=false;
            component.find("validfrmId").set('v.validity', {valid:false, badInput :true});
            component.find("validfrmId").showHelpMessageIfInvalid();
        }
        else if(frmDt < currentDt){
            component.set("v.hide3",true);
            isValid=false;
            isPriceBookvalid=false;
            component.find("validfrmId").set('v.validity', {valid:false, badInput :true});
            component.find("validfrmId").showHelpMessageIfInvalid();
        }
            else{
                component.set("v.hide3",false);   
            }
        
        if(toDt == 'Invalid Date' || !toDt){
            //  console.log('toDt isValid '+isValid);
            // component.find("expiryId").set("v.errors", [{message: "Select Date."}]);
            // $A.util.addClass(component.find("expiryId"), 'slds-has-error');
            isValid=false;
            isPriceBookvalid=false;
            component.find("expiryId").set('v.validity', {valid:false, badInput :true});
            component.find("expiryId").showHelpMessageIfInvalid();
        }
        else if(toDt < frmDt || toDt < currentDt){
            component.set("v.hide5",true);
            isValid=false;
            isPriceBookvalid=false;
            component.find("expiryId").set('v.validity', {valid:false, badInput :true});
            component.find("expiryId").showHelpMessageIfInvalid();
        }
            else{
                component.set("v.hide5",false);
            }
        
        if(currency == "Only BRL"){
            intr_U='0';
            if(!intr_R){
                //  console.log('intr_R isValid '+isValid);
                component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_R").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
            else if(isNaN(intr_R.replace(',','.'))){
                //  console.log('intr_R isValid '+isValid);
                component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_R").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
                else if(intr_R.replace(',','.') < 0){
                    //  console.log('intr_R isValid '+isValid);
                    component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
                    component.find("int_rate_R").showHelpMessageIfInvalid();
                    isValid=false;
                    isPriceBookvalid=false;
                }
            
        }
        
        if(currency == "Only USD"){
            intr_R='0';
            if(!intr_U){
                //  console.log('intr_U isValid '+isValid);
                component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_U").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
            else if(isNaN(intr_U.replace(',','.'))){
                //  console.log('intr_U isValid '+isValid);
                component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_U").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
                else if(intr_U.replace(',','.') < 0){
                    //  console.log('intr_U isValid '+isValid);
                    component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
                    component.find("int_rate_U").showHelpMessageIfInvalid();
                    isValid=false;
                    isPriceBookvalid=false;
                }
        }
        
        if(currency == "BRL and USD"){
            
            if(!intr_R){
                //  console.log('intr_R isValid '+isValid);
                component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_R").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
            else if(isNaN(intr_R.replace(',','.'))){
                //  console.log('intr_R isValid '+isValid);
                component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_R").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
                else if(intr_R.replace(',','.') < 0){
                    //  console.log('intr_R isValid '+isValid);
                    component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
                    component.find("int_rate_R").showHelpMessageIfInvalid();
                    isValid=false;
                    isPriceBookvalid=false;
                }
            
            if(!intr_U){
                //  console.log('intr_U isValid '+isValid);
                component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_U").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
            else if(isNaN(intr_U.replace(',','.'))){
                //  console.log('intr_U isValid '+isValid);
                component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_U").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
                else if(intr_U.replace(',','.') < 0){
                    //  console.log('intr_U isValid '+isValid);
                    component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
                    component.find("int_rate_U").showHelpMessageIfInvalid();
                    isValid=false;
                    isPriceBookvalid=false;
                }
        }
        if(!divsn){
            component.find("DivisionName").set('v.validity', {valid:false, badInput :true});
            component.find("DivisionName").showHelpMessageIfInvalid();
            isValid=false;
            isPriceBookvalid=false;
            //  console.log('Division' +divsn);
        }         
        if(mtFile.length==0){
            
            var toastEvent2 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.File_not_Imported}");
            var titl  = $A.get("{!$Label.c.Error}");
            toastEvent2.setParams({
                "title": titl,
                "type": "error",
                "message": msg,
                "duration":'3000'
            });
            toastEvent2.fire();
            
            // alert('File not Imported.');
            isValid=false;
            isPriceBookvalid=false;
        }
        
        if(pb_cmpgn){
            
            //  console.log('cmpgn_tp '+cmpgn_tp);
            //  console.log('blk_dt '+blk_dt);
            if(!cmpgn_tp){
                
                var toastEvent3 = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Please_select_Campaign_Type}");
                var titl  = $A.get("{!$Label.c.Warning}");
                toastEvent3.setParams({
                    "title": titl,
                    "type": "warning",
                    "message": msg,
                    "duration":'3000'
                });
                toastEvent3.fire();
                
                //alert('Please select Campaign Type.');
                isValid=false;
                isPriceBookvalid=false;
            }
            else if(intr_dt == 'Invalid Date' || !intr_dt){
                //  console.log('intr_dt isValid '+isValid);
                component.find("intr_dt").set('v.validity', {valid:false, badInput :true});
                component.find("intr_dt").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
                else if(intr_dt < currentDt){
                    //  console.log('intr_dt isValid '+isValid);
                    component.set("v.hide6",true);
                    component.find("intr_dt").set('v.validity', {valid:false, badInput :true});
                    component.find("intr_dt").showHelpMessageIfInvalid();
                    isValid=false;
                    isPriceBookvalid=false;
                }
                    else if(blk_dt == 'Invalid Date' || !blk_dt){
                        
                        component.find("blck_dt").set('v.validity', {valid:false, badInput :true});
                        component.find("blck_dt").showHelpMessageIfInvalid();
                        isValid=false;
                        isPriceBookvalid=false;
                    }
                        else if(blk_dt < currentDt){
                            component.set("v.hide7",true);
                            component.find("blck_dt").set('v.validity', {valid:false, badInput :true});
                            component.find("blck_dt").showHelpMessageIfInvalid();
                            isValid=false;
                            isPriceBookvalid=false;
                        }
                            else if(payObjs.length == 0){
                                var toastEvent4 = $A.get("e.force:showToast");
                                var msg  = $A.get("{!$Label.c.Payment_Terms_is_required}");
                                var titl  = $A.get("{!$Label.c.Warning}");
                                toastEvent4.setParams({
                                    "title": titl,
                                    "type": "warning",
                                    "message": msg,
                                    "duration":'3000'
                                });
                                toastEvent4.fire();
                                component.find("tabs").set("v.selectedTabId","tbTwo");
                                isValid=false;
                                isPriceBookvalid=false;
                            }
                                else{
                                    component.set("v.hide6",false);
                                    component.set("v.hide7",false);
                                }
        }
        else if(pb_avec){if(intr_dt == 'Invalid Date' || !intr_dt){
            //  console.log('intr_dt isValid '+isValid);
            component.find("intr_dt").set('v.validity', {valid:false, badInput :true});
            component.find("intr_dt").showHelpMessageIfInvalid();
            isValid=false;
            isPriceBookvalid=false;
        }
                         else if(intr_dt < currentDt){
                             //  console.log('intr_dt isValid '+isValid);
                             component.set("v.hide6",true);
                             component.find("intr_dt").set('v.validity', {valid:false, badInput :true});
                             component.find("intr_dt").showHelpMessageIfInvalid();
                             isValid=false;
                             isPriceBookvalid=false;
                         }
                             else if(blk_dt == 'Invalid Date' || !blk_dt){
                                 
                                 component.find("blck_dt").set('v.validity', {valid:false, badInput :true});
                                 component.find("blck_dt").showHelpMessageIfInvalid();
                                 isValid=false;
                                 isPriceBookvalid=false;
                             }
                                 else if(blk_dt < currentDt){
                                     component.set("v.hide7",true);
                                     component.find("blck_dt").set('v.validity', {valid:false, badInput :true});
                                     component.find("blck_dt").showHelpMessageIfInvalid();
                                     isValid=false;
                                     isPriceBookvalid=false;
                                 }
                         
                        }
            else
            {
        
                cmpgn_tp='';
                blk_dt='';
                intr_dt='';
            
            }
        //  console.log('isPriceBookvalid '+ isPriceBookvalid); 
        //  console.log('isvalid '+ isValid);
        //Divya
        if(usdRate != undefined && usdRate != '')	
		{
			if(isNaN(usdRate.replace(',','.'))){
                //  console.log('intr_U isValid '+isValid);
               component.find("crUsdRate").set('v.validity', {valid:false, badInput :true});
               component.find("crUsdRate").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
           }
            else if(usdRate.replace(',','.') < 0){
                 //  console.log('intr_U isValid '+isValid);
                component.find("crUsdRate").set('v.validity', {valid:false, badInput :true});
                component.find("crUsdRate").showHelpMessageIfInvalid();
                 isValid=false;
                 isPriceBookvalid=false;
            }
		}
        if(isPriceBookvalid){
            
            // validating sales district  
            if(arrOfSalesdist.length == 0){
                // component.set("v.isErrors", true);
                var toastEvent4 = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Sales_District_Entries_Required}");
                var titl  = $A.get("{!$Label.c.Warning}");
                toastEvent4.setParams({
                    "title": titl,
                    "type": "warning",
                    "message": msg,
                    "duration":'3000'
                });
                toastEvent4.fire();
                
                helper.applyCSS(component);
                isValid = false;
                
            }else if(arrOfSalesdist.length > 0){
                
                var duplicateval = component.get("v.showduplicateErr");
                
                for(var i = 0 ;i<arrOfSalesdist.length;i++){
                    for(var j = i+1 ;j<arrOfSalesdist.length;j++){
                        
                        var nameOfSD = arrOfSalesdist[i].Name;
                        if(typeof nameOfSD == "undefined"){
                            component.set("v.showErrOnDiv", true);
                            isValid = false;
                        }else{
                            //  console.log('arrOfSalesdist[i].Name'+arrOfSalesdist[i].Name);
                            if(arrOfSalesdist[i].Name != null || arrOfSalesdist[i].Name != ''){
                                if(arrOfSalesdist[i].Name == arrOfSalesdist[j].Name){
                                    component.set("v.showduplicateErr", true);
                                    isValid = false;
                                }     
                            }
                        }
                    }
                }
                
                if(!duplicateval){
                    for(var i = 0 ;i<arrOfSalesdist.length;i++){
                        if(arrOfSalesdist[i].Name == null){
                            component.set("v.showErrOnDiv", true);
                            isValid = false;
                        }else{
                            component.set("v.showErrOnDiv", false);
                        }
                    }
                }
            }
            
            if(isValid){
                
                obj.pb_for_cmpgn=pb_cmpgn;
                obj.pb_for_avec=pb_avec;

                obj.cmpgn_tp=cmpgn_tp;
                obj.pb_name=pb_nm;
                obj.curncy=currency;
                obj.frm_dt=frmDt;
                obj.exp_dt=toDt;
                obj.las_mon=lasMon;// Modified by by Anmol@wipro for US PB-005

                obj.intr_rt_R=intr_R.replace(',','.');
                obj.intr_rt_U=intr_U.replace(',','.');
                obj.intr_dt=intr_dt;
                obj.division=divsn;
                obj.blk_dt=blk_dt;
                
                //added kit related attributes on pricebook by alamelu
                obj.pb_type=pb_type;
                obj.pb_for_avec=component.get("v.pb_for_avec");

                obj.pb_for_Kit=component.get("v.Price_Book_For_Kit");
                // apply discount matrix and usdrate
                obj.apply_discount=apply_discount; //Divya
                obj.applyMinPrice=applyMinPrice; // Priya RITM0237685
                obj.applySimulation=applySimulation;
                obj.applyPercentage= applyPercentage;//Sagar
                //obj.custgrp=custgrp;//sagar
                if(usdRate != undefined && usdRate != '')
                {obj.usdRate=usdRate.replace(',','.');} //Divya
                
                priceBook=obj;
                console.log(JSON.stringify(priceBook));
                helper.createPriceBook(component, event, helper, priceBook, mtFile, arrOfSalesdist, arrOfSalesdist1,arrOfcustgrps,arrOfcustnames,payObjs);
                
                
                //  console.log('Price book if campaign not checked'+priceBook);
                //alert(priceBook);
            }
            else{
                component.set("v.showSpinner",false);
                var toastEvent3 = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding}");
                var titl  = $A.get("{!$Label.c.Warning}");
                toastEvent3.setParams({
                    "title": titl,
                    "type": "warning",
                    "message": msg,
                    "duration":'3000'
                });
                toastEvent3.fire();
            }
        }
        else{
            component.set("v.showSpinner",false);
            var toastEvent3 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding}");
            var titl  = $A.get("{!$Label.c.Warning}");
            toastEvent3.setParams({
                "title": titl,
                "type": "warning",
                "message": msg,
                "duration":'3000'
            });
            toastEvent3.fire();
        }
        
        
    },
    //added kit related attributes on pricebook
    saveAndApproval: function(component, event, helper){
        //  console.log('saveAndApproval called..');
        component.set("v.showSpinner",true);
        var priceBook = component.get("v.priceBookDetails"); //{};
        //  console.log(priceBook);
        var pb_cmpgn=component.get("v.pb_for_campaign");
        var pb_avec=component.get("v.pb_for_avec");

        
        var pb_type=component.get("v.priceBookType"); //added by alamelu
        //alert(pb_cmpgn);
        var cmpgn_tp='';
        var divsn = component.find("HiddenDivisionName").get("v.value");
        var blk_dt='';
        var intr_dt='';
        var obj = new Object();
        var isValid=true;
        var isPriceBookvalid=true;
        var apply_discount=component.get("v.apply_discount"); //Divya
        var applyMinPrice=component.get("v.applyMinPrice"); // Priya RITM0237685
        var applySimulation=component.get("v.applySimulation");//Simulation
        var applyPercentage=component.get("v.applyPercentage");//sagar
        var usdRate = component.find("crUsdRate").get("v.value"); //Divya
        if(pb_cmpgn || pb_avec){
            cmpgn_tp=component.get("v.campaignType");
        }
        var pb_nm = component.find("priceBookName").get("v.value");
        var currency = component.find("currencyID").get("v.value");
        //var validfrmDt = component.get("v.myDate");
        // var expiryDt = component.get("v.myDate1");
        var frmDt = $A.localizationService.formatDate(component.get("v.frmDate"), "yyyy-MM-dd"); //component.find("validfrmId").get("v.value");
        
        var toDt = $A.localizationService.formatDate(component.get("v.toDate"), "yyyy-MM-dd");//component.find("expiryId").get("v.value");
        var lasMon = $A.localizationService.formatDate(component.get("v.lasMon"), "yyyy-MM-dd");
        console.log('lasMon'+lasMon);
        if(pb_cmpgn || pb_avec){
            blk_dt= $A.localizationService.formatDate(component.get("v.bltDate"), "yyyy-MM-dd");//component.find("blck_dt").get("v.value");
            intr_dt = $A.localizationService.formatDate(component.get("v.intrDate"), "yyyy-MM-dd"); //component.find("intr_dt").get("v.value");
        }
		if(pb_avec){
            cmpgn_tp=component.get("v.campaignType");
        }
        var pb_nm = component.find("priceBookName").get("v.value");
        var currency = component.find("currencyID").get("v.value");
        //var validfrmDt = component.get("v.myDate");
        // var expiryDt = component.get("v.myDate1");
        var frmDt = $A.localizationService.formatDate(component.get("v.frmDate"), "yyyy-MM-dd"); //component.find("validfrmId").get("v.value");
        
        var toDt = $A.localizationService.formatDate(component.get("v.toDate"), "yyyy-MM-dd");//component.find("expiryId").get("v.value");
        
        var lasMon = $A.localizationService.formatDate(component.get("v.lasMon"), "yyyy-MM-dd");
        if(pb_avec){
            blk_dt= $A.localizationService.formatDate(component.get("v.bltDate"), "yyyy-MM-dd");//component.find("blck_dt").get("v.value");
            intr_dt = $A.localizationService.formatDate(component.get("v.intrDate"), "yyyy-MM-dd"); //component.find("intr_dt").get("v.value");
        }


      
        
        var intr_R = component.find("int_rate_R").get("v.value");
        var intr_U = component.find("int_rate_U").get("v.value");
        // sales District     
        var arrOfSalesdist = component.get("v.salesdtarr"); 
        var arrOfSalesdist1 = component.get("v.cropcularr");
        var arrOfcustgrps = component.get("v.custgrparr");
        console.log('arrOfcustgrps'+arrOfcustgrps);
        var arrOfcustnames = component.get("v.custnamearr");
        var custgrp= component.get("v.custgrpid");//sagar		
        var mtFile= component.get("v.materialDetails");
        var payObjs = component.get('v.paymentTermsWrapper');
        //  console.log('mt file  '+mtFile.length);
        
        var Today = new Date();
        var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();
        var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
        var yyyy = Today.getFullYear();
        var currentDt = (yyyy + "-" + MM + "-" + dd);
        
        
        
        if(!pb_nm){
            //  console.log('pb_nm isValid '+isValid);
            component.find("priceBookName").set('v.validity', {valid:false, badInput :true});
            component.find("priceBookName").showHelpMessageIfInvalid();
            
            var toastEvent2 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding}");
            var titl  = $A.get("{!$Label.c.Warning}");
            toastEvent2.setParams({
                "title": titl,
                "type": "warning",
                "message": msg,
                "duration":'3000'
            });
            toastEvent2.fire();
            
            isValid=false;
            isPriceBookvalid=false;
        }
        if(pb_nm=='undefined'){
            //  console.log('pb_nm isValid '+isValid);
            component.find("priceBookName").set('v.validity', {valid:false, badInput :true});
            component.find("priceBookName").showHelpMessageIfInvalid();
            
            var toastEvent2 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding}");
            var titl  = $A.get("{!$Label.c.Warning}");
            toastEvent2.setParams({
                "title": titl,
                "type": "warning",
                "message": msg,
                "duration":'3000'
            });
            toastEvent2.fire();
            
            isValid=false;
            isPriceBookvalid=false;
        }
        //Start of change for RITM0339238 (2/4)
        if(!usdRate){
            component.find("crUsdRate").set('v.validity', {valid:false, badInput :true});
            component.find("crUsdRate").showHelpMessageIfInvalid();
            
            var toastEvent2 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding}");
            var titl  = $A.get("{!$Label.c.Warning}");
            toastEvent2.setParams({
                "title": titl,
                "type": "warning",
                "message": msg,
                "duration":'3000'
            });
            toastEvent2.fire();
            
            isValid=false;
            isPriceBookvalid=false;
        }
        if(usdRate=='undefined'){
            component.find("crUsdRate").set('v.validity', {valid:false, badInput :true});
            component.find("crUsdRate").showHelpMessageIfInvalid();
            
            var toastEvent2 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding}");
            var titl  = $A.get("{!$Label.c.Warning}");
            toastEvent2.setParams({
                "title": titl,
                "type": "warning",
                "message": msg,
                "duration":'3000'
            });
            toastEvent2.fire();
            
            isValid=false;
            isPriceBookvalid=false;
        }
        //End of change for RITM0339238 (2/4)
        //  console.log('currency '+currency);
        if(!currency){
            //  console.log('currency isValid '+isValid);
            //  console.log('currency inside if '+currency);
            component.find("currencyID").set('v.validity', {valid:false, badInput :true});
            component.find("currencyID").showHelpMessageIfInvalid();
            isValid=false;
            isPriceBookvalid=false;
        }
        if(frmDt == 'Invalid Date' || !frmDt){
            //  console.log('frmDt isValid '+isValid);
            // component.find("validfrmId").set("v.errors", [{message: "Select Date."}]);
            // $A.util.addClass(component.find("validfrmId"), 'slds-has-error');
            isValid=false;
            isPriceBookvalid=false;
            component.find("validfrmId").set('v.validity', {valid:false, badInput :true});
            component.find("validfrmId").showHelpMessageIfInvalid();
        }
        else if(frmDt < currentDt){
            component.set("v.hide3",true);
            isValid=false;
            isPriceBookvalid=false;
            component.find("validfrmId").set('v.validity', {valid:false, badInput :true});
            component.find("validfrmId").showHelpMessageIfInvalid();
        }
            else{
                component.set("v.hide3",false);   
            }
        
        if(toDt == 'Invalid Date' || !toDt){
            //  console.log('toDt isValid '+isValid);
            // component.find("expiryId").set("v.errors", [{message: "Select Date."}]);
            // $A.util.addClass(component.find("expiryId"), 'slds-has-error');
            isValid=false;
            isPriceBookvalid=false;
            component.find("expiryId").set('v.validity', {valid:false, badInput :true});
            component.find("expiryId").showHelpMessageIfInvalid();
        }
        else if(toDt < frmDt || toDt < currentDt){
            component.set("v.hide5",true);
            isValid=false;
            isPriceBookvalid=false;
            component.find("expiryId").set('v.validity', {valid:false, badInput :true});
            component.find("expiryId").showHelpMessageIfInvalid();
        }
            else{
                component.set("v.hide5",false);
            }
        
        if(currency == "Only BRL"){
            intr_U='0';
            if(!intr_R){
                //  console.log('intr_R isValid '+isValid);
                component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_R").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
            else if(isNaN(intr_R.replace(',','.'))){
                //  console.log('intr_R isValid '+isValid);
                component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_R").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
                else if(intr_R.replace(',','.') < 0){
                    //  console.log('intr_R isValid '+isValid);
                    component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
                    component.find("int_rate_R").showHelpMessageIfInvalid();
                    isValid=false;
                    isPriceBookvalid=false;
                }
            
        }
        
        if(currency == "Only USD"){
            intr_R='0';
            if(!intr_U){
                //  console.log('intr_U isValid '+isValid);
                component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_U").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
            else if(isNaN(intr_U.replace(',','.'))){
                //  console.log('intr_U isValid '+isValid);
                component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_U").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
                else if(intr_U.replace(',','.') < 0){
                    //  console.log('intr_U isValid '+isValid);
                    component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
                    component.find("int_rate_U").showHelpMessageIfInvalid();
                    isValid=false;
                    isPriceBookvalid=false;
                }
        }
        
        if(currency == "BRL and USD"){
            
            if(!intr_R){
                //  console.log('intr_R isValid '+isValid);
                component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_R").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
            else if(isNaN(intr_R.replace(',','.'))){
                //  console.log('intr_R isValid '+isValid);
                component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_R").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
                else if(intr_R.replace(',','.') < 0){
                    //  console.log('intr_R isValid '+isValid);
                    component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
                    component.find("int_rate_R").showHelpMessageIfInvalid();
                    isValid=false;
                    isPriceBookvalid=false;
                }
            
            if(!intr_U){
                //  console.log('intr_U isValid '+isValid);
                component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_U").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
            else if(isNaN(intr_U.replace(',','.'))){
                //  console.log('intr_U isValid '+isValid);
                component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_U").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
                else if(intr_U.replace(',','.') < 0){
                    //  console.log('intr_U isValid '+isValid);
                    component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
                    component.find("int_rate_U").showHelpMessageIfInvalid();
                    isValid=false;
                    isPriceBookvalid=false;
                }
        }
        if(!divsn){
            component.find("DivisionName").set('v.validity', {valid:false, badInput :true});
            component.find("DivisionName").showHelpMessageIfInvalid();
            isValid=false;
            isPriceBookvalid=false;
            //  console.log('Division' +divsn);
        }         
        if(mtFile.length==0){
            
            var toastEvent2 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.File_not_Imported}");
            var titl  = $A.get("{!$Label.c.Error}");
            toastEvent2.setParams({
                "title": titl,
                "type": "error",
                "message": msg,
                "duration":'3000'
            });
            toastEvent2.fire();
            
            // alert('File not Imported.');
            isValid=false;
            isPriceBookvalid=false;
        }
        
        if(pb_cmpgn){
            
            //  console.log('cmpgn_tp '+cmpgn_tp);
            //  console.log('blk_dt '+blk_dt);
            if(!cmpgn_tp){
                
                var toastEvent3 = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Please_select_Campaign_Type}");
                var titl  = $A.get("{!$Label.c.Warning}");
                toastEvent3.setParams({
                    "title": titl,
                    "type": "warning",
                    "message": msg,
                    "duration":'3000'
                });
                toastEvent3.fire();
                
                //alert('Please select Campaign Type.');
                isValid=false;
                isPriceBookvalid=false;
            }
            else if(intr_dt == 'Invalid Date' || !intr_dt){
                //  console.log('intr_dt isValid '+isValid);
                component.find("intr_dt").set('v.validity', {valid:false, badInput :true});
                component.find("intr_dt").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
                else if(intr_dt < currentDt){
                    //  console.log('intr_dt isValid '+isValid);
                    component.set("v.hide6",true);
                    component.find("intr_dt").set('v.validity', {valid:false, badInput :true});
                    component.find("intr_dt").showHelpMessageIfInvalid();
                    isValid=false;
                    isPriceBookvalid=false;
                }
                    else if(blk_dt == 'Invalid Date' || !blk_dt){
                        
                        component.find("blck_dt").set('v.validity', {valid:false, badInput :true});
                        component.find("blck_dt").showHelpMessageIfInvalid();
                        isValid=false;
                        isPriceBookvalid=false;
                    }
                        else if(blk_dt < currentDt){
                            component.set("v.hide7",true);
                            component.find("blck_dt").set('v.validity', {valid:false, badInput :true});
                            component.find("blck_dt").showHelpMessageIfInvalid();
                            isValid=false;
                            isPriceBookvalid=false;
                        }
                            else if(payObjs.length == 0){
                                var toastEvent4 = $A.get("e.force:showToast");
                                var msg  = $A.get("{!$Label.c.Payment_Terms_is_required}");
                                var titl  = $A.get("{!$Label.c.Warning}");
                                toastEvent4.setParams({
                                    "title": titl,
                                    "type": "warning",
                                    "message": msg,
                                    "duration":'3000'
                                });
                                toastEvent4.fire();
                                component.find("tabs").set("v.selectedTabId","tbTwo");
                                isValid=false;
                                isPriceBookvalid=false;
                            }
                                else{
                                    component.set("v.hide6",false);
                                    component.set("v.hide7",false);
                                }
        }
        else if(pb_avec){if(intr_dt == 'Invalid Date' || !intr_dt){
            //  console.log('intr_dt isValid '+isValid);
            component.find("intr_dt").set('v.validity', {valid:false, badInput :true});
            component.find("intr_dt").showHelpMessageIfInvalid();
            isValid=false;
            isPriceBookvalid=false;
        }
                         else if(intr_dt < currentDt){
                             //  console.log('intr_dt isValid '+isValid);
                             component.set("v.hide6",true);
                             component.find("intr_dt").set('v.validity', {valid:false, badInput :true});
                             component.find("intr_dt").showHelpMessageIfInvalid();
                             isValid=false;
                             isPriceBookvalid=false;
                         }
                             else if(blk_dt == 'Invalid Date' || !blk_dt){
                                 
                                 component.find("blck_dt").set('v.validity', {valid:false, badInput :true});
                                 component.find("blck_dt").showHelpMessageIfInvalid();
                                 isValid=false;
                                 isPriceBookvalid=false;
                             }
                                 else if(blk_dt < currentDt){
                                     component.set("v.hide7",true);
                                     component.find("blck_dt").set('v.validity', {valid:false, badInput :true});
                                     component.find("blck_dt").showHelpMessageIfInvalid();
                                     isValid=false;
                                     isPriceBookvalid=false;
                                 }
                         
                        }
            else
            {
                cmpgn_tp='';
                blk_dt='';
                intr_dt='';
            
            }
        //  console.log('isPriceBookvalid '+ isPriceBookvalid); 
        //  console.log('isvalid '+ isValid);
        //Divya
          console.log('inside usdrate'+usdRate);
          		if(usdRate)	
		{
            console.log('inside usdrate'+usdRate);
            if (usdRate != undefined && usdRate != '' && usdRate != null){
                if(isNaN(usdRate.replace(',','.'))){
                component.find("crUsdRate").set('v.validity', {valid:false, badInput :true});
               component.find("crUsdRate").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
           }
            else if(usdRate.replace(',','.') < 0){
                 //  console.log('intr_U isValid '+isValid);
                component.find("crUsdRate").set('v.validity', {valid:false, badInput :true});
                component.find("crUsdRate").showHelpMessageIfInvalid();
                 isValid=false;
                 isPriceBookvalid=false;
            }
            }
		}
         if(isPriceBookvalid){
             
             // validating sales district  
             if(arrOfSalesdist.length == 0){
                 // component.set("v.isErrors", true);
                 var toastEvent4 = $A.get("e.force:showToast");
                 var msg  = $A.get("{!$Label.c.Sales_District_Entries_Required}");
                 var titl  = $A.get("{!$Label.c.Warning}");
                 toastEvent4.setParams({
                     "title": titl,
                     "type": "warning",
                     "message": msg,
                     "duration":'3000'
                 });
                 toastEvent4.fire();
                 
                 helper.applyCSS(component);
                 isValid = false;
                 
             }else if(arrOfSalesdist.length > 0){
                 
                 var duplicateval = component.get("v.showduplicateErr");
                 
                 for(var i = 0 ;i<arrOfSalesdist.length;i++){
                     for(var j = i+1 ;j<arrOfSalesdist.length;j++){
                         
                         var nameOfSD = arrOfSalesdist[i].Name;
                         if(typeof nameOfSD == "undefined"){
                             component.set("v.showErrOnDiv", true);
                             isValid = false;
                         }else{
                             //  console.log('arrOfSalesdist[i].Name'+arrOfSalesdist[i].Name);
                             if(arrOfSalesdist[i].Name != null || arrOfSalesdist[i].Name != ''){
                                 if(arrOfSalesdist[i].Name == arrOfSalesdist[j].Name){
                                     component.set("v.showduplicateErr", true);
                                     isValid = false;
                                 }     
                             }
                         }
                     }
                 }
                 
                 if(!duplicateval){
                     for(var i = 0 ;i<arrOfSalesdist.length;i++){
                         if(arrOfSalesdist[i].Name == null){
                             component.set("v.showErrOnDiv", true);
                             isValid = false;
                         }else{
                             component.set("v.showErrOnDiv", false);
                         }
                     }
                 }
             }
             
             if(isValid){
                 
                 obj.pb_for_cmpgn=pb_cmpgn;
                 obj.pb_for_avec=pb_avec;

                 obj.cmpgn_tp=cmpgn_tp;
                 obj.pb_name=pb_nm;
                 obj.curncy=currency;
                 obj.frm_dt=frmDt;
                 obj.exp_dt=toDt;
                 obj.las_mon=lasMon;// Modified by by Anmol@wipro for US PB-005

                 obj.intr_rt_R=intr_R.replace(',','.');
                 obj.intr_rt_U=intr_U.replace(',','.');
                 obj.intr_dt=intr_dt;
                 obj.division=divsn;
                 obj.blk_dt=blk_dt;
                 //added by alamelu for kit prod
                 obj.pb_type=pb_type;
                 obj.pb_for_Kit=component.get("v.Price_Book_For_Kit");
                 // apply discount matrix and usdrate
                 obj.apply_discount=apply_discount; //Divya
                 obj.applyMinPrice=applyMinPrice; // Priya RITM0237685
                 obj.applySimulation=applySimulation; //Simulation
                 obj.applyPercentage= applyPercentage;
                 //obj.custgrp=custgrp;//sagar
                 


                 if(usdRate != undefined && usdRate != '')
                 {obj.usdRate=usdRate.replace(',','.');} //Divya
                 
                 priceBook=obj;
                 
                 helper.saveAndSubmitApproval(component, event, helper, priceBook, mtFile, arrOfSalesdist,arrOfSalesdist1,arrOfcustgrps,arrOfcustnames, payObjs);
                 
                 //  console.log('Price book if campaign not checked'+priceBook);
                 //alert(priceBook);
             } 
             else{
                 component.set("v.showSpinner",false);
                 var toastEvent3 = $A.get("e.force:showToast");
                 var msg  = $A.get("{!$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding}");
                 var titl  = $A.get("{!$Label.c.Warning}");
                 toastEvent3.setParams({
                     "title": titl,
                     "type": "warning",
                     "message": msg,
                     "duration":'3000'
                 });
                 toastEvent3.fire();
             }
         }
         else{
             component.set("v.showSpinner",false);
             var toastEvent3 = $A.get("e.force:showToast");
             var msg  = $A.get("{!$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding}");
             var titl  = $A.get("{!$Label.c.Warning}");
             toastEvent3.setParams({
                 "title": titl,
                 "type": "warning",
                 "message": msg,
                 "duration":'3000'
             });
             toastEvent3.fire();
         }
         
    },
        //added by Atish
      getMyTasks: function(cmp){
          var action = cmp.get("c.getUplFiles");
          action.setCallback(this, function(response){
              var state = response.getState();
              if (state === "SUCCESS") {
                  cmp.set("v.ContentDocumentfiles", response.getReturnValue());
              }
          });
       $A.enqueueAction(action);
      },
       getMyAttachments: function(component){
          var action = component.get("c.getUploadItems");
          action.setCallback(this, function(response){
              var state = response.getState();
              if (state === "SUCCESS") {
                  component.set("v.testUpload", response.getReturnValue());
              }
          });
       $A.enqueueAction(action);
     },
    //added kit related attributes on pricebook
    priceBookUpdate: function(component, event, helper){
        //  console.log('priceBookUpdate called..');
        component.set("v.showSpinner",true);
        var priceBook = component.get("v.priceBookDetails"); //{};
        var recordId = component.get("v.recordId");
           //by atish
           component.set("v.recordsId",recordId); 

        
        //  console.log(priceBook);
        var pb_cmpgn=component.get("v.pb_for_campaign");
        var pb_avec=component.get("v.pb_for_avec");

        var pb_for_kit=component.get("v.Price_Book_For_Kit");
        //alert(pb_cmpgn);
        var cmpgn_tp='';
        var divsn=component.find("HiddenDivisionName").get("v.value");
        var blk_dt='';
        var intr_dt ='';
        var obj = new Object();
        var isValid=true;
        var isPriceBookvalid=true;
        var apply_discount=component.get("v.apply_discount"); //Divya
        var usdRate = component.find("crUsdRate").get("v.value"); //Divya
        console.log('apply_discount in update '+apply_discount);
        var applyMinPrice=component.get("v.applyMinPrice"); // Priya RITM0237685
        console.log('**in update applyMinPrice -> '+applyMinPrice);
        var applySimulation=component.get("v.applySimulation"); //Simulation
        console.log('**in update applySimulation -> '+applySimulation);
        var applyPercentage=component.get("v.applyPercentage");//Sagar
        
        if(pb_cmpgn || pb_avec ){
            cmpgn_tp=component.get("v.campaignType");
        }
        var pb_nm = component.find("priceBookName").get("v.value");
        var currency = component.find("currencyID").get("v.value");
        //var validfrmDt = component.get("v.myDate");
        // var expiryDt = component.get("v.myDate1");
        var frmDt = $A.localizationService.formatDate(component.get("v.frmDate"), "yyyy-MM-dd");//component.find("validfrmId").get("v.value");
        var toDt = $A.localizationService.formatDate(component.get("v.toDate"), "yyyy-MM-dd");//component.find("expiryId").get("v.value");
		var lasMon = $A.localizationService.formatDate(component.get("v.lasMon"), "yyyy-MM-dd");
        if(pb_cmpgn || pb_avec ){
            blk_dt= $A.localizationService.formatDate(component.get("v.bltDate"), "yyyy-MM-dd");//component.find("blck_dt").get("v.value");
            intr_dt = $A.localizationService.formatDate(component.get("v.intrDate"), "yyyy-MM-dd");//component.find("intr_dt").get("v.value");
        }
        
        var intr_R = component.find("int_rate_R").get("v.value");
        var intr_U = component.find("int_rate_U").get("v.value");
        var mtFile= component.get("v.materialDetails");
        var mtFileDelete =  component.get("v.materialToDelete");
        var payObjs = component.get('v.paymentTermsWrapper');
        var payObjsDelete = component.get('v.paymentTermsToDelete');
        var arrOfSalesdist = component.get("v.salesdtarr");
        var arrOfSalesdist1 = component.get("v.cropcularr");
        var arrOfcustgrps = component.get("v.custgrparr");
        console.log('arrOfcustgrps'+arrOfcustgrps);
        var arrOfcustnames = component.get("v.custnamearr");

        // console.log('mt file  '+mtFile.length);
        
        var Today = new Date();
        var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();
        var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
        var yyyy = Today.getFullYear();
        var currentDt = (yyyy + "-" + MM + "-" + dd);
        
        if(!pb_nm){
            //  console.log('pb_nm isValid '+isValid);
            component.find("priceBookName").set('v.validity', {valid:false, badInput :true});
            component.find("priceBookName").showHelpMessageIfInvalid();
            isValid=false;
            isPriceBookvalid=false;
            
            var toastEvent2 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding}");
            var titl  = $A.get("{!$Label.c.Warning}");
            toastEvent2.setParams({
                "title": titl,
                "type": "warning",
                "message": msg,
                "duration":'3000'
            });
            toastEvent2.fire();
        }
        
        if(pb_nm=='undefined'){
            //  console.log('pb_nm isValid '+isValid);
            component.find("priceBookName").set('v.validity', {valid:false, badInput :true});
            component.find("priceBookName").showHelpMessageIfInvalid();
            
            var toastEvent2 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding}");
            var titl  = $A.get("{!$Label.c.Warning}");
            toastEvent2.setParams({
                "title": titl,
                "type": "warning",
                "message": msg,
                "duration":'3000'
            });
            toastEvent2.fire();
            
            isValid=false;
            isPriceBookvalid=false;
        }
        //Start of change for RITM0339238 (3/4)
        if(!usdRate){
            component.find("crUsdRate").set('v.validity', {valid:false, badInput :true});
            component.find("crUsdRate").showHelpMessageIfInvalid();
            
            var toastEvent2 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding}");
            var titl  = $A.get("{!$Label.c.Warning}");
            toastEvent2.setParams({
                "title": titl,
                "type": "warning",
                "message": msg,
                "duration":'3000'
            });
            toastEvent2.fire();
            
            isValid=false;
            isPriceBookvalid=false;
        }
        if(usdRate=='undefined'){
            component.find("crUsdRate").set('v.validity', {valid:false, badInput :true});
            component.find("crUsdRate").showHelpMessageIfInvalid();
            
            var toastEvent2 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding}");
            var titl  = $A.get("{!$Label.c.Warning}");
            toastEvent2.setParams({
                "title": titl,
                "type": "warning",
                "message": msg,
                "duration":'3000'
            });
            toastEvent2.fire();
            
            isValid=false;
            isPriceBookvalid=false;
        }
        //End of change for RITM0339238 (3/4)
        
        if(!currency){
            //  console.log('currency isValid '+isValid);
            //  console.log('currency inside if '+currency);
            component.find("currencyID").set('v.validity', {valid:false, badInput :true});
            component.find("currencyID").showHelpMessageIfInvalid();
            isValid=false;
            isPriceBookvalid=false;
        }
        if(frmDt == 'Invalid Date' || !frmDt){
            //  console.log('frmDt isValid '+isValid);
            // component.find("validfrmId").set("v.errors", [{message: "Select Date."}]);
            // $A.util.addClass(component.find("validfrmId"), 'slds-has-error');
            isValid=false;
            isPriceBookvalid=false;
            component.find("validfrmId").set('v.validity', {valid:false, badInput :true});
            component.find("validfrmId").showHelpMessageIfInvalid();
        }
        else if(frmDt < currentDt){
            isValid=false;
            isPriceBookvalid=false;
            component.find("validfrmId").set('v.validity', {valid:false, badInput :true});
            component.find("validfrmId").showHelpMessageIfInvalid();
            component.set("v.hide3",true);
        }
            else{
                component.set("v.hide3",false);
            }
        if(toDt == 'Invalid Date' || !toDt){
            //  console.log('toDt isValid '+isValid);
            // component.find("expiryId").set("v.errors", [{message: "Select Date."}]);
            // $A.util.addClass(component.find("expiryId"), 'slds-has-error');
            isValid=false;
            isPriceBookvalid=false;
            component.find("expiryId").set('v.validity', {valid:false, badInput :true});
            component.find("expiryId").showHelpMessageIfInvalid();
        }
        else if(toDt < frmDt || toDt < currentDt){
            //  console.log('toDt isValid '+isValid);
            // component.find("expiryId").set("v.errors", [{message: "Select Date."}]);
            // $A.util.addClass(component.find("expiryId"), 'slds-has-error');
            isValid=false;
            isPriceBookvalid=false;
            component.find("expiryId").set('v.validity', {valid:false, badInput :true});
            component.find("expiryId").showHelpMessageIfInvalid();
            component.set("v.hide5",true);
        }
            else{
                component.set("v.hide5",false);
            }
        
        if(currency == "Only BRL"){
            intr_U='0';
            if(!intr_R){
                //  console.log('intr_R isValid '+isValid);
                component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_R").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
            else if(isNaN(intr_R.replace(',','.'))){
                //  console.log('intr_R isValid '+isValid);
                component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_R").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
                else if(intr_R.replace(',','.') < 0){
                    //  console.log('intr_R isValid '+isValid);
                    component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
                    component.find("int_rate_R").showHelpMessageIfInvalid();
                    isValid=false;
                    isPriceBookvalid=false;
                }
            
        }
        
        if(currency == "Only USD"){
            intr_R='0';
            if(!intr_U){
                //  console.log('intr_U isValid '+isValid);
                component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_U").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
            else if(isNaN(intr_U.replace(',','.'))){
                //  console.log('intr_U isValid '+isValid);
                component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_U").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
                else if(intr_U.replace(',','.') < 0){
                    //  console.log('intr_U isValid '+isValid);
                    component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
                    component.find("int_rate_U").showHelpMessageIfInvalid();
                    isValid=false;
                    isPriceBookvalid=false;
                }
        }
        
        if(currency == "BRL and USD"){
            
            if(!intr_R){
                //  console.log('intr_R isValid '+isValid);
                component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_R").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
            else if(isNaN(intr_R.replace(',','.'))){
                //  console.log('intr_R isValid '+isValid);
                component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_R").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
                else if(intr_R.replace(',','.') < 0){
                    //  console.log('intr_R isValid '+isValid);
                    component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
                    component.find("int_rate_R").showHelpMessageIfInvalid();
                    isValid=false;
                    isPriceBookvalid=false;
                }
            
            if(!intr_U){
                //  console.log('intr_U isValid '+isValid);
                component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_U").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
            else if(isNaN(intr_U.replace(',','.'))){
                //  console.log('intr_U isValid '+isValid);
                component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_U").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
                else if(intr_U.replace(',','.') < 0){
                    //  console.log('intr_U isValid '+isValid);
                    component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
                    component.find("int_rate_U").showHelpMessageIfInvalid();
                    isValid=false;
                    isPriceBookvalid=false;
                }
        }
        if(!divsn){
            component.find("DivisionName").set('v.validity', {valid:false, badInput :true});
            component.find("DivisionName").showHelpMessageIfInvalid();
            isValid=false;
            isPriceBookvalid=false;
            //  console.log('Division' +divsn);
        } 
        
        if(mtFile.length==0){
            var toastEvent2 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.File_not_Imported}");
            var titl  = $A.get("{!$Label.c.Error}");
            toastEvent2.setParams({
                "title": titl,
                "type": "error",
                "message": msg,
                "duration":'3000'
            });
            toastEvent2.fire();
            //alert('File not Imported.');
            isValid=false;
            isPriceBookvalid=false;
        }
        
        if(pb_cmpgn){
            
            //  console.log('cmpgn_tp '+cmpgn_tp);
            //  console.log('blk_dt '+blk_dt);
            if(!cmpgn_tp){
                var toastEvent3 = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Please_select_Campaign_Type}");
                var titl  = $A.get("{!$Label.c.Warning}");
                toastEvent3.setParams({
                    "title": titl,
                    "type": "warning",
                    "message": msg,
                    "duration":'3000'
                });
                toastEvent3.fire();
                // alert('Please select Campaign Type.');
                isValid=false;
                isPriceBookvalid=false;
            }
            else if(intr_dt == 'Invalid Date' || !intr_dt){
                //  console.log('intr_dt isValid '+isValid);
                component.find("intr_dt").set('v.validity', {valid:false, badInput :true});
                component.find("intr_dt").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
                else if(intr_dt < currentDt){
                    //  console.log('intr_dt isValid '+isValid);
                    component.find("intr_dt").set('v.validity', {valid:false, badInput :true});
                    component.find("intr_dt").showHelpMessageIfInvalid();
                    isValid=false;
                    isPriceBookvalid=false;
                    component.set("v.hide6",true);
                }
                    else if(blk_dt == 'Invalid Date' || !blk_dt){
                        
                        component.find("blck_dt").set('v.validity', {valid:false, badInput :true});
                        component.find("blck_dt").showHelpMessageIfInvalid();
                        isValid=false;
                        isPriceBookvalid=false;
                    }
                        else if(blk_dt < currentDt){
                            
                            component.find("blck_dt").set('v.validity', {valid:false, badInput :true});
                            component.find("blck_dt").showHelpMessageIfInvalid();
                            isValid=false;
                            isPriceBookvalid=false;
                            component.set("v.hide7",true);
                        }
                            else if(payObjs.length == 0){
                                var toastEvent4 = $A.get("e.force:showToast");
                                var msg  = $A.get("{!$Label.c.Payment_Terms_is_required}");
                                var titl  = $A.get("{!$Label.c.Warning}");
                                toastEvent4.setParams({
                                    "title": titl,
                                    "type": "warning",
                                    "message": msg,
                                    "duration":'3000'
                                });
                                toastEvent4.fire();
                                component.find("tabs").set("v.selectedTabId","tbTwo");
                                isValid=false;
                                isPriceBookvalid=false;
                            }
                                else{
                                    component.set("v.hide6",false);
                                    component.set("v.hide7",false);
                                }
            
        }
        else{
            cmpgn_tp='';
            blk_dt='';
            intr_dt='';
            
        }
        //  console.log('isvalid '+ isValid);
        // Divya
        if(usdRate)	
        {
            if(usdRate != undefined && usdRate != '' && usdRate != null){
                if(isNaN(usdRate.replace(',','.'))){
                    //  console.log('intr_U isValid '+isValid);
                    component.find("crUsdRate").set('v.validity', {valid:false, badInput :true});
                    component.find("crUsdRate").showHelpMessageIfInvalid();
                    isValid=false;
                    isPriceBookvalid=false;
                }
                else if(usdRate.replace(',','.') < 0){
                    //  console.log('intr_U isValid '+isValid);
                    component.find("crUsdRate").set('v.validity', {valid:false, badInput :true});
                    component.find("crUsdRate").showHelpMessageIfInvalid();
                    isValid=false;
                    isPriceBookvalid=false;
                }
            }
        }
        if(isPriceBookvalid){
            
            // validating sales district  
            if(arrOfSalesdist.length == 0){
                // component.set("v.isErrors", true);
                var toastEvent4 = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Sales_District_Entries_Required}");
                var titl  = $A.get("{!$Label.c.Warning}");
                toastEvent4.setParams({
                    "title": titl,
                    "type": "warning",
                    "message": msg,
                    "duration":'3000'
                });
                toastEvent4.fire();
                
                helper.applyCSS(component);
                isValid = false;
                
            }else if(arrOfSalesdist.length > 0){
                
                var duplicateval = component.get("v.showduplicateErr");
                
                for(var i = 0 ;i<arrOfSalesdist.length;i++){
                    for(var j = i+1 ;j<arrOfSalesdist.length;j++){
                        
                        var nameOfSD = arrOfSalesdist[i].Name;
                        if(typeof nameOfSD == "undefined"){
                            component.set("v.showErrOnDiv", true);
                            isValid = false;
                        }else{
                            //  console.log('arrOfSalesdist[i].Name'+arrOfSalesdist[i].Name);
                            if(arrOfSalesdist[i].Name != null || arrOfSalesdist[i].Name != ''){
                                if(arrOfSalesdist[i].Name == arrOfSalesdist[j].Name){
                                    component.set("v.showduplicateErr", true);
                                    isValid = false;
                                }     
                            }
                        }
                    }
                }
                
                if(!duplicateval){
                    for(var i = 0 ;i<arrOfSalesdist.length;i++){
                        if(arrOfSalesdist[i].Name == null){
                            component.set("v.showErrOnDiv", true);
                            isValid = false;
                        }else{
                            component.set("v.showErrOnDiv", false);
                        }
                    }
                }
            }
            if(isValid){
                obj.pcb_id=recordId;
                obj.pb_for_cmpgn=pb_cmpgn;
                obj.pb_for_avec=pb_avec;

                obj.cmpgn_tp=cmpgn_tp;
                obj.pb_name=pb_nm;
                obj.curncy=currency;
                obj.frm_dt=frmDt;
                obj.exp_dt=toDt;
                obj.intr_rt_R=intr_R.replace(',','.');
                obj.intr_rt_U=intr_U.replace(',','.');
                obj.intr_dt=intr_dt;
                obj.division=divsn;
                obj.blk_dt=blk_dt;
                obj.pb_for_Kit=pb_for_kit;
                obj.apply_discount=apply_discount; //Divya
                obj.applyMinPrice=applyMinPrice; // Priya RITM0237685
                obj.applySimulation=applySimulation; //Simulation
                obj.applyPercentage= applyPercentage;	 
                obj.las_mon=lasMon;
                if(usdRate != undefined && usdRate != '')
                {obj.usdRate=usdRate.replace(',','.');} //Divya
                
                priceBook=obj;
                
                helper.updatePriceBook(component, event, helper, priceBook, mtFile, mtFileDelete, payObjs, payObjsDelete, arrOfSalesdist,arrOfSalesdist1,arrOfcustgrps,arrOfcustnames);
                
                //  console.log('Price book if campaign not checked'+priceBook);
                //alert(priceBook);
            }
            else{
                component.set("v.showSpinner",false);
                var toastEvent3 = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding}");
                var titl  = $A.get("{!$Label.c.Warning}");
                toastEvent3.setParams({
                    "title": titl,
                    "type": "warning",
                    "message": msg,
                    "duration":'3000'
                });
                toastEvent3.fire();
            }
        }
        else{
            component.set("v.showSpinner",false);
            var toastEvent3 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding}");
            var titl  = $A.get("{!$Label.c.Warning}");
            toastEvent3.setParams({
                "title": titl,
                "type": "warning",
                "message": msg,
                "duration":'3000'
            });
            toastEvent3.fire();
        }
        
        
    },
    
    deleteSku : function(component, event, helper){
        // alert('deleteSku called');
        var target = event.getSource();  
        var index = target.get("v.value");
        var sku = component.get("v.materialDetails");
        if (index > -1) {
            sku.splice(index, 1);
        }
        component.set("v.materialDetails", sku);
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
            
            // helper.goDown(component);   
        }catch(error){
            console.log('error-->'+error);
        }   
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
    
    handleRemoveSalesDist : function(component, event, helper){
        var target = event.getSource();  
        var index = target.get("v.value");
        helper.removeSalesDist(component, index);
        
    },
     
	handleRemoveCropCulture : function(component, event, helper){
        var target = event.getSource();  
        var index = target.get("v.value");
        helper.removeCropCulture(component, index);
        
    },
    
    handleRemoveCustomerGroup : function(component, event, helper){
        var target = event.getSource();  
        var index = target.get("v.value");
        helper.removeCustomerGroup(component, index);
        //component.set("v.iscustgrp",true);
        component.set("v.custgrpid",'');
    },
    
    handleRemoveCustomerNames : function(component, event, helper){
        var target = event.getSource();  
        var index = target.get("v.value");
        helper.removeCustomerName(component, index);
        
    },
    
    addcropcul : function(component, event, helper){    
        try{
            var sd = component.get("v.cropcularr");
            sd.push({
                'Id':'',
                'sdtId1':'',
                'sdtNameforSales1':''
            });
            component.set("v.cropcularr",sd);
            
            // helper.goDown(component);   
        }catch(error){
            console.log('error-->'+error);
        }   
    },
    
    openSDModel1: function(component, event, helper){
        try{
            
            var target = event.getSource();  
            var rowIndexValue = target.get("v.value");            
            component.set("v.rowIndex",rowIndexValue);
            helper.fetchCropCultures(component);
            component.set("v.isOpen", true);
            helper.applyCSS(component);
            
        }catch(error){
            console.log('error-->'+error);
        }
    },
    
addcustgrp : function(component, event, helper){        
        try{
            var sd = component.get("v.custgrparr");
            sd.push({
                'Id':'',
                'sdtId2':'',
                'sdtNameforSales2':''
            });
            component.set("v.custgrparr",sd);
            
            // helper.goDown(component);   
        }catch(error){
            console.log('error-->'+error);
        }   
    },   
    
     openSDModel11: function(component, event, helper){
        try{
            
            var target = event.getSource();  
            var rowIndexValue = target.get("v.value");            
            component.set("v.rowIndex",rowIndexValue);
            helper.fetchCustomerGroups(component);
            component.set("v.isOpen", true);
            helper.applyCSS(component);
            
        }catch(error){
            console.log('error-->'+error);
        }
    },
    
    addcustname : function(component, event, helper){        
        try{
            var sd = component.get("v.custnamearr");
            sd.push({
                'Id':'',
                'Name':'',
                'custgrpname':'',
                'sapcode':'',
                'depotcode':''
            });
            component.set("v.custnamearr",sd);
            
            // helper.goDown(component);   
        }catch(error){
            console.log('error-->'+error);
        }   
    },  
    
     openSDModel2: function(component, event, helper){
        try{
            var custid1 = component.get("v.custgrpid");
            console.log('***custid***',custid1);
            var target = event.getSource();  
            var rowIndexValue = target.get("v.value");            
            component.set("v.rowIndex",rowIndexValue);
            helper.fetchCustomerNames(component,custid1);
            component.set("v.isOpen", true);
            helper.applyCSS(component);
            
        }catch(error){
            console.log('error-->'+error);
        }
    },
	
    
    disablePayment : function(component, event, helper){
        //  console.log('disablePayment called......');
        var recordId = component.get("v.recordId"); 
        var record= component.get("v.priceBookDetails");
        var clone = component.get("v.isClone");
        if(recordId != null){
            if(record.status == 'Waiting Approval'){
                
                component.find("pay_date").set("v.disabled",true);
                component.find("pay_dateBtn").set("v.disabled",true);
                component.find("pay_term").set("v.disabled",true);
                component.find("pay_termBtn").set("v.disabled",true);
            }
            else if(record.status == 'Approved'){
                component.find("pay_date").set("v.disabled",true);
                component.find("pay_dateBtn").set("v.disabled",true);
                component.find("pay_term").set("v.disabled",true);
                component.find("pay_termBtn").set("v.disabled",true);
            }
                else if(record.status == 'Canceled'){
                    component.find("pay_date").set("v.disabled",true);
                    component.find("pay_dateBtn").set("v.disabled",true);
                    component.find("pay_term").set("v.disabled",true);
                    component.find("pay_termBtn").set("v.disabled",true);
                }
                    else{
                        
                    }
        }
        if(clone == true){
            component.find("pay_date").set("v.disabled",false);
            component.find("pay_dateBtn").set("v.disabled",false);
            component.find("pay_term").set("v.disabled",false);
            component.find("pay_termBtn").set("v.disabled",false);
            
            component.set("v.hideDeleteBtn",true);
        }
        
        
        
    },
    
    
    onSelectedPayAdd: function(component, event, helper){
        //  console.log('onSelectedPayAdd called......');
        
        var payObjs = component.get('v.paymentTermsWrapper');
        var comp = component.get("v.paymentTerms"), 
            val = component.find("pay_term").get("v.value");
        var paySet= component.get("v.paymentSet");
        var flag = true;     
        var payMap  = JSON.stringify(comp);
        var obj = JSON.parse(payMap);
        
        contains(obj, "Id", val); //true
        
        function contains(arr, key, val) {
            for (var i = 0; i < arr.length; i++) {
                if(arr[i][key] === val){
                    
                    var obj2={};
                    
                    if(payObjs.length == 0){
                        
                        obj2.pt_id=val;
                        obj2.pt_name=arr[i].Payterms_Desc__c;
                        obj2.pt_type='day';
                        payObjs.push(obj2);  
                        paySet.push(arr[i].Payterms_Desc__c);
                        
                    }
                    else{
                        //  console.log(paySet);
                        
                        for(var j=0;j<paySet.length;j++){
                            if(paySet[j]== arr[i].Payterms_Desc__c){
                                flag=false;
                                break;
                            }
                        }
                        
                        if(flag){
                            obj2.pt_id=val;
                            obj2.pt_name=arr[i].Payterms_Desc__c;
                            obj2.pt_type='day';
                            payObjs.push(obj2); 
                            paySet.push(arr[i].Payterms_Desc__c); 
                        }
                        else{
                            component.find("pay_term").focus();
                            var toastEvent4 = $A.get("e.force:showToast");
                            var msg  = $A.get("{!$Label.c.Duplicate_entries_are_not_allowed}");
                            var titl  = $A.get("{!$Label.c.Error}");
                            toastEvent4.setParams({
                                "title": titl,
                                "type": "error",
                                "message": msg,
                                "duration":'3000'
                            });
                            toastEvent4.fire();
                        }
                        
                    }
                    //  console.log(paySet);  
                    component.set('v.paymentTermsWrapper', payObjs);   
                    return true;
                }
            }
        }
    },
    
    onSelectedPayDateAdd: function(component, event, helper){
        //  console.log('onSelectedPayDateAdd called......');
        
        var payObjs = component.get('v.paymentTermsWrapper');
        var val = component.find("pay_date").get("v.value");
        var paySet= component.get("v.paymentSet");
        var flag = true;     
        var obj2={};
        
        var Today = new Date();
        var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();
        var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
        var yyyy = Today.getFullYear();
        var currentDt = (yyyy + "-" + MM + "-" + dd);
        
        
        
        if(val){ 
            if(val < currentDt){
                component.find("pay_date").focus();
                var toastEvent4 = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Current_Date_validate}");
                var titl  = $A.get("{!$Label.c.Warning}");
                toastEvent4.setParams({
                    "title": titl,
                    "type": "warning",
                    "message": msg,
                    "duration":'3000'
                });
                toastEvent4.fire();
            }
            else{          
                if(payObjs.length == 0){
                    
                    obj2.pt_name=val;
                    obj2.pt_type='date';
                    payObjs.push(obj2);  
                    paySet.push(val);
                    component.set('v.paymentTermsWrapper', payObjs);
                }
                else{
                    //  console.log(paySet);
                    
                    for(var j=0;j<paySet.length;j++){
                        if(paySet[j]== val){
                            flag=false;
                            break;
                        }
                    }
                    
                    if(flag){
                        
                        obj2.pt_name=val;
                        obj2.pt_type='date';
                        payObjs.push(obj2); 
                        paySet.push(val); 
                        component.set('v.paymentTermsWrapper', payObjs);
                    }
                    else{
                        component.find("pay_date").focus();
                        var toastEvent4 = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.Duplicate_entries_are_not_allowed}");
                        var titl  = $A.get("{!$Label.c.Error}");
                        toastEvent4.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg,
                            "duration":'3000'
                        });
                        toastEvent4.fire();
                    } 
                }
            }
        }
        //  console.log(paySet);  
        
        
    },
    
    deletePay : function(component, event, helper){
        // alert('deleteSku called');
        
        var target = event.getSource();  
        var index = target.get("v.value");
        var id = target.get("v.name");
        
        if(id){
            var terms = component.get('v.paymentTermsToDelete'); 
            var newWrapper = new Array();
            
            newWrapper = {
                'id':id,
                'pt_id':'',
                'pt_name':'',
                'pt_date':'',
                'pBook':'',
                'pt_type':''
                
            };
            terms.push(newWrapper);
            // alert(materials.length);    
            component.set('v.paymentTermsToDelete',terms);
        }
        
        var pay = component.get("v.paymentTermsWrapper");
        var paySet= component.get("v.paymentSet");
        if (index > -1) {
            pay.splice(index, 1);
            paySet.splice(index, 1);
        }
        component.set("v.paymentTermsWrapper", pay);
        component.set("v.paymentSet", paySet); 
        
        
    },
    
    submitApproval : function(component, event, helper){
        //  console.log('submitApproval called..');
        component.set("v.showSpinner",true);
        var recordId = component.get("v.recordId");
        var Today = new Date();
        var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();
        var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
        var yyyy = Today.getFullYear();
        var currentDt = (yyyy + "-" + MM + "-" + dd);
        var frmDt = $A.localizationService.formatDate(component.get("v.frmDate"), "yyyy-MM-dd"); //component.find("validfrmId").get("v.value");
        var toDt = $A.localizationService.formatDate(component.get("v.toDate"), "yyyy-MM-dd");//component.find("expiryId").get("v.value");
        /*if(pb_cmpgn || pb_avec ){
            blk_dt= $A.localizationService.formatDate(component.get("v.bltDate"), "yyyy-MM-dd");//component.find("blck_dt").get("v.value");
            intr_dt = $A.localizationService.formatDate(component.get("v.intrDate"), "yyyy-MM-dd"); //component.find("intr_dt").get("v.value");
        }*/
        
        /* if(frmDt > currentDt){
            var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.Valid_From_Date_Greater_Than_Today}");
                        var titl  = $A.get("{!$Label.c.Error}");
                        toastEvent.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg
                        });
                        toastEvent.fire();
        }
        else*/
         if(toDt < currentDt){
             var toastEvent = $A.get("e.force:showToast");
             var msg  = $A.get("{!$Label.c.Expire_Date_Less_Than_Today}");
             var titl  = $A.get("{!$Label.c.Error}");
             toastEvent.setParams({
                 "title": titl,
                 "type": "error",
                 "message": msg
             });
             toastEvent.fire();
         }      
         else{
             helper.sentForApproval(component, recordId);
         }
         component.set("v.showSpinner",false);
     },
    
    toggleCheck2: function(component, event, helper){
        component.set("v.showSpinner",true);
        //var currecny = component.find("checkbox-id-01").get("v.value"); 
        var pb = component.get("v.priceBookDetails");
        // var isChecked = component.find("checkbox-id-02").get("v.checked");
        var isChecked = pb.isActive;
        var recordId = component.get("v.recordId");
        var strVal = '';
        // alert(isChecked);
        
        var Today = new Date();
        var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();
        var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
        var yyyy = Today.getFullYear();
        var currentDt = (yyyy + "-" + MM + "-" + dd);
        var frmDt = $A.localizationService.formatDate(component.get("v.frmDate"), "yyyy-MM-dd"); //component.find("validfrmId").get("v.value");
        var toDt = $A.localizationService.formatDate(component.get("v.toDate"), "yyyy-MM-dd");//component.find("expiryId").get("v.value");
        // var checkbox = document.getElementById('checkbox-id-01');
       /* if(pb_cmpgn || pb_avec ){
            blk_dt= $A.localizationService.formatDate(component.get("v.bltDate"), "yyyy-MM-dd");//component.find("blck_dt").get("v.value");
            intr_dt = $A.localizationService.formatDate(component.get("v.intrDate"), "yyyy-MM-dd"); //component.find("intr_dt").get("v.value");
        }*/
        if(isChecked){
            strVal ='false';
            
        }
        else{
            strVal ='true';
        }
        
        /* if(frmDt > currentDt){
            var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.Valid_From_Date_Greater_Than_Today}");
                        var titl  = $A.get("{!$Label.c.Error}");
                        toastEvent.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg
                        });
                        toastEvent.fire();
        }
        else if(toDt < currentDt){
            var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.Expire_Date_Less_Than_Today}");
                        var titl  = $A.get("{!$Label.c.Error}");
                        toastEvent.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg
                        });
                        toastEvent.fire();
        }      
        else{
           helper.activeDeactive(component, event,recordId, strVal);
        }*/
        
       helper.activeDeactive(component, event,recordId, strVal);
        component.set("v.showSpinner",false);
    },
    
    validateInterestRate:function(component, event, helper){
        var target = event.getSource();  
        var val = target.get("v.value");
        var nm = target.get("v.name");
        // val = val.replace('-','').trim();
        val=val.replace(/[^a-zA-Z0-9, ]/,'').replace(/([a-zA-Z ])/g,'').trim();
        
        component.find(nm).set("v.value",val);
    },
    validateUSDRate:function(component, event, helper){
        var target = event.getSource();  
        var val = target.get("v.value");
        var nm = target.get("v.name");
        // val = val.replace('-','').trim();
        val=val.replace(/[^a-zA-Z0-9, ]/,'').replace(/([a-zA-Z ])/g,'').trim();
        
        component.find(nm).set("v.value",val);
    },
    validateDecimalCommaVal:function(component, event, helper){
        var target = event.getSource();  
        var val = target.get("v.value");
        console.log('val1',val);
        var nm = target.get("v.name");
        // val = val.replace('-','').trim();  .replace(/([a-zA-Z ])/g,'')  replace(/[^a-zA-Z0-9, ]/,'')
        val=val.replace(/[^a-zA-Z0-9,. ]/,'').replace(/([a-zA-Z ])/g,'').trim();
        val = val.replace('.','').trim(); //added by Sagar to not allow users to insert dot(.) in Unit Price
        component.find(nm).set("v.value",val);
    },
    
    validateDecimalCommaValConvert:function(component, event, helper){
        var target = event.getSource();  
        var val = target.get("v.value");
        var nm = target.get("v.name");
        
        val=val.replace('.','').trim();
        val=val.replace(',','.').trim();
        // val=val.replace('-','.').trim();
        //alert(parseFloat(val).toFixed(2));
        
        // component.find(nm).set("v.value",val);
    },
    
    
    
    hideAndClonePriceBookJs: function(component, event, helper){
        //  console.log('hideAndClonePriceBookJs--');
        component.set("v.showSpinner", true);  
        var pBook = component.get("v.priceBookDetails");
        component.set("v.isClone", true);
        component.set("v.isEdit", false);
        component.set("v.isbtndisable", false);
        component.set("v.hide10",false);
        $('.btn-to-hide').show();
        
        // code added by Sagar@Wipro start--
        component.find("apply_percentage").set("v.disabled",false);
        component.find("apply_simulation").set("v.disabled",false);
        component.find("apply_disc").set("v.disabled",false);
        component.find("apply_MinPrice").set("v.disabled",false);
        component.find("lastMonth").set("v.disabled",false);
        // end--
        if(pBook.pb_for_cmpgn == true){
            component.set("v.hide1",true);
            component.set("v.hide4",true);
            component.find("radio1").set("v.disabled",false);
            component.find("radio2").set("v.disabled",false);
            component.find("blck_dt").set("v.disabled",false);
            component.find("intr_dt").set("v.disabled",false);
            component.set("v.hideDeleteBtn",true);
        }
        if(pBook.pb_for_avec == true){
            component.set("v.hide1",false);
            component.set("v.hide4",true);
            //component.find("radio1").set("v.disabled",false);commented by Jessy Ticket NO.INCTASK0895081
            //component.find("radio2").set("v.disabled",false);commented by Jessy Ticket NO.INCTASK0895081
            component.find("blck_dt").set("v.disabled",false);
            component.find("intr_dt").set("v.disabled",false);
            component.set("v.hideDeleteBtn",true);
        }								  
		 
        
        component.find("checkbox-id-01").set("v.disabled",false);
        component.find("priceBookName").set("v.disabled",false);
        component.find("currencyID").set("v.disabled",false);
        component.find("validfrmId").set("v.disabled",false);
        component.find("expiryId").set("v.disabled",false);
        component.find("int_rate_R").set("v.disabled",false);
        component.find("int_rate_U").set("v.disabled",false);
        component.find("DivisionName").set("v.disabled",true);
        component.find("searchUtil").set("v.disabled",true);
        component.find("imprtbtn").set("v.disabled",false);
        component.set("v.hide11",true); // hide choose file button....
        //component.find("addDistbtn").set("v.disabled",false);
        
        // component.find("skuName").set("v.disabled",false);
        component.find("skulkp").set("v.disabled",false);
        //  component.find("SkuCode1").set("v.disabled",false);
        //component.find("minPriceR").set("v.disabled",false);
        //component.find("minPriceU").set("v.disabled",false);
        component.find("unitPriceR").set("v.disabled",false);
        component.find("unitPriceU").set("v.disabled",false);
        component.find("fspR").set("v.disabled",false);
        component.find("fspU").set("v.disabled",false);
        component.find("addbtn").set("v.disabled",false);
        //component.find("sldtUtil1").set("v.disabled",false);
        
        if(pBook.curncy == 'Only BRL'){
            component.find("int_rate_U").set("v.disabled",true);
        }
        else if(pBook.curncy == 'Only USD'){
            component.find("int_rate_R").set("v.disabled",true);
        }
            else{
                component.find("int_rate_R").set("v.disabled",false);
                component.find("int_rate_U").set("v.disabled",false);
            }
        
        var salesdt = component.get('v.salesdtarr');
        var salesdt1 = component.get('v.cropcularr');
        var salesdt2 = component.get('v.cropgrparr');
        var salesdt3 = component.get('v.cropnamearr');

        
        var getSkuAllId = component.find("sdtNameforSales"); 
        
        var isArray = Array.isArray(getSkuAllId);
        if(isArray){
            for(var j = 0 ;j < salesdt.length;j++){
                component.find("sldtUtil")[j].set("v.disabled",false);
                component.find("lkpdisable")[j].set("v.disabled",false);
            }
        }else{
            //component.find("sldtUtil").set("v.disabled",false);
            //component.find("lkpdisable").set("v.disabled",false);
        }
        
        var getSkuAllId1 = component.find("sdtNameforSales1"); 
        var isArray1 = Array.isArray(getSkuAllId1);
        if(isArray1){
            for(var j = 0 ;j < salesdt1.length;j++){
                component.find("sldtUtil1")[j].set("v.disabled",false);
                component.find("lkpdisable1")[j].set("v.disabled",false);
            }
        }else{
            //component.find("sldtUtil1").set("v.disabled",false);
            //component.find("lkpdisable1").set("v.disabled",false);
        }
        
        
        var getSkuAllId2 = component.find("sdtNameforSales2"); 
        var isArray2 = Array.isArray(getSkuAllId2);
        if(isArray2){
            for(var j = 0 ;j < salesdt2.length;j++){
                component.find("sldtUtil2")[j].set("v.disabled",false);
                component.find("lkpdisable2")[j].set("v.disabled",false);
            }
        }else{
            //component.find("sldtUtil2").set("v.disabled",false);
           // component.find("lkpdisable2").set("v.disabled",false);
        }
        if(salesdt2 != null){
        var getSkuAllId3 = component.find("sdtNameforSales3"); 
        var isArray3 = Array.isArray(getSkuAllId3);
        if(isArray1){
            for(var j = 0 ;j < salesdt3.length;j++){
                component.find("sldtUtil3")[j].set("v.disabled",false);
                component.find("lkpdisable3")[j].set("v.disabled",false);
            }
        }else{
            //component.find("sldtUtil3").set("v.disabled",false);
            //component.find("lkpdisable3").set("v.disabled",false);
        }
        
        }        
        
        setTimeout(function(){ component.set("v.showSpinner", false); },5000);
        
        
    },
    //added kit related attributes on pricebook
    priceBookClone: function(component, event, helper){
        //  console.log('priceBookClone called..');
        component.set("v.showSpinner",true);
        var priceBook = component.get("v.priceBookDetails"); //{};
        //  console.log(priceBook);
        var pb_cmpgn=component.get("v.pb_for_campaign");
        var pb_avec=component.get("v.pb_for_avec");

        var apply_discount=component.get("v.apply_discount"); //Divya
        var applyMinPrice=component.get("v.applyMinPrice"); // Priya RITM0237685
        var applySimulation=component.get("v.applySimulation"); //Simulation
        var applyPercentage=component.get("v.applyPercentage"); //Sagar
        
        var usdRate = component.find("crUsdRate").get("v.value"); //Divya
        
        var pb_for_kit=component.get("v.Price_Book_For_Kit");
        //alert(pb_cmpgn);
        var cmpgn_tp='';
        var divsn = component.find("HiddenDivisionName").get("v.value");
        var blk_dt='';
        var intr_dt='';
        var obj = new Object();
        var isValid=true;
        var isPriceBookvalid=true;
        if(pb_cmpgn || pb_avec){
            cmpgn_tp=component.get("v.campaignType");
        }
        var pb_nm = component.find("priceBookName").get("v.value");
        var currency = component.find("currencyID").get("v.value");
        //var validfrmDt = component.get("v.myDate");
        // var expiryDt = component.get("v.myDate1");
        var frmDt = $A.localizationService.formatDate(component.get("v.frmDate"), "yyyy-MM-dd"); //component.find("validfrmId").get("v.value");
        
        var toDt = $A.localizationService.formatDate(component.get("v.toDate"), "yyyy-MM-dd");//component.find("expiryId").get("v.value");
        if(pb_cmpgn || pb_avec){
            blk_dt= $A.localizationService.formatDate(component.get("v.bltDate"), "yyyy-MM-dd");//component.find("blck_dt").get("v.value");
            intr_dt = $A.localizationService.formatDate(component.get("v.intrDate"), "yyyy-MM-dd"); //component.find("intr_dt").get("v.value");
        }
        var lasMon = $A.localizationService.formatDate(component.get("v.lasMon"), "yyyy-MM-dd");
        var intr_R = component.find("int_rate_R").get("v.value");
        var intr_U = component.find("int_rate_U").get("v.value");
        // sales District     
        var arrOfSalesdist = component.get("v.salesdtarr"); 
        var arrOfSalesdist1 = component.get("v.cropcularr");//added by Sagar@Wipro for PB-003
        console.log('arrOfSalesdist1'+arrOfSalesdist1);
        var arrOfcustgrps = component.get("v.custgrparr");//added by Sagar@Wipro for PB-004
        var arrOfcustnames = component.get("v.custnamearr");//added by Sagar@Wipro for PB-004

        var mtFile= component.get("v.materialDetails");
        var payObjs = component.get('v.paymentTermsWrapper');
        //  console.log('mt file  '+mtFile.length);
        
        var Today = new Date();
        var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();
        var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
        var yyyy = Today.getFullYear();
        var currentDt = (yyyy + "-" + MM + "-" + dd);
        
        
        if(!pb_nm){
            //  console.log('pb_nm isValid '+isValid);
            component.find("priceBookName").set('v.validity', {valid:false, badInput :true});
            component.find("priceBookName").showHelpMessageIfInvalid();
            
            var toastEvent2 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding}");
            var titl  = $A.get("{!$Label.c.Warning}");
            toastEvent2.setParams({
                "title": titl,
                "type": "warning",
                "message": msg,
                "duration":'3000'
            });
            toastEvent2.fire();
            
            isValid=false;
            isPriceBookvalid=false;
        }
        if(pb_nm=='undefined'){
            //  console.log('pb_nm isValid '+isValid);
            component.find("priceBookName").set('v.validity', {valid:false, badInput :true});
            component.find("priceBookName").showHelpMessageIfInvalid();
            
            var toastEvent2 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding}");
            var titl  = $A.get("{!$Label.c.Warning}");
            toastEvent2.setParams({
                "title": titl,
                "type": "warning",
                "message": msg,
                "duration":'3000'
            });
            toastEvent2.fire();
            
            isValid=false;
            isPriceBookvalid=false;
        }
        //Start of change for RITM0339238 (4/4)
        if(!usdRate){
            component.find("crUsdRate").set('v.validity', {valid:false, badInput :true});
            component.find("crUsdRate").showHelpMessageIfInvalid();
            
            var toastEvent2 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding}");
            var titl  = $A.get("{!$Label.c.Warning}");
            toastEvent2.setParams({
                "title": titl,
                "type": "warning",
                "message": msg,
                "duration":'3000'
            });
            toastEvent2.fire();
            
            isValid=false;
            isPriceBookvalid=false;
        }
        if(usdRate=='undefined'){
            component.find("crUsdRate").set('v.validity', {valid:false, badInput :true});
            component.find("crUsdRate").showHelpMessageIfInvalid();
            
            var toastEvent2 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding}");
            var titl  = $A.get("{!$Label.c.Warning}");
            toastEvent2.setParams({
                "title": titl,
                "type": "warning",
                "message": msg,
                "duration":'3000'
            });
            toastEvent2.fire();
            
            isValid=false;
            isPriceBookvalid=false;
        }
        //End of change for RITM0339238 (4/4)
        //  console.log('currency '+currency);
        if(!currency){
            //  console.log('currency isValid '+isValid);
            //  console.log('currency inside if '+currency);
            component.find("currencyID").set('v.validity', {valid:false, badInput :true});
            component.find("currencyID").showHelpMessageIfInvalid();
            isValid=false;
            isPriceBookvalid=false;
        }
        if(frmDt == 'Invalid Date' || !frmDt){
            //  console.log('frmDt isValid '+isValid);
            // component.find("validfrmId").set("v.errors", [{message: "Select Date."}]);
            // $A.util.addClass(component.find("validfrmId"), 'slds-has-error');
            isValid=false;
            isPriceBookvalid=false;
            component.find("validfrmId").set('v.validity', {valid:false, badInput :true});
            component.find("validfrmId").showHelpMessageIfInvalid();
        }
        else if(frmDt < currentDt){
            component.set("v.hide3",true);
            isValid=false;
            isPriceBookvalid=false;
            component.find("validfrmId").set('v.validity', {valid:false, badInput :true});
            component.find("validfrmId").showHelpMessageIfInvalid();
        }
            else{
                component.set("v.hide3",false);   
            }
        
        if(toDt == 'Invalid Date' || !toDt){
            //  console.log('toDt isValid '+isValid);
            // component.find("expiryId").set("v.errors", [{message: "Select Date."}]);
            // $A.util.addClass(component.find("expiryId"), 'slds-has-error');
            isValid=false;
            isPriceBookvalid=false;
            component.find("expiryId").set('v.validity', {valid:false, badInput :true});
            component.find("expiryId").showHelpMessageIfInvalid();
        }
        else if(toDt < frmDt || toDt < currentDt){
            component.set("v.hide5",true);
            isValid=false;
            isPriceBookvalid=false;
            component.find("expiryId").set('v.validity', {valid:false, badInput :true});
            component.find("expiryId").showHelpMessageIfInvalid();
        }
            else{
                component.set("v.hide5",false);
            }
        
        if(currency == "Only BRL"){
            intr_U='0';
            if(!intr_R){
                //  console.log('intr_R isValid '+isValid);
                component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_R").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
            else if(isNaN(intr_R.replace(',','.'))){
                //  console.log('intr_R isValid '+isValid);
                component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_R").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
                else if(intr_R.replace(',','.') < 0){
                    //  console.log('intr_R isValid '+isValid);
                    component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
                    component.find("int_rate_R").showHelpMessageIfInvalid();
                    isValid=false;
                    isPriceBookvalid=false;
                }
            
        }
        
        if(currency == "Only USD"){
            intr_R='0';
            if(!intr_U){
                //  console.log('intr_U isValid '+isValid);
                component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_U").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
            else if(isNaN(intr_U.replace(',','.'))){
                //  console.log('intr_U isValid '+isValid);
                component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_U").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
                else if(intr_U.replace(',','.') < 0){
                    //  console.log('intr_U isValid '+isValid);
                    component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
                    component.find("int_rate_U").showHelpMessageIfInvalid();
                    isValid=false;
                    isPriceBookvalid=false;
                }
        }
        
        if(currency == "BRL and USD"){
            
            if(!intr_R){
                //  console.log('intr_R isValid '+isValid);
                component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_R").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
            else if(isNaN(intr_R.replace(',','.'))){
                //  console.log('intr_R isValid '+isValid);
                component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_R").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
                else if(intr_R.replace(',','.') < 0){
                    //  console.log('intr_R isValid '+isValid);
                    component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
                    component.find("int_rate_R").showHelpMessageIfInvalid();
                    isValid=false;
                    isPriceBookvalid=false;
                }
            
            if(!intr_U){
                //  console.log('intr_U isValid '+isValid);
                component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_U").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
            else if(isNaN(intr_U.replace(',','.'))){
                //  console.log('intr_U isValid '+isValid);
                component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
                component.find("int_rate_U").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
                else if(intr_U.replace(',','.') < 0){
                    //  console.log('intr_U isValid '+isValid);
                    component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
                    component.find("int_rate_U").showHelpMessageIfInvalid();
                    isValid=false;
                    isPriceBookvalid=false;
                }
        }
        if(!divsn){
            component.find("DivisionName").set('v.validity', {valid:false, badInput :true});
            component.find("DivisionName").showHelpMessageIfInvalid();
            isValid=false;
            isPriceBookvalid=false;
            //  console.log('Division' +divsn);
        }         
        if(mtFile.length==0){
            
            var toastEvent2 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.File_not_Imported}");
            var titl  = $A.get("{!$Label.c.Error}");
            toastEvent2.setParams({
                "title": titl,
                "type": "error",
                "message": msg,
                "duration":'3000'
            });
            toastEvent2.fire();
            
            // alert('File not Imported.');
            isValid=false;
            isPriceBookvalid=false;
        }
        
        if(pb_cmpgn){
            
            //  console.log('cmpgn_tp '+cmpgn_tp);
            //  console.log('blk_dt '+blk_dt);
            if(!cmpgn_tp){
                
                var toastEvent3 = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Please_select_Campaign_Type}");
                var titl  = $A.get("{!$Label.c.Warning}");
                toastEvent3.setParams({
                    "title": titl,
                    "type": "warning",
                    "message": msg,
                    "duration":'3000'
                });
                toastEvent3.fire();
                
                //alert('Please select Campaign Type.');
                isValid=false;
                isPriceBookvalid=false;
            }
            else if(intr_dt == 'Invalid Date' || !intr_dt){
                //  console.log('intr_dt isValid '+isValid);
                component.find("intr_dt").set('v.validity', {valid:false, badInput :true});
                component.find("intr_dt").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
                else if(intr_dt < currentDt){
                    //  console.log('intr_dt isValid '+isValid);
                    component.set("v.hide6",true);
                    component.find("intr_dt").set('v.validity', {valid:false, badInput :true});
                    component.find("intr_dt").showHelpMessageIfInvalid();
                    isValid=false;
                    isPriceBookvalid=false;
                }
                    else if(blk_dt == 'Invalid Date' || !blk_dt){
                        
                        component.find("blck_dt").set('v.validity', {valid:false, badInput :true});
                        component.find("blck_dt").showHelpMessageIfInvalid();
                        isValid=false;
                        isPriceBookvalid=false;
                    }
                        else if(blk_dt < currentDt){
                            component.set("v.hide7",true);
                            component.find("blck_dt").set('v.validity', {valid:false, badInput :true});
                            component.find("blck_dt").showHelpMessageIfInvalid();
                            isValid=false;
                            isPriceBookvalid=false;
                        }
                            else if(payObjs.length == 0){
                                var toastEvent4 = $A.get("e.force:showToast");
                                var msg  = $A.get("{!$Label.c.Payment_Terms_is_required}");
                                var titl  = $A.get("{!$Label.c.Warning}");
                                toastEvent4.setParams({
                                    "title": titl,
                                    "type": "warning",
                                    "message": msg,
                                    "duration":'3000'
                                });
                                toastEvent4.fire();
                                component.find("tabs").set("v.selectedTabId","tbTwo");
                                isValid=false;
                                isPriceBookvalid=false;
                            }
                                else{
                                    component.set("v.hide6",false);
                                    component.set("v.hide7",false);
                                }
        }
        else{
            //Commented by Jessy Ticket NO.INCTASK0895081
            //cmpgn_tp='';
            //blk_dt='';
            //intr_dt='';
            
        }
        //  console.log('isPriceBookvalid '+ isPriceBookvalid); 
        //  console.log('isvalid '+ isValid);

        // Divya
          if(usdRate != undefined && usdRate != '')	
		{
			if(isNaN(usdRate.replace(',','.'))){
                //  console.log('intr_U isValid '+isValid);
               component.find("crUsdRate").set('v.validity', {valid:false, badInput :true});
               component.find("crUsdRate").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
           }
            else if(usdRate.replace(',','.') < 0){
                 //  console.log('intr_U isValid '+isValid);
                component.find("crUsdRate").set('v.validity', {valid:false, badInput :true});
                component.find("crUsdRate").showHelpMessageIfInvalid();
                 isValid=false;
                 isPriceBookvalid=false;
            }
		}
        if(isPriceBookvalid){
            
            // validating sales district  
            if(arrOfSalesdist.length == 0){
                // component.set("v.isErrors", true);
                var toastEvent4 = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Sales_District_Entries_Required}");
                var titl  = $A.get("{!$Label.c.Warning}");
                toastEvent4.setParams({
                    "title": titl,
                    "type": "warning",
                    "message": msg,
                    "duration":'3000'
                });
                toastEvent4.fire();
                
                helper.applyCSS(component);
                isValid = false;
                
            }else if(arrOfSalesdist.length > 0){
                
                var duplicateval = component.get("v.showduplicateErr");
                
                for(var i = 0 ;i<arrOfSalesdist.length;i++){
                    for(var j = i+1 ;j<arrOfSalesdist.length;j++){
                        
                        var nameOfSD = arrOfSalesdist[i].Name;
                        if(typeof nameOfSD == "undefined"){
                            component.set("v.showErrOnDiv", true);
                            isValid = false;
                        }else{
                            //  console.log('arrOfSalesdist[i].Name'+arrOfSalesdist[i].Name);
                            if(arrOfSalesdist[i].Name != null || arrOfSalesdist[i].Name != ''){
                                if(arrOfSalesdist[i].Name == arrOfSalesdist[j].Name){
                                    component.set("v.showduplicateErr", true);
                                    isValid = false;
                                }     
                            }
                        }
                    }
                }
                
                if(!duplicateval){
                    for(var i = 0 ;i<arrOfSalesdist.length;i++){
                        if(arrOfSalesdist[i].Name == null){
                            component.set("v.showErrOnDiv", true);
                            isValid = false;
                        }else{
                            component.set("v.showErrOnDiv", false);
                        }
                    }
                }
            }
            
            if(isValid){
                
                obj.pb_for_cmpgn=pb_cmpgn;
                obj.pb_for_avec=pb_avec;

                obj.cmpgn_tp=cmpgn_tp;
                obj.pb_name=pb_nm;
                obj.curncy=currency;
                obj.frm_dt=frmDt;
                obj.exp_dt=toDt;
                obj.intr_rt_R=intr_R.replace(',','.');
                obj.intr_rt_U=intr_U.replace(',','.');
                obj.intr_dt=intr_dt;
                obj.division=divsn;
                obj.blk_dt=blk_dt;
                obj.pb_for_kit=pb_for_kit;
                obj.apply_discount=apply_discount; //Divya
                obj.applyMinPrice=applyMinPrice; // Priya RITM0237685
                obj.applySimulation=applySimulation; //Simulation
                obj.applyPercentage= applyPercentage;
                obj.las_mon=lasMon;
                if(usdRate != undefined && usdRate != '')
                {obj.usdRate=usdRate.replace(',','.');} //Divya
                
                priceBook=obj;
                
                helper.clonePriceBook(component, event, helper, priceBook, mtFile, arrOfSalesdist,arrOfSalesdist1,arrOfcustgrps,arrOfcustnames, payObjs);
                
                //  console.log('Price book if campaign not checked'+priceBook);
                //alert(priceBook);
            }
            else{
                component.set("v.showSpinner",false);
                var toastEvent3 = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding}");
                var titl  = $A.get("{!$Label.c.Warning}");
                toastEvent3.setParams({
                    "title": titl,
                    "type": "warning",
                    "message": msg,
                    "duration":'3000'
                });
                toastEvent3.fire();
            }
        }
        else{
            component.set("v.showSpinner",false);
            var toastEvent3 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.Please_fill_all_the_mandatory_fields_before_proceeding}");
            var titl  = $A.get("{!$Label.c.Warning}");
            toastEvent3.setParams({
                "title": titl,
                "type": "warning",
                "message": msg,
                "duration":'3000'
            });
            toastEvent3.fire();
        }
    },
    
    openSkuModal: function(component, event, helper){
        
        //  var target = event.getSource();  
        //   var rowIndexValue = target.get("v.value");
        //   component.set("v.rowIndex",rowIndexValue);
        helper.fetchSku(component);
        component.set("v.isOpen3", true);
        helper.applyCSS(component);
    },
    
    closeSkuModel: function(component, event, helper){        
        component.set("v.isOpen3", false);
        helper.revertCssChange(component);
    },
    //Divya
    clickApplyDiscount: function(component, event, helper){       
        console.log('apply_disc is '+component.find("apply_disc"));
        var getCheckVal = component.find("apply_disc").get("v.checked");
        console.log('On change value is'+getCheckVal);
        if(getCheckVal){
            component.set("v.apply_discount", true);
        }
        else
            component.set("v.apply_discount", false); 
    },
    
    //Priya RITM0237685
    clickApplyMinPrice: function(component, event, helper){    
        var getCheckValue = component.find("apply_MinPrice").get("v.checked");
        console.log('**On change apply_MinPrice -> '+getCheckValue);
        if(getCheckValue){
            component.set("v.applyMinPrice", true);
        }
        else
            component.set("v.applyMinPrice", false); 
    },
      //Simulation
      clickSimulationPriceBook: function(component, event, helper){    
        var getCheckValue1 = component.find("apply_simulation").get("v.checked");
        console.log('**On change apply_simulation -> '+getCheckValue1);
        if(getCheckValue1){
            component.set("v.applySimulation", true);
        }
        else
            component.set("v.applySimulation", false); 
    },
    // function added by Sagar@Wipro SOS-007 for Increase Decrease Percentage
    clickApplyIncreaseDecreasePercentage: function(component, event, helper){    
        var getCheckValue2 = component.find("apply_percentage").get("v.checked");
        console.log('**On change apply_percentage -> '+getCheckValue2);
        if(getCheckValue2){
            component.set("v.applyPercentage", true);
        }
        else
            component.set("v.applyPercentage", false); 
    },
    
    //modified for kit , if kit different validation based on sku+kit code and setting err msg and form material table based on added sku
    addSKURow: function(component, event, helper){
        component.set("v.reload",false);
        var skDet = component.get('v.materialDetails');
        var skuDesc = component.get("v.skuDescription");
        var skuSet= component.get("v.uniqueSKU"); 
        var count= component.get("v.count"); 
        var flag=false;
        var mainFlag=true;
        var invalidFlag=false;
        var codeDsc='';
        var currency = component.find("currencyID").get("v.value");
        //added if for kit prod
        var cmpList=component.get('v.compList');
        if(component.get("v.Price_Book_For_Kit")==true){
            //alert('true kit');
            if(!currency){
                var toastEvent1 = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Please_Select_Currency}");
                var titl  = $A.get("{!$Label.c.Warning}");
                toastEvent1.setParams({
                    "title": titl,
                    "type": "warning",
                    "message": msg,
                    "duration":'3000'
                });
                toastEvent1.fire();
                
                // alert("Please select File to Import.");
                mainFlag=false;
                component.find("currencyID").focus();
                
            }
            else {
                var ErrMsg='';
                for(var i = 0; i < cmpList.length; i++) {
                    var code=cmpList[i].kit_prod+'#'+cmpList[i].sku_code;
                    var minR=cmpList[i].min_prc;
                    var minU=cmpList[i].min_prc_u;
                    var unitR=cmpList[i].unt_prc;
                    var unitU=cmpList[i].unt_prc_u;
                      //Added by Krishanu & Ankita @WIPRO - Start
                      var gm=cmpList[i].GM;
                      var selloutPrice = cmpList[i].sellOutPrice;
                      var selloutType = cmpList[i].selloutType;
                      var SOFactor = cmpList[i].SelloutFactor;
                      var MinFactor = cmpList[i].MinPriceFactor;
                      var sellOutPriceU = cmpList[i].sellOutPriceU;
                      var GMU = cmpList[i].GMU;
                      var selloutTypeU = cmpList[i].selloutTypeU;
                      var SelloutFactorU = cmpList[i].SelloutFactorU;
                      var MinPriceFactorU = cmpList[i].MinPriceFactorU;
                    var fspR=cmpList[i].fsp;
                    var fspU=cmpList[i].fsp_u;
                    //Added by Krishanu & Ankita @WIPRO -End
                    //alert(unitR);
                    if(!code){
                        mainFlag=false;
                        ErrMsg+='Invalid Sku Code :'+code
                        //component.find("SkuCode1").set('v.validity', {valid:false, badInput :true});
                        //component.find("SkuCode1").showHelpMessageIfInvalid();
                    }
                    else if(currency == 'Only BRL'){
                        
                        if(!minR){
                            mainFlag=false;
                            flag=true;
                            ErrMsg+=$A.get("{!$Label.c.Found_Null_Column_values_for_BRL}")+code;
                            //component.find("minPriceR").set('v.validity', {valid:false, badInput :true});
                            //component.find("minPriceR").showHelpMessageIfInvalid();
                        }
                        else if(isNaN(minR.replace('.','').replace(',','.').trim())){
                            mainFlag=false;
                            flag=false;
                            invalidFlag=true;
                            ErrMsg+=$A.get("{!$Label.c.Please_Enter_Valid_Value}")+' For Min Price BRL:'+code;
                            //component.find("minPriceR").set('v.validity', {valid:false, badInput :true});
                            //component.find("minPriceR").showHelpMessageIfInvalid();
                            
                            
                        }
                        
                            else if(!unitR){
                                mainFlag=false;
                                flag=true;
                                ErrMsg+=$A.get("{!$Label.c.Found_Null_Column_values_for_BRL}")+code;
                                
                                //component.find("unitPriceR").set('v.validity', {valid:false, badInput :true});
                                //component.find("unitPriceR").showHelpMessageIfInvalid();
                            }
                                else if(isNaN(unitR.replace('.','').replace(',','.').trim())){
                                    mainFlag=false;
                                    flag=false;
                                    invalidFlag=true;
                                    ErrMsg+=$A.get("{!$Label.c.Please_Enter_Valid_Value}")+' For Unit Price BRL:'+code;
                                    
                                    //component.find("unitPriceR").set('v.validity', {valid:false, badInput :true});
                                    //component.find("unitPriceR").showHelpMessageIfInvalid();
                                    
                                    
                                }
                                    else if(parseFloat(unitR.replace('.','').replace(',','.').trim()) < parseFloat(minR.replace('.','').replace(',','.').trim())){
                                        mainFlag=false;
                                        flag=false;
                                        //component.find("unitPriceR").focus();
                                        //component.find("unitPriceR").set('v.validity', {valid:false, badInput :true});
                                        //component.find("unitPriceR").showHelpMessageIfInvalid();
                                        ErrMsg+=$A.get("{!$Label.c.Unit_Should_be_Greater_than_Minimum}")+code;
                                        /*  var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.Unit_Should_be_Greater_than_Minimum}");
                        var titl  = $A.get("{!$Label.c.Error}");
                        toastEvent.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg
                        });
                        toastEvent.fire();*/
            }
                else if(!fspR){
                    mainFlag=false;
                    flag=true;
                    ErrMsg+=$A.get("{!$Label.c.Found_Null_Column_values_for_BRL}")+code;
                    
                    // component.find("fspR").set('v.validity', {valid:false, badInput :true});
                    //component.find("fspR").showHelpMessageIfInvalid();
                }
                    else if(isNaN(fspR.replace('.','').replace(',','.').trim())){
                        mainFlag=false;
                        flag=false;
                        invalidFlag=true;
                        ErrMsg+=$A.get("{!$Label.c.Please_Enter_Valid_Value}")+' For Future Price BRL'+code;
                        
                        //component.find("fspR").set('v.validity', {valid:false, badInput :true});
                        //component.find("fspR").showHelpMessageIfInvalid();
                        
                        
                    }
                        else if(parseFloat(fspR.replace('.','').replace(',','.').trim()).toFixed(2) < 0){
                            mainFlag=false;
                            flag=false;
                            //component.find("fspR").focus();
                            //component.find("fspR").set('v.validity', {valid:false, badInput :true});
                            //component.find("fspR").showHelpMessageIfInvalid();
                            ErrMsg+=$A.get("{!$Label.c.FSP_should_be_Greater_Than_Zero}")+code;
                            
                            /* var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.FSP_should_be_Greater_Than_Zero}");
                        var titl  = $A.get("{!$Label.c.Error}");
                        toastEvent.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg
                        });
                        toastEvent.fire();*/
            }
                else{
                    mainFlag=true;
                    flag=false;
                    invalidFlag=false;
                    minU='0'; 
                    unitU='0';
                    fspU='0';
                    sellOutPriceU=0;//Added by Krishanu & Ankita @WIPRO
                    GMU=0;//Added by Krishanu & Ankita @WIPRO
                    selloutTypeU='';//Added by Krishanu & Ankita @WIPRO
                    SelloutFactorU=0;//Added by Krishanu & Ankita @WIPRO
                    MinPriceFactorU=0;//Added by Krishanu & Ankita @WIPRO
                }
                        
                    }
                        else if(currency =='Only USD'){
                            if(!minU){
                                mainFlag=false;
                                flag=true;
                                ErrMsg+=$A.get("{!$Label.c.Found_Null_Column_values_for_USD}")+code;
                                //component.find("minPriceU").set('v.validity', {valid:false, badInput :true});
                                //component.find("minPriceU").showHelpMessageIfInvalid();
                            }
                            else if(isNaN(minU.replace('.','').replace(',','.').trim())){
                                mainFlag=false;
                                flag=false;
                                invalidFlag=true;
                                ErrMsg+=$A.get("{!$Label.c.Please_Enter_Valid_Value}")+' For Min Price USD:'+code;
                                
                                //component.find("minPriceU").set('v.validity', {valid:false, badInput :true});
                                //component.find("minPriceU").showHelpMessageIfInvalid();
                            }
                                else if(!unitU){
                                    mainFlag=false;
                                    flag=true;
                                    ErrMsg+=$A.get("{!$Label.c.Found_Null_Column_values_for_USD}")+code;
                                    
                                    //component.find("unitPriceU").set('v.validity', {valid:false, badInput :true});
                                    //component.find("unitPriceU").showHelpMessageIfInvalid();
                                }
                                    else if(isNaN(unitU.replace('.','').replace(',','.').trim())){
                                        mainFlag=false;
                                        flag=false;
                                        invalidFlag=true;
                                        ErrMsg+=$A.get("{!$Label.c.Please_Enter_Valid_Value}")+' For Unit Price USD:'+code;
                                        
                                        //component.find("unitPriceU").set('v.validity', {valid:false, badInput :true});
                                        //component.find("unitPriceU").showHelpMessageIfInvalid();
                                    }
                                        else if(parseFloat(unitU.replace('.','').replace(',','.').trim()) < parseFloat(minU.replace('.','').replace(',','.').trim())){
                                            mainFlag=false;
                                            flag=false;
                                            ErrMsg+=$A.get("{!$Label.c.Unit_Should_be_Greater_than_Minimum}")+code;
                                            
                                            //component.find("unitPriceU").focus();
                                            //component.find("unitPriceU").set('v.validity', {valid:false, badInput :true});
                                            //component.find("unitPriceU").showHelpMessageIfInvalid();
                                            
                                            
                                        }
                                            else if(!fspU){
                                                mainFlag=false;
                                                flag=true;
                                                ErrMsg+=$A.get("{!$Label.c.Found_Null_Column_values_for_USD}")+code;
                                                
                                                // component.find("fspU").set('v.validity', {valid:false, badInput :true});
                                                // component.find("fspU").showHelpMessageIfInvalid();
                                            }
                                                else if(isNaN(fspU.replace('.','').replace(',','.').trim())){
                                                    mainFlag=false;
                                                    flag=false;
                                                    invalidFlag=true;
                                                    ErrMsg+=$A.get("{!$Label.c.Please_Enter_Valid_Value}")+' For Future Price USD'+code;
                                                    
                                                    // component.find("fspU").set('v.validity', {valid:false, badInput :true});
                                                    // component.find("fspU").showHelpMessageIfInvalid();
                                                }
                                                    else if(parseFloat(fspU.replace('.','').replace(',','.').trim()).toFixed(2) < 0){
                                                        mainFlag=false;
                                                        flag=false;
                                                        ErrMsg+=$A.get("{!$Label.c.FSP_should_be_Greater_Than_Zero}")+code;
                                                        
                                                        // component.find("fspU").focus();
                                                        //  component.find("fspU").set('v.validity', {valid:false, badInput :true});
                                                        //  component.find("fspU").showHelpMessageIfInvalid();
                                                        
                                                        
                                                    }
                                                        else{
                                                            //alert('main');
                                                            mainFlag=true;
                                                            flag=false;
                                                            invalidFlag=false;
                                                            minR='0'; 
                                                            unitR='0';
                                                            fspR='0';
                                                            gm=0;//Added by Krishanu & Ankita @WIPRO
                                                            selloutPrice=0;//Added by Krishanu & Ankita @WIPRO
                                                            selloutType='';//Added by Krishanu & Ankita @WIPRO
                                                            SOFactor=0;//Added by Krishanu & Ankita @WIPRO
                                                            MinFactor=0;//Added by Krishanu & Ankita @WIPRO
                                                        }
                            
                            
                            
                            
                            
                        }
                            else if(currency =='BRL and USD'){
                                
                                if(!minR){
                                    mainFlag=false;
                                    flag=true;
                                    ErrMsg+=$A.get("{!$Label.c.Found_Null_Column_values_for_Both_Currency}")+code;
                                    
                                    //component.find("minPriceR").set('v.validity', {valid:false, badInput :true});
                                    //component.find("minPriceR").showHelpMessageIfInvalid();
                                }
                                else if(isNaN(minR.replace('.','').replace(',','.').trim())){
                                    mainFlag=false;
                                    flag=false;
                                    invalidFlag=true;
                                    ErrMsg+=$A.get("{!$Label.c.Please_Enter_Valid_Value}")+' For Min Price BRL and USD:'+code;
                                    
                                    //component.find("minPriceR").set('v.validity', {valid:false, badInput :true});
                                    //component.find("minPriceR").showHelpMessageIfInvalid();
                                    
                                    
                                }
                                    else if(!unitR){
                                        mainFlag=false;
                                        flag=true;
                                        ErrMsg+=$A.get("{!$Label.c.Found_Null_Column_values_for_Both_Currency}")+code;
                                        
                                        //component.find("unitPriceR").set('v.validity', {valid:false, badInput :true});
                                        //component.find("unitPriceR").showHelpMessageIfInvalid();
                                    }
                                        else if(isNaN(unitR.replace('.','').replace(',','.').trim())){
                                            mainFlag=false;
                                            flag=false;
                                            invalidFlag=true;
                                            ErrMsg+=$A.get("{!$Label.c.Please_Enter_Valid_Value}")+' For Unit Price BRL and USD:'+code;
                                            
                                            //component.find("unitPriceR").set('v.validity', {valid:false, badInput :true});
                                            //component.find("unitPriceR").showHelpMessageIfInvalid();
                                        }
                                            else if(parseFloat(unitR.replace('.','').replace(',','.').trim()) < parseFloat(minR.replace('.','').replace(',','.').trim())){
                                                mainFlag=false;
                                                flag=false;
                                                ErrMsg+=$A.get("{!$Label.c.Unit_Should_be_Greater_than_Minimum}")+code;
                                                
                                                //component.find("unitPriceR").focus();
                                                //component.find("unitPriceR").set('v.validity', {valid:false, badInput :true});
                                                //component.find("unitPriceR").showHelpMessageIfInvalid();
                                                
                                                
                                            }
                                                else if(!fspR){
                                                    mainFlag=false;
                                                    flag=true;
                                                    ErrMsg+=$A.get("{!$Label.c.Found_Null_Column_values_for_Both_Currency}")+code;
                                                    
                                                    //component.find("fspR").set('v.validity', {valid:false, badInput :true});
                                                    //component.find("fspR").showHelpMessageIfInvalid();
                                                }
                                                    else if(isNaN(fspR.replace('.','').replace(',','.').trim())){
                                                        mainFlag=false;
                                                        flag=false;
                                                        invalidFlag=true;
                                                        ErrMsg+=$A.get("{!$Label.c.Please_Enter_Valid_Value}")+' For Future Price BRL and USD:'+code;
                                                        
                                                        //component.find("fspR").set('v.validity', {valid:false, badInput :true});
                                                        //component.find("fspR").showHelpMessageIfInvalid();
                                                        
                                                        
                                                    }
                                                        else if(parseFloat(fspR.replace('.','').replace(',','.').trim()).toFixed(2) < 0){
                                                            mainFlag=false;
                                                            flag=false;
                                                            ErrMsg+=$A.get("{!$Label.c.FSP_should_be_Greater_Than_Zero}")+code;
                                                            
                                                            //component.find("fspR").focus();
                                                            //component.find("fspR").set('v.validity', {valid:false, badInput :true});
                                                            //component.find("fspR").showHelpMessageIfInvalid();
                                                            
                                                        }
                                                            else if(!minU){
                                                                mainFlag=false;
                                                                flag=true;
                                                                ErrMsg+=$A.get("{!$Label.c.Found_Null_Column_values_for_Both_Currency}")+code;
                                                                
                                                                //component.find("minPriceU").set('v.validity', {valid:false, badInput :true});
                                                                //component.find("minPriceU").showHelpMessageIfInvalid();
                                                            }
                                                                else if(isNaN(minU.replace('.','').replace(',','.').trim())){
                                                                    mainFlag=false;
                                                                    flag=false;
                                                                    invalidFlag=true;
                                                                    ErrMsg+=$A.get("{!$Label.c.Please_Enter_Valid_Value}")+' For Min Price BRL and USD:'+code;
                                                                    
                                                                    //component.find("minPriceU").set('v.validity', {valid:false, badInput :true});
                                                                    //component.find("minPriceU").showHelpMessageIfInvalid();
                                                                }
                                                                    else if(!unitU){
                                                                        mainFlag=false;
                                                                        flag=true;
                                                                        ErrMsg+=$A.get("{!$Label.c.Found_Null_Column_values_for_Both_Currency}")+code;
                                                                        
                                                                        //component.find("unitPriceU").set('v.validity', {valid:false, badInput :true});
                                                                        //component.find("unitPriceU").showHelpMessageIfInvalid();
                                                                    }
                                                                        else if(isNaN(unitU.replace('.','').replace(',','.').trim())){
                                                                            mainFlag=false;
                                                                            flag=false;
                                                                            invalidFlag=true;
                                                                            ErrMsg+=$A.get("{!$Label.c.Please_Enter_Valid_Value}")+' For Unit Price BRL and USD:'+code;
                                                                            
                                                                            //component.find("unitPriceU").set('v.validity', {valid:false, badInput :true});
                                                                            //component.find("unitPriceU").showHelpMessageIfInvalid();
                                                                        }
                                                                            else if(parseFloat(unitU.replace('.','').replace(',','.').trim()) < parseFloat(minU.replace('.','').replace(',','.').trim())){
                                                                                mainFlag=false;
                                                                                flag=false;
                                                                                ErrMsg+=$A.get("{!$Label.c.Unit_Should_be_Greater_than_Minimum}")+code;
                                                                                
                                                                                //component.find("unitPriceU").focus();
                                                                                //component.find("unitPriceU").set('v.validity', {valid:false, badInput :true});
                                                                                //component.find("unitPriceU").showHelpMessageIfInvalid();
                                                                                
                                                                                
                                                                            }
                                                                                else if(!fspU){
                                                                                    mainFlag=false;
                                                                                    flag=true;
                                                                                    ErrMsg+=$A.get("{!$Label.c.Found_Null_Column_values_for_Both_Currency}")+code;
                                                                                    
                                                                                    //component.find("fspU").set('v.validity', {valid:false, badInput :true});
                                                                                    //component.find("fspU").showHelpMessageIfInvalid();
                                                                                }
                                                                                    else if(isNaN(fspU.replace('.','').replace(',','.').trim())){
                                                                                        mainFlag=false;
                                                                                        flag=false;
                                                                                        invalidFlag=true;
                                                                                        ErrMsg+=$A.get("{!$Label.c.Please_Enter_Valid_Value}")+' For Future Price BRL and USD:'+code;
                                                                                        
                                                                                        //component.find("fspU").set('v.validity', {valid:false, badInput :true});
                                                                                        //component.find("fspU").showHelpMessageIfInvalid();
                                                                                    }
                                                                                        else if(parseFloat(fspU.replace('.','').replace(',','.').trim()).toFixed(2) < 0){
                                                                                            mainFlag=false;
                                                                                            flag=false;
                                                                                            ErrMsg+=$A.get("{!$Label.c.FSP_should_be_Greater_Than_Zero}")+code;
                                                                                            
                                                                                            //component.find("fspU").focus();
                                                                                            //component.find("fspU").set('v.validity', {valid:false, badInput :true});
                                                                                            //component.find("fspU").showHelpMessageIfInvalid();
                                                                                            
                                                                                            
                                                                                        }
                                                                                            else{
                                                                                                mainFlag=true;
                                                                                                flag=false;
                                                                                                invalidFlag=false;
                                                                                                
                                                                                            }
                                
                                
                                
                                
                            }
                }
                if(invalidFlag || ErrMsg!='' || flag){
                    //alert('hello');
                    var toastEvent = $A.get("e.force:showToast");
                    var msg  = ErrMsg;
                    var titl  = $A.get("{!$Label.c.Warning}");
                    toastEvent.setParams({
                        "title": titl,
                        "type": "warning",
                        "message": msg
                    });
                    toastEvent.fire();
                }
                
                
                
                
            }
            
            //alert(cmpList);
            if(mainFlag){
                var dFlag=false;
                //alert(dFlag);
                for(var i = 0; i < cmpList.length; i++) {
                    //alert('hello'+cmpList[i].mt_code);
                    var code=cmpList[i].kit_prod+'#'+cmpList[i].sku_code;
                    var minR=cmpList[i].min_prc;
                    var minU=cmpList[i].min_prc_u;
                    var unitR=cmpList[i].unt_prc;
                    var unitU=cmpList[i].unt_prc_u;
                      //Added by Krishanu & Ankita @WIPRO Start
                      var gm=cmpList[i].GM;
                      var selloutPrice = cmpList[i].sellOutPrice;
                      var selloutType = cmpList[i].selloutType;
                      var SOFactor = cmpList[i].SelloutFactor;
                      var MinFactor = cmpList[i].MinPriceFactor;
                      var sellOutPriceU = cmpList[i].sellOutPriceU;
                      var GMU = cmpList[i].GMU;
                      var selloutTypeU = cmpList[i].selloutTypeU;
                      var SelloutFactorU = cmpList[i].SelloutFactorU;
                      var MinPriceFactorU = cmpList[i].MinPriceFactorU;
                      var fspR=cmpList[i].fsp;
                      var fspU=cmpList[i].fsp_u;  
                      //Added by Krishanu & Ankita @WIPRO Start
                    var fspR=cmpList[i].fsp;
                    var fspU=cmpList[i].fsp_u;                    
                    if(!minR){
                        minR='0';
                    }
                    if(!minU){
                        minU='0';
                    }
                    if(!unitR){
                        unitR='0';
                    }
                    if(!unitU){
                        unitU='0';
                    }
                    if(!fspR){
                        fspR='0';
                    }
                    if(!fspU){
                        fspU='0';
                    }
                    //alert('**set'+skuSet+'*'+code);
                    if (jQuery.inArray(code, skuSet)!='-1') {
                        //alert('exist');
                        dFlag=true;
                        var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.Duplicate_SKU_Found}");
                        var titl  = $A.get("{!$Label.c.Error}");
                        toastEvent.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg
                        });
                        toastEvent.fire();
                        break;
                    }else{
                        var key='5191'+code;
                        if(key in skuDesc){
                            codeDsc=skuDesc[key];
                        }
                        else{
                            codeDsc='';
                        }
                        //Updated Datatable by Krishanu & Ankita @WIPRO
                        $('#tableId').dataTable().fnAddData( [
                            
                            cmpList[i].mt_code,
                            cmpList[i].sku_code,
                            cmpList[i].kit_prod,
                            parseFloat(minR.replace('.','').replace(',','.').trim()).toFixed(2).replace('.',','),
                            parseFloat(minU.replace('.','').replace(',','.').trim()).toFixed(2).replace('.',','),
                            parseFloat(unitR.replace('.','').replace(',','.').trim()).toFixed(2).replace('.',','),
                            parseFloat(unitU.replace('.','').replace(',','.').trim()).toFixed(2).replace('.',','),
                            parseFloat(selloutPrice.replace('.','').replace(',','.').trim()).toFixed(2).replace('.',','),
                            parseFloat(sellOutPriceU.replace('.','').replace(',','.').trim()).toFixed(2).replace('.',','),
                            parseFloat(fspR.replace('.','').replace(',','.').trim()).toFixed(2).replace('.',','),
                            parseFloat(fspU.replace('.','').replace(',','.').trim()).toFixed(2).replace('.',','),
                            gm,
                            GMU,
                            selloutType,
                            selloutTypeU,
                            SOFactor,
                            SelloutFactorU,
                            MinFactor,
                            MinPriceFactorU,
                            '<button  class="btn-to-hide" style="color:red; font-weight:bold; margin-left:21px; background:#fff; border-radius:3px; border:1px solid #ccc; padding:2px 5px 2px 5px;" id="" value="'+count+'" name="'+code+'" iconName="utility:delete" >X</button>'
                            
                        ]);
                        
                        
                        count=count+1;
                        
                        //alert('enter'+i);
                        var skuArray = new Object();            
                        skuArray.pbd_id='';
                        skuArray.sku_code = cmpList[i].sku_code;
                        skuArray.mt_code = cmpList[i].mt_code;
                        skuArray.min_prc = parseFloat(minR.replace('.','').replace(',','.').trim()).toFixed(2).toString();
                        skuArray.min_prc_u = parseFloat(minU.replace('.','').replace(',','.').trim()).toFixed(2).toString();
                        skuArray.unt_prc = parseFloat(unitR.replace('.','').replace(',','.').trim()).toFixed(2).toString();
                        skuArray.unt_prc_u = parseFloat(unitU.replace('.','').replace(',','.').trim()).toFixed(2).toString();
                        skuArray.fsp = parseFloat(fspR.replace('.','').replace(',','.').trim()).toFixed(2).toString();
                        skuArray.fsp_u = parseFloat(fspU.replace('.','').replace(',','.').trim()).toFixed(2).toString();
                          //Added by Krishanu & Ankita @WIPRO - Start
                          skuArray.GM = gm,
                          skuArray.selloutType = selloutType,
                          skuArray.sellOutPrice = selloutPrice.toFixed(2).toString(),
                          skuArray.SelloutFactor = SOFactor,
                          skuArray.MinPriceFactor = MinFactor,
                          skuArray.sellOutPriceU = sellOutPriceU.toFixed(2).toString(),
                          skuArray.GMU = GMU,
                          skuArray.selloutTypeU = selloutTypeU,
                          skuArray.SelloutFactorU = SelloutFactorU,
                          skuArray.MinPriceFactorU = MinPriceFactorU,
                          // - End
                        //kit prod
                        skuArray.kit_comp=cmpList[i].kit_prod+'#'+cmpList[i].sku_code;
                        skuArray.kit_prod=cmpList[i].kit_prod;
                        
                        skDet.push(skuArray);
                        skuSet.push(cmpList[i].kit_prod+'#'+cmpList[i].sku_code);
                    }
                }
                component.set('v.materialDetails',skDet);
                component.set('v.uniqueSKU',skuSet); 
                component.set('v.count',count); 
                if(!dFlag){
                    var successMsg  = $A.get("{!$Label.c.Line_Item_Added_Successfully}"); 
                    var successMsg1 = $A.get("{!$Label.c.Success}");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": successMsg1,
                        "type": "Success",
                        "message": successMsg
                    });
                    toastEvent.fire();
                }
            }
            
        }
        
        else{
            
            var code=component.find("SkuCode1").get("v.value");
            //alert(code);
            var minR=component.find("minPriceR").get("v.value");
            //minR = parseFloat(minR).toFixed(2);
            //minR = minR.toString();
            //console.log('minR'+minR);
            var minU=component.find("minPriceU").get("v.value");
            var unitR=component.find("unitPriceR").get("v.value");
            var unitU=component.find("unitPriceU").get("v.value");
            var fspR=component.find("fspR").get("v.value");
            var fspU=component.find("fspU").get("v.value");
             //Added by Krishanu & Ankita @WIPRO - Start
             var sellOutPrice=component.find("sellOutPrice").get("v.value");
             var GM=component.find("GM").get("v.value");
             var SelloutType=component.find("SelloutType").get("v.value");
             var SelloutFactor=component.find("SelloutFactor").get("v.value");
             var MinPriceFactor=component.find("MinPriceFactor").get("v.value");
             var sellOutPriceU = component.find("sellOutPriceU").get("v.value");
             var GMU = component.find("GMU").get("v.value");
             var selloutTypeU = component.find("selloutTypeU").get("v.value");
             var SelloutFactorU = component.find("SelloutFactorU").get("v.value");
             var MinPriceFactorU = component.find("MinPriceFactorU").get("v.value");
             //Added by Krishanu & Ankita @WIPRO - Start
            
            // kit prd
            var KitProduct=component.find("KitProd").get("v.value");
            
            
            if(!currency){
                var toastEvent1 = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Please_Select_Currency}");
                var titl  = $A.get("{!$Label.c.Warning}");
                toastEvent1.setParams({
                    "title": titl,
                    "type": "warning",
                    "message": msg,
                    "duration":'3000'
                });
                toastEvent1.fire();
                
                // alert("Please select File to Import.");
                mainFlag=false;
                component.find("currencyID").focus();
                
            } 
            else if(!code){
                mainFlag=false;
                component.find("SkuCode1").set('v.validity', {valid:false, badInput :true});
                component.find("SkuCode1").showHelpMessageIfInvalid();
            }
                else if(currency == 'Only BRL'){
                    if(!minR){
                        mainFlag=false;
                        flag=true;
                        component.find("minPriceR").set('v.validity', {valid:false, badInput :true});
                        component.find("minPriceR").showHelpMessageIfInvalid();
                    }
                    else if(isNaN(minR.replace('.','').replace(',','.').trim())){
                        mainFlag=false;
                        flag=false;
                        invalidFlag=true;
                        component.find("minPriceR").set('v.validity', {valid:false, badInput :true});
                        component.find("minPriceR").showHelpMessageIfInvalid();
                        
                        
                    }
                    
                        else if(!unitR){
                            mainFlag=false;
                            flag=true;
                            component.find("unitPriceR").set('v.validity', {valid:false, badInput :true});
                            component.find("unitPriceR").showHelpMessageIfInvalid();
                        }
                            else if(isNaN(unitR.replace('.','').replace(',','.').trim())){
                                mainFlag=false;
                                flag=false;
                                invalidFlag=true;
                                component.find("unitPriceR").set('v.validity', {valid:false, badInput :true});
                                component.find("unitPriceR").showHelpMessageIfInvalid();
                                
                                
                            }
                                else if(parseFloat(unitR.replace('.','').replace(',','.').trim()) < parseFloat(minR.replace('.','').replace(',','.').trim())){
                                    mainFlag=false;
                                    flag=false;
                                    component.find("unitPriceR").focus();
                                    //component.find("unitPriceR").set('v.validity', {valid:false, badInput :true});
                                    //component.find("unitPriceR").showHelpMessageIfInvalid();
                                    
                                    var toastEvent = $A.get("e.force:showToast");
                                    var msg  = $A.get("{!$Label.c.Unit_Should_be_Greater_than_Minimum}");
                                    var titl  = $A.get("{!$Label.c.Error}");
                                    toastEvent.setParams({
                                        "title": titl,
                                        "type": "error",
                                        "message": msg
                                    });
                                    toastEvent.fire();
                                }
                                    else if(!fspR){
                                        mainFlag=false;
                                        flag=true;
                                        component.find("fspR").set('v.validity', {valid:false, badInput :true});
                                        component.find("fspR").showHelpMessageIfInvalid();
                                    }
                                        else if(isNaN(fspR.replace('.','').replace(',','.').trim())){
                                            mainFlag=false;
                                            flag=false;
                                            invalidFlag=true;
                                            component.find("fspR").set('v.validity', {valid:false, badInput :true});
                                            component.find("fspR").showHelpMessageIfInvalid();
                                            
                                            
                                        }
                                            else if(parseFloat(fspR.replace('.','').replace(',','.').trim()).toFixed(2) < 0){
                                                mainFlag=false;
                                                flag=false;
                                                component.find("fspR").focus();
                                                component.find("fspR").set('v.validity', {valid:false, badInput :true});
                                                component.find("fspR").showHelpMessageIfInvalid();
                                                
                                                var toastEvent = $A.get("e.force:showToast");
                                                var msg  = $A.get("{!$Label.c.FSP_should_be_Greater_Than_Zero}");
                                                var titl  = $A.get("{!$Label.c.Error}");
                                                toastEvent.setParams({
                                                    "title": titl,
                                                    "type": "error",
                                                    "message": msg
                                                });
                                                toastEvent.fire();
                                            }
                                                else{
                                                    mainFlag=true;
                                                    flag=false;
                                                    invalidFlag=false;
                                                    minU='0'; 
                                                    unitU='0';
                                                    fspU='0';
                                                     //Added by Krishanu & Ankita @WIPRO - Start
                                                     sellOutPriceU=0;
                                                     GMU=0;
                                                     selloutTypeU='';
                                                     SelloutFactorU=0;
                                                     MinPriceFactorU=0;
                                                     //- End
                                                }
                    
                    if(invalidFlag){
                        var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.Please_Enter_Valid_Value}");
                        var titl  = $A.get("{!$Label.c.Warning}");
                        toastEvent.setParams({
                            "title": titl,
                            "type": "warning",
                            "message": msg
                        });
                        toastEvent.fire();
                    }
                    
                    if(flag){
                        var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.Found_Null_Column_values_for_BRL}");
                        var titl  = $A.get("{!$Label.c.Warning}");
                        toastEvent.setParams({
                            "title": titl,
                            "type": "warning",
                            "message": msg
                        });
                        toastEvent.fire();
                    }
                }
                    else if(currency =='Only USD'){
                        if(!minU){
                            mainFlag=false;
                            flag=true;
                            component.find("minPriceU").set('v.validity', {valid:false, badInput :true});
                            component.find("minPriceU").showHelpMessageIfInvalid();
                        }
                        else if(isNaN(minU.replace('.','').replace(',','.').trim())){
                            mainFlag=false;
                            flag=false;
                            invalidFlag=true;
                            component.find("minPriceU").set('v.validity', {valid:false, badInput :true});
                            component.find("minPriceU").showHelpMessageIfInvalid();
                        }
                            else if(!unitU){
                                mainFlag=false;
                                flag=true;
                                component.find("unitPriceU").set('v.validity', {valid:false, badInput :true});
                                component.find("unitPriceU").showHelpMessageIfInvalid();
                            }
                                else if(isNaN(unitU.replace('.','').replace(',','.').trim())){
                                    mainFlag=false;
                                    flag=false;
                                    invalidFlag=true;
                                    component.find("unitPriceU").set('v.validity', {valid:false, badInput :true});
                                    component.find("unitPriceU").showHelpMessageIfInvalid();
                                }
                                    else if(parseFloat(unitU.replace('.','').replace(',','.').trim()) < parseFloat(minU.replace('.','').replace(',','.').trim())){
                                        mainFlag=false;
                                        flag=false;
                                        component.find("unitPriceU").focus();
                                        component.find("unitPriceU").set('v.validity', {valid:false, badInput :true});
                                        component.find("unitPriceU").showHelpMessageIfInvalid();
                                        
                                        var toastEvent = $A.get("e.force:showToast");
                                        var msg  = $A.get("{!$Label.c.Unit_Should_be_Greater_than_Minimum}");
                                        var titl  = $A.get("{!$Label.c.Error}");
                                        toastEvent.setParams({
                                            "title": titl,
                                            "type": "error",
                                            "message": msg
                                        });
                                        toastEvent.fire();
                                    }
                                        else if(!fspU){
                                            mainFlag=false;
                                            flag=true;
                                            component.find("fspU").set('v.validity', {valid:false, badInput :true});
                                            component.find("fspU").showHelpMessageIfInvalid();
                                        }
                                            else if(isNaN(fspU.replace('.','').replace(',','.').trim())){
                                                mainFlag=false;
                                                flag=false;
                                                invalidFlag=true;
                                                component.find("fspU").set('v.validity', {valid:false, badInput :true});
                                                component.find("fspU").showHelpMessageIfInvalid();
                                            }
                                                else if(parseFloat(fspU.replace('.','').replace(',','.').trim()).toFixed(2) < 0){
                                                    mainFlag=false;
                                                    flag=false;
                                                    component.find("fspU").focus();
                                                    component.find("fspU").set('v.validity', {valid:false, badInput :true});
                                                    component.find("fspU").showHelpMessageIfInvalid();
                                                    
                                                    var toastEvent = $A.get("e.force:showToast");
                                                    var msg  = $A.get("{!$Label.c.FSP_should_be_Greater_Than_Zero}");
                                                    var titl  = $A.get("{!$Label.c.Error}");
                                                    toastEvent.setParams({
                                                        "title": titl,
                                                        "type": "error",
                                                        "message": msg
                                                    });
                                                    toastEvent.fire();
                                                }
                                                    else{
                                                        mainFlag=true;
                                                        flag=false;
                                                        invalidFlag=false;
                                                        minR='0'; 
                                                        unitR='0';
                                                        fspR='0';
                                                          //Added by Krishanu & Ankita @WIPRO - Start
                                                          sellOutPrice=0;
                                                          GM=0;
                                                          selloutType='';
                                                          SelloutFactor=0;
                                                          MinPriceFactor=0;
                                                          // - End
                                                    }
                        
                        if(invalidFlag){
                            var toastEvent = $A.get("e.force:showToast");
                            var msg  = $A.get("{!$Label.c.Please_Enter_Valid_Value}");
                            var titl  = $A.get("{!$Label.c.Warning}");
                            toastEvent.setParams({
                                "title": titl,
                                "type": "warning",
                                "message": msg
                            });
                            toastEvent.fire();
                        }
                        
                        if(flag){
                            var toastEvent = $A.get("e.force:showToast");
                            var msg  = $A.get("{!$Label.c.Found_Null_Column_values_for_USD}");
                            var titl  = $A.get("{!$Label.c.Warning}");
                            toastEvent.setParams({
                                "title": titl,
                                "type": "warning",
                                "message": msg
                            });
                            toastEvent.fire();
                        }
                        
                    }
                        else if(currency =='BRL and USD'){
                            
                            if(!minR){
                                mainFlag=false;
                                flag=true;
                                component.find("minPriceR").set('v.validity', {valid:false, badInput :true});
                                component.find("minPriceR").showHelpMessageIfInvalid();
                            }
                            else if(isNaN(minR.replace('.','').replace(',','.').trim())){
                                mainFlag=false;
                                flag=false;
                                invalidFlag=true;
                                component.find("minPriceR").set('v.validity', {valid:false, badInput :true});
                                component.find("minPriceR").showHelpMessageIfInvalid();
                                
                                
                            }
                                else if(!unitR){
                                    mainFlag=false;
                                    flag=true;
                                    component.find("unitPriceR").set('v.validity', {valid:false, badInput :true});
                                    component.find("unitPriceR").showHelpMessageIfInvalid();
                                }
                                    else if(isNaN(unitR.replace('.','').replace(',','.').trim())){
                                        mainFlag=false;
                                        flag=false;
                                        invalidFlag=true;
                                        component.find("unitPriceR").set('v.validity', {valid:false, badInput :true});
                                        component.find("unitPriceR").showHelpMessageIfInvalid();
                                    }
                                        else if(parseFloat(unitR.replace('.','').replace(',','.').trim()) < parseFloat(minR.replace('.','').replace(',','.').trim())){
                                            mainFlag=false;
                                            flag=false;
                                            component.find("unitPriceR").focus();
                                            //component.find("unitPriceR").set('v.validity', {valid:false, badInput :true});
                                            //component.find("unitPriceR").showHelpMessageIfInvalid();
                                            
                                            var toastEvent = $A.get("e.force:showToast");
                                            var msg  = $A.get("{!$Label.c.Unit_Should_be_Greater_than_Minimum}");
                                            var titl  = $A.get("{!$Label.c.Error}");
                                            toastEvent.setParams({
                                                "title": titl,
                                                "type": "error",
                                                "message": msg
                                            });
                                            toastEvent.fire();
                                        }
                                            else if(!fspR){
                                                mainFlag=false;
                                                flag=true;
                                                component.find("fspR").set('v.validity', {valid:false, badInput :true});
                                                component.find("fspR").showHelpMessageIfInvalid();
                                            }
                                                else if(isNaN(fspR.replace('.','').replace(',','.').trim())){
                                                    mainFlag=false;
                                                    flag=false;
                                                    invalidFlag=true;
                                                    component.find("fspR").set('v.validity', {valid:false, badInput :true});
                                                    component.find("fspR").showHelpMessageIfInvalid();
                                                    
                                                    
                                                }
                                                    else if(parseFloat(fspR.replace('.','').replace(',','.').trim()).toFixed(2) < 0){
                                                        mainFlag=false;
                                                        flag=false;
                                                        component.find("fspR").focus();
                                                        component.find("fspR").set('v.validity', {valid:false, badInput :true});
                                                        component.find("fspR").showHelpMessageIfInvalid();
                                                        
                                                        var toastEvent = $A.get("e.force:showToast");
                                                        var msg  = $A.get("{!$Label.c.FSP_should_be_Greater_Than_Zero}");
                                                        var titl  = $A.get("{!$Label.c.Error}");
                                                        toastEvent.setParams({
                                                            "title": titl,
                                                            "type": "error",
                                                            "message": msg
                                                        });
                                                        toastEvent.fire();
                                                    }
                                                        else if(!minU){
                                                            mainFlag=false;
                                                            flag=true;
                                                            component.find("minPriceU").set('v.validity', {valid:false, badInput :true});
                                                            component.find("minPriceU").showHelpMessageIfInvalid();
                                                        }
                                                            else if(isNaN(minU.replace('.','').replace(',','.').trim())){
                                                                mainFlag=false;
                                                                flag=false;
                                                                invalidFlag=true;
                                                                component.find("minPriceU").set('v.validity', {valid:false, badInput :true});
                                                                component.find("minPriceU").showHelpMessageIfInvalid();
                                                            }
                                                                else if(!unitU){
                                                                    mainFlag=false;
                                                                    flag=true;
                                                                    component.find("unitPriceU").set('v.validity', {valid:false, badInput :true});
                                                                    component.find("unitPriceU").showHelpMessageIfInvalid();
                                                                }
                                                                    else if(isNaN(unitU.replace('.','').replace(',','.').trim())){
                                                                        mainFlag=false;
                                                                        flag=false;
                                                                        invalidFlag=true;
                                                                        component.find("unitPriceU").set('v.validity', {valid:false, badInput :true});
                                                                        component.find("unitPriceU").showHelpMessageIfInvalid();
                                                                    }
                                                                        else if(parseFloat(unitU.replace('.','').replace(',','.').trim()) < parseFloat(minU.replace('.','').replace(',','.').trim())){
                                                                            mainFlag=false;
                                                                            flag=false;
                                                                            component.find("unitPriceU").focus();
                                                                            component.find("unitPriceU").set('v.validity', {valid:false, badInput :true});
                                                                            component.find("unitPriceU").showHelpMessageIfInvalid();
                                                                            
                                                                            var toastEvent = $A.get("e.force:showToast");
                                                                            var msg  = $A.get("{!$Label.c.Unit_Should_be_Greater_than_Minimum}");
                                                                            var titl  = $A.get("{!$Label.c.Error}");
                                                                            toastEvent.setParams({
                                                                                "title": titl,
                                                                                "type": "error",
                                                                                "message": msg
                                                                            });
                                                                            toastEvent.fire();
                                                                        }
                                                                            else if(!fspU){
                                                                                mainFlag=false;
                                                                                flag=true;
                                                                                component.find("fspU").set('v.validity', {valid:false, badInput :true});
                                                                                component.find("fspU").showHelpMessageIfInvalid();
                                                                            }
                                                                                else if(isNaN(fspU.replace('.','').replace(',','.').trim())){
                                                                                    mainFlag=false;
                                                                                    flag=false;
                                                                                    invalidFlag=true;
                                                                                    component.find("fspU").set('v.validity', {valid:false, badInput :true});
                                                                                    component.find("fspU").showHelpMessageIfInvalid();
                                                                                }
                                                                                    else if(parseFloat(fspU.replace('.','').replace(',','.').trim()).toFixed(2) < 0){
                                                                                        mainFlag=false;
                                                                                        flag=false;
                                                                                        component.find("fspU").focus();
                                                                                        component.find("fspU").set('v.validity', {valid:false, badInput :true});
                                                                                        component.find("fspU").showHelpMessageIfInvalid();
                                                                                        
                                                                                        var toastEvent = $A.get("e.force:showToast");
                                                                                        var msg  = $A.get("{!$Label.c.FSP_should_be_Greater_Than_Zero}");
                                                                                        var titl  = $A.get("{!$Label.c.Error}");
                                                                                        toastEvent.setParams({
                                                                                            "title": titl,
                                                                                            "type": "error",
                                                                                            "message": msg
                                                                                        });
                                                                                        toastEvent.fire();
                                                                                    }
                                                                                        else{
                                                                                            mainFlag=true;
                                                                                            flag=false;
                                                                                            invalidFlag=false;
                                                                                            
                                                                                        }
                            
                            if(invalidFlag){
                                var toastEvent = $A.get("e.force:showToast");
                                var msg  = $A.get("{!$Label.c.Please_Enter_Valid_Value}");
                                var titl  = $A.get("{!$Label.c.Warning}");
                                toastEvent.setParams({
                                    "title": titl,
                                    "type": "warning",
                                    "message": msg
                                });
                                toastEvent.fire();
                            }
                            
                            if(flag){
                                var toastEvent = $A.get("e.force:showToast");
                                var msg  = $A.get("{!$Label.c.Found_Null_Column_values_for_Both_Currency}");
                                var titl  = $A.get("{!$Label.c.Warning}");
                                toastEvent.setParams({
                                    "title": titl,
                                    "type": "warning",
                                    "message": msg
                                });
                                toastEvent.fire();
                            }
                        }
            
            if(mainFlag){
                
                if (jQuery.inArray(code, skuSet)!='-1') {
                    
                    var toastEvent = $A.get("e.force:showToast");
                    var msg  = $A.get("{!$Label.c.Duplicate_SKU_Found}");
                    var titl  = $A.get("{!$Label.c.Error}");
                    toastEvent.setParams({
                        "title": titl,
                        "type": "error",
                        "message": msg
                    });
                    toastEvent.fire();
                    
                }else{
                    var key='5191'+code;
                    if(key in skuDesc){
                        codeDsc=skuDesc[key];
                    }
                    else{
                        codeDsc='';
                    }
                    //alert(KitProduct);
                     //Updated Datatable Krishanu & Ankita @WIPRO - Start

                    $('#tableId').dataTable().fnAddData( [
                        
                        code,
                        codeDsc,
                        KitProduct,
                        parseFloat(minR.replace('.','').replace(',','.').trim()).toFixed(2).replace('.',','),
                        parseFloat(minU.replace('.','').replace(',','.').trim()).toFixed(2).replace('.',','),
                        parseFloat(unitR.replace('.','').replace(',','.').trim()).toFixed(2).replace('.',','),
                        parseFloat(unitU.replace('.','').replace(',','.').trim()).toFixed(2).replace('.',','),
                        sellOutPrice,
                        sellOutPriceU,
                        //Added by Krishanu & Ankita @WIPRO - Start
                       // parseFloat(sellOutPrice).toFixed(2).replace('.',','),
                       // parseFloat(sellOutPriceU).toFixed(2).replace('.',','),
                        //Added by Krishanu & Ankita @WIPRO - end
                        parseFloat(fspR.replace('.','').replace(',','.').trim()).toFixed(2).replace('.',','),
                        parseFloat(fspU.replace('.','').replace(',','.').trim()).toFixed(2).replace('.',','),
                          //Added by Krishanu & Ankita @WIPRO - Start
                          GM,
                          GMU,
                          SelloutType,
                          selloutTypeU,
                          SelloutFactor,
                          SelloutFactorU,
                          MinPriceFactor,
                          MinPriceFactorU,
                          //Added by Krishanu & Ankita @WIPRO - end
                        '<button  class="btn-to-hide" style="color:red; font-weight:bold; margin-left:21px; background:#fff; border-radius:3px; border:1px solid #ccc; padding:2px 5px 2px 5px;" id="" value="'+count+'" name="'+code+'" iconName="utility:delete" >X</button>'
                        
                    ]);
                    
                    count=count+1;
                    var skuArray = new Object();            
                    skuArray.pbd_id='';
                    skuArray.sku_code = code;
                    skuArray.mt_code = codeDsc;
                    skuArray.min_prc = parseFloat(minR.replace('.','').replace(',','.').trim()).toFixed(2).toString();
                    skuArray.min_prc_u = parseFloat(minU.replace('.','').replace(',','.').trim()).toFixed(2).toString();
                    skuArray.unt_prc = parseFloat(unitR.replace('.','').replace(',','.').trim()).toFixed(2).toString();
                    skuArray.unt_prc_u = parseFloat(unitU.replace('.','').replace(',','.').trim()).toFixed(2).toString();
                    skuArray.fsp = parseFloat(fspR.replace('.','').replace(',','.').trim()).toFixed(2).toString();
                    skuArray.fsp_u = parseFloat(fspU.replace('.','').replace(',','.').trim()).toFixed(2).toString();
                     //Added by Krishanu & Ankita @WIPRO - Start
                     skuArray.sellOutPrice = sellOutPrice;
                     skuArray.sellOutPriceU = sellOutPriceU;
                     //skuArray.sellOutPrice = parseFloat(sellOutPrice).toFixed(2).toString();
                     skuArray.GM = GM;
                     skuArray.selloutType = SelloutType;
                     skuArray.SelloutFactor = SelloutFactor;
                     skuArray.MinPriceFactor = MinPriceFactor;
                     //skuArray.sellOutPriceU = parseFloat(sellOutPriceU).toFixed(2).toString();
                     skuArray.GMU = GMU;
                     skuArray.SelloutFactorU = SelloutFactorU;
                     skuArray.MinPriceFactorU = MinPriceFactorU;
                     skuArray.selloutTypeU = selloutTypeU;
                     //Added by Krishanu & Ankita @WIPRO - Start
                    //kit prod
                    skuArray.kit_prod=KitProduct;
                    skDet.push(skuArray);
                    skuSet.push(code);
                    
                    component.set('v.materialDetails',skDet);
                    component.set('v.uniqueSKU',skuSet); 
                    component.set('v.count',count); 
                    
                    var successMsg  = $A.get("{!$Label.c.Line_Item_Added_Successfully}"); 
                    var successMsg1 = $A.get("{!$Label.c.Success}");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": successMsg1,
                        "type": "Success",
                        "message": successMsg
                    });
                    toastEvent.fire();
                }
            }
        }
    },
    open2Model: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isfinalModalOpen", true);
     },
    
     close2Model: function(cmp, event, helper) {
        // Set isModalOpen attribute to false  
        cmp.set("v.isfinalModalOpen", false);
       helper.gotoListviewHelper(cmp,'pending');
  
     },
    
     submit2Details: function(cmp, event, helper) {
        // Set isModalOpen attribute to false
        //Add your code to call apex method or do some processing
        cmp.set("v.isfinalModalOpen", false);
       helper.gotoListviewHelper(cmp,'pending');
  
     },
        // Added by Krishanu Mallik Thakur and Ankita Tripathy @WIPRO
      handleUnitPrice:function(cmp, event, helper){
          
          var skuWrapper = cmp.get("v.skuWrapper");
          var gm;
          var skywrap;
          var cfw ;
          var type;
          cfw = cmp.get('v.cfWrap');
          skywrap = cmp.get('v.skuWrapper.unt_prc');
          console.log('skuWrapper***',skuWrapper);
          console.log('***skuWrapper***',JSON.stringify(skuWrapper));
          
          var currtype = cmp.get("v.priceBookDetails.curncy");
          var flag = false;
          var smat = cmp.get('v.selloutMatrix');
          var ER = cmp.get('v.exchangeRate');
          smat.forEach(function(item){
              if(item.Type__c==cmp.get('v.skuWrapper.Brand')){
                  cmp.set('v.skuWrapper.SelloutFactor',item.Sell_Out_Factor__c);
                  cmp.set('v.skuWrapper.MinPriceFactor',item.Min_Price_Factor__c);
                  type = cmp.get('v.skuWrapper.mt_code');
                  flag = true;
                  
                  var minpriceu1 = cmp.get('v.skuWrapper.unt_prc');
                  console.log('minpriceu1*******'+minpriceu1);
                  minpriceu1 = minpriceu1.replace(/,/g, '.');
                  console.log('minpriceu2******'+minpriceu1);
                  var MinPriceFactor1 = cmp.get('v.skuWrapper.MinPriceFactor');
                  console.log('MinPriceFactor1*******'+MinPriceFactor1);
                  // var minprice=cmp.get('v.skuWrapper.unt_prc')-(cmp.get('v.skuWrapper.unt_prc')*cmp.get('v.skuWrapper.MinPriceFactor')/100);
                  var minprice=minpriceu1-(minpriceu1*MinPriceFactor1/100);
                  cmp.find('minPriceR').set('v.value',minprice.toFixed(2).toString().replace('.',','));
                  
                  skywrap = skywrap.replace(/,/g, '.');
                  var selloutp = skywrap*cfw.maximum + (skywrap*cfw.maximum*cmp.get('v.skuWrapper.SelloutFactor')/100);
                  
                  console.log('skywrap*******'+skywrap);
                  console.log('cfw.maximum*******'+cfw.maximum);
                  console.log('v.skuWrapper.SelloutFactor*******'+cmp.get('v.skuWrapper.SelloutFactor'));
                  //console.log('MinPriceFactor1*******'+MinPriceFactor1);
                  console.log('selloutp*******'+selloutp.toFixed(2).toString());
                  
                  cmp.set('v.skuWrapper.sellOutPrice',selloutp.toFixed(2).toString().replace('.',','));
                //   cmp.set('v.skuWrapper.sellOutPriceU','0');
                  cmp.set('v.skuWrapper.selloutType',item.Type__c);
                   //cmp.set('v.skuWrapper.selloutTypeU',' - ');
                  cmp.set('v.skuWrapper.GM',0);
                  cmp.set('v.skuWrapper.GMU',0);
                  
                  //   break;
                  //  return true;
              }
          });
          if(flag == false){
              console.log('SagarTestSellout');
              var action = cmp.get('c.getReplacementCost');
              action.setParams({
                  skuid:cmp.get('v.skuWrapper.pbd_id')
              });
              action.setCallback(this, function(response) {
                  var state = response.getState();
                  if (state === "SUCCESS") {
                      // var gm;var skywrap;
                      var rep = response.getReturnValue()*ER;
                      //  cfw = cmp.get('v.cfWrap');
                      // skywrap = cmp.get('v.skuWrapper.unt_prc');
                      skywrap = skywrap.replace(/,/g, '.');
                      gm = (skywrap*cfw.minimum*0.96-rep)/(skywrap*cfw.minimum*0.96);
                      console.log('GM %',gm,rep,ER);
                      if(skywrap==0||skywrap==null||skywrap==undefined){
                          gm=0;
                      }
                      gm = Math.round(gm*100);
                      // var type;
                      if(gm>=60){
                          type = 'Gold';
                      }else if(gm<60&&gm>=40){
                          type = 'A';
                      }else if(gm<40&&gm>=20){
                          type = 'B';
                      }else{
                          type = 'C';
                      }
                      cmp.set('v.skuWrapper.GM',gm);
                      // var smat = cmp.get('v.selloutMatrix');
                      smat.forEach(function(item){
                          if(item.Type__c==type){
                              cmp.set('v.skuWrapper.SelloutFactor',item.Sell_Out_Factor__c);
                              cmp.set('v.skuWrapper.MinPriceFactor',item.Min_Price_Factor__c);
                              
                          }
                      });
                      var minpriceu1 = cmp.get('v.skuWrapper.unt_prc');
                      console.log('minpriceu1'+minpriceu1);
                      minpriceu1 = minpriceu1.replace(/,/g, '.');
                      console.log('minpriceu2'+minpriceu1);
                      var MinPriceFactor1 = cmp.get('v.skuWrapper.MinPriceFactor');
                      console.log('MinPriceFactor1'+MinPriceFactor1);
                      // var minprice=cmp.get('v.skuWrapper.unt_prc')-(cmp.get('v.skuWrapper.unt_prc')*cmp.get('v.skuWrapper.MinPriceFactor')/100);
                      var minprice=minpriceu1-(minpriceu1*MinPriceFactor1/100);
                      cmp.find('minPriceR').set('v.value',minprice.toFixed(2).toString().replace('.',','));
                      var selloutp = skywrap*cfw.maximum + (skywrap*cfw.maximum*cmp.get('v.skuWrapper.SelloutFactor')/100);
                      cmp.set('v.skuWrapper.sellOutPrice',selloutp.toFixed(2).toString().replace('.',','));
                   //   cmp.set('v.skuWrapper.sellOutPriceU','0');
                      cmp.set('v.skuWrapper.selloutType',type);
                    //  cmp.set('v.skuWrapper.selloutTypeU',' - ');
                      // cmp.set('v.skuWrapper.GM',gm); 
                  }
              });
              $A.enqueueAction(action);
          }
      },
      
      
       // Added by Krishanu Mallik Thakur and Ankita Tripathy @WIPRO
      handleUnitPriceUSD:function(cmp, event, helper){
          
          var skuWrapper = cmp.get("v.skuWrapper");
          var gm;
          var skywrap;
          var cfw ;
          var type;
          cfw = cmp.get('v.cfWrap');
          skywrap = cmp.get('v.skuWrapper.unt_prc_u');
          console.log('skuWrapper***',skuWrapper);
          console.log('***skuWrapper***',JSON.stringify(skuWrapper));
          
          var currtype = cmp.get("v.priceBookDetails.curncy");
          var flag = false;
          var smat = cmp.get('v.selloutMatrix');
          smat.forEach(function(item){
              if(item.Type__c==cmp.get('v.skuWrapper.Brand')){
                  cmp.set('v.skuWrapper.SelloutFactorU',item.Sell_Out_Factor__c);
                  cmp.set('v.skuWrapper.MinPriceFactorU',item.Min_Price_Factor__c);
                  type = cmp.get('v.skuWrapper.mt_code');
                  flag = true;
                  
                  var minpriceu1 = cmp.get('v.skuWrapper.unt_prc_u');
                  console.log('minpriceu1*******'+minpriceu1);
                  minpriceu1 = minpriceu1.replace(/,/g, '.');
                  console.log('minpriceu2******'+minpriceu1);
                  var MinPriceFactor1 = cmp.get('v.skuWrapper.MinPriceFactorU');
                  console.log('MinPriceFactor1*******'+MinPriceFactor1);
                  // var minprice=cmp.get('v.skuWrapper.unt_prc_u')-(cmp.get('v.skuWrapper.unt_prc_u')*cmp.get('v.skuWrapper.MinPriceFactorU')/100);
                  var minprice=minpriceu1-(minpriceu1*MinPriceFactor1/100);
                  cmp.find('minPriceU').set('v.value',minprice.toFixed(2).toString().replace('.',','));
                  skywrap = skywrap.replace(/,/g, '.');
                  var selloutp = skywrap*cfw.maximum + (skywrap*cfw.maximum*cmp.get('v.skuWrapper.SelloutFactorU')/100);
                  
                  console.log('skywrap*******'+skywrap);
                  console.log('cfw.maximum*******'+cfw.maximum);
                  console.log('v.skuWrapper.SelloutFactorU*******'+cmp.get('v.skuWrapper.SelloutFactorU'));
                  //console.log('MinPriceFactor1*******'+MinPriceFactorU);
                  console.log('selloutp*******'+selloutp);
                  
                  cmp.set('v.skuWrapper.sellOutPriceU',selloutp.toFixed(2).toString().replace('.',','));
                  cmp.set('v.skuWrapper.selloutTypeU',item.Type__c);
                 // cmp.set('v.skuWrapper.sellOutPrice','0');
                  cmp.set('v.skuWrapper.GM',0);
                  cmp.set('v.skuWrapper.GMU',0);
                  
                  //   break;
                  //  return true;
              }
          });
          if(flag == false){
              console.log('SagarTestSellout');
              var action = cmp.get('c.getReplacementCost');
              action.setParams({
                  skuid:cmp.get('v.skuWrapper.pbd_id')
              });
              action.setCallback(this, function(response) {
                  var state = response.getState();
                  if (state === "SUCCESS") {
                      // var gm;var skywrap;
                      var rep = response.getReturnValue();
                      //  cfw = cmp.get('v.cfWrap');
                      // skywrap = cmp.get('v.skuWrapper.unt_prc');
                      skywrap = skywrap.replace(/,/g, '.');
                      gm = (skywrap*cfw.minimum*0.96-rep)/(skywrap*cfw.minimum*0.96);
                      console.log('GM %',gm,rep);
                      if(skywrap==0||skywrap==null||skywrap==undefined){
                          gm=0;
                      }
                      gm = Math.round(gm*100);
                      // var type;
                      if(gm>=60){
                          type = 'Gold';
                      }else if(gm<60&&gm>=40){
                          type = 'A';
                      }else if(gm<40&&gm>=20){
                          type = 'B';
                      }else{
                          type = 'C';
                      }
                      cmp.set('v.skuWrapper.GMU',gm);
                      // var smat = cmp.get('v.selloutMatrix');
                      smat.forEach(function(item){
                          if(item.Type__c==type){
                              cmp.set('v.skuWrapper.SelloutFactorU',item.Sell_Out_Factor__c);
                              cmp.set('v.skuWrapper.MinPriceFactorU',item.Min_Price_Factor__c);
                              
                          }
                      });
                      var minpriceu1 = cmp.get('v.skuWrapper.unt_prc_u');
                      console.log('minpriceu1'+minpriceu1);
                      minpriceu1 = minpriceu1.replace(/,/g, '.');
                      console.log('minpriceu2'+minpriceu1);
                      var MinPriceFactor1 = cmp.get('v.skuWrapper.MinPriceFactorU');
                      console.log('MinPriceFactor1'+MinPriceFactor1);
                      // var minprice=cmp.get('v.skuWrapper.unt_prc_u')-(cmp.get('v.skuWrapper.unt_prc_u')*cmp.get('v.skuWrapper.MinPriceFactor')/100);
                      var minprice=minpriceu1-(minpriceu1*MinPriceFactor1/100);
                      cmp.find('minPriceU').set('v.value',minprice.toFixed(2).toString().replace('.',','));
                      var selloutp = skywrap*cfw.maximum + (skywrap*cfw.maximum*cmp.get('v.skuWrapper.SelloutFactorU')/100);
                      cmp.set('v.skuWrapper.sellOutPriceU',selloutp.toFixed(2).toString().replace('.',','));
                      cmp.set('v.skuWrapper.selloutTypeU',type);
                      //cmp.set('v.skuWrapper.sellOutPrice','0');
                      // cmp.set('v.skuWrapper.GM',gm); 
                  }
              });
              $A.enqueueAction(action);
          }
      },
      
      //Added by Krishanu & Ankita @Wipro
      handleUnitPriceKit:function(cmp, event, helper){
          var currtype = cmp.get("v.priceBookDetails.curncy");
          var complist = cmp.get("v.compList");
          var idx = event.getSource().get("v.label");
          console.log(idx,complist);
          var gm;var skywrap;
                  var rep ;
          var cfw = cmp.get('v.cfWrap');
          var type;
          var flag = false;
          var smat = cmp.get('v.selloutMatrix');
          var ER = cmp.get('v.exchangeRate');
          
           smat.forEach(function(item){
                      if(item.Type__c==cmp.get('v.skuWrapper.Brand')){
                          complist[idx].SelloutFactor=item.Sell_Out_Factor__c;
                          complist[idx].MinPriceFactor=item.Min_Price_Factor__c;
                           flag = true;
                          skywrap = parseFloat(complist[idx].unt_prc);
                          complist[idx].unt_prc=complist[idx].unt_prc.replace(/,/g, '.');
                          var minprice=complist[idx].unt_prc-complist[idx].unt_prc*complist[idx].MinPriceFactor/100;
                  complist[idx].min_prc=Math.round(minprice).toString();
                          console.log('skywrap*******'+skywrap);
                          console.log('cfw.maximum*******'+cfw.maximum);
                          console.log('complist[idx].SelloutFactor*******'+complist[idx].SelloutFactor);
                          //console.log('skywrap*******'+skywrap);
                          
                  var selloutp = skywrap*cfw.maximum + (skywrap*cfw.maximum*complist[idx].SelloutFactor/100);
                          console.log('selloutp*******'+selloutp);
                  complist[idx].sellOutPrice=selloutp;
                  complist[idx].SelloutType=item.Type__c;
                  complist[idx].GM=0;
                  cmp.set('v.compList',complist);
                  
                      }
                  });
                  
                  
          
          
          if(flag == false){
          var action = cmp.get('c.getReplacementCost');
          action.setParams({
              skuid:complist[idx].pbd_id
          });
          action.setCallback(this, function(response) {
              var state = response.getState();
              if (state === "SUCCESS") {
                  //var gm;var skywrap;
                  rep = response.getReturnValue()*ER;
                  //var cfw = cmp.get('v.cfWrap');
                  skywrap = parseFloat(complist[idx].unt_prc);
                  gm = (skywrap*cfw.minimum*0.96-rep)/(skywrap*cfw.minimum*0.96);
                  console.log('GM %',gm,rep,skywrap,typeof cfw);
                  if(skywrap==0||skywrap==null||skywrap==undefined){
                      gm=0;
                  }
                  gm = Math.round(gm*100);
                  //var type;
                  if(gm>=60){
                      type = 'Gold';
                  }else if(gm<60&&gm>=40){
                      type = 'A';
                  }else if(gm<40&&gm>=20){
                      type = 'B';
                  }else{
                      type = 'C';
                  }
                  //var smat = cmp.get('v.selloutMatrix');
                  smat.forEach(function(item){
                      if(item.Type__c==type){
                          complist[idx].SelloutFactor=item.Sell_Out_Factor__c;
                          complist[idx].MinPriceFactor=item.Min_Price_Factor__c;
                          
                      }
                  });
                  complist[idx].unt_prc=complist[idx].unt_prc.replace(/,/g, '.');
                  var minprice=complist[idx].unt_prc-complist[idx].unt_prc*complist[idx].MinPriceFactor/100;
                  complist[idx].min_prc=Math.round(minprice).toString();
                  var selloutp = skywrap*cfw.maximum + (skywrap*cfw.maximum*complist[idx].SelloutFactor/100);
                  complist[idx].sellOutPrice=selloutp;
                  complist[idx].SelloutType=type;
                  complist[idx].GM=gm;
                  cmp.set('v.compList',complist);
              }
          });
           $A.enqueueAction(action);
          }
         
      },
      
       //Added by Krishanu & Ankita @Wipro
      handleUnitPriceKitUS:function(cmp, event, helper){
          var currtype = cmp.get("v.priceBookDetails.curncy");
          var complist = cmp.get("v.compList");
          var idx = event.getSource().get("v.label");
          console.log(idx,complist);
          var gm;var skywrap;
                  var rep ;
          var cfw = cmp.get('v.cfWrap');
          var type;
          var flag = false;
          var smat = cmp.get('v.selloutMatrix');
          
           smat.forEach(function(item){
                      if(item.Type__c==cmp.get('v.skuWrapper.Brand')){
                          complist[idx].SelloutFactorU=item.Sell_Out_Factor__c;
                          complist[idx].MinPriceFactorU=item.Min_Price_Factor__c;
                           flag = true;
                          skywrap = parseFloat(complist[idx].unt_prc_u);
                          complist[idx].unt_prc_u=complist[idx].unt_prc_u.replace(/,/g, '.');
                          var minprice=complist[idx].unt_prc_u-complist[idx].unt_prc_u*complist[idx].MinPriceFactorU/100;
                  complist[idx].min_prc_u=Math.round(minprice).toString();
                          console.log('skywrap*******'+skywrap);
                          console.log('cfw.maximum*******'+cfw.maximum);
                          console.log('complist[idx].SelloutFactorU*******'+complist[idx].SelloutFactorU);
                          //console.log('skywrap*******'+skywrap);
                          
                  var selloutp = skywrap*cfw.maximum + (skywrap*cfw.maximum*complist[idx].SelloutFactorU/100);
                          console.log('selloutp*******'+selloutp);
                  complist[idx].sellOutPriceU=selloutp;
                  complist[idx].selloutTypeU=item.Type__c;
                  complist[idx].GMU=0;
                  cmp.set('v.compList',complist);
                  
                      }
                  });
                  
                  
                  
          
          if(flag == false){
          var action = cmp.get('c.getReplacementCost');
          action.setParams({
              skuid:complist[idx].pbd_id
          });
          action.setCallback(this, function(response) {
              var state = response.getState();
              if (state === "SUCCESS") {
                  //var gm;var skywrap;
                  rep = response.getReturnValue();
                  //var cfw = cmp.get('v.cfWrap');
                  skywrap = parseFloat(complist[idx].unt_prc_u);
                  gm = (skywrap*cfw.minimum*0.96-rep)/(skywrap*cfw.minimum*0.96);
                  console.log('GM %',gm,rep,skywrap,typeof cfw);
                  if(skywrap==0||skywrap==null||skywrap==undefined){
                      gm=0;
                  }
                  gm = Math.round(gm*100);
                  //var type;
                  if(gm>=60){
                      type = 'Gold';
                  }else if(gm<60&&gm>=40){
                      type = 'A';
                  }else if(gm<40&&gm>=20){
                      type = 'B';
                  }else{
                      type = 'C';
                  }
                  //var smat = cmp.get('v.selloutMatrix');
                  smat.forEach(function(item){
                      if(item.Type__c==type){
                          complist[idx].SelloutFactorU=item.Sell_Out_Factor__c;
                          complist[idx].MinPriceFactorU=item.Min_Price_Factor__c;
                          
                      }
                  });
                  complist[idx].unt_prc_u=complist[idx].unt_prc_u.replace(/,/g, '.');
                  var minprice=complist[idx].unt_prc_u-complist[idx].unt_prc_u*complist[idx].MinPriceFactorU/100;
                  complist[idx].min_prc_u=Math.round(minprice).toString();
                  var selloutp = skywrap*cfw.maximum + (skywrap*cfw.maximum*complist[idx].SelloutFactorU/100);
                  complist[idx].sellOutPriceU=selloutp;
                  complist[idx].selloutTypeU=type;
                  complist[idx].GMU=gm;
                  cmp.set('v.compList',complist);
              }
          });
           $A.enqueueAction(action);
          }
         
      },
      //Added by Krishanu & Ankita @Wipro
    /*  handleUnitPriceKitUS:function(cmp, event, helper){
          var currtype = cmp.get("v.priceBookDetails.curncy");
          var complist = cmp.get("v.compList");
          var idx = event.getSource().get("v.label");
          console.log(idx,complist);
          var action = cmp.get('c.getReplacementCost');
          action.setParams({
              skuid:complist[idx].pbd_id
          });
          action.setCallback(this, function(response) {
              var state = response.getState();
              if (state === "SUCCESS") {
                  var gm;var skywrap;
                  var rep = response.getReturnValue();
                  var cfw = cmp.get('v.cfWrap');
                  skywrap = parseFloat(complist[idx].unt_prc_u);
                  gm = (skywrap*cfw.minimum*0.96-rep)/(skywrap*cfw.minimum*0.96);
                  console.log('GM %',gm,rep,skywrap,typeof cfw);
                  if(skywrap==0||skywrap==null||skywrap==undefined){
                      gm=0;
                  }
                  gm = Math.round(gm*100);
                  var type;
                  if(gm>=60){
                      type = 'Gold';
                  }else if(gm<60&&gm>=40){
                      type = 'A';
                  }else if(gm<40&&gm>=20){
                      type = 'B';
                  }else{
                      type = 'C';
                  }
                  var smat = cmp.get('v.selloutMatrix');
                  smat.forEach(function(item){
                      if(item.Type__c==type){
                          complist[idx].SelloutFactorU=item.Sell_Out_Factor__c;
                          complist[idx].MinPriceFactorU=item.Min_Price_Factor__c;
                          
                      }
                  });
                  var minprice=complist[idx].unt_prc_u-complist[idx].unt_prc_u*complist[idx].MinPriceFactorU/100;
                  complist[idx].min_prc_u=Math.round(minprice).toString();
                  var selloutp = skywrap*cfw.maximum + (skywrap*cfw.maximum*complist[idx].SelloutFactorU/100);
                  complist[idx].sellOutPriceU=selloutp;
                  complist[idx].selloutTypeU=type;
                  complist[idx].GMU=gm;
                  cmp.set('v.compList',complist);
              }
          });
          $A.enqueueAction(action);
      }*/
  
})