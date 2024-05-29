ActiveAdmin.register Author do
  permit_params :name, :bio

  index do
    selectable_column
    id_column
    column :name
    column :bio
    column :created_at
    actions
  end

  filter :name
  filter :bio
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :bio
    end
    f.actions
  end

  controller do
    def destroy
      author = Author.find(params[:id])
      unknown_author = Author.find_or_create_by(name: 'Unknown Author') do |a|
        a.bio = 'This author is used as a placeholder for books with no known author.'
      end

      author.books.update_all(author_id: unknown_author.id)
      author.destroy
      redirect_to admin_authors_path, notice: 'Author was successfully destroyed.'
    end
  end
end
