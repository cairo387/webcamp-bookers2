class SearchController < ApplicationController

  def search
    @select = params[:select]
    type = params[:type]
    @search = params[:search]

    if @select == "user"
      @users = User.search(type, @search)
    else
      @books = Book.search(type, @search)
    end
  end

end
