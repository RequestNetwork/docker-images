<script>

    import { onMount } from 'svelte'

    import { page } from '$app/stores'

    import {
        createRequest,
        isAddress,
        requestNodeURL,
        supportedChains
    } from '$lib/request-network.js'

    import HomeButton from '$lib/home-button.svelte'

    let request = {
        data: {
            dueDate: ``,
            payee: ``,
            payer: ``,
            value: `0`,
            ref: ``
        },
        node: ``,
        token: {
            chain: `mainnet`,
            address: `0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48`,
            decimals: 6
        },
        pending: false
    }

    function requestInit() {
        request.data.dueDate = ``
        request.data.payee = ``
        request.data.payer = ``
        request.data.value = `0`
        request.data.ref = ``
        request.pending = false
        try {
            let { chainId } = $page.data
            if (!chainId || !supportedChains.find(o => o.id == chainId))
                return window.location.href = `/request/create/?chainId=${supportedChains[0].id}`
            request.node = requestNodeURL($page.data.chainId)
        } catch(e) {
            console.error(e)
            //@ts-ignore
            alert(e.message)
        }
    }

    async function requestSubmit() {
        try {
            if (!window.ethereum)
                throw new Error(`Web3 Provider not found, please enable MetaMask!`)
            if (request.pending)
                return
            request.pending = true
            let r = await createRequest(request.node, request.data, request.token)
            window.location.href = `/request/${r.requestId}?chainId=${$page.data.chainId}`
        } catch(e) {
            console.error(e)
            //@ts-ignore
            alert(e.message)
            requestInit()
        }
    }

    $: disabled = {
        get submit() {
            return !request.node
                || request.pending
                || !isAddress(request.data.payee)
                || !isAddress(request.data.payer)
                || parseFloat(request.data.value) <= 0
        }
    }

    onMount(() => {
        setTimeout(requestInit, 2e2)
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
    span.node {
        font-size: 0.9em;
        font-style: italic;
        display: block;
        text-align: center;
        margin: 1em 0;
    }
</style>

<div class="main shadow">
    <div class="form p-5">
        <div class="row">
            <div class="col-2">
                <HomeButton/>
            </div>
            <div class="col">
                <h5 class="text-center">Request Create</h5>
            </div>
            <div class="col-2"></div>
        </div>
        <span class="node">Request Node: {request.node || `Unknown`}</span>
        <div class="form-group">
            <label for="request-payee">Payee</label>
            <input
                class="form-control form-control-sm"
                id="request-payee"
                aria-describedby="request-payee-help"
                bind:value={request.data.payee}
                placeholder="0x0...">
            <small id="request-payee-help" class="form-text text-muted">Payee address</small>
        </div>
        <div class="form-group">
            <label for="request-payer">Payer</label>
            <input
                class="form-control form-control-sm"
                id="request-payer"
                aria-describedby="request-payee-help"
                bind:value={request.data.payer}
                placeholder="0x0...">
            <small id="request-payer-help" class="form-text text-muted">Payer address</small>
        </div>
        <div class="form-group">
            <label for="request-value">Value</label>
            <input
                class="form-control form-control-sm"
                id="request-value"
                aria-describedby="request-value-help"
                bind:value={request.data.value}
                placeholder="0x0...">
            <small id="request-value-help" class="form-text text-muted">Request Value</small>
        </div>
        <div class="form-group">
            <label for="request-ref">Reference</label>
            <textarea
                class="form-control form-control-sm"
                id="request-ref"
                bind:value={request.data.ref}
                rows="3"/>
        </div>
        <button
            class="btn btn-sm btn-primary w-100 mt-1"
            disabled={disabled.submit}
            on:click={requestSubmit}>
            <span>Submit</span>
        </button>
    </div>
</div>
