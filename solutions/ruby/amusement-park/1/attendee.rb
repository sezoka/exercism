class Attendee
  def initialize(height)
    @height = height
    @pass = nil
  end

  def height
    @height
  end

  def pass_id
    @pass
  end

  def issue_pass!(pass_id)
    @pass = pass_id
  end

  def revoke_pass!
    @pass = nil
  end
end
