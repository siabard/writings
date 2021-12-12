# `OCaml`로 SDL 시작하기

## 라이브러리 설치

sdl2를 지원하기위한 몇가지 라이브러리가 있다. 기본적으로 sdl2 바인딩인
`ocamlsdl2`와 부속 모듈인 `ocamlsdl2-image`, `ocamlsdl2-ttf` 가
필요하다. 

```
opam install ocamlsdl2 ocamlsdl2-image ocamlsdl2-ttf`
```

## `dune` 파일 수정

`dune`으로 프로젝트를 다음과 같이 생성한다.

```
dune init proj [프로젝트명]
```

생성하게되면 다음과 같은 디렉토리 구조가 만들어진다.

```
dune init proj sdl2_test
cd sdl2_test
tree
.
├── bin
│   ├── dune
│   ├── main.ml
├── dune-project
├── lib
│   └── dune
├── sdl2_test.opam
└── test
    ├── dune
    └── sdl2_test.ml
```

이와 같이 만들어졌다면 `bin/dune` 파일을 수정해서 sdl2 라이브러리를
넣어주어야한다. 아쉽게도 의존성을 도와주는 기능이 없으니 지금은
에디터에서 직접 내용을 수정하도록 한다.

기존의 내용은 아래와 같다.

```
(executable
 (public_name sdl2_test)
 (name main)
 (libraries sdl2_test))

```

이 내용에 sdl2 관련 모듈을 넣는다.

```
(executable
 (public_name sdl2_test)
 (name main)
 (libraries sdl2 sdl2_ttf sdl2_img sdl2_test))

```

이 부분애눈 주의할 있다. 예를 들어 `ocamlsdl2`를 `dune`을 통해
설치했는데 라이브러리에는 `sdl2`라고만 쓰게된다. 마찬가지로
`ocamlsdl2-image`는 `sdl2_img`, `ocamlsdl2-ttf`는 `sdl2_ttf` 라는
이름을 쓴다.

다음과 같은 명령어로 실제로 `ocamlsdl2`가 `sdl2`로 설치되었음을 확인할 수 있다.

```
ocamlfind query sdl2
```

TODO : opam으로 설치된 모듈이 정확히 어떤 이름으로 쓰일지 아는 방법이 필요함.


## 기본 버전 만들기

이제 `main.ml` 파일에 기본 루틴을 넣는다.

```
open Sdl
open Sdlevent


let rec event_loop () =
  match Event.poll_event () with
  | None -> ()
  | Some Quit _ ->
    Sdl.quit();
    exit 0
  | _ -> event_loop ()
      

let main () =
  let width, height = (640, 480) in
  Sdl.init [`VIDEO];
  let window = Sdlwindow.create2
      ~x:`undefined ~y:`undefined
      ~width ~height
      ~title:"SDL2 tutorial"
      ~flags:[Window.Resizable]
  in
  let surf = Sdlwindow.get_surface window in
  let color = 0x00BB00_l in
  let rect = Sdlrect.make4 ~x:0 ~y:0 ~w:width ~h:height in
  Sdlsurface.fill_rect ~dst:surf ~rect ~color;
  Sdlwindow.update_surface window;
  let rec main_loop () =
    event_loop ();
    Sdlwindow.update_surface window;
    main_loop ()
  in
  main_loop ()

let () = main ()

```

### 이벤트 핸들러

### Surface 만들기

### 메인 루프
