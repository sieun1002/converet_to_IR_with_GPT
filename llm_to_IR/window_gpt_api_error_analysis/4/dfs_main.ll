; ModuleID = 'dfs_preorder'
target triple = "x86_64-pc-windows-msvc"

@.fmt1 = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00"
@.fmt2 = private unnamed_addr constant [6 x i8] c"%zu%s\00"
@.space = private unnamed_addr constant [2 x i8] c" \00"
@.empty = private unnamed_addr constant [1 x i8] c"\00"

; 7x7 adjacency matrix (row-major), 1 = edge, 0 = no edge
; Undirected graph:
; 0: 1,2
; 1: 0,3,4
; 2: 0,5
; 3: 1
; 4: 1,5
; 5: 2,4,6
; 6: 5
@adj = internal constant [49 x i32] [
  i32 0, i32 1, i32 1, i32 0, i32 0, i32 0, i32 0,
  i32 1, i32 0, i32 0, i32 1, i32 1, i32 0, i32 0,
  i32 1, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0,
  i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 0,
  i32 0, i32 1, i32 0, i32 0, i32 0, i32 1, i32 0,
  i32 0, i32 0, i32 1, i32 0, i32 1, i32 0, i32 1,
  i32 0, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0
]

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
define void @__main() { ret void }

define void @dfs_visit(i64 %n, i64 %v, i32* %adjp, i1* %visited, i64* %out, i64* %outLen) {
entry:
  %vis.ptr = getelementptr inbounds i1, i1* %visited, i64 %v
  %vis.val = load i1, i1* %vis.ptr, align 1
  %already = icmp ne i1 %vis.val, 0
  br i1 %already, label %ret, label %mark

mark:
  store i1 true, i1* %vis.ptr, align 1
  %len0 = load i64, i64* %outLen, align 8
  %out.elem.ptr = getelementptr inbounds i64, i64* %out, i64 %len0
  store i64 %v, i64* %out.elem.ptr, align 8
  %len1 = add i64 %len0, 1
  store i64 %len1, i64* %outLen, align 8
  br label %loop

loop:
  %i = phi i64 [ 0, %mark ], [ %i.next, %loop.body ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %loop.body, label %ret

loop.body:
  %mul = mul i64 %v, %n
  %idx = add i64 %mul, %i
  %adj.elem.ptr = getelementptr inbounds i32, i32* %adjp, i64 %idx
  %adj.val = load i32, i32* %adj.elem.ptr, align 4
  %has.edge = icmp ne i32 %adj.val, 0
  br i1 %has.edge, label %maybe.recurse, label %cont

maybe.recurse:
  %nei.vis.ptr = getelementptr inbounds i1, i1* %visited, i64 %i
  %nei.vis = load i1, i1* %nei.vis.ptr, align 1
  %not.vis = icmp eq i1 %nei.vis, 0
  br i1 %not.vis, label %do.recurse, label %cont

do.recurse:
  call void @dfs_visit(i64 %n, i64 %i, i32* %adjp, i1* %visited, i64* %out, i64* %outLen)
  br label %cont

cont:
  %i.next = add i64 %i, 1
  br label %loop

ret:
  ret void
}

define void @dfs(i64 %n, i64 %start, i32* %adjp, i64* %out, i64* %outLen) {
entry:
  %visited.arr = alloca [7 x i1], align 1
  br label %zero.loop

zero.loop:
  %zi = phi i64 [ 0, %entry ], [ %zi.next, %zero.body ]
  %zcond = icmp ult i64 %zi, 7
  br i1 %zcond, label %zero.body, label %after.zero

zero.body:
  %zptr = getelementptr inbounds [7 x i1], [7 x i1]* %visited.arr, i64 0, i64 %zi
  store i1 false, i1* %zptr, align 1
  %zi.next = add i64 %zi, 1
  br label %zero.loop

after.zero:
  %visited.base = getelementptr inbounds [7 x i1], [7 x i1]* %visited.arr, i64 0, i64 0
  call void @dfs_visit(i64 %n, i64 %start, i32* %adjp, i1* %visited.base, i64* %out, i64* %outLen)
  ret void
}

define i32 @main() {
entry:
  call void @__main()
  %out = alloca [7 x i64], align 8
  %outLen = alloca i64, align 8
  store i64 0, i64* %outLen, align 8
  %out.base = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 0
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* @adj, i64 0, i64 0
  call void @dfs(i64 7, i64 0, i32* %adj.base, i64* %out.base, i64* %outLen)
  %fmt1.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.fmt1, i64 0, i64 0
  %hcall = call i32 (i8*, ...) @printf(i8* %fmt1.ptr, i64 0)
  br label %print.loop

print.loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %after.print ]
  %len = load i64, i64* %outLen, align 8
  %more = icmp ult i64 %i, %len
  br i1 %more, label %body, label %done

body:
  %ip1 = add i64 %i, 1
  %lt = icmp ult i64 %ip1, %len
  %sp.ptr = select i1 %lt, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.space, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.empty, i64 0, i64 0)
  %val.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 %i
  %val = load i64, i64* %val.ptr, align 8
  %fmt2.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.fmt2, i64 0, i64 0
  %pcall = call i32 (i8*, ...) @printf(i8* %fmt2.ptr, i64 %val, i8* %sp.ptr)
  br label %after.print

after.print:
  %i.next = add i64 %i, 1
  br label %print.loop

done:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}