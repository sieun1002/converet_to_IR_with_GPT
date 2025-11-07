; ModuleID = 'recovered'
target triple = "x86_64-unknown-linux-gnu"

@xmmword_2010 = external constant <4 x i32>, align 16
@xmmword_2020 = external constant <4 x i32>, align 16
@unk_2004 = external global i8, align 1
@unk_2008 = external global i8, align 1
@__stack_chk_guard = external global i64, align 8

declare void @quick_sort(i32* noundef, i32 noundef, i32 noundef)
declare i32 @___printf_chk(i32 noundef, i8* noundef, ...)
declare void @___stack_chk_fail() noreturn

define i32 @main() {
L1080:
  %arr = alloca [9 x i32], align 16
  %canary = alloca i64, align 8

  %g = load i64, i64* @__stack_chk_guard, align 8
  store i64 %g, i64* %canary, align 8

  %base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %end = getelementptr inbounds i32, i32* %base, i64 9

  %vptr0 = bitcast i32* %base to <4 x i32>*
  %v0 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  store <4 x i32> %v0, <4 x i32>* %vptr0, align 16

  %p4 = getelementptr inbounds i32, i32* %base, i64 4
  %vptr1 = bitcast i32* %p4 to <4 x i32>*
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  store <4 x i32> %v1, <4 x i32>* %vptr1, align 16

  %p8 = getelementptr inbounds i32, i32* %base, i64 8
  store i32 4, i32* %p8, align 4

  call void @quick_sort(i32* %base, i32 0, i32 9)

  br label %L10E0

L10E0:                                              ; loop: print array
  %it = phi i32* [ %base, %L1080 ], [ %next, %L10E0 ]
  %val = load i32, i32* %it, align 4
  %next = getelementptr inbounds i32, i32* %it, i64 1
  %callp = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* @unk_2004, i32 %val)
  %cmp = icmp ne i32* %next, %end
  br i1 %cmp, label %L10E0, label %L10FA

L10FA:
  %callnl = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* @unk_2008)
  %saved = load i64, i64* %canary, align 8
  %cur = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %saved, %cur
  br i1 %ok, label %Lret, label %L1128

L1128:
  call void @___stack_chk_fail()
  unreachable

Lret:
  ret i32 0
}