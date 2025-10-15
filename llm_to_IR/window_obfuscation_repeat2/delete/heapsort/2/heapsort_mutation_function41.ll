; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*, align 8
@qword_1400070D0 = external global i32 (i8*)*, align 8

declare void @sub_140001010()
declare void @sub_1400024E0()
declare void (i32)* @signal(i32, void (i32)*)

define void @start() {
entry:
  %0 = load i32*, i32** @off_140004400, align 8
  store i32 0, i32* %0, align 4
  call void @sub_140001010()
  ret void
}

define i32 @TopLevelExceptionFilter(i8** %ctx) {
entry:
  %p = load i8*, i8** %ctx, align 8
  %p_i32 = bitcast i8* %p to i32*
  %code = load i32, i32* %p_i32, align 4
  %masked = and i32 %code, 553648127
  %cmp_magic = icmp eq i32 %masked, 541546307
  br i1 %cmp_magic, label %loc_140002130, label %loc_1400020A1

loc_140002130: ; from entry when magic matches
  %off4 = getelementptr i8, i8* %p, i64 4
  %b = load i8, i8* %off4, align 1
  %b1 = and i8 %b, 1
  %hasbit = icmp ne i8 %b1, 0
  br i1 %hasbit, label %loc_1400020A1, label %def_1400020C7

loc_1400020A1: ; selection logic
  %code_phi = phi i32 [ %code, %entry ], [ %code, %loc_140002130 ]
  %cmp_ja = icmp ugt i32 %code_phi, 3221225622
  br i1 %cmp_ja, label %loc_1400020EF, label %range_check

range_check: ; cmp eax, 0xC000008B
  %cmp_jbe = icmp ule i32 %code_phi, 3221225611
  br i1 %cmp_jbe, label %loc_140002110, label %switch_range

loc_140002110:
  %is_av = icmp eq i32 %code_phi, 3221225477
  br i1 %is_av, label %loc_1400021C0, label %gt_av

gt_av:
  %gt_av_u = icmp ugt i32 %code_phi, 3221225477
  br i1 %gt_av_u, label %loc_140002150, label %chk_80000002

chk_80000002:
  %is_80000002 = icmp eq i32 %code_phi, 2147483650
  br i1 %is_80000002, label %def_1400020C7, label %loc_1400020EF

loc_140002150:
  %is_c0000008 = icmp eq i32 %code_phi, 3221225480
  br i1 %is_c0000008, label %def_1400020C7, label %chk_c000001d

chk_c000001d:
  %is_c000001d = icmp eq i32 %code_phi, 3221225501
  br i1 %is_c000001d, label %loc_14000215E, label %loc_1400020EF

switch_range:
  %is_c000009c = icmp eq i32 %code_phi, 3221225628
  br i1 %is_c000009c, label %loc_140002190, label %check_9e

check_9e:
  %is_c000009e = icmp eq i32 %code_phi, 3221225630
  br i1 %is_c000009e, label %loc_14000215E, label %check_group

check_group:
  %is_95 = icmp eq i32 %code_phi, 3221225621
  %is_96 = icmp eq i32 %code_phi, 3221225622
  %is_97 = icmp eq i32 %code_phi, 3221225623
  %is_98 = icmp eq i32 %code_phi, 3221225624
  %is_99 = icmp eq i32 %code_phi, 3221225625
  %is_9b = icmp eq i32 %code_phi, 3221225627
  %or1 = or i1 %is_95, %is_96
  %or2 = or i1 %is_97, %is_98
  %or3 = or i1 %is_99, %is_9b
  %or12 = or i1 %or1, %or2
  %or123 = or i1 %or12, %or3
  br i1 %or123, label %loc_1400020D0, label %def_1400020C7

loc_1400020D0:
  %h0 = call void (i32)* @signal(i32 8, void (i32)* null)
  %sig_ign = inttoptr i64 1 to void (i32)*
  %is_ign = icmp eq void (i32)* %h0, %sig_ign
  br i1 %is_ign, label %loc_140002224, label %test_h0

test_h0:
  %is_null_h0 = icmp eq void (i32)* %h0, null
  br i1 %is_null_h0, label %loc_1400020EF, label %loc_1400021F0_h0

loc_1400021F0_h0:
  call void %h0(i32 8)
  br label %def_1400020C7

loc_140002190:
  %h1 = call void (i32)* @signal(i32 8, void (i32)* null)
  %is_ign1 = icmp eq void (i32)* %h1, %sig_ign
  br i1 %is_ign1, label %set_ign_8, label %test_h1

test_h1:
  %is_null_h1 = icmp eq void (i32)* %h1, null
  br i1 %is_null_h1, label %loc_1400020EF, label %loc_1400021F0_h1

loc_1400021F0_h1:
  call void %h1(i32 8)
  br label %def_1400020C7

set_ign_8:
  %_ = call void (i32)* @signal(i32 8, void (i32)* %sig_ign)
  br label %def_1400020C7

loc_14000215E:
  %h2 = call void (i32)* @signal(i32 4, void (i32)* null)
  %is_ign2 = icmp eq void (i32)* %h2, %sig_ign
  br i1 %is_ign2, label %set_ign_4, label %test_h2

test_h2:
  %is_null_h2 = icmp eq void (i32)* %h2, null
  br i1 %is_null_h2, label %loc_1400020EF, label %call_h2

call_h2:
  call void %h2(i32 4)
  br label %def_1400020C7

set_ign_4:
  %__ = call void (i32)* @signal(i32 4, void (i32)* %sig_ign)
  br label %def_1400020C7

loc_1400021C0:
  %h3 = call void (i32)* @signal(i32 11, void (i32)* null)
  %is_ign3 = icmp eq void (i32)* %h3, %sig_ign
  br i1 %is_ign3, label %set_ign_11, label %test_h3

test_h3:
  %is_null_h3 = icmp eq void (i32)* %h3, null
  br i1 %is_null_h3, label %loc_1400020EF, label %call_h3

call_h3:
  call void %h3(i32 11)
  br label %def_1400020C7

set_ign_11:
  %___ = call void (i32)* @signal(i32 11, void (i32)* %sig_ign)
  br label %def_1400020C7

loc_140002224:
  %____ = call void (i32)* @signal(i32 8, void (i32)* %sig_ign)
  call void @sub_1400024E0()
  br label %def_1400020C7

loc_1400020EF:
  %fp = load i32 (i8*)*, i32 (i8*)** @qword_1400070D0, align 8
  %is_null_fp = icmp eq i32 (i8*)* %fp, null
  br i1 %is_null_fp, label %loc_140002140, label %tailjmp

loc_140002140:
  ret i32 0

tailjmp:
  %arg_as_i8 = bitcast i8** %ctx to i8*
  %ret = call i32 %fp(i8* %arg_as_i8)
  ret i32 %ret

def_1400020C7:
  ret i32 -1
}