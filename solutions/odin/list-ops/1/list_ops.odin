package list_ops

// All procedures use prefix `ls_` to avoid conflict
// with Odin built-in `append()` and `map`.

// Returns a new list with 'other' appended to 'l'.
ls_append :: proc(l: []$T, other: []T) -> []T {
    new_list := make([]T, len(l) + len(other))
    insert_pos := 0
    for item in l {
        new_list[insert_pos] = item
        insert_pos += 1
    }
    for item in other {
        new_list[insert_pos] = item
        insert_pos += 1
    }
	return new_list
}

// Creates a new list by concatenating all the argument lists.
ls_concat :: proc(lists: [][]$T) -> []T {
    total_len := 0
    for list in lists {
        total_len += len(list)
    }

    new_list := make([]T, total_len)
    insert_pos := 0
    for list in lists {
        for item in list {
            new_list[insert_pos] = item
            insert_pos += 1
        }
    }
	return new_list
}

// Returns a list with only the elements for which the
// predicate 'pred' is true.
ls_filter :: proc(l: []$T, pred: proc(element: T) -> bool) -> []T {
    buff := make([dynamic]T, len(l))
    insert_pos := 0
    for item in l {
        if pred(item) {
            buff[insert_pos] = item
            insert_pos += 1
        }
    }
	shrink(&buff, insert_pos)
    return buff[:]
}

// Returns the length of the list.
ls_length :: proc(l: []$T) -> int {
    return len(l)
}

// Returns a list containing the result of calling 'transform'
// on each element of the list.
ls_map :: proc(l: []$T, transform: proc(element: T) -> $U) -> []U {
    buff := make([]T, len(l))
    for item, i in l {
        buff[i] = transform(item)
    }
    return buff[:]
}

// Returns the result of applying repeatively  'acc = fn(acc, e)' for each
// element e of the list (left-to-right), initializing 'acc' with 'initial_value'.
ls_foldl :: proc(l: []$T, initial_value: T, fn: proc(acc, element: T) -> $U) -> U {
    acc := initial_value
    for item, i in l {
        acc = fn(acc, item)
    }
    return acc
}

// Returns the result of applying repeatively  'acc = fn(acc, e)' for each
// element e of the list (right-to-left), initializing 'acc' with 'initial_value'.
ls_foldr :: proc(l: []$T, initial_value: T, fn: proc(acc, element: T) -> $U) -> U {
    acc := initial_value
    #reverse for item, i in l {
        acc = fn(acc, item)
    }
    return acc
}

// Returns a list with all the elements of the list in
// reverse order.
ls_reverse :: proc(l: []$T) -> []T {
    buff := make([]T, len(l))
    for item, i in l {
        buff[len(l) - 1 - i] = item
    }
    return buff[:]
}
