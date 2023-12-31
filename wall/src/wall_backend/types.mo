import Text "mo:base/Text";
import Principal "mo:base/Principal";
module {

    public type Content = {
        #Text: Text;
        #Image: Blob;
        #Video: Blob;
    };

    public type Message = {
        id: Nat;
        votes: Int;
        content: Content;
        creator: Principal;
    };

    public type MessageError = {
        #NotFound: Nat;
        #NotAuthorized : Text;
        #BadRequest: Text;
    }
};


