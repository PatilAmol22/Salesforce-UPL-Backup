({
    getOrderList: function(component, pageNumber, pageSize) {
        component.set("v.showSpinner",true);

        var pb = component.get("v.selectedPBRecord");
        var strt = component.find("strt_date").get("v.value");
        var end = component.find("end_date").get("v.value");
        var strt_dt = '';
        var end_dt = '';
        var skuId = '';

        if(pb.Id != undefined){
            skuId = pb.Id;
        }

        if(strt == undefined){
            strt_dt = ''; //new Date(strt);
        }
        else{
            strt_dt = strt;
        }

        if(end == undefined){
            end_dt = ''; //new Date(end);
        }
        else{
            end_dt = end; //new Date(end);
        }

        var action = component.get("c.getOrderData");
        action.setParams({
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "skuId": skuId,
            "strt_dt": strt_dt,
            "end_dt": end_dt
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                console.log('resultData - ', resultData);
                component.set("v.orderList", resultData.orderList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
            }
           
            component.set("v.showSpinner",false);
        });
        $A.enqueueAction(action);
    },

    convertDataToCSV : function(component, event, helper){
        component.set("v.showSpinner",true);
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        var pb = component.get("v.selectedPBRecord");
        var strt = component.find("strt_date").get("v.value");
        var end = component.find("end_date").get("v.value");
        var strt_dt = '';
        var end_dt = '';
        var skuId = '';

        if(pb.Id != undefined){
            skuId = pb.Id;
        }

        if(strt == undefined){
            strt_dt = ''; //new Date(strt);
        }
        else{
            strt_dt = strt;
        }

        if(end == undefined){
            end_dt = ''; //new Date(end);
        }
        else{
            end_dt = end; //new Date(end);
        }

        var action = component.get("c.getOrderDataToDownload");
        action.setParams({
            "skuId": skuId,
            "strt_dt": strt_dt,
            "end_dt": end_dt
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                // check if "objectRecords" parameter is null, then return from function
                if (resultData.length > 0) {
                   
                    // store ,[comma] in columnDivider variabel for sparate CSV values and 
                    // for start next line use '\n' [new line] in lineDivider varaible  
                    columnDivider = ',';
                    lineDivider =  '\n';
            
                    // in the keys valirable store fields API Names as a key 
                    // this labels use in CSV file header  
                    keys = ['Sales_Order_Number','SAP_Number','SKU_Code','SKU_Description','Date_Of_Approval','Ordered_Quantity' ];
                    
                    csvStringResult = '';
                    csvStringResult += keys.join(columnDivider);
                    csvStringResult += lineDivider;
            
                    for(var i=0; i < resultData.length; i++){   
                        counter = 0;
                    
                        for(var sTempkey in keys) {
                            var skey = keys[sTempkey] ;  
            
                        // add , [comma] after every String value,. [except first]
                            if(counter > 0){ 
                                csvStringResult += columnDivider; 
                            }   
                        
                        csvStringResult += '"'+ resultData[i][skey]+'"'; 
                        
                        counter++;
            
                        } // inner for loop close 
                        csvStringResult += lineDivider;
                    }// outer main for loop close 
                
                    if(csvStringResult != null){
                
                    // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
                        var hiddenElement = document.createElement('a');
                        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvStringResult);  // encodeURIComponent
                        hiddenElement.target = '_self'; // 
                        hiddenElement.download = 'ExportData.csv';  // CSV file Name* you can change it.[only name not .csv] 
                        document.body.appendChild(hiddenElement); // Required for FireFox browser
                        hiddenElement.click(); // using click() js function to download csv file
                    } 
                    else{
                        var errMsg = $A.get("{!$Label.c.No_Records_Found}");
                        var toastEvent1 = $A.get("e.force:showToast");
                        var titl  = $A.get("{!$Label.c.Warning}");
                        toastEvent1.setParams({
                            "title": titl,
                            "type": "Warning",
                            "message": errMsg
                            //"duration":'3000'
                        });
                        toastEvent1.fire();
                    }
                }
                else{
                    var errMsg = $A.get("{!$Label.c.No_Records_Found}");
                    var toastEvent1 = $A.get("e.force:showToast");
                    var titl  = $A.get("{!$Label.c.Error}");
                    toastEvent1.setParams({
                        "title": titl,
                        "type": "Error",
                        "message": errMsg
                        //"duration":'3000'
                    });
                    toastEvent1.fire();
                }
            }
            component.set("v.showSpinner",false);
        });
        $A.enqueueAction(action);
           
    },
})