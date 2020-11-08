/*
 *	ECE 4305L - EXP #11 "Temperature Reading"
 *
 *	APPLICATION FILE FOR READING THE TEMPERATURE FROM THE ADT7420 ONBOARD TEMPERATURE SENSOR:
 *
 *	AUTHOR: KYLE A. MONTESANTI
 */

// required libraries for application file:
#include "chu_init.h"
#include "gpio_cores.h"
#include "sseg_core.h"
#include "i2c_core.h"

// define any function prototypes:
void btn_ctrl(DebounceCore);
void temp_control(I2cCore, SsegCore);
void init_system(SsegCore);


// array for turning each 7-Segment Display off:
const uint8_t off_ptn[]={0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff};	// all off encodings
int btn_val = 0;												// constant button value reading for operations

// control the button operations:
void btn_ctrl(DebounceCore *btn_p)
{
	// keep an integer for operations for real-time results:
	if (btn_p -> read_db(0))
		btn_val = 1;

	else if (btn_p -> read_db(2))
		btn_val = 2;

	else if (btn_p -> read_db(3))
		btn_val = 3;

	else if (btn_p -> read_db(1))
		btn_val = 0;
}

// function to initialize the system:
void init_system(SsegCore *sseg_p)
{
	// initialize system with display off:
	sseg_p -> set_dp(0x00);										// ensure all decimal points are off
	sseg_p -> write_8ptn((uint8_t *)off_ptn);					// turn the display off
}


