package circular_buffer

// Complete the Buffer data structure.
Buffer :: struct {
    data: []int,
    len: int,
    cursor: int,
}

Error :: enum {
	None,
	BufferEmpty,
	BufferFull,
	Unimplemented,
}

new_buffer :: proc(capacity: int) -> Buffer {
	return Buffer{
        data = make([]int, capacity),
        len = 0,
    }
}

destroy_buffer :: proc(b: ^Buffer) {
    delete(b.data)
    b^ = {}
}

clear :: proc(b: ^Buffer) {
    b.len = 0
    b.cursor = 0
}

read :: proc(b: ^Buffer) -> (int, Error) {
    if b.len != 0 {
        begin_cursor := b.cursor - b.len
        if begin_cursor < 0 {
            begin_cursor += len(b.data)
        }
        data := b.data[begin_cursor]
        b.len -= 1
        return data, .None
    } else {
        return 0, .BufferEmpty
    }
}

write :: proc(b: ^Buffer, value: int) -> Error {
    if b.len != len(b.data) {
        b.data[b.cursor] = value
        b.cursor = (b.cursor + 1) % len(b.data)
        b.len += 1
        return .None
    } else {
        return .BufferFull
    }
}

overwrite :: proc(b: ^Buffer, value: int) {
    if b.len != len(b.data) {
        write(b, value)
    } else {
        b.data[b.cursor] = value
        b.cursor = (b.cursor + 1) % len(b.data)
    }
}
