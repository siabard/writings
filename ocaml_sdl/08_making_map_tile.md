# Map Tile을 만들기

지난 번 Texture Atlas를 만들었던 방식을 통해 Map Tile을 만들어보자.

먼저 화면의 지도를 구성한다.

```
let stage_1_map = [|
  0; 0; 0; 0; 2; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0;
  0; 0; 1; 1; 2; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0;
  0; 0; 1; 1; 2; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0;
  0; 0; 0; 0; 2; 0; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0;
  0; 0; 0; 0; 2; 2; 2; 0; 1; 3; 1; 0; 0; 1; 1; 1; 1; 0; 0; 0;
  0; 0; 0; 0; 0; 0; 2; 0; 0; 1; 1; 0; 0; 0; 0; 2; 2; 0; 0; 0;
  0; 0; 0; 0; 0; 0; 2; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0;
  0; 0; 0; 0; 0; 0; 2; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0;
  0; 0; 0; 0; 0; 0; 2; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0;
  0; 0; 0; 0; 0; 0; 2; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0;
  0; 0; 0; 0; 0; 2; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0;
  0; 0; 0; 0; 0; 2; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0;
  0; 0; 0; 0; 0; 2; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0;
  0; 0; 0; 0; 0; 2; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0;
  0; 0; 0; 0; 0; 2; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0;
|]
```

이 지도에 등록된 정수값은 지도용 Atlas의 인덱스 값이다.

이제 지도를 출력할 함수를 만든다.

```
let render_map renderer sprite_map map_atlas =

  for my = 0 to (480/32) - 1 do
    for mx = 0 to (640/32) - 1 do
      let map_tile_num = stage_1_map.(my * (640/32) + mx) in
      let map_tile = map_atlas.(map_tile_num) in
      Render.copy renderer ~texture:(SpriteMap.find "map" sprite_map)
        ~src_rect:(Rect.make4 ~x:map_tile.x ~y:map_tile.y ~w: 16 ~h: 16)
        ~dst_rect:(Rect.make4 ~x:(mx*32) ~y:(my*32) ~w:32 ~h:32)
        ()
    done;
  done;
  ()
```

등록된 함수를 메인 루프에서 실행하면 지도가 출력된다.

```
let main () =
  ...
  let sprite_map = SpriteMap.empty in
  let sprite_map = load_sprite renderer sprite_map "key1" "resources/sprites/godot.png" in
  let sprite_map = load_sprite renderer sprite_map "map" "resources/world/map.png" in
  let atlas = make_atlas 96 96 16 16 in
  let map_atlas = make_atlas 64 16 16 16 in
  let first_atlas = atlas.(0) in
  let render renderer =
    Render.clear renderer;
    Render.set_scale renderer (1.0, 1.0);
    render_map renderer sprite_map map_atlas;
    Render.copy renderer ~texture:(SpriteMap.find "key1" sprite_map)
      ~src_rect:(Rect.make4 ~x:first_atlas.x ~y:first_atlas.y ~w:16 ~h:16)
      ~dst_rect:(Rect.make4 ~x:100 ~y:100 ~w:32 ~h:32)
      ();
    Render.render_present renderer;
  in
  let rec main_loop () =
    event_loop ();
    render renderer;
    main_loop ()
  in
  main_loop ()
```
