import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Random "random";
import Nat64 "mo:base/Nat64";
import Option "mo:base/Option";

actor {
    var buffer = Buffer.Buffer<Nat64>(0);
    
    public func generate(n: Nat) : async () {
        buffer.clear();
        for (_ in Iter.range(1, n)) {
            buffer.add(42);
        }
    };
    public query func get_mem() : async (Nat,Nat,Nat) {
        Random.get_memory()
    };
    public func batch_get(n : Nat) : async () {
        for (idx in Iter.range(1, n)) {
            ignore buffer.get(idx);
        }
    };
    public func batch_put(n : Nat) :  async () {
        for (_ in Iter.range(1, n)) {
            buffer.add(42);
        }
    };
    public func batch_remove(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            ignore buffer.removeLast();
        }
    };
}
