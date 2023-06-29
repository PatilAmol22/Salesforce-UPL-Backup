({
    scripts : function(component, event, helper) {   
        
        if(!window.location.hash) {
		window.location = window.location + '#loaded';
		window.location.reload();
	}
        
        var action = component.get("c.getDonData");
        action.setParams({ "Distributors" : component.get('v.SelectedDisList'),"description" : component.get('v.SelecteddescriptionList'),"customer" : component.get('v.SelectedDistributorList')});
        
        action.setCallback(this, function(data) {
            var state = data.getState();
            console.log('CreditDonutstate===',state);
            
            if (state === "SUCCESS") {
                component.set('v.loaded', true);
                let val = data.getReturnValue();
                if(data.getReturnValue().isSuccess == false){
                    component.set('v.error', false);
                    component.set('v.Message', data.getReturnValue().Message);
                }else{
                    //component.set("v.ChartList",val[0].Total.toLocaleString('en-IN'));
                    console.log('Result---',val);
                    console.log('Result.length---',val);
                    
                    if(val.length <=0){
                        component.set("v.error",false);
                        component.set("v.Message",$A.get("$Label.c.Grz_NoDataForThisComb"));
                    }else{
                        component.set("v.error",true);
                    }
                    
                    var testarr = [];
                    for(var i = 0; i<val.length;i++){
                        var DecimalToCommaSep = val[i].value;
                        var n = DecimalToCommaSep.toLocaleString('en-IN');
                        testarr.push({name: val[i].name, value: n});
                    }
                    component.set("v.creditList",testarr);
                    var labelset=[] ;
                    var dataset=[] ;
                    var datasetNegative =[];
                    var colorset=[];
                    // colorset.push(val[0].UtilizedColor);
                    //colorset.push(val[0].PendingColor);
                    //colorset.push("#FF8833");
                    //colorset.push("#34B845");
                    component.set("v.colorset",colorset);
                    val.forEach(function(key) {
                        labelset.push(key.name) ;
                        dataset.push(key.value.toString().replace('-','')) ; 
                        datasetNegative.push(key.value.toString())
                    });
                    console.log('dataset',dataset);
                    console.log('datasetNegative',datasetNegative);
                    component.set("v.showDataNegative",datasetNegative);
                    component.set("v.showData",dataset);
                    
                    var colorsarr = [];
                    for(var i = 0 ; i<= val.length; i++){
                        var randomColor = Math.floor(Math.random()*16777215).toString(16);
                        colorsarr.push("#" + randomColor);
                    }
                    var chart = new Chart(document.getElementById("pie-chart"), {
                        type: 'bar',
                        data: {
                            labels:labelset,
                            datasets: [{
                                dataset:  component.get("v.showDataNegative"),
                                label: $A.get("$Label.c.GRZ_DistributorInventoryCount"),
                                backgroundColor: 'rgba(75, 192, 192, 0.5)',
                                borderColor :  'rgb(75, 192, 192)',
                                borderWidth: 2,
                                // backgroundColor :colorsarr,
                                data: component.get("v.showData")
                            }]
                        }
                        ,
                        options: {
                            title: {
                                display: false,
                                text: 'Credit Info Records'
                            },
                            scales: {
                                xAxes: [{
                                    barPercentage: 0.9
                                }]
                            }
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
                    });
                    component.set("v.chart",chart);
                }
            }
        });
        $A.enqueueAction(action);
    },
})