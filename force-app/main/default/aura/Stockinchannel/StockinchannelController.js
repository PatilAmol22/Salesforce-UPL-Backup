({
    doInit: function(component,event,helper) {
        
        
        //var today = $A.localizationService.formatDate(new Date(), "YYYY");
         var curr = new Date; // testing january
        //curr.setMonth(curr.getMonth() - 9); //testing january
        var today = $A.localizationService.formatDate(curr, "YYYY"); //testing january
        
        component.set("v.year", today);    
        //helper.getUserDetails(component,event,helper);
        helper.getBUDetails(component,event,helper);
    },
    
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');
        
        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    },
    search : function(component, event, helper)
    
    {
        component.set("v.DisplayComponents","false"); // added for search functionality
        var BU = component.find("intendBU").get("v.value");
        var Region = component.find("intend").get("v.value"); 
        var Salesrep = component.find("intendSalesRep").get("v.value");
        var Customer = component.find("intendCustomer").get("v.value");
        var Year= component.get("v.year");
        console.log('year is '+ Year);
        var isRequiredFieldError = false;
        console.log("reached 1");   
        if(BU == null || BU == '' )
        {
            $A.util.removeClass(component.find("intendBUerro"),"slds-hide");
            isRequiredFieldError = true;
            
        }
        else{
            $A.util.addClass(component.find("intendBUerro"),"slds-hide");
            isRequiredFieldError = false;
        }
        
        
        if(Region == null || Region == '' )
        {
            
            $A.util.removeClass(component.find("intenderro"),"slds-hide");
            isRequiredFieldError = true;
            
        }else
        {
            $A.util.addClass(component.find("intenderro"),"slds-hide");
            isRequiredFieldError = false; 
        }
        
        if(Salesrep == null || Salesrep == '' )
        {
            
            $A.util.removeClass(component.find("intendSalesReperro"),"slds-hide");
            isRequiredFieldError = true;
            
        }else
        {
            $A.util.addClass(component.find("intendSalesReperro"),"slds-hide");
            isRequiredFieldError = false;
            
        }
        
        if(Customer == null || Customer == '' )
        {
            
            $A.util.removeClass(component.find("intendCustomererro"),"slds-hide");
            isRequiredFieldError = true;
            
        }else
        {
            $A.util.addClass(component.find("intendCustomererro"),"slds-hide");
            isRequiredFieldError = false;
            
        }
        
        
        if(isRequiredFieldError == true)
        {
            console.log("reached 6");
            return;
        }
        else
        {
        var getNotes = component.get("c.getNotesID");
        getNotes.setParams({
            "Year": Year,
            "Customer":Customer,
            "Region":Region
        });
        
        getNotes.setCallback(this, function(response) {
            var state = response.getState();
           if (state === "SUCCESS"){
            var callBack =  response.getReturnValue();
            console.log('callback is '+ callBack);
            component.set("v.NotesId", callBack);
            component.set("v.DisplayComponents","True");
            //component.set("v.EnableLastMonth","true"); // updated to show checkbox
            }
            else
            {
                component.find('notifLib').showToast({
                    "variant": "error",
                    "title": "error!",
                    "message": "Stock in channel is not available"
                });     
            }
            if(component.get("v.ShowEnabledLastMonth"))
           var checkenable= component.find("month").get("v.value");
           console.log('check box status is '+ checkenable);
        });
        
        $A.enqueueAction(getNotes);
        }
        
        
        //$A.util.removeClass(component.find("toggle1"), "slds-hide");
    },
    
    
    onChangePickValRegion: function(component,event,helper)
    {  
       
        helper.helperonChangePickValRegion(component,event,helper);
       
    },
    
    onChangePickValBU: function(component,event,helper)
    {  
        //helper.helperonChangePickValBU(component,event,helper);
        helper.helperonChangePickValRegion(component,event,helper);
       
    },
    
    onChangePickValSales: function(component,event,helper)
    {  
        //helper.helperonChangePickValSales(component,event,helper);
        helper.helperonChangePickValBU(component,event,helper);
      
    },
    
    onChangePickValCustomer: function(component,event,helper)
    {  
        helper.helperonChangePickValCustomer(component,event,helper);
        
    }
    
})