({
	showToast : function(component, event) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
            "title": $A.get('$Label.c.Success'),
            "message": $A.get('$Label.c.The_record_has_been_updated_successfully'),
            "type":"success"
        	});
    		toastEvent.fire();
    }
})