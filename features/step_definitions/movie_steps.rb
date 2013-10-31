# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
  #flunk "Unimplemented"
end


Then /I should (not )?see the movies rated: (.*)/ do |not_inlist, rating_list|
 # ensure elements are (not)? visible by comparing
 # number of movies in the database, with the one shown
 # Then I should see PG,R movies
 rating_list.split(/,\s*/).each do |rate|
   if(not_inlist)
     assert page.has_no_xpath?('//td', :text => /^#{rate}$/)
   else
     assert page.has_xpath?('//td', :text => /^#{rate}$/)
   end
 end 
end 

# Make sure that one string (regexp) occurs before or after another one
#   on the same page
Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  #flunk "Unimplemented"
  assert page.body =~ /#{e1}.+#{e2}/m
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb

  if uncheck == "un"
    rating_list.split(', ').each {|x| step %{I uncheck "ratings_#{x}"}}
  else   
    rating_list.split(', ').each {|x| step %{I check "ratings_#{x}"}}
  end 
end

When /^I check all the ratings$/ do 

  Movie.all_ratings.each do | rating |
   rating = "ratings_" + rating
     check(rating) 
  end

end

Then /I should not see any of the movies/ do
  rows = page.all('#movies tr').size - 1 
  assert rows == 0
end 

Then /I should see all of the movies/ do
  rows = page.all('#movies tr').size - 1 
  assert rows == Movie.count()
end 



