({
    uplSetting:function(component, event, helper) {
        var action = component.get("c.getHiearchySettings");
        action.setCallback(this, function(response){ 
            if(response.getState() == 'SUCCESS'){
                var res = response.getReturnValue();
                console.log('Page Size ==>',res);
                component.set("v.pageSize",res);
            }else{
                console.log('Hiearchy Settings Error ==>', response.getError());
                this.genericToast('Error:', 'error', 'Please contact System Administrator');
            }
        });
        $A.enqueueAction(action);
    },

    getMarketingYear : function(component) {
        var action = component.get("c.getMarketingYear");
        action.setParams({
            "accountId": component.get("v.recordId"),
        });
        action.setCallback(this, function(response) { 
            if (response.getState() === "SUCCESS") {
                var res = response.getReturnValue();
                console.log('Marketing Year==>', res);
                component.set("v.firstYear",res.firstMarketingYear);
                component.set("v.secondYear",res.secondMarketingYear);
                component.set("v.curYear",res.firstMarketingYear);
                component.set("v.prevYear",res.firstMarketingYear-1);
            }
            else{
                console.log('Marketing Error ==>', response.getError());
                this.genericToast('Error:', 'error', 'Error while fetching marketing year. Please contact System Administrator');
            }
        });
        $A.enqueueAction(action);    
    },

    getDivision : function(component) {
        var action = component.get("c.getDivision");
        action.setParams({
            "accountId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var res = response.getReturnValue();
                console.log('Division ==>', res);
                component.set("v.divList", res);
            }
            else{
                console.log('Division Error ==>', response.getError());
                this.genericToast('Error:', 'error', 'Error while fetching Division. Please contact System Administrator');
            }
        });
        $A.enqueueAction(action);    
    },

    checkSubmit:function(component, event, helper) {
        var action = component.get("c.checkSubmitApproval");
        action.setParams({
            "accountId": component.get("v.recordId"),
            "mktYear": component.get("v.mktYear"),
            "divId" :component.get("v.custDiv")
        });
        action.setCallback(this, function(response){
            var data = response.getReturnValue();
            if(response.getState() == 'SUCCESS'){
                console.log("Draft Header Approval Status ==>", data);
                component.set("v.subDisabled",data.canNotSubmit);
                component.set("v.approvalList",data.approvalList);
            }else{
                console.log('Check Submit Error ==>', data);
                this.genericToast('Error:', 'error', 'Please contact System Administrator');
            }
        });
        $A.enqueueAction(action);        
    },
    
    retreiveWrapper:function(component, event, helper) {
        component.set('v.loaded', true);
        component.set('v.ChangeList',[]);
        var action = component.get("c.generateWrapper");
        action.setParams({
            "accountId": component.get("v.recordId"),
            "mktYear": component.get("v.mktYear"),
            "divId" :component.get("v.custDiv"),
            "hist" :component.get("v.showHistOnly")
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var resultData = response.getReturnValue();
                console.log("Retreive Wrapper ==>",resultData);
                component.set("v.AccountName",resultData.accountName);
                component.set("v.curYear",resultData.currentYear);
                component.set("v.prevYear",resultData.previousYear);
                component.set("v.dHeader",resultData.dfHeadId);
                component.set("v.MKT",resultData.MKTId);
                component.set("v.MKTYearName",resultData.MKTName);
                component.set("v.SAPcode",resultData.distSAPCode);
                component.set("v.sOrg",resultData.sOrgId);
                component.set("v.catList",resultData.KAMCatLine);
                component.set("v.datList",resultData.KAMTotalDataline);
                component.set("v.CheckedList",resultData.KAMTotalDataline);
                if(component.get("v.dHeader")){
                    component.set("v.diableDownload",false);
                    component.set("v.diableEmail",false);
                    component.set("v.diableClone",true);
                }else{
                    component.set("v.diableClone",false);
                }
                if(resultData.screenFlow == "Individual Product Offer"){
                    component.set("v.optionSelected", 'true');
                    component.set("v.picklistVisibility", false);
                }
                else if(resultData.screenFlow == "Portfolio product offer"){
                    component.set("v.optionSelected", 'false');
                    component.set("v.picklistVisibility", false);
                }
                else{
                    component.set("v.optionSelected", 'null');
                    component.set("v.picklistVisibility", true);
                }
                console.log("v.datList>>>",component.get("v.datList"));
                if(component.get("v.yearEditAccess") == false || resultData.Approved == true){
                    component.set("v.freezeInput",true);
                }
                else{
                    component.set("v.freezeInput",false);
                }
                for(var i = 0; i< resultData.KAMTotalDataline.length; i++){
                    if(resultData.KAMTotalDataline[i].dQty != 0 && resultData.KAMTotalDataline[i].isProductChecked == true){
                        component.set("v.aggregatePayoutType",resultData.KAMTotalDataline[i].payType);
                        break;
                    }
                }
                component.set("v.lastSavedBy",resultData.lastSavedName);
                component.set("v.lastSaveddate",resultData.lastSavedDate);
                component.set("v.showLast",resultData.showLastSaved);
                component.set("v.totalRecords", component.get("v.datList").length);
                var sObjectList = component.get("v.datList");
                var pageSize = component.get("v.pageSize");
                component.set("v.startPage",0);
                component.set("v.PageNumber",1);
                component.set("v.endPage",pageSize-1);
                component.set("v.TotalPages", Math.ceil(component.get("v.totalRecords") / pageSize));
                var PaginationList = [];
                for(var i=0; i< pageSize; i++){
                    if(component.get("v.datList").length> i)
                        PaginationList.push(sObjectList[i]);
                        component.set('v.PaginationList', PaginationList);
                }
                component.set("v.ediTotal",resultData.totalEDI);
                component.set("v.invTotal",resultData.totalInvoice);
                component.set("v.draftTotal",resultData.totalDraft);
                component.set("v.valTotal",resultData.totalVal);
                component.set("v.finPct",resultData.pctDraft);
                component.set('v.loaded', false);
            }else{
                console.log('Retreive Wrapper Error ==>', response.getError());
                this.genericToast('Error!', 'error', 'Please Contact System Administrator.');
                component.set('v.loaded', false);
            }
        });
        $A.enqueueAction(action); 
    },

    NavSave : function(component, event, helper) {
        console.log("v.ChangeList ==",component.get("v.ChangeList"));
        console.log("component.get(v.OptionSelection): ", component.get("v.OptionSelection"));
        var sObjectList = component.get("v.datList");
        var action = component.get("c.createDraftPlan");
        action.setParams({
            "datWrapList": component.get("v.ChangeList"),
            "accId": component.get("v.recordId"),
            "dfHeaderId":component.get("v.dHeader"),
            "SalesOrg":component.get("v.sOrg"),
            "mktYear": component.get("v.mktYear"),
            "DSapCode":component.get("v.SAPcode"),
            "delPayList":component.get("v.PayDeleteList"),
            "div":component.get("v.custDiv"),
            "screenFlow" : component.get("v.OptionSelection")
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                this.genericToast('success:', 'success', 'Draft saved successfully.');
                var resultData = response.getReturnValue();
                console.log('Save Draft ==>', resultData);
                component.set('v.loaded', false);
                var updatedfList=resultData.draftMap;
                var updatedpayList=resultData.payOutMap;
                console.log("updatedpayList>>>>",updatedpayList);
                console.log("updatedfList>>>>",updatedfList);
                component.set("v.dHeader",resultData.dHeaderId);
                component.set("v.lastSavedBy",resultData.savedname);
                component.set("v.lastSaveddate",resultData.saveddate);
                component.set("v.showLast",true);
                component.set("v.subDisabled",false);
                if(component.get("v.dHeader")){
                    component.set("v.diableDownload",false);
                    component.set("v.diableEmail",false);
                }
                for(var j=0;j<sObjectList.length;j++){
                    for(var u in updatedfList){ 
                        if(sObjectList[j].sid==u && sObjectList[j].dfId!=''){
                            sObjectList[j].dfId=updatedfList[u];
                        }  
                    }
                }
                for(var j=0;j<sObjectList.length;j++){
                    for(var u in updatedpayList){
                        if(sObjectList[j].dfId==u){
                            for(var i=0;i<sObjectList[j].dfpayList.length;i++){
                                for(var k=0;k<updatedpayList[u].length;k++){
                                    if(sObjectList[j].dfpayList[i].Tier == updatedpayList[u][k].Tier__c){
                                        sObjectList[j].dfpayList[i].payoutId=updatedpayList[u][k].Id;
                                        sObjectList[j].dfpayList[i].draftId=updatedpayList[u][k].Draft_Plan__c;
                                        sObjectList[j].dfpayList[i].reason=updatedpayList[u][k].Reason_Code__c;
                                        sObjectList[j].dfpayList[i].type=updatedpayList[u][k].Payout_Entry_Type__c;
                                    }
                                }
                            }
                        }
                    }
                }
                //component.set("v.ChangeList",[]);
            }
            else{
                console.log('Save Draft Error ==>', response.getError());
                this.genericToast('Error:', 'error', 'Please enter valid draft quantity.');
                component.set('v.loaded', false);               
            }
        });
        $A.enqueueAction(action);    
    },
    
    filterRecordUpdated : function(component){
        component.set("v.PaginationList", []);
        var pageSize = component.get("v.pageSize");  
        var sObjectList = component.get("v.datList");
        console.log('sObjectList',sObjectList);
        var material = component.find("selectMaterial").get("v.value");
        if(material){
            material = material.toUpperCase();
        }
        var product = component.find("selectProduct").get("v.value"); 
        if(product){
            product = product.toUpperCase();
        }
        //Added Brand Filter by GRZ(Nikhil Verma) RITM0478313 03-01-2023-->
        var brand = component.find("selectBrand").get("v.value"); 
        if(brand){
            brand = brand.toUpperCase();
        }        
        var query = {} ;
        if(material){
            query.cat = material;
        }
        if(product){
            query.SkuName = product;
        }
        //Added Brand Filter by GRZ(Nikhil Verma) RITM0478313 03-01-2023-->
        if(brand){
            query.brnd = brand;
        }
        console.log('query'+JSON.stringify(query));
        var filteredData = sObjectList.filter( (item) => {
            for (let key in query) {
                if (item[key] === undefined || !item[key].toUpperCase().includes(query[key])) {
                    return false;
                }
            }
            return true;
        });
        console.log('filteredData',filteredData);
        component.set("v.filterdata",filteredData);
        component.set('v.FilterList', filteredData);
        if(component.get("v.filterdata").length>0){
            var sObjectList = component.get("v.filterdata");
            var pageSize = component.get("v.pageSize");
            console.log(component.get("v.filterdata").length);
            component.set("v.totalRecords", component.get("v.filterdata").length);
            component.set("v.startPage",0);
            component.set("v.PageNumber",1);
            component.set("v.endPage",pageSize-1);
            component.set("v.TotalPages", Math.ceil(component.get("v.totalRecords") / pageSize));
            var PaginationList = [];
            for(var i=0; i< pageSize; i++){
                if(component.get("v.filterdata").length> i)
                    PaginationList.push(sObjectList[i]);
                component.set("v.PaginationList", PaginationList);
            }
        } 
        else{
            component.set("v.PaginationList", []);
            component.set("v.PageNumber",1); 
            component.set("v.TotalPages", 1);
        }
    },

    genericToast: function (title, type, msg) {
        var toastEvent = $A.get("e.force:showToast");
        if (toastEvent != undefined) {
            toastEvent.setParams({
                title: title,
                type: type,
                duration: '3000',
                message: msg
            });
            toastEvent.fire();
        }
        else {
            alert(title + ': ' + msg);
        }
    },
})