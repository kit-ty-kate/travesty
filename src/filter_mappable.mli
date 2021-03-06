(* This file is part of 'travesty'.

   Copyright (c) 2018 by Matt Windsor

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

(** Simultaneous mapping and filtering.

    [Filter_mappable] contains signatures and extensions for types that can
    be non-monadically mapped over, while simultaneously removing values. *)

(** {2 Signatures}

    For input and output module signatures for this module's functors, see
    {{!Filter_mappable_types} Filter_mappable_types}. *)

(** {2 Making full instances from basic ones} *)

(** [Make0] makes an {{!Filter_mappable_types.S0} S0} from a
    {{!Filter_mappable_types.Basic0} Basic0}. *)
module Make0 (F : Filter_mappable_types.Basic0) :
  Filter_mappable_types.S0 with type t := F.t and type elt := F.elt

(** [Make0] makes an {{!Filter_mappable_types.S1} S1} from a
    {{!Filter_mappable_types.Basic1} Basic1}. *)
module Make1 (F : Filter_mappable_types.Basic1) :
  Filter_mappable_types.S1 with type 'a t := 'a F.t

(** {2 Deriving Mappable} *)

(** [To_mappable0] lowers a filter-mappable arity-0 type to a mappable one. *)
module To_mappable0 (F : Filter_mappable_types.Basic0) :
  Mappable_types.S0 with type t := F.t and type elt := F.elt

(** [To_mappable1] lowers a filter-mappable arity-1 type to a mappable one. *)
module To_mappable1 (F : Filter_mappable_types.Basic1) :
  Mappable_types.S1 with type 'a t := 'a F.t
