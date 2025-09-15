; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/dijkstra_modular_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/dijkstra_modular_main.ll"
target triple = "x86_64-pc-linux-gnu"

@__bss_start = external global i8*
@byte_40202C = external global i8

declare i32 @read_graph(i8*, i32*, i32*)

declare void @dijkstra(i8*, i32, i32, i8*)

declare void @print_distances(i8*, i32)

declare i32 @fprintf(i8*, i8*, ...)

define i32 @main() {
entry:
  %var8 = alloca i32, align 4
  %varC = alloca i32, align 4
  %graph = alloca [40016 x i8], align 16
  %dist = alloca [40352 x i8], align 16
  %graphptr = getelementptr inbounds [40016 x i8], [40016 x i8]* %graph, i64 0, i64 0
  %distptr = getelementptr inbounds [40352 x i8], [40352 x i8]* %dist, i64 0, i64 0
  %call_read = call i32 @read_graph(i8* nonnull %graphptr, i32* nonnull %var8, i32* nonnull %varC)
  %cmp_ok = icmp eq i32 %call_read, 0
  br i1 %cmp_ok, label %bb_ok, label %bb_err

bb_err:                                           ; preds = %entry
  %stream_ptr = load i8*, i8** @__bss_start, align 8
  %call_fprintf = call i32 (i8*, i8*, ...) @fprintf(i8* %stream_ptr, i8* nonnull @byte_40202C)
  br label %bb_end

bb_ok:                                            ; preds = %entry
  %n_val = load i32, i32* %var8, align 4
  %src_val = load i32, i32* %varC, align 4
  call void @dijkstra(i8* nonnull %graphptr, i32 %n_val, i32 %src_val, i8* nonnull %distptr)
  %n_val2 = load i32, i32* %var8, align 4
  call void @print_distances(i8* nonnull %distptr, i32 %n_val2)
  br label %bb_end

bb_end:                                           ; preds = %bb_ok, %bb_err
  %var4.0 = phi i32 [ 0, %bb_ok ], [ 1, %bb_err ]
  ret i32 %var4.0
}