// function to read the temperature data and provide the required output specified by directions:
void temp_control(I2cCore *adt7420_p, SsegCore *sseg_p)
{
	const uint8_t DEV_ADDR = 0x4b;								// device address for ADT7420 temperature sensor

	uint8_t wbytes[2], bytes[2];								// arrays for writing/reading data
	uint16_t temp;
	float temp_c, temp_f;										// variables for celsius temperature and farhenheit temperature

	// variables for isolating the decimal values of the temperature:
	int c_tenths, c_hundths, c_ones, c_tens;
	int f_tenths, f_hundths, f_ones, f_tens;

	// read the device ID to verify the connection and proper communication location:
	wbytes[0] = 0x0b;											// location of ID for ADT7420 register
	adt7420_p -> write_transaction(DEV_ADDR, wbytes, 1, 1);		// write transaction then restart
	adt7420_p -> read_transaction(DEV_ADDR, bytes, 1, 0);		// read transaction

	// access the temperature information from the sensor:
	wbytes[0] = 0x00;											// location of base information for the temperature values
	adt7420_p->write_transaction(DEV_ADDR, wbytes, 1, 1);		// write transaction then restart
	adt7420_p->read_transaction(DEV_ADDR, bytes, 2, 0);			// read into the array

	// perform an automatic celsius conversion:
	temp = (uint16_t) bytes[0];									// cast 8-bit value into 16-bit integer value
	temp = (temp << 8) + (uint16_t) bytes[1];					// pack data accordingly (Reg 0 -> Upper Byte ; Reg 1 -> Lower Byte)
	temp = temp >> 3;											// right shift since 13 bits

	// calculate the temperature value in celsius as default:
	temp_c = (float) temp / 16;									// equation for a positive value
	temp_f = (temp_c * 1.8) + 32.0;								// convert to fahrenheit value

	/*uart.disp("temperature (C): ");
	uart.disp(temp_c);
	uart.disp("\n\r");

	uart.disp("temperature (F): ");
	uart.disp(temp_f);
	uart.disp("\n\r");*/

	// isolate the values:
	c_tens = (int) (temp_c / 10.0);							// isolate the ten's place
	c_ones = (int) (temp_c) % 10;							// isolate the one's place
	c_tenths = (int) (temp_c * 10) % 10;					// isolate the tenth's place
	c_hundths = (int) (temp_c * 100) % 10;					// isolate the hundredth's place

	f_tens = (int) (temp_f / 10.0);							// isolate the ten's place
	f_ones = (int) (temp_f) % 10;							// isolate the one's place
	f_tenths = (int) (temp_f * 10) % 10;					// isolate the tenth's place
	f_hundths = (int) (temp_f * 100) % 10;					// isolate the hundredth's place


	// determine the control operation for which output to display to user:
	if (btn_val == 1)
	{
		// up button (BTN 0) indicates only celsius output:
		sseg_p -> set_dp(0x40);									// turn appropriate decimal point on

		// write the celsius values to the sseg:
		sseg_p -> write_1ptn(sseg_p->h2s(12), 3);				// output "C" for unit
		sseg_p -> write_1ptn(sseg_p->h2s(c_hundths), 4);		// cast values to the 7-seg display
		sseg_p -> write_1ptn(sseg_p->h2s(c_tenths), 5);
		sseg_p -> write_1ptn(sseg_p->h2s(c_ones), 6);
		sseg_p -> write_1ptn(sseg_p->h2s(c_tens), 7);

		// ensure the other segments are off as well:
		for (int i = 0; i < 3; i++)
		{
			sseg_p -> write_1ptn(0xff, i);
		}
	}

	else if (btn_val == 2)
	{
		// down button (BTN 2) indicates only fahrenheit output:
		sseg_p -> set_dp(0x40);									// turn appropriate decimal point on

		// write the fahrenheit values to the sseg:
		sseg_p -> write_1ptn(sseg_p->h2s(15), 3);				// output "F" for unit
		sseg_p -> write_1ptn(sseg_p->h2s(f_hundths), 4);		// cast values to the 7-seg display
		sseg_p -> write_1ptn(sseg_p->h2s(f_tenths), 5);
		sseg_p -> write_1ptn(sseg_p->h2s(f_ones), 6);
		sseg_p -> write_1ptn(sseg_p->h2s(f_tens), 7);

		// ensure the other segments are off as well:
		for (int i = 0; i < 3; i++)
		{
			sseg_p -> write_1ptn(0xff, i);
		}

	}

	else if (btn_val == 3)
	{
		// left button (BTN 3) indicates both fahrenheit and celsius output:
		sseg_p -> set_dp(0x44);									// turn appropriate decimal point on

		// wirte the celsius values to the sseg:
		sseg_p -> write_1ptn(sseg_p->h2s(c_hundths), 0);		// cast values to the 7-seg display
		sseg_p -> write_1ptn(sseg_p->h2s(c_tenths), 1);
		sseg_p -> write_1ptn(sseg_p->h2s(c_ones), 2);
		sseg_p -> write_1ptn(sseg_p->h2s(c_tens), 3);

		// write the fahrenheit values to the sseg:
		sseg_p -> write_1ptn(sseg_p->h2s(f_hundths), 4);		// cast values to the 7-seg display
		sseg_p -> write_1ptn(sseg_p->h2s(f_tenths), 5);
		sseg_p -> write_1ptn(sseg_p->h2s(f_ones), 6);
		sseg_p -> write_1ptn(sseg_p->h2s(f_tens), 7);
	}

	else if (btn_val == 0)
	{
		// right button (BTN 1) indicates the display is off:
		sseg_p -> set_dp(0x00);									// ensure all decimal points are off
		sseg_p -> write_8ptn((uint8_t *)off_ptn);				// turn the display off
	}

}


// instantiate objects of the required classes:
DebounceCore btn(get_slot_addr(BRIDGE_BASE, S7_BTN));
SsegCore sseg(get_slot_addr(BRIDGE_BASE, S8_SSEG));
I2cCore adt7420(get_slot_addr(BRIDGE_BASE, S10_I2C));

// main function:
int main()
{
	init_system(&sseg);

	// infinitely loop the following function:
	while (1)
	{
		btn_ctrl(&btn);
		temp_control(&adt7420, &sseg);
	}
}


