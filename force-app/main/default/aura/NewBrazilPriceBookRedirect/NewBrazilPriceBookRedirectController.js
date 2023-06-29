({
	 doInit : function(component, event, helper){
               
        var recordId = component.get("v.recordId"); 
         
       //alert(recordId);
         console.log('doInit record id--->');
        console.log(recordId);
        
        if (typeof recordId != "undefined"){
            
            console.log('Record Existed--->');
           
          helper.getTypeOfCamaign(component,event,recordId);
          
            
        }
    },
})