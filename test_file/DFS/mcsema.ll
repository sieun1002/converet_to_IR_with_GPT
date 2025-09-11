; ModuleID = 'DFS_mcsema.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu-elf"

%struct.State = type { %struct.ArchState, [32 x %union.VectorReg], %struct.ArithFlags, %union.anon, %struct.Segments, %struct.AddressSpace, %struct.GPR, %struct.X87Stack, %struct.MMX, %struct.FPUStatusFlags, %union.anon, %union.FPU, %struct.SegmentCaches }
%struct.ArchState = type { i32, i32, %union.anon }
%union.VectorReg = type { %union.vec512_t }
%union.vec512_t = type { %struct.uint64v8_t }
%struct.uint64v8_t = type { [8 x i64] }
%struct.ArithFlags = type { i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8 }
%struct.Segments = type { i16, %union.SegmentSelector, i16, %union.SegmentSelector, i16, %union.SegmentSelector, i16, %union.SegmentSelector, i16, %union.SegmentSelector, i16, %union.SegmentSelector }
%union.SegmentSelector = type { i16 }
%struct.AddressSpace = type { i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg }
%struct.Reg = type { %union.anon }
%struct.GPR = type { i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg }
%struct.X87Stack = type { [8 x %struct.anon.3] }
%struct.anon.3 = type { [6 x i8], %struct.float80_t }
%struct.float80_t = type { [10 x i8] }
%struct.MMX = type { [8 x %struct.anon.4] }
%struct.anon.4 = type { i64, %union.vec64_t }
%union.vec64_t = type { %struct.uint64v1_t }
%struct.uint64v1_t = type { [1 x i64] }
%struct.FPUStatusFlags = type { i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, [4 x i8] }
%union.anon = type { i64 }
%union.FPU = type { %struct.anon.13 }
%struct.anon.13 = type { %struct.FpuFXSAVE, [96 x i8] }
%struct.FpuFXSAVE = type { %union.SegmentSelector, %union.SegmentSelector, %union.FPUAbridgedTagWord, i8, i16, i32, %union.SegmentSelector, i16, i32, %union.SegmentSelector, i16, %union.FPUControlStatus, %union.FPUControlStatus, [8 x %struct.FPUStackElem], [16 x %union.vec128_t] }
%union.FPUAbridgedTagWord = type { i8 }
%union.FPUControlStatus = type { i32 }
%struct.FPUStackElem = type { %union.anon.11, [6 x i8] }
%union.anon.11 = type { %struct.float80_t }
%union.vec128_t = type { %struct.uint128v1_t }
%struct.uint128v1_t = type { [1 x i128] }
%struct.SegmentCaches = type { %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow }
%struct.SegmentShadow = type { %union.anon, i32, i32 }
%seg_1000__init_1b_type = type <{ [27 x i8], [5 x i8], [96 x i8], [16 x i8], [80 x i8], [268 x i8], [4 x i8], [36 x i8], [4 x i8], [28 x i8], [4 x i8], [336 x i8], [4 x i8], [48 x i8], [4 x i8], [36 x i8], [4 x i8], [4 x i8], [4 x i8], [60 x i8], [4 x i8], [60 x i8], [4 x i8], [9 x i8], [3 x i8], [13 x i8] }>
%seg_3d98__init_array_10_type = type <{ [3480 x i8], i8*, i8*, [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [84 x i8], [4 x i8], [20 x i8], i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, [8 x i8], i8*, [8 x i8], [1 x i8] }>
%seg_2000__rodata_24_type = type <{ [36 x i8], [52 x i8], [4 x i8], [4 x i8], [36 x i8], [4 x i8], [36 x i8], [4 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [80 x i8], [4 x i8] }>
%struct.Memory = type opaque
%seg_0_LOAD_750_type = type <{ [8 x i8], [8 x i8], [8 x i8], i8*, [4 x i8], [4 x i8], [4 x i8], [8 x i8], [24 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [8 x i8], [24 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], i8*, [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], i8*, [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], i8*, [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], i8*, [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [8 x i8], [40 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], i8*, [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [28 x i8], [4 x i8], [28 x i8], [4 x i8], [12 x i8], [4 x i8], [52 x i8], [4 x i8], [8 x i8], [8 x i8], [20 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [28 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [244 x i8], [4 x i8], [60 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8] }>

@__mcsema_reg_state = thread_local(initialexec) global %struct.State zeroinitializer
@seg_1000__init_1b = internal constant %seg_1000__init_1b_type <{ [27 x i8] c"\F3\0F\1E\FAH\83\EC\08H\8B\05\D9/\00\00H\85\C0t\02\FF\D0H\83\C4\08\C3", [5 x i8] zeroinitializer, [96 x i8] c"\FF5z/\00\00\F2\FF%{/\00\00\0F\1F\00\F3\0F\1E\FAh\00\00\00\00\F2\E9\E1\FF\FF\FF\90\F3\0F\1E\FAh\01\00\00\00\F2\E9\D1\FF\FF\FF\90\F3\0F\1E\FAh\02\00\00\00\F2\E9\C1\FF\FF\FF\90\F3\0F\1E\FAh\03\00\00\00\F2\E9\B1\FF\FF\FF\90\F3\0F\1E\FAh\04\00\00\00\F2\E9\A1\FF\FF\FF\90", [16 x i8] c"\F3\0F\1E\FA\F2\FF%m/\00\00\0F\1FD\00\00", [80 x i8] c"\F3\0F\1E\FA\F2\FF%\15/\00\00\0F\1FD\00\00\F3\0F\1E\FA\F2\FF%\0D/\00\00\0F\1FD\00\00\F3\0F\1E\FA\F2\FF%\05/\00\00\0F\1FD\00\00\F3\0F\1E\FA\F2\FF%\FD.\00\00\0F\1FD\00\00\F3\0F\1E\FA\F2\FF%\F5.\00\00\0F\1FD\00\00", [268 x i8] c"\F3\0F\1E\FAAW\B9\18\00\00\00\BE\01\00\00\00AVAUATUSH\81\EC\18\01\00\00dH\8B\04%(\00\00\00H\89\84$\08\01\00\001\C0L\8Dl$@L\89\EF\F3H\AB\C7D$\\\01\00\00\00H\B8\01\00\00\00\01\00\00\00H\89D$DH\89D$h\C7D$x\01\00\00\00\C7\84$\8C\00\00\00\01\00\00\00\C7\84$\98\00\00\00\01\00\00\00\C7\07\00\00\00\00\BF\1C\00\00\00\C7\84$\B4\00\00\00\01\00\00\00\C7\84$\C4\00\00\00\01\00\00\00\C7\84$\D4\00\00\00\01\00\00\00\C7\84$\DC\00\00\00\01\00\00\00\C7\84$\E4\00\00\00\01\00\00\00\C7\84$\FC\00\00\00\01\00\00\00\E8\07\FF\FF\FF\BE\01\00\00\00\BF8\00\00\00I\89\C6\E8\F5\FE\FF\FF\BF8\00\00\00I\89\C7\E8\F8\FE\FF\FFM\85\F6I\89\C4\0F\94\C0M\85\FF\0F\94\C2\08\D0\0F\85m\01\00\00M\85\E4\0F\84d\01\00\00I\C7\04$", [4 x i8] zeroinitializer, [36 x i8] c"1\F6\BD\01\00\00\00\BB\01\00\00\00A\C7\06\01\00\00\00H\C7\04$\00\00\00\00\0F\1FD\00\00H\8D\0C\F5", [4 x i8] zeroinitializer, [28 x i8] c"I\8D<\0FH\8B\07H\83\F8\06w@H)\F1I\8D\14\86I\8DL\8D\00\0F\1F\80", [4 x i8] zeroinitializer, [336 x i8] c"D\8B\04\81E\85\C0t\06\8B2\85\F6t)H\83\C0\01H\83\C2\04H\83\F8\07u\E3H\83\EB\01H\85\DBt4I\8Bt\DC\F8\EB\ABH\83\F8\07u\F3\EB\E8\0F\1F\00I\89\04\DCH\8DH\01H\83\C3\01H\89\04\ECH\83\C5\01H\89\0F\C7\02\01\00\00\00H\85\DBu\CCL\89\F7\E8\F6\FD\FF\FFL\89\FF\E8\EE\FD\FF\FFL\89\E7\E8\E6\FD\FF\FF1\D21\C0H\8D5O\0D\00\00\BF\01\00\00\00\E8\11\FE\FF\FFH\85\EDt5I\89\E4L\8D-P\0D\00\00L\8D5E\0D\00\00H\83\C3\01I\8BT\DC\F8H9\EBuUH\8D\0D3\0D\00\00L\89\EE\BF\01\00\00\001\C0\E8\D7\FD\FF\FF1\C0H\8D5\1A\0D\00\00\BF\01\00\00\00\E8\C4\FD\FF\FFH\8B\84$\08\01\00\00dH+\04%(\00\00\00u_H\81\C4\18\01\00\001\C0[]A\\A]A^A_\C3\0F\1FD\00\00L\89\F1L\89\EE\BF\01\00\00\001\C0\E8\86\FD\FF\FF\EB\89L\89\F7\E8<\FD\FF\FFL\89\FF\E84\FD\FF\FFL\89\E7\E8,\FD\FF\FF1\D2H\8D5\97\0C\00\001\C0\BF\01\00\00\00\E8W\FD\FF\FF\E9{\FF\FF\FF\E8\1D\FD\FF\FFf.\0F\1F\84", [4 x i8] zeroinitializer, [48 x i8] c"\00\0F\1F\00\F3\0F\1E\FA1\EDI\89\D1^H\89\E2H\83\E4\F0PTE1\C01\C9H\8D=1\FD\FF\FF\FF\15#,\00\00\F4f.\0F\1F\84\00", [4 x i8] zeroinitializer, [36 x i8] c"H\8D=I,\00\00H\8D\05B,\00\00H9\F8t\15H\8B\05\06,\00\00H\85\C0t\09\FF\E0\0F\1F\80", [4 x i8] zeroinitializer, [4 x i8] c"\C3\0F\1F\80", [4 x i8] zeroinitializer, [60 x i8] c"H\8D=\19,\00\00H\8D5\12,\00\00H)\FEH\89\F0H\C1\EE?H\C1\F8\03H\01\C6H\D1\FEt\14H\8B\05\D5+\00\00H\85\C0t\08\FF\E0f\0F\1FD\00\00\C3\0F\1F\80", [4 x i8] zeroinitializer, [60 x i8] c"\F3\0F\1E\FA\80=\D5+\00\00\00u+UH\83=\B2+\00\00\00H\89\E5t\0CH\8B=\B6+\00\00\E8)\FC\FF\FF\E8d\FF\FF\FF\C6\05\AD+\00\00\01]\C3\0F\1F\00\C3\0F\1F\80", [4 x i8] zeroinitializer, [9 x i8] c"\F3\0F\1E\FA\E9w\FF\FF\FF", [3 x i8] zeroinitializer, [13 x i8] c"\F3\0F\1E\FAH\83\EC\08H\83\C4\08\C3" }>, align 4096
@seg_3d98__init_array_10 = internal global %seg_3d98__init_array_10_type <{ [3480 x i8] zeroinitializer, i8* bitcast (void ()* @frame_dummy to i8*), i8* bitcast (void ()* @__do_global_dtors_aux to i8*), [4 x i8] c"\01\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"S\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\0C\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\00\10\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\0D\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"|\14\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\19\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\98=\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\1B\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\1A\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\A0=\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\1C\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\F5\FE\FFo", [4 x i8] zeroinitializer, [4 x i8] c"\B0\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\05\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\E0\04\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\06\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\D8\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\0A\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\CF\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\0B\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\18\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\15\00\00\00", [12 x i8] zeroinitializer, [4 x i8] c"\03\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\98?\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\02\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"x\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\14\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\07\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\17\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\D8\06\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\07\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\18\06\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\C0\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\09\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\18\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\1E\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\FB\FF\FFo", [4 x i8] zeroinitializer, [4 x i8] c"\01\00\00\08", [4 x i8] zeroinitializer, [4 x i8] c"\FE\FF\FFo", [4 x i8] zeroinitializer, [4 x i8] c"\C8\05\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\FF\FF\FFo", [4 x i8] zeroinitializer, [4 x i8] c"\01\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\F0\FF\FFo", [4 x i8] zeroinitializer, [4 x i8] c"\B0\05\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\F9\FF\FFo", [4 x i8] zeroinitializer, [4 x i8] c"\03\00\00\00", [84 x i8] zeroinitializer, [4 x i8] c"\A8=\00\00", [20 x i8] zeroinitializer, i8* bitcast (i64 (i64)* @free to i8*), i8* bitcast (i64 ()* @__stack_chk_fail to i8*), i8* bitcast (i64 (i64, i64)* @calloc to i8*), i8* bitcast (i64 (i64)* @malloc to i8*), i8* bitcast (i64 (...)* @__printf_chk to i8*), i8* bitcast (void (i32 (i32, i8**, i8**)*, i32, i8**, i8*, i32 (i32, i8**, i8**)*, void ()*, void ()*, i32*)* @__libc_start_main to i8*), i8* bitcast (i64 (i64)* @_ITM_deregisterTMCloneTable to i8*), i8* bitcast (void ()* @__gmon_start__ to i8*), i8* bitcast (i64 (i64, i64)* @_ITM_registerTMCloneTable to i8*), i8* bitcast (i64 (i64)* @__cxa_finalize to i8*), [8 x i8] zeroinitializer, i8* bitcast (i8** @data_4008 to i8*), [8 x i8] zeroinitializer, [1 x i8] zeroinitializer }>, align 4096
@seg_2000__rodata_24 = internal constant %seg_2000__rodata_24_type <{ [36 x i8] c"\01\00\02\00DFS preorder from %zu: \00\0A\00%zu%s\00", [52 x i8] c"\01\1B\03;0\00\00\00\05\00\00\00\FC\EF\FF\FFd\00\00\00\\\F0\FF\FF\8C\00\00\00l\F0\FF\FF\A4\00\00\00\BC\F0\FF\FF\BC\00\00\00l\F3\FF\FFL\00\00\00", [4 x i8] c"\14\00\00\00", [4 x i8] zeroinitializer, [36 x i8] c"\01zR\00\01x\10\01\1B\0C\07\08\90\01\00\00\14\00\00\00\1C\00\00\00\18\F3\FF\FF&\00\00\00\00D\07\10", [4 x i8] zeroinitializer, [36 x i8] c"$\00\00\004\00\00\00\90\EF\FF\FF`\00\00\00\00\0E\10F\0E\18J\0F\0Bw\08\80\00?\1A:*3$\22", [4 x i8] zeroinitializer, [16 x i8] c"\14\00\00\00\\\00\00\00\C8\EF\FF\FF\10\00\00\00", [8 x i8] zeroinitializer, [16 x i8] c"\14\00\00\00t\00\00\00\C0\EF\FF\FFP\00\00\00", [8 x i8] zeroinitializer, [80 x i8] c"L\00\00\00\8C\00\00\00\F8\EF\FF\FF\A3\02\00\00\00F\0E\10\8F\02L\0E\18\8E\03B\0E \8D\04B\0E(\8C\05A\0E0\86\06A\0E8\83\07G\0E\D0\02\03'\02\0A\0E8C\0E0A\0E(B\0E B\0E\18B\0E\10B\0E\08F\0B\00\00\00", [4 x i8] zeroinitializer }>, align 8192
@0 = internal global i1 false
@1 = internal constant %struct.Memory* (%struct.State*, i64, %struct.Memory*)* @main_wrapper
@2 = internal constant void ()* @__mcsema_attach_call
@3 = internal constant %struct.Memory* (%struct.State*, i64, %struct.Memory*)* @frame_dummy_wrapper
@4 = internal constant %struct.Memory* (%struct.State*, i64, %struct.Memory*)* @__do_global_dtors_aux_wrapper
@seg_0_LOAD_750 = internal constant %seg_0_LOAD_750_type <{ [8 x i8] c"\7FELF\02\01\01\00", [8 x i8] zeroinitializer, [8 x i8] c"\03\00>\00\01\00\00\00", i8* bitcast (void ()* @_start to i8*), [4 x i8] c"@\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"P7\00\00", [8 x i8] zeroinitializer, [24 x i8] c"@\008\00\0D\00@\00\1F\00\1E\00\06\00\00\00\04\00\00\00@\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"@\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"@\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\D8\02\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\D8\02\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [12 x i8] c"\03\00\00\00\04\00\00\00\18\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\18\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\18\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\1C\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\1C\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\01\00\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\01\00\00\00\04\00\00\00", [24 x i8] zeroinitializer, [4 x i8] c"P\07\00\00", [4 x i8] zeroinitializer, [4 x i8] c"P\07\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\00\10\00\00", [4 x i8] zeroinitializer, [12 x i8] c"\01\00\00\00\05\00\00\00\00\10\00\00", [4 x i8] zeroinitializer, i8* bitcast (void ()* @.init_proc to i8*), [4 x i8] c"\00\10\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\89\04\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\89\04\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\00\10\00\00", [4 x i8] zeroinitializer, [12 x i8] c"\01\00\00\00\04\00\00\00\00 \00\00", [4 x i8] zeroinitializer, i8* @data_2000, [4 x i8] c"\00 \00\00", [4 x i8] zeroinitializer, [4 x i8] c"4\01\00\00", [4 x i8] zeroinitializer, [4 x i8] c"4\01\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\00\10\00\00", [4 x i8] zeroinitializer, [12 x i8] c"\01\00\00\00\06\00\00\00\98-\00\00", [4 x i8] zeroinitializer, i8* bitcast (i8** @data_3d98 to i8*), [4 x i8] c"\98=\00\00", [4 x i8] zeroinitializer, [4 x i8] c"x\02\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\80\02\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\00\10\00\00", [4 x i8] zeroinitializer, [12 x i8] c"\02\00\00\00\06\00\00\00\A8-\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\A8=\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\A8=\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\F0\01\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\F0\01\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [12 x i8] c"\04\00\00\00\04\00\00\008\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"8\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"8\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"0\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"0\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [12 x i8] c"\04\00\00\00\04\00\00\00h\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"h\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"h\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"D\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"D\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\04\00\00\00", [4 x i8] zeroinitializer, [12 x i8] c"S\E5td\04\00\00\008\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"8\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"8\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"0\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"0\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [12 x i8] c"P\E5td\04\00\00\00$ \00\00", [4 x i8] zeroinitializer, i8* @data_2024, [4 x i8] c"$ \00\00", [4 x i8] zeroinitializer, [4 x i8] c"4\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"4\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\04\00\00\00", [4 x i8] zeroinitializer, [8 x i8] c"Q\E5td\06\00\00\00", [40 x i8] zeroinitializer, [4 x i8] c"\10\00\00\00", [4 x i8] zeroinitializer, [12 x i8] c"R\E5td\04\00\00\00\98-\00\00", [4 x i8] zeroinitializer, i8* bitcast (i8** @data_3d98 to i8*), [4 x i8] c"\98=\00\00", [4 x i8] zeroinitializer, [4 x i8] c"h\02\00\00", [4 x i8] zeroinitializer, [4 x i8] c"h\02\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\01\00\00\00", [4 x i8] zeroinitializer, [28 x i8] c"/lib64/ld-linux-x86-64.so.2\00", [4 x i8] zeroinitializer, [28 x i8] c"\04\00\00\00 \00\00\00\05\00\00\00GNU\00\02\00\00\C0\04\00\00\00\03\00\00\00", [4 x i8] zeroinitializer, [12 x i8] c"\02\80\00\C0\04\00\00\00\01\00\00\00", [4 x i8] zeroinitializer, [52 x i8] c"\04\00\00\00\14\00\00\00\03\00\00\00GNU\00\01\A2\8F\84b\D6\FB\C3\AA&N\F2\D4\9B\EBY\BAC\8D\8B\04\00\00\00\10\00\00\00\01\00\00\00GNU\00", [4 x i8] zeroinitializer, [8 x i8] c"\03\00\00\00\02\00\00\00", [8 x i8] zeroinitializer, [20 x i8] c"\02\00\00\00\0A\00\00\00\01\00\00\00\06\00\00\00\00\00\81\00", [4 x i8] zeroinitializer, [4 x i8] c"\0A\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\D1e\CEm", [28 x i8] zeroinitializer, [8 x i8] c"6\00\00\00\12\00\00\00", [16 x i8] zeroinitializer, [8 x i8] c"$\00\00\00\12\00\00\00", [16 x i8] zeroinitializer, [8 x i8] c"\8A\00\00\00 \00\00\00", [16 x i8] zeroinitializer, [8 x i8] c";\00\00\00\12\00\00\00", [16 x i8] zeroinitializer, [8 x i8] c"L\00\00\00\12\00\00\00", [16 x i8] zeroinitializer, [8 x i8] c"\A6\00\00\00 \00\00\00", [16 x i8] zeroinitializer, [8 x i8] c"\1D\00\00\00\12\00\00\00", [16 x i8] zeroinitializer, [8 x i8] c"\10\00\00\00\12\00\00\00", [16 x i8] zeroinitializer, [8 x i8] c"\B5\00\00\00 \00\00\00", [16 x i8] zeroinitializer, [8 x i8] c"\01\00\00\00\22\00\00\00", [16 x i8] zeroinitializer, [244 x i8] c"\00__cxa_finalize\00__printf_chk\00malloc\00__libc_start_main\00free\00__stack_chk_fail\00calloc\00libc.so.6\00GLIBC_2.3.4\00GLIBC_2.4\00GLIBC_2.34\00GLIBC_2.2.5\00_ITM_deregisterTMCloneTable\00__gmon_start__\00_ITM_registerTMCloneTable\00\00\00\00\02\00\03\00\01\00\04\00\02\00\01\00\02\00\05\00\01\00\02\00\00\00\01\00\04\00S\00\00\00\10\00\00\00", [4 x i8] zeroinitializer, [60 x i8] c"t\19i\09\00\00\05\00]\00\00\00\10\00\00\00\14ii\0D\00\00\04\00i\00\00\00\10\00\00\00\B4\91\96\06\00\00\03\00s\00\00\00\10\00\00\00u\1Ai\09\00\00\02\00~\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\98=\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"p\14\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\A0=\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"0\14\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08@\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08@\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\D8?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\06\00\00\00\02\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\E0?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\06\00\00\00\03\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\E8?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\06\00\00\00\06\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\F0?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\06\00\00\00\09\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\F8?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\06\00\00\00\0A\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\B0?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\07\00\00\00\01\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\B8?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\07\00\00\00\04\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\C0?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\07\00\00\00\05\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\C8?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\07\00\00\00\07\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\D0?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\07\00\00\00\08\00\00\00", [8 x i8] zeroinitializer }>
@5 = internal constant %struct.Memory* (%struct.State*, i64, %struct.Memory*)* @_start_wrapper
@6 = internal constant %struct.Memory* (%struct.State*, i64, %struct.Memory*)* @.init_proc_wrapper

@data_1468 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 21, i32 56)
@data_143d = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 21, i32 13)
@data_12c4 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 11, i32 140)
@data_131f = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 11, i32 231)
@data_137e = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 11, i32 326)
@data_134c = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 11, i32 276)
@data_11df = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 5, i32 255)
@data_1014 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 0, i32 20)
@data_1457 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 21, i32 39)
@data_4008 = internal alias i8*, getelementptr inbounds (%seg_3d98__init_array_10_type, %seg_3d98__init_array_10_type* @seg_3d98__init_array_10, i32 0, i32 118)
@data_3ff8 = internal alias i8*, getelementptr inbounds (%seg_3d98__init_array_10_type, %seg_3d98__init_array_10_type* @seg_3d98__init_array_10, i32 0, i32 116)
@data_1429 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 19, i32 57)
@data_3ff0 = internal alias i8*, getelementptr inbounds (%seg_3d98__init_array_10_type, %seg_3d98__init_array_10_type* @seg_3d98__init_array_10, i32 0, i32 115)
@data_13e9 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 17, i32 1)
@data_3fe0 = internal alias i8*, getelementptr inbounds (%seg_3d98__init_array_10_type, %seg_3d98__init_array_10_type* @seg_3d98__init_array_10, i32 0, i32 113)
@data_4010 = internal alias i8, getelementptr inbounds (%seg_3d98__init_array_10_type, %seg_3d98__init_array_10_type* @seg_3d98__init_array_10, i32 0, i32 119, i32 0)
@data_1379 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 11, i32 321)
@data_1364 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 11, i32 300)
@data_135c = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 11, i32 292)
@data_201c = internal alias i8, getelementptr inbounds (%seg_2000__rodata_24_type, %seg_2000__rodata_24_type* @seg_2000__rodata_24, i32 0, i32 0, i32 28)
@data_12f9 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 11, i32 193)
@data_201d = internal alias i8, getelementptr inbounds (%seg_2000__rodata_24_type, %seg_2000__rodata_24_type* @seg_2000__rodata_24, i32 0, i32 0, i32 29)
@data_201a = internal alias i8, getelementptr inbounds (%seg_2000__rodata_24_type, %seg_2000__rodata_24_type* @seg_2000__rodata_24, i32 0, i32 0, i32 26)
@data_201e = internal alias i8, getelementptr inbounds (%seg_2000__rodata_24_type, %seg_2000__rodata_24_type* @seg_2000__rodata_24, i32 0, i32 0, i32 30)
@data_12bf = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 11, i32 135)
@data_2004 = internal alias i8, getelementptr inbounds (%seg_2000__rodata_24_type, %seg_2000__rodata_24_type* @seg_2000__rodata_24, i32 0, i32 0, i32 4)
@data_12aa = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 11, i32 114)
@data_12a2 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 11, i32 106)
@data_11c8 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 5, i32 232)
@data_11bb = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 5, i32 219)
@data_11a9 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 5, i32 201)
@data_13b5 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 13, i32 41)
@data_3fd8 = internal alias i8*, getelementptr inbounds (%seg_3d98__init_array_10_type, %seg_3d98__init_array_10_type* @seg_3d98__init_array_10, i32 0, i32 112)
@data_102d = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 2, i32 13)
@data_3fa8 = internal alias i8, getelementptr inbounds (%seg_3d98__init_array_10_type, %seg_3d98__init_array_10_type* @seg_3d98__init_array_10, i32 0, i32 106, i32 12)
@data_3fa0 = internal alias i8, getelementptr inbounds (%seg_3d98__init_array_10_type, %seg_3d98__init_array_10_type* @seg_3d98__init_array_10, i32 0, i32 106, i32 4)
@data_1016 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 0, i32 22)
@data_3fe8 = internal alias i8*, getelementptr inbounds (%seg_3d98__init_array_10_type, %seg_3d98__init_array_10_type* @seg_3d98__init_array_10, i32 0, i32 114)
@data_2000 = internal alias i8, getelementptr inbounds (%seg_2000__rodata_24_type, %seg_2000__rodata_24_type* @seg_2000__rodata_24, i32 0, i32 0, i32 0)
@data_3d98 = internal alias i8*, getelementptr inbounds (%seg_3d98__init_array_10_type, %seg_3d98__init_array_10_type* @seg_3d98__init_array_10, i32 0, i32 1)
@data_2024 = internal alias i8, getelementptr inbounds (%seg_2000__rodata_24_type, %seg_2000__rodata_24_type* @seg_2000__rodata_24, i32 0, i32 1, i32 0)
@RSP_2312_217d25b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 13, i32 0, i32 0)
@OF_2077_217d2570 = private thread_local(initialexec) alias i8, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 2, i32 13)
@SF_2073_217d2570 = private thread_local(initialexec) alias i8, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 2, i32 9)
@ZF_2071_217d2570 = private thread_local(initialexec) alias i8, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 2, i32 7)
@AF_2069_217d2570 = private thread_local(initialexec) alias i8, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 2, i32 5)
@PF_2067_217d2570 = private thread_local(initialexec) alias i8, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 2, i32 3)
@CF_2065_217d2570 = private thread_local(initialexec) alias i8, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 2, i32 1)
@RIP_2472_217d25b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 33, i32 0, i32 0)
@RAX_2216_217d25b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 1, i32 0, i32 0)
@RSP_2312_217d9bc0 = private thread_local(initialexec) alias i64*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 13, i32 0, i32 0) to i64**)
@RDI_2296_217e0fa0 = private thread_local(initialexec) alias i32 (i32, i8**, i8**)*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 11, i32 0, i32 0) to i32 (i32, i8**, i8**)**)
@RCX_2248_217d25b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 5, i32 0, i32 0)
@R8_2344_217d25b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 17, i32 0, i32 0)
@RSI_2280_217d25b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 9, i32 0, i32 0)
@RDX_2264_217d25b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 7, i32 0, i32 0)
@R9_2360_217d25b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 19, i32 0, i32 0)
@RBP_2328_217d25b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 15, i32 0, i32 0)
@RIP_2472_217d9a60 = private thread_local(initialexec) alias i8*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 33, i32 0, i32 0) to i8**)
@DF_2075_217d2570 = private thread_local(initialexec) alias i8, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 2, i32 11)
@RDI_2296_217d25b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 11, i32 0, i32 0)
@RDI_2296_217d9bc0 = private thread_local(initialexec) alias i64*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 11, i32 0, i32 0) to i64**)
@RAX_2216_217d9bc0 = private thread_local(initialexec) alias i64*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 1, i32 0, i32 0) to i64**)
@RDX_2264_217df140 = private thread_local(initialexec) alias i32*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 7, i32 0, i32 0) to i32**)
@RSI_2280_217d9a60 = private thread_local(initialexec) alias i8*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 9, i32 0, i32 0) to i8**)
@RDI_2296_217df140 = private thread_local(initialexec) alias i32*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 11, i32 0, i32 0) to i32**)
@FSBASE_2168_217d25b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 5, i32 7, i32 0, i32 0)
@RBX_2232_217d25b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 3, i32 0, i32 0)
@R12_2408_217d25b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 25, i32 0, i32 0)
@R13_2424_217d9a60 = private thread_local(initialexec) alias i8*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 27, i32 0, i32 0) to i8**)
@R13_2424_217d25b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 27, i32 0, i32 0)
@R14_2440_217d9a60 = private thread_local(initialexec) alias i8*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 29, i32 0, i32 0) to i8**)
@R14_2440_217d25b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 29, i32 0, i32 0)
@R14_2440_217df140 = private thread_local(initialexec) alias i32*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 29, i32 0, i32 0) to i32**)
@RCX_2248_217d9a60 = private thread_local(initialexec) alias i8*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 5, i32 0, i32 0) to i8**)
@R15_2456_217d25b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 31, i32 0, i32 0)
@RAX_2216_217d2570 = private thread_local(initialexec) alias i8, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 1, i32 0, i32 0) to i8*)
@RDX_2264_217d2570 = private thread_local(initialexec) alias i8, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 7, i32 0, i32 0) to i8*)
@RAX_2216_217d9a60 = private thread_local(initialexec) alias i8*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 1, i32 0, i32 0) to i8**)
@RDI_2296_217d9a60 = private thread_local(initialexec) alias i8*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 11, i32 0, i32 0) to i8**)

