ActiveAdmin.register Book do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
permit_params :name, :summary, :quantity, :price, :cover_image, :author


index do 
  column :name
  column :author
  column :summary
  column :quantity
  column :price
  column :cover_image
    
  actions
end

   show do |book|
    attributes_table_for book do
      row "Cover Image" do book.cover_image.present? ? image_tag(book.cover_image_url(:thumb),:size=>"120x120") : '' end
      row :name
      row :author
      row :summary
      row "No.of books" do book.quantity end  
      row :price
      row :created_at
      row :updated_at
    end
  end


  form do |f|
  	f.inputs do
      f.input :name
  		f.input :author
  		f.input :summary
  		f.input :quantity, :label=> "No.of Books"
  		f.input :price
  	  if f.object.new_record?
    	  f.input :cover_image, :as => :file, :label => 'Add Image'
      else
    	f.input :cover_image, :as => :file, :label => 'Add Image',:hint => f.object.cover_image.present? ? f.image_tag(f.object.cover_image_url(:thumb),:size=>"200x200"):""
      end
      actions
  	end
  end	

end
