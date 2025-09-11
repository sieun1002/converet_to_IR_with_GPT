; ModuleID = 'binarysearch.ll'
source_filename = "binarysearch"
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@.str_found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str_not_found = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1
@.keys = private unnamed_addr constant [3 x i32] [i32 2, i32 5, i32 -5], align 4

declare i32 @__printf_chk(i32, i8*, ...)

define i32 @main(i32 %argc, i8** %argv, i8** %envp) {
entry:
  ; local array of 9 ints; elements [0..7] are initialized as in the binary.
  %arr = alloca [9 x i32], align 16
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr.base, align 4                ; arr[0] = -5
  %p1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 -1, i32* %p1, align 4                      ; arr[1] = -1
  %p2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 0, i32* %p2, align 4                       ; arr[2] = 0
  %p3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 2, i32* %p3, align 4                       ; arr[3] = 2
  %p4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 2, i32* %p4, align 4                       ; arr[4] = 2
  %p5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 3, i32* %p5, align 4                       ; arr[5] = 3
  %p6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 7, i32* %p6, align 4                       ; arr[6] = 7
  %p7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 9, i32* %p7, align 4                       ; arr[7] = 9
  ; arr[8] intentionally left uninitialized, as in the binary

  ; loop over keys: 2, 5, -5
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %loop.keys

loop.keys:
  %i.val = load i32, i32* %i, align 4
  %i.done = icmp sge i32 %i.val, 3
  br i1 %i.done, label %done, label %key.load

key.load:
  %i64 = sext i32 %i.val to i64
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* @.keys, i64 0, i64 %i64
  %key = load i32, i32* %key.ptr, align 4

  ; lower_bound over arr[0..9) (high is 9)
  br label %lb.loop

lb.loop:
  ; low and high carried in PHI nodes
  %low.ph = phi i64 [ 0, %key.load ], [ %low.next, %lb.body.end ]
  %high.ph = phi i64 [ 9, %key.load ], [ %high.next, %lb.body.end ]
  %cont = icmp ugt i64 %high.ph, %low.ph
  br i1 %cont, label %lb.body, label %lb.exit

lb.body:
  %diff = sub i64 %high.ph, %low.ph
  %half = lshr i64 %diff, 1
  %mid = add i64 %low.ph, %half
  %mid.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %mid
  %mid.val = load i32, i32* %mid.ptr, align 4
  %cmp.lt = icmp slt i32 %mid.val, %key
  br i1 %cmp.lt, label %lb.take.right, label %lb.take.left

lb.take.right:
  %mid.plus1 = add i64 %mid, 1
  br label %lb.body.end

lb.take.left:
  br label %lb.body.end

lb.body.end:
  %low.next = phi i64 [ %mid.plus1, %lb.take.right ], [ %low.ph, %lb.take.left ]
  %high.next = phi i64 [ %high.ph, %lb.take.right ], [ %mid, %lb.take.left ]
  br label %lb.loop

lb.exit:
  ; check if found: (low <= 8) && (arr[low] == key)
  %low = phi i64 [ %low.ph, %lb.loop ]
  %low.gt8 = icmp ugt i64 %low, 8
  br i1 %low.gt8, label %notfound, label %maybe.eq

maybe.eq:
  %low.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %low
  %low.val = load i32, i32* %low.ptr, align 4
  %eq = icmp eq i32 %low.val, %key
  br i1 %eq, label %found, label %notfound

found:
  %fmtf = getelementptr inbounds [21 x i8], [21 x i8]* @.str_found, i64 0, i64 0
  ; __printf_chk(1, "key %d -> index %ld\n", key, (long)low)
  %callf = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtf, i32 %key, i64 %low)
  br label %after.print

notfound:
  %fmtn = getelementptr inbounds [21 x i8], [21 x i8]* @.str_not_found, i64 0, i64 0
  ; __printf_chk(1, "key %d -> not found\n", key)
  %calln = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtn, i32 %key)
  br label %after.print

after.print:
  %i.next = add i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop.keys

done:
  ret i32 0
}