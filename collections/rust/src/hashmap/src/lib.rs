use fxhash::FxHashMap;
use std::cell::RefCell;
use utils::Random;

thread_local! {
    // FxHashMap uses the same std::collections::HashMap with a deterministic hasher
    static MAP: RefCell<FxHashMap<u64, u64>> = RefCell::default();
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
    let value: FxHashMap<u64, u64> = utils::restore_stable();
    MAP.with(|cell| *cell.borrow_mut() = value);
}

#[ic_cdk::update]
fn generate(size: u32) {
    let rand = Random::new(Some(size), 1);
    let iter = rand.map(|x| (x, x));
    MAP.with(|map| {
        let mut map = map.borrow_mut();
        for (k, v) in iter {
            map.insert(k, v);
        }
    });
}

#[ic_cdk::query]
fn get_mem() -> (u128, u128, u128) {
    utils::get_mem()
}

#[ic_cdk::update]
fn batch_get(n: u32) {
    MAP.with(|map| {
        let map = map.borrow_mut(); // mut to ensure get doesn't get inlined by the compiler
        RAND.with(|rand| {
            let mut rand = rand.borrow_mut();
            for _ in 0..n {
                let k = rand.next().unwrap();
                map.get(&k);
            }
        })
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
                map.insert(k, k);
            }
        })
    })
}

#[ic_cdk::update]
fn batch_remove(n: u32) {
    let mut rand = Random::new(None, 1);
    MAP.with(|map| {
        let mut map = map.borrow_mut();
        for _ in 0..n {
            let k = rand.next().unwrap();
            map.remove(&k);
        }
    })
}
