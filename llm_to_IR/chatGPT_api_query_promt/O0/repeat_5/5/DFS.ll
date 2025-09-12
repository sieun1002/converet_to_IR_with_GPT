; ModuleID = 'main.ll'
source_filename = "main.c"
target triple = "x86_64-pc-linux-gnu"

@.hdr = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00"
@.fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00"
@.sp = private unnamed_addr constant [2 x i8] c" \00"
@.empty = private unnamed_addr constant [1 x i8] c"\00"

declare void @dfs(i32* nocapture, i64, i64, i64* nocapture, i64* nocapture)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() local_unnamed_addr {
entry:
  %blocked = alloca [49 x i32], align 16
  %out = alloca [49 x i64], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %out_len = alloca i64, align 8
  %i = alloca i64, align 8

  store i64 7, i64* %n, align 8
  %blk.i8 = bitcast [49 x i32]* %blocked to i8*
  call void @llvm.memset.p0i8.i64(i8* align 16 %blk.i8, i8 0, i64 196, i1 false)

  ; blocked[1] = 1
  %b1 = getelementptr inbounds [49 x i32], [49 x i32]* %blocked, i64 0, i64 1
  store i32 1, i32* %b1, align 4

  ; blocked[2] = 1
  %b2 = getelementptr inbounds [49 x i32], [49 x i32]* %blocked, i64 0, i64 2
  store i32 1, i32* %b2, align 8

  ; dynamic indices based on n = 7
  %nv = load i64, i64* %n, align 8

  ; blocked[n] = 1
  %b_n = getelementptr inbounds [49 x i32], [49 x i32]* %blocked, i64 0, i64 %nv
  store i32 1, i32* %b_n, align 4

  ; blocked[2n] = 1
  %mul2 = shl i64 %nv, 1
  %b_2n = getelementptr inbounds [49 x i32], [49 x i32]* %blocked, i64 0, i64 %mul2
  store i32 1, i32* %b_2n, align 4

  ; blocked[n+3] = 1
  %n_p3 = add i64 %nv, 3
  %b_n_p3 = getelementptr inbounds [49 x i32], [49 x i32]* %blocked, i64 0, i64 %n_p3
  store i32 1, i32* %b_n_p3, align 4

  ; blocked[3n+1] = 1
  %mul3 = add i64 %mul2, %nv            ; 3n
  %mul3_p1 = add i64 %mul3, 1
  %b_3n_p1 = getelementptr inbounds [49 x i32], [49 x i32]* %blocked, i64 0, i64 %mul3_p1
  store i32 1, i32* %b_3n_p1, align 4

  ; blocked[n+4] = 1
  %n_p4 = add i64 %nv, 4
  %b_n_p4 = getelementptr inbounds [49 x i32], [49 x i32]* %blocked, i64 0, i64 %n_p4
  store i32 1, i32* %b_n_p4, align 4

  ; blocked[4n+1] = 1
  %mul4 = shl i64 %nv, 2                ; 4n
  %mul4_p1 = add i64 %mul4, 1
  %b_4n_p1 = getelementptr inbounds [49 x i32], [49 x i32]* %blocked, i64 0, i64 %mul4_p1
  store i32 1, i32* %b_4n_p1, align 4

  ; blocked[2n+5] = 1
  %mul2_p5 = add i64 %mul2, 5
  %b_2n_p5 = getelementptr inbounds [49 x i32], [49 x i32]* %blocked, i64 0, i64 %mul2_p5
  store i32 1, i32* %b_2n_p5, align 4

  ; blocked[5n+2] = 1
  %mul5 = add i64 %mul4, %nv            ; 5n
  %mul5_p2 = add i64 %mul5, 2
  %b_5n_p2 = getelementptr inbounds [49 x i32], [49 x i32]* %blocked, i64 0, i64 %mul5_p2
  store i32 1, i32* %b_5n_p2, align 4

  ; blocked[4n+5] = 1
  %mul4_p5 = add i64 %mul4, 5
  %b_4n_p5 = getelementptr inbounds [49 x i32], [49 x i32]* %blocked, i64 0, i64 %mul4_p5
  store i32 1, i32* %b_4n_p5, align 4

  ; blocked[5n+4] = 1
  %mul5_p4 = add i64 %mul5, 4
  %b_5n_p4 = getelementptr inbounds [49 x i32], [49 x i32]* %blocked, i64 0, i64 %mul5_p4
  store i32 1, i32* %b_5n_p4, align 4

  ; blocked[5n+6] = 1
  %mul5_p6 = add i64 %mul5, 6
  %b_5n_p6 = getelementptr inbounds [49 x i32], [49 x i32]* %blocked, i64 0, i64 %mul5_p6
  store i32 1, i32* %b_5n_p6, align 4

  ; blocked[6n+5] = 1
  %mul6 = shl i64 %mul3, 1              ; 6n
  %mul6_p5 = add i64 %mul6, 5
  %b_6n_p5 = getelementptr inbounds [49 x i32], [49 x i32]* %blocked, i64 0, i64 %mul6_p5
  store i32 1, i32* %b_6n_p5, align 4

  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  %blk0 = getelementptr inbounds [49 x i32], [49 x i32]* %blocked, i64 0, i64 0
  %out0 = getelementptr inbounds [49 x i64], [49 x i64]* %out, i64 0, i64 0
  %nv2 = load i64, i64* %n, align 8
  %startv = load i64, i64* %start, align 8
  call void @dfs(i32* %blk0, i64 %nv2, i64 %startv, i64* %out0, i64* %out_len)

  ; print header
  %hdrp = getelementptr inbounds [24 x i8], [24 x i8]* @.hdr, i64 0, i64 0
  %startv2 = load i64, i64* %start, align 8
  %callhdr = call i32 (i8*, ...) @printf(i8* %hdrp, i64 %startv2)

  ; loop over results
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i.cur = load i64, i64* %i, align 8
  %len = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %i.cur, %len
  br i1 %cmp, label %body, label %done

body:
  %next = add i64 %i.cur, 1
  %more = icmp ult i64 %next, %len
  %sep.sp = getelementptr inbounds [2 x i8], [2 x i8]* @.sp, i64 0, i64 0
  %sep.empty = getelementptr inbounds [1 x i8], [1 x i8]* @.empty, i64 0, i64 0
  %sepp = select i1 %more, i8* %sep.sp, i8* %sep.empty

  %valp = getelementptr inbounds [49 x i64], [49 x i64]* %out, i64 0, i64 %i.cur
  %val = load i64, i64* %valp, align 8

  %fmtp = getelementptr inbounds [6 x i8], [6 x i8]* @.fmt, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmtp, i64 %val, i8* %sepp)

  %inc = add i64 %i.cur, 1
  store i64 %inc, i64* %i, align 8
  br label %loop

done:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}