<script>

    import { onMount } from 'svelte'

    import { supportedChains } from '$lib/request-network.js'

    import { stringCapitalise } from '$lib/string.js'

    let request = {
        chain: ``,
        id: ``
    }

    function requestInit() {
        request.chain = requestChains[0]
    }

    $: chain = supportedChains
        .find(o => o.name.toLowerCase() == request.chain.toLowerCase())

    function requestCreate() {
        window.location.href = `/request/create/?chainId=${chain?.id}`
    }

    function requestRetrieve() {
        window.location.href = `/request/${request.id}/?chainId=${chain?.id}`
    }

    $: disabled = {
        get retrieve() {
            return request.id.length != 66
        }
    }

    $: requestChains = supportedChains
        .map(o => stringCapitalise(o.name))

    onMount(() => {
        requestInit()
    })
</script>

<style>
    div.main {
        width: 500px;
        margin: 5em auto;
        background-color: white;
    }
    div.form-group {
        margin: 1em 0;
    }
    div.form-group label {
        margin-bottom: 0.5em;
        font-size: 0.9em;
    }
</style>

<div class="main shadow">
    <div class="form p-5">
        <h5 class="text-center">Request Network</h5>
        <div class="form-group">
            <label for="request-chain">Chain</label>
            <select
                class="form-select form-select-sm"
                id="request-chain"
                aria-describedby="request-chain-help"
                bind:value={request.chain}>
                {#each requestChains as c}
                    <option value={c}>{c}</option>
                {/each}
            </select>
            <small id="request-chain-help" class="form-text text-muted">Select storage chain</small>
        </div>
        <button
            class="btn btn-sm btn-primary w-100 mt-1"
            on:click={requestCreate}>
            <span>Create</span>
        </button>
        <hr>
        <div class="form-group">
            <label for="request-id">Request Id</label>
            <input
                class="form-control form-control-sm"
                id="request-id"
                aria-describedby="request-id-help"
                bind:value={request.id}
                placeholder="abc123...">
            <small id="request-id-help" class="form-text text-muted">Retrieve a request by id</small>
        </div>
        <button
            class="btn btn-sm btn-success w-100 mt-1"
            disabled={disabled.retrieve}
            on:click={requestRetrieve}>
            <span>Retrieve</span>
        </button>
    </div>
</div>
