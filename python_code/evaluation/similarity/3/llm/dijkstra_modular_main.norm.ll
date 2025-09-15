; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/dijkstra_modular_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/dijkstra_modular_main.ll"
target triple = "x86_64-pc-linux-gnu"

@stream = external global i8*, align 8
@byte_40202C = external global [0 x i8], align 1

declare i32 @read_graph(i8*, i32*, i32*)

declare void @dijkstra(i8*, i32, i32, i8*)

declare void @print_distances(i8*, i32)

declare i32 @fprintf(i8*, i8*, ...)

define i32 @main() {
entry:
  %var_8 = alloca i32, align 4
  %var_C = alloca i32, align 4
  %buf_graph = alloca i8, align 16
  %buf_dist = alloca i8, align 16
  %call_read = call i32 @read_graph(i8* nonnull %buf_graph, i32* nonnull %var_8, i32* nonnull %var_C)
  %cmp_zero = icmp eq i32 %call_read, 0
  br i1 %cmp_zero, label %loc_401724, label %loc_err

loc_err:                                          ; preds = %entry
  %stream_val = load i8*, i8** @stream, align 8
  %call_fprintf = call i32 (i8*, i8*, ...) @fprintf(i8* %stream_val, i8* getelementptr inbounds ([0 x i8], [0 x i8]* @byte_40202C, i64 0, i64 0))
  br label %loc_401753

loc_401724:                                       ; preds = %entry
  %n_val = load i32, i32* %var_8, align 4
  %m_val = load i32, i32* %var_C, align 4
  call void @dijkstra(i8* nonnull %buf_graph, i32 %n_val, i32 %m_val, i8* nonnull %buf_dist)
  %n_val2 = load i32, i32* %var_8, align 4
  call void @print_distances(i8* nonnull %buf_dist, i32 %n_val2)
  br label %loc_401753

loc_401753:                                       ; preds = %loc_401724, %loc_err
  %var_4.0 = phi i32 [ 0, %loc_401724 ], [ 1, %loc_err ]
  ret i32 %var_4.0
}
