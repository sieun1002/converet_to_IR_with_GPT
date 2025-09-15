; ModuleID = 'BFS.ll'
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
  %4 = sub i64 %2, 96
  store i64 %4, i64* @RSP_2312_9d175b8, align 8, !tbaa !8
  %5 = sub i64 %2, 56
  %6 = load i64, i64* @RDI_2296_9d175b8, align 8
  %7 = inttoptr i64 %5 to i64*
  store i64 %6, i64* %7, align 8
  %8 = sub i64 %2, 64
  %9 = load i64, i64* @RSI_2280_9d175b8, align 8
  %10 = inttoptr i64 %8 to i64*
  store i64 %9, i64* %10, align 8
  %11 = sub i64 %2, 72
  %12 = load i64, i64* @RDX_2264_9d175b8, align 8
  %13 = inttoptr i64 %11 to i64*
  store i64 %12, i64* %13, align 8
  %14 = sub i64 %2, 80
  %15 = load i64, i64* @RCX_2248_9d175b8, align 8
  %16 = inttoptr i64 %14 to i64*
  store i64 %15, i64* %16, align 8
  %17 = sub i64 %2, 88
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
  %33 = phi %struct.Memory* [ %129, %inst_126b ], [ %33, %inst_13b3 ]
  %34 = load i64, i64* %146, align 8
  %35 = load i64, i64* %148, align 8
  %36 = sub i64 %34, %35
  %37 = icmp ugt i64 %35, %34
  %38 = zext i1 %37 to i8
  store i8 %38, i8* @CF_2065_9d17570, align 1, !tbaa !10
  %39 = trunc i64 %36 to i32
  %40 = and i32 %39, 255
  %41 = call i32 @llvm.ctpop.i32(i32 %40) #3, !range !24
  %42 = trunc i32 %41 to i8
  %43 = and i8 %42, 1
  %44 = xor i8 %43, 1
  store i8 %44, i8* @PF_2067_9d17570, align 1, !tbaa !25
  %45 = xor i64 %35, %34
  %46 = xor i64 %45, %36
  %47 = lshr i64 %46, 4
  %48 = trunc i64 %47 to i8
  %49 = and i8 %48, 1
  store i8 %49, i8* @AF_2069_9d17570, align 1, !tbaa !26
  %50 = icmp eq i64 %36, 0
  %51 = zext i1 %50 to i8
  store i8 %51, i8* @ZF_2071_9d17570, align 1, !tbaa !27
  %52 = lshr i64 %36, 63
  %53 = trunc i64 %52 to i8
  store i8 %53, i8* @SF_2073_9d17570, align 1, !tbaa !28
  %54 = lshr i64 %34, 63
  %55 = lshr i64 %35, 63
  %56 = xor i64 %55, %54
  %57 = xor i64 %52, %54
  %58 = add nuw nsw i64 %57, %56
  %59 = icmp eq i64 %58, 2
  %60 = zext i1 %59 to i8
  store i8 %60, i8* @OF_2077_9d17570, align 1, !tbaa !29
  br i1 %37, label %inst_12c6, label %inst_13cf

inst_13ae:                                        ; preds = %inst_131d, %inst_135f, %inst_1345
  %61 = load i64, i64* %228, align 8
  %62 = add i64 %61, 1
  store i64 %62, i64* %228, align 8
  br label %inst_13b3

inst_13b3:                                        ; preds = %inst_12c6, %inst_13ae
  %63 = load i64, i64* %228, align 8
  %64 = sub i64 %130, 64
  %65 = inttoptr i64 %64 to i64*
  %66 = load i64, i64* %65, align 8
  %67 = icmp ugt i64 %66, %63
  br i1 %67, label %inst_131d, label %inst_13c1

inst_1236:                                        ; preds = %inst_1218, %inst_120e
  %68 = load i64, i64* %105, align 8
  %69 = load i64, i64* %10, align 8
  %70 = icmp ugt i64 %69, %68
  br i1 %70, label %inst_1218, label %inst_1240

