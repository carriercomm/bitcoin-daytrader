class Float
  require 'colorize'
  def btc_round
    self.round 6
  end
  def usd_round
    self.round 2
  end
  def percent_round
    self.round 2
  end


end

class Fixnum
  def minute
    self.minutes
  end
  def minutes
    self * 60
  end
  def hour
    self.hours
  end
  def hours
    self.minutes * 60
  end
end

class String
  def dollar_sign
    if self.count('-') > 0
      self.sub "-", "-$"
    else
      "$" + self
    end
  end
end

class Object
  def color_by_sign
    if self.to_s.count('-') > 0
      self.to_s.red
    else
      self.to_s.green
    end
  end
end

def percent_change (n, o)
  (n - o) / o
end

def format_stars
  return "",("*"*50).cyan,""
end