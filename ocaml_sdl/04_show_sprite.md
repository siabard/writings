# Sprite 출력하기

이제 SDL_Image를 통해 이미지를 읽어들여 화면에 출력해보자.

그러기위해서는 두가지 일을 할 것이다.

먼저 Window에 대한 renderer를 만들 것이고, 해당 renderer를 이용해
이미지를 읽어들여 Texture를 생성하도록 한다.

## Renderer 만들기 

Renderer는 Window 생성시 만들 수 있다.

```
  let window = Sdlwindow.create2
      ~x:`undefined ~y:`undefined
      ~width ~height
      ~title:"SDL2 tutorial"
      ~flags:[Window.Resizable]
  in
  let renderer =
    Render.create_renderer ~win:window ~index:(-1) ~flags:[Render.Accelerated]
  in
  ...
```

위에서 볼 수 있듯이 윈도, 인덱스, 플래그 정보를 넣으면 Renderer를 만들 수 있다.

## 이미지 읽어들여 Texture만들기

Renderer를 이용해 파일을 읽어들인다. 이때 RWops 를 이용해 파일을
읽어들이고, 이를 파라미터로 옮겨, surface와 texture를 각각 만든다.

```
let load_sprite renderer filename =
  let rw = RWops.from_file ~filename ~mode:"rb" in
  let surf = Image.load_png_rw rw in
  let tex = Texture.create_from_surface renderer surf in
  Surface.free surf;
  (tex)
```

## rendering 루틴 만들기

생성한 텍스쳐를 rendering 헬퍼 함수로 옮겨 화면에 노출시킨다.

```
  let sprite = load_sprite renderer "resources/sprites/godot.png" in
  let render renderer =
    Render.clear renderer;
    Render.set_scale renderer (1.0, 1.0);
    Render.copy renderer ~texture:sprite
      ~src_rect:(Rect.make4 ~x:0 ~y:0 ~w:64 ~h:64)
      ~dst_rect:(Rect.make4 ~x:100 ~y:100 ~w:64 ~h:64)
      ();
    Render.render_present renderer;
  in
```

해당 헬퍼 함수는 main_loop에서 동작시킨다.

```
  let rec main_loop () =
    event_loop ();
    render renderer;
    main_loop ()
  in
```

이를 전체 소스로 보면 다음과 같다.

```
open Sdl
open Sdlevent
module Image = Sdlimage

let event_loop () =
  match Event.poll_event () with
  | None -> ()
  | Some Quit _ ->
    Sdl.quit();
    exit 0
  | _ -> ()


let load_sprite renderer filename =
  let rw = RWops.from_file ~filename ~mode:"rb" in
  let surf = Image.load_png_rw rw in
  let tex = Texture.create_from_surface renderer surf in
  Surface.free surf;
  (tex)
  

let main () =
  let width, height = (640, 480) in
  Sdl.init [`VIDEO];
  Sdlimage.init [`PNG];
  let window = Sdlwindow.create2
      ~x:`undefined ~y:`undefined
      ~width ~height
      ~title:"SDL2 tutorial"
      ~flags:[Window.Resizable]
  in
  let renderer =
    Render.create_renderer ~win:window ~index:(-1) ~flags:[Render.Accelerated]
  in
  let sprite = load_sprite renderer "resources/sprites/godot.png" in
  let render renderer =
    Render.clear renderer;
    Render.set_scale renderer (1.0, 1.0);
    Render.copy renderer ~texture:sprite
      ~src_rect:(Rect.make4 ~x:0 ~y:0 ~w:64 ~h:64)
      ~dst_rect:(Rect.make4 ~x:100 ~y:100 ~w:64 ~h:64)
      ();
    Render.render_present renderer;
  in
  let rec main_loop () =
    event_loop ();
    render renderer;
    main_loop ()
  in
  main_loop ()

let () = main ()
```

PNG, JPG 등을 열기 위해서는 SDL_image 모듈의 도움이 필요하다는 것을
알아두면 좋다.
