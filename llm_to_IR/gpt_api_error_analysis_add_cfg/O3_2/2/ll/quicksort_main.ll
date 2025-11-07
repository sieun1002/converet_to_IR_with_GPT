; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@__stack_chk_guard = external global i64, align 8
@xmmword_2010 = external constant [16 x i8], align 16
@xmmword_2020 = external constant [16 x i8], align 16
@unk_2004 = external global i8, align 1
@unk_2008 = external global i8, align 1

declare void @quick_sort(i32*, i32, i32)
declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail() noreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg)

define i32 @main() {
L1080:
  ; locals
  %arr = alloca [10 x i32], align 16
  %canary.save = alloca i64, align 8

  ; load and save stack guard
  %g0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %g0, i64* %canary.save, align 8

  ; initialize first 8 ints from two 16-byte constants
  %arr.i8 = bitcast [10 x i32]* %arr to i8*
  %csrc0 = getelementptr inbounds [16 x i8], [16 x i8]* @xmmword_2010, i64 0, i64 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %arr.i8, i8* align 16 %csrc0, i64 16, i1 false)
  %dst1 = getelementptr inbounds i8, i8* %arr.i8, i64 16
  %csrc1 = getelementptr inbounds [16 x i8], [16 x i8]* @xmmword_2020, i64 0, i64 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %dst1, i8* align 16 %csrc1, i64 16, i1 false)

  ; store 4 into element index 8
  %elt8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %elt8, align 4

  ; quick_sort(&arr[0], 0, 9)
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* %arr0, i32 0, i32 9)
  br label %L10E0

L10E0: ; print loop body starting at 0x10E0
  %p.cur = phi i32* [ %arr0, %L1080 ], [ %p.next, %L10E0 ]
  %val = load i32, i32* %p.cur, align 4
  ; ___printf_chk(2, fmt, val)
  %_res0 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* @unk_2004, i32 %val)
  ; advance pointer
  %p.next = getelementptr inbounds i32, i32* %p.cur, i64 1
  ; r12 was &arr[10] (end address at offset 0x28), compare after increment
  %pend = getelementptr inbounds i32, i32* %arr0, i64 10
  %more = icmp ne i32* %p.next, %pend
  br i1 %more, label %L10E0, label %after_loop

after_loop:
  ; ___printf_chk(2, newline_fmt)
  %_res1 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* @unk_2008)
  ; stack canary check
  %g.saved = load i64, i64* %canary.save, align 8
  %g.now = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %g.saved, %g.now
  br i1 %ok, label %ret_ok, label %L1128

L1128: ; __stack_chk_fail path at 0x1128
  call void @___stack_chk_fail()
  unreachable

ret_ok:
  ret i32 0
}