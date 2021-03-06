(* This file is part of 'travesty'.

   Copyright (c) 2018, 2019 by Matt Windsor

   Permission is hereby granted, free of charge, to any person obtaining a
   copy of this software and associated documentation files (the "Software"),
   to deal in the Software without restriction, including without limitation
   the rights to use, copy, modify, merge, publish, distribute, sublicense,
   and/or sell copies of the Software, and to permit persons to whom the
   Software is furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
   THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
   FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
   DEALINGS IN THE SOFTWARE. *)

(** Mapping for containers with two element types.

    [Bi_mappable] implements the Haskell notion of a bifunctor: a container
    that contains two distinct element types, both of which can be
    non-monadically, covariantly mapped over.

    Common examples include:

    - maps and associative lists, where the two types are keys and values;
    - result types, where the two types are success and failure. *)

open Base

(** {2 Signatures}

    For input and output signatures for this module's functors, see
    {{!Bi_mappable_types} Bi_mappable_types}. *)

(** {2 Making full bi-mappable type modules}

    These functors build full implementations of bi-mappability given the
    basic minimal definitions above. *)

(** [Make2] implements {{!Bi_mappable_types.S2} S2} for an arity-2
    bi-mappable container. *)
module Make2 (I : Bi_mappable_types.Basic2) :
  Bi_mappable_types.S2 with type ('l, 'r) t = ('l, 'r) I.t

(** [Make1_left] implements {{!Bi_mappable_types.S1_left} S1_left} for an
    arity-1 bi-mappable container with floating left type. *)
module Make1_left (I : Bi_mappable_types.Basic1_left) :
  Bi_mappable_types.S1_left with type 'l t = 'l I.t and type right = I.right

(** [Make1_right] implements {{!Bi_mappable_types.S1_right} S1_right} for an
    arity-1 bi-mappable container with floating right type. *)
module Make1_right (I : Bi_mappable_types.Basic1_right) :
  Bi_mappable_types.S1_right with type 'r t = 'r I.t and type left = I.left

(** [Make0] implements {{!Bi_mappable_types.S0} S0} for an arity-0
    bi-mappable container. *)
module Make0 (I : Bi_mappable_types.Basic0) :
  Bi_mappable_types.S0
    with type t = I.t
     and type left = I.left
     and type right = I.right

(** {2:fix Fixing types}

    We can convert arity-2 modules to arity-1 modules, and arity-1 modules to
    arity-0 modules, by fixing types. The various [FixX_Y] functors achieve
    this. *)

(** {3 Arity-2} *)

(** [Fix2_left (I) (Left)] fixes the left type of [I] to [Left], making it an
    {{!Bi_mappable_types.S1_right} S1_right}. *)
module Fix2_left (I : Bi_mappable_types.Basic2) (Left : T) :
  Bi_mappable_types.S1_right
    with type 'r t = (Left.t, 'r) I.t
     and type left = Left.t

(** [Fix2_right (S) (Left)] fixes the right type of [S] to [Right], making it
    an {{!Bi_mappable_types.S1_left} S1_left}. *)
module Fix2_right (I : Bi_mappable_types.Basic2) (Right : T) :
  Bi_mappable_types.S1_left
    with type 'l t = ('l, Right.t) I.t
     and type right = Right.t

(** [Fix2_both (S) (Left) (Right)] fixes the types of [S] to [Left] and
    [Right], making it an {{!Bi_mappable_types.S0} S0}. *)
module Fix2_both (I : Bi_mappable_types.Basic2) (Left : T) (Right : T) :
  Bi_mappable_types.S0
    with type t = (Left.t, Right.t) I.t
     and type left = Left.t
     and type right = Right.t

(** {3 Arity-1} *)

(** [Fix1_left (S) (Left)] fixes the floating left type of [S] to [Left],
    making it an {{!Bi_mappable_types.S0} S0}. *)
module Fix1_left (I : Bi_mappable_types.Basic1_left) (Left : T) :
  Bi_mappable_types.S0
    with type t = Left.t I.t
     and type left = Left.t
     and type right = I.right

(** [Fix1_right (I) (Right)] fixes the floating right type of [S] to [Right],
    making it an {{!Bi_mappable_types.S0} S0}. *)
module Fix1_right (I : Bi_mappable_types.Basic1_right) (Right : T) :
  Bi_mappable_types.S0
    with type t = Right.t I.t
     and type left = I.left
     and type right = Right.t

