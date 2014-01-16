class AlbumsController < ApplicationController
	before_filter :require_user, :except => [:index, :show, :release, :download]
  layout :set_layout

  def index
		@albums = current_artist ? current_artist.albums.published.all : Album.published.all
  end

  def show
		@album = Album.find( params[:id] )
    redirect_to( artist_album_url( @album.artist, @album ), :status => 301 ) unless current_artist?
		authorize! :read_album, @album
		@artist = current_artist
  end

  def edit
		@album = Album.find( params[:id] )
    redirect_to( edit_artist_album_url( @album.artist, @album ), :status => 301 ) unless current_artist?
		authorize! :write_album, @album
  end

  def new
		authorize! :write_album, Album
		@album = Album.new
		@album.artist = current_artist if current_artist?
  end

	def create
		@album = Album.new( params[:album] )
		authorize! :write_album, @album
		if @album.save
			redirect_to artist_album_url( @album.artist, @album )
		else
			render :action => 'new'
		end
	end

	def update
		@album = Album.find( params[:id] )
		authorize! :write_album, @album
		if @album.update_attributes( params[:album] )
			redirect_to artist_album_url( @album.artist, @album )
		else
			render :action => 'edit'
		end
	end

	def destroy
		@album = Album.find( params[:id] )
		authorize! :write_album, @album
		@album.destroy
		redirect_to albums_url
	end

  def release
		@album = Album.find( params[:id] )
    release = @album.releases.in_format( params[:format] ).first
    #TODO release.touch
    #FIXME
    # release = @album.releases.build( format: params[:format] )
    # release.valid?
    # argv = "karoryfer_releaser_#{@album.id}_#{release.format}"
    argv = "karoryfer_releaser_#{@album.id}_#{params[:format]}"
    if release.nil?
      unless `ps aux`.include? argv
        Spawnling.new( argv: argv ) do
          @album.releases.create( format: params[:format] )
        end
      end
    end
    if request.xhr?
      render json: { success: true }
    else
      redirect_to album_url(@album)
    end
  end

  def download
		@album = Album.find( params[:id] )
    release = @album.releases.in_format( params[:format] ).first
    if release.nil?
      if request.xhr?
        render json: { success: false }
      else
        redirect_to album_url(@album)
      end
    else
      if request.xhr?
        render json: { success: true, url: release.file.url }
      else
        redirect_to release.file.url
      end
    end
  end
end

