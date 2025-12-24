class BookingsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Muestra las reservas donde el usuario es el estudiante
    # @bookings = current_user.bookings.order(start_time: :desc)
    @my_bookings = current_user.bookings.order(start_time: :asc)
  end

  def new
    @service = Service.find(params[:service_id])
    @booking = Booking.new
  end

  def create
    @service = Service.find(params[:service_id])
    @booking = @service.bookings.new(booking_params)
    
    # Ahora esto funcionará porque en el modelo pusimos 'belongs_to :user'
    @booking.user = current_user

    # Ya no necesitamos calcular el end_time aquí, 
    # el modelo lo hará solo gracias al 'before_validation'

    if @booking.save
      redirect_to bookings_path, notice: "¡Reserva confirmada con éxito!"
    else
      # Si hay errores (como el de 'End time'), se mostrarán aquí
      render :new, status: :unprocessable_entity
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:start_time, :notes)
  end
end