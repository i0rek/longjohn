class Model
  attr_accessor :model, :company, :kind, :users, :available_devices, :total_devices

  def initialize(model='', company='', kind='')
    @model = model
    @company = company
    @kind = kind
    @total_devices = 0
    @available_devices = 0
    @users = []
  end

  def self.all
    from_devices(Device.all)
  end

  def self.from_devices devices
    {}.tap do |models|
      devices.each do |device|
        key = "#{device.kind}_#{device.company}_#{device.model}"
        models[key] ||= device.cast_to_model
        models[key].total_devices += 1
        models[key].available_devices += 1
      end
    end.values.flatten
  end

  def self.in from, to
    Model.all.tap do |models|
      EquipmentReservation.in(from, to).each do |reservation|
        reservation.reservations.each do |r|
          model = models.find{|model| model.equal_to_reservation(r) }
          model.apply_reservation(r, reservation.user) if model
        end
      end
    end.compact
  end

  def devices
    Device.where(kind: @kind, company: @company, model: @model)
  end

  def available_devices
    @available_devices < 0 ? 0 : @available_devices
  end

  def ==(other)
    return false unless other.is_a?(self.class)
    self.model == other.model && self.company == other.company && self.kind == other.kind
  end

  def apply_reservation(reservation, user)
    if reservation['returns'].present?
      @available_devices -= (reservation['pickups'] - reservation['returns']).size
    else
      @available_devices -= reservation['count'].to_i
    end

    users << user
  end

  def equal_to_reservation(reservation)
    return false unless reservation.is_a?(Hash)
    kind == reservation['kind'] && company == reservation['company'] && model == reservation['model']
  end

end
