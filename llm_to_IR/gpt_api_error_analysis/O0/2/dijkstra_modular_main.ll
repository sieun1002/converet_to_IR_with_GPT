; ModuleID = 'main.ll'
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

%struct._IO_FILE = type opaque

@stream = external global %struct._IO_FILE*
@.str = private unnamed_addr constant [21 x i8] c"Error reading graph\0A\00", align 1

declare i32 @read_graph(i8*, i32*, i32*)
declare void @dijkstra(i8*, i32, i32, i32*)
declare void @print_distances(i32*, i32)
declare i32 @fprintf(%struct._IO_FILE*, i8*, ...)

define i32 @main() local_unnamed_addr {
entry:
  %graph = alloca [40016 x i8], align 16
  %dist = alloca [100 x i32], align 16
  %ret = alloca i32, align 4
  %n = alloca i32, align 4
  %src = alloca i32, align 4
  store i32 0, i32* %ret, align 4
  %graph.bc = bitcast [40016 x i8]* %graph to i8*
  %call = call i32 @read_graph(i8* nonnull %graph.bc, i32* nonnull %n, i32* nonnull %src)
  %cmp = icmp eq i32 %call, 0
  br i1 %cmp, label %ok, label %fail

fail:                                             ; preds = %entry
  %streamptr = load %struct._IO_FILE*, %struct._IO_FILE** @stream, align 8
  %fmtptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %call1 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %streamptr, i8* %fmtptr)
  store i32 1, i32* %ret, align 4
  br label %end

ok:                                               ; preds = %entry
  %nval = load i32, i32* %n, align 4
  %srcval = load i32, i32* %src, align 4
  %dist0 = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 0
  call void @dijkstra(i8* %graph.bc, i32 %nval, i32 %srcval, i32* %dist0)
  %nval2 = load i32, i32* %n, align 4
  call void @print_distances(i32* %dist0, i32 %nval2)
  store i32 0, i32* %ret, align 4
  br label %end

end:                                              ; preds = %ok, %fail
  %retv = load i32, i32* %ret, align 4
  ret i32 %retv
}