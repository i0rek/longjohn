class Admin::EquipmentReservationsController < ApplicationController
  before_filter :requires_admin

  expose(:equipment_reservations) { EquipmentReservation.all.asc(:kind, :company, :model, :barcode) }
  expose(:equipment_reservation)

  def update
    if equipment_reservation.save
      redirect_to admin_equipment_reservations_path, :notice => ["Changed!", "You really changes that equipment_reservation!"]
    else
      flash.now.alert = ["Ooops!", "Something went wrong."]
      render "edit"
    end
  end

  def destroy
    if equipment_reservation.destroy
      redirect_to admin_equipment_reservations_path, notice: [
        "Destroyed!", "This Reservation was successfully destroyed."]
    end
  end
end
