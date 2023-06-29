({
    clearImages: function(component, event, helper){  // Added By Nik to reset images on Report type change...02/05/2019
       
        var fileList = component.find("fileId").get("v.files");
        
        if(fileList !=null){
        component.find("fileId").set("v.value",[]);
        component.set("v.fileName","No File Selected..");
        component.set("v.ImgFileSize",0);
        }
    },

    doSave: function(component, event, helper) {
        console.log('doSave of schm file component called.');
         
         var param = event.getParam('arguments');
         var repTyp = param.reportingType;  // added by Nikhil on 08/04/2019....
        console.log(param.RecordId);
        component.set("v.parentId",param.RecordId);
        var imgDis = param.imgDisable;
        component.set("v.hideImageBox",imgDis);
        component.set("v.ImgFileName",param.imagelabel);
        var filelist = component.find("fileId").get("v.files");
        console.log('File in list'+JSON.stringify(filelist));

        if(repTyp == 'Existing Product Price update'){       // if..else block added by Nikhil on 08/04/2019....
            if (filelist == null ){
                console.log('Inside if...condition true...');
                component.set("v.showLoadingSpinner", false);
                component.set("v.ImgFileSize",0);
           }else 
           if( filelist.length > 0 ){
               helper.uploadHelper(component, event);
               component.set("v.ImgFileSize",filelist.length);
           }
         }                                                  // ...Nik
        else{              
        if (filelist == null ){
             alert('Please Select a valid File');
             component.set("v.ImgFileSize",0);
        }else 
        if( filelist.length > 0 ) {
             
            helper.uploadHelper(component, event);
            component.set("v.ImgFileSize",filelist.length);
        }
        }                                                  // ...Nik
    },
    handleFilesChange: function(component, event, helper) {
        try{
        var fileName = [];
        var fileList = component.find("fileId").get("v.files");
        var isvalid = false;
        console.log(fileList.length);
        if(fileList.length > 0){
            for(var i=0;i<fileList.length ;i++){
                fileName.push(fileList[i].name);  
                if(fileList[i].type.includes('/jpeg')){
                    //console.log(fileList[i].type.includes('/jpeg'));
                 isvalid = true;   
                }
                if(fileList[i].type.includes('/png')){
                 //console.log(fileList[i].type.includes('/png'));
                 isvalid = true;   
                }
                if(!isvalid){
                   alert('Please select valid file format.'); 
                    fileName='No file selected';
                }
        	}
        }if (fileList == null ){
             alert('Please Select a valid File');
             component.set("v.ImgFileSize",0);
            fileName='No file selected';
        }else
        if(fileList.length > 5){
            alert('Please do not select more than 5 images');
            fileName='No file selected';
        }
        console.log(fileName);
        component.set("v.fileName",fileName);
        component.set("v.ImgFileSize",fileList.length);
        }catch(e){
           alert(e);
			}
    },
})