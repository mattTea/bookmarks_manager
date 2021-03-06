# As a user,
# So that I can quickly access websites I regularly visit,
# I want to view a list of my bookmarks.

# As a user,
# so that I can comfortably access my favourite web pages,
# I wish to view only the titles,
# and be able to click them to be directed to that page. 

require 'pg'

feature "Viewing bookmarks" do
  scenario "user can see list of bookmarks" do

    # Add test data
    Bookmark.create(url: "http://www.makersacademy.com", title: "Makers Academy")
    Bookmark.create(url: "http://www.destroyallsoftware.com", title: "Destroy All Software")
    Bookmark.create(url: "http://www.google.com", title: "Google")

    visit("/bookmarks")

    expect(page).to have_link("Makers Academy", href: "http://www.makersacademy.com")
    expect(page).to have_link("Destroy All Software", href: "http://www.destroyallsoftware.com")
    expect(page).to have_link("Google", href: "http://www.google.com")
  end

  scenario "user sees only the title of saved bookmarks" do
    Bookmark.create(url: "http://www.makersacademy.com", title: "Makers Academy")
    visit("/bookmarks")
    expect(page).not_to have_content "http://www.makersacademy.com"
  end
end