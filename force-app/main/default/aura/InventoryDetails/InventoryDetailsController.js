({
    doInit : function(component, event, helper) {
        console.log('do init of detail'); 
        var sObjectList = component.get("v.invntId");
                var pageSize = component.get("v.pageSize");
        		component.set("v.totalRecords", sObjectList.length);
        console.log('do init of detail1');
        		var totalPages=Math.ceil(component.get("v.totalRecords") / pageSize);
                // set star as 0
                component.set("v.startPage",0);//changed to 1
                component.set("v.PageNumber",1);
        	    component.set("v.endPage",pageSize-1);
        		component.set("v.TotalPages", totalPages );  
                var PaginationList = [];
                for(var i=0; i< pageSize; i++){
                    if(component.get("v.invntId").length> i)
                        PaginationList.push(sObjectList[i]);
                    component.set('v.PaginationList', PaginationList);
                }                
                
    },       
	handleNext: function(component, event, helper) {              
        var sObjectList = component.get("v.invntId");    
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
        component.set("v.PageNumber",component.get("v.PageNumber")+1);
    },
    
    handlePrev: function(component, event, helper) {
        var sObjectList = component.get("v.invntId");
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
        component.set("v.PageNumber",component.get("v.PageNumber")-1);
    },
    updateAvailability: function(component, event, helper) {        
        var pagination = component.get("v.invntId");
        console.log('pagination +'+pagination);
        var target = event.target;
        console.log('target +'+target);
        var rowIndex = event.getSource().get('v.label');
        console.log('rowIndex +'+rowIndex);
        var InventoryRecordToUpdate = pagination[rowIndex];
        helper.helperUpdateAvailability(component, rowIndex, event, helper,target, InventoryRecordToUpdate);
            
	 },
    updateAvailabilityDate: function(component, event, helper) {
        
        var pagination = component.get("v.invntId");
        //console.log('pagination +'+pagination);
        var target = event.target;
        var rowIndex = event.getSource().get('v.label');
        var InventoryRecordToUpdate = pagination[rowIndex];
        helper.helperUpdateAvailabilityDate(component, rowIndex, event, helper,target, InventoryRecordToUpdate);
        
	 },
    UpdateComment: function(component, event, helper) {        
        var pagination = component.get("v.invntId")        
        console.log('pagination +'+pagination);
        var target = event.target;
        var rowIndex = event.getSource().get('v.label');
        var InventoryRecordToUpdate = pagination[rowIndex];
        helper.helperUpdateComment(component, rowIndex, event, helper,target, InventoryRecordToUpdate);
        
	 },
    //Search Filter
    handleSearch: function(component, event, helper) {
        console.log('in handleSearch');
        var timer = setTimeout(function(){
            helper.filterRecords(component);           
        },500);
        
    },
    
    
})