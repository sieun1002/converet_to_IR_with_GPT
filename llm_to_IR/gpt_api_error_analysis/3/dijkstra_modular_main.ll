; ModuleID = 'main.ll'
target triple = "x86_64-pc-linux-gnu"

@stream = external global i8*, align 8
@byte_40202C = external global [0 x i8], align 1

declare i32 @read_graph(i8*, i32*, i32*)
declare void @dijkstra(i8*, i32, i32, i8*)
declare void @print_distances(i8*, i32)
declare i32 @fprintf(i8*, i8*, ...)

define i32 @main() {
entry:
  %var_4 = alloca i32, align 4
  %var_8 = alloca i32, align 4
  %var_C = alloca i32, align 4
  %buf_graph = alloca i8, align 16
  %buf_dist = alloca i8, align 16
  store i32 0, i32* %var_4, align 4
  %call_read = call i32 @read_graph(i8* %buf_graph, i32* %var_8, i32* %var_C)
  %cmp_zero = icmp eq i32 %call_read, 0
  br i1 %cmp_zero, label %loc_401724, label %loc_err

loc_err:                                            ; corresponds to 0x4016FF..0x40171F
  %stream_val = load i8*, i8** @stream, align 8
  %fmt_ptr = getelementptr inbounds [0 x i8], [0 x i8]* @byte_40202C, i64 0, i64 0
  %call_fprintf = call i32 (i8*, i8*, ...) @fprintf(i8* %stream_val, i8* %fmt_ptr)
  store i32 1, i32* %var_4, align 4
  br label %loc_401753

loc_401724:                                         ; corresponds to 0x401724..0x40174C
  %n_val = load i32, i32* %var_8, align 4
  %m_val = load i32, i32* %var_C, align 4
  call void @dijkstra(i8* %buf_graph, i32 %n_val, i32 %m_val, i8* %buf_dist)
  %n_val2 = load i32, i32* %var_8, align 4
  call void @print_distances(i8* %buf_dist, i32 %n_val2)
  store i32 0, i32* %var_4, align 4
  br label %loc_401753

loc_401753:                                         ; corresponds to function epilogue
  %ret_load = load i32, i32* %var_4, align 4
  ret i32 %ret_load
}