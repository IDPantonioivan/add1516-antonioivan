#!/usr/bin/ruby

users = `cat userlist.txt`

userlist = users.split("\n")

userlist.each do

{|nombre| system("userdel -f -r #{nombre}")}

end

puts "Borrados los usuarios"

