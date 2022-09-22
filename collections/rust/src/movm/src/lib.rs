use candid::Nat;
use fxhash::FxHashMap;
use motoko::{
    ast::Delim,
    check::parse,
    value::Value,
    vm_types::{Core, Interruption, Limit, Limits},
};
use std::cell::RefCell;

struct Random {
    state: u32,
    size: Option<u32>,
    ind: u32,
}
impl Random {
    pub fn new(size: Option<u32>, seed: u32) -> Self {
        Random {
            state: seed,
            size,
            ind: 0,
        }
    }
}
impl Iterator for Random {
    type Item = u32;
    fn next(&mut self) -> Option<Self::Item> {
        if let Some(size) = self.size {
            self.ind += 1;
            if self.ind > size {
                return None;
            }
        }
        self.state = self.state * 48271 % 0x7fffffff;
        Some(self.state)
    }
}

thread_local! {
    static CORE: RefCell<Core> = RefCell::new(Core::new(Delim::new()));
}

/*
fn core_eval(prog: &str) -> Result<Value, Interruption> {
    CORE.with(|core| (*core.borrow_mut()).eval(prog))
}

*/

#[ic_cdk_macros::update]
fn generate(size: u32) {
    CORE.with(|core| 
              
              (*core.borrow_mut())
              .step(&Limits::none()).unwrap() 
    );
    todo!()
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
