({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
    
    uploadHelper: function(component, event) {
        // start/show the loading spinner   
        component.set("v.showLoadingSpinner", true);
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fileId").get("v.files"); 
        var isValid = true;
        var self = this;
        var count =0;
        var imagename = component.get("v.ImgFileName");
        [].forEach.call(fileInput, function(file) {
            count += 1;
            self.readFile(component,file,count,imagename);});
       var imgHd= component.get("v.hideImageBox");
        if(imgHd){
        	component.find("fileId").set("v.disabled",true);
          }
        component.set("v.fileName","No File Selected..");
        component.find("fileId").set("v.value", []);
        //$('#input-file-10').val('');
        var filelist = component.find("fileId").get("v.files");
        console.log('filelist length >>--->'+filelist.size);
        console.log('----------filelist--------------');
        console.log(filelist);
        console.log('----------filelist END--------------');
        console.log('ImgFileSizeB4 '+ component.get("v.ImgFileSize"));
        component.set("v.ImgFileSize",0);
        console.log('ImgFileSizeafter '+ component.get("v.ImgFileSize"));
    },
 
   readFile: function(component, file,count,imagename) {
   console.log('count>>>>>>>>>>'+count);
    
  var reader = new FileReader();
  var self1 = this;
  reader.onload = $A.getCallback(function(){
     var fileContents = reader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self1.uploadProcess(component, file, fileContents,count,imagename);
  });
  reader.readAsDataURL(file);
},
    uploadProcess: function(component, file, fileContents, count,imagename) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        //console.log('Filelist>>--->'+filelist);
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition,'',count,imagename);
    },
 
 
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId,count,imagename) {
        // call the apex method 'saveChunk'
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveChunk");
        var imageLen = component.get("v.ImgFileSize");
       console.log('count>>--->'+count);
        action.setParams({
            parentId: component.get("v.parentId"),
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId,
            imagelength:count,
            imageNamelabel:imagename
        });
 
        // set call back 
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                // check if the start postion is still less then end postion 
                // then call again 'uploadInChunk' method , 
                // else, diaply alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId,count,imagename);
                } else {
                   // alert('your File is uploaded successfully');
                    component.set("v.showLoadingSpinner", false);
                }
                // handel the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
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
        // enqueue the action
        $A.enqueueAction(action);
    }
})