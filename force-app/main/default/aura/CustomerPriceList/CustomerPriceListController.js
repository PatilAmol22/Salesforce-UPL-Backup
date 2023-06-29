({    
    doInit: function(component,event,helper) {
        helper.getProfileName(component,event,helper);        
        helper.getSalesDistrict(component,event,helper);
    },
    getCustomer: function(component,event,helper){
        console.log('in getCustomer');
        helper.helperGetCustomer(component,event,helper);
        //helper.helperSDGetPriceBook(component,event,helper);
    }, 
    getPriceBook: function(component,event,helper){
        console.log('in getPricebook');
        
        
        helper.helperGetPriceBook(component,event,helper);
        
        
    } ,
    getPriceList: function(component,event,helper){
        console.log('in getPricelist');
        
        
        
        helper.getProfileName(component,event,helper); 
        helper.helperGetPriceList(component,event,helper);
    },
    
    Validation : function(component,event,helper){
        var crmId=component.find("priceBook").get("v.value");
        component.set('v.crmId1',crmId);
        console.log("id is **********",crmId);
        component.set("v.DisplayComponents",false);
        if(crmId){
            $A.util.addClass(component.find("pberro"),"slds-hide");
        }
        else{
            $A.util.removeClass(component.find("pberro"),"slds-hide");
        }
        
        
        
          
      // var priceBookDetail1 = component.get("v.pricebookdetail");

      /*  for(var i=0;i<priceBookDetail1.length;i++){
            var validFrom=priceBookDetail1[i].Valid_From__c;
            var lastMonth=priceBookDetail1[i].Last_Month_Of_The_Season__c;
            var intrestBrl=priceBookDetail1[i].Interest_Rate_R__c;
            var intrestUsd=priceBookDetail1[i].Interest_Rate_U__c;
            
            for(var i=validFrom;i<=lastMonth;i++){
                if(validFrom==lastMonth){
                    
                    console.log("same month");
                    
                }else if(validFrom<=lastMonth){
                    
                    console.log("diff");
                    
                }
            }

        }
        */
        
        //BELOW 15 LINES OF CODE ADDED BY HARSHIT&SAGAR@WIPRO FOR (US PB-006) ---START
        var priceBookid = component.get("v.crmId1");
        var custId=component.find("customer").get("v.value");
        var action = component.get("c.getpricebookdetail");
        action.setParams({
            "crmId":priceBookid,
            "custId": custId,
        });
        action.setCallback(this,function(response){
            
            var state = response.getState();
            if(state=="SUCCESS"){
            
                component.set('v.pricebookdetail',response.getReturnValue());
            
            var pricebookdetail12 =JSON.parse(JSON.stringify(response.getReturnValue()));
            var pricebookdetail22 =JSON.stringify(response.getReturnValue()); 
                console.log("pricebookdetail",pricebookdetail12);
                console.log("pricebookdetail11",pricebookdetail22);
                console.log("inside",response.getReturnValue());
                
                var pricebookdetail2 = component.get("v.pricebookdetail");
       // console.log("custPriceList**********)))))))))",custPriceList);
          for(var i = 0; i < pricebookdetail2.length; i++){
            //var replc = priceDetailList1[i].materialPlnRplcCost;
              var curr = pricebookdetail2[i].curr;
              console.log('currrrr is***'+curr);
            //var unitValueBRL1 = priceDetailList1[i].unitValueBRL;
            //var unitValueUSD1 = priceDetailList1[i].unitValueUSD;
                        
              if(curr=="BRL"){
                  //curr1=true;
                  component.set("v.showUSDPrice",false);
                  component.set("v.showBRLPrice",true);
					
              }
               if(curr=="USD"){
                  //curr1=true;
                  component.set("v.showBRLPrice",false);
                  component.set("v.showUSDPrice",true);
					//component.set("v.showBRLPrice",false);
              }
           
             console.log('showBRLPrice***',component.get("v.showBRLPrice"));
              console.log('showUSDPrice***',component.get("v.showUSDPrice"));
        
//---END
    
          }
                
          }
                         
       });
        $A.enqueueAction(action);
      
        //---END
        
    },
    custValidation : function(component,event,helper){
        var crmId=component.find("customer").get("v.value");
        if(crmId){
            $A.util.addClass(component.find("custerro"),"slds-hide");
        }
        else{
            $A.util.removeClass(component.find("custerro"),"slds-hide");
        }
        helper.helperSDGetPriceBook(component,event,helper);
    }
})