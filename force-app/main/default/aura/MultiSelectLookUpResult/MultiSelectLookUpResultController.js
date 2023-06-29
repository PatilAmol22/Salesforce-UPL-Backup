({
    selectRecord : function(component, event, helper){      
        // get the selected record from list  
        var getSelectRecord = component.get("v.oRecord");
        //var getSelectRecords = [];
         var getSelectRecords = component.get("v.lstSelectedRecordsResult"); 
        console.log(JSON.stringify(getSelectRecord));
       //console.log(getSelectRecords.length);
       
      /*  var isPresent = getSelectRecords.find(function(element) {
            return element == getSelectRecord;
        });
       
        if( $A.util.isUndefined(isPresent)){
        	getSelectRecords.push(getSelectRecord);  
        }*/
        getSelectRecords.push(getSelectRecord); 
        component.set("v.lstSelectedRecordsResult",getSelectRecords); 
    },
})