/*
 * This example shows how get values from a GPIO 
 * configured as an input.
 */

#include <stdio.h>
#include <rt/rt_api.h>
#include <stdint.h>

#define LED0 5
#define LED1 9
#define LED2 10
#define LED3 11

#define SW 12

int __rt_fpga_fc_frequency = 20000000;
int __rt_fpga_periph_frequency = 10000000;

int main()
{
	printf("Hello, GPIO test\n");

	rt_pad_set_function(SW, 1);
	
	rt_pad_set_function(LED0, 1);
	rt_pad_set_function(LED2, 1);

  // GPIO initialization
	rt_gpio_init(0, SW);
	rt_gpio_init(0, LED0);
	rt_gpio_init(0, LED2);

  // Configure GPIO as an inpout
    rt_gpio_set_dir(0, 1<<SW, RT_GPIO_IS_IN);
	rt_gpio_set_dir(0, 1<<LED0, RT_GPIO_IS_OUT);
	rt_gpio_set_dir(0, 1<<LED2, RT_GPIO_IS_OUT);

	int sw_val=0;
		
	while(1) {
		sw_val = rt_gpio_get_pin_value(0, SW);
		if(sw_val==0) {
			printf("LED0 is blinking\n\n");
			rt_gpio_set_pin_value(0, LED0, 1);
			rt_time_wait_us(1);
			rt_gpio_set_pin_value(0, LED0, 0);
			rt_time_wait_us(1);
		}
		else {
			printf("LED2 is blinking\n\n");
			rt_gpio_set_pin_value(0, LED2, 1);
			rt_time_wait_us(1);
			rt_gpio_set_pin_value(0, LED2, 0);
			rt_time_wait_us(1);
		}
	}

  return 0;
}
