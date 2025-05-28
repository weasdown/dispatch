enum VehicleType {
  dca('Double-Crewed Ambulance'),
  rrv('Rapid Response Vehicle'),
  helicopter('Air Ambulance Helicopter'),
  criticalCareCar('Critical Care Car'),
  communityFirstResponder('Community First Responder');

  const VehicleType(this.name);

  final String name;
}
