({
    
    
    doInit: function (component, event, helper) {
        console.log(component.get("v.UserType"));
        component.set("v.spinner", true);
        if(component.get("v.UserType") === 'Manager' || component.get("v.UserType") === undefined){//
            component.set("v.Editable", false);
        }
        if(component.get("v.ContractHeader")){
        var Contract = component.get("v.ContractHeader");
            console.log(Contract.Status +' '+Contract.CRMStatus);
        /*   
         var action = component.get("c.getlatestContractStatus");
            //Set the Object parameters and Field Set name
            action.setParams({  
            ContractIds : component.get("v.ContractHeader.Contract")
            });
            
            action.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === 'SUCCESS'){
                console.log('CRMStatus'+response.getReturnValue());
             component.set("v.ContractHeader.CRMStatus", response.getReturnValue());
            }
            });
            $A.enqueueAction(action);    
        
        Contract = component.get("v.ContractHeader");    
            
            
            
        */    
        if(Contract.Status != 'Aguardando Metas' || Contract.CRMStatus === 'In Review' || Contract.CRMStatus === 'Approved' ){
         component.set("v.Editable", false);
            console.log(component.get("v.Editable"))
        }
            var Editable = component.get("v.Editable");
        component.set('v.Materialscolumns', [
            {label: $A.get("$Label.c.RebateProductCategory"), fieldName: 'product_category', type: 'text', },
            {label: $A.get("$Label.c.RebateBrandName"), fieldName: 'ProductGroup', type: 'text', },
            {label: 'SKU', fieldName: 'code', type: 'text',},
            
            {label: $A.get("$Label.c.RebateProductName"), fieldName: 'Product', type: 'text',},
            {label: $A.get("$Label.c.RebateVolumeLY"), fieldName: 'Volume2018', type: 'number',typeAttributes: { minimumFractionDigits: '2' }},
            {label: $A.get("$Label.c.RebatePriceLY"), fieldName: 'Price2018', type: 'number',typeAttributes: { minimumFractionDigits: '2' }},
            {label: $A.get("$Label.c.RebateValueLY"), fieldName: 'Amount2018', type: 'number',typeAttributes: { minimumFractionDigits: '2' }},
            {label: $A.get("$Label.c.RebateVolume"), fieldName: 'VolumeGoal', type: 'number',editable: Editable,typeAttributes: { minimumFractionDigits: '2' }},
            {label: $A.get("$Label.c.RebatePrice"), fieldName: 'AmountGoal', type: 'number',editable: Editable,typeAttributes: { minimumFractionDigits: '2' }},
            {label: $A.get("$Label.c.RebateValue"), fieldName: 'Goal_Billing', type: 'number',typeAttributes: { minimumFractionDigits: '2' }},
            
        ]);
            console.log('value is of goal is '+ component.get("v.ContractHeader"));
            //if(component.get("v.ContractHeader")){
            console.log('value is of goal is 56'+ JSON.stringify(component.get("v.ContractHeader")));
            var action = component.get("c.getGoals");
            //Set the Object parameters and Field Set name
            action.setParams({  
            rC : component.get("v.ContractHeader")
            });
            
            action.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === 'SUCCESS'){
            component.set("v.spinner", false);
            component.set("v.Materialsdata", response.getReturnValue());  
            component.set("v.showTotal", true);
            component.set("v.ContractHeader.TotalTypeValueLY", response.getReturnValue()[0].TotalTypeValueLY);
            component.set("v.v.ContractHeader.TotalTypeValue", response.getReturnValue()[0].TotalTypeValue);
            component.set("v.ContractHeader.TotalOtherValueLY", response.getReturnValue()[0].TotalOtherValueLY);
            component.set("v.ContractHeader.TotalOtherValue", response.getReturnValue()[0].TotalOtherValue);
            component.set("v.ContractHeader.TotalValueLY", response.getReturnValue()[0].TotalValueLY);
            component.set("v.ContractHeader.TotalValue", response.getReturnValue()[0].TotalValue);
           
            if(response.getReturnValue()[0].response_service == 'true'){
               
            }
            else{
                 var error=  $A.get("$Label.c.REB_Error_Message");
                var message = response.getReturnValue()[0].response_service;
                if(message == 'false'){
                  component.find('notifLib').showToast({
                        "variant": "error",
                        "message": error,
                        
                    });  
                }
                else{
             component.find('notifLib').showToast({
                        "variant": "error",
                        "message": message,
                        
                    });  
                }
            }
            
            }
            });
            $A.enqueueAction(action);
            }
            },
            
            
            Back : function(component, event, helper) {
            component.set("v.showGoal",false);
            component.set("v.showHome",true);
            
            },
            
            getHistory : function (component, event, helper) {
            component.set('v.Historycolumns', [
            {label: $A.get("$Label.c.REB_Date"), fieldName: 'Date_history', type: 'text'},
            {label: $A.get("$Label.c.REB_Responsible"), fieldName: 'Responsible', type: 'text', initialWidth: 150,},
            {label: $A.get("$Label.c.REB_User"), fieldName: 'User', type: 'text',initialWidth: 250,},
            {label: $A.get("$Label.c.REB_Action"), fieldName: 'Action', type: 'text',initialWidth: 100,},
            {label: $A.get("$Label.c.REB_New_approval_Status"), fieldName: 'New_approval_Status', type: 'text'},
            {label: $A.get("$Label.c.REB_Justification"), fieldName: 'Justification', type: 'text'}
            
            
        ]);
        
        var action = component.get("c.getHistoryGoals");
        //Set the Object parameters and Field Set name
        action.setParams({  
            rC : component.get("v.ContractHeader")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === 'SUCCESS'){
                
                component.set("v.Historydata", response.getReturnValue());  
                component.set("v.showTotal", false);
            }
        });
        $A.enqueueAction(action);    
        
        
    },
    
    handleSaveEdition: function (component, event, helper) {
        var draftValues = event.getParam('draftValues');
        console.log(draftValues);
    },
    handleEditCellChange : function (component, event, helper) {
        var draftValues = event.getParam('draftValues');
        var Materialsdata = component.get("v.Materialsdata");
        var contractheader = component.get("v.ContractHeader");
        console.log('Materialsdata=='+Materialsdata);
        console.log('draftValues=='+draftValues);
        for (var i in Materialsdata) {
            for (var j in draftValues){
                if (Materialsdata[i].Id == draftValues[j].Id) {
                    if(draftValues[j].VolumeGoal){
                        Materialsdata[i].VolumeGoal = draftValues[j].VolumeGoal;
                        console.log('Materialsdata[i].VolumeGoal=='+Materialsdata[i].VolumeGoal);
                    }
                    if(draftValues[j].AmountGoal){
                        Materialsdata[i].AmountGoal = draftValues[j].AmountGoal;  
                        console.log('Materialsdata[i].AmountGoal'+Materialsdata[i].VolumeGoal);
                    }
                    Materialsdata[i].Goal_Billing = Materialsdata[i].VolumeGoal * Materialsdata[i].AmountGoal;
                    console.log('Materialsdata[i].Goal_Billing=='+Materialsdata[i].Goal_Billing);
                }
            }
        }
        var Total=0;
        var TotalOther=0;
        var TotalValue=0;
        for (var i in Materialsdata) {
            Total += Materialsdata[i].Goal_Billing; 
            /*if(Materialsdata[i].product_category === 'Outros'){
                TotalOther += Materialsdata[i].Goal_Billing; 
            }
            else{
                TotalValue += Materialsdata[i].Goal_Billing;
            }*/
            TotalValue += Materialsdata[i].Goal_Billing;
            
        }
        
        contractheader.TotalValue = Total + contractheader.TotalOtherValue;
        //contractheader.TotalOtherValue = TotalOther;
        contractheader.TotalTypeValue = TotalValue ;
        component.set("v.Materialsdata",Materialsdata);
        component.set("v.ContractHeader",contractheader);
        
    },
    
    Save : function (component, event, helper) {
        var Materialsdata = component.get("v.Materialsdata");
        var action = component.get("c.updateGoals");
        var isValid = true;
        
        //checking if not null or not
        for (var i in Materialsdata) {
            if(((Materialsdata[i].VolumeGoal != 0 &&  Materialsdata[i].AmountGoal != 0 && isValid) || (Materialsdata[i].VolumeGoal == 0 &&  Materialsdata[i].AmountGoal == 0 && isValid)) ){
                isValid = true;
            }
            else{
                isValid = false; 
            }
            
        }
        
        if(isValid){
        //Set the Object parameters and Field Set name
        action.setParams({  
            liGD : Materialsdata,
            rC : component.get("v.ContractHeader")         
        });   
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === 'SUCCESS'){
                console.log('response.getReturnValue()=='+JSON.stringify(response.getReturnValue()));
                component.find('notifLib').showToast({
            "variant": "success",
            "message": response.getReturnValue(),
           
        });
                component.set("v.draftValues", null);
                var ContractHeader = component.get("v.ContractHeader");
                if(ContractHeader.TotalValueLY != 0){
                var growthRate = (ContractHeader.TotalValue-ContractHeader.TotalValueLY)/ContractHeader.TotalValueLY*100;
                component.set("v.ContractHeader.GrowthRate", growthRate);
                }
            }
        });
        $A.enqueueAction(action);   
        }
        else{
            component.find('notifLib').showToast({
            "variant": "error",
            "message": $A.get("$Label.c.NONZero"),
           
        }); 
        }
        
    },
  Submit : function (component, event, helper) {  
      var Materialsdata = component.get("v.Materialsdata");
      var actionsubmit = component.get("c.updateAndSubmitGoals");
        var actionsave = component.get("c.updateGoals");
        var isValid = true;
        
        //checking if not null or not
        for (var i in Materialsdata) {
            if(((Materialsdata[i].VolumeGoal != 0 &&  Materialsdata[i].AmountGoal != 0 && isValid) || (Materialsdata[i].VolumeGoal == 0 &&  Materialsdata[i].AmountGoal == 0 && isValid)) ){
                isValid = true;
            }
            else{
                isValid = false; 
            }
            
        }
        
        if(isValid){
        //Set the Object parameters and Field Set name
        actionsave.setParams({  
            liGD : Materialsdata,
            rC : component.get("v.ContractHeader")         
        });   
        actionsave.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === 'SUCCESS'){
			
			//submit code
			 var ContractHeader = component.get("v.ContractHeader");
        actionsubmit.setParams({  
            liGD : Materialsdata,
            rC : component.get("v.ContractHeader")         
        });   
        actionsubmit.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === 'SUCCESS'){
                    
                if( response.getReturnValue() == 'Enviado com êxito para aprovação'){
                    component.find('notifLib').showToast({
                        "variant": "success",
                        "message": response.getReturnValue(),
                        
                    });
                component.set("v.draftValues", null); 
                component.set("v.Editable", false);
                component.set("v.ContractHeader.CRMStatus", "In Editing");
                 component.set('v.Materialscolumns', [
            {label: 'Product Category', fieldName: 'product_category', type: 'text', },
            {label: 'Marca', fieldName: 'ProductGroup', type: 'text', },
            {label: 'SKU', fieldName: 'code', type: 'text',},
            
            {label: 'Produto', fieldName: 'Product', type: 'text',},
            {label: 'Volume 2018', fieldName: 'Volume2018', type: 'number', typeAttributes: { maximumFractionDigits: '2'}},
            {label: 'Preço² 2018', fieldName: 'Price2018', type: 'number',},
            {label: 'Vendas 2018', fieldName: 'Amount2018', type: 'number',},
            {label: 'Volume Meta', fieldName: 'VolumeGoal', type: 'number',editable: false,},
            {label: 'Preço Meta', fieldName: 'AmountGoal', type: 'number',editable: false,},
            {label: 'Vendas Meta', fieldName: 'Goal_Billing', type: 'number',},
            
        ]);
                     
                 var ContractHeader = component.get("v.ContractHeader");
                if(ContractHeader.TotalValueLY != 0){
                var growthRate = (ContractHeader.TotalValue-ContractHeader.TotalValueLY)/ContractHeader.TotalValueLY*100;
                component.set("v.ContractHeader.GrowthRate", growthRate);
                }
                     }
                     else{
                      component.find('notifLib').showToast({
            "variant": "error",
            "message": response.getReturnValue(),
           
        });
                     }
            }
        });
        $A.enqueueAction(actionsubmit);
		             
                }
            
        });
        $A.enqueueAction(actionsave);   
        }
        else{
            component.find('notifLib').showToast({
            "variant": "error",
            "message": $A.get("$Label.c.NONZero"),
           
        }); 
        }  
    },
        
        onUpdateOtherValue: function (component, event, helper) {
            var contractheader = component.get("v.ContractHeader");
            contractheader.TotalOtherValue = component.find("otherValue").get("v.value");
            console.log(contractheader.TotalOtherValue);
            //contractheader.TotalTypeValue = TotalValue;
            contractheader.TotalValue = contractheader.TotalOtherValue+contractheader.TotalTypeValue;
            component.set("v.ContractHeader",contractheader);
            console.log(component.get("v.ContractHeader"));
            
        },
                     
       onActiveMaterialTab: function (component, event, helper) {
              if(component.get("v.UserType") === 'Manager'){
            component.set("v.Editable", false);
        }
        if(component.get("v.ContractHeader")){
        var Contract = component.get("v.ContractHeader");
            console.log(Contract.Status +' '+Contract.CRMStatus);
        if(Contract.Status != 'Aguardando Metas' || Contract.CRMStatus === 'In Review' || Contract.CRMStatus === 'Approved' ){
         component.set("v.Editable", false);
            console.log(component.get("v.Editable"))
        }
            var Editable = component.get("v.Editable");
        component.set('v.Materialscolumns', [
            {label: 'Product Category', fieldName: 'product_category', type: 'text', },
            {label: 'Marca', fieldName: 'ProductGroup', type: 'text', },
            {label: 'SKU', fieldName: 'code', type: 'text',},
            
            {label: 'Produto', fieldName: 'Product', type: 'text',},
            {label: 'Volume 2018', fieldName: 'Volume2018', type: 'number',typeAttributes: { minimumFractionDigits: '2' }},
            {label: 'Preço² 2018', fieldName: 'Price2018', type: 'number',typeAttributes: { minimumFractionDigits: '2' }},
            {label: 'Vendas 2018', fieldName: 'Amount2018', type: 'number',typeAttributes: { minimumFractionDigits: '2' }},
            {label: 'Volume Meta', fieldName: 'VolumeGoal', type: 'number',editable: Editable,typeAttributes: { minimumFractionDigits: '2' }},
            {label: 'Preço Meta', fieldName: 'AmountGoal', type: 'number',editable: Editable,typeAttributes: { minimumFractionDigits: '2' }},
            {label: 'Vendas Meta', fieldName: 'Goal_Billing', type: 'number',typeAttributes: { minimumFractionDigits: '2' }},
            
        ]);   
           
               }
            },
                
                sendGoalsJS : function (component, event, helper) {
           console.log('Inside send goals');
        var Materialsdata = component.get("v.Materialsdata");
        var action = component.get("c.sendGoals");
        //Set the Object parameters and Field Set name
        var ContractHeader = component.get("v.ContractHeader");
        action.setParams({  
            liGD : Materialsdata,
            rC : component.get("v.ContractHeader")         
        });   
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === 'SUCCESS'){
                    
                if( response.getReturnValue() == 'Metas enviadas com sucesso'){
                    component.find('notifLib').showToast({
                        "variant": "success",
                        "message": response.getReturnValue(),
                        
                    });
               
                     }
                     else{
                      component.find('notifLib').showToast({
            "variant": "error",
            "message": response.getReturnValue(),
           
        });
                     }
            }
        });
        $A.enqueueAction(action);   
        
        
    },
})