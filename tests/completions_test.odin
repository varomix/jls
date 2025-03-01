package tests

import "core:testing"
import "core:fmt"

import test "shared:testing"

@(test)
ast_simple_struct_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test

		My_Struct :: struct {
			one: int,
			two: int,
			three: int,
		}

		main :: proc() {
			my_struct: My_Struct;
			my_struct.{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(
		t,
		&source,
		".",
		{"My_Struct.one: int", "My_Struct.two: int", "My_Struct.three: int"},
	)
}

@(test)
ast_index_array_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test

		My_Struct :: struct {
			one: int,
			two: int,
			three: int,
		}

		main :: proc() {
			my_struct: [] My_Struct;
			my_struct[2].{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(
		t,
		&source,
		".",
		{"My_Struct.one: int", "My_Struct.two: int", "My_Struct.three: int"},
	)
}

@(test)
ast_index_dynamic_array_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test

		My_Struct :: struct {
			one: int,
			two: int,
			three: int,
		}

		main :: proc() {
			my_struct: [dynamic] My_Struct;
			my_struct[2].{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(
		t,
		&source,
		".",
		{"My_Struct.one: int", "My_Struct.two: int", "My_Struct.three: int"},
	)
}

@(test)
ast_struct_pointer_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test

		My_Struct :: struct {
			one: int,
			two: int,
			three: int,
		}

		main :: proc() {
			my_struct: ^My_Struct;
			my_struct.{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(
		t,
		&source,
		".",
		{"My_Struct.one: int", "My_Struct.two: int", "My_Struct.three: int"},
	)
}

@(test)
ast_struct_take_address_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test

		My_Struct :: struct {
			one: int,
			two: int,
			three: int,
		}

		main :: proc() {
			my_struct: My_Struct;
			my_pointer := &my_struct;
			my_pointer.{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(
		t,
		&source,
		".",
		{"My_Struct.one: int", "My_Struct.two: int", "My_Struct.three: int"},
	)
}

@(test)
ast_struct_deref_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test

		My_Struct :: struct {
			one: int,
			two: int,
			three: int,
		}

		main :: proc() {
			my_struct: ^^My_Struct;
			my_deref := my_struct^;
			my_deref.{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(
		t,
		&source,
		".",
		{"My_Struct.one: int", "My_Struct.two: int", "My_Struct.three: int"},
	)
}

@(test)
ast_range_map :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test

		My_Struct :: struct {
			one: int,
			two: int,
			three: int,
		}

		main :: proc() {
			my_map: map[int]My_Struct;
			
			for key, value in my_map {
				value.{*}
			}

		}
		`,
		packages = {},
	}

	test.expect_completion_details(
		t,
		&source,
		".",
		{"My_Struct.one: int", "My_Struct.two: int", "My_Struct.three: int"},
	)
}

@(test)
ast_range_array :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test

		My_Struct :: struct {
			one: int,
			two: int,
			three: int,
		}

		main :: proc() {
			my_array: []My_Struct;
			
			for value in my_array {
				value.{*}
			}

		}
		`,
		packages = {},
	}

	test.expect_completion_details(
		t,
		&source,
		".",
		{"My_Struct.one: int", "My_Struct.two: int", "My_Struct.three: int"},
	)
}

@(test)
ast_completion_identifier_proc_group :: proc(t: ^testing.T) {

	source := test.Source {
		main = `package test

		My_Int :: distinct int;

		distinct_function :: proc(a: My_Int, c: int) {
		}

		int_function :: proc(a: int, c: int) {
		}

		group_function :: proc {
			int_function,
			distinct_function,
		};

		main :: proc() {
			grou{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(
		t,
		&source,
		"",
		{"test.group_function: proc"},
	)
}

@(test)
ast_completion_in_comp_lit_type :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test

		My_Struct :: struct {
			one: int,
			two: int,
			three: int,
		}

		main :: proc() {
			my_comp := My_{*} {
			};
		}
		`,
		packages = {},
	}

	test.expect_completion_details(t, &source, "", {"test.My_Struct: struct"})
}

@(test)
ast_completion_range_struct_selector_strings :: proc(t: ^testing.T) {

	source := test.Source {
		main = `package test

		My_Struct :: struct {
			array: []string,
		}

		main :: proc() {
			my_struct: My_Struct;
	
			for value in my_struct.array {
				val{*}
			}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(t, &source, "", {"test.value: string"})
}

@(test)
ast_completion_selector_on_indexed_array :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test

		My_Foo :: struct {
			a: int,
			b: int,
		}

		My_Struct :: struct {
			array: []My_Foo,
		}

		main :: proc() {
			my_struct: My_Struct;
	
			my_struct.array[len(my_struct.array)-1].{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(
		t,
		&source,
		".",
		{"My_Foo.a: int", "My_Foo.b: int"},
	)
}

@(test)
index_package_completion :: proc(t: ^testing.T) {

	packages := make([dynamic]test.Package)

	append(
		&packages,
		test.Package{
			pkg = "my_package",
			source = `package my_package
		My_Struct :: struct {
			one: int,
			two: int,
			three: int,
		}
		`,
		},
	)

	source := test.Source {
		main     = `package test

		import "my_package"

		main :: proc() {	
            my_package.{*}
		}
		`,
		packages = packages[:],
	}

	test.expect_completion_details(
		t,
		&source,
		".",
		{"my_package.My_Struct: struct"},
	)
}

import "core:odin/ast"
import "core:odin/parser"

@(test)
ast_generic_make_slice :: proc(t: ^testing.T) {

	source := test.Source {
		main = `package test
		Allocator :: struct {

		}
		Context :: struct {
			allocator: Allocator,
		}
		make_slice :: proc($T: typeid/[]$E, auto_cast len: int, allocator := context.allocator, loc := #caller_location) -> (T, Allocator_Error) #optional_second {
		}

		My_Struct :: struct {
			my_int: int,
		}

		main :: proc() {
			my_slice := make_slice([]My_Struct, 23);
			my_slic{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(
		t,
		&source,
		"",
		{"test.my_slice: []My_Struct"},
	)
}

@(test)
ast_named_procedure_1 :: proc(t: ^testing.T) {

	source := test.Source {
		main = `package test
		proc_a :: proc(a: int, b: int) -> int {
		}

		proc_b :: proc(a: int, b: bool) -> bool {
		}

		my_group :: proc {proc_a, proc_b};

		main :: proc() {
			my_bool := my_group(b = false, a = 2);
			my_boo{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(t, &source, "", {"test.my_bool: bool"})
}

@(test)
ast_named_procedure_2 :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test
		proc_a :: proc(a: int, b: int) -> int {
		}

		proc_b :: proc(a: int, b: bool) -> bool {
		}

		my_group :: proc {proc_a, proc_b};

		main :: proc() {
			my_bool := my_group(b = false);
			my_boo{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(t, &source, "", {"test.my_bool: bool"})
}

@(test)
ast_swizzle_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test
		main :: proc() {
			my_array: [4] f32;
			my_array.{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(
		t,
		&source,
		".",
		{
			"x: f32",
			"y: f32",
			"z: f32",
			"w: f32",
			"r: f32",
			"g: f32",
			"b: f32",
			"a: f32",
		},
	)
}

@(test)
ast_swizzle_completion_one_component :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test
		main :: proc() {
			my_array: [4] f32;
			my_array.x{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(
		t,
		&source,
		".",
		{"xx: [2]f32", "xy: [2]f32", "xz: [2]f32", "xw: [2]f32"},
	)
}

@(test)
ast_swizzle_completion_few_components :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test
		main :: proc() {
			my_array: [2] f32;
			my_array.x{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(
		t,
		&source,
		".",
		{"xx: [2]f32", "xy: [2]f32"},
	)
}


@(test)
ast_swizzle_resolve_one_components :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test
		main :: proc() {
			my_array: [4]f32;
			my_swizzle := my_array.x;
			my_swizz{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(t, &source, "", {"test.my_swizzle: f32"})
}

@(test)
ast_swizzle_resolve_two_components :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test
		main :: proc() {
			my_array: [4]f32;
			my_swizzle := my_array.xx;
			my_swizz{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(t, &source, "", {"test.my_swizzle: [2]f32"})
}

@(test)
ast_swizzle_resolve_one_component_struct_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test
		My_Struct :: struct {
			one: int,
			two: int,
		};
		main :: proc() {
			my_array: [4] My_Struct;
			my_array.x.{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(
		t,
		&source,
		".",
		{"My_Struct.one: int", "My_Struct.two: int"},
	)
}

@(test)
ast_for_in_for_from_different_package :: proc(t: ^testing.T) {
	packages := make([dynamic]test.Package)

	append(
		&packages,
		test.Package{
			pkg = "my_package",
			source = `package my_package
				My_Bar :: struct {
					number: int,
				}
				
				My_Foo :: struct {
					elems: []^My_Bar,
				}			
		`,
		},
	)

	source := test.Source {
		main     = `package test	
		import "my_package"		
		main :: proc() {
			my_foos: []^my_package.My_Foo
			for foo in my_foos {
				for my_bar in foo.elems {
					my_bar.{*}
				}
			}
		}
		`,
		packages = packages[:],
	}

	test.expect_completion_details(t, &source, "", {"My_Bar.number: int"})
}

@(test)
ast_for_in_identifier_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test	
		My_Struct :: struct {
			one: int,
			two: int,
		};
		
		main :: proc() {
		
			my_array: [4]My_Struct;
		
		
			for my_element in my_array {
				my_elem{*}
			}
		
		}
		`,
		packages = {},
	}


	test.expect_completion_details(
		t,
		&source,
		"",
		{"test.my_element: My_Struct"},
	)
}

@(test)
ast_completion_poly_struct_proc :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test	
		RenderPass :: struct(type : typeid) { list : ^int, data : type, }

		LightingAccumPass2 :: struct {
			foo: int,
		}		
		
		execute_lighting_pass2 :: proc(pass : RenderPass(LightingAccumPass2)) {
			pass.{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(t, &source, "", {"RenderPass.list: ^int"})
}

@(test)
ast_generic_make_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test

		make :: proc{
			make_dynamic_array,
			make_dynamic_array_len,
			make_dynamic_array_len_cap,
			make_map,
			make_slice,
		};
		make_slice :: proc($T: typeid/[]$E, auto_cast len: int, loc := #caller_location) -> (T, Allocator_Error) #optional_second {
		}
		make_map :: proc($T: typeid/map[$K]$E, auto_cast cap: int = DEFAULT_RESERVE_CAPACITY, loc := #caller_location) -> T {
		}
		make_dynamic_array :: proc($T: typeid/[dynamic]$E, loc := #caller_location) -> (T, Allocator_Error) #optional_second {		
		}
		make_dynamic_array_len :: proc($T: typeid/[dynamic]$E, auto_cast len: int, loc := #caller_location) -> (T, Allocator_Error) #optional_second {
		}
		make_dynamic_array_len_cap :: proc($T: typeid/[dynamic]$E, auto_cast len: int, auto_cast cap: int, loc := #caller_location) -> (T, Allocator_Error) #optional_second {
		}

		My_Struct :: struct {
			my_int: int,
		}

		main :: proc() {
			allocator: Allocator;
			my_array := make([dynamic]My_Struct, 343);
			my_array[2].{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(t, &source, ".", {"My_Struct.my_int: int"})
}

@(test)
ast_generic_make_completion_2 :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test

		make :: proc{
			make_dynamic_array,
			make_dynamic_array_len,
			make_dynamic_array_len_cap,
			make_map,
			make_slice,
		};
		make_slice :: proc($T: typeid/[]$E, auto_cast len: int, loc := #caller_location) -> (T, Allocator_Error) #optional_second {
		}
		make_map :: proc($T: typeid/map[$K]$E, auto_cast cap: int = DEFAULT_RESERVE_CAPACITY, loc := #caller_location) -> T {
		}
		make_dynamic_array :: proc($T: typeid/[dynamic]$E, loc := #caller_location) -> (T, Allocator_Error) #optional_second {		
		}
		make_dynamic_array_len :: proc($T: typeid/[dynamic]$E, auto_cast len: int, loc := #caller_location) -> (T, Allocator_Error) #optional_second {
		}
		make_dynamic_array_len_cap :: proc($T: typeid/[dynamic]$E, auto_cast len: int, auto_cast cap: int, loc := #caller_location) -> (T, Allocator_Error) #optional_second {
		}

		My_Struct :: struct {
			my_int: int,
		}

		main :: proc() {
			allocator: Allocator;
			my_array := make([]My_Struct, 343);
			my_array[2].{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(t, &source, ".", {"My_Struct.my_int: int"})
}

@(test)
ast_struct_for_in_switch_stmt_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test
		PlatformContext :: struct {
			windows:  [dynamic]Window,
			running:  bool,
		}
		
		platform_context: PlatformContext;
		
		Window :: struct {
			width:      int,
			height:     int,
		}

		main :: proc() {
			switch (message) {
			case win32.WM_SIZE:
				for w in platform_context.windows {
					w.{*}
				}
			}
		}
		`,
	}

	test.expect_completion_details(t, &source, ".", {"Window.height: int"})
}

@(test)
ast_overload_with_autocast_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test

		my_group :: proc{
			with_autocast,
			with_bool,
		};
		with_autocast :: proc(auto_cast a: int) -> bool {
		}
		with_bool :: proc(a: bool) -> int {
		}

		main :: proc() {
			my_uint: uint = 0;
			my_value := my_group(my_uint);
			my_val{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(t, &source, "", {"test.my_value: bool"})
}


@(test)
ast_overload_with_any_int_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test

		my_group :: proc{
			with_any_int,
			with_bool,
		};
		with_any_int :: proc(#any_int a: int) -> bool {
		}
		with_bool :: proc(a: bool) -> int {
		}

		main :: proc() {
			my_uint: uint = 0;
			my_value := my_group(my_uint);
			my_val{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(t, &source, "", {"test.my_value: bool"})
}

@(test)
ast_overload_with_any_int_with_poly_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test

		my_group :: proc{
			with_any_int,
			with_bool,
		};
		with_any_int :: proc($T: typeid/[dynamic]$E, #any_int a: int) -> bool {
		}
		with_bool :: proc($T: typeid/[dynamic]$E, a: bool) -> int {
		}

		main :: proc() {
			my_uint: uint = 0;
			my_value := my_group([dynamic]f32, my_uint);
			my_val{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(t, &source, "", {"test.my_value: bool"})
}


/*
	Wait for odin issue to be done 
@(test)
ast_completion_in_between_struct :: proc(t: ^testing.T) {

	source := test.Source {
		main = `package test

		Format_Decision_State :: struct {
			type: Format_Decision_Type,
			current_token: ^Format_Token,
			previous_token: ^Format_Token,
			line: ^Unwrapped_Line,
			a{*}
			indent: int,
			width: int,
			penalty: f32,
		}
		`,
		packages = {},
	};

	test.expect_completion_details(t, &source, "", {"test.my_value: bool"});
}

*/

@(test)
ast_overload_with_any_int_index_completion :: proc(t: ^testing.T) {
	packages := make([dynamic]test.Package)

	append(
		&packages,
		test.Package{
			pkg = "my_package",
			source = `package my_package
		my_group :: proc{
			with_any_int,
			with_bool,
		};
		with_any_int :: proc($T: typeid/[dynamic]$E, #any_int a: int) -> bool {
		}
		with_bool :: proc($T: typeid/[dynamic]$E, a: bool) -> int {
		}
		`,
		},
	)

	source := test.Source {
		main     = `package test

		import "my_package"

		main :: proc() {
			my_uint: uint = 0;
			my_value := my_package.my_group([dynamic]f32, my_uint);
			my_val{*}
		}
		`,
		packages = packages[:],
	}

	test.expect_completion_details(t, &source, ".", {"test.my_value: bool"})
}


@(test)
ast_package_procedure_completion :: proc(t: ^testing.T) {
	packages := make([dynamic]test.Package)

	append(
		&packages,
		test.Package{
			pkg = "my_package",
			source = `package my_package
		my_proc :: proc() -> bool {
		}
		`,
		},
	)

	source := test.Source {
		main     = `package test

		import "my_package"

		main :: proc() {
			my_package.{*}
		}
		`,
		packages = packages[:],
	}

	test.expect_completion_details(
		t,
		&source,
		".",
		{"my_package.my_proc: proc() -> bool"},
	)
}

@(test)
ast_poly_with_comp_lit_empty_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test
	
		My_Struct :: struct {
			a: int,
		}

		new_type :: proc($T: typeid, pos, end: My_Struct) -> ^T {
		}

		main :: proc() {
			t := new_type(My_Struct, {}, {})
			t.{*}
		}
		`,
		packages = {},
	}

	//FIXME
	//test.expect_completion_details(t, &source, ".", {"my_package.my_proc: proc() -> bool"});
}

@(test)
ast_global_struct_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main

		Foo :: struct { x: int }
		foo := Foo{}
		main :: proc() {
			x := foo.{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(t, &source, ".", {"Foo.x: int"})
}

@(test)
ast_global_non_mutable_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main

		Foo :: struct { x: int }
		main :: proc() {
			x := Foo.{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(t, &source, ".", {})
}

@(test)
ast_basic_value_untyped_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main

		main :: proc() {
			xaa := 2
			xa{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(t, &source, "", {"test.xaa: int"})
}

@(test)
ast_basic_value_binary_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main

		main :: proc() {
			xaa := 2
			xb2 := xaa - 2
			xb{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(t, &source, "", {"test.xb2: int"})
}

@(test)
ast_file_private_completion :: proc(t: ^testing.T) {
	packages := make([dynamic]test.Package)

	append(
		&packages,
		test.Package{
			pkg = "my_package",
			source = `package my_package

		@(private="file") my_proc :: proc() -> bool {
		}
		`,
		},
	)

	source := test.Source {
		main     = `package main
		import "my_package"
		main :: proc() {
			my_package.{*}
		}
		`,
		packages = packages[:],
	}

	test.expect_completion_details(t, &source, ".", {})
}

@(test)
ast_non_mutable_variable_struct_completion :: proc(t: ^testing.T) {
	packages := make([dynamic]test.Package)

	append(
		&packages,
		test.Package{
			pkg = "my_package",
			source = `package my_package
		My_Struct :: struct { a: int }
		Im :: My_Struct;
		`,
		},
	)

	source := test.Source {
		main     = `package main
		import "my_package"
		main :: proc() {
			my_package.{*}
		}
		`,
		packages = packages[:],
	}

	test.expect_completion_details(t, &source, ".", {"my_package.Im: struct"})
}

@(test)
ast_mutable_variable_struct_completion :: proc(t: ^testing.T) {
	packages := make([dynamic]test.Package)

	append(
		&packages,
		test.Package{
			pkg = "my_package",
			source = `package my_package
		My_Struct :: struct { a: int }
		var: My_Struct;
		`,
		},
	)

	source := test.Source {
		main     = `package main
		import "my_package"
		main :: proc() {
			my_package.var.{*}
		}
		`,
		packages = packages[:],
	}

	test.expect_completion_details(t, &source, ".", {"My_Struct.a: int"})
}

@(test)
ast_out_of_block_scope_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		main :: proc() {
			{
				aabb := 2
			}
			aab{*}
		}
		`,
	}

	test.expect_completion_details(t, &source, "", {})
}

@(test)
ast_value_decl_multiple_name_same_type :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		main :: proc() {
			xaaaa, yaaaa: string
			xaaaa = "hi"
			yaaa{*}
		}
		`,
	}

	test.expect_completion_details(t, &source, "", {"test.yaaaa: string"})
}

@(test)
ast_value_decl_comp_lit :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		My_Struct :: struct {
			a: int,
		}
		main :: proc() {
			my_struct := My_Struct {
				a = 2,
			}

			my_struct.{*}
		}
		`,
	}

	test.expect_completion_details(t, &source, ".", {"My_Struct.a: int"})
}

@(test)
ast_multi_pointer_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		main :: proc() {
			faa: [^]int
			fa{*}
		}
		`,
	}

	test.expect_completion_details(t, &source, "", {"test.faa: [^]int"})
}

@(test)
ast_multi_pointer_indexed_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		main :: proc() {
			faa: [^]int
			sap := faa[1]
			sa{*}
		}
		`,
	}

	test.expect_completion_details(t, &source, "", {"test.sap: int"})
}

@(test)
ast_implicit_named_comp_lit_bitset :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		My_Enum :: enum {A, B, C}
		My_Bitset :: bit_set[My_Enum]
		My_Struct :: struct {
			bits: My_Bitset,
		}

		main :: proc() {
			inst := My_Struct {
				bits = {.{*}}
			}
		}
		`,
	}

	test.expect_completion_details(t, &source, ".", {"A", "B", "C"})
}

@(test)
ast_implicit_unnamed_comp_lit_bitset :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		My_Enum :: enum {A, B, C}
		My_Bitset :: bit_set[My_Enum]
		My_Struct :: struct {
			bits: My_Bitset,
			bits_2: My_Bitset,
		}

		main :: proc() {
			inst := My_Struct {
				{.A}, {.{*}},
			}
		}
		`,
	}

	test.expect_completion_details(t, &source, ".", {"A", "B", "C"})
}

@(test)
ast_implicit_unnamed_comp_lit_enum :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		My_Enum :: enum {A, B, C}

		My_Struct :: struct {
			enums: My_Enum,
			enums_2: My_Enum,
		}

		main :: proc() {
			inst := My_Struct {
				.A, .{*}
			}
		}
		`,
	}

	test.expect_completion_details(t, &source, ".", {"A", "B", "C"})
}

@(test)
ast_implicit_mixed_named_and_unnamed_comp_lit_bitset :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		My_Enum :: enum {A, B, C}
		My_Bitset :: bit_set[My_Enum]
		My_Struct_2 :: struct {
			bitset_1: My_Bitset,
			bitset_2: My_Bitset,
		}
		My_Struct :: struct {
			foo: My_Struct_2,
		}

		main :: proc() {
			inst := My_Struct {
				foo = {{.A}, {.{*}}, {.B} }
			}
		}
		`,
	}

	test.expect_completion_details(t, &source, ".", {"A", "B", "C"})
}

@(test)
ast_comp_lit_in_complit_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		My_Struct_2 :: struct {
			aaa: int,
			aab: int,
		}
		My_Struct :: struct {
			foo: My_Struct_2,
		}

		main :: proc() {
			inst := My_Struct {
				foo = {
					a{*}
				}
			}
		}
		`,
	}

	test.expect_completion_details(
		t,
		&source,
		"",
		{"My_Struct_2.aab: int", "My_Struct_2.aaa: int"},
	)
}

@(test)
ast_inlined_struct :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		My_Struct :: struct {
			foo: struct {
				a: int,
				b: int,
			},
		}

		main :: proc() {
			inst: My_Struct
			inst.foo.{*}
		}
		`,
	}

	test.expect_completion_details(
		t,
		&source,
		".",
		{"struct.a: int", "struct.b: int"},
	)
}

@(test)
ast_inlined_union :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main

		My_Struct :: struct {
			variant: union {int, f32},
		}

		main :: proc() {
			inst: My_Struct
			inst.{*}
		}
		`,
	}

	test.expect_completion_details(
		t,
		&source,
		".",
		{"My_Struct.variant: union"},
	)
}

