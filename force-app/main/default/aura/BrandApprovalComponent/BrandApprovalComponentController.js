({
	doInit : function(component, event, helper) {
		
	},
    onChangeSelection : function(component, event, helper) {
    var objects =[];
    component.set("v.singleBrandRecord","");
    component.set("v.selectedBrandRecords",objects);
    component.set("v.singleCompanyRecord","");
    component.set("v.selectedCompanyRecords",objects);
    component.set("v.singleFormulationRecord","");
    component.set("v.selectedFormulationRecords",objects);
    },
    onChangeBrands : function(component, event, helper) {
     	var UnapprovedBrnds = component.get("v.selectedBrandRecords");
        var brands = document.getElementById("brndsError");
        if(brands != null){
            if(UnapprovedBrnds == ''){
              brands.style.display = "Block";
            }else{
            brands.style.display = "None";    
            } 
        }    
    },
    onChangeBrand : function(component, event, helper) {
	var approvedBrnd = component.get("v.singleBrandRecord"); 
          console.log('approvedBrnd>>--->'+approvedBrnd);
         var brand = document.getElementById("brndError");
         console.log('brand>>--->'+brand);
        if(brand != null){
            if(!approvedBrnd){
            brand.style.display = "Block";
            }else{ 
               brand.style.display = "None"; 
            }
    	}
	},
    updateBrand :function(component, event, helper) {
	var approvedBrnd = component.get("v.singleBrandRecord");
    var UnapprovedBrnds = component.get("v.selectedBrandRecords");
    //var selVal = component.get("v.selectedValue");
    var isvalid = true;
        
        if(!approvedBrnd){
        isvalid = false; 
         document.getElementById("brndError").style.display = "Block";
        }else{
        document.getElementById("brndError").style.display = "None";    
        }
        if(UnapprovedBrnds == ''){
         isvalid = false;  
          document.getElementById("brndsError").style.display = "Block";
        }else{
        document.getElementById("brndsError").style.display = "None";    
        }
        if(isvalid){    
           
            console.log('approvedBrnd>>--->'+JSON.stringify(approvedBrnd));
            console.log('UnapprovedBrnds>>--->'+UnapprovedBrnds);
             helper.UpdateBrandhelp(component,event,helper,approvedBrnd,UnapprovedBrnds);
        }    
	},
    onChangeCmp :function(component, event, helper) {
    	var approvedCmp = component.get("v.singleCompanyRecord");  
        var cmp = document.getElementById("cmpError");
         if(cmp != null){
            if(!approvedCmp){
             cmp.style.display = "Block";
            }else{
           cmp.style.display = "None";    
            }
         }
    },
    onChangecmpes :function(component, event, helper) {
        var Unapprovedcmpes = component.get("v.selectedCompanyRecords");
         var cmpes = document.getElementById("cmpesError");
        if(cmpes != null){
            if(Unapprovedcmpes == ''){
                cmpes.style.display = "Block";
            }else{
                cmpes.style.display = "None";    
            } 
        }    
    },
     updateCompany :function(component, event, helper) {
	var approvedCmp = component.get("v.singleCompanyRecord");
    var Unapprovedcmpes = component.get("v.selectedCompanyRecords");
       var isvalid = true;
      if(!approvedCmp){
         document.getElementById("cmpError").style.display = "Block";
         isvalid = false; 
        }else{
        document.getElementById("cmpError").style.display = "None";    
        }	
     if(Unapprovedcmpes == ''){
          document.getElementById("cmpesError").style.display = "Block";
         isvalid = false; 
        }else{
        document.getElementById("cmpesError").style.display = "None";    
        }       
         if(isvalid){
            helper.UpdateComphelp(component, event, helper,approvedCmp,Unapprovedcmpes);
            console.log('approvedCompany>>--->'+approvedCmp);
            console.log('Unapprovedcmps>>--->'+Unapprovedcmpes);
         }         
	},
    onChangefrm :function(component, event, helper) {
        var approvedFrm = component.get("v.singleFormulationRecord");  
        var frm = document.getElementById("frmError");
        if(frm!= null){
            if(!approvedFrm){
             frm.style.display = "Block";
            }else{
            frm.style.display = "None";    
            }
        }    
    },
    onChangefrms:function(component, event, helper) {
       var UnapprovedFrms = component.get("v.selectedFormulationRecords");
        var frms = document.getElementById("frmsError");
        if(frms!=null){
            if(UnapprovedFrms == ''){
                frms.style.display = "Block";
            }else{
                frms.style.display = "None";    
            }
        }
    },
     updateFormulation :function(component, event, helper) {
	var approvedFrm = component.get("v.singleFormulationRecord");
    var UnapprovedFrms = component.get("v.selectedFormulationRecords");
       var isvalid = true; 
     if(!approvedFrm){
         document.getElementById("frmError").style.display = "Block";
         isvalid = false;
        }else{
        document.getElementById("frmError").style.display = "None";    
        }
         if(UnapprovedFrms == ''){
          document.getElementById("frmsError").style.display = "Block";
          isvalid = false;  
        }else{
        document.getElementById("frmsError").style.display = "None";    
        }
        if(isvalid){     
            helper.UpdateFrmhelp(component, event, helper,approvedFrm,UnapprovedFrms); 
            console.log('approvedFrm>>--->'+approvedFrm);
            console.log('UnapprovedFrms>>--->'+UnapprovedFrms);
        }         
	},
     cancel :function(component, event, helper) {
      window.history.go(-1);
	},
})