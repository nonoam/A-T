# app/models/user.rb
class User < ApplicationRecord
  # Módulos de Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Definición de Roles (Enum es más rápido y limpio que Rolify para 3 roles fijos)
  enum :role, { student: 0, teacher: 1, admin: 2 }, default: :student

  # Relaciones
  has_many :services, dependent: :destroy # Solo si es profesor
  has_many :bookings, dependent: :destroy # Sus reservas como estudiante
  has_many :teacher_bookings, through: :services, source: :bookings # Reservas recibidas como profesor

  # Validaciones
  validates :role, presence: true

  # Helper visual
  def full_name
    "#{first_name} #{last_name}"
  end
end