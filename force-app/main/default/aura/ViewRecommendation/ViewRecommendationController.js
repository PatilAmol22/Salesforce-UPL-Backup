({
    doInit: function(component, event, helper) {
        
       var taskid = component.get("v.TaskId"); 
        //alert('--task id '+taskid);
        console.log('--task id '+taskid);
        if(taskid != null){
            var action = component.get("c.subject");
        action.setParams({
            "taskrec": component.get("v.TaskId")
        });
        action.setCallback(this, function(response){
             var state = response.getState();
             if(state === 'SUCCESS'){
                 var sub = response.getReturnValue();
                 //alert('gere');
                 if(sub == 'Call To Farmer - For Recommendation')
                 {
                     //alert('gerein if');
                     component.set("v.subjectrecommendation",sub);
                      component.set("v.followUpFlagVR1",false);
                     component.set("v.viewfollowup",true);
                     //component.set("v.passViewFollow",true);
                     //component.set("v.sett",false);
                 }else if(sub == 'Call To Farmer - For Follow Up'){
                     //alert('gereinelse if');
                      component.set("v.subjectfollowup",sub);
                      component.set("v.viewfollowup",false);
                     component.set("v.passViewFollow",true);
                     component.set("v.editfollowup",true);
                     /*if(component.get("v.sett")){
                         component.set("v.passViewFollowCloseCall",true);
                         component.set("v.passViewFollow",false);
                      	component.set("v.sett1",false);
                     }*/
                     
                 }
                 
                }
         });
        $A.enqueueAction(action);
            
        
        }else{
            component.set("v.followUpFlagVR1",false);
        }
        },
    
    
	 handleCancel : function(component, event, helper){
         if(!component.get("v.sett1")){
             component.set("v.passViewFollow",false);
             component.set("v.sett1",true);
         }
        if(!component.get("v.sett")){
            component.set("v.followUpFlagVR", false);
             component.set("v.passViewFollowCloseCall", false); 
            component.set("v.passViewFollow",true);
            component.set("v.sett",true);
        }
    },
    
    doSaveChild : function(component, event, helper){
        /*
        var child = component.find("createFollowComponent");
        child.callChild();
        child.callChildOne();
        */

		
        var aavalidation = parseInt(component.get("v.acreAreaValidation"));
        var acreAreaVal = parseInt(component.get("v.AcreArea"));
        console.log('Existing val -- ');
        console.log(acreAreaVal);
        console.log('Entered val -- ');
        console.log(aavalidation);
        if(aavalidation > acreAreaVal){
            console.log('error msg in if, if entered value is greater than original');
            var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Invalid Acre Area",
                        "message": " Please select " + acreAreaVal + " or less than "+acreAreaVal+" .",
                        "type" : "Error"
                    });
                    resultsToast.fire();
        	
        }
        else{
            
            
             var action = component.get("c.saveRecommendation");
        action.setParams({
            "lirec": component.get("v.ListofRecommendation")
        });
        action.setCallback(this, function(response){
             var state = response.getState();
             if(state === 'SUCCESS'){
                 //component.set("v.ListofRecommendation", response.getReturnValue());
                 component.set("v.passViewFollowCloseCall", false);
                 if(component.get("v.subjectfollowup")!=null){
                 alert('condition');
                     component.set("v.onSaveHide",false);
                     component.set("v.onSaveHide1",true);
                     component.set("v.passViewFollow", true);
                 }
                 var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Saved Recommendation",
                        "message": "The record was saved.",
                		"type" : "Success"
                    });
                    resultsToast.fire();
             }
         });
        $A.enqueueAction(action);
            
        }
        
        	

        
       
    },
    
    handleViewFollowUp : function(component, event, helper) {
		
        component.set("v.followUpFlagVR1",true);
		if (component.get("v.sett1")){
            
            //component.set("v.followUpFlagVR", true); 
            component.set("v.passViewFollowCloseCall", false); 
            component.set("v.passViewFollow",true);
            component.set("v.sett1",false);
        }
    },
    
    
    handleProductFollowUp : function(component, event, helper) {
		
        component.set("v.followUpFlagVR",true);
		if (component.get("v.sett")){
            //component.set("v.followUpFlagVR", true); 
            //
            component.set("v.passViewFollowCloseCall", true); 
            component.set("v.passViewFollow",false);
            //
            component.set("v.sett",false);
        }
    },
    
    handleFollowUp : function(component, event, helper){
      	component.set("v.passViewFollowCloseCall", false);
    },
    
    handleNextRecommendation : function(component, event, helper){
      
        component.set("v.rFlagSave",true);
        component.set("v.onSaveHide",true);
        //component.set("v.recommendationFlagSave",true);
    },
    
    handleCancelAfterFollowUp : function(component, event, helper){
      	
        component.set("v.rFlagSave",false);
        
    },
    
    
})