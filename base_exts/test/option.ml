open Stdio
open Travesty_base_exts.Option

let%test_module "map" = (module struct
  let%expect_test "behaves properly: Some" =
    print_s
      Base.([%sexp (map ~f:(fun x -> x * x) (Some 12) : int option)]) ;
    [%expect {| (144) |}]

  let%expect_test "behaves properly: None" =
    print_s Base.([%sexp (map ~f:(fun x -> x * x) None : int option)]) ;
    [%expect {| () |}]
end)

let%test_module "count" = (module struct
  let%expect_test "behaves properly: Some/yes" =
    print_s
      Base.([%sexp (count ~f:Base.Int.is_positive (Some 42) : int)]) ;
    [%expect {| 1 |}]

  let%expect_test "behaves properly: Some/no" =
    print_s Base.([%sexp (count ~f:Int.is_positive (Some (-42)) : int)]) ;
    [%expect {| 0 |}]
end)

let%test_module "map_m" = (module struct
  module M = On_monad (Base.Option)
  let%expect_test "returning identity on Some/Some" =
    print_s
      Base.(
        [%sexp
          (M.map_m ~f:Base.Option.some (Some "hello") : string option option)]) ;
    [%expect {| ((hello)) |}]
end)

let%test_module "exclude" = (module struct
  let%expect_test "Some -> None" =
    print_s
      Base.([%sexp (exclude (Some 9) ~f:Int.is_positive : int option)]) ;
    [%expect {| () |}]

  let%expect_test "Some -> Some" =
    print_s
      Base.([%sexp (exclude (Some 0) ~f:Int.is_positive : int option)]) ;
    [%expect {| (0) |}]
end)

let%test_module "first_some_of_thunks" = (module struct
  let%expect_test "short-circuiting" =
    print_s
      Base.(
        [%sexp
          ( first_some_of_thunks
              [ Fn.const None
              ; Fn.const (Some "hello")
              ; Fn.const (Some "world")
              ; (fun () -> failwith "this shouldn't happen") ]
            : string option )]) ;
    [%expect {| (hello) |}]
end)

let%test_module "value_f" = (module struct
  let default_f () =
    printf "*** EVALUATED ***\n";
    42

  let%expect_test "option is Some" =
    printf "%d\n" (value_f ~default_f (Some 64));
    [%expect {||}]

  let%expect_test "option is None" =
    printf "%d\n" (value_f ~default_f None);
    [%expect {||}]

  let%expect_test "multiple evaluations" =
    Base.List.iter [ Some 0; None; Some 118; Some 999; Some 88199; Some 911; Some 9725; None; Some 3 ]
      ~f:(fun x -> printf "%d\n" (value_f ~default_f x));
    [%expect {||}]
end)

let%test_module "value_l" = (module struct
  (* We use a separate lazy instance for each test, to avoid the test results
     becoming dependent on run order. *)
  let default_f () =
    printf "*** EVALUATED ***\n";
    "foo"

  let%expect_test "option is Some" =
    let default_l = Lazy.from_fun default_f in
    printf "%s\n" (value_l ~default_l (Some "bar"));
    [%expect {||}]

  let%expect_test "option is None" =
    let default_l = Lazy.from_fun default_f in
    printf "%s\n" (value_l ~default_l None);
    [%expect {||}]

  let%expect_test "multiple evaluations" =
    let default_l = Lazy.from_fun default_f in
    Base.List.iter [ Some "bread"; Some "eggs"; None; Some "breaded eggs"; None; Some "ham" ]
      ~f:(fun x -> printf "%s\n" (value_l ~default_l (x)));
    [%expect {||}]
end)