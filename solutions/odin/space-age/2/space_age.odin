package space_age

Planet :: enum {
	Mercury,
	Venus,
	Earth,
	Mars,
	Jupiter,
	Saturn,
	Uranus,
	Neptune,
}

age :: proc(planet: Planet, seconds: int) -> f64 {
    years: f64
    switch planet {
    case .Mercury: years = 0.2408467
    case .Venus: years = 0.61519726
    case .Earth: years = 1.0
    case .Mars: years = 1.8808158
    case .Jupiter: years = 11.862615
    case .Saturn: years = 29.447498
    case .Uranus: years = 84.016846
    case .Neptune: years = 164.79132
    }
    return f64(seconds) / (years * 31557600)
}
