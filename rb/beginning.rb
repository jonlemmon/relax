#
#  BEGINNING GAMESTATE
#    this gamestate essentially just plays the opening music and pushes the OpeningCredits gamestate
class Beginning < Chingu::GameState #(Gamestate rescue Gosu::Window) # < Chingu::GameState
  trait :timer
  def setup
   self.input = { :esc => :exit } #, [:enter, :return] => Opening1, :p => Pause, :r => lambda{current_game_state.setup} }
   $music = Gosu::Song["assets/audio/intro_song.ogg"]
   $music.volume = 0.9
   $music.play(true)
   after(5) { push_game_state(Chingu::GameStates::FadeTo.new(LivingRoom.new, :speed => 8)) }  #(Opening1.new, :speed => 8)) }
  end
end

#
#  PAUSE GAMESTATE
#    pressing 'P' at any time pauses the current gamestate (except possibly during fades)
class Pause <  Chingu::GameState #(Gamestate rescue Gosu::Window)
  def initialize(options = {})
    super
    @title = Chingu::Text.create(:text=>"PAUSED (press 'P' to un-pause)", :y=>110, :size=>30, :color => Colors::Dark_Orange, :zorder=>1000 )
    @title.x = 400 - @title.width/2
    self.input = { :p => :un_pause, :r => :reset }
    $music.pause
  end
  def un_pause
    $music.play
    pop_game_state(:setup => false)    # Return the previous game state, dont call setup()
  end  
  def reset  # pressing 'r' resets the gamestate
    pop_game_state(:setup => true)
  end
  def draw
    previous_game_state.draw    # Draw prev game state onto screen (in this case our level)
    super                       # Draw game objects in current game state, this includes Chingu::Texts
  end
end

#
#  OPENING CREDITS GAMESTATE
#    Gosu logo with animated highlights 
class Opening1 <  Chingu::GameState
  trait :timer
  def setup
    self.input = { :esc => :exit, [:enter, :return] => :intro, :p => Pause, :r => lambda{current_game_state.setup} }
    @beam = Highlight.create(:x => 116, :y => 360)  # from intro_objects.rb
    @beam2 = Highlight2.create(:x => 50, :y => 360)
    @beam3 = Highlight.create(:x => -400, :y => 360)
    after (3900) {
      push_game_state(Chingu::GameStates::FadeTo.new(Opening2.new, :speed => 8))
    }
  end

  def intro # pressing 'enter' skips ahead to the Introduction
    push_game_state(Chingu::GameStates::FadeTo.new(Opening2.new, :speed => 11)) #Introduction.new, :speed => 11))
  end

  def draw
    Gosu::Image["assets/intro/gosu-logo.png"].draw(0, 0, 0)
    super
  end
end

#
#  OPENING CREDITS 2 GAMESTATE
#    Ruby logo with animated sparkle
class Opening2 <  Chingu::GameState  #(Gamestate rescue Gosu::Window)
  trait :timer
  def setup
    self.input = { :esc => :exit, [:enter, :return] => :intro, :p => Pause, :r => lambda{current_game_state.setup} }
    Sparkle.destroy_all
    @sparkle = Sparkle.create(:x => 553, :y => 341, :zorder => 20) # Sparkle is defined in objects.rb
    after(20) {  # make the sparkle grow and turn, then stop turning
      @sparkle.turnify1  # turnify methods are defined in Sparkle class in objects.rb
      after(100) {
        @sparkle.turnify2
        after(100) {
          @sparkle.turnify3
          after(400) {
            @sparkle.turnify4
            after(200) {
              @sparkle.turnify5
              after(400) {
                @sparkle.turnify6
    } } } } } }
    after (2400) { push_game_state(Chingu::GameStates::FadeTo.new(Introduction.new, :speed => 8)) }
  end

  def intro # pressing 'enter' skips ahead to the Introduction
    push_game_state(Chingu::GameStates::FadeTo.new(Introduction.new, :speed => 11))
  end

  def draw
    Gosu::Image["assets/intro/ruby-logo.png"].draw(0, 0, 0)
    super
  end
end


#
#  INTRODUCTION GAMESTATE
#
class Introduction <  Chingu::GameState
  trait :timer
  def initialize
    super
    self.input = { [:enter, :return] => :next, :p => Pause, :r => lambda{current_game_state.setup} }
  end

  def setup
    Chingu::Text.destroy_all # destroy any previously existing Text, Player, EndPlayer, and Meteors
    Player.destroy_all
    EndPlayer.destroy_all
    Meteor.destroy_all
