
if Game.count == 0
  puts "Creating default game..."
  Game.create!(
    id: 1,
    title: "Sample Game",
    description: "This is a sample game for development and testing"
  )
  puts "Default game created!"
else
  puts "Default game already exists, skipping creation."
end
