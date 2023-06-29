({
	doInit : function(component, event, helper) {
		
	},
    gotoURL : function(component, event, helper) {
    var currentURL =window.location.href;
    if(currentURL.indexOf('/s')){
        var n = currentURL.indexOf('/s');
        currentURL = currentURL.substring(0, n != -1 ? n : currentURL.length);
    }
    currentURL = currentURL + '/apex/Grz_countrySelection';
    var currenturl1 = 'https://uplltd.secure.force.com/DistributorCountrySelection';    
        component.set("v.redirectionLink",currenturl1);
    console.log('currUrl>>',currentURL); 
    //window.location.href = currentURL;
    //window.open(currentURL,'_blank');
    }
})