declare !remill.function.type !1289 dso_local %struct.Memory* @__remill_sync_hyper_call(%struct.State* dereferenceable(3376), %struct.Memory*, i32) #0

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare !remill.function.type !1289 i32 @llvm.ctpop.i32(i32) #1

; Function Attrs: alwaysinline inlinehint noduplicate noreturn nounwind
define internal %struct.Memory* @__remill_error(%struct.State* dereferenceable(3376) %0, i64 %1, %struct.Memory* %2) #2 !remill.function.type !1289 {
  call void @abort()
  unreachable
}

; Function Attrs: noduplicate noinline nounwind optnone readnone
declare !remill.function.type !1289 dso_local %struct.Memory* @__remill_barrier_store_load(%struct.Memory*) #3

; Function Attrs: noduplicate noinline nounwind optnone readnone
declare !remill.function.type !1289 dso_local %struct.Memory* @__remill_barrier_store_store(%struct.Memory*) #3

; Function Attrs: noduplicate noinline nounwind optnone readnone
declare !remill.function.type !1289 dso_local %struct.Memory* @__remill_barrier_load_load(%struct.Memory*) #3

; Function Attrs: nounwind readnone
declare !remill.function.type !1289 dso_local i32 @__remill_fpu_exception_test_and_clear(i32, i32) #4

; Function Attrs: noduplicate noinline nounwind optnone readnone
declare !remill.function.type !1289 dso_local %struct.Memory* @__remill_barrier_load_store(%struct.Memory*) #5

; Function Attrs: noduplicate noinline nounwind optnone readnone
declare !remill.function.type !1289 dso_local %struct.Memory* @__remill_atomic_begin(%struct.Memory*) #5

; Function Attrs: noduplicate noinline nounwind optnone readnone
declare !remill.function.type !1289 dso_local %struct.Memory* @__remill_atomic_end(%struct.Memory*) #5

; Function Attrs: noduplicate noinline nounwind optnone readnone
declare !remill.function.type !1289 dso_local %struct.Memory* @__remill_delay_slot_begin(%struct.Memory*) #5

; Function Attrs: noduplicate noinline nounwind optnone readnone
declare !remill.function.type !1289 dso_local %struct.Memory* @__remill_delay_slot_end(%struct.Memory*) #5

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !1289 dso_local %struct.Memory* @__remill_function_call(%struct.State* nonnull, i64, %struct.Memory*) #6

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !1289 dso_local %struct.Memory* @__remill_function_return(%struct.State* nonnull, i64, %struct.Memory*) #6

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !1289 dso_local %struct.Memory* @__remill_jump(%struct.State* nonnull, i64, %struct.Memory*) #6

; Function Attrs: alwaysinline inlinehint noduplicate noreturn nounwind
define internal %struct.Memory* @__remill_missing_block(%struct.State* nonnull %0, i64 %1, %struct.Memory* %2) #7 !remill.function.type !1289 {
  call void @abort()
  unreachable
}

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !1289 dso_local %struct.Memory* @__remill_async_hyper_call(%struct.State* nonnull, i64, %struct.Memory*) #6

; Function Attrs: naked nobuiltin noinline
define private void @_start() #8 {
  call void asm sideeffect "pushq $0;pushq $$0x1390;jmpq *$1;", "*m,*m,~{dirflag},~{fpsr},~{flags}"(%struct.Memory* (%struct.State*, i64, %struct.Memory*)** elementtype(%struct.Memory* (%struct.State*, i64, %struct.Memory*)*) @5, void ()** elementtype(void ()*) @2)
  ret void
}

; Function Attrs: naked nobuiltin noinline
define private void @frame_dummy() #8 {
  call void asm sideeffect "pushq $0;pushq $$0x1470;jmpq *$1;", "*m,*m,~{dirflag},~{fpsr},~{flags}"(%struct.Memory* (%struct.State*, i64, %struct.Memory*)** elementtype(%struct.Memory* (%struct.State*, i64, %struct.Memory*)*) @3, void ()** elementtype(void ()*) @2)
  ret void
}

; Function Attrs: naked nobuiltin noinline
define private void @__do_global_dtors_aux() #8 {
  call void asm sideeffect "pushq $0;pushq $$0x1430;jmpq *$1;", "*m,*m,~{dirflag},~{fpsr},~{flags}"(%struct.Memory* (%struct.State*, i64, %struct.Memory*)** elementtype(%struct.Memory* (%struct.State*, i64, %struct.Memory*)*) @4, void ()** elementtype(void ()*) @2)
  ret void
}

; Function Attrs: naked nobuiltin noinline
define private void @.init_proc() #8 {
  call void asm sideeffect "pushq $0;pushq $$0x1000;jmpq *$1;", "*m,*m,~{dirflag},~{fpsr},~{flags}"(%struct.Memory* (%struct.State*, i64, %struct.Memory*)** elementtype(%struct.Memory* (%struct.State*, i64, %struct.Memory*)*) @6, void ()** elementtype(void ()*) @2)
  ret void
}

; Function Attrs: noreturn
declare void @abort() #9

