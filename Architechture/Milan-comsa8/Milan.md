# AMD Epyc 7763 (Milan - Zen3) on Cosma8

## Technical specifications

| Component                   | Per-Core          | Per-CCD (8 cores) | Per-NUMA (2 CCDs)          | Per-Socket (8 CCDs) | Node (2 Sockets) |
|-----------------------------|-------------------|-------------------|----------------------------|---------------------|------------------|
| Cores                       | 1                 | 8                 | 16                         | 64                  | 128              |
| L1 Cache                    | 32 KB I + 32 KB D | 512 KB total      | 1 MB                       | 4 MB                | 8 MB             |
| L2 Cache                    | 512 KB            | 4 MB              | 8 MB                       | 32 MB               | 64 MB            |
| L3 Cache                    | —                 | 32 MB shared      | 64 MB (2 × 32 MB)          | 256 MB (8 × 32 MB)  | 512 MB           |
| Memory Channels (DDR4-3200) | —                 | —                 | 2 channels                 | 8 channels          | 16 channels      |
| NUMA Domains (NPS=4)        | —                 | —                 | 1 NUMA domain              | 4 NUMA domains      | 8 NUMA domains   |
| Topology Mapping            | —                 | 1 CCD             | 2 CCDs + 2 memory channels | 8 CCDs total        | 16 CCDs total    |

Notes:

- Base and boost clocks (representative examples across Milan SKUs):
  - PState-3: 2.45 GHz base, up to ~3.5 GHz boost
  - PState-2: 2.0 GHz base, no boost.
- Memory controllers reside in the I/O die; the CCD-to-memory affinity
  is determined by NUMA mapping.
- In NPS=4 mode, each NUMA domain contains:
  - 16 cores
  - 64 MB L3 cache
  - 2 DDR5 channels
- L3 cache is private per CCD and not shared across CCDs.
- L3 cache acts as a victim cache for L2, storing evicted lines but not
  fetching directly from DRAM (*).
- AVX2 (256-bit) on Zen3 provides 1 FMA units/core

## Peak Performance

### Double avx fma flops

Theoretical:

- cores × frequency × (fma units × fma ops) × (vector size  / dp size)
- cores × frequency × (2 × 2) × (256/64) = cores × frequency × 16

Likwid command (memory size scaled by number of cores):

``` bash
numactl --cpunodebind=0 --membind=0 likwid-perfctr -C 0-15 -g FLOPS_DP -m likwid-bench -t peakflops_avx_fma -W N:8MB:16 -i 1000
```

| Cores | NUMAs | Theoretical (GFLOP/s) | Measured (GFLOP/s) | % of Peak | Frequency (GHz) |
|-------|-------|-----------------------|--------------------|-----------|-----------------|
| 16    | 1     | 829.4                 | 820.1              | 98.88     | 3.24            |
| 64    | 4     | 2734.1                | 2686.7             | 98.27     | 2.67            |
| 128   | 8     | 5529.6                | 5371.9             | 97.15     | 2.7             |

### Single avx fma flops

Theoretical:

- cores × frequency × (fma units × fma ops) × (vector size / sp size)
- cores × frequency × (2 × 2) × (256/32) = cores × frequency × 32

Likwid command (memory size scaled for number of cores):

  ``` bash
numactl --cpunodebind=0 --membind=0 likwid-perfctr -C 0-15 -g FLOPS_SP -m likwid-bench -t peakflops_sp_avx_fma -W N:8MB:16 -i 1000
  ```

| Cores | NUMAs | Theoretical (GFLOP/s) | Measured (GFLOP/s) | % of Peak | Frequency (GHz) |
|-------|-------|-----------------------|--------------------|-----------|-----------------|
| 16    | 1     | 1658.9                | 1639.3             | 98.82     | 3.24            |
| 64    | 4     | 5468.2                | 5361.4             | 98.05     | 2.67            |
| 128   | 8     | 11059.2               | 10711.0            | 96.85     | 2.7             |

### Memory bandwidth

Theoretical:

- Per channel: DDR4-3200 → 3200 MT/s × 8 bytes = 25.6 GB/s
- Per NUMA domain (2 channels) = 51.2 GB/s

Likwid command (scaled for number of cores):

``` bash
numactl --cpunodebind=0 --membind=0 likwid-perfctr -C 0-15 -g MEM1 -m likwid-bench -t stream_mem_avx_fma -W N:8GB:16 -i 50 2>&1 | tee milan_mem1_16c.log
numactl --cpunodebind=0 --membind=0 likwid-perfctr -C 0-15 -g MEM2 -m likwid-bench -t stream_mem_avx_fma -W N:8GB:16 -i 50 2>&1 | tee milan_mem1_16c.log
```

| Cores | NUMAs | Theoretical | Measured   | % of Peak |
|-------|-------|-------------|------------|-----------|
| 16    | 1     | 51.2 GB/s   | 41.6 GB/s  | 81.25     |
| 64    | 4     | 204.8 GB/s  | 165.3 GB/s | 80.71     |
| 128   | 8     | 409.6 GB/s  | 331.4 GB/s | 80.91     |

### L2 bandwidth

Likwid command (scaled for number of cores):

``` bash
numactl --cpunodebind=0 --membind=0 likwid-perfctr -C 0-15 -g L2 -m -- likwid-bench -t load -W S0:8388608B:16 -i 50000
```

| Frequency | Core      | NUMA       |
|-----------|-----------|------------|
| 3.24 GHz  | 49.5 GB/s | 729.0 GB/s |
