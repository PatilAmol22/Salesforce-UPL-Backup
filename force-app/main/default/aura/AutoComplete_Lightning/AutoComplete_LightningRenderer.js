({
    
    afterRender : function(component, helper) {
           
        var listInput = component.find("searchText").getElement();
        console.log('listInput--> '+listInput);
        //var acctlistInput = acctlistInputCmp.getElement();
        listInput.setAttribute("list", "resultList");
        return this.superAfterRender();
     
    }
})