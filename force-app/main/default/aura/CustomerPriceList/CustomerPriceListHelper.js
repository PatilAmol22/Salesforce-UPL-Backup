({
    getProfileName: function(component,event,helper) {
        var action = component.get("c.getProfileVisibility");
        action.setCallback(this, function(response) {
        var callBackResponse =  response.getReturnValue();       
        component.set("v.PV", response.getReturnValue());
        });
           $A.enqueueAction(action);
		
    },
	getSalesDistrict: function(component,event,helper) {        
        component.find("customer").set("v.value",'');
        component.find("priceBook").set("v.value",'');
        var action = component.get("c.getSalesDistrict");
        action.setCallback(this, function(response) {
        var callBackResponse =  response.getReturnValue();       
        component.set("v.sd", response.getReturnValue());
            console.log('called js');
            console.log('data@@:'+callBackResponse);
            if(response.getReturnValue().length==1){ 
                
            window.setTimeout(
                $A.getCallback( function() {
                    console.log('called js1');
                    // Now set our preferred value
                    component.find("salesDist").set("v.value", response.getReturnValue()[0].Id);
                    
                  }));
                action.setCallback(this, function(a) {
                    console.log('called js2');
				component.set("v.sd", a.getReturnValue());
                component.set("v.showCust",false);
                component.set("v.showPB",false);     
				});
                
            }
            
            
     });

        $A.enqueueAction(action);
		
	},
    helperGetCustomer: function(component,event,helper) { 
        var crmId=component.find("salesDist").get("v.value");
        if(crmId){
            $A.util.addClass(component.find("sderro"),"slds-hide");            
        }
        else{
            $A.util.removeClass(component.find("sderro"),"slds-hide"); 
        }
        component.set("v.showCust",true);
        component.set("v.showPB",false);//true
        component.find("priceBook").set("v.value",'');
        var crmId=component.find("salesDist").get("v.value");
        console.log('crmId---'+crmId);
        var action = component.get("c.getCustomers");
        action.setParams({
            "Id": crmId
        });
        action.setCallback(this, function(response) {
        var callBackResponse =  response.getReturnValue();
        var customers =JSON.parse(JSON.stringify(callBackResponse));
        
           console.log('response.getState()--'+response.getState());
            if (response.getState()=='SUCCESS'){
                console.log('response.getState()-*-'+response.getState());
            component.set("v.cust", response.getReturnValue());
            if(response.getReturnValue().length==1){ 
                console.log('inside if');
                window.setTimeout(
                    $A.getCallback( function() {
                        // Now set our preferred value
                        component.find("customer").set("v.value", response.getReturnValue()[0].Id);
						console.log('value set');	
                        component.set("v.showCust",true);
                        component.set("v.showPB",false);//true
                    }));       
            } else{console.log('check console');component.set("v.showCust",true);console.log('check console1');
                        component.set("v.showPB",false);}   //true
            }else{
                 component.set("v.showCust",false);
                 component.set("v.showPB",false);
                console.log('check console3');
       			 component.find("priceBook").set("v.value",'');                
        		component.find("customer").set("v.value",'');
                $A.util.addClass(component.find("custerro"),"slds-hide");
            	$A.util.addClass(component.find("pberro"),"slds-hide");
            }
     });

        $A.enqueueAction(action);
		
	},
    helperGetPriceBook: function(component,event,helper) {
        
        var custId=component.find("customer").get("v.value");
        if(custId){
            $A.util.addClass(component.find("custerro"),"slds-hide");
        }
        else{
            $A.util.removeClass(component.find("custerro"),"slds-hide");
        } 
        
         console.log('in helperGetPriceBook ')
       // var custId=component.find("customer").get("v.value");
       
         console.log('Test it');
         var crmId=component.find("salesDist").get("v.value");
        console.log('crmId---'+custId+'-------'+crmId);
        //if(custId){
        var action = component.get("c.getPriceBookList");
        action.setParams({
            "crmId":crmId,
            "custId":custId
        });
        
        action.setCallback(this, function(response) {
        var callBackResponse =  response.getReturnValue();
        var priceList =JSON.parse(JSON.stringify(callBackResponse));
        console.log('response.getState()-'+response.getState());
            if(response.getState()=='SUCCESS'){
            component.set("v.pbl", response.getReturnValue());
            component.set("v.showCust",true);
            component.set("v.showPB",true);
            if(response.getReturnValue().length==1){ 
                console.log('inside if');
                window.setTimeout(
                    $A.getCallback( function() {
                        // Now set our preferred value
                        component.find("customer").set("v.value", response.getReturnValue()[0].Id);
						console.log('value set12');						                    
                    })); 
               
            } }else{console.log('22');component.set("v.showPB",false);component.find("priceBook").set("v.value",''); }
        });
         $A.enqueueAction(action);
       // }
        /*else{
            component.set("v.showPB",false);            
        	component.find("priceBook").set("v.value",'');
             $A.util.addClass(component.find("pberro"),"slds-hide");
        } */
    },
    
    
    helperSDGetPriceBook: function(component,event,helper) {
        
        var custId=component.find("customer").get("v.value");
       /* if(custId){
            $A.util.addClass(component.find("custerro"),"slds-hide");
        }
        else{
            $A.util.removeClass(component.find("custerro"),"slds-hide");
        } */
        
         console.log('in helperGetPriceBook ')
       // var custId=component.find("customer").get("v.value");
       
         console.log('Test it');
         var crmId=component.find("salesDist").get("v.value");
        console.log('crmId---'+custId+'-------'+crmId);
        //if(custId){
        var action = component.get("c.getPriceBookList");
        action.setParams({
            "crmId":crmId,
            "custId":custId
        });
        
        action.setCallback(this, function(response) {
        var callBackResponse =  response.getReturnValue();
        var priceList =JSON.parse(JSON.stringify(callBackResponse));
        console.log('response.getState()-'+response.getState());
            if(response.getState()=='SUCCESS'){
            component.set("v.pbl", response.getReturnValue());
            component.set("v.showCust",true);
            component.set("v.showPB",true);
            if(response.getReturnValue().length==1){ 
                console.log('inside if');
                window.setTimeout(
                    $A.getCallback( function() {
                        // Now set our preferred value
                        //component.find("customer").set("v.value", response.getReturnValue()[0].Id);//commented by swapnil - Customer value is changing to null
						console.log('value set12');						                    
                    })); 
               
            } }else{console.log('22');component.set("v.showPB",false);component.find("priceBook").set("v.value",''); }
        });
         $A.enqueueAction(action);
       // }
        /*else{
            component.set("v.showPB",false);            
        	component.find("priceBook").set("v.value",'');
             $A.util.addClass(component.find("pberro"),"slds-hide");
        } */
    },
    helperGetPriceList: function(component,event,helper) { 
        var custId=component.find("customer").get("v.value");
        var crmId=component.find("salesDist").get("v.value");
        var pbId= component.find("priceBook").get("v.value");

               console.log("pbid**********",pbId);

        
        console.log('b4');
        var visibility= component.get("v.PV");
        console.log('visibility**************************',visibility);
        
        
         
                       
        //alert("hello");
        
        if(visibility){
            var showFSP=component.find("FSP").get("v.value");
            var showMP=component.find("MP").get("v.value");
            console.log('ShowFSP-'+showFSP+'--showMP--'+showMP);
        }
        
        console.log('crmId---'+crmId+'---custId----'+custId+'---pbId----'+pbId);
        if((custId!= '' && custId != null) &&( crmId != '' && crmId!= null) &&( pbId!= '' && pbId != null)){
        var action = component.get("c.getPriceLists");
        action.setParams({
            "custId": custId,
            "crmId":crmId,
            "pbId":pbId
        });
        component.set("v.ShowSpinner", true);
        component.set("v.DisplayComponents",false);
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state+'----');
            if (state === "SUCCESS"){
            var callBack =  response.getReturnValue();
                console.log('callBack--'+callBack);
                 console.log('callBack--'+JSON.stringify(callBack));

               /* nEW CHANGES START HERE */
           console.log('Lengthsss---'+response.getReturnValue().length);
           
            component.set("v.custPLs", callBack );
                 console.log('custPLs -'+ component.get("v.custPLs"));
                      var custPriceList = component.get("v.custPLs");
        console.log("custPriceList**********)))))))))",custPriceList);
          for(var i = 0; i < custPriceList.length; i++){
            //var replc = priceDetailList1[i].materialPlnRplcCost;
            
              //BELOW 20 LINES OF CODE ADDED BY HARSHIT&SAGAR@WIPRO FOR (US PB-006) ---START
              var curr = custPriceList[i].currISOCode;
              console.log('currrrr is***'+curr);
            //var unitValueBRL1 = priceDetailList1[i].unitValueBRL;
            //var unitValueUSD1 = priceDetailList1[i].unitValueUSD;
                        
              if(curr=="BRL"){
                  //curr1=true;
                  component.set("v.showUSDPrice",false);
                  component.set("v.showBRLPrice",true);
					
              }
               if(curr=="USD"){
                  //curr1=true;
                  component.set("v.showBRLPrice",false);
                  component.set("v.showUSDPrice",true);
					
              }
           
             console.log('showBRLPrice***',component.get("v.showBRLPrice"));
              console.log('showUSDPrice***',component.get("v.showUSDPrice"));
        
//---END
    
          }
    
                
            if(visibility){
                component.set("v.showFSP",showFSP);
                component.set("v.showMinP",showMP);
            }
                component.set("v.ShowSpinner", false);
            component.set("v.DisplayComponents",true);            
                console.log('Pagination done Last');  

                
            }
            else
            {
                console.log('ERROR-', response.getError());
                component.set("v.ShowSpinner", false);
            	component.set("v.DisplayComponents",false);
                component.find('notifLib').showToast({
                    "variant": "error",
                    "title": "error!",
                    "message": "No Price List Available"
                });     
            }
        });

        
         $A.enqueueAction(action);
            
            
        }else{
            if(crmId == null || crmId == ''){$A.util.removeClass(component.find("sderro"),"slds-hide");}
            if(custId == null || custId == ''){$A.util.removeClass(component.find("custerro"),"slds-hide");}
            if(pbId == null || pbId == ''){$A.util.removeClass(component.find("pberro"),"slds-hide");}
            
        }
        
        
        
        //alert("hellp");
        
        
     
    },
})