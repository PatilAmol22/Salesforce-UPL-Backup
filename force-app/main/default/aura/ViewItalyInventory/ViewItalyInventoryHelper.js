({
	textKeyChange: function(component, termtext) {         
        console.log('term value :-----'+termtext)
        //var searchKey =  component.find("input1").get("v.value"); 
        var searchKey = termtext;
        //searchKey = searchKey.toUpperCase();
 		var recordToDisply = component.find("recordSize").get("v.value"); 
        var searchField = component.get("v.selectBy");
        component.set("v.page",1);
        var page = component.get("v.page"); 
			//alert(searchKey);
		      
       if($A.util.isUndefined(searchKey) || searchKey ==''){
         	//alert(searchKey);
             this.fetchRequirements(component,page,recordToDisply);   
         }
        else{
             
             console.log('Ontextkeychange searchKey>>--->'+searchKey);
             
             if(searchField == 'Product/Sku') {                 
                 this.searchRequirements(component,searchField,searchKey,page,recordToDisply);
             }
            else if(searchField == 'Storage Location') {
                 console.log('searchField check 2:--- '+searchField);                 
                     this.searchRequirements(component,searchField,searchKey,page,recordToDisply);                 
             }
            
        }
        
    },
    
    
    fetchRequirements : function(component,page, recordToDisply){
         var action = component.get('c.getInventories');        
         action.setParams({
            pageNumber: page,
            recordToDisply: recordToDisply   
        });
        action.setCallback(this, function(response){
            //store state of response
            var returnValue = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS"){
                component.set('v.Wrapperlist',returnValue.listWrapStkReqInv);
                component.set('v.isAdmin',returnValue.isAdmin);
                component.set('v.isAreaMgr',returnValue.isAreaMgr);
                component.set("v.page", returnValue.page);  
                component.set("v.total", parseInt(returnValue.total));  
                component.set("v.pages", Math.ceil(returnValue.total / recordToDisply)); 
               console.log('pages>>--->'+component.get("v.pages"));
               console.log('total>>--->'+component.get("v.total"));
               console.log('page>>--->'+component.get("v.page"));
               console.log(component.get("v.Wrapperlist"));
            }
        });
        $A.enqueueAction(action); 	
	},
   
    searchRequirements : function(component,searchField,searchKey,page,recordToDisply){
      	var recordToDisply1 = recordToDisply;
       
        var action = component.get("c.getBySKUAndSLocation"); 
         
        action.setParams({ 
            "fieldName":  searchField,
            "value": searchKey,
            "pageNumber": page,
            "recordToDisply": recordToDisply  
        });  
         action.setCallback(this, function(response){
             
         var returnValue = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS"){
                component.set('v.Wrapperlist',returnValue.listWrapStkReqInv);
                component.set("v.page", returnValue.page);  
                component.set("v.total", parseInt(returnValue.total));  
               // console.log('pages>>--->'+returnValue.total);
               // console.log('record to display>>--->'+recordToDisply1);
                component.set("v.pages", Math.ceil(returnValue.total / recordToDisply1)); 
             
                if(returnValue.listWrapStkReqInv.length==0){
                    this.errormsg(component);
                    var page = component.get("v.page") || 1; 
        			var recordToDisply = component.find("recordSize").get("v.value"); 
       				this.fetchRequirements(component,page,recordToDisply);
                    component.set("v.selItem","");
        		} 
              
            }
        });
        $A.enqueueAction(action);       
    
	},
   
   
    errormsg:function(component,event){
         var staticLabel = $A.get("$Label.c.No_Such_Data_Present_in_system");
       // alert(staticLabel);
       //  console.log('ewtewwe');
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: 'dismissible',
            duration:'5',
            message: staticLabel,
            key: 'info_alt',
            type : 'info'
        });
        toastEvent.fire();
    }
})