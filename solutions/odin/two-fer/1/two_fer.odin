package two_fer

import "core:fmt"

two_fer :: proc(name: string = "") -> string {
    return fmt.aprintf(
        "One for %s, one for me.",
        name if name != "" else "you",
        allocator=context.temp_allocator
    )
}
