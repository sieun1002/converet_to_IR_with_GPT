; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@__stack_chk_guard = external global i64
@xmmword_2030 = external constant <4 x i32>, align 16
@xmmword_2040 = external constant <4 x i32>, align 16
@qword_2050 = external global i64, align 8

@.str_found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str_notfound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare i32 @___printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()

define i32 @main() {
L1080:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 4
  %cur.slot = alloca i32*, align 8
  %end.slot = alloca i32*, align 8
  %key.slot = alloca i32, align 4
  %canary = alloca i64, align 8
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %canary, align 8
  %v0 = load <4 x i32>, <4 x i32>* @xmmword_2030, align 16
  %arrvecptr0 = bitcast [9 x i32]* %arr to <4 x i32>*
  store <4 x i32> %v0, <4 x i32>* %arrvecptr0, align 16
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2040, align 16
  %arr4ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  %arrvecptr1 = bitcast i32* %arr4ptr to <4 x i32>*
  store <4 x i32> %v1, <4 x i32>* %arrvecptr1, align 16
  %arr8ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr8ptr, align 4
  %q = load i64, i64* @qword_2050, align 8
  %lo32 = trunc i64 %q to i32
  %q_shr32 = lshr i64 %q, 32
  %hi32 = trunc i64 %q_shr32 to i32
  %keys0ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  %keys1ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  %keys2ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 %lo32, i32* %keys0ptr, align 4
  store i32 %hi32, i32* %keys1ptr, align 4
  store i32 -5, i32* %keys2ptr, align 4
  store i32* %keys0ptr, i32** %cur.slot, align 8
  %endptr = getelementptr inbounds i32, i32* %keys0ptr, i64 3
  store i32* %endptr, i32** %end.slot, align 8
  br label %L10E0

L10E0:
  %cur = load i32*, i32** %cur.slot, align 8
  %key = load i32, i32* %cur, align 4
  store i32 %key, i32* %key.slot, align 4
  br label %L1105

L1105:
  %low = phi i64 [ 0, %L10E0 ], [ %low_next, %L1150 ], [ %low, %L1102 ]
  %high = phi i64 [ 9, %L10E0 ], [ %high, %L1150 ], [ %mid, %L1102 ]
  %cond = icmp ult i64 %low, %high
  br i1 %cond, label %L10F0, label %L110A

L10F0:
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %half, %low
  %midptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %mid
  %midval = load i32, i32* %midptr, align 4
  %key2 = load i32, i32* %key.slot, align 4
  %cmpmid = icmp sgt i32 %key2, %midval
  br i1 %cmpmid, label %L1150, label %L1102

L1150:
  %low_next = add i64 %mid, 1
  br label %L1105

L1102:
  br label %L1105

L110A:
  %key3 = load i32, i32* %key.slot, align 4
  %cmp_ja = icmp ugt i64 %low, 8
  br i1 %cmp_ja, label %L1156, label %L1112

L1112:
  %valptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %low
  %val = load i32, i32* %valptr, align 4
  %cmp_ne = icmp ne i32 %key3, %val
  br i1 %cmp_ne, label %L1156, label %L1118

L1118:
  %fmt_found_ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_found, i64 0, i64 0
  %call1 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt_found_ptr, i32 %key3, i64 %low)
  br label %L1127

L1156:
  %fmt_nf_ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_notfound, i64 0, i64 0
  %key4 = load i32, i32* %key.slot, align 4
  %call2 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt_nf_ptr, i32 %key4)
  br label %L1127

L1127:
  %cur1 = load i32*, i32** %cur.slot, align 8
  %cur_next = getelementptr inbounds i32, i32* %cur1, i64 1
  store i32* %cur_next, i32** %cur.slot, align 8
  %end2 = load i32*, i32** %end.slot, align 8
  %cmp_loop = icmp ne i32* %end2, %cur_next
  br i1 %cmp_loop, label %L10E0, label %L1130

L1130:
  %guard1 = load i64, i64* @__stack_chk_guard, align 8
  %saved = load i64, i64* %canary, align 8
  %cmp_can = icmp ne i64 %saved, %guard1
  br i1 %cmp_can, label %L116B, label %L1140

L1140:
  ret i32 0

L116B:
  call void @__stack_chk_fail()
  unreachable
}