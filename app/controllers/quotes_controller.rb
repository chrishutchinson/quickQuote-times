class QuotesController < ApplicationController
  # http://api.rubyonrails.org/classes/ActionController/RequestForgeryProtection.html
  protect_from_forgery
  skip_before_action :verify_authenticity_token, if: :json_request?

  ##
  # a method invoked from the routes, called by the `video.show.erb` page, used to cut a quote from an original video file,
  # trimming the video file down to the desired duration, using in point and duration.
  # To cut the quote it makes a system call using ffmpeg to cut the video.
  # it then saves the video quote.
  # @param [params hash]
  def save_quote_with_video_snippet
    # read values from params hash and saves video quote
    data =  JSON.parse(params["quoteDetails"])
    @video = Video.find(data["video_id"])
    @quote = @video.quotes.new
    @quote.tc_in = data["tc_in"].to_f
    @quote.tc_out = data["tc_out"].to_f
    @quote.duration = data["duration"].to_f
    @quote.text = data["text"].to_s
    @quote.author = data["author"].to_s
    @quote.save

    # Trimming the Video

    @snippet_file_name = "snippet_#{@quote.id}.mp4"
    # define temporary location to put the trimed video in public folder before uploading to amazon S3
    @path_to_file= Rails.root.join('public',"#{@snippet_file_name}").to_s
    # system call to cut video with ffmpeg. the video is saved in the public folder of the applciaiton
    `ffmpeg -i 'http://#{ENV['AMAZON_S3_BUCKET']}.s3.amazonaws.com/videos/media/#{@video.id}/#{@video.media_file_name}' -ss #{@quote.tc_in} -t #{@quote.duration} -vcodec libx264 -acodec aac -async 1 -strict -2 #{@path_to_file}`

    # saving to amazon S3 using paperclip
    File.open(@path_to_file, "r") do |f|
          @quote.snippet = f
    end

    @quote.save
    # link to the video on amazon S3 saved in the database
    @quote.link = "http://#{ENV['AMAZON_S3_BUCKET']}.s3.amazonaws.com/videos/quotes/#{@quote.id}/#{@snippet_file_name}"
    @quote.save

    # delete temporary file from public folder,  temporary_snippet.mp4
    `rm -rf #{@path_to_file}`
    # returning link to video quote snippet video file on amazon S3 as a response
    @temp1 =  @quote.link
    temp = {response: @temp1}
    # format support
    respond_to do |format|
      # return link of video quote to Ajax request
      format.json { render json: temp, status: :ok}
      format.js { render :nothing => true }
    end
  end

  protected

  def json_request?
    request.format.json?
  end

  private
  def quote_params
    params.require(:quote).permit(:tc_in,:tc_out, :duration, :text,:video_id, :author, :snippet)
  end

end
