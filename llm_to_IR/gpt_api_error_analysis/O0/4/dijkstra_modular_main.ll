; ModuleID = 'main_module'
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@byte_40202C = private unnamed_addr constant [14 x i8] c"input error\0A\00", align 1
@__bss_start = external global i8*, align 8

declare i32 @read_graph(i8*, i32*, i32*)
declare void @dijkstra(i8*, i32, i32, i8*)
declare void @print_distances(i8*, i32)
declare i32 @_fprintf(i8*, i8*, ...)

define i32 @main() {
entry:
  %var_4 = alloca i32, align 4
  %var_8 = alloca i32, align 4
  %var_C = alloca i32, align 4
  %var_9C50 = alloca [1 x i8], align 1
  %var_9DE0 = alloca [1 x i8], align 1
  store i32 0, i32* %var_4, align 4
  %p_graph = getelementptr inbounds [1 x i8], [1 x i8]* %var_9C50, i64 0, i64 0
  %call_read = call i32 @read_graph(i8* %p_graph, i32* %var_8, i32* %var_C)
  %cmp = icmp eq i32 %call_read, 0
  br i1 %cmp, label %loc_401724, label %loc_4016FF

loc_4016FF:
  %streamptr = load i8*, i8** @__bss_start, align 8
  %fmtptr = getelementptr inbounds [14 x i8], [14 x i8]* @byte_40202C, i64 0, i64 0
  %call_fprintf = call i32 @_fprintf(i8* %streamptr, i8* %fmtptr)
  store i32 1, i32* %var_4, align 4
  br label %loc_401753

loc_401724:
  %n_val = load i32, i32* %var_8, align 4
  %m_val = load i32, i32* %var_C, align 4
  %out_ptr = getelementptr inbounds [1 x i8], [1 x i8]* %var_9DE0, i64 0, i64 0
  call void @dijkstra(i8* %p_graph, i32 %n_val, i32 %m_val, i8* %out_ptr)
  %n_val2 = load i32, i32* %var_8, align 4
  call void @print_distances(i8* %out_ptr, i32 %n_val2)
  store i32 0, i32* %var_4, align 4
  br label %loc_401753

loc_401753:
  %retv = load i32, i32* %var_4, align 4
  ret i32 %retv
}