({
    doInit: function (component, event, helper) {
        
        //var ch={"Branch":"REGIONAL TRIÂNGULO","BranchId":"a1B0K00000V4oKyUAJ","BU":"BU CENTRO","BUId":"a1M0K00000D2OmsUAF","Category_Name":"Transforma","color":"","Contract":"1013","Contract_date":"2021-11-03","ContractId":"a5S0K000000PuAnUAK","ContractTypeCode":"C","CRMStatus":"In Editing","CTC":"57001662 - RODRIGO SANCHES GATTO","curr":"BRL","Director":"CULTURAS EXTENSIVAS","DirectorId":"a1m0K000000f0PJQAY","DistAccepted":false,"Distributor":"COOP AGR UNAI LTDA","DistributorCode":"0001033619","DistributorCodeAndName":"0001033619 - COOP AGR UNAI LTDA","DistributorId":"0010K00001gyJpbQAE","element":"","Final_date":"2022-03-31","GrowthIndex":0.01,"GrowthRate":"20.2725458046058426696674808899446","Initial_date":"2021-04-01","isDisabled":true,"pStatus":"Ativo","salesRep":"0050K00000AxpDz","Status":"Cartas de Crédito em processo de emissão","TerritoryId":"a1L0K00000ioFc5UAE","TotalOtherValue":0,"TotalOtherValueLY":0,"TotalTypeValueLY":21390283.4,"TotalValue":25726638.4,"TotalValueLY":21390283.4,"Type":"Cooper Up"};
        var conId='';
        var contract=component.get("v.ContractHeader");
        var curUrl=window.location.href;
        console.log('curl================'+curUrl);
        console.log('contgra================'+JSON.stringify(contract));
        if(contract){
            conId=contract.ContractId;
            component.set("v.isOrg",true);
        }else{
            conId=curUrl.split('id=')[1];
            component.set("v.isOrg",false);
        }
        console.log('value is isisisisisisi '+ conId);
        var action = component.get("c.getgoalvsActualCalculations");
        //Set the Object parameters and Field Set name
        action.setParams({  
            contractId : conId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === 'SUCCESS'){
                console.log('successssssss');
                component.set("v.LoadingBalls", false)
                
                if(response.getReturnValue().error==true){
                    component.set("v.isError", true);
                     var error=  $A.get("$Label.c.REB_Error_Message");
                    component.find('notifLib').showToast({
                        "variant": "error",
                        "message": error,
                        
                    });
                }else{
                    
                //var ll=['Biossoluções','Complementares','Demais','Estratégicos','Premium','Outros'];
                component.set("v.valueMap", response.getReturnValue().PCategory);
                component.set("v.contract", response.getReturnValue().contract);
                component.set("v.valid", response.getReturnValue().valid);
                component.set("v.BU", response.getReturnValue().BU);
                var reLi=response.getReturnValue().liRebGoal; 
                component.set("v.PamProductList",reLi);
                console.log('contract are=== '+JSON.stringify(component.get("v.contract")));
                console.log('rebates are=== '+JSON.stringify(component.get("v.PamProductList")));
                 
                
                var a1 = component.get('c.changeObj');
                $A.enqueueAction(a1);
                }
                
            }else{
                console.log('errrrrrrrrrr');
            }
        });
        $A.enqueueAction(action);
                            component.set("v.isError", false);

        //helper.getProductCategory(component, event, helper);
    },
    
    Back: function (component, event, helper) {
        component.set("v.showCalculator",false);
        component.set("v.showHome",true);
                            component.set("v.isError", true);
    },
    Back1: function (component, event, helper) {
        component.set("v.confirm",!(component.get("v.confirm")));
        
    },
    changeObj: function (component, event, helper) {
        var reLi=component.get("v.PamProductList");
        component.set("v.PamProductList",[]);
        
        var upLi=[];
        reLi.forEach(function (item, index) {
            var obj = {
                Actual_Value__c: (item.Actual_Value__c?item.Actual_Value__c:0),
                Actual_Volume__c: (item.Actual_Volume__c?item.Actual_Volume__c:0),
                Brand_Name__c: item.Brand_Name__c,
                Product_Category__c: item.Product_Category__c,
                Name: item.Name,
                Rebate_Percent: item.Rebate_Percent,
                Net_Value__c: (item.Net_Value__c?item.Net_Value__c:0),
                Net_Volume__c: (item.Net_Volume__c?item.Net_Volume__c:0),
                Returns_Value__c: (item.Returns_Value__c?item.Returns_Value__c:0),
                Returns_Volume__c: (item.Returns_Volume__c?item.Returns_Volume__c:0),
                Value__c: (item.Value__c?item.Value__c:0),
                Volume__c: (item.Volume__c?item.Volume__c:0),
                Id: item.Id,
                OO_Value__c: (item.OO_Value__c?item.OO_Value__c:0),
                OO_Volume__c: (item.OO_Volume__c?item.OO_Volume__c:0),
                CO_Value__c: (item.CO_Value__c?item.CO_Value__c:0),
                CO_Volume__c: (item.CO_Volume__c?item.CO_Volume__c:0),
                NN_Value__c: (item.NN_Value__c?item.NN_Value__c:0),
                NN_Volume__c: (item.NN_Volume__c?item.NN_Volume__c:0),
                ND_Value__c: (item.ND_Value__c?item.ND_Value__c:0),
                ND_Volume__c: (item.ND_Volume__c?item.ND_Volume__c:0),
                get nn() {
                    return this.NN_Value__c*this.NN_Volume__c;
                },
                get nd() {
                    return this.ND_Value__c*this.ND_Volume__c;
                },
                get vPercent() {
                    if(this.Volume__c!==0){
                        var r1= ((this.Actual_Volume__c-this.Returns_Volume__c+this.OO_Volume__c-this.CO_Volume__c+this.NN_Volume__c-this.ND_Volume__c)/this.Volume__c);
                        if(r1>0)return r1; else return 0;
                    }else return 0; 
                },
                get bvo() {
                    if(this.vPercent>=0.8){
                        return this.Volume__c;
                    } else return 0;
                },
                get bva() {
                    if(this.vPercent>=0.8)return this.Value__c; else return 0;
                },
                get cvo() {
                    var v1=this.vPercent;
                    if(v1>=0.80 || v1==0)return (this.Actual_Volume__c-this.Returns_Volume__c+this.OO_Volume__c-this.CO_Volume__c+this.NN_Volume__c-this.ND_Volume__c);
                    else return 0;
                },
                get cva() {
                    var v1=this.vPercent;
                    if(v1>=0.80 || v1==0)return (this.Actual_Value__c-this.Returns_Value__c+this.OO_Value__c-this.CO_Value__c+this.nn-this.nd);
                    else return 0;
                },
                get per1() {
                    var v1=this.cva;
                    if(v1!=null)return ((this.Rebate_Percent*v1)/100);
                    else return 0;
                },
            };
            upLi.push(obj);
        });
        component.set("v.PamProductList", upLi);
        console.log('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'+JSON.stringify(upLi));
        var helper1 = {};
        var resultG = upLi.reduce(function(r, o) {
            var key = o.Product_Category__c;
            
            if(!helper1[key]) {
                helper1[key] = Object.assign({}, o); // create a copy of o
                r.push(helper1[key]);
            } else {
                helper1[key].Value__c += o.Value__c;
                helper1[key].Net_Value__c += o.Net_Value__c;
                helper1[key].Returns_Value__c += o.Returns_Value__c;
                helper1[key].Actual_Value__c += o.Actual_Value__c;
                helper1[key].OO_Value__c += o.OO_Value__c;
                helper1[key].CO_Value__c += o.CO_Value__c;
                helper1[key].nn += o.nn;
                helper1[key].nd += o.nd;
                helper1[key].bva += o.bva;
                helper1[key].cva += o.cva;
                helper1[key].per1 += o.per1;
                helper1[key].Rebate_Percent = o.Rebate_Percent;
            }
            
            return r;
        }, []);
        component.set("v.resultG", resultG);
        
        var appEvent = $A.get("e.c:RebateEvent");               
        appEvent.setParams({"parentVar":resultG});                                               
        appEvent.fire();
        console.log('sum groupings are are=== '+JSON.stringify(component.get("v.resultG")));
        
        
        var a=0,b=0,c=0,d=0,e=0,f=0,g=0,h=0,i=0,j=0,k=0;
        var helper2 = {};
                resultG.forEach(function (item, index) {

                    a += item.Value__c;
                    b += item.Net_Value__c;
                    c += item.Returns_Value__c;
                    d += item.Actual_Value__c;
                    e += item.OO_Value__c;
                    f += item.CO_Value__c;
                    g += item.nn;
                    h += item.nd;
                    i += item.bva;
                    j += item.cva;
                    k += item.per1;
                });
               	helper2.Value__c=a;helper2.Net_Value__c=b;helper2.Returns_Value__c=c;
        		helper2.Actual_Value__c=d;helper2.OO_Value__c=e;
        		helper2.CO_Value__c=f;helper2.nn=g;
        		helper2.nd=h;helper2.bva=i;helper2.cva=j;
        helper2.per1=k;
                component.set("v.realizado", (d-c));
                component.set("v.estimativa", ((d-c)+(e-f)+(g-h)));
                component.set("v.carteira", (e-f));
                component.set("v.novas", (g-h));
                component.set("v.metas", a);
                component.set("v.TotalG", helper2);
                if(a!=0)component.set("v.ating", (component.get("v.estimativa"))/a);else component.set("v.ating", 0);
        		/*if(component.get("v.realizado")==0)component.set("v.realizado",'-');
        		if(component.get("v.carteira")==0)component.set("v.carteira",'-');
        		if(component.get("v.novas")==0)component.set("v.novas",'-');
        		if(component.get("v.metas")==0)component.set("v.metas",'-');
        		if(component.get("v.estimativa")==0)component.set("v.estimativa",'-');
        		if(component.get("v.ating")==0)component.set("v.ating",'-');*/
         
    },
    handleClick : function (cmp, event, helper) {
        cmp.set("v.width","font-size:3px;width:100%;");
        if(cmp.get("v.isOrg")==false){
            cmp.set("v.width","font-size:2px;width:100%;position:absolute;left:0%;top: -1%;");
        
        }
        cmp.set("v.plainIp",true);
        window.setTimeout(
            $A.getCallback(function() {
                window.print();
                cmp.set("v.plainIp",false);
                cmp.set("v.width","font-size:10px;width:150%;");     
            }), 500
        );
        
    },
    
    exportCsv:function (cmp, event, helper){
    	var cont=cmp.get("v.contract");
        var rows=[];
    rows.push([cont.Name,' ',' ','BU',cont.Region__r.Zone__r.Name,'','REALIZADO',cmp.get("v.realizado"),'META',cmp.get("v.metas")]);
    rows.push(['PROGRAMA',cont.Type__c,' ','REGIONAL',cont.Region_Name__c,'','CARTEIRA',cmp.get("v.carteira"),'ESTIMATIVA',cmp.get("v.estimativa")]);
    rows.push(['CLASSIFICAÇÃO',cont.Category_Name__c,' ','CTC',cont.Sales_Rep__c,'','NOVAS NEG / DEV',cmp.get("v.novas"),'ATINGIMENTO',cmp.get("v.ating")]);
    rows.push([' ']);
    //rows.push([]);
        let csvContent = "data:text/csv;charset=utf-8,";

rows.forEach(function(rowArray) {
    let row = rowArray.join(",");
    csvContent += row + "\r\n";
});
        alert(csvContent);
     csvContent='';
       //content, filename, contentType
       var content=csvContent;
        var filename='fewfg.csv';
        var contentType='text/csv;charset=utf-8;';
        var blob = new Blob([content], { type: contentType });
  var url = URL.createObjectURL(blob);

  // Create a link to download it
  var pom = document.createElement('a');
  pom.href = url;
  pom.setAttribute('download', filename);
  pom.click();
	}
    
})