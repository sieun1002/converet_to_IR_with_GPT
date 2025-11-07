; ModuleID = 'recovered_main'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2030 = external constant <4 x i32>, align 16
@xmmword_2040 = external constant <4 x i32>, align 16
@qword_2050   = external constant i64, align 8

@.str_found    = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str_notfound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail() noreturn

define i32 @main() {
entry:                                           ; 0x1080
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %canary = alloca i64, align 8
  %can0 = call i64 asm "movq %fs:0x28, $0", "={rax},~{dirflag},~{fpsr},~{flags}"()
  store i64 %can0, i64* %canary, align 8
  %v0 = load <4 x i32>, <4 x i32>* @xmmword_2030, align 16
  %arr.i32 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %arr.vec0 = bitcast i32* %arr.i32 to <4 x i32>*
  store <4 x i32> %v0, <4 x i32>* %arr.vec0, align 16
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2040, align 16
  %arr.i32.4 = getelementptr inbounds i32, i32* %arr.i32, i64 4
  %arr.vec1 = bitcast i32* %arr.i32.4 to <4 x i32>*
  store <4 x i32> %v1, <4 x i32>* %arr.vec1, align 16
  %arr.i32.8 = getelementptr inbounds i32, i32* %arr.i32, i64 8
  store i32 12, i32* %arr.i32.8, align 4
  %q = load i64, i64* @qword_2050, align 8
  %keys.i64 = bitcast [3 x i32]* %keys to i64*
  store i64 %q, i64* %keys.i64, align 8
  %keys.i32.2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys.i32.2, align 4
  %iter0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  %end = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 3
  br label %b10E0

b10E0:                                           ; 0x10E0
  %iter = phi i32* [ %iter0, %entry ], [ %iter.next, %b1127 ]
  %key = load i32, i32* %iter, align 4
  br label %b1105.prep

b1105.prep:
  %rcx0 = phi i64 [ 0, %b10E0 ]
  %rdx0 = phi i64 [ 9, %b10E0 ]
  br label %b1105

b1105:                                           ; 0x1105
  %rcx = phi i64 [ %rcx0, %b1105.prep ], [ %rcx, %b1102 ], [ %rcx.next, %b1150 ]
  %rdx = phi i64 [ %rdx0, %b1105.prep ], [ %mid, %b1102 ], [ %rdx, %b1150 ]
  %cond = icmp ult i64 %rcx, %rdx
  br i1 %cond, label %b10F0, label %b110A

b10F0:                                           ; 0x10F0
  %sub = sub i64 %rdx, %rcx
  %shr = lshr i64 %sub, 1
  %mid = add i64 %shr, %rcx
  %elem.ptr = getelementptr inbounds i32, i32* %arr.i32, i64 %mid
  %elem = load i32, i32* %elem.ptr, align 4
  %cmpjg = icmp sgt i32 %key, %elem
  br i1 %cmpjg, label %b1150, label %b1102

b1102:                                           ; 0x1102
  br label %b1105

b1150:                                           ; 0x1150
  %rcx.next = add i64 %mid, 1
  br label %b1105

b110A:                                           ; 0x110A
  %cmp.ja = icmp ugt i64 %rcx, 8
  br i1 %cmp.ja, label %b1156, label %b1112

b1112:                                           ; 0x1112
  %elem.ptr.idx = getelementptr inbounds i32, i32* %arr.i32, i64 %rcx
  %elem.idx = load i32, i32* %elem.ptr.idx, align 4
  %cmp.jnz = icmp ne i32 %key, %elem.idx
  br i1 %cmp.jnz, label %b1156, label %b1118

b1118:                                           ; 0x1118
  %fmt.found = getelementptr inbounds [21 x i8], [21 x i8]* @.str_found, i64 0, i64 0
  call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.found, i32 %key, i64 %rcx)
  br label %b1127

b1156:                                           ; 0x1156
  %fmt.nf = getelementptr inbounds [21 x i8], [21 x i8]* @.str_notfound, i64 0, i64 0
  call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.nf, i32 %key)
  br label %b1127

b1127:                                           ; 0x1127
  %iter.next = getelementptr inbounds i32, i32* %iter, i64 1
  %cont = icmp ne i32* %iter.next, %end
  br i1 %cont, label %b10E0, label %b1130

b1130:                                           ; 0x1130
  %can1 = call i64 asm "movq %fs:0x28, $0", "={rax},~{dirflag},~{fpsr},~{flags}"()
  %saved = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %saved, %can1
  br i1 %ok, label %b1140, label %b116B

b1140:                                           ; 0x1140
  ret i32 0

b116B:                                           ; 0x116B
  call void @___stack_chk_fail()
  unreachable
}