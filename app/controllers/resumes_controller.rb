class ResumesController < ApplicationController
 	def index
		@resumes = Resume.all
	end

	def new
		@resume = Resume.new
	end

	def create
		@resume = Resume.new(resume_params)
		s3_resume = S3Store.new(params[:resume][:attachment]).store
		if @resume.save
		 redirect_to resumes_path, notice: "The resume #{@resume.name} has been uploaded."
		else
		 render "new"
		end	  
	end

	def destroy
		@resume = Resume.find(params[:id])
		@resume.destroy
		redirect_to resumes_path, notice:  "The resume #{@resume.name} has been deleted."
	end

	private
		def resume_params
		params.require(:resume).permit(:name, :attachment)
	end
end

class S3Store
  BUCKET = "besthires".freeze

  def initialize file
    @file = file
    @s3 = AWS::S3.new
    @bucket = @s3.buckets[BUCKET]
  end

  def store
    @obj = @bucket.objects[filename].write(@file.tempfile, acl: :public_read)
    self
  end

  def url
    @obj.public_url.to_s
  end

  private
  
  def filename
  	@filename ||= @file.original_filename.gsub(/[^a-zA-Z0-9_\.]/, '_')
  end
end
