class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  @all_ratings = []
  #reset_session
  @all_ratings = Movie.uniq.pluck(:rating)
  if params[:sort]!= nil
  @sort = params[:sort]
  session[:sort] = params[:sort]
  elsif session[:sort] !=nil
  @sort  = session[:sort]
  if @sort == "Release_Date"
  redirect_to movies_path(:id => "release_date_header",:sort => @sort)
  elsif @sort =="Movie_Title"
  redirect_to movies_path(:id => "title_date_header",:sort => @sort)
  end
  end
  if params[:ratings]!= nil
  @rating = params[:ratings]
  session[:ratings] = params[:ratings]
  elsif session[:ratings] !=nil
  @rating  = session[:ratings]
  redirect_to movies_path(:ratings => @rating)
  end
  if @sort == "Movie_Title"
  @movies = Movie.all.sort_by { |movie| movie.title } 
    @hilitetitle = "hilite"
    end
    if @sort == "Release_Date"
    @movies = Movie.all.sort_by { |movie| movie.release_date } 
    @hiliterelease = "hilite"
    end
    if @rating != nil
       current = []
     @rating.each do |key,value|
     	current += [key]
     end
      @movies = Movie.where(:rating => current)
      end
    if @sort == nil && @rating == nil
    @movies = Movie.all
    end
  end
  
  
  
  
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
