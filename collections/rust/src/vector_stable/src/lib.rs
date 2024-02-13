use ic_stable_structures::StableVec;
use std::cell::RefCell;
use utils::Memory;

thread_local! {
    static MAP: RefCell<StableVec<u64, Memory>> = RefCell::new(StableVec::init(utils::get_upgrade_memory()).unwrap());
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
    MAP.with(|map| {
        let map = map.borrow_mut();
        for _ in 0..size {
            map.push(&42).unwrap();
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
        let map = map.borrow();
        for idx in 0..n {
            let _ = map.get(idx as u64);
        }
    })
}

#[ic_cdk::update]
fn batch_put(n: u32) {
    MAP.with(|map| {
        let map = map.borrow_mut();
        for _ in 0..n {
            map.push(&42).unwrap();
        }
    })
}

#[ic_cdk::update]
fn batch_remove(n: u32) {
    MAP.with(|map| {
        let map = map.borrow_mut();
        for _ in 0..n {
            map.pop();
        }
    })
}
