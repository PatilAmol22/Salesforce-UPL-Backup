({
    getBrandCategorys:function(component,event,helper){
        console.log('getBrandCategorys called..');
        var action = component.get("c.getBrandCategorys");
        action.setCallback(this,function(response){
            console.log(response.getState());
            if(response.getState() == 'SUCCESS'){
                console.log(response.getReturnValue());  
                component.set("v.catgryObj",response.getReturnValue());
            } 
        }); 
        $A.enqueueAction(action);	
    },
    
    getBrandList:function(component,event,helper){
        console.log('getBrandList called..');
        var action2 = component.get("c.getBrandList");
        action2.setCallback(this,function(response){
            console.log(response.getState());
            if(response.getState() == 'SUCCESS'){
                console.log(response.getReturnValue());  
                component.set("v.brandObj",response.getReturnValue());
                
            } 
            component.set("v.showSpinner",false);  
        }); 
        $A.enqueueAction(action2);	
    },
    
    getCmpnyList:function(component,event,helper){
        console.log('getCmpnyList called..');
        var action3 = component.get("c.getCmpnyList");
        action3.setCallback(this,function(response){
            console.log(response.getState());
            if(response.getState() == 'SUCCESS'){
                console.log(response.getReturnValue());  
                component.set("v.cmpnyObj",response.getReturnValue());
            } 
        }); 
        $A.enqueueAction(action3);	
    },
    
    getPackList:function(component,event,helper){
        console.log('getPackList called..');
        var action4 = component.get("c.getPackList");
        action4.setParams({
            'searchKeyWordPackSize': ''
        });
        
        action4.setCallback(this,function(response){
            console.log(response.getState());
            if(response.getState() == 'SUCCESS'){
                console.log(response.getReturnValue());  
                component.set("v.pckObj",response.getReturnValue());
                //  component.set("v.showSpinner",false);
            } 
            component.set("v.showSpinner",false);
        }); 
        $A.enqueueAction(action4);	
    },
    
    getCropList:function(component,event,helper){
        console.log('getCropList called..');
        var action5 = component.get("c.cropList");
        action5.setParams({
            'searchKeyWordCrop': ''
        });
        action5.setCallback(this,function(response){
            console.log(response.getState());
            if(response.getState() == 'SUCCESS'){
                console.log(response.getReturnValue());  
                component.set("v.cropObj",response.getReturnValue());
                
            } 
        }); 
        $A.enqueueAction(action5);	
    },
    
    getPestList:function(component,event,helper){
        console.log('getPestList called..');
        var action6 = component.get("c.pestList");
        action6.setCallback(this,function(response){
            console.log(response.getState());
            if(response.getState() == 'SUCCESS'){
                console.log(response.getReturnValue());  
                component.set("v.pestObj",response.getReturnValue());
                
            } 
            component.set("v.showSpinner",false);
        }); 
        $A.enqueueAction(action6);	
    },
    
    
    onBrandChange:function(component,event,helper){
        console.log('onBrandChange called..');
        var action7 = component.get("c.getCmpnyListOnBrnd");
        var sel = component.find("Reporting_Type").get("v.value");
        var brnd = component.find("brand").get("v.value");
        
        action7.setParams({
            "brndId":brnd
        });
        
        action7.setCallback(this,function(response){
            console.log(response.getState());
            if(response.getState() == 'SUCCESS'){
                
                if(sel != "Existing Company, New Brand"){
                    
                    
                    component.set("v.selectedCmpny",response.getReturnValue());
                    // component.set("v.cmpnyObj",response.getReturnValue());
                    component.set("v.cmpnyOpt",true);	 
                    component.set("v.hiddenCmpnyId",response.getReturnValue().Company__c);	
                    
                    
                    var companyId = response.getReturnValue().Company__c;
                    console.log('hidden id of company '+response.getReturnValue().Company__c);
                    // component.set("v.hiddenCmpnyId",response.getReturnValue()[0].Company__c);
                    if(sel == "Update in Label Claim" || sel == "Existing Product Price update" || sel == "New Pack size in an Existing Brand" ){
                        component.set("v.showSpinner",true);  
                        helper.getUpdateClaims(component, event, helper);
                        helper.getFormulation(component, event, helper,companyId,brnd);
                        
                    }
                    
                }
                component.find("company").set("v.disabled", false); 
            } 
            component.set("v.showSpinner",false);  
        });
        
        $A.enqueueAction(action7);	
    },
    
    onCmpnyChange:function(component,event,helper,cmpVal){
        console.log('onCmpnyChange called..'+cmpVal);
        var action8 = component.get("c.getBrandListOnCmpny");
        //var cmpnyObjs = component.get('v.selectedCmpny');
        var cmpny = component.find("company").get("v.value");
        var sel = component.find("Reporting_Type").get("v.value");
        action8.setParams({
            "cmpnyId":cmpVal
        });
        
        action8.setCallback(this,function(response){
            console.log(response.getState());
            if(response.getState() == 'SUCCESS'){
                console.log(response.getReturnValue());  
                component.set("v.brandObj",response.getReturnValue());
                if(sel != "Existing Company, New Brand"){
                    component.find("brand").set("v.disabled", false);
                }
            } 
            component.set("v.showSpinner",false);  
        }); 
        
        $A.enqueueAction(action8);	
    },
    
    getFormulation:function(component,event,helper,companyId,brnd){
        
        console.log('Company id in Formulation '+companyId);
        console.log('Brand id in Formulation '+brnd);
        console.log('getFormulation called..');
        var action9 = component.get("c.formulationDetails");
        var brnd = component.find("brand").get("v.value");
        var cmpny = component.find("company").get("v.value");
        
        
        action9.setParams({
            "brnd_id":brnd,
            "cmpny_id":companyId
        });
        
        action9.setCallback(this,function(response){
            console.log(response.getState());
            if(response.getState() == 'SUCCESS'){
                console.log(response.getReturnValue());
                var frmltn= response.getReturnValue(); 
                if(frmltn != null){  
                    component.set("v.selectedFormulation ",response.getReturnValue());
                    component.set("v.hiddenFrmltnId", frmltn.Id);
                    component.set('v.frmltnOpt', true); 
                }
            }else{
                alert($A.get("$Label.c.Formulation_not_available_Please_select_or_Add_new_one"));
                helper.getListOfFormulation(component, event, helper); 
                component.set('v.frmoptn', true); 
                
                //component.set("v.selectedFormulation ",'');
                
            } 
            component.set("v.showSpinner",false);  
        });
        
        $A.enqueueAction(action9);	
    },
    
    addNewBrand1:function(component,event,helper){
        console.log('addNewBrand called..');
        var action = component.get("c.newBrandEntry");
        var nm=component.find("brand_name").get("v.value");
        // var cod=component.find("brand_code").get("v.value");
        var cat=component.find("catgry").get("v.value");
        action.setParams({
            "brnd_nm":nm,     //"cod":cod,
            "cat":cat
        });
        action.setCallback(this,function(response){
            console.log(response.getState());
            if(response.getState() == 'SUCCESS'){
                console.log(response.getReturnValue()); 
                if(response.getReturnValue() == null){
                    alert($A.get("$Label.c.Brand_with_same_name_already_exist_Please_try_new_one"));
                }
                else{
                    component.set("v.selectedBrand",response.getReturnValue());
                    component.set('v.brndOpt', true);    
                    component.set('v.brandModal', false);
                    component.find("openBrnd").set("v.disabled", true);   
                }
            } 
            component.set("v.showSpinner",false);  
        });
        
        $A.enqueueAction(action);	
    },
    
    addNewBrandHelper:function(component,event,helper){
        console.log('addNewBrand called..');
        var action = component.get("c.newBrandEntry");
        var nm=component.find("brand_name").get("v.value");
        // var cod=component.find("brand_code").get("v.value");
        var cat=component.find("catgry").get("v.value");
        action.setParams({
            "brnd_nm":nm,     //"cod":cod,
            "cat":cat
        });
        action.setCallback(this,function(response){
            console.log(response.getState());
            if(response.getState() == 'SUCCESS'){
                console.log(response.getReturnValue()); 
                if(response.getReturnValue() == null){
                    alert($A.get("$Label.c.Brand_with_same_name_already_exist_Please_try_new_one"));
                }
                else{
                    component.set("v.selectedRecordBrand",response.getReturnValue());
                    var bdId = response.getReturnValue();
                    
                    component.set('v.hiddenBrndId',bdId.Id); 
                    
                    component.set('v.newbrndadd', true);    
                    component.set('v.brandModal', false);
                    component.find("openBrnd").set("v.disabled", true);
                    var pillTarget = component.find("lookup-pill-Brand");
                    var lookUpTarget = component.find("lookupFieldBrand"); 
                    
                    /*var bradPill = component.find("brandPill");
                    $A.util.removeClass(bradPill, 'slds-show');*/
                    
                    $A.util.addClass(pillTarget, 'slds-show');
                    $A.util.removeClass(pillTarget, 'slds-hide');
                    
                    $A.util.addClass(lookUpTarget, 'slds-hide');
                    $A.util.removeClass(lookUpTarget, 'slds-show');  
                    
                    
                    
                }
            } 
            component.set("v.showSpinner",false);  
        });
        
        $A.enqueueAction(action);	
    },
    
    
    
    
    
    
    
    
    
    addNewCmpny:function(component,event,helper){
        
        var action11 = component.get("c.newCmpnyEntry");
        var nm=component.find("cmpny_name").get("v.value");
        // var cod=component.find("cmpny_code").get("v.value");
        var site=component.find("cmpny_site").get("v.value");
        action11.setParams({
            "cmpny_nm":nm,    //"cod":cod,
            "site":site
        });
        
        action11.setCallback(this,function(response){
            console.log(response.getState());
            if(response.getState() == 'SUCCESS'){
                
                console.log(response.getReturnValue());
                if(response.getReturnValue() == null){
                    alert($A.get("$Label.c.Company_with_same_name_already_exist_Please_try_new_one"));
                }
                else{ 
                    
                    
                    component.set("v.selectedCmpny",response.getReturnValue());
                    component.set('v.cmpnyOpt', true);  
                    component.set('v.cmpnyModal', false);
                    component.find("openCmpny").set("v.disabled", true);   
                } 
            } 
            component.set("v.showSpinner",false);
        });
        
        $A.enqueueAction(action11);	
    },
    
    
    addNewCmpny1:function(component,event,helper){
        
        var action11 = component.get("c.newCmpnyEntry");
        var nm=component.find("cmpny_name").get("v.value");
        var site=component.find("cmpny_site").get("v.value");
        action11.setParams({
            "cmpny_nm":nm,    //"cod":cod,
            "site":site
        });
        action11.setCallback(this,function(response){
            console.log(response.getState());
            if(response.getState() == 'SUCCESS'){
                if(response.getReturnValue() == null){
                    alert($A.get("$Label.c.Company_with_same_name_already_exist_Please_try_new_one"));
                } else{
                    component.set('v.newcmpadd', true); 
                    component.set("v.selectedRecordCompany",response.getReturnValue());
                    var resState = response.getReturnValue();
                    
                    component.set('v.hiddenCmpnyId', resState.Id);
                    
                    
                    
                    component.set('v.cmpnyModal', false);
                    component.find("openCmpny").set("v.disabled", true); 
                    var pillTarget = component.find("lookup-pill-Company");
                    var lookUpTarget = component.find("lookupFieldCompany"); 
                    $A.util.addClass(pillTarget, 'slds-show');
                    $A.util.removeClass(pillTarget, 'slds-hide');
                    $A.util.addClass(lookUpTarget, 'slds-hide');
                    $A.util.removeClass(lookUpTarget, 'slds-show'); 
                }
            }
            component.set("v.showSpinner",false);
            
        });
        $A.enqueueAction(action11);	
        
    },
    
    
    
    
    
    
    
    addNewFrmltn:function(component,event,helper){
        
        var action12 = component.get("c.newFrmltnEntry");
        var nm = component.find("frmltn_name").get("v.value");
        //  var cod = component.find("frmltn_code").get("v.value");
        var brnd_id = component.get('v.hiddenBrndId');
        var cmpny_id = component.get('v.hiddenCmpnyId');  
        
        
        
        
        action12.setParams({
            "frml_nm":nm,             //"cod":cod,
            "brnd_id":brnd_id,
            "cmpny_id":cmpny_id
        });
        
        action12.setCallback(this,function(response){
            console.log(response.getState());
            if(response.getState() == 'SUCCESS'){
                console.log(response.getReturnValue());  
                var frmltn= response.getReturnValue();  
                
                component.set("v.selectedRecordFormulation",response.getReturnValue());
                
                
                component.set('v.formulationModal', false);
                component.set("v.hiddenFrmltnId", frmltn.id);
                component.find("openFrmltn").set("v.disabled", true); 
                component.set('v.frmltnOpt', true);
                component.set('v.frmoptn', true);
                component.set('v.newfrmadd', true);
                
                var pillTarget = component.find("lookup-pill-Formulation");
                var lookUpTarget = component.find("lookupFieldFormulation"); 
                
                $A.util.addClass(pillTarget, 'slds-show');
                $A.util.removeClass(pillTarget, 'slds-hide');
                
                $A.util.addClass(lookUpTarget, 'slds-hide');
                $A.util.removeClass(lookUpTarget, 'slds-show');
                
                
            } 
            component.set("v.showSpinner",false); 
            
        });
        
        $A.enqueueAction(action12);	
    },
    
    
    
    addNewPack:function(component,event,helper){
        console.log('addNewPack called..');
        var action12 = component.get("c.newPacktnEntry");
        var nm=component.find("pck_name").get("v.value");
        // var cod=component.find("pck_code").get("v.value"); 
        
        action12.setParams({
            "name":nm    //"cod":cod
        });
        
        action12.setCallback(this,function(response){
            console.log(response.getState());
            if(response.getState() == 'SUCCESS'){
                
                component.set('v.selectedRecordPackSize', response.getReturnValue());
                component.set('v.pckOpt', true);    
                component.set('v.packModal', false);
                //  component.set("v.showSpinner",false);
                var pillTarget = component.find("lookup-pill-PackSize");
                var lookUpTarget = component.find("lookupFieldPackSize"); 
                $A.util.addClass(pillTarget, 'slds-show');
                $A.util.removeClass(pillTarget, 'slds-hide');
                $A.util.addClass(lookUpTarget, 'slds-hide');
                $A.util.removeClass(lookUpTarget, 'slds-show');
                component.set('v.newpacksizeadd', true);
                
            } 
            component.set("v.showSpinner",false);
        });
        
        $A.enqueueAction(action12);	
    },
    
    
    
    
    createPriceEntry:function(component,event,c_pricObj,updatelabel,comPrice_id){
        console.log('createPriceEntry called..');
        
        
        //alert( 'JSON.stringify(c_pricObj) '+JSON.stringify(c_pricObj)); 
        var action = component.get("c.newCompetitorEntry");
        var rtrnId='';        
        action.setParams({
            "c_pricObjt":JSON.stringify(c_pricObj),
            "updateLabel":JSON.stringify(updatelabel),
            "comPriceId":comPrice_id
        });
        
        action.setCallback(this,function(response){
            console.log(response.getError());
            component.set("v.showSubmitSpinner",false);
            if(response.getState() == 'SUCCESS'){
                console.log(response.getReturnValue()); 
                rtrnId=response.getReturnValue();
                console.log('Return Id '+rtrnId);
                
                
                
                if(rtrnId!=''){
                    
                    window.location='/lightning/r/Competitor_Price__c/'+rtrnId+'/view'; 
                    
                    /* var urlEvent = $A.get("e.force:navigateToURL");
    					urlEvent.setParams({
    					  "url": "/"+rtrnId
                        });
        				urlEvent.fire();*/
                    //https://upl--brazildb--c.cs57.visual.force.com/
                    /* alert(location.protocol);
                    alert(location.hostname.split('.')[0]);
                    alert(location.hostname);*/
                    
                    //  window.location='/'+rtrnId;
                }
                // alert('Price and Scheme Details Added Successfully..'); 
                // component.set('v.selectedPack', response.getReturnValue());
                //component.find("brand").set("v.disabled", true); comment by vishal
                //component.find("company").set("v.disabled", true); comment by vishal
                // component.find("formulation").set("v.disabled", true); comment by vishal
                component.find("Reporting_Type").set("v.disabled", true);
            } 
        });
        console.log('retrnId');
        console.log(rtrnId);
        
        
        $A.enqueueAction(action);	
    },
    
    newPriceEntry:function(component, event, c_pricObj, schemeObj, comPrice_id){
        console.log('newPriceEntry called..');
        console.log(c_pricObj);
        console.log(schemeObj);
        console.log(comPrice_id);
        var action = component.get("c.saveCPEntry");
        var schmObjs = component.get('v.priceDetailsObj');  
        var repType = c_pricObj.Reporting_Type__c; // ------Patch added by Nikhil on 08/04/2019 for image..
        
        console.log(' @@@@@@@@ c price  '+JSON.stringify(c_pricObj));
        action.setParams({
            "c_pricObjt":JSON.stringify(c_pricObj),
            "schemeObjt":JSON.stringify(schemeObj),
            "comPriceId":comPrice_id
        });
        
        
        action.setCallback(this,function(response){
            console.log('Error response '+response.getError());
            if(response.getState() == 'SUCCESS'){
                console.log('RESPONSE '+response.getReturnValue()); 
                console.log('Pack size null is '+response.getReturnValue().Pack_Size__c);
                
                schmObjs.push({
                    
                    pck_size:response.getReturnValue().Pack_Size__c,
                    mrp:response.getReturnValue().MRP__c,
                    frm_price:response.getReturnValue().Farmer_Price__c,
                    ret_price:response.getReturnValue().Retailer_Price__c,
                    dis_price:response.getReturnValue().Distributor_Price__c,
                    schm:response.getReturnValue().Scheme__c,
                    cmnt:response.getReturnValue().Comment__c,
                    pck_nm:response.getReturnValue().Pack_Size__r.Name,
                    pck_id:response.getReturnValue().Id 
                });
                //  window.setTimeout(
                //   $A.getCallback(function() {
                if(schmObjs.length>0){
                    component.set("v.showSubmitBtn",true);
                }
                //  }), 5000);               
                
                var schmChildCmp = component.find("schemePic_id");
                if(schmObjs.length == 1){
                    //schmChildCmp.SaveAttachments(response.getReturnValue().Id,true,"scheme"); // commented by Nikhil on 08/04/2019....
                    window.setTimeout( $A.getCallback(function() {
                        schmChildCmp.SaveAttachments(response.getReturnValue().Id,true,"scheme",repType); // added by Nikhil on 08/04/2019....
                    }),2000);    
                } 
                
                var pckChildCmp = component.find("packshotPic_id");
                // pckChildCmp.SaveAttachments(response.getReturnValue().Id,false,"packshot");  // commented by Nikhil on 08/04/2019....
                window.setTimeout($A.getCallback(function() {
                    pckChildCmp.SaveAttachments(response.getReturnValue().Id,false,"packshot",repType);  // added by Nikhil on 08/04/2019....
                }),2000);   
                var labelChildCmp = component.find("labelPic_id");
                if(schmObjs.length == 1){
                    //labelChildCmp.SaveAttachments(response.getReturnValue().Id,true,"label");  // commented by Nikhil on 08/04/2019....
                    window.setTimeout( $A.getCallback(function() {
                        labelChildCmp.SaveAttachments(response.getReturnValue().Id,true,"label",repType);  // added by Nikhil on 08/04/2019....
                    }),2000);
                }
                //schmChildCmp.set("v.parentId",response.getReturnValue().Id);
                var zero = 0;
                component.set("v.packfilesize",0);
                console.log('pack Size from helper '+component.get("v.packfilesize"));
                // component.find("brand").set("v.disabled", true); 
                //component.find("company").set("v.disabled", true);
                //component.find("formulation").set("v.disabled", true);
                component.find("Reporting_Type").set("v.disabled", true); 
                component.set('v.priceDetailsObj', schmObjs);
                component.set('v.competitorPriceId', response.getReturnValue().Competitor_Price__c);
                component.set("v.selectedRecordPackSize", null);
                //component.set("v.showSpinner",false);
            } 
            //component.set("v.showSubmitSpinner",false);   // commented by Nik. delay is added to Multiple file upload helper on 02/05/2019...
            //component.set("v.showSpinner",false);
        });
        
        $A.enqueueAction(action);	
    },
    
    removeSchmPriceEntry:function(component,event,helper, scm_id, indx){
        console.log('removeSchmPriceEntry called..');
        var action12 = component.get("c.deletePriceEntry");
        var schmObjs = component.get("v.priceDetailsObj"); 
        
        action12.setParams({
            "price_id":scm_id
        });
        
        action12.setCallback(this,function(response){
            console.log(response.getState());
            if(response.getState() == 'SUCCESS'){
                console.log(response.getReturnValue()); 
                if(response.getReturnValue() == true){
                    schmObjs.splice(indx, 1);
                    component.set("v.priceDetailsObj",schmObjs);
                    
                }
            }
            if(schmObjs.length>0){
                component.set("v.showSubmitBtn",true);
            }
            else{
                component.set("v.showSubmitBtn",false);
            }
            component.set("v.showSpinner",false);
        });
        
        $A.enqueueAction(action12);	
    },
    
    cancelEntry:function(component,event,helper){
        console.log('cancelEntry called...');
        
        var comPrice_id = component.get('v.competitorPriceId');
        var action11 = component.get("c.cancelPriceEntry");
        console.log(comPrice_id);
        action11.setParams({
            "compPriceId":comPrice_id
        });
        
        action11.setCallback(this,function(response){
            console.log(response.getState());
            if(response.getState() == 'SUCCESS'){
                console.log(response.getReturnValue());  
                
            } 
            component.set("v.showSpinner",false);
            window.location='/lightning/o/Competitor_Price__c/list?filterName=Recent';
        });
        
        $A.enqueueAction(action11);	
    },
    
    
    getUpdateClaims:function(component,event,helper){
        console.log('getUpdateClaims called..');
        var action12 = component.get("c.updateClaimList");
        var schmObjs = component.get("v.priceDetailsObj"); 
        var brndObjs = component.get('v.selectedBrand');
        action12.setParams({
            "brandId":brndObjs.Id
        });
        
        action12.setCallback(this,function(response){
            console.log(response.getState());
            if(response.getState() == 'SUCCESS'){
                console.log(response.getReturnValue()); 
                component.set("v.updateClaimObjUpdated",response.getReturnValue());
            } 
            component.set("v.showSpinner",false);
        });
        
        $A.enqueueAction(action12);	
    },
    
    getListOfFormulation:function(component,event,helper){
        console.log('getListOfFormulation called..');
        var action12 = component.get("c.getformulationList");
        
        action12.setCallback(this,function(response){
            console.log(response.getState());
            if(response.getState() == 'SUCCESS'){
                console.log(response.getReturnValue()); 
                if(response.getReturnValue() != null){ 
                    console.log('response.getReturnValue() '+response.getReturnValue());
                    component.set("v.frmlnObj",response.getReturnValue());
                }
            } 
            component.set("v.showSpinner",false);
        });
        
        $A.enqueueAction(action12);	
    },
    
    //added by vishal 
    searchHelperBrand : function(component,event,getInputkeyWordBrand){
        
        console.log('getInputkeyWordBrand  '+getInputkeyWordBrand);
        var action = component.get("c.fetchBrandList");
        
        action.setParams({
            'searchKeyWordBrand': getInputkeyWordBrand
        });
        
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinnerBrand"), "slds-show");
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
                
                if (storeResponse.length == 0) {
                    component.set("v.MessageBrand", 'No Result Found...');
                } else {
                    component.set("v.MessageBrand", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecordsBrand", storeResponse);
                
                
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    },
    
    searchHelperCompany :function(component,event,getInputkeyWordCompany){
        
        var action = component.get("c.fetchCompanyList");
        
        action.setParams({
            'searchKeyWordCompany': getInputkeyWordCompany
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinnerCompany"), "slds-show");
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
                
                if (storeResponse.length == 0) {
                    component.set("v.MessageCompany", 'No Result Found...');
                } else {
                    component.set("v.MessageCompany", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecordsCompany", storeResponse);
                
                
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
        
        
    } ,
    
    
    searchHelperOnBrandKeyPress:function(component,event,getInputkeyWordBrand){
        var action = component.get("c.searchHelperOnBrandKeyPres");
        
        action.setParams({
            'searchKeyWordBrand': getInputkeyWordBrand
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinnerBrand"), "slds-show");
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
                
                if (storeResponse.length == 0) {
                    component.set("v.MessageBrand", 'No Result Found...');
                } else {
                    component.set("v.MessageBrand", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecordsBrand", storeResponse);
                
                
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
        
        
    },
    
    
    
    searchHelperOnCompanyKeyPress:function(component,event,getInputkeyWordCompany){
        var action = component.get("c.searchHelperOnCompanyKeyPres");
        
        action.setParams({
            'searchKeyWordCompany': getInputkeyWordCompany
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinnerCompany"), "slds-show");
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
                
                if (storeResponse.length == 0) {
                    component.set("v.MessageCompany", 'No Result Found...');
                } else {
                    component.set("v.MessageCompany", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecordsCompany", storeResponse);
                
                
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    },
    
    
    
    
    getCompanyOnBrand :function(component,event,brdID){
        console.log('getting compnay list on brand '+brdID);
        var action = component.get("c.getCmpnyListOnBrnd");
        action.setParams({
            "brndId":brdID
        });
        
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var storeResponse = response.getReturnValue();
                var forclose = component.find("lookup-pill-Company");
                $A.util.addClass(forclose, 'slds-show');
                $A.util.removeClass(forclose, 'slds-hide');
                
                var forclose = component.find("searchResCompany");
                $A.util.addClass(forclose, 'slds-is-close');
                $A.util.removeClass(forclose, 'slds-is-open');
                
                var lookUpTarget = component.find("lookupFieldCompany");
                $A.util.addClass(lookUpTarget, 'slds-hide');
                $A.util.removeClass(lookUpTarget, 'slds-show');
                component.set("v.selectedRecordCompany", storeResponse);
                component.set("v.newcmpadd", false);
                
            }
            
        });
        
        $A.enqueueAction(action);
    },
    
    
    //added by vishal
    getFormulationOnBrand :function(component,event,brdID,cmpID){
        
        var action = component.get("c.formulationDetails");
        action.setParams({
            "brnd_id":brdID,
            "cmpny_id":cmpID
        });
        
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var storeResponse = response.getReturnValue();
                var forclose = component.find("lookup-pill-Formulation");
                $A.util.addClass(forclose, 'slds-show');
                $A.util.removeClass(forclose, 'slds-hide');
                
                var forclose = component.find("searchResFormulation");
                $A.util.addClass(forclose, 'slds-is-close');
                $A.util.removeClass(forclose, 'slds-is-open');
                
                var lookUpTarget = component.find("lookupFieldFormulation");
                $A.util.addClass(lookUpTarget, 'slds-hide');
                $A.util.removeClass(lookUpTarget, 'slds-show');
                component.set("v.selectedRecordFormulation", storeResponse); 
            }else{
                alert($A.get("$Label.c.Formulation_not_available_Please_select_or_Add_new_one"));
                component.set('v.frmoptn', false);
                
            }
            
        });
        
        $A.enqueueAction(action);
    },
    
    
    
    
    
    
    searchHelperFormulation :function(component,event,getInputkeyWordFormulation){
        
        var action = component.get("c.fetchFormulationList");
        
        action.setParams({
            'searchKeyWordFormulation': getInputkeyWordFormulation
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinnerFormulation"), "slds-show");
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
                console.log('@@@ storeResponse '+storeResponse);
                
                if(storeResponse!=null){
                    if (storeResponse.length == 0) {
                        component.set("v.MessageFormulation", 'No Result Found...');
                    } else {
                        component.set("v.MessageFormulation", '');
                    }  
                }
                
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecordsFormulation", storeResponse);
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    } ,
    
    searchHelperOnFormulationKeyPress:function(component,event,getInputkeyWordFormulation){
        var action = component.get("c.searchHelperOnFormulationKeyPres");
        
        action.setParams({
            'searchKeyWordFormulation': getInputkeyWordFormulation
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinnerFormulation"), "slds-show");
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                
                
                if (storeResponse.length == 0) {
                    component.set("v.MessageFormulation", 'No Result Found...');
                } else {
                    component.set("v.MessageFormulation", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecordsFormulation", storeResponse);
                
                
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    },
    
    searchHelperPackSize :function(component,event,getInputkeyWordPackSize){
        
        var action = component.get("c.getPackList");
        
        action.setParams({
            'searchKeyWordPackSize': getInputkeyWordPackSize
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinnerPackSize"), "slds-show");
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
                
                if (storeResponse.length == 0) {
                    component.set("v.MessagePackSize", 'No Result Found...');
                } else {
                    component.set("v.MessagePackSize", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecordsPackSize", storeResponse);
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    } ,
    
    
    searchHelperOnPackSizeKeyPress:function(component,event,getInputkeyWordPackSize){
        var action = component.get("c.getPackList");
        
        action.setParams({
            'searchKeyWordPackSize': getInputkeyWordPackSize
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinnerPackSize"), "slds-show");
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
                
                if (storeResponse.length == 0) {
                    component.set("v.MessagePackSize", 'No Result Found...');
                } else {
                    component.set("v.MessagePackSize", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecordsPackSize", storeResponse);
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    },  
    
    
    
    searchHelperCrop :function(component,event,getInputkeyWordCrop){
        
        var action = component.get("c.cropList");
        //alert('action onfocus in helper');
        action.setParams({
            'searchKeyWordCrop': getInputkeyWordCrop
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinnerCrop"), "slds-show");
            var state = response.getState();
            
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
                
                if (storeResponse.length == 0) {
                    component.set("v.MessageCrop", 'No Result Found...');
                } else {
                    component.set("v.MessageCrop", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecordsCrop", storeResponse);
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    } ,
    
    searchHelperOnCropKeyPress:function(component,event,getInputkeyWordCrop){
        
        var action = component.get("c.cropList");
        
        action.setParams({
            'searchKeyWordCrop': getInputkeyWordCrop
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinnerCrop"), "slds-show");
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
                
                if (storeResponse.length == 0) {
                    component.set("v.MessageCrop", 'No Result Found...');
                } else {
                    component.set("v.MessageCrop", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecordsCrop", storeResponse);
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    },
    
    searchHelperPest :function(component,event,getInputkeyWordPest){
        
        var action = component.get("c.pestList");
        //alert('action onfocus in helper');
        action.setParams({
            'searchKeyWordPest': getInputkeyWordPest
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinnerPest"), "slds-show");
            var state = response.getState();
            
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
                
                if (storeResponse.length == 0) {
                    component.set("v.MessagePest", 'No Result Found...');
                } else {
                    component.set("v.MessagePest", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecordsPest", storeResponse);
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    } ,
    
    searchHelperOnPestKeyPress:function(component,event,getInputkeyWordPest){
        
        var action = component.get("c.pestList");
        
        action.setParams({
            'searchKeyWordPest': getInputkeyWordPest
        });
        
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinnerPest"), "slds-show");
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
                
                if (storeResponse.length == 0) {
                    component.set("v.MessagePest", 'No Result Found...');
                } else {
                    component.set("v.MessagePest", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecordsPest", storeResponse);
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    },
    
    clearAll:function(component,event){
        
        //for Brand
        component.set("v.listOfSearchRecordsBrand", null );
        component.set("v.selectedRecordBrand", null );
        var pillTarget = component.find("lookup-pill-Brand");
        var lookUpTarget = component.find("lookupFieldBrand"); 
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide'); 
        
        //for Company
        component.set("v.listOfSearchRecordsCompany", null );
        component.set("v.selectedRecordCompany", null );
        var pillTarget1 = component.find("lookup-pill-Company");
        var lookUpTarget1 = component.find("lookupFieldCompany"); 
        $A.util.addClass(pillTarget1, 'slds-hide');
        $A.util.removeClass(pillTarget1, 'slds-show');
        $A.util.addClass(lookUpTarget1, 'slds-show');
        $A.util.removeClass(lookUpTarget1, 'slds-hide');
        
        
        // for Formualtion
        component.set("v.listOfSearchRecordsFormulation", null );
        component.set("v.selectedRecordFormulation", null );
        var pillTarget2 = component.find("lookup-pill-Formulation");
        var lookUpTarget2 = component.find("lookupFieldFormulation"); 
        
        $A.util.addClass(pillTarget2, 'slds-hide');
        $A.util.removeClass(pillTarget2, 'slds-show');
        
        $A.util.addClass(lookUpTarget2, 'slds-show');
        $A.util.removeClass(lookUpTarget2, 'slds-hide');
        
        
        
        //for PackSize
        component.set("v.listOfSearchRecordsPackSize", null );
        component.set("v.selectedRecordPackSize", null );
        var pillTarget3 = component.find("lookup-pill-PackSize");
        var lookUpTarget3 = component.find("lookupFieldPackSize"); 
        
        $A.util.addClass(pillTarget3, 'slds-hide');
        $A.util.removeClass(pillTarget3, 'slds-show');
        
        $A.util.addClass(lookUpTarget3, 'slds-show');
        $A.util.removeClass(lookUpTarget3, 'slds-hide');
        
        
        //for Crop
        component.set("v.listOfSearchRecordsCrop", null );
        component.set("v.selectedRecordCrop", null );
        var pillTarget4 = component.find("lookup-pill-Crop");
        var lookUpTarget4 = component.find("lookupFieldCrop"); 
        
        $A.util.addClass(pillTarget4, 'slds-hide');
        $A.util.removeClass(pillTarget4, 'slds-show');
        
        $A.util.addClass(lookUpTarget4, 'slds-show');
        $A.util.removeClass(lookUpTarget4, 'slds-hide');
        
        
        //for Pest
        component.set("v.listOfSearchRecordsPest", null );
        component.set("v.selectedRecordPest", null );
        var pillTarget5 = component.find("lookup-pill-Pest");
        var lookUpTarget5 = component.find("lookupFieldPest"); 
        
        $A.util.addClass(pillTarget5, 'slds-hide');
        $A.util.removeClass(pillTarget5, 'slds-show');
        
        $A.util.addClass(lookUpTarget5, 'slds-show');
        $A.util.removeClass(lookUpTarget5, 'slds-hide');
        
        
        component.find("vBrand").set("v.value", '');
        component.find("vCompany").set("v.value", '');
        component.find("vFormulation").set("v.value", '');
        
        var sel = component.find("Reporting_Type").get("v.value");
        if(sel=='New Company, New Brand' || sel=='Existing Company, New Brand' || sel=='New Pack size in an Existing Brand' || sel=='Existing Product Price update'){
            component.find("vPackSize").set("v.value", '');
        }
        
        
        //alert('sel '+sel);
        if(sel == 'New Company, New Brand' || sel =='Existing Company, New Brand'){
            component.find("vCrop").set("v.value", '');
            component.find("vPest").set("v.value", '');
        }
        
        if(sel=='New Company, New Brand' || sel=='Existing Company, New Brand' || sel=='New Pack size in an Existing Brand' || sel=='Existing Product Price update'){
            component.find("MRP").set("v.value", '');
            component.find("farmer_price").set("v.value", '');
            component.find("retailer_price").set("v.value", '');
            component.find("distributor_price").set("v.value", '');
            component.find("schemes").set("v.value", '');
            component.find("comments").set("v.value", '');
        }
        
        if(sel=='New Company, New Brand' || sel=='Existing Company, New Brand' || sel=='Update in Label Claim'){ //if block added by Nik on 30/04/2019 as error was occuring on type change..
            component.find("dose").set("v.value", '');
            component.find("uom").set("v.value", '');
            component.find("per_acre_cost").set("v.value", ''); 
        }
        
        component.find("openBrnd").set("v.disabled", false);
        component.find("openCmpny").set("v.disabled", false);
        component.find("openFrmltn").set("v.disabled", false);
        
        if(sel != 'Update in Label Claim'){           // added by Nikhil to reset images selection on Reporting type chnage on 02/05/2019....
            var schmChildCmp = component.find("schemePic_id");
            var pckChildCmp = component.find("packshotPic_id");
            var labelChildCmp = component.find("labelPic_id");
            
            // schmChildCmp.ResetImages(component,event); 
            // pckChildCmp.ResetImages(component,event); 
            // labelChildCmp.ResetImages(component,event); 
        }
    },
    
    //added by vishal pawar for Spain Portugal Patch
    gettingLoginUserId : function(component,event,helper){
        console.log('In helper Method for Loging User Country ');
        
        var action = component.get('c.gettingLoginUserIds'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                component.set('v.countryName', a.getReturnValue());
                var countryNm = a.getReturnValue();
                if(countryNm =='Spain' || countryNm =='Portugal' || countryNm =='Naturagri Spain'){
                    component.set('v.requiredTrueFalse', false);
                }else{
                    component.set('v.requiredTrueFalse', true);
                }
                
            }
        });
        $A.enqueueAction(action);
        
    },
    
    
})