public class NoteController {
	 @AuraEnabled
    public static List < NoteWrapper > fetchNotes( String strRecordId )  {  
          
        List < NoteWrapper > listNoteWrappers = new List < NoteWrapper >();  
        Set < Id > setDocIds = new Set < Id >();  
        for ( ContentDocumentLink objCDL : [ SELECT ContentDocumentId FROM ContentDocumentLink  WHERE LinkedEntityId =: strRecordId ] ){
            setDocIds.add( objCDL.ContentDocumentId ); 
        }  
             
        for( ContentNote objNote : [ SELECT Id, Title, Content, CreatedDate FROM ContentNote WHERE Id IN: setDocIds ORDER BY CreatedDate ] ) {  
  
            NoteWrapper objWrapper = new NoteWrapper();  
            objWrapper.strTitle = objNote.Title;  
            //Below replaceAll removes all the HTML tags from the Content  
            objWrapper.strNotes = objNote.Content.toString().replaceAll( '<[^>]+>',' ' );  
            objWrapper.strCreatedDate = String.valueOf( objNote.CreatedDate.date() );  
            objWrapper.isEdit = true;
            objWrapper.noteId = objNote.Id;
            listNoteWrappers.add( objWrapper );  
  
        }  
        return listNoteWrappers;  
  
    }  
    
  
    public class NoteWrapper {  
  		
        @AuraEnabled  
        public ID noteId;  
        @AuraEnabled  
        public String strTitle;  
        @AuraEnabled  
        public String strNotes;  
        @AuraEnabled  
        public String strCreatedDate;  
        @AuraEnabled  
        public Boolean isEdit = true;  
  
    }  
}