; ModuleID = 'recovered.ll'
source_filename = "recovered"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type opaque

@__bss_start = external dso_local global %struct._IO_FILE*, align 8
@byte_40202C = external dso_local global [1 x i8], align 1

declare dso_local i32 @read_graph(i8* noundef, i32* noundef, i32* noundef)
declare dso_local void @dijkstra(i8* noundef, i32 noundef, i32 noundef, i8* noundef)
declare dso_local void @print_distances(i8* noundef, i32 noundef)
declare dso_local i32 @_fprintf(%struct._IO_FILE* noundef, i8* noundef, ...)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %ret = alloca i32, align 4
  %var_8 = alloca i32, align 4
  %var_C = alloca i32, align 4
  %var_9C50 = alloca [40016 x i8], align 16
  %var_9DE0 = alloca [40416 x i8], align 16
  store i32 0, i32* %ret, align 4
  %graph.ptr = getelementptr inbounds [40016 x i8], [40016 x i8]* %var_9C50, i64 0, i64 0
  %call.read = call i32 @read_graph(i8* noundef %graph.ptr, i32* noundef %var_8, i32* noundef %var_C)
  %ok = icmp eq i32 %call.read, 0
  br i1 %ok, label %do_dijkstra, label %error_path

error_path:                                       ; preds = %entry
  %stream.ptr = load %struct._IO_FILE*, %struct._IO_FILE** @__bss_start, align 8
  %fmt.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @byte_40202C, i64 0, i64 0
  %call.fprintf = call i32 (%struct._IO_FILE*, i8*, ...) @_fprintf(%struct._IO_FILE* noundef %stream.ptr, i8* noundef %fmt.ptr)
  store i32 1, i32* %ret, align 4
  br label %ret_block

do_dijkstra:                                      ; preds = %entry
  %n.val = load i32, i32* %var_8, align 4
  %m.val = load i32, i32* %var_C, align 4
  %dist.ptr = getelementptr inbounds [40416 x i8], [40416 x i8]* %var_9DE0, i64 0, i64 0
  call void @dijkstra(i8* noundef %graph.ptr, i32 noundef %n.val, i32 noundef %m.val, i8* noundef %dist.ptr)
  %n.val2 = load i32, i32* %var_8, align 4
  call void @print_distances(i8* noundef %dist.ptr, i32 noundef %n.val2)
  store i32 0, i32* %ret, align 4
  br label %ret_block

ret_block:                                        ; preds = %do_dijkstra, %error_path
  %r = load i32, i32* %ret, align 4
  ret i32 %r
}