import {derived} from 'svelte/store';
import {state, syncing} from './State';
import {accountData} from '$lib/web3';
import {getAddress} from 'viem';


import {logs} from 'named-logs';
const logger = logs(`pending-state`);

/**
 * Here we are deriving a new state from the indexer state and the account data
 * This allow us to optimistically update the UI with pending messages from the user
 *
 */
export const pendingState = derived([syncing, state, accountData.data], ([$syncing, $state, $accountData]) => {
	const pendingNeuro721: {from: `0x${string}`; to: `0x${string}`; id: bigint; pending: boolean}[] = $state.neuro721.map((v) => ({
		id: v.id,
		from: v.from,
		to: v.to,
		pending: false,
	}));

	logger.info(`num greetings: ${$state.neuro721.length}`);

	const accountIndexes: {[from: `0x${string}`]: number} = {};
	for (let i = 0; i < pendingNeuro721.length; i++) {
		accountIndexes[pendingNeuro721[i].from] = i;
		logger.info(`${i}: ${pendingNeuro721[i].from}`);
	}

	const pendingMessages: {[from: `0x${string}`]: bigint} = {};

	const pendingHashes: {[hash: string]: boolean} = {};
	if ($syncing.lastSync && $syncing.lastSync.unconfirmedBlocks) {
		for (const block of $syncing.lastSync.unconfirmedBlocks) {
			for (const event of block.events) {
				pendingHashes[event.transactionHash] = true;
			}
		}
	}

	if ($accountData) {
		for (const hash of Object.keys($accountData.actions)) {
			const action = $accountData.actions[hash as `0x${string}`];
			if (action.final) {
				// in this case, the indexer will pick the correct state once synced up
				// we can ignore the pending tx
				// the tx-broadcaster should stop caring about this one
				continue;
			}
			if (action.status === 'Failure') {
				// tx failed so we can ignore it
				// TODO? this failure can be picked up elsewhere to let the user know
				//  but we could also modify the PendingState type to include information here
				continue;
			}

			if (pendingHashes[hash]) {
				// if tx is already considered in the index, we can skip
				continue;
			}
			switch (action.inclusion) {
				case 'Cancelled':
					// tx cancelled, we ignore it
					continue;
				case 'BeingFetched':
					// TODO add to state that loading is still going for txs....
					// tx state is loading
					continue;
				case 'Included':
				case 'NotFound':
				case 'Broadcasted':
				// else we consider it
			}
			if (action.tx.metadata && typeof action.tx.metadata === 'object' && 'message' in action.tx.metadata) {
				const fromAccount = getAddress(action.tx.from);
				pendingMessages[fromAccount] = action.tx.metadata.message as bigint;
			}
		}
	}

	for (const fro of Object.keys(pendingMessages)) {
		const from = fro as `0x${string}`;
		const i = accountIndexes[from];
		if (isNaN(i)) {
			logger.info(`new: ${from}`);
			pendingNeuro721.push({
				from,
				to:from,
				id: pendingMessages[from],
				pending: true,
			});
		} else {
			logger.info(`${pendingNeuro721[i].id} and ${pendingMessages[from]}`);
			// remove that when `if (indexer.includes(hash)) {continue;}` is implemented
			if (pendingNeuro721[i].id != pendingMessages[from]) {
				pendingNeuro721[i].id = pendingMessages[from];
				pendingNeuro721[i].pending = true;
			}
		}
	}

	return {
		neuro721: pendingNeuro721,
	};
});

if (typeof window !== 'undefined') {
	(window as any).pendingState = pendingState;
}
