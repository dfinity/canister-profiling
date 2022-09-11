// Publisher
import List "mo:base/List";

actor Publisher {

  type Counter = {
    topic : Text;
    value : Nat;
  };

  type Subscriber = {
    topic : Text;
    callback : shared Counter -> async ();
  };

  stable var subscribers = List.nil<Subscriber>();

  public func idle() : async () {
  };

  public func subscribe(subscriber : Subscriber) : async () {
    subscribers := List.push(subscriber, subscribers);
  };

  public func publish(counter : Counter) : async () {
    for (subscriber in List.toArray(subscribers).vals()) {
      if (subscriber.topic == counter.topic) {
        await subscriber.callback(counter);
      };
    };
  };
}
