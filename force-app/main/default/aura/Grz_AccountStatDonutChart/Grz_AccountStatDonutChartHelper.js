({
    createAccountStatChart : function(component, event, helper) {
        
        console.log('v.monthValue on load---------',component.get("v.monthValue"));
        var action = component.get("c.getAccountStatementData");
        action.setParams({ 
                monthValue : component.get("v.monthValue")
        	});
        action.setCallback(this, function(data) {
            var state = data.getState();
            console.log('getAccountStatementData  State === ',state);
            
            if (state === "SUCCESS") {
                component.set('v.loaded', true);
                let result = data.getReturnValue();
                console.log('getAccountStatementData  result === ',result);
                if(result.isSuccess == false){
                    component.set('v.error', false);
                    component.set('v.Message', result.msg);
                    console.log('getAccountStatementData  ===',result.msg);
                }
                else{
                    component.set("v.OpeningBalance",result.OpeningBalance);
                    component.set("v.ClosingBalance",result.ClosingBalance);
                    
                    if(result.totalCredit =='0.00' && result.totalDebit == '0.00'){
                        component.set('v.IsCreditDebitTotal', true);
                    }else{
                        component.set('v.IsCreditDebitTotal', false);
                    }
                    
                    component.set("v.TotalCredit",result.totalCredit);
                    component.set("v.TotalDebit",result.totalDebit);                
                    var creditDebitLabels = [];
                    creditDebitLabels.push($A.get("$Label.c.Grz_TotalCreditDebit").split(","));
                    console.log('CreditDebitLabels : ',creditDebitLabels[0]);
                    component.set("v.CreditDebitLabels",creditDebitLabels[0]);
                    var openClosingBalanceLabels = [];
                    openClosingBalanceLabels.push($A.get("$Label.c.Grz_OpenClosingBalance").split(","));
                    component.set("v.OpenClosingBalanceLabels",openClosingBalanceLabels[0]);
                    
                    var labelset=[] ;
                    var dataset=[] ;
                    labelset.push(creditDebitLabels[0][0]);
                    labelset.push(creditDebitLabels[0][1]);
                    console.log('labelset : ',labelset);
                    dataset.push(result.totalCredit);
                    dataset.push(result.totalDebit);
                    
                    if(window.chartAccountStat != undefined) {
            			window.chartAccountStat.destroy();
       				}
                    window.chartAccountStat = new Chart(document.getElementById("pie-chartAccountStat"), {
                        type: 'doughnut',
                        data: {
                            labels:labelset,
                            datasets: [{
                                //dataset:  component.get("v.showDataNegative"),
                                label: "Account Statement Info",
                                backgroundColor: ["#FFFF00", "#FF0000"],
                                data: dataset
                            }]
                        },
                        options: {
                            title: {
                                display: false,
                                text: 'Account Statement Info'
                            }
                        }
                    });
                    
                    component.set("v.chart",chartAccountStat);
                }
            }
        });
        $A.enqueueAction(action);
    }
})