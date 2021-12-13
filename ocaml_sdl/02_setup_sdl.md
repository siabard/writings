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


let event_loop () =
  match Event.poll_event () with
  | None -> ()
  | Some Quit _ ->
    Sdl.quit();
    exit 0
  | _ ->  ()
      

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

이벤트 핸들러는 `Sdl_event.poll_event`를 통해 들어온 이벤트에 따라
어떤 일을 할 것인지를 정한다. 위의 예제에서 이벤트 핸들러를 살펴보자.

```
let event_loop () =
  match Event.poll_event () with
  | None -> ()
  | Some Quit _ ->
    Sdl.quit();
    exit 0
  | _ ->  ()
      
```

여기에서 이벤트 핸들러가 확인하는 이벤트는 `Some Quit _` 뿐이다. 이
이벤트가 들어오면 프로그램을 종료하며, `Sdl`을 끝낸다.

이벤트 핸들러는 이 뿐 아니라, 키보드, 마우스, 햅틱 등도 처리한다.

### Surface 만들기

`Surface`는 렌더링이 일어나는 부분이다. 

```
  let surf = Sdlwindow.get_surface window in
  let color = 0x00BB00_l in
  let rect = Sdlrect.make4 ~x:0 ~y:0 ~w:width ~h:height in
  Sdlsurface.fill_rect ~dst:surf ~rect ~color;
  Sdlwindow.update_surface window;
```

생성된 `Window`에서 `get_surface`를 통해 Surface를 얻는데, 여기에 직접
그림을 그릴 수 있다. 사실 이 방법 보다는 Renderer를 생성하여 렌더링을
하는 편이 훨씬 더 효과적이다. 이 방법은 나중에 알아본다.

### 메인 루프

OCaml에서 루프를 하는 방법은 여러 가지가 있지만 여기에서는 Tail Call
Recursion (꼬리 재귀 호출)을 이용했다.

```
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
```

재귀 호출은 `main_loop`를 통해서 일어나며 이벤트 핸들러, Window
Surface의 update 등을 처리한다. 

## 정리

이렇게 OCaml에서 SDL을 이용하여 간단한 화면 그리기 예제를 만들었다. 다음에는 Renderer와 Texture를 통해 이미지를 노출하는 방법을 알아본다.
