; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@aZuS = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@asc_140004018 = private unnamed_addr constant [2 x i8] c" \00", align 1
@unk_14000401A = private unnamed_addr constant [1 x i8] c"\00", align 1

declare dso_local void @dfs(i32*, i64, i64, i64*, i64*)
declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define dso_local i32 @main() {
entry:
  %matrix = alloca [49 x i32], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %out = alloca [64 x i64], align 16
  %count = alloca i64, align 8
  %matrix.i8 = bitcast [49 x i32]* %matrix to i8*
  call void @llvm.memset.p0i8.i64(i8* %matrix.i8, i8 0, i64 192, i1 false)
  %mat.base = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 0
  store i32 0, i32* %mat.base, align 4
  store i64 7, i64* %n, align 8
  %p1 = getelementptr inbounds i32, i32* %mat.base, i64 1
  store i32 1, i32* %p1, align 4
  %nv = load i64, i64* %n, align 8
  %p_n = getelementptr inbounds i32, i32* %mat.base, i64 %nv
  store i32 1, i32* %p_n, align 4
  %p2 = getelementptr inbounds i32, i32* %mat.base, i64 2
  store i32 1, i32* %p2, align 4
  %nv_shl1 = shl i64 %nv, 1
  %p_2n = getelementptr inbounds i32, i32* %mat.base, i64 %nv_shl1
  store i32 1, i32* %p_2n, align 4
  %nv_add3 = add i64 %nv, 3
  %p_n_plus_3 = getelementptr inbounds i32, i32* %mat.base, i64 %nv_add3
  store i32 1, i32* %p_n_plus_3, align 4
  %t_3n = add i64 %nv_shl1, %nv
  %t_3n_plus_1 = add i64 %t_3n, 1
  %p_3n_plus_1 = getelementptr inbounds i32, i32* %mat.base, i64 %t_3n_plus_1
  store i32 1, i32* %p_3n_plus_1, align 4
  %nv_add4 = add i64 %nv, 4
  %p_n_plus_4 = getelementptr inbounds i32, i32* %mat.base, i64 %nv_add4
  store i32 1, i32* %p_n_plus_4, align 4
  %t_4n = shl i64 %nv, 2
  %t_4n_plus_1 = add i64 %t_4n, 1
  %p_4n_plus_1 = getelementptr inbounds i32, i32* %mat.base, i64 %t_4n_plus_1
  store i32 1, i32* %p_4n_plus_1, align 4
  %t_2n_plus_5 = add i64 %nv_shl1, 5
  %p_2n_plus_5 = getelementptr inbounds i32, i32* %mat.base, i64 %t_2n_plus_5
  store i32 1, i32* %p_2n_plus_5, align 4
  %t_5n = add i64 %t_4n, %nv
  %t_5n_plus_2 = add i64 %t_5n, 2
  %p_5n_plus_2 = getelementptr inbounds i32, i32* %mat.base, i64 %t_5n_plus_2
  store i32 1, i32* %p_5n_plus_2, align 4
  %t_4n_plus_5 = add i64 %t_4n, 5
  %p_4n_plus_5 = getelementptr inbounds i32, i32* %mat.base, i64 %t_4n_plus_5
  store i32 1, i32* %p_4n_plus_5, align 4
  %t_5n_plus_4 = add i64 %t_5n, 4
  %p_5n_plus_4 = getelementptr inbounds i32, i32* %mat.base, i64 %t_5n_plus_4
  store i32 1, i32* %p_5n_plus_4, align 4
  %t_5n_plus_6 = add i64 %t_5n, 6
  %p_5n_plus_6 = getelementptr inbounds i32, i32* %mat.base, i64 %t_5n_plus_6
  store i32 1, i32* %p_5n_plus_6, align 4
  %t_6n = add i64 %t_5n, %nv
  %t_6n_plus_5 = add i64 %t_6n, 5
  %p_6n_plus_5 = getelementptr inbounds i32, i32* %mat.base, i64 %t_6n_plus_5
  store i32 1, i32* %p_6n_plus_5, align 4
  store i64 0, i64* %start, align 8
  store i64 0, i64* %count, align 8
  %out.base = getelementptr inbounds [64 x i64], [64 x i64]* %out, i64 0, i64 0
  %fmt1.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @_Format, i64 0, i64 0
  %start.val = load i64, i64* %start, align 8
  call void @dfs(i32* %mat.base, i64 %nv, i64 %start.val, i64* %out.base, i64* %count)
  %start.val2 = load i64, i64* %start, align 8
  %call.printf.header = call i32 (i8*, ...) @printf(i8* %fmt1.ptr, i64 %start.val2)
  br label %loop

loop:
  %i.phi = phi i64 [ 0, %entry ], [ %i.next, %body ]
  %cnt.cur = load i64, i64* %count, align 8
  %cmp.loop = icmp ult i64 %i.phi, %cnt.cur
  br i1 %cmp.loop, label %body, label %after

body:
  %i.plus1 = add i64 %i.phi, 1
  %cnt.cur2 = load i64, i64* %count, align 8
  %is_last = icmp uge i64 %i.plus1, %cnt.cur2
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @asc_140004018, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_14000401A, i64 0, i64 0
  %suffix.sel = select i1 %is_last, i8* %empty.ptr, i8* %space.ptr
  %out.elem.ptr = getelementptr inbounds i64, i64* %out.base, i64 %i.phi
  %out.elem = load i64, i64* %out.elem.ptr, align 8
  %fmt2.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  %call.printf.item = call i32 (i8*, ...) @printf(i8* %fmt2.ptr, i64 %out.elem, i8* %suffix.sel)
  %i.next = add i64 %i.phi, 1
  br label %loop

after:
  %call.putchar = call i32 @putchar(i32 10)
  ret i32 0
}