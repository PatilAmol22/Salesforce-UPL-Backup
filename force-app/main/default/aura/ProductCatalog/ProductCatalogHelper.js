({
    getFirstDetails: function(component, event, helper) {
        component.set("v.showSpinner", true);
       // var opp_id = component.get("v.recordId");
       // console.log("****Opportunity Id......: " + opp_id);
    
        var action = component.get("c.getFirstDropDown");
    
        /* action.setParams({
            id_val: opp_id
        }); */
    
        action.setCallback(this, function(response) {
          //  console.log(response.getError());
          if (response.getState() == "SUCCESS") {
            // console.log('*****Result****.... '+ JSON.stringify(response.getReturnValue()));
            var resp = response.getReturnValue();
           // console.log('*****Result****.... ', resp);
            component.set("v.firstDropDownList", resp);
          }
    
          component.set("v.showSpinner", false);
        });
    
        $A.enqueueAction(action);
      },

      getSecondDetails: function(component, event, helper) {
        component.set("v.showSpinner", true);
        var cat_id = component.get("v.firstVal");
       // console.log("****Opportunity Id......: " + cat_id);
    
        var action = component.get("c.getSecondDropDown");
    
        action.setParams({
            cat_val: cat_id
        });
    
        action.setCallback(this, function(response) {
          //  console.log(response.getError());
          if (response.getState() == "SUCCESS") {
            // console.log('*****Result****.... '+ JSON.stringify(response.getReturnValue()));
            var resp = response.getReturnValue();
           // console.log('*****Result****.... ', resp);
            component.set("v.secondDropDownList", resp);
          }
    
          component.set("v.showSpinner", false);
        });
    
        $A.enqueueAction(action);
      },

      getThirdDetails: function(component, event, helper) {
        component.set("v.showSpinner", true);
        var cat_id = component.get("v.firstVal");
        var sub_cat_id = component.get("v.secondVal");
       // console.log("****Opportunity Id......: " + cat_id);
    
        var action = component.get("c.getThirdDropDown");
    
        action.setParams({
            cat_val: cat_id,
            sub_cat_val: sub_cat_id
        });
    
        action.setCallback(this, function(response) {
          //  console.log(response.getError());
          if (response.getState() == "SUCCESS") {
            // console.log('*****Result****.... '+ JSON.stringify(response.getReturnValue()));
            var resp = response.getReturnValue();
           // console.log('*****Result****.... ', resp);
            component.set("v.thirdDropDownList", resp);
          }
    
          component.set("v.showSpinner", false);
        });
    
        $A.enqueueAction(action);
      },

      showProducts: function(component, event, helper) {
        component.set("v.showSpinner", true);
        var arry = [];
        component.set("v.allProductList", arry);
        var cat_id = component.get("v.firstVal");
        var sub_cat_id = component.get("v.secondVal");
        var last_cat_id = component.get("v.thirdVal");
       // console.log("****Opportunity Id......: " + cat_id);
    
        var action = component.get("c.getProducts");
    
        action.setParams({
            cat_val: cat_id,
            sub_cat_val: sub_cat_id,
            last_cat_val: last_cat_id
        });
    
        action.setCallback(this, function(response) {
          //  console.log(response.getError());
          if (response.getState() == "SUCCESS") {
            // console.log('*****Result****.... '+ JSON.stringify(response.getReturnValue()));
            var resp = response.getReturnValue();
            console.log('***** allProductList****.... ', resp);
            //console.log('*****Result Products****.... ', resp.productList);
            component.set("v.allProductList", resp);
             //added by Vaishnavi w.r.t Mobile UI
             component.set('v.PaginationList', resp);

             //below added by vaishnavi... START
 
             var pageSize = component.get("v.pageSize");
             var PaginationList = [];
             var i=0;
             var productList=component.get("v.PaginationList")[0].productList;
             component.set("v.totalRecords", productList.length);
             component.set("v.startPage",0);
             component.set("v.endPage",pageSize-1);
             for(i=0; i< pageSize; i++){
                 if(productList.length> i)
                     PaginationList.push(productList[i]);    
             }
             component.set('v.PaginationList', PaginationList);
 
          }
    
          component.set("v.showSpinner", false);
        });
    
        $A.enqueueAction(action);
      },

      showDetails: function(component, event, helper) {
        component.set("v.showSpinner", true);
        
        var val = component.get("v.productName");
        
       // console.log("****Opportunity Id......: " + cat_id);
    
        var action = component.get("c.getProductDetails");
        component.set("v.productName", '');
        action.setParams({
            prodName: val
        });
    
        action.setCallback(this, function(response) {
          //  console.log(response.getError());
          if (response.getState() == "SUCCESS") {
            // console.log('*****Result****.... '+ JSON.stringify(response.getReturnValue()));
            component.set("v.showDetails", true);
            component.set("v.showCatalog", false);
            var resp = response.getReturnValue();
            console.log('*****Result productDetails****.... ', resp);
            //console.log('*****Result Products****.... ', resp.productList);
            component.set("v.productDetails", resp);
            
          }
    
          component.set("v.showSpinner", false);
          
        });
    
        $A.enqueueAction(action);
      },
});