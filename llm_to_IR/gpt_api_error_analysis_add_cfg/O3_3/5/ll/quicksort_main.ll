; ModuleID = 'main_from_asm_0x1080_0x112d'
target triple = "x86_64-pc-linux-gnu"

@unk_2004 = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@unk_2008 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

@xmmword_2010 = external constant [16 x i8], align 16
@xmmword_2020 = external constant [16 x i8], align 16

@__stack_chk_guard = external global i64

declare void @quick_sort(i32*, i32, i32)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail() noreturn

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg)

define i32 @main() {
loc_1080:
  %arr = alloca [9 x i32], align 16
  %saved_canary = alloca i64, align 8
  %guard_init = load i64, i64* @__stack_chk_guard
  store i64 %guard_init, i64* %saved_canary, align 8

  %arr_i8 = bitcast [9 x i32]* %arr to i8*
  %src1 = bitcast [16 x i8]* @xmmword_2010 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %arr_i8, i8* align 16 %src1, i64 16, i1 false)

  %off16 = getelementptr inbounds i8, i8* %arr_i8, i64 16
  %src2 = bitcast [16 x i8]* @xmmword_2020 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %off16, i8* align 16 %src2, i64 16, i1 false)

  %idx8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %idx8, align 4

  %base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %end = getelementptr inbounds i32, i32* %base, i64 9

  call void @quick_sort(i32* %base, i32 0, i32 9)
  br label %loc_10E0

loc_10E0:
  %cur = phi i32* [ %base, %loc_1080 ], [ %next, %loc_10E0 ]
  %val = load i32, i32* %cur, align 4
  %next = getelementptr inbounds i32, i32* %cur, i64 1
  %fmt1 = getelementptr inbounds [4 x i8], [4 x i8]* @unk_2004, i64 0, i64 0
  %call_print = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt1, i32 %val)
  %cmp_cont = icmp ne i32* %next, %end
  br i1 %cmp_cont, label %loc_10E0, label %bb_10FA

bb_10FA:
  %fmt2 = getelementptr inbounds [2 x i8], [2 x i8]* @unk_2008, i64 0, i64 0
  %call_nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt2)
  %guard_now = load i64, i64* @__stack_chk_guard
  %guard_saved = load i64, i64* %saved_canary, align 8
  %canary_mismatch = icmp ne i64 %guard_saved, %guard_now
  br i1 %canary_mismatch, label %loc_1128, label %bb_111D

bb_111D:
  ret i32 0

loc_1128:
  call void @__stack_chk_fail()
  unreachable
}