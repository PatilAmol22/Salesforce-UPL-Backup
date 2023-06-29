public class attachmentsample {
public Integer fileSize { get; set; }
    public attachmentsample(ApexPages.StandardController controller) {

    }
    Public Attachment myfile;
    Public Attachment getmyfile()
    {
        myfile = new Attachment();
        return myfile;
    }
   
    Public Pagereference Savedoc()
    {
        String accid = System.currentPagereference().getParameters().get('id');
        
        if(fileSize > 10000000)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'File is not Uploaded:Max.File Size is 10MB'));  
            return null; 
        }
        else{

            Attachment a = new Attachment(parentId = accid, name=myfile.name, body = myfile.body);
             
             /* insert the attachment */
            insert a;
            PageReference pg = new PageReference('/'+accid);
            pg.setRedirect(true);
            return pg;
        }
    }   

}