({ 
    scriptsLoaded : function(component, event, helper) {
        var locale = $A.get("$Locale.langLocale");
        console.log('locale : ',locale);
        var delay = component.get('v.delay');               
        //Using the country in addition to lang locale because some users in Argentina have en_US set as 
        //default language ,GRZ(Gurubaksh Grewal) : APPS-1757 added on: 16-08-2022
        if($A.get("$Locale.country")==='AR' || $A.get("$Locale.userLocaleCountry")=='AR')locale='es_AR';
        if(locale == 'en_US'){
            component.set('v.isMexico', false);
            component.set('v.isBrazil', false);
            component.set('v.isIndia', true);
            component.set('v.isChile', false);
            component.set('v.isArgentina', false);
            window.setTimeout(function(){
                helper.scripts(component, event, helper);
            },delay*300);
        }
        else if(locale == 'es_MX')
        {
            component.set('v.isArgentina', false);
            component.set('v.isMexico', true);
            component.set('v.isBrazil', false);
            component.set('v.isIndia', false);
            component.set('v.isChile', false);
            window.setTimeout(function(){
                helper.scriptsMexico(component, event);
            },delay*100);
        }
        else if(locale == 'es_AR')
        {
            component.set('v.isArgentina', true);
            component.set('v.isMexico', false);
            component.set('v.isBrazil', false);
            component.set('v.isIndia', false);
            component.set('v.isChile', false);
            window.setTimeout(function(){
                helper.scriptsArgentina(component, event);
            },delay*100);
        }
        else if(locale == 'es')
        {
            console.log('InChile');
            component.set('v.isArgentina', false);
            component.set('v.isMexico', false);
            component.set('v.isBrazil', false);
            component.set('v.isIndia', false);
            component.set('v.isChile', true);
            window.setTimeout(function(){
                helper.scriptsChile(component, event);
            },delay*100);
        }
        else{
            component.set('v.isArgentina', false);
            component.set('v.isMexico', false);
            component.set('v.isIndia', false);
            component.set('v.isBrazil', true);
            component.set('v.isChile', false);
            window.setTimeout(function(){
                helper.scriptsBrazil(component, event);
            },delay*1000);
        }
    },
    openModel: function(component, event, helper) {
      component.set("v.isOpen", true);
   },
   closeModel: function(component, event, helper) {
      component.set("v.isOpen", false);
   },
   // SelectedVal: function(component, event, helper) {
  //       component.set('v.loaded', false);
  //        var locale = $A.get("$Locale.langLocale");
  //        var delay = component.get('v.delay');
   //       if(locale == 'en_US'){
   //            window.setTimeout(function(){
   //                 component.set('v.loaded', true);
   //             helper.ChangeMethod(component, event, helper);
  //          },delay*100);
 //        }
  //      },
    
    handleFocus:function(component, event, helper){
        console.log(event.getParam('recordId'));
        component.set('v.cusNumber', event.getParam('recordId'));
    },
    
    HandleCustmor:function(component, event, helper){
         component.set('v.loaded', false);
          var locale = $A.get("$Locale.langLocale");
          if(locale == 'es'){
            helper.scriptsChile(component, event, helper);
         }
    },

	//Using the doInit method for get the Sales Area Option in lightning combobox
    //(Mohit Garg) :added on: 06-10-2022
    doInit: function (cmp, event, helper) {
        var options = [];
        var action = cmp.get("c.getSalesAreaOptions");
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var arr = response.getReturnValue();
                cmp.set("v.valueOfSalesOrg",(arr[0].value));
                cmp.set("v.options", arr);
            }
        });
        $A.enqueueAction(action);
    },
    
    //handleChange method to get company code when we chenge the value in dropdown
    //(Mohit Garg) :added on: 06-10-2022
    
    handleChange: function (component, event, helper) {
        component.set('v.loaded', false);
        
        var itemNode = document.getElementById('pie-chart');
        itemNode.parentNode.removeChild(itemNode);
        document.getElementById('chartDiv').innerHTML = '<canvas class="canCSS slds-align_absolute-center"  id="pie-chart" width="300" height="250"></canvas>';
        
        var locale = $A.get("$Locale.langLocale");
        console.log('locale : ',locale);
       // console.log('jj',component.get("v.chart"));
       // component.get("v.chart").destroy();
        var delay = component.get('v.delay');
        if($A.get("$Locale.country")==='AR' || $A.get("$Locale.userLocaleCountry")=='AR')locale='es_AR';
        if(locale == 'en_US'){
            component.set('v.isMexico', false);
            component.set('v.isBrazil', false);
            component.set('v.isIndia', true);
            component.set('v.isChile', false);
            component.set('v.isArgentina', false);
           // window.setTimeout(function(){			//Code Commented to reduce the graph loading time ,GRZ(Butesh) : Ticket No. INC0418863 added on: 19-12-2022
                helper.scripts(component, event);
           // });
        }
  
        var selectedOptionValue = event.getParam("value");        
        component.set('v.valueOfSalesOrg', selectedOptionValue);
        console.log('test---2',component.get("v.valueOfSalesOrg"));
    }

    //+++++++++++++++++++++++++++++++++++++++++
})