({
    scripts : function(component, event, helper) {      
        var action = component.get("c.getDonData");
        console.log('companycode ==', component.get("v.valueOfSalesOrg"));
        action.setParams({ companyCode : component.get("v.valueOfSalesOrg") });
        console.log('action=='+action);
        action.setCallback(this, function(data) {
            var state = data.getState();
            console.log('CreditDonutstate===',state);
            console.log('Dserr1',data.getReturnValue().errorMessage);
             console.log('Dserr2',data.getReturnValue().isSuccess);
            if (state === "SUCCESS") {
                component.set('v.loaded', true);
                let val = data.getReturnValue().Results;
                console.log('India Credit Data : ',val);
                if(data.getReturnValue().isSuccess == false && data.getReturnValue().errorMessage == 'False'){  //Updated for INC0414972 GRZ(Dheeraj Sharma) 18-11-2022
                    $A.get('e.force:refreshView').fire(); //Updated for INC0414972 GRZ(Dheeraj Sharma) 18-11-2022    
                   
                }else
                    if(data.getReturnValue().isSuccess == false){ //Updated for INC0414972 GRZ(Dheeraj Sharma) 18-11-2022
                    component.set('v.error', false);//Updated for INC0414972 GRZ(Dheeraj Sharma) 18-11-2022
                    component.set('v.Message', data.getReturnValue().Message);//Updated for INC0414972 GRZ(Dheeraj Sharma) 18-11-2022
                }else{
                    component.set('v.error', true);
                    component.set("v.ChartList",val[0].Total.toLocaleString('en-IN'));
                    
                    console.log('data.getReturnValue().isSuccess'+data.getReturnValue().isSuccess);
                    console.log('data.getReturnValue().Message'+data.getReturnValue().Message);
                    console.log('val===',val);
                    
                    console.log('123===',component.get("v.Utilized"));
                    console.log('124===',component.get("v.Pending"));
                    console.log('Result---',val[0].cateListWrap);
                    
                    // val[0].cateListWrap[0].value =  '-'+val[0].cateListWrap[0].value;
                    // val[0].cateListWrap[1].value =  '-'+val[0].cateListWrap[1].value;
                    
                    var testarr = [];
                    for(var i = 0; i<val[0].cateListWrap.length;i++){
                        var DecimalToCommaSep = val[0].cateListWrap[i].value;
                        console.log(DecimalToCommaSep);
                        var n = DecimalToCommaSep.toLocaleString('en-IN');
                        console.log(n);
                        testarr.push({name: val[0].cateListWrap[i].name, value: n});
                    }
                    component.set("v.creditList",testarr);
                    console.log('test---1',component.get("v.creditList"));
                    var labelset=[] ;
                    var dataset=[] ;
                    var datasetNegative =[];
                    var colorset=[];
                    // colorset.push(val[0].UtilizedColor);
                    //colorset.push(val[0].PendingColor);
                    colorset.push("#FF8833");
                    colorset.push("#34B845");
                    console.log('colorset--',colorset);
                    component.set("v.colorset",colorset);
                    val[0].cateListWrap.forEach(function(key) {
                        labelset.push(key.name) ;
                        //let text = key.value.replace('-','');
                        dataset.push(key.value.toString().replace('-','')) ; 
                        datasetNegative.push(key.value.toString())
                    });
                    console.log('dataset',dataset);
                    console.log('datasetNegative',datasetNegative);
                    component.set("v.showDataNegative",datasetNegative);
                    component.set("v.showData",dataset);
                    var a = new Chart(document.getElementById("pie-chart"), {
                        type: 'doughnut',
                        data: {
                            labels:labelset,
                            datasets: [{
                                dataset:  component.get("v.showDataNegative"),
                                label: "Count of Credit Info",
                                backgroundColor: ["#F47920", "#4CCF5D"],
                                data: component.get("v.showData")
                            }]
                        },
                        options: {
                            title: {
                                display: false,
                                text: 'Credit Info Records'
                            }
                        },
                        tooltips: {
                            callbacks: {
                                label: function(tooltipItem, data) {
                                    var datasetIndex = tooltipItem.datasetIndex;
                                    console.log('datasetIndex',datasetIndex);
                                    var index = tooltipItem.index;
                                    var entry =  data.datasets[datasetIndex].dataset[index];
                                    console.log('entry',entry);
                                    return `${entry} `;
                                }
                            }
                        }
                    });
                    
                    //INC0418863 Grazitti
                     component.set("v.chart",a);
                }
                
                
                
            }
        });
        $A.enqueueAction(action);
    },

    scriptsMexico: function(component, event, helper){
        
        var action = component.get("c.getDonDataMexico");
        action.setCallback(this, function(data) {
            var state = data.getState();
            console.log('CreditDonutstate===',state);
            if (state === "SUCCESS") {
                component.set('v.loaded', true);
                let val = data.getReturnValue().Results;
                console.log('Mexico Credit Chart Data : ', data);
                component.set("v.CreditDetailList",data.getReturnValue().creditDetailData[0]);
                if(data.getReturnValue().isSuccess == false){
                    component.set('v.error', false);
                    component.set('v.Message', data.getReturnValue().Message);
                }
                if(null!= val && val!= undefined)
                {
                    console.log('val==>',val);
                    component.set("v.ChartList",val[0].Total.toLocaleString('es-MX'));
                    //component.set("v.ChartList",val[0].Total);
                    var testarr = [];
                    for(var i = 0; i<val[0].cateListWrap.length;i++){
                        var DecimalToCommaSep = val[0].cateListWrap[i].value;
                        var n = DecimalToCommaSep.toLocaleString('es-MX');
                        //var n = DecimalToCommaSep;
                        testarr.push({name: val[0].cateListWrap[i].name, value: n});
                    }
                    console.log('testarr[0]>>>>>>',testarr[0]);
                    console.log('testarr[1]>>>>>>',testarr[1]);
                    var var1 = parseFloat(testarr[0].value.replaceAll(',',''));
                    var var2 = parseFloat(testarr[1].value.replaceAll(',',''));
                    console.log('var1==>'+var1);
                    console.log('var2==>'+var2);
                    
                    var exceededCheck = (var1 + var2);
                    console.log('exceededCheck>>>',exceededCheck);
                    console.log('Label.c.Grz_Creditexceeded>>>',$A.get("$Label.c.Grz_Creditexceeded"))
                    // var exceededCheck = 1
                    if(exceededCheck!=0)
                    {
                        var check = (var1/exceededCheck)*100;
                        //var check = 90
                        if(check > $A.get("$Label.c.Grz_Creditexceeded"))
                        {
                            component.set("v.exceeded",true);
                        }
                        console.log('check>>>>>',check);
                    }
                    
                    
                    
                    component.set("v.creditList",testarr);
                    console.log('test---1',component.get("v.creditList"));
                    
                    var labelset=[] ;
                    var dataset=[] ;
                    var colorset=[];
                    var datasetNegative =[];
                    // colorset.push(val[0].UtilizedColor);
                    //colorset.push(val[0].PendingColor);
                    colorset.push("#FF8833");
                    colorset.push("#34B845");
                    console.log('colorset--',colorset);
                    component.set("v.colorset",colorset);
                    val[0].cateListWrap.forEach(function(key) {
                        labelset.push(key.name) ; 
                        datasetNegative.push(key.value.toString()) ; 
                        dataset.push(key.value.toString().replace('-','')) ;
                    });
                }
                component.set("v.showData",dataset);
                component.set("v.showDataNegative",datasetNegative);
                
                new Chart(document.getElementById("pie-chart"), {
                    type: 'doughnut',
                    data: {
                        labels:labelset,
                        datasets: [{
                            dataset:  component.get("v.showDataNegative"),
                            label: "Count of Credit Info",
                            backgroundColor: ["#F47920", "#4CCF5D"],
                            data: dataset
                        }]
                    },
                    options: {
                        title: {
                            display: false,
                            text: 'Credit Info Records'
                        }
                    },
                    tooltips: {
                        callbacks: {
                            label: function(tooltipItem, data) {
                                var datasetIndex = tooltipItem.datasetIndex;
                                console.log('datasetIndex',datasetIndex);
                                var index = tooltipItem.index;
                                var entry =  data.datasets[datasetIndex].dataset[index];
                                return `${entry.name} `;
                            }
                        }
                    }
                });
                
            }
        });
        $A.enqueueAction(action);
    },
    
    scriptsArgentina: function(component, event, helper){
        
        var action = component.get("c.getDonDataArgentina");
        action.setCallback(this, function(data) {
            var state = data.getState();
            console.log('CreditDonutstate===',state);
            if (state === "SUCCESS") {
                component.set('v.loaded', true);
                let val = data.getReturnValue().Results;
                console.log('Mexico Credit Chart Data : ', data);
                component.set("v.CreditDetailList",data.getReturnValue().creditDetailData[0]);
                if(data.getReturnValue().isSuccess == false){
                    component.set('v.error', false);
                    component.set('v.Message', data.getReturnValue().Message);
                }
                if(null!= val && val!= undefined)
                {
                    console.log('val==>',val);
                    component.set("v.ChartList",val[0].Total.toLocaleString('es-MX'));
                    //component.set("v.ChartList",val[0].Total);
                    var testarr = [];
                    for(var i = 0; i<val[0].cateListWrap.length;i++){
                        var DecimalToCommaSep = val[0].cateListWrap[i].value;
                        var n = DecimalToCommaSep.toLocaleString('es-MX');
                        //var n = DecimalToCommaSep;
                        testarr.push({name: val[0].cateListWrap[i].name, value: n});
                    }
                    console.log('testarr[0]>>>>>>',testarr[0]);
                    console.log('testarr[1]>>>>>>',testarr[1]);
                    var var1 = parseFloat(testarr[0].value.replaceAll(',',''));
                    var var2 = parseFloat(testarr[1].value.replaceAll(',',''));
                    console.log('var1==>'+var1);
                    console.log('var2==>'+var2);
                    
                    var exceededCheck = (var1 + var2);
                    console.log('exceededCheck>>>',exceededCheck);
                    console.log('Label.c.Grz_Creditexceeded>>>',$A.get("$Label.c.Grz_Creditexceeded"))
                    // var exceededCheck = 1
                    if(exceededCheck!=0)
                    {
                        var check = (var1/exceededCheck)*100;
                        //var check = 90
                        if(check > $A.get("$Label.c.Grz_Creditexceeded"))
                        {
                            component.set("v.exceeded",true);
                        }
                        console.log('check>>>>>',check);
                    }
                    
                    
                    
                    component.set("v.creditList",testarr);
                    console.log('test---1',component.get("v.creditList"));
                    
                    var labelset=[] ;
                    var dataset=[] ;
                    var colorset=[];
                    var datasetNegative =[];
                    // colorset.push(val[0].UtilizedColor);
                    //colorset.push(val[0].PendingColor);
                    colorset.push("#FF8833");
                    colorset.push("#34B845");
                    console.log('colorset--',colorset);
                    component.set("v.colorset",colorset);
                    val[0].cateListWrap.forEach(function(key) {
                        labelset.push(key.name) ; 
                        datasetNegative.push(key.value.toString()) ; 
                        dataset.push(key.value.toString().replace('-','')) ;
                    });
                }
                component.set("v.showData",dataset);
                component.set("v.showDataNegative",datasetNegative);
                
                new Chart(document.getElementById("pie-chart"), {
                    type: 'doughnut',
                    data: {
                        labels:labelset,
                        datasets: [{
                            dataset:  component.get("v.showDataNegative"),
                            label: "Count of Credit Info",
                            backgroundColor: ["#F47920", "#4CCF5D"],
                            data: dataset
                        }]
                    },
                    options: {
                        title: {
                            display: false,
                            text: 'Credit Info Records'
                        }
                    },
                    tooltips: {
                        callbacks: {
                            label: function(tooltipItem, data) {
                                var datasetIndex = tooltipItem.datasetIndex;
                                console.log('datasetIndex',datasetIndex);
                                var index = tooltipItem.index;
                                var entry =  data.datasets[datasetIndex].dataset[index];
                                return `${entry.name} `;
                            }
                        }
                    }
                });
                
               
                
            }
        });
        $A.enqueueAction(action);
    },
    
    
    /*  ChangeMethod : function(component, event, helper) {
        component.get("v.chart").destroy();
           console.log(event.getParam("value"));
         component.set("v.SalesOrgDefaultVal",event.getParam("value"));
        
        
         var colorset=[];
                colorset.push("#FF8833");
                colorset.push("#34B845");
                component.set("v.colorset",colorset);
                
                
                var CredContArea = '';
                    for(var i = 0; i< component.get("v.MetaMapping").length; i++){
                        if(component.get("v.SalesOrgDefaultVal") == component.get("v.MetaMapping")[i].MasterLabel)
                        {
                            CredContArea = component.get("v.MetaMapping")[i].Credit_Control_Area__c;
                        }
               }
                
                console.log("CredContArea-->>",CredContArea);
                for(var i = 0; i< component.get("v.response").length; i++)
                {
                    if(component.get("v.response")[i].Creditcontrolarea == CredContArea)
                    {
                        component.set("v.ChartList",parseFloat(component.get("v.response")[i].Creditlimit).toLocaleString('en-IN'));
                        
                        var testarr = [];
                        testarr.push({name: $A.get("$Label.c.Grz_CreditUtilized"), value: parseFloat(component.get("v.response")[i].UsedLimit).toLocaleString('en-IN')});
                        testarr.push({name: $A.get("$Label.c.Grz_CreditPending"), value: parseFloat(component.get("v.response")[i].BalanceLimit).toLocaleString('en-IN')});
                        
                        component.set("v.creditList",testarr);
                        
                        var labelset=[] ;
                        var dataset=[] ; 
                        var datasetNegative = [];
                        labelset.push($A.get("$Label.c.Grz_CreditUtilized")) ; 
                        labelset.push($A.get("$Label.c.Grz_CreditPending")) ; 
                        dataset.push(component.get("v.response")[i].UsedLimit.replace('-','')) ; 
                        dataset.push(component.get("v.response")[i].BalanceLimit.replace('-','')) ; 
                        datasetNegative.push(component.get("v.response")[i].UsedLimit);
                        datasetNegative.push(component.get("v.response")[i].BalanceLimit);
                        
                        component.set("v.showData",dataset);
                          component.set("v.showDataNegative",datasetNegative);
                        break;
                    } else{
                        component.set("v.ChartList",'0'.toLocaleString('en-IN'));
                        var testarr = [];
                        testarr.push({name: $A.get("$Label.c.Grz_CreditUtilized"), value: '0'});
                        testarr.push({name: $A.get("$Label.c.Grz_CreditPending"), value: '0'});
                        component.set("v.creditList",testarr);
                        
                        var labelset=[] ;
                        var dataset=[] ;
                        labelset.push($A.get("$Label.c.Grz_CreditUtilized")) ;
                        labelset.push($A.get("$Label.c.Grz_CreditPending")) ;  
                        console.log("labelset--->>",labelset);
                        dataset.push(0) ; 
                        dataset.push(0) ; 
                        console.log("dataset--->>",dataset);
                        component.set("v.showData",dataset);
                        console.log("component.getv.showDat->>",component.get("v.showData"));
                    }
                    
                   
                }
                
                
                
                var chart = new Chart(document.getElementById("pie-chart"), {
                    type: 'doughnut',
                    data: {
                        labels:labelset,
                        datasets: [{
                             dataset:  component.get("v.showDataNegative"),
                            label: "Count of Credit Info",
                            backgroundColor: ["#F47920", "#4CCF5D"],
                            data: component.get("v.showData")
                        }]
                    },
                    options: {
                        title: {
                            display: false,
                            text: 'Credit Info Records'
                        },
                         tooltips: {
                            callbacks: {
                                label: function(tooltipItem, data) {
                                    var datasetIndex = tooltipItem.datasetIndex;
                                    var index = tooltipItem.index;
                                    var entry =  data.datasets[datasetIndex].dataset[index];
                                   return `${entry} `;
                                }
                            }
                        }
                    }
                });
          component.set("v.chart",chart);
                
           
    }, */
    
    scriptsBrazil : function(component, event, helper) {		
        var action = component.get("c.getDonDataBrazil");
        console.log('action=='+action);
        action.setCallback(this, function(data) {
            var state = data.getState();
            console.log('CreditDonutstate===',state);
            
            if (state === "SUCCESS") {
                component.set('v.loaded', true);
                let val = data.getReturnValue().Results;
                component.set("v.CreditDetailList",data.getReturnValue().creditDetailData[0]);
                if(data.getReturnValue().isSuccess == false){
                    component.set('v.error', false);
                    component.set('v.Message', data.getReturnValue().Message);
                }
                component.set("v.ChartList",val[0].Total.toLocaleString('pt-BR'));
                //component.set("v.ChartList",val[0].Total);
                var testarr = [];
                for(var i = 0; i<val[0].cateListWrap.length;i++){
                    var DecimalToCommaSep = val[0].cateListWrap[i].value;
                    var n = DecimalToCommaSep.toLocaleString('pt-BR');
                    //var n = DecimalToCommaSep;
                    testarr.push({name: val[0].cateListWrap[i].name, value: n});
                }
                component.set("v.creditList",testarr);
                console.log('test---1',component.get("v.creditList"));
                var labelset=[] ;
                var dataset=[] ;
                var colorset=[];
                // colorset.push(val[0].UtilizedColor);
                //colorset.push(val[0].PendingColor);
                colorset.push("#FF8833");
                colorset.push("#34B845");
                console.log('colorset--',colorset);
                component.set("v.colorset",colorset);
                val[0].cateListWrap.forEach(function(key) {
                    labelset.push(key.name) ; 
                    dataset.push(key.value) ; 
                });
                
                new Chart(document.getElementById("pie-chart"), {
                    type: 'doughnut',
                    data: {
                        labels:labelset,
                        datasets: [{
                            label: "Count of Credit Info",
                            backgroundColor: ["#F47920", "#4CCF5D"],
                            data: dataset
                        }]
                    },
                    options: {
                        title: {
                            display: false,
                            text: 'Credit Info Records'
                        }
                    }
                });
                
            }
        });
        $A.enqueueAction(action);
        
    },
    
    
    scriptsChile : function(component, event, helper) {
        //  component.get("v.chartChile").destroy();
        component.set('v.error',true);
        component.set('v.Message','');
        var action = component.get("c.getDonDataChile");
        action.setParams({ cusNumber : component.get("v.cusNumber") });
        action.setCallback(this, function(data) {
            var state = data.getState();
            console.log('CreditDonutstate===',state);
            console.log('data.getReturnValue()===',data.getReturnValue());
            
            if (state === "SUCCESS") {
                component.set('v.isInternal', data.getReturnValue().isInternal);
                component.set('v.loaded', true);
                let val = data.getReturnValue().Results;
                component.set("v.CreditDetailList",data.getReturnValue().creditDetailData[0]);
                if(data.getReturnValue().isSuccess == false){
                    component.set('v.error', false);
                    component.set('v.Message', data.getReturnValue().Message);
                }
                component.set("v.ChartList",val[0].Total.toLocaleString('es'));
                //component.set("v.ChartList",val[0].Total);
                var testarr = [];
                for(var i = 0; i<val[0].cateListWrap.length;i++){
                    var DecimalToCommaSep = val[0].cateListWrap[i].value;
                    var n = DecimalToCommaSep.toLocaleString('es');
                    //var n = DecimalToCommaSep;
                    testarr.push({name: val[0].cateListWrap[i].name, value: n});
                }
                component.set("v.creditList",testarr);
                console.log('test---1',component.get("v.creditList"));
                var labelset=[] ;
                var dataset=[] ;
                var colorset=[];
                var datasetNegative =[];
                // colorset.push(val[0].UtilizedColor);
                //colorset.push(val[0].PendingColor);
                colorset.push("#FF8833");
                colorset.push("#34B845");
                console.log('colorset--',colorset);
                component.set("v.colorset",colorset);
                val[0].cateListWrap.forEach(function(key) {
                    labelset.push(key.name) ; 
                    //dataset.push(key.value) ; 
                    datasetNegative.push(key.value.toString()) ; 
                    dataset.push(key.value.toString().replace('-','')) ;
                });
                component.set("v.showData",dataset);
                component.set("v.showDataNegative",datasetNegative);
                if(window.barChileCredit != undefined) {
                    window.barChileCredit.destroy();
                }
                window.barChileCredit =new Chart(document.getElementById("pie-chartChile"), {
                    type: 'doughnut',
                    data: {
                        labels:labelset,
                        datasets: [{
                            dataset:  component.get("v.showDataNegative"),
                            label: "Count of Credit Info",
                            backgroundColor: ["#F47920", "#4CCF5D"],
                            data: dataset
                        }]
                    },
                    options: {
                        title: {
                            display: false,
                            text: 'Credit Info Records'
                        }
                    },
                    tooltips: {
                        callbacks: {
                            label: function(tooltipItem, data) {
                                var datasetIndex = tooltipItem.datasetIndex;
                                console.log('datasetIndex',datasetIndex);
                                var index = tooltipItem.index;
                                var entry =  data.datasets[datasetIndex].dataset[index];
                                return `${entry.name} `;
                            }
                        }
                    }
                });
                component.set('v.chartChile',chart);
                
            }else{
                component.set('v.loaded', true);
                component.set('v.error', false);
                component.set('v.Message', 'Algo salió mal');
            }
        });
        $A.enqueueAction(action);
    },
    
    
})