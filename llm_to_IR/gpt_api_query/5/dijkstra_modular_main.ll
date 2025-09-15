; ModuleID = 'recovered.ll'
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@__bss_start = external global i8
@byte_40202C = external global [0 x i8]

declare i32 @read_graph(i8*, i32*, i32*)
declare void @dijkstra(i8*, i32, i32, i32*)
declare void @print_distances(i32*, i32)
declare i32 @fprintf(i8*, i8*, ...)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %rc = alloca i32, align 4
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %graph = alloca [40016 x i8], align 16
  %dist = alloca [100 x i32], align 16
  store i32 0, i32* %rc, align 4

  %graph.ptr = getelementptr inbounds [40016 x i8], [40016 x i8]* %graph, i64 0, i64 0
  %call = call i32 @read_graph(i8* %graph.ptr, i32* %n, i32* %m)
  %ok = icmp eq i32 %call, 0
  br i1 %ok, label %success, label %error

error:                                            ; preds = %entry
  %fmtp = getelementptr inbounds [0 x i8], [0 x i8]* @byte_40202C, i64 0, i64 0
  %call2 = call i32 (i8*, i8*, ...) @fprintf(i8* @__bss_start, i8* %fmtp)
  store i32 1, i32* %rc, align 4
  br label %end

success:                                          ; preds = %entry
  %nval = load i32, i32* %n, align 4
  %mval = load i32, i32* %m, align 4
  %dist.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 0
  call void @dijkstra(i8* %graph.ptr, i32 %nval, i32 %mval, i32* %dist.ptr)
  call void @print_distances(i32* %dist.ptr, i32 %nval)
  store i32 0, i32* %rc, align 4
  br label %end

end:                                              ; preds = %success, %error
  %ret = load i32, i32* %rc, align 4
  ret i32 %ret
}