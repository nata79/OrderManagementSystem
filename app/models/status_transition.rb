class StatusTransition < ActiveRecord::Base
  extend Enumerize
  
  belongs_to :order

  enumerize :event, in: [:place, :pay, :cancel]

  validates :event, :order, :from, :to, presence: true
  validates :reason, presence: true, if: :cancel?

  before_validation :set_from_status
  before_validation :set_to_status

  before_create :execute_transition

private
  def set_from_status
    self.from = order.status unless self.order.nil?
  end

  def set_to_status
    self.to = order.status_after_event(self.event.try(:to_sym)) unless self.order.nil?
  end

  def execute_transition
    self.order.fire_status_event self.event
  end

  def cancel?
    self.event == 'cancel'
  end
end
