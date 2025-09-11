; ModuleID = 'timsort_mcsema.bc'
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
%seg_1000__init_1b_type = type <{ [27 x i8], [5 x i8], [112 x i8], [16 x i8], [96 x i8], [268 x i8], [4 x i8], [44 x i8], [4 x i8], [36 x i8], [4 x i8], [4 x i8], [4 x i8], [60 x i8], [4 x i8], [60 x i8], [4 x i8], [12 x i8], [4 x i8], [444 x i8], [4 x i8], [212 x i8], [4 x i8], [140 x i8], [4 x i8], [260 x i8], [4 x i8], [236 x i8], [4 x i8], [348 x i8], [4 x i8], [60 x i8], [4 x i8], [519 x i8], [1 x i8], [13 x i8] }>
%seg_3d90__init_array_10_type = type <{ [3472 x i8], i8*, i8*, [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [84 x i8], [4 x i8], [20 x i8], i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, [8 x i8], i8*, [8 x i8], [1 x i8] }>
%seg_2000__rodata_d_type = type <{ [13 x i8], [3 x i8], [60 x i8], [4 x i8], [4 x i8], [4 x i8], [36 x i8], [4 x i8], [36 x i8], [4 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [164 x i8], [4 x i8] }>
%struct.Memory = type opaque
%seg_0_LOAD_7a8_type = type <{ [8 x i8], [8 x i8], [8 x i8], i8*, [4 x i8], [4 x i8], [4 x i8], [8 x i8], [24 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [8 x i8], [24 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], i8*, [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], i8*, [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], i8*, [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], i8*, [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [8 x i8], [40 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], i8*, [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [28 x i8], [4 x i8], [28 x i8], [4 x i8], [12 x i8], [4 x i8], [52 x i8], [4 x i8], [8 x i8], [8 x i8], [20 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [28 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [268 x i8], [4 x i8], [76 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8] }>

@__mcsema_reg_state = thread_local(initialexec) global %struct.State zeroinitializer
@seg_1000__init_1b = internal constant %seg_1000__init_1b_type <{ [27 x i8] c"\F3\0F\1E\FAH\83\EC\08H\8B\05\D9/\00\00H\85\C0t\02\FF\D0H\83\C4\08\C3", [5 x i8] zeroinitializer, [112 x i8] c"\FF5r/\00\00\F2\FF%s/\00\00\0F\1F\00\F3\0F\1E\FAh\00\00\00\00\F2\E9\E1\FF\FF\FF\90\F3\0F\1E\FAh\01\00\00\00\F2\E9\D1\FF\FF\FF\90\F3\0F\1E\FAh\02\00\00\00\F2\E9\C1\FF\FF\FF\90\F3\0F\1E\FAh\03\00\00\00\F2\E9\B1\FF\FF\FF\90\F3\0F\1E\FAh\04\00\00\00\F2\E9\A1\FF\FF\FF\90\F3\0F\1E\FAh\05\00\00\00\F2\E9\91\FF\FF\FF\90", [16 x i8] c"\F3\0F\1E\FA\F2\FF%]/\00\00\0F\1FD\00\00", [96 x i8] c"\F3\0F\1E\FA\F2\FF%\FD.\00\00\0F\1FD\00\00\F3\0F\1E\FA\F2\FF%\F5.\00\00\0F\1FD\00\00\F3\0F\1E\FA\F2\FF%\ED.\00\00\0F\1FD\00\00\F3\0F\1E\FA\F2\FF%\E5.\00\00\0F\1FD\00\00\F3\0F\1E\FA\F2\FF%\DD.\00\00\0F\1FD\00\00\F3\0F\1E\FA\F2\FF%\D5.\00\00\0F\1FD\00\00", [268 x i8] c"\F3\0F\1E\FAAUATL\8D%\F5\0E\00\00UH\8D-\EF\0E\00\00SH\83\ECXdH\8B\04%(\00\00\00H\89D$HH\B8\05\00\00\00\03\00\00\00H\89\E3L\8Dl$8\C7D$8\FF\FF\FF\FFH\89\DFH\89\04$H\B8\01\00\00\00\02\00\00\00H\89D$\08H\B8\09\00\00\00\05\00\00\00H\89D$\10H\B8\05\00\00\00\06\00\00\00H\89D$\18H\B8\07\00\00\00\08\00\00\00H\89D$ H\B8\00\00\00\00\04\00\00\00H\89D$(H\B8\04\00\00\00\0A\00\00\00H\89D$0\E8V\01\00\00f\0F\1FD\00\00\8B\13L\89\E1H\89\EE\BF\01\00\00\001\C0H\83\C3\04\E8(\FF\FF\FFI9\DDu\E3\8BT$81\C0H\8D\0D1\0E\00\00H\89\EE\BF\01\00\00\00\E8\09\FF\FF\FFH\8BD$HdH+\04%(\00\00\00u\0DH\83\C4X1\C0[]A\\A]\C3\E8\A7\FE\FF\FF\0F\1F\80", [4 x i8] zeroinitializer, [44 x i8] c"\F3\0F\1E\FA1\EDI\89\D1^H\89\E2H\83\E4\F0PTE1\C01\C9H\8D=\D1\FE\FF\FF\FF\15\A3-\00\00\F4f.\0F\1F\84\00", [4 x i8] zeroinitializer, [36 x i8] c"H\8D=\C9-\00\00H\8D\05\C2-\00\00H9\F8t\15H\8B\05\86-\00\00H\85\C0t\09\FF\E0\0F\1F\80", [4 x i8] zeroinitializer, [4 x i8] c"\C3\0F\1F\80", [4 x i8] zeroinitializer, [60 x i8] c"H\8D=\99-\00\00H\8D5\92-\00\00H)\FEH\89\F0H\C1\EE?H\C1\F8\03H\01\C6H\D1\FEt\14H\8B\05U-\00\00H\85\C0t\08\FF\E0f\0F\1FD\00\00\C3\0F\1F\80", [4 x i8] zeroinitializer, [60 x i8] c"\F3\0F\1E\FA\80=U-\00\00\00u+UH\83=2-\00\00\00H\89\E5t\0CH\8B=6-\00\00\E8\B9\FD\FF\FF\E8d\FF\FF\FF\C6\05--\00\00\01]\C3\0F\1F\00\C3\0F\1F\80", [4 x i8] zeroinitializer, [12 x i8] c"\F3\0F\1E\FA\E9w\FF\FF\FF\0F\1F\80", [4 x i8] zeroinitializer, [444 x i8] c"AWAVAUATUSH\89\FB\BF<\00\00\00H\81\ECH\08\00\00dH\8B\04%(\00\00\00H\89\84$8\08\00\001\C0\E8\AF\FD\FF\FFH\85\C0\0F\843\08\00\00I\89\C5E1\C9E1\C0\0F\1FD\00\00I\8Dh\01A\BC\0F\00\00\00I\83\F8\0E\0F\84\F4\00\00\00\8BD\AB\FC9\04\AB\0F\8D\D4\00\00\00\EB\12\0F\1FD\00\00\8B|\AB\FC9<\AB\0F\8D^\05\00\00H\89\E8H\83\C5\01H\83\FD\0Fu\E6\B8\0E\00\00\00L\89\C2f\0F\1FD\00\00\8B\0C\93\8B4\83\894\93H\83\C2\01\89\0C\83H\83\E8\01H9\C2r\E7I\89\EC\B8 \00\00\00M)\C4I9\C4L\0FB\E0\B8\0F\00\00\00M\01\C4I9\C4L\0FG\E0L9\E5syL\8D\1C\ABI\89\EAN\8D4\83f\0F\1FD\00\00A\8B;L\89\DEL\89\D8L\89\D2M9\C2w\1A\EB\22\0F\1FD\00\00H\83\EA\01\89\08H\8DF\FCL9\C2\0F\84\AD\00\00\00\8BH\FCH\89\C69\CF|\E3I\83\C2\01\89>I\83\C3\04M9\D4u\BC\EB\22f\90\8BD\AB\FC9\04\AB\0F\8Ct\FF\FF\FFH\83\C5\01H\83\FD\0Fu\E9A\BC\0F\00\00\00\0F\1F\00M)\C4N\89D\CC0N\89\A4\CC0\04\00\00I\83\C1\01I\83\F9\01v=I\83\F9\02\0F\84\F2\02\00\00M\8Dy\FEM\8DA\FDN\8B\B4\FC0\04\00\00J\8B\84\C40\04\00\00I\8Dy\FFH\89|$\08O\8D\1C&L9\D8v=M9\E6\0F\86\11\02\00\00H\83\FD\0F\0F\848\04\00\00I\89\E8\E9\8F\FE\FF\FF\0F\1F\80", [4 x i8] zeroinitializer, [212 x i8] c"L\89\F6I\83\C2\01I\83\C3\04\89>M9\D4\0F\85\12\FF\FF\FF\E9u\FF\FF\FFL9\E0\0F\82\F1\00\00\00H\8BD$\08N\8BD\FC0L\8BL\C40K\8D\04!H\89D$\10M9\E6\0F\86\D4\01\00\00J\8D\14\A5\00\00\00\00J\8D4\8B\B9<\00\00\00L\89\EFL\89D$ L\89\\$\10H\89D$\18\E8\93\FB\FF\FFL\8BD$ L\8B\\$\10M\01\C6M\85\E4toM9\C6L\8BT$\18w\1D\EB=\0F\1FD\00\00I\83\EE\01B\8B\04\B3B\89\04\93M9\C6v'M\85\E4tHC\8BD\A5\FCI\83\EA\01B9D\B3\FC\7F\DAI\83\EC\01C\8BD\A5\00B\89\04\93M9\C6w\D9M\85\E4t!M)\E2J\8D\14\A5", [4 x i8] zeroinitializer, [140 x i8] c"L\89\EEL\89\\$\10J\8D<\93\E8'\FB\FF\FFL\8B\\$\10N\89\9C\FC0\04\00\00L\8B|$\08I\83\FF\02\0F\84\A1\01\00\00N\8B\A4\FC(\04\00\00M\89\F9\E9\9F\FE\FF\FFJ\89\84\FC0\04\00\00J\8BT\C40N\8BT\FC0N\89\B4\C40\04\00\00N\8B\8C\FC0\04\00\00J\89T\FC0N\89T\C40N\8Bd\FC0M9\CE\0F\87\09\02\00\00J\8D4\93\B9<\00\00\00L\89\EFL\89L$\18J\8D\14\B5", [4 x i8] zeroinitializer, [260 x i8] c"L\89D$\10L\89T$\08\E8\89\FA\FF\FFL\8BL$\181\D2L\8BT$\08L\8BD$\10K\8D4\0CI9\F4\0F\83\AB\04\00\00M\85\F6u\1F\E9\A1\04\00\00\90\89\C8H\83\C2\01B\89D\93\FCI9\D6v(L9\E6\0F\86\87\04\00\00A\8BL\95\00B\8B\04\A3I\83\C2\019\C1~\D6B\89D\93\FCI\83\C4\01I9\D6w\D8M\01\F1N\89\8C\C40\04\00\00I\83\FF\01\0F\85\0E\FF\FF\FFA\B9\01\00\00\00\E9\EF\FD\FF\FFL9\E0\0F\82\14\FF\FF\FFH\8BD$\08N\8BD\FC0L\8BL\C40K\8D\04!H\89D$\10J\8D\14\B5\00\00\00\00J\8D4\83\B9<\00\00\00L\89\EFL\89L$(L\89\\$ L\89D$\18\E8\BF\F9\FF\FFL\8BL$(1\D2L9L$\10L\8BD$\18L\8B\\$ \0F\86 \04\00\00M\85\F6u-\E9\16\04\00\00f\0F\1F\84\00", [4 x i8] zeroinitializer, [236 x i8] c"H\83\C2\01\89\C8B\89D\83\FCI9\D6\0F\86j\FE\FF\FFL9L$\10\0F\86\EE\03\00\00A\8BL\95\00B\8B\04\8BI\83\C0\019\C1~\D0I\83\C1\01\EB\D0L\8B\BC$0\04\00\00L\8B\84$8\04\00\00A\B9\02\00\00\00M9\C7\0F\87\22\FD\FF\FFL\8Bd$0\B9<\00\00\00L\89\EFL\89D$\08J\8D\14\BD\00\00\00\00L\8Bt$8J\8D4\A3\E8\13\F9\FF\FFL\8BD$\081\C0K\8D40I9\F6\0F\83\D1\03\00\00M\85\FFu#\E9\C7\03\00\00\0F\1FD\00\00\89\CAH\83\C0\01B\89T\A3\FCI9\C7v(L9\F6\0F\86\A9\03\00\00A\8BL\85\00B\8B\14\B3I\83\C4\019\D1~\D6B\89T\A3\FCI\83\C6\01I9\C7w\D8M\01\C7L\89\BC$0\04\00\00\E9\95\FE\FF\FFJ\8D\14\8D", [4 x i8] zeroinitializer, [348 x i8] c"J\8D4\A3\B9<\00\00\00L\89\EFL\89T$\18L\89D$\10L\89L$\08\E8\80\F8\FF\FFL\8BL$\08L\8BT$\18L\8BD$\10M\01\CCM\85\C9K\8D\14\16L\89\C8tDI9\D2r\1E\EB=\0F\1F\00H\83\EA\01\8B\0C\93B\89\0C\A3I9\D2s*H\85\C0\0F\84\17\FE\FF\FFA\8B|\85\FCI\83\EC\019|\93\FC\7F\D8H\83\E8\01A\8BL\85\00B\89\0C\A3I9\D2r\D6H\85\C0\0F\84\ED\FD\FF\FFI)\C4H\8D\14\85\00\00\00\00L\89\EEL\89L$\10J\8D<\A3L\89D$\08\E8\04\F8\FF\FFL\8BD$\08L\8BL$\10\E9\BD\FD\FF\FFL9\C0\0F\87\AB\FA\FF\FF\E9\C8\FA\FF\FFI\83\F9\01\0F\86\E7\00\00\00H\8DD$8I\C1\E1\03H\89D$\08N\8DT\0C0N\8D\B4\0C0\04\00\00f\90M\8BZ\F8M\8BF\F8M\8B~\F0I\8Bj\F0O\8D$\03M9\F8\0F\82\DD\00\00\00J\8D\14\BD\00\00\00\00H\8D4\AB\B9<\00\00\00L\89\EFL\89T$ L\89\\$\18L\89D$\10\E8k\F7\FF\FFL\8B\\$\181\D2L\8BD$\10L\8BT$ M9\E3\0F\83T\01\00\00M\85\FFu$\E9J\01\00\00\0F\1F\80", [4 x i8] zeroinitializer, [60 x i8] c"\89\C8H\83\C2\01\89D\AB\FCI9\D7v1M9\E3\0F\83+\01\00\00A\8BL\95\00B\8B\04\9BH\83\C5\019\C1~\D7\89D\AB\FCI\83\C3\01I9\D7w\D9f.\0F\1F\84\00", [4 x i8] zeroinitializer, [519 x i8] c"M\01\F8I\83\EA\08I\83\EE\08M\89F\F8L;T$\08\0F\856\FF\FF\FFH\8B\84$8\08\00\00dH+\04%(\00\00\00\0F\85\D1\01\00\00H\81\C4H\08\00\00L\89\EF[]A\\A]A^A_\E9\96\F6\FF\FFJ\8D\14\85\00\00\00\00J\8D4\9B\B9<\00\00\00L\89\EFL\89T$\18L\89D$\10\E8\93\F6\FF\FFL\8BD$\10J\8DT=\00L\8BT$\18H9\D5L\89\C0sFM\85\C0u \EB?\0F\1FD\00\00H\83\EA\01\8B\0C\93B\89\0C\A3H9\D5s*H\85\C0\0F\84W\FF\FF\FFA\8B|\85\FCI\83\EC\019|\93\FC\7F\D8H\83\E8\01A\8BL\85\00B\89\0C\A3H9\D5r\D6H\85\C0\0F\84-\FF\FF\FFI)\C4H\8D\14\85\00\00\00\00L\89\EEL\89T$\18J\8D<\A3L\89D$\10\E8\1C\F6\FF\FFL\8BD$\10L\8BT$\18\E9\FD\FE\FF\FFI9\D7\0F\86\F4\FE\FF\FFM\89\FBI\8Dt\95\00H\8D<\ABL\89T$\18I)\D3L\89D$\10I\C1\E3\02L\89\DA\E8\DF\F5\FF\FFL\8BD$\10L\8BT$\18\E9\C0\FE\FF\FFI9\D6\0F\86\8F\FB\FF\FFJ\8D<\93M\89\F2I\8Dt\95\00L\89L$\10I)\D2L\89D$\08I\C1\E2\02L\89\D2\E8\A2\F5\FF\FFL\8BD$\08L\8BL$\10\E9[\FB\FF\FFI9\D6\0F\86h\FA\FF\FFI)\D6I\8Dt\95\00J\8D<\83L\89\\$\10I\C1\E6\02L\89\F2\E8m\F5\FF\FFL\8B\\$\10\E9A\FA\FF\FFH\8B\84$8\08\00\00dH+\04%(\00\00\00uBH\81\C4H\08\00\00[]A\\A]A^A_\C3I9\C7\0F\86m\FC\FF\FFL\89\FAJ\8D<\A3I\8Dt\85\00L\89D$\08H)\C2H\C1\E2\02\E8\18\F5\FF\FFL\8BD$\08\E9F\FC\FF\FF\E8\E9\F4\FF\FF", [1 x i8] zeroinitializer, [13 x i8] c"\F3\0F\1E\FAH\83\EC\08H\83\C4\08\C3" }>, align 4096
@seg_3d90__init_array_10 = internal global %seg_3d90__init_array_10_type <{ [3472 x i8] zeroinitializer, i8* bitcast (void ()* @frame_dummy to i8*), i8* bitcast (void ()* @__do_global_dtors_aux to i8*), [4 x i8] c"\01\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"`\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\0C\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\00\10\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\0D\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\C8\1B\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\19\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\90=\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\1B\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\1A\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\98=\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\1C\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\F5\FE\FFo", [4 x i8] zeroinitializer, [4 x i8] c"\B0\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\05\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\F8\04\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\06\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\D8\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\0A\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\E7\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\0B\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\18\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\15\00\00\00", [12 x i8] zeroinitializer, [4 x i8] c"\03\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\90?\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\02\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\90\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\14\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\07\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\17\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\18\07\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\07\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"X\06\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\C0\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\09\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\18\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\1E\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\FB\FF\FFo", [4 x i8] zeroinitializer, [4 x i8] c"\01\00\00\08", [4 x i8] zeroinitializer, [4 x i8] c"\FE\FF\FFo", [4 x i8] zeroinitializer, [4 x i8] c"\F8\05\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\FF\FF\FFo", [4 x i8] zeroinitializer, [4 x i8] c"\01\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\F0\FF\FFo", [4 x i8] zeroinitializer, [4 x i8] c"\E0\05\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\F9\FF\FFo", [4 x i8] zeroinitializer, [4 x i8] c"\03\00\00\00", [84 x i8] zeroinitializer, [4 x i8] c"\A0=\00\00", [20 x i8] zeroinitializer, i8* bitcast (i64 (i64)* @free to i8*), i8* bitcast (i64 ()* @__stack_chk_fail to i8*), i8* bitcast (i64 (i64, i64, i64, i64)* @__memcpy_chk to i8*), i8* bitcast (i8* (i8*, i8*, i64)* @memcpy to i8*), i8* bitcast (i64 (i64)* @malloc to i8*), i8* bitcast (i64 (...)* @__printf_chk to i8*), i8* bitcast (void (i32 (i32, i8**, i8**)*, i32, i8**, i8*, i32 (i32, i8**, i8**)*, void ()*, void ()*, i32*)* @__libc_start_main to i8*), i8* bitcast (i64 (i64)* @_ITM_deregisterTMCloneTable to i8*), i8* bitcast (void ()* @__gmon_start__ to i8*), i8* bitcast (i64 (i64, i64)* @_ITM_registerTMCloneTable to i8*), i8* bitcast (i64 (i64)* @__cxa_finalize to i8*), [8 x i8] zeroinitializer, i8* bitcast (i8** @data_4008 to i8*), [8 x i8] zeroinitializer, [1 x i8] zeroinitializer }>, align 4096
@seg_2000__rodata_d = internal constant %seg_2000__rodata_d_type <{ [13 x i8] c"\01\00\02\00 \00%d%s\00\0A\00", [3 x i8] zeroinitializer, [60 x i8] c"\01\1B\03;<\00\00\00\06\00\00\00\10\F0\FF\FFp\00\00\00\80\F0\FF\FF\98\00\00\00\90\F0\FF\FF\B0\00\00\00\F0\F0\FF\FF0\01\00\00\00\F2\FF\FFX\00\00\00\F0\F2\FF\FF\C8\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\14\00\00\00", [4 x i8] zeroinitializer, [36 x i8] c"\01zR\00\01x\10\01\1B\0C\07\08\90\01\00\00\14\00\00\00\1C\00\00\00\A0\F1\FF\FF&\00\00\00\00D\07\10", [4 x i8] zeroinitializer, [36 x i8] c"$\00\00\004\00\00\00\98\EF\FF\FFp\00\00\00\00\0E\10F\0E\18J\0F\0Bw\08\80\00?\1A:*3$\22", [4 x i8] zeroinitializer, [16 x i8] c"\14\00\00\00\\\00\00\00\E0\EF\FF\FF\10\00\00\00", [8 x i8] zeroinitializer, [16 x i8] c"\14\00\00\00t\00\00\00\D8\EF\FF\FF`\00\00\00", [8 x i8] zeroinitializer, [164 x i8] c"d\00\00\00\8C\00\00\00 \F2\FF\FF\C7\08\00\00\00B\0E\10\8F\02B\0E\18\8E\03B\0E \8D\04B\0E(\8C\05A\0E0\86\06A\0E8\83\07O\0E\80\11\03\DF\06\0A\0E8D\0E0A\0E(B\0E B\0E\18B\0E\10B\0E\08E\0B\03}\01\0A\0E8A\0E0A\0E(B\0E B\0E\18B\0E\10B\0E\08A\0B\008\00\00\00\F4\00\00\00\B8\EF\FF\FF\09\01\00\00\00F\0E\10\8D\02B\0E\18\8C\03H\0E \86\04H\0E(\83\05D\0E\80\01\02\DF\0A\0E(C\0E A\0E\18B\0E\10B\0E\08A\0B", [4 x i8] zeroinitializer }>, align 8192
@0 = internal global i1 false
@1 = internal constant %struct.Memory* (%struct.State*, i64, %struct.Memory*)* @main_wrapper
@2 = internal constant void ()* @__mcsema_attach_call
@3 = internal constant %struct.Memory* (%struct.State*, i64, %struct.Memory*)* @frame_dummy_wrapper
@4 = internal constant %struct.Memory* (%struct.State*, i64, %struct.Memory*)* @__do_global_dtors_aux_wrapper
@seg_0_LOAD_7a8 = internal constant %seg_0_LOAD_7a8_type <{ [8 x i8] c"\7FELF\02\01\01\00", [8 x i8] zeroinitializer, [8 x i8] c"\03\00>\00\01\00\00\00", i8* bitcast (void ()* @_start to i8*), [4 x i8] c"@\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\B07\00\00", [8 x i8] zeroinitializer, [24 x i8] c"@\008\00\0D\00@\00\1F\00\1E\00\06\00\00\00\04\00\00\00@\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"@\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"@\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\D8\02\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\D8\02\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [12 x i8] c"\03\00\00\00\04\00\00\00\18\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\18\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\18\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\1C\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\1C\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\01\00\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\01\00\00\00\04\00\00\00", [24 x i8] zeroinitializer, [4 x i8] c"\A8\07\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\A8\07\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\00\10\00\00", [4 x i8] zeroinitializer, [12 x i8] c"\01\00\00\00\05\00\00\00\00\10\00\00", [4 x i8] zeroinitializer, i8* bitcast (void ()* @.init_proc to i8*), [4 x i8] c"\00\10\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\D5\0B\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\D5\0B\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\00\10\00\00", [4 x i8] zeroinitializer, [12 x i8] c"\01\00\00\00\04\00\00\00\00 \00\00", [4 x i8] zeroinitializer, i8* @data_2000, [4 x i8] c"\00 \00\00", [4 x i8] zeroinitializer, [4 x i8] c"\80\01\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\80\01\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\00\10\00\00", [4 x i8] zeroinitializer, [12 x i8] c"\01\00\00\00\06\00\00\00\90-\00\00", [4 x i8] zeroinitializer, i8* bitcast (i8** @data_3d90 to i8*), [4 x i8] c"\90=\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\80\02\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\88\02\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\00\10\00\00", [4 x i8] zeroinitializer, [12 x i8] c"\02\00\00\00\06\00\00\00\A0-\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\A0=\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\A0=\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\F0\01\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\F0\01\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [12 x i8] c"\04\00\00\00\04\00\00\008\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"8\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"8\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"0\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"0\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [12 x i8] c"\04\00\00\00\04\00\00\00h\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"h\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"h\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"D\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"D\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\04\00\00\00", [4 x i8] zeroinitializer, [12 x i8] c"S\E5td\04\00\00\008\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"8\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"8\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"0\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"0\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [12 x i8] c"P\E5td\04\00\00\00\10 \00\00", [4 x i8] zeroinitializer, i8* @data_2010, [4 x i8] c"\10 \00\00", [4 x i8] zeroinitializer, [4 x i8] c"<\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"<\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\04\00\00\00", [4 x i8] zeroinitializer, [8 x i8] c"Q\E5td\06\00\00\00", [40 x i8] zeroinitializer, [4 x i8] c"\10\00\00\00", [4 x i8] zeroinitializer, [12 x i8] c"R\E5td\04\00\00\00\90-\00\00", [4 x i8] zeroinitializer, i8* bitcast (i8** @data_3d90 to i8*), [4 x i8] c"\90=\00\00", [4 x i8] zeroinitializer, [4 x i8] c"p\02\00\00", [4 x i8] zeroinitializer, [4 x i8] c"p\02\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\01\00\00\00", [4 x i8] zeroinitializer, [28 x i8] c"/lib64/ld-linux-x86-64.so.2\00", [4 x i8] zeroinitializer, [28 x i8] c"\04\00\00\00 \00\00\00\05\00\00\00GNU\00\02\00\00\C0\04\00\00\00\03\00\00\00", [4 x i8] zeroinitializer, [12 x i8] c"\02\80\00\C0\04\00\00\00\01\00\00\00", [4 x i8] zeroinitializer, [52 x i8] c"\04\00\00\00\14\00\00\00\03\00\00\00GNU\00\83?4.\DC`\80zK5\18\D2\7F`\C7\86=\FC*\FA\04\00\00\00\10\00\00\00\01\00\00\00GNU\00", [4 x i8] zeroinitializer, [8 x i8] c"\03\00\00\00\02\00\00\00", [8 x i8] zeroinitializer, [20 x i8] c"\02\00\00\00\0B\00\00\00\01\00\00\00\06\00\00\00\00\00\81\00", [4 x i8] zeroinitializer, [4 x i8] c"\0B\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\D1e\CEm", [28 x i8] zeroinitializer, [8 x i8] c"6\00\00\00\12\00\00\00", [16 x i8] zeroinitializer, [8 x i8] c"$\00\00\00\12\00\00\00", [16 x i8] zeroinitializer, [8 x i8] c"\A2\00\00\00 \00\00\00", [16 x i8] zeroinitializer, [8 x i8] c"O\00\00\00\12\00\00\00", [16 x i8] zeroinitializer, [8 x i8] c";\00\00\00\12\00\00\00", [16 x i8] zeroinitializer, [8 x i8] c"\BE\00\00\00 \00\00\00", [16 x i8] zeroinitializer, [8 x i8] c"H\00\00\00\12\00\00\00", [16 x i8] zeroinitializer, [8 x i8] c"\1D\00\00\00\12\00\00\00", [16 x i8] zeroinitializer, [8 x i8] c"\10\00\00\00\12\00\00\00", [16 x i8] zeroinitializer, [8 x i8] c"\CD\00\00\00 \00\00\00", [16 x i8] zeroinitializer, [8 x i8] c"\01\00\00\00\22\00\00\00", [16 x i8] zeroinitializer, [268 x i8] c"\00__cxa_finalize\00__printf_chk\00malloc\00__libc_start_main\00free\00__memcpy_chk\00memcpy\00__stack_chk_fail\00libc.so.6\00GLIBC_2.14\00GLIBC_2.3.4\00GLIBC_2.4\00GLIBC_2.34\00GLIBC_2.2.5\00_ITM_deregisterTMCloneTable\00__gmon_start__\00_ITM_registerTMCloneTable\00\00\00\00\02\00\03\00\01\00\04\00\05\00\01\00\06\00\02\00\05\00\01\00\02\00\01\00\05\00`\00\00\00\10\00\00\00", [4 x i8] zeroinitializer, [76 x i8] c"\94\91\96\06\00\00\06\00j\00\00\00\10\00\00\00t\19i\09\00\00\05\00u\00\00\00\10\00\00\00\14ii\0D\00\00\04\00\81\00\00\00\10\00\00\00\B4\91\96\06\00\00\03\00\8B\00\00\00\10\00\00\00u\1Ai\09\00\00\02\00\96\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\90=\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\F0\12\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\98=\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\B0\12\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08@\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08@\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\D8?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\06\00\00\00\02\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\E0?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\06\00\00\00\03\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\E8?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\06\00\00\00\06\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\F0?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\06\00\00\00\0A\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\F8?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\06\00\00\00\0B\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\A8?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\07\00\00\00\01\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\B0?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\07\00\00\00\04\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\B8?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\07\00\00\00\05\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\C0?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\07\00\00\00\07\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\C8?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\07\00\00\00\08\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\D0?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\07\00\00\00\09\00\00\00", [8 x i8] zeroinitializer }>
@5 = internal constant %struct.Memory* (%struct.State*, i64, %struct.Memory*)* @_start_wrapper
@6 = internal constant %struct.Memory* (%struct.State*, i64, %struct.Memory*)* @.init_proc_wrapper

@data_18a2 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 29, i32 130)
@data_185e = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 29, i32 62)
@data_1655 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 25, i32 45)
@data_1b3d = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 33, i32 381)
@data_171d = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 25, i32 245)
@data_153f = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 21, i32 127)
@data_15ae = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 23, i32 22)
@data_1b92 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 33, i32 466)
@data_17c1 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 27, i32 145)
@data_1b00 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 33, i32 320)
@data_196f = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 29, i32 335)
@data_1ac3 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 33, i32 259)
@data_1a8a = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 33, i32 202)
@data_1a44 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 33, i32 132)
@data_1b6d = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 33, i32 429)
@data_133a = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 19, i32 58)
@data_12e8 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 15, i32 56)
@data_12bd = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 15, i32 13)
@data_1204 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 5, i32 260)
@data_11f7 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 5, i32 247)
@data_11cd = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 5, i32 205)
@data_11b0 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 5, i32 176)
@data_1014 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 0, i32 20)
@data_1331 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 19, i32 49)
@data_12d7 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 15, i32 39)
@data_4008 = internal alias i8*, getelementptr inbounds (%seg_3d90__init_array_10_type, %seg_3d90__init_array_10_type* @seg_3d90__init_array_10, i32 0, i32 119)
@data_3ff8 = internal alias i8*, getelementptr inbounds (%seg_3d90__init_array_10_type, %seg_3d90__init_array_10_type* @seg_3d90__init_array_10, i32 0, i32 117)
@data_1235 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 7, i32 37)
@data_3fd8 = internal alias i8*, getelementptr inbounds (%seg_3d90__init_array_10_type, %seg_3d90__init_array_10_type* @seg_3d90__init_array_10, i32 0, i32 113)
@data_200b = internal alias i8, getelementptr inbounds (%seg_2000__rodata_d_type, %seg_2000__rodata_d_type* @seg_2000__rodata_d, i32 0, i32 0, i32 11)
@data_11aa = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 5, i32 170)
@data_2006 = internal alias i8, getelementptr inbounds (%seg_2000__rodata_d_type, %seg_2000__rodata_d_type* @seg_2000__rodata_d, i32 0, i32 0, i32 6)
@data_2004 = internal alias i8, getelementptr inbounds (%seg_2000__rodata_d_type, %seg_2000__rodata_d_type* @seg_2000__rodata_d, i32 0, i32 0, i32 4)
@data_12a9 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 13, i32 57)
@data_3ff0 = internal alias i8*, getelementptr inbounds (%seg_3d90__init_array_10_type, %seg_3d90__init_array_10_type* @seg_3d90__init_array_10, i32 0, i32 116)
@data_102d = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 2, i32 13)
@data_3fa0 = internal alias i8, getelementptr inbounds (%seg_3d90__init_array_10_type, %seg_3d90__init_array_10_type* @seg_3d90__init_array_10, i32 0, i32 106, i32 12)
@data_3f98 = internal alias i8, getelementptr inbounds (%seg_3d90__init_array_10_type, %seg_3d90__init_array_10_type* @seg_3d90__init_array_10, i32 0, i32 106, i32 4)
@data_1269 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 11, i32 1)
@data_3fe0 = internal alias i8*, getelementptr inbounds (%seg_3d90__init_array_10_type, %seg_3d90__init_array_10_type* @seg_3d90__init_array_10, i32 0, i32 114)
@data_4010 = internal alias i8, getelementptr inbounds (%seg_3d90__init_array_10_type, %seg_3d90__init_array_10_type* @seg_3d90__init_array_10, i32 0, i32 120, i32 0)
@data_1016 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 0, i32 22)
@data_3fe8 = internal alias i8*, getelementptr inbounds (%seg_3d90__init_array_10_type, %seg_3d90__init_array_10_type* @seg_3d90__init_array_10, i32 0, i32 115)
@data_2000 = internal alias i8, getelementptr inbounds (%seg_2000__rodata_d_type, %seg_2000__rodata_d_type* @seg_2000__rodata_d, i32 0, i32 0, i32 0)
@data_3d90 = internal alias i8*, getelementptr inbounds (%seg_3d90__init_array_10_type, %seg_3d90__init_array_10_type* @seg_3d90__init_array_10, i32 0, i32 1)
@data_2010 = internal alias i8, getelementptr inbounds (%seg_2000__rodata_d_type, %seg_2000__rodata_d_type* @seg_2000__rodata_d, i32 0, i32 2, i32 0)
@RSP_2312_31c7d5b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 13, i32 0, i32 0)
@OF_2077_31c7d570 = private thread_local(initialexec) alias i8, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 2, i32 13)
@SF_2073_31c7d570 = private thread_local(initialexec) alias i8, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 2, i32 9)
@ZF_2071_31c7d570 = private thread_local(initialexec) alias i8, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 2, i32 7)
@AF_2069_31c7d570 = private thread_local(initialexec) alias i8, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 2, i32 5)
@PF_2067_31c7d570 = private thread_local(initialexec) alias i8, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 2, i32 3)
@CF_2065_31c7d570 = private thread_local(initialexec) alias i8, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 2, i32 1)
@RIP_2472_31c7d5b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 33, i32 0, i32 0)
@RAX_2216_31c7d5b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 1, i32 0, i32 0)
@RAX_2216_31c84a60 = private thread_local(initialexec) alias i8*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 1, i32 0, i32 0) to i8**)
@RDI_2296_31c84a60 = private thread_local(initialexec) alias i8*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 11, i32 0, i32 0) to i8**)
@RSI_2280_31c7d5b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 9, i32 0, i32 0)
@RCX_2248_31c7d5b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 5, i32 0, i32 0)
@RCX_2248_31c84a60 = private thread_local(initialexec) alias i8*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 5, i32 0, i32 0) to i8**)
@RDX_2264_31c7d5b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 7, i32 0, i32 0)
@RDI_2296_31c7d5b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 11, i32 0, i32 0)
@FSBASE_2168_31c7d5b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 5, i32 7, i32 0, i32 0)
@RSP_2312_31c84bc0 = private thread_local(initialexec) alias i64*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 13, i32 0, i32 0) to i64**)
@RSP_2312_31c8a140 = private thread_local(initialexec) alias i32*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 13, i32 0, i32 0) to i32**)
@RBX_2232_31c7d5b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 3, i32 0, i32 0)
@RBX_2232_31c8a140 = private thread_local(initialexec) alias i32*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 3, i32 0, i32 0) to i32**)
@RBP_2328_31c7d5b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 15, i32 0, i32 0)
@RBP_2328_31c84a60 = private thread_local(initialexec) alias i8*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 15, i32 0, i32 0) to i8**)
@R12_2408_31c7d5b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 25, i32 0, i32 0)
@R12_2408_31c84a60 = private thread_local(initialexec) alias i8*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 25, i32 0, i32 0) to i8**)
@R13_2424_31c7d5b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 27, i32 0, i32 0)
@RDI_2296_31c8bfa0 = private thread_local(initialexec) alias i32 (i32, i8**, i8**)*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 11, i32 0, i32 0) to i32 (i32, i8**, i8**)**)
@R8_2344_31c7d5b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 17, i32 0, i32 0)
@R9_2360_31c7d5b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 19, i32 0, i32 0)
@RIP_2472_31c84a60 = private thread_local(initialexec) alias i8*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 33, i32 0, i32 0) to i8**)
@R10_2376_31c7d5b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 21, i32 0, i32 0)
@R11_2392_31c7d5b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 23, i32 0, i32 0)
@R11_2392_31c8a140 = private thread_local(initialexec) alias i32*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 23, i32 0, i32 0) to i32**)
@RSI_2280_31c8a140 = private thread_local(initialexec) alias i32*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 9, i32 0, i32 0) to i32**)
@RAX_2216_31c8a140 = private thread_local(initialexec) alias i32*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 1, i32 0, i32 0) to i32**)
@R14_2440_31c7d5b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 29, i32 0, i32 0)
@R15_2456_31c7d5b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 31, i32 0, i32 0)
@RBX_2232_31c7d570 = private thread_local(initialexec) alias i8, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 3, i32 0, i32 0) to i8*)
@RAX_2216_31c7d5a0 = private thread_local(initialexec) alias i32, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 1, i32 0, i32 0) to i32*)
@RDI_2296_31c7d5a0 = private thread_local(initialexec) alias i32, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 11, i32 0, i32 0) to i32*)
@RDX_2265_31c7d570 = private thread_local(initialexec) alias i8, getelementptr (i8, i8* bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 7, i32 0, i32 0) to i8*), i32 1)

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
  call void asm sideeffect "pushq $0;pushq $$0x1210;jmpq *$1;", "*m,*m,~{dirflag},~{fpsr},~{flags}"(%struct.Memory* (%struct.State*, i64, %struct.Memory*)** elementtype(%struct.Memory* (%struct.State*, i64, %struct.Memory*)*) @5, void ()** elementtype(void ()*) @2)
  ret void
}

; Function Attrs: naked nobuiltin noinline
define private void @frame_dummy() #8 {
  call void asm sideeffect "pushq $0;pushq $$0x12f0;jmpq *$1;", "*m,*m,~{dirflag},~{fpsr},~{flags}"(%struct.Memory* (%struct.State*, i64, %struct.Memory*)** elementtype(%struct.Memory* (%struct.State*, i64, %struct.Memory*)*) @3, void ()** elementtype(void ()*) @2)
  ret void
}

; Function Attrs: naked nobuiltin noinline
define private void @__do_global_dtors_aux() #8 {
  call void asm sideeffect "pushq $0;pushq $$0x12b0;jmpq *$1;", "*m,*m,~{dirflag},~{fpsr},~{flags}"(%struct.Memory* (%struct.State*, i64, %struct.Memory*)** elementtype(%struct.Memory* (%struct.State*, i64, %struct.Memory*)*) @4, void ()** elementtype(void ()*) @2)
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
  %0 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %1 = sub i64 %0, 8
  store i64 %1, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %2 = load i64, i64* bitcast (i8** @data_3fe8 to i64*), align 8
  store i64 %2, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  store i8 0, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  %3 = trunc i64 %2 to i32
  %4 = and i32 %3, 255
  %5 = call i32 @llvm.ctpop.i32(i32 %4) #13, !range !1308
  %6 = trunc i32 %5 to i8
  %7 = and i8 %6, 1
  %8 = xor i8 %7, 1
  store i8 %8, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  %9 = icmp eq i64 %2, 0
  %10 = zext i1 %9 to i8
  store i8 %10, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  %11 = lshr i64 %2, 63
  %12 = trunc i64 %11 to i8
  store i8 %12, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  store i8 0, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  store i8 0, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  br i1 %9, label %inst_1016, label %inst_1014

inst_1016:                                        ; preds = %inst_1014, %inst_1000
  %13 = phi %struct.Memory* [ %memory, %inst_1000 ], [ %46, %inst_1014 ]
  %14 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %15 = add i64 8, %14
  %16 = icmp ult i64 %15, %14
  %17 = icmp ult i64 %15, 8
  %18 = or i1 %16, %17
  %19 = zext i1 %18 to i8
  store i8 %19, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  %20 = trunc i64 %15 to i32
  %21 = and i32 %20, 255
  %22 = call i32 @llvm.ctpop.i32(i32 %21) #13, !range !1308
  %23 = trunc i32 %22 to i8
  %24 = and i8 %23, 1
  %25 = xor i8 %24, 1
  store i8 %25, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  %26 = xor i64 8, %14
  %27 = xor i64 %26, %15
  %28 = lshr i64 %27, 4
  %29 = trunc i64 %28 to i8
  %30 = and i8 %29, 1
  store i8 %30, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  %31 = icmp eq i64 %15, 0
  %32 = zext i1 %31 to i8
  store i8 %32, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  %33 = lshr i64 %15, 63
  %34 = trunc i64 %33 to i8
  store i8 %34, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  %35 = lshr i64 %14, 63
  %36 = xor i64 %33, %35
  %37 = add nuw nsw i64 %36, %33
  %38 = icmp eq i64 %37, 2
  %39 = zext i1 %38 to i8
  store i8 %39, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  %40 = add i64 %15, 8
  store i64 %40, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  ret %struct.Memory* %13

inst_1014:                                        ; preds = %inst_1000
  %41 = icmp eq i8 %10, 0
  %42 = select i1 %41, i64 ptrtoint (i8* @data_1014 to i64), i64 ptrtoint (i8* @data_1016 to i64)
  %43 = add i64 %42, 2
  %44 = add i64 %1, -8
  %45 = inttoptr i64 %44 to i64*
  store i64 %43, i64* %45, align 8
  store i64 %44, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  store i64 %2, i64* @RIP_2472_31c7d5b8, align 8, !tbaa !1290
  %46 = call %struct.Memory* @__remill_function_call(%struct.State* @__mcsema_reg_state, i64 %2, %struct.Memory* %memory)
  br label %inst_1016
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1240_deregister_tm_clones(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1240:
  store i8* @data_4010, i8** @RDI_2296_31c84a60, align 8
  store i8* @data_4010, i8** @RAX_2216_31c84a60, align 8
  store i8 0, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  store i8 1, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  store i8 0, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  store i8 1, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  store i8 0, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  store i8 0, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  %0 = load i64, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1314
  %1 = add i64 %0, 8
  store i64 %1, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  ret %struct.Memory* %memory
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1030(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1030:
  %0 = load i64, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1314
  %1 = add i64 %0, -8
  %2 = inttoptr i64 %1 to i64*
  store i64 0, i64* %2, align 8
  store i64 %1, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %3 = call %struct.Memory* @sub_1020(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  ret %struct.Memory* %3
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1040(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1040:
  %0 = load i64, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1314
  %1 = add i64 %0, -8
  %2 = inttoptr i64 %1 to i64*
  store i64 1, i64* %2, align 8
  store i64 %1, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %3 = call %struct.Memory* @sub_1020(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  ret %struct.Memory* %3
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1050(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1050:
  %0 = load i64, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1314
  %1 = add i64 %0, -8
  %2 = inttoptr i64 %1 to i64*
  store i64 2, i64* %2, align 8
  store i64 %1, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %3 = call %struct.Memory* @sub_1020(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  ret %struct.Memory* %3
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1020(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1020:
  %0 = load i64, i64* bitcast (i8* @data_3f98 to i64*), align 8
  %1 = load i64, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1314
  %2 = add i64 %1, -8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3, align 8
  store i64 %2, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %4 = load i64, i64* bitcast (i8* @data_3fa0 to i64*), align 8
  store i64 %4, i64* @RIP_2472_31c7d5b8, align 8, !tbaa !1290
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
define internal %struct.Memory* @sub_1270_register_tm_clones(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1270:
  store i8* @data_4010, i8** @RDI_2296_31c84a60, align 8
  store i64 0, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  store i64 0, i64* @RSI_2280_31c7d5b8, align 8, !tbaa !1290
  store i8 0, i8* @CF_2065_31c7d570, align 1, !tbaa !1314
  store i8 1, i8* @PF_2067_31c7d570, align 1, !tbaa !1314
  store i8 0, i8* @AF_2069_31c7d570, align 1, !tbaa !1314
  store i8 1, i8* @ZF_2071_31c7d570, align 1, !tbaa !1314
  store i8 0, i8* @SF_2073_31c7d570, align 1, !tbaa !1314
  store i8 0, i8* @OF_2077_31c7d570, align 1, !tbaa !1314
  %0 = load i64, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1314
  %1 = add i64 %0, 8
  store i64 %1, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  ret %struct.Memory* %memory
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1070(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1070:
  %0 = load i64, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1314
  %1 = add i64 %0, -8
  %2 = inttoptr i64 %1 to i64*
  store i64 4, i64* %2, align 8
  store i64 %1, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %3 = call %struct.Memory* @sub_1020(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  ret %struct.Memory* %3
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1080(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1080:
  %0 = load i64, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1314
  %1 = add i64 %0, -8
  %2 = inttoptr i64 %1 to i64*
  store i64 5, i64* %2, align 8
  store i64 %1, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %3 = call %struct.Memory* @sub_1020(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  ret %struct.Memory* %3
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1100_main(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1100:
  %0 = load i64, i64* @R13_2424_31c7d5b8, align 8
  %1 = load i64, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1314
  %2 = add i64 %1, -8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3, align 8
  %4 = load i64, i64* @R12_2408_31c7d5b8, align 8
  %5 = add i64 %2, -8
  %6 = getelementptr i64, i64* %3, i32 -1
  store i64 %4, i64* %6, align 8
  store i8* @data_2004, i8** @R12_2408_31c84a60, align 8
  %7 = load i64, i64* @RBP_2328_31c7d5b8, align 8
  %8 = add i64 %5, -8
  %9 = getelementptr i64, i64* %6, i32 -1
  store i64 %7, i64* %9, align 8
  store i8* @data_2006, i8** @RBP_2328_31c84a60, align 8
  %10 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %11 = add i64 %8, -8
  %12 = getelementptr i64, i64* %9, i32 -1
  store i64 %10, i64* %12, align 8
  %13 = sub i64 %11, 88
  %14 = inttoptr i64 %13 to i64*
  %15 = inttoptr i64 %13 to i32*
  %16 = icmp ult i64 %11, 88
  %17 = zext i1 %16 to i8
  store i8 %17, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  %18 = trunc i64 %13 to i32
  %19 = and i32 %18, 255
  %20 = call i32 @llvm.ctpop.i32(i32 %19) #13, !range !1308
  %21 = trunc i32 %20 to i8
  %22 = and i8 %21, 1
  %23 = xor i8 %22, 1
  store i8 %23, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  %24 = xor i64 88, %11
  %25 = xor i64 %24, %13
  %26 = lshr i64 %25, 4
  %27 = trunc i64 %26 to i8
  %28 = and i8 %27, 1
  store i8 %28, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  %29 = icmp eq i64 %13, 0
  %30 = zext i1 %29 to i8
  store i8 %30, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  %31 = lshr i64 %13, 63
  %32 = trunc i64 %31 to i8
  store i8 %32, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  %33 = lshr i64 %11, 63
  %34 = xor i64 %31, %33
  %35 = add nuw nsw i64 %34, %33
  %36 = icmp eq i64 %35, 2
  %37 = zext i1 %36 to i8
  store i8 %37, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  %38 = load i64, i64* @FSBASE_2168_31c7d5b8, align 8
  %39 = add i64 %38, 40
  %40 = inttoptr i64 %39 to i64*
  %41 = load i64, i64* %40, align 8
  %42 = getelementptr i64, i64* %14, i32 9
  store i64 %41, i64* %42, align 8
  store i64 %13, i64* @RBX_2232_31c7d5b8, align 8, !tbaa !1290
  %43 = add i64 %13, 56
  store i64 %43, i64* @R13_2424_31c7d5b8, align 8, !tbaa !1290
  %44 = getelementptr i32, i32* %15, i32 14
  store i32 -1, i32* %44, align 4
  store i64 %13, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  store i64 12884901893, i64* %14, align 8
  %45 = getelementptr i64, i64* %14, i32 1
  store i64 8589934593, i64* %45, align 8
  %46 = getelementptr i64, i64* %14, i32 2
  store i64 21474836489, i64* %46, align 8
  %47 = getelementptr i64, i64* %14, i32 3
  store i64 25769803781, i64* %47, align 8
  %48 = getelementptr i64, i64* %14, i32 4
  store i64 34359738375, i64* %48, align 8
  %49 = getelementptr i64, i64* %14, i32 5
  store i64 17179869184, i64* %49, align 8
  store i64 42949672964, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %50 = getelementptr i64, i64* %14, i32 6
  store i64 42949672964, i64* %50, align 8
  %51 = add i64 %13, -8
  %52 = getelementptr i64, i64* %14, i32 -1
  store i64 ptrtoint (i8* @data_11aa to i64), i64* %52, align 8
  store i64 %51, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %53 = call %struct.Memory* @sub_1300_timsort_constprop_0(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  br label %inst_11b0

inst_11b0:                                        ; preds = %inst_11b0, %inst_1100
  %54 = phi i64 [ ptrtoint (i8* @data_11b0 to i64), %inst_1100 ], [ %104, %inst_11b0 ]
  %55 = phi %struct.Memory* [ %53, %inst_1100 ], [ %97, %inst_11b0 ]
  %56 = add i64 %54, 2
  %57 = load i32*, i32** @RBX_2232_31c8a140, align 8
  %58 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %59 = load i32, i32* %57, align 4
  %60 = zext i32 %59 to i64
  store i64 %60, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %61 = add i64 %56, 3
  %62 = load i64, i64* @R12_2408_31c7d5b8, align 8
  store i64 %62, i64* @RCX_2248_31c7d5b8, align 8, !tbaa !1290
  %63 = add i64 %61, 3
  %64 = load i64, i64* @RBP_2328_31c7d5b8, align 8
  store i64 %64, i64* @RSI_2280_31c7d5b8, align 8, !tbaa !1290
  %65 = add i64 %63, 5
  store i64 1, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  %66 = add i64 %65, 2
  store i64 0, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %67 = add i64 %66, 4
  %68 = add i64 4, %58
  store i64 %68, i64* @RBX_2232_31c7d5b8, align 8, !tbaa !1290
  %69 = icmp ult i64 %68, %58
  %70 = icmp ult i64 %68, 4
  %71 = or i1 %69, %70
  %72 = zext i1 %71 to i8
  store i8 %72, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  %73 = trunc i64 %68 to i32
  %74 = and i32 %73, 255
  %75 = call i32 @llvm.ctpop.i32(i32 %74) #13, !range !1308
  %76 = trunc i32 %75 to i8
  %77 = and i8 %76, 1
  %78 = xor i8 %77, 1
  store i8 %78, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  %79 = xor i64 4, %58
  %80 = xor i64 %79, %68
  %81 = lshr i64 %80, 4
  %82 = trunc i64 %81 to i8
  %83 = and i8 %82, 1
  store i8 %83, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  %84 = icmp eq i64 %68, 0
  %85 = zext i1 %84 to i8
  store i8 %85, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  %86 = lshr i64 %68, 63
  %87 = trunc i64 %86 to i8
  store i8 %87, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  %88 = lshr i64 %58, 63
  %89 = xor i64 %86, %88
  %90 = add nuw nsw i64 %89, %86
  %91 = icmp eq i64 %90, 2
  %92 = zext i1 %91 to i8
  store i8 %92, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  %93 = add i64 %67, 5
  %94 = load i64, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1314
  %95 = add i64 %94, -8
  %96 = inttoptr i64 %95 to i64*
  store i64 %93, i64* %96, align 8
  store i64 %95, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %97 = call %struct.Memory* @ext_10f0____printf_chk(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %55)
  %98 = load i64, i64* @R13_2424_31c7d5b8, align 8
  %99 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %100 = sub i64 %98, %99
  %101 = icmp eq i64 %100, 0
  %102 = zext i1 %101 to i8
  %103 = icmp eq i8 %102, 0
  %104 = select i1 %103, i64 ptrtoint (i8* @data_11b0 to i64), i64 ptrtoint (i8* @data_11cd to i64)
  br i1 %103, label %inst_11b0, label %inst_11cd

inst_11cd:                                        ; preds = %inst_11b0
  %105 = add i64 %104, 4
  %106 = load i64*, i64** @RSP_2312_31c84bc0, align 8
  %107 = load i32*, i32** @RSP_2312_31c8a140, align 8
  %108 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %109 = getelementptr i32, i32* %107, i32 14
  %110 = load i32, i32* %109, align 4
  %111 = zext i32 %110 to i64
  store i64 %111, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %112 = add i64 %105, 2
  store i64 0, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  store i8 0, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  store i8 1, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  store i8 1, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  store i8 0, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  store i8 0, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  store i8 0, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  %113 = add i64 %112, 7
  store i8* @data_200b, i8** @RCX_2248_31c84a60, align 8
  %114 = add i64 %113, 3
  %115 = load i64, i64* @RBP_2328_31c7d5b8, align 8
  store i64 %115, i64* @RSI_2280_31c7d5b8, align 8, !tbaa !1290
  %116 = add i64 %114, 5
  store i64 1, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  %117 = add i64 %116, 5
  %118 = add i64 %108, -8
  %119 = getelementptr i64, i64* %106, i32 -1
  store i64 %117, i64* %119, align 8
  store i64 %118, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %120 = call %struct.Memory* @ext_10f0____printf_chk(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %97)
  %121 = load i64*, i64** @RSP_2312_31c84bc0, align 8
  %122 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %123 = getelementptr i64, i64* %121, i32 9
  %124 = load i64, i64* %123, align 8
  %125 = load i64, i64* @FSBASE_2168_31c7d5b8, align 8
  %126 = add i64 %125, 40
  %127 = inttoptr i64 %126 to i64*
  %128 = load i64, i64* %127, align 8
  %129 = sub i64 %124, %128
  store i64 %129, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %130 = icmp ugt i64 %128, %124
  %131 = zext i1 %130 to i8
  store i8 %131, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  %132 = trunc i64 %129 to i32
  %133 = and i32 %132, 255
  %134 = call i32 @llvm.ctpop.i32(i32 %133) #13, !range !1308
  %135 = trunc i32 %134 to i8
  %136 = and i8 %135, 1
  %137 = xor i8 %136, 1
  store i8 %137, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  %138 = xor i64 %128, %124
  %139 = xor i64 %138, %129
  %140 = lshr i64 %139, 4
  %141 = trunc i64 %140 to i8
  %142 = and i8 %141, 1
  store i8 %142, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  %143 = icmp eq i64 %129, 0
  %144 = zext i1 %143 to i8
  store i8 %144, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  %145 = lshr i64 %129, 63
  %146 = trunc i64 %145 to i8
  store i8 %146, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  %147 = lshr i64 %124, 63
  %148 = lshr i64 %128, 63
  %149 = xor i64 %148, %147
  %150 = xor i64 %145, %147
  %151 = add nuw nsw i64 %150, %149
  %152 = icmp eq i64 %151, 2
  %153 = zext i1 %152 to i8
  store i8 %153, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  %154 = icmp eq i8 %144, 0
  br i1 %154, label %inst_1204, label %inst_11f7

inst_1204:                                        ; preds = %inst_11cd
  %155 = add i64 %122, -8
  %156 = inttoptr i64 %155 to i64*
  store i64 add (i64 ptrtoint (i8* @data_1204 to i64), i64 5), i64* %156, align 8
  store i64 %155, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %157 = call %struct.Memory* @ext_10b0____stack_chk_fail(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %120)
  ret %struct.Memory* %157

inst_11f7:                                        ; preds = %inst_11cd
  %158 = add i64 88, %122
  %159 = getelementptr i64, i64* %121, i32 11
  store i64 0, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  store i8 0, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  store i8 1, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  store i8 1, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  store i8 0, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  store i8 0, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  store i8 0, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  %160 = add i64 %158, 8
  %161 = getelementptr i64, i64* %159, i32 1
  %162 = load i64, i64* %159, align 8
  store i64 %162, i64* @RBX_2232_31c7d5b8, align 8, !tbaa !1290
  %163 = add i64 %160, 8
  %164 = getelementptr i64, i64* %161, i32 1
  %165 = load i64, i64* %161, align 8
  store i64 %165, i64* @RBP_2328_31c7d5b8, align 8, !tbaa !1290
  %166 = add i64 %163, 8
  %167 = load i64, i64* %164, align 8
  store i64 %167, i64* @R12_2408_31c7d5b8, align 8, !tbaa !1290
  %168 = add i64 %166, 8
  %169 = getelementptr i64, i64* %164, i32 1
  %170 = load i64, i64* %169, align 8
  store i64 %170, i64* @R13_2424_31c7d5b8, align 8, !tbaa !1290
  %171 = add i64 %168, 8
  store i64 %171, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  ret %struct.Memory* %120
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1210__start(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1210:
  store i64 0, i64* @RBP_2328_31c7d5b8, align 8, !tbaa !1290
  %0 = load i64, i64* @RDX_2264_31c7d5b8, align 8
  store i64 %0, i64* @R9_2360_31c7d5b8, align 8, !tbaa !1290
  %1 = load i64*, i64** @RSP_2312_31c84bc0, align 8
  %2 = load i64, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1314
  %3 = add i64 %2, 8
  %4 = load i64, i64* %1, align 8
  store i64 %4, i64* @RSI_2280_31c7d5b8, align 8, !tbaa !1290
  store i64 %3, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %5 = and i64 -16, %3
  %6 = load i64, i64* @RAX_2216_31c7d5b8, align 8
  %7 = add i64 %5, -8
  %8 = inttoptr i64 %7 to i64*
  store i64 %6, i64* %8, align 8
  %9 = add i64 %7, -8
  %10 = getelementptr i64, i64* %8, i32 -1
  store i64 %7, i64* %10, align 8
  store i64 0, i64* @R8_2344_31c7d5b8, align 8, !tbaa !1290
  store i64 0, i64* @RCX_2248_31c7d5b8, align 8, !tbaa !1290
  store i8 0, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  store i8 1, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  store i8 1, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  store i8 0, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  store i8 0, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  store i8 0, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  store i32 (i32, i8**, i8**)* @main, i32 (i32, i8**, i8**)** @RDI_2296_31c8bfa0, align 8
  %11 = add i64 %9, -8
  %12 = load i64, i64* bitcast (i8** @data_3fd8 to i64*), align 8
  %13 = getelementptr i64, i64* %10, i32 -1
  store i64 ptrtoint (i8** @data_3fd8 to i64), i64* %13, align 8
  store i64 %11, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  store i64 %12, i64* @RIP_2472_31c7d5b8, align 8, !tbaa !1290
  %14 = call %struct.Memory* @__remill_function_call(%struct.State* @__mcsema_reg_state, i64 %12, %struct.Memory* %memory)
  store i8* @data_1235, i8** @RIP_2472_31c84a60, align 8
  call void @abort() #13
  unreachable
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1060(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1060:
  %0 = load i64, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1314
  %1 = add i64 %0, -8
  %2 = inttoptr i64 %1 to i64*
  store i64 3, i64* %2, align 8
  store i64 %1, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %3 = call %struct.Memory* @sub_1020(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  ret %struct.Memory* %3
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_12b0___do_global_dtors_aux(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_12b0:
  %0 = load i8, i8* @data_4010, align 1
  store i8 0, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  %1 = zext i8 %0 to i32
  %2 = call i32 @llvm.ctpop.i32(i32 %1) #13, !range !1308
  %3 = trunc i32 %2 to i8
  %4 = and i8 %3, 1
  %5 = xor i8 %4, 1
  store i8 %5, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  store i8 0, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  %6 = icmp eq i8 %0, 0
  %7 = zext i1 %6 to i8
  store i8 %7, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  %8 = lshr i8 %0, 7
  store i8 %8, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  store i8 0, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  %9 = icmp eq i8 %7, 0
  br i1 %9, label %inst_12e8, label %inst_12bd

inst_12d7:                                        ; preds = %inst_12cb, %inst_12bd
  %10 = phi i64 [ %40, %inst_12bd ], [ ptrtoint (i8* @data_12d7 to i64), %inst_12cb ]
  %11 = phi %struct.Memory* [ %memory, %inst_12bd ], [ %46, %inst_12cb ]
  %12 = add i64 %10, 5
  %13 = load i64, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1314
  %14 = add i64 %13, -8
  %15 = inttoptr i64 %14 to i64*
  store i64 %12, i64* %15, align 8
  store i64 %14, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %16 = call %struct.Memory* @sub_1240_deregister_tm_clones(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %11)
  store i8 1, i8* @data_4010, align 1
  %17 = load i64*, i64** @RSP_2312_31c84bc0, align 8
  %18 = load i64, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1314
  %19 = add i64 %18, 8
  %20 = load i64, i64* %17, align 8
  store i64 %20, i64* @RBP_2328_31c7d5b8, align 8, !tbaa !1290
  %21 = add i64 %19, 8
  store i64 %21, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  ret %struct.Memory* %16

inst_12e8:                                        ; preds = %inst_12b0
  %22 = load i64, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1314
  %23 = add i64 %22, 8
  store i64 %23, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  ret %struct.Memory* %memory

inst_12bd:                                        ; preds = %inst_12b0
  %24 = load i64, i64* @RBP_2328_31c7d5b8, align 8
  %25 = load i64, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1314
  %26 = add i64 %25, -8
  %27 = inttoptr i64 %26 to i64*
  store i64 %24, i64* %27, align 8
  store i64 %26, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %28 = load i64, i64* bitcast (i8** @data_3ff8 to i64*), align 8
  store i8 0, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  %29 = trunc i64 %28 to i32
  %30 = and i32 %29, 255
  %31 = call i32 @llvm.ctpop.i32(i32 %30) #13, !range !1308
  %32 = trunc i32 %31 to i8
  %33 = and i8 %32, 1
  %34 = xor i8 %33, 1
  store i8 %34, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  store i8 0, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  %35 = icmp eq i64 %28, 0
  %36 = zext i1 %35 to i8
  store i8 %36, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  %37 = lshr i64 %28, 63
  %38 = trunc i64 %37 to i8
  store i8 %38, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  store i8 0, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  store i64 %26, i64* @RBP_2328_31c7d5b8, align 8, !tbaa !1290
  %39 = icmp eq i8 %36, 0
  %40 = select i1 %39, i64 add (i64 ptrtoint (i8* @data_12bd to i64), i64 14), i64 add (i64 ptrtoint (i8* @data_12bd to i64), i64 26)
  br i1 %35, label %inst_12d7, label %inst_12cb

inst_12cb:                                        ; preds = %inst_12bd
  %41 = add i64 %40, 7
  %42 = load i64, i64* bitcast (i8** @data_4008 to i64*), align 8
  store i64 %42, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  %43 = add i64 %41, 5
  %44 = add i64 %26, -8
  %45 = getelementptr i64, i64* %27, i32 -1
  store i64 %43, i64* %45, align 8
  store i64 %44, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %46 = call %struct.Memory* @ext_1090___cxa_finalize(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  br label %inst_12d7
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_12f0_frame_dummy(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_12f0:
  %0 = call %struct.Memory* @sub_1270_register_tm_clones(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  ret %struct.Memory* %0
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1300_timsort_constprop_0(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1300:
  %0 = load i64, i64* @R15_2456_31c7d5b8, align 8
  %1 = load i64, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1314
  %2 = add i64 %1, -8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3, align 8
  %4 = load i64, i64* @R14_2440_31c7d5b8, align 8
  %5 = add i64 %2, -8
  %6 = getelementptr i64, i64* %3, i32 -1
  store i64 %4, i64* %6, align 8
  %7 = load i64, i64* @R13_2424_31c7d5b8, align 8
  %8 = add i64 %5, -8
  %9 = getelementptr i64, i64* %6, i32 -1
  store i64 %7, i64* %9, align 8
  %10 = load i64, i64* @R12_2408_31c7d5b8, align 8
  %11 = add i64 %8, -8
  %12 = getelementptr i64, i64* %9, i32 -1
  store i64 %10, i64* %12, align 8
  %13 = load i64, i64* @RBP_2328_31c7d5b8, align 8
  %14 = add i64 %11, -8
  %15 = getelementptr i64, i64* %12, i32 -1
  store i64 %13, i64* %15, align 8
  %16 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %17 = add i64 %14, -8
  %18 = getelementptr i64, i64* %15, i32 -1
  store i64 %16, i64* %18, align 8
  %19 = load i64, i64* @RDI_2296_31c7d5b8, align 8
  store i64 %19, i64* @RBX_2232_31c7d5b8, align 8, !tbaa !1290
  store i64 60, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  %20 = sub i64 %17, 2120
  %21 = inttoptr i64 %20 to i64*
  %22 = load i64, i64* @FSBASE_2168_31c7d5b8, align 8
  %23 = add i64 %22, 40
  %24 = inttoptr i64 %23 to i64*
  %25 = load i64, i64* %24, align 8
  %26 = getelementptr i64, i64* %21, i32 263
  store i64 %25, i64* %26, align 8
  store i64 0, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  store i8 0, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  store i8 1, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  store i8 1, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  store i8 0, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  store i8 0, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  store i8 0, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  %27 = add i64 %20, -8
  %28 = getelementptr i64, i64* %21, i32 -1
  store i64 ptrtoint (i8* @data_1331 to i64), i64* %28, align 8
  store i64 %27, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %29 = call %struct.Memory* @ext_10e0__malloc(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  %30 = load i64, i64* @RAX_2216_31c7d5b8, align 8
  %31 = icmp eq i64 %30, 0
  %32 = zext i1 %31 to i8
  %33 = icmp eq i8 %32, 0
  %34 = select i1 %33, i64 ptrtoint (i8* @data_133a to i64), i64 ptrtoint (i8* @data_1b6d to i64)
  br i1 %31, label %inst_1b6d, label %inst_133a

inst_1808:                                        ; preds = %inst_1b9b, %inst_17fa, %inst_17d0, %inst_1b92
  %35 = phi %struct.Memory* [ %656, %inst_1b92 ], [ %2150, %inst_1b9b ], [ %1554, %inst_17d0 ], [ %1554, %inst_17fa ]
  %36 = load i64, i64* @R15_2456_31c7d5b8, align 8
  %37 = load i64, i64* @R8_2344_31c7d5b8, align 8
  %38 = add i64 %37, %36
  store i64 %38, i64* @R15_2456_31c7d5b8, align 8, !tbaa !1290
  %39 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %40 = add i64 %39, 1072
  %41 = inttoptr i64 %40 to i64*
  store i64 %38, i64* %41, align 8
  br label %inst_16ad

inst_1413:                                        ; preds = %inst_1400, %inst_13e8
  %42 = load i32*, i32** @RAX_2216_31c8a140, align 8
  %43 = load i64, i64* @RAX_2216_31c7d5b8, align 8
  %44 = sub i64 %43, 4
  %45 = inttoptr i64 %44 to i32*
  %46 = load i32, i32* %45, align 4
  %47 = zext i32 %46 to i64
  store i64 %47, i64* @RCX_2248_31c7d5b8, align 8, !tbaa !1290
  store i64 %43, i64* @RSI_2280_31c7d5b8, align 8, !tbaa !1290
  %48 = load i32, i32* @RDI_2296_31c7d5a0, align 4
  %49 = sub i32 %48, %46
  %50 = lshr i32 %49, 31
  %51 = trunc i32 %50 to i8
  %52 = lshr i32 %48, 31
  %53 = lshr i32 %46, 31
  %54 = xor i32 %53, %52
  %55 = xor i32 %50, %52
  %56 = add nuw nsw i32 %55, %54
  %57 = icmp eq i32 %56, 2
  %58 = icmp ne i8 %51, 0
  %59 = xor i1 %58, %57
  br i1 %59, label %inst_1400, label %inst_141d

inst_141d:                                        ; preds = %inst_13e8, %inst_1413
  %60 = add i64 1, %946
  store i64 %60, i64* @R10_2376_31c7d5b8, align 8, !tbaa !1290
  %61 = load i32*, i32** @RSI_2280_31c8a140, align 8
  %62 = load i32, i32* @RDI_2296_31c7d5a0, align 4
  store i32 %62, i32* %61, align 4
  %63 = add i64 4, %943
  store i64 %63, i64* @R11_2392_31c7d5b8, align 8, !tbaa !1290
  %64 = sub i64 %756, %60
  %65 = icmp eq i64 %64, 0
  %66 = zext i1 %65 to i8
  %67 = icmp eq i8 %66, 0
  br i1 %67, label %inst_13e8, label %inst_1450

inst_143d:                                        ; preds = %inst_1430, %inst_135c
  %68 = phi i64 [ %1059, %inst_135c ], [ %1124, %inst_1430 ]
  %69 = add i64 %68, 4
  %70 = load i64, i64* @RBP_2328_31c7d5b8, align 8
  %71 = add i64 1, %70
  store i64 %71, i64* @RBP_2328_31c7d5b8, align 8, !tbaa !1290
  %72 = add i64 %69, 4
  %73 = sub i64 %71, 15
  %74 = icmp eq i64 %73, 0
  %75 = zext i1 %74 to i8
  %76 = add i64 %72, 2
  %77 = sub i64 %76, 23
  %78 = icmp eq i8 %75, 0
  %79 = select i1 %78, i64 %77, i64 %76
  br i1 %78, label %inst_1430, label %inst_1447

inst_1450:                                        ; preds = %inst_1447, %inst_14c0, %inst_13b1, %inst_1348, %inst_141d
  %80 = phi i64 [ %511, %inst_1348 ], [ %763, %inst_13b1 ], [ %1126, %inst_1447 ], [ undef, %inst_141d ], [ undef, %inst_14c0 ]
  %81 = phi %struct.Memory* [ %499, %inst_1348 ], [ %499, %inst_13b1 ], [ %499, %inst_1447 ], [ %499, %inst_141d ], [ %499, %inst_14c0 ]
  %82 = add i64 %80, 3
  %83 = load i64, i64* @R12_2408_31c7d5b8, align 8
  %84 = sub i64 %83, %501
  store i64 %84, i64* @R12_2408_31c7d5b8, align 8, !tbaa !1290
  %85 = add i64 %82, 5
  %86 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %87 = load i64, i64* @R9_2360_31c7d5b8, align 8
  %88 = mul i64 %87, 8
  %89 = add i64 %86, 48
  %90 = add i64 %89, %88
  %91 = inttoptr i64 %90 to i64*
  store i64 %501, i64* %91, align 8
  %92 = add i64 %85, 8
  %93 = add i64 %86, 1072
  %94 = add i64 %93, %88
  %95 = inttoptr i64 %94 to i64*
  store i64 %84, i64* %95, align 8
  %96 = add i64 %92, 4
  %97 = add i64 1, %87
  store i64 %97, i64* @R9_2360_31c7d5b8, align 8, !tbaa !1290
  %98 = icmp ult i64 %97, 1
  %99 = add i64 %96, 4
  %100 = zext i1 %98 to i8
  %101 = icmp eq i64 %87, 0
  %102 = zext i1 %101 to i8
  %103 = add i64 %99, 2
  %104 = add i64 %103, 61
  %105 = or i8 %102, %100
  %106 = icmp ne i8 %105, 0
  %107 = select i1 %106, i64 %104, i64 %103
  br i1 %106, label %inst_14a7, label %inst_146a

inst_1a60:                                        ; preds = %inst_1a78, %inst_1a50
  %108 = phi i64 [ %1898, %inst_1a50 ], [ %1916, %inst_1a78 ]
  %109 = add i64 %108, 3
  %110 = load i64, i64* @RAX_2216_31c7d5b8, align 8
  %111 = icmp eq i64 %110, 0
  %112 = zext i1 %111 to i8
  %113 = add i64 %109, 6
  %114 = sub i64 %113, 169
  %115 = icmp eq i8 %112, 0
  %116 = select i1 %115, i64 %113, i64 %114
  br i1 %111, label %inst_19c0, label %inst_1a69

inst_1a69:                                        ; preds = %inst_1a44, %inst_1a60
  %117 = phi i64 [ %1880, %inst_1a44 ], [ %116, %inst_1a60 ]
  %118 = add i64 %117, 5
  %119 = load i64, i64* @R13_2424_31c7d5b8, align 8
  %120 = load i64, i64* @RAX_2216_31c7d5b8, align 8
  %121 = mul i64 %120, 4
  %122 = add i64 %119, -4
  %123 = add i64 %122, %121
  %124 = inttoptr i64 %123 to i32*
  %125 = load i32, i32* %124, align 4
  %126 = zext i32 %125 to i64
  store i64 %126, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  %127 = add i64 %118, 4
  %128 = load i64, i64* @R12_2408_31c7d5b8, align 8
  %129 = sub i64 %128, 1
  store i64 %129, i64* @R12_2408_31c7d5b8, align 8, !tbaa !1290
  %130 = add i64 %127, 4
  %131 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %132 = load i64, i64* @RDX_2264_31c7d5b8, align 8
  %133 = mul i64 %132, 4
  %134 = add i64 %131, -4
  %135 = add i64 %134, %133
  %136 = inttoptr i64 %135 to i32*
  %137 = load i32, i32* %136, align 4
  %138 = sub i32 %137, %125
  %139 = icmp eq i32 %138, 0
  %140 = zext i1 %139 to i8
  %141 = lshr i32 %138, 31
  %142 = trunc i32 %141 to i8
  %143 = lshr i32 %137, 31
  %144 = lshr i32 %125, 31
  %145 = xor i32 %143, %144
  %146 = xor i32 %141, %143
  %147 = add nuw nsw i32 %146, %145
  %148 = icmp eq i32 %147, 2
  %149 = add i64 %130, 2
  %150 = sub i64 %149, 40
  %151 = icmp eq i8 %140, 0
  %152 = icmp eq i8 %142, 0
  %153 = xor i1 %152, %148
  %154 = and i1 %151, %153
  %155 = select i1 %154, i64 %150, i64 %149
  %156 = add i64 %155, 4
  br i1 %154, label %inst_1a50, label %inst_1a78

inst_1670:                                        ; preds = %inst_168a, %inst_1660
  %157 = phi i64 [ %1467, %inst_1660 ], [ %1485, %inst_168a ]
  %158 = add i64 %157, 3
  %159 = load i64, i64* @R12_2408_31c7d5b8, align 8
  %160 = sub i64 %1434, %159
  %161 = icmp ult i64 %1434, %159
  %162 = zext i1 %161 to i8
  %163 = icmp eq i64 %160, 0
  %164 = zext i1 %163 to i8
  %165 = add i64 %158, 6
  %166 = add i64 %165, 1159
  %167 = or i8 %164, %162
  %168 = icmp ne i8 %167, 0
  %169 = select i1 %168, i64 %166, i64 %165
  br i1 %168, label %inst_1b00, label %inst_1679

inst_1474:                                        ; preds = %inst_15c5, %inst_146a
  %170 = phi %struct.Memory* [ %81, %inst_146a ], [ %765, %inst_15c5 ]
  %171 = add i64 %1134, 4
  %172 = load i64, i64* @R9_2360_31c7d5b8, align 8
  %173 = sub i64 %172, 2
  store i64 %173, i64* @R15_2456_31c7d5b8, align 8, !tbaa !1290
  %174 = add i64 %171, 4
  %175 = sub i64 %172, 3
  store i64 %175, i64* @R8_2344_31c7d5b8, align 8, !tbaa !1290
  %176 = add i64 %174, 8
  %177 = load i64*, i64** @RSP_2312_31c84bc0, align 8
  %178 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %179 = getelementptr i64, i64* %177, i32 -1
  %180 = getelementptr i64, i64* %177, i32 3
  %181 = getelementptr i64, i64* %177, i32 2
  %182 = getelementptr i64, i64* %177, i32 4
  %183 = mul i64 %173, 8
  %184 = add i64 %178, 1072
  %185 = add i64 %184, %183
  %186 = inttoptr i64 %185 to i64*
  %187 = load i64, i64* %186, align 8
  store i64 %187, i64* @R14_2440_31c7d5b8, align 8, !tbaa !1290
  %188 = add i64 %176, 8
  %189 = mul i64 %175, 8
  %190 = add i64 %184, %189
  %191 = inttoptr i64 %190 to i64*
  %192 = load i64, i64* %191, align 8
  store i64 %192, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %193 = add i64 %188, 4
  %194 = sub i64 %172, 1
  store i64 %194, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  %195 = add i64 %193, 5
  %196 = getelementptr i64, i64* %177, i32 1
  store i64 %194, i64* %196, align 8
  %197 = add i64 %195, 4
  %198 = load i64, i64* @R12_2408_31c7d5b8, align 8
  %199 = add i64 %198, %187
  store i64 %199, i64* @R11_2392_31c7d5b8, align 8, !tbaa !1290
  %200 = add i64 %197, 3
  %201 = sub i64 %192, %199
  %202 = icmp ult i64 %192, %199
  %203 = zext i1 %202 to i8
  %204 = icmp eq i64 %201, 0
  %205 = zext i1 %204 to i8
  %206 = add i64 %200, 2
  %207 = add i64 %206, 61
  %208 = or i8 %205, %203
  %209 = icmp ne i8 %208, 0
  %210 = select i1 %209, i64 %207, i64 %206
  %211 = add i64 %210, 3
  br i1 %209, label %inst_14db, label %inst_149e

inst_1878:                                        ; preds = %inst_1890, %inst_1868
  %212 = phi i64 [ %1636, %inst_1868 ], [ %1654, %inst_1890 ]
  %213 = add i64 %212, 3
  %214 = load i64, i64* @RAX_2216_31c7d5b8, align 8
  %215 = icmp eq i64 %214, 0
  %216 = zext i1 %215 to i8
  %217 = add i64 %213, 6
  %218 = sub i64 %217, 489
  %219 = icmp eq i8 %216, 0
  %220 = select i1 %219, i64 %217, i64 %218
  br i1 %215, label %inst_1698, label %inst_1881

inst_1679:                                        ; preds = %inst_1655, %inst_1670
  %221 = phi i64 [ %1446, %inst_1655 ], [ %169, %inst_1670 ]
  %222 = add i64 %221, 5
  %223 = load i64, i64* @R13_2424_31c7d5b8, align 8
  %224 = load i64, i64* @RDX_2264_31c7d5b8, align 8
  %225 = mul i64 %224, 4
  %226 = add i64 %225, %223
  %227 = inttoptr i64 %226 to i32*
  %228 = load i32, i32* %227, align 4
  %229 = zext i32 %228 to i64
  store i64 %229, i64* @RCX_2248_31c7d5b8, align 8, !tbaa !1290
  %230 = add i64 %222, 4
  %231 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %232 = load i64, i64* @R12_2408_31c7d5b8, align 8
  %233 = mul i64 %232, 4
  %234 = add i64 %233, %231
  %235 = inttoptr i64 %234 to i32*
  %236 = load i32, i32* %235, align 4
  %237 = zext i32 %236 to i64
  store i64 %237, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %238 = add i64 %230, 4
  %239 = load i64, i64* @R10_2376_31c7d5b8, align 8
  %240 = add i64 1, %239
  store i64 %240, i64* @R10_2376_31c7d5b8, align 8, !tbaa !1290
  %241 = add i64 %238, 2
  %242 = sub i32 %228, %236
  %243 = icmp eq i32 %242, 0
  %244 = lshr i32 %242, 31
  %245 = trunc i32 %244 to i8
  %246 = lshr i32 %228, 31
  %247 = lshr i32 %236, 31
  %248 = xor i32 %247, %246
  %249 = xor i32 %244, %246
  %250 = add nuw nsw i32 %249, %248
  %251 = icmp eq i32 %250, 2
  %252 = add i64 %241, 2
  %253 = sub i64 %252, 42
  %254 = icmp ne i8 %245, 0
  %255 = xor i1 %254, %251
  %256 = or i1 %243, %255
  %257 = select i1 %256, i64 %253, i64 %252
  br i1 %256, label %inst_1660, label %inst_168a

inst_1881:                                        ; preds = %inst_185e, %inst_1878
  %258 = phi i64 [ %1618, %inst_185e ], [ %220, %inst_1878 ]
  %259 = add i64 %258, 5
  %260 = load i64, i64* @R13_2424_31c7d5b8, align 8
  %261 = load i64, i64* @RAX_2216_31c7d5b8, align 8
  %262 = mul i64 %261, 4
  %263 = add i64 %260, -4
  %264 = add i64 %263, %262
  %265 = inttoptr i64 %264 to i32*
  %266 = load i32, i32* %265, align 4
  %267 = zext i32 %266 to i64
  store i64 %267, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  %268 = add i64 %259, 4
  %269 = load i64, i64* @R12_2408_31c7d5b8, align 8
  %270 = sub i64 %269, 1
  store i64 %270, i64* @R12_2408_31c7d5b8, align 8, !tbaa !1290
  %271 = add i64 %268, 4
  %272 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %273 = load i64, i64* @RDX_2264_31c7d5b8, align 8
  %274 = mul i64 %273, 4
  %275 = add i64 %272, -4
  %276 = add i64 %275, %274
  %277 = inttoptr i64 %276 to i32*
  %278 = load i32, i32* %277, align 4
  %279 = sub i32 %278, %266
  %280 = icmp eq i32 %279, 0
  %281 = zext i1 %280 to i8
  %282 = lshr i32 %279, 31
  %283 = trunc i32 %282 to i8
  %284 = lshr i32 %278, 31
  %285 = lshr i32 %266, 31
  %286 = xor i32 %284, %285
  %287 = xor i32 %282, %284
  %288 = add nuw nsw i32 %287, %286
  %289 = icmp eq i32 %288, 2
  %290 = add i64 %271, 2
  %291 = sub i64 %290, 40
  %292 = icmp eq i8 %281, 0
  %293 = icmp eq i8 %283, 0
  %294 = xor i1 %293, %289
  %295 = and i1 %292, %294
  %296 = select i1 %295, i64 %291, i64 %290
  %297 = add i64 %296, 4
  br i1 %295, label %inst_1868, label %inst_1890

inst_1a8a:                                        ; preds = %inst_1a78, %inst_1a50, %inst_1a44, %inst_1a0a
  %298 = phi i64 [ %1747, %inst_1a0a ], [ %1898, %inst_1a50 ], [ %1916, %inst_1a78 ], [ undef, %inst_1a44 ]
  %299 = phi %struct.Memory* [ %1734, %inst_1a0a ], [ %1734, %inst_1a50 ], [ %1734, %inst_1a78 ], [ %1734, %inst_1a44 ]
  %300 = add i64 %298, 3
  %301 = load i64, i64* @RAX_2216_31c7d5b8, align 8
  %302 = icmp eq i64 %301, 0
  %303 = zext i1 %302 to i8
  %304 = add i64 %300, 6
  %305 = sub i64 %304, 211
  %306 = icmp eq i8 %303, 0
  %307 = select i1 %306, i64 %304, i64 %305
  br i1 %302, label %inst_19c0, label %inst_1a93

inst_1698:                                        ; preds = %inst_1b09, %inst_18ab, %inst_168a, %inst_1660, %inst_1b00, %inst_18a2, %inst_1878
  %308 = phi i64 [ %339, %inst_18a2 ], [ undef, %inst_18ab ], [ %220, %inst_1878 ], [ %412, %inst_1b00 ], [ undef, %inst_1b09 ], [ %1467, %inst_1660 ], [ %1485, %inst_168a ]
  %309 = phi %struct.Memory* [ %331, %inst_18a2 ], [ %1695, %inst_18ab ], [ %1393, %inst_1878 ], [ %399, %inst_1b00 ], [ %2033, %inst_1b09 ], [ %1424, %inst_1660 ], [ %1424, %inst_168a ]
  %310 = add i64 %308, 3
  %311 = load i64, i64* @R9_2360_31c7d5b8, align 8
  %312 = load i64, i64* @R14_2440_31c7d5b8, align 8
  %313 = add i64 %312, %311
  %314 = add i64 %310, 8
  %315 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %316 = load i64, i64* @R8_2344_31c7d5b8, align 8
  %317 = mul i64 %316, 8
  %318 = add i64 %315, 1072
  %319 = add i64 %318, %317
  %320 = inttoptr i64 %319 to i64*
  store i64 %313, i64* %320, align 8
  %321 = add i64 %314, 4
  %322 = load i64, i64* @R15_2456_31c7d5b8, align 8
  %323 = sub i64 %322, 1
  %324 = icmp eq i64 %323, 0
  %325 = zext i1 %324 to i8
  %326 = add i64 %321, 6
  %327 = sub i64 %326, 242
  %328 = icmp eq i8 %325, 0
  %329 = select i1 %328, i64 %327, i64 %326
  br i1 %328, label %inst_15bb, label %inst_16ad

inst_18a2:                                        ; preds = %inst_1890, %inst_1868, %inst_185e, %inst_1818
  %330 = phi i64 [ %1409, %inst_1818 ], [ %1636, %inst_1868 ], [ %1654, %inst_1890 ], [ undef, %inst_185e ]
  %331 = phi %struct.Memory* [ %1393, %inst_1818 ], [ %1393, %inst_1868 ], [ %1393, %inst_1890 ], [ %1393, %inst_185e ]
  %332 = add i64 %330, 3
  %333 = load i64, i64* @RAX_2216_31c7d5b8, align 8
  %334 = icmp eq i64 %333, 0
  %335 = zext i1 %334 to i8
  %336 = add i64 %332, 6
  %337 = sub i64 %336, 531
  %338 = icmp eq i8 %335, 0
  %339 = select i1 %338, i64 %336, i64 %337
  br i1 %334, label %inst_1698, label %inst_18ab

inst_14a7:                                        ; preds = %inst_149e, %inst_1766, %inst_16ad, %inst_1450
  %340 = phi i64 [ %107, %inst_1450 ], [ %630, %inst_1766 ], [ undef, %inst_16ad ], [ %1150, %inst_149e ]
  %341 = phi %struct.Memory* [ %81, %inst_1450 ], [ %591, %inst_1766 ], [ %345, %inst_16ad ], [ %170, %inst_149e ]
  %342 = load i64, i64* @RBP_2328_31c7d5b8, align 8
  %343 = sub i64 %342, 15
  %344 = icmp eq i64 %343, 0
  br i1 %344, label %inst_18e9, label %inst_14b1

inst_16ad:                                        ; preds = %inst_1698, %inst_1808
  %345 = phi %struct.Memory* [ %35, %inst_1808 ], [ %309, %inst_1698 ]
  store i64 1, i64* @R9_2360_31c7d5b8, align 8, !tbaa !1290
  br label %inst_14a7

inst_1ac3:                                        ; preds = %inst_196f, %inst_192d, %inst_198f
  %346 = phi i64 [ %1780, %inst_192d ], [ %654, %inst_198f ], [ undef, %inst_196f ]
  %347 = phi %struct.Memory* [ %1767, %inst_192d ], [ %1767, %inst_198f ], [ %1767, %inst_196f ]
  %348 = add i64 %346, 3
  %349 = load i64, i64* @R15_2456_31c7d5b8, align 8
  %350 = load i64, i64* @RDX_2264_31c7d5b8, align 8
  %351 = sub i64 %349, %350
  %352 = icmp ult i64 %349, %350
  %353 = zext i1 %352 to i8
  %354 = icmp eq i64 %351, 0
  %355 = zext i1 %354 to i8
  %356 = add i64 %348, 6
  %357 = sub i64 %356, 268
  %358 = or i8 %355, %353
  %359 = icmp ne i8 %358, 0
  %360 = select i1 %359, i64 %357, i64 %356
  br i1 %359, label %inst_19c0, label %inst_1acc

inst_16d9:                                        ; preds = %inst_16c1, %inst_14e4
  %361 = phi i64 [ %1241, %inst_14e4 ], [ %1500, %inst_16c1 ]
  %362 = add i64 %361, 8
  %363 = mul i64 %187, 4
  store i64 %363, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %364 = add i64 %362, 4
  %365 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %366 = load i64, i64* @R8_2344_31c7d5b8, align 8
  %367 = mul i64 %366, 4
  %368 = add i64 %367, %365
  store i64 %368, i64* @RSI_2280_31c7d5b8, align 8, !tbaa !1290
  %369 = add i64 %364, 5
  store i64 60, i64* @RCX_2248_31c7d5b8, align 8, !tbaa !1290
  %370 = add i64 %369, 3
  %371 = load i64, i64* @R13_2424_31c7d5b8, align 8
  store i64 %371, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  %372 = add i64 %370, 5
  %373 = load i64, i64* @R9_2360_31c7d5b8, align 8
  %374 = getelementptr i64, i64* %177, i32 5
  store i64 %373, i64* %374, align 8
  %375 = add i64 %372, 5
  store i64 %199, i64* %182, align 8
  %376 = add i64 %375, 5
  store i64 %366, i64* %180, align 8
  %377 = add i64 %376, 5
  %378 = add i64 %178, -8
  store i64 %377, i64* %179, align 8
  store i64 %378, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %379 = call %struct.Memory* @ext_10c0____memcpy_chk(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %170)
  %380 = load i64*, i64** @RSP_2312_31c84bc0, align 8
  %381 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %382 = getelementptr i64, i64* %380, i32 5
  %383 = load i64, i64* %382, align 8
  store i64 %383, i64* @R9_2360_31c7d5b8, align 8, !tbaa !1290
  store i64 0, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %384 = getelementptr i64, i64* %380, i32 2
  %385 = load i64, i64* %384, align 8
  %386 = sub i64 %385, %383
  %387 = icmp ult i64 %385, %383
  %388 = zext i1 %387 to i8
  %389 = icmp eq i64 %386, 0
  %390 = zext i1 %389 to i8
  %391 = getelementptr i64, i64* %380, i32 3
  %392 = load i64, i64* %391, align 8
  store i64 %392, i64* @R8_2344_31c7d5b8, align 8, !tbaa !1290
  %393 = getelementptr i64, i64* %380, i32 4
  %394 = load i64, i64* %393, align 8
  store i64 %394, i64* @R11_2392_31c7d5b8, align 8, !tbaa !1290
  %395 = or i8 %390, %388
  %396 = icmp ne i8 %395, 0
  %397 = select i1 %396, i64 ptrtoint (i8* @data_1b3d to i64), i64 ptrtoint (i8* @data_171d to i64)
  br i1 %396, label %inst_1b3d, label %inst_171d

inst_1b00:                                        ; preds = %inst_1655, %inst_160f, %inst_1670
  %398 = phi i64 [ %1438, %inst_160f ], [ %169, %inst_1670 ], [ undef, %inst_1655 ]
  %399 = phi %struct.Memory* [ %1424, %inst_160f ], [ %1424, %inst_1670 ], [ %1424, %inst_1655 ]
  %400 = add i64 %398, 3
  %401 = load i64, i64* @R14_2440_31c7d5b8, align 8
  %402 = load i64, i64* @RDX_2264_31c7d5b8, align 8
  %403 = sub i64 %401, %402
  %404 = icmp ult i64 %401, %402
  %405 = zext i1 %404 to i8
  %406 = icmp eq i64 %403, 0
  %407 = zext i1 %406 to i8
  %408 = add i64 %400, 6
  %409 = sub i64 %408, 1137
  %410 = or i8 %407, %405
  %411 = icmp ne i8 %410, 0
  %412 = select i1 %411, i64 %409, i64 %408
  br i1 %411, label %inst_1698, label %inst_1b09

inst_1910:                                        ; preds = %inst_18f3, %inst_19c0
  %413 = phi i64 [ %1716, %inst_18f3 ], [ %801, %inst_19c0 ]
  %414 = phi %struct.Memory* [ %341, %inst_18f3 ], [ %776, %inst_19c0 ]
  %415 = add i64 %413, 4
  %416 = load i64, i64* @R10_2376_31c7d5b8, align 8
  %417 = sub i64 %416, 8
  %418 = inttoptr i64 %417 to i64*
  %419 = load i64, i64* %418, align 8
  store i64 %419, i64* @R11_2392_31c7d5b8, align 8, !tbaa !1290
  %420 = add i64 %415, 4
  %421 = load i64, i64* @R14_2440_31c7d5b8, align 8
  %422 = sub i64 %421, 8
  %423 = inttoptr i64 %422 to i64*
  %424 = load i64, i64* %423, align 8
  store i64 %424, i64* @R8_2344_31c7d5b8, align 8, !tbaa !1290
  %425 = add i64 %420, 4
  %426 = sub i64 %421, 16
  %427 = inttoptr i64 %426 to i64*
  %428 = load i64, i64* %427, align 8
  store i64 %428, i64* @R15_2456_31c7d5b8, align 8, !tbaa !1290
  %429 = add i64 %425, 4
  %430 = sub i64 %416, 16
  %431 = inttoptr i64 %430 to i64*
  %432 = load i64, i64* %431, align 8
  store i64 %432, i64* @RBP_2328_31c7d5b8, align 8, !tbaa !1290
  %433 = add i64 %429, 4
  %434 = add i64 %424, %419
  store i64 %434, i64* @R12_2408_31c7d5b8, align 8, !tbaa !1290
  %435 = add i64 %433, 3
  %436 = sub i64 %424, %428
  %437 = icmp ult i64 %424, %428
  %438 = zext i1 %437 to i8
  store i8 %438, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  %439 = trunc i64 %436 to i32
  %440 = and i32 %439, 255
  %441 = call i32 @llvm.ctpop.i32(i32 %440) #13, !range !1308
  %442 = trunc i32 %441 to i8
  %443 = and i8 %442, 1
  %444 = xor i8 %443, 1
  store i8 %444, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  %445 = xor i64 %428, %424
  %446 = xor i64 %445, %436
  %447 = lshr i64 %446, 4
  %448 = trunc i64 %447 to i8
  %449 = and i8 %448, 1
  store i8 %449, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  %450 = icmp eq i64 %436, 0
  %451 = zext i1 %450 to i8
  store i8 %451, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  %452 = lshr i64 %436, 63
  %453 = trunc i64 %452 to i8
  store i8 %453, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  %454 = lshr i64 %424, 63
  %455 = lshr i64 %428, 63
  %456 = xor i64 %455, %454
  %457 = xor i64 %452, %454
  %458 = add nuw nsw i64 %457, %456
  %459 = icmp eq i64 %458, 2
  %460 = zext i1 %459 to i8
  store i8 %460, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  %461 = add i64 %435, 6
  %462 = add i64 %461, 221
  %463 = icmp eq i8 %438, 0
  %464 = select i1 %463, i64 %461, i64 %462
  %465 = add i64 %464, 8
  br i1 %437, label %inst_1a0a, label %inst_192d

inst_1736:                                        ; preds = %inst_1760, %inst_1730
  %466 = phi i64 [ %1530, %inst_1730 ], [ undef, %inst_1760 ]
  %467 = add i64 %466, 5
  %468 = mul i64 %528, 4
  %469 = add i64 %520, -4
  %470 = add i64 %469, %468
  %471 = load i32, i32* @RAX_2216_31c7d5a0, align 4
  %472 = inttoptr i64 %470 to i32*
  store i32 %471, i32* %472, align 4
  %473 = add i64 %467, 3
  %474 = load i64, i64* @RDX_2264_31c7d5b8, align 8
  %475 = sub i64 %1502, %474
  %476 = icmp ult i64 %1502, %474
  %477 = zext i1 %476 to i8
  %478 = icmp eq i64 %475, 0
  %479 = zext i1 %478 to i8
  %480 = add i64 %473, 6
  %481 = sub i64 %480, 406
  %482 = or i8 %479, %477
  %483 = icmp ne i8 %482, 0
  %484 = select i1 %483, i64 %481, i64 %480
  br i1 %483, label %inst_15ae, label %inst_1744

inst_1b3d:                                        ; preds = %inst_1744, %inst_171d, %inst_16d9
  %485 = phi i64 [ %397, %inst_16d9 ], [ %1521, %inst_1744 ], [ undef, %inst_171d ]
  %486 = add i64 %485, 3
  %487 = load i64, i64* @R14_2440_31c7d5b8, align 8
  %488 = load i64, i64* @RDX_2264_31c7d5b8, align 8
  %489 = sub i64 %487, %488
  %490 = icmp ult i64 %487, %488
  %491 = zext i1 %490 to i8
  %492 = icmp eq i64 %489, 0
  %493 = zext i1 %492 to i8
  %494 = add i64 %486, 6
  %495 = sub i64 %494, 1432
  %496 = or i8 %493, %491
  %497 = icmp ne i8 %496, 0
  %498 = select i1 %497, i64 %495, i64 %494
  br i1 %497, label %inst_15ae, label %inst_1b46

inst_1348:                                        ; preds = %inst_14b1, %inst_133a
  %499 = phi %struct.Memory* [ %29, %inst_133a ], [ %341, %inst_14b1 ]
  %500 = add i64 %1033, 4
  %501 = load i64, i64* @R8_2344_31c7d5b8, align 8
  %502 = add i64 %501, 1
  store i64 %502, i64* @RBP_2328_31c7d5b8, align 8, !tbaa !1290
  %503 = add i64 %500, 6
  store i64 15, i64* @R12_2408_31c7d5b8, align 8, !tbaa !1290
  %504 = add i64 %503, 4
  %505 = sub i64 %501, 14
  %506 = icmp eq i64 %505, 0
  %507 = zext i1 %506 to i8
  %508 = add i64 %504, 6
  %509 = add i64 %508, 244
  %510 = icmp eq i8 %507, 0
  %511 = select i1 %510, i64 %508, i64 %509
  br i1 %506, label %inst_1450, label %inst_135c

inst_174f:                                        ; preds = %inst_1744, %inst_171d
  %512 = phi i64 [ %1508, %inst_171d ], [ %1521, %inst_1744 ]
  %513 = load i64, i64* @R13_2424_31c7d5b8, align 8
  %514 = load i64, i64* @RDX_2264_31c7d5b8, align 8
  %515 = mul i64 %514, 4
  %516 = add i64 %515, %513
  %517 = inttoptr i64 %516 to i32*
  %518 = load i32, i32* %517, align 4
  %519 = zext i32 %518 to i64
  store i64 %519, i64* @RCX_2248_31c7d5b8, align 8, !tbaa !1290
  %520 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %521 = load i64, i64* @R9_2360_31c7d5b8, align 8
  %522 = mul i64 %521, 4
  %523 = add i64 %522, %520
  %524 = inttoptr i64 %523 to i32*
  %525 = load i32, i32* %524, align 4
  %526 = zext i32 %525 to i64
  store i64 %526, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %527 = load i64, i64* @R8_2344_31c7d5b8, align 8
  %528 = add i64 1, %527
  store i64 %528, i64* @R8_2344_31c7d5b8, align 8, !tbaa !1290
  %529 = sub i32 %518, %525
  %530 = icmp eq i32 %529, 0
  %531 = lshr i32 %529, 31
  %532 = trunc i32 %531 to i8
  %533 = lshr i32 %518, 31
  %534 = lshr i32 %525, 31
  %535 = xor i32 %534, %533
  %536 = xor i32 %531, %533
  %537 = add nuw nsw i32 %536, %535
  %538 = icmp eq i32 %537, 2
  %539 = icmp ne i8 %532, 0
  %540 = xor i1 %539, %538
  %541 = or i1 %530, %540
  br i1 %541, label %inst_1730, label %inst_1760

inst_1561:                                        ; preds = %inst_1576, %inst_1550
  %542 = phi i64 [ %1306, %inst_1550 ], [ %1328, %inst_1576 ]
  %543 = add i64 %542, 3
  %544 = load i64, i64* @R12_2408_31c7d5b8, align 8
  %545 = icmp eq i64 %544, 0
  %546 = zext i1 %545 to i8
  %547 = add i64 %543, 2
  %548 = add i64 %547, 72
  %549 = icmp eq i8 %546, 0
  %550 = select i1 %549, i64 %547, i64 %548
  br i1 %545, label %inst_15ae, label %inst_1566

inst_1566:                                        ; preds = %inst_153f, %inst_1561
  %551 = phi i64 [ %1284, %inst_153f ], [ %550, %inst_1561 ]
  %552 = add i64 %551, 5
  %553 = load i64, i64* @R13_2424_31c7d5b8, align 8
  %554 = load i64, i64* @R12_2408_31c7d5b8, align 8
  %555 = mul i64 %554, 4
  %556 = add i64 %553, -4
  %557 = add i64 %556, %555
  %558 = inttoptr i64 %557 to i32*
  %559 = load i32, i32* %558, align 4
  %560 = add i64 %552, 4
  %561 = load i64, i64* @R10_2376_31c7d5b8, align 8
  %562 = sub i64 %561, 1
  store i64 %562, i64* @R10_2376_31c7d5b8, align 8, !tbaa !1290
  %563 = add i64 %560, 5
  %564 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %565 = load i64, i64* @R14_2440_31c7d5b8, align 8
  %566 = mul i64 %565, 4
  %567 = add i64 %564, -4
  %568 = add i64 %567, %566
  %569 = inttoptr i64 %568 to i32*
  %570 = load i32, i32* %569, align 4
  %571 = sub i32 %570, %559
  %572 = icmp eq i32 %571, 0
  %573 = zext i1 %572 to i8
  %574 = lshr i32 %571, 31
  %575 = trunc i32 %574 to i8
  %576 = lshr i32 %570, 31
  %577 = lshr i32 %559, 31
  %578 = xor i32 %576, %577
  %579 = xor i32 %574, %576
  %580 = add nuw nsw i32 %579, %578
  %581 = icmp eq i32 %580, 2
  %582 = add i64 %563, 2
  %583 = sub i64 %582, 38
  %584 = icmp eq i8 %573, 0
  %585 = icmp eq i8 %575, 0
  %586 = xor i1 %585, %581
  %587 = and i1 %584, %586
  %588 = select i1 %587, i64 %583, i64 %582
  %589 = add i64 %588, 4
  br i1 %587, label %inst_1550, label %inst_1576

inst_1766:                                        ; preds = %inst_146a, %inst_15bb
  %590 = phi i64 [ %1134, %inst_146a ], [ %774, %inst_15bb ]
  %591 = phi %struct.Memory* [ %81, %inst_146a ], [ %765, %inst_15bb ]
  %592 = add i64 %590, 8
  %593 = load i64*, i64** @RSP_2312_31c84bc0, align 8
  %594 = getelementptr i64, i64* %593, i32 134
  %595 = load i64, i64* %594, align 8
  store i64 %595, i64* @R15_2456_31c7d5b8, align 8, !tbaa !1290
  %596 = add i64 %592, 8
  %597 = getelementptr i64, i64* %593, i32 135
  %598 = load i64, i64* %597, align 8
  store i64 %598, i64* @R8_2344_31c7d5b8, align 8, !tbaa !1290
  %599 = add i64 %596, 6
  store i64 2, i64* @R9_2360_31c7d5b8, align 8, !tbaa !1290
  %600 = add i64 %599, 3
  %601 = sub i64 %595, %598
  %602 = icmp ult i64 %595, %598
  %603 = zext i1 %602 to i8
  store i8 %603, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  %604 = trunc i64 %601 to i32
  %605 = and i32 %604, 255
  %606 = call i32 @llvm.ctpop.i32(i32 %605) #13, !range !1308
  %607 = trunc i32 %606 to i8
  %608 = and i8 %607, 1
  %609 = xor i8 %608, 1
  store i8 %609, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  %610 = xor i64 %598, %595
  %611 = xor i64 %610, %601
  %612 = lshr i64 %611, 4
  %613 = trunc i64 %612 to i8
  %614 = and i8 %613, 1
  store i8 %614, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  %615 = icmp eq i64 %601, 0
  %616 = zext i1 %615 to i8
  store i8 %616, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  %617 = lshr i64 %601, 63
  %618 = trunc i64 %617 to i8
  store i8 %618, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  %619 = lshr i64 %595, 63
  %620 = lshr i64 %598, 63
  %621 = xor i64 %620, %619
  %622 = xor i64 %617, %619
  %623 = add nuw nsw i64 %622, %621
  %624 = icmp eq i64 %623, 2
  %625 = zext i1 %624 to i8
  store i8 %625, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  %626 = add i64 %600, 6
  %627 = sub i64 %626, 734
  %628 = or i8 %616, %603
  %629 = icmp eq i8 %628, 0
  %630 = select i1 %629, i64 %627, i64 %626
  br i1 %629, label %inst_14a7, label %inst_1785

inst_137d:                                        ; preds = %inst_1370, %inst_135c
  %631 = load i64, i64* @RBP_2328_31c7d5b8, align 8
  store i64 %631, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %632 = add i64 1, %631
  store i64 %632, i64* @RBP_2328_31c7d5b8, align 8, !tbaa !1290
  %633 = sub i64 %632, 15
  %634 = icmp eq i64 %633, 0
  %635 = zext i1 %634 to i8
  %636 = icmp eq i8 %635, 0
  br i1 %636, label %inst_1370, label %inst_138a

inst_1588:                                        ; preds = %inst_1576, %inst_1550, %inst_153f
  %637 = phi i64 [ %1306, %inst_1550 ], [ %1328, %inst_1576 ], [ undef, %inst_153f ]
  %638 = add i64 %637, 3
  %639 = load i64, i64* @R12_2408_31c7d5b8, align 8
  %640 = icmp eq i64 %639, 0
  %641 = zext i1 %640 to i8
  %642 = add i64 %638, 2
  %643 = add i64 %642, 33
  %644 = icmp eq i8 %641, 0
  %645 = select i1 %644, i64 %642, i64 %643
  br i1 %640, label %inst_15ae, label %inst_158d

inst_138f:                                        ; preds = %inst_138a, %inst_18db
  store i64 %501, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  br label %inst_1398

inst_198f:                                        ; preds = %inst_19a9, %inst_1980
  %646 = phi i64 [ %1809, %inst_1980 ], [ %1827, %inst_19a9 ]
  %647 = add i64 %646, 3
  %648 = load i64, i64* @R11_2392_31c7d5b8, align 8
  %649 = icmp ult i64 %648, %1776
  %650 = zext i1 %649 to i8
  %651 = add i64 %647, 6
  %652 = add i64 %651, 299
  %653 = icmp eq i8 %650, 0
  %654 = select i1 %653, i64 %652, i64 %651
  br i1 %653, label %inst_1ac3, label %inst_1998

inst_1b92:                                        ; preds = %inst_17c1, %inst_1785, %inst_17e0
  %655 = phi i64 [ %1564, %inst_1785 ], [ %941, %inst_17e0 ], [ undef, %inst_17c1 ]
  %656 = phi %struct.Memory* [ %1554, %inst_1785 ], [ %1554, %inst_17e0 ], [ %1554, %inst_17c1 ]
  %657 = load i64, i64* @R15_2456_31c7d5b8, align 8
  %658 = load i64, i64* @RAX_2216_31c7d5b8, align 8
  %659 = sub i64 %657, %658
  %660 = icmp ult i64 %657, %658
  %661 = zext i1 %660 to i8
  %662 = icmp eq i64 %659, 0
  %663 = zext i1 %662 to i8
  %664 = or i8 %663, %661
  %665 = icmp ne i8 %664, 0
  br i1 %665, label %inst_1808, label %inst_1b9b

inst_1398:                                        ; preds = %inst_1398, %inst_138f
  %666 = load i64, i64* @RDX_2264_31c7d5b8, align 8
  %667 = mul i64 %666, 4
  %668 = add i64 %667, %1035
  %669 = inttoptr i64 %668 to i32*
  %670 = load i32, i32* %669, align 4
  %671 = zext i32 %670 to i64
  store i64 %671, i64* @RCX_2248_31c7d5b8, align 8, !tbaa !1290
  %672 = load i64, i64* @RAX_2216_31c7d5b8, align 8
  %673 = mul i64 %672, 4
  %674 = add i64 %673, %1035
  %675 = inttoptr i64 %674 to i32*
  %676 = load i32, i32* %675, align 4
  %677 = zext i32 %676 to i64
  store i64 %677, i64* @RSI_2280_31c7d5b8, align 8, !tbaa !1290
  store i32 %676, i32* %669, align 4
  %678 = add i64 1, %666
  store i64 %678, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  store i32 %670, i32* %675, align 4
  %679 = sub i64 %672, 1
  store i64 %679, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %680 = icmp ult i64 %678, %679
  br i1 %680, label %inst_1398, label %inst_13b1

inst_1998:                                        ; preds = %inst_196f, %inst_198f
  %681 = phi i64 [ %1788, %inst_196f ], [ %654, %inst_198f ]
  %682 = add i64 %681, 5
  %683 = load i64, i64* @R13_2424_31c7d5b8, align 8
  %684 = load i64, i64* @RDX_2264_31c7d5b8, align 8
  %685 = mul i64 %684, 4
  %686 = add i64 %685, %683
  %687 = inttoptr i64 %686 to i32*
  %688 = load i32, i32* %687, align 4
  %689 = zext i32 %688 to i64
  store i64 %689, i64* @RCX_2248_31c7d5b8, align 8, !tbaa !1290
  %690 = add i64 %682, 4
  %691 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %692 = load i64, i64* @R11_2392_31c7d5b8, align 8
  %693 = mul i64 %692, 4
  %694 = add i64 %693, %691
  %695 = inttoptr i64 %694 to i32*
  %696 = load i32, i32* %695, align 4
  %697 = zext i32 %696 to i64
  store i64 %697, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %698 = add i64 %690, 4
  %699 = load i64, i64* @RBP_2328_31c7d5b8, align 8
  %700 = add i64 1, %699
  store i64 %700, i64* @RBP_2328_31c7d5b8, align 8, !tbaa !1290
  %701 = add i64 %698, 2
  %702 = sub i32 %688, %696
  %703 = icmp eq i32 %702, 0
  %704 = lshr i32 %702, 31
  %705 = trunc i32 %704 to i8
  %706 = lshr i32 %688, 31
  %707 = lshr i32 %696, 31
  %708 = xor i32 %707, %706
  %709 = xor i32 %704, %706
  %710 = add nuw nsw i32 %709, %708
  %711 = icmp eq i32 %710, 2
  %712 = add i64 %701, 2
  %713 = sub i64 %712, 41
  %714 = icmp ne i8 %705, 0
  %715 = xor i1 %714, %711
  %716 = or i1 %703, %715
  %717 = select i1 %716, i64 %713, i64 %712
  br i1 %716, label %inst_1980, label %inst_19a9

inst_15ae:                                        ; preds = %inst_1b46, %inst_158d, %inst_1505, %inst_1588, %inst_1561, %inst_1b3d, %inst_1736
  %718 = phi i64 [ %498, %inst_1b3d ], [ undef, %inst_1b46 ], [ %484, %inst_1736 ], [ %1271, %inst_1505 ], [ %645, %inst_1588 ], [ ptrtoint (i8* @data_15ae to i64), %inst_158d ], [ %550, %inst_1561 ]
  %719 = phi %struct.Memory* [ %379, %inst_1b3d ], [ %2069, %inst_1b46 ], [ %379, %inst_1736 ], [ %1258, %inst_1505 ], [ %1258, %inst_1588 ], [ %1368, %inst_158d ], [ %1258, %inst_1561 ]
  %720 = add i64 %718, 8
  %721 = load i64*, i64** @RSP_2312_31c84bc0, align 8
  %722 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %723 = load i64, i64* @R15_2456_31c7d5b8, align 8
  %724 = mul i64 %723, 8
  %725 = add i64 %722, 1072
  %726 = add i64 %725, %724
  %727 = load i64, i64* @R11_2392_31c7d5b8, align 8
  %728 = inttoptr i64 %726 to i64*
  store i64 %727, i64* %728, align 8
  %729 = add i64 %720, 5
  %730 = getelementptr i64, i64* %721, i32 1
  %731 = load i64, i64* %730, align 8
  store i64 %731, i64* @R15_2456_31c7d5b8, align 8, !tbaa !1290
  br label %inst_15bb

inst_13b1:                                        ; preds = %inst_1430, %inst_18db, %inst_1398
  %732 = phi i64 [ %1124, %inst_1430 ], [ undef, %inst_1398 ], [ undef, %inst_18db ]
  %733 = add i64 %732, 3
  %734 = load i64, i64* @RBP_2328_31c7d5b8, align 8
  %735 = add i64 %733, 5
  %736 = add i64 %735, 3
  %737 = sub i64 %734, %501
  %738 = add i64 %736, 3
  %739 = icmp ult i64 %737, 32
  %740 = zext i1 %739 to i8
  %741 = add i64 %738, 4
  %742 = icmp eq i8 %740, 0
  %743 = select i1 %742, i64 %737, i64 32
  %744 = add i64 %741, 5
  store i64 15, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %745 = add i64 %744, 3
  %746 = add i64 %501, %743
  %747 = add i64 %745, 3
  %748 = sub i64 %746, 15
  %749 = icmp ult i64 %746, 15
  %750 = zext i1 %749 to i8
  %751 = icmp eq i64 %748, 0
  %752 = zext i1 %751 to i8
  %753 = add i64 %747, 4
  %754 = or i8 %752, %750
  %755 = icmp eq i8 %754, 0
  %756 = select i1 %755, i64 15, i64 %746
  store i64 %756, i64* @R12_2408_31c7d5b8, align 8, !tbaa !1290
  %757 = add i64 %753, 3
  %758 = icmp ult i64 %734, %756
  %759 = zext i1 %758 to i8
  %760 = add i64 %757, 2
  %761 = add i64 %760, 121
  %762 = icmp eq i8 %759, 0
  %763 = select i1 %762, i64 %761, i64 %760
  br i1 %762, label %inst_1450, label %inst_13d7

inst_15bb:                                        ; preds = %inst_15ae, %inst_1698
  %764 = phi i64 [ %329, %inst_1698 ], [ %729, %inst_15ae ]
  %765 = phi %struct.Memory* [ %309, %inst_1698 ], [ %719, %inst_15ae ]
  %766 = add i64 %764, 4
  %767 = load i64, i64* @R15_2456_31c7d5b8, align 8
  %768 = sub i64 %767, 2
  %769 = icmp eq i64 %768, 0
  %770 = zext i1 %769 to i8
  %771 = add i64 %766, 6
  %772 = add i64 %771, 417
  %773 = icmp eq i8 %770, 0
  %774 = select i1 %773, i64 %771, i64 %772
  br i1 %769, label %inst_1766, label %inst_15c5

inst_19c0:                                        ; preds = %inst_1acc, %inst_1a93, %inst_19b6, %inst_1980, %inst_1ac3, %inst_1a8a, %inst_1a60
  %775 = phi i64 [ %307, %inst_1a8a ], [ undef, %inst_1a93 ], [ %116, %inst_1a60 ], [ %360, %inst_1ac3 ], [ undef, %inst_1acc ], [ %1809, %inst_1980 ], [ %1828, %inst_19b6 ]
  %776 = phi %struct.Memory* [ %299, %inst_1a8a ], [ %1957, %inst_1a93 ], [ %1734, %inst_1a60 ], [ %347, %inst_1ac3 ], [ %1995, %inst_1acc ], [ %1767, %inst_1980 ], [ %1767, %inst_19b6 ]
  %777 = add i64 %775, 3
  %778 = load i64, i64* @R8_2344_31c7d5b8, align 8
  %779 = load i64, i64* @R15_2456_31c7d5b8, align 8
  %780 = add i64 %779, %778
  store i64 %780, i64* @R8_2344_31c7d5b8, align 8, !tbaa !1290
  %781 = add i64 %777, 4
  %782 = load i64, i64* @R10_2376_31c7d5b8, align 8
  %783 = sub i64 %782, 8
  store i64 %783, i64* @R10_2376_31c7d5b8, align 8, !tbaa !1290
  %784 = add i64 %781, 4
  %785 = load i64, i64* @R14_2440_31c7d5b8, align 8
  %786 = sub i64 %785, 8
  store i64 %786, i64* @R14_2440_31c7d5b8, align 8, !tbaa !1290
  %787 = add i64 %784, 4
  %788 = sub i64 %786, 8
  %789 = inttoptr i64 %788 to i64*
  store i64 %780, i64* %789, align 8
  %790 = add i64 %787, 5
  %791 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %792 = add i64 %791, 8
  %793 = inttoptr i64 %792 to i64*
  %794 = load i64, i64* %793, align 8
  %795 = sub i64 %783, %794
  %796 = icmp eq i64 %795, 0
  %797 = zext i1 %796 to i8
  %798 = add i64 %790, 6
  %799 = sub i64 %798, 202
  %800 = icmp eq i8 %797, 0
  %801 = select i1 %800, i64 %799, i64 %798
  br i1 %800, label %inst_1910, label %inst_19da

inst_1bc2:                                        ; preds = %inst_1b6d, %inst_19da
  %802 = phi i64 [ %1029, %inst_1b6d ], [ %928, %inst_19da ]
  %803 = phi %struct.Memory* [ %29, %inst_1b6d ], [ %889, %inst_19da ]
  %804 = add i64 %802, 5
  %805 = load i64, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1314
  %806 = add i64 %805, -8
  %807 = inttoptr i64 %806 to i64*
  store i64 %804, i64* %807, align 8
  store i64 %806, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %808 = call %struct.Memory* @ext_10b0____stack_chk_fail(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %803)
  %809 = load i8, i8* @RBX_2232_31c7d570, align 1
  %810 = load i8, i8* @RDX_2265_31c7d570, align 1
  %811 = add i8 %810, %809
  store i8 %811, i8* @RBX_2232_31c7d570, align 1, !tbaa !1314
  %812 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %813 = sub i64 %812, 8
  %814 = icmp ult i64 %812, 8
  %815 = lshr i64 %813, 63
  %816 = lshr i64 %812, 63
  %817 = xor i64 %815, %816
  %818 = add nuw nsw i64 %817, %816
  %819 = icmp eq i64 %818, 2
  %820 = zext i1 %819 to i8
  %821 = icmp ult i64 %812, %813
  %822 = or i1 %821, %814
  %823 = zext i1 %822 to i8
  store i8 %823, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  %824 = trunc i64 %812 to i32
  %825 = and i32 %824, 255
  %826 = call i32 @llvm.ctpop.i32(i32 %825) #13, !range !1308
  %827 = trunc i32 %826 to i8
  %828 = and i8 %827, 1
  %829 = xor i8 %828, 1
  store i8 %829, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  %830 = xor i64 8, %813
  %831 = xor i64 %830, %812
  %832 = lshr i64 %831, 4
  %833 = trunc i64 %832 to i8
  %834 = and i8 %833, 1
  store i8 %834, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  %835 = icmp eq i64 %812, 0
  %836 = zext i1 %835 to i8
  store i8 %836, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  %837 = trunc i64 %816 to i8
  store i8 %837, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  store i8 %820, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  %838 = add i64 %812, 8
  store i64 %838, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  ret %struct.Memory* %808

inst_15d5:                                        ; preds = %inst_16b8, %inst_14db
  %839 = phi i64 [ %1140, %inst_14db ], [ %1180, %inst_16b8 ]
  %840 = add i64 %839, 8
  store i64 %192, i64* %186, align 8
  %841 = add i64 %840, 5
  %842 = add i64 %178, 48
  %843 = add i64 %842, %189
  %844 = inttoptr i64 %843 to i64*
  %845 = load i64, i64* %844, align 8
  %846 = add i64 %841, 5
  %847 = add i64 %842, %183
  %848 = inttoptr i64 %847 to i64*
  %849 = load i64, i64* %848, align 8
  store i64 %849, i64* @R10_2376_31c7d5b8, align 8, !tbaa !1290
  %850 = add i64 %846, 8
  store i64 %187, i64* %191, align 8
  %851 = add i64 %850, 8
  %852 = load i64, i64* %186, align 8
  store i64 %852, i64* @R9_2360_31c7d5b8, align 8, !tbaa !1290
  %853 = add i64 %851, 5
  store i64 %845, i64* %848, align 8
  %854 = add i64 %853, 5
  store i64 %849, i64* %844, align 8
  %855 = add i64 %854, 5
  %856 = load i64, i64* %848, align 8
  store i64 %856, i64* @R12_2408_31c7d5b8, align 8, !tbaa !1290
  %857 = add i64 %855, 3
  %858 = sub i64 %187, %852
  %859 = icmp ult i64 %187, %852
  %860 = zext i1 %859 to i8
  store i8 %860, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  %861 = trunc i64 %858 to i32
  %862 = and i32 %861, 255
  %863 = call i32 @llvm.ctpop.i32(i32 %862) #13, !range !1308
  %864 = trunc i32 %863 to i8
  %865 = and i8 %864, 1
  %866 = xor i8 %865, 1
  store i8 %866, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  %867 = xor i64 %852, %187
  %868 = xor i64 %867, %858
  %869 = lshr i64 %868, 4
  %870 = trunc i64 %869 to i8
  %871 = and i8 %870, 1
  store i8 %871, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  %872 = icmp eq i64 %858, 0
  %873 = zext i1 %872 to i8
  store i8 %873, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  %874 = lshr i64 %858, 63
  %875 = trunc i64 %874 to i8
  store i8 %875, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  %876 = lshr i64 %187, 63
  %877 = lshr i64 %852, 63
  %878 = xor i64 %877, %876
  %879 = xor i64 %874, %876
  %880 = add nuw nsw i64 %879, %878
  %881 = icmp eq i64 %880, 2
  %882 = zext i1 %881 to i8
  store i8 %882, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  %883 = add i64 %857, 6
  %884 = add i64 %883, 521
  %885 = or i8 %873, %860
  %886 = icmp eq i8 %885, 0
  %887 = select i1 %886, i64 %884, i64 %883
  br i1 %886, label %inst_1818, label %inst_160f

inst_19da:                                        ; preds = %inst_18e9, %inst_19c0
  %888 = phi i64 [ %1195, %inst_18e9 ], [ %801, %inst_19c0 ]
  %889 = phi %struct.Memory* [ %341, %inst_18e9 ], [ %776, %inst_19c0 ]
  %890 = add i64 %888, 8
  %891 = load i64*, i64** @RSP_2312_31c84bc0, align 8
  %892 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %893 = getelementptr i64, i64* %891, i32 263
  %894 = load i64, i64* %893, align 8
  %895 = add i64 %890, 9
  %896 = load i64, i64* @FSBASE_2168_31c7d5b8, align 8
  %897 = add i64 %896, 40
  %898 = inttoptr i64 %897 to i64*
  %899 = load i64, i64* %898, align 8
  %900 = sub i64 %894, %899
  store i64 %900, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %901 = icmp ugt i64 %899, %894
  %902 = zext i1 %901 to i8
  store i8 %902, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  %903 = trunc i64 %900 to i32
  %904 = and i32 %903, 255
  %905 = call i32 @llvm.ctpop.i32(i32 %904) #13, !range !1308
  %906 = trunc i32 %905 to i8
  %907 = and i8 %906, 1
  %908 = xor i8 %907, 1
  store i8 %908, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  %909 = xor i64 %899, %894
  %910 = xor i64 %909, %900
  %911 = lshr i64 %910, 4
  %912 = trunc i64 %911 to i8
  %913 = and i8 %912, 1
  store i8 %913, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  %914 = icmp eq i64 %900, 0
  %915 = zext i1 %914 to i8
  store i8 %915, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  %916 = lshr i64 %900, 63
  %917 = trunc i64 %916 to i8
  store i8 %917, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  %918 = lshr i64 %894, 63
  %919 = lshr i64 %899, 63
  %920 = xor i64 %919, %918
  %921 = xor i64 %916, %918
  %922 = add nuw nsw i64 %921, %920
  %923 = icmp eq i64 %922, 2
  %924 = zext i1 %923 to i8
  store i8 %924, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  %925 = add i64 %895, 6
  %926 = add i64 %925, 465
  %927 = icmp eq i8 %915, 0
  %928 = select i1 %927, i64 %926, i64 %925
  br i1 %927, label %inst_1bc2, label %inst_19f1

inst_17e0:                                        ; preds = %inst_17fa, %inst_17d0
  %929 = phi i64 [ %1593, %inst_17d0 ], [ %1611, %inst_17fa ]
  %930 = add i64 %929, 3
  %931 = load i64, i64* @R14_2440_31c7d5b8, align 8
  %932 = sub i64 %1560, %931
  %933 = icmp ult i64 %1560, %931
  %934 = zext i1 %933 to i8
  %935 = icmp eq i64 %932, 0
  %936 = zext i1 %935 to i8
  %937 = add i64 %930, 6
  %938 = add i64 %937, 937
  %939 = or i8 %936, %934
  %940 = icmp ne i8 %939, 0
  %941 = select i1 %940, i64 %938, i64 %937
  br i1 %940, label %inst_1b92, label %inst_17e9

inst_13e8:                                        ; preds = %inst_14c0, %inst_13d7, %inst_141d
  %942 = load i32*, i32** @R11_2392_31c8a140, align 8
  %943 = load i64, i64* @R11_2392_31c7d5b8, align 8
  %944 = load i32, i32* %942, align 4
  %945 = zext i32 %944 to i64
  store i64 %945, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  store i64 %943, i64* @RSI_2280_31c7d5b8, align 8, !tbaa !1290
  store i64 %943, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %946 = load i64, i64* @R10_2376_31c7d5b8, align 8
  store i64 %946, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %947 = sub i64 %946, %501
  %948 = icmp ult i64 %946, %501
  %949 = zext i1 %948 to i8
  %950 = icmp eq i64 %947, 0
  %951 = zext i1 %950 to i8
  %952 = or i8 %951, %949
  %953 = icmp eq i8 %952, 0
  br i1 %953, label %inst_1413, label %inst_141d

inst_17e9:                                        ; preds = %inst_17c1, %inst_17e0
  %954 = phi i64 [ %1572, %inst_17c1 ], [ %941, %inst_17e0 ]
  %955 = add i64 %954, 5
  %956 = load i64, i64* @R13_2424_31c7d5b8, align 8
  %957 = load i64, i64* @RAX_2216_31c7d5b8, align 8
  %958 = mul i64 %957, 4
  %959 = add i64 %958, %956
  %960 = inttoptr i64 %959 to i32*
  %961 = load i32, i32* %960, align 4
  %962 = zext i32 %961 to i64
  store i64 %962, i64* @RCX_2248_31c7d5b8, align 8, !tbaa !1290
  %963 = add i64 %955, 4
  %964 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %965 = load i64, i64* @R14_2440_31c7d5b8, align 8
  %966 = mul i64 %965, 4
  %967 = add i64 %966, %964
  %968 = inttoptr i64 %967 to i32*
  %969 = load i32, i32* %968, align 4
  %970 = zext i32 %969 to i64
  store i64 %970, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %971 = add i64 %963, 4
  %972 = load i64, i64* @R12_2408_31c7d5b8, align 8
  %973 = add i64 1, %972
  store i64 %973, i64* @R12_2408_31c7d5b8, align 8, !tbaa !1290
  %974 = add i64 %971, 2
  %975 = sub i32 %961, %969
  %976 = icmp eq i32 %975, 0
  %977 = lshr i32 %975, 31
  %978 = trunc i32 %977 to i8
  %979 = lshr i32 %961, 31
  %980 = lshr i32 %969, 31
  %981 = xor i32 %980, %979
  %982 = xor i32 %977, %979
  %983 = add nuw nsw i32 %982, %981
  %984 = icmp eq i32 %983, 2
  %985 = add i64 %974, 2
  %986 = sub i64 %985, 42
  %987 = icmp ne i8 %978, 0
  %988 = xor i1 %987, %984
  %989 = or i1 %976, %988
  %990 = select i1 %989, i64 %986, i64 %985
  br i1 %989, label %inst_17d0, label %inst_17fa

inst_1b6d:                                        ; preds = %inst_1300
  %991 = add i64 %34, 8
  %992 = load i64*, i64** @RSP_2312_31c84bc0, align 8
  %993 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %994 = getelementptr i64, i64* %992, i32 263
  %995 = load i64, i64* %994, align 8
  %996 = add i64 %991, 9
  %997 = load i64, i64* @FSBASE_2168_31c7d5b8, align 8
  %998 = add i64 %997, 40
  %999 = inttoptr i64 %998 to i64*
  %1000 = load i64, i64* %999, align 8
  %1001 = sub i64 %995, %1000
  store i64 %1001, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %1002 = icmp ugt i64 %1000, %995
  %1003 = zext i1 %1002 to i8
  store i8 %1003, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  %1004 = trunc i64 %1001 to i32
  %1005 = and i32 %1004, 255
  %1006 = call i32 @llvm.ctpop.i32(i32 %1005) #13, !range !1308
  %1007 = trunc i32 %1006 to i8
  %1008 = and i8 %1007, 1
  %1009 = xor i8 %1008, 1
  store i8 %1009, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  %1010 = xor i64 %1000, %995
  %1011 = xor i64 %1010, %1001
  %1012 = lshr i64 %1011, 4
  %1013 = trunc i64 %1012 to i8
  %1014 = and i8 %1013, 1
  store i8 %1014, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  %1015 = icmp eq i64 %1001, 0
  %1016 = zext i1 %1015 to i8
  store i8 %1016, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  %1017 = lshr i64 %1001, 63
  %1018 = trunc i64 %1017 to i8
  store i8 %1018, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  %1019 = lshr i64 %995, 63
  %1020 = lshr i64 %1000, 63
  %1021 = xor i64 %1020, %1019
  %1022 = xor i64 %1017, %1019
  %1023 = add nuw nsw i64 %1022, %1021
  %1024 = icmp eq i64 %1023, 2
  %1025 = zext i1 %1024 to i8
  store i8 %1025, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  %1026 = add i64 %996, 2
  %1027 = add i64 %1026, 66
  %1028 = icmp eq i8 %1016, 0
  %1029 = select i1 %1028, i64 %1027, i64 %1026
  br i1 %1028, label %inst_1bc2, label %inst_1b80

inst_133a:                                        ; preds = %inst_1300
  %1030 = add i64 %34, 3
  store i64 %30, i64* @R13_2424_31c7d5b8, align 8, !tbaa !1290
  %1031 = add i64 %1030, 3
  store i64 0, i64* @R9_2360_31c7d5b8, align 8, !tbaa !1290
  %1032 = add i64 %1031, 3
  store i64 0, i64* @R8_2344_31c7d5b8, align 8, !tbaa !1290
  %1033 = add i64 %1032, 5
  br label %inst_1348

inst_135c:                                        ; preds = %inst_1348
  %1034 = add i64 %511, 4
  %1035 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %1036 = mul i64 %502, 4
  %1037 = add i64 %1035, -4
  %1038 = add i64 %1037, %1036
  %1039 = inttoptr i64 %1038 to i32*
  %1040 = load i32, i32* %1039, align 4
  %1041 = zext i32 %1040 to i64
  store i64 %1041, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %1042 = add i64 %1034, 3
  %1043 = add i64 %1036, %1035
  %1044 = inttoptr i64 %1043 to i32*
  %1045 = load i32, i32* %1044, align 4
  %1046 = sub i32 %1045, %1040
  %1047 = lshr i32 %1046, 31
  %1048 = trunc i32 %1047 to i8
  %1049 = lshr i32 %1045, 31
  %1050 = lshr i32 %1040, 31
  %1051 = xor i32 %1049, %1050
  %1052 = xor i32 %1047, %1049
  %1053 = add nuw nsw i32 %1052, %1051
  %1054 = icmp eq i32 %1053, 2
  %1055 = add i64 %1042, 6
  %1056 = add i64 %1055, 212
  %1057 = icmp eq i8 %1048, 0
  %1058 = xor i1 %1057, %1054
  %1059 = select i1 %1058, i64 %1056, i64 %1055
  br i1 %1058, label %inst_143d, label %inst_137d

inst_18db:                                        ; preds = %inst_1370
  %1060 = sub i64 %631, %501
  %1061 = icmp ult i64 %631, %501
  %1062 = zext i1 %1061 to i8
  %1063 = icmp eq i64 %1060, 0
  %1064 = zext i1 %1063 to i8
  %1065 = or i8 %1064, %1062
  %1066 = icmp eq i8 %1065, 0
  br i1 %1066, label %inst_138f, label %inst_13b1

inst_1370:                                        ; preds = %inst_137d
  %1067 = mul i64 %632, 4
  %1068 = add i64 %1037, %1067
  %1069 = inttoptr i64 %1068 to i32*
  %1070 = load i32, i32* %1069, align 4
  %1071 = zext i32 %1070 to i64
  store i64 %1071, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  %1072 = add i64 %1067, %1035
  %1073 = inttoptr i64 %1072 to i32*
  %1074 = load i32, i32* %1073, align 4
  %1075 = sub i32 %1074, %1070
  %1076 = lshr i32 %1075, 31
  %1077 = trunc i32 %1076 to i8
  %1078 = lshr i32 %1074, 31
  %1079 = lshr i32 %1070, 31
  %1080 = xor i32 %1078, %1079
  %1081 = xor i32 %1076, %1078
  %1082 = add nuw nsw i32 %1081, %1080
  %1083 = icmp eq i32 %1082, 2
  %1084 = icmp eq i8 %1077, 0
  %1085 = xor i1 %1084, %1083
  br i1 %1085, label %inst_18db, label %inst_137d

inst_138a:                                        ; preds = %inst_137d
  store i64 14, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  br label %inst_138f

inst_13d7:                                        ; preds = %inst_13b1
  %1086 = mul i64 %734, 4
  %1087 = add i64 %1086, %1035
  store i64 %1087, i64* @R11_2392_31c7d5b8, align 8, !tbaa !1290
  store i64 %734, i64* @R10_2376_31c7d5b8, align 8, !tbaa !1290
  %1088 = mul i64 %501, 4
  %1089 = add i64 %1088, %1035
  store i64 %1089, i64* @R14_2440_31c7d5b8, align 8, !tbaa !1290
  br label %inst_13e8

inst_14c0:                                        ; preds = %inst_1400
  store i64 %1089, i64* @RSI_2280_31c7d5b8, align 8, !tbaa !1290
  %1090 = add i64 1, %946
  store i64 %1090, i64* @R10_2376_31c7d5b8, align 8, !tbaa !1290
  %1091 = add i64 4, %943
  store i64 %1091, i64* @R11_2392_31c7d5b8, align 8, !tbaa !1290
  %1092 = inttoptr i64 %1089 to i32*
  store i32 %48, i32* %1092, align 4
  %1093 = sub i64 %756, %1090
  %1094 = icmp eq i64 %1093, 0
  %1095 = zext i1 %1094 to i8
  %1096 = icmp eq i8 %1095, 0
  br i1 %1096, label %inst_13e8, label %inst_1450

inst_1400:                                        ; preds = %inst_1413
  %1097 = load i64, i64* @RDX_2264_31c7d5b8, align 8
  %1098 = sub i64 %1097, 1
  store i64 %1098, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  store i32 %46, i32* %42, align 4
  store i64 %44, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %1099 = sub i64 %1098, %501
  %1100 = icmp eq i64 %1099, 0
  br i1 %1100, label %inst_14c0, label %inst_1413

inst_1430:                                        ; preds = %inst_143d
  %1101 = add i64 %79, 4
  %1102 = mul i64 %71, 4
  %1103 = add i64 %1037, %1102
  %1104 = inttoptr i64 %1103 to i32*
  %1105 = load i32, i32* %1104, align 4
  %1106 = zext i32 %1105 to i64
  store i64 %1106, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %1107 = add i64 %1101, 3
  %1108 = add i64 %1102, %1035
  %1109 = inttoptr i64 %1108 to i32*
  %1110 = load i32, i32* %1109, align 4
  %1111 = sub i32 %1110, %1105
  %1112 = lshr i32 %1111, 31
  %1113 = trunc i32 %1112 to i8
  %1114 = lshr i32 %1110, 31
  %1115 = lshr i32 %1105, 31
  %1116 = xor i32 %1114, %1115
  %1117 = xor i32 %1112, %1114
  %1118 = add nuw nsw i32 %1117, %1116
  %1119 = icmp eq i32 %1118, 2
  %1120 = add i64 %1107, 6
  %1121 = sub i64 %1120, 140
  %1122 = icmp ne i8 %1113, 0
  %1123 = xor i1 %1122, %1119
  %1124 = select i1 %1123, i64 %1121, i64 %1120
  br i1 %1123, label %inst_13b1, label %inst_143d

inst_1447:                                        ; preds = %inst_143d
  %1125 = add i64 %79, 6
  store i64 15, i64* @R12_2408_31c7d5b8, align 8, !tbaa !1290
  %1126 = add i64 %1125, 3
  br label %inst_1450

inst_146a:                                        ; preds = %inst_1450
  %1127 = add i64 %107, 4
  %1128 = sub i64 %97, 2
  %1129 = icmp eq i64 %1128, 0
  %1130 = zext i1 %1129 to i8
  %1131 = add i64 %1127, 6
  %1132 = add i64 %1131, 754
  %1133 = icmp eq i8 %1130, 0
  %1134 = select i1 %1133, i64 %1131, i64 %1132
  br i1 %1129, label %inst_1766, label %inst_1474

inst_14db:                                        ; preds = %inst_1474
  %1135 = icmp ult i64 %192, %198
  %1136 = zext i1 %1135 to i8
  %1137 = add i64 %211, 6
  %1138 = add i64 %1137, 241
  %1139 = icmp eq i8 %1136, 0
  %1140 = select i1 %1139, i64 %1137, i64 %1138
  br i1 %1135, label %inst_15d5, label %inst_14e4

inst_149e:                                        ; preds = %inst_1474
  %1141 = sub i64 %187, %198
  %1142 = icmp ult i64 %187, %198
  %1143 = zext i1 %1142 to i8
  %1144 = icmp eq i64 %1141, 0
  %1145 = zext i1 %1144 to i8
  %1146 = add i64 %211, 6
  %1147 = add i64 %1146, 529
  %1148 = or i8 %1145, %1143
  %1149 = icmp ne i8 %1148, 0
  %1150 = select i1 %1149, i64 %1147, i64 %1146
  br i1 %1149, label %inst_16b8, label %inst_14a7

inst_16b8:                                        ; preds = %inst_149e
  %1151 = lshr i64 %192, 63
  %1152 = lshr i64 %198, 63
  %1153 = add i64 %1150, 3
  %1154 = sub i64 %192, %198
  %1155 = icmp ult i64 %192, %198
  %1156 = zext i1 %1155 to i8
  store i8 %1156, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  %1157 = trunc i64 %1154 to i32
  %1158 = and i32 %1157, 255
  %1159 = call i32 @llvm.ctpop.i32(i32 %1158) #13, !range !1308
  %1160 = trunc i32 %1159 to i8
  %1161 = and i8 %1160, 1
  %1162 = xor i8 %1161, 1
  store i8 %1162, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  %1163 = xor i64 %198, %192
  %1164 = xor i64 %1163, %1154
  %1165 = lshr i64 %1164, 4
  %1166 = trunc i64 %1165 to i8
  %1167 = and i8 %1166, 1
  store i8 %1167, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  %1168 = icmp eq i64 %1154, 0
  %1169 = zext i1 %1168 to i8
  store i8 %1169, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  %1170 = lshr i64 %1154, 63
  %1171 = trunc i64 %1170 to i8
  store i8 %1171, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  %1172 = xor i64 %1152, %1151
  %1173 = xor i64 %1170, %1151
  %1174 = add nuw nsw i64 %1173, %1172
  %1175 = icmp eq i64 %1174, 2
  %1176 = zext i1 %1175 to i8
  store i8 %1176, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  %1177 = add i64 %1153, 6
  %1178 = sub i64 %1177, 236
  %1179 = icmp eq i8 %1156, 0
  %1180 = select i1 %1179, i64 %1177, i64 %1178
  br i1 %1155, label %inst_15d5, label %inst_16c1

inst_18e9:                                        ; preds = %inst_14a7
  %1181 = add i64 %340, 4
  %1182 = add i64 %1181, 6
  %1183 = add i64 %1182, 1080
  %1184 = add i64 %1183, 4
  %1185 = load i64, i64* @R9_2360_31c7d5b8, align 8
  %1186 = sub i64 %1185, 1
  %1187 = icmp ult i64 %1185, 1
  %1188 = zext i1 %1187 to i8
  %1189 = icmp eq i64 %1186, 0
  %1190 = zext i1 %1189 to i8
  %1191 = add i64 %1184, 6
  %1192 = add i64 %1191, 231
  %1193 = or i8 %1190, %1188
  %1194 = icmp ne i8 %1193, 0
  %1195 = select i1 %1194, i64 %1192, i64 %1191
  br i1 %1194, label %inst_19da, label %inst_18f3

inst_14b1:                                        ; preds = %inst_14a7
  store i64 %342, i64* @R8_2344_31c7d5b8, align 8, !tbaa !1290
  br label %inst_1348

inst_14e4:                                        ; preds = %inst_14db
  %1196 = lshr i64 %198, 63
  %1197 = add i64 %1140, 5
  %1198 = load i64, i64* %196, align 8
  %1199 = add i64 %1197, 5
  %1200 = add i64 %178, 48
  %1201 = add i64 %1200, %183
  %1202 = inttoptr i64 %1201 to i64*
  %1203 = load i64, i64* %1202, align 8
  store i64 %1203, i64* @R8_2344_31c7d5b8, align 8, !tbaa !1290
  %1204 = add i64 %1199, 5
  %1205 = mul i64 %1198, 8
  %1206 = add i64 %1200, %1205
  %1207 = inttoptr i64 %1206 to i64*
  %1208 = load i64, i64* %1207, align 8
  store i64 %1208, i64* @R9_2360_31c7d5b8, align 8, !tbaa !1290
  %1209 = add i64 %1204, 4
  %1210 = add i64 %198, %1208
  store i64 %1210, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %1211 = add i64 %1209, 5
  store i64 %1210, i64* %181, align 8
  %1212 = add i64 %1211, 3
  %1213 = sub i64 %187, %198
  %1214 = icmp ult i64 %187, %198
  %1215 = zext i1 %1214 to i8
  store i8 %1215, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  %1216 = trunc i64 %1213 to i32
  %1217 = and i32 %1216, 255
  %1218 = call i32 @llvm.ctpop.i32(i32 %1217) #13, !range !1308
  %1219 = trunc i32 %1218 to i8
  %1220 = and i8 %1219, 1
  %1221 = xor i8 %1220, 1
  store i8 %1221, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  %1222 = xor i64 %198, %187
  %1223 = xor i64 %1222, %1213
  %1224 = lshr i64 %1223, 4
  %1225 = trunc i64 %1224 to i8
  %1226 = and i8 %1225, 1
  store i8 %1226, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  %1227 = icmp eq i64 %1213, 0
  %1228 = zext i1 %1227 to i8
  store i8 %1228, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  %1229 = lshr i64 %1213, 63
  %1230 = trunc i64 %1229 to i8
  store i8 %1230, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  %1231 = lshr i64 %187, 63
  %1232 = xor i64 %1196, %1231
  %1233 = xor i64 %1229, %1231
  %1234 = add nuw nsw i64 %1233, %1232
  %1235 = icmp eq i64 %1234, 2
  %1236 = zext i1 %1235 to i8
  store i8 %1236, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  %1237 = add i64 %1212, 6
  %1238 = add i64 %1237, 468
  %1239 = or i8 %1228, %1215
  %1240 = icmp ne i8 %1239, 0
  %1241 = select i1 %1240, i64 %1238, i64 %1237
  br i1 %1240, label %inst_16d9, label %inst_1505

inst_1505:                                        ; preds = %inst_14e4
  %1242 = add i64 %1241, 8
  %1243 = mul i64 %198, 4
  store i64 %1243, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %1244 = add i64 %1242, 4
  %1245 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %1246 = mul i64 %1208, 4
  %1247 = add i64 %1246, %1245
  store i64 %1247, i64* @RSI_2280_31c7d5b8, align 8, !tbaa !1290
  %1248 = add i64 %1244, 5
  store i64 60, i64* @RCX_2248_31c7d5b8, align 8, !tbaa !1290
  %1249 = add i64 %1248, 3
  %1250 = load i64, i64* @R13_2424_31c7d5b8, align 8
  store i64 %1250, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  %1251 = add i64 %1249, 5
  store i64 %1203, i64* %182, align 8
  %1252 = add i64 %1251, 5
  store i64 %199, i64* %181, align 8
  %1253 = add i64 %1252, 5
  store i64 %1210, i64* %180, align 8
  %1254 = add i64 %1253, 5
  %1255 = load i64, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1314
  %1256 = add i64 %1255, -8
  %1257 = inttoptr i64 %1256 to i64*
  store i64 %1254, i64* %1257, align 8
  store i64 %1256, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %1258 = call %struct.Memory* @ext_10c0____memcpy_chk(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %170)
  %1259 = load i64*, i64** @RSP_2312_31c84bc0, align 8
  %1260 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %1261 = getelementptr i64, i64* %1259, i32 4
  %1262 = load i64, i64* %1261, align 8
  store i64 %1262, i64* @R8_2344_31c7d5b8, align 8, !tbaa !1290
  %1263 = getelementptr i64, i64* %1259, i32 2
  %1264 = load i64, i64* %1263, align 8
  store i64 %1264, i64* @R11_2392_31c7d5b8, align 8, !tbaa !1290
  %1265 = load i64, i64* @R14_2440_31c7d5b8, align 8
  %1266 = add i64 %1262, %1265
  store i64 %1266, i64* @R14_2440_31c7d5b8, align 8, !tbaa !1290
  %1267 = load i64, i64* @R12_2408_31c7d5b8, align 8
  %1268 = icmp eq i64 %1267, 0
  %1269 = zext i1 %1268 to i8
  %1270 = icmp eq i8 %1269, 0
  %1271 = select i1 %1270, i64 ptrtoint (i8* @data_153f to i64), i64 ptrtoint (i8* @data_15ae to i64)
  br i1 %1268, label %inst_15ae, label %inst_153f

inst_153f:                                        ; preds = %inst_1505
  %1272 = icmp ult i64 %1266, %1262
  %1273 = add i64 %1271, 3
  %1274 = zext i1 %1272 to i8
  %1275 = icmp eq i64 %1265, 0
  %1276 = zext i1 %1275 to i8
  %1277 = add i64 %1273, 5
  %1278 = getelementptr i64, i64* %1259, i32 3
  %1279 = load i64, i64* %1278, align 8
  store i64 %1279, i64* @R10_2376_31c7d5b8, align 8, !tbaa !1290
  %1280 = add i64 %1277, 2
  %1281 = add i64 %1280, 29
  %1282 = or i8 %1276, %1274
  %1283 = icmp eq i8 %1282, 0
  %1284 = select i1 %1283, i64 %1281, i64 %1280
  br i1 %1283, label %inst_1566, label %inst_1588

inst_1550:                                        ; preds = %inst_1566
  %1285 = sub i64 %565, 1
  store i64 %1285, i64* @R14_2440_31c7d5b8, align 8, !tbaa !1290
  %1286 = add i64 %589, 4
  %1287 = mul i64 %1285, 4
  %1288 = add i64 %1287, %564
  %1289 = inttoptr i64 %1288 to i32*
  %1290 = load i32, i32* %1289, align 4
  %1291 = zext i32 %1290 to i64
  store i64 %1291, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %1292 = add i64 %1286, 4
  %1293 = mul i64 %562, 4
  %1294 = add i64 %1293, %564
  %1295 = inttoptr i64 %1294 to i32*
  store i32 %1290, i32* %1295, align 4
  %1296 = add i64 %1292, 3
  %1297 = sub i64 %1285, %1262
  %1298 = icmp ult i64 %1285, %1262
  %1299 = zext i1 %1298 to i8
  %1300 = icmp eq i64 %1297, 0
  %1301 = zext i1 %1300 to i8
  %1302 = add i64 %1296, 2
  %1303 = add i64 %1302, 39
  %1304 = or i8 %1301, %1299
  %1305 = icmp ne i8 %1304, 0
  %1306 = select i1 %1305, i64 %1303, i64 %1302
  br i1 %1305, label %inst_1588, label %inst_1561

inst_1576:                                        ; preds = %inst_1566
  %1307 = sub i64 %554, 1
  store i64 %1307, i64* @R12_2408_31c7d5b8, align 8, !tbaa !1290
  %1308 = add i64 %589, 5
  %1309 = mul i64 %1307, 4
  %1310 = add i64 %1309, %553
  %1311 = inttoptr i64 %1310 to i32*
  %1312 = load i32, i32* %1311, align 4
  %1313 = zext i32 %1312 to i64
  store i64 %1313, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %1314 = add i64 %1308, 4
  %1315 = mul i64 %562, 4
  %1316 = add i64 %1315, %564
  %1317 = inttoptr i64 %1316 to i32*
  store i32 %1312, i32* %1317, align 4
  %1318 = add i64 %1314, 3
  %1319 = sub i64 %565, %1262
  %1320 = icmp ult i64 %565, %1262
  %1321 = zext i1 %1320 to i8
  %1322 = icmp eq i64 %1319, 0
  %1323 = zext i1 %1322 to i8
  %1324 = add i64 %1318, 2
  %1325 = sub i64 %1324, 39
  %1326 = or i8 %1323, %1321
  %1327 = icmp eq i8 %1326, 0
  %1328 = select i1 %1327, i64 %1325, i64 %1324
  br i1 %1327, label %inst_1561, label %inst_1588

inst_158d:                                        ; preds = %inst_1588
  %1329 = lshr i64 %639, 63
  %1330 = add i64 %645, 3
  %1331 = load i64, i64* @R10_2376_31c7d5b8, align 8
  %1332 = sub i64 %1331, %639
  store i64 %1332, i64* @R10_2376_31c7d5b8, align 8, !tbaa !1290
  %1333 = icmp ult i64 %1331, %639
  %1334 = zext i1 %1333 to i8
  store i8 %1334, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  %1335 = trunc i64 %1332 to i32
  %1336 = and i32 %1335, 255
  %1337 = call i32 @llvm.ctpop.i32(i32 %1336) #13, !range !1308
  %1338 = trunc i32 %1337 to i8
  %1339 = and i8 %1338, 1
  %1340 = xor i8 %1339, 1
  store i8 %1340, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  %1341 = xor i64 %639, %1331
  %1342 = xor i64 %1341, %1332
  %1343 = lshr i64 %1342, 4
  %1344 = trunc i64 %1343 to i8
  %1345 = and i8 %1344, 1
  store i8 %1345, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  %1346 = icmp eq i64 %1332, 0
  %1347 = zext i1 %1346 to i8
  store i8 %1347, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  %1348 = lshr i64 %1332, 63
  %1349 = trunc i64 %1348 to i8
  store i8 %1349, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  %1350 = lshr i64 %1331, 63
  %1351 = xor i64 %1329, %1350
  %1352 = xor i64 %1348, %1350
  %1353 = add nuw nsw i64 %1352, %1351
  %1354 = icmp eq i64 %1353, 2
  %1355 = zext i1 %1354 to i8
  store i8 %1355, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  %1356 = add i64 %1330, 8
  %1357 = mul i64 %639, 4
  store i64 %1357, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %1358 = add i64 %1356, 3
  %1359 = load i64, i64* @R13_2424_31c7d5b8, align 8
  store i64 %1359, i64* @RSI_2280_31c7d5b8, align 8, !tbaa !1290
  %1360 = add i64 %1358, 5
  store i64 %1264, i64* %1263, align 8
  %1361 = add i64 %1360, 4
  %1362 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %1363 = mul i64 %1332, 4
  %1364 = add i64 %1363, %1362
  store i64 %1364, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  %1365 = add i64 %1361, 5
  %1366 = add i64 %1260, -8
  %1367 = getelementptr i64, i64* %1259, i32 -1
  store i64 %1365, i64* %1367, align 8
  store i64 %1366, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %1368 = call %struct.Memory* @ext_10d0__memcpy(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %1258)
  %1369 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %1370 = add i64 %1369, 16
  %1371 = inttoptr i64 %1370 to i64*
  %1372 = load i64, i64* %1371, align 8
  store i64 %1372, i64* @R11_2392_31c7d5b8, align 8, !tbaa !1290
  br label %inst_15ae

inst_15c5:                                        ; preds = %inst_15bb
  %1373 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %1374 = mul i64 %767, 8
  %1375 = add i64 %1373, 1064
  %1376 = add i64 %1375, %1374
  %1377 = inttoptr i64 %1376 to i64*
  %1378 = load i64, i64* %1377, align 8
  store i64 %1378, i64* @R12_2408_31c7d5b8, align 8, !tbaa !1290
  store i64 %767, i64* @R9_2360_31c7d5b8, align 8, !tbaa !1290
  br label %inst_1474

inst_1818:                                        ; preds = %inst_15d5
  %1379 = add i64 %887, 8
  %1380 = mul i64 %852, 4
  store i64 %1380, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %1381 = add i64 %1379, 4
  %1382 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %1383 = mul i64 %856, 4
  %1384 = add i64 %1383, %1382
  store i64 %1384, i64* @RSI_2280_31c7d5b8, align 8, !tbaa !1290
  %1385 = add i64 %1381, 5
  store i64 60, i64* @RCX_2248_31c7d5b8, align 8, !tbaa !1290
  %1386 = add i64 %1385, 3
  %1387 = load i64, i64* @R13_2424_31c7d5b8, align 8
  store i64 %1387, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  %1388 = add i64 %1386, 5
  store i64 %849, i64* %180, align 8
  %1389 = add i64 %1388, 5
  store i64 %175, i64* %181, align 8
  %1390 = add i64 %1389, 5
  store i64 %852, i64* %196, align 8
  %1391 = add i64 %1390, 5
  %1392 = add i64 %178, -8
  store i64 %1391, i64* %179, align 8
  store i64 %1392, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %1393 = call %struct.Memory* @ext_10c0____memcpy_chk(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %170)
  %1394 = load i64*, i64** @RSP_2312_31c84bc0, align 8
  %1395 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %1396 = getelementptr i64, i64* %1394, i32 1
  %1397 = load i64, i64* %1396, align 8
  store i64 %1397, i64* @R9_2360_31c7d5b8, align 8, !tbaa !1290
  %1398 = getelementptr i64, i64* %1394, i32 3
  %1399 = load i64, i64* %1398, align 8
  store i64 %1399, i64* @R10_2376_31c7d5b8, align 8, !tbaa !1290
  %1400 = getelementptr i64, i64* %1394, i32 2
  %1401 = load i64, i64* %1400, align 8
  store i64 %1401, i64* @R8_2344_31c7d5b8, align 8, !tbaa !1290
  %1402 = load i64, i64* @R12_2408_31c7d5b8, align 8
  %1403 = add i64 %1397, %1402
  store i64 %1403, i64* @R12_2408_31c7d5b8, align 8, !tbaa !1290
  %1404 = icmp eq i64 %1397, 0
  %1405 = zext i1 %1404 to i8
  %1406 = load i64, i64* @R14_2440_31c7d5b8, align 8
  %1407 = add i64 %1399, %1406
  store i64 %1407, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  store i64 %1397, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %1408 = icmp eq i8 %1405, 0
  %1409 = select i1 %1408, i64 ptrtoint (i8* @data_185e to i64), i64 ptrtoint (i8* @data_18a2 to i64)
  br i1 %1404, label %inst_18a2, label %inst_185e

inst_160f:                                        ; preds = %inst_15d5
  %1410 = add i64 %887, 4
  %1411 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %1412 = mul i64 %849, 4
  %1413 = add i64 %1412, %1411
  store i64 %1413, i64* @RSI_2280_31c7d5b8, align 8, !tbaa !1290
  %1414 = add i64 %1410, 5
  store i64 60, i64* @RCX_2248_31c7d5b8, align 8, !tbaa !1290
  %1415 = add i64 %1414, 3
  %1416 = load i64, i64* @R13_2424_31c7d5b8, align 8
  store i64 %1416, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  %1417 = add i64 %1415, 5
  store i64 %852, i64* %180, align 8
  %1418 = add i64 %1417, 8
  %1419 = mul i64 %187, 4
  store i64 %1419, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %1420 = add i64 %1418, 5
  store i64 %175, i64* %181, align 8
  %1421 = add i64 %1420, 5
  store i64 %849, i64* %196, align 8
  %1422 = add i64 %1421, 5
  %1423 = add i64 %178, -8
  store i64 %1422, i64* %179, align 8
  store i64 %1423, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %1424 = call %struct.Memory* @ext_10c0____memcpy_chk(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %170)
  %1425 = load i64*, i64** @RSP_2312_31c84bc0, align 8
  %1426 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %1427 = getelementptr i64, i64* %1425, i32 3
  %1428 = load i64, i64* %1427, align 8
  store i64 %1428, i64* @R9_2360_31c7d5b8, align 8, !tbaa !1290
  store i64 0, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %1429 = getelementptr i64, i64* %1425, i32 1
  %1430 = load i64, i64* %1429, align 8
  store i64 %1430, i64* @R10_2376_31c7d5b8, align 8, !tbaa !1290
  %1431 = getelementptr i64, i64* %1425, i32 2
  %1432 = load i64, i64* %1431, align 8
  store i64 %1432, i64* @R8_2344_31c7d5b8, align 8, !tbaa !1290
  %1433 = load i64, i64* @R12_2408_31c7d5b8, align 8
  %1434 = add i64 %1428, %1433
  store i64 %1434, i64* @RSI_2280_31c7d5b8, align 8, !tbaa !1290
  %1435 = icmp ult i64 %1433, %1434
  %1436 = zext i1 %1435 to i8
  %1437 = icmp eq i8 %1436, 0
  %1438 = select i1 %1437, i64 ptrtoint (i8* @data_1b00 to i64), i64 ptrtoint (i8* @data_1655 to i64)
  br i1 %1437, label %inst_1b00, label %inst_1655

inst_1655:                                        ; preds = %inst_160f
  %1439 = add i64 %1438, 3
  %1440 = load i64, i64* @R14_2440_31c7d5b8, align 8
  %1441 = icmp eq i64 %1440, 0
  %1442 = zext i1 %1441 to i8
  %1443 = add i64 %1439, 2
  %1444 = add i64 %1443, 31
  %1445 = icmp eq i8 %1442, 0
  %1446 = select i1 %1445, i64 %1444, i64 %1443
  br i1 %1445, label %inst_1679, label %inst_1b00

inst_1660:                                        ; preds = %inst_1679
  %1447 = add i64 %257, 2
  %1448 = and i64 %229, 4294967295
  store i64 %1448, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %1449 = add i64 %1447, 4
  %1450 = add i64 1, %224
  store i64 %1450, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %1451 = add i64 %1449, 5
  %1452 = mul i64 %240, 4
  %1453 = add i64 %231, -4
  %1454 = add i64 %1453, %1452
  %1455 = trunc i64 %1448 to i32
  %1456 = inttoptr i64 %1454 to i32*
  store i32 %1455, i32* %1456, align 4
  %1457 = add i64 %1451, 3
  %1458 = sub i64 %1440, %1450
  %1459 = icmp ult i64 %1440, %1450
  %1460 = zext i1 %1459 to i8
  %1461 = icmp eq i64 %1458, 0
  %1462 = zext i1 %1461 to i8
  %1463 = add i64 %1457, 2
  %1464 = add i64 %1463, 40
  %1465 = or i8 %1462, %1460
  %1466 = icmp ne i8 %1465, 0
  %1467 = select i1 %1466, i64 %1464, i64 %1463
  br i1 %1466, label %inst_1698, label %inst_1670

inst_168a:                                        ; preds = %inst_1679
  %1468 = add i64 %257, 5
  %1469 = mul i64 %240, 4
  %1470 = add i64 %231, -4
  %1471 = add i64 %1470, %1469
  %1472 = inttoptr i64 %1471 to i32*
  store i32 %236, i32* %1472, align 4
  %1473 = add i64 %1468, 4
  %1474 = add i64 1, %232
  store i64 %1474, i64* @R12_2408_31c7d5b8, align 8, !tbaa !1290
  %1475 = add i64 %1473, 3
  %1476 = sub i64 %1440, %224
  %1477 = icmp ult i64 %1440, %224
  %1478 = zext i1 %1477 to i8
  %1479 = icmp eq i64 %1476, 0
  %1480 = zext i1 %1479 to i8
  %1481 = add i64 %1475, 2
  %1482 = sub i64 %1481, 40
  %1483 = or i8 %1480, %1478
  %1484 = icmp eq i8 %1483, 0
  %1485 = select i1 %1484, i64 %1482, i64 %1481
  br i1 %1484, label %inst_1670, label %inst_1698

inst_16c1:                                        ; preds = %inst_16b8
  %1486 = add i64 %1180, 5
  %1487 = load i64, i64* %196, align 8
  %1488 = add i64 %1486, 5
  %1489 = add i64 %178, 48
  %1490 = add i64 %1489, %183
  %1491 = inttoptr i64 %1490 to i64*
  %1492 = load i64, i64* %1491, align 8
  store i64 %1492, i64* @R8_2344_31c7d5b8, align 8, !tbaa !1290
  %1493 = add i64 %1488, 5
  %1494 = mul i64 %1487, 8
  %1495 = add i64 %1489, %1494
  %1496 = inttoptr i64 %1495 to i64*
  %1497 = load i64, i64* %1496, align 8
  store i64 %1497, i64* @R9_2360_31c7d5b8, align 8, !tbaa !1290
  %1498 = add i64 %1493, 4
  %1499 = add i64 %198, %1497
  store i64 %1499, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %1500 = add i64 %1498, 5
  store i64 %1499, i64* %181, align 8
  br label %inst_16d9

inst_171d:                                        ; preds = %inst_16d9
  %1501 = add i64 %397, 3
  %1502 = load i64, i64* @R14_2440_31c7d5b8, align 8
  %1503 = icmp eq i64 %1502, 0
  %1504 = zext i1 %1503 to i8
  %1505 = add i64 %1501, 2
  %1506 = add i64 %1505, 45
  %1507 = icmp eq i8 %1504, 0
  %1508 = select i1 %1507, i64 %1506, i64 %1505
  br i1 %1507, label %inst_174f, label %inst_1b3d

inst_1744:                                        ; preds = %inst_1736
  %1509 = add i64 %484, 5
  %1510 = load i64, i64* @R9_2360_31c7d5b8, align 8
  %1511 = load i64, i64* %384, align 8
  %1512 = sub i64 %1511, %1510
  %1513 = icmp ult i64 %1511, %1510
  %1514 = zext i1 %1513 to i8
  %1515 = icmp eq i64 %1512, 0
  %1516 = zext i1 %1515 to i8
  %1517 = add i64 %1509, 6
  %1518 = add i64 %1517, 1006
  %1519 = or i8 %1516, %1514
  %1520 = icmp ne i8 %1519, 0
  %1521 = select i1 %1520, i64 %1518, i64 %1517
  br i1 %1520, label %inst_1b3d, label %inst_174f

inst_1730:                                        ; preds = %inst_174f
  %1522 = add i64 %512, 5
  %1523 = add i64 %1522, 4
  %1524 = add i64 %1523, 4
  %1525 = add i64 %1524, 2
  %1526 = add i64 %1525, 2
  %1527 = sub i64 %1526, 48
  %1528 = add i64 %1527, 4
  %1529 = add i64 1, %514
  store i64 %1529, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %1530 = add i64 %1528, 2
  %1531 = and i64 %519, 4294967295
  store i64 %1531, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  br label %inst_1736

inst_1760:                                        ; preds = %inst_174f
  %1532 = add i64 1, %521
  store i64 %1532, i64* @R9_2360_31c7d5b8, align 8, !tbaa !1290
  br label %inst_1736

inst_1785:                                        ; preds = %inst_1766
  %1533 = add i64 %630, 5
  %1534 = getelementptr i64, i64* %593, i32 6
  %1535 = load i64, i64* %1534, align 8
  store i64 %1535, i64* @R12_2408_31c7d5b8, align 8, !tbaa !1290
  %1536 = add i64 %1533, 5
  store i64 60, i64* @RCX_2248_31c7d5b8, align 8, !tbaa !1290
  %1537 = add i64 %1536, 3
  %1538 = load i64, i64* @R13_2424_31c7d5b8, align 8
  store i64 %1538, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  %1539 = add i64 %1537, 5
  %1540 = getelementptr i64, i64* %593, i32 1
  store i64 %598, i64* %1540, align 8
  %1541 = add i64 %1539, 8
  %1542 = mul i64 %595, 4
  store i64 %1542, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %1543 = add i64 %1541, 5
  %1544 = getelementptr i64, i64* %593, i32 7
  %1545 = load i64, i64* %1544, align 8
  store i64 %1545, i64* @R14_2440_31c7d5b8, align 8, !tbaa !1290
  %1546 = add i64 %1543, 4
  %1547 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %1548 = mul i64 %1535, 4
  %1549 = add i64 %1548, %1547
  store i64 %1549, i64* @RSI_2280_31c7d5b8, align 8, !tbaa !1290
  %1550 = add i64 %1546, 5
  %1551 = load i64, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1314
  %1552 = add i64 %1551, -8
  %1553 = inttoptr i64 %1552 to i64*
  store i64 %1550, i64* %1553, align 8
  store i64 %1552, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %1554 = call %struct.Memory* @ext_10c0____memcpy_chk(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %591)
  %1555 = load i64*, i64** @RSP_2312_31c84bc0, align 8
  %1556 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %1557 = getelementptr i64, i64* %1555, i32 1
  %1558 = load i64, i64* %1557, align 8
  store i64 %1558, i64* @R8_2344_31c7d5b8, align 8, !tbaa !1290
  store i64 0, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %1559 = load i64, i64* @R14_2440_31c7d5b8, align 8
  %1560 = add i64 %1559, %1558
  store i64 %1560, i64* @RSI_2280_31c7d5b8, align 8, !tbaa !1290
  %1561 = icmp ult i64 %1559, %1560
  %1562 = zext i1 %1561 to i8
  %1563 = icmp eq i8 %1562, 0
  %1564 = select i1 %1563, i64 ptrtoint (i8* @data_1b92 to i64), i64 ptrtoint (i8* @data_17c1 to i64)
  br i1 %1563, label %inst_1b92, label %inst_17c1

inst_17c1:                                        ; preds = %inst_1785
  %1565 = add i64 %1564, 3
  %1566 = load i64, i64* @R15_2456_31c7d5b8, align 8
  %1567 = icmp eq i64 %1566, 0
  %1568 = zext i1 %1567 to i8
  %1569 = add i64 %1565, 2
  %1570 = add i64 %1569, 35
  %1571 = icmp eq i8 %1568, 0
  %1572 = select i1 %1571, i64 %1570, i64 %1569
  br i1 %1571, label %inst_17e9, label %inst_1b92

inst_17d0:                                        ; preds = %inst_17e9
  %1573 = add i64 %990, 2
  %1574 = and i64 %962, 4294967295
  store i64 %1574, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %1575 = add i64 %1573, 4
  %1576 = add i64 1, %957
  store i64 %1576, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %1577 = add i64 %1575, 5
  %1578 = mul i64 %973, 4
  %1579 = add i64 %964, -4
  %1580 = add i64 %1579, %1578
  %1581 = trunc i64 %1574 to i32
  %1582 = inttoptr i64 %1580 to i32*
  store i32 %1581, i32* %1582, align 4
  %1583 = add i64 %1577, 3
  %1584 = sub i64 %1566, %1576
  %1585 = icmp ult i64 %1566, %1576
  %1586 = zext i1 %1585 to i8
  %1587 = icmp eq i64 %1584, 0
  %1588 = zext i1 %1587 to i8
  %1589 = add i64 %1583, 2
  %1590 = add i64 %1589, 40
  %1591 = or i8 %1588, %1586
  %1592 = icmp ne i8 %1591, 0
  %1593 = select i1 %1592, i64 %1590, i64 %1589
  br i1 %1592, label %inst_1808, label %inst_17e0

inst_17fa:                                        ; preds = %inst_17e9
  %1594 = add i64 %990, 5
  %1595 = mul i64 %973, 4
  %1596 = add i64 %964, -4
  %1597 = add i64 %1596, %1595
  %1598 = inttoptr i64 %1597 to i32*
  store i32 %969, i32* %1598, align 4
  %1599 = add i64 %1594, 4
  %1600 = add i64 1, %965
  store i64 %1600, i64* @R14_2440_31c7d5b8, align 8, !tbaa !1290
  %1601 = add i64 %1599, 3
  %1602 = sub i64 %1566, %957
  %1603 = icmp ult i64 %1566, %957
  %1604 = zext i1 %1603 to i8
  %1605 = icmp eq i64 %1602, 0
  %1606 = zext i1 %1605 to i8
  %1607 = add i64 %1601, 2
  %1608 = sub i64 %1607, 40
  %1609 = or i8 %1606, %1604
  %1610 = icmp eq i8 %1609, 0
  %1611 = select i1 %1610, i64 %1608, i64 %1607
  br i1 %1610, label %inst_17e0, label %inst_1808

inst_185e:                                        ; preds = %inst_1818
  %1612 = add i64 %1409, 3
  %1613 = icmp ult i64 %1399, %1407
  %1614 = zext i1 %1613 to i8
  %1615 = add i64 %1612, 2
  %1616 = add i64 %1615, 30
  %1617 = icmp eq i8 %1614, 0
  %1618 = select i1 %1617, i64 %1615, i64 %1616
  br i1 %1613, label %inst_1881, label %inst_18a2

inst_1868:                                        ; preds = %inst_1881
  %1619 = sub i64 %273, 1
  store i64 %1619, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %1620 = add i64 %297, 3
  %1621 = mul i64 %1619, 4
  %1622 = add i64 %1621, %272
  %1623 = inttoptr i64 %1622 to i32*
  %1624 = load i32, i32* %1623, align 4
  %1625 = zext i32 %1624 to i64
  store i64 %1625, i64* @RCX_2248_31c7d5b8, align 8, !tbaa !1290
  %1626 = add i64 %1620, 4
  %1627 = mul i64 %270, 4
  %1628 = add i64 %1627, %272
  %1629 = inttoptr i64 %1628 to i32*
  store i32 %1624, i32* %1629, align 4
  %1630 = add i64 %1626, 3
  %1631 = icmp ult i64 %1399, %1619
  %1632 = zext i1 %1631 to i8
  %1633 = add i64 %1630, 2
  %1634 = add i64 %1633, 42
  %1635 = icmp eq i8 %1632, 0
  %1636 = select i1 %1635, i64 %1634, i64 %1633
  br i1 %1635, label %inst_18a2, label %inst_1878

inst_1890:                                        ; preds = %inst_1881
  %1637 = sub i64 %261, 1
  store i64 %1637, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %1638 = add i64 %297, 5
  %1639 = mul i64 %1637, 4
  %1640 = add i64 %1639, %260
  %1641 = inttoptr i64 %1640 to i32*
  %1642 = load i32, i32* %1641, align 4
  %1643 = zext i32 %1642 to i64
  store i64 %1643, i64* @RCX_2248_31c7d5b8, align 8, !tbaa !1290
  %1644 = add i64 %1638, 4
  %1645 = mul i64 %270, 4
  %1646 = add i64 %1645, %272
  %1647 = inttoptr i64 %1646 to i32*
  store i32 %1642, i32* %1647, align 4
  %1648 = add i64 %1644, 3
  %1649 = icmp ult i64 %1399, %273
  %1650 = zext i1 %1649 to i8
  %1651 = add i64 %1648, 2
  %1652 = sub i64 %1651, 42
  %1653 = icmp eq i8 %1650, 0
  %1654 = select i1 %1653, i64 %1651, i64 %1652
  br i1 %1649, label %inst_1878, label %inst_18a2

inst_18ab:                                        ; preds = %inst_18a2
  %1655 = lshr i64 %333, 63
  %1656 = add i64 %339, 3
  %1657 = load i64, i64* @R12_2408_31c7d5b8, align 8
  %1658 = sub i64 %1657, %333
  store i64 %1658, i64* @R12_2408_31c7d5b8, align 8, !tbaa !1290
  %1659 = icmp ult i64 %1657, %333
  %1660 = zext i1 %1659 to i8
  store i8 %1660, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  %1661 = trunc i64 %1658 to i32
  %1662 = and i32 %1661, 255
  %1663 = call i32 @llvm.ctpop.i32(i32 %1662) #13, !range !1308
  %1664 = trunc i32 %1663 to i8
  %1665 = and i8 %1664, 1
  %1666 = xor i8 %1665, 1
  store i8 %1666, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  %1667 = xor i64 %333, %1657
  %1668 = xor i64 %1667, %1658
  %1669 = lshr i64 %1668, 4
  %1670 = trunc i64 %1669 to i8
  %1671 = and i8 %1670, 1
  store i8 %1671, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  %1672 = icmp eq i64 %1658, 0
  %1673 = zext i1 %1672 to i8
  store i8 %1673, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  %1674 = lshr i64 %1658, 63
  %1675 = trunc i64 %1674 to i8
  store i8 %1675, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  %1676 = lshr i64 %1657, 63
  %1677 = xor i64 %1655, %1676
  %1678 = xor i64 %1674, %1676
  %1679 = add nuw nsw i64 %1678, %1677
  %1680 = icmp eq i64 %1679, 2
  %1681 = zext i1 %1680 to i8
  store i8 %1681, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  %1682 = add i64 %1656, 8
  %1683 = mul i64 %333, 4
  store i64 %1683, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %1684 = add i64 %1682, 3
  %1685 = load i64, i64* @R13_2424_31c7d5b8, align 8
  store i64 %1685, i64* @RSI_2280_31c7d5b8, align 8, !tbaa !1290
  %1686 = add i64 %1684, 5
  store i64 %1397, i64* %1400, align 8
  %1687 = add i64 %1686, 4
  %1688 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %1689 = mul i64 %1658, 4
  %1690 = add i64 %1689, %1688
  store i64 %1690, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  %1691 = add i64 %1687, 5
  store i64 %1401, i64* %1396, align 8
  %1692 = add i64 %1691, 5
  %1693 = add i64 %1395, -8
  %1694 = getelementptr i64, i64* %1394, i32 -1
  store i64 %1692, i64* %1694, align 8
  store i64 %1693, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %1695 = call %struct.Memory* @ext_10d0__memcpy(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %331)
  %1696 = load i64*, i64** @RSP_2312_31c84bc0, align 8
  %1697 = getelementptr i64, i64* %1696, i32 1
  %1698 = load i64, i64* %1697, align 8
  store i64 %1698, i64* @R8_2344_31c7d5b8, align 8, !tbaa !1290
  %1699 = getelementptr i64, i64* %1696, i32 2
  %1700 = load i64, i64* %1699, align 8
  store i64 %1700, i64* @R9_2360_31c7d5b8, align 8, !tbaa !1290
  br label %inst_1698

inst_18f3:                                        ; preds = %inst_18e9
  %1701 = add i64 %1195, 5
  %1702 = load i64*, i64** @RSP_2312_31c84bc0, align 8
  %1703 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %1704 = add i64 %1703, 56
  store i64 %1704, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %1705 = add i64 %1701, 4
  %1706 = shl i64 %1185, 2
  %1707 = shl i64 %1706, 1
  store i64 %1707, i64* @R9_2360_31c7d5b8, align 8, !tbaa !1290
  %1708 = add i64 %1705, 5
  %1709 = getelementptr i64, i64* %1702, i32 1
  store i64 %1704, i64* %1709, align 8
  %1710 = add i64 %1708, 5
  %1711 = add i64 %1703, 48
  %1712 = add i64 %1711, %1707
  store i64 %1712, i64* @R10_2376_31c7d5b8, align 8, !tbaa !1290
  %1713 = add i64 %1710, 8
  %1714 = add i64 %1703, 1072
  %1715 = add i64 %1714, %1707
  store i64 %1715, i64* @R14_2440_31c7d5b8, align 8, !tbaa !1290
  %1716 = add i64 %1713, 2
  br label %inst_1910

inst_1a0a:                                        ; preds = %inst_1910
  %1717 = mul i64 %424, 4
  store i64 %1717, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %1718 = add i64 %465, 4
  %1719 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %1720 = mul i64 %419, 4
  %1721 = add i64 %1720, %1719
  store i64 %1721, i64* @RSI_2280_31c7d5b8, align 8, !tbaa !1290
  %1722 = add i64 %1718, 5
  store i64 60, i64* @RCX_2248_31c7d5b8, align 8, !tbaa !1290
  %1723 = add i64 %1722, 3
  %1724 = load i64, i64* @R13_2424_31c7d5b8, align 8
  store i64 %1724, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  %1725 = add i64 %1723, 5
  %1726 = load i64*, i64** @RSP_2312_31c84bc0, align 8
  %1727 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %1728 = getelementptr i64, i64* %1726, i32 3
  store i64 %416, i64* %1728, align 8
  %1729 = add i64 %1725, 5
  %1730 = getelementptr i64, i64* %1726, i32 2
  store i64 %424, i64* %1730, align 8
  %1731 = add i64 %1729, 5
  %1732 = add i64 %1727, -8
  %1733 = getelementptr i64, i64* %1726, i32 -1
  store i64 %1731, i64* %1733, align 8
  store i64 %1732, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %1734 = call %struct.Memory* @ext_10c0____memcpy_chk(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %414)
  %1735 = load i64*, i64** @RSP_2312_31c84bc0, align 8
  %1736 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %1737 = getelementptr i64, i64* %1735, i32 2
  %1738 = load i64, i64* %1737, align 8
  store i64 %1738, i64* @R8_2344_31c7d5b8, align 8, !tbaa !1290
  %1739 = load i64, i64* @RBP_2328_31c7d5b8, align 8
  %1740 = load i64, i64* @R15_2456_31c7d5b8, align 8
  %1741 = add i64 %1740, %1739
  store i64 %1741, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %1742 = getelementptr i64, i64* %1735, i32 3
  %1743 = load i64, i64* %1742, align 8
  store i64 %1743, i64* @R10_2376_31c7d5b8, align 8, !tbaa !1290
  %1744 = icmp ult i64 %1739, %1741
  %1745 = zext i1 %1744 to i8
  store i64 %1738, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %1746 = icmp eq i8 %1745, 0
  %1747 = select i1 %1746, i64 ptrtoint (i8* @data_1a8a to i64), i64 ptrtoint (i8* @data_1a44 to i64)
  br i1 %1746, label %inst_1a8a, label %inst_1a44

inst_192d:                                        ; preds = %inst_1910
  %1748 = mul i64 %428, 4
  store i64 %1748, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %1749 = add i64 %465, 4
  %1750 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %1751 = mul i64 %432, 4
  %1752 = add i64 %1751, %1750
  store i64 %1752, i64* @RSI_2280_31c7d5b8, align 8, !tbaa !1290
  %1753 = add i64 %1749, 5
  store i64 60, i64* @RCX_2248_31c7d5b8, align 8, !tbaa !1290
  %1754 = add i64 %1753, 3
  %1755 = load i64, i64* @R13_2424_31c7d5b8, align 8
  store i64 %1755, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  %1756 = add i64 %1754, 5
  %1757 = load i64*, i64** @RSP_2312_31c84bc0, align 8
  %1758 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %1759 = getelementptr i64, i64* %1757, i32 4
  store i64 %416, i64* %1759, align 8
  %1760 = add i64 %1756, 5
  %1761 = getelementptr i64, i64* %1757, i32 3
  store i64 %419, i64* %1761, align 8
  %1762 = add i64 %1760, 5
  %1763 = getelementptr i64, i64* %1757, i32 2
  store i64 %424, i64* %1763, align 8
  %1764 = add i64 %1762, 5
  %1765 = add i64 %1758, -8
  %1766 = getelementptr i64, i64* %1757, i32 -1
  store i64 %1764, i64* %1766, align 8
  store i64 %1765, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %1767 = call %struct.Memory* @ext_10c0____memcpy_chk(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %414)
  %1768 = load i64*, i64** @RSP_2312_31c84bc0, align 8
  %1769 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %1770 = getelementptr i64, i64* %1768, i32 3
  %1771 = load i64, i64* %1770, align 8
  store i64 %1771, i64* @R11_2392_31c7d5b8, align 8, !tbaa !1290
  store i64 0, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %1772 = getelementptr i64, i64* %1768, i32 2
  %1773 = load i64, i64* %1772, align 8
  store i64 %1773, i64* @R8_2344_31c7d5b8, align 8, !tbaa !1290
  %1774 = getelementptr i64, i64* %1768, i32 4
  %1775 = load i64, i64* %1774, align 8
  store i64 %1775, i64* @R10_2376_31c7d5b8, align 8, !tbaa !1290
  %1776 = load i64, i64* @R12_2408_31c7d5b8, align 8
  %1777 = icmp ult i64 %1771, %1776
  %1778 = zext i1 %1777 to i8
  %1779 = icmp eq i8 %1778, 0
  %1780 = select i1 %1779, i64 ptrtoint (i8* @data_1ac3 to i64), i64 ptrtoint (i8* @data_196f to i64)
  br i1 %1779, label %inst_1ac3, label %inst_196f

inst_196f:                                        ; preds = %inst_192d
  %1781 = add i64 %1780, 3
  %1782 = load i64, i64* @R15_2456_31c7d5b8, align 8
  %1783 = icmp eq i64 %1782, 0
  %1784 = zext i1 %1783 to i8
  %1785 = add i64 %1781, 2
  %1786 = add i64 %1785, 36
  %1787 = icmp eq i8 %1784, 0
  %1788 = select i1 %1787, i64 %1786, i64 %1785
  br i1 %1787, label %inst_1998, label %inst_1ac3

inst_1980:                                        ; preds = %inst_1998
  %1789 = add i64 %717, 2
  %1790 = and i64 %689, 4294967295
  store i64 %1790, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %1791 = add i64 %1789, 4
  %1792 = add i64 1, %684
  store i64 %1792, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %1793 = add i64 %1791, 4
  %1794 = mul i64 %700, 4
  %1795 = add i64 %691, -4
  %1796 = add i64 %1795, %1794
  %1797 = trunc i64 %1790 to i32
  %1798 = inttoptr i64 %1796 to i32*
  store i32 %1797, i32* %1798, align 4
  %1799 = add i64 %1793, 3
  %1800 = sub i64 %1782, %1792
  %1801 = icmp ult i64 %1782, %1792
  %1802 = zext i1 %1801 to i8
  %1803 = icmp eq i64 %1800, 0
  %1804 = zext i1 %1803 to i8
  %1805 = add i64 %1799, 2
  %1806 = add i64 %1805, 49
  %1807 = or i8 %1804, %1802
  %1808 = icmp ne i8 %1807, 0
  %1809 = select i1 %1808, i64 %1806, i64 %1805
  br i1 %1808, label %inst_19c0, label %inst_198f

inst_19a9:                                        ; preds = %inst_1998
  %1810 = add i64 %717, 4
  %1811 = mul i64 %700, 4
  %1812 = add i64 %691, -4
  %1813 = add i64 %1812, %1811
  %1814 = inttoptr i64 %1813 to i32*
  store i32 %696, i32* %1814, align 4
  %1815 = add i64 %1810, 4
  %1816 = add i64 1, %692
  store i64 %1816, i64* @R11_2392_31c7d5b8, align 8, !tbaa !1290
  %1817 = add i64 %1815, 3
  %1818 = sub i64 %1782, %684
  %1819 = icmp ult i64 %1782, %684
  %1820 = zext i1 %1819 to i8
  %1821 = icmp eq i64 %1818, 0
  %1822 = zext i1 %1821 to i8
  %1823 = add i64 %1817, 2
  %1824 = sub i64 %1823, 39
  %1825 = or i8 %1822, %1820
  %1826 = icmp eq i8 %1825, 0
  %1827 = select i1 %1826, i64 %1824, i64 %1823
  br i1 %1826, label %inst_198f, label %inst_19b6

inst_19b6:                                        ; preds = %inst_19a9
  %1828 = add i64 %1827, 10
  br label %inst_19c0

inst_19f1:                                        ; preds = %inst_19da
  %1829 = add i64 2120, %892
  %1830 = getelementptr i64, i64* %891, i32 265
  %1831 = icmp ult i64 %1829, %892
  %1832 = icmp ult i64 %1829, 2120
  %1833 = or i1 %1831, %1832
  %1834 = zext i1 %1833 to i8
  store i8 %1834, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  %1835 = trunc i64 %1829 to i32
  %1836 = and i32 %1835, 255
  %1837 = call i32 @llvm.ctpop.i32(i32 %1836) #13, !range !1308
  %1838 = trunc i32 %1837 to i8
  %1839 = and i8 %1838, 1
  %1840 = xor i8 %1839, 1
  store i8 %1840, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  %1841 = xor i64 2120, %892
  %1842 = xor i64 %1841, %1829
  %1843 = lshr i64 %1842, 4
  %1844 = trunc i64 %1843 to i8
  %1845 = and i8 %1844, 1
  store i8 %1845, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  %1846 = icmp eq i64 %1829, 0
  %1847 = zext i1 %1846 to i8
  store i8 %1847, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  %1848 = lshr i64 %1829, 63
  %1849 = trunc i64 %1848 to i8
  store i8 %1849, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  %1850 = lshr i64 %892, 63
  %1851 = xor i64 %1848, %1850
  %1852 = add nuw nsw i64 %1851, %1848
  %1853 = icmp eq i64 %1852, 2
  %1854 = zext i1 %1853 to i8
  store i8 %1854, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  %1855 = load i64, i64* @R13_2424_31c7d5b8, align 8
  store i64 %1855, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  %1856 = add i64 %1829, 8
  %1857 = getelementptr i64, i64* %1830, i32 1
  %1858 = load i64, i64* %1830, align 8
  store i64 %1858, i64* @RBX_2232_31c7d5b8, align 8, !tbaa !1290
  %1859 = add i64 %1856, 8
  %1860 = getelementptr i64, i64* %1857, i32 1
  %1861 = load i64, i64* %1857, align 8
  store i64 %1861, i64* @RBP_2328_31c7d5b8, align 8, !tbaa !1290
  %1862 = add i64 %1859, 8
  %1863 = getelementptr i64, i64* %1860, i32 1
  %1864 = load i64, i64* %1860, align 8
  store i64 %1864, i64* @R12_2408_31c7d5b8, align 8, !tbaa !1290
  %1865 = add i64 %1862, 8
  %1866 = getelementptr i64, i64* %1863, i32 1
  %1867 = load i64, i64* %1863, align 8
  store i64 %1867, i64* @R13_2424_31c7d5b8, align 8, !tbaa !1290
  %1868 = add i64 %1865, 8
  %1869 = load i64, i64* %1866, align 8
  store i64 %1869, i64* @R14_2440_31c7d5b8, align 8, !tbaa !1290
  %1870 = add i64 %1868, 8
  store i64 %1870, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %1871 = getelementptr i64, i64* %1866, i32 1
  %1872 = load i64, i64* %1871, align 8
  store i64 %1872, i64* @R15_2456_31c7d5b8, align 8, !tbaa !1290
  %1873 = call %struct.Memory* @ext_10a0__free(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %889)
  ret %struct.Memory* %1873

inst_1a44:                                        ; preds = %inst_1a0a
  %1874 = add i64 %1747, 3
  %1875 = icmp eq i64 %1738, 0
  %1876 = zext i1 %1875 to i8
  %1877 = add i64 %1874, 2
  %1878 = add i64 %1877, 32
  %1879 = icmp eq i8 %1876, 0
  %1880 = select i1 %1879, i64 %1878, i64 %1877
  br i1 %1879, label %inst_1a69, label %inst_1a8a

inst_1a50:                                        ; preds = %inst_1a69
  %1881 = sub i64 %132, 1
  store i64 %1881, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %1882 = add i64 %156, 3
  %1883 = mul i64 %1881, 4
  %1884 = add i64 %1883, %131
  %1885 = inttoptr i64 %1884 to i32*
  %1886 = load i32, i32* %1885, align 4
  %1887 = zext i32 %1886 to i64
  store i64 %1887, i64* @RCX_2248_31c7d5b8, align 8, !tbaa !1290
  %1888 = add i64 %1882, 4
  %1889 = mul i64 %129, 4
  %1890 = add i64 %1889, %131
  %1891 = inttoptr i64 %1890 to i32*
  store i32 %1886, i32* %1891, align 4
  %1892 = add i64 %1888, 3
  %1893 = icmp ult i64 %1739, %1881
  %1894 = zext i1 %1893 to i8
  %1895 = add i64 %1892, 2
  %1896 = add i64 %1895, 42
  %1897 = icmp eq i8 %1894, 0
  %1898 = select i1 %1897, i64 %1896, i64 %1895
  br i1 %1897, label %inst_1a8a, label %inst_1a60

inst_1a78:                                        ; preds = %inst_1a69
  %1899 = sub i64 %120, 1
  store i64 %1899, i64* @RAX_2216_31c7d5b8, align 8, !tbaa !1290
  %1900 = add i64 %156, 5
  %1901 = mul i64 %1899, 4
  %1902 = add i64 %1901, %119
  %1903 = inttoptr i64 %1902 to i32*
  %1904 = load i32, i32* %1903, align 4
  %1905 = zext i32 %1904 to i64
  store i64 %1905, i64* @RCX_2248_31c7d5b8, align 8, !tbaa !1290
  %1906 = add i64 %1900, 4
  %1907 = mul i64 %129, 4
  %1908 = add i64 %1907, %131
  %1909 = inttoptr i64 %1908 to i32*
  store i32 %1904, i32* %1909, align 4
  %1910 = add i64 %1906, 3
  %1911 = icmp ult i64 %1739, %132
  %1912 = zext i1 %1911 to i8
  %1913 = add i64 %1910, 2
  %1914 = sub i64 %1913, 42
  %1915 = icmp eq i8 %1912, 0
  %1916 = select i1 %1915, i64 %1913, i64 %1914
  br i1 %1911, label %inst_1a60, label %inst_1a8a

inst_1a93:                                        ; preds = %inst_1a8a
  %1917 = lshr i64 %301, 63
  %1918 = add i64 %307, 3
  %1919 = load i64, i64* @R12_2408_31c7d5b8, align 8
  %1920 = sub i64 %1919, %301
  store i64 %1920, i64* @R12_2408_31c7d5b8, align 8, !tbaa !1290
  %1921 = icmp ult i64 %1919, %301
  %1922 = zext i1 %1921 to i8
  store i8 %1922, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  %1923 = trunc i64 %1920 to i32
  %1924 = and i32 %1923, 255
  %1925 = call i32 @llvm.ctpop.i32(i32 %1924) #13, !range !1308
  %1926 = trunc i32 %1925 to i8
  %1927 = and i8 %1926, 1
  %1928 = xor i8 %1927, 1
  store i8 %1928, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  %1929 = xor i64 %301, %1919
  %1930 = xor i64 %1929, %1920
  %1931 = lshr i64 %1930, 4
  %1932 = trunc i64 %1931 to i8
  %1933 = and i8 %1932, 1
  store i8 %1933, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  %1934 = icmp eq i64 %1920, 0
  %1935 = zext i1 %1934 to i8
  store i8 %1935, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  %1936 = lshr i64 %1920, 63
  %1937 = trunc i64 %1936 to i8
  store i8 %1937, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  %1938 = lshr i64 %1919, 63
  %1939 = xor i64 %1917, %1938
  %1940 = xor i64 %1936, %1938
  %1941 = add nuw nsw i64 %1940, %1939
  %1942 = icmp eq i64 %1941, 2
  %1943 = zext i1 %1942 to i8
  store i8 %1943, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  %1944 = add i64 %1918, 8
  %1945 = mul i64 %301, 4
  store i64 %1945, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %1946 = add i64 %1944, 3
  %1947 = load i64, i64* @R13_2424_31c7d5b8, align 8
  store i64 %1947, i64* @RSI_2280_31c7d5b8, align 8, !tbaa !1290
  %1948 = add i64 %1946, 5
  store i64 %1743, i64* %1742, align 8
  %1949 = add i64 %1948, 4
  %1950 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %1951 = mul i64 %1920, 4
  %1952 = add i64 %1951, %1950
  store i64 %1952, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  %1953 = add i64 %1949, 5
  store i64 %1738, i64* %1737, align 8
  %1954 = add i64 %1953, 5
  %1955 = add i64 %1736, -8
  %1956 = getelementptr i64, i64* %1735, i32 -1
  store i64 %1954, i64* %1956, align 8
  store i64 %1955, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %1957 = call %struct.Memory* @ext_10d0__memcpy(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %299)
  %1958 = load i64*, i64** @RSP_2312_31c84bc0, align 8
  %1959 = getelementptr i64, i64* %1958, i32 2
  %1960 = load i64, i64* %1959, align 8
  store i64 %1960, i64* @R8_2344_31c7d5b8, align 8, !tbaa !1290
  %1961 = getelementptr i64, i64* %1958, i32 3
  %1962 = load i64, i64* %1961, align 8
  store i64 %1962, i64* @R10_2376_31c7d5b8, align 8, !tbaa !1290
  br label %inst_19c0

inst_1acc:                                        ; preds = %inst_1ac3
  %1963 = add i64 %360, 3
  %1964 = add i64 %1963, 5
  %1965 = load i64, i64* @R13_2424_31c7d5b8, align 8
  %1966 = mul i64 %350, 4
  %1967 = add i64 %1966, %1965
  store i64 %1967, i64* @RSI_2280_31c7d5b8, align 8, !tbaa !1290
  %1968 = add i64 %1964, 4
  %1969 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %1970 = load i64, i64* @RBP_2328_31c7d5b8, align 8
  %1971 = mul i64 %1970, 4
  %1972 = add i64 %1971, %1969
  store i64 %1972, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  %1973 = add i64 %1968, 5
  store i64 %1775, i64* %1770, align 8
  %1974 = add i64 %1973, 3
  %1975 = add i64 %1974, 5
  store i64 %1773, i64* %1772, align 8
  %1976 = add i64 %1975, 4
  %1977 = shl i64 %351, 1
  %1978 = shl i64 %1977, 1
  store i64 %1978, i64* @R11_2392_31c7d5b8, align 8, !tbaa !1290
  %1979 = lshr i64 %1977, 63
  %1980 = trunc i64 %1979 to i8
  store i8 %1980, i8* @CF_2065_31c7d570, align 1, !tbaa !1314
  %1981 = trunc i64 %1978 to i32
  %1982 = and i32 %1981, 254
  %1983 = call i32 @llvm.ctpop.i32(i32 %1982) #13, !range !1308
  %1984 = trunc i32 %1983 to i8
  %1985 = and i8 %1984, 1
  %1986 = xor i8 %1985, 1
  store i8 %1986, i8* @PF_2067_31c7d570, align 1, !tbaa !1314
  store i8 0, i8* @AF_2069_31c7d570, align 1, !tbaa !1314
  %1987 = icmp eq i64 %1978, 0
  %1988 = zext i1 %1987 to i8
  store i8 %1988, i8* @ZF_2071_31c7d570, align 1, !tbaa !1314
  %1989 = lshr i64 %1978, 63
  %1990 = trunc i64 %1989 to i8
  store i8 %1990, i8* @SF_2073_31c7d570, align 1, !tbaa !1314
  store i8 0, i8* @OF_2077_31c7d570, align 1, !tbaa !1314
  %1991 = add i64 %1976, 3
  store i64 %1978, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %1992 = add i64 %1991, 5
  %1993 = add i64 %1769, -8
  %1994 = getelementptr i64, i64* %1768, i32 -1
  store i64 %1992, i64* %1994, align 8
  store i64 %1993, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %1995 = call %struct.Memory* @ext_10d0__memcpy(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %347)
  %1996 = load i64*, i64** @RSP_2312_31c84bc0, align 8
  %1997 = getelementptr i64, i64* %1996, i32 2
  %1998 = load i64, i64* %1997, align 8
  store i64 %1998, i64* @R8_2344_31c7d5b8, align 8, !tbaa !1290
  %1999 = getelementptr i64, i64* %1996, i32 3
  %2000 = load i64, i64* %1999, align 8
  store i64 %2000, i64* @R10_2376_31c7d5b8, align 8, !tbaa !1290
  br label %inst_19c0

inst_1b09:                                        ; preds = %inst_1b00
  %2001 = add i64 %412, 4
  %2002 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %2003 = load i64, i64* @R10_2376_31c7d5b8, align 8
  %2004 = mul i64 %2003, 4
  %2005 = add i64 %2004, %2002
  store i64 %2005, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  %2006 = add i64 %2001, 3
  %2007 = add i64 %2006, 5
  %2008 = load i64, i64* @R13_2424_31c7d5b8, align 8
  %2009 = mul i64 %402, 4
  %2010 = add i64 %2009, %2008
  store i64 %2010, i64* @RSI_2280_31c7d5b8, align 8, !tbaa !1290
  %2011 = add i64 %2007, 5
  store i64 %1428, i64* %1431, align 8
  %2012 = add i64 %2011, 3
  %2013 = add i64 %2012, 5
  store i64 %1432, i64* %1429, align 8
  %2014 = add i64 %2013, 4
  %2015 = shl i64 %403, 1
  %2016 = shl i64 %2015, 1
  store i64 %2016, i64* @R10_2376_31c7d5b8, align 8, !tbaa !1290
  %2017 = lshr i64 %2015, 63
  %2018 = trunc i64 %2017 to i8
  store i8 %2018, i8* @CF_2065_31c7d570, align 1, !tbaa !1314
  %2019 = trunc i64 %2016 to i32
  %2020 = and i32 %2019, 254
  %2021 = call i32 @llvm.ctpop.i32(i32 %2020) #13, !range !1308
  %2022 = trunc i32 %2021 to i8
  %2023 = and i8 %2022, 1
  %2024 = xor i8 %2023, 1
  store i8 %2024, i8* @PF_2067_31c7d570, align 1, !tbaa !1314
  store i8 0, i8* @AF_2069_31c7d570, align 1, !tbaa !1314
  %2025 = icmp eq i64 %2016, 0
  %2026 = zext i1 %2025 to i8
  store i8 %2026, i8* @ZF_2071_31c7d570, align 1, !tbaa !1314
  %2027 = lshr i64 %2016, 63
  %2028 = trunc i64 %2027 to i8
  store i8 %2028, i8* @SF_2073_31c7d570, align 1, !tbaa !1314
  store i8 0, i8* @OF_2077_31c7d570, align 1, !tbaa !1314
  %2029 = add i64 %2014, 3
  store i64 %2016, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %2030 = add i64 %2029, 5
  %2031 = add i64 %1426, -8
  %2032 = getelementptr i64, i64* %1425, i32 -1
  store i64 %2030, i64* %2032, align 8
  store i64 %2031, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %2033 = call %struct.Memory* @ext_10d0__memcpy(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %399)
  %2034 = load i64*, i64** @RSP_2312_31c84bc0, align 8
  %2035 = getelementptr i64, i64* %2034, i32 1
  %2036 = load i64, i64* %2035, align 8
  store i64 %2036, i64* @R8_2344_31c7d5b8, align 8, !tbaa !1290
  %2037 = getelementptr i64, i64* %2034, i32 2
  %2038 = load i64, i64* %2037, align 8
  store i64 %2038, i64* @R9_2360_31c7d5b8, align 8, !tbaa !1290
  br label %inst_1698

inst_1b46:                                        ; preds = %inst_1b3d
  %2039 = add i64 %498, 3
  %2040 = add i64 %2039, 5
  %2041 = load i64, i64* @R13_2424_31c7d5b8, align 8
  %2042 = mul i64 %488, 4
  %2043 = add i64 %2042, %2041
  store i64 %2043, i64* @RSI_2280_31c7d5b8, align 8, !tbaa !1290
  %2044 = add i64 %2040, 4
  %2045 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %2046 = load i64, i64* @R8_2344_31c7d5b8, align 8
  %2047 = mul i64 %2046, 4
  %2048 = add i64 %2047, %2045
  store i64 %2048, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  %2049 = add i64 %2044, 5
  store i64 %394, i64* %384, align 8
  %2050 = add i64 %2049, 4
  %2051 = shl i64 %489, 1
  %2052 = shl i64 %2051, 1
  store i64 %2052, i64* @R14_2440_31c7d5b8, align 8, !tbaa !1290
  %2053 = lshr i64 %2051, 63
  %2054 = trunc i64 %2053 to i8
  store i8 %2054, i8* @CF_2065_31c7d570, align 1, !tbaa !1314
  %2055 = trunc i64 %2052 to i32
  %2056 = and i32 %2055, 254
  %2057 = call i32 @llvm.ctpop.i32(i32 %2056) #13, !range !1308
  %2058 = trunc i32 %2057 to i8
  %2059 = and i8 %2058, 1
  %2060 = xor i8 %2059, 1
  store i8 %2060, i8* @PF_2067_31c7d570, align 1, !tbaa !1314
  store i8 0, i8* @AF_2069_31c7d570, align 1, !tbaa !1314
  %2061 = icmp eq i64 %2052, 0
  %2062 = zext i1 %2061 to i8
  store i8 %2062, i8* @ZF_2071_31c7d570, align 1, !tbaa !1314
  %2063 = lshr i64 %2052, 63
  %2064 = trunc i64 %2063 to i8
  store i8 %2064, i8* @SF_2073_31c7d570, align 1, !tbaa !1314
  store i8 0, i8* @OF_2077_31c7d570, align 1, !tbaa !1314
  %2065 = add i64 %2050, 3
  store i64 %2052, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %2066 = add i64 %2065, 5
  %2067 = add i64 %381, -8
  %2068 = getelementptr i64, i64* %380, i32 -1
  store i64 %2066, i64* %2068, align 8
  store i64 %2067, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %2069 = call %struct.Memory* @ext_10d0__memcpy(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %379)
  %2070 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %2071 = add i64 %2070, 16
  %2072 = inttoptr i64 %2071 to i64*
  %2073 = load i64, i64* %2072, align 8
  store i64 %2073, i64* @R11_2392_31c7d5b8, align 8, !tbaa !1290
  br label %inst_15ae

inst_1b80:                                        ; preds = %inst_1b6d
  %2074 = add i64 2120, %993
  %2075 = getelementptr i64, i64* %992, i32 265
  %2076 = icmp ult i64 %2074, %993
  %2077 = icmp ult i64 %2074, 2120
  %2078 = or i1 %2076, %2077
  %2079 = zext i1 %2078 to i8
  store i8 %2079, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  %2080 = trunc i64 %2074 to i32
  %2081 = and i32 %2080, 255
  %2082 = call i32 @llvm.ctpop.i32(i32 %2081) #13, !range !1308
  %2083 = trunc i32 %2082 to i8
  %2084 = and i8 %2083, 1
  %2085 = xor i8 %2084, 1
  store i8 %2085, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  %2086 = xor i64 2120, %993
  %2087 = xor i64 %2086, %2074
  %2088 = lshr i64 %2087, 4
  %2089 = trunc i64 %2088 to i8
  %2090 = and i8 %2089, 1
  store i8 %2090, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  %2091 = icmp eq i64 %2074, 0
  %2092 = zext i1 %2091 to i8
  store i8 %2092, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  %2093 = lshr i64 %2074, 63
  %2094 = trunc i64 %2093 to i8
  store i8 %2094, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  %2095 = lshr i64 %993, 63
  %2096 = xor i64 %2093, %2095
  %2097 = add nuw nsw i64 %2096, %2093
  %2098 = icmp eq i64 %2097, 2
  %2099 = zext i1 %2098 to i8
  store i8 %2099, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  %2100 = add i64 %2074, 8
  %2101 = getelementptr i64, i64* %2075, i32 1
  %2102 = load i64, i64* %2075, align 8
  store i64 %2102, i64* @RBX_2232_31c7d5b8, align 8, !tbaa !1290
  %2103 = add i64 %2100, 8
  %2104 = getelementptr i64, i64* %2101, i32 1
  %2105 = load i64, i64* %2101, align 8
  store i64 %2105, i64* @RBP_2328_31c7d5b8, align 8, !tbaa !1290
  %2106 = add i64 %2103, 8
  %2107 = getelementptr i64, i64* %2104, i32 1
  %2108 = load i64, i64* %2104, align 8
  store i64 %2108, i64* @R12_2408_31c7d5b8, align 8, !tbaa !1290
  %2109 = add i64 %2106, 8
  %2110 = getelementptr i64, i64* %2107, i32 1
  %2111 = load i64, i64* %2107, align 8
  store i64 %2111, i64* @R13_2424_31c7d5b8, align 8, !tbaa !1290
  %2112 = add i64 %2109, 8
  %2113 = load i64, i64* %2110, align 8
  store i64 %2113, i64* @R14_2440_31c7d5b8, align 8, !tbaa !1290
  %2114 = add i64 %2112, 8
  %2115 = getelementptr i64, i64* %2110, i32 1
  %2116 = load i64, i64* %2115, align 8
  store i64 %2116, i64* @R15_2456_31c7d5b8, align 8, !tbaa !1290
  %2117 = add i64 %2114, 8
  store i64 %2117, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  ret %struct.Memory* %29

inst_1b9b:                                        ; preds = %inst_1b92
  %2118 = add i64 %655, 3
  %2119 = add i64 %2118, 6
  %2120 = add i64 %2119, 3
  %2121 = add i64 %2120, 4
  %2122 = load i64, i64* @RBX_2232_31c7d5b8, align 8
  %2123 = load i64, i64* @R12_2408_31c7d5b8, align 8
  %2124 = mul i64 %2123, 4
  %2125 = add i64 %2124, %2122
  store i64 %2125, i64* @RDI_2296_31c7d5b8, align 8, !tbaa !1290
  %2126 = add i64 %2121, 5
  %2127 = load i64, i64* @R13_2424_31c7d5b8, align 8
  %2128 = mul i64 %658, 4
  %2129 = add i64 %2128, %2127
  store i64 %2129, i64* @RSI_2280_31c7d5b8, align 8, !tbaa !1290
  %2130 = add i64 %2126, 5
  store i64 %1558, i64* %1557, align 8
  %2131 = add i64 %2130, 3
  %2132 = add i64 %2131, 4
  %2133 = shl i64 %659, 1
  %2134 = shl i64 %2133, 1
  store i64 %2134, i64* @RDX_2264_31c7d5b8, align 8, !tbaa !1290
  %2135 = lshr i64 %2133, 63
  %2136 = trunc i64 %2135 to i8
  store i8 %2136, i8* @CF_2065_31c7d570, align 1, !tbaa !1314
  %2137 = trunc i64 %2134 to i32
  %2138 = and i32 %2137, 254
  %2139 = call i32 @llvm.ctpop.i32(i32 %2138) #13, !range !1308
  %2140 = trunc i32 %2139 to i8
  %2141 = and i8 %2140, 1
  %2142 = xor i8 %2141, 1
  store i8 %2142, i8* @PF_2067_31c7d570, align 1, !tbaa !1314
  store i8 0, i8* @AF_2069_31c7d570, align 1, !tbaa !1314
  %2143 = icmp eq i64 %2134, 0
  %2144 = zext i1 %2143 to i8
  store i8 %2144, i8* @ZF_2071_31c7d570, align 1, !tbaa !1314
  %2145 = lshr i64 %2134, 63
  %2146 = trunc i64 %2145 to i8
  store i8 %2146, i8* @SF_2073_31c7d570, align 1, !tbaa !1314
  store i8 0, i8* @OF_2077_31c7d570, align 1, !tbaa !1314
  %2147 = add i64 %2132, 5
  %2148 = add i64 %1556, -8
  %2149 = getelementptr i64, i64* %1555, i32 -1
  store i64 %2147, i64* %2149, align 8
  store i64 %2148, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  %2150 = call %struct.Memory* @ext_10d0__memcpy(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %656)
  %2151 = load i64, i64* @RSP_2312_31c7d5b8, align 8
  %2152 = add i64 %2151, 8
  %2153 = inttoptr i64 %2152 to i64*
  %2154 = load i64, i64* %2153, align 8
  store i64 %2154, i64* @R8_2344_31c7d5b8, align 8, !tbaa !1290
  br label %inst_1808
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1bc8__term_proc(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1bc8:
  %0 = load i64, i64* @RSP_2312_31c7d5b8, align 8
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
  store i8 %11, i8* @CF_2065_31c7d570, align 1, !tbaa !1294
  %12 = trunc i64 %0 to i32
  %13 = and i32 %12, 255
  %14 = call i32 @llvm.ctpop.i32(i32 %13) #13, !range !1308
  %15 = trunc i32 %14 to i8
  %16 = and i8 %15, 1
  %17 = xor i8 %16, 1
  store i8 %17, i8* @PF_2067_31c7d570, align 1, !tbaa !1309
  %18 = xor i64 8, %1
  %19 = xor i64 %18, %0
  %20 = lshr i64 %19, 4
  %21 = trunc i64 %20 to i8
  %22 = and i8 %21, 1
  store i8 %22, i8* @AF_2069_31c7d570, align 1, !tbaa !1313
  %23 = icmp eq i64 %0, 0
  %24 = zext i1 %23 to i8
  store i8 %24, i8* @ZF_2071_31c7d570, align 1, !tbaa !1310
  %25 = trunc i64 %4 to i8
  store i8 %25, i8* @SF_2073_31c7d570, align 1, !tbaa !1311
  store i8 %8, i8* @OF_2077_31c7d570, align 1, !tbaa !1312
  %26 = add i64 %0, 8
  store i64 %26, i64* @RSP_2312_31c7d5b8, align 8, !tbaa !1290
  ret %struct.Memory* %memory
}

; Function Attrs: nobuiltin noinline
declare !remill.function.type !1315 extern_weak x86_64_sysvcc i64 @_ITM_registerTMCloneTable(i64, i64) #11

; Function Attrs: nobuiltin noinline
declare !remill.function.type !1315 extern_weak x86_64_sysvcc i64 @_ITM_deregisterTMCloneTable(i64) #11

; Function Attrs: noinline
declare !remill.function.type !1315 extern_weak x86_64_sysvcc i8* @memcpy(i8*, i8*, i64) #12

; Function Attrs: nobuiltin noinline
declare !remill.function.type !1315 extern_weak x86_64_sysvcc i64 @__stack_chk_fail() #11

; Function Attrs: nobuiltin noinline
declare !remill.function.type !1315 extern_weak x86_64_sysvcc i64 @free(i64) #11

; Function Attrs: nobuiltin noinline
declare !remill.function.type !1316 extern_weak x86_64_sysvcc i64 @__cxa_finalize(i64) #11

; Function Attrs: noinline
define internal %struct.Memory* @ext_10f0____printf_chk(%struct.State* %0, i64 %1, %struct.Memory* %2) #12 {
  %4 = call %struct.Memory* @__remill_function_call(%struct.State* @__mcsema_reg_state, i64 ptrtoint (i64 (...)* @.__printf_chk to i64), %struct.Memory* %2)
  ret %struct.Memory* %4
}

; Function Attrs: noinline
declare !remill.function.type !1316 i64 @.__printf_chk(...) #12

; Function Attrs: nobuiltin noinline
declare !remill.function.type !1315 extern_weak x86_64_sysvcc i64 @malloc(i64) #11

; Function Attrs: noinline
define internal %struct.Memory* @ext_10e0__malloc(%struct.State* %0, i64 %1, %struct.Memory* %2) #12 {
  %4 = call %struct.Memory* @__remill_function_call(%struct.State* @__mcsema_reg_state, i64 ptrtoint (i64 (...)* @.malloc to i64), %struct.Memory* %2)
  ret %struct.Memory* %4
}

; Function Attrs: noinline
declare !remill.function.type !1316 i64 @.malloc(...) #12

; Function Attrs: nobuiltin noinline
declare !remill.function.type !1315 extern_weak x86_64_sysvcc i64 @__memcpy_chk(i64, i64, i64, i64) #11

; Function Attrs: noinline
define internal %struct.Memory* @ext_10d0__memcpy(%struct.State* %0, i64 %1, %struct.Memory* %2) #12 {
  %4 = call %struct.Memory* @__remill_function_call(%struct.State* @__mcsema_reg_state, i64 ptrtoint (i64 (...)* @.memcpy to i64), %struct.Memory* %2)
  ret %struct.Memory* %4
}

; Function Attrs: noinline
declare !remill.function.type !1316 i64 @.memcpy(...) #12

; Function Attrs: noinline
declare !remill.function.type !1315 extern_weak x86_64_sysvcc void @__libc_start_main(i32 (i32, i8**, i8**)*, i32, i8**, i8*, i32 (i32, i8**, i8**)*, void ()*, void ()*, i32*) #12

; Function Attrs: noinline
define internal %struct.Memory* @ext_10c0____memcpy_chk(%struct.State* %0, i64 %1, %struct.Memory* %2) #12 {
  %4 = call %struct.Memory* @__remill_function_call(%struct.State* @__mcsema_reg_state, i64 ptrtoint (i64 (...)* @.__memcpy_chk to i64), %struct.Memory* %2)
  ret %struct.Memory* %4
}

; Function Attrs: noinline
declare !remill.function.type !1316 i64 @.__memcpy_chk(...) #12

; Function Attrs: noinline
define internal %struct.Memory* @ext_1090___cxa_finalize(%struct.State* %0, i64 %1, %struct.Memory* %2) #12 {
  %4 = call %struct.Memory* @__remill_function_call(%struct.State* @__mcsema_reg_state, i64 ptrtoint (i64 (i64)* @__cxa_finalize to i64), %struct.Memory* %2)
  ret %struct.Memory* %4
}

; Function Attrs: noinline
define weak x86_64_sysvcc void @__gmon_start__() #12 !remill.function.type !1315 {
  ret void
}

; Function Attrs: noinline
declare !remill.function.type !1315 extern_weak i64 @__printf_chk(...) #12

; Function Attrs: noinline
define internal %struct.Memory* @ext_10a0__free(%struct.State* %0, i64 %1, %struct.Memory* %2) #12 {
  %4 = call %struct.Memory* @__remill_function_call(%struct.State* @__mcsema_reg_state, i64 ptrtoint (i64 (...)* @.free to i64), %struct.Memory* %2)
  ret %struct.Memory* %4
}

; Function Attrs: noinline
declare !remill.function.type !1316 i64 @.free(...) #12

; Function Attrs: noinline
define internal %struct.Memory* @ext_10b0____stack_chk_fail(%struct.State* %0, i64 %1, %struct.Memory* %2) #12 {
  %4 = call %struct.Memory* @__remill_function_call(%struct.State* @__mcsema_reg_state, i64 ptrtoint (i64 (...)* @.__stack_chk_fail to i64), %struct.Memory* %2)
  ret %struct.Memory* %4
}

; Function Attrs: noinline
declare !remill.function.type !1316 i64 @.__stack_chk_fail(...) #12

; Function Attrs: naked nobuiltin noinline
define dllexport x86_64_sysvcc i32 @main(i32 %param0, i8** %param1, i8** %param2) #8 !remill.function.type !1316 {
  call void asm sideeffect "pushq $0;pushq $$0x1100;jmpq *$1;", "*m,*m,~{dirflag},~{fpsr},~{flags}"(%struct.Memory* (%struct.State*, i64, %struct.Memory*)** elementtype(%struct.Memory* (%struct.State*, i64, %struct.Memory*)*) @1, void ()** elementtype(void ()*) @2)
  ret i32 undef
}

; Function Attrs: noinline
declare !remill.function.type !1317 void @__mcsema_attach_call() #12

define internal %struct.Memory* @main_wrapper(%struct.State* %0, i64 %1, %struct.Memory* %2) {
  call void @__mcsema_early_init()
  %4 = tail call %struct.Memory* @sub_1100_main(%struct.State* @__mcsema_reg_state, i64 %1, %struct.Memory* %2)
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
  %4 = tail call %struct.Memory* @sub_12f0_frame_dummy(%struct.State* @__mcsema_reg_state, i64 %1, %struct.Memory* %2)
  ret %struct.Memory* %4
}

define internal %struct.Memory* @__do_global_dtors_aux_wrapper(%struct.State* %0, i64 %1, %struct.Memory* %2) {
  call void @__mcsema_early_init()
  %4 = tail call %struct.Memory* @sub_12b0___do_global_dtors_aux(%struct.State* @__mcsema_reg_state, i64 %1, %struct.Memory* %2)
  ret %struct.Memory* %4
}

define internal %struct.Memory* @_start_wrapper(%struct.State* %0, i64 %1, %struct.Memory* %2) {
  call void @__mcsema_early_init()
  %4 = tail call %struct.Memory* @sub_1210__start(%struct.State* @__mcsema_reg_state, i64 %1, %struct.Memory* %2)
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
!1315 = !{!"base.external.cfgexternal"}
!1316 = !{!"base.entrypoint"}
!1317 = !{!"base.helper.mcsema"}
