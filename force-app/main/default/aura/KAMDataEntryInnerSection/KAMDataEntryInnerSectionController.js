({
    doInit : function(component, event, helper) {
        var pagination=[];
        pagination = component.get("v.PayoutList");
        var isDefined = !$A.util.isUndefined(pagination);
        if(!isDefined || pagination.length==0 && component.get("v.draftQty")!=null){
            var rowItem={
            Tier: 1,
            quantity: 0,
            threshold: 0,
            payout: 0,
            payoutPct: 0,
            del:false
        };
            var RowItemList = [];
            RowItemList.push(rowItem);
            component.set("v.PayoutList",RowItemList);
        }else{
            for (var i = 0;i < pagination.length; i++) {
                pagination[i].quantity =(pagination[i].threshold/component.get('v.draftQty'))*100;
                component.set("v.PayoutList",pagination);
            }  
        }
    },
    
    addNewRow: function(component, event, helper) {
        var pyList = component.get("v.PayoutList");
        pyList.push({
            'Tier':pyList.length + 1,
            'quantity': 0,
            'threshold': 0,
            'payout': 0,
            'payoutPct': 0,
            'del':false
        });
        component.set("v.PayoutList",pyList);
    },
 
    removeDeletedRow: function(component, event, helper) {
        var index = event.getParam("indexVar");
        var delList = component.get("v.PayoutDelList");
        var AllRowsList = component.get("v.PayoutList");
        var pyList = component.get("v.PayoutList");
        if(pyList[index].payoutId && pyList[index].payoutId != ''){
            pyList[index].del = true;
            delList.push(pyList[index].payoutId);
        }
        component.set("v.PayoutDelList",delList);
        if(index != 0){
            AllRowsList.splice(index, 1);
        }
        for(var i=0;i<AllRowsList.length;i++){
            AllRowsList[i].Tier = i+1;
        }
        component.set("v.PayoutList", AllRowsList);
        component.getEvent("KAMDataEntryDynamicRowPayoutList").setParams({
            "indexVar" : component.get("v.rowIndex"),
            "payList" :component.get("v.PayoutList"),
            "toDelList":component.get("v.PayoutDelList")
        }).fire();
    },

    ApplyChanges: function(component, event, helper) {
        var index = event.getParam("indexVar");
        var payout = event.getParam("payWrapper");
        var AllRowsList = component.get("v.PayoutList");
        AllRowsList[index] = payout;
        component.set("v.PayoutList", AllRowsList);
        console.log('==PayoutList>',component.get("v.PayoutList"));
        component.getEvent("KAMDataEntryDynamicRowPayoutList").setParams({
            "indexVar" : component.get("v.rowIndex"),
            "payList" :component.get("v.PayoutList"),
            "toDelList":component.get("v.PayoutDelList")
        }).fire();
    }
})