#!ic-repl
load "../../prelude.sh";

import fake = "2vxsx-fae" as ".dfx/local/canisters/basic_dao/basic_dao.did";

// Setup initial account
identity alice;
identity bob;
identity cathy;
identity dory;
identity genesis;

let file = "README.md";
output(file, "| |transfer_token|submit_proposal|vote_proposal|\n|--|--|--|--|\n");

let init = encode fake.__init_args(
  record {
    accounts = vec {
      record { owner = genesis; tokens = record { amount_e8s = 1_000_000_000_000 } };
      record { owner = alice; tokens = record { amount_e8s = 100 } };
      record { owner = bob; tokens = record { amount_e8s = 200 } };
      record { owner = cathy; tokens = record { amount_e8s = 300 } };
    };
    proposals = vec {};
    system_params = record {
      transfer_fee = record { amount_e8s = 100 };
      proposal_vote_threshold = record { amount_e8s = 100 };
      proposal_submission_deposit = record { amount_e8s = 100 };
    };
  }
);

let DAO = install(wasm_profiling(".dfx/local/canisters/basic_dao/basic_dao.wasm"), init, null);
call DAO.__get_cycles();

// transfer tokens
let _ = call DAO.transfer(record { to = dory; amount = record { amount_e8s = 400 } });
output(file, stringify("|motoko|", __cost__, "|"));
flamegraph(DAO, "DAO.transfer", "motoko_transfer");

// alice makes a proposal
identity alice;
let update_transfer_fee = record { transfer_fee = opt record { amount_e8s = 10_000 } };
call DAO.submit_proposal(
  record {
    canister_id = DAO;
    method = "update_system_params";
    message = encode DAO.update_system_params(update_transfer_fee);
  },
);
let alice_id = _.ok;
output(file, stringify(__cost__, "|"));
flamegraph(DAO, "DAO.submit_proposal", "motoko_submit_proposal");

// voting
identity bob;
call DAO.vote(record { proposal_id = alice_id; vote = variant { yes } });
output(file, stringify(__cost__, "|\n"));
flamegraph(DAO, "DAO.vote", "motoko_vote");
