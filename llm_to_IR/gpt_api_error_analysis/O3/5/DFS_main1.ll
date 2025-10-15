; ModuleID = 'dfs_preorder_main'
source_filename = "dfs_preorder_main.ll"
target triple = "x86_64-pc-linux-gnu"

@.str.header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.format = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i32 @__printf_chk(i32, i8*, ...)
declare noalias i8* @calloc(i64, i64)
declare noalias i8* @malloc(i64)
declare void @free(i8*)

define i32 @main() local_unnamed_addr {
entry:
  %out = alloca [7 x i64], align 16
  %visited.raw = call i8* @calloc(i64 28, i64 1)
  %nextidx.raw = call i8* @calloc(i64 56, i64 1)
  %stack.raw = call i8* @malloc(i64 56)
  %vnull = icmp eq i8* %visited.raw, null
  %nnull = icmp eq i8* %nextidx.raw, null
  %vn.or = or i1 %vnull, %nnull
  %snull = icmp eq i8* %stack.raw, null
  %need_fail = or i1 %vn.or, %snull
  br i1 %need_fail, label %fail, label %init

init:                                             ; preds = %entry
  %visited = bitcast i8* %visited.raw to i32*
  %nextidx = bitcast i8* %nextidx.raw to i64*
  %stack = bitcast i8* %stack.raw to i64*
  store i64 0, i64* %stack, align 8
  store i32 1, i32* %visited, align 4
  %out0.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 0
  store i64 0, i64* %out0.ptr, align 8
  call void @free(i8* %visited.raw)
  call void @free(i8* %nextidx.raw)
  call void @free(i8* %stack.raw)
  %hdr.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.header, i64 0, i64 0
  %call.header = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %hdr.ptr, i64 0)
  %fmt.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.format, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.nl, i64 0, i64 1
  %out0.val = load i64, i64* %out0.ptr, align 8
  %call.first = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.ptr, i64 %out0.val, i8* %empty.ptr)
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0
  %call.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl.ptr)
  ret i32 0

fail:                                             ; preds = %entry
  br i1 %vnull, label %skip.free.v, label %do.free.v

do.free.v:                                        ; preds = %fail
  call void @free(i8* %visited.raw)
  br label %skip.free.v

skip.free.v:                                      ; preds = %do.free.v, %fail
  br i1 %nnull, label %skip.free.n, label %do.free.n

do.free.n:                                        ; preds = %skip.free.v
  call void @free(i8* %nextidx.raw)
  br label %skip.free.n

skip.free.n:                                      ; preds = %do.free.n, %skip.free.v
  br i1 %snull, label %printf.only, label %do.free.s

do.free.s:                                        ; preds = %skip.free.n
  call void @free(i8* %stack.raw)
  br label %printf.only

printf.only:                                      ; preds = %do.free.s, %skip.free.n
  %hdr2.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.header, i64 0, i64 0
  %call.hdr2 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %hdr2.ptr, i64 0)
  %nl2.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0
  %call.nl2 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl2.ptr)
  ret i32 0
}