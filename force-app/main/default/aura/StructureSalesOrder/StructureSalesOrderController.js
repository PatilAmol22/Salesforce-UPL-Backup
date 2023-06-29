({
    doInit: function(component, event, helper) {
        console.log('salesOrder Total discount'+component.get("v.salesOrder.Total_Group_Discount__c"));
             
         component.set("v.disableSave",true);
             // $("#fc").focus();
        setTimeout(function(){ 
             $("#loader_23").show();
               //$("#fc").focus();
               onLoadCalculation();
             var salesOrderId = component.get("v.salesOrder.Id");
            console.log('salesOrderId>>--->'+salesOrderId);
        if(salesOrderId != undefined && salesOrderId != null && salesOrderId !=''){
            finalUnitPriceReplace();
            calculateEqi();
            disabledInput();
            //component.set("v.disableSave",false);
        }
        }, 8000); 
        
        
        
        function onLoadCalculation(){
                 console.log('load Calculations');
            $("div.totalProductVolume").each(function(){
                var divId = this.id;
                console.log('tag id'+divId);
                var tdId = $('#'+divId).parent().attr('id');
                console.log('tdId===>'+tdId);
                var rowSize = tdId.split('_')[2];
                var totalPrdVol = 0;
                for(var i=1;i<=rowSize;i++){ 
                  var productVol = $("#"+tdId.split('_')[0]+'_'+tdId.split('_')[1]+'_'+i+'_'+rowSize+'_Product_Volume').val();
                  productVol =	replaceDotByCommma(productVol);
                    if(isNaN(productVol)){productVol =0;}
                    totalPrdVol = totalPrdVol + productVol;
                }
                if(isNaN(totalPrdVol)){
                   totalPrdVol = 0; 
                }
                console.log('totalProductVolume'+replaceCommmaByDot(totalPrdVol.toFixed(2)));
                $('#'+divId).html(replaceCommmaByDot(totalPrdVol.toFixed(2)));    
            }); 
            
            $("div.totalValue").each(function(){
                 var divId = this.id;
                var tdId = $('#'+divId).parent().attr('id');
                var rowSize = tdId.split('_')[2];
                var totalValSum = 0;
                for(var i=1;i<=rowSize;i++){ 
                  var totalVal = $("#"+tdId.split('_')[0]+'_'+tdId.split('_')[1]+'_'+i+'_'+rowSize+'_Total_Value').html();
                   totalVal = replaceDotByCommma(totalVal);
                    if(isNaN(totalVal)){
                        totalVal = 0;
                    }
                 
                  totalValSum = totalValSum + totalVal;
                }
                if(isNaN(totalValSum)){
                   totalValSum = 0; 
                }
                console.log('totalValue'+replaceCommmaByDot(totalValSum.toFixed(2)));
                $('#'+divId).html(replaceCommmaByDot(totalValSum.toFixed(2))); 
            });
            $("div.totalValuewithInterest").each(function(){
                var divId = this.id;
                var tdId = $('#'+divId).parent().attr('id');
                var rowSize = tdId.split('_')[2];
                var totalValWithInterest = 0;
                for(var i=1;i<=rowSize;i++){ 
                  var priceWithInterest = $("#"+tdId.split('_')[0]+'_'+tdId.split('_')[1]+'_'+i+'_'+rowSize+'_Total_Value_with_Interest').html();
                  priceWithInterest =	replaceDotByCommma(priceWithInterest);
                    if(isNaN(priceWithInterest)){
                        priceWithInterest = 0;
                    }
                  totalValWithInterest = totalValWithInterest + priceWithInterest;
                }
                  if(isNaN(totalValWithInterest)){
                   totalValWithInterest =0	; 
                }
                 console.log('totalValuewithInterest'+replaceCommmaByDot(totalValWithInterest.toFixed(2)));
                $('#'+divId).html(replaceCommmaByDot(totalValWithInterest.toFixed(2)));
                
            });
          
               /* $(".campaignSubgroup").each(function(){  
                   var id = this.id;
                   var groupId = '';
                   groupId = id.split('-')[1];               
                   var productVol = $("#"+groupId.split('_')[0]+'_'+groupId.split('_')[1]+'_'+groupId.split('_')[2]+'_'+groupId.split('_')[3]+'_Product_Volume').val();
                    if(productVol!='' && productVol>0){
                    groupId = groupId+'_Product_Volume';    
                   helper.onProductVolumeChange(component, event,groupId,'onLoad');
                   }
               });*/
               }       
         function finalUnitPriceReplace(){	
             console.log('final unit Price comma');
        $(".FinalUnitPrice").each(function(){  
         var tagId = this.id;
           
         var tagVal = $('#'+tagId).val();
            //alert(tagVal);
            if(isNaN(tagVal)){
                tagVal = 0;
            }
            $('#'+tagId).val(replaceCommmaByDot(tagVal));
        });
         }		
            function disabledInput(){
                $('input[type=text]').each(function(){  
               var inputId = this.id;
                var inputVal = $('#'+inputId).val();
               //alert(inputVal);
                inputVal = replaceDotByCommma(inputVal);
                
                    //if(!isNaN(inputVal)){
                    // alert(inputVal);
                    $('#'+inputId).prop('disabled', true); 
                //}     
            });
              $('select').each(function(){  
               var inputId = this.id;
                    // alert(inputVal);
                    $('#'+inputId).prop('disabled', true);      
            });
           $('input[type=date]').each(function(){  
               var inputId = this.id;
                var inputVal = $('#'+inputId).val();
               //alert(inputVal);
                if(inputVal){
                    // alert(inputVal);
                    $('#'+inputId).prop('disabled', true); 
                } 
               $("#loader_23").hide(); 
            });      
            
        }
        
           function replaceDotByCommma(replaceVal){
            var str = replaceVal.toString().replace('.','');
            str = str.replace(',','.'); 
            return parseFloat(str);   
        }
    function replaceCommmaByDot(replaceVal){  
         var str = replaceVal.toString().replace('.',',');  
         return str; 
   }                 
        function calculateEqi(){
           var mapPricebook = component.get("v.structureCampWrap.mapofStructureLineItem");
           var anchorVol =$("#001_1_Total_Product_Volume").html() 
           anchorVol = replaceDotByCommma(anchorVol);
               $("tr.campaignSubgroup").each(function(){
                 var id = this.id;
                 var groupId = '';
                 var pricebokId = id.split('-')[0];
                   //alert(pricebokId);
                   //console.log('pricebokId>>>'+pricebokId);
                   groupId = id.split('-')[1];
                  // alert(groupId.split('_')[0]+'_'+groupId.split('_')[1]+'_Volume'); //001_1_1_2_Product_Volume
                   if(groupId.split('_')[2]=='1'){
                     // alert(groupId.split('_')[0]);
                      
                       var returnJsonSOlineItem = JSON.parse(JSON.stringify(mapPricebook[pricebokId])); // findKey(pricebokId, JSONTEST); 
                       
                       //console.log('returnJsonSOlineItem>>>'+JSON.stringify(returnJsonSOlineItem));
                       if(returnJsonSOlineItem != undefined && returnJsonSOlineItem != ''){
                       if(parseInt($("#"+groupId.split('_')[0]+'_'+groupId.split('_')[1]+'_Volume').html())==0 || returnJsonSOlineItem.equivalence>0.00){
                                        
                           var eqi =returnJsonSOlineItem.equivalence; 
                           if(isNaN(eqi)){eqi=0;}
                           //alert(eqi);
                           var newVol = (eqi/100)*anchorVol;
                           //alert(newVol);
                           $("#"+groupId.split('_')[0]+'_'+groupId.split('_')[1]+'_Volume').html(replaceCommmaByDot(newVol.toFixed(2)));
                       }
                       }    
                     
                     // $("#"+groupId.split('_')[0]+'_'+groupId.split('_')[1]+'_Volume').html();
                   //id =id.split('-')[0];
                       
                   }
                   
                });      
       } 
             // component.find("calculate").set("v.disabled",true);
         //$("#loader_23").hide();
           
       // }                
               
   },
   onPressFinalUnitPrice:function(component,event,helper){
       var inputPrdtVol =  event.currentTarget;
       var tdId = inputPrdtVol.getAttribute("id");
       var finalVal = $('#'+tdId).val();
       var finUnitVal = '';
       finUnitVal = finalVal.replace(/[^a-zA-Z0-9,. ]/,'').replace(/([a-zA-Z ])/g,'').trim();
       
       if(isNaN(finalVal.replace('.','').replace(',','.'))  || finalVal == ''){
             if(  finalVal == ''){
              // alert($A.get("$Label.c.Invalid_Final_Unit_Price"));    
           }else{
               //alert($A.get("$Label.c.Invalid_Final_Unit_Price"));    
           }
           finalVal = 0;
       }
       $('#'+tdId).val(finUnitVal);
   },
   onChangeProductVol : function(component,event,helper){
        
       var inputPrdtVol =  event.currentTarget;
       var tdId = inputPrdtVol.getAttribute("id");
       var prdtVol = $('#'+tdId).val();
       prdtVol = prdtVol.replace('.','');
       prdtVol = prdtVol.replace(',','.').trim();
       var trId = $('#'+tdId).parent().parent().parent().attr('id');
       var priceBookDetailId = trId.split("-")[0];
       //var JSONTEST = JSON.parse(JSON.stringify(component.get("v.structureCampWrap.lstStructOrderLineItem")));
       var mapPricebook = component.get("v.structureCampWrap.mapofStructureLineItem");
       var returnJsonObj = JSON.parse(JSON.stringify(mapPricebook[priceBookDetailId]));// helper.findKey(component,priceBookDetailId, JSONTEST);
       console.log('-------------------'+JSON.stringify(returnJsonObj));
       var group=tdId.split("_")[0];
       var subGroup = tdId.split("_")[1];
       var row = tdId.split("_")[2];
       var rowCount = tdId.split("_")[3];
       console.log('Product Volume id>>>'+group+subGroup+row+rowCount);
       if(prdtVol ==0){
           $('#'+group+'_'+subGroup+'_'+row+'_'+rowCount+'_Invoice_Date').val('');
       }
       var skuMultipleOf = 0;   
       if(returnJsonObj!=undefined){
       if(returnJsonObj.multipleOf>0){
           var prdvolum = replaceDotByCommma(prdtVol);
           skuMultipleOf = prdvolum % returnJsonObj.multipleOf;    
       }
       }    
         
       if(skuMultipleOf>0){
       //alert($A.get("$Label.c.Please_Enter_value_in_multiple_of")+' '+returnJsonObj.multipleOf);
           var errorMsg = $A.get("$Label.c.Please_Enter_value_in_multiple_of")+' '+returnJsonObj.multipleOf;
           helper.showWarningToast(component,event,errorMsg);    
           $('#'+tdId).val(0);
       }else{
           
       $("#loader_23").show();
       //$("#fc").focus();
        setTimeout(function() { 
            // $("#fc").focus();
       helper.onProductVolumeChange(component,event,tdId,'onProductChange');
       }, 2); 
       }
       
       
       function replaceDotByCommma(replaceVal){
            var str = replaceVal.toString().replace('.','');
            str = str.replace(',','.'); 
            return parseFloat(str);   
        }
    function replaceCommmaByDot(replaceVal){  
         var str = replaceVal.toString().replace('.',',');  
         return str; 
   }
     
      
   },
   onChangeInvoiceDate : function(component,event,helper){
      var inputInvDate =  event.currentTarget;
      var tdId = inputInvDate.getAttribute("id");
      var selectedDate = $('#'+tdId).val();
      //alert('invoice Date '+selectedDate); 
      var rowIdSplit = tdId.split("_");
      var campgrp = rowIdSplit[0];
      var campSubgrp = rowIdSplit[1];
      var row = rowIdSplit[2];
      var rowCount = parseInt(rowIdSplit[3]); 
      var d = new Date();
      var paymentTermDate = component.get("v.salesOrder.Campaign_Payment_Term_Date__c");
      var maturityDate = component.get("v.salesOrder.Maturity_Date__c");
      var JSONTEST = JSON.parse(JSON.stringify(component.get("v.structureCampWrap.lstStructOrderLineItem")));
      //console.log('------------------------------');
       //console.log(JSONTEST);
       var interestDatestr = JSONTEST[0].interestDate;
       var intrFlag = true; 
       var intrestDate = new Date(interestDatestr);
       //alert(interestDatestr);
        var trid = event.currentTarget.parentElement.parentElement.parentElement.id;
        //console.log('trid>>-->'+trid);
        var priceBookDetailId = trid.split("-")[0];
       var days = 0;
       var errorMsg = '';
       var isError = false;
       var isDays = false;
       //alert(priceBookDetailId);
      var invoiceOrderDate ; 
      // alert(paymentTermDate+'Maturity>>>>'+maturityDate);
       if((paymentTermDate == null || paymentTermDate == undefined) && maturityDate == null){
           days = component.get("v.days");
           //alert(days)
           isDays = true;
       }
       if(!isDays){   
       // alert(paymentTermDate);    
       if(paymentTermDate == '' ){
           invoiceOrderDate = maturityDate;
       }else{
           invoiceOrderDate = paymentTermDate;       
       } 
       }
       if(selectedDate){
           var today = new Date();
           var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
           var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
           var yyyy = today.getFullYear();
           
           // Custom date format for ui:inputDate
           var currentDate = (yyyy + "-" + MM + "-" + dd);
           
           var x = new Date(selectedDate);
           var y = new Date(currentDate); 
           //console.log('+x <= +y: '+(+x <= +y));
           //console.log('x: '+x);
           //console.log('y: '+y);
   
           var day = new Date(selectedDate).getUTCDay();
           //console.log('day'+day);
           
               // is less than today?
           if (+x <= +y) {
               errorMsg = $A.get("$Label.c.Invoice_Date_should_be_greater_than_Today_s_Date");
              isError = true;
           }else if(!isNaN(day)){
               if(invoiceOrderDate){
                   var oneDay = 24*60*60*1000; // hours*minutes*seconds*milliseconds
                   var firstDate = new Date(invoiceOrderDate);
                   var secondDate = new Date(selectedDate);
                   if(secondDate <= intrestDate){
                       days = 0;
                       intrFlag = false;
                   }
                   
                   /*if(secondDate < firstDate && !isDays){ 
                       errorMsg = $A.get("$Label.c.Invoice_Date_should_be_greater_than_Maturity_Date_or_Fixed_Date");
                       isError = true;    
                   }*/
                   var diffDays = Math.round((secondDate.getTime() - firstDate.getTime())/(oneDay));
                       //alert(diffDays);
                        if(diffDays < 0){
                           diffDays = 0;
                       }
                       else{
                           diffDays = diffDays +1;
                       }
                   if(intrFlag==true){
                       days = diffDays;
                      // alert(days);
                   }
                   if(diffDays > 365 && !isDays){
                   errorMsg = $A.get("$Label.c.Date_of_FAT_greater_than_360")+": "+diffDays;
                     isError = true;
                   }
               }
           }
       }
       
       if(isError == false){
       for(var i=0; i<JSONTEST.length ; i++){
           if(JSONTEST[i].combinationkey == priceBookDetailId){
              JSONTEST[i].days = days;
           }
       }
      component.set("v.structureCampWrap.lstStructOrderLineItem",JSONTEST);  
       $("#loader_23").show();
      
        setTimeout(function() { 
           //  $("#fc").focus();
       helper.onProductVolumeChange(component,event,tdId,'onInvoiceChange');
       }, 2); 
           
       }else{
           //alert(errorMsg);
           helper.showWarningToast(component,event,errorMsg);
           $('#'+tdId).val('');
       } 
   },
   onChangeFinalUnitPrice:function(component,event,helper){
      var inputInvDate =  event.currentTarget; 
      var tdId = inputInvDate.getAttribute("id");
      var finalPrice =  $('#'+tdId).val();
      finalPrice = replaceDotByCommma(finalPrice);
      var rowIdSplit = tdId.split("_");
      var campgrp = rowIdSplit[0];
      var campSubgrp = rowIdSplit[1];
      var row = rowIdSplit[2];
      var rowCount = parseInt(rowIdSplit[3]);
      var trId = $('#'+tdId).parent().parent().parent().attr('id');
      var priceBookId = trId.split('-')[0]; 
      var JSONTEST = JSON.parse(JSON.stringify(component.get("v.structureCampWrap.lstStructOrderLineItem")));
      var returnJSONObj = findKey(priceBookId,JSONTEST);
       var pricewithInterest = replaceDotByCommma($('#'+campgrp+'_'+campSubgrp+'_'+row+'_'+rowCount+'_Price_with_Interest').html());
       var managerDiscount = 0;
           if(returnJSONObj.isManDiscount==true){
               managerDiscount = returnJSONObj.manDiscount;
           }
         var totalvaluewithInterest = 0; 
         var managerLimt = (pricewithInterest - (pricewithInterest * (managerDiscount/100))).toFixed(2);
       if( finalPrice < managerLimt){
            $('#'+tdId).val(0);
           errorMsg = $A.get("$Label.c.Invalid_Final_Unit_Price");
           //alert($A.get("$Label.c.Invalid_Final_Unit_Price"));
           helper.showWarningToast(component,event,errorMsg);
            finalPrice = 0;
       }else{
            $('#'+tdId).val(replaceCommmaByDot(finalPrice));
           if(finalPrice != pricewithInterest){
            for(var i=0;i<JSONTEST.length;i++){
               if(JSONTEST[i].combinationkey == priceBookId){
                  JSONTEST[i].isManual = true;
               }
            }
             component.set("v.structureCampWrap.lstStructOrderLineItem",JSONTEST);  
             console.log(JSON.parse(JSON.stringify(component.get("v.structureCampWrap.lstStructOrderLineItem"))));  
           }    
           }
       
        var productVol = $('#' + campgrp + "_"+campSubgrp+"_"+ row+"_"+rowCount+ '_Product_Volume').val();
           totalvaluewithInterest = productVol * finalPrice;  
       if(isNaN(totalvaluewithInterest)){
           totalvaluewithInterest = 0;
       }
       $('#' + campgrp + "_"+campSubgrp+"_"+ row+"_"+rowCount+ '_Total_Value_with_Interest').html(replaceCommmaByDot(totalvaluewithInterest.toFixed(2)));
       var totalFinalPricewithInterest = 0;
       for(var i=1;i<=rowCount;i++){
           var finalPriceWithInterest = $('#' + campgrp + "_"+campSubgrp+"_"+ i+"_"+rowCount+ '_Total_Value_with_Interest').html();
           finalPriceWithInterest = replaceDotByCommma(finalPriceWithInterest);
           if(isNaN(finalPriceWithInterest)){
               finalPriceWithInterest = 0;   
           }
           totalFinalPricewithInterest = totalFinalPricewithInterest + finalPriceWithInterest;
       }
        $('#' + campgrp + "_"+campSubgrp+ '_Total_Value_with_Interest').html(replaceCommmaByDot(totalFinalPricewithInterest.toFixed(2)));
       
           var Total_Product_Volume = 0;
           var Total_Value = 0;
          //alert(colId+'<<<'+rowId+'>>>'+row);
           $("div._Total_Value_with_Interest").each(function(){
               var inputId = this.id;
               var inputval = $('#'+inputId).html();
               inputval = replaceDotByCommma(inputval);
             
               if(isNaN(inputval)){
                   inputval =0;
               }
              //  alert(inputval);
               Total_Value = Total_Value + inputval;
           });
           component.set("v.totalValueWithInterest", Total_Value);
       
       function findKey(key, JSONObj) { //method to find key in JSON
               for (var i = 0; i < JSONObj.length; i++) {
                  // console.log(JSON.stringify(JSONObj[i]).indexOf(key))
                   if (JSON.stringify(JSONObj[i]).indexOf(key) >= 0) {
                       return JSONObj[i];
                   }
               }
           }
     
       function replaceDotByCommma(replaceVal){
            var str = replaceVal.toString().replace('.','');
            str = str.replace(',','.'); 
            return parseFloat(str);   
        }
    function replaceCommmaByDot(replaceVal){  
         var str = replaceVal.toString().replace('.',',');  
         return str; 
   }
       //alert(trId); 
   },
   saveSalesOrder : function(component,event,helper){
    var structSalesOrderWrap = component.get("v.structureCampWrap");
    var currncy = component.get("v.salesOrder.CurrencyIsoCode");
    var isPronutiva = component.get("v.salesOrder.Pronutiva__c");
    var mvar = "";
    var JSONTEST = JSON.parse(JSON.stringify(component.get("v.structureCampWrap.lstStructOrderLineItem")));
       //console.log('------------------Before---------');
       //console.log('JSON>>>',JSONTEST);
       function findAndReplace(object, value, replacevalue,field){
           for(var x in object){
           if(typeof object[x] == typeof {}){
             findAndReplace(object[x], value, replacevalue,field);
           }
           if(object[x] == value){ 
             object[field] = replacevalue;
               
              break;
               //return object[x]			   
           }
         }
         
       }
          
var errorFlag = false;
var errorMsg='';  
var isSingleEntry = false; 
var returnVal = true;  
var procountB = 0;
var procountO = 0;
var saveDataJSONList = [];

   $("tr.campaignSubgroup").each(function(){
   //alert(groupId);       
   var id = this.id;
   var groupId = '';
   groupId = id.split('-')[1];
   var comKey = id.split('-')[0]; 
   var returnJsonObj ={};
       
   //console.log(groupId.split('_')[0]+'_'+groupId.split('_')[1]+'_Volume'); //001_1_1_2_Product_Volume
   //console.log($("#"+groupId.split('_')[0]+'_'+groupId.split('_')[1]+'_Volume').html());
   id =id.split('-')[0];
  // alert('Invoice Date>>--->'+$("#"+groupId+"_Invoice_Date").val());  
      if($("#"+groupId+"_Product_Volume").val()!='' && $("#"+groupId+"_Product_Volume").val()!=0 ){  
           isSingleEntry = true;
          if(isPronutiva){
                  returnJsonObj = findKey(comKey,JSONTEST);
                  if(returnJsonObj.skuCategory == 'BIOLOGICALS & NUTRITION'){
                      procountB++;
                  }else{
                      procountO++;
                  } 
          }
          if($("#"+groupId+"_culture").val()!='None'){
        
     // alert('inside culture');
        if($("#"+groupId+"_Product_Volume").val()=='' || $("#"+groupId+"_Product_Volume").val()==0 ){
             
            errorFlag = true;
             errorMsg = $A.get("$Label.c.Please_Enter_product_volume");
           
        }else{
            if($("#"+groupId+"_Invoice_Date").val()=='' ||$("#"+groupId+"_Invoice_Date").val()==0 ){
             errorFlag = true;
             errorMsg = $A.get("$Label.c.Please_Enter_Invoice_Date");
             
            }else{
                if($("#"+groupId+"_Final_Unit_Price").val()=='' ||$("#"+groupId+"_Final_Unit_Price").val()==0 ){
             errorFlag = true;
             errorMsg = $A.get("$Label.c.Please_Enter_Final_Unit_Price");
               
               }	
            }
        }
   //findAndReplace(JSONTEST,id,groupId.split('_')[0],"campGrp");//object,id to found,value,field name
   //findAndReplace(JSONTEST,id,$("#"+groupId+"_campaignSubgroup").html(),"camSubgrp");//object,id to found,value,field name
   var saveDataJSON = new Object();
   try{  
   //console.log('JSONTEST---',JSONTEST);
   saveDataJSON =  findKey(id,JSONTEST);                   
   saveDataJSON.cultureDesc = $("#"+groupId+"_culture").val();
   saveDataJSON.UOM = $("#"+groupId+"_uom").html();
   saveDataJSON.volume = replaceDotByCommma($("#"+groupId.split('_')[0]+'_'+groupId.split('_')[1]+'_Volume').html());
   saveDataJSON.intialPrice = replaceDotByCommma($("#"+groupId+"_Intial_Price-"+currncy).html());
   saveDataJSON.prdctVol = replaceDotByCommma($("#"+groupId+"_Product_Volume").val());
   saveDataJSON.totalVal = replaceDotByCommma($("#"+groupId+"_Total_Value").html());
   saveDataJSON.invoiceDate = $("#"+groupId+"_Invoice_Date").val();
   saveDataJSON.grpDiscount=replaceDotByCommma($("#"+groupId.split('_')[0]+"_Group_Discount").html());
   saveDataJSON.priceWithInterest = replaceDotByCommma($("#"+groupId+"_Price_with_Interest").html());
   saveDataJSON.FinalUnitPrice = replaceDotByCommma($("#"+groupId+"_Final_Unit_Price").val());
   saveDataJSON.volDifference =$("#"+groupId.split('_')[0]+'_'+groupId.split('_')[1]+'_Volume_Difference').html();
   saveDataJSON.totalValStr =$("#"+groupId+"_Total_Value").html();    
   saveDataJSON.totalValWithInterestStr=$("#"+groupId+"_Total_Value_with_Interest").html();
   saveDataJSON.priceWithInterestStr =$("#"+groupId+"_Price_with_Interest").html();
   saveDataJSON.discountedInitialPriceStr = $("#"+groupId+"_Initial_Price_R").html();
   saveDataJSON.totalValWithInterest = replaceDotByCommma($("#"+groupId+"_Total_Value_with_Interest").html());
   saveDataJSON.isTrue = true;            
    saveDataJSONList.push(saveDataJSON);
   
              }catch(e){
                  console.log('saveDataJSON',e);
   console.log('saveDataJSON',saveDataJSON)               
              }          
              
    /*          findAndReplace(JSONTEST,id,$("#"+groupId+"_SkuName").html(),"skuDesc");//object,id to found,value,field name
   findAndReplace(JSONTEST,id,$("#"+groupId+"_culture").val(),"cultureDesc");//object,id to found,value,field name
   findAndReplace(JSONTEST,id,$("#"+groupId+"_uom").html(),"UOM");//object,id to found,value,field name
   findAndReplace(JSONTEST,id,$("#"+groupId.split('_')[0]+'_'+groupId.split('_')[1]+'_Volume').html(),"volume");//object,id to found,value,field name
   findAndReplace(JSONTEST,id,replaceDotByCommma($("#"+groupId+"_Intial_Price-"+currncy).html()),"intialPrice");//object,id to found,value,field name
   findAndReplace(JSONTEST,id,replaceDotByCommma($("#"+groupId+"_Product_Volume").val()),"prdctVol");//object,id to found,value,field name
   //findAndReplace(JSONTEST,id,parseFloat($("#"+groupId+"_Intial_Price-"+currncy).html()),"intialPrice");//object,id to found,value,field name
   findAndReplace(JSONTEST,id,replaceDotByCommma($("#"+groupId+"_Total_Value").html()),"totalVal");//object,id to found,value,field name
   findAndReplace(JSONTEST,id,$("#"+groupId+"_Invoice_Date").val(),"invoiceDate");//object,id to found,value,field name
   findAndReplace(JSONTEST,id,replaceDotByCommma($("#"+groupId.split('_')[0]+"_Group_Discount").html()),"grpDiscount");//object,id to found,value,field name
   findAndReplace(JSONTEST,id,replaceDotByCommma($("#"+groupId+"_Price_with_Interest").html()),"priceWithInterest");//object,id to found,value,field name
   findAndReplace(JSONTEST,id,replaceDotByCommma($("#"+groupId+"_Final_Unit_Price").val()),"FinalUnitPrice");//object,id to found,value,field name
   findAndReplace(JSONTEST,id,replaceDotByCommma($("#"+groupId+"_Total_Value_with_Interest").html()),"totalValWithInterest");//object,id to found,value,field name
   findAndReplace(JSONTEST,id,true,"isTrue");*/
     
          }else{
                errorMsg =$A.get("$Label.c.Please_select_Culture");
              errorFlag = true;
          }
  }     /*else{
        
        errorFlag='false';
          errorMsg = 'Please select Culture';
    }     
   */
   //volume diff
   //console.log('-----------------After JSON------------------'); 
   //console.log(JSON.parse(JSON.stringify(JSONTEST)));
   
});
      //alert(procountB+'---'+procountO+'---'+isPronutiva);
        if(isPronutiva){
           if(procountB ==0 || procountO==0){
               errorFlag = true;
           var toastEvent = $A.get("e.force:showToast");
           if (toastEvent!=undefined){
           var msg  = $A.get("{!$Label.c.If_Pronutiva_Yes_Then_Check_Category}");
           var titl  = $A.get("{!$Label.c.Error}");
           toastEvent.setParams({
               "title": titl,
               "type": "Error",
               "message": msg,
               "duration":'3000'
           });
           toastEvent.fire();   
           }else{
               alert(msg);
           }
           }    
       }    
   function findKey(key, JSONObj) { //method to find key in JSON
               for (var i = 0; i < JSONObj.length; i++) {
                   //console.log(JSON.stringify(JSONObj[i]).indexOf(key))
                   if (JSON.stringify(JSONObj[i]).indexOf(key) >= 0) {
                       return JSONObj[i];
                   }
               }
           }    
   function replaceDotByCommma(replaceVal){
            var str = replaceVal.toString().replace('.','');
            str = str.replace(',','.'); 
            return parseFloat(str);   
        }    
   if(errorFlag == false && errorMsg==''){
        //console.log('final save',saveDataJSONList.length);
       //console.log('saveDataJSON',saveDataJSONList);	 
       component.set("v.structureCampWrap.saveListStructOrderLineItem",saveDataJSONList);
        component.set("v.salesOrder.TotalValueWithoutInterest__c",component.get("v.totalValueWithInterest"));
        //console.log('sales order Item',JSON.stringify(component.get("v.structureCampWrap.saveListStructOrderLineItem")));
        var totalGrpDiscount = $("#Group_all_discount").html();
        component.set("v.salesOrder.Total_Group_Discount__c",totalGrpDiscount);
         
   }
       if(errorMsg!=''){
        returnVal = false;   
       var toastEvent = $A.get("e.force:showToast");
       if (toastEvent!=undefined){
       toastEvent.setParams({
             title : $A.get("{!$Label.c.Warning}"),
           message:errorMsg,
           duration:' 3000',
           key: 'info_alt',
           type: 'Warning',
           mode: 'dismissible'
       });
       toastEvent.fire();
       }else{
           alert(errorMsg);
           /*sforce.one.showToast({
                       "title": $A.get("{!$Label.c.Warning}"),
                       "message":errorMsg,
                        "type": "warning"
                   });*/
       } 
   }
       if(!isSingleEntry){
            var toastEvent = $A.get("e.force:showToast");
         if (toastEvent!=undefined){   
       toastEvent.setParams({
             title : $A.get("{!$Label.c.Warning}"),
           message:$A.get("{!$Label.c.Please_Make_at_least_one_entry}"),
           duration:' 3000',
           key: 'info_alt',
           type: 'Warning',
           mode: 'dismissible'
       });
       toastEvent.fire();
         }else{
             var error = $A.get("{!$Label.c.Please_Make_at_least_one_entry}");
             alert(error);
            /*  sforce.one.showToast({
                       "title": $A.get("{!$Label.c.Warning}"),
                       "message":error,
                        "type": "warning"
                   });*/
         }   
       }    
       //console.log(JSONTEST);
       if(!isSingleEntry || errorFlag){
           returnVal = false;
       }
       //alert(returnVal);
      return returnVal;
   },
   editSalesOrder : function(component,event,helper){
         component.set("v.disableSave",false);
       component.set("v.disableEdit",false);
        $("#loader_23").show();
             // $("#fc").focus();
        setTimeout(function(){ 
               //$("#fc").focus();
               enableAllInput();
          }, 2);
       function enableAllInput(){
             $('input.productVol').each(function(){  
               var inputId = this.id;
               var inputVal = $('#'+inputId).val();
               $('#'+inputId).prop('disabled', false);      
            });
           $(".FinalUnitPrice").each(function(){
             var inputId = this.id;
               var inputVal = $('#'+inputId).val();
               //alert('final>>>'+inputVal);
               if(inputVal>0){
                   //alert();
                   $('#'+inputId).prop('disabled', false);       
               }
               
           });
             $('input[type=date]').each(function(){  
               var inputId = this.id;
                var inputVal = $('#'+inputId).val();
               //alert(inputVal);
                if(inputVal){
                    // alert(inputVal);
                    $('#'+inputId).prop('disabled', false); 
                }     
            });      
              $('select').each(function(){  
               var inputId = this.id;
               var inputVal = $('#'+inputId).val();
               $('#'+inputId).prop('disabled',false);      
            }); 
           $("#loader_23").hide();
          
       }
      
       
   }
})