; Function Attrs: noinline
define internal %struct.Memory* @sub_1000__init_proc(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1000:
  %0 = load i64, i64* @RSP_2312_217d25b8, align 8
  %1 = sub i64 %0, 8
  store i64 %1, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %2 = load i64, i64* bitcast (i8** @data_3fe8 to i64*), align 8
  store i64 %2, i64* @RAX_2216_217d25b8, align 8, !tbaa !1290
  store i8 0, i8* @CF_2065_217d2570, align 1, !tbaa !1294
  %3 = trunc i64 %2 to i32
  %4 = and i32 %3, 255
  %5 = call i32 @llvm.ctpop.i32(i32 %4) #13, !range !1308
  %6 = trunc i32 %5 to i8
  %7 = and i8 %6, 1
  %8 = xor i8 %7, 1
  store i8 %8, i8* @PF_2067_217d2570, align 1, !tbaa !1309
  %9 = icmp eq i64 %2, 0
  %10 = zext i1 %9 to i8
  store i8 %10, i8* @ZF_2071_217d2570, align 1, !tbaa !1310
  %11 = lshr i64 %2, 63
  %12 = trunc i64 %11 to i8
  store i8 %12, i8* @SF_2073_217d2570, align 1, !tbaa !1311
  store i8 0, i8* @OF_2077_217d2570, align 1, !tbaa !1312
  store i8 0, i8* @AF_2069_217d2570, align 1, !tbaa !1313
  br i1 %9, label %inst_1016, label %inst_1014

inst_1016:                                        ; preds = %inst_1014, %inst_1000
  %13 = phi %struct.Memory* [ %memory, %inst_1000 ], [ %46, %inst_1014 ]
  %14 = load i64, i64* @RSP_2312_217d25b8, align 8
  %15 = add i64 8, %14
  %16 = icmp ult i64 %15, %14
  %17 = icmp ult i64 %15, 8
  %18 = or i1 %16, %17
  %19 = zext i1 %18 to i8
  store i8 %19, i8* @CF_2065_217d2570, align 1, !tbaa !1294
  %20 = trunc i64 %15 to i32
  %21 = and i32 %20, 255
  %22 = call i32 @llvm.ctpop.i32(i32 %21) #13, !range !1308
  %23 = trunc i32 %22 to i8
  %24 = and i8 %23, 1
  %25 = xor i8 %24, 1
  store i8 %25, i8* @PF_2067_217d2570, align 1, !tbaa !1309
  %26 = xor i64 8, %14
  %27 = xor i64 %26, %15
  %28 = lshr i64 %27, 4
  %29 = trunc i64 %28 to i8
  %30 = and i8 %29, 1
  store i8 %30, i8* @AF_2069_217d2570, align 1, !tbaa !1313
  %31 = icmp eq i64 %15, 0
  %32 = zext i1 %31 to i8
  store i8 %32, i8* @ZF_2071_217d2570, align 1, !tbaa !1310
  %33 = lshr i64 %15, 63
  %34 = trunc i64 %33 to i8
  store i8 %34, i8* @SF_2073_217d2570, align 1, !tbaa !1311
  %35 = lshr i64 %14, 63
  %36 = xor i64 %33, %35
  %37 = add nuw nsw i64 %36, %33
  %38 = icmp eq i64 %37, 2
  %39 = zext i1 %38 to i8
  store i8 %39, i8* @OF_2077_217d2570, align 1, !tbaa !1312
  %40 = add i64 %15, 8
  store i64 %40, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  ret %struct.Memory* %13

inst_1014:                                        ; preds = %inst_1000
  %41 = icmp eq i8 %10, 0
  %42 = select i1 %41, i64 ptrtoint (i8* @data_1014 to i64), i64 ptrtoint (i8* @data_1016 to i64)
  %43 = add i64 %42, 2
  %44 = add i64 %1, -8
  %45 = inttoptr i64 %44 to i64*
  store i64 %43, i64* %45, align 8
  store i64 %44, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  store i64 %2, i64* @RIP_2472_217d25b8, align 8, !tbaa !1290
  %46 = call %struct.Memory* @__remill_function_call(%struct.State* @__mcsema_reg_state, i64 %2, %struct.Memory* %memory)
  br label %inst_1016
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1020(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1020:
  %0 = load i64, i64* bitcast (i8* @data_3fa0 to i64*), align 8
  %1 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %2 = add i64 %1, -8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3, align 8
  store i64 %2, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %4 = load i64, i64* bitcast (i8* @data_3fa8 to i64*), align 8
  store i64 %4, i64* @RIP_2472_217d25b8, align 8, !tbaa !1290
  %5 = icmp eq i64 %4, 4141
  br i1 %5, label %inst_102d, label %6

inst_102d:                                        ; preds = %6, %inst_1020
  ret %struct.Memory* %memory

6:                                                ; preds = %inst_1020
  %7 = sub i64 ptrtoint (i8* @data_102d to i64), %4
  %8 = trunc i64 %7 to i32
  %9 = zext i32 %8 to i64
  %10 = icmp eq i64 %9, 0
  br i1 %10, label %inst_102d, label %11

11:                                               ; preds = %6
  %12 = call %struct.Memory* @__remill_jump(%struct.State* @__mcsema_reg_state, i64 %4, %struct.Memory* %memory)
  ret %struct.Memory* %12
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1030(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1030:
  %0 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %1 = add i64 %0, -8
  %2 = inttoptr i64 %1 to i64*
  store i64 0, i64* %2, align 8
  store i64 %1, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %3 = call %struct.Memory* @sub_1020(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  ret %struct.Memory* %3
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1470_frame_dummy(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1470:
  %0 = call %struct.Memory* @sub_13f0_register_tm_clones(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  ret %struct.Memory* %0
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1040(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1040:
  %0 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %1 = add i64 %0, -8
  %2 = inttoptr i64 %1 to i64*
  store i64 1, i64* %2, align 8
  store i64 %1, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %3 = call %struct.Memory* @sub_1020(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  ret %struct.Memory* %3
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1050(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1050:
  %0 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %1 = add i64 %0, -8
  %2 = inttoptr i64 %1 to i64*
  store i64 2, i64* %2, align 8
  store i64 %1, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %3 = call %struct.Memory* @sub_1020(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  ret %struct.Memory* %3
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1060(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1060:
  %0 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %1 = add i64 %0, -8
  %2 = inttoptr i64 %1 to i64*
  store i64 3, i64* %2, align 8
  store i64 %1, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %3 = call %struct.Memory* @sub_1020(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  ret %struct.Memory* %3
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1390__start(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1390:
  store i64 0, i64* @RBP_2328_217d25b8, align 8, !tbaa !1290
  %0 = load i64, i64* @RDX_2264_217d25b8, align 8
  store i64 %0, i64* @R9_2360_217d25b8, align 8, !tbaa !1290
  %1 = load i64*, i64** @RSP_2312_217d9bc0, align 8
  %2 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %3 = add i64 %2, 8
  %4 = load i64, i64* %1, align 8
  store i64 %4, i64* @RSI_2280_217d25b8, align 8, !tbaa !1290
  store i64 %3, i64* @RDX_2264_217d25b8, align 8, !tbaa !1290
  %5 = and i64 -16, %3
  %6 = load i64, i64* @RAX_2216_217d25b8, align 8
  %7 = add i64 %5, -8
  %8 = inttoptr i64 %7 to i64*
  store i64 %6, i64* %8, align 8
  %9 = add i64 %7, -8
  %10 = getelementptr i64, i64* %8, i32 -1
  store i64 %7, i64* %10, align 8
  store i64 0, i64* @R8_2344_217d25b8, align 8, !tbaa !1290
  store i64 0, i64* @RCX_2248_217d25b8, align 8, !tbaa !1290
  store i8 0, i8* @CF_2065_217d2570, align 1, !tbaa !1294
  store i8 1, i8* @PF_2067_217d2570, align 1, !tbaa !1309
  store i8 1, i8* @ZF_2071_217d2570, align 1, !tbaa !1310
  store i8 0, i8* @SF_2073_217d2570, align 1, !tbaa !1311
  store i8 0, i8* @OF_2077_217d2570, align 1, !tbaa !1312
  store i8 0, i8* @AF_2069_217d2570, align 1, !tbaa !1313
  store i32 (i32, i8**, i8**)* @main, i32 (i32, i8**, i8**)** @RDI_2296_217e0fa0, align 8
  %11 = add i64 %9, -8
  %12 = load i64, i64* bitcast (i8** @data_3fd8 to i64*), align 8
  %13 = getelementptr i64, i64* %10, i32 -1
  store i64 ptrtoint (i8** @data_3fd8 to i64), i64* %13, align 8
  store i64 %11, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  store i64 %12, i64* @RIP_2472_217d25b8, align 8, !tbaa !1290
  %14 = call %struct.Memory* @__remill_function_call(%struct.State* @__mcsema_reg_state, i64 %12, %struct.Memory* %memory)
  store i8* @data_13b5, i8** @RIP_2472_217d9a60, align 8
  call void @abort() #13
  unreachable
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_10e0_main(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_10e0:
  %0 = load i64, i64* @R15_2456_217d25b8, align 8
  %1 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %2 = add i64 %1, -8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3, align 8
  store i64 24, i64* @RCX_2248_217d25b8, align 8, !tbaa !1290
  store i64 1, i64* @RSI_2280_217d25b8, align 8, !tbaa !1290
  %4 = load i64, i64* @R14_2440_217d25b8, align 8
  %5 = add i64 %2, -8
  %6 = getelementptr i64, i64* %3, i32 -1
  store i64 %4, i64* %6, align 8
  %7 = load i64, i64* @R13_2424_217d25b8, align 8
  %8 = add i64 %5, -8
  %9 = getelementptr i64, i64* %6, i32 -1
  store i64 %7, i64* %9, align 8
  %10 = load i64, i64* @R12_2408_217d25b8, align 8
  %11 = add i64 %8, -8
  %12 = getelementptr i64, i64* %9, i32 -1
  store i64 %10, i64* %12, align 8
  %13 = load i64, i64* @RBP_2328_217d25b8, align 8
  %14 = add i64 %11, -8
  %15 = getelementptr i64, i64* %12, i32 -1
  store i64 %13, i64* %15, align 8
  %16 = load i64, i64* @RBX_2232_217d25b8, align 8
  %17 = add i64 %14, -8
  %18 = getelementptr i64, i64* %15, i32 -1
  store i64 %16, i64* %18, align 8
  %19 = sub i64 %17, 280
  %20 = inttoptr i64 %19 to i64*
  store i64 %19, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %21 = load i64, i64* @FSBASE_2168_217d25b8, align 8
  %22 = add i64 %21, 40
  %23 = inttoptr i64 %22 to i64*
  %24 = load i64, i64* %23, align 8
  %25 = getelementptr i64, i64* %20, i32 33
  store i64 %24, i64* %25, align 8
  store i64 0, i64* @RAX_2216_217d25b8, align 8, !tbaa !1290
  store i8 0, i8* @CF_2065_217d2570, align 1, !tbaa !1294
  store i8 1, i8* @PF_2067_217d2570, align 1, !tbaa !1309
  store i8 1, i8* @ZF_2071_217d2570, align 1, !tbaa !1310
  store i8 0, i8* @SF_2073_217d2570, align 1, !tbaa !1311
  store i8 0, i8* @OF_2077_217d2570, align 1, !tbaa !1312
  store i8 0, i8* @AF_2069_217d2570, align 1, !tbaa !1313
  %26 = add i64 %19, 64
  store i64 %26, i64* @R13_2424_217d25b8, align 8, !tbaa !1290
  store i64 %26, i64* @RDI_2296_217d25b8, align 8, !tbaa !1290
  %27 = load i8, i8* @DF_2075_217d2570, align 1, !tbaa !1315
  %28 = icmp eq i8 %27, 0
  %29 = select i1 %28, i64 8, i64 -8
  %30 = load i64*, i64** @RDI_2296_217d9bc0, align 8
  %31 = mul i64 %29, 24
  br label %while.body.i

while.body.i:                                     ; preds = %while.body.i, %inst_10e0
  %32 = phi i64* [ %30, %inst_10e0 ], [ %38, %while.body.i ]
  %33 = phi i64 [ %26, %inst_10e0 ], [ %35, %while.body.i ]
  %34 = phi i64 [ 24, %inst_10e0 ], [ %36, %while.body.i ]
  store i64 0, i64* %32, align 8
  %35 = add i64 %29, %33
  %36 = add i64 %34, -1
  %37 = icmp eq i64 %36, 0
  %38 = inttoptr i64 %35 to i64*
  br i1 %37, label %while.cond.while.end_crit_edge.i, label %while.body.i

while.cond.while.end_crit_edge.i:                 ; preds = %while.body.i
  %39 = add i64 %26, %31
  store i64 %39, i64* @RDI_2296_217d25b8, align 8, !tbaa !1314
  store i64 0, i64* @RCX_2248_217d25b8, align 8, !tbaa !1290
  %40 = inttoptr i64 %19 to i32*
  %41 = getelementptr i32, i32* %40, i32 23
  store i32 1, i32* %41, align 4
  store i64 4294967297, i64* @RAX_2216_217d25b8, align 8, !tbaa !1290
  %42 = bitcast i64* %20 to i8*
  %43 = getelementptr i8, i8* %42, i32 68
  %44 = bitcast i8* %43 to i64*
  store i64 4294967297, i64* %44, align 8
  %45 = getelementptr i64, i64* %20, i32 13
  store i64 4294967297, i64* %45, align 8
  %46 = getelementptr i32, i32* %40, i32 30
  store i32 1, i32* %46, align 4
  %47 = getelementptr i32, i32* %40, i32 35
  store i32 1, i32* %47, align 4
  %48 = getelementptr i32, i32* %40, i32 38
  store i32 1, i32* %48, align 4
  %49 = load i32*, i32** @RDI_2296_217df140, align 8
  store i32 0, i32* %49, align 4
  store i64 28, i64* @RDI_2296_217d25b8, align 8, !tbaa !1290
  %50 = getelementptr i32, i32* %40, i32 45
  store i32 1, i32* %50, align 4
  %51 = getelementptr i32, i32* %40, i32 49
  store i32 1, i32* %51, align 4
  %52 = getelementptr i32, i32* %40, i32 53
  store i32 1, i32* %52, align 4
  %53 = getelementptr i32, i32* %40, i32 55
  store i32 1, i32* %53, align 4
  %54 = getelementptr i32, i32* %40, i32 57
  store i32 1, i32* %54, align 4
  %55 = getelementptr i32, i32* %40, i32 63
  store i32 1, i32* %55, align 4
  %56 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %57 = add i64 %56, -8
  %58 = inttoptr i64 %57 to i64*
  store i64 ptrtoint (i8* @data_11a9 to i64), i64* %58, align 8
  store i64 %57, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %59 = call %struct.Memory* @ext_10b0__calloc(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  store i64 1, i64* @RSI_2280_217d25b8, align 8, !tbaa !1290
  store i64 56, i64* @RDI_2296_217d25b8, align 8, !tbaa !1290
  %60 = load i64, i64* @RAX_2216_217d25b8, align 8
  store i64 %60, i64* @R14_2440_217d25b8, align 8, !tbaa !1290
  %61 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %62 = add i64 %61, -8
  %63 = inttoptr i64 %62 to i64*
  store i64 ptrtoint (i8* @data_11bb to i64), i64* %63, align 8
  store i64 %62, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %64 = call %struct.Memory* @ext_10b0__calloc(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %59)
  store i64 56, i64* @RDI_2296_217d25b8, align 8, !tbaa !1290
  %65 = load i64, i64* @RAX_2216_217d25b8, align 8
  store i64 %65, i64* @R15_2456_217d25b8, align 8, !tbaa !1290
  %66 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %67 = add i64 %66, -8
  %68 = inttoptr i64 %67 to i64*
  store i64 ptrtoint (i8* @data_11c8 to i64), i64* %68, align 8
  store i64 %67, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %69 = call %struct.Memory* @ext_10c0__malloc(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %64)
  %70 = load i32*, i32** @R14_2440_217df140, align 8
  %71 = load i64, i64* @R14_2440_217d25b8, align 8
  %72 = icmp eq i64 %71, 0
  %73 = zext i1 %72 to i8
  %74 = load i64*, i64** @RAX_2216_217d9bc0, align 8
  %75 = load i64, i64* @RAX_2216_217d25b8, align 8
  store i64 %75, i64* @R12_2408_217d25b8, align 8, !tbaa !1290
  %76 = load i64, i64* @R15_2456_217d25b8, align 8
  %77 = icmp eq i64 %76, 0
  %78 = zext i1 %77 to i8
  store i8 %78, i8* @RDX_2264_217d2570, align 1, !tbaa !1314
  %79 = zext i8 %73 to i64
  %80 = zext i8 %78 to i64
  %81 = or i64 %80, %79
  %82 = trunc i64 %81 to i8
  store i8 %82, i8* @RAX_2216_217d2570, align 1, !tbaa !1314
  store i8 0, i8* @CF_2065_217d2570, align 1, !tbaa !1294
  %83 = trunc i64 %81 to i32
  %84 = and i32 %83, 255
  %85 = call i32 @llvm.ctpop.i32(i32 %84) #13, !range !1308
  %86 = trunc i32 %85 to i8
  %87 = and i8 %86, 1
  %88 = xor i8 %87, 1
  store i8 %88, i8* @PF_2067_217d2570, align 1, !tbaa !1309
  %89 = icmp eq i8 %82, 0
  %90 = zext i1 %89 to i8
  store i8 %90, i8* @ZF_2071_217d2570, align 1, !tbaa !1310
  store i8 0, i8* @SF_2073_217d2570, align 1, !tbaa !1311
  store i8 0, i8* @OF_2077_217d2570, align 1, !tbaa !1312
  store i8 0, i8* @AF_2069_217d2570, align 1, !tbaa !1313
  %91 = icmp eq i8 %90, 0
  %92 = select i1 %91, i64 ptrtoint (i8* @data_134c to i64), i64 ptrtoint (i8* @data_11df to i64)
  br i1 %91, label %inst_134c, label %inst_11df

inst_1210:                                        ; preds = %inst_11e8, %inst_125e
  %93 = load i64, i64* @RSI_2280_217d25b8, align 8
  %94 = mul i64 %93, 8
  store i64 %94, i64* @RCX_2248_217d25b8, align 8, !tbaa !1290
  %95 = add i64 %94, %76
  store i64 %95, i64* @RDI_2296_217d25b8, align 8, !tbaa !1290
  %96 = inttoptr i64 %95 to i64*
  %97 = load i64, i64* %96, align 8
  store i64 %97, i64* @RAX_2216_217d25b8, align 8, !tbaa !1290
  %98 = sub i64 %97, 6
  %99 = icmp ult i64 %97, 6
  %100 = zext i1 %99 to i8
  %101 = icmp eq i64 %98, 0
  %102 = zext i1 %101 to i8
  %103 = or i8 %102, %100
  %104 = icmp eq i8 %103, 0
  br i1 %104, label %inst_1265, label %inst_1225

inst_1292:                                        ; preds = %inst_1270, %inst_1255
  %105 = phi i64 [ %199, %inst_1255 ], [ %356, %inst_1270 ]
  %106 = add i64 %105, 3
  store i64 %71, i64* @RDI_2296_217d25b8, align 8, !tbaa !1290
  %107 = add i64 %106, 5
  %108 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %109 = add i64 %108, -8
  %110 = inttoptr i64 %109 to i64*
  store i64 %107, i64* %110, align 8
  store i64 %109, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %111 = call %struct.Memory* @ext_1090__free(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %69)
  %112 = load i64, i64* @R15_2456_217d25b8, align 8
  store i64 %112, i64* @RDI_2296_217d25b8, align 8, !tbaa !1290
  %113 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %114 = add i64 %113, -8
  %115 = inttoptr i64 %114 to i64*
  store i64 ptrtoint (i8* @data_12a2 to i64), i64* %115, align 8
  store i64 %114, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %116 = call %struct.Memory* @ext_1090__free(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %111)
  %117 = load i64, i64* @R12_2408_217d25b8, align 8
  store i64 %117, i64* @RDI_2296_217d25b8, align 8, !tbaa !1290
  %118 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %119 = add i64 %118, -8
  %120 = inttoptr i64 %119 to i64*
  store i64 ptrtoint (i8* @data_12aa to i64), i64* %120, align 8
  store i64 %119, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %121 = call %struct.Memory* @ext_1090__free(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %116)
  store i64 0, i64* @RDX_2264_217d25b8, align 8, !tbaa !1290
  store i64 0, i64* @RAX_2216_217d25b8, align 8, !tbaa !1290
  store i8 0, i8* @CF_2065_217d2570, align 1, !tbaa !1294
  store i8 1, i8* @PF_2067_217d2570, align 1, !tbaa !1309
  store i8 1, i8* @ZF_2071_217d2570, align 1, !tbaa !1310
  store i8 0, i8* @SF_2073_217d2570, align 1, !tbaa !1311
  store i8 0, i8* @OF_2077_217d2570, align 1, !tbaa !1312
  store i8 0, i8* @AF_2069_217d2570, align 1, !tbaa !1313
  store i8* @data_2004, i8** @RSI_2280_217d9a60, align 8
  store i64 1, i64* @RDI_2296_217d25b8, align 8, !tbaa !1290
  %122 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %123 = add i64 %122, -8
  %124 = inttoptr i64 %123 to i64*
  store i64 ptrtoint (i8* @data_12bf to i64), i64* %124, align 8
  store i64 %123, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %125 = call %struct.Memory* @ext_10d0____printf_chk(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %121)
  %126 = load i64, i64* @RBP_2328_217d25b8, align 8
  %127 = icmp eq i64 %126, 0
  %128 = zext i1 %127 to i8
  %129 = icmp eq i8 %128, 0
  %130 = select i1 %129, i64 ptrtoint (i8* @data_12c4 to i64), i64 ptrtoint (i8* @data_12f9 to i64)
  br i1 %127, label %inst_12f9, label %inst_12c4

inst_1238:                                        ; preds = %inst_1225, %inst_1247
  %131 = phi i64 [ %312, %inst_1225 ], [ %159, %inst_1247 ]
  %132 = add i64 %131, 4
  %133 = load i64, i64* @RAX_2216_217d25b8, align 8
  %134 = mul i64 %133, 4
  %135 = add i64 %134, %311
  %136 = inttoptr i64 %135 to i32*
  %137 = load i32, i32* %136, align 4
  %138 = zext i32 %137 to i64
  store i64 %138, i64* @R8_2344_217d25b8, align 8, !tbaa !1290
  %139 = add i64 %132, 3
  %140 = icmp eq i32 %137, 0
  %141 = zext i1 %140 to i8
  %142 = add i64 %139, 2
  %143 = add i64 %142, 6
  %144 = icmp eq i8 %141, 0
  %145 = select i1 %144, i64 %142, i64 %143
  br i1 %140, label %inst_1247, label %inst_1241

inst_1247:                                        ; preds = %inst_1241, %inst_1238
  %146 = phi i64 [ %145, %inst_1238 ], [ %323, %inst_1241 ]
  %147 = add i64 %146, 4
  %148 = add i64 1, %133
  store i64 %148, i64* @RAX_2216_217d25b8, align 8, !tbaa !1290
  %149 = add i64 %147, 4
  %150 = load i64, i64* @RDX_2264_217d25b8, align 8
  %151 = add i64 4, %150
  store i64 %151, i64* @RDX_2264_217d25b8, align 8, !tbaa !1290
  %152 = add i64 %149, 4
  %153 = sub i64 %148, 7
  %154 = icmp eq i64 %153, 0
  %155 = zext i1 %154 to i8
  %156 = add i64 %152, 2
  %157 = sub i64 %156, 29
  %158 = icmp eq i8 %155, 0
  %159 = select i1 %158, i64 %157, i64 %156
  br i1 %158, label %inst_1238, label %inst_1255

inst_134c:                                        ; preds = %inst_11df, %while.cond.while.end_crit_edge.i
  %160 = phi i64 [ %92, %while.cond.while.end_crit_edge.i ], [ %284, %inst_11df ]
  %161 = add i64 %160, 3
  store i64 %71, i64* @RDI_2296_217d25b8, align 8, !tbaa !1290
  %162 = add i64 %161, 5
  %163 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %164 = add i64 %163, -8
  %165 = inttoptr i64 %164 to i64*
  store i64 %162, i64* %165, align 8
  store i64 %164, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %166 = call %struct.Memory* @ext_1090__free(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %69)
  %167 = load i64, i64* @R15_2456_217d25b8, align 8
  store i64 %167, i64* @RDI_2296_217d25b8, align 8, !tbaa !1290
  %168 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %169 = add i64 %168, -8
  %170 = inttoptr i64 %169 to i64*
  store i64 ptrtoint (i8* @data_135c to i64), i64* %170, align 8
  store i64 %169, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %171 = call %struct.Memory* @ext_1090__free(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %166)
  %172 = load i64, i64* @R12_2408_217d25b8, align 8
  store i64 %172, i64* @RDI_2296_217d25b8, align 8, !tbaa !1290
  %173 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %174 = add i64 %173, -8
  %175 = inttoptr i64 %174 to i64*
  store i64 ptrtoint (i8* @data_1364 to i64), i64* %175, align 8
  store i64 %174, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %176 = call %struct.Memory* @ext_1090__free(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %171)
  store i64 0, i64* @RDX_2264_217d25b8, align 8, !tbaa !1290
  store i8* @data_2004, i8** @RSI_2280_217d9a60, align 8
  store i64 0, i64* @RAX_2216_217d25b8, align 8, !tbaa !1290
  store i8 0, i8* @CF_2065_217d2570, align 1, !tbaa !1294
  store i8 1, i8* @PF_2067_217d2570, align 1, !tbaa !1309
  store i8 1, i8* @ZF_2071_217d2570, align 1, !tbaa !1310
  store i8 0, i8* @SF_2073_217d2570, align 1, !tbaa !1311
  store i8 0, i8* @OF_2077_217d2570, align 1, !tbaa !1312
  store i8 0, i8* @AF_2069_217d2570, align 1, !tbaa !1313
  store i64 1, i64* @RDI_2296_217d25b8, align 8, !tbaa !1290
  %177 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %178 = add i64 %177, -8
  %179 = inttoptr i64 %178 to i64*
  store i64 ptrtoint (i8* @data_1379 to i64), i64* %179, align 8
  store i64 %178, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %180 = call %struct.Memory* @ext_10d0____printf_chk(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %176)
  br label %inst_12f9

inst_1255:                                        ; preds = %inst_1265, %inst_1247
  %181 = phi i64 [ %159, %inst_1247 ], [ undef, %inst_1265 ]
  %182 = add i64 %181, 4
  %183 = load i64, i64* @RBX_2232_217d25b8, align 8
  %184 = sub i64 %183, 1
  store i64 %184, i64* @RBX_2232_217d25b8, align 8, !tbaa !1290
  %185 = trunc i64 %184 to i32
  %186 = and i32 %185, 255
  %187 = call i32 @llvm.ctpop.i32(i32 %186) #13, !range !1308
  %188 = trunc i32 %187 to i8
  %189 = and i8 %188, 1
  %190 = xor i8 %189, 1
  %191 = icmp eq i64 %184, 0
  %192 = zext i1 %191 to i8
  %193 = lshr i64 %184, 63
  %194 = trunc i64 %193 to i8
  %195 = add i64 %182, 3
  store i8 0, i8* @CF_2065_217d2570, align 1, !tbaa !1294
  store i8 %190, i8* @PF_2067_217d2570, align 1, !tbaa !1309
  store i8 %192, i8* @ZF_2071_217d2570, align 1, !tbaa !1310
  store i8 %194, i8* @SF_2073_217d2570, align 1, !tbaa !1311
  store i8 0, i8* @OF_2077_217d2570, align 1, !tbaa !1312
  store i8 0, i8* @AF_2069_217d2570, align 1, !tbaa !1313
  %196 = add i64 %195, 2
  %197 = add i64 %196, 52
  %198 = icmp eq i8 %192, 0
  %199 = select i1 %198, i64 %196, i64 %197
  br i1 %191, label %inst_1292, label %inst_125e

inst_12d5:                                        ; preds = %inst_1338, %inst_12c4
  %200 = phi %struct.Memory* [ %125, %inst_12c4 ], [ %371, %inst_1338 ]
  %201 = add i64 %360, 4
  %202 = load i64, i64* @RBX_2232_217d25b8, align 8
  %203 = add i64 1, %202
  store i64 %203, i64* @RBX_2232_217d25b8, align 8, !tbaa !1290
  %204 = add i64 %201, 5
  %205 = load i64, i64* @R12_2408_217d25b8, align 8
  %206 = mul i64 %203, 8
  %207 = add i64 %205, -8
  %208 = add i64 %207, %206
  %209 = inttoptr i64 %208 to i64*
  %210 = load i64, i64* %209, align 8
  store i64 %210, i64* @RDX_2264_217d25b8, align 8, !tbaa !1290
  %211 = add i64 %204, 3
  %212 = load i64, i64* @RBP_2328_217d25b8, align 8
  %213 = sub i64 %203, %212
  %214 = icmp eq i64 %213, 0
  %215 = zext i1 %214 to i8
  %216 = add i64 %211, 2
  %217 = add i64 %216, 85
  %218 = icmp eq i8 %215, 0
  %219 = select i1 %218, i64 %217, i64 %216
  br i1 %218, label %inst_1338, label %inst_12e3

inst_125e:                                        ; preds = %inst_1270, %inst_1265, %inst_1255
  %220 = load i64, i64* @RBX_2232_217d25b8, align 8
  %221 = mul i64 %220, 8
  %222 = add i64 %75, -8
  %223 = add i64 %222, %221
  %224 = inttoptr i64 %223 to i64*
  %225 = load i64, i64* %224, align 8
  store i64 %225, i64* @RSI_2280_217d25b8, align 8, !tbaa !1290
  br label %inst_1210

inst_12f9:                                        ; preds = %inst_12e3, %inst_134c, %inst_1292
  %226 = phi i64 [ undef, %inst_134c ], [ %130, %inst_1292 ], [ ptrtoint (i8* @data_12f9 to i64), %inst_12e3 ]
  %227 = phi %struct.Memory* [ %180, %inst_134c ], [ %125, %inst_1292 ], [ %381, %inst_12e3 ]
  %228 = add i64 %226, 2
  store i64 0, i64* @RAX_2216_217d25b8, align 8, !tbaa !1290
  store i8 0, i8* @CF_2065_217d2570, align 1, !tbaa !1294
  store i8 1, i8* @PF_2067_217d2570, align 1, !tbaa !1309
  store i8 1, i8* @ZF_2071_217d2570, align 1, !tbaa !1310
  store i8 0, i8* @SF_2073_217d2570, align 1, !tbaa !1311
  store i8 0, i8* @OF_2077_217d2570, align 1, !tbaa !1312
  store i8 0, i8* @AF_2069_217d2570, align 1, !tbaa !1313
  %229 = add i64 %228, 7
  store i8* @data_201c, i8** @RSI_2280_217d9a60, align 8
  %230 = add i64 %229, 5
  store i64 1, i64* @RDI_2296_217d25b8, align 8, !tbaa !1290
  %231 = add i64 %230, 5
  %232 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %233 = add i64 %232, -8
  %234 = inttoptr i64 %233 to i64*
  store i64 %231, i64* %234, align 8
  store i64 %233, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %235 = call %struct.Memory* @ext_10d0____printf_chk(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %227)
  %236 = load i64*, i64** @RSP_2312_217d9bc0, align 8
  %237 = load i64, i64* @RSP_2312_217d25b8, align 8
  %238 = getelementptr i64, i64* %236, i32 33
  %239 = load i64, i64* %238, align 8
  %240 = load i64, i64* @FSBASE_2168_217d25b8, align 8
  %241 = add i64 %240, 40
  %242 = inttoptr i64 %241 to i64*
  %243 = load i64, i64* %242, align 8
  %244 = sub i64 %239, %243
  store i64 %244, i64* @RAX_2216_217d25b8, align 8, !tbaa !1290
  %245 = icmp ugt i64 %243, %239
  %246 = zext i1 %245 to i8
  store i8 %246, i8* @CF_2065_217d2570, align 1, !tbaa !1294
  %247 = trunc i64 %244 to i32
  %248 = and i32 %247, 255
  %249 = call i32 @llvm.ctpop.i32(i32 %248) #13, !range !1308
  %250 = trunc i32 %249 to i8
  %251 = and i8 %250, 1
  %252 = xor i8 %251, 1
  store i8 %252, i8* @PF_2067_217d2570, align 1, !tbaa !1309
  %253 = xor i64 %243, %239
  %254 = xor i64 %253, %244
  %255 = lshr i64 %254, 4
  %256 = trunc i64 %255 to i8
  %257 = and i8 %256, 1
  store i8 %257, i8* @AF_2069_217d2570, align 1, !tbaa !1313
  %258 = icmp eq i64 %244, 0
  %259 = zext i1 %258 to i8
  store i8 %259, i8* @ZF_2071_217d2570, align 1, !tbaa !1310
  %260 = lshr i64 %244, 63
  %261 = trunc i64 %260 to i8
  store i8 %261, i8* @SF_2073_217d2570, align 1, !tbaa !1311
  %262 = lshr i64 %239, 63
  %263 = lshr i64 %243, 63
  %264 = xor i64 %263, %262
  %265 = xor i64 %260, %262
  %266 = add nuw nsw i64 %265, %264
  %267 = icmp eq i64 %266, 2
  %268 = zext i1 %267 to i8
  store i8 %268, i8* @OF_2077_217d2570, align 1, !tbaa !1312
  %269 = icmp eq i8 %259, 0
  br i1 %269, label %inst_137e, label %inst_131f

inst_11df:                                        ; preds = %while.cond.while.end_crit_edge.i
  %270 = add i64 %92, 3
  store i8 0, i8* @CF_2065_217d2570, align 1, !tbaa !1294
  %271 = trunc i64 %75 to i32
  %272 = and i32 %271, 255
  %273 = call i32 @llvm.ctpop.i32(i32 %272) #13, !range !1308
  %274 = trunc i32 %273 to i8
  %275 = and i8 %274, 1
  %276 = xor i8 %275, 1
  store i8 %276, i8* @PF_2067_217d2570, align 1, !tbaa !1309
  %277 = icmp eq i64 %75, 0
  %278 = zext i1 %277 to i8
  store i8 %278, i8* @ZF_2071_217d2570, align 1, !tbaa !1310
  %279 = lshr i64 %75, 63
  %280 = trunc i64 %279 to i8
  store i8 %280, i8* @SF_2073_217d2570, align 1, !tbaa !1311
  store i8 0, i8* @OF_2077_217d2570, align 1, !tbaa !1312
  store i8 0, i8* @AF_2069_217d2570, align 1, !tbaa !1313
  %281 = add i64 %270, 6
  %282 = add i64 %281, 356
  %283 = icmp eq i8 %278, 0
  %284 = select i1 %283, i64 %281, i64 %282
  br i1 %277, label %inst_134c, label %inst_11e8

inst_11e8:                                        ; preds = %inst_11df
  %285 = add i64 %284, 8
  store i64 0, i64* %74, align 8
  %286 = add i64 %285, 2
  store i64 0, i64* @RSI_2280_217d25b8, align 8, !tbaa !1290
  %287 = add i64 %286, 5
  store i64 1, i64* @RBP_2328_217d25b8, align 8, !tbaa !1290
  %288 = add i64 %287, 5
  store i64 1, i64* @RBX_2232_217d25b8, align 8, !tbaa !1290
  %289 = add i64 %288, 7
  store i32 1, i32* %70, align 4
  %290 = add i64 %289, 8
  %291 = load i64*, i64** @RSP_2312_217d9bc0, align 8
  %292 = load i64, i64* @RSP_2312_217d25b8, align 8
  store i64 0, i64* %291, align 8
  %293 = add i64 %290, 5
  br label %inst_1210

inst_1265:                                        ; preds = %inst_1210
  %294 = sub i64 %97, 7
  %295 = icmp eq i64 %294, 0
  %296 = zext i1 %295 to i8
  %297 = icmp eq i8 %296, 0
  br i1 %297, label %inst_125e, label %inst_1255

inst_1225:                                        ; preds = %inst_1210
  %298 = add i64 %293, 8
  %299 = add i64 %298, 4
  %300 = add i64 %299, 3
  %301 = add i64 %300, 4
  %302 = add i64 %301, 2
  %303 = add i64 %302, 3
  %304 = sub i64 %94, %93
  %305 = add i64 %303, 4
  %306 = mul i64 %97, 4
  %307 = add i64 %306, %71
  store i64 %307, i64* @RDX_2264_217d25b8, align 8, !tbaa !1290
  %308 = add i64 %305, 5
  %309 = load i64, i64* @R13_2424_217d25b8, align 8
  %310 = mul i64 %304, 4
  %311 = add i64 %310, %309
  store i64 %311, i64* @RCX_2248_217d25b8, align 8, !tbaa !1290
  %312 = add i64 %308, 7
  br label %inst_1238

inst_1241:                                        ; preds = %inst_1238
  %313 = add i64 %145, 2
  %314 = load i32*, i32** @RDX_2264_217df140, align 8
  %315 = load i32, i32* %314, align 4
  %316 = zext i32 %315 to i64
  store i64 %316, i64* @RSI_2280_217d25b8, align 8, !tbaa !1290
  %317 = add i64 %313, 2
  %318 = icmp eq i32 %315, 0
  %319 = zext i1 %318 to i8
  %320 = add i64 %317, 2
  %321 = add i64 %320, 41
  %322 = icmp eq i8 %319, 0
  %323 = select i1 %322, i64 %320, i64 %321
  br i1 %318, label %inst_1270, label %inst_1247

inst_1270:                                        ; preds = %inst_1241
  %324 = add i64 %323, 4
  %325 = load i64, i64* @RBX_2232_217d25b8, align 8
  %326 = mul i64 %325, 8
  %327 = add i64 %326, %75
  %328 = inttoptr i64 %327 to i64*
  store i64 %133, i64* %328, align 8
  %329 = add i64 %324, 4
  %330 = add i64 %133, 1
  store i64 %330, i64* @RCX_2248_217d25b8, align 8, !tbaa !1290
  %331 = add i64 %329, 4
  %332 = add i64 1, %325
  store i64 %332, i64* @RBX_2232_217d25b8, align 8, !tbaa !1290
  %333 = trunc i64 %332 to i32
  %334 = and i32 %333, 255
  %335 = call i32 @llvm.ctpop.i32(i32 %334) #13, !range !1308
  %336 = trunc i32 %335 to i8
  %337 = and i8 %336, 1
  %338 = xor i8 %337, 1
  %339 = icmp eq i64 %332, 0
  %340 = zext i1 %339 to i8
  %341 = lshr i64 %332, 63
  %342 = trunc i64 %341 to i8
  %343 = add i64 %331, 4
  %344 = load i64, i64* @RBP_2328_217d25b8, align 8
  %345 = mul i64 %344, 8
  %346 = add i64 %345, %292
  %347 = inttoptr i64 %346 to i64*
  store i64 %133, i64* %347, align 8
  %348 = add i64 %343, 4
  %349 = add i64 1, %344
  store i64 %349, i64* @RBP_2328_217d25b8, align 8, !tbaa !1290
  %350 = add i64 %348, 3
  store i64 %330, i64* %96, align 8
  %351 = add i64 %350, 6
  store i32 1, i32* %314, align 4
  %352 = add i64 %351, 3
  store i8 0, i8* @CF_2065_217d2570, align 1, !tbaa !1294
  store i8 %338, i8* @PF_2067_217d2570, align 1, !tbaa !1309
  store i8 %340, i8* @ZF_2071_217d2570, align 1, !tbaa !1310
  store i8 %342, i8* @SF_2073_217d2570, align 1, !tbaa !1311
  store i8 0, i8* @OF_2077_217d2570, align 1, !tbaa !1312
  store i8 0, i8* @AF_2069_217d2570, align 1, !tbaa !1313
  %353 = add i64 %352, 2
  %354 = sub i64 %353, 52
  %355 = icmp eq i8 %340, 0
  %356 = select i1 %355, i64 %354, i64 %353
  br i1 %355, label %inst_125e, label %inst_1292

inst_12c4:                                        ; preds = %inst_1292
  %357 = add i64 %130, 3
  %358 = load i64, i64* @RSP_2312_217d25b8, align 8
  store i64 %358, i64* @R12_2408_217d25b8, align 8, !tbaa !1290
  %359 = add i64 %357, 7
  store i8* @data_201e, i8** @R13_2424_217d9a60, align 8
  %360 = add i64 %359, 7
  store i8* @data_201a, i8** @R14_2440_217d9a60, align 8
  br label %inst_12d5

inst_1338:                                        ; preds = %inst_12d5
  %361 = add i64 %219, 3
  %362 = load i64, i64* @R14_2440_217d25b8, align 8
  store i64 %362, i64* @RCX_2248_217d25b8, align 8, !tbaa !1290
  %363 = add i64 %361, 3
  %364 = load i64, i64* @R13_2424_217d25b8, align 8
  store i64 %364, i64* @RSI_2280_217d25b8, align 8, !tbaa !1290
  %365 = add i64 %363, 5
  store i64 1, i64* @RDI_2296_217d25b8, align 8, !tbaa !1290
  %366 = add i64 %365, 2
  store i64 0, i64* @RAX_2216_217d25b8, align 8, !tbaa !1290
  store i8 0, i8* @CF_2065_217d2570, align 1, !tbaa !1294
  store i8 1, i8* @PF_2067_217d2570, align 1, !tbaa !1309
  store i8 1, i8* @ZF_2071_217d2570, align 1, !tbaa !1310
  store i8 0, i8* @SF_2073_217d2570, align 1, !tbaa !1311
  store i8 0, i8* @OF_2077_217d2570, align 1, !tbaa !1312
  store i8 0, i8* @AF_2069_217d2570, align 1, !tbaa !1313
  %367 = add i64 %366, 5
  %368 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %369 = add i64 %368, -8
  %370 = inttoptr i64 %369 to i64*
  store i64 %367, i64* %370, align 8
  store i64 %369, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %371 = call %struct.Memory* @ext_10d0____printf_chk(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %200)
  br label %inst_12d5

inst_12e3:                                        ; preds = %inst_12d5
  %372 = add i64 %219, 7
  store i8* @data_201d, i8** @RCX_2248_217d9a60, align 8
  %373 = add i64 %372, 3
  %374 = load i64, i64* @R13_2424_217d25b8, align 8
  store i64 %374, i64* @RSI_2280_217d25b8, align 8, !tbaa !1290
  %375 = add i64 %373, 5
  store i64 1, i64* @RDI_2296_217d25b8, align 8, !tbaa !1290
  %376 = add i64 %375, 2
  store i64 0, i64* @RAX_2216_217d25b8, align 8, !tbaa !1290
  store i8 0, i8* @CF_2065_217d2570, align 1, !tbaa !1294
  store i8 1, i8* @PF_2067_217d2570, align 1, !tbaa !1309
  store i8 1, i8* @ZF_2071_217d2570, align 1, !tbaa !1310
  store i8 0, i8* @SF_2073_217d2570, align 1, !tbaa !1311
  store i8 0, i8* @OF_2077_217d2570, align 1, !tbaa !1312
  store i8 0, i8* @AF_2069_217d2570, align 1, !tbaa !1313
  %377 = add i64 %376, 5
  %378 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %379 = add i64 %378, -8
  %380 = inttoptr i64 %379 to i64*
  store i64 %377, i64* %380, align 8
  store i64 %379, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %381 = call %struct.Memory* @ext_10d0____printf_chk(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %200)
  br label %inst_12f9

inst_137e:                                        ; preds = %inst_12f9
  %382 = add i64 %237, -8
  %383 = inttoptr i64 %382 to i64*
  store i64 add (i64 ptrtoint (i8* @data_137e to i64), i64 5), i64* %383, align 8
  store i64 %382, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %384 = call %struct.Memory* @ext_10a0____stack_chk_fail(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %235)
  ret %struct.Memory* %384

inst_131f:                                        ; preds = %inst_12f9
  %385 = add i64 280, %237
  %386 = getelementptr i64, i64* %236, i32 35
  store i64 0, i64* @RAX_2216_217d25b8, align 8, !tbaa !1290
  store i8 0, i8* @CF_2065_217d2570, align 1, !tbaa !1294
  store i8 1, i8* @PF_2067_217d2570, align 1, !tbaa !1309
  store i8 1, i8* @ZF_2071_217d2570, align 1, !tbaa !1310
  store i8 0, i8* @SF_2073_217d2570, align 1, !tbaa !1311
  store i8 0, i8* @OF_2077_217d2570, align 1, !tbaa !1312
  store i8 0, i8* @AF_2069_217d2570, align 1, !tbaa !1313
  %387 = add i64 %385, 8
  %388 = getelementptr i64, i64* %386, i32 1
  %389 = load i64, i64* %386, align 8
  store i64 %389, i64* @RBX_2232_217d25b8, align 8, !tbaa !1290
  %390 = add i64 %387, 8
  %391 = getelementptr i64, i64* %388, i32 1
  %392 = load i64, i64* %388, align 8
  store i64 %392, i64* @RBP_2328_217d25b8, align 8, !tbaa !1290
  %393 = add i64 %390, 8
  %394 = getelementptr i64, i64* %391, i32 1
  %395 = load i64, i64* %391, align 8
  store i64 %395, i64* @R12_2408_217d25b8, align 8, !tbaa !1290
  %396 = add i64 %393, 8
  %397 = getelementptr i64, i64* %394, i32 1
  %398 = load i64, i64* %394, align 8
  store i64 %398, i64* @R13_2424_217d25b8, align 8, !tbaa !1290
  %399 = add i64 %396, 8
  %400 = load i64, i64* %397, align 8
  store i64 %400, i64* @R14_2440_217d25b8, align 8, !tbaa !1290
  %401 = add i64 %399, 8
  %402 = getelementptr i64, i64* %397, i32 1
  %403 = load i64, i64* %402, align 8
  store i64 %403, i64* @R15_2456_217d25b8, align 8, !tbaa !1290
  %404 = add i64 %401, 8
  store i64 %404, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  ret %struct.Memory* %235
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_13c0_deregister_tm_clones(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_13c0:
  store i8* @data_4010, i8** @RDI_2296_217d9a60, align 8
  store i8* @data_4010, i8** @RAX_2216_217d9a60, align 8
  store i8 0, i8* @CF_2065_217d2570, align 1, !tbaa !1294
  store i8 1, i8* @PF_2067_217d2570, align 1, !tbaa !1309
  store i8 0, i8* @AF_2069_217d2570, align 1, !tbaa !1313
  store i8 1, i8* @ZF_2071_217d2570, align 1, !tbaa !1310
  store i8 0, i8* @SF_2073_217d2570, align 1, !tbaa !1311
  store i8 0, i8* @OF_2077_217d2570, align 1, !tbaa !1312
  %0 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %1 = add i64 %0, 8
  store i64 %1, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  ret %struct.Memory* %memory
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_13f0_register_tm_clones(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_13f0:
  store i8* @data_4010, i8** @RDI_2296_217d9a60, align 8
  store i64 0, i64* @RAX_2216_217d25b8, align 8, !tbaa !1290
  store i64 0, i64* @RSI_2280_217d25b8, align 8, !tbaa !1290
  store i8 0, i8* @CF_2065_217d2570, align 1, !tbaa !1314
  store i8 1, i8* @PF_2067_217d2570, align 1, !tbaa !1314
  store i8 0, i8* @AF_2069_217d2570, align 1, !tbaa !1314
  store i8 1, i8* @ZF_2071_217d2570, align 1, !tbaa !1314
  store i8 0, i8* @SF_2073_217d2570, align 1, !tbaa !1314
  store i8 0, i8* @OF_2077_217d2570, align 1, !tbaa !1314
  %0 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %1 = add i64 %0, 8
  store i64 %1, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  ret %struct.Memory* %memory
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1430___do_global_dtors_aux(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1430:
  %0 = load i8, i8* @data_4010, align 1
  store i8 0, i8* @CF_2065_217d2570, align 1, !tbaa !1294
  %1 = zext i8 %0 to i32
  %2 = call i32 @llvm.ctpop.i32(i32 %1) #13, !range !1308
  %3 = trunc i32 %2 to i8
  %4 = and i8 %3, 1
  %5 = xor i8 %4, 1
  store i8 %5, i8* @PF_2067_217d2570, align 1, !tbaa !1309
  store i8 0, i8* @AF_2069_217d2570, align 1, !tbaa !1313
  %6 = icmp eq i8 %0, 0
  %7 = zext i1 %6 to i8
  store i8 %7, i8* @ZF_2071_217d2570, align 1, !tbaa !1310
  %8 = lshr i8 %0, 7
  store i8 %8, i8* @SF_2073_217d2570, align 1, !tbaa !1311
  store i8 0, i8* @OF_2077_217d2570, align 1, !tbaa !1312
  %9 = icmp eq i8 %7, 0
  br i1 %9, label %inst_1468, label %inst_143d

inst_1457:                                        ; preds = %inst_144b, %inst_143d
  %10 = phi i64 [ %40, %inst_143d ], [ ptrtoint (i8* @data_1457 to i64), %inst_144b ]
  %11 = phi %struct.Memory* [ %memory, %inst_143d ], [ %46, %inst_144b ]
  %12 = add i64 %10, 5
  %13 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %14 = add i64 %13, -8
  %15 = inttoptr i64 %14 to i64*
  store i64 %12, i64* %15, align 8
  store i64 %14, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %16 = call %struct.Memory* @sub_13c0_deregister_tm_clones(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %11)
  store i8 1, i8* @data_4010, align 1
  %17 = load i64*, i64** @RSP_2312_217d9bc0, align 8
  %18 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %19 = add i64 %18, 8
  %20 = load i64, i64* %17, align 8
  store i64 %20, i64* @RBP_2328_217d25b8, align 8, !tbaa !1290
  %21 = add i64 %19, 8
  store i64 %21, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  ret %struct.Memory* %16

inst_1468:                                        ; preds = %inst_1430
  %22 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %23 = add i64 %22, 8
  store i64 %23, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  ret %struct.Memory* %memory

inst_143d:                                        ; preds = %inst_1430
  %24 = load i64, i64* @RBP_2328_217d25b8, align 8
  %25 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %26 = add i64 %25, -8
  %27 = inttoptr i64 %26 to i64*
  store i64 %24, i64* %27, align 8
  store i64 %26, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %28 = load i64, i64* bitcast (i8** @data_3ff8 to i64*), align 8
  store i8 0, i8* @CF_2065_217d2570, align 1, !tbaa !1294
  %29 = trunc i64 %28 to i32
  %30 = and i32 %29, 255
  %31 = call i32 @llvm.ctpop.i32(i32 %30) #13, !range !1308
  %32 = trunc i32 %31 to i8
  %33 = and i8 %32, 1
  %34 = xor i8 %33, 1
  store i8 %34, i8* @PF_2067_217d2570, align 1, !tbaa !1309
  store i8 0, i8* @AF_2069_217d2570, align 1, !tbaa !1313
  %35 = icmp eq i64 %28, 0
  %36 = zext i1 %35 to i8
  store i8 %36, i8* @ZF_2071_217d2570, align 1, !tbaa !1310
  %37 = lshr i64 %28, 63
  %38 = trunc i64 %37 to i8
  store i8 %38, i8* @SF_2073_217d2570, align 1, !tbaa !1311
  store i8 0, i8* @OF_2077_217d2570, align 1, !tbaa !1312
  store i64 %26, i64* @RBP_2328_217d25b8, align 8, !tbaa !1290
  %39 = icmp eq i8 %36, 0
  %40 = select i1 %39, i64 add (i64 ptrtoint (i8* @data_143d to i64), i64 14), i64 add (i64 ptrtoint (i8* @data_143d to i64), i64 26)
  br i1 %35, label %inst_1457, label %inst_144b

inst_144b:                                        ; preds = %inst_143d
  %41 = add i64 %40, 7
  %42 = load i64, i64* bitcast (i8** @data_4008 to i64*), align 8
  store i64 %42, i64* @RDI_2296_217d25b8, align 8, !tbaa !1290
  %43 = add i64 %41, 5
  %44 = add i64 %26, -8
  %45 = getelementptr i64, i64* %27, i32 -1
  store i64 %43, i64* %45, align 8
  store i64 %44, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %46 = call %struct.Memory* @ext_1080___cxa_finalize(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  br label %inst_1457
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1070(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1070:
  %0 = load i64, i64* @RSP_2312_217d25b8, align 8, !tbaa !1314
  %1 = add i64 %0, -8
  %2 = inttoptr i64 %1 to i64*
  store i64 4, i64* %2, align 8
  store i64 %1, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  %3 = call %struct.Memory* @sub_1020(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  ret %struct.Memory* %3
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_147c__term_proc(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_147c:
  %0 = load i64, i64* @RSP_2312_217d25b8, align 8
  %1 = sub i64 %0, 8
  %2 = icmp ult i64 %0, 8
  %3 = lshr i64 %1, 63
  %4 = lshr i64 %0, 63
  %5 = xor i64 %3, %4
  %6 = add nuw nsw i64 %5, %4
  %7 = icmp eq i64 %6, 2
  %8 = zext i1 %7 to i8
  %9 = icmp ult i64 %0, %1
  %10 = or i1 %9, %2
  %11 = zext i1 %10 to i8
  store i8 %11, i8* @CF_2065_217d2570, align 1, !tbaa !1294
  %12 = trunc i64 %0 to i32
  %13 = and i32 %12, 255
  %14 = call i32 @llvm.ctpop.i32(i32 %13) #13, !range !1308
  %15 = trunc i32 %14 to i8
  %16 = and i8 %15, 1
  %17 = xor i8 %16, 1
  store i8 %17, i8* @PF_2067_217d2570, align 1, !tbaa !1309
  %18 = xor i64 8, %1
  %19 = xor i64 %18, %0
  %20 = lshr i64 %19, 4
  %21 = trunc i64 %20 to i8
  %22 = and i8 %21, 1
  store i8 %22, i8* @AF_2069_217d2570, align 1, !tbaa !1313
  %23 = icmp eq i64 %0, 0
  %24 = zext i1 %23 to i8
  store i8 %24, i8* @ZF_2071_217d2570, align 1, !tbaa !1310
  %25 = trunc i64 %4 to i8
  store i8 %25, i8* @SF_2073_217d2570, align 1, !tbaa !1311
  store i8 %8, i8* @OF_2077_217d2570, align 1, !tbaa !1312
  %26 = add i64 %0, 8
  store i64 %26, i64* @RSP_2312_217d25b8, align 8, !tbaa !1290
  ret %struct.Memory* %memory
}

; Function Attrs: nobuiltin noinline
declare !remill.function.type !1316 extern_weak x86_64_sysvcc i64 @_ITM_registerTMCloneTable(i64, i64) #11

; Function Attrs: nobuiltin noinline
declare !remill.function.type !1316 extern_weak x86_64_sysvcc i64 @_ITM_deregisterTMCloneTable(i64) #11

; Function Attrs: nobuiltin noinline
declare !remill.function.type !1317 extern_weak x86_64_sysvcc i64 @__cxa_finalize(i64) #11

; Function Attrs: nobuiltin noinline
declare !remill.function.type !1316 extern_weak x86_64_sysvcc i64 @malloc(i64) #11

; Function Attrs: nobuiltin noinline
declare !remill.function.type !1316 extern_weak x86_64_sysvcc i64 @__stack_chk_fail() #11

; Function Attrs: nobuiltin noinline
declare !remill.function.type !1316 extern_weak x86_64_sysvcc i64 @calloc(i64, i64) #11

; Function Attrs: noinline
define internal %struct.Memory* @ext_10d0____printf_chk(%struct.State* %0, i64 %1, %struct.Memory* %2) #12 {
  %4 = call %struct.Memory* @__remill_function_call(%struct.State* @__mcsema_reg_state, i64 ptrtoint (i64 (...)* @.__printf_chk to i64), %struct.Memory* %2)
  ret %struct.Memory* %4
}

; Function Attrs: noinline
declare !remill.function.type !1317 i64 @.__printf_chk(...) #12

; Function Attrs: noinline
declare !remill.function.type !1316 extern_weak x86_64_sysvcc void @__libc_start_main(i32 (i32, i8**, i8**)*, i32, i8**, i8*, i32 (i32, i8**, i8**)*, void ()*, void ()*, i32*) #12

; Function Attrs: noinline
define internal %struct.Memory* @ext_10c0__malloc(%struct.State* %0, i64 %1, %struct.Memory* %2) #12 {
  %4 = call %struct.Memory* @__remill_function_call(%struct.State* @__mcsema_reg_state, i64 ptrtoint (i64 (...)* @.malloc to i64), %struct.Memory* %2)
  ret %struct.Memory* %4
}

; Function Attrs: noinline
declare !remill.function.type !1317 i64 @.malloc(...) #12

; Function Attrs: noinline
define internal %struct.Memory* @ext_10b0__calloc(%struct.State* %0, i64 %1, %struct.Memory* %2) #12 {
  %4 = call %struct.Memory* @__remill_function_call(%struct.State* @__mcsema_reg_state, i64 ptrtoint (i64 (...)* @.calloc to i64), %struct.Memory* %2)
  ret %struct.Memory* %4
}

; Function Attrs: noinline
declare !remill.function.type !1317 i64 @.calloc(...) #12

; Function Attrs: noinline
define internal %struct.Memory* @ext_10a0____stack_chk_fail(%struct.State* %0, i64 %1, %struct.Memory* %2) #12 {
  %4 = call %struct.Memory* @__remill_function_call(%struct.State* @__mcsema_reg_state, i64 ptrtoint (i64 (...)* @.__stack_chk_fail to i64), %struct.Memory* %2)
  ret %struct.Memory* %4
}

; Function Attrs: noinline
declare !remill.function.type !1317 i64 @.__stack_chk_fail(...) #12

; Function Attrs: noinline
define weak x86_64_sysvcc void @__gmon_start__() #12 !remill.function.type !1316 {
  ret void
}

; Function Attrs: noinline
declare !remill.function.type !1316 extern_weak i64 @__printf_chk(...) #12

; Function Attrs: noinline
define internal %struct.Memory* @ext_1090__free(%struct.State* %0, i64 %1, %struct.Memory* %2) #12 {
  %4 = call %struct.Memory* @__remill_function_call(%struct.State* @__mcsema_reg_state, i64 ptrtoint (i64 (...)* @.free to i64), %struct.Memory* %2)
  ret %struct.Memory* %4
}

; Function Attrs: noinline
declare !remill.function.type !1317 i64 @.free(...) #12

; Function Attrs: nobuiltin noinline
declare !remill.function.type !1316 extern_weak x86_64_sysvcc i64 @free(i64) #11

; Function Attrs: noinline
define internal %struct.Memory* @ext_1080___cxa_finalize(%struct.State* %0, i64 %1, %struct.Memory* %2) #12 {
  %4 = call %struct.Memory* @__remill_function_call(%struct.State* @__mcsema_reg_state, i64 ptrtoint (i64 (i64)* @__cxa_finalize to i64), %struct.Memory* %2)
  ret %struct.Memory* %4
}

; Function Attrs: naked nobuiltin noinline
define dllexport x86_64_sysvcc i32 @main(i32 %param0, i8** %param1, i8** %param2) #8 !remill.function.type !1317 {
  call void asm sideeffect "pushq $0;pushq $$0x10e0;jmpq *$1;", "*m,*m,~{dirflag},~{fpsr},~{flags}"(%struct.Memory* (%struct.State*, i64, %struct.Memory*)** elementtype(%struct.Memory* (%struct.State*, i64, %struct.Memory*)*) @1, void ()** elementtype(void ()*) @2)
  ret i32 undef
}

; Function Attrs: noinline
declare !remill.function.type !1318 void @__mcsema_attach_call() #12

define internal %struct.Memory* @main_wrapper(%struct.State* %0, i64 %1, %struct.Memory* %2) {
  call void @__mcsema_early_init()
  %4 = tail call %struct.Memory* @sub_10e0_main(%struct.State* @__mcsema_reg_state, i64 %1, %struct.Memory* %2)
  ret %struct.Memory* %4
}

define internal void @__mcsema_early_init() {
  %1 = load volatile i1, i1* @0, align 1
  br i1 %1, label %2, label %3

2:                                                ; preds = %0
  ret void

3:                                                ; preds = %0
  store volatile i1 true, i1* @0, align 1
  ret void
}

define internal %struct.Memory* @frame_dummy_wrapper(%struct.State* %0, i64 %1, %struct.Memory* %2) {
  call void @__mcsema_early_init()
  %4 = tail call %struct.Memory* @sub_1470_frame_dummy(%struct.State* @__mcsema_reg_state, i64 %1, %struct.Memory* %2)
  ret %struct.Memory* %4
}

define internal %struct.Memory* @__do_global_dtors_aux_wrapper(%struct.State* %0, i64 %1, %struct.Memory* %2) {
  call void @__mcsema_early_init()
  %4 = tail call %struct.Memory* @sub_1430___do_global_dtors_aux(%struct.State* @__mcsema_reg_state, i64 %1, %struct.Memory* %2)
  ret %struct.Memory* %4
}

define internal %struct.Memory* @_start_wrapper(%struct.State* %0, i64 %1, %struct.Memory* %2) {
  call void @__mcsema_early_init()
  %4 = tail call %struct.Memory* @sub_1390__start(%struct.State* @__mcsema_reg_state, i64 %1, %struct.Memory* %2)
  ret %struct.Memory* %4
}

define internal %struct.Memory* @.init_proc_wrapper(%struct.State* %0, i64 %1, %struct.Memory* %2) {
  call void @__mcsema_early_init()
  %4 = tail call %struct.Memory* @sub_1000__init_proc(%struct.State* @__mcsema_reg_state, i64 %1, %struct.Memory* %2)
  ret %struct.Memory* %4
}

attributes #0 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { alwaysinline inlinehint noduplicate noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noduplicate noinline nounwind optnone readnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind readnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { noduplicate noinline nounwind optnone readnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { noduplicate noinline nounwind optnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { alwaysinline inlinehint noduplicate noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #8 = { naked nobuiltin noinline }
attributes #9 = { noreturn }
attributes #10 = { noinline "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #11 = { nobuiltin noinline }
attributes #12 = { noinline }
attributes #13 = { nounwind }

!llvm.ident = !{!0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}
!llvm.dbg.cu = !{!4}

!0 = !{!"clang version 9.0.1 (https://github.com/trailofbits/vcpkg.git 4592a93cc4ca82f1963dba08413c43639662d7ae)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 2, !"Dwarf Version", i32 4}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !5, producer: "clang version 9.0.1 (https://github.com/trailofbits/vcpkg.git 4592a93cc4ca82f1963dba08413c43639662d7ae)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !6, imports: !7, nameTableKind: None)
!5 = !DIFile(filename: "/remill/lib/Arch/X86/Runtime/BasicBlock.cpp", directory: "/remill/remill-build/lib/Arch/X86/Runtime")
!6 = !{}
!7 = !{!8, !13, !20, !24, !31, !35, !40, !42, !50, !54, !58, !72, !76, !80, !84, !88, !93, !97, !101, !105, !109, !117, !121, !125, !127, !131, !135, !140, !146, !150, !154, !156, !164, !168, !176, !178, !182, !186, !190, !194, !199, !204, !209, !210, !211, !212, !214, !215, !216, !217, !218, !219, !220, !276, !280, !297, !300, !305, !313, !318, !322, !326, !330, !334, !336, !338, !342, !348, !352, !358, !364, !366, !370, !374, !378, !382, !393, !395, !399, !403, !407, !409, !413, !417, !421, !423, !425, !429, !437, !441, !445, !449, !451, !457, !459, !465, !469, !473, !477, !481, !485, !489, !491, !493, !497, !501, !505, !507, !511, !515, !517, !519, !523, !527, !531, !535, !536, !537, !538, !539, !540, !541, !542, !543, !544, !545, !550, !553, !555, !557, !559, !561, !563, !565, !567, !569, !571, !573, !575, !577, !580, !583, !585, !587, !589, !591, !593, !595, !597, !599, !601, !603, !605, !607, !610, !612, !616, !620, !625, !629, !631, !633, !635, !637, !639, !641, !643, !645, !647, !649, !651, !653, !655, !659, !665, !670, !674, !676, !678, !680, !682, !689, !693, !697, !701, !705, !709, !714, !718, !720, !724, !730, !734, !739, !741, !743, !747, !751, !755, !757, !759, !761, !763, !767, !769, !771, !775, !779, !783, !787, !791, !793, !795, !799, !803, !807, !811, !813, !815, !819, !823, !824, !825, !826, !827, !828, !834, !836, !838, !842, !844, !846, !848, !850, !852, !854, !856, !861, !865, !867, !869, !874, !876, !878, !880, !882, !884, !886, !889, !891, !893, !897, !901, !903, !905, !907, !909, !911, !913, !915, !917, !919, !921, !925, !929, !931, !933, !935, !937, !939, !941, !943, !945, !947, !949, !951, !953, !955, !957, !959, !963, !967, !971, !973, !975, !977, !979, !981, !983, !985, !987, !989, !993, !997, !1001, !1003, !1005, !1007, !1011, !1015, !1019, !1021, !1023, !1025, !1027, !1029, !1031, !1033, !1035, !1037, !1039, !1041, !1043, !1047, !1051, !1055, !1057, !1059, !1061, !1063, !1067, !1071, !1073, !1075, !1077, !1079, !1081, !1083, !1087, !1091, !1093, !1095, !1097, !1099, !1103, !1107, !1111, !1113, !1115, !1117, !1119, !1121, !1123, !1127, !1131, !1135, !1137, !1141, !1145, !1147, !1149, !1151, !1153, !1155, !1157, !1162, !1164, !1167, !1172, !1174, !1180, !1182, !1184, !1186, !1191, !1193, !1199, !1201, !1203, !1204, !1205, !1206, !1207, !1208, !1209, !1210, !1211, !1212, !1213, !1214, !1215, !1221, !1225, !1229, !1233, !1237, !1241, !1243, !1245, !1247, !1251, !1255, !1259, !1263, !1267, !1269, !1271, !1273, !1277, !1281, !1285, !1287}
!8 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !9, entity: !10, file: !12, line: 58)
!9 = !DINamespace(name: "__gnu_debug", scope: null)
!10 = !DINamespace(name: "__debug", scope: !11)
!11 = !DINamespace(name: "std", scope: null)
!12 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/c++/7.5.0/debug/debug.h", directory: "")
!13 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !14, file: !19, line: 52)
!14 = !DISubprogram(name: "abs", scope: !15, file: !15, line: 837, type: !16, flags: DIFlagPrototyped, spFlags: 0)
!15 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!16 = !DISubroutineType(types: !17)
!17 = !{!18, !18}
!18 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!19 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/c++/7.5.0/bits/std_abs.h", directory: "")
!20 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !21, file: !23, line: 127)
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !15, line: 62, baseType: !22)
!22 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !15, line: 58, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!23 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/c++/7.5.0/cstdlib", directory: "")
!24 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !25, file: !23, line: 128)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !15, line: 70, baseType: !26)
!26 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !15, line: 66, size: 128, flags: DIFlagTypePassByValue, elements: !27, identifier: "_ZTS6ldiv_t")
!27 = !{!28, !30}
!28 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !26, file: !15, line: 68, baseType: !29, size: 64)
!29 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !26, file: !15, line: 69, baseType: !29, size: 64, offset: 64)
!31 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !32, file: !23, line: 130)
!32 = !DISubprogram(name: "abort", scope: !15, file: !15, line: 588, type: !33, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!33 = !DISubroutineType(types: !34)
!34 = !{null}
!35 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !36, file: !23, line: 134)
!36 = !DISubprogram(name: "atexit", scope: !15, file: !15, line: 592, type: !37, flags: DIFlagPrototyped, spFlags: 0)
!37 = !DISubroutineType(types: !38)
!38 = !{!18, !39}
!39 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!40 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !41, file: !23, line: 137)
!41 = !DISubprogram(name: "at_quick_exit", scope: !15, file: !15, line: 597, type: !37, flags: DIFlagPrototyped, spFlags: 0)
!42 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !43, file: !23, line: 140)
!43 = !DISubprogram(name: "atof", scope: !15, file: !15, line: 101, type: !44, flags: DIFlagPrototyped, spFlags: 0)
!44 = !DISubroutineType(types: !45)
!45 = !{!46, !47}
!46 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !48, size: 64)
!48 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !49)
!49 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!50 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !51, file: !23, line: 141)
!51 = !DISubprogram(name: "atoi", scope: !15, file: !15, line: 104, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!52 = !DISubroutineType(types: !53)
!53 = !{!18, !47}
!54 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !55, file: !23, line: 142)
!55 = !DISubprogram(name: "atol", scope: !15, file: !15, line: 107, type: !56, flags: DIFlagPrototyped, spFlags: 0)
!56 = !DISubroutineType(types: !57)
!57 = !{!29, !47}
!58 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !59, file: !23, line: 143)
!59 = !DISubprogram(name: "bsearch", scope: !15, file: !15, line: 817, type: !60, flags: DIFlagPrototyped, spFlags: 0)
!60 = !DISubroutineType(types: !61)
!61 = !{!62, !63, !63, !65, !65, !68}
!62 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!63 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !64, size: 64)
!64 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!65 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !66, line: 46, baseType: !67)
!66 = !DIFile(filename: "/tmp/vcpkg_ubuntu-18.04_llvm-9_amd64/installed/x64-linux-rel/tools/llvm/lib/clang/9.0.1/include/stddef.h", directory: "")
!67 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!68 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !15, line: 805, baseType: !69)
!69 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !70, size: 64)
!70 = !DISubroutineType(types: !71)
!71 = !{!18, !63, !63}
!72 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !73, file: !23, line: 144)
!73 = !DISubprogram(name: "calloc", scope: !15, file: !15, line: 541, type: !74, flags: DIFlagPrototyped, spFlags: 0)
!74 = !DISubroutineType(types: !75)
!75 = !{!62, !65, !65}
!76 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !77, file: !23, line: 145)
!77 = !DISubprogram(name: "div", scope: !15, file: !15, line: 849, type: !78, flags: DIFlagPrototyped, spFlags: 0)
!78 = !DISubroutineType(types: !79)
!79 = !{!21, !18, !18}
!80 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !81, file: !23, line: 146)
!81 = !DISubprogram(name: "exit", scope: !15, file: !15, line: 614, type: !82, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!82 = !DISubroutineType(types: !83)
!83 = !{null, !18}
!84 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !85, file: !23, line: 147)
!85 = !DISubprogram(name: "free", scope: !15, file: !15, line: 563, type: !86, flags: DIFlagPrototyped, spFlags: 0)
!86 = !DISubroutineType(types: !87)
!87 = !{null, !62}
!88 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !89, file: !23, line: 148)
!89 = !DISubprogram(name: "getenv", scope: !15, file: !15, line: 631, type: !90, flags: DIFlagPrototyped, spFlags: 0)
!90 = !DISubroutineType(types: !91)
!91 = !{!92, !47}
!92 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !49, size: 64)
!93 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !94, file: !23, line: 149)
!94 = !DISubprogram(name: "labs", scope: !15, file: !15, line: 838, type: !95, flags: DIFlagPrototyped, spFlags: 0)
!95 = !DISubroutineType(types: !96)
!96 = !{!29, !29}
!97 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !98, file: !23, line: 150)
!98 = !DISubprogram(name: "ldiv", scope: !15, file: !15, line: 851, type: !99, flags: DIFlagPrototyped, spFlags: 0)
!99 = !DISubroutineType(types: !100)
!100 = !{!25, !29, !29}
!101 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !102, file: !23, line: 151)
!102 = !DISubprogram(name: "malloc", scope: !15, file: !15, line: 539, type: !103, flags: DIFlagPrototyped, spFlags: 0)
!103 = !DISubroutineType(types: !104)
!104 = !{!62, !65}
!105 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !106, file: !23, line: 153)
!106 = !DISubprogram(name: "mblen", scope: !15, file: !15, line: 919, type: !107, flags: DIFlagPrototyped, spFlags: 0)
!107 = !DISubroutineType(types: !108)
!108 = !{!18, !47, !65}
!109 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !110, file: !23, line: 154)
!110 = !DISubprogram(name: "mbstowcs", scope: !15, file: !15, line: 930, type: !111, flags: DIFlagPrototyped, spFlags: 0)
!111 = !DISubroutineType(types: !112)
!112 = !{!65, !113, !116, !65}
!113 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !114)
!114 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !115, size: 64)
!115 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!116 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !47)
!117 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !118, file: !23, line: 155)
!118 = !DISubprogram(name: "mbtowc", scope: !15, file: !15, line: 922, type: !119, flags: DIFlagPrototyped, spFlags: 0)
!119 = !DISubroutineType(types: !120)
!120 = !{!18, !113, !116, !65}
!121 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !122, file: !23, line: 157)
!122 = !DISubprogram(name: "qsort", scope: !15, file: !15, line: 827, type: !123, flags: DIFlagPrototyped, spFlags: 0)
!123 = !DISubroutineType(types: !124)
!124 = !{null, !62, !65, !65, !68}
!125 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !126, file: !23, line: 160)
!126 = !DISubprogram(name: "quick_exit", scope: !15, file: !15, line: 620, type: !82, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!127 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !128, file: !23, line: 163)
!128 = !DISubprogram(name: "rand", scope: !15, file: !15, line: 453, type: !129, flags: DIFlagPrototyped, spFlags: 0)
!129 = !DISubroutineType(types: !130)
!130 = !{!18}
!131 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !132, file: !23, line: 164)
!132 = !DISubprogram(name: "realloc", scope: !15, file: !15, line: 549, type: !133, flags: DIFlagPrototyped, spFlags: 0)
!133 = !DISubroutineType(types: !134)
!134 = !{!62, !62, !65}
!135 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !136, file: !23, line: 165)
!136 = !DISubprogram(name: "srand", scope: !15, file: !15, line: 455, type: !137, flags: DIFlagPrototyped, spFlags: 0)
!137 = !DISubroutineType(types: !138)
!138 = !{null, !139}
!139 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!140 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !141, file: !23, line: 166)
!141 = !DISubprogram(name: "strtod", scope: !15, file: !15, line: 117, type: !142, flags: DIFlagPrototyped, spFlags: 0)
!142 = !DISubroutineType(types: !143)
!143 = !{!46, !116, !144}
!144 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !145)
!145 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !92, size: 64)
!146 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !147, file: !23, line: 167)
!147 = !DISubprogram(name: "strtol", scope: !15, file: !15, line: 176, type: !148, flags: DIFlagPrototyped, spFlags: 0)
!148 = !DISubroutineType(types: !149)
!149 = !{!29, !116, !144, !18}
!150 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !151, file: !23, line: 168)
!151 = !DISubprogram(name: "strtoul", scope: !15, file: !15, line: 180, type: !152, flags: DIFlagPrototyped, spFlags: 0)
!152 = !DISubroutineType(types: !153)
!153 = !{!67, !116, !144, !18}
!154 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !155, file: !23, line: 169)
!155 = !DISubprogram(name: "system", scope: !15, file: !15, line: 781, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!156 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !157, file: !23, line: 171)
!157 = !DISubprogram(name: "wcstombs", scope: !15, file: !15, line: 933, type: !158, flags: DIFlagPrototyped, spFlags: 0)
!158 = !DISubroutineType(types: !159)
!159 = !{!65, !160, !161, !65}
!160 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !92)
!161 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !162)
!162 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !163, size: 64)
!163 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !115)
!164 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !165, file: !23, line: 172)
!165 = !DISubprogram(name: "wctomb", scope: !15, file: !15, line: 926, type: !166, flags: DIFlagPrototyped, spFlags: 0)
!166 = !DISubroutineType(types: !167)
!167 = !{!18, !92, !115}
!168 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !169, entity: !170, file: !23, line: 200)
!169 = !DINamespace(name: "__gnu_cxx", scope: null)
!170 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !15, line: 80, baseType: !171)
!171 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !15, line: 76, size: 128, flags: DIFlagTypePassByValue, elements: !172, identifier: "_ZTS7lldiv_t")
!172 = !{!173, !175}
!173 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !171, file: !15, line: 78, baseType: !174, size: 64)
!174 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!175 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !171, file: !15, line: 79, baseType: !174, size: 64, offset: 64)
!176 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !169, entity: !177, file: !23, line: 206)
!177 = !DISubprogram(name: "_Exit", scope: !15, file: !15, line: 626, type: !82, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!178 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !169, entity: !179, file: !23, line: 210)
!179 = !DISubprogram(name: "llabs", scope: !15, file: !15, line: 841, type: !180, flags: DIFlagPrototyped, spFlags: 0)
!180 = !DISubroutineType(types: !181)
!181 = !{!174, !174}
!182 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !169, entity: !183, file: !23, line: 216)
!183 = !DISubprogram(name: "lldiv", scope: !15, file: !15, line: 855, type: !184, flags: DIFlagPrototyped, spFlags: 0)
!184 = !DISubroutineType(types: !185)
!185 = !{!170, !174, !174}
!186 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !169, entity: !187, file: !23, line: 227)
!187 = !DISubprogram(name: "atoll", scope: !15, file: !15, line: 112, type: !188, flags: DIFlagPrototyped, spFlags: 0)
!188 = !DISubroutineType(types: !189)
!189 = !{!174, !47}
!190 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !169, entity: !191, file: !23, line: 228)
!191 = !DISubprogram(name: "strtoll", scope: !15, file: !15, line: 200, type: !192, flags: DIFlagPrototyped, spFlags: 0)
!192 = !DISubroutineType(types: !193)
!193 = !{!174, !116, !144, !18}
!194 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !169, entity: !195, file: !23, line: 229)
!195 = !DISubprogram(name: "strtoull", scope: !15, file: !15, line: 205, type: !196, flags: DIFlagPrototyped, spFlags: 0)
!196 = !DISubroutineType(types: !197)
!197 = !{!198, !116, !144, !18}
!198 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!199 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !169, entity: !200, file: !23, line: 231)
!200 = !DISubprogram(name: "strtof", scope: !15, file: !15, line: 123, type: !201, flags: DIFlagPrototyped, spFlags: 0)
!201 = !DISubroutineType(types: !202)
!202 = !{!203, !116, !144}
!203 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!204 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !169, entity: !205, file: !23, line: 232)
!205 = !DISubprogram(name: "strtold", scope: !15, file: !15, line: 126, type: !206, flags: DIFlagPrototyped, spFlags: 0)
!206 = !DISubroutineType(types: !207)
!207 = !{!208, !116, !144}
!208 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!209 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !170, file: !23, line: 240)
!210 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !177, file: !23, line: 242)
!211 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !179, file: !23, line: 244)
!212 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !213, file: !23, line: 245)
!213 = !DISubprogram(name: "div", linkageName: "_ZN9__gnu_cxx3divExx", scope: !169, file: !23, line: 213, type: !184, flags: DIFlagPrototyped, spFlags: 0)
!214 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !183, file: !23, line: 246)
!215 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !187, file: !23, line: 248)
!216 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !200, file: !23, line: 249)
!217 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !191, file: !23, line: 250)
!218 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !195, file: !23, line: 251)
!219 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !205, file: !23, line: 252)
!220 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !221, file: !222, line: 57)
!221 = distinct !DICompositeType(tag: DW_TAG_class_type, name: "exception_ptr", scope: !223, file: !222, line: 79, size: 64, flags: DIFlagTypePassByReference | DIFlagNonTrivial, elements: !224, identifier: "_ZTSNSt15__exception_ptr13exception_ptrE")
!222 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/c++/7.5.0/bits/exception_ptr.h", directory: "")
!223 = !DINamespace(name: "__exception_ptr", scope: !11)
!224 = !{!225, !226, !230, !233, !234, !239, !240, !244, !250, !254, !258, !261, !262, !265, !269}
!225 = !DIDerivedType(tag: DW_TAG_member, name: "_M_exception_object", scope: !221, file: !222, line: 81, baseType: !62, size: 64)
!226 = !DISubprogram(name: "exception_ptr", scope: !221, file: !222, line: 83, type: !227, scopeLine: 83, flags: DIFlagExplicit | DIFlagPrototyped, spFlags: 0)
!227 = !DISubroutineType(types: !228)
!228 = !{null, !229, !62}
!229 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !221, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!230 = !DISubprogram(name: "_M_addref", linkageName: "_ZNSt15__exception_ptr13exception_ptr9_M_addrefEv", scope: !221, file: !222, line: 85, type: !231, scopeLine: 85, flags: DIFlagPrototyped, spFlags: 0)
!231 = !DISubroutineType(types: !232)
!232 = !{null, !229}
!233 = !DISubprogram(name: "_M_release", linkageName: "_ZNSt15__exception_ptr13exception_ptr10_M_releaseEv", scope: !221, file: !222, line: 86, type: !231, scopeLine: 86, flags: DIFlagPrototyped, spFlags: 0)
!234 = !DISubprogram(name: "_M_get", linkageName: "_ZNKSt15__exception_ptr13exception_ptr6_M_getEv", scope: !221, file: !222, line: 88, type: !235, scopeLine: 88, flags: DIFlagPrototyped, spFlags: 0)
!235 = !DISubroutineType(types: !236)
!236 = !{!62, !237}
!237 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !238, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!238 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !221)
!239 = !DISubprogram(name: "exception_ptr", scope: !221, file: !222, line: 96, type: !231, scopeLine: 96, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!240 = !DISubprogram(name: "exception_ptr", scope: !221, file: !222, line: 98, type: !241, scopeLine: 98, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!241 = !DISubroutineType(types: !242)
!242 = !{null, !229, !243}
!243 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !238, size: 64)
!244 = !DISubprogram(name: "exception_ptr", scope: !221, file: !222, line: 101, type: !245, scopeLine: 101, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!245 = !DISubroutineType(types: !246)
!246 = !{null, !229, !247}
!247 = !DIDerivedType(tag: DW_TAG_typedef, name: "nullptr_t", scope: !11, file: !248, line: 235, baseType: !249)
!248 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/x86_64-linux-gnu/c++/7.5.0/bits/c++config.h", directory: "")
!249 = !DIBasicType(tag: DW_TAG_unspecified_type, name: "decltype(nullptr)")
!250 = !DISubprogram(name: "exception_ptr", scope: !221, file: !222, line: 105, type: !251, scopeLine: 105, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!251 = !DISubroutineType(types: !252)
!252 = !{null, !229, !253}
!253 = !DIDerivedType(tag: DW_TAG_rvalue_reference_type, baseType: !221, size: 64)
!254 = !DISubprogram(name: "operator=", linkageName: "_ZNSt15__exception_ptr13exception_ptraSERKS0_", scope: !221, file: !222, line: 118, type: !255, scopeLine: 118, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!255 = !DISubroutineType(types: !256)
!256 = !{!257, !229, !243}
!257 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !221, size: 64)
!258 = !DISubprogram(name: "operator=", linkageName: "_ZNSt15__exception_ptr13exception_ptraSEOS0_", scope: !221, file: !222, line: 122, type: !259, scopeLine: 122, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!259 = !DISubroutineType(types: !260)
!260 = !{!257, !229, !253}
!261 = !DISubprogram(name: "~exception_ptr", scope: !221, file: !222, line: 129, type: !231, scopeLine: 129, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!262 = !DISubprogram(name: "swap", linkageName: "_ZNSt15__exception_ptr13exception_ptr4swapERS0_", scope: !221, file: !222, line: 132, type: !263, scopeLine: 132, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!263 = !DISubroutineType(types: !264)
!264 = !{null, !229, !257}
!265 = !DISubprogram(name: "operator bool", linkageName: "_ZNKSt15__exception_ptr13exception_ptrcvbEv", scope: !221, file: !222, line: 144, type: !266, scopeLine: 144, flags: DIFlagPublic | DIFlagExplicit | DIFlagPrototyped, spFlags: 0)
!266 = !DISubroutineType(types: !267)
!267 = !{!268, !237}
!268 = !DIBasicType(name: "bool", size: 8, encoding: DW_ATE_boolean)
!269 = !DISubprogram(name: "__cxa_exception_type", linkageName: "_ZNKSt15__exception_ptr13exception_ptr20__cxa_exception_typeEv", scope: !221, file: !222, line: 153, type: !270, scopeLine: 153, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!270 = !DISubroutineType(types: !271)
!271 = !{!272, !237}
!272 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !273, size: 64)
!273 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !274)
!274 = !DICompositeType(tag: DW_TAG_class_type, name: "type_info", scope: !11, file: !275, line: 88, flags: DIFlagFwdDecl)
!275 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/c++/7.5.0/typeinfo", directory: "")
!276 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !223, entity: !277, file: !222, line: 73)
!277 = !DISubprogram(name: "rethrow_exception", linkageName: "_ZSt17rethrow_exceptionNSt15__exception_ptr13exception_ptrE", scope: !11, file: !222, line: 69, type: !278, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!278 = !DISubroutineType(types: !279)
!279 = !{null, !221}
!280 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !281, file: !296, line: 64)
!281 = !DIDerivedType(tag: DW_TAG_typedef, name: "mbstate_t", file: !282, line: 6, baseType: !283)
!282 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/mbstate_t.h", directory: "")
!283 = !DIDerivedType(tag: DW_TAG_typedef, name: "__mbstate_t", file: !284, line: 21, baseType: !285)
!284 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/__mbstate_t.h", directory: "")
!285 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !284, line: 13, size: 64, flags: DIFlagTypePassByValue, elements: !286, identifier: "_ZTS11__mbstate_t")
!286 = !{!287, !288}
!287 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !285, file: !284, line: 15, baseType: !18, size: 32)
!288 = !DIDerivedType(tag: DW_TAG_member, name: "__value", scope: !285, file: !284, line: 20, baseType: !289, size: 32, offset: 32)
!289 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !285, file: !284, line: 16, size: 32, flags: DIFlagTypePassByValue, elements: !290, identifier: "_ZTSN11__mbstate_tUt_E")
!290 = !{!291, !292}
!291 = !DIDerivedType(tag: DW_TAG_member, name: "__wch", scope: !289, file: !284, line: 18, baseType: !139, size: 32)
!292 = !DIDerivedType(tag: DW_TAG_member, name: "__wchb", scope: !289, file: !284, line: 19, baseType: !293, size: 32)
!293 = !DICompositeType(tag: DW_TAG_array_type, baseType: !49, size: 32, elements: !294)
!294 = !{!295}
!295 = !DISubrange(count: 4, lowerBound: 0)
!296 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/c++/7.5.0/cwchar", directory: "")
!297 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !298, file: !296, line: 139)
!298 = !DIDerivedType(tag: DW_TAG_typedef, name: "wint_t", file: !299, line: 20, baseType: !139)
!299 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/wint_t.h", directory: "")
!300 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !301, file: !296, line: 141)
!301 = !DISubprogram(name: "btowc", scope: !302, file: !302, line: 284, type: !303, flags: DIFlagPrototyped, spFlags: 0)
!302 = !DIFile(filename: "/usr/include/wchar.h", directory: "")
!303 = !DISubroutineType(types: !304)
!304 = !{!298, !18}
!305 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !306, file: !296, line: 142)
!306 = !DISubprogram(name: "fgetwc", scope: !302, file: !302, line: 727, type: !307, flags: DIFlagPrototyped, spFlags: 0)
!307 = !DISubroutineType(types: !308)
!308 = !{!298, !309}
!309 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !310, size: 64)
!310 = !DIDerivedType(tag: DW_TAG_typedef, name: "__FILE", file: !311, line: 5, baseType: !312)
!311 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/__FILE.h", directory: "")
!312 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_FILE", file: !311, line: 4, flags: DIFlagFwdDecl, identifier: "_ZTS8_IO_FILE")
!313 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !314, file: !296, line: 143)
!314 = !DISubprogram(name: "fgetws", scope: !302, file: !302, line: 756, type: !315, flags: DIFlagPrototyped, spFlags: 0)
!315 = !DISubroutineType(types: !316)
!316 = !{!114, !113, !18, !317}
!317 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !309)
!318 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !319, file: !296, line: 144)
!319 = !DISubprogram(name: "fputwc", scope: !302, file: !302, line: 741, type: !320, flags: DIFlagPrototyped, spFlags: 0)
!320 = !DISubroutineType(types: !321)
!321 = !{!298, !115, !309}
!322 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !323, file: !296, line: 145)
!323 = !DISubprogram(name: "fputws", scope: !302, file: !302, line: 763, type: !324, flags: DIFlagPrototyped, spFlags: 0)
!324 = !DISubroutineType(types: !325)
!325 = !{!18, !161, !317}
!326 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !327, file: !296, line: 146)
!327 = !DISubprogram(name: "fwide", scope: !302, file: !302, line: 573, type: !328, flags: DIFlagPrototyped, spFlags: 0)
!328 = !DISubroutineType(types: !329)
!329 = !{!18, !309, !18}
!330 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !331, file: !296, line: 147)
!331 = !DISubprogram(name: "fwprintf", scope: !302, file: !302, line: 580, type: !332, flags: DIFlagPrototyped, spFlags: 0)
!332 = !DISubroutineType(types: !333)
!333 = !{!18, !317, !161, null}
!334 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !335, file: !296, line: 148)
!335 = !DISubprogram(name: "fwscanf", scope: !302, file: !302, line: 621, type: !332, flags: DIFlagPrototyped, spFlags: 0)
!336 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !337, file: !296, line: 149)
!337 = !DISubprogram(name: "getwc", scope: !302, file: !302, line: 728, type: !307, flags: DIFlagPrototyped, spFlags: 0)
!338 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !339, file: !296, line: 150)
!339 = !DISubprogram(name: "getwchar", scope: !302, file: !302, line: 734, type: !340, flags: DIFlagPrototyped, spFlags: 0)
!340 = !DISubroutineType(types: !341)
!341 = !{!298}
!342 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !343, file: !296, line: 151)
!343 = !DISubprogram(name: "mbrlen", scope: !302, file: !302, line: 307, type: !344, flags: DIFlagPrototyped, spFlags: 0)
!344 = !DISubroutineType(types: !345)
!345 = !{!65, !116, !65, !346}
!346 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !347)
!347 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !281, size: 64)
!348 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !349, file: !296, line: 152)
!349 = !DISubprogram(name: "mbrtowc", scope: !302, file: !302, line: 296, type: !350, flags: DIFlagPrototyped, spFlags: 0)
!350 = !DISubroutineType(types: !351)
!351 = !{!65, !113, !116, !65, !346}
!352 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !353, file: !296, line: 153)
!353 = !DISubprogram(name: "mbsinit", scope: !302, file: !302, line: 292, type: !354, flags: DIFlagPrototyped, spFlags: 0)
!354 = !DISubroutineType(types: !355)
!355 = !{!18, !356}
!356 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !357, size: 64)
!357 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !281)
!358 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !359, file: !296, line: 154)
!359 = !DISubprogram(name: "mbsrtowcs", scope: !302, file: !302, line: 337, type: !360, flags: DIFlagPrototyped, spFlags: 0)
!360 = !DISubroutineType(types: !361)
!361 = !{!65, !113, !362, !65, !346}
!362 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !363)
!363 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !47, size: 64)
!364 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !365, file: !296, line: 155)
!365 = !DISubprogram(name: "putwc", scope: !302, file: !302, line: 742, type: !320, flags: DIFlagPrototyped, spFlags: 0)
!366 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !367, file: !296, line: 156)
!367 = !DISubprogram(name: "putwchar", scope: !302, file: !302, line: 748, type: !368, flags: DIFlagPrototyped, spFlags: 0)
!368 = !DISubroutineType(types: !369)
!369 = !{!298, !115}
!370 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !371, file: !296, line: 158)
!371 = !DISubprogram(name: "swprintf", scope: !302, file: !302, line: 590, type: !372, flags: DIFlagPrototyped, spFlags: 0)
!372 = !DISubroutineType(types: !373)
!373 = !{!18, !113, !65, !161, null}
!374 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !375, file: !296, line: 160)
!375 = !DISubprogram(name: "swscanf", scope: !302, file: !302, line: 631, type: !376, flags: DIFlagPrototyped, spFlags: 0)
!376 = !DISubroutineType(types: !377)
!377 = !{!18, !161, !161, null}
!378 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !379, file: !296, line: 161)
!379 = !DISubprogram(name: "ungetwc", scope: !302, file: !302, line: 771, type: !380, flags: DIFlagPrototyped, spFlags: 0)
!380 = !DISubroutineType(types: !381)
!381 = !{!298, !298, !309}
!382 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !383, file: !296, line: 162)
!383 = !DISubprogram(name: "vfwprintf", scope: !302, file: !302, line: 598, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!384 = !DISubroutineType(types: !385)
!385 = !{!18, !317, !161, !386}
!386 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !387, size: 64)
!387 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__va_list_tag", file: !5, size: 192, flags: DIFlagTypePassByValue, elements: !388, identifier: "_ZTS13__va_list_tag")
!388 = !{!389, !390, !391, !392}
!389 = !DIDerivedType(tag: DW_TAG_member, name: "gp_offset", scope: !387, file: !5, baseType: !139, size: 32)
!390 = !DIDerivedType(tag: DW_TAG_member, name: "fp_offset", scope: !387, file: !5, baseType: !139, size: 32, offset: 32)
!391 = !DIDerivedType(tag: DW_TAG_member, name: "overflow_arg_area", scope: !387, file: !5, baseType: !62, size: 64, offset: 64)
!392 = !DIDerivedType(tag: DW_TAG_member, name: "reg_save_area", scope: !387, file: !5, baseType: !62, size: 64, offset: 128)
!393 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !394, file: !296, line: 164)
!394 = !DISubprogram(name: "vfwscanf", scope: !302, file: !302, line: 673, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!395 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !396, file: !296, line: 167)
!396 = !DISubprogram(name: "vswprintf", scope: !302, file: !302, line: 611, type: !397, flags: DIFlagPrototyped, spFlags: 0)
!397 = !DISubroutineType(types: !398)
!398 = !{!18, !113, !65, !161, !386}
!399 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !400, file: !296, line: 170)
!400 = !DISubprogram(name: "vswscanf", scope: !302, file: !302, line: 685, type: !401, flags: DIFlagPrototyped, spFlags: 0)
!401 = !DISubroutineType(types: !402)
!402 = !{!18, !161, !161, !386}
!403 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !404, file: !296, line: 172)
!404 = !DISubprogram(name: "vwprintf", scope: !302, file: !302, line: 606, type: !405, flags: DIFlagPrototyped, spFlags: 0)
!405 = !DISubroutineType(types: !406)
!406 = !{!18, !161, !386}
!407 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !408, file: !296, line: 174)
!408 = !DISubprogram(name: "vwscanf", scope: !302, file: !302, line: 681, type: !405, flags: DIFlagPrototyped, spFlags: 0)
!409 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !410, file: !296, line: 176)
!410 = !DISubprogram(name: "wcrtomb", scope: !302, file: !302, line: 301, type: !411, flags: DIFlagPrototyped, spFlags: 0)
!411 = !DISubroutineType(types: !412)
!412 = !{!65, !160, !115, !346}
!413 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !414, file: !296, line: 177)
!414 = !DISubprogram(name: "wcscat", scope: !302, file: !302, line: 97, type: !415, flags: DIFlagPrototyped, spFlags: 0)
!415 = !DISubroutineType(types: !416)
!416 = !{!114, !113, !161}
!417 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !418, file: !296, line: 178)
!418 = !DISubprogram(name: "wcscmp", scope: !302, file: !302, line: 106, type: !419, flags: DIFlagPrototyped, spFlags: 0)
!419 = !DISubroutineType(types: !420)
!420 = !{!18, !162, !162}
!421 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !422, file: !296, line: 179)
!422 = !DISubprogram(name: "wcscoll", scope: !302, file: !302, line: 131, type: !419, flags: DIFlagPrototyped, spFlags: 0)
!423 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !424, file: !296, line: 180)
!424 = !DISubprogram(name: "wcscpy", scope: !302, file: !302, line: 87, type: !415, flags: DIFlagPrototyped, spFlags: 0)
!425 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !426, file: !296, line: 181)
!426 = !DISubprogram(name: "wcscspn", scope: !302, file: !302, line: 187, type: !427, flags: DIFlagPrototyped, spFlags: 0)
!427 = !DISubroutineType(types: !428)
!428 = !{!65, !162, !162}
!429 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !430, file: !296, line: 182)
!430 = !DISubprogram(name: "wcsftime", scope: !302, file: !302, line: 835, type: !431, flags: DIFlagPrototyped, spFlags: 0)
!431 = !DISubroutineType(types: !432)
!432 = !{!65, !113, !65, !161, !433}
!433 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !434)
!434 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !435, size: 64)
!435 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !436)
!436 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "tm", file: !302, line: 83, flags: DIFlagFwdDecl, identifier: "_ZTS2tm")
!437 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !438, file: !296, line: 183)
!438 = !DISubprogram(name: "wcslen", scope: !302, file: !302, line: 222, type: !439, flags: DIFlagPrototyped, spFlags: 0)
!439 = !DISubroutineType(types: !440)
!440 = !{!65, !162}
!441 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !442, file: !296, line: 184)
!442 = !DISubprogram(name: "wcsncat", scope: !302, file: !302, line: 101, type: !443, flags: DIFlagPrototyped, spFlags: 0)
!443 = !DISubroutineType(types: !444)
!444 = !{!114, !113, !161, !65}
!445 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !446, file: !296, line: 185)
!446 = !DISubprogram(name: "wcsncmp", scope: !302, file: !302, line: 109, type: !447, flags: DIFlagPrototyped, spFlags: 0)
!447 = !DISubroutineType(types: !448)
!448 = !{!18, !162, !162, !65}
!449 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !450, file: !296, line: 186)
!450 = !DISubprogram(name: "wcsncpy", scope: !302, file: !302, line: 92, type: !443, flags: DIFlagPrototyped, spFlags: 0)
!451 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !452, file: !296, line: 187)
!452 = !DISubprogram(name: "wcsrtombs", scope: !302, file: !302, line: 343, type: !453, flags: DIFlagPrototyped, spFlags: 0)
!453 = !DISubroutineType(types: !454)
!454 = !{!65, !160, !455, !65, !346}
!455 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !456)
!456 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !162, size: 64)
!457 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !458, file: !296, line: 188)
!458 = !DISubprogram(name: "wcsspn", scope: !302, file: !302, line: 191, type: !427, flags: DIFlagPrototyped, spFlags: 0)
!459 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !460, file: !296, line: 189)
!460 = !DISubprogram(name: "wcstod", scope: !302, file: !302, line: 377, type: !461, flags: DIFlagPrototyped, spFlags: 0)
!461 = !DISubroutineType(types: !462)
!462 = !{!46, !161, !463}
!463 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !464)
!464 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !114, size: 64)
!465 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !466, file: !296, line: 191)
!466 = !DISubprogram(name: "wcstof", scope: !302, file: !302, line: 382, type: !467, flags: DIFlagPrototyped, spFlags: 0)
!467 = !DISubroutineType(types: !468)
!468 = !{!203, !161, !463}
!469 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !470, file: !296, line: 193)
!470 = !DISubprogram(name: "wcstok", scope: !302, file: !302, line: 217, type: !471, flags: DIFlagPrototyped, spFlags: 0)
!471 = !DISubroutineType(types: !472)
!472 = !{!114, !113, !161, !463}
!473 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !474, file: !296, line: 194)
!474 = !DISubprogram(name: "wcstol", scope: !302, file: !302, line: 428, type: !475, flags: DIFlagPrototyped, spFlags: 0)
!475 = !DISubroutineType(types: !476)
!476 = !{!29, !161, !463, !18}
!477 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !478, file: !296, line: 195)
!478 = !DISubprogram(name: "wcstoul", scope: !302, file: !302, line: 433, type: !479, flags: DIFlagPrototyped, spFlags: 0)
!479 = !DISubroutineType(types: !480)
!480 = !{!67, !161, !463, !18}
!481 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !482, file: !296, line: 196)
!482 = !DISubprogram(name: "wcsxfrm", scope: !302, file: !302, line: 135, type: !483, flags: DIFlagPrototyped, spFlags: 0)
!483 = !DISubroutineType(types: !484)
!484 = !{!65, !113, !161, !65}
!485 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !486, file: !296, line: 197)
!486 = !DISubprogram(name: "wctob", scope: !302, file: !302, line: 288, type: !487, flags: DIFlagPrototyped, spFlags: 0)
!487 = !DISubroutineType(types: !488)
!488 = !{!18, !298}
!489 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !490, file: !296, line: 198)
!490 = !DISubprogram(name: "wmemcmp", scope: !302, file: !302, line: 258, type: !447, flags: DIFlagPrototyped, spFlags: 0)
!491 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !492, file: !296, line: 199)
!492 = !DISubprogram(name: "wmemcpy", scope: !302, file: !302, line: 262, type: !443, flags: DIFlagPrototyped, spFlags: 0)
!493 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !494, file: !296, line: 200)
!494 = !DISubprogram(name: "wmemmove", scope: !302, file: !302, line: 267, type: !495, flags: DIFlagPrototyped, spFlags: 0)
!495 = !DISubroutineType(types: !496)
!496 = !{!114, !114, !162, !65}
!497 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !498, file: !296, line: 201)
!498 = !DISubprogram(name: "wmemset", scope: !302, file: !302, line: 271, type: !499, flags: DIFlagPrototyped, spFlags: 0)
!499 = !DISubroutineType(types: !500)
!500 = !{!114, !114, !115, !65}
!501 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !502, file: !296, line: 202)
!502 = !DISubprogram(name: "wprintf", scope: !302, file: !302, line: 587, type: !503, flags: DIFlagPrototyped, spFlags: 0)
!503 = !DISubroutineType(types: !504)
!504 = !{!18, !161, null}
!505 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !506, file: !296, line: 203)
!506 = !DISubprogram(name: "wscanf", scope: !302, file: !302, line: 628, type: !503, flags: DIFlagPrototyped, spFlags: 0)
!507 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !508, file: !296, line: 204)
!508 = !DISubprogram(name: "wcschr", scope: !302, file: !302, line: 164, type: !509, flags: DIFlagPrototyped, spFlags: 0)
!509 = !DISubroutineType(types: !510)
!510 = !{!114, !162, !115}
!511 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !512, file: !296, line: 205)
!512 = !DISubprogram(name: "wcspbrk", scope: !302, file: !302, line: 201, type: !513, flags: DIFlagPrototyped, spFlags: 0)
!513 = !DISubroutineType(types: !514)
!514 = !{!114, !162, !162}
!515 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !516, file: !296, line: 206)
!516 = !DISubprogram(name: "wcsrchr", scope: !302, file: !302, line: 174, type: !509, flags: DIFlagPrototyped, spFlags: 0)
!517 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !518, file: !296, line: 207)
!518 = !DISubprogram(name: "wcsstr", scope: !302, file: !302, line: 212, type: !513, flags: DIFlagPrototyped, spFlags: 0)
!519 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !520, file: !296, line: 208)
!520 = !DISubprogram(name: "wmemchr", scope: !302, file: !302, line: 253, type: !521, flags: DIFlagPrototyped, spFlags: 0)
!521 = !DISubroutineType(types: !522)
!522 = !{!114, !162, !115, !65}
!523 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !169, entity: !524, file: !296, line: 248)
!524 = !DISubprogram(name: "wcstold", scope: !302, file: !302, line: 384, type: !525, flags: DIFlagPrototyped, spFlags: 0)
!525 = !DISubroutineType(types: !526)
!526 = !{!208, !161, !463}
!527 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !169, entity: !528, file: !296, line: 257)
!528 = !DISubprogram(name: "wcstoll", scope: !302, file: !302, line: 441, type: !529, flags: DIFlagPrototyped, spFlags: 0)
!529 = !DISubroutineType(types: !530)
!530 = !{!174, !161, !463, !18}
!531 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !169, entity: !532, file: !296, line: 258)
!532 = !DISubprogram(name: "wcstoull", scope: !302, file: !302, line: 448, type: !533, flags: DIFlagPrototyped, spFlags: 0)
!533 = !DISubroutineType(types: !534)
!534 = !{!198, !161, !463, !18}
!535 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !524, file: !296, line: 264)
!536 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !528, file: !296, line: 265)
!537 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !532, file: !296, line: 266)
!538 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !466, file: !296, line: 280)
!539 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !394, file: !296, line: 283)
!540 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !400, file: !296, line: 286)
!541 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !408, file: !296, line: 289)
!542 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !524, file: !296, line: 293)
!543 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !528, file: !296, line: 294)
!544 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !532, file: !296, line: 295)
!545 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !546, file: !549, line: 48)
!546 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !547, line: 224, baseType: !548)
!547 = !DIFile(filename: "/tmp/vcpkg_ubuntu-18.04_llvm-9_amd64/installed/x64-linux-rel/tools/llvm/lib/clang/9.0.1/include/stdint.h", directory: "")
!548 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!549 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/c++/7.5.0/cstdint", directory: "")
!550 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !551, file: !549, line: 49)
!551 = !DIDerivedType(tag: DW_TAG_typedef, name: "int16_t", file: !547, line: 205, baseType: !552)
!552 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!553 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !554, file: !549, line: 50)
!554 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !547, line: 167, baseType: !18)
!555 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !556, file: !549, line: 51)
!556 = !DIDerivedType(tag: DW_TAG_typedef, name: "int64_t", file: !547, line: 96, baseType: !29)
!557 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !558, file: !549, line: 53)
!558 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast8_t", file: !547, line: 234, baseType: !546)
!559 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !560, file: !549, line: 54)
!560 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast16_t", file: !547, line: 217, baseType: !551)
!561 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !562, file: !549, line: 55)
!562 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast32_t", file: !547, line: 186, baseType: !554)
!563 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !564, file: !549, line: 56)
!564 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast64_t", file: !547, line: 112, baseType: !556)
!565 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !566, file: !549, line: 58)
!566 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least8_t", file: !547, line: 232, baseType: !546)
!567 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !568, file: !549, line: 59)
!568 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least16_t", file: !547, line: 215, baseType: !551)
!569 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !570, file: !549, line: 60)
!570 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least32_t", file: !547, line: 184, baseType: !554)
!571 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !572, file: !549, line: 61)
!572 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least64_t", file: !547, line: 110, baseType: !556)
!573 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !574, file: !549, line: 63)
!574 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !547, line: 262, baseType: !29)
!575 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !576, file: !549, line: 64)
!576 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !547, line: 249, baseType: !29)
!577 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !578, file: !549, line: 66)
!578 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !547, line: 226, baseType: !579)
!579 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!580 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !581, file: !549, line: 67)
!581 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !547, line: 207, baseType: !582)
!582 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!583 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !584, file: !549, line: 68)
!584 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !547, line: 172, baseType: !139)
!585 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !586, file: !549, line: 69)
!586 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !547, line: 98, baseType: !67)
!587 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !588, file: !549, line: 71)
!588 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast8_t", file: !547, line: 235, baseType: !578)
!589 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !590, file: !549, line: 72)
!590 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast16_t", file: !547, line: 218, baseType: !581)
!591 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !592, file: !549, line: 73)
!592 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast32_t", file: !547, line: 187, baseType: !584)
!593 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !594, file: !549, line: 74)
!594 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast64_t", file: !547, line: 113, baseType: !586)
!595 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !596, file: !549, line: 76)
!596 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least8_t", file: !547, line: 233, baseType: !578)
!597 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !598, file: !549, line: 77)
!598 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least16_t", file: !547, line: 216, baseType: !581)
!599 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !600, file: !549, line: 78)
!600 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least32_t", file: !547, line: 185, baseType: !584)
!601 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !602, file: !549, line: 79)
!602 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least64_t", file: !547, line: 111, baseType: !586)
!603 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !604, file: !549, line: 81)
!604 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintmax_t", file: !547, line: 263, baseType: !67)
!605 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !606, file: !549, line: 82)
!606 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !547, line: 256, baseType: !67)
!607 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !169, entity: !608, file: !609, line: 44)
!608 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", scope: !11, file: !248, line: 231, baseType: !67)
!609 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/c++/7.5.0/ext/new_allocator.h", directory: "")
!610 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !169, entity: !611, file: !609, line: 45)
!611 = !DIDerivedType(tag: DW_TAG_typedef, name: "ptrdiff_t", scope: !11, file: !248, line: 232, baseType: !29)
!612 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !613, file: !615, line: 53)
!613 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "lconv", file: !614, line: 51, flags: DIFlagFwdDecl, identifier: "_ZTS5lconv")
!614 = !DIFile(filename: "/usr/include/locale.h", directory: "")
!615 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/c++/7.5.0/clocale", directory: "")
!616 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !617, file: !615, line: 54)
!617 = !DISubprogram(name: "setlocale", scope: !614, file: !614, line: 122, type: !618, flags: DIFlagPrototyped, spFlags: 0)
!618 = !DISubroutineType(types: !619)
!619 = !{!92, !18, !47}
!620 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !621, file: !615, line: 55)
!621 = !DISubprogram(name: "localeconv", scope: !614, file: !614, line: 125, type: !622, flags: DIFlagPrototyped, spFlags: 0)
!622 = !DISubroutineType(types: !623)
!623 = !{!624}
!624 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !613, size: 64)
!625 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !626, file: !628, line: 64)
!626 = !DISubprogram(name: "isalnum", scope: !627, file: !627, line: 108, type: !16, flags: DIFlagPrototyped, spFlags: 0)
!627 = !DIFile(filename: "/usr/include/ctype.h", directory: "")
!628 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/c++/7.5.0/cctype", directory: "")
!629 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !630, file: !628, line: 65)
!630 = !DISubprogram(name: "isalpha", scope: !627, file: !627, line: 109, type: !16, flags: DIFlagPrototyped, spFlags: 0)
!631 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !632, file: !628, line: 66)
!632 = !DISubprogram(name: "iscntrl", scope: !627, file: !627, line: 110, type: !16, flags: DIFlagPrototyped, spFlags: 0)
!633 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !634, file: !628, line: 67)
!634 = !DISubprogram(name: "isdigit", scope: !627, file: !627, line: 111, type: !16, flags: DIFlagPrototyped, spFlags: 0)
!635 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !636, file: !628, line: 68)
!636 = !DISubprogram(name: "isgraph", scope: !627, file: !627, line: 113, type: !16, flags: DIFlagPrototyped, spFlags: 0)
!637 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !638, file: !628, line: 69)
!638 = !DISubprogram(name: "islower", scope: !627, file: !627, line: 112, type: !16, flags: DIFlagPrototyped, spFlags: 0)
!639 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !640, file: !628, line: 70)
!640 = !DISubprogram(name: "isprint", scope: !627, file: !627, line: 114, type: !16, flags: DIFlagPrototyped, spFlags: 0)
!641 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !642, file: !628, line: 71)
!642 = !DISubprogram(name: "ispunct", scope: !627, file: !627, line: 115, type: !16, flags: DIFlagPrototyped, spFlags: 0)
!643 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !644, file: !628, line: 72)
!644 = !DISubprogram(name: "isspace", scope: !627, file: !627, line: 116, type: !16, flags: DIFlagPrototyped, spFlags: 0)
!645 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !646, file: !628, line: 73)
!646 = !DISubprogram(name: "isupper", scope: !627, file: !627, line: 117, type: !16, flags: DIFlagPrototyped, spFlags: 0)
!647 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !648, file: !628, line: 74)
!648 = !DISubprogram(name: "isxdigit", scope: !627, file: !627, line: 118, type: !16, flags: DIFlagPrototyped, spFlags: 0)
!649 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !650, file: !628, line: 75)
!650 = !DISubprogram(name: "tolower", scope: !627, file: !627, line: 122, type: !16, flags: DIFlagPrototyped, spFlags: 0)
!651 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !652, file: !628, line: 76)
!652 = !DISubprogram(name: "toupper", scope: !627, file: !627, line: 125, type: !16, flags: DIFlagPrototyped, spFlags: 0)
!653 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !654, file: !628, line: 87)
!654 = !DISubprogram(name: "isblank", scope: !627, file: !627, line: 130, type: !16, flags: DIFlagPrototyped, spFlags: 0)
!655 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !656, file: !658, line: 98)
!656 = !DIDerivedType(tag: DW_TAG_typedef, name: "FILE", file: !657, line: 7, baseType: !312)
!657 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/FILE.h", directory: "")
!658 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/c++/7.5.0/cstdio", directory: "")
!659 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !660, file: !658, line: 99)
!660 = !DIDerivedType(tag: DW_TAG_typedef, name: "fpos_t", file: !661, line: 78, baseType: !662)
!661 = !DIFile(filename: "/usr/include/stdio.h", directory: "")
!662 = !DIDerivedType(tag: DW_TAG_typedef, name: "_G_fpos_t", file: !663, line: 30, baseType: !664)
!663 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/_G_config.h", directory: "")
!664 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !663, line: 26, flags: DIFlagFwdDecl, identifier: "_ZTS9_G_fpos_t")
!665 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !666, file: !658, line: 101)
!666 = !DISubprogram(name: "clearerr", scope: !661, file: !661, line: 757, type: !667, flags: DIFlagPrototyped, spFlags: 0)
!667 = !DISubroutineType(types: !668)
!668 = !{null, !669}
!669 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !656, size: 64)
!670 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !671, file: !658, line: 102)
!671 = !DISubprogram(name: "fclose", scope: !661, file: !661, line: 199, type: !672, flags: DIFlagPrototyped, spFlags: 0)
!672 = !DISubroutineType(types: !673)
!673 = !{!18, !669}
!674 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !675, file: !658, line: 103)
!675 = !DISubprogram(name: "feof", scope: !661, file: !661, line: 759, type: !672, flags: DIFlagPrototyped, spFlags: 0)
!676 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !677, file: !658, line: 104)
!677 = !DISubprogram(name: "ferror", scope: !661, file: !661, line: 761, type: !672, flags: DIFlagPrototyped, spFlags: 0)
!678 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !679, file: !658, line: 105)
!679 = !DISubprogram(name: "fflush", scope: !661, file: !661, line: 204, type: !672, flags: DIFlagPrototyped, spFlags: 0)
!680 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !681, file: !658, line: 106)
!681 = !DISubprogram(name: "fgetc", scope: !661, file: !661, line: 477, type: !672, flags: DIFlagPrototyped, spFlags: 0)
!682 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !683, file: !658, line: 107)
!683 = !DISubprogram(name: "fgetpos", scope: !661, file: !661, line: 731, type: !684, flags: DIFlagPrototyped, spFlags: 0)
!684 = !DISubroutineType(types: !685)
!685 = !{!18, !686, !687}
!686 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !669)
!687 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !688)
!688 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !660, size: 64)
!689 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !690, file: !658, line: 108)
!690 = !DISubprogram(name: "fgets", scope: !661, file: !661, line: 564, type: !691, flags: DIFlagPrototyped, spFlags: 0)
!691 = !DISubroutineType(types: !692)
!692 = !{!92, !160, !18, !686}
!693 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !694, file: !658, line: 109)
!694 = !DISubprogram(name: "fopen", scope: !661, file: !661, line: 232, type: !695, flags: DIFlagPrototyped, spFlags: 0)
!695 = !DISubroutineType(types: !696)
!696 = !{!669, !116, !116}
!697 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !698, file: !658, line: 110)
!698 = !DISubprogram(name: "fprintf", scope: !661, file: !661, line: 312, type: !699, flags: DIFlagPrototyped, spFlags: 0)
!699 = !DISubroutineType(types: !700)
!700 = !{!18, !686, !116, null}
!701 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !702, file: !658, line: 111)
!702 = !DISubprogram(name: "fputc", scope: !661, file: !661, line: 517, type: !703, flags: DIFlagPrototyped, spFlags: 0)
!703 = !DISubroutineType(types: !704)
!704 = !{!18, !18, !669}
!705 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !706, file: !658, line: 112)
!706 = !DISubprogram(name: "fputs", scope: !661, file: !661, line: 626, type: !707, flags: DIFlagPrototyped, spFlags: 0)
!707 = !DISubroutineType(types: !708)
!708 = !{!18, !116, !686}
!709 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !710, file: !658, line: 113)
!710 = !DISubprogram(name: "fread", scope: !661, file: !661, line: 646, type: !711, flags: DIFlagPrototyped, spFlags: 0)
!711 = !DISubroutineType(types: !712)
!712 = !{!65, !713, !65, !65, !686}
!713 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !62)
!714 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !715, file: !658, line: 114)
!715 = !DISubprogram(name: "freopen", scope: !661, file: !661, line: 238, type: !716, flags: DIFlagPrototyped, spFlags: 0)
!716 = !DISubroutineType(types: !717)
!717 = !{!669, !116, !116, !686}
!718 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !719, file: !658, line: 115)
!719 = !DISubprogram(name: "fscanf", scope: !661, file: !661, line: 377, type: !699, flags: DIFlagPrototyped, spFlags: 0)
!720 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !721, file: !658, line: 116)
!721 = !DISubprogram(name: "fseek", scope: !661, file: !661, line: 684, type: !722, flags: DIFlagPrototyped, spFlags: 0)
!722 = !DISubroutineType(types: !723)
!723 = !{!18, !669, !29, !18}
!724 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !725, file: !658, line: 117)
!725 = !DISubprogram(name: "fsetpos", scope: !661, file: !661, line: 736, type: !726, flags: DIFlagPrototyped, spFlags: 0)
!726 = !DISubroutineType(types: !727)
!727 = !{!18, !669, !728}
!728 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !729, size: 64)
!729 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !660)
!730 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !731, file: !658, line: 118)
!731 = !DISubprogram(name: "ftell", scope: !661, file: !661, line: 689, type: !732, flags: DIFlagPrototyped, spFlags: 0)
!732 = !DISubroutineType(types: !733)
!733 = !{!29, !669}
!734 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !735, file: !658, line: 119)
!735 = !DISubprogram(name: "fwrite", scope: !661, file: !661, line: 652, type: !736, flags: DIFlagPrototyped, spFlags: 0)
!736 = !DISubroutineType(types: !737)
!737 = !{!65, !738, !65, !65, !686}
!738 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !63)
!739 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !740, file: !658, line: 120)
!740 = !DISubprogram(name: "getc", scope: !661, file: !661, line: 478, type: !672, flags: DIFlagPrototyped, spFlags: 0)
!741 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !742, file: !658, line: 121)
!742 = !DISubprogram(name: "getchar", scope: !661, file: !661, line: 484, type: !129, flags: DIFlagPrototyped, spFlags: 0)
!743 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !744, file: !658, line: 124)
!744 = !DISubprogram(name: "gets", scope: !661, file: !661, line: 577, type: !745, flags: DIFlagPrototyped, spFlags: 0)
!745 = !DISubroutineType(types: !746)
!746 = !{!92, !92}
!747 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !748, file: !658, line: 126)
!748 = !DISubprogram(name: "perror", scope: !661, file: !661, line: 775, type: !749, flags: DIFlagPrototyped, spFlags: 0)
!749 = !DISubroutineType(types: !750)
!750 = !{null, !47}
!751 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !752, file: !658, line: 127)
!752 = !DISubprogram(name: "printf", scope: !661, file: !661, line: 318, type: !753, flags: DIFlagPrototyped, spFlags: 0)
!753 = !DISubroutineType(types: !754)
!754 = !{!18, !116, null}
!755 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !756, file: !658, line: 128)
!756 = !DISubprogram(name: "putc", scope: !661, file: !661, line: 518, type: !703, flags: DIFlagPrototyped, spFlags: 0)
!757 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !758, file: !658, line: 129)
!758 = !DISubprogram(name: "putchar", scope: !661, file: !661, line: 524, type: !16, flags: DIFlagPrototyped, spFlags: 0)
!759 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !760, file: !658, line: 130)
!760 = !DISubprogram(name: "puts", scope: !661, file: !661, line: 632, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!761 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !762, file: !658, line: 131)
!762 = !DISubprogram(name: "remove", scope: !661, file: !661, line: 144, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!763 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !764, file: !658, line: 132)
!764 = !DISubprogram(name: "rename", scope: !661, file: !661, line: 146, type: !765, flags: DIFlagPrototyped, spFlags: 0)
!765 = !DISubroutineType(types: !766)
!766 = !{!18, !47, !47}
!767 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !768, file: !658, line: 133)
!768 = !DISubprogram(name: "rewind", scope: !661, file: !661, line: 694, type: !667, flags: DIFlagPrototyped, spFlags: 0)
!769 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !770, file: !658, line: 134)
!770 = !DISubprogram(name: "scanf", scope: !661, file: !661, line: 383, type: !753, flags: DIFlagPrototyped, spFlags: 0)
!771 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !772, file: !658, line: 135)
!772 = !DISubprogram(name: "setbuf", scope: !661, file: !661, line: 290, type: !773, flags: DIFlagPrototyped, spFlags: 0)
!773 = !DISubroutineType(types: !774)
!774 = !{null, !686, !160}
!775 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !776, file: !658, line: 136)
!776 = !DISubprogram(name: "setvbuf", scope: !661, file: !661, line: 294, type: !777, flags: DIFlagPrototyped, spFlags: 0)
!777 = !DISubroutineType(types: !778)
!778 = !{!18, !686, !160, !18, !65}
!779 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !780, file: !658, line: 137)
!780 = !DISubprogram(name: "sprintf", scope: !661, file: !661, line: 320, type: !781, flags: DIFlagPrototyped, spFlags: 0)
!781 = !DISubroutineType(types: !782)
!782 = !{!18, !160, !116, null}
!783 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !784, file: !658, line: 138)
!784 = !DISubprogram(name: "sscanf", scope: !661, file: !661, line: 385, type: !785, flags: DIFlagPrototyped, spFlags: 0)
!785 = !DISubroutineType(types: !786)
!786 = !{!18, !116, !116, null}
!787 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !788, file: !658, line: 139)
!788 = !DISubprogram(name: "tmpfile", scope: !661, file: !661, line: 159, type: !789, flags: DIFlagPrototyped, spFlags: 0)
!789 = !DISubroutineType(types: !790)
!790 = !{!669}
!791 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !792, file: !658, line: 141)
!792 = !DISubprogram(name: "tmpnam", scope: !661, file: !661, line: 173, type: !745, flags: DIFlagPrototyped, spFlags: 0)
!793 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !794, file: !658, line: 143)
!794 = !DISubprogram(name: "ungetc", scope: !661, file: !661, line: 639, type: !703, flags: DIFlagPrototyped, spFlags: 0)
!795 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !796, file: !658, line: 144)
!796 = !DISubprogram(name: "vfprintf", scope: !661, file: !661, line: 327, type: !797, flags: DIFlagPrototyped, spFlags: 0)
!797 = !DISubroutineType(types: !798)
!798 = !{!18, !686, !116, !386}
!799 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !800, file: !658, line: 145)
!800 = !DISubprogram(name: "vprintf", scope: !661, file: !661, line: 333, type: !801, flags: DIFlagPrototyped, spFlags: 0)
!801 = !DISubroutineType(types: !802)
!802 = !{!18, !116, !386}
!803 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !804, file: !658, line: 146)
!804 = !DISubprogram(name: "vsprintf", scope: !661, file: !661, line: 335, type: !805, flags: DIFlagPrototyped, spFlags: 0)
!805 = !DISubroutineType(types: !806)
!806 = !{!18, !160, !116, !386}
!807 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !169, entity: !808, file: !658, line: 175)
!808 = !DISubprogram(name: "snprintf", scope: !661, file: !661, line: 340, type: !809, flags: DIFlagPrototyped, spFlags: 0)
!809 = !DISubroutineType(types: !810)
!810 = !{!18, !160, !65, !116, null}
!811 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !169, entity: !812, file: !658, line: 176)
!812 = !DISubprogram(name: "vfscanf", scope: !661, file: !661, line: 420, type: !797, flags: DIFlagPrototyped, spFlags: 0)
!813 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !169, entity: !814, file: !658, line: 177)
!814 = !DISubprogram(name: "vscanf", scope: !661, file: !661, line: 428, type: !801, flags: DIFlagPrototyped, spFlags: 0)
!815 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !169, entity: !816, file: !658, line: 178)
!816 = !DISubprogram(name: "vsnprintf", scope: !661, file: !661, line: 344, type: !817, flags: DIFlagPrototyped, spFlags: 0)
!817 = !DISubroutineType(types: !818)
!818 = !{!18, !160, !65, !116, !386}
!819 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !169, entity: !820, file: !658, line: 179)
!820 = !DISubprogram(name: "vsscanf", scope: !661, file: !661, line: 432, type: !821, flags: DIFlagPrototyped, spFlags: 0)
!821 = !DISubroutineType(types: !822)
!822 = !{!18, !116, !116, !386}
!823 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !808, file: !658, line: 185)
!824 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !812, file: !658, line: 186)
!825 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !814, file: !658, line: 187)
!826 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !816, file: !658, line: 188)
!827 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !820, file: !658, line: 189)
!828 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !829, file: !833, line: 83)
!829 = !DISubprogram(name: "acos", scope: !830, file: !830, line: 53, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!830 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/mathcalls.h", directory: "")
!831 = !DISubroutineType(types: !832)
!832 = !{!46, !46}
!833 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/c++/7.5.0/cmath", directory: "")
!834 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !835, file: !833, line: 102)
!835 = !DISubprogram(name: "asin", scope: !830, file: !830, line: 55, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!836 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !837, file: !833, line: 121)
!837 = !DISubprogram(name: "atan", scope: !830, file: !830, line: 57, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!838 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !839, file: !833, line: 140)
!839 = !DISubprogram(name: "atan2", scope: !830, file: !830, line: 59, type: !840, flags: DIFlagPrototyped, spFlags: 0)
!840 = !DISubroutineType(types: !841)
!841 = !{!46, !46, !46}
!842 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !843, file: !833, line: 161)
!843 = !DISubprogram(name: "ceil", scope: !830, file: !830, line: 159, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!844 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !845, file: !833, line: 180)
!845 = !DISubprogram(name: "cos", scope: !830, file: !830, line: 62, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!846 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !847, file: !833, line: 199)
!847 = !DISubprogram(name: "cosh", scope: !830, file: !830, line: 71, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!848 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !849, file: !833, line: 218)
!849 = !DISubprogram(name: "exp", scope: !830, file: !830, line: 95, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!850 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !851, file: !833, line: 237)
!851 = !DISubprogram(name: "fabs", scope: !830, file: !830, line: 162, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!852 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !853, file: !833, line: 256)
!853 = !DISubprogram(name: "floor", scope: !830, file: !830, line: 165, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!854 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !855, file: !833, line: 275)
!855 = !DISubprogram(name: "fmod", scope: !830, file: !830, line: 168, type: !840, flags: DIFlagPrototyped, spFlags: 0)
!856 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !857, file: !833, line: 296)
!857 = !DISubprogram(name: "frexp", scope: !830, file: !830, line: 98, type: !858, flags: DIFlagPrototyped, spFlags: 0)
!858 = !DISubroutineType(types: !859)
!859 = !{!46, !46, !860}
!860 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!861 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !862, file: !833, line: 315)
!862 = !DISubprogram(name: "ldexp", scope: !830, file: !830, line: 101, type: !863, flags: DIFlagPrototyped, spFlags: 0)
!863 = !DISubroutineType(types: !864)
!864 = !{!46, !46, !18}
!865 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !866, file: !833, line: 334)
!866 = !DISubprogram(name: "log", scope: !830, file: !830, line: 104, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!867 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !868, file: !833, line: 353)
!868 = !DISubprogram(name: "log10", scope: !830, file: !830, line: 107, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!869 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !870, file: !833, line: 372)
!870 = !DISubprogram(name: "modf", scope: !830, file: !830, line: 110, type: !871, flags: DIFlagPrototyped, spFlags: 0)
!871 = !DISubroutineType(types: !872)
!872 = !{!46, !46, !873}
!873 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 64)
!874 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !875, file: !833, line: 384)
!875 = !DISubprogram(name: "pow", scope: !830, file: !830, line: 140, type: !840, flags: DIFlagPrototyped, spFlags: 0)
!876 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !877, file: !833, line: 421)
!877 = !DISubprogram(name: "sin", scope: !830, file: !830, line: 64, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!878 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !879, file: !833, line: 440)
!879 = !DISubprogram(name: "sinh", scope: !830, file: !830, line: 73, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!880 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !881, file: !833, line: 459)
!881 = !DISubprogram(name: "sqrt", scope: !830, file: !830, line: 143, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!882 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !883, file: !833, line: 478)
!883 = !DISubprogram(name: "tan", scope: !830, file: !830, line: 66, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!884 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !885, file: !833, line: 497)
!885 = !DISubprogram(name: "tanh", scope: !830, file: !830, line: 75, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!886 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !887, file: !833, line: 1080)
!887 = !DIDerivedType(tag: DW_TAG_typedef, name: "double_t", file: !888, line: 150, baseType: !46)
!888 = !DIFile(filename: "/usr/include/math.h", directory: "")
!889 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !890, file: !833, line: 1081)
!890 = !DIDerivedType(tag: DW_TAG_typedef, name: "float_t", file: !888, line: 149, baseType: !203)
!891 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !892, file: !833, line: 1084)
!892 = !DISubprogram(name: "acosh", scope: !830, file: !830, line: 85, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!893 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !894, file: !833, line: 1085)
!894 = !DISubprogram(name: "acoshf", scope: !830, file: !830, line: 85, type: !895, flags: DIFlagPrototyped, spFlags: 0)
!895 = !DISubroutineType(types: !896)
!896 = !{!203, !203}
!897 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !898, file: !833, line: 1086)
!898 = !DISubprogram(name: "acoshl", scope: !830, file: !830, line: 85, type: !899, flags: DIFlagPrototyped, spFlags: 0)
!899 = !DISubroutineType(types: !900)
!900 = !{!208, !208}
!901 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !902, file: !833, line: 1088)
!902 = !DISubprogram(name: "asinh", scope: !830, file: !830, line: 87, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!903 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !904, file: !833, line: 1089)
!904 = !DISubprogram(name: "asinhf", scope: !830, file: !830, line: 87, type: !895, flags: DIFlagPrototyped, spFlags: 0)
!905 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !906, file: !833, line: 1090)
!906 = !DISubprogram(name: "asinhl", scope: !830, file: !830, line: 87, type: !899, flags: DIFlagPrototyped, spFlags: 0)
!907 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !908, file: !833, line: 1092)
!908 = !DISubprogram(name: "atanh", scope: !830, file: !830, line: 89, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!909 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !910, file: !833, line: 1093)
!910 = !DISubprogram(name: "atanhf", scope: !830, file: !830, line: 89, type: !895, flags: DIFlagPrototyped, spFlags: 0)
!911 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !912, file: !833, line: 1094)
!912 = !DISubprogram(name: "atanhl", scope: !830, file: !830, line: 89, type: !899, flags: DIFlagPrototyped, spFlags: 0)
!913 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !914, file: !833, line: 1096)
!914 = !DISubprogram(name: "cbrt", scope: !830, file: !830, line: 152, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!915 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !916, file: !833, line: 1097)
!916 = !DISubprogram(name: "cbrtf", scope: !830, file: !830, line: 152, type: !895, flags: DIFlagPrototyped, spFlags: 0)
!917 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !918, file: !833, line: 1098)
!918 = !DISubprogram(name: "cbrtl", scope: !830, file: !830, line: 152, type: !899, flags: DIFlagPrototyped, spFlags: 0)
!919 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !920, file: !833, line: 1100)
!920 = !DISubprogram(name: "copysign", scope: !830, file: !830, line: 196, type: !840, flags: DIFlagPrototyped, spFlags: 0)
!921 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !922, file: !833, line: 1101)
!922 = !DISubprogram(name: "copysignf", scope: !830, file: !830, line: 196, type: !923, flags: DIFlagPrototyped, spFlags: 0)
!923 = !DISubroutineType(types: !924)
!924 = !{!203, !203, !203}
!925 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !926, file: !833, line: 1102)
!926 = !DISubprogram(name: "copysignl", scope: !830, file: !830, line: 196, type: !927, flags: DIFlagPrototyped, spFlags: 0)
!927 = !DISubroutineType(types: !928)
!928 = !{!208, !208, !208}
!929 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !930, file: !833, line: 1104)
!930 = !DISubprogram(name: "erf", scope: !830, file: !830, line: 228, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!931 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !932, file: !833, line: 1105)
!932 = !DISubprogram(name: "erff", scope: !830, file: !830, line: 228, type: !895, flags: DIFlagPrototyped, spFlags: 0)
!933 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !934, file: !833, line: 1106)
!934 = !DISubprogram(name: "erfl", scope: !830, file: !830, line: 228, type: !899, flags: DIFlagPrototyped, spFlags: 0)
!935 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !936, file: !833, line: 1108)
!936 = !DISubprogram(name: "erfc", scope: !830, file: !830, line: 229, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!937 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !938, file: !833, line: 1109)
!938 = !DISubprogram(name: "erfcf", scope: !830, file: !830, line: 229, type: !895, flags: DIFlagPrototyped, spFlags: 0)
!939 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !940, file: !833, line: 1110)
!940 = !DISubprogram(name: "erfcl", scope: !830, file: !830, line: 229, type: !899, flags: DIFlagPrototyped, spFlags: 0)
!941 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !942, file: !833, line: 1112)
!942 = !DISubprogram(name: "exp2", scope: !830, file: !830, line: 130, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!943 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !944, file: !833, line: 1113)
!944 = !DISubprogram(name: "exp2f", scope: !830, file: !830, line: 130, type: !895, flags: DIFlagPrototyped, spFlags: 0)
!945 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !946, file: !833, line: 1114)
!946 = !DISubprogram(name: "exp2l", scope: !830, file: !830, line: 130, type: !899, flags: DIFlagPrototyped, spFlags: 0)
!947 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !948, file: !833, line: 1116)
!948 = !DISubprogram(name: "expm1", scope: !830, file: !830, line: 119, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!949 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !950, file: !833, line: 1117)
!950 = !DISubprogram(name: "expm1f", scope: !830, file: !830, line: 119, type: !895, flags: DIFlagPrototyped, spFlags: 0)
!951 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !952, file: !833, line: 1118)
!952 = !DISubprogram(name: "expm1l", scope: !830, file: !830, line: 119, type: !899, flags: DIFlagPrototyped, spFlags: 0)
!953 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !954, file: !833, line: 1120)
!954 = !DISubprogram(name: "fdim", scope: !830, file: !830, line: 326, type: !840, flags: DIFlagPrototyped, spFlags: 0)
!955 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !956, file: !833, line: 1121)
!956 = !DISubprogram(name: "fdimf", scope: !830, file: !830, line: 326, type: !923, flags: DIFlagPrototyped, spFlags: 0)
!957 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !958, file: !833, line: 1122)
!958 = !DISubprogram(name: "fdiml", scope: !830, file: !830, line: 326, type: !927, flags: DIFlagPrototyped, spFlags: 0)
!959 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !960, file: !833, line: 1124)
!960 = !DISubprogram(name: "fma", scope: !830, file: !830, line: 335, type: !961, flags: DIFlagPrototyped, spFlags: 0)
!961 = !DISubroutineType(types: !962)
!962 = !{!46, !46, !46, !46}
!963 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !964, file: !833, line: 1125)
!964 = !DISubprogram(name: "fmaf", scope: !830, file: !830, line: 335, type: !965, flags: DIFlagPrototyped, spFlags: 0)
!965 = !DISubroutineType(types: !966)
!966 = !{!203, !203, !203, !203}
!967 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !968, file: !833, line: 1126)
!968 = !DISubprogram(name: "fmal", scope: !830, file: !830, line: 335, type: !969, flags: DIFlagPrototyped, spFlags: 0)
!969 = !DISubroutineType(types: !970)
!970 = !{!208, !208, !208, !208}
!971 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !972, file: !833, line: 1128)
!972 = !DISubprogram(name: "fmax", scope: !830, file: !830, line: 329, type: !840, flags: DIFlagPrototyped, spFlags: 0)
!973 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !974, file: !833, line: 1129)
!974 = !DISubprogram(name: "fmaxf", scope: !830, file: !830, line: 329, type: !923, flags: DIFlagPrototyped, spFlags: 0)
!975 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !976, file: !833, line: 1130)
!976 = !DISubprogram(name: "fmaxl", scope: !830, file: !830, line: 329, type: !927, flags: DIFlagPrototyped, spFlags: 0)
!977 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !978, file: !833, line: 1132)
!978 = !DISubprogram(name: "fmin", scope: !830, file: !830, line: 332, type: !840, flags: DIFlagPrototyped, spFlags: 0)
!979 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !980, file: !833, line: 1133)
!980 = !DISubprogram(name: "fminf", scope: !830, file: !830, line: 332, type: !923, flags: DIFlagPrototyped, spFlags: 0)
!981 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !982, file: !833, line: 1134)
!982 = !DISubprogram(name: "fminl", scope: !830, file: !830, line: 332, type: !927, flags: DIFlagPrototyped, spFlags: 0)
!983 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !984, file: !833, line: 1136)
!984 = !DISubprogram(name: "hypot", scope: !830, file: !830, line: 147, type: !840, flags: DIFlagPrototyped, spFlags: 0)
!985 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !986, file: !833, line: 1137)
!986 = !DISubprogram(name: "hypotf", scope: !830, file: !830, line: 147, type: !923, flags: DIFlagPrototyped, spFlags: 0)
!987 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !988, file: !833, line: 1138)
!988 = !DISubprogram(name: "hypotl", scope: !830, file: !830, line: 147, type: !927, flags: DIFlagPrototyped, spFlags: 0)
!989 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !990, file: !833, line: 1140)
!990 = !DISubprogram(name: "ilogb", scope: !830, file: !830, line: 280, type: !991, flags: DIFlagPrototyped, spFlags: 0)
!991 = !DISubroutineType(types: !992)
!992 = !{!18, !46}
!993 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !994, file: !833, line: 1141)
!994 = !DISubprogram(name: "ilogbf", scope: !830, file: !830, line: 280, type: !995, flags: DIFlagPrototyped, spFlags: 0)
!995 = !DISubroutineType(types: !996)
!996 = !{!18, !203}
!997 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !998, file: !833, line: 1142)
!998 = !DISubprogram(name: "ilogbl", scope: !830, file: !830, line: 280, type: !999, flags: DIFlagPrototyped, spFlags: 0)
!999 = !DISubroutineType(types: !1000)
!1000 = !{!18, !208}
!1001 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1002, file: !833, line: 1144)
!1002 = !DISubprogram(name: "lgamma", scope: !830, file: !830, line: 230, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!1003 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1004, file: !833, line: 1145)
!1004 = !DISubprogram(name: "lgammaf", scope: !830, file: !830, line: 230, type: !895, flags: DIFlagPrototyped, spFlags: 0)
!1005 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1006, file: !833, line: 1146)
!1006 = !DISubprogram(name: "lgammal", scope: !830, file: !830, line: 230, type: !899, flags: DIFlagPrototyped, spFlags: 0)
!1007 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1008, file: !833, line: 1149)
!1008 = !DISubprogram(name: "llrint", scope: !830, file: !830, line: 316, type: !1009, flags: DIFlagPrototyped, spFlags: 0)
!1009 = !DISubroutineType(types: !1010)
!1010 = !{!174, !46}
!1011 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1012, file: !833, line: 1150)
!1012 = !DISubprogram(name: "llrintf", scope: !830, file: !830, line: 316, type: !1013, flags: DIFlagPrototyped, spFlags: 0)
!1013 = !DISubroutineType(types: !1014)
!1014 = !{!174, !203}
!1015 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1016, file: !833, line: 1151)
!1016 = !DISubprogram(name: "llrintl", scope: !830, file: !830, line: 316, type: !1017, flags: DIFlagPrototyped, spFlags: 0)
!1017 = !DISubroutineType(types: !1018)
!1018 = !{!174, !208}
!1019 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1020, file: !833, line: 1153)
!1020 = !DISubprogram(name: "llround", scope: !830, file: !830, line: 322, type: !1009, flags: DIFlagPrototyped, spFlags: 0)
!1021 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1022, file: !833, line: 1154)
!1022 = !DISubprogram(name: "llroundf", scope: !830, file: !830, line: 322, type: !1013, flags: DIFlagPrototyped, spFlags: 0)
!1023 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1024, file: !833, line: 1155)
!1024 = !DISubprogram(name: "llroundl", scope: !830, file: !830, line: 322, type: !1017, flags: DIFlagPrototyped, spFlags: 0)
!1025 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1026, file: !833, line: 1158)
!1026 = !DISubprogram(name: "log1p", scope: !830, file: !830, line: 122, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!1027 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1028, file: !833, line: 1159)
!1028 = !DISubprogram(name: "log1pf", scope: !830, file: !830, line: 122, type: !895, flags: DIFlagPrototyped, spFlags: 0)
!1029 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1030, file: !833, line: 1160)
!1030 = !DISubprogram(name: "log1pl", scope: !830, file: !830, line: 122, type: !899, flags: DIFlagPrototyped, spFlags: 0)
!1031 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1032, file: !833, line: 1162)
!1032 = !DISubprogram(name: "log2", scope: !830, file: !830, line: 133, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!1033 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1034, file: !833, line: 1163)
!1034 = !DISubprogram(name: "log2f", scope: !830, file: !830, line: 133, type: !895, flags: DIFlagPrototyped, spFlags: 0)
!1035 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1036, file: !833, line: 1164)
!1036 = !DISubprogram(name: "log2l", scope: !830, file: !830, line: 133, type: !899, flags: DIFlagPrototyped, spFlags: 0)
!1037 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1038, file: !833, line: 1166)
!1038 = !DISubprogram(name: "logb", scope: !830, file: !830, line: 125, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!1039 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1040, file: !833, line: 1167)
!1040 = !DISubprogram(name: "logbf", scope: !830, file: !830, line: 125, type: !895, flags: DIFlagPrototyped, spFlags: 0)
!1041 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1042, file: !833, line: 1168)
!1042 = !DISubprogram(name: "logbl", scope: !830, file: !830, line: 125, type: !899, flags: DIFlagPrototyped, spFlags: 0)
!1043 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1044, file: !833, line: 1170)
!1044 = !DISubprogram(name: "lrint", scope: !830, file: !830, line: 314, type: !1045, flags: DIFlagPrototyped, spFlags: 0)
!1045 = !DISubroutineType(types: !1046)
!1046 = !{!29, !46}
!1047 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1048, file: !833, line: 1171)
!1048 = !DISubprogram(name: "lrintf", scope: !830, file: !830, line: 314, type: !1049, flags: DIFlagPrototyped, spFlags: 0)
!1049 = !DISubroutineType(types: !1050)
!1050 = !{!29, !203}
!1051 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1052, file: !833, line: 1172)
!1052 = !DISubprogram(name: "lrintl", scope: !830, file: !830, line: 314, type: !1053, flags: DIFlagPrototyped, spFlags: 0)
!1053 = !DISubroutineType(types: !1054)
!1054 = !{!29, !208}
!1055 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1056, file: !833, line: 1174)
!1056 = !DISubprogram(name: "lround", scope: !830, file: !830, line: 320, type: !1045, flags: DIFlagPrototyped, spFlags: 0)
!1057 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1058, file: !833, line: 1175)
!1058 = !DISubprogram(name: "lroundf", scope: !830, file: !830, line: 320, type: !1049, flags: DIFlagPrototyped, spFlags: 0)
!1059 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1060, file: !833, line: 1176)
!1060 = !DISubprogram(name: "lroundl", scope: !830, file: !830, line: 320, type: !1053, flags: DIFlagPrototyped, spFlags: 0)
!1061 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1062, file: !833, line: 1178)
!1062 = !DISubprogram(name: "nan", scope: !830, file: !830, line: 201, type: !44, flags: DIFlagPrototyped, spFlags: 0)
!1063 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1064, file: !833, line: 1179)
!1064 = !DISubprogram(name: "nanf", scope: !830, file: !830, line: 201, type: !1065, flags: DIFlagPrototyped, spFlags: 0)
!1065 = !DISubroutineType(types: !1066)
!1066 = !{!203, !47}
!1067 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1068, file: !833, line: 1180)
!1068 = !DISubprogram(name: "nanl", scope: !830, file: !830, line: 201, type: !1069, flags: DIFlagPrototyped, spFlags: 0)
!1069 = !DISubroutineType(types: !1070)
!1070 = !{!208, !47}
!1071 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1072, file: !833, line: 1182)
!1072 = !DISubprogram(name: "nearbyint", scope: !830, file: !830, line: 294, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!1073 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1074, file: !833, line: 1183)
!1074 = !DISubprogram(name: "nearbyintf", scope: !830, file: !830, line: 294, type: !895, flags: DIFlagPrototyped, spFlags: 0)
!1075 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1076, file: !833, line: 1184)
!1076 = !DISubprogram(name: "nearbyintl", scope: !830, file: !830, line: 294, type: !899, flags: DIFlagPrototyped, spFlags: 0)
!1077 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1078, file: !833, line: 1186)
!1078 = !DISubprogram(name: "nextafter", scope: !830, file: !830, line: 259, type: !840, flags: DIFlagPrototyped, spFlags: 0)
!1079 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1080, file: !833, line: 1187)
!1080 = !DISubprogram(name: "nextafterf", scope: !830, file: !830, line: 259, type: !923, flags: DIFlagPrototyped, spFlags: 0)
!1081 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1082, file: !833, line: 1188)
!1082 = !DISubprogram(name: "nextafterl", scope: !830, file: !830, line: 259, type: !927, flags: DIFlagPrototyped, spFlags: 0)
!1083 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1084, file: !833, line: 1190)
!1084 = !DISubprogram(name: "nexttoward", scope: !830, file: !830, line: 261, type: !1085, flags: DIFlagPrototyped, spFlags: 0)
!1085 = !DISubroutineType(types: !1086)
!1086 = !{!46, !46, !208}
!1087 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1088, file: !833, line: 1191)
!1088 = !DISubprogram(name: "nexttowardf", scope: !830, file: !830, line: 261, type: !1089, flags: DIFlagPrototyped, spFlags: 0)
!1089 = !DISubroutineType(types: !1090)
!1090 = !{!203, !203, !208}
!1091 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1092, file: !833, line: 1192)
!1092 = !DISubprogram(name: "nexttowardl", scope: !830, file: !830, line: 261, type: !927, flags: DIFlagPrototyped, spFlags: 0)
!1093 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1094, file: !833, line: 1194)
!1094 = !DISubprogram(name: "remainder", scope: !830, file: !830, line: 272, type: !840, flags: DIFlagPrototyped, spFlags: 0)
!1095 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1096, file: !833, line: 1195)
!1096 = !DISubprogram(name: "remainderf", scope: !830, file: !830, line: 272, type: !923, flags: DIFlagPrototyped, spFlags: 0)
!1097 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1098, file: !833, line: 1196)
!1098 = !DISubprogram(name: "remainderl", scope: !830, file: !830, line: 272, type: !927, flags: DIFlagPrototyped, spFlags: 0)
!1099 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1100, file: !833, line: 1198)
!1100 = !DISubprogram(name: "remquo", scope: !830, file: !830, line: 307, type: !1101, flags: DIFlagPrototyped, spFlags: 0)
!1101 = !DISubroutineType(types: !1102)
!1102 = !{!46, !46, !46, !860}
!1103 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1104, file: !833, line: 1199)
!1104 = !DISubprogram(name: "remquof", scope: !830, file: !830, line: 307, type: !1105, flags: DIFlagPrototyped, spFlags: 0)
!1105 = !DISubroutineType(types: !1106)
!1106 = !{!203, !203, !203, !860}
!1107 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1108, file: !833, line: 1200)
!1108 = !DISubprogram(name: "remquol", scope: !830, file: !830, line: 307, type: !1109, flags: DIFlagPrototyped, spFlags: 0)
!1109 = !DISubroutineType(types: !1110)
!1110 = !{!208, !208, !208, !860}
!1111 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1112, file: !833, line: 1202)
!1112 = !DISubprogram(name: "rint", scope: !830, file: !830, line: 256, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!1113 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1114, file: !833, line: 1203)
!1114 = !DISubprogram(name: "rintf", scope: !830, file: !830, line: 256, type: !895, flags: DIFlagPrototyped, spFlags: 0)
!1115 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1116, file: !833, line: 1204)
!1116 = !DISubprogram(name: "rintl", scope: !830, file: !830, line: 256, type: !899, flags: DIFlagPrototyped, spFlags: 0)
!1117 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1118, file: !833, line: 1206)
!1118 = !DISubprogram(name: "round", scope: !830, file: !830, line: 298, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!1119 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1120, file: !833, line: 1207)
!1120 = !DISubprogram(name: "roundf", scope: !830, file: !830, line: 298, type: !895, flags: DIFlagPrototyped, spFlags: 0)
!1121 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1122, file: !833, line: 1208)
!1122 = !DISubprogram(name: "roundl", scope: !830, file: !830, line: 298, type: !899, flags: DIFlagPrototyped, spFlags: 0)
!1123 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1124, file: !833, line: 1210)
!1124 = !DISubprogram(name: "scalbln", scope: !830, file: !830, line: 290, type: !1125, flags: DIFlagPrototyped, spFlags: 0)
!1125 = !DISubroutineType(types: !1126)
!1126 = !{!46, !46, !29}
!1127 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1128, file: !833, line: 1211)
!1128 = !DISubprogram(name: "scalblnf", scope: !830, file: !830, line: 290, type: !1129, flags: DIFlagPrototyped, spFlags: 0)
!1129 = !DISubroutineType(types: !1130)
!1130 = !{!203, !203, !29}
!1131 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1132, file: !833, line: 1212)
!1132 = !DISubprogram(name: "scalblnl", scope: !830, file: !830, line: 290, type: !1133, flags: DIFlagPrototyped, spFlags: 0)
!1133 = !DISubroutineType(types: !1134)
!1134 = !{!208, !208, !29}
!1135 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1136, file: !833, line: 1214)
!1136 = !DISubprogram(name: "scalbn", scope: !830, file: !830, line: 276, type: !863, flags: DIFlagPrototyped, spFlags: 0)
!1137 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1138, file: !833, line: 1215)
!1138 = !DISubprogram(name: "scalbnf", scope: !830, file: !830, line: 276, type: !1139, flags: DIFlagPrototyped, spFlags: 0)
!1139 = !DISubroutineType(types: !1140)
!1140 = !{!203, !203, !18}
!1141 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1142, file: !833, line: 1216)
!1142 = !DISubprogram(name: "scalbnl", scope: !830, file: !830, line: 276, type: !1143, flags: DIFlagPrototyped, spFlags: 0)
!1143 = !DISubroutineType(types: !1144)
!1144 = !{!208, !208, !18}
!1145 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1146, file: !833, line: 1218)
!1146 = !DISubprogram(name: "tgamma", scope: !830, file: !830, line: 235, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!1147 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1148, file: !833, line: 1219)
!1148 = !DISubprogram(name: "tgammaf", scope: !830, file: !830, line: 235, type: !895, flags: DIFlagPrototyped, spFlags: 0)
!1149 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1150, file: !833, line: 1220)
!1150 = !DISubprogram(name: "tgammal", scope: !830, file: !830, line: 235, type: !899, flags: DIFlagPrototyped, spFlags: 0)
!1151 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1152, file: !833, line: 1222)
!1152 = !DISubprogram(name: "trunc", scope: !830, file: !830, line: 302, type: !831, flags: DIFlagPrototyped, spFlags: 0)
!1153 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1154, file: !833, line: 1223)
!1154 = !DISubprogram(name: "truncf", scope: !830, file: !830, line: 302, type: !895, flags: DIFlagPrototyped, spFlags: 0)
!1155 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1156, file: !833, line: 1224)
!1156 = !DISubprogram(name: "truncl", scope: !830, file: !830, line: 302, type: !899, flags: DIFlagPrototyped, spFlags: 0)
!1157 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1158, file: !1161, line: 58)
!1158 = !DIDerivedType(tag: DW_TAG_typedef, name: "fenv_t", file: !1159, line: 94, baseType: !1160)
!1159 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/fenv.h", directory: "")
!1160 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !1159, line: 75, flags: DIFlagFwdDecl, identifier: "_ZTS6fenv_t")
!1161 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/c++/7.5.0/fenv.h", directory: "")
!1162 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1163, file: !1161, line: 59)
!1163 = !DIDerivedType(tag: DW_TAG_typedef, name: "fexcept_t", file: !1159, line: 68, baseType: !582)
!1164 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1165, file: !1161, line: 62)
!1165 = !DISubprogram(name: "feclearexcept", scope: !1166, file: !1166, line: 71, type: !16, flags: DIFlagPrototyped, spFlags: 0)
!1166 = !DIFile(filename: "/usr/include/fenv.h", directory: "")
!1167 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1168, file: !1161, line: 63)
!1168 = !DISubprogram(name: "fegetexceptflag", scope: !1166, file: !1166, line: 75, type: !1169, flags: DIFlagPrototyped, spFlags: 0)
!1169 = !DISubroutineType(types: !1170)
!1170 = !{!18, !1171, !18}
!1171 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1163, size: 64)
!1172 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1173, file: !1161, line: 64)
!1173 = !DISubprogram(name: "feraiseexcept", scope: !1166, file: !1166, line: 78, type: !16, flags: DIFlagPrototyped, spFlags: 0)
!1174 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1175, file: !1161, line: 65)
!1175 = !DISubprogram(name: "fesetexceptflag", scope: !1166, file: !1166, line: 88, type: !1176, flags: DIFlagPrototyped, spFlags: 0)
!1176 = !DISubroutineType(types: !1177)
!1177 = !{!18, !1178, !18}
!1178 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1179, size: 64)
!1179 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !1163)
!1180 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1181, file: !1161, line: 66)
!1181 = !DISubprogram(name: "fetestexcept", scope: !1166, file: !1166, line: 92, type: !16, flags: DIFlagPrototyped, spFlags: 0)
!1182 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1183, file: !1161, line: 68)
!1183 = !DISubprogram(name: "fegetround", scope: !1166, file: !1166, line: 104, type: !129, flags: DIFlagPrototyped, spFlags: 0)
!1184 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1185, file: !1161, line: 69)
!1185 = !DISubprogram(name: "fesetround", scope: !1166, file: !1166, line: 107, type: !16, flags: DIFlagPrototyped, spFlags: 0)
!1186 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1187, file: !1161, line: 71)
!1187 = !DISubprogram(name: "fegetenv", scope: !1166, file: !1166, line: 114, type: !1188, flags: DIFlagPrototyped, spFlags: 0)
!1188 = !DISubroutineType(types: !1189)
!1189 = !{!18, !1190}
!1190 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1158, size: 64)
!1191 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1192, file: !1161, line: 72)
!1192 = !DISubprogram(name: "feholdexcept", scope: !1166, file: !1166, line: 119, type: !1188, flags: DIFlagPrototyped, spFlags: 0)
!1193 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1194, file: !1161, line: 73)
!1194 = !DISubprogram(name: "fesetenv", scope: !1166, file: !1166, line: 123, type: !1195, flags: DIFlagPrototyped, spFlags: 0)
!1195 = !DISubroutineType(types: !1196)
!1196 = !{!18, !1197}
!1197 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1198, size: 64)
!1198 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !1158)
!1199 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1200, file: !1161, line: 74)
!1200 = !DISubprogram(name: "feupdateenv", scope: !1166, file: !1166, line: 128, type: !1195, flags: DIFlagPrototyped, spFlags: 0)
!1201 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1158, file: !1202, line: 61)
!1202 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/c++/7.5.0/cfenv", directory: "")
!1203 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1163, file: !1202, line: 62)
!1204 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1165, file: !1202, line: 65)
!1205 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1168, file: !1202, line: 66)
!1206 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1173, file: !1202, line: 67)
!1207 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1175, file: !1202, line: 68)
!1208 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1181, file: !1202, line: 69)
!1209 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1183, file: !1202, line: 71)
!1210 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1185, file: !1202, line: 72)
!1211 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1187, file: !1202, line: 74)
!1212 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1192, file: !1202, line: 75)
!1213 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1194, file: !1202, line: 76)
!1214 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1200, file: !1202, line: 77)
!1215 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1216, file: !1220, line: 75)
!1216 = !DISubprogram(name: "memchr", scope: !1217, file: !1217, line: 90, type: !1218, flags: DIFlagPrototyped, spFlags: 0)
!1217 = !DIFile(filename: "/usr/include/string.h", directory: "")
!1218 = !DISubroutineType(types: !1219)
!1219 = !{!62, !63, !18, !65}
!1220 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.5.0/../../../../include/c++/7.5.0/cstring", directory: "")
!1221 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1222, file: !1220, line: 76)
!1222 = !DISubprogram(name: "memcmp", scope: !1217, file: !1217, line: 63, type: !1223, flags: DIFlagPrototyped, spFlags: 0)
!1223 = !DISubroutineType(types: !1224)
!1224 = !{!18, !63, !63, !65}
!1225 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1226, file: !1220, line: 77)
!1226 = !DISubprogram(name: "memcpy", scope: !1217, file: !1217, line: 42, type: !1227, flags: DIFlagPrototyped, spFlags: 0)
!1227 = !DISubroutineType(types: !1228)
!1228 = !{!62, !713, !738, !65}
!1229 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1230, file: !1220, line: 78)
!1230 = !DISubprogram(name: "memmove", scope: !1217, file: !1217, line: 46, type: !1231, flags: DIFlagPrototyped, spFlags: 0)
!1231 = !DISubroutineType(types: !1232)
!1232 = !{!62, !62, !63, !65}
!1233 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1234, file: !1220, line: 79)
!1234 = !DISubprogram(name: "memset", scope: !1217, file: !1217, line: 60, type: !1235, flags: DIFlagPrototyped, spFlags: 0)
!1235 = !DISubroutineType(types: !1236)
!1236 = !{!62, !62, !18, !65}
!1237 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1238, file: !1220, line: 80)
!1238 = !DISubprogram(name: "strcat", scope: !1217, file: !1217, line: 129, type: !1239, flags: DIFlagPrototyped, spFlags: 0)
!1239 = !DISubroutineType(types: !1240)
!1240 = !{!92, !160, !116}
!1241 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1242, file: !1220, line: 81)
!1242 = !DISubprogram(name: "strcmp", scope: !1217, file: !1217, line: 136, type: !765, flags: DIFlagPrototyped, spFlags: 0)
!1243 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1244, file: !1220, line: 82)
!1244 = !DISubprogram(name: "strcoll", scope: !1217, file: !1217, line: 143, type: !765, flags: DIFlagPrototyped, spFlags: 0)
!1245 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1246, file: !1220, line: 83)
!1246 = !DISubprogram(name: "strcpy", scope: !1217, file: !1217, line: 121, type: !1239, flags: DIFlagPrototyped, spFlags: 0)
!1247 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1248, file: !1220, line: 84)
!1248 = !DISubprogram(name: "strcspn", scope: !1217, file: !1217, line: 272, type: !1249, flags: DIFlagPrototyped, spFlags: 0)
!1249 = !DISubroutineType(types: !1250)
!1250 = !{!65, !47, !47}
!1251 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1252, file: !1220, line: 85)
!1252 = !DISubprogram(name: "strerror", scope: !1217, file: !1217, line: 396, type: !1253, flags: DIFlagPrototyped, spFlags: 0)
!1253 = !DISubroutineType(types: !1254)
!1254 = !{!92, !18}
!1255 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1256, file: !1220, line: 86)
!1256 = !DISubprogram(name: "strlen", scope: !1217, file: !1217, line: 384, type: !1257, flags: DIFlagPrototyped, spFlags: 0)
!1257 = !DISubroutineType(types: !1258)
!1258 = !{!65, !47}
!1259 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1260, file: !1220, line: 87)
!1260 = !DISubprogram(name: "strncat", scope: !1217, file: !1217, line: 132, type: !1261, flags: DIFlagPrototyped, spFlags: 0)
!1261 = !DISubroutineType(types: !1262)
!1262 = !{!92, !160, !116, !65}
!1263 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1264, file: !1220, line: 88)
!1264 = !DISubprogram(name: "strncmp", scope: !1217, file: !1217, line: 139, type: !1265, flags: DIFlagPrototyped, spFlags: 0)
!1265 = !DISubroutineType(types: !1266)
!1266 = !{!18, !47, !47, !65}
!1267 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1268, file: !1220, line: 89)
!1268 = !DISubprogram(name: "strncpy", scope: !1217, file: !1217, line: 124, type: !1261, flags: DIFlagPrototyped, spFlags: 0)
!1269 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1270, file: !1220, line: 90)
!1270 = !DISubprogram(name: "strspn", scope: !1217, file: !1217, line: 276, type: !1249, flags: DIFlagPrototyped, spFlags: 0)
!1271 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1272, file: !1220, line: 91)
!1272 = !DISubprogram(name: "strtok", scope: !1217, file: !1217, line: 335, type: !1239, flags: DIFlagPrototyped, spFlags: 0)
!1273 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1274, file: !1220, line: 92)
!1274 = !DISubprogram(name: "strxfrm", scope: !1217, file: !1217, line: 146, type: !1275, flags: DIFlagPrototyped, spFlags: 0)
!1275 = !DISubroutineType(types: !1276)
!1276 = !{!65, !160, !116, !65}
!1277 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1278, file: !1220, line: 93)
!1278 = !DISubprogram(name: "strchr", scope: !1217, file: !1217, line: 225, type: !1279, flags: DIFlagPrototyped, spFlags: 0)
!1279 = !DISubroutineType(types: !1280)
!1280 = !{!92, !47, !18}
!1281 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1282, file: !1220, line: 94)
!1282 = !DISubprogram(name: "strpbrk", scope: !1217, file: !1217, line: 302, type: !1283, flags: DIFlagPrototyped, spFlags: 0)
!1283 = !DISubroutineType(types: !1284)
!1284 = !{!92, !47, !47}
!1285 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1286, file: !1220, line: 95)
!1286 = !DISubprogram(name: "strrchr", scope: !1217, file: !1217, line: 252, type: !1279, flags: DIFlagPrototyped, spFlags: 0)
!1287 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !1288, file: !1220, line: 96)
!1288 = !DISubprogram(name: "strstr", scope: !1217, file: !1217, line: 329, type: !1283, flags: DIFlagPrototyped, spFlags: 0)
!1289 = !{!"base.helper.semantics"}
!1290 = !{!1291, !1291, i64 0}
!1291 = !{!"long", !1292, i64 0}
!1292 = !{!"omnipotent char", !1293, i64 0}
!1293 = !{!"Simple C++ TBAA"}
!1294 = !{!1295, !1292, i64 2065}
!1295 = !{!"_ZTS5State", !1292, i64 16, !1296, i64 2064, !1292, i64 2080, !1297, i64 2088, !1299, i64 2112, !1301, i64 2208, !1302, i64 2480, !1303, i64 2608, !1304, i64 2736, !1292, i64 2760, !1292, i64 2768, !1305, i64 3280}
!1296 = !{!"_ZTS10ArithFlags", !1292, i64 0, !1292, i64 1, !1292, i64 2, !1292, i64 3, !1292, i64 4, !1292, i64 5, !1292, i64 6, !1292, i64 7, !1292, i64 8, !1292, i64 9, !1292, i64 10, !1292, i64 11, !1292, i64 12, !1292, i64 13, !1292, i64 14, !1292, i64 15}
!1297 = !{!"_ZTS8Segments", !1298, i64 0, !1292, i64 2, !1298, i64 4, !1292, i64 6, !1298, i64 8, !1292, i64 10, !1298, i64 12, !1292, i64 14, !1298, i64 16, !1292, i64 18, !1298, i64 20, !1292, i64 22}
!1298 = !{!"short", !1292, i64 0}
!1299 = !{!"_ZTS12AddressSpace", !1291, i64 0, !1300, i64 8, !1291, i64 16, !1300, i64 24, !1291, i64 32, !1300, i64 40, !1291, i64 48, !1300, i64 56, !1291, i64 64, !1300, i64 72, !1291, i64 80, !1300, i64 88}
!1300 = !{!"_ZTS3Reg", !1292, i64 0}
!1301 = !{!"_ZTS3GPR", !1291, i64 0, !1300, i64 8, !1291, i64 16, !1300, i64 24, !1291, i64 32, !1300, i64 40, !1291, i64 48, !1300, i64 56, !1291, i64 64, !1300, i64 72, !1291, i64 80, !1300, i64 88, !1291, i64 96, !1300, i64 104, !1291, i64 112, !1300, i64 120, !1291, i64 128, !1300, i64 136, !1291, i64 144, !1300, i64 152, !1291, i64 160, !1300, i64 168, !1291, i64 176, !1300, i64 184, !1291, i64 192, !1300, i64 200, !1291, i64 208, !1300, i64 216, !1291, i64 224, !1300, i64 232, !1291, i64 240, !1300, i64 248, !1291, i64 256, !1300, i64 264}
!1302 = !{!"_ZTS8X87Stack", !1292, i64 0}
!1303 = !{!"_ZTS3MMX", !1292, i64 0}
!1304 = !{!"_ZTS14FPUStatusFlags", !1292, i64 0, !1292, i64 1, !1292, i64 2, !1292, i64 3, !1292, i64 4, !1292, i64 5, !1292, i64 6, !1292, i64 7, !1292, i64 8, !1292, i64 9, !1292, i64 10, !1292, i64 11, !1292, i64 12, !1292, i64 13, !1292, i64 14, !1292, i64 15, !1292, i64 16, !1292, i64 17, !1292, i64 18, !1292, i64 19, !1292, i64 20}
!1305 = !{!"_ZTS13SegmentCaches", !1306, i64 0, !1306, i64 16, !1306, i64 32, !1306, i64 48, !1306, i64 64, !1306, i64 80}
!1306 = !{!"_ZTS13SegmentShadow", !1292, i64 0, !1307, i64 8, !1307, i64 12}
!1307 = !{!"int", !1292, i64 0}
!1308 = !{i32 0, i32 9}
!1309 = !{!1295, !1292, i64 2067}
!1310 = !{!1295, !1292, i64 2071}
!1311 = !{!1295, !1292, i64 2073}
!1312 = !{!1295, !1292, i64 2077}
!1313 = !{!1295, !1292, i64 2069}
!1314 = !{!1292, !1292, i64 0}
!1315 = !{!1295, !1292, i64 2075}
!1316 = !{!"base.external.cfgexternal"}
!1317 = !{!"base.entrypoint"}
!1318 = !{!"base.helper.mcsema"}
