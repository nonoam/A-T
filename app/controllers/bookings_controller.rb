class BookingsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Muestra reservas donde soy estudiante
    @my_bookings = current_user.bookings.order(start_time: :asc)
  end

  def new
    @service = Service.find(params[:service_id])
    @booking = @service.bookings.build
    # Precargamos el estudiante
    @booking.student = current_user
  end

  def create
    @service = Service.find(params[:service_id])
    @booking = @service.bookings.build(booking_params)
    @booking.student = current_user
    @booking.status = :pending

    if @booking.save
      redirect_to bookings_path, notice: 'Tu solicitud de reserva ha sido enviada.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:start_time, :end_time)
  end
end