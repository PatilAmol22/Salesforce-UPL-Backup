({
    doInit : function(component, event, helper) {
        
    },
    handleUserUpdated: function(component, event, helper) { 
        var user = component.get("v.User") ;
        var Profile = user.Profile.Name;
        
        if(Profile == 'System Administrator' ||
           Profile == 'Brazil System Administrator' ||
           Profile == 'Brazil Sales Price Admin' ) {
            component.set("v.ShowOption", true);
        }
        component.set("v.ShowComponent", true);
    },
    
    onChange : function(component, event, helper) {
        
        var ValueSelected = component.find("Upload").get("v.value");
        console.log('ValueSelected'+ValueSelected);
        if(ValueSelected != ''){
            component.set("v.ShowSampleTemplate","true");
            helper.getFileHelper(component, event, helper, ValueSelected);
            $A.util.removeClass(component.find("ErrorType"),"slds-show");
            $A.util.addClass(component.find("ErrorType"),"slds-hide");
        }
        if(ValueSelected == ''){
            component.set("v.ShowSampleTemplate","false"); 
            $A.util.removeClass(component.find("ErrorType"),"slds-hide");
            $A.util.addClass(component.find("ErrorType"),"slds-show");
        }
        
    },
    onFileUploaded : function(component, event, helper) {
        
        var ValueSelected = component.find("Upload").get("v.value");
        var fileselect = component.find("fileId").get("v.value");
             
        if(ValueSelected != '' && fileselect != ''){
            component.set("v.ShowSampleTemplate","true");
            helper.fileUploadHelper(component, event, helper, ValueSelected);
        }
        if(!ValueSelected){
            $A.util.removeClass(component.find("ErrorType"),"slds-hide");
            $A.util.addClass(component.find("ErrorType"),"slds-show");
       
           }
        if(!fileselect){
            $A.util.removeClass(component.find("ErrorFile"),"slds-hide");
            $A.util.addClass(component.find("ErrorFile"),"slds-show");
       
           }
      
       
    },
    
    fileSelected : function(component, event, helper) {
        
        var uploadFile = event.getSource().get("v.files")[0];        
        component.set("v.FileName",uploadFile.name);
        component.set("v.ShowFileName","true");
        if(uploadFile){
           $A.util.removeClass(component.find("ErrorFile"),"slds-show");
            $A.util.addClass(component.find("ErrorFile"),"slds-hide");
       
           }
        
        
    }
})