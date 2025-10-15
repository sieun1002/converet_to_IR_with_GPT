; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@off_140004390 = external global i32*, align 8
@unk_140004C00 = external global [0 x i8], align 8

declare void @sub_1400024B0(i8*, i32, i8*)

define void @TlsCallback_1(i8* %hModule, i32 %dwReason, i8* %pReserved) {
entry:
  %paddr = load i32*, i32** @off_140004390, align 8
  %cur = load i32, i32* %paddr, align 4
  %cmp2 = icmp eq i32 %cur, 2
  br i1 %cmp2, label %after_store, label %do_store

do_store:
  store i32 2, i32* %paddr, align 4
  br label %after_store

after_store:
  %is2 = icmp eq i32 %dwReason, 2
  br i1 %is2, label %case_2, label %check_1

check_1:
  %is1 = icmp eq i32 %dwReason, 1
  br i1 %is1, label %call_sub, label %ret_default

case_2:
  %start = getelementptr [0 x i8], [0 x i8]* @unk_140004C00, i64 0, i64 0
  %end = getelementptr [0 x i8], [0 x i8]* @unk_140004C00, i64 0, i64 0
  %eq = icmp eq i8* %start, %end
  br i1 %eq, label %ret_case2, label %loop

loop:
  %it = phi i8* [ %start, %case_2 ], [ %next, %loop_end ]
  %fp_ptr = bitcast i8* %it to void ()**
  %fp = load void ()*, void ()** %fp_ptr, align 8
  %isnull = icmp eq void ()* %fp, null
  br i1 %isnull, label %loop_end, label %do_call

do_call:
  call void %fp()
  br label %loop_end

loop_end:
  %next = getelementptr i8, i8* %it, i64 8
  %cont = icmp ne i8* %next, %end
  br i1 %cont, label %loop, label %ret_case2

ret_case2:
  ret void

call_sub:
  tail call void @sub_1400024B0(i8* %hModule, i32 %dwReason, i8* %pReserved)
  ret void

ret_default:
  ret void
}