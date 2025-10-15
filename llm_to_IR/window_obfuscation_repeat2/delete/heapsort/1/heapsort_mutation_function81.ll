; ModuleID: 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004390 = external dso_local global i64*

declare dso_local i32 @j__crt_atexit(void ()*)
declare dso_local void @sub_140001820()

define dso_local i32 @sub_140001870() local_unnamed_addr {
entry:
  %rdx_base_ptr = load i64*, i64** @off_140004390, align 8
  %firstq = load i64, i64* %rdx_base_ptr, align 8
  %eax32 = trunc i64 %firstq to i32
  %isneg1 = icmp eq i32 %eax32, -1
  br i1 %isneg1, label %scanInit, label %haveCount

haveCount:                                           ; preds = %entry
  br label %testCalls

scanInit:                                            ; preds = %entry
  br label %scanLoop

scanLoop:                                            ; preds = %scanInit, %scanLoopCont
  %rax_phi = phi i64 [ 0, %scanInit ], [ %r8_back, %scanLoopCont ]
  %r8 = add i64 %rax_phi, 1
  %ecx_temp = trunc i64 %rax_phi to i32
  %eltptr_scan = getelementptr inbounds i64, i64* %rdx_base_ptr, i64 %r8
  %val_scan = load i64, i64* %eltptr_scan, align 8
  %cond_scan = icmp ne i64 %val_scan, 0
  br i1 %cond_scan, label %scanLoopCont, label %scanEnd

scanLoopCont:                                        ; preds = %scanLoop
  %r8_back = add i64 %rax_phi, 1
  br label %scanLoop

scanEnd:                                             ; preds = %scanLoop
  br label %testCalls

testCalls:                                           ; preds = %haveCount, %scanEnd
  %ecx_final = phi i32 [ %eax32, %haveCount ], [ %ecx_temp, %scanEnd ]
  %isZero = icmp eq i32 %ecx_final, 0
  br i1 %isZero, label %tail, label %loopPrep

loopPrep:                                            ; preds = %testCalls
  %i_init64 = zext i32 %ecx_final to i64
  br label %callLoop

callLoop:                                            ; preds = %loopPrep, %callLoop
  %i_phi = phi i64 [ %i_init64, %loopPrep ], [ %i_next, %callLoop ]
  %eltptr = getelementptr inbounds i64, i64* %rdx_base_ptr, i64 %i_phi
  %f64 = load i64, i64* %eltptr, align 8
  %fptr = inttoptr i64 %f64 to void ()*
  call void %fptr()
  %i_next = add i64 %i_phi, -1
  %more = icmp ne i64 %i_next, 0
  br i1 %more, label %callLoop, label %tail

tail:                                                ; preds = %callLoop, %testCalls
  %ret = call i32 @j__crt_atexit(void ()* @sub_140001820)
  ret i32 %ret
}