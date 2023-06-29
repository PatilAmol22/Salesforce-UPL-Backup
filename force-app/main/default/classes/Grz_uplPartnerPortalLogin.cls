global class Grz_uplPartnerPortalLogin implements Auth.LoginDiscoveryHandler {
    
    global PageReference login(String identifier, String startUrl, Map<String, String> requestAttributes) {
        if (identifier != null && isValidEmail(identifier)) {
            List<User> users = [SELECT Id FROM User WHERE Email = :identifier AND IsActive = TRUE];
            if (!users.isEmpty() && users.size() == 1) {
                List<TwoFactorMethodsInfo> verifiedInfo = [SELECT HasUserVerifiedEmailAddress FROM TwoFactorMethodsInfo WHERE UserId = :users[0].Id];
                if ((!verifiedInfo.isEmpty() && verifiedInfo[0].HasUserVerifiedEmailAddress == true)) {
                    return discoveryResult(users[0], Auth.VerificationMethod.EMAIL, startUrl, requestAttributes);
                } else {
                    return discoveryResult(users[0], Auth.VerificationMethod.PASSWORD, startUrl, requestAttributes);
                }
            } else {
                throw new Auth.LoginDiscoveryException('No unique user found. User count=' + users.size());
            }
        }
        if (identifier != null) {
            String formattedSms = identifier;
            if (formattedSms != null) {
                List<User> users = [SELECT Id FROM User WHERE MobilePhone = :formattedSms AND IsActive = TRUE];
                if (!users.isEmpty() && users.size() == 1) {
                    List<TwoFactorMethodsInfo> verifiedInfo = [SELECT HasUserVerifiedMobileNumber FROM TwoFactorMethodsInfo WHERE UserId = :users[0].Id];
                    if (!verifiedInfo.isEmpty() && verifiedInfo[0].HasUserVerifiedMobileNumber == true) {
                        return discoveryResult(users[0], Auth.VerificationMethod.SMS, startUrl, requestAttributes);
                    } else {
                        return discoveryResult(users[0], Auth.VerificationMethod.PASSWORD, startUrl, requestAttributes);
                    }
                } else {
                    throw new Auth.LoginDiscoveryException('No unique user found. User count=' + users.size());
                }
            }
        }
        if (identifier != null) {
            }
        throw new Auth.LoginDiscoveryException('Invalid Identifier');
    }
    private boolean isValidEmail(String identifier) {
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
        Pattern EmailPattern = Pattern.compile(emailRegex);
        Matcher EmailMatcher = EmailPattern.matcher(identifier);
        if (EmailMatcher.matches()) { return true; }
        else { return false; }
    }
    private PageReference getSsoRedirect(User user, String startUrl, Map<String, String> requestAttributes) {
        return null;
    }
    private PageReference discoveryResult(User user, Auth.VerificationMethod method, String startUrl, Map<String, String> requestAttributes) {
        PageReference ssoRedirect = getSsoRedirect(user, startUrl, requestAttributes);
        if (ssoRedirect != null) {
            return ssoRedirect;
        } else {
            if (method != null) {
                List<Auth.VerificationMethod> methods = new List<Auth.VerificationMethod>();
                methods.add(method);
                PageReference pwdlessRedirect;
                if(Test.isRunningTest()){
                    pwdlessRedirect = new PageReference('test');
                }else{
                    pwdlessRedirect = Site.passwordlessLogin(user.Id, methods, startUrl);
                    
                }
                if (pwdlessRedirect != null) {
                    return pwdlessRedirect;
                } else {
                    throw new Auth.LoginDiscoveryException('No Passwordless Login redirect URL returned for verification method: ' + method);
                }
            } else {
                throw new Auth.LoginDiscoveryException('No method found');
            }
        }
    }
}