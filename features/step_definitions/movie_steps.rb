# Add a declarative step here for populating the DB with movies.

Then /I should see all of the movies/ do
  all('table#movies tbody tr').count.should == 10
end

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
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

Then  /I should( not)? see movies with the following ratings: (.*)/ do |not_see, rating_list|
  all_ratings =rating_list.split(/\s*,\s*/)
  td_list = all('table#movies tbody tr td[2]')

  if !not_see then
    assert td_list.count > 0
  end

  td_list.each do |td_rating|
    if not_see then
      assert !all_ratings.include?(td_rating.text)
    else
      assert all_ratings.include?(td_rating.text)
    end
  end
end

Then  /I should see (un)?checked the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(", ").each do |rating|
    step %{the "ratings_#{rating}" checkbox should#{uncheck == nil ? '' : ' not'} be checked}
  end
end
