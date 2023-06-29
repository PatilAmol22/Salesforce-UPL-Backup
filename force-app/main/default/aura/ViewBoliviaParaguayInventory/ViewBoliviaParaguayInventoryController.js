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
        //var searchKey =  component.find("input1").get("v.value");
        var searchKey = event.getParam("term");
        var searchFeild = component.get("v.selectBy");
        component.set("v.showStorageLocation", false);
        component.set("v.showSKUCode", false);
        window.setTimeout($A.getCallback(function() {helper.fetchDepot(component);}),2000 );
    	var searchDepot = component.get("v.Selected_Depots");
         if($A.util.isUndefined(searchKey) || searchKey ==''){
         
             helper.fetchRequirements(component,page, recordToDisply, searchDepot);   
         }else{
             helper.searchRequirements(component,helper,searchFeild,searchKey,page,recordToDisply, searchDepot);
        }
      //  helper.fetchAutoCompleteData(component);
    },
    //To search again  when selected depot is changed in mmulti select picklist
    onDepotChange: function (component, event, helper) {
        var searchKey = component.get("v.selItem"); //event.getParam("term");

        //var searchDepot = component.find("depot_items").get("v.value");
        var searchDepot = component.get("v.Selected_Depots");
        // var opts = component.find("select_id").get("v.value");

        var opts = document.querySelector('input[name="options"]:checked').value;
        var recordToDisply = component.find("recordSize").get("v.value");
        var searchField = "DepotName";
        component.set("v.page", 1);
        var page = component.get("v.page");
		console.log('searchDepot :'+searchDepot);
        if (searchDepot != null || searchDepot != '') {
            if (!$A.util.isUndefined(searchKey)) {
                helper.fetchRequirements(component, page, recordToDisply, searchDepot);
            } else {
                searchKey = '';
                helper.searchRequirements(component, searchField, searchKey, page, recordToDisply, searchDepot);
            }
        }

    },
    handleItemChange: function (component, event, helper) {
        console.log(" component ---> "+component);
        var selItem = component.get("v.selItem");
        
        console.log(" selItem ---> "+selItem);
        
        if (selItem.length >= 2) {
            console.log('Inside If');
            helper.textKeyChange(component, selItem);
        } else {
            console.log('Inside ELse');
            helper.textKeyChange(component, '');
        }
    },

    //Called by event handler when search key changes
    searched: function (component, event, helper) {
        var termtext = event.getParam("term");
        helper.textKeyChange(component, termtext);
    },
     onpagesizechange : function(component,event,helper){
    

        var page =  1;
        var recordToDisply = component.find("recordSize").get("v.value"); 
        //var searchKey =  component.find("input1").get("v.value");
        var searchKey = component.get("v.selItem");
        var searchFeild = component.get("v.selectBy");
    	var searchDepot = component.get("v.Selected_Depots");
         
         if($A.util.isUndefined(searchKey) || searchKey ==''){
         
             helper.fetchRequirements(component,page, recordToDisply, searchDepot);   
         }else{
             helper.searchRequirements(component,searchFeild,searchKey,page,recordToDisply, searchDepot);
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
        var page = component.get("v.page") || 1;
        var recordToDisply = component.find("recordSize").get("v.value");
        var searchDepot = component.get("v.Selected_Depots");
		
        console.log('opts----->'+opts);

        if (opts == 'Product/Sku') {
            component.set("v.showProduct", true);
            component.set("v.showSKUCode", false);
            component.set("v.showStorageLocation", false);
            component.set("v.showbrandName", false);
        } else if (opts == 'Storage Location') {
            component.set("v.showProduct", false);
            component.set("v.showSKUCode", false);
            component.set("v.showStorageLocation", true);
            component.set("v.showbrandName", false);
        } else if(opts == 'Brand Name') {
            component.set("v.showProduct", false);
            component.set("v.showSKUCode", false);
            component.set("v.showStorageLocation", false);
            component.set("v.showbrandName", true);
        } else {
            component.set("v.showProduct", false);
            component.set("v.showSKUCode", true);
            component.set("v.showStorageLocation", false);
            component.set("v.showbrandName", false);
        }
		component.set("v.selectBy", opts);	
        helper.fetchRequirements(component, page, recordToDisply, searchDepot);
    },
    onChageSAPCheckBox : function (component, event, helper) {

        if(component.get('v.SAPCheboxBoolean') == true){
            console.log('SAPchkBox==>',component.get('v.SAPCheboxBoolean'));
            component.set('v.SAPCheboxBoolean', false);
        }else{
            console.log('SAPchkBox==>',component.get('v.SAPCheboxBoolean'));
            component.set('v.SAPCheboxBoolean', true);
        }
        var page = component.get("v.page") || 1;
        var recordToDisply = component.find("recordSize").get("v.value");
        var searchDepot = component.get("v.Selected_Depots");
        helper.fetchRequirements(component, page, recordToDisply, searchDepot);
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
		
        var searchKey =  component.find("input1").get("v.value"); 
        //searchKey = searchKey.toUpperCase();
        var searchDepot = component.get("v.Selected_Depots");
 		var recordToDisply = component.find("recordSize").get("v.value"); 
        var searchFeild = component.get("v.selectBy");
       component.set("v.page",1);
        var page = component.get("v.page"); 
        console.log("page 1--> "+page);
        console.log("searchDepot--> "+searchDepot);
			//alert(searchKey);       
       if($A.util.isUndefined(searchKey) || searchKey ==''){
         	//alert(searchKey);
             helper.fetchRequirements(component,page,recordToDisply, searchDepot);   
         }else{
             helper.searchRequirements(component,helper,searchFeild,searchKey,page,recordToDisply, searchDepot);
        }
        
    },
   previous: function(component, event, helper) {  
       //var searchKey =  component.find("input1").get("v.value");
      // searchKey = searchKey.toUpperCase();
       var searchKey = component.get("v.selItem");
       var searchDepot = component.get("v.Selected_Depots");
        var searchFeild = component.get("v.selectBy");
       var recordToDisply = component.find("recordSize").get("v.value"); 
        component.set("v.page", component.get("v.page") - 1);  
        var page = component.get("v.page") ;
       //console.log("page--> "+page);
     
     if($A.util.isUndefined(searchKey) || searchKey ==''){
         	
             helper.fetchRequirements(component,page, recordToDisply, searchDepot);   
        }else{
       
             helper.searchRequirements(component,helper,searchFeild,searchKey,page,recordToDisply, searchDepot);
        }
                
    },
    First : function(component, event, helper) { 
        //var searchKey =  component.find("input1").get("v.value");
        //searchKey = searchKey.toUpperCase();
        var searchKey = component.get("v.selItem");
        var searchDepot = component.get("v.Selected_Depots");
        var searchFeild = component.get("v.selectBy");
        component.set("v.page",1);  
        var recordToDisply = component.find("recordSize").get("v.value");  
      
         var page = component.get("v.page") ;
        //console.log("page--> "+page);
        if($A.util.isUndefined(searchKey) || searchKey ==''){
            
             helper.fetchRequirements(component,page, recordToDisply, searchDepot);   
        }else{
          
             helper.searchRequirements(component,helper,searchFeild,searchKey,page,recordToDisply, searchDepot);
        }
    },  
    Last : function(component, event, helper) { 
        //var searchKey =  component.find("input1").get("v.value");
       // searchKey = searchKey.toUpperCase();
        var searchKey = component.get("v.selItem");
        var searchDepot = component.get("v.Selected_Depots");
        var searchFeild = component.get("v.selectBy");
        component.set("v.page",component.get("v.pages"));  
        var recordToDisply = component.find("recordSize").get("v.value");  
      
        var page = component.get("v.page") ;
        //console.log("page--> "+page);
      
        if($A.util.isUndefined(searchKey) || searchKey ==''){
         
             helper.fetchRequirements(component,page, recordToDisply, searchDepot);   
        }else{
        
             helper.searchRequirements(component,helper,searchFeild,searchKey,page,recordToDisply, searchDepot);
        }
    },  
    next:function(component, event, helper) {  
        //var searchKey =  component.find("input1").get("v.value");
       // searchKey = searchKey.toUpperCase();
       	var searchDepot = component.get("v.Selected_Depots");
        var searchFeild = component.get("v.selectBy");
        var recordToDisply = component.find("recordSize").get("v.value");
        component.set("v.page", component.get("v.page") + 1); 
        var page = component.get("v.page") ;
        var searchKey = component.get("v.selItem");
       	console.log("page--> "+page);
       console.log("searchFeild--> "+searchFeild);
        console.log("searchKey--> "+searchKey);
        console.log("recordToDisply--> "+recordToDisply);
        if($A.util.isUndefined(searchKey) || searchKey ==''){
          
             helper.fetchRequirements(component,page, recordToDisply, searchDepot);   
        }else{
           // console.log("searchKey inside else--> "+searchKey);
           // console.log("recordToDisply inside else--> "+recordToDisply);
             helper.searchRequirements(component,helper,searchFeild,searchKey,page,recordToDisply, searchDepot);
        }
    }
    
})