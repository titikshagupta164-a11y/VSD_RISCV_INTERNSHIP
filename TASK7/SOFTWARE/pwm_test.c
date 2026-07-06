### PWM Register Definitions (`io.h`)

```c
#define IO_PWM_CTRL      64
#define IO_PWM_PERIOD    68
#define IO_PWM_DUTY      72
#define IO_PWM_STATUS    76
```
### `pwm_test.c`

```c
#include "io.h"

/*
 * ---------------------------------------------------------
 * PWM Peripheral Test
 * ---------------------------------------------------------
 * Configures the PWM peripheral through memory-mapped I/O.
 *
 * PERIOD = 100 clock cycles
 * DUTY   = 40 clock cycles
 * CTRL   = 1 (Enable PWM)
 * ---------------------------------------------------------
 */

int main(void)
{
    /* Configure PWM period */
    IO_OUT(IO_PWM_PERIOD, 100);

    /* Configure PWM duty cycle */
    IO_OUT(IO_PWM_DUTY, 40);

    /* Enable PWM */
    IO_OUT(IO_PWM_CTRL, 1);

    /* Keep the PWM running */
    while (1);

    return 0;
}
```
