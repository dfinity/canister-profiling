mod env;
mod heartbeat;
mod service;
mod types;

use crate::env::CanisterEnvironment;
use crate::service::{BasicDaoService, StableState};
use crate::types::*;
use ic_cdk::{init, post_upgrade, pre_upgrade, query, update};
use std::cell::RefCell;

thread_local! {
    static SERVICE: RefCell<BasicDaoService> = RefCell::default();
}

#[init]
fn init(init_state: BasicDaoStableStorage) {
    ic_cdk::setup();
    utils::profiling_init();
    let mut init_service = BasicDaoService::from(init_state);
    init_service.env = Box::new(CanisterEnvironment {});

    SERVICE.with(|service| *service.borrow_mut() = init_service);
}

#[pre_upgrade]
fn pre_upgrade() {
    SERVICE.with(|serv| {
        let serv = serv.borrow();
        let v = StableState {
            accounts: serv.accounts.clone(),
            proposals: serv.proposals.clone(),
            next_proposal_id: serv.next_proposal_id,
            system_params: serv.system_params.clone(),
        };
        utils::save_stable(&v);
    });
}
#[post_upgrade]
fn post_upgrade() {
    let v: StableState = utils::restore_stable();
    SERVICE.with(|cell| {
        *cell.borrow_mut() = BasicDaoService {
            env: Box::new(CanisterEnvironment {}),
            accounts: v.accounts,
            proposals: v.proposals,
            next_proposal_id: v.next_proposal_id,
            system_params: v.system_params,
        }
    });
}

#[query]
fn get_system_params() -> SystemParams {
    SERVICE.with(|service| service.borrow().system_params.clone())
}

#[update]
fn transfer(args: TransferArgs) -> Result<(), String> {
    SERVICE.with(|service| service.borrow_mut().transfer(args))
}

#[query]
fn account_balance() -> Tokens {
    SERVICE.with(|service| service.borrow().account_balance())
}

#[query]
fn list_accounts() -> Vec<Account> {
    SERVICE.with(|service| service.borrow().list_accounts())
}

#[update]
fn submit_proposal(proposal: ProposalPayload) -> Result<u64, String> {
    SERVICE.with(|service| service.borrow_mut().submit_proposal(proposal))
}

#[query]
fn get_proposal(proposal_id: u64) -> Option<Proposal> {
    SERVICE.with(|service| service.borrow().get_proposal(proposal_id))
}

#[query]
fn list_proposals() -> Vec<Proposal> {
    SERVICE.with(|service| service.borrow().list_proposals())
}

#[update]
fn vote(args: VoteArgs) -> Result<ProposalState, String> {
    SERVICE.with(|service| service.borrow_mut().vote(args))
}

#[update]
fn update_system_params(payload: UpdateSystemParamsPayload) {
    SERVICE.with(|service| service.borrow_mut().update_system_params(payload))
}
