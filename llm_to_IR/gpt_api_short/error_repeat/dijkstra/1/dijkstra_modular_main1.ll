; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x4016D0
; Intent: Read a graph, run Dijkstra, print distances; return 0 on success, 1 on error (confidence=0.86). Evidence: calls read_graph/dijkstra/print_distances; error path prints via fprintf and returns 1
; Preconditions: None
; Postconditions: Returns 0 if read_graph() succeeded and distances printed; returns 1 on read_graph() error

; Only the necessary external declarations:
@stream = external global i8*
@byte_40202C = external global i8

declare i32 @_fprintf(i8*, i8*, ...)
declare i32 @read_graph(i32*, i32*, i32*)
declare void @dijkstra(i32*, i32, i32, i32*)
declare void @print_distances(i32*, i32)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %ret = alloca i32, align 4
  %n = alloca i32, align 4
  %src = alloca i32, align 4
  %dist = alloca [100 x i32], align 16
  %graph = alloca [100 x [100 x i32]], align 16
  store i32 0, i32* %ret, align 4

  %graph_i32 = bitcast [100 x [100 x i32]]* %graph to i32*
  %rg = call i32 @read_graph(i32* %graph_i32, i32* %n, i32* %src)
  %ok = icmp eq i32 %rg, 0
  br i1 %ok, label %then_ok, label %then_err

then_err:                                         ; preds = %entry
  %stream_val = load i8*, i8** @stream, align 8
  %fmt = getelementptr inbounds i8, i8* @byte_40202C, i64 0
  %call_fprintf = call i32 (i8*, i8*, ...) @_fprintf(i8* %stream_val, i8* %fmt)
  store i32 1, i32* %ret, align 4
  br label %done

then_ok:                                          ; preds = %entry
  %nval = load i32, i32* %n, align 4
  %srcval = load i32, i32* %src, align 4
  %dist_ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 0
  call void @dijkstra(i32* %graph_i32, i32 %nval, i32 %srcval, i32* %dist_ptr)
  call void @print_distances(i32* %dist_ptr, i32 %nval)
  store i32 0, i32* %ret, align 4
  br label %done

done:                                             ; preds = %then_ok, %then_err
  %rv = load i32, i32* %ret, align 4
  ret i32 %rv
}