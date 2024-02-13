import Vector "mo:vector";
import Iter "mo:base/Iter";
import Random "random";
import Nat64 "mo:base/Nat64";
import Option "mo:base/Option";
import Profiling "../../../utils/motoko/Profiling";

actor {
    stable let profiling = Profiling.init();
    
    stable let buffer : Vector.Vector<Nat64> = Vector.new();
    
    public func generate(n: Nat) : async () {
        Vector.clear(buffer);
        for (_ in Iter.range(1, n)) {
            Vector.add<Nat64>(buffer, 42);
        }
    };
    public query func get_mem() : async (Nat,Nat,Nat) {
        Random.get_memory()
    };
    public func batch_get(n : Nat) : async () {
        let size = Vector.size(buffer);
        for (idx in Iter.range(1, n)) {
            ignore Vector.get(buffer, idx);
        }
    };
    public func batch_put(n : Nat) :  async () {
        for (_ in Iter.range(1, n)) {
            Vector.add<Nat64>(buffer, 42);
        }
    };
    public func batch_remove(n : Nat) : async () {
        for (_ in Iter.range(1, n)) {
            ignore Vector.removeLast(buffer);
        }
    };
}
