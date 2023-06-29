({
    createMexicoArChart : function(component, event, helper) {
        var defaultunput = 'HomePageArGraph';
        var action = component.get("c.getMexicoArData");
        action.setParams({ 
                executedfrom : defaultunput
        });
        action.setCallback(this, function(data) {
            var state = data.getState();
            console.log('getMexicoArData  State === ',state);
            
            if (state === "SUCCESS") {
                component.set('v.loaded', true);
                let result = data.getReturnValue();
                console.log('getMexicoArData  result === ',result);
                if(result.isSuccess == false){
                    component.set('v.error', false);
                    component.set('v.Message', result.Message);
                    console.log('getAccountStatementData  ===',result.Message);
                }
                else{
                    /*component.set("v.OpeningBalance",result.OpeningBalance);
                    component.set("v.ClosingBalance",result.ClosingBalance);
                    */
                    if(result.totalOverdue =='0.00' && result.notYetDue == '0.00'){
                        component.set('v.IsCreditDebitTotal', true);
                    }
                    
                    component.set("v.TotalOverdue",result.totalOverdue);
                    component.set("v.NotYetDue",result.notYetDue);                
                    var NotDueAndOverdueLabels = [];
                    NotDueAndOverdueLabels.push($A.get("$Label.c.Grz_NotDueAndOverdueLabels").split(","));
                    console.log('NotDueAndOverdueLabels : ',NotDueAndOverdueLabels[0]);
                    component.set("v.NotDueAndOverdueLabels",NotDueAndOverdueLabels[0]);
                    var openClosingBalanceLabels = [];
                    openClosingBalanceLabels.push($A.get("$Label.c.Grz_OpenClosingBalance").split(","));
                    component.set("v.OpenClosingBalanceLabels",openClosingBalanceLabels[0]);
                    
                    var labelset=[] ;
                    var dataset=[] ;
                    labelset.push(NotDueAndOverdueLabels[0][0]);
                    labelset.push(NotDueAndOverdueLabels[0][1]);
                    console.log('labelset : ',labelset);
                    dataset.push(result.totalOverdue);
                    dataset.push(result.notYetDue);
                    
                    var chart = new Chart(document.getElementById("pie-chartMexicoArStat"), {
                        type: 'doughnut',
                        data: {
                            labels:labelset,
                            datasets: [{
                                //dataset:  component.get("v.showDataNegative"),
                                label: "Account Info",
                                backgroundColor: ["#0000FF", "#FFFF00"],
                                data: dataset
                            }]
                        },
                        options: {
                            title: {
                                display: false,
                                text: 'Account  Info'
                            }
                        }
                    });
                    
                    component.set("v.chart",chart);
                }
            }
        });
        $A.enqueueAction(action);
    }
})