({
    scriptsLoaded: function (component, event, helper) {
        console.log('Script loaded..');
        $(".collapseimg").hide();
        $(document).ready();
    },
    showSpinner: function (component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        console.log("Calling");
        component.set("v.Spinner", true);

    },

    // this function automatic call by aura:doneWaiting event 
    hideSpinner: function (component, event, helper) {
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    },

    // to fetch data on load
    doInit: function (component, event, helper) {
        console.log("TOday-->");
        var page = component.get("v.page") || 1;
        var recordToDisply = component.find("recordSize").get("v.value");
        var searchKey = event.getParam("term");
        var searchField = component.get("v.selectBy");
        component.set("v.showStorageLocation", false);
        component.set("v.showSKUCode", false);
        helper.fetchDepot(component, helper);
        var searchDepot = component.get("v.Selected_Depots");


        if ($A.util.isUndefined(searchKey) || searchKey == '') {
            console.log("TOday- IF ->");
            console.log("TOday- IF ->",searchDepot);
            helper.fetchRequirements(component, page, recordToDisply, searchDepot);//   Called this inside fetch depot
        } else {
            console.log("TOday- ELSE ->");
        }
    },

    //To search again  when selected depot is changed in mmulti select picklist
    onDepotChange: function (component, event, helper) {
        var searchKey = component.get("v.selItem"); //event.getParam("term");

        // var searchDepot = component.find("depot_items").get("v.value");
        var searchDepot = component.get("v.Selected_Depots");
        // var opts = component.find("select_id").get("v.value");

        var opts = document.querySelector('input[name="options"]:checked').value;
        var recordToDisply = component.find("recordSize").get("v.value");
        var searchField = "DepotName";
        component.set("v.page", 1);
        var page = component.get("v.page");

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

    //When Page size changes
    onpagesizechange: function (component, event, helper) {

        var page = 1;
        console.log('Done 1');
        var recordToDisply = component.find("recordSize").get("v.value");
        console.log('Done 2');
        var searchKey = component.get("v.selItem");
        console.log('Done 3');
        // var searchDepot = component.find("depot_items").get("v.value");
        var searchDepot = component.get("v.Selected_Depots");
        console.log('Done 4');
        
        var searchField = component.get("v.selectBy");
        console.log('Done 5');

        if ($A.util.isUndefined(searchKey) || searchKey == '') {

            helper.fetchRequirements(component, page, recordToDisply, searchDepot);
        } else {
            helper.searchRequirements(component, searchField, searchKey, page, recordToDisply, searchDepot);
        }
        component.set("v.page", 1);
    },

    //JQuery toggle expand and collapse functionality
    toggleExpandAll: function (component, event, helper) {
        $(".expand").hide();
        $(".collapse").show();
        $(".collapseimg").show();
        $(".expandimg").hide();
        $(".table").show();
        $(".errtd").show();

    },

    //to search again when search by radio button changes
    onRadioSelect: function (component, event, helper) {
        // var opts = component.find("select_id").get("v.value");
        var opts = document.querySelector('input[name="options"]:checked').value;
		/*component.set("v.selectBy", opts);	    
        */
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

    toggleCollapseAll: function (component, event, helper) {
        $(".expandimg").show();
        $(".expand").show();
        $(".collapse").hide();
        $(".collapseimg").hide();
        $(".errtd").hide();
        $(".table").hide();
        // $(".errtd").hide();

    },
    toggleExpand: function (component, event, helper) {
        var index = event.currentTarget.dataset.rowIndex;
        //alert('Expand>>--->'+index);
        $("#" + index + "imgexp").hide();
        $("#" + index + "imgcolsp").show();
        $("#" + index + "table").show();
        // $("#"+index+"tr").show(); 
        $("#" + index + "errtd").show();
        var toggleText = component.find("text");
        $A.util.toggleClass(toggleText, "toggle");
    },
    toggleCollapse: function (component, event, helper) {
        var index = event.currentTarget.dataset.rowIndex;
        //alert('collapse>>--->'+index);
        $("#" + index + "imgexp").show();
        $("#" + index + "imgcolsp").hide();
        $("#" + index + "table").hide();
        // $("#"+index+"tr").hide();
        $("#" + index + "errtd").hide();

        var toggleText = component.find("text");
        $A.util.toggleClass(toggleText, "toggle");
    },

    //When searchkey changes(Not in use)
    searchKeyChange: function (component, event, helper) {

        var searchKey = component.find("input1").get("v.value");
        var searchDepot = component.find("depot_items").get("v.value");
        //searchKey = searchKey.toUpperCase();
        var recordToDisply = component.find("recordSize").get("v.value");
        var searchField = component.get("v.selectBy");
        component.set("v.page", 1);
        var page = component.get("v.page");
        //alert(searchKey);       
        if ($A.util.isUndefined(searchKey) || searchKey == '') {
            //alert(searchKey);
            helper.fetchRequirements(component, page, recordToDisply, searchDepot);
        } else {
            helper.searchRequirements(component, helper, searchField, searchKey, page, recordToDisply);
        }

    },

    //Pagination methods
    previous: function (component, event, helper) {
        var searchKey = component.get("v.selItem");//event.getParam("term");
        // var searchDepot = component.find("depot_items").get("v.value");
        var searchDepot = component.get("v.Selected_Depots");
        var searchField = component.get("v.selectBy");
        var recordToDisply = component.find("recordSize").get("v.value");
        component.set("v.page", component.get("v.page") - 1);
        var page = component.get("v.page");

        if ($A.util.isUndefined(searchKey) || searchKey == '') {

            helper.fetchRequirements(component, page, recordToDisply, searchDepot);
        } else {

            helper.searchRequirements(component, searchField, searchKey, page, recordToDisply, searchDepot);
        }

    },
    //Pagination methods
    First: function (component, event, helper) {
        var searchKey = component.get("v.selItem");//event.getParam("term");
        // var searchDepot = component.find("depot_items").get("v.value");
        var searchDepot = component.get("v.Selected_Depots");
        var searchField = component.get("v.selectBy");
        component.set("v.page", 1);
        var recordToDisply = component.find("recordSize").get("v.value");

        var page = component.get("v.page");
        if ($A.util.isUndefined(searchKey) || searchKey == '') {

            helper.fetchRequirements(component, page, recordToDisply, searchDepot);
        } else {

            helper.searchRequirements(component, searchField, searchKey, page, recordToDisply, searchDepot);
        }
    },

    //Pagination methods
    Last: function (component, event, helper) {
        var searchKey = component.get("v.selItem");//event.getParam("term");
        // var searchDepot = component.find("depot_items").get("v.value");
        var searchDepot = component.get("v.Selected_Depots");
        //var searchDepot = component.get("v.Selected_Depots");
        var searchField = component.get("v.selectBy");
        component.set("v.page", component.get("v.pages"));
        var recordToDisply = component.find("recordSize").get("v.value");
        var page = component.get("v.page");
        /* if(page==0){
         page=1;
          
        }*/

        if ($A.util.isUndefined(searchKey) || searchKey == '') {
            // console.log("Last FetchRequirement Page Size--> "+page);
            helper.fetchRequirements(component, page, recordToDisply, searchDepot);
        } else {

            helper.searchRequirements(component, searchField, searchKey, page, recordToDisply, searchDepot);
        }
    },
    //Pagination methods
    next: function (component, event, helper) {
        var searchKey = component.get("v.selItem");//event.getParam("term");
        //var searchDepot = component.find("depot_items").get("v.value");
        var searchDepot = component.get("v.Selected_Depots");
        var searchField = component.get("v.selectBy");
        var recordToDisply = component.find("recordSize").get("v.value");
        component.set("v.page", component.get("v.page") + 1);
        var page = component.get("v.page");
        if ($A.util.isUndefined(searchKey) || searchKey == '') {
            // console.log("searchKey inside if--> "+searchKey);
            helper.fetchRequirements(component, page, recordToDisply, searchDepot);
        } else {
            // console.log("recordToDisply inside else--> "+recordToDisply);
            helper.searchRequirements(component, searchField, searchKey, page, recordToDisply, searchDepot);
        }
    }

})