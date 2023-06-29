({ 
    
    onCustomerGraphLoaded: function(cmp, event, helper) {
        
       // window.reload();
        
        var fiscalyearStart = "";
        var today = new Date();
        
        if ((today.getMonth() + 1) <= 6) {
        fiscalyearStart = today.getFullYear() - 1;
        } else {
        fiscalyearStart = today.getFullYear()
        }
        console.log('-----fiscalyearStart---- '+fiscalyearStart);
        
        
        
       var Q1 = [3,4,5];
        var Q2 = [6,7,8];
        var Q3 = [9,10,11];
        var Q4 = [0,1,2];
        
         var currentquater;
        console.log('this.Q1 : ',Q1);
        if(Q1.includes(new Date().getMonth())){
            currentquater = 'Quarter 4';
        }else if(Q2.includes(new Date().getMonth())){
            currentquater = 'Quarter 1';
        }else if(Q3.includes(new Date().getMonth())){
            currentquater = 'Quarter 2';
        }else if(Q4.includes(new Date().getMonth())){
            currentquater = 'Quarter 3';
        }
        console.log('-----currentquater---- '+currentquater);
        
        
        var action = cmp.get("c.getPickListValuesIntoList");
        action.setParams({ "quater" :currentquater, "Year" : fiscalyearStart, "brand" : cmp.get('v.SelectedDisList')});
        action.setCallback(this, function(data) {
            var state = data.getState();
            console.log('CreditDonutstate===',state);
            if (state === "SUCCESS") {
                cmp.set('v.SubmitMonths', data.getReturnValue().submit);
               // cmp.set('v.options', "{'label':'Bob','value':'123'}");
                cmp.set('v.options', data.getReturnValue().acc);
                cmp.set('v.options2', data.getReturnValue().descriptionList);
                
                let val = data.getReturnValue().picklist;
                var today = new Date();
                var dd = String(today.getDate()).padStart(2, '0');
                var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
                console.log('mm-->>',mm);
                var yyyy = today.getFullYear();
                today = mm + '/' + dd + '/' + yyyy;
                console.log('today',today);
                
                if((parseInt(mm) >= 1) && (parseInt(mm) <= 6)){
                    const result = Number(yyyy) + 1;
                    const result1 = Number(yyyy) - 1;
                    console.log('result-->>',result);
                    //  console.log('first if',yyyy + '-'+ yyyy+1);
                    if(data.getReturnValue().picklist.includes(yyyy + '-'+ result)){
                        cmp.set('v.yearValue',result1 + '-'+ yyyy);
                        cmp.set('v.currentYear',result1 + '-'+ yyyy);
                        console.log('first if');
                        var index = data.getReturnValue().picklist.indexOf(yyyy + '-'+ result);
                        if (index > -1) {
                            data.getReturnValue().picklist.splice(index, 1); // 2nd parameter means remove one item only
                        }
                    }else{
                        cmp.set('v.yearValue',yyyy + '-'+ result);
                         cmp.set('v.currentYear',yyyy + '-'+ result);
                    }
                }else{
                    const result = Number(yyyy) + 1;
                    cmp.set('v.yearValue',yyyy + '-'+ result);
                     cmp.set('v.currentYear',yyyy + '-'+ result);
                }
                
                console.log('dferfr',cmp.get('v.yearValue'));
                var YearOption=[] ;
                
                //YearOption.push({'label': 'None', 'value': 'None'})
                data.getReturnValue().picklist.forEach(function(key) {
                    YearOption.push({'label': key, 'value': key}) ;
                });
                
                console.log('YearOption-->>',YearOption);
                cmp.set('v.yearOptionRemoveCurrent',YearOption);
                console.log(cmp.get('v.yearOptionRemoveCurrent'));
                
                 var MonthOption=[] ;
               //  MonthOption.push({'label': 'None', 'value': 'None'});
                
                if((parseInt(mm) >= 1) && (parseInt(mm) <= 3)){
                    MonthOption.push({'label': 'I kwartał kwiecień-czerwiec', 'value': 'Quarter 1'});
                    MonthOption.push({'label': 'II kwartał lipiec-wrzesień', 'value': 'Quarter 2'});
                    cmp.set('v.MonthValue','Quarter 2');
                    if(cmp.get("v.SubmitMonths") == true){
                        MonthOption.push({'label': 'III kwartał październik-grudzień', 'value': 'Quarter 3'});
                        cmp.set('v.MonthValue','Quarter 3');
                    }
                }else  if((parseInt(mm) >= 4) && (parseInt(mm) <= 6)){
                    MonthOption.push({'label': 'I kwartał kwiecień-czerwiec', 'value': 'Quarter 1'});
                    MonthOption.push({'label': 'II kwartał lipiec-wrzesień', 'value': 'Quarter 2'});
                    MonthOption.push({'label': 'III kwartał październik-grudzień', 'value': 'Quarter 3'});
                    cmp.set('v.MonthValue','Quarter 3');
                    if(cmp.get("v.SubmitMonths") == true){
                        MonthOption.push({'label': 'IV kwartał styczeń-marzec', 'value': 'Quarter 4'});
                    cmp.set('v.MonthValue','Quarter 4');
                    }
                }else  if((parseInt(mm) >= 7) && (parseInt(mm) <= 9)){
                    if(cmp.get("v.SubmitMonths") == true){
                        MonthOption.push({'label': 'I kwartał kwiecień-czerwiec', 'value': 'Quarter 1'});
                    cmp.set('v.MonthValue','Quarter 1');
                    }
                }else  if((parseInt(mm) >= 10) && (parseInt(mm) <= 12)){
                    MonthOption.push({'label': 'I kwartał kwiecień-czerwiec', 'value': 'Quarter 1'});
                    cmp.set('v.MonthValue','Quarter 1');
                    if(cmp.get("v.SubmitMonths") == true){
                        MonthOption.push({'label': 'II kwartał lipiec-wrzesień', 'value': 'Quarter 2'});
                   cmp.set('v.MonthValue','Quarter 2');
                    }
                }
                
                cmp.set('v.Months',MonthOption);
                
              //  cmp.set('v.MonthValue','None');
                
                helper.scripts(cmp, event);
            }
        })
        $A.enqueueAction(action);
        
    },
    
    
      onBrandChange: function(cmp, event, helper) {
        var action = cmp.get("c.getPickListValuesIntoList");
        action.setParams({ "quater" : '' , "Year" : '0000' , "brand" : cmp.get('v.SelectedDisList')});
        action.setCallback(this, function(data) {
            var state = data.getState();
            console.log('CreditDonutstate===',state);
            console.log('Brand');
            if (state === "SUCCESS") {
                cmp.set('v.options2', data.getReturnValue().descriptionList);
                 cmp.set('v.Placeholder' ,$A.get("$Label.c.All"));
                
            }
        })
        $A.enqueueAction(action);
        
    },
    
    handleYearChange : function(component, event, helper) {
        
        if(event.getParam("value") == component.get('v.currentYear')){
            var MonthOption=[] ;
            //MonthOption.push({'label': 'None', 'value': 'None'});
            
            var today = new Date();
                var dd = String(today.getDate()).padStart(2, '0');
                var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
                var yyyy = today.getFullYear();
            if((parseInt(mm) >= 1) && (parseInt(mm) <= 3)){
                    MonthOption.push({'label': 'I kwartał kwiecień-czerwiec', 'value': 'Quarter 1'});
                    MonthOption.push({'label': 'II kwartał lipiec-wrzesień', 'value': 'Quarter 2'});
                    component.set('v.MonthValue','Quarter 2');
                    if(component.get("v.SubmitMonths") == true){
                        MonthOption.push({'label': 'III kwartał październik-grudzień', 'value': 'Quarter 3'});
                        component.set('v.MonthValue','Quarter 3');
                    }
                }else  if((parseInt(mm) >= 4) && (parseInt(mm) <= 6)){
                    MonthOption.push({'label': 'I kwartał kwiecień-czerwiec', 'value': 'Quarter 1'});
                    MonthOption.push({'label': 'II kwartał lipiec-wrzesień', 'value': 'Quarter 2'});
                    MonthOption.push({'label': 'III kwartał październik-grudzień', 'value': 'Quarter 3'});
                    component.set('v.MonthValue','Quarter 3');
                    if(component.get("v.SubmitMonths") == true){
                        MonthOption.push({'label': 'IV kwartał styczeń-marzec', 'value': 'Quarter 4'});
                    component.set('v.MonthValue','Quarter 4');
                    }
                }else  if((parseInt(mm) >= 7) && (parseInt(mm) <= 9)){
                    if(component.get("v.SubmitMonths") == true){
                        MonthOption.push({'label': 'I kwartał kwiecień-czerwiec', 'value': 'Quarter 1'});
                    component.set('v.MonthValue','Quarter 1');
                    }
                }else  if((parseInt(mm) >= 10) && (parseInt(mm) <= 12)){
                    MonthOption.push({'label': 'I kwartał kwiecień-czerwiec', 'value': 'Quarter 1'});
                    component.set('v.MonthValue','Quarter 1');
                    if(component.get("v.SubmitMonths") == true){
                        MonthOption.push({'label': 'II kwartał lipiec-wrzesień', 'value': 'Quarter 2'});
                   component.set('v.MonthValue','Quarter 2');
                    }
                }
            
            component.set('v.Months',MonthOption);
           // component.set('v.MonthValue','None');
        }else{
            var MonthOption=[] ;
           // MonthOption.push({'label': 'None', 'value': 'None'});
            MonthOption.push({'label': 'I kwartał kwiecień-czerwiec', 'value': 'Quarter 1'});
            MonthOption.push({'label': 'II kwartał lipiec-wrzesień', 'value': 'Quarter 2'});
           MonthOption.push({'label': 'III kwartał październik-grudzień', 'value': 'Quarter 3'});
          MonthOption.push({'label': 'IV kwartał styczeń-marzec', 'value': 'Quarter 4'});
            component.set('v.Months',MonthOption);
            component.set('v.MonthValue','Quarter 4');
        }
        component.set('v.yearValue',event.getParam("value"));
        component.set('v.loaded', false);
        component.get("v.chart").destroy();
        helper.scripts(component, event);
        
    },
    
    handleMonthChange : function(component, event, helper) {
         component.set('v.MonthValue',event.getParam("value"));
         component.set('v.loaded', false);
        component.get("v.chart").destroy();
        helper.scripts(component, event);
    },
    
    
    scriptsLoaded : function(component, event, helper) {
        helper.scripts(component, event);
    },
    
   // emptyStocks : function(component, event, helper) {
  //      component.set('v.ExcludeEmptyStock', component.find("toggleButton").get("v.checked"));
  //      component.set('v.loaded', false);
   //     component.get("v.chart").destroy();
   //     helper.scripts(component, event);
  //  },
    
    
    handleComponentEvent: function(component, event, helper) {
         
       
        var valueFromChild = event.getParam("SelectedDistributor");
         var count = event.getParam("count");
        
        var dis = [];
         component.set('v.SelecteddescriptionList', dis);
        if(count > 0){      
        for (let i = 0; i < valueFromChild.length; i++) {
            if(JSON.stringify(valueFromChild[i]).includes('selected')){
                if(valueFromChild[i].selected == true){
                   dis.push(valueFromChild[i].value); 
                }
              }
        }
        }else{
            dis = [];
        }
        
        
        component.set('v.SelectedDisList', dis);
         
        var a = component.get('c.onBrandChange');
        $A.enqueueAction(a);
        
        component.set('v.loaded', false);
        component.get("v.chart").destroy();
        
        helper.scripts(component, event);
    },
    
    handleComponentEvent2: function(component, event, helper) {
        var valueFromChild = event.getParam("SelectedDistributor");
         var count = event.getParam("count");
        //alert(valueFromChild);
        var dis = [];
        if(count > 0){      
        for (let i = 0; i < valueFromChild.length; i++) {
            if(JSON.stringify(valueFromChild[i]).includes('selected')){
                if(valueFromChild[i].selected == true){
                   dis.push(valueFromChild[i].value); 
                }
              }
        }
        }else{
            dis = [];
        }
        
        
        component.set('v.SelecteddescriptionList', dis);
       
        
        component.set('v.loaded', false);
        component.get("v.chart").destroy();
        
        helper.scripts(component, event);
    }
    
})