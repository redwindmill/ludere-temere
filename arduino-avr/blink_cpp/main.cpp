#include <Arduino.h>

#define ONBOARD_LED 13
#define BLINK_TIME_ON_MS 500
#define BLINK_TIME_OFF_MS 5000
//-----------------------------------------------------------------------------//

void setup() {
	pinMode(ONBOARD_LED, OUTPUT);
}

//-----------------------------------------------------------------------------//

int main(void) {
	init();
	setup();

	for (;;) {
		digitalWrite(ONBOARD_LED, HIGH);	// set the LED on
		delay(BLINK_TIME_ON_MS);			// wait
		digitalWrite(ONBOARD_LED, LOW);		// set the LED off
		delay(BLINK_TIME_OFF_MS);			// wait
	}
}
