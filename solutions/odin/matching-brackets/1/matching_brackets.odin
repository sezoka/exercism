package matching_brackets

is_balanced :: proc(input: string) -> bool {
    stack := make([dynamic]rune, 0, len(input), context.temp_allocator)

    for bracket in input {
        switch bracket {
        case '[', '(', '{':
            switch bracket {
            case '[': append(&stack, ']')
            case '(': append(&stack, ')')
            case '{': append(&stack, '}')
            }
        case ']', ')', '}':
            if len(stack) == 0 || (pop(&stack) != bracket) {
                return false
            }
        }
    }

	return len(stack) == 0
}
