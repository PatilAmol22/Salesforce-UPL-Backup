public class ProfileImage {
    public String profileImageUrl { get; set; }
    List<user> lstuser;
  
    public ProfileImage () {
         lstuser = [select FullPhotoUrl from User where Id =: UserInfo.getUserId()];
         profileImageUrl=lstuser[0].FullPhotoUrl; 
    }
}