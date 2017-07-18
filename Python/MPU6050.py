import smbus
import math

class MPU6050:
    # Power management registers
    power_mgmt_1 = 0x6b
    power_mgmt_2 = 0x6c

    def __init__(self, bus, address):
        self.bus = bus
        self.address = address
        
        self.bus.write_byte_data(self.address, self.power_mgmt_1, 0)
        
    def read_byte(self, adr):
        return self.bus.read_byte_data(self.address, adr)

    def read_word(self, adr):
        high = self.bus.read_byte_data(self.address, adr)
        low = self.bus.read_byte_data(self.address, adr+1)
        val = (high << 8) + low
        return val

    def read_word_2c(self, adr):
        val = self.read_word(adr)
        if (val >= 0x8000):
            return -((65535 - val) + 1)
        else:
            return val

    def getX(self):
        gyro_xout = self.read_word_2c(0x43) / 131
        return(gyro_xout)

    def getY(self):
        gyro_yout = self.read_word_2c(0x45) / 131
        return(gyro_yout)

    def getZ(self):
        gyro_zout = self.read_word_2c(0x47) / 131
        return(gyro_zout)

    def getXaccel(self):
        accel_xout = self.read_word_2c(0x3b) / 16384.0
        return(accel_xout)

    def getYaccel(self):
        accel_yout = self.read_word_2c(0x3d) / 16384.0
        return(accel_yout)

    def getZaccel(self):
        accel_zout = self.read_word_2c(0x3f) / 16384.0
        return(accel_zout)
