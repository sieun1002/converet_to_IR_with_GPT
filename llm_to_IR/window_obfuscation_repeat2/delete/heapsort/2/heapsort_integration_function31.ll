; ModuleID: 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*
@unk_140004BE0 = external global void ()*

declare void @sub_1400023D0()

define void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %p_ptr = load i32*, i32** @off_140004370, align 8
  %p_loaded = load i32, i32* %p_ptr, align 4
  %cmp = icmp eq i32 %p_loaded, 2
  br i1 %cmp, label %after_set, label %set2

set2:                                             ; preds = %entry
  store i32 2, i32* %p_ptr, align 4
  br label %after_set

after_set:                                        ; preds = %set2, %entry
  switch i32 %Reason, label %retDefault [
    i32 2, label %case2
    i32 1, label %case1
  ]

retDefault:                                       ; preds = %after_set
  ret void

case2:                                            ; preds = %after_set
  %start = bitcast void ()** @unk_140004BE0 to i8*
  %end = bitcast void ()** @unk_140004BE0 to i8*
  %cmpse = icmp eq i8* %start, %end
  br i1 %cmpse, label %retDefault2, label %loop

loop:                                             ; preds = %cont, %case2
  %cur = phi i8* [ %start, %case2 ], [ %next, %cont ]
  %curptr = bitcast i8* %cur to void ()**
  %fn = load void ()*, void ()** %curptr, align 8
  %isnull = icmp eq void ()* %fn, null
  br i1 %isnull, label %cont, label %docall

docall:                                           ; preds = %loop
  call void %fn()
  br label %cont

cont:                                             ; preds = %docall, %loop
  %next = getelementptr i8, i8* %cur, i64 8
  %done = icmp eq i8* %next, %end
  br i1 %done, label %retDefault2, label %loop

retDefault2:                                      ; preds = %cont, %case2
  ret void

case1:                                            ; preds = %after_set
  tail call void @sub_1400023D0()
  ret void
}