# config/initializers/ransack.rb
Ransack.configure do |config|
  config.add_predicate 'cover_image_cont',
                       arel_predicate: 'matches',
                       formatter: proc { |v| "%#{v}%" },
                       validator: proc { |v| v.present? },
                       compounds: true,
                       type: :string
end
