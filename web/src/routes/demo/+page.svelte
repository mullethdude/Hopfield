<script lang="ts">
	import ConnectButton from '$lib/web3/ConnectButton.svelte';
	import Web3ConnectionUI from '$lib/web3/Web3ConnectionUI.svelte';
	import {account, connection, network, contracts} from '$lib/web3';
	import {status, state} from '$lib/blockchain/state/State';
	import Nfts from '$lib/components/nfts/Nfts.svelte';

	let tokenID: string;
	let messageToSend: string;



</script>

<div class="navbar bg-base-100">
	<div class="navbar-start">
		<span class="normal-case text-xl">Demo</span>
	</div>
	<div class="navbar-center hidden lg:flex" />
	<div class="navbar-end">
		<ConnectButton />
	</div>
</div>

<symbol id="icon-spinner6" viewBox="0 0 32 32">
	<path
		d="M12 4c0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.209-1.791 4-4 4s-4-1.791-4-4zM24.719 16c0 0 0 0 0 0 0-1.812 1.469-3.281 3.281-3.281s3.281 1.469 3.281 3.281c0 0 0 0 0 0 0 1.812-1.469 3.281-3.281 3.281s-3.281-1.469-3.281-3.281zM21.513 24.485c0-1.641 1.331-2.972 2.972-2.972s2.972 1.331 2.972 2.972c0 1.641-1.331 2.972-2.972 2.972s-2.972-1.331-2.972-2.972zM13.308 28c0-1.487 1.205-2.692 2.692-2.692s2.692 1.205 2.692 2.692c0 1.487-1.205 2.692-2.692 2.692s-2.692-1.205-2.692-2.692zM5.077 24.485c0-1.346 1.092-2.438 2.438-2.438s2.438 1.092 2.438 2.438c0 1.346-1.092 2.438-2.438 2.438s-2.438-1.092-2.438-2.438zM1.792 16c0-1.22 0.989-2.208 2.208-2.208s2.208 0.989 2.208 2.208c0 1.22-0.989 2.208-2.208 2.208s-2.208-0.989-2.208-2.208zM5.515 7.515c0 0 0 0 0 0 0-1.105 0.895-2 2-2s2 0.895 2 2c0 0 0 0 0 0 0 1.105-0.895 2-2 2s-2-0.895-2-2zM28.108 7.515c0 2.001-1.622 3.623-3.623 3.623s-3.623-1.622-3.623-3.623c0-2.001 1.622-3.623 3.623-3.623s3.623 1.622 3.623 3.623z"
	/>
</symbol>

<section class="py-8 px-4">
	Mint 25 NEURONs To make it works
	{#if $connection.state !== 'Connected'}
		Please connect
	{:else if $network.notSupported}
		Wrong network
	{:else if $status.state !== 'Loaded'}
		<div>Loading Messages...</div>
	{/if}
	
	<span class="px-2">

		
		<svg width="600" height="600" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
		{#each $state.neuro721 as transf, index}
			
			{#if transf.from==="0x0000000000000000000000000000000000000000"  && transf.to.toLowerCase()=== $account.address}
			
				{#if transf.id}
				
			
				<Nfts  tokenID={"0x"+transf.id.toString(16)} />
		
				{:else}
				{/if}	
			{/if} 
		{:else}
		{/each}
	</svg>
	

</section>

<div class="inline-block form-control w-full max-w-xs">
	<label for="message" class="label !inline">
		<span class="label-text">Say something to the world</span>
	</label>
	<input
		id="message"
		type="text"
		bind:value={messageToSend}
		placeholder="Type here"
		class="!inline input input-bordered w-full max-w-xs"
	/>
</div>
<button
on:click={() =>
	contracts.execute(async ({contracts, connection}) => {
		let nu = 1n;	
		contracts.Neuro721.write.mint(["0x"+nu.toString(16)]);
	})}
	class="m-1 btn btn-primary">Mint  NEURON </button
>

<button
on:click={() =>
	contracts.execute(async ({contracts, connection}) => {
		contracts.Neuro721.write.trainer(["0x19","0x0e5294e","0x0e210c4"]);
	})}
	class="m-1 btn btn-primary">Train NEuron</button
>
<!--contracts.Neuro721.write.trainer(["0x0f","0x43f2","0x7e3f"]);-->

<button
on:click={() =>
	contracts.execute(async ({contracts, connection}) => {
		contracts.Neuro721.write.initneural(["0x19","0x0e210c4"]);
	})}
	class="m-1 btn btn-primary">INIT NEuron</button
>

<button
on:click={() =>
	contracts.execute(async ({contracts, connection}) => {
		contracts.Neuro721.write.test(["0x19","0x0001106"]);
	})}
	class="m-1 btn btn-primary">TEST IT</button
>

<!--  0x7e3f ==O in 5x3   0x0e5294e in 5x5  -->
<!--  0x43f2 ==1 in 5x3   in 5x5 0x0e210c4-->
<Web3ConnectionUI />
