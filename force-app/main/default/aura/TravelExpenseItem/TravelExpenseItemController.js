({
    doInit : function(component,event){
         
    },
    doinit : function(component,event){
         
    },
    getValueFromApplication : function(component,event){
        
        var ShowResultValue = event.getParam("stringDate");
        // set the handler attributes based on event data
        alert('ShowResultValue :- '+ShowResultValue);
   		component.set("v.newDate", ShowResultValue);
        
    },
	removeDeletedRow: function(component, event, helper) {
        
      
      component.getEvent("RemoveItemEvent").setParams({"indexVar" : component.get("v.rowIndex")}).fire();
      
      /*console.log('total :- '+component.get("v.totAmount"));
      console.log('total :- '+component.find('lineitemamount').get("v.value"));
      console.log('total :- '+component.get("v.TravelExpensesList.Amount__c"));*/
        
    },
    
    click_amnt: function(component, event, helper){
        var sum = 0;
       	var list = component.get("v.TravelExpenses");
    
        var child_list=JSON.stringify(list);
        var list_item= component.get("v.TravelExpenses1");
        list_item.push(child_list);
        var ItemList = component.get("v.TravelExpensesList");
        //var child_list_array= '['+child_list+']';
        console.log('list_item : '+ list_item);
        
       // alert(JSON.stringify(ItemList));
        var jsonChildList = JSON.parse(child_list);
        for(var k = 0 ; k < jsonChildList.length ; k++){
            
           console.log('amount : '+ jsonChildList[k].Amount__c);
            
            sum = sum+ +jsonChildList[k].Amount__c;
            
            console.log('sum : '+ sum); 
        }
         console.log('TravelExpensesList :' +component.get("v.travelexpense.Month__c"));
        
       // var ittm = component.get("v.travelexpense");
       // console.log(' ittm :-'+JSON.stringify(ittm));
        //sum = sum+ +component.find('lineitemamount').get("v.value");
        
        //console.log('total :- '+total_sum);
        //component.find("totalAmount").set("v.value",sum);
        
    }
    
    // Click for edit row
    /*editRow: function(component, event, helper) {
      var editamnt = component.find('lineitemitems');
      editamnt.set("v.disabled", false); 
     },*/
})