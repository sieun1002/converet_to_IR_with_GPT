; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x0000000000001080
; Intent: print binary search results for fixed keys (confidence=0.92). Evidence: printf formats mention "key" and "index"; lower_bound-style binary search loop with signed compare.
; Preconditions: None
; Postconditions: Returns 0

@fmt_found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@fmt_not = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1
@arr = private unnamed_addr constant [9 x i32] [i32 -5, i32 -1, i32 0, i32 2, i32 2, i32 3, i32 7, i32 9, i32 12], align 4
@keys = private unnamed_addr constant [3 x i32] [i32 2, i32 5, i32 -5], align 4

; Only the needed extern declarations:
declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  br label %keys.loop

keys.loop:                                        ; preds = %after_print, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %after_print ]
  %more = icmp ult i64 %i, 3
  br i1 %more, label %do_search, label %exit

do_search:                                        ; preds = %keys.loop
  %keyptr = getelementptr inbounds [3 x i32], [3 x i32]* @keys, i64 0, i64 %i
  %key = load i32, i32* %keyptr, align 4
  br label %bs.loop

bs.loop:                                          ; preds = %cont, %do_search
  %lo = phi i64 [ 0, %do_search ], [ %lo2, %cont ]
  %hi = phi i64 [ 9, %do_search ], [ %hi2, %cont ]
  %cmp = icmp ugt i64 %hi, %lo
  br i1 %cmp, label %calc_mid, label %bs.done

calc_mid:                                         ; preds = %bs.loop
  %diff = sub i64 %hi, %lo
  %half = lshr i64 %diff, 1
  %mid = add i64 %lo, %half
  %aptr = getelementptr inbounds [9 x i32], [9 x i32]* @arr, i64 0, i64 %mid
  %aval = load i32, i32* %aptr, align 4
  %lt = icmp slt i32 %aval, %key
  br i1 %lt, label %set_lo, label %set_hi

set_lo:                                           ; preds = %calc_mid
  %mid.plus1 = add i64 %mid, 1
  br label %cont

set_hi:                                           ; preds = %calc_mid
  br label %cont

cont:                                             ; preds = %set_hi, %set_lo
  %lo2 = phi i64 [ %mid.plus1, %set_lo ], [ %lo, %set_hi ]
  %hi2 = phi i64 [ %hi, %set_lo ], [ %mid, %set_hi ]
  br label %bs.loop

bs.done:                                          ; preds = %bs.loop
  %lo.final = phi i64 [ %lo, %bs.loop ]
  %le8 = icmp ule i64 %lo.final, 8
  br i1 %le8, label %check_eq, label %print_not

check_eq:                                         ; preds = %bs.done
  %aptr2 = getelementptr inbounds [9 x i32], [9 x i32]* @arr, i64 0, i64 %lo.final
  %aval2 = load i32, i32* %aptr2, align 4
  %eq = icmp eq i32 %aval2, %key
  br i1 %eq, label %print_found, label %print_not

print_found:                                      ; preds = %check_eq
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @fmt_found, i64 0, i64 0
  call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt1, i32 %key, i64 %lo.final)
  br label %after_print

print_not:                                        ; preds = %check_eq, %bs.done
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @fmt_not, i64 0, i64 0
  call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt2, i32 %key)
  br label %after_print

after_print:                                      ; preds = %print_not, %print_found
  %i.next = add i64 %i, 1
  br label %keys.loop

exit:                                             ; preds = %keys.loop
  ret i32 0
}