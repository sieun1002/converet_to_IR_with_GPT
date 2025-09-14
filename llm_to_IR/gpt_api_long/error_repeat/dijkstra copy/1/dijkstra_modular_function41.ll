; ModuleID = 'min_index'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: min_index  ; Address: 0x4013C0
; Intent: Return index of the minimum signed 32-bit value in values where flags[i] == 0; -1 if none (confidence=0.95). Evidence: sentinel 0x7FFFFFFF; checks flags[i]==0 and value < currentMin in loop.
; Preconditions: values and flags point to at least n i32 elements; n >= 0.
; Postconditions: Returns -1 if no flags[i]==0; otherwise index of smallest signed value among eligible elements.

; Only the needed extern declarations:

define dso_local i32 @min_index(i32* %values, i32* %flags, i32 %n) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %min = phi i32 [ 2147483647, %entry ], [ %min.next, %inc ]
  %minidx = phi i32 [ -1, %entry ], [ %minidx.next, %inc ]
  %condend = icmp sge i32 %i, %n
  br i1 %condend, label %exit, label %body

body:
  %idxprom = sext i32 %i to i64
  %fptr = getelementptr inbounds i32, i32* %flags, i64 %idxprom
  %fval = load i32, i32* %fptr, align 4
  %iszero = icmp eq i32 %fval, 0
  br i1 %iszero, label %consider_value, label %inc

consider_value:
  %vptr = getelementptr inbounds i32, i32* %values, i64 %idxprom
  %v = load i32, i32* %vptr, align 4
  %lt = icmp slt i32 %v, %min
  br i1 %lt, label %update, label %inc

update:
  br label %inc

inc:
  %min.next = phi i32 [ %min, %body ], [ %min, %consider_value ], [ %v, %update ]
  %minidx.next = phi i32 [ %minidx, %body ], [ %minidx, %consider_value ], [ %i, %update ]
  %i.next = add i32 %i, 1
  br label %loop

exit:
  ret i32 %minidx
}