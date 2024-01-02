import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import TrieMap "mo:base/TrieMap";
import Option "mo:base/Option";
import A "account";

shared (msg) actor class MotoCoin(coinName: Text, coinSymbol: Text) {

  private let owner = msg.caller;
  private let ledger = TrieMap.TrieMap<A.Account, Nat>(A.accountsEqual, A.accountsHash);
  private var supply = 0;
  private let _n = coinName;
  private let _s = coinSymbol;

  public func name(): async Text {
    coinName;
  };

  public func symbol(): async Text {
    coinSymbol;
  };

  public func totalSupply(): async Nat {
    supply;
  };

  public func balanceOf(account: A.Account): async Nat {
    _balance(account);
  };

  private func _balance(account: A.Account): Nat {
    Option.get(ledger.get(account), 0);
  };

  public shared (msg) func transfer(to: A.Account, amount: Nat): async Result.Result<(), A.AccountError> {
    let sender: A.Account = {
      owner = msg.caller;
      subaccount = null;
    };
    let senderBalance = _balance(sender);
    if (senderBalance < amount) {
      return #err(#InsufficientBalacne("Balance = " # debug_show(senderBalance) # ", amount = " # debug_show(amount)));
    };
    let receiverBalance = _balance(to);
    ledger.put(sender, senderBalance - amount);
    ledger.put(to, receiverBalance + amount);
    #ok();
  };

  public func airdrop(): async Result.Result<(), Text> {
    #ok();
  };

  public shared(msg) func mint(to: A.Account, amount: Nat): async Result.Result<(), A.AccountError> {
    if (msg.caller != owner) {
      return #err(#NotAuthorized("Caller not owner"));
    };
    _mint(to, amount);
  };

  private func _mint(to: A.Account, amount: Nat): Result.Result<(), A.AccountError> {
    supply += amount;
    let accountBalance = _balance(to);
    ledger.put(to, accountBalance + amount);
    #ok();
  }
};
