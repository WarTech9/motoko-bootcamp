import Int "mo:base/Int";
import Float "mo:base/Float";

actor Calculator {
  public query func greet(name : Text) : async Text {
    return "Hello, " # name # "!";
  };

  var counter = 0.0;

  public func add(x: Float) : async Float {
    counter := counter + x;
    counter;
  };

  public func sub(x: Float): async Float {
    counter := counter - x;
    counter;
  };

  public func mul(x: Float): async Float {
    counter := counter * x;
    counter;
  };

  public func div(x: Float): async Float {
    if (x == 0) {
      return 0;
    };
    counter := counter / x;
    counter;
  };

  public func reset(): async () {
    counter := 0.0;
  };

  public func power(x: Float): async Float {
    counter := counter ** x;
    counter;
  };

  public func sqrt(): async Float {
    counter := counter ** 0.5;
    counter;
  };

  public query func see(): async Float {
    counter;
  };

  public query func floor(): async Int {
    Float.toInt(Float.floor(counter));

  }
};
