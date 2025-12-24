class ApplicationController < ActionController::Base
  # 1. Incluimos Pundit para manejar la autorización en toda la app
  include Pundit::Authorization

  # 2. Configuración de parámetros de Devise antes de cualquier acción
  before_action :configure_permitted_parameters, if: :devise_controller?

  # 3. Manejo global de excepciones de Pundit (UX)
  # Si el usuario intenta hacer algo no permitido, lo redirigimos suavemente
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  # 4. Strong Parameters para Devise (Sanitización)
  def configure_permitted_parameters
    # Permitir datos extra al registrarse (Sign Up)
    # NOTA: Permitimos 'role' aquí para que puedan elegir ser Profesor o Estudiante.
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :bio, :role])

    # Permitir datos extra al editar su propio perfil (Account Update)
    # NOTA: Por seguridad, NO permitimos cambiar el 'role' después del registro aquí.
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :bio])
  end

  private

  # 5. Método privado para manejar la redirección por falta de permisos
  def user_not_authorized
    flash[:alert] = "No tienes autorización para realizar esta acción."
    
    # Intenta redirigir a la página anterior (referer), si no existe, va al inicio
    redirect_back(fallback_location: root_path)
  end
end