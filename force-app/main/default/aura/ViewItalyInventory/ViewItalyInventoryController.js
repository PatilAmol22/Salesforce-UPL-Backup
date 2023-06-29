({
    scriptsLoaded : function(component, event, helper) {
        //console.log('Script loaded..'); 
         $(".collapseimg").hide();
         //alert('before reload');
         $(document).ready();
        //alert('after reload');
    },
    
    doInit : function(component,event,helper){
    

        var page = component.get("v.page") || 1;
        var recordToDisply = component.find("recordSize").get("v.value"); 
        var searchKey =  event.getParam("term");
        
        var searchField = component.get("v.selectBy");
        component.set("v.showStorageLocation", false);
    
         if($A.util.isUndefined(searchKey) || searchKey ==''){
         
             helper.fetchRequirements(component,page, recordToDisply);   
         }else{
             helper.searchRequirements(component,searchField,searchKey,page,recordToDisply);
        }
      //  helper.fetchAutoCompleteData(component);
    },
    
    handleItemChange : function(component, event, helper) {
        var selItem = component.get("v.selItem");
        console.log('selItem (searched): '+selItem);
        
       // if (selItem.length >= 3) { 
           // console.log('selItem (searched 2): '+selItem);
            helper.textKeyChange(component, selItem);
       // }
    },
    
    //Called by event handler when search key changes
    searched : function(component, event, helper){
        console.log('event :----- '+event.getParam("term"));
        
        var termtext = event.getParam("term");
        
        helper.textKeyChange(component,termtext);
    },    
    
     onpagesizechange : function(component,event,helper){
    

        var page =  1;
        var recordToDisply = component.find("recordSize").get("v.value"); 
        var searchKey = component.get("v.selItem");// event.getParam("term");
        
        var searchField = component.get("v.selectBy");
    
         if($A.util.isUndefined(searchKey) || searchKey ==''){
         
             helper.fetchRequirements(component,page, recordToDisply);   
         }else{
             helper.searchRequirements(component,searchField,searchKey,page,recordToDisply);
        }
          component.set("v.page",1);
      //  helper.fetchAutoCompleteData(component);
    },
    
    toggleExpandAll : function(component, event, helper){
        $(".expand").hide();
        $(".collapse").show();
        $(".collapseimg").show();
        $(".expandimg").hide();
        $(".table").show();
        $(".errtd").show(); 
        
    },
    onRadioSelect :function(component, event, helper){
        var opts = document.querySelector('input[name="options"]:checked').value;
        console.log(opts);
        var opts = document.querySelector('input[name="options"]:checked').value;
       /* console.log("On radio select");
		component.set("v.selectBy", opts);	    
        */
        var page = component.get("v.page") || 1;
        var recordToDisply = component.find("recordSize").get("v.value"); 
       
        
        if(opts == 'Product/Sku'){
            console.log('opts 1 :-- '+opts);
            component.set("v.showProduct", true);
            component.set("v.showStorageLocation", false);
        }else if(opts=='Storage Location') {
            console.log('opts 2 :-- '+opts);
            component.set("v.showProduct", false);
            component.set("v.showStorageLocation", true);
        }
        component.set("v.selectBy", opts);
        helper.fetchRequirements(component,page, recordToDisply);
    },
    toggleCollapseAll : function(component, event, helper){
         $(".expandimg").show();
        $(".expand").show();
        $(".collapse").hide();
         $(".collapseimg").hide();
         $(".errtd").hide();
        $(".table").hide();
        // $(".errtd").hide();
        
    },
     toggleExpand : function(component, event, helper) {
      var index = event.currentTarget.dataset.rowIndex; 
      //alert('Expand>>--->'+index);
      $(".expand").hide();
      $(".collapse").show();   
      $("#"+index+"imgexp").hide();
      $("#"+index+"imgcolsp").show(); 
      $("#"+index+"table").show(); 
       // $("#"+index+"tr").show(); 
         $("#"+index+"errtd").show();
      var toggleText = component.find("text");
      $A.util.toggleClass(toggleText, "toggle");
    },
    toggleCollapse : function(component, event, helper) {
      var index = event.currentTarget.dataset.rowIndex;
        $(".collapse").hide();
        $(".expand").show();   
        //alert('collapse>>--->'+index);
        $("#"+index+"imgexp").show();
        $("#"+index+"imgcolsp").hide(); 
        $("#"+index+"table").hide(); 
        // $("#"+index+"tr").hide();
        $("#"+index+"errtd").hide();
        
      var toggleText = component.find("text");
      $A.util.toggleClass(toggleText, "toggle");
    },
    searchKeyChange: function(component, event,helper) {         
		
        var searchKey =  component.get("v.selItem");
        //searchKey = searchKey.toUpperCase();
 		var recordToDisply = component.find("recordSize").get("v.value"); 
        var searchField = component.get("v.selectBy");
       component.set("v.page",1);
        var page = component.get("v.page"); 
        console.log("page 1--> "+page);
			//alert(searchKey);       
       if($A.util.isUndefined(searchKey) || searchKey ==''){
         	//alert(searchKey);
             helper.fetchRequirements(component,page,recordToDisply);   
         }else{
             helper.searchRequirements(component,searchField,searchKey,page,recordToDisply);
        }
        
    },
   previous: function(component, event, helper) {  
       var searchKey =  component.get("v.selItem");
      // searchKey = searchKey.toUpperCase();
        var searchField = component.get("v.selectBy");
       var recordToDisply = component.find("recordSize").get("v.value"); 
        component.set("v.page", component.get("v.page") - 1);  
        var page = component.get("v.page") ;
       //console.log("page--> "+page);
     
     if($A.util.isUndefined(searchKey) || searchKey ==''){
         	
             helper.fetchRequirements(component,page, recordToDisply);   
        }else{
       
             helper.searchRequirements(component,searchField,searchKey,page,recordToDisply);
        }
                
    },
    First : function(component, event, helper) { 
        var searchKey =  component.get("v.selItem");
        //searchKey = searchKey.toUpperCase();
        var searchField = component.get("v.selectBy");
        component.set("v.page",1);  
        var recordToDisply = component.find("recordSize").get("v.value");  
      
         var page = component.get("v.page") ;
        //console.log("page--> "+page);
        if($A.util.isUndefined(searchKey) || searchKey ==''){
            
             helper.fetchRequirements(component,page, recordToDisply);   
        }else{
          
             helper.searchRequirements(component,searchField,searchKey,page,recordToDisply);
        }
    },  
    Last : function(component, event, helper) { 
        var searchKey =  component.get("v.selItem");
       // searchKey = searchKey.toUpperCase();
        var searchField = component.get("v.selectBy");
        component.set("v.page",component.get("v.pages"));  
        var recordToDisply = component.find("recordSize").get("v.value");  
      
        var page = component.get("v.page") ;
        //console.log("page--> "+page);
      
        if($A.util.isUndefined(searchKey) || searchKey ==''){
         
             helper.fetchRequirements(component,page, recordToDisply);   
        }else{
        
             helper.searchRequirements(component,searchField,searchKey,page,recordToDisply);
        }
    },  
    next:function(component, event, helper) {  
        var searchKey =  component.get("v.selItem");
       // searchKey = searchKey.toUpperCase();
        var searchField = component.get("v.selectBy");
        var recordToDisply = component.find("recordSize").get("v.value");
        component.set("v.page", component.get("v.page") + 1); 
        var page = component.get("v.page") ;
        console.log("page--> "+page);
        console.log("searchField--> "+searchField);
        console.log("searchKey--> "+searchKey);
        console.log("recordToDisply--> "+recordToDisply);
        if($A.util.isUndefined(searchKey) || searchKey ==''){
          
             helper.fetchRequirements(component,page, recordToDisply);   
        }else{
           // console.log("searchKey inside else--> "+searchKey);
           // console.log("recordToDisply inside else--> "+recordToDisply);
             helper.searchRequirements(component,helper,searchField,searchKey,page,recordToDisply);
        }
    }
    
})