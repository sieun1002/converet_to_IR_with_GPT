; ModuleID = 'fixed'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_140004390 = external global i32*
@unk_140004C00 = external global i8

declare void @sub_1400024B0(i8*, i32, i8*)

define void @TlsCallback_0(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %p_addr = load i32*, i32** @off_140004390
  %val = load i32, i32* %p_addr
  %cmp = icmp eq i32 %val, 2
  br i1 %cmp, label %after_store, label %do_store

do_store:
  store i32 2, i32* %p_addr
  br label %after_store

after_store:
  %is_thread_attach = icmp eq i32 %Reason, 2
  br i1 %is_thread_attach, label %case_thread_attach, label %check_process_attach

check_process_attach:
  %is_process_attach = icmp eq i32 %Reason, 1
  br i1 %is_process_attach, label %tailcall, label %ret

case_thread_attach:
  %start = getelementptr i8, i8* @unk_140004C00, i64 0
  %end = getelementptr i8, i8* @unk_140004C00, i64 0
  %range_empty = icmp eq i8* %start, %end
  br i1 %range_empty, label %ret, label %loop

loop:
  %cur = phi i8* [ %start, %case_thread_attach ], [ %next, %after_iter ]
  %pfnptr = bitcast i8* %cur to i8**
  %pfn = load i8*, i8** %pfnptr
  %has_pfn = icmp ne i8* %pfn, null
  br i1 %has_pfn, label %call_block, label %skip

call_block:
  %fn = bitcast i8* %pfn to void ()*
  call void %fn()
  br label %skip

skip:
  %next = getelementptr i8, i8* %cur, i64 8
  %cont = icmp ne i8* %next, %end
  br i1 %cont, label %after_iter, label %ret

after_iter:
  br label %loop

tailcall:
  musttail call void @sub_1400024B0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}