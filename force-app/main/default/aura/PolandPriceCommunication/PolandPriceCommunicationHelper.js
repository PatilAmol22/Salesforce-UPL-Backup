({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 4500000, //Max size 4.5 MB  
    //CHUNK_SIZE: 750000, //Chunk Max size 750Kb 

    validateData :function(component){
        var flag = true;
        if(component.find("fileId").get("v.files")!=undefined){
            var fileCount=component.find("fileId").get("v.files").length;
        }
        
        /*var distributorDetailList=component.get('v.distributorDetailList');
        for(var i=0;i<distributorDetailList.length;i++){
            if(distributorDetailList[i].checkMail){
                if(component.get('v.isSendEmailChecked')==false){
                    this.showMessage('Please select send email',false);
                    flag=false; 
                }
            }
        }*/
        if(component.get('v.distributorDetailList')==undefined || component.get('v.distributorDetailList')==''){
            this.showMessage($A.get("$Label.c.Please_add_distribution_details"),false);
            flag=false;
        }else 
        if(component.get('v.description')==undefined || component.get('v.description')==''){
            this.showMessage($A.get("$Label.c.Please_add_description"),false);
            flag=false;
        }else
        if(component.get('v.fileName')==undefined || component.get('v.fileName')==''){
            this.showMessage($A.get("$Label.c.Please_select_file"),false);
            flag=false;
        }else 
         if (fileCount > 0) {
             console.log('fileCount :'+fileCount);
             var fsizeSum=0;
                for (var i = 0; i < fileCount; i++){
                    var file=component.find("fileId").get("v.files")[i];
                    var maxFileSize=4500000;
                    var fSize=file.size;
                    fsizeSum=fsizeSum+fSize;
                    if (file.size > maxFileSize) {
                        this.showMessage('Selected file size:'+file.size+'. '+ $A.get("$Label.c.Please_select_file_less_than_4_5_MB"),false);
                        flag=false;
                    }
                }
             component.set('v.fileSize',fsizeSum);
                    
            }
        console.log('flag :'+flag);  
        return flag;    
    },

    uploadFiles: function(component, event) {
        var isValid=this.validateData(component);
        if(isValid){
            if (component.find("fileId").get("v.files").length > 0) {
                var s = component.get("v.FilesUploaded");
                var fileName = "";
                var fileType = "";
                var fileCount=component.find("fileId").get("v.files").length;
                if (fileCount > 0) {
                    for (var i = 0; i < fileCount; i++) 
                    {
                        var jCount=i+1;
                        this.uploadHelper(component, event,component.find("fileId").get("v.files")[i],jCount);
                    }
                    component.set('v.totalFilength',fileCount);
                }
            } else {
                this.showMessage($A.get("$Label.c.Please_Select_a_Valid_File"),false);
            }
        }
    },
    
    uploadHelper: function(component, event,f,jCount) {
       	//component.set("v.showLoadingSpinner", true);
        /*var fileSplit=[];
        if(f.includes('==>')){
            fileSplit=f.split('==>');
            console.log('fileSplit[0]'+fileSplit[0]);
            console.log('fileSplit[0]'+fileSplit[1]);
            component.set('v.totalFileCount',fileSplit[1]);
            file = fileSplit[0];
        }else{
            file = f;
        }*/
        var file =f;
        var self = this;
        // Convert file content in Base64
        var objFileReader = new FileReader();
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
            var upcount= self.uploadProcess(component, file, fileContents,jCount);
            console.log('upcount :'+upcount);
        });

        objFileReader.readAsDataURL(file);
    },

    uploadProcess: function(component, file, fileContents,jCount) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        console.log('endPosition :'+endPosition);
        console.log('file :'+JSON.stringify(file));
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition,jCount);
        return jCount;
    },
    
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition,totalFileCount) {
        var getPolandPriceCommList=component.get('v.polandPriceComList');
        var getdistributorDetailList=component.get('v.distributorDetailList');
        //var totalFileCount=component.get('v.totalFileCount');
        var emailArray=[];
        for(var i=0;i<getdistributorDetailList.length;i++){
            console.log('cEmail :'+getdistributorDetailList[i].cEmail)
            emailArray.push(getdistributorDetailList[i].cEmail);
        }
        console.log('file name : '+component.get('v.fileName '));
        console.log('emailArray : '+emailArray);
        console.log('getPolandPriceCommList : '+getPolandPriceCommList);
        console.log('totalFileCount : '+totalFileCount);
        console.log('file.name : '+file.name);
        console.log('file.type : '+file.type);
        // call the apex method 'saveFile'
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.uploadFileAttachments");
        component.set("v.showSpinner", true);
        action.setParams({
            // Take current object's opened record. You can set dynamic values here as well
            ppComList:getPolandPriceCommList,
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            emailIds: emailArray,
            totalFileCount:totalFileCount
        });

        // set call back 
        action.setCallback(this, function(response) {
            var state = response.getState();
            var totalFileCountNew=response.getReturnValue();
            console.log('totalFileCountNew : '+totalFileCountNew);
            component.set("v.showSpinner", false);
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition);
                } else {
                   	component.set('v.totalFileCount',totalFileCountNew);
                    console.log('totalFileCountNew : '+totalFileCountNew);
                    this.showMessage($A.get("$Label.c.Files_uploaded_Successfully"),true);
                    var tfcount=component.get('v.totalFileCount');
                    var tflength=component.get('v.totalFilength');
                    console.log('tfcount : '+tfcount);
                    console.log('tflength : '+tflength);
                    if(tflength==tfcount){
                        this.sendEmail(component);
                    }
                }
                // handel the response errors        
            } else if (state === "INCOMPLETE") {
                this.showMessage("From server: " + response.getReturnValue(),false);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    createPolandPriceCommunication : function(component){
        console.log('isSendEmailChecked :'+component.get('v.isSendEmailChecked'));
        console.log('description :'+component.get('v.description'));
        console.log('distributorDetailList :'+JSON.stringify(component.get('v.distributorDetailList')));
        return new Promise(
            $A.getCallback(function(resolve, reject) {
                var action = component.get("c.createPPCommunication");
                component.set("v.showSpinner", true); 
                action.setParams({
                    isSendEmail:component.get('v.isSendEmailChecked'),
                    description: component.get('v.description'),
                    distributorDetailList: JSON.stringify(component.get('v.distributorDetailList'))
                }); 
                action.setCallback(this, function(a) {
                    // on call back make it false ,spinner stops after data is retrieved
                    component.set("v.showSpinner", false); 
                    var state = a.getState();
                    resolve(state);
                    if (state == "SUCCESS") {
                        var returnValue = a.getReturnValue();
                        console.log('ppList returnValue : '+JSON.stringify(returnValue));
                        component.set('v.polandPriceComList',returnValue);
                        //this.showMessage('Record is inserted successfully',true);
                        component.set('v.recordSaved',true);
                        
                    }else if(state=="Error"){
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                //this.showMessage('Error message: '+errors[0].message,false);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                        component.set('v.recordSaved',false);
                    }
                });
                $A.enqueueAction(action);         
                
                
            })
        );
    },
    
    sendEmail : function(component){
        
        var isSendEmailChecked=component.get('v.isSendEmailChecked');
        console.log('isSendEmailChecked :'+isSendEmailChecked);
        if(isSendEmailChecked){
            component.set("v.showSpinner", true); 
            var action = component.get("c.sendEmailMethod");
            action.setCallback(this, function(a) {
                // on call back make it false ,spinner stops after data is retrieved
                component.set("v.showSpinner", false); 
                var state = a.getState();
                
                if (state == "SUCCESS") {
                    var returnValue = a.getReturnValue();
                    console.log('returnValue : '+JSON.stringify(returnValue));
                    this.showMessage($A.get("$Label.c.Email_Send_Successfully"),true);
                    $A.get('e.force:refreshView').fire();
                }else if(state=="Error"){
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            this.showMessage($A.get("$Label.c.Error_Message")+':'+errors[0].message,false);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }else{
            $A.get('e.force:refreshView').fire();
        }
        
        
    },
    
    showMessage : function(message,isSuccess) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": isSuccess?"Success!":"Error!",
            "type":isSuccess?"success":"error",
            "message": message
        });
        toastEvent.fire();
    }
    
    
    
})