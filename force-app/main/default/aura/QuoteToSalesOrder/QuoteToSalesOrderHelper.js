({
    checkStatus: function(component, event, helper) {
        //console.log('RecordTp.... ',rcdTp_nm);
      component.set("v.showSpinner", true);
      var recordId = component.get("v.recordId");
      var action = component.get("c.checkQuoteStatus");

      action.setParams({
        quote_id: recordId
      });

      action.setCallback(this, function(response) {
      if (response.getState() == "SUCCESS") {
          
        var resp = response.getReturnValue();
        console.log('Status Response.... ',resp);
        if(resp == 'Approved'){
          this.createSO(component, event, helper);
        }
        else if(resp == 'Not Approved'){
          component.set("v.errorMsg", $A.get("$Label.c.Quotation_Is_Not_Approved_Can_Not_Create_Sales_Order"));
          component.set("v.showError", true);
        }else if(resp=='Sales Order already created'){
          component.set("v.errorMsg", 'Sales Order already created.');
          component.set("v.showError", true);
        }
        else{
          component.set("v.errorMsg", $A.get("$Label.c.Failed_To_Create_Sales_Order"));
          component.set("v.showError", true);
        }
      }
      else{
        component.set("v.errorMsg", $A.get("$Label.c.No_Records_Found"));
        component.set("v.showError", true);
      }

      component.set("v.showSpinner", false);
      });
      $A.enqueueAction(action);
    },

    
    
    createSO: function(component, event, helper) {
         //console.log('RecordTp.... ',rcdTp_nm);
    component.set("v.showSpinner", true);
    var recordId = component.get("v.recordId");
    var action = component.get("c.createSalesOrder");

    action.setParams({
        quote_id: recordId
    });

    action.setCallback(this, function(response) {
      if (response.getState() == "SUCCESS") {
         
        var resp = response.getReturnValue();
        console.log('Status Response.... ',resp);
        if(resp == null || resp == ''){
          component.set("v.errorMsg", $A.get("$Label.c.Failed_To_Create_Sales_Order"));
          component.set("v.showError", true);
        }
        else{

          var ordIds = new Array();
          var ordNo = '';
          for(var j=0; j<resp.length; j++){
            ordIds.push(resp[j].Id);
            if(j == 0){
              ordNo = resp[j].Name;
            }
            else{
              ordNo = ordNo + ','+ resp[j].Name;
            }
          }
          component.set("v.orderNumbers", ordNo);
          component.set("v.soList", ordIds);
          component.set("v.showSuccess", true);
        }
        
      }
      else{
        component.set("v.errorMsg", $A.get("$Label.c.Failed_To_Create_Sales_Order"));
        component.set("v.showError", true);
      }
     
      component.set("v.showSpinner", false);
    });
    $A.enqueueAction(action);
    }
})