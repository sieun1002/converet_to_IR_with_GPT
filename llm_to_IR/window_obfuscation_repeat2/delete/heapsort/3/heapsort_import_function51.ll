; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*
@unk_140004BE0 = external global [0 x i8]

declare void @sub_1400023D0()

define void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %offptr1 = load i32*, i32** @off_140004370, align 8
  %val2 = load i32, i32* %offptr1, align 4
  %cmp3 = icmp eq i32 %val2, 2
  br i1 %cmp3, label %after_set, label %do_set

do_set:                                            ; preds = %entry
  store i32 2, i32* %offptr1, align 4
  br label %after_set

after_set:                                         ; preds = %do_set, %entry
  %is2 = icmp eq i32 %Reason, 2
  br i1 %is2, label %case2, label %check1

check1:                                            ; preds = %after_set
  %is1 = icmp eq i32 %Reason, 1
  br i1 %is1, label %case1, label %ret

case2:                                             ; preds = %after_set
  %base = bitcast [0 x i8]* @unk_140004BE0 to i8*
  %end = bitcast [0 x i8]* @unk_140004BE0 to i8*
  %cmp_empty = icmp eq i8* %base, %end
  br i1 %cmp_empty, label %ret, label %loop

loop:                                              ; preds = %skipcall, %case2
  %rbx_phi = phi i8* [ %base, %case2 ], [ %rbx_next, %skipcall ]
  %ptrptr = bitcast i8* %rbx_phi to i8**
  %fp_i8 = load i8*, i8** %ptrptr, align 8
  %isnull = icmp eq i8* %fp_i8, null
  br i1 %isnull, label %skipcall, label %docall

docall:                                            ; preds = %loop
  %fp = bitcast i8* %fp_i8 to void ()*
  call void %fp()
  br label %skipcall

skipcall:                                          ; preds = %docall, %loop
  %rbx_next = getelementptr i8, i8* %rbx_phi, i64 8
  %cmpdone = icmp eq i8* %rbx_next, %end
  br i1 %cmpdone, label %ret, label %loop

case1:                                             ; preds = %check1
  tail call void @sub_1400023D0()
  ret void

ret:                                               ; preds = %skipcall, %case2, %check1
  ret void
}