enum CommandType {
  lock,
  unlock,
  disable,
  enable,
  honk,
  lightsOn,
  lightsOff;

  String get label {
    switch (this) {
      case CommandType.lock:
        return 'Lock';
      case CommandType.unlock:
        return 'Unlock';
      case CommandType.disable:
        return 'Disable';
      case CommandType.enable:
        return 'Enable';
      case CommandType.honk:
        return 'Honk';
      case CommandType.lightsOn:
        return 'Lights On';
      case CommandType.lightsOff:
        return 'Lights Off';
    }
  }

  String get mqttValue {
    switch (this) {
      case CommandType.lock:
        return 'lock';
      case CommandType.unlock:
        return 'unlock';
      case CommandType.disable:
        return 'disable';
      case CommandType.enable:
        return 'enable';
      case CommandType.honk:
        return 'honk';
      case CommandType.lightsOn:
        return 'lights_on';
      case CommandType.lightsOff:
        return 'lights_off';
    }
  }
}
