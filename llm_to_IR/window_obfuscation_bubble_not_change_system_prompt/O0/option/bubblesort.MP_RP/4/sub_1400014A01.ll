; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external global i64*

declare void @sub_140001420(void ()*)
declare void @sub_140001450()

define void @sub_1400014A0() local_unnamed_addr {
entry:
  %base_ptr_addr = load i64*, i64** @off_1400043B0, align 8
  %first_qword = load i64, i64* %base_ptr_addr, align 8
  %first32 = trunc i64 %first_qword to i32
  %is_minus1 = icmp eq i32 %first32, -1
  br i1 %is_minus1, label %scan.preheader, label %testcount

scan.preheader:
  br label %scan.loop

scan.loop:
  %idx = phi i64 [ 1, %scan.preheader ], [ %idx.next, %scan.body ]
  %last_nonzero = phi i32 [ 0, %scan.preheader ], [ %idx.trunc, %scan.body ]
  %slotptr = getelementptr inbounds i64, i64* %base_ptr_addr, i64 %idx
  %slot = load i64, i64* %slotptr, align 8
  %nz = icmp ne i64 %slot, 0
  br i1 %nz, label %scan.body, label %testcount

scan.body:
  %idx.trunc = trunc i64 %idx to i32
  %idx.next = add i64 %idx, 1
  br label %scan.loop

testcount:
  %ecx = phi i32 [ %first32, %entry ], [ %last_nonzero, %scan.loop ]
  %is_zero = icmp eq i32 %ecx, 0
  br i1 %is_zero, label %tail, label %loop.prelude

loop.prelude:
  %count64 = zext i32 %ecx to i64
  %start = getelementptr inbounds i64, i64* %base_ptr_addr, i64 %count64
  br label %call.loop

call.loop:
  %cur = phi i64* [ %start, %loop.prelude ], [ %prev, %call.iter ]
  %fp64 = load i64, i64* %cur, align 8
  %fptr = inttoptr i64 %fp64 to void ()*
  call void %fptr()
  %prev = getelementptr inbounds i64, i64* %cur, i64 -1
  %cont = icmp ne i64* %prev, %base_ptr_addr
  br i1 %cont, label %call.iter, label %tail

call.iter:
  br label %call.loop

tail:
  tail call void @sub_140001420(void ()* @sub_140001450)
  ret void
}