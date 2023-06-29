({    
	doInit: function(component,event,helper) { 
		helper.getWarehouse(component,event,helper);
        helper.getHBrand(component,event,helper); 
        helper.getloadMaterials(component,event,helper);
    },
    getBrand: function(component,event,helper){
        helper.getHBrand(component,event,helper);
	},
    refresfBrandMat: function(component,event,helper){       
        helper.getHBrand(component,event,helper);
        helper.getloadMaterials(component,event,helper);
    },
    getMat: function(component,event,helper){ 
        console.log('In Mat');
         if(component.find("brand").get("v.value") != '' && component.find("brand").get("v.value") != undefined){
        console.log('called hmaterials'+component.find("brand").get("v.value"));
            helper.getHMaterials(component,event,helper);
        }else{ component.find("materials").set("v.value",'');
              helper.getloadMaterials(component,event,helper);
             }
	},
   
    
    search : function(component, event, helper){
        helper.HSearch(component,event,helper);
    },
        
})