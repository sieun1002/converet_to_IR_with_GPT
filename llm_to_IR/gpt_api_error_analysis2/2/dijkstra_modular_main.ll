; ModuleID = 'dijkstra_main.ll'
source_filename = "dijkstra_main.c"
target triple = "x86_64-unknown-linux-gnu"

@__bss_start = external global i8*
@byte_40202C = external global i8

declare i32 @read_graph(i8*, i32*, i32*)
declare void @dijkstra(i8*, i32, i32, i8*)
declare void @print_distances(i8*, i32)
declare i32 @_fprintf(i8*, i8*, ...)

define i32 @main() {
entry:
  %retvar = alloca i32, align 4
  %graph.buf = alloca [40016 x i8], align 16
  %dist.buf = alloca [912 x i8], align 16
  %var_8 = alloca i32, align 4
  %var_C = alloca i32, align 4
  store i32 0, i32* %retvar, align 4
  %graph.ptr = getelementptr inbounds [40016 x i8], [40016 x i8]* %graph.buf, i64 0, i64 0
  %call.read = call i32 @read_graph(i8* %graph.ptr, i32* %var_8, i32* %var_C)
  %cmp.read = icmp eq i32 %call.read, 0
  br i1 %cmp.read, label %loc_401724, label %loc_4016FF

loc_4016FF:                                        ; error path
  %stream.ld = load i8*, i8** @__bss_start, align 8
  %call.fprintf = call i32 (i8*, i8*, ...) @_fprintf(i8* %stream.ld, i8* @byte_40202C)
  store i32 1, i32* %retvar, align 4
  br label %loc_401753

loc_401724:                                        ; success path
  %graph.ptr2 = getelementptr inbounds [40016 x i8], [40016 x i8]* %graph.buf, i64 0, i64 0
  %v8.ld = load i32, i32* %var_8, align 4
  %vC.ld = load i32, i32* %var_C, align 4
  %dist.ptr = getelementptr inbounds [912 x i8], [912 x i8]* %dist.buf, i64 0, i64 0
  call void @dijkstra(i8* %graph.ptr2, i32 %v8.ld, i32 %vC.ld, i8* %dist.ptr)
  %v8.ld2 = load i32, i32* %var_8, align 4
  call void @print_distances(i8* %dist.ptr, i32 %v8.ld2)
  store i32 0, i32* %retvar, align 4
  br label %loc_401753

loc_401753:
  %ret.ld = load i32, i32* %retvar, align 4
  ret i32 %ret.ld
}