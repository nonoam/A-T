class ServicesController < ApplicationController
  # Autenticación: Obligatoria excepto para ver el catálogo
  before_action :authenticate_user!, except: [:index, :show]
  
  # Seteo de datos: Busca la clase por ID antes de acciones específicas
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  def index
    @services = Service.all
    @services = @services.search_by_text(params[:query]) if params[:query].present?
    @services = @services.by_modality(params[:modality]) if params[:modality].present?
  end

  def show
    # @service ya está disponible gracias a set_service
  end

  def new
    @service = current_user.services.build
    authorize @service
  end

  def create
    @service = current_user.services.build(service_params)
    authorize @service

    if @service.save
      redirect_to @service, notice: 'Clase creada exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # --- MÉTODOS QUE FALTABAN Y CAUSABAN EL ERROR ---

  def edit
    # @service seteado por before_action
    authorize @service # Pundit verifica si eres el dueño
  end

  def update
    authorize @service
    if @service.update(service_params)
      redirect_to @service, notice: 'Clase actualizada correctamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @service
    @service.destroy
    
    respond_to do |format|
      format.html { redirect_to services_path, notice: 'Clase eliminada.', status: :see_other }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@service) }
    end
  end

  private

  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:title, :description, :price_cents, :duration, :modality)
  end
end