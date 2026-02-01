package forth

import "core:strings"
import "core:strconv"

Error :: enum {
	None,
	Cant_Nest_Definitions,
	Cant_Redefine_Compilation_Word,
	Cant_Redefine_Number,
	Divide_By_Zero,
	Incomplete_Definition,
	Stack_Underflow,
	Unknown_Word,
	Unimplemented,
}

Builtin :: enum {
    Define_Start,
    Define_End,
}

Token :: union {
    int,
    string,
    Builtin,
}

evaluate :: proc(input: ..string) -> (output: []int, error: Error) {
    stack: [dynamic]int

    tokens: [dynamic]Token
    defer delete(tokens)

    defines: map[string][]Token
    defer delete(defines)

    tokenize :: proc(src: string, tokens: ^[dynamic]Token) -> Error {
        src_iter := src
        for str_token in strings.split_iterator(&src_iter, " ") {
            if str_token == "-" {
                append(tokens, str_token)
            } else if str_token == ":" {
                append(tokens, Builtin.Define_Start)
            } else if str_token == ";" {
                append(tokens, Builtin.Define_End)
            } else if str_token[0] == '-' || ('0' <= str_token[0] && str_token[0] <= '9') {
                parsed, ok := strconv.parse_int(str_token)
                if !ok do return .Unimplemented
                append(tokens, parsed)
            } else {
                append(tokens, str_token)
            }
        }
        return .None
    }

    for commands in input {
        lowered := strings.to_lower(commands, allocator=context.temp_allocator)
        err := tokenize(lowered, &tokens)
        if err != .None {
            return stack[:], err
        }
    }

    in_define_block := false
    define_block_start: int
    for i := 0; i < len(tokens); i += 1 {
        switch v in tokens[i] {
        case int:
            if in_define_block do continue
            append(&stack, v)
        case string:
            def_tokens, exists := defines[v]
            if exists {
                if in_define_block {
                    ordered_remove(&tokens, i)
                    inject_at(&tokens, i, ..def_tokens)
                } else {
                    append(&tokens, ..def_tokens)
                }
            } else {
                if in_define_block do continue
                switch v {
                case "+":
                    if 2 <= len(stack) {
                        b := pop(&stack)
                        a := pop(&stack)
                        append(&stack, a + b)
                    } else {
                        return stack[:], .Stack_Underflow
                    }
                case "-":
                    if 2 <= len(stack) {
                        b := pop(&stack)
                        a := pop(&stack)
                        append(&stack, a - b)
                    } else {
                        return stack[:], .Stack_Underflow
                    }
                case "*":
                    if 2 <= len(stack) {
                        b := pop(&stack)
                        a := pop(&stack)
                        append(&stack, a * b)
                    } else {
                        return stack[:], .Stack_Underflow
                    }
                case "/":
                    if 2 <= len(stack) {
                        b := pop(&stack)
                        a := pop(&stack)
                        if b != 0 {
                            append(&stack, a / b)
                        } else {
                            return stack[:], .Divide_By_Zero
                        }
                    } else {
                        return stack[:], .Stack_Underflow
                    }
                case "dup":
                    if 1 <= len(stack) {
                        v := pop(&stack)
                        append(&stack, v)
                        append(&stack, v)
                    } else {
                        return stack[:], .Stack_Underflow
                    }
                case "drop":
                    if 1 <= len(stack) {
                        pop(&stack)
                    } else {
                        return stack[:], .Stack_Underflow
                    }
                case "swap":
                    if 2 <= len(stack) {
                        b := pop(&stack)
                        a := pop(&stack)
                        append(&stack, b)
                        append(&stack, a)
                    } else {
                        return stack[:], .Stack_Underflow
                    }
                case "over":
                    if 2 <= len(stack) {
                        a := stack[len(stack) - 2]
                        append(&stack, a)
                    } else {
                        return stack[:], .Stack_Underflow
                    }
                case:
                    return stack[:], Error.Unknown_Word
                }
            }
        case Builtin:
            switch v {
            case .Define_Start:
                in_define_block = true
                define_block_start = i + 1
                i += 1
            case .Define_End:
                in_define_block = false
                define_block_end := i
                name_vart := tokens[define_block_start]
                name, is_string := name_vart.(string)
                if is_string {
                    defines[name] = tokens[define_block_start+1:define_block_end]
                } else {
                    return stack[:], Error.Cant_Redefine_Number
                }
            }
        }
    }

    return stack[:], .None
}

