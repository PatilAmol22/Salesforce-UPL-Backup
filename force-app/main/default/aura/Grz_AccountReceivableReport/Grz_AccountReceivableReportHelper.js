({
    scriptsBrazil : function(component, event, helper) {	
        component.set('v.loaded', false);
        var action = component.get("c.getAccountReceivables");
        action.setParams({ 
            customerCode : component.get("v.customerCode"),
            sapUserId : component.get("v.sapUserId"),
            companyCode : component.get("v.companyCode"),
            distributorValue : component.get("v.distributorValuep"),
            subGroupId : component.get("v.subGroupValue"),
        });
        action.setCallback(this, function(data) {
            var state = data.getState();
            console.log('ARstate===>',state);
            if (state === "SUCCESS") {
                if(data.getReturnValue().isSuccess){
                    component.set('v.loaded', true);
                    let val = data.getReturnValue().ARWrap;
                    console.log('AR===>',val);
                    var testarr = [];
                    var showTitle = false;
                    if(val.length > 0){
                        component.set('v.nodatafound', false); 
                        showTitle = true;
                        for(var i = 0; i<val.length;i++){
                            testarr.push({name: val[i].name, value: val[i].value});
                        }
                        var labelset=[] ;
                        var dataset=[] ;
                        val.forEach(function(key) {
                            labelset.push(key.name) ; 
                            dataset.push(key.value) ; 
                        });
                        var legend = true;
                        if(labelset.length > 4){
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
                                    backgroundColor: ["#2f43c4","#F47920","#8f9091","#f7d642"],
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
                                //Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
                                tooltips: {
                                    callbacks: {
                                        label: function(tooltipItem, data) {
                                            let amt = data['datasets'][0]['data'][tooltipItem['index']];
                                            return data['labels'][tooltipItem['index']] + ': ' + amt.toLocaleString("pt-BR",{style:"currency", currency:"BRL"});
                                        }
                                    }  
                                }
                            },
                        });
                    }else{
                        component.set('v.nodatafound', true);
                        component.set('v.Message','Nenhum dado encontrado');
                        showTitle = false;
                    }
                    
                }else{
                    component.set('v.loaded', true);
                    if(window.doughnutType != undefined) {
                        window.doughnutType.destroy();
                    }
                    component.set('v.nodatafound', true); 
                    component.set('v.Message',data.getReturnValue().Message);
                }
            }else{
                component.set('v.loaded', true);
                component.set('v.nodatafound', true); 
                component.set('v.Message','Error: Please Contact System Admin');
            }
        });
        $A.enqueueAction(action);
    }
    
})