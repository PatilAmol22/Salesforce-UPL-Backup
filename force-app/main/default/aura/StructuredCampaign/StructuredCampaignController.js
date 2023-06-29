({    
    scriptsLoaded : function(component, event, helper) {
        //console.log('Script loaded..');
        //$('#csvTable').DataTable();
       if ( ! $.fn.DataTable.isDataTable( '#csvTable' ) ) {
           // $("#csvTable").dataTable();
          
          }
          else{
            location.reload(true);
          }
        
    },
    
    doInit : function(component, event, helper){
        
        var recordId = component.get("v.recordId"); 
        var price_book_checkbox = component.get("v.Price_Book_For_Campaign");
        
        var pbType=component.get("v.priceBookType");
        //alert('hello'+price_book_checkbox+pbType);
       //alert('price_book_checkbox----->'+component.get("v.priceBookType"));
        /*
added by nikhil : on-22-3-2019*/

if(price_book_checkbox){
    
    //var currecny = component.find("checkbox-id-01").get("v.value"); 
    //var isChecked = component.find("radi2").get("v.checked");
    //alert(price_book_checkbox);
    component.set("v.hide1","true");
    component.set("v.pb_for_campaign",true);
        component.set("v.campaignType","Structured");
        component.find("radio2").set("v.checked", true);
    if(pbType){
    component.find("checkbox-id-01").set("v.value", pbType);
    }
        helper.loadPaymentTerms(component);
    }
    else{
        
        component.set("v.hide1","false");
       //component.set("v.hide2","false");
        //component.set("v.hide3","false");
        //component.set("v.hide4","true");
        //component.set("v.hide5","true");
        //component.set("v.hide6","true");
        //component.set("v.hide7","true");
        
        component.set("v.pb_for_campaign",false);
      
        component.set("v.campaignType","Simple");

        if(pbType!=null && pbType!=''){
            //alert(pbType);
        component.find("checkbox-id-01").set("v.value", pbType);
        }
    }

       

//console.log('doInit record id--->');
        //console.log(recordId);
        
        var Today = new Date();
            var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();
            var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
            var yyyy = Today.getFullYear();
            
            component.set("v.today", yyyy + "-" + MM + "-" + dd);
        	//console.log("today--->"+component.get('v.today'));
        
        if (typeof recordId != "undefined"){
            
            //console.log('Record Existed--->');
            
            component.set("v.isbtndisable", true);
            component.set("v.isSavebtnHide", false);
            component.set("v.isEdit", true);
            // helper.editPriceBook(component);
            helper.reloadPriceBook(component);
            
        }else if(typeof recordId == "undefined"){
            //console.log('New Record--->');
            
            //component.find("searchUtil").set("v.disabled",false);
            
            component.set("v.isSavebtnHide", true);
            component.set("v.isbtndisable", false);
            component.set("v.isEdit", false);
            helper.loadSKUDescription(component,event);
        }
        //helper.loadSKUDescription(component,event);
        
    },
    
    //generalized function to remove invalid chars like@# -
    handleInvalidChars:function(component, event, helper){
        var target = event.getSource();  
        var val = target.get("v.value");
        var nm = target.get("v.name");
       // val = val.replace('-','').trim();
       	//console.log("nm--> "+nm);
        //console.log("val--> "+val);
        val=val.replace(/[^a-zA-Z0-9, ]/,'').replace(/([a-zA-Z ])/g,'').trim();
       
        component.find(nm).set("v.value",val);
    },

    //Date validation From Date
    validateDate: function(component, event, helper){
        // var test=component.find("options").get("v.value");
        
        var val=event.getSource().get('v.value');
        
        var Today = new Date();
        var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();
        var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
        var yyyy = Today.getFullYear();
        var currentDt = (yyyy + "-" + MM + "-" + dd);
        
        if(val < currentDt){ 
            event.getSource().focus();
            component.set("v.hide9",true);
        }
        else{
            component.set("v.hide9",false);
        }
        
    },
    
    //Date validation To Date
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
            event.getSource().focus();
            component.set("v.hide10",true);
        }
        else{
            component.set("v.hide10",false);
        }
    },
    
    //Date validation Interest Date
    validateDate3: function(component, event, helper){
        // var test=component.find("options").get("v.value");
        var val=event.getSource().get('v.value');
        
        var Today = new Date();
        var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();
        var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
        var yyyy = Today.getFullYear();
        var currentDt = (yyyy + "-" + MM + "-" + dd);
        
        if(val < currentDt){ 
            event.getSource().focus();
            component.set("v.hide11",true);
        }
        else{
            component.set("v.hide11",false);
        }
    },
    
    //Date validation Block Date
    validateDate4: function(component, event, helper){
        // var test=component.find("options").get("v.value");
        var val=event.getSource().get('v.value');
        var frm_dt=component.find("validfrmId").get("v.value");
        var Today = new Date();
        var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();
        var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
        var yyyy = Today.getFullYear();
        var currentDt = (yyyy + "-" + MM + "-" + dd);
        
        if(val < currentDt ){ 
          //  event.getSource().focus();
            component.set("v.hide15",true);
        }
        else{
            component.set("v.hide15",false);
        }
     },
    
    //To fetch values from Payment-Terms Master
    getPaymentTerms : function(component, event, helper){
        
        helper.loadPaymentTerms(component);
        
    },
    
    //Called from Import button to Process CSV
    handleImport: function(component, event, helper){
        // var test=component.find("options").get("v.value");
        component.set("v.showSpinner",true);
         var matList = component.get("v.materialDetails");
        //console.log("matList--> "+JSON.stringify(matList));
        
        try{
            
            var fileInput = component.find("csvFile").getElement();
            var file = fileInput.files[0];
            var fileName;
            var fileExtension;
            
            if(file) {
              fileName= file.name;
              fileExtension = fileName.split('.').pop();
            } 
            
                     
          if(!file){
              //console.log("csvFile missing")
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
            else if(fileExtension!="csv"){              
             var toastEvent1 = $A.get("e.force:showToast");
              var msg  = $A.get("{!$Label.c.Wrong_file_format}");""//$A.get("{!$Label.c.Please_choose_a_file}");
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
              
              // //console.log("File");
              var reader = new FileReader();
              reader.readAsText(file, "UTF-8");
              reader.onload = function (evt) {
                  ////console.log("EVT FN");
                  var csv = evt.target.result;
                  //  //console.log('@@@ csv file contains'+ csv);
                  var result = helper.CSV2JSON(component,csv);
                  //component.find("currencyID").set("v.disabled",true);
                  //  //console.log('@@@ result = ' + result);
                  ////console.log('@@@ Result = '+JSON.parse(result));
                  // helper.CreateAccount(component,result);
                  
              }
              reader.onerror = function (evt) {
                  //console.log("error reading file");
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
          
      }catch(e){
          alert(e);
          component.set("v.showSpinner",false);
      } 
    },
    
    //Not in Use
    updateColumnSorting: function(component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },
    
    //Not in Use
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
        
        //console.log('validfrmDt-->'+validfrmDt);
        if(validfrmDt == ''){
            //console.log('validfrmDt-->'+validfrmDt);
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
    
    //To add Payment Terms
    handlePaymntTermAdd: function(component, event, helper){
        //console.log('onSelectedPayAdd called......');
        
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
                        //console.log(paySet);
                        
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
                    //console.log(paySet);  
                    component.set('v.paymentTermsWrapper', payObjs);   
                    return true;
                }
            }
        }
    },
    
    //To add Payment terms by Date
    handlePaymntDateAdd: function(component, event, helper){
        //console.log('onSelectedPayDateAdd called......');
        
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
            var titl  = $A.get("{!$Label.c.Error}");
            toastEvent4.setParams({
                "title": titl,
                "type": "error",
                "message": msg,
                "duration":'3000'
            });
            toastEvent4.fire(); 
                return false;
            }
            
            if(payObjs.length == 0){
                
                obj2.pt_name=val;
                obj2.pt_type='date';
                payObjs.push(obj2);  
                paySet.push(val);
            }
            else{
                //console.log(paySet);
                
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
            //console.log(paySet);  
            component.set('v.paymentTermsWrapper', payObjs); 
        }
    },
    
    //To Delete Payment terms in create and edit mode of the Price Book
    deletePaymntTrm : function(component, event, helper){
        // alert('deleteSku called');
        
        var target = event.getSource();  
        var index = target.get("v.value");
        var id = target.get("v.name");
        
        if(id){
            //console.log("Inside paymentTermsToDelete");
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
    
    //To toggle discount input visibility on No Discount Checkbox
    handleGroupDiscountCheck : function(component, event, helper){
        
        var dicount_given = component.find("dicount_given").get("v.checked");
        var ltd_vol_no = component.find("ltd_vol_no").get("v.checked");
        var ltd_vol_yes = component.find("ltd_vol_yes").get("v.checked");
        //component.find("ltd_vol_no").get("v.checked");
        
        //console.log("dicount_given--> "+dicount_given+' --> '+ltd_vol_yes+' --> '+ltd_vol_no);
        if((dicount_given== false && ltd_vol_no==true) &&(dicount_given== false && ltd_vol_yes==false)){
            component.set("v.hide13",true);
        }
        else{
            component.set("v.hide13",false);
            component.set("v.groupObj.Group_Discount__c",0);
        }
        
        
    },
    
    //To toggle discount input visibility on Limited Volume Radio buttons
    handleLtdVol : function(component, event, helper){
        var ltdVolCheck = event.getSource().get("v.value");
        //console.log("inside limited volume -->1"+ltdVolCheck);
        if(ltdVolCheck=='Yes'){ 
            component.find("ltd_vol_no").set("v.checked",false);
            component.find("dicount_given").set("v.checked",true);
            //console.log("inside limited volume -->2"+ltdVolCheck);
            component.set("v.groupObj.Limited_volume__c",true);
            component.set("v.groupObj.Group_Discount__c",0);
            component.set("v.hide13",false);    
            //console.log("v.groupObj.Limited_volume__c-->",component.get("v.groupObj.Limited_volume__c"));
        }
        else{
            component.find("ltd_vol_yes").set("v.checked",false);
             //console.log("inside limited volume -->3"+ltdVolCheck);
            if(!component.find("dicount_given").get("v.checked")){
                component.set("v.hide13",true);
            }
            component.set("v.groupObj.Limited_volume__c",false); 
        }
        
    },
    
    //To toggle Subgroups input visibility on Will have subgroup of products? Radio buttons
    handleSubGrpRequired : function(component, event, helper){
        var subGrpRequired = event.getSource().get("v.value");
        //console.log("inside subGrpRequired -->"+subGrpRequired);
        if(subGrpRequired =='Yes'){
            component.set("v.groupObj.Will_you_have_a_sub_product_group__c","Yes");
            component.set("v.hide14","true");
        }   
        else{
            component.set("v.groupObj.Will_you_have_a_sub_product_group__c","No");
            component.set("v.groupObj.Required_sub_group_Qty__c",0);  
            component.set("v.hide14","false");
        }
    },
    
    //Group Validation/Save/Edit functionality
    handleSaveGrp :function(component, event, helper){
        var groupList = component.get("v.groupWrapperList");
        var groupObj = component.get("v.groupObj");
        var grpSet = component.get("v.groupSet") || new Set();
        var isValid = true;
        
        var editedRow = new Object();
        
        //console.log("groupObj inside handleSaveGrp --> "+JSON.stringify(groupObj));
        
        var grpIndex = component.get("v.groupIndex");
        
        if(isNaN(groupObj.Name_of_the_group__c) || groupObj.Name_of_the_group__c.length ==0 ){
            //console.log('Group Name is valid --> '+isValid);
            component.find("grp_Name").set('v.validity', {valid:false, badInput :true});
            component.find("grp_Name").showHelpMessageIfInvalid();
            isValid=false;
            //return false;
        }
        
        //console.log('Before Save Group Error toast--> '+groupObj.Will_you_have_a_sub_product_group__c+'groupObj.Required_sub_group_Qty__c--> '+groupObj.Required_sub_group_Qty__c);
        if(groupObj.Will_you_have_a_sub_product_group__c=="Yes" && 
           (groupObj.Required_sub_group_Qty__c == 0 || groupObj.Required_sub_group_Qty__c == undefined ))
        {	
            //console.log('Inside Save Group Error toast');
           var toastEvent = $A.get("e.force:showToast");
            var msg  =$A.get("{!$Label.c.Subgroup_quantity_cannot_be_0_or_blank}"); 
            var titl  = $A.get("{!$Label.c.Error}");
            toastEvent.setParams({
                "title": titl,
                "type": "error",
                "message": msg,
                "duration":'3000'
            });
            toastEvent.fire();
            isValid=false;
            return false;
        }
        
        if(isValid==true){
            //console.log("isValid--> "+isValid)
            //console.log("grpIndex ===> "+grpIndex);
            if(grpIndex != -1 ){
                
                //console.log("Inside Edited If-- >"+grpIndex);            
                editedRow = groupList[grpIndex];
                
                //alert((groupObj.Name_of_the_group__c).length);
                if(groupObj.Name_of_the_group__c.length==1){
                editedRow.grp_name="00"+ groupObj.Name_of_the_group__c;    
                }
                else if(groupObj.Name_of_the_group__c.length==2){
                editedRow.grp_name="0"+ groupObj.Name_of_the_group__c;    
                }
                else{
                  editedRow.grp_name= groupObj.Name_of_the_group__c;      
                }
                
                editedRow.grp_desc= groupObj.Group_Description__c;
                editedRow.discount= groupObj.Group_Discount__c;
                editedRow.subgrp_qty_required= groupObj.Required_sub_group_Qty__c;
                editedRow.dicount_given= groupObj.Do_not_generate_group_discount__c;
                editedRow.subgrp_required= groupObj.Will_you_have_a_sub_product_group__c;
                if(groupObj.Limited_volume__c == true){
                    editedRow.limited_vol= "Yes";//groupObj.Limited_volume__c;
                }
                else{
                    editedRow.limited_vol= "No"; 
                }
                groupList[grpIndex] = editedRow;
            }
            
            else{
                var obj = new Object();
            /*var obj= {
            grp_name:"name1",
            grp_desc:"desc1",
            discount:"10"
        	}*/
            //groupList.push(obj);
            //alert(groupObj.Name_of_the_group__c.length);
            if(groupObj!= undefined || groupObj!=null){
                //console.log("Group Name inside Save---> "+obj.grp_name)
                if(groupObj.Name_of_the_group__c.length==1){
                obj.grp_name="00"+ groupObj.Name_of_the_group__c;    
                }
                else if(groupObj.Name_of_the_group__c.length==2){
                obj.grp_name="0"+ groupObj.Name_of_the_group__c;    
                }
                else{
                  obj.grp_name= groupObj.Name_of_the_group__c;      
                }
                //obj.grp_name= groupObj.Name_of_the_group__c;
                obj.grp_desc= groupObj.Group_Description__c;
                obj.discount= groupObj.Group_Discount__c;
                obj.subgrp_qty_required= groupObj.Required_sub_group_Qty__c;
                obj.dicount_given= groupObj.Do_not_generate_group_discount__c;
                obj.subgrp_required= groupObj.Will_you_have_a_sub_product_group__c;
                if(groupObj.Limited_volume__c == true){
                    obj.limited_vol= "Yes";//groupObj.Limited_volume__c;
                }
                else{
                    obj.limited_vol= "No"; 
                }
                 
                /*function grpPresent(){
                    return(groupObj.Name_of_the_group__c);
                }
                grpPresent();
                ////console.log("grpPresent --> "+grpSet.find(grpPresent));
                */
                var isDuplicate = findKey(obj.grp_name,groupList);
                //console.log("isDuplicate ==>  "+isDuplicate);
                
                if(isDuplicate!= true){
                groupList.push(obj);
                // grpSet.push(groupObj.Name_of_the_group__c);
                component.set("v.groupSet",grpSet);
                //console.log("grpSet===> "+JSON.stringify(grpSet));
                //console.log("groupList--> "+JSON.stringify(groupList));
                }
                else{
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
                    return false;
                    
                }
            }
        }
            
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
                            var msg  = $A.get("{!$Label.c.Invalid_Input}");
                            var titl  = $A.get("{!$Label.c.Error}");
                            toastEvent.setParams({
                                "title": titl,
                                "type": "error",
                                "message": msg,
                                "duration":'3000'
                            });
                            toastEvent.fire();
                    return false;            
        }
        
        //console.log("typeof(groupList)==>"+typeof(groupList));
        //console.log("typeof(groupObj)==>"+typeof(groupObj));
        component.set("v.groupWrapperList",groupList);
        component.set("v.groupIndex",-1);
        component.set("v.isOpen", false);
        component.set("v.hide13",false);
        component.set("v.hide14",false);
        console.log("Group Obj"+JSON.stringify(component.get("v.groupObj")));
        component.set("v.groupObj",{'sobjectType':'Campaign_Group__c',
                                    'Name_of_the_group__c':'',
                                    'Campaign__c':'',
                                    'Group_Discount__c':0,
                                    'Limited_volume__c':false,
                                    'Do_not_generate_group_discount__c':true,
                                    'Will_you_have_a_sub_product_group__c':'No',
                                    'Required_sub_group_Qty__c':0});
        
        function findKey(key, JSONObj) { //method to find key in JSON
            //console.log(JSON.parse(JSON.stringify(JSONObj)));
            var JSON2 = JSON.parse(JSON.stringify(JSONObj));
            for (var i = 0; i < JSON2.length; i++) {
                if(JSON2[i].grp_name == key){
					//console.log("inside find key");                    
                    return true;                    
                    
                }
                /*//console.log(JSON.stringify(JSONObj[i]).indexOf(key))
                if (JSON.stringify(JSONObj[i]).indexOf(key) >= 0) {
                    return true;
                }*/
                
            }
        }
        return true;
        
    },
    
    //Group Edit functionality\ passing group index for handleSaveGrp
    handleEditGroup : function(component, event, helper){
        
        var target = event.getSource();  
        var index = target.get("v.value");
        var id = target.get("v.name");
        //console.log("target -->"+target+" index -->  "+index+" id -->  "+id);
        
        component.set("v.isOpen",true);
        component.set("v.groupIndex",index);
        
        var grpList = new Array();
        grpList =  component.get("v.groupWrapperList");
        var grpRow = grpList[index];
        //console.log("grpRow inside handle Edit --> "+JSON.stringify(grpRow));
        
        component.set("v.groupObj",{//'sobjectType':'Campaign_Group__c',
            'Name_of_the_group__c':grpRow.grp_name,
            'Group_Description__c':grpRow.grp_desc,
            'Group_Discount__c':grpRow.discount,
            'Required_sub_group_Qty__c':grpRow.subgrp_qty_required,
            'Do_not_generate_group_discount__c':grpRow.dicount_given,
            'Will_you_have_a_sub_product_group__c':grpRow.subgrp_required
            //'Limited_volume__c':grpRow,
        });
        
        if(grpRow.discount!=0 || grpRow.discount!=''){
            component.find("dicount_given").set("v.checked",false);
            component.set("v.hide13",true);
        }
        if(grpRow.subgrp_required=="Yes"){
            component.set("v.hide14",true);
            component.find("sub_grp_req_yes").set("v.checked",true);
            component.find("sub_grp_req_no").set("v.checked",false);
        }
        else{
            component.set("v.hide14",false);
            console.log("grpRow.subgrp_required==No");
            component.find("sub_grp_req_no").set("v.checked",true);
            component.find("sub_grp_req_yes").set("v.checked",false);
            
        }
        
        if(grpRow.limited_vol=="Yes"){
            //console.log("grpRow.limited_vol-->"+grpRow.limited_vol);
            component.find("ltd_vol_no").set("v.checked",false);  
            component.find("ltd_vol_yes").set("v.checked",true);
            
        }
        else{
          console.log("No grpRow.limited_vol-->"+grpRow.limited_vol);
          component.find("ltd_vol_no").set("v.checked",true);		
          console.log("After grpRow.limited_vol-->"+grpRow.limited_vol);  		
          component.find("ltd_vol_yes").set("v.checked",false);
        }
        //console.log("grpRow==>"+JSON.stringify(component.get("v.groupObj")));       
        
        
    },
    
    //Group Delete functionality
    handleDeleteGrp : function(component, event, helper){
        //console.log("inside delete group");
        var target = event.getSource();  
        var index = target.get("v.value");
        var oldGrpList = component.get("v.groupWrapperList");
        oldGrpList.splice(index,1);
        component.set("v.groupWrapperList",oldGrpList);
    },
    
    //toggle value of simulator_upload attribute on Simulator upload change
    handleSimRadio : function(component, event, helper){
        var simulator_upload = event.getSource().get("v.value");
        //console.log("simulator_upload-->"+simulator_upload)
        if(simulator_upload=="Yes"){
            component.set("v.simulator_upload",true);  
        }
        else{
            component.set("v.simulator_upload",false);  
        }
    },
    
    //On Price book save/ Validations / Calls createPriceBook of helper on ALL OK
    handlePriceBookSave : function(component, event, helper){
        //console.log("Inside Handle Save ==>");
        component.set("v.showSpinner",true);
        var priceBook = component.get("v.priceBookDetails"); //{};
        //console.log(priceBook);
        var pb_cmpgn=component.get("v.pb_for_campaign");
        var cmpgn_tp = '';
        var blk_dt='';
        var intr_dt='';
        var obj = new Object();
        var isValid=true;
        var isPriceBookvalid=true;
        var groupArray=[];
        var Lastgroup= component.get("v.Lastgroup");
        //console.log('Lastgroup :-'+Lastgroup);
        
        if(pb_cmpgn){
            cmpgn_tp=component.get("v.campaignType");
        }
        
        var pb_nm = component.find("pb_name").get("v.value");
        //console.log("pb_nm--> "+pb_nm);
        var frmDt = $A.localizationService.formatDate(component.get("v.frmDate"), "yyyy-MM-dd");//component.find("validfrmId").get("v.value");       
        var toDt = $A.localizationService.formatDate(component.get("v.toDate"), "yyyy-MM-dd");
        if(pb_cmpgn){
            blk_dt= $A.localizationService.formatDate(component.get("v.blockDate"), "yyyy-MM-dd");//component.find("blck_dt").get("v.value");
            intr_dt = $A.localizationService.formatDate(component.get("v.intrDate"), "yyyy-MM-dd"); //component.find("intr_dt").get("v.value");
        }
        var intr_R = component.get("v.PriceBook.Interest_Rate_R__c");//component.find("int_rate_R").get("v.value");
        var intr_U = component.get("v.PriceBook.Interest_Rate_U__c");//component.find("int_rate_U").get("v.value");
        //console.log("intr_R -->"+intr_R+" intr_U -->"+intr_U);
        var mgr_discount = component.get("v.mgr_discount");
        var simulator_upload = component.get("v.simulator_upload");
        
        var material_wrapper = component.get("v.materialDetails");
        var paymntTerm_wrapper = component.get('v.paymentTermsWrapper');
        var grp_wrapper = component.get("v.groupWrapperList");
        var salesDistrict_wrapper = component.get("v.salesdtarr");
        
        if(!pb_nm || pb_nm.trim().length==0){
            //console.log('pb_nm isValid '+isValid);
            component.find("pb_name").set('v.validity', {valid:false, badInput :true});
            component.find("pb_name").showHelpMessageIfInvalid();
            component.find("pb_name").focus();
            
            var toastEvent = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.You_must_enter_a_name}");
                var titl  = $A.get("{!$Label.c.Warning}");
                toastEvent.setParams({
                    "title": titl,
                    "type": "warning",
                    "message": msg,
                    "duration":'3000'
                });
            
            toastEvent.fire();
            
            isValid=false;
            isPriceBookvalid=false;
        }        
        if(frmDt == 'Invalid Date' || !frmDt){
            //console.log('frmDt isValid '+isValid);
            // component.find("validfrmId").set("v.errors", [{message: "Select Date."}]);
            // $A.util.addClass(component.find("validfrmId"), 'slds-has-error');
            isValid=false;
            isPriceBookvalid=false;
            component.find("validfrmId").set('v.validity', {valid:false, badInput :true});
            component.find("validfrmId").showHelpMessageIfInvalid();
        }
        if(toDt == 'Invalid Date' || !toDt){
            //console.log('toDt isValid '+isValid);
            // component.find("expiryId").set("v.errors", [{message: "Select Date."}]);
            // $A.util.addClass(component.find("expiryId"), 'slds-has-error');
            isValid=false;
            isPriceBookvalid=false;
            component.find("expiryId").set('v.validity', {valid:false, badInput :true});
            component.find("expiryId").showHelpMessageIfInvalid();
        }
        if(!intr_R){
            //console.log('intr_R isValid '+intr_R+' '+isValid);
            component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
            component.find("int_rate_R").showHelpMessageIfInvalid();
            isValid=false;
            isPriceBookvalid=false;
        }
        if(!intr_U){
            //console.log('intr_U isValid '+isValid);
            component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
            component.find("int_rate_U").showHelpMessageIfInvalid();
            isValid=false;
            isPriceBookvalid=false;
        }
        /*if(!mgr_discount){
            //console.log('mgr Discount isValid '+isValid);
            component.find("mgr_discount").set('v.validity', {valid:false, badInput :true});
            component.find("mgr_discount").showHelpMessageIfInvalid();
            isValid=false;
            isPriceBookvalid=false;
        }*/
        if(material_wrapper.length==0){
            
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
            
            //console.log('cmpgn_tp '+cmpgn_tp);
            //console.log('blk_dt '+blk_dt);
            if(!cmpgn_tp){
                
                var toastEvent3 = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Please_select_Campaign_Type}");
                var titl  = $A.get("{!$Label.c.Error}");
                toastEvent3.setParams({
                    "title": titl,
                    "type": "error",
                    "message": msg,
                    "duration":'3000'
                });
                toastEvent3.fire();
                
                isValid=false;
                isPriceBookvalid=false;
            }
            else if(intr_dt == 'Invalid Date' || !intr_dt){
                //console.log('intr_dt isValid '+isValid);
                component.find("intr_dt").set('v.validity', {valid:false, badInput :true});
                component.find("intr_dt").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
                else if(blk_dt == 'Invalid Date' || !blk_dt){
                    
                    component.find("blockDateId").set('v.validity', {valid:false, badInput :true});
                    component.find("blockDateId").showHelpMessageIfInvalid();
                    isValid=false;
                    isPriceBookvalid=false;
                }
                    else if(paymntTerm_wrapper.length == 0){
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
            		
                        else if(salesDistrict_wrapper.length == 0 || salesDistrict_wrapper=="undefined"){
                            //console.log("Inside Sales District Empty==>");
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
                            component.find("tabs").set("v.selectedTabId","one");
                            isValid=false;
                            isPriceBookvalid=false;
                        }
/********************************/
       
else if(salesDistrict_wrapper.length > 0){
            
            var duplicateval = component.get("v.showduplicateErr");
                            
            for(var i = 0 ;i<salesDistrict_wrapper.length;i++){
                for(var j = i+1 ;j<salesDistrict_wrapper.length;j++){
                    
                    var nameOfSD = salesDistrict_wrapper[i].Name;
                    if(typeof nameOfSD == "undefined"){
                        component.set("v.showErrOnDiv", true);
                        isValid = false;
                    }else{
                        //console.log('arrOfSalesdist[i].Name'+salesDistrict_wrapper[i].Name);
                        if(salesDistrict_wrapper[i].Name != null || salesDistrict_wrapper[i].Name != ''){
                            if(salesDistrict_wrapper[i].Name == salesDistrict_wrapper[j].Name){
                                component.set("v.showduplicateErr", true);
                                isValid = false;
                            }     
                        }
                    }
                }
            }
            
            if(!duplicateval){
                for(var i = 0 ;i<salesDistrict_wrapper.length;i++){
                    if(salesDistrict_wrapper[i].Name == null){
                        component.set("v.showErrOnDiv", true);
                        isValid = false;
                    }else{
                        component.set("v.showErrOnDiv", false);
                    }
                }
            }
        }            
            
            
            /********************************/
               
        }
        else{
            cmpgn_tp='';
            blk_dt='';
            intr_dt='';
            
        }
        
        if(isValid){
            
            obj.pb_for_cmpgn = pb_cmpgn;
            obj.cmpgn_tp = cmpgn_tp;
            obj.pb_name = pb_nm;
            //obj.curncy=currency;
            obj.frm_dt = frmDt;
            obj.exp_dt = toDt;
            obj.intr_rt_R = intr_R;
            obj.intr_rt_U = intr_U;
            obj.intr_dt = intr_dt;
            //obj.division=divsn;
            obj.blk_dt = blk_dt;
            obj.mgr_Discount = mgr_discount;
            obj.simulator_upload = simulator_upload;
            
            priceBook=obj;
            //console.log('grp_wrapper :-'+grp_wrapper.length);
            for(var n=0;n<Lastgroup.length;n++){
                groupArray.push(Lastgroup[n]);
            }
            
            //console.log('groupArray :-'+groupArray.length);
            var grpNameArray=[];
            var grpInMaterials=[];
            if(groupArray.length==grp_wrapper.length){
                //console.log('groupArray :-'+groupArray);
                for(var m=0;m<grp_wrapper.length;m++){
                    grpNameArray.push(grp_wrapper[m].grp_name);
                }
                
                function compareArrays(arr1, arr2) {
                    return $(arr1).not(arr2).length == 0 && $(arr2).not(arr1).length == 0;
                }
    
                if(compareArrays(groupArray,grpNameArray)){
                //console.log('Group Number Matched');
                helper.createPriceBook(component, event, helper, priceBook,grp_wrapper, material_wrapper, paymntTerm_wrapper,salesDistrict_wrapper);
                }
                else{
                //console.log('Group Number Not Matched');
                var toastEvent4 = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Group_numbers_didn_t_match_in_materials}");
                var titl  = $A.get("{!$Label.c.Warning}");
                toastEvent4.setParams({
                    "title": titl,
                    "type": "warning",
                    "message": msg,
                    "duration":'3000'
                });
                toastEvent4.fire();
                component.find("tabs").set("v.selectedTabId","one");
                isValid=false;
                isPriceBookvalid=false;
                component.set("v.showSpinner",false);
                }
                
            }else {
                //console.log('Group Number Not Matched');
                var toastEvent4 = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Group_numbers_didn_t_match_in_materials}");
                var titl  = $A.get("{!$Label.c.Error}");
                toastEvent4.setParams({
                    "title": titl,
                    "type": "error",
                    "message": msg,
                    "duration":'3000'
                });
                toastEvent4.fire();
                component.find("tabs").set("v.selectedTabId","one");
                isValid=false;
                isPriceBookvalid=false;
                component.set("v.showSpinner",false);
            }
            
            
            //console.log('Price book '+priceBook);
            //alert(priceBook);
        }
        else{
            component.set("v.showSpinner",false);
        }
        
        
    },
        
     //On Save and Submit
    handleSaveAndSubmit : function(component, event, helper){
        
        console.log("Inside Handle Save ==>");
        component.set("v.showSpinner",true);
        var priceBook = component.get("v.priceBookDetails"); //{};
        console.log(priceBook);
        var pb_cmpgn=component.get("v.pb_for_campaign");
        var cmpgn_tp = '';
        var blk_dt='';
        var intr_dt='';
        var obj = new Object();
        var isValid=true;
        var isPriceBookvalid=true;
        var groupArray=[];
        var Lastgroup= component.get("v.Lastgroup");
        console.log('Lastgroup :-'+Lastgroup);
        
        if(pb_cmpgn){
            cmpgn_tp=component.get("v.campaignType");
        }
        
        var pb_nm = component.find("pb_name").get("v.value");
        console.log("pb_nm--> "+pb_nm);
        var frmDt = $A.localizationService.formatDate(component.get("v.frmDate"), "yyyy-MM-dd");//component.find("validfrmId").get("v.value");       
        var toDt = $A.localizationService.formatDate(component.get("v.toDate"), "yyyy-MM-dd");
        if(pb_cmpgn){
            blk_dt= $A.localizationService.formatDate(component.get("v.blockDate"), "yyyy-MM-dd");//component.find("blck_dt").get("v.value");
            intr_dt = $A.localizationService.formatDate(component.get("v.intrDate"), "yyyy-MM-dd"); //component.find("intr_dt").get("v.value");
        }
        var intr_R = component.get("v.PriceBook.Interest_Rate_R__c");//component.find("int_rate_R").get("v.value");
        var intr_U = component.get("v.PriceBook.Interest_Rate_U__c");//component.find("int_rate_U").get("v.value");
        console.log("intr_R -->"+intr_R+" intr_U -->"+intr_U);
        var mgr_discount = component.get("v.mgr_discount");
        var simulator_upload = component.get("v.simulator_upload");
        
        var material_wrapper = component.get("v.materialDetails");
        var paymntTerm_wrapper = component.get('v.paymentTermsWrapper');
        var grp_wrapper = component.get("v.groupWrapperList");
        var salesDistrict_wrapper = component.get("v.salesdtarr");
        
        if(!pb_nm || pb_nm.trim().length==0){
            console.log('pb_nm isValid '+isValid);
            component.find("pb_name").set('v.validity', {valid:false, badInput :true});
            component.find("pb_name").showHelpMessageIfInvalid();
            component.find("pb_name").focus();
            
            var toastEvent = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.You_must_enter_a_name}");
                var titl  = $A.get("{!$Label.c.Warning}");
                toastEvent.setParams({
                    "title": titl,
                    "type": "warning",
                    "message": msg,
                    "duration":'3000'
                });
            
            toastEvent.fire();
            
            isValid=false;
            isPriceBookvalid=false;
        }        
        if(frmDt == 'Invalid Date' || !frmDt){
            console.log('frmDt isValid '+isValid);
            // component.find("validfrmId").set("v.errors", [{message: "Select Date."}]);
            // $A.util.addClass(component.find("validfrmId"), 'slds-has-error');
            isValid=false;
            isPriceBookvalid=false;
            component.find("validfrmId").set('v.validity', {valid:false, badInput :true});
            component.find("validfrmId").showHelpMessageIfInvalid();
        }
        if(toDt == 'Invalid Date' || !toDt){
            console.log('toDt isValid '+isValid);
            // component.find("expiryId").set("v.errors", [{message: "Select Date."}]);
            // $A.util.addClass(component.find("expiryId"), 'slds-has-error');
            isValid=false;
            isPriceBookvalid=false;
            component.find("expiryId").set('v.validity', {valid:false, badInput :true});
            component.find("expiryId").showHelpMessageIfInvalid();
        }
        if(!intr_R){
            console.log('intr_R isValid '+intr_R+' '+isValid);
            component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
            component.find("int_rate_R").showHelpMessageIfInvalid();
            isValid=false;
            isPriceBookvalid=false;
        }
        if(!intr_U){
            console.log('intr_U isValid '+isValid);
            component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
            component.find("int_rate_U").showHelpMessageIfInvalid();
            isValid=false;
            isPriceBookvalid=false;
        }
        /*if(!mgr_discount){
            console.log('mgr Discount isValid '+isValid);
            component.find("mgr_discount").set('v.validity', {valid:false, badInput :true});
            component.find("mgr_discount").showHelpMessageIfInvalid();
            isValid=false;
            isPriceBookvalid=false;
        }*/
        if(material_wrapper.length==0){
            
            var toastEvent2 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.File_not_Imported}");
            var titl  = $A.get("{!$Label.c.Warning}");
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
            
            console.log('cmpgn_tp '+cmpgn_tp);
            console.log('blk_dt '+blk_dt);
            if(!cmpgn_tp){
                
                var toastEvent3 = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Please_select_Campaign_Type}");
                var titl  = $A.get("{!$Label.c.Error}");
                toastEvent3.setParams({
                    "title": titl,
                    "type": "error",
                    "message": msg,
                    "duration":'3000'
                });
                toastEvent3.fire();
                
                isValid=false;
                isPriceBookvalid=false;
            }
            else if(intr_dt == 'Invalid Date' || !intr_dt){
                console.log('intr_dt isValid '+isValid);
                component.find("intr_dt").set('v.validity', {valid:false, badInput :true});
                component.find("intr_dt").showHelpMessageIfInvalid();
                isValid=false;
                isPriceBookvalid=false;
            }
                else if(blk_dt == 'Invalid Date' || !blk_dt){
                    
                    component.find("blockDateId").set('v.validity', {valid:false, badInput :true});
                    component.find("blockDateId").showHelpMessageIfInvalid();
                    isValid=false;
                    isPriceBookvalid=false;
                }
                    else if(paymntTerm_wrapper.length == 0){
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
            		
                        else if(salesDistrict_wrapper.length == 0 || salesDistrict_wrapper=="undefined"){
                            console.log("Inside Sales District Empty==>");
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
                            component.find("tabs").set("v.selectedTabId","one");
                            isValid=false;
                            isPriceBookvalid=false;
                        }
/********************************/
       
else if(salesDistrict_wrapper.length > 0){
            
            var duplicateval = component.get("v.showduplicateErr");
                            
            for(var i = 0 ;i<salesDistrict_wrapper.length;i++){
                for(var j = i+1 ;j<salesDistrict_wrapper.length;j++){
                    
                    var nameOfSD = salesDistrict_wrapper[i].Name;
                    if(typeof nameOfSD == "undefined"){
                        component.set("v.showErrOnDiv", true);
                        isValid = false;
                    }else{
                        console.log('arrOfSalesdist[i].Name'+salesDistrict_wrapper[i].Name);
                        if(salesDistrict_wrapper[i].Name != null || salesDistrict_wrapper[i].Name != ''){
                            if(salesDistrict_wrapper[i].Name == salesDistrict_wrapper[j].Name){
                                component.set("v.showduplicateErr", true);
                                isValid = false;
                            }     
                        }
                    }
                }
            }
            
            if(!duplicateval){
                for(var i = 0 ;i<salesDistrict_wrapper.length;i++){
                    if(salesDistrict_wrapper[i].Name == null){
                        component.set("v.showErrOnDiv", true);
                        isValid = false;
                    }else{
                        component.set("v.showErrOnDiv", false);
                    }
                }
            }
        }            
            
            
            /********************************/
               
        }
        else{
            cmpgn_tp='';
            blk_dt='';
            intr_dt='';
            
        }
        
        if(isValid){
            
            obj.pb_for_cmpgn = pb_cmpgn;
            obj.cmpgn_tp = cmpgn_tp;
            obj.pb_name = pb_nm;
            //obj.curncy=currency;
            obj.frm_dt = frmDt;
            obj.exp_dt = toDt;
            obj.intr_rt_R = intr_R;
            obj.intr_rt_U = intr_U;
            obj.intr_dt = intr_dt;
            //obj.division=divsn;
            obj.blk_dt = blk_dt;
            obj.mgr_Discount = mgr_discount;
            obj.simulator_upload = simulator_upload;
            
            priceBook=obj;
            console.log('grp_wrapper :-'+grp_wrapper.length);
            for(var n=0;n<Lastgroup.length;n++){
                groupArray.push(Lastgroup[n]);
            }
            
            console.log('groupArray :-'+groupArray.length);
            var grpNameArray=[];
            var grpInMaterials=[];
            if(groupArray.length==grp_wrapper.length){
                console.log('groupArray :-'+groupArray);
                for(var m=0;m<grp_wrapper.length;m++){
                    grpNameArray.push(grp_wrapper[m].grp_name);
                }
                
                function compareArrays(arr1, arr2) {
                    return $(arr1).not(arr2).length == 0 && $(arr2).not(arr1).length == 0;
                }
    
                if(compareArrays(groupArray,grpNameArray)){
                console.log('Group Number Matched');
                helper.createAndSubmitPriceBook(component, event, helper, priceBook,grp_wrapper, material_wrapper, paymntTerm_wrapper,salesDistrict_wrapper);
                }
                else{
                console.log('Group Number Not Matched');
                var toastEvent4 = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Group_numbers_didn_t_match_in_materials}");
                var titl  = $A.get("{!$Label.c.Error}");
                toastEvent4.setParams({
                    "title": titl,
                    "type": "error",
                    "message": msg,
                    "duration":'3000'
                });
                toastEvent4.fire();
                component.find("tabs").set("v.selectedTabId","one");
                isValid=false;
                isPriceBookvalid=false;
                component.set("v.showSpinner",false);
                }
                
            }else {
                console.log('Group Number Not Matched');
                var toastEvent4 = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Group_numbers_didn_t_match_in_materials}");
                var titl  = $A.get("{!$Label.c.Error}");
                toastEvent4.setParams({
                    "title": titl,
                    "type": "error",
                    "message": msg,
                    "duration":'3000'
                });
                toastEvent4.fire();
                component.find("tabs").set("v.selectedTabId","one");
                isValid=false;
                isPriceBookvalid=false;
                component.set("v.showSpinner",false);
            }
            
            
            console.log('Price book '+priceBook);
            //alert(priceBook);
        }
        else{
            component.set("v.showSpinner",false);
        }
        
    },
    
    //On Price book update/ Validations / Calls updatePriceBook of helper on ALL OK
    handlePriceBookUpdate: function(component, event, helper){
        //console.log('priceBookUpdate called..');
        component.set("v.showSpinner",true);
        var priceBook = component.get("v.priceBookDetails"); //{};
        var recordId = component.get("v.recordId");
        //console.log(priceBook);
        var pb_cmpgn=component.get("v.pb_for_campaign");
        //alert(pb_cmpgn);
        var cmpgn_tp='';
        //var divsn=component.find("HiddenDivisionName").get("v.value");
        var blk_dt='';
        var intr_dt ='';
        var obj = new Object();
        var isValid=true;
       /* if(pb_cmpgn){
           cmpgn_tp=component.get("v.campaignType");
        }*/
        var pb_nm = component.find("pb_name").get("v.value");
        var frmDt = $A.localizationService.formatDate(component.get("v.frmDate"), "yyyy-MM-dd");//component.find("validfrmId").get("v.value");
        var toDt = $A.localizationService.formatDate(component.get("v.toDate"), "yyyy-MM-dd");//component.find("expiryId").get("v.value");
        if(pb_cmpgn){
            cmpgn_tp=component.get("v.campaignType");
            blk_dt= $A.localizationService.formatDate(component.get("v.blockDate"), "yyyy-MM-dd");//component.find("blck_dt").get("v.value");
            intr_dt = $A.localizationService.formatDate(component.get("v.intrDate"), "yyyy-MM-dd");//component.find("intr_dt").get("v.value");
        }
        var intr_R = component.get("v.PriceBook.Interest_Rate_R__c");
        var intr_U = component.get("v.PriceBook.Interest_Rate_U__c");
        var mgr_discount = component.get("v.mgr_discount");
        var simulator_upload = component.get("v.simulator_upload");
        //var intr_R = component.find("int_rate_R").get("v.value");
        //var intr_U = component.find("int_rate_U").get("v.value");
        var material_wrapper= component.get("v.materialDetails");
        var paymntTerm_wrapper = component.get('v.paymentTermsWrapper');
        var grp_wrapper = component.get("v.groupWrapperList");
        var payObjsDelete = component.get('v.paymentTermsToDelete');
        var salesDistrict_wrapper = component.get("v.salesdtarr");
        // //console.log('mt file  '+material_wrapper.length);
        
        if(!pb_nm){
            //console.log('pb_nm isValid '+isValid);
            component.find("pb_name").set('v.validity', {valid:false, badInput :true});
            component.find("pb_name").showHelpMessageIfInvalid();
            isValid=false;
        }
        
        /*if(!currency){
              //console.log('currency isValid '+isValid);
             //console.log('currency inside if '+currency);
            component.find("currencyID").set('v.validity', {valid:false, badInput :true});
            component.find("currencyID").showHelpMessageIfInvalid();
             isValid=false;
        }*/
        if(frmDt == 'Invalid Date' || !frmDt){
            //console.log('frmDt isValid '+isValid);
            // component.find("validfrmId").set("v.errors", [{message: "Select Date."}]);
            // $A.util.addClass(component.find("validfrmId"), 'slds-has-error');
            isValid=false;
            component.find("validfrmId").set('v.validity', {valid:false, badInput :true});
            component.find("validfrmId").showHelpMessageIfInvalid();
        }
        if(toDt == 'Invalid Date' || !toDt){
            //console.log('toDt isValid '+isValid);
            // component.find("expiryId").set("v.errors", [{message: "Select Date."}]);
            // $A.util.addClass(component.find("expiryId"), 'slds-has-error');
            isValid=false;
            component.find("expiryId").set('v.validity', {valid:false, badInput :true});
            component.find("expiryId").showHelpMessageIfInvalid();
        }
        if(!intr_R){
            //console.log('intr_R isValid '+isValid);
            component.find("int_rate_R").set('v.validity', {valid:false, badInput :true});
            component.find("int_rate_R").showHelpMessageIfInvalid();
            isValid=false;
        }
        if(!intr_U){
            //console.log('intr_U isValid '+isValid);
            component.find("int_rate_U").set('v.validity', {valid:false, badInput :true});
            component.find("int_rate_U").showHelpMessageIfInvalid();
            isValid=false;
        }
        /* if(!divsn){
            component.find("DivisionName").set('v.validity', {valid:false, badInput :true});
            component.find("DivisionName").showHelpMessageIfInvalid();
            isValid=false;
             //console.log('Division' +divsn);
        } */
        
        /*  if(mtFile.length==0){
            var toastEvent2 = $A.get("e.force:showToast");
            var msg  = $A.get("{!$Label.c.File_not_Imported}");
            var titl  = $A.get("{!$Label.c.Warning}");
            toastEvent2.setParams({
                "title": titl,
                "type": "warning",
                "message": msg,
                "duration":'3000'
            });
            toastEvent2.fire();
            //alert('File not Imported.');
             isValid=false;
        }*/
        
        if(pb_cmpgn){
            
            //console.log('cmpgn_tp '+cmpgn_tp);
            //console.log('blk_dt '+blk_dt);
            if(!cmpgn_tp){
                var toastEvent3 = $A.get("e.force:showToast");
                var msg  = $A.get("{!$Label.c.Please_select_Campaign_Type}");
                var titl  = $A.get("{!$Label.c.Error}");
                toastEvent3.setParams({
                    "title": titl,
                    "type": "error",
                    "message": msg,
                    "duration":'3000'
                });
                toastEvent3.fire();
                // alert('Please select Campaign Type.');
                isValid=false;
            }
            else if(intr_dt == 'Invalid Date' || !intr_dt){
                //console.log('intr_dt isValid '+isValid);
                component.find("intr_dt").set('v.validity', {valid:false, badInput :true});
                component.find("intr_dt").showHelpMessageIfInvalid();
                isValid=false;
            }
                else if(blk_dt == 'Invalid Date' || !blk_dt){
                    
                    component.find("blck_dt").set('v.validity', {valid:false, badInput :true});
                    component.find("blck_dt").showHelpMessageIfInvalid();
                    isValid=false;
                }
                    else if(paymntTerm_wrapper.length == 0){
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
                    }
            
        }
        else{
            cmpgn_tp='';
            blk_dt='';
            intr_dt='';
            
        }
        //console.log('isvalid '+ isValid);
        
        if(isValid){
            obj.pcb_id = recordId;
            obj.pb_for_cmpgn = pb_cmpgn;
            obj.cmpgn_tp = cmpgn_tp;
            obj.pb_name = pb_nm;
            //obj.curncy=currency;
            obj.frm_dt = frmDt;
            obj.exp_dt = toDt;
            obj.intr_rt_R = intr_R;
            obj.intr_rt_U = intr_U;
            obj.intr_dt = intr_dt;
            //obj.division=divsn;
            obj.blk_dt = blk_dt;
            obj.mgr_Discount = mgr_discount;
            obj.simulator_upload = simulator_upload;
            
            priceBook=obj;
            
            
            helper.updatePriceBook(component, event, helper, priceBook, grp_wrapper, material_wrapper, paymntTerm_wrapper, payObjsDelete);
            
            //console.log('Price book if campaign not checked'+priceBook);
            //alert(priceBook);
        }
        else{
            component.set("v.showSpinner",false);
        }
        
        
    },
    
    //On Click of activate or Deactivate / calls activeDeactive of helper
    handleDeactivate : function(component, event, helper){
        component.set("v.showSpinner",true);
        //var currecny = component.find("checkbox-id-01").get("v.value"); 
        var pb = component.get("v.priceBookDetails");
       // var isChecked = component.find("checkbox-id-02").get("v.checked");
        var isChecked = pb.isActive;
        
        var recordId = component.get("v.recordId");
        var strVal = '';
       // alert(isChecked);
        
      // var checkbox = document.getElementById('checkbox-id-01');
        if(isChecked){
           strVal ='false';
           
        }
        else{
            strVal ='true';
        }
        helper.activeDeactive(component, event,recordId, strVal);
        component.set("v.showSpinner",false);
    },
    
    //Not in Use
    handleExpiryValueChange: function(component, event, helper){
        //alert('how expiry gets Called');
        var isNullCheck = true;
        var validfrmDt = component.get("v.myDate");
        ////console.log('Method--validfrmDt--'+validfrmDt);
        var expiryDt = component.get("v.myDate1");
        ////console.log('Method--ExpiryDt--'+expiryDt);
        var falseDate1 = true;
        var Today = new Date();
        ////console.log('todaydate'+Today.getDate());
        var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();    
        var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
        var yyyy = Today.getFullYear();
        var todayDate = (yyyy + "-" + MM + "-" + dd);
        ////console.log('method--todayDate---'+todayDate);
        
        
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
            //console.log('Inside--isNullCheck-'+isNullCheck);
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

    
    //Handle Submit for Approval
    submitApproval : function(component, event, helper){
        //console.log('submitApproval called..');
        //component.set("v.showSpinner",true);
        var recordId = component.get("v.recordId");
        helper.sendForApproval(component, recordId);
        component.set("v.inApprovalFlag",true);
    },
    
    //On click of + button for adding Sales District
    addSalesDist : function(component, event, helper){        
        try{
            var sd = component.get("v.salesdtarr");
            sd.push({
                'Id':'',
                'sdtId':'',
                'sdtNameforSales':''
            });
            component.set("v.salesdtarr",sd);
            
            //helper.goDown(component);   
        }catch(error){
            //console.log('error-->'+error);
        }   
    },
    
    //To open Sales district ldt: Datatable for Sales District Selection
    //on click of search icon in SD line item
    openSDModel: function(component, event, helper){
        try{
            
            var target = event.getSource();  
            var rowIndexValue = target.get("v.value");            
            component.set("v.rowIndexSD",rowIndexValue);
            helper.fetchSalesDistrict(component);
            component.set("v.isOpenSD", true);
            helper.applyCSS(component);
            
        }catch(error){
            //console.log('error-->'+error);
        }
    },
    
    
    //Called to close various modal popups like group and SD addtions
    closeModel: function(component, event, helper){
        component.set("v.isOpen", false);
        //component.set("v.isOpen2", false);
        component.set("v.isOpenSD", false);
        component.set("v.groupIndex","-1");
        component.set("v.groupObj",{'sobjectType':'Campaign_Group__c',
                                    'Name_of_the_group__c':'',
                                    'Campaign__c':'',
                                    'Group_Discount__c':0,
                                    'Limited_volume__c':false,
                                    'Will_you_have_a_sub_product_group__c':'No',
                                    'Required_sub_group_Qty__c':0});
        helper.revertCssChange(component);
    },
    
   
    //Delete SD Line Item
    handleRemoveSalesDist : function(component, event, helper){
        var target = event.getSource();  
        var index = target.get("v.value");
        helper.removeSalesDist(component, index);
        
    },
    
    //To handle LDT Datatable Values
    tabActionClicked: function(component, event, helper){
        
        var actionId = event.getParam('actionId');
        var lstofSldt = [];
        
        //Division
        /*if(actionId == 'selectDivision' ){
            
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
                        //console.log('Error-->'+e);
                    }
                    
                }
            }
            component.set('v.wrappers', skuArray);
            component.set("v.isOpen3", false);
            helper.revertCssChange(component);
        }
        */
        //Sales District
        if(actionId == 'salectDist'){
            //console.log('salectDist');
            var rowIdx = event.getParam("index");
            var Salesdist = event.getParam('row');
            var rowIndex = component.get("v.rowIndexSD");
            var salesDistList = component.get("v.salesdtarr");
            
                       //console.log("salesDistList--> "+JSON.stringify(salesDistList));
            for (var idx=0; idx<salesDistList.length; idx++) {
                if (idx==rowIndex) {
                    //console.log("salesDistList If--> ");
                    salesDistList[idx].sdtId = Salesdist.Id;                   
                    salesDistList[idx].Name = Salesdist.Name;
                    salesDistList[idx].SDCode = Salesdist.RegionCode__c;                    
                } 
            }
            component.set('v.salesdtarr', salesDistList);
            component.set("v.isOpenSD",false);
            helper.revertCssChange(component);
            
        }
    },
    
    //Not in Use
    applyCSS: function(component){
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:0} .forceStyle.desktop .viewport{overflow:hidden}");
    },
    
    //Not in Use
    revertCssChange: function(component){
        // alert('2000');
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:5} .forceStyle.desktop .viewport{overflow:visible}");
    },
    
    //Called on Click of cancel button to redirect to list view
    gotoListview : function (component, event, helper){
        helper.gotoListviewHelper(component,'');
    },
    //added for kit on change of pricebook type set the values and navigate to component
    onRadioSelect:function(component, event, helper){
        //var currecny = component.find("checkbox-id-01").get("v.value"); 
        var val1=event.getSource().get('v.value');
       component.set("v.priceBookType",val1);
var pbType=component.get("v.priceBookType");
            //alert('**'+pbType);        
      // var checkbox = document.getElementById('checkbox-id-01');
        if(val1=='Price Book For Campaign'){
            component.set("v.hide1","true");
            //component.set("v.hide2","false");
            //component.set("v.hide3","false");
            //component.set("v.hide4","true");
            //component.set("v.hide5","true");
            component.set("v.hide6","true");
            //component.set("v.hide7","false");
            
            
            component.set("v.pb_for_campaign",true);
            component.set("v.campaignType","Structured");
            component.find("radio2").set("v.checked", true);
            helper.loadPaymentTerms(component);
        }
        else{



            component.set("v.hide1","false");
            //component.set("v.hide2","true");
            //component.set("v.hide3","true");
            //component.set("v.hide4","false");
			//component.set("v.hide5","false");
            component.set("v.hide6","false");
            //component.set("v.hide7","true");
            
            component.set("v.pb_for_campaign",false);
            component.set("v.campaignType","");
            component.find("radio2").set("v.checked", false);

            /* added by nikhil : on-22-3-2019 */
            
            var pbKit;
            if(pbType=="Normal Pricebook"){
                pbKit=false;
                component.set("v.campaignType","");
            }
            else if (pbType=="Price Book For Kit"){
                pbKit=true;
                component.set("v.campaignType","");
            }
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef  : "c:NewBrazilPricebook",
                componentAttributes  : {
                Price_Book_For_Campaign :false ,
                Price_Book_For_Kit :pbKit ,
                priceBookType :pbType,
                campaignType:   component.get("v.campaignType"),
               reload:true
            }
            });
            //console.log('Event '+evt);
            evt.fire(); 
        }},
    //to toggle between campaign screen based on the Price book for Campaign Checkbox 
    toggleCheck: function(component, event, helper){
        
        //var currecny = component.find("checkbox-id-01").get("v.value");
        var isChecked = component.get("v.Price_Book_For_Campaign"); 
        //var isChecked = component.find("checkbox-id-01").get("v.checked");
        // alert(isChecked);
        var pbType=component.find("checkbox-id-01").get("v.value");
        // var checkbox = document.getElementById('checkbox-id-01');
        if(isChecked){
            component.set("v.hide1","true");
            //component.set("v.hide2","false");
            //component.set("v.hide3","false");
            //component.set("v.hide4","true");
            //component.set("v.hide5","true");
            component.set("v.hide6","true");
            //component.set("v.hide7","false");
            
            
            component.set("v.pb_for_campaign",true);
            component.set("v.campaignType","Structured");
            component.find("radio2").set("v.checked", true);
            helper.loadPaymentTerms(component);
        }
        else{



            component.set("v.hide1","false");
            //component.set("v.hide2","true");
            //component.set("v.hide3","true");
            //component.set("v.hide4","false");
			//component.set("v.hide5","false");
            component.set("v.hide6","false");
            //component.set("v.hide7","true");
            
            component.set("v.pb_for_campaign",false);
            component.set("v.campaignType","Simple");
            component.find("radio2").set("v.checked", false);

            /* added by nikhil : on-22-3-2019 */

            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef  : "c:NewBrazilPricebook",
                componentAttributes  : {
                Price_Book_For_Campaign :false ,
                Price_Book_For_Kit :false ,
                priceBookType :pbType,
                campaignType:component.get("v.campaignType"),
                    reload:true
            }
            });
            //console.log('Event '+evt);
            evt.fire(); 
        }
        //component.find("DivisionName").set("v.disabled",true);
    },
    
    //to toggle between campaign screen based on the Price book for Campaign Type Radio
    //modified to send pbtype parameter in method call
    onRadioChange: function(component, event, helper){
        //alert('hello');
        // var test=component.find("options").get("v.value");
        if(event.getSource().get('v.value') == 'Structured'){
            component.set("v.hide8",false);
        }
        else{
             /* added by nikhil : on-22-3-2019 */
            var pbType=component.get("v.priceBookType");
            
            //alert(pbType);
                var evt = $A.get("e.force:navigateToComponent");
                evt.setParams({
                    componentDef  : "c:NewBrazilPricebook",
                    componentAttributes  : {
                        Price_Book_For_Campaign :true,
                        Price_Book_For_Kit :false ,
                        priceBookType :pbType,
                        campaignType:component.get("v.campaignType"),
                        reload:true
                    }
                });
                //console.log('Event '+evt);
                evt.fire(); 
               
            component.set("v.hide8",true);
        }
    }, 
    
    //Opens up Group addition popup
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        var grpIndex = component.get("v.groupIndex");
        console.log("grpIndex---> "+grpIndex);
        component.set("v.isOpen", true);
        if(grpIndex==-1){
            component.find("ltd_vol_no").set("v.checked",true);
            component.find("sub_grp_req_no").set("v.checked",true);
        }
        
    },
    
})