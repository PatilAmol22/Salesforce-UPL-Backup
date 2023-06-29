({
    scriptsBrazil : function(component, event, helper) {		
        var action = component.get("c.getCaseStatusData");
        action.setParams({ 
            startDate : component.get("v.startDate"),
            endDate : component.get("v.endDate"),
            distributor : component.get("v.distributorValue"),
        });
        action.setCallback(this, function(data) {
            var state = data.getState();
            if (state === "SUCCESS") {
                component.set('v.loaded', true);
                let val = data.getReturnValue().Results;
                var testarr = [];
                var showTitle = false;
                if(val[0].cateListWrap.length > 0){
                    component.set('v.nodatafound', false); 
                    showTitle = true;
                }else{
                    component.set('v.nodatafound', true);
                    showTitle = false;
                }
                for(var i = 0; i<val[0].cateListWrap.length;i++){
                    testarr.push({name: val[0].cateListWrap[i].name, value: val[0].cateListWrap[i].value});
                }
                var labelset=[] ;
                var dataset=[] ;
                var chartTitle = 'Atendimento Total: '+ val[0].Total.toLocaleString('pt-BR');
                val[0].cateListWrap.forEach(function(key) {
                    //let str = key.name.substring(0, 10) +'...';
                    labelset.push(key.name) ; 
                    dataset.push(key.value) ; 
                });
                var legend = true;
                if(labelset.length > 4){
                    legend = false;
                }
                if(window.doughnutStatus != undefined) {
                    window.doughnutStatus.destroy();
                }
                window.doughnutStatus = new Chart(document.getElementById("pie-charts-status"), {
                    type: 'doughnut',
                    data: {
                        labels:labelset,
                        datasets: [{
                            backgroundColor: ["#F47920", "#4CCF5D","#FFD700","#DC143C","#00FFFF","#C0C0C0","#0000FF","#808080","#00008B","#000000","#ADD8E6","#FFA500","#800080","#A52A2A","#FFFF00","#800000","#00FF00","#008000","#FF00FF","#808000","#FFC0CB","#7FFD4","#FF1493"],
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
                            text: chartTitle
                        }
                    },
                });
            }
        });
        $A.enqueueAction(action);
    }
    
})