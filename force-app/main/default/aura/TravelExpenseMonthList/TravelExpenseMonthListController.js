({
	doInit : function(component,event){
        var action = component.get("c.getMTExpense");
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('action : ' + response.getState());
            if(response.getState()=="SUCCESS"){
                console.log('return data :- '+JSON.stringify(response.getReturnValue()));
                component.set('v.TravelExpenseMonthList',response.getReturnValue().results);
            }
        });
         $A.enqueueAction(action);
    },
    getValueFromApplication : function(component,event){
        
        var ShowResultValue = event.getParam("stringDate");
        // set the handler attributes based on event data
        alert('ShowResultValue :- '+ShowResultValue);
   		component.set("v.newDate", ShowResultValue);
        
    },
	removeDeletedRow: function(component, event, helper) {
        
      
      component.getEvent("RemoveItemEvent").setParams({"indexVar" : component.get("v.rowIndex")}).fire();
      
      console.log('total :- '+component.get("v.totAmount"));
      console.log('total :- '+component.find('lineitemamount').get("v.value"));
      console.log('total :- '+component.get("v.TravelExpensesList.Amount__c"));
        
    },
    
    // Click for edit row
    /*editRow: function(component, event, helper) {
      var editamnt = component.find('lineitemitems');
      editamnt.set("v.disabled", false); 
     },*/
})