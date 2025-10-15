; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_140004450 = internal global i8* null, align 8
@dword_140007004 = internal global i32 0, align 4
@dword_140007008 = internal global i32 0, align 4

define dso_local i32 @sub_140001010() local_unnamed_addr nounwind {
entry:
  br label %spin

spin:
  %i = phi i32 [ 0, %entry ], [ %i.next, %spin_body_done ]
  %cond = icmp ult i32 %i, 100000
  br i1 %cond, label %spin_try, label %locked_fallback

spin_try:
  %token = inttoptr i64 1 to i8*
  %pair = cmpxchg i8** @off_140004450, i8* null, i8* %token seq_cst seq_cst
  %got = extractvalue { i8*, i1 } %pair, 1
  br i1 %got, label %locked, label %spin_body_done

spin_body_done:
  %i.next = add i32 %i, 1
  br label %spin

locked_fallback:
  br label %locked

locked:
  store i32 1, i32* @dword_140007004, align 4
  store i32 0, i32* @dword_140007008, align 4
  %oldx = atomicrmw xchg i8** @off_140004450, i8* null seq_cst
  ret i32 0
}