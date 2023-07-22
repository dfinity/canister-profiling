import Heap "mo:base/Heap";
import Nat32 "mo:base/Nat32";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Random "random";
import O "mo:base/Order";

actor {
    var map = Heap.Heap<Nat32>(Nat32.compare);
    let rand = Random.new(null, 42);

    stable var stable_map : Heap.Tree<Nat32> = null;

    system func preupgrade() {
        stable_map := map.share();
    };
    system func postupgrade() {
        map.unsafeUnshare(stable_map);
    };
    
    public func generate(size: Nat32) : async () {
        let rand = Random.new(?size, 1);
        map := Heap.fromIter(rand, Nat32.compare);
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
            let k = Option.get<Nat32>(rand.next(), 0);
            map.put(k);
        }
    };
    public func batch_remove(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            map.deleteMin();
        }
    };
}
