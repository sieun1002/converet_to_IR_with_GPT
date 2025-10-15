; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32, align 4
@qword_1400070A8 = external global i8*, align 8
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00", align 1

declare i8* @sub_1400026F0(i8*)
declare i8* @sub_140002830()
declare void @sub_14002C875(i8*, i8*, i32)
declare void @sub_140001BA0(i8*, i8*)

define void @sub_140001C00(i8* %rcx) {
entry:
  %var48 = alloca [48 x i8], align 8
  %cnt32 = load i32, i32* @dword_1400070A4, align 4
  %gt0 = icmp sgt i32 %cnt32, 0
  br i1 %gt0, label %loop_prep, label %zero_case

loop_prep:                                        ; preds = %entry
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  %scan0 = getelementptr i8, i8* %base0, i64 24
  br label %loop

loop:                                             ; preds = %advance, %loop_prep
  %idx.phi = phi i32 [ 0, %loop_prep ], [ %idx.next, %advance ]
  %scan.phi = phi i8* [ %scan0, %loop_prep ], [ %scan.next, %advance ]
  %start.ptrptr = bitcast i8* %scan.phi to i8**
  %start.ptr = load i8*, i8** %start.ptrptr, align 8
  %param.int = ptrtoint i8* %rcx to i64
  %start.int = ptrtoint i8* %start.ptr to i64
  %cmp.lo = icmp ult i64 %param.int, %start.int
  br i1 %cmp.lo, label %advance, label %check_end

check_end:                                        ; preds = %loop
  %ptr8 = getelementptr i8, i8* %scan.phi, i64 8
  %ptr8.pp = bitcast i8* %ptr8 to i8**
  %len.base = load i8*, i8** %ptr8.pp, align 8
  %len.field.ptr.i8 = getelementptr i8, i8* %len.base, i64 8
  %len.field.ptr = bitcast i8* %len.field.ptr.i8 to i32*
  %len32 = load i32, i32* %len.field.ptr, align 4
  %len64 = zext i32 %len32 to i64
  %end.int = add i64 %start.int, %len64
  %in.range = icmp ult i64 %param.int, %end.int
  br i1 %in.range, label %found, label %advance

advance:                                          ; preds = %check_end, %loop
  %idx.next = add i32 %idx.phi, 1
  %scan.next = getelementptr i8, i8* %scan.phi, i64 40
  %cont = icmp ne i32 %idx.next, %cnt32
  br i1 %cont, label %loop, label %notfound_from_loop

found:                                            ; preds = %check_end
  ret void

notfound_from_loop:                               ; preds = %advance
  br label %notfound_call

zero_case:                                        ; preds = %entry
  br label %notfound_call

notfound_call:                                    ; preds = %zero_case, %notfound_from_loop
  %s.phi = phi i32 [ 0, %zero_case ], [ %cnt32, %notfound_from_loop ]
  %rdi = call i8* @sub_1400026F0(i8* %rcx)
  %isnull = icmp eq i8* %rdi, null
  br i1 %isnull, label %err, label %newentry

err:                                              ; preds = %notfound_call
  %str.ptr = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void @sub_140001BA0(i8* %str.ptr, i8* %rcx)
  ret void

newentry:                                         ; preds = %notfound_call
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %s64 = sext i32 %s.phi to i64
  %mul40 = mul i64 %s64, 40
  %entry.ptr = getelementptr i8, i8* %base1, i64 %mul40
  %off20 = getelementptr i8, i8* %entry.ptr, i64 32
  %off20.pp = bitcast i8* %off20 to i8**
  store i8* %rdi, i8** %off20.pp, align 8
  %entry.i32 = bitcast i8* %entry.ptr to i32*
  store i32 0, i32* %entry.i32, align 4
  %retbase = call i8* @sub_140002830()
  %rdi.off12.i8 = getelementptr i8, i8* %rdi, i64 12
  %rdi.off12 = bitcast i8* %rdi.off12.i8 to i32*
  %d.val = load i32, i32* %rdi.off12, align 4
  %d64 = zext i32 %d.val to i64
  %rcx.ptr = getelementptr i8, i8* %retbase, i64 %d64
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %entry2.ptr = getelementptr i8, i8* %base2, i64 %mul40
  %off18 = getelementptr i8, i8* %entry2.ptr, i64 24
  %off18.pp = bitcast i8* %off18 to i8**
  store i8* %rcx.ptr, i8** %off18.pp, align 8
  %buf.ptr = getelementptr inbounds [48 x i8], [48 x i8]* %var48, i64 0, i64 0
  call void @sub_14002C875(i8* %rcx.ptr, i8* %buf.ptr, i32 48)
  ret void
}