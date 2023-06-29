public class ParseToBlobCtrl { 
    
    @Future(callout=true)
    public static void convertToBlob(String url, String fName,String recId,String communityImage, String hyrperlinkURL,String description,String descriptionForNews){
        System.debug('url in parse class '+url);
        Matcher imgMatcher = Pattern.compile( '<img(.+?)>' ).matcher( url );
        
        // iterate each image tag found
        while ( imgMatcher.find() ) {
            
            // get the image tag html
            String imageTag = imgMatcher.group();
            System.debug( 'imageTag=' + imageTag );
            
            // get the value of the src attribute
            // the leading space is significant to avoid other attributes like data-cke-saved-src
            String imageURL = imageTag.substringBetween( ' src="', '"' );
            System.debug( 'imageURL=' + imageURL );
            
            // if url contained parameters they might be html escaped, unescape them
            // or, more conservatively, replace '&amp;' with '&'
            String decodedURL = imageURL.unescapeHtml4();
            System.debug( 'decodedURL=' + decodedURL );
            
            // note, as of API 34.0 or later, getContent() is considered an http callout
            // so take that into consideration for your unit tests and governor limits
            // https://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/apex_System_PageReference_getContent.htm
            PageReference page = new PageReference( decodedURL );
            
            
            
            Blob b ;//= page.getContent();
            if(Test.isRunningTest()) { 
                b = blob.valueOf('Unit.Test');
            } else {
                b = page.getContent();
            }
            
            
            
            
            
            ContentVersion v = new ContentVersion();
            v.versionData = b;
            v.title = fName;
            v.pathOnClient ='foo.png';
            System.debug('communityImage '+communityImage);
            v.Community_Images__c =communityImage;
            System.debug('hyrperlinkURL after creating '+hyrperlinkURL);
            v.Hyperlink_URL__c =hyrperlinkURL;
            v.Description__c =description;
            System.debug('descriptionForNews for News  '+descriptionForNews);
            v.Description_For_News__c = descriptionForNews;
            insert v;
            
            System.debug( 'Content version Id is  ' +v.Id);
            
            //Get Content Documents
            Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:v.Id].ContentDocumentId;
            System.debug('Succes conDocId '+conDocId);
            //Create ContentDocumentLink 
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = recId;
            cdl.ContentDocumentId = conDocId;
            cdl.shareType = 'V';
            cdl.Visibility = 'AllUsers';
            Insert cdl;
            
        }
    }
    
    
}