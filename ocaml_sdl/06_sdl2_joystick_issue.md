# 빌드시 SDL2 모듈 관련 오류가 발생할 때

`dune build bin/main.exe` 로 빌드했을 때 새로 설치한 manjaro에서 `undefined reference to symbol 'SDL_JoystickNumAxes'` 오류가 나면서 도저히 해결을 할 수 없었다.

OCamlSdl2 소스코드를 다운 받아서 다시 빌드해보면 어떨까 생각해서 아래와 같이 삽질을 했다.

## 추가확인

`sdl2-config` 스크립트 안에 보면 `--static-libs` 관련한 구문이 주석처리되어있다. 그걸 풀어버리면 된다. 근데 이걸 주석처리한 이유가 있지않을까 싶다.

## 추가확인 2

`dune` 파일을 고치면 된다. 

```
(executable
 (public_name sdl2_tutorial)
 (name main)
 (link_flags -cclib -lSDL2)
 (libraries sdl2 sdl2_img sdl2_tutorial))

```

`(link_flags -cclib -lSDL2)`을 넣으면 모두 해결 됨.

## 수동 빌드 배포

설치된 ocamlsdl2 를 삭제하고 git에서 받은 소스로 다시 설치해보았다.

```
opam uninstall ocamlsdl2
```

이러니까  `ocamlsdl2-image`, `ocamlsdl2-ttf` 가 같이 삭제되었다. opam에서 의존성이 잡혀있나보다. 하지만, 다운받은 `ocamlsdl2`에는 해당 모듈이 없다. 

### Github 소스 다운로드 빌드

```
git clone https://github.com/fccm/OCamlSDL2.git
``` 

## Makefile 확인

`Makefile` 중에 아래와 같은 줄이 눈에 띄었다.

```
LIBS_ = $(shell sdl2-config --static-libs)
```

`sdl2-config`에 관련해서는 옵션이 없다. 그래서 아래와 같이 고쳤다.

```
LIBS_ = $(shell sdl2-config --libs)
```

### 수동 빌드

해당 경로의 `opam` 파일을 열어보면 컴파일 하는 내용이 자세히 써있다. Linux에서 컴파일할 것이기때문에 Makefile에 대한 config부터 만들고 시작한다.

```
cp ./src/Makefile.config.unix ./src/Makefile.config
make -C src gen
make -C src dep
make -C src opt
make -C src byte
make -C src findinstall
make -C src findinstall_h
```

### 다른 의존성 설치

```
opam install ocamlsdl2-image ocamlsdl2-ttf 
```

## 기타 할 일들

`~/.opam/4.13.1/lib/stublibs` 에 혹시 파일이 있다면 삭제가 안될 수 있다. 배포가 안된다면 해당 폴더안의 내용을 지우자.

`*. so` 파일이 있음에도 불구하고 `ld.so.conf` 안잡혀있다고 경고가 나온다. 이걸 잡아줘야하나 현재 고민중이다.
