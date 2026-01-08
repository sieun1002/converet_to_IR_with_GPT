; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

%struct.S = type { i32, i8*, i8* }

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global %struct.S*
@qword_140008258 = external global void (i8*)*
@qword_140008270 = external global void (i8*)*
@unk_140007100 = external global i8

declare i8* @sub_1400027E8(i32, i32)

define i32 @sub_140001EF0(i32 %0, i8* %1) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %nz = icmp ne i32 %g, 0
  br i1 %nz, label %if.then, label %ret0

ret0:                                             ; preds = %entry
  ret i32 0

if.then:                                          ; preds = %entry
  %mem = call i8* @sub_1400027E8(i32 1, i32 24)
  %null = icmp eq i8* %mem, null
  br i1 %null, label %retm1, label %gotmem

retm1:                                            ; preds = %if.then
  ret i32 -1

gotmem:                                           ; preds = %if.then
  %p = bitcast i8* %mem to %struct.S*
  %f0ptr = getelementptr inbounds %struct.S, %struct.S* %p, i64 0, i32 0
  store i32 %0, i32* %f0ptr, align 4
  %f1ptr = getelementptr inbounds %struct.S, %struct.S* %p, i64 0, i32 1
  store i8* %1, i8** %f1ptr, align 8
  %fp1 = load void (i8*)*, void (i8*)** @qword_140008258, align 8
  call void %fp1(i8* @unk_140007100)
  %head = load %struct.S*, %struct.S** @qword_1400070E0, align 8
  %f2ptr = getelementptr inbounds %struct.S, %struct.S* %p, i64 0, i32 2
  store %struct.S* %head, %struct.S** %f2ptr, align 8
  store %struct.S* %p, %struct.S** @qword_1400070E0, align 8
  %fp2 = load void (i8*)*, void (i8*)** @qword_140008270, align 8
  call void %fp2(i8* @unk_140007100)
  ret i32 0
}