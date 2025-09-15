; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/dijkstra_modular_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/dijkstra_modular_main.ll"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type opaque

@stream = external global %struct._IO_FILE*
@.str = private unnamed_addr constant [29 x i8] c"Error: failed to read graph\0A\00", align 1

declare i32 @read_graph(i8* noundef, i32* noundef, i32* noundef)

declare void @dijkstra(i8* noundef, i32 noundef, i32 noundef, i8* noundef)

declare void @print_distances(i8* noundef, i32 noundef)

declare i32 @fprintf(%struct._IO_FILE* noundef, i8* noundef, ...)

define i32 @main() {
entry:
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %frame = alloca [40416 x i8], align 16
  %dist_ptr = getelementptr inbounds [40416 x i8], [40416 x i8]* %frame, i64 0, i64 0
  %graph_ptr = getelementptr inbounds [40416 x i8], [40416 x i8]* %frame, i64 0, i64 400
  %rg = call i32 @read_graph(i8* noundef nonnull %graph_ptr, i32* noundef nonnull %n, i32* noundef nonnull %m)
  %okcmp = icmp eq i32 %rg, 0
  br i1 %okcmp, label %loc_401724, label %err

err:                                              ; preds = %entry
  %stream_ld = load %struct._IO_FILE*, %struct._IO_FILE** @stream, align 8
  %0 = call i64 @fwrite(i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str, i64 0, i64 0), i64 28, i64 1, %struct._IO_FILE* %stream_ld)
  br label %loc_401753

loc_401724:                                       ; preds = %entry
  %n_ld = load i32, i32* %n, align 4
  %m_ld = load i32, i32* %m, align 4
  call void @dijkstra(i8* noundef nonnull %graph_ptr, i32 noundef %n_ld, i32 noundef %m_ld, i8* noundef nonnull %dist_ptr)
  %n_ld2 = load i32, i32* %n, align 4
  call void @print_distances(i8* noundef nonnull %dist_ptr, i32 noundef %n_ld2)
  br label %loc_401753

loc_401753:                                       ; preds = %loc_401724, %err
  %ret.0 = phi i32 [ 0, %loc_401724 ], [ 1, %err ]
  ret i32 %ret.0
}

; Function Attrs: nofree nounwind
declare noundef i64 @fwrite(i8* nocapture noundef, i64 noundef, i64 noundef, %struct._IO_FILE* nocapture noundef) #0

attributes #0 = { nofree nounwind }
