module CatsHelper

  def current_user_owns_cat!
    if self.instance_of?(RentalRequestsController)
      cat_id = RentalRequest.find(params[:id]).cat_id
    else
      cat_id = params[:id]
    end
    unless current_user == Cat.find(cat_id).owner
      flash[:errors] ||= []
      flash[:errors] << "You don't have access to that!"
      redirect_to cats_url
    end
  end

end
