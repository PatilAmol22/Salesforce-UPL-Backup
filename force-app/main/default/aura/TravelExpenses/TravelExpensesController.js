({
    //Note : Used "MTE" for Monthly Travel Expense 
    
    doInit: function(component, event, helper) {
        
        var it_date = component.find('date');
        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth()+1; //January is 0!
        var yyyy = today.getFullYear();
        
        if(dd<10) {
            dd = '0'+dd
        }
        if(mm<10) {
            mm = '0'+mm
        }
        today = dd + '/' + mm + '/' + yyyy;
        var default_date= dd + '-' + mm + '-' + yyyy;
        //console.log('default_date :- '+default_date);
        //it_date.set("v.value",default_date);
        var page = component.get("v.page") || 1; 
        var recordToDisply = component.find("recordSize").get("v.value"); 
        
        helper.fetchPickListMonthData(component);
        helper.fetchPickListYearData(component);
        helper.fetchActivities(component, page, recordToDisply, component.get('v.selectedTabsoft'), component.get("v.isAsc"),''); 
        helper.fetchProfile(component);
        
        
    },
    
    // blur method for negative to positive amount
    onChange: function(component, event, helper){
        
        var amnt_number = component.find('amount');
        var amnt_value = amnt_number.get("v.value");
        console.log('valuer  :- '+amnt_value)
        if(amnt_value < 0){
            console.log('valuer  :- '+amnt_value)
			 helper.showToast("Error","error","Negative values not allowed");
        }
        var amnt= Math.abs(amnt_value);
        
        component.set("v.travelexpense.Amount__c",amnt);
        
        
    },
    onSelectChange: function(component, event, helper) {  
        var target = event.getSource();  
        var searchText = component.find('mtdOptions').get("v.value");
        var value = target.get("v.value");
        
       // console.log('searchText : '+searchText);
        if (value=='None' && !searchText) { 
            var action = component.get("c.doInit");
            $A.enqueueAction(action);
        }
        else{
            var page = 1  
            var recordToDisply = component.find("recordSize").get("v.value"); 
            var splitValues = value.split(" ");
            var month = splitValues[0];
            var year = splitValues[1];
            
            var whereClause='';
            if(searchText){
                
                var numString = parseInt(searchText.trim());
                if(Number.isNaN(numString)){
                    whereClause="WHERE (Month__c LIKE '%"+searchText.trim()+"')";
                    helper.fetchActivities(component, page, recordToDisply,component.get('v.selectedTabsoft'), component.get("v.isAsc"), whereClause);
                }
                else{
                    whereClause="WHERE (Month__c = "+parseInt(searchText.trim())+" OR TotalAmount__c = "+parseInt(searchText.trim())+")";
                    helper.fetchActivities(component, page, recordToDisply,component.get('v.selectedTabsoft'), component.get("v.isAsc"), whereClause);
                }
            }else{
                var numString = parseInt(searchText);
                if(Number.isNaN(numString)){
                    whereClause="WHERE (Month__c LIKE '%"+searchText+"')";
                    helper.fetchActivities(component, page, recordToDisply,component.get('v.selectedTabsoft'), component.get("v.isAsc"), whereClause);
                }
                else{
                    whereClause="WHERE (Month__c = "+parseInt(searchText)+" OR TotalAmount__c = "+parseInt(searchText)+")";
                    helper.fetchActivities(component, page, recordToDisply,component.get('v.selectedTabsoft'), component.get("v.isAsc"), whereClause);
                }
            }
        }
    },
    onSelectYearChange: function(component, event, helper) {  
        var target = event.getSource();  
        var searchText = component.find('yrOptions').get("v.value");
        var yearText= searchText.split(" ");
        //  console.log('searchText : '+searchText);
        var value = target.get("v.value");
        if (value=='None' && !searchText) { 
            var action = component.get("c.doInit");
            $A.enqueueAction(action);
        }
        else{
            var page = 1  
            var recordToDisply = component.find("recordSize").get("v.value"); 
            var splitValues = value.split(" ");
            var month = splitValues[0];
            var year = splitValues[1];
            

            var whereClause='';
            if(searchText){
                var numString = parseInt(searchText.trim());
                if(Number.isNaN(numString)){
                    whereClause="WHERE (Month__c = '%"+searchText.trim()+"')";
                    helper.fetchActivities(component, page, recordToDisply,component.get('v.selectedTabsoft'), component.get("v.isAsc"), whereClause);
                }
                else{
                   // whereClause="WHERE (Month__c includes ('"+parseInt(searchText.trim())+"'))";
                    whereClause="WHERE (Month__c LIKE '%"+parseInt(searchText.trim())+"%')";
                    helper.fetchActivities(component, page, recordToDisply,component.get('v.selectedTabsoft'), component.get("v.isAsc"), whereClause);
                }
            }else{
                var numString = parseInt(searchText);
                if(Number.isNaN(numString)){
                    whereClause="WHERE (Month__c LIKE '%"+searchText+"')";
                    helper.fetchActivities(component, page, recordToDisply,component.get('v.selectedTabsoft'), component.get("v.isAsc"), whereClause);
                }
                else{
                    whereClause="WHERE (Month__c = "+parseInt(searchText)+" OR TotalAmount__c = "+parseInt(searchText)+")";
                    helper.fetchActivities(component, page, recordToDisply,component.get('v.selectedTabsoft'), component.get("v.isAsc"), whereClause);
                }
            }
        }
    },
    search: function(component, event, helper) {  
        var target = event.getSource();  
        var searchText = target.get("v.value");
        var last_SearchText = component.get("v.last_SearchText");
        if (event.keyCode == 27 || !searchText) { 
            var action = component.get("c.doInit");
            $A.enqueueAction(action);
        }
        else if(searchText != last_SearchText  && /\s+$/.test(searchText) ){
            //Save server call, if last text not changed
            //Search only when space character entered
            
            var page = 1;  
            var recordToDisply = component.find("recordSize").get("v.value");
            var value = component.get("v.mtd");
            var whereClause=""; //"WHERE calendar_month(CreatedDate) = "+parseInt(month.trim())+" AND calendar_year(CreatedDate) = "+parseInt(year.trim());    
            var numString = parseInt(searchText);
           if(Number.isNaN(numString)){
                whereClause="WHERE (Month__c LIKE '%"+searchText.trim()+"%')";
            }else{
                whereClause="WHERE (TotalAmount__c = "+parseInt(searchText.trim())+")";
            }
                        
            helper.fetchActivities(component, page, recordToDisply,component.get('v.selectedTabsoft'), component.get("v.isAsc"), whereClause);
        }
    },
    
    previousPage: function(component, event, helper) {  
        var recordToDisply = component.find("recordSize").get("v.value"); 
        component.set("v.page", component.get("v.page") - 1);  
        helper.fetchActivities(component, component.get("v.page"), recordToDisply,component.get('v.selectedTabsoft'), component.get("v.isAsc"),'');          
       }, 
    
    gotoFirstPage : function(component, event, helper) {  
        component.set("v.page",1);  
        var recordToDisply = component.find("recordSize").get("v.value");  
        helper.fetchActivities(component, 1, recordToDisply,component.get('v.selectedTabsoft'), component.get("v.isAsc"),'');  
       },  
    
    gotoLastPage : function(component, event, helper) {  
        component.set("v.page",component.get("v.pages"));  
        var recordToDisply = component.find("recordSize").get("v.value");  
        helper.fetchActivities(component, component.get("v.pages"), recordToDisply,component.get('v.selectedTabsoft'), component.get("v.isAsc"),'');  
      },  
    
    nextPage: function(component, event, helper) {  
        var recordToDisply = component.find("recordSize").get("v.value");
        component.set("v.page", component.get("v.page") + 1);  
        helper.fetchActivities(component, component.get("v.page"), recordToDisply,component.get('v.selectedTabsoft'), component.get("v.isAsc"),'');  
       },  
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);

        //component.set("v.travelexpense.Amount__c", "");
        /*component.set("v.TravelExpensesList", {'sobjectType': 'Expense_Item__c',
                                         'Date__c': '',
                                         'Item__c': '',
                                         'Amount__c': '',
                                         'Purpose__c': '',
                                         'Location__c':'',
                                         'Month__c':''});*/
        helper.fetchPickListData(component);
        helper.applyCSS(component);
    },
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
        component.set("v.travelexpense",{'sobjectType': 'Expense_Item__c',
                                         'Date__c': '',
                                         'Item__c': '',
                                         'Amount__c': '',
                                         'Purpose__c': '',
                                         'Location__c':'',
                                         'Month__c':''});
        /*component.set("v.TravelExpensesList", {'sobjectType': 'Expense_Item__c',
                                         'Date__c': '',
                                         'Item__c': '',
                                         'Amount__c': '',
                                         'Purpose__c': '',
                                         'Location__c':'',
                                         'Month__c':''});*/
        
        component.set("v.isExistingDayOpen",false);
        helper.revertCssChange(component);
        location.reload();
    },
    
    // MTE - Monthly Travel Expense
    // Open model 
    viewMTEModel: function(component, event, helper) {
        component.set("v.isOpenMonth", true);
        var mnt_yr =' ';
        var action = component.get("c.getPerMTExpense");
        var src = event.getSource();
        var mte_id = src.get("v.value"); 
        component.set("v.selectedMTE", mte_id);//UPL-2-I386: Modified by:Ankita Saxena Changes in Travel request  for Indonesia
        component.set("v.recordId",mte_id);
        
        var sum = 0;
        
        console.log('mte_id : ' + mte_id);
        action.setParams({
            "mte_id": mte_id
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
          //  console.log('action : ' + response.getState());
            if(response.getState()=="SUCCESS"){

                var JsnStr = JSON.stringify(response.getReturnValue());
                // console.log('response : ' + JsnStr);
                var obj = JSON.parse(JsnStr);
                for (var i = 0; i < obj.length; i++) {
                    
                    mnt_yr = obj[0]['Month__c'];
                //	console.log('Amount__c : '+obj[i]['Amount__c']);
                    
                   sum=sum+ + obj[i]['Amount__c'];
                    component.set("v.total_amount",sum);
                    
                    component.set("v.TravelExpenseDayList", response.getReturnValue());
                }
                component.set("v.month_header","Travel Expenses Report - "+mnt_yr);
            }
        });
        $A.enqueueAction(action);
        
    },
    // close model
    closeMTEModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpenMonth", false);
        helper.revertCssChange(component);
    },
    editMTERecord: function(component, event, helper) {
        component.set("v.isEditOpenMonth", true);
        var mnt_yr =' ';
        var action = component.get("c.getPerMTExpense");
        var src = event.getSource();
        var mte_id = src.get("v.value");
        var sum = 0; 
        
        action.setParams({
            "mte_id": mte_id
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
          //  console.log('action : ' + response.getState());
            if(response.getState()=="SUCCESS"){

                var JsnStr = JSON.stringify(response.getReturnValue());
                var obj = JSON.parse(JsnStr);
                for (var i = 0; i < obj.length; i++) {
              //      console.log(obj[i]['Month__c']);
                    mnt_yr = obj[0]['Month__c'];

                    
                    sum=sum+ + obj[i]['Amount__c'];
                    component.set("v.total_amount",sum);
                }
                component.set("v.month_header","Travel Expenses Report - "+mnt_yr);
                component.set('v.TravelExpenseDayListEdit',response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    // close model
    closeEditMTEModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isEditOpenMonth", false);
        helper.revertCssChange(component);
    }, 
    
    clickError: function(component, event, helper) {
        location.reload();
    },
    
    
    openDeleteModel: function(component, event, helper) {
        
        var target = event.getSource();  
        var recordId = target.get("v.value");
        
        component.set("v.recordId", recordId);
        component.set("v.isOpenDelete",true);
        component.set("v.delete_header","Delete Record");
        helper.revertCssChange(component);
    },
    
    closeDeleteModel: function(component, event, helper) {
        component.set("v.isOpenDelete", false);
        helper.revertCssChange(component);
    },
    openDeleteDayModel : function(component, event, helper) {
       
        var target = event.getSource();  
        var recordId = target.get("v.value");
        
        component.set("v.recordId", recordId);
        component.set("v.isEditOpenMonth", false);
        component.set("v.isOpenDeleteDay",true);
        component.set("v.delete_header","Delete Record");
        helper.revertCssChange(component);
    },
    closeDeleteDayModel: function(component, event, helper) {
        
        //component.set("v.isOpenDelete", false);
        component.set("v.isOpenDeleteDay", false);
        helper.revertCssChange(component);
    },
    
    likenClose: function(component, event, helper) {
        // Display alert message on the click on the "Like and Close" button from Model Footer 
        // and set set the "isOpen" attribute to "False for close the model Box.
        
        component.set("v.isOpen", false);
    },
    
    onDateChange: function(component, event, helper) {
        
    },
    
    onPicklistChange: function(component, event, helper) {
        
        //alert(event.getSource().get("v.value"));
        
    },
    onAdd: function(component, event, helper) {
        
        var sum=0;
        var isValid = true;
        var it_items=component.find('items');
        var it_date=component.find('dateId');
        var it_amount=component.find('amount');
        var it_purpose=component.find('purpose');
        var it_location=component.find('location');
        var it_remark=component.find('remark');
        var it_lineitemamount=component.find('lineitemamount');
        var ot_totalAllocation=component.find('totalAllocation');
        //var it_month=component.find('month');
        var selectedDate = it_date.get("v.value");
        var selectD=selectedDate.split("-");
       // console.log(' mnth :- '+selectD[0]);
        if(selectD[1]=="01"){
            component.set("v.travelexpense.Month__c", "JAN "+selectD[0]);
        }
        if(selectD[1]=="02"){
            component.set("v.travelexpense.Month__c", "FEB "+selectD[0]);
        }
        if(selectD[1]=="03"){
            component.set("v.travelexpense.Month__c", "MAR "+selectD[0]);
        }
        if(selectD[1]=="04"){
            component.set("v.travelexpense.Month__c", "APR "+selectD[0]);
        }
        if(selectD[1]=="05"){
            component.set("v.travelexpense.Month__c", "MAY "+selectD[0]);
        }
        if(selectD[1]=="06"){
            component.set("v.travelexpense.Month__c", "JUN "+selectD[0]);
        }
        if(selectD[1]=="07"){
            component.set("v.travelexpense.Month__c", "JUL "+selectD[0]);
        }
        if(selectD[1]=="08"){
            component.set("v.travelexpense.Month__c", "AUG "+selectD[0]);
        }
        if(selectD[1]=="09"){
            component.set("v.travelexpense.Month__c", "SEP "+selectD[0]);
        }
        
        if(selectD[1]=="10"){
            component.set("v.travelexpense.Month__c", "OCT "+selectD[0]);
        }
        
        if(selectD[1]=="11"){
            component.set("v.travelexpense.Month__c", "NOV "+selectD[0]);
        }
        
        if(selectD[1]=="12"){
            component.set("v.travelexpense.Month__c", "DEC "+selectD[0]);
        }
        
      //  console.log('selectedDate :- '+selectedDate);
        //alert(selectedDate);
        // Current Date logic
        /* var Today = new Date();
        var dd = (Today.getDate() < 10 ? '0' : '') + Today.getDate();
        var MM = ((Today.getMonth() + 1) < 10 ? '0' : '') + (Today.getMonth() + 1);
        var yyyy = Today.getFullYear();
        var formattedDate = (yyyy + "-" + MM + "-" + dd);
        
        if(selectedDate <= formattedDate){}
        
        */
        
       // console.log('amount :- '+it_amount.get("v.value"));
        var amnt_=it_amount.get("v.value");
        var amnt_postive1= it_amount.get("v.value");
        var amnt_postive=Math.abs(amnt_postive1);
      //  console.log(' amnt_postive :- '+amnt_postive);
         it_amount.set("v.value", amnt_postive);
         /* if(it_items.get("v.value") == ''){
            it_items.set("v.errors",[{message:"please select the item"}]);
            isValid=false;
            }else {
                // Validation from current date 
             /*   var evt = $A.get("e.c:setDateEvt");
                evt.setParams({ "stringDate":selectedDate });
                evt.fire();
                */
            
        if(it_date.get("v.value") == ''){
            it_date.set("v.errors",[{message:"Please select the date"}]);
            isValid=false;
        }else{
            it_date.set("v.errors",null);
            if(it_items.get("v.value") == ''){
                it_items.set("v.errors",[{message:"please select the item"}]);
                isValid=false;
            }
            else{
                it_items.set("v.errors",null);
                if(it_amount.get("v.value") == '' ){  //(isNaN(it_amount.get("v.value")))
                    it_amount.set("v.errors",[{message:"enter the amount number"}]);
                    isValid = false;
                }
                else{
                    it_amount.set("v.errors",null);
                    if(it_purpose.get("v.value") == '' ){
                        it_purpose.set("v.errors",[{message:"enter the purpose"}]);
                        isValid=false;
                    }
                    else{
                        it_purpose.set("v.errors",null);
                        if(it_location.get("v.value") == '' ){
                            it_location.set("v.errors",[{message:"enter the location address"}]);
                            isValid=false;
                        }
                        else {
                            it_location.set("v.errors",null);
                            console.log('Error  :- '+it_remark.get("v.value"));
                            if(it_remark.get("v.value") == '' ){
                                console.log('enter the remark');
                                it_remark.set("v.errors",[{message:"enter the remark"}]);
                                isValid=false;
                            }
                            else {
                                it_remark.set("v.errors",null);            
                                var new_item1 = component.get("v.travelexpense");
                                // console.log(' new_item1 :-'+JSON.stringify(new_item1));
                                helper.addTravelExpenseItems(component,new_item1);      
                            }}}}}}
            
        
        //var JSONObject = JSON.parse(new_item);
        // var amnt= JSONObject["Amount__c"];
        //  console.log('amount number :- '+it_lineitemamount.get("v.value"));
        //   console.log(new_item);
        
        /* var amnt_new = +amnt;
         sum =sum + amnt_new;
        console.log(sum);
        */
        
        
    },
    
    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        var afterminusTotamount = 0;
        var index = event.getParam("indexVar");
        var allRowsList = component.get("v.TravelExpensesList");
        var totAmount = 0;
        
        totAmount = component.get("v.totAmount");
        for(var k = 0 ;k< allRowsList.length;k++){
            if(k==index){
                //alert('Amount----->'+allRowsList[k].Amount__c);
                afterminusTotamount = totAmount - allRowsList[k].Amount__c;
            }
        }
        component.find('totalAmount').set("v.value",afterminusTotamount); 
        allRowsList.splice(index, 1);
        component.set("v.TravelExpensesList", allRowsList);
        
    },
    
    
    // Edit Record of day
    editPerMTERecord : function(component, event, helper) {
                var mnt_yr =' ';
        var bill_no =' ';
        helper.fetchPickListData(component);
        component.set("v.isEditOpenMonth",false);
        component.set("v.isExistingDayOpen",true);
        
        // component.set("v.day_header","Activity Record #"+mte_id);
        
        
        var action = component.get("c.getExistPerMTExpense");
        var src = event.getSource();
        var mte_id = src.get("v.value");
        action.setParams({
            "mte_id": mte_id
        });
		action.setCallback(this, function(response) {
            var state = response.getState();
            //('action : ' + response.getState());
            if(response.getState()=="SUCCESS"){
                // console.log('return data :- '+JSON.stringify(response.getReturnValue()));
                // console.log('response :- '+response.getReturnValue());
                //patch
                var JSONdata = JSON.stringify(response.getReturnValue());
                var expnsObj = JSON.parse(JSONdata);
                
                for (var i = 0; i < expnsObj.length; i++) {
                    // console.log(expnsObj[i]['Month__c']);
                    mnt_yr = expnsObj[0]['Month__c'];
                    bill_no = expnsObj[i]['Name'];
                    //console.log('mnt_yr : '+bill_no);
                    component.set("v.day_header","Travel Expenses Report - "+ mnt_yr +"- Bill No. "+bill_no);
                }
                
                
                component.set("v.travelexpense",expnsObj[0]);
                //end patch
            }
        });
        $A.enqueueAction(action);

        
    },
    
    
    saveAndClose : function(component, event, helper) {
        var action = component.get("c.saveTravelExpense");       
        var eiObj = component.get("v.TravelExpensesList");
        
        if(JSON.stringify(eiObj)!='[]'){
           console.log('eiObj :- '+JSON.stringify(eiObj));
            action.setParams({
            "eiObj": eiObj 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
           // console.log('data save : ' + response.getState());
            
         
            if (state == "SUCCESS") {
              //  console.log('response  :- '+response.getReturnValue());
                helper.showToast("Success","success","Added successfully");
                location.reload();
            }else {
               
              // 	helper.showToast("Error","error","Travel expenses for this is already submitted for approval. Please RECALL approval process to add the records.");
            	component.set("v.isOpenError",true);
                //alert("Travel expenses for this is already submitted for approval. Please RECALL approval process to add the records.");
                //location.reload();
                
            }
        });
        $A.enqueueAction(action);  
        component.set("v.isOpen", false);
        }else{
           helper.showToast("Error Message","error","Please enter proper data");
        }
        
    },
    
    saveAndCloseExistDay : function(component, event, helper) {
        var action = component.get("c.updateTravelExpense");       
        var eiObj = component.get("v.travelexpense");
        var sum=0;
        var isValid = true;
        var it_items=component.find('items');
        var it_amount=component.find('amount');
        var it_purpose=component.find('purpose');
        var it_location=component.find('location');
        var it_remark=component.find('remark');
        
 
        if(it_items.get("v.value") == ''){
            it_items.set("v.errors",[{message:"please select the item"}]);
            isValid=false;
        }
        else{
            it_items.set("v.errors",null);
            if(it_amount.get("v.value") == '' ){  //(isNaN(it_amount.get("v.value")))
                it_amount.set("v.errors",[{message:"enter the amount number"}]);
                isValid = false;
            }
            else{
                it_amount.set("v.errors",null);
                if(it_purpose.get("v.value") == '' ){
                    console.log('purpose error  :- '+it_purpose.get("v.value"));
                    it_purpose.set("v.errors",[{message:"enter the purpose"}]);
                    isValid=false;
                }
                else{
                    it_purpose.set("v.errors",null);
                    if(it_location.get("v.value") == '' ){
                        console.log('location error  :- '+it_location.get("v.value"));
                        it_location.set("v.errors",[{message:"enter the location address"}]);
                        isValid=false;
                    }
                    else {
                        it_location.set("v.errors",null);
                        console.log('remark error  :- '+it_remark.get("v.value"));
                        if(it_remark.get("v.value") == '' ){
                            console.log('enter the remark');
                            it_remark.set("v.errors",[{message:"enter the remark"}]);
                            isValid=false;
                        }
                        else {
                            it_remark.set("v.errors",null);    
                            action.setParams({
                                "update_eiObj": eiObj 
                            });
                            action.setCallback(this, function(response) {
                                var state = response.getState();
                                //console.log('data save : ' + response.getState());
                                //console.log('return value : ' + response.getReturnValue());
                                if (state == "SUCCESS") {
                                    alert('Record Updated. Please click OK');
                                    helper.showToast("Success","success","Record updated successfully");
                                    location.reload();
                                }else {
                                    
                                    helper.showToast("Error","error","Travel expenses for this is already submitted for approval. Please RECALL approval process to edit the records.");
                                }
                            });
                            $A.enqueueAction(action);   
                        }}}}}
        
         
    },
    
    clickDelete : function(component, event, helper) {
        var recordId = component.get("v.recordId");
       // console.log('recordId :- '+recordId);
      	var mte_obj= component.get("v.TravelExpenseMonthList");
        //var src = event.getSource();
        //var rec_id = src.get("v.value");
        
        var action = component.get('c.deleteMTERecord');
        action.setParams({
            "mte_obj": mte_obj,
            "recordId": recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            //console.log('data save : ' + response.getState());
            //console.log('return value : ' + response.getReturnValue());
            if (state == "SUCCESS") {
                location.reload();
            }else {
                helper.showToast("Error","error","Cannot delete the records in pending state. Please RECALL approval process to delete the records.");
            }
        });
        $A.enqueueAction(action);
          
    },
    clickDeleteDay : function(component, event, helper) {
      
         //console.log('clicked :- '+component.get("v.indexVar"));
         //component.getEvent("RemoveEvent").setParams({"indexVar" : component.get("v.rowIndex")}).fire();
        
        var recordId = component.get("v.recordId");
        //('recordId :- '+recordId);
        var e_obj= component.get("v.TravelExpenseDayListEdit");
        //var src = event.getSource();
        //var rec_id = src.get("v.value");
        var action = component.get('c.deletePerMTERecord');
        action.setParams({
            "e_obj": e_obj,
            "recordId": recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            console.log('data save : ' + response.getState());
            console.log('return value : ' + response.getReturnValue());
            if (state == "SUCCESS") {
                location.reload();
            }else {
                
                helper.showToast("Error","error","Travel expenses for this is already submitted for approval. Please RECALL approval process to delete the records.");
            	
            }
        });
        $A.enqueueAction(action);   
          
    },
    /**
     * Handler for receiving the updateLookupIdEvent event
     */
    handleLookupIdUpdate : function(component, event, helper) {
        // Get the Id from the Event
        var accountId = event.getParam("sObjectId");
        
        // Set the Id bound to the View
        //component.set('v.recordId', accountId);
    },
    //To sort Expenses month wise
    //UPL-2-I386: Modified by:Ankita Saxena Changes in Travel request  for Indonesia
    sortMonth : function(component, event, helper) {  
        component.set("v.selectedTabsoft", 'Month');  
        helper.sortHelper(component, event, 'Month__c');  
    }, 
    sortCreatedBy : function(component, event, helper) {  
        component.set("v.selectedTabsoft", 'CreatedBy');  
        helper.sortHelper(component, event, 'CreatedBy.Name');  
    },
    viewSummary: function(component, event, helper) { 
        var urlEvent = $A.get("e.force:navigateToURL");
        var id = component.get("v.selectedMTE");
        urlEvent.setParams({
        "url": "/apex/Summary_Report?id="+id
        });
 
        urlEvent.fire();
    },
    
    
    
})