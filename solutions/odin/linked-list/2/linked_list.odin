package linked_list

import "base:runtime"

List :: struct {
    head: ^Node,
    tail: ^Node,
    len: int,
}

Node :: struct {
    value: int,
    next: ^Node,
    prev: ^Node,
}

Error :: enum {
	None,
	Empty_List,
	Unimplemented,
}

// Create a new list containing 'elements'.
new_list :: proc(elements: ..int) -> List {
    list: List
    for element in elements {
        push(&list, element)
    }
	return list
}

// Deallocate the list
destroy_list :: proc(l: ^List) {
    for l.len != 0 {
        pop(l)
    }
}

// Insert a value at the head of the list.
unshift :: proc(l: ^List, value: int) {
    node := new(Node)
    node.value = value
    if l.len == 0 {
        l.tail = node
    } else {
        node.next = l.head
        l.head.prev = node
    }
    l.head = node
    l.len += 1
}

// Add a value to the tail of the list
push :: proc(l: ^List, value: int) {
    node := new(Node)
    node.value = value
    if l.len == 0 {
        l.head = node
    } else {
        node.prev = l.tail
        l.tail.next = node
    }
    l.tail = node
    l.len += 1
}

// Remove and return the value at the head of the list.
shift :: proc(l: ^List) -> (int, Error) {
    if l.len == 0 {
        return {}, .Empty_List
    } else  {
        head := l.head
        val := head.value
        l.head = head.next
        free(head)
        l.len -= 1
        return val, .None
    }
}

// Remove and return the value at the tail of the list.
pop :: proc(l: ^List) -> (int, Error) {
    if l.len == 0 {
        return {}, .Empty_List
    } else {
        tail := l.tail
        if l.len == 1 {
            l.head = nil
            l.tail = nil
        } else {
            l.tail = l.tail.prev
        }
        val := tail.value
        free(tail)
        l.len -= 1
        return val, .None
    }
}

// Reverse the elements in the list (in-place).
reverse :: proc(l: ^List) {
    len := l.len
    buff := make([]int, len)
    defer runtime.delete(buff)
    for i in 0..<len {
        v, _ := pop(l)
        buff[i] = v
    }
    for val in buff {
        push(l, val)
    }
}

// Returns the number of elements in the list
count :: proc(l: List) -> int {
    return l.len
}

// Delete (only) the first element from the list with the given value.
// If the value is not in the list, do nothing.
delete :: proc(l: ^List, value: int) {
    for node := l.head; node != nil; node = node.next {
        if node.value == value {
            node := node
            if l.len == 1 {
                l.head = nil
                l.tail = nil
            } else {
                if node.prev == nil {
                    l.head = node.next
                    node.next.prev = nil
                } else {
                    node.prev.next = node.next
                }
                if node.next == nil {
                    l.tail = node.prev
                    node.prev.next = nil
                } else {
                    node.next.prev = node.prev
                }
            }
            free(node)
            l.len -= 1
            return
        }
    }
}
