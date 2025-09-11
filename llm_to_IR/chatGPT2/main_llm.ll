; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x40141B
; Intent: demo/driver that prints an int array, calls heap_sort(a, n), then prints the sorted array (confidence=0.93). Evidence: stack-local 9-element int array initialized with {7,3,9,1,4,8,2,6,5}, two printf-loops around a call to heap_sort, newline via putchar.
; Preconditions: The C library shims @_printf and @_putchar are modeled as canonical calls. Read-only strings expected at 0x402004 ("prefix #1"), 0x40200D ("%d "), 0x402011 ("prefix #2") within %MEM.
; Postconditions: Returns 0 in RAX; observable effects are the two prints and the in-place sort performed by @heap_sort on the provided array memory.

%Regs = type {
i64, i64, i64, i64, i64, i64, i64, i64,
i64, i64, i64, i64, i64, i64, i64, i64,
i64, i1, i1, i1, i1, i1, i1, i1
}

declare void @llvm.trap()

; canonical interface for callees referenced by this function
declare dso_local void @heap_sort(i8* nocapture, %Regs* nocapture) local_unnamed_addr
declare dso_local void @_printf(i8* nocapture, %Regs* nocapture) local_unnamed_addr
declare dso_local void @_putchar(i8* nocapture, %Regs* nocapture) local_unnamed_addr

define dso_local void @main(i8* nocapture %MEM, %Regs* nocapture %S) local_unnamed_addr {
entry:
; -------- load commonly used register fields --------
%RAX.p = getelementptr inbounds %Regs, %Regs* %S, i32 0, i32 0
%RBX.p = getelementptr inbounds %Regs, %Regs* %S, i32 0, i32 1
%RCX.p = getelementptr inbounds %Regs, %Regs* %S, i32 0, i32 2
%RDX.p = getelementptr inbounds %Regs, %Regs* %S, i32 0, i32 3
%RSI.p = getelementptr inbounds %Regs, %Regs* %S, i32 0, i32 4
%RDI.p = getelementptr inbounds %Regs, %Regs* %S, i32 0, i32 5
%RBP.p = getelementptr inbounds %Regs, %Regs* %S, i32 0, i32 6
%RSP.p = getelementptr inbounds %Regs, %Regs* %S, i32 0, i32 7
%RSP0 = load i64, i64* %RSP.p, align 8

; -------- synthesize space for the local array below current RSP (no actual prologue modeled) --------
; int arr[9] lives at (RSP0 - 0x40)
%arr.addr = add i64 %RSP0, -64
%arr.base.i8 = getelementptr inbounds i8, i8* %MEM, i64 %arr.addr
%arr.base = bitcast i8* %arr.base.i8 to i32*

; initialize arr with {7,3,9,1,4,8,2,6,5}
%p0 = getelementptr inbounds i32, i32* %arr.base, i64 0
store i32 7, i32* %p0, align 4
%p1 = getelementptr inbounds i32, i32* %arr.base, i64 1
store i32 3, i32* %p1, align 4
%p2 = getelementptr inbounds i32, i32* %arr.base, i64 2
store i32 9, i32* %p2, align 4
%p3 = getelementptr inbounds i32, i32* %arr.base, i64 3
store i32 1, i32* %p3, align 4
%p4 = getelementptr inbounds i32, i32* %arr.base, i64 4
store i32 4, i32* %p4, align 4
%p5 = getelementptr inbounds i32, i32* %arr.base, i64 5
store i32 8, i32* %p5, align 4
%p6 = getelementptr inbounds i32, i32* %arr.base, i64 6
store i32 2, i32* %p6, align 4
%p7 = getelementptr inbounds i32, i32* %arr.base, i64 7
store i32 6, i32* %p7, align 4
%p8 = getelementptr inbounds i32, i32* %arr.base, i64 8
store i32 5, i32* %p8, align 4

; n = 9 (size_t)
%n = add i64 0, 9

; printf(prefix #1) (RDI = 0x402004, EAX = 0)
store i64 0, i64* %RAX.p, align 8
store i64 4202500, i64* %RDI.p, align 8 ; 0x402004
call void @_printf(i8* %MEM, %Regs* %S)

; for (i = 0; i < n; ++i) printf("%d ", arr[i]);
br label %print1.loop

print1.loop:
%i0 = phi i64 [ 0, %entry ], [ %i0.next, %print1.body ]
%cond0 = icmp ult i64 %i0, %n
br i1 %cond0, label %print1.body, label %after.print1

print1.body:
%elem.ptr0 = getelementptr inbounds i32, i32* %arr.base, i64 %i0
%elem0 = load i32, i32* %elem.ptr0, align 4
%elem0.sext = sext i32 %elem0 to i64
store i64 0, i64* %RAX.p, align 8
store i64 4202509, i64* %RDI.p, align 8 ; 0x40200D -> "%d "
store i64 %elem0.sext, i64* %RSI.p, align 8
call void @_printf(i8* %MEM, %Regs* %S)
%i0.next = add i64 %i0, 1
br label %print1.loop

after.print1:
; putchar('\n') (RDI = 10)
store i64 10, i64* %RDI.p, align 8
call void @_putchar(i8* %MEM, %Regs* %S)

; heap_sort(arr, n) — RDI=a, RSI=n
store i64 %arr.addr, i64* %RDI.p, align 8
store i64 %n, i64* %RSI.p, align 8
call void @heap_sort(i8* %MEM, %Regs* %S)

; printf(prefix #2)
store i64 0, i64* %RAX.p, align 8
store i64 4202513, i64* %RDI.p, align 8 ; 0x402011
call void @_printf(i8* %MEM, %Regs* %S)

; for (i = 0; i < n; ++i) printf("%d ", arr[i]);
br label %print2.loop

print2.loop:
%i1 = phi i64 [ 0, %after.print1 ], [ %i1.next, %print2.body ]
%cond1 = icmp ult i64 %i1, %n
br i1 %cond1, label %print2.body, label %after.print2

print2.body:
%elem.ptr1 = getelementptr inbounds i32, i32* %arr.base, i64 %i1
%elem1 = load i32, i32* %elem.ptr1, align 4
%elem1.sext = sext i32 %elem1 to i64
store i64 0, i64* %RAX.p, align 8
store i64 4202509, i64* %RDI.p, align 8 ; 0x40200D -> "%d "
store i64 %elem1.sext, i64* %RSI.p, align 8
call void @_printf(i8* %MEM, %Regs* %S)
%i1.next = add i64 %i1, 1
br label %print2.loop

after.print2:
; putchar('\n')
store i64 10, i64* %RDI.p, align 8
call void @_putchar(i8* %MEM, %Regs* %S)

; return 0;
store i64 0, i64* %RAX.p, align 8

; standard epilogue: RIP=[RSP], RSP+=8
%RSP.now = load i64, i64* %RSP.p, align 8
%retaddr.i8 = getelementptr inbounds i8, i8* %MEM, i64 %RSP.now
%retaddr.p = bitcast i8* %retaddr.i8 to i64*
%retaddr = load i64, i64* %retaddr.p, align 8
%RIP.p = getelementptr inbounds %Regs, %Regs* %S, i32 0, i32 16
store i64 %retaddr, i64* %RIP.p, align 8
%RSP.next = add i64 %RSP.now, 8
store i64 %RSP.next, i64* %RSP.p, align 8
ret void
}