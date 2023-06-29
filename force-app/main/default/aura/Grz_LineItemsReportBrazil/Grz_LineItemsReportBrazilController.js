({
    doInit : function(component, event, helper) {
        var action = component.get("c.getSalesOrderLineItemDetails");
        action.setParams({ 
            startDate : component.get("v.startDate"),
            endDate : component.get("v.endDate"),
            distributor : component.get("v.distributorValue"),
            pageNumber : component.get("v.pageNumber"),
            pageSize : component.get("v.pageSize"),
            subGroupId : component.get("v.subGroupValue"),
        });
        action.setCallback(this, function(data) {
            var state = data.getState();
            if (state === "SUCCESS") {
                var salesLineItemData = data.getReturnValue().salesOrderLineItemList;
                if(salesLineItemData.length > 0){
                    component.set('v.datafound', true);
                    component.set('v.salesOrderLineItemData',salesLineItemData);                    
                }else{
                    component.set('v.datafound', false);
                }
                component.set('v.totalrecords', data.getReturnValue().totalRecords);
                component.set('v.recordstart', data.getReturnValue().RecordStart);
                component.set('v.recordend', data.getReturnValue().RecordEnd);
                component.set('v.totalpages', Math.ceil(component.get("v.totalrecords") / component.get("v.pageSize")));
                var pagenumber = parseInt(component.get("v.pageNumber"));
                var pageList = [];
                var totalpages = component.get("v.totalpages");
                this.pagelist = [];
                if (totalpages > 1) {
                    if (totalpages < 3) {
                        if (pagenumber == 1) {
                            pageList.push(1, 2);
                        }
                        if (pagenumber == 2) {
                            pageList.push(1, 2);
                        }
                    } else {
                        if (pagenumber + 1 < totalpages && pagenumber - 1 > 0) {
                            pageList.push(pagenumber - 1, pagenumber, pagenumber + 1);
                        } else if (pagenumber == 1 && totalpages > 2) {
                            pageList.push(1, 2, 3);
                        } else if (pagenumber + 1 == totalpages && pagenumber - 1 > 0) {
                            pageList.push(pagenumber - 1, pagenumber, pagenumber + 1);
                        } else if (pagenumber == totalpages && pagenumber - 1 > 0) {
                            pageList.push(pagenumber - 2, pagenumber - 1, pagenumber);
                        }
                    }
                }
                if (component.get("v.pageNumber") == 1) {
                    component.set('v.disableFirst',true);
                }else{
                    component.set('v.disableFirst',false);
                }
                if (
                    component.get("v.pageNumber") == component.get("v.totalpages") ||
                    component.get("v.pageNumber") >= component.get("v.totalpages")
                ) {
                    component.set('v.disableNext',true);
                }else{
                    component.set('v.disableNext',false);
                }
                component.set('v.pagelist',pageList);
            }
            else{
                console.log('error for sales:',data.getError());
                component.set('v.datafound', false);
                component.set('v.disableNext',true);
            }
        });
        $A.enqueueAction(action);
    },
    handleFirst:function(component, event, helper) {
        var pagenumber = 1;
        component.set('v.pageNumber',pagenumber);
    },
    handlePrevious:function(component, event, helper) {
        component.set('v.pageNumber',component.get('v.pageNumber')-1);
    },
    handleNext:function(component, event, helper) {
        component.set('v.pageNumber',component.get("v.pageNumber")+1);
    },
    handleLast:function(component, event, helper) {
        component.set('v.pageNumber',component.get("v.totalpages"));
    },
    processMe:function(component, event, helper) {
        component.set('v.pageNumber',parseInt(event.target.name));
    },
    handleSalesOrderLineItemClick:function(component, event, helper) {
        let recordId = event.currentTarget.dataset.id;
        component.set('v.detailPageLink','sales-order/'+recordId);
    }
})