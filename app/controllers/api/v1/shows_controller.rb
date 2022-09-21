# frozen_string_literal: true

module Api
  module V1
    class ShowsController < ApplicationController
      def index
        @shows = Show.all

        render json: @shows
      end

      def create
        @show = Show.new(show_params)

        if @show.save
          render json: @show, status: 201
        else
          render json: { error: "Unable to create show. Error(s): #{@show.errors.full_messages.join(', ')}" },
                 status: 422
        end
      end

      def destroy
        @show = Show.find(params[:id])

        if @show.destroy
          render json: { message: 'Show deleted' }, status: 200
        else
          render json: { error: 'Unable to destroy show' }, status: 422
        end
      end

      private

      def show_params
        params.require(:show).permit(:name, :start_date, :finish_date)
      end
    end
  end
end
