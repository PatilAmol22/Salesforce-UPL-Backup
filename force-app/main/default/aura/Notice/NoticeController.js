({
	doInit : function(component, event, helper) {
        console.log('in doinitdsadadas');
        
        helper.gettingNewsData(component,event,helper);
        helper.getUrlAddress(component,event,helper);
        
		
	},
    
    /*Download_file:function(component,event,helper){
        console.log('On download file');
        var idOfRec = component.get("v.Ids");
        console.log('idOfRec '+idOfRec);
        let baseUrl = 'https://upl--upltest.my.salesforce.com/';
        console.log('baseUrl : '+baseUrl);
        
        var action = component.get('c.getContentVersionIds'); 
        
        action.setParams({
            "nId" : idOfRec
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('a.getReturnValue() in download file '+a.getReturnValue());
                var docId = a.getReturnValue();
                if(docId==''){
                    this.showNotification();
                }else{
                    for (let i = 0; i < docId.length; i++) {
                        const element = result[i];
                        console.log('element : '+element);
                        setTimeout(function timer() {
                            let downloadElement = document.createElement('a');
                            downloadElement.href = baseUrl+'sfc/servlet.shepherd/version/download/'+element;
                            downloadElement.target = '_self';
                            document.body.appendChild(downloadElement);
                            downloadElement.click(); 
                        }, i * 3000);
                        
                    }
                }
                
               /// component.set('v.sObjList', a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
    },*/
    
    showNotification:function(component,event,helper){
        /*const evt = new ShowToastEvent({
            title: "Download Files",
            message: "No Files Present",
            variant: "error",
        });
        this.dispatchEvent(evt);*/
    }
    
    
   
})