({
	searchHelper : function(component,event,getInputkeyWord) {
	  // call the apex class method 
	  var searchField = component.get("v.displayField");
     var action = component.get("c.fetchLookUpValues");
      // set param to method  
        action.setParams({
            'SearchField': searchField,
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName"),
            'filter': component.get("v.Filter"),
            'queryFields':component.get("v.queryFields")
          });
      // set a callBack    
        action.setCallback(this, function(response) {
          $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
	},
})