#    $window.caption = "          ______ Relax ______"
    @counter = 0  # used for automated Meteor creation
    @count = 1    # used for automated Meteor creation
    @nxt = false  # used for :next method ('enter')
    @song_fade = false
    @fade_count = 0
    @knight = Knight.create(:x=>900,:y=>300,:zorder=>100) # creates Knight offscreen; Knight is defined in characters.rb
    @click = Gosu::Sound["assets/audio/pickup_chime.ogg"]

    if $intro == false
      $music = Gosu::Song["assets/audio/music/intro_song.ogg"]
      $music.volume = 0.8
      $music.play(true)
    else
      $intro = false
    end

    after(300) {
      @text = Chingu::Text.create("Relax", :y => 150, :font => "GeosansLight", :size => 45, :color => Colors::Dark_Orange, :zorder => Z::GUI)
      @text.x = 1100/2 - @text.width/2 # center text
      after(300) {
        @text2 = Chingu::Text.create("Press ENTER to play.", :y => 510, :font => "GeosansLight", :size => 45, :color => Colors::Dark_Orange, :zorder => Z::GUI)
        @text2.x = 1100/2 - @text2.width/2 # center text
        after(300) {
          @player = Knight.create(:x => 400, :y => 450, :zorder => Z::Main_Character)
        }
      }
    }
  end
  
  def next
    if @nxt == true  # if you've already pressed 'enter' once, pressing it again skips ahead
      @nxt = false
      push_game_state(LivingRoom)
    else
      @nxt = true    # transition to Level 1 - Knight enters and speaks; push Level_1 gamestate
      @click.play
      after(200) {
        if @text2 != nil; @text2.destroy; end  # only destroy @text2 if it exists
        after(200) {
          if @text != nil; @text.destroy; end
          after(200) {
            @count = 0
            @knight.movement # Knight methods are defined in characters.rb
            after (1400) {
              @knight.speak
                after(10) {
                @text3 = Chingu::Text.create("Relax.", :y => 220, :font => "GeosansLight", :size => 35, :color => Colors::White, :zorder => 300)
                @text3.x = 1100/2 - @text3.width/2   # center text
                after (880) {
                  @text4 = Chingu::Text.create("You've earned it.", :y => 350, :font => "GeosansLight", :size => 35, :color => Colors::White, :zorder => 300)
                  @text4.x = 1100/2 - @text4.width/2
                  after (1390) {
                    @text5 = Chingu::Text.create("And take care of the kids.", :y => 390, :font => "GeosansLight", :size => 35, :color => Colors::White, :zorder => 300)
                    @text5.x = 1100/2 - @text5.width/2
                    after(1400) {
                      @knight.enter_ship
                      after(10) {
                        @song_fade = true
                        after(800) {@text3.destroy}
                        after(1300) {@text4.destroy}
                        after(1600) {@text5.destroy}
                        after(2300) {
                          $music.stop
                          push_game_state(LivingRoom)
      } } } } } } } } } }
    end
  end

def update
    super
    @counter += @count # used for Meteor creation
    if @song_fade == true # fade song if @song_fade is true
      @fade_count += 1
      if @fade_count == 20
        @fade_count = 0
        $music.volume -= 0.1
      end
    end

    if(@counter >= 80)  # automated Meteor creation when @counter is 80
      @random = rand(4)+1
      case @random
      when 1
        Meteor.create(x: rand(800)+1, y: 0,
                velocity_y: rand(5)+1, velocity_x: rand(-5..5),
                :scale => rand(0.5)+0.4, :zorder => Z::Object)
      when 2
        Meteor.create(x: rand(800)+1, y: 600,
                velocity_y: rand(1..5)*-1, velocity_x: rand(-5..5),
                  :scale => rand(0.5)+0.4, :zorder => Z::Object)
      when 3
        Meteor.create(x: 0, y: rand(600)+1,
                velocity_x: rand(1..5), velocity_y: rand(-5..5),
                  :scale => rand(0.5)+0.4, :zorder => Z::Object)
      when 4
        Meteor.create(x: 800, y: rand(600)+1,
                velocity_x: rand(1..5)*-1, velocity_y: rand(-5..5),
                :scale => rand(0.5)+0.4, :zorder => Z::Object)
      end
      @counter = 60  # resets @counter to 60
    end
    Meteor.destroy_if {|meteor| meteor.outside_window?} # self-explanatory
  end

  def draw
    Gosu::Image["assets/intro/background.png"].draw(0, 0, 0)    # Background Image: Raw Gosu Image.draw(x,y,zorder)-call
    super
  end
end

