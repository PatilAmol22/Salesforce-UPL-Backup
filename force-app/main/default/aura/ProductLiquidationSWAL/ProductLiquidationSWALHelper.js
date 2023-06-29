({
    fetchData : function(component,event,helper) {
        var MonthHere = component.get("v.ProductMonth");
        var valuesedit = component.get("v.Editable");
        if( MonthHere=='Apr' ){
            component.set("v.OpeningInventoryEditable",true);
        }
        var OIedit = component.get("v.OpeningInventoryEditable");
        component.set('v.columns', [
            //{label: 'Id', fieldName: 'Id', type: 'text'},
            {label: 'Material Group', fieldName: 'Brand_Name__c', type: 'text', hideDefaultActions:true, fixedWidth:115},
            {label: 'Brand Name', fieldName: 'Product_Name__c', type: 'text', hideDefaultActions:true, fixedWidth:195},
            {label: 'Opening Inventory', fieldName: 'Opening_Inventory__c', type: 'number', hideDefaultActions:true, editable:OIedit, fixedWidth:134},
            {label: 'YTD Sales', fieldName : 'YTD_Sales__c', type: 'number', hideDefaultActions:true, fixedWidth:80},
            {label: 'Total Available Stock', fieldName : 'Total_Available_Stock__c', type: 'number',hideDefaultActions:true, fixedWidth:145},
            {label: 'Distributors Inventory', fieldName : 'Distributors_Inventory__c', type: 'number',hideDefaultActions:true, editable:valuesedit, fixedWidth:155},
            {label: 'Retailers Inventory', fieldName : 'Retailers_Inventory__c', type: 'number',hideDefaultActions:true, editable: valuesedit , fixedWidth:145},
            {label: 'Total Market Inventory', fieldName : 'Total_Market_Inventory__c', type: 'number',hideDefaultActions:true, fixedWidth:160},
            {label: 'Plan YTD '+MonthHere, fieldName : 'Plan_for_the_month__c', type: 'number',hideDefaultActions:true, fixedWidth:100},
            //Added by Varun Shrivastava Start
            {label: 'Product Budget', fieldName : 'Product_Budget__c', type: 'number',hideDefaultActions:true, fixedWidth:100},
            //Added by Varun Shrivastava End
            {label: 'Liquidation YTD '+MonthHere, fieldName : 'Liquidation_YTD_current_month__c', type: 'number',hideDefaultActions:true, fixedWidth:150},
            {label: 'Liquidation % YTD '+MonthHere, fieldName : 'Liquidation_YTD_current_month_Percentage__c', type: 'percent',hideDefaultActions:true, fixedWidth:165},
            {label: 'Plan For The Next Month', fieldName : 'Plan_for_the_next_month__c', type: 'number',hideDefaultActions:true, editable:valuesedit, fixedWidth:180}
        ]);
        var ac = component.get('c.getsliquidationData');
        var Territory = component.get("v.ProductTerritoryId");
        console.log('Sayan Territory: '+Territory );
        var FiscalYear = component.get("v.ProductFiscalYear");
        console.log('Sayan Fiscal Year: '+FiscalYear);
        var Month = component.get("v.ProductMonth");
        console.log('Sayan Month: '+Month);
        ac.setParams({
            "territoryName" : Territory,
            "FiscalYear" : FiscalYear,
            "Month" : Month
        });
        ac.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set('v.data',data);
            }else{
                console.log('Failed: '+response.getError() );
            }
        });
        $A.enqueueAction(ac);
        
    },
    
    handleEditCell : function(component, event, helper){
        var updatedL = event.getParam('draftValues');
        console.log('Updated Records', updatedL );
        
        
        for(var i = 0; i < updatedL.length; i++){
            console.log('Sayan Inside For Loop-->');
            console.log(updatedL[i]);
            var fId;
            var fName;
            var fValue;
            if(updatedL[i].Distributors_Inventory__c != undefined && updatedL[i].Distributors_Inventory__c != '' && updatedL[i].Distributors_Inventory__c != null ){
                console.log('updating Distributors_Inventory__c');
                fId = updatedL[i].Id;
                fName = "Distributors_Inventory__c";
                fValue = updatedL[i].Distributors_Inventory__c;
                this.validations( component,event,helper,fId,fName,fValue );
            }else if(updatedL[i].Retailers_Inventory__c != undefined && updatedL[i].Retailers_Inventory__c != '' && updatedL[i].Retailers_Inventory__c != null ){
                console.log('updating Retailers_Inventory__c');
                fId = updatedL[i].Id;
                fName = "Retailers_Inventory__c";
                fValue = updatedL[i].Retailers_Inventory__c;
                this.validations( component,event,helper,fId,fName,fValue );
            }else if( updatedL[i].Plan_for_the_next_month__c != undefined && updatedL[i].Plan_for_the_next_month__c != '' && updatedL[i].Plan_for_the_next_month__c != null ){
                console.log('updating Plan_for_the_next_month__c');
                var nup = component.get('c.normalUpdate');
                var Territory = component.get("v.ProductTerritoryId");
                var FiscalYear = component.get("v.ProductFiscalYear");
                var Month = component.get("v.ProductMonth");
                nup.setParams({
                    "RecordId": updatedL[i].Id,
                    "PlanForNext" : updatedL[i].Plan_for_the_next_month__c,
                    "territoryName" : Territory,
                    "FiscalYear" : FiscalYear,
                    "Month" : Month
                });
                nup.setCallback(this, function(response){
                    var state = response.getState();
                    if(state === "SUCCESS"){
                        var data = response.getReturnValue();
                        component.set('v.data',data);
                        //alert("Record Updated Successfully");
                        //$A.get('e.force:refreshView').fire();
                        component.find( "dtTable" ).set( "v.draftValues", null );
                    }
                    else{
                        console.log("Error msg: "+response.getError());
                    }
                });
                $A.enqueueAction(nup);
            }else if( updatedL[i].Opening_Inventory__c != undefined && updatedL[i].Opening_Inventory__c != '' && updatedL[i].Opening_Inventory__c != null ){
                console.log('updating Opening_Inventory__c');
                var nup = component.get('c.OpeningInventoryUpdate');
                var Territory = component.get("v.ProductTerritoryId");
                var FiscalYear = component.get("v.ProductFiscalYear");
                var Month = component.get("v.ProductMonth");
                nup.setParams({
                    "RecordId": updatedL[i].Id,
                    "OI" : updatedL[i].Opening_Inventory__c,
                    "territoryName" : Territory,
                    "FiscalYear" : FiscalYear,
                    "Month" : Month
                });
                nup.setCallback(this, function(response){
                    var state = response.getState();
                    if(state === "SUCCESS"){
                        var data = response.getReturnValue();
                        component.set('v.data',data);
                        //alert("Record Updated Successfully");
                        //$A.get('e.force:refreshView').fire();
                        component.find( "dtTable" ).set( "v.draftValues", null );
                    }
                    else{
                        console.log("Error msg: "+response.getError());
                    }
                });
                $A.enqueueAction(nup);
            }else{
                var FieldNameHere;
                console.log('updating else part');
                if( updatedL[i].Distributors_Inventory__c == '' && updatedL[i].Retailers_Inventory__c == undefined && updatedL[i].Plan_for_the_next_month__c == undefined && updatedL[i].Opening_Inventory__c == undefined ){
                    console.log('Sayan edited column is Distributors_Inventory__c');
                    FieldNameHere = 'Distributors_Inventory__c';
                }else if( updatedL[i].Distributors_Inventory__c == undefined && updatedL[i].Retailers_Inventory__c == '' && updatedL[i].Plan_for_the_next_month__c == undefined && updatedL[i].Opening_Inventory__c == undefined ){
                    console.log('Sayan edited column is Retailers_Inventory__c');
                    FieldNameHere = 'Retailers_Inventory__c';
                }else if( updatedL[i].Distributors_Inventory__c == undefined && updatedL[i].Retailers_Inventory__c == undefined && updatedL[i].Plan_for_the_next_month__c == '' && updatedL[i].Opening_Inventory__c == undefined ){
                    console.log('Sayan edited column is Plan_for_the_next_month__c');
                    FieldNameHere = 'Plan_for_the_next_month__c';
                }else if( updatedL[i].Distributors_Inventory__c == undefined && updatedL[i].Retailers_Inventory__c == undefined && updatedL[i].Plan_for_the_next_month__c == undefined && updatedL[i].Opening_Inventory__c == '' ){
                    console.log('Sayan edited column is Opening_Inventory__c');
                    FieldNameHere = 'Opening_Inventory__c';
                }
                var FieldIdHere = updatedL[i].Id;
                this.UpdateNullValueAsZero( component,event,helper,FieldNameHere,FieldIdHere );
            }
        }
        
    },
    fetchLiquidationCustomSetting: function( component){
        var action = component.get('c.fetchCustomSetting');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var data = response.getReturnValue();
                component.set('v.isLiquidationValidationEnabled',data);
                console.log('Custom Setting Enabled : '+data);
            }
            else{
                console.log("Error msg: "+response.getError());
            }
        });
        $A.enqueueAction(action);

    },

    validations : function( component,event,helper,fId,fName,fValue ){
        
        var Territory = component.get("v.ProductTerritoryId");
        console.log('Sayan Territory: '+Territory );
        var FiscalYear = component.get("v.ProductFiscalYear");
        console.log('Sayan Fiscal Year: '+FiscalYear);
        var Month = component.get("v.ProductMonth");
        console.log('Sayan Month: '+Month);
        var liqEnabledFlag = component.get("v.isLiquidationValidationEnabled");
        
        var ResultOnActionCallState;
        
        
        var Action = component.get("c.Validation");
        Action.setParams({
            "territoryName" : Territory,
            "FiscalYear" : FiscalYear,
            "Month" : Month,
            "LiqId" : fId,
            "FieldName" : fName,
            "FieldValue" : fValue
        });
        Action.setCallback(this, function(response){
            var ActionCallState = response.getState();
            if(ActionCallState === "SUCCESS"){
                ResultOnActionCallState = response.getReturnValue();
                if( ResultOnActionCallState === "ERROR" ){
                    //target.focus();
                    //target.set("v.value",0);
                    //Inventory should not exceed Total available stock
                    /*var toastEvent1 = $A.get("e.force:showToast");
                    var titl  = $A.get("{!$Label.c.Error}");
                    toastEvent1.setParams({
                        "title": titl,
                        "type": "Error",
                        "message": "Inventory should not exceed Total available stock"
                        //"duration":'3000'
                    });
                    toastEvent1.fire();*/
                    alert( 'Inventory should not exceed Total available stock' );
                    component.find( "dtTable" ).set( "v.draftValues", null );
                    component.set("v.UpdationStatus",false);
                }else if( ResultOnActionCallState === "SUCCESSFULL" ){
                    component.set("v.UpdationStatus",true);
                }
                if(ResultOnActionCallState === "LIQUIDATION ERROR"){
                    console.log('Lqi Error:');
                    if(liqEnabledFlag == true){
                        component.set("v.UpdationStatus",false);
                        console.log('Lqi Error:1');
                        alert( 'Current Month Liquidation can not be less than Last Month Liquidation' );
                        component.find( "dtTable" ).set( "v.draftValues", null );
                    }else{
                        component.set("v.UpdationStatus",true);
                        console.log('Lqi Error:2');
                        alert( 'Current Month Liquidation can not be less than Last Month Liquidation' );
                    }
                }
                var UpdationStatus = component.get("v.UpdationStatus");
                this.UpdateData(component,event,helper,UpdationStatus);
            }
            else{
                console.log("Validation Error msg: "+response.getError());
            }
        });
        $A.enqueueAction(Action);
        
    },
    
    UpdateData : function(component,event,helper,UpdationStatus){
        var Territory = component.get("v.ProductTerritoryId");
        console.log('Sayan Territory: '+Territory );
        var FiscalYear = component.get("v.ProductFiscalYear");
        console.log('Sayan Fiscal Year: '+FiscalYear);
        var Month = component.get("v.ProductMonth");
        console.log('Sayan Month: '+Month);
        
        var ResultOnActionCallState;
        
        var updatedL = event.getParam('draftValues');
        console.log('Updated Records', updatedL );
        
        
        for(var i = 0; i < updatedL.length; i++){
            console.log('Sayan Inside For Loop');
            var EditAction = component.get('c.liquiUpdate');
            EditAction.setParams({
                "editList": updatedL,
                "territoryName" : Territory,
                "FiscalYear" : FiscalYear,
                "Month" : Month,
                "UpdationStatus" : UpdationStatus
            });
            EditAction.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    var data = response.getReturnValue();
                    component.set('v.data',data);
                    //alert("Record Updated Successfully");
                    //$A.get('e.force:refreshView').fire();
                    component.find( "dtTable" ).set( "v.draftValues", null );
                }
                else{
                    console.log("Error msg: "+response.getError());
                }
            });
            $A.enqueueAction(EditAction);
            component.find( "dtTable" ).set( "v.draftValues", null );
            
        }
    },
    
    UpdateNullValueAsZero : function( component,event,helper,FieldNameHere,FieldIdHere ){
        var actionhere = component.get( 'c.UpdateNullValueAsZero' );
        var Territory = component.get("v.ProductTerritoryId");
        var FiscalYear = component.get("v.ProductFiscalYear");
        var Month = component.get("v.ProductMonth");
        actionhere.setParams({
            "territoryName" : Territory,
            "FiscalYear" : FiscalYear,
            "Month" : Month,
            "FieldNameHere": FieldNameHere,
            "FieldIdHere" : FieldIdHere
        });
        actionhere.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var data = response.getReturnValue();
                component.set('v.data',data);
                component.find( "dtTable" ).set( "v.draftValues", null );
            }
            else{
                console.log("Error msg: "+response.getError());
            }
        });
        $A.enqueueAction(actionhere);
    }
    
})