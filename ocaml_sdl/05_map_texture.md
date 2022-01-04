# TextureMap 만들기

Texture를 읽어 들여서 출력이 가능하다면, 이를 집단으로 묶는 것도 필요하다. 다양한 Texture를 관리해야 이후에 필요한 경우 해당하는 Texture를 꺼내 쓰는데 어려움이 없다.

일단 OCaml에서는 Map을 지원한다.

```
module SpriteMap = Map.Make(String)
```

이 방법은 꽤 신선한데, Functor라고 불리우는 방법이다. (혹은 module function이라고도 한다.)

위와 같이 선언하게되면, Map을 이용해 key의 타입을 String으로 사용하고 값은 다형성 값으로 설정된다.

이제 `load_sprite`를 수정해서 Map에 새로운 Texture를 추가하는 함수로 바꾼다.

```
let load_sprite renderer sprite_map id  filename =
  let rw = RWops.from_file ~filename ~mode:"rb" in
  let surf = Image.load_png_rw rw in
  let tex = Texture.create_from_surface renderer surf in
  let sprite_map = SpriteMap.add id tex sprite_map in
  Surface.free surf;
  (sprite_map)
```

해당하는 스프라이트 로딩 루틴이 생겼으니, render하는 방식도 변경해준다.

```
  let sprite_map = SpriteMap.empty in
  let sprite_map = load_sprite renderer sprite_map "key1" "resources/sprites/godot.png" in
  let render renderer =
    Render.clear renderer;
    Render.set_scale renderer (1.0, 1.0);
    Render.copy renderer ~texture:(SpriteMap.find "key1" sprite_map)
      ~src_rect:(Rect.make4 ~x:0 ~y:0 ~w:16 ~h:16)
      ~dst_rect:(Rect.make4 ~x:100 ~y:100 ~w:32 ~h:32)
      ();
    Render.render_present renderer;
```

위에서 보이는 것처럼 초기 Map을 empty로 선언하고, 그 이후에 필요한 파일을 읽어들여 Map으로 구성하였다. render할 때는 `find`를 이용해 필요한 Texture를 꺼낼 수 있도록 변경하였다.


