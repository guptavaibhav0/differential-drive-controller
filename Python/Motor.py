import math

def getMotorCharacteristics(torque):
    # --- Power ---
    p1 =  -6.871e-17
    p2 =   2.261e-13
    p3 =   -2.45e-10
    p4 =   8.394e-08
    p5 =  -5.231e-05
    p6 =     0.06066
    p7 =     0.02498
    power = p1*torque**6 + p2*torque**5 + p3*torque**4 + p4*torque**3 + p5*torque**2 + p6*torque + p7

    # --- Current ---
    p1 = 0.00567
    p2 = 0.1646
    current = p1*torque + p2

    # --- Efficency ---
    p1 = -2.072e-20
    p2 = 9.663e-17
    p3 = -1.871e-13
    p4 = 1.946e-10
    p5 = -1.177e-07
    p6 = 4.203e-05
    p7 = -0.00869
    p8 = 0.9424
    p9 = 30.06
    efficency =  p1*torque**8 + p2*torque**7 + p3*torque**6 + p4*torque**5 + p5*torque**4 + p6*torque**3 + p7*torque**2 + p8*torque + p9

    return(current, efficency)

def getMotorVoltage(torque, omega):
    torque = torque * 10 /60
    omega*= 60
    (current, efficency) = getMotorCharacteristics(math.fabs(torque))
    r = 1.6
    K_b = 0.0057
    voltage = r * current - K_b * omega
    voltage_discretized = math.floor((voltage * 127) / 12)
    if (voltage_discretized > 60):
        voltage_discretized = 60
    elif (voltage_discretized < -60):
        voltage_discretized = -60
    return(voltage_discretized)
