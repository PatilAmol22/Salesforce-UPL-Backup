({
	 doInit : function (component, event) {
         var createRecordEvent = $A.get("e.force:createRecord"); 
         var userId = $A.get("$SObjectType.CurrentUser.Id");
			console.log('userId>>--->'+JSON.stringify(userId));
         var recordTypeId = component.get("v.pageReference").state.recordTypeId;
          console.log('Page ref-->'+JSON.stringify(component.get("v.pageReference")));
          var additionalParams = component.get("v.pageReference").state.additionalParams;
          //console.log("additionalParams--> "+additionalParams);         
              var action  = component.get("c.getuserCountry");
              console.log('recordTypeId>>--->'+recordTypeId);
              //console.log("recordid>>--->"+recordid);
              action.setParams({                  
                  "recTypeId":userId
              });
          //console.log("accString==> "+accString);
          //var recordid = component.get("v.recordId");
          
        action.setCallback(this,function (response){
          	
           //Checking the server response state
    		//let state = response.getState();            
            
           // if (state === "SUCCESS") {
        	// Process server success response
        	var CountryName = response.getReturnValue();
            
                if(CountryName!=''){
                   
                    createRecordEvent.setParams({
                        "entityApiName": "Community_Configuration__c",
                        "recordTypeId":recordTypeId,
                        "defaultFieldValues": {                           
                            'Country__c': CountryName                            
                        }           
                    });                     
            }
                
                else{
                console.log('Not Prospect 1');
                createRecordEvent.setParams({
                    "entityApiName": "Community_Configuration__c",
                    "recordTypeId":recordTypeId,
                    "defaultFieldValues": {                           
                       // 'Country__c': responseWrapper.userCountry                            
                    } 
        		}); 
            }   
                
    	//}           
           
        /*else if (state === "ERROR") {
        // Process error returned by server
        console.log('Not Prospect 2');
        createRecordEvent.setParams({
                "entityApiName": "Account",
                "recordTypeId":recordTypeId,
                "defaultFieldValues": {                           
                   // 'Country__c': responseWrapper.userCountry                            
                }                                  
        });     
    }  */
           
    createRecordEvent.fire();                
    });      
   $A.enqueueAction(action);
  }   
})