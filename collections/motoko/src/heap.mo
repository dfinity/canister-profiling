import Heap "mo:base/Heap";
import Nat64 "mo:base/Nat64";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Random "random";
import O "mo:base/Order";
import Profiling "../../../Profiling";

actor {
    stable let profiling = Profiling.init(32);
    
    var map = Heap.Heap<Nat64>(Nat64.compare);
    stable var stableMap : Heap.Tree<Nat64> = null;
    let rand = Random.new(null, 42);

    system func preupgrade() {
        stableMap := map.share();
    };
    system func postupgrade() {
        map.unsafeUnshare(stableMap);
    };
    
    public func generate(size: Nat32) : async () {
        let rand = Random.new(?size, 1);
        // TODO: use fromIter after https://github.com/dfinity/motoko-base/issues/578
        // map := Heap.fromIter(rand, Nat64.compare);
        for (x in rand) {
            map.put(x);
        }
    };

    public query func get_mem() : async (Nat,Nat,Nat) {
        Random.get_memory()
    };    
    public func batch_get(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            ignore map.removeMin();
        }
    };
    public func batch_put(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            let k = Option.get<Nat64>(rand.next(), 0);
            map.put(k);
        }
    };
    public func batch_remove(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            map.deleteMin();
        }
    };
}
