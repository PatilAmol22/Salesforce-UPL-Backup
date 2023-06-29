({
    init : function(component, event, helper) {
        //var searchKey = event.getParam("term");
        //var searchFeild = component.get("v.selectBy");
        //console.log('searchKey :'+searchKey);
        var action = component.get("c.getDistributors");
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state == 'SUCCESS') {                
                var acntList = response.getReturnValue();
                var options = [];
                acntList.forEach(function(acnt)  { 
                    console.log(acnt);
                    options.push({ value: acnt.Id, label: acnt.Name});
                });
                component.set("v.listOptions", options);
            } else {
                console.log('Failed with state: ' + state);
            }
        });
        
        $A.enqueueAction(action); 
	},
    
    handleChange: function (component, event) {
        // Get the list of the "value" attribute on all the selected options
        var selectedOptionsList = event.getParam("value");
        console.log('selectedOptionsList: ' + selectedOptionsList);
        component.set('v.selectedIds',selectedOptionsList);
        //alert("Options selected: '" + selectedOptionsList + "'");
    },
    
    handleSelectAll: function(component, event, helper) {
        var getID = component.get("v.distributorDetailList");
        var checkvalue = component.find("selectAll").get("v.value");        
        var checkId = component.find("checkId"); 
        console.log('checkvalue : ',checkvalue);
        if(checkvalue == true){
            for(var i=0; i<checkId.length; i++){
                checkId[i].set("v.value",true);
            }
        }
        else{ 
            for(var i=0; i<checkId.length; i++){
                checkId[i].set("v.value",false);
            }
        }
    },
    
    handleSelect :  function(component, event, helper) {
        var distributorDetailList = component.get("v.distributorDetailList");
        for(var i=0;i<distributorDetailList.length;i++){
            if(distributorDetailList[i].checkMail==false){
                component.set("v.isSelectAll",false);
            }
        }
    },
    
    addDistributors : function(component,event,helper){
        console.log('selectedIds : '+component.get('v.selectedIds'));
        component.set("v.isSelectAll",true);
        var ddList=component.get('v.distributorDetailList');
        var accountArray=[];
        var accountListMap=component.get('v.contactListMap');
        console.log('accountListMap : '+JSON.stringify(accountListMap));
        if(Array.isArray(accountListMap)){
            for(var j=0; j<accountListMap.length;j++){
                if(accountListMap[j].cEmail!=null){
                  accountArray.push(accountListMap[j].cEmail);
                }
            } 
        }
        var action = component.get("c.getCommunityContacts");
        action.setParams({
            selectedIds: component.get('v.selectedIds')
        });
        var opts=[];   
        action.setCallback(this, function(a) {
            var state = a.getState();
            
            if (state == "SUCCESS") {
                var returnValue = a.getReturnValue();
                if(returnValue.length!=0){
                    console.log('returnValue json: '+JSON.stringify(returnValue)); 
                    var flag=false;
                    for(var i=0;i<returnValue.length;i++){
                        console.log('accountListMap json: '+returnValue[i].cEmail); 
                        if(accountListMap==null || !accountListMap.includes(returnValue[i].cEmail)){
                            if(!accountArray.includes(returnValue[i].cEmail)){
                            ddList.push(returnValue[i]);
                            flag=true;
                            }
                        }
                    }
                    if(flag){
                        component.set('v.distributorDetailList',ddList);
                    }
                    
                    var distributorDetailList=component.get('v.distributorDetailList');
                    for(var i=0;i<distributorDetailList.length;i++){
                        accountArray.push(distributorDetailList[i].cEmail);
                        component.set('v.contactListMap',accountArray);
                    } 
                }else{
                    helper.showMessage('Please select distributor',false);
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    
    removeTableRow:  function(component,event,helper){
        var indexVar=event.getSource().get('v.name');
        var contactListMap=component.get('v.contactListMap');
        console.log('contactListMap :'+JSON.stringify(contactListMap))
        var distributorDetailList=component.get("v.distributorDetailList");
        if (indexVar > -1) {
            distributorDetailList.splice(indexVar, 1);
        }
        component.set("v.distributorDetailList",distributorDetailList);
        component.set('v.contactListMap',component.get("v.distributorDetailList"));
        
        
    },
    handleFilesChange: function(component,event){
    	console.log(component.get("v.FileList"));
        var fileName = "No File Selected..";
        var fileCount=component.find("fileId").get("v.files").length;
        var files='';
        var count=0;
        if (fileCount > 0) {
            for (var i = 0; i < fileCount; i++) 
            {
                count=i+1;
                fileName = component.find("fileId").get("v.files")[i]["name"];
                files=files+','+fileName;
            }
        }
        else
        {
            files=fileName;
        }
        component.set("v.fileName", files);
	},
    
    onCheckSendEmail :function(component,event,helper){
        console.log(''+component.find('isSendEmailChecked').get('v.value'));
        var isChecked=component.find('isSendEmailChecked').get('v.value');
        component.set('v.isSendEmailChecked',isChecked); 
    },
    savePBC : function(component,event,helper){
        var isValid=helper.validateData(component);
        if(isValid){
            helper.createPolandPriceCommunication(component)
            .then(function(result) {
                console.log('result : ',result);
                if(result=='SUCCESS'){
                    helper.showMessage($A.get("$Label.c.Records_Inserted_Successfully_Secondary_Sales"),true);
                    var getPolandPriceCommList=component.get('v.polandPriceComList');
                    console.log('getPolandPriceCommList : '+getPolandPriceCommList)
                    if(getPolandPriceCommList!='undefined' || getPolandPriceCommList!='' || getPolandPriceCommList!=null){
                        console.log('upload file called');
                        helper.uploadFiles(component,event);
                    }
                }else{
                    helper.showMessage('Something went wrong',false);
                }
            });
        }
        
        /*window.setTimeout($A.getCallback(function() {
            var getPolandPriceCommList=component.get('v.polandPriceComList');
            console.log('getPolandPriceCommList : '+getPolandPriceCommList)
            if(getPolandPriceCommList!='undefined' || getPolandPriceCommList!='' || getPolandPriceCommList!=null){
                console.log('upload file called');
                var isValid=helper.validateData(component);
                if(isValid){
                    helper.uploadFiles(component,event);
                   
                }
            }
        }),8000 );*/
    }
})