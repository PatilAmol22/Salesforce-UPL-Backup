({	
    ctr : function(cmp, event, helper) {
        var locale = $A.get("$Locale.langLocale");
        var validUser;
        if(locale == 'en_US'){
            cmp.set('v.isIndia', true);
            cmp.set('v.isBrazil', false);
            cmp.set('v.isChile', false);
            cmp.set('v.isMexico', false);
        }else if(locale == 'es_MX'){
            cmp.set('v.isBrazil', false);
            cmp.set('v.isIndia', false);
            cmp.set('v.isMexico', true);
            cmp.set('v.isChile', false);
        }else if(locale == 'es'){
            cmp.set('v.isBrazil', false);
            cmp.set('v.isIndia', false);
            cmp.set('v.isChile', true);
            cmp.set('v.isMexico', false);
        }
        else{
            cmp.set('v.isBrazil', true);
            cmp.set('v.isIndia', false);
            cmp.set('v.isChile', false);
            cmp.set('v.isMexico', false);
        }
        var temp = [];
        var action1 = cmp.get("c.getUserData");
        action1.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                cmp.set("v.validUser",result);
                validUser = cmp.get("v.validUser");
            }
        });
        $A.enqueueAction(action1);
        var action = cmp.get("c.getDonDataAll");
        action.setParams({ 
            fiscalYearValue : cmp.get("v.yearCheck"),
            language: locale
        });
        
        action.setCallback(this, function(response){ 
            if(response.getState() === 'SUCCESS' && response.getReturnValue()){
                temp = response.getReturnValue();
                console.log('=====Order Graph Data =======>',temp);
                helper.createGraph(cmp, temp,locale,validUser);
            }else{
                console.log('======Order Graph Error=========');
            }
        });      
        
        $A.enqueueAction(action);	
    },
    handleYearChange : function(cmp, event, helper) {
        var locale = $A.get("$Locale.langLocale");
        var validUser = cmp.get("v.validUser");
        if(locale == 'en_US'){
            cmp.set('v.isIndia', true);
            cmp.set('v.isBrazil', false);
            cmp.set('v.isChile', false);
            cmp.set('v.isMexico', false);
        }else if(locale == 'es_MX'){
            cmp.set('v.isBrazil', false);
            cmp.set('v.isIndia', false);
            cmp.set('v.isMexico', true);
            cmp.set('v.isChile', false);
        }else if(locale == 'es'){
            cmp.set('v.isBrazil', false);
            cmp.set('v.isIndia', false);
            cmp.set('v.isChile', true);
            cmp.set('v.isMexico', false);
        }
            else{
                cmp.set('v.isBrazil', true);
                cmp.set('v.isIndia', false);
                cmp.set('v.isChile', false);
                cmp.set('v.isMexico', false);
            }
        cmp.set("v.yearCheck", event.getParam("value"));
        var temp = [];
        var action = cmp.get("c.getDonDataAll");
        action.setParams({ 
            fiscalYearValue : cmp.get("v.yearCheck"),
            language: locale
        });
        action.setCallback(this, function(response){ 
            if(response.getState() === 'SUCCESS' && response.getReturnValue()){
                temp = response.getReturnValue();
                helper.createGraph(cmp, temp,locale,validUser);
            }
        });      
        $A.enqueueAction(action);
    }  
})