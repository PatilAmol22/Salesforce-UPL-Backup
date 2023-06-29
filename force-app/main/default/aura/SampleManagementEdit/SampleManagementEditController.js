({
	doInit : function(component, event, helper) {
      console.log('doinit---'+component.get('v.recordId'));
          var myPageRef = component.get("v.pageReference");
        var id = myPageRef.state.c__id;
        component.set("v.recordId", id);
           console.log('doinit---'+component.get('v.recordId'));
         component.set("v.isSWAL",true);
		/*if(component.find('materialrequi')){
                     var childcmp = component.find('materialrequi');
                         childcmp.destroy();
                     console.log(JSON.stringify(childcmp));
                
                }*/
        //component.find('materialrequi').getFiredFromAura();
	},
    handlePageChange : function(component, event, helper) {
          console.log('Handler');
         component.set("v.isSWAL",true);
         	component.find('materialrequi').getFiredFromAura();
    }
})