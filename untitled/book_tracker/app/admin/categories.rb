ActiveAdmin.register Category do
  permit_params :name

  controller do
    def destroy
      category = Category.find(params[:id])
      unknown_category = Category.find_or_create_by(name: 'Unknown Category')

      category.books.each do |book|
        book.categories.delete(category)
        book.categories << unknown_category unless book.categories.include?(unknown_category)
      end

      category.destroy
      redirect_to admin_categories_path, notice: 'Category was successfully destroyed.'
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :created_at
    actions
  end

  filter :name
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end
end
