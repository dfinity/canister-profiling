mod env;
mod heartbeat;
mod service;
mod types;

use crate::env::CanisterEnvironment;
use crate::service::BasicDaoService;
use crate::types::*;
use ic_cdk::{init, post_upgrade, pre_upgrade, query, update};
use std::cell::RefCell;
use std::collections::HashMap;

use candid::{Decode, Encode, Principal};
use ic_stable_structures::{
    memory_manager::{MemoryId, MemoryManager},
    writer::Writer,
    DefaultMemoryImpl, Memory,
};

thread_local! {
    static SERVICE: RefCell<BasicDaoService> = RefCell::default();
    static MEMORY_MANAGER: RefCell<MemoryManager<DefaultMemoryImpl>> =
        RefCell::new(MemoryManager::init(DefaultMemoryImpl::default()));
}

const PROFILING: MemoryId = MemoryId::new(100);

const UPGRADES: MemoryId = MemoryId::new(0);

#[init]
fn init(init_state: BasicDaoStableStorage) {
    ic_cdk::setup();
    let memory = MEMORY_MANAGER.with(|m| m.borrow().get(PROFILING));
    memory.grow(32);
    let mut init_service = BasicDaoService::from(init_state);
    init_service.env = Box::new(CanisterEnvironment {});

    SERVICE.with(|service| *service.borrow_mut() = init_service);
}

#[pre_upgrade]
fn pre_upgrade() {
    let bytes = SERVICE.with(|serv| {
        Encode!(
            &serv.borrow().accounts,
            &serv.borrow().proposals,
            &serv.borrow().next_proposal_id,
            &serv.borrow().system_params
        )
        .unwrap()
    });
    let len = bytes.len() as u32;
    let mut memory = MEMORY_MANAGER.with(|m| m.borrow().get(UPGRADES));
    let mut writer = Writer::new(&mut memory, 0);
    writer.write(&len.to_le_bytes()).unwrap();
    writer.write(&bytes).unwrap();
}
#[post_upgrade]
fn post_upgrade() {
    let memory = MEMORY_MANAGER.with(|m| m.borrow().get(UPGRADES));
    let mut len_bytes = [0; 4];
    memory.read(0, &mut len_bytes);
    let len = u32::from_le_bytes(len_bytes) as usize;
    let mut bytes = vec![0; len];
    memory.read(4, &mut bytes);
    let (accounts, proposals, next_proposal_id, system_params) =
        Decode!(&bytes, HashMap<Principal, Tokens>, HashMap<u64, Proposal>, u64, SystemParams)
            .unwrap();
    SERVICE.with(|cell| {
        *cell.borrow_mut() = BasicDaoService {
            env: Box::new(CanisterEnvironment {}),
            accounts,
            proposals,
            next_proposal_id,
            system_params,
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
