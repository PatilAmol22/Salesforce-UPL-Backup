({
	getTypeOfCamaign : function(cmp,event,recordId) {
        console.log('getTypeOfCamaign called...');
        cmp.set("v.showSpinner1",true);
        var action = cmp.get("c.getCampaigntype");
		
        action.setParams({
            "priceBookId":recordId
        });

        action.setCallback(this,function(resp){
        var state = resp.getState();
        if(cmp.isValid() && state === 'SUCCESS'){
            console.log('response..... '+resp.getReturnValue());
          
           var cmpTyp =resp.getReturnValue();
            
            if(cmpTyp == 'Structured'){
               // alert(cmpTyp);
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef  : "c:StructuredCampaign" ,//c:PriceBookClone
                componentAttributes  : {
                    recordId :recordId 
                }
            });
            console.log('Event '+evt);
            evt.fire();
           }
           else{
             //  alert(cmpTyp);
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef  : "c:NewBrazilPricebook" ,
                componentAttributes  : {
                    recordId :recordId 
                }
            });
            console.log('Event '+evt);
            evt.fire();
           }
           cmp.set("v.showSpinner1",false);         
        }else{
            console.log(resp.getError());
            cmp.set("v.showSpinner1",false);
        }
        
        });
        $A.enqueueAction(action);
        
    },
})