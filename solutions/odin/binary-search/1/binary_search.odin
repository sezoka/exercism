package binary_search

find :: proc(haystack: []$T, needle: T) -> (index: int, found: bool) #optional_ok {
    left := 0
    right := len(haystack)

    for left < right {
        center := (left + right) / 2
        if haystack[center] == needle {
            return center, true
        } else if needle < haystack[center] {
            right = center
        } else if haystack[center] < needle {
            left = center + 1
        }
    }
    
    return 0, false
}
