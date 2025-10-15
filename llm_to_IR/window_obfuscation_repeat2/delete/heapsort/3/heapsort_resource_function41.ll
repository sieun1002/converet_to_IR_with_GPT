; ModuleID = 'recovered'
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i8*
@qword_1400070D0 = external global i8*

declare i8* @signal(i32, i8*)
declare void @sub_140001010()
declare void @sub_1400024E0()

define dso_local void @start() {
entry:
  %0 = load i8*, i8** @off_140004400, align 8
  %1 = bitcast i8* %0 to i32*
  store i32 0, i32* %1, align 4
  call void @sub_140001010()
  ret void
}

define dso_local i32 @TopLevelExceptionFilter(i8* %arg) {
entry:
  %rbx.save = ptrtoint i8* %arg to i64
  %p1 = bitcast i8* %arg to i8**
  %rdx = load i8*, i8** %p1, align 8
  %eaxptr = bitcast i8* %rdx to i32*
  %eax = load i32, i32* %eaxptr, align 4
  %masked = and i32 %eax, 553648127
  %cmp_magic = icmp eq i32 %masked, 541541187
  br i1 %cmp_magic, label %bb130, label %bb0A1

bb130:                                            ; loc_140002130
  %byteptr = getelementptr i8, i8* %rdx, i64 4
  %b = load i8, i8* %byteptr, align 1
  %b1 = and i8 %b, 1
  %tst = icmp ne i8 %b1, 0
  br i1 %tst, label %bb0A1, label %ret_def

bb0A1:                                            ; loc_1400020A1
  %cmp_hi = icmp ugt i32 %eax, 3221225622
  br i1 %cmp_hi, label %bb20EF, label %bbCheckLow

bbCheckLow:
  %cmp_le_8B = icmp ule i32 %eax, 3221225611
  br i1 %cmp_le_8B, label %bb2110, label %bbSwitch

bbSwitch:
  switch i32 %eax, label %ret_def [
    i32 3221225613, label %bb0D0
    i32 3221225614, label %bb0D0
    i32 3221225615, label %bb0D0
    i32 3221225616, label %bb0D0
    i32 3221225617, label %bb0D0
    i32 3221225619, label %bb0D0
    i32 3221225620, label %bb2190
    i32 3221225622, label %bb215E
    i32 3221225618, label %ret_def
    i32 3221225621, label %ret_def
  ]

bb0D0:                                            ; loc_1400020D0
  %h0 = call i8* @signal(i32 8, i8* null)
  %is_one0 = icmp eq i8* %h0, inttoptr (i64 1 to i8*)
  br i1 %is_one0, label %bb2224, label %bb0D0_after

bb0D0_after:
  %nonnull0 = icmp ne i8* %h0, null
  br i1 %nonnull0, label %bb21F0, label %bb20EF

bb2110:                                           ; loc_140002110
  %eq_5 = icmp eq i32 %eax, 3221225477
  br i1 %eq_5, label %bb21C0, label %bb2110_next

bb2110_next:
  %gt_5 = icmp ugt i32 %eax, 3221225477
  br i1 %gt_5, label %bb2150, label %bb211D

bb211D:
  %eq_80000002 = icmp eq i32 %eax, 2147483650
  br i1 %eq_80000002, label %ret_def, label %bb20EF

bb2150:                                           ; loc_140002150
  %eq_8 = icmp eq i32 %eax, 3221225480
  br i1 %eq_8, label %ret_def, label %bb2150_next

bb2150_next:
  %eq_1D = icmp eq i32 %eax, 3221225501
  br i1 %eq_1D, label %bb215E, label %bb20EF

bb215E:                                           ; loc_14000215E
  %h1 = call i8* @signal(i32 4, i8* null)
  %is_one1 = icmp eq i8* %h1, inttoptr (i64 1 to i8*)
  br i1 %is_one1, label %bb0210, label %bb215E_after

bb215E_after:
  %is_null1 = icmp eq i8* %h1, null
  br i1 %is_null1, label %bb20EF, label %bb215E_call

bb215E_call:
  %fp1 = bitcast i8* %h1 to void (i32)*
  call void %fp1(i32 4)
  br label %ret_def

bb2190:                                           ; loc_140002190
  %h2 = call i8* @signal(i32 8, i8* null)
  %is_one2 = icmp eq i8* %h2, inttoptr (i64 1 to i8*)
  br i1 %is_one2, label %bb2190_one, label %bb2190_check

bb2190_one:
  %_ = call i8* @signal(i32 8, i8* inttoptr (i64 1 to i8*))
  br label %ret_def

bb2190_check:
  %nonnull2 = icmp ne i8* %h2, null
  br i1 %nonnull2, label %bb21F0, label %bb20EF

bb21C0:                                           ; loc_1400021C0
  %h3 = call i8* @signal(i32 11, i8* null)
  %is_one3 = icmp eq i8* %h3, inttoptr (i64 1 to i8*)
  br i1 %is_one3, label %bb21FC, label %bb21C0_after

bb21C0_after:
  %is_null3 = icmp eq i8* %h3, null
  br i1 %is_null3, label %bb20EF, label %bb21C0_call

bb21C0_call:
  %fp3 = bitcast i8* %h3 to void (i32)*
  call void %fp3(i32 11)
  br label %ret_def

bb21F0:                                           ; loc_1400021F0
  %handler4 = phi i8* [ %h0, %bb0D0_after ], [ %h2, %bb2190_check ]
  %fp4 = bitcast i8* %handler4 to void (i32)*
  call void %fp4(i32 8)
  br label %ret_def

bb21FC:                                           ; loc_1400021FC
  %_2 = call i8* @signal(i32 11, i8* inttoptr (i64 1 to i8*))
  br label %ret_def

bb0210:                                           ; loc_140002210
  %_3 = call i8* @signal(i32 4, i8* inttoptr (i64 1 to i8*))
  br label %ret_def

bb2224:                                           ; loc_140002224
  %_4 = call i8* @signal(i32 8, i8* inttoptr (i64 1 to i8*))
  call void @sub_1400024E0()
  br label %ret_def

bb20EF:                                           ; loc_1400020EF
  %fp_ext_ptr = load i8*, i8** @qword_1400070D0, align 8
  %has_fp = icmp ne i8* %fp_ext_ptr, null
  br i1 %has_fp, label %bb20FE, label %bb2140

bb20FE:
  %rbx.val = inttoptr i64 %rbx.save to i8*
  %fp_ext = bitcast i8* %fp_ext_ptr to i32 (i8*)*
  %callres = tail call i32 %fp_ext(i8* %rbx.val)
  ret i32 %callres

bb2140:                                           ; loc_140002140
  ret i32 0

ret_def:                                          ; def_1400020C7
  ret i32 -1
}