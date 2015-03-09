class CollectionScaffoldGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("../templates", __FILE__)
  include Rails::Generators::ResourceHelpers

  check_class_collision suffix: "Controller"

  class_option :orm, banner: "NAME", type: :string, required: true,
                     desc: "ORM to generate the controller for"
  argument :attributes, type: :array, default: [], banner: "field:type field:type"

  def create_route
    route "collection_resources :#{plural_name}"
  end

  def create_controller_files
    template "controller.rb", File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")
  end

  def create_model_file
    template 'model.rb', File.join('app/models', class_path, "#{file_name}.rb")
  end

  def create_collection_file
    template 'collection.rb', File.join('app/models', class_path, file_name, "collection.rb")
  end

  def create_root_folder
    empty_directory File.join("app/views", controller_file_path)
  end

  def copy_view_files
    available_views.each do |view|
      formats.each do |format|
        filename = filename_with_extensions(view, format)
        template filename, File.join("app/views", controller_file_path, filename)
      end
    end
  end

  protected

  def collection_type_addition_for(attribute)
    case attribute.type
    when :boolean then ", type: Boolean"
    else ''
    end
  end

  def parent_class_name
    options[:parent] || "ActiveRecord::Base"
  end

  def available_views
    %w(index edit show new _form collection_edit)
  end

  def formats
    [:html]
  end

  def handler
    :haml
  end

  def filename_with_extensions(view, format)
    [view, format, handler].compact.join('.')
  end
end
