class Booking < ApplicationRecord
  # Cambiamos 'student' por 'user' para que coincida con el controlador
  belongs_to :user
  belongs_to :service

  enum :status, { pending: 0, confirmed: 1, cancelled: 2 }, default: :pending

  # Validaciones
  validates :start_time, :end_time, presence: true
  validate :end_date_after_start_date
  validate :no_overlapping_bookings

  # PROCESO AUTOMÁTICO: Calcula el fin de la clase antes de validar
  before_validation :set_end_time, on: :create

  private

  def set_end_time
    return unless start_time.present? && service.present?
    self.end_time = start_time + service.duration.minutes
  end

  def end_date_after_start_date
    return if end_time.blank? || start_time.blank?
    errors.add(:end_time, "debe ser después del inicio") if end_time <= start_time
  end

  def no_overlapping_bookings
    return if start_time.blank? || end_time.blank?

    overlaps = Booking.where(service_id: service_id)
                      .where.not(id: id)
                      .where("start_time < ? AND end_time > ?", end_time, start_time)
                      .exists?

    if overlaps
      errors.add(:base, "Este horario ya está reservado. Por favor elige otro.")
    end
  end
end