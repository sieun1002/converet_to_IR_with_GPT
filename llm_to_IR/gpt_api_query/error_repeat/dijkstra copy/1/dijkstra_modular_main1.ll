; ModuleID = 'recovered.ll'
source_filename = "recovered"

%struct._IO_FILE = type opaque

@__bss_start = external global %struct._IO_FILE*
@byte_40202C = external global i8

declare i32 @read_graph(i8*, i32*, i32*)
declare void @dijkstra(i8*, i32, i32, i32*)
declare void @print_distances(i32*, i32)
declare i32 @fprintf(%struct._IO_FILE*, i8*, ...)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %ret = alloca i32, align 4
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %dist = alloca [100 x i32], align 16
  %graph = alloca [40016 x i8], align 16
  store i32 0, i32* %ret, align 4

  %graph.ptr = getelementptr inbounds [40016 x i8], [40016 x i8]* %graph, i64 0, i64 0
  %call.read = call i32 @read_graph(i8* %graph.ptr, i32* %n, i32* %m)
  %ok = icmp eq i32 %call.read, 0
  br i1 %ok, label %then.ok, label %then.err

then.err:                                          ; if (read_graph != 0)
  %stream = load %struct._IO_FILE*, %struct._IO_FILE** @__bss_start, align 8
  %fmt = getelementptr i8, i8* @byte_40202C, i64 0
  %call.fprintf = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %stream, i8* %fmt)
  store i32 1, i32* %ret, align 4
  br label %exit

then.ok:                                           ; if (read_graph == 0)
  %dist.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 0
  %n.val = load i32, i32* %n, align 4
  %m.val = load i32, i32* %m, align 4
  call void @dijkstra(i8* %graph.ptr, i32 %n.val, i32 %m.val, i32* %dist.ptr)
  %n.val2 = load i32, i32* %n, align 4
  call void @print_distances(i32* %dist.ptr, i32 %n.val2)
  store i32 0, i32* %ret, align 4
  br label %exit

exit:
  %ret.final = load i32, i32* %ret, align 4
  ret i32 %ret.final
}