@(test)
ast_union_identifier_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		My_Union :: union {
			int,
		}

		main :: proc() {
			a: My_{*}
		}
		`,
	}

	test.expect_completion_details(t, &source, ".", {"test.My_Union: union"})
}

@(test)
ast_union_poly :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		My_Union :: union($T: typeid) {T}

		main :: proc() {
			m: My_Union(int)
    		m.{*}
		}
		`,
	}

	test.expect_completion_labels(t, &source, ".", {"(int)"})
}

@(test)
ast_maybe_first_value :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		Maybe :: union($T: typeid) {T}

		main :: proc() {
			m: Maybe(int)
    		v, ok := m.?
			v{*}
		}
		`,
	}

	test.expect_completion_details(t, &source, "", {"test.v: int"})
}

@(test)
ast_maybe_second_value :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		main :: proc() {
			m: Maybe(int)
    		v, ok := m.?
			ok{*}
		}
		`,
	}

	test.expect_completion_details(t, &source, "", {"test.ok: bool"})
}

@(test)
ast_maybe_array :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		My_Union :: union($T: typeid) {T}

		main :: proc() {
			m: My_Union([5]u8)
    		m.{*}
		}
		`,
	}

	test.expect_completion_labels(t, &source, ".", {"([5]u8)"})
}


@(test)
ast_maybe_index_completion :: proc(t: ^testing.T) {
	packages := make([dynamic]test.Package)

	append(
		&packages,
		test.Package{
			pkg = "my_package",
			source = `package my_package
		Maybe :: union($T: typeid) {T}
		`,
		},
	)

	source := test.Source {
		main     = `package main
		import "my_package"
		main :: proc() {
			m: my_package.Maybe(int)
    		m.{*}
		}
		`,
		packages = packages[:],
	}

	test.expect_completion_labels(t, &source, ".", {"(my_package.int)"})
}

@(test)
ast_distinct_u32_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		f :: proc() {
			Distinct_Type :: distinct u32

			d: Distinct_Type
			d{*}
		}
		`,
	}

	test.expect_completion_details(t, &source, "", {"test.d: Distinct_Type"})
}

