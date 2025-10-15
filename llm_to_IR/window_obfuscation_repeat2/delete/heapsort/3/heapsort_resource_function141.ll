; ModuleID = 'recovered'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*
@unk_140004BE0 = external global i8

declare void @sub_1400023D0(i8*, i32, i8*)

define dso_local void @TlsCallback_0(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %p = load i32*, i32** @off_140004370, align 8
  %val = load i32, i32* %p, align 4
  %is2 = icmp eq i32 %val, 2
  br i1 %is2, label %afterSet, label %set

set:
  store i32 2, i32* %p, align 4
  br label %afterSet

afterSet:
  %cmpReason2 = icmp eq i32 %Reason, 2
  br i1 %cmpReason2, label %loc_1970, label %check1

check1:
  %cmpReason1 = icmp eq i32 %Reason, 1
  br i1 %cmpReason1, label %loc_19B0, label %retBlock

retBlock:
  ret void

loc_1970:
  %eq = icmp eq i8* @unk_140004BE0, @unk_140004BE0
  br i1 %eq, label %retBlock, label %loop

loop:
  %rbx_phi = phi i8* [ @unk_140004BE0, %loc_1970 ], [ %rbx_next, %next ]
  %entryp = bitcast i8* %rbx_phi to i8**
  %pfn = load i8*, i8** %entryp, align 8
  %isnull2 = icmp eq i8* %pfn, null
  br i1 %isnull2, label %next, label %call

call:
  %typed = bitcast i8* %pfn to void (i8*, i32, i8*)*
  call void %typed(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  br label %next

next:
  %rbx_next = getelementptr i8, i8* %rbx_phi, i64 8
  %cmpCont = icmp ne i8* %rbx_next, @unk_140004BE0
  br i1 %cmpCont, label %loop, label %ret_after_loop

ret_after_loop:
  ret void

loc_19B0:
  tail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void
}