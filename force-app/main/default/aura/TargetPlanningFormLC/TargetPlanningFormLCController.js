({
	doInit : function(component, event, helper) {
        helper.getMarketingYear(component);
        helper.getPageSize(component);
        helper.getLastSavedData(component);
        helper.getDivision(component);
        //helper.retrieveSKUWrapper(component);
        
	},
    onChange : function(component, event, helper) {
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
            console.log(component.get("v.secondYear"));
        }
        if(component.get("v.custDiv") != " " )
			helper.retrieveSKUWrapper(component);
    },
    changeDivision:function(component, event, helper) {
         component.set("v.custDiv",component.find('div').get('v.value'));
		 helper.retrieveSKUWrapper(component);
    },
    handleNext: function(component, event, helper) {
        
        var finalList=component.get('v.FinalList');
        console.log('finalList::'+finalList);
        if(finalList.length>0){
        	helper.saveTargetTotal(component, event, helper);
        }
        if(component.get("v.FilterList").length>0)
            var sObjectList = component.get("v.FilterList");
        else
        	var sObjectList = component.get("v.SKUWrapper");    
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
        component.set("v.FinalList",[]);
        component.set("v.PageNumber",component.get("v.PageNumber")+1);
        helper.getLastSavedData(component);
    },
    handlePrev: function(component, event, helper) {
        var finalList=component.get('v.FinalList');
        if(finalList.length>0){
        	helper.saveTargetTotal(component, event, helper);
        }
        if(component.get("v.FilterList").length>0)
            var sObjectList = component.get("v.FilterList");
        else
        	var sObjectList = component.get("v.SKUWrapper");
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
        component.set("v.FinalList",[]);
        component.set("v.PageNumber",component.get("v.PageNumber")-1);
        helper.getLastSavedData(component);
    },
    onMaterialChange: function(component, event, helper) {
        
        var timer = setTimeout(function(){
            helper.filterRecords(component);           
        },500);
        
    },
    onProductChange: function(component, event, helper) {
        
        var timer = setTimeout(function(){
            helper.filterRecords(component);           
        },500);
        
    },
    updatefinallist : function(component, event, helper) {
        var pagination = component.get("v.PaginationList");
        var target = event.target;
        var rowIndex = event.getSource().get('v.label');
        var value = event.getSource().get('v.value');
        var sObjectList = component.get("v.SKUWrapper");
        const index = sObjectList.indexOf(pagination[rowIndex]);
        component.set("v.PaginationList",pagination);
        var finalList=component.get('v.FinalList');
        if(!finalList.includes(sObjectList[index])){
        	finalList.push(sObjectList[index]);
        	component.set('v.FinalList', finalList);
        }
        for(var p in pagination){
            console.log('p.targetTotal'+pagination[p].targetTotal);
            console.log('p.draftTotal'+pagination[p].draftTotal);
            console.log('p.SKUName'+pagination[p].SKUName);
            console.log('p.SKUMaterial'+pagination[p].SKUMaterial);
        }
        for(var p in finalList){
            console.log('p.targetTotal'+pagination[p].targetTotal);
            console.log('p.draftTotal'+pagination[p].draftTotal);
            console.log('p.SKUName'+pagination[p].SKUName);
            console.log('p.SKUMaterial'+pagination[p].SKUMaterial);
        }
	},
    saveTargetTotal : function(component, event, helper) {
        var finalList=component.get('v.FinalList');
        if(finalList.length>0){
        	helper.saveTargetTotal(component, event, helper);
        }
        component.set("v.FinalList",[]);
        helper.getLastSavedData(component);
	}
})