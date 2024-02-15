import { queryString } from '$lib/url.js'

export function load({ params = { id: `` } }) {
    let chainId = queryString(`chainId`)
    return { chainId, requestId: params.id }
}
