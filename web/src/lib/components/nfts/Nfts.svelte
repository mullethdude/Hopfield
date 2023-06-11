<script lang="ts">

	import {account, connection, network, contracts} from '$lib/web3';

	import {onDestroy, onMount} from 'svelte';
	import { tokentransient, colorscheme } from '$lib/components/nfts/Value';

    export let tokenID: string;

let imgURI: number| undefined;
let iframeURI: number | undefined;


function wait(sec: number): Promise<void> {
  return new Promise((resolve) => {
    setTimeout(resolve, sec * 1000);
  });
}

function refresh() {

    contracts.execute(async ({contracts, connection}) => {
		contracts.Neuro721.read["tokenURI"]([tokenID], {blockTag:"latest"}).then((uri) => {
		return fetch(uri)
		  .then((response) => response.json())
		  .then((json) => {
			  imgURI = parseInt(json.state);
			  tokentransient.set(parseInt(json.state))
			  console.log("STATE")
			  console.log(tokenID);
			  console.log(json.state);
			  iframeURI = parseInt(json.description);
			  
			});
		});
	});
}



let timeout: NodeJS.Timeout;
function refreshAgainAndAgain() {
  refresh();
  timeout = setTimeout(refreshAgainAndAgain, 1000);
}
onMount(() => {
  refreshAgainAndAgain();
});
onDestroy(() => {
  if (timeout) {
    clearTimeout(timeout);
    timeout = undefined;
  }
});

function neurontosvg( ){

}
</script>

{#if imgURI && iframeURI}
<!--<img src={imgURI} alt={`${contractAddress}:${tokenID}`} />-->
<!--<iframe srcdoc="<h1>hi</h1><script>console.log('hey');console.log(window.ethereum)</script>"></iframe>-->

<!-- {parseInt(iframeURI)}
	<p> {iframeURI}state of this neuron {get(tokentransient)} </p> -->
	
	{#if imgURI===1}
	<rect x={((iframeURI-1)%5)*10} y={10+10*Math.floor((iframeURI-1)/5)} width="10" height="10" fill="#000"/>
	<!--<Wb iframeURI/>-->

	{:else}
	<rect x={((iframeURI-1)%5)*10} y={10+10*Math.floor((iframeURI-1)/5)} width="10" height="10" fill="#0aa"/>
	<!--<Bb iframeURI/>-->

	{/if} 


{:else}

{/if}
