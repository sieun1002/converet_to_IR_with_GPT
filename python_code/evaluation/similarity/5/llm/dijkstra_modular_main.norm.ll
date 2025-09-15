; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/dijkstra_modular_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/dijkstra_modular_main.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type opaque

@stderr = external global %struct._IO_FILE*
@.str = private unnamed_addr constant [26 x i8] c"Error: read_graph failed\0A\00", align 1

declare i32 @read_graph(i8*, i32*, i32*)

declare void @dijkstra(i8*, i32, i32, i32*)

declare void @print_distances(i32*, i32)

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %var_8 = alloca i32, align 4
  %var_C = alloca i32, align 4
  %graph = alloca [40016 x i8], align 16
  %dist = alloca [164 x i32], align 16
  %graph.ptr0 = getelementptr inbounds [40016 x i8], [40016 x i8]* %graph, i64 0, i64 0
  %call.read_graph = call i32 @read_graph(i8* nonnull %graph.ptr0, i32* nonnull %var_8, i32* nonnull %var_C)
  %cmp.zero = icmp eq i32 %call.read_graph, 0
  br i1 %cmp.zero, label %ok, label %err

err:                                              ; preds = %entry
  %stderr.ld = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %0 = call i64 @fwrite(i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str, i64 0, i64 0), i64 25, i64 1, %struct._IO_FILE* %stderr.ld) #1
  br label %exit

ok:                                               ; preds = %entry
  %n.ld = load i32, i32* %var_8, align 4
  %start.ld = load i32, i32* %var_C, align 4
  %dist.ptr0 = getelementptr inbounds [164 x i32], [164 x i32]* %dist, i64 0, i64 0
  call void @dijkstra(i8* nonnull %graph.ptr0, i32 %n.ld, i32 %start.ld, i32* nonnull %dist.ptr0)
  %n.ld2 = load i32, i32* %var_8, align 4
  call void @print_distances(i32* nonnull %dist.ptr0, i32 %n.ld2)
  br label %exit

exit:                                             ; preds = %ok, %err
  %var_4.0 = phi i32 [ 0, %ok ], [ 1, %err ]
  ret i32 %var_4.0
}

; Function Attrs: nofree nounwind
declare noundef i64 @fwrite(i8* nocapture noundef, i64 noundef, i64 noundef, %struct._IO_FILE* nocapture noundef) #0

attributes #0 = { nofree nounwind }
attributes #1 = { cold }
