class CreateLoveMessagesTable < ActiveRecord::Migration[6.0]
  def up
    unless ActiveRecord::Base.connection.table_exists?(:love_messages)
      create_table :love_messages do |table|
        table.string :message
        table.timestamps
      end

      default_messages = [
        "i love you",
        "hi, how was heaven when you left it?",
        "do you believe in love at first sight or should i pass by again?",
        "did the sun come out or did you just smile at me?",
        "kiss me if i’m wrong, but dinosaurs still exist, right?",
        "hey, you’re pretty and i’m cute. together we’d be pretty cute.",
        "is your name google? because you have everything i’ve been searching for.",
        "are you from tennessee? because you’re the only ten i see!",
        "hello, i’m a thief, and i’m here to steal your heart.",
        "i may not be a genie, but i can make your dreams come true.",
        "if nothing lasts forever, will you be my nothing?",
        "there must be something wrong with my eyes, i can’t take them off you.",
        "was you father an alien? because there’s nothing else like you on earth!",
        "was your father a thief? ‘cause someone stole the stars from the sky and put them in your eyes.",
        "do you have a pencil? cause i want to erase your past and write our future.",
        "i’d say god bless you, but it looks like he already did.",
        "i must be in a museum, because you truly are a work of art.",
        "are you my phone charger? because without you, i’d die.",
        "can you take me to the doctor? because i just broke my leg falling for you.",
        "you don’t need keys to drive me crazy.",
        "are you a dictionary? cause you’re adding meaning to my life.",
        "you remind me of a magnet, because you sure are attracting me over here!",
        "i’m no mathematician, but i’m pretty good with numbers. tell you what, give me yours and watch what i can do with it.",
        "somebody call the cops, because it’s got to be illegal to look that good!",
      ].each do |message|
        LoveMessage.create(message: message)
      end
    end
  end

  def down
    if ActiveRecord::Base.connection.table_exists?(:love_messages)
      drop_table :love_messages
    end
  end
end
