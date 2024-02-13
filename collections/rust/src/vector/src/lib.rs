use std::cell::RefCell;

thread_local! {
    static MAP: RefCell<Vec<u64>> = RefCell::default();
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
    let value: Vec<u64> = utils::restore_stable();
    MAP.with(|cell| *cell.borrow_mut() = value);
}

#[ic_cdk::update]
fn generate(size: u32) {
    MAP.with(|map| {
        let mut map = map.borrow_mut();
        map.clear();
        for _ in 0..size {
            map.push(42);
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
        for idx in 0..n {
            let _ = map.get(idx as usize);
        }
    })
}

#[ic_cdk::update]
fn batch_put(n: u32) {
    MAP.with(|map| {
        let mut map = map.borrow_mut();
        for _ in 0..n {
            map.push(42);
        }
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
