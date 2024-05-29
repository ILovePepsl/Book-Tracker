ActiveAdmin.register Book do
  permit_params :title, :description, :cover_image, :author_id, :status, :started_reading_on, :finished_reading_on, :rating, category_ids: []

  scope :general_library, default: true do |books|
    books.general_library
  end

  controller do
    def scoped_collection
      super.general_library
    end
  end

  form do |f|
    f.inputs 'Book Details' do
      f.input :title
      f.input :description
      f.input :cover_image, as: :file
      f.input :author
      f.input :categories, as: :check_boxes
      f.input :status, as: :select, collection: ['Прочитал', 'Хочу прочитать', 'Сейчас читаю']
      f.input :started_reading_on, as: :datepicker
      f.input :finished_reading_on, as: :datepicker
      f.input :rating
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :title
    column :author
    column :status
    column :rating
    column :created_at
    actions
  end

  filter :title
  filter :description
  filter :author
  filter :status
  filter :rating
  filter :created_at
  filter :updated_at

  show do
    attributes_table do
      row :title
      row :description
      row :cover_image do |book|
        image_tag url_for(book.cover_image) if book.cover_image.attached?
      end
      row :author
      row :categories do |book|
        book.categories.map(&:name).join(', ')
      end
      row :status
      row :started_reading_on
      row :finished_reading_on
      row :rating
    end
    active_admin_comments
  end
end
