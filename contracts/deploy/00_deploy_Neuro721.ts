import {execute} from 'rocketh';
import 'rocketh-deploy-proxy';
import {context} from './_context';

export default execute(
	context,
	async ({deployViaProxy, accounts, artifacts}) => {
		const contract = await deployViaProxy(
			'Neuro721',
			{
				account: accounts.deployer,
				artifact: artifacts.Neuro721,
				args: [''],
			},
			{
				owner: accounts.deployer,
			}
		);
	},
	
	{tags: ['Neuro721', 'Neuro721_deploy']}
);


// const {deployments, getNamedAccounts} = hre;
// const {deploy} = deployments;

// const {deployer} = await getNamedAccounts();

// const dev = !hre.network.live;

// await deploy('SimpleERC721', {
//   from: deployer,
//   log: true,
//   proxy: dev,
// });
// };
// export default func;
// func.tags = ['SimpleERC721'];
