package bob

import "core:unicode"
import "core:strings"
import "core:log"

response :: proc(input: string) -> string {
    trimmed := strings.trim(input, " \n\t\r")

    is_silence := trimmed == ""
    is_question := !is_silence && trimmed[len(trimmed)-1] == '?'
    has_letter := false
    is_upper := true

    for c in input {
        if unicode.to_upper(c) != c {
            is_upper = false
        }
        if unicode.is_letter(c) {
            has_letter = true
        }
    }

    if is_silence {
        return "Fine. Be that way!"
    } else if is_question && is_upper && has_letter {
        return "Calm down, I know what I'm doing!"
    } else if is_question {
        return "Sure."
    } else if is_upper && has_letter {
        return "Whoa, chill out!"
    } else {
        return "Whatever."
    }
}
