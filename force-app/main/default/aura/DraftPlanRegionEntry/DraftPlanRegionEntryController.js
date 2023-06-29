({
	doInit : function(component, event, helper) {
        helper.uplSetting(component);
        helper.getMarketingYear(component);
        helper.getDivision(component);
       	//helper.retriveWrapper(component);
        //alert('hello');
           
    },
    changeDivision:function(component, event, helper) {
         component.set("v.custDiv",component.find('div').get('v.value'));
		 helper.retriveWrapper(component);
    },
    onMaterialChange: function(component, event, helper) {
        helper.FilterRecordUpdated(component); 
        /*var timer = setTimeout(function(){
            helper.filterRecords(component);           
        },1000);*/
    },
    onProductChange: function(component, event, helper) {
       helper.FilterRecordUpdated(component); 
        /*var timer = setTimeout(function(){
            helper.filterRecords(component);           
        },1000);*/
        
    },
    Save : function(component, event, helper) {
        var cLis=component.get('v.ChangeList');
        if(cLis.length>0){
        	helper.NavSave(component, event, helper);
        }
        component.set("v.ChangeList",[]);
    },
    Cancel:function(component, event, helper) {
        //helper.Initiate();
        $A.get('e.force:refreshView').fire();
    },
    handleNext: function(component, event, helper) {
        //alert(component.get("v.dHeader"));
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
    addChange:function(component, event, helper) {
        var pagination = component.get("v.PaginationList");
        var target = event.target;
        var rowIndex = event.getSource().get('v.label');
        var value = event.getSource().get('v.value');
        var sObjectList = component.get("v.datList");
        const index = sObjectList.indexOf(pagination[rowIndex]);
        var Changelst=component.get('v.ChangeList');
        if(!Changelst.includes(sObjectList[index])){
         	Changelst.push(sObjectList[index]);
        	component.set('v.ChangeList', Changelst);
            }
        //alert(Changelst.length);
    },
    onChange : function(component, event, helper) {
        component.set("v.mktYear",component.find('select').get('v.value'));
        if(component.get("v.mktYear") == 'first'){
         	component.set("v.yearEditAccess",true);
            //component.set("v.freezeInput",fa);
            component.set("v.PrevYear",component.get("v.firstYear")-1);
            component.set("v.curYear",component.get("v.firstYear"));
        }
        if(component.get("v.mktYear") == 'second'){
            
            component.set("v.yearEditAccess",false);
            //alert(component.get("v.freezeInput"));
         	component.set("v.PrevYear",component.get("v.secondYear")-1);
            component.set("v.curYear",component.get("v.secondYear"));
            console.log(component.get("v.secondYear"));
        }
		helper.retriveWrapper(component);
    }
})