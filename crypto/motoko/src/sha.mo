import Sha256 "mo:sha2/Sha256";
import Sha512 "mo:sha2/Sha512";
import Principal "mo:base/Principal";
import Utils "utils";

actor {
    let ACCOUNT_SEPERATOR : Blob = "\0Aaccount-id";
    let SUBACCOUNT_ZERO : [Nat8] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    
    public func sha256(blob: Blob) : async Blob {
        Sha256.fromBlob(#sha256, blob);
    };
    public func sha512(blob: Blob) : async Blob {
        Sha512.fromBlob(#sha512, blob);
    };
    public func principalToAccount(id: Principal) : async Blob {
        let digest = Sha256.Digest(#sha224);
        digest.writeBlob(ACCOUNT_SEPERATOR);
        digest.writeBlob(Principal.toBlob id);
        digest.writeArray(SUBACCOUNT_ZERO);
        digest.sum();
    };

    public func principalToNeuron(id: Principal, nonce: Nat64) : async Blob {
        let digest = Sha256.Digest(#sha256);
        digest.writeBlob("\0c");
        digest.writeBlob("neuron-stake");
        digest.writeBlob(Principal.toBlob id);
        digest.writeArray(Utils.nat64_to_be nonce);
        digest.sum();
    };
}
