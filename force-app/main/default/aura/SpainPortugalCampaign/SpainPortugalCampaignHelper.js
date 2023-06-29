({
    fetchPicklistValues : function(component,objName,feild,tagId){
       var action = component.get("c.getselectOptions");
       //console.log(objName);
        action.setParams({
            "objObject": objName,
            "fld": feild
        });
        var opts = [];
         var allValues;
        action.setCallback(this,function(response){
            if(response.getState() =='SUCCESS'){
                 console.log(response.getState());
                 allValues = response.getReturnValue();
                if(allValues != undefined  && allValues.length > 0){
                    for(var i= 0 ; i < allValues.length; i++){
                       console.log(allValues[i]);
                        opts.push({
                            class : 'optionclass',
                            label : allValues[i],
                            value : allValues[i]
                        });    
                    }
                }
                //console.log('id>>--->'+tagId);
                component.find(tagId).set("v.options",opts);
            }  
        });
        $A.enqueueAction(action);
	},
    getUserName:function(component,event,helper){
        var action = component.get("c.getloginuserName");
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
             //console.log(response);   
             component.find("tempOwn").set("v.value",response.getReturnValue());
               
            } 
        }); 
       $A.enqueueAction(action);	
    },
    getActualQtyAndAmount : function(component,custmerId,sKUId){
        var action = component.get("c.getInvoiceQtyAndAomunt");
        action.setParams({
            "custId":custmerId,
            "sKUId":sKUId
        });
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var returnVal = response.getReturnValue();
                if(returnVal == null){
                   // alert('No amount');
                     component.set("v.ActualQty",'');
                     component.set("v.ActualAmt",'');
                     component.find("actualQty").set("v.disabled", false);
                    component.find("actualAmt").set("v.disabled", false);

                }else{
                    component.set("v.ActualQty",returnVal.Quantity__c);
                    component.set("v.ActualAmt",returnVal.Net_Value__c);
                    component.find("actualQty").set("v.disabled", true);
                    component.find("actualAmt").set("v.disabled", true);

                }
            }
        });
        $A.enqueueAction(action);	
    },
    getRecordData : function(component,recId){
        var action = component.get("c.fetchAllRecordData");
        action.setParams({
            "recordId": recId
        });
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
             console.log(response);   
             var returnVal = response.getReturnValue();
                //alert(returnVal.sPCampaign.CurrencyIsoCode);
                if(returnVal.sPCampaign != null){
                 	component.set("v.campaignObj",returnVal.sPCampaign);
                    component.find("currency").set("v.value",returnVal.sPCampaign.CurrencyIsoCode);
                }   
             if(returnVal.ForecastInfoList.length != 0){
             	component.set("v.forecastInfoList",returnVal.ForecastInfoList);
             }
            if(returnVal.cropDetailList.length != 0){
             	component.set("v.cropDetailList",returnVal.cropDetailList);
            }
            if(returnVal.demoProtocolList.length != 0){
             component.set("v.demoProtocolList",returnVal.demoProtocolList);
           } 
           if(returnVal.activityList.length != 0){     
             component.set("v.expenseActivityList",returnVal.activityList);	
           }
          if(returnVal.userProfile=='Finance Manager Spain'){
                     component.set("v.isIdPresent",true); 
                     component.find("campName").set("v.disabled",true);
                     component.find("startDate").set("v.disabled",true);
                     component.find("endDate").set("v.disabled",true);
                     component.find("currency").set("v.disabled",true);
                     component.find("campStatus").set("v.disabled",true);          
          }
        	}	                   
        });
        $A.enqueueAction(action);	
    },
    saveCampaign :function(Component,campignObj,custForecastInfoList,cropList,demoList,expenseList,custForecastInfoDelList,cropDelList,demoDelList,expenseDelList){
    	var action = Component.get("c.saveSpainCampaign");
        action.setParams({
            "spainCampaignObj":campignObj,
            "forecastInfoObj":JSON.stringify(custForecastInfoList),
            "cropDetailObj":JSON.stringify(cropList),
            "demoProtocolObj":JSON.stringify(demoList),
            "expenseActObj":JSON.stringify(expenseList),
            "forecastInfoDelObj":JSON.stringify(custForecastInfoDelList),
            "cropDetailDelObj":JSON.stringify(cropDelList),
            "demoProtocolDelObj":JSON.stringify(demoDelList),
            "expenseActDelObj":JSON.stringify(expenseDelList)	
        });
        action.setCallback(this,function(response){       
            if(response.getState() == 'SUCCESS'){
                    //alert(response.getReturnValue());
                     var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                             title : 'Success Message',
                            message: 'Campaign Saved Sucessfully',
                            duration:'5000',
                            key: 'info_alt',
                            type: 'Success',
                            mode: 'dismissible'
                        });
                        toastEvent.fire();
                    
                      var urlEvent = $A.get("e.force:navigateToURL");
    					urlEvent.setParams({
    					  "url": "/"+response.getReturnValue()
                        });
        				urlEvent.fire();
            }
        });
        $A.enqueueAction(action);       
    },
    updateCFIRecord : function(component,event,custForecastRec){
    var action =component.get("c.updateCFIRecord");
        action.setParams({
            "cFIRecord":JSON.stringify(custForecastRec)
        });
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
             //console.log(response);   
             var returnVal = response.getReturnValue();
                if(returnVal=='SUCCESS'){
                     var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                             title : 'Success Message',
                            message: 'Record updated Sucessfully',
                            duration:'5000',
                            key: 'info_alt',
                            type: 'Success',
                            mode: 'dismissible'
                        });
                        toastEvent.fire();
                }
                if(returnVal=='ERROR'){
                    this.showToastMsg(component,event,'There is some Error occured, please contact to System Administrator');
                }
                
            }
        });
          $A.enqueueAction(action);
},
     showToastMsg:function(component,event,msg){
         var message = msg;
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
             title : 'Error Message',
            message: message,
            duration:'5000',
            key: 'info_alt',
            type: 'error',
            mode: 'dismissible'
        });
        toastEvent.fire();
    }
})