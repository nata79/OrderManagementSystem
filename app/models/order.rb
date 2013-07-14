class Order < ActiveRecord::Base
  has_many :transitions, class_name: 'StatusTransition'
  has_many :line_items

  validates :order_date, :vat, presence: true

  validate :order_date_not_in_the_past, on: :create
  validate :should_not_be_updated, if: :locked?

  before_validation :set_vat_default

  before_destroy :prevent_destroy

  state_machine :status, initial: :draft do
    event :place do
      transition :draft => :placed
    end

    event :cancel do
      transition [:draft, :placed] => :canceled
    end

    event :pay do
      transition :placed => :payed
    end
  end

  def locked?
    self.placed? or self.payed?
  end

  def status_after_event event
    self.status_transitions.select{ |t| t.event == event }.first.try(:to)
  end

  def net_total
    @net_total ||=
      self.line_items.map(&:net_price).reduce(&:+) or Money.new(0)
  end

  def gross_total
    @gross_total ||=
      self.net_total + self.net_total * self.vat
  end
private
  def order_date_not_in_the_past
    errors.add :order_date, 'past date' unless self.order_date.nil? or self.order_date >= Date.today
  end

  def should_not_be_updated
    if order_date_changed? or vat_changed?
      errors.add :base, 'cannot be updated with this status'
    end
  end

  def set_vat_default
    self.vat ||= (VAT or 0.2)
  end

  def prevent_destroy
    raise 'Orders cannot be destroyed'
  end  
end
