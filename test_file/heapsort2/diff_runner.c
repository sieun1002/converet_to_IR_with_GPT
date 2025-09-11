// diff_runner.c
#define _GNU_SOURCE
#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <errno.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <limits.h>

typedef void (*heap_sort_t)(int*, size_t);

static int is_sorted(const int *a, size_t n){
  for(size_t i=1;i<n;i++) if(a[i-1]>a[i]) return 0;
  return 1;
}

static uint64_t now_ns(void){
  struct timespec ts;
#if defined(CLOCK_MONOTONIC_RAW)
  clock_gettime(CLOCK_MONOTONIC_RAW, &ts);
#else
  clock_gettime(CLOCK_MONOTONIC, &ts);
#endif
  return (uint64_t)ts.tv_sec*1000000000ull + (uint64_t)ts.tv_nsec;
}

// 간단한 FNV-1a 64비트 해시(배열 내용 요약용)
static uint64_t fnv1a64(const void *data, size_t len){
  const unsigned char *p=(const unsigned char*)data;
  uint64_t h=1469598103934665603ull;
  for(size_t i=0;i<len;i++){ h ^= p[i]; h *= 1099511628211ull; }
  return h;
}

static int write_array_txt(const char *path, const int *a, size_t n){
  FILE *f=fopen(path,"w");
  if(!f) return -1;
  for(size_t i=0;i<n;i++){
    if(i) fputc(' ', f);
    fprintf(f, "%d", a[i]);
  }
  fputc('\n', f);
  fclose(f);
  return 0;
}

static int mkdir_if_needed(const char *dir){
  if(!dir || !*dir) return 0;
  if(mkdir(dir, 0755) == 0) return 0;
  if(errno == EEXIST) return 0;
  perror("mkdir");
  return -1;
}

int main(int argc, char **argv){
  // 인자: [Ncases] [n] [seed] [outdir]
  int Ncases = (argc>1)? atoi(argv[1]) : 1000;
  size_t n   = (argc>2)? (size_t)strtoull(argv[2],NULL,10) : 100;
  unsigned int seed = (argc>3)? (unsigned int)strtoul(argv[3],NULL,10) : 0xC0FFEEu;
  const char *outdir = (argc>4)? argv[4] : "out";
  int dump_all = 0;
  const char *env = getenv("DUMP_ALL");
  if(env && strcmp(env,"0")!=0) dump_all = 1;

  if(mkdir_if_needed(outdir)!=0) return 3;

  // 요약 CSV
  char summary_path[PATH_MAX];
  snprintf(summary_path, sizeof(summary_path), "%s/summary.csv", outdir);
  FILE *csv = fopen(summary_path, "w");
  if(!csv){ perror("fopen summary.csv"); return 3; }
  setvbuf(csv, NULL, _IOLBF, 0); // 줄버퍼링

  fprintf(csv, "case,n,seed,agree,same,sorted_ref,sorted_llm,"
               "first_diff_index,ref_val,llm_val,hash_ref,hash_llm,ns_ref,ns_llm\n");

  void *A = dlopen("./ref.so", RTLD_NOW);
  void *B = dlopen("./llm.so", RTLD_NOW);
  if(!A || !B){
    fprintf(stderr, "dlopen failed: %s\n", dlerror());
    return 1;
  }
  heap_sort_t f_ref=(heap_sort_t)dlsym(A,"heap_sort");
  heap_sort_t f_llm=(heap_sort_t)dlsym(B,"heap_sort");
  if(!f_ref || !f_llm){
    fprintf(stderr,"[ERR] heap_sort symbol not found\n");
    return 2;
  }

  srand(seed);
  int agree_cnt=0, mism_cnt=0;

  for(int t=0; t<Ncases; t++){
    // 입력 생성 및 보존
    int *orig=(int*)malloc(sizeof(int)*n);
    int *x1  =(int*)malloc(sizeof(int)*n);
    int *x2  =(int*)malloc(sizeof(int)*n);
    if(!orig||!x1||!x2){ fprintf(stderr,"malloc failed\n"); return 4; }

    for(size_t i=0;i<n;i++){
      int v=(rand()%2001)-1000;
      orig[i]=v; x1[i]=v; x2[i]=v;
    }

    uint64_t t0=now_ns();
    f_ref(x1,n);
    uint64_t t1=now_ns();
    f_llm(x2,n);
    uint64_t t2=now_ns();

    int same = memcmp(x1,x2,sizeof(int)*n)==0;
    int ok1 = is_sorted(x1,n);
    int ok2 = is_sorted(x2,n);

    // 첫 차이 인덱스
    long first_diff=-1; int dref=0, dllm=0;
    if(!same){
      for(size_t i=0;i<n;i++){
        if(x1[i]!=x2[i]){ first_diff=(long)i; dref=x1[i]; dllm=x2[i]; break; }
      }
    }

    uint64_t href = fnv1a64(x1, sizeof(int)*n);
    uint64_t hllm = fnv1a64(x2, sizeof(int)*n);

    int agree = (same && ok1 && ok2);
    if(agree) agree_cnt++; else mism_cnt++;

    // 요약 CSV 한 줄
    fprintf(csv, "%d,%zu,%u,%d,%d,%d,%d,%ld,%d,%d,%llu,%llu,%llu,%llu\n",
            t, n, seed, agree, same, ok1, ok2,
            first_diff, dref, dllm,
            (unsigned long long)href, (unsigned long long)hllm,
            (unsigned long long)(t1-t0), (unsigned long long)(t2-t1));

    // 덤프 조건: mismatch 또는 DUMP_ALL=1
    if(!agree || dump_all){
      char p_in[PATH_MAX], p_ref[PATH_MAX], p_llm[PATH_MAX];
      snprintf(p_in,  sizeof(p_in),  "%s/case_%04d_input.txt", outdir, t);
      snprintf(p_ref, sizeof(p_ref), "%s/case_%04d_ref.txt",   outdir, t);
      snprintf(p_llm, sizeof(p_llm), "%s/case_%04d_llm.txt",   outdir, t);
      write_array_txt(p_in,  orig, n);
      write_array_txt(p_ref, x1,   n);
      write_array_txt(p_llm, x2,   n);

      // 화면에는 처음 12개만 간단히
      if(!agree && mism_cnt<=5){
        printf("[mismatch #%d] case=%d first 12 (ref/llm):\n", mism_cnt, t);
        for(size_t i=0;i<12 && i<n;i++) printf("%d ", x1[i]); puts("");
        for(size_t i=0;i<12 && i<n;i++) printf("%d ", x2[i]); puts("");
        printf("sorted? ref=%d llm=%d  first_diff=%ld  ref=%d llm=%d\n",
               ok1, ok2, first_diff, dref, dllm);
      }
    }

    free(orig); free(x1); free(x2);
  }

  fclose(csv);

  printf("agree_rate_on_random_inputs=%.3f (%d/%d)\n",
         (double)agree_cnt/Ncases, agree_cnt, Ncases);
  printf("mismatches=%d\n", mism_cnt);
  printf("summary: %s\n", summary_path);
  printf("array dumps: %s/case_####_{input,ref,llm}.txt\n", outdir);

  return mism_cnt?2:0;
}
