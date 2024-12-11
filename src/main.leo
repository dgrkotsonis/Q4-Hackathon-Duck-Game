program q4_hackathon_mint_duck_tokens.aleo {
    // On-chain storage of an `account` map, with `address` as the key,
    // and `u64` as the value (total value of NFTs).
    mapping account: address => u64;

    // The collection of tokens this is from
    // struct TokenCollection {
    //     // Amount of editions in this Collection
    //     editions: u32,
    //     // Remaining total NFTs in this collection
    //     remaining: u64
    // }

    record token {
        // The token owner.
        owner: address,
        // The token amount.
        amount: u64,
        edition: u8,
        // collection: TokenCollection
    }

    /* Mint */

    // The function `mint_private` initializes a new record with the specified amount of tokens for the receiver.
    // TODO: Should we first call mint_private then transfer_private_to_public???
    transition mint_private(receiver: address, amount: u64, edition: u8) -> token {
        
        return token {
            owner: receiver,
            amount: amount,
            edition: edition,
        };
    }

    // The function `transfer_private_to_public` turns a specified token amount from a token record into public tokens for the specified receiver.
    // This function preserves privacy for the sender's record, however it publicly reveals the token receiver and the token amount.
    async transition transfer_private_to_public(sender: token, public receiver: address, public amount: u64) -> (token, Future) {
        // Checks the given token record has a sufficient token amount.
        // This `sub` operation is safe, and the proof will fail if an underflow occurs.
        // `difference` holds the change amount for the caller.
        let difference: u64 = sender.amount - amount;

        // Produces a token record with the change amount for the caller.
        let remaining: token = token {
            owner: sender.owner,
            amount: difference,
            edition: sender.edition
        };

        let asset_val: u64 = (5u64 - sender.edition as u64) * amount;

        // Output the sender's change record.
        // Increment the token amount publicly for the token receiver.
        return (remaining, finalize_transfer_priv_to_pub(receiver, asset_val));
    }

    async function finalize_transfer_priv_to_pub(public receiver: address, public asset_val: u64) {
        // Increments `account[receiver]` by `asset_val`.
        // If `account[receiver]` does not exist, it will be created.
        // If `account[receiver] + asset_val` overflows, `transfer_private_to_public` is reverted.
        let current_amount: u64 = Mapping::get_or_use(account, receiver, 0u64);
        Mapping::set(account, receiver, current_amount + asset_val);
    }

}
