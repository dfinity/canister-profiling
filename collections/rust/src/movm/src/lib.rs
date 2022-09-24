use candid::Nat;
use fxhash::FxHashMap;
use motoko::{
    ast::Delim,
    check::parse,
    value::Value,
    vm_types::{Core, Interruption, Limit, Limits},
};
use std::cell::RefCell;
 
thread_local! {
    static CORE: RefCell<Core> = RefCell::new(Core::new(Delim::new()));
}

#[ic_cdk_macros::update]
fn generate(size: u32) {
    let p = motoko_proc_macro::parse_static!("123");
    
    CORE.with(|core| {
        let _ = (*core.borrow_mut()).step(&Limits::none());
        *core.borrow_mut() = Core::new(p.clone())
    }
    );
/*
    let _ = core_eval(&format!(
        "
      var map = prim \"hashMapNew\" ();
      let i = prim \"fastRandIterNew\" (?{}, 1);
      var j = object {{
        next = func () {{
          let (n, i) = prim \"fastRandIterNext\" ();
          j := i;
          n
        }}
      }};
      for (x in j) {{
        map := prim \"HashMapPut\" (map, x, x);
      }}
      ",
        size
    ))
    .expect("generate");
*/
//    todo!()
}

#[ic_cdk_macros::update]
fn get(x: u32) -> Option<String> {
/*
    core_eval(&format!("prim \"hashMapGet\" (map, {})", x))
        .expect("get")
        .convert()
        .expect("not a ?Text value")
*/
todo!()
}

#[ic_cdk_macros::update]
fn put(k: u32, v: String) {
/*
    core_eval(&format!("prim \"hashMapPut\" (map, {}, {})", k, v)).expect("put");
*/
todo!()
}

#[ic_cdk_macros::update]
fn remove(x: u32) {
    // to do -- support hashMapRemove
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
