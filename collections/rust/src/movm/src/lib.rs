//use candid::Nat;
//use fxhash::FxHashMap;
use motoko::{ast::Literal, value::{Value, Value_}, vm_types::{Core, Limits}, shared::Share};
use motoko_proc_macro::parse_static;
use std::cell::RefCell;

thread_local! {
    static CORE: RefCell<Core> = RefCell::new(
        Core::new(
            parse_static!("
            var map = prim \"hashMapNew\" ();
            var rand_ = prim \"fastRandIterNew\" (null, 42);
            let rands = func(count) {
              prim \"fastRandIterNew\" (?count, 42)
            };")
                .clone()
        )
    );
}

fn val_from_u32(x: u32) -> Value_ {
    Value::from_literal(&Literal::Nat(format!("{}", x))).unwrap().share()
}

fn val_from_string(s: String) -> Value_ {
    Value::from_literal(&Literal::Text(s)).unwrap().share()
}

#[ic_cdk_macros::update]
fn generate(size: u32) {
    CORE.with(|core| {
        let mut core = core.borrow_mut();
        core.continue_(&Limits::none()).unwrap();
        core
            .eval_open_block(
                vec![("size", val_from_u32(size))],
                parse_static!(
                 "
                 for (x in prim \"fastRandIterNew\" (?size, 1)) {
                   let (m, _) = prim \"hashMapPut\" (map, x, prim \"natToText\" x);
                   map := m;
                 }"
                )
                .clone(),
            )
            .unwrap();
    })
}

#[ic_cdk_macros::query]
fn get_mem() -> (u128, u128, u128) {
  let size = core::arch::wasm32::memory_size(0) as u128 * 32768;
  (size, size, size)
}

#[ic_cdk_macros::update]
fn get(x: u32) -> Option<String> {
    let _r = CORE
        .with(|core| {
            let mut core = core.borrow_mut();
            core.continue_(&Limits::none()).unwrap();
            core.eval_open_block(
                vec![("x", val_from_u32(x))],
                parse_static!("prim \"hashMapGet\" (map, x)").clone(),
            )
        })
        .unwrap();
    None
}

#[ic_cdk_macros::update]
fn put(k: u32, v: String) {
    CORE.with(|core| {
        let mut core = core.borrow_mut();
        core.continue_(&Limits::none()).unwrap();
        core.eval_open_block(
            vec![("k", val_from_u32(k)), ("v", val_from_string(v))],
            parse_static!(
                "
                 let (m, _) = prim \"hashMapPut\" (map, k, v);
                 map := m"
            )
            .clone(),
        )
    })
    .unwrap();
}

#[ic_cdk_macros::update]
fn remove(x: u32) {
    CORE.with(|core| {
        (core.borrow_mut()).continue_(&Limits::none()).unwrap();
        (core.borrow_mut()).eval_open_block(
            vec![("x", val_from_u32(x))],
            parse_static!(
                "
                 let (m, _) = prim \"hashMapRemove\" (map, x);
                 map := m"
            )
            .clone(),
        )
    })
    .unwrap();
}

#[ic_cdk_macros::update]
fn batch_get(n: u32) {
    CORE.with(|core| {
        (core.borrow_mut()).continue_(&Limits::none()).unwrap();
        (core.borrow_mut()).eval_open_block(
            vec![("size", val_from_u32(n))],
            parse_static!(
                "
                 let j = rands(size);
                 for (x in j) {
                   let _ = prim \"hashMapGet\" (map, x);
                 }"
            )
            .clone(),
        )
    })
    .unwrap();
}

#[ic_cdk_macros::update]
fn batch_put(n: u32) {
    CORE.with(|core| {
        (core.borrow_mut()).continue_(&Limits::none()).unwrap();
        (core.borrow_mut()).eval_open_block(
            vec![("size", val_from_u32(n))],
            parse_static!(
                "
                 let j = rands(size);
                 for (x in j) {
                   let s = prim \"natToText\" x;
                   let (m, _) = prim \"hashMapPut\" (map, x, s);
                   map := m;
                 }"
            )
            .clone(),
        )
    })
    .unwrap();
}

#[ic_cdk_macros::update]
fn batch_remove(n: u32) {
    CORE.with(|core| {
        (core.borrow_mut()).continue_(&Limits::none()).unwrap();
        (core.borrow_mut()).eval_open_block(
            vec![("size", val_from_u32(n))],
            parse_static!(
                "
                 let j = rands(size);
                 for (x in j) {
                   let (m, _) = prim \"hashMapRemove\" (map, x);
                   map := m;
                 }"
            )
            .clone(),
        )
    })
    .unwrap();
}
