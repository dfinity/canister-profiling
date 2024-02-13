#![allow(non_snake_case)]
use candid::Principal;
use serde_bytes::ByteBuf;
use sha2::{Digest, Sha224, Sha256};

const SUBACCOUNT_ZERO: [u8; 32] = [0; 32];
const ACCOUNT_SEPERATOR: &[u8] = b"\x0Aaccount-id";

#[ic_cdk::update]
fn sha256(blob: ByteBuf) -> ByteBuf {
    ByteBuf::from(&mut sha2::Sha256::digest(blob)[..])
}
#[ic_cdk::update]
fn sha512(blob: ByteBuf) -> ByteBuf {
    ByteBuf::from(&mut sha2::Sha512::digest(blob)[..])
}
#[ic_cdk::update]
fn principalToAccount(id: Principal) -> ByteBuf {
    let mut hash = Sha224::new();
    hash.update(ACCOUNT_SEPERATOR);
    hash.update(id.as_slice());
    hash.update(SUBACCOUNT_ZERO);
    ByteBuf::from(&mut hash.finalize()[..])
}
#[ic_cdk::update]
fn principalToNeuron(id: Principal, nonce: u64) -> ByteBuf {
    let mut data = Sha256::new();
    data.update([0x0c]);
    data.update(b"neuron-stake");
    data.update(id.as_slice());
    data.update(nonce.to_be_bytes());
    ByteBuf::from(&mut data.finalize()[..])
}
