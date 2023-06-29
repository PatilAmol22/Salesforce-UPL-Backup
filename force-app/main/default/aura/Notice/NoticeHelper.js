({
	gettingNewsData : function(component,event,helper) {
		var action = component.get('c.getNewsList'); 
        
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('in return in notice '+JSON.stringify(a.getReturnValue()));
                var tmpResult = a.getReturnValue();
                var descriptionforNew = tmpResult[0].descriptionforNews;
                console.log('descriptionforNew '+descriptionforNew);
                
                
                component.set("v.returnNewsList",a.getReturnValue());
                
                
                /*var imgurl = a.getReturnValue()[0].imageurl;
                var title = a.getReturnValue()[0].title;
                console.log('imgurl in sa '+imgurl);
                component.set("v.imgursl",imgurl);
                component.set("v.title",title);
               component.set("v.description",a.getReturnValue()[0].description);
                component.set("v.Ids",a.getReturnValue()[0].Id);*/
                
                
               // component.set('v.sObjList', a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	},
    
    getUrlAddress:function(component,event,helper){
        console.log('in news component Helper method ');
        
        var action = component.get('c.gettingUrlAddress'); 
        
        
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                var tempUrlAdd = a.getReturnValue()+'/s/news-letters';
                console.log('tempUrlAdd in News Compoennt '+tempUrlAdd);
                component.set('v.urlAddress', tempUrlAdd);
            }
        });
        $A.enqueueAction(action);
    },
})