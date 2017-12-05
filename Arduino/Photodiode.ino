// Ceci est le fichier concernant le laser.
#include "Photodiode.h"
#include "Constants.h"

uint16_t buf[BUFFER_NBR][NBR_PTS];

volatile int currentBufferIndex;
volatile int bufferToProcess;

volatile bool state;

// Interrupt quand le buffer est plein
void ADC_Handler(void)
{   
    // Le buffer est plein, on change de buffer
    if ((adc_get_status(ADC) & ADC_ISR_RXBUFF) == ADC_ISR_RXBUFF)
    {
        currentBufferIndex = (currentBufferIndex + 1) & BUFFER_NBR_OVERFLOW_MASK;
        ADC->ADC_RNPR = (uint32_t) buf[currentBufferIndex]; // addresse du nouveau buffer
        ADC->ADC_RNCR= NBR_PTS; // nombre de points à placer en tableau
    }

    state = !state;
    digitalWrite(52, state);
    
  
}

// configuration de l'ADC avec DMA
void setupADC_DMA()
{
    pmc_enable_periph_clk(ID_ADC);
    adc_init(ADC, SystemCoreClock, ADC_FREQ_WANTED, ADC_STARTUP_NORM);
    adc_configure_timing(ADC, TRACKING_TIME, ADC_SETTLING_TIME_3, TRANSFER_PERIOD);
    adc_configure_power_save(ADC, 0, 0);
    //adc_configure_trigger(ADC, ADC_TRIG_SW, ADC_MR_FREERUN_ON); // l'echappe
    ADC->ADC_MR |=0x80;
    ADC->ADC_CHER=0x80;
    
    NVIC_EnableIRQ(ADC_IRQn);

    ADC->ADC_IDR=~(1<<27);
    ADC->ADC_IER=1<<27;
    ADC->ADC_RPR=(uint32_t)buf[0];   // DMA buffer
    ADC->ADC_RCR=NBR_PTS;
    ADC->ADC_RNPR=(uint32_t)buf[1]; // next DMA buffer
    ADC->ADC_RNCR=NBR_PTS;
    currentBufferIndex = 1;
    bufferToProcess = 1;
    ADC->ADC_PTCR=1;
    ADC->ADC_CR=2;
    
    state = true;
    digitalWrite(52, state);
    
    //NVIC_SetPriority(ADC_IRQn, 0);

}


