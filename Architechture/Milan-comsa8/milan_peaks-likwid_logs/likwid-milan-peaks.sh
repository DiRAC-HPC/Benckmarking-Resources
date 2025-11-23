# DP FLOP/s (no AVX or FMA) - FLOPS_DP is used, but on Milan (Zen3) FLOPS_DP and FLOPS_SP so either can be used.
numactl --cpunodebind=0 --membind=0 likwid-perfctr -C 0-15 -g FLOPS_DP -m likwid-bench -t peakflops -W N:8MB:16 -i 5000 2>&1 | tee milan_flops_dp_16c.log
numactl --cpunodebind=0-3 --membind=0-3 likwid-perfctr -C 0-63 -g FLOPS_DP -m likwid-bench -t peakflops -W N:32MB:64 -i 5000 2>&1 | tee milan_flops_dp_64c.log
numactl --cpunodebind=0-7 --membind=0-7 likwid-perfctr -C 0-127 -g FLOPS_DP -m likwid-bench -t peakflops -W N:64MB:128 -i 5000 2>&1 | tee milan_flops_dp_128c.log

# SP FLOP/s (no AVX or FMA) - FLOPS_SP is used, but on Milan (Zen3) FLOPS_DP and FLOPS_SP so either can be used.
numactl --cpunodebind=0 --membind=0 likwid-perfctr -C 0-15 -g FLOPS_SP -m likwid-bench -t peakflops_sp -W N:8MB:16 -i 5000 2>&1 | tee milan_flops_sp_16c.log
numactl --cpunodebind=0-3 --membind=0-3 likwid-perfctr -C 0-63 -g FLOPS_SP -m likwid-bench -t peakflops_sp -W N:32MB:64 -i 5000 2>&1 | tee milan_flops_sp_64c.log
numactl --cpunodebind=0-7 --membind=0-7 likwid-perfctr -C 0-127 -g FLOPS_SP -m likwid-bench -t peakflops_sp -W N:64MB:128 -i 5000 2>&1 | tee milan_flops_sp_128c.log

# DP FLOP/s (with AVX2 and FMA) - FLOPS_DP is used, but on Milan (Zen3) FLOPS_DP and FLOPS_SP so either can be used.
numactl --cpunodebind=0 --membind=0 likwid-perfctr -C 0-15 -g FLOPS_DP -m likwid-bench -t peakflops_avx_fma -W N:8MB:16 -i 5000 2>&1 | tee milan_flops_dp_avx_fma_16c.log
numactl --cpunodebind=0-3 --membind=0-3 likwid-perfctr -C 0-63 -g FLOPS_DP -m likwid-bench -t peakflops_avx_fma -W N:32MB:64 -i 5000 2>&1 | tee milan_flops_dp_avx_fma_64c.log
numactl --cpunodebind=0-7 --membind=0-7 likwid-perfctr -C 0-127 -g FLOPS_DP -m likwid-bench -t peakflops_avx_fma -W N:64MB:128 -i 5000 2>&1 | tee milan_flops_dp_avx_fma_128c.log

# SP FLOP/s (with AVX2 and FMA) - FLOPS_SP is used, but on Milan (Zen3) FLOPS_DP and FLOPS_SP so either can be used.
numactl --cpunodebind=0 --membind=0 likwid-perfctr -C 0-15 -g FLOPS_SP -m likwid-bench -t peakflops_sp_avx_fma -W N:8MB:16 -i 5000 2>&1 | tee milan_flops_sp_avx_fma_16c.log
numactl --cpunodebind=0-3 --membind=0-3 likwid-perfctr -C 0-63 -g FLOPS_SP -m likwid-bench -t peakflops_sp_avx_fma -W N:32MB:64 -i 5000 2>&1 | tee milan_flops_sp_avx_fma_64c.log
numactl --cpunodebind=0-7 --membind=0-7 likwid-perfctr -C 0-127 -g FLOPS_SP -m likwid-bench -t peakflops_sp_avx_fma -W N:64MB:128 -i 5000 2>&1 | tee milan_flops_sp_avx_fma_128c.log

# Memory bandwidth for channels 1-4 (stream memory with AVX and FMA for consistancy) - MEM1 on Milan (Zen3) is only for channels 1-4 so MEM2 also has to be ran and summed.
numactl --cpunodebind=0 --membind=0 likwid-perfctr -C 0-15 -g MEM1 -m likwid-bench -t stream_mem_avx_fma -W N:8GB:16 -i 50 2>&1 | tee milan_mem1_16c.log
numactl --cpunodebind=0-3 --membind=0-3 likwid-perfctr -C 0-63 -g MEM1 -m likwid-bench -t stream_mem_avx_fma -W N:32GB:64 -i 50 2>&1 | tee milan_mem1_64c.log
numactl --cpunodebind=0-7 --membind=0-7 likwid-perfctr -C 0-127 -g MEM1 -m likwid-bench -t stream_mem_avx_fma -W N:64GB:128 -i 50 2>&1 | tee milan_mem1_128c.log

# Memory bandwidth for channels 5-8 (stream memory with AVX and FMA for consistancy) - MEM3 on Milan (Zen3) is only for channels 5-8 so MEM1 also has to be ran and summed.
numactl --cpunodebind=0 --membind=0 likwid-perfctr -C 0-15 -g MEM2 -m likwid-bench -t stream_mem_avx_fma -W N:8GB:16 -i 50 2>&1 | tee milan_mem2_16c.log
numactl --cpunodebind=0-3 --membind=0-3 likwid-perfctr -C 0-63 -g MEM2 -m likwid-bench -t stream_mem_avx_fma -W N:32GB:64 -i 50 2>&1 | tee milan_mem2_64c.log
numactl --cpunodebind=0-7 --membind=0-7 likwid-perfctr -C 0-127 -g MEM2 -m likwid-bench -t stream_mem_avx_fma -W N:64GB:128 -i 50 2>&1 | tee milan_mem2_128c.log

# L2 cache (load from memory) - L2 on Milan (Zen3) measures the memory bandwidth from L2 -> CPU; data size used exactly to fill L2 cache of 2 CCDs (1 NUMA domain).
numactl --cpunodebind=0 --membind=0 likwid-perfctr -C 0-15 -g L2 -m likwid-bench -t load -W S0:8388608B:16 -i 50000 2>&1 | tee milan_l2_16c
