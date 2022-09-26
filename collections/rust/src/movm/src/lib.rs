use candid::Nat;
use fxhash::FxHashMap;
use motoko::{
    ast::{Delim, Literal},
    check::parse,
    value::Value,
    vm_types::{Core, Interruption, Limit, Limits},
};
use motoko_proc_macro::parse_static;
use std::cell::RefCell;

thread_local! {
    static CORE: RefCell<Core> = RefCell::new(Core::new(
        parse_static!(
            "
      var map = prim \"hashMapNew\" ();
   "
        )
        .clone()
    ));
}

fn val_from_u32(x: u32) -> Value {
    Value::from_literal(Literal::Nat(format!("{}", x))).unwrap()
}

#[ic_cdk_macros::update]
fn generate(size: u32) {
    CORE.with(|core| {
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
      }
    "
                )
                .clone(),
            )
            .unwrap();
    })
}

#[ic_cdk_macros::update]
fn get(x: u32) -> Option<String> {
    todo!()
}

#[ic_cdk_macros::update]
fn put(k: u32, v: String) {
    todo!()
}

#[ic_cdk_macros::update]
fn remove(x: u32) {
    todo!()
}

#[ic_cdk_macros::update]
fn batch_get(n: u32) {
    todo!()
}

#[ic_cdk_macros::update]
fn batch_put(n: u32) {
    todo!()
}

#[ic_cdk_macros::update]
fn batch_remove(n: u32) {
    todo!()
}
