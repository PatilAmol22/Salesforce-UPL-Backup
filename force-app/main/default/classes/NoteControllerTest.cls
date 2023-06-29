@isTest
public class NoteControllerTest {
    private static testMethod void unit1(){
        
        Id RecordId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('Hannaford_General_Query').getRecordTypeId();
		case cse = new case();
        cse.Subject = 'test'; 
        cse.recordTypeId = RecordId;
        cse.SuppliedEmail ='test@test.com';
        insert cse;
        
        String notesText = 'This is notes';
        ContentNote objCntNote = new ContentNote();
        objCntNote.Title = 'Test';
        objCntNote.Content = Blob.valueOf(notesText);
        insert objCntNote; 
        
        ContentDocumentLink objCntDocLink = new ContentDocumentLink();
        objCntDocLink.LinkedEntityId = cse.Id;
        objCntDocLink.ContentDocumentId = objCntNote.Id;
        objCntDocLink.shareType = 'V';
        insert objCntDocLink;
        
        NoteController.fetchNotes(cse.Id);
        
    }
}