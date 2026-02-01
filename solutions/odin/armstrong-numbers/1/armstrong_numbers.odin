package armstrong_numbers

is_armstrong_number :: proc(n: u128) -> bool {
    digits_cnt: u128
    tmp := n
    for tmp != 0 {
        tmp /= 10
        digits_cnt += 1
    }

    sum: u128
    tmp = n
    for tmp != 0 {
        digit := tmp % 10
        sum += pow_u128(digit, digits_cnt)
        tmp /= 10
    }

	return sum == n
}

pow_u128 :: proc(a: u128, b: u128) -> u128 {
    res : u128 = 1
    for _ in 0..<b {
        res *= a
    }
    return res
}

