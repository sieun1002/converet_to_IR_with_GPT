; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004390 = external global i64*

declare i32 @j__crt_atexit(void ()*)

define void @sub_140001820() {
entry:
  ret void
}

define i32 @sub_140001870() {
entry:
  %base = load i64*, i64** @off_140004390, align 8
  %firstq = load i64, i64* %base, align 8
  %first32 = trunc i64 %firstq to i32
  %issentinel = icmp eq i32 %first32, -1
  br i1 %issentinel, label %scan.loop, label %decide_entry

decide_entry:
  br label %decide

scan.loop:
  %idx = phi i64 [ 1, %entry ], [ %idx.next, %scan.cont ]
  %eltptr = getelementptr inbounds i64, i64* %base, i64 %idx
  %elt = load i64, i64* %eltptr, align 8
  %nonzero = icmp ne i64 %elt, 0
  br i1 %nonzero, label %scan.cont, label %scan.exit

scan.cont:
  %idx.next = add i64 %idx, 1
  br label %scan.loop

scan.exit:
  %counti64 = sub i64 %idx, 1
  %count32 = trunc i64 %counti64 to i32
  br label %decide

decide:
  %count = phi i32 [ %first32, %decide_entry ], [ %count32, %scan.exit ]
  %isZero = icmp eq i32 %count, 0
  br i1 %isZero, label %register, label %callloop.prep

callloop.prep:
  %count64 = sext i32 %count to i64
  %start = getelementptr inbounds i64, i64* %base, i64 %count64
  br label %callloop

callloop:
  %curr = phi i64* [ %start, %callloop.prep ], [ %curr.next, %callloop ]
  %val = load i64, i64* %curr, align 8
  %fn = inttoptr i64 %val to void ()*
  call void %fn()
  %curr.next = getelementptr inbounds i64, i64* %curr, i64 -1
  %cond = icmp ne i64* %curr.next, %base
  br i1 %cond, label %callloop, label %aftercalls

aftercalls:
  br label %register

register:
  %res = tail call i32 @j__crt_atexit(void ()* @sub_140001820)
  ret i32 %res
}