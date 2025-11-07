; ModuleID = 'recovered_from_0x1080_0x1170'
source_filename = "recovered_from_0x1080_0x1170"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

@xmmword_2030 = external constant [16 x i8], align 16
@xmmword_2040 = external constant [16 x i8], align 16
@qword_2050 = external constant i64, align 8

@__stack_chk_guard = external thread_local(initialexec) global i64, align 8

declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail() noreturn nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg)

define i32 @main() {
loc_1080:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %canary = alloca i64, align 8

  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %canary, align 8

  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0

  %dst0.i8 = bitcast i32* %arr.base to i8*
  %src2030.i8 = bitcast [16 x i8]* @xmmword_2030 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %dst0.i8, i8* align 16 %src2030.i8, i64 16, i1 false)

  %arr4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  %dst4.i8 = bitcast i32* %arr4 to i8*
  %src2040.i8 = bitcast [16 x i8]* @xmmword_2040 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %dst4.i8, i8* align 16 %src2040.i8, i64 16, i1 false)

  %arr8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 12, i32* %arr8, align 4

  %q2050 = load i64, i64* @qword_2050, align 8
  %keys.i64 = bitcast [3 x i32]* %keys to i64*
  store i64 %q2050, i64* %keys.i64, align 8

  %key2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %key2, align 4

  %keys0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  %keysEnd = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 3
  br label %loc_10E0

loc_10E0:                                           ; preds = %loc_1080, %loc_1127
  %r12.cur = phi i32* [ %keys0, %loc_1080 ], [ %r12.next, %loc_1127 ]
  %key.load = load i32, i32* %r12.cur, align 4
  br label %loc_1105

loc_10F0:                                           ; preds = %loc_1105
  %diff = sub i64 %rdx.phi, %rcx.phi
  %half = lshr i64 %diff, 1
  %mid = add i64 %half, %rcx.phi
  %mid.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %mid
  %mid.val = load i32, i32* %mid.ptr, align 4
  %cmp.sgt = icmp sgt i32 %key.phi, %mid.val
  br i1 %cmp.sgt, label %loc_1150, label %loc_1105

loc_1105:                                           ; preds = %loc_10E0, %loc_10F0, %loc_1150
  %key.phi = phi i32 [ %key.load, %loc_10E0 ], [ %key.phi, %loc_10F0 ], [ %key.phi, %loc_1150 ]
  %rdx.phi = phi i64 [ 9, %loc_10E0 ], [ %mid, %loc_10F0 ], [ %rdx.phi, %loc_1150 ]
  %rcx.phi = phi i64 [ 0, %loc_10E0 ], [ %rcx.phi, %loc_10F0 ], [ %rcx.next, %loc_1150 ]
  %cmp.jb = icmp ult i64 %rcx.phi, %rdx.phi
  br i1 %cmp.jb, label %loc_10F0, label %loc_1105_cont

loc_1105_cont:                                      ; preds = %loc_1105
  %cmp.ja = icmp ugt i64 %rcx.phi, 8
  br i1 %cmp.ja, label %loc_1156, label %loc_1105_check

loc_1105_check:                                     ; preds = %loc_1105_cont
  %idx.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %rcx.phi
  %idx.val = load i32, i32* %idx.ptr, align 4
  %cmp.ne = icmp ne i32 %key.phi, %idx.val
  br i1 %cmp.ne, label %loc_1156, label %loc_1105_found

loc_1105_found:                                     ; preds = %loc_1105_check
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %call.ok = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt1, i32 %key.phi, i64 %rcx.phi)
  br label %loc_1127

loc_1150:                                           ; preds = %loc_10F0
  %rcx.next = add i64 %mid, 1
  br label %loc_1105

loc_1156:                                           ; preds = %loc_1105_check, %loc_1105_cont
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  %call.nf = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt2, i32 %key.phi)
  br label %loc_1127

loc_1127:                                           ; preds = %loc_1156, %loc_1105_found
  %r12.in = phi i32* [ %r12.cur, %loc_1105_found ], [ %r12.cur, %loc_1156 ]
  %r12.next = getelementptr inbounds i32, i32* %r12.in, i64 1
  %more = icmp ne i32* %r12.next, %keysEnd
  br i1 %more, label %loc_10E0, label %bb_1130

bb_1130:                                            ; corresponds to 0x1130..0x114a
  %saved = load i64, i64* %canary, align 8
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %saved, %guard.now
  br i1 %ok, label %bb_1140, label %loc_116B

bb_1140:                                            ; epilogue, returns 0
  ret i32 0

loc_116B:                                           ; preds = %bb_1130
  call void @__stack_chk_fail()
  unreachable
}