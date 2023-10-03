use ic_stable_structures::StableMinHeap;
use std::cell::RefCell;
use std::cmp::Reverse;
use utils::{Memory, Random};

thread_local! {
    static MAP: RefCell<StableMinHeap<Reverse<u64>, Memory>> = RefCell::new(StableMinHeap::init(utils::get_upgrade_memory()).unwrap());
    static RAND: RefCell<Random> = RefCell::new(Random::new(None, 42));
}

#[ic_cdk::init]
fn init() {
    utils::profiling_init();
}

#[ic_cdk::post_upgrade]
fn post_upgrade() {
    MAP.with(|map| drop(map.borrow()));
}

#[ic_cdk::update]
fn generate(size: u32) {
    let rand = Random::new(Some(size), 1);
    let iter = rand.map(Reverse);
    MAP.with(|map| {
        let mut map = map.borrow_mut();
        for x in iter {
            map.push(&x).unwrap();
        }
    });
}

#[ic_cdk::query]
fn get_mem() -> (u128, u128, u128) {
    utils::get_upgrade_mem_size()
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
                map.push(&Reverse(k)).unwrap();
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
