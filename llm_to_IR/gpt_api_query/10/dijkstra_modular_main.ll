; ModuleID = 'recovered.ll'
source_filename = "recovered.c"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type opaque

@__bss_start = external global %struct._IO_FILE*, align 8
@byte_40202C = external global i8, align 1

declare i32 @read_graph(i8*, i32*, i32*)
declare void @dijkstra(i8*, i32, i32, i8*)
declare void @print_distances(i8*, i32)
declare i32 @fprintf(%struct._IO_FILE*, i8*, ...)

define i32 @main() {
entry:
  %ret = alloca i32, align 4
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %graphbuf = alloca [40016 x i8], align 16
  %distbuf = alloca [400 x i8], align 16

  store i32 0, i32* %ret, align 4

  %graphptr = getelementptr inbounds [40016 x i8], [40016 x i8]* %graphbuf, i64 0, i64 0
  %call.read = call i32 @read_graph(i8* %graphptr, i32* %n, i32* %m)
  %cond = icmp ne i32 %call.read, 0
  br i1 %cond, label %err, label %ok

err:                                              ; if read_graph != 0
  %stream = load %struct._IO_FILE*, %struct._IO_FILE** @__bss_start, align 8
  %fmt = bitcast i8* @byte_40202C to i8*
  %call.fprintf = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %stream, i8* %fmt)
  store i32 1, i32* %ret, align 4
  br label %end

ok:                                               ; if read_graph == 0
  %n.val = load i32, i32* %n, align 4
  %m.val = load i32, i32* %m, align 4
  %distptr = getelementptr inbounds [400 x i8], [400 x i8]* %distbuf, i64 0, i64 0
  call void @dijkstra(i8* %graphptr, i32 %n.val, i32 %m.val, i8* %distptr)
  %n.val2 = load i32, i32* %n, align 4
  call void @print_distances(i8* %distptr, i32 %n.val2)
  store i32 0, i32* %ret, align 4
  br label %end

end:
  %rv = load i32, i32* %ret, align 4
  ret i32 %rv
}