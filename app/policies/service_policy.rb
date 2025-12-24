class ServicePolicy < ApplicationPolicy
  def index?
    true # Todos pueden ver el catálogo
  end

  def show?
    true
  end

  def create?
    # Solo profesores o admins
    user.present? && (user.teacher? || user.admin?)
  end

  def update?
    # Solo el dueño o admin
    user.present? && (record.user == user || user.admin?)
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end