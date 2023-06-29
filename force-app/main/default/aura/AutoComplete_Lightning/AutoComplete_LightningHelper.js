({  
    initHandlers: function(component, event, helper) {

        var options = '';
        var options2 = '';
        var options3 = '';
        var resultlis= component.get("v.resultlis");
        //console.log('resultlis :----- '+resultlis);
        var description1 =  component.get("v.fields");
        //console.log('description1 :----- '+description1);
    	var ready = component.get("v.ready");
        //console.log('ready :----- '+ready);
        var field1= description1;
        var sObjectType = component.get("v.sObjectType");
        //console.log('sObjectType :----- '+sObjectType);
        var WhereClause = component.get("v.WhereClause");
        //console.log('WhereClause :----- '+WhereClause);
        var limitSize = component.get("v.limit");
        //console.log('limitSize :----- '+limitSize);
        
       // var inputElement = component.find("searchText").getElement();        
        //console.log("searchText.value --> "+inputElement.value);
        
        //.get("e.c:SearchInventoryEvent").setParams({term: inputElement.value}).fire();
       // component.set("v.selItem", inputElement.value);
        //var searchTerm = inputElement.value;        
        /*console.log('searchTerm :- '+searchTerm);
        console.log('field1 :- '+field1);
        console.log('WhereClause :- '+WhereClause);
        */
        var dataListElement = document.getElementById("resultList");        
        /*console.log("dataListElement --> "+dataListElement);
        console.log("description1 --> "+description1);
        */
        if (ready === false) {
           	return;
        }
        var action = component.get("c.getSuggestions");
        //if(description=='SKU__r.SKU_Description__c'){
        console.log('Sayan00 sObjectType-->'+sObjectType);
        console.log('Sayan00 description1-->'+description1);
        console.log('Sayan00 WhereClause-->'+WhereClause);
        action.setParams({ sObjectType : sObjectType,
                          fields: description1,
                          WhereClause: WhereClause
                         });
        
        //}
        action.setCallback(this,function(response){
            //console.log(response.getState());
            //console.log(response.getReturnValue());
            console.log('description1 :--- '+description1);
            if (action.getState() === "SUCCESS"){
                console.log("I am in Autocomplete SUCCESS");
                var accList = response.getReturnValue();
                if(description1=='SKU__r.SKU_Description__c'){
                    for(var i = 0; i < accList.length; i++){
                        if(accList[i].SKU__c != 'undefined' && accList[i].SKU__c != undefined && accList[i].SKU__c != ''){
                            if(accList[i].SKU__r.SKU_Description__c != 'undefined' && accList[i].SKU__r.SKU_Description__c != undefined && accList[i].SKU__r.SKU_Description__c != ''){
                                options += '<option value="'+accList[i].SKU__r.SKU_Description__c+'" />';
                            }
                        }
                    }
                    document.getElementById('resultList').innerHTML = options;
                } 
                else if(description1=='Depot_Code__c'){
                    for(var i = 0; i < accList.length; i++){
                        // console.log('description1 :--- '+accList[i].Name);
                        if(accList[i].Name == 'EXPR'){
                            if(component.get('v.isAdmin') == true){
                                options2 += '<option value="'+accList[i].Name+'" />';
                            }
                        }else{
                            options2 += '<option value="'+accList[i].Name+'" />';
                        }

                    }
                    document.getElementById('resultList').innerHTML = options2;   
                }
                else if(description1=='SKU__r.SKU_Code__c'){
                    for(var i = 0; i < accList.length; i++){
                        if(accList[i].SKU__c != 'undefined' && accList[i].SKU__c != undefined && accList[i].SKU__c != ''){
                            if(accList[i].SKU__r.SKU_Code__c != 'undefined' && accList[i].SKU__r.SKU_Code__c != undefined && accList[i].SKU__r.SKU_Code__c != ''){
                                options3 += '<option value="'+accList[i].SKU__r.SKU_Code__c+'" />';
                            }
                        }
                    }
                    document.getElementById('resultList').innerHTML = options3;   
                }
                else if(description1=='SKU__r.Brand_Name__c'){
                    for(var i = 0; i < accList.length; i++){
                        if(accList[i].SKU__c != 'undefined' && accList[i].SKU__c != undefined && accList[i].SKU__c != ''){
                            if(accList[i].SKU__r.Brand_Name__c != 'undefined' && accList[i].SKU__r.Brand_Name__c != undefined && accList[i].SKU__r.Brand_Name__c != ''){
                                options3 += '<option value="'+accList[i].SKU__r.Brand_Name__c+'" />';
                            }
                        }
                    }
                    document.getElementById('resultList').innerHTML = options3;   
                }
				else if(description1=='(Select id,Name,Email from contacts where Email!=null)'){
                    for(var i = 0; i < accList.length; i++){
                        console.log('Account Name-->'+accList[i].Name);
                        if(accList[i].Name != 'undefined' && accList[i].Name != undefined && accList[i].Name != ''){
                            options += '<option value="'+accList[i].Name+'" />';
                        }
                    }
                    document.getElementById('resultList').innerHTML = options;   
                }
                //var selectedValue= event.getSource().get("v.value");
                //console.log('check value  :- '+component.find("searchText").getElement().value);
               
                //inputElement.setAttribute("List" :);
            }
            
        });
        $A.enqueueAction(action);
		
    }

})