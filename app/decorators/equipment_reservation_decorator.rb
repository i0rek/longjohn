class EquipmentReservationDecorator < ApplicationDecorator
  decorates :equipment_reservation

  # Accessing Helpers
  #   You can access any helper via a proxy
  #
  #   Normal Usage: helpers.number_to_currency(2)
  #   Abbreviated : h.number_to_currency(2)
  #
  #   Or, optionally enable "lazy helpers" by calling this method:
  #     lazy_helpers
  #   Then use the helpers with no proxy:
  #     number_to_currency(2)

  # Defining an Interface
  #   Control access to the wrapped subject's methods using one of the following:
  #
  #   To allow only the listed methods (whitelist):
  #     allows :method1, :method2
  #
  #   To allow everything except the listed methods (blacklist):
  #     denies :method1, :method2

  # Presentation Methods
  #   Define your own instance methods, even overriding accessors
  #   generated by ActiveRecord:
  #
  #   def created_at
  #     h.content_tag :span, time.strftime("%a %m/%d/%y"),
  #                   :class => 'timestamp'
  #   end

  def labels
    "#{pickup_label}&nbsp;#{return_label}".html_safe
  end

  def pickup_label
    if all_picked_up_barcodes.present?
      if pickup_warning
        h.content_tag(:span, "Pick Up", class: "label label-warning")
      else
        h.content_tag(:span, "Pick Up", class: "label label-success")
      end
    end
  end

  def return_label
    if all_returned_barcodes.present?
      if return_warning
        h.content_tag(:span, "Return", class: "label label-warning")
      else
        h.content_tag(:span, "Return", class: "label label-success")
      end
    end
  end
end
