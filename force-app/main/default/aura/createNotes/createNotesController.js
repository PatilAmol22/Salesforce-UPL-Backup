({
	doInit : function(component, event, helper) {
		helper.fetchNotes(component, event, helper);
	},
    
    updateNote : function(component, event, helper) {
        var indx = event.target.id;
        var notes = component.get("v.notesList");
        notes[indx].isEdit = false;
        component.set("v.notesList", notes);
    },
    
    cancel : function(component, event, helper) {
        var indx = event.target.id;
        var notes = component.get("v.notesList");
        notes[indx].isEdit = true;
        component.set("v.notesList", notes);
    },
    
    save : function(component, event, helper) {
        helper.saveNote(component, event, helper);
    },
    
})