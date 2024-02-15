<script>
    import { onMount } from 'svelte'

    import { page } from '$app/stores'

    import { JsonView } from '@zerodevx/svelte-json-view'

    import { Circle } from 'svelte-loading-spinners'
  
    import {
        requestNodeURL,
        retrieveRequest,
        supportedChains
    } from '$lib/request-network.js'

    import { stringTruncate } from '$lib/string'

    import HomeButton from '$lib/home-button.svelte'

    let state = {
        request: {
            data: {},
            node: ``
        }
    }

    async function requestInit() {
        try {
            let { chainId, requestId } = $page.data
            if (!chainId || !supportedChains.find(o => o.id == chainId))
                return window.location.href = `/request/create/?chainId=${supportedChains[0].id}`
            state.request.node = requestNodeURL($page.data.chainId)
            state.request.data = await retrieveRequest(request.node, requestId)
        } catch(e) {
            console.error(e)
            //@ts-ignore
            alert(e.message)
        }
    }

    $: request = {
        get data() {
            return state.request.data
        },
        get id() {
            return stringTruncate($page.data.requestId, 16)
        },
        get node() {
            return state.request.node
        },
        get ready() {
            return Object.keys(request.data).length > 0
        }
    }

    onMount(() => {
        requestInit()
    })

</script>

<style>
    div.main {
        width: calc(100vw - 5em);
        margin: 2em auto;
        background-color: white;
    }
    span.node {
        font-size: 0.9em;
        font-style: italic;
        display: block;
        text-align: center;
        margin: 1em 0;
    }
    div.json {
        font-family: monospace;
        font-size: 0.8em;
        border: 1px solid lightgray;
        margin-top: 2em;
        padding: 1em 2em;
    }
    div.loading {
        height: 10em;
    }
    div.loading {
        display: flex;
        justify-content: center;
        margin-top: 10em;
    }
</style>

<div class="main shadow">
    <div class="form p-5">
        <div class="row">
            <div class="col-2">
                <HomeButton/>
            </div>
            <div class="col">
                <h5 class="text-center">Request Id: {request.id}</h5>
            </div>
            <div class="col-2"></div>
        </div>
        <span class="node">Request Node: {request.node}</span>
        {#if !request.ready}
            <div class="loading">
                <Circle size="40" color="rgb(0,204,142)" unit="px"/>
            </div>
        {/if}
        {#if request.ready}
            <div class="json">
                <JsonView json={request.data}/>
            </div>
        {/if}
    </div>
</div>
