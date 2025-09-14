; ModuleID = 'recovered'
source_filename = "recovered.ll"

@.str.pre   = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.elem  = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1

declare void @dfs(i32* noundef, i64 noundef, i64 noundef, i64* noundef, i64* noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define dso_local i32 @main(i32 noundef %argc, i8** noundef %argv) local_unnamed_addr {
entry:
  ; locals
  %adj      = alloca [49 x i32], align 16
  %out      = alloca [7 x i64], align 16
  %out_len  = alloca i64, align 8
  %i        = alloca i64, align 8

  ; zero-initialize 7x7 adjacency matrix (49 i32 = 196 bytes)
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* align 16 %adj.i8, i8 0, i64 196, i1 false)

  ; base pointers
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %out.base = getelementptr inbounds [7 x i64],  [7 x i64]*  %out, i64 0, i64 0

  ; set undirected edges in adjacency matrix for N = 7
  ; (0,1) and (1,0)
  %p01 = getelementptr inbounds i32, i32* %adj.base, i64 1
  store i32 1, i32* %p01, align 4
  %p10 = getelementptr inbounds i32, i32* %adj.base, i64 7
  store i32 1, i32* %p10, align 4

  ; (0,2) and (2,0)
  %p02 = getelementptr inbounds i32, i32* %adj.base, i64 2
  store i32 1, i32* %p02, align 4
  %p20 = getelementptr inbounds i32, i32* %adj.base, i64 14
  store i32 1, i32* %p20, align 4

  ; (1,3) and (3,1)
  %p13 = getelementptr inbounds i32, i32* %adj.base, i64 10
  store i32 1, i32* %p13, align 4
  %p31 = getelementptr inbounds i32, i32* %adj.base, i64 22
  store i32 1, i32* %p31, align 4

  ; (1,4) and (4,1)
  %p14 = getelementptr inbounds i32, i32* %adj.base, i64 11
  store i32 1, i32* %p14, align 4
  %p41 = getelementptr inbounds i32, i32* %adj.base, i64 29
  store i32 1, i32* %p41, align 4

  ; (2,5) and (5,2)
  %p25 = getelementptr inbounds i32, i32* %adj.base, i64 19
  store i32 1, i32* %p25, align 4
  %p52 = getelementptr inbounds i32, i32* %adj.base, i64 37
  store i32 1, i32* %p52, align 4

  ; (4,5) and (5,4)
  %p45 = getelementptr inbounds i32, i32* %adj.base, i64 33
  store i32 1, i32* %p45, align 4
  %p54 = getelementptr inbounds i32, i32* %adj.base, i64 39
  store i32 1, i32* %p54, align 4

  ; (5,6) and (6,5)
  %p56 = getelementptr inbounds i32, i32* %adj.base, i64 41
  store i32 1, i32* %p56, align 4
  %p65 = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %p65, align 4

  ; prepare call to dfs
  store i64 0, i64* %out_len, align 8
  call void @dfs(i32* noundef %adj.base, i64 noundef 7, i64 noundef 0, i64* noundef %out.base, i64* noundef %out_len)

  ; print header: "DFS preorder from %zu: " with start=0
  %fmt.pre = getelementptr inbounds [24 x i8], [24 x i8]* @.str.pre, i64 0, i64 0
  %_ = call i32 (i8*, ...) @printf(i8* noundef %fmt.pre, i64 noundef 0)

  ; print sequence: for (i = 0; i < out_len; ++i) printf("%zu%s", out[i], i+1 < out_len ? " " : "")
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %count = load i64, i64* %out_len, align 8
  %iv = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %iv, %count
  br i1 %cmp, label %body, label %after

body:
  %next = add i64 %iv, 1
  %has_next = icmp ult i64 %next, %count
  %sep.space = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %sep.empty = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep.sel = select i1 %has_next, i8* %sep.space, i8* %sep.empty

  %val.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 %iv
  %val = load i64, i64* %val.ptr, align 8

  %fmt.elem = getelementptr inbounds [6 x i8], [6 x i8]* @.str.elem, i64 0, i64 0
  %__ = call i32 (i8*, ...) @printf(i8* noundef %fmt.elem, i64 noundef %val, i8* noundef %sep.sel)

  %inc = add i64 %iv, 1
  store i64 %inc, i64* %i, align 8
  br label %loop

after:
  %nl = call i32 @putchar(i32 noundef 10)
  ret i32 0
}