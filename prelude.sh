function install(wasm, args, cycle) {
  let id = call ic.provisional_create_canister_with_cycles(record { settings = null; amount = cycle });
  let S = id.canister_id;
  let _ = call ic.install_code(
    record {
      arg = args;
      wasm_module = gzip(wasm);
      mode = variant { install };
      canister_id = S;
    }
  );
  S
};

function upgrade(id, wasm, args) {
  call ic.install_code(
    record {
      arg = args;
      wasm_module = gzip(wasm);
      mode = variant { upgrade };
      canister_id = id;
    }
  );
};

function uninstall(id) {
  call ic.stop_canister(record { canister_id = id });
  call ic.delete_canister(record { canister_id = id });
};

function get_memory(cid) {
  let _ = call ic.canister_status(record { canister_id = cid });
  _.memory_size
};

let mo_config = record { start_page = 16; page_limit = 1024 };
let rs_config = record { start_page = 1; page_limit = 1024 };
