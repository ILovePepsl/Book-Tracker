namespace :users do
  desc "Create default book lists for existing users"
  task create_default_book_lists: :environment do
    User.find_each do |user|
      user.create_default_book_lists if user.book_lists.empty?
    end
  end
end