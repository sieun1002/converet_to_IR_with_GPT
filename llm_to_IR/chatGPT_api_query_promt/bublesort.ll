; ModuleID = 'bubblesort_from_elf'
source_filename = "bubblesort_from_elf"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl  = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main() {
entry:
  ; int arr[10] = {9,1,5,3,7,2,8,6,4,0};
  %arr = alloca [10 x i32], align 16
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  %p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  %p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  %p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  %p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  %p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 9,  i32* %p0, align 4
  store i32 1,  i32* %p1, align 4
  store i32 5,  i32* %p2, align 4
  store i32 3,  i32* %p3, align 4
  store i32 7,  i32* %p4, align 4
  store i32 2,  i32* %p5, align 4
  store i32 8,  i32* %p6, align 4
  store i32 6,  i32* %p7, align 4
  store i32 4,  i32* %p8, align 4
  store i32 0,  i32* %p9, align 4
  br label %outer_header

; Optimized bubble sort using last-swap bound reduction
outer_header:
  %limit = phi i64 [ 10, %entry ], [ %last.end, %after_inner_set ]
  %first = load i32, i32* %p0, align 4
  br label %inner_loop

inner_loop:
  %i        = phi i64 [ 1, %outer_header ], [ %i.next, %inner_next ]
  %last     = phi i64 [ 0, %outer_header ], [ %last.phi, %inner_next ]
  %prev     = phi i32 [ %first, %outer_header ], [ %prev.next, %inner_next ]
  %cmp.i    = icmp ult i64 %i, %limit
  br i1 %cmp.i, label %inner_body, label %after_inner

inner_body:
  %pi    = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %curr  = load i32, i32* %pi, align 4
  %lt    = icmp slt i32 %curr, %prev
  br i1 %lt, label %swap, label %noswap

swap:
  %im1   = add i64 %i, -1
  %pim1  = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %im1
  store i32 %curr, i32* %pim1, align 4
  store i32 %prev, i32* %pi,   align 4
  br label %inner_next

noswap:
  br label %inner_next

inner_next:
  %prev.next = phi i32 [ %prev, %swap ], [ %curr, %noswap ]
  %last.phi  = phi i64 [ %i,    %swap ], [ %last, %noswap ]
  %i.next    = add i64 %i, 1
  br label %inner_loop

after_inner:
  %last.end = %last
  %done = icmp ule i64 %last.end, 1
  br i1 %done, label %print, label %after_inner_set

after_inner_set:
  br label %outer_header

; Print sorted array
print:
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt, i64 0, i64 0
  br label %print_loop

print_loop:
  %k    = phi i64 [ 0, %print ], [ %k.next, %print_body ]
  %cond = icmp ult i64 %k, 10
  br i1 %cond, label %print_body, label %print_done

print_body:
  %pk   = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %k
  %val  = load i32, i32* %pk, align 4
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i32 %val)
  %k.next = add i64 %k, 1
  br label %print_loop

print_done:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
  ret i32 0
}