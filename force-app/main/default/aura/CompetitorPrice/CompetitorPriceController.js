({
    
    doInit : function(component, event, helper) {
        //helper.getBrandList(component, event, helper);
        //helper.getCmpnyList(component, event, helper);
        //component.set("v.hideImageBox", true);
        //alert('Getting Country of Login User Id ');
        helper.gettingLoginUserId(component,event,helper);
        
    },
    
    toggleDetails : function(component, event, helper) {
        component.set("v.showSpinner",true);
        var sel = component.find("Reporting_Type");
        //alert(sel);
        var val = sel.get("v.value");
        // alert(val);
        var flag = false;
        
        if (val == "New Company, New Brand") {
            
            component.set("v.type34", true);
            component.set("v.type5", true);
            flag = true;
            // helper.getCropList(component, event, helper); Commented by vishal
            // helper.getPestList(component, event, helper); Commented by vishal
            //helper.getListOfFormulation(component, event, helper);  commented by vishal
            // component.find("brand").set("v.disabled", true);  commented by vishal
            //component.find("company").set("v.disabled", true);  commented by vishal
            //component.find("formulation").set("v.disabled", false); commented by vishal
            // component.find("pack_size").set("v.disabled", false); commented by vishal
            
            component.find("vFormulation").set("v.disabled", false);
            component.find("vPackSize").set("v.disabled", false);
            component.find("vBrand").set("v.disabled", true);
            component.find("vCompany").set("v.disabled", true);
            component.find("vCrop").set("v.disabled", false);
            //helper.clearAll(component,event);
            component.set("v.showSpinner",false);  
            /* component.find("openBrnd").set("v.disabled", false);
            component.find("openCmpny").set("v.disabled", false);
            component.find("openFrmltn").set("v.disabled", false);*/
        }
        else if (val == "Existing Company, New Brand") { 
            
            component.set("v.type34", true);
            component.set("v.type5", true);
            flag = true;
            
            // helper.getCmpnyList(component, event, helper);
            // helper.getListOfFormulation(component, event, helper);
            // helper.getCropList(component, event, helper); Commented by vishal
            //  helper.getPestList(component, event, helper); Commented by vishal
            
            
            component.find("vFormulation").set("v.disabled", false);
            component.find("vPackSize").set("v.disabled", false);
            component.find("vBrand").set("v.disabled", true);
            component.find("vCompany").set("v.disabled", false);
            component.set("v.showSpinner",false);
            
            // component.find("brand").set("v.disabled", true);  commented by vishal
            // component.find("company").set("v.disabled", false); commented by vishal
            // component.find("formulation").set("v.disabled", false); commented by vishal
            // component.find("pack_size").set("v.disabled", false); commented by vishal
            //   component.set("v.brandObj","");  commented by vishal
            
            /*component.find("openBrnd").set("v.disabled", false);
            component.find("openCmpny").set("v.disabled", true);
            component.find("openFrmltn").set("v.disabled", false);*/
            helper.clearAll(component,event);
        }
            else if(val == "New Pack size in an Existing Brand"){
                
                component.set("v.type34", true);
                component.set("v.type5", false);
                flag = false;
                // helper.getBrandList(component, event, helper); commented by vishal
                // helper.getCmpnyList(component, event, helper); commented by vishal
                // helper.getListOfFormulation(component, event, helper);  commented by vishal
                // component.find("brand").set("v.disabled", false); commented by vishal
                //component.find("company").set("v.disabled", false); commented by vishal
                //component.find("formulation").set("v.disabled", false);  commented by vishal
                //component.find("pack_size").set("v.disabled", true); commented by vishal
                
                component.find("vBrand").set("v.disabled", false); 
                component.find("vCompany").set("v.disabled", false); 
                component.find("vFormulation").set("v.disabled", false); 
                component.find("vPackSize").set("v.disabled", true); 
                component.set("v.showSpinner",false);
                helper.clearAll(component,event);
                
                // component.set("v.cmpnyObj","");
                
                /* component.find("openBrnd").set("v.disabled", true);
            component.find("openCmpny").set("v.disabled", false);
            component.find("openFrmltn").set("v.disabled", false);*/
            }
                else if(val == "Existing Product Price update"){
                    
                    component.set("v.type34", true);
                    component.set("v.type5", false);
                    flag = true;
                    //helper.getBrandList(component, event, helper);  commented by vishal
                    //helper.getCmpnyList(component, event, helper);commented by vishal
                    // helper.getListOfFormulation(component, event, helper);  commented by vishal
                    //component.find("brand").set("v.disabled", false);  commented by vishal
                    // component.find("company").set("v.disabled", false);  commented by vishal
                    // component.find("formulation").set("v.disabled", false); commented by vishal
                    // component.find("pack_size").set("v.disabled", false); commented by vishal
                    
                    component.find("vFormulation").set("v.disabled", false);
                    component.find("vPackSize").set("v.disabled", false);
                    component.find("vBrand").set("v.disabled", false);
                    component.find("vCompany").set("v.disabled", false);
                    //component.set("v.cmpnyObj","");
                    component.set("v.showSpinner",false);
                    helper.clearAll(component,event);
                    
                    /*  component.find("openBrnd").set("v.disabled", false);
            component.find("openCmpny").set("v.disabled", false);
            component.find("openFrmltn").set("v.disabled", false);*/
                }
                    else if(val == "Update in Label Claim"){
                        
                        component.set("v.type34", false);
                        component.set("v.type5", true);
                        flag = false;
                        // helper.getBrandList(component, event, helper); Commented by vishal
                        // helper.getCmpnyList(component, event, helper); Commented by vishal
                        //helper.getListOfFormulation(component, event, helper);  Commented by vishal
                        // helper.getCropList(component, event, helper); Commented by vishal
                        // helper.getPestList(component, event, helper);Commented by vishal
                        //component.find("brand").set("v.disabled", false); Commented by vishal
                        // component.find("company").set("v.disabled", false); Commented by vishal
                        // component.find("formulation").set("v.disabled", false); Commented by vishal
                        component.find("vBrand").set("v.disabled", false);
                        component.find("vFormulation").set("v.disabled", false);
                        component.find("vCompany").set("v.disabled", false);
                        
                        component.set("v.showSpinner",false);
                        helper.clearAll(component,event);
                        
                    }
                        else{
                            
                            //component.find("brand").set("v.disabled", true);  commented by vishal
                            //component.find("company").set("v.disabled", true);  commented by vishal
                            //component.find("formulation").set("v.disabled", true); commented by vishal
                            component.find("vCompany").set("v.disabled", true);
                            component.find("vBrand").set("v.disabled", true);
                            component.find("vFormulation").set("v.disabled", true);
                            // component.find("vPackSize").set("v.disabled", true);
                            //  component.find("pack_size").set("v.disabled", false);  commented by vishal
                            component.set("v.showSubmitBtn",false);
                            component.set("v.showSpinner",false);
                            component.set("v.type34", false);
                            component.set("v.type5", false); 
                            helper.clearAll(component,event);
                            
                            /*component.find("openBrnd").set("v.disabled", false);
            component.find("openCmpny").set("v.disabled", false);
            component.find("openFrmltn").set("v.disabled", false);*/
                        }
        
        
        if(flag){
            // helper.getPackList(component, event, helper);
        }
        // component.set("v.showSpinner",false);
        //component.find("formulation").set("v.value", ""); commented by vishal
        //component.set('v.hiddenBrndId', ''); commented by vishal
        //component.set('v.hiddenCmpnyId', ''); commented by vishal
        // component.find("brand").set("v.value", "");  commented by vishal
        //component.find("company").set("v.value", ""); commented by vishal
        // component.set('v.selectedBrand', ''); commented by vishal
        // component.set('v.selectedCmpny', ''); commented by vishal
        //component.set('v.selectedFormulation', ''); commented by vishal
        // component.set('v.cmpnyOpt', false); commented by vishal
        //component.set('v.brndOpt', false); commented by vishal
        // component.set('v.frmltnOpt', false); commented by vishal
        
        
    },
    
    addSchemeDetails : function(component, event, helper) {
        
        console.log("inside addSchemeDetails");
        component.set("v.showSpinner",true);
        var comp = component.get("v.pckObj");
        var schmObjs = component.get('v.priceDetailsObj');
        var selc = component.find("Reporting_Type").get("v.value");
        console.log(selc);
        var pck_size='';
        if(selc == "New Pack size in an Existing Brand"){
            var str=component.get('v.selectedPack');
            pck_size=str.Id;
            console.log(str);
        }
        else{
            pck_size=component.find("pack_size").get("v.value");
            
        }
        var mrp=component.find("MRP").get("v.value");
        var frm_price=component.find("farmer_price").get("v.value");
        var ret_price=component.find("retailer_price").get("v.value");
        var dis_price=component.find("distributor_price").get("v.value");
        var schm=component.find("schemes").get("v.value");
        var cmnt=component.find("comments").get("v.value");
        var pcknm='';
        var pckMap  = JSON.stringify(comp);
        var obj = JSON.parse(pckMap);
        contains(obj, "Id", pck_size);
        
        console.log({
            "pck_size":pck_size,
            "mrp":mrp,
            "frm_price":frm_price,
            "ret_price":ret_price,
            "dis_price":dis_price,
            "schm":schm,
            "cmnt":cmnt,
            "pcknm":pcknm
        });
        
        if(!pck_size){
            component.set("v.showSpinner",false);
            component.find("pack_size").set("v.errors", [{message: $A.get("$Label.c.Select_Pack_Size")}]);
            $A.util.addClass(component.find("pack_size"), 'slds-has-error');
        }
        else if(!mrp){
            //component.find("MRP").set("v.errors", "Complete this field");
            // $A.util.addClass(component.find("MRP"), 'slds-has-error');
            component.set("v.showSpinner",false);
            component.find("MRP").set('v.validity', {valid:false, badInput :true});
            component.find("MRP").showHelpMessageIfInvalid();
            //  component.find("MRP").setCustomValidity('Enter a date');
        }
            else if(!frm_price){
                //component.find("farmer_price").set("v.errors", [{message: "Complete this field"}]);
                //$A.util.addClass(component.find("farmer_price"), 'slds-has-error');
                component.set("v.showSpinner",false);
                component.find("farmer_price").set('v.validity', {valid:false, badInput :true});
                component.find("farmer_price").showHelpMessageIfInvalid();
            }
                else if(!ret_price){
                    //component.find("retailer_price").set("v.errors", [{message: "Complete this field"}]);
                    //$A.util.addClass(component.find("retailer_price"), 'slds-has-error');
                    component.set("v.showSpinner",false);
                    component.find("retailer_price").set('v.validity', {valid:false, badInput :true});
                    component.find("retailer_price").showHelpMessageIfInvalid();
                }
                    else if(!dis_price){
                        //component.find("distributor_price").set("v.errors", [{message: "Complete this field"}]);
                        //$A.util.addClass(component.find("distributor_price"), 'slds-has-error');
                        component.set("v.showSpinner",false);
                        component.find("distributor_price").set('v.validity', {valid:false, badInput :true});
                        component.find("distributor_price").showHelpMessageIfInvalid();
                    }
                        else if(!schm){
                            //component.find("schemes").set("v.errors", [{message: "Complete this field"}]);
                            //$A.util.addClass(component.find("schemes"), 'slds-has-error');
                            component.set("v.showSpinner",false);
                            component.find("schemes").set('v.validity', {valid:false, badInput :true});
                            component.find("schemes").showHelpMessageIfInvalid();
                        }
                            else{
                                
                                /*var obj = new Object();
        obj.pck_size=pck_size;
        obj.mrp=mrp;
        obj.frm_price=frm_price;
        obj.ret_price=ret_price;
        obj.dis_price=dis_price;
        obj.schm=schm;
        obj.cmnt=cmnt;   */ 
                                
                                schmObjs.push({
                                    pck_size:pck_size,
                                    mrp:mrp,
                                    frm_price:frm_price,
                                    ret_price:ret_price,
                                    dis_price:dis_price,
                                    schm:schm,
                                    cmnt:cmnt,
                                    pcknm:pcknm
                                });
                                
                                component.set('v.priceDetailsObj', schmObjs);
                                component.set('v.hideSchmImageBox',true);
                                component.set('v.hideLablImageBox',true);
                                component.find("schemes").set("v.value",schm);
                                component.find("schemes").set("v.disabled", true); 
                                
                                component.find("pack_size").set("v.value","");
                                component.find("MRP").set("v.value","");
                                component.find("farmer_price").set("v.value","");
                                component.find("retailer_price").set("v.value","");
                                component.find("distributor_price").set("v.value","");
                                //component.find("schemes").set("v.value","");
                                component.find("comments").set("v.value","");
                            } 
        
        function contains(arr, key, val) {
            for (var i = 0; i < arr.length; i++) {
                if(arr[i][key] === val){
                    console.log('<------>')
                    pcknm =arr[i].Name;
                    return true;
                }
            }
        }
        
    },
    
    removePriceDetails: function(component, event, helper) {
        console.log("inside removePriceDetails");
        component.set("v.showSpinner",true);
        var index = event.currentTarget.dataset.rowIndex;
        console.log("index no.- "+ index);
        var schmObjs = component.get("v.priceDetailsObj");
        
        var id=schmObjs[index].pck_id;
        
        helper.removeSchmPriceEntry(component, event, helper, id, index);
        // schmObjs.splice(index, 1);
        // component.set("v.priceDetailsObj",schmObjs); 
    },
    
    resetSchemeDetails: function(component, event, helper) {
        console.log("inside resetSchemeDetails");
        
        // component.find("pack_size").set("v.value","");
        component.find("MRP").set("v.value","");
        component.find("farmer_price").set("v.value","");
        component.find("retailer_price").set("v.value","");
        component.find("distributor_price").set("v.value","");
        //component.find("schemes").set("v.value","");
        component.find("comments").set("v.value","");
    },
    
    addLabelClaim : function(component, event, helper) {
        
        var cName = component.get("v.countryName");
        
        if(cName =='India' || cName =='SWAL'){
            console.log("inside addLabelClaim");
            var comp ='';
            var comp2 ='';
            var updtList = component.get("v.updateClaimObjUpdated");
            
            var tmcrop = component.get("v.selectedRecordCrop");
            if(tmcrop!= null){
                comp = component.get("v.selectedRecordCrop"); 
            }
            var tmppest = component.get("v.selectedRecordPest");
            if(tmppest!= null){
                comp2 = component.get("v.selectedRecordPest"); 
            }
            
            
            
            
            
            
            var labelObjs = component.get('v.updateClaimObj');
            
            var flag=false;
            
            var crpa = component.get("v.selectedRecordCrop");
            var crp = '';
            if(crpa!=null){
                crp = crpa.Id;    
            }
            
            
            var psta = component.get("v.selectedRecordPest");
            var pst ='';
            if(psta!=null){
                pst = psta.Id;
            }
            
            
            
            var dos=component.find("dose").get("v.value");
            var uom=component.find("uom").get("v.value");
            var acr_cst=component.find("per_acre_cost").get("v.value");
            var crpNm='';
            var pstNm='';
            var sel = component.find("Reporting_Type").get("v.value");
            var brnd = '';
            
            if(sel == "New Company, New Brand" || sel == "Existing Company, New Brand" || sel == "New Pack size in an Existing Brand" || sel == "Existing Product Price update" || sel == "Update in Label Claim"){
                var bradAdd = component.get('v.newbrndadd');
                if(bradAdd == true){
                    var str=component.get('v.selectedRecordBrand');
                    if(str!=null){
                        brnd=str.Id;    
                    }
                    
                }else{
                    var str=component.get('v.selectedRecordBrand');
                    if(str!=null){
                        brnd=str.Brand__c;    
                    }
                    
                }
                
            }
            
            
            var crpMap  = JSON.stringify(comp);
            var obj = JSON.parse(crpMap);
            
            var pstMap  = JSON.stringify(comp2);
            var obj2 = JSON.parse(pstMap);
            
            contains(obj, "Id", crp); 
            contains2(obj2, "Id", pst); 
            
            console.log({
                "crp":crp,
                "pst":pst,
                "dos":dos,
                "uom":uom,
                "acr_cst":acr_cst,
                "crpNm":crpNm,
                "pstNm":pstNm
            });
            
            
            
            
            
            
            
            
            if(!brnd){
                //component.find("farmer_price").set("v.errors", [{message: "Complete this field"}]);
                //$A.util.addClass(component.find("farmer_price"), 'slds-has-error');
                component.set("v.showSpinner",false);
                alert($A.get("$Label.c.Please_select_Brand"));
                // component.find("crop").set('v.validity', {valid:false, badInput :true});
                //component.find("crop").showHelpMessageIfInvalid();
            }
            else if(!crp){
                //component.find("farmer_price").set("v.errors", [{message: "Complete this field"}]);
                //$A.util.addClass(component.find("farmer_price"), 'slds-has-error');
                component.set("v.showSpinner",false);
                alert($A.get("$Label.c.Please_Select_Crop"));
                // component.find("crop").set('v.validity', {valid:false, badInput :true});
                //component.find("crop").showHelpMessageIfInvalid();
            }
                else if(!pst){
                    //component.find("retailer_price").set("v.errors", [{message: "Complete this field"}]);
                    //$A.util.addClass(component.find("retailer_price"), 'slds-has-error');
                    component.set("v.showSpinner",false);
                    alert($A.get("$Label.c.Please_select_Pest"));
                    //component.find("vPest").set('v.validity', {valid:false, badInput :true});
                    //component.find("vPest").showHelpMessageIfInvalid();
                }
                    else if(!dos){
                        //component.find("distributor_price").set("v.errors", [{message: "Complete this field"}]);
                        //$A.util.addClass(component.find("distributor_price"), 'slds-has-error');
                        component.set("v.showSpinner",false);
                        component.find("dose").set('v.validity', {valid:false, badInput :true});
                        component.find("dose").showHelpMessageIfInvalid();
                    }
                        else if(!uom){
                            //component.find("uom").set("v.errors", [{message: "Complete this field"}]);
                            //$A.util.addClass(component.find("uom"), 'slds-has-error');
                            component.set("v.showSpinner",false);
                            component.find("uom").set('v.validity', {valid:false, badInput :true});
                            component.find("uom").showHelpMessageIfInvalid();
                        }
                            else if(!acr_cst){
                                //component.find("schemes").set("v.errors", [{message: "Complete this field"}]);
                                //$A.util.addClass(component.find("schemes"), 'slds-has-error');
                                component.set("v.showSpinner",false);
                                component.find("per_acre_cost").set('v.validity', {valid:false, badInput :true});
                                component.find("per_acre_cost").showHelpMessageIfInvalid();
                            }
                                else{
                                    if(updtList!=null){
                                        if(updtList.length>0){
                                            for(var i=0;i<updtList.length;i++){
                                                if(updtList[i].crp == crp && updtList[i].brand_Id == brnd){
                                                    flag=true;
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                    if(flag){
                                        alert($A.get("$Label.c.Entry_for_selected_Brand_and_Crop_already_Exist"));
                                    }
                                    else{
                                        labelObjs.push({
                                            crp:crp,
                                            pst:pst,
                                            dos:dos,
                                            uom:uom,
                                            acr_cst:acr_cst,
                                            crpNm:crpa.Name,
                                            pstNm:psta.Name
                                        });
                                        
                                        component.set('v.updateClaimObj', labelObjs);
                                        component.set("v.showSubmitBtn",true);    
                                    }             
                                    
                                    var forclose = component.find("lookup-pill-Crop");
                                    $A.util.addClass(forclose, 'slds-hide');
                                    $A.util.removeClass(forclose, 'slds-show');
                                    
                                    var lookUpTarget = component.find("lookupFieldCrop");
                                    $A.util.addClass(lookUpTarget, 'slds-show');
                                    $A.util.removeClass(lookUpTarget, 'slds-hide'); 
                                    component.find("vCrop").set("v.value","");
                                    
                                    
                                    
                                    var forclose = component.find("lookup-pill-Pest");
                                    $A.util.addClass(forclose, 'slds-hide');
                                    $A.util.removeClass(forclose, 'slds-show');
                                    
                                    var lookUpTarget = component.find("lookupFieldPest");
                                    $A.util.addClass(lookUpTarget, 'slds-show');
                                    $A.util.removeClass(lookUpTarget, 'slds-hide'); 
                                    component.find("vPest").set("v.value","");
                                    
                                    
                                    
                                    
                                    // component.find("crop").set("v.value","");
                                    //component.find("pest").set("v.value","");
                                    component.find("dose").set("v.value","");
                                    component.find("uom").set("v.value","");
                                    component.find("per_acre_cost").set("v.value","");
                                    component.find("vBrand").set("v.disabled", true); 
                                    component.find("vCompany").set("v.disabled", true);
                                    component.find("vFormulation").set("v.disabled", true);
                                    component.find("Reporting_Type").set("v.disabled", true); 
                                    component.set("v.selectedRecordCrop", null); 
                                    component.set("v.selectedRecordPest", null); 
                                    component.set("v.showSpinner",false);
                                    
                                } 
            function contains(arr, key, val) {
                for (var i = 0; i < arr.length; i++) {
                    if(arr[i][key] === val){
                        console.log('<------>')
                        crpNm=arr[i].Name;
                        return true;
                    }
                }
            }
            
            function contains2(arr, key, val) {
                for (var i = 0; i < arr.length; i++) {
                    if(arr[i][key] === val){
                        console.log('<------>')
                        pstNm=arr[i].Name;
                        return true;
                    }
                }
            }
        } // end of India And SWAL
        
        
        
        
        
        if(cName=='Spain' || cName=='Portugal' || cName=='Naturagri Spain' ){
            console.log('inside Spain Users');
            component.set("v.showSubmitBtn",true); 
            
            var comp ='';
            var comp2 ='';
            var updtList = component.get("v.updateClaimObjUpdated");
            
            var tmcrop = component.get("v.selectedRecordCrop");
            if(tmcrop!= null){
                comp = component.get("v.selectedRecordCrop"); 
            }
            var tmppest = component.get("v.selectedRecordPest");
            if(tmppest!= null){
                comp2 = component.get("v.selectedRecordPest"); 
            }
            
            
            
            
            
            
            var labelObjs = component.get('v.updateClaimObj');
            
            var flag=false;
            
            var crpa = component.get("v.selectedRecordCrop");
            var crp = '';
            if(crpa!=null){
                crp = crpa.Id;    
            }
            
            
            var psta = component.get("v.selectedRecordPest");
            var pst ='';
            if(psta!=null){
                pst = psta.Id;
            }
            
            
            
            var dos=component.find("dose").get("v.value");
            var uom=component.find("uom").get("v.value");
            var acr_cst=component.find("per_acre_cost").get("v.value");
            var crpNm='';
            var pstNm='';
            var sel = component.find("Reporting_Type").get("v.value");
            var brnd = '';
            
            if(sel == "New Company, New Brand" || sel == "Existing Company, New Brand" || sel == "New Pack size in an Existing Brand" || sel == "Existing Product Price update" || sel == "Update in Label Claim"){
                var bradAdd = component.get('v.newbrndadd');
                if(bradAdd == true){
                    var str=component.get('v.selectedRecordBrand');
                    if(str!=null){
                        brnd=str.Id;    
                    }
                    
                }else{
                    var str=component.get('v.selectedRecordBrand');
                    if(str!=null){
                        brnd=str.Brand__c;    
                    }
                    
                }
                
            }
            
            
            var crpMap  = JSON.stringify(comp);
            var obj = JSON.parse(crpMap);
            
            var pstMap  = JSON.stringify(comp2);
            var obj2 = JSON.parse(pstMap);
            
            contains(obj, "Id", crp); 
            contains2(obj2, "Id", pst); 
            
            console.log({
                "crp":crp,
                "pst":pst,
                "dos":dos,
                "uom":uom,
                "acr_cst":acr_cst,
                "crpNm":crpNm,
                "pstNm":pstNm
            });
            
            
            if(updtList!=null){
                if(updtList.length>0){
                    for(var i=0;i<updtList.length;i++){
                        if(updtList[i].crp == crp && updtList[i].brand_Id == brnd){
                            flag=true;
                            break;
                        }
                    }
                }
            }
            if(flag){
                alert($A.get("$Label.c.Entry_for_selected_Brand_and_Crop_already_Exist"));
            }
            else{
                labelObjs.push({
                    crp:crp,
                    pst:pst,
                    dos:dos,
                    uom:uom,
                    acr_cst:acr_cst,
                    crpNm:crpa.Name,
                    pstNm:psta.Name
                });
                
                component.set('v.updateClaimObj', labelObjs);
                component.set("v.showSubmitBtn",true);    
            } 
            
            
            
            
            console.log('inside Spain and Portugal Save update Claim'); 
            function contains(arr, key, val) {
                for (var i = 0; i < arr.length; i++) {
                    if(arr[i][key] === val){
                        console.log('<------>')
                        crpNm=arr[i].Name;
                        return true;
                    }
                }
            }
            
            function contains2(arr, key, val) {
                for (var i = 0; i < arr.length; i++) {
                    if(arr[i][key] === val){
                        console.log('<------>')
                        pstNm=arr[i].Name;
                        return true;
                    }
                }
            }
            
            var forclose = component.find("lookup-pill-Crop");
            $A.util.addClass(forclose, 'slds-hide');
            $A.util.removeClass(forclose, 'slds-show');
            
            var lookUpTarget = component.find("lookupFieldCrop");
            $A.util.addClass(lookUpTarget, 'slds-show');
            $A.util.removeClass(lookUpTarget, 'slds-hide'); 
            component.find("vCrop").set("v.value","");
            
            
            
            var forclose = component.find("lookup-pill-Pest");
            $A.util.addClass(forclose, 'slds-hide');
            $A.util.removeClass(forclose, 'slds-show');
            
            var lookUpTarget = component.find("lookupFieldPest");
            $A.util.addClass(lookUpTarget, 'slds-show');
            $A.util.removeClass(lookUpTarget, 'slds-hide'); 
            component.find("vPest").set("v.value","");
            
            
            
            
            // component.find("crop").set("v.value","");
            //component.find("pest").set("v.value","");
            component.find("dose").set("v.value","");
            component.find("uom").set("v.value","");
            component.find("per_acre_cost").set("v.value","");
            component.find("vBrand").set("v.disabled", true); 
            component.find("vCompany").set("v.disabled", true);
            component.find("vFormulation").set("v.disabled", true);
            component.find("Reporting_Type").set("v.disabled", true); 
            component.set("v.selectedRecordCrop", null); 
            component.set("v.selectedRecordPest", null); 
            component.set("v.showSpinner",false);
            
            
        }// end of Spain and Portugal and Naturagri Spain
        
        
        
    },
    
    removeLabelClaim: function(component, event, helper) {
        console.log("inside removeLabelClaim");
        
        var index = event.currentTarget.dataset.rowIndex;
        console.log("index no.- "+ index);
        var labelObjs = component.get("v.updateClaimObj");
        
        labelObjs.splice(index, 1);
        component.set("v.updateClaimObj",labelObjs); 
        if(labelObjs.length>0){
            component.set("v.showSubmitBtn",true);
        }
        else{
            component.set("v.showSubmitBtn",false);
        }
    },
    
    openBrandModal: function(component, event, helper){
        console.log('openBrandModal called..');
        var sel = component.find("Reporting_Type").get("v.value");
        if(!sel){
            //component.find("Reporting_Type").set("v.errors", [{message: "Complete this field"}]);
            //$A.util.addClass(component.find("Reporting_Type"), 'slds-has-error');
            component.find("Reporting_Type").set('v.validity', {valid:false, badInput :true});
            component.find("Reporting_Type").showHelpMessageIfInvalid();
        }
        else{
            helper.getBrandCategorys(component, event, helper);
            
            component.set('v.brandModal', true);
        }     
    },
    
    addNewBrand : function(component, event, helper) {
        
        console.log("inside addNewBrand");
        component.set("v.showSpinner",true);
        var brandObjs = component.get('v.selectedBrand');
        
        var nm=component.find("brand_name").get("v.value");
        // var cod=component.find("brand_code").get("v.value");
        var cat=component.find("catgry").get("v.value");
        var sel = component.find("Reporting_Type").get("v.value");
        if(!sel){
            // component.find("Reporting_Type").set("v.errors", [{message: "Complete this field"}]);
            // $A.util.addClass(component.find("Reporting_Type"), 'slds-has-error');
            component.set("v.showSpinner",false);
            component.find("Reporting_Type").set('v.validity', {valid:false, badInput :true});
            component.find("Reporting_Type").showHelpMessageIfInvalid();
            
        }
        else if(!nm){
            component.set("v.showSpinner",false);
            component.find("brand_name").set("v.errors", [{message: "Complete this field"}]);
            $A.util.addClass(component.find("brand_name"), 'slds-has-error');
        }
        /* else if(!cod){
            component.set("v.showSpinner",false);
            component.find("brand_code").set("v.errors", [{message: "Complete this field"}]);
            $A.util.addClass(component.find("brand_code"), 'slds-has-error');
        }*/
            else{
                console.log({
                    "name":nm,    //"cod":cod,
                    "cat":cat
                });
                
                helper.addNewBrandHelper(component, event, helper);     
                
                /*    var obj=new Object();
            obj.Id=cod;
            obj.Name=nm;
        component.set('v.selectedBrand', obj);
        component.set('v.brndOpt', true);    
        component.set('v.brandModal', false);
         */   
            }     
    },
    
    closeBrandModal: function(component, event, helper){
        component.set('v.brandModal', false);
    },
    
    openCmpnyModal: function(component, event, helper){
        var sel = component.find("Reporting_Type").get("v.value");
        if(!sel){
            //component.find("Reporting_Type").set("v.errors", [{message: "Complete this field"}]);
            // $A.util.addClass(component.find("Reporting_Type"), 'slds-has-error');
            component.find("Reporting_Type").set('v.validity', {valid:false, badInput :true});
            component.find("Reporting_Type").showHelpMessageIfInvalid();
        }
        else{
            component.set('v.cmpnyModal', true);
            
        }
    },
    
    addNewCmpny : function(component, event, helper) {
        
        console.log("inside addNewCmpny");
        component.set("v.showSpinner",true);
        var cmpnyObjs = component.get('v.selectedCmpny');
        
        var nm=component.find("cmpny_name").get("v.value");
        // var cod=component.find("cmpny_code").get("v.value");
        var site=component.find("cmpny_site").get("v.value");
        var sel = component.find("Reporting_Type").get("v.value");
        if(!sel){
            //component.find("Reporting_Type").set("v.errors", [{message: "Complete this field"}]);
            //$A.util.addClass(component.find("Reporting_Type"), 'slds-has-error');
            component.set("v.showSpinner",false);
            component.find("Reporting_Type").set('v.validity', {valid:false, badInput :true});
            component.find("Reporting_Type").showHelpMessageIfInvalid();
        }
        else if(!nm){
            component.set("v.showSpinner",false);
            component.find("cmpny_name").set("v.errors", [{message: $A.get("$Label.c.Complete_this_field")}]);
            $A.util.addClass(component.find("cmpny_name"), 'slds-has-error');
        }
        /* else if(!cod){
            component.set("v.showSpinner",false);
            component.find("cmpny_code").set("v.errors", [{message: "Complete this field"}]);
            $A.util.addClass(component.find("cmpny_code"), 'slds-has-error');
        }*/
            else{
                console.log({
                    "name":nm,      // "cod":cod,
                    "site":site
                }); 
                
                helper.addNewCmpny1(component, event, helper);    
                
                /* var obj=new Object();
            obj.Id=cod;
            obj.Name=nm;
        component.set('v.selectedCmpny', obj);
        component.set('v.cmpnyOpt', true);  
        component.set('v.cmpnyModal', false);
         */   
            }     
    },
    
    closeCmpnyModal: function(component, event, helper){
        component.set('v.cmpnyModal', false);
    },
    
    openFormulationModal: function(component, event, helper){
        //***** imp**** kindley set lookup id's of brand and cmpny here and also set name's... 
        
        var selBrand = component.get('v.selectedRecordBrand');
        var selCmpny = component.get('v.selectedRecordCompany');
        
        
        
        
        var sel = component.find("Reporting_Type").get("v.value");
        if(!sel){
            // component.find("Reporting_Type").set("v.errors", [{message: "Complete this field"}]);
            // $A.util.addClass(component.find("Reporting_Type"), 'slds-has-error');
            component.find("Reporting_Type").set('v.validity', {valid:false, badInput :true});
            component.find("Reporting_Type").showHelpMessageIfInvalid();
        }
        else if(!selBrand){
            alert($A.get("$Label.c.Brand_Not_Found_Either_Select_Brand_or_Add_New_one"));
        }
            else if(!selCmpny){
                alert($A.get("$Label.c.Company_Not_Found_Either_Select_Company_or_Add_New_one"));
            }
                else{
                    component.set('v.formulationModal', true);
                    
                    var newbrndadds =  component.get('v.newbrndadd');
                    if(newbrndadds == true){
                        component.find("frmltn_brnd").set("v.value",selBrand.Name);  
                    }else{
                        component.find("frmltn_brnd").set("v.value",selBrand.Brand__r.Name); 
                    }
                    
                    
                    if(sel =='Existing Company, New Brand' || sel =='New Company, New Brand' || sel == 'Update in Label Claim' || sel == 'New Pack size in an Existing Brand' || sel == 'Existing Product Price update'){
                        var newcmpadder =  component.get('v.newcmpadd');
                        //alert('newcmpadder '+newcmpadder);
                        if(newcmpadder == true ){
                            component.find("frmltn_cmpny").set("v.value",selCmpny.Name);   
                        }else{
                            component.find("frmltn_cmpny").set("v.value",selCmpny.Company__r.Name); 
                        }
                    }
                    
                    
                    if(sel== 'Existing Product Price update' || sel =='Existing Company, New Brand' || sel == 'Update in Label Claim' || sel == 'New Pack size in an Existing Brand'){
                        var newbrndaddss =  component.get('v.newbrndadd');
                        if(newbrndaddss == true){
                            component.set('v.hiddenBrndId', selBrand.Id);
                        }else{
                            component.set('v.hiddenBrndId', selBrand.Brand__c); 
                        }
                        
                        var newcmpadder =  component.get('v.newcmpadd');
                        if(newcmpadder == true){
                            component.set('v.hiddenCmpnyId', selCmpny.Id);  
                        }else{
                            component.set('v.hiddenCmpnyId', selCmpny.Company__c);
                        }
                    }
                }
    },
    
    addNewFrmltn : function(component, event, helper) {
        
        console.log("inside addNewFrmltn");
        component.set("v.showSpinner",true);
        var frmltnObjs = component.get('v.selectedFormulation');
        
        var nm = component.find("frmltn_name").get("v.value");
        //  var cod = component.find("frmltn_code").get("v.value");
        var brnd_id = component.get('v.hiddenBrndId');
        var cmpny_id = component.get('v.hiddenCmpnyId'); 
        
        
        
        
        var sel = component.find("Reporting_Type").get("v.value");
        if(!sel){
            //component.find("Reporting_Type").set("v.errors", [{message: "Complete this field"}]);
            //$A.util.addClass(component.find("Reporting_Type"), 'slds-has-error');
            component.set("v.showSpinner",false);
            component.find("Reporting_Type").set('v.validity', {valid:false, badInput :true});
            component.find("Reporting_Type").showHelpMessageIfInvalid();
        }
        else if(!nm){
            component.set("v.showSpinner",false);
            component.find("frmltn_name").set("v.errors", [{message: $A.get("$Label.c.Complete_this_field")}]);
            $A.util.addClass(component.find("frmltn_name"), 'slds-has-error');
        }
        /* else if(!cod){
           component.set("v.showSpinner",false);
            component.find("frmltn_code").set("v.errors", [{message: "Complete this field"}]);
            $A.util.addClass(component.find("frmltn_code"), 'slds-has-error');
        }*/
            else if(!brnd_id){
                component.set("v.showSpinner",false);
                alert($A.get("$Label.c.Something_went_wrong_Brand_not_found"));
            }
                else if(!cmpny_id){
                    component.set("v.showSpinner",false);
                    alert($A.get("$Label.c.Something_went_wrong_Company_not_found"));
                }
                    else{
                        console.log({
                            "name":nm,              //"cod":cod,
                            "brnd_id":brnd_id,
                            "cmpny_id":cmpny_id
                        });  
                        
                        helper.addNewFrmltn(component, event, helper);      
                        /* var obj=new Object();
            obj.Id=cod;
            obj.Name=nm;
        component.set('v.selectedFormulation', obj);  
        component.set('v.hiddenFrmltnId', cod);
        component.set('v.formulationModal', false);*/
                        
                    }     
    },
    
    closeFormulationModal: function(component, event, helper){
        component.set('v.formulationModal', false);
    },
    
    openPackModal: function(component, event, helper){
        var sel = component.find("Reporting_Type").get("v.value");
        if(!sel){
            //component.find("Reporting_Type").set("v.errors", [{message: "Complete this field"}]);
            //$A.util.addClass(component.find("Reporting_Type"), 'slds-has-error');
            component.find("Reporting_Type").set('v.validity', {valid:false, badInput :true});
            component.find("Reporting_Type").showHelpMessageIfInvalid();
        }
        else{
            component.set('v.packModal', true);
        }    
    },
    
    addNewPack : function(component, event, helper) {
        
        console.log("inside addNewPack");
        component.set("v.showSpinner",true);
        var cmpnyObjs = component.get('v.selectedPack');
        
        var nm=component.find("pck_name").get("v.value");
        // var cod=component.find("pck_code").get("v.value");
        var sel = component.find("Reporting_Type").get("v.value");
        if(!sel){
            //component.find("Reporting_Type").set("v.errors", [{message: "Complete this field"}]);
            //$A.util.addClass(component.find("Reporting_Type"), 'slds-has-error');
            component.set("v.showSpinner",false);
            component.find("Reporting_Type").set('v.validity', {valid:false, badInput :true});
            component.find("Reporting_Type").showHelpMessageIfInvalid();
        }
        else if(!nm){
            component.set("v.showSpinner",false);
            component.find("pck_name").set("v.errors", [{message: $A.get("$Label.c.Complete_this_field")}]);
            $A.util.addClass(component.find("pck_name"), 'slds-has-error');
        }
        /* else if(!cod){
            component.set("v.showSpinner",false);
            component.find("pck_code").set("v.errors", [{message: "Complete this field"}]);
            $A.util.addClass(component.find("pck_code"), 'slds-has-error');
        }*/
            else{
                console.log({
                    "name":nm  //"cod":cod
                }); 
                
                helper.addNewPack(component, event, helper);    
                
                /*var obj=new Object();
            obj.Id=cod;
            obj.Name=nm;
        component.set('v.selectedPack', obj);
        component.set('v.pckOpt', true);    
        component.set('v.packModal', false);*/
                
            }     
    },
    
    closePackModal: function(component, event, helper){
        component.set('v.packModal', false);
    },
    
    onBrandChange: function(component, event, helper){
        component.set("v.showSpinner",true);  
        var comp = component.get("v.brandObj"), 
            val = component.find("brand").get("v.value");
        
        var sel = component.find("Reporting_Type").get("v.value");       
        var brandMap  = JSON.stringify(comp);
        var obj = JSON.parse(brandMap);
        
        contains(obj, "Brand__c", val); //true
        
        var brndObjs = component.get('v.selectedBrand');
        var brndId =brndObjs.Id;
        helper.onBrandChange(component, event, helper);
        
        /*if(sel == "Update in Label Claim" || sel == "Existing Product Price update"){
            component.set("v.showSpinner",true);  
            helper.getUpdateClaims(component, event, helper);
           // helper.getFormulation(component, event, helper);
            
        }*/
        
        
        function contains(arr, key, val) {
            for (var i = 0; i < arr.length; i++) {
                if(arr[i][key] === val){
                    console.log('<------>')
                    var obj=new Object();
                    obj.Id=val;
                    obj.Name=arr[i].Brand__r.Name;
                    component.set('v.selectedBrand', obj);   
                    return true;
                }
            }
            
        }
        
        
    },
    
    onCmpnyChange: function(component, event, helper){
        
        console.log('@@@ after company change');
        //component.set("v.showSpinner",true);    
        var comp = component.get("v.cmpnyObj"); 
        var val = component.find("company").get("v.value");
        console.log('company value is '+val);
        var sel = component.find("Reporting_Type").get("v.value");
        var cmpnyMap  = JSON.stringify(comp);
        var obj = JSON.parse(cmpnyMap);
        
        contains(obj, "Company__c", val); 
        
        var cmpnyObjs = component.get('v.selectedCmpny');
        
        if(sel == "New Pack size in an Existing Brand" || sel == "Existing Product Price update" || sel == "Update in Label Claim" ){
            var cmpVal = component.find("company").get("v.value");
            helper.onCmpnyChange(component, event, helper,cmpVal);
        } 
        /*if(sel != "Existing Company, New Brand"){
            helper.getFormulation(component, event, helper);
        } */ 
        function contains(arr, key, val) {
            for (var i = 0; i < arr.length; i++) {
                if(arr[i][key] === val){
                    console.log('<------>')
                    var obj=new Object();
                    obj.Id=val;
                    obj.Name=arr[i].Company__r.Name;
                    component.set('v.selectedCmpny', obj);   
                    return true;
                }
            }
        }
    }, // end of function
    
    saveDetails: function(component, event, helper){
        
        var cName = component.get("v.countryName");
        
        if(cName =='India' || cName =='SWAL'){
            console.log('saveDetails');
            component.set("v.showSubmitSpinner",true);
            var sel = component.find("Reporting_Type").get("v.value");
            var comPrice_id = component.get('v.competitorPriceId');
            var brnd = '';
            var cmpny = '';
            
            if(sel == "New Company, New Brand" || sel == "Existing Company, New Brand" || sel == "New Pack size in an Existing Brand" || sel == "Existing Product Price update" || sel == "Update in Label Claim"){
                var newbrndadds = component.get('v.newbrndadd');
                if(newbrndadds == true){
                    var str=component.get('v.selectedRecordBrand');
                    if(str!=null){
                        brnd=str.Id;    
                    }
                    
                }else{
                    var str=component.get('v.selectedRecordBrand');
                    if(str!=null){
                        brnd=str.Brand__c;      
                    }
                    
                }
                //alert('in submit  '+brnd);
            }
            
            
            
            if(sel == "New Company, New Brand" || sel == "Existing Company, New Brand" || sel == "New Pack size in an Existing Brand" || sel == "Existing Product Price update" || sel == "Update in Label Claim"){
                var newcmpadds= component.get('v.newcmpadd');
                // alert('newcmpadd '+newcmpadds);
                if(newcmpadds == true){
                    var str=component.get('v.selectedRecordCompany');
                    if(str!=null){
                        cmpny = str.Id;     
                    }
                    
                }else{
                    var str=component.get('v.selectedRecordCompany');
                    if(str!=null){
                        cmpny = str.Company__c;   
                    }
                    
                }
                
            }
            var frmltn ='';
            if(sel == "New Company, New Brand" || sel == "Existing Company, New Brand" || sel == "New Pack size in an Existing Brand" || sel == "Existing Product Price update" || sel == "Update in Label Claim"){
                var frmoptns = component.get('v.frmoptn');
                // alert('frmoptns '+frmoptns);
                
                if(frmoptns == true){
                    var formltn = component.get('v.selectedRecordFormulation');
                    if(formltn!=null){
                        frmltn = formltn.Id; 
                    }
                    
                }else{
                    var formltn = component.get('v.selectedRecordFormulation');
                    if(formltn!=null){
                        frmltn = formltn.Formulation__c;  
                    }
                    
                }
                
            }
            
            
            
            var updatelabel = component.get('v.updateClaimObj');
            
            console.log({
                "sel":sel,
                "brnd":brnd,
                "cmpny":cmpny,
                "frmltn":frmltn,
                "updatelabel":updatelabel,
                "comPrice_id":comPrice_id
            }); 
            
            
            
            
            
            
            
            if(!sel){
                component.find("Reporting_Type").set("v.errors", $A.get("$Label.c.Complete_this_field"));
                $A.util.addClass(component.find("Reporting_Type"), 'slds-has-error');
                component.set("v.showSubmitSpinner",false);
                // component.find("Reporting_Type").set('v.validity', {valid:false, badInput :true});
                // component.find("Reporting_Type").showHelpMessageIfInvalid();
                //  component.find("MRP").setCustomValidity('Enter a date');
            }
            else if(!brnd){
                // component.find("brand").set("v.errors", [{message: "Complete this field"}]);
                // $A.util.addClass(component.find("brand"), 'slds-has-error');
                component.set("v.showSubmitSpinner",false);
                // component.find("brand").set('v.validity', {valid:false, badInput :true});
                // component.find("brand").showHelpMessageIfInvalid();
                alert($A.get("$Label.c.Please_select_Brand_or_Add_New_one"));
            }
                else if(!cmpny){
                    //component.find("company").set("v.errors", [{message: "Complete this field"}]);
                    // $A.util.addClass(component.find("company"), 'slds-has-error');
                    component.set("v.showSubmitSpinner",false);
                    //  component.find("company").set('v.validity', {valid:false, badInput :true});
                    //  component.find("company").showHelpMessageIfInvalid();
                    alert($A.get("$Label.c.Please_select_Company_or_Add_New_one"));
                }
                    else if(!frmltn || $A.util.isUndefined(frmltn)){
                        // component.find("formulation").set("v.errors", [{message: "Complete this field"}]);
                        // $A.util.addClass(component.find("formulation"), 'slds-has-error');
                        component.set("v.showSubmitSpinner",false);
                        //component.find("formulation").set('v.validity', {valid:false, badInput :true});
                        //component.find("formulation").showHelpMessageIfInvalid();
                        alert($A.get("$Label.c.Please_create_New_Formulation"));
                    }
                        else{
                            
                            if(sel == "New Company, New Brand" || sel == "Existing Company, New Brand"){
                                if(updatelabel.length==0){
                                    component.set("v.showSubmitSpinner",false);
                                    alert($A.get("$Label.c.Please_Add_UPDATE_LABEL_CLAIM"));
                                }
                                else{
                                    var c_pricObj ={};
                                    c_pricObj.sobjectType = 'Competitor_Price__c';
                                    if(comPrice_id == null || comPrice_id.length==0){
                                        c_pricObj.Reporting_Type__c=sel;
                                        c_pricObj.Brand__c=brnd;
                                        c_pricObj.Company__c=cmpny;
                                        c_pricObj.Formulation__c=frmltn;
                                    }
                                    helper.createPriceEntry(component, event, c_pricObj, updatelabel, comPrice_id);
                                    // createCompetitorPrice(component, event, helper, sel,brnd,cmpny,frmltn, priceDetails, updatelabel);
                                }
                                
                            }
                            else if(sel == "New Pack size in an Existing Brand" || sel == "Existing Product Price update"){
                                var c_pricObj ={};
                                c_pricObj.sobjectType = 'Competitor_Price__c';
                                helper.createPriceEntry(component, event, c_pricObj, updatelabel, comPrice_id);
                            }  
                                else if(sel == "Update in Label Claim"){
                                    if(updatelabel.length==0){
                                        component.set("v.showSubmitSpinner",false);
                                        alert($A.get("$Label.c.Please_Add_UPDATE_LABEL_CLAIM"));
                                    }
                                    else{
                                        var c_pricObj ={};
                                        c_pricObj.sobjectType = 'Competitor_Price__c';
                                        if(comPrice_id == null || comPrice_id.length==0){ 
                                            c_pricObj.Reporting_Type__c=sel;
                                            c_pricObj.Brand__c=brnd;
                                            c_pricObj.Company__c=cmpny;
                                            c_pricObj.Formulation__c=frmltn;
                                        }
                                        helper.createPriceEntry(component, event, c_pricObj, updatelabel, comPrice_id);            }
                                }
                            
                            
                            /* function createCompetitorPrice(component, event, helper, sel,brnd,cmpny,frmltn, priceDetails, updatelabel){
            var c_pricObj = new sObject();
                c_pricObj.Reporting_Type__c=sel;
                c_pricObj.Brand__c=brnd;
                c_pricObj.Company__c=cmpny;
                c_pricObj.Formulation__c=frmltn;
            
            helper.createPriceEntry(component, event, helper, c_pricObj, priceDetails, updatelabel);
        }*/
                        }
        }//end of India And SWAL
        
        
        
        
        // for Spain n Portugal and N Spain
        if(cName=='Spain' || cName=='Portugal' || cName=='Naturagri Spain' ){
            console.log('Complete save for Spain and Portugal');
            component.set("v.showSubmitSpinner",true);
            var sel = component.find("Reporting_Type").get("v.value");
            var comPrice_id = component.get('v.competitorPriceId');
            var brnd = '';
            var cmpny = '';
            
            if(sel == "New Company, New Brand" || sel == "Existing Company, New Brand" || sel == "New Pack size in an Existing Brand" || sel == "Existing Product Price update" || sel == "Update in Label Claim"){
                var newbrndadds = component.get('v.newbrndadd');
                if(newbrndadds == true){
                    var str=component.get('v.selectedRecordBrand');
                    if(str!=null){
                        brnd=str.Id;    
                    }
                    
                }else{
                    var str=component.get('v.selectedRecordBrand');
                    if(str!=null){
                        brnd=str.Brand__c;      
                    }
                    
                }
                //alert('in submit  '+brnd);
            }
            
            
            
            if(sel == "New Company, New Brand" || sel == "Existing Company, New Brand" || sel == "New Pack size in an Existing Brand" || sel == "Existing Product Price update" || sel == "Update in Label Claim"){
                var newcmpadds= component.get('v.newcmpadd');
                // alert('newcmpadd '+newcmpadds);
                if(newcmpadds == true){
                    var str=component.get('v.selectedRecordCompany');
                    if(str!=null){
                        cmpny = str.Id;     
                    }
                    
                }else{
                    var str=component.get('v.selectedRecordCompany');
                    if(str!=null){
                        cmpny = str.Company__c;   
                    }
                    
                }
                
            }
            
            console.log('After all cmpny '+cmpny);
            
            var frmltn ='';
            if(sel == "New Company, New Brand" || sel == "Existing Company, New Brand" || sel == "New Pack size in an Existing Brand" || sel == "Existing Product Price update" || sel == "Update in Label Claim"){
                var frmoptns = component.get('v.frmoptn');
                // alert('frmoptns '+frmoptns);
                
                if(frmoptns == true){
                    var formltn = component.get('v.selectedRecordFormulation');
                    if(formltn!=null){
                        frmltn = formltn.Id; 
                    }
                    
                }else{
                    var formltn = component.get('v.selectedRecordFormulation');
                    if(formltn!=null){
                        frmltn = formltn.Formulation__c;  
                    }
                    
                }
                
            }
            
            
            
            var updatelabel = component.get('v.updateClaimObj');
            
            console.log({
                "sel":sel,
                "brnd":brnd,
                "cmpny":cmpny,
                "frmltn":frmltn,
                "updatelabel":updatelabel,
                "comPrice_id":comPrice_id
            }); 
            
            
            if(!sel){
                component.find("Reporting_Type").set("v.errors", $A.get("$Label.c.Complete_this_field"));
                $A.util.addClass(component.find("Reporting_Type"), 'slds-has-error');
                component.set("v.showSubmitSpinner",false);
                
            }else if(!brnd){
                component.set("v.showSubmitSpinner",false);
                alert($A.get("$Label.c.Please_select_Brand_or_Add_New_one"));
            }else if(!cmpny){
                component.set("v.showSubmitSpinner",false);
                alert($A.get("$Label.c.Please_select_Company_or_Add_New_one"));
            }else if(!frmltn || $A.util.isUndefined(frmltn)){
                // component.find("formulation").set("v.errors", [{message: "Complete this field"}]);
                // $A.util.addClass(component.find("formulation"), 'slds-has-error');
                component.set("v.showSubmitSpinner",false);
                //component.find("formulation").set('v.validity', {valid:false, badInput :true});
                //component.find("formulation").showHelpMessageIfInvalid();
                alert($A.get("$Label.c.Please_create_New_Formulation"));
            }else{
                
                if(sel == "New Company, New Brand" || sel == "Existing Company, New Brand"){
                    if(updatelabel.length==0){
                        component.set("v.showSubmitSpinner",false);
                        alert($A.get("$Label.c.Please_Add_UPDATE_LABEL_CLAIM"));
                    }
                    else{
                        var c_pricObj ={};
                        c_pricObj.sobjectType = 'Competitor_Price__c';
                        if(comPrice_id == null || comPrice_id.length==0){
                            c_pricObj.Reporting_Type__c=sel;
                            c_pricObj.Brand__c=brnd;
                            console.log('After all cmpny 1'+cmpny);
                            c_pricObj.Company__c=cmpny;
                            c_pricObj.Formulation__c=frmltn;
                        }
                        helper.createPriceEntry(component, event, c_pricObj, updatelabel, comPrice_id);
                        // createCompetitorPrice(component, event, helper, sel,brnd,cmpny,frmltn, priceDetails, updatelabel);
                    }
                    
                }
                else if(sel == "New Pack size in an Existing Brand" || sel == "Existing Product Price update"){
                    var c_pricObj ={};
                    c_pricObj.sobjectType = 'Competitor_Price__c';
                    helper.createPriceEntry(component, event, c_pricObj, updatelabel, comPrice_id);
                }  
                    else if(sel == "Update in Label Claim"){
                        if(updatelabel.length==0){
                            component.set("v.showSubmitSpinner",false);
                            alert($A.get("$Label.c.Please_Add_UPDATE_LABEL_CLAIM"));
                        }
                        else{
                            var c_pricObj ={};
                            c_pricObj.sobjectType = 'Competitor_Price__c';
                            if(comPrice_id == null || comPrice_id.length==0){ 
                                c_pricObj.Reporting_Type__c=sel;
                                c_pricObj.Brand__c=brnd;
                                console.log('After all cmpny 2'+cmpny);
                                c_pricObj.Company__c=cmpny;
                                c_pricObj.Formulation__c=frmltn;
                            }
                            helper.createPriceEntry(component, event, c_pricObj, updatelabel, comPrice_id);           
                        }
                    }
                
            }
        }// end of Spain1 and Portugal and N Spain
        
        
        
        
    },
    
    newSchemeDetails : function(component, event, helper) {
        
        var cName = component.get("v.countryName");
        console.log('cName '+cName);
        if(cName == 'India' || cName == 'SWAL'){
            console.log("inside newSchemeDetails");  
            var flag = true;
            var schmObjs = component.get('v.priceDetailsObj');
            var comPrice_id = component.get('v.competitorPriceId');
            var selc = component.find("Reporting_Type").get("v.value");
            
            var pck_size='';
            if(selc == "New Pack size in an Existing Brand" || selc == "New Company, New Brand" || selc == "Existing Company, New Brand" || selc == "Existing Product Price update"){
                
                
                var str=component.get('v.selectedRecordPackSize');
                if(str!=null){
                    pck_size=str.Id;
                }else{
                    pck_size='';
                }
            }
            
            var mrp = parseInt(component.find("MRP").get("v.value"));
            var frm_price= parseInt(component.find("farmer_price").get("v.value"));
            var ret_price= parseInt(component.find("retailer_price").get("v.value"));
            var dis_price= parseInt(component.find("distributor_price").get("v.value"));
            var schm=component.find("schemes").get("v.value");
            var cmnt=component.find("comments").get("v.value");
            var flag = true;
            
            var brnd = '';
            if(selc == "Existing Company, New Brand" || selc == "New Company, New Brand"){ 
                
                var str =component.get('v.selectedRecordBrand');
                
                if(str!=null){
                    brnd=str.Id;    
                }else{
                    brnd='';    
                }
                
            }
            
            if(selc == "New Pack size in an Existing Brand" || selc == "Existing Product Price update"){
                var str =component.get('v.selectedRecordBrand');
                //alert('str '+JSON.stringify(str));
                
                if(str!=null){
                    var tempbrd = component.get('v.newbrndadd');
                    if(tempbrd){
                        brnd = str.Id;    
                    }else{
                        brnd = str.Brand__c;        
                    }
                    
                }else{
                    brnd = '';    
                }
            }
            
            
            var cmpny = '';
            
            if(selc == "New Company, New Brand"){
                
                var str=component.get('v.selectedRecordCompany');
                if(str!=null){
                    cmpny=str.Id;    
                }else{
                    cmpny='';    
                }
            }
            
            if(selc == "Existing Company, New Brand")
            {
                var newcmpadds = component.get('v.newcmpadd');
                if(newcmpadds == true){
                    
                    var str=component.get('v.selectedRecordCompany');
                    if(str!=null){
                        cmpny=str.Id;     
                    }else{
                        cmpny='';     
                    }
                }else{
                    var str=component.get('v.selectedRecordCompany');
                    if(str!=null){
                        cmpny=str.Company__c;         
                    }else{
                        cmpny='';     
                    }
                    
                }
                
            }  
            
            
            if(selc == "New Pack size in an Existing Brand" || selc == "Existing Product Price update" || selc == "Update in Label Claim")
            {
                var str=component.get('v.selectedRecordCompany');
                if(str!=null){
                    cmpny=str.Company__c;        
                }else{
                    cmpny='';    
                }
            }
            
            //this is for Formulation
            var frmltn ='';
            if(selc == "New Pack size in an Existing Brand"  || selc == "Existing Product Price update"){
                var formltn = component.get('v.selectedRecordFormulation'); 
                var foltn = component.get('v.frmoptn');
                if(foltn == true){
                    if(formltn!=null){
                        frmltn = formltn.Id;          
                    }else{
                        frmltn ='';      
                    }
                    
                    
                    
                }else{
                    if(formltn!=null){
                        frmltn = formltn.Formulation__c;          
                    }else{
                        frmltn = '';      
                    }
                    
                }
                
                
                
            }else{
                var formltn = component.get('v.selectedRecordFormulation'); 
                var foltn = component.get('v.frmoptn');
                if(foltn == true){
                    if(formltn!=null){
                        frmltn = formltn.Id;          
                    }else{
                        frmltn = '';      
                    }
                    
                    
                }else{
                    if(formltn!=null){
                        frmltn = formltn.Formulation__c;  
                    }else{
                        frmltn = '';  
                    }
                    
                }
                
            }
            
            
            
            // alert('new company new brand new formualtion '+frmltn);
            
            console.log({
                "sel":selc,
                "brnd":brnd,
                "cmpny":cmpny,
                "frmltn":frmltn,
                "comPrice_id":comPrice_id
            }); 
            
            console.log({
                "pck_size":pck_size,
                "mrp":mrp,
                "frm_price":frm_price,
                "ret_price":ret_price,
                "dis_price":dis_price,
                "schm":schm,
                "cmnt":cmnt
            });
            var schemefilesize = component.get("v.schFileSize");
            var packfilesize = component.get("v.pacFileSize");
            var labelfilesize = component.get("v.lablFileSize");
            var isFileEmpty = false;
            
            console.log('schemefilesize'+schemefilesize);
            console.log('packfilesize'+packfilesize);
            console.log('labelfilesize'+labelfilesize);
            if(schemefilesize == 0 && schmObjs.length == 0){
                document.getElementById("schError").style.display = "block";
                //$("#schError").css("display", "block");
                component.set("v.showSpinner",false); 
                isFileEmpty = true;
            }else{
                document.getElementById("schError").style.display = "none";
                
            }
            if(packfilesize == 0){
                document.getElementById("pacError").style.display = "block";
                component.set("v.showSpinner",false);
                isFileEmpty = true;
            }else{
                document.getElementById("pacError").style.display = "none";
            }
            if(labelfilesize == 0 && schmObjs.length == 0){
                document.getElementById("labError").style.display = "block";
                component.set("v.showSpinner",false);
                isFileEmpty = true;
            }else{
                document.getElementById("labError").style.display = "none";
                
            }
            
            /*--------- Patch added by Nikhil on 08/04/2019 to make image selection non mandatory for reporting type 'Existing Product Price update'-------Start---- */
            
            if(selc == "Existing Product Price update"){
                isFileEmpty = false;
                document.getElementById("labError").style.display = "none";
                document.getElementById("pacError").style.display = "none";
                document.getElementById("schError").style.display = "none";
                
            }
            
            /*----------------------------------------------- Patch End -----------------------------------------------------------------------------------*/
            
            if( !isFileEmpty ){
                component.set("v.showSpinner",true);
            }
            if(!brnd){
                component.set("v.showSpinner",false);
                alert($A.get("$Label.c.Please_select_Brand_or_Add_New_one"));
            }
            else if(!cmpny){
                component.set("v.showSpinner",false);
                alert($A.get("$Label.c.Please_select_Company_or_Add_New_one"));
            }
                else if(!frmltn || $A.util.isUndefined(frmltn)){
                    component.set("v.showSpinner",false);
                    alert($A.get("$Label.c.Please_create_New_Formulation"));
                }
                    else if(!pck_size){
                        component.set("v.showSpinner",false);
                        alert($A.get("$Label.c.Please_select_pack_size"));
                    }
                        else if(!mrp){
                            component.set("v.showSpinner",false);
                            component.find("MRP").set('v.validity', {valid:false, badInput :true});
                            component.find("MRP").showHelpMessageIfInvalid();
                            
                        }
                            else if(!frm_price){
                                component.set("v.showSpinner",false);
                                component.find("farmer_price").set('v.validity', {valid:false, badInput :true});
                                component.find("farmer_price").showHelpMessageIfInvalid();
                            }
                                else if(!ret_price){
                                    component.set("v.showSpinner",false);
                                    component.find("retailer_price").set('v.validity', {valid:false, badInput :true});
                                    component.find("retailer_price").showHelpMessageIfInvalid();
                                }
                                    else if(!dis_price){
                                        component.set("v.showSpinner",false);
                                        component.find("distributor_price").set('v.validity', {valid:false, badInput :true});
                                        component.find("distributor_price").showHelpMessageIfInvalid();
                                    }
                                        else if(!schm){
                                            component.set("v.showSpinner",false);
                                            component.find("schemes").set('v.validity', {valid:false, badInput :true});
                                            component.find("schemes").showHelpMessageIfInvalid();
                                        }
                                            else{
                                                
                                                var c_pricObj ={};
                                                c_pricObj.sobjectType = 'Competitor_Price__c';
                                                if(comPrice_id == null || comPrice_id.length==0){
                                                    c_pricObj.Reporting_Type__c=selc;
                                                    c_pricObj.Brand__c=brnd;
                                                    c_pricObj.Company__c=cmpny;
                                                    c_pricObj.Formulation__c=frmltn;
                                                }
                                                var schemeObj ={};
                                                var Count ;
                                                if(flag){
                                                    console.log('value of flag inside flag ');
                                                    schemeObj.sobjectType = 'Price_Scheme_Detail__c';
                                                    schemeObj.Comment__c = cmnt;
                                                    schemeObj.Distributor_Price__c = dis_price;
                                                    schemeObj.Farmer_Price__c = frm_price;
                                                    schemeObj.MRP__c = mrp;
                                                    
                                                    console.log('@@@@@ 1782 pck_size '+pck_size);
                                                    schemeObj.Pack_Size__c = pck_size;
                                                    schemeObj.Retailer_Price__c = ret_price;
                                                    schemeObj.Scheme__c = schm;
                                                    Count = Object.keys(schemeObj).length;
                                                    console.log('size of schemeObjs '+Count);
                                                }
                                                
                                                if(!isFileEmpty && Count>0 && flag === true){
                                                    helper.newPriceEntry(component, event, c_pricObj, schemeObj, comPrice_id);
                                                    component.find("schemes").set("v.value",schm);
                                                    component.find("schemes").set("v.disabled", true);  
                                                    
                                                    
                                                    //component.find("pack_size").set("v.value",""); Commented by Vishal
                                                    var forclose = component.find("lookup-pill-PackSize");
                                                    $A.util.addClass(forclose, 'slds-hide');
                                                    $A.util.removeClass(forclose, 'slds-show');
                                                    
                                                    var lookUpTarget = component.find("lookupFieldPackSize");
                                                    $A.util.addClass(lookUpTarget, 'slds-show');
                                                    $A.util.removeClass(lookUpTarget, 'slds-hide'); 
                                                    component.find("vPackSize").set("v.value","");
                                                    
                                                    
                                                    
                                                    component.find("MRP").set("v.value","");
                                                    component.find("farmer_price").set("v.value","");
                                                    component.find("retailer_price").set("v.value","");
                                                    component.find("distributor_price").set("v.value","");
                                                    //component.find("schemes").set("v.value","");
                                                    component.find("comments").set("v.value","");
                                                    console.log('isFileEmpty 1');
                                                    component.set('v.isLock',true);
                                                    
                                                    
                                                    
                                                }else{
                                                    component.set("v.showSpinner",false); 
                                                }
                                                //component.set('v.priceDetailsObj', schmObjs);
                                                
                                            } 
        }//end of India and SWAL 
        
        
        if(cName == 'Spain' || cName == 'Portugal' || cName == 'Naturagri Spain' ){
            var flag = true;
            var schmObjs = component.get('v.priceDetailsObj');
            var comPrice_id = component.get('v.competitorPriceId');
            var selc = component.find("Reporting_Type").get("v.value");
            console.log('Inside Spain');
            var pck_size='';
            if(selc == "New Pack size in an Existing Brand" || selc == "New Company, New Brand" || selc == "Existing Company, New Brand" || selc == "Existing Product Price update"){
                var str=component.get('v.selectedRecordPackSize');
                if(str!=null){
                    pck_size=str.Id;
                }else{
                    pck_size='';
                }
            }
            console.log('Inside Spain 1');
            var mrp = parseFloat(component.find("MRP").get("v.value"));     // Start GRZ(Dheeraj Sharma) : INC0374606  Date :09-09-2022
            var frm_price= parseFloat(component.find("farmer_price").get("v.value"));    // Start GRZ(Dheeraj Sharma) : INC0374606  Date :09-09-2022
            var ret_price= parseFloat(component.find("retailer_price").get("v.value"));      // Start GRZ(Dheeraj Sharma) : INC0374606  Date :09-09-2022
            var dis_price= parseFloat(component.find("distributor_price").get("v.value"));     // Start GRZ(Dheeraj Sharma) : INC0374606  Date :09-09-2022
            var schm=component.find("schemes").get("v.value");
            var cmnt=component.find("comments").get("v.value");
            var flag = true;
            
            console.log('Inside Spain 2');
            var brnd = '';
            if(selc == "Existing Company, New Brand" || selc == "New Company, New Brand"){ 
                
                var str =component.get('v.selectedRecordBrand');
                
                if(str!=null){
                    brnd=str.Id;    
                }else{
                    brnd='';    
                }
                
            }
            
            console.log('Inside Spain 3');
            
            if(selc == "New Pack size in an Existing Brand" || selc == "Existing Product Price update"){
                var str =component.get('v.selectedRecordBrand');
                //alert('str '+JSON.stringify(str));
                
                if(str!=null){
                    var tempbrd = component.get('v.newbrndadd');
                    if(tempbrd){
                        brnd = str.Id;    
                    }else{
                        brnd = str.Brand__c;        
                    }
                    
                }else{
                    brnd = '';    
                }
            }
            
            console.log('Inside Spain 4');
            
            var cmpny = '';
            
            if(selc == "New Company, New Brand"){
                
                var str=component.get('v.selectedRecordCompany');
                if(str!=null){
                    cmpny=str.Id;    
                }else{
                    cmpny='';    
                }
            }
            
            console.log('Inside Spain 5');
            
            if(selc == "Existing Company, New Brand"){
                var newcmpadds = component.get('v.newcmpadd');
                if(newcmpadds == true){
                    
                    var str=component.get('v.selectedRecordCompany');
                    if(str!=null){
                        cmpny=str.Id;     
                    }else{
                        cmpny='';     
                    }
                }else{
                    var str=component.get('v.selectedRecordCompany');
                    if(str!=null){
                        cmpny=str.Company__c;         
                    }else{
                        cmpny='';     
                    }
                    
                }
                
            }
            
            console.log('Inside Spain 6');
            
            if(selc == "New Pack size in an Existing Brand" || selc == "Existing Product Price update" || selc == "Update in Label Claim"){
                var str=component.get('v.selectedRecordCompany');
                if(str!=null){
                    cmpny=str.Company__c;        
                }else{
                    cmpny='';    
                }
            }
            
            console.log('Inside Spain 7');
            
            //this is for Formulation
            var frmltn ='';
            if(selc == "New Pack size in an Existing Brand"  || selc == "Existing Product Price update"){
                var formltn = component.get('v.selectedRecordFormulation'); 
                var foltn = component.get('v.frmoptn');
                if(foltn == true){
                    if(formltn!=null){
                        frmltn = formltn.Id;          
                    }else{
                        frmltn ='';      
                    }
                    
                    
                    
                }else{
                    if(formltn!=null){
                        frmltn = formltn.Formulation__c;          
                    }else{
                        frmltn = '';      
                    }
                    
                }
                
                
                
            }else{
                var formltn = component.get('v.selectedRecordFormulation'); 
                var foltn = component.get('v.frmoptn');
                if(foltn == true){
                    if(formltn!=null){
                        frmltn = formltn.Id;          
                    }else{
                        frmltn = '';      
                    }
                    
                    
                }else{
                    if(formltn!=null){
                        frmltn = formltn.Formulation__c;  
                    }else{
                        frmltn = '';  
                    }
                    
                }
                
            }
            
            console.log('Inside Spain 8');
            
            
            
            console.log({
                "sel":selc,
                "brnd":brnd,
                "cmpny":cmpny,
                "frmltn":frmltn,
                "comPrice_id":comPrice_id
            }); 
            
            
            console.log('pck_size '+pck_size);
            console.log({
                "pck_size":pck_size,
                "mrp":mrp,
                "frm_price":frm_price,
                "ret_price":ret_price,
                "dis_price":dis_price,
                "schm":schm,
                "cmnt":cmnt
            });
            
            var schemefilesize = component.get("v.schFileSize");
            var packfilesize = component.get("v.pacFileSize");
            var labelfilesize = component.get("v.lablFileSize");
            var isFileEmpty = false;
            
            if(schemefilesize == 0 && schmObjs.length == 0){
                document.getElementById("schError").style.display = "block";
                //$("#schError").css("display", "block");
                component.set("v.showSpinner",false); 
                isFileEmpty = true;
            }else{
                document.getElementById("schError").style.display = "none";
                
            }
            if(packfilesize == 0){
                document.getElementById("pacError").style.display = "block";
                component.set("v.showSpinner",false);
                isFileEmpty = true;
            }else{
                document.getElementById("pacError").style.display = "none";
            }
            if(labelfilesize == 0 && schmObjs.length == 0){
                document.getElementById("labError").style.display = "block";
                component.set("v.showSpinner",false);
                isFileEmpty = true;
            }else{
                document.getElementById("labError").style.display = "none";
                
            }
            
            if(selc == "Existing Product Price update"){
                isFileEmpty = false;
                document.getElementById("labError").style.display = "none";
                document.getElementById("pacError").style.display = "none";
                document.getElementById("schError").style.display = "none";
                
            }
            
            if( !isFileEmpty ){
                component.set("v.showSpinner",true);
            }
            
            console.log('mrp '+mrp);
                    
            if(isNaN(mrp) && isNaN(frm_price) && isNaN(ret_price) && isNaN(dis_price) ){
                console.log('inside Empty ');
                flag = false;
                alert($A.get("$Label.c.Enter_atleat_one_Price_in_PRICE_AND_SCHEME_DETAILS_Section"));
                component.set("v.showSpinner",false); 
            }else{
                flag = true;
            }
            if(flag){
                var c_pricObj ={};
                c_pricObj.sobjectType = 'Competitor_Price__c';
                if(comPrice_id == null || comPrice_id.length==0){
                    c_pricObj.Reporting_Type__c=selc;
                    c_pricObj.Brand__c=brnd;
                    console.log('Company Name '+cmpny);
                    c_pricObj.Company__c=cmpny;
                    c_pricObj.Formulation__c=frmltn;
                }
                console.log('c_pricObj '+c_pricObj);
                var schemeObj ={};
                var Count ;
                schemeObj.sobjectType = 'Price_Scheme_Detail__c';
                schemeObj.Comment__c = cmnt;
                schemeObj.Distributor_Price__c = dis_price;
                schemeObj.Farmer_Price__c = frm_price;
                schemeObj.MRP__c = mrp;
                console.log('@@@@@ 2074 pck_size '+pck_size);
                
                schemeObj.Pack_Size__c = pck_size;
                schemeObj.Retailer_Price__c = ret_price;
                schemeObj.Scheme__c = schm;
                Count = Object.keys(schemeObj).length;
                console.log('size of schemeObjs '+Count);
                if(!isFileEmpty && Count>0 && flag === true){
                    helper.newPriceEntry(component, event, c_pricObj, schemeObj, comPrice_id);
                    component.find("schemes").set("v.value",schm);
                    component.find("schemes").set("v.disabled", true);
                    
                    var forclose = component.find("lookup-pill-PackSize");
                    $A.util.addClass(forclose, 'slds-hide');
                    $A.util.removeClass(forclose, 'slds-show');
                    
                    var lookUpTarget = component.find("lookupFieldPackSize");
                    $A.util.addClass(lookUpTarget, 'slds-show');
                    $A.util.removeClass(lookUpTarget, 'slds-hide'); 
                    component.find("vPackSize").set("v.value","");
                     
                    component.find("MRP").set("v.value","");
                    component.find("farmer_price").set("v.value","");
                    component.find("retailer_price").set("v.value","");
                    component.find("distributor_price").set("v.value","");
                    //component.find("schemes").set("v.value","");
                    component.find("comments").set("v.value","");
                    console.log('isFileEmpty 1');
                    component.set('v.isLock',true);
                }
            }else{
                component.set("v.showSpinner",false); 
            }
            
           console.log('Inside Spain 9');
            
            
        }// end of Spain and Portugal and N Spain
        
        
    },
    
    
    
    
    onSchFilesizeChange:function(component, event, helper){
        var schemefilesize = component.get("v.schFileSize");
        if(schemefilesize !=0){
            document.getElementById("schError").style.display = "none";
            //$("#schError").css("display", "none");   
        }
    },
    onPackFileSizeChange:function(component, event, helper){
        var packfilesize = component.get("v.pacFileSize");
        console.log('onPackFileSizeChange - '+ packfilesize);
        if(packfilesize !=0){
            document.getElementById("pacError").style.display = "none";
            //$("#pacError").css("display", "none");   
        }
    },
    onlablFileSizeChange:function(component, event, helper){
        var labelfilesize = component.get("v.lablFileSize");
        if(labelfilesize !=0){
            document.getElementById("labError").style.display = "none";
            //$("#labError").css("display", "none");   
        }
    },
    
    cancelCPrice: function(component, event, helper){
        console.log('cancelCPrice called...');
        helper.cancelEntry(component, event);
    },
    
    onFormulationChange: function(component, event, helper){
        console.log('onFormulationChange called...');
        component.set("v.showSpinner",true);  
        var comp = component.get("v.selectedFormulation");
        
        var frmltn = component.find("formulation").get("v.value");       
        
        var obj = new Object();
        obj.Id=frmltn;
        
        component.set('v.selectedFormulation', obj);
        
        component.set("v.showSpinner",false);  
    },
    
    onFarmerPrice : function(component, event, helper){
        
        var fPrice = parseInt(component.find("farmer_price").get("v.value"));
        var mrpPrice = parseInt(component.find("MRP").get("v.value"));
        console.log('fPrice '+fPrice);
        console.log(' mrpPrice '+mrpPrice);
        if(mrpPrice < fPrice){
            if(confirm($A.get("$Label.c.Are_you_sure_Farmer_Price_Greater_than_MRP"))){
                console.log('');
            }else{
                component.find("farmer_price").set("v.value",'');
                component.find("farmer_price").focus();
                
            }
        }
        
    }, // end of onFarmerPrice
    
    onRetailerPrice : function(component, event, helper){
        var mrpPrice = parseInt(component.find("MRP").get("v.value"));
        var fPrice = parseInt(component.find("farmer_price").get("v.value"));
        var retailPrice = parseInt(component.find("retailer_price").get("v.value"));
        if(retailPrice>=mrpPrice){
            alert($A.get("$Label.c.Retailer_Price_should_be_less_than_MRP"));
            component.find("retailer_price").set("v.value",'');
            component.find("retailer_price").focus();
        }
        
    }, //end of onRetailerPrice
    
    onDistributorPrice : function(component, event, helper){
        var mrpPrice = parseInt(component.find("MRP").get("v.value"));
        var fPrice = parseInt(component.find("farmer_price").get("v.value"));
        var retailPrice = parseInt(component.find("retailer_price").get("v.value"));
        var distributorPrice = parseInt(component.find("distributor_price").get("v.value"));
        if(distributorPrice >= mrpPrice ||  distributorPrice >= retailPrice){
            alert($A.get("$Label.c.Distributor_Price_should_be_less_than_Retailer_Price")); 
            component.find("distributor_price").set("v.value",'');
            component.find("distributor_price").focus();
        }
        
        
    }, // end of Distributor Price
    
    onMRPPrice :function(component, event, helper){
        var mrpPrice = component.find("MRP").get("v.value");
        var retailPrice = component.find("retailer_price").get("v.value");
        var distributorPrice = component.find("distributor_price").get("v.value");
        
        if(retailPrice !='' || distributorPrice !=''){
            //var mrpPrice1 = parseInt(component.find("MRP").get("v.value"));
            //var retailPrice1 = parseInt(component.find("retailer_price").get("v.value"));
            //var distributorPrice1 =  parseInt(component.find("distributor_price").get("v.value"));
            if (mrpPrice <= retailPrice || mrpPrice <= distributorPrice){
                alert($A.get("$Label.c.MRP_should_not_be_less_than_Retailer_price_and_Distributor_Price")) ;
                component.find("MRP").set("v.value",'');
                //component.find("MRP").focus();
                
            }
            
        }
    }, // end of MRP Price
    
    
    //added by vishal
    onblurBrand : function(component,event,helper){ 
        
        component.set("v.listOfSearchRecordsBrand", null );
        var forclose = component.find("searchResBrand");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    onblurCompany : function(component,event,helper){ 
        
        component.set("v.listOfSearchRecordsCompany", null );
        var forclose = component.find("searchResCompany");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    
    
    
    clearBrand :function(component,event,helper){ 
        
        var brd = component.get("v.newbrndadd");
        var brd1 = component.get("v.isLock");
        
        if(brd1 == false ){
            component.set("v.listOfSearchRecordsBrand", null );
            component.set("v.selectedRecordBrand", null );
            component.find("openBrnd").set("v.disabled", false);
            
            
            var pillTarget = component.find("lookup-pill-Brand");
            var lookUpTarget = component.find("lookupFieldBrand"); 
            
            $A.util.addClass(pillTarget, 'slds-hide');
            $A.util.removeClass(pillTarget, 'slds-show');
            
            $A.util.addClass(lookUpTarget, 'slds-show');
            $A.util.removeClass(lookUpTarget, 'slds-hide'); 
            
            
            if(brd== false){
                
                component.set("v.listOfSearchRecordsCompany", null );
                component.set("v.selectedRecordCompany", null );
                var pillTarget1 = component.find("lookup-pill-Company");
                var lookUpTarget1 = component.find("lookupFieldCompany"); 
                
                
                $A.util.addClass(pillTarget1, 'slds-hide');
                $A.util.removeClass(pillTarget1, 'slds-show');
                
                $A.util.addClass(lookUpTarget1, 'slds-show');
                $A.util.removeClass(lookUpTarget1, 'slds-hide');
                
                
                component.set("v.listOfSearchRecordsFormulation", null );
                component.set("v.selectedRecordFormulation", null );
                var pillTarget2 = component.find("lookup-pill-Formulation");
                var lookUpTarget2 = component.find("lookupFieldFormulation"); 
                
                $A.util.addClass(pillTarget2, 'slds-hide');
                $A.util.removeClass(pillTarget2, 'slds-show');
                
                $A.util.addClass(lookUpTarget2, 'slds-show');
                $A.util.removeClass(lookUpTarget2, 'slds-hide'); 
            }
            component.find("vBrand").set("v.value", '');
            
        }
        
        
        
        
    },
    
    clearCompany :function(component,event,helper){ 
        var cmp = component.get("v.newcmpadd");
        var cmp1 = component.get("v.isLock");
        
        if(cmp1 == false){
            var pillTarget = component.find("lookup-pill-Company");
            var lookUpTarget = component.find("lookupFieldCompany"); 
            component.find("openCmpny").set("v.disabled", false);
            $A.util.addClass(pillTarget, 'slds-hide');
            $A.util.removeClass(pillTarget, 'slds-show');
            $A.util.addClass(lookUpTarget, 'slds-show');
            $A.util.removeClass(lookUpTarget, 'slds-hide');
            component.find("vCompany").set("v.value", '');
        }
        
        
    },
    
    
    
    onfocusBrand : function(component,event,helper){
        
        $A.util.addClass(component.find("mySpinnerBrand"), "slds-show");
        var forOpen = component.find("searchResBrand");
        
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
        var getInputkeyWordBrand = '';
        
        console.log('infocus brand company id '+component.get("v.cmpId"));
        console.log('infocus flag '+component.get("v.flagCmp"));
        
        var tmpFlagCmp = component.get("v.flagCmp");
        if(tmpFlagCmp){
            getInputkeyWordBrand =  component.get("v.cmpId");
        }else{
            getInputkeyWordBrand =  '';
        }
        
        
        helper.searchHelperBrand(component,event,getInputkeyWordBrand);
    },
    
    onfocusCompany : function(component,event,helper){
        
        $A.util.addClass(component.find("mySpinnerCompany"), "slds-show"); 
        var forOpen = component.find("searchResCompany");
        
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        var getInputkeyWordCompany = '';
        helper.searchHelperCompany(component,event,getInputkeyWordCompany);
        
        
        
    },
    
    
    
    
    keyPressControllerBrand : function(component, event, helper) {
        
        var getInputkeyWordBrand = component.get("v.SearchKeyWordBrand");
        
        if( getInputkeyWordBrand.length > 2 ){
            console.log('getInputkeyWordBrand '+getInputkeyWordBrand);
            var forOpen = component.find("searchResBrand");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelperOnBrandKeyPress(component,event,getInputkeyWordBrand);
            
        }
        
    },
    
    
    
    keyPressControllerCompany : function(component, event, helper) {
        
        var getInputkeyWordCompany = component.get("v.SearchKeyWordCompany");
        
        if( getInputkeyWordCompany.length > 2 ){
            
            var forOpen = component.find("searchResCompany");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelperOnCompanyKeyPress(component,event,getInputkeyWordCompany);
            
        }
        
    },
    
    
    
    selectRecordBrand : function(component, event, helper){  
        
        
        var isExpandable = document.getElementById('selectBrands').value;
        // var isExpandablehdn = component.find("hdnBrandId").get("v.value") ;
        
        
        
        // get the selected record from list  
        // var getSelectRecord = component.get("v.oRecord");
        
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEventBrand : function(component, event, helper) {
        // get the selected Account record from the COMPONETN event 
        
        console.log('inaction handleComponentEventBrand ');
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        component.set("v.selectedRecordBrand" , selectedAccountGetFromEvent); 
        
        var brdID = selectedAccountGetFromEvent.Brand__c;
        var cmpID = selectedAccountGetFromEvent.Company__c;
        
        var forclose = component.find("lookup-pill-Brand");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchResBrand");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupFieldBrand");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show'); 
        
        helper.getCompanyOnBrand(component,event,brdID);
        helper.getFormulationOnBrand(component,event,brdID,cmpID); // this function is getting formulation by sending Brand id and Company id
        
    },
    
    
    
    
    
    
    
    handleComponentEventCompany : function(component, event, helper) { 
        
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        component.set("v.selectedRecordCompany" , selectedAccountGetFromEvent); 
        var tmpcmpId = component.get("v.selectedRecordCompany");
        
        component.set("v.cmpId",tmpcmpId.Company__c); 
        component.set("v.flagCmp",true); 
        
        
        
        console.log('you have select company first ');
        console.log('selected tmpcmpId is '+tmpcmpId.Company__c);
        
        
        var forclose = component.find("lookup-pill-Company");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchResCompany");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupFieldCompany");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show'); 
        
        
    },
    
    
    
    
    onblurFormulation : function(component,event,helper){ 
        
        component.set("v.listOfSearchRecordsFormulation", null );
        var forclose = component.find("searchResFormulation");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    clearFormulation :function(component,event,helper){ 
        var frm = component.get("v.frmoptn");
        var frm1 = component.get("v.isLock");
        
        if(frm1 == false){
            var pillTarget = component.find("lookup-pill-Formulation");
            var lookUpTarget = component.find("lookupFieldFormulation"); 
            component.find("openFrmltn").set("v.disabled", false);
            $A.util.addClass(pillTarget, 'slds-hide');
            $A.util.removeClass(pillTarget, 'slds-show');
            
            $A.util.addClass(lookUpTarget, 'slds-show');
            $A.util.removeClass(lookUpTarget, 'slds-hide'); 
            component.find("vFormulation").set("v.value", '');
        }
    },
    
    onfocusFormulation : function(component,event,helper){
        
        $A.util.addClass(component.find("mySpinnerFormulation"), "slds-show"); 
        var forOpen = component.find("searchResFormulation");
        
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        var getInputkeyWordFormulation = '';
        helper.searchHelperFormulation(component,event,getInputkeyWordFormulation);
        
    },
    
    
    keyPressControllerFormulation : function(component, event, helper) {
        
        var getInputkeyWordFormulation = component.get("v.SearchKeyWordFormulation");
        
        if( getInputkeyWordFormulation.length > 2 ){
            
            var forOpen = component.find("searchResFormulation");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelperOnFormulationKeyPress(component,event,getInputkeyWordFormulation);
            
        }
        
    },
    
    
    
    handleComponentEventFormulation : function(component, event, helper) { 
        
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        component.set("v.selectedRecordFormulation" , selectedAccountGetFromEvent); 
        
        
        var forclose = component.find("lookup-pill-Formulation");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchResFormulation");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupFieldFormulation");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show'); 
    },
    
    
    onfocusPackSize : function(component,event,helper){
        
        $A.util.addClass(component.find("mySpinnerPackSize"), "slds-show"); 
        var forOpen = component.find("searchResPackSize");
        
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        var getInputkeyWordPackSize = '';
        helper.searchHelperPackSize(component,event,getInputkeyWordPackSize);
        
    },    
    
    
    onblurPackSize : function(component,event,helper){ 
        component.set("v.listOfSearchRecordsPackSize", null );
        var forclose = component.find("searchResPackSize");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    keyPressControllerPackSize :function(component,event,helper){ 
        var getInputkeyWordPackSize = component.get("v.SearchKeyWordPackSize");
        
        if(getInputkeyWordPackSize.length > 2 ){
            
            var forOpen = component.find("searchResPackSize");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelperOnPackSizeKeyPress(component,event,getInputkeyWordPackSize);
            
        }
    },
    
    
    handleComponentEventPackSize : function(component, event, helper) { 
        
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        component.set("v.selectedRecordPackSize" , selectedAccountGetFromEvent); 
        
        
        var forclose = component.find("lookup-pill-PackSize");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchResPackSize");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupFieldPackSize");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show'); 
    },
    
    clearPackSize :function(component,event,helper){ 
        var frm = component.get("v.newpacksizeadd");
        // alert('frm'+frm); 
        component.set("v.selectedRecordPackSize",null);
        component.find("vPackSize").set('v.value','');
        
        var pillTarget = component.find("lookup-pill-PackSize");
        var lookUpTarget = component.find("lookupFieldPackSize"); 
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide'); 
        
    },
    
    onblurCrop : function(component,event,helper){ 
        component.set("v.listOfSearchRecordsCrop", null );
        var forclose = component.find("searchResCrop");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    
    onfocusCrop : function(component,event,helper){
        
        $A.util.addClass(component.find("mySpinnerCrop"), "slds-show"); 
        var forOpen = component.find("searchResCrop");
        
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        var getInputkeyWordCrop = '';
        helper.searchHelperCrop(component,event,getInputkeyWordCrop);
        
    }, 
    
    
    keyPressControllerCrop : function(component,event,helper){
        var getInputkeyWordCrop = component.get("v.SearchKeyWordCrop");
        console.log('getInputkeyWordCrop '+getInputkeyWordCrop);
        if(getInputkeyWordCrop.length > 2 ){
            
            var forOpen = component.find("searchResCrop");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelperOnCropKeyPress(component,event,getInputkeyWordCrop);
            
        }
    },
    
    handleComponentEventCrop : function(component, event, helper) { 
        
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        component.set("v.selectedRecordCrop" , selectedAccountGetFromEvent); 
        
        var forclose = component.find("lookup-pill-Crop");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchResCrop");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupFieldCrop");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show'); 
    },
    
    
    clearCrop :function(component,event,helper){  
        
        var pillTarget = component.find("lookup-pill-Crop");
        var lookUpTarget = component.find("lookupFieldCrop"); 
        component.set("v.selectedRecordCrop",null);
        component.find("vCrop").set('v.value','');
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide'); 
    },
    
    onfocusPest : function(component,event,helper){
        
        $A.util.addClass(component.find("mySpinnerPest"), "slds-show"); 
        var forOpen = component.find("searchResPest");
        
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        var getInputkeyWordPest = '';
        helper.searchHelperPest(component,event,getInputkeyWordPest);
        
    }, 
    
    onblurPest : function(component,event,helper){ 
        component.set("v.listOfSearchRecordsPest", null );
        var forclose = component.find("searchResPest");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    
    keyPressControllerPest : function(component,event,helper){
        var getInputkeyWordPest = component.get("v.SearchKeyWordPest");
        //console.log('getInputkeyWordPest '+getInputkeyWordPest);
        if(getInputkeyWordPest.length > 2 ){
            
            var forOpen = component.find("searchResPest");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelperOnPestKeyPress(component,event,getInputkeyWordPest);
            
        }
    },
    
    clearPest :function(component,event,helper){  
        
        var pillTarget = component.find("lookup-pill-Pest");
        var lookUpTarget = component.find("lookupFieldPest"); 
        component.set("v.selectedRecordPest",null);
        component.find("vPest").set('v.value','');
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide'); 
    },
    
    handleComponentEventPest : function(component, event, helper) { 
        
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        component.set("v.selectedRecordPest" , selectedAccountGetFromEvent); 
        
        var forclose = component.find("lookup-pill-Pest");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchResPest");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupFieldPest");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show'); 
    },
    
    
    
    
    
    
})