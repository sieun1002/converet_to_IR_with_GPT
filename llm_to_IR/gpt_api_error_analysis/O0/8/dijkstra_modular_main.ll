target triple = "x86_64-pc-linux-gnu"

@__bss_start = external global i8*
@byte_40202C = external global i8

declare i32 @read_graph(i8*, i32*, i32*)
declare void @dijkstra(i8*, i32, i32, i8*)
declare void @print_distances(i8*, i32)
declare i32 @fprintf(i8*, i8*, ...)

define i32 @main() {
entry:
  %var4 = alloca i32, align 4
  %var8 = alloca i32, align 4
  %varC = alloca i32, align 4
  %graph = alloca [40016 x i8], align 16
  %dist = alloca [40352 x i8], align 16
  store i32 0, i32* %var4, align 4
  %graphptr = getelementptr inbounds [40016 x i8], [40016 x i8]* %graph, i64 0, i64 0
  %distptr = getelementptr inbounds [40352 x i8], [40352 x i8]* %dist, i64 0, i64 0
  %call_read = call i32 @read_graph(i8* %graphptr, i32* %var8, i32* %varC)
  %cmp_ok = icmp eq i32 %call_read, 0
  br i1 %cmp_ok, label %bb_ok, label %bb_err

bb_err:
  %stream_ptr = load i8*, i8** @__bss_start
  %call_fprintf = call i32 (i8*, i8*, ...) @fprintf(i8* %stream_ptr, i8* @byte_40202C)
  store i32 1, i32* %var4, align 4
  br label %bb_end

bb_ok:
  %n_val = load i32, i32* %var8, align 4
  %src_val = load i32, i32* %varC, align 4
  call void @dijkstra(i8* %graphptr, i32 %n_val, i32 %src_val, i8* %distptr)
  %n_val2 = load i32, i32* %var8, align 4
  call void @print_distances(i8* %distptr, i32 %n_val2)
  store i32 0, i32* %var4, align 4
  br label %bb_end

bb_end:
  %retv = load i32, i32* %var4, align 4
  ret i32 %retv
}