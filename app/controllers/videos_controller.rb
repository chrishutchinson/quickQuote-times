class VideosController < ApplicationController

  def index
    @user = current_user
    @videos = @user.videos.order('created_at DESC')
    # Checks if videos `is_processed` is false  and if it is sends API call to speech to text API to check if
    # video has been processed.
    # does it only on false, to avoid making too many api calls for already processed videos.
    @videos.where(:is_processed => false  ).each do |v|
      v.check_is_video_processed
    end
  end

  def new
    @user = current_user
    @video = @user.videos.new
  end

  def create
    @user = current_user
    @video = @user.videos.build(video_params)
    @video.published_at = Time.now

     if @video.save
       @video.link = "https://#{ENV['AMAZON_S3_BUCKET']}.s3.amazonaws.com/videos/media/#{@video.id}/#{@video.media_file_name}"
       @video.save
       # `send_to_text_to_speech` also retrieves and saves uid
       @video.send_to_text_to_speech
       @video.is_processed = false
       @video.save
        flash[:success] = 'Video added!'
        redirect_to user_video_path(@user.id, @video.id)
     else
        render 'new'
     end
  end

    def show
      @user = User.find(params[:user_id])
      @video = @user.videos.find(params[:id])
      if !@video.is_processed
       @video.check_is_video_processed
      end

    end
    def destroy
      @user =  User.find(params[:user_id])
      @video = @user.videos.find(params[:id])
      @video.media = nil
      @video.save
      @video.delete_video_from_speech_to_text_api
      if @video.destroy
        flash[:success] = 'Video Deleted!'
        redirect_to user_videos_path(@user)
      else
        render user_videos_path(@user)
      end
    end

    private
    def video_params
      params.require(:video).permit(:media,:link,:title, :uid)
    end

end