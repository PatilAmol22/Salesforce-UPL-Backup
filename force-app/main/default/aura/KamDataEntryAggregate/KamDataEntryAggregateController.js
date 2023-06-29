({
    doInit : function(component, event, helper) {
        var mList = component.get("v.masterList");
        var pagination=[];
        var RowItemList = [];
        if(mList.length >0){
            for(var i=0;i<mList.length;i++){
                if(mList[i].isProductChecked = true){
                    RowItemList = mList[i].dfpayList;
                    if(mList[i].dfpayList!=null && mList[i].dfpayList.length>0)
                        component.set("v.rCode",mList[i].dfpayList[i].reason);
                    break;
                }
            }
            component.set("v.PayoutList",RowItemList);
        }
        pagination = component.get("v.PayoutList");
        var isDefined = !$A.util.isUndefined(pagination);
        if(!isDefined || pagination.length==0 ){
            var rowItem={
                Tier: 1,
                quantity: 0,
                threshold: 0,
                payout: 0,
                payoutPct: 0,
                length:1,
                del:false,              
                reason:'Competitive Response',  
            };
            var RowItemList = [];
            RowItemList.push(rowItem);
            component.set("v.PayoutList",RowItemList);
        }
    },
    AddrCode: function(component, event, helper) {
        var List = component.get("v.PayoutList");
        if(List.length>0){
            List[0].reason = component.get("v.rCode");
        }
        component.set("v.PayoutList",List);
    },
    
    addNewRow: function(component, event, helper) {
        var pyList = component.get("v.PayoutList");
        pyList.push({
            'Tier':pyList.length + 1,
            'quantity': 0,
            'threshold': 0,
            'payout': 0,
            'payoutPct': 0,
            'del':false,
            'reason':component.get("v.rCode"),
        });
        component.set("v.PayoutList",pyList);
    },
    
    closeModel:  function(component, event, helper){
        var cmpEvent = component.getEvent("closeModal");
        cmpEvent.fire();
    },
    removeRow: function(component, event, helper){
        var temp = [];
        temp = component.get("v.PayoutList");
        if(temp.length > 1){
            temp.pop();
            component.set("v.PayoutList",temp);
        }
    },
    
    submitDetails: function(component, event, helper){
        var cmpEvent = component.getEvent("setPayout");
        cmpEvent.setParams({
            "payout" : component.get("v.PayoutList"),
            "rCode" : component.get("v.rCode")
        });
        cmpEvent.fire();
    }
})