#include <stdio.h>
#include <inttypes.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "ppg_data.h"

/*
	Based on Jacek Wieczorek's https://github.com/jacajack/usynth

	Proof of concept implementation of PPG Wave wavetable synthesis and waveform interpolation
*/

#define WAVETABLE_SIZE 61
#define SAMPLING_FREQ 20000

typedef struct wavetable_slot {
	uint8_t is_pure;
	uint8_t *ptr_l;
	uint8_t *ptr_r;
	uint8_t factor;
} wavetable_slot;


static inline const uint8_t* load_wavetable(wavetable_slot *slots, uint8_t wavetable_size, const uint8_t *wavetable_def)
{

	memset(slots, 0, wavetable_size * sizeof(wavetable_slot));
	
	//Skip first byte (wavetable number)
	wavetable_def++;

	uint8_t waveform, pos;

	do
	{
		waveform = *wavetable_def++;
		pos = *wavetable_def++;

		//Multiply by 64 samples in wave (ppg_waveforms_data consists of waveform numbers)
		slots[pos].ptr_l = ppg_waveforms_data + (waveform << 6);
		slots[pos].ptr_r = NULL;
		slots[pos].is_pure = 1;
		slots[pos].factor = 0;
	}
	while (pos < wavetable_size - 1);

	//Generate interpolation factors
	const wavetable_slot *left_pure = NULL, *right_pure = NULL;
	for (uint8_t i = 0; i < wavetable_size; i++)
	{
		if (slots[i].is_pure)
		{
			left_pure = &slots[i];
			right_pure = &slots[i];
			
			//Search for the next pure-wave
			for (uint8_t j = i + 1; j < wavetable_size; j++)
			{
				if (slots[j].is_pure)
				{
					right_pure = &slots[j];
					break;
				}
			}
		}

		//Total distance between known pure waves and distance from the left one to current slot
		uint8_t total_distance = right_pure - left_pure;
		uint8_t left_distance = &slots[i] - left_pure;

		slots[i].ptr_l = left_pure->ptr_l;
		slots[i].ptr_r = right_pure->ptr_l;

		if (total_distance == 0)
			slots[i].factor = 0;
		else
		 	slots[i].factor = (65535 / total_distance * left_distance) >> 8;
		
	}

	//Pointer to the next wavetable
	return wavetable_def;
}

static inline const uint8_t* load_n_wavetable(wavetable_slot *slots, uint8_t wavetable_size, uint8_t n)
{
	uint16_t offset = ppg_wavetable_offsets[n];
	return load_wavetable(slots, wavetable_size, ppg_wavetable_data + offset);
}

static inline uint8_t phase2sample(const uint8_t *waveforms_data, uint16_t phase2b)
{
	uint8_t phase = ((uint8_t*) &phase2b)[1] >> 1; //Get 7 most significant bits
	uint8_t half_select = phase & 64; //0 or 1
	phase &= 63; // Modulo 63

	if (half_select)
		return *(waveforms_data + phase);
	else
		return 255u - *(waveforms_data + 63u - phase);
}

static inline uint8_t get_wavetable_sample (const wavetable_slot *slot, uint16_t phase2b)
{
	uint8_t sample_l = phase2sample(slot->ptr_l, phase2b);
	uint8_t sample_r = phase2sample(slot->ptr_r, phase2b);
	uint8_t factor = slot->factor; 
	uint8_t mix_l = (256 - factor) * sample_l >> 8;
	uint8_t mix_r = factor * sample_r >> 8;
	return mix_l + mix_r;
}

int main( )
{
	wavetable_slot *slots = calloc(WAVETABLE_SIZE, sizeof(wavetable_slot));
	
	//29 wavetables available
	load_n_wavetable(slots, WAVETABLE_SIZE, 18);

	while ( 1 )
	{
		//NCO
		static uint16_t phase = 0;
		static float f = 62;
		uint16_t phase_step = 65536 * f / SAMPLING_FREQ;

		//Wavetable sweep
		static uint32_t cnt = 0;
		static float t = 0;
		cnt++;
		t = (float)cnt / SAMPLING_FREQ;
		//Ranging <-30;30>
		int8_t sinus = 30 * sin(t);

		uint8_t sample = get_wavetable_sample (slots + 30 + sinus, phase);	 

		putchar(sample);
		phase += phase_step;
	}

	return 0;
}