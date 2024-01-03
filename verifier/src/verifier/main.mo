import Result "mo:base/Result";
import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import T "types";

actor Verifier {

  type ProfileError = T.ProfileError;

  private let profileStore = HashMap.HashMap<Principal, T.StudentProfile>(
    0, 
    Principal.equal, 
    Principal.hash
  );

  public shared (msg) func addMyProfile(profile: T.StudentProfile): async Result.Result<(), T.ProfileError> {
    let existingProfile = profileStore.get(msg.caller);
    switch existingProfile {
      case (?p) {
        #err(#ProfileExists);
      };
      case (null) {
        profileStore.put(msg.caller, profile);
        #ok();
      };
    }
  };

  public shared query (msg) func seeProfile(p: Principal): async Result.Result<T.StudentProfile, ProfileError> {
    let existingProfile = profileStore.get(msg.caller);
    switch existingProfile {
      case (?p) {
        #ok(p);
      };
      case (null) {
        #err(#NotFound);
      };
    }
  };

  public shared ({ caller }) func updateMyProfile(profile: T.StudentProfile): async Result.Result<(), ProfileError> {
    let existingProfile = profileStore.get(caller);
    switch(existingProfile) {
      case(?p) { 
        profileStore.put(caller, profile);
        #ok();
       };
      case(null) { 
        #err(#NotFound);
      };
    };
  };

  public shared ({ caller }) func deleteMyProfile(): async Result.Result<(), ProfileError> {
    let existingProfile = profileStore.get(caller);
    switch(existingProfile) {
      case(?p) { 
        profileStore.delete(caller);
        #ok();
       };
      case(null) {
        #err(#NotFound);
       };
    };
  };

  public func getAllProfiles(): async [T.PrincipalProfile] {
    Iter.toArray(profileStore.entries());
  };

  public func getProfilesOnTeam(team: Text): async [T.PrincipalProfile] {
    Array.filter(
      Iter.toArray(profileStore.entries()), func ((k: Principal, v: T.StudentProfile)) : Bool {
        v.team == team
      }
    );
   };
};
