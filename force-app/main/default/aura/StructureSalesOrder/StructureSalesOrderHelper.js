({
    
    onProductVolumeChange: function(component,event,tdId,callFrom){
       	
         
       // this.showSpinner(component,event);
       	 var firstExecuted = true;
         var currncy = component.get("v.salesOrder.CurrencyIsoCode");
        var trId = $('#'+tdId).parent().parent().parent().attr('id');
        //alert(trId);
         var priceBookDetailId = trId.split("-")[0];
        //alert('trId>>--->'+trId);
        var rowIdSplit = tdId.split("_");
        var campgrp = rowIdSplit[0];
        var campSubgrp = rowIdSplit[1];
        var row = rowIdSplit[2];
        var rowCount = parseInt(rowIdSplit[3]);
        var list = component.get("v.structureCampWrap.listCampaignGroupWrap");
         var colCount = list.length;
        //alert('onProductVolumeChange>>--->'+tdId);
        //console.log('Group JSON');
        var mapCampgrp = component.get("v.structureCampWrap.mapofCampaignGroup");
        var JSONTEST = JSON.parse(JSON.stringify(component.get("v.structureCampWrap.lstStructOrderLineItem")));
       	var mapPricebook = component.get("v.structureCampWrap.mapofStructureLineItem");
       // console.log(JSONTEST);
        //console.log('QTY>>>>'+mapCampgrp["001"].Required_sub_group_Qty__c);
     	var gropupJSON =JSON.parse(JSON.stringify(component.get("v.structureCampWrap.mapofCampaignGroup")));
        //console.log(gropupJSON);
        var isLimitVol = gropupJSON[campgrp].Limited_volume__c;
       // if(callFrom == 'onInvoiceChange'){
       		 calculatetotalproductVol(campgrp,campSubgrp,row);
            var pdctvolDif = checkProductVolume(campgrp,campSubgrp,row);
        	 calculateIntialPrice(campgrp,campSubgrp,row);	 
             calculatePriceWithInterest(campgrp,campSubgrp,row,rowCount);
             calculateTotalValue(campgrp,campSubgrp,row);
                calculateTotalValueSum(campgrp,campSubgrp,row,rowCount);
             calculateTotalValuewithInterest(campgrp,campSubgrp,row,rowCount);
             calculateFinal_Unit_Price(campgrp,campSubgrp,row,rowCount);
             calculateTotalValuewithInterest(campgrp,campSubgrp,row,rowCount);
             calculateTotalValuewithInterestSum(campgrp,campSubgrp,row,rowCount);
             calculateTotalValuewithInterestAllSum(campgrp,campSubgrp,row);
      //  }else{
           
            
            /*if(isLimitVol == false ){ 
                calculateTotalValue(campgrp,campSubgrp,row);
                calculateTotalValueSum(campgrp,campSubgrp,row,rowCount);
                calculateTotalValuewithInterestSum(campgrp,campSubgrp,row,rowCount);
                calculateTotalValuewithInterestAllSum(campgrp,campSubgrp,row);
            }else if(pdctvolDif<=0){
                calculateTotalValue(campgrp,campSubgrp,row);
                calculateTotalValueSum(campgrp,campSubgrp,row,rowCount);
                console.log('Product Volume Diff'+pdctvolDif+'---------------'+campgrp+campSubgrp+row);
                calculateTotalValuewithInterestSum(campgrp,campSubgrp,row);
                calculateTotalValuewithInterestAllSum(campgrp,campSubgrp,row,rowCount);
            }
                            
       // }   */

    function calculatetotalproductVol(colId,campSubgrp,row){
        var Total_Product_Volume = 0;
        var Product_Volume = 0;
        for (var i = 1; i <= rowCount; i++){
            //1_1_1_2_Product_Volume
            Product_Volume = parseInt($('#' + colId + "_"+campSubgrp+"_"+ i+"_"+rowCount+ '_Product_Volume').val());
            Product_Volume = replaceDotByCommma(Product_Volume);
            //alert('Product volume>>===>'+Product_Volume);
            if (isNaN(Product_Volume)) {
                Product_Volume = 0;
            }
            Total_Product_Volume = Total_Product_Volume + Product_Volume;
        }
		
        // $('#' + colId +"_"+campSubgrp+ '_Total_Product_Volume').html('');
        $('#' + colId +"_"+campSubgrp+ '_Total_Product_Volume').html(replaceCommmaByDot(Total_Product_Volume.toFixed(2)));
        
    }
     //done   
     function calculateTotalValue(colId, rowId,row){
        var Total_Product_Volume = 0;
        var Product_Volume=0;
        var Intial_Price =0;
      var i=rowId;
         	//console.log('calculateTotalValue >>-->'+$('#' + colId + "_"+i+"_"+ row+"_"+rowCount+ '_Intial_Price'+'-'+currncy).html());
            Intial_Price = $('#' + colId + "_"+i+"_"+ row+"_"+rowCount+ '_Intial_Price'+'-'+currncy).html(); //.replace(',',''));
			//Intial_Price = replaceDotByCommma(Intial_Price);
        //console.log('#' + colId + "_" + i + '_Intial_Price'+'---> '+$('#' + colId + "_" + i + '_Product_Volume').val()); //.replace(',',''))
            Product_Volume = $('#' + colId + "_"+i+"_"+ row+"_"+rowCount+'_Product_Volume').val();
         	Product_Volume = replaceDotByCommma(Product_Volume);
			//console.log(Intial_Price+'<<<Intial_Price>>>'+Product_Volume);
            if (isNaN(Intial_Price)) {
                Intial_Price = 0;
            }
            if (isNaN(Product_Volume)) {
                Product_Volume = 0;
            }
            Total_Product_Volume = Product_Volume * Intial_Price ;
         	
        
         	//alert('total>>--->'+Total_Product_Volume);   
         $('#' + colId + "_"+i+"_"+ row+"_"+rowCount+'_Total_Value').html((replaceCommmaByDot(Total_Product_Volume.toFixed(2))));


    }
                //done  .
        function calculateEqi(){
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
                function checkProductVolume(colId, rowId,row) {
                    var tagClass =  $('#'+tdId).parent().parent().attr('class');
        			if(tagClass == 'SIMSku'){
                       // alert(tagClass);
         			  calculateEqi(); 
        			}
                    var Volume = $('#' + colId+'_'+rowId+'_Volume').text(); //.replace(',', ''));
                    Volume = replaceDotByCommma(Volume);
                    var Product_Volume = $('#' + colId + "_" + rowId+'_'+ row+'_'+rowCount+'_Product_Volume').val();
                    Product_Volume = replaceDotByCommma(Product_Volume);
                    var volume_diff = $('#' + colId +'_'+rowId+'_Volume_Difference').html();
                    volume_diff = replaceDotByCommma(volume_diff);
                    var Total_Product_Volume = $('#' + colId +'_'+rowId+'_Total_Product_Volume').html();
                    Total_Product_Volume = replaceDotByCommma(Total_Product_Volume);
                    if (isNaN(Volume)) {
                        Volume = 0;
                    }
                    if (isNaN(Product_Volume)) {
                        Product_Volume = 0;
                    }
                    if (isNaN(volume_diff)) {
                        volume_diff = 0;
                    }
                    if (isNaN(Total_Product_Volume)) {
                        Total_Product_Volume = 0;
                    }
                    volume_diff = Total_Product_Volume - Volume  ;
                
                  // alert(isLimitVol);  
             if(volume_diff<0){
                       $('#' + colId +'_'+rowId+'_Volume_Difference').html(replaceCommmaByDot(volume_diff.toFixed(2)));
                       $('#' + colId +'_'+rowId+'_Volume_Difference').css("color", "red");
                     
        }else{
        if(isLimitVol==true && volume_diff>0){
        //alert($A.get("$Label.c.Limited_Volume"));
        var toastEvent = $A.get("e.force:showToast"); 
        var error = $A.get("$Label.c.Warning");
        if (toastEvent!=undefined){
            toastEvent.setParams({
                title: error,
                mode: 'dismissible',
                type: 'warning',
                message: $A.get("$Label.c.Limited_Volume")
            });
            toastEvent.fire();
        }
        else{ // otherwise throw an alert
            /*sforce.one.showToast({
                        "title": error,
                        "message":$A.get("$Label.c.Limited_Volume"),
                         "type": "warning"
                    });*/
            var errorMsg = $A.get("$Label.c.Limited_Volume");
            alert(errorMsg);
        }
                           //this.showWarningToast(component,event,$A.get("$Label.c.Limited_Volume"));
                          $('#' + colId + "_" + rowId+'_'+ row+'_'+rowCount+'_Product_Volume').val(0);
                          $('#' + colId + "_" + rowId+'_Volume_Difference').html(0);
                          //alert('#' + colId + "_" + rowId+'_'+ row+'_'+rowCount+'_Total_Value');
                          $('#' + colId + "_" + rowId+'_'+ row+'_'+rowCount+'_Total_Value').html(0);
                          $('#' + colId + "_" + rowId+'_Total_Value').html(0);
                          $('#' + colId + "_" + rowId+'_'+ row+'_'+rowCount+'_Initial_Price_R').html(0);
                          $('#' + colId + "_" + rowId+'_Total_Value_with_Interest').html(0);
                          $('#' + colId + "_" + rowId+'_'+ row+'_'+rowCount+'_Price_with_Interest').html(0);
                         // $('#' + colId + "_" + rowId+'_'+ row+'_'+rowCount+'_Total_Value_with_Interest').html(0); 
                          document.getElementById(colId + "_" + rowId+'_'+ row+'_'+rowCount+'_Total_Value_with_Interest').innerHTML = 0;  
                          $('#' + colId + "_" + rowId+'_'+ row+'_'+rowCount+'_Final_Unit_Price').val(0);  
                            
                           // calculatetotalproductVol(colId);//recalculate total product vol.
                     }else{
                       //$('#' + colId +'_'+rowId+'_Volume_Difference').html(replaceCommmaByDot(volume_diff.toFixed(2)));
                        document.getElementById(colId +'_'+rowId+'_Volume_Difference').innerHTML = replaceCommmaByDot(volume_diff.toFixed(2)); 
                         $('#' + colId +'_'+rowId+'_Volume_Difference').css("color", "black");
                     }
                    }
                  
                    
                     calculatetotalproductVol(colId,rowId,row);//recalculate total product vol.
                     
                    if(isLimitVol == false){
                     //alert(isLimitVol);   
                   	$('#' + colId +'_Volume_Difference').html(replaceCommmaByDot(volume_diff.toFixed(2)));
                   //document.getElementById(colId + '_Volume_Difference').innerHTML = replaceCommmaByDot(volume_diff.toFixed(2)); 
                    /*Check data from group setting using JSON*/
                    CalculateGroupDiscount(colId,rowId,row);
                   calculateTotalPerTop(colId,rowId,row);
                    calculateIntialPrice(colId,rowId,row);
                    calculatePriceWithInterest(colId,rowId,row,rowCount);
                    enableInvoiceDate(colId,rowId,row);
                    enableFinalUnitPrice(colId,rowId,row);
                    calculateTotalValuewithInterest(colId,rowId,row,rowCount);
                    calculateTotalValueSum(colId,rowId,row,rowCount);
                    calculateTotalValuewithInterestSum(colId,rowId,row,rowCount);
                    calculateTotalValuewithInterestAllSum(colId,rowId,row);
                    }else if(volume_diff<=0){
                         //$('#' + colId +'_Volume_Difference').html(replaceCommmaByDot(volume_diff.toFixed(2)));
                    //document.getElementById(colId + '_Group_Discount').innerHTML = replaceCommmaByDot(volume_diff.toFixed(2)); 
                    calculateTotalValueSum(colId,rowId,row,rowCount);
                    calculateTotalValuewithInterestSum(colId,rowId,row,rowCount);
                    
                    /*Check data from group setting using JSON*/
                    CalculateGroupDiscount(colId,rowId,row);
                    calculateTotalPerTop(colId,rowId,row);
                    calculateIntialPrice(colId,rowId,row);
                    calculatePriceWithInterest(colId,rowId,row,rowCount);
                    enableInvoiceDate(colId,rowId,row);
                    enableFinalUnitPrice(colId,rowId,row);
                    calculateTotalValuewithInterest(colId,rowId,row,rowCount);
                    calculateTotalValueSum(colId,rowId,row);
                    calculateTotalValuewithInterestSum(colId,rowId,row,rowCount);
                      
                    } 
                    $("#spinner").hide();
                    return volume_diff;
                 }
             //done       
            function enableInvoiceDate(colId,rowId,row){
                var productVol =   $('#' + colId + "_"+rowId+"_"+ row+"_"+rowCount+ '_Product_Volume').val();
                if(isNaN(productVol )){productVol =0;}
                if(productVol!=0){
                   // $('#' + colId + "_" + rowId + '_Invoice_Date').prop('readonly', true);
                    $('#' + colId + "_"+rowId+"_"+ row+"_"+rowCount+ '_Invoice_Date').prop('disabled', false);
                    //alert('checked');
                }else{
                   // $('#' + colId + "_" + rowId + '_Invoice_Date').prop('readonly', true);
                    $('#' + colId + "_"+rowId+"_"+ row+"_"+rowCount+ '_Invoice_Date').prop('disabled', true);
                    //alert('not checked');
                }
            }
            function CalculateGroupDiscount(colId,rowId,row){
             
                 var returnJsonGroup =JSON.parse(JSON.stringify(mapCampgrp[colId])); //findKey(colId, gropupJSON);
                // var returnJsonSOlineItem = JSON.parse(JSON.stringify(mapPricebook[pricebokId])); //findKey(colId, JSONTEST);
                 var volDiff = $('#' + colId + "_"+rowId+"_Volume_Difference").html();
                 volDiff = replaceDotByCommma(volDiff);
                 var anchorVolDiff = 0 ;
               // 001_1_1_3_campaignSubgroup
                 var className = $('#' + colId + "_"+rowId+"_"+ row+"_"+rowCount+"_campaignSubgroup").attr('class');
                // var subgroupReq = $('#' + colId + "_"+rowId+"_"+ row+"_"+rowCount+"_campaignSubgroup").attr('req');
                
                var subgrpCount = className.split("_")[1];
                var isReqSubgrp = false;
                var applyDiscount = false;
                var prdtVolDiff = 0;
                var isreqCount = 0;//how many from group + isRequired from price book Detail
                var mandSubgroups = 0;//how many from group
                mandSubgroups = returnJsonGroup.Required_sub_group_Qty__c;
                //alert(mandSubgroups);
               /* if(mandSubgroups > subgrpCount){
                	mandSubgroups = 0;    
                }*/
                 for(var i=1; i<=subgrpCount; i++){
                       
                        var volclassName = $('#'+colId+'_'+i+'_Volume').attr('class'); 
                        var isSimSubgrp = volclassName.split('_')[3]; 
                        if(isSimSubgrp=='Sim'|| isSimSubgrp=='SIM'){
                       
                        prdtVolDiff = $('#'+colId+'_'+i+'_Volume_Difference').html(); 
                        prdtVolDiff = replaceDotByCommma(prdtVolDiff);
                           // alert(prdtVolDiff);
                             if(isNaN(prdtVolDiff)){
                                 prdtVolDiff =-1;
                             }
                             if(prdtVolDiff>=0){
                                 isReqSubgrp = true;
                                 isreqCount++;
                             }else{
                                 // alert('totalPrdtVol'+prdtVolDiff);
                                 isReqSubgrp = false; 
                                 break;
                             }
                         }else{
                             	 prdtVolDiff = $('#'+colId+'_'+i+'_Volume_Difference').html(); 
                        		 prdtVolDiff = replaceDotByCommma(prdtVolDiff);
                            	 //alert(totalPrdtVol);
                             	 if(isNaN(prdtVolDiff)){
                                 	prdtVolDiff = -1;
                             	 }
                                 if(prdtVolDiff>=0){
                                   isreqCount++;
                                   isReqSubgrp = true;
                             	 }else{
                                if(isreqCount != mandSubgroups){  
                                 isReqSubgrp = false;  
                                }/*else{
                                   isReqSubgrp = true;   
                                }*/
                             }
                            
                             }     
                 }
                console.log('mandSubgroups>>--->'+mandSubgroups);
                console.log('isreqCount>>--->'+isreqCount);
                if(isreqCount < mandSubgroups){
                    isReqSubgrp = false;
                }else if(isreqCount == mandSubgroups){
                    	 //alert('isReqSubgrp ==>>--->'+isReqSubgrp);
                      	isReqSubgrp = true;
                    	applyDiscount = true;
                }
                
                 //alert('isReqSubgrp>>--->'+isReqSubgrp);
                 var anchorDiscount=0;
                if(isNaN(anchorDiscount)){
                    anchorDiscount = 0;
                }
                 
                var satisfyAnchor = $("output.SIMmakeZero").val();
                var anchorVolDiff = -1;
               //
               //  alert(satisfyAnchor);
                var groupId =''; 
                var subgrpno ='';
              
                var applidAnchorDiscount = $("output.SIMmakeZero").val();        
                
                     anchorDiscount =  $('#001_Group_Discount').html();
                	//alert('anchorDiscount>>>'+anchorDiscount);
                     anchorDiscount = replaceDotByCommma(anchorDiscount);
                 if(isNaN(anchorDiscount)){
                    anchorDiscount = 0;
                }
                	//alert('anchorDiscount>>>'+anchorDiscount);	
                     anchorVolDiff = $("#001_1_Volume_Difference").html();
                       //alert('anchorVolDiff>>--->'+anchorVolDiff);
                     anchorVolDiff = replaceDotByCommma(anchorVolDiff);
               // alert('anchorVolDiff>>--->'+anchorVolDiff);
                if(isNaN(anchorVolDiff)){
                    anchorVolDiff = -1;
                }
                if(anchorDiscount>0){
                    firstExecuted = false;
                }
                if(firstExecuted){
                 // alert(anchorVolDiff);  
                if(returnJsonGroup.Do_not_generate_group_discount__c==false && volDiff >= 0 && anchorVolDiff>=0 && isReqSubgrp){
                     //$('#' + colId + '_Group_Discount').html(replaceCommmaByDot(returnJsonGroup.Group_Discount__c));
                      document.getElementById(colId + '_Group_Discount').innerHTML = replaceCommmaByDot(returnJsonGroup.Group_Discount__c);
                    CalculateGroupDiscount1(colId,rowId,row);
              
                }else{
                    //alert();
                    //$('#' + colId + '_Group_Discount').html(0);
                     document.getElementById(colId + '_Group_Discount').innerHTML = 0; 
                    $('output.NAOmakeZero').each(function(){
                       groupId = this.id.split('_')[0];
                      //$('#' + groupId + '_Group_Discount').html(0); 
        			 document.getElementById(groupId + '_Group_Discount').innerHTML = 0; 
                    });
                    //alert('inside else'+volDiff);
                }
                }else if(returnJsonGroup.Do_not_generate_group_discount__c==false && (volDiff>=0 || applyDiscount) && anchorDiscount>0 && isReqSubgrp){   
                   // $('#' + colId + '_Group_Discount').html(replaceCommmaByDot(returnJsonGroup.Group_Discount__c));
                	 document.getElementById(colId + '_Group_Discount').innerHTML = replaceCommmaByDot(returnJsonGroup.Group_Discount__c);
                	console.log('colId>>--->'+$('#002_Group_Discount').html()); 
                    console.log('Group Discount >>--->'+replaceCommmaByDot(returnJsonGroup.Group_Discount__c));
                }else if(anchorVolDiff>0){
                    //$('#' + colId + '_Group_Discount').html(0);
                    document.getElementById(colId + '_Group_Discount').innerHTML = 0; 
                    console.log('colId>>--->'+$('#002_Group_Discount').html()); 
                }else if(anchorVolDiff<0){
                   // $('#' + colId + '_Group_Discount').html(0);
                    document.getElementById(colId + '_Group_Discount').innerHTML = 0; 
                     $('output.NAOmakeZero').each(function(){
                       groupId = this.id.split('_')[0];
                      //$('#' + groupId + '_Group_Discount').html(0); 
                      document.getElementById(groupId + '_Group_Discount').innerHTML = 0;     
                    });
                    console.log('colId else if anchor >>--->'+$('#002_Group_Discount').html()); 
                }
                       		
          }
    //done    
    		 function CalculateGroupDiscount1(colId,rowId,row){
                 $("div.NAOvolDiff").each(function(){ 
                    
                 	  var id = this.id;
                      var volDiffVal = $('#'+id).html();
                      volDiffVal = replaceDotByCommma(volDiffVal);
                      var trId = $('#'+id).parent().parent().attr('id');
                      var grpId = trId.split('-')[1];
                      var grp = grpId.split('_')[0];
                      var returnJsonGroup =JSON.parse(JSON.stringify(mapCampgrp[grp]));
                      
                     if(volDiffVal>=0){
                     //alert(returnJsonGroup.Group_Discount__c);
                        //$('#' + grp	 + '_Group_Discount').html(replaceCommmaByDot(returnJsonGroup.Group_Discount__c)); 
                       document.getElementById(grp+ '_Group_Discount').innerHTML = replaceCommmaByDot(returnJsonGroup.Group_Discount__c);  
                       console.log('group discount 1 >>---->'+replaceCommmaByDot(returnJsonGroup.Group_Discount__c));	 
                     }
                 });

             }	 
        
            function enableFinalUnitPrice(colId,rowId,row){
              
                    var productVol =   $('#' + colId + "_"+rowId+"_"+ row+"_"+rowCount+ '_Product_Volume').val();
                    productVol =replaceDotByCommma(productVol);
                    if(isNaN(productVol )){productVol =0;}
                    if(productVol!=0){
                        // $('#' + colId + "_" + rowId + '_Invoice_Date').prop('readonly', true);
                        $('#' + colId + "_"+rowId+"_"+ row+"_"+rowCount+ '_Final_Unit_Price').prop('disabled', false);
                          if(callFrom !='onLoad'){
                        calculateFinal_Unit_Price(colId,rowId,row,rowCount);
                          }else{
                            var finalPrice =  $('#' + colId + "_"+rowId+"_"+ row+"_"+rowCount+ '_Final_Unit_Price').val();
                          	  $('#' + colId + "_"+rowId+"_"+ row+"_"+rowCount+ '_Final_Unit_Price').val(replaceCommmaByDot(finalPrice));
                          }
                    }else{
                        // $('#' + colId + "_" + rowId + '_Invoice_Date').prop('readonly', true);
                        $('#' + colId + "_"+rowId+"_"+ row+"_"+rowCount+'_Final_Unit_Price').prop('disabled', true);
                        $('#' + colId + "_"+rowId+"_"+ row+"_"+rowCount+'_Final_Unit_Price').val(0);
                        //alert('not checked');
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
            //need to modify
            function  calculateTotalPerTop(colId,rowId,row) {
        
                //Group_all_discount
                var totalPer = 0;
                
                for(var i=1;i<=colCount;i++){
                 var grpDiscount = parseFloat($('#00' +i+'_Group_Discount').html());
                    if(isNaN(grpDiscount)){
                        grpDiscount =0;
                    }
                    /*if(i==1 && grpDiscount>0){
                        CalculateGroupDiscount1(colId,rowId,row);
                    }*/
                    totalPer = totalPer + grpDiscount;  
                }
                //console.log('totalPer'+totalPer+'colCount'+colCount);  
                $('#Group_all_discount').html(totalPer);
            }
			//done
          function calculateIntialPrice(colId, rowId,row){
          
              var percent = $('#Group_all_discount').html();
              if($("#"+colId+'_'+rowId+'_'+row+'_'+rowCount+"_Product_Volume").val() == 0){
                 $('#'+colId+'_'+rowId+'_'+row+'_'+rowCount+'_Initial_Price_R').html(0);  
              }{
  				$("tr.campaignSubgroup").each(function(){  
                    var id = this.id;
                    var groupId = '';
                    groupId = id.split('-')[1];               
                    var productVol = $("#"+groupId+"_Product_Volume").val();
                    if(productVol>0){
                      var initialPrice = $("#"+groupId+"_Intial_Price"+"-"+currncy).html();
                      var Initial_Price_R = (initialPrice -  ((percent/100) * initialPrice));
             		  //$('#'+groupId+'_Initial_Price_R').html(replaceCommmaByDot(Initial_Price_R.toFixed(2)));
            		 document.getElementById(groupId+'_Initial_Price_R').innerHTML = replaceCommmaByDot(Initial_Price_R.toFixed(2));
                    calculatePriceWithInterest(groupId.split('_')[0],groupId.split('_')[1],groupId.split('_')[2],parseInt(groupId.split('_')[3]));
                    //calculateFinal_Unit_Price(groupId.split('_')[0],groupId.split('_')[1],groupId.split('_')[2],parseInt(groupId.split('_')[3]));
                    //calculateTotalValuewithInterest(groupId.split('_')[0],groupId.split('_')[1],groupId.split('_')[2],parseInt(groupId.split('_')[3]));
                    //calculateTotalValueSum(groupId.split('_')[0],groupId.split('_')[1],groupId.split('_')[2],parseInt(groupId.split('_')[3]));
                    calculateTotalValuewithInterestSum(groupId.split('_')[0],groupId.split('_')[1],groupId.split('_')[2],parseInt(groupId.split('_')[3]));
                    
                    }
          		});
              }
          }
        function calculatePriceWithInterest(colId,rowId,row,rowCount){
           // alert(rowCount);
             var returnJsonSOlineItem = JSON.parse(JSON.stringify(mapPricebook[priceBookDetailId])); //findKey(colId, JSONTEST);
             //var returnJsonGroup =JSON.parse(JSON.stringify(mapCampgrp[colId]));
            
            var days = 0;
         	var TIM = 0;
            var interestdate = '';
            var intrestRate  = 0;
             for(var i=0; i<JSONTEST.length; i++){
                 if(returnJsonSOlineItem!=undefined){   
                    if(JSONTEST[i].combinationkey == returnJsonSOlineItem.combinationkey){
                       days = JSONTEST[i].days;
                       interestdate = JSONTEST[i].interestDate;
                        if(currncy =='BRL'){
                         intrestRate = JSONTEST[i].interestRateBRL;  
                        }else{
                          intrestRate = JSONTEST[i].interestRateUSD;     
                        }
                    }
            }     
        }
           // alert('days>>>'+days);
            //alert('intrestRate>>>'+intrestRate);
            var today = new Date();
            var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
            var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
            var yyyy = today.getFullYear();
            
            // Custom date format for ui:inputDate
            var currentDate = (yyyy + "-" + MM + "-" + dd);
            
            var x = new Date(interestdate);
            var y = new Date(currentDate);
            
            var invoiceDate = $('#' + colId + "_"+rowId+"_"+ row+"_"+rowCount+ '_Invoice_Date').val();
            var d = new Date(interestdate),
            t = new Date(),
            n = new Date(invoiceDate),
            s = '';
           
            if((d > n)){
                TIM = 0;
                //console.log('Invoice Date is lesser');
            }
            if((d < n)){
                //alert(days);
                TIM = (days/30);
               
                //console.log('Invoice Date is greater');
                //console.log('----->'+TIM);
            }
            var  Intial_Price = $('#' + colId + "_"+rowId+"_"+ row+"_"+rowCount+ '_Initial_Price_R').html();//.replace(',',''));
           //console.log('Intial_Price comma--->'+intrestRate);
            Intial_Price = replaceDotByCommma(Intial_Price);
            var amount =Intial_Price;
            //alert(+x <= +y);
            //if(+x <= +y){
             //alert('initial '+Intial_Price +' Power '+Math.pow((1 + intrestRate),TIM)+' Tim '+TIM)   
              console.log('initial '+Intial_Price +' Power '+Math.pow((1 + intrestRate),TIM.toFixed(2)).toFixed(2)+' Tim '+TIM.toFixed(2))   
             amount = (Intial_Price * (Math.pow((1 + intrestRate),TIM.toFixed(2))).toFixed(2));
              //alert('amount>>--->'+amount.toFixed(2));   
			//}
           //$('#' + colId + "_"+rowId+"_"+ row+"_"+rowCount+ '_Price_with_Interest').html(replaceCommmaByDot(amount.toFixed(2)));
            document.getElementById(colId + "_"+rowId+"_"+ row+"_"+rowCount+ '_Price_with_Interest').innerHTML = replaceCommmaByDot(amount.toFixed(2));
        }
        function calculateTotalValuewithInterest(colId,rowId,row,rowCount){
            var volume= $('#' + colId + "_"+rowId+"_"+ row+"_"+rowCount+ '_Product_Volume').val();
            volume = replaceDotByCommma(volume);
            var finalPrice = $('#' + colId + "_"+rowId+"_"+ row+"_"+rowCount+ '_Final_Unit_Price').val();
            finalPrice = replaceDotByCommma(finalPrice);
            //$('#' + colId + "_"+rowId+"_"+ row+"_"+rowCount+'_Total_Value_with_Interest').html(replaceCommmaByDot((volume * finalPrice).toFixed(2)));
        	document.getElementById(colId + "_"+rowId+"_"+ row+"_"+rowCount+'_Total_Value_with_Interest').innerHTML = replaceCommmaByDot((volume * finalPrice).toFixed(2));
        }
        function calculateFinal_Unit_Price(colId,rowId,row,rowCount){
           //var returnJsonGroup =JSON.parse(JSON.stringify(mapCampgrp[colId])); //findKey(colId, gropupJSON);
            var returnJsonSOlineItem =JSON.parse(JSON.stringify(mapPricebook[priceBookDetailId]));// findKey(priceBookDetailId, JSONTEST);
            //console.log('calculateFinal_Unit_Price');
            //console.log(returnJsonSOlineItem);
            var interestPrice = $('#' + colId + "_"+rowId+"_"+ row+"_"+rowCount+ '_Price_with_Interest').html();
            interestPrice = replaceDotByCommma(interestPrice);
            //alert('interestPrice>>--->'+interestPrice);
            var managerDiscount = 0;
            if(returnJsonSOlineItem !=undefined){
            if(returnJsonSOlineItem.isManDiscount==true){
                managerDiscount = returnJsonSOlineItem.manDiscount;
            }
            }
            var applyManagerDiscoutnt =  false;
            /*if(applyManagerDiscoutnt){
               var managerLimt = interestPrice - ((interestPrice * managerDiscount)/100);
                if( replaceDotByCommma($('#' + colId + "_"+rowId+"_"+ row+"_"+rowCount+'_Final_Unit_Price').val())<managerLimt){
                   // alert($A.get("$Label.c.Final_Unit_Price_value_should_be_less_then_Manager_Price"));
                      $('#' + colId + "_"+rowId+"_"+ row+"_"+rowCount+'_Final_Unit_Price').val(replaceCommmaByDot(interestPrice.toFixed(2)));
                }else{
                      $('#' + colId + "_"+rowId+"_"+ row+"_"+rowCount+'_Final_Unit_Price').val(replaceCommmaByDot(interestPrice.toFixed(2)));
                }
            }else{*/
           // alert('isManual>>>'+returnJsonSOlineItem.isManual);
            if(returnJsonSOlineItem != undefined){
                if(!returnJsonSOlineItem.isManual ){
              $('#' + colId + "_"+rowId+"_"+ row+"_"+rowCount+'_Final_Unit_Price').val(replaceCommmaByDot(interestPrice.toFixed(2)));
                }
            }    
            //}   
        
        }
        function calculateTotalValueSum(colId,rowId,row,rowCount){
            var Total_Product_Volume = 0;
            var Total_Value = 0;
            for (var i = 1; i <= rowCount; i++) {
            //console.log('#'+colId+"_"+rowId+'_'+i+'_'+rowCount+'_Total_Value');
                Total_Value  = $('#'+colId+"_"+rowId+'_'+i+'_'+rowCount+'_Total_Value').html();
                Total_Value = replaceDotByCommma(Total_Value);
                if (isNaN(Total_Value )) {
                    Total_Value  = 0;
                }
                Total_Product_Volume = Total_Product_Volume + Total_Value ;
            }
        	//alert('Replace Comma'+replaceCommmaByDot(Total_Product_Volume));
            //$('#' + colId +'_'+rowId +'_Total_Value').html((replaceCommmaByDot(Total_Product_Volume.toFixed(2))));
        	document.getElementById(colId +'_'+rowId +'_Total_Value').innerHTML = replaceCommmaByDot(Total_Product_Volume.toFixed(2));
        }
        function calculateTotalValuewithInterestSum(colId,rowId,row,rowCount){
            var Total_Product_Volume = 0;
            var Total_Value = 0;
            
            for (var i = 1; i <= rowCount; i++) { 
                Total_Value  = $('#' + colId + "_"+rowId+'_'+ i+'_'+rowCount+ '_Total_Value_with_Interest').html();
                //console.log('colId>>--->'+colId+'----'+rowId+'----'+i+'---'+rowCount+'total val'+Total_Value);
                Total_Value = replaceDotByCommma(Total_Value);
             	//console.log('Total_Value>>--->'+Total_Value);
                //alert( 'Total Product Vol'+Total_Value);
                if (isNaN(Total_Value)){
                    Total_Value  = 0;
                }
                Total_Product_Volume = Total_Product_Volume + Total_Value;
            }
        	//alert(Total_Product_Volume);
            //$('#' + colId +'_'+rowId  + '_Total_Value_with_Interest').html(replaceCommmaByDot(Total_Product_Volume.toFixed(2)));
        	//console.log('Total Product Volume >>--->'+Total_Product_Volume);
            document.getElementById(colId +'_'+rowId  + '_Total_Value_with_Interest').innerHTML = replaceCommmaByDot(Total_Product_Volume.toFixed(2));
        }
        function calculateTotalValuewithInterestAllSum(colId,rowId,row){
            
            var Total_Product_Volume = 0;
    		var Total_Value = 0;
           //alert(colId+'<<<'+rowId+'>>>'+row);
            $("div._Total_Value_with_Interest").each(function(){
                var inputId = this.id;
                var inputval = $('#'+inputId).html();
                inputval = replaceDotByCommma(inputval);
                //alert(inputval);
                if(isNaN(inputval)){
                    inputval =0;
                }
               //  alert(inputval);
                Total_Value = Total_Value + inputval;
            });
            /*Total_Value = $('#' + colId + "_"+rowId+"_"+ row+"_"+rowCount+'_Total_Value_with_Interest').html();
            Total_Value = replaceDotByCommma(Total_Value);
            if (isNaN(Total_Value )) {
            	Total_Value  = 0;
        	}
            Total_Product_Volume = Total_Value ;  
            
            var totalvalWithInterest = parseFloat(component.get("v.totalValueWithInterest"));
            
            totalvalWithInterest = parseFloat(totalvalWithInterest) + parseFloat(Total_Product_Volume);
            alert('>>>>>>>>>>>>>>>>>>>>>>'+totalvalWithInterest);*/
           // alert(Total_Value);
            component.set("v.totalValueWithInterest", Total_Value);
        
        }
         function replaceDotByCommma(replaceVal){
             var str = replaceVal.toString().replace('.','');
             str = str.replace(',','.'); 
             return parseFloat(str);   
         }
     function replaceCommmaByDot(replaceVal){  
          var str = replaceVal.toString().replace('.',','); 
         if(isNaN(str)){
            //alert(str); 
         }
          return str; 
    }
         $("#loader_23").hide();
        
	},
    showWarningToast : function(component, event, toastMsg) {
        var toastEvent = $A.get("e.force:showToast");
       // var toastEvent = sforce.one.showToast; 
        var error = $A.get("$Label.c.Warning");
        // For lightning1 show the toast
        if (toastEvent!=undefined){
            //fire the toast event in Salesforce1
            toastEvent.setParams({
                title: error,
                mode: 'dismissible',
                type: 'warning',
                message: toastMsg
            });
            toastEvent.fire();
        }
        else{ // otherwise throw an alert
            //console.log('toastMsg'+toastMsg);
            /*sforce.one.showToast({
                        "title": "error!",
                        "message":toastMsg,
                         "type": "warning"
                    });*/
            alert(error+': ' + toastMsg);
        }
    }
    /*findKey:function (component, key, JSONObj) { //method to find key in JSON
          for (var i = 0; i < JSONObj.length; i++) {
             //console.log(JSON.stringify(JSONObj[i]).indexOf(key))
            if (JSON.stringify(JSONObj[i]).indexOf(key) >= 0) {
                return JSONObj[i];
           }
        }
    }*/
    
})