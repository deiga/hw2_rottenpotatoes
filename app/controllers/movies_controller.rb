class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @sort_by = params[:sort]
    @sort_by ||= session[:sort]
    @ratings = params[:ratings]
    @ratings ||= session[:ratings]
    selected_ratings = @ratings.keys unless @ratings.nil?
    selected_ratings = @all_ratings if selected_ratings.nil? or selected_ratings.empty?
    unless @sort_by.nil? or @sort_by.empty?
      @movies = Movie.find(:all, :conditions => [ "rating IN (?)", selected_ratings], :order => "#{@sort_by} ASC")
    else
      @movies = Movie.find(:all, :conditions => [ "rating IN (?)", selected_ratings])
    end
    session[:ratings], session[:sort] = @ratings, @sort_by
    if params[:sort].nil? and params[:ratings].nil?
      redirect_to movies_path(:sort => @sort_by, :ratings => @ratings) unless session[:sort].nil? and session[:ratings].nil?
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
