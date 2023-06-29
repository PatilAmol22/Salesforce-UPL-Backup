({
	// Your renderer method overrides go here
	afterRender : function(component, helper) {
  		var acctlistInputCmp = component.find("searchText");
  		var acctlistInput = acctlistInputCmp.getElement();
  		acctlistInput.setAttribute("list", "resultList");
  		return this.superAfterRender();
	}
    
})