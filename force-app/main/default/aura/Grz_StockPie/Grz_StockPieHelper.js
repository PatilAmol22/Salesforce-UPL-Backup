({
    scriptsBrazil: function (component, event, helper) {
        var action = component.get("c.getStockData");
        action.setParams({
            distributor: component.get("v.distributorValuep"),
            subGroupId: component.get("v.subGroupValue"), //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
        });
        action.setCallback(this, function (data) {
            var state = data.getState();
            if (state === "SUCCESS") {
                component.set("v.loaded", true);
                let val = data.getReturnValue().ChartValue;
                let val1 = data.getReturnValue();
                component.set("v.isParentBr", val1.isParentBr);
                component.set("v.isMainParent", val1.isMainParent);//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022

                if (val1.isParentBr) {
                    let distr = val1.taxMap;
                    let cstCode = [];
                    const opt = {
                        label: "Todos",
                        value: "All",
                    };
                    cstCode = [...cstCode, opt];
                    /**start* GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022*/
                    for (let i = 0; i < distr.length; i++) {
                        let arr = distr[i].split(" - ");
                        const option = {
                            label:
                                arr[2].substr(0, 12) +
                                " - " +
                                arr[3].substr(0, 12) +
                                " - " +
                                arr[1].substr(arr[1].length - 7),
                            value: distr[i].substr(0, distr[i].indexOf(" -")),
                        };
                        cstCode = [...cstCode, option];
                    }
                    /*---------------------End----------------------------------*/
                    component.set("v.distributorOptionsBr", cstCode);
                }
                /*----Start--------Added main parent filter list logic, GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022*/
                if (val1.isMainParent) {
                    let distr = val1.subGroupData;
                    let cstCode = [];
                    for (let i = 0; i < distr.length; i++) {
                        let arr = distr[i].split(" - ");
                        const option = {
                            label:
                                arr[2].substr(0, 12) +
                                " - " +
                                arr[3].substr(0, 12) +
                                " - " +
                                arr[1].substr(arr[1].length - 7),
                            value: distr[i].substr(0, distr[i].indexOf(" -")),
                        };
                        cstCode = [...cstCode, option];
                    }
                    component.set("v.subGroupOptionsBr", cstCode);
                }
                /*---------------End------------------*/
                var testarr = [];
                var showTitle = false;
                if (val.length > 0) {
                    component.set("v.nodatafound", false);
                    showTitle = true;
                } else {
                    component.set("v.nodatafound", true);
                    showTitle = false;
                }
                for (var i = 0; i < val.length; i++) {
                    testarr.push({ name: val[i].name, value: val[i].value });
                }
                var labelset = [];
                var dataset = [];
                val.forEach(function (key) {
                    labelset.push(key.name);
                    dataset.push(key.value);
                });
                var legend = true;
                if (labelset.length > 4) {
                    legend = false;
                }
                if (window.donStock != undefined) {
                    window.donStock.destroy();
                }
                window.donStock = new Chart(
                    document.getElementById("stockpie-charts"),
                    {
                        type: "doughnut",
                        data: {
                            labels: labelset,
                            datasets: [
                                {
                                    backgroundColor: [
                                        "#2f43c4",
                                        "#F47920",
                                        "#8f9091",
                                        "#f7d642",
                                    ],
                                    data: dataset,
                                },
                            ],
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            legend: {
                                position: "top",
                                display: legend,
                                align: "right",
                            },
                            title: {
                                display: showTitle,
                            },
                            // Added for decimal seperator GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
                            tooltips: {
                                callbacks: {
                                    label: function (tooltipItem, data) {
                                        let amt =
                                            data["datasets"][0]["data"][
                                                tooltipItem["index"]
                                            ];
                                        return (
                                            data["labels"][
                                                tooltipItem["index"]
                                            ] +
                                            ": " +
                                            amt.toLocaleString("pt-BR", {
                                                style: "currency",
                                                currency: "BRL",
                                            })
                                        );
                                    },
                                },
                            },
                        },
                    }
                );
            }
        });
        $A.enqueueAction(action);
    },
});