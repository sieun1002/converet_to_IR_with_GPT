; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*
@unk_140004BE0 = external global void (i8*, i32, i8*)*

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_0(i8* %h, i32 %reason, i8* %reserved) {
entry:
  %paddr = load i32*, i32** @off_140004370, align 8
  %val = load i32, i32* %paddr, align 4
  %cmp2 = icmp eq i32 %val, 2
  br i1 %cmp2, label %afterSet, label %setTwo

setTwo:                                            ; preds = %entry
  store i32 2, i32* %paddr, align 4
  br label %afterSet

afterSet:                                          ; preds = %setTwo, %entry
  %is2 = icmp eq i32 %reason, 2
  br i1 %is2, label %reason2, label %check1

check1:                                            ; preds = %afterSet
  %is1 = icmp eq i32 %reason, 1
  br i1 %is1, label %reason1, label %exit

exit:                                              ; preds = %check1
  ret void

reason2:                                           ; preds = %afterSet
  %rbx_init = getelementptr inbounds void (i8*, i32, i8*)*, void (i8*, i32, i8*)** @unk_140004BE0, i64 0
  %rsi_init = getelementptr inbounds void (i8*, i32, i8*)*, void (i8*, i32, i8*)** @unk_140004BE0, i64 0
  %eq = icmp eq void (i8*, i32, i8*)** %rbx_init, %rsi_init
  br i1 %eq, label %exit2, label %loop

loop:                                              ; preds = %cont, %reason2
  %rbx.phi = phi void (i8*, i32, i8*)** [ %rbx_init, %reason2 ], [ %rbx_next, %cont ]
  %fp = load void (i8*, i32, i8*)*, void (i8*, i32, i8*)** %rbx.phi, align 8
  %isnullfp = icmp eq void (i8*, i32, i8*)* %fp, null
  br i1 %isnullfp, label %cont, label %doCall

doCall:                                            ; preds = %loop
  call void %fp(i8* %h, i32 %reason, i8* %reserved)
  br label %cont

cont:                                              ; preds = %doCall, %loop
  %rbx_next = getelementptr inbounds void (i8*, i32, i8*)*, void (i8*, i32, i8*)** %rbx.phi, i64 1
  %done = icmp eq void (i8*, i32, i8*)** %rbx_next, %rsi_init
  br i1 %done, label %exit2, label %loop

exit2:                                             ; preds = %cont, %reason2
  ret void

reason1:                                           ; preds = %check1
  tail call void @sub_1400023D0(i8* %h, i32 %reason, i8* %reserved)
  ret void
}