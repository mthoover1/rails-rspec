require 'spec_helper'

describe 'Admin' do

  before(:each) do
    post = Post.create!(:title => "Title1", :content => "al;s")
    page.driver.browser.authorize 'geek', 'jock' 
  end
  
  context "on admin homepage" do

    before(:each) do
      visit '/admin/posts'
    end

    it "can see a list of recent posts" do
      expect(page).to have_content("Title1")
    end

    it "can edit a post by clicking the edit link next to a post" do
      page.all('td')[-2].click_link('Edit')
      expect(page).to have_content("al;s")
    end

    it "can delete a post by clicking the delete link next to a post" do
      count = Post.all.count
      page.all('td')[-1].click_link('Delete')
      Post.all.count.should eq(count-1)
    end

    it "can create a new post and view it" do
       visit new_admin_post_url

       expect {
         fill_in 'post_title',   with: "Hello world!"
         fill_in 'post_content', with: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat."
         page.check('post_is_published')
         click_button "Save"
       }.to change(Post, :count).by(1)

       page.should have_content "Published: true"
       page.should have_content "Post was successfully saved."
     end
  end

  context "editing post" do
    it "can mark an existing post as unpublished" do
      visit "/admin/posts/#{Post.first.id}/edit"
      page.uncheck("post[is_published]")
      click_button('Save')

      visit "/admin/posts/#{Post.first.id}"
      page.should have_content "Published: false"
    end
  end

  context "on post show page" do
    before(:each) do
      visit "/admin/posts/#{Post.first.id}"
    end
    # it "can visit a post show page by clicking the title" 
    # THIS TEST IS AWFUL

    it "can see an edit link that takes you to the edit post path" do
      click_link 'Edit post' 
      page.should have_content('Publish?') 
    end

    it "can go to the admin homepage by clicking the Admin welcome page link" do
      click_link 'Admin welcome page' 
      page.should have_content('Welcome to the admin panel!') 
    end
  end
end
