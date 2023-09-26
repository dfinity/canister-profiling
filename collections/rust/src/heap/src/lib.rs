use candid::{CandidType, Deserialize};
use std::cell::RefCell;
use std::cmp::Reverse;
use std::collections::BinaryHeap;
use utils::Random;

// TODO: remove this after we impl Reverse in Candid
#[derive(Deserialize, Eq, Ord, PartialEq, PartialOrd)]
struct RevU64(Reverse<u64>);
impl CandidType for RevU64 {
    fn _ty() -> candid::types::Type {
        u64::ty()
    }
    fn idl_serialize<S: candid::types::Serializer>(&self, serializer: S) -> Result<(), S::Error> {
        serializer.serialize_nat64(self.0 .0)
    }
}
impl From<u64> for RevU64 {
    fn from(v: u64) -> Self {
        Self(Reverse(v))
    }
}

thread_local! {
    static MAP: RefCell<BinaryHeap<RevU64>> = RefCell::default();
    static RAND: RefCell<Random> = RefCell::new(Random::new(None, 42));
}

#[ic_cdk::init]
fn init() {
    utils::profiling_init();
}
#[ic_cdk::pre_upgrade]
fn pre_upgrade() {
    MAP.with(|map| utils::save_stable(&map));
}
#[ic_cdk::post_upgrade]
fn post_upgrade() {
    let value: BinaryHeap<RevU64> = utils::restore_stable();
    MAP.with(|cell| *cell.borrow_mut() = value);
}

#[ic_cdk::update]
fn generate(size: u32) {
    let rand = Random::new(Some(size), 1);
    let iter = rand.map(|x| x.into());
    MAP.with(|map| {
        let mut map = map.borrow_mut();
        *map = iter.collect::<BinaryHeap<RevU64>>();
    });
}

#[ic_cdk::query]
fn get_mem() -> (u128, u128, u128) {
    utils::get_mem()
}

#[ic_cdk::update]
fn batch_get(n: u32) {
    MAP.with(|map| {
        let mut map = map.borrow_mut();
        for _ in 0..n {
            map.pop();
        }
    })
}

#[ic_cdk::update]
fn batch_put(n: u32) {
    MAP.with(|map| {
        let mut map = map.borrow_mut();
        RAND.with(|rand| {
            let mut rand = rand.borrow_mut();
            for _ in 0..n {
                let k = rand.next().unwrap();
                map.push(k.into());
            }
        })
    })
}

#[ic_cdk::update]
fn batch_remove(n: u32) {
    MAP.with(|map| {
        let mut map = map.borrow_mut();
        for _ in 0..n {
            map.pop();
        }
    })
}
