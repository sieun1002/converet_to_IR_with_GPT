; ModuleID = 'main_recovered.ll'
source_filename = "main_recovered.c"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type opaque

declare i32 @read_graph(i8* nocapture, i32* nocapture, i32* nocapture)
declare void @dijkstra(i8* nocapture, i32, i32, i32* nocapture)
declare void @print_distances(i32* nocapture, i32)
declare i32 @fprintf(%struct._IO_FILE*, i8*, ...)

@__bss_start = external global %struct._IO_FILE
@byte_40202C = external constant i8

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %ret = alloca i32, align 4
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %graphbuf = alloca [40016 x i8], align 16
  %distbuf = alloca [40416 x i8], align 16

  store i32 0, i32* %ret, align 4

  %graphptr = getelementptr inbounds [40016 x i8], [40016 x i8]* %graphbuf, i64 0, i64 0
  %rv = call i32 @read_graph(i8* %graphptr, i32* %n, i32* %m)
  %ok = icmp eq i32 %rv, 0
  br i1 %ok, label %do_dijkstra, label %error

error:                                            ; if read_graph != 0
  %fmtptr = getelementptr i8, i8* @byte_40202C, i64 0
  %callf = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* @__bss_start, i8* %fmtptr)
  store i32 1, i32* %ret, align 4
  br label %exit

do_dijkstra:                                      ; if read_graph == 0
  %nval = load i32, i32* %n, align 4
  %mval = load i32, i32* %m, align 4
  %dist_i8 = getelementptr inbounds [40416 x i8], [40416 x i8]* %distbuf, i64 0, i64 0
  %dist_i32 = bitcast i8* %dist_i8 to i32*
  call void @dijkstra(i8* %graphptr, i32 %nval, i32 %mval, i32* %dist_i32)
  call void @print_distances(i32* %dist_i32, i32 %nval)
  store i32 0, i32* %ret, align 4
  br label %exit

exit:
  %retval = load i32, i32* %ret, align 4
  ret i32 %retval
}