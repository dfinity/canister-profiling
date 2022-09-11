import Heap "mo:base/Heap";
import Nat32 "mo:base/Nat32";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Random "random";
import O "mo:base/Order";

actor {
    func compare(x: (Nat32, Text), y: (Nat32, Text)) : O.Order = Nat32.compare(x.0, y.0);
    var map = Heap.Heap<(Nat32, Text)>(compare);
    let rand = Random.new(null, 42);

    stable var stable_map : Heap.Tree<(Nat32, Text)> = null;

    system func preupgrade() {
        stable_map := map.share();
    };
    system func postupgrade() {
        map.unsafeUnshare(stable_map);
    };
    
    public func generate(size: Nat) : async () {
        let rand = Random.new(?size, 1);
        let iter = Iter.map<Nat32, (Nat32, Text)>(rand, func x = (x, debug_show x));
        map := Heap.fromIter(iter, compare);
    };
    public func get() : async ?(Nat32, Text) {
        map.removeMin();
    };
    public func put(k : Nat32, v : Text) : async () {
        map.put((k, v));
    };
    public func remove() : async () {
        map.deleteMin()
    };
    public query func get_mem() : async (Nat,Nat,Nat) {
        Random.get_memory()
    };    
    public func batch_get(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            let _ = (Option.get<Nat32>(rand.next(), 0), "");
            ignore map.removeMin();
        }
    };
    public func batch_put(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            let k = Option.get<Nat32>(rand.next(), 0);
            map.put((k, debug_show k));
        }
    };
    public func batch_remove(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            let _ = (Option.get<Nat32>(rand.next(), 0), "");            
            map.deleteMin();
        }
    };
}
