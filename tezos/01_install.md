# 기본 설치

이 글에서는 Tezos를 `opam`을 이용해 설치하는 방법을 알아본다. 

## OCaml 설치

현재 tezos (granada 버전)은 OCaml 4.12.1 을 기준으로 만들어져있다. `opam`으로 tezos 용 스위치를 만든다.

```
opam switch create for_tezos 4.12.1
```

생성한 스위치에 맞게 환경변수를 변경할 수 있다.

```
eval $(opam env --switch=for_tezos)
```

## Tezos 설치

tezos는 아래 명령으로 설치할 수 있다. 대략 880개 정도의 연관 패키지를 설치하기 때문에 꽤 긴 시간을 투자해햐나다.

```
opam depext tezos
opam install tezos
```

## 설치 후 작업

### .zcash 설치

초기에 tezos관련 프로그램을 기동시키면 Zcash가 없다는 메세지가 나온다. 아래의 스크립트를 받아 실행시킨다.

```
curl -O https://raw.githubusercontent.com/zcash/zcash/master/zcutil/fetch-params.sh
. fetch-param.sh
```
