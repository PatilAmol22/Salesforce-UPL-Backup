({
    createGraph : function(cmp, temp,language,validUser) {
        cmp.set("v.creditList",temp[0].cateListWrap);
        cmp.set("v.totalValue",temp[0].Total);
        var labelset=[] ;
        var dataset=[] ;
        var invdataset=[] ;
        cmp.get("v.creditList").forEach(function(key) {
            labelset.push(key.monthName); 
            dataset.push(key.orderAmount); 
        });
        var el = cmp.find('barChart').getElement();
        var ctx = el.getContext('2d'); 
        if(window.bar != undefined) {
            window.bar.destroy();
        }
        if(language == 'en_US'){
            window.bar = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labelset,
                    datasets: [
                        {
                            label: 'Order Amount History',
                            backgroundColor: "#f83",
                            data: dataset,
                            //borderColor: ["rgb(255, 99, 132)"],
                            borderWidth: 1
                        }
                    ]
                },
                responsive: true,
                maintainAspectRatio: true,
                barValueSpacing: 1,
                   
                    options: {
                      
                        scales: {
                            xAxes: [{
                                gridLines: {
                                    display:false
                                }
                            }],
                            yAxes: [{
                                ticks: {
                                    callback: function(value, index, values) {
                                     
                                       console.log('value123-----',value);
                                       if (value >= 1000000000) {
                                            var aNumber = parseFloat((value / 1000000000).toFixed(2)) + 'B';
                                            return aNumber;
                                       }
                                        
                                        if (value >= 1000000 && value < 1000000000 ) {
                                             
                                            var bNumber = parseFloat((value / 1000000)) + 'M';
                                           
                                            return 'INR '+ bNumber;
                                        }
                                        if (value >= 1000 && value < 1000000) {
                                            
                                            var cNumber = parseFloat((value / 1000)) + 'K';
                                            return 'INR ' + cNumber;
                                           
                                        }
                                        else{
                                            
                                            var sNumber = parseFloat(value.toFixed(2));
                                             return sNumber;
                                            
                                        }
                                      
                                        
                                    }
             
                                },
                                gridLines: {
                                    display:false
                                }
                               
                            }]
                        },
                        tooltips: {
                            callbacks: {
                                label: function(tooltipItem, data) {
                                return tooltipItem.yLabel.toLocaleString("en-US",{style:"currency", currency:"INR"});
                                }
                            }
                        }
                        
                    }
            });
        } 
       else if(language == 'es_MX'){
            window.bar = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labelset,
                    datasets: [
                        {
                            label: 'Historial de montos de pedidos',
                            backgroundColor: "#f83",
                            data: dataset,
                            //borderColor: ["rgb(255, 99, 132)"],
                            borderWidth: 1
                        }
                    ]
                },
                responsive: true,
                maintainAspectRatio: true,
                barValueSpacing: 1
            });
        }else if(language == 'es'){
            window.bar = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labelset,
                    datasets: [
                        {
                            label: 'Historial de montos de pedidos',
                            backgroundColor: "#f83",
                            data: dataset,
                            //borderColor: ["rgb(255, 99, 132)"],
                            borderWidth: 1
                        }
                    ]
                },
                responsive: true,
                maintainAspectRatio: true,
                barValueSpacing: 1
            });
        }else if (language == 'pt_BR'){
            if(validUser){
                cmp.set("v.invoiceList",temp[0].invoiceListWrap);
                cmp.set("v.totalInvoiceValue",temp[0].invTotal);
                cmp.get("v.invoiceList").forEach(function(key) { 
                    invdataset.push(key.invAmount); 
                });
                window.bar = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: labelset,
                        datasets: [
                            {
                                label: 'Histórico de pedidos',
                                
                                backgroundColor: "#675B58",
                                data: dataset,
                                borderWidth: 1
                                
                            },
                            {
                                label: 'Histórico de fatura',
                                backgroundColor: "#f83",
                                data: invdataset,
                                borderWidth: 1
                            }
                        ],
                    },
                    
                    responsive: true,
                    maintainAspectRatio: true,
                    barValueSpacing: 1,
                    //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
                    options: {
                      
                        scales: {
                            xAxes: [{
                                gridLines: {
                                    display:false
                                }
                            }],
                            yAxes: [{
                                ticks: {
                                    callback: function(value, index, values) {
                                      /*GRZ(Swaranjeet) : APPS-947 PO & Delivery Date :30-08-2022*/
                                       console.log('value123-----',value);
                                       if (value >= 1000000000) {
                                          	var aNumber = parseFloat((value / 1000000000).toFixed(2)).toLocaleString("pt-BR",{style:"currency", currency:"BRL",maximumFractionDigits:0, minimumFractionDigits:0}) + 'B';
                                       		return aNumber;
                                       }
                                        
                                        if (value >= 1000000 && value < 1000000000 ) {
                                             
                                            var bNumber = parseFloat((value / 1000000).toFixed(2)).toLocaleString("pt-BR",{style:"currency", currency:"BRL",maximumFractionDigits:0, minimumFractionDigits:0}) + 'M';
                                           
                                            return bNumber;
                                        }
                                        if (value >= 1000 && value < 1000000) {
                                            
                                             var cNumber = parseFloat((value / 1000).toFixed(2)).toLocaleString("pt-BR",{style:"currency", currency:"BRL",maximumFractionDigits:0, minimumFractionDigits:0}) + 'K';
                                            return cNumber;
                                           
                                        }
                                        else{
                                            
                                            var sNumber = parseFloat(value.toFixed(2)).toLocaleString("pt-BR",{style:"currency", currency:"BRL",maximumFractionDigits:0, minimumFractionDigits:0});
                                          	 return sNumber;
                                            
                                        }
                                      
                                        
                                    }
             
                                },
                                gridLines: {
                                    display:false
                                }
                               
                            }]
                        },
                        tooltips: {
                            callbacks: {
                                label: function(tooltipItem, data) {
                                return tooltipItem.yLabel.toLocaleString("pt-BR",{style:"currency", currency:"BRL"});
                                }
                            }
                        }
                        
                    }
                });
            }else{
            cmp.set("v.invoiceList",temp[0].invoiceListWrap);
            cmp.set("v.totalInvoiceValue",temp[0].invTotal);
            cmp.get("v.invoiceList").forEach(function(key) { 
                invdataset.push(key.invAmount); 
            });
            window.bar = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labelset,
                    datasets: [
                        {
                            label: 'Histórico de pedidos',
                            backgroundColor: "#f83",
                            data: dataset,
                            borderWidth: 1
                        },
                    ],
                },
                responsive: true,
                maintainAspectRatio: true,
                barValueSpacing: 1,
                
            });
            }
            
        }
    }
})