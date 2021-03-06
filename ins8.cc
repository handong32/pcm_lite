#include <stdio.h>
#include <unordered_map>
#include <vector>
#include <iostream>
#include <cmath>
#include <cstring>
#include <thread>         // std::thread

#include "Perf.h"
#include "Rapl.h"

#define UINT32_MAXT 0xffffffff
#define TIME_CONVERSION_khz 2899999*1000
#define CACHE_LINE_SIZE 64

int main (int argc, char * argv[]) {
  if (argc!=2) {printf("usage: main <iters> \n"); return -1;}
  uint32_t n = atoi(argv[1]);
  
  std::unordered_map<std::string, perf::PerfCounter> counters;
  perf::PerfCounter ins_retired = perf::PerfCounter{perf::PerfEvent::fixed_instructions};
  perf::PerfCounter unhalted_ref_cyc_tsc = perf::PerfCounter{perf::PerfEvent::fixed_reference_cycles};
  perf::PerfCounter llc_miss = perf::PerfCounter{perf::PerfEvent::llc_misses};

  volatile uint64_t ans;
  uint32_t num_elements = 20000000; // ~80 MB ==  ~(4 * L3 cache)
  uint32_t *arr;
  uint32_t j;
  arr = (uint32_t*) malloc (num_elements * sizeof(uint32_t));
  
  ans = 0;
  memset(arr, 0, num_elements*sizeof(uint32_t));
  for(j=0;j<num_elements;j++) {
    arr[j] = (j % 10)+1;
  }
  
  ins_retired.Start();
  unhalted_ref_cyc_tsc.Start();
  llc_miss.Start();
  rapl::RaplCounter rp = rapl::RaplCounter();
  rp.Start();
  
  uint64_t tsc_start = rdtsc();
	
  for(j=0;j<n;j++) {
    //std::this_thread::sleep_for(std::chrono::milliseconds(1));
    std::this_thread::sleep_for(std::chrono::microseconds(10));
    memcpy(arr, arr+10000000, 614*sizeof(uint32_t));
  }
  ans = arr[1024];
  
  rp.Stop();        
  ins_retired.Stop();
  unhalted_ref_cyc_tsc.Stop();
  llc_miss.Stop();

  float nrg = rp.Read();
  uint64_t ins = ins_retired.Read();
  uint64_t ref_cyc = unhalted_ref_cyc_tsc.Read();
  uint64_t llcm = llc_miss.Read();
  
  uint64_t tsc_stop = rdtsc();
  uint64_t tsc_diff = tsc_stop - tsc_start;
  float tdiff = (tsc_diff/(float)TIME_CONVERSION_khz)/1000000.0;
  
  rp.Clear();
  printf("%lu,%.3lf,%.3lf,%lu,%lu,%lu\n", ans, nrg, tdiff, ins, ref_cyc, llcm);

  free(arr);
  return 0; 
}
