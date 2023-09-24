#!ic-repl
load "../prelude.sh";

import fake = "2vxsx-fae" as "motoko/.dfx/local/canisters/dip721_nft/constructor.did";

// Setup initial account
identity alice;
identity bob;

let motoko = wasm_profiling("motoko/.dfx/local/canisters/dip721_nft/dip721_nft.wasm", record { start_page = 16 });
let rust = wasm_profiling("rust/.dfx/local/canisters/dip721_nft/dip721_nft.wasm", record { start_page = 1 });

let file = "README.md";
output(file, "\n## DIP721 NFT\n\n| |binary_size|init|mint_token|transfer_token|upgrade|\n|--|--:|--:|--:|--:|--:|\n");

function perf(wasm, title) {
  let init = encode fake.__init_args(
    record {
      logo = record {
        logo_type = "image/png";
        data = "";
      };
      name = "My DIP721";
      symbol = "DFXB";
      maxLimit = 10;
    }
  );
  let NFT = install(wasm, init, null);
  call NFT.__get_cycles();
  output(file, stringify("|", title, "|", wasm.size(), "|", _, "|"));
  // mint
  let _ = call NFT.mintDip721(
    bob,
    vec {
      record {
        purpose = variant { Rendered };
        data = blob "hello";
        key_val_data = vec {
          record { "description"; variant { TextContent = "The NFT metadata can hold arbitrary metadata" } };
          record { "tag"; variant { TextContent = "anime" } };
          record { "contentType"; variant { TextContent = "text/plain" } };
          record { "locationType"; variant { Nat8Content = 4 } };
        }
      }
    }
  );
  let svg = stringify(title, "_nft_mint.svg");
  output(file, stringify("[", __cost__, "](", svg, ")|"));
  flamegraph(NFT, "NFT.mintDip721", svg);
  // transfer tokens
  let _ = call NFT.transferFromDip721(bob, alice, 0);
  let svg = stringify(title, "_nft_transfer.svg");
  output(file, stringify("[", __cost__, "](", svg, ")|"));
  flamegraph(NFT, "NFT.transferFromDip721", svg);
  // upgrade
  upgrade(NFT, wasm, init);
  let svg = stringify(title, "_upgrade.svg");
  flamegraph(NFT, "NFT.upgrade", svg);
  output(file, stringify("[", _, "](", svg, ")|\n"));
};

perf(motoko, "Motoko");
perf(rust, "Rust");