@(test)
ast_new_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		new :: proc($T: typeid) -> (^T, Allocator_Error) #optional_second {
		}

		main :: proc() {
			adzz := new(int);
			adzz{*}
		}

		`,
	}

	test.expect_completion_details(t, &source, "", {"test.adzz: int"})
}

@(test)
ast_new_clone_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		new_clone :: proc(data: $T) -> (^T, Allocator_Error) #optional_second {
		}

		Foo :: struct {}

		main :: proc() {
			adzz := new_clone(Foo{});
			adzz{*}
		}

		`,
	}

	test.expect_completion_details(t, &source, "", {"test.adzz: Foo"})
}

@(test)
ast_rawtr_cast_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		
		main :: proc() {
			raw: rawptr
			my_int := cast(int)raw;
			my_i{*}
		}

		`,
	}

	test.expect_completion_details(t, &source, "", {"test.my_int: int"})
}

ast_overload_with_procedure_return :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		import "my_package"	
	

		my_group :: proc {
			make_slice,
			make_map,
		}

		make_slice :: proc($T: typeid/[]$E, auto_cast len: int) -> (T, Allocator_Error) #optional_second {}
		make_map :: proc(a: int) -> int {}


		test_int :: proc() -> int {}
		main :: proc() {
			my_in := my_group([]int, test_int())
			my_in{*}
		}
		`,
	}

	test.expect_completion_details(t, &source, "", {"test.my_in: []int"})
}


