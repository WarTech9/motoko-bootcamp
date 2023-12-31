import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Principal "mo:base/Principal";
import Iter "mo:base/Iter";
import Order "mo:base/Order";
import Types "types";

actor MessageWall {

  public type Content = Types.Content;
  public type Message = Types.Message;
  public type MessageError = Types.MessageError;

  private let wall = HashMap.HashMap<Nat, Message>(0, Nat.equal, Nat32.fromNat);
  private var lastId = 0;

  public shared ({ caller }) func writeMessage(c : Content) : async Nat {
    let message : Message = {
      id = lastId;
      votes = 0;
      content = c;
      creator = caller;
    };
    wall.put(lastId, message);
    lastId += 1;
    lastId;
  };

  public shared query func getMessage(id : Nat) : async Result.Result<Message, MessageError> {
    let message = wall.get(id);
    switch (message) {
      case (?m) {
        return #ok(m);
      };
      case (null) {
        #err(#NotFound(id));
      };
    };
  };

  public shared ({ caller }) func updateMessage(id : Nat, newContent : Content) : async Result.Result<(), MessageError> {
    let message = wall.get(id);
    switch(message) {
      case(?m) {
        if (m.creator != caller) {
          #err(#NotAuthorized(Principal.toText(caller)));
        } else {
          let newMessage: Message = {
            id = id;
            votes = m.votes;
            creator = m.creator;
            content = newContent;
          };
          wall.put(id, newMessage);
          #ok();
        };
       };
      case(null) { 
        #err(#NotFound(id));
      };
    };
  };

  public func deleteMessage(id : Nat) : async Result.Result<(), MessageError> {
    let message = wall.get(id);
    switch(message) {
      case(?m) { 
        wall.delete(id);
        #ok();
       };
      case(null) { 
        #err(#NotFound(id));
      };
    };
  };

  public shared ({ caller }) func upVote(id : Nat) : async Result.Result<(), MessageError> {
    let message = wall.get(id);
    switch(message) {
      case(?m) {
        if (m.creator == caller) {
          #err(#BadRequest("Can not vote for your own message"));
        } else {
          let newMessage: Message = {
            id = id;
            votes = m.votes + 1;
            creator = m.creator;
            content = m.content;
          };
          wall.put(id, newMessage);
        #ok();
        }
      };
      case(null) { 
        #err(#NotFound(id));
      };
    };
  };

  public shared ({ caller }) func downVote(id : Nat) : async Result.Result<(), MessageError> {
    let message = wall.get(id);
    switch(message) {
      case(?m) {
        if (m.creator == caller) {
          #err(#BadRequest("Can not vote for your own message"));
        } else {
          let votes = if (m.votes == 0) 0 else m.votes - 1;
          let newMessage: Message = {
            id = id;
            votes = votes;
            creator = m.creator;
            content = m.content;
          };
          wall.put(id, newMessage);
          #ok();
        }
      };
      case(null) { 
        #err(#NotFound(id));
      };
    };
  };

  public query func getAllMessages() : async [Message] {
    Iter.toArray(wall.vals());
  };

  public query func getAllMessagesRanked() : async [Message] {
    Iter.toArray(
      Iter.sort(wall.vals(), func(a: Message, b: Message): Order.Order {
        let result = if (a.votes > b.votes) {
          #greater;
        } else if (a.votes < b.votes) {
          #less;
        } else {
          #equal;
        };
        result;
      })
    );
  };
};
