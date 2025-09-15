; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/mcsema/ll/O0/dijkstra_modular_function3.ll'
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
%struct.Memory = type opaque

@__mcsema_reg_state = external thread_local(initialexec) global %struct.State
@data_4012f6 = external global i8
@data_4012b8 = external global i8
@data_401272 = external global i8
@data_40200a = external global i8
@data_402004 = external global i8
@data_40125d = external global i8
@data_402007 = external global i8
@RSP_2312_4145c678 = external global i64
@OF_2077_4145c630 = external global i8
@SF_2073_4145c630 = external global i8
@ZF_2071_4145c630 = external global i8
@AF_2069_4145c630 = external global i8
@PF_2067_4145c630 = external global i8
@CF_2065_4145c630 = external global i8
@RAX_2216_4145c678 = external global i64
@RSP_2312_41463c00 = external global i64*
@RCX_2248_4145c678 = external global i64
@RDI_2296_4145c678 = external global i64
@RBP_2328_4145c678 = external global i64
@RDX_2264_4145c678 = external global i64
@RSI_2280_4145c678 = external global i64
@RAX_2216_4145c660 = external global i32
@RAX_2216_4145c630 = external global i8
@R8_2344_4145c678 = external global i64
@RDI_2296_41463aa0 = external global i8*

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare !remill.function.type !4 i32 @llvm.ctpop.i32(i32) #0

; Function Attrs: noinline
declare hidden %struct.Memory* @sub_401130_init_graph(%struct.State* noalias nonnull, i64, %struct.Memory* noalias) #1

; Function Attrs: noinline
declare hidden %struct.Memory* @sub_4011b0_add_edge(%struct.State* noalias nonnull, i64, %struct.Memory* noalias) #1

