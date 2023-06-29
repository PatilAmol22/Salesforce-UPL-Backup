({
    doInit: function (component, event, helper) {
        var recordId = component.get("v.recordId");
        console.log('doInit called....');
       // console.log('recordId.... : '+ recordId);
       /* var pageReference = {
        type: 'comm__namedPage',
        attributes: {
            //componentName: 'c__ProductCatalog',
                pageName: 'product-catalogues'
            }
        };
        component.set("v.pageReference", pageReference); */

        helper.getFirstDetails(component, event, helper);
        var url = $A.get('$Resource.orangeback');
        component.set('v.backgroundImageURL', url);
    },

    handleChange1: function (component, event, helper) {
        var frstval = component.get("v.firstVal");
        //var scndval = component.get("v.secondVal");
        //var thrdval = component.get("v.thirdVal");
        var arry = [];
        if(frstval == '' || frstval == null){
           // helper.getFirstDetails(component, event, helper);
            component.set("v.secondDropDownList", arry);
            component.set("v.thirdDropDownList", arry);
        }
        else{
            //helper.getFirstDetails(component, event, helper);
            helper.getSecondDetails(component, event, helper);
            component.set("v.thirdDropDownList", arry);
        }
        
    },

    handleChange2: function (component, event, helper) {
        var frstval = component.get("v.firstVal");
        var scndval = component.get("v.secondVal");
        //var thrdval = component.get("v.thirdVal");
        var arry = [];

        if(frstval == '' || frstval == null){
            // helper.getFirstDetails(component, event, helper);
             component.set("v.secondDropDownList", arry);
             component.set("v.thirdDropDownList", arry);
         }
         else if(frstval.length > 0 && scndval == ''){
             //helper.getFirstDetails(component, event, helper);
             //helper.getSecondDetails(component, event, helper);
             component.set("v.thirdDropDownList", arry);
         }
         else if(frstval.length > 0 && scndval.length > 0){
            // helper.getFirstDetails(component, event, helper);
            // helper.getSecondDetails(component, event, helper);
             helper.getThirdDetails(component, event, helper);
         }
    },

    handleShow: function (component, event, helper) {
        var frstval = component.get("v.firstVal");
        var scndval = component.get("v.secondVal");
        var thrdval = component.get("v.thirdVal");
       // var arry = [];

        if(frstval.length > 0){
                                        // <!-- for navigation -->
            /* event.preventDefault();  
            var navService = component.find( "navService" );  
            var pageReference = {  
                type: "comm__namedPage",  
                attributes: {  
                    pageName: "product-catalogues"      // tab name here...*************##########********
                },  
                state: {  
                    sel: frstval,
                    cat: scndval, 
                    scat: thrdval 
                }  
            };  
            sessionStorage.setItem('pageTransfer', JSON.stringify(pageReference.state));  
            navService.navigate(pageReference);  */
            event.preventDefault();
            var navService = component.find('navService');
            var pageReference = component.get('v.pageReference');
            var pageReference = {  
                type: "comm__namedPage",  
                attributes: {  
                    pageName: "product-catalogues"      // tab name here...*************##########********
                },  
                state: {  
                    sel: frstval,
                    cat: scndval, 
                    scat: thrdval 
                }  
            };  
            var handleUrl = (url) => {
                window.open(url);
            };
            var handleError = (error) => {
                console.log(error);
            };
            sessionStorage.setItem('pageTransfer', JSON.stringify(pageReference.state));  
            navService.generateUrl(pageReference).then(handleUrl, handleError);
           // navService.navigate(pageReference);

        }
        else{
            component.find("first_dropDwn").focus();
            var toastEvent1 = $A.get("e.force:showToast");
            var titl  = $A.get("{!$Label.c.Warning}");
            var errMsg = $A.get("{!$Label.c.select_an_option}");
            toastEvent1.setParams({
                "title": titl,
                "type": "Warning",
                "message": errMsg
                //"duration":'3000'
            });
            toastEvent1.fire();
        }
    },
});