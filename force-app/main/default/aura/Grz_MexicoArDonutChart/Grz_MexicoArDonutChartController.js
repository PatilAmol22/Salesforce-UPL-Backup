({
	 scriptsLoaded : function(component, event, helper) {
        var locale = $A.get("$Locale.langLocale");
        console.log('getArDonutLocal langLocale : '+locale);
        var delay = component.get('v.delay');
         
        //if(locale == 'es-MX'){
            /*component.set('v.isMexico', true);
            component.set('v.isBrazil', false);
            component.set('v.isIndia', false);*/
            
            window.setTimeout(function(){
            	helper.createMexicoArChart(component, event, helper);
            },delay*100);
        //}
    },
})