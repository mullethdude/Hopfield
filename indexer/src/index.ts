import {MergedAbis, JSProcessor, fromJSProcessor} from 'ethereum-indexer-js-processor';
import contractsInfo from './contracts';

// you declare the types for your in-browswe DB.
export type Data = {
	neuro721: {from: `0x${string}`; to: `0x${string}`; id: bigint}[];
};
//Transfer(address(0), owner, id);
// event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
const TinyRogerIndexerProcessor: JSProcessor<MergedAbis<typeof contractsInfo.contracts>, Data> = {
	// version is automatically populated via version.cjs to let the browser knows to reindex on changes
	version: '__VERSION_HASH__',
	construct(): Data {
		// you return here the starting state, here an empty array for the greetings
		return {neuro721: []};
	},
	onTransfer(state, event) {
		// we lookup existing message from this user:
		const findIndex = state.neuro721.findIndex((v) => v.id === event.args.tokenId);

		// the message is one of the args of the event object (automatically populated and typed! from the abi)
		const to = event.args.to;
		const from = event.args.from

		if (findIndex === -1) {
			// if none message exists from that user we push a new entry
			state.neuro721.push({
				id: event.args.tokenId,
				to: event.args.to,
				from: event.args.from,
			});
		} else {
			// else we edit the message
			state.neuro721[findIndex].to = to;
		}
	},
};

export const createProcessor = fromJSProcessor(() => TinyRogerIndexerProcessor);
