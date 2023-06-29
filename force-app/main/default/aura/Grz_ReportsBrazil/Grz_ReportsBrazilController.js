({
    doInit: function (component, event, helper) {

        var action = component.get("c.getAccountInformation");
        action.setCallback(this, function (data) {
            var state = data.getState();
            if (state === "SUCCESS") {
                let val = data.getReturnValue().Results;
                var profile = val[0].profileName;
                console.log('Profile==> ', profile);
                if (profile == 'Brazil Partner Community Distributor Profile' || profile == 'Brazil Partner Community Distributor Profile New' || profile == 'Brazil Partner Community Distributor Finance Profile' ||profile == 'Brazil Partner Community Distributor Marketing Profile'||profile == 'Brazil Partner Community Distributor Supply Profile' || profile=='Brazil Partner Community Distributor Operations Profile') {
                    component.set("v.showFilter", true);
                } else {
                    component.set("v.showFilter", false);
                }
                if (profile == 'Brazil Partner Community Distributor Profile' || profile == 'Brazil Partner Community Distributor Profile New') {
                    component.set("v.isMainUser", true);
                } else if (profile == 'Brazil Partner Community Distributor Finance Profile') {
                    component.set("v.isFinanceUser", true);
                }
                else if (profile == 'Brazil Partner Community Distributor Supply Profile') {
                    component.set("v.isSupplyUser", true);
                }
                else if (profile == 'Brazil Partner Community Distributor Marketing Profile') {
                    component.set("v.isMarketingUser", true);
                }
                else if (profile == 'Brazil Partner Community Distributor Operations Profile') {
                    component.set("v.isOperationUser", true);
                }
                
                
                component.set('v.isParentBr', val[0].isParentBr);
                component.set('v.isMainParent', val[0].isMainParent);
                if (val[0].isParentBr) {
                    let distr = val[0].cstrCode;
                    if (distr.length > 0) {
                        let cstCode = [];
                        const opt = {
                            label: "Todos",
                            value: "All"
                        };
                        cstCode = [...cstCode, opt];
                        for (let i = 0; i < distr.length; i++) {
                            let arr = distr[i].split(' - ');//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
                            const option = {
                            label: arr[1].substr(0,25) + ' - ' + arr[2].substr(0,23) + ' - ' + arr[0].substr(arr[0].length - 7),//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
                            value: distr[i].substr(0, distr[i].indexOf(' -'))
                            };
                            cstCode = [...cstCode, option];
                        }
                        component.set('v.distributorOptionsBr', cstCode);
                    }
                }
                //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
               if (val[0].isMainParent) {
                    let distr = val[0].subGroupData;
                    if (distr.length > 0) {
                        let cstCode = [];
                        for (let i = 0; i < distr.length; i++) {
                            let arr = distr[i].split(' - ');
                            const option = {
                                label: arr[1].substr(0,25) + ' - ' + arr[2].substr(0,23) + ' - ' + arr[0].substr(arr[0].length - 7),
                                value: distr[i].substr(0, distr[i].indexOf(' -'))
                            };
                            cstCode = [...cstCode, option];
                        }
                        component.set('v.subGroupOptionsBr', cstCode);
                    }
                }
                console.log(component.get("v.showFilter"));
                var today = new Date();
                var dd = String(today.getDate()).padStart(2, "0");
                var mm = String(today.getMonth() + 1).padStart(2, "0"); //January is 0!
                var yyyy = today.getFullYear();
                var today1 = new Date();
                var last30days = new Date(today1.setDate(today1.getDate() - 90));
                var ddd = String(last30days.getDate()).padStart(2, "0");
                var mmm = String(last30days.getMonth() + 1).padStart(2, "0"); //January is 0!
                var yy = last30days.getFullYear();
                component.set('v.todayDate', yyyy + "-" + mm + "-" + dd);
                var currentFiscalYear = today.getFullYear();
                //component.set('v.startDate', currentFiscalYear + "-01-01");
                component.set('v.startDatep', yy + "-" + mmm + "-" + ddd);
                component.set('v.endDatep', yyyy + "-" + mm + "-" + dd);
                component.set('v.sd', yy + "-" + mmm + "-" + ddd);
                component.set('v.ed', yyyy + "-" + mm + "-" + dd);
                component.set('v.fiscalyearStartDate', Number(currentFiscalYear) - 2 + "-01-01");
                component.set('v.fiscalyearEndDate', currentFiscalYear + "-12-31");
            }
        });
        $A.enqueueAction(action);
    },
    startDateChange: function (component, event, helper) {
        let validStartDate = event.getParam("value");
        var isInvalid = false;
        if (validStartDate < component.get('v.fiscalyearStartDate') || validStartDate > component.get('v.fiscalyearEndDate')) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "message": "Insira uma data válida."
            });
            toastEvent.fire();
            isInvalid = true;
        } else if (validStartDate > component.get('v.endDatep')) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "message": "A data de início não pode ser posterior à data de término."
            });
            toastEvent.fire();
            isInvalid = true;
        } else if (validStartDate > component.get('v.todayDate')) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "message": "A data de início e a data de término devem ser menores que hoj."
            });
            toastEvent.fire();
            isInvalid = true;
        }
        if (!isInvalid) {
            component.set("v.sd", event.getParam("value"));
            component.set('v.startDatep', component.get("v.sd"));
        }
        else {
            component.set('v.startDatep', component.get("v.sd"));
        }
    },
    endDateChange: function (component, event, helper) {
        let validEndDate = event.getParam("value");
        var isInvalid = false;
        if (validEndDate < component.get('v.fiscalyearStartDate') || validEndDate > component.get('v.fiscalyearEndDate')) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "message": "Insira uma data válida."
            });
            toastEvent.fire();
            isInvalid = true;
        } else if (validEndDate > component.get('v.todayDate')) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "message": "A data de início e a data de término devem ser menores que hoje."
            });
            toastEvent.fire();
            isInvalid = true;
        } else if (validEndDate < component.get('v.startDatep')) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "message": "A data de término não pode ser anterior à data de início."
            });
            toastEvent.fire();
            isInvalid = true;
        }
        if (!isInvalid) {
            component.set("v.ed", event.getParam("value"));
            component.set('v.endDatep', component.get("v.ed"));
        }
        else {
            component.set('v.endDatep', component.get("v.ed"));
        }
    },
    handleDistributor: function (component, event, helper) {
        component.set('v.distributorValuep', event.getParam("value"));
        component.set('v.subGroupValue', "");//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
    },
    //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
    handleSubGroup: function (component, event, helper) {
        component.set('v.subGroupValue', event.getParam("value"));
        component.set('v.distributorValuep', "All");
    }
})