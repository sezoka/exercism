package all_your_base

import "core:fmt"
import "core:math"

Error :: enum {
	None,
	Invalid_Input_Digit,
	Input_Base_Too_Small,
	Output_Base_Too_Small,
	Unimplemented,
}

rebase :: proc(input_base: int, digits: []int, output_base: int) -> ([]int, Error) {
    if 2 <= input_base {
        if 2 <= output_base {
            num_from_digits: int
            i: int
            #reverse for digit in digits {
                if 0 <= digit && digit < input_base {
                    num_from_digits += digit * pow_int(input_base, i)
                    i += 1
                } else {
                    return nil, .Invalid_Input_Digit
                }
            }

            size_of_buffer: int
            tmp := num_from_digits
            for tmp != 0 {
                tmp /= output_base
                size_of_buffer += 1
            }
            if size_of_buffer == 0 {
                size_of_buffer = 1
            }

            out_buff := make([]int, size_of_buffer)
            tmp = num_from_digits
            for i := size_of_buffer - 1; tmp != 0; i -= 1 {
                rem := tmp % output_base
                tmp /= output_base
                out_buff[i] = rem
            }

            return out_buff, .None
        } else {
            return nil, .Output_Base_Too_Small
        }
    } else {
        return nil, .Input_Base_Too_Small
    }

	return nil, .Unimplemented
}

pow_int :: proc(x, y: int) -> int {
    idk: int = 1
    for _ in 0..<y {
        idk *= x
    }
    return idk
}
