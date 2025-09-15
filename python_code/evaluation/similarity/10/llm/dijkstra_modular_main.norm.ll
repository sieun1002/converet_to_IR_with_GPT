; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/dijkstra_modular_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/dijkstra_modular_main.ll"
target triple = "x86_64-pc-linux-gnu"

@__bss_start = external global i8*
@byte_40202C = private unnamed_addr constant [13 x i8] c"input error\0A\00", align 1

declare i32 @read_graph(i8*, i32*, i32*)

declare void @dijkstra(i8*, i32, i32, i8*)

declare void @print_distances(i8*, i32)

declare i32 @fprintf(i8*, i8*, ...)

define i32 @main() local_unnamed_addr {
entry:
  %n = alloca i32, align 4
  %src = alloca i32, align 4
  %graph = alloca [40016 x i8], align 16
  %dist = alloca [400 x i8], align 16
  %graph.ptr = getelementptr inbounds [40016 x i8], [40016 x i8]* %graph, i64 0, i64 0
  %dist.ptr = getelementptr inbounds [400 x i8], [400 x i8]* %dist, i64 0, i64 0
  %call.read = call i32 @read_graph(i8* nonnull %graph.ptr, i32* nonnull %n, i32* nonnull %src)
  %cmp = icmp eq i32 %call.read, 0
  br i1 %cmp, label %ok, label %err

err:                                              ; preds = %entry
  %stream.ptr = load i8*, i8** @__bss_start, align 8
  %0 = call i64 @fwrite(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @byte_40202C, i64 0, i64 0), i64 12, i64 1, i8* %stream.ptr)
  br label %exit

ok:                                               ; preds = %entry
  %n.val = load i32, i32* %n, align 4
  %src.val = load i32, i32* %src, align 4
  call void @dijkstra(i8* nonnull %graph.ptr, i32 %n.val, i32 %src.val, i8* nonnull %dist.ptr)
  %n.val2 = load i32, i32* %n, align 4
  call void @print_distances(i8* nonnull %dist.ptr, i32 %n.val2)
  br label %exit

exit:                                             ; preds = %ok, %err
  %status.0 = phi i32 [ 0, %ok ], [ 1, %err ]
  ret i32 %status.0
}

; Function Attrs: nofree nounwind
declare noundef i64 @fwrite(i8* nocapture noundef, i64 noundef, i64 noundef, i8* nocapture noundef) #0

attributes #0 = { nofree nounwind }
