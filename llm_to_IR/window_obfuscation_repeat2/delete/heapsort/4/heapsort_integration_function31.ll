; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = global i32* null
@unk_140004BE0 = global [0 x i8*] zeroinitializer

declare void @sub_1400023D0()

define void @TlsCallback_1(i8* %arg0, i32 %arg1, i8* %arg2) {
entry:
  %p = load i32*, i32** @off_140004370, align 8
  %val = load i32, i32* %p, align 4
  %is2 = icmp eq i32 %val, 2
  br i1 %is2, label %after_set, label %do_set

do_set:                                           ; preds = %entry
  store i32 2, i32* %p, align 4
  br label %after_set

after_set:                                        ; preds = %do_set, %entry
  %is_attach = icmp eq i32 %arg1, 2
  br i1 %is_attach, label %do_list, label %check_detach

check_detach:                                     ; preds = %after_set
  %is_detach = icmp eq i32 %arg1, 1
  br i1 %is_detach, label %jmp, label %ret

ret:                                              ; preds = %check_detach
  ret void

do_list:                                          ; preds = %after_set
  %begin = getelementptr inbounds [0 x i8*], [0 x i8*]* @unk_140004BE0, i64 0, i64 0
  %end = getelementptr inbounds [0 x i8*], [0 x i8*]* @unk_140004BE0, i64 0, i64 0
  %cmpbe = icmp eq i8** %begin, %end
  br i1 %cmpbe, label %ret2, label %loop

ret2:                                             ; preds = %do_list
  ret void

loop:                                             ; preds = %aftercall, %do_list
  %it = phi i8** [ %begin, %do_list ], [ %next, %aftercall ]
  %fptr = load i8*, i8** %it, align 8
  %isnull = icmp eq i8* %fptr, null
  br i1 %isnull, label %aftercall, label %docall

docall:                                           ; preds = %loop
  %callee = bitcast i8* %fptr to void ()*
  call void %callee()
  br label %aftercall

aftercall:                                        ; preds = %docall, %loop
  %next = getelementptr inbounds i8*, i8** %it, i64 1
  %done = icmp eq i8** %next, %end
  br i1 %done, label %ret3, label %loop

ret3:                                             ; preds = %aftercall
  ret void

jmp:                                              ; preds = %check_detach
  tail call void @sub_1400023D0()
  ret void
}