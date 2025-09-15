; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/mcsema/ll/O0/BFS_function.ll'
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
@RSP_2312_9d175b8 = external global i64
@OF_2077_9d17570 = external global i8
@SF_2073_9d17570 = external global i8
@ZF_2071_9d17570 = external global i8
@AF_2069_9d17570 = external global i8
@PF_2067_9d17570 = external global i8
@CF_2065_9d17570 = external global i8
@RAX_2216_9d175b8 = external global i64
@RBP_2328_9d175b8 = external global i64
@RBP_2328_9d1ebc0 = external global i64*
@R9_2360_9d175b8 = external global i64
@R8_2344_9d175b8 = external global i64
@RCX_2248_9d175b8 = external global i64
@RDX_2264_9d175b8 = external global i64
@RSI_2280_9d175b8 = external global i64
@RDI_2296_9d175b8 = external global i64

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare !remill.function.type !4 i32 @llvm.ctpop.i32(i32) #0

; Function Attrs: noinline
define hidden %struct.Memory* @sub_11c9_bfs(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #1 {
inst_11c9:
  %0 = load i64, i64* @RBP_2328_9d175b8, align 8
  %1 = load i64, i64* @RSP_2312_9d175b8, align 8, !tbaa !5
  %2 = add i64 %1, -8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3, align 8
  store i64 %2, i64* @RBP_2328_9d175b8, align 8, !tbaa !8
  %4 = add i64 %1, -104
  store i64 %4, i64* @RSP_2312_9d175b8, align 8, !tbaa !8
  %5 = add i64 %1, -64
  %6 = load i64, i64* @RDI_2296_9d175b8, align 8
  %7 = inttoptr i64 %5 to i64*
  store i64 %6, i64* %7, align 8
  %8 = add i64 %1, -72
  %9 = load i64, i64* @RSI_2280_9d175b8, align 8
  %10 = inttoptr i64 %8 to i64*
  store i64 %9, i64* %10, align 8
  %11 = add i64 %1, -80
  %12 = load i64, i64* @RDX_2264_9d175b8, align 8
  %13 = inttoptr i64 %11 to i64*
  store i64 %12, i64* %13, align 8
  %14 = add i64 %1, -88
  %15 = load i64, i64* @RCX_2248_9d175b8, align 8
  %16 = inttoptr i64 %14 to i64*
  store i64 %15, i64* %16, align 8
  %17 = add i64 %1, -96
  %18 = load i64, i64* @R8_2344_9d175b8, align 8
  %19 = inttoptr i64 %17 to i64*
  store i64 %18, i64* %19, align 8
  %20 = load i64, i64* @R9_2360_9d175b8, align 8
  %21 = inttoptr i64 %4 to i64*
  store i64 %20, i64* %21, align 8
  %22 = load i64, i64* %10, align 8
  store i8 0, i8* @CF_2065_9d17570, align 1, !tbaa !10
  %23 = trunc i64 %22 to i32
  %24 = and i32 %23, 255
  %25 = call i32 @llvm.ctpop.i32(i32 %24) #3, !range !24
  %26 = trunc i32 %25 to i8
  %27 = and i8 %26, 1
  %28 = xor i8 %27, 1
  store i8 %28, i8* @PF_2067_9d17570, align 1, !tbaa !25
  store i8 0, i8* @AF_2069_9d17570, align 1, !tbaa !26
  %29 = icmp eq i64 %22, 0
  %30 = zext i1 %29 to i8
  store i8 %30, i8* @ZF_2071_9d17570, align 1, !tbaa !27
  %31 = lshr i64 %22, 63
  %32 = trunc i64 %31 to i8
  store i8 %32, i8* @SF_2073_9d17570, align 1, !tbaa !28
  store i8 0, i8* @OF_2077_9d17570, align 1, !tbaa !29
  br i1 %29, label %inst_11fe, label %inst_11f4

inst_13c1:                                        ; preds = %inst_126b, %inst_13b3
  %33 = load i64, i64* %140, align 8
  %34 = load i64, i64* %142, align 8
  %35 = sub i64 %33, %34
  %36 = icmp ult i64 %33, %34
  %37 = zext i1 %36 to i8
  store i8 %37, i8* @CF_2065_9d17570, align 1, !tbaa !10
  %38 = trunc i64 %35 to i32
  %39 = and i32 %38, 255
  %40 = call i32 @llvm.ctpop.i32(i32 %39) #3, !range !24
  %41 = trunc i32 %40 to i8
  %42 = and i8 %41, 1
  %43 = xor i8 %42, 1
  store i8 %43, i8* @PF_2067_9d17570, align 1, !tbaa !25
  %44 = xor i64 %34, %33
  %45 = xor i64 %44, %35
  %46 = trunc i64 %45 to i8
  %47 = lshr i8 %46, 4
  %48 = and i8 %47, 1
  store i8 %48, i8* @AF_2069_9d17570, align 1, !tbaa !26
  %49 = icmp eq i64 %35, 0
  %50 = zext i1 %49 to i8
  store i8 %50, i8* @ZF_2071_9d17570, align 1, !tbaa !27
  %51 = lshr i64 %35, 63
  %52 = trunc i64 %51 to i8
  store i8 %52, i8* @SF_2073_9d17570, align 1, !tbaa !28
  %53 = lshr i64 %33, 63
  %54 = lshr i64 %34, 63
  %55 = xor i64 %54, %53
  %56 = xor i64 %51, %53
  %57 = add nuw nsw i64 %56, %55
  %58 = icmp eq i64 %57, 2
  %59 = zext i1 %58 to i8
  store i8 %59, i8* @OF_2077_9d17570, align 1, !tbaa !29
  br i1 %36, label %inst_12c6, label %inst_13cf

inst_13ae:                                        ; preds = %inst_131d, %inst_135f, %inst_1345
  %60 = load i64, i64* %215, align 8
  %61 = add i64 %60, 1
  br label %inst_13b3

inst_13b3:                                        ; preds = %inst_12c6, %inst_13ae
  %storemerge1 = phi i64 [ 0, %inst_12c6 ], [ %61, %inst_13ae ]
  store i64 %storemerge1, i64* %215, align 8
  %62 = add i64 %125, -64
  %63 = inttoptr i64 %62 to i64*
  %64 = load i64, i64* %63, align 8
  %65 = icmp ugt i64 %64, %storemerge1
  br i1 %65, label %inst_131d, label %inst_13c1

inst_1236:                                        ; preds = %inst_1218, %inst_120e
  %storemerge = phi i64 [ 0, %inst_120e ], [ %107, %inst_1218 ]
  store i64 %storemerge, i64* %101, align 8
  %66 = load i64, i64* %10, align 8
  %67 = icmp ugt i64 %66, %storemerge
  br i1 %67, label %inst_1218, label %inst_1240

inst_13db:                                        ; preds = %inst_13cf, %inst_125b, %inst_11fe
  %68 = phi %struct.Memory* [ %memory, %inst_11fe ], [ %219, %inst_13cf ], [ %124, %inst_125b ]
  %69 = load i64*, i64** @RBP_2328_9d1ebc0, align 8
  %70 = load i64, i64* @RBP_2328_9d175b8, align 8, !tbaa !5
  %71 = load i64, i64* %69, align 8
  store i64 %71, i64* @RBP_2328_9d175b8, align 8, !tbaa !8
  %72 = add i64 %70, 16
  store i64 %72, i64* @RSP_2312_9d175b8, align 8, !tbaa !8
  ret %struct.Memory* %68

inst_11fe:                                        ; preds = %inst_11f4, %inst_11c9
  %73 = load i64, i64* %21, align 8
  store i64 %73, i64* @RAX_2216_9d175b8, align 8, !tbaa !8
  %74 = inttoptr i64 %73 to i64*
  store i64 0, i64* %74, align 8
  br label %inst_13db

inst_11f4:                                        ; preds = %inst_11c9
  %75 = load i64, i64* %13, align 8
  %76 = sub i64 %75, %22
  %77 = icmp ult i64 %75, %22
  %78 = zext i1 %77 to i8
  store i8 %78, i8* @CF_2065_9d17570, align 1, !tbaa !10
  %79 = trunc i64 %76 to i32
  %80 = and i32 %79, 255
  %81 = call i32 @llvm.ctpop.i32(i32 %80) #3, !range !24
  %82 = trunc i32 %81 to i8
  %83 = and i8 %82, 1
  %84 = xor i8 %83, 1
  store i8 %84, i8* @PF_2067_9d17570, align 1, !tbaa !25
  %85 = xor i64 %22, %75
  %86 = xor i64 %85, %76
  %87 = trunc i64 %86 to i8
  %88 = lshr i8 %87, 4
  %89 = and i8 %88, 1
  store i8 %89, i8* @AF_2069_9d17570, align 1, !tbaa !26
  %90 = icmp eq i64 %76, 0
  %91 = zext i1 %90 to i8
  store i8 %91, i8* @ZF_2071_9d17570, align 1, !tbaa !27
  %92 = lshr i64 %76, 63
  %93 = trunc i64 %92 to i8
  store i8 %93, i8* @SF_2073_9d17570, align 1, !tbaa !28
  %94 = lshr i64 %75, 63
  %95 = xor i64 %31, %94
  %96 = xor i64 %92, %94
  %97 = add nuw nsw i64 %96, %95
  %98 = icmp eq i64 %97, 2
  %99 = zext i1 %98 to i8
  store i8 %99, i8* @OF_2077_9d17570, align 1, !tbaa !29
  br i1 %77, label %inst_120e, label %inst_11fe

inst_120e:                                        ; preds = %inst_11f4
  %100 = add i64 %1, -56
  %101 = inttoptr i64 %100 to i64*
  br label %inst_1236

inst_1218:                                        ; preds = %inst_1236
  %102 = shl i64 %storemerge, 2
  store i64 %102, i64* @RDX_2264_9d175b8, align 8, !tbaa !8
  %103 = load i64, i64* %16, align 8
  %104 = add i64 %102, %103
  %105 = inttoptr i64 %104 to i32*
  store i32 -1, i32* %105, align 4
  %106 = load i64, i64* %101, align 8
  %107 = add i64 %106, 1
  br label %inst_1236

inst_1240:                                        ; preds = %inst_1236
  %108 = shl i64 %66, 3
  store i64 %108, i64* @RAX_2216_9d175b8, align 8, !tbaa !8
  %109 = lshr i64 %66, 61
  %110 = trunc i64 %109 to i8
  %111 = and i8 %110, 1
  store i8 %111, i8* @CF_2065_9d17570, align 1, !tbaa !5
  %112 = trunc i64 %108 to i32
  %113 = and i32 %112, 248
  %114 = call i32 @llvm.ctpop.i32(i32 %113) #3, !range !24
  %115 = trunc i32 %114 to i8
  %116 = and i8 %115, 1
  %117 = xor i8 %116, 1
  store i8 %117, i8* @PF_2067_9d17570, align 1, !tbaa !5
  store i8 0, i8* @AF_2069_9d17570, align 1, !tbaa !5
  %118 = icmp eq i64 %108, 0
  %119 = zext i1 %118 to i8
  store i8 %119, i8* @ZF_2071_9d17570, align 1, !tbaa !5
  %120 = lshr i64 %108, 63
  %121 = trunc i64 %120 to i8
  store i8 %121, i8* @SF_2073_9d17570, align 1, !tbaa !5
  store i8 0, i8* @OF_2077_9d17570, align 1, !tbaa !5
  store i64 %108, i64* @RDI_2296_9d175b8, align 8, !tbaa !8
  %122 = load i64, i64* @RSP_2312_9d175b8, align 8, !tbaa !5
  %123 = add i64 %122, -8
  store i64 %123, i64* @RSP_2312_9d175b8, align 8, !tbaa !8
  %124 = call %struct.Memory* @ext_10d0__malloc(%struct.State* nonnull @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  %125 = load i64, i64* @RBP_2328_9d175b8, align 8
  %126 = add i64 %125, -16
  %127 = load i64, i64* @RAX_2216_9d175b8, align 8
  %128 = inttoptr i64 %126 to i64*
  store i64 %127, i64* %128, align 8
  store i8 0, i8* @CF_2065_9d17570, align 1, !tbaa !10
  %129 = trunc i64 %127 to i32
  %130 = and i32 %129, 255
  %131 = call i32 @llvm.ctpop.i32(i32 %130) #3, !range !24
  %132 = trunc i32 %131 to i8
  %133 = and i8 %132, 1
  %134 = xor i8 %133, 1
  store i8 %134, i8* @PF_2067_9d17570, align 1, !tbaa !25
  store i8 0, i8* @AF_2069_9d17570, align 1, !tbaa !26
  %135 = icmp eq i64 %127, 0
  %136 = zext i1 %135 to i8
  store i8 %136, i8* @ZF_2071_9d17570, align 1, !tbaa !27
  %137 = lshr i64 %127, 63
  %138 = trunc i64 %137 to i8
  store i8 %138, i8* @SF_2073_9d17570, align 1, !tbaa !28
  store i8 0, i8* @OF_2077_9d17570, align 1, !tbaa !29
  br i1 %135, label %inst_125b, label %inst_126b

inst_126b:                                        ; preds = %inst_1240
  %139 = add i64 %125, -40
  %140 = inttoptr i64 %139 to i64*
  store i64 0, i64* %140, align 8
  %141 = add i64 %125, -32
  %142 = inttoptr i64 %141 to i64*
  store i64 0, i64* %142, align 8
  %143 = add i64 %125, -72
  %144 = inttoptr i64 %143 to i64*
  %145 = load i64, i64* %144, align 8
  %146 = shl i64 %145, 2
  %147 = add i64 %125, -80
  %148 = inttoptr i64 %147 to i64*
  %149 = load i64, i64* %148, align 8
  %150 = add i64 %146, %149
  %151 = inttoptr i64 %150 to i32*
  store i32 0, i32* %151, align 4
  %152 = load i64, i64* %142, align 8
  %153 = add i64 %152, 1
  store i64 %153, i64* %142, align 8
  %154 = shl i64 %152, 3
  %155 = load i64, i64* %128, align 8
  %156 = add i64 %155, %154
  store i64 %156, i64* @RDX_2264_9d175b8, align 8, !tbaa !8
  %157 = load i64, i64* %144, align 8
  %158 = inttoptr i64 %156 to i64*
  store i64 %157, i64* %158, align 8
  %159 = add i64 %125, -96
  %160 = inttoptr i64 %159 to i64*
  %161 = load i64, i64* %160, align 8
  %162 = inttoptr i64 %161 to i64*
  store i64 0, i64* %162, align 8
  br label %inst_13c1

inst_125b:                                        ; preds = %inst_1240
  %163 = add i64 %125, -96
  %164 = inttoptr i64 %163 to i64*
  %165 = load i64, i64* %164, align 8
  store i64 %165, i64* @RAX_2216_9d175b8, align 8, !tbaa !8
  %166 = inttoptr i64 %165 to i64*
  store i64 0, i64* %166, align 8
  br label %inst_13db

inst_1345:                                        ; preds = %inst_131d
  %167 = shl i64 %storemerge1, 2
  store i64 %167, i64* @RDX_2264_9d175b8, align 8, !tbaa !8
  %168 = load i64, i64* %148, align 8
  %169 = add i64 %167, %168
  %170 = inttoptr i64 %169 to i32*
  %171 = load i32, i32* %170, align 4
  %.not = icmp eq i32 %171, -1
  br i1 %.not, label %inst_135f, label %inst_13ae

inst_135f:                                        ; preds = %inst_1345
  %172 = shl i64 %184, 2
  %173 = add i64 %172, %168
  %174 = inttoptr i64 %173 to i32*
  %175 = load i32, i32* %174, align 4
  store i64 %167, i64* @RCX_2248_9d175b8, align 8, !tbaa !8
  %176 = add i32 %175, 1
  store i32 %176, i32* %170, align 4
  %177 = load i64, i64* %142, align 8
  %178 = add i64 %177, 1
  store i64 %178, i64* %142, align 8
  %179 = shl i64 %177, 3
  %180 = load i64, i64* %128, align 8
  %181 = add i64 %180, %179
  store i64 %181, i64* @RDX_2264_9d175b8, align 8, !tbaa !8
  %182 = load i64, i64* %215, align 8
  %183 = inttoptr i64 %181 to i64*
  store i64 %182, i64* %183, align 8
  br label %inst_13ae

inst_131d:                                        ; preds = %inst_13b3
  %184 = load i64, i64* %202, align 8
  %185 = mul i64 %64, %184
  %186 = add i64 %185, %storemerge1
  %187 = shl i64 %186, 2
  store i64 %187, i64* @RDX_2264_9d175b8, align 8, !tbaa !8
  %188 = add i64 %125, -56
  %189 = inttoptr i64 %188 to i64*
  %190 = load i64, i64* %189, align 8
  %191 = add i64 %187, %190
  %192 = inttoptr i64 %191 to i32*
  %193 = load i32, i32* %192, align 4
  %194 = icmp eq i32 %193, 0
  br i1 %194, label %inst_13ae, label %inst_1345

inst_12c6:                                        ; preds = %inst_13c1
  %195 = add i64 %33, 1
  store i64 %195, i64* %140, align 8
  %196 = shl i64 %33, 3
  %197 = load i64, i64* %128, align 8
  %198 = add i64 %196, %197
  %199 = inttoptr i64 %198 to i64*
  %200 = load i64, i64* %199, align 8
  %201 = add i64 %125, -8
  %202 = inttoptr i64 %201 to i64*
  store i64 %200, i64* %202, align 8
  %203 = load i64, i64* %160, align 8
  %204 = inttoptr i64 %203 to i64*
  %205 = load i64, i64* %204, align 8
  %206 = add i64 %205, 1
  store i64 %206, i64* @RCX_2248_9d175b8, align 8, !tbaa !8
  store i64 %206, i64* %204, align 8
  %207 = shl i64 %205, 3
  %208 = add i64 %125, -88
  %209 = inttoptr i64 %208 to i64*
  %210 = load i64, i64* %209, align 8
  %211 = add i64 %210, %207
  store i64 %211, i64* @RDX_2264_9d175b8, align 8, !tbaa !8
  %212 = load i64, i64* %202, align 8
  %213 = inttoptr i64 %211 to i64*
  store i64 %212, i64* %213, align 8
  %214 = add i64 %125, -24
  %215 = inttoptr i64 %214 to i64*
  br label %inst_13b3

inst_13cf:                                        ; preds = %inst_13c1
  %216 = load i64, i64* %128, align 8
  store i64 %216, i64* @RAX_2216_9d175b8, align 8, !tbaa !8
  store i64 %216, i64* @RDI_2296_9d175b8, align 8, !tbaa !8
  %217 = load i64, i64* @RSP_2312_9d175b8, align 8, !tbaa !5
  %218 = add i64 %217, -8
  store i64 %218, i64* @RSP_2312_9d175b8, align 8, !tbaa !8
  %219 = call %struct.Memory* @ext_1090__free(%struct.State* nonnull @__mcsema_reg_state, i64 undef, %struct.Memory* %124)
  br label %inst_13db
}

; Function Attrs: noinline
declare hidden %struct.Memory* @ext_10d0__malloc(%struct.State*, i64, %struct.Memory*) #2

; Function Attrs: noinline
declare hidden %struct.Memory* @ext_1090__free(%struct.State*, i64, %struct.Memory*) #2

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
