// Subscriber

actor Subscriber {

  type Counter = {
    topic : Text;
    value : Nat;
  };

  var count: Nat = 0;

  type Subscribe = shared ({topic:Text; callback: shared ({topic:Text; value:Nat}) -> async ()}) -> async ();

  public func init(cid: Text, topic0 : Text) : async () {
    let Publisher : actor { subscribe : Subscribe } = actor(cid);
    await Publisher.subscribe({
      topic = topic0;
      callback = updateCount;
    });
  };

  public func idle() : async () {
  };

  public func updateCount(counter : Counter) : async () {
    count += counter.value;
  };

  public query func getCount() : async Nat {
    count;
  };
}