inst_13db:                                        ; preds = %inst_13cf, %inst_125b, %inst_11fe
  %71 = phi %struct.Memory* [ %memory, %inst_11fe ], [ %233, %inst_13cf ], [ %129, %inst_125b ]
  %72 = load i64*, i64** @RBP_2328_9d1ebc0, align 8
  %73 = load i64, i64* @RBP_2328_9d175b8, align 8, !tbaa !5
  %74 = load i64, i64* %72, align 8
  store i64 %74, i64* @RBP_2328_9d175b8, align 8, !tbaa !8
  %75 = add i64 %73, 8
  %76 = add i64 %75, 8
  store i64 %76, i64* @RSP_2312_9d175b8, align 8, !tbaa !8
  ret %struct.Memory* %71

inst_11fe:                                        ; preds = %inst_11f4, %inst_11c9
  %77 = load i64, i64* %21, align 8
  store i64 %77, i64* @RAX_2216_9d175b8, align 8, !tbaa !8
  %78 = inttoptr i64 %77 to i64*
  store i64 0, i64* %78, align 8
  br label %inst_13db

inst_11f4:                                        ; preds = %inst_11c9
  %79 = load i64, i64* %13, align 8
  %80 = sub i64 %79, %22
  %81 = icmp ugt i64 %22, %79
  %82 = zext i1 %81 to i8
  store i8 %82, i8* @CF_2065_9d17570, align 1, !tbaa !10
  %83 = trunc i64 %80 to i32
  %84 = and i32 %83, 255
  %85 = call i32 @llvm.ctpop.i32(i32 %84) #3, !range !24
  %86 = trunc i32 %85 to i8
  %87 = and i8 %86, 1
  %88 = xor i8 %87, 1
  store i8 %88, i8* @PF_2067_9d17570, align 1, !tbaa !25
  %89 = xor i64 %22, %79
  %90 = xor i64 %89, %80
  %91 = lshr i64 %90, 4
  %92 = trunc i64 %91 to i8
  %93 = and i8 %92, 1
  store i8 %93, i8* @AF_2069_9d17570, align 1, !tbaa !26
  %94 = icmp eq i64 %80, 0
  %95 = zext i1 %94 to i8
  store i8 %95, i8* @ZF_2071_9d17570, align 1, !tbaa !27
  %96 = lshr i64 %80, 63
  %97 = trunc i64 %96 to i8
  store i8 %97, i8* @SF_2073_9d17570, align 1, !tbaa !28
  %98 = lshr i64 %79, 63
  %99 = xor i64 %31, %98
  %100 = xor i64 %96, %98
  %101 = add nuw nsw i64 %100, %99
  %102 = icmp eq i64 %101, 2
  %103 = zext i1 %102 to i8
  store i8 %103, i8* @OF_2077_9d17570, align 1, !tbaa !29
  br i1 %81, label %inst_120e, label %inst_11fe

inst_120e:                                        ; preds = %inst_11f4
  %104 = sub i64 %2, 48
  %105 = inttoptr i64 %104 to i64*
  store i64 0, i64* %105, align 8
  br label %inst_1236

inst_1218:                                        ; preds = %inst_1236
  %106 = mul i64 %68, 4
  store i64 %106, i64* @RDX_2264_9d175b8, align 8, !tbaa !8
  %107 = load i64, i64* %16, align 8
  %108 = add i64 %106, %107
  %109 = inttoptr i64 %108 to i32*
  store i32 -1, i32* %109, align 4
  %110 = load i64, i64* %105, align 8
  %111 = add i64 %110, 1
  store i64 %111, i64* %105, align 8
  br label %inst_1236

