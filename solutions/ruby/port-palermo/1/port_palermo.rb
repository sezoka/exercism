module Port
  IDENTIFIER = :PALE

  def self.get_identifier(city)
    city[0, 4].upcase.to_sym
  end

  def self.get_terminal(ship_identifier)
    ship_kind = ship_identifier.to_s[0, 3] 
    (ship_kind == "OIL" or ship_kind == "GAS") ? :A : :B
  end
end
