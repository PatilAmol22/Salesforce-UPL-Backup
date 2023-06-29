({
	doInit : function(component, event, helper) {
		var locale = $A.get("$Locale.langLocale");
        //alert("You are using " + locale);
        if(locale == 'en_US'){
            component.set('v.isIndia', true);
            component.set('v.isBrazil', false);
            component.set('v.isMexico', false);
            component.set('v.isChile', false);
        }else if(locale == 'pt_BR'){
            component.set('v.isBrazil', true);
            component.set('v.isIndia', false);
            component.set('v.isMexico', false);
            component.set('v.isChile', false);
        }else if(locale == 'es'){
            component.set('v.isBrazil', false);
            component.set('v.isIndia', false);
            component.set('v.isMexico', false);
            component.set('v.isChile', true);
        }
         else{
            component.set('v.isBrazil', false);
            component.set('v.isIndia', false);
            component.set('v.isMexico', true);
            component.set('v.isChile', false);
         }
	}
})