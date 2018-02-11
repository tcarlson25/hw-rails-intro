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
    path_change = false # keep track if redirect needed
    
    # sort movies by param
    if params[:sort]
      @movies = Movie.sort_by(params[:sort])
      session[:sort] = params[:sort]
    elsif session[:sort]
      @movies = Movie.sort_by(session[:sort])
      params[:sort] = session[:sort]
      path_change = true
    else
      @movies = Movie.all
    end
    
    # sort movies by checked ratings
    @all_ratings = Movie.unique_ratings
    if params[:ratings]
      @checked_ratings = params[:ratings].keys
      session[:ratings] = params[:ratings]
    elsif session[:ratings]
      @checked_ratings = session[:ratings].keys
      params[:ratings] = session[:ratings]
      path_change = true
    else
      @checked_ratings = @all_ratings
    end
    @movies = Movie.filter_ratings(@checked_ratings, @movies)
    
    # redirect if needed to keep RESTfulness 
    if path_change
      redirect_to(movies_path(:sort => params[:sort], :ratings => params[:ratings]))
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
