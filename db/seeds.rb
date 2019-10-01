# to type into Pry, initalize method already created by ActiveRecord
User.destroy_all 
Song.destroy_all
Playlist.destroy_all
PlaylistSong.destroy_all


user1 = User.create(name: "Lucas Meyer", username: "lucasm", password: "lucasdabest")
user2 = User.create(name: "Sarah Wise", username: "sarahw", password: "imusics")
user3 = User.create(name: "Tom Wheels", username: "tomw", password: "password123")
user4 = User.create(name: "Kathi Clyff", username: "kathc", password: "k1clyff")
user5 = User.create(name: "Tony Schwarz", username: "schwarzt", password: "schwarz123")
user6 = User.create(name: "Lauren King", username: "kingl", password: "kingandqueen")

song1 = Song.create(title: "Summer of 69", genre: "rock", mood: "happy", artist: "Bryan Adams")
song2 = Song.create(title: "It's My Life", genre: "rock", mood: "happy", artist: "Bon Jovi")
song3 = Song.create(title: "Wind of Change", genre: "rock", mood: "sad", artist: "Scorpions")
song4 = Song.create(title: "I'm Gonna Be (500 miles)", genre: "rock", mood: "calm", artist: "The Proclaimers")
song5 = Song.create(title: "Liar", genre: "pop", mood: "sad", artist: "Camila Cabello")
song6 = Song.create(title: "I Warned Myself", genre: "pop", mood: "sad", artist: "Charlie Puth")
song7 = Song.create(title: "Memories", genre: "pop", mood: "calm", artist: "Maroon 5")
song8 = Song.create(title: "Dance Monkey", genre: "pop", mood: "happy", artist: "Tones and I")
song9 = Song.create(title: "My Favourite Room", genre: "indie", mood: "sad", artist: "Blossoms")
song10 = Song.create(title: "I Always Knew", genre: "indie", mood: "happy", artist: "The Vaccines")
song11 = Song.create(title: "Decency", genre: "indie", mood: "calm", artist: "Balthazar")
song12 = Song.create(title: "Ego", genre: "indie", mood: "calm", artist: "Milky Chance")
song13 = Song.create(title: "Sky and Sand", genre: "electro", mood: "calm", artist: "Paul Kalkbrenner")
song14 = Song.create(title: "Sorry", genre: "electro", mood: "sad", artist: "Joel Corry")
song15 = Song.create(title: "Never Change", genre: "electro", mood: "happy", artist: "Don Diablo")
song16 = Song.create(title: "I Wanna Dance", genre: "electro", mood: "happy", artist: "Jonas Blue") 

# to be passed user_id, title
playlist1 = Playlist.create()
playlist2 = Playlist.create()
playlist3 = Playlist.create()
playlist4 = Playlist.create()
playlist5 = Playlist.create()
playlist6 = Playlist.create()

# to be passed playlist_id, song_id
joint1 = PlaylistSong.create()
joint2 = PlaylistSong.create()
joint3 = PlaylistSong.create()
joint4 = PlaylistSong.create()
joint5 = PlaylistSong.create()
joint6 = PlaylistSong.create()

