; ModuleID = 'main.ll'
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type opaque

@stream = external global %struct._IO_FILE*
@.str = private unnamed_addr constant [29 x i8] c"Error: failed to read graph\0A\00", align 1

declare i32 @read_graph(i8* noundef, i32* noundef, i32* noundef)
declare void @dijkstra(i8* noundef, i32 noundef, i32 noundef, i8* noundef)
declare void @print_distances(i8* noundef, i32 noundef)
declare i32 @fprintf(%struct._IO_FILE* noundef, i8* noundef, ...)

define i32 @main() {
entry:
  %ret = alloca i32, align 4
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %frame = alloca [40416 x i8], align 16
  store i32 0, i32* %ret, align 4
  %dist_ptr = getelementptr inbounds [40416 x i8], [40416 x i8]* %frame, i64 0, i64 0
  %graph_ptr = getelementptr inbounds [40416 x i8], [40416 x i8]* %frame, i64 0, i64 400
  %rg = call i32 @read_graph(i8* noundef %graph_ptr, i32* noundef %n, i32* noundef %m)
  %okcmp = icmp eq i32 %rg, 0
  br i1 %okcmp, label %loc_401724, label %err

err:
  %stream_ld = load %struct._IO_FILE*, %struct._IO_FILE** @stream, align 8
  %fmt = getelementptr inbounds [29 x i8], [29 x i8]* @.str, i64 0, i64 0
  %call_fprintf = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* noundef %stream_ld, i8* noundef %fmt)
  store i32 1, i32* %ret, align 4
  br label %loc_401753

loc_401724:
  %n_ld = load i32, i32* %n, align 4
  %m_ld = load i32, i32* %m, align 4
  call void @dijkstra(i8* noundef %graph_ptr, i32 noundef %n_ld, i32 noundef %m_ld, i8* noundef %dist_ptr)
  %n_ld2 = load i32, i32* %n, align 4
  call void @print_distances(i8* noundef %dist_ptr, i32 noundef %n_ld2)
  store i32 0, i32* %ret, align 4
  br label %loc_401753

loc_401753:
  %ret_ld = load i32, i32* %ret, align 4
  ret i32 %ret_ld
}