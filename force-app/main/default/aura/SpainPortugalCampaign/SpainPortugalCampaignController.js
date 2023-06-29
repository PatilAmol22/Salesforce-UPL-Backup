({  
	doInit : function(component, event, helper) {
        var recId = component.get("v.recordId");
        helper.fetchPicklistValues(component,'Spain_Portugal_Campaign__c','Status__c','campStatus');
        helper.fetchPicklistValues(component,'Spain_Portugal_Campaign__c','CurrencyIsoCode','currency');
        if(recId && recId !='undefined'){
       	 helper.getRecordData(component,recId); 
        component.set("v.isOwner",true);
        }else{
            helper.getUserName(component,event,helper);
        }
	},
    showSkuLookup : function(component, event, helper) {
        var activity = component.find("expenActvty").get("v.value");
        if(activity == 'New product Development' || activity == 'Existing Product Publicity' || activity == 'Marketing Field Trail Product' ){
        component.set("v.showSKU",true);
        }else{
        component.set("v.showSKU",false);
        component.set("v.selectedSKULookUpRecordActivity",{'sobjectType':'sObject'});
        }
    },
    numberValidation :function(component, event, helper){
        var target = event.getSource();  
        var value = target.get("v.value");
        console.log(value);
        if(!value){
            value = 0;
        }
        else{
            var valueString = value.toString(); 
            value = parseFloat(valueString.replace("-", "")); 
        }
        target.set("v.value", value);
        },
    validateNumber :function(component, event, helper){
        var index = event.currentTarget.dataset.rowIndex;  
        var actualQty = $("#"+index+"actualQtyedit").val();
        var actualAmt = $("#"+index+"actualAmtedit").val();
         if(!actualQty){
              $("#"+index+"actualQtyedit").css({"border-color": "#F50707", 
             "border-width":"1px", 
             "border-style":"solid"}); 
              $("#"+index+"errorQty").show();
         }
        else{
             $("#"+index+"actualQtyedit").css({"border-color": "#000000", 
             "border-width":"1px", 
             "border-style":"solid"});
             $("#"+index+"errorQty").hide(); 
            var valueString = actualQty.toString(); 
            actualQty = parseFloat(valueString.replace("-", "")); 
            actualQty =parseFloat(valueString.replace("+", "")); 
            $("#"+index+"actualQtyedit").val(actualQty);
        }
        if(!actualAmt){
             $("#"+index+"actualAmtedit").css({"border-color": "#F50707", 
             "border-width":"1px", 
             "border-style":"solid"});  
              $("#"+index+"errorAmt").show();
         }
        else{
              $("#"+index+"actualAmtedit").css({"border-color": "#000000", 
             "border-width":"1px", 
             "border-style":"solid"});
             $("#"+index+"errorAmt").hide();
            
            var valueString = actualAmt.toString(); 
            actualAmt = parseFloat(valueString.replace("-", "")); 
            actualAmt = parseFloat(valueString.replace("+", "")); 
            $("#"+index+"actualAmtedit").val(actualAmt);
        }
        
    },
     custmerSKUChange: function(component, event, helper){
		var customerObjId = component.get("v.selectedCustomerLookUpRecord.Id");
        var skuObjectId = component.get("v.selectedSKULookUpRecord.Id");
        if(skuObjectId && customerObjId){
            helper.getActualQtyAndAmount(component,customerObjId,skuObjectId);
        }
 	  },
    
    addCustForecastInfo :function(component, event, helper) {
        var customerObjId = component.get("v.selectedCustomerLookUpRecord.Id");
        var skuObjectId = component.get("v.selectedSKULookUpRecord.Id");
        var custObjName = component.get("v.selectedCustomerLookUpRecord.Name");
        var skuObjdesc = component.get("v.selectedSKULookUpRecord.SKU_Description__c");
        var skuObjcode = component.get("v.selectedSKULookUpRecord.SKU_Code__c");
        var forecastAmt = component.get("v.forecastCost"); 
        var actualAmt = component.get("v.ActualAmt");
        var actualQty = component.get("v.ActualQty");
        var etryType = '';
        var custForecastList = component.get("v.forecastInfoList");
        
        //alert(JSON.stringify(custForecastList));
        var isErorr = false;
        for(var i in custForecastList){
            if(custObjName == custForecastList[i].customerName && skuObjcode == custForecastList[i].sKUCode){
              helper.showToastMsg(component,event,'You can not add duplicate combination of Customer and SKU.');
              	isErorr = true; 
            }
        }
        
        if(!custObjName){
            helper.showToastMsg(component,event,'Please select Customer');
           isErorr = true;
        }
         if(!skuObjdesc){
            helper.showToastMsg(component,event,'Please select SKU');
           isErorr = true;
        }
         if(!forecastAmt){
           component.find("forecastid").set("v.errors", [{message: "Complete this field"}]);
            $A.util.addClass(component.find("forecastid"), 'slds-has-error');
           isErorr = true;
         }else{
             component.find("forecastid").set("v.errors", null); 
             $A.util.removeClass(component.find("forecastid"), 'slds-has-error');
         }
        var disableFlag = component.find("actualQty").get("v.disabled");
        if(disableFlag){
           etryType = 'Auto';
        }else{
            if(!actualQty){
                 component.find("actualQty").set("v.errors", [{message: "Complete this field"}]);
            $A.util.addClass(component.find("actualQty"), 'slds-has-error');
           isErorr = true;
            }else{
                 component.find("actualQty").set("v.errors", null); 
             $A.util.removeClass(component.find("actualQty"), 'slds-has-error');
            }
            if(!actualAmt){
             component.find("actualAmt").set("v.errors", [{message: "Complete this field"}]);
            $A.util.addClass(component.find("actualAmt"), 'slds-has-error');
           isErorr = true;
            }else{
             component.find("actualAmt").set("v.errors", null); 
             $A.util.removeClass(component.find("actualAmt"), 'slds-has-error');
            }
            etryType = 'Manual';
        }
        if(!isErorr){
        custForecastList.push({
            customerId : customerObjId,
            customerName : custObjName,
            sKUId : skuObjectId,
            sKUDescription : skuObjdesc,
            ActualAmount: actualAmt,
            entryType:etryType,
            ActualQty: actualQty,
            sKUCode:skuObjcode,
            forecastAmount : forecastAmt
        });
         // alert(JSON.stringify(custForecastList));  
        component.set("v.forecastInfoList",custForecastList);
        var childCmp = component.find("childCust");
        childCmp.clearData();
         var childCmp = component.find("childSkuForecast");
        childCmp.clearData();
        component.set("v.forecastCost",'');
        component.set("v.ActualQty",'');
        component.set("v.ActualAmt",'');
        component.find("actualQty").set("v.disabled", false);
        component.find("actualAmt").set("v.disabled", false);
        }
       // alert(JSON.stringify(component.get("v.forecastInfoList")));
    },
    editRecord : function(component, event, helper){
     var index = event.currentTarget.dataset.rowIndex;
      $("#"+index+"actualQtyedit").attr('disabled',false);
      $("#"+index+"actualAmtedit").attr('disabled',false);
      $("#"+index+"editbtn").attr('disabled', true);
      $("#"+index+"updatebtn").attr('disabled', false);
    },
    updateRecord : function(component, event, helper){
      var index = event.currentTarget.dataset.rowIndex;
      var custForecastList = component.get("v.forecastInfoList");
      var actualQty = $("#"+index+"actualQtyedit").val();
      var actualAmt =  $("#"+index+"actualAmtedit").val();  
        if(!actualQty || !actualAmt){
            if(!actualQty){
              $("#"+index+"actualQtyedit").css({"border-color": "#F50707", 
             "border-width":"1px", 
             "border-style":"solid"}); 
              $("#"+index+"errorQty").show();
            }
            if(!actualAmt){
              $("#"+index+"actualAmtedit").css({"border-color": "#F50707", 
             "border-width":"1px", 
             "border-style":"solid"});  
              $("#"+index+"errorAmt").show();
            }
        }else{
            $("#"+index+"actualQtyedit").css({"border-color": "#000000"}); 
             //"border-width":"1px"});
             $("#"+index+"errorQty").hide();
            
             $("#"+index+"actualAmtedit").css({"border-color": "#000000"});
             $("#"+index+"errorAmt").hide();
            
              custForecastList[index].ActualQty = actualQty;
              custForecastList[index].ActualAmount = actualAmt;
              //alert(JSON.stringify(custForecastList[index]));
              $("#"+index+"actualQtyedit").attr('disabled',true);
              $("#"+index+"actualAmtedit").attr('disabled',true);
              $("#"+index+"editbtn").attr('disabled', false);
              $("#"+index+"updatebtn").attr('disabled', true);
              
            helper.updateCFIRecord(component,event,custForecastList[index]);
        }  
    },
	removeforcastinfo : function(component, event, helper){
         var index = event.currentTarget.dataset.rowIndex;
         var custforecastInfoList = component.get("v.forecastInfoList");
         var cFIDellist = component.get("v.forecastInfoDelList");
        if(custforecastInfoList[index].id != '' || custforecastInfoList[index].id != null ){
            cFIDellist.push({ 
            id : custforecastInfoList[index].id,
            customerId : custforecastInfoList[index].customerId,
            customerName : custforecastInfoList[index].customerName,
            sKUId : custforecastInfoList[index].sKUId,
            sKUDescription : custforecastInfoList[index].sKUDescription,
            sKUCode:custforecastInfoList[index].sKUCode,
            forecastAmount : custforecastInfoList[index].forecastAmount});
            
        }
        component.set("v.forecastInfoDelList",cFIDellist);    
        custforecastInfoList.splice(index, 1);
        component.set("v.forecastInfoList", custforecastInfoList);
    },    
    addCrop:function(component, event, helper){
    	var cropobjId = component.get("v.selectedCropLookUpRecord.Id"); 
        var cropobjName = component.get("v.selectedCropLookUpRecord.Name");
        var croplist = component.get("v.cropDetailList");
        var isError = false;
        //console.log('cropIdlist>>--->'+component.get("v.cropDetailList"));
        for(var i in croplist){
            if(cropobjId == croplist[i].cropid){
            helper.showToastMsg(component,event,'You can not add duplicate Crop');
            var childCmp = component.find("childCrop");
            childCmp.clearData();
            isError = true; 
            }  
        }
        if(!cropobjName){
        	 helper.showToastMsg(component,event,'Please select Crop');
             isError = true; 
        }
        if(!isError){ 
        croplist.push({
            cropid : cropobjId,
            cropName : cropobjName
        });
        //alert(JSON.stringify(croplist));
        component.set("v.cropDetailList",croplist);       
        var childCmp = component.find("childCrop");
        childCmp.clearData();
        }
    },
    removeCrop: function(component, event, helper) {
        var index = event.currentTarget.dataset.rowIndex;
        var cropList = component.get("v.cropDetailList");
        var cropDellist = component.get("v.cropDetailDelList");
        
        if(cropList[index].id != '' || cropList[index].id != null || !$A.util.isUndefined(cropList[index].id) ){
            cropDellist.push({
                id :cropList[index].id,
                cropid : cropList[index].cropid,
            	cropName : cropList[index].cropName
            });
            
        }
        component.set("v.cropDetailDelList",cropDellist);     
        cropList.splice(index, 1);
        component.set("v.cropDetailList",cropList); 
    },
    addDemoProtocol:function(component, event, helper){
        var demoObjective = component.find("objective").get("v.value");
        var demoStartDate = component.find("demoStartDate").get("v.value");
        var demoEndDate = component.find("demoEndDate").get("v.value");
        var demoCost = component.find("costid").get("v.value");
        var demoStatus = component.find("demoProtocolStatus").get("v.value");
        var isvalidDate = component.get("v.isDateValidate");
        var demolist = component.get("v.demoProtocolList");
        var isErorr = false;
        if(demolist.length > 25){
        helper.showToastMsg(component,event,'You Can not add more than 25 records in Demo Protocol');
        isError = true; 
        //component.set("v.demoProtocolList",demolist); 
		component.find("objective").set("v.value",'');     
        component.find("demoStartDate").set("v.value",'');
        component.find("demoEndDate").set("v.value",'');
        component.find("costid").set("v.value",'');
        component.find("demoProtocolStatus").set("v.value",'Contract');
        }
        if(demoObjective == ''){
             component.find("objective").set("v.errors", [{message: "Complete this field"}]);
               $A.util.addClass(component.find("objective"), 'slds-has-error');
            isErorr = true;
        }else{
             component.find("objective").set("v.errors", null);
             $A.util.removeClass(component.find("objective"), 'slds-has-error');
        }
        if(demoStartDate ==''){
             component.find("demoStartDate").set("v.errors", [{message: "Complete this field"}]);
               $A.util.addClass(component.find("demoStartDate"), 'slds-has-error');
            isErorr = true;
        }else{
             component.find("demoStartDate").set("v.errors", null);
             $A.util.removeClass(component.find("demoStartDate"), 'slds-has-error');
        }
        if(demoEndDate==''){
             component.find("demoEndDate").set("v.errors", [{message: "Complete this field"}]);
               $A.util.addClass(component.find("demoEndDate"), 'slds-has-error');
            isErorr = true;
        }else{
             component.find("demoEndDate").set("v.errors", null);
            $A.util.removeClass(component.find("demoEndDate"), 'slds-has-error');
        }
        if(!demoCost){
             component.find("costid").set("v.errors", [{message: "Complete this field"}]);
               $A.util.addClass(component.find("costid"), 'slds-has-error');
            isErorr = true;
        }else{
             component.find("costid").set("v.errors", null);
            $A.util.removeClass(component.find("costid"), 'slds-has-error');
        }
        //alert(isvalidDate);
        if(!isErorr && isvalidDate){
        demolist.push({
            objectives : demoObjective,
            startDate: demoStartDate,
            endDate : demoEndDate,
            cost : demoCost,
            status :demoStatus
        });
        component.set("v.demoProtocolList",demolist); 
		component.find("objective").set("v.value",'');     
        component.find("demoStartDate").set("v.value",'');
        component.find("demoEndDate").set("v.value",'');
        component.find("costid").set("v.value",'');
        component.find("demoProtocolStatus").set("v.value",'Contract');
        }
        
    },
    removeDemoProtocol: function(component, event, helper) {
        var index = event.currentTarget.dataset.rowIndex;
        var demoProtocolList = component.get("v.demoProtocolList");
        var DpDelList = component.get("v.demoProtocolDelList");
        
        if(demoProtocolList[index].id != '' || demoProtocolList[index].id != null || !$A.util.isUndefined(demoProtocolList[index].id) ){
            DpDelList.push({
                id : demoProtocolList[index].id, 
                objectives : demoProtocolList[index].objectives,
            	startDate: demoProtocolList[index].startDate,
            	endDate : demoProtocolList[index].endDate,
            	cost : demoProtocolList[index].cost,
            	status :demoProtocolList[index].status
            });
            component.set("v.demoProtocolDelList",DpDelList);     
        }
        demoProtocolList.splice(index, 1);
        component.set("v.demoProtocolList",demoProtocolList); 
    },
    addExpenseActivity : function(component, event, helper){
      var custId =  component.get("v.selectedExpCustLookUpRecord.Id");
      var custName =  component.get("v.selectedExpCustLookUpRecord.Name"); 
      var expenseActivity = component.find("expenActvty").get("v.value");
      var expenseActivitySKUId = component.get("v.selectedSKULookUpRecordActivity.Id");
      var expenseActivitySKUDesc = component.get("v.selectedSKULookUpRecordActivity.SKU_Description__c");
      var expenseActivitySKUCode = component.get("v.selectedSKULookUpRecordActivity.SKU_Code__c"); 
      var expenseActivityBudgetedCost = component.find("budgetedCost").get("v.value");
      var expenseActivityActualCost = component.find("actualCost").get("v.value");
      var expenseList = component.get("v.expenseActivityList");
      var isShowSKU = component.get("v.showSKU");
      var isErorr = false;
        for(var i in expenseList){
            if(isShowSKU && expenseList[i].sKUID != ''){
                if(expenseList[i].expenseActivity == expenseActivity && expenseList[i].sKUID == expenseActivitySKUId && expenseList[i].customerName == custName){
                    helper.showToastMsg(component,event,' You can not add duplicate combination of Customer, Activity and SKU ');
                    isErorr = true;	   
                }
            }    
        }
        if(!custName){
            helper.showToastMsg(component,event,'Please select Custmer');
           isErorr = true;
        }
        if(!expenseActivitySKUId && isShowSKU ){
            helper.showToastMsg(component,event,'Please select SKU');
           isErorr = true;
        }
        if(!expenseActivityBudgetedCost){
             component.find("budgetedCost").set("v.errors", [{message: "Complete this field"}]);
             $A.util.addClass(component.find("budgetedCost"), 'slds-has-error');
            isErorr = true;
        }else{
             component.find("budgetedCost").set("v.errors", null);
             $A.util.removeClass(component.find("budgetedCost"), 'slds-has-error');
        }
        if(!expenseActivityActualCost){
             component.find("actualCost").set("v.errors", [{message: "Complete this field"}]);
              $A.util.addClass(component.find("actualCost"), 'slds-has-error');
            isErorr = true;
        }else{
             component.find("actualCost").set("v.errors", null);
             $A.util.removeClass(component.find("actualCost"), 'slds-has-error');
        }
        if(!isErorr){
        expenseList.push({
            expenseActivity: expenseActivity,
            customerId:custId,
            customerName:custName,
            sKUID:expenseActivitySKUId,
            sKUDescription:expenseActivitySKUDesc,
            sKUCode: expenseActivitySKUCode,
            budgetedCost:expenseActivityBudgetedCost,
            actualCost:expenseActivityActualCost
        });
     component.set("v.expenseActivityList",expenseList);
      if(isShowSKU){      
          var childCmp = component.find("childSKUAct");
          childCmp.clearData();
      }
      component.set("v.showSKU",false);      
      component.find("expenActvty").set("v.value",'');
      component.find("budgetedCost").set("v.value",'');
      component.find("actualCost").set("v.value",'');
     var childCmp1 = component.find("expCust");
      childCmp1.clearData();
        }
    },
    
    removeExpenseActivity: function(component, event, helper) {
        var index = event.currentTarget.dataset.rowIndex;
        var expActList  = component.get("v.expenseActivityList");
        var expActDelList = component.get("v.expenseActivityDelList");
        
        if(expActList[index].id != '' || !$A.util.isUndefined(expActList[index].id) || expActList[index].id != null){
            expActDelList.push({
            id:expActList[index].id,
            customerId:expActList[index].customerId,
            customerName:expActList[index].customerName,
            expenseActivity: expActList[index].expenseActivity,
            sKUID:expActList[index].sKUID,
            sKUDescription:expActList[index].sKUDescription,
            sKUCode: expActList[index].sKUCode,
            budgetedCost:expActList[index].budgetedCost,
            actualCost:expActList[index].actualCost
            });
        }
        component.set("v.expenseActivityDelList",expActList);     
        expActList.splice(index, 1);
        component.set("v.expenseActivityList", expActList); 
    },
    
    onDateChangeStartDate: function(component, event, helper) {
        var target = event.getSource(); 
        var startdateid =  target.getLocalId(); 
          console.log('id==='+startdateid); 
        var inputCmp = component.find(startdateid);
        var value = inputCmp.get("v.value");
        console.log('value==='+value); 
         var inputCmp2;
		 var value2;
        if(startdateid == 'startDate'){
        	  inputCmp2 = component.find("endDate");
       		  value2 = inputCmp2.get("v.value");
              var today = new Date();
              var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
              var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
              var yyyy = today.getFullYear();
              // Custom date format for ui:inputDate
              var currentDate = (yyyy + "-" + MM + "-" + dd);
        	  var x = new Date(value);
        	  var y = new Date(currentDate);
        	  var z = new Date(value2);
            
        }
        var flag = true;
        if(startdateid != 'demoStartdate'){
        if(x=='Invalid Date'){
            inputCmp.set("v.errors", [{message:"Complete this field"}]);           
            $A.util.addClass(inputCmp, "error");
            component.set("v.isDateValidate", false);
            flag = false; 
        }else{
            inputCmp.set("v.errors", null);
			$A.util.removeClass(inputCmp, "error");
            component.set("v.isDateValidate",true);
        }
        }
        // is less than today?
        else if (+x < +y) {
            inputCmp.set("v.errors", [{message: "Start Date cannot be less than today" }]);    
            $A.util.addClass(inputCmp, "error");
            component.set("v.isDateValidate",false);
            flag = false;
        } 
		else if(+x > +z){
            inputCmp.set("v.errors", [{message: "Start Date cannot be after End Date" }]);
            $A.util.addClass(inputCmp, "error");
            component.set("v.isDateValidate",false);
            flag = false;
		}
		else {
			inputCmp.set("v.errors", null);
			$A.util.removeClass(inputCmp, "error");
            component.set("v.isDateValidate",true);
		}
        //component.set("v.isValidStartDate",flag);
    },  
    //Validate End Date
    onDateChangeEndDate: function(component, event, helper) {
        var inputCmp = component.find("endDate");
        var value = inputCmp.get("v.value");
        
        var inputCmp1 = component.find("startDate");
        var value1 = inputCmp1.get("v.value");
        
        var x = new Date(value);
        var y = new Date(value1);
        
        var today = new Date();
        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        
        // Custom date format for ui:inputDate
        var currentDate = (yyyy + "-" + MM + "-" + dd);
        var z = new Date(currentDate);
        
        var flag = true;
        
        if(x=='Invalid Date'){
            inputCmp.set("v.errors", [{message: "Complete this field"}]);      
            $A.util.addClass(inputCmp, "error");
            component.set("v.isDateValidate",false);
            flag = false; 
        }
        else if (+x < +z) {
            inputCmp.set("v.errors", [{message: "End Date cannot be less than today" }]);    
            $A.util.addClass(inputCmp, "error");
            component.set("v.isDateValidate",false);
            flag = false;
        }         
        // is less than today?
        else if (+x < +y) {
            //inputCmp.set("v.errors", [{message:"Valid To date: "+value+" cannot be less than Valid From date: " + value1}]);
            inputCmp.set("v.errors", [{message: "End Date cannot be before Start Date"}]);
            $A.util.addClass(inputCmp, "error");
            component.set("v.isDateValidate",false);
            flag = false;
        }
        else {
            inputCmp.set("v.errors", null);
            $A.util.removeClass(inputCmp, "error"); 
            component.set("v.isDateValidate",false);
        }
        
    },
    onDateChangeDemoStartDate: function(component, event, helper) {
        var inputCmp = component.find("demoStartDate");
        var value = inputCmp.get("v.value");
        
        var inputCmp1 = component.find("demoEndDate");
        var value1 = inputCmp1.get("v.value");
        
        var x = new Date(value);
        var y = new Date(value1);
        
        var today = new Date();
        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        
        // Custom date format for ui:inputDate
        var currentDate = (yyyy + "-" + MM + "-" + dd);
        var z = new Date(currentDate);
        
        var flag = true;
        
        if(x=='Invalid Date'){
            inputCmp.set("v.errors", [{message: "Complete this field"}]);      
            $A.util.addClass(inputCmp, "error");
            component.set("v.isDateValidate",false);
            flag = false; 
        }
        else if (+x < +z) {
            inputCmp.set("v.errors", [{message: "End Date cannot be less than today" }]);    
            $A.util.addClass(inputCmp, "error");
            component.set("v.isDateValidate",false);
            flag = false;
        }         
        // is less than today?
        else if (+x > +y) {
            //inputCmp.set("v.errors", [{message:"Valid To date: "+value+" cannot be less than Valid From date: " + value1}]);
            inputCmp.set("v.errors", [{message: "Start Date cannot be greater than End Date"}]);
            $A.util.addClass(inputCmp, "error");
            component.set("v.isDateValidate",false);
            flag = false;
        }
        else {
            inputCmp.set("v.errors", null);
            $A.util.removeClass(inputCmp, "error"); 
            component.set("v.isDateValidate",true);
        }
              
         inputCmp1 = component.find("startDate");
         value1 = inputCmp1.get("v.value");
          if(!value1){
            helper.showToastMsg(component,event,'Please select Campaign Start Date'); 
            flag = false;
            inputCmp.set("v.value",'');
        }
        if(flag){ 
         x = new Date(value);
         y = new Date(value1);
        
        today = new Date();
         dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
         MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
         yyyy = today.getFullYear();
        
        // Custom date format for ui:inputDate
         currentDate = (yyyy + "-" + MM + "-" + dd);
         z = new Date(currentDate);
        
         flag = true;
        
        if(x=='Invalid Date'){
            inputCmp.set("v.errors", [{message: "Complete this field"}]);      
            $A.util.addClass(inputCmp, "error");
            component.set("v.isDateValidate",false);
            flag = false; 
        }
        else if (+x < +z) {
            inputCmp.set("v.errors", [{message: "Start Date cannot be less than today" }]);    
            $A.util.addClass(inputCmp, "error");
            component.set("v.isDateValidate",false);
            flag = false;
        }         
        // is less than today?
        else if (+x < +y) {
            //inputCmp.set("v.errors", [{message:"Valid To date: "+value+" cannot be less than Valid From date: " + value1}]);
            inputCmp.set("v.errors", [{message: "Start Date cannot be less than Campaign Start Date"}]);
            $A.util.addClass(inputCmp, "error");
            component.set("v.isDateValidate",false);
            flag = false;
        }
        else {
            inputCmp.set("v.errors", null);
            $A.util.removeClass(inputCmp, "error"); 
            component.set("v.isDateValidate",true);
        }
        }
        
        inputCmp1 = component.find("endDate");
         value1 = inputCmp1.get("v.value");
         if(!value1){
            helper.showToastMsg(component,event,'Please select Campaign End Date'); 
            flag = false;
             inputCmp.set("v.value",'');
        }
        if(flag){ 
         x = new Date(value);
         y = new Date(value1);
        
        today = new Date();
         dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
         MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
         yyyy = today.getFullYear();
        
        // Custom date format for ui:inputDate
         currentDate = (yyyy + "-" + MM + "-" + dd);
         z = new Date(currentDate);
        
         flag = true;
        
        if(x=='Invalid Date'){
            inputCmp.set("v.errors", [{message: "Complete this field"}]);      
            $A.util.addClass(inputCmp, "error");
            component.set("v.isDateValidate",false);
            flag = false; 
        }
        else if (+x < +z) {
            inputCmp.set("v.errors", [{message: "Start Date cannot be less than today" }]);    
            $A.util.addClass(inputCmp, "error");
            component.set("v.isDateValidate",false);
            flag = false;
        }         
        // is less than today?
        else if (+x > +y) {
            //inputCmp.set("v.errors", [{message:"Valid To date: "+value+" cannot be less than Valid From date: " + value1}]);
            inputCmp.set("v.errors", [{message: "Start Date cannot be greater than Campaign End Date"}]);
            $A.util.addClass(inputCmp, "error");
            component.set("v.isDateValidate",false);
            flag = false;
        }
        else {
            inputCmp.set("v.errors", null);
            $A.util.removeClass(inputCmp, "error"); 
            component.set("v.isDateValidate",true);
        }
       }
    },
    onDateChangeDemoEndDate: function(component, event, helper) {
        var inputCmp = component.find("demoEndDate");
        var value = inputCmp.get("v.value");
        
        var inputCmp1 = component.find("demoStartDate");
        var value1 = inputCmp1.get("v.value");
        
        var x = new Date(value);
        var y = new Date(value1);
        
        var today = new Date();
        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        
        // Custom date format for ui:inputDate
        var currentDate = (yyyy + "-" + MM + "-" + dd);
        var z = new Date(currentDate);
        
        var flag = true;
        
        if(x=='Invalid Date'){
            inputCmp.set("v.errors", [{message: "Complete this field"}]);      
            $A.util.addClass(inputCmp, "error");
            component.set("v.isDateValidate",false);
            flag = false; 
        }
        else if (+x < +z) {
            inputCmp.set("v.errors", [{message: "End Date cannot be less than today" }]);    
            $A.util.addClass(inputCmp, "error");
            component.set("v.isDateValidate",false);
            flag = false;
        }         
        // is less than today?
        else if (+x < +y) {
            //inputCmp.set("v.errors", [{message:"Valid To date: "+value+" cannot be less than Valid From date: " + value1}]);
            inputCmp.set("v.errors", [{message: "End Date cannot be before Start Date"}]);
            $A.util.addClass(inputCmp, "error");
            component.set("v.isDateValidate",false);
            flag = false;
        }
        else {
            inputCmp.set("v.errors", null);
            $A.util.removeClass(inputCmp, "error"); 
            component.set("v.isDateValidate",true);
        }
         
         inputCmp1 = component.find("startDate");
         value1 = inputCmp1.get("v.value");
        if(!value1){
            helper.showToastMsg(component,event,'Please select Campaign Start Date'); 
            flag = false;
            inputCmp.set("v.value",'');
        }
        if(flag){ 
         x = new Date(value);
         y = new Date(value1);
        
        today = new Date();
         dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
         MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
         yyyy = today.getFullYear();
        
        // Custom date format for ui:inputDate
         currentDate = (yyyy + "-" + MM + "-" + dd);
         z = new Date(currentDate);
        
         flag = true;
        
        if(x=='Invalid Date'){
            inputCmp.set("v.errors", [{message: "Complete this field"}]);      
            $A.util.addClass(inputCmp, "error");
            component.set("v.isDateValidate",false);
            flag = false; 
        }
        else if (+x < +z) {
            inputCmp.set("v.errors", [{message: "End Date cannot be less than today" }]);    
            $A.util.addClass(inputCmp, "error");
            component.set("v.isDateValidate",false);
            flag = false;
        }         
        // is less than today?
        
        else if (+x < +y) {
            console.log(x);
        console.log(y);          
            inputCmp.set("v.errors", [{message: "End Date cannot be before Campaign Start Date"}]);
            $A.util.addClass(inputCmp, "error");
            component.set("v.isDateValidate",false);
            flag = false;
        }
        else {
            inputCmp.set("v.errors", null);
            $A.util.removeClass(inputCmp, "error"); 
            component.set("v.isDateValidate",true);
        }
        }
        
        inputCmp1 = component.find("endDate");
         value1 = inputCmp1.get("v.value");
        if(!value1){
            helper.showToastMsg(component,event,'Please select Campaign End Date'); 
            flag = false;
            inputCmp.set("v.value",'');
        }
         if(flag){ 
         x = new Date(value);
         y = new Date(value1);
        
        today = new Date();
         dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
         MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
         yyyy = today.getFullYear();
        
        // Custom date format for ui:inputDate
         currentDate = (yyyy + "-" + MM + "-" + dd);
         z = new Date(currentDate);
        
         flag = true;
        
        if(x=='Invalid Date'){
            inputCmp.set("v.errors", [{message: "Complete this field"}]);      
            $A.util.addClass(inputCmp, "error");
            component.set("v.isDateValidate",false);
            flag = false; 
        }
        else if (+x < +z) {
            inputCmp.set("v.errors", [{message: "End Date cannot be less than today" }]);    
            $A.util.addClass(inputCmp, "error");
            component.set("v.isDateValidate",false);
            flag = false;
        }         
        // is less than today?
        else if (+x > +y) {
            //inputCmp.set("v.errors", [{message:"Valid To date: "+value+" cannot be less than Valid From date: " + value1}]);
            inputCmp.set("v.errors", [{message: "End Date cannot be greater than Campaign End Date"}]);
            $A.util.addClass(inputCmp, "error");
            component.set("v.isDateValidate",false);
            flag = false;
        }
        else {
            inputCmp.set("v.errors", null);
            $A.util.removeClass(inputCmp, "error"); 
            component.set("v.isDateValidate",true);
        }
      }
    },
    onNameChange:function(component, event, helper) {
       var val = component.find("campName").get("v.value");
        //alert(val);
        if(val){  
            $A.util.removeClass(component.find("campName"), 'slds-has-error');
             component.find("campName").set("v.errors", null);
        }else{
            $A.util.addClass(component.find("campName"), 'slds-has-error');
             component.find("campName").set("v.errors", [{message: "Complete this field"}]);
        }
    },
    validateandSave : function(component, event, helper) {
        
        var campignObj = component.get("v.campaignObj");
        var isError = false; 
        if(!component.get("v.campaignObj.Name")){
            component.find("campName").set("v.errors", [{message: "Complete this field"}]);
            $A.util.addClass(component.find("campName"), 'slds-has-error');
            isError = true;
        }else{
        	 component.find("campName").set("v.errors", null);
             $A.util.removeClass(component.find("campName"), 'slds-has-error');
        }
        if(!component.get("v.campaignObj.Start_Date__c")){
            component.find("startDate").set("v.errors", [{message: "Complete this field"}]);
            $A.util.addClass(component.find("startDate"), 'slds-has-error');
            isError = true;
        }else{
        	 component.find("startDate").set("v.errors", null);  
             $A.util.removeClass(component.find("startDate"), 'slds-has-error');
        }
        if(!component.get("v.campaignObj.End_Date__c")){
            component.find("endDate").set("v.errors", [{message: "Complete this field"}]);
            $A.util.addClass(component.find("endDate"), 'slds-has-error');
            isError = true;
        }else{
        	 component.find("endDate").set("v.errors", null);
             $A.util.removeClass(component.find("endDate"), 'slds-has-error');
        }
        var custForecastInfoList = component.get("v.forecastInfoList");
        var cropList = component.get("v.cropDetailList");
        var demoList = component.get("v.demoProtocolList");
        var expenseList = component.get("v.expenseActivityList");
        var custForecastInfoDelList = component.get("v.forecastInfoDelList");
        var cropDelList = component.get("v.cropDetailDelList");
        var demoDelList = component.get("v.demoProtocolDelList");
        var expenseDelList = component.get("v.expenseActivityDelList");
        if(!isError){
           //alert(JSON.stringify(expenseList));
        helper.saveCampaign(component,campignObj,custForecastInfoList,cropList,demoList,expenseList,custForecastInfoDelList,cropDelList,demoDelList,expenseDelList);
        }
        
    },
    redirectCancel : function(component, event, helper){
                window.history.go(-1);
    }
})