inst_1240:                                        ; preds = %inst_1236
  %112 = shl i64 %69, 2
  %113 = shl i64 %112, 1
  store i64 %113, i64* @RAX_2216_9d175b8, align 8, !tbaa !8
  %114 = lshr i64 %112, 63
  %115 = trunc i64 %114 to i8
  store i8 %115, i8* @CF_2065_9d17570, align 1, !tbaa !5
  %116 = trunc i64 %113 to i32
  %117 = and i32 %116, 254
  %118 = call i32 @llvm.ctpop.i32(i32 %117) #3, !range !24
  %119 = trunc i32 %118 to i8
  %120 = and i8 %119, 1
  %121 = xor i8 %120, 1
  store i8 %121, i8* @PF_2067_9d17570, align 1, !tbaa !5
  store i8 0, i8* @AF_2069_9d17570, align 1, !tbaa !5
  %122 = icmp eq i64 %113, 0
  %123 = zext i1 %122 to i8
  store i8 %123, i8* @ZF_2071_9d17570, align 1, !tbaa !5
  %124 = lshr i64 %113, 63
  %125 = trunc i64 %124 to i8
  store i8 %125, i8* @SF_2073_9d17570, align 1, !tbaa !5
  store i8 0, i8* @OF_2077_9d17570, align 1, !tbaa !5
  store i64 %113, i64* @RDI_2296_9d175b8, align 8, !tbaa !8
  %126 = load i64, i64* @RSP_2312_9d175b8, align 8, !tbaa !5
  %127 = add i64 %126, -8
  %128 = inttoptr i64 %127 to i64*
  store i64 undef, i64* %128, align 8
  store i64 %127, i64* @RSP_2312_9d175b8, align 8, !tbaa !8
  %129 = call %struct.Memory* @ext_10d0__malloc(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  %130 = load i64, i64* @RBP_2328_9d175b8, align 8
  %131 = sub i64 %130, 16
  %132 = load i64, i64* @RAX_2216_9d175b8, align 8
  %133 = inttoptr i64 %131 to i64*
  store i64 %132, i64* %133, align 8
  store i8 0, i8* @CF_2065_9d17570, align 1, !tbaa !10
  %134 = trunc i64 %132 to i32
  %135 = and i32 %134, 255
  %136 = call i32 @llvm.ctpop.i32(i32 %135) #3, !range !24
  %137 = trunc i32 %136 to i8
  %138 = and i8 %137, 1
  %139 = xor i8 %138, 1
  store i8 %139, i8* @PF_2067_9d17570, align 1, !tbaa !25
  store i8 0, i8* @AF_2069_9d17570, align 1, !tbaa !26
  %140 = icmp eq i64 %132, 0
  %141 = zext i1 %140 to i8
  store i8 %141, i8* @ZF_2071_9d17570, align 1, !tbaa !27
  %142 = lshr i64 %132, 63
  %143 = trunc i64 %142 to i8
  store i8 %143, i8* @SF_2073_9d17570, align 1, !tbaa !28
  store i8 0, i8* @OF_2077_9d17570, align 1, !tbaa !29
  %144 = icmp eq i8 %141, 0
  br i1 %144, label %inst_126b, label %inst_125b

inst_126b:                                        ; preds = %inst_1240
  %145 = sub i64 %130, 40
  %146 = inttoptr i64 %145 to i64*
  store i64 0, i64* %146, align 8
  %147 = sub i64 %130, 32
  %148 = inttoptr i64 %147 to i64*
  store i64 0, i64* %148, align 8
  %149 = sub i64 %130, 72
  %150 = inttoptr i64 %149 to i64*
  %151 = load i64, i64* %150, align 8
  %152 = mul i64 %151, 4
  %153 = sub i64 %130, 80
  %154 = inttoptr i64 %153 to i64*
  %155 = load i64, i64* %154, align 8
  %156 = add i64 %152, %155
  %157 = inttoptr i64 %156 to i32*
  store i32 0, i32* %157, align 4
  %158 = load i64, i64* %148, align 8
  %159 = add i64 %158, 1
  store i64 %159, i64* %148, align 8
  %160 = mul i64 %158, 8
  %161 = load i64, i64* %133, align 8
  %162 = add i64 %161, %160
  store i64 %162, i64* @RDX_2264_9d175b8, align 8, !tbaa !8
  %163 = load i64, i64* %150, align 8
  %164 = inttoptr i64 %162 to i64*
  store i64 %163, i64* %164, align 8
  %165 = sub i64 %130, 96
  %166 = inttoptr i64 %165 to i64*
  %167 = load i64, i64* %166, align 8
  %168 = inttoptr i64 %167 to i64*
  store i64 0, i64* %168, align 8
  br label %inst_13c1

inst_125b:                                        ; preds = %inst_1240
  %169 = sub i64 %130, 96
  %170 = inttoptr i64 %169 to i64*
  %171 = load i64, i64* %170, align 8
  store i64 %171, i64* @RAX_2216_9d175b8, align 8, !tbaa !8
  %172 = inttoptr i64 %171 to i64*
  store i64 0, i64* %172, align 8
  br label %inst_13db

inst_1345:                                        ; preds = %inst_131d
  %173 = mul i64 %63, 4
  store i64 %173, i64* @RDX_2264_9d175b8, align 8, !tbaa !8
  %174 = load i64, i64* %154, align 8
  %175 = add i64 %173, %174
  %176 = inttoptr i64 %175 to i32*
  %177 = load i32, i32* %176, align 4
  %178 = sub i32 %177, -1
  %179 = icmp eq i32 %178, 0
  %180 = zext i1 %179 to i8
  %181 = icmp eq i8 %180, 0
  br i1 %181, label %inst_13ae, label %inst_135f

inst_135f:                                        ; preds = %inst_1345
  %182 = mul i64 %194, 4
  %183 = add i64 %182, %174
  %184 = inttoptr i64 %183 to i32*
  %185 = load i32, i32* %184, align 4
  store i64 %173, i64* @RCX_2248_9d175b8, align 8, !tbaa !8
  %186 = add i32 1, %185
  store i32 %186, i32* %176, align 4
  %187 = load i64, i64* %148, align 8
  %188 = add i64 %187, 1
  store i64 %188, i64* %148, align 8
  %189 = mul i64 %187, 8
  %190 = load i64, i64* %133, align 8
  %191 = add i64 %190, %189
  store i64 %191, i64* @RDX_2264_9d175b8, align 8, !tbaa !8
  %192 = load i64, i64* %228, align 8
  %193 = inttoptr i64 %191 to i64*
  store i64 %192, i64* %193, align 8
  br label %inst_13ae

inst_131d:                                        ; preds = %inst_13b3
  %194 = load i64, i64* %215, align 8
  %195 = zext i64 %194 to i128
  %196 = zext i64 %66 to i128
  %197 = mul i128 %196, %195
  %198 = trunc i128 %197 to i64
  %199 = add i64 %198, %63
  %200 = mul i64 %199, 4
  store i64 %200, i64* @RDX_2264_9d175b8, align 8, !tbaa !8
  %201 = sub i64 %130, 56
  %202 = inttoptr i64 %201 to i64*
  %203 = load i64, i64* %202, align 8
  %204 = add i64 %200, %203
  %205 = inttoptr i64 %204 to i32*
  %206 = load i32, i32* %205, align 4
  %207 = icmp eq i32 %206, 0
  br i1 %207, label %inst_13ae, label %inst_1345

inst_12c6:                                        ; preds = %inst_13c1
  %208 = add i64 %34, 1
  store i64 %208, i64* %146, align 8
  %209 = mul i64 %34, 8
  %210 = load i64, i64* %133, align 8
  %211 = add i64 %209, %210
  %212 = inttoptr i64 %211 to i64*
  %213 = load i64, i64* %212, align 8
  %214 = sub i64 %130, 8
  %215 = inttoptr i64 %214 to i64*
  store i64 %213, i64* %215, align 8
  %216 = load i64, i64* %166, align 8
  %217 = inttoptr i64 %216 to i64*
  %218 = load i64, i64* %217, align 8
  %219 = add i64 %218, 1
  store i64 %219, i64* @RCX_2248_9d175b8, align 8, !tbaa !8
  store i64 %219, i64* %217, align 8
  %220 = mul i64 %218, 8
  %221 = sub i64 %130, 88
  %222 = inttoptr i64 %221 to i64*
  %223 = load i64, i64* %222, align 8
  %224 = add i64 %223, %220
  store i64 %224, i64* @RDX_2264_9d175b8, align 8, !tbaa !8
  %225 = load i64, i64* %215, align 8
  %226 = inttoptr i64 %224 to i64*
  store i64 %225, i64* %226, align 8
  %227 = sub i64 %130, 24
  %228 = inttoptr i64 %227 to i64*
  store i64 0, i64* %228, align 8
  br label %inst_13b3

inst_13cf:                                        ; preds = %inst_13c1
  %229 = load i64, i64* %133, align 8
  store i64 %229, i64* @RAX_2216_9d175b8, align 8, !tbaa !8
  store i64 %229, i64* @RDI_2296_9d175b8, align 8, !tbaa !8
  %230 = load i64, i64* @RSP_2312_9d175b8, align 8, !tbaa !5
  %231 = add i64 %230, -8
  %232 = inttoptr i64 %231 to i64*
  store i64 undef, i64* %232, align 8
  store i64 %231, i64* @RSP_2312_9d175b8, align 8, !tbaa !8
  %233 = call %struct.Memory* @ext_1090__free(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %33)
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