@(test)
ast_index_proc_parameter_completion :: proc(t: ^testing.T) {
	packages := make([dynamic]test.Package)

	append(
		&packages,
		test.Package{
			pkg = "my_package",
			source = `package my_package
		My_Struct :: struct {
			a: int,
			b: int,
		}
		`,
		},
	)

	source := test.Source {
		main     = `package main
		import "my_package"
		f :: proc(param: my_package.My_Struct) {
			para{*}
		}
		`,
		packages = packages[:],
	}

	test.expect_completion_details(
		t,
		&source,
		".",
		{"my_package.param: My_Struct"},
	)
}

@(test)
ast_implicit_completion_in_enum_array_comp_lit :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		main :: proc() {
			foo :: enum{ one, two }
			bar := [foo]int{
			  .one = 1,
			  .{*}two = 2, 
			}
	    }
		`,
	}

	//TODO(Add proper completion support, but right now it's just to ensure no crashes)
	test.expect_completion_details(t, &source, ".", {})
}

@(test)
ast_implicit_enum_value_decl_type :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		Foo :: enum { Aa, Ab, Ac, Ad }
		main :: proc() {
			foo: Foo = .{*}
	    }
		`,
	}

	test.expect_completion_labels(t, &source, ".", {"Aa", "Ab", "Ac", "Ad"})
}

