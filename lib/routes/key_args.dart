import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sunny_sdk_core/model_exports.dart';
//
//
// extension MSchemaRefKeyExtension on MSchemaRef {
//   KeyArgs<T> keyArgs<T>(String id, [T? record]) {
//     return KeyArgs.fromId(this, id, record: record);
//   }
// }
//
// // extension UserKeys on User {
// //   MKey get mkey {
// //     return refs.user.mkey(this.id);
// //   }
// //
// //   UserArg get userKeyArgs {
// //     return UserArg.ofUser(this);
// //   }
// // }
//
// class KeyArgs<R> with RouteParamsMixin {
//   final MKey? id;
//   final R? record;
//   final Map<String, dynamic> args;
//
//   KeyArgs(MKey this.id, {Map<String, dynamic>? args, this.record})
//       : args = {...?args, "id": id.mxid, "record": record};
//
//   KeyArgs.fromArgs(MSchemaRef ref, this.args)
//       : id = ref.mkey(args["id"] ?? illegalState("Missing id")),
//         record = args["record"] as R?;
//
//   factory KeyArgs.of(MSchemaRef ref, final dynamic args) {
//     if (args is KeyArgs<R>) return args;
//     if (args is Map<String, dynamic>) return KeyArgs.fromArgs(ref, args);
//     if (args is String) return KeyArgs.fromId(ref, args, args: {});
//     return illegalState("Can't extract keyArgs");
//   }
//
//   KeyArgs.fromId(MSchemaRef ref, String id,
//       {R? record, Map<String, dynamic>? args})
//       : this(ref.mkey(id)!, record: record, args: args);
//
//   operator [](key) {
//     if (key == "id") return id!.mxid;
//     if (key == "record") return record;
//     return args[key.toString()];
//   }
//
//   T? get<T>(key) {
//     if (key == "id") {
//       if (T == String) {
//         return id!.mxid as T;
//       } else {
//         return id as T?;
//       }
//     }
//
//     if (key == "record") return record as T?;
//     return args[key?.toString()] as T?;
//   }
//
//   @override
//   Map<String, dynamic> toMap() => args;
// }
//
// class IdArgs<R> with RouteParamsMixin {
//   final String? id;
//   final R? record;
//   final Map<String, dynamic> args;
//
//   IdArgs(this.id, {Map<String, dynamic>? args, this.record})
//       : args = {...?args, "id": id, "record": record};
//
//   IdArgs.fromArgs(this.args)
//       : id = (args["id"] as String?) ?? illegalState("Missing id"),
//         record = args["record"] as R?;
//
//   factory IdArgs.of(final dynamic args) {
//     if (args is IdArgs<R>) return args;
//     if (args is Map<String, dynamic>) return IdArgs.fromArgs(args);
//     if (args is String) return IdArgs.fromId(args, args: {});
//     return illegalState("Can't extract keyArgs");
//   }
//
//   IdArgs.fromId(String id, {R? record, Map<String, dynamic>? args})
//       : this(id, record: record, args: args);
//
//   operator [](key) {
//     if (key == "id") return id;
//     if (key == "record") return record;
//     return args[key.toString()];
//   }
//
//   T? get<T>(key) {
//     if (key == "id") {
//       if (T == String) {
//         return id as T?;
//       } else {
//         return id as T?;
//       }
//     }
//
//     if (key == "record") return record as T?;
//     return args[key?.toString()] as T?;
//   }
//
//   @override
//   Map<String, dynamic> toMap() => args;
// }

class AuthModalArgs with EquatableMixin {
  static final defaults = AuthModalArgs();
  final bool showLogo;
  final WidgetBuilder? topMessage;
  final WidgetBuilder? bottomWidget;

  final ScrollController? scroller;

  static AuthModalArgs of(final dyn) {
    if (dyn is AuthModalArgs) return dyn;
    if (dyn == null) return AuthModalArgs();
    return AuthModalArgs(showLogo: dyn["showLogo"] != false);
  }

  AuthModalArgs({
    this.showLogo = true,
    this.topMessage,
    this.bottomWidget,
    this.scroller,
  });

  /// Makes it easy to pass to builder arg
  static AuthModalArgs builder(ScrollController controller) {
    return AuthModalArgs(scroller: controller, showLogo: false);
  }

  @override
  List<Object> get props => [showLogo];

  @override
  bool get stringify => true;
}

//
// extension MModelIdArgsExt<X extends MModel> on X {
//   IdArgs<X> idArgs({String? id, Map<String, dynamic>? args}) =>
//       IdArgs(id ?? this.id, args: args, record: this);
// }
