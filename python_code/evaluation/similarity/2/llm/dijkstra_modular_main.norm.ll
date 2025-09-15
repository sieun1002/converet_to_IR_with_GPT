; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/dijkstra_modular_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/dijkstra_modular_main.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type opaque

@stream = external global %struct._IO_FILE*
@.str = private unnamed_addr constant [21 x i8] c"Error reading graph\0A\00", align 1

declare i32 @read_graph(i8*, i32*, i32*)

declare void @dijkstra(i8*, i32, i32, i32*)

declare void @print_distances(i32*, i32)

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...)

define i32 @main() local_unnamed_addr {
entry:
  %graph1 = alloca [40016 x i8], align 16
  %dist = alloca [100 x i32], align 16
  %n = alloca i32, align 4
  %src = alloca i32, align 4
  %graph1.sub = getelementptr inbounds [40016 x i8], [40016 x i8]* %graph1, i64 0, i64 0
  %call = call i32 @read_graph(i8* nonnull %graph1.sub, i32* nonnull %n, i32* nonnull %src)
  %cmp = icmp eq i32 %call, 0
  br i1 %cmp, label %ok, label %fail

fail:                                             ; preds = %entry
  %streamptr = load %struct._IO_FILE*, %struct._IO_FILE** @stream, align 8
  %0 = call i64 @fwrite(i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str, i64 0, i64 0), i64 20, i64 1, %struct._IO_FILE* %streamptr)
  br label %end

ok:                                               ; preds = %entry
  %nval = load i32, i32* %n, align 4
  %srcval = load i32, i32* %src, align 4
  %dist0 = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 0
  call void @dijkstra(i8* nonnull %graph1.sub, i32 %nval, i32 %srcval, i32* nonnull %dist0)
  %nval2 = load i32, i32* %n, align 4
  call void @print_distances(i32* nonnull %dist0, i32 %nval2)
  br label %end

end:                                              ; preds = %ok, %fail
  %ret.0 = phi i32 [ 0, %ok ], [ 1, %fail ]
  ret i32 %ret.0
}

; Function Attrs: nofree nounwind
declare noundef i64 @fwrite(i8* nocapture noundef, i64 noundef, i64 noundef, %struct._IO_FILE* nocapture noundef) #0

attributes #0 = { nofree nounwind }
