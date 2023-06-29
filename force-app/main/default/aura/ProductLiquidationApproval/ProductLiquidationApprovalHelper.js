({
	fetchData : function(component,event, helper) {
		var ac = component.get('c.getliquidation');
	    var selectedTerritories = component.get("v.ProductTerritoryId");
        var currentMon = component.get('v.Month');
        var FiscalYear = component.get('v.productFY');
        if(currentMon==='Apr'){
        component.set("v.Editable",true);
        var valuesedit = component.get("v.Editable");
        console.log('valuesedit : '+valuesedit);
        }
        ac.setParams({ 
            territoryName: selectedTerritories,
            FiscalYear:FiscalYear ,
            mon:currentMon
                     });
        ac.setCallback(this, function(response){
             var state = response.getState();
            if(state === "SUCCESS"){
			    var returnValue = response.getReturnValue();
                component.set('v.liquidationData', response.getReturnValue());
                var liquidationDatas = component.get('v.liquidationData');
				 component.set('v.columns', [
            {label: 'Material Group', fieldName: 'Brand_Name__c', type: 'text', hideDefaultActions:true, fixedWidth:140},
            {label: 'Brand Name', fieldName: 'Product_Name__c', type: 'text', hideDefaultActions:true, fixedWidth:120},
            {label: 'Opening Inventory', fieldName: 'Opening_Inventory__c', type: 'number', hideDefaultActions:true,editable:valuesedit, fixedWidth:100},
            {label: 'YTD Sales', fieldName : 'YTD_Sales__c', type: 'number', hideDefaultActions:true, fixedWidth:80},
            {label: 'Total Available Stock', fieldName : 'Total_Available_Stock__c', type: 'number',hideDefaultActions:true, fixedWidth:100},
            {label: 'Distributors Inventory', fieldName : 'Distributors_Inventory__c', type: 'number',hideDefaultActions:true, editable:true, fixedWidth:100},
            {label: 'Retailers Inventory', fieldName : 'Retailers_Inventory__c', type: 'number',hideDefaultActions:true, editable: true , fixedWidth:100},
            {label: 'Total Market Inventory', fieldName : 'Total_Market_Inventory__c', type: 'number',hideDefaultActions:true, fixedWidth:100},
            {label: 'Plan YTD '+currentMon, fieldName : 'Plan_for_the_month__c', type: 'number',hideDefaultActions:true, fixedWidth:100},
            //Added by Varun Shrivastava Start
            {label: 'Product Budget', fieldName : 'Product_Budget__c', type: 'number',hideDefaultActions:true, fixedWidth:100},
            //Added by Varun Shrivastava End
            {label: 'Liquidation YTD '+currentMon, fieldName : 'Liquidation_YTD_current_month__c', type: 'number',hideDefaultActions:true, fixedWidth:100},
            {label: 'Liquidation % YTD '+currentMon, fieldName : 'Liquidation_YTD_current_month_Percentage__c', type: 'percent',hideDefaultActions:true, fixedWidth:100},
            {label: 'Plan For The Next Month', fieldName : 'Plan_for_the_next_month__c', type: 'number',hideDefaultActions:true, editable:true, fixedWidth:100}
        ]);
			}
            else{
                alert("Error In Loading Liqui Data");
            }
        });
        
        $A.enqueueAction(ac); 
        
	},
    handleEditCell : function(component, event, helper){
        var updatedL = event.getParam('draftValues');
       // console.log('Updated Records', updatedL );
        
        
        for(var i = 0; i < updatedL.length; i++){
            console.log(updatedL[i]);
            var fId;
            var fName;
            var fValue;
            var oiValue;
            var ytdSalesValue;
            if(updatedL[i].Distributors_Inventory__c != undefined && updatedL[i].Distributors_Inventory__c != '' && updatedL[i].Distributors_Inventory__c != null ){
                fId = updatedL[i].Id;
                fName = "Distributors_Inventory__c";
                fValue = updatedL[i].Distributors_Inventory__c;
                this.validations( component,event,helper,fId,fName,fValue);
            }else if(updatedL[i].Retailers_Inventory__c != undefined && updatedL[i].Retailers_Inventory__c != '' && updatedL[i].Retailers_Inventory__c != null ){
                fId = updatedL[i].Id;
                fName = "Retailers_Inventory__c";
                fValue = updatedL[i].Retailers_Inventory__c;
                this.validations( component,event,helper,fId,fName,fValue);
                
            }
             else if( updatedL[i].Opening_Inventory__c != undefined && updatedL[i].Opening_Inventory__c != '' && updatedL[i].Opening_Inventory__c != null ){
             var op = component.get('c.OpenInventoryUpdate');
                var Territory = component.get("v.ProductTerritoryId");
                var FiscalYear = component.get("v.productFY");
                var Month = component.get("v.Month");
                op.setParams({
                    "RecordId": updatedL[i].Id,
                    "OpenInventory" : updatedL[i].Opening_Inventory__c,
                    "territoryName" : Territory,
                    "FiscalYear" : FiscalYear,
                    "Month" : Month
                });
                op.setCallback(this, function(response){
                    var state = response.getState();
                    if(state === "SUCCESS"){
                        var data = response.getReturnValue();
                        component.set('v.liquidationData',data);
                        //alert("Record Updated Successfully");
                        //$A.get('e.force:refreshView').fire();
                        component.find( "dtTable" ).set( "v.draftValues", null );
                    }
                    else{
                        console.log("Error msg: "+response.getError());
                    }
                });
                $A.enqueueAction(op);
            
             }
            else if( updatedL[i].Plan_for_the_next_month__c != undefined && updatedL[i].Plan_for_the_next_month__c != '' && updatedL[i].Plan_for_the_next_month__c != null ){
                var nup = component.get('c.normalUpdate');
                var Territory = component.get("v.ProductTerritoryId");
                var FiscalYear = component.get("v.productFY");
                var Month = component.get("v.Month");
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
                        component.set('v.liquidationData',data);
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
                console.log(' inside fourth if');
                if( updatedL[i].Distributors_Inventory__c == '' && updatedL[i].Retailers_Inventory__c == undefined && updatedL[i].Plan_for_the_next_month__c == undefined && updatedL[i].Opening_Inventory__c == undefined ){
                    console.log(' edited column is Distributors_Inventory__c');
                    FieldNameHere = 'Distributors_Inventory__c';
                }else if( updatedL[i].Distributors_Inventory__c == undefined && updatedL[i].Retailers_Inventory__c == '' && updatedL[i].Plan_for_the_next_month__c == undefined && updatedL[i].Opening_Inventory__c == undefined ){
                    console.log(' edited column is Retailers_Inventory__c');
                    FieldNameHere = 'Retailers_Inventory__c';
                }else if( updatedL[i].Distributors_Inventory__c == undefined && updatedL[i].Retailers_Inventory__c == undefined && updatedL[i].Plan_for_the_next_month__c == '' && updatedL[i].Opening_Inventory__c == undefined ){
                    console.log('edited column is Plan_for_the_next_month__c');
                    FieldNameHere = 'Plan_for_the_next_month__c';
                }
                else if( updatedL[i].Distributors_Inventory__c == undefined && updatedL[i].Retailers_Inventory__c == undefined && updatedL[i].Plan_for_the_next_month__c == undefined && updatedL[i].Opening_Inventory__c == '' ){
                    console.log('edited column is Opening_Inventory__c');
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

    validations : function( component,event,helper,fId,fName,fValue){
        
        var Territory = component.get("v.ProductTerritoryId");
        //Added by Varun Shrivastava : 
        console.log('Sayan Territory: '+Territory );
		var FiscalYear = component.get("v.productFY");
        console.log('Sayan Fiscal Year: '+FiscalYear);
        var Month = component.get("v.Month");
        console.log('Sayan Month: '+Month);
        var liqEnabledFlag = component.get("v.isLiquidationValidationEnabled");
        var ResultOnActionCallState;
        
        console.log('Validation Called');
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
                console.log('Response Validation : '+ResultOnActionCallState);
                if( ResultOnActionCallState === "ERROR" ){
                    //target.focus();
                    //target.set("v.value",0);
                    //Inventory should not exceed Total available stock
                   /* var toastEvent1 = $A.get("e.force:showToast");
                    var titl  = $A.get("{!$Label.c.Error}");
                    toastEvent1.setParams({
                        "title": titl,
                        "type": "Error",
                        "message": "Inventory should not exceed Total available stock"
                        //"duration":'3000'
                    });
                    toastEvent1.fire(); */
                    alert( 'Inventory should not exceed Total available stock' );
                    component.find( "dtTable" ).set( "v.draftValues", null );
                    component.set("v.UpdationStatus",false);
                } 
                if( ResultOnActionCallState === "SUCCESSFULL" ){
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
                console.log("Validation Error msg: "+JSON.stringify(response.getError));
            }
        });
        $A.enqueueAction(Action);
        
    },
    
    UpdateData : function(component,event,helper,UpdationStatus){
        var Territory = component.get("v.ProductTerritoryId");
        var FiscalYear = component.get("v.productFY");
        var Month = component.get("v.Month");
        
        var ResultOnActionCallState;
        
        var updatedL = event.getParam('draftValues');
        //console.log('Updated Records', updatedL );
        console.log('UpdationStatus : '+UpdationStatus)
        
        for(var i = 0; i < updatedL.length; i++){
            console.log('liquiupdate Inside For Loop');
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
                    component.set('v.liquidationData',data);
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
        var FiscalYear = component.get("v.productFY");
        var Month = component.get("v.Month");
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
                component.set('v.liquidationData',data);
                component.find( "dtTable" ).set( "v.draftValues", null );
            }
            else{
                console.log("Error msg: "+response.getError());
            }
        });
        $A.enqueueAction(actionhere);
    }
})