class BlogsController < ApplicationController
  def index
    @blogs = Blog.all
  end 
  def new
    @blog = Blog.new
  end
  def show
    @blog = Blog.find(params[:id])
  end
  def create
    @blog = current_user.blogs.new(blog_params)
    if @blog.save
      redirect_to action: :index
    else
      render :new
    end
  end
  def edit
    @blog= Blog.find(params[:id])
  end

  def update
    @blog= Blog.find(params[:id])
    if @blog.update(blog_params)
      redirect_to @blog
    else
      render :edit
    end
  end
  def destroy
    @blog=Blog.find(params[:id])
    @blog.destroy
    redirect_to blogs_path
  end

  private
    def blog_params
      params.require(:blog).permit(:title, :content, :image)
    end
end
