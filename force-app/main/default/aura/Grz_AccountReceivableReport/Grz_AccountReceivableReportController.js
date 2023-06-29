({ 
    scriptsLoaded : function(component, event, helper) {
        component.set('v.loaded', false);
        var action = component.get("c.getuserInfo");
        action.setCallback(this, function(data) {
            var state = data.getState();
            if (state === "SUCCESS") {
                let val = data.getReturnValue();
                console.log('AROnload===>',val);
                component.set("v.isParentBr",val.isParentBr);
                component.set("v.isMainParent",val.isMainParent);//Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
                component.set("v.customerCode",val.customerCode);
                component.set("v.sapUserId",val.sapUserId);
                component.set("v.companyCode",val.companyCode);
                if(val.isParentBr){
                    let distr = val.cstrCode;
                    if (distr.length > 0) {
                        let cstCode = [];
                        const opt = {
                            label: "Todos",
                            value: "All"
                        };
                        cstCode = [...cstCode, opt];
                        for (let i = 0; i < distr.length; i++) {
                            let arr = distr[i].split(' - ');//Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
                            const option = {
                                label: arr[1].substr(0,12) + ' - ' + arr[2].substr(0,12) + ' - ' + arr[0].substr(arr[0].length - 7),//Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
                                value: distr[i].substr(0, distr[i].indexOf(' -'))
                            };
                            cstCode = [...cstCode, option];
                        }
                        component.set('v.distributorOptionsBr',cstCode);
                    }
                }
                //Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
                if(val.isMainParent){
                    let subData = val.subGroupData;
                    if (subData.length > 0) {
                        let cstCode = [];
                        for (let i = 0; i < subData.length; i++) {
                            let arr = subData[i].split(' - ');
                            const option = {
                                label: arr[1].substr(0,12) + ' - ' + arr[2].substr(0,12) + ' - ' + arr[0].substr(arr[0].length - 7),
                                value: subData[i].substr(0, subData[i].indexOf(' -'))
                            };
                            cstCode = [...cstCode, option];
                        }
                        component.set('v.subGroupOptionsBr',cstCode);
                    }
                }
                helper.scriptsBrazil(component, event);
            }        
        });
        $A.enqueueAction(action);
    },
    handleDistributor : function(component, event, helper) {
        component.set('v.distributorValuep', event.getParam("value"));
        component.set('v.subGroupValue', "");//Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
        helper.scriptsBrazil(component, event);       
    },
    //Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
    handleSubGroup : function(component, event, helper) {
        component.set('v.subGroupValue', event.getParam("value"));
        component.set('v.distributorValuep', "All");
        helper.scriptsBrazil(component, event);       
    }
})