; ModuleID = 'main_module'
target triple = "x86_64-pc-linux-gnu"

@.str_d = private constant [4 x i8] c"%d \00", align 1
@.str_sorted = private constant [15 x i8] c"Sorted array: \00", align 1
@xmmword_2020 = external constant [16 x i8], align 16
@__stack_chk_guard = external global i64

declare void @selection_sort(i32*, i32)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail() noreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias writeonly, i8* noalias readonly, i64, i1 immarg)

define i32 @main() {
entry_1080:
  %arr = alloca [5 x i32], align 16
  %canary.slot = alloca i64, align 8
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary.slot, align 8
  %arr.i8 = bitcast [5 x i32]* %arr to i8*
  %src.i8 = bitcast [16 x i8]* @xmmword_2020 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %arr.i8, i8* align 16 %src.i8, i64 16, i1 false)
  %elem4ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %elem4ptr, align 4
  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  call void @selection_sort(i32* %arr0, i32 5)
  %hdr = getelementptr inbounds [15 x i8], [15 x i8]* @.str_sorted, i64 0, i64 0
  %callhdr = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %hdr)
  %endptr = getelementptr inbounds i32, i32* %arr0, i64 5
  br label %loc_10E0

loc_10E0:
  %p = phi i32* [ %arr0, %entry_1080 ], [ %p.next, %loc_10E0 ]
  %val = load i32, i32* %p, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str_d, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt, i32 %val)
  %p.next = getelementptr inbounds i32, i32* %p, i64 1
  %cmp = icmp ne i32* %p.next, %endptr
  br i1 %cmp, label %loc_10E0, label %bb_10fa

bb_10fa:
  %guard2 = load i64, i64* @__stack_chk_guard, align 8
  %saved = load i64, i64* %canary.slot, align 8
  %cmp_canary = icmp ne i64 %saved, %guard2
  br i1 %cmp_canary, label %loc_1115, label %ret_ok

ret_ok:
  ret i32 0

loc_1115:
  call void @__stack_chk_fail()
  unreachable
}