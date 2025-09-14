; ModuleID = 'main.ll'
source_filename = "main"

%struct._IO_FILE = type opaque

@__bss_start = external global %struct._IO_FILE*
@byte_40202C = external global i8

declare i32 @read_graph(i8*, i32*, i32*)
declare void @dijkstra(i8*, i32, i32, i8*)
declare void @print_distances(i8*, i32)
declare i32 @fprintf(%struct._IO_FILE*, i8*, ...)

define i32 @main() {
entry:
  %ret = alloca i32, align 4
  %var_8 = alloca i32, align 4
  %var_C = alloca i32, align 4
  %var_9C50 = alloca [40080 x i8], align 16
  %var_9DE0 = alloca [336 x i8], align 16

  store i32 0, i32* %ret, align 4

  %graph_ptr = getelementptr inbounds [40080 x i8], [40080 x i8]* %var_9C50, i64 0, i64 0
  %call = call i32 @read_graph(i8* %graph_ptr, i32* %var_8, i32* %var_C)
  %iszero = icmp eq i32 %call, 0
  br i1 %iszero, label %success, label %error

error:
  %stream = load %struct._IO_FILE*, %struct._IO_FILE** @__bss_start, align 8
  %call_fprintf = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %stream, i8* @byte_40202C)
  store i32 1, i32* %ret, align 4
  br label %done

success:
  %dist_ptr = getelementptr inbounds [336 x i8], [336 x i8]* %var_9DE0, i64 0, i64 0
  %v = load i32, i32* %var_8, align 4
  %e = load i32, i32* %var_C, align 4
  call void @dijkstra(i8* %graph_ptr, i32 %v, i32 %e, i8* %dist_ptr)
  call void @print_distances(i8* %dist_ptr, i32 %v)
  store i32 0, i32* %ret, align 4
  br label %done

done:
  %rv = load i32, i32* %ret, align 4
  ret i32 %rv
}