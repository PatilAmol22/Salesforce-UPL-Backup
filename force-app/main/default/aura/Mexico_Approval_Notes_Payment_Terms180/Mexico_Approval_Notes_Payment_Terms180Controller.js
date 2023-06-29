({
	doInit : function(component, event, helper) {
       // alert('hiii');
         var action = component.get('c.getSalesOrder180');      
        action.setParams({ recordIdVar : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                 // alert('HIIIIII')
                if(response.getReturnValue()==true)
                {	
                   // alert('HIIIIII inside methods');
                    component.set("v.notes", 'Esta recibiendo este correo porque el termino de pago es mayor a 180 dias');
                }
            }
        });
        $A.enqueueAction(action);
            
        
		
	}
})