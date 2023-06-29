({
	loadPieChart : function(component, event, helper) {
        var action = component.get("c.getTop10ProductCustomer");     
            action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let val = response.getReturnValue() ;
                var labelset=[] ;
                var dataset=[] ;
                val.forEach(function(key) {
                    labelset.push(key.label) ; 
                    dataset.push(key.count) ; 
                });
                new Chart(document.getElementById("doughnut-chart-products"), {
                    type: 'doughnut',
                    data: {
                        labels:labelset,
                        datasets: [{
                            label: "Count of Task",
                            backgroundColor: ["#00BFFF","#00008B","#ADD8E6","#52D726","#FFEC00","#FF7300","#007ED6","#8e5ea2","#3cba9f","#e8c3b9","#7CDDDD"],
                            data: dataset
                        }]
                    },
                    options: {
                        title: {
                            display: true,
                            text: 'Marca'
                        },
                        legend: {
            				display: true,
                            position: 'top'
         				}
                    }
                });
            }
        });
        $A.enqueueAction(action);
        
    }
})