(** {2 Converting bi-mappable modules to mappable modules}

    By ignoring values of either the left or the right type, we can derive
    {{!Mappable} mappable} modules from bi-mappable ones. Since the various
    [S] {i n} signatures contain functions for doing this on an ad-hoc basis,
    the functors below are mainly for use when one needs actual {{!Mappable}
    Mappable} instances.

    This reflects the 'clowns to the left of me, jokers to the right' (the
    technical term!) set-up in Haskell; each [Map_leftX] functor implements a
    {{:http://hackage.haskell.org/package/bifunctors/docs/Data-Bifunctor-Clown.html}
    Clown}; each [Map_rightX] functor implements a a
    {{:http://hackage.haskell.org/package/bifunctors/docs/Data-Bifunctor-Joker.html}
    Joker}.

    Since, unlike Haskell, we can't partially apply type constructors in
    OCaml, there are no arity-2 conversions available, and the arity-1
    conversions only work if their direction is the one with a floating type.
    To rectify this, use {{!section:fix} Fix2_left and friends}. *)

(** {3 Arity-1} *)

(** Mapping over the left type of an arity-1 bi-mappable container with a
    floating left type. *)
module Map1_left (S : Bi_mappable_types.S1_left) :
  Mappable_types.S1 with type 'l t = 'l S.t

(** Mapping over the right type of an arity-1 bi-mappable container with a
    floating right type. *)
module Map1_right (S : Bi_mappable_types.S1_right) :
  Mappable_types.S1 with type 'r t = 'r S.t

(** {3 Arity-0} *)

(** Mapping over the left type of an arity-0 bi-mappable container. *)
module Map0_left (S : Bi_mappable_types.S0) :
  Mappable_types.S0 with type t = S.t and type elt = S.left

(** Mapping over the right type. of an arity-0 bi-mappable container. *)
module Map0_right (S : Bi_mappable_types.S0) :
  Mappable_types.S0 with type t = S.t and type elt = S.right

(** {2 Chaining containers} *)

(** {3 Chaining a mappable on the outside of a bi-mappable}

    These functors let us compose an inner bi-mappable container with an
    outer mappable container, producing a bi-map.

    For example, we can make {{!Travesty_base_exts.Alist} associative lists}
    bi-mappable by composing a bi-map over {{!Travesty_base_exts.Tuple2}
    pairs} [(a * b)] with a map over {{!Travesty_base_exts.List} lists}.

    In Haskell terms, this is a
    {{:http://hackage.haskell.org/package/bifunctors/docs/Data-Bifunctor-Tannen.html}
    Tannen}. *)

(** [Chain_Bi2_Map1 (Bi) (Map)] composes a bi-map [Bi] on an inner arity-2
    container over a map [Map] over an outer arity-1 container. *)
module Chain_Bi2_Map1 (Bi : Bi_mappable_types.S2) (Map : Mappable_types.S1) :
  Bi_mappable_types.S2 with type ('l, 'r) t = ('l, 'r) Bi.t Map.t

(** [Chain_Bi1_left_Map1 (Bi) (Map)] composes a bi-map [Bi] on an inner
    arity-1 container with floating left type over a map [Map] over an outer
    arity-1 container. *)
module Chain_Bi1_left_Map1
    (Bi : Bi_mappable_types.S1_left)
    (Map : Mappable_types.S1) :
  Bi_mappable_types.S1_left
    with type 'l t = 'l Bi.t Map.t
     and type right = Bi.right

(** [Chain_Bi1_right_Map1 (Bi) (Map)] composes a bi-map [Bi] on an inner
    arity-1 container with floating right type over a map [Map] over an outer
    arity-1 container. *)
module Chain_Bi1_right_Map1
    (Bi : Bi_mappable_types.S1_right)
    (Map : Mappable_types.S1) :
  Bi_mappable_types.S1_right
    with type 'r t = 'r Bi.t Map.t
     and type left = Bi.left

(** [Chain_Bi0_Map1 (Bi) (Map)] composes a bi-map [Bi] on an inner arity-0
    container over a map [Map] over an outer arity-1 container. *)
module Chain_Bi0_Map1 (Bi : Bi_mappable_types.S0) (Map : Mappable_types.S1) :
  Bi_mappable_types.S0
    with type t = Bi.t Map.t
     and type left = Bi.left
     and type right = Bi.right

(** {3 Chaining mappables on the inside of a bi-mappable}

    These functors let us compose one or two inner mappable containers with
    an outer bi-mappable container, producing a bi-mappable.

    In Haskell terms, this is a
    {{:http://hackage.haskell.org/package/bifunctors/docs/Data-Bifunctor-Biff.html}
    Biff}. *)

(** [Chain_Map1_Bi2 (LMap) (RMap) (Bi)] composes an inner arity-1 map [LMap]
    on the left, and another such map [RMap] on the right, of an arity-2
    bi-traversal [Bi]. *)
module Chain_Map1_Bi2
    (LMap : Mappable_types.S1)
    (RMap : Mappable_types.S1)
    (Bi : Bi_mappable_types.Basic2) :
  Bi_mappable_types.S2 with type ('l, 'r) t = ('l LMap.t, 'r RMap.t) Bi.t

(** [Chain_Map1_Bi1_left (LMap) (Bi)] composes an inner arity-1 map [LMap] on
    the left of an arity-1 bi-map [Bi] with floating left type. *)
module Chain_Map1_Bi1_left
    (LMap : Mappable_types.S1)
    (Bi : Bi_mappable_types.Basic1_left) :
  Bi_mappable_types.S1_left
    with type 'l t = 'l LMap.t Bi.t
     and type right = Bi.right

(** [Chain_Map1_Bi1_right (RMap) (Bi)] composes an inner arity-1 map [LMap]
    on the right of an arity-1 bi-map [Bi] with floating right type. *)
module Chain_Map1_Bi1_right
    (RMap : Mappable_types.S1)
    (Bi : Bi_mappable_types.Basic1_right) :
  Bi_mappable_types.S1_right
    with type 'r t = 'r RMap.t Bi.t
     and type left = Bi.left
