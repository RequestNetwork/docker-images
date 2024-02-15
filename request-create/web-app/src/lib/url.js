export function queryString(param = ``) {
    return new URLSearchParams(document.location.search)
        .get(param)
}
