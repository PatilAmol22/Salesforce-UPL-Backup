({
    
    doInit: function(component, event, helper) {
        
        var CustomerId  = component.get("v.customerId");
        console.log('customer '+CustomerId);
        var action = component.get("c.init");
        
        action.setParams({
            //"custId": CustomerId
            "StockInChannelId": component.get("v.StockInChannelId")
        });
        
        action.setCallback(this, function(response) {
            console.log('inside');
            
            component.set("v.SubmittedForApproval", true);
            //component.set("v.ReadyForApproval", false);
            
            component.set("v.Status", response.getReturnValue().Status); 
            
            var Status = component.get("v.Status");
            console.log('r '+Status);
            if(Status == 'In Progress'){
                component.set("v.ReadyForApproval", true);
                component.set("v.SubmittedForApproval", false);
            }
            if(Status == 'Submitted for Approval'){
                component.set("v.enablestock", false);
                component.set("v.FreezeDetails", false);
                component.set("v.ReadyForApproval", false);
                component.set("v.SubmittedForApproval", true);
            }
            if(Status == 'Approved'){
                component.set("v.enablestock", false);
                component.set("v.FreezeDetails", false);
                component.set("v.SubmittedForApproval", false);
            }
            if(Status == 'Rejected'){
                //component.set("v.enablestock", true);
                //component.set("v.FreezeDetails", false);
                component.set("v.SubmittedForApproval", false);
            }
            component.set("v.isRegionalManager", response.getReturnValue().isRegionalManager);
            component.set("v.LiApprovalHistory", response.getReturnValue().liApprovalHistory); 
            //component.set("v.ReadyForApproval", false);
            //component.set("v.SubmittedForApproval", response.getReturnValue().SubmittedForApprovalStatus);
        });
        
        $A.enqueueAction(action);
        
    },
    
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
    },
    
    Approve: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        
        component.set("v.isModalOpen", false);
        var comments = component.find('input1').get('v.value');
        
        var action = component.get("c.ApproveReject");
        
        action.setParams({
            "Approved": true,
            "Comments": comments,
            //"CustomerId": component.get("v.customerId")
            "StockInChannelId": component.get("v.StockInChannelId")
        });
        action.setCallback(this, function(response) {
            
            component.set("v.Status", "Approved");
            component.set("v.SubmittedForApproval", false);
            component.set("v.ReadyForApproval", false); 
            component.set("v.LiApprovalHistory", response.getReturnValue());
            component.set("v.enablestock", false);
            component.set("v.FreezeDetails", false);
        });
        $A.enqueueAction(action);
    },
    
    Reject: function(component, event, helper) {
        // Set isModalOpen attribute to false
        //Add your code to call apex method or do some processing
        component.set("v.isModalOpen", false);
        
        var comments = component.find('input1').get('v.value');
        
        var action = component.get("c.ApproveReject");
        
        action.setParams({
            "Approved": false,
            "Comments": comments,
            // "CustomerId": component.get("v.customerId")
            "StockInChannelId": component.get("v.StockInChannelId")
        });
        action.setCallback(this, function(response) {
            
            component.set("v.Status", "Rejected");
            component.set("v.SubmittedForApproval", false);
            component.set("v.ReadyForApproval", false); 
            component.set("v.LiApprovalHistory", response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    closeModel : function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    
    SubmitForApproval: function(component, event, helper) {
        
        var CustomerId  = component.get("v.customerId");
        console.log('customer '+CustomerId);
        console.log('StockInchannelId '+component.get("v.StockInChannelId"));
        var action = component.get("c.SubmitForApprovalApex");
        
        action.setParams({
            //"custId": CustomerId
            "StockInChannelId": component.get("v.StockInChannelId")
        });
        
        action.setCallback(this, function(response) {
            component.set("v.SubmittedForApproval", true);
            component.set("v.ReadyForApproval", false); 
            component.set("v.Status", "Submitted for Approval");
            component.set("v.enablestock", false);
            component.set("v.FreezeDetails", false);
            component.set("v.LiApprovalHistory", response.getReturnValue());
        });
        
        $A.enqueueAction(action);
        
    },
    
})