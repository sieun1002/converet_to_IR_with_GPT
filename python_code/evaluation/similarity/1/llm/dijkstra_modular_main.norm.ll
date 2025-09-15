; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/dijkstra_modular_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/dijkstra_modular_main.ll"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type { i8 }

@stderr = external global %struct._IO_FILE*
@.str = private unnamed_addr constant [13 x i8] c"input error\0A\00", align 1

declare i32 @read_graph(i8* nocapture, i32* nocapture, i32* nocapture)

declare void @dijkstra(i8* nocapture, i32, i32, i32* nocapture)

declare void @print_distances(i32* nocapture, i32)

declare i32 @fprintf(%struct._IO_FILE* nocapture, i8* nocapture, ...)

define i32 @main() {
entry:
  %n = alloca i32, align 4
  %src = alloca i32, align 4
  %graph = alloca [40016 x i8], align 16
  %dist = alloca [164 x i32], align 16
  %graph.ptr = getelementptr inbounds [40016 x i8], [40016 x i8]* %graph, i64 0, i64 0
  %rg = call i32 @read_graph(i8* nonnull %graph.ptr, i32* nonnull %n, i32* nonnull %src)
  %ok = icmp eq i32 %rg, 0
  br i1 %ok, label %L_ok, label %L_err

L_err:                                            ; preds = %entry
  %stderr.val = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %0 = call i64 @fwrite(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i64 0, i64 0), i64 12, i64 1, %struct._IO_FILE* %stderr.val) #1
  br label %L_end

L_ok:                                             ; preds = %entry
  %n.val = load i32, i32* %n, align 4
  %src.val = load i32, i32* %src, align 4
  %dist.ptr = getelementptr inbounds [164 x i32], [164 x i32]* %dist, i64 0, i64 0
  call void @dijkstra(i8* nonnull %graph.ptr, i32 %n.val, i32 %src.val, i32* nonnull %dist.ptr)
  call void @print_distances(i32* nonnull %dist.ptr, i32 %n.val)
  br label %L_end

L_end:                                            ; preds = %L_ok, %L_err
  %ret.0 = phi i32 [ 0, %L_ok ], [ 1, %L_err ]
  ret i32 %ret.0
}

; Function Attrs: nofree nounwind
declare noundef i64 @fwrite(i8* nocapture noundef, i64 noundef, i64 noundef, %struct._IO_FILE* nocapture noundef) #0

attributes #0 = { nofree nounwind }
attributes #1 = { cold }
