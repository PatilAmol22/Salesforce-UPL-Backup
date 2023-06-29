({
	doInit : function(component, event, helper) {
        console.log('do init of detail'); 
        var sObjectList = component.get("v.custPLs");
                var pageSize = component.get("v.pageSize");
        		component.set("v.totalRecords", sObjectList.length);
        var currbrl1 = component.get("v.pricebookdetail");
        console.log('currbrl1---'+currbrl1);
         var pricebookdetail11 = component.get("v.pricebookdetail");
        console.log('pricebookdetail11---'+JSON.stringify(pricebookdetail11));
        console.log('pageSize---'+pageSize);
        console.log('component.get("v.totalRecords")--'+ component.get("v.totalRecords"));
        console.log('do init of detail1--'+sObjectList.length);
        if(sObjectList.length >= pageSize) 
        		var totalPages=Math.ceil(component.get("v.totalRecords") / pageSize);
        else 
            var totalPages=1;
                // set star as 0
                component.set("v.startPage",0);//changed to 1
                component.set("v.PageNumber",1);
        	    component.set("v.endPage",pageSize-1);
        		component.set("v.TotalPages", totalPages );  
                var PaginationList = [];
                for(var i=0; i< pageSize; i++){
                    if(component.get("v.custPLs").length> i)
                        PaginationList.push(sObjectList[i]);
                    component.set('v.PaginationList', PaginationList);
                    //console.log('v.PaginationList', PaginationList);
                }                
                console.log('v.PaginationList', PaginationList);
    },    
    //Search Filter
    handleSearch: function(component, event, helper) {
        console.log('in handleSearch');
        var timer = setTimeout(function(){
            helper.filterRecords(component);           
        },500);
        
    },
    
    handleNext: function(component, event, helper) {              
        var sObjectList = component.get("v.custPLs");    
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
    // function call on Click on the "Download As CSV" Button. 
    downloadCSV: function(component, event, helper) {
        var sObjectList = component.get("v.custPLs");
        console.log(sObjectList);
        var csv = helper.convertArrayOfObjectsToCSV(component,sObjectList);
        if (csv == null){return;}      
	    var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        //hiddenElement.href = 'data:application/vnd.ms-excel,' + encodeURI(csv);
        hiddenElement.target = '_self'; // 
        hiddenElement.download = 'CustomerPriceList.csv';   
        document.body.appendChild(hiddenElement); 
    	hiddenElement.click(); 
    },
    
    handlePrev: function(component, event, helper) {
        var sObjectList = component.get("v.custPLs");
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
    }
    
})