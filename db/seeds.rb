# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Word.delete_all
words_file = Rails.root.join('db', 'words.txt')

open(words_file.to_path) do |words|
  words.read.each_line do |word|
    Word.create! text: word.strip
  end
end