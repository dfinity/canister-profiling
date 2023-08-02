import CertTree "mo:ic-certification/CertTree";
import Blob "mo:base/Blob";
import { tabulate } "mo:base/Array";
import { range } "mo:base/Iter";
import Utils "utils";

actor {
    var counter : Nat8 = 0;
    let cert_store : CertTree.Store = CertTree.newStore();
    let tree = CertTree.Ops(cert_store);

    public func generate(size : Nat) : async () {
        let word = Utils.Word(1);
        for (i_ in range(1, size)) {
            let w = Blob.fromArray(word.gen());
            tree.put([w], w);
        }
    };
    public query func get_mem() : async (Nat, Nat, Nat) {
        Utils.get_memory();
    };
    public func inc() : async () {
        counter += 1;
        let val = Blob.fromArray([counter]);
        tree.put(["counter"], val);
    };
    public func witness() : async (Blob, Blob) {
        let root = tree.treeHash();
        let witness = tree.reveal(["counter"]);
        (root, tree.encodeWitness(witness))
    };
}
