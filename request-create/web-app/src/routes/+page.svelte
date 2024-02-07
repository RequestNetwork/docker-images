<script>
    import {
        RequestNetwork,
        Types,
        Utils
    } from '@requestnetwork/request-client.js'
    
    import { Web3SignatureProvider } from '@requestnetwork/web3-signature'

    import { ethers } from 'ethers'

    import moment from 'moment'

    let request = {
        payee: ``,
        payer: ``,
        value: `0`,
        ref: ``,
        pending: false
    }

    let requestValue = (v = ``, decimals = 0) =>  ethers.utils.parseUnits(v, decimals)

    function requestParty(address = ``) {
        return {
            type: Types.Identity.TYPE.ETHEREUM_ADDRESS,
            value: address
        }
    }

    function requestCurrency(address = ``, chain = ``) {
        return {
            type: Types.RequestLogic.CURRENCY.ERC20,
            value: address,
            network: chain
        }
    }

    function requestPaymentNetwork(chain = ``, paymentAddress = ``, feeAddress = ``, feeAmount = ``) {
        return {
            id: Types.Extension.PAYMENT_NETWORK_ID.ERC20_FEE_PROXY_CONTRACT,
            parameters: {
                paymentNetworkName: chain,
                paymentAddress,
                feeAddress: feeAddress || ethers.constants.AddressZero,
                feeAmount: feeAmount || requestValue(`0.1`),
            }
        }
    }

    function requestCreateObject() {
        let token = `0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48`
        let chain = `mainnet`
        let currency = requestCurrency(token, chain)
        let payee = requestParty(request.payee)
        let payer = requestParty(request.payer)
        let expectedAmount = requestValue(request.value)
        let timestamp = Utils.getCurrentTimestampInSecond()
        let requestInfo = { currency, payee, payer, expectedAmount, timestamp }
        let paymentNetwork = requestPaymentNetwork(chain, request.payee)
        let contentData = requestContentData(request.ref)
        let signer = requestSigner(request.payee)
        return {
            requestInfo,
            paymentNetwork,
            contentData,
            signer
        }
    }

    function requestContentData(reason = ``, dueDate = ``) {
        return {
            reason: reason || `Test Request`,
            dueDate: dueDate || moment().add(30, `days`).format(`L`)
        }
    }

    function requestSigner(address = ``) {
        return {
            type: Types.Identity.TYPE.ETHEREUM_ADDRESS,
            value: address
        }
    }

    async function requestSubmit() {
        try {
            if (!window.ethereum)
                throw new Error(`Web3 Provider not found, please enable MetaMask!`)
            let signatureProvider = new Web3SignatureProvider(window.ethereum)
            console.log(signatureProvider)
            let client = new RequestNetwork({
                nodeConnectionConfig: { 
                    baseURL: `https://gnosis.prod.request.network/`
                },
                signatureProvider
            })
            console.log(client)
            let requestData = requestCreateObject()
            console.log(requestData)
        } catch(e) {
            console.error(e)
            //@ts-ignore
            alert(e.message)
        }
    }

    $: disabled = {
        get submit() {
            return request.pending
                || !ethers.utils.isAddress(request.payee)
                || !ethers.utils.isAddress(request.payer)
                || parseFloat(request.value) <= 0
        }
    }
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
        <h5 class="text-center">Request Create</h5>
        <div class="form-group">
            <label for="request-payee">Payee</label>
            <input
                class="form-control form-control-sm"
                id="request-payee"
                aria-describedby="request-payee-help"
                bind:value={request.payee}
                placeholder="0x0...">
            <small id="request-payee-help" class="form-text text-muted">Payee address</small>
        </div>
        <div class="form-group">
            <label for="request-payer">Payer</label>
            <input
                class="form-control form-control-sm"
                id="request-payer"
                aria-describedby="request-payee-help"
                bind:value={request.payer}
                placeholder="0x0...">
            <small id="request-payer-help" class="form-text text-muted">Payer address</small>
        </div>
        <div class="form-group">
            <label for="request-value">Value</label>
            <input
                class="form-control form-control-sm"
                id="request-value"
                aria-describedby="request-value-help"
                bind:value={request.value}
                placeholder="0x0...">
            <small id="request-value-help" class="form-text text-muted">Request Value</small>
        </div>
        <div class="form-group">
            <label for="request-ref">Reference</label>
            <textarea
                class="form-control form-control-sm"
                id="request-ref"
                bind:value={request.ref}
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
