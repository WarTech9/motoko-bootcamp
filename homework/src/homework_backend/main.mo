import Types "types";
import Buffer "mo:base/Buffer";
import Error "mo:base/Error";
import Result "mo:base/Result";
import Time "mo:base/Time";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Nat32 "mo:base/Nat32";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Text "mo:base/Text";

actor {
  public type Homework = Types.Homework;

  let diary = HashMap.HashMap<Nat, Homework>(0, Nat.equal, Nat32.fromNat);
  var lastId = 0;

  public shared func addHomework(homework: Homework): async Nat {
    diary.put(lastId, homework);
    lastId += 1;
    lastId;
  };

  public shared func getHomework(id: Nat) : async Result.Result<Homework, Text> {
    let found = diary.get(id);
    switch(found) {
      case(?h) { return #ok(h) };
      case(null) { return #err("Homework missing: " # Nat.toText(id))};
    };
  };

  public shared func updateHomework(id: Nat, homework: Homework): async Result.Result<(), Text> {
    let found = diary.get(id);
    switch(found) {
      case(?h) { 
        diary.put(id, homework);
        #ok();
       };
      case(null) { return #err("Homework missing: " # Nat.toText(id))};
    };
  };

  public shared func markAsComplete(id: Nat): async Result.Result<(), Text> {
    let found = diary.get(id);
    switch(found) {
      case(?h) { 
        let newH: Homework = {
          title = h.title;
          description = h.description;
          dueDate = h.dueDate;
          completed = true;
        };
        diary.put(id, newH);
        #ok(); };

      case(null) { #err("Missing homework" # Nat.toText(id)); };
    };
  };

  public shared func deleteHomework(id: Nat): async Result.Result<(), Text> {
    let found = diary.get(id);
    switch(found) {
      case(?h) { 
        diary.delete(id);
        #ok();
       };
      case(null) { return #err("Homework missing: " # Nat.toText(id))};
    };
  };

  public shared func getAllHomework(): async [Homework] {
    Iter.toArray(diary.vals());
  };

  public func searchHomework(searchTerm: Text): async [Homework] {
    Array.filter(Iter.toArray(diary.vals()), func (x: Homework): Bool {
      Text.contains(x.title, #text searchTerm) or
      Text.contains(x.description, #text searchTerm);
    });
  };
};