@(test)
ast_implicit_bitset_value_decl :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		Foo :: enum { Aa, Ab, Ac, Ad }
		Foo_Set :: bit_set[Foo]
		main :: proc() {
			foo_set := Foo_Set { .{*} }
	    }
		`,
	}

	test.expect_completion_labels(t, &source, ".", {"Aa", "Ab", "Ac", "Ad"})
}

@(test)
ast_implicit_bitset_add :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		Foo :: enum { Aa, Ab, Ac, Ad }
		Foo_Set :: bit_set[Foo]
		main :: proc() {
			foo_set: Foo_Set
			foo_set += .{*}
	    }
		`,
	}

	test.expect_completion_labels(t, &source, ".", {"Aa", "Ab", "Ac", "Ad"})
}

@(test)
ast_enum_complete :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		Foo :: enum { Aa, Ab, Ac, Ad }
		main :: proc() {
			foo := Foo.{*}
	    }
		`,
	}

	test.expect_completion_labels(t, &source, ".", {"Aa", "Ab", "Ac", "Ad"})
}


@(test)
ast_comp_lit_with_all_symbols_indexed_enum_implicit :: proc(t: ^testing.T) {
	packages := make([dynamic]test.Package)

	append(
		&packages,
		test.Package{
			pkg = "my_package",
			source = `package my_package
		Foo :: enum {
			ONE,
			TWO,
		}
		
		Bar :: struct {
			a: int,
			b: int,
			c: Foo,
		}
		`,
		},
	)

	source := test.Source {
		main     = `package main
		import "my_package"
		main :: proc() {
			a := my_package.Bar {
				c = .{*}
			}
	    }
		`,
		packages = packages[:],
	}

	test.expect_completion_details(t, &source, ".", {"TWO", "ONE"})
}

@(test)
ast_package_uppercase_test :: proc(t: ^testing.T) {
	packages := make([dynamic]test.Package)

	append(
		&packages,
		test.Package{
			pkg = "My_package",
			source = `package My_package
		Foo :: enum {
			ONE,
			TWO,
		}
		
		Bar :: struct {
			a: int,
			b: int,
			c: Foo,
		}
		`,
		},
	)

	source := test.Source {
		main     = `package main
		import "My_package"
		main :: proc() {
			My_package.{*}
	    }
		`,
		packages = packages[:],
	}

	test.expect_completion_details(
		t,
		&source,
		".",
		{"My_package.Foo: enum", "My_package.Bar: struct"},
	)
}


@(test)
ast_index_enum_infer :: proc(t: ^testing.T) {
	packages := make([dynamic]test.Package)

	append(
		&packages,
		test.Package{
			pkg = "My_package",
			source = `package My_package
		Foo :: enum {
			ONE,
			TWO,
		}
		`,
		},
	)

	source := test.Source {
		main     = `package main
		import "My_package"
		main :: proc() {
			my_enum: My_package.Foo

			if my_enum == {*}.
	    }
		`,
		packages = packages[:],
	}

	test.expect_completion_details(t, &source, ".", {"ONE", "TWO"})
}

@(test)
ast_index_builtin_ODIN_OS :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test	
		main :: proc() {
			when ODIN_OS == .{*}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(t, &source, ".", {"Darwin"})
}

@(test)
ast_for_in_range_half_completion_1 :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test
		main :: proc() {
			ints: []int
		
			for int_idx in 0..<len(ints) {
				ints[int_idx] = int_i{*}
			}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(t, &source, ".", {"test.int_idx: int"})
}

@(test)
ast_for_in_range_half_completion_2 :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test	
		advance_rune_n :: proc(t: ^Tokenizer, n: int) {
			for in 0..<n {
				advance_rune(n{*})
			}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(t, &source, ".", {"test.n: int"})
}

@(test)
ast_for_in_switch_type :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test	
		My_Foo :: struct {
			bar: int,
		}

		My_Struct :: struct {
			my: []My_Foo,
		}
		
		My_Union :: union {
			My_Struct,
		}
		
		main :: proc() {
			my_union: My_Union
			switch v in my_union {
			case My_Struct:
				for item in v.my {
					item.{*}
				}
			}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(t, &source, ".", {"My_Foo.bar: int"})
}

@(test)
ast_procedure_in_procedure_non_mutable_completion :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test	
		test :: proc() {
			Int :: int
			
			my_procedure_two :: proc() {
				b : In{*}
			}
		}
		`,
		packages = {},
	}

	test.expect_completion_details(t, &source, "", {"Int"})
}

