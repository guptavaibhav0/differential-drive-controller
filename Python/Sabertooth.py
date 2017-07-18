import serial
from time import sleep

class Sabertooth:
    clamp = lambda self, n, minn, maxn: max(min(maxn, n), minn)
    
    def __init__(self, address, serialPort):
        self._address = address
        self._port = serialPort

    def command(self, cmd, value):
        self._port.write(bytes([self._address]))
        self._port.write(bytes([cmd]))
        self._port.write(bytes([value]))
        self._port.write(bytes([(self._address + cmd + value) & 127]))

    def throttleCommand(self, cmd, power):
        power = self.clamp(power,-126,126)
        if power < 0:
            power = -power
        self.command(cmd, power)
  
    def motor(self, motor, power):
        if (motor < 1 or motor > 2):
            return
        motorByte = 4 if (motor == 2) else 0
        powerByte = 1 if (power < 0) else 0
        self.throttleCommand(motorByte + powerByte, power)

    def stop(self):
        self.motor(1, 0);
        self.motor(2, 0);
  
    def setMinVoltage(self, value):
        self.command(2, min(value, 120))

    def setMaxVoltage(self, value):
        self.command(3, min(value, 127))

    def setBaudRate(self, baudRate):
        switcher = {
            2400: 1,
            9600: 2,
            19200: 3,
            38400: 4,
            115200: 5,
        }
        value = switcher.get(baudRate, 9600)
        self.command(15, value);
        sleep(0.5);

    def setDeadband(self, value):
        self.command(17, min(value, 127));

    def setRamping(self, value):
        self.command(16, self.clamp(value, 0, 80));
