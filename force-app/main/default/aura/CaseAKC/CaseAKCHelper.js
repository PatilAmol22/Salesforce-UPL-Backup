({
    // Issue reported by IBM team - Prashant Chinchpure date 25th feb 2021- Start (calling existing doinit code)
     helperMethod : function(component, event,helper) {
         console.log('init function called');
           console.log('Test Call');
         component.set("v.isNurtureFarmCase",false);
         component.set("v.isUPLConsumerProduct",false);
           //Added by Varun Shrivastava Start
           /*console.log('Account ID : '+component.get("v.recordId"));
           
           var pageRef = component.get("v.pageReference");
           var state = pageRef.state; // state holds any query params
           var base64Context = state.inContextOfRef;
           if (base64Context.startsWith("1\.")) {
                 base64Context = base64Context.substring(2);
           }
           var addressableContext = JSON.parse(window.atob(base64Context));
           var accountID =  addressableContext.attributes.recordId;
           console.log('Account ID : '+component.get("v.recordId"));*/
           //Added by Varun Shrivastava End
           
          var recordTypeId = '';
          var additionalParams = '';
           try{
             console.log('get info ',JSON.stringify(component.get("v.pageReference")))
           if(JSON.stringify(component.get("v.pageReference")) != null ){
           
              recordTypeId = component.get("v.pageReference").state.recordTypeId;
             component.set("v.caseRecordTypeForNurture",recordTypeId);
             
               additionalParams = component.get("v.pageReference").state.additionalParams;
             console.log('additionalParams ',JSON.stringify(additionalParams));
           }
           
            var accString = '';
            var accStringforUPLConsumer='';

           if(additionalParams!=undefined && additionalParams!=''){
               accString = additionalParams.split("=")[1].replace("&","");
               component.set("v.accIdForNurture",accString); 
               // <!--New Changes(start) - Ishu (for UPL Consumer)-->
               if(additionalParams.split("=")[2]!=null)
               {
                accString = additionalParams.split("=")[2].replace("&","");
              component.set("v.accIdForUPLConsumer",accString);    
               }
            //    <!--New Changes(stendart) - Ishu --> 

           }    
               console.log('accString'+accString);
             var recordid = component.get("v.recordId");
             console.log('recordid ',recordid);
             console.log('recordTypeId ',recordTypeId);
             console.log('accString ',accString);
               var action  = component.get("c.getReordInformation");
               action.setParams({
                   "recId": recordid,
                   "recTypeId":recordTypeId,
                   "accId": accString
               });
           var recordid = component.get("v.recordId");
           
         action.setCallback(this,function (result){
             console.log('result ',JSON.stringify(result));
               var responseList = result.getReturnValue();
             console.log('responseList ',responseList);
             var isDataPattern = responseList[1];
             //Added by Varun Shrivastava Start
             var isUPLGeneralCase = responseList[2];
             //Added by Varun Shrivastava End
             //Added by prashant chinchpure 2 july 2020 Start
                var isColombiaCase = responseList[3];
             //Added by prashant chinchpure End
             //Added by Varun Shrivastava Start
             //var isakcRetailerCase = responseList[4];
             //console.log('AKC Retailer Flag : '+isakcRetailerCase);
             //Added by Varun Shrivastava End
             //Changes start - Ben
             var isNurtureCase= responseList[4];
             var isUPLConsumerProduct=responseList[5];
             //Changes end - Ben
             console.log('isDataPattern>>--->'+isDataPattern);
             //alert("recordid"+recordid);
             if(isDataPattern){
                 var urlEvent = $A.get("e.force:navigateToURL");
                 urlEvent.setParams({
                   "url": "/apex/Case_AKC",
                   "isredirect": "true"
                 });
                 urlEvent.fire();
             }
             //Changes start - Ben
             else if (isNurtureCase ) {
                 console.log('getting in boolean');
                 var workspaceAPI = component.find("workspace");
                 workspaceAPI.getFocusedTabInfo().then(function (response) {
                     var focusedTabId = response.tabId;
                     component.set("v.focustab",focusedTabId);
                 })
                     .catch(function (error) {
                         console.log(error);
                     });
                 
                 component.set("v.isNurtureFarmCase",true);
                 
                 
             }
             //Changes end - Ben
             //Added by Ishu Mittal for UPL Consumer
             else if(isUPLConsumerProduct)
             { 
                 console.log('getting in boolean');
                 var workspaceAPI = component.find("workspace");
                 workspaceAPI.getFocusedTabInfo().then(function (response) {
                     var focusedTabId = response.tabId;
                     component.set("v.focustab",focusedTabId);
                 })
                     .catch(function (error) {
                         console.log(error);
                     });
                 
                 component.set("v.isUPLConsumerProduct",true); 
             }
             //Chnages end-Ishu
             
             else if(isColombiaCase){
                 console.log('isColombiaCase>>--->',isColombiaCase);
                 if(component.find('colombiaCase')){
                      var childcmp = component.find('colombiaCase');
                          childcmp.destroy();
                      console.log('TESX>>> ',JSON.stringify(childcmp));
                 }
                  //if(!component.get("v.isColombiaCase")){
                       component.set("v.isColombiaCase",true);
                       //this.navigateToStandardPage(component, event,helper);
                  // location.reload();
                // } //
                 
                
                    
             }
             //Added by Varun Start
             else if(isUPLGeneralCase){
                 var urlEvent = $A.get("e.force:navigateToURL");
                 console.log('accString : '+accString);
                 urlEvent.setParams({
                   "url": "/apex/Case_UPL_GeneralCase_Creation?accountId="+accString,
                   "isredirect": "true"
                 });
                 urlEvent.fire();
             }
             //Added by Varund End
             ////Added by Varun Shrivastava AKC Retailer Start
             
             /*else if(isakcRetailerCase){
                 var urlEvent = $A.get("e.force:navigateToURL");
                 console.log('accString : '+accString);
                 urlEvent.setParams({
                   "url": "/apex/Case_UPL_GeneralCase_Creation?accountId="+accString,
                   "isredirect": "true"
                 });
                 urlEvent.fire();
             }
             //Added by Varun Shrivastava AKc Retailer End
             */
             else if(recordid != null || recordid != undefined ){
                 if(component.get("v.recordTypeId")){
                     component.set("v.isColombiaCase",true);
                     //this.navigateToStandardPage(component, event,helper);
                 }
                 /*console.log('recordid 85>>--->'+component.get("v.recordId"));
                 var editRecordEvent = $A.get("e.force:editRecord");
                 editRecordEvent.setParams({
                  "recordId":recordid
                    });
              console.log('------------------------------');	
          editRecordEvent.fire();*/
                     
             }
             else if(recordid == null || recordid == undefined){
                 
         var createRecordEvent = $A.get("e.force:createRecord");
                 //If UPL Gen case and farmer promotional product is found
                 if(responseList[0]==true){
                     createRecordEvent.setParams({
                         "entityApiName": "Case",
                         "recordTypeId":recordTypeId,
                         "defaultFieldValues": {                            
                             'AccountId' : accString,
                             'Theme_of_Month__c': true,
                             'PriorPromotion__c': true
                         }           
                     });  
                 }
                 //If farmer promotional product is not found
                 else{
                     if(accString != ''){
                     createRecordEvent.setParams({
                         "entityApiName": "Case",
                         "recordTypeId":recordTypeId,
                         "defaultFieldValues": {
                             //'Phone' : '415-240-6590',
                             'AccountId' : accString                            
                         }           
                     });       
                     }
                     else{
                      createRecordEvent.setParams({
                         "entityApiName": "Case",
                         "recordTypeId":recordTypeId                                
                     });       
                     }
                 }
         createRecordEvent.fire();                
             }  
         });
        $A.enqueueAction(action);
               }
           catch(e){
                 console.error(e);
           }
     },
     
     // Issue reported by IBM team - Prashant Chinchpure date 25th feb 2021- End (calling existing doinit code)
 })