@(test)
ast_switch_completion_for_maybe_enum :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package test	
			Maybe :: union($T: typeid) {T}

			My_Enum :: enum {
				One,
				Two,
			}
			main :: proc(a: Maybe(My_Enum)) {
				switch v in a {
					case My_Enum:
						switch v {
							case .{*}
						}
						
				}
			}
		`,
		packages = {},
	}

	test.expect_completion_details(t, &source, ".", {"One", "Two"})
}

@(test)
ast_union_with_type_from_different_package :: proc(t: ^testing.T) {
	packages := make([dynamic]test.Package)

	append(
		&packages,
		test.Package{
			pkg = "my_package",
			source = `package my_package	
			My_Int :: int
		`,
		},
	)

	source := test.Source {
		main     = `package main
		import "my_package"

		My_Union :: union { 
			bool, 
			my_package.My_Int,
		}

		main :: proc() {
			my_union: My_Union
			my_union.{*} 
		}
		`,
		packages = packages[:],
	}

	test.expect_completion_labels(t, &source, ".", {"(my_package.My_Int)"})
}

@(test)
ast_completion_union_with_typeid :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		Maybe :: union($T: typeid) {T}

		main :: proc() {
			my_maybe: Maybe(typeid)
			my_maybe.{*}
		}
		`,
	}

	test.expect_completion_labels(t, &source, ".", {"(typeid)"})
}

