({
	doInit : function(component, event, helper) {
		helper.getFileHelper(component, event, helper);
	},
    
    fileSelected : function(component, event, helper) {
        
        var uploadFile = event.getSource().get("v.files")[0];        
        component.set("v.FileName",uploadFile.name);
        component.set("v.ShowFileName","true");
        if(uploadFile){
           $A.util.removeClass(component.find("ErrorFile"),"slds-show");
            $A.util.addClass(component.find("ErrorFile"),"slds-hide");
       
           }
        
        
    },
    
    onFileUploaded : function(component, event, helper) {
        
       
        var fileselect = component.find("fileId").get("v.value");
             
        if(fileselect != ''){
           
            helper.fileUploadHelper(component, event, helper);
        }
      
        if(!fileselect){
            $A.util.removeClass(component.find("ErrorFile"),"slds-hide");
            $A.util.addClass(component.find("ErrorFile"),"slds-show");
       
           }
      
       
    },
  
})