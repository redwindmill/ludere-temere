`linux` `arduino-mk` `arduino`

[ARDUINO](https://www.arduino.cc/) PROJECTS
================================================================
A template Arduino sketch repository that uses [arduino-mk](https://github.com/sudar/Arduino-Makefile).

Run `make help` for more information.

UNO-PINS
----------------------------------------------------------------
```
AREF        - Analog reference, in for reference voltage (external power)
GND         - Ground
3V3         - 3.3 volts
5V          - 5 volts

RESET       - reset arduno
IOREF       - voltage reference for the board

00(RX)      - IOPORT(D) PCINT(16) PCMSK2(0) DIGITAL      FTDI-R
01(TX)      - IOPORT(D) PCINT(17) PCMSK2(1) DIGITAL TRIG FTDI-W
02(IRQ0)    - IOPORT(D) PCINT(18) PCMSK2(2) DIGITAL TRIG
03(IRQ1)    - IOPORT(D) PCINT(19) PCMSK2(3) DIGITAL PWM(2)
04          - IOPORT(D) PCINT(20) PCMSK2(4) DIGITAL
05          - IOPORT(D) PCINT(21) PCMSK2(5) DIGITAL PWM(0)
06          - IOPORT(D) PCINT(22) PCMSK2(6) DIGITAL PWM(0)
07          - IOPORT(D) PCINT(23) PCMSK2(7) DIGITAL
08          - IOPORT(B) PCINT(00) PCMSK0(0) DIGITAL
09          - IOPORT(B) PCINT(01) PCMSK0(1) DIGITAL PWM(1)
10(SS)      - IOPORT(B) PCINT(02) PCMSK0(2) DIGITAL PWM(1) SPI
11(MOSI)    - IOPORT(B) PCINT(03) PCMSK0(3) DIGITAL PWM(2) SPI
12(MISO)    - IOPORT(B) PCINT(04) PCMSK0(4) DIGITAL        SPI
13(SCK)     - IOPORT(B) PCINT(05) PCMSK0(5) DIGITAL        SPI
14(A0)      - IOPORT(C) PCINT(08) PCMSK1(0) DIGITAL ADC
15(A1)      - IOPORT(C) PCINT(09) PCMSK1(1) DIGITAL ADC
16(A2)      - IOPORT(C) PCINT(10) PCMSK1(2) DIGITAL ADC
17(A3)      - IOPORT(C) PCINT(11) PCMSK1(3) DIGITAL ADC
18(A4)      - IOPORT(C) PCINT(12) PCMSK1(4) DIGITAL ADC TWI
19(A5)      - IOPORT(C) PCINT(13) PCMSK1(5) DIGITAL ADC TWI

IOPORT: IO port of the ATMEGA chip
PCINT:  Pin Change Interrupt number
PCMSK:  Pin Change Interrupt mask and bit

DIGITAL:
    pinMode()
    digitalWrite()
    digitalRead()

ANALOG:
    PWN: Duty
        Write()

    ADC: 10bit (expects the pin numbering scheme in the alias)
        Read()

TWI: I^2C (Multiple pins must be used in conjunction)
    Wire.send()

SPI: High Speed (Multiple pins must be used in conjunction)
    Spi
    .transfer()

TRIG: triggers
    attach
    .transfer()

FTDI-W: +usb
    Serial
    .print()

FTDI-R: +usb
    Serial
    .read
```

UNO-DATA TYPES
----------------------------------------------------------------
```
bool    - 8 bit
byte    - 8 bit (0-255)
char    - 8 bit (-128 to 127)
word    - 16 bit (0-65,535)
int     - 16 bit (-32768 to 32767)
ulong   - 32 bit (0-4,294,967,295)
long    - 32 bit (-2,147,483,648 to 2,147,483,647)
float   - 32 bit (-3.4028235E38 to 3.4028235E38) *not native
```
