({
	doInit : function(component, event, helper) {
        var key = component.get("v.key");
        var map1 = component.get("v.resultG");
        //if(map1.length==0)map1=[{"Actual_Value__c":684300,"Actual_Volume__c":7000,"Brand_Name__c":"BIOZYME","Product_Category__c":"Biossoluções","Name":"RGB-0000021120","Net_Value__c":684300,"Net_Volume__c":7000,"Returns_Value__c":0,"Returns_Volume__c":0,"Value__c":440000,"Volume__c":4000,"Id":"a5T5D0000006cvpUAA","OO_Value__c":0,"OO_Volume__c":0,"CO_Value__c":0,"CO_Volume__c":0,"NN_Value__c":0,"NN_Volume__c":0,"ND_Value__c":0,"ND_Volume__c":0,"nn":0,"nd":0,"vPercent":1.75,"bvo":0,"bva":0,"cvo":0,"cva":0},{"Actual_Value__c":784900,"Actual_Volume__c":130010,"Brand_Name__c":"MANZATE WG","Product_Category__c":"Complementares","Name":"RGB-0000021121","Net_Value__c":0,"Net_Volume__c":80010,"Returns_Value__c":0,"Returns_Volume__c":0,"Value__c":1668000,"Volume__c":109865,"Id":"a5T5D0000006cvqUAA","OO_Value__c":0,"OO_Volume__c":0,"CO_Value__c":0,"CO_Volume__c":0,"NN_Value__c":0,"NN_Volume__c":0,"ND_Value__c":0,"ND_Volume__c":0,"nn":0,"nd":0,"vPercent":0.625,"bvo":0,"bva":0,"cvo":0,"cva":0},{"Actual_Value__c":264725.63,"Actual_Volume__c":252708,"Brand_Name__c":"BARAO","Product_Category__c":"Demais","Name":"RGB-0000021123","Net_Value__c":264725.63,"Net_Volume__c":252708,"Returns_Value__c":0,"Returns_Volume__c":0,"Value__c":288800,"Volume__c":184648,"Id":"a5T5D0000006cvsUAA","OO_Value__c":0,"OO_Volume__c":169580,"CO_Value__c":0,"CO_Volume__c":0,"NN_Value__c":24,"NN_Volume__c":43,"ND_Value__c":0,"ND_Volume__c":0,"nn":1080,"nd":0,"vPercent":1.0707236842105263,"bvo":0,"bva":0,"cvo":20580,"cva":0},{"Actual_Value__c":1912237.06,"Actual_Volume__c":19998,"Brand_Name__c":"CARTARYS","Product_Category__c":"Estratégicos","Name":"RGB-0000021138","Net_Value__c":1912237.06,"Net_Volume__c":16008,"Returns_Value__c":0,"Returns_Volume__c":0,"Value__c":2031000,"Volume__c":21000,"Id":"a5T5D0000006cw7UAA","OO_Value__c":0,"OO_Volume__c":0,"CO_Value__c":0,"CO_Volume__c":0,"NN_Value__c":0,"NN_Volume__c":0,"ND_Value__c":0,"ND_Volume__c":0,"nn":0,"nd":0,"vPercent":1.0672,"bvo":0,"bva":0,"cvo":0,"cva":0},{"Actual_Value__c":279253.1,"Actual_Volume__c":51057,"Brand_Name__c":"KASUMIN","Product_Category__c":"Premium","Name":"RGB-0000021140","Net_Value__c":279253.1,"Net_Volume__c":51057,"Returns_Value__c":0,"Returns_Volume__c":0,"Value__c":259500,"Volume__c":50020,"Id":"a5T5D0000006cw9UAA","OO_Value__c":0,"OO_Volume__c":9000,"CO_Value__c":0,"CO_Volume__c":0,"NN_Value__c":0,"NN_Volume__c":0,"ND_Value__c":0,"ND_Volume__c":0,"nn":0,"nd":0,"vPercent":1.3333333333333333,"bvo":0,"bva":0,"cvo":0,"cva":0}];
        map1.forEach(function (item, index) {
           if(item['Product_Category__c']==key)component.set("v.value" , item); 
        });
        
	},
    
    getEvents : function(component, event, helper) {
         var key = component.get("v.key");
        var evtValue = event.getParam("parentVar");
        component.set("v.childValue",evtValue);
        component.set("v.resultG",evtValue);
         var map1 = component.get("v.resultG");
        map1.forEach(function (item, index) {
           if(item['Product_Category__c']==key)component.set("v.value" , item); 
        });
       
	}
})