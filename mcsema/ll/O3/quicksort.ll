; ModuleID = 'quicksort.bc'
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
%seg_1000__init_1b_type = type <{ [27 x i8], [5 x i8], [48 x i8], [16 x i8], [32 x i8], [220 x i8], [4 x i8], [36 x i8], [4 x i8], [4 x i8], [4 x i8], [60 x i8], [4 x i8], [60 x i8], [4 x i8], [12 x i8], [4 x i8], [243 x i8], [1 x i8], [13 x i8] }>
%seg_2000__rodata_30_type = type <{ [12 x i8], [4 x i8], [32 x i8], [60 x i8], [4 x i8], [4 x i8], [4 x i8], [36 x i8], [4 x i8], [36 x i8], [4 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [124 x i8], [4 x i8] }>
%seg_3db0__init_array_10_type = type <{ [3504 x i8], i8*, i8*, [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [84 x i8], [4 x i8], [20 x i8], i8*, i8*, i8*, i8*, i8*, i8*, i8*, [8 x i8], i8*, [8 x i8], [1 x i8] }>
%struct.Memory = type opaque
%seg_0_LOAD_6a8_type = type <{ [8 x i8], [8 x i8], [8 x i8], i8*, [4 x i8], [4 x i8], [4 x i8], [8 x i8], [24 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [8 x i8], [24 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], i8*, [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], i8*, [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], i8*, [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], i8*, [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [8 x i8], [40 x i8], [4 x i8], [4 x i8], [12 x i8], [4 x i8], i8*, [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [28 x i8], [4 x i8], [28 x i8], [4 x i8], [12 x i8], [4 x i8], [52 x i8], [4 x i8], [8 x i8], [8 x i8], [20 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [28 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [8 x i8], [16 x i8], [204 x i8], [4 x i8], [12 x i8], [4 x i8], [60 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8], [4 x i8], [4 x i8], [8 x i8], [8 x i8] }>

@__mcsema_reg_state = thread_local(initialexec) global %struct.State zeroinitializer
@seg_1000__init_1b = internal constant %seg_1000__init_1b_type <{ [27 x i8] c"\F3\0F\1E\FAH\83\EC\08H\8B\05\D9/\00\00H\85\C0t\02\FF\D0H\83\C4\08\C3", [5 x i8] zeroinitializer, [48 x i8] c"\FF5\92/\00\00\FF%\94/\00\00\0F\1F@\00\F3\0F\1E\FAh\00\00\00\00\E9\E2\FF\FF\FFf\90\F3\0F\1E\FAh\01\00\00\00\E9\D2\FF\FF\FFf\90", [16 x i8] c"\F3\0F\1E\FA\FF%\9E/\00\00f\0F\1FD\00\00", [32 x i8] c"\F3\0F\1E\FA\FF%^/\00\00f\0F\1FD\00\00\F3\0F\1E\FA\FF%V/\00\00f\0F\1FD\00\00", [220 x i8] c"\F3\0F\1E\FAAT\BA\09\00\00\001\F6UH\8D-o\0F\00\00SH\83\EC0f\0Fo\05n\0F\00\00dH\8B\04%(\00\00\00H\89D$(1\C0H\89\E3L\8Dd$(H\C7D$ \04\00\00\00\0F)\04$f\0Fo\05Q\0F\00\00H\89\DF\0F)D$\10\E8D\01\00\00\0F\1F@\00\8B\13H\89\EE\BF\02\00\00\001\C0H\83\C3\04\E8{\FF\FF\FFI9\DCu\E61\C0H\8D5\05\0F\00\00\BF\02\00\00\00\E8c\FF\FF\FFH\8BD$(dH+\04%(\00\00\00u\0BH\83\C401\C0[]A\\\C3\E83\FF\FF\FF\0F\1F\00\F3\0F\1E\FA1\EDI\89\D1^H\89\E2H\83\E4\F0PTE1\C01\C9H\8D=1\FF\FF\FF\FF\15\83.\00\00\F4f.\0F\1F\84\00", [4 x i8] zeroinitializer, [36 x i8] c"H\8D=\A9.\00\00H\8D\05\A2.\00\00H9\F8t\15H\8B\05f.\00\00H\85\C0t\09\FF\E0\0F\1F\80", [4 x i8] zeroinitializer, [4 x i8] c"\C3\0F\1F\80", [4 x i8] zeroinitializer, [60 x i8] c"H\8D=y.\00\00H\8D5r.\00\00H)\FEH\89\F0H\C1\EE?H\C1\F8\03H\01\C6H\D1\FEt\14H\8B\055.\00\00H\85\C0t\08\FF\E0f\0F\1FD\00\00\C3\0F\1F\80", [4 x i8] zeroinitializer, [60 x i8] c"\F3\0F\1E\FA\80=5.\00\00\00u+UH\83=\12.\00\00\00H\89\E5t\0CH\8B=\16.\00\00\E8Y\FE\FF\FF\E8d\FF\FF\FF\C6\05\0D.\00\00\01]\C3\0F\1F\00\C3\0F\1F\80", [4 x i8] zeroinitializer, [12 x i8] c"\F3\0F\1E\FA\E9w\FF\FF\FF\0F\1F\80", [4 x i8] zeroinitializer, [243 x i8] c"H9\D6\0F\8D\E9\00\00\00AVAUI\89\D5ATI\89\F4UH\89\FDSL\89\E8L\89\E7M\8DL$\01L\89\EBL)\E0H\D1\F8L\01\E0\8Bt\85\00J\8D\04\AD\00\00\00\00\0F\1F\00D\8BD\BD\00H\8DL\05\00\8B\11A9\F0|j9\D6}\1CH\8DD\05\FCf\0F\1FD\00\00H\89\C1\8B\10H\83\E8\04H\83\EB\019\F2\7F\EFI\89\FEH9\DF~'H\89\DAL\89\E8L)\E2L)\F0H9\C2}>L9\E3\7FCM\89\F4M9\E5\7F\83[]A\\A]A^\C3H\83\EB\01\89T\BD\00M\89\CED\89\01I9\D9\7F\C6H\8D\04\9D\00\00\00\00I\83\C1\01H\83\C7\01\E9x\FF\FF\FFM9\EE|\15I\89\DD\EB\C0H\89\DAL\89\E6H\89\EF\E8 \FF\FF\FF\EB\ADL\89\EAL\89\F6H\89\EF\E8\10\FF\FF\FF\EB\DB\C3", [1 x i8] zeroinitializer, [13 x i8] c"\F3\0F\1E\FAH\83\EC\08H\83\C4\08\C3" }>, align 4096
@seg_2000__rodata_30 = internal constant %seg_2000__rodata_30_type <{ [12 x i8] c"\01\00\02\00%d \00\0A\00\00\00", [4 x i8] zeroinitializer, [32 x i8] c"\09\00\00\00\01\00\00\00\05\00\00\00\03\00\00\00\07\00\00\00\02\00\00\00\08\00\00\00\06\00\00\00", [60 x i8] c"\01\1B\03;<\00\00\00\06\00\00\00\F0\EF\FF\FFp\00\00\00 \F0\FF\FF\98\00\00\000\F0\FF\FF\B0\00\00\00P\F0\FF\FF\10\01\00\00\00\F1\FF\FFX\00\00\00\F0\F1\FF\FF\C8\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\14\00\00\00", [4 x i8] zeroinitializer, [36 x i8] c"\01zR\00\01x\10\01\1B\0C\07\08\90\01\00\00\14\00\00\00\1C\00\00\00\A0\F0\FF\FF&\00\00\00\00D\07\10", [4 x i8] zeroinitializer, [36 x i8] c"$\00\00\004\00\00\00x\EF\FF\FF0\00\00\00\00\0E\10F\0E\18J\0F\0Bw\08\80\00?\1A9*3$\22", [4 x i8] zeroinitializer, [16 x i8] c"\14\00\00\00\\\00\00\00\80\EF\FF\FF\10\00\00\00", [8 x i8] zeroinitializer, [16 x i8] c"\14\00\00\00t\00\00\00x\EF\FF\FF \00\00\00", [8 x i8] zeroinitializer, [124 x i8] c"D\00\00\00\8C\00\00\00 \F1\FF\FF\F3\00\00\00\00K\0E\10\8E\02B\0E\18\8D\03E\0E \8C\04D\0E(\86\05D\0E0\83\06\02~\0A\0E(A\0E B\0E\18B\0E\10B\0E\08A\0B\02R\0E\08\C3\C6\CC\CD\CE\00\000\00\00\00\D4\00\00\008\EF\FF\FF\AD\00\00\00\00F\0E\10\8C\02H\0E\18\86\03H\0E \83\04D\0EP\02\87\0A\0E C\0E\18A\0E\10B\0E\08A\0B\00", [4 x i8] zeroinitializer }>, align 8192
@seg_3db0__init_array_10 = internal global %seg_3db0__init_array_10_type <{ [3504 x i8] zeroinitializer, i8* bitcast (void ()* @frame_dummy to i8*), i8* bitcast (void ()* @__do_global_dtors_aux to i8*), [4 x i8] c"\01\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"@\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\0C\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\00\10\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\0D\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\14\13\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\19\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\B0=\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\1B\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\1A\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\B8=\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\1C\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\F5\FE\FFo", [4 x i8] zeroinitializer, [4 x i8] c"\B0\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\05\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\98\04\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\06\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\D8\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\0A\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\BC\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\0B\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\18\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\15\00\00\00", [12 x i8] zeroinitializer, [4 x i8] c"\03\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\B0?\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\02\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"0\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\14\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\07\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\17\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"x\06\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\07\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\B8\05\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\C0\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\09\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\18\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\1E\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\FB\FF\FFo", [4 x i8] zeroinitializer, [4 x i8] c"\01\00\00\08", [4 x i8] zeroinitializer, [4 x i8] c"\FE\FF\FFo", [4 x i8] zeroinitializer, [4 x i8] c"h\05\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\FF\FF\FFo", [4 x i8] zeroinitializer, [4 x i8] c"\01\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\F0\FF\FFo", [4 x i8] zeroinitializer, [4 x i8] c"T\05\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\F9\FF\FFo", [4 x i8] zeroinitializer, [4 x i8] c"\03\00\00\00", [84 x i8] zeroinitializer, [4 x i8] c"\C0=\00\00", [20 x i8] zeroinitializer, i8* bitcast (i64 ()* @__stack_chk_fail to i8*), i8* bitcast (i64 (...)* @__printf_chk to i8*), i8* bitcast (void (i32 (i32, i8**, i8**)*, i32, i8**, i8*, i32 (i32, i8**, i8**)*, void ()*, void ()*, i32*)* @__libc_start_main to i8*), i8* bitcast (i64 (i64)* @_ITM_deregisterTMCloneTable to i8*), i8* bitcast (void ()* @__gmon_start__ to i8*), i8* bitcast (i64 (i64, i64)* @_ITM_registerTMCloneTable to i8*), i8* bitcast (i64 (i64)* @__cxa_finalize to i8*), [8 x i8] zeroinitializer, i8* bitcast (i8** @data_4008 to i8*), [8 x i8] zeroinitializer, [1 x i8] zeroinitializer }>, align 4096
@0 = internal global i1 false
@1 = internal constant %struct.Memory* (%struct.State*, i64, %struct.Memory*)* @main_wrapper
@2 = internal constant void ()* @__mcsema_attach_call
@3 = internal constant %struct.Memory* (%struct.State*, i64, %struct.Memory*)* @frame_dummy_wrapper
@4 = internal constant %struct.Memory* (%struct.State*, i64, %struct.Memory*)* @__do_global_dtors_aux_wrapper
@seg_0_LOAD_6a8 = internal constant %seg_0_LOAD_6a8_type <{ [8 x i8] c"\7FELF\02\01\01\00", [8 x i8] zeroinitializer, [8 x i8] c"\03\00>\00\01\00\00\00", i8* bitcast (void ()* @_start to i8*), [4 x i8] c"@\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\F86\00\00", [8 x i8] zeroinitializer, [24 x i8] c"@\008\00\0D\00@\00\1F\00\1E\00\06\00\00\00\04\00\00\00@\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"@\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"@\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\D8\02\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\D8\02\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [12 x i8] c"\03\00\00\00\04\00\00\00\18\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\18\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\18\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\1C\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\1C\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\01\00\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\01\00\00\00\04\00\00\00", [24 x i8] zeroinitializer, [4 x i8] c"\A8\06\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\A8\06\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\00\10\00\00", [4 x i8] zeroinitializer, [12 x i8] c"\01\00\00\00\05\00\00\00\00\10\00\00", [4 x i8] zeroinitializer, i8* bitcast (void ()* @.init_proc to i8*), [4 x i8] c"\00\10\00\00", [4 x i8] zeroinitializer, [4 x i8] c"!\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"!\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\00\10\00\00", [4 x i8] zeroinitializer, [12 x i8] c"\01\00\00\00\04\00\00\00\00 \00\00", [4 x i8] zeroinitializer, i8* @data_2000, [4 x i8] c"\00 \00\00", [4 x i8] zeroinitializer, [4 x i8] c"x\01\00\00", [4 x i8] zeroinitializer, [4 x i8] c"x\01\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\00\10\00\00", [4 x i8] zeroinitializer, [12 x i8] c"\01\00\00\00\06\00\00\00\B0-\00\00", [4 x i8] zeroinitializer, i8* bitcast (i8** @data_3db0 to i8*), [4 x i8] c"\B0=\00\00", [4 x i8] zeroinitializer, [4 x i8] c"`\02\00\00", [4 x i8] zeroinitializer, [4 x i8] c"h\02\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\00\10\00\00", [4 x i8] zeroinitializer, [12 x i8] c"\02\00\00\00\06\00\00\00\C0-\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\C0=\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\C0=\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\F0\01\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\F0\01\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [12 x i8] c"\04\00\00\00\04\00\00\008\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"8\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"8\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"0\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"0\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [12 x i8] c"\04\00\00\00\04\00\00\00h\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"h\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"h\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"D\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"D\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\04\00\00\00", [4 x i8] zeroinitializer, [12 x i8] c"S\E5td\04\00\00\008\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"8\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"8\03\00\00", [4 x i8] zeroinitializer, [4 x i8] c"0\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"0\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [12 x i8] c"P\E5td\04\00\00\000 \00\00", [4 x i8] zeroinitializer, i8* @data_2030, [4 x i8] c"0 \00\00", [4 x i8] zeroinitializer, [4 x i8] c"<\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"<\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\04\00\00\00", [4 x i8] zeroinitializer, [8 x i8] c"Q\E5td\06\00\00\00", [40 x i8] zeroinitializer, [4 x i8] c"\10\00\00\00", [4 x i8] zeroinitializer, [12 x i8] c"R\E5td\04\00\00\00\B0-\00\00", [4 x i8] zeroinitializer, i8* bitcast (i8** @data_3db0 to i8*), [4 x i8] c"\B0=\00\00", [4 x i8] zeroinitializer, [4 x i8] c"P\02\00\00", [4 x i8] zeroinitializer, [4 x i8] c"P\02\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\01\00\00\00", [4 x i8] zeroinitializer, [28 x i8] c"/lib64/ld-linux-x86-64.so.2\00", [4 x i8] zeroinitializer, [28 x i8] c"\04\00\00\00 \00\00\00\05\00\00\00GNU\00\02\00\00\C0\04\00\00\00\03\00\00\00", [4 x i8] zeroinitializer, [12 x i8] c"\02\80\00\C0\04\00\00\00\01\00\00\00", [4 x i8] zeroinitializer, [52 x i8] c"\04\00\00\00\14\00\00\00\03\00\00\00GNU\00J\E5_q\04\B7\80%\A4O\81\FAD#\83\97\D6\84\99,\04\00\00\00\10\00\00\00\01\00\00\00GNU\00", [4 x i8] zeroinitializer, [8 x i8] c"\03\00\00\00\02\00\00\00", [8 x i8] zeroinitializer, [20 x i8] c"\02\00\00\00\07\00\00\00\01\00\00\00\06\00\00\00\00\00\81\00", [4 x i8] zeroinitializer, [4 x i8] c"\07\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\D1e\CEm", [28 x i8] zeroinitializer, [8 x i8] c"\1F\00\00\00\12\00\00\00", [16 x i8] zeroinitializer, [8 x i8] c"w\00\00\00 \00\00\00", [16 x i8] zeroinitializer, [8 x i8] c"\01\00\00\00\12\00\00\00", [16 x i8] zeroinitializer, [8 x i8] c"\93\00\00\00 \00\00\00", [16 x i8] zeroinitializer, [8 x i8] c"\12\00\00\00\12\00\00\00", [16 x i8] zeroinitializer, [8 x i8] c"\A2\00\00\00 \00\00\00", [16 x i8] zeroinitializer, [8 x i8] c"1\00\00\00\22\00\00\00", [16 x i8] zeroinitializer, [204 x i8] c"\00__stack_chk_fail\00__printf_chk\00__libc_start_main\00__cxa_finalize\00libc.so.6\00GLIBC_2.2.5\00GLIBC_2.3.4\00GLIBC_2.4\00GLIBC_2.34\00_ITM_deregisterTMCloneTable\00__gmon_start__\00_ITM_registerTMCloneTable\00\00\00\02\00\01\00\03\00\01\00\04\00\01\00\05\00", [4 x i8] zeroinitializer, [12 x i8] c"\01\00\04\00@\00\00\00\10\00\00\00", [4 x i8] zeroinitializer, [60 x i8] c"u\1Ai\09\00\00\05\00J\00\00\00\10\00\00\00t\19i\09\00\00\04\00V\00\00\00\10\00\00\00\14ii\0D\00\00\03\00b\00\00\00\10\00\00\00\B4\91\96\06\00\00\02\00l\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\B0=\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\10\12\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\B8=\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\D0\11\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08@\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08\00\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\08@\00\00", [4 x i8] zeroinitializer, [4 x i8] c"\D8?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\06\00\00\00\01\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\E0?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\06\00\00\00\02\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\E8?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\06\00\00\00\04\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\F0?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\06\00\00\00\06\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\F8?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\06\00\00\00\07\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\C8?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\07\00\00\00\03\00\00\00", [8 x i8] zeroinitializer, [4 x i8] c"\D0?\00\00", [4 x i8] zeroinitializer, [8 x i8] c"\07\00\00\00\05\00\00\00", [8 x i8] zeroinitializer }>
@5 = internal constant %struct.Memory* (%struct.State*, i64, %struct.Memory*)* @_start_wrapper
@6 = internal constant %struct.Memory* (%struct.State*, i64, %struct.Memory*)* @.init_proc_wrapper

@data_1312 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 17, i32 242)
@data_1229 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 17, i32 9)
@data_1128 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 5, i32 168)
@data_111d = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 5, i32 157)
@data_10fa = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 5, i32 122)
@data_10e0 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 5, i32 96)
@data_1208 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 13, i32 56)
@data_11dd = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 13, i32 13)
@data_1014 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 0, i32 20)
@data_2028 = internal alias i8, getelementptr inbounds (%seg_2000__rodata_30_type, %seg_2000__rodata_30_type* @seg_2000__rodata_30, i32 0, i32 2, i32 24)
@data_2018 = internal alias i8, getelementptr inbounds (%seg_2000__rodata_30_type, %seg_2000__rodata_30_type* @seg_2000__rodata_30, i32 0, i32 2, i32 8)
@data_11c9 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 11, i32 57)
@data_3ff0 = internal alias i8*, getelementptr inbounds (%seg_3db0__init_array_10_type, %seg_3db0__init_array_10_type* @seg_3db0__init_array_10, i32 0, i32 112)
@data_1189 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 9, i32 1)
@data_3fe0 = internal alias i8*, getelementptr inbounds (%seg_3db0__init_array_10_type, %seg_3db0__init_array_10_type* @seg_3db0__init_array_10, i32 0, i32 110)
@data_1155 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 5, i32 213)
@data_3fd8 = internal alias i8*, getelementptr inbounds (%seg_3db0__init_array_10_type, %seg_3db0__init_array_10_type* @seg_3db0__init_array_10, i32 0, i32 109)
@data_2008 = internal alias i8, getelementptr inbounds (%seg_2000__rodata_30_type, %seg_2000__rodata_30_type* @seg_2000__rodata_30, i32 0, i32 0, i32 8)
@data_10dc = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 5, i32 92)
@data_2020 = internal alias i8, getelementptr inbounds (%seg_2000__rodata_30_type, %seg_2000__rodata_30_type* @seg_2000__rodata_30, i32 0, i32 2, i32 16)
@data_2010 = internal alias i8, getelementptr inbounds (%seg_2000__rodata_30_type, %seg_2000__rodata_30_type* @seg_2000__rodata_30, i32 0, i32 2, i32 0)
@data_2004 = internal alias i8, getelementptr inbounds (%seg_2000__rodata_30_type, %seg_2000__rodata_30_type* @seg_2000__rodata_30, i32 0, i32 0, i32 4)
@data_11f7 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 13, i32 39)
@data_4008 = internal alias i8*, getelementptr inbounds (%seg_3db0__init_array_10_type, %seg_3db0__init_array_10_type* @seg_3db0__init_array_10, i32 0, i32 115)
@data_3ff8 = internal alias i8*, getelementptr inbounds (%seg_3db0__init_array_10_type, %seg_3db0__init_array_10_type* @seg_3db0__init_array_10, i32 0, i32 113)
@data_4010 = internal alias i8, getelementptr inbounds (%seg_3db0__init_array_10_type, %seg_3db0__init_array_10_type* @seg_3db0__init_array_10, i32 0, i32 116, i32 0)
@data_1016 = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 0, i32 22)
@data_3fe8 = internal alias i8*, getelementptr inbounds (%seg_3db0__init_array_10_type, %seg_3db0__init_array_10_type* @seg_3db0__init_array_10, i32 0, i32 111)
@data_102c = internal alias i8, getelementptr inbounds (%seg_1000__init_1b_type, %seg_1000__init_1b_type* @seg_1000__init_1b, i32 0, i32 2, i32 12)
@data_3fc0 = internal alias i8, getelementptr inbounds (%seg_3db0__init_array_10_type, %seg_3db0__init_array_10_type* @seg_3db0__init_array_10, i32 0, i32 106, i32 12)
@data_3fb8 = internal alias i8, getelementptr inbounds (%seg_3db0__init_array_10_type, %seg_3db0__init_array_10_type* @seg_3db0__init_array_10, i32 0, i32 106, i32 4)
@data_2000 = internal alias i8, getelementptr inbounds (%seg_2000__rodata_30_type, %seg_2000__rodata_30_type* @seg_2000__rodata_30, i32 0, i32 0, i32 0)
@data_3db0 = internal alias i8*, getelementptr inbounds (%seg_3db0__init_array_10_type, %seg_3db0__init_array_10_type* @seg_3db0__init_array_10, i32 0, i32 1)
@data_2030 = internal alias i8, getelementptr inbounds (%seg_2000__rodata_30_type, %seg_2000__rodata_30_type* @seg_2000__rodata_30, i32 0, i32 3, i32 0)
@RIP_2472_375215b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 33, i32 0, i32 0)
@RSP_2312_375215b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 13, i32 0, i32 0)
@OF_2077_37521570 = private thread_local(initialexec) alias i8, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 2, i32 13)
@SF_2073_37521570 = private thread_local(initialexec) alias i8, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 2, i32 9)
@ZF_2071_37521570 = private thread_local(initialexec) alias i8, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 2, i32 7)
@AF_2069_37521570 = private thread_local(initialexec) alias i8, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 2, i32 5)
@PF_2067_37521570 = private thread_local(initialexec) alias i8, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 2, i32 3)
@CF_2065_37521570 = private thread_local(initialexec) alias i8, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 2, i32 1)
@RAX_2216_375215b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 1, i32 0, i32 0)
@RSP_2312_37528bc0 = private thread_local(initialexec) alias i64*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 13, i32 0, i32 0) to i64**)
@RDI_2296_375215b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 11, i32 0, i32 0)
@RBP_2328_375215b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 15, i32 0, i32 0)
@FSBASE_2168_375215b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 5, i32 7, i32 0, i32 0)
@RBX_2232_375215b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 3, i32 0, i32 0)
@RBX_2232_3752e140 = private thread_local(initialexec) alias i32*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 3, i32 0, i32 0) to i32**)
@RBP_2328_37528a60 = private thread_local(initialexec) alias i8*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 15, i32 0, i32 0) to i8**)
@RSI_2280_375215b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 9, i32 0, i32 0)
@RSI_2280_37528a60 = private thread_local(initialexec) alias i8*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 9, i32 0, i32 0) to i8**)
@RDX_2264_375215b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 7, i32 0, i32 0)
@R12_2408_375215b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 25, i32 0, i32 0)
@XMM0_16_3752e8f0 = private thread_local(initialexec) alias <2 x float>, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 0) to <2 x float>*)
@XMM0_16_375215d0 = private thread_local(initialexec) alias i128, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 0) to i128*)
@XMM0_24_3752e8f0 = private thread_local(initialexec) alias <2 x float>, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 1) to <2 x float>*)
@RAX_2216_3752e140 = private thread_local(initialexec) alias i32*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 1, i32 0, i32 0) to i32**)
@R8_2344_375215b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 17, i32 0, i32 0)
@RCX_2248_375215b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 5, i32 0, i32 0)
@RCX_2248_3752e140 = private thread_local(initialexec) alias i32*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 5, i32 0, i32 0) to i32**)
@R9_2360_375215b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 19, i32 0, i32 0)
@R13_2424_375215b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 27, i32 0, i32 0)
@R14_2440_375215b8 = private thread_local(initialexec) alias i64, getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 29, i32 0, i32 0)
@RDX_2264_375215a0 = private thread_local(initialexec) alias i32, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 7, i32 0, i32 0) to i32*)
@RSI_2280_375215a0 = private thread_local(initialexec) alias i32, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 9, i32 0, i32 0) to i32*)
@R8_2344_375215a0 = private thread_local(initialexec) alias i32, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 17, i32 0, i32 0) to i32*)
@RDI_2296_3752ffa0 = private thread_local(initialexec) alias i32 (i32, i8**, i8**)*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 11, i32 0, i32 0) to i32 (i32, i8**, i8**)**)
@RIP_2472_37528a60 = private thread_local(initialexec) alias i8*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 33, i32 0, i32 0) to i8**)
@RAX_2216_37528a60 = private thread_local(initialexec) alias i8*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 1, i32 0, i32 0) to i8**)
@RDI_2296_37528a60 = private thread_local(initialexec) alias i8*, bitcast (i64* getelementptr inbounds (%struct.State, %struct.State* @__mcsema_reg_state, i32 0, i32 6, i32 11, i32 0, i32 0) to i8**)

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
  call void asm sideeffect "pushq $0;pushq $$0x1130;jmpq *$1;", "*m,*m,~{dirflag},~{fpsr},~{flags}"(%struct.Memory* (%struct.State*, i64, %struct.Memory*)** elementtype(%struct.Memory* (%struct.State*, i64, %struct.Memory*)*) @5, void ()** elementtype(void ()*) @2)
  ret void
}

