export function stringCapitalise(str = ``) {
    return str.length > 1
        ? [str[0].toUpperCase(), str.slice(1).toLowerCase()].join(``)
        : str.toUpperCase()
}

export function stringTruncate(str = ``, len = 8, join = `...`) {
    return [
        str.slice(0, len),
        str.slice(-len)
    ].join(join)
}
