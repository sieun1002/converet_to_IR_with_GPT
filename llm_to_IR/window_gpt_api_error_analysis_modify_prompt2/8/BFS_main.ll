; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@aZuS = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@asc_140004015 = private unnamed_addr constant [2 x i8] c" \00", align 1
@unk_140004017 = private unnamed_addr constant [1 x i8] c"\00", align 1
@aDistZuZuD = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare void @bfs(i32* %graph, i64 %n, i64 %start, i8* %ctx, i64* %orderOut, i64* %countOut)
declare i32 @printf(i8* %fmt, ...)
declare i32 @putchar(i32 %ch)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define dso_local i32 @main(i32 %argc, i8** %argv) {
entry:
  %var_28 = alloca i64, align 8
  %var_30 = alloca i64, align 8
  %var_18 = alloca i64, align 8
  %var_20 = alloca i64, align 8
  %var_168 = alloca i64, align 8
  %var_160 = alloca [7 x i64], align 16
  %var_100 = alloca [48 x i32], align 16
  %var_120 = alloca [7 x i32], align 16

  store i64 7, i64* %var_28, align 8

  %graph.i8 = bitcast [48 x i32]* %var_100 to i8*
  call void @llvm.memset.p0i8.i64(i8* %graph.i8, i8 0, i64 192, i1 false)

  %gidx1 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 1
  store i32 1, i32* %gidx1, align 4
  %gidx2 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 2
  store i32 1, i32* %gidx2, align 4
  %gidx7 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 7
  store i32 1, i32* %gidx7, align 4
  %gidx14 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 14
  store i32 1, i32* %gidx14, align 4
  %gidx10 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 10
  store i32 1, i32* %gidx10, align 4
  %gidx22 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 22
  store i32 1, i32* %gidx22, align 4
  %gidx11 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 11
  store i32 1, i32* %gidx11, align 4
  %gidx29 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 29
  store i32 1, i32* %gidx29, align 4
  %gidx19 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 19
  store i32 1, i32* %gidx19, align 4
  %gidx37 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 37
  store i32 1, i32* %gidx37, align 4
  %gidx33 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 33
  store i32 1, i32* %gidx33, align 4
  %gidx39 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 39
  store i32 1, i32* %gidx39, align 4
  %gidx41 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 41
  store i32 1, i32* %gidx41, align 4
  %gidx47 = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 47
  store i32 1, i32* %gidx47, align 4

  store i64 0, i64* %var_30, align 8
  store i64 0, i64* %var_168, align 8

  %graph.ptr = getelementptr inbounds [48 x i32], [48 x i32]* %var_100, i64 0, i64 0
  %n.val = load i64, i64* %var_28, align 8
  %start.val = load i64, i64* %var_30, align 8
  %ctx.ptr = bitcast i64* %var_28 to i8*
  %order.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %var_160, i64 0, i64 0
  call void @bfs(i32* %graph.ptr, i64 %n.val, i64 %start.val, i8* %ctx.ptr, i64* %order.ptr, i64* %var_168)

  %fmt0 = getelementptr inbounds [21 x i8], [21 x i8]* @_Format, i64 0, i64 0
  %start.print = load i64, i64* %var_30, align 8
  %call.printf0 = call i32 (i8*, ...) @printf(i8* %fmt0, i64 %start.print)

  store i64 0, i64* %var_18, align 8
  br label %order.loop

order.loop:
  %i.cur = phi i64 [ 0, %entry ], [ %i.next, %order.body ]
  %count.cur = load i64, i64* %var_168, align 8
  %cmp.lt = icmp ult i64 %i.cur, %count.cur
  br i1 %cmp.lt, label %order.body, label %order.done

order.body:
  %i.plus1 = add i64 %i.cur, 1
  %count.reload = load i64, i64* %var_168, align 8
  %cmp.ge = icmp uge i64 %i.plus1, %count.reload
  %spc.empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140004017, i64 0, i64 0
  %spc.space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @asc_140004015, i64 0, i64 0
  %sel.sp = select i1 %cmp.ge, i8* %spc.empty.ptr, i8* %spc.space.ptr
  %ord.elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %var_160, i64 0, i64 %i.cur
  %ord.elem = load i64, i64* %ord.elem.ptr, align 8
  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %ord.elem, i8* %sel.sp)
  %i.next = add i64 %i.cur, 1
  br label %order.loop

order.done:
  %nl = call i32 @putchar(i32 10)

  store i64 0, i64* %var_20, align 8
  br label %dist.loop

dist.loop:
  %j.cur = phi i64 [ 0, %order.done ], [ %j.next, %dist.body ]
  %n.reload = load i64, i64* %var_28, align 8
  %cmp.j = icmp ult i64 %j.cur, %n.reload
  br i1 %cmp.j, label %dist.body, label %dist.done

dist.body:
  %dist.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %var_120, i64 0, i64 %j.cur
  %dist.val = load i32, i32* %dist.ptr, align 4
  %fmt2 = getelementptr inbounds [23 x i8], [23 x i8]* @aDistZuZuD, i64 0, i64 0
  %start.reload = load i64, i64* %var_30, align 8
  %call.printf2 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %start.reload, i64 %j.cur, i32 %dist.val)
  %j.next = add i64 %j.cur, 1
  br label %dist.loop

dist.done:
  ret i32 0
}