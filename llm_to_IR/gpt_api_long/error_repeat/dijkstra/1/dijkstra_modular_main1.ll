; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x4016D0
; Intent: Read graph, run Dijkstra, print distances; return 0 on error, 1 on failure (confidence=0.95). Evidence: Calls to dijkstra/print_distances; fprintf on error.
; Preconditions: External functions write within provided buffers (graph ~40016 bytes, distances ~400 bytes).
; Postconditions: Prints distances; returns 0 on success, 1 on error.

@__bss_start = external global i8*
@byte_40202C = private unnamed_addr constant [13 x i8] c"read error!\0A\00", align 1

; Only the needed extern declarations:
declare i32 @read_graph(i8*, i32*, i32*)
declare void @dijkstra(i8*, i32, i32, i8*)
declare void @print_distances(i8*, i32)
declare i32 @fprintf(i8*, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %graphbuf = alloca [40016 x i8], align 16
  %distbuf = alloca [400 x i8], align 16
  %n = alloca i32, align 4
  %src = alloca i32, align 4
  %graphptr = getelementptr inbounds [40016 x i8], [40016 x i8]* %graphbuf, i64 0, i64 0
  %distptr = getelementptr inbounds [400 x i8], [400 x i8]* %distbuf, i64 0, i64 0
  %rg = call i32 @read_graph(i8* %graphptr, i32* %n, i32* %src)
  %ok = icmp eq i32 %rg, 0
  br i1 %ok, label %bb_success, label %bb_error

bb_error:
  %stream = load i8*, i8** @__bss_start, align 8
  %fmt = bitcast [13 x i8]* @byte_40202C to i8*
  %retfprintf = call i32 (i8*, i8*, ...) @fprintf(i8* %stream, i8* %fmt)
  br label %bb_ret

bb_success:
  %n_val = load i32, i32* %n, align 4
  %src_val = load i32, i32* %src, align 4
  call void @dijkstra(i8* %graphptr, i32 %n_val, i32 %src_val, i8* %distptr)
  call void @print_distances(i8* %distptr, i32 %n_val)
  br label %bb_ret

bb_ret:
  %retv = phi i32 [ 1, %bb_error ], [ 0, %bb_success ]
  ret i32 %retv
}