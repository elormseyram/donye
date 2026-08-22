alter table public.fleet_bikes
  add column if not exists battery_capacity_kwh numeric(7,3),
  add column if not exists nominal_voltage_v numeric(7,2),
  add column if not exists motor_power_w integer;

alter table public.fleet_bikes
  drop constraint if exists fleet_bikes_capacity_positive,
  add constraint fleet_bikes_capacity_positive
    check (battery_capacity_kwh is null or battery_capacity_kwh > 0),
  drop constraint if exists fleet_bikes_voltage_positive,
  add constraint fleet_bikes_voltage_positive
    check (nominal_voltage_v is null or nominal_voltage_v > 0),
  drop constraint if exists fleet_bikes_motor_power_positive,
  add constraint fleet_bikes_motor_power_positive
    check (motor_power_w is null or motor_power_w > 0);

create unique index if not exists rider_bike_one_active_owner
  on public.rider_bike_assignments (bike_id)
  where returned_at is null;

create unique index if not exists rider_one_active_bike
  on public.rider_bike_assignments (rider_id)
  where returned_at is null;
