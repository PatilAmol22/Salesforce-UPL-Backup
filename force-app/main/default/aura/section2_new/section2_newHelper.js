({
    showHideDetailsInfos : function(component,event,helper) {
        console.log('In Helper Method');
        
        var action = component.get('c.showHideDetailsInfo'); 
        
        
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            console.log('in section 2 sumary '+state);
            if(state == 'SUCCESS') {
                var totalcollect,outstanding,balancecredit,showCurYear,showLstYear,showTotalNumberofOrder,showGrowth;
                var returnValue = a.getReturnValue();
                console.log('returnValue in total collect '+JSON.stringify(returnValue));
                if(returnValue.length != 0){
                    totalcollect = returnValue[0].Total_Collectible__c;
                    outstanding = returnValue[0].Outstanding__c;
                    balancecredit = returnValue[0].Balance_Credit_Limit__c;
                    showCurYear = returnValue[0].This_Year_Sales__c;
                    showLstYear = returnValue[0].Last_Year_Sales__c;
                    showTotalNumberofOrder = returnValue[0].Total_number_of_Order__c;
                    showGrowth = returnValue[0].Show_Growth__c;
                }
                
                
                console.log('showGrowth in section '+showGrowth);
                
                component.set("v.Total_Collectible",totalcollect);
                component.set("v.Outstanding",outstanding);
                component.set("v.Balance_Credit_Limit",balancecredit);
                component.set("v.curYear",showCurYear);
                component.set("v.lastYear",showLstYear);
                component.set("v.totalNumberOfOrder",showTotalNumberofOrder);
                component.set("v.growth",showGrowth);
                
            }
        });
        $A.enqueueAction(action);
        
    },
    
    fetchCollectionInfos:function(component,event,helper){
      console.log('In fetchCollectionInfos MEthod ');
        //collectionInfo
         var action = component.get('c.collectionInfo'); 
        
        
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            console.log('state in section 2 '+state);
            if(state == 'SUCCESS') {
                if(a.getReturnValue()!=null){
                    component.set('v.collection', a.getReturnValue());
                    
                     var tempDate =  a.getReturnValue().LastModifiedDate;
                    
                    
                    
                    const months = ["JAN", "FEB", "MAR","APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
                    let current_datetime = new Date(tempDate);
                    
                    let formatted_date = current_datetime.getDate() + "-" + months[current_datetime.getMonth()] + "-" + current_datetime.getFullYear()
                    
                    component.set("v.collectionLastDate",formatted_date);
                    component.set("v.DataNotfoundCollection",true);
                    
                }else{
                    component.set("v.DataNotfoundCollection",false);
                    var errormsg = $A.get("$Label.c.Data_Not_Available");
                    component.set("v.DataNotfoundCollectionMsg",errormsg);
                    
                    console.log('Data not found');
                }
                
            }
        });
        $A.enqueueAction(action);
        
        
    },
    
    fetchOutstandingInfos:function(component,event,helper){
        
         var action = component.get('c.outstandingInfo'); 
        
        
        
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                if(a.getReturnValue()!=null){
                    
					console.log('JSON FORMAT '+JSON.stringify(a.getReturnValue()));                    
                    component.set('v.outstandingDate', a.getReturnValue());  
                    var tempDate =  a.getReturnValue().LastModifiedDate;
                    
                    console.log('In data last '+tempDate);
                    
                    const months = ["JAN", "FEB", "MAR","APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
                    let current_datetime = new Date(tempDate);
                    //console.log('current_datetime '+current_datetime);
                    let formatted_date = current_datetime.getDate() + "-" + months[current_datetime.getMonth()] + "-" + current_datetime.getFullYear()
                    console.log('formatted_date '+formatted_date);
                    component.set("v.outstandingLastDate",formatted_date);
                    
                    component.set("v.DataNotfoundOutstand",true);
                    
                }else{
                    component.set("v.DataNotfoundOutstand",true);
                    var errormsg = $A.get("$Label.c.Data_Not_Available");
                    component.set("v.DataNotfoundOutstandMsg",errormsg);
                    console.log('Data not found');
                }
                
                
            }
        });
        $A.enqueueAction(action);
        
    },
   
    
    fetchCreditInfo:function(component,event,helper){
        console.log('in fetchCreditInfo Method');
        
        var action = component.get('c.Credit_Info'); 
        
        
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                if(a.getReturnValue()!=null){
                    console.log('fetchCreditInfo JOSN Format '+JSON.stringify(a.getReturnValue()));
                    component.set('v.balanceCredit', a.getReturnValue()); 
                    var tempDate =  a.getReturnValue().LastModifiedDate;
                    
                    console.log('In data last '+tempDate);
                    
                    const months = ["JAN", "FEB", "MAR","APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
                    let current_datetime = new Date(tempDate);
                    //console.log('current_datetime '+current_datetime);
                    let formatted_date = current_datetime.getDate() + "-" + months[current_datetime.getMonth()] + "-" + current_datetime.getFullYear()
                    console.log('formatted_date '+formatted_date);
                    component.set("v.BalanceCreditLastDate",formatted_date);
                     component.set("v.DataNotfoundCreditBalance",true);
                    
                    
                }else{
                    component.set("v.DataNotfoundCreditBalance",true);
                    var errormsg = $A.get("$Label.c.Data_Not_Available");
                    component.set("v.DataNotfoundCreditBalanceMsg",errormsg);
                    console.log('Data not found');
                }
                
            }
        });
        $A.enqueueAction(action);
        
    },
    
    
    fetchSalesOrderAmount:function(component,event,helper){
      console.log('Inside fetchSalesOrderAmount Method ')  ;
        var action = component.get('c.fetchSalesAmt'); 
        
        
        
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                //component.set('v.sObjList', a.getReturnValue());
               console.log('sales order Amount '+a.getReturnValue());
                var returnSalesOrder = a.getReturnValue();
                console.log('sales order Amount '+JSON.stringify(returnSalesOrder));
                var countryNam = returnSalesOrder.countryName;
                console.log('countryNam dasda  '+countryNam);
                if(countryNam=='Poland'){
                    component.set("v.isForPoland",true);
                    component.set("v.isForOther",false);
                    component.set("v.isForJapan",false);
                }else if(countryNam=='Japan'){
                    component.set("v.isForJapan",true);
                    component.set("v.isForOther",false);
                    component.set("v.isForPoland",false);                   
                }else{
                    component.set("v.isForPoland",false);
                    component.set("v.isForJapan",false);
                    component.set("v.isForOther",true);
                    
                }
                component.set("v.curentSalesOrderAmt",returnSalesOrder.currentYearSales);
                component.set("v.lastSalesOrderAmt",returnSalesOrder.lstYearSales);
                component.set("v.totalNumberOfOrders",returnSalesOrder.totalNumberOrder);
                component.set("v.curCode",returnSalesOrder.currencyCode);
                
                console.log('returnSalesOrder==>',returnSalesOrder);
                
                
                component.set("v.lstYear",returnSalesOrder.lstYear);
                // component.set("v.lstYear",((returnSalesOrder.lstYear).toString()).substring(2,4));
                component.set("v.lstYear1",returnSalesOrder.lstYear1);
                // component.set("v.lstYear1",((returnSalesOrder.lstYear1).toString()).substring(2,4)); 
                
                component.set("v.curYears",returnSalesOrder.curYear);
                //component.set("v.curYears",((returnSalesOrder.curYear).toString()).substring(2,4));
                
                component.set("v.curYears1",returnSalesOrder.curYear1);
                // component.set("v.curYears1",((returnSalesOrder.curYear1).toString()).substring(2,4));
                
                
                console.log('Month Name is  '+returnSalesOrder.monthName);
                component.set("v.monthName",returnSalesOrder.monthName);
                component.set('v.growthAmount', returnSalesOrder.growth);
                component.set('v.asOnDate', returnSalesOrder.asOnDate);
                
                
            }
        });
        $A.enqueueAction(action);
        
    },
    
    
    fetchSalesgrowth:function(component,event,helper){
        console.log('in fetchSalesgrowth method ');
        var action = component.get('c.fetchSalesGrowth'); 
        
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            console.log('State in growth is '+state );
            if(state == 'SUCCESS') {
                var returngrowth = a.getReturnValue();
                console.log('State in growth returngrowth is '+returngrowth );
                
               // component.set('v.growthAmount', returngrowth);
            }
        });
        $A.enqueueAction(action);
        
        
        
    },
    
    
    
    
    
    
})