@(test)
ast_completion_with_pointer :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main

		main :: proc() {
			my_pointer: ^int
			my_p{*}
		}
		`,
	}

	test.expect_completion_details(t, &source, "", {"test.my_pointer: ^int"})
}


@(test)
ast_matrix_completion_index :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		main :: proc() {
			m := matrix[2, 3]f32 {
				1, 9, -13, 
				20, 5, -6, 
			}
		
			my_float := m[2, 3]
			my_f{*}
		}
		`,
	}

	test.expect_completion_details(t, &source, "", {"test.my_float: f32"})
}

@(test)
ast_matrix_with_matrix_mult :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main
		main :: proc() {
			a := matrix[2, 3]f32 {
				2, 3, 1, 
				4, 5, 0, 
			}
		
			b := matrix[3, 2]f32 {
				1, 2, 
				3, 4, 
				5, 6, 
			}

			my_matrix := a * b

			my_matri{*}		
		}
		`,
	}

	test.expect_completion_details(
		t,
		&source,
		"",
		{"test.my_matrix: matrix[2,2]f32"},
	)
}

@(test)
ast_vector_with_matrix_mult :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main

		My_Matrix :: matrix[2, 4]f32

		main :: proc() {
			m := My_Matrix{1, 2, 3, 4, 5, 5, 4, 2}
			v := [4]f32{1, 5, 4, 3}
		
			my_vector := m * v
	
			my_vecto{*}		
		}
		`,
	}

	test.expect_completion_details(t, &source, "", {"test.my_vector: [4]f32"})
}

@(test)
ast_completion_on_call_expr :: proc(t: ^testing.T) {
	source := test.Source {
		main = `package main		
		My_Struct :: struct {
			a: int,
			b: int,
		}

		my_function :: proc() -> My_Struct {}

		main :: proc() {
			my_function().{*}
		}
		`,
	}

	test.expect_completion_details(
		t,
		&source,
		".",
		{"My_Struct.a: int", "My_Struct.b: int"},
	)
}
