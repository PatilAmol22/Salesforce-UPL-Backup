({
    init: function (cmp, event, helper) {
        var recordId = cmp.get('v.recordId');
        console.log("recordId"+recordId);
        helper.ClearLineItemField(cmp,event, helper,recordId);
        cmp.set('v.columns', [
            // {label: 'Id', fieldName: 'Id', type: 'text' , editable: false},
            {label: 'Name', fieldName: 'Name', type: 'text' ,editable: false,cellAttributes: { alignment: 'right' }},
            {label: 'Product Name', fieldName: 'ProductName__c', type: 'text' ,editable: false},
            {label: 'Quantity', fieldName: 'Quantity__c', type: 'Number' ,editable: true},
            {label: 'Unbilled Quatity', fieldName: 'Unbilled_Quatity__c', type: 'Number' ,editable: true},
            {label: 'New Quatity', fieldName: 'New_Quantity__c', type: 'Number' ,editable: true},
            
            {label: 'Date of FAT', fieldName: 'DateofFAT__c', type: 'date-local' ,editable: true},
            {label: 'Cancel Item', fieldName: 'Cancel_Line_Item__c', type: 'boolean' ,editable: true},
            {label: 'Cancellation Reason', fieldName: 'Cancellation_Reason__c', type: 'picklist' ,editable: true,
           
            
            }
           //  {label: 'Type', fieldName: 'Type', type: 'action', editable: true, typeAttributes: {rowActions: actions } {defaultValues: 'value1', 'value2'}}, //PICKLIST

        ]);
        helper.fetchData(cmp,event, helper,recordId);
        //helper.fetchData1(cmp,event, helper,recordId);
        helper.inventory(cmp,event,helper);
        helper.minMaxDate(cmp,event,helper,recordId);
                helper.getCancelReasonPicklist(cmp, event);

    },
    
    handleCancelClick : function (cmp, event, helper) {
        cmp.set("v.ShowModel", false);
        
        cmp.set("v.data",cmp.get("v.data2"));
        console.log("cmp.get",cmp.get("v.data2"));
        console.log("cmp.get data",cmp.get("v.data"));
       // $A.get("e.force:closeQuickAction").fire();
        cmp.set("v.ShowModel", false);
  
        
    },
    
    toggleCancellationReason : function (cmp, event, helper) {
        console.log("cmp.get data",cmp.get("v.data"));
        cmp.set("v.check",event.getSource().get("v.checked"));
        console.log("event.getParams",event.getSource().get("v.checked"));
        
    },
   
    handleSaveEdition: function (cmp, event, helper) {
        /* var toastEvent = $A.get("e.force:showToast");
             toastEvent.setParams({
                "title": $A.get("$Label.c.Error"),
                "message": $A.get("$Label.c.BlockedOrder"),
                "type": "error"
            });
            toastEvent.fire();
*/
      //  cmp.set("v.showSpinner", true); 
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0');
        var yyyy = today.getFullYear();
        
        
        today = yyyy + '-' +mm + '-' + dd ;
        cmp.set("v.today",today);
        console.log(today);
        var q1 = cmp.get("v.quantity1.Non_Invoice_Quantity__c");
        console.log('q1');
        var data = cmp.get("v.data",data);
        console.log('data',data);
        var newSalesOrder1= cmp.get("v.inventory"); 
        console.log('newSalesOrder1',newSalesOrder1);
        var minMaxDate = cmp.get("v.minMaxDate");
        var minDate;
        var maxDate;
        var flag = false;
        var draftValues = cmp.get("v.data");
        console.log("draftValues**",draftValues);
        var lineItemArrayList = [];
        var lineItemArray = new Object();  
        var branddata= cmp.get("v.data1");
        console.log('branddata',branddata);
        for(var i = 0; i <branddata.length; i++){
            for(var j = 0; j <draftValues.length; j++){ 
                if(branddata[i].Id == draftValues[j].Id){
                   // var q = draftValues[j].Non_Invoice_Quantity__c;
                   // console.log('q',q);
                    lineItemArray = new Object();
                    lineItemArray.Id=draftValues[j].Id;
                    lineItemArray.Name=branddata[i].Name;
                    // lineItemArray.New_Quantity__c=branddata[i].New_Quantity__c;
                    
                    lineItemArray.ProductName__c=branddata[i].ProductName__c;
                    lineItemArray.Brand_Name__c=branddata[i].SKU_Name__r.Brand_Name__c;
                    lineItemArray.Quantity__c=draftValues[j].Quantity__c;
                    lineItemArray.previousQty = branddata[i].New_Quantity__c;
                    lineItemArray.previousfat =branddata[i].DateofFAT__c ;
					lineItemArray.Cancellation_Reason__c = draftValues[j].Cancellation_Reason__c;
                    
                    if(draftValues[j].DateofFAT__c != null){
                        lineItemArray.DateofFAT__c=draftValues[j].DateofFAT__c;
                        
                    }
                    else{
                        lineItemArray.DateofFAT__c= branddata[i].DateofFAT__c;
                    }
                    lineItemArray.New_Quantity__c=draftValues[j].New_Quantity__c;
                    
                    lineItemArray.Cancel_Line_Item__c=draftValues[j].Cancel_Line_Item__c;
                    console.log('Test1');
                    if(lineItemArray.DateofFAT__c < today && lineItemArray.Cancel_Line_Item__c =='False'){
                        console.log('Test11');
                       // alert('Test');
                       /* var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.dateoffat1}");
                        var titl  = $A.get("{!$Label.c.dateoffattitle}");
                        toastEvent.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg,
                            "duration":'5000'
                        });
                        toastEvent.fire();
                        console.log('Test12');
                        return;*/
                    }
                    var min;
                    var max;
                    var d;
                    minMaxDate.forEach(function(item){
                        console.log('item.skuName',item.skuName);
                        console.log('branddata[i].ProductName__c ',branddata[i].ProductName__c );
                        
                        if(item.skuName == branddata[i].ProductName__c ){
                            
                            // var min1 = minDate.split('-');
                            // var max1 = maxDate.split('-');
                            // var min = new Date(min1[0],min1[1],min1[2]); 
                            // var max = new Date(max1[0],max1[1],max1[2]);
                            min = new Date(item.minDate);
                            max = new Date(item.maxDate);
                            d = new Date(lineItemArray.DateofFAT__c);
                            console.log('d',d);
                            console.log('lineItemArray.DateofFAT__c',lineItemArray.DateofFAT__c);
                            console.log('min',min);
                            console.log('max',max);
                            
                            
                            
                        }
                    });
                    if(d < min){
                        console.log('Test2');
                        var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.dateoffatmindate}");
                        var titl  = $A.get("{!$Label.c.dateoffatmintitle}");
                        toastEvent.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg,
                            "duration":'5000'
                        });
                        toastEvent.fire();
                        return;
                    }
                    if(d > max){
                        console.log('Test3');
                        var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.dateoffatmaxdate}");
                        var titl  = $A.get("{!$Label.c.dateoffatmaxtitle}");
                        toastEvent.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg,
                            "duration":'5000'
                        });
                        toastEvent.fire();
                        return;
                        
                    }
                    
                    
                    for(var jj = 0; jj < newSalesOrder1.length; jj++){
                        console.log('newSalesOrder1[j].productname',newSalesOrder1[jj].productname);                          
                        console.log('lineItemArray.Brand_Name__c',lineItemArray.Brand_Name__c);                          
                        
                        var d1 = new Date(newSalesOrder1[jj].year);
                        console.log('d1',d1);
                        var d2 = new Date(newSalesOrder1[jj].year1);
                        console.log('d2',d2);
                        var d = new Date(lineItemArray.DateofFAT__c);
                        console.log('d',d);
                        if( branddata[i].SKU_Name__r.Brand_Name__c == newSalesOrder1[jj].productname  ){
                            
                            console.log('name same');
                            
                            if(d1 <=d && d <= d2 ){
                                
                                flag = true;
                                console.log('1st if**');
                            }
                            
                            
                        }
                        
                    }
                  /*  if(flag==false){
                        var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.yearnotpresent}");
                        var titl  = $A.get("{!$Label.c.yeartitle}");
                        toastEvent.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg,
                            "duration":'3000'
                        });
                        toastEvent.fire();
                        return;
                    }*/
                    
                    if(  lineItemArray.New_Quantity__c < branddata[i].Quantity_Billed__c){
                        console.log('Test4');
                        var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.quantityless1}");
                        var titl  = $A.get("{!$Label.c.quantitytitle}");
                        toastEvent.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg,
                            "duration":'5000'
                        });
                        toastEvent.fire();
                        return;
                    }
                    
                    if( lineItemArray.New_Quantity__c >branddata[i].Quantity__c){
                        console.log('Test5');
                         var titl  = $A.get("{!$Label.c.quantityincreasetitle}");
                         alert(titl);
                      /*  var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.quantitygreater1}");
                        var titl  = $A.get("{!$Label.c.quantityincreasetitle}");
                        toastEvent.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg,
                            "duration":'5000'
                        });
                        toastEvent.fire();*/
                        return;
                    }
                    
                    //Change by Swaranjeet(Grazitti) #RITM0557675 
                     if(lineItemArray.New_Quantity__c != null && (lineItemArray.Cancellation_Reason__c==''||lineItemArray.Cancellation_Reason__c==null||lineItemArray.Cancellation_Reason__c==undefined)){
                        console.log('checks for cancellation reason1');
                        var toastEvent = $A.get("e.force:showToast");
                        var msg  = "Please enter Cancellation Reason";
                        var titl  = "Please enter Cancellation Reason";
                        toastEvent.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg,
                            "duration":'5000'
                        });
                        toastEvent.fire();
                        return;
                    }
                    
                    if( lineItemArray.Cancel_Line_Item__c==true&&(lineItemArray.Cancellation_Reason__c==''||lineItemArray.Cancellation_Reason__c==null||lineItemArray.Cancellation_Reason__c==undefined)){
                       console.log('Test6');
                        var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.cancellationreason1}");
                        var titl  =$A.get("{!$Label.c.reasontitle}");
                        toastEvent.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg,
                            "duration":'5000'
                        });
                        toastEvent.fire();
                        return;
                    }
                    
                    // console.log('lineItemArray.Non_Invoice_Quantity__c',lineItemArray.Non_Invoice_Quantity__c);
                    // console.log(' draftValues[j].Non_Invoice_Quantity__c', draftValues[j].Non_Invoice_Quantity__c);
                    
                    // String.valueOf(d.dateGmt())
                    // lineItemArray.DateofFAT__c=Date.valueOf(draftValues[j].DateofFAT__c.removeEnd('T00:00:00.000Z'))
                    lineItemArrayList.push(lineItemArray);
                    // console.log('draftValues date is'+JSON.stringify(draftValues[j].DateofFAT__c));
                    
                }
            }
        }
        
        
        console.log('draftValues'+JSON.stringify(draftValues));
        
        console.log('lineItemArrayList'+JSON.stringify(lineItemArrayList));
        
        for(var i = 0; i <lineItemArrayList.length; i++){
            if(lineItemArrayList[i].Cancel_Line_Item__c == true){
                if((lineItemArrayList[i].New_Quantity__c != null  && lineItemArrayList[i].DateofFAT__c != null)||(lineItemArrayList[i].New_Quantity__c != lineItemArrayList[i].previousQty && lineItemArrayList[i].DateofFAT__c != lineItemArrayList[i].previousfat)){
                   console.log('Test7');
                    var toastEvent = $A.get("e.force:showToast");
                    var msg  = $A.get("{!$Label.c.reason1}");
                    var titl  = $A.get("{!$Label.c.reason1title}");
                    toastEvent.setParams({
                        "title": titl,
                        "type": "error",
                        "message": msg,
                        "duration":'5000'
                    });
                    toastEvent.fire();
                    return;
                }
                if(lineItemArrayList[i].Cancellation_Reason__c==''||lineItemArrayList[i].Cancellation_Reason__c==null||lineItemArrayList[i].Cancellation_Reason__c==undefined){
                    console.log('Test8');   
                    var toastEvent = $A.get("e.force:showToast");
                        var msg  = $A.get("{!$Label.c.cancellationreason1}");
                        var titl  = $A.get("{!$Label.c.reasontitle}");
                        toastEvent.setParams({
                            "title": titl,
                            "type": "error",
                            "message": msg,
                            "duration":'5000'
                        });
                        toastEvent.fire();
                        return;
                    }
            }
        }
        
        
       var action = cmp.get("c.OrderItemBlockingAPICallaction1");
      //  var action = cmp.get("c.updateOrderItem");
        cmp.set("v.showSpinner", true); 
         var res ;
        console.log('Test123123');
        action.setParams({
            "soId": cmp.get('v.recordId'),
            "soitString" : JSON.stringify(draftValues)
        });
       
        action.setCallback(this, function(response) {
            
            res = response.getReturnValue();
             console.log('test111***'+res);
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.showSpinner", false); 
            console.log('state'+state);
            console.log('response********'+response.getReturnValue());
                console.log('outside toast1');
            helper.showToast(cmp, helper, response.getReturnValue());

                 //confirm(res);
                
              /*  if(res != null || res != '' || res!='undifined'){
                     console.log('inside toast13');
                     this.LightningAlert.open({
            message: 'this is the alert message',
            theme: 'error',
            label: 'Error!',
        }).then(function() {
            console.log('alert is closed');
        });
                    console.log('inside toast1');
                    alert(res);
                     console.log('inside toast11');
                 var toastEvent9 = $A.get("e.force:showToast");
                            toastEvent.setParams({                                
                                "message": res,
                                "type": "warning"
                            });
                            toastEvent9.fire();
                    console.log('inside toast2');
                }*/
                 cmp.set("v.ShowModel", false);
                console.log('outside toast2');
            }else{
                cmp.set("v.showSpinner", false); 
            helper.showToast(cmp,helper, 'ERROR');
            }
            
        });
        console.log('res123***'+res);
       // $A.enqueueAction(action);
       // console.log('res321***'+res);
        // helper.revertCssChange(cmp);
       // $A.get("e.force:closeQuickAction").fire(); 
       // $A.get("e.force:closeQuickAction").fire();
     //   cmp.set("v.ShowModel", false);
         $A.enqueueAction(action);
    },
    cancelreason:function(cmp,event,helper){
        console.log('reason selected',JSON.stringify(event.getParams('v.value')));
        console.log("-------",event.getSource().get("v.value"));
         console.log("-------",event.getParams('v.value'));
        console.log('data',cmp.get('v.data'));
    },
    
    setRecordId : function(component, event, helper){
        
        var selectedRows = event.getParam('selectedRows');
        //var key = component.get('v.key');
        // var recIds = '';
        console.log(selectedRows);
    },
    restrictQuantity: function(component, event, helper){
        var target = event.getSource();  
        var qty = target.get("v.value");
         var multipleOf = target.get("v.placeholder");
        var setValue = null; 
		var errorMessage ='';		
        console.log('qty',qty);
            if(qty!=null){
                console.log('qty',qty);
                if(multipleOf !=0){
                if((qty%multipleOf != 0 || qty<multipleOf)){
                    console.log('multipleOf'+multipleOf+'--'+qty);
                    errorMessage= $A.get("$Label.c.Qty_should_be_in_multiple_of")+" "+multipleOf;
                console.log('errorMessage',errorMessage);
                   // alert(errorMessage);
                    target.set("v.value", null);
                    target.set("v.errors", [{message:errorMessage}]);
                    $A.util.addClass(target, "error");
                }
                else{
                    target.set("v.errors", null); 
                    
                }
                }
                    
                
            }
        
    }
})