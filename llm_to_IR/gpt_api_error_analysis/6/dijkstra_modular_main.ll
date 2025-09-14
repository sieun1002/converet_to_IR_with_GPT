; ModuleID = 'graph_main'
source_filename = "graph_main.c"
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

%struct._IO_FILE = type opaque

@stream = external global %struct._IO_FILE*
@.str = private unnamed_addr constant [28 x i8] c"Error: invalid graph input\0A\00", align 1

declare i32 @read_graph(i8*, i32*, i32*)
declare void @dijkstra(i8*, i32, i32, i32*)
declare void @print_distances(i32*, i32)
declare i32 @fprintf(%struct._IO_FILE*, i8*, ...)

define i32 @main() local_unnamed_addr {
entry:
  %ret.addr = alloca i32, align 4
  %n.addr = alloca i32, align 4
  %m.addr = alloca i32, align 4
  %graphbuf = alloca [40016 x i8], align 16
  %distbuf = alloca [40416 x i8], align 16
  store i32 0, i32* %ret.addr, align 4
  %graphbuf.ptr = getelementptr inbounds [40016 x i8], [40016 x i8]* %graphbuf, i64 0, i64 0
  %call.read_graph = call i32 @read_graph(i8* nonnull %graphbuf.ptr, i32* nonnull %n.addr, i32* nonnull %m.addr)
  %cmp = icmp eq i32 %call.read_graph, 0
  br i1 %cmp, label %if.success, label %if.error

if.error:                                         ; preds = %entry
  %stream.ptr = load %struct._IO_FILE*, %struct._IO_FILE** @stream, align 8
  %fmt.ptr = getelementptr inbounds [28 x i8], [28 x i8]* @.str, i64 0, i64 0
  %call.fprintf = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %stream.ptr, i8* %fmt.ptr)
  store i32 1, i32* %ret.addr, align 4
  br label %return

if.success:                                       ; preds = %entry
  %n.val = load i32, i32* %n.addr, align 4
  %m.val = load i32, i32* %m.addr, align 4
  %distbuf.i8 = getelementptr inbounds [40416 x i8], [40416 x i8]* %distbuf, i64 0, i64 0
  %distbuf.i32 = bitcast i8* %distbuf.i8 to i32*
  call void @dijkstra(i8* nonnull %graphbuf.ptr, i32 %n.val, i32 %m.val, i32* nonnull %distbuf.i32)
  %n.val2 = load i32, i32* %n.addr, align 4
  call void @print_distances(i32* nonnull %distbuf.i32, i32 %n.val2)
  store i32 0, i32* %ret.addr, align 4
  br label %return

return:                                           ; preds = %if.success, %if.error
  %ret.final = load i32, i32* %ret.addr, align 4
  ret i32 %ret.final
}