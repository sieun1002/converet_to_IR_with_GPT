; ModuleID = 'main_from_ida'
source_filename = "main_from_ida.ll"
target triple = "x86_64-pc-linux-gnu"

@.str.header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.space  = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty  = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.item   = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1

declare void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_len)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  %matrix = alloca [49 x i32], align 16
  %out = alloca [8 x i64], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %out_len = alloca i64, align 8
  %i = alloca i64, align 8

  ; n = 7, start = 0, out_len = 0
  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  ; zero matrix[49]
  %mat.ptr.i8 = bitcast [49 x i32]* %matrix to i8*
  call void @llvm.memset.p0i8.i64(i8* %mat.ptr.i8, i8 0, i64 196, i1 false)

  ; Build adjacency matrix using n
  %n.val = load i64, i64* %n, align 8

  ; matrix[1] = 1
  %idx1.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 1
  store i32 1, i32* %idx1.ptr, align 4

  ; matrix[n] = 1
  %idxn.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %n.val
  store i32 1, i32* %idxn.ptr, align 4

  ; matrix[2] = 1
  %idx2.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 2
  store i32 1, i32* %idx2.ptr, align 4

  ; matrix[2*n] = 1
  %mul2n = mul i64 %n.val, 2
  %idx2n.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %mul2n
  store i32 1, i32* %idx2n.ptr, align 4

  ; matrix[n+3] = 1
  %n_plus_3 = add i64 %n.val, 3
  %idxn3.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %n_plus_3
  store i32 1, i32* %idxn3.ptr, align 4

  ; matrix[3*n + 1] = 1
  %mul3n = mul i64 %n.val, 3
  %mul3n_p1 = add i64 %mul3n, 1
  %idx3n1.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %mul3n_p1
  store i32 1, i32* %idx3n1.ptr, align 4

  ; matrix[n + 4] = 1
  %n_plus_4 = add i64 %n.val, 4
  %idxn4.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %n_plus_4
  store i32 1, i32* %idxn4.ptr, align 4

  ; matrix[4*n + 1] = 1
  %mul4n = mul i64 %n.val, 4
  %mul4n_p1 = add i64 %mul4n, 1
  %idx4n1.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %mul4n_p1
  store i32 1, i32* %idx4n1.ptr, align 4

  ; matrix[2*n + 5] = 1
  %mul2n_p5 = add i64 %mul2n, 5
  %idx2n5.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %mul2n_p5
  store i32 1, i32* %idx2n5.ptr, align 4

  ; matrix[5*n + 2] = 1
  %mul5n = mul i64 %n.val, 5
  %mul5n_p2 = add i64 %mul5n, 2
  %idx5n2.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %mul5n_p2
  store i32 1, i32* %idx5n2.ptr, align 4

  ; matrix[4*n + 5] = 1
  %mul4n_p5 = add i64 %mul4n, 5
  %idx4n5.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %mul4n_p5
  store i32 1, i32* %idx4n5.ptr, align 4

  ; matrix[5*n + 4] = 1
  %mul5n_p4 = add i64 %mul5n, 4
  %idx5n4.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %mul5n_p4
  store i32 1, i32* %idx5n4.ptr, align 4

  ; matrix[5*n + 6] = 1
  %mul5n_p6 = add i64 %mul5n, 6
  %idx5n6.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %mul5n_p6
  store i32 1, i32* %idx5n6.ptr, align 4

  ; matrix[6*n + 5] = 1
  %mul6n = mul i64 %n.val, 6
  %mul6n_p5 = add i64 %mul6n, 5
  %idx6n5.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %mul6n_p5
  store i32 1, i32* %idx6n5.ptr, align 4

  ; Call dfs(&matrix[0], n, start, out, &out_len)
  %matrix.base = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 0
  %out.base = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 0
  %start.val = load i64, i64* %start, align 8
  call void @dfs(i32* %matrix.base, i64 %n.val, i64 %start.val, i64* %out.base, i64* %out_len)

  ; printf("DFS preorder from %zu: ", start)
  %fmt.header.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.header, i64 0, i64 0
  %call.printf.h = call i32 (i8*, ...) @printf(i8* %fmt.header.ptr, i64 %start.val)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.val = load i64, i64* %i, align 8
  %len.val = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %i.val, %len.val
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  ; sep = (i+1 < out_len) ? " " : ""
  %i.plus1 = add i64 %i.val, 1
  %cmp.sep = icmp ult i64 %i.plus1, %len.val
  %sep.space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %sep.empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep.ptr = select i1 %cmp.sep, i8* %sep.space.ptr, i8* %sep.empty.ptr

  ; val = out[i]
  %out.i.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 %i.val
  %out.i.val = load i64, i64* %out.i.ptr, align 8

  ; printf("%zu%s", val, sep)
  %fmt.item.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.item, i64 0, i64 0
  %call.printf.item = call i32 (i8*, ...) @printf(i8* %fmt.item.ptr, i64 %out.i.val, i8* %sep.ptr)

  ; i++
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:
  ; putchar('\n')
  %call.putchar = call i32 @putchar(i32 10)
  ret i32 0
}