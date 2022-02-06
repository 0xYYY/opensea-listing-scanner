# OpenSea Listing Scanner

## Requirements
1. An RPC node, e.g. Alchemy or Infura.
2. [foundry](https://github.com/gakonst/foundry)
3. [ripgrep](https://github.com/BurntSushi/ripgrep)
4. [sd](https://github.com/chmln/sd)
5. [jq](https://github.com/stedolan/jq)
6. [xcv](https://github.com/BurntSushi/xsv/issues/267)

## How to run?
Change the `RPC` in the script to your node. And set the parameters (`COLLECTION_NAME`,
`CONTRACT_ADDRESS`, `MAX_SUPPLY`) of the NFT collection that you want to scan. Then run `./scan.sh`.

## Why not just use OpenSea UI and why Rarible API?
See [this](https://twitter.com/rarible/status/1478606417120481285). Also, Rarible API is free to
use without the need of an API key.

## Why so many dependencies, and mostly Rust alternatives of some existing program?
Those are the tools I prefer to use on my dev machine. Maybe you should to. Because Rust good.
And if you are already using some of them, here are [100](https://www.wezm.net/v2/posts/2020/100-rust-binaries/) [more](https://www.wezm.net/v2/posts/2020/100-rust-binaries/page2/). :)

## Reference
- [Rarible OpenAPI](https://github.com/rarible/ethereum-openapi)

## License
MIT
