import Principal "mo:base/Principal";

module Types {
    public type PrincipalProfile = (Principal, StudentProfile);
    public type StudentProfile = {
        name: Text;
        team: Text;
        graduate: Bool;
    };

    public type ProfileError = {
        #ProfileExists;
        #Unauthorized;
        #NotFound;
    }
}
