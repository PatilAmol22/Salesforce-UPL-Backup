({
    getUserDetails: function(component,event,helper) {
        console.log('reached helper');
        var action = component.get("c.checkAccess");
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('reached helper state'+ state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log("store respsonse is"+ storeResponse);
                //component.set("v.userInfo", storeResponse);
                console.log('response is sales rep'+ storeResponse.isSalesRep +'customer is '+ storeResponse.isCustomer );
                if (storeResponse.isCustomer)
                {
                    component.set("v.isCustomer",true);
                }
                else 
                {
                    if (storeResponse.isSalesRep)
                    {
                        component.set("v.isSalesRep",true);
                    }
                }
                if (storeResponse.blockDate!= null)
                {
                    component.set("v.blockDate",storeResponse.blockDate);
                    
                }
                
                /*component.set("v.oInventoryUpload", storeResponse);
                var convert =JSON.parse(JSON.stringify(component.get("v.ostockinchannel")));
                component.set("v.zone", convert);
                console.log("value is "+ convert.Name);
              //console.log("we reached here "+convert.Name );
               //console.log(JSON.parse(JSON.stringify(component.get("v.ostockinchannel") )));
               //component.set("v.zone", storeResponse.zone);
              */
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    getDocuments :function(component,event,helper){
        /*var action = component.get("c.getDocument");
        action.setCallback(this, function(res){
            component.set("v.doc", res.getReturnValue());
            console.log(component.get("v.doc"));
        })
        $A.enqueueAction(action);*/
        
        
        var action = component.get("c.getDataAsCSV");
        action.setCallback(this, function(res){
            // call the helper function which "return" the CSV data as a String   
            var csvhere;   
            var objectRecords = res.getReturnValue();
            var csvStringResult, counter, keys, columnDivider, lineDivider;
            
            // store ,[comma] in columnDivider variabel for sparate CSV values and 
            // for start next line use '\n' [new line] in lineDivider varaible  
            columnDivider = ',';
            lineDivider =  '\n';
            
            // in the keys valirable store fields API Names as a key 
            // this labels use in CSV file header 
            //Year,Month,CustomerCode,SKUCode,Volume 
            keys = ['Year','Month','CustomerCode','SKUCode','Volume' ];
            
            csvStringResult = '';
            csvStringResult += keys.join(columnDivider);
            csvStringResult += lineDivider;
            
            if( res.getReturnValue()!=null ){
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
            }
            
            
            // return the CSV formate String
            
            csvhere = csvStringResult;
            if (csvhere == null){return;} 
            console.log('->'+csvhere);
            
            if( res.getReturnValue()==null ){
                component.set("v.doc", '/servlet/servlet.FileDownload?file=0150K000009VvXjQAK');
            }else{
                component.set("v.doc", 'data:text/csv;charset=utf-8,' + encodeURI(csvhere));
            }
        })
        $A.enqueueAction(action);
    }
    
    /*convertArrayOfObjectsToCSV : function(component){
        var csvStringResult, counter, keys, columnDivider, lineDivider;
       console.log('reached here 1');
        columnDivider = ',';
        lineDivider =  '\n';
        keys = ['Year','SAP Code','ShkhkhkKU','CurrentMonth','PreviousMonth','LastMonth'];
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        return csvStringResult;        
    }*/
})