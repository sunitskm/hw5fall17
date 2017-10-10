# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
    #puts movie
    #puts movie.class
    Movie.create(movie)
  end
  #temp = Movie.where(:title => 'Aladdin').pluck(:title, :rating, :created_at)
  #puts temp
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  #remove this statement after implementing the test step
    all("#ratings_form > input[type= 'checkbox']").each{|ch| uncheck(ch[:id])}
    #uncheck("ratings_PG")
    #uncheck("ratings_G")
    #uncheck("ratings_R")
    #uncheck("ratings_PG-13")
    #uncheck("ratings_NC-17")
    
    str1 = arg1.split(", ")
    str1.each do |rat|
        check("ratings_"+rat)
    end
    click_button "ratings_submit"
  
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
    result1 = true
    result2 = false
    #remove this statement after implementing the test step
    str1 = arg1.split(", ")
    page.all('#movies tr > td :nth-child(2)').each do |td|
        if str1 .rindex(td.text) == nil
            result1 = false
            break
        end
    end
    dbCount  = Movie.where(:rating => str1).count
    rowCount = all('#movies tr').count - 1
    #puts "Row count = #{rowCount}, DB count = #{dbCount}"
    if result1 and (dbCount == rowCount)
        result2 = true
    end
    expect(result2).to be_truthy
end

Then /^I should see all of the movies$/ do
   #remove this statement after implementing the test step
    result2 = false
    dbCount  = Movie.count
    rowCount = all('#movies tr').count - 1
    puts "Row count = #{rowCount}, DB count = #{dbCount}"
    if  (dbCount == rowCount)
        result2 = true
    end
    #all('#movies tr').count.should == Movie.count + 1
    expect(result2).to be_truthy
end


When /^I click on Movie Title$/ do
    click_link('title_header')
end

Then /^I should see "(.*?)" before "(.*?)"$/ do |arg1,arg2|
    i = 0
    str1 = 0
    str2 = 0
    result = false
    all('#movies tr > td:nth-child(1)').each do |td|
        i = i + 1
        if td.text == arg1
         str1 = i 
        end
        if td.text == arg2
         str2 = i
        end
    end
    puts "str2=#{str2}, str1=#{str1}"
    if str2 > str1 
        result = true
    end
    expect(result).to be_truthy
end

When /^I click on Release Date$/ do
    click_link('release_date_header')
end

Then /^I should see Release Date "(.*?)" before "(.*?)"$/ do |arg1,arg2|
    i = 0
    str1 = 0
    str2 = 0
    #puts "arg1=#{arg1}, arg2=#{arg2}"
    result = false
    #puts "Rows = #{page.all('#movies tr').length}"
    all('#movies tr > td:nth-child(3)').each do |td|
        i = i + 1
        if td.text == arg1
         str1 = i 
        end
        if td.text == arg2
         str2 = i
        end
        #puts "test"
    end
    #puts "str2=#{str2}, str1=#{str1}"
    if str2 > str1 
        result = true
    end
    expect(result).to be_truthy
end



