; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str.format = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.pair = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define void @dfs(i32* %adj, i64 %n, i64 %start, i8* %vis, i64* %out, i64* %cnt) {
entry:
  %vptr = getelementptr inbounds i8, i8* %vis, i64 %start
  %vload = load i8, i8* %vptr, align 1
  %viscmp = icmp ne i8 %vload, 0
  br i1 %viscmp, label %ret, label %notvis

notvis:
  store i8 1, i8* %vptr, align 1
  %c0 = load i64, i64* %cnt, align 8
  %outptr = getelementptr inbounds i64, i64* %out, i64 %c0
  store i64 %start, i64* %outptr, align 8
  %c1 = add i64 %c0, 1
  store i64 %c1, i64* %cnt, align 8
  br label %loop

loop:
  %i = phi i64 [ 0, %notvis ], [ %i.next, %loop.inc ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %loop.body, label %ret

loop.body:
  %rowmul = mul i64 %start, %n
  %flat = add i64 %rowmul, %i
  %adjptr = getelementptr inbounds i32, i32* %adj, i64 %flat
  %aval = load i32, i32* %adjptr, align 4
  %has = icmp ne i32 %aval, 0
  br i1 %has, label %checkvis, label %loop.inc

checkvis:
  %vptr2 = getelementptr inbounds i8, i8* %vis, i64 %i
  %vload2 = load i8, i8* %vptr2, align 1
  %notvisited = icmp eq i8 %vload2, 0
  br i1 %notvisited, label %recurse, label %loop.inc

recurse:
  call void @dfs(i32* %adj, i64 %n, i64 %i, i8* %vis, i64* %out, i64* %cnt)
  br label %loop.inc

loop.inc:
  %i.next = add i64 %i, 1
  br label %loop

ret:
  ret void
}

define i32 @main() {
entry:
  %adjarr = alloca [49 x i32], align 16
  %visarr = alloca [7 x i8], align 1
  %outarr = alloca [7 x i64], align 16
  %count = alloca i64, align 8
  store i64 0, i64* %count, align 8
  %adjarr.i8 = bitcast [49 x i32]* %adjarr to i8*
  call void @llvm.memset.p0i8.i64(i8* %adjarr.i8, i8 0, i64 196, i1 false)
  %visarr.i8 = getelementptr inbounds [7 x i8], [7 x i8]* %visarr, i64 0, i64 0
  call void @llvm.memset.p0i8.i64(i8* %visarr.i8, i8 0, i64 7, i1 false)
  %outarr.i8 = bitcast [7 x i64]* %outarr to i8*
  call void @llvm.memset.p0i8.i64(i8* %outarr.i8, i8 0, i64 56, i1 false)
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adjarr, i64 0, i64 0
  %vis.base = getelementptr inbounds [7 x i8], [7 x i8]* %visarr, i64 0, i64 0
  %out.base = getelementptr inbounds [7 x i64], [7 x i64]* %outarr, i64 0, i64 0
  %idx_10 = mul i64 1, 7
  %idx_10b = add i64 %idx_10, 0
  %ptr_10 = getelementptr inbounds i32, i32* %adj.base, i64 %idx_10b
  store i32 1, i32* %ptr_10, align 4
  %idx_20 = mul i64 2, 7
  %idx_20b = add i64 %idx_20, 0
  %ptr_20 = getelementptr inbounds i32, i32* %adj.base, i64 %idx_20b
  store i32 1, i32* %ptr_20, align 4
  %idx_13a = mul i64 1, 7
  %idx_13 = add i64 %idx_13a, 3
  %ptr_13 = getelementptr inbounds i32, i32* %adj.base, i64 %idx_13
  store i32 1, i32* %ptr_13, align 4
  %idx_31a = mul i64 3, 7
  %idx_31 = add i64 %idx_31a, 1
  %ptr_31 = getelementptr inbounds i32, i32* %adj.base, i64 %idx_31
  store i32 1, i32* %ptr_31, align 4
  %idx_14a = mul i64 1, 7
  %idx_14 = add i64 %idx_14a, 4
  %ptr_14 = getelementptr inbounds i32, i32* %adj.base, i64 %idx_14
  store i32 1, i32* %ptr_14, align 4
  %idx_41a = mul i64 4, 7
  %idx_41 = add i64 %idx_41a, 1
  %ptr_41 = getelementptr inbounds i32, i32* %adj.base, i64 %idx_41
  store i32 1, i32* %ptr_41, align 4
  %idx_25a = mul i64 2, 7
  %idx_25 = add i64 %idx_25a, 5
  %ptr_25 = getelementptr inbounds i32, i32* %adj.base, i64 %idx_25
  store i32 1, i32* %ptr_25, align 4
  %idx_52a = mul i64 5, 7
  %idx_52 = add i64 %idx_52a, 2
  %ptr_52 = getelementptr inbounds i32, i32* %adj.base, i64 %idx_52
  store i32 1, i32* %ptr_52, align 4
  %idx_45a = mul i64 4, 7
  %idx_45 = add i64 %idx_45a, 5
  %ptr_45 = getelementptr inbounds i32, i32* %adj.base, i64 %idx_45
  store i32 1, i32* %ptr_45, align 4
  %idx_54a = mul i64 5, 7
  %idx_54 = add i64 %idx_54a, 4
  %ptr_54 = getelementptr inbounds i32, i32* %adj.base, i64 %idx_54
  store i32 1, i32* %ptr_54, align 4
  %idx_56a = mul i64 5, 7
  %idx_56 = add i64 %idx_56a, 6
  %ptr_56 = getelementptr inbounds i32, i32* %adj.base, i64 %idx_56
  store i32 1, i32* %ptr_56, align 4
  %idx_65a = mul i64 6, 7
  %idx_65 = add i64 %idx_65a, 5
  %ptr_65 = getelementptr inbounds i32, i32* %adj.base, i64 %idx_65
  store i32 1, i32* %ptr_65, align 4
  call void @dfs(i32* %adj.base, i64 7, i64 0, i8* %vis.base, i64* %out.base, i64* %count)
  %fmt.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.format, i64 0, i64 0
  %pr0 = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i64 0)
  br label %loop2

loop2:
  %i2 = phi i64 [ 0, %entry ], [ %i2.next, %afterprint ]
  %cnt.load = load i64, i64* %count, align 8
  %cmp2 = icmp ult i64 %i2, %cnt.load
  br i1 %cmp2, label %body2, label %end2

body2:
  %ip1 = add i64 %i2, 1
  %cmpnext = icmp ult i64 %ip1, %cnt.load
  br i1 %cmpnext, label %space, label %empty

space:
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  br label %sel

empty:
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  br label %sel

sel:
  %strphi = phi i8* [ %space.ptr, %space ], [ %empty.ptr, %empty ]
  %out.elem.ptr = getelementptr inbounds i64, i64* %out.base, i64 %i2
  %out.val = load i64, i64* %out.elem.ptr, align 8
  %fmt2.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.pair, i64 0, i64 0
  %pr1 = call i32 (i8*, ...) @printf(i8* %fmt2.ptr, i64 %out.val, i8* %strphi)
  br label %afterprint

afterprint:
  %i2.next = add i64 %i2, 1
  br label %loop2

end2:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}