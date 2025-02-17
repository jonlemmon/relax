
class EndPlayer < Chingu::GameObject
end

#
#   METEOR
#     Meteor class is used in Introduction gamestate
class Meteor < Chingu::GameObject
#  trait :bounding_circle, :debug => DEBUG
#  traits :velocity, :collision_detection

  def initialize(options)
    super(options.merge(:image => Gosu::Image["assets/intro/meteor.png"]))
    @angular_velocity = 5
    @random = rand(2)+1
    if(@random == 1)
      @angular_velocity = -@angular_velocity
    end
  end

  def update
    @angle += @angular_velocity
  end
end


#
#  KNIGHT
#    called in beginning.rb, in Introduction gamestate
class Knight < Chingu::GameObject
  def initialize(options)
    super
    @image = Gosu::Image["assets/characters/knight.png"]
    @voice = Gosu::Sound["assets/audio/mumble.ogg"]
    @velox = 0     # x velocity starts as 0
    @veloy = 0     # y velocity starts as 0
    @factoring = 1 # used for shrinking Knight when he enters the ship
  end
  def movement   # called in Introduction gamestate
    @velox = -7  # move left
  end
  def enter_ship # called in Introduction gamestate
    @veloy = 2
    @factoring = 0.98
  end
  def speak      # called in Introduction gamestate
    @voice.play
  end
  def update
    self.factor *= @factoring
    @x += @velox
    @y += @veloy
    if @x <= 400; @velox = 0; end
    if @y >= 450; @veloy = 0; end
  end
end





#
#  SPARKLE
#    called in OpeningCredits2 gamestate (Ruby logo)
class Sparkle < Chingu::GameObject
  def setup
    @image = Gosu::Image["assets/intro/sparkle.png"]
    self.factor = 0.1
    @turning = 0.5
    @factoring = 1.0
    @angle = 35
  end

  def turnify1; @turning = 1.0; @factoring = 1.2;   end
  def turnify2; @turning = 2.8; @factoring = 1.05;  end
  def turnify3; @turning = 8.5; @factoring = 1.00;  end
  def turnify4; @turning = 12.5; @factoring = 1.2;  end
  def turnify5; @turning = 10.4; @factoring = 0.75;  end
  def turnify6; @turning = 6.8; @factoring = 0.25;  end

  def update
    @angle += @turning
    self.factor *= @factoring

    # if self.factor >= 1.1
    #   @factoring = 1.0
    # end
  end
end

#
#  HIGHLIGHT
#    called in OpeningCredits gamestate (Gosu logo)
class Highlight < Chingu::GameObject
  def setup
    @image = Gosu::Image["assets/intro/highlight.png"]
  end
  def update
    @x += 5
  end
end

#
#  HIGHLIGHT2
#    called in OpeningCredits gamestate (Gosu logo)
class Highlight2 < Chingu::GameObject
  def setup
    @image = Gosu::Image["assets/intro/highlight2.png"]
  end
  def update
    @x += 5
  end
end

