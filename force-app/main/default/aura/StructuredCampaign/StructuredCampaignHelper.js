({ 
    //To fetch values from Payment Terms Master
    loadPaymentTerms : function(cmp) {
        console.log('loadPaymentTerms called...');
        var action = cmp.get("c.getPaymentTerm");
       
        action.setCallback(this,function(resp){
        var state = resp.getState();
        if(cmp.isValid() && state === 'SUCCESS'){
            //console.log('response..... '+resp.getReturnValue());
        cmp.set("v.paymentTerms",resp.getReturnValue());
       
        }else{
            console.log(resp.getError());
        }
        });
        $A.enqueueAction(action);
    
    },
    
    //To load SKU descriptions based on the SKU code in CSV file
    loadSKUDescription: function(cmp) {
        console.log('loadSKUDescription called...');
        var action = cmp.get("c.skuDescriptionMap");
       
        action.setCallback(this,function(resp){
        var state = resp.getState();
        if(cmp.isValid() && state === 'SUCCESS'){
        console.log('loadSKUDescription response..... '+resp.getReturnValue());
        cmp.set("v.skuDescription",resp.getReturnValue());
       
        }else{
            console.log(resp.getError());
        }
        });
        $A.enqueueAction(action);
    
    },

    //To validate/process CSV and Populate JQuery Datatable in ALL OK
   	CSV2JSON: function (component,csv) {
      
        var skDet = component.get('v.materialDetails');        
        var skuDesc = component.get("v.skuDescription");
       	var groupSet=component.get("v.groupSet");
        var skuSet= component.get("v.uniqueSKU");
       	var clrTable= component.get("v.clearTableData");    
        var grpSet=[];
        var grpSet2=[];
        
        console.log("skDet.length--> "+skDet.length+' '+typeof(skDet));
        if(skDet.length>0){
            component.set("v.materialDetails",'');
            skDet = [];
            $('#csvTable').dataTable().fnClearTable();
        }
        
        var key ='';
        //var array = [];
        var arr = []; 
         
        arr = csv.split('\n');
        
       // console.log('@@@ arr = '+arr);
        arr.pop();
        var jsonObj = [];
        var headers = arr[0].split(',');
        var flag=true;
        console.log("number of rows ==> "+arr.length);
        for(var i = 1; i < arr.length; i++) {
           // var data = arr[i].split(',');
           
            var re =/,(?=(?:(?:[^"]*"){2})*[^"]*$)/g;				// /,(?=(?:(?:[^"]*"){2})*[^"]*$)/; 
            var data = [].map.call(arr[i].split(re), function(el) {
                return el.replace(/^"|"$/g, '');
              }
            );
            
            //alert(data);
            var obj = {};
            var obj2 ={};
            if(data.length!=14){
                flag=false;
                    var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.Wrong_file_format}");
                        var titl  = $A.get("{!$Label.c.Error}");
                        toastEvent.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg,
                            "duration":'5000'
                        });
                        toastEvent.fire();
                document.getElementById("file").value = "";
            }
            else{
            
            for(var j = 0; j < data.length; j++) {
                //console.log("val at "+i+" ==> "+val);
                var invVal='';
                var val=data[j].trim();
             if(val.length == 0){ 

                if(j == 0 && val.length == 0){
                    flag=false;
                    var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.File_has_Null_SKU_Code_Please_Add_SKU_Code_and_Then_Import_File}");
                        var titl  = $A.get("{!$Label.c.Error}");
                        toastEvent.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg,
                            "duration":'5000'
                        });
                        toastEvent.fire();
                    document.getElementById("file").value = "";
                    clrTable=true;
                    val='0,0';
                }
                else if(j == 1){
                    flag=false;
                    var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.Found_null_values_in_Volume_column}");
                        var titl  = $A.get("{!$Label.c.Error}");
                        toastEvent.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg
                        });
                        toastEvent.fire();
                    document.getElementById("file").value = "";
                    clrTable=true;
                    val='0,0';
                }
                
                else if(j == 2 || j == 3 || j == 4 || j == 5 || j == 6 ||j == 7 ){
                    flag=false;
                    var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.Found_Null_Column_values_for_Both_Currency}");
                        var titl  = $A.get("{!$Label.c.Error}");
                        toastEvent.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg
                        });
                        toastEvent.fire();
                    document.getElementById("file").value = "";
                    clrTable=true;
                    val='0,0';
                }
                else if(j == 8 || j == 9 || j == 10 || j == 11 || j == 12 ||j == 13 ){
                    flag=false;
                    var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.Found_null_values_in_CSV}");
                        var titl  = $A.get("{!$Label.c.Error}");
                        toastEvent.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg
                        });
                        toastEvent.fire();
                     document.getElementById("file").value = "";
                     clrTable=true;
                    val='0,0';
                }
                
                else{
                   
                val='0,0';
				val=val.replace('.','').replace(',','.').trim();
                val=val.replace("\"","");
                val=val.replace(".",",");
               /* val=val.replace(",",".").trim();
                val=val.replace(".",",");
                val=val.replace("\"","");
                */
                var hed=headers[j].replace(",",".").trim();
                hed=hed.replace(".",",");
                
                obj[hed] = val;
               
              /*if(j==0){
                  obj2.cn=val;  
                }
                else*/
                if(j==0){
                  obj2.sku_code=val; 
                    
                    if(val.length == 6){
                        key='5191000000000000'+val;   // if length is 6 then added 12 zeros. 
                    }
                    else if(val.length == 7){
                        key='519100000000000'+val;    // if length is 7 then added 11 zeros.       
                    }
                    else {
                        key='5191'+val;    // if length is 18 then added sales org code only.       
                    }
                    if (jQuery.inArray(key, skuSet)!='-1') {
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
                        document.getElementById("file").value = "";
                        clrTable=true;
                           
                    }                    
                    if(key in skuDesc){
                        // console.log('skuDesc------ '+skuDesc[key]);
                         obj2.sku_desc = skuDesc[key];
                     }
                     else{
                         obj2.sku_desc = '';
                     }
                }
                //if(j==2){
                 // obj2.sku_desc='N/A';  
                //}
                else if(j==1){
                  obj2.volume=val;  
                }
                else if(j==2){
                  obj2.unt_prc=val;  
                }
                else if(j==3){
                  obj2.unt_prc_u=val; 
                }
                else if(j==4){
                  obj2.min_prc=val;  
                }
                else if(j==5){
                  obj2.min_prc_u=val;  
                }
                else if(j==6){
                  obj2.fsp_prc=val;  
                }
                else if(j==7){
                  obj2.fsp_prc_u=val;  
                }
                else if(j==8){
                  obj2.equivalence=val;  
                }
                else if(j==9){
                  obj2.multiplication_factor=val;  
                }
                else if(j==10){
                    if(val.length=='1'){
                        obj2.grp='00'+val;
                    }else if(val.length=='2'){
                        obj2.grp='0'+val;
                    }else{
                        obj2.grp=val;
                    }
                  obj2.grp=val;  
                }
                else if(j==11){
                  obj2.sub_grp=val;  
                }
                else if(j==12){
                  obj2.anchor=val;  
                }
                else if(j==13){
                  obj2.subGrp_required=val;  
                }
                }

              }
              else{

               /* if(val.length == 0){
                    val='0,0';
                }*/
                val=val.replace('.','').replace(',','.').trim();
                val=val.replace("\"","");
                val=val.replace(".",",");
                /*val=val.replace(",",".").trim();
                val=val.replace(".",",");
                val=val.replace("\"","");
                */
                var hed=headers[j].replace(",",".").trim();
                hed=hed.replace(".",",");
                invVal=val;
                obj[hed] = val;
                  
                  if(isNaN(invVal.replace(",",".")) && (j!=11 && j!=12 && j!=13)){
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
                      document.getElementById("file").value = "";
                      invVal='';  
                      clrTable=true;
                  }
                  
              else{
               
                 if(j==0){
                  obj2.sku_code=val; 
                    
                     
                     
                    if(val.length == 6){
                        key='5191000000000000'+val;   // if length is 6 then added 12 zeros. 
                    }
                    else if(val.length == 7){
                        key='519100000000000'+val;    // if length is 7 then added 11 zeros.       
                    }
                    else {
                        key='5191'+val;    // if length is 18 then added sales org code only.       
                    }
                     if (jQuery.inArray(key, skuSet)!='-1') {
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
                         document.getElementById("file").value = "";
                         component.set("v.showSpinner",false);  
                         clrTable=true;
                         //return false;  
                    }
                    
                    if(key in skuDesc){
                        // console.log('skuDesc------ '+skuDesc[key]);
                         obj2.sku_desc = skuDesc[key];
                     }
                     else{
                         obj2.sku_desc = '';
                     }
                }
                //if(j==2){
                 // obj2.sku_desc='N/A';  
                //}
                else if(j==1){
                  obj2.volume=val;  
                }
                else if(j==2){
                  obj2.unt_prc=val;  
                }
                else if(j==3){
                  obj2.unt_prc_u=val; 
                }
                else if(j==4){
                  obj2.min_prc=val;  
                }
                else if(j==5){
                  obj2.min_prc_u=val;  
                }
                else if(j==6){
                  obj2.fsp_prc=val;  
                }
                else if(j==7){
                  obj2.fsp_prc_u=val;  
                }
                else if(j==8){
                  obj2.equivalence=val;  
                }
                else if(j==9){
                  obj2.multiplication_factor=val;  
                }
                else if(j==10){
                    //console.log('val grp 2 :-'+val.length);
                    if(val.length=='1'){
                        obj2.grp='00'+val;
                    }else if(val.length=='2'){
                        obj2.grp='0'+val;
                    }else{
                        obj2.grp=val;
                    }
                }
                else if(j==11){
                  obj2.sub_grp=val;  
                }
                else if(j==12){
                  obj2.anchor=val;  
                }
                else if(j==13){
                  obj2.subGrp_required=val;  
                }
               
              } 
              }   //console.log('@@@ obj headers = ' + obj[headers[j].trim()]);
            }
            }
            if(flag){
                skDet.push(obj2);
                skuSet.push(key);
            }
            else{
                
                skDet.splice(0, skDet.length);
                skuSet=[];
                //$('#csvTable').dataTable().fnClearTable();
                break;
            }
            jsonObj.push(obj);
        }
       // console.log('skDet------->');
      //  console.log(skDet); 
        
        component.set('v.materialDetails',skDet);
        component.set('v.data',skDet);
       	component.set('v.uniqueSKU',skuSet); 
        
       
    if(flag){
        console.log("Line Number 359");
        // $('#csvTable').dataTable().fnClearTable();
        setTimeout(function(){ 
            // $('#csvTable').DataTable();
           // console.log(JSON.parse(JSON.stringify(skDet)));
            var testJson = JSON.parse(JSON.stringify(skDet));
            try{ 
                if ( ! $.fn.DataTable.isDataTable( '#csvTable' ) ) {

                $("#csvTable").DataTable({
                    "rowCallback": function( row, data ) {
                      if ( data[13].toUpperCase() == "SIM" ) {
                        $(row).css('background','#D3D3D3').css('color','black');
                      }
                    }
                  } );
                }
              }catch(e){
                  console.log(e);
              }
            var length = testJson.length;
            var lastGrp='';
            var grpFlag= true;
            
            for(var i = 0; i < length; i++) {
             //   console.log(testJson[i]);
                console.log('testJson[i].grp :-'+testJson[i].grp);
                grpSet.push(testJson[i].grp);
                
          try {
              
                $('#csvTable').dataTable().fnAddData( [
                //testJson[i].cn,
                testJson[i].sku_code,
                testJson[i].sku_desc,    
                testJson[i].volume,
                testJson[i].unt_prc,
                testJson[i].unt_prc_u,                                    
                testJson[i].min_prc,
                testJson[i].min_prc_u,
                testJson[i].fsp_prc,
                testJson[i].fsp_prc_u,    
                testJson[i].equivalence,
                testJson[i].multiplication_factor,
                testJson[i].grp,
                testJson[i].sub_grp,
                testJson[i].anchor,
                testJson[i].subGrp_required
               // '<button  class="slds-button btn-small" style="color:red"  value="'+i+'" iconName="utility:delete" >X</button>'
                /*'<button class="slds-button slds-button_destructive"><svg class="slds-button__icon slds-button__icon_right" aria-hidden="true"><use xlink:href="/assets/icons/utility-sprite/svg/symbols.svg#delete"></use></svg></button>'*/

              
            ]);
          document.getElementById("file").value = "";    
           
        } catch (error) {
          console.log(error); 
          document.getElementById("file").value = "";
          component.set("v.showSpinner",false);  
        }
           
        }
       
        console.log('lastGrp length 2:-'+ Array.from(new Set(grpSet)));
        var arSet=Array.from(new Set(grpSet));
        for(var m=0;m<arSet.length;m++){
              grpSet2.push(arSet[m]);
         }
        console.log('grpSet 2 :-> '+grpSet2.length)
        component.set("v.Lastgroup",grpSet2);
        component.set("v.showSpinner",false);   
            $('div.dataTables_filter input').addClass('slds-input');
             $('div.dataTables_filter input').css("marginBottom", "10px");
         }, 500);  
     }
     else{
        component.set("v.showSpinner",false);
     }
       
         
        var json = JSON.stringify(jsonObj);
       // console.log('@@@ json = '+ json);
      
        return json;
        
    },

    //Not in Use
    sortData: function (component, fieldName, sortDirection) {
        var data = component.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        component.set("v.data", data);
    },  
    
    //Not in Use
    sortBy: function (field, reverse, primer) {
     var key = primer ? function(x) {return primer(x[field])} : function(x) {return x[field]};
     //checks if the two rows should switch places
     reverse = !reverse ? 1 : -1;
     return function (a, b) {
         return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
     }
 	},
    
    //To create Price Book, sends all the wrappers to class
    createPriceBook: function(component, event, helper, priceBook,grp_wrapper, material_wrapper, paymntTerm_wrapper,salesDistrict_wrapper){
        console.log('createPriceBook called..');
        console.log(priceBook);
        console.log(material_wrapper);
        console.log(grp_wrapper);
        console.log(paymntTerm_wrapper);
        console.log(salesDistrict_wrapper);
        var action = component.get("c.savePriceBook");
        
        action.setParams({
            "price_book":JSON.stringify(priceBook),
            "sku_file":JSON.stringify(material_wrapper),
            "groupList":JSON.stringify(grp_wrapper),
            "paymentTerms":JSON.stringify(paymntTerm_wrapper),
            "salesDistrictList": JSON.stringify(salesDistrict_wrapper)
        });
        
        action.setCallback(this,function(response){
            console.log(response.getError());
            if(response.getState() == 'SUCCESS'){
              console.log(response.getReturnValue()); 
             //  alert('Price and Scheme Details Added Successfully..'); 
			 //var pb_id = response.getReturnValue();
			 var resp = response.getReturnValue();
             /*if((pb_id!=undefined || pb_id!=null) && pb_id!='false'  ){
             var successMsg  = $A.get("{!$Label.c.Price_Book_Created_Successfully}"); 
                        var successMsg1 = $A.get("{!$Label.c.Success}");
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": successMsg1,
                            "type": "Success",
                            "message": successMsg
                        });
                        toastEvent.fire();
                                    
                    this.goToPbRecord(component,pb_id);
                }
                else{
                     	var successMsg  = $A.get("{!$Label.c.Some_error_has_occurred}"); 
                        var successMsg1 = $A.get("{!$Label.c.Success}");
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": successMsg1,
                            "type": "Error",
                            "message": successMsg
                        });
                        toastEvent.fire();
                     	component.set("v.showSpinner",false);
                    	return false;
                  	this.gotoListviewHelper(component);  
                }*/
                
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
                console.log('Response on create...'); 
                console.log(resp);
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
                this.gotoListviewHelper(component,'draft');
            } 
            // component.set("v.showSubmitSpinner",false);
             component.set("v.showSpinner",false);
        });
        
       $A.enqueueAction(action);	
    },
    
    //To create Price Book and Submit it for approval as well
    createAndSubmitPriceBook: function(component, event, helper, priceBook,grp_wrapper, material_wrapper, paymntTerm_wrapper,salesDistrict_wrapper){
        console.log('createPriceBook called..');
        console.log(priceBook);
        console.log(material_wrapper);
        console.log(grp_wrapper);
        console.log(paymntTerm_wrapper);
        console.log(salesDistrict_wrapper);
        var action = component.get("c.saveAndSubmitPriceBook");
        
        action.setParams({
            "price_book":JSON.stringify(priceBook),
            "sku_file":JSON.stringify(material_wrapper),
            "groupList":JSON.stringify(grp_wrapper),
            "paymentTerms":JSON.stringify(paymntTerm_wrapper),
            "salesDistrictList": JSON.stringify(salesDistrict_wrapper)
        });
        
        action.setCallback(this,function(response){
            console.log(response.getError());
            if(response.getState() == 'SUCCESS'){
              console.log(response.getReturnValue()); 
             //  alert('Price and Scheme Details Added Successfully..'); 
			 //var pb_id = response.getReturnValue();
			 var resp = response.getReturnValue();
             /*if((pb_id!=undefined || pb_id!=null) && pb_id!='false'  ){
             var successMsg  = $A.get("{!$Label.c.Price_Book_Created_Successfully}"); 
                        var successMsg1 = $A.get("{!$Label.c.Success}");
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": successMsg1,
                            "type": "Success",
                            "message": successMsg
                        });
                        toastEvent.fire();
                                    
                    this.goToPbRecord(component,pb_id);
                }
                else{
                     	var successMsg  = $A.get("{!$Label.c.Some_error_has_occurred}"); 
                        var successMsg1 = $A.get("{!$Label.c.Success}");
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": successMsg1,
                            "type": "Error",
                            "message": successMsg
                        });
                        toastEvent.fire();
                     	component.set("v.showSpinner",false);
                    	return false;
                  	this.gotoListviewHelper(component);  
                }*/
                
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
                console.log('Response on create...'); 
                console.log(resp);
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
                this.gotoListviewHelper(component,'pending');
            } 
            // component.set("v.showSubmitSpinner",false);
             component.set("v.showSpinner",false);
        });
        
       $A.enqueueAction(action);	
    },
    
    
    //To repopulate values when price book edited
    reloadPriceBook : function(component, event, helper){
        console.log('editPriceBook called..');
        component.set("v.showSpinner",true);
        var dateFormat = $A.get("$Locale.dateFormat");
        
        var Today = new Date();
            var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();
            var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
            var yyyy = Today.getFullYear();
        
        var currentDate = yyyy + "-" + MM + "-" + dd;
         //component.set("v.today", yyyy + "-" + MM + "-" + dd);
        	
        var action = component.get("c.reloadPriceBook");
        
        action.setParams({
            "price_bookId":component.get("v.recordId")
        });
        
         action.setCallback(this,function(response){
            console.log(response.getError());
            if(response.getState() == 'SUCCESS'){
               
              var data = response.getReturnValue();
              var parsed = data;
              console.log(data);
              console.log(parsed);
              console.log(JSON.stringify(parsed.pc_book));
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
                    console.log("Line Number 476");
                    component.set("v.priceBookDetails",parsed.pc_book);
                    console.log("Line Number 478");
                    //component.set("v.hide10",true);
                   
                    if(parsed.pc_book.isActive == true){
                        component.find("checkbox-id-02").set("v.checked", true);
                        component.set("v.active_deactive",$A.get("{!$Label.c.Deactivate}"));
                    }
                    else{
                         component.set("v.active_deactive",$A.get("{!$Label.c.Activate}"));
                    }
					console.log("Line Number 484");
                    component.set("v.toDate",$A.localizationService.formatDate(parsed.pc_book.exp_dt, "yyyy-MM-dd")); //"yyyy-dd-MM"
                    
                    if(currentDate > $A.localizationService.formatDate(parsed.pc_book.frm_dt,"yyyy-MM-dd")){
                        console.log("inside currentDate > frm date if"+$A.localizationService.formatDate(parsed.pc_book.frm_dt,"yyyy-MM-dd"));
                        component.set("v.frmDate",currentDate);
                    }
                    else{
                        console.log("inside currentDate > frm date else"+$A.localizationService.formatDate(parsed.pc_book.frm_dt,"yyyy-MM-dd"));
                       	component.set("v.frmDate",$A.localizationService.formatDate(parsed.pc_book.frm_dt, "yyyy-MM-dd")); 
                    }
                    //component.set("v.frmDate",$A.localizationService.formatDate(parsed.pc_book.frm_dt, "d MMM, yyyy"));
                    
                    if(parsed.pc_book.pb_for_cmpgn == true){
                        component.find("checkbox-id-01").set("v.value", 'Price Book For Campaign');
                        component.set("v.priceBookType",'Price Book For Campaign');
                      // component.find("checkbox-id-01").set("v.checked", true);
                       console.log("Line Number 490");
                       component.set("v.hide1",true);
                       //component.set("v.hide4",true);
                       component.set("v.pb_for_campaign",true);
                      /* var chkbx= $("#checkbox-id-01");
                       chkbx.prop('checked', true);*/
                       component.set("v.blockDate",$A.localizationService.formatDate(parsed.pc_book.blk_dt, "yyyy-MM-dd"));//d MMM, yyyy
                       component.set("v.intrDate",$A.localizationService.formatDate(parsed.pc_book.intr_dt, "yyyy-MM-dd"));
                       component.set("v.PriceBook.Name",parsed.pc_book.pb_name);
                       component.set("v.PriceBook.Interest_Rate_R__c",parsed.pc_book.intr_rt_R);
                       component.set("v.PriceBook.Interest_Rate_U__c",parsed.pc_book.intr_rt_U);
                       component.set("v.mgr_discount",parsed.pc_book.mgr_Discount);
                        if(parsed.pc_book.simulator_upload==true){
                        console.log("inside simulator_upload==true")
                        component.find("simulator1").set("v.checked",true);
                        component.set("v.simulator_upload",true);    
                        }
                        else{
                          component.find("simulator2").set("v.checked",true);
                          component.set("v.simulator_upload",false);      
                        }
                        
                        
                       this.loadPaymentTerms(component);
                    }
                    else{
                        console.log("Line Number 501");
                       component.set("v.pb_for_campaign",false);
                      /* var chkbx= $("#checkbox-id-01");
                       chkbx.prop('checked', false);*/
                        component.set("v.priceBookType",'Normal Pricebook');
                            component.find("checkbox-id-01").set("v.value", 'Normal Pricebook');
                       //component.find("checkbox-id-01").set("v.checked", false); 
                       component.set("v.hide1",false);
                       //component.set("v.hide4",false); 
                    }
                    
                    if(parsed.pc_book.cmpgn_tp == 'Simple'){
                        console.log("Inside Simple");
                        component.find("radio1").set("v.checked", true);
                        component.set("v.campaignType",'Simple');
                    }
                    else if(parsed.pc_book.cmpgn_tp == 'Structured'){
                        console.log("Inside Structured");
                        component.find("radio2").set("v.checked", true);
                        component.set("v.campaignType",'Structured');
                    }
                    else{
                        component.set("v.campaignType",'');    
                    }
                     
                    
                 //   component.set("v.PriceBookDivisionName",parsed.pc_book.division_nm);
                    //component.find("HiddenDivisionName").set("v.value", parsed.pc_book.division);
                   

                 if(parsed.materialList != null){ 
                    var materials = component.get('v.materialDetails'); 
                    var newWrapper = new Array();
                     console.log("Before Parsing");
                    for(var j = 0 ;j < parsed.materialList.length;j++){
                        //console.log("parsed.materialList[j].sku_desc--> "+parsed.materialList[j].sku_desc);
                    newWrapper = {
                                 //'cn': parsed.materialList[j].cn,
                                //'mt_code': parsed.materialList[j].mt_code,
                                'sku_code' :parsed.materialList[j].sku_code,
                        		'sku_desc' :parsed.materialList[j].sku_desc,
                        		'volume':parsed.materialList[j].volume,
                                'min_prc':parsed.materialList[j].min_prc,
                                'min_prc_u':parsed.materialList[j].min_prc_u,
                                'unt_prc':parsed.materialList[j].unt_prc,
                                'unt_prc_u':parsed.materialList[j].unt_prc_u,
                                'fsp_prc':parsed.materialList[j].fsp_prc,
                                'fsp_prc_u':parsed.materialList[j].fsp_prc_u,
                        		'equivalence':parsed.materialList[j].equivalence,
                        		'multiplication_factor':parsed.materialList[j].multiplication_factor,
                        		'grp':parsed.materialList[j].grp,
                        		'sub_grp':parsed.materialList[j].sub_grp,
                        		'anchor':parsed.materialList[j].anchor,
                        		'subGrp_required':parsed.materialList[j].subGrp_required,
                        		'pbd_id':parsed.materialList[j].pbd_id
                               };
                                materials.push(newWrapper);
                            } 
                    component.set('v.materialDetails',materials);
					console.log(component.get('v.materialDetails'));
                    setTimeout(function(){ 
                        //$('#csvTable').DataTable();
                        
                       // console.log(JSON.parse(JSON.stringify(skDet)));
                       try{ 
                            $("#csvTable").DataTable({
                                "rowCallback": function( row, data ) {
                                    if ( data[13].toUpperCase() == "SIM" ) {
                                        $(row).css('background','#D3D3D3').css('color','black');
                                    }
                                }
                            } );
                        }catch(e){
                            console.log(e);
                        }
                        var testJson = parsed.materialList;//JSON.parse(JSON.stringify(materialList));
                       	console.log("after Parsing");
                        var length = testJson.length;
                        for(var i = 0; i < length; i++) {
                         //   console.log(testJson[i]);
                      try {
                          
                            $('#csvTable').dataTable().fnAddData( [
                           
                            //testJson[i].cn,
                           // testJson[i].mt_code,*/
                            testJson[i].sku_code,
                            testJson[i].sku_desc,
                            testJson[i].volume,           
                            testJson[i].min_prc,
                            testJson[i].min_prc_u,
                            testJson[i].unt_prc,
                            testJson[i].unt_prc_u,
                            testJson[i].fsp_prc,
                            testJson[i].fsp_prc_u,
                            testJson[i].equivalence,
                            testJson[i].multiplication_factor,
                            testJson[i].grp,
                            testJson[i].sub_grp,
                            testJson[i].anchor,
                            testJson[i].subGrp_required,
                            //testJson[i].pbd_id,
                            //'<button id="'+testJson[i].pbd_id+'" class="slds-button btn-small" style="color:red"  value="'+i+'" iconName="utility:delete" >X</button>'
                            /*'<button class="slds-button slds-button_destructive"><svg class="slds-button__icon slds-button__icon_right" aria-hidden="true"><use xlink:href="/assets/icons/utility-sprite/svg/symbols.svg#delete"></use></svg></button>'*/
            
                          
                        ]);
                    } catch (error) {
                      console.log(error);  
                      component.set("v.showSpinner",false);  
                    }
                      
                    }
                    component.set("v.showSpinner",false);
                        $('div.dataTables_filter input').addClass('slds-input');
                         $('div.dataTables_filter input').css("marginBottom", "10px");
                     }, 5000);  

                  }
                  console.log("Line Number 601");
                  component.set('v.materialDetails',materials);

                  if(parsed.salesDistricts != null){
                    var newWrapperSdt = new Array();
                    var wrappers2 = component.get('v.salesdtarr');
                    for(var j = 0 ;j < parsed.salesDistricts.length;j++){
                        
                        console.log('DistId--->'+parsed.salesDistricts[j].Id);
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
                        component.find("sldtUtil").set("v.disabled",true);
                        component.find("lkpdisable").set("v.disabled",true);
                    }
                  }
console.log("Line Number 651");
                 if(parsed.approvarList !=null){       
                    var history = component.get('v.approvalHistory'); 
                    var hisArr = new Array();
                    for(var j = 0 ;j < parsed.approvarList.length;j++){
                        hisArr = {
                                'date_tm':parsed.approvarList[j].date_tm,
                            	'name':parsed.approvarList[j].name,
                                'user': parsed.approvarList[j].user,
                                'cur_status': parsed.approvarList[j].cur_status,
                                //'prev_status' :parsed.materialList[j].prev_status,
                                'comment':parsed.approvarList[j].comment
                               };
                               history.push(hisArr);
                            } 
                    component.set('v.approvalHistory',history);
                   
                   }
				 console.log("Line Number 648");
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
console.log("Line Number 691");
              if(parsed.groupList !=null){       
                   
                    var grpWrapperList = component.get('v.groupWrapperList');
                    var grpObj = new Array();//component.get("v.paymentSet"); 
                    
                    
                    for(var k = 0 ;k < parsed.groupList.length;k++){
                        
                        grpObj = {
                                'id':parsed.groupList[k].id,
                                'grp_id': parsed.groupList[k].grp_id,
                                'grp_name': parsed.groupList[k].grp_name,
                                'grp_desc' :parsed.groupList[k].grp_desc,
                                'discount':parsed.groupList[k].discount,
                            	'subgrp_qty_required':parsed.groupList[k].subgrp_qty_required,
                            	'subgrp_required':parsed.groupList[k].subgrp_required,
	                            'limited_vol':parsed.groupList[k].limited_vol,
                            	'dicount_given':parsed.groupList[k].dicount_given
                               };
                               grpWrapperList.push(grpObj);
                               
                               
                            } 
                    component.set('v.groupWrapperList',grpWrapperList);

                   }


                 //  component.set("v.showSpinner",false); 
                  if(parsed.pc_book.status == 'Draft' || parsed.pc_book.status == 'Disapproved'){
                    console.log("Line Number 675");                      
                    component.find("checkbox-id-01").set("v.disabled",true);
                    console.log("Line Number 677"); 
                    //component.find("pb_name").set("v.disabled",true);
                    console.log("Line Number 679"); 
                    //component.find("currencyID").set("v.disabled",true);
                    //component.find("DivisionName").set("v.disabled",true);
                    //component.find("searchUtil").set("v.disabled",true);
                    //component.find("DivisionName").set("v.disabled",true);
					console.log("Line Number 704");
                    if(parsed.pc_book.pb_for_cmpgn == true){
                        
                        component.find("radio1").set("v.disabled",true);
                        component.find("radio2").set("v.disabled",true);
                        component.set("v.inApprovalFlag",false);
                        console.log("inApprovalFlag-->"+component.get("v.inApprovalFlag"));
                        //component.set("v.hideDeleteBtn",true);  
                    }
                    if(parsed.pc_book.isActive == true){
                        console.log("parsed.pc_book.isActive---> "+parsed.pc_book.isActive)
                        component.find("checkbox-id-02").set("v.checked",true);
                        //component.find("approvalBtnId").set("v.disabled",false);
                        component.set('v.inApprovalFlag',false);
                        console.log("Line Number 803");
                    }

                   }
                    //console.log("Line Number 690");                      
                   else{
                       if(parsed.pc_book.status == 'Canceled'){
                        component.find("deactivate_btn").set("v.disabled",true);   
                       }
                    console.log("Line Number 715");                      
                    component.find("checkbox-id-01").set("v.disabled",true);
                    component.find("pb_name").set("v.disabled",true);
                    //component.find("currencyID").set("v.disabled",true);
                    component.find("validfrmId").set("v.disabled",true);
                    component.find("expiryId").set("v.disabled",true);
                    component.find("int_rate_R").set("v.disabled",true);
                    component.find("int_rate_U").set("v.disabled",true);
                    component.find("mgr_discount").set("v.disabled",true);
                    component.find("simulator1").set("v.disabled",true);
                    component.find("simulator2").set("v.disabled",true);
                      
                    component.find("updateBtn").set("v.disabled",true);
                    //component.find("searchUtil").set("v.disabled",true);
                    component.find("imprtbtn").set("v.disabled",true);
                    //document.getElementById("file").disabled = true;
                    component.set("v.hide8",false);
                    console.log("Line Number 728");                      
                    if(parsed.pc_book.pb_for_cmpgn == true){
                        console.log("Line Number 707");                      
                        component.find("radio1").set("v.disabled",true);
                        component.find("radio2").set("v.disabled",true);
                        component.find("blockDateId").set("v.disabled",true);
                        component.find("intr_dt").set("v.disabled",true);
                        component.set("v.inApprovalFlag",true);
                        component.find("approvalBtnId").set("v.disabled",true);
                        component.set("v.hideDeleteBtn",false);
                    }
                    
                   }

                 }
                // component.set("v.showSpinner",false);
            }
            else{
                 component.set("v.showSpinner",false);
            } 
            
             
        });
        
       $A.enqueueAction(action);	
    },
    
    //To update Price Book, sends all the wrappers to class
    updatePriceBook : function (component, event, helper,  priceBook, grp_wrapper, material_wrapper, paymntTerm_wrapper, payObjsDelete){
      	console.log('updatePriceBook called..');
        console.log("grp_wrapper--> "+grp_wrapper);
       //console.log("material_wrapper--> "+material_wrapper);
        console.log("paymntTerm_wrapper --> "+paymntTerm_wrapper);
        console.log("paymntTerm_wrapper --> "+payObjsDelete);
        var action = component.get("c.updatePriceBook");
        
        action.setParams({
            "price_book":JSON.stringify(priceBook),
            "sku_file":JSON.stringify(material_wrapper),
            "groupList":JSON.stringify(grp_wrapper),
            "paymentTerms":JSON.stringify(paymntTerm_wrapper),
            "payObjsDelete":JSON.stringify(payObjsDelete)
        });
        
       action.setCallback(this,function(response){
            console.log(response.getError());
            if(response.getState() == 'SUCCESS'){
              console.log(response.getReturnValue()); 
             //  alert('Price and Scheme Details Added Successfully..'); 
			
             
             var pb_id = response.getReturnValue();
             if((pb_id!=undefined || pb_id!=null) && pb_id!='false'  ){
             var successMsg  = $A.get("{!$Label.c.Price_Book_Created_Successfully}"); 
                        var successMsg1 = $A.get("{!$Label.c.Success}");
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": successMsg1,
                            "type": "Success",
                            "message": successMsg
                        });
                        toastEvent.fire();
                      this.gotoListviewHelper(component,'draft');                
                    //this.goToPbRecord(component,pb_id);
                }
                else{
                     	var successMsg  = $A.get("{!$Label.c.Some_error_has_occurred}"); 
                        var successMsg1 = $A.get("{!$Label.c.Success}");
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": successMsg1,
                            "type": "Error",
                            "message": successMsg
                        });
                        toastEvent.fire();
                     	component.set("v.showSpinner",false);
                    	return false;
                  		this.gotoListviewHelper(component,'draft');  
                }   
            } 
            // component.set("v.showSubmitSpinner",false);
             component.set("v.showSpinner",false);
        });
        
       $A.enqueueAction(action);	
    
    },
   
    //Submits the price book for approval    
    sendForApproval : function(component,recordId) {
        console.log('sentForApproval called...');
        component.set("v.showSpinner",true);
        var action = component.get("c.submitForApproval");
       
        action.setParams({
            "priceBookId":recordId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            var returnVal=  response.getReturnValue();
            if (state === "SUCCESS"){
                console.log("returnVal"+returnVal);
                if(returnVal==="Success"){
                   		var successMsg  = $A.get("{!$Label.c.Price_Book_is_Sent_For_Approval}"); 
                        var successMsg1 = $A.get("{!$Label.c.Success}");
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": successMsg1,
                            "type": "Success",
                            "message": successMsg
                        });
                        toastEvent.fire();
                    component.set("v.showSpinner",false);
                    component.set("v.inApprovalFlag",true);
                    
                }
                this.gotoListviewHelper(component,'pending');
                
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    //redirects to object home page on Save/Update/Cancel/Submit/Deactivate    
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
                homeEvent.fire();
                */
                var urlEvent = $A.get("e.force:navigateToURL");
                if(urlEvent) {
                    urlEvent.setParams({
                        "url": fullUrl,
                        "isredirect": false
                    });
                    urlEvent.fire();
                } 
                else{
                    sforce.one.navigateToURL(fullUrl);
                }
            }
        });
        $A.enqueueAction(action);
	},
    
    //To redirect to Pricebook detail page on Save and Update/ Not in Use    
    goToPbRecord :function (component,priceBookId) {
    
        var sObectEvent = $A.get("e.force:navigateToSObject");
        sObectEvent .setParams({
            "recordId": priceBookId  ,
            "slideDevName": "detail"
        });
        sObectEvent.fire(); 
    },
    
    //Not in Use    
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
    
    //Not in Use       
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
        
    //Used for Sales District validation on Div    
    applyCSS: function(component){
        
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:0} .forceStyle.desktop .viewport{overflow:hidden}");
    	var isSaldtNull = component.get("v.showErrOnDiv");
        if(isSaldtNull){
            component.set("v.showErrOnDiv", false);
        }
        
    },
     
    //Used at many places    
    revertCssChange: function(component){
        
        //var isCloneVar = component.get("v.isClone");        
        var isDone = true; 
        var recordId = component.get("v.recordId"); 
      	component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:5} .forceStyle.desktop .viewport{overflow:visible}");  
        
   	},
        
    //Not in Use    
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
        
    //Used to Populate data from Sales District Master when Pop up Opens   
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
     
    //Not in Use                        
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
        
    //To remove Sales District    
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
        
   
    
    //To Deactivate the Pricebook and Recall the approval process    
    activeDeactive : function(cmp,event,recordId, strVal) {
        console.log('activeDeactive called...');
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
            console.log('response..... '+resp.getReturnValue());

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
  
})