; Function Attrs: naked nobuiltin noinline
define private void @frame_dummy() #8 {
  call void asm sideeffect "pushq $0;pushq $$0x1210;jmpq *$1;", "*m,*m,~{dirflag},~{fpsr},~{flags}"(%struct.Memory* (%struct.State*, i64, %struct.Memory*)** elementtype(%struct.Memory* (%struct.State*, i64, %struct.Memory*)*) @3, void ()** elementtype(void ()*) @2)
  ret void
}

; Function Attrs: naked nobuiltin noinline
define private void @__do_global_dtors_aux() #8 {
  call void asm sideeffect "pushq $0;pushq $$0x11d0;jmpq *$1;", "*m,*m,~{dirflag},~{fpsr},~{flags}"(%struct.Memory* (%struct.State*, i64, %struct.Memory*)** elementtype(%struct.Memory* (%struct.State*, i64, %struct.Memory*)*) @4, void ()** elementtype(void ()*) @2)
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
define internal %struct.Memory* @sub_1020(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1020:
  %0 = load i64, i64* bitcast (i8* @data_3fb8 to i64*), align 8
  %1 = load i64, i64* @RSP_2312_375215b8, align 8, !tbaa !1290
  %2 = add i64 %1, -8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3, align 8
  store i64 %2, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  %4 = load i64, i64* bitcast (i8* @data_3fc0 to i64*), align 8
  store i64 %4, i64* @RIP_2472_375215b8, align 8, !tbaa !1293
  %5 = icmp eq i64 %4, 4140
  br i1 %5, label %inst_102c, label %6

inst_102c:                                        ; preds = %6, %inst_1020
  ret %struct.Memory* %memory

6:                                                ; preds = %inst_1020
  %7 = sub i64 ptrtoint (i8* @data_102c to i64), %4
  %8 = trunc i64 %7 to i32
  %9 = zext i32 %8 to i64
  %10 = icmp eq i64 %9, 0
  br i1 %10, label %inst_102c, label %11

11:                                               ; preds = %6
  %12 = call %struct.Memory* @__remill_jump(%struct.State* @__mcsema_reg_state, i64 %4, %struct.Memory* %memory)
  ret %struct.Memory* %12
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1030(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1030:
  %0 = load i64, i64* @RSP_2312_375215b8, align 8, !tbaa !1290
  %1 = add i64 %0, -8
  %2 = inttoptr i64 %1 to i64*
  store i64 0, i64* %2, align 8
  store i64 %1, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  %3 = call %struct.Memory* @sub_1020(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  ret %struct.Memory* %3
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1000__init_proc(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1000:
  %0 = load i64, i64* @RSP_2312_375215b8, align 8
  %1 = sub i64 %0, 8
  store i64 %1, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  %2 = load i64, i64* bitcast (i8** @data_3fe8 to i64*), align 8
  store i64 %2, i64* @RAX_2216_375215b8, align 8, !tbaa !1293
  store i8 0, i8* @CF_2065_37521570, align 1, !tbaa !1295
  %3 = trunc i64 %2 to i32
  %4 = and i32 %3, 255
  %5 = call i32 @llvm.ctpop.i32(i32 %4) #13, !range !1309
  %6 = trunc i32 %5 to i8
  %7 = and i8 %6, 1
  %8 = xor i8 %7, 1
  store i8 %8, i8* @PF_2067_37521570, align 1, !tbaa !1310
  %9 = icmp eq i64 %2, 0
  %10 = zext i1 %9 to i8
  store i8 %10, i8* @ZF_2071_37521570, align 1, !tbaa !1311
  %11 = lshr i64 %2, 63
  %12 = trunc i64 %11 to i8
  store i8 %12, i8* @SF_2073_37521570, align 1, !tbaa !1312
  store i8 0, i8* @OF_2077_37521570, align 1, !tbaa !1313
  store i8 0, i8* @AF_2069_37521570, align 1, !tbaa !1314
  br i1 %9, label %inst_1016, label %inst_1014

inst_1016:                                        ; preds = %inst_1014, %inst_1000
  %13 = phi %struct.Memory* [ %memory, %inst_1000 ], [ %46, %inst_1014 ]
  %14 = load i64, i64* @RSP_2312_375215b8, align 8
  %15 = add i64 8, %14
  %16 = icmp ult i64 %15, %14
  %17 = icmp ult i64 %15, 8
  %18 = or i1 %16, %17
  %19 = zext i1 %18 to i8
  store i8 %19, i8* @CF_2065_37521570, align 1, !tbaa !1295
  %20 = trunc i64 %15 to i32
  %21 = and i32 %20, 255
  %22 = call i32 @llvm.ctpop.i32(i32 %21) #13, !range !1309
  %23 = trunc i32 %22 to i8
  %24 = and i8 %23, 1
  %25 = xor i8 %24, 1
  store i8 %25, i8* @PF_2067_37521570, align 1, !tbaa !1310
  %26 = xor i64 8, %14
  %27 = xor i64 %26, %15
  %28 = lshr i64 %27, 4
  %29 = trunc i64 %28 to i8
  %30 = and i8 %29, 1
  store i8 %30, i8* @AF_2069_37521570, align 1, !tbaa !1314
  %31 = icmp eq i64 %15, 0
  %32 = zext i1 %31 to i8
  store i8 %32, i8* @ZF_2071_37521570, align 1, !tbaa !1311
  %33 = lshr i64 %15, 63
  %34 = trunc i64 %33 to i8
  store i8 %34, i8* @SF_2073_37521570, align 1, !tbaa !1312
  %35 = lshr i64 %14, 63
  %36 = xor i64 %33, %35
  %37 = add nuw nsw i64 %36, %33
  %38 = icmp eq i64 %37, 2
  %39 = zext i1 %38 to i8
  store i8 %39, i8* @OF_2077_37521570, align 1, !tbaa !1313
  %40 = add i64 %15, 8
  store i64 %40, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  ret %struct.Memory* %13

inst_1014:                                        ; preds = %inst_1000
  %41 = icmp eq i8 %10, 0
  %42 = select i1 %41, i64 ptrtoint (i8* @data_1014 to i64), i64 ptrtoint (i8* @data_1016 to i64)
  %43 = add i64 %42, 2
  %44 = add i64 %1, -8
  %45 = inttoptr i64 %44 to i64*
  store i64 %43, i64* %45, align 8
  store i64 %44, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  store i64 %2, i64* @RIP_2472_375215b8, align 8, !tbaa !1293
  %46 = call %struct.Memory* @__remill_function_call(%struct.State* @__mcsema_reg_state, i64 %2, %struct.Memory* %memory)
  br label %inst_1016
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_11d0___do_global_dtors_aux(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_11d0:
  %0 = load i8, i8* @data_4010, align 1
  store i8 0, i8* @CF_2065_37521570, align 1, !tbaa !1295
  %1 = zext i8 %0 to i32
  %2 = call i32 @llvm.ctpop.i32(i32 %1) #13, !range !1309
  %3 = trunc i32 %2 to i8
  %4 = and i8 %3, 1
  %5 = xor i8 %4, 1
  store i8 %5, i8* @PF_2067_37521570, align 1, !tbaa !1310
  store i8 0, i8* @AF_2069_37521570, align 1, !tbaa !1314
  %6 = icmp eq i8 %0, 0
  %7 = zext i1 %6 to i8
  store i8 %7, i8* @ZF_2071_37521570, align 1, !tbaa !1311
  %8 = lshr i8 %0, 7
  store i8 %8, i8* @SF_2073_37521570, align 1, !tbaa !1312
  store i8 0, i8* @OF_2077_37521570, align 1, !tbaa !1313
  %9 = icmp eq i8 %7, 0
  br i1 %9, label %inst_1208, label %inst_11dd

inst_11f7:                                        ; preds = %inst_11eb, %inst_11dd
  %10 = phi i64 [ %40, %inst_11dd ], [ ptrtoint (i8* @data_11f7 to i64), %inst_11eb ]
  %11 = phi %struct.Memory* [ %memory, %inst_11dd ], [ %46, %inst_11eb ]
  %12 = add i64 %10, 5
  %13 = load i64, i64* @RSP_2312_375215b8, align 8, !tbaa !1290
  %14 = add i64 %13, -8
  %15 = inttoptr i64 %14 to i64*
  store i64 %12, i64* %15, align 8
  store i64 %14, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  %16 = call %struct.Memory* @sub_1160_deregister_tm_clones(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %11)
  store i8 1, i8* @data_4010, align 1
  %17 = load i64*, i64** @RSP_2312_37528bc0, align 8
  %18 = load i64, i64* @RSP_2312_375215b8, align 8, !tbaa !1290
  %19 = add i64 %18, 8
  %20 = load i64, i64* %17, align 8
  store i64 %20, i64* @RBP_2328_375215b8, align 8, !tbaa !1293
  %21 = add i64 %19, 8
  store i64 %21, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  ret %struct.Memory* %16

inst_1208:                                        ; preds = %inst_11d0
  %22 = load i64, i64* @RSP_2312_375215b8, align 8, !tbaa !1290
  %23 = add i64 %22, 8
  store i64 %23, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  ret %struct.Memory* %memory

inst_11dd:                                        ; preds = %inst_11d0
  %24 = load i64, i64* @RBP_2328_375215b8, align 8
  %25 = load i64, i64* @RSP_2312_375215b8, align 8, !tbaa !1290
  %26 = add i64 %25, -8
  %27 = inttoptr i64 %26 to i64*
  store i64 %24, i64* %27, align 8
  store i64 %26, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  %28 = load i64, i64* bitcast (i8** @data_3ff8 to i64*), align 8
  store i8 0, i8* @CF_2065_37521570, align 1, !tbaa !1295
  %29 = trunc i64 %28 to i32
  %30 = and i32 %29, 255
  %31 = call i32 @llvm.ctpop.i32(i32 %30) #13, !range !1309
  %32 = trunc i32 %31 to i8
  %33 = and i8 %32, 1
  %34 = xor i8 %33, 1
  store i8 %34, i8* @PF_2067_37521570, align 1, !tbaa !1310
  store i8 0, i8* @AF_2069_37521570, align 1, !tbaa !1314
  %35 = icmp eq i64 %28, 0
  %36 = zext i1 %35 to i8
  store i8 %36, i8* @ZF_2071_37521570, align 1, !tbaa !1311
  %37 = lshr i64 %28, 63
  %38 = trunc i64 %37 to i8
  store i8 %38, i8* @SF_2073_37521570, align 1, !tbaa !1312
  store i8 0, i8* @OF_2077_37521570, align 1, !tbaa !1313
  store i64 %26, i64* @RBP_2328_375215b8, align 8, !tbaa !1293
  %39 = icmp eq i8 %36, 0
  %40 = select i1 %39, i64 add (i64 ptrtoint (i8* @data_11dd to i64), i64 14), i64 add (i64 ptrtoint (i8* @data_11dd to i64), i64 26)
  br i1 %35, label %inst_11f7, label %inst_11eb

inst_11eb:                                        ; preds = %inst_11dd
  %41 = add i64 %40, 7
  %42 = load i64, i64* bitcast (i8** @data_4008 to i64*), align 8
  store i64 %42, i64* @RDI_2296_375215b8, align 8, !tbaa !1293
  %43 = add i64 %41, 5
  %44 = add i64 %26, -8
  %45 = getelementptr i64, i64* %27, i32 -1
  store i64 %43, i64* %45, align 8
  store i64 %44, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  %46 = call %struct.Memory* @ext_1050___cxa_finalize(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  br label %inst_11f7
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1080_main(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1080:
  %0 = load i64, i64* @R12_2408_375215b8, align 8
  %1 = load i64, i64* @RSP_2312_375215b8, align 8, !tbaa !1290
  %2 = add i64 %1, -8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3, align 8
  store i64 9, i64* @RDX_2264_375215b8, align 8, !tbaa !1293
  store i64 0, i64* @RSI_2280_375215b8, align 8, !tbaa !1293
  %4 = load i64, i64* @RBP_2328_375215b8, align 8
  %5 = add i64 %2, -8
  %6 = getelementptr i64, i64* %3, i32 -1
  store i64 %4, i64* %6, align 8
  store i8* @data_2004, i8** @RBP_2328_37528a60, align 8
  %7 = load i64, i64* @RBX_2232_375215b8, align 8
  %8 = add i64 %5, -8
  %9 = getelementptr i64, i64* %6, i32 -1
  store i64 %7, i64* %9, align 8
  %10 = sub i64 %8, 48
  %11 = inttoptr i64 %10 to float*
  %12 = inttoptr i64 %10 to i64*
  %13 = load i64, i64* bitcast (i8* @data_2010 to i64*), align 8
  %14 = load i64, i64* bitcast (i8* @data_2018 to i64*), align 8
  %15 = zext i64 %14 to i128
  %16 = shl nuw i128 %15, 64
  %17 = zext i64 %13 to i128
  %18 = or i128 %16, %17
  store i128 %18, i128* @XMM0_16_375215d0, align 1, !tbaa !1315
  %19 = load i64, i64* @FSBASE_2168_375215b8, align 8
  %20 = add i64 %19, 40
  %21 = inttoptr i64 %20 to i64*
  %22 = load i64, i64* %21, align 8
  %23 = add i64 %10, 40
  %24 = getelementptr i64, i64* %12, i32 5
  store i64 %22, i64* %24, align 8
  store i64 0, i64* @RAX_2216_375215b8, align 8, !tbaa !1293
  store i8 0, i8* @CF_2065_37521570, align 1, !tbaa !1295
  store i8 1, i8* @PF_2067_37521570, align 1, !tbaa !1310
  store i8 1, i8* @ZF_2071_37521570, align 1, !tbaa !1311
  store i8 0, i8* @SF_2073_37521570, align 1, !tbaa !1312
  store i8 0, i8* @OF_2077_37521570, align 1, !tbaa !1313
  store i8 0, i8* @AF_2069_37521570, align 1, !tbaa !1314
  store i64 %10, i64* @RBX_2232_375215b8, align 8, !tbaa !1293
  store i64 %23, i64* @R12_2408_375215b8, align 8, !tbaa !1293
  %25 = getelementptr i64, i64* %12, i32 4
  store i64 4, i64* %25, align 8
  %26 = load <2 x float>, <2 x float>* @XMM0_16_3752e8f0, align 1
  %27 = load <2 x float>, <2 x float>* @XMM0_24_3752e8f0, align 1
  %28 = extractelement <2 x float> %26, i32 0
  store float %28, float* %11, align 4
  %29 = extractelement <2 x float> %26, i32 1
  %30 = getelementptr float, float* %11, i32 1
  store float %29, float* %30, align 4
  %31 = extractelement <2 x float> %27, i32 0
  %32 = getelementptr float, float* %11, i32 2
  store float %31, float* %32, align 4
  %33 = extractelement <2 x float> %27, i32 1
  %34 = getelementptr float, float* %11, i32 3
  store float %33, float* %34, align 4
  %35 = load i64, i64* bitcast (i8* @data_2020 to i64*), align 8
  %36 = load i64, i64* bitcast (i8* @data_2028 to i64*), align 8
  %37 = zext i64 %36 to i128
  %38 = shl nuw i128 %37, 64
  %39 = zext i64 %35 to i128
  %40 = or i128 %38, %39
  store i128 %40, i128* @XMM0_16_375215d0, align 1, !tbaa !1315
  store i64 %10, i64* @RDI_2296_375215b8, align 8, !tbaa !1293
  %41 = getelementptr float, float* %11, i32 4
  %42 = load <2 x float>, <2 x float>* @XMM0_16_3752e8f0, align 1
  %43 = load <2 x float>, <2 x float>* @XMM0_24_3752e8f0, align 1
  %44 = extractelement <2 x float> %42, i32 0
  store float %44, float* %41, align 4
  %45 = extractelement <2 x float> %42, i32 1
  %46 = getelementptr float, float* %41, i32 1
  store float %45, float* %46, align 4
  %47 = extractelement <2 x float> %43, i32 0
  %48 = getelementptr float, float* %41, i32 2
  store float %47, float* %48, align 4
  %49 = extractelement <2 x float> %43, i32 1
  %50 = getelementptr float, float* %41, i32 3
  store float %49, float* %50, align 4
  %51 = add i64 %10, -8
  %52 = getelementptr i64, i64* %12, i32 -1
  store i64 ptrtoint (i8* @data_10dc to i64), i64* %52, align 8
  store i64 %51, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  %53 = call %struct.Memory* @sub_1220_quick_sort(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  br label %inst_10e0

inst_10e0:                                        ; preds = %inst_10e0, %inst_1080
  %54 = phi i64 [ ptrtoint (i8* @data_10e0 to i64), %inst_1080 ], [ %102, %inst_10e0 ]
  %55 = phi %struct.Memory* [ %53, %inst_1080 ], [ %95, %inst_10e0 ]
  %56 = add i64 %54, 2
  %57 = load i32*, i32** @RBX_2232_3752e140, align 8
  %58 = load i64, i64* @RBX_2232_375215b8, align 8
  %59 = load i32, i32* %57, align 4
  %60 = zext i32 %59 to i64
  store i64 %60, i64* @RDX_2264_375215b8, align 8, !tbaa !1293
  %61 = add i64 %56, 3
  %62 = load i64, i64* @RBP_2328_375215b8, align 8
  store i64 %62, i64* @RSI_2280_375215b8, align 8, !tbaa !1293
  %63 = add i64 %61, 5
  store i64 2, i64* @RDI_2296_375215b8, align 8, !tbaa !1293
  %64 = add i64 %63, 2
  store i64 0, i64* @RAX_2216_375215b8, align 8, !tbaa !1293
  %65 = add i64 %64, 4
  %66 = add i64 4, %58
  store i64 %66, i64* @RBX_2232_375215b8, align 8, !tbaa !1293
  %67 = icmp ult i64 %66, %58
  %68 = icmp ult i64 %66, 4
  %69 = or i1 %67, %68
  %70 = zext i1 %69 to i8
  store i8 %70, i8* @CF_2065_37521570, align 1, !tbaa !1295
  %71 = trunc i64 %66 to i32
  %72 = and i32 %71, 255
  %73 = call i32 @llvm.ctpop.i32(i32 %72) #13, !range !1309
  %74 = trunc i32 %73 to i8
  %75 = and i8 %74, 1
  %76 = xor i8 %75, 1
  store i8 %76, i8* @PF_2067_37521570, align 1, !tbaa !1310
  %77 = xor i64 4, %58
  %78 = xor i64 %77, %66
  %79 = lshr i64 %78, 4
  %80 = trunc i64 %79 to i8
  %81 = and i8 %80, 1
  store i8 %81, i8* @AF_2069_37521570, align 1, !tbaa !1314
  %82 = icmp eq i64 %66, 0
  %83 = zext i1 %82 to i8
  store i8 %83, i8* @ZF_2071_37521570, align 1, !tbaa !1311
  %84 = lshr i64 %66, 63
  %85 = trunc i64 %84 to i8
  store i8 %85, i8* @SF_2073_37521570, align 1, !tbaa !1312
  %86 = lshr i64 %58, 63
  %87 = xor i64 %84, %86
  %88 = add nuw nsw i64 %87, %84
  %89 = icmp eq i64 %88, 2
  %90 = zext i1 %89 to i8
  store i8 %90, i8* @OF_2077_37521570, align 1, !tbaa !1313
  %91 = add i64 %65, 5
  %92 = load i64, i64* @RSP_2312_375215b8, align 8, !tbaa !1290
  %93 = add i64 %92, -8
  %94 = inttoptr i64 %93 to i64*
  store i64 %91, i64* %94, align 8
  store i64 %93, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  %95 = call %struct.Memory* @ext_1070____printf_chk(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %55)
  %96 = load i64, i64* @R12_2408_375215b8, align 8
  %97 = load i64, i64* @RBX_2232_375215b8, align 8
  %98 = sub i64 %96, %97
  %99 = icmp eq i64 %98, 0
  %100 = zext i1 %99 to i8
  %101 = icmp eq i8 %100, 0
  %102 = select i1 %101, i64 ptrtoint (i8* @data_10e0 to i64), i64 ptrtoint (i8* @data_10fa to i64)
  br i1 %101, label %inst_10e0, label %inst_10fa

inst_10fa:                                        ; preds = %inst_10e0
  %103 = add i64 %102, 2
  store i64 0, i64* @RAX_2216_375215b8, align 8, !tbaa !1293
  store i8 0, i8* @CF_2065_37521570, align 1, !tbaa !1295
  store i8 1, i8* @PF_2067_37521570, align 1, !tbaa !1310
  store i8 1, i8* @ZF_2071_37521570, align 1, !tbaa !1311
  store i8 0, i8* @SF_2073_37521570, align 1, !tbaa !1312
  store i8 0, i8* @OF_2077_37521570, align 1, !tbaa !1313
  store i8 0, i8* @AF_2069_37521570, align 1, !tbaa !1314
  %104 = add i64 %103, 7
  store i8* @data_2008, i8** @RSI_2280_37528a60, align 8
  %105 = add i64 %104, 5
  store i64 2, i64* @RDI_2296_375215b8, align 8, !tbaa !1293
  %106 = add i64 %105, 5
  %107 = load i64, i64* @RSP_2312_375215b8, align 8, !tbaa !1290
  %108 = add i64 %107, -8
  %109 = inttoptr i64 %108 to i64*
  store i64 %106, i64* %109, align 8
  store i64 %108, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  %110 = call %struct.Memory* @ext_1070____printf_chk(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %95)
  %111 = load i64*, i64** @RSP_2312_37528bc0, align 8
  %112 = load i64, i64* @RSP_2312_375215b8, align 8
  %113 = getelementptr i64, i64* %111, i32 5
  %114 = load i64, i64* %113, align 8
  %115 = load i64, i64* @FSBASE_2168_375215b8, align 8
  %116 = add i64 %115, 40
  %117 = inttoptr i64 %116 to i64*
  %118 = load i64, i64* %117, align 8
  %119 = sub i64 %114, %118
  store i64 %119, i64* @RAX_2216_375215b8, align 8, !tbaa !1293
  %120 = icmp ugt i64 %118, %114
  %121 = zext i1 %120 to i8
  store i8 %121, i8* @CF_2065_37521570, align 1, !tbaa !1295
  %122 = trunc i64 %119 to i32
  %123 = and i32 %122, 255
  %124 = call i32 @llvm.ctpop.i32(i32 %123) #13, !range !1309
  %125 = trunc i32 %124 to i8
  %126 = and i8 %125, 1
  %127 = xor i8 %126, 1
  store i8 %127, i8* @PF_2067_37521570, align 1, !tbaa !1310
  %128 = xor i64 %118, %114
  %129 = xor i64 %128, %119
  %130 = lshr i64 %129, 4
  %131 = trunc i64 %130 to i8
  %132 = and i8 %131, 1
  store i8 %132, i8* @AF_2069_37521570, align 1, !tbaa !1314
  %133 = icmp eq i64 %119, 0
  %134 = zext i1 %133 to i8
  store i8 %134, i8* @ZF_2071_37521570, align 1, !tbaa !1311
  %135 = lshr i64 %119, 63
  %136 = trunc i64 %135 to i8
  store i8 %136, i8* @SF_2073_37521570, align 1, !tbaa !1312
  %137 = lshr i64 %114, 63
  %138 = lshr i64 %118, 63
  %139 = xor i64 %138, %137
  %140 = xor i64 %135, %137
  %141 = add nuw nsw i64 %140, %139
  %142 = icmp eq i64 %141, 2
  %143 = zext i1 %142 to i8
  store i8 %143, i8* @OF_2077_37521570, align 1, !tbaa !1313
  %144 = icmp eq i8 %134, 0
  br i1 %144, label %inst_1128, label %inst_111d

inst_1128:                                        ; preds = %inst_10fa
  %145 = add i64 %112, -8
  %146 = inttoptr i64 %145 to i64*
  store i64 add (i64 ptrtoint (i8* @data_1128 to i64), i64 5), i64* %146, align 8
  store i64 %145, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  %147 = call %struct.Memory* @ext_1060____stack_chk_fail(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %110)
  ret %struct.Memory* %147

inst_111d:                                        ; preds = %inst_10fa
  %148 = add i64 48, %112
  %149 = getelementptr i64, i64* %111, i32 6
  store i64 0, i64* @RAX_2216_375215b8, align 8, !tbaa !1293
  store i8 0, i8* @CF_2065_37521570, align 1, !tbaa !1295
  store i8 1, i8* @PF_2067_37521570, align 1, !tbaa !1310
  store i8 1, i8* @ZF_2071_37521570, align 1, !tbaa !1311
  store i8 0, i8* @SF_2073_37521570, align 1, !tbaa !1312
  store i8 0, i8* @OF_2077_37521570, align 1, !tbaa !1313
  store i8 0, i8* @AF_2069_37521570, align 1, !tbaa !1314
  %150 = add i64 %148, 8
  %151 = getelementptr i64, i64* %149, i32 1
  %152 = load i64, i64* %149, align 8
  store i64 %152, i64* @RBX_2232_375215b8, align 8, !tbaa !1293
  %153 = add i64 %150, 8
  %154 = load i64, i64* %151, align 8
  store i64 %154, i64* @RBP_2328_375215b8, align 8, !tbaa !1293
  %155 = add i64 %153, 8
  %156 = getelementptr i64, i64* %151, i32 1
  %157 = load i64, i64* %156, align 8
  store i64 %157, i64* @R12_2408_375215b8, align 8, !tbaa !1293
  %158 = add i64 %155, 8
  store i64 %158, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  ret %struct.Memory* %110
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1220_quick_sort(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1220:
  %0 = load i64, i64* @RSI_2280_375215b8, align 8
  %1 = load i64, i64* @RDX_2264_375215b8, align 8
  %2 = sub i64 %0, %1
  %3 = icmp ult i64 %0, %1
  %4 = zext i1 %3 to i8
  store i8 %4, i8* @CF_2065_37521570, align 1, !tbaa !1295
  %5 = trunc i64 %2 to i32
  %6 = and i32 %5, 255
  %7 = call i32 @llvm.ctpop.i32(i32 %6) #13, !range !1309
  %8 = trunc i32 %7 to i8
  %9 = and i8 %8, 1
  %10 = xor i8 %9, 1
  store i8 %10, i8* @PF_2067_37521570, align 1, !tbaa !1310
  %11 = xor i64 %1, %0
  %12 = xor i64 %11, %2
  %13 = lshr i64 %12, 4
  %14 = trunc i64 %13 to i8
  %15 = and i8 %14, 1
  store i8 %15, i8* @AF_2069_37521570, align 1, !tbaa !1314
  %16 = icmp eq i64 %2, 0
  %17 = zext i1 %16 to i8
  store i8 %17, i8* @ZF_2071_37521570, align 1, !tbaa !1311
  %18 = lshr i64 %2, 63
  %19 = trunc i64 %18 to i8
  store i8 %19, i8* @SF_2073_37521570, align 1, !tbaa !1312
  %20 = lshr i64 %0, 63
  %21 = lshr i64 %1, 63
  %22 = xor i64 %21, %20
  %23 = xor i64 %18, %20
  %24 = add nuw nsw i64 %23, %22
  %25 = icmp eq i64 %24, 2
  %26 = zext i1 %25 to i8
  store i8 %26, i8* @OF_2077_37521570, align 1, !tbaa !1313
  %27 = icmp eq i8 %19, 0
  %28 = xor i1 %27, %25
  br i1 %28, label %inst_1312, label %inst_1229

inst_1280:                                        ; preds = %inst_1275, %inst_1280
  %29 = phi i64 [ %239, %inst_1275 ], [ %58, %inst_1280 ]
  %30 = add i64 %29, 3
  %31 = load i32*, i32** @RAX_2216_3752e140, align 8
  %32 = load i64, i64* @RAX_2216_375215b8, align 8
  store i64 %32, i64* @RCX_2248_375215b8, align 8, !tbaa !1293
  %33 = add i64 %30, 2
  %34 = load i32, i32* %31, align 4
  %35 = zext i32 %34 to i64
  store i64 %35, i64* @RDX_2264_375215b8, align 8, !tbaa !1293
  %36 = add i64 %33, 4
  %37 = sub i64 %32, 4
  store i64 %37, i64* @RAX_2216_375215b8, align 8, !tbaa !1293
  %38 = add i64 %36, 4
  %39 = load i64, i64* @RBX_2232_375215b8, align 8
  %40 = sub i64 %39, 1
  store i64 %40, i64* @RBX_2232_375215b8, align 8, !tbaa !1293
  %41 = add i64 %38, 2
  %42 = sub i32 %34, %183
  %43 = icmp eq i32 %42, 0
  %44 = zext i1 %43 to i8
  %45 = lshr i32 %42, 31
  %46 = trunc i32 %45 to i8
  %47 = lshr i32 %34, 31
  %48 = xor i32 %188, %47
  %49 = xor i32 %45, %47
  %50 = add nuw nsw i32 %49, %48
  %51 = icmp eq i32 %50, 2
  %52 = add i64 %41, 2
  %53 = sub i64 %52, 17
  %54 = icmp eq i8 %44, 0
  %55 = icmp eq i8 %46, 0
  %56 = xor i1 %55, %51
  %57 = and i1 %54, %56
  %58 = select i1 %57, i64 %53, i64 %52
  br i1 %57, label %inst_1280, label %inst_1291

inst_1291:                                        ; preds = %inst_1271, %inst_1280
  %59 = phi i64 [ %235, %inst_1271 ], [ %58, %inst_1280 ]
  %60 = add i64 %59, 3
  store i64 %172, i64* @R14_2440_375215b8, align 8, !tbaa !1293
  %61 = add i64 %60, 3
  %62 = load i64, i64* @RBX_2232_375215b8, align 8
  %63 = sub i64 %172, %62
  %64 = icmp eq i64 %63, 0
  %65 = lshr i64 %63, 63
  %66 = trunc i64 %65 to i8
  %67 = lshr i64 %172, 63
  %68 = lshr i64 %62, 63
  %69 = xor i64 %68, %67
  %70 = xor i64 %65, %67
  %71 = add nuw nsw i64 %70, %69
  %72 = icmp eq i64 %71, 2
  %73 = add i64 %61, 2
  %74 = add i64 %73, 39
  %75 = icmp ne i8 %66, 0
  %76 = xor i1 %75, %72
  %77 = or i1 %64, %76
  %78 = select i1 %77, i64 %74, i64 %73
  br i1 %77, label %inst_12c0, label %inst_1299

inst_1299:                                        ; preds = %inst_12c0, %inst_1291
  %79 = phi i64 [ %267, %inst_12c0 ], [ %78, %inst_1291 ]
  %80 = add i64 %79, 3
  %81 = load i64, i64* @RBX_2232_375215b8, align 8
  %82 = add i64 %80, 3
  %83 = add i64 %82, 3
  %84 = sub i64 %81, %149
  store i64 %84, i64* @RDX_2264_375215b8, align 8, !tbaa !1293
  %85 = lshr i64 %84, 63
  %86 = add i64 %83, 3
  %87 = load i64, i64* @R14_2440_375215b8, align 8
  %88 = sub i64 %147, %87
  store i64 %88, i64* @RAX_2216_375215b8, align 8, !tbaa !1293
  %89 = lshr i64 %88, 63
  %90 = add i64 %86, 3
  %91 = sub i64 %84, %88
  %92 = lshr i64 %91, 63
  %93 = trunc i64 %92 to i8
  %94 = xor i64 %89, %85
  %95 = xor i64 %92, %85
  %96 = add nuw nsw i64 %95, %94
  %97 = icmp eq i64 %96, 2
  %98 = add i64 %90, 2
  %99 = add i64 %98, 62
  %100 = icmp eq i8 %93, 0
  %101 = xor i1 %100, %97
  %102 = select i1 %101, i64 %99, i64 %98
  %103 = add i64 %102, 3
  br i1 %101, label %inst_12e8, label %inst_12aa

inst_12af:                                        ; preds = %inst_12f2, %inst_12aa
  %104 = phi %struct.Memory* [ %332, %inst_12f2 ], [ %145, %inst_12aa ]
  %105 = add i64 %324, 3
  %106 = load i64, i64* @R14_2440_375215b8, align 8
  store i64 %106, i64* @R12_2408_375215b8, align 8, !tbaa !1293
  br label %inst_12b2

inst_12b2:                                        ; preds = %inst_12ed, %inst_12af
  %107 = phi i64 [ undef, %inst_12ed ], [ %105, %inst_12af ]
  %108 = phi %struct.Memory* [ %195, %inst_12ed ], [ %104, %inst_12af ]
  %109 = add i64 %107, 3
  %110 = load i64, i64* @R13_2424_375215b8, align 8
  %111 = load i64, i64* @R12_2408_375215b8, align 8
  %112 = sub i64 %110, %111
  %113 = icmp ult i64 %110, %111
  %114 = zext i1 %113 to i8
  store i8 %114, i8* @CF_2065_37521570, align 1, !tbaa !1295
  %115 = trunc i64 %112 to i32
  %116 = and i32 %115, 255
  %117 = call i32 @llvm.ctpop.i32(i32 %116) #13, !range !1309
  %118 = trunc i32 %117 to i8
  %119 = and i8 %118, 1
  %120 = xor i8 %119, 1
  store i8 %120, i8* @PF_2067_37521570, align 1, !tbaa !1310
  %121 = xor i64 %111, %110
  %122 = xor i64 %121, %112
  %123 = lshr i64 %122, 4
  %124 = trunc i64 %123 to i8
  %125 = and i8 %124, 1
  store i8 %125, i8* @AF_2069_37521570, align 1, !tbaa !1314
  %126 = icmp eq i64 %112, 0
  %127 = zext i1 %126 to i8
  store i8 %127, i8* @ZF_2071_37521570, align 1, !tbaa !1311
  %128 = lshr i64 %112, 63
  %129 = trunc i64 %128 to i8
  store i8 %129, i8* @SF_2073_37521570, align 1, !tbaa !1312
  %130 = lshr i64 %110, 63
  %131 = lshr i64 %111, 63
  %132 = xor i64 %131, %130
  %133 = xor i64 %128, %130
  %134 = add nuw nsw i64 %133, %132
  %135 = icmp eq i64 %134, 2
  %136 = zext i1 %135 to i8
  store i8 %136, i8* @OF_2077_37521570, align 1, !tbaa !1313
  %137 = add i64 %109, 2
  %138 = sub i64 %137, 125
  %139 = icmp eq i8 %127, 0
  %140 = icmp eq i8 %129, 0
  %141 = xor i1 %140, %135
  %142 = and i1 %139, %141
  %143 = select i1 %142, i64 %138, i64 %137
  br i1 %142, label %inst_123a, label %inst_12b7

inst_123a:                                        ; preds = %inst_1229, %inst_12b2
  %144 = phi i64 [ add (i64 ptrtoint (i8* @data_1229 to i64), i64 17), %inst_1229 ], [ %143, %inst_12b2 ]
  %145 = phi %struct.Memory* [ %memory, %inst_1229 ], [ %108, %inst_12b2 ]
  %146 = add i64 %144, 3
  %147 = load i64, i64* @R13_2424_375215b8, align 8
  %148 = add i64 %146, 3
  %149 = load i64, i64* @R12_2408_375215b8, align 8
  store i64 %149, i64* @RDI_2296_375215b8, align 8, !tbaa !1293
  %150 = add i64 %148, 5
  %151 = add i64 %149, 1
  store i64 %151, i64* @R9_2360_375215b8, align 8, !tbaa !1293
  %152 = add i64 %150, 3
  store i64 %147, i64* @RBX_2232_375215b8, align 8, !tbaa !1293
  %153 = add i64 %152, 3
  %154 = sub i64 %147, %149
  %155 = add i64 %153, 3
  %156 = ashr i64 %154, 1
  %157 = add i64 %155, 3
  %158 = add i64 %149, %156
  %159 = add i64 %157, 4
  %160 = load i64, i64* @RBP_2328_375215b8, align 8
  %161 = mul i64 %158, 4
  %162 = add i64 %161, %160
  %163 = inttoptr i64 %162 to i32*
  %164 = load i32, i32* %163, align 4
  %165 = zext i32 %164 to i64
  store i64 %165, i64* @RSI_2280_375215b8, align 8, !tbaa !1293
  %166 = add i64 %159, 8
  %167 = mul i64 %147, 4
  store i64 %167, i64* @RAX_2216_375215b8, align 8, !tbaa !1293
  %168 = add i64 %166, 3
  br label %inst_1260

inst_12db:                                        ; preds = %inst_12d3, %inst_1260
  %169 = load i64, i64* @R9_2360_375215b8, align 8
  %170 = add i64 1, %169
  store i64 %170, i64* @R9_2360_375215b8, align 8, !tbaa !1293
  %171 = add i64 1, %172
  store i64 %171, i64* @RDI_2296_375215b8, align 8, !tbaa !1293
  br label %inst_1260

inst_1260:                                        ; preds = %inst_12db, %inst_123a
  %172 = load i64, i64* @RDI_2296_375215b8, align 8
  %173 = mul i64 %172, 4
  %174 = add i64 %173, %160
  %175 = inttoptr i64 %174 to i32*
  %176 = load i32, i32* %175, align 4
  %177 = zext i32 %176 to i64
  store i64 %177, i64* @R8_2344_375215b8, align 8, !tbaa !1293
  %178 = load i64, i64* @RAX_2216_375215b8, align 8
  %179 = add i64 %178, %160
  store i64 %179, i64* @RCX_2248_375215b8, align 8, !tbaa !1293
  %180 = inttoptr i64 %179 to i32*
  %181 = load i32, i32* %180, align 4
  %182 = zext i32 %181 to i64
  store i64 %182, i64* @RDX_2264_375215b8, align 8, !tbaa !1293
  %183 = load i32, i32* @RSI_2280_375215a0, align 4
  %184 = sub i32 %176, %183
  %185 = lshr i32 %184, 31
  %186 = trunc i32 %185 to i8
  %187 = lshr i32 %176, 31
  %188 = lshr i32 %183, 31
  %189 = xor i32 %188, %187
  %190 = xor i32 %185, %187
  %191 = add nuw nsw i32 %190, %189
  %192 = icmp eq i32 %191, 2
  %193 = icmp ne i8 %186, 0
  %194 = xor i1 %193, %192
  br i1 %194, label %inst_12db, label %inst_1271

inst_12ed:                                        ; preds = %inst_1302, %inst_12e8
  %195 = phi %struct.Memory* [ %360, %inst_1302 ], [ %145, %inst_12e8 ]
  %196 = load i64, i64* @RBX_2232_375215b8, align 8
  store i64 %196, i64* @R13_2424_375215b8, align 8, !tbaa !1293
  br label %inst_12b2

inst_1312:                                        ; preds = %inst_1220
  %197 = load i64, i64* @RSP_2312_375215b8, align 8, !tbaa !1290
  %198 = add i64 %197, 8
  store i64 %198, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  ret %struct.Memory* %memory

inst_1229:                                        ; preds = %inst_1220
  %199 = load i64, i64* @R14_2440_375215b8, align 8
  %200 = load i64, i64* @RSP_2312_375215b8, align 8, !tbaa !1290
  %201 = add i64 %200, -8
  %202 = inttoptr i64 %201 to i64*
  store i64 %199, i64* %202, align 8
  %203 = load i64, i64* @R13_2424_375215b8, align 8
  %204 = add i64 %201, -8
  %205 = getelementptr i64, i64* %202, i32 -1
  store i64 %203, i64* %205, align 8
  store i64 %1, i64* @R13_2424_375215b8, align 8, !tbaa !1293
  %206 = load i64, i64* @R12_2408_375215b8, align 8
  %207 = add i64 %204, -8
  %208 = getelementptr i64, i64* %205, i32 -1
  store i64 %206, i64* %208, align 8
  store i64 %0, i64* @R12_2408_375215b8, align 8, !tbaa !1293
  %209 = load i64, i64* @RBP_2328_375215b8, align 8
  %210 = add i64 %207, -8
  %211 = getelementptr i64, i64* %208, i32 -1
  store i64 %209, i64* %211, align 8
  %212 = load i64, i64* @RDI_2296_375215b8, align 8
  store i64 %212, i64* @RBP_2328_375215b8, align 8, !tbaa !1293
  %213 = load i64, i64* @RBX_2232_375215b8, align 8
  %214 = add i64 %210, -8
  %215 = getelementptr i64, i64* %211, i32 -1
  store i64 %213, i64* %215, align 8
  store i64 %214, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  br label %inst_123a

inst_1271:                                        ; preds = %inst_1260
  %216 = add i64 %168, 5
  %217 = add i64 %216, 5
  %218 = add i64 %217, 2
  %219 = add i64 %218, 3
  %220 = add i64 %219, 2
  %221 = add i64 %220, 2
  %222 = load i32, i32* @RDX_2264_375215a0, align 4
  %223 = sub i32 %183, %222
  %224 = lshr i32 %223, 31
  %225 = trunc i32 %224 to i8
  %226 = lshr i32 %222, 31
  %227 = xor i32 %226, %188
  %228 = xor i32 %224, %188
  %229 = add nuw nsw i32 %228, %227
  %230 = icmp eq i32 %229, 2
  %231 = add i64 %221, 2
  %232 = add i64 %231, 28
  %233 = icmp eq i8 %225, 0
  %234 = xor i1 %233, %230
  %235 = select i1 %234, i64 %232, i64 %231
  br i1 %234, label %inst_1291, label %inst_1275

inst_1275:                                        ; preds = %inst_1271
  %236 = add i64 %235, 5
  %237 = add i64 %160, -4
  %238 = add i64 %237, %178
  store i64 %238, i64* @RAX_2216_375215b8, align 8, !tbaa !1293
  %239 = add i64 %236, 6
  br label %inst_1280

inst_12c0:                                        ; preds = %inst_1291
  %240 = add i64 %78, 4
  %241 = sub i64 %62, 1
  store i64 %241, i64* @RBX_2232_375215b8, align 8, !tbaa !1293
  %242 = lshr i64 %241, 63
  %243 = add i64 %240, 4
  %244 = load i32, i32* @RDX_2264_375215a0, align 4
  store i32 %244, i32* %175, align 4
  %245 = add i64 %243, 3
  %246 = load i64, i64* @R9_2360_375215b8, align 8
  store i64 %246, i64* @R14_2440_375215b8, align 8, !tbaa !1293
  %247 = add i64 %245, 3
  %248 = load i32*, i32** @RCX_2248_3752e140, align 8
  %249 = load i32, i32* @R8_2344_375215a0, align 4
  store i32 %249, i32* %248, align 4
  %250 = add i64 %247, 3
  %251 = sub i64 %246, %241
  %252 = icmp eq i64 %251, 0
  %253 = zext i1 %252 to i8
  %254 = lshr i64 %251, 63
  %255 = trunc i64 %254 to i8
  %256 = lshr i64 %246, 63
  %257 = xor i64 %242, %256
  %258 = xor i64 %254, %256
  %259 = add nuw nsw i64 %258, %257
  %260 = icmp eq i64 %259, 2
  %261 = add i64 %250, 2
  %262 = sub i64 %261, 58
  %263 = icmp eq i8 %253, 0
  %264 = icmp eq i8 %255, 0
  %265 = xor i1 %264, %260
  %266 = and i1 %263, %265
  %267 = select i1 %266, i64 %262, i64 %261
  br i1 %266, label %inst_1299, label %inst_12d3

inst_12e8:                                        ; preds = %inst_1299
  %268 = xor i64 %87, %147
  %269 = lshr i64 %147, 63
  %270 = lshr i64 %87, 63
  %271 = xor i64 %270, %269
  %272 = sub i64 %87, %147
  %273 = icmp ult i64 %87, %147
  %274 = zext i1 %273 to i8
  store i8 %274, i8* @CF_2065_37521570, align 1, !tbaa !1295
  %275 = trunc i64 %272 to i32
  %276 = and i32 %275, 255
  %277 = call i32 @llvm.ctpop.i32(i32 %276) #13, !range !1309
  %278 = trunc i32 %277 to i8
  %279 = and i8 %278, 1
  %280 = xor i8 %279, 1
  store i8 %280, i8* @PF_2067_37521570, align 1, !tbaa !1310
  %281 = xor i64 %268, %272
  %282 = lshr i64 %281, 4
  %283 = trunc i64 %282 to i8
  %284 = and i8 %283, 1
  store i8 %284, i8* @AF_2069_37521570, align 1, !tbaa !1314
  %285 = icmp eq i64 %272, 0
  %286 = zext i1 %285 to i8
  store i8 %286, i8* @ZF_2071_37521570, align 1, !tbaa !1311
  %287 = lshr i64 %272, 63
  %288 = trunc i64 %287 to i8
  store i8 %288, i8* @SF_2073_37521570, align 1, !tbaa !1312
  %289 = xor i64 %287, %270
  %290 = add nuw nsw i64 %289, %271
  %291 = icmp eq i64 %290, 2
  %292 = zext i1 %291 to i8
  store i8 %292, i8* @OF_2077_37521570, align 1, !tbaa !1313
  %293 = icmp ne i8 %288, 0
  %294 = xor i1 %293, %291
  br i1 %294, label %inst_1302, label %inst_12ed

inst_12aa:                                        ; preds = %inst_1299
  %295 = icmp ult i64 %81, %149
  %296 = zext i1 %295 to i8
  %297 = trunc i64 %84 to i32
  %298 = and i32 %297, 255
  %299 = call i32 @llvm.ctpop.i32(i32 %298) #13, !range !1309
  %300 = trunc i32 %299 to i8
  %301 = and i8 %300, 1
  %302 = xor i8 %301, 1
  %303 = xor i64 %149, %81
  %304 = xor i64 %303, %84
  %305 = lshr i64 %304, 4
  %306 = trunc i64 %305 to i8
  %307 = and i8 %306, 1
  %308 = icmp eq i64 %84, 0
  %309 = zext i1 %308 to i8
  %310 = trunc i64 %85 to i8
  %311 = lshr i64 %81, 63
  %312 = lshr i64 %149, 63
  %313 = xor i64 %312, %311
  %314 = xor i64 %85, %311
  %315 = add nuw nsw i64 %314, %313
  %316 = icmp eq i64 %315, 2
  %317 = zext i1 %316 to i8
  store i8 %296, i8* @CF_2065_37521570, align 1, !tbaa !1295
  store i8 %302, i8* @PF_2067_37521570, align 1, !tbaa !1310
  store i8 %307, i8* @AF_2069_37521570, align 1, !tbaa !1314
  store i8 %309, i8* @ZF_2071_37521570, align 1, !tbaa !1311
  store i8 %310, i8* @SF_2073_37521570, align 1, !tbaa !1312
  store i8 %317, i8* @OF_2077_37521570, align 1, !tbaa !1313
  %318 = add i64 %103, 2
  %319 = add i64 %318, 67
  %320 = icmp eq i8 %309, 0
  %321 = icmp eq i8 %310, 0
  %322 = xor i1 %321, %316
  %323 = and i1 %320, %322
  %324 = select i1 %323, i64 %319, i64 %318
  br i1 %323, label %inst_12f2, label %inst_12af

inst_12f2:                                        ; preds = %inst_12aa
  %325 = add i64 %324, 3
  store i64 %81, i64* @RDX_2264_375215b8, align 8, !tbaa !1293
  %326 = add i64 %325, 3
  store i64 %149, i64* @RSI_2280_375215b8, align 8, !tbaa !1293
  %327 = add i64 %326, 3
  store i64 %160, i64* @RDI_2296_375215b8, align 8, !tbaa !1293
  %328 = add i64 %327, 5
  %329 = load i64, i64* @RSP_2312_375215b8, align 8, !tbaa !1290
  %330 = add i64 %329, -8
  %331 = inttoptr i64 %330 to i64*
  store i64 %328, i64* %331, align 8
  store i64 %330, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  %332 = call %struct.Memory* @sub_1220_quick_sort(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %145)
  br label %inst_12af

inst_12b7:                                        ; preds = %inst_12b2
  %333 = load i64*, i64** @RSP_2312_37528bc0, align 8
  %334 = load i64, i64* @RSP_2312_375215b8, align 8, !tbaa !1290
  %335 = add i64 %334, 8
  %336 = getelementptr i64, i64* %333, i32 1
  %337 = load i64, i64* %333, align 8
  store i64 %337, i64* @RBX_2232_375215b8, align 8, !tbaa !1293
  %338 = add i64 %335, 8
  %339 = getelementptr i64, i64* %336, i32 1
  %340 = load i64, i64* %336, align 8
  store i64 %340, i64* @RBP_2328_375215b8, align 8, !tbaa !1293
  %341 = add i64 %338, 8
  %342 = getelementptr i64, i64* %339, i32 1
  %343 = load i64, i64* %339, align 8
  store i64 %343, i64* @R12_2408_375215b8, align 8, !tbaa !1293
  %344 = add i64 %341, 8
  %345 = load i64, i64* %342, align 8
  store i64 %345, i64* @R13_2424_375215b8, align 8, !tbaa !1293
  %346 = add i64 %344, 8
  %347 = getelementptr i64, i64* %342, i32 1
  %348 = load i64, i64* %347, align 8
  store i64 %348, i64* @R14_2440_375215b8, align 8, !tbaa !1293
  %349 = add i64 %346, 8
  store i64 %349, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  ret %struct.Memory* %108

inst_12d3:                                        ; preds = %inst_12c0
  %350 = mul i64 %241, 4
  store i64 %350, i64* @RAX_2216_375215b8, align 8, !tbaa !1293
  br label %inst_12db

inst_1302:                                        ; preds = %inst_12e8
  %351 = add i64 %103, 2
  %352 = add i64 %351, 21
  %353 = add i64 %352, 3
  store i64 %147, i64* @RDX_2264_375215b8, align 8, !tbaa !1293
  %354 = add i64 %353, 3
  store i64 %87, i64* @RSI_2280_375215b8, align 8, !tbaa !1293
  %355 = add i64 %354, 3
  store i64 %160, i64* @RDI_2296_375215b8, align 8, !tbaa !1293
  %356 = add i64 %355, 5
  %357 = load i64, i64* @RSP_2312_375215b8, align 8, !tbaa !1290
  %358 = add i64 %357, -8
  %359 = inttoptr i64 %358 to i64*
  store i64 %356, i64* %359, align 8
  store i64 %358, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  %360 = call %struct.Memory* @sub_1220_quick_sort(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %145)
  br label %inst_12ed
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1130__start(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1130:
  store i64 0, i64* @RBP_2328_375215b8, align 8, !tbaa !1293
  %0 = load i64, i64* @RDX_2264_375215b8, align 8
  store i64 %0, i64* @R9_2360_375215b8, align 8, !tbaa !1293
  %1 = load i64*, i64** @RSP_2312_37528bc0, align 8
  %2 = load i64, i64* @RSP_2312_375215b8, align 8, !tbaa !1290
  %3 = add i64 %2, 8
  %4 = load i64, i64* %1, align 8
  store i64 %4, i64* @RSI_2280_375215b8, align 8, !tbaa !1293
  store i64 %3, i64* @RDX_2264_375215b8, align 8, !tbaa !1293
  %5 = and i64 -16, %3
  %6 = load i64, i64* @RAX_2216_375215b8, align 8
  %7 = add i64 %5, -8
  %8 = inttoptr i64 %7 to i64*
  store i64 %6, i64* %8, align 8
  %9 = add i64 %7, -8
  %10 = getelementptr i64, i64* %8, i32 -1
  store i64 %7, i64* %10, align 8
  store i64 0, i64* @R8_2344_375215b8, align 8, !tbaa !1293
  store i64 0, i64* @RCX_2248_375215b8, align 8, !tbaa !1293
  store i8 0, i8* @CF_2065_37521570, align 1, !tbaa !1295
  store i8 1, i8* @PF_2067_37521570, align 1, !tbaa !1310
  store i8 1, i8* @ZF_2071_37521570, align 1, !tbaa !1311
  store i8 0, i8* @SF_2073_37521570, align 1, !tbaa !1312
  store i8 0, i8* @OF_2077_37521570, align 1, !tbaa !1313
  store i8 0, i8* @AF_2069_37521570, align 1, !tbaa !1314
  store i32 (i32, i8**, i8**)* @main, i32 (i32, i8**, i8**)** @RDI_2296_3752ffa0, align 8
  %11 = add i64 %9, -8
  %12 = load i64, i64* bitcast (i8** @data_3fd8 to i64*), align 8
  %13 = getelementptr i64, i64* %10, i32 -1
  store i64 ptrtoint (i8** @data_3fd8 to i64), i64* %13, align 8
  store i64 %11, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  store i64 %12, i64* @RIP_2472_375215b8, align 8, !tbaa !1293
  %14 = call %struct.Memory* @__remill_function_call(%struct.State* @__mcsema_reg_state, i64 %12, %struct.Memory* %memory)
  store i8* @data_1155, i8** @RIP_2472_37528a60, align 8
  call void @abort() #13
  unreachable
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1160_deregister_tm_clones(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1160:
  store i8* @data_4010, i8** @RDI_2296_37528a60, align 8
  store i8* @data_4010, i8** @RAX_2216_37528a60, align 8
  store i8 0, i8* @CF_2065_37521570, align 1, !tbaa !1295
  store i8 1, i8* @PF_2067_37521570, align 1, !tbaa !1310
  store i8 0, i8* @AF_2069_37521570, align 1, !tbaa !1314
  store i8 1, i8* @ZF_2071_37521570, align 1, !tbaa !1311
  store i8 0, i8* @SF_2073_37521570, align 1, !tbaa !1312
  store i8 0, i8* @OF_2077_37521570, align 1, !tbaa !1313
  %0 = load i64, i64* @RSP_2312_375215b8, align 8, !tbaa !1290
  %1 = add i64 %0, 8
  store i64 %1, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  ret %struct.Memory* %memory
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1190_register_tm_clones(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1190:
  store i8* @data_4010, i8** @RDI_2296_37528a60, align 8
  store i64 0, i64* @RAX_2216_375215b8, align 8, !tbaa !1293
  store i64 0, i64* @RSI_2280_375215b8, align 8, !tbaa !1293
  store i8 0, i8* @CF_2065_37521570, align 1, !tbaa !1290
  store i8 1, i8* @PF_2067_37521570, align 1, !tbaa !1290
  store i8 0, i8* @AF_2069_37521570, align 1, !tbaa !1290
  store i8 1, i8* @ZF_2071_37521570, align 1, !tbaa !1290
  store i8 0, i8* @SF_2073_37521570, align 1, !tbaa !1290
  store i8 0, i8* @OF_2077_37521570, align 1, !tbaa !1290
  %0 = load i64, i64* @RSP_2312_375215b8, align 8, !tbaa !1290
  %1 = add i64 %0, 8
  store i64 %1, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  ret %struct.Memory* %memory
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1040(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1040:
  %0 = load i64, i64* @RSP_2312_375215b8, align 8, !tbaa !1290
  %1 = add i64 %0, -8
  %2 = inttoptr i64 %1 to i64*
  store i64 1, i64* %2, align 8
  store i64 %1, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  %3 = call %struct.Memory* @sub_1020(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  ret %struct.Memory* %3
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1210_frame_dummy(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1210:
  %0 = call %struct.Memory* @sub_1190_register_tm_clones(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  ret %struct.Memory* %0
}

; Function Attrs: noinline
define internal %struct.Memory* @sub_1314__term_proc(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #10 {
inst_1314:
  %0 = load i64, i64* @RSP_2312_375215b8, align 8
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
  store i8 %11, i8* @CF_2065_37521570, align 1, !tbaa !1295
  %12 = trunc i64 %0 to i32
  %13 = and i32 %12, 255
  %14 = call i32 @llvm.ctpop.i32(i32 %13) #13, !range !1309
  %15 = trunc i32 %14 to i8
  %16 = and i8 %15, 1
  %17 = xor i8 %16, 1
  store i8 %17, i8* @PF_2067_37521570, align 1, !tbaa !1310
  %18 = xor i64 8, %1
  %19 = xor i64 %18, %0
  %20 = lshr i64 %19, 4
  %21 = trunc i64 %20 to i8
  %22 = and i8 %21, 1
  store i8 %22, i8* @AF_2069_37521570, align 1, !tbaa !1314
  %23 = icmp eq i64 %0, 0
  %24 = zext i1 %23 to i8
  store i8 %24, i8* @ZF_2071_37521570, align 1, !tbaa !1311
  %25 = trunc i64 %4 to i8
  store i8 %25, i8* @SF_2073_37521570, align 1, !tbaa !1312
  store i8 %8, i8* @OF_2077_37521570, align 1, !tbaa !1313
  %26 = add i64 %0, 8
  store i64 %26, i64* @RSP_2312_375215b8, align 8, !tbaa !1293
  ret %struct.Memory* %memory
}

; Function Attrs: nobuiltin noinline
declare !remill.function.type !1317 extern_weak x86_64_sysvcc i64 @_ITM_deregisterTMCloneTable(i64) #11

; Function Attrs: noinline
declare !remill.function.type !1317 extern_weak i64 @__printf_chk(...) #12

; Function Attrs: noinline
declare !remill.function.type !1317 extern_weak x86_64_sysvcc void @__libc_start_main(i32 (i32, i8**, i8**)*, i32, i8**, i8*, i32 (i32, i8**, i8**)*, void ()*, void ()*, i32*) #12

; Function Attrs: noinline
define internal %struct.Memory* @ext_1070____printf_chk(%struct.State* %0, i64 %1, %struct.Memory* %2) #12 {
  %4 = call %struct.Memory* @__remill_function_call(%struct.State* @__mcsema_reg_state, i64 ptrtoint (i64 (...)* @.__printf_chk to i64), %struct.Memory* %2)
  ret %struct.Memory* %4
}

; Function Attrs: noinline
declare !remill.function.type !1318 i64 @.__printf_chk(...) #12

; Function Attrs: noinline
define internal %struct.Memory* @ext_1060____stack_chk_fail(%struct.State* %0, i64 %1, %struct.Memory* %2) #12 {
  %4 = call %struct.Memory* @__remill_function_call(%struct.State* @__mcsema_reg_state, i64 ptrtoint (i64 (...)* @.__stack_chk_fail to i64), %struct.Memory* %2)
  ret %struct.Memory* %4
}

; Function Attrs: noinline
declare !remill.function.type !1318 i64 @.__stack_chk_fail(...) #12

; Function Attrs: nobuiltin noinline
declare !remill.function.type !1317 extern_weak x86_64_sysvcc i64 @__stack_chk_fail() #11

; Function Attrs: nobuiltin noinline
declare !remill.function.type !1318 extern_weak x86_64_sysvcc i64 @__cxa_finalize(i64) #11

; Function Attrs: noinline
define internal %struct.Memory* @ext_1050___cxa_finalize(%struct.State* %0, i64 %1, %struct.Memory* %2) #12 {
  %4 = call %struct.Memory* @__remill_function_call(%struct.State* @__mcsema_reg_state, i64 ptrtoint (i64 (i64)* @__cxa_finalize to i64), %struct.Memory* %2)
  ret %struct.Memory* %4
}

; Function Attrs: nobuiltin noinline
declare !remill.function.type !1317 extern_weak x86_64_sysvcc i64 @_ITM_registerTMCloneTable(i64, i64) #11

; Function Attrs: noinline
define weak x86_64_sysvcc void @__gmon_start__() #12 !remill.function.type !1317 {
  ret void
}

; Function Attrs: naked nobuiltin noinline
define dllexport x86_64_sysvcc i32 @main(i32 %param0, i8** %param1, i8** %param2) #8 !remill.function.type !1318 {
  call void asm sideeffect "pushq $0;pushq $$0x1080;jmpq *$1;", "*m,*m,~{dirflag},~{fpsr},~{flags}"(%struct.Memory* (%struct.State*, i64, %struct.Memory*)** elementtype(%struct.Memory* (%struct.State*, i64, %struct.Memory*)*) @1, void ()** elementtype(void ()*) @2)
  ret i32 undef
}

; Function Attrs: noinline
declare !remill.function.type !1319 void @__mcsema_attach_call() #12

define internal %struct.Memory* @main_wrapper(%struct.State* %0, i64 %1, %struct.Memory* %2) {
  call void @__mcsema_early_init()
  %4 = tail call %struct.Memory* @sub_1080_main(%struct.State* @__mcsema_reg_state, i64 %1, %struct.Memory* %2)
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
  %4 = tail call %struct.Memory* @sub_1210_frame_dummy(%struct.State* @__mcsema_reg_state, i64 %1, %struct.Memory* %2)
  ret %struct.Memory* %4
}

define internal %struct.Memory* @__do_global_dtors_aux_wrapper(%struct.State* %0, i64 %1, %struct.Memory* %2) {
  call void @__mcsema_early_init()
  %4 = tail call %struct.Memory* @sub_11d0___do_global_dtors_aux(%struct.State* @__mcsema_reg_state, i64 %1, %struct.Memory* %2)
  ret %struct.Memory* %4
}

define internal %struct.Memory* @_start_wrapper(%struct.State* %0, i64 %1, %struct.Memory* %2) {
  call void @__mcsema_early_init()
  %4 = tail call %struct.Memory* @sub_1130__start(%struct.State* @__mcsema_reg_state, i64 %1, %struct.Memory* %2)
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
!1291 = !{!"omnipotent char", !1292, i64 0}
!1292 = !{!"Simple C++ TBAA"}
!1293 = !{!1294, !1294, i64 0}
!1294 = !{!"long", !1291, i64 0}
!1295 = !{!1296, !1291, i64 2065}
!1296 = !{!"_ZTS5State", !1291, i64 16, !1297, i64 2064, !1291, i64 2080, !1298, i64 2088, !1300, i64 2112, !1302, i64 2208, !1303, i64 2480, !1304, i64 2608, !1305, i64 2736, !1291, i64 2760, !1291, i64 2768, !1306, i64 3280}
!1297 = !{!"_ZTS10ArithFlags", !1291, i64 0, !1291, i64 1, !1291, i64 2, !1291, i64 3, !1291, i64 4, !1291, i64 5, !1291, i64 6, !1291, i64 7, !1291, i64 8, !1291, i64 9, !1291, i64 10, !1291, i64 11, !1291, i64 12, !1291, i64 13, !1291, i64 14, !1291, i64 15}
!1298 = !{!"_ZTS8Segments", !1299, i64 0, !1291, i64 2, !1299, i64 4, !1291, i64 6, !1299, i64 8, !1291, i64 10, !1299, i64 12, !1291, i64 14, !1299, i64 16, !1291, i64 18, !1299, i64 20, !1291, i64 22}
!1299 = !{!"short", !1291, i64 0}
!1300 = !{!"_ZTS12AddressSpace", !1294, i64 0, !1301, i64 8, !1294, i64 16, !1301, i64 24, !1294, i64 32, !1301, i64 40, !1294, i64 48, !1301, i64 56, !1294, i64 64, !1301, i64 72, !1294, i64 80, !1301, i64 88}
!1301 = !{!"_ZTS3Reg", !1291, i64 0}
!1302 = !{!"_ZTS3GPR", !1294, i64 0, !1301, i64 8, !1294, i64 16, !1301, i64 24, !1294, i64 32, !1301, i64 40, !1294, i64 48, !1301, i64 56, !1294, i64 64, !1301, i64 72, !1294, i64 80, !1301, i64 88, !1294, i64 96, !1301, i64 104, !1294, i64 112, !1301, i64 120, !1294, i64 128, !1301, i64 136, !1294, i64 144, !1301, i64 152, !1294, i64 160, !1301, i64 168, !1294, i64 176, !1301, i64 184, !1294, i64 192, !1301, i64 200, !1294, i64 208, !1301, i64 216, !1294, i64 224, !1301, i64 232, !1294, i64 240, !1301, i64 248, !1294, i64 256, !1301, i64 264}
!1303 = !{!"_ZTS8X87Stack", !1291, i64 0}
!1304 = !{!"_ZTS3MMX", !1291, i64 0}
!1305 = !{!"_ZTS14FPUStatusFlags", !1291, i64 0, !1291, i64 1, !1291, i64 2, !1291, i64 3, !1291, i64 4, !1291, i64 5, !1291, i64 6, !1291, i64 7, !1291, i64 8, !1291, i64 9, !1291, i64 10, !1291, i64 11, !1291, i64 12, !1291, i64 13, !1291, i64 14, !1291, i64 15, !1291, i64 16, !1291, i64 17, !1291, i64 18, !1291, i64 19, !1291, i64 20}
!1306 = !{!"_ZTS13SegmentCaches", !1307, i64 0, !1307, i64 16, !1307, i64 32, !1307, i64 48, !1307, i64 64, !1307, i64 80}
!1307 = !{!"_ZTS13SegmentShadow", !1291, i64 0, !1308, i64 8, !1308, i64 12}
!1308 = !{!"int", !1291, i64 0}
!1309 = !{i32 0, i32 9}
!1310 = !{!1296, !1291, i64 2067}
!1311 = !{!1296, !1291, i64 2071}
!1312 = !{!1296, !1291, i64 2073}
!1313 = !{!1296, !1291, i64 2077}
!1314 = !{!1296, !1291, i64 2069}
!1315 = !{!1316, !1316, i64 0}
!1316 = !{!"__int128", !1291, i64 0}
!1317 = !{!"base.external.cfgexternal"}
!1318 = !{!"base.entrypoint"}
!1319 = !{!"base.helper.mcsema"}
