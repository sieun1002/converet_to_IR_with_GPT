; ModuleID = 'recovered.ll'
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type opaque

@__bss_start = external global %struct._IO_FILE* ; stream
@byte_40202C = external global [0 x i8]           ; format

declare i32 @read_graph(i8* noundef, i32* noundef, i32* noundef)
declare void @dijkstra(i8* noundef, i32 noundef, i32 noundef, i8* noundef)
declare void @print_distances(i8* noundef, i32 noundef)
declare i32 @_fprintf(%struct._IO_FILE* noundef, i8* noundef, ...)

define i32 @main(i32 noundef %argc, i8** noundef %argv) {
entry:
  %ret = alloca i32, align 4
  %n = alloca i32, align 4
  %start = alloca i32, align 4
  %graph = alloca [40016 x i8], align 16
  %dist = alloca [400 x i8], align 16

  store i32 0, i32* %ret, align 4

  %graph.ptr = getelementptr inbounds [40016 x i8], [40016 x i8]* %graph, i64 0, i64 0
  %rg = call i32 @read_graph(i8* noundef %graph.ptr, i32* noundef %n, i32* noundef %start)
  %ok = icmp eq i32 %rg, 0
  br i1 %ok, label %do_dijkstra, label %err

err:                                              ; preds = %entry
  %stream.val = load %struct._IO_FILE*, %struct._IO_FILE** @__bss_start, align 8
  %fmt.ptr = getelementptr inbounds [0 x i8], [0 x i8]* @byte_40202C, i64 0, i64 0
  %callfprintf = call i32 (%struct._IO_FILE*, i8*, ...) @_fprintf(%struct._IO_FILE* noundef %stream.val, i8* noundef %fmt.ptr)
  store i32 1, i32* %ret, align 4
  br label %done

do_dijkstra:                                      ; preds = %entry
  %n.val = load i32, i32* %n, align 4
  %start.val = load i32, i32* %start, align 4
  %dist.ptr = getelementptr inbounds [400 x i8], [400 x i8]* %dist, i64 0, i64 0
  call void @dijkstra(i8* noundef %graph.ptr, i32 noundef %n.val, i32 noundef %start.val, i8* noundef %dist.ptr)
  %n.val2 = load i32, i32* %n, align 4
  call void @print_distances(i8* noundef %dist.ptr, i32 noundef %n.val2)
  store i32 0, i32* %ret, align 4
  br label %done

done:                                             ; preds = %do_dijkstra, %err
  %rv = load i32, i32* %ret, align 4
  ret i32 %rv
}