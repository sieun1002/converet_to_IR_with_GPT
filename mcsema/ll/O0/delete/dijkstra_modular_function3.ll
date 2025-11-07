; ModuleID = 'dijkstra_modular.ll'
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
  %4 = sub i64 %2, 64
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
  %14 = xor i64 64, %2
  %15 = xor i64 %14, %4
  %16 = lshr i64 %15, 4
  %17 = trunc i64 %16 to i8
  %18 = and i8 %17, 1
  store i8 %18, i8* @AF_2069_4145c630, align 1, !tbaa !26
  %19 = icmp eq i64 %4, 0
  %20 = zext i1 %19 to i8
  store i8 %20, i8* @ZF_2071_4145c630, align 1, !tbaa !27
  %21 = lshr i64 %4, 63
  %22 = trunc i64 %21 to i8
  store i8 %22, i8* @SF_2073_4145c630, align 1, !tbaa !28
  %23 = lshr i64 %2, 63
  %24 = xor i64 %21, %23
  %25 = add nuw nsw i64 %24, %23
  %26 = icmp eq i64 %25, 2
  %27 = zext i1 %26 to i8
  store i8 %27, i8* @OF_2077_4145c630, align 1, !tbaa !29
  %28 = sub i64 %2, 16
  %29 = load i64, i64* @RDI_2296_4145c678, align 8
  %30 = inttoptr i64 %28 to i64*
  store i64 %29, i64* %30, align 8
  %31 = sub i64 %2, 24
  %32 = load i64, i64* @RSI_2280_4145c678, align 8
  %33 = inttoptr i64 %31 to i64*
  store i64 %32, i64* %33, align 8
  %34 = sub i64 %2, 32
  %35 = load i64, i64* @RDX_2264_4145c678, align 8
  %36 = inttoptr i64 %34 to i64*
  store i64 %35, i64* %36, align 8
  %37 = load i64, i64* %33, align 8
  store i64 %37, i64* @RSI_2280_4145c678, align 8, !tbaa !8
  store i8* @data_402007, i8** @RDI_2296_41463aa0, align 8
  %38 = sub i64 %2, 36
  store i64 %38, i64* @RDX_2264_4145c678, align 8, !tbaa !8
  store i8 0, i8* @RAX_2216_4145c630, align 1, !tbaa !5
  %39 = add i64 %4, -8
  %40 = getelementptr i64, i64* %5, i32 -1
  store i64 ptrtoint (i8* @data_40125d to i64), i64* %40, align 8
  store i64 %39, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  %41 = call %struct.Memory* @ext_404078___isoc99_scanf(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  %42 = load i32, i32* @RAX_2216_4145c660, align 4
  %43 = sub i32 %42, 2
  %44 = icmp eq i32 %43, 0
  %45 = load i64, i64* @RBP_2328_4145c678, align 8
  br i1 %44, label %inst_401272, label %inst_401266

inst_401296:                                      ; preds = %inst_40128c, %inst_40127f, %inst_401272
  %46 = sub i64 %45, 4
  %47 = inttoptr i64 %46 to i32*
  store i32 -1, i32* %47, align 4
  br label %inst_4013b6

inst_4013a3:                                      ; preds = %inst_401391, %inst_401384
  %48 = sub i64 %187, 4
  %49 = inttoptr i64 %48 to i32*
  store i32 -1, i32* %49, align 4
  br label %inst_4013b6

inst_401328:                                      ; preds = %inst_401319, %inst_40130f, %inst_401300, %inst_4012f6
  %50 = sub i64 %204, 4
  %51 = inttoptr i64 %50 to i32*
  store i32 -1, i32* %51, align 4
  br label %inst_4013b6

inst_4013b6:                                      ; preds = %inst_4013af, %inst_401378, %inst_4012ea, %inst_401266, %inst_401328, %inst_4013a3, %inst_401296
  %52 = phi %struct.Memory* [ %41, %inst_401296 ], [ %183, %inst_4013a3 ], [ %183, %inst_4013af ], [ %183, %inst_401378 ], [ %200, %inst_401328 ], [ %200, %inst_4012ea ], [ %41, %inst_401266 ]
  %53 = load i64, i64* @RBP_2328_4145c678, align 8
  %54 = sub i64 %53, 4
  %55 = inttoptr i64 %54 to i32*
  %56 = load i32, i32* %55, align 4
  %57 = zext i32 %56 to i64
  store i64 %57, i64* @RAX_2216_4145c678, align 8, !tbaa !8
  %58 = load i64*, i64** @RSP_2312_41463c00, align 8
  %59 = load i64, i64* @RSP_2312_4145c678, align 8
  %60 = add i64 64, %59
  %61 = icmp ult i64 %60, %59
  %62 = icmp ult i64 %60, 64
  %63 = or i1 %61, %62
  %64 = zext i1 %63 to i8
  store i8 %64, i8* @CF_2065_4145c630, align 1, !tbaa !10
  %65 = trunc i64 %60 to i32
  %66 = and i32 %65, 255
  %67 = call i32 @llvm.ctpop.i32(i32 %66) #3, !range !24
  %68 = trunc i32 %67 to i8
  %69 = and i8 %68, 1
  %70 = xor i8 %69, 1
  store i8 %70, i8* @PF_2067_4145c630, align 1, !tbaa !25
  %71 = xor i64 64, %59
  %72 = xor i64 %71, %60
  %73 = lshr i64 %72, 4
  %74 = trunc i64 %73 to i8
  %75 = and i8 %74, 1
  store i8 %75, i8* @AF_2069_4145c630, align 1, !tbaa !26
  %76 = icmp eq i64 %60, 0
  %77 = zext i1 %76 to i8
  store i8 %77, i8* @ZF_2071_4145c630, align 1, !tbaa !27
  %78 = lshr i64 %60, 63
  %79 = trunc i64 %78 to i8
  store i8 %79, i8* @SF_2073_4145c630, align 1, !tbaa !28
  %80 = lshr i64 %59, 63
  %81 = xor i64 %78, %80
  %82 = add nuw nsw i64 %81, %78
  %83 = icmp eq i64 %82, 2
  %84 = zext i1 %83 to i8
  store i8 %84, i8* @OF_2077_4145c630, align 1, !tbaa !29
  %85 = add i64 %60, 8
  %86 = getelementptr i64, i64* %58, i32 8
  %87 = load i64, i64* %86, align 8
  store i64 %87, i64* @RBP_2328_4145c678, align 8, !tbaa !8
  %88 = add i64 %85, 8
  store i64 %88, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  ret %struct.Memory* %52

inst_4012b8:                                      ; preds = %inst_401334, %inst_4012a2
  %89 = phi %struct.Memory* [ %169, %inst_4012a2 ], [ %270, %inst_401334 ]
  %90 = load i64, i64* @RBP_2328_4145c678, align 8
  %91 = sub i64 %90, 40
  %92 = inttoptr i64 %91 to i32*
  %93 = load i32, i32* %92, align 4
  %94 = zext i32 %93 to i64
  store i64 %94, i64* @RAX_2216_4145c678, align 8, !tbaa !8
  %95 = sub i64 %90, 36
  %96 = inttoptr i64 %95 to i32*
  %97 = load i32, i32* %96, align 4
  %98 = sub i32 %93, %97
  %99 = icmp ugt i32 %97, %93
  %100 = zext i1 %99 to i8
  store i8 %100, i8* @CF_2065_4145c630, align 1, !tbaa !10
  %101 = and i32 %98, 255
  %102 = call i32 @llvm.ctpop.i32(i32 %101) #3, !range !24
  %103 = trunc i32 %102 to i8
  %104 = and i8 %103, 1
  %105 = xor i8 %104, 1
  store i8 %105, i8* @PF_2067_4145c630, align 1, !tbaa !25
  %106 = xor i32 %97, %93
  %107 = xor i32 %106, %98
  %108 = lshr i32 %107, 4
  %109 = trunc i32 %108 to i8
  %110 = and i8 %109, 1
  store i8 %110, i8* @AF_2069_4145c630, align 1, !tbaa !26
  %111 = icmp eq i32 %98, 0
  %112 = zext i1 %111 to i8
  store i8 %112, i8* @ZF_2071_4145c630, align 1, !tbaa !27
  %113 = lshr i32 %98, 31
  %114 = trunc i32 %113 to i8
  store i8 %114, i8* @SF_2073_4145c630, align 1, !tbaa !28
  %115 = lshr i32 %93, 31
  %116 = lshr i32 %97, 31
  %117 = xor i32 %116, %115
  %118 = xor i32 %113, %115
  %119 = add nuw nsw i32 %118, %117
  %120 = icmp eq i32 %119, 2
  %121 = zext i1 %120 to i8
  store i8 %121, i8* @OF_2077_4145c630, align 1, !tbaa !29
  %122 = icmp eq i8 %114, 0
  %123 = xor i1 %122, %120
  %124 = select i1 %123, i64 add (i64 ptrtoint (i8* @data_4012b8 to i64), i64 162), i64 add (i64 ptrtoint (i8* @data_4012b8 to i64), i64 12)
  br i1 %123, label %inst_40135a, label %inst_4012c4

inst_401272:                                      ; preds = %inst_401230
  %125 = sub i64 %45, 24
  %126 = inttoptr i64 %125 to i64*
  %127 = load i64, i64* %126, align 8
  %128 = inttoptr i64 %127 to i32*
  %129 = load i32, i32* %128, align 4
  %130 = icmp eq i32 %129, 0
  %131 = lshr i32 %129, 31
  %132 = trunc i32 %131 to i8
  %133 = icmp ne i8 %132, 0
  %134 = or i1 %130, %133
  br i1 %134, label %inst_401296, label %inst_40127f

inst_401266:                                      ; preds = %inst_401230
  %135 = sub i64 %45, 4
  %136 = inttoptr i64 %135 to i32*
  store i32 -1, i32* %136, align 4
  br label %inst_4013b6

inst_40127f:                                      ; preds = %inst_401272
  %137 = sub i32 %129, 100
  %138 = icmp eq i32 %137, 0
  %139 = zext i1 %138 to i8
  %140 = lshr i32 %137, 31
  %141 = trunc i32 %140 to i8
  %142 = xor i32 %140, %131
  %143 = add nuw nsw i32 %142, %131
  %144 = icmp eq i32 %143, 2
  %145 = icmp eq i8 %139, 0
  %146 = icmp eq i8 %141, 0
  %147 = xor i1 %146, %144
  %148 = and i1 %145, %147
  br i1 %148, label %inst_401296, label %inst_40128c

inst_40128c:                                      ; preds = %inst_40127f
  %149 = sub i64 %45, 36
  %150 = inttoptr i64 %149 to i32*
  %151 = load i32, i32* %150, align 4
  store i8 0, i8* @CF_2065_4145c630, align 1, !tbaa !10
  %152 = and i32 %151, 255
  %153 = call i32 @llvm.ctpop.i32(i32 %152) #3, !range !24
  %154 = trunc i32 %153 to i8
  %155 = and i8 %154, 1
  %156 = xor i8 %155, 1
  store i8 %156, i8* @PF_2067_4145c630, align 1, !tbaa !25
  store i8 0, i8* @AF_2069_4145c630, align 1, !tbaa !26
  %157 = icmp eq i32 %151, 0
  %158 = zext i1 %157 to i8
  store i8 %158, i8* @ZF_2071_4145c630, align 1, !tbaa !27
  %159 = lshr i32 %151, 31
  %160 = trunc i32 %159 to i8
  store i8 %160, i8* @SF_2073_4145c630, align 1, !tbaa !28
  store i8 0, i8* @OF_2077_4145c630, align 1, !tbaa !29
  %161 = icmp eq i8 %160, 0
  br i1 %161, label %inst_4012a2, label %inst_401296

inst_4012a2:                                      ; preds = %inst_40128c
  %162 = sub i64 %45, 16
  %163 = inttoptr i64 %162 to i64*
  %164 = load i64, i64* %163, align 8
  store i64 %164, i64* @RDI_2296_4145c678, align 8, !tbaa !8
  store i64 %127, i64* @RAX_2216_4145c678, align 8, !tbaa !8
  %165 = zext i32 %129 to i64
  store i64 %165, i64* @RSI_2280_4145c678, align 8, !tbaa !8
  %166 = load i64, i64* @RSP_2312_4145c678, align 8, !tbaa !5
  %167 = add i64 %166, -8
  %168 = inttoptr i64 %167 to i64*
  store i64 add (i64 ptrtoint (i8* @data_401272 to i64), i64 63), i64* %168, align 8
  store i64 %167, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  %169 = call %struct.Memory* @sub_401130_init_graph(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %41)
  %170 = load i64, i64* @RBP_2328_4145c678, align 8
  %171 = sub i64 %170, 40
  %172 = inttoptr i64 %171 to i32*
  store i32 0, i32* %172, align 4
  br label %inst_4012b8

inst_40135a:                                      ; preds = %inst_4012b8
  %173 = add i64 %124, 4
  %174 = sub i64 %90, 32
  %175 = inttoptr i64 %174 to i64*
  %176 = load i64, i64* %175, align 8
  store i64 %176, i64* @RSI_2280_4145c678, align 8, !tbaa !8
  %177 = add i64 %173, 10
  store i8* @data_40200a, i8** @RDI_2296_41463aa0, align 8
  %178 = add i64 %177, 2
  store i8 0, i8* @RAX_2216_4145c630, align 1, !tbaa !5
  %179 = add i64 %178, 5
  %180 = load i64, i64* @RSP_2312_4145c678, align 8, !tbaa !5
  %181 = add i64 %180, -8
  %182 = inttoptr i64 %181 to i64*
  store i64 %179, i64* %182, align 8
  store i64 %181, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  %183 = call %struct.Memory* @ext_404078___isoc99_scanf(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %89)
  %184 = load i32, i32* @RAX_2216_4145c660, align 4
  %185 = sub i32 %184, 1
  %186 = icmp eq i32 %185, 0
  %187 = load i64, i64* @RBP_2328_4145c678, align 8
  br i1 %186, label %inst_401384, label %inst_401378

inst_4012c4:                                      ; preds = %inst_4012b8
  %188 = add i64 %124, 10
  store i8* @data_402004, i8** @RDI_2296_41463aa0, align 8
  %189 = add i64 %188, 4
  %190 = sub i64 %90, 44
  store i64 %190, i64* @RSI_2280_4145c678, align 8, !tbaa !8
  %191 = add i64 %189, 4
  %192 = sub i64 %90, 48
  store i64 %192, i64* @RDX_2264_4145c678, align 8, !tbaa !8
  %193 = add i64 %191, 4
  %194 = sub i64 %90, 52
  store i64 %194, i64* @RCX_2248_4145c678, align 8, !tbaa !8
  %195 = add i64 %193, 2
  store i8 0, i8* @RAX_2216_4145c630, align 1, !tbaa !5
  %196 = add i64 %195, 5
  %197 = load i64, i64* @RSP_2312_4145c678, align 8, !tbaa !5
  %198 = add i64 %197, -8
  %199 = inttoptr i64 %198 to i64*
  store i64 %196, i64* %199, align 8
  store i64 %198, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  %200 = call %struct.Memory* @ext_404078___isoc99_scanf(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %89)
  %201 = load i32, i32* @RAX_2216_4145c660, align 4
  %202 = sub i32 %201, 3
  %203 = icmp eq i32 %202, 0
  %204 = load i64, i64* @RBP_2328_4145c678, align 8
  br i1 %203, label %inst_4012f6, label %inst_4012ea

inst_4012f6:                                      ; preds = %inst_4012c4
  %205 = sub i64 %204, 44
  %206 = inttoptr i64 %205 to i32*
  %207 = load i32, i32* %206, align 4
  %208 = lshr i32 %207, 31
  %209 = trunc i32 %208 to i8
  %210 = icmp ne i8 %209, 0
  br i1 %210, label %inst_401328, label %inst_401300

inst_4012ea:                                      ; preds = %inst_4012c4
  %211 = sub i64 %204, 4
  %212 = inttoptr i64 %211 to i32*
  store i32 -1, i32* %212, align 4
  br label %inst_4013b6

inst_401300:                                      ; preds = %inst_4012f6
  %213 = sub i64 %204, 24
  %214 = inttoptr i64 %213 to i64*
  %215 = load i64, i64* %214, align 8
  store i64 %215, i64* @RCX_2248_4145c678, align 8, !tbaa !8
  %216 = inttoptr i64 %215 to i32*
  %217 = load i32, i32* %216, align 4
  %218 = sub i32 %207, %217
  %219 = lshr i32 %218, 31
  %220 = trunc i32 %219 to i8
  %221 = lshr i32 %217, 31
  %222 = xor i32 %221, %208
  %223 = xor i32 %219, %208
  %224 = add nuw nsw i32 %223, %222
  %225 = icmp eq i32 %224, 2
  %226 = icmp eq i8 %220, 0
  %227 = xor i1 %226, %225
  br i1 %227, label %inst_401328, label %inst_40130f

inst_40130f:                                      ; preds = %inst_401300
  %228 = sub i64 %204, 48
  %229 = inttoptr i64 %228 to i32*
  %230 = load i32, i32* %229, align 4
  %231 = lshr i32 %230, 31
  %232 = trunc i32 %231 to i8
  %233 = icmp ne i8 %232, 0
  br i1 %233, label %inst_401328, label %inst_401319

inst_401319:                                      ; preds = %inst_40130f
  %234 = zext i32 %230 to i64
  store i64 %234, i64* @RAX_2216_4145c678, align 8, !tbaa !8
  store i64 %215, i64* @RCX_2248_4145c678, align 8, !tbaa !8
  %235 = sub i32 %230, %217
  %236 = icmp ugt i32 %217, %230
  %237 = zext i1 %236 to i8
  store i8 %237, i8* @CF_2065_4145c630, align 1, !tbaa !10
  %238 = and i32 %235, 255
  %239 = call i32 @llvm.ctpop.i32(i32 %238) #3, !range !24
  %240 = trunc i32 %239 to i8
  %241 = and i8 %240, 1
  %242 = xor i8 %241, 1
  store i8 %242, i8* @PF_2067_4145c630, align 1, !tbaa !25
  %243 = xor i32 %217, %230
  %244 = xor i32 %243, %235
  %245 = lshr i32 %244, 4
  %246 = trunc i32 %245 to i8
  %247 = and i8 %246, 1
  store i8 %247, i8* @AF_2069_4145c630, align 1, !tbaa !26
  %248 = icmp eq i32 %235, 0
  %249 = zext i1 %248 to i8
  store i8 %249, i8* @ZF_2071_4145c630, align 1, !tbaa !27
  %250 = lshr i32 %235, 31
  %251 = trunc i32 %250 to i8
  store i8 %251, i8* @SF_2073_4145c630, align 1, !tbaa !28
  %252 = xor i32 %221, %231
  %253 = xor i32 %250, %231
  %254 = add nuw nsw i32 %253, %252
  %255 = icmp eq i32 %254, 2
  %256 = zext i1 %255 to i8
  store i8 %256, i8* @OF_2077_4145c630, align 1, !tbaa !29
  %257 = icmp ne i8 %251, 0
  %258 = xor i1 %257, %255
  br i1 %258, label %inst_401334, label %inst_401328

inst_401334:                                      ; preds = %inst_401319
  %259 = zext i32 %207 to i64
  %260 = sub i64 %204, 16
  %261 = inttoptr i64 %260 to i64*
  %262 = load i64, i64* %261, align 8
  store i64 %262, i64* @RDI_2296_4145c678, align 8, !tbaa !8
  store i64 %259, i64* @RSI_2280_4145c678, align 8, !tbaa !8
  store i64 %234, i64* @RDX_2264_4145c678, align 8, !tbaa !8
  %263 = sub i64 %204, 52
  %264 = inttoptr i64 %263 to i32*
  %265 = load i32, i32* %264, align 4
  %266 = zext i32 %265 to i64
  store i64 %266, i64* @RCX_2248_4145c678, align 8, !tbaa !8
  store i64 1, i64* @R8_2344_4145c678, align 8, !tbaa !8
  %267 = load i64, i64* @RSP_2312_4145c678, align 8, !tbaa !5
  %268 = add i64 %267, -8
  %269 = inttoptr i64 %268 to i64*
  store i64 add (i64 ptrtoint (i8* @data_4012f6 to i64), i64 86), i64* %269, align 8
  store i64 %268, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  %270 = call %struct.Memory* @sub_4011b0_add_edge(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %200)
  %271 = load i64, i64* @RBP_2328_4145c678, align 8
  %272 = sub i64 %271, 40
  %273 = inttoptr i64 %272 to i32*
  %274 = load i32, i32* %273, align 4
  %275 = add i32 1, %274
  store i32 %275, i32* %273, align 4
  br label %inst_4012b8

inst_401384:                                      ; preds = %inst_40135a
  %276 = sub i64 %187, 32
  %277 = inttoptr i64 %276 to i64*
  %278 = load i64, i64* %277, align 8
  %279 = inttoptr i64 %278 to i32*
  %280 = load i32, i32* %279, align 4
  %281 = lshr i32 %280, 31
  %282 = trunc i32 %281 to i8
  %283 = icmp ne i8 %282, 0
  br i1 %283, label %inst_4013a3, label %inst_401391

inst_401378:                                      ; preds = %inst_40135a
  %284 = sub i64 %187, 4
  %285 = inttoptr i64 %284 to i32*
  store i32 -1, i32* %285, align 4
  br label %inst_4013b6

inst_401391:                                      ; preds = %inst_401384
  %286 = sub i64 %187, 24
  %287 = inttoptr i64 %286 to i64*
  %288 = load i64, i64* %287, align 8
  store i64 %288, i64* @RCX_2248_4145c678, align 8, !tbaa !8
  %289 = inttoptr i64 %288 to i32*
  %290 = load i32, i32* %289, align 4
  %291 = sub i32 %280, %290
  %292 = lshr i32 %291, 31
  %293 = trunc i32 %292 to i8
  %294 = lshr i32 %290, 31
  %295 = xor i32 %294, %281
  %296 = xor i32 %292, %281
  %297 = add nuw nsw i32 %296, %295
  %298 = icmp eq i32 %297, 2
  %299 = icmp ne i8 %293, 0
  %300 = xor i1 %299, %298
  br i1 %300, label %inst_4013af, label %inst_4013a3

inst_4013af:                                      ; preds = %inst_401391
  %301 = sub i64 %187, 4
  %302 = inttoptr i64 %301 to i32*
  store i32 0, i32* %302, align 4
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
