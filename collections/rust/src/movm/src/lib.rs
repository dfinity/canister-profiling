//use candid::Nat;
//use fxhash::FxHashMap;
use motoko::{ast::Literal, value::Value, vm_types::{Core, Limits}};
use motoko_proc_macro::parse_static;
use std::cell::RefCell;

thread_local! {
    static CORE: RefCell<Core> = RefCell::new(
        Core::new(
            parse_static!("
            var map = prim \"hashMapNew\" ();
            var rand_ = prim \"fastRandIterNew\" (null, 42);
            rands = func(count){
              var c = 0;
              { next = func() {
                 if (cs == count) {
                   null
                 } else {
                   c := c + 1;
                   let (n, i) = prim \"fastRandIterNext\" rand_;
                   rand_ := i;
                   n
                 }
                }
              }
            };")
                .clone()
        )
    );
}

fn val_from_u32(x: u32) -> Value {
    Value::from_literal(Literal::Nat(format!("{}", x))).unwrap()
}

fn val_from_string(s: String) -> Value {
    Value::from_literal(Literal::Text(s)).unwrap()
}

#[ic_cdk_macros::update]
fn generate(size: u32) {
    CORE.with(|core| {
        (core.borrow_mut()).continue_(&Limits::none()).unwrap();
        (core.borrow_mut())
            .eval_open_block(
                vec![("size", val_from_u32(size))],
                parse_static!(
                 "
                 var i = prim \"fastRandIterNew\" (?size, 1);
                 var j = {
                   next = func () {
                     let (n, i_) = prim \"fastRandIterNext\" i;
                     i := i_;
                     n
                   }
                 };
                 for (x in j) {
                   let s = prim \"natToText\" x;
                   let (m, _) = prim \"hashMapPut\" (map, x, s);
                   map := m;
                 }"
                )
                .clone(),
            )
            .unwrap();
    })
}

#[ic_cdk_macros::update]
fn get(x: u32) -> Option<String> {
    let _r = CORE
        .with(|core| {
            (core.borrow_mut()).continue_(&Limits::none()).unwrap();
            (core.borrow_mut()).eval_open_block(
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
        (core.borrow_mut()).continue_(&Limits::none()).unwrap();
        (core.borrow_mut()).eval_open_block(
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
