; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1080
; Intent: Insertion-sort 10 integers on the stack and print them using __printf_chk (confidence=0.95). Evidence: insertion-sort inner shift loop; prints each element with "%d ".
; Preconditions: none
; Postconditions: returns 0 after printing the sorted sequence

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Only the needed extern declarations:
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  ; stack canary (conservative emulation)
  %canary = alloca i64, align 8
  store i64 0, i64* %canary, align 8

  %arr = alloca [10 x i32], align 16
  ; initialize the array: [9,1,5,3,7,2,8,6,4,0]
  %arr.cast = bitcast [10 x i32]* %arr to [10 x i32]*
  store [10 x i32] [i32 9, i32 1, i32 5, i32 3, i32 7, i32 2, i32 8, i32 6, i32 4, i32 0], [10 x i32]* %arr.cast, align 16

  br label %outer.header

outer.header:                                     ; preds = %outer.latch, %entry
  %i = phi i32 [ 1, %entry ], [ %i.next, %outer.latch ]
  ; key = arr[i]
  %i.i64 = sext i32 %i to i64
  %key.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.i64
  %key = load i32, i32* %key.ptr, align 4
  br label %inner.check

inner.check:                                      ; preds = %inner.body, %outer.header
  %j = phi i32 [ %i, %outer.header ], [ %j.dec, %inner.body ]
  %j.gt0 = icmp sgt i32 %j, 0
  br i1 %j.gt0, label %inner.cmp, label %place.key

inner.cmp:                                        ; preds = %inner.check
  %jm1 = add nsw i32 %j, -1
  %jm1.i64 = sext i32 %jm1 to i64
  %a.jm1.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %jm1.i64
  %a.jm1 = load i32, i32* %a.jm1.ptr, align 4
  %cmp.shift = icmp sgt i32 %a.jm1, %key
  br i1 %cmp.shift, label %inner.body, label %place.key

inner.body:                                       ; preds = %inner.cmp
  %j.i64 = sext i32 %j to i64
  %a.j.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %j.i64
  store i32 %a.jm1, i32* %a.j.ptr, align 4
  %j.dec = add nsw i32 %j, -1
  br label %inner.check

place.key:                                        ; preds = %inner.cmp, %inner.check
  %j.final = phi i32 [ %j, %inner.check ], [ %j, %inner.cmp ]
  %j.final.i64 = sext i32 %j.final to i64
  %dst.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %j.final.i64
  store i32 %key, i32* %dst.ptr, align 4
  %done = icmp eq i32 %i, 9
  br i1 %done, label %print.entry, label %outer.latch

outer.latch:                                      ; preds = %place.key
  %i.next = add nsw i32 %i, 1
  br label %outer.header

print.entry:                                      ; preds = %place.key
  br label %print.loop

print.loop:                                       ; preds = %print.loop, %print.entry
  %k = phi i32 [ 0, %print.entry ], [ %k.next, %print.loop ]
  %k.i64 = sext i32 %k to i64
  %k.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %k.i64
  %val = load i32, i32* %k.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i32 %val)
  %k.next = add nsw i32 %k, 1
  %cont = icmp eq i32 %k.next, 10
  br i1 %cont, label %print.after, label %print.loop

print.after:                                      ; preds = %print.loop
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %call.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
  ; stack canary check
  %loaded.canary = load i64, i64* %canary, align 8
  %canary.bad = icmp ne i64 %loaded.canary, 0
  br i1 %canary.bad, label %canary.fail, label %ret.ok

canary.fail:                                      ; preds = %print.after
  call void @__stack_chk_fail()
  unreachable

ret.ok:                                           ; preds = %print.after
  ret i32 0
}