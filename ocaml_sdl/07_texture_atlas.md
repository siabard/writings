# Texture Atlas

개별 스프라이트를 여러 개의 이미지로 나눠서 읽어들이는 대신, 하나의 큰
이미지로 읽어들여, 이것을 잘라서 쓰는 것이 효과적이다. 

사용할 이미지를 일정한 크기의 타일로 자른다고 가정하고, 생성한 영역에 맞게 이미지를 노출시키면 된다.

일정한 타일을 만드는 것은 아래와 같이 `Array`를 이용해 만든다.

```
let make_atlas width height tile_width tile_height =
  let num_x = width / tile_width in
  let num_y = height / tile_height in
  let length = num_x * num_y in
  let atlas = Array.make length {x = 0; y = 0; w = tile_width; h = tile_height } in
  for ny = 0 to num_y - 1 do
    for nx = 0 to num_x - 1 do
      atlas.(ny * num_x + nx) <- {x = nx * tile_width; y = ny * tile_height; w = tile_width; h = tile_height}
    done;
  done;
  atlas
```


해당하는 영역을 렌더링을 하면 된다.

```
let main () =
  ...
  let atlas = make_atlas 96 96 16 16 in
  let first_atlas = atlas.(0) in
  let render renderer =
    Render.clear renderer;
    Render.set_scale renderer (1.0, 1.0);
    Render.copy renderer ~texture:(SpriteMap.find "key1" sprite_map)
      ~src_rect:(Rect.make4 ~x:first_atlas.x ~y:first_atlas.y ~w:16 ~h:16)
      ~dst_rect:(Rect.make4 ~x:100 ~y:100 ~w:32 ~h:32)
      ();
    Render.render_present renderer;
  in
  ...
```

위에서 볼 수 있는 것처럼, 먼저 atlas를 생성해 텍스쳐의 위치를 미리 결정해놓고, 나중에 이 텍스쳐의 특정 위치만 렌더링 시에만 이용하면 된다.
