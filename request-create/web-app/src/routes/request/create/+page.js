import { queryString } from '$lib/url.js'

export function load() {
    let chainId = queryString(`chainId`)
    return { chainId }
}
