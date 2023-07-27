import Sha256 "mo:sha2/Sha256";
import Sha512 "mo:sha2/Sha512";
import Principal "mo:base/Principal";
import { tabulate } "mo:base/Array";
import { fromNat = Nat8fromNat } "mo:base/Nat8";
import { toNat; fromNat = Nat64fromNat } "mo:base/Nat64";

actor {
    let ACCOUNT_SEPERATOR : [Nat8] = [10,97,99,99,111,117,110,116,45,105,100];
    let SUBACCOUNT_ZERO : [Nat8] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    
    public func sha256(blob: Blob) : async Blob {
        Sha256.fromBlob(#sha256, blob);
    };
    public func sha512(blob: Blob) : async Blob {
        Sha512.fromBlob(#sha512, blob);
    };
    public func principalToAccount(id: Principal) : async Blob {
        let digest = Sha256.Digest(#sha224);
        digest.writeArray(ACCOUNT_SEPERATOR);
        digest.writeBlob(Principal.toBlob id);
        digest.writeArray(SUBACCOUNT_ZERO);
        digest.sum();
    };
    func nat64_to_be(x : Nat64) : [Nat8] {
        tabulate<Nat8>(8, func i = x >> (Nat64fromNat (7-i) * 8) & 0xff |> toNat _ |> Nat8fromNat _);
    };
    public func principalToNeuron(id: Principal, nonce: Nat64) : async Blob {
        let digest = Sha256.Digest(#sha256);
        digest.writeArray([12]);
        digest.writeArray([110,101,117,114,111,110,45,115,116,97,107,101]);
        digest.writeBlob(Principal.toBlob id);
        digest.writeArray(nat64_to_be nonce);
        digest.sum();
    };
}
