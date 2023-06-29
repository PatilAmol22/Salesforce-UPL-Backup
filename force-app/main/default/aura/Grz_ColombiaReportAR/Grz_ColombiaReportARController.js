({ 
    scriptsLoaded : function(component, event, helper) {
        component.set('v.loaded', false);
        var action = component.get("c.getAccountReceivables");
        action.setCallback(this, function(data) {
            var state = data.getState();
            console.log('ARstate===>',state);
            console.log('AR Response ===>',data.getReturnValue());
            if (state === "SUCCESS") {
                if(data.getReturnValue().success){
                    component.set('v.loaded', true);
                    let val = data.getReturnValue().ARReportWrap;
                    var testarr = [];
                    var showTitle = false;
                    if(val.length > 0){
                        component.set('v.nodatafound', false); 
                        showTitle = true;
                        var legend = true;
                        var labelset = [] ;
                        var dataset = [] ;
                        for(var i = 0; i < val.length; i++){
                            testarr.push({name: val[i].name, value: val[i].value});
                        }
                        val.forEach(function(key) {
                            labelset.push(key.name) ; 
                            dataset.push(key.value) ; 
                        });
                        if(labelset.length > 5){
                            legend = false;
                        }
                        if(window.doughnutType != undefined) {
                            window.doughnutType.destroy();
                        }
                        window.doughnutType = new Chart(document.getElementById("ARpie-charts"), {
                            type: 'doughnut',
                            data: {
                                labels:labelset,
                                datasets: [{
                                    backgroundColor: ["#7dcafa","#eb8033","#e75ae9","#e9cd52","#e52828"],
                                    data: dataset
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                legend: {
                                    position: 'top',
                                    display: legend,
                                    align:'right',
                                },
                                title: {
                                    display: showTitle,
                                },
                                tooltips: {
                                    callbacks: {
                                        label: function(tooltipItem, data) {
                                            let amt = data['datasets'][0]['data'][tooltipItem['index']];
                                            //return data['labels'][tooltipItem['index']] + ': ' + amt.toLocaleString("es-CO");
                                            return data['labels'][tooltipItem['index']] + ': ' + amt + ' %';
                                        }
                                    }  
                                }
                            },
                        });
                    }else{
                        component.set('v.nodatafound', true);
                        component.set('v.Message','Error while loading data.');
                        showTitle = false;
                    }
                }else{
                    component.set('v.loaded', true);
                    if(window.doughnutType != undefined) {
                        window.doughnutType.destroy();
                    }
                    component.set('v.nodatafound', true); 
                    component.set('v.Message',data.getReturnValue().message);
                }
            }else{
                component.set('v.loaded', true);
                component.set('v.nodatafound', true); 
                component.set('v.Message','Error while loading data.');
            }
        });
        $A.enqueueAction(action);
    },
})