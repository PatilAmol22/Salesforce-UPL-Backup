({  
    initHandlers: function(component, event, helper) {

        var options = '';
        var options2 = '';
        var options3 = '';
        var resultlis= component.get("v.resultlis");
        var description1 =  component.get("v.fields");
        var ready = component.get("v.ready");
        var field1= description1;
        var sObjectType = component.get("v.sObjectType");
        var WhereClause = component.get("v.WhereClause");
        var limitSize = component.get("v.limit");
        var dataListElement = document.getElementById("resultList");        
        if (ready === false) {
            console.log('Return without');
           	return;
        }
        var action = component.get("c.getSuggestions");
        action.setParams({ sObjectType : sObjectType,
                          fields: description1,
                          WhereClause: WhereClause
                         });
        
        action.setCallback(this,function(response){
            if (action.getState() === "SUCCESS"){
                var accList = response.getReturnValue();
                console.log('acclist : '+accList);
                if(description1=='SKU__r.SKU_Description__c'){
                    for(var i = 0; i < accList.length; i++){
                        options += '<option value="'+accList[i].SKU__r.SKU_Description__c+'" />';
                    }
                    document.getElementById('resultList').innerHTML = options;
                } 
                else if(description1=='Location__c'){
                    for(var i = 0; i < accList.length; i++){
                        if(accList[i].Name == 'EXPR'){
                            if(component.get('v.isAdmin') == true){
                                options2 += '<option value="'+accList[i].Location__c +'" />';
                            }
                        }else{
                            options2 += '<option value="'+accList[i].Location__c +'" />';
                        }

                    }
                    document.getElementById('resultList').innerHTML = options2;   
                }
                else if(description1=='SKU__r.SKU_Code__c'){
                    console.log('description1000000000 :--- '+description1);
                    for(var i = 0; i < accList.length; i++){
                        options3 += '<option value="'+accList[i].SKU__r.SKU_Code__c+'" />';
                    }
                    document.getElementById('resultList').innerHTML = options3;   
                }
                else if(description1=='SKU__r.Brand_Name__c'){
                    console.log('description1000000000 :--- '+description1);
                    for(var i = 0; i < accList.length; i++){
                        console.log('description1000000000 :--- '+ accList[i].SKU__r.Brand_Name__c);
                        if(accList[i].SKU__r.Brand_Name__c != 'undefined' && accList[i].SKU__r.Brand_Name__c != undefined && accList[i].SKU__r.Brand_Name__c != ''){
                            options3 += '<option value="'+accList[i].SKU__r.Brand_Name__c+'" />';
                        }
                    }
                    document.getElementById('resultList').innerHTML = options3;   
                }

            }
            
        });
        $A.enqueueAction(action);
		
    }

})