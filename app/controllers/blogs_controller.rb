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
    fetch_random_image_from_unsplash(@blog.title) if blog_params[:title].present?
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
      fetch_random_image_from_unsplash(@blog.title) if blog_params[:title].present?
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
      params.require(:blog).permit(:title, :content, :image_url)
    end

    def fetch_random_image_from_unsplash(query)
      @photo = Unsplash::Photo.search(query).first
      if @photo.present?
       @blog.update(image_url: @photo.urls['regular'])
      end
    end
    

  

end
