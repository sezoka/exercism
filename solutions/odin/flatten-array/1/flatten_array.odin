package flatten_array

Item :: union {
	i32,
	[]Item,
}

flatten :: proc(input: Item) -> []i32 {
    buff := make([dynamic]i32)
    _flatten_impl(&buff, input)
    shrink(&buff)
    return buff[:]
}

_flatten_impl :: proc(buff: ^[dynamic]i32, input: Item) {
    switch v in input {
    case i32:
        append(buff, v)
    case ([]Item):
        for item in v {
            _flatten_impl(buff, item)
        }
    }
}
