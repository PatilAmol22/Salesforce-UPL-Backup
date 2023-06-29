({
	UpdateBrandhelp:function(component,event,helper,approvedBrnd,UnapprovedBrnds) {
        var action =component.get("c.updateBrandRef");
        console.log('>>--->'+approvedBrnd);
        console.log('>>--->'+UnapprovedBrnds);
        action.setParams({
            "brand" : JSON.stringify(approvedBrnd),
            "brands" : JSON.stringify(UnapprovedBrnds)
        });
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                
                var record = response.getReturnValue();
                if(record!= null){
                window.location ='/lightning/r/Brand__c/'+record.Id+'/view?0.source=alohaHeader';
            	 }else{
                    alert('There is some problem, Please contact to System Administrator');
                }
            }
        });
         $A.enqueueAction(action);
	},
    UpdateComphelp : function(component, event, helper,approvedcmp,Unapprovedcmpes) {
		var action =component.get("c.updateCmpRef");
        console.log('>>--->'+approvedcmp);
        console.log('>>--->'+Unapprovedcmpes);
        action.setParams({
            "company" : JSON.stringify(approvedcmp),
            "companies" : JSON.stringify(Unapprovedcmpes)
        });
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                console.log(response.getReturnValue());
                var record = response.getReturnValue();
                if(record!= null){
                window.location ='/lightning/r/Company__c/'+record.Id+'/view?0.source=alohaHeader';
                }else{
                    alert('There is some problem, Please contact to System Administrator');
                }
            }
        });
         $A.enqueueAction(action);
	},
	UpdateFrmhelp : function(component, event, helper,approvedfrm,Unapprovedfrms) {
		var action =component.get("c.updateFrmRef");
        console.log('>>--->'+approvedfrm);
        console.log('>>--->'+Unapprovedfrms);
        action.setParams({
            "formulation" : JSON.stringify(approvedfrm),
            "formulations" : JSON.stringify(Unapprovedfrms)
        });
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var record = response.getReturnValue();
                if(record!= null){
                window.location ='/lightning/r/Formulation__c/'+record.Id+'/view?0.source=alohaHeader';
            	 }else{
                    alert('There is some problem, Please contact to System Administrator');
                }
           }
        });
         $A.enqueueAction(action);
	}
})