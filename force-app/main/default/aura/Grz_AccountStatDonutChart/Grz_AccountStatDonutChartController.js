({
	 scriptsLoaded : function(component, event, helper) {
        var locale = $A.get("$Locale.langLocale");
        console.log('getAccountStatementData langLocale : '+locale);
        var delay = component.get('v.delay');
         
        //if(locale == 'es-MX'){
            /*component.set('v.isMexico', true);
            component.set('v.isBrazil', false);
            component.set('v.isIndia', false);*/
            
            window.setTimeout(function(){
            	helper.createAccountStatChart(component, event, helper);
            },delay*100);
        //}
    },
    handleMonthChange : function(component, event, helper) {
        component.set('v.loaded',false);
        component.set('v.monthValue', event.getParam("value"));
        console.log('v.monthValue---------',component.get("v.monthValue"));
        helper.createAccountStatChart(component, event, helper);       
    }
})