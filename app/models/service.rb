class Service < ApplicationRecord
  belongs_to :user
  has_many :bookings, dependent: :destroy

  enum :modality, { online: 0, in_person: 1, hybrid: 2 }, default: :online

  # Validaciones
  validates :title, presence: true
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }
  
  # Scopes para búsqueda (usados en el controlador)
  scope :by_modality, ->(modality) { where(modality: modality) }
  scope :search_by_text, ->(query) { 
    where("title ILIKE ? OR description ILIKE ?", "%#{query}%", "%#{query}%") 
  }
end