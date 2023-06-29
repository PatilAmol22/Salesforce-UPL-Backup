({
     
    //code for cancelReason by Harshit&Sirisha
    doInit: function(component, event, helper) {        
        helper.getCancelReasonPicklist(component, event);
                helper.SKUUpdateAPI(component, event, helper); // Added by Sagar@Wipro for StatusOrdemVendas API Call

    },
    handleUserUpdated: function(component, event, helper) { 
    var user = component.get("v.User") ;
    var Profile = user.Profile.Name;
        
        if(Profile == 'System Administrator' ||
          Profile == 'Brazil System Administrator' ||
          Profile == 'Brazil Sales District Manager' ||
          Profile == 'Brazil Customer Service User' ||
          Profile == 'Brazil Customer Service Manager' ||
          Profile == 'Brazil Sales Person') {
            component.set("v.GetOrder", true);
        }
        else{
            
             var toastEvent = $A.get("e.force:showToast");
                   

            toastEvent.setParams({
                "title": $A.get("$Label.c.Error"),
                "message": $A.get("$Label.c.RestrictOrderBlocking"),
                "type": "error"
            });
            toastEvent.fire();
            $A.get("e.force:closeQuickAction").fire();
        }
    
    },
     
    //Method for cancelReason by Harshit&Sirisha
    cancellationReason: function(component, event, helper){
        
        var cancelReason = component.get("v.cancel.Cancellation_Reason__c");
        console.log('cancelReason'+cancelReason);
        //alert(cancelReason);
       
       
    },
    handleRecordUpdated: function(component, event, helper) {       
        component.set("v.ShowLC", true);
        component.set("v.ShowSpinner", false);
    },
    
    Yes : function(component, event, helper) {
        component.set("v.ShowSpinner", true);
        component.set("v.ShowLC", false);
        
        if(component.get("v.simpleRecord.BrazilSalesOrderStatus__c") == 'Blocked'){
             var toastEvent = $A.get("e.force:showToast");
             toastEvent.setParams({
                "title": $A.get("$Label.c.Error"),
                "message": $A.get("$Label.c.BlockedOrder"),
                "type": "error"
            });
            toastEvent.fire();
                    

            
            $A.get("e.force:closeQuickAction").fire();
            component.set("v.ShowModel", false);
        }

        else{ 
        if(component.get("v.simpleRecord.BrazilSalesOrderStatus__c") == 'Approved' &&
          component.get("v.simpleRecord.BrazilSalesOrderStatus__c") == 'Aprovado'){
            var toastEvent = $A.get("e.force:showToast");
                   

            toastEvent.setParams({
                "title": $A.get("$Label.c.Error"),
                "message": $A.get("$Label.c.OBApprovedMessage"),
                "type": "error"
            });
            toastEvent.fire();
                    

            
            $A.get("e.force:closeQuickAction").fire();
            component.set("v.ShowModel", false);
        }
        
               
        else{
            if(component.get("v.simpleRecord.Type_of_Order__c") == 'ORDEM FILHA' && component.get("v.simpleRecord.Type_of_Order__c") == 'CONTRATO MÃE' ){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": $A.get("$Label.c.Error"),
                    "message": $A.get("$Label.c.OBChildSalesOrders"),
                    "type": "error"
                });
                toastEvent.fire();
    
                
                
                $A.get("e.force:closeQuickAction").fire();
                component.set("v.ShowModel", false);
            }
            else{
                //Only Admin and the customer service team will have an option to resubmit the order
                 var user = component.get("v.User") ;
                 var Profile = user.Profile.Name;
                
                var message = component.get("v.simpleRecord.Blocked_Cancellation_Message__c");
                /*if((typeof  message != "undefined" &&
                  (Profile == 'Brazil System Administrator' ||
                   Profile == 'System Administrator' ||
                   Profile == 'Brazil Customer Service User' ||
                   Profile == 'Brazil Customer Service Manager')) 
                   || message == null 
                   || typeof  message == "undefined"){*/
                //Code Added By Sagar for Sales Order Cancellation
                var action = component.get("c.OrderBlockingMethod");
                var comments = component.find('Comments').get('v.value');
                var reason = component.get("v.cancel.Cancellation_Reason__c");
                var reason1 = component.find('CancellationReasonPicklist').get('v.value');
                 console.log('reason'+reason);
                 console.log('reason1'+reason1);
                    console.log('comments'+comments);
                action.setParams({ sapOrderNumber : component.get("v.simpleRecord.SAP_Order_Number__c"),
                                 comments : comments,
                                 ReasonCode: component.get("v.cancel.Cancellation_Reason__c")});

                action.setCallback(this, function(response) {
                    
                    var state = response.getState();
                    var responseValue = response.getReturnValue();
                    console.log('responseValue1'+responseValue);
                    console.log('state'+state);
                    if (state === "SUCCESS") {
                        console.log('responseValue'+responseValue);
                        console.log('1st if');
                        if(responseValue === "Parent_Order"){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": $A.get("$Label.c.Error"),
                                "message": $A.get("$Label.c.OBChildParentOrders"),
                                "type": "error"
                            });
                            toastEvent.fire();
                                    

                            
                        }
                        else{
                            alert(responseValue);
                             component.set("v.ShowModel", false);
                           /*  var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({                                
                                "message": responseValue,
                                "type": "warning"
                            });
                            toastEvent.fire();*/
                            
                        }
                        
                   //     $A.get("e.force:closeQuickAction").fire();
                       
                    }
                    else if (state === "INCOMPLETE") {
                        
                                 

                      //  $A.get("e.force:closeQuickAction").fire();
                        component.set("v.ShowModel", false);
                    }
                        else if (state === "ERROR") {
                             console.log('5th if');
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": $A.get("$Label.c.Error"),
                                "message": $A.get("$Label.c.OBChildParentOrders"),
                                "type": "error"
                            });
                            toastEvent.fire();
                            
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    console.log("Error message: " + 
                                                errors[0].message);
                                }
                                
                                $A.get("e.force:closeQuickAction").fire();
                                component.set("v.ShowModel", false);
                                        

                            } else {
                                console.log("Unknown error");
                                       

                                $A.get("e.force:closeQuickAction").fire();
                                component.set("v.ShowModel", false);
                            }
                        }
                });
                
                
                $A.enqueueAction(action);
           
                /*}     
                
                else{
                    
                    var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": $A.get("$Label.c.Error"),
                    "message": $A.get("$Label.c.Order_Block_Resubmit"),
                    "type": "error"
                });
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
                component.set("v.ShowModel", false);
                    
                }*/
            }
          
              
        }
        }
        
    },
    
    No : function(component, event, helper) {
       // $A.get("e.force:closeQuickAction").fire();
                component.set("v.ShowLC", false);

        component.set("v.ShowModel", false);
        if($A.get("e.force:closeQuickAction"))
         $A.get("e.force:closeQuickAction").fire();
    },
    
    
})