; Function Attrs: noinline
define hidden %struct.Memory* @sub_401230_read_graph(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #1 {
inst_401230:
  %0 = load i64, i64* @RBP_2328_4145c678, align 8
  %1 = load i64, i64* @RSP_2312_4145c678, align 8, !tbaa !5
  %2 = add i64 %1, -8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3, align 8
  store i64 %2, i64* @RBP_2328_4145c678, align 8, !tbaa !8
  %4 = add i64 %1, -72
  %5 = inttoptr i64 %4 to i64*
  %6 = icmp ult i64 %2, 64
  %7 = zext i1 %6 to i8
  store i8 %7, i8* @CF_2065_4145c630, align 1, !tbaa !10
  %8 = trunc i64 %4 to i32
  %9 = and i32 %8, 255
  %10 = call i32 @llvm.ctpop.i32(i32 %9) #3, !range !24
  %11 = trunc i32 %10 to i8
  %12 = and i8 %11, 1
  %13 = xor i8 %12, 1
  store i8 %13, i8* @PF_2067_4145c630, align 1, !tbaa !25
  %14 = xor i64 %2, %4
  %15 = trunc i64 %14 to i8
  %16 = lshr i8 %15, 4
  %17 = and i8 %16, 1
  store i8 %17, i8* @AF_2069_4145c630, align 1, !tbaa !26
  %18 = icmp eq i64 %4, 0
  %19 = zext i1 %18 to i8
  store i8 %19, i8* @ZF_2071_4145c630, align 1, !tbaa !27
  %20 = lshr i64 %4, 63
  %21 = trunc i64 %20 to i8
  store i8 %21, i8* @SF_2073_4145c630, align 1, !tbaa !28
  %22 = lshr i64 %2, 63
  %23 = xor i64 %20, %22
  %24 = add nuw nsw i64 %23, %22
  %25 = icmp eq i64 %24, 2
  %26 = zext i1 %25 to i8
  store i8 %26, i8* @OF_2077_4145c630, align 1, !tbaa !29
  %27 = add i64 %1, -24
  %28 = load i64, i64* @RDI_2296_4145c678, align 8
  %29 = inttoptr i64 %27 to i64*
  store i64 %28, i64* %29, align 8
  %30 = add i64 %1, -32
  %31 = load i64, i64* @RSI_2280_4145c678, align 8
  %32 = inttoptr i64 %30 to i64*
  store i64 %31, i64* %32, align 8
  %33 = add i64 %1, -40
  %34 = load i64, i64* @RDX_2264_4145c678, align 8
  %35 = inttoptr i64 %33 to i64*
  store i64 %34, i64* %35, align 8
  %36 = load i64, i64* %32, align 8
  store i64 %36, i64* @RSI_2280_4145c678, align 8, !tbaa !8
  store i8* @data_402007, i8** @RDI_2296_41463aa0, align 8
  %37 = add i64 %1, -44
  store i64 %37, i64* @RDX_2264_4145c678, align 8, !tbaa !8
  store i8 0, i8* @RAX_2216_4145c630, align 1, !tbaa !5
  %38 = add i64 %1, -80
  %39 = getelementptr i64, i64* %5, i64 -1
  store i64 ptrtoint (i8* @data_40125d to i64), i64* %39, align 8
  store i64 %38, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  %40 = call %struct.Memory* @ext_404078___isoc99_scanf(%struct.State* nonnull @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  %41 = load i32, i32* @RAX_2216_4145c660, align 4
  %42 = icmp eq i32 %41, 2
  %43 = load i64, i64* @RBP_2328_4145c678, align 8
  br i1 %42, label %inst_401272, label %inst_401266

inst_401296:                                      ; preds = %inst_40128c, %inst_40127f, %inst_401272
  %44 = add i64 %43, -4
  %45 = inttoptr i64 %44 to i32*
  store i32 -1, i32* %45, align 4
  br label %inst_4013b6

inst_4013a3:                                      ; preds = %inst_401391, %inst_401384
  %46 = add i64 %171, -4
  %47 = inttoptr i64 %46 to i32*
  store i32 -1, i32* %47, align 4
  br label %inst_4013b6

inst_401328:                                      ; preds = %inst_401319, %inst_40130f, %inst_401300, %inst_4012f6
  %48 = add i64 %182, -4
  %49 = inttoptr i64 %48 to i32*
  store i32 -1, i32* %49, align 4
  br label %inst_4013b6

inst_4013b6:                                      ; preds = %inst_4013af, %inst_401378, %inst_4012ea, %inst_401266, %inst_401328, %inst_4013a3, %inst_401296
  %50 = phi %struct.Memory* [ %40, %inst_401296 ], [ %168, %inst_4013a3 ], [ %168, %inst_4013af ], [ %168, %inst_401378 ], [ %179, %inst_401328 ], [ %179, %inst_4012ea ], [ %40, %inst_401266 ]
  %51 = load i64, i64* @RBP_2328_4145c678, align 8
  %52 = add i64 %51, -4
  %53 = inttoptr i64 %52 to i32*
  %54 = load i32, i32* %53, align 4
  %55 = zext i32 %54 to i64
  store i64 %55, i64* @RAX_2216_4145c678, align 8, !tbaa !8
  %56 = load i64*, i64** @RSP_2312_41463c00, align 8
  %57 = load i64, i64* @RSP_2312_4145c678, align 8
  %58 = add i64 %57, 64
  %59 = icmp ugt i64 %57, -65
  %60 = zext i1 %59 to i8
  store i8 %60, i8* @CF_2065_4145c630, align 1, !tbaa !10
  %61 = trunc i64 %58 to i32
  %62 = and i32 %61, 255
  %63 = call i32 @llvm.ctpop.i32(i32 %62) #3, !range !24
  %64 = trunc i32 %63 to i8
  %65 = and i8 %64, 1
  %66 = xor i8 %65, 1
  store i8 %66, i8* @PF_2067_4145c630, align 1, !tbaa !25
  %67 = xor i64 %57, %58
  %68 = trunc i64 %67 to i8
  %69 = lshr i8 %68, 4
  %70 = and i8 %69, 1
  store i8 %70, i8* @AF_2069_4145c630, align 1, !tbaa !26
  %71 = icmp eq i64 %58, 0
  %72 = zext i1 %71 to i8
  store i8 %72, i8* @ZF_2071_4145c630, align 1, !tbaa !27
  %73 = lshr i64 %58, 63
  %74 = trunc i64 %73 to i8
  store i8 %74, i8* @SF_2073_4145c630, align 1, !tbaa !28
  %75 = lshr i64 %57, 63
  %76 = xor i64 %73, %75
  %77 = add nuw nsw i64 %76, %73
  %78 = icmp eq i64 %77, 2
  %79 = zext i1 %78 to i8
  store i8 %79, i8* @OF_2077_4145c630, align 1, !tbaa !29
  %80 = getelementptr i64, i64* %56, i64 8
  %81 = load i64, i64* %80, align 8
  store i64 %81, i64* @RBP_2328_4145c678, align 8, !tbaa !8
  %82 = add i64 %57, 80
  store i64 %82, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  ret %struct.Memory* %50

inst_4012b8:                                      ; preds = %inst_401334, %inst_4012a2
  %83 = phi %struct.Memory* [ %157, %inst_4012a2 ], [ %243, %inst_401334 ]
  %84 = load i64, i64* @RBP_2328_4145c678, align 8
  %85 = add i64 %84, -40
  %86 = inttoptr i64 %85 to i32*
  %87 = load i32, i32* %86, align 4
  %88 = zext i32 %87 to i64
  store i64 %88, i64* @RAX_2216_4145c678, align 8, !tbaa !8
  %89 = add i64 %84, -36
  %90 = inttoptr i64 %89 to i32*
  %91 = load i32, i32* %90, align 4
  %92 = sub i32 %87, %91
  %93 = icmp ult i32 %87, %91
  %94 = zext i1 %93 to i8
  store i8 %94, i8* @CF_2065_4145c630, align 1, !tbaa !10
  %95 = and i32 %92, 255
  %96 = call i32 @llvm.ctpop.i32(i32 %95) #3, !range !24
  %97 = trunc i32 %96 to i8
  %98 = and i8 %97, 1
  %99 = xor i8 %98, 1
  store i8 %99, i8* @PF_2067_4145c630, align 1, !tbaa !25
  %100 = xor i32 %91, %87
  %101 = xor i32 %100, %92
  %102 = trunc i32 %101 to i8
  %103 = lshr i8 %102, 4
  %104 = and i8 %103, 1
  store i8 %104, i8* @AF_2069_4145c630, align 1, !tbaa !26
  %105 = icmp eq i32 %92, 0
  %106 = zext i1 %105 to i8
  store i8 %106, i8* @ZF_2071_4145c630, align 1, !tbaa !27
  %107 = lshr i32 %92, 31
  %108 = trunc i32 %107 to i8
  store i8 %108, i8* @SF_2073_4145c630, align 1, !tbaa !28
  %109 = lshr i32 %87, 31
  %110 = lshr i32 %91, 31
  %111 = xor i32 %110, %109
  %112 = xor i32 %107, %109
  %113 = add nuw nsw i32 %112, %111
  %114 = icmp eq i32 %113, 2
  %115 = zext i1 %114 to i8
  store i8 %115, i8* @OF_2077_4145c630, align 1, !tbaa !29
  %116 = icmp sgt i32 %92, -1
  %117 = xor i1 %116, %114
  %118 = select i1 %117, i64 add (i64 ptrtoint (i8* @data_4012b8 to i64), i64 162), i64 add (i64 ptrtoint (i8* @data_4012b8 to i64), i64 12)
  br i1 %117, label %inst_40135a, label %inst_4012c4

inst_401272:                                      ; preds = %inst_401230
  %119 = add i64 %43, -24
  %120 = inttoptr i64 %119 to i64*
  %121 = load i64, i64* %120, align 8
  %122 = inttoptr i64 %121 to i32*
  %123 = load i32, i32* %122, align 4
  %124 = lshr i32 %123, 31
  %125 = icmp slt i32 %123, 1
  br i1 %125, label %inst_401296, label %inst_40127f

inst_401266:                                      ; preds = %inst_401230
  %126 = add i64 %43, -4
  %127 = inttoptr i64 %126 to i32*
  store i32 -1, i32* %127, align 4
  br label %inst_4013b6

inst_40127f:                                      ; preds = %inst_401272
  %128 = add i32 %123, -100
  %129 = icmp ne i32 %128, 0
  %130 = lshr i32 %128, 31
  %131 = xor i32 %130, %124
  %132 = add nuw nsw i32 %131, %124
  %133 = icmp eq i32 %132, 2
  %134 = icmp sgt i32 %128, -1
  %135 = xor i1 %134, %133
  %136 = and i1 %129, %135
  br i1 %136, label %inst_401296, label %inst_40128c

inst_40128c:                                      ; preds = %inst_40127f
  %137 = add i64 %43, -36
  %138 = inttoptr i64 %137 to i32*
  %139 = load i32, i32* %138, align 4
  store i8 0, i8* @CF_2065_4145c630, align 1, !tbaa !10
  %140 = and i32 %139, 255
  %141 = call i32 @llvm.ctpop.i32(i32 %140) #3, !range !24
  %142 = trunc i32 %141 to i8
  %143 = and i8 %142, 1
  %144 = xor i8 %143, 1
  store i8 %144, i8* @PF_2067_4145c630, align 1, !tbaa !25
  store i8 0, i8* @AF_2069_4145c630, align 1, !tbaa !26
  %145 = icmp eq i32 %139, 0
  %146 = zext i1 %145 to i8
  store i8 %146, i8* @ZF_2071_4145c630, align 1, !tbaa !27
  %147 = lshr i32 %139, 31
  %148 = trunc i32 %147 to i8
  store i8 %148, i8* @SF_2073_4145c630, align 1, !tbaa !28
  store i8 0, i8* @OF_2077_4145c630, align 1, !tbaa !29
  %149 = icmp sgt i32 %139, -1
  br i1 %149, label %inst_4012a2, label %inst_401296

inst_4012a2:                                      ; preds = %inst_40128c
  %150 = add i64 %43, -16
  %151 = inttoptr i64 %150 to i64*
  %152 = load i64, i64* %151, align 8
  store i64 %152, i64* @RDI_2296_4145c678, align 8, !tbaa !8
  store i64 %121, i64* @RAX_2216_4145c678, align 8, !tbaa !8
  %153 = zext i32 %123 to i64
  store i64 %153, i64* @RSI_2280_4145c678, align 8, !tbaa !8
  %154 = load i64, i64* @RSP_2312_4145c678, align 8, !tbaa !5
  %155 = add i64 %154, -8
  %156 = inttoptr i64 %155 to i64*
  store i64 add (i64 ptrtoint (i8* @data_401272 to i64), i64 63), i64* %156, align 8
  store i64 %155, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  %157 = call %struct.Memory* @sub_401130_init_graph(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %40)
  %158 = load i64, i64* @RBP_2328_4145c678, align 8
  %159 = add i64 %158, -40
  %160 = inttoptr i64 %159 to i32*
  store i32 0, i32* %160, align 4
  br label %inst_4012b8

inst_40135a:                                      ; preds = %inst_4012b8
  %161 = add i64 %84, -32
  %162 = inttoptr i64 %161 to i64*
  %163 = load i64, i64* %162, align 8
  store i64 %163, i64* @RSI_2280_4145c678, align 8, !tbaa !8
  store i8* @data_40200a, i8** @RDI_2296_41463aa0, align 8
  store i8 0, i8* @RAX_2216_4145c630, align 1, !tbaa !5
  %164 = add i64 %118, 21
  %165 = load i64, i64* @RSP_2312_4145c678, align 8, !tbaa !5
  %166 = add i64 %165, -8
  %167 = inttoptr i64 %166 to i64*
  store i64 %164, i64* %167, align 8
  store i64 %166, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  %168 = call %struct.Memory* @ext_404078___isoc99_scanf(%struct.State* nonnull @__mcsema_reg_state, i64 undef, %struct.Memory* %83)
  %169 = load i32, i32* @RAX_2216_4145c660, align 4
  %170 = icmp eq i32 %169, 1
  %171 = load i64, i64* @RBP_2328_4145c678, align 8
  br i1 %170, label %inst_401384, label %inst_401378

inst_4012c4:                                      ; preds = %inst_4012b8
  store i8* @data_402004, i8** @RDI_2296_41463aa0, align 8
  %172 = add i64 %84, -44
  store i64 %172, i64* @RSI_2280_4145c678, align 8, !tbaa !8
  %173 = add i64 %84, -48
  store i64 %173, i64* @RDX_2264_4145c678, align 8, !tbaa !8
  %174 = add i64 %84, -52
  store i64 %174, i64* @RCX_2248_4145c678, align 8, !tbaa !8
  store i8 0, i8* @RAX_2216_4145c630, align 1, !tbaa !5
  %175 = add i64 %118, 29
  %176 = load i64, i64* @RSP_2312_4145c678, align 8, !tbaa !5
  %177 = add i64 %176, -8
  %178 = inttoptr i64 %177 to i64*
  store i64 %175, i64* %178, align 8
  store i64 %177, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  %179 = call %struct.Memory* @ext_404078___isoc99_scanf(%struct.State* nonnull @__mcsema_reg_state, i64 undef, %struct.Memory* %83)
  %180 = load i32, i32* @RAX_2216_4145c660, align 4
  %181 = icmp eq i32 %180, 3
  %182 = load i64, i64* @RBP_2328_4145c678, align 8
  br i1 %181, label %inst_4012f6, label %inst_4012ea

inst_4012f6:                                      ; preds = %inst_4012c4
  %183 = add i64 %182, -44
  %184 = inttoptr i64 %183 to i32*
  %185 = load i32, i32* %184, align 4
  %186 = lshr i32 %185, 31
  %.not = icmp sgt i32 %185, -1
  br i1 %.not, label %inst_401300, label %inst_401328

inst_4012ea:                                      ; preds = %inst_4012c4
  %187 = add i64 %182, -4
  %188 = inttoptr i64 %187 to i32*
  store i32 -1, i32* %188, align 4
  br label %inst_4013b6

inst_401300:                                      ; preds = %inst_4012f6
  %189 = add i64 %182, -24
  %190 = inttoptr i64 %189 to i64*
  %191 = load i64, i64* %190, align 8
  store i64 %191, i64* @RCX_2248_4145c678, align 8, !tbaa !8
  %192 = inttoptr i64 %191 to i32*
  %193 = load i32, i32* %192, align 4
  %194 = sub i32 %185, %193
  %195 = lshr i32 %194, 31
  %196 = lshr i32 %193, 31
  %197 = xor i32 %196, %186
  %198 = xor i32 %195, %186
  %199 = add nuw nsw i32 %198, %197
  %200 = icmp eq i32 %199, 2
  %201 = icmp sgt i32 %194, -1
  %202 = xor i1 %201, %200
  br i1 %202, label %inst_401328, label %inst_40130f

inst_40130f:                                      ; preds = %inst_401300
  %203 = add i64 %182, -48
  %204 = inttoptr i64 %203 to i32*
  %205 = load i32, i32* %204, align 4
  %206 = lshr i32 %205, 31
  %.not1 = icmp sgt i32 %205, -1
  br i1 %.not1, label %inst_401319, label %inst_401328

inst_401319:                                      ; preds = %inst_40130f
  %207 = zext i32 %205 to i64
  store i64 %207, i64* @RAX_2216_4145c678, align 8, !tbaa !8
  store i64 %191, i64* @RCX_2248_4145c678, align 8, !tbaa !8
  %208 = sub i32 %205, %193
  %209 = icmp ult i32 %205, %193
  %210 = zext i1 %209 to i8
  store i8 %210, i8* @CF_2065_4145c630, align 1, !tbaa !10
  %211 = and i32 %208, 255
  %212 = call i32 @llvm.ctpop.i32(i32 %211) #3, !range !24
  %213 = trunc i32 %212 to i8
  %214 = and i8 %213, 1
  %215 = xor i8 %214, 1
  store i8 %215, i8* @PF_2067_4145c630, align 1, !tbaa !25
  %216 = xor i32 %193, %205
  %217 = xor i32 %216, %208
  %218 = trunc i32 %217 to i8
  %219 = lshr i8 %218, 4
  %220 = and i8 %219, 1
  store i8 %220, i8* @AF_2069_4145c630, align 1, !tbaa !26
  %221 = icmp eq i32 %208, 0
  %222 = zext i1 %221 to i8
  store i8 %222, i8* @ZF_2071_4145c630, align 1, !tbaa !27
  %223 = lshr i32 %208, 31
  %224 = trunc i32 %223 to i8
  store i8 %224, i8* @SF_2073_4145c630, align 1, !tbaa !28
  %225 = xor i32 %196, %206
  %226 = xor i32 %223, %206
  %227 = add nuw nsw i32 %226, %225
  %228 = icmp eq i32 %227, 2
  %229 = zext i1 %228 to i8
  store i8 %229, i8* @OF_2077_4145c630, align 1, !tbaa !29
  %230 = icmp slt i32 %208, 0
  %231 = xor i1 %230, %228
  br i1 %231, label %inst_401334, label %inst_401328

inst_401334:                                      ; preds = %inst_401319
  %232 = zext i32 %185 to i64
  %233 = add i64 %182, -16
  %234 = inttoptr i64 %233 to i64*
  %235 = load i64, i64* %234, align 8
  store i64 %235, i64* @RDI_2296_4145c678, align 8, !tbaa !8
  store i64 %232, i64* @RSI_2280_4145c678, align 8, !tbaa !8
  store i64 %207, i64* @RDX_2264_4145c678, align 8, !tbaa !8
  %236 = add i64 %182, -52
  %237 = inttoptr i64 %236 to i32*
  %238 = load i32, i32* %237, align 4
  %239 = zext i32 %238 to i64
  store i64 %239, i64* @RCX_2248_4145c678, align 8, !tbaa !8
  store i64 1, i64* @R8_2344_4145c678, align 8, !tbaa !8
  %240 = load i64, i64* @RSP_2312_4145c678, align 8, !tbaa !5
  %241 = add i64 %240, -8
  %242 = inttoptr i64 %241 to i64*
  store i64 add (i64 ptrtoint (i8* @data_4012f6 to i64), i64 86), i64* %242, align 8
  store i64 %241, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  %243 = call %struct.Memory* @sub_4011b0_add_edge(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %179)
  %244 = load i64, i64* @RBP_2328_4145c678, align 8
  %245 = add i64 %244, -40
  %246 = inttoptr i64 %245 to i32*
  %247 = load i32, i32* %246, align 4
  %248 = add i32 %247, 1
  store i32 %248, i32* %246, align 4
  br label %inst_4012b8

inst_401384:                                      ; preds = %inst_40135a
  %249 = add i64 %171, -32
  %250 = inttoptr i64 %249 to i64*
  %251 = load i64, i64* %250, align 8
  %252 = inttoptr i64 %251 to i32*
  %253 = load i32, i32* %252, align 4
  %254 = lshr i32 %253, 31
  %.not2 = icmp sgt i32 %253, -1
  br i1 %.not2, label %inst_401391, label %inst_4013a3

inst_401378:                                      ; preds = %inst_40135a
  %255 = add i64 %171, -4
  %256 = inttoptr i64 %255 to i32*
  store i32 -1, i32* %256, align 4
  br label %inst_4013b6

inst_401391:                                      ; preds = %inst_401384
  %257 = add i64 %171, -24
  %258 = inttoptr i64 %257 to i64*
  %259 = load i64, i64* %258, align 8
  store i64 %259, i64* @RCX_2248_4145c678, align 8, !tbaa !8
  %260 = inttoptr i64 %259 to i32*
  %261 = load i32, i32* %260, align 4
  %262 = sub i32 %253, %261
  %263 = lshr i32 %262, 31
  %264 = lshr i32 %261, 31
  %265 = xor i32 %264, %254
  %266 = xor i32 %263, %254
  %267 = add nuw nsw i32 %266, %265
  %268 = icmp eq i32 %267, 2
  %269 = icmp slt i32 %262, 0
  %270 = xor i1 %269, %268
  br i1 %270, label %inst_4013af, label %inst_4013a3

inst_4013af:                                      ; preds = %inst_401391
  %271 = add i64 %171, -4
  %272 = inttoptr i64 %271 to i32*
  store i32 0, i32* %272, align 4
  br label %inst_4013b6
}

; Function Attrs: noinline
declare hidden %struct.Memory* @ext_404078___isoc99_scanf(%struct.State*, i64, %struct.Memory*) #2

attributes #0 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #1 = { noinline "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { noinline }
attributes #3 = { nounwind }

!llvm.ident = !{!0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}
!llvm.dbg.cu = !{}

!0 = !{!"clang version 9.0.1 (https://github.com/trailofbits/vcpkg.git 4592a93cc4ca82f1963dba08413c43639662d7ae)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 2, !"Dwarf Version", i32 4}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{!"base.helper.semantics"}
!5 = !{!6, !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C++ TBAA"}
!8 = !{!9, !9, i64 0}
!9 = !{!"long", !6, i64 0}
!10 = !{!11, !6, i64 2065}
!11 = !{!"_ZTS5State", !6, i64 16, !12, i64 2064, !6, i64 2080, !13, i64 2088, !15, i64 2112, !17, i64 2208, !18, i64 2480, !19, i64 2608, !20, i64 2736, !6, i64 2760, !6, i64 2768, !21, i64 3280}
!12 = !{!"_ZTS10ArithFlags", !6, i64 0, !6, i64 1, !6, i64 2, !6, i64 3, !6, i64 4, !6, i64 5, !6, i64 6, !6, i64 7, !6, i64 8, !6, i64 9, !6, i64 10, !6, i64 11, !6, i64 12, !6, i64 13, !6, i64 14, !6, i64 15}
!13 = !{!"_ZTS8Segments", !14, i64 0, !6, i64 2, !14, i64 4, !6, i64 6, !14, i64 8, !6, i64 10, !14, i64 12, !6, i64 14, !14, i64 16, !6, i64 18, !14, i64 20, !6, i64 22}
!14 = !{!"short", !6, i64 0}
!15 = !{!"_ZTS12AddressSpace", !9, i64 0, !16, i64 8, !9, i64 16, !16, i64 24, !9, i64 32, !16, i64 40, !9, i64 48, !16, i64 56, !9, i64 64, !16, i64 72, !9, i64 80, !16, i64 88}
!16 = !{!"_ZTS3Reg", !6, i64 0}
!17 = !{!"_ZTS3GPR", !9, i64 0, !16, i64 8, !9, i64 16, !16, i64 24, !9, i64 32, !16, i64 40, !9, i64 48, !16, i64 56, !9, i64 64, !16, i64 72, !9, i64 80, !16, i64 88, !9, i64 96, !16, i64 104, !9, i64 112, !16, i64 120, !9, i64 128, !16, i64 136, !9, i64 144, !16, i64 152, !9, i64 160, !16, i64 168, !9, i64 176, !16, i64 184, !9, i64 192, !16, i64 200, !9, i64 208, !16, i64 216, !9, i64 224, !16, i64 232, !9, i64 240, !16, i64 248, !9, i64 256, !16, i64 264}
!18 = !{!"_ZTS8X87Stack", !6, i64 0}
!19 = !{!"_ZTS3MMX", !6, i64 0}
!20 = !{!"_ZTS14FPUStatusFlags", !6, i64 0, !6, i64 1, !6, i64 2, !6, i64 3, !6, i64 4, !6, i64 5, !6, i64 6, !6, i64 7, !6, i64 8, !6, i64 9, !6, i64 10, !6, i64 11, !6, i64 12, !6, i64 13, !6, i64 14, !6, i64 15, !6, i64 16, !6, i64 17, !6, i64 18, !6, i64 19, !6, i64 20}
!21 = !{!"_ZTS13SegmentCaches", !22, i64 0, !22, i64 16, !22, i64 32, !22, i64 48, !22, i64 64, !22, i64 80}
!22 = !{!"_ZTS13SegmentShadow", !6, i64 0, !23, i64 8, !23, i64 12}
!23 = !{!"int", !6, i64 0}
!24 = !{i32 0, i32 9}
!25 = !{!11, !6, i64 2067}
!26 = !{!11, !6, i64 2069}
!27 = !{!11, !6, i64 2071}
!28 = !{!11, !6, i64 2073}
!29 = !{!11, !6, i64 2077}
