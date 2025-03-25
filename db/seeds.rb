
game = Game.find_or_initialize_by(id: 1)
if game.new_record?
  puts "Creating game with ID=1..."
  game.title = "Sample Game"
  game.description = "This is a sample game for development and testing"
  game.save!
  puts "Game created with ID=1!"
else
  puts "Game with ID=1 already exists, updating if needed."
  game.update(
    title: "Sample Game",
    description: "This is a sample game for development and testing"
  )
end
