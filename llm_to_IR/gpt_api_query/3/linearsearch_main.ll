; ModuleID = 'recovered'
source_filename = "recovered.ll"

@.str_found = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str_not = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare i32 @linear_search(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)
declare void @__stack_chk_fail()
@__stack_chk_guard = external global i64

define i32 @main() {
entry:
  %canary = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %size = alloca i32, align 4
  %key = alloca i32, align 4
  %idx = alloca i32, align 4

  ; stack canary setup
  %g0 = load i64, i64* @__stack_chk_guard
  store i64 %g0, i64* %canary, align 8

  ; initialize array: [5, 3, 8, 4, 2]
  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4, align 4

  ; size = 5, key = 4
  store i32 5, i32* %size, align 4
  store i32 4, i32* %key, align 4

  ; call linear_search(arr, size, key)
  %arrptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %sz = load i32, i32* %size, align 4
  %ky = load i32, i32* %key, align 4
  %call = call i32 @linear_search(i32* %arrptr, i32 %sz, i32 %ky)
  store i32 %call, i32* %idx, align 4

  ; if (idx == -1) puts("Element not found");
  ; else printf("Element found at index %d\n", idx);
  %isneg1 = icmp eq i32 %call, -1
  br i1 %isneg1, label %notfound, label %found

found:
  %idxv = load i32, i32* %idx, align 4
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str_found, i64 0, i64 0
  %p = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %idxv)
  br label %after

notfound:
  %sptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str_not, i64 0, i64 0
  %q = call i32 @puts(i8* %sptr)
  br label %after

after:
  ; stack canary check
  %g1 = load i64, i64* @__stack_chk_guard
  %gsaved = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %g1, %gsaved
  br i1 %ok, label %retlbl, label %stkfail

stkfail:
  call void @__stack_chk_fail()
  br label %retlbl

retlbl:
  ret i32 0
}