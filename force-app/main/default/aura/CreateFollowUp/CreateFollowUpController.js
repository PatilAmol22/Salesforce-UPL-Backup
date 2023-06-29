({
    doInit : function(component, event, helper) {
        helper.fetchPickListVal(component, 'ResonForNotBuying__c', 'reasonfornotbuying');
        helper.fetchPickListVal(component, 'NameProductBought__c', 'nameproductbought');
        helper.fetchPickListVal(component, 'ProductForm__c', 'productform');   
        helper.fetchPickListVal(component, 'PackColour__c', 'packcolor');  
        helper.fetchPickListVal(component, 'PackArtWork__c', 'packartwork'); 
        helper.fetchPickListVal(component, 'SatisfactionLevel__c', 'satisfactionlevel');
        helper.fetchPickListVal(component, 'If_No_Reason__c', 'reasonnotusedentirecroparea');
        
         var today = $A.localizationService.formatDate(new Date()+1, "YYYY-MM-DD");
        component.set("v.maxBuyDate",today);
        var pastDate = $A.localizationService.formatDate(new Date()+1, "YYYY-MM-DD");
        component.set("v.cannotBePast",pastDate);
    },
    
    doSave : function(component, event, helper) {
        var action = component.get("c.createFollowUp");
        alert('j');
        var indexVal = component.get("v.indexOfIteration");
        //var recomId = component.get("v.recomId");
        // var action = component.get("c.createFollowUpNew");
        console.log('actionactionactionaction' +action);
        
        var indexVal = component.get("v.indexOfIteration");
        console.log('indexValindexValindexValindexVal' + indexVal);
        
        var recomId = [];
        
        for(var v = 0 ; v<= indexVal ; v++){
            recomId.push(component.get("v.recomId"));
            // recomId = component.get("v.recomId");
        }
        
        console.log('recomIdrecomIdrecomId' + recomId);
        var findval = component.find(recomId);
        
        console.log('findvalfindvalfindval' + findval);
        
        //component.find("recomId")
       
        action.setParams({
            "recommendationId" : recomId,
            //"recommendationId" : component.get("v.recomId"),
            "buyProduct" : component.get("v.isChecked"),
            "reasonForNot" : component.get("v.reasonnotbuy"),
            "otherReasonDetails" : component.get("v.ifotherspecifyreason"),
            "whichProduct" : component.get("v.productbought"), 
            "whenProduct" : component.get("v.datepro"),
            "whichRetailer" : component.get("v.retailer"),
            "broughtYourself" : component.get("v.selfboughtused"),
            "formProduct" : component.get("v.productformval"),
            "colorProduct" : component.get("v.packcolorval"),
            "artworkProduct" : component.get("v.packartworkval"),
            "entireArea" : component.get("v.isCheckedArea"),
            "acreArea" : component.get("v.numAcre"),
            "resultSatisfied" : component.get("v.satisfactionlevelval"),
            "ifNoReason" : component.get("v.reasonnotusedentirecropareaval"),
            "noDetails" : component.get("v.detailReason"),
            "possibleBuy" : component.get("v.purchase"),
            "possibleApply" : component.get("v.application")
        });
        
        
        action.setCallback(this, function(response){
            
            var state = response.getState();
            var responseVal = response.getReturnValue();
            
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "title": "Saved",
                "message": "The record was saved.",
                "type" : "Success"
            });
            resultsToast.fire();
            
            if(state === 'SUCCESS'){
                alert('Success---if inside success');  
                console.log('currency data is:' + JSON.stringify(responseVal));
                
                component.set("v.setTrue", true);
                component.set("v.returnedId",responseVal.Id);
            }
            
        });
        $A.enqueueAction(action);
        console.log('ok---------------------------------'+component.get("v.recomId"));
        console.log('ok---------------------------------'+component.get("v.isChecked"));
        console.log('ok---------------------------------'+component.get("v.reasonnotbuy"));
        console.log('ok---------------------------------'+component.get("v.ifotherspecifyreason"));
        console.log('ok---------------------------------'+component.get("v.productbought"));
        console.log('ok---------------------------------'+component.get("v.datepro"));
        console.log('ok---------------------------------'+component.get("v.retailer"));
        console.log('ok---------------------------------'+component.get("v.selfboughtused"));
        console.log('ok---------------------------------'+component.get("v.productformval"));
        console.log('ok---------------------------------'+component.get("v.packcolorval"));
        console.log('ok---------------------------------'+component.get("v.packartworkval"));
        console.log('ok---------------------------------'+component.get("v.isCheckedArea"));
        console.log('ok---------------------------------'+component.get("v.numAcre"));
        console.log('ok---------------------------------'+component.get("v.satisfactionlevelval"));
        console.log('ok---------------------------------'+component.get("v.reasonnotusedentirecropareaval"));
        console.log('ok---------------------------------'+component.get("v.detailReason"));
        console.log('ok---------------------------------'+component.get("v.purchase"));
        console.log('ok---------------------------------'+component.get("v.application"));
        
        
    },
    
    handlecheckbox : function(component, event, helper) {
        if (component.get("v.isChecked")){
            component.set("v.truthy", true);}
        else if(!component.get("v.isChecked")){
            component.set("v.truthy", false);
        }
        var selectedOptionsList = component.find("AnyPestInfestation").get("v.checked");
        var liRecom = component.get("v.ListofRecommendation");
        var recom = component.get("v.recommendation");
        
        for (var i = 0; i < liRecom.length; i++) {
            if(liRecom[i].Id == recom.Id){
                liRecom[i].IfProductBought__c = selectedOptionsList;
                console.log('liRecom[i]liRecom[i]liRecom[i]-->'+recom.NameProductBought__c);
                console.log('liRecom[i]liRecom[i]liRecom[i]-->'+recom.CorrectProductBought__c);
                console.log('recom.Idrecom.Idrecom.Idrecom.Id-->'+recom.Id);
                console.log('selectedOptionsListselectedOptionsListselectedOptionsLis===-=-t]-->'+selectedOptionsList);
                
            }
        }
        component.set("v.ListofRecommendation", liRecom);
        
    },
    
    //swapnil
    handleReasonNotBuy :  function(component, event, helper) {
        var selectedOptionsList = event.getParam("value");
        var targetName = event.getSource().get("v.name");
        if(targetName == 'reasonnotbuying'){ 
            component.set("v.reasonnotbuy" , selectedOptionsList);
        }
        
        var liRecom = component.get("v.ListofRecommendation");
        var recom = component.get("v.recommendation");
        
        for (var i = 0; i < liRecom.length; i++) {
            if(liRecom[i].Id == recom.Id){
                liRecom[i].ResonForNotBuying__c = selectedOptionsList;
            }
        }
        component.set("v.ListofRecommendation", liRecom);
    },
    
    handleNameProductBought : function(component,event,helper){
        var selectedOptionsList = event.getParam("value");
        var targetName = event.getSource().get("v.name");
        if(targetName == 'productboughtname'){ 
            component.set("v.productbought" , selectedOptionsList);
        }
        var liRecom = component.get("v.ListofRecommendation");
        var recom = component.get("v.recommendation");
        
        for (var i = 0; i < liRecom.length; i++) {
            if(liRecom[i].Id == recom.Id){
                liRecom[i].NameProductBought__c = selectedOptionsList;
            }
        }
        component.set("v.ListofRecommendation", liRecom);
        
    },
    
    handleProductForm : function(component,event,helper){
        var selectedOptionsList = event.getParam("value");
        var targetName = event.getSource().get("v.name");
        if(targetName == 'productform'){ 
            component.set("v.productformval" , selectedOptionsList);
        }
        var liRecom = component.get("v.ListofRecommendation");
        var recom = component.get("v.recommendation");
        
        for (var i = 0; i < liRecom.length; i++) {
            if(liRecom[i].Id == recom.Id){
                liRecom[i].ProductForm__c = selectedOptionsList;
            }
        }
        component.set("v.ListofRecommendation", liRecom);
        
    },
    
    handlePackColor : function(component,event,helper){
        var selectedOptionsList = event.getParam("value");
        var targetName = event.getSource().get("v.name");
        if(targetName == 'packcolor'){ 
            component.set("v.packcolorval" , selectedOptionsList);
        }
        var liRecom = component.get("v.ListofRecommendation");
        var recom = component.get("v.recommendation");
        
        for (var i = 0; i < liRecom.length; i++) {
            if(liRecom[i].Id == recom.Id){
                liRecom[i].PackColour__c = selectedOptionsList;
            }
        }
        component.set("v.ListofRecommendation", liRecom);
    },
    
    handlePackArtWork  : function(component,event,helper){
        var selectedOptionsList = event.getParam("value");
        var targetName = event.getSource().get("v.name");
        if(targetName == 'packartwork'){ 
            component.set("v.packartworkval" , selectedOptionsList);
        }
        var liRecom = component.get("v.ListofRecommendation");
        var recom = component.get("v.recommendation");
        
        for (var i = 0; i < liRecom.length; i++) {
            if(liRecom[i].Id == recom.Id){
                liRecom[i].PackArtWork__c = selectedOptionsList;
            }
        }
        component.set("v.ListofRecommendation", liRecom);
        
    },
    
    handleUsedCropArea : function(component,event,helper){
        
        
        var selectedOptionsList = component.find("UsedCropArea").get("v.checked");
        var liRecom = component.get("v.ListofRecommendation");
        var recom = component.get("v.recommendation");
        
        
        for (var i = 0; i < liRecom.length; i++) {
            if(liRecom[i].Id == recom.Id){
                liRecom[i].UsedEntireCropArea__c = selectedOptionsList;
                
            }
            
            console.log('liRecom[i]liRecom[i]liRecom[i]-->'+liRecom[i]);
            console.log('recom.Idrecom.Idrecom.Idrecom.Id-->'+recom.Id);
            console.log('selectedOptionsListselectedOptionsListselectedOptionsLis===-=-t]-->'+selectedOptionsList);
            
        }
        component.set("v.ListofRecommendation", liRecom);
        
        if(selectedOptionsList){
            helper.handleAcreAreaHelper(component,event,helper);
        }else if(!selectedOptionsList){
            
            component.find("manyacres").set("v.value","");
            component.set("v.disableSet",false);
            
        }
        
    },
    
    
    handleSatisfaction  : function(component,event,helper){
        var selectedOptionsList = event.getParam("value");
        var targetName = event.getSource().get("v.name");
        if(targetName == 'satisfactionlevel'){ 
            component.set("v.satisfactionlevelval" , selectedOptionsList);
        }
        var liRecom = component.get("v.ListofRecommendation");
        var recom = component.get("v.recommendation");
        
        for (var i = 0; i < liRecom.length; i++) {
            if(liRecom[i].Id == recom.Id){
                liRecom[i].SatisfactionLevel__c = selectedOptionsList;
            }
        }
        component.set("v.ListofRecommendation", liRecom);
        
        console.log('selectedOptionsListselectedOptionsListselectedOptionsList--->' + selectedOptionsList);
        if(selectedOptionsList === '1 - Dissatisfied'){
            console.log('In If--->');
            component.set("v.reqTrue", true);
        }else{
            console.log('In else--->');
            component.set("v.reqTrue", false);
            //component.find("nonUplProduct").set("v.value","");
        }
        
        
        
    },
    
    handleReason  : function(component,event,helper){
        var selectedOptionsList = event.getParam("value");
        var targetName = event.getSource().get("v.name");
        if(targetName == 'reasonnotusedentirecroparea'){ 
            component.set("v.reasonnotusedentirecropareaval" , selectedOptionsList);
        }
        var liRecom = component.get("v.ListofRecommendation");
        var recom = component.get("v.recommendation");
        
        for (var i = 0; i < liRecom.length; i++) {
            if(liRecom[i].Id == recom.Id){
                liRecom[i].ReasonNotUsedEntireCropArea__c = selectedOptionsList;
            }
        }
        component.set("v.ListofRecommendation", liRecom);
        
        console.log('selectedOptionsListselectedOptionsListselectedOptionsList--->' + selectedOptionsList);
        if(selectedOptionsList === 'Others'){
            console.log('In If--->');
            component.set("v.reqTrueVal", true);
        }else{
            console.log('In else--->');
            component.set("v.reqTrueVal", false);
            component.find("detailOtherReason").set("v.value","");
        }
        
    },
    
    handleAcreArea : function(component,event,helper){
        
        var acreAreaVal = component.get("v.AcreArea");
        var selectedOptionsList = event.getParam("value");
        var targetName = event.getSource().get("v.name");
        
        component.set("v.acreAreaValidation",selectedOptionsList);
        
        
        console.log('acreAreaValacreAreaVal' + acreAreaVal);
        console.log('selectedOptionsListselectedOptionsList' +selectedOptionsList);
        console.log('acre area is --' +acreAreaVal+ ' selected area is ' +selectedOptionsList);
        
        var liRecom = component.get("v.ListofRecommendation");
        var recom = component.get("v.recommendation");
        //12                                //13
        //var getvalue = acreAreaVal <= selectedOptionsList;
        //console.log('--0kay here- t/f '+ getvalue);
        //if(event.getParam("value") < component.get("v.AcreArea")){
        //if( selectedOptionsList < acreAreaVal){
            //component.set("v.UseCropArea__c",acreAreaVal);
       // console.log("inside iff");
            for (var i = 0; i < liRecom.length; i++) {
            if(liRecom[i].Id == recom.Id){
                liRecom[i].UseCropArea__c = selectedOptionsList;
            }
         }
            component.set("v.ListofRecommendation", liRecom);
       // }
    },
    
})