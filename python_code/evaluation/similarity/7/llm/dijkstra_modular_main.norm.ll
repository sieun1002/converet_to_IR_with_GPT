; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/dijkstra_modular_main.ll'
source_filename = "main_from_asm.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@stderr = external global i8*, align 8
@.str = private unnamed_addr constant [19 x i8] c"read_graph failed\0A\00", align 1

declare i32 @read_graph(i8*, i32*, i32*)

declare void @dijkstra(i8*, i32, i32, i32*)

declare void @print_distances(i32*, i32)

declare i32 @fprintf(i8*, i8*, ...)

define i32 @main() {
entry:
  %n = alloca i32, align 4
  %src = alloca i32, align 4
  %graph = alloca [40000 x i8], align 16
  %dist = alloca [10104 x i32], align 16
  %graph_ptr0 = getelementptr inbounds [40000 x i8], [40000 x i8]* %graph, i64 0, i64 0
  %call_rg = call i32 @read_graph(i8* nonnull %graph_ptr0, i32* nonnull %n, i32* nonnull %src)
  %cmp = icmp eq i32 %call_rg, 0
  br i1 %cmp, label %loc_401724, label %loc_4016FF

loc_4016FF:                                       ; preds = %entry
  %stderrp = load i8*, i8** @stderr, align 8
  %0 = call i64 @fwrite(i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str, i64 0, i64 0), i64 18, i64 1, i8* %stderrp) #1
  br label %loc_401753

loc_401724:                                       ; preds = %entry
  %nval = load i32, i32* %n, align 4
  %srcval = load i32, i32* %src, align 4
  %dist_ptr = getelementptr inbounds [10104 x i32], [10104 x i32]* %dist, i64 0, i64 0
  call void @dijkstra(i8* nonnull %graph_ptr0, i32 %nval, i32 %srcval, i32* nonnull %dist_ptr)
  %nval2 = load i32, i32* %n, align 4
  call void @print_distances(i32* nonnull %dist_ptr, i32 %nval2)
  br label %loc_401753

loc_401753:                                       ; preds = %loc_401724, %loc_4016FF
  %var4.0 = phi i32 [ 0, %loc_401724 ], [ 1, %loc_4016FF ]
  ret i32 %var4.0
}

; Function Attrs: nofree nounwind
declare noundef i64 @fwrite(i8* nocapture noundef, i64 noundef, i64 noundef, i8* nocapture noundef) #0

attributes #0 = { nofree nounwind }
attributes #1 = { cold }
