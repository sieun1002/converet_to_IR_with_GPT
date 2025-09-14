; ModuleID = 'main_from_disasm.ll'
; target triple can be set if needed, e.g. "x86_64-unknown-linux-gnu"

; External declarations inferred from call sites
declare i32 @read_graph(i8* noundef, i32* noundef, i32* noundef)
declare void @dijkstra(i8* noundef, i32 noundef, i32 noundef, i8* noundef)
declare void @print_distances(i8* noundef, i32 noundef)
declare i32 @fprintf(i8* noundef, i8* noundef, ...)

; These globals correspond to what the disassembly loads for fprintf(stream, format, ...)
; stream: loaded from ds:__bss_start (treated here as a pointer-to-pointer to a FILE-like object)
@__bss_start = external global i8*, align 8
; format string at 0x40202C (content unknown here)
@byte_40202C = external global [1 x i8], align 1

define i32 @main() {
entry:
  ; locals
  %ret = alloca i32, align 4              ; var_4
  %n   = alloca i32, align 4              ; var_8
  %src = alloca i32, align 4              ; var_C

  ; stack buffers based on frame layout
  %graph.buf = alloca [40016 x i8], align 16   ; var_9C50
  %dist.buf  = alloca [400 x i8], align 16     ; var_9DE0

  ; ret = 0
  store i32 0, i32* %ret, align 4

  ; call read_graph(&graph, &n, &src)
  %graph.ptr = getelementptr inbounds [40016 x i8], [40016 x i8]* %graph.buf, i64 0, i64 0
  %call.read = call i32 @read_graph(i8* noundef %graph.ptr, i32* noundef %n, i32* noundef %src)
  %ok = icmp eq i32 %call.read, 0
  br i1 %ok, label %on_ok, label %on_err

on_err:                                           ; eax != 0
  ; rdi = ds:__bss_start (stream)
  %stream = load i8*, i8** @__bss_start, align 8
  ; rsi = &byte_40202C (format)
  %fmt = getelementptr inbounds [1 x i8], [1 x i8]* @byte_40202C, i64 0, i64 0
  ; call fprintf(stream, format)
  %call.fprintf = call i32 (i8*, i8*, ...) @fprintf(i8* noundef %stream, i8* noundef %fmt)
  ; ret = 1
  store i32 1, i32* %ret, align 4
  br label %exit

on_ok:                                            ; eax == 0
  ; dijkstra(&graph, n, src, &dist)
  %n.val   = load i32, i32* %n, align 4
  %src.val = load i32, i32* %src, align 4
  %dist.ptr = getelementptr inbounds [400 x i8], [400 x i8]* %dist.buf, i64 0, i64 0
  call void @dijkstra(i8* noundef %graph.ptr, i32 noundef %n.val, i32 noundef %src.val, i8* noundef %dist.ptr)

  ; print_distances(&dist, n)
  call void @print_distances(i8* noundef %dist.ptr, i32 noundef %n.val)

  ; ret = 0
  store i32 0, i32* %ret, align 4
  br label %exit

exit:
  %rv = load i32, i32* %ret, align 4
  ret i32 %rv
}