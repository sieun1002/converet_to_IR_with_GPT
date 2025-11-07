; ModuleID = 'lifted_from_asm_main'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2030 = external global <4 x i32>, align 16
@xmmword_2040 = external global <4 x i32>, align 16
@qword_2050   = external global i64
@__stack_chk_guard = external global i64

@aKeyDIndexLd  = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@aKeyDNotFound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail() noreturn

define i32 @main() {
bb1080:
  %arr = alloca [9 x i32], align 16
  %iter = alloca i32*, align 8
  %end = alloca i32*, align 8
  %canary = alloca i64, align 8
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary, align 8
  %arr_vec0.ptr = bitcast [9 x i32]* %arr to <4 x i32>*
  %vec0 = load <4 x i32>, <4 x i32>* @xmmword_2030, align 16
  store <4 x i32> %vec0, <4 x i32>* %arr_vec0.ptr, align 16
  %arr_4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i32 0, i32 4
  %arr_vec1.ptr = bitcast i32* %arr_4 to <4 x i32>*
  %vec1 = load <4 x i32>, <4 x i32>* @xmmword_2040, align 16
  store <4 x i32> %vec1, <4 x i32>* %arr_vec1.ptr, align 16
  %arr_8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i32 0, i32 8
  store i32 12, i32* %arr_8, align 4
  %base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i32 0, i32 0
  store i32* %base, i32** %iter, align 8
  %endp = getelementptr inbounds i32, i32* %base, i64 9
  store i32* %endp, i32** %end, align 8
  br label %bb10E0

bb10E0:                                           ; 0x10E0
  %cur = load i32*, i32** %iter, align 8
  %key = load i32, i32* %cur, align 4
  br label %bb1105

bb1105:                                           ; 0x1105
  %low = phi i64 [ 0, %bb10E0 ], [ %low_inc, %bb1150 ], [ %low, %bb10F0_notjg ]
  %high = phi i64 [ 9, %bb10E0 ], [ %high, %bb1150 ], [ %mid, %bb10F0_notjg ]
  %cmp_lh = icmp ult i64 %low, %high
  br i1 %cmp_lh, label %bb10F0, label %bb1105_after

bb10F0:                                           ; 0x10F0
  %sub = sub i64 %high, %low
  %shr = lshr i64 %sub, 1
  %mid = add i64 %shr, %low
  %elem.ptr = getelementptr inbounds i32, i32* %base, i64 %mid
  %elem = load i32, i32* %elem.ptr, align 4
  %cmp_jg = icmp sgt i32 %key, %elem
  br i1 %cmp_jg, label %bb1150, label %bb10F0_notjg

bb10F0_notjg:
  br label %bb1105

bb1150:                                           ; 0x1150
  %low_inc = add i64 %mid, 1
  br label %bb1105

bb1105_after:
  %too_high = icmp ugt i64 %low, 8
  br i1 %too_high, label %bb1156, label %bb1112

bb1112:
  %idx.ptr = getelementptr inbounds i32, i32* %base, i64 %low
  %idx.val = load i32, i32* %idx.ptr, align 4
  %neq = icmp ne i32 %key, %idx.val
  br i1 %neq, label %bb1156, label %bb1118

bb1118:
  %fmt_ok = getelementptr inbounds [21 x i8], [21 x i8]* @aKeyDIndexLd, i64 0, i64 0
  %call_ok = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt_ok, i32 %key, i64 %low)
  br label %bb1127

bb1156:                                           ; 0x1156
  %fmt_nf = getelementptr inbounds [21 x i8], [21 x i8]* @aKeyDNotFound, i64 0, i64 0
  %call_nf = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt_nf, i32 %key)
  br label %bb1127

bb1127:                                           ; 0x1127
  %cur2 = load i32*, i32** %iter, align 8
  %next = getelementptr inbounds i32, i32* %cur2, i64 1
  store i32* %next, i32** %iter, align 8
  %end2 = load i32*, i32** %end, align 8
  %cont = icmp ne i32* %end2, %next
  br i1 %cont, label %bb10E0, label %bb1130

bb1130:
  %guard_now = load i64, i64* @__stack_chk_guard, align 8
  %guard_saved = load i64, i64* %canary, align 8
  %canary_mismatch = icmp ne i64 %guard_saved, %guard_now
  br i1 %canary_mismatch, label %bb116B, label %bb1140

bb1140:
  ret i32 0

bb116B:                                           ; 0x116B
  call void @___stack_chk_fail()
  unreachable
}