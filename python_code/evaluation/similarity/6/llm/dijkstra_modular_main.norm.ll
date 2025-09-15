; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/dijkstra_modular_main.ll'
source_filename = "graph_main.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type opaque

@stream = external global %struct._IO_FILE*
@.str = private unnamed_addr constant [28 x i8] c"Error: invalid graph input\0A\00", align 1

declare i32 @read_graph(i8*, i32*, i32*)

declare void @dijkstra(i8*, i32, i32, i32*)

declare void @print_distances(i32*, i32)

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...)

define i32 @main() local_unnamed_addr {
entry:
  %n.addr = alloca i32, align 4
  %m.addr = alloca i32, align 4
  %graphbuf = alloca [40016 x i8], align 16
  %distbuf1 = alloca [10104 x i32], align 16
  %distbuf1.sub = getelementptr inbounds [10104 x i32], [10104 x i32]* %distbuf1, i64 0, i64 0
  %graphbuf.ptr = getelementptr inbounds [40016 x i8], [40016 x i8]* %graphbuf, i64 0, i64 0
  %call.read_graph = call i32 @read_graph(i8* nonnull %graphbuf.ptr, i32* nonnull %n.addr, i32* nonnull %m.addr)
  %cmp = icmp eq i32 %call.read_graph, 0
  br i1 %cmp, label %if.success, label %if.error

if.error:                                         ; preds = %entry
  %stream.ptr = load %struct._IO_FILE*, %struct._IO_FILE** @stream, align 8
  %0 = call i64 @fwrite(i8* getelementptr inbounds ([28 x i8], [28 x i8]* @.str, i64 0, i64 0), i64 27, i64 1, %struct._IO_FILE* %stream.ptr)
  br label %return

if.success:                                       ; preds = %entry
  %n.val = load i32, i32* %n.addr, align 4
  %m.val = load i32, i32* %m.addr, align 4
  call void @dijkstra(i8* nonnull %graphbuf.ptr, i32 %n.val, i32 %m.val, i32* nonnull %distbuf1.sub)
  %n.val2 = load i32, i32* %n.addr, align 4
  call void @print_distances(i32* nonnull %distbuf1.sub, i32 %n.val2)
  br label %return

return:                                           ; preds = %if.success, %if.error
  %ret.addr.0 = phi i32 [ 0, %if.success ], [ 1, %if.error ]
  ret i32 %ret.addr.0
}

; Function Attrs: nofree nounwind
declare noundef i64 @fwrite(i8* nocapture noundef, i64 noundef, i64 noundef, %struct._IO_FILE* nocapture noundef) #0

attributes #0 = { nofree nounwind }
