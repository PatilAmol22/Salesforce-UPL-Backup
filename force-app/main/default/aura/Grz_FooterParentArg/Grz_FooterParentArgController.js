({
		doInit : function(component, event, helper) {
		var locale = $A.get("$Locale.langLocale");
        //Using the country in addition to lang locale because some users in Argentina have en_US set as 
        //default language ,GRZ(Gurubaksh Grewal) : APPS-1757 added on: 16-08-2022
        if($A.get("$Locale.country")==='AR' || $A.get("$Locale.userLocaleCountry")=='AR')locale='es_AR';
        // alert("You are using " + locale);
		if(locale == 'es_AR'){
            component.set('v.isArgentina', true);
            //component.set('v.footerPaddingCls', 'parent-footer-padding-AR');
        }else{
            component.set('v.isArgentina', false);
         }

	}
})