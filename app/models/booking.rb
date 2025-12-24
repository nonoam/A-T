# app/models/booking.rb
class Booking < ApplicationRecord
  belongs_to :student, class_name: 'User', foreign_key: 'user_id'
  belongs_to :service

  enum :status, { pending: 0, confirmed: 1, cancelled: 2 }, default: :pending

  validates :start_time, :end_time, presence: true
  validate :end_date_after_start_date
  validate :no_overlapping_bookings

  private

  def end_date_after_start_date
    return if end_time.blank? || start_time.blank?
    errors.add(:end_time, "debe ser después del inicio") if end_time <= start_time
  end

  def no_overlapping_bookings
    return if start_time.blank? || end_time.blank?

    # Lógica de Superposición:
    # (StartA < EndB) y (EndA > StartB)
    overlaps = Booking.where(service_id: service_id)
                      .where.not(id: id) # Excluirse a sí mismo (para ediciones)
                      .where("start_time < ? AND end_time > ?", end_time, start_time)
                      .exists?

    if overlaps
      errors.add(:base, "Este horario ya está reservado. Por favor elige otro.")
    end
  end
end