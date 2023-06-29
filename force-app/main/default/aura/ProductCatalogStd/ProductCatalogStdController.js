({
    doInit: function (component, event, helper) {
        console.log('sessionStorage...', sessionStorage.length);
		//var pageReference = component.get("v.pageReference");
       // component.set("v.firstVal", pageReference.state.c__firstVal);
       // console.log('firstVal...', pageReference.state.firstVal);

       var urlString = window.location.href;
       var baseURL = urlString.substring(0, urlString.indexOf("/s"));
       component.set("v.homeURL", baseURL);
       
       console.log('baseURL...', urlString.indexOf("?"));

       if(urlString.indexOf("?") == -1){
        component.set("v.productURL", urlString);
       }
       else{
        component.set("v.productURL", urlString.substring(0, urlString.indexOf("?")));
       }
       
       component.set('v.pageNumber',1);
       component.set('v.pageSize',10);
        if(sessionStorage.length > 0){
            var resultMsg = sessionStorage.getItem( 'pageTransfer' );  
            //console.log('receiver length...', resultMsg.length);
            component.set("v.firstVal", JSON.parse(resultMsg).sel);
            component.set("v.secondVal", JSON.parse(resultMsg).cat);
            component.set("v.thirdVal", JSON.parse(resultMsg).scat);

            //sessionStorage.clear();
            

            //console.log('urlString 1...', urlString.substring(0, urlString.indexOf("?")));
           
        }
        else{
            
            //console.log('urlString 2...', urlString);
        }
                
        helper.getFirstDetails(component, event, helper);
        var url = $A.get('$Resource.orangeback');
        component.set('v.backgroundImageURL', url);
        
        var frstval = component.get("v.firstVal");
        var scndval = component.get("v.secondVal");
        var thrdval = component.get("v.thirdVal");

        if(frstval.length > 0 && scndval.length == 0){
            helper.getSecondDetails(component, event, helper);
        }
        else if(frstval.length > 0 && scndval.length > 0){
            helper.getSecondDetails(component, event, helper);
            helper.getThirdDetails(component, event, helper);
        }
        if(frstval.length ){
            //helper.getSecondDetails(component, event, helper);
           // helper.getThirdDetails(component, event, helper);
            helper.showProducts(component, event, helper);
        }
    },

    handleChange1: function (component, event, helper) {
        var frstval = component.get("v.firstVal");
        //var scndval = component.get("v.secondVal");
       // var thrdval = component.get("v.thirdVal");
        var arry = [];
        if(frstval == '' || frstval == null){
           // helper.getFirstDetails(component, event, helper);
            component.set("v.secondDropDownList", arry);
            component.set("v.thirdDropDownList", arry);
            component.set("v.allProductList", arry);
        }
        else{
            //helper.getFirstDetails(component, event, helper);
            helper.getSecondDetails(component, event, helper);
            component.set("v.thirdDropDownList", arry);
            component.set("v.allProductList", arry);
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
             component.set("v.allProductList", arry);
         }
         else if(frstval.length > 0 && scndval == ''){
             //helper.getFirstDetails(component, event, helper);
             //helper.getSecondDetails(component, event, helper);
             component.set("v.thirdDropDownList", arry);
             component.set("v.allProductList", arry);
         }
         else if(frstval.length > 0 && scndval.length > 0){
            // helper.getFirstDetails(component, event, helper);
            // helper.getSecondDetails(component, event, helper);
             helper.getThirdDetails(component, event, helper);
             component.set("v.allProductList", arry);
         }
    },

    handleShow: function (component, event, helper) {
        var frstval = component.get("v.firstVal");
        var scndval = component.get("v.secondVal");
        var thrdval = component.get("v.thirdVal");
        
        if(frstval.length > 0){

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
            
            sessionStorage.setItem('pageTransfer', JSON.stringify(pageReference.state));  
            
            helper.showProducts(component, event, helper);
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

    viewDetails: function (component, event, helper) {
        var target = event.getSource();  
        var val = target.get("v.value"); 
        //component.set("v.showCatalog", false);
        if(val.length>0){
            component.set("v.productName", val);
            
            helper.showDetails(component, event, helper);
        }
        //alert(val);
    },
    handleNext : function(component, event, helper) { 
        var sObjectList = component.get("v.allProductList")[0].productList;
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var pageNumber;
        var counter = 0;
        for(var i=end+1; i<end+pageSize+1; i++){
            if(sObjectList.length > i){
                Paginationlist.push(sObjectList[i]);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
    },
    
    handlePrev : function(component, event, helper) {        
        var sObjectList = component.get("v.allProductList")[0].productList;
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        var pageNumber;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                Paginationlist.push(sObjectList[i]);
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
    },
});