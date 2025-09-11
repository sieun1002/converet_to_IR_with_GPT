빠른 IR 유효성/라운드트립 측정 가이드

무엇을 측정하나
- valid_parse: llvm-as 통과 여부(구문·형식)
- verify_ok: opt -verify 통과 여부(SSA/타입 불변식)
- codegen_ok: llc 오브젝트 생성 성공 여부
- diff_equal: 정규화 후 llvm-diff 동일(정답 IR이 있을 때만)
- link_ok: 하네스와 링크 성공 여부(선택)
- roundtrip_ok: codegen_ok && link_ok

사전 준비
- LLVM/Clang 설치(WSL/Ubuntu)
  sudo apt-get update
  sudo apt-get install -y clang llvm

폴더 구조 예
cases/
  add/
    src.c           # 정답 IR을 만들 소스(또는 ref.ll을 직접 넣어도 됨)
    ref.ll          # 선택(없으면 src.c로부터 자동 생성)
    llm.ll          # 후보 IR(LLM 산출물)
    mcsema.ll       # 후보 IR(McSema 산출물)
    retdec.ll       # 후보 IR(RetDec 산출물)
    harness.c       # 선택: 링크용 하네스

하네스 템플릿
- 함수 시그니처를 아는 순수 함수라면 templates/harness_template.c 참고.
- 예: extern int target(int); 같은 프로토타입을 맞춰주세요.

실행
  chmod +x quick_ir_eval.sh
  ./quick_ir_eval.sh cases

결과 파일
- out/results.csv: 케이스×아티팩트별 세부 결과
- out/summary.txt: 전체 성공률 요약
