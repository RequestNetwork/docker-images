//@ts-nocheck

import { ethers } from 'ethers'

import moment from 'moment'

import {
    RequestNetwork,
    Types,
    Utils
} from '@requestnetwork/request-client.js'

import { Web3SignatureProvider } from '@requestnetwork/web3-signature'

import { EthereumPrivateKeySignatureProvider } from '@requestnetwork/epk-signature'

// private

function requestContentData(reason = ``, dueDate = ``) {
    return {
        reason: reason || `Test Request`,
        dueDate: dueDate || moment().add(30, `days`).format(`L`)
    }
}

function requestCurrency(token = requestToken) {
    return {
        type: Types.RequestLogic.CURRENCY.ERC20,
        value: token.address,
        network: token.chain
    }
}

function requestInfo(request = requestData, token = tokenData) {
    return {
        payee: requestParty(request.payee),
        payer: requestParty(request.payer),
        currency: requestCurrency(token),
        expectedAmount: requestValue(request.value, token),
        timestamp: Utils.getCurrentTimestampInSecond()
    }
}

function requestSigner(address = ``) {
    return {
        type: Types.Identity.TYPE.ETHEREUM_ADDRESS,
        value: address
    }
}

function requestParty(address = ``) {
    return {
        type: Types.Identity.TYPE.ETHEREUM_ADDRESS,
        value: address
    }
}

function requestPaymentNetwork(
    token = requestToken,
    paymentAddress = ``,
    feeAddress = ``,
    feeAmount = ``
) {
    return {
        id: Types.Extension.PAYMENT_NETWORK_ID.ERC20_FEE_PROXY_CONTRACT,
        parameters: {
            paymentNetworkName: token.chain,
            paymentAddress,
            feeAddress: feeAddress || ethers.constants.AddressZero,
            feeAmount: feeAmount || requestValue(`0.1`, token),
        }
    }
}

function requestSignatureProvider(web3Provider = {}, privateKey = ``) {
    if (privateKey)
        return new EthereumPrivateKeySignatureProvider({ method: Types.Signature.METHOD.ECDSA, privateKey })
    if (!web3Provider)
        throw new Error(`Unable to create a signatureProvider with no provider!`)
    return new Web3SignatureProvider(web3Provider)
}

function requestValue(v = ``, token = requestToken) {
    return ethers.utils.parseUnits(v, token.decimals).toString()
}

// public

export function requestClient(requestNodeURL = ``, options = {}) {
    return new RequestNetwork({
        nodeConnectionConfig: {
            baseURL: requestNodeURL
        },
        ...options
    })
}

export function isAddress(address = ``) {
    return ethers.utils.isAddress(address)
}

export async function createRequest(
    requestNode = ``,
    request = requestData,
    token = requestToken,
    web3Provider = window.ethereum,
    privateKey = ``
) {
    let signatureProvider = requestSignatureProvider(web3Provider, privateKey)
    let c = requestClient(requestNode, { signatureProvider })
    let o = {
        requestInfo: requestInfo(request, token),
        paymentNetwork: requestPaymentNetwork(token, request.payee),
        contentData: requestContentData(request.ref),
        signer: requestSigner(request.payee),
    }
    console.log(o)
    console.log(requestNode)
    let r =  await c.createRequest({
        requestInfo: requestInfo(request, token),
        paymentNetwork: requestPaymentNetwork(token, request.payee),
        contentData: requestContentData(request.ref),
        signer: requestSigner(request.payee),
    })
    return r.waitForConfirmation()
}

export const requestData = {
    payee: ``,
    payer: ``,
    value: ``, 
    ref: ``,
    dueDate: ``
}

export function requestNodeURL(chainId = ``) {
    let chain = supportedChains
        .find(o => o.id == chainId)
    if (!chain)
        throw new Error(`Invalid chainId - ${chainId}!`)
    return `https://${chain.name}.prod.request.network/`
}

export const requestToken = {
    address: ``,
    chain: ``,
    decimals: 0
}

export async function retrieveRequest(requestNode = ``, id = ``) {
    let c = requestClient(requestNode)
    let r = await c.fromRequestId(id)
    return r.getData()
}

export const supportedChains = [
    {
        id: 100,
        name: `gnosis`
    },
    {
        id: 11155111,
        name: `sepolia`
    }
]
