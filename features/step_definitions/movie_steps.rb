# Add a declarative step here for populating the DB with movies.

class Movie < ActiveRecord::Base
end

Then /I should see all of the movies/ do
  rows = page.all("table#movies tbody tr").count
  rows.should == 10
end

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  page.body.should =~ /#{e1}.*#{e2}/m
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(", ").each do |rating|
    step %{I #{uncheck}check "ratings_#{rating}"}
  end
end

When /I (un)?check all ratings/ do |uncheck|
  step %{I #{uncheck}check the following ratings: G, PG, PG-13, NC-17, R}
end

Then /I should see (un)?checked all ratings/ do |uncheck|
  step %{I should see #{uncheck}checked the following ratings: G, PG, PG-13, NC-17, R}
end

Then  /I should( not)? see movies with the following ratings: (.*)/ do |not_see, rating_list|
  regex = /^#{rating_list.gsub(', ', '|')}$/
  cells = page.all("table#movies tbody tr td[2]")
  cells.each do |td|
    if not_see == nil
      td.text.should =~ regex
    else
      td.text.should_not =~ regex
    end
  end
end

Then  /I should see (un)?checked the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(", ").each do |rating|
    step %{the "ratings_#{rating}" checkbox should#{uncheck == nil ? '' : ' not'} be checked}
  end
end
