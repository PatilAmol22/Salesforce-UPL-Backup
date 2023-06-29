({
    fetchAccount : function(component, event) {
        
        var action = component.get('c.fetchAccountDetail'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                //alert('Success');
                //component.set('v.sObjList', a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    
    //for fetching accoun details
    searchHelperAccount :function(component,event,getInputkeyWordAccount){
        
        var action = component.get("c.fetchAccountDetail");
        
        action.setParams({
            'searchKeyWordAccount': getInputkeyWordAccount
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            // $A.util.removeClass(component.find("mySpinnerAccount"), "slds-show");
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
                
                if (storeResponse.length == 0) {
                    component.set("v.MessageAccount", 'No Result Found...');
                } else {
                    component.set("v.MessageAccount", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecordsAccount", storeResponse);
                
                
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
        
        
    } ,
    
    //searching for Owner Name
    searchHelperOwnerName :function(component,event,getInputkeyWordOwnerName){
        
        var action = component.get("c.fetchOwnerNameDetail");
        
        action.setParams({
            'searchKeyWordOwnerName': getInputkeyWordOwnerName
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
                
                if (storeResponse.length == 0) {
                    component.set("v.MessageOwnerName", 'No Result Found...');
                } else {
                    component.set("v.MessageOwnerName", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecordsOwnerName", storeResponse);
                
                
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
        
        
    } ,
    
    
    
    searchHelperOnAccountKeyPress : function(component,event,getInputkeyWordAccount){
        var action = component.get("c.searchHelperOnAccountKeyPres");
        
        action.setParams({
            'searchKeyWordAccount': getInputkeyWordAccount
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            //$A.util.removeClass(component.find("mySpinnerAccount"), "slds-show");
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
                
                if (storeResponse.length == 0) {
                    component.set("v.MessageAccount", 'No Result Found...');
                } else {
                    component.set("v.MessageAccount", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecordsAccount", storeResponse);
                
                
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    },
    
    
    searchHelperOnOwnerNameKeyPress : function(component,event,getInputkeyWordOwnerName){
        var action = component.get("c.searchHelperOnOwnerNameKeyPres");
        
        action.setParams({
            'searchKeyWordOwnerName': getInputkeyWordOwnerName
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
                
                if (storeResponse.length == 0) {
                    component.set("v.MessageOwnerName", 'No Result Found...');
                } else {
                    component.set("v.MessageOwnerName", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecordsOwnerName", storeResponse);
                
                
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    },
    
    
    
    //on load data retrival
    fetchSalesOrderData1 : function(component,event,accId,strtDate,statusOrder,edDate,subOrderStatus){
        
        var action = component.get('c.fetchSalesOrder1');
        console.log('statusOrder : '+statusOrder)
        action.setParams({
            "accountId" : accId,
            "strtDate" : strtDate,
            "statusOrder" : statusOrder,
            "edDate" : edDate,
            "subOrderStatus" : subOrderStatus
            
        });
        
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            
            if (state === "SUCCESS") {
                //set response value in lstOpp attribute on component.
                
                if(response.getReturnValue().length >0 ){
                    component.set("v.showDataTable" , true);
                    //console.log(''+response.getReturnValue().length);
                    component.set('v.lstSalesOrder', response.getReturnValue());
                  
                    component.set("v.displayInfo",false);
                    
                    // when response successfully return from server then apply jQuery dataTable after 500 milisecond
                    
                    
                    
                    setTimeout(function(){
                        
                        $(document).ready(function () {
                            $('#tableId').DataTable({
                                "footerCallback": function ( row, data, start, end, display ) {
                                    var api = this.api(), data;
                                    // converting to interger to find total
                                    var intVal = function ( i ) {
                                        //alert(typeof i);
                                       return typeof i === 'string' ?
                                            i.replace(/[\$,]/g, '')*1 :
                                        typeof i === 'number' ?
                                            i : 0;
                                        
                                        
                                    };
                                    // computing column Total of the complete result 
                                    var Total = api
                                    .column( 4 )
                                    .data()
                                    .reduce( function (a, b) {
                                        return intVal(a) + intVal(b);
                                    }, 0 );
                                    
                                    // Total over this page
                                    var pageTotal = api
                                    .column( 4, { page: 'current'} )
                                    .data()
                                    .reduce( function (a, b) {
                                        return intVal(a) + intVal(b);
                                    }, 0 );
                                    
                                    component.set('v.totalAmount', Total);  
                                    //alert(component.get('v.totalAmount')); 
                                    // Update footer
                                   /* $( api.column(4 ).footer() ).html(
                                        Total 
                                    );  */                          
                                    
                                },
                                
                                
                            });
                            
                        });
                        
                        
                        $('div.dataTables_filter input').addClass('slds-input');
                        $('div.dataTables_filter input').css("marginBottom", "10px");
                        
                        
                        
                    }, 800);
                    
                }
                
                
            }
        });
        $A.enqueueAction(action); 
    },
    
    
    
    // for Search Button
    fetchSalesOrderData : function(component,event,accId,ownerId,strtDate,statusOrder,edDate,isSameDate){
        console.log('statusOrder ----22> '+statusOrder)
        console.log('accId ----22> '+accId)
        var action = component.get('c.fetchSalesOrder');
        action.setParams({
            "accountId" : accId,
            "ownerId" : ownerId,
            "strtDate" : strtDate,
            "statusOrder" : statusOrder,
            "edDate" : edDate,
            "isSameDate" : isSameDate
            
        });
        
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            
            if (state === "SUCCESS") {
                //set response value in lstOpp attribute on component.
                
                if(response.getReturnValue().length >0 ){
                    component.set("v.showDataTable" , true);
                    console.log(''+response.getReturnValue().length);
                    component.set('v.lstSalesOrder', response.getReturnValue());
                    component.set("v.displayInfo",false);
                    
                    if ( $.fn.dataTable.isDataTable( '#tableId' ) ) {
                        
                        var table = $('#tableId').DataTable();
                        table.destroy();
                    }
                    
                    // alert(component.get('v.lstSalesOrder'));
                    // when response successfully return from server then apply jQuery dataTable after 500 milisecond
                    setTimeout(function(){
                        // if ( ! $.fn.DataTable.isDataTable( '#tableId' ) ) {
                        $('#tableId').DataTable({
                            
                            "footerCallback": function ( row, data, start, end, display ) {
                                var api = this.api(), data;
                                // converting to interger to find total
                                var intVal = function ( i ) {
                                    return typeof i === 'string' ?
                                        i.replace(/[\$,]/g, '')*1 :
                                    typeof i === 'number' ?
                                        i : 0;
                                };
                                // computing column Total of the complete result 
                                var Total = api
                                .column( 4 )
                                .data()
                                .reduce( function (a, b) {
                                    return intVal(a) + intVal(b);
                                }, 0 );
                                
                                // Total over this page
                                var pageTotal = api
                                .column( 4, { page: 'current'} )
                                .data()
                                .reduce( function (a, b) {
                                    return intVal(a) + intVal(b);
                                }, 0 );
                                 component.set('v.totalAmount', Total);  
                                // Update footer
                               /* $( api.column(4 ).footer() ).html(
                                    Total 
                                );*/                            
                                
                            }  
                            
                        });
                        $('div.dataTables_filter input').addClass('slds-input');
                        $('div.dataTables_filter input').css("marginBottom", "10px");
                        
                        // }
                        
                    }, 500);
                    
                }else{
                    if ( $.fn.dataTable.isDataTable( '#tableId' ) ) {
                        var table = $('#tableId').DataTable();
                        table.destroy();
                        component.set('v.lstSalesOrder',null);
                        component.set("v.showDataTable" , false);
                        component.set("v.displayInfo" , true);
                        var tmp = component.get("v.displayInfo"); 
                        if(tmp){
                            var msg = $A.get("$Label.c.Sales_Orders_not_found");
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title : 'Info Message',
                                message:msg,
                                messageTemplate: 'Mode is pester ,duration is 1 sec and Message is overrriden',
                                duration:' 1000',
                                key: 'info_alt',
                                type: 'info',
                                mode: 'pester'
                            });
                            toastEvent.fire();
                        }
                        
                    }
                    
                    var msg = $A.get("$Label.c.Sales_Orders_not_found");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Info Message',
                        message:msg,
                        messageTemplate: 'Mode is pester ,duration is 1 sec and Message is overrriden',
                        duration:' 1000',
                        key: 'info_alt',
                        type: 'info',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    
                }
                
            }
        });
        $A.enqueueAction(action); 
    },
    
    
    
    
    showErrorToast : function(component, event, helper,msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error Message',
            message:msg,
            messageTemplate: 'Mode is pester ,duration is 1 sec and Message is overrriden',
            duration:' 1000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    
    convertArrayOfObjectsToCSV : function(component,objectRecords){
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        
        
        columnDivider = ',';
        lineDivider =  '\n';
        
        keys = ['Sales_Order_Number','AccountName','Status','creationDate','totalValue' ];
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
            
            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                
                // add , [comma] after every String value,. [except first]
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }   
                
                csvStringResult += '"'+ objectRecords[i][skey]+'"'; 
                
                counter++;
                
            } // inner for loop close 
            csvStringResult += lineDivider;
        }// outer main for loop close 
        
        // return the CSV formate String 
        return csvStringResult;        
    },
    
    loginAdmin : function (component, event, helper){
        
        var action = component.get('c.fetchProfile'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                //component.set('v.sObjList', a.getReturnValue());
                var response = a.getReturnValue();
                if(response!=null){
                    component.set('v.isAdminLogin',true);
                }else{
                    component.set('v.isAdminLogin',false);
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    
    
    
    
})