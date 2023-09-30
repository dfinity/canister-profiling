use ic_stable_structures::StableBTreeMap;
use std::cell::RefCell;
use utils::{Memory, Random};

thread_local! {
    static MAP: RefCell<StableBTreeMap<u64, u64, Memory>> = RefCell::new(StableBTreeMap::init(utils::get_upgrade_memory()));
    static RAND: RefCell<Random> = RefCell::new(Random::new(None, 42));
}

#[ic_cdk::init]
fn init() {
    utils::profiling_init();
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
        let map = map.borrow();
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
