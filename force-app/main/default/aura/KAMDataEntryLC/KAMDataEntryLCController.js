({
    doInit : function(component, event, helper) {
        helper.uplSetting(component);
        helper.getMarketingYear(component);
        helper.getDivision(component); 
    },

    changeDivision:function(component, event, helper) {
        component.set("v.custDiv",component.find('div').get('v.value'));
        if(component.get("v.custDiv") != undefined){       
            helper.checkSubmit(component);
            helper.retreiveWrapper(component);
        }else{
            component.set("v.diableDownload",true);
            component.set("v.diableClone",true);
            component.set("v.diableEmail",true);
            component.set('v.PaginationList', []);
            component.set('v.draftTotal', null);
            component.set('v.valTotal', null);
            component.set('v.invTotal', null);
            component.set('v.ediTotal', null);
            helper.checkSubmit(component);
        }
    },

    changeMarketYear:function(component, event, helper) {
        component.set("v.mktYear",component.find('select').get('v.value'));
        if(component.get("v.mktYear") == 'first'){
            component.set("v.yearEditAccess",true);
            component.set("v.prevYear",component.get("v.firstYear")-1);
            component.set("v.currentYear",component.get("v.firstYear"));
        }
        if(component.get("v.mktYear") == 'second'){
            component.set("v.yearEditAccess",false);
            component.set("v.prevYear",component.get("v.secondYear")-1);
            component.set("v.currentYear",component.get("v.secondYear"));
        }
        helper.checkSubmit(component);
        helper.retreiveWrapper(component);
    },
    
    showhistoryOnly:function(component, event, helper){
        var selectedHeaderCheck = component.get("v.showHistOnly");
        if(selectedHeaderCheck == true){
            component.set("v.showHistOnly",false);
        }else{
            component.set("v.showHistOnly",true);
        }
        helper.checkSubmit(component);
        helper.retreiveWrapper(component);
    },
    
    //Created By: GUNNAGYA for Ticket no.: RITM0266323 
    handleProductCheck:function(component,event,helper){
        var tempVal = event.target.checked;
        var count = 0;
        var sObjectList = component.get("v.datList");
        var sObjectList1 = component.get("v.PaginationList");
        for (var i = 0;i <sObjectList.length; i++) {
            sObjectList[i].disabledItem = false;
            if(sObjectList[i].sid == event.target.name) {
                sObjectList[i].isProductChecked = tempVal;  
                if(tempVal==false)sObjectList[i].dQty=0;
            }
            if(sObjectList[i].dQty==null || sObjectList[i].dQty == 0){
                sObjectList[i].isProductChecked == false;
            }
            if (sObjectList[i].isProductChecked == true) {
                count = count + 1;
            } 
            if (sObjectList[i].isProductChecked == false){
                sObjectList[i].dQty = 0.00; 
                sObjectList[i].dAmt = 0; 
            }
            component.set("v.count", count);
        } 
        var Changelst=component.get('v.ChangeList');        
        for (var i = 0;i <sObjectList.length; i++) {
            for (var y = 0;y <sObjectList1.length; y++) {
                if(sObjectList[i].sid==sObjectList1[y].sid){
                    sObjectList1[y].isProductChecked = sObjectList[i].isProductChecked;
                    sObjectList1[y].disabledItem = sObjectList[i].disabledItem;
                }
            }
            if(!Changelst.includes(sObjectList[i])){
                Changelst.push(sObjectList[i]);
                component.set('v.ChangeList', Changelst);
            } 
        }
        for (var i = 0;i <sObjectList.length; i++) {
            var staticLabel = $A.get("$Label.c.Limit_to_select_Products_in_Draft_Plan");
            if(count >= staticLabel){
                if(sObjectList[i].isProductChecked ==true){
                    sObjectList[i].disabledItem = false;
                }
                else{
                    sObjectList[i].disabledItem = true;            
                } 
            }
            else {
                sObjectList[i].disabledItem = false;
            }
        }
        component.set("v.datList",sObjectList);
        component.set("v.PaginationList",sObjectList1);
        component.set("v.ChangeList",sObjectList);
    },
    
    openModel: function(component, event, helper) {
        component.set("v.isModalOpen", true);
    },
    
    closeCloneScreen: function(component, event, helper) {
        component.set("v.showCloneScreen", false);
    },
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    
    submitDetails: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    
    handleSetPayoutEvent: function(component, event, helper){
        var type = component.get("v.aggregatePayoutType");        
        var payoutTemp = event.getParam("payout");
        var sObjectList = component.get("v.datList");
        for (var i = 0; i <sObjectList.length; i++){
            if(sObjectList[i].dQty!=null && sObjectList[i].isProductChecked == true){
                sObjectList[i].dfpayList = payoutTemp;
                sObjectList[i].reasonCode = payoutTemp[0].reason;
                sObjectList[i].payType = type;
            }
        }
        component.set('v.CheckedList', sObjectList);
        component.set('v.datList', sObjectList);
        component.set('v.ChangeList', sObjectList);
        component.set('v.datList', sObjectList);
        component.set("v.isModalOpen", false);
    },
    //End Change by GUNNAGYA
    
    Save : function(component, event, helper) {
        component.set('v.loaded', true);
        helper.NavSave(component, event, helper);
    },
    ApplyChangesWrapper:function(component, event, helper) {
        var index = event.getParam("indexVar");
        var payoutList = event.getParam("payList");
        var deletedList = event.getParam("toDelList");
        var pagination = component.get("v.PaginationList");
        pagination[index].dfpayList = payoutList;
        var Changelst = component.get('v.ChangeList');
        if(!Changelst.includes(pagination[index])){
            Changelst.push(pagination[index]);
            component.set('v.ChangeList', Changelst);
        }
        component.set("v.PaginationList",pagination);
        component.set("v.PayDeleteList",deletedList);
    },

    Cancel:function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },

    Submit:function(component, event, helper) {
        component.set('v.loaded', true);
        var action = component.get("c.submitApproval");
        action.setParams({
            "dhId":component.get("v.dHeader")
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var res = response.getReturnValue();
                console.log("Submit ==>", res);
                if(res == 'Pending'){
                    helper.genericToast('Success:', 'Success', 'Submitted for Approval.'); 
                    component.set('v.loaded', false);  
                    helper.checkSubmit(component);
                    helper.retreiveWrapper(component);
                }
                else {
                    helper.genericToast('Error:', 'error', 'No Applicable Process found or Manager not defined.'); 
                    component.set('v.loaded', false);
                }
            }
        });
        $A.enqueueAction(action);        
    },

    onMaterialChange: function(component, event, helper) {
        helper.filterRecordUpdated(component);    
    },

    onProductChange: function(component, event, helper) {
        helper.filterRecordUpdated(component);
    },
    //Added Brand Filter by GRZ(Nikhil Verma) RITM0478313 03-01-2023-->
    onBrandChange: function(component, event, helper) {
        helper.filterRecordUpdated(component);
    },

    //function created to handle the screen flow and set the value in the variable - v.optionSelected
    handleChange : function(component, event, helper) {
        component.set("v.OptionSelection",component.find('radioGrpLayoutPicklist').get('v.value'));
        if(component.get("v.OptionSelection") == '--Choose the screen flow--'){
            component.set("v.optionSelected", "null");
        }
        if(component.get("v.OptionSelection") == 'Individual Product Offer'){
            component.set("v.optionSelected", "true");
        }
        if(component.get("v.OptionSelection") == 'Portfolio product offer'){
            component.set("v.optionSelected", "false");
        }
    },
    
    CalcPct:function(component, event, helper) {
        var pagination = component.get("v.PaginationList");
        var rowIndex = event.getSource().get('v.label');
        var value = event.getSource().get('v.value');        
        var sObjectList = component.get("v.datList");
        const index = sObjectList.indexOf(pagination[rowIndex]);
        if(sObjectList[index].productPrice != null){
            sObjectList[index].dAmt = sObjectList[index].productPrice * value ;
        }
        if(sObjectList[index].iQty != null){
            sObjectList[index].dPct = (value/sObjectList[index].iQty).toFixed(2);
            if(sObjectList[index].iAmt != null){
                sObjectList[index].dVal =(value*sObjectList[index].iAmt * sObjectList[index].dPct).toFixed(2);
            }
        }
        var tempList = [];
        for (var i = 0; i < sObjectList.length; i++){
            if(sObjectList[i].dQty != null && sObjectList[i].isProductChecked == true){
                component.set("v.isModalActive",true);
                tempList.push(sObjectList[i]);
            }
        }
        component.set("v.aggrDValue",tempList);
        var sum;
        component.set("v.draftTotal", 0.0);
        for (var i = 0, sum = 0; i < sObjectList.length; i++) {
            if(sObjectList[i].dAmt != null){
                sum += sObjectList[i].dAmt;
            }   
        }
        component.set("v.draftTotal",sum);
        component.set("v.PaginationList",pagination);
        var Changelst = component.get('v.ChangeList');
        if(!Changelst.includes(sObjectList[index])){
            Changelst.push(sObjectList[index]);
            component.set('v.ChangeList', Changelst);
        }
        if(!$A.util.isUndefinedOrNull(pagination[rowIndex].dfpayList)){
            for(var j=0;j<pagination[rowIndex].dfpayList.length;j++){
                if(pagination[rowIndex].dfpayList[j].threshold!=0){
                    pagination[rowIndex].dfpayList[j].quantity=(pagination[rowIndex].dfpayList[j].threshold/pagination[rowIndex].dQty).toFixed(2);
                }
            }
        }
    },

    CalcDfQty:function(component, event, helper) {
        var pagination = component.get("v.PaginationList");
        var rowIndex = event.getSource().get('v.label');
        var sObjectList = component.get("v.datList");
        console.log("pagination[rowIndex].dfpayList)>>",pagination[rowIndex].dfpayList);
        if(!$A.util.isUndefinedOrNull(pagination[rowIndex].dfpayList)){
            for(var j=0;j<pagination[rowIndex].dfpayList.length;j++){
                if(pagination[rowIndex].dfpayList[j].threshold!=0){
                    pagination[rowIndex].dfpayList[j].quantity=(pagination[rowIndex].dfpayList[j].threshold/pagination[rowIndex].dQty).toFixed(2);
                }
            }
        }
        const index = sObjectList.indexOf(pagination[rowIndex]);
        if(sObjectList[index].iQty!=null){
            sObjectList[index].dQty =sObjectList[index].dPct*sObjectList[index].iQty ;
            sObjectList[index].dAmt =sObjectList[index].productPrice*sObjectList[index].dQty ;
            if(sObjectList[index].iAmt!=null){
                sObjectList[index].dVal =(sObjectList[index].dQty*sObjectList[index].iAmt*sObjectList[index].dPct).toFixed(2);
            }
        }
        component.set("v.draftTotal",0.0);
        var sum;
        for (var i = 0,sum = 0; i <sObjectList.length; i++) {
            if(sObjectList[i].dAmt!=null && sObjectList[i].isProductChecked == true)
                sum +=sObjectList[i].dAmt ;
        } 
        component.set("v.draftTotal",sum);
        component.set("v.PaginationList",pagination);
        var Changelst=component.get('v.ChangeList');
        if(!Changelst.includes(sObjectList[index])){
            Changelst.push(sObjectList[index]);
            component.set('v.ChangeList', Changelst);
        }
    },
    handleNext: function(component, event, helper) {
        var cLis=component.get('v.ChangeList');
        if(cLis.length>0){
            helper.NavSave(component, event, helper);
        }
        if(component.get("v.FilterList").length>0)
            var sObjectList = component.get("v.FilterList");
        else
            var sObjectList = component.get("v.datList");
        for(var i=0;i<sObjectList.length;i++){
            sObjectList[i].expanded=false;
        }
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        for(var i=end+1; i<end+pageSize+1; i++){
            if(sObjectList.length > i){
                Paginationlist.push(sObjectList[i]);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        component.set("v.ChangeList",[]);
        component.set("v.PageNumber",component.get("v.PageNumber")+1);
    },
    handlePrev: function(component, event, helper) {
        var cLis=component.get('v.ChangeList');
        if(cLis.length>0){
            helper.NavSave(component, event, helper);
        }
        if(component.get("v.FilterList").length>0)
            var sObjectList = component.get("v.FilterList");
        else
            var sObjectList = component.get("v.datList");
        for(var i=0;i<sObjectList.length;i++){
            sObjectList[i].expanded=false;
        }
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                Paginationlist.push(sObjectList[i]);
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        component.set("v.ChangeList",[]);
        component.set("v.PageNumber",component.get("v.PageNumber")-1);
    },
    handleClick : function(component, event, helper) {
        var target = event.target;
        var dataEle = target.getAttribute("data-Index");
        var pagination = component.get("v.PaginationList");
        if(pagination[dataEle].expanded){
            pagination[dataEle].expanded=false;
        }
        else{
            pagination[dataEle].expanded=true;
        }
        component.set('v.PaginationList', pagination);
    },
    applyPct : function(component, event, helper) {
        var pct = component.get("v.commonPct");
        var pagination = component.get("v.PaginationList");
        if(component.get("v.FilterList").length>0)
            var sObjectList = component.get("v.FilterList");
        else
            var sObjectList = component.get("v.datList");
        component.set("v.draftTotal",0.0);
        var sum;
        var Changelst=component.get('v.ChangeList');
        for (var i = 0,sum = 0; i <pagination.length; i++) {
            const index = sObjectList.indexOf(pagination[i]);
            sObjectList[index].dPct=pct;
            if(sObjectList[index].iQty!=null){
                sObjectList[index].dQty =sObjectList[index].dPct*sObjectList[index].iQty ;
                var aggDqty = sObjectList[index].dQty;
                console.log("aggDqty>>",aggDqty);
                sObjectList[index].dAmt =sObjectList[index].productPrice*sObjectList[index].dQty ;
                if(sObjectList[index].iAmt!=null){
                    sObjectList[index].dVal =(sObjectList[index].dQty*sObjectList[index].iAmt*sObjectList[index].dPct).toFixed(2);
                }
            }
            else{
                sObjectList[index].dAmt=null;
            }
            sum += sObjectList[index].dAmt ;
            pagination[i].dPct=pct;
            if(pagination[i].iQty!=null){
                pagination[i].dQty =pagination[i].dPct*pagination[i].iQty ;
                pagination[i].dAmt =pagination[i].productPrice*pagination[i].dQty ;
                if(pagination[i].iAmt!=null){
                    pagination[i].dVal =(pagination[i].dQty*pagination[i].iAmt*pagination[i].dPct).toFixed(2);
                }
            }
            else{
                pagination[i].dAmt=null;
            }
            if(!$A.util.isUndefinedOrNull(pagination[i].dfpayList)){
                for(var j=0;j<pagination[i].dfpayList.length;j++){
                    if(pagination[i].dfpayList[j].threshold!=0){
                        pagination[i].dfpayList[j].quantity=(pagination[i].dfpayList[j].threshold/pagination[i].dQty).toFixed(2);
                    }
                }
            }
            if(!Changelst.includes(sObjectList[index])){
                Changelst.push(sObjectList[index]);
                component.set('v.ChangeList', Changelst);
            }
        } 
        component.set("v.PaginationList",pagination);
        component.set("v.draftTotal",sum);
        component.set("v.commonPct",'');
    },
    downloadPDF : function(component, event, helper) {
        window.open("/apex/DraftPlanPDF?id=" + component.get("v.recordId") + "&custDiv=" +component.get("v.custDiv"), '_blank');
    },
    sendEmail : function(component, event, helper) {
        component.set('v.loaded', true);
        var action = component.get("c.sendEmailMsg");
        action.setParams({
            "url" : "/apex/DraftPlanPDF?id=" + component.get("v.recordId") + "&custDiv=" +component.get("v.custDiv"), 
            "fileName" : "Draft Plan",
            "accName": component.get("v.AccountName"),
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var res = response.getReturnValue();
                if(res){
                    helper.genericToast('', 'success', 'Email Sent Successfully.');
                    component.set("v.diableEmail",true);
                    component.set('v.loaded', false);
                }
                else {
                    helper.genericToast('Error:', 'error', 'Contact System Administrator.');
                    component.set('v.loaded', false);
                }
            }else{
                helper.genericToast('Error:', 'error', 'Contact System Administrator.'); 
                component.set('v.loaded', false);
            }
        });
        $A.enqueueAction(action);
    },

    // Draft Plan Clone RITM0560054 GRZ(Nikhil Verma) 24-05-2023-->
    handleDraftClick : function(component, event, helper) {
        var draftId = event.target.getAttribute("title");
        var accName = event.target.getAttribute("data-id");
        if (confirm("Are you sure you want to clone draft plan for current account as " + accName + " ?") == true) {
            component.set('v.loaded', true);
            var action = component.get("c.createCloneDraftPlan");
            action.setParams({
                "accountId": component.get("v.recordId"),
                "cloneDraftId": draftId,
            });
            action.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    var res = response.getReturnValue();
                    if(res.success){
                        console.log('res==>',res);
                        component.set('v.showCloneScreen', false);
                        helper.checkSubmit(component);
                        helper.retreiveWrapper(component);
                    }else {
                        helper.genericToast('Error:', 'error', 'Contact System Administrator.');
                        console.log('Error==>',res.message);
                        component.set('v.loaded', false);
                    }
                }else{
                    helper.genericToast('Error:', 'error', 'Contact System Administrator.'); 
                    component.set('v.loaded', false);
                }
            });
            $A.enqueueAction(action);
        }
    },
    handleClone : function(component, event, helper) {
        component.set('v.loaded', true);
        var action = component.get("c.fetchExistingDraftPlan");
        action.setParams({
            "accountId": component.get("v.recordId"),
            "mktYear": component.get("v.mktYear"),
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var res = response.getReturnValue();
                if(res.success){
                    console.log('res==>',res);
                    component.set('v.DraftCloneRedords', res.data);
                    console.log('res==>',component.get('v.DraftCloneRedords'));
                    component.set('v.loaded', false);
                    component.set('v.showCloneScreen', true);
                }
                else {
                    helper.genericToast('Error:', 'error', res.message);
                    component.set('v.loaded', false);
                }
            }else{
                helper.genericToast('Error:', 'error', 'Contact System Administrator.'); 
                component.set('v.loaded', false);
            }
        });
        $A.enqueueAction(action);
    },
})