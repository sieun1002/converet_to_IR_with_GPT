; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2030 = external constant <4 x i32>, align 16
@xmmword_2040 = external constant <4 x i32>, align 16
@qword_2050   = external constant i64, align 8
@__stack_chk_guard = external global i64, align 8

@.str.index = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.notfound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail() noreturn

define i32 @main() {
bb1080:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 8
  %saved_canary = alloca i64, align 8
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %saved_canary, align 8

  %vec0 = load <4 x i32>, <4 x i32>* @xmmword_2030, align 16
  %arr0_ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %arr0_vptr = bitcast i32* %arr0_ptr to <4 x i32>*
  store <4 x i32> %vec0, <4 x i32>* %arr0_vptr, align 16

  %vec1 = load <4 x i32>, <4 x i32>* @xmmword_2040, align 16
  %arr4_ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  %arr4_vptr = bitcast i32* %arr4_ptr to <4 x i32>*
  store <4 x i32> %vec1, <4 x i32>* %arr4_vptr, align 16

  %arr8_ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr8_ptr, align 4

  %q = load i64, i64* @qword_2050, align 8
  %keys0_ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  %keys_i64_ptr = bitcast i32* %keys0_ptr to i64*
  store i64 %q, i64* %keys_i64_ptr, align 8

  %keys2_ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys2_ptr, align 4

  %init_ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  %end_ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 3
  br label %bb10e0

bb10e0:
  %cur_ptr.ph = phi i32* [ %init_ptr, %bb1080 ], [ %cur_ptr.next, %bb1127 ]
  %key = load i32, i32* %cur_ptr.ph, align 4
  br label %bb1105

bb10f0:
  %sub = sub i64 %rdx.phi, %rcx.phi
  %shr = lshr i64 %sub, 1
  %mid = add i64 %shr, %rcx.phi
  %elem_ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %mid
  %elem = load i32, i32* %elem_ptr, align 4
  %cmp_jg = icmp sgt i32 %key, %elem
  br i1 %cmp_jg, label %bb1150, label %bb1105

bb1105:
  %rcx.phi = phi i64 [ 0, %bb10e0 ], [ %rcx.next, %bb1150 ], [ %rcx.phi, %bb10f0 ]
  %rdx.phi = phi i64 [ 9, %bb10e0 ], [ %rdx.phi, %bb1150 ], [ %mid, %bb10f0 ]
  %cmp_jb = icmp ult i64 %rcx.phi, %rdx.phi
  br i1 %cmp_jb, label %bb10f0, label %bb110a

bb1150:
  %rcx.next = add i64 %mid, 1
  br label %bb1105

bb110a:
  %cmp_ja = icmp ugt i64 %rcx.phi, 8
  br i1 %cmp_ja, label %bb1156, label %bb110a.cont

bb110a.cont:
  %idx_ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %rcx.phi
  %idx_val = load i32, i32* %idx_ptr, align 4
  %cmp_ne = icmp ne i32 %key, %idx_val
  br i1 %cmp_ne, label %bb1156, label %bb110a.found

bb110a.found:
  %fmt_idx = getelementptr inbounds [21 x i8], [21 x i8]* @.str.index, i64 0, i64 0
  %call_found = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt_idx, i32 %key, i64 %rcx.phi)
  br label %bb1127

bb1156:
  %fmt_nf = getelementptr inbounds [21 x i8], [21 x i8]* @.str.notfound, i64 0, i64 0
  %call_nf = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt_nf, i32 %key)
  br label %bb1127

bb1127:
  %cur_ptr.next = getelementptr inbounds i32, i32* %cur_ptr.ph, i64 1
  %done = icmp ne i32* %cur_ptr.next, %end_ptr
  br i1 %done, label %bb10e0, label %bb1130

bb1130:
  %saved = load i64, i64* %saved_canary, align 8
  %guard1 = load i64, i64* @__stack_chk_guard, align 8
  %canary_mismatch = icmp ne i64 %saved, %guard1
  br i1 %canary_mismatch, label %bb116b, label %bb1140

bb1140:
  ret i32 0

bb116b:
  call void @___stack_chk_fail()
  unreachable
}