; ModuleID = 'main_module'
target triple = "x86_64-pc-linux-gnu"

@.str.header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.space  = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty  = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.item   = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1

declare void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_len)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1)

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %out = alloca [49 x i64], align 16
  %out_len = alloca i64, align 8
  %start = alloca i64, align 8

  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  %adj.idx1.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj.idx1.ptr, align 4
  %adj.idx2.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj.idx2.ptr, align 4

  %adj.idx7.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %adj.idx7.ptr, align 4
  %adj.idx10.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %adj.idx10.ptr, align 4
  %adj.idx11.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %adj.idx11.ptr, align 4
  %adj.idx14.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %adj.idx14.ptr, align 4
  %adj.idx19.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %adj.idx19.ptr, align 4
  %adj.idx22.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %adj.idx22.ptr, align 4
  %adj.idx29.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %adj.idx29.ptr, align 4
  %adj.idx33.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %adj.idx33.ptr, align 4
  %adj.idx37.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %adj.idx37.ptr, align 4
  %adj.idx39.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %adj.idx39.ptr, align 4
  %adj.idx41.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %adj.idx41.ptr, align 4
  %adj.idx47.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %adj.idx47.ptr, align 4

  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %out.base = getelementptr inbounds [49 x i64], [49 x i64]* %out, i64 0, i64 0
  call void @dfs(i32* %adj.base, i64 7, i64 0, i64* %out.base, i64* %out_len)

  %fmt.hdr.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.header, i64 0, i64 0
  %start.val = load i64, i64* %start, align 8
  %printf.hdr.call = call i32 (i8*, ...) @printf(i8* %fmt.hdr.ptr, i64 %start.val)

  br label %loop.cond

loop.cond:
  %i.phi = phi i64 [ 0, %entry ], [ %i.next, %loop.body.end ]
  %len.cur = load i64, i64* %out_len, align 8
  %cmp.more = icmp ult i64 %i.phi, %len.cur
  br i1 %cmp.more, label %loop.body, label %loop.end

loop.body:
  %i.plus1 = add i64 %i.phi, 1
  %len.again = load i64, i64* %out_len, align 8
  %cmp.space = icmp ult i64 %i.plus1, %len.again
  br i1 %cmp.space, label %delim.space, label %delim.empty

delim.space:
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  br label %delim.merge

delim.empty:
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  br label %delim.merge

delim.merge:
  %delim.sel = phi i8* [ %space.ptr, %delim.space ], [ %empty.ptr, %delim.empty ]
  %elem.ptr = getelementptr inbounds [49 x i64], [49 x i64]* %out, i64 0, i64 %i.phi
  %elem.val = load i64, i64* %elem.ptr, align 8
  %fmt.item.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.item, i64 0, i64 0
  %printf.item.call = call i32 (i8*, ...) @printf(i8* %fmt.item.ptr, i64 %elem.val, i8* %delim.sel)
  br label %loop.body.end

loop.body.end:
  %i.next = add i64 %i.phi, 1
  br label %loop.cond

loop.end:
  %putchar.call = call i32 @putchar(i32 10)
  ret i32 0
}