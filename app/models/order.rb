class Order < ActiveRecord::Base
  validates :order_date, presence: true

  validate :order_date_not_in_the_past, on: :create
  validate :should_not_be_updated, if: :locked?

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
private
  def order_date_not_in_the_past
    errors.add :order_date, 'past date' unless self.order_date.nil? or self.order_date >= Date.today
  end

  def should_not_be_updated
    if order_date_changed? or vat_changed?
      errors.add :base, 'cannot be updated with this status'
    end
  end

  def prevent_destroy
    raise 'Orders cannot be destroyed'
  end  
end
