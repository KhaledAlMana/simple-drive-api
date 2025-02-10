
module Api::V1
  class StorageController < ApplicationController
    before_action :set_file, only: [ :show, :update, :destroy ]

    def index
      @files = Storage.all
      render json: @files, status: :ok
    end

    def show
      render json: @file, status: :ok
    end

    def create
      @file = Storage.new(file_params)

      if @file.save
        render json: @file, status: :created
      else
        render json: { errors: @file.errors.full_messages },
                status: :unprocessable_entity
      end
    end

    def update
      if @file.update(file_params)
        render json: @file, status: :ok
      else
        render json: { errors: @file.errors.full_messages },
                status: :unprocessable_entity
      end
    end

    def destroy
      @file.destroy
      head :no_content
    end

    private

    def set_file
      @file = Storage.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "File not found" }, status: :not_found
    end

    def file_params
      params.require(:storage).permit(:name, :file_type, :content, :size)
    end
  end
end
