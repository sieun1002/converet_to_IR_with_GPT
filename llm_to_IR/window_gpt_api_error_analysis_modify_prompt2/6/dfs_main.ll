; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@aZuS = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@asc_140004018 = private unnamed_addr constant [2 x i8] c" \00", align 1
@unk_14000401A = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

declare dso_local void @dfs(i8*, i64, i64, i64*, i64*)
declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %frame = alloca [360 x i8], align 16
  %frame.i8 = bitcast [360 x i8]* %frame to i8*
  %rbp = getelementptr inbounds i8, i8* %frame.i8, i64 128
  %var20.ptr.i8 = getelementptr inbounds i8, i8* %rbp, i64 208
  %var20.ptr = bitcast i8* %var20.ptr.i8 to i64*
  store i64 7, i64* %var20.ptr, align 8
  %arr64 = bitcast i8* %rbp to i64*
  br label %zero.loop

zero.loop:                                        ; preds = %zero.loop, %entry
  %zi = phi i64 [ 0, %entry ], [ %zi.next, %zero.loop ]
  %zgep = getelementptr inbounds i64, i64* %arr64, i64 %zi
  store i64 0, i64* %zgep, align 8
  %zi.next = add i64 %zi, 1
  %zcond = icmp ult i64 %zi.next, 24
  br i1 %zcond, label %zero.loop, label %zero.exit

zero.exit:                                        ; preds = %zero.loop
  %arr32 = bitcast i8* %rbp to i32*
  %p0 = getelementptr inbounds i32, i32* %arr32, i64 0
  store i32 0, i32* %p0, align 4
  %p1 = getelementptr inbounds i32, i32* %arr32, i64 1
  store i32 1, i32* %p1, align 4
  %n = load i64, i64* %var20.ptr, align 8
  %pn = getelementptr inbounds i32, i32* %arr32, i64 %n
  store i32 1, i32* %pn, align 4
  %p2 = getelementptr inbounds i32, i32* %arr32, i64 2
  store i32 1, i32* %p2, align 4
  %n2 = add i64 %n, %n
  %p2n = getelementptr inbounds i32, i32* %arr32, i64 %n2
  store i32 1, i32* %p2n, align 4
  %n_plus_3 = add i64 %n, 3
  %pn3 = getelementptr inbounds i32, i32* %arr32, i64 %n_plus_3
  store i32 1, i32* %pn3, align 4
  %n3 = add i64 %n2, %n
  %n3p1 = add i64 %n3, 1
  %p3n1 = getelementptr inbounds i32, i32* %arr32, i64 %n3p1
  store i32 1, i32* %p3n1, align 4
  %n_plus_4 = add i64 %n, 4
  %pn4 = getelementptr inbounds i32, i32* %arr32, i64 %n_plus_4
  store i32 1, i32* %pn4, align 4
  %n4 = shl i64 %n, 2
  %n4p1 = add i64 %n4, 1
  %p4n1 = getelementptr inbounds i32, i32* %arr32, i64 %n4p1
  store i32 1, i32* %p4n1, align 4
  %n2p5 = add i64 %n2, 5
  %p2n5 = getelementptr inbounds i32, i32* %arr32, i64 %n2p5
  store i32 1, i32* %p2n5, align 4
  %n5 = add i64 %n4, %n
  %n5p2 = add i64 %n5, 2
  %p5n2 = getelementptr inbounds i32, i32* %arr32, i64 %n5p2
  store i32 1, i32* %p5n2, align 4
  %n4p5 = add i64 %n4, 5
  %p4n5 = getelementptr inbounds i32, i32* %arr32, i64 %n4p5
  store i32 1, i32* %p4n5, align 4
  %n5p4 = add i64 %n5, 4
  %p5n4 = getelementptr inbounds i32, i32* %arr32, i64 %n5p4
  store i32 1, i32* %p5n4, align 4
  %n5p6 = add i64 %n5, 6
  %p5n6 = getelementptr inbounds i32, i32* %arr32, i64 %n5p6
  store i32 1, i32* %p5n6, align 4
  %n6 = add i64 %n5, %n        ; 6n
  %n6p5 = add i64 %n6, 5
  %p6n5 = getelementptr inbounds i32, i32* %arr32, i64 %n6p5
  store i32 1, i32* %p6n5, align 4
  %var28.ptr.i8 = getelementptr inbounds i8, i8* %rbp, i64 200
  %var28.ptr = bitcast i8* %var28.ptr.i8 to i64*
  store i64 0, i64* %var28.ptr, align 8
  %var138.ptr.i8 = getelementptr inbounds i8, i8* %rbp, i64 -72
  %var138.ptr = bitcast i8* %var138.ptr.i8 to i64*
  store i64 0, i64* %var138.ptr, align 8
  %var130.ptr.i8 = getelementptr inbounds i8, i8* %rbp, i64 -64
  %var130.ptr = bitcast i8* %var130.ptr.i8 to i64*
  %start = load i64, i64* %var28.ptr, align 8
  call void @dfs(i8* %rbp, i64 %n, i64 %start, i64* %var130.ptr, i64* %var138.ptr)
  %start2 = load i64, i64* %var28.ptr, align 8
  %fmt = getelementptr inbounds [24 x i8], [24 x i8]* @_Format, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt, i64 %start2)
  %var18.ptr.i8 = getelementptr inbounds i8, i8* %rbp, i64 216
  %var18.ptr = bitcast i8* %var18.ptr.i8 to i64*
  store i64 0, i64* %var18.ptr, align 8
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %zero.exit
  %idx = load i64, i64* %var18.ptr, align 8
  %len = load i64, i64* %var138.ptr, align 8
  %cmp = icmp ult i64 %idx, %len
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %idxp1 = add i64 %idx, 1
  %is_last = icmp uge i64 %idxp1, %len
  br i1 %is_last, label %choose.empty, label %choose.space

choose.space:                                     ; preds = %loop.body
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @asc_140004018, i64 0, i64 0
  br label %choose.join

choose.empty:                                     ; preds = %loop.body
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_14000401A, i64 0, i64 0
  br label %choose.join

choose.join:                                      ; preds = %choose.empty, %choose.space
  %delim = phi i8* [ %space.ptr, %choose.space ], [ %empty.ptr, %choose.empty ]
  %elem.ptr = getelementptr inbounds i64, i64* %var130.ptr, i64 %idx
  %elem = load i64, i64* %elem.ptr, align 8
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %elem, i8* %delim)
  %idx.next = add i64 %idx, 1
  store i64 %idx.next, i64* %var18.ptr, align 8
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %pc = call i32 @putchar(i32 10)
  ret i32 0
}